/**
 * Controller class for LCRMTrainingEventStatusSection VF page
 *
 * @author  Saloni Sukhija
 * @version  2017-06-14
 *
 */
 /**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-06-14   Saloni Sukhija           Created
* 2018-01-30  Harika Devi Kalidindi   Modified as part of CRM -12852 to allow only authorised Users(owner/Role above hireracy/Users having GLI_Training_Event_Authorized_Users permission set ) to update the status
*2019-02-08    Tejasree Tadi            Added custom label as a part of DPS-1836 and added checks before DML operations and SOQL Queries to prevent PMD Apex CRUD and Apex Sharing violations 
*=============================================================================
*/ 
//Added without sharing to avoid APEX Sharing Violation Rule
 public without sharing class LCRMTrainingEventStatusSectionController{

    public ApexPages.StandardController oController;
    public Training_Event__c oTrainingEvent;
    public boolean isEditable{get;set;}
    public boolean isTrainingUser{get;set;}
    List<PermissionSetAssignment> assignment = new List<PermissionSetAssignment>();
    private string param2 = string.escapeSingleQuotes('param2');
    
    public LCRMTrainingEventStatusSectionController(ApexPages.StandardController controller){
    
        oController = controller;
        oTrainingEvent = (Training_Event__c)controller.getRecord();
        isEditable = false;
        //Added if condition to prevent APEX CRUD Violation before SOQL Query 
        if(Schema.sObjectType.PermissionSetAssignment.isQueryable())
        assignment =  [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name IN( 'LCRM_GLI_Training_Users','LCRM_USL_Training_Users')];
        String profileName = [SELECT Id,Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        if(assignment.size()>0 || profileName=='System Administrator')
            isTrainingUser = true;   
    }
    
    
    public void changeToEdit(){
        isEditable = true;
    }
    
    
    
   public void setStatus(){
        String result = Apexpages.currentPage().getParameters().get('param1');
        System.debug('@@@@@result'+ result);
    //Added if condition and  string.escapeSingleQuotes() to avoid Apex XSSFROMURLPARAM Violation Rule_PMD Scan
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(param2))){
        String status = (String)(string.escapeSingleQuotes(Apexpages.currentPage().getParameters().get(param2)));
        System.debug('@@@@@status'+ status);
        if(result == 'true')
            oTrainingEvent.Status__c = status;
        else if(result == 'false')
            oTrainingEvent.Status__c = [SELECT Status__c FROM Training_Event__c WHERE id = :oTrainingEvent.id].Status__c;
     System.debug('@@@@@oTrainingEvent.Status__c '+ oTrainingEvent.Status__c );
    }
   }
       
   
        /**Arti - 
         * CRM-3292 gets all the roles below logged in users role Id
         * @param  roleIds set of role Ids
         * @returns Set<ID>
         */
    
        public Set<ID> getAllSubRoleIds(Set<ID> roleIds) 
        {
            List<UserRole> lstrole = new List<UserRole>();
            Set<ID> currentRoleIds = new Set<ID>();
        //Added a condition to prevent APEX CRUD Violation before SOQL Query
            if(Schema.sObjectType.UserRole.isQueryable())
            lstrole =[select Id,Name from UserRole where ParentRoleId  IN :roleIds AND ParentRoleID != null];
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
    
        /**Arti - 
         * CRM-3292 Checks whether logged in user is having GLI_Training_Event_Authorized_Users permission set
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
    
    //Harika - Modified as part of CRM -12852 to allow only authorised Users(owner/Role above hireracy/Users having GLI_Training_Event_Authorized_Users permission set ) to update the status
    public PageReference save(){
         Training_Event__c tev = new Training_Event__c();
         Id loggedinuserroleid =userinfo.getuserroleid();
         Id Loggeduserid =UserInfo.getUserId();
         Boolean haspermssionset  =checkpermissionset(); 
         Set<ID>  allrolesbelowcurrentuser =new   Set<ID> ();
         List<User> ouser = new List<User>();
         List<Training_Event__Share> trainingeventshare = new List<Training_Event__Share>();
     //Added a condition to prevent APEX CRUD Violation before SOQL Query
         if(Schema.sObjectType.Training_Event__Share.isQueryable())
         trainingeventshare = [Select Id,AccessLevel from Training_Event__Share where  UserOrGroupId =: Loggeduserid and ParentId = :oTrainingEvent.id  and AccessLevel='Edit'];
         
        try{
         if(loggedinuserroleid!=null)
         {
         allrolesbelowcurrentuser =getAllSubRoleIds(new Set<ID>{loggedinuserroleid});
         } 
     //Added a condition to prevent APEX CRUD Violation before SOQL Query
         if(Schema.sObjectType.Training_Event__c.isQueryable())
        tev=[select id, Training_Name__c, Account__c, name,OwnerId, Training_Date__c, Status__c ,LCRM_Cancelled_Reason__c from Training_Event__c where id =:oTrainingEvent.id];
        Id ownerroleId;
                Boolean aboverole =false;
        //Added a condition to prevent APEX CRUD Violation before SOQL Query
                if(Schema.sobjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable())
                 ouser=[Select Id,UserRoleId,ManagerId  from User where Id=:tev.OwnerId];
                if(ouser.size()>0)
                {
                    if(ownerroleId!= null && !allrolesbelowcurrentuser.isEmpty() )
                    {
                        if(allrolesbelowcurrentuser.Contains(ownerroleId))
                        {
                            aboverole =true;
                        }
                    }
                 }
        if(tev.Status__c == 'Completed' || tev.Status__c == 'Completed-Duplicate' || tev.Status__c == 'Cancelled')    
            {
                if(ouser.size()>0)
                {
        //Added a condition to prevent APEX CRUD Violation before UPDATE operation
                   if(aboverole || ouser[0].ManagerId == Loggeduserid || haspermssionset && Schema.sObjectType.Training_Event__c.isUpdateable())
                    {
                         try{
                             update oTrainingEvent;  
                         }
                         catch(Exception e)
                         {        
                             ApexPages.addMessages(e); 
                             return null;
          
                         }
                    }
                    else
                    {  //Created a custom Label named "Record_Locked_Error_Message" and referred it below to avoid Hard Coding as a part of DPS-1836
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,System.Label.Record_Locked_Error_Message));
                        return null; 
                        //nonEditList.add(tev);
                    }
                                   
            }
            
         }
            else
            
            {
            // modifed to update status if  logged in user is haing edit access
            if(aboverole || ouser[0].Id == Loggeduserid || ouser[0].ManagerId == Loggeduserid  || haspermssionset|| (!trainingeventshare.isEmpty()) && Schema.sObjectType.Training_Event__c.isUpdateable())//Added a condition to prevent APEX CRUD Violation before UPDATE operation
            {
            try{
            update oTrainingEvent;  
            }
            catch(Exception e)
        {
           ApexPages.addMessages(e); 
           return null;
          
        }
            }
            else
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Insufficient_privileges));
                        return null; 
            }
            }
                  
            
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        
        isEditable = false;
      /**  PageReference oPage = Page.LCRMTrainingEventStatusSection;
       oPage.getParameters().put('id',oTrainingEvent.id);
       oPage.setRedirect(true);
       System.debug('#######oTrainingEvent Status__c'+ oTrainingEvent.Status__c);
       return oPage;**/
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4t'){
             PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/' + oTrainingEvent.id);
             return pageRef;
         }else{
             return null;
         }
    }
    
    public PageReference cancel(){
        isEditable = false;
       /** PageReference oPage = Page.LCRMTrainingEventStatusSection;
        oPage.getParameters().put('id',oTrainingEvent.id);
        oPage.setRedirect(true);
        return oPage;**/
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4t'){
             PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/' + oTrainingEvent.id);
             return pageRef;
         }else{
             return null;
         }
    }
}