/***************************************************************************************************
DPS-19692 : Added LMLeadTrigger triger logic into LeadBeforeEventListener trigger as part of Triggers Logic Optimization JIRA
DPS-19692 : Deactivated This Trigger
****************************************************************************************************/
trigger LMLeadTrigger on Lead (before insert, before update,after insert,after Update) {

//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}
    LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler();
    LeadRepAssignmentHandler oLeadRepAssignmentHandler = new LeadRepAssignmentHandler();
    LIST<String> EloquaUserList= new LIST<String>();         
    SET<String> EloquaUserSet= new SET<String>();  
    //public integer count=0;
    private static final String USERNAME_TRLEGALUS_ELOQUA = 'TRLegalUS Eloqua';
     //added loggedInUser as part of mcl-2193
    string loggedInUser = system.label.UserLoggedIn;
     
    // Default lead values to minimize Lead creation JIRA# ILM-10    
    
    if(trigger.IsBefore){
        if(UserInfo.getName() == USERNAME_TRLEGALUS_ELOQUA || loggedInUser.contains(UserInfo.getName()) || checkRecursive.runOnce())
        {
            //system.debug('***count' + count+1); 
            if( trigger.IsInsert || trigger.IsUpdate) {    
                oLeadTriggerHandler.IsHoliday(trigger.new,trigger.newmap,trigger.oldmap, trigger.IsInsert,trigger.IsUpdate); 
                oLeadTriggerHandler.setSLAFromSLAAdminTable(trigger.new,trigger.newmap,trigger.oldmap, trigger.IsInsert,trigger.IsUpdate);
                oLeadTriggerHandler.UpdateSalesRegionalMAnager(trigger.new,trigger.newmap,trigger.oldmap, trigger.IsInsert,trigger.IsUpdate);
                //Dev3 env code.
                //oLeadRepAssignmentHandler.leadRepAssigmentProcess(trigger.new);
                
               /* EloquaUserList= ILMGeneral__c.getValues('AllowedUsersForSalesRepAssignment').value__c.split(';');
                     for(String str:EloquaUserList){
                         EloquaUserSet.add(str.trim().toUpperCase());
                     }         
                     string strUsername= UserInfo.getFirstName() + ' '+ userInfo.getLastName();
                     system.debug('*****strUsername'+strUsername + 'set :'+EloquaUserSet);
                     if(EloquaUserSet!=null && EloquaUserSet.contains(strUsername.toUpperCase())){
                         oLeadRepAssignmentHandler.leadRepAssigmentProcess(trigger.new);
                     }  */
                
                
            }
            // TEST2 Env code on Insert.
            if(trigger.IsInsert){ 
                if(!TEST.isRunningTest()){
                 EloquaUserList= ILMGeneral__c.getValues('AllowedUsersForSalesRepAssignment').value__c.split(';');
                     for(String str:EloquaUserList){
                         EloquaUserSet.add(str.trim().toUpperCase());
                     }  
                     
                 } 
                 else {
                     EloquaUserSet.add('SL ELOQUA');
                 }     
                     string strUsername= UserInfo.getFirstName() + ' '+ userInfo.getLastName();
                     system.debug('*****strUsername'+strUsername + 'set :'+EloquaUserSet);
                     if(EloquaUserSet!=null && EloquaUserSet.contains(strUsername.toUpperCase())){
                         oLeadRepAssignmentHandler.leadRepAssigmentProcess(trigger.new);
                     }
            }
                       
        }       
    }
   

}