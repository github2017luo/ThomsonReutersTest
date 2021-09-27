/**
     * @description ESC_contactSearchLWCController class
     */
    public with sharing class ESC_contactSearchLWCController {
        static String filterSecondary = 'where id!=null';
        static boolean execQuery = false;
        static List<String> lstcon= new List<String>();
         @Testvisible static List<Contact> lstssd = new List<Contact>();
        static List<DataTableWrapper> response = new List<DataTableWrapper>();
        static string query = '';
        static string mergedIDs='';
        static string firstName='';
        static string lastName='';
         static string email='';
        static string phone='';
        /**
         * @description ESC_contactSearchLWCControllerV2
        * @param name
        * @param emphone
        * @param sapNumber
        * @return retriveRecs
     */
        
        @AuraEnabled(Cacheable = true)
        public static List<DataTableWrapper> retriveRecs(String name,String emphone,String sapNumber) {
           // response = new List<DataTableWrapper>();
           // lstssd = new List<Contact>();
            //string fieldsToBeReturned= 'Id,Name,AccountId,Account.Name,Email,Account.BillingCity,Account.BillingState,Account.Total_Active_Subscriptions__c';
            //string objName = 'Contact';
            //string limitClause=' Limit '+label.ESC_MaxRecords;
            //system.debug('^^^^1'+name);
            //system.debug('^^^^2'+emphone);
            getsplitname(name); 
            getsplitemphone(emphone);
             //system.debug('^^^^3'+firstName+lastName+email+phone+sapNumber);
                if(sapNumber!=''){
                getSSDRecs(sapNumber);
                if(lstcon.size() ==0){
                    lstcon.add('\'xxxxxxxxxxxxxxxxxx\'');
                }
                mergedIDs = string.join(lstcon, ',');
                
            }
            
            /*if(firstName!=''){
                getFilterSecondary('firstname',firstName);
            }
            if(lastName!=''){
                getFilterSecondary('lastname',lastName);
            }*/
            if(email!=''){
                getFilterSecondary('email',email);
            }

            if(phone!=''){
                getFilterSecondary2(phone);
            }
            if(sapNumber!=''){
                //mergedIDs = String.escapeSingleQuotes(mergedIDs);
                filterSecondary += ' and id in ('+mergedIDs +')';
                execQuery =true;
            }
            system.debug(LoggingLevel.WARN, 'query***'+filterSecondary);
            if(execQuery){
                //query = 'select ' +fieldsToBeReturned +' from '+objName + ' '+ filterSecondary+' '+ limitClause;
                query = 'select Id,Name,AccountId,Account.Name,Email,Account.BillingCity,Account.BillingState,Account.Total_Active_Subscriptions__c from Contact '+ filterSecondary+ ' Limit '+string.escapeSingleQuotes(label.ESC_MaxRecords);
            }
            
            List<DataTableWrapper> data =  ESC_contactSearchLWCController.getResponse();
            system.debug(LoggingLevel.WARN, + data);

            return data;
        }
    /**
         * @description getsplitname
         * @param name
        */
        static void getsplitname(string name)   {    
            List<String> list1 = new List<String>();
                for(String s : name.split(',')){
                    list1.add(s);
                }
                if(list1.size()>0 && list1.size()==1){
                    firstName=list1[0];
                  
                }
                if(list1.size()>0 && list1.size()==2){
                    firstName=list1[0];
                    lastName=list1[1];
                }
                
                if(firstName!=''){
                    getFilterSecondary('firstname',firstName);
                }
                if(lastName!=''){
                    getFilterSecondary('lastname',lastName);
                }
            
            }
            
            
            /**
         * @description getsplitemphone
         * @param emphone
        */
        static void getsplitemphone(string emphone)   {    
            List<String> list1 = new List<String>();
                for(String s : emphone.split(',')){
                    list1.add(s);
                }
                if(list1.size()>0 && list1.size()==1){
                    email=list1[0];
                  
                }
                if(list1.size()>0 && list1.size()==2){
                    email=list1[0];
                    phone=list1[1];
                }
            }
            
        /**
         * @description getResponse
         * @return response
        */
        static List<DataTableWrapper> getResponse(){
           
            lstssd = Database.query(query);
            if(lstssd.size()>0){
                system.debug(LoggingLevel.WARN, 'result'+lstssd[0]+lstssd[0].Account.Total_Active_Subscriptions__c);
                getResults();
                if(response.size()>0){
                    //system.debug('response**'+response);
                    return response;
                }
            }

            return null;
        }


        /**
         * @description getFilterSecondary
        * @param param
        * @param val
        */
        Static void getFilterSecondary(String param,String val){
                filterSecondary += ' and '+param+' LIKE \''+ val + '%\'';
                execQuery =true;
                
            }
        /**
         * @description getFilterSecondary2
        * @param phone
        */
         @Testvisible Static void getFilterSecondary2(String phone){
                filterSecondary += ' and (USL_IVR_Phone_Number__c '+ ' LIKE \''+ phone + '%\'' ;
                filterSecondary += ' OR Standardized_MobilePhone__c '+ ' LIKE \''+ phone + '%\'' ;
                filterSecondary += ' OR Standardized_Phone__c '+ ' LIKE \''+ phone + '%\'' ;
                filterSecondary += ' OR Standardized_OtherPhone__c '+ ' LIKE \''+ phone + '%\')' ;
                
                execQuery =true;
                
                
            }
            /**
         * @description getSSDRecs
        * @param sapNumber
        */
        Static void getSSDRecs(String sapNumber){
                List<Source_System_Detail__c> lstssds = new List<Source_System_Detail__c>();
                //List<Account> lstacc= new List<Account>();
                List<Contact> lstcons= new List<Contact>();
                Set<Id> setAccs = new Set<Id>();
                if(
                    Schema.sObjectType.Source_System_Detail__c.isAccessible() && Schema.sObjectType.Source_System_Detail__c.isQueryable()
                ){
                lstssds = [select id,Source_System_Account_Number__c,Account_Name__c from Source_System_Detail__c where Source_System_Account_Number__c=:sapNumber];
                }
                
                for(Source_System_Detail__c ssd:lstssds){
                    setAccs.add(ssd.Account_Name__c);
                }
                
                
                if(setAccs.size()>0){
                    if(
    
                        Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable()
                       
                    ){
                    //lstacc = [select Id,Name,BillingCity,BillingState,Total_Active_Subscriptions__c,(select id,name,email from contacts) from account where id IN :setAccs];
                    lstcons=[select Id,Name from Contact where AccountId IN :setAccs];
                }
                }
                
                //for(Account acc:lstacc){
                    //if(acc.contacts.size()>0){
                        for(Contact con:lstcons){
                            string queuID  ='\''+ con.id+'\'';
                            lstcon.add(queuID);
                        }
                    //}
                //}
                
            }
             /**
         * @description getResults        
        */
         @Testvisible Static void getResults(){
                for(Contact rec:lstssd){
                    
                    DataTableWrapper obj = new DataTableWrapper();
                    obj.Id = rec.id;
                    obj.name = rec.Name;
                    obj.nameUrl = '/'+rec.id;
                    obj.email = rec.Email;
                    obj.accname = rec.Account.Name;
                    obj.accnameUrl = '/'+rec.AccountId;
                    obj.city = rec.Account.BillingCity;
                    obj.state = rec.Account.BillingState;
                    obj.totalactivesubscriptions = String.valueof(rec.Account.Total_Active_Subscriptions__c);
                    response.add(obj);
                    
                }
            }
         /**
         * @description DataTableWrapper
         */
        @Testvisible private class DataTableWrapper {
             /**
         * @description id  
         * @return id 
         */
            @AuraEnabled
            public Id id {get;set;}
              /**
         * @description name 
         * @return name 
         */
            @AuraEnabled
            public String name {get;set;}
            
               /**
         * @description nameUrl 
         * @return nameUrl 
         */
            @AuraEnabled
            public String nameUrl {get;set;}
            
             /**
         * @description email 
         * @return email 
         */
            @AuraEnabled
            public String email {get;set;}
            
                /**
         * @description accname 
         * @return accname 
         */
            @AuraEnabled
            public String accname {get;set;}
            
                /**
         * @description accnameUrl 
         * @return accnameUrl 
         */
            @AuraEnabled
            public String accnameUrl {get;set;}
            
             /**
         * @description city 
         * @return city 
         */
            @AuraEnabled
            public String city {get;set;}
            
        /**
         * @description state
         * @return state
         */
            @AuraEnabled
            public String state {get;set;}
            
            /**
         * @description totalactivesubscriptions
         * @return totalactivesubscriptions
         */
            @AuraEnabled
            public String totalactivesubscriptions {get;set;}
            
        }
    }