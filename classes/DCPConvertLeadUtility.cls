/**
* @description
* Class: DCPCovertLeadUtility
* Purpose: Utility class for DCPConvertLead.
* Created: 06/14/2021
* Author: Kavya Ganagaraju
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 06/14/2021   Kavya G          DCP-1693    Created
* =============================================================================
*/
public with sharing class DCPConvertLeadUtility {


    String supportEmail = '';
    /**********************************************************************
     * @description Constructor
     **********************************************************************/
    public DCPConvertLeadUtility(){
        supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
    }
    

    
    /*****************************************************************************
     * @description createNewContact: Method to create bew contact
     *               before lead conversion
     * @param l
     * @param refDetails
     * @return ReferenceDetails
     ****************************************************************************/

    public ReferenceDetails createNewContact(Lead l,
                                                     ReferenceDetails refDetails){
        
        contact oContact = new Contact();
    
        oContact.FirstName = l.firstName;
        oContact.LastName  = l.LastName;            
        oContact.Email     = l.Email;
        
        if( l.Phone != null ){
           oContact.Phone = l.Phone;                 
        }
        oContact.AccountId = refDetails.convertedAccId;
        
        database.saveresult conSaveRes = database.insert(oContact, false);

        if(conSaveRes.isSuccess()){
           refDetails.convertedConId = oContact.id;
        }else{
           System.debug(loggingLevel.INFO, 'New contact creation failed');
           refDetails.recordResult = conSaveRes;
           refDetails.errorObject = 'Contact'; 
        }                       
        return refDetails;
    }

    /************************************************************************
    *  @description createOppty: Method to create opportunity and map Account SSd.
    * @param copw
    * @return id 
    ************************************************************************/ 
   public id createOppty(DCPConvertLeadHelper.CreateOpptyWrap copw){  

        ReferenceDetails rd = new ReferenceDetails();
        Source_System_Detail__C ssdRec = new Source_System_Detail__C();
        
        string accName = copw.accNamew;
        id accID       = copw.accIDw;
        id conID       = copw.conIDw;
        id accSsd      = copw.accSsdw;
        rd             = copw.rdw;
        ssdRec         = copw.ssdRecw;
        //decimal contractTerm = copw.contractTerm;
        decimal contractTerm = 12.00; //Added by AD
        date systemDate = System.Today();
        date renewalDate = systemDate.addMonths(Integer.valueof(contractTerm));
     
                       
        string opportunityRecordTypeName = 'GLI_Pipeline_Opportunity';                
        if(Static_Values__c.getAll().containsKey('opportunityRecordTypeName')){ 
            opportunityRecordTypeName = Static_Values__c.getValues('opportunityRecordTypeName').Value__c ;  
        }   
                        
        Opportunity op = new Opportunity(); 
        op.name                      =accName;               
        op.AccountId                 =accID; 
        op.Key_Contact__c            =conID;    
        op.Source_System_Detail__c   =accSsd; 
        op.Bill_To_Account_SSD__c    = accSsd;
        op.StageName                 = DCPConstants.APP_SCHEDULED;   
        op.CloseDate                 =System.Today() + 30;   
        op.Reason__c                 = DCPConstants.DIGITAL;   
        op.Was_There_a_Competitor__c = 'No';    
        //op.Operating_Unit__c         = 'Print';
        op.Sales_org__c              = DCPConstants.SALESORG_WEST;       
        op.Is_GLI__c                 = True; 
        op.Is_Digital_New_Sales__c   = true;  
        op.Renewal_Date__c           = renewalDate;               
        
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(opportunityRecordTypeName).getRecordTypeId() != null){    
            op.RecordTypeId = 
            Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(opportunityRecordTypeName).getRecordTypeId();  
        } 
    
        if(rd != null && rd.accountShippingSSDId !=null ){  
            op.ShipTo_Source_System_Detail__c = rd.accountShippingSSDId;    
        }
    
        if(ssdRec.Source_System_Account_Number__c !=null && Schema.sObjectType.Account.isAccessible()){                      
              Account accrec = [Select id, Name, BU_Region__c, Bu_Segment__c From Account WHERE id =: accId ];                        
                op.LCRM_Sub_BU__c = accrec.BU_Region__c;
                op.BU_Segment__c = accrec.Bu_Segment__c;                                      
        }

        op = mapPricebookToOppty(op);        
        database.insert(op);
           
        return op.id;   
    }

    /****************************************************************************
    *  @description mapPricebookToOppty: Method to map Price book to opportunity.
    *  @param opp
    *  @return Opportunity
    *****************************************************************************/ 
    public Opportunity mapPricebookToOppty(Opportunity opp){
        String priceBookName = Static_Values__c.getValues('PriceBookName').Value__c; 
        if(!Schema.sObjectType.pricebook2.fields.name.isAccessible()){  
            return null;    
        }   
        List<pricebook2> priceBookList = new List<pricebook2>();
        if(Schema.sObjectType.pricebook2.isAccessible()){
            priceBookList  = [SELECT id FROM pricebook2 WHERE name =: priceBookName LIMIT 1];   
        }
        if(!priceBookList.isEmpty()){ 

            opp.Pricebook2Id= priceBookList[0].Id;                   
        } 
        return opp;
    }

    /******************************************************************************
     * @description getContractTerm: gets the contract term from Line Item associated 
     * to the cartid of the Lead being converted
     * @param le
     * @return Map<String,decimal>
     ****************************************************************************/

    public Map<String,decimal> getLeadToContractTerm(List<Lead> le){
        
        Lead lc = new Lead();
        Map<String,decimal> leadToContractTermMap = 
                        new Map<String, decimal>();

        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();

        if(!le.isEmpty()){

           lc = le[0]; 

            if (Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
                lineItem = [select APTS_Contract_Term_Number__c from Apttus_Config2__LineItem__c
                                where Apttus_Config2__ConfigurationId__c =: lc.Product_Configuration__c LIMIT 1];
            }
            leadToContractTermMap.put(lc.Id, LineItem.APTS_Contract_Term_Number__c);
        }   
        return leadToContractTermMap;

    }

    /****************************************************************
    * @description fetchLeadDetails: Method to fetch Lead Record Details.
    * @param leadIds
    * @param cartIds
    * @return List<Lead>
    *****************************************************************/
    public List<Lead> fetchLeadDetails(List<string> leadIds, List<string> cartIds){

        List<Lead> leadInfo = new List<Lead>();

        if(Schema.sObjectType.Lead.isAccessible()){
            leadInfo = [SELECT Id, Name,firstname,city,street,state,
                        Lead_Region__c,country,postalcode, lastname,
                        Email,phone, isconverted, convertedAccountid,
                        convertedcontactid,Product_Configuration__c,
                        convertedopportunityId,company,
                        Billing_Street__c, Billing_City__c,
                        Billing_State__c, Billing_Country__c,
                        Billing_Zip__c, Market_Segment__c, 
                        Billing_Street_2__c, Customer_Sub_Type__c,
                        Customer_Class__c,Customer_Group__c,Customer_Type__c,
                        Sales_Org__c
                        FROM Lead 
                        WHERE Id In: leadIds 
                                AND Product_Configuration__c in: cartIds
                                AND isconverted = false
                        ORDER BY createdDate DESC LIMIT 1] ;
        }

        return leadInfo;

    }

    /*****************************************************************
    * @description ReferenceDetails Class
    ******************************************************************/
    public class ReferenceDetails{            
        public id convertedAccId;
        public id convertedConId;
        public id convertedOppId;
        public id accountSSDId;    //Billing Address SSD Id
        public id contactSSDId;
        public string refDesc;
        public Source_system_Detail__c ssdRec;
        public id accountShippingSSDId;    //Shippig Address SSD Id
        public Source_system_Detail__c shippingSSDRec;
        public database.saveResult recordResult;
        public String errorObject;     
        /**
        * @description
        */
        public ReferenceDetails(){
            errorObject = '';
        }      
    }

    /****************************************************************************
     * @description mapContToAccDetails: Map of existing Contact to Account where
     *                      Contact.email = Lead.email and Account name=
     *                      lead.company
     * @param l
     * @return Map<String,String>
     ****************************************************************************/
    public MAP<string, string> mapContToAccDetails(Lead l){
        MAP<string, string> conDetails = new MAP<string, string>();
        
        if(l.Email != null && l.Company != null){
            conDetails = getContactAccMap(l.Email, l.Company );
        } 
       return conDetails;
    
    }

    /****************************************************************
     * @description getContactAccMap : gets conid and Accid Map
     * @param email
     * @param accName
     * @return MAP<String, String>
     ****************************************************************/
    private static MAP<string, string> getContactAccMap(string email, string accName){
        
        MAP<id, contact> contacts = new MAP<id, contact>([Select id, AccountId, Account.Name 
                                                          from contact WHERE email =: email AND 
                                                          Account.Name =: accName 
                                                          ORDER BY LastModifiedDate desc LIMIT 1]);
        MAP<string, string> details = new MAP<string, string>();
        
        if(!contacts.isEmpty()){
        
            contact c = new contact();
            c = contacts.values()[0];
            details.put(c.id, c.AccountId );  

        } 
        return details;
    }


}