@isTest 
public class IntegrationControllerTest
{
    static String orderNum;
    static String log_id;
 @TestSetup
    static void test_Setup(){
        List <Integration_logger__c> lstAccount = new List<Integration_logger__c>();
        Integration_logger__c testlog = new Integration_logger__c();
        testlog.Object_Name__c='Quote/Proposal';
        lstAccount.add(testlog);
        Integration_logger__c testlog2 = new Integration_logger__c();
        testlog2.Object_Name__c='Quote/Proposal' ;
        lstAccount.add(testlog2);
        insert lstAccount;
        
        Apttus_Config2__Order__c order=new Apttus_Config2__Order__c(Retry_Count__c=3);
        insert order;
        
        Apttus_Config2__Order__c ord=[select name,id from Apttus_Config2__Order__c where id=:order.id];
        orderNum=ord.name;
        
      //  Integration_logger__c log_id_id=[select id from Integration_logger__c where Order__r.id=:order.id];
       // log_id=log_id_id.id;
    }
    static testmethod void testsearchmethod(){  
        List<Integration_logger__c> lstAccount1=[Select id,name,Object_Name__c from Integration_logger__c where Object_Name__c='Quote/Proposal'];
        Test.startTest();
        //String searchValue='abc';
        
        Test.setCurrentPage(Page.IntegrationLoggerPage);
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount1);
        stdSetController.setSelected(lstAccount1);
        IntegrationController ext = new IntegrationController(stdSetController);
        ext.searchValue='abc';
         
        ext.Search();
       
        //ext.retry();
        //ext.retryAll();
        ext.Previous();
        ext.next();
        Test.stopTest();
    }
    static testmethod void testUpdateMethod(){
        List<Integration_logger__c> lstAccount2=[Select id,name,Object_Name__c from Integration_logger__c where Object_Name__c='Quote/Proposal'];        
        Test.startTest();
        Apttus_Config2__Order__c o=[select id,name from Apttus_Config2__Order__c where Retry_Count__c=3];
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lstAccount2);
        stdSetController.setSelected(lstAccount2);
        IntegrationController intlog = new IntegrationController(stdSetController);
       //IntegrationController.UpdateIntegrationLogger(false,o.Id,lstAccount2[0].Id);
        Test.stopTest();
    }
    static testmethod void testupdateintegrationlogger()
    {
      Apttus_Config2__Order__c order=new Apttus_Config2__Order__c(Retry_Count__c=3);
        insert order;
      
       List<Integration_logger__c> integrationLoggerList=new List<Integration_logger__c>{new Integration_logger__c(Object_Name__c='Quote/Proposal',Success__c=false,Order__c=order.Id)};
       
       
       
        Test.startTest();
        //String searchValue='abc';
        
        Test.setCurrentPage(Page.IntegrationLoggerPage);
       
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(integrationLoggerList);
        Apexpages.currentPage().getparameters().put('selectedOrdId',order.Name);
        stdSetController.setSelected(integrationLoggerList);
        IntegrationController ext = new IntegrationController(stdSetController);
       //IntegrationController.SubmitORder(orderNum,lstAccount1[0].Id);
       
        ext.searchValue='';
         
        ext.Search();
       
        //ext.retry();
       // ext.retryAll();
        ext.Previous();
        ext.next();
        Test.stopTest();
    } 
}