/**
* Description   : CRM-5046
*                     
* Change History: 3-May-2017 Added logic to skip GLI leads from assignments.
* 
* 
* 
*/
public class LeadRepAssignmentHandler{

    List<Lead> listLeads = new List<Lead>();
    Set<String> setAccountIds = new Set<String>();
    
    Map<Id,String> MapAccountIds = new Map<Id,String>(); 
   
    Map<Id,String> mapLeadAccount = new Map<Id,String>();
    List<Lead> nonTeamRoleLead = new List<Lead>();
    Map<String,String> MapLead = new Map<String,String>();
    Map<String,Id> MapUser = new Map<String,Id>();
    
    //Map<Id,String> mapZipcode = new Map<Id,String>();
    //Map<Id,String> mapRepType = new Map<Id,String>();
    Set<String> setZipcode = new Set<String>();
    Set<String> setRepType= new Set<String>();
    Set<String> repEmpNumber = new Set<String>();
    Boolean teamrole= false;
    List<QueueSobject> listQueue;
    List<LLM_Queue_Assignment__c> listQueueAssignment;
    List<LLM_Sales_Rep_Assignment__c > salesRepAssignment;
    List<User> userList;
    
    public void leadRepAssigmentProcess(List<Lead> listOfLeads){
    
     system.debug('Leadlist:'+listOfLeads);
     listQueue= [Select q.Id, q.QueueId, q.Queue.Name, q.SobjectType from QueueSobject q where q.SobjectType='Lead'];
     listQueueAssignment = [select id, Channel__c, Queue__c from LLM_Queue_Assignment__c];
     Map<ID, Recordtype> gliRecordTypeIds = new Map<ID, Recordtype>([SELECT ID FROM Recordtype
                                                   where developername in ('Elite','UKI') and sobjecttype = 'Lead' and isActive = true]);
        for (Lead objlead : listOfLeads){
           //Postal Code present on Lead    
           //R2: Adding the GLI logic to skip the GLI Leads from Assignment.   
            if(objlead.Billing_Zip__c != null && !(gliRecordTypeIds.containsKey(objlead.recordtypeid) || objlead.is_Gli__c)){
                setZipcode.add(objlead.Billing_Zip__c);
                 //Rep Type present on Lead.
                if(objlead.Rep_Type__c != null){
                    setRepType.add(objlead.Rep_Type__c);
                    nonTeamRoleLead.add(objlead);                                                 
                }        
            } 
        }
        system.debug('setZipcode..'+setZipcode);
        system.debug('setRepType..'+setRepType);
        //salesRepAssignment= [select id, Rep_Employee_Number__c, Sales_Rep_Name__c,Rep_Type__c,Zipcode__c from LLM_Sales_Rep_Assignment__c where Zipcode__c=:mapZipcode.values() and Rep_Type__c=:mapRepType.values()];
        salesRepAssignment= [select id, Rep_Employee_Number__c,Zipcode__c,Rep_Type__c from LLM_Sales_Rep_Assignment__c where Zipcode__c=:setZipcode and Rep_Type__c=:setRepType];
        
        //Getting the Rep Employee Number from LLMsalesRepAssignment object.
        system.debug('salesRepAssignment:'+ salesRepAssignment);
           if(salesRepAssignment != null && salesRepAssignment.size()>0){
                for(LLM_Sales_Rep_Assignment__c repAssign : salesRepAssignment){
                    system.debug('++++++++++++++++');
                    if(repAssign.Rep_Employee_Number__c  != null){
                        repEmpNumber.add(repAssign.Rep_Employee_Number__c);
        //Taking Zipcode and Reptype as key to Rep employee number
                        MapLead.put(repAssign.Zipcode__c+repAssign.Rep_Type__c,repAssign.Rep_Employee_Number__c);
                    }
                }
         }
        system.debug('maplead values:'+ MapLead.values()); 
        system.debug('repEmpNumber::'+repEmpNumber);
        
        //querying active users using rep emp number
        userList = [SELECT id,name,Rep_Employee_Number__c from user where Rep_Employee_Number__c=:repEmpNumber And IsActive = True];
        for (user u:userList)
        {
                system.debug('*************');
                mapUser.put(u.Rep_Employee_Number__c,u.id);     
        }
        for(Lead leadRole : listOfLeads){
            //Team Role Present on Lead    
           if(leadRole.Team_Role__c != null ){
                  //check account associated into Lead
                  if(leadRole.Account__c != null){
                    setAccountIds.add(leadRole.Account__c);
                    listLeads.add(leadRole);                     
                  }else{
                    channelQueue(leadRole);
                  }
            }else{
                channelQueue(leadRole);
            }
        }
           
        
    
   
    
   
   //List<AccountTeamMember> listAccountTeamMembers = [Select userId, user.Name, Accountid,TeamMemberRole from AccountTeamMember where Accountid = :setAccountIds];
       
    List<AccountTeamMember> listAccountTeamMembers = [Select userId, user.Name, User.Rep_Type_Description__c, Accountid,TeamMemberRole from AccountTeamMember where Accountid = :setAccountIds order by User.Name limit 10000];
     
       // AccountTeamMember based on Account.
       Map<id,List<AccountTeamMember>> teamMemberForAccountMap= new Map<id,List<AccountTeamMember>>();
            if(listAccountTeamMembers != null & listAccountTeamMembers .size()>0){
                for(AccountTeamMember atm: listAccountTeamMembers ){
                    if(teamMemberForAccountMap.ContainsKey(atm.Accountid))
                        teamMemberForAccountMap.get(atm.Accountid).add(atm);
                    else{
                        teamMemberForAccountMap.put(atm.Accountid,new List<AccountTeamMember>());
                        teamMemberForAccountMap.get(atm.Accountid).add(atm);
                    } 
                }
            } 
        //Team Role Present on Lead.    
        for(Lead lead : listLeads){
            List<AccountTeamMember> listTeamMember= new List<AccountTeamMember>();
            listTeamMember = teamMemberForAccountMap.get(lead.Account__c);
            teamrole=false;
           if(listTeamMember != null && listTeamMember.size() > 0){
               for(AccountTeamMember atm : listTeamMember){
                  //if(lead.Team_Role__c == atm.TeamMemberRole){
                  //system.debug('@@@@@Rep_Type_Description__c::'+atm.User.Rep_Type_Description__c);
                  if(lead.Team_Role__c == atm.User.Rep_Type_Description__c){
                      lead.OwnerId = atm.userId;
                      teamrole=true;
                      break;
                  }
                   
               }
             }
           
           if(teamrole==false){
            system.debug('inside the teamrole false condition');
            channelQueue(lead);
           }
        }    
                             
 }
 
