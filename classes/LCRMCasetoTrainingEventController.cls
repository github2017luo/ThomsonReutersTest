/**
* Controller class for LCRM Case to Training Event
*
* @author  Saloni Sukhija
* @version 2017-05-30
* @author  Abhirup Banik
* @version 2017-11-02
*/
//Added without sharing keyword to avoid Apex Sharing Violation
public without sharing class LCRMCasetoTrainingEventController{

    public ApexPages.StandardController oStandardController;
    public Case oCase;
    //public String strProfileName;
  
    public LCRMCasetoTrainingEventController(ApexPages.StandardController oController) {
          oStandardController = oController;
          oCase = (Case) oController.getRecord();
      //strProfileName = [SELECT Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name; //Added by Abhirup
    }
    
    public PageReference onPageLoad(){
        
        PageReference pg;
        List<GroupMember> groupList = new List<GroupMember>();
        Boolean isAdmin = false;
        if(Schema.sObjectType.GroupMember.isQueryable())//Added to avoid Apex CRUD violation for PMD Fix
        //checking if the user is a Training Admin
         groupList =  [SELECT group.DeveloperName FROM GroupMember WHERE UserOrGroupId =: UserInfo.getuserId()];

        for(GroupMember gMember:groupList){
            if(gMember.group.DeveloperName == 'GLI_Training_Admins')
                isAdmin = true;
        }
        //Added Schema.sobjectType.Case.isQueryable in if Condition to avoid Apex CRUD Violation
        if(isAdmin || GLI_USL_Profile__c.getInstance(UserInfo.getProfileId()).Is_Logged_In__c && (Schema.sObjectType.Case.isQueryable())){ //Added by Abhirup CRM-3234-Checking logged-in User is GLI USL Profiles
            Case c = [SELECT OwnerId,Account.Name,Subject,AccountId,ContactId,LCRM_Address_1__c,LCRM_Address_2__c,LCRM_City__c,LCRM_State__c,LCRM_Postcode_Zip__c,LCRM_Country__c,LCRM_Preferred_Training_Type__c,LCRM_Anything_else_Trainer_should_know__c,Is_GLI__c,LCRM_Sub_BU__c FROM Case WHERE id = :oCase.id];
            
            if(c != null){
            
                if(! String.valueOf(c.OwnerId).startsWith('005'))
                    pg = Page.LCRM_ConvertCaseOwnerIssuePage;
                
                else{
                    Training_Event__c te = new Training_Event__c();
                    
                    te.OwnerId = c.OwnerId;
                    te.Training_Name__c = c.Account.Name + '-' + System.today().format();
                    te.Account__c = c.AccountId;
                    te.LCRM_Primary_Contact__c = c.ContactId;
                    te.LCRM_Address_1__c = c.LCRM_Address_1__c;
                    te.LCRM_Address_2__c = c.LCRM_Address_2__c;
                    te.LCRM_City__c = c.LCRM_City__c;
                    te.LCRM_State__c = c.LCRM_State__c;
                    te.LCRM_Postcode_Zip__c = c.LCRM_Postcode_Zip__c;
                    te.LCRM_Country__c = c.LCRM_Country__c;
                    te.LCRM_Delivery_Method__c = c.LCRM_Preferred_Training_Type__c;
                    te.Notes__c = c.LCRM_Anything_else_Trainer_should_know__c;
                    te.LCRM_Converted_from_Case__c = c.id;
                    
                    //Is GLI and Sub-Bu fields
                    te.LCRM_Is_GLI__c =  c.Is_GLI__c;
                    te.LCRM_Sub_Bu__c = c.LCRM_Sub_BU__c;
                    
                    Savepoint sp = Database.setSavepoint();
                    try{
                         if(Schema.sObjectType.Training_Event__c.isCreateable())//Added to avoid Apex CRUD Violation
                        insert te;
                              
                        if(te.id != null && Schema.sObjectType.LCRM_Training_Event_Case_Product__c.isQueryable()){//Added a condition to avoid Apex CRUD violation
                            //creating training event products
                            List<LCRM_Training_Event_Case_Product__c> products = [SELECT LCRM_Product__c FROM LCRM_Training_Event_Case_Product__c WHERE LCRM_Training_Event_Case__c = :oCase.Id];
                            if(products!=null && products.size()>0){
                                List<Training_Event_Product__c> tepToCreate = new List<Training_Event_Product__c>();
                                Training_Event_Product__c tep;
                                for(LCRM_Training_Event_Case_Product__c prod:products){
                                    tep = new Training_Event_Product__c(LCRM_Training_Event__c=te.id,LCRM_Product__c=prod.LCRM_Product__c);
                                    tepToCreate.add(tep);
                                }
                                if(Schema.sObjectType.Training_Event_Product__c.isCreateable())//Added to avoid Apex CRUD Violation
                                insert tepToCreate;
                             }
                            
                            //setting the status of the case to Converted            
                            oCase.Status = 'Converted';
                            if(Schema.sObjectType.Case.isUpdateable())//Added to avoid Apex CRUD violation Rule for PMD fixes
                            update oCase;
                        
                        pg = new Pagereference('/'+te.id);
                      }
                  }
                  catch(Exception e){
                      Database.rollback(sp);
                      ApexPages.addMessages(e);
                      return null;
                  }
                }
           }
        }
        else
            pg = Page.LCRM_ConvertCaseErrorPage; //redirecting to error page for non-authorized users
            
        return pg;
    }
}