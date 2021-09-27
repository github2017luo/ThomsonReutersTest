trigger ESC_Maritzresponse on MaritzCX__Survey_Response__c (before insert, after insert) {
    
    List<MaritzCX__Survey_Response__c> newCXList = new List<MaritzCX__Survey_Response__c>();
    Map<id,MaritzCX__Survey_Response__c> newCXMap = new Map<id,MaritzCX__Survey_Response__c>();
    Map<id,MaritzCX__Survey_Response__c> oldCXMap = new Map<id,MaritzCX__Survey_Response__c>();
    
    if(Trigger.New != null)  {newCXList = Trigger.New;}
    if(Trigger.NewMap != null)  {newCXMap  = Trigger.NewMap;}
    if(Trigger.OldMap != null)  {oldCXMap  = Trigger.OldMap;}
    System.debug('maritz trigger --->'+Trigger.New);
    ESC_MaritzCX_Trigger_Methods methods = new ESC_MaritzCX_Trigger_Methods(newCXList, newCXMap, oldCXMap);
                          
   
    if(Trigger.isBefore && Trigger.isInsert){  

        System.debug('maritz before insert fired--->'+Trigger.New);
        methods.setCase(newCXList);
   }
   
   
   if(Trigger.isAfter && Trigger.isInsert)
   {
    System.debug('maritz after insert fired--->'+Trigger.New);
            methods.reopenCases(newCXList);
            methods.createEscalations(newCXList);
   }
}