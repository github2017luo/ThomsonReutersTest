/**
    * @description class used in Payment related Email templates
    *  
    */
public without sharing class ESC_getCreditcardDetails{
     //public List<ESC_Case_Form_Extension__c> creditcardDetails{get;set;}
    /**
     * @description caseId - retrieved from apex component 
     */
     public String caseId{get;set;}
    /**
     * @description c  
     */
     public case c{
            get {
              c = [Select Id, casenumber from case where id =: caseId];
              return c; 
           }
           set;
        }
    
    /**
     * @description ESC_Case_Form_Extension__c 
     */
    public List<ESC_Case_Form_Extension__c> cfe{
        get {
             
          cfe = new List<ESC_Case_Form_Extension__c>();
         //List<ESC_Case_Form_Extension_Line_Item__c> cfli = new List<ESC_Case_Form_Extension_Line_Item__c>();
         if(Schema.sObjectType.ESC_Case_Form_Extension__c.isQueryable()){
            cfe = [Select id,name,USL_Transaction_Date__c,ESC_CreditCard_Details__c,ESC_Invoice_Number__c,ESC_Credit_Card_Type__c,ESC_Bank_Routing_Number__c,ESC_Payment_Type__c from ESC_Case_Form_Extension__c WHERE ESC_Case__c=: caseId and ESC_Form__r.name =: 'CreditCard/Debit Payment'];
         }
        return cfe;
        }
        set;
    }
    
    /**
     * @description newLine 
     */
    public String newLine {
        get { 
            return '\r\n'; }
        set;
    }
}