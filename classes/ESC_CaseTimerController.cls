public without sharing class ESC_CaseTimerController {
    @AuraEnabled
    public static String isCaseOwner(Id casId) {
        List<Case> lstCase = new List<Case>();
        lstCase = [SELECT Id,OwnerId from Case where Id=:casId];
        if(lstCase.size()>0){
            String ownerid = lstCase[0].OwnerId;
            //To handle casetimer only when case owner is a user and logged in user.Not for queue and other users
            if(ownerid.startsWith('005') && ownerid == UserInfo.getUserId()){
                return 'true';
            }    
        }
        return 'false';
    }
    
    @AuraEnabled
    public static List<ESC_Case_Usage__c> getSessionRec(Id casId) {
        List<ESC_Case_Usage__c> stList = new List<ESC_Case_Usage__c>();
        stList = [SELECT id,ESC_Case__c,ESC_Viewer__c,ESC_Viewer__r.Name,ESC_Case__r.ESC_Billable_Time__c,ESC_Case__r.ESC_Total_Time_Spent__c from ESC_Case_Usage__c where ESC_Case__c=:casId];
        system.debug('Stlist'+stList);
        return stList;
    }
     @AuraEnabled
    public static List<Case> getCaseRec(Id casId) {
        return [SELECT id, ESC_Billable_Time__c,ESC_Total_Time_Spent__c FROM Case where Id =:casId];
    }
    
    @AuraEnabled
    public static List<ESC_Case_Usage__c> newSession(String casId, String duration){
       
        String h=duration;
        system.debug('Current time:' + h + casId);
        List<String> h1= new List<String>();
        h1.addAll(h.split(':'));
        Double temp = Integer.valueOf(h1[2]) + (60 * Integer.valueOf(h1[1])) + (3600 * Integer.valueOf(h1[0]));
        if(temp>0){
            ESC_Case_Usage__c session = new ESC_Case_Usage__c();
            session.ESC_Case__c = casId;
            session.ESC_Duration__c = temp/60;
            session.ESC_Billable_Time__c = temp/60;
           
            session.ESC_Viewer__c = UserINFO.getUserId();
            session.ESC_Type__c = 'System';
            
            insert session;
            system.debug('session-->'+session);
        }
    
        List<ESC_Case_Usage__c> sessionList = new List<ESC_Case_Usage__c>();
        sessionList = getSessionRec(casId);
        return sessionList;
        
    }
}