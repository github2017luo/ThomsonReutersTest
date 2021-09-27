/********************************************************************************
Class Name      : DCPRenewalRestHandler_test
@description    : Testing Services
********************************************************************************
===============================================================================
Date                         Developer              Description
27-06-2021                   RameshBabu           Initial Creation
********************************************************************************
*/

@istest
public class DCPRenewalRestHandler_test {
    

       @Testsetup static void makeData(){

    
        DCPTestDataFactory.disableApplicationAutomation();
         //DCPCreateDocusignEnvelope_Test.createDocusignTestData();



        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        insert ssd;
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        insert con;
        PriceBook2 pricebook = (PriceBook2)objectToDataMap.get('PriceBook2');
        insert pricebook;
           
        
        Apttus_Config2__PriceList__c pricelist = (Apttus_Config2__PriceList__c)objectToDataMap.get('Apttus_Config2__PriceList__c');
        insert pricelist;
        Opportunity opp = (Opportunity)objectToDataMap.get('Opportunity');
        opp.StageName = 'Contacting';
        opp.Renewal_Date__c = system.today().addDays(180);
        opp.Pricebook2id = pricebook.id;
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = con.id;
        insert opp;
        Apttus_Proposal__Proposal__c prop = (Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c');
        prop.Apttus_Proposal__Primary__c = false;
        prop.Digital_Batch_Processed__c = true;
        prop.Digital_Quote_Automation__c = true;
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        prop.Digital_Envelope_Created__c = false;    
        prop.Apttus_Proposal__Approval_Stage__c = 'Generated';
        prop.Apttus_Proposal__Opportunity__c = opp.id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.APTS_SSD_bill_to__c = ssd.id;
        prop.APTS_SSD_ship_to__c = ssd.id;
        prop.Apttus_QPConfig__BillToAccountId__c = acc.id;
        prop.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        prop.APTS_Order_Confirmation_Contact__c = con.id;
        prop.Apttus_QPConfig__PriceListId__c = pricelist.id;
        insert prop;
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_Config2__Status__c = 'Finalized';
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BusinessObjectId__c = 'Proposal';
        cart.APTS_SSD_bill_to__c = ssd.id;
        cart.APTS_SSD_Ship_To__c = ssd.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.Id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.Id;
        cart.Apttus_Config2__AccountId__c = acc.Id;
        cart.Apttus_Config2__PriceListId__c = pricelist.id;
        insert cart;
        Product2 prod = (Product2)objectToDataMap.get('Product2');
        //prod.APTS_Product_Pricing_Model__c = 'Banded';
       // prod.APTS_Product_Pricing_Model__c ='Per Seat';
        insert prod;

         Apttus_Config2__PriceListItem__c priceListItem = (Apttus_Config2__PriceListItem__c)objectToDataMap.get('Apttus_Config2__PriceListItem__c');
        priceListItem.Apttus_Config2__PriceListId__c = pricelist.id;
        priceListItem.Apttus_Config2__ProductId__c = prod.id;
        insert priceListItem;
        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)objectToDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.id;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ProductId__c = prod.id;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem.Apttus_Config2__PriceListItemId__c = priceListItem.id;
        lineItem.Apttus_Config2__PricingStatus__c = 'Pending';

        insert lineItem;
         ContentVersion contentVer = new ContentVersion();
        contentVer.ContentLocation = 'S';
        contentVer.Title = String.valueOf('Order Form Test Content Version');
        contentVer.PathOnClient = String.valueOf('Test PathOnClient');
        contentVer.versiondata = EncodingUtil.base64Decode('Test versionData');
        contentVer.Legacy_ParentId__c = prop.id; // use this field to tie the content version to the proposal
        insert contentVer;
        contentVer = [SELECT id, ContentDocumentId FROM ContentVersion WHERE Title = 'Order Form Test Content Version' LIMIT 1];

        ContentDocumentLink contentDocLink = new ContentDocumentLink();
        contentDocLink.ContentDocumentId = contentVer.ContentDocumentId;
        contentDocLink.LinkedEntityId  = prop.id;
        insert contentDocLink;

        // default DocuSign user record        
        Apttus_DocuApi__DocuSignUser__c oDocuSign = new Apttus_DocuApi__DocuSignUser__c();
        oDocuSign.Apttus_DocuApi__DocuSignAccountId__c = '1970775';
        oDocuSign.Apttus_DocuApi__Default__c = TRUE;
        insert oDocuSign;
        
        // create web service setting for DocuSign Connection
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'test.endpoint';
        web.Name = 'Digital DocuSign Connection';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        insert web;
                  }
           
