public class ProductSelectionController {
    //Properties
    public Opportunity oppty{get;set;}
    public Quote oQuote {get;set;}
    public string matrlType{get;set;}
    public string medHighLvl{get;set;}
    public string prodBusinesschannel{get;set;}
    public string prodCurrency {get;set;}
    public list <LATAMPRODUCT> latamProductList{get;set;}
    public string priceBook{get;set;}
    public boolean renewalOpty {get;set;}
    public Integer rowNum{get;set;}
    OpportunityLineItem objLine;
    quoteLineItem oqLine;
    public string redirectId;
    list<OpportunityLineItem> existingOppLineItemList = new list<OpportunityLineItem>();
    list<quoteLineItem> existingQuoteLineItemList = new list<quoteLineItem>();
    map<string,string>pricebookMap = new map <string,string>();
    set <integer> indexRow =  new set<Integer>();
    list<OpportunityLineItem> deleteLineDetails = new list <OpportunityLineItem>();
    list<Quotelineitem> deleteQuotelineItemList = new list <Quotelineitem>();
    public string objectName {get;set;}
    public boolean showWarning{get;set;}//MPC
    private string strSalesOrg ;//MPC
    public string reasonType{get;set;}    
    public string cancelComments{get;set;}
    public boolean boolChckRenew{get;set;}
    public boolean boolChckNotRenew{get;set;}      
    public List<OpportunityLineItem> lstSelectedOLI{get;set;} 
    public List<QuoteLineItem> lstSelectedQLI{get;set;}
    public list <LATAMPRODUCT> productListNotCancelled{get;set;} 
    public boolean boolChckPartlCncl{get;set;}
    public boolean boolChckPartlCncl1{get;set;}   
    
