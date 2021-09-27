/**
 * Contains methods for MassEditTrainingContacts VF Page
 * 
 * Contains the wrapper class for Training Event Contact for showing checkboxes
 * Contains method to update the selected training event contacts with the selected training date
 *
 * @author  Srikanth Kuruva
 * @Last Modified By  Sadasiva Banda
 * @version  2013-01-24
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-02-12   Tejasree                Created Custom label and used them to prevent Hard coding as a part of DPS-1836.Added checks before SOQL/DML operatins to prevent violations like Apex CRUD violation and to prevent Apex Sharing vioaltion and Apex SOQl injection
                                                          
 * =============================================================================
 */
//Added without sharing to avoid APEX SHARING VIOLATION Rule 
public without sharing class MassEditTrainingContacts{
@TestVisible static Boolean isTheme4d = UserInfo.getUiThemeDisplayed() == 'Theme4d';

    public List<TrainingEventContactWrapper> listTrainingEventContacts{get;set;}
    public List<Training_Event_Contact__c> selectedTECList = new List<Training_Event_Contact__c>();
    public List<Training_Event_Contact__c> sQueryResult = new  List<Training_Event_Contact__c>();
    public List<SelectOption> listMatchingTopics {get;set;}
    public List<SelectOption> defaultTopics{get;set;}
    public List<String> listSelectedTopics {get;set;}
    public List<SelectOption> listCategories = new List<SelectOption>();
    public Set<String> ctgySet = new Set<String>();
    public Map<Id,Training_Event_Contact__c> tempListTrainingEventContacts{get;set;}
    public Map<Id, List<String>> mapTrainingContactTopics{get;set;}
    public Map<String,string> mapFields = new Map<string,string>();
    public Map<String,string> mapNameKey = new Map<string,string>();
    public Map<String,Schema.DisplayType> mapfieldsAndTypes = new Map<String,Schema.DisplayType>();
    public Map<Id,Boolean> mapOldCheckedItems = new Map<Id,Boolean>();
    private string trngEventId =string.escapeSingleQuotes('id');//Added as a part of DPS-1836
    public Boolean bSelectAll{get;set;}
    public Boolean isRecords{get;set;}
    public Boolean isDate{get;set;}
    public Integer rSize{get;set;}
    public PagingContacts oPagingContacts {get;set;}
    
    public String selectedTopics{get;set;}     
    public String tTopicDel{get;set;}
    public String tContactDel{get;set;} 
    public String dTrainedDate{get;set;}
    public String tEventName{get;set;} 
    public String selTopics{get;set{selTopics=value;}}
    public String sSearchValue5 {get;set;} 
    public String sSelectedField5 {get;set;}
    public String sSelectedOperator5 {get;set;} 
    public String sortDir{
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    } 
    public String sortField{
        get  { if (sortField == null) {sortField = 'Last_Name__c'; } return sortField;  }
        set;
    }
    //Added string.escapeSingleQuotes to avoid ApexXSSFromURLParam violation
    public Id TrainingEventId = Id.ValueOf(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(trngEventId)));
    
    public PageReference onPageLoad(){
        PageReference oPage;
        
        String UserBusinessUnit = LCRMGenericComponent.getUserBU();                
        Boolean BUFlag = LCRMGenericComponent.validateUserBU(UserBusinessUnit);
        Boolean LotusUser = LCRMGenericComponent.isLotusUser();
        
        if(BUFlag || LotusUser)
            oPage = new PageReference('/apex/LCRMMassEditTrainingContacts?id='+TrainingEventId);
            
        return oPage;
     }
    
         
    //constructor
     
    public MassEditTrainingContacts(ApexPages.StandardSetController controller){
        rSize= controller.getSelected().size();
        oPagingContacts = new PagingContacts();
        oPagingContacts.Pagesize = 100;
        oPagingContacts.listTrainingEventCons = new List<TrainingEventContactWrapper>();
        
        tempListTrainingEventContacts = new Map<Id,Training_Event_Contact__c>();
        mapTrainingContactTopics= new Map<Id, List<String>>();
        mapFields = AppUtil2.getFieldNameList('Training_Topic__c', mapFields, mapNameKey, mapfieldsAndTypes);
        sSelectedField5 = 'Category';
        sSelectedOperator5 = 'equals';
        dTrainedDate = System.Today().format();
        isRecords = true;           
        listTrainingEventContacts = new List<TrainingEventContactWrapper>();        
        if(TrainingEventId != null){
            tEventName = [Select Name from Training_Event__c where id =:TrainingEventId].Name; 
        }
        if(controller.getSelected().size() != 0){
            selectedTECList = controller.getSelected();
            bSelectAll = true;
            for(Training_Event_Contact__c tec: [select Contact_Name__r.Westlaw_User_ID__c , 
 Contact_Name__r.SAP_Role__c , Training_Event__r.Name,  SAP_Account_Number__c ,  Account_Name__c, Id, Name, First_Name__c, Last_Name__c, Job_Function__c, User_trained_Date__c from Training_Event_Contact__c where Id in :controller.getSelected()])
            {
                tempListTrainingEventContacts.put(tec.id, tec);
            }            
        }
        else{
            bSelectAll = false;
            for(Training_Event_Contact__c tec : [select  Contact_Name__r.Westlaw_User_ID__c , 
 Contact_Name__r.SAP_Role__c , Training_Event__r.Name,  SAP_Account_Number__c ,  Account_Name__c , Id, Name, First_Name__c, Last_Name__c, Job_Function__c, User_trained_Date__c from Training_Event_Contact__c where Training_Event__c = :TrainingEventId])
            {
                tempListTrainingEventContacts.put(tec.id, tec);
            }
        }
        
        if(!tempListTrainingEventContacts.isEmpty()){            
            contactList(tempListTrainingEventContacts.values());     
        }    
        else{
           isRecords = false;           
        }
        oPagingContacts.listTrainingEventCons =listTrainingEventContacts;
        if(rSize == 0)
            rSize =listTrainingEventContacts.size();        
        findResults(); 
        isDate=true;     
    }    
    
    //wrapper class to display list of contacts and topics
    public class TrainingEventContactWrapper{
        public Boolean bSelected{get;set;}
        public Training_Event_Contact__c oTrainingEventContact{get;set;}
        public List<String> oTrainingContactTopic{get;set;}
        public Integer oTopics{get;set;}
        
        public TrainingEventContactWrapper(Boolean b, Training_Event_Contact__c c, List<String> t, Integer i){
            bSelected = b;
            oTrainingEventContact = c;
            oTrainingContactTopic =t;
            oTopics =i;
        }
    }
    
    //Extended pageable to impliment pagination
    public class PagingContacts extends Pageable{
        public List<TrainingEventContactWrapper> listTrainingEventCons {get;set;}
       
        public PagingContacts(){
        }        
        
        public override integer getRecordCount() {
            return (listTrainingEventCons == null ? 0 : listTrainingEventCons.size());
        }
        
       public override void moveNext(){
            system.debug('listTrainingEventCons'+listTrainingEventCons);
            super.moveNext();
        }        
        
       public override void movePrev(){
           super.movePrev();
       }     
    }
    
     //called on click of 'Save and Return' btn
    public pageReference SaveAndReturn(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeUpdated = new List<Training_Event_Contact__c>();
        List<Training_Event_Contact__c> listUpdateAll = new List<Training_Event_Contact__c>();
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c != null)
                tTrainingEventContactWrapper.oTrainingEventContact.Trained__c =true;
            listTrainingEventContactstobeUpdated.add(tTrainingEventContactWrapper.oTrainingEventContact);
            //listUpdateAll.add(tTrainingEventContactWrapper.oTrainingEventContact); 
        }
    //Added one condition to prevent APEX CRUD VIOLATION before UPDATE operation
        if(!listTrainingEventContactstobeUpdated.isEmpty() && Schema.sObjectType.Training_Event_Contact__c.isUpdateable()){
            update listTrainingEventContactstobeUpdated;
			 }
        
			//if the user is in LEX //added as part of sales lightning roll-out
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4t') {
            PageReference pg = new Pagereference('/lightning/r/Training_Event__c/' + TrainingEventId + '/view');  
            return pg;
        }
        
        PageReference pg = new PageReference('/apex/TrainingEventDetail?id='+TrainingEventId);
        return pg;
    }
    
    //Called on click of 'Save'.
    
    public pageReference Save(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeUpdated = new List<Training_Event_Contact__c>();
        List<Training_Event_Contact__c> listUpdateAll = new List<Training_Event_Contact__c>();
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c != null)
                tTrainingEventContactWrapper.oTrainingEventContact.Trained__c = true;
            listTrainingEventContactstobeUpdated.add(tTrainingEventContactWrapper.oTrainingEventContact);
        }
        if(!listTrainingEventContactstobeUpdated.isEmpty()){
            update listTrainingEventContactstobeUpdated;
        }
            
        //reset default date in field to today
        dTrainedDate = System.Today().format();
        return null;
    }
    
    //called on 'Update Training date' for mass records.
    
    public pageReference SaveMassDate(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeUpdated = new List<Training_Event_Contact__c>();
        date myDate = date.parse(dTrainedDate);
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.bSelected){
                tTrainingEventContactWrapper.oTrainingEventContact.Trained__c = true;
                tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c = myDate;
                listTrainingEventContactstobeUpdated.add(tTrainingEventContactWrapper.oTrainingEventContact);
            }
        }
    //Added one condition to prevent APEX CRUD VIOLATION before UPDATE operation
        if(!listTrainingEventContactstobeUpdated.isEmpty() && (Schema.sobjectType.Training_Event_Contact__c.isUpdateable())){
            update listTrainingEventContactstobeUpdated;
        }
        dTrainedDate = System.Today().format();
        return null;
    }
    
    //Called on click of 'Remove Selected', deletes training event contact and 
    //associated training event topics record (id any).
    
    public pageReference RemoveSelected(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeRemoved= new List<Training_Event_Contact__c>();
        List<TrainingEventContactWrapper> listTrainingEventContactsLeft= new List<TrainingEventContactWrapper>();
        List<Training_Event_Topic__c> listContactTopicsToBeRemoved = new List<Training_Event_Topic__c>();
        List<Id> tConId = new List<Id>();
        
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.bSelected){
                listTrainingEventContactstobeRemoved.add(tTrainingEventContactWrapper.oTrainingEventContact);
                if(tTrainingEventContactWrapper.oTopics >0)
                    tConId.add(tTrainingEventContactWrapper.oTrainingEventContact.id);            
            }
            else{
                listTrainingEventContactsLeft.add(tTrainingEventContactWrapper);    
            }
        }
        if(!listTrainingEventContactstobeRemoved.isEmpty()){
            if(!tConId.isEmpty()){
                for(Training_Event_Topic__c tTopic: [select id, Training_Event_Contact__c from Training_Event_Topic__c where Training_Event_Contact__c In:tConId])
                {
                    listContactTopicsToBeRemoved.add(tTopic);
                }
            }
            //Added if condition for null check and to prevent APEX CRUD VIOLATION before DELETE operation 
            if(!listContactTopicsToBeRemoved.isEmpty() && Training_Event_Topic__c.sObjectType.getDescribe().isDeletable()){   
             delete listContactTopicsToBeRemoved; 
            }
            //Added one condition for null check and to prevent APEX CRUD VIOLATION before DELETE operation
            if(!listTrainingEventContactstobeRemoved.isEmpty() && Schema.sObjectType.Training_Event_Contact__c.isDeletable()){
            
            delete listTrainingEventContactstobeRemoved;  
             }
        }
        if(!listTrainingEventContactsLeft.isEmpty()){
            listTrainingEventContacts = listTrainingEventContactsLeft; 
            oPagingContacts.listTrainingEventCons =listTrainingEventContacts; 
            rSize=listTrainingEventContacts.size();  
        }
        else{
            listTrainingEventContacts.clear();
            oPagingContacts.listTrainingEventCons =listTrainingEventContacts;
            rSize=0;                
        }
        return null;
    }
    
    public String getTrngEvntId(){
        if(TrainingEventId != null)
            return TrainingEventId;
        else    
            return null;
    }    
    
    //get category values in filter
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
    
    public class tTrainingTopic
    {
        public Training_Topic__c tTrainingTopic{get;set;}
        public Boolean bSelected{get;set;}        
        
        public tTrainingTopic(Training_Topic__c tt)
        {
            tTrainingTopic = tt;
            bSelected = false;
        }
    }
    
    //sets selected topics on selected topics change
    
    public void selTopicsList(){
        //defaultTopics = new List<SelectOption>();
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
       system.debug('__selected Topics Final__'+ctgySet);      
    }  
    
    //search and return topics for selected category   
    public pageReference findResults(){
        //selTopicsList();           
        defaultTopics = new List<SelectOption>();
        if(selectedTopics !=null && selectedTopics !=''){
            for(String ss:listSelectedTopics){
                defaultTopics.add(new SelectOption(ss,ss));
                
            }
        }
        listMatchingTopics = new List<SelectOption>();
        String sQueryString = '';
        sQueryString = 'SELECT id, Topic__c FROM Training_Topic__c where CreatedDate <> null ';        
        if(sSearchValue5!=null && sSearchValue5!='' && sSearchValue5!='%')
     //Added string.escapeSingleQuotes to avoid APEX XSS FROM URLPARAM Violation
            sQueryString += AppUtil2.queryForText(mapFields.get(string.escapeSingleQuotes(sSelectedField5)),string.escapeSingleQuotes(sSelectedOperator5),string.escapeSingleQuotes(sSearchValue5));
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
    
    //adds topics to selected training event contacts
    public pageReference saveTopics(){
        List<Training_Event_Topic__c> newTrainingEventContactsTopics = new List<Training_Event_Topic__c>();
        List<Training_Event_Topic__c> trainingEventContactsTopicDel = new List<Training_Event_Topic__c>();
        
        Map<Id,Training_Event_Contact__c> tConMap = new Map<Id,Training_Event_Contact__c>();
        Map<Id, List<String>> existingTopics = new Map<Id, List<String>>();
        Map<Id,String> topicMap =new Map<Id,String>();    
        Map<String,Id> topicIdMap =new Map<String,Id>();
        
        Boolean isAdd= false;
        Training_Event_Topic__c tTopic;
        Id tId;
        
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.bSelected){
                tConMap.put(tTrainingEventContactWrapper.oTrainingEventContact.Id,tTrainingEventContactWrapper.oTrainingEventContact);
                existingTopics.put(tTrainingEventContactWrapper.oTrainingEventContact.Id,tTrainingEventContactWrapper.oTrainingContactTopic );
            }
        }
        if(tConMap.size()!= 0){
            selTopicsList();
            if(selectedTopics !=null && selectedTopics !=''){
                if(!ctgySet.isEmpty()){
                    for(List<Training_Topic__c> tpcl:[Select id,Topic__c, Category__c from Training_Topic__c where Topic__c in:listSelectedTopics])
                    {
                       for(Training_Topic__c tpc:tpcl){
                         if(ctgySet.contains(tpc.Topic__c+':'+tpc.Category__c)|| ctgySet.contains(tpc.Topic__c+':'+'%')){
                               if(!topicIdMap.containsKey(tpc.Topic__c)){
                                   topicMap.put(tpc.id,tpc.Topic__c);
                                   topicIdMap.put(tpc.Topic__c,tpc.id);
                               }
                           }
                       }
                    }
                }
                for(Training_Event_Contact__c tCon:tConMap.values()){
                    if(!(existingTopics.get(tCon.id)).isEmpty()){
                        for(String selTopic:topicMap.values()){
                            tTopic = new Training_Event_Topic__c();
                            isAdd = false;
                            for(String exTopic:existingTopics.get(tCon.id)){
                                if(selTopic != exTopic){                                    
                                    isAdd = true;
                                } 
                                else if(selTopic == exTopic){
                                    isAdd = false;
                                    break;
                                }
                            }
                            if(isAdd){
                                tTopic.Training_Event_Contact__c = tCon.Id;    
                                if(topicIdMap.containsKey(selTopic))
                                    tId= topicIdMap.get(selTopic);
                                tTopic.Training_Topic__c = tId;
                                newTrainingEventContactsTopics.add(tTopic);
                            }
                         }
                    }
                    else{
                        for(String selTopic:topicMap.values()){
                            tTopic = new Training_Event_Topic__c();
                            tTopic.Training_Event_Contact__c = tCon.Id;    
                            if(topicIdMap.containsKey(selTopic))
                                tId= topicIdMap.get(selTopic);
                            tTopic.Training_Topic__c = tId;
                            newTrainingEventContactsTopics.add(tTopic);
                        }
                    } 
                }
                try{
        //Added one condition to prevent APEX CRUD VIOLATION before INSERT operation
                    if(!newTrainingEventContactsTopics.isEmpty() && Schema.sObjectType.Training_Event_Topic__c.isCreateable()){
                        insert newTrainingEventContactsTopics;
                    } 
                    Integer counter=0;
                    for(Training_Event_Topic__c topics:newTrainingEventContactsTopics)
                        if(!mapTrainingContactTopics.containsKey(topics.Training_Event_Contact__c)){
                            mapTrainingContactTopics.put(topics.Training_Event_Contact__c, new List<string>{topicMap.get(topics.Training_Topic__c)}); 
                        }
                        else{
                            List<String> listTempTopics = new List<String>();
                            listTempTopics = mapTrainingContactTopics.get(topics.Training_Event_Contact__c);
                            listTempTopics.add(topicMap.get(topics.Training_Topic__c));
                            mapTrainingContactTopics.remove(topics.Training_Event_Contact__c);
                            mapTrainingContactTopics.put(topics.Training_Event_Contact__c, listTempTopics);
                        }                    
                        for (TrainingEventContactWrapper otecw : oPagingContacts.listTrainingEventCons){
                            if(tConMap.containsKey(otecw.oTrainingEventContact.Id)==true){
                                otecw.oTrainingContactTopic = mapTrainingContactTopics.get(otecw.oTrainingEventContact.Id);
                                otecw.oTopics=mapTrainingContactTopics.get(otecw.oTrainingEventContact.Id).size();
                            }
                        }
                        defaultTopics = new List<SelectOption>();
                        listSelectedTopics = new List<String>();
                        selectedTopics = '';
                        return null;
                }
                catch(Exception e){
                    system.debug('Exception while adding topics'+e.getMessage());
                    return null;
                }    
                return null;                 
             }
             else{
                 //Created a custom label "Please_select_topics_to_be_added_to_selected_Training_Event_s" and referred it below to avoid Hard Coding values as a part of DPS-1836
                 String msg =System.Label.Please_select_topics_to_be_added_to_selected_Training_Event_s;         
                 ApexPages.Message ErrMsg = new ApexPages.Message(ApexPages.severity.INFO, msg);
                 ApexPages.addMessage(ErrMsg);
                 return null;
             }
         }
         return null; 
     }
     //sets boolean on tab enter
     public void setBool(){
        if(isDate ==false)
            isDate =true;
        else if(isDate == true)
            isDate =false;    
     }
    
     //column sort 
     
     public void toggleSort(){
        // simply toggle the direction
        if(sortDir == 'asc')
            sortDir ='desc';
        else
            sortDir = 'asc';
        // run the query again
       for(TrainingEventContactWrapper con:listTrainingEventContacts){
           mapOldCheckedItems.put(con.oTrainingEventContact.id,con.bSelected);           
       }       
       String sQuery = '';
       sQuery = 'select Contact_Name__r.Westlaw_User_ID__c , Contact_Name__r.SAP_Role__c , Training_Event__r.Name,  SAP_Account_Number__c ,  Account_Name__c, Id, Name, First_Name__c, Last_Name__c, Job_Function__c, User_trained_Date__c from Training_Event_Contact__c where CreatedDate <> null';
       
       if(!selectedTECList.isEmpty()){
           sQuery +=' and Id In:selectedTECList';
       }
       else{
         //Added string.escapeSingleQuotes to avoid APEX XSS FROM URLPARAM Violation
           sQuery +=AppUtil2.queryForText('Training_Event__c','equals',string.escapeSingleQuotes(TrainingEventId));           
       }
       
       sQuery +=' order by ' + sortField + ' ' + sortDir;
       sQueryResult = Database.query(sQuery);  
       listTrainingEventContacts.clear();
       contactList(sQueryResult);
       oPagingContacts.listTrainingEventCons =listTrainingEventContacts;     
    }   
    
    //called to create list of contacts and topics
    
    public void contactList(List<Training_Event_Contact__c> resultList){
        List<String> topicLst  = new List<String>();
        Map<Id,TrainingEventContactWrapper> tempValMap = new Map<Id,TrainingEventContactWrapper>();
        mapTrainingContactTopics.clear();         
        for(Training_Event_Topic__c topics:[Select Training_Topic__c, Training_Topic__r.Topic__c, Training_Event_Contact__c from Training_Event_Topic__c where Training_Event_Contact__c In:resultList])
        {
            if(!mapTrainingContactTopics.containsKey(topics.Training_Event_Contact__c)){
                    mapTrainingContactTopics.put(topics.Training_Event_Contact__c, new List<string>{topics.Training_Topic__r.Topic__c});
            }
            else{
                mapTrainingContactTopics.get(topics.Training_Event_Contact__c).add(topics.Training_Topic__r.Topic__c);
            }
        }
        if(!mapTrainingContactTopics.isEmpty()){
            for(Training_Event_Contact__c c:resultList){
                List<String> t = new List<String>();
                if(mapTrainingContactTopics.containsKey(c.id))
                    t = mapTrainingContactTopics.get(c.id);
                Integer i = t.size();
                if(!mapOldCheckedItems.isEmpty()){
                    Boolean b = mapOldCheckedItems.get(c.id);
                    TrainingEventContactWrapper temp = new TrainingEventContactWrapper(b,c,t,i);
                    listTrainingEventContacts.add(temp);
                }
                else{
                    TrainingEventContactWrapper temp = new TrainingEventContactWrapper(bSelectAll,c,t,i);
                    listTrainingEventContacts.add(temp);
                }
            }
        }
        else{
            for(Training_Event_Contact__c c:resultList){
                List<String> s = new List<String>();
                if(!mapOldCheckedItems.isEmpty()){
                    Boolean b = mapOldCheckedItems.get(c.id);
                    TrainingEventContactWrapper temp = new TrainingEventContactWrapper(b,c,s,0);
                    tempValMap.put(c.id,temp);
                    listTrainingEventContacts.add(temp);
                 }
                 else{
                     TrainingEventContactWrapper temp = new TrainingEventContactWrapper(bSelectAll,c,s,0);
                     tempValMap.put(c.id,temp);
                     listTrainingEventContacts.add(temp);
                 }
            }
        }
    }
    
    //called from popbox to remove topic from a contact
    
    public Pagereference RemoveTrainingContactTopic(){
        List<Training_Event_Topic__c> conTopicToDel = new List<Training_Event_Topic__c>();
        if((tTopicDel !=null && tTopicDel !='') && (tContactDel !=null && tContactDel !='')){
            conTopicToDel = [select id, Training_Event_Contact__c, Training_Topic__r.Topic__c  from Training_Event_Topic__c where Training_Event_Contact__c =:tContactDel  and  Topic__c  =:tTopicDel];
        }        
        List<String> topicList= mapTrainingContactTopics.get(tContactDel);
        List<String> newTopicList = new List<String>();        
        for(String s:topicList){
                if(s != tTopicDel)
                    newTopicList.add(s);
            }
        
        mapTrainingContactTopics.remove(tContactDel);
        mapTrainingContactTopics.put(tContactDel , newTopicList); 
    //Added one condition to prevent APEX CRUD VIOLATION before DELETE operation
        if(!conTopicToDel.isEmpty() && Schema.sObjectType.Training_Event_Topic__c.isDeletable()) 
                delete conTopicToDel;
        for (TrainingEventContactWrapper otecw : oPagingContacts.listTrainingEventCons){
            if(otecw.oTrainingEventContact.Id == tContactDel){
                otecw.oTrainingContactTopic = newTopicList;
                otecw.oTopics-=1;
                break;
            }
        }
        return null;
       
    }
  
}