     @isTest static void viewEnvelopeTest(){
         
        RestRequest request = new RestRequest();
        RestResponse response=new RestResponse();
        request.requestUri =
            '/services/apexrest/digital/renewal/envelope?docusignEnvelopeId=1d855f69-3fd4-4ce0-b3a0-9667b09a3393';
        request.httpMethod = 'get';
        request.addHeader('Content-Type','application/json');
        RestContext.request = request;
        RestContext.response= response;
        
                 test.startTest();
                 try {   
       // Test.setMock(HttpCalloutMock.class, new DCPViewDocusignEnvelope_Test.DocusignViewEnvelopeSuccess());
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());

            DCPServiceResponse response1= DCPRenewalRestHandler.serviceHandler('envelope');
                  system.assertEquals(String.isBlank(response1.response),false, 'Success');
                 }
                 catch(Exception ex){
                               
    
            Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
            System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');

                              
                                   }
                         
                  test.stopTest();
             }
    @isTest static void viewEnvelopeExceptionTest(){
        
                         test.startTest();
                 try {   
       // Test.setMock(HttpCalloutMock.class, new DCPViewDocusignEnvelope_Test.DocusignViewEnvelopeSuccess());
            Test.setMock(HttpCalloutMock.class, new HttpResponseMock());

             DCPServiceResponse response=DCPRenewalRestHandler.serviceHandler('');
             system.assertEquals(String.isBlank(response.response),false, 'Success');
                 }
                 catch(Exception ex){
                     
                 Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
                 System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');

                                     }
               test.stopTest();

    }
  

         @isTest static void handleRepriceTest(){
        List<Apttus_Config2__ProductConfiguration__c> cart =    [SELECT id
                                                                         FROM Apttus_Config2__ProductConfiguration__c ];
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> cart  :  '+ cart);
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('cartId', cart[0].Id);
        System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> RequestBody  :  '+ requestBody);


            
          test.startTest();
              try{
                DCPServiceResponse response= DCPRenewalRestHandler.serviceHandler('reprice',requestBody);
                  system.assertEquals(String.isBlank(response.response),false, 'Success');
                 }
               catch(Exception ex){
              Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
              System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');
                                 }             
                test.stopTest();
               }
    
        @isTest static void handleRepriceSuccess(){
                     
        List<Apttus_Config2__ProductConfiguration__c> cart = new List<Apttus_Config2__ProductConfiguration__c>();
        List<Apttus_Config2__LineItem__c> lineItem = new List<Apttus_Config2__LineItem__c>();

        Map<String, SObject> objectToDataMap1 = DCPTestDataFactory.declareSObjectData();
        cart.add((Apttus_Config2__ProductConfiguration__c)objectToDataMap1.get('Apttus_Config2__ProductConfiguration__c'));
        insert cart;

        lineItem.add((Apttus_Config2__LineItem__c)objectToDataMap1.get('Apttus_Config2__LineItem__c'));
        lineItem[0].Apttus_Config2__ConfigurationId__c = cart[0].Id;
        lineItem[0].Apttus_Config2__PricingStatus__c='Pending';
        insert lineItem;
            
        List<Apttus_Config2__ProductConfiguration__c> cart1 =    [SELECT id
                                                                           FROM Apttus_Config2__ProductConfiguration__c ];
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('cartId', cart1[0].Id);

                   Test.startTest();
                     try{
                           String result = DCPRepriceCart.repriceCart(requestBody);
                           System.debug(LoggingLevel.DEBUG,result);
                           DCPServiceResponse response=   DCPRenewalRestHandler.serviceHandler('reprice',requestBody);
                           system.assertEquals(String.isBlank(response.response),false, 'Success');
                         
                         }
                     catch(Exception ex){
                         Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
                         System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');

                                        }
                      Test.stopTest();
                     }
    
     @isTest static void bundleTest(){
         List<Apttus_Config2__ProductConfiguration__c> cart =    [SELECT id
                                                                FROM Apttus_Config2__ProductConfiguration__c ];
         System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> cart  :  '+ cart);
         Map<String, String> requestBody = new Map<String, String>();
         requestBody.put('cartId', cart[0].Id);
         System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> RequestBody  :  '+ requestBody);


            
          test.startTest();
              try{
                DCPServiceResponse response= DCPRenewalRestHandler.serviceHandler('bundle',requestBody);
                system.assertEquals(String.isBlank(response.response),false, 'Success');
                 }
               catch(Exception ex){
                Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
                System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');

                                  }
               test.stopTest();
             }
    


    @istest static void finalizetest(){
        
        List<Apttus_Proposal__Proposal__c> propList;
        List<Apttus_Config2__ProductConfiguration__c> cartList;
        Opportunity opp = [SELECT id, Renewal_Date__c FROM Opportunity ];
        Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c ];
        propList = DCPProposal.getPresentedProposal(opp.Id,ssd.Id);
		cartList =    [SELECT id FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__Status__c ='Finalized'];
        
        Map<string,string> requestbody = new Map<string,string>();
        requestBody.put('cartId', cartList[0].id);

        Test.startTest();
        try{
            
            DCPServiceResponse response= DCPRenewalRestHandler.serviceHandler('finalize',requestBody);
            system.assertEquals(String.isBlank(response.response),false, 'Success');

           
           }catch(Exception ex){
            Boolean expectedExceptionThrown = !String.isBlank(ex.getStackTraceString())?true:false;
            System.assertEquals(expectedExceptionThrown, true,'The returned data is not correct !');

                             }
        
        Test.stopTest();
    
    
    }
             
      @isTest static void servicehandlerPutTest(){
          
      Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c];

         Map<String,String> requestBody = new Map<String,String>{'proposalId'=>prop.id};
         Map<String,String> requestBodyImproper = new Map<String,String>{'proposalsId'=>prop.id};

            
        List<Apttus_Config2__ProductConfiguration__c> cart =    [SELECT id, Apttus_Config2__Status__c
                                                                FROM Apttus_Config2__ProductConfiguration__c];
    
    	
    	System.debug(LoggingLevel.DEBUG,'cart details' +cart);
        Map<String, String> requestBody1 = new Map<String, String>();
        requestBody1.put('cartId', cart[0].Id);


                 test.startTest();
        
             try{

              DCPRenewalRestHandler.serviceHandler('document',requestBody);
              DCPRenewalRestHandler.serviceHandler('document',requestBodyImproper);
                 
              cart[0].Apttus_Config2__Status__c = '';
              update cart;
                
              // for CartNotFinalized condition  
              DCPRenewalRestHandler.serviceHandler('document',requestBody);

              }
             catch(Exception ex){
                 System.debug(LoggingLevel.WARN,'ExceptiomMessage:'+ex.getMessage());
                 System.assertEquals('ExceptinThrown', ex.getMessage(),'GenaeratedocumentUnsuccess');
                 
             }           

            test.stopTest();
             
           }

             
             @isTest static void handlePutTest3(){
                           
           try{
              Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c ];
              Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
              envelope.Apttus_DocuApi__ParentId__c = prop.id;
              envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
              envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;

        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid'};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new DCPViewDocusignEnvelope_Test.DocusignViewEnvelopeSuccess());
          Test.setMock(HttpCalloutMock.class, new HttpResponseMock());


        // Set mock callout class for Envelope response
                  DCPRenewalRestHandler.serviceHandlerPUT('envelope',requestBody);


                 }
                       catch(Exception ex){
                        System.debug(LoggingLevel.WARN,'ExceptiomMessage:'+ex.getMessage());
                        System.assertNotEquals('ExceptinThrown', ex.getMessage(),'envelopenotsuccess');
                           
                       }
                       test.stopTest();
                       
                   }
        @isTest static void serviceHandlerPUTExceptionTest(){
        
             test.startTest();
             Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid'};

         try {   
              // Test.setMock(HttpCalloutMock.class, new DCPViewDocusignEnvelope_Test.DocusignViewEnvelopeSuccess());
              Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
              DCPRenewalRestHandler.serviceHandlerPUT('enveelope',requestBody);
             }
                 catch(Exception ex){
                     System.debug(LoggingLevel.WARN,'ExceptiomMessage:'+ex.getMessage());
                     System.assertNotEquals('ExceptinThrown', ex.getMessage(),'DocusignenvelopeUnsuccess');
                     
                                    }
               test.stopTest();

    }


    
    
    @istest static void createEnvelopeTest(){
        

        Test.startTest();   
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Approval_Stage__c = 'Generated' LIMIT 1];

        Map<String,String> requestBody = new Map<String,String>{'proposalId'=>prop.id};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
        DCPServiceResponse dcpresp= DCPRenewalRestHandler.serviceHandler('envelope',requestBody);
        System.assertEquals('Success', dcpresp.status,'CreateEnvelopeFails');
        
        Test.stopTest();

    }
        @isTest
    private static void updateVoidDocusignEnvelopeTest(){
        
        Apttus_Proposal__Proposal__c prop = [SELECT id FROM Apttus_Proposal__Proposal__c LIMIT 1];
        Apttus_DocuApi__DocuSignEnvelope__c envelope = new Apttus_DocuApi__DocuSignEnvelope__c();
        envelope.Apttus_DocuApi__ParentId__c = prop.id;
        envelope.Apttus_QPDSign__QuoteProposal__c = prop.id;
        envelope.Apttus_DocuApi__EnvelopeId__c = 'someid';
        insert envelope;

        Test.startTest();   
        
        Map<String,String> requestBody = new Map<String,String>{'docusignEnvelopeId'=>'someid','updateAction'=>'void','voidReason'=>'Some reason'};

        // Set mock callout class for Envelope response
        Test.setMock(HttpCalloutMock.class, new HttpResponseMock());
         DCPServiceResponse dcpresp= DCPRenewalRestHandler.serviceHandlerPUT('envelope',requestBody);
         System.assertEquals('Success', dcpresp.status,'UpdateEnvelopeFails');
        
        Test.stopTest();
    }
    
}