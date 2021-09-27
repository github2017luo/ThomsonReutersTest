global class TakeOwnership{ 
    public TakeOwnership(ApexPages.StandardController controller) {

    }


  webService static void addOpportunityOwner(Id opp, Id oUser) { 
        List<opportunity> listopp = [Select Id,OwnerId from Opportunity where Id=: opp];
        for(Opportunity op : listopp){
            op.OwnerId  = oUser;
        }
        update listopp;
    }
  
   webService static void AddToSalesTeam(Id opp, Id oUser){
      user u = new user();
      u = [select id,Email,Phone from user where id=:oUser];
        
      //String oppid= ApexPages.currentPage().getparameters().get('id');
            
      Opportunity oOpp = [Select OwnerId from Opportunity where Id =: opp limit 1];
           
      Opportunityteammember oteamMember = new Opportunityteammember(UserId=u.id,OpportunityId=opp,Email__c = u.Email,Phone__c = u.Phone );
           
      database.insert(oteamMember);
           
     if(u.id!=oOpp.OwnerId){
           OpportunityShare oppshare = new OpportunityShare(UserorGroupId=u.id,OpportunityId=opp,OpportunityAccessLevel = 'edit');
           database.insert(oppshare);
       }
      }
      
      
      
      
   webService static void addTrainingEventOwner(Id trainingEvent, Id oUser) { 
        List<Training_Event__c> listTrainingEvent = [Select Id,OwnerId from Training_Event__c where Id=: trainingEvent];
        for(Training_Event__c te: listTrainingEvent){
            te.OwnerId  = oUser;
        }
        update listTrainingEvent;
    }
}