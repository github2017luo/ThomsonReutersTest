/********************************************************************************
Class Name : UEDeleteAttachmentService_Test
@description : Test Class of UEDeleteAttachmentService
********************************************************************************
Modification Details:
Date                    Description                     Owner
24/09/2020              Created                         Herin Acharya
28/05/2021              Reframing new testclass         Deepthi KB
                        for delete attachment
                        DUE-10968
*********************************************************************************/

@isTest
private class UEDeleteAttachmentService_Test{
 /********************************************************************************
    Method Name : setup
    @description : To create test data for case creation (Account ,Source_System_Detail__c,Contact,Product2)
    *********************************************************************************/
    @testSetup 
     static void setup(){
      
        Account objAcc = new Account();
        objAcc.Name='Test';
        objAcc.AccountNumber ='12345';
        objAcc.Sales_Org__c = 'GLI';
        objAcc.BU_Region__c='US';
        objAcc.Bu_Segment__c='Professional Legal';
        insert objAcc;  
         
             
        Source_System_Detail__c objLCRMSSD = new Source_System_Detail__c();
        objLCRMSSD.Account_name__c = objAcc.id;
        objLCRMSSD.Name = 'TestLcrmAccName';
        objLCRMSSD.Source_System_Name__c = 'TestSAP';
        objLCRMSSD.Source_System_Account_Number__c = '123456'; 
        objLCRMSSD.Account_Name__c = objAcc.id;
        insert objLCRMSSD;
         
        Contact objContact = new contact();
        objContact.AccountId = objAcc.id;
        objContact.FirstName = 'TestFirstName';
        objContact.LastName = 'TestLastName';
        objContact.Email = 'Test@gmail.com';
        Insert objContact;
         
        Product2 objPro = new Product2();
        objPro.name = 'LEGALONE CORPORATE BSUB';
        insert objPro;
         
        User userObj = new User();
        userObj.ProfileId = [SELECT Id FROM Profile WHERE Name ='System Administrator'].Id;
        userObj.FirstName = 'ESI';
        userObj.LastName = 'User';
        userObj.Username = 'ESIUsertest@test.com';
        userObj.alias = 'fakeESI';
        userObj.email = 'ESIUsertest@test.com';
        userObj.localesidkey='en_US';
        userObj.emailencodingkey='UTF-8';
        userObj.languagelocalekey='en_US';
        userObj.localesidkey='en_US';
        userObj.timezonesidkey= 'America/Los_Angeles';
        insert userObj;
         
        List<Case> allCases = new List<Case>();
        Case objCase = new Case();
        objCase.contactId = objContact.id;
        objCase.AccountId = objAcc.id;
        objCase.LCRM_Account_SSD__c = objLCRMSSD.id;
        objCase.subject = 'I cannot access the product';
        objCase.Description = 'TestDiscription';
        objCase.MYTR_Query_Type__c = 'I cannot access the product';
        objCase.SuppliedPhone = '912345678';
        objCase.ESC_Origin_Name__c= 'Sample URL';
        objCase.Origin = MTRCommonUtility.MYTR_ORIGIN;   
        objCase.UE_Language_Locale__c = 'en-us';
        allCases.add(objCase);
         
        insert allCases;
        
        System.runAs(userObj){
            LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
            insert test2;
            List<Contentversion> cv = new List<Contentversion>();
            Contentversion objCV1 = new Contentversion();
            objCV1.VersionData = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAABj8AAAOACAYAAABlnmGhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP');
            system.debug(LoggingLevel.DEBUG,'objCV1.VersionData---'+objCV1.VersionData);
            objCV1.Title = 'ContnetVersion1';
            objCV1.PathOnClient = 'ContnetVersion1.PNG';
            objCV1.FirstPublishLocationId = objCase.id;
            system.debug(LoggingLevel.DEBUG,'objCV1---'+objCV1.id);
            cv.add(objCV1);
                        
            Contentversion objCV2 = new Contentversion();
            objCV2.VersionData = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAABj8AAAOACAYAAABlnmGhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP');
            objCV2.Title = 'ContnetVersion2';
            objCV2.PathOnClient = 'ContnetVersion2.PNG';
            system.debug(LoggingLevel.DEBUG,'objCV2---'+objCV2.id);
            cv.add(objCV2);
            
            Contentversion objCV3 = new Contentversion();
            objCV3.VersionData = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAABj8AAAOACAYAAABlnmGhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP');
            objCV3.Title = 'ContnetVersion2';
            objCV3.PathOnClient = 'ContnetVersion3.PNG';
            cv.add(objCV3);
            
            insert cv;
            system.debug(LoggingLevel.DEBUG,'listCV---'+cv);
            
            FeedItem objFeedItem1 = new FeedItem();
            objFeedItem1.ParentId = objCase.id;
            objFeedItem1.Body = 'Test Comment';
            objFeedItem1.Type = 'ContentPost';
            objFeedItem1.RelatedRecordId = objCV1.id;
            insert objFeedItem1;
            
            
            //FeedItem DeleteItem = new FeedItem();
            //DeleteItem.ParentId = objCase.id;
            //DeleteItem.Body = 'Delete Feed';
            //DeleteItem.Type = 'ContentPost';
            //DeleteItem.RelatedRecordId = objCV3.id;
            //insert DeleteItem;
            
            
            FeedAttachment objFA = new FeedAttachment();
            objFA.FeedEntityId = objFeedItem1.id;
            objFA.RecordId = objCV2.id;
            objFA.Type = 'CONTENT';
            insert objFA;
           
            list<Contentversion> listCV= [Select id,contentdocumentId from Contentversion];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
        } 
        
                  
     }

