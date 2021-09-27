/*
* Description   : CRM-8693 : Handler for Updating Multi-picklist Account Tier on Account when Customer Master Attribute 5 on SSD is Inserted or Updated.    
* Author        : Noopur Rathod 
* Change History: 06-Nov-2017 Initial Version               
*/

public class UpdateMultiListAccountTierHandler {
          
    private static Boolean isRunOnce = true;
    public static Boolean checkRecursive(){
           if(isRunOnce){
            isRunOnce=false;
            return true;
           } else{
            return isRunOnce;
           }
    }
  
    /*
        This method will update 'Account Tier' field on account when 
       'Customer Master Attribute 5' field on SSD will be inserted or updated.
    */  
    public static void updateAccountTier(List<Source_System_Detail__c> ssdList){
        Id loggedInUserId = UserInfo.getUserId();
        boolean uslUser =false;
       
        String profileName = [SELECT Profile.Id, Profile.Name from User Where Id =:loggedInUserId].Profile.Name;
        String subbu = [SELECT Sub_Bu__c from User Where Id =:loggedInUserId].Sub_Bu__c;
        if(profileName == 'System Administrator' || profileName == 'GLI Sales User' || profileName == 'GLI Sales Ops User' || subbu == 'FindLaw' || subbu == 'USL' || subbu == 'LMS'){
             uslUser = true;
        }
        
        if(uslUser ){
            Map<Id, String> accIds = new Map<Id, String>();
            Set<String> custMaster = new Set<String>();
            for(Source_System_Detail__c ssd: ssdList){
                accIds.put(ssd.Account_Name__c,ssd.LCRM_Customer_Master_Att_5__c); 
                custMaster.add(ssd.LCRM_Customer_Master_Att_5__c);
            } 
            
            List<Account> acctsToUpdate = [Select Id,Account_Tier__c from Account where id in:accIds.keySet()];
            List<Account> accountTier = new List<Account>();
            
            for(Account a : acctsToUpdate) {
                for(String customer: custMaster){
                   if(mapOfSSD.containsKey(customer)){
                     a.Account_Tier__c = mapOfSSD.get(customer);
                     accountTier.add(a);
                    }      
                }
            }
           update accountTier;  
        }
    }

    static Map<String,String> mapOfSSD = new  Map<String,String>();
    
    static{
        mapOfSSD.put( 'XS','Dedicated State Govt');
        mapOfSSD.put( 'X','Key Connection - LMLF or Corp');
        mapOfSSD.put( 'XA','Academic Key Connect');
        mapOfSSD.put( 'LP','LLF Premier Service');
    }
}