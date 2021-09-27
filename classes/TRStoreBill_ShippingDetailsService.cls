@RestResource(urlMapping='/BillingShippingDetails')
global without sharing class  TRStoreBill_ShippingDetailsService{

    public static TRStoreAddressdDetails addressdetails{get; set;}

     @HttpGet
    global static TRStoreAddressdDetails  fetchBillingAndShippingAddress(){
        
        RestRequest req = RestContext.request;
        string billingaccountNumber = req.params.get('billToAccountNum');
        string zipCode = req.params.get('zipCode');
        string country = req.params.get('country');
        string siteName = req.params.get('site');
        
        LIST<string> billingAccountNumbers= new LIST<string>();
        billingAccountNumbers.add(req.params.get('billToAccountNum'));
        
        system.debug(LoggingLevel.Info,'Billing address.....'+billingAccountNumbers);
        system.debug(LoggingLevel.Info,'Billing address.....'+billingaccountNumber );
        system.debug(LoggingLevel.Info,'zipCode.....'+zipCode);
        system.debug(LoggingLevel.Info,'Country.....'+country );
        
         
        if(!string.isBlank(billingaccountNumber) &&  !string.isBlank(zipCode) ){
        
        
            string billToFunction;
            string shipToFunction;
            string countrySalesOrg;
            
            
            if(Static_Values__c.getAll().containsKey('BusinessPartnerBillPay'))
                billToFunction = Static_Values__c.getAll().get('BusinessPartnerBillPay').Value__c;
                
            if(Static_Values__c.getAll().containsKey('BusinessPartnerShipPay'))
                shipToFunction = Static_Values__c.getAll().get('BusinessPartnerShipPay').Value__c;
             
             if(!string.isBlank(country)){
                  system.debug(LoggingLevel.Info,'country .....'+country);
                 if(country.equalsIgnoreCase('CA')){
                     countrySalesOrg = Static_Values__c.getAll().get('CanadaSalesOrg').Value__c;
                 }else{
                     countrySalesOrg = Static_Values__c.getAll().get('UsSalesOrg').Value__c;
                 }
             }else{
                 countrySalesOrg = Static_Values__c.getAll().get('CanadaSalesOrg').Value__c;
             }
             
             
             if(siteName == 'pwc'){
                  if(Static_Values__c.getAll().containsKey('pwcBusinessAcc1'))
                        billingAccountNumbers.addAll((Static_Values__c.getAll().get('pwcBusinessAcc1').Value__c).split(','));
                  if(Static_Values__c.getAll().containsKey('pwcBusinessAcc2'))
                        billingAccountNumbers.addAll((Static_Values__c.getAll().get('pwcBusinessAcc2').Value__c).split(','));
                  if(Static_Values__c.getAll().containsKey('pwcBusinessAcc3'))
                        billingAccountNumbers.addAll((Static_Values__c.getAll().get('pwcBusinessAcc3').Value__c).split(','));
            
                 
                 
             }else if(siteName == 'det'){
                 if(Static_Values__c.getAll().containsKey('detBusinessAcc1'))
                        billingAccountNumbers.addAll((Static_Values__c.getAll().get('detBusinessAcc1').Value__c).split(','));
                  if(Static_Values__c.getAll().containsKey('detBusinessAcc2'))
                        billingAccountNumbers.addAll((Static_Values__c.getAll().get('detBusinessAcc2').Value__c).split(','));
                  if(Static_Values__c.getAll().containsKey('detBusinessAcc3'))
                        billingAccountNumbers.addAll((Static_Values__c.getAll().get('detBusinessAcc3').Value__c).split(','));
            
             }
             
        system.debug(LoggingLevel.Info,'Billing address.....'+billingAccountNumbers);
        system.debug(LoggingLevel.Info,'zipCode.....'+zipCode);
        system.debug(LoggingLevel.Info,'Country.....'+country );
        system.debug(LoggingLevel.Info,'countrySalesOrg .....'+countrySalesOrg );
        system.debug(LoggingLevel.Info,'shipToFunction .....'+shipToFunction );
        system.debug(LoggingLevel.Info,'billToFunction .....'+billToFunction );
        
             
            LIST<Business_Partner_Function__c> bpf = new LIST<Business_Partner_Function__c>();
            bpf = [select id, name, Account_SAP_Number__c, Related_Account__c, Related_Account__r.name, Relationship_Type__c, State__c, Street__c, Zip__c, City__c, 
                        Default__c, country__c, Related_Account_GLI__r.Name, Related_Account_GLI__c, Related_Account_GLI__r.LCRM_Market_Segment__c, 
                        Related_Account_GLI__r.LCRM_Phone__c FROM Business_Partner_Function__c WHERE 
                        (Related_Account_GLI__r.Source_System_Account_Number__c IN: billingAccountNumbers OR (Related_Account_GLI__r.Source_System_Account_Number__c  =: billingaccountNumber  AND Related_Account_GLI__r.Postal_Code__c LIKE: '%'+ zipCode +'%' )) AND Related_Account_GLI__r.LCRM_Sales_Org__c =: countrySalesOrg
                        AND ( ( Related_Account_GLI__r.Source_System_Account_Number__c =: billingaccountNumber AND Relationship_Type__c =: billToFunction ) OR (Related_Account_GLI__r.Source_System_Account_Number__c IN: billingAccountNumbers  AND Relationship_Type__c =: shipToFunction ) )
                        AND Related_Account_GLI__r.Source_System_Account_Number__c != null ];
            
            system.debug(LoggingLevel.Info,'Business_Partner_Function__c.....'+bpf);
            
            //addressdetails = new TRStoreAddressdDetails();
            customerAddress bilAdd = new customerAddress();
            LIST<customerAddress> shipAdd = new LIST<customerAddress>();
            
           // LIST<TRStore_OrderRequest.customerAddress>  sal = new LIST<TRStore_OrderRequest.customerAddress>();     
                
               // orgDetails odd = new orgDetails();
                string oName; 
                string oId;
                string oMS;
            for(Business_Partner_Function__c bp: bpf){
            
                system.debug(LoggingLevel.Info,'Hello Phone...........'+bp.Related_Account_GLI__r.LCRM_Phone__c);
                
                if(bp.Relationship_Type__c.equalsIgnoreCase(billToFunction )){
                   
                       bilAdd.street1 = bp.Street__c;
                       bilAdd.city = bp.City__c;
                       bilAdd.state = bp.State__c;
                       bilAdd.country = bp.country__c ;
                       bilAdd.zipCode = bp.Zip__c;
                       bilAdd.accNumber = bp.Account_SAP_Number__c;
                       bilAdd.phone = bp.Related_Account_GLI__r.LCRM_Phone__c;
                       
                   // addressdetails.BillingaddressDetails = bilAdd;
                   oName =  bp.Related_Account_GLI__r.Name;
                   oId = bp.Related_Account_GLI__c;
                   oMS = bp.Related_Account_GLI__r.LCRM_Market_Segment__c;
                
                }else if(bp.Relationship_Type__c.equalsIgnoreCase(shipToFunction) ){
                    customerAddress sp = new customerAddress();
                    
                       sp.street1 = bp.Street__c;
                       sp.city = bp.City__c;
                       sp.state = bp.State__c;
                       sp.country = bp.country__c ;
                       sp.zipCode = bp.Zip__c;
                       sp.accNumber = bp.Account_SAP_Number__c;
                       sp.phone = bp.Related_Account_GLI__r.LCRM_Phone__c;
                       
                    shipAdd.add(sp);
                }
                
            
            }
            
          //   addressdetails.shippingAddressDetails = shipAdd;
          orgDetails odd = new orgDetails(oName, oId, oMS);
          if(!bpf.isEmpty()){
            addressdetails = new TRStoreAddressdDetails(bilAdd, shipAdd,odd, TRStoreConstants.SUCCESS_STATUS, TRStoreConstants.SUCCESS_CODE );
          }else{
              addressdetails = new TRStoreAddressdDetails(null, null,null, TRStoreConstants.DETAILS_NOT_FOUND , TRStoreConstants.DETAILS_NOT_FOUND_CODE );
          }   
        }else{
            addressdetails = new TRStoreAddressdDetails(null, null,null, TRStoreConstants.DETAILS_NOT_FOUND , TRStoreConstants.REQUIREDFIELDSMISSING );
        }

     return addressdetails;    
    }



    //Wrapper classes 

   global class TRStoreAddressdDetails{
   
       public customerAddress BillingaddressDetails;
       public LIST<customerAddress> shippingAddressDetails;
       public orgDetails organizationDetails;
       public string statusDetaail;
       public string statusCode;
       
       public TRStoreAddressdDetails(customerAddress ba, LIST<customerAddress> sa, orgDetails od, string rs, string rc){
           
           shippingAddressDetails = new LIST<customerAddress>();
           BillingaddressDetails = new customerAddress();
           
           shippingAddressDetails = sa;
           BillingaddressDetails = ba;
           organizationDetails = od;
           statusDetaail = rs;
           statusCode = rc;
       
       }
 
   }
    
    global class orgDetails{
        public string organizationName;
        public string organizationId;
        public string organizationType;
        
        
        public orgDetails(string oName, string oId, string orgType){
            
            organizationName = oName;
            organizationId = oId;
            organizationType = orgType;
        }
        
    }
    
    
      public class customerAddress {
        public String street1; //610 Opperman Dr
        public string street2; // optional 
        public String city; //Eagan
        public String state;    //MN
        public String zipCode;  //55123
        public String country;  //US
        public string accNumber;
        public string phone;
    }
    
    
   
}