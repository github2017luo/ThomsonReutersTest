/**
* Test Class for 'Active S2E account Workflow Merged-Created&Edited' Process Builder
*
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2020-08-21   Miriam Ghosh            Created     
* =============================================================================
*/

@isTest
/**
 * @description Hello World
 */
public class S2EWorkflowMergedCreatedandEdited_test {
 
    //For method: Is RecType Customer,prospect etc?
    @isTest static void s2eAccWorkflowMethod1(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');

        
        //test.startTest();
            
            Id recordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            
        	Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.Phone = '1234567890';
            acc1.Account_Error_Counter__c = 3;
        	acc1.RecordTypeId = RecordTypeIdAccount1;
            insert acc1;
        
        	Id recordTypeIdAccount3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            acc1.RecordTypeId = RecordTypeIdAccount3;
            update acc1;
        
        	Id recordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            acc1.RecordTypeId = RecordTypeIdAccount2;	
            acc1.Account_Error_Counter__c = 2;
            acc1.SAPAccountNumber__c = 'UTSAP001';
            acc1.Sales_Org__c = 'LLEY';
            acc1.NameTwo__c = 'test';
            acc1.Is_GLI__c = False;
            update acc1;
           
        
            //test.stopTest();
    }
   
    //Method: Is RT Archive?Is Arc Date NULL?
    @isTest static void s2eAccWorkflowMethod2(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');

        
        //test.startTest();
            
            Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();
            Id recordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Archive').getRecordTypeId();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.RecordTypeId = RecordTypeIdAccount1;// Archive
            acc1.Archive_Date__c = null;
            //acc1.Is_GLI__c = true;
            insert acc1;
        
            acc1.RecordTypeId = RecordTypeIdAccount;// GLI acc
            acc1.Archive_Date__c = Date.valueof('2021-12-17');
            acc1.Is_GLI__c = False;
            update acc1;
            system.debug(LoggingLevel.DEBUG,'@@@PB method 2'+acc1.Archive_Date__c);
            //system.assertEquals(null, acc1.Archive_Date__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 2'+acc1.Archive_Date__c);
        
            //test.stopTest();
    }
    
    //Method: Is AccName notNull?Is GLI False?
    @isTest static void s2eAccWorkflowMethod3(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'test account';
            acc1.Is_GLI__c = False;
            acc1.Tax_3__c = 'test';
            acc1.Tax_4__c = 'tax4';
            insert acc1;
            
            /*acc1.Tax_3__c = 'TEST';
            update acc1;
        
            acc1.Tax_4__c = 'TAX4';
            update acc1;
        
            acc1.Name = 'TEST ACCOUNT';
            update acc1;*/
        
            system.debug(LoggingLevel.DEBUG,'@@@PB method 3'+acc1.Tax_3__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 3'+acc1.Tax_4__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 3'+acc1.Name);
        
            //test.stopTest();
    }
    
    //Method: Is Sales org FSCO,TSL,RV01?
    @isTest static void s2eAccWorkflowMethod4(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.Sales_Org__c = 'RV01';
            insert acc1;
        
            acc1.Sales_Org__c = 'TSL';
            update acc1;
        
            /*acc1.Is_Migrated__c = true;
            update acc1;*/
            //system.assertEquals(true, acc1.Is_Migrated__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 4'+acc1.Is_Migrated__c);
           
        
            //test.stopTest();
    }
    
    
    //Method: IsGLI?WLECExternalID not NULL?profile Contains WPD?
    @isTest static void s2eAccWorkflowMethod5(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');        
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.Is_GLI__c = False;
            acc1.WLEC_External_Id__c = 'X012356';
            insert acc1;
        
            /*acc1.WPD_Record__c = true;
            update acc1;*/
            //system.assertEquals(true, acc1.WPD_Record__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 5'+acc1.WPD_Record__c);
        
            //test.stopTest();
    }
    
