@isTest
public class USL_ServiceNotesESI_Test{

    public void init(){
    
    }

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
        
        WebServiceSettings__c ESIWebService = new WebServiceSettings__c();
        ESIWebService.Name = 'USL_ServiceNoteServicesESI';
        ESIWebService.Active__c  = true;
        ESIWebService.Endpoint__c = 'api.apigarden-qa.thomsonreuters.com/ebs/case/qa/getServiceNoteList';
        ESIWebService.Max_GLI_Count__c = 10;
        ESIWebService.Max_Non_GLI_Count__c = 10;
        ESIWebService.Password__c = 'esidevuser123';
        ESIWebService.Service_Unavailable_Message__c = 'test';
        ESIWebService.Timeout__c = 120;
        ESIWebService.Username__c = 'esidevuser';
        insert ESIWebService;
        
        WebServiceSettings__c ESIWebService2 = new WebServiceSettings__c();
        ESIWebService2.Name = 'USL_ServiceNoteServicesdetailESI';
        ESIWebService2.Active__c  = true;
        ESIWebService2.Endpoint__c = 'api.apigarden-qa.thomsonreuters.com/ebs/case/qa/getServiceNoteList';
        ESIWebService2.Max_GLI_Count__c = 10;
        ESIWebService2.Max_Non_GLI_Count__c = 10;
        ESIWebService2.Password__c = 'esidevuser123';
        ESIWebService2.Service_Unavailable_Message__c = 'testiuytre';
        ESIWebService2.Timeout__c = 120;
        ESIWebService2.Username__c = 'esidevuser';
        insert ESIWebService2;
        
        
        
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        ssd.recordTypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        ssd.name = 'testqwerty4321';
        ssd.Source_System_Name__c = 'sourceSystemNameruihvr';
        ssd.Account_Name__r = account1;
        ssd.Account_Name__c = account1.id;
        ssd.LCRM_Sales_Org__c = 'WEST';
        ssd.LCRM_Sub_BU__c = 'USL';
        insert ssd;
       
        
        Test.startTest();
        pageReference pgTrainingEventfromAccount = page.ServiceNotesESI;
        Test.setCurrentPage(pgTrainingEventfromAccount);
        ApexPages.currentPage().getParameters().put('Id', account1.Id);        
        ApexPages.StandardController sc = new ApexPages.StandardController(account1);

        USL_ServiceNotesESI controller = new USL_ServiceNotesESI(sc);
        ServiceNotesServices ss = new ServiceNotesServices();
        PageReference pggetlistServiceNoteItems = controller.getlistServiceNoteItems();
        account1.SAPAccountNumber__c=null;
        update account1;
        PageReference pggetlistServiceNoteItems2 = controller.getlistServiceNoteItems();
        
        Boolean pgchangeServiceNoteDetail = controller.changeServiceNoteDetail();
        controller.FilterByDepartmentValue = 'Department';
        PageReference pgFilterByDepartmentValue = controller.FilterByDepartment();
        
        
        ApexPages.currentPage().getParameters().put('Id', account.Id);        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(account);

        USL_ServiceNotesESI controller1 = new USL_ServiceNotesESI(sc1);
        ServiceNotesServices ss1 = new ServiceNotesServices();
        childAccount.ParentId=account.id;
        update childAccount;
        
        PageReference pggetlistServiceNoteItems1 = controller1.getlistServiceNoteItems();
        
        
        controller.dFromDt = '';
        PageReference pggetlistServiceNoteItems3 = controller.getlistServiceNoteItems();

        controller.FilterByDepartmentValue = '';
        PageReference pggetlistServiceNoteItems4 = controller.FilterByDepartment();
        
        
        controller.listServiceNotes.clear();
        controller.ShoworHideFilter();
        
        ServiceNotesWS.ServiceNote_v4_0ESI_Implementation ESIWS = new ServiceNotesWS.ServiceNote_v4_0ESI_Implementation();
        String sample = ESIWS.getSampleJson();
        
        JSONParser parser = JSON.createParser(sample);
        ESIWS.parseErrorMessage(parser);
       
        Decimal[] decimalArray = new Decimal[]{10};
        ESIWS.GetServiceNoteItems('1234jks', decimalArray, Date.today(), Date.today());
        ESIWS.GetServiceNoteDetail('SystemId','ServiceNoteId');
        
        ServiceNotesWS.GetServiceNoteDetailResponse_element element = new ServiceNotesWS.GetServiceNoteDetailResponse_element();
        
        
        ServiceNotesWS.ServiceNote_v3_0Port port3 = new ServiceNotesWS.ServiceNote_v3_0Port();
        //port3.GetServiceNoteItems('SystemId', decimalArray ,Date.today() ,Date.today();
        port3.GetServiceNoteDetail('1234systemId','serviceNoteId');
        
        ServiceNotesWS.GetServiceNoteItemsResponse_elementESI element2 = new ServiceNotesWS.GetServiceNoteItemsResponse_elementESI();
        
        
        
        Test.stopTest();
    }

}