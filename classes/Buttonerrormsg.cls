/*
 * 2019-04-05 - Lovedeep Singh - Modified [ DPS-4098 ] Added Auraenabled annotation for PermissiontoButton method so that this could be used by the lightning component LTGS_Apttus_Proposal_Admin. No change introduced in the logic
 * 
 */
global without sharing class Buttonerrormsg{
@AuraEnabled
    WebService static Boolean PermissiontoButton(Id quoteId) {
        Boolean Test=false;    
         if(Schema.sObjectType.PermissionSetAssignment.isAccessible()){
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                    FROM PermissionSetAssignment
                                                                    WHERE AssigneeId = :Userinfo.getUserId() ];
        system.debug('##lstcurrentUserPerSet' + lstcurrentUserPerSet);
        
        for (PermissionSetAssignment psa: lstcurrentUserPerSet)
            {
                system.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
                if(psa.PermissionSet.Name.equals('Apttus_CPQ_Admin_Add_On'))
                    Test = true;
            }
           } 
        return Test;
    }    
}