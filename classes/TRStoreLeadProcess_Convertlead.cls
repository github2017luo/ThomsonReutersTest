/* Class: TRStoreLeadProcess_Convertlead
* Purpose: To convert the Lead for Transact on Place Order
* Created: 10/29/2020
* Author: Ameeta Antonio
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-10-29   Ameeta Antonio   DUE-6621    Lead Conversion 
* =============================================================================
*/

global with sharing class TRStoreLeadProcess_Convertlead{

    private List<String> ssdListToQuery = new List<String>();
    private Lead leadToCheck = new lead();
    private String leadOrigin ='';
    
/********************************************************************************************************
*  ConvertLeadWrapperDetails: Wrapper class for 'convertLead' method, to resolve PMD issues
*********************************************************************************************************/      
    public class ConvertLeadWrapperDetails{
    
    public id leadId;
    public id cartId;
    public string emailId;
    public string westAccNumber;    
    public id quoteId ; 
    
    public ConvertLeadWrapperDetails(){
        string avoidNull='';
    }    
 }
  
/********************************************************************************************************
*  ConvertLead: Method to Convert lead through webservice .
*  @input ConvertLeadWrapperDetails Record , @returns TRStore_LeadRequest.TRStoreResponse
*********************************************************************************************************/  
 public TRStore_LeadRequest.TRStoreResponse convertLead(ConvertLeadWrapperDetails clwdt){
               
        TRStore_LeadRequest.TRStoreResponse  resp = new TRStore_LeadRequest.TRStoreResponse();
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        System.debug(LoggingLevel.Info,'WESTACCNO:'+clwdt.westAccNumber+'leadId:'+clwdt.leadId+'cartId:'+clwdt.cartId+'emailId:'+clwdt.emailId);
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        
        if(clwdt.leadId != null&& clwdt.cartId!=null){
        
            System.debug(LoggingLevel.Info,'WESTACCNO:'+clwdt.westAccNumber+'leadId:'+clwdt.leadId+'cartId:'+clwdt.cartId+'emailId:'+clwdt.emailId);
            try{  
                system.debug(LoggingLevel.Info,'ConvertLead started');
                LIST<string> leadIds = new LIST<string>();
                LIST<string> cartIds = new LIST<string>();
                                
                leadIds.add(clwdt.leadId);
                cartIds.add(clwdt.cartId);
                List<Lead> leadsList = new List<Lead>();
                List<Lead> allLeadsList = new List<Lead>();
                allLeadsList = TRStoreLeadProcess_Createlead.queryLeadDetails(leadIds, cartIds, false);

                leadsList = mapUnconvertedLeadsListForConversion(allLeadsList);
                                
                system.debug(loggingLevel.INFO,'List of lead '+leadsList);
                
               // ********************************************
               resp = convertMainMethod1(leadsList, clwdt, resp);
                               
            }catch(Exception e){
                system.debug(loggingLevel.INFO,'Error '+e);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Conversion of Lead'+string.valueOf(e),'webServiceName'=>'convertLead','requestType'=>'Lead Conversion','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>clwdt.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);                
            }             
        }
        else{
            system.debug(loggingLevel.INFO,'convertion failed cartId or leadId is null ');
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Conversion of Lead convertion failed cartId or leadId is null','webServiceName'=>'convertLead','requestType'=>'Lead Conversion','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>clwdt.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);            
        }
        return resp;
    }   
        
    private Map<String,Source_System_Detail__C> sSDMap = new Map<String,Source_System_Detail__C> ();

