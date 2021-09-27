@isTest(seeAllData=false)
public class TRStore_CreateProductJsonBatchTest{

      public static testMethod void testData(){
          
           LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='SubBUCountryList', value__c='Canada'),
            new Static_Values__c(name='TRStoreSupportedPricelists', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='TRStorePEOrderConfirmationCode', value__c='OrderConfirmation'),
            new Static_Values__c(name='mediaHighLevelCodes', value__c='07,21'),
            new Static_Values__c(name='sellableFlagValues' , value__c='Display and Sell'),
            new Static_Values__c(name='TRStoreFeaturesToExclude' , value__c='Table of content,IndexFileName,ReleaseFileName,IndexNote,ReleaseNote,TOCFileName'),
            new Static_Values__c(name='TRStoreFeatureSetToInclude' , value__c='Hardcover Specifications,Microsite Specifications,Formats,Taxcode Specifications,eBook')
            
            
            
            };
            
            
            
           insert staticCSList;
         
          list<product2> products = new LIST<product2>();
         
         
         product2 pd1 = new product2();
         pd1.Name = 'Test Product';
         pd1.ProductCode = '98765';
         pd1.Description = 'Test Desc';
         pd1.Service_Number__c = '87654';
         pd1.Apttus_Filter_Brand__c = 'Test';
         pd1.Apttus_Filter_Jurisdiction__c = 'Colorado';
         pd1.Format__c= 'Format';
         pd1.IsActive = true;
         pd1.CPD_Sellable_Description__c ='Display and Sell';
         pd1.LCRM_Sub_Bu__c ='Canada';
         pd1.APTS_Media_High_Level_Code__c  = '07';
         products.add(pd1);
         
         product2 pd2 = new product2();
         pd2.Name = 'Test Product';
         pd2.ProductCode = '987654';
         pd2.Description = 'Test Desc';
         //pd2.Service_Number__c = '876543';
         //pd2.Apttus_Filter_Brand__c = ''
         //pd2.Apttus_Filter_Jurisdiction__c = 'test Jurisdiction';
         //pd2.Format__c= 'Format';
         pd2.CPD_Sellable_Description__c ='Display and Sell';
         pd2.LCRM_Sub_Bu__c ='Canada';
         pd2.APTS_Media_High_Level_Code__c  = '21';
         pd2.IsActive = true;
         
         // products.add(pd2);
          
          
         LIST<database.saveResult> pdres = database.insert(products, false);
         system.debug('products Result'+pdres);
         
         Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
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
         
          
          TRStore_CreateProductJsonBatch prodBatch = new TRStore_CreateProductJsonBatch();
          prodBatch.execute(null);
          
      }


}