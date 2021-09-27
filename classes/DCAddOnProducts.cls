/*
* CHANGE HISTORY 
* ==================================================================================================================================
* Date          Name                    Description
* 2018-01-16    Ramesh Reddy            DLT-6822 - [Add On Journey] Add On Page available for Plus or Premium Plans
* 2018-02-21    Ramesh Reddy            DLT-7720 - Add-on Flag logic to be updated using Renewal Date and Campaign Code
* 2018-05-15    Ramesh Reddy            DLT-7685 - Text on top half of add-on 'tile' to be presented in bullet format
* 2018-05-23    Srikanth kota           DLT-8663 - Removed ProductPricingModel filter for quantity to make Crop work
* 2018-06-12    Rajan Tatuskar          DLT-9759 - Updates Account/Contact reference For Add On Product classes 
* 2018-07-16    Harika Sai P            DLT-9683 - Enhanced 'tiles' On Addon Page Downloads. 
* 2018-07-18    Bharat Bhushan          DLT-9683 - Enhanced 'tiles' On Addon Page Downloads. Added Video length and PDF size
* 2018-10-18    Rajan Tatuskar          DLT-12594 - Recommendations reason from Automation file for Add-Ons
* 2018-11-06    Rajan Tatuskar          DLT-13389 - Defect : Add on page - Per seat not working
* 2018-11-15    Divija Salla            DLT-13464 - All. Streamline all Max users for landing page and add on page, added new Custom metadata: 'DC Max Users or Attorneys'
* 2018-12-20    Benjamin Her            DLT-14153 - Cdoe Scan fixes
* 2019-01-10    Bishanka Dassarma       DLT-14347 - Code Scan Fixes
* 2019-02-05    Navleen Kaur            DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
* 2019-02-20    Harika Sai P            DLT-15252 - Send credential flag to AEM when any public records are added on
* 2019-04-25    Harika Sai P            DLT-16262 - Public record product title should contain text or word 'Public Records'
* 2019-05-14    Navleen Kaur            DLT-16421 - [SLF][SFDC] Mid-Contract/Upsell - Changes to Addon related Subscriptions and Features
* 2019-06-24    Navleen Kaur            DLT-16914 - Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveAddOns, DCBundleFinalizeService
* 2020-01-02    Srikanth Kota           DLT-18979 - AddOns page for the Plus proposal (regular renewal) is picking up the amount from the Mid Contract Plus proposal (which is expired).
* 2020-07-14    Benjamin Her            DLT-20210/DLT-20346 - Update Max Attorney for Banded/Per Seat
* 2020-08-14    Benjamin Her            DLT-20588 Implement MLF support
* 2020-12-03    Benjamin Her            DLT-21201 - PMD fix
* 2021-05-24    Kavya S                 DLT-21405 - PMD FIX
* ==================================================================================================================================   
*/
@RestResource(urlMapping='/digitalconfigurator/getAddOns/*')
 /** 
 * @description : DCAddOnProducts
 */
