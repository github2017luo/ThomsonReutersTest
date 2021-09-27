/*
======================================================================================================================
TEST CLASS NAME: testServiceNotes
======================================================================================================================
=
PURPOSE: Validates the functionality provided by the ServiceNotes class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
17/11/2017       Niket K        Method named 'testLCRMServiceNotes' added to test the lift and shift of SAP number from account to SSD
======================================================================================================================
*/

@isTest
public class testServiceNotes
{
    public static testmethod void testServiceNotes()
    {
        List<Account> listAccount = new List<Account>();
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
        Account account = new Account();
        Account account1 = new Account();
      
        if(listAccount.isEmpty())
        {
            account.Name = 'testAccount';
            account.Customer_Type__c = 'Induvidual';
            account.Customer_Group__c = 'ACADEMIC';
            account.Industry = 'Energy';
            account.SAPAccountNumber__c = '1000550771';
            insert account;
            account1.Name = 'testAccount';
            account1.Customer_Type__c = 'Induvidual';
            account1.Customer_Group__c = 'ACADEMIC';
            account1.Industry = 'Energy';
            account1.SAPAccountNumber__c = '1000550721';
            account1.ParentId=account.id;
            insert account1;           
                           
            
        }
        else
        {
            account = listAccount[0];
        }
        
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000031954'];
        Account childAccount = new Account();
        if(listAccount.isEmpty())
        {
            childAccount.Name = 'testAccount';
            childAccount.Customer_Type__c = 'Induvidual';
            childAccount.Customer_Group__c = 'ACADEMIC';
            childAccount.Industry = 'Energy';
            childAccount.SAPAccountNumber__c = '1000031954';
            childAccount.ParentId = account1.Id;
            insert childAccount;
        }
        else
        {
            childAccount = listAccount[0];
        }
        Test.startTest();
        pageReference pgTrainingEventfromAccount = page.ServiceNotes;
        Test.setCurrentPage(pgTrainingEventfromAccount);
        ApexPages.currentPage().getParameters().put('Id', account1.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(account1);
        
        ServiceNotes controller = new ServiceNotes(sc);
        ServiceNotesServices ss = new ServiceNotesServices();
        PageReference pggetlistServiceNoteItems = controller.getlistServiceNoteItems();
        account1.SAPAccountNumber__c=null;
        update account1;
        PageReference pggetlistServiceNoteItems2 = controller.getlistServiceNoteItems();
        
        PageReference pgchangeServiceNoteDetail = controller.changeServiceNoteDetail();
        controller.FilterByDepartmentValue = 'Department';
        PageReference pgFilterByDepartmentValue = controller.FilterByDepartment();
        
        
        ApexPages.currentPage().getParameters().put('Id', account.Id);        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(account);
        
        ServiceNotes controller1 = new ServiceNotes(sc1);
        ServiceNotesServices ss1 = new ServiceNotesServices();
        childAccount.ParentId=account.id;
        update childAccount;
        
        PageReference pggetlistServiceNoteItems1 = controller1.getlistServiceNoteItems();
        Test.stopTest();
    }
    /*
Description : testLCRMServiceNotesmethod is used to cover the functionality of LCRMServiceNotes 

*/
    @istest
    public static void testLCRMServiceNotes()
    {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser = new User(alias = 'GLIT', email='user@GLImydomain.com', 
                                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                                timezonesidkey='America/Los_Angeles', username=System.now().getTime() +'user@gli.com',Rep_Type_Description__c='test',
                                Sub_Bu__c = 'USL');        
        insert gliUser;
        List<Account> listAccount = new List<Account>();
        List<Source_System_Detail__c> SsdList = new List<Source_System_Detail__c>();
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c,(Select Source_System_Account_Number__c FROM Source_System_Details__r WHERE LCRM_Sales_Org__c = 'West') from Account where SAPAccountNumber__c = '1000550771'];
        Account account = new Account();
        Account account1 = new Account();
        Account NoSSDaccount = new Account();
        Account NoSSDaccount1 = new Account();
        if(listAccount.isEmpty())
        {
            account.Name = 'testAccount';
            account.Customer_Type__c = 'Induvidual';
            account.Customer_Group__c = 'ACADEMIC';
            account.Industry = 'Energy';           
            insert account;
            
            NoSSDaccount.Name = 'testAccountNoSSD';
            NoSSDaccount.Customer_Type__c = 'Induvidual';
            NoSSDaccount.Customer_Group__c = 'ACADEMIC';
            NoSSDaccount.Industry = 'Energy';   
            NoSSDaccount.SAPAccountNumber__c = null;
            insert NoSSDaccount;
            
            NoSSDaccount1.Name = 'testAccountNoSSD';
            NoSSDaccount1.Customer_Type__c = 'Induvidual';
            NoSSDaccount1.Customer_Group__c = 'ACADEMIC';
            NoSSDaccount1.Industry = 'Energy';            
            NoSSDaccount1.ParentId=account.id;
            insert NoSSDaccount1;
            
            account1.Name = 'testAccount';
            account1.Customer_Type__c = 'Induvidual';
            account1.Customer_Group__c = 'ACADEMIC';
            account1.Industry = 'Energy';
            //account1.SAPAccountNumber__c = '1000550721';
            account1.ParentId=account.id;
            insert account1;
            
            
            Source_System_Detail__c ssd1 = new Source_System_Detail__c();
            ssd1.Source_System_Account_Number__c = '1000550721';
            ssd1.LCRM_Sales_Org__c = 'West';
            ssd1.Account_Name__c = account1.Id;
            ssd1.Source_System_Name__c = 'Test';
            insert ssd1;
            
            Source_System_Detail__c ssd2 = new Source_System_Detail__c();
            ssd2.Source_System_Account_Number__c = '1000550721';
            ssd2.LCRM_Sales_Org__c = 'West';
            ssd2.Account_Name__c = account1.Id;
            ssd2.Source_System_Name__c = 'Test';
            insert ssd2;
            
            
        }
        else
        {
            account = listAccount[0];
        }
        
        listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c,(Select Source_System_Account_Number__c FROM Source_System_Details__r WHERE LCRM_Sales_Org__c = 'West') from Account where SAPAccountNumber__c = '1000031954'];
        Account childAccount = new Account();
        Account childAccountNoSSD = new Account();
        if(listAccount.isEmpty())
        {
            childAccount.Name = 'testAccount';
            childAccount.Customer_Type__c = 'Induvidual';
            childAccount.Customer_Group__c = 'ACADEMIC';
            childAccount.Industry = 'Energy';
            childAccount.SAPAccountNumber__c = '1000031954';
            childAccount.ParentId = account1.Id;
            insert childAccount;
    
            childAccountNoSSD.Name = 'testAccount';
            childAccountNoSSD.Customer_Type__c = 'Induvidual';
            childAccountNoSSD.Customer_Group__c = 'ACADEMIC';
            childAccountNoSSD.Industry = 'Energy';
            childAccountNoSSD.SAPAccountNumber__c = '1000031955';
            childAccountNoSSD.ParentId = NoSSDaccount.Id;
           // insert childAccountNoSSD;
            
            Source_System_Detail__c ssd1 = new Source_System_Detail__c();
            ssd1.Source_System_Account_Number__c = '1000031954';
            ssd1.LCRM_Sales_Org__c = 'West';
            ssd1.Account_Name__c = childAccount.Id;
            ssd1.Source_System_Name__c = 'Test';
          //  insert ssd1;           
            
            
        }
        else
        {
            childAccount = listAccount[0];
        }
        
