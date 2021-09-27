/**
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 
* 2/28/2019   Vaishali Gayatri      Controller class for LTGS_MassMuteReassignmentChange_Oppty VF page
* =============================================================================
*/ 

public with sharing class LTGS_massMuteReAssign_TrainingEvent {
    
    
    public boolean hasAccess{get;set;}
    public string  message{get;set;}
    public ApexPages.StandardSetController stdCntrlr {get; set;}
    
    /****************************************************************************************************************************
changeCbx() executes the dml operations if the user has access to modify records ,else it fails
*****************************************************************************************************************************/  
    public void changeCbx()
    {
        
        list<Training_Event__c> listTrainingevent = new list<Training_Event__c>();
        list<Training_Event__c> selectedTrainingevent= (Training_Event__c[])stdCntrlr.getSelected();
        
        try {
            if(hasAccess)
            {
                if(selectedTrainingevent.size()==0)
                {
                    message='Please choose at least one record';
                }
                else
                {
                    for ( Training_Event__c lod : [Select Id,LCRM_Mute_Reassignment__c from Training_Event__c where Id IN: selectedTrainingevent]) //getting selected values from object
                    {
                        lod.LCRM_Mute_Reassignment__c = !(lod.LCRM_Mute_Reassignment__c);
                        listTrainingevent.add(lod);
                    }
                    if(Schema.sObjectType.Training_Event__c.fields.LCRM_Mute_Reassignment__c.isupdateable() && !listTrainingevent.isEmpty())
                    {
                        update listTrainingevent;
                    }
                    message='Selected records updated';
                }
                
            }                
        }
        catch(Exception e)
        {
            String errorMessageLog =  e.getStackTraceString()+ '\n'+String.valueOf(e.getLineNumber())+ '\n'+String.valueOf(e.getCause());                  
            LTGS_ExceptionHandling.createExceptionLog(e.getMessage(), e.getTypeName(),errorMessageLog, UserInfo.getUserID(), 'LTGS_massMuteReAssign_TrainingEvent','Training_Event__c',''); 
        }      
    }    
    
    /****************************************************************************************************************************
Constructor method to check whether user has right permission on page load
*****************************************************************************************************************************/ 
    
    public LTGS_massMuteReAssign_TrainingEvent(ApexPages.StandardSetController controller)
    {
        stdCntrlr = controller;
        message='You do not have permission to update the mute reassignment';   
        hasAccess=false;
        String profileName;
        list<PermissionSetAssignment>psa = new list<PermissionSetAssignment>();
        
        if(Schema.sObjectType.PermissionSetAssignment.isQueryable())
        {
            psa=[SELECT Id FROM PermissionSetAssignment WHERE PermissionSet.Name = 'LCRM_Mute_Reassignment' AND AssigneeId = :userinfo.getUserId()];   //checking whether logged in user is assigned to permission set
        }
        
        profileName=[Select Id,Name from Profile where Id=:UserInfo.getProfileId()].Name;
        
        if(profileName == 'Elite Sales Ops' || profileName == 'GLI Sales Ops User'|| profileName =='UKI Sales Ops' || profileName == 'System Administrator' || !psa.isEmpty())
        {
            hasAccess=true;                               
        }
    }    
    
    
}