public Without Sharing class LCRMManageActivitiesCtrl{
    
    public String selFunction{get;set;}
    public Task tempTask{get;set;}
    public Event tempEvent{get;set;}
    public String retUrl{get;set;}
    public set<ID> actIDSet{get;set;}
    public List<Task> taskList{get;set;}
    public List<Event> eventList{get;set;}
    
    public LCRMManageActivitiesCtrl(){
        String recordIDs = ApexPages.CurrentPage().getParameters().get('Ids');
        retUrl = ApexPages.CurrentPage().getParameters().get('retURL');
        System.debug('ids : '+recordIDs);
        tempTask = new Task();
        tempEvent = new Event();
        actIDSet = new set<ID>();
        for(String idVal : recordIDs.split(',')){
            actIDSet.add(idVal);
        }
        if(actIDSet.size()<=0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No valid records found'));
        }else{
          
            try{
            if(Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isQueryable()){
                taskList = [SELECT ID, STATUS, ActivityDate FROM TASK WHERE ID IN :actIDSet]; 
                }
            }catch(Exception e){System.debug('Exception : '+e.getMessage());}
            try{
            if(Schema.sObjectType.Event.isAccessible() && Schema.sObjectType.Event.isQueryable()){
                eventList = [SELECT ID, STATUS__c, StartDateTime FROM EVENT WHERE ID IN :actIDSet]; 
                }
            }catch(Exception e){System.debug('Exception : '+e.getMessage());}
        }
    }
    
    public PageReference updateStatus(){
        if((taskList.size() > 0 && (tempTask.Status == null || tempTask.Status == '')) || (eventList.size() > 0 && (tempEvent.Status__c == null || tempEvent.Status__c == ''))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select value for Status fields before clicking Save.'));
            system.debug('@@tasklist'+taskList.size()+tempTask.Status+'Event'+eventList.size()+tempEvent.Status__c);
            return null;
            
        }
        system.debug('@@return');
        for(Task taskObj : taskList){
            taskObj.Status = tempTask.Status;
        }
        for(Event eventObj : eventList){
            eventObj.Status__c = tempEvent.Status__c;
        }
        try{
             if(Schema.sObjectType.Task.isUpdateable())
            update taskList;   
             if(Schema.sObjectType.Event.isUpdateable())  
            update eventList;
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        return cancel();
    }
    
    public PageReference updateDueDate(){
        if((tempTask.ActivityDate == null && taskList.size() > 0 ) || (tempEvent.StartDateTime == null && eventList.size() > 0)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select value for Due Date field before clicking Save.'));
            return null;
        }
        for(Task taskObj : taskList){
            taskObj.ActivityDate = tempTask.ActivityDate ;
        }
        for(Event eventObj : eventList){
            eventObj.StartDateTime = tempEvent.StartDateTime;
        }
        try{
            update taskList;
            update eventList;
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        return cancel();
    }
    
    public List<SelectOption> getFunctionList(){
        List<SelectOption> soList = new List<SelectOption>();
        soList.add(new SelectOption('Status','Update Status'));
        soList.add(new SelectOption('Due Date','Update Due Date'));
        return soList ;
    }
    
    public PageReference cancel(){
          // modification done as part of lightning
        String s=getContextUserUiThemeDisplayed(); 
        PageReference pr;
        if(s=='Theme4d' || s=='Theme4t' ){
            pr=New PageReference('/lightning/n/Activities');
        }
        else{
            //Added this to avoid ApexOpenRedirect PMD violation
            if(retURL.startsWith('/')){
            retURL=retURL.replaceFirst('/','');
        }
            pr= new PageReference('/'+retURL);
            pr.setRedirect(true);
        } 
        return pr;
    }
    
    //Added method to return theme being used by user in lightning
    public String getContextUserUiThemeDisplayed() {
        return UserInfo.getUiThemeDisplayed();
    } 
    
}