/********************************************************************************************************
*  convertMainMethod1: Method to perform operations before lead conversion.Method moved from convertlead method to fix PMD.
*  @input ConvertLeadWrapperDetails Record,list of leads , @returns TRStore_LeadRequest.TRStoreResponse
*********************************************************************************************************/ 
    private TRStore_LeadRequest.TRStoreResponse convertMainMethod1(LIST<Lead> leadsList,  ConvertLeadWrapperDetails clwdt , TRStore_LeadRequest.TRStoreResponse resp){
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        
        if(!leadsList.isEmpty() || leadsList.size()>0){
                    clwdt.westAccNumber = mapAccSSDList(leadsList,clwdt.westAccNumber);
                    
                    system.debug(loggingLevel.INFO,'@@West Account Number:'+clwdt.westAccNumber);
                    if(clwdt.westAccNumber != null && String.isNotBlank(clwdt.westAccNumber))
                    {
                        LIST<Lead> leads = new LIST<Lead>();
                        List<Source_System_Detail__C> ssdList = new  List<Source_System_Detail__C>();
                        List<LCRM_Contact_SSD__c> contactsSSDList =new List<LCRM_Contact_SSD__c>();  
                        ReferenceDetails refDet = new ReferenceDetails();
                        
                        id conID;                       
                        string accName='';                      
                        String sapAccNo = clwdt.westAccNumber;
                        system.debug(loggingLevel.INFO,'SAP Account Number:'+sapAccNo);
                        ssdList = querySSDDDetails(ssdListToQuery); 
                        system.debug(loggingLevel.INFO,'SSD List:'+ssdList);
                        
                        mapSSDList(ssdList, refDet, clwdt); 
            
                        conID = queryContactSSDs(clwdt.emailId,ssdrec,leadToCheck);  
                        
                        ContactUpdateToRespWrap crwp = new ContactUpdateToRespWrap();
                        
                        crwp.conIdw =conID;
                        crwp.leadsListw =leadsList;
                        crwp.refDetw =refDet; 
                        crwp.respw =resp;
                        
                        resp = contactUpdateToResp(crwp);
                        
                    }
                    else{
                      system.debug(loggingLevel.INFO,'creation of Account started ');
                        //Call to create new account and new contact   
                        resp =  createNewAccContactonConvert(leadsList ,resp);                     
                    }                    
                }
                else{
                    system.debug(loggingLevel.INFO,'convertion failed. lead list is null ');
                    Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Convertion failed. lead list is null','webServiceName'=>'convertLead','requestType'=>'Lead Conversion','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>clwdt.leadId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                TRStore_ErrorHandler.logException(errorHandlerMap);                   
                }
                
                return resp;                 
    }
    
    private  Source_System_Detail__C  ssdrec = new Source_System_Detail__C();
    private ReferenceDetails mapSSDList(List<Source_System_Detail__C> ssdList, ReferenceDetails refDet, ConvertLeadWrapperDetails clwdt){
             
        if(ssdList!=null && ssdList.size()>0){
            for(Source_System_Detail__C ssd : ssdList){
                if(leadToCheck.SAPAccountNumber__c == ssd.Source_System_Account_Number__c){
                    ssdrec = ssd; 
                    refDet.accountSSDId = ssd.id;
                }
                if(leadToCheck.ShipToSSD_TRStore__c == ssd.Source_System_Account_Number__c){
                    refDet.accountShippingSSDId = ssd.id;
                }
            }
            
            if(String.isBlank(leadToCheck.ShipToSSD_TRStore__c) && String.isNotBlank(clwdt.WestAccNumber) && !ssdList.isEmpty()){
                CreateNewSsdWrap cssdWrap = new CreateNewSsdWrap();
                    cssdWrap.lwr = leadToCheck;
                    cssdWrap.oAccountw = ssdList[0].Account_Name__c;
                    cssdWrap.oAccountNamew = ssdList[0].Account_Name__r.Name;
                    cssdWrap.shippingOnlyw = true;
                
                sSDMap = createNewSSD(cssdWrap);
                refDet = populateRefDetails(refDet);
                    
            }
        }
        
        return refDet;
        
    }
    
    private ReferenceDetails populateRefDetails(ReferenceDetails refDet){
        if(!sSDMap.isEmpty()){
             if(sSDMap.get('ShipTo') != null){
                refDet.accountShippingSSDId = sSDMap.get('ShipTo').Id;
                refDet.shippingSSDRec = sSDMap.get('ShipTo');  
            }
        }
        
        return refDet;
        
    }
    
    private class ContactUpdateToRespWrap{
    
         id conIdw ;
         LIST<Lead> leadsListw ;
         ReferenceDetails refDetw ; 
         TRStore_LeadRequest.TRStoreResponse respw;
        
        public ContactUpdateToRespWrap(){
            
            leadsListw = new LIST<Lead>();
            refDetw = new ReferenceDetails();
            respw = new TRStore_LeadRequest.TRStoreResponse();
            
        }
        
    }
    
    private TRStore_LeadRequest.TRStoreResponse contactUpdateToResp(ContactUpdateToRespWrap  coutrw){
          
        id conId =  coutrw.conIdw ;
        LIST<Lead> leadsList = coutrw.leadsListw ;
        ReferenceDetails refDet = coutrw.refDetw ; 
        TRStore_LeadRequest.TRStoreResponse resp = coutrw.respw;
                
        if(conID != null){
            system.debug(LoggingLevel.Info,' conId  '+conID );
            
            ConvertLeadWrapper cwl = new ConvertLeadWrapper();
            
            cwl.ssdRecw = ssdrec;
            cwl.conIdw = conID;
            cwl.leadsw = leadsList;
            cwl.refDetailsw = refDet;
            
            resp = commonConvertLead(cwl);
        }
        
        return resp; 
    }
    
    private void createContactException(Lead l, ReferenceDetails conResult){
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;       
        if(conResult.recordResult != null){
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of Contact' + String.valueOf(conResult.recordResult.getErrors()),'webServiceName'=>'createNewContact','requestType'=>'Contact Creation','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>l.Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);            
        } 
    }

