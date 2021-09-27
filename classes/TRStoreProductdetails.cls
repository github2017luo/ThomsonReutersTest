/**Class: TRStoreProductdetails
* Purpose: This class is for providing the product details for AEM  as part of TRStore 
* Created: 7/30/2019
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 07/30/2019  Mallik               DLT-17259     Created 
* 04/05/2019  Mallik               DLT-19888     Added Author Biography Changes
* 24/07/2020  Ameeta               DLT-20308     Bundle products PDP Page (Main and Microsites) SFDC and Zero Pricing
* 18/09/2020  Ameeta               DUE-5126      Added changes related to Product Collateral for EPM load.
* 18/09/2020  Ameeta               DUE-5128      Jurisdiction and Practice Area changes
* 26/09/2020  SachinR              DUE-5126      REST API to retrieve product details, version:v1:Refactored code
* 29/12/2020  Kanishk              DLT-21268     Publisher remapped to product Offering
* =============================================================================
*/
@RestResource(urlMapping='/TRstoreProductDetail/*')
global with sharing class TRStoreProductdetails{
    
    public Product2 product;
    public String productCode;
    public String countryCode;
    public String languageCode;
    public Boolean requestError;
    public string bundleChildFormatName;  
    public string bundleParentFormatName;
    public string bundleChildBundleType;
    public string bundleParentBundleType;
    public string bundleBaseBundleType;
    public Map<String,String> staticValues;
    public TRStoreproductDetailsService.ProductWrapper productData;
    public TRStoreproductDetailsService.RequestStatus statusResponse;
    public LIST<TRStoreproductDetailsService.ProductFormats> pdtFormats;
    public LIST<TRStoreproductDetailsService.ProductsFeatures> productset;
    
    public System.RestRequest restRequest
    {
        get { return System.RestContext.request; }
    }
    
    /**
     * Processes a Http Get request to provide product information
     * @author SR
     * @since 26/09/2020
     */
    @HttpGet
    global static TRStoreproductDetailsService.ProductWrapper doGet() {
        TRStoreProductdetails srObj = new TRStoreProductdetails();
        srObj.processRequest();
        return srObj.productData;
    }
    
    /* Initialize member variables*/
    private void initialize() {
        this.getStaticValues();
        this.bundleChildFormatName  = 'Formats';  
        this.bundleParentFormatName = 'Bundle Specifications';
        this.bundleChildBundleType  = 'Child';
        this.bundleParentBundleType = 'Parent';
        this.bundleBaseBundleType   = 'Base Product';
        this.bundleChildFormatName  = staticValues.containsKey('Bundle_ChildFormatName')?staticValues.get('Bundle_ChildFormatName') : this.bundleChildFormatName ;  
        this.bundleParentFormatName = staticValues.containsKey('Bundle_ParentFormatName')?staticValues.get('Bundle_ParentFormatName') : this.bundleParentFormatName;
        this.bundleChildBundleType  = staticValues.containsKey('Bundle_ChildBundleType')?staticValues.get('Bundle_ChildBundleType') : this.bundleChildBundleType;
        this.bundleParentBundleType = staticValues.containsKey('Bundle_ParentBundleType')?staticValues.get('Bundle_ParentBundleType') : this.bundleParentBundleType;
        this.bundleBaseBundleType   = staticValues.containsKey('Bundle_BaseBundleType')?staticValues.get('Bundle_BaseBundleType') : this.bundleBaseBundleType;
        
        this.productData = new TRStoreproductDetailsService.ProductWrapper();
        this.statusResponse = new TRStoreproductDetailsService.RequestStatus();
        this.pdtFormats = new LIST<TRStoreproductDetailsService.ProductFormats>();
        this.productset = new LIST<TRStoreproductDetailsService.ProductsFeatures>();
        
    }
    
    /* Get request params */
    private void parseRequest() {
        Map<String,String> requestMap = restRequest.params;
        try{
            this.requestError = false;
            this.productCode = requestMap.containsKey('pCode') ? requestMap.get('pCode') : '';
            this.countryCode = requestMap.containsKey('country') ? requestMap.get('country')  : '';
            this.languageCode = requestMap.containsKey('lang') ? requestMap.get('lang')  : '';
            if(String.isBlank(this.productCode) || String.isBlank(this.countryCode) || String.isBlank(this.languageCode)) {
                this.requestError = true;
            }
        }catch(Exception ex) {
            this.requestError = true;
        }finally{
            if(this.requestError) {
                this.statusResponse.statusCode = TRStoreConstants.DETAILS_NOT_FOUND_CODE;
                this.statusResponse.statusDesc = TRStoreConstants.DETAILS_NOT_FOUND ;
                this.statusResponse.status = TRStoreConstants.SUCCESS_STATUS;
                productData.status = statusResponse;
            }
        }
    }
    
    /* Process Request */
    public void processRequest() {
        try{
            this.initialize();
            this.parseRequest();
            this.fetchProductData();
            this.prepareResponseData();
        }catch(Exception ex) {
            this.statusResponse.statusCode = TRStoreConstants.DETAILS_NOT_FOUND_CODE;
            this.statusResponse.statusDesc = TRStoreConstants.DETAILS_NOT_FOUND ;
            this.statusResponse.status = TRStoreConstants.SUCCESS_STATUS;
            this.productData.status = statusResponse;
        }        
    }
    
    /* Prepare Response Data */
    public void prepareResponseData() {
        try{
            statusResponse = new TRStoreproductDetailsService.RequestStatus();
            if(product <> null && !product.Apttus_Config2__PriceLists__r.isEmpty()) {
                this.prepareProductData();
            }else{
                this.statusResponse.statusCode = TRStoreConstants.DETAILS_NOT_FOUND_CODE;
                this.statusResponse.statusDesc = TRStoreConstants.DETAILS_NOT_FOUND ;
                this.statusResponse.status = TRStoreConstants.SUCCESS_STATUS;
                productData.status = statusResponse;
            }
        }catch(Exception ex) {
            this.statusResponse.statusCode = TRStoreConstants.DETAILS_NOT_FOUND_CODE;
            this.statusResponse.statusDesc = TRStoreConstants.DETAILS_NOT_FOUND ;
            this.statusResponse.status = TRStoreConstants.SUCCESS_STATUS;
            productData.status = statusResponse;
        }        
    }
    
  /* Prepare product data */    
    private void prepareProductData(){
        this.addProductData();
        if(languageCode.containsIgnoreCase('fr')){
            this.addFrenchData();
        }
        this.addPrice();
        this.addAuthors();
        this.addFeatures();
        this.addCollateral();
        if(!this.pdtFormats.isEmpty()){
            this.productData.ProductFormat = this.pdtFormats;
        }
        if(!this.productset.isEmpty()){
            this.productData.productFeatureset = productset;  
        }
        this.statusResponse.statusCode = TRStoreConstants.SUCCESS_CODE;
        this.statusResponse.statusDesc =  TRStoreConstants.DETAILS_FOUND ;
        this.statusResponse.status = TRStoreConstants.SUCCESS_STATUS;
        this.productData.status = statusResponse; 
    }
    
    /* Add product data to response */
    private void addProductData(){
        this.productData.productName = product.Name;
        this.productData.ProductCode = product.ProductCode;
        this.productData.Description = product.Description;
        
        this.productData.serviceNumber = this.handleEmptyString(product.Service_Number__c, TRStoreConstants.NOT_AVAILABLE); 
        this.productData.publisher = this.handleEmptyString(product.Product_Offering__c, TRStoreConstants.NOT_AVAILABLE); 
        this.productData.author = this.handleEmptyString(product.LCRM_Author__c, TRStoreConstants.NOT_AVAILABLE); 
        this.productData.shortDesc = this.handleEmptyString(product.DC_Short_Description__c, TRStoreConstants.NOT_AVAILABLE);
        this.productData.longDesc = this.handleEmptyString(product.DC_Long_Description__c, TRStoreConstants.NOT_AVAILABLE);
        this.productData.sub =  this.handleEmptyString(product.Subscription_Number__c, TRStoreConstants.NOT_AVAILABLE); 
        this.productData.isbn = this.handleEmptyString(product.ISBN__c, TRStoreConstants.NOT_AVAILABLE); 
        this.productData.publicationDate = (product.LCRM_Publication_Date__c != null)?string.valueOf(product.LCRM_Publication_Date__c) :TRStoreConstants.NOT_AVAILABLE;
        String jurisdiction =  this.stringReplace(product.Apttus_Filter_Jurisdiction__c);
        String pracArea = this.stringReplace(product.Practice_Area__c);
        this.productData.Jurisdiction = this.handleEmptyString(jurisdiction, TRStoreConstants.NOT_AVAILABLE);
        this.productData.practiceArea = this.handleEmptyString(pracArea, TRStoreConstants.NOT_AVAILABLE); 
        if(languageCode.containsIgnoreCase('en'))
        { 
            TRStoreproductDetailsService.ProductFormats pf = new TRStoreproductDetailsService.ProductFormats();
            pf.format = (!string.isBlank(product.Format__c))?product.Format__c:TRStoreConstants.NOT_AVAILABLE;
            pf.productId = product.ProductCode;
            pf.bundleType = bundleBaseBundleType;
            pf.bundleTitle = product.Name;
            this.pdtFormats.add(pf);
        }
        
    }    
    
    private String stringReplace(String originalString){
        String targetString = '';
        
        if(String.isNotBlank(originalString)){
            List<String> valueList=originalString.split(';');
            for(String s : valueList){
                String trimmedString = s.trim();
                targetString+= trimmedString+', ';
            }
            targetString = targetString.subString(0, targetString.length() - 2);
             
        }
        return targetString;
    }
    
    private string handleEmptyString(String source, String target){
        String returnString = source;
        if(String.isBlank(returnString) && String.isBlank(target)){
            returnString = TRStoreConstants.NOT_AVAILABLE;
        }else if(String.isBlank(returnString)){
            returnString = target;
        }
        return returnString;
    }
    
    /* Add French product data to response */
    private void addFrenchData(){
        TRStoreproductDetailsService.productFormats pf = new TRStoreproductDetailsService.productFormats();
        pf.format = (!string.isBlank(product.Format__c))?product.Format__c:TRStoreConstants.NOT_AVAILABLE;
        pf.productId = product.ProductCode;
        pf.bundleType = bundleBaseBundleType;
        pf.bundleTitle = product.Name;
        
        for(Apttus_Config2__ProductTranslation__c pt: product.Apttus_Config2__Translation__r){
            String jurisdictionFr =  this.stringReplace(pt.Jurisdiction__c);
            String pracAreaFr = this.stringReplace( pt.Practice_Area__c);
            productData.Jurisdiction = this.handleEmptyString(jurisdictionFr, this.productData.Jurisdiction);
            productData.practiceArea = this.handleEmptyString(pracAreaFr, this.productData.practiceArea);
            pf.format = (!string.isBlank(pt.Format__c))?pt.Format__c : ((!string.isBlank(product.Format__c))?product.Format__c:TRStoreConstants.NOT_AVAILABLE);                   
                }
        
        this.pdtFormats.add(pf);
    }
    
    /* Add product price data to response */
    private void addPrice(){
        LIST<TRStoreproductDetailsService.Pricelist> priceDetails = new LIST<TRStoreproductDetailsService.Pricelist>();
        for(Apttus_Config2__PriceListItem__c pl: product.Apttus_Config2__PriceLists__r){
            
            TRStoreproductDetailsService.Pricelist pld = new TRStoreproductDetailsService.Pricelist();
            pld.listPrice = pl.Apttus_Config2__ListPrice__c;
            pld.chargetype = pl.Apttus_Config2__ChargeType__c;
            
            priceDetails.add(pld);
        }
        productData.pricelistDetails = priceDetails;
    }
    
    /* Add product authors to the response */
    private void addAuthors(){
        LIST<TRStoreproductDetailsService.ProductAuthors> localAuthors = new LIST<TRStoreproductDetailsService.ProductAuthors>();
        LIST<String> authorListWithBlankOrder = new LIST<String>();
        LIST<Product_Author_Value__c> pavListWithBlankOrder = new LIST<Product_Author_Value__c>();
        MAP<String,Product_Author_Value__c> authorValueList = new MAP<String,Product_Author_Value__c>();
        
        for(Product_Author_Value__c pa: product.Product_Author_Values__r ){
            authorValueList.put(pa.Product_AuthorId__r.Name,pa);
            if(pa.Display_Order__c != null){
                TRStoreproductDetailsService.ProductAuthors author = new TRStoreproductDetailsService.ProductAuthors();
                author.authorId = pa.Product_AuthorId__r.Author_ID__c;
                author.authorName = pa.Product_AuthorId__r.Name;
                author.sfdcId = pa.Product_AuthorId__c;
                localAuthors.add(author);
            }else{
                authorListWithBlankOrder.add(pa.Product_AuthorId__r.Name);
            }
        }
                              
        if(!authorListWithBlankOrder.isEmpty()){
            authorListWithBlankOrder.sort();
        }
        
        for(String authName : authorListWithBlankOrder){
            pavListWithBlankOrder.add(authorValueList.get(authName));
        }
        
        for(Product_Author_Value__c pa: pavListWithBlankOrder ){
            
                TRStoreproductDetailsService.ProductAuthors author = new TRStoreproductDetailsService.ProductAuthors();
                author.authorId = pa.Product_AuthorId__r.Author_ID__c;
                author.authorName = pa.Product_AuthorId__r.Name;
                author.sfdcId = pa.Product_AuthorId__c;
                localAuthors.add(author);
            
        }
        productData.Authors = localAuthors;
    }
    
    /* Get feature translations for bundles*/
    private Map<string, string> getFeatureTranslations(){
        List<string> lanTrStr = new LIST<string>();
        Map<string, string> languageTranslation = new MAP<string, string>();
        for(Apttus_Config2__ProductFeatureValue__c pv: product.Apttus_Config2__ProductFeatureValues__r){
            if(string.isNotBlank(pv.Apttus_Config2__Value__c)){
                if(pv.Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name.equalsIgnoreCase(bundleChildFormatName) ||  pv.Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name.equalsIgnoreCase(bundleParentFormatName) ) {
                    lanTrStr.add(pv.Apttus_Config2__FeatureId__r.Name);   
                }   
            } 
        }
        if(!lanTrStr.isEmpty()){
            for(Language_Translations__mdt lt: [Select id, Eng_Values__c, Language__c, Translated_Value__c FROM Language_Translations__mdt WHERE Eng_Values__c IN: lanTrStr]){
                languageTranslation.put(lt.Eng_Values__c, lt.Translated_Value__c);
            }
        }
        return languageTranslation;
    }
    
    /* Add product features to the response*/
    private void addFeatures(){
        Map<string, string> languageTranslation =  this.getFeatureTranslations();
       
        for(Apttus_Config2__ProductFeatureValue__c pv: product.Apttus_Config2__ProductFeatureValues__r){
            if(string.isNotBlank(pv.Apttus_Config2__Value__c)){
                TRStoreproductDetailsService.ProductsFeatures pf = new TRStoreproductDetailsService.ProductsFeatures();
                
                pf.key = pv.Apttus_Config2__FeatureId__r.Name;
                pf.value = pv.Apttus_Config2__Value__c;
                if(pv.Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name.equalsIgnoreCase(bundleChildFormatName) ){
                    TRStoreproductDetailsService.productFormats pft = new TRStoreproductDetailsService.productFormats();
                    pft.bundleType = bundleChildBundleType;
                    pft.productId = pv.Apttus_Config2__Value__c;
                    pft.format = (languageTranslation.containsKey(pv.Apttus_Config2__FeatureId__r.Name) && languageCode.containsIgnoreCase('fr'))? (languageTranslation.get(pv.Apttus_Config2__FeatureId__r.Name)) : pv.Apttus_Config2__FeatureId__r.Name ;
                    this.pdtFormats.add(pft);
                }else if(pv.Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name.equalsIgnoreCase(bundleParentFormatName)   ){
                    TRStoreproductDetailsService.productFormats pft = new TRStoreproductDetailsService.productFormats();
                    pft.bundleType = bundleParentBundleType;
                    pft.bundleTitle = pv.Apttus_Config2__Value__c;
                    pft.format = pv.Apttus_Config2__FeatureId__r.Name;
                    pft.productId = pv.Apttus_Config2__FeatureId__r.Name;
                    this.pdtFormats.add(pft);
                }
                this.productset.add(pf);
            }
        }
    }
    /* Add product collateral to the response*/
    private void addCollateral(){
        Map<String, String> mapTitle = new Map<String,String>{staticValues.get('Release Note')=>'ReleaseNote',staticValues.get('Index')=>'IndexNote',staticValues.get('Table of Contents')=>'Table of content'};
            Map<String, String> mapPath = new Map<String,String>{staticValues.get('Release Note')=>'ReleaseFileName',staticValues.get('Index')=>'IndexFileName',staticValues.get('Table of Contents')=>'TOCFileName'};
                for(Product_Collateral_Value__c pcv: product.Product_Collateral_Values__r){
                    if(mapTitle.containsKey(pcv.Product_Collateral__r.Collateral_Type__c)){
                        TRStoreproductDetailsService.ProductsFeatures pf = new TRStoreproductDetailsService.ProductsFeatures();
                        
                        pf.key = mapTitle.get(pcv.Product_Collateral__r.Collateral_Type__c);
                        pf.value = (string.isNotBlank(pcv.Product_Collateral__r.Collateral_Path__c))?'Yes':'No';
                        
                        this.productset.add(pf);
                    }
                    if(string.isNotBlank(pcv.Product_Collateral__r.Collateral_Path__c) && mapPath.containsKey(pcv.Product_Collateral__r.Collateral_Type__c)){
                        TRStoreproductDetailsService.ProductsFeatures pfpath = new TRStoreproductDetailsService.ProductsFeatures();
                        
                        pfpath.key = mapPath.get(pcv.Product_Collateral__r.Collateral_Type__c);
                        pfpath.value = (string.isNotBlank(pcv.Product_Collateral__r.Collateral_Path__c))?pcv.Product_Collateral__r.Collateral_Path__c:TRStoreConstants.NOT_AVAILABLE;
                        
                        this.productset.add(pfpath);
                    }  
                    
                }
    }
    
    /* Retrieve product data */
    private void fetchProductData(){
        String featureExclude = this.staticValues.get('TRStoreFeaturesToExclude');
        List<String> featureExcludeList=featureExclude.split(',');
        
        String featureSetInclude = this.staticValues.get('TRStoreFeatureSetToInclude');
        List<String> featureSetIncludeList=featureSetInclude.split(',');
        
        String collateral = staticValues.containsKey('TRStoreCollateral')?staticValues.get('TRStoreCollateral'):'';
        List<String> collateralList=collateral.split(',');
        List<String> sellableFlagList= staticValues.containsKey('sellableFlagValues') ? staticValues.get('sellableFlagValues').split(',') : null;
        String countryPriceList;
        if(this.countryCode.equalsIgnoreCase('US')){
            countryPriceList = staticValues.get('TRStorePricelistUS'); 
        }
        else if(this.countryCode.equalsIgnoreCase('CA'))
        {
          countryPriceList = staticValues.get('TRStorePricelistCA');    
        }else{
            countryPriceList = staticValues.get('TRStorePricelistCA');
        }
        
        String pCode = this.productCode;
        
        try{
            String query = 'SELECT Id, Name, ProductCode, Description, Service_Number__c,Apttus_Filter_Brand__c,Product_Offering__c,Apttus_Filter_Jurisdiction__c, Format__c,Practice_Area__c, LCRM_Publication_Date__c, ISBN__c, LCRM_Author__c,DC_Short_Description__c,DC_Long_Description__c,Subscription_Number__c,(SELECT id, name, Apttus_Config2__ChargeType__c,Apttus_Config2__PriceType__c,Apttus_Config2__Frequency__c, Apttus_Config2__ListPrice__c FROM Apttus_Config2__PriceLists__r where Apttus_Config2__Active__c = true AND Apttus_Config2__ListPrice__c <> 0 ),(SELECT id, name, Apttus_Config2__Value__c, Apttus_Config2__FeatureId__r.Name,Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name from Apttus_Config2__ProductFeatureValues__r WHERE Apttus_Config2__FeatureId__r.Apttus_Config2__FeatureSetId__r.Name IN: featureSetIncludeList AND Apttus_Config2__FeatureId__r.Name NOT IN: featureExcludeList),(Select id, name, Product_Collateral__c, Product__r.Name,Product_Collateral__r.Name,Product_Collateral__r.Collateral_Path__c, Product_Collateral__r.Collateral_Title__c, Product_Collateral__r.Collateral_Type__c from Product_Collateral_Values__r where Product_Collateral__r.Collateral_Type__c IN: collateralList ),(SELECT id, name, Display_Order__c, Product_AuthorId__c, Product_AuthorId__r.Author_ID__c, Product_AuthorId__r.Name FROM Product_Author_Values__r ORDER BY Display_Order__c ASC NULLS LAST),(select id, name, Format__c, Jurisdiction__c, Practice_Area__c, Pricing_Terms__c, Stock__c FROM Apttus_Config2__Translation__r ) From Product2 WHERE (ProductCode =: pCode AND IsActive = true AND CPD_Sellable_Description__c IN: sellableFlagList) AND Id IN (SELECT Apttus_Config2__ProductId__c FROM Apttus_Config2__PriceListItem__c WHERE (Apttus_Config2__ListPrice__c <> NULL AND Apttus_Config2__Active__c = true AND Apttus_Config2__PriceListId__r.name =: countryPriceList) AND (Apttus_Config2__EffectiveDate__c = NULL OR Apttus_Config2__EffectiveDate__c <= Today) AND (Apttus_Config2__ExpirationDate__c = NULL OR Apttus_Config2__ExpirationDate__c >= Today)) limit 1';
            List<Product2> products = Database.query(query);            
            this.product = products.isEmpty() ? null : products[0];
        }catch(Exception ex) {
            this.statusResponse.statusCode = TRStoreConstants.DETAILS_NOT_FOUND_CODE;
            this.statusResponse.statusDesc = TRStoreConstants.DETAILS_NOT_FOUND ;
            this.statusResponse.status = TRStoreConstants.SUCCESS_STATUS;
            this.productData.status = statusResponse;
        }
        
    }
    
    /* Retrieve static values and store it in a map */
    private void getStaticValues(){
        for(Static_Values__c instance : [Select Name, Value__c from Static_Values__c] ){
            if(this.staticValues == null) {
                this.staticValues = new Map<String,String>();
            }
            this.staticValues.put(instance.name, instance.Value__c);
        }
    }
    
}