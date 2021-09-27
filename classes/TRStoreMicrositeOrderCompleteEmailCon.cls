public without sharing class TRStoreMicrositeOrderCompleteEmailCon {
    
    public id LeadId;
    public Lead leadrecord{get;set;}
    public Apttus_Config2__ProductConfiguration__c pc{get; set;}
    public List<Online_Contacts__c> onlineContact{get; set;}
    
    
    public String getLeadId(){
        return LeadId;
    }
    
    public void setLeadId(id lId){     
        LeadId = lId;
       if( LeadId != null){
       
            leadrecord = [SELECT Id, firstname,lastName, email, job_function__c,street, Shipping_Street_2__c, city, state, country, postalcode, Billing_Street__c, Billing_State__c, Billing_City__c, 
                          Billing_Country__c, Billing_Zip__c, company, TRStore_ChargeCode__c, Product_Configuration__c, Lead_Microsite__c, SAPAccountNumber__c, MobilePhone, Phone, Shipping_Phone__c,
                          TRstore_Payment_Method__c, Microsite_Lead_Status__c, Microsite_Approvals_History__c  from Lead WHERE ID =: LeadId];
            
            pc = new Apttus_Config2__ProductConfiguration__c();
            pc = [SELECT id, Name,Rollup_Net_Price__c, (SELECT id, name, APTS_Product_Name__c, Apttus_Config2__Quantity__c, Apttus_Config2__NetPrice__c, APTS_Product_Code__c FROM Apttus_Config2__lineItems__r) 
                            from Apttus_Config2__ProductConfiguration__c where id =: leadrecord.Product_Configuration__c ]; 
            
           // if (LeadId != null){
                onlineContact = [SELECT id, First_Name__c, Last_Name__c, Email__c, WLEc_Juris__c, Position__c, Type__c 
                                 FROM Online_Contacts__c
                                 WHERE Lead__c =: LeadId];
           // }
            /*for (List<Online_Contacts__c> onlineContactList:[SELECT id, First_Name__c, Last_Name__c, Email__c, WLEc_Juris__c, Position__c, Type__c 
                                 FROM Online_Contacts__c
                                 WHERE Lead__c =: LeadId]){
                if(onlineContactList.size()>0){
                    onlineContact = onlineContactList;
                }
            }*/
                         
        }
        
    
    }
    
    public TRStoreMicrositeOrderCompleteEmailCon(){
        
    }


}