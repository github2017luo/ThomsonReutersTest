/* 
CHANGE HISTORY
==========================================================================================================
Date          Name       Description
2019-02-27      Rahul      Created apex class for Mass Mute Reassignment button lightning component on Lead Object List View
==========================================================================================================

*/

public without sharing class LTGS_MassMuteReAssignLead
{
    public boolean hasAccess{get;set;}
    public string  message{get;set;}
    public ApexPages.StandardSetController stdCntrlr {get; set;}
    String profileName;
    /****************************************************************************************************************************
changeCbx() executes the dml operations if the user has access to modify records ,else it fails  done as part of sales lightning project
getProfile used in Lighthtning Component LeadConvert
*****************************************************************************************************************************/  
    public void changeCbx()
    {
        
        list<Lead> listlead = new list<Lead>();
        list<Lead> selectedlead= (Lead[])stdCntrlr.getSelected();
        
        try {
            if(hasAccess)
            {
                if(selectedlead.size()==0)
                {
                    message='Please choose at least one record';
                }
                else
                {
                    for ( Lead lod : [Select Id,LCRM_Do_Not_Reassign__c from Lead where Id IN: selectedlead]) //getting selected values from object
                    {
                        lod.LCRM_Do_Not_Reassign__c = !(lod.LCRM_Do_Not_Reassign__c);
                        listlead.add(lod);
                    }
                    if(Schema.sObjectType.Lead.fields.LCRM_Do_Not_Reassign__c.isupdateable() && !listlead.isEmpty())
                    {
                        update listlead;
                    }
                    message='Selected records updated';
                }
                
            }   
            
        }
        catch(Exception e)
        {
            String errorMessageLog =  e.getStackTraceString()+ '\n'+String.valueOf(e.getLineNumber())+ '\n'+String.valueOf(e.getCause());                  
           // LTGS_ExceptionHandling.createExceptionLog(e.getMessage(), e.getTypeName(),errorMessageLog, UserInfo.getUserID(), 'LTGS_MassMuteReAssignLead','Lead',''); 
        }             
    }
    
    @AuraEnabled
    public static string getProfile()
    {
        String profileN=[Select Id,Name from Profile where Id=:UserInfo.getProfileId()].Name;
        return profileN;
    }
    /****************************************************************************************************************************
Constructor method to check whether user has right permission on page load
*****************************************************************************************************************************/ 
    
    public LTGS_MassMuteReAssignLead(ApexPages.StandardSetController controller)
    {
        stdCntrlr = controller;
        message='You do not have permission to update the mute reassignment';   
        hasAccess=false;
        
        list<PermissionSetAssignment>psa = new list<PermissionSetAssignment>();
        profileName= getProfile();          
        if(Schema.sObjectType.PermissionSetAssignment.isQueryable())
        {
            psa=[SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'LCRM_Mute_Reassignment' AND AssigneeId = :userinfo.getUserId()];   //checking whether logged in user is assigned to permission set
        }
        
        
        
        if(profileName == 'Elite Sales Ops' || profileName == 'GLI Sales Ops User'|| profileName =='UKI Sales Ops' || profileName == 'System Administrator' || !psa.isEmpty())
        {
            hasAccess=true;                               
        }
    }
}