/********************************************************************************************************
*  createNewAccContactonConvert: Method to invoke creation of new Account and Contact for Guest user flow 
*  on lead Convert .
*  @input list of leads, TRStore_LeadRequest.TRStoreResponse , @returns TRStoreResponse
*********************************************************************************************************/  
    private TRStore_LeadRequest.TRStoreResponse createNewAccContactonConvert(List<lead> leadListInn, TRStore_LeadRequest.TRStoreResponse resp){
        
        ///id leadId =  TRStore_TransactMapAccount.fetchLeadDetails(leadListInn);
        MAP<string, string> existingAccDetails = new MAP<string, string>();
        
        for(lead l: leadListInn){
            system.debug(loggingLevel.INFO,'Lead Details.......'+l);
            existingAccDetails = TRStore_TransactMapAccount.mapAccountDetails(l);
            system.debug(loggingLevel.INFO,'existingAccDetails .......'+existingAccDetails);
           
            Savepoint sp1 = Database.setSavepoint();
            ReferenceDetails accResult = createNewAccount(l, existingAccDetails);
            system.debug(loggingLevel.INFO,'New Account Details->>'+accResult + 'ship ssd ID' +accResult.accountShippingSSDId);
            if (accResult.convertedAccId != null){
                system.debug(loggingLevel.INFO,'New Account Details->>'+accResult.convertedAccId);
                ReferenceDetails conResult = new ReferenceDetails();
                
                //conResult.convertedConId = (!existingAccDetails.isEmpty()) ? 
                
                if(!existingAccDetails.isEmpty()){
                    conResult.convertedConId = (!existingAccDetails.keySet().isEmpty()) ? new list<string>(existingAccDetails.keySet())[0] : '';   
                }else{
                    conResult = createNewContact(l, accResult);
                }
            
                system.debug(loggingLevel.INFO,'New Contact Details->>'+conResult );
                if (conResult.convertedConId == null){
                    Database.rollback(sp1);
                    createContactException(l, conResult);   
                }
                system.debug(loggingLevel.INFO,'refrences '+accResult+' and '+conResult);
                
                ConvertLeadWrapper cwl = new ConvertLeadWrapper();            
                cwl.ssdRecw = accResult.ssdRec;
                cwl.conIdw = conResult.convertedConId;
                cwl.leadsw = leadListInn;
                cwl.refDetailsw = accResult;
                
                resp = commonConvertLead(cwl);
            }                        
        }    
        return resp;
    }   
    //End of Lead Convert from Custom Service 

/********************************************************************************************************
*  mapAccSSDList : Method to map the SSD which need to be queried into a list.
*  @input list of leads,westAccNumber
*********************************************************************************************************/
    private String mapAccSSDList(List<Lead> leadsList,String westAccNumber){
        for(Lead le : leadsList){
                        if(le.SAPAccountNumber__c != null){
                            ssdListToQuery.add(le.SAPAccountNumber__c);
                            westAccNumber = String.isNotBlank(westAccNumber)?westAccNumber:le.SAPAccountNumber__c;
                        }
                        if(le.ShipToSSD_TRStore__c != null){
                            ssdListToQuery.add(le.ShipToSSD_TRStore__c);
                        }
                        leadToCheck = le;
        }
        return westAccNumber;
    }


/********************************************************************************************************
*  mapUnconvertedLeadsListForConversion : Method to map the leads which are not converted into a list.
*  @input list of leads, @returns list of unconverted leads.
*********************************************************************************************************/
    private List<Lead> mapUnconvertedLeadsListForConversion(List<Lead> allLeadsList){
        List<Lead> leadlist = new List<Lead>();
        if(!allLeadsList.isEmpty()){
            for(Lead lea:allLeadsList){
                leadOrigin=lea.Lead_Microsite__c;
                if(!lea.isconverted && (lea.Lead_Microsite__c=='TR Store' || lea.Lead_Microsite__c=='PWC' || lea.Lead_Microsite__c=='Deloitte')){ 
                    leadlist.add(lea); 
                }
            }
        }
        return leadlist;
    }
    
/********************************************************************************************************
*  commonConvertLead: Method to convert lead.Method moved from convertlead method to fix PMD.
*  @input ConvertLeadWrapper Record @returns TRStore_LeadRequest.TRStoreResponse
*********************************************************************************************************/   
    private TRStore_LeadRequest.TRStoreResponse commonConvertLead(ConvertLeadWrapper cw){                
        TRStore_LeadRequest.TRStoreResponse  resp = new TRStore_LeadRequest.TRStoreResponse();    
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;            
        
        /***********/        
        List<Lead> leads = new List<Lead>();
        leads   = cw.leadsw;        
        /**********************/       
        if(cw.ssdRecw.id != null && cw.conIdw != null ){            
            resp = commonConvertLeadSSDConIdNotnull(cw);            
        }
        else{
            resp.responseCode=TRStoreConstants.ERROR_CODE;
            resp.responseStatus='convertion failed as your email or account is incorrect.'; 
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'convertion failed as your email or account is incorrect','webServiceName'=>'commonConvertLead','requestType'=>'Lead Conversion','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>leads[0].Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);            
        }
        return resp;
    }

/********************************************************************************************************
*  ConvertLeadWrapper: Wrapper class for 'commonConvertLead' method, to resolve PMD issues
*********************************************************************************************************/ 
    private class ConvertLeadWrapper{    
        Source_System_Detail__C ssdRecw;
        id conIdw;
        List<Lead> leadsw;
        ReferenceDetails refDetailsw;
                
        public ConvertLeadWrapper(){
            ssdRecw = new Source_System_Detail__C();
            leadsw = new List<Lead>();            
        }    
    }

