/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 
 * 2012-08-31   Anshita Sharma      created                                   
 * =============================================================================
 */ 


public class TrainingEventContactUpdate{
    public  List<Training_Event__c> tTrainingEvent = new List<Training_Event__c>();
    public Training_Event__c tTevent{get;set;}
    public  Boolean isUpdate{get;set;}
    public  String status{get;set;}
    public  Date tDate{get;set;}
        
    List<Training_Event_Contact__c> tLstUpdate = new List<Training_Event_Contact__c>();
       
    public TrainingEventContactUpdate(ApexPages.StandardController stdController){
        tTevent=(Training_Event__c)stdController.getRecord();
        tTrainingEvent=[select id, Status__c, Training_Date__c from Training_Event__c where Id =:tTevent.id];
        status =tTrainingEvent[0].Status__c;
        tDate=tTrainingEvent[0].Training_Date__c;
        if(status == 'Completed-Duplicate' || status =='Completed')
            isUpdate = true;
        else
            isUpdate = false;   
    }
   

    public PageReference saveCon(){
        if(status == 'Completed' || status =='Completed-Duplicate'){
            for(List<Training_Event_Contact__c> tContact:[select id, User_trained_Date__c,  Trained__c, Training_Event__c from Training_Event_Contact__c where Training_Event__c=:tTevent.id]){
                for(Training_Event_Contact__c tcon:tContact){
                    tcon.User_trained_Date__c=tDate;
                    tcon.Trained__c = true;
                    tLstUpdate.add(tcon);
                }
            }
           if(!tLstUpdate.isEmpty())
                update(tLstUpdate);
            PageReference pg = new PageReference('/'+tTevent.id);
            pg.setRedirect(true);
            return pg;
        }
    return null;
    
    }
     
    
}