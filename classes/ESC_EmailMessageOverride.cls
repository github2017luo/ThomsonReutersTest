public class ESC_EmailMessageOverride{
public EmailMessage emailmsg ;

      public ESC_EmailMessageOverride(ApexPages.StandardController controller) {
                if (!Test.isRunningTest())
              {
                     controller.addFields(new List<string>{'parentid','ESC_ReadByOwner__c','ESC_Read_By_Accountable_Resolver__c'});
                  }
               emailmsg = (EmailMessage)controller.getRecord();
      
    }
    
    public PageReference updateLogsForPushTopic(){
        
         ESC_PushTopicHelperObj.populateLogs(emailmsg, 'Email Read By');
         System.debug('populateLogs: '+emailmsg.id );
         PageReference pageRef = new PageReference('/'+emailmsg.id+'?nooverride=1'); 
         pageRef.setRedirect(true);
         return pageRef;
  
    }
    
   
}