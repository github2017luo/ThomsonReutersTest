/**
* @description This class is responsible for handling the incoming mails from Workflow rules.It parses the subject line and accordingly passes the control to the appropriate class.
*/

public without sharing class TaxSAPCustomerQuoteCreateServiceHandler implements Messaging.InboundEmailHandler{
    
    /**
     * @description Handler method triggering ZPEND request and update Order
     * @param email of type Messaging.InboundEmail
     * @param envelope of type Messaging.InboundEnvelope
     * @return Messaging.InboundEmailResult
     */
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        String sub = email.subject;
        //String body = email.plainTextBody;
        if(sub!=null){  
            if(sub.contains('CreateSoldToTaxCustomer:>')){   
                LIST<String> stringList = new LIST<String>();
                stringList = sub.subString(sub.indexOf(':>')+2).split(':');
                string proposalId = stringList[0];
                string sfdcSSDId = stringList[1];
                invokeZPEND(proposalId,sfdcSSDId);
            }
            //Start: Added by Kruti Shah for DOC-12443
            else if(sub.contains('UpdateOrderForClosedCase:>')){
                LIST<String> stringList = new LIST<String>();
                stringList = sub.subString(sub.indexOf(':>')+2).split(':');
                string caseID = stringList[0];
                string orderId = stringList[1];
                system.debug(LoggingLevel.DEBUG,'KS--> caseID '+caseID);
                system.debug(LoggingLevel.DEBUG,'KS--> orderId '+orderId);
                updatedorder(orderId);                
            }
            //End: Added by Kruti Shah for DOC-12443
            //Code written as part of Sales Tax Integration  - Added By Poorva -DOC-6407
            //Code covered with Tax_SalesTaxFromDellBoomi_Test
          /*if(sub.contains('SalesTaxIntegration:>'))
            {   
                LIST<String> stringList = new LIST<String>();
                string configId= sub.subString(sub.indexOf(':>')+2);
                System.debug('$$PS Insinde handler of sust quote - sales tax'+configId);
                
                Tax_SalesTaxFromDellBoomi.triggerSalesTax(configId.trim());
                
            } */
        }              
        result.success = true;
        return result;
    }

    /**
     * @description Method to trigger ZPEND request
     * @param proposalId of type String
     * @param sfdcSSDId of type String
     */
    public void invokeZPEND(String proposalId,String sfdcSSDId){
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
            Apttus_Proposal__Proposal__c proposal = [select Id,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Id=:proposalId];
            if(proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                CreateSSDCustomerFromDellBoomi.oppID = proposal.Apttus_Proposal__Opportunity__c;
                CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(sfdcSSDId,proposalId);
            }else{
                CreateSSDCustomerFromESI.triggerCustomerCreation(sfdcSSDId,proposalId);                 
            }
        }
    }
    
    /**
     * @description Method to update Order on Case Closure
     * @param orderId of type String
     */
    public void updatedorder(String orderId){
        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()){
            Apttus_Config2__Order__c orderRec = [Select Id,name,APTS_SAP_Status__c,Apttus_Config2__Status__c from Apttus_Config2__Order__c 
                                                where Id =:orderId and APTS_SAP_Status__c =:'Case Created'];                    
            orderRec.APTS_SAP_Status__c = 'Order Completed';
            orderRec.Apttus_Config2__Status__c = 'Pending';
            orderRec.Apttus_Config2__ActivatedDate__c = datetime.now();
            update OrderRec;
        }
    }
}