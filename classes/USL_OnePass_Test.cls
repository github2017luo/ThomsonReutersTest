@isTest
public class USL_OnePass_Test{

    static Contact con = new Contact();
    static Account account = new Account();
    static Account account1 = new Account();
    static Account account2 = new Account();
    static Account childAccount = new Account();
    static WebServiceSettings__c ESIWebService = new WebServiceSettings__c();
    static WebServiceSettings__c ESIWebService2 = new WebServiceSettings__c();
    static Source_System_Detail__c ssd = new Source_System_Detail__c();
    static LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c();
    static User user;




    public static void init(){
    
        UserRole r = new UserRole(DeveloperName = 'ESC_Agent', Name = 'ESC_Agent');
        insert r;
        
        user = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = r.id,
             Sub_Bu__c = 'USL'
       );
       
       System.runAs(user){
        
            List<Account> listAccount = new List<Account>();
            listAccount = [select Name,Customer_Type__c, Customer_Group__c, Industry, SAPAccountNumber__c from Account where SAPAccountNumber__c = '1000550771'];
            //Account account = new Account();
            //   Account account1 = new Account();
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
            //Contact con = new Contact();
            con.LastName = 'Test Contact';
            con.FirstName = 'abc';
            con.ESC_OptOut_CSAT_Check__c = false;
            con.ESC_Frequency_Cap__c = 5;
            con.ESC_tocLanguage__c = 'English';
            insert con;
            
           
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
            
            ESIWebService2.Name = 'USL_OnePass';
            ESIWebService2.Active__c  = true;
            ESIWebService2.Endpoint__c = 'api.apigarden-qa.thomsonreuters.com/ebs/case/qa/getServiceNoteList';
            ESIWebService2.Max_GLI_Count__c = 10;
            ESIWebService2.Max_Non_GLI_Count__c = 10;
            ESIWebService2.Password__c = 'esidevuser123';
            ESIWebService2.Service_Unavailable_Message__c = 'testiuytre';
            ESIWebService2.Timeout__c = 120;
            ESIWebService2.Username__c = 'esidevuser';
            insert ESIWebService2;
            
            
            
            ssd.recordTypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
            ssd.name = 'testqwerty4321';
            ssd.Source_System_Name__c = 'sourceSystemNameruihvr';
            ssd.Account_Name__r = account1;
            ssd.Account_Name__c = account1.id;
            ssd.LCRM_Sales_Org__c = 'WEST';
            ssd.LCRM_Sub_BU__c = 'USL';
            insert ssd;
            
            conSSD.LCRM_Contact_ID__c = '10377042';
            conSSd.LCRM_Contact__c = con.id;
            conSSD.LCRM_Legacy_Contact_Type__c = 'sapwrp';
            conSSD.LCRM_Source_Contact_Id__c = '10377042';
            conSSD.Name = '1000167240';
            insert conSSD;
        }    
        
        
    
    }

      public static testmethod void testOnePass(){
    
        init();
        
        Test.startTest();
        
        System.runAs(user){
            pageReference pageOnePass = page.USL_OnePass;
            Test.setCurrentPage(pageOnePass);
            ApexPages.currentPage().getParameters().put('Id', conSSD.Id);        
            ApexPages.StandardController sc = new ApexPages.StandardController(conSSD);
    
            USL_OnePass onePass = new USL_OnePass(sc);
            USL_OnePassWS onePassWS = new USL_OnePassWS();
            
            
            String sampleJson = USL_OnePass.sampleResponse();
            USL_onePass.createTestData();
            JsonParser parser = JSON.createParser(sampleJson);
            //USL_onePass.parseJson(parser);
            
            
            Decimal[] decimalArray = new Decimal[]{10,20,30,40};
            USL_onePassWS.decimalArrayToStringList(decimalArray);
     
            
            /*USL_onePassWS.orgId = '00D2D0000008ajd';
            USL_onePassWS.getEndpoint();
            USL_onePassWS.orgId = '00D2D0000008bbZ';
            USL_onePassWS.getEndpoint();
            USL_onePassWS.orgId = '00D2a0000000PCR';
            USL_onePassWS.getEndpoint();
            USL_onePassWS.orgId = '00D1b0000008epn';
            USL_onePassWS.getEndpoint();
            USL_onePassWS.orgId = '00D30000000pLSL';
            USL_onePassWS.getEndpoint();  
            USL_onePassWS.orgId = '00D30000000pLSP';
            USL_onePassWS.getEndpoint();     
            */
            USL_onePassWS.buildJson();    
            USL_onePassWS.getDateString(Date.today()); 
            USL_onePassWS.getDateString(Date.newInstance(2000, 10, 5)); 
            USL_onePassWS.getDateString(Date.newInstance(2000, 5, 15)); 

            USL_onePassWS.parseErrorMessage(JSON.createParser(sampleJson)); 
            USL_onePassWS.getStatusCode(JSON.createParser(sampleJson));
            USL_OnePassWS.getOnePassFromJson(JSON.createParser(sampleJson),200);
            USL_OnePassWS.getOnePassFromJson(JSON.createParser(sampleJson),400);
            USL_onePassWS.parseActivityCodeItemList(JSON.createParser(sampleJson));
        
        }
  
        Test.stopTest();
    }
    

}