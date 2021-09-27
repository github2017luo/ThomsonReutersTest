@isTest
public class CaseManagementImplmentsTest {
    @testSetup
     static void setup(){
        Account obj_acc = new Account();
        obj_acc.Name='TestAccount';
        obj_acc.AccountNumber ='12345678';
        insert obj_acc;     
         
        Contact obj_contact = new contact();
        obj_contact.FirstName = 'TestFirstName';
        obj_contact.LastName = 'TestLastName';
        obj_contact.Email = 'testaccount@gmail.com';
        insert obj_contact;
        
        Case obj_case = new Case();
        obj_case.Description='Test description';
        obj_case.Status='New';
        obj_case.Origin='Phone';
        obj_case.Priority='Medium';
        obj_case.ContactId =obj_contact.id;
        insert obj_case;
                 
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test.png';
        cv.PathOnClient = 'Test.png';
        cv.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'); 
        insert cv;
         
        FeedItem ObjFeedItem = new FeedItem();
        ObjFeedItem.ParentId = obj_case.id; //eg. case id, custom object id..       
        ObjFeedItem.Status ='Published';
        ObjFeedItem.Visibility = 'AllUsers';
        ObjFeedItem.Body = 'Test Commnets'; 
        ObjFeedItem.Type = 'ContentPost';
        ObjFeedItem.RelatedRecordId = cv.id;
        insert ObjFeedItem;

    }
    
    @isTest 
    private static void testdoGet1() {
        
        test.starttest();
        
        ContentVersion Obj_attache = [SELECT Id FROM ContentVersion Where Title = 'Test.png' limit 1];
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/download/'+ Obj_attache.id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<String> downloadlist = CaseManagementImplments.doGet();
       CaseManagementImplments.doGet();
        // Verify results
       System.assert(downloadlist!= null);
        
        test.stoptest();
        
    }
    
}