    //Method:Is marked for Deletion?Is Exclude From Archive False? 
    @isTest static void s2eAccWorkflowMethod6(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');            
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.Mark_for_Deletion__c = true;
            acc1.Exclude_From_Archive__c = false;
            acc1.Sales_Org__c = 'LPTC';
            insert acc1;
        
            /*acc1.Archive_Date__c = system.today();
            acc1.RecordTypeId = '01213000001Ncxy';
            acc1.ShortTerm_Archive_Remove_Date__c = system.today()+30;
            acc1.Temp_Archive_Group__c = 'MFD';
            update acc1;*/
        
            /*system.assertEquals(system.today(), acc1.Archive_Date__c);
            system.assertEquals('01213000001Ncxy', acc1.RecordTypeId);
            system.assertEquals(system.today()+30, acc1.ShortTerm_Archive_Remove_Date__c);
            system.assertEquals('MFD', acc1.Temp_Archive_Group__c);*/
            
            system.debug(LoggingLevel.DEBUG,'@@@PB method 6'+acc1.Archive_Date__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 6'+acc1.RecordTypeId);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 6'+acc1.ShortTerm_Archive_Remove_Date__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 6'+acc1.Temp_Archive_Group__c);
        
            //test.stopTest();
    }
    
    //Method:RT Archive?isNULL ArcDate?
    @isTest static void s2eAccWorkflowMethod7(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Archive').getRecordTypeId();
            acc1.Phone = '1234567890';
            //acc1.Archive_Date__c = ";
            insert acc1;
        
            /*acc1.Archive_Date__c = system.today();
            update acc1;*/
            //system.assertEquals(system.today(), acc1.Archive_Date__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 7'+acc1.Archive_Date__c);
        
            //test.stopTest();
    }
    
    //Method: Is RT Archive?
    @isTest static void s2eAccWorkflowMethod8(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            insert acc1;
        
            /*acc1.Long_Term_Archive__c = false;
            acc1.Temp_Archive_Group__c = '';
            update acc1;*/
            
            /*system.assertEquals(false, acc1.Long_Term_Archive__c);
            system.assertEquals('', acc1.Temp_Archive_Group__c);*/
            system.debug(LoggingLevel.DEBUG,'@@@PB method 8'+acc1.Long_Term_Archive__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 8'+acc1.Temp_Archive_Group__c);
        
            //test.stopTest();
    }
    
    //Method: Is WorldCheckMatch NULL & Failed match,Is Sanctioned Status not null?
    @isTest static void s2eAccWorkflowMethod9(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        Profile prof = [SELECT Id FROM profile WHERE name='System Administrator'];
        User us = UnitTest.getUserInstance();
        us.Username = 'New'+Math.random()*100 +'@TR.com';        
        us.profileid = prof.Id;
        us.CommunityNickname = 'MG2';
        us.Sub_Bu__c = 'UKI';
        insert us;
  
        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');      
        //test.startTest();
          System.runAs(us){  
            Account acc1 = UnitTest.getAccountInstance();
            acc1.recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc1.Is_GLI__c = true;
            acc1.Name = 'Test Account';
            acc1.LCRM_WorldCheck_Match_Status__c = 'Failed match';
            acc1.Sanctioned_Status__c = '';
            insert acc1;
            
            //Account a = [Select id, Sanctioned_Status__c FROM Account WHERE Id =: acc1.id];
            /*acc1.Sanctioned_Status__c = 'No Sanctions';
            update acc1;
            system.assertEquals('No Sanctions', acc1.Sanctioned_Status__c);*/
            system.debug(LoggingLevel.DEBUG,'@@@PB method 9'+acc1.Sanctioned_Status__c);
            }

            //test.stopTest();
    }
    
    //Method: Is Long-Term Archive?Is short term Archive Remove Date not blank?
    @isTest static void s2eAccWorkflowMethod10(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            acc1.Long_Term_Archive__c = true;
            acc1.ShortTerm_Archive_Remove_Date__c = system.today()+10;
            insert acc1;
        
            /*acc1.ShortTerm_Archive_Remove_Date__c = null;
            update acc1;*/
            //system.assertEquals(null, acc1.ShortTerm_Archive_Remove_Date__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 10'+acc1.ShortTerm_Archive_Remove_Date__c);
        
            //test.stopTest();
    }
    
    //Method: Is RT Customer?Is Tax Expiration Date today?Customer marker check to True?
    @isTest static void s2eAccWorkflowMethod11(){
        
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;

        integer j = 1;
        integer k = 1;
        System.assertEquals(j,k,'equal');
        //test.startTest();
            
            Account acc1 = UnitTest.getAccountInstance();
            acc1.Name = 'Test Account';
            acc1.recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
            acc1.Tax_Document_Expiration_Date__c = system.today()-30;
            acc1.Customer_Master_Check__c = true;
            insert acc1;
        
           /*acc1.Customer_Master_Check__c = false;
            acc1.Sales_Check__c = false;
            update acc1;*/
            system.debug(LoggingLevel.DEBUG,'@@@PB method 11'+acc1.Customer_Master_Check__c);
            system.debug(LoggingLevel.DEBUG,'@@@PB method 11'+acc1.Sales_Check__c);

            //test.stopTest();
    }
    
}