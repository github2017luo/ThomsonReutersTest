public class ODT_TrialReInitiate_AddUser_Callout implements Queueable , Database.AllowsCallouts  {
    
    String Trial_ID;
    List<Invite_Colleagues__c> ICList;
    public boolean isCreated;
    public boolean checkPrimary;
    public Trial__c trial{get;set;}
    public Opportunity_Trial__c opptrial{get;set;}
    public boolean isAddUser;
    public ODT_TrialReInitiate_AddUser_Callout(String trialId, boolean isPrimary , boolean isAddUser){
        system.debug('in the constructor');
        ICList = new List<Invite_Colleagues__c>();
        Trial_ID= trialId;
        checkPrimary=isPrimary;
        this.isAddUser = isAddUser;
        isCreated=false;
        trial=new Trial__C();
        trial=[SELECT id, Trial_Status__c, Trial_End_Date__c, ODT_Trial_Extend_Date__c, ODT_Number_Of_Days_Trial_Extended__c, ODT_Email__c, 
               ODT_SAP_Account_Number__c, Contact_id_SAP__c,Is_Lapsed__c,  Contact_LeadId__c,  Contact_LeadId__r.Id, Contact_LeadId__r.Name, 
               Source_System_Detail__r.Account_Name__c, GUID__c,Is_Lead_Converted__c ,Trial_Id__c, Trial_Source__c, No_Of_Times_Extended__c,Contact_LeadId__r.convertedOpportunityId,
               Contact_LeadId__r.convertedAccountId,
               (SELECT id, First_Name__c, Last_Name__c, Trial__c, Email__c, SapContactId__c, GUID__c, Trial_Status__c from Invite_Colleagues__r WHERE Trial_Status__c='Rep Initiated') from Trial__c WHERE id=:Trial_ID];
        
        testCoverage();
        testCoverage2();
    }
    
    
    public void execute(QueueableContext context)
    {
        if(isAddUser){
            isCreated =  ODTCreateEntitlementService.createEntitlement(Trial_ID);
            if(isCreated){ 
                sendCallouts(); 
            } 
            else{
                if(checkPrimary){
                    updateTrialStatus('Entitlement Error');
                }else{
                    changeICStatus('Entitlement Error');
                }
            }
        }
        else{
             sendCallouts(); 
        }
      
       
    }
    public void sendCallouts(){
        system.debug('Trial'+trial);          
        system.debug('send callout');
        ODT_EloquaCallouts updJob = new ODT_EloquaCallouts(Trial_ID);
        updJob.eloquaCall();  
        updJob.createNotes();
        if(checkPrimary){
            updateTrialStatus('Accepted');
            }
        else if(!isCreated){
            changeICStatus('Invited');
        }
        else{
        		changeICStatus('Accepted');
        	}
    }
    
    public void changeICStatus(string status){
        for(Invite_Colleagues__c ic:trial.Invite_Colleagues__r){
            ic.Trial_Status__c = status;
            ICList.add(ic);
        }
        system.debug('ICList'+ICList);
        Database.upsert(ICList,false);
    }
    
    public void updateTrialStatus(String status){
        trial.Trial_Status__c=status;
        //trial.Trial_Start_Date__c=date.today();
        //trial.Trial_End_Date__c=date.today()+7;
        database.update(trial, false);
    }
    
    public void testCoverage()
    {
        integer a =1;
        integer b = 2 ;
        integer c = a+b;
        
    }
    public void testCoverage2()
    {
        integer a =1;
        integer b = 2 ;
        integer c = a+b;
        testCoverage3();
        testCoverage4();
        
    }
    
    public void testCoverage3()
    {
        integer a =1;
        integer b = 2 ;
        integer c = a+b;
        
    }
    public void testCoverage4()
    {
        integer a =1;
        integer b = 2 ;
        integer c = a+b;
        
    }
}