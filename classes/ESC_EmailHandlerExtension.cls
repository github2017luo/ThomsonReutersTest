public class ESC_EmailHandlerExtension {
public EmailMessage emailmsg ;

    public ESC_EmailHandlerExtension(ApexPages.StandardController controller) {
         if (!Test.isRunningTest())
       {
           controller.addFields(new List<string>{'parentid','ESC_ReadByOwner__c','ESC_Read_By_Accountable_Resolver__c'});
       }
       emailmsg = (EmailMessage)controller.getRecord();
      
    }
    
    public void updateLogsForPushTopic(){
        
         ESC_PushTopicHelperObj.populateLogs(emailmsg , 'Email Read By');
    }
    
   
}