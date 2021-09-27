trigger ESC_EPx_Triggers on ESC_EPx__c (before insert, after insert, after update) {

    List<ESC_EPX__c> newEPsList = new List<ESC_EPX__c>();
    Map<id,ESC_EPX__c> newEPsMap = new Map<id,ESC_EPX__c>();
    Map<id,ESC_EPX__c> oldEPsMap = new Map<id,ESC_EPX__c>();
    
    if(Trigger.New != null)  newEPsList = Trigger.New;
    if(Trigger.NewMap != null)  newEPsMap  = Trigger.NewMap;
    if(Trigger.OldMap != null)  oldEPsMap  = Trigger.OldMap;

    ESC_EPx_Trigger_Methods methods = new ESC_EPx_Trigger_Methods(newEpsList, newEPsMap, oldEPsMap);
  /*  
    List<id> caseIdList = new List<Id>();
   for(ESC_EPx__c epx : newEpsList){
        caseIdList.add(epx.ESC_Case__c);
   }
   
   list<ESC_Epx__c> eps =new list<ESC_Epx__c>();
   for(ESC_EPx__c epslist:[select id,ESC_EPx_Type__c,ESC_Case__c from ESC_EPx__c where ESC_EPx_Type__c ='EPs - Initial Feedback' AND ESC_Case__c =:caseIdList]){
    eps.add(epslist);
   }
   if(eps.size() >1){
      delete eps;
   }
   */
   //ESC_EPx__c epslist =[select id,ESC_EPx_Type__c,ESC_Case__c from ESC_EPx__c where ESC_EPx_Type__c ='EPs - Initial Feedback' AND ESC_Case__c in caseIdList];
                               
   
   if(Trigger.isBefore && Trigger.isInsert){
            
       if(ESC_EPx_Trigger_Context_Utility.firstRun){
          ESC_EPx_Trigger_Context_Utility.firstRun = false;
          
          methods.expirationCheck();
          methods.setSurveyType();
          methods.setCaseOwnerAndTeam();
          methods.setLanguage();
       }//END FIRST RUN CHECK
      
   }
   
   
   if(Trigger.isAfter && Trigger.isInsert)
   {
       
       if(ESC_EPx_Trigger_Context_Utility.firstRunAfterInsert)
       {
            ESC_EPx_Trigger_Context_Utility.firstRunAfterInsert = false;
            methods.reopenCases();
            methods.createFeedbackCases();
       }
   }
   
   if(Trigger.isAfter && Trigger.isUpdate)
   {
       if(ESC_EPx_Trigger_Context_Utility.firstRunAfterUpdate)
       {
        ESC_EPx_Trigger_Context_Utility.firstRunAfterUpdate = false;
       methods.createEscalations();
       }
   }
   
   /*
   if(Trigger.isAfter){
     
        if(ESC_EPx_Trigger_Context_Utility.firstRunAfterInsert){
            ESC_EPx_Trigger_Context_Utility.firstRunAfterInsert = false;
  
            methods.reopenCases();
            methods.createFeedbackCases();
            methods.createEscalations();
            
       }//End First Run After Insert
         
   }//End Trigger isAfter Check  
        
*/

}