/********************************************************************************************************
*  commonConvertLeadSSDConIdNotnull: Method to convert lead.Method moved from convertlead method to fix PMD.
*  @input ConvertLeadWrapper Record @returns TRStore_LeadRequest.TRStoreResponse
*********************************************************************************************************/
    private TRStore_LeadRequest.TRStoreResponse commonConvertLeadSSDConIdNotnull(ConvertLeadWrapper  cw){

        /***************PMD Fix************/
         TRStore_LeadRequest.TRStoreResponse  resp = new TRStore_LeadRequest.TRStoreResponse();    
         String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;  
         Source_System_Detail__C ssdRec = new Source_System_Detail__C();
         id conId;
         id accID;   
         id oppID;
         string accName='';
         List<Lead> leads = new LIST<Lead>();
         ReferenceDetails refDetails;
            
         ssdRec = cw.ssdRecw;
         conID = cw.conIdw;
         leads =  cw.leadsw;
         refDetails = cw.refDetailsw;            

         accID = ssdRec.Account_Name__c;           
         accName=ssdRec.name;
           
         CreateOpptyWrap crOpWr = new CreateOpptyWrap();        
         crOpWr.accNamew = accName;
         crOpWr.accIDw = accID;
         crOpWr.conIDw = conId;
         crOpWr.accSsdw = ssdrec.id;
         crOpWr.rdw = refDetails;
         crOpWr.ssdRecw = ssdRec;
                                
         oppID =  createOppty(crOpWr);            
         if(ssdRec.Source_System_Account_Number__c !=null){
           database.update(new Opportunity(id=oppId, Has_SSD_Currency__c= false), false);
         }
            
            if(oppID!=null){
                LeadStatus cs;
                if (Schema.sObjectType.LeadStatus.isAccessible())
                {
                    cs = [Select Id, MasterLabel from LeadStatus where IsConverted=true AND MasterLabel LIKE 'Sales%' limit 1];                         
                }                    
                Lead l = new Lead ();                                
                for(lead ll : leads)
                {
                    l = ll;
                }
                               
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(l.id);                                
                lc.setConvertedStatus(cs.MasterLabel);
                if(accID !=null){
                    lc.setAccountId(accID);
                }                                                                      
                if(conId != null){
                    lc.setContactId(conID);
                }
                if(oppID != null){
                    lc.setOpportunityId(oppID);
                }
                                
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                //system.debug(LoggingLevel.Info,'Converted Lead Details.........'+lcr);
               /* 
                String priceBookName = Static_Values__c.getValues('PriceBookName').Value__c;    
                
                if(!Schema.sObjectType.pricebook2.fields.name.isAccessible()){  
                    return null;    
                }   
                List<pricebook2> priceBookList = new List<pricebook2>();
                if(Schema.sObjectType.pricebook2.isAccessible()){
                    priceBookList  = [SELECT id FROM pricebook2 WHERE name =: priceBookName LIMIT 1];   
                }
                
                List<Opportunity> oppty = new List<Opportunity>();
                if(Schema.sObjectType.Opportunity.isAccessible()){
                    oppty = [select pricebook2id from Opportunity where Id =: oppID];
                }
                
                if(priceBookList!=null && priceBookList.size() > 0 ) {   
                    for(pricebook2 pb : priceBookList){ 
                        oppty[0].Pricebook2Id=pb.id;  
                    }   
                } 
                database.update(new Opportunity(id=oppId, pricebook2id = oppty[0].pricebook2id), false);
                */
                List<Opportunity> oppty = new List<Opportunity>();
                if(Schema.sObjectType.Opportunity.isAccessible()){
                    oppty = [select pricebook2id from Opportunity where Id =: oppID];
                }
                oppty[0] = mapPricebookToOppty(oppty[0]);
                database.update(new Opportunity(id=oppId, pricebook2id = oppty[0].pricebook2id), false);
                resp = mapResponseForleadConvert(lcr,supportEmail);                                           
            }
            else  // no lead found or fail to create oppty
            {
                resp.responseCode=TRStoreConstants.ERROR_CODE;
                resp.responseStatus='No Lead found or fail to create oppty';
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'No Lead found or failure to create oppty','webServiceName'=>'commonConvertLeadSSDConIdNotnull','requestType'=>'Lead Conversion','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>leads[0].Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              TRStore_ErrorHandler.logException(errorHandlerMap);                
            }            
          return resp;              
  }           

/********************************************************************************************************
*  mapResponseForleadConvert: Method to map the response for the lead conversion service.
*  @input Database.LeadConvertResult record, String email , @returns TRStore_LeadRequest.TRStoreResponse
*********************************************************************************************************/
    private TRStore_LeadRequest.TRStoreResponse mapResponseForleadConvert(Database.LeadConvertResult lcr,String supEmail){
    TRStore_LeadRequest.TRStoreResponse  resp = new TRStore_LeadRequest.TRStoreResponse();
        if(lcr.isSuccess()){
      resp.convertedAccID=lcr.getAccountId();
            resp.convertedOppID= lcr.getOpportunityId();
            resp.convertedConID= lcr.getContactId();
            resp.responseCode=TRStoreConstants.SUCCESS_CODE;
            resp.responseStatus='converted successfully';                    
        }
        else{ // conversion fail
      resp.responseCode=TRStoreConstants.ERROR_CODE;
            resp.responseStatus='convertion failed';
            String dbErrors = null;
            for(Database.Error de: lcr.getErrors()){
              if( de != null){
                  dbErrors = dbErrors + de; 
                }  
            }
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Conversion of Lead convertion:'+dbErrors,'webServiceName'=>'convertLead','requestType'=>'Lead Conversion','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>lcr.leadId,'supportEmail'=>supEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);            
        }
        return resp;
    }