    public OpportunityLineItem objOpportunityLI    {get;set;}
    /*******************************************************************
        Purpose     : Constructor
    ********************************************************************/
    public ProductSelectionController() {        
        loadData();  //MPC  
        
    }
    /*******************************************************************
        Purpose     : LoadData- To display the data based on the selected filters
    ********************************************************************/
    private void LoadData(){
        try{
            Id sObjectid = ApexPages.currentPage().getParameters().get('id');
            oppty = new opportunity ();
            objOpportunityLI = new OpportunityLineItem ();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Oppty_Prod_Warning_Msg1));          
            if( sObjectid !=null){
                Schema.SObjectType sObjectName=sObjectid.getSObjectType();                
                system.debug('$$$sObjectName'+sObjectName);
                if(string.valueof(sObjectName).equalsIgnoreCase('Opportunity')){
                    oppty = [select id,recordType.Name, owner.sales_org__c,name,CurrencyIsoCode,Sub_Category__c,Renewal_Flag__c,Expiration_Date__c,Expected_Revenue_Date__c,Pricebook2Id,pricebook2.name,sales_org__c from opportunity where id =: sObjectid ];
                    strSalesOrg = oppty.sales_org__c;
                    redirectId = oppty.Id;
                    objectName = 'Opportunity';
                    //To check Renewal Record Type
                    if((oppty.Renewal_Flag__c == True && RecordtypeIds__c.getInstance('LATAM Renewal Opportunity') != NULL && oppty.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c)){
                        boolChckRenew=true; 
                        boolChckNotRenew=false;
                    }
                    else{
                        boolChckNotRenew=true;
                    }                    
                }
                else if(string.valueof(sObjectName).equalsIgnoreCase('Quote')){
                    oQuote = [select id,recordType.Name,Bill_To_Customer_Name__c,Opportunity.Expiration_Date__c,Opportunity.Expected_Revenue_Date__c,Renewal_Flag_Formula__c,Ship_To_Customer_Name__c, opportunity.owner.sales_org__c,name,CurrencyIsoCode,opportunity.sales_org__c,opportunity.Sub_Category__c,opportunity.Renewal_Flag__c,opportunity.Pricebook2Id,opportunity.pricebook2.name,Pricebook2Id,pricebook2.name from quote where id =: sObjectid ];
                    strSalesOrg = oQuote.opportunity.sales_org__c;
                    redirectId = oQuote.Id;
                    objectName = 'Quote';
                    //To check Renewal Record Type
                    if((oQuote.Renewal_Flag_Formula__c== True && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != Null && oQuote.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c)){
                        boolChckRenew=true;
                        boolChckNotRenew=false; 
                    }
                    else{
                        boolChckNotRenew=true;
                    }                    
                }
            }
            
            
            latamProductList = new list<LATAMPRODUCT>();
            productListNotCancelled = new list<LATAMPRODUCT>();
            if(oppty.Id !=null){
                prodCurrency = oppty.CurrencyIsoCode;                
                existingOppLineItemList = getoppLineitem(oppty.Id);
                if(!existingOppLineItemList.isEmpty()){
                    for (OpportunityLineItem oppLine:existingOppLineItemList){
                        LATAMPRODUCT oLatamProduct = null;
                        if(oppLine.RenewalCheck__c == true && oppLine.Activity_Type__c == 'Cancelled'){
                            oLatamProduct = new LATAMPRODUCT(oppLine, true);
                        }
                        else{
                            oLatamProduct = new LATAMPRODUCT(oppLine, false);
                        }                                               
                        //LATAMPRODUCT oLatamProduct = new LATAMPRODUCT(oppLine,false);
                        oLatamProduct.productName = oppLine.Product2.Name;
                        oLatamProduct.materialCode = oppLine.product2.ProductCode;
                        latamProductList.add(oLatamProduct);
                        system.debug('*****oppLine' + oppLine);
                        if(oppLine.RenewalCheck__c == true  && oppLine.Activity_Type__c == 'New' || oppLine.Activity_Type__c == 'Renewed' || oppLine.Activity_Type__c == 'Uplift' || oppLine.Activity_Type__c == 'Downgrade'){
                            system.debug('*****oppLine.Active_Status__c' + oppLine.Active_Status__c);   
                            productListNotCancelled.add(oLatamProduct);
                            system.debug('*****productListNotCancelled' + productListNotCancelled);  
                        }                        
                    }
                }
                if(oppty.Sub_Category__c == 'Renewal' || oppty.Renewal_Flag__c){
                    renewalOpty = True;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Oppty_Prod_Warning_Msg2));
                    
                }
            }
            else if(oQuote.Id!=null){
                prodCurrency = oQuote.CurrencyIsoCode;
                existingQuoteLineItemList = getQuoteLineitem(oQuote.Id);
                if(!existingQuoteLineItemList.isEmpty()){
                    for (quoteLineItem quoteLine:existingQuoteLineItemList){
                        LATAMPRODUCT oLatamProduct = null;
                        if(quoteLine.RenewalCheckQLI__c == true && quoteLine.Item_Activity_Type__c == 'Cancelled'){
                            oLatamProduct = new LATAMPRODUCT(quoteLine, true);
                        }
                        else{
                            oLatamProduct = new LATAMPRODUCT(quoteLine, false);
                        }
                        //LATAMPRODUCT oLatamProduct = new LATAMPRODUCT(quoteLine,false);
                        oLatamProduct.productName = quoteLine.Product2.Name;
                        oLatamProduct.materialCode = quoteLine.product2.ProductCode;
                        latamProductList.add(oLatamProduct);
                        if(quoteLine.RenewalCheckQLI__c == true && quoteLine.Item_Activity_Type__c == 'New' || quoteLine.Item_Activity_Type__c == 'Renewed' || quoteLine.Item_Activity_Type__c == 'Uplift' || quoteLine.Item_Activity_Type__c == 'Downgrade'){
                          productListNotCancelled.add(oLatamProduct);  
                        } 
                    }
                }
                if(oQuote.opportunity.Sub_Category__c == 'Renewal' || oQuote.opportunity.Renewal_Flag__c){
                    renewalOpty = True;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Oppty_Prod_Warning_Msg2));
                }
            }
            // Added for MPC
            //strSalesOrg = [Select sales_Org__c  From User Where Id = :UserInfo.getUserId() Limit 1].sales_Org__c;
            //Reading sales orgs from custom setting
            List<string> salesOrgsLst=new  List<string>();
            SET<string> salesOrgSet= new SET<string>();
            if(!Test.isRunningTest()){
                string strSalesOrgs= LatAmGeneral__c.getInstance('SalesOrgMCShowWarning').Value__C;                
                if(strSalesOrgs != ''){                        
                    salesOrgsLst= strSalesOrgs.split(','); 
                    salesOrgSet.addAll(salesOrgsLst);
                    if(salesOrgSet.contains(strSalesOrg)){
                        showWarning = true;
                    }
                    else
                    showWarning = false;  
                }
            }
            //MPC Ends
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, ex.getmessage()));
        }
        
    }

    /*******************************************************************
        Purpose     : Generates Material Type dropdown from Material Type custom settings
    ********************************************************************/
    public List<SelectOption> getMaterialTypeSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'ALL'));        
        // Find all the material in the custom setting
        Map<String, Material_Type__c> productMaterialType = Material_Type__c.getAll();
        // Sort them by name
        List<String> materialTypeList = new List<String>();
        materialTypeList.addAll(productMaterialType.keySet());
        materialTypeList.sort();
        // Create the Select Options.
        for (String materialType : materialTypeList) {
            options.add(new SelectOption(materialType, materialType));
        }
        return options;
    }
    /*******************************************************************
        Purpose     : Generates Active price book list
    ********************************************************************/
    public List<SelectOption> getActivePricebookList(){
        List<SelectOption> options = new List<SelectOption>();
        list<pricebook2> pricebookList = new list <pricebook2>();
        //for(Pricebook2 PriceBk2 :  [select Sales_Org__c, IsStandard ,IsActive,name from pricebook2 where IsActive = true order by name])
        //12/13/2016 : Mrinmoy Sarkar - Modified for loop for Hercules Implementation.
        String[] prBkNameFilters ;
        if(String.valueOf(oppty.Renewal_Flag__c)==Label.AllowPriceBook){
            prBkNameFilters = new String[]{'%ABEP%'};
        }
        else{
            
            prBkNameFilters = new String[]{'%ABEP%','%FSCO%'};
        }
        //for(Pricebook2 PriceBk2 :  [select Sales_Org__c, IsStandard ,IsActive,name from pricebook2 where IsActive = true and (NOT Name Like  '%ABEP%') order by name])
        for(Pricebook2 PriceBk2 :  [select Sales_Org__c, IsStandard ,IsActive,name from pricebook2 where IsActive = true and (NOT Name Like : prBkNameFilters) order by name])
        {
            options.add(new SelectOption(PriceBk2.name, PriceBk2.name));
            pricebookMap.put(PriceBk2.name,PriceBk2.id);
            pricebookList.add(PriceBk2);
        }
        for(Pricebook2 PriceBk:pricebookList){
            if(oppty.Id!=null){
                if(oppty.pricebook2.name!=null){
                    priceBook = oppty.pricebook2.name;
                    break;
                }
                else if(oppty.owner.sales_org__c!=null && PriceBk.Sales_Org__c!=null){
                    if(oppty.owner.sales_org__c == PriceBk.Sales_Org__c ){
                        priceBook=PriceBk.name;
                        break;
                    }
                }
                else if(oppty.owner.sales_org__c == null && PriceBk.IsStandard){
                    priceBook=PriceBk.name;
                    break;
                }
                else if(oppty.owner.sales_org__c != PriceBk.Sales_Org__c && PriceBk.Sales_Org__c == null && PriceBk.IsStandard){
                    priceBook=PriceBk.name;
                }
            }
            else if(oQuote.Id!=null){
                if(oQuote.pricebook2.name!=null){
                    priceBook = oQuote.pricebook2.name;
                    break;
                }
                else if(oQuote.Id!=null && oQuote.Opportunity.owner.sales_org__c!=null && PriceBk.Sales_Org__c!=null){
                    if(oQuote.Opportunity.owner.sales_org__c == PriceBk.Sales_Org__c ){
                        priceBook=PriceBk.name;
                        break;
                    }
                }
                else if(oQuote.Opportunity.owner.sales_org__c == null && PriceBk.IsStandard){
                    priceBook=PriceBk.name;
                    break;
                }
                else if(oQuote.Opportunity.owner.sales_org__c != PriceBk.Sales_Org__c && PriceBk.Sales_Org__c == null && PriceBk.IsStandard){
                    priceBook=PriceBk.name;
                }
            }
        }
        return options;
    }
    /*******************************************************************
        Purpose     : Generates Media HighLevel  dropdown from Product_Media_high_Level__c custom settings
    ********************************************************************/
    public List<SelectOption> getMediahighLevelSelectList() {
        List<string>mediahighLevel = new list<string>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'ALL'));        
        // Find all the material in the custom setting
        for (Product_Media_high_Level__c oPMhL : Product_Media_high_Level__c.getAll().values()){
            mediahighLevel.add(oPMhL.Name);
        }
        if(!mediahighLevel.isEmpty()){
            mediahighLevel.sort();
            for(string oMHL:mediahighLevel){
                options.add(new SelectOption(oMHL, oMHL));
            }
        }
        return options;
    }
    /*****************************************************************************************
        Purpose     : Generates Cancel Reason dropdown from QuoteLineItem as part of Renewals
    ******************************************************************************************/
    
    public List<SelectOption> getReasonTypeList() {
        List<string> lstReasonType = new list<string>();
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = QuoteLineItem.Cancel_Reason__c.getDescribe();
        List<Schema.PicklistEntry> lstPickValues = fieldResult.getPicklistValues();      
        options.add(new SelectOption('', '--None--'));
        if(!lstPickValues.isEmpty()){            
            for(Schema.PicklistEntry pickListValue : lstPickValues){
                options.add(new SelectOption(pickListValue.getLabel(), pickListValue.getValue()));
            }
        }
        return options;
    }
    /*******************************************************************
        Purpose     : Generates Business channelList  dropdown from Pro_Business_Channel__c custom settings
    ********************************************************************/
    public List<SelectOption> getBusinessChannelList() {
        List<string>businessChannel = new list<string>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'ALL'));        
        // Find all the material in the custom setting
        for (Pro_Business_Channel__c oBC : Pro_Business_Channel__c.getAll().values()){
            businessChannel.add(oBC.Name);
        }
        if(!businessChannel.isEmpty()){
            businessChannel.sort();
            for(string oMHL:businessChannel){
                options.add(new SelectOption(oMHL, oMHL));
            }
        }
        return options;
    }
    /*******************************************************************
        Purpose     : Used to Add product row
********************************************************************/
    public pagereference AddProduct(){
        system.debug('Enter AddProduct');
        if(oppty.Id != null){
            objLine = new OpportunityLineItem ();
            objLine.Revenue_Type__c = 'Incremental';
            objLine.quantity = 0;
            objLine.unitprice = 0;
            //To check Renewal Record Type
            
            System.debug('***oppty.Renewal_Flag__c****'+oppty.Renewal_Flag__c);
            System.debug('***RecordtypeIds__c****'+RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c);
            System.debug('***oppty.RecordTypeId__c****'+oppty.RecordTypeId);
            if(oppty.Renewal_Flag__c == True && RecordtypeIds__c.getInstance('LATAM Renewal Opportunity') != NULL && oppty.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c){
                
                objLine.Activity_Type__c = 'New';
                objLine.Active_Status__c = 'Active';
                objLine.Subscription_Start_Date__c = oppty.Expected_Revenue_Date__c;
                objLine.Subscription_End_Date__c = oppty.Expiration_Date__c;
                system.debug('*********Subscription Start Date:='+objLine.Subscription_Start_Date__c);
                system.debug('*********Subscription End Date:='+objLine.Subscription_End_Date__c);
                objLine.Last_Invoice_Price__c = 0.00;
                objLine.Projected_Renewal_Price__c = 0.00;         
            }
            latamProductList.add(new LATAMPRODUCT(objLine,false));
        }
        else if(oQuote.Id != null ){
            oqLine = new quoteLineItem ();
            oqLine.Revenue_Type__c = 'Incremental';
            oqLine.quantity = 0;
            oqLine.unitprice = 0;
            //To check Renewal Record Type
            if((oQuote.Renewal_Flag_Formula__c== True && RecordtypeIds__c.getInstance('LATAM Renewal Quote') != Null && oQuote.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c)){
                oqLine.Item_Activity_Type__c = 'New';
                oqLine.Status__c = 'Active';
                oqLine.Subscription_Start_Date__c = oQuote.Opportunity.Expected_Revenue_Date__c;
                oqLine.Subscription_End_Date__c = oQuote.Opportunity.Expiration_Date__c;
                oqLine.Projected_Renewal_Price__c = 0.00;
                oqLine.Last_Invoice_Price__c = 0.00;
            }
            latamProductList.add(new LATAMPRODUCT(oqLine,false));
        }   
        return null;
    }
    /*******************************************************************
        Purpose     : Used to Save the opportunityLineitem/Quotelineitem
********************************************************************/
    public pagereference SaveClose(){
        system.debug('$$$Save selected'+latamProductList);
        pagereference pr;
        try{
            boolean redirect = performValidation();
            system.debug('$$$redirect '+redirect);                            
            if(redirect){
                pr = new pagereference('/'+redirectId);
            }
            return pr;
        }
        catch(Exception ex){
            system.debug('$$$Save Error'+ex); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, ex.getDmlMessage(0)));
            return null;
        }
        return null;  
    }    
    /*******************************************************************************
        Purpose     : Used to Save and validate suggested price for the OLI/QLI
    ********************************************************************************/
    public PageReference SaveAndValidate() {
        try{
            system.debug('****************ss');
            boolean reload = performValidation();                            
            if(reload){
                loadData();
            }
        }
        catch(Exception ex){
            system.debug('$$$Save Error'+ex); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, ex.getDmlMessage(0)));
            
        }
        return null;
    }

    /*******************************************************************
        Purpose     : Used to Delete all the lines when price book is changed
    ********************************************************************/
    public pageReference deleteExistinglines(){
        system.debug('$$$pricebook123'+pricebookMap+pricebookMap.get(priceBook));
        try{
            latamProductList.clear();
            if(!existingOppLineItemList.isEmpty()){
                delete existingOppLineItemList;
            }
            if(!existingQuoteLineItemList.isEmpty()){
                delete existingQuoteLineItemList ;
            }
            if(pricebookMap.containskey(priceBook)){
                if(oppty.id!=null){
                    opportunity opp =new opportunity (id = oppty.id);
                    opp.pricebook2Id = pricebookMap.get(priceBook);
                    update opp;
                    Pagereference pg= new PageReference('/apex/productselection?id='+redirectId);
                    pg.setredirect(true);
                    return pg; 
                }else if(oQuote.id!=null){
                    Quote objQuote =new Quote(id = oQuote.id);
                    objQuote.pricebook2Id = pricebookMap.get(priceBook);
                    update objQuote;
                    Pagereference pg= new PageReference('/apex/productselection?id='+redirectId);
                    pg.setredirect(true);
                    return pg; 
                }
            }
            
        }catch (exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, ex.getmessage()));
            system.debug('$$$Exception'+ex);
        }   
        return null;
    }
    /*******************************************************************
        Purpose     : Used to navigate back to Opportunity or Quote
********************************************************************/
    public pageReference Cancel(){
        Pagereference pg= new PageReference('/'+redirectId);
        pg.setredirect(true);
        return pg; 
    }
    /*******************************************************************
        Purpose     : Used to oppportunitylineitem
        Parameters  : Oppid
        Returns     : Opportunitylineitem
********************************************************************/
    private list<OpportunityLineItem> getoppLineitem(string oppId){
        list<OpportunityLineItem>olineItemList = new list<OpportunityLineItem>();
        system.debug('$$$Enter'+oppId);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.OpportunityLineItem.fieldsets.Product_Selection.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Annual_Price__c,Name,pricebookentryid,Product2.Name,product2.ProductCode ,Cancel_Comments__c,OpportunityId ,quantity ,Reason_For_New_Product__c,Subscription_End_Date__c, Subscription_Start_Date__c, unitprice,Monthly_Charge_Calc__c,Ship_To_Customer_Name__c,Monthly_Charge_Suggested_Price__c,Cancel_Reason__c,Activity_Type__c,RenewalCheck__c,Monthly_Charge_Suggested_Total_Price_Msg__c, Active_Status__c FROM OpportunityLineItem Where opportunityId = :oppId ';
        
        system.debug('$$$Lineitem'+query);
        olineItemList = Database.query(query);
        return olineItemList;
    }
    /*******************************************************************
        Purpose     : Used to get Quotelineitems  
        Parameters  : QuoteId
        Returns     : Quotelineitem
********************************************************************/
    private list<quoteLineItem> getQuoteLineitem(string quoteId){
        list<quoteLineItem> QuotelineItemList = new list<quoteLineItem>();
        system.debug('$$$Enter'+quoteId);
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.QuoteLineItem.fieldsets.Product_Selection.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id,Annual_Price__c,pricebookentryid,Ship_To_Customer_Name__c,RenewalCheckQLI__c,Bill_To_Customer_Name__c,Reason_For_New_Product__c,Subscription_End_Date__c,Subscription_Start_Date__c,Product2.Name,Cancel_Comments__c,product2.ProductCode , quoteId ,quantity,unitprice,Monthly_Charge_Calc__c,Cancel_Reason__c,Item_Activity_Type__c ,Monthly_Charge_Suggested_Price__c,Status__c,Monthly_Charge_Suggested_Total_Price_Msg__c FROM QuoteLineItem Where quoteId = :quoteId ';
        system.debug('$$$Lineitem'+query);
        QuotelineItemList = Database.query(query);
        return QuotelineItemList;
    }
    /*******************************************************************
        Purpose     : Used for product search 
        Parameters  :product name , material type , Media high Level , Pricebook name , currency value , business channel and Renewal Identifier
        Returns     : Filtered list of pricebook entry
********************************************************************/
    @RemoteAction
    public static list<LATAMPRODUCT> searchProdut(string productName,string materialType,string mediaHighLevel,string pricebookname, string currencyValue,string businessChannel,boolean renewalIdentifier){
        boolean pricebookentryisActive = true;
        list<LatamProduct> filteredProductList = new List <LATAMPRODUCT>();
        list<LatamProduct> filteredRenewalProductList = new List <LATAMPRODUCT>();
        System.debug('$$$Product Name is: '+productName +'$$$'+materialType+'$$$'+mediaHighLevel+'$$$'+pricebookname);
        //Added for Fixing Production Issue afer May release: IM01981798.Query to get pricebooksalesorg
        string priceBookSalesorg = [select  Sales_Org__c from pricebook2 where name = :pricebookname].Sales_Org__c;
        system.debug('$$priceBookSalesorg '+priceBookSalesorg );
        string productQuery = 'Select Product2Id, Id, Product2.Name, Product2.ISBN__c, Product2.ProductCode, Product2.Description, UnitPrice, UseStandardPrice from PricebookEntry where (';
        productQuery += ' Product2.name like \'%' + String.escapeSingleQuotes(productName) + '%\'';
        productQuery += ' OR Product2.ProductCode like \'%' + String.escapeSingleQuotes(productName) + '%\'';
        productQuery += ' OR Product2.ISBN__c like \'%' + String.escapeSingleQuotes(productName) + '%\'';
        productQuery += ' OR Product2.Description like \'%' + String.escapeSingleQuotes(productName) + '%\')';
        productQuery += ' And isActive = :pricebookentryisActive ';
        if(materialType!=''){
            productQuery += ' And Product2.Material_Type__c = :materialType';
        }
        if(mediaHighLevel!=''){
            productQuery += ' And Product2.Media_High_Level__c = :mediaHighLevel';
        }
        if(currencyValue!=''){
            productQuery += ' And CurrencyIsoCode = :currencyValue';
        }
        if(businessChannel!=''){
            productQuery += ' And Product2.Business_Channel__c = :businessChannel';
        }
        productQuery += ' And Pricebook2.name = :pricebookname';
        productQuery += ' limit 50';
        system.debug('$$$productQuery'+productQuery +' '+renewalIdentifier);
        List<PricebookEntry> productList = Database.query(productQuery);
        for(PricebookEntry opriceBook: productList){
            filteredProductList.add(new LATAMPRODUCT(opriceBook));
        }
        system.debug('$$productList'+productList);
        //Criteria for renewal products
        //Modified query for fixing Production Issue afer May release: IM01981798.Added 'AND' condition for Sales_Org__c
        if(!renewalIdentifier && !productList.isEmpty()){
            set<string> productIdSet = new set <string>();
            set <string> productIdSetFiltered = new set <string>();
            for (PricebookEntry pbe : productList){
                productIdSet.add(pbe.Product2Id);
            }
            for(Sales_Area_Product_Info__c osales : [select id ,Product__c from Sales_Area_Product_Info__c where Product__c in :productIdSet and D_Chain_Material_Status__c ='ZO' and Sales_Org__c = :priceBookSalesorg]){
                productIdSetFiltered.add(osales.product__c);
            }
            for (PricebookEntry renewalPbe:productList){
                if(!productIdSetFiltered.contains(renewalPbe.Product2Id)){
                    filteredRenewalProductList.add(new LATAMPRODUCT(renewalPbe));
                }
            }
            system.debug('$$$filteredRenewalProductList'+ filteredRenewalProductList);
            return filteredRenewalProductList;
        }
        system.debug('$$$filteredProductList'+filteredProductList);
        return filteredProductList;
    }
    /*******************************************************************
        Purpose     : Used to store the delected Items
        Parameters  :
********************************************************************/
    public void delRow()
    {
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        system.debug('$$$IndexRow'+rowNum );  
        if(oppty.id!=null){
            if(latamProductList.get(rowNum).oppLine.id!=null){
                deleteLineDetails.add(latamProductList.get(rowNum).oppLine);
            }
            
        }else if(oQuote.Id!=null){
            if(latamProductList.get(rowNum).qLine.id!=null){
                deleteQuotelineItemList.add(latamProductList.get(rowNum).qLine);
            }
            
        }
        latamProductList.remove(rowNum);
        
    }    
    /*******************************************************************
        Purpose     : perform Validation and on successfull do DML
        Parameters  :
    ********************************************************************/
    public  boolean  performValidation(){
        list<OpportunityLineItem> upsertoppLineDetails = new list <OpportunityLineItem>();
        list<OpportunityLineItem> upsertoppLineCnclDetails = new list <OpportunityLineItem>();
        list<quoteLineItem> upsertQLineDetails = new list <quoteLineItem>();
        list<quoteLineItem> upsertQLineCnclDetails = new list <quoteLineItem>();
        integer iChckSizeCncl;
        if(RecordtypeIds__c.getInstance('LATAM Renewal Opportunity') != NULL && oppty.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c && oppty.Renewal_Flag__c == True){
            upsertoppLineCnclDetails = partialOLICancel();                    
            system.debug('*****upsertoppLineCnclDetails' + upsertoppLineCnclDetails);
        }       
        for(LATAMPRODUCT olatamProduct : latamProductList){
            system.debug('$$Latam lines'+olatamProduct.oppLine);
            if(oppty.Id != null ){
                system.debug('Step1.1');
                iChckSizeCncl = 0;
                if(olatamProduct.oppLine.Quantity == null || olatamProduct.oppLine.Quantity == 0){
                    olatamProduct.oppLine.Quantity.addError('You must enter a value');
                    return false;
                }
                if(olatamProduct.oppLine.unitPrice == null){
                    olatamProduct.oppLine.unitPrice.addError('You must enter a value');
                    return false;
                }
                if(RecordtypeIds__c.getInstance('LATAM Renewal Opportunity') != NULL && oppty.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c && oppty.Renewal_Flag__c == True){
                    if(olatamProduct.oppLine.Activity_Type__c == 'New' && olatamProduct.oppLine.Reason_For_New_Product__c == null){
                        olatamProduct.oppLine.Reason_For_New_Product__c.addError(System.Label.PartialCancelError);
                        return false;
                    }
                    
                }                                 
                if(upsertoppLineCnclDetails != null && !upsertoppLineCnclDetails.isEmpty()){
                    for(OpportunityLineItem objOli : upsertoppLineCnclDetails){
                        if(objOli.Id == olatamProduct.oppLine.Id){
                              system.debug('****objOli'+ objOli);
                              upsertoppLineDetails.add(objOli);
                        }
                        
                        else if(objOli.Id != olatamProduct.oppLine.Id){
                             iChckSizeCncl++; 
                        }
                        
                     } 
                     if(iChckSizeCncl == upsertoppLineCnclDetails.size()){
                         if(olatamProduct.oppLine.pricebookentryId!=null){
                                if(olatamProduct.oppLine.opportunityId == null){
                                    olatamProduct.oppLine.opportunityId = oppty.Id;
                                }
                                system.debug('****olatamProduct.oppLine1'+ olatamProduct.oppLine);
                                upsertoppLineDetails.add(olatamProduct.oppLine);
                            }       
                     } 
                 } 
                 else{
                    if(olatamProduct.oppLine.pricebookentryId!=null){
                        if(olatamProduct.oppLine.opportunityId == null){
                            olatamProduct.oppLine.opportunityId = oppty.Id;
                        }
                        system.debug('****olatamProduct.oppLine2'+ olatamProduct.oppLine);
                        upsertoppLineDetails.add(olatamProduct.oppLine);
                    }
                }
        
    }
    else if (oQuote.Id!=null ){
        system.debug('Step2.1');
        iChckSizeCncl = 0;
        if(olatamProduct.qLine.Quantity == null || olatamProduct.qLine.Quantity == 0){
            olatamProduct.qLine.Quantity.addError('You must enter a value');
            system.debug('Step2.2');
            return false;
        }
        if(olatamProduct.qLine.unitPrice == null){
            olatamProduct.qLine.unitPrice.addError('You must enter a value');
            system.debug('Step2.3');
            return false;
        }
        if(RecordtypeIds__c.getInstance('LATAM Renewal Quote') != Null && oQuote.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c && oQuote.Renewal_Flag_Formula__c== True){
            if(olatamProduct.qLine.Item_Activity_Type__c == 'New' && olatamProduct.qLine.Reason_For_New_Product__c == null){
                olatamProduct.qLine.Reason_For_New_Product__c.addError(System.Label.PartialCancelError);
                system.debug('Step2.4');
                return false;
            }
            upsertQLineCnclDetails = partialQLICancel();
            
        }
        
        if(upsertQLineCnclDetails != null && !upsertQLineCnclDetails.isEmpty()){
                for(QuoteLineItem qli : upsertQLineCnclDetails){
                    if(qli.Id == olatamProduct.qLine.Id){                                                 
                            upsertQLineDetails.add(qli);                            
                        }
                        
                        else if(qli.Id != olatamProduct.qLine.Id){
                             iChckSizeCncl++; 
                        }
                        
                     } 
                     if(iChckSizeCncl == upsertQLineCnclDetails.size()){
                         if(olatamProduct.qLine.pricebookentryId!=null){
                                if(olatamProduct.qLine.QuoteId == null){
                                    olatamProduct.qLine.QuoteId = oQuote.Id;
                                }                               
                                /*if(oQuote.Ship_To_Customer_Name__c !=null){
                                    olatamProduct.qLine.Ship_To_Customer_Name__c = oQuote.Ship_To_Customer_Name__c; 
                                }*/
                                if(oQuote.Bill_To_Customer_Name__c !=null){
                                     olatamProduct.qLine.Bill_To_Customer_Name__c = oQuote.Bill_To_Customer_Name__c;
                                }
                                upsertQLineDetails.add(olatamProduct.qLine);
                            }       
                     } 
                 } 
                 else{
                    if(olatamProduct.qLine.pricebookentryId!=null){
                                if(olatamProduct.qLine.QuoteId == null){
                                    olatamProduct.qLine.QuoteId = oQuote.Id;
                                }
                                if(RecordtypeIds__c.getInstance('LATAM Renewal Quote') != Null && oQuote.RecordTypeId != RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c && oQuote.Renewal_Flag_Formula__c != True){
                                    if(oQuote.Ship_To_Customer_Name__c !=null){
                                        olatamProduct.qLine.Ship_To_Customer_Name__c = oQuote.Ship_To_Customer_Name__c; 
                                    }
                                }
                                if(oQuote.Bill_To_Customer_Name__c !=null){
                                     olatamProduct.qLine.Bill_To_Customer_Name__c = oQuote.Bill_To_Customer_Name__c;
                                }
                                upsertQLineDetails.add(olatamProduct.qLine);
                            } 
                }
    }
}
        if(boolChckPartlCncl == true && upsertoppLineCnclDetails == null){
            system.debug('Step3');
            return false;
        }
        else{
            System.debug('**upsertoppLineDetails'+ upsertoppLineDetails);
            if(!upsertoppLineDetails.isEmpty()){
                if(oppty.pricebook2Id == null){
                    oppty.pricebook2Id = pricebookMap.get(priceBook);
                    update oppty;
                }
                System.debug('**upsertoppLineDetails'+ upsertoppLineDetails);
                List<OpportunityLineItem> oliInsertList = new List<OpportunityLineItem>();
                List<OpportunityLineItem> oliUpdateList = new List<OpportunityLineItem>();
                for(OpportunityLineItem toli : upsertoppLineDetails){
                    if(toli.ID == null){oliInsertList.add(toli);}
                    else{oliUpdateList.add(toli);}
                    
                }
                update oliUpdateList;
                insert oliInsertList;
                //upsert upsertoppLineDetails;    //saperated DMLs for insert and update due to recursive check issue.
            }
        }
        if(boolChckPartlCncl == true && upsertQLineCnclDetails == null){
            system.debug('Step4');
            return false;
        }
        else{
            if(!upsertQLineDetails.isEmpty()){
                if(oQuote.pricebook2Id == null){
                    oQuote.pricebook2Id = pricebookMap.get(priceBook);
                    update oQuote;
                }
                System.debug('**upsertQLineDetails'+ upsertQLineDetails);
                List<QuoteLineItem> qliInsertList = new List<QuoteLineItem>();
                List<QuoteLineItem> qliUpdateList = new List<QuoteLineItem>();
                for(QuoteLineItem tqli : upsertQLineDetails){
                    if(tqli.ID == null){qliInsertList.add(tqli);}
                    else{qliUpdateList.add(tqli);}
                    
                }
                update qliUpdateList;
                insert qliInsertList;
                //upsert upsertQLineDetails; //saperated DMLs for insert and update due to recursive check issue.
            }
        }
        if(!deleteLineDetails.isEmpty()){
            delete deleteLineDetails;
            deleteLineDetails.clear();
        }
        if(!deleteQuotelineItemList.isEmpty()){
            delete deleteQuotelineItemList;
            deleteQuotelineItemList.clear();
        }
        return true;
    }
    /*******************************************************************
        Purpose     : Wrapper class to store opportunityLineItem and QuoteLineitem
        Parameters  :
********************************************************************/
    public class LATAMPRODUCT{
        public OpportunityLineItem oppLine {get;set;}
        public QuoteLineItem qLine {get;set;}
        public boolean isSelected {get;set;}
        public string productName {get;set;}
        public string materialCode {get;set;}
        public PricebookEntry pbe{get;set;}
        public string unitPriceInLocale {get;set;}
        //Used for opportunity Product
        public LATAMPRODUCT (OpportunityLineItem oLineItem,boolean isSelected){
            this.oppLine=oLineItem;
            //this.isSelected=false;
            this.isSelected=isSelected;
            this.productName = productName;
            this.materialCode = materialCode;

        }
        //used for Quotelinitem
        public LATAMPRODUCT (QuoteLineItem oQLineItem,boolean isSelected){
            this.qLine=oQLineItem;
            //this.isSelected=false;
            this.isSelected=isSelected;
            this.productName = productName;
            this.materialCode = materialCode; 
            
        }
        //Used to convert the unit price as per user's Locale 
        public LATAMPRODUCT (PricebookEntry oPricebookEntry){
            this.pbe=oPricebookEntry;
            this.unitPriceInLocale = (oPricebookEntry.UnitPrice == null ? '' : oPricebookEntry.UnitPrice.format());
            
        }

    }

    /*******************************************************************
        Purpose     : Partial Cancel Of OpportunityLineItem and QuoteLineItem
        Parameters  :
    ******************************************************************/

    public List<OpportunityLineItem> partialOLICancel(){
        system.debug('****************ssvv');
        system.debug('****************latamProductList '+ latamProductList);
            boolChckPartlCncl = false;
            list<OpportunityLineItem> lstOLICancelDetails = new list <OpportunityLineItem>();
            list<OpportunityLineItem> lstUnselectedOLI = new list <OpportunityLineItem>();
            system.debug('****************');
            lstSelectedOLI = new List<OpportunityLineItem>();                        
            if(oppty.id!=null){
            
                if(latamProductList != null && !latamProductList.isEmpty()){
                   for(LATAMPRODUCT wrapLTProd : latamProductList){
                      if(wrapLTProd.isSelected == false){ 
                         lstUnselectedOLI.add(wrapLTProd.oppLine); 
                      }   
                   } 
                }
                if(lstUnselectedOLI != null && !lstUnselectedOLI.isEmpty()){                   
                   for(OpportunityLineItem objOLIunselected : lstUnselectedOLI){
                       if(objOLIunselected.Activity_Type__c == 'Cancelled'){
                          objOLIunselected.Activity_Type__c = 'Renewed';
                          objOLIunselected.Cancel_Reason__c = '';
                          objOLIunselected.Cancel_Comments__c = '';
                          objOLIunselected.Cancel_Date__c = null;                                                   
                          objOLIunselected.Active_Status__c = 'Active';
                          lstOLICancelDetails.add(objOLIunselected); 
                       }
                   } 
                }
                if((productListNotCancelled != null && !productListNotCancelled.isEmpty()) || (lstOLICancelDetails != null && !lstOLICancelDetails.isEmpty())){
                    for(LATAMPRODUCT wrapLTProd : productListNotCancelled){
                    
                        if(wrapLTProd.isSelected == true && wrapLTProd.oppLine.Activity_Type__c != 'Cancelled'){
                            boolChckPartlCncl = true;
                            lstSelectedOLI.add(wrapLTProd.oppLine);
                            //lstSelectedQLI.add(wrapLTProd.qLine);
                        }
                    }
                
                    system.debug('********productListNotCancelled.size()'+ productListNotCancelled.size());
                    system.debug('********lstSelectedQLI.size()'+ lstSelectedOLI.size());
                    if((productListNotCancelled.size() == 1 && productListNotCancelled.size() == lstSelectedOLI.size())){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PartialCanclOneProduct));                     
                        return null;
                    } 
                    if(productListNotCancelled.size() == lstSelectedOLI.size()){                    
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PartialCanclAllProduct));                     
                        return null;
                    }
                    
                    
                    if(lstSelectedOLI != null && !lstSelectedOLI.isEmpty()){                         
                        for(OpportunityLineItem objOLIselected:lstSelectedOLI){
                            system.debug('********cancelComments'+ cancelComments);
                            system.debug('********Cancel_Comments__c'+ objOLIselected.Cancel_Comments__c);
                            
                            system.debug('********reasonType'+ reasonType);
                            if(objOpportunityLI.Cancel_Reason__c == null){
                                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PartialCancelError));
                                objOLIselected.Cancel_Reason__c.addError(System.Label.PartialCancelError);
                                return null;
                            }
                            if(cancelComments.trim() == ''){
                                objOLIselected.Cancel_Comments__c.addError(System.Label.PartialCancelError);
                                return null;
                            }        
                                    
                            objOLIselected.Cancel_Reason__c = objOpportunityLI.Cancel_Reason__c;
                            objOLIselected.Cancel_Comments__c = cancelComments;
                            objOLIselected.Cancel_Date__c = Date.today();
                            objOLIselected.UnitPrice = 0.00;
                            //objOLIselected.TotalPrice = 0.00;
                            objOLIselected.Active_Status__c = 'Cancelled';
                            objOLIselected.Activity_Type__c = 'Cancelled';                                            
                            lstOLICancelDetails.add(objOLIselected);                        
                        }
                    }  
                    if(!lstOLICancelDetails.isEmpty() && lstOLICancelDetails != null){                        
                        cancelComments = ' ';
                        reasonType = '';  
                        System.debug('^^^^'+lstOLICancelDetails);
                        return lstOLICancelDetails;
                        
                    }         
                }
            }            
                        
        cancelComments = ' ';
         reasonType = ''; 
        return null;    
    }
    public List<QuoteLineItem> partialQLICancel(){
        list<QuoteLineItem> lstUnselectedQLI  = new list <QuoteLineItem>();
        list<QuoteLineItem> lstQLICancelDetails = new list <QuoteLineItem>();
        lstSelectedQLI = new list <QuoteLineItem>();
        boolChckPartlCncl = false;
         if(oQuote.Id!=null){
                if(latamProductList != null && !latamProductList.isEmpty()){
                   for(LATAMPRODUCT wrapLTProd : latamProductList){
                      if(wrapLTProd.isSelected == false){ 
                         lstUnselectedQLI.add(wrapLTProd.qLine); 
                      }   
                   } 
                }
                if(lstUnselectedQLI != null && !lstUnselectedQLI.isEmpty()){                   
                   for(QuoteLineItem objQLIunselected : lstUnselectedQLI){
                       if(objQLIunselected.Item_Activity_Type__c == 'Cancelled'){
                          objQLIunselected.Item_Activity_Type__c = 'Renewed';
                          objQLIunselected.Cancel_Reason__c = '';
                          objQLIunselected.Cancel_Comments__c = '';
                          objQLIunselected.Cancel_Date__c = null;                          
                          objQLIunselected.Status__c = 'Active';
                          lstQLICancelDetails.add(objQLIunselected); 
                       }
                   } 
                }
                if((productListNotCancelled != null && !productListNotCancelled.isEmpty()) || (lstQLICancelDetails != null && !lstQLICancelDetails.isEmpty())){
                    for(LATAMPRODUCT wrapLTProd : productListNotCancelled){
                        if(wrapLTProd.isSelected == true && wrapLTProd.qLine.Item_Activity_Type__c != 'Cancelled'){
                            //lstSelectedOLI.add(wrapLTProd.oppLine);
                            system.debug('StepSS');
                            boolChckPartlCncl = true;
                            lstSelectedQLI.add(wrapLTProd.qLine);
                        }
                    } 
                 
                    if((productListNotCancelled.size() == 1 && productListNotCancelled.size() == lstSelectedQLI.size())){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PartialCanclOneProduct));                     
                        return null;
                    } 
                    if(productListNotCancelled.size() == lstSelectedQLI.size()){                    
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PartialCanclAllProduct));                     
                        return null;
                    }           
                
                
                    if(lstSelectedQLI != null && !lstSelectedQLI.isEmpty()){
                        System.debug('lstSelectedQLI---->'+lstSelectedQLI);
                        for(QuoteLineItem objQLIselected:lstSelectedQLI){
                            
                            if(objOpportunityLI.Cancel_Reason__c == null){
                                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.PartialCancelError));
                                objQLIselected.Cancel_Reason__c.addError(System.Label.PartialCancelError);
                                return null;
                            }
                            system.debug('********cancelComments'+ cancelComments); 
                            if(cancelComments.trim() == ''){
                                objQLIselected.Cancel_Comments__c.addError(System.Label.PartialCancelError);
                                return null;
                            }        
                            objQLIselected.Cancel_Reason__c = objOpportunityLI.Cancel_Reason__c;
                            objQLIselected.Cancel_Comments__c = cancelComments;
                            objQLIselected.Cancel_Date__c = Date.today();
                            objQLIselected.UnitPrice = 0.00;
                            objQLIselected.Status__c = 'Cancelled'; 
                            objQLIselected.Item_Activity_Type__c = 'Cancelled';                                                                   
                            lstQLICancelDetails.add(objQLIselected);                        
                        }
                    }
                
                
                    if(!lstQLICancelDetails.isEmpty() && lstQLICancelDetails != null){                        
                        System.debug('**lstQLICancelDetails'+ lstQLICancelDetails);
                        cancelComments = ' ';
                        reasonType = ''; 
                        return lstQLICancelDetails;    
                    }
               }
           } 
           cancelComments = ' ';
        reasonType = '';    
        return null;       
    }

}