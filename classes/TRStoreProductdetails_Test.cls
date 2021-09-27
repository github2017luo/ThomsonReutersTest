@isTest(seeAllData=false)
public class TRStoreProductdetails_Test{

    
     public static testMethod void testData(){
         
         LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='TRStorePELeadConvertCode', value__c='LeadConvert'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c='OrderConfirmation'),
            new Static_Values__c(name='TRStorePricelistUS', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='sellableFlagValues' , value__c='Display and Sell'),
            new Static_Values__c(name='Bundle_ChildFormatName' , value__c='Formats'),
            new Static_Values__c(name='Bundle_ParentFormatName' , value__c='Bundle Specifications'),
            new Static_Values__c(name='Bundle_ChildBundleType' , value__c='Child'),
            new Static_Values__c(name='Bundle_ParentBundleType' , value__c='Parent'),
            new Static_Values__c(name='Bundle_BaseBundleType' , value__c='Landing Product'),
            new Static_Values__c(name='TRStoreCollateral' , value__c='Release note'),
            new Static_Values__c(name='TRStoreFeaturesToExclude' , value__c='Release Note'),
            new Static_Values__c(name='TRStoreFeatureSetToInclude' , value__c='Formats'),
            new Static_Values__c(name='Release Note' , value__c='Release note'),
            new Static_Values__c(name='Index' , value__c='Index'),
            new Static_Values__c(name='Table of Contents' , value__c='Table of contents')};
            
            
        insert staticCSList;
         
         
         list<product2> products = new LIST<product2>();
         
         
         product2 pd1 = new product2();
         pd1.Name = 'Test Product';
         pd1.ProductCode = '98765';
         pd1.Description = 'Test Desc';
         pd1.Service_Number__c = '87654';
         pd1.Product_Offering__c = 'Test';
         pd1.Apttus_Filter_Jurisdiction__c = 'Colorado';
         pd1.Format__c= 'Format';
         pd1.IsActive = true;
         pd1.CPD_Sellable_Description__c ='Display and Sell';
         products.add(pd1);
         
         product2 pd2 = new product2();
         pd2.Name = 'Test Product';
         pd2.ProductCode = '987654';
         pd2.Description = 'Test Desc';
         //pd2.Service_Number__c = '876543';
         //pd2.Product_Offering__c = ''
         //pd2.Apttus_Filter_Jurisdiction__c = 'test Jurisdiction';
         //pd2.Format__c= 'Format';
         pd2.CPD_Sellable_Description__c ='Display and Sell';
         pd2.IsActive = true;
         
          products.add(pd2);
          
          
         LIST<database.saveResult> pdres = database.insert(products, false);
         system.debug('products Result'+pdres);
         
         Product_Author__c pa1 = new Product_Author__c();
         pa1.Author_ID__c = '1';
         pa1.Name= 'Test Author one';
         pa1.Author_Biography__c = 'Biography of Author one';         
         database.insert(pa1,true);
         
         Product_Author_Value__c pav1 = new Product_Author_Value__c();
         pav1.Product_AuthorId__c = pa1.Id;
         pav1.ProductId__c = products[1].Id;
         pav1.Display_Order__c = 1;
         database.insert(pav1,true);
         
         Product_Author__c pa2 = new Product_Author__c();
         pa2.Author_ID__c = '2';
         pa2.Name= 'Test Author two';
         pa2.Author_Biography__c = 'Biography of Author two';         
         database.insert(pa2,true);
         
         Product_Author_Value__c pav2 = new Product_Author_Value__c();
         pav2.Product_AuthorId__c = pa2.Id;
         pav2.ProductId__c = products[1].Id;
         
         database.insert(pav2,true);
         
          Apttus_Config2__FeatureSet__c pfs = new Apttus_Config2__FeatureSet__c();
          pfs.Apttus_Config2__Sequence__c = 1;
          pfs.Apttus_Config2__Description__c = 'NT Test';
          pfs.name = 'Formats';
          insert pfs;
          
          Apttus_Config2__Feature__c pf =  new Apttus_Config2__Feature__c();
          pf.name = 'test feature';
          pf.Apttus_Config2__FeatureSetId__c = pfs.id;
          pf.Apttus_Config2__Sequence__c = 1;
          insert pf;
          
          
          Apttus_Config2__ProductFeatureValue__c pfv = new Apttus_Config2__ProductFeatureValue__c();
          pfv.Apttus_Config2__Value__c = 'test';
          pfv.Apttus_Config2__FeatureId__c = pf.id;
          pfv.Apttus_Config2__ProductId__c = pd2.id;
          insert pfv;
         
          Product_Collateral__c pColl = new Product_Collateral__c();
          pColl.Collateral_Title__c = 'Release note';
          pColl.Collateral_Path__c = 'tespath';
          pColl.Collateral_Type__c = 'Release note';
          insert pColl;
         
          Product_Collateral_Value__c pCollValue = new Product_Collateral_Value__c();
          pCollValue.Product_Collateral__c = pColl.id;
          pCollValue.Product__c = pd2.id;
          insert pCollValue;
          
          Apttus_Config2__ProductTranslation__c pt = new Apttus_Config2__ProductTranslation__c();
          pt.name = 'testval';
          pt.Apttus_Config2__ProductId__c = pd2.id;
          pt.Apttus_Config2__Language__c = 'French';
          insert pt;
          
          Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
          insert plSO;
        
          LIST<Apttus_Config2__PriceListItem__c> plList = new list<Apttus_Config2__PriceListItem__c>();
          
          Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO.Apttus_Config2__ProductId__c = pd1.id;
          pliSO.Apttus_Config2__PriceType__c = 'One time';
          pliSO.Apttus_Config2__Frequency__c = 'One time';
          pliSO.Apttus_Config2__ListPrice__c = 250;
          
          
          plList.add(pliSO);
          
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__ChargeType__c = 'MRC';
          pliSO2.Apttus_Config2__PriceListId__c = plSO.Id;
          pliSO2.Apttus_Config2__ProductId__c = pd2.id;
          pliSO2.Apttus_Config2__PriceType__c = 'One time';
          pliSO2.Apttus_Config2__Frequency__c = 'One time';
          pliSO2.Apttus_Config2__ListPrice__c = 250;
          
          plList.add(pliSO2);
           
         database.insert(plList, false); 
         
         
         RestRequest req = new RestRequest();
         req.params.put('pCode','98765');
         req.params.put('country','US');
         req.params.put('lang','en');
         
         req.requestURI = '/services/apexrest/TRstoreProductDetail';  //Request URL
         req.httpMethod = 'GET';//HTTP Request Type
         RestContext.request = req;
         
        // TRStoreProductdetails.productDetails();
         TRStoreProductdetails.doGet();
         
         RestRequest req2 = new RestRequest();
         req2.params.put('pCode','987654');
         req2.params.put('country','US');
         req2.params.put('lang','fr');
         req2.requestURI = '/services/apexrest/TRstoreProductDetail';  //Request URL
         req2.httpMethod = 'GET';//HTTP Request Type
         RestContext.request = req2;
         
         //TRStoreProductdetails.productDetails();
         TRStoreProductdetails.doGet();
                 
         RestRequest req3 = new RestRequest();
         req3.params.put('pCode','9876');
         req3.params.put('country','CA');
         req.params.put('lang','en');
         
         req3.requestURI = '/services/apexrest/TRstoreProductDetail';  //Request URL
         req3.httpMethod = 'GET';//HTTP Request Type
         RestContext.request = req3;
         
         //TRStoreProductdetails.productDetails();
         TRStoreProductdetails.doGet();
         
         RestRequest req4 = new RestRequest();
         req4.params.put('pCode','9876');
		 req.params.put('lang','en');          
         req4.requestURI = '/services/apexrest/TRstoreProductDetail';  //Request URL
         req4.httpMethod = 'GET';//HTTP Request Type
         RestContext.request = req4;
         
         TRStoreproductDetailsService.ProductWrapper resp = TRStoreProductdetails.doGet();
         System.assertNotEquals(null,resp);
         
     }
    
}