public class ESC_IntrusiveNotificationController{

    public String groupIds {get; set;}
    Map<String, Notifcation> objNotification {get; set;}
    Map<string, string> objectPT {get; set;}
    static Map<String, Schema.SObjectType> schemaMap {get; set;}
    public ESC_IntrusiveNotificationController(){
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_INF_Chrome));
       groupIds ='';
        for(GroupMember queuIDs : [Select Group.ID from GroupMember where UserOrGroupId =:UserInfo.getUserId() and Group.Type = 'Queue']){
            if(groupIds==''){
            groupIds  = queuIDs.GroupID;
            }else{
              groupIds  +=','+ queuIDs.GroupID;
              system.debug('groupIds&&'+groupIds);
              }
             
        }
        system.debug('groupIds&&'+groupIds);
         schemaMap = Schema.getGlobalDescribe();
        
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
            Notifcation nt = new Notifcation(ins);
            string keyPrefix = schemaMap.get(ins.ESC_ObjectAPIName__c).getDescribe().getkeyprefix();
            objNotification.put(keyPrefix , nt );
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