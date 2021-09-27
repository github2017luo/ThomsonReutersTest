/**
 * Controller class for LCRMCloneTrainingEvent VF page
 *
 * @author  Saloni Sukhija
 * @version  2017-06-05
 *
 */
 
public without sharing class LCRMCloneTrainingEventController{

    public ApexPages.StandardController oController;
    public Training_Event__c oTrainingEvent;
    public Id trainingEventId;
    

    public LCRMCloneTrainingEventController(ApexPages.StandardController standardController){
        oController = standardController;
        oTrainingEvent = (Training_Event__c)standardController.getRecord();
        trainingEventId = Id.valueof(ApexPages.currentPage().getParameters().get(String.escapeSingleQuotes('teId')));
        
    }
    
    public PageReference onPageLoad(){
        PageReference oPage;
        
        String query = getQuery('Training_Event__c');
        query += ' WHERE Id = :trainingEventId';
        Training_Event__c te = Database.query(query); 
        
        if(te != null){
            Training_Event__c new_te = new Training_Event__c();
            
            new_te.Training_Name__c = te.Training_Name__c;
            new_te.Account__c = te.Account__c;
            new_te.LCRM_Primary_Contact__c = te.LCRM_Primary_Contact__c;
            new_te.LCRM_Address_1__c = te.LCRM_Address_1__c;
            new_te.LCRM_Address_2__c = te.LCRM_Address_2__c;
            new_te.LCRM_City__c = te.LCRM_City__c;
            new_te.LCRM_Postcode_Zip__c = te.LCRM_Postcode_Zip__c;
            new_te.LCRM_State__c = te.LCRM_State__c;
            new_te.LCRM_Country__c = te.LCRM_Country__c;
            new_te.Training_Type__c = te.Training_Type__c;
            new_te.OwnerId = UserInfo.getUserId();
            
            if(te.Status__c == 'Cancelled' || te.Status__c == 'Completed' || te.Status__c == 'Completed-Duplicate')
               new_te.Status__c = 'Pending';
            else
               new_te.Status__c = te.Status__c;
                    
             //Is GLI and Sub-Bu fields
             new_te.LCRM_Is_GLI__c = te.LCRM_Is_GLI__c;
             new_te.LCRM_Sub_Bu__c = te.LCRM_Sub_Bu__c;
             
             Savepoint sp = Database.setSavepoint();
         
             try{
                insert new_te;
         
             if(new_te.id != null){
                //creating training event products
                query = getQuery('Training_Event_Product__c');
                query += ' WHERE LCRM_Training_Event__c = :trainingEventId';
                List<Training_Event_Product__c> products = Database.query(query);
                
                if(products != null && products.size() > 0){
                    List<Training_Event_Product__c> tepToInsert = new List<Training_Event_Product__c>();
                    Training_Event_Product__c tep;
                    for(Training_Event_Product__c prod : products){
                        tep = prod.clone(false,true,false,false);
                        tep.LCRM_Training_Event__c = new_te.id;
                        tepToInsert.add(tep);
                    }
                    insert tepToInsert;
                }
                
                oPage = new PageReference('/'+new_te.id);
             }
           }
           catch(Exception e){
               Database.rollback(sp);
              ApexPages.addMessages(e);
              return null;
           }
        }
        return oPage;
    }
    
    public String getQuery(String sobjectname){
    
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().fields.getMap();
        List<String> objFields = new List<String>(objectFields.keySet());
        String sQueryString = 'SELECT ';
        for(integer i=0 ; i<objFields.size() ; i++){
            if(i != objFields.size()-1)
                 sQueryString += objFields[i]+ ',';
             else 
                 sQueryString += objFields[i];
        }
        sQueryString += ' FROM ' + sobjectname;
        return sQueryString; 
    }

}