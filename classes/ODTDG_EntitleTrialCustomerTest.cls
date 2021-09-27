@IsTest(seeAllData=false)
public with sharing class ODTDG_EntitleTrialCustomerTest {
    
    @isTest static void testParse() {
        
    	LIST<Static_Values__c> staticList = new LIST<Static_Values__c>();
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipLinkType', 'best'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_FreeTrial', 'Digital'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeMain', 'plan to plan'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeExtended', 'Accessory Product'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('LeadSupportEmail', 'support@test.com'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_ProductJuridisctions', 'General;'));
        
        insert staticList;
        
        LIST<KeyValueListStore__c> keyList = new LIST<KeyValueListStore__c>();
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserProfileName', TextValue__c='TR Corp Partner Community User'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserBUSegmentValue', TextValue__c='Corporate'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserLeadSourceValue', TextValue__c='Partner'));
        insert keyList;
        
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore';
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
        
        Source_System_Detail__c ssd = new Source_System_Detail__c();
		ssd.Name = 'TestSsd';
        ssd.Source_System_Name__c = 'TestSsd';
        ssd.Source_System_Account_Number__c = '100785647';
        ssd.Account_Name__c=acc.id;
		insert ssd;
        
        
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
        prd1.Apttus_Filter_Jurisdiction__c = 'casamia';
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
        
      
        Product2Addon__c ad = new Product2Addon__c();
        ad.Addon_Product_Code__c = '753986';
        ad.Product2__c = prd1.Id;
        insert ad;
        
        Country_Region__c  stateTest = new Country_Region__c(Name='US-AA', Country_Code__c='US',Region_Code__c='AA', Region_Name__c='Armed Forces US', IsActive__c =true);
        insert stateTest;
        
        ODTDG_TrialRecord_ContactHelper tch = new ODTDG_TrialRecord_ContactHelper();
        system.debug(LoggingLevel.INFO,'conthelper'+tch);
        
        /*ODTDG_TrialRecord tr = new ODTDG_TrialRecord();
        ODTDG_TrialRecord.TrialProdInfo trProd = new ODTDG_TrialRecord.TrialProdInfo();
        ODTDG_TrialRecord_TrialHelper.TrialInfo trIn = new ODTDG_TrialRecord_TrialHelper.TrialInfo();
        ODTDG_TrialRecord_TrialHelper.TrialAccountInfo trAc = new ODTDG_TrialRecord_TrialHelper.TrialAccountInfo();*/
        
        LIST<product_relationship__c> test = [select id,Product_to__r.productCode,relationship_link_type__c,Product_to__r.Free_Trial__c,relationship_type__c,Product_To__r.Product_Offering__c,Segment__c
                                                                 FROM product_relationship__c ];
        system.debug(LoggingLevel.INFO,'testqueyr............'+test);
         
        string jsonStrPrimary ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"100785647","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"Armed Forces US","accountNumSource":"SAP","customerSegment":"In-house counsel","customerSegmentValue":"Law-1-6","accountName": "","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null}]}}' ;
        string jsonStrWrongProduct ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"casamia","accountNumSource":"SAP","customerSegment":"In-house counsl","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practial Law","productSfId":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"}]}}' ;
       
       
        ODTDG_TrialRecord obj = ODTDG_TrialRecord.parse(jsonStrPrimary );
        System.assert(obj != null,'Object Not Created');

      
         
        RestRequest req1 = new RestRequest(); 

        req1.requestURI = '/services/apexrest/ODTDGTrialInitiationService' ;
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(jsonStrPrimary );
        RestContext.request = req1;

        ODTDG_EntitlementWrapper post1 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post1...............'+post1);
        
        
        
        Ent_Trial__c entTrial = new Ent_Trial__c(id=post1.sfdcDetails.trialId , Trial_Status__c='Active');
        update entTrial;
        
               
        string jsonStrInvite ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Invite","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"'+post1.sfdcDetails.trialId+'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"casamia","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Active","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null},{"firstName":"JasmithaINC","lastName":"Sri VaishanaviINC","email":"jasmitha.sriINC@mailinator.com","trialContactSfId":"","primaryUser":false,"businessPhone": "09887765443","cobaltGUID":"Wisconsin Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOugajskgdj","contactNumber":"0007654645","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"jasmitha.srINCINC@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" :null}]}}' ;
        
        RestRequest req2 = new RestRequest(); 

        req2.requestURI = '/services/apexrest/ODTDGTrialInitiationService' ;
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueof(jsonStrInvite );
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post2 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post2...............'+post2); 
        
        LIST<Ent_Trial__c> trialDetails = new LIST<Ent_Trial__c>();
        trialDetails = [SELECT id, name, Account_Name__c, Account__c ,(SELECT id, Name FROM Trial_Contacts__r), (SELECT id, name FROM Trial_Products1__r) FROM Ent_Trial__c WHERE ID =: entTrial.id];
        
        string prodId='';
        string contId='';
        
        for(Ent_Trial__c ent: trialDetails ){
            //System.debug(LoggingLevel.INFO,'DCP Trial Account Name>>>'+ent.Account_Name__c);
        	//System.debug(LoggingLevel.INFO,'DCP Trial Account Id>>>'+ent.Account__c);
            for(Trial_Product__c tp: ent.Trial_Products1__r){
                prodId = tp.id;
             }
             
             for(Trial_Contact__c cp: ent.Trial_Contacts__r){
                contId = cp.id;
             }
             
        }
        
        
        //string jsonStrEnttitle='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"100785647","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel"},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'","trialProductNumber":"753987"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89"} ]}}' ;
        string jsonStrEnttitle='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Entitle","campaignCode":"","trialStartDate":"06/16/2021","trialDuration":7,"trialProfileType":"NCJ","trialSfId":"'+ post1.sfdcDetails.trialId +'","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","state":"casamia","countryCode":"US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName":"Company Name","zipCode":""},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":"'+prodId+'"}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"'+contId+'","primaryUser":true,"cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Entitle","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime":"2021-07-27T21:00:00.000+0000"} ]}}' ;
        req2.requestBody = Blob.valueof(jsonStrEnttitle);
        RestContext.request = req2;

        ODTDG_EntitlementWrapper post3 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post3...............'+post3);  

        
        
        
        ODTDG_TrialRecord obj1 = ODTDG_TrialRecord.parse(jsonStrWrongProduct);
        System.assert(obj1 != null,'Object Not Created');
        
        RestRequest req0 = new RestRequest(); 

        req0.requestURI = '/services/apexrest/ODTDGTrialInitiationService' ;
        req0.httpMethod = 'POST';
        req0.requestBody = Blob.valueof(jsonStrWrongProduct);
        RestContext.request = req0;

        ODTDG_EntitlementWrapper post0 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post0...............'+post0);
        
        string jsonStrPrimaryNoAcc ='{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"Armed Forces US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "tcs","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Mallikarjuna1","lastName":"Rao1","email":"mallik.rao1@mailinator.com","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null}]}}' ;
        RestRequest req3 = new RestRequest(); 
        req3.requestURI = '/services/apexrest/ODTDGTrialInitiationService' ;
        req3.httpMethod = 'POST';
        req3.requestBody = Blob.valueof(jsonStrPrimaryNoAcc );
        RestContext.request = req3;

        ODTDG_EntitlementWrapper post4 = ODTDG_EntitleTrialCustomer.createNewTrial();
        System.debug(LoggingLevel.INFO,'post4...............'+post4);
        
        ODTDG_EntitleTrialCustomerServiceHelper.getContactFunctionValue('Law Firm');
        ODTDG_EntitleTrialCustomerServiceHelper.getcustomerSegmentValue('Law Firm');

        }
    
    /*added by Sameeksha for testing DCP-4538 User story*/
    @isTest static void testParse2() {
        ODTDG_TrialRecord_TrialHelper.TrialInfo cdtest = new ODTDG_TrialRecord_TrialHelper.TrialInfo();
        ODTDG_TrialRecord_TrialHelper.TrialAccountInfo cdtest1 = new ODTDG_TrialRecord_TrialHelper.TrialAccountInfo();
        system.debug(LoggingLevel.INFO,'testqueyr............'+cdtest+'-'+cdtest1); 
    	LIST<Static_Values__c> staticList = new LIST<Static_Values__c>();
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipLinkType', 'best'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_FreeTrial', 'Digital'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeMain', 'plan to plan'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_RelationshipTypeExtended', 'Accessory Product'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('LeadSupportEmail', 'support@test.com'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_ProductJuridisctions', 'General;'));
        staticList.add(ODTDG_TestFactory.staticCustomSetting('ODTDG_law-1-6', 'FLS;'));
        insert staticList;
        
        LIST<KeyValueListStore__c> keyList = new LIST<KeyValueListStore__c>();
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserProfileName', TextValue__c='TR Corp Partner Community User'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserBUSegmentValue', TextValue__c='Corporate'));
        keyList.add(new KeyValueListStore__c(name='LTS_partnerUserLeadSourceValue', TextValue__c='Partner'));
        insert keyList;
        
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore';
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        insert acc;
        System.assert(acc.name != null,'test');
        
        Source_System_Detail__c ssd = new Source_System_Detail__c();
		ssd.Name = 'TestSsd';
        ssd.Source_System_Name__c = 'TestSsd';
        ssd.Source_System_Account_Number__c = '100785647';
        ssd.Account_Name__c=acc.id;
		insert ssd;
        
        
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
        prd1.Apttus_Filter_Jurisdiction__c = 'casamia';
        prds.add(prd1);
        
        insert prds;

    	
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
        
      
        Product2Addon__c ad = new Product2Addon__c();
        ad.Addon_Product_Code__c = '753986';
        ad.Product2__c = prd1.Id;
        insert ad;
        
        Country_Region__c  stateTest = new Country_Region__c(Name='US-AA', Country_Code__c='US',Region_Code__c='AA', Region_Name__c='Armed Forces US', IsActive__c =true);
        insert stateTest;
        
        ODTDG_TrialRecord_ContactHelper tch = new ODTDG_TrialRecord_ContactHelper();
        system.debug(LoggingLevel.INFO,'conthelper'+tch);
        
        LIST<product_relationship__c> test = [select id,Product_to__r.productCode,relationship_link_type__c,Product_to__r.Free_Trial__c,relationship_type__c,Product_To__r.Product_Offering__c,Segment__c
                                                                 FROM product_relationship__c ];
        system.debug(LoggingLevel.INFO,'testqueyr............'+test);        
        string trialReq = '{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"1007856471","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"Armed Forces US","accountNumSource":"SAP","customerSegment":"In-house counsel","customerSegmentValue":"Law-1-6","accountName": "","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Sameeksha","lastName":"Sharma","email":"sameeksha@gmailll.com","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null}]}}' ;
        string trialReqCatch = '{"odtdgTrialDetails":{"trialInfo":{"trialStatus":"Draft","campaignCode":null,"trialStartDate":"06/16/2021","trialDuration":14,"trialProfileType":"NEW_CUSTOMER","trialSfId":"","trialSource":"Digital"},"trialAccountInfo":{"accountNumber":"1007856471","isLapsed":true,"lapsedReasonCode":"25","countryCode":"US","state":"Armed Forces US","accountNumSource":"SAP","customerSegment":"In-house counsel","accountName": "","zipCode": null},"trialProdInfo":[{"productOffering":"Practical Law","productSfId":""}],"trialContacts":[{"firstName":"Sameeksha","lastName":"Sharma","email":"","trialContactSfId":"","primaryUser":true,"businessPhone": "8765543657646","cobaltGUID":"Wyoming Litigation on Westlaw","dataroomGUID":"","userAuthId":"HAFHKJHFKJJAHSGHQIHFUQWHUFOuiof","contactNumber":"0007654635","contactNumSource":"SAP","trialStatus":"Draft","trialContactUniqueName":"mallik.rao1@mailinator.com 13/06/2021 19:47:16:89","trialAcceptanceDateTime" : null}]}}' ;
        
        RestRequest trialreq1 = new RestRequest(); 

        trialreq1.requestURI = '/services/apexrest/ODTDGTrialInitiationService' ;
        trialreq1.httpMethod = 'POST';
        trialreq1.requestBody = Blob.valueof(trialReq);
        RestContext.request = trialreq1;

        ODTDG_EntitlementWrapper trialpost1 = ODTDG_EntitleTrialCustomer.createNewTrial();
        
        Ent_Trial__c trialEntTrial = new Ent_Trial__c(id=trialpost1.sfdcDetails.trialId , Trial_Status__c='Active');
        update trialEntTrial;
                 
        //to cover catch block
        RestRequest trialreq2 = new RestRequest(); 

        trialreq2.requestURI = '/services/apexrest/ODTDGTrialInitiationService' ;
        trialreq2.httpMethod = 'POST';
        trialreq2.requestBody = Blob.valueof(trialReqCatch);
        RestContext.request = trialreq2;

        ODTDG_EntitlementWrapper trialpost2 = ODTDG_EntitleTrialCustomer.createNewTrial();
        
        Ent_Trial__c trialEntTrial2 = new Ent_Trial__c(id=trialpost2.sfdcDetails.trialId , Trial_Status__c='Active');
        update trialEntTrial2;
        
        
        LIST<Ent_Trial__c> trialDetails = new LIST<Ent_Trial__c>();
        trialDetails = [SELECT id, name, Account_Name__c, Account__c ,(SELECT id, Name FROM Trial_Contacts__r), (SELECT id, name FROM Trial_Products1__r) FROM Ent_Trial__c WHERE ID =:trialEntTrial.id OR ID = :trialEntTrial2.id];
       
        for(Ent_Trial__c ent: trialDetails ){
            System.debug(LoggingLevel.INFO,'DCP Trial Account Name>>>'+ent.Account_Name__c);
        	System.debug(LoggingLevel.INFO,'DCP Trial Account Id>>>'+ent.Account__c);
        }   
    }
}