global with sharing class SF1LeadCreateController {
    
    Lead oLead {get; set;}
    public List<SelectOption> listCountryOptions {get; set;}
    private final ApexPages.StandardController oStandardController;
    public boolean bRedirect {get;set;}
    public Id savedLeadId {get; set;}
    public String strProfileName;

    public SF1LeadCreateController () {
        oLead = new Lead();
        listCountryOptions = DataQualityUtil.listAvailableCountryOptions();
        //oLead.Sales_Org__c = [Select Sales_Org__c from User where Id =:UserInfo.getUserId()].Sales_Org__c;
        strProfileName = [Select Id, Name from Profile where Id =:UserInfo.getProfileId()].Name;
        List<User> listUser = [Select Id, Sales_Org__c from User where Id =:UserInfo.getuserId() LIMIT 1];
        
        if(strProfileName =='TR Legal US Sales User'){
            oLead.Sales_Org__c = 'WEST';
            oLead.Customer_Type__c = 'Organization';
        }
        else{
            oLead.Sales_Org__c = listUser[0].Sales_Org__c;
        }    
    }
    
    public Lead getLead() {
        if(oLead == null) oLead = new Lead();
        return oLead;
    }
    
    public pageReference save() {
        try{
            PageReference oPageReference = null;
            oLead.Status ='Contacting'; 
            insert oLead;
            
            //Navigate to newly created Lead(Record) Detail page 
            savedLeadId = oLead.Id;  
            System.debug('oSavedLeadId at ValidateLead: '+savedLeadId); 
            bRedirect = true;  
           
        } catch(System.DMLException e) {
           ApexPages.addMessages(e);
        }
        return null;
    }

    public SF1LeadCreateController (ApexPages.StandardController controller) {
        oLead = new Lead();
    }   

}