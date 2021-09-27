/**
* Test class : EntTrailTriggerHelper_Test
* JIRA Details: 
* @description : HandlerHelperClass
* CHANGE HISTORY
* =====================================================================================================================
* Date         Name                    Description
* JUN 2021     TCS DevTeam             Created as Part of DPS-20397,DPS-20399,DPS-20400
*                                       to update the "Has Active Trail" field on Account, Lead, Opportunity
*                                       when it has atleast one Trial with the Status - Rep Initiated or Accepted
*                                                                 
* =====================================================================================================================
*/
public without sharing class EntTrialTriggerHandlerHelper {

 /**
* @description processRecords
* @param parentTrlMap
* 
*/
     public static void processRecords(map<id, list<string>> parentTrlMap){
        list<Account> accounts = new list<account>();
         //list<contact> contacts = new list<contact>();
        list<Lead> leads = new list<Lead>();
        list<opportunity> opportunities = new list<opportunity>();
        
        
        for(id recId : parentTrlMap.keyset()){
            if(string.valueOf(recId.getSobjectType())=='Account'){    
                accounts = prepareAccountList(parentTrlMap,recId,accounts);            
                
            }
            /* else if(string.valueOf(recId.getSobjectType())=='Contact'){    
                contacts = prepareContactList(parentTrlMap,recId,contacts);            
                
            }*/
            
            else if(string.valueOf(recId.getSobjectType())=='Lead'){    
                leads = prepareLeadList(parentTrlMap,recId,leads);            
                
            }
            
           /* else if( string.valueOf(recId.getSobjectType())=='Lead'){               
                Lead ld  = EntTrialTriggerHelper.getLeadSobject(parentTrlMap.get(recId).size(),recId);
                if(ld != null){
                    Leads.add(ld);
                }
            }*/
          
            
            else if(string.valueOf(recId.getSobjectType())=='Opportunity'){
                opportunity opp = EntTrialTriggerHelper.getOpportunitySobject(parentTrlMap.get(recId).size(),recId);
                if(opp != null){
                    Opportunities.add(opp);
                }
            }
        }
        
        EntTrialTriggerHelper.updateAccounts( accounts);
        EntTrialTriggerHelper.updateLeads(leads);
        EntTrialTriggerHelper.updateOpportunities(Opportunities);
        //updateContacts(contacts);
    }
    
     private static list<Account>  prepareAccountList( map<id, list<string>> parentTrlMap, id recId,list<account> accList){
        list<Account> accounts = new List<account>();
        if(accList.size()> 0 ){
            accounts.addAll(accList); 
        }
        Account acc = EntTrialTriggerHelper.getAccountSobject(parentTrlMap.get(recId).size(),recId);
        if(acc != null){
            accounts.add(acc);
        }
        return accounts;
    }
    
     /*private static list<contact>  prepareContactList( map<id, list<string>> parentTrlMap, id recId,list<contact> conList){
        list<contact> contacts = new List<contact>();
        if(conList.size()> 0 ){
            contacts.addAll(conList); 
        }
        Contact con = EntTrialTriggerHelper.getContactSobject(parentTrlMap.get(recId).size(),recId);
        if(con != null){
            contacts.add(con);
        }
        return contacts;
    }*/
    
    private static list<Lead>  prepareLeadList( map<id, list<string>> parentTrlMap, id recId,list<Lead> leadList){
        list<Lead> leads = new List<Lead>();
        if(leadList.size()> 0 ){
            leads.addAll(leadList); 
        }
        Lead ld = EntTrialTriggerHelper.getLeadSobject(parentTrlMap.get(recId).size(),recId);
        if(ld != null){
            leads.add(ld);
        }
        return leads;
    }
    
        
   /* private static void updateContacts(list<contact> contacts){
        if(contact.SobjectType.getDescribe().isUpdateable() && 
           contacts.size()>0){
               update contacts;
           }
    }*/
    
}