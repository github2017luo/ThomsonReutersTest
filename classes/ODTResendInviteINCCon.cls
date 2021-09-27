public without sharing class  ODTResendInviteINCCon {
    
    public Invite_Colleagues__c inc{get; set;}
    public Boolean eloquaEmailTriggered{get; set;}
    public Boolean checkEmailvalidationBool{get; set;}
    public set<string> incEmailsSet{get; set;}
    
    public ODTresendInviteINCCon(ApexPages.StandardController controller) {
        
       inc = new Invite_Colleagues__c();
       checkEmailvalidationBool = false; 
       incEmailsSet = new SET<string>();
        
        if( controller.getId() != null && Schema.sObjectType.Invite_Colleagues__c.isQueryable()){
            inc =[SELECT ID, Email__c, First_Name__c, Last_Name__c, Trial__r.ODT_SAP_Account_Number__c, Trial__r.Contact_id_SAP__c, Trial__r.Global_Trial_ID__c, Trial__r.ODT_Email__c, Trial__r.Trial_Start_Date__c, 
                        Trial__r.Trial_End_Date__c, Trial__r.ODT_Trial_Product_Category__c, SapContactId__c, trial__c,  User_Auth_ID__c, Trial__r.Is_Lapsed__c  FROM Invite_Colleagues__c WHERE ID=: controller.getId()];
        
        incEmailsSet.add(inc.Trial__r.ODT_Email__c);
         for(Invite_Colleagues__c  i : [Select ID, name, Email__c From Invite_Colleagues__c WHERE trial__c  =: inc.trial__c  AND ID !=: inc.id ]){
             incEmailsSet.add(i.Email__c);
         }
            
       }      
        
    }
    
    
    public void processsINC(){
        boolean checkEmailvalidation = checkEmailValidation(inc.Email__c, inc.Trial__r.ODT_Email__c, incEmailsSet);
        if(inc.id != null && checkEmailvalidation){
               inc.Trial_Status__c = 'Rep Initiated';
               boolean incSrBool = false;
              
               if(Schema.sObjectType.Invite_Colleagues__c.isUpdateable()){
                    database.saveResult incSR = Database.update(inc, false);
                   incSrBool = incSR.isSuccess();
               }
               
               if(incSrBool){
                  LIST<id> incList =  new LIST<id>();
                  incList.add(inc.id);
                  ODT_AddNetnewInvitedcolleagueCallout ora = new ODT_AddNetnewInvitedcolleagueCallout(incList);
                    System.enqueueJob(ora);
                   eloquaEmailTriggered = true;
               }
               
               
                    
        }else{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.ODTAddNewUserEmailErrorMsg);
            ApexPages.addmessage(myMsg);
             
        }
    
    }
    
    public PageReference closeEloquaPopup(){
        PageReference myVFPage = new PageReference('/'+inc.id);
        myVFPage.setRedirect(true);
        return myVFPage;
    }
    
    
    public static boolean checkEmailValidation(string inviteeEmail, string primaryEmail, SET<string> otherEmailIDs){
        
        string primaryDomain='';
        string inviteeDomain='';
        
        if(primaryEmail != null && primaryEmail !=''){
            primaryDomain = primaryEmail.substring(primaryEmail.indexOf('@'));
        }    
        if(inviteeEmail != null && inviteeEmail!=''){
            inviteeDomain = inviteeEmail.substring(inviteeEmail.indexOf('@'));
        }
        boolean issameDomain = inviteeDomain.equalsIgnoreCase(primaryDomain);
        
        boolean isExistingEmail = otherEmailIDs.contains(inviteeEmail);
        
        return (issameDomain & !isExistingEmail );
    
    }
    
    

}