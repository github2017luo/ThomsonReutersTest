@isTest
private class CaseManagementServiceTest {
    
    @testSetup 
     static void setup(){
        Account obj_acc = new Account();
        obj_acc.Name='Test';
        obj_acc.AccountNumber ='12345';
        obj_acc.Sales_Org__c = 'GLI';
        insert obj_acc;     
        
        /*
        Source_System_Detail__c obj_LCRMSSD = new Source_System_Detail__c();
        obj_LCRMSSD.Account_name__c = obj_acc.id;
        obj_LCRMSSD.Name = 'TestLcrmAccName';
        obj_LCRMSSD.Source_System_Name__c = 'TestSAP';
        obj_LCRMSSD.Source_System_Account_Number__c = '123456'; 
        obj_LCRMSSD.Account_Name__c = obj_acc.id;
        insert obj_LCRMSSD; */
         
        Contact obj_contact = new contact();
        obj_contact.AccountId = obj_acc.id;
        obj_contact.FirstName = 'TestFirstName';
        obj_contact.LastName = 'TestLastName';
        obj_contact.Email = 'Test@gmail.com';
        Insert obj_contact;
         
        Case obj_case = new Case();
        obj_case.Description='Testdata';
        obj_case.Status='New';
        obj_case.Origin='Phone';
        obj_case.Priority='Medium';
        obj_case.ContactId =obj_contact.id;
        obj_case.accountId = obj_acc.id;
        obj_case.Subject = 'Test';
        obj_case.MYTR_Category__c    = 'Test Category';
        obj_case.MYTR_Query_Type__c = 'Test QueryType';
        obj_case.Product__C = 'CheckPoint';
        obj_case.ESC_Impact__c = '1 - Whole Site';
        obj_case.ESC_Diagnosis_Summary__c = 'Access Details';
        obj_case.ESC_Cause__c ='Missing Information to Customer';
        obj_case.ESC_Resolution_Code__c = 'Answered by Email';
        insert obj_case;
                  
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test.png';
        cv.PathOnClient = 'Test.png';
        cv.VersionData = EncodingUtil.base64Decode('Test'); 
        insert cv;
         
        FeedItem ObjFeedItem = new FeedItem();
        ObjFeedItem.ParentId = obj_case.id; //eg. case id, custom object id..       
        ObjFeedItem.Status ='Published';
        ObjFeedItem.Visibility = 'AllUsers';
        ObjFeedItem.Body = 'Test Commnets'; 
        ObjFeedItem.Type = 'ContentPost';
        ObjFeedItem.RelatedRecordId = cv.id;
        insert ObjFeedItem;
         
        Product2 obj_pro = new Product2();
        obj_pro.name = 'LaLey 4.0 Comercial';
        insert obj_pro;
     
        string settingName = 'I_cannot_access_the_product';
        MyTr_Case_Record_Type_Setting__mdt supportSetting = 
                          [Select id,MasterLabel,DeveloperName,Case_Record_Sub_Type__c,Case_Record_Type__c,Case_Type__c,
                          Record_Type_Developer_Name__c,English__c,Portuguese__c,Spanish__c from 
                          MyTr_Case_Record_Type_Setting__mdt WHERE DeveloperName = : settingName  ]; 
                            
                                 
     }
    
    public static CaseManagementService.Attach TestDatForAttachment()  {
        CaseManagementService.Attach obj_attach = new CaseManagementService.Attach();
        obj_attach.Body ='Test';
        obj_attach.ContentType = 'text/plain';
        obj_attach.Name = 'Test.txt';
        
        return obj_attach;
    }  
    