 public void channelQueue(Lead olead){
        
    if(olead.Billing_Zip__c == null){
        //if channel present assign to default channel queue.
        if(olead.Business_Org__c != null){                      
            assignDefaultQueue(olead);    
        }
        //else assign to default lead queue.
        else{
            assignDefaultQueue(olead);  
        }
    } //Rep Type not present on Lead.
      //if channel present assign to default channel queue.
    if(olead.Rep_Type__c == null){
        if(olead.Business_Org__c != null){                       
            assignDefaultQueue(olead);    
        }
        //else assign to default lead queue.
        else{
            assignDefaultQueue(olead);  
        }       
                        
    }        
 
   // RepEmployeeNumber present in the salesRepAssignment object.Assign Lead to appropriate Sales Rep.
   
   
   //Billing zip and Rep type present in the lead
   if(olead.Billing_Zip__c != null && olead.Rep_Type__c != null) {
       system.debug('Billing_Zip__c+Rep_Type__c :'+ olead.Billing_Zip__c+olead.Rep_Type__c);
       system.debug('mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c) :'+ mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c));
       // valid RepEmployeeNumber present in the salesRepAssignment object.Assign Lead to appropriate Sales Rep.
       if(mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c) != null && mapUser.containsKey(mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c))) {
           olead.OwnerId = mapUser.get(mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c));
           system.debug('mapUser.get(mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c)):'+mapUser.get(mapLead.get(olead.Billing_Zip__c+olead.Rep_Type__c)));
           system.debug('ownerid : '+ olead.OwnerId); 
       }
       //RepEmployeeNumber not present in the salesRepAssignment object.                                    
       else {
           if(olead.Business_Org__c != null){                      
               assignDefaultQueue(olead);    
           }
        //else assign to default lead queue.
           else{
               assignDefaultQueue(olead);  
           }
        } 
         
      
    }
                                                             
   //Billing zip and Rep type not present in the lead                                    
   else{
        //if channel present assign to default channel queue.
        if(olead.Business_Org__c != null){                      
            assignDefaultQueue(olead);    
        }
        //else assign to default lead queue.
        else{
            assignDefaultQueue(olead);  
        }
             
   }
   
  }
 
 public void assignDefaultQueue(Lead defaultQueue){
    if(listQueueAssignment != null && listQueueAssignment.size()>0){
        for(LLM_Queue_Assignment__c queueAssignment : listQueueAssignment){
            if(queueAssignment.Channel__c == defaultQueue.Business_Org__c){
                for(QueueSobject queueObj : listQueue){
                    if(queueObj.Queue.Name == queueAssignment.Queue__c){
                        defaultQueue.OwnerId=queueObj.QueueId;
                        break;
                    }
                                        
                }
                                                                            
            }
        }
    }
 } 


}