public without sharing class TRStore_MicrositeQuote {
    
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
    public Static String shippingMethod = Static_Values__c.getValues('ShipMethodMicrositeIntBestPrice').Value__c;
    public Static String paymentOptionPayByChargeCode = Static_Values__c.getValues('PaymentOptionMicrosite').Value__c;
     
    public static String cartId = '';
    
    public static List<Database.saveResult> mapMicrositeProposal (List<Lead> leadInfo) {
        
        LIST<Apttus_Proposal__Proposal__c> proposalList = new LIST<Apttus_Proposal__Proposal__c>();
        List<Database.saveResult> insertProposal = new LIST<Database.saveResult>(); 
        Apttus_Proposal__Proposal__c micrositeProposal = new Apttus_Proposal__Proposal__c();
        
        id leadId;
        string QuoterecordType;
        
         if(Static_Values__c.getAll().containsKey('TRStoreQuoteRecordType') ){
              QuoterecordType = Static_Values__c.getAll().get('TRStoreQuoteRecordType').value__c;
          } 
        
        if(!leadInfo.isEmpty()){
        //priceListName = (leadInfo[0].Lead_Region__c=='TR Store Canada Print')? priceListNameCA : priceListNameUS ;
        //List<Apttus_Config2__PriceList__c> priceListDetails = [SELECT id,Name FROM Apttus_Config2__PriceList__c WHERE name =: priceListName LIMIT 1];
        try{
            for(Lead lead : leadInfo){
                    
                    leadId = lead.id;
                    
                    if(lead.Product_Configuration__c!=null){
                        micrositeProposal.Apttus_Proposal__Proposal_Name__c = 'TRStoreProposal-' + lead.Product_Configuration__c;
                        cartId = lead.Product_Configuration__c;
                    }
                    if(lead.Lead_Region__c!=null || lead.Lead_Region__c!=''){
                        micrositeProposal.TR_Store_Source__c = lead.Lead_Region__c;
                        micrositeProposal.CurrencyIsoCode = (lead.Lead_Region__c=='TR Store Canada Print') ? 'CAD' : 'USD' ;
                    }
                    
                    if(QuoterecordType  != null)
                        micrositeProposal.recordtypeId = QuoterecordType ;
                    
                    micrositeProposal.Language__c = 'English';
                    micrositeProposal.APTS_Ground_Shipping__c = shippingMethod;
                    micrositeProposal.Latam_APTS_Reason__c = 'Digital';
                    
                    micrositeProposal.APTS_Proposal_Business_Unit__c = (lead.Lead_Region__c=='TR Store Canada Print') ? 'Canada' : 'SCS' ;
                    if(String.isEmpty(micrositeProposal.APTS_Payment_Option__c)){
                      micrositeProposal.APTS_Payment_Option__c = paymentOptionPayByChargeCode; 
                    }
                    
                    proposalList.add(micrositeProposal);
                
            }       
             
            insertProposal = database.insert(proposalList, false);
            
            for (Database.SaveResult sr : insertProposal){
                if (sr.isSuccess()) {
                    // Quote creation was successful
                    System.debug(LoggingLevel.INFO,'Successfully inserted quote. Quote ID: ' + sr.getId());
                    if ((sr.getId() != null) && (cartId != null)) {
                        database.update( new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c=sr.getId(),Apttus_Config2__BusinessObjectRefId__c=sr.getId(),Apttus_Config2__BusinessObjectType__c='Proposal', id=cartid), false);
                    }
                   
                }
                else {
                    // Quote creation failed            
                    for(Database.Error err : sr.getErrors()) {                  
                        System.debug(LoggingLevel.INFO,err.getStatusCode() + ': ' + err.getMessage());
                        TRStoreLeadprocess.logTRSException('Lead convert process', err.getMessage(), 'Quote Create From Microsite Approvals', leadId,'Quote/Proposal', 'Order Confirmation', supportEmail, false);
                    }
                }
            
              }
          } catch(exception e){
                    system.debug(LoggingLevel.INFO,'Exception came in microsite quote creation>>>>>'+e);
                   // TRStoreLeadprocess.logTRSException('proposal update error', 'lead is not converted', 'Quote Update', insertProposal[0].id,'Quote/Proposal', 'Order Confirmation', supportEmail, false);
                }  
        }
        
        return insertProposal;
    }
    
}