    /********************************************************************************
    Method Name : testSampleDeleteAttachReq
    @description : TO create sample JSON request. By using this we will not need to write sample request multiple times for diffrent test scenarios
    @param json
    @return RestRequest
    *********************************************************************************/
    public static RestRequest testSampleDeleteAttachReq (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/UEDeleteAttachmentService/';
        request.httpMethod = 'DELETE';       
        RestContext.request = request;
        return request;
    }
     /********************************************************************************
    Method Name : testSampleRestRequest
    @description : TO create sample JSON request. By using this we will not need to write sample request multiple times for diffrent test scenarios
    @param json
    @return RestRequest
    *********************************************************************************/
   
    public static RestRequest testSampleRestRequest (string json){
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueof(json);
        request.requestUri ='/services/apexrest/UEDeleteAttachmentService/';
        request.httpMethod = 'DELETE';       
        RestContext.request = request;
        return request;
    }
    
    
    @isTest 
    private static void testDoPostSuccessScenarios1(){
        test.starttest();
        User userObj = [Select id,firstname,lastname,name from user where firstname = 'ESI' and lastname = 'User' and Username = 'ESIUsertest@test.com' limit 1];
        system.debug(LoggingLevel.DEBUG,'userObj---'+userObj);
        System.runAs(userObj){
            Contact objContact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
            
            case objCase = [Select id from case where contactid =:objContact.id and ESC_Product_Segment_Brand__c NOT IN ('Risk')];
            
            FeedItem objFeed = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'ContentPost'];
            system.debug(LoggingLevel.DEBUG,'objFeed---'+objFeed.createdby.firstname+ +objFeed.createdby.lastname);
            //FeedItem objFeed1 = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'TextPost'];
                    
            list<Contentversion> listCV= [Select id,contentdocumentId from Contentversion order by createddate];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
            
            /*//dkb list<FeedAttachment> listFA = [Select id,FeedEntityId,RecordId from FeedAttachment where FeedEntityId=:objFeed.id and 
                                          RecordId =:listCV[0].id ];  
            system.debug(LoggingLevel.DEBUG,'listFA---'+listFA);
            */
            if(listCV.size()>0){
            UEDeleteAttachmentService.deleteFeedWrapper objdeleteRequestWrapper = new UEDeleteAttachmentService.deleteFeedWrapper();
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = objFeed.id;
            list<ContentDocument> listCd= [SELECT id,OwnerId,owner.name FROM ContentDocument where id=: listCV[0].contentdocumentId WITH SECURITY_ENFORCED LIMIT 1];
            system.debug(LoggingLevel.DEBUG,'Listcd owneername---'+listCd[0].owner.name);
            //Use for deleted feed item
           // FeedItem deleteItem= [Select id,createdby.firstname,createdby.lastname from FeedItem where Body = ''];
            UEDeleteAttachmentService.deleteFeedWrapper objdeleteRequestWrapper1 = new UEDeleteAttachmentService.deleteFeedWrapper();
            objdeleteRequestWrapper1.contentDocumentId = listCV[1].contentdocumentId;
            objdeleteRequestWrapper1.contentVersionId = listCV[1].id;
                             
            String jsonMsg;
                        
            RestRequest request = new RestRequest();
            UEDeleteAttachmentService.deleteFeedResponseMessage response = new UEDeleteAttachmentService.deleteFeedResponseMessage();
                        
            objdeleteRequestWrapper1.feedItemId = objfeed.id; 
            jsonMsg=JSON.serialize(objdeleteRequestWrapper1);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UEDeleteAttachmentService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            System.AssertEquals(response.isSuccess,true,'Attachment Deleted Successfully');
                        
            //TO throw exception - DeleteItem
                        
            //error scenario 1 - Improper Format
            objdeleteRequestWrapper = new UEDeleteAttachmentService.deleteFeedWrapper();
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = '';
            
            jsonMsg = JSON.serialize(objdeleteRequestWrapper);
            response = new UEDeleteAttachmentService.deleteFeedResponseMessage();
            request = new RestRequest();
            request = testSampleDeleteAttachReq(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT');
            response = UEDeleteAttachmentService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            System.AssertEquals(response.isSuccess,false,MTRCommonUtility.IMPROPER_REQUEST_FORMAT);
            
            //error scenario 1.a
            objdeleteRequestWrapper.feedItemId = '66666';
            jsonMsg = JSON.serialize(objdeleteRequestWrapper);
            response = new UEDeleteAttachmentService.deleteFeedResponseMessage();
            request = new RestRequest();
            request = testSampleDeleteAttachReq(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT');
            response = UEDeleteAttachmentService.deleteServices();
                           
            //error scenario 2 - Incorrect Operation            
            jsonMsg = JSON.serialize(objdeleteRequestWrapper);
                
            response = new UEDeleteAttachmentService.deleteFeedResponseMessage();
            request = new RestRequest();
            request = testSampleDeleteAttachReq(jsonMsg);
            request.addParameter('operation', 'SomeBadvalue');
            system.debug(LoggingLevel.DEBUG,'request---'+request);
            response = UEDeleteAttachmentService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            System.AssertEquals(response.isSuccess,false,'INCORRECT OPERATION');
            }    
        }
        test.stopTest();
    }
    
    
    @isTest 
    private static void testDeleteNoBodyPost(){
        test.starttest();
        User userObj = [Select id,firstname,lastname,name from user where firstname = 'ESI' and lastname = 'User' and Username = 'ESIUsertest@test.com' limit 1];
        system.debug(LoggingLevel.DEBUG,'userObj---'+userObj);
        System.runAs(userObj){
            Contact objContact = [select id,Email from Contact where FirstName = 'TestFirstName' limit 1];
            
            case objCase = [Select id from case where contactid =:objContact.id and ESC_Product_Segment_Brand__c NOT IN ('Risk')];
            
            FeedItem objFeed = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'ContentPost'];
            objFeed.Body = '';
            update objFeed;
            system.debug(LoggingLevel.DEBUG,'objFeed---'+objFeed);
            //FeedItem objFeed1 = [Select id,createdby.firstname,createdby.lastname from FeedItem where ParentId =: objCase.id and type = 'TextPost'];
                    
            list<Contentversion> listCV= [Select id,contentdocumentId from Contentversion order by createddate];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
            
            /*//dkb list<FeedAttachment> listFA = [Select id,FeedEntityId,RecordId from FeedAttachment where FeedEntityId=:objFeed.id and 
                                          RecordId =:listCV[0].id ];
            //dkb system.debug(LoggingLevel.DEBUG,'listFA---'+listFA); */

            if(listCV.size()>0){
            UEDeleteAttachmentService.deleteFeedWrapper objdeleteRequestWrapper = new UEDeleteAttachmentService.deleteFeedWrapper();
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = objFeed.id;
           
            String jsonMsg;
            RestRequest request = new RestRequest();
            UEDeleteAttachmentService.deleteFeedResponseMessage response = new UEDeleteAttachmentService.deleteFeedResponseMessage();
            
            
            objdeleteRequestWrapper.feedItemId = objfeed.id; 
            jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UEDeleteAttachmentService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            System.AssertEquals(response.isSuccess,true,'Attachment Deleted Successfully');
            
            //delete second doc
            listCV= [Select id,contentdocumentId from Contentversion order by createddate];
            system.debug(LoggingLevel.DEBUG,'listCV---'+listCV);
            
           /* //dkb listFA = [Select id,FeedEntityId,RecordId from FeedAttachment where FeedEntityId=:objFeed.id and 
                                          RecordId =:listCV[0].id ];  
            system.debug(LoggingLevel.DEBUG,'listFA---'+listFA); */
            objdeleteRequestWrapper.contentDocumentId = listCV[0].contentdocumentId;
            objdeleteRequestWrapper.contentVersionId = listCV[0].id;
            objdeleteRequestWrapper.feedItemId = objFeed.id;
            
            jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UEDeleteAttachmentService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            response = UEDeleteAttachmentService.deleteServices();
            System.AssertEquals(response.isSuccess,false,'Attachment Deleted');
            
            //Do error
             objdeleteRequestWrapper.feedItemId = '66666666';
            
            jsonMsg=JSON.serialize(objdeleteRequestWrapper);
            request = TestSampleRestRequest(jsonMsg);
            request.addParameter('operation', 'DELETEATTACHMENT'); 
            response = UEDeleteAttachmentService.deleteServices();
            system.debug(LoggingLevel.DEBUG,'response---'+response);
            response = UEDeleteAttachmentService.deleteServices();
            System.AssertEquals(response.isSuccess,false,'Invalid feeditemid');
        
            }
        }
        test.stopTest();
    }
    
    
}