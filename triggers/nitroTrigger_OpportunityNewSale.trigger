trigger nitroTrigger_OpportunityNewSale on Opportunity (after insert, after update) {
 /* skg
 if (nitro.NitroCommonUtility.isParticipant()) {
    system.debug('ENTER NEWSALE PROCESS');
    StaticResource RoleList = [select id, Name, Body from StaticResource where Name = 'nitro_RenewalRolesList' limit 1];
    set<string> RenewalRoles = new set<string> {};
    RenewalRoles.addAll(RoleList.body.toString().split(',',-2));
    
    Set <id> ownerSet = new Set<id>();
    set<id> userQuotaSet = new set<id>();
    map <id,User> userMap;
    map <id, UserQuota__c> userQuotaMap;
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
      system.debug('triggerRunOnce = '+nitro_TriggerRunOnce.isAlreadyDone(o.id));
      system.debug('StageName is '+o.StageName);
      system.debug('Opp UserQuota is '+o.User_Quota__c);
      if (!nitro_TriggerRunOnce.isAlreadyDone(o.id)) {
        if ((trigger.isInsert && o.StageName == '100%') ||
            (trigger.isUpdate && o.StageName == '100%' && trigger.oldMap.get(o.id).StageName != '100%')) {
           
           ownerSet.add(o.ownerId);
           if (o.User_Quota__c != null)
             userQuotaSet.add(o.User_Quota__c);
        }
      }
    }
    
    if (!ownerset.isEmpty() && !userQuotaSet.isEmpty()) {
        
        userMap = new map<id,User> ([Select u.id, UserRoleID, UserRole.Name  
                                                   from User u where u.id in :ownerSet]);
      if (!userQuotaSet.isEmpty())
          userQuotaMap = new map<id, UserQuota__c>([select id, New_Sale__c, User__c, Fiscal_Month__c 
                                                       from UserQuota__c 
                                                       where id IN: userQuotaSet and 
                                                       New_Sale__c != null and 
                                                       New_Sale__c != 0]);
      
      if (userQuotaMap != null) {
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
            
            string tfOppQuery = (timeFrame != 'AllTime' || timeFrame == null) ?'SELECT id, OwnerId, Total_Incremental__c,CloseDate FROM Opportunity WHERE '+
                                                            'OwnerId in :ownerSet AND '+
                                                            'CloseDate = '+queryTime+' AND '+
                                                            'Total_Incremental__c != null AND Total_Incremental__c != 0 AND '+
                                                            'isWon = true' :
                                                          'SELECT id, OwnerId, Amount, CloseDate FROM Opportunity WHERE '+
                                                          'OwnerId in :ownerSet AND '+
                                                          'Total_Incremental__c != null AND Total_Incremental__c != 0 AND '+
                                                          'isWon = true';                                                                                                     
            
            for (Opportunity oldOpp : database.query(tfOppQuery)) {
              timeframeOpps.put(oldOpp.id,oldOpp);
            }
            
            for (Opportunity Opp : trigger.new) {
                if ((trigger.isUpdate && trigger.oldMap.get(Opp.id).StageName != '100%' && Opp.StageName == '100%') ||
                   (trigger.isInsert && Opp.StageName == '100%')) {
                
                if (!RenewalRoles.contains(userMap.get(Opp.OwnerId).UserRole.Name)) {
                    // Add the current Opp into the timeFrameOpps list to include in the total. 
                timeFrameOpps.put(Opp.id,Opp);  
                    // add up all the dollar amounts for the TimeFrameOpps list. 
                    Decimal uQTotal = 0;
                    for (Opportunity tFopp : timeFrameOpps.values()) { 
                      for (UserQuota__c UQ : userQuotaMap.values()) {
                      list<integer> uQMthYr = nitro_TriggerRunOnce.getMonthYear(UQ.Fiscal_Month__c);
                      if (uQMthYr[0] == tFOpp.CloseDate.Month() && 
                             uQMthYr[1] == tFOpp.CloseDate.Year()) {
                        if (uQMthYr[0] == tFOpp.CloseDate.Month() && 
                            uQMthYr[1] == tFOpp.CloseDate.Year() &&
                            tFOpp.Total_Incremental__c != null && tFOpp.Total_Incremental__c != 0)  {   
                            uQTotal += tFOpp.Total_Incremental__c;
                             }
                          }
                       }
                    }
                    
                    if (userQuotaMap.get(Opp.User_Quota__c) != null) {
                      decimal uQta = userQuotaMap.get(Opp.User_Quota__c).New_Sale__c;
                      
                      // Divide by Quota. 
                      integer percent = ((uQTotal / uQta) * 100).intValue();
                      
                      apiCall.addLogAction('OPPORTUNITYNEWSALE_USERQUOTAPERCENT', percent, Opp.OwnerId);
                      actionCounter++;
                      nitro_TriggerRunOnce.setAlreadyDone(Opp.id);
                    }
                }
              }
            }
            
            if (actionCounter != 0)
                nitro.NitroProxy.logActions(apiCall.getActionList());  
          }
        }
    }
  } */
}