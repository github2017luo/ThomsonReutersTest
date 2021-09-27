Public class ProductTrialTriggerHandler{
    public static Boolean flag = true;
    public static Boolean recflag = true;
    public static void UpdateAccountOnTrial(List<Product_Trial__c> listProductTrials){
        Map<Id,Opportunity> MapOpportunity = new Map<Id,Opportunity>();
        Set<Id> ProductTrialOptyIds = new Set<Id>();
        
        for(Product_Trial__c oProductTrial : listProductTrials){
            ProductTrialOptyIds.add(oProductTrial.Opportunity__c);
        }
        
        MapOpportunity = new Map<Id,Opportunity>([Select Id,AccountId,OwnerId from Opportunity where Id IN : ProductTrialOptyIds]);

       for(Product_Trial__c oProductTrial : listProductTrials){
          if(MapOpportunity.containskey(oProductTrial.Opportunity__c)){
                    oProductTrial.Account__c = MapOpportunity.get(oProductTrial.Opportunity__c).AccountId;
                    oProductTrial.OwnerId = MapOpportunity.get(oProductTrial.Opportunity__c).OwnerId;
          }else{
              oProductTrial.Account__c = null;
          }
      }
    }
    
    public static void InsertTrialUsers(List<Product_Trial__c> listProductTrials){
        Map<Id,List<OpportunityContactRole>> MapOppContacts = new Map<Id,List<OpportunityContactRole>>();
        Set<Id> ProductTrialOptyIds = new Set<Id>();
        List<Trial_User__c> listTrialUsersInsert = new List<Trial_User__c>();
        List<Trial_User__c> ListTrialUsers = new List<Trial_User__c>();
        Map<Id,Set<String>> mapTrialUsers = new Map<Id,Set<String>>(); 
        ListTrialUsers = [Select Product_Trial__c,Contact__c from Trial_User__c where Product_Trial__c IN :listProductTrials];
        
        for(Trial_User__c oTrialUser : ListTrialUsers){
                if(!mapTrialUsers.containskey(oTrialUser.Product_Trial__c)){
                    mapTrialUsers.put(oTrialUser.Product_Trial__c,new Set<String>{oTrialUser.Contact__c});
                }else{
                    mapTrialUsers.get(oTrialUser.Product_Trial__c).add(oTrialUser.Contact__c);
                }
        }
        
        for(Product_Trial__c oProductTrial : listProductTrials){
            ProductTrialOptyIds.add(oProductTrial.Opportunity__c);
        }
        
        for(OpportunityContactRole oOpportunityContact : [Select ContactId,Contact.FirstName,Contact.LastName,Contact.Email,OpportunityId,Role,Contact.SAP_Contact_ID__c from OpportunityContactRole where OpportunityId IN : ProductTrialOptyIds and Role='Trial User']){
            if(!MapOppContacts.containskey(oOpportunityContact.OpportunityId)){
               MapOppContacts.put(oOpportunityContact.OpportunityId,new OpportunityContactRole[]{oOpportunityContact});
             }else{
                 MapOppContacts.get(oOpportunityContact.OpportunityId).add(oOpportunityContact);
             }
        
        }
        
        if(!MapOppContacts.IsEmpty()){
            for(Product_Trial__c oProductTrial : listProductTrials){
                for(OpportunityContactRole oOpportunityContact : MapOppContacts.get(oProductTrial.Opportunity__c)){
                if(MapTrialUsers.IsEmpty() || !MapTrialUsers.get(oProductTrial.Id).contains(oOpportunityContact.Contact.Id)){
                        Trial_User__c oTrialUser = new Trial_User__c(Name = oOpportunityContact.Contact.FirstName+' '+oOpportunityContact.Contact.LastName );
                        oTrialUser.Product_Trial__c = oProductTrial.Id;
                        oTrialUser.First_Name__c = oOpportunityContact.Contact.FirstName;
                        oTrialUser.Last_Name__c = oOpportunityContact.Contact.LastName;
                        oTrialUser.Email__c = oOpportunityContact.Contact.Email;
                        oTrialUser.Contact__c = oOpportunityContact.ContactId;
                        listTrialUsersInsert.add(oTrialUser);
                    }
                }
                insert listTrialUsersInsert;
            }
      }
    }
}