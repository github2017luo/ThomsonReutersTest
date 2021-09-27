@IsTest
private class CaseResourceLatamTest
{      
    @testSetup 
     static void setup(){
        Account obj_acc = new Account();
        obj_acc.Name='Test';
        obj_acc.SAPAccountNumber__C ='12345';
        obj_acc.Sales_Org__c = 'GLI';
        insert obj_acc;     
        
        /*
        Source_System_Detail__c obj_lcrm = new Source_System_Detail__c();
        obj_lcrm.Account_name__c = obj_acc.id;
        obj_lcrm.Name = 'TestLcrmAccName';
        obj_lcrm.Source_System_Name__c = 'TestSAP';
        insert obj_lcrm;
        */
         
        Contact obj_contact = new contact();
        obj_contact.accountId = obj_acc.id;
        obj_contact.FirstName = 'TestFirstName';
        obj_contact.LastName = 'TestLastName';
        obj_contact.Email = 'Test@gmail.com';
        Insert obj_contact;
        
        Case obj_case = new Case();
        obj_case.Description='Testdata';
        obj_case.Status='New';
        obj_case.Origin='Phone';
        obj_case.Priority='Medium';
        obj_case.AccountId = obj_acc.id;
        obj_case.ContactId =obj_contact.id;
        obj_case.MYTR_Category__c    = 'Billing Admin';
        obj_case.LCRM_Sub_BU__c = 'Latam';
        insert obj_case;
                  
     }
    
    public static CaseResourceLatam.Attach TestDatForAttachment()  {
        CaseResourceLatam.Attach obj_attach = new CaseResourceLatam.Attach();
        obj_attach.Body ='Test';
        obj_attach.ContentType = 'text/plain';
        obj_attach.Name = 'Test.txt';
        
        return obj_attach;
    }  
    
    public static CaseResourceLatam.caseDetails TestDataforCase(){
        
        /*Source_System_Detail__c obj_SSD = [select id,Account_name__c,Account_name__r.Sales_Org__c,LCRM_Sales_Org__c from Source_System_Detail__c where Name = 'TestLcrmAccName'
                                           limit 1];*/
                                           
        Contact obj_Contact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
        
        CaseResourceLatam.caseDetails obj_caseNew = new CaseResourceLatam.caseDetails ();
        obj_caseNew.CategoryType = 'Billing Admin';
        obj_caseNew.ContactId=obj_Contact.Id;
        obj_caseNew.CompanyName = 'TATA';
        obj_caseNew.subject = 'TestSubject';
        obj_caseNew.Description = 'TestDiscription';
        obj_caseNew.QueryType = 'TestQueryType';
        obj_caseNew.businessUnit= 'LatAm';
        obj_caseNew.CaseComments = 'Query Comments';
        return obj_caseNew;
    }
    
    
    @isTest 
    private static void testdoGet() {
        
        test.starttest();
        Case Obj_case1 =  [Select id,MYTR_Category__c,ContactId,Account.SAPAccountNumber__C  From Case Where Status ='New' limit 1];
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/createCaseLatam/';
        request.addParameter('contactId', Obj_case1.ContactId);
        request.addParameter('category', Obj_case1.MYTR_Category__c );
        request.addParameter('accountNo', Obj_case1.Account.SAPAccountNumber__C);        
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<CaseWrapper> thisCase = CaseResourceLatam.doGet();
        System.assert(thisCase != null);
        test.stoptest();
        
    }
    
    @isTest 
    private static void testdoGet1() {
        
        test.starttest();
        Case Obj_case1 =  [Select id,MYTR_Category__c,ContactEmail,Account.SAPAccountNumber__C From Case Where Status ='New' limit 1];
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/createCaseLatam/';
        request.addParameter('category', Obj_case1.MYTR_Category__c );
        request.addParameter('accountNo', Obj_case1.Account.SAPAccountNumber__C );
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<CaseWrapper> thisCase = CaseResourceLatam.doGet();
        System.assert(thisCase != null);
        test.stoptest();
        
    }
    
    @isTest 
    private static void testdoGet2() {
        
        test.starttest();
        Case Obj_case1 =  [Select id,MYTR_Category__c,ContactId From Case Where Status ='New' limit 1];
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/createCaseLatam/';
        request.addParameter('contactId', Obj_case1.contactId);
        request.addParameter('category', Obj_case1.MYTR_Category__c );
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<CaseWrapper> thisCase = CaseResourceLatam.doGet();
        System.assert(thisCase != null);
        test.stoptest();
        
    }

    @isTest 
    private static void testDoPOST(){
        test.starttest();
        
        Case Obj_case1 =  [Select id,casenumber From Case Where Status ='New'];                
        List <CaseResourceLatam.Attach> lstAttach=new List<CaseResourceLatam.Attach>();
        
        CaseResourceLatam.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseResourceLatam.caseDetails obj_caseNew1 = TestDataforCase ();
        
        CaseResourceLatam.currentCaseect reqst=new CaseResourceLatam.currentCaseect();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/createCaseLatam/'+Obj_case1.casenumber;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = request;
        
        CaseResourceLatam.addComment();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPOST1(){
        test.starttest();
        
        Case Obj_case1 =  [Select id,casenumber From Case Where Status ='New'];                
        List <CaseResourceLatam.Attach> lstAttach=new List<CaseResourceLatam.Attach>();
        
        CaseResourceLatam.Attach obj_attach1 = TestDatForAttachment();
        CaseResourceLatam.Attach obj_attach2 = TestDatForAttachment();
        obj_attach2.name = 'Test123.png';
        lstAttach.add(obj_attach2);
        lstAttach.add(obj_attach1);
        
        CaseResourceLatam.caseDetails obj_caseNew1 = TestDataforCase ();
        obj_caseNew1.EmailIdOfUser=null;
        
        CaseResourceLatam.currentCaseect reqst=new CaseResourceLatam.currentCaseect ();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/createCaseLatam/'+Obj_case1.casenumber;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = request;
        
        CaseResourceLatam.addComment();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPOST2(){
        test.starttest();
                 
        List <CaseResourceLatam.Attach> lstAttach=new List<CaseResourceLatam.Attach>();
        
        CaseResourceLatam.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseResourceLatam.caseDetails obj_caseNew1 = TestDataforCase ();     
        CaseResourceLatam.currentCaseect reqst=new CaseResourceLatam.currentCaseect ();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/createCaseLatam/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = request;
        
        CaseResourceLatam.addComment();        
        test.stopTest();
        
    }
    

}