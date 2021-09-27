/*
======================================================================================================================
NAME: SourceSystemDetailController
======================================================================================================================
PURPOSE:    functionality for creation of New SSD from Opportunity.

CHANGE HISTORY:
======================================================================================================================
DATE                  NAME                           DESC

2017-10-05            Priyanka                     created as per JIRA STORY: CRM-7429
2018-09-24            Shiva                        DLT-12501 - created method for creating SSD Instance
that can be used from other classes
2019-06-24            Poorva                     Modified as part of Tax Proffessional Stories 
2020-02-27            Khushboo                     Modified as part of DOC-9884 for Tax Professional
======================================================================================================================
*/
public without sharing class SourceSystemDetailController {
    
    public Opportunity opp{get;set;}
    public Apttus_Proposal__Proposal__c prop{get;set;}
    public String OppId{get;set;}
    public Source_System_Detail__c sourceSysDetail{get;set;}
    public static User us{get;set;}
    public Id acc;
    public static final string USL_RECORDTPYE='USL_Source_Systems';
    public string selectedCurrencyName{get;set;}
    public string selectedIndustryName{get;set;}
    public string selectedCustomerGroupName{get;set;}
    public string selectedsalesOrgName{get;set;} // created as a part of DOC-860
    public List<Selectoption> CustomerGroup{get; set;}
    public List<Selectoption> Industry{get; set;}
    public List<Selectoption> Currency1{get; set;}
    public List<SelectOption> CountryOptions {get;set;}
    public List<SelectOption> CountryRegionOptions {get;set;}
    public static final string LOTUS_TAX_RECORDTYPE = 'USL_Source_Systems';
    public boolean LOTUS_TAX_CHECK {get;set;}
    public boolean bTaxSalesOrgS100Check {get;set;}
    public String subbu {get;set;}
    public String segment {get;set;}
    public static Integer defaultCall;
    private static String proposalId;
    public Account accRec {get;set;}
    public Boolean  displayFirstCreateSeg {get;set;}
    public String urlVal {get;set;}
    public String selectedCreateOption {get;set;}
    public String objname1;
    public Boolean backOptionflag{get;set;}
    public static String accName{get;set;}
    public Integer name1Len{get;set;}
    public Integer street1Len{get;set;}
    public Integer street2Len{get;set;}
    public Integer street3Len{get;set;}
    public Integer street4Len{get;set;}
    public boolean latamtaxsec{get;set;}
    public List<Selectoption> taxnumbertypelist{get;set;}
    public string selectedtaxnumbertype{get;set;}
    
    public SourceSystemDetailController(){
        
        String opId = string.escapeSingleQuotes('Id');
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(opId ))) {
            OppId = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(opId)));
        }
        Id objname = (Id.valueOf(OppId));
        objname1 = objname.getSObjectType().getDescribe().getName();
        if(objname1 == 'Opportunity' && Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.isQueryable()){
            opp = [Select id,account.name,accountId,LCRM_Sub_BU__c from Opportunity where id=: OppId];
        }
        else if(objname1 == 'Apttus_Proposal__Proposal__c' && Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
            prop = [Select id,APTS_Proposal_Business_Unit__c,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where id=: OppId];
        }
        //DOC-12752-Commented as part of CrossSell
        /*User usr1 =new User();
        usr1 = [select DefaultCurrencyIsoCode, Sub_Bu__c,Segment__c from User where id=:UserInfo.getUserId()];
        subbu = usr1.Sub_Bu__c;
        segment = usr1.Segment__c;*/
        urlVal = (String)(string.escapeSingleQuotes(Apexpages.currentPage().getUrl())); //Added as part of DOC-8652 for Tax Profeessional-
        System.debug('urlVal  : '+urlVal);
        List<String> displayFirstCreateSegList = (KeyValueListStore__c.getValues('TaxSSDSegmentList')!=null && 
                                                  KeyValueListStore__c.getValues('TaxSSDSegmentList').TextValue__c!=null && 
                                                  KeyValueListStore__c.getValues('TaxSSDSegmentList').TextValue__c!='')?KeyValueListStore__c.getValues('TaxSSDSegmentList').TextValue__c.split(';'):new List<String>();
        Boolean ssdOptionflag = (urlVal.contains('billToSSD') || urlVal.contains('shipToSSD') || urlVal.contains('payerSSD'))?true:false;
        Account acc1 = new Account();
        if(objname1 == 'Opportunity'){
            acc1 = queryAcc(opp.accountId);
            sourceSysDetail = SourceSystemDetailController.createSSDInstance(OppId, opp.accountId);
        }else if(objname1 == 'Apttus_Proposal__Proposal__c'){
            acc1 = queryAcc(prop.Apttus_Proposal__Account__c);
            sourceSysDetail = SourceSystemDetailController.createSSDInstance(OppId, prop.Apttus_Proposal__Account__c);
        }
        //sourceSysDetail = SourceSystemDetailController.createSSDInstance(OppId, acc1);
        
        accRec = new Account();
        accRec = acc1;
        //Boolean taxUserflag = LCRMGenericComponent.validateTaxProfUser();
        LOTUS_TAX_CHECK = false;
        bTaxSalesOrgS100Check = false;
        latamtaxsec = false;
        string currencyISO;
        //System.debug('segment : '+segment);
        System.debug('ssdOptionflag : '+ssdOptionflag);
        System.debug('displayFirstCreateSegList : '+displayFirstCreateSegList);
        selectedCreateOption = 'createSSD';
        displayFirstCreateSeg = false;
        defaultCall = 0;
        if(prop != null && displayFirstCreateSegList.contains(prop.APTS_Proposal_Business_Unit__c) && ssdOptionflag == true){
            accRec = new Account();
            backOptionflag = true;
            displayFirstCreateSeg = true;
            selectedCreateOption = NULL;
            LOTUS_TAX_CHECK = true;
            this.CountryOptions = DataQualityUtil.listAvailableCountryOptions();
            accRec.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Create_New_Account').getRecordTypeId();
            accRec.Bu_Segment__c = acc1.Bu_Segment__c;
            /*accRec.ECC_Top_Named_Law_Firms__c = acc1.ECC_Top_Named_Law_Firms__c;
            accRec.ECC_Number_of_Attorneys__c = acc1.ECC_Number_of_Attorneys__c;
            accRec.ECC_Number_Of_Employees__c = acc1.ECC_Number_Of_Employees__c;
            accRec.ECC_Top_Named_Corporations__c = acc1.ECC_Top_Named_Corporations__c;
            accRec.ECC_Annual_Revenue__c = acc1.ECC_Annual_Revenue__c;
            accRec.ECC_Government_Type__c = acc1.ECC_Government_Type__c;*/
        }
        System.debug('displayFirstCreateSeg : '+displayFirstCreateSeg);
        System.debug('selectedCreateOption : '+selectedCreateOption);
        getsalesorg();
        //DOC-12752-Commented as part of CrossSell
        /*if(taxUserflag){
            LOTUS_TAX_CHECK = true;
            defaultCall = 0;
            system.debug('defaultCall : '+defaultCall);
            currencyISO = (String)usr1.DefaultCurrencyIsoCode;
            sourceSysDetail.Billing_Currency__c =  currencyISO;
            sourceSysDetail.CurrencyIsoCode =  currencyISO;   
            sourceSysDetail.LCRM_Sales_Org__c = Label.SALESORGS100;
            selectedsalesOrgName = Label.SALESORGS100;
            refreshCGroupandIndustry();           
        }*/
        sourceSysDetail.Name = abrString(sourceSysDetail.Name, 'Name', ((selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.LCRM_Name_2__c = abrString(sourceSysDetail.LCRM_Name_2__c, 'Name', ((selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.LCRM_Name_3__c = abrString(sourceSysDetail.LCRM_Name_3__c, 'Name', ((selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.Number_Street__c = abrString(sourceSysDetail.Number_Street__c, 'Address', 35);
        sourceSysDetail.LCRM_Street_2__c = abrString(sourceSysDetail.LCRM_Street_2__c, 'Address', 35);
        sourceSysDetail.LCRM_Street3__c = abrString(sourceSysDetail.LCRM_Street3__c, 'Address', 35);
        sourceSysDetail.LCRM_Street4__c = abrString(sourceSysDetail.LCRM_Street4__c, 'Address', 35);
        name1Len = sourceSysDetail.Name.length();
        street1Len = sourceSysDetail.Number_Street__c.length();
        street2Len = sourceSysDetail.LCRM_Street_2__c.length();
        street3Len = sourceSysDetail.LCRM_Street3__c.length();
        street4Len = sourceSysDetail.LCRM_Street4__c.length();
    }
    
    public Pagereference clickedBack(){
        PageReference pg;    
        pg = new PageReference(string.escapeSingleQuotes(urlVal));
        pg.setRedirect(true);
        return pg;
    }
    
    public Account queryAcc(Id accId){
        Account acc1=new Account();
        if(!Schema.sObjectType.Account.isAccessible() && !Schema.sObjectType.Account.isQueryable()){
            return null;
        }
        system.debug('accId : '+accId);
            acc1 = [Select id,name,billingcity,billingstate,BillingStateCode,billingstreet,billingcountry,BillingCountryCode,billingpostalcode,phone,
                fax,nameTwo__c,Namethree__c,website,Street_Address_2__c,Street_Address_3__c,Street_Address_4__c,
                PO_Box__c,County__c,Sales_Org__c,Industry,Customer_Group__c, Customer_Class_c__c, 
                Industry_LatAm__c, Tax_3__c, Tax_4__c, Tax_Number__c, Tax_Number_Type__c, Bu_Segment__c,
                ECC_Top_Named_Law_Firms__c, ECC_Number_of_Attorneys__c, ECC_Number_Of_Employees__c,
                ECC_Top_Named_Corporations__c, ECC_Annual_Revenue__c, ECC_Government_Type__c 
                from Account where id =:accId];
        system.debug('acc1 : '+acc1);
        return acc1;
    }
    
    public void clickedAccountWithSSD(){
        displayFirstCreateSeg = false;
        selectedCreateOption = 'createAccWithSSD';
        if(LOTUS_TAX_CHECK)
        {
            defaultCall = 0;   
        }  
        //refreshCGroupandIndustry();
        System.debug('displayFirstCreateSeg : '+displayFirstCreateSeg);
        System.debug('selectedCreateOption : '+selectedCreateOption);
        System.debug('defaultCall : '+defaultCall);
    }
    
    public void clickedSSDOnly(){
        displayFirstCreateSeg = false;
        selectedCreateOption = 'createSSD';
        if(LOTUS_TAX_CHECK)
        {
            defaultCall = 0;   
        }
        if(objname1 == 'Opportunity'){
            accRec = queryAcc(opp.accountId);
        }else if(objname1 == 'Apttus_Proposal__Proposal__c'){
            accRec = queryAcc(prop.Apttus_Proposal__Account__c);
        }  
        //propvalue = apexpages.currentPage().getParameters().get('Id');
        //Id newId = Id.valueOf(propvalue);
        //prop = [Select id,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where id=: newId];
        //refreshCGroupandIndustry();
        System.debug('displayFirstCreateSeg : '+displayFirstCreateSeg);
        System.debug('selectedCreateOption : '+selectedCreateOption);
        System.debug('defaultCall : '+defaultCall);
    }
    
    public static Source_System_Detail__c createSSDInstance(Id oppId, Id accId){
        //DOC-12752-Commented as part of CrossSell
        /*us=new User();        
        if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable()){
            us = [ Select id, Sub_Bu__c,DefaultCurrencyIsoCode FROM User WHERE id = :UserInfo.getUserId()];
        }*/
        // Recordtype rec = [select id from recordtype where SobjectType='source_system_detail__c' and DeveloperName =:USL_RECORDTPYE];
        Account acc1=new Account(); 
         if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.isQueryable()){
             acc1 = [Select id,name,billingcity,billingstate,BillingStateCode,billingstreet,billingcountry,BillingCountryCode,billingpostalcode,phone,
                fax,nameTwo__c,Namethree__c,website,Street_Address_2__c,Street_Address_3__c,Street_Address_4__c,
                PO_Box__c,County__c,Sales_Org__c,Industry,Customer_Group__c, Customer_Class_c__c, 
                Industry_LatAm__c, Tax_3__c, Tax_4__c, Tax_Number__c, Tax_Number_Type__c, Bu_Segment__c,
                ECC_Top_Named_Law_Firms__c, ECC_Number_of_Attorneys__c, ECC_Number_Of_Employees__c,
                ECC_Top_Named_Corporations__c, ECC_Annual_Revenue__c, ECC_Government_Type__c 
                from Account where id =:accId];
         }
        Id recordTypeId = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();   
        Source_System_Detail__c ssdInstance = new Source_System_Detail__c (recordtypeid = recordTypeId );
        ssdInstance.Country__c = acc1.BillingCountry ;
        ssdInstance.City__c = acc1.billingcity;
        ssdInstance.Number_Street__c = acc1.billingstreet;
        ssdInstance.State__c = acc1.BillingState;
        ssdInstance.Postal_Code__c = acc1.billingpostalcode;
        ssdInstance.County__c = acc1.County__c;
        ssdInstance.LCRM_Phone__c = acc1.phone;
        ssdInstance.LCRM_Fax__c = acc1.fax;
        ssdInstance.LCRM_Name_3__c = acc1.Namethree__c;
        ssdInstance.LCRM_Name_2__c = acc1.nameTwo__c;
        ssdInstance.LCRM_Website__c = acc1.website;
        ssdInstance.LCRM_PO_Box__c = acc1.PO_Box__c;
        ssdInstance.LCRM_Street_2__c = acc1.Street_Address_2__c; //Poorva
        ssdInstance.LCRM_Street3__c = acc1.Street_Address_3__c;
        ssdInstance.LCRM_Street4__c = acc1.Street_Address_4__c;
        ssdInstance.LCRM_Street_2__c = acc1.Street_Address_2__c;
        ssdInstance.Account_Name__c = acc1.Id;
        ssdInstance.name = acc1.name;
        ssdInstance.Source_System_Name__c = acc1.name;
        accName = acc1.Name;
        //DOC-12752-Commented as part of CrossSell
        /*Boolean taxUserflag = LCRMGenericComponent.validateTaxProfUser();
        if(taxUserflag){
            String currencyISO = (String)us.DefaultCurrencyIsoCode;
            ssdInstance.Billing_Currency__c =  currencyISO;
            ssdInstance.CurrencyIsoCode =  currencyISO;   
            ssdInstance.LCRM_Sales_Org__c = Label.SALESORGS100; 
            System.debug('TestSalesorg'+ssdInstance.LCRM_Sales_Org__c);
        }*/ 
        return ssdInstance;
    }
    public List<Selectoption> fetchIndustry(string salesorg){
        List<Selectoption> IndustryList = new List<selectoption>();
        IndustryList.add(new selectOption('', '- None -'));
        for(GLIPicklistValues__c gli :  GLIPicklistValues__c.getall().values() ){
            if(salesorg != null && salesorg != ''){
                if(gli.Picklist_Salesorg__c.contains(salesorg) && gli.Picklist_Field_For__c.equalsIgnoreCase ('Industry')){
                    IndustryList.add(new selectoption(gli.Picklist_Lov__c,gli.Picklist_Lov__c));
                }
            }    
        }
        IndustryList.sort();
        return IndustryList; 
    }
    public List<Selectoption> fetchCustomerGroup(string salesorg){
        List<Selectoption> customerGroupList = new List<selectoption>();
        customerGroupList.add(new selectOption('', '- None -'));
        List<GLIPicklistValues__c> allCustomerGroup = new List<GLIPicklistValues__c>();
        for(GLIPicklistValues__c gli :  GLIPicklistValues__c.getall().values() ){
            if(salesorg != null && salesorg != ''){
                if(gli.Picklist_Salesorg__c.contains(salesorg)&& gli.Picklist_Field_For__c.equalsIgnoreCase ('CustomerGroup')){
                    customerGroupList.add(new selectoption(gli.Picklist_Lov__c,gli.Picklist_Lov__c));
                }
            }    
        }
        return customerGroupList; 
    }
    //DOC-3724: To display currency options at SSD creation page
    public List<Selectoption> getCurrency1(string salesorg){
        List<Selectoption> currencyList = new List<selectoption>();
        if(salesorg != null && salesorg != '' && salesorg == 'TA61'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('GBP', 'GBP'));
            currencyList.add(new selectOption('EUR', 'EUR'));
            currencyList.add(new selectOption('CHF', 'CHF'));
            currencyList.add(new selectOption('USD', 'USD')); //DOC-4823
         }
        else if(salesorg != null && salesorg != '' && salesorg == 'CARS'){
            currencyList.add(new selectOption('CAD', 'CAD'));           
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'TSL'){
            currencyList.add(new selectOption('BRL', 'BRL')); 
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'SMHK'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('HKD', 'HKD')); 
            currencyList.add(new selectOption('GBP', 'GBP')); 
            currencyList.add(new selectOption('USD', 'USD'));          
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'INWL'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('INR', 'INR')); 
            currencyList.add(new selectOption('USD', 'USD'));          
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'LRA'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('AUD', 'AUD')); 
            currencyList.add(new selectOption('GBP', 'GBP')); 
            currencyList.add(new selectOption('USD', 'USD'));          
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'BKRS'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('AUD', 'AUD')); 
            currencyList.add(new selectOption('NZD', 'NZD')); 
            currencyList.add(new selectOption('USD', 'USD'));          
        } 
        else if(salesorg != null && salesorg != '' && salesorg == 'TRFR'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('AUD', 'AUD')); 
            currencyList.add(new selectOption('IDR', 'IDR')); 
            currencyList.add(new selectOption('JPY', 'JPY')); 
            currencyList.add(new selectOption('KRW', 'KRW'));
            currencyList.add(new selectOption('MXN', 'MXN'));
            currencyList.add(new selectOption('MYR', 'MYR')); 
            currencyList.add(new selectOption('SGD', 'SGD')); 
            currencyList.add(new selectOption('GBP', 'GBP'));
            currencyList.add(new selectOption('TWD', 'TWD')); 
            currencyList.add(new selectOption('USD', 'USD'));          
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'SMGE'){
            currencyList.add(new selectOption('', '- None -'));
            currencyList.add(new selectOption('EUR', 'EUR')); 
            currencyList.add(new selectOption('GBP', 'GBP'));
            currencyList.add(new selectOption('USD', 'USD'));          
        }
        else if(salesorg != null && salesorg != '' && salesorg == 'LLEY'){
            currencyList.add(new selectOption('ARS', 'ARS'));          
        }
        /*else if(salesorg != null && salesorg != '' && salesorg == 'Duzon'){
            currencyList.add(new selectOption('KRW', 'KRW'));           
        }*/ 
        else{
            currencyList.add(new selectOption('USD', 'USD'));
            selectedcurrencyName = 'USD';
            system.debug('Sales Org Value in West block'+selectedCurrencyName);
            apexpages.currentpage().getparameters().put('USD', selectedCurrencyName);
        }
        return currencyList;         
    }
    
    public List<Selectoption> getsalesorg(){
        List<Selectoption> salesOrgList = new List<selectoption>();
        //DOC-12752-Commented as part of CrossSell
        /*Set<String> SubBuWestSet=new Set<String>{'Findlaw','LMS','USL'};
            us=new User();    
        system.debug('InsideGetsalesorg***');    
        if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.isQueryable()){
            us = [ Select id, Sub_Bu__c,Segment__c FROM User WHERE id = :UserInfo.getUserId()];
        }
        if(us.Sub_Bu__c == Label.SALESORGTAXREG || us.Segment__c == Label.SALESORGTAX){
            salesOrgList.add(new selectOption('', '- None -'));    
            salesOrgList.add(new selectOption('S100', 'S100'));
            salesOrgList.add(new selectOption('TA61', 'TA61'));       
            salesOrgList.add(new selectoption('TA78','TA78'));         
            salesOrgList.add(new selectOption('CARS', 'CARS')); 
            salesOrgList.add(new selectOption('WEST', 'WEST')); 
            System.debug('defaultCall : '+defaultCall);
            if(defaultCall == 0){
                selectedsalesOrgName = Label.SALESORGS100;
                if(LOTUS_TAX_CHECK)
                {
                    bTaxSalesOrgS100Check = true;    
                }  
                defaultCall =1;
            }
            refreshCGroupandIndustry();
        }else if(us.Segment__c != null && (us.Segment__c == Label.SALESORGCORP || us.Segment__c == Label.SUBBUGLOBAL  )){
            salesOrgList.add(new selectOption('', '- None -'));
            salesOrgList.add(new selectOption('CARS', 'CARS')); 
            salesOrgList.add(new selectOption('S100', 'S100'));
            salesOrgList.add(new selectoption('TA78','TA78')); 
            salesOrgList.add(new selectoption('TA61','TA61')); 
            salesOrgList.add(new selectOption('WEST', 'WEST')); 
        }
        else if(us.Sub_Bu__c == Label.SALESORGCAN){
            salesOrgList.add(new selectOption('', '- None -'));
            salesOrgList.add(new selectoption('CARS','CARS')); 
            selectedsalesOrgName = 'CARS';
            refreshCGroupandIndustry();
        }
        else if(us.Segment__c != null && (us.Sub_Bu__c == Label.SUBBUGLOBAL  || us.Segment__c == Label.SUBBUGLOBAL  )){*/
            salesOrgList.add(new selectOption('', '- None -'));
            salesOrgList.add(new selectOption('BKRS', 'BKRS'));
            salesOrgList.add(new selectOption('CARS', 'CARS')); 
            salesOrgList.add(new selectOption('INWL', 'INWL'));
            salesOrgList.add(new selectOption('LLEY', 'LLEY'));
            salesOrgList.add(new selectOption('LRA', 'LRA'));
            /*salesOrgList.add(new selectOption('1S-Russia', '1S-Russia'));
            salesOrgList.add(new selectOption('Duzon', 'Duzon'));*/
            salesOrgList.add(new selectOption('S100', 'S100'));
            salesOrgList.add(new selectOption('SMHK', 'SMHK'));
            salesOrgList.add(new selectOption('SMGE', 'SMGE'));
            salesOrgList.add(new selectoption('TA78','TA78')); 
            salesOrgList.add(new selectoption('TA61','TA61')); 
        salesOrgList.add(new selectOption('TRFR', 'TRFR'));
            salesOrgList.add(new selectOption('TSL', 'TSL'));
            salesOrgList.add(new selectOption('WEST', 'WEST')); 
            refreshCGroupandIndustry();
        /*}

        else {
            salesOrgList.add(new selectOption('WEST', 'WEST')); 
            selectedsalesOrgName = 'WEST';
            refreshCGroupandIndustry();
        }      
        System.debug('selectedsalesOrgName : '+selectedsalesOrgName);*/  
        return salesOrgList; 
    }
    
    public void refreshCGroupandIndustry(){
        String  selectedSalesorg,selectedSalesorg1,salesOrgChanged,salesOrgChanged1;
        selectedSalesorg1 = string.escapeSingleQuotes('salesorg');
        salesOrgChanged1 = string.escapeSingleQuotes('salesOrgChanged');
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(selectedSalesorg1))) {
            selectedSalesorg = (string)(string.escapeSingleQuotes(apexpages.currentpage().getparameters().get(selectedSalesorg1)));
        }
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(salesOrgChanged1))) {
            salesOrgChanged = (string)(string.escapeSingleQuotes(apexpages.currentpage().getparameters().get(salesOrgChanged1)));
        }
        System.debug('selectedSalesorg : '+selectedSalesorg+' : salesOrgChanged : '+salesOrgChanged);
        if(salesOrgChanged == 'true'){
            selectedsalesOrgName = selectedSalesorg;
        }
        //apexpages.currentpage().getparameters().put('salesorg', selectedsalesOrgName);
        CustomerGroup = new List<Selectoption>();
        Industry = new List<Selectoption>();
        Currency1= new List<Selectoption>();
        Currency1 = getCurrency1(selectedsalesOrgName);
        CustomerGroup = fetchCustomerGroup(selectedsalesOrgName);
        Industry = fetchIndustry(selectedsalesOrgName); 
        System.debug('selectedsalesOrgName : '+selectedsalesOrgName );        
        if(selectedsalesOrgName != Label.SALESORGS100)
        {
            bTaxSalesOrgS100Check = false;
        }
        else
        {
            bTaxSalesOrgS100Check = true;
        }
        System.debug('bTaxSalesOrgS100Check : '+bTaxSalesOrgS100Check );
        if(selectedsalesOrgName == 'LLEY' || selectedsalesOrgName == 'TSL'){
            latamtaxsec = true;
            gettaxnumbertypeList();
        }else{
            latamtaxsec = false;
        }
        /*sourceSysDetail.Name = abrString(sourceSysDetail.Name, 'Name', ((selectedsalesOrgName ==null || selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.LCRM_Name_2__c = abrString(sourceSysDetail.LCRM_Name_2__c, 'Name', ((selectedsalesOrgName ==null || selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.LCRM_Name_3__c = abrString(sourceSysDetail.LCRM_Name_3__c, 'Name', ((selectedsalesOrgName ==null || selectedsalesOrgName == Label.SALESORGS100)?40:35));    
        name1Len = sourceSysDetail.Name.length();*/
    }  
    
    public void addressCountryChanged(){
        String selectedvalue,selectedvalue1;
        selectedvalue1 = string.escapeSingleQuotes('CountryOptions');
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get(selectedvalue1))) {
            selectedvalue = (String)(string.escapeSingleQuotes(apexpages.currentPage().getParameters().get(selectedvalue1)));
        }
        System.debug('selectedvalue : '+selectedvalue );
        accRec.BillingCountryCode = selectedvalue;
        this.CountryRegionOptions = DataQualityUtil.listAvailableCountryRegionOptions(selectedvalue);
        System.debug('CountryRegionOptions : '+this.CountryRegionOptions);
    }

    public void gettaxnumbertypeList(){
        taxnumbertypeList = new List<Selectoption>();
        taxnumbertypeList.add(new selectOption('', '- None -'));
        if (Schema.sObjectType.Latam_Tax_Number_Type__mdt.isAccessible()){
            for(Latam_Tax_Number_Type__mdt txnm : [Select MasterLabel, Tax_Number_Code__c, Tax_Number_Desc__c from Latam_Tax_Number_Type__mdt ORDER BY Tax_Number_Code__c]){
                taxnumbertypeList.add(new selectoption(txnm.Tax_Number_Desc__c,txnm.Tax_Number_Desc__c));
            }
       }
    }    
    
    public Pagereference saveSSD(){
        sourceSysDetail.Name = abrString(sourceSysDetail.Name, 'Name', ((selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.LCRM_Name_2__c = abrString(sourceSysDetail.LCRM_Name_2__c, 'Name', ((selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.LCRM_Name_3__c = abrString(sourceSysDetail.LCRM_Name_3__c, 'Name', ((selectedsalesOrgName == Label.SALESORGS100)?40:35));
        sourceSysDetail.Number_Street__c = abrString(sourceSysDetail.Number_Street__c, 'Address', 35);
        sourceSysDetail.LCRM_Street_2__c = abrString(sourceSysDetail.LCRM_Street_2__c, 'Address', 35);
        sourceSysDetail.LCRM_Street3__c = abrString(sourceSysDetail.LCRM_Street3__c, 'Address', 35);
        sourceSysDetail.LCRM_Street4__c = abrString(sourceSysDetail.LCRM_Street4__c, 'Address', 35);
        name1Len = sourceSysDetail.Name.length();
        street1Len = sourceSysDetail.Number_Street__c.length();
        street2Len = sourceSysDetail.LCRM_Street_2__c.length();
        street3Len = sourceSysDetail.LCRM_Street3__c.length();
        street4Len = sourceSysDetail.LCRM_Street4__c.length();
        Savepoint sp = Database.setSavepoint();
        system.debug('Sales Org Value = ' + selectedsalesOrgName);
        system.debug('$$$$ PS -  Value invalid issue inside save' + selectedIndustryName);
        sourceSysDetail.Source_System_Name__c = (selectedsalesOrgName == Label.SALESORGS100)?'HANA':'ENTWRP';
        if(selectedCreateOption == 'createAccWithSSD'){
            accRec.Account_Name_2__c = sourceSysDetail.LCRM_Name_2__c;
            accRec.Account_Name_3__c = sourceSysDetail.LCRM_Name_3__c;
            //System.debug('accRec : before save : '+accRec);
            //upsert accRec;
            //System.debug('accRec : after save : '+accRec);
            sourceSysDetail.name = accRec.name;
            sourceSysDetail.Country__c = accRec.BillingCountryCode ;
            sourceSysDetail.City__c = accRec.billingcity;
            sourceSysDetail.Number_Street__c = accRec.billingstreet;
            sourceSysDetail.State__c = accRec.BillingStateCode;
            sourceSysDetail.Postal_Code__c = accRec.billingpostalcode;
            sourceSysDetail.County__c = accRec.County__c;
            //sourceSysDetail.LCRM_Name_3__c = accRec.Namethree__c;
            //sourceSysDetail.LCRM_Name_2__c = accRec.nameTwo__c;
            sourceSysDetail.LCRM_PO_Box__c = accRec.PO_Box__c;
            sourceSysDetail.LCRM_Street_2__c = ''; 
            sourceSysDetail.LCRM_Street3__c = ''; 
            sourceSysDetail.LCRM_Street4__c = ''; 
            //sourceSysDetail.Account_Name__c = accRec.Id;
            sourceSysDetail.LCRM_Phone__c = '';
            sourceSysDetail.LCRM_Fax__c = '';
        }
        String errorMsg = '';
        if(selectedCreateOption == 'createAccWithSSD'){
            if(accRec.Name !='' &&  accRec.Name !=null){
                if(selectedsalesOrgName == Label.SALESORGS100 && String.valueOf(accRec.Name).length() >40){
                    errorMsg = errorMsg + 'Number of Account Name characters should be less than equal 40.<br/>';
                }else if(String.valueOf(sourceSysDetail.Name).length() >35){
                    errorMsg = errorMsg + 'Number of Account Name characters should be less than equal 35.<br/>';
                }
            }
            if(accRec.BillingStreet!='' &&  accRec.BillingStreet!=null){
                if(String.valueOf(sourceSysDetail.Name).length() >35){
                        errorMsg = errorMsg + 'Number of Street characters should be less than equal 35.<br/>';
                }
            }
        }
        if(selectedsalesOrgName== null || selectedsalesOrgName==''){
            errorMsg = errorMsg + 'Sales Org is required.<br/>';
        }
        system.debug('Customer Group = '+selectedCustomerGroupName);
        system.debug('selectedsalesOrgName = '+selectedsalesOrgName);
        if((selectedCustomerGroupName == null || selectedCustomerGroupName =='') && selectedsalesOrgName != Label.SALESORGS100){
            errorMsg = errorMsg + 'Customer Group is required.<br/>';
        }
        if((selectedIndustryName== null || selectedIndustryName=='') && selectedsalesOrgName != Label.SALESORGS100){
            errorMsg = errorMsg + 'Industry is required.<br/>';
        }
        if(selectedCurrencyName== null || selectedCurrencyName==''){
            errorMsg = errorMsg + 'Currency is required.<br/>';
        }
        if(sourceSysDetail.Name =='' || sourceSysDetail.Name ==null){
            errorMsg = errorMsg + 'Source System Account Name is required.<br/>';
        }
        If(sourceSysDetail.Name !='' &&  sourceSysDetail.Name !=null && selectedCreateOption != 'createAccWithSSD'){
            //Added by Kruti Shah for DOC-10475
            if(selectedsalesOrgName == Label.SALESORGS100){
                if(String.valueOf(sourceSysDetail.Name).length() >40){
                    errorMsg = errorMsg + 'Number of Chars in Source System Account Name should be less than equal 40.<br/>';
                }
            }else{
                if(String.valueOf(sourceSysDetail.Name).length() >35){
                    errorMsg = errorMsg + 'Number of Chars in Source System Account Name should be less than equal 35.<br/>';
                }
            }
        }
        If(sourceSysDetail.LCRM_Name_2__c!='' &&  sourceSysDetail.LCRM_Name_2__c !=null){
            //Added by Kruti Shah for DOC-10475
            if(selectedsalesOrgName == Label.SALESORGS100){
                if(String.valueOf(sourceSysDetail.LCRM_Name_2__c).length() >40){
                    errorMsg = errorMsg + 'Number of Chars in Name 2 should be less than equal 40.<br/>';
                }
            }else{
                if(String.valueOf(sourceSysDetail.LCRM_Name_2__c).length() >35){
                    errorMsg = errorMsg + 'Number of Chars in Name 2 should be less than equal 35.<br/>';
                }
            }
        }
        If(sourceSysDetail.LCRM_Name_3__c!='' &&  sourceSysDetail.LCRM_Name_3__c !=null){
            //Added by Kruti Shah for DOC-10475
            if(selectedsalesOrgName == Label.SALESORGS100){
                if(String.valueOf(sourceSysDetail.LCRM_Name_3__c).length() >40){
                    errorMsg = errorMsg + 'Number of Chars in Name 3 should be less than equal 40.<br/>';
                }
            }else{
                if(String.valueOf(sourceSysDetail.LCRM_Name_3__c).length() >35){
                    errorMsg = errorMsg + 'Number of Chars in Name 3 should be less than equal 35.<br/>';
                }
            }
        }
        if((selectedtaxnumbertype =='' || selectedtaxnumbertype ==null) && (selectedsalesOrgName == 'LLEY' || selectedsalesOrgName == 'TSL')){
            errorMsg = errorMsg + 'Tax Number Type is required.<br/>';
        }
        if((sourceSysDetail.LCRM_Tax_Number__c == '' || sourceSysDetail.LCRM_Tax_Number__c == null) && (selectedsalesOrgName == 'LLEY' || selectedsalesOrgName == 'TSL')){
            errorMsg = errorMsg + 'Tax Number is required.<br/>';
        }else if((sourceSysDetail.LCRM_Tax_Number__c !=null && String.valueOf(sourceSysDetail.LCRM_Tax_Number__c).length() > 16) && (selectedsalesOrgName == 'LLEY' || selectedsalesOrgName == 'TSL')){
            errorMsg = errorMsg + 'Number of Chars in Tax Number should be less than or equal to 16.<br/>';
        }
        if((sourceSysDetail.LCRM_Tax_3__c !=null && String.valueOf(sourceSysDetail.LCRM_Tax_3__c).length() > 18) && (selectedsalesOrgName == 'LLEY' || selectedsalesOrgName == 'TSL')){
            errorMsg = errorMsg + 'Number of Chars in Tax Number 3 should be less than or equal to 18.<br/>';
        }
        if((sourceSysDetail.LCRM_Tax_4__c !=null && String.valueOf(sourceSysDetail.LCRM_Tax_4__c).length() > 18) && (selectedsalesOrgName == 'LLEY' || selectedsalesOrgName == 'TSL')){
            errorMsg = errorMsg + 'Number of Chars in Tax Number 4 should be less than or equal to 18.<br/>';
        }
        if((sourceSysDetail.Number_Street__c=='' || sourceSysDetail.Number_Street__c==null) && selectedCreateOption != 'createAccWithSSD'){
            errorMsg = errorMsg + 'Number of Street is required.<br/>';
        }
        if(sourceSysDetail.Number_Street__c!='' &&  sourceSysDetail.Number_Street__c!=null && String.valueOf(sourceSysDetail.Number_Street__c).length() >35){
            errorMsg = errorMsg + 'Number of Chars in Street should be less than equal 35.<br/>';
        }
        if(sourceSysDetail.LCRM_Street_2__c!='' &&  sourceSysDetail.LCRM_Street_2__c!=null && String.valueOf(sourceSysDetail.LCRM_Street_2__c).length() >35){
            errorMsg = errorMsg + 'Number of Chars in Street 2 should be less than equal 35.<br/>';
        }
        if(sourceSysDetail.LCRM_Street3__c!='' &&  sourceSysDetail.LCRM_Street3__c!=null && String.valueOf(sourceSysDetail.LCRM_Street3__c).length() >35){
            errorMsg = errorMsg + 'Number of Chars in Street 3 should be less than equal 35.<br/>';
        }
        if(sourceSysDetail.LCRM_Street4__c!='' &&  sourceSysDetail.LCRM_Street4__c!=null && String.valueOf(sourceSysDetail.LCRM_Street4__c).length() >35){
            errorMsg = errorMsg + 'Number of Chars in Street 4 should be less than equal 35.<br/>';
        }
        if(errorMsg !=null && errorMsg !=''){
            ApexPages.Message errorMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, '<br/>'+errorMsg);
            ApexPages.addMessage(errorMsg1);
            return null;
        }
        
        system.debug(urlVal);
        String prId;
        try{
            if(selectedCreateOption == 'createAccWithSSD'){
                System.debug('accRec : before save : '+accRec);
                if (Schema.sObjectType.Account.isUpdateable() && Schema.sObjectType.Account.isCreateable()){
                    upsert accRec;
                }
                System.debug('accRec : after save : '+accRec);
                sourceSysDetail.Account_Name__c = accRec.Id;
            }
            system.debug('$$$$ PS -  Value invalid issue inside try method of save' + selectedIndustryName);
            sourceSysDetail.LCRM_Industry__c =selectedIndustryName;
            sourceSysDetail.LCRM_Industry__c =selectedIndustryName;
            sourceSysDetail.LCRM_Customer_Group__c =selectedCustomerGroupName;
            sourceSysDetail.LCRM_Sales_Org__c = selectedsalesOrgName;  
            sourceSysDetail.CurrencyIsoCode = selectedCurrencyName; 
            sourceSysDetail.Billing_Currency__c = selectedCurrencyName;
            sourceSysDetail.LatAm_Tax_Number_Type__c = selectedtaxnumbertype;
            
            if (!Schema.sObjectType.Source_System_Detail__c.isCreateable()) {
                System.debug('Schema.sObjectType.Source_System_Detail__c.isCreateable()**'+Schema.sObjectType.Source_System_Detail__c.isCreateable());
                return null;
            }  
            system.debug('kh**'+sourceSysDetail);
            insert sourceSysDetail;
            
            //Updated and Added as part of DOC-8652 for Tax Profeessional By Poorva
            if(objname1 == 'Opportunity'){
                opp.Source_system_detail__c = sourceSysDetail.Id;
                if (Schema.sObjectType.Opportunity.isUpdateable()) {
                    update opp;
                }
            }else{                
                //prId = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('propId')));
                system.debug('Entered in save ..Proposal Id:' +OppId);
                Apttus_Proposal__Proposal__c prop = [select id from Apttus_Proposal__Proposal__c where id= :OppId];
                //prop.Id  = pId;
                if(urlVal.contains('shipToSSD')){
                    prop.APTS_SSD_ship_to__c = sourceSysDetail.Id;
                    if(selectedCreateOption == 'createAccWithSSD'){
                        prop.Apttus_QPConfig__ShipToAccountId__c = accRec.Id;
                    }
                }else if(urlVal.contains('billToSSD')){
                    prop.APTS_SSD_bill_to__c = sourceSysDetail.Id;    
                    if(selectedCreateOption == 'createAccWithSSD'){
                        prop.Apttus_QPConfig__BillToAccountId__c = accRec.Id;
                    }
                }else if(urlVal.contains('payerSSD')){
                    prop.APTS_Payer__c = sourceSysDetail.Id;
                }
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                    update prop;
                }
            }
        }catch(Exception e){
            Database.rollback(sp);
            accRec.ID = null;
            System.debug('msg : '+e.getMessage());
            System.debug('msg trace : '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage())); 
            return null;
        }
        PageReference pg;    
        /*if(objname1 == 'Opportunity'){
        pg = new PageReference('/'+opp.Id);
        }else{
        pg = new PageReference('/'+prId);
        }*/
        pg = new PageReference('/'+OppId);
        pg.setRedirect(true);
        return pg;
        
    }
    public Pagereference cancel(){
        String urlVal = Apexpages.currentPage().getUrl(); //Added as part of DOC-8652 for Tax Professional-
        PageReference pg;    
        pg = new PageReference('/'+OppId);
        pg.setRedirect(true);
        return pg;
        
    }
    
    public static String replaceIgnoreCase(String replace, String with, String inText) {
        String replaceLower = replace.toUpperCase();
        String inTextLower = inText.toUpperCase();
        Integer indexOfTag = inTextLower.indexOf(replaceLower);
        if(indexOfTag > -1) {
            String replaceAsInText = inText.substring(indexOfTag, (indexOfTag+replace.length()));
            inText = inText.replace(replaceAsInText, with);
            inText = replaceIgnoreCase(replace, with, inText);
        }
        return inText;
    }
    
    public static String replaceAllMultiWord(String inputStr, String type, Map<String, String> nameMap, Map<String, String> addMap){
        if(type == 'Name'){
            for(String str : nameMap.keySet()){
                if(inputStr.containsIgnoreCase(str)){
                    inputStr = replaceIgnoreCase(str, nameMap.get(str), inputStr);
                }
            }
        }else if(type == 'Address'){
            for(String str : addMap.keySet()){
                if(inputStr.containsIgnoreCase(str)){
                    inputStr = replaceIgnoreCase(str, addMap.get(str), inputStr);
                }
            }
        }
        return inputStr;
    }
    
    public static String replaceAllSingleWord(String inputStr, String type, Map<String, String> nameMap, Map<String, String> addMap){
        List<String> seperatorList = new List<String>{' ',',','-'};
        String outputStr = '';
        Boolean flag = false;
        for(String primarySep : seperatorList){
            if(inputStr.contains(primarySep)){
                flag = true;
                for(String str : inputStr.split(primarySep)){
                    String tempStr = str;
                    System.debug('str : '+str);
                    for(String secondarySep : seperatorList){
                        if(tempStr.contains(secondarySep)){
                            tempStr = replaceAllSingleWord(tempStr, type, nameMap, addMap);
                        } 
                    }
                    if(type == 'Name'){
                        if(nameMap!=null && nameMap.keySet().contains(str.trim().toUpperCase())){
                            tempStr = tempStr.replaceAll(str.trim(), nameMap.get(str.trim().toUpperCase()));
                        }
                    }else if(type == 'Address'){
                        if(addMap!=null && addMap.keySet().contains(str.trim().toUpperCase())){
                            tempStr = tempStr.replaceAll(str.trim(), addMap.get(str.trim().toUpperCase()));
                        }
                    }
                    outputStr = (outputStr ==null || outputStr =='')? tempStr  : outputStr + primarySep + tempStr;
                    system.debug('outputStr : '+outputStr );
                }
                if(inputStr.startsWith(primarySep) && !outputStr.startsWith(primarySep)){
                    outputStr = primarySep + outputStr;
                }
                if(inputStr.endsWith(primarySep) && !outputStr.endsWith(primarySep)){
                    outputStr = outputStr + primarySep;
                }
                break;
            }
        }
        if(flag==false){
            String tempStr = inputStr;
            if(type == 'Name'){
                if(nameMap!=null && nameMap.keySet().contains(inputStr.trim().toUpperCase())){
                    tempStr = tempStr.replaceAll(inputStr.trim(), nameMap.get(inputStr.trim().toUpperCase()));
                }
            }else if(type == 'Address'){
                if(addMap!=null && addMap.keySet().contains(inputStr.trim().toUpperCase())){
                    tempStr = tempStr.replaceAll(inputStr.trim(), addMap.get(inputStr.trim().toUpperCase()));
                }
            }
            outputStr = tempStr;
            //outputStr = inputStr;
        }
        return outputStr;
    }
    
    public static String abrString(String inputStr, String type, Integer sizeLimit){
        if(inputStr == null || inputStr == ''){
            return '';
        }
        inputStr = inputStr;
        String outputStr = '';
        Map<String, String> multiWordNameAlwaysMap = new Map<String,String>();
        Map<String, String> oneWordNameAlwaysMap = new Map<String,String>();
        Map<String, String> multiWordNotNameAlwaysMap = new Map<String,String>();
        Map<String, String> oneWordNotNameAlwaysMap = new Map<String,String>();
        Map<String, String> multiWordAddAlwaysMap = new Map<String,String>();
        Map<String, String> oneWordAddAlwaysMap = new Map<String,String>();
        Map<String, String> multiWordNotAddAlwaysMap = new Map<String,String>();
        Map<String, String> oneWordNotAddAlwaysMap = new Map<String,String>();
        for(APTS_SSD_Abreviation__mdt ssdAbr : [Select MasterLabel, Abbreviation__c, Always_Applicable__c, Category__c, More_than_a_word__c from APTS_SSD_Abreviation__mdt where Is_Active__c=TRUE ORDER BY MasterLabel DESC]){
            if(ssdAbr.Category__c.contains('Name')){
                if(ssdAbr.Always_Applicable__c==true){
                    if(ssdAbr.More_than_a_word__c==true){
                        multiWordNameAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }else{
                        oneWordNameAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }
                }else{
                    if(ssdAbr.More_than_a_word__c==true){
                        multiWordNotNameAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }else{
                        oneWordNotNameAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }
                }
            }
            if(ssdAbr.Category__c.contains('Address')){
                if(ssdAbr.Always_Applicable__c==true){
                    if(ssdAbr.More_than_a_word__c==true){
                        multiWordAddAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }else{
                        oneWordAddAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }
                }else{
                    if(ssdAbr.More_than_a_word__c==true){
                        multiWordNotAddAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }else{
                        oneWordNotAddAlwaysMap.put(ssdAbr.MasterLabel.toUpperCase(), ssdAbr.Abbreviation__c);
                    }
                }
            }
        }
        System.debug('multiWordNameAlwaysMap : '+multiWordNameAlwaysMap);
        System.debug('oneWordNameAlwaysMap : '+oneWordNameAlwaysMap);
        System.debug('multiWordNotNameAlwaysMap : '+multiWordNotNameAlwaysMap);
        System.debug('oneWordNotNameAlwaysMap : '+oneWordNotNameAlwaysMap);
        System.debug('multiWordAddAlwaysMap : '+multiWordAddAlwaysMap);
        System.debug('oneWordAddAlwaysMap : '+oneWordAddAlwaysMap);
        System.debug('multiWordNotAddAlwaysMap : '+multiWordNotAddAlwaysMap);
        System.debug('oneWordNotAddAlwaysMap : '+oneWordNotAddAlwaysMap);
        
        System.debug('outputStr : '+outputStr);
        System.debug('inputStr : '+inputStr);
        inputStr = replaceAllMultiWord(inputStr, type, multiWordNameAlwaysMap, multiWordAddAlwaysMap);
        System.debug('inputStr : '+inputStr);
        outputStr = replaceAllSingleWord(inputStr, type, oneWordNameAlwaysMap, oneWordAddAlwaysMap);
        System.debug('outputStr : '+outputStr + ' : lenght : '+outputStr.length());
        
        if(outputStr.length()<=sizeLimit){
            return outputStr;
        }
        
        inputStr = outputStr;
        outputStr = '';
        System.debug('inputStr : '+inputStr);
        System.debug('outputStr : '+outputStr);
        inputStr = replaceAllMultiWord(inputStr, type, multiWordNotNameAlwaysMap, multiWordNotAddAlwaysMap);
        System.debug('inputStr : '+inputStr);
        outputStr = replaceAllSingleWord(inputStr, type, oneWordNotNameAlwaysMap, oneWordNotAddAlwaysMap);
        System.debug('outputStr : '+outputStr);
        
        return outputStr;
    }
}