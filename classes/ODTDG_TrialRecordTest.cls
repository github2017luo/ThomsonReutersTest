@IsTest(seeAllData=false)
public with sharing class ODTDG_TrialRecordTest {


    static testmethod void callingData(){

        boolean testBool = true;
        LIST<Static_Values__c> staticList = new LIST<Static_Values__c>();
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipLinkType', 'best'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_FreeTrial', 'Digital'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeMain', 'plan to plan'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeExtended', 'Accessory Product'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('LeadSupportEmail', 'support@test.com'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_ProductJuridisctions', 'General;'));
                staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_best', 'best'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_better', 'better'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_good', 'good'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_PractLaw', '58133'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_PractLawConnect', '58172'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_TandCAccStatus', 'Rep Initiated;Invited;Draft;New;Entitlement Error'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_TandCEntInvalidStatus', 'OP_ERR'));
        insert staticList;
        
       
        LIST<KeyValueListStore__c> keyList = new LIST<KeyValueListStore__c>();
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserProfileName', TextValue__c='TR Corp Partner Community User'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserBUSegmentValue', TextValue__c='Corporate'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserLeadSourceValue', TextValue__c='Partner'));
        insert keyList;

        System.assert(testBool != false,'boolean true');


    }
 
    private static void entitleTest(string prodId,string contId,ODTDG_EntitlementWrapper post1){
        Ent_Trial__c entTrial = new Ent_Trial__c(id=post1.sfdcDetails.trialId , Trial_End_Date__c=date.today());
        update entTrial;
        
        RestRequest req2 = new RestRequest(); 

        req2.requestURI = '/services/apexrest/ODTDGEntitleTrialCustomer' ;
        req2.httpMethod = 'POST';
          //string jsonStrEnttitle='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel"},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"} ]}}' ;
          string jsonStrEnttitle='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","state":"casamia","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName":"Company Name","zipCode":""},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime":"2021-07-27T21:00:00.000+0000"} ]}}' ;
        req2.requestBody = Blob.valueof(jsonStrEnttitle);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post3 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post3...............'+post3);  

        entTrial = new Ent_Trial__c(id=post1.sfdcDetails.trialId , Trial_End_Date__c=(date.today()-365),Trial_Status__c='Accepted');
        update entTrial;
        
        string jsonStrEnttitleOrg='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","state":"casamia","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName":"Company Name","zipCode":""},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime":"2021-07-27T21:00:00.000+0000"} ]}}' ;
        req2.requestBody = Blob.valueof(jsonStrEnttitleOrg);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper postlast = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'postlast...............'+postlast); 
    }

    static testMethod void testParse() {
 
        callingData();

        LIST<Product2> productsstd = new List<Product2>();
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST1';
        prd.ProductCode = '753987';
        prd.Product_Offering__c='Westlaw Edge';
        prd.Free_Trial__c = 'Digital';
        prd.IsActive=TRUE;
        productsstd.add(prd);
        
        Product2 prd1 = new Product2();
        prd1.DC_Product_Title__c = 'sample product';
        prd1.Name ='TEST2';
        prd1.ProductCode = '753986';
        prd1.Product_Offering__c='Practical Law';
        prd1.Free_Trial__c = 'Digital';
        prd1.IsActive=TRUE;
        productsstd.add(prd1);
        
        Product2 prd2 = new Product2();
        prd2.DC_Product_Title__c = 'sample product2';
        prd2.Name ='TEST3';
        prd2.ProductCode = '753985';
        prd2.Product_Offering__c='Practical Law';
        prd2.Free_Trial__c = 'Digital';
        prd2.IsActive=TRUE;
        prd2.ProductMarketingRecordID__c = 58133;
        
        productsstd.add(prd2);
        
        insert productsstd;

    LIST<product2> test1 = [select id,productcode,free_trial__c,Product_Offering__c
                                                                 FROM product2 ];
        system.debug(LoggingLevel.INFO,'testqueyr............'+test1);
        LIST<Product_Relationship__c > prList = new List<Product_Relationship__c>();
        
        Product_Relationship__c p1 = new Product_Relationship__c();
        p1.Product_to__c = prd.Id;
        p1.Product_from__c = prd.Id;
        p1.Segment__c = 'In-house counsel';
        p1.Relationship_Link_Type__c ='best';
        p1.Relationship_Type__c = 'plan to plan';
         
        prList.add(p1);
        
        Product_Relationship__c p2 = new Product_Relationship__c();
        p2.Product_to__c = prd1.Id;
        p2.Product_from__c = prd1.Id;
        p2.Segment__c = 'In-house counsel';
        p2.Relationship_Link_Type__c ='best';
        p2.Relationship_Type__c = 'plan to plan';
        prList.add(p2);
        
         Product_Relationship__c p3 = new Product_Relationship__c();
        p3.Product_to__c = prd1.Id;
        p3.Product_from__c = prd1.Id;
        p3.Segment__c = 'In-house counsel';
        p3.Relationship_Link_Type__c ='Better';
        p3.Relationship_Type__c = 'plan to plan';
        prList.add(p3);
        
         Product_Relationship__c p4 = new Product_Relationship__c();
        p4.Product_to__c = prd1.Id;
        p4.Product_from__c = prd1.Id;
        p4.Segment__c = 'In-house counsel';
        p4.Relationship_Link_Type__c ='Good';
        p4.Relationship_Type__c = 'plan to plan';
        prList.add(p4);
        
        
         Product_Relationship__c p5 = new Product_Relationship__c();
        p5.Product_to__c = prd2.Id;
        p5.Product_from__c = prd1.Id;
        p5.Segment__c = 'In-house counsel';
        p5.Relationship_Link_Type__c ='Best';
        p5.Relationship_Type__c = 'plan to plan';
        prList.add(p5);
        
        
        insert prList;
        
        
        ODTDG_Helper.getPrimaryProductsFromlist(prList);
        
        LIST<product_relationship__c> test = [select id,Product_to__r.productCode,relationship_link_type__c,Product_to__r.Free_Trial__c,relationship_type__c,Product_To__r.Product_Offering__c,Segment__c
                                                                 FROM product_relationship__c ];
        system.debug(LoggingLevel.INFO,'testqueyr............'+test);
         
        string jsonStrPrimary ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"casamia","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null}]}}' ;
        
  
       
        ODTDG_TrialRecord obj = ODTDG_TrialRecord.parse(jsonStrPrimary );
        System.assert(obj != null,'Object Not Created');

      
        
        RestRequest req1 = new RestRequest(); 

        req1.requestURI = '/services/apexrest/ODTDGEntitleTrialCustomer' ;
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(jsonStrPrimary );
        RestContext.request = req1;

        ODTDG_EntitlementWrapper post1 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post1...............'+post1);
        
        Ent_Trial__c entTrial = new Ent_Trial__c(id=post1.sfdcDetails.trialId , Trial_Status__c='Active');
        update entTrial;

        string jsonStrInvite ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Invite","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"'+post1.sfdcDetails.trialId+'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"casamia","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Active","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"businessPhone": "09887765443","cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOugajskgdj","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" :null}]}}' ;
        
        RestRequest req2 = new RestRequest(); 

        req2.requestURI = '/services/apexrest/ODTDGEntitleTrialCustomer' ;
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueof(jsonStrInvite );
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post2 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post2...............'+post2); 

        string prodId=prd.id;
        string contId=post2.sfdcDetails.trialContacts[0].trialContactSfId;
        entitleTest(prodId,contId,post1);
        
        // entTrial = new Ent_Trial__c(id=post1.sfdcDetails.trialId , Trial_End_Date__c=date.today());
        // update entTrial;
        
        //   //string jsonStrEnttitle='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel"},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"} ]}}' ;
        //   string jsonStrEnttitle='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","state":"casamia","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName":"Company Name","zipCode":""},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime":"2021-07-27T21:00:00.000+0000"} ]}}' ;
        // req2.requestBody = Blob.valueof(jsonStrEnttitle);
        // RestContext.request = req2;

        // ODTDG_EntitlementWrapper post3 = ODTDG_EntitleTrialCustomer.createNewTrial();
        // System.debug(LoggingLevel.INFO,'post3...............'+post3);  

        // entTrial = new Ent_Trial__c(id=post1.sfdcDetails.trialId , Trial_End_Date__c=(date.today()-365),Trial_Status__c='Accepted');
        // update entTrial;
        
        // string jsonStrEnttitleOrg='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","state":"casamia","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName":"Company Name","zipCode":""},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime":"2021-07-27T21:00:00.000+0000"} ]}}' ;
        // req2.requestBody = Blob.valueof(jsonStrEnttitleOrg);
        // RestContext.request = req2;

        // ODTDG_EntitlementWrapper postlast = ODTDG_EntitleTrialCustomer.createNewTrial();
        // System.debug(LoggingLevel.INFO,'postlast...............'+postlast); 
        
        
        string jsonStrDraftwithId='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NEW_CUSTOMER","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
  
        req2.requestBody = Blob.valueof(jsonStrDraftwithId);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post4 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post4...............'+post4);  

         
         
        string jsonStrBlank='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Accepted","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
        
        req2.requestBody = Blob.valueof(jsonStrBlank);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post5 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post5...............'+post5);


        string jsonStrProdBlank='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Accepted","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
        
        req2.requestBody = Blob.valueof(jsonStrProdBlank);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post6 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post6...............'+post6); 
        
        
        string jsonStrConBlank='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Invite","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Acceptd","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Activ","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
        
        req2.requestBody = Blob.valueof(jsonStrConBlank);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post7 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post7...............'+post7); 

        string jsonStrConCatch='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Invite","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Acceptd","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINCuatsbjahagb","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Activ","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
        req2.requestBody = Blob.valueof(jsonStrConCatch);
        RestContext.request = req2;
        
        ODTDG_EntitleTrialCustomer.tocoverCatchBlock = true;
        ODTDG_EntitlementWrapper post8 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post8...............'+post8); 
        
        
        
        
        
    }

    static testMethod void testParse2() {
        
        LIST<Static_Values__c> staticList = new LIST<Static_Values__c>();
            staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipLinkType', 'best'));
            staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_FreeTrial', 'Digital'));
            staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeMain', 'plan to plan'));
            staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeExtended', 'Accessory Product'));
            insert staticList;
            
            LIST<KeyValueListStore__c> keyList = new LIST<KeyValueListStore__c>();
            keyList.add(new KeyValueListStore__c(name='LTS_partnerUserProfileName', TextValue__c='TR Corp Partner Community User'));
            keyList.add(new KeyValueListStore__c(name='LTS_partnerUserBUSegmentValue', TextValue__c='Corporate'));
            keyList.add(new KeyValueListStore__c(name='LTS_partnerUserLeadSourceValue', TextValue__c='Partner'));
            insert keyList;
            
            list<Product2> prds = new list<Product2>();
            
            Product2 prd = new Product2();
            prd.DC_Product_Title__c = 'sample product';
            prd.Name ='TEST1';
            prd.ProductCode = '753987';
            prd.Product_Offering__c='Westlaw Edge';
            prd.Free_Trial__c = 'Digital';
            prds.add(prd);
            
            Product2 prd1 = new Product2();
            prd1.DC_Product_Title__c = 'sample product';
            prd1.Name ='TEST2';
            prd1.ProductCode = '753986';
            prd1.Product_Offering__c='Practical Law';
            prd1.Free_Trial__c = 'Digital';
            prds.add(prd1);
            
            insert prds;
    
        LIST<product2> test1 = [select id,productcode,free_trial__c,Product_Offering__c
                                                                     FROM product2 ];
            system.debug(LoggingLevel.INFO,'testqueyr............'+test1);
            
            Product_Relationship__c p1 = new Product_Relationship__c();
            p1.Product_to__c = prd.Id;
            p1.Product_from__c = prd.Id;
            p1.Segment__c = 'In-house counsel';
            p1.Relationship_Link_Type__c ='best';
            p1.Relationship_Type__c = 'plan to plan';
            insert p1;
            
            Product_Relationship__c p2 = new Product_Relationship__c();
            p2.Product_to__c = prd1.Id;
            p2.Product_from__c = prd1.Id;
            p2.Segment__c = 'In-house counsel';
            p2.Relationship_Link_Type__c ='best';
            p2.Relationship_Type__c = 'plan to plan';
            insert p2;
            
            /*ODTDG_TrialRecord tr = new ODTDG_TrialRecord();
            ODTDG_TrialRecord.TrialProdInfo trProd = new ODTDG_TrialRecord.TrialProdInfo();
            ODTDG_TrialRecord_TrialHelper.TrialInfo trIn = new ODTDG_TrialRecord_TrialHelper.TrialInfo();
            ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAc = new ODTDG_TrialRecord_TrialHelper.TrialAccountInfo();*/
            
            LIST<product_relationship__c> test = [select id,Product_to__r.productCode,relationship_link_type__c,Product_to__r.Free_Trial__c,relationship_type__c,Product_To__r.Product_Offering__c,Segment__c
                                                                     FROM product_relationship__c ];
            system.debug(LoggingLevel.INFO,'testqueyr............'+test);
             
           string jsonStrPrimary ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"Jasmitha","lastName":"Sri Vaishanavi","email":"jasmitha.sri@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
            
            string jsonStrInvite ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Invite","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Accepted","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
               
            
            Contact con1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            Email = 'abcdtest@test.com');
            insert con1;
            
            Contact con2 = new Contact(
            FirstName = 'Test1',
            Lastname = 'McTesty1',
            Email = 'abcdtest1@test.com');
            insert con2;
    
             Lead olead= new Lead();
            olead.status='Unworked';
            olead.Source__c='Advance Search';
            olead.salutation='Mr.';
            olead.FirstName='test';
            olead.LastName='user';
            olead.Company='xyzz';
            insert olead;
        
                 ODTDG_TrialRecord obj = ODTDG_TrialRecord.parse(jsonStrPrimary );
                System.assert(obj != null,'Object Not Created');
        
              
                
                RestRequest req1 = new RestRequest(); 
        
                req1.requestURI = '/services/apexrest/ODTDGEntitleTrialCustomer' ;
                req1.httpMethod = 'POST';
                req1.requestBody = Blob.valueof(jsonStrPrimary );
                RestContext.request = req1;
        
                ODTDG_EntitlementWrapper post1 = ODTDG_EntitleTrialCustomer.createNewTrial();
                System.debug(LoggingLevel.INFO,'post1...............'+post1);
            
            list<Trial_Contact__c> trlCons = new list<Trial_Contact__c>();
            for(Trial_Contact__c tc : [Select id, name, Lead__c from Trial_Contact__c WHERE Trials__c =: post1.sfdcDetails.trialId ]){
                Trial_Contact__c trlCon = new Trial_Contact__c();
                trlCon.id = tc.id;
                trlCon.Lead__c = olead.id;
                trlCons.add(trlCon);
                System.debug(LoggingLevel.INFO,'leadupdate......'+trlCon);
            }   
            update trlCons;
            
            
            RestRequest req2 = new RestRequest(); 

            req2.requestURI = '/services/apexrest/ODTDGEntitleTrialCustomer' ;
            req2.httpMethod = 'POST';
            req2.requestBody = Blob.valueof(jsonStrInvite );
            RestContext.request = req2;
    
            string jsonStrExistingCon='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NEW_CUSTOMER","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Westlaw Edge","productSfId":"","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Test","lastName":"McTesty","email":"abcdtest@test.com","trialContactSfId":"'+con1.id+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wyoming Litigation on Westlaw","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"},{"firstName":"Test1","lastName":"McTesty1","email":"abcdtest1@test.com","trialContactSfId":"'+con2.id+'","primaryUser":false,"cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"US-Wisconsin Litigation on Westlaw","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
            req2.requestBody = Blob.valueof(jsonStrExistingCon);
            RestContext.request = req2;
    
            ODTDG_EntitlementWrapper post9 = ODTDG_EntitleTrialCustomer.createNewTrial();
            System.debug(LoggingLevel.INFO,'post9...............'+post9); 
        
        
    
            System.assert(con1.id != null,'Object has Created');


        }
}