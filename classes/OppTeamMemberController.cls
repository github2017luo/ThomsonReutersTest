public without sharing class OppTeamMemberController{
    public String opportunityId {get;set;}
    Public String TeamMemberId;
    Public OpportunityTeamMember oMember;
    Public UserRecordAccess oUserRecordAccess;
    public String strProfileName;
    
    public OppTeamMemberController(ApexPages.StandardController controller) {
         if(Test.isRunningTest()){
            // oMember = [Select Id,Opportunity.OwnerId,UserId,OpportunityId, Opportunity.Is_GLI__c from OpportunityTeamMember where OpportunityId =:controller.getId()];
            oMember = (OpportunityTeamMember)controller.getrecord();
         }
         else{
             TeamMemberId = ApexPages.currentPage().getparameters().get('delID');
             if(Schema.sObjectType.OpportunityTeamMember.isAccessible()){
                oMember = [Select Id,Opportunity.OwnerId,UserId,OpportunityId, Opportunity.Is_GLI__c, Opportunity.StageName,Partner_Role__c  from OpportunityTeamMember where Id=:TeamMemberId];
            } 
        }
         opportunityId = oMember.OpportunityId;
         
        //DPS-18481 - Fetch Profile Name
        if(Schema.sObjectType.Profile.isAccessible()){
            strProfileName = [Select Id, Name from Profile where Id =:UserInfo.getProfileId()].Name;
        }
    }         


    public pagereference deleteSalesTeamMember(){
        
        //DPS-18481/DPS-18577 - to check whether User has assigned custom permission or not
        Boolean hasCustomPermission = FeatureManagement.checkPermission('LatAm_Partner_Channel_Team');
        
        PageReference pageReference = null;
        //DPS-18481/DPS-18577 Restrict Users from Modifying Opportunity Team when the opportunity is Stage = 100%,95% or 5%
        if(!(!hasCustomPermission && !oMember.Opportunity.Is_GLI__c && ((oMember.Opportunity.StageName == '0%' || oMember.Opportunity.StageName == '95%' || oMember.Opportunity.StageName == '100%') || oMember.Partner_Role__c == 'Partner Deal Hunter') && (strProfileName == 'LatAm User' || strProfileName == 'Partner Portal User')))
        {
            //start: added by LCRM
            String UserBusinessUnit = LCRMGenericComponent.getUserBU(); 
            System.debug('UserBusinessUnit : '+UserBusinessUnit);
            Boolean BUFlag = LCRMGenericComponent.validateUserBU(UserBusinessUnit);
            System.debug('BUFlag : '+BUFlag);
            if(Schema.sObjectType.UserRecordAccess.isAccessible()){
                oUserRecordAccess = [SELECT HasAllAccess,HasEditAccess,MaxAccessLevel,RecordId FROM UserRecordAccess where 
                                    RecordId=:opportunityId and UserId=:Userinfo.getUserId()]; 
            }
            System.debug('oUserRecordAccess : '+oUserRecordAccess);
            
            String sErrorMsg = 'Insufficient Privileges.You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.';                        
            
            if(BUFlag == FALSE && Userinfo.getUserId()!=oMember.UserId && oUserRecordAccess.MaxAccessLevel!='All')
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,sErrorMsg ));
            }
            else
            {
                 pageReference = new PageReference('/' + opportunityId);
                 pageReference.getParameters().put('retURL', '/' + opportunityId);
                 // PageReference pageReference = new PageReference('/006/o');
                try{
                    if(BUFlag == TRUE){
                        try{
                            OpportunitySplit oppsplitDel;
                            if(Schema.sObjectType.OpportunitySplit.isAccessible()){
                                oppsplitDel = [SELECT Id, IsDeleted, OpportunityId, Split, SplitAmount, SplitOwner.name, SplitPercentage FROM OpportunitySplit WHERE OpportunityId = :opportunityId AND SplitOwnerId = :oMember.UserId];
                            }
                            System.debug('oppsplitDel : '+oppsplitDel);
                            if(oppsplitDel!=null && oppsplitDel.SplitPercentage>0 && Schema.sObjectType.OpportunitySplit.isAccessible()){ 
                                List<OpportunitySplit> oppsplits = [SELECT Id, IsDeleted, OpportunityId, Split, SplitAmount, SplitOwner.name, SplitPercentage FROM OpportunitySplit WHERE OpportunityId = :opportunityId AND SplitOwnerId <> :oMember.UserId];
                                System.debug('oppsplits : '+oppsplits);
                                for(OpportunitySplit oppsplit : oppsplits){
                                    oppsplit.SplitPercentage = oppsplit.SplitPercentage + oppsplitDel.SplitPercentage;
                                    break;
                                }
                                oppsplitDel.SplitPercentage = 0;
                                oppsplits.add(oppsplitDel);
                                System.debug('oppsplits after : '+oppsplits);
                                if(Schema.sObjectType.OpportunitySplit.isUpdateable()){
                                    update oppsplits;
                                }
                            }
                            if(Schema.sObjectType.OpportunitySplit.isDeletable()){
                                delete oppsplitDel;
                            }
                        }catch(Exception e){
                            System.debug('exception msg : '+e.getMessage());
                            System.debug('exception : '+e.getStackTraceString());
                        }
                    }
                    database.delete(oMember);
                }catch(Exception ex){
                    System.debug('exception : '+ex.getStackTraceString());
                }
                try{
                 deleteShares(new OpportunityTeamMember[]{oMember});
                 }
                 Catch(exception ex){
                    System.debug('Exception'+ex);
                 }
             }
        }
        else if((!hasCustomPermission && !oMember.Opportunity.Is_GLI__c && (oMember.Opportunity.StageName == '0%' || oMember.Opportunity.StageName == '95%' || oMember.Opportunity.StageName == '100%') && (strProfileName == 'LatAm User' || strProfileName == 'Partner Portal User')))
        {
            //DPS-18481 - Error Message
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.LAtamRestictUserMessage));
            
        }
        else if((!hasCustomPermission && !oMember.Opportunity.Is_GLI__c && oMember.Partner_Role__c == 'Partner Deal Hunter' && (strProfileName == 'LatAm User' || strProfileName == 'Partner Portal User')))
        {
            //DPS-18577 - Error Message
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.LatAmUserDealHunterMsg));
        }
        return pageReference; 
    }
    
    private void deleteShares(list<OpportunityTeamMember> TeamMembers){

        List<id> userIds = new List<id>();
        for(OpportunityTeamMember TeamMember:TeamMembers){
            if(TeamMember.userId != TeamMember.Opportunity.ownerid){ 
            
                userIds.add(TeamMember.userId);
            }
        }
        list<OpportunityShare> oShare;
        
        if(Schema.sObjectType.OpportunityShare.isAccessible()){
            oShare = [select id from opportunityshare 
                                            where opportunityId=:opportunityId  and UserOrGroupId in:userIds];
        }
        if(oShare != null && Schema.sObjectType.OpportunityShare.isDeletable()){
            delete oShare;
            
            system.debug('***Opp share Delete::');
        }
    }
}