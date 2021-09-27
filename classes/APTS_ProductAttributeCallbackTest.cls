@isTest
private class APTS_ProductAttributeCallbackTest 
{
    private static final string USL_RECORDTPYE='USL_Source_Systems';
    @isTest static void testMethodOne()
    { 
    // New Change
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User TaxUser=new User(username='testuser23corp@acme.com',
        lastname='testuser',
        Alias='testuser',
        Email='testuser@tcs.com',
        Sub_Bu__c='US',
        TimeZoneSidKey = 'GMT',
        ProfileId = profileId.id,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        Segment__c = 'Professional Tax');
        insert TaxUser;
           
            Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
            insert priceList;
      System.assertEquals( 'Thomson Reuters Master - US Legal',priceList.Name,'Success');
            
            Schema.DescribeFieldResult fieldResultMarket = Apttus_Config2__ProductConfiguration__c.APTS_AccountMirror_Picklist__c.getDescribe();
            String valueMarket = fieldResultMarket.getPicklistValues().get(0).getValue();
            
            List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
            KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
            keyvaluestore.Name='ANZUsersProfileId';
            keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
            
            KeyValueListStore__c LCRMStrikeIronFlagINS2 = new KeyValueListStore__c();
            LCRMStrikeIronFlagINS2.Name='LCRMDisableStrikeIronServices';
            LCRMStrikeIronFlagINS2.TextValue__c='True';
            keyvaluestoreList.add(LCRMStrikeIronFlagINS2 );
            keyvaluestoreList.add(keyvaluestore);
            
            KeyValueListStore__c keyval2 = new KeyValueListStore__c();
            keyval2.Name='ReasonWithCompetitor';
            keyval2.TextValue__c='Price';
            keyvaluestoreList.add(keyval2);
            
            insert keyvaluestoreList;
            
            List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
            
            RecordtypeIds__c recordtype=new RecordtypeIds__c();
            recordtype.Name='Pre-Pipeline Opportunities';
            recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
            recordlist.add(recordtype);
            
            RecordtypeIds__c recordtype1=new RecordtypeIds__c();
            recordtype1.Name='Pipeline Opportunities';
            recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
            recordlist.add(recordtype1);
            insert recordlist;
          
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
            insert a;
            Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
            
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=a.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.LCRM_Frozen_Market_Segment__c = valueMarket;
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='S100';
            accountSSD.Billing_Currency__c = 'USD';
            insert accountSSD;
            
           
          // System.runAs(u1){ 
           
           Date todaysDate = system.today();
           Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
           List<Opportunity> oppList = new List<Opportunity>();
           Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId, Name='tst-opp1', stagename='Appointment Scheduled',closedate=todaysDate,forecastcategoryname='pipeline',accountId=a.id,Source_System_Detail__c=accountSSD.Id);
           oppList.add(o);
           
           insert oppList;
            
            Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            
           List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
           List<Apttus_Proposal__Proposal__c> updatepropList = new List<Apttus_Proposal__Proposal__c>();
           