    public static CaseManagementService.caseNew TestDataforCase(){
                
        Contact obj_Contact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
        system.debug('obj_Contact---'+obj_Contact);
        Product2 obj_pro = [select id,name from product2 where name = 'LaLey 4.0 Comercial' limit 1];
        
        CaseManagementService.caseNew obj_caseNew = new CaseManagementService.caseNew ();
        obj_caseNew.CategoryType = 'Billing Admin';
        obj_caseNew.ContactId = obj_Contact.id;
        obj_caseNew.CompanyName = 'TATA';
        obj_caseNew.EmailAddress = obj_Contact.Email;
        obj_caseNew.subject = 'I cannot access the product';
        obj_caseNew.Description = 'TestDiscription';
        obj_caseNew.QueryType = 'I cannot access the product';
        obj_caseNew.businessUnit= 'LaTAm';
        obj_caseNew.Product = 'Checkpoint';
        obj_caseNew.CaseComments = 'Query by customer';
        obj_caseNew.IsoCountrycode='AR-en';
        obj_caseNew.ProdusctsList='LaLey 4.0 Comercial';
        obj_caseNew.OnlineUserFirstName='OnlineUser FN';
        obj_caseNew.OnlineUserLastName='OnlineUser LN';
        obj_caseNew.OnlineUserEmail='onlineuser@gmail.com';
        //obj_caseNew.ProdusctsList = obj_pro.name;
        obj_caseNew.ProductAdditionalInfo = 'Test Additional Info';
        obj_caseNew.OnlineUserNamesToDelete = 'Test User NAme';
        obj_caseNew.RemovingAccessToProducts = 'Yes';
        
        return obj_caseNew;
    }
    
    public static RestRequest TestSampleRestRequest (string Json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(Json);
        request.requestUri ='/services/apexrest/caseManagement/';
        request.httpMethod = 'POST';       
        RestContext.request = request;       
        return request;
    }
    
