/**********************************************************************
Copyright @ 2019 TATA CONSULTANCY SERVICES.
---------------------------------------------------------------------------------------
Author, Kruti Shah
----------------------------------------------------------------------------------------
Purpose : Batch class to Assign Sales Rep to Renewal Proposal and Oppty
**********************************************************************/
global class LATAM_BatchToCreateRepAssignment implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query = '';
        String st = String.valueOf(system.today());
        query=' select id,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Proposal_Name__c,';      
        query+= 'Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.OwnerId,Auto_Renewal_Quote__c,Apttus_Proposal__Account__c,OwnerId';
        query+=' from Apttus_Proposal__Proposal__c '; 
        query+=' where Apttus_QPConfig__IsSystemGenerated__c =true and Auto_Renewal_Quote__c=true and DAY_ONLY(createdDate)= ' + st + ' and  Apttus_Proposal__Proposal_Name__c Like \'%Renew%\' ';
        
        system.debug('Query'+query); 
        try{
            return Database.getQueryLocator(query);
        }catch(exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause'+ex.getCause());
            system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());
            return Database.getQueryLocator(query);
        }
    }
    
    global void execute(Database.BatchableContext bc,List<Apttus_Proposal__Proposal__c> proposalsRec){
        system.debug('###Inside Execute'+proposalsRec);
        String businessUnitOfRenewalQuote ='';
        List<Apttus_Proposal__Proposal__c> propList=new List<Apttus_Proposal__Proposal__c>();        
        try{           
            List<Id> actIdsList_Canada = new List<Id>();
            Map<Id, Id> acTeamMemMap_Canada = new Map<Id, Id>();
            //List<AccountTeamMember> AccountTeamMembers_Canada = new List<AccountTeamMember>();    
            List<id> updateOpptyId = new List<id>();
            List<opportunity> listofupdateOppty = new List<opportunity>();
            
            for(Apttus_Proposal__Proposal__c prop : proposalsRec)
            {   
                if(prop.APTS_Proposal_Business_Unit__c.containsignorecase('Canada')){
                    businessUnitOfRenewalQuote = 'Canada';
                    actIdsList_Canada.add(prop.Apttus_Proposal__Account__c);
                }              
            } 
            
            string canadaName = Label.Sales_Rep_Canada;
            User canadaUser = [select id,name from user where name =:canadaName  and IsActive=true limit 1];
            system.debug('canadaUser '+canadaUser );
            
            List<String> teamRole = new List<String>();
            for(CanadaTeamRole__c ctr : CanadaTeamRole__c.getall().values()){
                teamRole.add(ctr.name__c);
            }
                                    
            /* Commented as part of TM2.0 Enablement
            if(actIdsList_Canada != null && actIdsList_Canada.size() >0){                
                AccountTeamMembers_Canada =[select id,accountID,userid, User.IsActive 
                                            from AccountTeamMember 
                                            where accountID in : actIdsList_Canada and User.IsActive=true 
                                            and TeamMemberRole in: teamRole];
            }
            
            system.debug('AccountTeamMembers_Canada.size()'+AccountTeamMembers_Canada.size());
            if(AccountTeamMembers_Canada != null && AccountTeamMembers_Canada.size() >0){
                for(AccountTeamMember acTeam : AccountTeamMembers_Canada){
                    acTeamMemMap_Canada.put(acTeam.accountID,acTeam.userid);
                }     
            }     
            System.debug('1+++++++'+acTeamMemMap_Canada);  
            */     
            //Added By Poonam Garg . Replacing AccountTeamMember with TM2.0 Objects
            //Get Roles from Territory2Type Object for Business Unit Canada
            Set<String> rolesIds=new Set<String>();
            for(Territory2Type terrType:[SELECT Id,Description FROM Territory2Type where description in :teamRole]){
                rolesIds.add(terrType.Id);
            }
            System.debug('Roles++++'+rolesIds);
            Map<id,Set<id>> mapTerrAccIds=new Map<Id,Set<Id>>();  // Store Territory and related AccountIds
            Map<id,id> mapTerrUserIds=new Map<Id,Id>(); // Store Territory and related User Ids
            Set<Id> setTerrIds=new Set<Id>();
            Set<Id> accountIds=new Set<Id>();
            String terrId='';
            if(!rolesIds.isEmpty() && !actIdsList_Canada.isEmpty()){
            //Get the territory ids which have role in Territory2Type object and have related ObjectTerritory2Association record
            List<ObjectTerritory2Association> lsAccountTerritory=  [SELECT Id, ObjectId, Territory2Id FROM ObjectTerritory2Association where objectid IN :actIdsList_Canada
                                                    and Territory2Id IN (Select id from Territory2 where Territory2TypeId IN :rolesIds)];
            
            for(ObjectTerritory2Association  obj:lsAccountTerritory){
                if(obj!=null && obj.Territory2Id !=null && obj.ObjectId!=null){                                         
                if(String.isEmpty(terrId) || terrId!=obj.ObjectId){
                    terrId=obj.Territory2Id;
                    accountIds=new Set<Id>();
                    accountIds.add(obj.ObjectId);
                    mapTerrAccIds.put(obj.Territory2Id ,accountIds);
                    setTerrIds.add(obj.Territory2Id);
                
                }
                else if(obj.Territory2Id==terrId){
                accountIds.add(obj.ObjectId);                                        
                mapTerrAccIds.put(obj.Territory2Id ,accountIds);
                }
                }
            }   
             if(!setTerrIds.isEmpty()){
                //Set a Map of Accounr Ids and UserIds. Get UserIds Related to UserTerritory2Association Object.
                for(UserTerritory2Association usT: [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association where Territory2Id IN :setTerrIds and user.IsActive=true and isActive=true] ){
                    System.debug('ust----'+ust);
                    if(usT!=null && usT.Territory2Id !=null && usT.UserId!=null){                   
                       mapTerrUserIds.put(usT.Territory2Id ,usT.UserId);
                       if(!mapTerrAccIds.isEmpty() && usT.Territory2Id!=null && mapTerrAccIds.get(usT.Territory2Id)!=null){
                          for(Id accId : mapTerrAccIds.get(usT.Territory2Id)){  
                                acTeamMemMap_Canada.put(accId,usT.UserId);
                            }
                       }
                    }
                } 
                }
            } 
            System.debug('AccountTeamMembers_Canada.size()'+acTeamMemMap_Canada.size());            
                        
            for(Apttus_Proposal__Proposal__c prop : proposalsRec){
                if(businessUnitOfRenewalQuote == 'Canada'){
                    system.debug('Canada Prop ID '+prop.id);                    
                    if(acTeamMemMap_Canada.size()>0 && acTeamMemMap_Canada.get(prop.Apttus_Proposal__Account__c)!=null)
                    {
                        prop.OwnerId = acTeamMemMap_Canada.get(prop.Apttus_Proposal__Account__c);                        
                    }
                    else{
                        system.debug('Canada Opportunity '+prop.Apttus_Proposal__Opportunity__c);
                        prop.OwnerId = canadaUser.id;
                        system.debug('Canada Oppty Owner '+prop.Apttus_Proposal__Opportunity__r.OwnerId);                        
                    }
                    updateOpptyId.add(prop.Apttus_Proposal__Opportunity__c);                                       
                }                
                propList.add(prop);                
            }  
            
            //Update Proposal List
            if(propList.size()>0)
            {
                update propList;
            }            
            
            if(updateOpptyId!= null && updateOpptyId.size()>0 && businessUnitOfRenewalQuote == 'Canada')
            {
                system.debug('KS--> Inside Opportunity Update for Canada');
                for(opportunity opptyRec : [select id,ownerId,AccountId from opportunity where id in : updateOpptyId ]){
                    if(acTeamMemMap_Canada.size()>0 && acTeamMemMap_Canada.get(opptyRec.AccountId)!=null)
                    {                        
                        opptyRec.OwnerId = acTeamMemMap_Canada.get(opptyRec.AccountId);
                    }
                    else{
                        opptyRec.OwnerId = canadaUser.id;
                    }                    
                    listofupdateOppty.add(opptyRec);
                } 
                
                if(listofupdateOppty!= null && listofupdateOppty.size()>0)
                {
                    system.debug('Ks-->updateOppty '+listofupdateOppty);
                    update listofupdateOppty;
                }                
            } 
            
        }
        catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}