/********************************************************************************************************
*  CreateOpptyWrap: Wrapper class for 'createOppty' method, to resolve PMD issues
*********************************************************************************************************/
    private class CreateOpptyWrap{        
        string accNamew ;
        id accIDw ;
        id conIDw ;
        id accSsdw;
        ReferenceDetails rdw ;
        Source_System_Detail__C ssdRecw;
        
        public CreateOpptyWrap(){
                ssdRecw = new Source_System_Detail__C ();
                accNamew = '';
        }   
    }

/********************************************************************************************************
*  createOppty: Method to create opportunity and map Account SSd.
*  @input CreateOpptyWrap record , @returns Opportunity ID 
*********************************************************************************************************/
   private id createOppty(CreateOpptyWrap cow){  
        string accName = cow.accNamew;
        id accID = cow.accIDw;
        id conID = cow.conIDw;
        id accSsd = cow.accSsdw;
        ReferenceDetails rd = new ReferenceDetails();
        rd = cow.rdw;
        Source_System_Detail__C ssdRec = new Source_System_Detail__C();
        ssdRec = cow.ssdRecw;
   
        system.debug(loggingLevel.INFO,'opp details'+accName +' '+ accID+' '+conID+' '+accSsD); 
                       
        string opportunityRecordTypeName = 'GLI_Pipeline_Opportunity';                
        if(Static_Values__c.getAll().containsKey('opportunityRecordTypeName')){ 
            opportunityRecordTypeName = Static_Values__c.getValues('opportunityRecordTypeName').Value__c ;  
        }   
                        
        Opportunity op = new Opportunity(); 
        op.name=accName;               
        op.AccountId=accID; 
        op.Key_Contact__c=conID;    
        op.Source_System_Detail__c=accSsd; 
        op.Bill_To_Account_SSD__c = accSsd;
        op.StageName='Appointment Scheduled';   
        op.CloseDate=System.Today() + 30;   
        op.Reason__c = 'Digital';   
        op.Was_There_a_Competitor__c = 'No';    
        op.Operating_Unit__c = 'Print';       
        op.Is_GLI__c = True;              
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(opportunityRecordTypeName).getRecordTypeId() != null){    
            op.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(opportunityRecordTypeName).getRecordTypeId();  
        }       
        if(rd != null){ 
            if(rd.accountShippingSSDId !=null){ 
                op.ShipTo_Source_System_Detail__c = rd.accountShippingSSDId;    
            }   
        }               
        if(ssdRec.Source_System_Account_Number__c !=null && Schema.sObjectType.Account.isAccessible()){  
            try{                      
              Account accrec = [Select id, Name, BU_Region__c, Bu_Segment__c From Account WHERE id =: accId ];                        
                op.LCRM_Sub_BU__c = updatenotNull(accrec.BU_Region__c);
                op.BU_Segment__c = updatenotNull(accrec.Bu_Segment__c );                                      
            }catch(exception e){
                system.debug(loggingLevel.INFO,'TRStore Exception >>'+e);
            }      
        }   
        op = mapPricebookToOppty(op);        
        database.insert(op);    
            
        system.debug(LoggingLevel.Info,'Hello Opportunity...'+op);   
            
        return op.id;   
    }
    
    private static string updatenotNull(string val){
        if(val != null){    
            return val;  
        }   
        return null;
    }

/********************************************************************************************************
*  mapPricebookToOppty: Method to map Price book to opportunity.
*  @input Opportunity  @returns Opportunity
*********************************************************************************************************/     
    private Opportunity mapPricebookToOppty(Opportunity opp){
        String priceBookName = Static_Values__c.getValues('PriceBookName').Value__c; 
        if(!Schema.sObjectType.pricebook2.fields.name.isAccessible()){  
            return null;    
        }   
        List<pricebook2> priceBookList = new List<pricebook2>();
        if(Schema.sObjectType.pricebook2.isAccessible()){
            priceBookList  = [SELECT id FROM pricebook2 WHERE name =: priceBookName LIMIT 1];   
        }
        if(priceBookList!=null && priceBookList.size() > 0 ){   
            for(pricebook2 pb : priceBookList){ 
                opp.Pricebook2Id=pb.id;  
            }                  
        } 
        return opp;
    }
        
