/**
 * TRStore_TransactMapAccount Description
 * @description
 */
public with sharing class TRStore_TransactMapAccount{
    /**
     * mapAccountDetails 
     * @description
     * @param  l
     * @return MAP<string,string>: Return description
     */
    public static MAP<string, string> mapAccountDetails(Lead l){
        MAP<string, string> conDetails = new MAP<string, string>();        
        system.debug(loggingLevel.INFO,'Starting existing Account Mapping.......'); 
        if(l.Email != null && l.Company != null){
            conDetails = getContactDetails(l.Email, l.Company );
        }
         system.debug(loggingLevel.INFO,'conDetails .......'+conDetails ); 
       return conDetails;
    
    }
    /**
     * getContactDetails 
     * @description
     * @param email
     * @param accName
     * @return MAP<string,string>: Return description
     */
    private static MAP<string, string> getContactDetails(string email, string accName){   
        /**
         * Query is update by servendra kumar
         * Changes1: added: AND Account.Name =: accName ORDER BY createdDate DESC LIMIT 1 in SOQL query
         * Changes2: updated code from line no 37 to 41 
         */
        MAP<id, contact> contacts = new MAP<id, contact>([Select id, AccountId, Account.Name from contact WHERE email =: email AND Account.Name =: accName ORDER BY createdDate DESC LIMIT 1]);
        MAP<string, string> details = new MAP<string, string>();   
        if((!contacts.isEmpty())  && (contacts.size() > 0 ) ){ 
            for(contact c: contacts.values()){
                details.put(c.id, c.AccountId);
            }
        }
        /*
         * code is commented by Servendra kumar, as this is unnecessary code
        if((!contacts.isEmpty())  && (contacts.size() >=2 ) ){        
            for(contact c: contacts.values()){
                if(c.Account.Name == accName){
                    details.put(c.id, c.AccountId);
                }    
            }
        }else if(contacts.size() == 1){
            contact c = new contact();
            c = contacts.values()[0];            
            details.put(c.id, c.AccountId );    
        } */       
        system.debug(loggingLevel.INFO,'details .......'+details);         
        return details;
    }
    /**
     * fetchLeadDetails 
     * @description
     * @param leads
     * @return id: Return description
     */
    public static id fetchLeadDetails(LIST<Lead> leads){    
        if(!leads.isEmpty()){
            return leads[0].id;
        }    
        return null;
    }
}