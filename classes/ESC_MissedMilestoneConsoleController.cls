public without sharing class ESC_MissedMilestoneConsoleController {

    public List<Case> myCases {get;set;} 
    public List<Case> allCases {get;set;} 
    public Integer myCaseSize;
    public Integer allCaseSize;
    public ESC_MilestoneAlertConfigSetting__c mac;
    public id userId;   
    public string style {get;set;} 
    Public List<string> ownerIdentifiers;
    public string groups{get; set;}
    public String groupIds {get; set;}
    Map<String, Notifcation> objNotification {get; set;}
    Map<string, string> objectPT {get; set;}
    static Map<String, Schema.SObjectType> schemaMap {get; set;}
    Public ESC_MissedMilestoneConsoleController(){   
        userId = UserInfo.getuserid();
        ownerIdentifiers = new list<string>();
        groups = '';
         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_INF_Chrome));
        groupIds ='';
        for(GroupMember queuIDs : [Select Group.ID from GroupMember where UserOrGroupId = :UserInfo.getUserId() and Group.Type = 'Queue']){
            ownerIdentifiers.add(queuIDs.GroupID);
            groups += queuIDs.GroupID +',';
             if(groupIds==''){
            groupIds  = queuIDs.GroupID;
            }else{
              groupIds  +=','+ queuIDs.GroupID;
              system.debug('groupIds&&'+groupIds);
              }
            
        }
        system.debug('groupIds&&'+groupIds);
         schemaMap = Schema.getGlobalDescribe();
        mac = ESC_MilestoneAlertConfigSetting__c.getValues('1');
        style = mac.X1stLevelColor__c; 
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
            myCases = [Select Id,subject ,ownerid, CaseNumber,MilestoneStatus,status,createddate from Case where ownerid =:userId and IsEscalated = true and IsClosed=false limit 999];
            if(ownerIdentifiers.size()>0){
                allCases = [Select Id,subject ,ownerid, CaseNumber,MilestoneStatus,status,createddate from Case where IsEscalated = true and Ownerid =:ownerIdentifiers and IsClosed=false limit 999];        
            }
        }
        style = setcolour(myCases.size());
        
    }
    
    Public Integer getmyCaseSize(){
        if(myCases!=null){
            return myCases.size();
            
        }
        else {
            return 0;
        }
        
    }
    Public Integer getallCaseSize(){
        if(allCases!=null){
            return allCases.size();
            
        }
        else {
            return 0;
        }
        
    }
    Public void refreshCaseListJS(){
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
            myCases = [Select Id,subject ,ownerid,CaseNumber,MilestoneStatus, status,createddate from Case where ownerid =:userId and IsEscalated = true and IsClosed=false limit 999];
            System.debug('Missed called'+myCases);
            allCases = [Select Id,subject ,ownerid, CaseNumber,MilestoneStatus,status,createddate from Case where IsEscalated = true  and Ownerid =:ownerIdentifiers and IsClosed=false limit 999];    
            System.debug('Missed called'+allCases);
        }
        style = setcolour(myCases.size());
    }
    public string setcolour(integer i){
        string color;
        if(i < mac.X1stLevelThreshold__c){color = mac.X1stLevelColor__c;}
        else if (i< mac.X2ndLevelThreshold__c){color = mac.X2ndLevelColor__c ;}
        else {color = mac.X3rdLayerColor__c;}
        return color;
    }
    
     public string getPushTopicNames(){
        set<string> pushTopicNames = new set<string>();
        try{
     ESC_IntrusiveNotifications__c eptn = ESC_IntrusiveNotifications__c.getInstance();
     for(string pushTopicName : eptn.ESC_IntrusiveNotificationsNames_csv__c.split(',')){
        pushTopicNames.add(pushTopicName.trim());
         
     }
        }
     catch(exception ex){
         System.debug('Exception'+ex);
     }
     system.debug(pushTopicNames);
     return JSON.serialize(pushTopicNames);
    }
    
    public string getObjectIdentifierMap(){
       
        
    objectPT = new Map<string , string>();
    
    for(string name : schemaMap.keySet()){
        string keyPrefix = schemaMap.get(name).getDescribe().getkeyprefix();
        string labelName = schemaMap.get(name).getDescribe().getLabel();
        if(keyPrefix !=null){
        objectPT.put(keyPrefix , labelName);
        }
    }
    return JSON.serialize(objectPT).replaceall('\'','`');
    }
    
    public string getIntrusiveSchemaMSG(){
        objNotification = new Map<String, Notifcation>();
        for(ESC_IntrusiveNotificationsSchema__c ins : ESC_IntrusiveNotificationsSchema__c.getall().values())
        {
            if(ins!=null){
                Notifcation nt = new Notifcation(ins);
            string keyPrefix = schemaMap.get(ins.ESC_ObjectAPIName__c).getDescribe().getkeyprefix();
            objNotification.put(keyPrefix , nt );
            }
            
        }
        System.debug('objNotification' + objNotification);
        return JSON.serialize(objNotification).replaceall('\'','`');
    }
    
     public class Notifcation{
        
        public set<string> fields {get; set;}
        public Map<string, string> fieldLabelMap {get; set;}
        public string iconName  {get; set;}
        public string objectName {get; set;}
        
        
        public  Notifcation(ESC_IntrusiveNotificationsSchema__c ins){
            fields = getFieldAPINames(ins.ESC_BodyMsgFields__c);
            fieldLabelMap = getInfoField(ins.ESC_ObjectAPIName__c);
            iconName = ins.ESC_Icon__c;
            objectName = schemaMap.get(ins.ESC_ObjectAPIName__c).getDescribe().getLabel();
        }
        
        set<string> getFieldAPINames(string returnedColumns){
        
        List<string> t_fieldNames = new list<string>();
        set<string> fieldNames = new set<string>();
        
        t_fieldNames= returnedColumns.split(',');
        
        for(string var : t_fieldNames ){
            if(var.contains('.')){
                continue;
            }
            fieldNames.add(var.trim());
          }
        
        return fieldNames;
        } 
        
        Map<string,string> getInfoField(string selectedObj){
        system.debug('getInfoField called with' + selectedObj );
        Map<string,string> apiFieldInfo =new Map<string,string>();
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObj).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            
            schema.describefieldresult dfield = sfield.getDescribe();
            string key= dfield.getLocalName();
            if(fields.contains(key)){
            string value = dfield.getLabel();
            apiFieldInfo.put(key, value);
            }
        }
      return apiFieldInfo;
        }
    }
}