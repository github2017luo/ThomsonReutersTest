/**
* Interface to Update the order status 
* Order Details
*
* @author  TCS
* @version 2016-09-22
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description
* 2016-09-22   Prabhu Issac                    Created                                                                   
* =============================================================================
*/
@RestResource(urlMapping='/apttusorderpostback/*')
global without sharing class ApttusORDERSTATUSPostback{
  @HttpPost
    global static status handleOrderStatusPostback(StatusUpdate StatusUpdate){
    
       Map<String,Order_Status__c> orderStatusSortingMap = new Map<String, Order_Status__c>();
        status st = new status ();
        try{
            orderStatusSortingMap = Order_Status__c.getAll();
            if(!AppUtil.IsEmpty(StatusUpdate.originatingOrderNumber)){            
                if(!(AppUtil.IsEmpty(StatusUpdate.orderID) && AppUtil.IsEmpty(StatusUpdate.docStatus) ) ){
                        List<Apttus_Config2__Order__c> listOrders = new List<Apttus_Config2__Order__c>();
                        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()){
                            listOrders = [Select id,Name,IDOC__c, Apttus_Config2__Status__c,APTS_SAP_Status__c ,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c,Apttus_QPConfig__ProposalId__r.Name, Apttus_Config2__OrderReferenceNumber__c, Apttus_Config2__OrderDate__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__r.Name =:StatusUpdate.originatingOrderNumber order by Apttus_Config2__OrderDate__c desc];
                        }
                        
                        //Changes added by Gowthami as part of SOC-7011 dated 21/3/2018 for Findlaw , APTS_Check_COB__c added by Sakshi as part of SOC-9388 dated 12/06/2018
                        List<Apttus_Proposal__Proposal__c> listProp = new List<Apttus_Proposal__Proposal__c>();
                        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
                            listProp = [Select id,Apttus_Proposal__Approval_Stage__c,APTS_Check_COB__c,APTS_Case_Brand_Value__c,APTS_Proposal_Business_Unit__c from Apttus_Proposal__Proposal__c where id=:listOrders[0].Apttus_QPConfig__ProposalId__c];
                        }
                        if(!listOrders.isEmpty()){
                            if(listOrders[0].APTS_SAP_Status__c!= orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c){
                                    listOrders[0].Apttus_Config2__OrderReferenceNumber__c = StatusUpdate.orderID;
                                    listOrders[0].APTS_SAP_Status__c = orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c;
                                    if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='Order Completed'){
                                        listOrders[0].Apttus_Config2__Status__c='Activated';                                      
                                    }
                                    //Changes added by Gowthami as part of SOC-7011 dated 21/3/2018
                                    else if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='No Inventory Available'){
                                       listProp[0].Apttus_Proposal__Approval_Stage__c='Rejected';
                                    }
                                    
                                    //Changes added by Sakshi as part of SOC-9388 dated 12/06/2018
                                    else if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='Ready for COB'){
                                       listProp[0].APTS_Check_COB__c = true;
                                    }
                                    //get IDOC number from ESI-Pathra
                                    if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c=='Order Created'){
                                        listOrders[0].IDOC__c=StatusUpdate.idocNumber;
                                        //Added for DOC-13521
                                        Map<Id,String> failurereason = new Map<Id,String>();
                                        for(APTS_Case_Brand__mdt val : [Select MasterLabel,DeveloperName,APTS_Case_Brand_Value__c,APTS_Case_Type__c,APTS_Product_Family__c,APTS_Proposal_Business_Unit__c from APTS_Case_Brand__mdt where APTS_Case_Type__c =: 'Entitlement']){
                                            if(val.APTS_Product_Family__c == listProp[0].APTS_Case_Brand_Value__c && listProp[0].APTS_Proposal_Business_Unit__c != null && val.APTS_Proposal_Business_Unit__c.contains(listProp[0].APTS_Proposal_Business_Unit__c)){
                                                failurereason.put(listProp[0].Id,val.APTS_Case_Brand_Value__c);
                                                system.debug('######## val.APTS_Case_Brand_Value__c'+val.APTS_Case_Brand_Value__c);
                                            }                                           
                                        }
                                        if(!failurereason.isEmpty() && failurereason != null){
                                            List<Id> listofprop = new List<Id>{listProp[0].Id};
                                            List<Id> createdcases = new List<Id>();
                                            GenericCaseMgmtService casecall = new GenericCaseMgmtService();
                                            system.debug('######## failurereason'+failurereason);
                                            createdcases = casecall.createCreditCheckCase(listofprop,failurereason);
                                        }
                                        //End DOC-13521
                                    }
                                   /* //SOC-3959-Pathra
                                    //change--Start- Added to send mail when the order is canceled in SAP due to the deactivation of material
                                    if(orderStatusSortingMap.get(StatusUpdate.docStatus).SFDC_Order_Status__c!='ORDER_CANCELED'){
                                        Apttus_Proposal__Proposal__c Quote =[Select Name,Id,ownerId from Apttus_Proposal__Proposal__c where name=:listOrders[0].Apttus_QPConfig__ProposalId__r.Name]; 
                                        User proposalOwner = [SELECT id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c FROM User where Id=:Quote.OwnerId];
                                        system.debug('###'+proposalOwner);
                                        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
                                        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                        emailToSend.setToAddresses(new List<String>{'pathra226374@gmail.com',string.valueof(proposalOwner.Email)});
                                        emailToSend.setPlainTextBody('Hi '+proposalOwner.Name+',\n\nThe order you have submitted has been canceled in SAP as the material is deactivated,\nplease change the material and resubmit it.\n\nThanks,\nSupport Team');
                                        emailToSend.setSubject('Order Canceled');
                                        lstMsgsToSend.add(emailToSend);                
                                        Messaging.sendEmail(lstMsgsToSend);
                                    }
                                    //change--End*/
                                     if(!listProp.isEmpty() && Schema.sObjectType.Apttus_Proposal__Proposal__c.IsUpdateable()){
                                        update listProp;
                                     }
                                    //Changes ended by Gowthami as part of SOC-7011 dated 21/3/2018
                                    update listOrders[0];
                                    st.description='Received Successfully by Salesforce';
                                    st.code='202';                                   
                                    
                            }
                            else{
                                 st.description='The order is already in the status of which you are trying to update.';
                                 st.code='404';
                            }
                        
                }
                 
              }
            }
         }
        catch(Exception ex){
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            st.description='Something went wrong'+ex.getMessage()+ex.getLineNumber();
            st.code='404';
        }
        return st;
    }

    //ORDER object wrapper class
    global class StatusUpdate{
        global string originatingOrderNumber;
        global string idocNumber;
        global string soldToAccount;
        global string orderID;
        global string productId;
        global string orderCancelled;
        global string docStatus;
        global string docId;
        global string contractNum;
        global string contractLine;
        global string deliveryDoc;
        global string deliveryDate;
        global string shipMethod;
        global string shipCarrier;
        global string trackingNum;
        global string externalUserId;
        global string timestamp ;
        global string orderProcessedBy;
        global string QuoteId;

    }     
    global class status{
        global String description;
        global String code;
        public status()
        {
        description='';
        code='';
        }
    } 
}