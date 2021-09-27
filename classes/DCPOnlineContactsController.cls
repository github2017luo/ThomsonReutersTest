/********************************************************************************
Class Name : DCPOnlineContactsController 
@description : This code is used in online contacts manage
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                           Developer                 Description
27-07-2021                      Dinesh            DCP-3000 | Initial Creation
*********************************************************************************/ 
public without sharing class DCPOnlineContactsController {
    
    private static final string STR_PROPOSALID = 'proposalid';

     /**
    @description for retrieveOnlineContacts
    @param requestParams 
    @return returns for response
    */
    public static OLCResponseWrapper retrieveOnlineContacts(Map<String, String> requestParams){
        List<OnlineContactsToReturn> olcToReturnList = new List<OnlineContactsToReturn>();
        OLCResponseWrapper olcRes = new OLCResponseWrapper();
        if(requestParams == null || requestParams.isEmpty()){
            throw new DCCustomException('Request Parameters do not exist');
        }
        if(requestParams.containsKey(STR_PROPOSALID) && String.isNotBlank(requestParams.get(STR_PROPOSALID))){
        	String proposalId = requestParams.get(STR_PROPOSALID);
            Apttus_Proposal__Proposal__c proposal = [SELECT Id, Digital_Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id =: proposalId WITH SECURITY_ENFORCED];
            List<Online_Contacts__c> onlineCons = [SELECT Id, First_Name__c, Last_Name__c, Email__c, ContactID__c, Material__c FROM Online_Contacts__c WHERE QuoteId__c =: proposalId WITH SECURITY_ENFORCED];
            
            for(Online_Contacts__c olc: onlineCons){
                OnlineContactsToReturn olcToRet = new OnlineContactsToReturn();
                olcToRet.contactSFId = olc.Id;
                olcToRet.contactExternalId = olc.ContactID__c;
        		olcToRet.lastName = olc.Last_Name__c;
        		olcToRet.firstName = olc.First_Name__c;
        		olcToRet.email = olc.Email__c;
        		olcToRet.materialNumber = olc.Material__c;
                olcToReturnList.add(olcToRet);
            }
            
            olcRes.proposalId = proposal.Id;
            olcRes.proposalType = proposal.Digital_Quote_Type__c;
            olcRes.onlineContacts = olcToReturnList;
        }
        return olcRes;
    }
    
    
    /**
    * @description OLCRequest
    */        
    public class OLCResponseWrapper{
        public String proposalId;
        public String proposalType;
        public List<OnlineContactsToReturn> onlineContacts;
    }

    /**
    * @description OnlineContactsToReturn
    */  
    public class OnlineContactsToReturn {
        public String contactSFId;
        public String contactExternalId;
        public String lastName;
        public String firstName;
        public String email;
        public String materialNumber;
    }

}