/**
* @description
* Class: DCPCovertLead
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
public with sharing class DCPConvertLeadHelper {


    String supportEmail = '';
    /***************************************
     * @description Constructor
     *****************************************/
    public DCPConvertLeadHelper(){
        supportEmail = Static_Values__c.getValues('LeadSupportEmail').Value__c;
    }
   /****************************************************
     * @description
     ***************************************************/
    /*public class ConvertLeadWrapperDetails{
    
        public id leadId;
        public id cartId;
        public string emailId;  
        public id quoteId ; 
        public Map<string,decimal> leadToContractTermMap;
        public id trialID;//Added as part of DCP-4147
        public string trialStatus;//Added as part of DCP-4147
        public string reviewRequired;//Added as part of DCP-4147
        public string reviewRequiredNotes;//Added as part of DCP-4147
     }
*/
    /*************************************************
    * @description CreateOpptyWrap class
    **************************************************/
    public class CreateOpptyWrap{        
        public string accNamew ;
        public id accIDw ;
        public id conIDw ;
        public id accSsdw;
        public Lead lead;
        public DCPConvertLeadUtility.ReferenceDetails rdw ;
        public Source_System_Detail__C ssdRecw;
        public decimal contractTerm;
        /**
        * @description
        */
        public CreateOpptyWrap(){
                ssdRecw = new Source_System_Detail__C ();
                accNamew = '';
        }   
    }
    
    /**************************************************************
    * @description  CreateNewSsdWrap
    ***************************************************************/
    private class CreateNewSsdWrap{
        private lead lwr ;
        private Id oAccountw; 
        private string oAccountNamew;  
        private boolean shippingOnlyw;
       // private boolean reviewRequired; //Added by priyanka DCP-4231
        /**
        * @description
        */
        private CreateNewSsdWrap(){
           lwr = new Lead();
       }
   }

   /***************************************************************
     * @description createNewAccount: Create new Account, SSD records
     * @param l
     * @param existingContAcctmap
     * @return DCPConvertLeadUtility.ReferenceDetails
     **************************************************************/
    public  DCPConvertLeadUtility.ReferenceDetails createNewAccount(lead l,
                                            Map<String,String> existingContAcctmap){
        
        id accId;
        id conId;
        DCPConvertLeadUtility.ReferenceDetails refDetails =
                new DCPConvertLeadUtility.ReferenceDetails();
        Map<String, Source_System_Detail__c> sSDMap =
                        new  Map<String, Source_System_Detail__c>();

        for(string cid: existingContAcctmap.keyset()){
            accId = existingContAcctmap.get(cid);
            conId = cid;
        }

        try{
            if(existingContAcctmap.isEmpty()){

                Account oAccount           = new Account();
                oAccount.Name              = l.company; 
                oAccount.Email__c          = l.Email;
                oAccount.Phone             = l.Phone;
                oAccount.BillingCity       = l.Billing_City__c; 
                oAccount.BillingStreet     = l.Billing_Street__c;
                oAccount.BillingState      = l.Billing_State__c;
                oAccount.BillingCountry    = l.Billing_Country__c;
                oAccount.BillingPostalCode = l.Billing_Zip__c;
                oAccount.CurrencyIsoCode   = (l.Lead_Region__c==
                                              DCPConstants.UE_CAN_PRINT)? 
                                              DCPConstants.CAD_CURRENCYCODE :
                                              DCPConstants.USD_CURRENCYCODE;
                oAccount.Sales_Org__c = l.Sales_org__c;
               
                database.saveresult accSaveResults;
                accSaveResults = database.insert(oAccount,false);
                 
                accid = oAccount.id;

            }

            if(accId != null) {
                CreateNewSsdWrap cssdWrap = new CreateNewSsdWrap();
                cssdWrap.lwr           = l;
                cssdWrap.oAccountw     = accId;
                cssdWrap.oAccountNamew = l.company;
                cssdWrap.shippingOnlyw = false;
                //cssdWrap.reviewRequired = clwd.reviewRequired;   //added by priyanka DCP-4231               
                sSDMap = createNewSSD(cssdWrap);
            }else{
                
                Map<String,String> errorHandlerMap = new Map<String,String>{
                        'objectName'=>'Lead','expMsg'=>'Errors While Creation of Account',
                         +'webServiceName'=>'createNewAccount',
                         +'requestType'=>'Account Creation',
                         +'reqMsg'=>'Exception Class Name: DCPConvertlead',
                         +'recId'=>l.Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                DCPNewSaleUtilityCls.logException(errorHandlerMap);                
            }

            refDetails.convertedAccId = accId;
            if(!sSDMap.isEmpty()){
                refDetails.accountSSDId = sSDMap.get(DCPConstants.BILL_TO).Id;
                refDetails.ssdRec = sSDMap.get(DCPConstants.BILL_TO);
                }
            }       
            catch(Exception e){
                
                Map<String,String> errorHandlerMap = new Map<String,String>{
                    'objectName'=>'Lead','expMsg'=>'Errors While Creation of Account / SSD'
                         + e.getMessage(),'webServiceName'=>'createNewAccount',
                         +'requestType'=>'Account Creation',
                         +'reqMsg'=>'Exception Class Name: DCPConvertlead',
                         +'recId'=>l.Id,'supportEmail'=>supportEmail,'toSupport'=>'true'};
                DCPNewSaleUtilityCls.logException(errorHandlerMap);             
        }
        
        return refDetails;
    } 

     /*****************************************************
     * @description createNewSSD Created new SSD record
     * @param cnsw
     * @return Map<string,Source_System_Detail__c>
     ****************************************************/

    public Map<string,Source_System_Detail__c> createNewSSD(CreateNewSsdWrap cnsw){
        lead l = cnsw.lwr;
        Id oAccount = cnsw.oAccountw;
        String oAccountName = cnsw.oAccountNamew;
        Boolean shippingOnly = cnsw.shippingOnlyw;
        //Boolean reviewRequired = cnsw.reviewRequired; // Added by priyanka DCP-4231
    
        string ssdRecordType = Static_Values__c.getValues('SSDRecordType').value__c;  
        Map<String, Source_System_Detail__c> sSDMap = new  Map<String, Source_System_Detail__c>();  
        Id ssdrectype =
            Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(ssdRecordType).getRecordTypeId();
        LIST<Source_System_Detail__c> ssdList = new LIST<Source_System_Detail__c>();
            
        if(!shippingOnly){
            // This is for billing address SSD details.......
            Source_System_Detail__c ssd = new Source_System_Detail__c();        
            ssd.Name                        = oAccountName;
            ssd.Number_Street__c            = l.Billing_Street__c;
            ssd.LCRM_Street_2__c            = l.Billing_Street_2__c;
            ssd.City__c                     = l.Billing_City__c; 
            ssd.State__c                    = l.Billing_State__c; 
            ssd.Country__c                  = l.Billing_Country__c; 
            ssd.Postal_Code__c              = l.Billing_Zip__c; 
            ssd.Account_Name__c             = oAccount;
            ssd.RecordtypeId                = ssdrectype;
            ssd.Source_System_Name__c       = oAccountName;
            ssd.LCRM_Email__c               = l.Email;
            ssd.Company_Code__c             = DCPConstants.USL_SSD_COMPANY_CODE;
            ssd.CurrencyIsoCode             = (l.Lead_Region__c==DCPConstants.UE_CAN_PRINT)? 
                                                        DCPConstants.CAD_CURRENCYCODE :
                                                        DCPConstants.USD_CURRENCYCODE;
            ssd.LCRM_Sales_Org__c           = DCPConstants.SALESORG_WEST;
            ssd.LCRM_Sub_BU__c              = DCPConstants.BU_USL;
            ssd.LCRM_Industry__c            = DCPConstants.NA;
            ssd.LCRM_Country_Code__c        = DCPConstants.US;
            ssd.LCRM_Market_Segment__c      = l.Market_Segment__c;            
            ssd.LCRM_Phone__c               = l.Phone;
            /*ssd.Send_Digital_Orders_to_ZPND__c = reviewRequired; //Added by Priyanka DCP-4231
         // Mapping the fields as per DCP-3306 -Kavya S
            ssd.LCRM_Customer_Group__c = l.Customer_Group__c;
            ssd.LCRM_Customer_Type__c = l.Customer_Type__c ;
            ssd.LCRM_Industry__c = l.Market_Segment__c;*/
                        
            ssdList.add(ssd);            
            SSDMap.put(DCPConstants.BILL_TO,ssd);
        }
                     
        LIST<database.saveresult> ssdResult;
        ssdResult = database.insert(ssdList, false);
       
        if(!ssdList.isEmpty()){  
          return SSDMap;
        }else {
            return null;
        }    
    }
}