/* Class: TRStore_ErrorHandler
* Purpose: Class to record the exception in the integration logger object
* Created: 03 Nov 2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =================================================================================
* Date          Name                 JIRA        Description
* 03 Nov 2020   Avudaiappan A        DUE-6164    Created this class to fetch product details JSON 
* ==================================================================================
*/
public with sharing Class TRStore_ErrorHandler{
    /* Use the following lines for calling the below method in the class
     * Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage(),'webServiceName'=>'CreateProposalAPI','requestType'=>'Getting records from UEProposal','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>staticVal.get('cartId'),'supportEmail'=>staticVal.get('supportEmail'),'toSupport'=>'true'};
     * TRStore_ErrorHandler.logException(errorHandlerMap);
     */
    public static void logException(Map<String,String> errorMap){
        try{
            integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = errorMap.get('objectName');
            intLog.Exception_Message__c = errorMap.get('expMsg');
            intLog.Request_Message__c = errorMap.get('reqMsg');
            intLog.Request_Type__c = errorMap.get('requestType');
            intLog.Service_Name__c = errorMap.get('webServiceName');
            intLog.Exception_Module__c = errorMap.get('module');
            intLog.Object_Id__c = errorMap.get('recId');
            intLog.Support_Email__c = errorMap.get('supportEmail');
            intLog.Is_Escalated_to_Support__c = boolean.valueOf(errorMap.get('toSupport'));  
            
            database.saveResult intLoggerSave = database.insert(intLog,false); 
                
            if((errorMap.get('objectName')).contains('Lead')){
                Database.update(new Lead(ID=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }else if((errorMap.get('objectName')).contains('Quote/Proposal')){
                Database.update(new Apttus_Proposal__Proposal__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }else if((errorMap.get('objectName')).contains('Product Configuration')){
                Database.update(new Apttus_Config2__ProductConfiguration__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }/*else if((errorMap.get('objectName')).contains('Order')){
                Database.update(new Apttus_Config2__Order__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }else if((errorMap.get('objectName')).contains('Source System Detail')){
                Database.update(new Source_System_Detail__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }else if((errorMap.get('objectName')).contains('Online Contacts')){
                Database.update(new Online_Contact__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }*/
        } catch(Exception e){
            system.debug(loggingLevel.INFO,'TRS Exception >>'+e);
        }
    }  
        
}