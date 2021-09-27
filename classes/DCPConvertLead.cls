/* Class: DCPCovertLead
* Purpose: Convert Lead  to Acct, Cont, Oppty and create SSD
* Created: 06/14/2021
* Author: Kavya Ganagaraju
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 06/14/2021   Kavya G          DCP-1693    Created
* =============================================================================
*/

/**
 * @description DCPConvertLead
 */
public with sharing class DCPConvertLead {

    String supportEmail = '';

    DCPConvertLeadUtility dcpCLUtility = new DCPConvertLeadUtility(); 

    /****************************************************************
     * @description DCPConvertLead Constructor
     ****************************************************************/
    public DCPConvertLead(){
        supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
    }

    /**************************************************************************************
     * @description ConvertLeadInitiation Initiates the Lead Conversion Process
     * @param clwdt
     **************************************************************************************/
     public void convertLeadInitiation(DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails clwdt){


        if(clwdt.leadId != null && clwdt.cartId != null){
           
            try{  
               
                LIST<string> leadIds = new LIST<string>();
                LIST<string> cartIds = new LIST<string>();

                leadIds.add(clwdt.leadId);
                cartIds.add(clwdt.cartId);                                
                
                List<Lead> unConvertedLeadsList = new List<Lead>();

                /* UnConvertedLeadsList: gets the list of Leads that are not
                 converted based on the cartids passed.*/
                unConvertedLeadsList = dcpCLUtility.fetchLeadDetails(leadIds, cartIds);

                clwdt.leadToContractTermMap = 
                                dcpCLUtility.getLeadToContractTerm(unConvertedLeadsList);
                
                beforeConvertLead(unConvertedLeadsList, clwdt);

                               
            }catch(Exception e){
                system.debug(loggingLevel.INFO,'Error '+e);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead',
               +'expMsg'=>'Errors While Conversion of Lead'+string.valueOf(e),'webServiceName'=>
               +'convertLeadInitiation','requestType'=>'Lead Conversion',
               +'reqMsg'=>'Exception Class Name:DCPConvertlead',
               +'recId'=>clwdt.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
               DCPNewSaleUtilityCls.logException(errorHandlerMap);                
            }             
        }
        else{
            system.debug(loggingLevel.INFO,'convertion failed cartId or leadId is null ');
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead',
           +'expMsg'=>'Errors While Conversion of Lead convertion failed cartId or leadId is null',
           +'webServiceName'=>'convertLeadInitiation','requestType'=>'Lead Conversion',
           +'reqMsg'=>'Exception Class Name:DCPConvertlead',
           +'recId'=>clwdt.leadId,'supportEmail'=>supportEmail,
           +'toSupport'=>'true'};
            DCPNewSaleUtilityCls.logException(errorHandlerMap);       
        }
    }   

    /**************************************************************************************
     * @description beforeConvertLead does the preprocessing before converting a lead
     *                  Checks for existing Acc, Contact and if no matchs then created a 
     *              new Account, Contact, SSD records, to be used for lead conversion
     * @param toConvertLeadsList
     * @param clwdt
     **************************************************************************************/
    public void beforeConvertLead(list<Lead> toConvertLeadsList,
                        DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails clwdt){

        
        if(!toConvertLeadsList.isEmpty()){
           
            MAP<string, string> existngContactAndAcctmap = new MAP<string, string>();

            for(lead l: toConvertLeadsList){

                existngContactAndAcctmap = DCPCLUtility.mapContToAccDetails(l);
                DCPConvertLeadHelper dcpCLHelper = new DCPConvertLeadHelper();

                DCPConvertLeadUtility.ReferenceDetails accResult =
                                     dcpCLHelper.createNewAccount(l, existngContactAndAcctmap);
                
                 DCPConvertLeadUtility.ReferenceDetails conResult =
                    new DCPConvertLeadUtility.ReferenceDetails();

                conResult = accResult.convertedAccId != null?
                getContactForConversion(l,accResult,existngContactAndAcctmap): null;

                if (conResult.convertedConId == null){
                     createContactException(l, conResult);   
                 }
               
                
                ConvertLeadWrapper cwl = new ConvertLeadWrapper();            
                cwl.ssdRecw = accResult.ssdRec;
                cwl.conIdw = conResult.convertedConId;
                cwl.leadsw = toConvertLeadsList;
                cwl.refDetailsw = accResult;
                if(clwdt.LeadToContractTermMap!= null){
                    cwl.contractTerm = clwdt.LeadToContractTermMap.get(l.Id);
                }
                
                    convertLeadDataCheck(cwl);
            }                        

        }
    }

    /*************************************************************************************
    * @description convertLeadDataCheck Method to check if SSD and ont Records are present
    *                        and process Lead Conversion
    * @param cw
    *************************************************************************************/ 
    public void convertLeadDataCheck(ConvertLeadWrapper cw){                
                          
        List<Lead> leads = new List<Lead>();
        leads   = cw.leadsw;           
        if(cw.ssdRecw.id != null && cw.conIdw != null ){            
            perfomLeadConversion(cw);            
        }
        else{
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead',
                    +'expMsg'=>'convertion failed as your email or account is incorrect',
                    +'webServiceName'=>'beforeConvertLead','requestType'=>'Lead Conversion',
                    +'reqMsg'=>'Exception Class Name: DCPConvertlead',
                    +'recId'=>leads[0].Id,
                    +'supportEmail'=>supportEmail,'toSupport'=>'true'};
            DCPNewSaleUtilityCls.logException(errorHandlerMap);            
        }
    }

    /***************************************************************************************
    *  @description perfomLeadConversion-Main method to convert lead
    *  @param cw
    ***************************************************************************************/ 
    public void perfomLeadConversion(ConvertLeadWrapper  cw){ 
        
         Source_System_Detail__C ssdRec = new Source_System_Detail__C();
         DCPConvertLeadUtility.ReferenceDetails refDetails;
        
         
         string accName='';
         List<Lead> leads = new LIST<Lead>();
            
         ssdRec     = cw.ssdRecw;
         refDetails = cw.refDetailsw;                    
         accName    = ssdRec.name;

         leadConversionWrapper lcw =
                           new leadConversionWrapper();
        lcw.accID      = ssdRec.Account_Name__c;
        lcw.leads      = cw.leadsw; 
        lcw.conID      = cw.conIdw;
           
        DCPConvertLeadHelper.CreateOpptyWrap crOpWr = 
                            new DCPConvertLeadHelper.CreateOpptyWrap();

         crOpWr.accNamew = accName;
         crOpWr.accIDw   = lcw.accID;
         crOpWr.conIDw   = lcw.conId;
         crOpWr.accSsdw  = ssdrec.id;
         crOpWr.rdw      = refDetails;
         crOpWr.ssdRecw  = ssdRec;
         
        crOpWr.contractTerm = cw.contractTerm;
        lcw.oppID           = dcpCLUtility.createOppty(crOpWr);
         
            
        if(lcw.oppID!=null){
            LeadStatus cs = getLeadStatus();

            convertLead(lcw,cs);                                   
        }
        else  // no lead found or fail to create oppty
        {
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead',
                +'expMsg'=>'No Lead found or failure to create oppty',
                +'webServiceName'=>'convertLeadDataCheck',
                +'requestType'=>'Lead Conversion',
                +'reqMsg'=>'Exception Class Name: DCPonvertlead',
                +'recId'=>leads[0].Id,
                +'supportEmail'=>supportEmail,'toSupport'=>'true'};
                DCPNewSaleUtilityCls.logException(errorHandlerMap);                
            }                      
    }

    /****************************************************************
    * @description convertLead - performs the Lead Conversion
    * @param lcw
    * @param cs
    *****************************************************************/
    Private void convertLead(LeadConversionWrapper lcw, LeadStatus cs){

        Lead l = new Lead ();                                
            for(lead ll : lcw.leads){
                    l = ll;
                }
                               
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(l.id);                                
                lc.setConvertedStatus(cs.MasterLabel);
                if(lcw.accID !=null){
                    lc.setAccountId(lcw.accID);
                }                                                                      
                if(lcw.conId != null){
                    lc.setContactId(lcw.conID);
                }
                if(lcw.oppID != null){
                    lc.setOpportunityId(lcw.oppID);
                }
    
                Database.LeadConvertResult lcr;
                lcr = Database.convertLead(lc);

    }

    
    /****************************************************************
    * @description getLeadStatus
    * @return LeadStatus
    *****************************************************************/
    Private LeadStatus getLeadStatus(){

        LeadStatus cs;

        if (Schema.sObjectType.LeadStatus.isAccessible())
                {
                    cs = [Select Id, MasterLabel from LeadStatus
                           where IsConverted=true AND MasterLabel
                           LIKE 'Sales%' limit 1];                         
                }   

        return cs;

    }       


    /*****************************************************************************
     * @description getContactForConversion Method to check for existing contact before lead conversion
     * @param l
     * @param refDetails
     * @param existingAccDetails
     * @return DCPConvertLeadUtility.ReferenceDetails
     ****************************************************************************/

    private DCPConvertLeadUtility.ReferenceDetails getContactForConversion(Lead l,
                             DCPConvertLeadUtility.ReferenceDetails refDetails,
                                                     Map<String,String> existingAccDetails){

        DCPConvertLeadUtility.ReferenceDetails conResult = new DCPConvertLeadUtility.ReferenceDetails();

        if(!existingAccDetails.isEmpty()){
            conResult.convertedConId = (!existingAccDetails.keySet().isEmpty()) ? 
                                  new list<string>(existingAccDetails.keySet())[0] : '';   
        }else{
                conResult = dcpCLUtility.createNewContact(l, refDetails);
            }        
        
        return conResult;
    }

    /*********************************************************************************
    *  @description createContactException: Method to create the exception for contact.
    *  @param l
    *  @param conResult
    *********************************************************************************/
    
    private void createContactException(Lead l, DCPConvertLeadUtility.ReferenceDetails conResult){
          
        if(conResult.recordResult != null){
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead',
            +'expMsg'=>'Errors While Creation of Contact'
            + String.valueOf(conResult.recordResult.getErrors()),
            +'webServiceName'=>'dcpCLUtility.createNewContact','requestType'=>'Contact Creation',
            +'reqMsg'=>'Exception Class Name: DCPConvertlead',
            +'recId'=>l.Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            DCPNewSaleUtilityCls.logException(errorHandlerMap);            
        } 
    }

    /********************************************************************************************
     * @description leadConversionWrapper
     *********************************************************************************************/
    public class LeadConversionWrapper{
        public id accID;
        public id conId;
        public id oppId;
        public List<Lead> leads;
    }

    /**
    * @description  ConvertLeadWrapper
    */
    public class ConvertLeadWrapper{    
        public Source_System_Detail__C ssdRecw;
        public id conIdw;
        public List<Lead> leadsw;
        public decimal contractTerm;
        public DCPConvertLeadUtility.ReferenceDetails refDetailsw;
        /**
        * @description
        */       
        public ConvertLeadWrapper(){
            ssdRecw = new Source_System_Detail__C();
            leadsw = new List<Lead>();            
        }    
    }

}