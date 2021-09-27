/**
     * @description CaseCommentHelper
     
     */
    public without sharing class CaseCommentHelper
    {
    
        static Map<Id, List<EntitySubscription> > caseFollowerListMap = new Map<Id, List<EntitySubscription> > ();
        static Map<Id, String> userEmailMap = new Map<Id, String>();
        static Map<id,String> caseOwnerIdMap= new Map<id,String>();
        static List<User> userList = new List<User>();
        static  Map <ID,List<String>> caseEmailMap = new Map<ID,List<String>>();
        static  List<EntitySubscription> caseFollower = new List<EntitySubscription>();
        static   Set<ID> casefolloweridSet = new Set<ID>();
        static   List<id> lstOfCase=new List<id>();
        
       /**
         * @description getValidCase
         * @param listOfCases
         * @return getValidCase
         */ 
        public static List<Case> getValidCase(Set<ID> listOfCases){
            List<Case> validCase= new list<Case>();
            List<Case> cases = new List<Case>();
            if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isQueryable()){
                cases = [SELECT Id,Sales_Org__c,Recordtype.DeveloperName,CaseNumber,Subject,Priority,Account.name,ownerId, Owner.name, Contact.name,Status,Product.name,Description,Product__c
                                FROM Case Where ID IN: listOfCases];        
            }
            
            for (Case ocase:Cases){
                System.debug(LoggingLevel.WARN,'Record type:'+ocase.Recordtype.DeveloperName +'salesorg'+ocase.Sales_Org__c);
                if ( (ocase.Sales_Org__c =='BKRS' || ocase.Sales_Org__c =='LRA') && ocase.Recordtype.DeveloperName =='ANZ' && ocase.Subject != 'Triggered' ){
                    validCase.add(oCase);
                }
            } 
            return validCase;
        }
        /**
         * @description getListofFollower
         * @param validCase
         * @return data
         */ 
        
       public static Map<ID,List<String>> getListofFollower(List<Case> validCase){ 
            
            
            for(Case oid:validCase)
            {
                lstOfCase.add(oid.Id);
                String ownid=oid.OwnerId;
                if((ownid.startsWithIgnoreCase('005'))){
                    casefolloweridSet.add(oid.OwnerId);
                    caseOwnerIdMap.put(oid.Id,oid.OwnerId);
                }
            }
            
             Map<ID,List<String>>  data = getListofFollower1(validCase);
             return data;
       }    
        /**
         * @description getListofFollower1
         * @param validCase
         * @return data
         */     
        
        public static Map<ID,List<String>> getListofFollower1(List<Case> validCase){
            
            if(!validCase.isEmpty() && Schema.sObjectType.EntitySubscription.isAccessible() && Schema.sObjectType.EntitySubscription.isQueryable()){
                caseFollower=[select parentid, SubscriberId from EntitySubscription where parentID IN :lstOfCase] ;
            }
            
            if(!caseFollower.isEmpty()){
                for(EntitySubscription es:caseFollower){
                    if(caseFollowerListMap.get(es.parentid) == null){
                        caseFollowerListMap.put(es.parentid, new List<EntitySubscription>{es});
                    }else{
                        caseFollowerListMap.get(es.parentid).add(es);  
                    }
                    casefolloweridSet.add(es.SubscriberId);
                }
            } 
            Map<ID,List<String>>  data = getListofFollower2();
             return data;
            
        }
        /**
         * @description getListofFollower2
         * @return getCaseEmails
         */     
        
            public static Map<ID,List<String>> getListofFollower2(){
            
            if(!casefolloweridSet.isEmpty() && Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable()){
                userList= [select id,email from User where ID IN:casefolloweridSet and IsActive = true ];
            }
            
                   return getCaseEmails(userEmailMap,userList);   
        }
        
        /**
         * @description getCaseEmails
         * @param userEmailMap
         * @param userList
         * @return getCaseEmails
         */ 
    
        public static Map<ID,List<String>> getCaseEmails(Map<Id, String> userEmailMap,List<User> userList){
            if(!userList.isEmpty()){
                for(User ouser:userList){
                    //Comneted as part of single email limt
                    //userEmailMap.put(ouser.Id, ouser.email);  
                   userEmailMap.put(ouser.Id, ouser.Id);                                         
                }
            }
            Map<ID,List<String>> data = getCaseEmails2();
            return data;
        } 

             /**
         * @description getCaseEmails
         * @return caseEmailMap
         */ 

        public static Map<ID,List<String>> getCaseEmails2(){

            if(!caseFollowerListMap.isEmpty()){
                for (Id caseRecordId : caseFollowerListMap.keySet()){
                    List<String> listofEmails= new List<String>();
                    for (EntitySubscription esRecord : caseFollowerListMap.get(caseRecordId)){
                        if(!userEmailMap.isEmpty() && userEmailMap.get(esRecord.SubscriberId) != null){
                            listofEmails.add(userEmailMap.get(esRecord.SubscriberId));
                        }
                    }
                    caseEmailMap.put(caseRecordId,listofEmails);
                }
            }

            Map<ID,List<String>> data = getCaseEmails3();
            return data;
        }

          /**
         * @description getCaseEmails
         * @return caseEmailMap
         */ 
        public static Map<ID,List<String>> getCaseEmails3(){
            for(ID caseRecId:caseOwnerIdMap.keyset()){
                //String ownerEmail= userEmailMap.get(caseOwnerIdMap.get(caseRecId));
                String ownerEmail=caseOwnerIdMap.get(caseRecId);
                if(caseEmailMap.get(caseRecId) == null){
                    caseEmailMap.put(caseRecId, new List<String>{ownerEmail});
                }else{
                    caseEmailMap.get(caseRecId).add(ownerEmail);  
                }               
            }
            
            system.debug(LoggingLevel.WARN,'Final List'+caseEmailMap);
            return caseEmailMap;
        }
            
        
        /**
         * @description sendEmailMessage
         * @param listOfCases
         * @param caseFollower
         * @param subjectMap
         */     
        
        public static void sendEmailMessage(List<Case> listOfCases,Map<ID,List<String>> caseFollower, Map<ID,String> subjectMap){
            CaseCommentHelperExtended.sendEmail(listOfCases, caseFollower, subjectMap);

        }
            
    
    }