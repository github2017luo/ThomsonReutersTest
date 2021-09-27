@isTest(seeAllData=false)
public class TRStoreBill_ShippingDetailsServiceTest{
    
    public static testMethod  void TRStoreBill_ShippingDetailsServiceMet1(){
        
        
         Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
        String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        //a.BU_Segment_Level_2__c= valueMarket;
        insert a;
      
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
       /* Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
       // accountSSD.Account_Name__c=a.ID;
        accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Source_System_Account_Number__c='11111112';
        accountSSD.LCRM_SAP_Account_Number__c ='11111112'; 
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Postal_Code__c ='12345-6789';
        insert accountSSD;
        */
         List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                
                insert WebserviceList;
       
        
         Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC'/*,Account_Name__c=acc.ID*/,APTS_Customer_Category__c='1',
                                                                        LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                                                        LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                                                        City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');  
        insert accountSSD;
        
        
        
        List<Business_Partner_Function__c> bpfList=new List<Business_Partner_Function__c>();
                Business_Partner_Function__c bpf1 = new Business_Partner_Function__c();
                bpf1.Relationship_Type__c ='Bill-to party';
                bpf1.Related_Account_GLI__c=accountSSD.id;
                bpf1.Sold_To_Account_GLI__c=accountSSD.id;
            bpf1.Related_Account__c=a.id;
            bpf1.Sold_To_Account__c=a.id;
            bpfList.add(bpf1);
            
             Business_Partner_Function__c bpf2 = new Business_Partner_Function__c();
        bpf2.Relationship_Type__c ='Ship-to party';
        bpf2.Related_Account_GLI__c=accountSSD.id;
        bpf2.Sold_To_Account_GLI__c=accountSSD.id;
    bpf2.Related_Account__c=a.id;
    bpf2.Sold_To_Account__c=a.id;
        bpfList.add(bpf2);
        
         
        
        insert bpfList;
        
        
         LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{
                                                                         new Static_Values__c(name='BusinessPartnerBillPay', value__c='Bill-to party'),
                                                                         new Static_Values__c(name='BusinessPartnerShipPay', value__c='Ship-to party'),
                                                                         new Static_Values__c(name='CanadaSalesOrg', value__c='CARS'),
                                                                         new Static_Values__c(name='UsSalesOrg', value__c='WEST'),
                                                                         new Static_Values__c(name='pwcBusinessAcc1', value__c='10000254'),
                                                                         new Static_Values__c(name='pwcBusinessAcc2', value__c='10058985'),
                                                                         new Static_Values__c(name='pwcBusinessAcc3', value__c='10058985'),
                                                                         new Static_Values__c(name='detBusinessAcc1', value__c='10058985'),
                                                                         new Static_Values__c(name='detBusinessAcc2', value__c='10058985'),
                                                                         new Static_Values__c(name='detBusinessAcc3', value__c='10058985')
                                                                         };
        
        insert staticCSList ;
        
         
        
         RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/BillingShippingDetails';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
         
        req.addHeader('Content-Type', 'application/json');
        
        req.params.put('billToAccountNum', accountSSD.Source_System_Account_Number__c);
        req.params.put('zipCode', '12345');
        req.params.put('country', 'US');
        req.params.put('site', 'pwc');
        
        RestContext.request = req;
    
        TRStoreBill_ShippingDetailsService.fetchBillingAndShippingAddress();
        
        req.params.put('site', 'det');
        RestContext.request = req;
        TRStoreBill_ShippingDetailsService.fetchBillingAndShippingAddress();
        
        
        
    }
    
}