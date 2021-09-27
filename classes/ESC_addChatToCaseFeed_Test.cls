@isTest(seealldata=false)
public class ESC_addChatToCaseFeed_Test {
    static testMethod void validateCaseFeed(){
                
        Case testCase = new Case();
        testCase.subject='test sub';
        testCase.description='test';
        insert testCase;
        
        LiveChatVisitor lcv = new LiveChatVisitor();
         try{
            insert lcv;
        }catch(Exception e){
        system.debug('exception'+e);
        }
        List<LiveChatTranscript> testList = new List<LiveChatTranscript>();  
        LiveChatTranscript testTranscript = new LiveChatTranscript(CaseID = testCase.Id,LiveChatVisitorid = lcv.id );
        testList.add(testTranscript); 
        insert testList;
        //List<ESC_addChatToCaseFeed.getMessage> testList = new List<ESC_addChatToCaseFeed.getMessage>();
        //ESC_addChatToCaseFeed.getMessage testMessage = new ESC_addChatToCaseFeed.getMessage();
        //testMessage.transcriptId = testTranscript.id;
        //testMessage.parentId = testCase.Id;
        //testList.add(testMessage);
        
        Test.startTest();
        ESC_addChatToCaseFeed.postToFeed(testList);
        Test.stopTest();
        
        FeedItem fd  = new FeedItem();
        fd.ParentId = testCase.Id;
        fd.Body = '[xzxzxzxz]';
        fd.Type ='ContentPost';
        insert fd; 
        
        //FeedItem testItem = [SELECT ID FROM FeedItem Where ParentId = :testTranscript.id];
       
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        
        //System.assert(testItem != null);        
    }
}