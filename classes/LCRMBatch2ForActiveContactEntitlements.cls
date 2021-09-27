/*
@Author: Navjyoti Mohanta
@JIRA Story: CRM-8058
@Purpose: This Batch class is for to find out whether the GLI Contacts hold any Active Entitlement Record or not.
@Version: 

* CHANGE HISTORY
* =============================================================================
* Date              Name                    Description
*                                  
* =============================================================================
*/
global class LCRMBatch2ForActiveContactEntitlements implements Database.Batchable<SObject> {
    
    
    global Database.QueryLocator start (Database.BatchableContext BC){
       
        Date yesterday = Date.TODAY().addDays(-1);
        Date presentday = Date.TODAY() ;      
        
        
         String query ='SELECT Id , LCRM_Contact__c, LCRM_Access_Start_Date__c, LCRM_Access_End_Date__c  ';
        query += 'from LCRM_Contact_Entitlement__c where LCRM_Contact__r.LCRM_Is_GLI__c = true ';
        query += ' AND ((LCRM_Access_Start_Date__c =: presentday ) ';        
        query +=' OR (LCRM_Access_End_Date__c =: yesterday))';
         
               
        system.debug('the final query is '+query);
        
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext BC, List<LCRM_Contact_Entitlement__c> scope){
        set<id> setOfContactIds= new set<Id>();
        list<contact> listOfContacts = new list<Contact>();
        set<contact> setOfContactsToBeUpdated = new set<Contact>();
        list<contact> listOfContactsToBeUpdated = new list<Contact>();
        try{
            if(scope != null){
                for(LCRM_Contact_Entitlement__c conent :scope){
                    setOfContactIds.add(conent.LCRM_Contact__c);
                }
                system.debug('contactIds Size'+setOfContactIds.size());

                listOfContacts = [Select Id ,LCRM_Active_Entitlement__c , Name ,  (Select Id, LCRM_Contact__c, LCRM_Access_Start_Date__c, 
                LCRM_Access_End_Date__c from Contact_Entitlements__r)  from Contact where Id IN : setOfContactIds];                
				/*
                for(LCRM_Contact_Entitlement__c ent :scope){
                    if(listOfContacts != null){
                        for(contact con: listOfContacts ){
                            if(ent.LCRM_Contact__c == con.Id){
                                if(ent.LCRM_Access_Start_Date__c == Date.TODAY()){
                                system.debug('inside start date is today'+ent);
                                    con.LCRM_Active_Entitlement__c = true ;
                                    //setOfContactsToBeUpdated.add(con);
                                }
                                else if(ent.LCRM_Access_End_Date__c == Date.TODAY().addDays(-1)){
                                    system.debug('inside if end date is yesterday'+ent);
                                    list<LCRM_Contact_Entitlement__c> listOfContactEntitlements = con.Contact_Entitlements__r;
                                    for(LCRM_Contact_Entitlement__c conEntitle :listOfContactEntitlements){
                                        
                                            system.debug('the other entitlement record'+conEntitle );
                                            if(Date.TODAY()<= conEntitle.LCRM_Access_End_Date__c && Date.TODAY()>= conEntitle.LCRM_Access_Start_Date__c){
                                            con.LCRM_Active_Entitlement__c = true ;                                         
                                            break;
                                            }else{
                                                con.LCRM_Active_Entitlement__c = false;                                         
                                            }                  
                                        
                                    }
                                    setOfContactsToBeUpdated.add(con);
                                }
                            }
                        }
                    }
                }
                */
                for(Contact con :listOfContacts ){             
                    list<LCRM_Contact_Entitlement__c> listOfContactEntitlements = con.Contact_Entitlements__r;
                    if(listOfContactEntitlements.size()>0){
                        system.debug('@@@listOfContactEntitlements'+listOfContactEntitlements.size()+'completelist'+listOfContactEntitlements);
                        for(LCRM_Contact_Entitlement__c conEntitle :listOfContactEntitlements){
                            if(conEntitle.LCRM_Access_Start_Date__c == Date.TODAY()){
                                //system.debug('inside start date is today'+ent);
                                con.LCRM_Active_Entitlement__c = true ;
                                setOfContactsToBeUpdated.add(con);
                                break;
                            }else if(Date.TODAY() <= conEntitle.LCRM_Access_End_Date__c && Date.TODAY() >= conEntitle.LCRM_Access_Start_Date__c){
                                con.LCRM_Active_Entitlement__c = true ;
                                setOfContactsToBeUpdated.add(con);
                                break;
                            }else{
                                con.LCRM_Active_Entitlement__c = false;
                            }                     
                        }
                        setOfContactsToBeUpdated.add(con);
                    }
                    //listOfUpdateContact.add(con);            
                }
            

                
                
                system.debug('@list of contact after update'+listOfContactsToBeUpdated);
                if(setOfContactsToBeUpdated.size()>0){
                listOfContactsToBeUpdated.addAll(setOfContactsToBeUpdated);
                 Database.SaveResult[] srList = Database.Update(listOfContactsToBeUpdated,false);
               }
            }
        }
        Catch(Exception e){
            system.debug(e);
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}