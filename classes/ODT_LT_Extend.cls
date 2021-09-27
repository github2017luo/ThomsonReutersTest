public class ODT_LT_Extend {
@AuraEnabled
    public static List<String> UserProfileName()
    {
        
        User userDetails =[select id, name,Profile.name, userrole.name from user where id=:UserInfo.getUserId()];
        List<String> userRoleProfile= new List<String>();
        userRoleProfile.add(userDetails.profile.name);
        userRoleProfile.add(userDetails.userrole.name);
        //userRoleProfile.add(userDetails.profile.name);
        return userRoleProfile;
    }
    
   /* 
    @AuraEnabled
    public static Trial__c trialDetails(Id recordId)
    {
        Trial__c trail;
        if (Schema.sObjectType.Trial__c.isQueryable())
            trail = [select id,Name,Contact_LeadId__c,Is_Lead_Converted__c,Trial_Status__c,Trial_Source__c,ODT_Trial_Product_Category__c,Trial_Id__c from Trial__c where id =: recordId];
       
        return trail;
        
    }*/
}