global with sharing class DCAddOnProducts {
    
    private static final String STR_DIMENSION1_NAME = 'Quantity';
    private static final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static final String CART_STATUS_FINALIZED = 'Finalized'; 
    private static final String APPROVAL_STAGE_PRESENTED = 'Presented';   // DLT-18979
    private static final string WEST_PROFLEX = 'West Proflex';
    private static final string DIGITAL_FIRM_GOV = 'Government';
    private static final string DIGITAL_FIRM_SMALLLAW = 'Small Law';
    private static final String PRODUCT_PRICING_MODEL_PER_SEAT = 'Per Seat';
    private static final String PRODUCT_PRICING_MODEL_BANDED = 'Banded';
    private static final List<String> LAW_FIRMS = System.Label.Digital_Law_Firm.split(',');
    
    private Map<String,List<Pricematrix>> productIdToPriceMatrices = new Map<String,List<Pricematrix>>();
    private Map<String,Map<Integer,Pricematrix>> productIdToQuantityPriceMatrices = new Map<String,Map<Integer,Pricematrix>>();
    private Map<String, List<OnlineContacts>> onlineContactMap = new Map<String, List<OnlineContacts>>();
    public Map<String,Product> allProducts = new Map<String,Product>(); 
    private Map<String, Apttus_Config2__LineItem__c> selectedProductIdLineItemMap;
    
    public Set<String> selectedProducts = new Set<String>();
    private static Integer maxNoOfAttorneys = 0;
    private Integer maxNoOfPerSeatUsers;
    private Integer attorneyAmount;
    Map<String,String> quoteTypeToType = new Map<String,String>();
    private Map<String,List<Material>> mapOfmaterialNo = new Map<String,List<Material>>();
    private String quoteId;            
    private String addOnProducts; 
    
    /**
    * Rest-API service will trigger this method and return the quote details and Addon products
    */
    /** 
     * @description :AddOnResponse
     * @param opportunityId : Opportunity id
     * @param quoteType : quote type
     * @return : response
     */
    @HttpPost
    global static AddOnResponse api(String opportunityId,String quoteType){
        AddOnResponse response = new AddOnResponse();  
        if(String.isBlank(opportunityId) || String.isBlank(quoteType)){
            response.responseCode = 400;
            response.responseMessage = 'Opportunity Id And Quote Type should not be null or empty';
            return response; 
        }
        try{
            DCAddOnProducts data = new DCAddOnProducts();
            response.addOnDetails = data.getSubscriptions(opportunityId,quoteType);
            response.responseCode = 200;
            response.responseMessage = '';
        }catch(Exception ex){
            DCUtils.trackLog(ex,'DCAddOnProducts','api');
            response.responseCode = 400;
            response.responseMessage = ex.getMessage();
        }
        System.debug(logginglevel.INFO,'Response----' + JSON.serialize(response));
        return response;
    }
    /**
        * get all addOn products based on Opportunity and quote type
        */ 
        /** 
     * @description :AddOnDetails getSubscriptions
     * @param opportunityId : Opportunity id
     * @param quoteType : Quote Type
     * @return : add
     */
    private AddOnDetails getSubscriptions(String opportunityId,String quoteType){
        quoteTypeToType.put('Straight Renewal','Straight');
        quoteTypeToType.put('Premium','Premium');
        quoteTypeToType.put('Best Value','Plus');
        quoteTypeToType.put('Best Value+Config','Config');
    
        List<Apttus_Config2__ProductConfiguration__c> carts = new List<Apttus_Config2__ProductConfiguration__c>();
        carts = [SELECT id,Apttus_QPConfig__Proposald__c,APTS_New_Holdings__c,APTS_Current_Holdings__c,Apttus_Config2__PriceListId__c,
                    Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c, Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c,
                    Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                    Apttus_QPConfig__Proposald__r.APTS_Customer_Category__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,
                    Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.APTS_Apttus_Customer_Pricing_Segment__c,
                    Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.SAP_Account_Number__c, 
                    Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c,
                    Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c,
                    (SELECT id, name, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
                        Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__ProductId__c,
                        Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,Apttus_Config2__Quantity__c,
                        Apttus_Config2__NetPrice__c,APTS_Contract_Term__c,Apttus_Config2__ProductId__r.Name
                    FROM Apttus_Config2__LineItems__r 
                    WHERE Apttus_Config2__LineStatus__c !=:LINE_STATUS_CANCELLED) 
                FROM Apttus_Config2__ProductConfiguration__c 
                WHERE Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c =: opportunityId 
                AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED 
                AND Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c =: quoteType
                AND Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c =:APPROVAL_STAGE_PRESENTED 
                WITH SECURITY_ENFORCED];                                     
        
        if(carts.isEmpty()){
            throw new DCCustomException('criteria does not match with any record, opportunityId: '+opportunityId);
        }
        
        String customerNumber = carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;
        Product_Account_Detail__c subscription = new Product_Account_Detail__c();
        if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){
            subscription = [SELECT ZP_Cust_Number__c,Digital_Firm__c 
                            FROM Product_Account_Detail__c 
                            WHERE ZP_Cust_Number__c = :customerNumber 
                            LIMIT 1];
        }
        quoteId = carts[0].Apttus_QPConfig__Proposald__c;
        String digitalQuoteType = carts[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
        String segment = carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.APTS_Apttus_Customer_Pricing_Segment__c;
        String firm = subscription.Digital_Firm__c;
        String ocId = carts[0].Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c;
        String ocEmailId = carts[0].Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c;
        
        AddOnDetails add = new AddOnDetails();
        add.quoteId = carts[0].Apttus_QPConfig__Proposald__c;
        add.quoteType = digitalQuoteType;
        add.oCCId =  ocId;
        add.oCCEmailId  = ocEmailId;
        
        add = getPrice(add,digitalQuoteType,carts);
        selectedProductIdLineItemMap = new Map<String, Apttus_Config2__LineItem__c>();

        getMaxNoOfAttorneys(firm);
        attorneyAmount = getAttorneyAmount(firm);

        add = populatePricingDetails(add,carts,firm);

        getProducts(carts,firm);
        add.addOnProducts = allProducts.values();
        add.maxNoOfPerSeatUsers = attorneyAmount;
        System.debug(logginglevel.INFO,'AddOnDetails Json >'+Json.serialize(add));
        return add;
    } 

    //getPrice()
    //Gets the price based on digital quote type
    private AddOnDetails getPrice(AddOnDetails add,String digitalQuoteType,List<Apttus_Config2__ProductConfiguration__c> carts){
        AddOnDetails addon = add;
        if(digitalQuoteType == 'Straight Renewal') {
            add.price = carts[0].APTS_Current_Holdings__c;
        } 
        else {
            add.price = carts[0].APTS_New_Holdings__c;
        }
        return addon;
    }

    //populatePricingDetails()
    //Gets the addon's pricing details based on cart line items.
    private AddOnDetails populatePricingDetails(AddOnDetails add, List<Apttus_Config2__ProductConfiguration__c> carts,String firm){
        AddOnDetails addon = add;
        for(Apttus_Config2__LineItem__c line : carts[0].Apttus_Config2__LineItems__r){
            addon.quantity = Integer.valueOf(line.Apttus_Config2__Quantity__c);   
            addon.adjustmentType = line.Apttus_Config2__AdjustmentType__c;
            addon.adjustmentAmount = line.Apttus_Config2__AdjustmentAmount__c;
            addon.contractTerm = line.APTS_Contract_Term__c;  
            selectedProducts.add(line.Apttus_Config2__ProductId__c);
            selectedProductIdLineItemMap.put(line.Apttus_Config2__ProductId__c, line);

            //DLT-20210/DLT-20346
            if(LAW_FIRMS.contains(firm)
                && (line.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == PRODUCT_PRICING_MODEL_BANDED
                || line.Apttus_Config2__ProductId__r.Name == WEST_PROFLEX)){

                attorneyAmount = maxNoOfAttorneys;
            }
        }

        return addon;
    }
    private integer getAttorneyAmount(String firm){
                
        if(LAW_FIRMS.contains(firm)){
            return maxNoOfPerSeatUsers;
        }
        else{
            return maxNoOfAttorneys;
        }
    }
    
    /**
    * get all getDBcatAddOns from Digital subscrptions for New Mid Contract :: added by Navleen as part of  DLT-16421
    */

    /** 
     * @description : getDBcatAddOns :get all getDBcatAddOns from Digital subscrptions for New Mid Contrac
     * @param custNumber : Customer Number
     */
    private void getDBcatAddOns(String custNumber){                  
        Set<String> setOfAddOnSvc  = new Set<String>();
        Set<String> setOfSubNo  = new Set<String>();
        for(Product_Account_Detail__c acctToPrds : [SELECT Add_on_Type__c,Default_Add_On__c,Add_On_Sub__c,Add_On_Svc__c FROM Product_Account_Detail__c where  ZP_Cust_Number__c =:custNumber AND Add_on_Type__c ='Plus' AND Add_On_Sub__c!= null AND Contract_Type__c ='New Mid Contract' AND Add_On_Svc__c!=null]){
            if( acctToPrds.Add_On_Svc__c != null && acctToPrds.Add_On_Sub__c != null){
                setOfAddOnSvc.add(acctToPrds.Add_On_Svc__c);
                setOfSubNo.add(acctToPrds.Add_On_Sub__c);
            }
        }
        system.debug(logginglevel.INFO,'setOfSubNo'+setOfSubNo);
        List<Digital_Product_Plans__c> plans = new  List<Digital_Product_Plans__c>();
        if(setOfAddOnSvc!= null && setOfSubNo!= null && !(setOfAddOnSvc.isEmpty()) 
            && !(setOfSubNo.isEmpty()) && Schema.sObjectType.Digital_Product_Plans__c.isAccessible() ){ 

            plans = [SELECT id, name, Material_Number__c,Material_Description__c, Product__c, Subscription_Number__c,
                        SLF_Jurisdiction__c, DB_Group__c, DB_Group_Sort_Order__c,DB_Category__c,DB_Category_Sort_Order__c,
                        SLF_Help_Text__c,Additional_Help_Text__c
                    FROM Digital_Product_Plans__c 
                    WHERE Material_Number__c IN : setOfAddOnSvc 
                    AND Subscription_Number__c IN : setOfSubNo];                   
        }
        system.debug(logginglevel.INFO,'plans'+plans);        
        populateMaterialNumberMap(plans);

    }
    private void populateMaterialNumberMap(List<Digital_Product_Plans__c> plans){
        for(Digital_Product_Plans__c plan : plans){
            Material mat= new Material();
            mat.materialId = plan.Id;
            mat.materialNumber = plan.Material_Number__c;
            mat.materialDescription = plan.Material_Description__c;
            mat.internalDescription = plan.SLF_Help_Text__c;
            mat.classificationValue = plan.DB_Category__c;
            mat.classificationValueSortOrder = Integer.valueOf(plan.DB_Category_Sort_Order__c);
            mat.subscriptionNumber = plan.Subscription_Number__c;
            mat.jurisdiction = plan.SLF_Jurisdiction__c;
            mat.productPlanId = plan.Product__c;
            mat.productGroup = plan.DB_Group__c;
            mat.productGroupSortOrder = Integer.valueOf(plan.DB_Group_Sort_Order__c);
            mat.additionalInternalDescription = plan.Additional_Help_Text__c;
            if(mapOfmaterialNo.get(plan.Material_Number__c)==null){
                mapOfmaterialNo.put(plan.Material_Number__c,new List<Material>());
            }
            mapOfmaterialNo.get(plan.Material_Number__c).add(mat);
        }
    }
    /**
    * get all addOn products from Digital subscrptions
    */
    /** 
     * @description : getProducts
     * @param carts : carts
     * @param firm : firm
     */
    private void getProducts(List<Apttus_Config2__ProductConfiguration__c> carts,String firm){

        String custNumber = carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;
        String digitalQuoteType = carts[0].Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c;
        String segment = carts[0].Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.APTS_Apttus_Customer_Pricing_Segment__c;
        String campaignCode = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Campaign_Code__c;
        Date renewalDate = carts[0].Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c;
        String quoteType = quoteTypeToType.get(digitalQuoteType);
        
        List<Product_Account_Detail__c> subscriptions = new  List<Product_Account_Detail__c>();
        if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){         
        //DLT-12594 - Recommendations reason from Automation file for Add-Ons
            subscriptions = [SELECT Id,name,Add_On_Sub__c,Add_On_Svc__c ,Add_on_Type__c,Add_On_Text_Code__c
                            FROM Product_Account_Detail__c 
                            WHERE ZP_Cust_Number__c =: custNumber 
                            AND Add_on_Type__c =: quoteType
                            AND Campaign_Code__c =: campaignCode 
                            AND Renewal_Date__c =: renewalDate];
        }
    
        Set<String> serviceNumbers = new Set<String>();
        List<String> subscriptionNumbers = new List<String>();
        Set<String> servicesubscription = new Set<String>();
        //added by Navleen as part Of  DLT-16421
        getDBcatAddOns(custNumber);
        system.debug(logginglevel.INFO,'mapOfmaterialNo'+mapOfmaterialNo);
        //DLT-12594 - Recommendations reason from Automation file for Add-Ons
        Map<String,String> addOnTextCodeMap = new Map<String,String>();
    
        for(Product_Account_Detail__c digital : subscriptions ){
            if(String.isNotBlank(digital.Add_On_Svc__c) && String.isNotBlank(digital.Add_On_Sub__c)){
                serviceNumbers.add(digital.Add_On_Svc__c);
                subscriptionNumbers.add(digital.Add_On_Sub__c);
                servicesubscription.add(digital.Add_On_Svc__c+'-'+digital.Add_On_Sub__c);
                //DLT-12594 - Recommendations reason from Automation file for Add-Ons
                if(String.isNotBlank(digital.Add_On_Text_Code__c)){
                    addOnTextCodeMap.put(digital.Add_On_Svc__c,digital.Add_On_Text_Code__c);
                }
            }
        }
        
        List<Product2> prods = new List<Product2>();    
        if(Schema.sObjectType.Product2.isAccessible()){
            system.debug(logginglevel.INFO,'serviceNumbers ::'+serviceNumbers );
            prods = [SELECT Id,Name,Subscription_Number__c,productCode,Service_Number__c,DC_Jurisdiction__c,
                        DC_Long_Description__c,DC_Short_Description__c,DC_Product_Title__c,Apttus_Filter_Jurisdiction__c,
                        APTS_Product_Pricing_Model__c,DC_PDF_Description__c,DC_PDF_URL__c,DC_Video_Description__c,
                        DC_Video_Length__c,DC_Video_URL__c,DC_PDF_Size__c
                    FROM Product2 
                    WHERE productCode IN :serviceNumbers ];
        }

        //Pulls public addon numbers from custom metadata information
        getPublicAddons();

        for(Product2 prod : prods ){
            if(!serviceNumbers.contains(prod.productCode)){
                continue;
            }
            //Adds the product to the map of addon products
            populateAllAddonMap(prod,addOnTextCodeMap);
        }

        populateAddonProductPriceMatrix(segment, firm);
        populateAddonProductOnlineContact();

    }

    //populateAddonProductOnlineContact()
    //Populates the online contact for the addon product
    private void populateAddonProductOnlineContact(){
        if(!allProducts.isEmpty()){
            Map<String, List<OnlineContacts>> prodIdOnlineContactMap = getOnlineContacts(quoteId);
            for(String pId : allProducts.keySet()){
                //DLT-13389 - Defect : Add on page - Per seat not working
                if(allProducts.containsKey(pId) && String.isNotBlank(allProducts.get(pId).materialNumber)){
                    allProducts.get(pId).onlineContacts = prodIdOnlineContactMap.get(allProducts.get(pId).materialNumber);
                }
            }
        }
    }

    //populateAddonProductPriceMatrix()
    //Populates the price matrix for the addon products
    private void populateAddonProductPriceMatrix(String segment, String firm){
        if(!allProducts.isEmpty()){
            getPricematricesV2(allProducts.keySet(),segment,firm);
            for(String pId : allProducts.keySet()){
                allProducts.get(pId).priceMatrix = productIdToPriceMatrices.get(pId);
            }
        }
    }

    //getShortDescription()
    //Gets and splits the short desciriton of the product and store into a list.
    private List<String> getShortDescription(Product2 prod){
        List<String> finalArray = new List<String>();
        String shortDescription = prod.DC_Short_Description__c;
        String[] discriptionArray = String.isBlank(shortDescription) ? new String[]{} : shortDescription.split('\\{\\{bullet}}');

        if(discriptionArray != null){
            for(String discription : discriptionArray){
                if(String.isNotBlank(discription)){
                    discription = discription.trim();
                    finalArray.add(discription);
                }
            }
        }
        return finalArray;
    }

    //populateAllAddonMap()
    //Populates the 'allProducts' map with a product
    private void populateAllAddonMap(Product2 prod,Map<String,String> addOnTextCodeMap ){

        Product addOnP = new Product();
        addOnP.productId = prod.Id; 
        addOnP.productTitle = prod.DC_Product_Title__c;

        addOnP.shortDescription = getShortDescription(prod);
        //added by Navleen as part of  DLT-16421
        addOnP.material = mapOfmaterialNo.get(prod.productCode);
        
        addOnP.longDescription = prod.DC_Long_Description__c;
        addOnP.jurisdiction = prod.DC_Jurisdiction__c;
        addOnP.pricingModel = prod.APTS_Product_Pricing_Model__c;
        addOnP.isSelected = selectedProducts.contains(prod.Id);
        if(selectedProductIdLineItemMap.keySet().contains(prod.Id)) {
            addOnP.noOfUsers = Integer.valueOf(selectedProductIdLineItemMap.get(prod.Id).Apttus_Config2__Quantity__c);
        }
        //DLT-9683
        addOnp.pdfurl= prod.DC_PDF_URL__c;
        addOnp.pdfdescription= prod.DC_PDF_Description__c;
        addOnp.videoURL= prod.DC_Video_URL__c;
        addOnp.videoDescription= prod.DC_Video_Description__c;
        addOnp.videoLength= prod.DC_Video_Length__c;
        addOnp.pdfSize=prod.DC_PDF_Size__c;
        //DLT-9683 Ends
        //DLT-12594 - Recommendations reason from Automation file for Add-Ons
        if(addOnTextCodeMap.containsKey(prod.productCode)){
            addOnp.addOnTextCode = addOnTextCodeMap.get(prod.productCode);
        }
        
        addOnp.materialNumber = prod.productCode;
        //DLT-15252 - If the product title has a text public records, it means Add On product is public record type and we will send the flag to AEM as true
        system.debug(logginglevel.INFO,'Name$$' + (prod.Name).toLowerCase());
        system.debug(logginglevel.INFO,'value$$' + (prod.Name).toLowerCase().Contains('public records'));
        //DLT-16262 start .. Added public Addon product service numbers check to identify public addon.

        system.debug(logginglevel.INFO,'***prod.Service_Number__c::'+prod.Service_Number__c);
        
        if((prod.Name).toLowerCase().Contains('public records') || (addOnProducts!= null && addOnProducts.contains(prod.Service_Number__c)) ){  //DLT-16262   -Added OR condition                           
            addOnp.isPublicAddOn = true;
        }                     
        allProducts.put(prod.Id,addOnP);

    }

    //getPublicAddons()
    //Stores the strings for all products considerd Public Addons
    private void getPublicAddons(){
        List<DC_Global_Settings__mdt> globalSettingsmdt;  
        if (Schema.sObjectType.DC_Global_Settings__mdt.isAccessible()) {
            //DLT-16262         
            globalSettingsmdt= [SELECT Id,public_addon_products__c FROM DC_Global_Settings__mdt LIMIT 100]; 
        }
        
        system.debug(logginglevel.INFO,'globalSettings ***# '+globalSettingsmdt ); 

        for(DC_Global_Settings__mdt gsmdt: globalSettingsmdt){
            if(gsmdt.public_addon_products__c!= null && gsmdt.public_addon_products__c!= ''){
                addOnProducts = gsmdt.public_addon_products__c; 
            }
        }
        system.debug(logginglevel.INFO,'***addOnProducts ::'+addOnProducts );
    }

    /**
    * get max no of Attorney from Global Settings
    */ 
    /** 
     * @description : getMaxNoOfAttorneys
     * @param digitalFirm : Digital Firm
     */
    private void getMaxNoOfAttorneys(String digitalFirm){
        //DLT-13464 Starts
        List<DC_Max_Users_or_Attorneys__mdt> globalSetting = new List<DC_Max_Users_or_Attorneys__mdt>();
        Map<String,DC_Max_Users_or_Attorneys__mdt> firmToMaxNoAttorneyMap = new Map<String,DC_Max_Users_or_Attorneys__mdt>();

        if(Schema.sObjectType.DC_Max_Users_or_Attorneys__mdt.isQueryable()){
            globalSetting = [SELECT Max_No_Of_Attorneys__c,Max_No_Of_Per_Seat_Users__c,Segment__c 
                            FROM DC_Max_Users_or_Attorneys__mdt
                            LIMIT 100];
        }//End If
        for(DC_Max_Users_or_Attorneys__mdt maxAttorney : globalSetting){
            firmToMaxNoAttorneyMap.put(maxAttorney.Segment__c, maxAttorney);
        }

        if(firmToMaxNoAttorneyMap.containsKey(digitalFirm)){
            maxNoOfAttorneys = Integer.valueOf(firmToMaxNoAttorneyMap.get(digitalFirm).Max_No_Of_Attorneys__c);
            maxNoOfPerSeatUsers  = Integer.valueOf(firmToMaxNoAttorneyMap.get(digitalFirm).Max_No_Of_Per_Seat_Users__c);
        }             
    }

    /**
    * get price matrix for all products based on Pricing segment and attorneys
    */    
    /** 
     * @description : getPricematricesV2
     * @param productIds : Product id
     * @param segment : segment
     * @param firm : firm
     */
    private void getPricematricesV2(Set<String> productIds,String segment,String firm){
        Set<String> attorneys = new Set<String>();
        for(Integer i=1; i<= maxNoOfAttorneys; i++){
            attorneys.add(String.valueOf(i));
        }
        System.debug(logginglevel.INFO,'attorneys==>'+attorneys);
        Map<String,List<Pricematrix>> productIdToPriceMatrices1 = new Map<String,List<Pricematrix>>();
        Map<String,Pricematrix> surplusProductIdToPriceMatrix = new Map<String,Pricematrix>();
        List<Apttus_Config2__PriceMatrixEntry__c> entries = new List<Apttus_Config2__PriceMatrixEntry__c>();
        if(Schema.sObjectType.Apttus_Config2__PriceMatrixEntry__c.isAccessible()){
            entries =   [SELECT Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c, 
                        Apttus_Config2__Dimension1Value__c,Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c 
                        FROM  Apttus_Config2__PriceMatrixEntry__c   
                        WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__Dimension1Id__r.name = :STR_DIMENSION1_NAME  
                        AND Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c IN :productIds 
                        AND Apttus_Config2__Dimension1Value__c IN :attorneys 
                        AND Apttus_Config2__Dimension2Value__c =: segment ];
        } 
        for(Apttus_Config2__PriceMatrixEntry__c entry : entries){
            String productId = entry.Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c;
            Pricematrix matrix = new Pricematrix();
            matrix.quantity = Integer.valueOf(entry.Apttus_Config2__Dimension1Value__c);
            matrix.amount = entry.Apttus_Config2__AdjustmentAmount__c;
            
            if(productIdToQuantityPriceMatrices.get(productId) == null){
                productIdToQuantityPriceMatrices.put(productId, new Map<Integer,Pricematrix>());
            }
            productIdToQuantityPriceMatrices.get(productId).put(matrix.quantity,matrix);
            
        }

        //Populates the missing matrice between two ranges with the higer range.
        populateMissingPriceMatrix();
        
        for(String prodId : productIdToQuantityPriceMatrices.keySet()) {
            productIdToPriceMatrices.put(prodId, productIdToQuantityPriceMatrices.get(prodId).values());
        } 
        
        System.debug(logginglevel.INFO,JSON.serialize(productIdToPriceMatrices));
        
    }

    //populateMissingPriceMatrix()
    //Populating missing price matrix values between ranges with the higher range.
    private void populateMissingPriceMatrix(){
        for(String prodId : productIdToQuantityPriceMatrices.keySet()) {
            Pricematrix prevMatrix = null;
            for(Integer i = maxNoOfAttorneys; i >= 1; i--) {
                if(!productIdToQuantityPriceMatrices.get(prodId).keySet().contains(i)) {
                    if(prevMatrix == null) {
                        prevMatrix = new Pricematrix();
                        prevMatrix.amount = 0;
                    }
                    prevMatrix.quantity = i;
                    productIdToQuantityPriceMatrices.get(prodId).put(i, prevMatrix.clone());            
                }
                prevMatrix = productIdToQuantityPriceMatrices.get(prodId).get(i).clone();
            }
        }
    }

    private Map<String, List<OnlineContacts>> getOnlineContacts(String quoteId){
        System.debug(logginglevel.INFO,'quoteId > '+quoteId);
        //DLT-13389 - Defect : Add on page - Per seat not working
        //DLT-13389 - Added "Material__c" in SOQL query
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();
        if(Schema.sObjectType.Online_Contacts__c.isAccessible()){
            onlineContactList =[SELECT Id, ContactID__c, ProductId__c, Middle_Name__c, QuoteId__c, QuoteLineItem__c,  
                                    Product_Attribute__c, Material__c 
                                FROM Online_Contacts__c 
                                WHERE QuoteId__c = :quoteId];
        }
        Map<String, List<OnlineContacts>> prodIdOnlineContactMap = new Map<String, List<OnlineContacts>>();
        
        for(Online_Contacts__c onlineContact : onlineContactList) {
            OnlineContacts onc = new OnlineContacts();
            onc.contactSFId = onlineContact.Id;
            onc.contactExternalId = onlineContact.ContactID__c;
            
            //DLT-13389 - Defect : Add on page - Per seat not working
            //DLT-13389 - Changed map key from "ProductId__c" to "Material__c"
            if(!prodIdOnlineContactMap.keySet().contains(onlineContact.Material__c)){
                prodIdOnlineContactMap.put(onlineContact.Material__c, new List<OnlineContacts>());
            }
            prodIdOnlineContactMap.get(onlineContact.Material__c).add(onc);
        }
            
        return prodIdOnlineContactMap;
    }

    /** 
     * @description : AddOnResponse
     * @param responseMessage : response Message
     * @param responseCode : response Code
     * @param addOnDetails : add On Details
     */

    global class AddOnResponse{
        public String responseMessage;  
        public Integer responseCode;    
        public AddOnDetails addOnDetails;   
        
    }
    /** 
     * @description : AddOnDetails
     * @param quoteId : Quote id
     * @param quoteType : Quote Type
     * @param quantity : quantity
     * @param adjustmentType : Adjustment Type  
     * @param price : Price
     * @param adjustmentAmount : Adjustment Amount
     * @param contractTerm : Contract Term
     * @param maxNoOfPerSeatUsers : maxNoOfPerSeatUsers
     * @param oCCId :oCCId
     * @param oCCEmailId :oCCEmailId
     */
    public class AddOnDetails {
        private String quoteId;  
        private String quoteType;    
        private Integer quantity;    
        private String adjustmentType; 
        private Decimal price;
        private Decimal adjustmentAmount;
        private String contractTerm;
        private Integer maxNoOfPerSeatUsers;
        private string oCCId;
        private String oCCEmailId;
        private List<Product> addOnProducts = new List<Product>();
    }
    /** 
     * @description : Product
     * @param productId : Product id
     * @param productTitle : Product Title
     * @param shortDescription : Short description
     * @param material : Material  
     * @param longDescription : Long Description
     * @param jurisdiction : Jurisdiction
     * @param isSelected : is Selected
     * @param noOfUsers : No Of Users
     * @param priceMatrix :Price Matrix
     * @param onlineContacts :Online Contacts
     * @param pdfurl : pdfurl
     * @param pdfdescription :pdf description
     * @param videoURL :Video URL
     * @param videoDescription :Video description
     * @param videoLength :Video length
     * @param pdfSize :pdf Size
     * @param addOnTextCode :addOnTextCode
     * @param materialNumber :Material Number
     * @param isPublicAddOn :isPublicAddOn
     */
    public class Product {
        private String productId;    
        private String productTitle;
        private List<String> shortDescription; 
        private List<Material> material;
        private String longDescription;  
        private String jurisdiction;
        private String pricingModel;
        private Boolean isSelected;
        private Integer noOfUsers;
        private List<PriceMatrix> priceMatrix = new List<PriceMatrix>();
        private List<OnlineContacts> onlineContacts = new List<OnlineContacts>();
        private String pdfurl;//DLT-9683
        private String pdfdescription;
        private String videoURL;
        private String videoDescription;
        private String videoLength;
        private String pdfSize;
        private String addOnTextCode;
        private String materialNumber;
        private boolean isPublicAddOn;//DLT-15252                                        
    }
    /** 
     * @description : Material
     * @param materialId : Material id
     * @param materialNumber : Material name
     * @param materialDescription : Material Description
     * @param internalDescription : Internal Description  
     * @param classificationValue : Classification Value
     * @param classificationValueSortOrder : classification Value Sort Order
     * @param subscriptionNumber : Subscription Number
     * @param jurisdiction : Jurisdiction
     * @param productPlanId : Product PlanId
     * @param productGroup : Product Group
     * @param productGroupSortOrder : Product Group SortOrder
     * @param additionalInternalDescription :additional Internal Description
     */
    public class Material {
        private String materialId;
        private String materialNumber;
        private String materialDescription;
        private String internalDescription;
        private String classificationValue;
        private Integer classificationValueSortOrder;
        private String subscriptionNumber;
        private String jurisdiction;
        private String productPlanId;
        private String productGroup;
        private Integer productGroupSortOrder;
        private String additionalInternalDescription;
    }
 /** 
     * @description : PriceMatrix
     * @param quantity : quantity
     * @param amount : amount
     */
    public class PriceMatrix {
        private Integer quantity;    //10
        private Decimal amount;  //1749
    }
    /** 
     * @description : OnlineContacts
     * @param contactSFId : Contacts Fid
     * @param contactExternalId : contact external ID
     */
    public class OnlineContacts{
        private String contactSFId;
        private String contactExternalId;
    }
    
    
}