/********************************************************************************************************
*  queryLeadDetails: Common Method to query lead details based on email ID and cart ID
*  @input email ID, cart ID, boolean:isCreated, @returns List of Lead 
*********************************************************************************************************/     
   /* private static List<Lead> queryLeadDetails(List<string> emailIdList, List<string> cartList,boolean isCreated){
        List<Lead> leadInfo= new List<Lead>();
        Set<String> microSitesSet = new set<String>();
      
        Schema.DescribeFieldResult fieldResult = lead.Lead_Microsite__c.getDescribe();
              
        for(Schema.PicklistEntry s:fieldResult.getPicklistValues()){
            if(s.getValue()!='TR Store')
            {
                microSitesSet.add(s.getValue());
                System.debug(loggingLevel.INFO,'value: '+s.getValue());
            }
          
        }
         
        system.debug('TRStore cart List....'+cartList);
         
        if(isCreated && Schema.sObjectType.Lead.isAccessible()){
            leadInfo = [SELECT Id, Name,firstname,city,street,state ,country, postalcode, Lead_Region__c, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c,Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c from
                            Lead WHERE ( Email In: emailIdList OR Product_Configuration__c IN: cartList) and Lead_Microsite__c Not IN : microSitesSet ];
            
        }else if(Schema.sObjectType.Lead.isAccessible()){  
                system.debug(loggingLevel.INFO,'lead id from PE'+emailIdList);
                leadInfo = [SELECT Id, Name,firstname,city,street,state ,Lead_Region__c,country,postalcode, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c,TRStore_Existing_Customer__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c, Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c 
                                FROM Lead WHERE Id In: emailIdList AND Product_Configuration__c IN: cartList] ;
            
        }
        
        system.debug(LoggingLevel.Info,'leadInfo'+leadInfo);
        return leadInfo;
        
    }*/
    
    /********************************************************************************************************
*  querySSDDDetails: Common Method to query Account SSD details
*  @input SAP Account Number, @returns List of SSD
*  As Part of  DLT-15904 
*********************************************************************************************************/   
    private static List<Source_System_Detail__C> querySSDDDetails(List<String> sapAcc) {
        
        List<Source_System_Detail__C> ssdList = new  List<Source_System_Detail__C>([Select id , name  ,Account_Name__c,Source_System_Account_Number__c ,Account_Name__r.name, Billing_Currency__c from Source_System_Detail__C where Source_System_Account_Number__c IN:sapAcc limit 1 ]);
        system.debug(LoggingLevel.Info,'ssdList'+ssdList);
        return  ssdList;
    }
    
    /********************************************************************************************************
*  queryContactSSDs: Method to query Contact SSD details
*  @input contact email, @returns contact Id
*  As Part of  DLT-15904 
*********************************************************************************************************/
    private static id queryContactSSDs(string conEmail, Source_System_Detail__c ssd, Lead leadrec){
        system.debug(LoggingLevel.Info,'conEmail...........'+ conEmail);

        List<Contact> contactList = new  List<Contact>([Select id , name, Email,AccountId FROM Contact WHERE Email =: conEmail AND AccountId =: ssd.Account_Name__c limit 1]);
        system.debug(LoggingLevel.Info,'ContactList...........'+ contactList);
        
        id conId;
        
        if(!contactList.isEmpty()){
            for(Contact cont : contactList){          
                conID = cont.id ;
                system.debug(LoggingLevel.Info,'conid'+conID);         
            }
        }else{
            
            ReferenceDetails accDetails = new ReferenceDetails();
            accDetails.convertedAccId = ssd.Account_Name__c;
            ReferenceDetails conDetails = createNewContact(leadrec, accDetails);
            conId = conDetails.convertedConId;
        }
        
        return conId;       
    }
     
/********************************************************************************************************
*  createNewAccount: Method to create new Account for Guest user flow on lead Convert .
*  @input lead , @returns ReferenceDetails
*********************************************************************************************************/    
    private ReferenceDetails createNewAccount(lead l, MAP<string, string> conAccMap){
        
        ReferenceDetails refDetails = new ReferenceDetails();
        system.debug('Hello World..........'+conAccMap);
        Map<String, Source_System_Detail__c> sSDMap = new  Map<String, Source_System_Detail__c>();
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        database.saveresult accSaveRes;  
        id accIdLocal;
        id conIdLocal;
        id accSSDIdLocal;
        id conSSDIdLocal;
        
        system.debug('supportEmail ..........'+supportEmail );
        for(string cid: conAccMap.keySet()){
            accIdLocal = conAccMap.get(cid);
            conIdLocal = cid;
        }
        system.debug('Acc and Con id..........'+accIdLocal +'       '+conIdLocal );
        
        try{
            if(conAccMap.isEmpty()){
                
                Account oAccount = new Account();
                oAccount.Name = l.company; 
                oAccount.Email__c = l.Email;
                oAccount.Phone = l.Phone;
                oAccount.BillingCity = l.Billing_City__c; 
                oAccount.BillingStreet = l.Billing_Street__c;
                oAccount.BillingState = l.Billing_State__c;
                oAccount.BillingCountry = l.Billing_Country__c;
                oAccount.BillingPostalCode = l.Billing_Zip__c;
                oAccount.CurrencyIsoCode = (l.Lead_Region__c=='UE Store Canada PRINT')? 'CAD' : 'USD' ;
                accSaveRes = database.insert(oAccount, false);
                
                system.debug(loggingLevel.INFO, 'error in acc creation' +accSaveRes.errors + oAccount);
                
                accIdLocal = oAccount.id;
                
            }   
                
            if(accIdLocal != null) {
                CreateNewSsdWrap cssdWrap = new CreateNewSsdWrap();
                cssdWrap.lwr = l;
                cssdWrap.oAccountw = accIdLocal;
                cssdWrap.oAccountNamew = l.company;
                cssdWrap.shippingOnlyw = false;
                    
                sSDMap = createNewSSD(cssdWrap);
            }else{
                System.debug(loggingLevel.INFO, 'Create New Account failed >>>'+String.valueOf(accSaveRes.getErrors()));
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of Account' + String.valueOf(accSaveRes.getErrors()),'webServiceName'=>'createNewAccount','requestType'=>'Account Creation','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>l.Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              TRStore_ErrorHandler.logException(errorHandlerMap);                
            }
            
            refDetails.convertedAccId = accIdLocal;
            if(!sSDMap.isEmpty()){
                refDetails.accountSSDId = sSDMap.get('BillTo').Id;
                refDetails.ssdRec = sSDMap.get('BillTo');
                if(l.TRstore_Billadd_differenceto_shipping__c && sSDMap.containsKey('ShipTo')){
                    refDetails.accountShippingSSDId = sSDMap.get('ShipTo').Id;
                    refDetails.shippingSSDRec = sSDMap.get('ShipTo');  
                }
            }            
        }
        catch(Exception e){
            system.debug(LoggingLevel.INFO,'Errors While Creation of Account / SSD' +e.getMessage());
            Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Lead','expMsg'=>'Errors While Creation of Account / SSD' + e.getMessage(),'webServiceName'=>'createNewAccount','requestType'=>'Account Creation','reqMsg'=>'Exception Class Name: TRStoreLeadProcess_Convertlead','module'=>'UEStore','recId'=>l.Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
            TRStore_ErrorHandler.logException(errorHandlerMap);             
        }
        
        return refDetails;
    }

