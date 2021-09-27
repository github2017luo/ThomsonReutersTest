/**
* Controller class for LCRM Add Delegates VF page
*
* @author  Saloni Sukhija
* @version 2017-06-3
*/
/**
 * @description LCRMAddDelegatesHelper created for PMD fix
 */
public without sharing class LCRMAddDelegatesHelper
{
    //public Boolean showList{get; set;}  
    //public List<SelectOption> listOperatorFields = new List<SelectOption>();

    /**
    * @description getlistContactFieldsFinal
    * @param listContactFields
    * @return listFieldOptionsFinal
    */
    public static list<SelectOption> getlistContactFieldsFinal(List<String> listContactFields){
        List<SelectOption> listFieldOptions = new List<SelectOption>();
        listFieldOptions.add(new SelectOption('--None--','--None--'));
        for(Integer i=0;i<listContactFields.size();i++)
        {   
            listFieldOptions.add(new SelectOption(listContactFields[i],listContactFields[i]));
        }
        
        system.debug(LoggingLevel.DEBUG,'@@@listFieldOptions'+listFieldOptions);
        Set<SelectOption> setFieldOptions = new Set<SelectOption>(listFieldOptions);
        List<SelectOption> listFieldOptionsFinal = new List<SelectOption>(setFieldOptions );
        
     return listFieldOptionsFinal;
    }
    
    /**
    * @description getlistOperatorFields
    * @return listOperatorFields
    */
    /*public static list<SelectOption> getlistOperatorFields(){       
        List<SelectOption> listOperatorFields = new List<SelectOption>();   
        listOperatorFields = AppUtil2.populateOperators(Schema.DisplayType.STRING);
           return listOperatorFields;
    }*/
    
    /**
    * @description getlistContactIds
    * @param trainingEventId
    * @return listContactIds
    */
    public static List<Id> getlistContactIds(Id trainingEventId){
        //Map<Id, Contact> mapExistingContacts = new Map<Id, Contact>();
        List<Id> listContactIds = new List<Id>();
        List<Training_Event_Contact__c> teCons= new List<Training_Event_Contact__c>();
        if(Schema.sObjectType.Training_Event_Contact__c.isQueryable()){
         teCons = [SELECT Id, Contact_Name__c FROM Training_Event_Contact__c where Training_Event__c = :trainingEventId];}
        if(teCons!=null && teCons.size()>0){
        for(Training_Event_Contact__c trainingEventContact : teCons)
            {
                listContactIds.add(trainingEventContact.Contact_Name__c);
            }
        }
        
       return listContactIds;    
    }
  
}