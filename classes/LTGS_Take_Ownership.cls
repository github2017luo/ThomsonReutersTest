/* Class: LTGS_Take_Ownership
 * Purpose:Controller class to fetch opportunity probability to change the record owner.
 * Created: 3/7/2019
 * Author: Ankit Raj 
 
 * CHANGE HISTORY
 * ==========================================================================================================
 *  Date          Name                 Description
 *  2019-03-07    Ankit                Initial Version
 * ==========================================================================================================
 
 */

public without sharing class LTGS_Take_Ownership {
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
                returnProbability() returns the probability of current opportunity
    *****************************************************************************************************************************/ 
     
    @AuraEnabled
    public static String returnStageName(Id recordId)
    {
        Opportunity opp;
        if (Schema.sObjectType.Opportunity.isQueryable())
            opp = [select id,Name,StageName from Opportunity where id =: recordId];
       
        String stageName = opp.StageName;
        
        return stageName;
        
    }
    /****************************************************************************************************************************
                ChangeOwner() updates the existing record owner to the current loggedin user
    *****************************************************************************************************************************/ 
     
    @AuraEnabled
    public static void ChangeOwner(Id recordId)
    {
     try{           
        Opportunity opp = new Opportunity(Id=recordId);
        
        opp.OwnerId = userInfo.getUserId();
        if (Schema.sObjectType.Opportunity.isUpdateable())
            update opp;
     }

 catch(Exception e)
   {
    String errorMessageLog =  e.getStackTraceString()+ '\n'+String.valueOf(e.getLineNumber())+ '\n'+String.valueOf(e.getCause());                  
    LTGS_ExceptionHandling.createExceptionLog(e.getMessage(), e.getTypeName(),errorMessageLog, UserInfo.getUserID(), 'LTGS_Take_Ownership','Opportunity',''); 
   }   
 }
    
}