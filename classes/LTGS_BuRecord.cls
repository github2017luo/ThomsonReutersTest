/*
 * Class: LTGS_BuRecord
 * Created: 25/3/2019
 * Author: Samarpreet
 
 * CHANGE HISTORY
 * ==========================================================================================================
 *  Date          Name                 Description
 *  2019-03-25    Samarpreet                Initial Version
  * ==========================================================================================================
 
 */
public without sharing class LTGS_BuRecord {

/****************************************************************************************************************************
                UserProfileName() fetches current loggedin user profile
    *****************************************************************************************************************************/ 
     
    @AuraEnabled
    public static String UserProfileName()
    {
        Profile pro;
        if (Schema.sObjectType.Profile.isQueryable())
            pro = [select id,Name from Profile where id =: userinfo.getProfileId()];        
        String profileName= pro.Name;
       
        return profileName;
    }
    
/****************************************************************************************************************************
                GLIServiceUserCheck() returns whether the user is GLI Or not 
*****************************************************************************************************************************/ 
     
    @AuraEnabled
     public static boolean GLIServiceUserCheck(){
        boolean GLIServiceUser =false;
        List<UKI_Static_Values__mdt> UKISV =[SELECT MasterLabel,UKI_Value__c from UKI_Static_Values__mdt];
        Set<String> GLIProfileSet = new Set<String>();
        string profileID = UserInfo.getProfileID();
        String ProfileName = [SELECT Name from Profile Where Id =:profileID].Name;
        if(UKISV.size()>0){
            for(UKI_Static_Values__mdt val: UKISV){
                if(val.MasterLabel == 'Profiles'){
                    for(String temp:val.UKI_Value__c.split(';')){
                            GLIProfileSet.add(temp);
                        }
                }
             }
        }
        
        if(GLIProfileSet.contains(profileName)){
            GLIServiceUser =true;
        }
        return GLIServiceUser;
    }
    
    
}