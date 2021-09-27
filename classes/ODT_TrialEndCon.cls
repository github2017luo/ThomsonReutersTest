public class ODT_TrialEndCon {
    
    public boolean displayPopup {get; set;}     
    public boolean displayReason{get;set;}
    public boolean displayOtherReason{get;set;}
    public id trialId{get;set;}
    public String trialEndReason{get;set;}
    public String trialEndOtherReason{get;set;}
    public trial__c trial{get;set;}
    public boolean isEnded{get;set;}
    public boolean error{get;set;}
    
    public ODT_TrialEndCon(ApexPages.StandardController controller)
    {
        trialId=ApexPages.currentPage().getParameters().get('id');
        trial =[select id , Trial_Status__c ,Trial_End_Date__c, Early_End_Reason__c, Early_End_Other_Reason__c from trial__C where id =:trialId];
        
        
        displayPopup= true;
        displayReason= true;
        isEnded = false;
        error= false;
    }
    public pageReference closePopup() {   
        displayPopup = false;
        displayReason= false;
        displayOtherReason=false;
        return backToTrial();
    }     
    
    public PageReference backToTrial()
    {
        PageReference pf = new PageReference('/'+trialId);
        pf.setRedirect(true);
        return pf;
        
    }
    
    public void showReason()
    {      
        displayReason= true;
    }
    public void showOtherReason()
    {       
        displayOtherReason=true; 
    }
    public void closeOtherReason()
    {
        displayOtherReason=false;      
    }
    public void endTrial()
    {
        
        system.debug('End called');
        system.debug(trialEndOtherReason+'tttttt');
        system.debug(trialEndReason+'tttttt');
        String trialEndDate = String.valueOf(date.today()); 
        try{
            HTTPResponse res = ODTTrialManagement.postTrialExtendDetails(trialId, 'END', trialEndReason, trialEndDate);
            
            // Parse the JSON response
            system.debug('in the try');
            
            if(res != null){
                system.debug('***********'+res);
                if (res.getStatusCode() == 200) {
                    ESIResponseGetSubscription esiRes = (ESIResponseGetSubscription)JSON.deserialize(res.getBody(), ESIResponseGetSubscription.class);
                    
                    System.debug('esiResp:.......'+esiRes);
                    
                    if(esiRes.notification!=null)
                    {
                        
                        String statusCode = esiRes.notification.statusCode;
                        String statusDescription = esiRes.notification.statusDescription;
                        system.debug('status code '+statusCode+' Description  '+statusDescription);
                        if(statusCode.equals('200'))
                        {
                            system.debug('inside 200');
                            trial.Early_End_Reason__c = trialEndReason;
                            trial.Early_End_Other_Reason__c= trialEndOtherReason;
                            trial.Trial_Status__c='Ended';
                            trial.Trial_End_Date__c=date.today();       
                            trial.ODT_Ended_By__c=userinfo.getUserId();
                            Database.SaveResult ds = database.update(trial,false);
                            
                            if(ds.isSuccess())
                            {
                                isEnded=true;
                                displayPopup=false;
                                System.debug(res.getBody());
                            }
                            else
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Updation failed,Please check logs for details.'));
                                system.debug('Error while updating'+ds.errors);
                                
                                error=true;
                                displayPopup=false;
                            }
                            
                            
                        }
                        else        
                        {
                            String subscriptionMessage='';
                            
                            if(esiRes.onlineContact!=null)
                            {
                                for(ESIResponseGetSubscription.onlineContact olcon: esires.onlineContact)
                                {
                                    if(olcon.entitlements!=null)
                                    {
                                        for(ESIResponseGetSubscription.entitlements ent : olcon.entitlements)
                                        {
                                            if(ent.subscriptions!=null)
                                            {
                                                for(ESIResponseGetSubscription.subscriptions sub : ent.subscriptions)
                                                {
                                                    system.debug('FFFFFFFFFFFFFFFFF'+sub.subscriptionMessage);
                                                    subscriptionMessage=  sub.subscriptionMessage ;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            system.debug('inside else');
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,subscriptionMessage));
                            error=true;
                            displayPopup=false;
                        }
                        
                        
                    }
                    
                }
                else if(res.getStatusCode() == 400){
                    
                    system.debug('other error');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'something went wrong'));
                    error=true;
                }
                
            }
            else 
            {
                system.debug('response null');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Response is null'));
                error=true;
            }
            
            
        }
        catch(Exception e)
        {
            system.debug('in the catch'+e.getStackTraceString());
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            error = true;
        }
        
    }
    
    
}