/********************************************************************************************************
*  validatePhoneNumber: Method to validate if length of phone number entered is less than 16 digits
*  @input String phno @returns String
*********************************************************************************************************/    
    private static string validatePhoneNumber(string phno){
        
         if(phno != null) {                 
                //check the size of phone field 
                if(phno.length()<= 16){
                    return phno;
                }else{
                    // Replace all special characters with null and check the size, 
                    // if less than 16 assign the same otherwise get first 16 characters 
                    string newPhone = phno.replaceAll('[^a-zA-Z0-9\\s+]', '');
                    newPhone = phoneMoreThan16(newPhone);
                }
          }
          return null;
      }

/********************************************************************************************************
*  phoneMoreThan16: Method to validate phone number 
*  @input String phno @returns String
*********************************************************************************************************/
    private static string phoneMoreThan16(string newPhone){
        if(newPhone != null){
            if(newPhone.length() <= 16 ){
                return newPhone;
            }else{
                return newPhone.subString(0,16);
            }
        } else{
            return null;
        } 
    }

/********************************************************************************************************
*  CreateNewSsdWrap: Wrapper class for 'createNewSSD' method, to resolve PMD issues
*********************************************************************************************************/    
    private class CreateNewSsdWrap{
         lead lwr ;
         Id oAccountw; 
         string oAccountNamew;  
         boolean shippingOnlyw;
        
        public CreateNewSsdWrap(){
            lwr = new Lead();
        }
    }
    
/********************************************************************************************************
*  createNewSSD: Method to create billing SSD for guest user flow.
*  @input CreateNewSsdWrap record, @returns Map of created SSD
*********************************************************************************************************/      
    private Map<string,Source_System_Detail__c> createNewSSD(CreateNewSsdWrap cnsw){
        lead l = cnsw.lwr;
        Id oAccount = cnsw.oAccountw;
        String oAccountName = cnsw.oAccountNamew;
        Boolean shippingOnly = cnsw.shippingOnlyw;
    
        string ssdRecordType = Static_Values__c.getValues('SSDRecordType').value__c;  
        Map<String, Source_System_Detail__c> sSDMap = new  Map<String, Source_System_Detail__c>();  
        Id ssdrectype= Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(ssdRecordType).getRecordTypeId();
        LIST<Source_System_Detail__c> ssdList = new LIST<Source_System_Detail__c>();
            
        if(!shippingOnly){
            // This is for billing address SSD details.......
            Source_System_Detail__c ssd = new Source_System_Detail__c();        
            ssd.Name= oAccountName;
            ssd.Number_Street__c = l.Billing_Street__c;
            ssd.LCRM_Street_2__c = l.Billing_Street_2__c;
            ssd.City__c = l.Billing_City__c; 
            ssd.State__c = l.Billing_State__c; 
            ssd.Country__c = l.Billing_Country__c; 
            ssd.Postal_Code__c =l.Billing_Zip__c; 
            ssd.Account_Name__c= oAccount;
            ssd.RecordtypeId=ssdrectype;
            ssd.Source_System_Name__c=oAccountName;
            ssd.LCRM_Email__c= l.Email;
            ssd.CurrencyIsoCode = (l.Lead_Region__c=='UE Store Canada PRINT')? 'CAD' : 'USD' ;
            ssd.LCRM_Sales_Org__c = (l.Lead_Region__c=='UE Store Canada PRINT')? 'CARS' : 'WEST';
            ssd.LCRM_Sub_BU__c =(l.Lead_Region__c=='UE Store Canada PRINT')? 'Canada' : 'USL';
            ssd.LCRM_Industry__c='NOT APPLICABLE';
            ssd.LCRM_Country_Code__c = (l.Lead_Region__c=='UE Store Canada PRINT') ? 'CA' : 'US';
            ssd.LCRM_Distribution_Channel__c = 'WEST GROUP';
            ssd.LCRM_Market_Segment__c = l.Market_Segment__c;            
            ssd.LCRM_Phone__c = validatePhoneNumber(l.Phone);
                        
            ssdList.add(ssd);            
            SSDMap.put('BillTo',ssd);
        }
                     
        // This is for shipping address SSD details.......
        if(shippingOnly || l.TRstore_Billadd_differenceto_shipping__c){
            Source_System_Detail__c ssdShipping = mapShippingSSD(l,cnsw,ssdrectype);                
                
            ssdList.add(ssdShipping);
            SSDMap.put('ShipTo',ssdShipping);                
        }
        LIST<database.saveresult> ssdResult = database.insert(ssdList, false);
        system.debug(loggingLevel.INFO,'result of acc insert'+ssdResult);
        if(!ssdList.isEmpty()){  
          return SSDMap;
        }else {
            return null;
        }    
    }

