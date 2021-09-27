trigger nitroTrigger_OpportunityRenewal on Opportunity (after insert, after update) {
 /* skg
  if (nitro.NitroCommonUtility.isParticipant()) {
        
    StaticResource RoleList = [select id, Name, Body from StaticResource where Name = 'nitro_RenewalRolesList' limit 1];
    set<string> QualifiedRoles = new set<string> {};
    QualifiedRoles.addAll(RoleList.body.toString().split(',',-2));
    
    Set <id> ownerSet = new Set<id>();
    set<id> userQuotaSet = new set<id>();
    map <id,User> quotaMap;
    map <id, UserQuota__c> userQuotaMap = new map<id,UserQuota__c>() ;
    nitro.NitroAPICall apiCall = new nitro.NitroAPICall();  
    
    Integer actionCounter = 0;
    
    // Get a list of all the owners who have closed deals. 
    for (Opportunity o: Trigger.new) {
      if (Trigger.isUpdate) {
        // If the Nitro State field triggered this, then it was as a result
        // of an Opportunity insert, and we don't want to do any further processing. 
        if (o.nitro__Nitro_State__c != System.Trigger.oldMap.get(o.Id).nitro__Nitro_State__c) {
          continue;
        } 
      }
      
      // If this opportunity is marked as won, throw the owner in the list of
      // quotas to be computed. 
      if (!nitro_TriggerRunOnce.isAlreadyDone(o.id)) {
        if ((trigger.isInsert && o.StageName == '100%') ||
            (trigger.isUpdate && o.StageName == '100%' && trigger.oldMap.get(o.id).StageName != '100%')) {
          system.debug('Opp UserQuota is '+o.User_Quota__c);
          ownerSet.add(o.ownerId);
          if (o.User_Quota__c != null) {
            userQuotaSet.add(o.User_Quota__c);
          }
          
        }
      }
    }
    
    if (!ownerset.isEmpty()) {
      // Get all the quotas. 
      quotaMap = new map<id,User> ([Select id, UserRoleID, UserRole.Name 
                                                 from User u 
                                                 where u.id in :ownerSet]);
                  
      // Get only UserQuota records with a valid Renewal__c value
      if (!userQuotaSet.isEmpty()) {
        userQuotaMap = new map<id, UserQuota__c>([select id, Renewal__c, User__c, Fiscal_Month__c 
                                                   from UserQuota__c 
                                                   where id IN: userQuotaSet and 
                                                   Renewal__c != null and 
                                                   Renewal__c != 0]);
      }
        
      
      
      // Get the Nitro Configuration data.  
      nitro__Nitro_Configuration__c nitroConfigData = nitro__Nitro_Configuration__c.getInstance('nitro');
      // if it's null, then quit.  
    
      if (NitroConfigData != null && NitroConfigData.nitro__Time__c != null) {
        
        // get the timeframe from Nitro Configs. 
        String timeFrame = nitroConfigData.nitro__Time__c;   
       
        // get all the opportunities marked as closed-won in the specified timeframe by all the users in the set.
        map <id,Opportunity> timeFrameOpps = new map<id,Opportunity>{};
       
        string queryTime = (timeframe == 'Week')? 'THIS_WEEK' : 
                         (timeframe == 'Month')? 'THIS_MONTH' : 
                         (timeframe == 'Quarter')? 'THIS_FISCAL_QUARTER' : 
                         (timeframe == 'Year')? 'THIS_FISCAL_YEAR' : 
                         '';
       // Get only Opps that have a valid Renewal Amount value
        string tfOppQuery = (timeFrame != 'AllTime' || timeFrame == null) ?'SELECT id, OwnerId, Total_Renewal__c,CloseDate FROM Opportunity WHERE '+
                                                      'OwnerId in :ownerSet AND '+
                                                      'CloseDate = '+queryTime+' AND '+
                                                      'Total_Renewal__c != null AND Total_Renewal__c != 0 AND '+
                                                      'isWon = true' :
                                                    'SELECT id, OwnerId, Total_Renewal__c,CloseDate FROM Opportunity WHERE '+
                                                    'OwnerId in :ownerSet AND '+
                                                    'Total_Renewal__c != null AND Total_Renewal__c != 0 AND '+
                                                  'isWon = true';
        
        for (Opportunity oldOpp : database.query(tfOppQuery)) {
          timeframeOpps.put(oldOpp.id,oldOpp);
        }

          for (Opportunity Opp : trigger.new) {
            //if userquota lookup is not populated avaoid the logic
            if(userQuotaMap.values()!=null || userQuotaMap.values().size()>0){
                if ((trigger.isUpdate && trigger.oldMap.get(Opp.id).StageName != '100%' && Opp.StageName == '100%') ||
                     (trigger.isInsert && Opp.StageName == '100%')) {

                    //if (QualifiedRoles.contains(quotaMap.get(Opp.OwnerId).UserRole.Name)) {
                     apiCall.addLogAction('OPPORTUNITY_RENEWAL_CLOSEDWON',Opp.OwnerID);
                     actionCounter++;
                     nitro_TriggerRunOnce.setAlreadyDone(Opp.id);
                  
                     // Add the current Opp into the timeFrameOpps list to include in the total. 
                    timeFrameOpps.put(Opp.id,Opp);  
                    Decimal rQTotal = 0;
                    Decimal uQTotal = 0;
                     // add up all the dollar amounts for the TimeFrameOpps list. 
                     for (Opportunity tFopp : timeFrameOpps.values()) { 
                         if (tFopp.OwnerId == Opp.ownerId && tFopp.Total_Renewal__c != null) {
                             RQtotal = RQtotal + tFopp.Total_Renewal__c; 
                             for (UserQuota__c UQ : userQuotaMap.values()) {
                                 list<integer> uQMthYr = nitro_TriggerRunOnce.getMonthYear(UQ.Fiscal_Month__c);
                                 if (uQMthYr[0] == tFOpp.CloseDate.Month() && 
                                    uQMthYr[1] == tFOpp.CloseDate.Year() &&
                                    tFOpp.Total_Renewal__c != null && tFOpp.Total_Renewal__c != 0) {
                                 uQTotal += tFOpp.Total_Renewal__c;
                                }
                            }
                         }
                    }
              

                  if (userQuotaMap != null && 
                      userQuotaMap.get(Opp.User_Quota__c) != null) {
                      decimal uQta = userQuotaMap.get(Opp.User_Quota__c).Renewal__c;
                      
                      // Divide by Quota. 
                      integer percent = ((uQtotal / uQta) * 100).intValue();
                      System.debug('****percent'+percent );
                      apiCall.addLogAction('OPPORTUNITY_RENEWAL_QUOTA_PERCENTACHIEVED',percent,Opp.OwnerID); 
                      //apiCall.addLogAction('OPPORTUNITYRENEWAL_USERQUOTAPERCENT', percent, Opp.OwnerId);
                    }
                  }
                }
             }
           }
      
            if (actionCounter != 0) {
              nitro.NitroProxy.logActions(apiCall.getActionList());  
        }
      }
    }
  //} */
}