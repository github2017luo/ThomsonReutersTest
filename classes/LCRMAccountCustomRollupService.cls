public class LCRMAccountCustomRollupService {
    
    private static Boolean isRunOnce = true;
    public static Boolean checkRecursive(){
           if(isRunOnce){
            isRunOnce=false;
            return true;
           } else{
            return isRunOnce;
           }
    }
    
    public static Boolean loggedInUserFlag = false;
    
    public static void CountRollup(Map<id,Source_System_Detail__c> mapAccountSSDOld,Map<id,Source_System_Detail__c> mapAccountSSDNew){
        
        
        try  
        {
            set<id> accIds = new set<id>();
            loggedInUserFlag = loggedInUserInformatica();
            
            system.debug('@@ Old Map' + mapAccountSSDOld);
            System.debug('@@ New map' + mapAccountSSDNew);
           
            if(!loggedInUserFlag)
            {
                
                if(mapAccountSSdOld!=null && mapAccountSSdNew == null){
                
                   for (Source_System_Detail__c accSSD : mapAccountSSDOld.values()){
                        //condition to handle after delete and undelete scenario
                        if(accSSD!=null){
                             accIds.add(accSSD.Account_Name__c);
                             
                        }
                           
                            system.debug('@@ Account Ids for old map' + accIds);
                    }
                    
                   
                  
                }
                
                
                if(mapAccountSSDNew!=null){
                    system.debug('Inside New Map');
                    for(Source_System_Detail__c accSSDNew : mapAccountSSDNew.values()){                           
                      
                      if(mapAccountSSDOld !=null){
                          Source_System_Detail__c  oldSSD = mapAccountSSDOld.get(accSSDNew.Id);
                          //condition to handle after update scenario
                      
                          if(oldSSD.Account_Name__c != null || oldSSD.LCRM_Count_of_Subscriptions__c !=null){
                              
                              if(accSSDNew.Account_Name__c != oldSSD.Account_Name__c || accSSDNew.LCRM_Count_of_Subscriptions__c != oldSSD.LCRM_Count_of_Subscriptions__c){
                                accIds.add(accSSDNew.Account_Name__c);
                                accIds.add(oldSSD.Account_Name__c);

                              }
                              //condition to handle after insert scenario
                      
                          }
                      }
                      
                      else if(accSSDNew.Account_Name__c != null && accSSDNew.LCRM_Count_of_Subscriptions__c != null){ 
                      
                          accIds.add(accSSDNew.Account_Name__c);
                      }
                      system.debug('@@ Account Ids for new map' + accIds);
                                  
                    }
                }
                
       
                   system.debug('@@ Account Ids' + accIds);
               
                    
                    if(accIds!=null){
                        List<Account> accList = [Select Total_Active_Subscriptions__c from Account where id in:accIds and Is_GLI__c = true];
                        updatetotalActiveSubscription(accList);
                        
                    }else{
                        system.debug('Acc Ids are null');
                    }
                
                    
                }
               
        } 


        catch (Exception e) {
                System.debug(e.getMessage());
            }

    
    }
    
    //method to update the Total active subscription on Account
    
    public static void updatetotalActiveSubscription(List<Account> AccountList){
        
        Map<Id,Double> accIdMap = new Map<Id,Double>();
        List<Account> accList = new List<Account>();
        List<Source_System_Detail__c> accSSDList;
        
        accSSDList = [Select id,LCRM_Count_of_Subscriptions__c,Account_Name__c from Source_System_Detail__c where Account_Name__c in : AccountList];
        system.debug('@@ Account SSD' + accSSDList);
         try{               
       
           if(accSSDList ==null || accSSDList.isEmpty()){
                            
               for(Account acc:AccountList){
                      
                     acc.Total_Active_Subscriptions__c = 0;
                     acclist.add(acc);
               }
                    
           }else{
                     
                 
                 for(Source_System_Detail__c  ssd:accSSDList )
                 {
                     if(accIdMap.get(ssd.Account_Name__c) ==null){
                            accIdMap.put(ssd.Account_Name__c,ssd.LCRM_Count_of_Subscriptions__c);
                            
                     }else{
                                
                             if(ssd.LCRM_Count_of_Subscriptions__c!=null){
                                    
                                    Decimal countActiveSubscription = accIdMap.get(ssd.Account_Name__c) +ssd.LCRM_Count_of_Subscriptions__c;
                                    //accIdMap.get(ssdList.Account_Name__c) +ssdList.LCRM_Count_of_Subscriptions__c;
                                    accIdMap.put(ssd.Account_Name__c,countActiveSubscription);
                                    
                             }
                     }
                 }
                 
                    system.debug('@@ accIdMap' + accIdMap);     
                
                for(Account acc:AccountList)  {
             
                 acc.Total_Active_Subscriptions__c =accIdMap.get(acc.Id);
                 acc.LCRM_Total_Active_Subs_Timestamp__c = datetime.Now();
                 accList.add(acc);
             }
             
             
          }
          
             if(!accList.isEmpty()){
             
             Database.UpsertResult[] srList = Database.upsert(accList,false);
              List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
                    system.debug('srList '+srList );
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully updated Total Active Subscriptions on Account. Account ID: ' + sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Account fields that affected this error: ' + err.getFields());
                                LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                                excepObj.LCRM_Exception_Message__c = err.getMessage();
                                excepObj.LCRM_Exception_Trace__c = 'LCRMAccountSSDRollUp_Batch class'+String.valueof(err.getFields());
                                excepObj.LCRM_Exception_Type__c = 'Error found in LCRMAccountCustomRollupService';
                                excepObj.LCRM_User_ID__c = userinfo.getUserId();
                                exceptionList.add(excepObj);
                            }
                        }
                    }
                     if(!exceptionList.isempty()){
                         insert exceptionList;
                     }
             
             }
         }catch(Exception ex){
             System.debug('error'+ex.getMessage());
         
         }
            
        
    }
    
    //method to check whether the logged In useris Informatica
     public static Boolean loggedInUserInformatica() {
        
        LIST<String> userList= new LIST<String>();         
        SET<String> userSet= new SET<String>();
        //custom setting to store user names which will be bypassed from strikeiron functionality
        KeyValueListStore__c tempValueStore = KeyValueListStore__c.getValues('LCRMCheckInformaticaUser');
        if(tempValueStore !=null && tempValueStore.TextValue__c !=null && tempValueStore.TextValue__c !=''){
            userList = tempValueStore.TextValue__c .split('\n');
        }
        
        if(!userList.isEmpty()){
                for(String s : userList){
                    userSet.add(s.trim().toLowerCase());
                }
        }
        
        //flag is true when logged in user is informatia user that matches name stored in custom setting
        Boolean loggedinUserFlag = userSet.contains(UserInfo.getName().toLowerCase());
        System.debug('loggedinUserFlag : '+loggedinUserFlag+' : '+UserInfo.getName().toLowerCase());
        
        return loggedinUserFlag ;
        }
}