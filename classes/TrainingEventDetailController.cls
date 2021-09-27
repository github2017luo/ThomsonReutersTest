/**
 * Contains methods for Training events details VF Page
 * 
 * Contains method to search/add contact, training topics, task and event
 * to the training event.
 * @author  Anshita Sharma
   @Last Modified By  Sadasiva Banda
 * @version  2013-01-17
 */
 /**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2013-01-17   Anshita Sharma           Created
* 2017-10-10   Harika Devi Kalidindi   Modified as a part of CRM -3257 to check whether logged in user is having Edit access to Training Event
* =============================================================================
*/ 
 
public without sharing class TrainingEventDetailController{
   
    private ApexPages.StandardController oStandardController;
        
    public Task NewTask {get;set;}
    public Event NewEvent {get;set;}
    
    public PagingContacts oPagingContacts {get;set;}
    public Training_Event__c tTrainingEvent{get;set;}
    public Training_Event__c trainingEvent{get;set;}
    public Account acc{get;set;}
    
    public Map<String,string> mapTraingTopicFields = new Map<string,string>();    
    public Map<String,Schema.DisplayType> mapContactFieldsAndTypes1 = new Map<String,Schema.DisplayType>();
    public Map<String,string> mapNameKey1 = new Map<string,string>();
    public Map<String,string> mapContactFields = new Map<string,string>();
    public Map<String,string> mapNameKey = new Map<string,string>();
    public Map<String,Schema.DisplayType> mapContactFieldsAndTypes = new Map<String,Schema.DisplayType>();
    public Map<Id, Contact> mapExistingContacts {get;set;}
    public Set<Id> exConIds {get;set;}
    public Set<String> ctgySet = new Set<String>();
    
    public List<SelectOption> listCategories = new List<SelectOption>();
    public List<SelectOption> listMatchingTopics {get;set;}
    public List<SelectOption> defaultTopics{get;set;}
    public List<SelectOption> listOperatorFields = new List<SelectOption>();
    public List<String> listSelectedTopics {get;set;}
    public List<String> listContactFields = new List<String>();
    public List<cContact> listMatchingContacts {get;set;}
    public List <Searchfilters> ListSelectedfilter  {get;set;}    
    
    public Boolean bSelectAll{get;set;}
    public Boolean renderAccountInfo{get;set;}
    public Boolean showList{get; set;}
    public Boolean activePswd{get; set;}
    //Harika  -Added as a part of CRM -3257 to check whether logged in user is having Edit access to Training Event
    Public Boolean TrainingEventacces{get; set;}
     
    public String sSelectedField1 {get;set;}    
    public String sSelectedField5 {get;set;}
    public String selTopics{get;set{system.debug('**Insetter'+value);selTopics=value;system.debug('**Insetter'+selTopics);}}
    public String sSelectedOperator1 {get;set;}     
    public String sSelectedOperator5 {get;set;}    
    public String sSearchValue1 {get;set;}     
    public String sSearchValue5 {get;set;}    
    public string SelectedTopics {get;set;}    
    public string sSearchKey{get;set;}
    public String Keyword {get;set;} 
    public String filtersadd {get;set;} 
    public String searchAcc {get;set;} 
    public Date endDate{get;set;} 
    
    public Id AccountId{get;set;}     
    public Id TrainingEventId = System.currentPageReference().getParameters().get('id');
    public String sortDir{
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    } 
    public String sortField{
        get  { if (sortField == null) {sortField = 'LastName'; } return sortField;  }
        set;
    }
    
    //wrapper class to display contact with checkbox
    
    public class cContact{
        public Contact cCon{get;set;}
        public Boolean bSelected{get;set;}
        
        public cContact(Contact con, Boolean checked){
            cCon =con;
            bSelected = checked;                   
        }       
    }
    
     //extended pageable class to use pagination on page
     
    public class PagingContacts extends Pageable {
        public List<cContact> listofContacts {get;set;}       
        public PagingContacts(){        
        }
        
        public override integer getRecordCount() {
            return (listofContacts == null ? 0 : listofContacts.size());
        }
        public override void moveNext(){
            super.moveNext();           
        }        
        public override void movePrev(){
           super.movePrev();           
        }
    } 
    
    //wrapper class for all search filters to impliment 'add filters'
    
    public class Searchfilters{
        public String sSelectedField {get;set;}
        public String sSelectedOperator {get;set;}
        public String sSelectedValue {get;set;}
        
        public Searchfilters(String sField,String sOperator,String sValue){
            this.sSelectedField = sField;
            this.sSelectedOperator = sOperator;
            this.sSelectedValue = sValue;
        }       
    } 
    
    //added by Saloni for CRM-4636 to route to GLI Training Event page
     public PageReference onPageLoad(){
        PageReference oPage;
        
        String UserBusinessUnit = LCRMGenericComponent.getUserBU();                
        Boolean BUFlag = LCRMGenericComponent.validateUserBU(UserBusinessUnit);
        
        if(BUFlag || LCRMGenericComponent.isLotusUser())
            oPage = new PageReference('/apex/LCRMTrainingEventDetail');  
            
        return oPage;
     }
    
    //constructor
    
    public TrainingEventDetailController(ApexPages.StandardController oController){
        oStandardController = oController;
        tTrainingEvent = (Training_Event__c) oController.getRecord();
        
        oPagingContacts = new PagingContacts();
        oPagingContacts.Pagesize = 25;
        oPagingContacts.listofContacts = new List<cContact>();        
        
        mapTraingTopicFields = AppUtil2.getFieldNameList('Training_Topic__c', mapTraingTopicFields, mapNameKey1, mapContactFieldsAndTypes1);
        mapContactFields = AppUtil2.getFieldNameList('Contact', mapContactFields, mapNameKey, mapContactFieldsAndTypes);
        mapContactFields.put('City ','Account.BillingCity');
        mapContactFieldsAndTypes.put('City ',Schema.DisplayType.STRING);
        mapNameKey.put('Account.BillingCity','City ');
        
        activePswd = true;
        // Harika - Added as a part of CRM -3257 
        TrainingEventacces =Trainingeventrecordaccess();
        sSelectedField5 = 'Category';
        sSelectedOperator5 = 'equals';
        filtersadd ='';
        ListSelectedfilter  = new List<Searchfilters>{new Searchfilters('--None--','--None--','')};
          if(Schema.sObjectType.Training_Event__c.isQueryable()) //Added to avoid Apex CRUD violation
        //events field mapping and setting SAP account number from training event's account      
        trainingEvent = [Select id, name, Account_Level__c, Account__r.SAPAccountNumber__c  ,Account__c, Training_Type__c ,Training_Duration__c ,Notes__c, Status__c ,   Training_Date__c, Training_Name__c from Training_Event__c where id =:tTrainingEvent.Id]; 
        if(trainingEvent.Account_Level__c)
        {
            sSelectedField1 = 'SAP Account Number';
            sSelectedOperator1 = 'equals';
            sSearchValue1 = trainingEvent.Account__r.SAPAccountNumber__c;
            if(sSearchValue1 != null)
                renderAccountInfo = true;            
        }
        else{
            renderAccountInfo = false;
        }
        if(trainingEvent.Training_Duration__c !=null && trainingEvent.Training_Duration__c!=0){
            Integer i =Integer.valueOf(trainingEvent.Training_Duration__c);    
            Date tEndDate =(trainingEvent.Training_Date__c); 
            endDate = tEndDate+i;
        }            
             
        NewTask = new Task();
        NewTask.WhatId = tTrainingEvent.Id;
        NewTask.Training_Event_Id__c=trainingEvent.id;
        NewTask.Training_Event_Name__c=trainingEvent.name;
        NewTask.Subject= 'Task';
                
        NewEvent = new Event();
        NewEvent.WhatId = tTrainingEvent.Id;    
		NewEvent.Description =trainingEvent.Notes__c; 
        NewEvent.OwnerId = UserInfo.getUserId();
        NewEvent.Training_Event_Id__c=trainingEvent.id;
        NewEvent.Training_Event_Name__c=trainingEvent.name;
        NewEvent.Subject=trainingEvent.Training_Name__c;
        NewEvent.type =trainingEvent.Training_Type__c; 
        NewEvent.Status__c =trainingEvent.Status__c;    
        NewEvent.StartDateTime=trainingEvent.Training_Date__c;
        if(endDate!=null)
            NewEvent.EndDateTime=endDate ;       
        else
            NewEvent.EndDateTime=trainingEvent.Training_Date__c;
        
        for(String sField : mapNameKey.Values()){
            if(sField == 'Westlaw User ID' || sField == 'Last Name' || sField == 'First Name' || sField == 'SAP Account Number' || 
               sField == 'City ' || sField == 'Account Name' ){
                listContactFields.add(sField);
            }
        }
        listContactFields.sort();
        findResults(); 
         
    }

    public list<SelectOption> getlistOperatorFields(){       
       listOperatorFields = AppUtil2.populateOperators(Schema.DisplayType.STRING);
       return listOperatorFields;
    }
    
    public list<SelectOption> getlistContactFields(){
        List<SelectOption> listFieldOptions = new List<SelectOption>();
        listFieldOptions.add(new SelectOption('--None--','--None--'));
        for(Integer i=0;i<listContactFields.size();i++)
        {
            
            listFieldOptions.add(new SelectOption(listContactFields[i],listContactFields[i]));
        }
        
           listFieldOptions.add(new SelectOption('Account.Legacy_System_Id__c','Legacy System ID'));
        return listFieldOptions;
    }
    
    //called inside 'findContacts()' to check existing contact of training events
    
    public void getExistingContacts(){
        mapExistingContacts = new Map<Id, Contact>();
        List<Id> listContactIds = new List<Id>();
        for(Training_Event_Contact__c TrainingEventContact : [SELECT Id, Contact_Name__c FROM Training_Event_Contact__c where Training_Event__c = :tTrainingEvent.Id])
        {
            listContactIds.add(TrainingEventContact.Contact_Name__c);
        }
        
        if(!listContactIds.isEmpty()){
            mapExistingContacts = new Map<Id, Contact>([SELECT Id, Name, FirstName, LastName, SAP_Account_Number__c,Westlaw_User_ID__c, SAP_Role__c, Account.billingcity,MailingCity, Account.Name,External_Id__c,Source__c FROM Contact where Id in :listContactIds]);
        }       
    }
    
    //calles on search, searched on contacts not already associated to TE.
    
    public pagereference findContacts(){
        listMatchingContacts = new List<cContact>();
         
        getExistingContacts();
        String sQueryString ='';
        Set<String> setSearchFields = new Set<String>{'FirstName','LastName','SAP_Account_Number__c','Westlaw_User_ID__c', 'Account.Name','Name','Account.billingcity','MailingCity'};
        sQueryString = 'SELECT Id, Name, FirstName, LastName, SAP_Account_Number__c,Westlaw_User_ID__c,SAP_Role__c, Account.billingcity,MailingCity, Account.Name,External_Id__c,Source__c FROM Contact where CreatedDate <> null ';        
        if(sSearchValue1!=null && sSearchValue1!='' && sSelectedField1!='--None--'){
            sQueryString += AppUtil2.queryForText(mapContactFields.get(sSelectedField1),String.escapeSingleQuotes(sSelectedOperator1),String.escapeSingleQuotes(sSearchValue1));            
        }      
        if(!ListSelectedfilter.IsEmpty()){ 
            Integer i = 0;
            for(Searchfilters oSearchfilters : ListSelectedfilter){ System.debug(oSearchfilters.sSelectedField+'****');
                if(oSearchfilters.sSelectedField!='--None--' && oSearchfilters.sSelectedValue!=null && oSearchfilters.sSelectedValue!='' && oSearchfilters.sSelectedField!='Account.Legacy_System_Id__c'){
                    sQueryString +=AppUtil2.queryForText(mapContactFields.get(oSearchfilters.sSelectedField),String.escapeSingleQuotes(oSearchfilters.sSelectedOperator),String.escapeSingleQuotes(oSearchfilters.sSelectedValue));
                }else if(oSearchfilters.sSelectedField=='Account.Legacy_System_Id__c'){
                    sQueryString +=AppUtil2.queryForText('Account.Legacy_System_Id__c',String.escapeSingleQuotes(oSearchfilters.sSelectedOperator),String.escapeSingleQuotes(oSearchfilters.sSelectedValue));
                }   
            }              
         }    
         if(sSearchKey != null && sSearchKey !=''){
                sQueryString +=' and Name Like';    
                sQueryString +='\'%'+sSearchKey +'%\'';  
         }
         if(activePswd == true){
             sQueryString += AppUtil2.queryForText('SAP_Role__c','includes','WL PSWD ACTIVE');    
         }
         
         if(!mapExistingContacts.isEmpty()){
             exConIds=mapExistingContacts.keySet();
             sQueryString += ' and Id not In : exConIds';        
             
         }
               
         sQueryString +=' order by ' + String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir);
         sQueryString += ' limit 1000';
         
         system.debug('*****: '+sQueryString );
         try{
            Contact[] templistMatchingContacts = Database.query(sQueryString);            
            listMatchingContacts = convertType(templistMatchingContacts);          
         }
         catch(Exception e){
             system.debug('ERROR: '+e.getMessage());
         }
         oPagingContacts.listofContacts =listMatchingContacts ;
         oPagingContacts.PageNumber =1;
         return null;
    }
    
    //called to convert result list to wrapper type
    
    public List<cContact> convertType(Contact[] templistMatchingContacts){
        List<cContact> listTempWrapperObj = new List<cContact>();
        if(!templistMatchingContacts.isEmpty()){
            for(Contact ctempContact : templistMatchingContacts){
                if(!mapExistingContacts.isEmpty()){
                    if(!mapExistingContacts.containsKey(ctempContact.id)){
                        cContact cc = new cContact(ctempContact, false);
                        listTempWrapperObj.add(cc);
                     }
                }
                else{
                    cContact cc = new cContact(ctempContact, false);
                    listTempWrapperObj.add(cc);
                }
            } 
            if(!listTempWrapperObj.isEmpty())
                showList = true;
            else
                showList = false;    
        }    
        return listTempWrapperObj;       
    }  
    
    // adds the contact and/or topics to training event
     
    public pageReference AddtoTraining(){
        Training_Event_Topic__c tTopic;
        Id tId;
        List<Contact> listSelectedContacts = new List<Contact>();        
        List<Training_Event_Topic__c> newTrainingEventContactsTopics = new List<Training_Event_Topic__c>();
        List<Training_Event_Contact__c> listTrainingEventContacts = new List<Training_Event_Contact__c>();            
        Training_Event_Contact__c TrainingEventContact;
        Map<String,Id> topicMap =new Map<String,Id>();
        Map<Id,String> topicMap1 =new Map<Id,String>();
        
        if (listMatchingContacts != null){
            for(cContact con : listMatchingContacts ){
                if(con.bSelected == true){
                    listSelectedContacts.add(con.cCon);                    
                }
            }
             
            if(!listSelectedContacts.isEmpty()){
                selTopicsList();
                if(!ctgySet.isEmpty()){
                    for(List<Training_Topic__c> tpcl:[Select id,Topic__c, Category__c from Training_Topic__c where Topic__c in:listSelectedTopics])
                    {
                        for(Training_Topic__c tpc:tpcl){
                            if(ctgySet.contains(tpc.Topic__c+':'+tpc.Category__c)|| ctgySet.contains(tpc.Topic__c+':'+'%')){
                                if(!topicMap.containsKey(tpc.Topic__c))
                                {
                                    topicMap.put(tpc.Topic__c,tpc.id);
                                    topicMap1.put(tpc.id,tpc.Topic__c);
                                }
                            }    
                        }
                    }
                }
                for(Contact c : listSelectedContacts){
                    TrainingEventContact = new Training_Event_Contact__c();
                    TrainingEventContact.Contact_Name__c = c.Id;
                    TrainingEventContact.Training_Event__c = TrainingEventId; 
                    listTrainingEventContacts.add(TrainingEventContact);                     
                }
                //Added if condition for null check and to avoid Apex CRUD violation
                if(!listTrainingEventContacts.isEmpty() && (Schema.sObjectType.Training_Event_Contact__c.isCreateable()))
                insert listTrainingEventContacts;
                
                if(!topicMap.isEmpty()) {
                    for(Training_Event_Contact__c c :listTrainingEventContacts){
                        for(String topic:topicMap1.values()){
                            tTopic = new Training_Event_Topic__c();
                            tTopic.Training_Event_Contact__c = c.Id;
                            if(topicMap.containsKey(topic))
                                tId= topicMap.get(topic);
                            tTopic.Training_Topic__c = tId;
                            newTrainingEventContactsTopics.add(tTopic);
                        }
                    } 
                    //Added one more conditin in If , to avoid Apex CRUD violation
                    if(!newTrainingEventContactsTopics.isEmpty() && Schema.sObjectType.Training_Event_Topic__c.isCreateable()){
                        insert newTrainingEventContactsTopics;
                    } 
               }
               PageReference pg = new Pagereference('/apex/TrainingEventDetail?id='+TrainingEventId );
               pg.setRedirect(true);
               return pg;
            }
            return null;
        }    
        return null;
    }
    
    //add filter categories for topics
    
    public list<SelectOption> getlistCategories(){
      listCategories.clear();
      listCategories.add(new SelectOption('%','--All--'));
      for(AggregateResult ar : [select Category__c from Training_Topic__c group by Category__c])
      {
          String category = (String)ar.get('Category__c');
          listCategories.add(new SelectOption(category,category));
      }       
      return listCategories;
    }
    
    //sets selected topics on selected topics change
    
    public void selTopicsList(){
        system.debug('in selTopicsList');
        selectedTopics = selTopics; 
        if(selectedTopics  != null){
            listSelectedTopics= selectedTopics.split(';', 0); 
            //string sTopicCategory = listSelectedTopics[listSelectedTopics.size()-1]+':'+sSearchValue5;
            
            string sTopicCategory=''; 
            for(String S:listSelectedTopics){ 
            String comp=S+':'+sSearchValue5;
                    
            if(!ctgySet.contains(comp)){
                ctgySet.add(comp);
            }
           }             
        }
        
    } 
    
    //search and return topics for selected category
    
    public pageReference findResults(){
        defaultTopics = new List<SelectOption>();
        //selTopicsList();           
        if(selectedTopics !=null && selectedTopics !=''){
            for(String ss:listSelectedTopics){
                defaultTopics.add(new SelectOption(ss,ss));                
            }            
        }
        listMatchingTopics = new List<SelectOption>();
        String sQueryString = 'SELECT id, Topic__c FROM Training_Topic__c where CreatedDate <> null ';        
        
        system.debug('Anshita search5'+sSearchValue5);
        if(sSearchValue5!=null && sSearchValue5!='' && sSearchValue5!='%')
            sQueryString += AppUtil2.queryForText(mapTraingTopicFields.get(sSelectedField5),String.escapeSingleQuotes(sSelectedOperator5),String.escapeSingleQuotes(sSearchValue5));
        
        if(listSelectedTopics!=null){
            sQueryString += ' and Topic__c not in :listSelectedTopics';               
        }    
        sQueryString += ' order by Topic__c';
        
        Training_Topic__c[] templistMatchingTopics = Database.query(sQueryString);
        
        for(Training_Topic__c ttempTopic : templistMatchingTopics){
            listMatchingTopics.add(new SelectOption(ttempTopic.Topic__c,ttempTopic.Topic__c));
        }
        return null;
    }    
   
    //add task to training event
    
    public pageReference addTask(){
        try{
            if(Task.sObjectType.getDescribe().isCreateable())//Added to avoid Apex CRUD violation
            insert NewTask;
        }
        catch(Exception e){           
           system.debug('Error adding task'+e.getMessage());
           return null;
        }   
        
        NewTask = new Task();
        NewTask.WhatId = trainingEvent.Id;
        NewTask.Training_Event_Id__c=trainingEvent.id;
        NewTask.Training_Event_Name__c=trainingEvent.name;
        NewTask.Subject='Task';
        NewTask.Type = 'Outbound Call';
        NewTask.Status ='Pending';
        NewTask.Priority ='Normal';
        return null;         
    }    
    
    //add event to training event
    
    public pageReference addEvent(){
        try{
            if(NewEvent.IsAllDayEvent == true){
                NewEvent.EndDateTime = null;
            }
            if(Event.sObjectType.getDescribe().isCreateable())//Added to avoid Apex CRUD violation
            insert NewEvent;
        }
        catch(Exception e){
          system.debug('Error adding event'+e.getMessage());
          return null;
        }   
        
        NewEvent = new Event();
        NewEvent.WhatId = tTrainingEvent.Id;    
	    NewEvent.Description =trainingEvent.Notes__c; 
        NewEvent.OwnerId = UserInfo.getUserId();
        NewEvent.Training_Event_Id__c=trainingEvent.id;
        NewEvent.Training_Event_Name__c=trainingEvent.name;
        NewEvent.Subject=trainingEvent.Training_Name__c;
        NewEvent.type =trainingEvent.Training_Type__c; 
        NewEvent.StartDateTime =trainingEvent.Training_Date__c; 
        NewEvent.Status__c =trainingEvent.Status__c;    
        if(endDate!=null)
            NewEvent.EndDateTime=endDate ;       
        else
            NewEvent.EndDateTime=trainingEvent.Training_Date__c;    
        return null;         
    }    
    
    //for column toggle sort
    
    public void toggleSort(){
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        findContacts();
    }    
    
    //to add filter rows
    
    public pagereference  addFilter(){
       
       ListSelectedfilter.add(new Searchfilters('--None--','--None--',''));
       return null;
    }
    
     /*
   * Harika - CRM -3257
   *Description : Verify whether the user has edit access to the training event record.
   * 
   */
     public Boolean Trainingeventrecordaccess()
    {
        Id userId =UserInfo.getUserId();
        Boolean baccesslevel;  
        List<Training_Event__Share> trainingeventshare = new List<Training_Event__Share>();
        List<UserRecordAccess> useraccess = new List<UserRecordAccess>();
        if(Schema.sObjectType.Training_Event__Share.isQueryable()) //Added to avoid Apex CRUD violation
        trainingeventshare= [Select Id,AccessLevel from Training_Event__Share where  UserOrGroupId =: userId  and ParentId = :TrainingEventId  and AccessLevel='Edit'];
        if(Schema.sObjectType.UserRecordAccess.isQueryable()) //Added to avoid Apex CRUD violation
        useraccess= [Select RecordId FROM UserRecordAccess WHERE UserId=:userId  AND HasEditAccess = true AND RecordId =:TrainingEventId];
        //List<Training_Event__c> otrainingevent = [Select OwnerId from Training_Event__c where Id=:TrainingEventId and OwnerId =:userId ];
        //if( trainingeventshare.size() >0 || (otrainingevent.size() >0) || useraccess.size() >0)
        if( trainingeventshare.size() >0 || useraccess.size() >0)
        {
        baccesslevel =true;
        
        }
        else 
        {
        baccesslevel =false;
        
        }
        return baccesslevel;
        
       
    }
    
    
}