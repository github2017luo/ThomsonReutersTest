public without sharing class ESC_SectionDetails{
        public boolean hasMasterOrigin {get; set;}
        public string masterObject{get; set;}
        public string masterQueryparamKey{get; set;}
        public string masterRecordID{get; set;}
        public Sobject masterRecord{get; set;}
        public ESC_Case_Form_Extension__c cfexten {get; set;}
         public List<ESC_Case_Form_Extension_Line_Item__c> cfextenLineItems {get; set;}
        public List<Form_Section__c> allformSections {get; set;}
        
        public ESC_SectionDetails(){
            allformSections = new List<Form_Section__c>();
            hasMasterOrigin = false;
            cfexten = new ESC_Case_Form_Extension__c();
            cfextenLineItems = new List<ESC_Case_Form_Extension_Line_Item__c>();
            
        }
       
        
        
         public Map<string,Object> getSectionDetails(string recordID, string toBeFecthedFields, string objectType ){
            
       string query= 'select '+toBeFecthedFields+' from '+objectType+' where id=\''+recordID+'\'';
       system.debug('query'+query);
        Map<string,Object> fieldMap = new Map<string,Object>();
         List<Sobject> sob = Database.query('select '+string.escapesinglequotes(toBeFecthedFields)+' from '+string.escapesinglequotes(objectType)+' where id=\''+string.escapesinglequotes(recordID)+'\'');
         try{
         if(sob !=null){
              system.debug('sob'+sob);
        for(string field: toBeFecthedFields.split(',')){
            fieldMap.put(field,sob[0].get(field));
            
        }
        fieldMap.put('id',sob[0].get('id'));
         }}
         catch(exception ex){
              system.debug('Exception cauth'+sob);
         }
        return fieldMap;
    }
    public List<Sobject> getSectionDetailsSOBJ(string recordID, string toBeFecthedFields, string objectType){
       string query= 'select '+toBeFecthedFields+' from '+objectType+' where id=\''+recordID+'\'';
       system.debug('query'+query);
        Map<string,Object> fieldMap = new Map<string,Object>();
         List<Sobject> sob = new List<Sobject>();
        try{
        sob = Database.query('select '+string.escapesinglequotes(toBeFecthedFields)+' from '+string.escapesinglequotes(objectType)+' where id=\''+string.escapesinglequotes(recordID)+'\'');
         return sob;
        }
         catch(exception ex){
              system.debug('Exception cauth'+sob);
             
              
               return null;
         }
       
    }
    public List<Sobject> getSectionDetailsSOBJ(string caseid,String formId, string toBeFecthedFields, string objectType ){
        String extensionId='';
        String query='';
        List<Sobject> sob = new List<Sobject>();
        if(objectType.equalsignoreCase('ESC_Case_Form_Extension_Line_Item__c')){
            try{
                extensionId = [select Id from ESC_Case_Form_Extension__c where ESC_Case__c=:caseid and ESC_form__c=:formid].Id;
            }
            catch(exception ex){
                system.debug('Exception:'+ex.getStackTraceString());
            }
            if(extensionId!=''){
                //query= 'select '+string.escapeSingleQuotes(toBeFecthedFields)+' from '+string.escapeSingleQuotes(objectType)+' where ESC_Case_Form_Extension__c=\''+string.escapeSingleQuotes(extensionId)+'\'';
            try{    
                sob = Database.query('select '+string.escapeSingleQuotes(toBeFecthedFields)+' from '+string.escapeSingleQuotes(objectType)+' where ESC_Case_Form_Extension__c=\''+string.escapeSingleQuotes(extensionId)+'\'');
            }
            catch(exception ex){
              system.debug('Exception cauth'+sob);
        }
        finally{
            return sob;
        }
            }
        }
        else{
            //query= 'select '+string.escapeSingleQuotes(toBeFecthedFields)+' from '+string.escapeSingleQuotes(objectType)+' where ESC_Case__c=\''+string.escapeSingleQuotes(caseid)+'\' and ESC_Form__c=\''+string.escapeSingleQuotes(formId)+'\'';
            try{
            sob = Database.query('select '+string.escapeSingleQuotes(toBeFecthedFields)+' from '+string.escapeSingleQuotes(objectType)+' where ESC_Case__c=\''+string.escapeSingleQuotes(caseid)+'\' and ESC_Form__c=\''+string.escapeSingleQuotes(formId)+'\'');
            }
            catch(exception ex){
              system.debug('Exception cauth'+sob);
        }
        finally{
            return sob;
        }
        }
      /* system.debug('query'+query);
        
        try{
            if(query!=''){
                //sob = Database.query(query);
            }
        }
        catch(exception ex){
              system.debug('Exception cauth'+sob);
        }
        finally{
            return sob;
        }*/
        return sob;
    } 
    }