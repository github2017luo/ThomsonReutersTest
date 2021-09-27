/**
* Controller class for TrainingEventReminder visualforce component. This is used to show the products and learning objectives which will be covered in the training event.
*
* @author  Saloni Sukhija
* @version 2017-07-11
*/

public class TrainingEventReminderController{

    public Id trainingEventId{get;set;}
    public List<TrainingProducts> prods;
    public List<LearningObjectives> learningObjs;
    
    
    public class TrainingProducts{
        public String sNo{get;set;}
        public Training_Event_Product__c product{get;set;} 
    }
    
    public class LearningObjectives{
        public String sNo{get;set;}
        public String lObj{get;set;} 
        public String nextLine{get;set;}
    }
    
     
        
    public List<TrainingProducts> getProducts(){
        prods = new List<TrainingProducts>();
        
        List<Training_Event_Product__c> teProds = [SELECT LCRM_Product__r.Name FROM Training_Event_Product__c WHERE LCRM_Training_Event__c = :trainingEventId];
        
        if(teProds!=null && teProds.size()>0){
            TrainingProducts prod;
            for(integer i=0 ; i<teProds.size() ; i++){
                prod = new TrainingProducts();
                prod.sNo = i+1+'. ';
                prod.product = teProds.get(i);
                
                prods.add(prod);
            }
            
        }
         
        return prods;
    }
    
    public List<LearningObjectives> getLearningObjectives(){
        Map<String, Schema.SObjectField> teFieldsMap = Schema.getGlobalDescribe().get('Training_event__c').getDescribe().fields.getMap();
        
        List<LCRM_Learning_Objectives__c> lObj = LCRM_Learning_Objectives__c.getall().values();
        List<String> lObjApiName = new List<String>();  
        for(LCRM_Learning_Objectives__c l:lObj)
            lObjApiName.add(l.Name);
            
        String sQueryString = 'SELECT ';
        for(integer i=0 ; i<lObjApiName.size() ; i++){
            if(i != lObjApiName.size()-1)
                 sQueryString += lObjApiName[i]+ ',';
             else 
                 sQueryString += lObjApiName[i];
        }
        sQueryString += ' FROM Training_event__c WHERE Id =:trainingEventId';
        Training_Event__c te = Database.query(sQueryString);
        
        List<String> learningObj = new List<String>();
        for (String fieldName: lObjApiName) {
            if(te.get(fieldName) == true) 
                learningObj.add(teFieldsMap.get(fieldName).getDescribe().getLabel());       
        }
        
        learningObjs = new List<LearningObjectives>();
        
        if(learningObj.size()>0){
            LearningObjectives obj;
            for(integer i=0 ; i<learningObj.size() ; i++){
                obj = new LearningObjectives();
                obj.sNo = i+1+'. ';
                obj.lObj = learningObj.get(i);
                obj.nextLine = '\r\n';
                learningObjs.add(obj);
            }
        }
        
        return learningObjs;
    }
    
    public String getOwnerName(){
        return [SELECT LCRM_Owner__c FROM Training_Event__c WHERE id=:trainingEventId].LCRM_Owner__c;
    }
    
     /*Harika - 2017-10-27  CRM -10938
   *Description : Created getProductNames to display all the Products related to Training Event as Coma seperated String
   * @Return Type String
   */
    
    public String getProductNames(){
        
        List<String> trainingproductname= new List<String>();
        List<Training_Event_Product__c> teProds = [SELECT LCRM_Product__r.Name FROM Training_Event_Product__c WHERE LCRM_Training_Event__c = :trainingEventId Order By Name Desc];
        String SProductNames;
        if(teProds!=null && teProds.size()>0)
        {
            
            for(Training_Event_Product__c teProd:teProds)
            {
                
                trainingproductname.add(teProd.LCRM_Product__r.Name);
                
            }
            
            //Harika -Added as part of CRM -10938 to display all the product names in a string
            
            if(!trainingproductname.isEmpty())
            {
                for(String str : trainingproductname)
                {
                    if(SProductNames!= null && SProductNames!= '')
                    { 
                        SProductNames+= str + ',' ;
                    }
                    else
                    {
                        SProductNames= str +',';
                    }
                }
 
                // remove last additional comma from string
                SProductNames= SProductNames.removeEnd(',');
                

            }
            else
            {
            SProductNames= '';
            }
        }
         
        return SProductNames;
    }
    
    
    
}