/**
 * Controller class for LCRMTrainingEventStatusSection VF page
 *
 */
 /**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 
* 2018-07-02  TCS   Modified as part of CRM -15521 to allow access to UKI sales users if they are an opportunity owner.
  2019-03-07  Raghawendra   Modified as part of DPS-2519 at lines 171-186
* =============================================================================
*/ 
public without sharing class OpportunityTeamUserLookup {
    
    Private list<user> territoryUsers;
    
    public List<user> results{get;set;} 
    public string searchString{get;set;}
    public boolean bAcctTerritory{get;set;}
    public id opportunityid{get;set;}    
    public List<TeamMemberSet> teamMemberResults{get;set;}
    public opportunity oOpportunity{get;set;}
    public set<id> existingTeamMembers{get;set;}
    public Boolean loggedInUser {get;set;}
    public Boolean partnerFlag {get;set;}
    Public String errorMessage {get;set;}
    public OpportunityTeamUserLookup(){
    List<opportunityTeamMember> existingOptyTeamMember = new List<opportunityTeamMember>();
        try{
            partnerFlag = false;
            bAcctTerritory = true;
            results = new list<user>();
            searchString = '';
            LoggedInUser= true;
            
            id accountId = (id)System.currentPageReference().getParameters().get('accountid');
            TerritoryUtil.accId = accountId;
            opportunityid = (id)System.currentPageReference().getParameters().get('opportunityid');
            

            if(Schema.sObjectType.opportunity.isAccessible()){
                oOpportunity = [select id, ownerid, name,CreatedBy.id from opportunity where id =:opportunityid ];
            }
            territoryUsers= getTerritoryusers(AccountId);
            ExistingTeamMembers = new set<id>();
            if(Schema.sObjectType.opportunityTeamMember.isAccessible()){
                ExistingOptyTeamMember = [select id,userid from opportunityTeamMember where opportunityid =:opportunityid ];
            }
            if(!ExistingOptyTeamMember.isempty()){            
                for(opportunityTeamMember member:ExistingOptyTeamMember ){
                    ExistingTeamMembers.add(Member.userid);
                }
            }
            //system.debug('***'+territoryUsers);
            if(territoryUsers != null){
                territoryResults();
            }
            TeamMemberResults =populateTeamMemberResults();   
       
        }
        
        catch(exception OException){
          
            Apexpages.addMessages(OException);
            
        }       
    }
     /**Arti - 
     
         * CRM-15521 Checks whether logged in user is UKI sales user and can't access Opportunity if User is not an opportunity owner.  
         * @returns void 
         */
    public void onLoadUser(){
     User oUser= new User();
      String oProfile= [select id, name from profile where id=:UserInfo.getProfileId()].Name;
        //String userId = 
        if(Schema.sObjectType.User.isAccessible()){
            oUser= [select id, name, Sub_Bu__c,Profileid from User where id=:UserInfo.getUserId()];
        }
        system.debug('profile+++'+oUser.Profileid);
        if(oProfile== 'UKI Users' &&  oOpportunity.ownerid!=oUser.id){
           LoggedInUser=false; 
        }
          if(LoggedInUser==false){
         //errorMessage ='You are not authorized to perform this action';
         apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,(system.label.You_are_not_authorized_to_perform_this_action)));
         //ApexPages.addMessage(myMsg);
        }  
        
        
    }
    public void search(){
        partnerFlag = false;
     User userObj = new User();
        try{
            results = new list<user>();
            if(bAcctTerritory){
                if(territoryUsers != null){
                    territoryResults(); 
                }
            }
            else{
                if(searchString != null && searchString.length()>0){
                    String userId = UserInfo.getUserId();
                    String userSalesOrg = '';
                    try{
                        

                        if(Schema.sObjectType.USER.isAccessible()){
                         userObj = [SELECT ID, Sales_Org__c FROM USER WHERE ID = :userId];
                        }
                        userSalesOrg = userObj.Sales_Org__c;
                    }catch(Exception e){
                        System.debug('Exception : '+e.getMessage());
                    }
            
                    searchString = searchString.replace('*','');
                    if(searchString.length()>2 && userSalesOrg == 'GLI'){
                        results=[SELECT Id, Name, Phone, Email, Rep_Employee_Number__c, Rep_Type_Description__c,Profile.Name FROM User WHERE IsActive=true and Rep_Type_Description__c!=null and Sales_Org__c = 'GLI' and name like: '%'+ searchString+'%'];
                    }else if(searchString.length()>2 && userSalesOrg != 'GLI'){
                        results=[SELECT Id, Name, Phone, Email, Rep_Employee_Number__c, Rep_Type_Description__c,Profile.Name FROM User WHERE IsActive=true and Rep_Type_Description__c!=null and Sales_Org__c <> 'GLI' and name like: '%'+ searchString+'%'];
                    }else{
                        throw new apputil.AppException(System.Label.Search_String_should_be_more_than_2_characters);
                    } 
                }
                else{
                    throw new apputil.AppException(System.Label.Search_String_should_be_more_than_2_characters);
                } 
            }
            TeamMemberResults =populateTeamMemberResults();
        }
        catch(exception OException){
            Apexpages.addMessages(OException);
        }
    }    
    
    public string getPageHeader(){
        if(bAcctTerritory){
            return 'Account Territory Members';
        }else{
            return 'Users';
        }
    }
    
    public List<selectOption> getAccess(){
        List<selectOption> access = new List<selectOption>();
        access.add(new selectOption('Edit','Read/Write'));
        return access;
    }
    
    public pageReference addSalesTeam(){
        List<OpportunityTeamMember> listMember = new List<OpportunityTeamMember>();
        List<OpportunityShare> listShareEdit = new List<OpportunityShare>();
        OpportunityShare oShare;
        try{
            for(TeamMemberSet t:TeamMemberResults){
                if(t.isSelected){
                    /*system.debug('test : '+t.TeamMember.Partner_Role__c);
                    if(t.TeamMember.Partner_Role__c!=null && t.TeamMember.Partner_Role__c.contains('Partner Deal Hunter')){
                        apexpages.addmessage(new ApexPages.message(ApexPages.severity.Error,('test deal hunter error')));
                        return null;
                    }*/
                    listMember.add(t.TeamMember);
                    oShare = new OpportunityShare();
                    if(t.TeamMember.userId != oOpportunity.ownerId){
                       oShare.OpportunityAccessLevel='Edit';                       
                       oShare.OpportunityId=opportunityid;
                       oShare.UserOrGroupId=t.TeamMember.userId;
                       if(t.TeamMember.teamMemberRole=='LatAm Partner'){continue;}
                       listShareEdit.add(oShare);    
                   }
                }
             }
             if(!listMember.isempty() && Schema.sObjectType.OpportunityTeamMember.isCreateable()){
               insert listMember;
             }
             if(!listShareEdit.isempty() && Schema.sObjectType.OpportunityShare.isCreateable()){
               insert listShareEdit;
             }  
    /****************************************************************************************************************************
                DPS-2519: added code(171-186) to redirect the interface based on the loggedin theme
    *****************************************************************************************************************************/ 
     
             PageReference ref ;  
             if(UserInfo.getUiThemeDisplayed() == 'Theme3')
                {
                   //String url= 'https://thomsonreutersglis2e--s2eltng--c.visualforce.com/apex/OpportunityDetail?id='+opportunityid+'&sfdc.override=1';
                    ref=(new PageReference (System.currentPageReference ().getParameters().get('retURL')));
                }
                
                else if(UserInfo.getUiThemeDisplayed() == 'Theme4d')
                {
                   String url=  '/lightning/r/Opportunity/'+opportunityid+'/view?0.source=alohaHeader';
                   ref=new PageReference(url);

                }
               
             //return (new PageReference (System.currentPageReference ().getParameters().get('retURL')));
                return ref ;
        }
        catch(exception OException){
            Apexpages.addMessages(OException);
        }
        return null;            
    }
    
    Private list<TeamMemberSet> populateTeamMemberResults(){
        List<TeamMemberSet> teamMemberResults = new List<TeamMemberSet>();
        if(!results.isempty()){            
            for(user oUser:results){
                System.debug('test : '+oUser.Profile.Name);
                if(!ExistingTeamMembers.contains(oUser.id) && oUser.Profile.Name == 'Partner Portal User'){
                    //TeamMemberResults.add(new TeamMemberSet(new opportunityTeamMember(user=oUser,opportunityid=opportunityid,userid=oUser.id,teamMemberrole=oUser.rep_type_description__c)));
                    //skg
                    TeamMemberResults.add(new TeamMemberSet(new opportunityTeamMember(user=oUser,opportunityid=opportunityid,userid=oUser.id,teamMemberrole='LatAm Partner',Email__c = oUser.Email,Phone__c = oUser.Phone)));                                                                                   
                    partnerFlag = true;
                }else if(!ExistingTeamMembers.contains(oUser.id) && oUser.Profile.Name != 'Partner Portal User'){
                    TeamMemberResults.add(new TeamMemberSet(new opportunityTeamMember(user=oUser,opportunityid=opportunityid,userid=oUser.id,teamMemberrole=AppUtil.truncateString(oUser.rep_type_description__c, 40),Email__c = oUser.Email,Phone__c = oUser.Phone)));                                                                                   
                }   
            }            
        }
        return TeamMemberResults;
    } 
    
    private void territoryResults(){
        if(searchString != null && searchString.length()>0){
            searchString = searchString.replace('*','');
            for(user tuser:territoryUsers){                
                if(tuser.name.toLowerCase().contains(searchString.toLowerCase())){
                    results.add(tuser);                   
                }
            }
        }
        else{           
            results = territoryUsers;
        }        
    }
    
    private List<user> getTerritoryusers(id accountId){
        TerritoryUtil territoryUtilObj=new TerritoryUtil();
        return (TerritoryUtilObj.listAccountTerritoryMembers(AccountId));          
    }
    
    // Internal Classes
    Public class TeamMemberSet{
        public opportunityTeamMember teamMember{get;set;}
        Public boolean isSelected{get;set;}
        public TeamMemberSet(opportunityTeamMember teamMember){
            this.TeamMember = TeamMember;
            isSelected=false;           
        }
    }
}