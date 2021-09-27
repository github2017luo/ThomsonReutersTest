/**
* This class is used as controller for mass reassign
* training event page.
* @ Author: Anshita Sharma
* @ Last Modified: Oct 10, 2012
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2012-10-10   Anshita Sharma           Created
* 2017-10-10   Harika Devi Kalidindi   Modified as a part of CRM-10860 to check whether logged in user is authorised user and allows to mass update of training Event
* =============================================================================
*/
public with sharing class massUpdateTEController
{
    
    //Instantiate a StandardSetController
    public ApexPages.StandardSetController setCon;
    
    
    //Properties
    public Boolean isNotAll{get;set;}
    public Boolean isNotUpdtAll{get;set;}
    public boolean isRecords{get;set;}
    public Boolean isNonEdit{get;set;}
    public Boolean isEdit{get;set;}
    public String radioOption;
   
    
    //List
    List<Training_Event__c> selectedLst = new List<Training_Event__c>();
    List<Training_Event__c> editList= new List<Training_Event__c>();
    List<Training_Event__c> nonEditList= new List<Training_Event__c>();
    Map<id, Training_Event__c> tevntMap = new Map<id, Training_Event__c>();
    
    //Constructor
    public massUpdateTEController(ApexPages.StandardSetController controller)
    {
        setCon = controller;
        if(setCon.getSelected().size()>0)
            isRecords = true;
        else
            isRecords = false; 
        isNotAll = true;
        isNotUpdtAll = true;
        isNonEdit = false; 
        isEdit= false;   
        
        this.radioOption = 'Update all Training Events' ;
        getTEvnt();
        if(nonEditList.size()>0)
            isNonEdit=true;
             
        
        
    }
    
   
    //Getters and Setters

public integer getMySelectedSize()
    {
        return null;
        }
    public integer getEditSize()
    {
        integer i=0;
        if(editList.size()!=0)
            return editList.size();
        else
            return i;
    } 
    
    public integer getNonEditSize()
    {
        integer i=0;
        if(nonEditList.size()!=0)
            return nonEditList.size();
        else
            return i;
    } 
    
    public List<Training_Event__c> getEditList()
    {
        return editList;
    } 
    
    public List<Training_Event__c> getNonEditList()
    {
        return nonEditList;
    }    
    //Actions methods and other methods
     
     /**
      * Harika - Modified as part of CRM-10860  to whether logged in user is authorised user and allows to mass update of training Event
      
      */
     public void getTevnt()
     {
     
         if(setCon.getSelected().size()>0)
        {
            selectedLst.clear();
            selectedLst= setCon.getSelected();
        }
         Id loggedinuserroleid =userinfo.getuserroleid();
         Id Loggeduserid =UserInfo.getUserId();
         Boolean haspermssionset  =checkpermissionset(); 
         Set<ID>  allrolesbelowcurrentuser =new   Set<ID> ();
         if(loggedinuserroleid!=null)
         {
         allrolesbelowcurrentuser =getAllSubRoleIds(new Set<ID>{loggedinuserroleid});
         } 
                
        for(Training_Event__c tevnt:selectedLst)
        {
            tevntMap.put(tevnt.id, tevnt);
        }   
         List<Training_Event__c> lstTeEvent =[select id, Training_Name__c, Account__c, name,OwnerId, Training_Date__c,LCRM_Start_Time__c, Status__c ,LCRM_Cancelled_Reason__c from Training_Event__c where id IN:tevntMap.KeySet()];
        
        if(!lstTeEvent.isEmpty())
        {
        for(Training_Event__c tev:lstTeEvent ) //Harika  : Added cancelled reason field in SOQL  a part of CRM-10860
        {
            
            if(tev.Status__c == 'Completed' || tev.Status__c == 'Completed-Duplicate' || tev.Status__c == 'Cancelled')    
            {
                Id ownerroleId;
                Boolean aboverole =false;
                List<User> ouser =[Select Id,UserRoleId,ManagerId  from User where Id=:tev.OwnerId];
                if(ouser.size()>0)
                {
                    ownerroleId =ouser[0].UserRoleId;
                    if(ownerroleId!= null && !allrolesbelowcurrentuser.isEmpty() )
                    {
                        if(allrolesbelowcurrentuser.Contains(ownerroleId))
                        {
                            aboverole =true;
                        }
                    }
                    
                    if(aboverole || ouser[0].ManagerId == Loggeduserid || haspermssionset)
                    {
                         editList.add(tev);
                    }
                    else
                    {
                        nonEditList.add(tev);
                    }
                                   
            }
            
         }
            else
                editList.add(tev);
        }
        }
        if(editList.size()!=0)
        {
            setCon.setSelected(editList);
            isEdit = true;
        }    
     }
    
     
     
    //Called for action attribute of <actionSupport>
    
    public PageReference Test()
    {
       
       return null;
    }    
    
    
    
    //Called for showing available Radio options
    
    public List<SelectOption> getRadioItems()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Update all Training Events','Update all Training Events')); 
        options.add(new SelectOption('Update Individual Training Event','Update Individual Training Event')); 
        return options; 
    }
    
    
    // getter for selected radio option
    
    public String getRadioOption()
    {
        return radioOption;
    }
    
    
    // setter for selected radio option
                        
   public void setRadioOption(String opt)
    {
        this.radioOption= opt;
        if(radioOption != 'Update all Training Events')
            isNotAll = false;               
        else
            isNotAll = true;                   
                      
    }
    
    
    //Called on 'Save' and 'Mass Update' to update optys
    
    public PageReference saveTEvnts()
    {
        List <Training_Event__c> lstToUpdate= new List<Training_Event__c>();
        lstToUpdate = setCon.getSelected();
                 
        try
        {
            if(lstToUpdate.size()>0)
                update lstToUpdate;              
            
        }
        catch(Exception e)
        {
           ApexPages.addMessages(e);
           return null;           
        }       
        Pagereference listPage= new PageReference('/a0K?fcf');
        listPage.setredirect(true);
        return listPage; 
    
    }
    
        /**Harika - 
         * CRM-10860 gets all the roles below logged in users role Id
         * @param  roleIds set of role Ids
         * @returns Set<ID>
         */
    
        public Set<ID> getAllSubRoleIds(Set<ID> roleIds) 
        {
            Set<ID> currentRoleIds = new Set<ID>();
            List<UserRole> lstrole =[select Id,Name from UserRole where ParentRoleId  IN :roleIds AND ParentRoleID != null];
            // get all of the roles underneath the passed roles
            for(UserRole userRole :lstrole)
            {
                currentRoleIds.add(userRole.Id);
            }
    
            // go fetch some more rolls!
            if(currentRoleIds.size() > 0)
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
    
            return currentRoleIds;

        }
    
        /**Harika - 
         * CRM-10860 Checks whether logged in user is having GLI_Training_Event_Authorized_Users permission set
         * @returns Boolean 
         */
        public Boolean checkpermissionset()
        { 
            List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() and PermissionSet.Name ='LCRM_GLI_Training_Event_Authorized_Users'];
            Boolean haspermssionset;
            if(lstcurrentUserPerSet.size()>0)
            {
                 haspermssionset =true;
                
            }
            else{
                haspermssionset =false;
            }
        
            return haspermssionset;
    
    }
  }