        Test.startTest();
        system.runAs(gliUser){
            pageReference pgServiceNotes = page.ServiceNotes;
            Test.setCurrentPage(pgServiceNotes);
            ApexPages.currentPage().getParameters().put('Id', account1.Id);        
            ApexPages.StandardController sc = new ApexPages.StandardController(account1);
            
            ServiceNotes controller = new ServiceNotes(sc);
            ServiceNotesServices ss = new ServiceNotesServices();
            PageReference pggetlistServiceNoteItems = controller.getlistServiceNoteItems();
            account1.SAPAccountNumber__c=null;            
            update account1;
            
            PageReference pggetlistServiceNoteItems2 = controller.getlistServiceNoteItems();            
            PageReference pgchangeServiceNoteDetail = controller.changeServiceNoteDetail();
            controller.FilterByDepartmentValue = 'Department';
            PageReference pgFilterByDepartmentValue = controller.FilterByDepartment();          
            
            ApexPages.currentPage().getParameters().put('Id', account.Id);        
            ApexPages.StandardController sc1 = new ApexPages.StandardController(account);
            
            ServiceNotes controller1 = new ServiceNotes(sc1);
            ServiceNotesServices ss1 = new ServiceNotesServices();
            childAccount.ParentId=account.id;
            update childAccount;            
            PageReference pggetlistServiceNoteItems1 = controller1.getlistServiceNoteItems();
            System.debug('pggetlistServiceNoteItems1 @@@ '+pggetlistServiceNoteItems1);
            System.assert(pggetlistServiceNoteItems1==null, pggetlistServiceNoteItems1);  
            System.assertequals(true,controller1.RenderServiceNoteList);
            System.assertNotEquals(0,controller1.listServiceNotesResult.size());
            
           
            ApexPages.currentPage().getParameters().put('Id', NoSSDaccount.Id);        
            ApexPages.StandardController scnossd1 = new ApexPages.StandardController(NoSSDaccount);            
            ServiceNotes controllernossd1 = new ServiceNotes(scnossd1);         
            PageReference pggetlistServiceNoteItemsnossd1 = controllernossd1.getlistServiceNoteItems(); 
            System.assertNotEquals(0,controllernossd1.listServiceNotesResult.size());
         
            
            ApexPages.currentPage().getParameters().put('Id', NoSSDaccount1.Id);        
            ApexPages.StandardController scnossd2 = new ApexPages.StandardController(NoSSDaccount1);            
            ServiceNotes controllernossd2 = new ServiceNotes(scnossd2);
            ServiceNotesServices ssnossd2 = new ServiceNotesServices();
            PageReference pggetlistServiceNoteItemsnossd2 = controllernossd2.getlistServiceNoteItems(); 
           System.assertNotEquals(0,controllernossd2.listServiceNotesResult.size());
         
            
            
            
        }
        
        Test.stopTest();
    }
    
    
    
    
}