/********************************************************************************************************
*  mapShippingSSD: Method to create shipping SSD for guest user flow.
*  @input Lead,CreateNewSsdWrap record,recordType @returns Source_System_Detail__c record
*********************************************************************************************************/
    private Source_System_Detail__c mapShippingSSD(Lead l,CreateNewSsdWrap cnsw, String ssdrectype){
        Source_System_Detail__c ssdShipping = new Source_System_Detail__c();
        ssdShipping.Name= cnsw.oAccountNamew;
    ssdShipping.Number_Street__c = l.Street;
    ssdShipping.LCRM_Street_2__c = l.Shipping_Street_2__c;
    ssdShipping.City__c = l.City; 
    ssdShipping.State__c = l.State; 
    ssdShipping.Country__c = l.Country; 
    ssdShipping.Postal_Code__c =l.PostalCode; 
    ssdShipping.Account_Name__c= cnsw.oAccountw;
    ssdShipping.RecordtypeId=ssdrectype;
    ssdShipping.Source_System_Name__c=cnsw.oAccountNamew;
    ssdShipping.LCRM_Email__c= l.Email;
    ssdShipping.CurrencyIsoCode = (l.Lead_Region__c=='UE Store Canada PRINT')? 'CAD' : 'USD' ;
    ssdShipping.LCRM_Sales_Org__c = (l.Lead_Region__c=='UE Store Canada PRINT')? 'CARS' : 'WEST';
    ssdShipping.LCRM_Sub_BU__c = (l.Lead_Region__c=='UE Store Canada PRINT') ? 'Canada' : 'USL';
    ssdShipping.LCRM_Industry__c='NOT APPLICABLE';
    ssdShipping.LCRM_Country_Code__c= (l.Lead_Region__c=='UE Store Canada PRINT') ? 'CA' : 'US';
    ssdShipping.LCRM_Distribution_Channel__c = 'WEST GROUP'; 
    ssdShipping.LCRM_Market_Segment__c = l.Market_Segment__c;
    ssdShipping.LCRM_Phone__c = validatePhoneNumber(l.Shipping_Phone__c);

    return ssdShipping;  
    }

/********************************************************************************************************
*  createNewContact: Method to create new contact before lead gets converted.
*  @input lead,ReferenceDetails @returns ReferenceDetails
*********************************************************************************************************/    
    private static ReferenceDetails createNewContact(Lead l, ReferenceDetails refDetails){
        
        contact oContact = new Contact();
        String supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
        system.debug(loggingLevel.INFO,'+++ Within newContactDetails else check '+ refDetails.convertedAccId );
        
        if(l.Shipping_FirstName__c != null && l.Shipping_LastName__c != null){
            oContact.FirstName = l.Shipping_FirstName__c;
            oContact.LastName = l.Shipping_LastName__c;
        }else{
            oContact.FirstName = l.firstName;
            oContact.LastName = l.LastName;
        }                
        oContact.Email = l.Email;
        
        if( l.Phone != null ){
          oContact.Work_Direct__c = validatePhoneNumber(l.Phone);
          oContact.Phone = oContact.Work_Direct__c;                 
        }
        oContact.AccountId = refDetails.convertedAccId; //Set whatever Account Id that has been selected
        
        database.saveresult conSaveRes = database.insert(oContact, false);
        System.debug(loggingLevel.INFO, 'New contact creation '+conSaveRes);

        if(conSaveRes.isSuccess()){
           refDetails.convertedConId = oContact.id;
        }else{
           System.debug(loggingLevel.INFO, 'New contact creation failed');
           refDetails.recordResult = conSaveRes;
           refDetails.errorObject = 'Contact'; 
        }                       
        return refDetails;
    }
       
    global class ReferenceDetails{
        
        public id convertedAccId;
        public id convertedConId;
        public id convertedOppId;
        public id   accountSSDId;    //Billing Address SSD Id
        public id   contactSSDId;
        string refDesc;
        public Source_system_Detail__c ssdRec;
        public id accountShippingSSDId;    //Shippig Address SSD Id
        public Source_system_Detail__c shippingSSDRec;
        database.saveResult recordResult;
        String errorObject;     
        
        global ReferenceDetails(){
            errorObject='';
        }          
    }
           
}