public class TRStore_CreateProductJsonBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    
    //Querythe products from canada Store and send to Execute method
    public Iterable<sObject> start(Database.BatchableContext bc) {
    
    LIST<product2> products  = new LIST<product2>();
    List<String> sellableFlagList= new LIST<string>();
    List<String> mediaHighLevelCode = new List<String>{'21','07','02','08'};
    SET<String> priceListDetails = new SET<string>();
    SET<String> subBuSupportList = new SET<string>();
    
     string countryPriceList;
     string canadasubBu ='Canada';
     
     MAP<string , Static_Values__c> staticValuesMap = new MAP<string, Static_Values__c>();
     staticValuesMap = Static_Values__c.getAll();
     
    if(staticValuesMap.containsKey('sellableFlagValues')){
         String sellableFlag = staticValuesMap.get('sellableFlagValues').value__c;
         sellableFlagList=sellableFlag.split(',');
    }    
    
     if(staticValuesMap.containsKey('TRStoreSupportedPricelists')){
         priceListDetails.addAll(staticValuesMap.get('TRStoreSupportedPricelists').value__c.split(',')); 
     }
     
     if(staticValuesMap.containsKey('SubBUCountryList')){
         subBuSupportList.addAll(staticValuesMap.get('SubBUCountryList').value__c.split(','));
     }
     
     if(staticValuesMap.containsKey('mediaHighLevelCodes')){
         mediaHighLevelCode.addAll(staticValuesMap.get('mediaHighLevelCodes').value__c.split(','));
     }
      
    
    // Query product details based on canada filter conditions 
      if(Schema.sObjectType.product2.isAccessible()) {
      
            products = [SELECT Id, Name, ProductCode, LCRM_Sub_Bu__c, Apttus_Filter_Brand__c ,
                        (SELECT id, name,  Apttus_Config2__PriceListId__c   FROM Apttus_Config2__PriceLists__r where Apttus_Config2__Active__c = true AND Apttus_Config2__PriceListId__r.name =: priceListDetails)
                        From Product2 WHERE (LCRM_Sub_Bu__c IN: subBuSupportList AND APTS_Media_High_Level_Code__c IN: mediaHighLevelCode AND IsActive = true AND CPD_Sellable_Description__c IN: sellableFlagList) AND Id IN (SELECT Apttus_Config2__ProductId__c FROM Apttus_Config2__PriceListItem__c WHERE (Apttus_Config2__ListPrice__c <> NULL AND Apttus_Config2__Active__c = true AND Apttus_Config2__PriceListId__r.name IN: priceListDetails) AND (Apttus_Config2__EffectiveDate__c = NULL OR Apttus_Config2__EffectiveDate__c <= Today) AND (Apttus_Config2__ExpirationDate__c = NULL OR Apttus_Config2__ExpirationDate__c >= Today)) ];
                        
         }
        
        
        
        //String query = 'SELECT ID,ProductCode,Sales_Org__c,LCRM_Sub_Bu__c,(SELECT Id,name from apttus_config2__pricelists__r where Apttus_Config2__PriceListId__r.name = \'Thomson Reuters Master - Canada\' AND apttus_config2__listprice__c <> NULL AND apttus_config2__active__c = true  AND( (apttus_config2__effectivedate__c = NULL OR apttus_config2__effectivedate__c <= today ) AND ( apttus_config2__expirationdate__c = NULL OR apttus_config2__expirationdate__c > today ) ) ) FROM Product2 WHERE Sales_Org__c=\'CARS\' and isActive = true and CPD_Sellable_Description__c <> null and  APTS_Media_High_Level_Code__c IN:mediaHighLevelCode and LCRM_Sub_Bu__c = \'Canada\'  LIMIT 10';
       // return Database.getQueryLocator(query);
       
       return products ;
            
    }
    public void execute(Database.BatchableContext bc, List<Product2> scope){
        List<Product_Detail__c> prodJsonList= new List<Product_Detail__c>();
        
        TRStore_GetPricingDetails.ProductDetails details = new TRStore_GetPricingDetails.ProductDetails();

         //Iterate product record for query and fetch json from TRStore_GetPricingDetails classes
        for (Product2 product : scope) {
            Product_Detail__c prodDetail = new Product_Detail__c();
             id priceListId;
                
                for(Apttus_Config2__PriceListItem__c pli: product.Apttus_Config2__PriceLists__r){
                    if(pli.Apttus_Config2__PriceListId__c != null){
                         priceListId = pli.Apttus_Config2__PriceListId__c ;
                        continue;
                    } 
                }
            
            
                
                prodDetail.Product_Details__c = details.getProductDetails(product.ProductCode,  priceListId);
                
                if(product.Apttus_Filter_Brand__c != null && product.Apttus_Filter_Brand__c == 'Éditions Yvon Blais'){
                     TRStoreProductPricingService.language = 'FR';
                     prodDetail.Product_Details_French__c = details.getProductDetails(product.ProductCode,  priceListId);
                     TRStoreProductPricingService.language = 'EN';
                }
                
                
               /* prodDetail.Product_ID__c = product.Id;
                prodDetail.Product_Code__c = product.ProductCode; */
                prodDetail.Price_List__c = pricelistid;
                prodDetail.Product__c = product.id;
                prodDetail.Product_Code__c = product.ProductCode;
                
                string uniqueKey = product.ProductCode+'-'+ product.id+'-'+pricelistid;
                prodDetail.APTS_Ext_ID__c = uniqueKey ;

            system.debug(loggingLevel.INFO,'Single prod detail json..........'+prodDetail.Product_Details__c );
            prodJsonList.add(prodDetail);
        }
        //string extId = product2.fields.APTS_Ext_ID__c;
        system.debug(loggingLevel.INFO,'Final prod Details list..........'+prodJsonList);

        // Based on externaal Id we are updating the existing records otherwise, it will create new records.
       LIST<Database.upsertResult> finalres = database.upsert(prodJsonList, Product_Detail__c.APTS_Ext_ID__c.getDescribe().getSObjectField(), false);
       
    }    
    public void finish(Database.BatchableContext bc){
        integer i =0;
    } 
    
     public void execute(SchedulableContext ctx) {
         
         // Execute the batch apex with single record 
          id batchJobId = Database.executeBatch(new TRStore_CreateProductJsonBatch(), 1);
          
          
          integer noOfHrs = 6;
           if(Static_Values__c.getAll().containsKey('TrstorePDPJsonSchedulehrs')){
             noOfHrs = Integer.valueOf(Static_Values__c.getAll().get('TrstorePDPJsonSchedulehrs').value__c); 
           }

          //Add no.of hrs for next iteration 
          datetime nextiteraion = system.now().addHours(noOfHrs);
          
          
        String day = string.valueOf(nextiteraion.day());

        String month = string.valueOf(nextiteraion.month());

        String hour = string.valueOf(nextiteraion.hour());

        String minute = string.valueOf(nextiteraion.minute());

        String second = string.valueOf(nextiteraion.second());

        String year = string.valueOf(nextiteraion.year());
        
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        String strJobName = 'UpdateTRSTRjson-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;

         // Schedule the next iteration
         if(!test.isRunningTest()) {
             String jobID = system.schedule(strJobName, strSchedule, new TRStore_CreateProductJsonBatch());
         }
     
        
    }
    
}