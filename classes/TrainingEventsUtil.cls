public class TrainingEventsUtil {
 
/**
 * Provides methods helper methods for working with TrainingEvents
 *
 * @author  John De Santiago - Thomson Reuters Code Share
 * @version 2011-03-24
 * Test Classes  :testTrainingEventShareTrigger,testTrainingEventAccountTrigger,testTrainingEventDetailController,testTrainingEventfromAccount
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-02-07   Shawn                   Created
 * 2012-05-09   Anshita                 Added 'CreateTrainingEventAccount' Method
 *                                      for QC 3313           
 * 2012-12-11   Nandita                 Added 'createStrategy2TrainingEvent' Method 
 *                                      for QC 3584 
 * 2017-06-20    Saloni Sukhija         Added initialiseGLITrainingEventFields for CRM-3248 
 * 2017-10-26   Harika Devi Kalidindi   Added insertTrainingeventshare and deleteTrainingeventshare for CRM-6180
 * 2017-10-30   Harika Devi Kalidindi   Added sendemailnotification method for CRM - 11010   
 * =============================================================================
 */
    //Constants
 
  
        
    //Public Methods
    
    public static void syncTrainingEventAccounts(Set<Id> trainingEventIds) {
        
        List<Training_Event__c> listTrainingEvents = [SELECT 
                                                        Id, account_level__c
                                                        , (SELECT Id, Account__c FROM Training_Event_Accounts__r)
                                                        , (SELECT Id, Contact_Name__c, Contact_Name__r.AccountId FROM Training_Event_Contacts__r WHERE Contact_Name__r.AccountId != null) 
                                                    FROM 
                                                        Training_Event__c  
                                                    WHERE 
                                                    Id IN :trainingEventIds];
                                                            //Training_Event__c.Account_Level__c = FALSE]; 
                                                            //Id IN :trainingEventIds & Training_Event__c.Account_Level__c = 'FALSE'];
        
        List<Training_Event_Account__c> trainingAccountsToCreate = new List<Training_Event_Account__c>();
        //List<Id> trainingEventAccountToDeleteIds = new List<Id>();
        List<Training_Event_Account__c> trainingEventAccountToDeleteIds = new List<Training_Event_Account__c>();
        
            
        for (Training_Event__c oEvent : listTrainingEvents) {
            if (oEvent.Account_Level__c == false) {
            Set<Id> contactAccountIds = new Set<Id>();
            
            //Get Event Contact Account Ids
            for (Training_Event_Contact__c oEventContact : oEvent.Training_Event_Contacts__r) {
                contactAccountIds.add(oEventContact.Contact_Name__r.AccountId);
            }
            
            //Get Existing Training Accounts
            Set<Id> existingTrainingAccountIds = new Set<Id>();
            
            for (Training_Event_Account__c oEventAccount : oEvent.Training_Event_Accounts__r) {
                existingTrainingAccountIds.add(oEventAccount.Account__c);
            }
            
            
            //Determine Which Tranining Event Accounts to Keep and Add
            Set<Id> accountToKeepIds = new Set<Id>();
            Set<Id> accountToAddIds = new Set<Id>();
            
            for (Id contactAccountId : contactAccountIds) {
                if (existingTrainingAccountIds.contains(contactAccountId)) {
                    //Account to Keep
                    accountToKeepIds.add(contactAccountId);
                }
                else {
                    Training_Event_Account__c oEventAccount = new Training_Event_Account__c();
                    oEventAccount.Training_Event__c = oEvent.Id;
                    oEventAccount.Account__c = contactAccountId;
                    
                    trainingAccountsToCreate.add(oEventAccount);
                    
                    //Account to Add
                    accountToAddIds.add(contactAccountId);
                }
            }
            
            //Determine which Training Accounts to Delete
            for (Training_Event_Account__c oEventAccount : oEvent.Training_Event_Accounts__r) {
                if (accountToKeepIds.contains(oEventAccount.Account__c) == false && accountToAddIds.contains(oEventAccount.Account__c) == false) {
                    //trainingEventAccountToDeleteIds.add(oEventAccount.Account__c);
                    trainingEventAccountToDeleteIds.add(oEventAccount);
                }
            }
        }
        }
        //Create Training Event Accounts
        if (trainingAccountsToCreate.isEmpty() == false) {
            insert trainingAccountsToCreate;
        }
        
        //Delete Training Event Accounts
        if (trainingEventAccountToDeleteIds.isEmpty() == false) {
            delete trainingEventAccountToDeleteIds;
        }
    }
    
    
    public static void LastTrainedUpdateonAccount(List <Training_Event__c> ListTrainingEvents){
        Set<Id> Acc = new Set<ID>();
        List<Training_Event_Account__c> ListTrainingEvenAccs = [Select Id,Training_Event__c,Account__c,Training_Date__c from Training_Event_Account__c where Training_Event__c  IN : ListTrainingEvents];
        TrainingEventAccountUtil.PopulateLastTrainedOnAccount(ListTrainingEvenAccs,Acc);
    }
    
    public static void LastTrainedUpdateonAccountdel(List <Training_Event__c> ListTrainingEvents){
        List<Training_Event_Account__c> ListTrainingEvenAccs =[Select Id,Training_Event__c,Account__c,Training_Date__c from Training_Event_Account__c where Training_Event__c IN : ListTrainingEvents];
        TrainingEventAccountUtil.PopulateLastTrainedOnAccount_Delete(ListTrainingEvenAccs);
    }
    
    public static void CreateTrainingEventAccount(Map<Id, Training_Event__c> MapTrainingEvents){
        List<Training_Event_Account__c> ListTrainingEvenAccs = new List<Training_Event_Account__c>();
        for(Training_Event__c tTevnt:MapTrainingEvents.values()){
            if (tTevnt.Account_Level__c == true){
                Training_Event_Account__c tTEA = new Training_Event_Account__c();
                tTEA.Account__c =  tTevnt.Account__c;
                tTEA.Training_Event__c = tTevnt.Id;
                tTEA.External_Id__c = String.valueOf(tTevnt.Account__c) + String.valueOf(tTevnt.Id);
                ListTrainingEvenAccs.add(tTEA);    
            }        
        }
        if(!ListTrainingEvenAccs.isEmpty())
            insert ListTrainingEvenAccs;        
    }
    
    
    public static void createStrategy2TrainingEvent(Map<Id, Training_Event__c> MapTrainingEvents){
         List<Strategy2TrainingEvent__c> listStrategy2TEvent = new List<Strategy2TrainingEvent__c>();        
        for(Training_Event__c oTrainingEvent : MapTrainingEvents.values()){
          if(oTrainingEvent.Strategy__c!=null){
           Strategy2TrainingEvent__c Strategy2TrainingEvent = new Strategy2TrainingEvent__c(Training_Event__c=oTrainingEvent.Id,
                                                                              Strategy__c=oTrainingEvent.Strategy__c);
                                                                              
           listStrategy2TEvent.add(Strategy2TrainingEvent );
         }
        }
        
        Insert listStrategy2TEvent;
    }
    
    public static void CompletedTrainingEvent(List <Training_Event__c> ListTrainingEvents){
                        DateTime dtmValue;
                                        string sDisplayDate;
         system.debug('CompletedTrainingEvent**');
           //Get all team members to send notification too
        List<Training_Event_Team__c> ListTrainingEventTeam = [Select Training_Event_Team__c, Team_Email__c from Training_Event_Team__c where Training_Event_Team__c  IN : ListTrainingEvents and Send_Notification__c = true];

        //Get all Training Rep names
        List<Training_Event__c> ListTrainingEventReps = [SELECT id, Training_Rep_2__r.Name, Training_Rep_3__r.Name, Training_Rep_4__r.Name FROM Training_Event__c where id IN : ListTrainingEvents];
        Integer i;
        
        map<Id,Training_Event__c>mapofTrainingEventRep =new  map<Id,Training_Event__c>();
        
        for(Training_Event__c Training_Event :ListTrainingEventReps ){
            mapofTrainingEventRep.put(Training_Event.Id,Training_Event);
        }
        system.debug('mapofTrainingEventRep**'+mapofTrainingEventRep.keyset());
        system.debug('mapofTrainingEventRep**'+mapofTrainingEventRep.values());
        
        //map of records
          
          Map<String,List<String>> MapOfTeam_Email=New map<String,List<String>>();                     
          if(!ListTrainingEventTeam.isempty()){
              for(Training_Event_Team__c trainingEventTeam:ListTrainingEventTeam ){
                    if (MapOfTeam_Email.containsKey(trainingEventTeam.Training_Event_Team__c)) {
                     MapOfTeam_Email.get(trainingEventTeam.Training_Event_Team__c).add(trainingEventTeam.Team_Email__c);
                    }else {
                        MapOfTeam_Email.put(trainingEventTeam.Training_Event_Team__c, new List <String> {trainingEventTeam.Team_Email__c});
                    }
          
          }  
          }
              
          
         system.debug('MapOfTeam_Email**'+MapOfTeam_Email.keyset());
         system.debug('MapOfTeam_Email**'+MapOfTeam_Email.values());
          
          OrgWideEmailAddress[] owea;
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //Get the OrgWideEmailAddress to use as the From email address
                    owea = [select Id from OrgWideEmailAddress where DisplayName = 'Salesforce Notification'];
          
          List<Messaging.SingleEmailMessage> listSingleEmailMessages = new List<Messaging.SingleEmailMessage>();
           string sReps;     
           //For each training event
            for (Training_Event__c oEvent : listTrainingEvents) {
                if(!MapOfTeam_Email.isEmpty()){
                 List<String> toAddresses = new List<String>(); 
                 if(MapOfTeam_Email.containsKey(oEvent.Id)){
                 toAddresses.addAll(MapOfTeam_Email.get(oEvent.Id));
                 }
                 system.debug('toAddresses**'+toAddresses);
              //format the date
                if(oEvent.Training_Date__c != null){
                dtmValue = DateTime.newInstance(oEvent.Training_Date__c.year(), oEvent.Training_Date__c.month(), oEvent.Training_Date__c.day());
                }
                if(dtmValue != null)
                sDisplayDate = dtmValue.format('MM/dd/yyyy');
                //Get the training Rep namestring 
                sReps = '';
                 
                 system.debug('mapofTrainingEventRep.get(oEvent.Id).Training_Rep_2__r.Name**'+mapofTrainingEventRep.get(oEvent.Id).Training_Rep_2__r.Name);
                 system.debug('mapofTrainingEventRep.get(oEvent.Id).Training_Rep_3__r.Name**'+mapofTrainingEventRep.get(oEvent.Id).Training_Rep_3__r.Name);
                 system.debug('mapofTrainingEventRep.get(oEvent.Id).Training_Rep_4__r.Name**'+mapofTrainingEventRep.get(oEvent.Id).Training_Rep_4__r.Name);
                  if(mapofTrainingEventRep.containsKey(oEvent.Id)) {
                          if (mapofTrainingEventRep.get(oEvent.Id).Training_Rep_2__r.Name != null)
                                sReps = mapofTrainingEventRep.get(oEvent.Id).Training_Rep_2__r.Name + ', ';
                            else
                                sReps = 'X, ';
                            if (mapofTrainingEventRep.get(oEvent.Id).Training_Rep_3__r.Name != null)
                                sReps = sReps + mapofTrainingEventRep.get(oEvent.Id).Training_Rep_3__r.Name + ', ';
                            else
                                sReps = sReps + 'X, ';
                            if (mapofTrainingEventRep.get(oEvent.Id).Training_Rep_4__r.Name != null)
                                sReps = sReps + mapofTrainingEventRep.get(oEvent.Id).Training_Rep_4__r.Name;
                  }//End If
                  system.debug('sReps**'+sReps);
                    String s2 = sReps.replaceAll('X, ', '');
                    system.debug('**'+s2);
                  string sLink = System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ oEvent.Id; 
                  
                  if (owea.size() > 0) {
                         mail.setOrgWideEmailAddressId(owea.get(0).Id); 
                         system.debug('***OrgWideaddress: ' + owea.get(0).Id);          
                     } 
                     
                      mail.setToAddresses(toAddresses);       
                    mail.setSaveAsActivity(false);
                    mail.setSubject('Alert - Training Event ' + oEvent.Name + ' Has Been Completed');
                    mail.setHtmlBody('Please be aware that the following training event has been completed.' +
                        '<p>Training Event : ' + oEvent.Training_Name__c + 
                        '<p>You can access Training Event ' + oEvent.Name + ' directly by clicking <a href="' + sLink + '">here</a>' +
                        '<p>Training Date : ' + sDisplayDate + 
                        '<p>Training Event ID : ' + oEvent.Id +
                        '<p>Training Rep(s) : ' + s2); 
                    listSingleEmailMessages.add(mail);
                }
            }
            system.debug('listSingleEmailMessages**'+listSingleEmailMessages);
              if (!listSingleEmailMessages.isEmpty()) {
                If ( ! Test.isRunningTest() ){ //Prathyush Reddy - Added if statement just as a Temporary Fix to avoid Single Email Limit : 02/12/2016
                Messaging.sendEmail(listSingleEmailMessages);
                }
                
                }

        
    }
    //Internal Classes
    public class TrainingEventsUtilException extends Exception{}
    
    //CRM-3248 to initialise LCRM_Time_Zone__c and LCRM_Owner_s_Manager_s_Email__c 
    public static void initialiseGLITrainingEventFields(List<Training_Event__c> newTrainingEvents){
    
        List<Id> teOwnersIds = new List<Id>();
        Map<Id,User> teOwnersMap;
        List<Id> teOwnersManagersIds = new List<Id>();
        Map<Id,User> teOwnersManagersMap;
        Map<Id,String> teOwnersTimeZoneMap = new Map<Id,String>();
        
        for(Training_Event__c te:newTrainingEvents){
            teOwnersIds.add(te.OwnerId);
        }
        teOwnersMap = new map<Id,User>([SELECT Id,ManagerId,TimeZoneSidKey FROM User WHERE id in :teOwnersIds]);
        
        for(User u:teOwnersMap.values()){
            teOwnersManagersIds.add(u.ManagerId);
            
            List<Schema.PicklistEntry> ple = Training_Event__c.LCRM_Time_Zone__c.getDescribe().getPicklistValues();
            for(Schema.PicklistEntry p: ple){
                if(u.TimeZoneSidKey!='GMT' && p.getValue().contains(u.TimeZoneSidKey))
                    teOwnersTimeZoneMap.put(u.Id,p.getValue());    
            }
            if(u.TimeZoneSidKey=='GMT')
                teOwnersTimeZoneMap.put(u.Id,'(GMT+00:00) Greenwich Mean Time (GMT)'); 

        }
        teOwnersManagersMap = new map<Id,User>([SELECT Id, Email FROM User WHERE Id in :teOwnersManagersIds]);
        
        for(Training_Event__c te:newTrainingEvents){
            if(te.LCRM_Is_GLI__c){
                if(teOwnersMap.size() > 0){
                Id manager = (teOwnersMap.get(te.OwnerId)).ManagerId;
                if(manager != null)
                    te.LCRM_Owner_s_Manager_s_Email__c = (teOwnersManagersMap.get(manager)).Email;
                }
                te.LCRM_Time_Zone__c = teOwnersTimeZoneMap.get(te.OwnerId);
            }
        }
    }
   /*
   CRM -6180
   Description : method is called after training event team record is inserted
   * @param  ListTrainingEventteam  list of trainingevent team after insert  i.e trigger.new 
   */
  public static void afterInsertTrainingTeam(List <Training_Event_Team__c> ListTrainingEventteam)
    {
    for(Training_Event_Team__c teventteam : ListTrainingEventteam)
            {
                insertTrainingeventshare(teventteam.Training_Event_Team__c,teventteam.Training_Team_Member__c);
                if(teventteam.Send_Notification__c)
               {
                    sendemailnotification(teventteam.Id,teventteam.Training_Team_Member__c);
                }
   
            }
    }
    
      /*
   CRM -6180
   Description : method is called before training event team record is deleted
   * @param  ListbeforedeleteTrainingEventteamList of trainingevent team before delete i.e trigger.old 
   */
  public static void beforedeleteteteam(List <Training_Event_Team__c> ListbeforedeleteTrainingEventteam)
    {
    
    for(Training_Event_Team__c teventteam : ListbeforedeleteTrainingEventteam)
        {
           deleteTrainingeventshare(teventteam.Training_Event_Team__c,teventteam.Training_Team_Member__c);
         }
    }
    
    /*
   CRM -6180
   Description : method is called before training event team record is updated 
   * @param  ListTrainingEventteam List of trainingevent team that needs to be updated i.e trigger.new
   * @param  ListbeforeupdateTrainingEventteam  List of trainingevent team before update i.e trigger.old 
   */
  public static void beforeupdateTrainingTeam(List <Training_Event_Team__c> ListTrainingEventteam,List <Training_Event_Team__c> ListbeforeupdateTrainingEventteam)
    {
    
    List<Id> lsttrainingeventteamid= new List<Id>();
    if(!ListbeforeupdateTrainingEventteam.isEmpty())
        {
            for(Training_Event_Team__c teventteam : ListbeforeupdateTrainingEventteam)
            {
                lsttrainingeventteamid.add(teventteam.Id);
            }
        
            Map<Id, Training_Event_Team__c > mapoldteteam = new  Map<Id, Training_Event_Team__c >();
            if(!lsttrainingeventteamid.isEmpty())
            {
                mapoldteteam= new Map<Id, Training_Event_Team__c >([Select Id,Training_Event_Team__c,Training_Team_Member__c,Send_Notification__c from Training_Event_Team__c where Id in :lsttrainingeventteamid]);
            }
    for(Training_Event_Team__c teeam : ListTrainingEventteam)
        {
            if(teeam.Training_Team_Member__c!=mapoldteteam.get(teeam.Id).Training_Team_Member__c)
            {
               deleteTrainingeventshare(teeam.Training_Event_Team__c,mapoldteteam.get(teeam.Id).Training_Team_Member__c);
                insertTrainingeventshare(teeam.Training_Event_Team__c,teeam.Training_Team_Member__c);
            }
            
            if(teeam.Send_Notification__c &&!mapoldteteam.get(teeam.Id).Send_Notification__c)
            {
                sendemailnotification(teeam.Id,teeam.Training_Team_Member__c);
            }
            
            
           
         }
         
         }
         
         }
    
  
    /*
   CRM -6180
   Description : Provides Edit access to the users when he is added into Training event team 
   * @param  trainingeventid Id of Training Event
   * @param  Userid Id of Training event team Member
   */
    
    public static void insertTrainingeventshare(Id trainingeventid,Id Userid)
    {
     
     Training_Event__Share trainEventShare = new Training_Event__Share();
                trainEventShare.ParentId = trainingeventid;
                trainEventShare.UserOrGroupId =Userid;
                trainEventShare.AccessLevel ='Edit';
                
                insert trainEventShare;   
    }
    
     /*
   CRM -6180
   Description : Removes the edit access for the user when he is removed from training event team 
   * @param  trainingeventid Id of Training Event
   * @param  Userid Id of Training event team Member
   */
    
    public static void deleteTrainingeventshare(Id trainingeventid,Id Userid)
    {
     
      Training_Event__Share teSharedelete = [Select Id,AccessLevel from Training_Event__Share where  UserOrGroupId =: Userid and ParentId = :trainingeventid  and AccessLevel='Edit'];
                if(teSharedelete !=null)
                {
                    delete teSharedelete ;
                }  
    }
   
   /*
   *CRM -11010
   *Description : Sends a email to the Training event team member when the send notification chcekbox is checked
   * @param  Teid Id of Training Event
   * @param  uId  Id of Training event team Member
   */ 
    
    public static void  sendemailnotification(Id Teid,Id uId)
    {
        EmailTemplate notificationtemplateId = [SELECT Id, Name, TemplateType FROM EmailTemplate WHERE Name =: Label.Notification_to_Trainingevent_team_Mem];
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                    // Who you are sending the email to
                    mail.setTargetObjectId(uId);    
                    // The email template ID used for the email 
                    mail.setTemplateId(notificationtemplateId .Id); 
                    mail.setWhatId(Teid);
                    mail.setBccSender(false); 
                    mail.setUseSignature(false); 
                    //mail.setReplyTo('recruiting@acme.com'); 
                    mail.setSenderDisplayName('Thomsonreuters Password'); 
                    mail.setSaveAsActivity(false); 
                    //Messaging.sendEmail(mail);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                    }
  
  
}