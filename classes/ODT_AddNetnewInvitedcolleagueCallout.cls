public class ODT_AddNetnewInvitedcolleagueCallout implements Queueable , Database.AllowsCallouts  {
  
  private LIST<id> InvitedColleagesIds {get; set;}
  
  public ODT_AddNetnewInvitedcolleagueCallout(LIST<id> incIds){
      
      InvitedColleagesIds = new List<id>();
      InvitedColleagesIds = incIds;
  
  }
  
   public void execute(QueueableContext context){
        LIST<Invite_Colleagues__c> incListToUpdate = new LIST<Invite_Colleagues__c >();
        for(Invite_Colleagues__c inc: [SELECT ID, Email__c, First_Name__c, Last_Name__c, Trial__r.ODT_SAP_Account_Number__c, Trial__r.Contact_id_SAP__c, Trial__r.Global_Trial_ID__c, Trial__r.ODT_Email__c, Trial__r.Trial_Start_Date__c, Trial__r.Trial_End_Date__c, Trial__r.ODT_Trial_Product_Category__c, SapContactId__c, Trial__c, User_Auth_ID__c, Trial__r.Is_Lapsed__c  FROM Invite_Colleagues__c WHERE Id IN: InvitedColleagesIds ]){
           // string incEncryptedStr = sendEloquaRequestToINC(inc);
            ODT_EloquaCallouts updJob = new ODT_EloquaCallouts(inc.Trial__c);
            updJob.eloquaCall();  
            updJob.createNotes();
            
            inc.Trial_Status__c = 'Invited';
            incListToUpdate.add(inc);
       }
       
       database.update(incListToUpdate, false);
       
   }
   
   
   public static string sendEloquaRequestToINC(Invite_Colleagues__c inc){
   
           
           
           string startDate='';
           string endDate='';
           
            
           if(inc.Trial__r.Trial_Start_Date__c != null)
               startDate =  inc.Trial__r.Trial_Start_Date__c.year()+'-'+inc.Trial__r.Trial_Start_Date__c.month()+'-'+inc.Trial__r.Trial_Start_Date__c.day();
           if(inc.Trial__r.Trial_End_Date__c != null)
               endDate =  inc.Trial__r.Trial_End_Date__c.year()+'-'+inc.Trial__r.Trial_End_Date__c.month()+'-'+inc.Trial__r.Trial_End_Date__c.day();
               
               
                          
            string rawURL ='firstName='+inc.First_Name__c+'&lastName='+inc.Last_Name__c+'&InviteeEmailId='+inc.Email__c+'&SAPAccountNum='+inc.Trial__r.ODT_SAP_Account_Number__c+'&primaryContactNum='+inc.Trial__r.Contact_id_SAP__c+'&referenceGroupId='+inc.Trial__r.Global_Trial_ID__c+'&GlobalID='+inc.Trial__r.Global_Trial_ID__c+'&primaryTrialRequester='+inc.Trial__r.ODT_Email__c+'&startDate='+startDate+'&endDate='+endDate+'&trialCategory='+inc.Trial__r.ODT_Trial_Product_Category__c +'&InviteeSFDCID='+inc.id+'&isLapsed='+inc.Trial__r.Is_Lapsed__c+'&onePassId=';
            
            if(inc.User_Auth_ID__c != null){
               rawURL += inc.User_Auth_ID__c;
            }
            
             Blob onDemandTrialBlob = blob.valueof('ondemandtrialpro');
              string onDemandTrialString = EncodingUtil.base64Encode(onDemandTrialBlob);
              Blob cryptoKey = EncodingUtil.base64Decode(onDemandTrialString);
              Blob dataUrl = Blob.valueOf(rawURL);
              Blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , dataUrl);
              String encryptedURL = EncodingUtil.base64Encode(encryptedData);
                    
              String encodedURL = EncodingUtil.urlEncode(encryptedURL, 'UTF-8');
            
           
           // Call Eloqua call to send data
           
           
       return encodedURL;
   
   }
   
   
   
  
}