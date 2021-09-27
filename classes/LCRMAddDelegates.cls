/**
* Controller class for LCRM Add Delegates VF page
*
* @author  Saloni Sukhija
* @version 2017-06-3
*/
/**
 * @description LCRMAddDelegates
 */
public without sharing class LCRMAddDelegates{
    
    public ApexPages.StandardController oStandardController;
    public List<id> listContactIds;
    public Id trainingEventId;
    public List<SelectOption> listOperatorFields = new List<SelectOption>();
    public List<String> listContactFields = new List<String>();
    public Map<String,string> mapContactFields = new Map<string,string>();
    public Map<String,string> mapNameKey = new Map<string,string>();
    public Map<String,Schema.DisplayType> mapContactFieldsAndTypes = new Map<String,Schema.DisplayType>();
    public Training_Event__c oTrainingEvent;
    
    /** 
     * @description oPagingContacts
    */
    public PagingContacts oPagingContacts {get;set;}

    /** 
     * @description mapExistingContacts
    */
    public Map<Id, Contact> mapExistingContacts {get;set;}
    
    /**
    * @description listMatchingContacts
    */
    public List<cContact> listMatchingContacts{get;set;}
    /**
    * @description listSelectedfilter
    */
    public List <Searchfilters> listSelectedfilter{get;set;}
    
    /**
    * @description sSearchKey
    */
    public string sSearchKey{get;set;}
    /**
    * @description sortField
    */
    public String sortField{
        get  { if (sortField == null) {sortField = 'LastName'; } return sortField;  }
        set;
    }
    /**
    * @description sortDir
    */
    public String sortDir{
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    } 
    
    /**
    * @description showList
    */
    public Boolean showList{get; set;}  
    
    //wrapper class to display contact with checkbox
    /**
    * @description cContact
    */
    public class CContact{
        /**
        * @description cContact
        */
        public Contact cCon{get;set;}
        /**
        * @description bSelected
        */
        public Boolean bSelected{get;set;}
        /**
        * @description cContact
        * @param con
        * @param checked
        */
        public cContact(Contact con, Boolean checked){
            cCon =con;
            bSelected = checked;                   
        }       
    }
    
    //wrapper class for all search filters to impliment 'add filters'
    /**
        * @description Searchfilters
        */
     public class Searchfilters{
        /**
        * @description sSelectedField
        */
        public String sSelectedField {get;set;}
        /**
        * @description sSelectedOperator
        */
        public String sSelectedOperator {get;set;}
        /**
        * @description sSelectedValue
        */
        public String sSelectedValue {get;set;}
        /**
        * @description Searchfilters
        * @param sField
        * @param sOperator
        * @param sValue
        */
        public Searchfilters(String sField,String sOperator,String sValue){
            this.sSelectedField = sField;
            this.sSelectedOperator = sOperator;
            this.sSelectedValue = sValue;
        }       
    } 
    
    //extended pageable class to use pagination on page
    /**
        * @description PagingContacts
        */
     public class PagingContacts extends Pageable {
        /**
        * @description listofContacts
        */
        public List<cContact> listofContacts {get;set;}   
        /**
        * @description PagingContacts
        */    
        public PagingContacts(){ 
            system.debug(LoggingLevel.DEBUG,'Inside PagingContacts');  
        }
        
        public override integer getRecordCount() {
            return (listofContacts == null ? 0 : listofContacts.size());
        }
        public override void moveNext(){
            super.moveNext();           
        }        
        public override void movePrev(){
           super.movePrev();           
        }
    }        
    
    /**
        * @description LCRMAddDelegates
        * @param oController
        */
    public LCRMAddDelegates(ApexPages.StandardController oController){
        oStandardController = oController;
        oTrainingEvent = (Training_Event__c) oController.getRecord();
        
        oPagingContacts = new PagingContacts();
        oPagingContacts.Pagesize = 25;
        oPagingContacts.listofContacts = new List<cContact>();   
        
        mapContactFields = AppUtil2.getFieldNameList('Contact', mapContactFields, mapNameKey, mapContactFieldsAndTypes);
        // Added city value as part of Story CRM-10861
        for(String sField : mapNameKey.Values()){
            if(sField == 'Last Name' || sField == 'Account Name' || sField == 'First Name' || sField == 'City' || sField == 'Email'){
                listContactFields.add(sField);
               
            }
        }
        
         listSelectedfilter  = new List<Searchfilters>{new Searchfilters('--None--','--None--','')};
         
         trainingEventId = System.currentPageReference().getParameters().get('teId');
    }
    
    /**
        * @description LCRMAddDelegates
        * @return list<SelectOption>
        */
    public list<SelectOption> getlistContactFields(){
        //List<SelectOption> listFieldOptions = new List<SelectOption>();
        /*listFieldOptions.add(new SelectOption('--None--','--None--'));
        for(Integer i=0;i<listContactFields.size();i++)
        {   
            listFieldOptions.add(new SelectOption(listContactFields[i],listContactFields[i]));
        }*/
        /*List<SelectOption> listFieldOptions = LCRMAddDelegatesHelper.getlistContactFieldsFinal(listContactFields);
        system.debug(LoggingLevel.DEBUG,'@@@listFieldOptions'+listFieldOptions);
        Set<SelectOption> setFieldOptions = new Set<SelectOption>(listFieldOptions);
        List<SelectOption> listFieldOptionsFinal = new List<SelectOption>(setFieldOptions );*/
        List<SelectOption> listFieldOptionsFinal = LCRMAddDelegatesHelper.getlistContactFieldsFinal(listContactFields);
        
     return listFieldOptionsFinal;
    }
    /**
     * @description  getlistOperatorFields
     * @return list<SelectOption>
     */
    public list<SelectOption> getlistOperatorFields(){       
           listOperatorFields = AppUtil2.populateOperators(Schema.DisplayType.STRING);
           return listOperatorFields;
    }

     /**
     * @description  getExistingContacts
     */  
    public void getExistingContacts(){
        mapExistingContacts = new Map<Id, Contact>();
        listContactIds = new List<Id>();
        List<Training_Event_Contact__c> teCons= new List<Training_Event_Contact__c>();
        /*if(Schema.sObjectType.Training_Event_Contact__c.isQueryable()){
         teCons = [SELECT Id, Contact_Name__c FROM Training_Event_Contact__c where Training_Event__c = :trainingEventId];}
        if(teCons!=null && teCons.size()>0){
        for(Training_Event_Contact__c trainingEventContact : teCons)
            {
                listContactIds.add(trainingEventContact.Contact_Name__c);
            }
        }*/
        
       listContactIds = LCRMAddDelegatesHelper.getlistContactIds(trainingEventId); 
       if(!listContactIds.isEmpty()){
            mapExistingContacts = new Map<Id, Contact>([SELECT Id, Name, FirstName, LastName, Account.Name, Email, Phone, Job_Function__c, LCRM_City__c FROM Contact where Id in :listContactIds]);
        }       
    }
    
    /**
     * @description  convertType
     * @param templistMatchingContacts
     * @return List<cContact>
     */
    public List<cContact> convertType(Contact[] templistMatchingContacts){
        List<cContact> listTempWrapperObj = new List<cContact>();
        if(!templistMatchingContacts.isEmpty()){
            for(Contact ctempContact : templistMatchingContacts){
                    cContact cc = new cContact(ctempContact, false);
                    listTempWrapperObj.add(cc);
            } 
            if(!listTempWrapperObj.isEmpty())
                {showList = true;}
            else
                {showList = false;    }
        } 
        
        return listTempWrapperObj;       
    }  
    
    /**
     * @description  findContacts
     * @return null
     */
    public pagereference findContacts(){
        listMatchingContacts = new List<cContact>();
         
        getExistingContacts();
        
        String sQueryString = 'SELECT Id, Name, FirstName, LastName, Account.Name,Email,Phone,Job_Function__c,LCRM_City__c FROM Contact WHERE CreatedDate <> null AND LCRM_Is_GLI__c=TRUE'; 
        //String sQueryString = LCRMAddDelegatesHelper.sQueryStringCreation();
        //String sQueryString = sQueryStringCreation();
        
             
        if(!listSelectedfilter.IsEmpty()){ 
            //Integer i = 0;
            /*for(Searchfilters oSearchfilters : listSelectedfilter){ 
                if(oSearchfilters.sSelectedField!='--None--' && oSearchfilters.sSelectedValue!=null && oSearchfilters.sSelectedValue!=''){
                    sQueryString +=AppUtil2.queryForText(mapContactFields.get(oSearchfilters.sSelectedField),oSearchfilters.sSelectedOperator,oSearchfilters.sSelectedValue);
                }                
            }*/
            sQueryString = listSelectedfilter(sQueryString,listSelectedfilter);
        }              
         
        if(sSearchKey != null && sSearchKey !=''){
            sQueryString +=' and Name Like';             
            sQueryString +='\'%'+String.escapeSingleQuotes(sSearchKey)+'%\'';  
        }
         
         System.debug(LoggingLevel.DEBUG,'-- Existing contacts:'+mapExistingContacts);
         if(!mapExistingContacts.isEmpty()){
             /*sQueryString += ' and Id not In (';
             for(integer i=0 ; i<listContactIds.size() ; i++){
                 if(i != listContactIds.size()-1)
                     {sQueryString += ' \''+listContactIds[i]+ '\', ';}
                 else 
                     {sQueryString += ' \''+listContactIds[i]+ '\' ';}
             }
             sQueryString += ')'; */
             //sQueryString = LCRMAddDelegatesHelper.sQueryStringMethod(sQueryString,listContactIds);
             sQueryString = sQueryStringMethod(sQueryString,listContactIds);
         }
               
         sQueryString +=' order by ' + String.escapeSingleQuotes(sortField) + ' ' + String.escapeSingleQuotes(sortDir);
         sQueryString += ' limit 1000';
         
         system.debug(LoggingLevel.DEBUG,'*****: '+sQueryString );
         
         try{
            Contact[] templistMatchingContacts = Database.query(String.valueof(sQueryString));            
            listMatchingContacts = convertType(templistMatchingContacts);          
         }
         catch(Exception e){
             ApexPages.addMessages(e);
             return null;
         }
         
         oPagingContacts.listofContacts = listMatchingContacts ;
         oPagingContacts.PageNumber = 1;
         return null;
    }
    
    /** 
     * @description addFilter
     * @return null
    */
     public pagereference  addFilter(){
       
       listSelectedfilter.add(new Searchfilters('--None--','--None--',''));
       return null;
     }
     
     /** 
     * @description toggleSort
    */
     public void toggleSort(){
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        findContacts();
    }    
    
     /** 
     * @description addToTraining
     * @return null
    */
     public PageReference addToTraining(){
        List<Contact> listSelectedContacts = new List<Contact>();
        List<Training_Event_Contact__c> listTrainingEventContacts = new List<Training_Event_Contact__c>();            
        Training_Event_Contact__c trainingEventContact;
        
        if (listMatchingContacts != null){
            for(cContact con : listMatchingContacts ){
                if(con.bSelected == true){
                    listSelectedContacts.add(con.cCon);                    
                }
            }
            
            if(listSelectedContacts.size()>0){
                for(Contact c : listSelectedContacts){
                    trainingEventContact = new Training_Event_Contact__c();
                    trainingEventContact.Contact_Name__c = c.Id;
                    trainingEventContact.Training_Event__c = trainingEventId; 
                    listTrainingEventContacts.add(trainingEventContact);                     
                }
            }
            Database.insert(listTrainingEventContacts,false);
            
           //PageReference pg = new Pagereference('/apex/TrainingEventDetail?id='+trainingEventId 
           PageReference pg = new PageReference(System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.escapeSingleQuotes(trainingEventId));          
           pg.setRedirect(true);
           return pg;
        }
            return null;
    } 
    
    /**
     * @description listSelectedfilter
     * @param sQueryString
     * @param listSelectedfilter
     * @return sQueryString
     */
    public String listSelectedfilter(String sQueryString,List<Searchfilters> listSelectedfilter){
        for(Searchfilters oSearchfilters : listSelectedfilter){ 
                if(oSearchfilters.sSelectedField!='--None--' && oSearchfilters.sSelectedValue!=null && oSearchfilters.sSelectedValue!=''){
                    sQueryString +=AppUtil2.queryForText(mapContactFields.get(oSearchfilters.sSelectedField),oSearchfilters.sSelectedOperator,oSearchfilters.sSelectedValue);
                }                
            }
        
        return sQueryString;
        
    }
    
    /**
     * @description sQueryStringMethod
     * @param sQueryString
     * @param listContactIds
     * @return sQueryString
     */
    public String sQueryStringMethod(String sQueryString, List<id> listContactIds){
             sQueryString += ' and Id not In (';
             for(integer i=0 ; i<listContactIds.size() ; i++){
                 if(i != listContactIds.size()-1)
                     {sQueryString += ' \''+listContactIds[i]+ '\', ';}
                 else 
                     {sQueryString += ' \''+listContactIds[i]+ '\' ';}
             }
             sQueryString += ')'; 
        
        return sQueryString;
    }
    
    /**
     * @description sQueryStringCreation
     * @return sQueryString
     */
    /*public String sQueryStringCreation(){
        
        String sQueryString = 'SELECT Id, Name, FirstName, LastName, Account.Name,Email,Phone,Job_Function__c,LCRM_City__c FROM Contact WHERE CreatedDate <> null AND LCRM_Is_GLI__c=TRUE'; 
        return sQueryString;
    }*/ 
}