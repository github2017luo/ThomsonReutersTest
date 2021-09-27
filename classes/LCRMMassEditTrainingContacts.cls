/**
* Controller class for LCRM Mass Edit Training Contacts VF page
*
* @author  Saloni Sukhija
* @version 2017-06-06
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-06-16   Saloni Sukhija          Created
* 2018-01-04   Harika Devi Kalidindi   Modified as part of CRM -10938 to send different reminder mails based on logged in user Sub -Bu 
* 2018-01-04   Harika Devi Kalidindi   Added surveyEmail Boolean as part of CRM -11533 to set the activity fields to default values 
* =============================================================================
*/
/** 
 * @description :  Controller class for LCRM Mass Edit Training Contacts VF page
*/
public without sharing class LCRMMassEditTrainingContacts{

    /** @description gettersetter*/ public List<TrainingEventContactWrapper> listTrainingEventContacts{get;set;}
    public List<Training_Event_Contact__c> selectedTECList = new List<Training_Event_Contact__c>();
    public List<Training_Event_Contact__c> sQueryResult = new  List<Training_Event_Contact__c>();
    
    /** @description gettersetter*/ public Map<Id,Training_Event_Contact__c> tempListTrainingEventContacts{get;set;}
    public Map<Id,Boolean> mapOldCheckedItems = new Map<Id,Boolean>();
          
    /** @description gettersetter*/ public Boolean bSelectAll{get;set;}
    /** @description gettersetter*/ public Boolean isRecords{get;set;}
    //added as part of  CRM -11533
    public Static boolean surveyEmail= false;
    //added as part of  CRM -10938
    public Static boolean uslreminderEmail= false;
    
    /** @description gettersetter*/ public Id trainingEventId{get;set;}
    /** @description gettersetter*/ public Integer rSize{get;set;}
    /** @description gettersetter*/ public PagingContacts oPagingContacts {get;set;}
    private string idofTrainingEvent =string.escapeSingleQuotes('id');
    //public String dTrainedDate{get;set;}
    /** @description gettersetter*/ public date dTrainedDate{get;set;}
    /** @description gettersetter*/ public String tEventName{get;set;}  
    /** @description gettersetter*/ public String sortDir{
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    } 
    /** @description gettersetter*/ public String sortField{
        get  { if (sortField == null) {sortField = 'Last_Name__c'; } return sortField;  }
        set;
    }
     
    /** @description gettersetter*/ public String surveyNames{ get;set;}
    /** @description gettersetter*/ public String reminderNames{ get;set;}
    /** @description gettersetter*/ public static string mysubBu{get;set;}
    
    /** 
 * @description :  wrapper class to display list of contacts
*/
    public class TrainingEventContactWrapper{
        /** @description gettersetter*/ public Boolean bSelected{get;set;}
        /** @description gettersetter*/ public Training_Event_Contact__c oTrainingEventContact{get;set;}
        
        /**
         * @description : TrainingEventContactWrapper
         * @param  b 
         * @param  c
         */
        public TrainingEventContactWrapper(Boolean b, Training_Event_Contact__c c){
            bSelected = b;
            oTrainingEventContact = c;
        }
    }
    
    /** 
     * @description :  class PagingContacts for LCRMMassEditTrainingVontacts, extended pageable class to use pagination on page
     */
    public class PagingContacts extends Pageable{
        /** @description gettersetter*/ public List<TrainingEventContactWrapper> listTrainingEventCons {get;set;}
       
        /**
         * @description : PagingContacts
         */
        public PagingContacts(){
            listTrainingEventCons =new List<TrainingEventContactWrapper>(); 
        }        
        
        public override integer getRecordCount() {
            return (listTrainingEventCons == null ? 0 : listTrainingEventCons.size());
        }
        
       public override void moveNext(){
            //system.debug('listTrainingEventCons'+listTrainingEventCons);
            super.moveNext();
        }        
        
       public override void movePrev(){
           super.movePrev();
       }     
    }
    
    /**
         * @description : LCRMMassEditTrainingContacts
         * @param  controller 
     */
    public LCRMMassEditTrainingContacts(ApexPages.StandardSetController controller){
        rSize= controller.getSelected().size();
        oPagingContacts = new PagingContacts();
        oPagingContacts.Pagesize = 100;
        oPagingContacts.listTrainingEventCons = new List<TrainingEventContactWrapper>();
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(idofTrainingEvent ))){
            trainingEventId = (String)(string.escapeSingleQuotes(ApexPages.CurrentPage().getparameters().get(idofTrainingEvent)));
        }
        
        tempListTrainingEventContacts = new Map<Id,Training_Event_Contact__c>();
        //dTrainedDate = System.Today().format();
        dTrainedDate = System.Today();
        isRecords = true; 
        listTrainingEventContacts = new List<TrainingEventContactWrapper>();        
        if(TrainingEventId != null){
            tEventName = [Select Name from Training_Event__c where id =:TrainingEventId].Name; 
        }
        if(controller.getSelected().size() != 0){
            selectedTECList = controller.getSelected();
            bSelectAll = true;
            for(Training_Event_Contact__c tec: [select Training_Event__r.Name, Account_Name__c, Id, Name, First_Name__c, Last_Name__c, LCRM_Email__c, Job_Function__c, Trained__c, User_trained_Date__c,LCRM_Send_Survey__c,LCRM_Send_Reminder__c from Training_Event_Contact__c where Id in :controller.getSelected()])
            {
                tempListTrainingEventContacts.put(tec.id, tec);
            }            
        }
        else{
            bSelectAll = false;
            for(Training_Event_Contact__c tec : [select  Training_Event__r.Name, Account_Name__c , Id, Name, First_Name__c, Last_Name__c, LCRM_Email__c, Job_Function__c, Trained__c, User_trained_Date__c, LCRM_Send_Survey__c,LCRM_Send_Reminder__c from Training_Event_Contact__c where Training_Event__c = :TrainingEventId])
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
        oPagingContacts.listTrainingEventCons = listTrainingEventContacts;
        if(rSize == 0){
            rSize =listTrainingEventContacts.size(); 
        }
    } 
    //Called on click of 'saveAndReturn'
    /**
         * @description : saveAndReturn
         * @return PageReference
    */
    public pageReference saveAndReturn(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeUpdated = new List<Training_Event_Contact__c>();
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c != null){
                tTrainingEventContactWrapper.oTrainingEventContact.Trained__c =true;
            }
            listTrainingEventContactstobeUpdated.add(tTrainingEventContactWrapper.oTrainingEventContact);
        }
        if(!listTrainingEventContactstobeUpdated.isEmpty() && (Schema.sObjectType.Training_Event_Contact__c.isupdateable())){
            update listTrainingEventContactstobeUpdated;
        }
        
        //DPS-20079
        //PageReference pg = new PageReference('/apex/TrainingEventDetail?id='+TrainingEventId);
        PageReference pg = new PageReference(System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.escapeSingleQuotes(trainingEventId));          
           
        return pg;
    }
    
    //Called on click of 'Save'
    /**
         * @description : save
         * @return PageReference
    */
    public pageReference save(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeUpdated = new List<Training_Event_Contact__c>();
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
                    if(tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c != null){
                tTrainingEventContactWrapper.oTrainingEventContact.Trained__c = true;
            }
            listTrainingEventContactstobeUpdated.add(tTrainingEventContactWrapper.oTrainingEventContact);
            
        }
        if(!listTrainingEventContactstobeUpdated.isEmpty()){
            update listTrainingEventContactstobeUpdated;
        }
            
        //reset default date in field to today
        //dTrainedDate = System.Today().format();
        dTrainedDate = System.Today();
        return null;
    }
    
    //called on 'Update Training date' for mass records.
    /**
         * @description : saveMassDate
         * @return PageReference
    */
    public pageReference saveMassDate(){
        //date myDate = date.parse(dTrainedDate);
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.bSelected){
                tTrainingEventContactWrapper.oTrainingEventContact.Trained__c = true;
                //tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c = myDate;
                tTrainingEventContactWrapper.oTrainingEventContact.User_trained_Date__c = dTrainedDate;
                //tTrainingEventContactWrapper.oTrainingEventContact.LCRM_Send_Survey__c = true;
            }
        }
        //dTrainedDate = System.Today().format();
        dTrainedDate = System.Today();
        return null;
    }
    
    //Called on click of 'Remove Selected', deletes training event contact
    /**
         * @description : removeSelected
         * @return PageReference
    */
    public pageReference removeSelected(){
        List<Training_Event_Contact__c> listTrainingEventContactstobeRemoved= new List<Training_Event_Contact__c>();
        List<TrainingEventContactWrapper> listTrainingEventContactsLeft= new List<TrainingEventContactWrapper>();
        
        for(TrainingEventContactWrapper tTrainingEventContactWrapper : listTrainingEventContacts){
            if(tTrainingEventContactWrapper.bSelected){
                listTrainingEventContactstobeRemoved.add(tTrainingEventContactWrapper.oTrainingEventContact);
            }else{
                listTrainingEventContactsLeft.add(tTrainingEventContactWrapper);    
            }
        }
        
        //Commenting out as a part of bug fix DPS-20550
        //if(!listTrainingEventContactstobeRemoved.isEmpty() && Schema.sObjectType.Training_Event_Contact__c.isDeletable()){
        if(!listTrainingEventContactstobeRemoved.isEmpty()){
            delete listTrainingEventContactstobeRemoved;    
        }                         
        
        if(!listTrainingEventContactsLeft.isEmpty()){
            listTrainingEventContacts = listTrainingEventContactsLeft; 
            oPagingContacts.listTrainingEventCons = listTrainingEventContacts; 
            rSize=listTrainingEventContacts.size();  
        }
        else{
            listTrainingEventContacts.clear();
            oPagingContacts.listTrainingEventCons = listTrainingEventContacts;
            rSize=0;                
        }
        return null;
    }
    /**
         * @description : getTrngEvntId
         * @return String
    */
    public String getTrngEvntId(){
        if(TrainingEventId != null){
            return TrainingEventId;
        }else{    
            return null;
        }
    }    
    
     //column sort 
     /**
         * @description : toggleSort
    */
     public void toggleSort(){
        // simply toggle the direction
        if(sortDir == 'asc'){
            sortDir ='desc';
        }else{
            sortDir = 'asc';
        }
        // run the query again
       for(TrainingEventContactWrapper con:listTrainingEventContacts){
           mapOldCheckedItems.put(con.oTrainingEventContact.id,con.bSelected);           
       }       
       String sQuery ='';
       sQuery= 'select Training_Event__r.Name, Account_Name__c, Id, Name, First_Name__c, Last_Name__c, LCRM_Email__c, Job_Function__c, Trained__c, User_trained_Date__c, LCRM_Send_Survey__c,LCRM_Send_Reminder__c from Training_Event_Contact__c where CreatedDate <> null';
       
       if(!selectedTECList.isEmpty()){
           sQuery +=' and Id In:selectedTECList';
       }
       else{
           sQuery +=AppUtil2.queryForText('Training_Event__c','equals',TrainingEventId);           
       }
       
       sQuery +=' order by ' + sortField + ' ' + sortDir;
       sQueryResult = Database.query(sQuery);  
       listTrainingEventContacts.clear();
       contactList(sQueryResult);
       oPagingContacts.listTrainingEventCons =listTrainingEventContacts;     
    }   
    
    //called to create list of contacts
    /**
         * @description : contactList
         * @param resultList
    */
    public void contactList(List<Training_Event_Contact__c> resultList){
            for(Training_Event_Contact__c c:resultList){
                List<String> s = new List<String>();
                if(!mapOldCheckedItems.isEmpty()){
                    Boolean b = mapOldCheckedItems.get(c.id);
                    TrainingEventContactWrapper temp = new TrainingEventContactWrapper(b,c);
                    listTrainingEventContacts.add(temp);
                 }
                 else{
                     TrainingEventContactWrapper temp = new TrainingEventContactWrapper(bSelectAll,c);
                     listTrainingEventContacts.add(temp);
                 }
            }
    }
    
    //Added a surveyEmail check to default Status and Type to "Completed" and "Training Event"
     /**
         * @description : sendSurvey
     */
    public void sendSurvey(){
    
       try{
        List<Id> selectedTEC = new List<Id>();
        Map<Id,String> conMap = new Map<Id,String>();
        
        for(TrainingEventContactWrapper con:listTrainingEventContacts){
        if(con.bSelected){
        
                con.oTrainingEventContact.LCRM_Send_Survey__c =true ;
                selectedTEC.add(con.oTrainingEventContact.Id);
            
        } 
        }
        List<Training_Event_Contact__c> tecList = [select Contact_Name__r.Id,Contact_Name__r.Email from Training_Event_Contact__c where id in :selectedTEC];
        /*for(Training_Event_Contact__c tec:tecList)
            conMap.put(tec.Contact_Name__r.Id,String.valueof(tec.Contact_Name__r.Email));
            
        if(conMap.size() > 0){
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage singleMail;
            //Added as part of CRM-3278 to send email based on Sub Bu.
            mysubBu = [Select Sub_Bu__c From User Where Id = :UserInfo.getUserId()][0].Sub_Bu__c;
            Id templateId;
            If(mysubBu =='USL'|| mysubBu =='US' || mysubBu == 'Global' || mysubBu =='Europe' || mysubBu =='AEM')
            {
             templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'Survey to GLI training attendees'].Id;
             }
             else if(mysubBu =='UKI' || mysubBu =='Elite')
             {
             templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'Survey to training attendees'].Id;
             }
             else if(mysubBu == 'Canada')
             {
             templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'Survey to Canada training attendees'].Id;
             }
                
            for(Id conId:conMap.keySet()){
                if(conMap.get(conId)!= null && conMap.get(conId)!= ''){
                singleMail = new Messaging.SingleEmailMessage();
                singleMail.setTemplateID(templateId);
                singleMail.setWhatId(TrainingEventId);
                singleMail.setTargetObjectId(conId);
                surveyEmail =true;
                emails.add(singleMail);
                }
             }
             
             
             
                             
             if(emails.size() > 0)
                Messaging.sendEmail(emails);
                }*/
                List<Training_Event_Contact__c> updateTEContact =new List<Training_Event_Contact__c>(); 
                for(Training_Event_Contact__c tecontact:tecList)
                {
                tecontact.LCRM_Send_Survey__c =true;
                updateTEContact.add(tecontact);
                }
                 update updateTEContact;
                }
                
                 catch (Exception oException) {
      ApexPages.addMessages(oException);
    }
                 
                } 
                
    
   //Modified as part of CRM -10938 to send different reminder mails based on logged in user Sub -Bu 
    /**
         * @description : sendReminder
     */
    public void sendReminder(){
    
        List<Id> selectedTEC = new List<Id>();
        Map<Id,String> conMap = new Map<Id,String>();
        Map<Id,Id> teconmap =new Map<Id,Id>();
        for(TrainingEventContactWrapper con:listTrainingEventContacts){
        if(con.bSelected){
                con.oTrainingEventContact.LCRM_Send_Reminder__c =true ;
                selectedTEC.add(con.oTrainingEventContact.Id);
                }
            
        } 
        List<Training_Event_Contact__c> tecList = [select Id,Contact_Name__r.Id,Contact_Name__r.Email from Training_Event_Contact__c where id in :selectedTEC];
        for(Training_Event_Contact__c tec:tecList)
        {
            conMap.put(tec.Contact_Name__r.Id,String.valueof(tec.Contact_Name__r.Email));
            teconmap.put(tec.Contact_Name__r.Id,tec.Id);
            }
            
        if(conMap.size() > 0){
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage singleMail;
            mysubBu = [Select Sub_Bu__c From User Where Id = :UserInfo.getUserId()][0].Sub_Bu__c;
            Id templateId;
            If(mysubBu =='USL' || mysubBu =='US' || mysubBu == 'Canada' || mysubBu == 'Global' || mysubBu =='Europe' || mysubBu =='AEM')
            {
            
            templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'USLTraining Event Reminder'].Id;
                
            for(Id conId:conMap.keySet())
            {
                if(conMap.get(conId)!= null && conMap.get(conId)!= '')
                {
               Id tEConId =teconmap.get(conId);
               singleMail = new Messaging.SingleEmailMessage();
                singleMail.setTemplateID(templateId);
                singleMail.setWhatId(tEConId);
                singleMail.setTargetObjectId(conId);
                uslreminderEmail = true;
                emails.add(singleMail);
                }
            }
            
             }
             else if(mysubBu =='UKI' || mysubBu =='Elite')
             {
             try{
             templateId = [SELECT Id FROM EmailTemplate WHERE Name = 'Training Event Reminder'].Id;
             for(Id conId:conMap.keySet())
             {
                if(conMap.get(conId)!= null && conMap.get(conId)!= '')
                {
                
                singleMail = new Messaging.SingleEmailMessage();
                singleMail.setTemplateID(templateId);
                singleMail.setWhatId(TrainingEventId);
                singleMail.setTargetObjectId(conId);
                emails.add(singleMail);
                }
             }
             }catch(EmailException e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:' + e.getMessage()); 
             }
             }
             
            if(emails.size() > 0){
            try{
                Messaging.sendEmail(emails);
                }catch(EmailException e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:' + e.getMessage());
                }
                }
        }
        List<Training_Event_Contact__c> lstTEContact =new List<Training_Event_Contact__c>(); 
        for(Training_Event_Contact__c tecontact:tecList)
                {
                tecontact.LCRM_Send_Reminder__c =true;
                lstTEContact.add(tecontact);
                }
                 update lstTEContact;
    }                   
}