           Apttus_Proposal__Proposal__c prop1 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,Apttus_Proposal__Primary__c =true,
                Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Account__c=a.id,
                APTS_SSD_Sold_To__c = accountSSD.Id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote',
                 /*Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,*/APTS_Proposal_Business_Unit__c = 'Tax Professional',
                 APTS_Approval_Segment__c='Government', Apttus_QPConfig__PriceListId__c=priceList.id);
                 insert prop1;
            
            List<Apttus_Config2__ProductConfiguration__c> confList = new List<Apttus_Config2__ProductConfiguration__c>();
            Apttus_Config2__ProductConfiguration__c conf=new Apttus_Config2__ProductConfiguration__c(
            Name='ABC', Apttus_QPConfig__Proposald__c=prop1.id,
            Apttus_Config2__Status__c='Finalized',Apttus_Config2__PriceListId__c=priceList.id);
            //confList.add(conf);
            insert conf;
            ID cartID = conf.Id;
        
            List<Product2> prodList = new List<Product2>();
            Product2 prod1=new Product2(Name='TEst1', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC1');
            prodList.add(prod1);
            
            Product2 prod2=new Product2(Name='TEst2', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC2');
            prodList.add(prod2);
            
            Product2 prod3=new Product2(Name='TEst3', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC3');
            prodList.add(prod3);
            
            Product2 prod4=new Product2(Name='TEst4', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC4');
            prodList.add(prod4);
            
            Product2 prod5=new Product2(Name='TEst5', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC5');
            prodList.add(prod5);
            
            Product2 prod6=new Product2(Name='TEst6', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC6');
            prodList.add(prod6);
            
            Product2 prod7=new Product2(Name='TEst7', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC7');
            prodList.add(prod7);
            
            Product2 prod8=new Product2(Name='TEst8', IsActive=true, Apttus_Config2__ConfigurationType__c='standalone', APTS_Eligibility_All__c=true,
            ProductCode='ABC8');
            prodList.add(prod8);
            
            
            Product2 prod9=new Product2(Name='TEst9', IsActive=true, Apttus_Config2__ConfigurationType__c='Bundle', APTS_Eligibility_All__c=true,
            ProductCode='ABC9', Apttus_Config2__HasOptions__c = True );
            prodList.add(prod9);
            
            insert prodList;
            
            List<APTS_Product_Variant__c> pvList = new List<APTS_Product_Variant__c>();
            APTS_Product_Variant__c pv1=new APTS_Product_Variant__c(Name='PV1',APTS_Product_Delivery__c='Download',APTS_Product__c=prod1.id,APTS_Product_ID__c=prod1.ProductCode,APTS_Product_Variant_ID__c='PV1', CurrencyIsoCode = 'USD' );
            pvList.add(pv1);
            APTS_Product_Variant__c pv2=new APTS_Product_Variant__c(Name='PV2',APTS_Product_Delivery__c='eBook',APTS_Product__c=prod2.id,APTS_Product_ID__c=prod2.ProductCode,APTS_Product_Variant_ID__c='PV2', CurrencyIsoCode = 'USD');
            pvList.add(pv2);
            APTS_Product_Variant__c pv3=new APTS_Product_Variant__c(Name='PV3',APTS_Product_Delivery__c='e-Flex',APTS_Product__c=prod3.id,APTS_Product_ID__c=prod3.ProductCode,APTS_Product_Variant_ID__c='PV3', CurrencyIsoCode = 'USD');
            pvList.add(pv3);
            APTS_Product_Variant__c pv4=new APTS_Product_Variant__c(Name='PV4',APTS_Product_Delivery__c='HTML',APTS_Product__c=prod4.id,APTS_Product_ID__c=prod4.ProductCode,APTS_Product_Variant_ID__c='PV4', CurrencyIsoCode = 'USD');
            pvList.add(pv4);
            APTS_Product_Variant__c pv5=new APTS_Product_Variant__c(Name='PV5',APTS_Product_Delivery__c='Online/Internet',APTS_Product__c=prod5.id,APTS_Product_ID__c=prod5.ProductCode,APTS_Product_Variant_ID__c='PV5', CurrencyIsoCode = 'USD');
            pvList.add(pv5);
            APTS_Product_Variant__c pv6=new APTS_Product_Variant__c(Name='PV6',APTS_Product_Delivery__c='PDF',APTS_Product__c=prod6.id,APTS_Product_ID__c=prod6.ProductCode,APTS_Product_Variant_ID__c='PV6', CurrencyIsoCode = 'USD');
            pvList.add(pv6);
            APTS_Product_Variant__c pv7=new APTS_Product_Variant__c(Name='PV7',APTS_Product_Delivery__c='Softbound',APTS_Product__c=prod7.id,APTS_Product_ID__c=prod7.ProductCode,APTS_Product_Variant_ID__c='PV7', CurrencyIsoCode = 'USD');
            pvList.add(pv7);
            APTS_Product_Variant__c pv9=new APTS_Product_Variant__c(Name='PV9',APTS_Product_Delivery__c='Online/Internet',APTS_Product__c=prod9.id,APTS_Product_ID__c=prod9.ProductCode,APTS_Product_Variant_ID__c='PV9', CurrencyIsoCode = 'USD');
            pvList.add(pv9);
            insert pvList;
            
            APTS_Bundle_Variant__c bv = new APTS_Bundle_Variant__c(Name = 'ABC9', CurrencyIsoCode = 'USD', APTS_Component_Product_EPMID__c = 'PV9', APTS_Bundle_Product_Delivery__c = 'Bundle', APTS_Component_Product_Delivery__c = 'Online/Internet');
            insert bv;
            
            List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
            
            Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod1.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem1);
            //insert lineItem;
            
            Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod2.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem2);
            
            Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod3.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem3);
            
            Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod4.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem4);
            
            Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod5.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem5);
            
            Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod6.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem6);
            
            Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod7.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem7);
            
            Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod8.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1);
            liList.add(lineItem8);
            
            Apttus_Config2__LineItem__c lineItem9=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=conf.id,Apttus_Config2__LineType__c='Product/Service',Apttus_Config2__ProductId__c=prod9.id, 
            Apttus_Config2__PriceListId__c=priceList.id, Apttus_Config2__ItemSequence__c = 1, Apttus_Config2__LineNumber__c = 1, Apttus_Config2__HasOptions__c = True);
            liList.add(lineItem9);
            
            insert liList;
            
            List<Apttus_Config2__ProductAttributeValue__c> pavList= new List<Apttus_Config2__ProductAttributeValue__c>();
            
            Apttus_Config2__ProductAttributeValue__c pav1=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem1.id,Tax_Prof_Download__c='Download');
            pavList.add(pav1);
            
            Apttus_Config2__ProductAttributeValue__c pav2=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem2.id,Tax_Prof_eBook__c='eBook');
            pavList.add(pav2);
            
            Apttus_Config2__ProductAttributeValue__c pav3=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem3.id,Tax_Prof_e_Flex__c='e-Flex');
            pavList.add(pav3);
            
            Apttus_Config2__ProductAttributeValue__c pav4=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem4.id,Tax_Prof_HTML__c='HTML');
            pavList.add(pav4);
            
            Apttus_Config2__ProductAttributeValue__c pav5=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem5.id,Tax_Prof_Product_Delivery_Online_Intern__c='Online/Internet');
            pavList.add(pav5);
            
            Apttus_Config2__ProductAttributeValue__c pav6=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem6.id,Tax_Prof_PDF__c='PDF');
            pavList.add(pav6);
            
            Apttus_Config2__ProductAttributeValue__c pav7=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem7.id,Tax_Prof_Softbound__c='Softbound');
            pavList.add(pav7);
            
            Apttus_Config2__ProductAttributeValue__c pav8=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem8.id,Tax_Prof_Download__c='Download');
            pavList.add(pav8);
            
            Apttus_Config2__ProductAttributeValue__c pav9=new Apttus_Config2__ProductAttributeValue__c(Apttus_Config2__LineItemId__c= lineItem9.id,Tax_Prof_Product_Delivery_Online_Intern__c='Online/Internet');
            pavList.add(pav9);
            
            if(pavList!= null){
                insert pavList;                
            }
            System.runAs(Taxuser){
            Test.startTest();
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem9, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem8, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem7, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem6, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem4, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem3, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem2, new APTS_ProductAttributeCallback());
            Apttus_Config2.CallbackTester.testProductAttributeCallback( cartID, lineItem1, new APTS_ProductAttributeCallback());
            Test.stopTest();
            }
    }      
    }