    @isTest 
    private static void testDoPost(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPost1(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        //obj_caseNew1.businessUnit= 'UKI';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPost2(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.businessUnit= 'GGO';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPost3(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.businessUnit= 'LatAm';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPost4(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.businessUnit= 'WEST';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPost5(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        //obj_caseNew1.LCRMAccountSSD = '123478';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    
    @isTest 
    private static void testDoPost6(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.EmailAddress = 'asdf@gmail.com';
                
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    @isTest 
    private static void testDoPost7(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
          
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
    @isTest 
    private static void testDoPost8(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.ProdusctsList='LaLey 4.0 Administrativo;LaLey 4.0 Comercial';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    } 
    
    @isTest 
    private static void testDoPost9(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.OnlineUserFirstName = 'TestFname';
        obj_caseNew1.OnlineUserLastName = 'TestLname';
        obj_caseNew1.OnlineUserEmail = 'test@gmail.com';
        //obj_caseNew1.ProdusctsList='LaLey 4.0 Administrativo;LaLey 4.0 Comercial';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        //reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    } 
    
     @isTest 
    private static void testDoPost10(){
        test.starttest();                       
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew1 = TestDataforCase();
        obj_caseNew1.OnlineUserFirstName = 'TestFirstName1';
        obj_caseNew1.OnlineUserLastName = 'TestLastName1';
        obj_caseNew1.OnlineUserEmail = 'test1@gmail.com';
        //obj_caseNew1.ProdusctsList='LaLey 4.0 Administrativo;LaLey 4.0 Comercial';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew1;
        //reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = TestSampleRestRequest(JsonMsg);    
        CaseManagementService.doPost();        
        test.stopTest();
        
    }
     /*
    @isTest 
    private static void testDoPut(){
        test.starttest();
        
        Case Obj_case1 =  [Select id,casenumber From Case Where Status ='New' limit 1];                
        List <CaseManagementService.Attach> lstAttach=new List<CaseManagementService.Attach>();
        
        CaseManagementService.Attach obj_attach1 = TestDatForAttachment();
        lstAttach.add(obj_attach1);
        
        CaseManagementService.caseNew obj_caseNew = new CaseManagementService.caseNew ();
        obj_caseNew.CategoryType = 'Billingd';
        obj_caseNew.CompanyName = 'TATA';
        obj_caseNew.subject = 'TestSubject';
        
        CaseManagementService.CaseObject reqst=new CaseManagementService.CaseObject();
        reqst.cases=obj_caseNew;
        reqst.attachments=lstAttach;
   
        String JsonMsg=JSON.serialize(reqst);
        system.debug('JsonMsg---'+JsonMsg);
       
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/caseManagement/'+Obj_case1.casenumber;
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = request;
        
        CaseManagementService.addComment();        
        test.stopTest();
        
    }
     */
    
    @isTest 
    private static void testGetCaseList(){
        test.startTest();
        
        Case Obj_case1 =  [Select id,casenumber From Case Where Status ='New' limit 1];
        Contact obj_Contact = [select id,email from Contact where FirstName = 'TestFirstName' limit 1];
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/caseManagement/';
        request.addParameter('contactId', obj_Contact.id);
        request.addParameter('caseNo', Obj_case1.casenumber);
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        system.debug('request.requestUri----'+request.requestUri);
        List<CaseWrapper> thisCase = CaseManagementService.doGet();
        System.assert(thisCase != null);
        test.stopTest();
      
    }
    
    @isTest 
    private static void testGetCaseList1(){
        test.startTest();
        
        Case Obj_case1 =  [Select id,casenumber From Case Where Status ='New'];
        Contact obj_Contact = [select id,email from Contact where FirstName = 'TestFirstName' limit 1];
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/caseManagement/';
        request.addParameter('caseNo', '');
        request.addParameter('contactId', obj_Contact.id);
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        system.debug('request.requestUri----'+request.requestUri);
        List<CaseWrapper> thisCase = CaseManagementService.doGet();
        System.assert(thisCase != null);
        test.stopTest();
      
    }
   
    @isTest 
    private static void testGetCaseList2(){
        test.startTest();
        
        Case Obj_case1 =  [Select id,casenumber From Case Where Status ='New'];
        Obj_case1.Status = 'Closed';
        update Obj_case1;
        
        CaseHistory objCH = new CaseHistory();
        objCH.Field = 'Status';
        objCH.CaseId =Obj_case1.id;
        insert objCH;
        
        Case Obj_case2 =  [SELECT Id,ContactEmail,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,
                           Subject,ESC_Customer_Symptom__c,Product__c,ESC_Diagnosis_Summary__c,Account.Name,
                           contact.phone,contact.name,Source.name,MYTR_Query_Type__c,AccountId,ContactId,
                           Description,Owner.Name,Account.SAPAccountNumber__c,ESC_Resolution_Comment__c,
                           ESC_Cause__c,ESC_Resolution_Code__c,ClosedDate,ContactPhone,ContactMobile,Status,
                           MYTR_Category__c ,Reason__c,Priority,ESC_Impact__c,Follow_Up_Date__c,Due_DateTime__c,
                           (SELECT Id,title,body,RelatedRecordId,type,Visibility,LastModifiedDate,CreatedBy.name 
                           from feeds where (type ='ContentPost' OR type = 'TextPost') ORDER BY LastModifiedDate Desc),
                           (SELECT id,Field,NewValue,oldvalue,createddate,createdbyid,createdBy.Name from 
                            Histories where  field = 'Status' order by createddate desc limit 1) 
                           From case where casenumber =: Obj_case1.CaseNumber];
        
        system.debug('Obj_case2---'+Obj_case2);
        system.debug('Obj_case2HistoryRecord---'+Obj_case2.Histories);
        
        CaseHistory CH =  [Select id, Field, OldValue, NewValue from CaseHistory where CaseId = :Obj_case1.id limit 1];
        system.debug('CH---'+CH);
        //Contact obj_Contact = [select id,email from Contact where FirstName = 'TestFirstName' limit 1];
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/caseManagement/';
        request.addParameter('caseNo', Obj_case2.casenumber);
        request.addParameter('contactId','');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        system.debug('request.requestUri----'+request.requestUri);
        List<CaseWrapper> thisCase = CaseManagementService.doGet();
        System.assert(thisCase != null);
        test.stopTest();
      
    }
    
 
    
}