/*
 * Modified by Bharat Bhushan on 6th Aug 2018
 * DLT-11509 - [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID]
 * Modified by Harika Sai on 14th Dec 20108
 * DLT-13174 
 * Modified by Navleen Kaur on 07 Feb 2019
 * DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
 */
@isTest
Public class Digital_PremiumProposalAutomationTest{
    
    @testSetup 
    static void settUpdata() {
         //To fix the test class error from UpdateMultiListAccountTier
        WebServiceSettings__c web = new WebServiceSettings__c();
        web.Endpoint__c = 'https://thomsonreutersglis2e--merge.cs19.my.salesforce.com/servlet/servlet.ExternalRedirect?url=https%3A%2F%2Fqa.securepayment.thomsonreuters.com%2FTRPaymentGateway%2FBilling%2FInvoiceSummary%2FTRPaymentAutoCharge';
        web.Name = 'Payment AutoCharge';
        web.Username__c = 'test.user';
        web.Password__c = 'test:123';
        web.Service_Unavailable_Message__c = 'testservice';
        insert web;
        //Ends
        //Create Account,Contact and Opportunity
        DCTestData.createData(); 
        DCTestData.createPaymentCreditWebService();
        
        Apttus_Config2__PriceList__c priceList = [select id,name from Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal' limit 1 ];
        
        Account tAccount = new Account();
        tAccount.id = DCTestData.accountId;

        Contact tContact =new Contact();
        tContact.id = DCTestData.contactId;

        Source_System_Detail__c tSSDAccount = new Source_System_Detail__c();
        tSSDAccount.id = DCTestData.accssdid;
        tSSDAccount.APTS_Customer_Category__c = null;
        update tSSDAccount;
        
        LCRM_Contact_SSD__c  tssdContcat = new LCRM_Contact_SSD__c();
        tssdContcat = DCTestData.createContactSSD(tContact,tSSDAccount);
        tssdContcat.LCRM_SAP_Role__c= 'WL PSWD ACTIVE;EML ORDER CONFIRM;EBILL EMAIL CONTACT;SAP - 18 BILLING/ACCT PAYABLE;';
        tssdContcat.LCRM_Job_Function__c = 'Attorney - Other';
        tssdContcat.LCRM_Source_Contact_Id__c= '12345';
        tssdContcat.LCRM_Email__c='testfirst.testlast@test.com';
        update tssdContcat;
        
        Product2 prodObj = DCTestData.createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
        Product2 prodObj2 = DCTestData.createProduct('SL Minnesota Analytical (Westlaw PRO&trade)', '41409998', '42009561');
        Product2 upsellProd = DCTestData.createProduct('ALL States Analytical (Westlaw PRO&trade)', '40974108', '42009614');
        Product2 upsellProd2 = DCTestData.createProduct('SL National Analytical (Westlaw PRO&trade)', '42004985', '42004987');
        
        
        Opportunity tOppty = new Opportunity();
        tOppty.id = DCTestData.oppId;
        tOppty.AccountId = tAccount.id;
        tOppty.Source_System_Detail__c = tSSDAccount.id;
        tOppty.Campaign_Code__c ='00237KI';
        tOppty.Renewal_Date__c = system.today().addDays(50);
        tOppty.Key_Contact__c = tContact.id;
        update tOppty;
        
        
        Apttus_Proposal__Proposal__c stProposal = DCTestData.createQuote(tAccount.id ,'Straight Renewal');
        stProposal.Apttus_Proposal__Opportunity__c = tOppty.id; 
        insert  stProposal;
        test.starttest();
        Apttus_Proposal__Proposal__c plusProposal = DCTestData.createQuote(tAccount.id ,'Best Value');
        plusProposal.Apttus_Proposal__Opportunity__c = tOppty.id;
        insert plusProposal;
        
        
       /* //This is added to fix flow error to add SSD on old proposal
        Apttus_Proposal__Proposal__c cproposal = DCTestData.createQuote(tAccount.Id, 'Best Value+Config');
        cproposal.APTS_SSD_Sold_To__c = tSSDAccount.id;
        cproposal.APTS_SSD_bill_to__c = tSSDAccount.id;
        cproposal.Apttus_Proposal__Opportunity__c = tOppty.id;
        insert cproposal;
        */
        
        opportunity opptyList =  [Select id,name,Ownerid,owner.name,owner.id,AccountId,Source_System_Detail__c,Source_System_Detail__r.LCRM_APTS_Band_Number__c,
                                  Source_System_Detail__r.LCRM_eOutput_Eligibility__c,Status__c,StageName,Renewal_Date__c,RecordTypeId,Campaign_Code__c,  
                                  SAP_Account_Number__c FROM Opportunity where AccountId =: tAccount.id limit 1];
        

        LCRM_Contact_SSD__c lcrmlist =[select id,LCRM_Account_SSD__r.id,LastModifiedDate,LCRM_Hard_Bounce__c,LCRM_Contact__r.Id,LCRM_Contact__r.Email,LCRM_Contact__r.SAP_Contact_ID__c,LCRM_SAP_Role__c,LCRM_Job_Function__c,LCRM_Email__c,LCRM_Source_Contact_Id__c from LCRM_Contact_SSD__c where LCRM_Account_SSD__r.id =: tSSDAccount.Id ];
        

       
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>([SELECT AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Digital_Firm__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Service__c,Premium_New_Subscription__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c,Renewal_Date__c FROM Product_Account_Detail__c]);
        
        Product_Account_Detail__c dsPremium =  new Product_Account_Detail__c();
        //DCTestData.createDigitalSubscriptions('42009614','42009614', 'Premium', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        
        dsPremium.Account__c = tAccount.id;
        dsPremium.AccountSSD__c = tSSDAccount.Id;
        dsPremium.Premium_New_Service__c = '40974108';
        dsPremium.Premium_New_Subscription__c = '42009614';
        dsPremium.Current_Subscription__c = '42009617';
        dsPremium.Actual_New_Subscription_Product__c = upsellProd.id;
        dsPremium.Actual_New_Subscription__c ='';
        dsPremium.Actual_New_Service__c ='';
        dsPremium.Offer_Price__c = 5;
        dsPremium.Quantity__c = 1;
        dsPremium.Current_Term_Length__c = 3;
        dsPremium.Year1_YoYvalue__c = 7;
        dsPremium.Year3_YoYvalue__c = 2;
        dsPremium.Type__c ='Premium';
        dsPremium.Digital_Firm__c= 'Small Law';
        dsPremium.Hard_Bounce__c = True;
        dsPremium.SAP_Contact_Id__c = '12345';
        dsPremium.ZP_Cust_Number__c = '1004284494';
        dsPremium.Campaign_Code__c = '00237KI';
        dsPremium.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsPremium);
        
        Product_Account_Detail__c dsPremium2 =  new Product_Account_Detail__c();
        
        dsPremium2.Account__c = tAccount.id;
        dsPremium2.AccountSSD__c = tSSDAccount.Id;
        dsPremium2.Premium_New_Service__c = '42004985';
        dsPremium2.Premium_New_Subscription__c = '42004987';
        dsPremium2.Current_Subscription__c = '42009617';
        dsPremium2.Actual_New_Subscription_Product__c = upsellProd2.id;
        dsPremium2.Actual_New_Subscription__c ='';
        dsPremium2.Actual_New_Service__c ='';
        dsPremium2.Offer_Price__c = 5;
        dsPremium2.Quantity__c = 1;
        dsPremium2.Digital_Firm__c= 'Small Law';
        dsPremium2.Type__c ='Premium';
        dsPremium2.Hard_Bounce__c = True;
        dsPremium2.SAP_Contact_Id__c = '12345';
        dsPremium2.ZP_Cust_Number__c = '1004284494';
        dsPremium2.Campaign_Code__c = '00237KI';
        dsPremium2.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsPremium2);
        

        Product_Account_Detail__c dsCurrent = new Product_Account_Detail__c();
        //DCTestData.createDigitalSubscriptions('42072689','42072690', 'Premium', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        
        dsCurrent.Account__c = tAccount.id;
        dsCurrent.AccountSSD__c = tSSDAccount.Id;
        dsCurrent.Current_Subscription__c = '42009617';
        dsCurrent.Actual_New_Subscription__c ='';
        dsCurrent.Actual_New_Service__c ='';
        dsCurrent.Premium_New_Service__c = '';
        dsCurrent.Premium_New_Subscription__c = '';
        dsCurrent.Actual_New_Subscription_Product__c = upsellProd.id;
        dsCurrent.Offer_Price__c = 5;
        dsCurrent.Quantity__c = 1;
        dsCurrent.Type__c ='Premium';
        dsCurrent.Digital_Firm__c= 'Small Law';
        dsCurrent.Hard_Bounce__c = True;
        dsCurrent.SAP_Contact_Id__c = '12345';
        dsCurrent.ZP_Cust_Number__c = '1004284494';
        dsCurrent.Campaign_Code__c = '00237KI';
        dsCurrent.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsCurrent);
        
        
        insert prodactdetailList;
        
        set<String> productIds = new set<String>();
        for(Product_Account_Detail__c p : [select Actual_New_Subscription_Product__c from Product_Account_Detail__c where id in :prodactdetailList]){
            if(p.Actual_New_Subscription_Product__c !=null)
                productIds.add(p.Actual_New_Subscription_Product__c);
        }
        
         system.AssertEquals(prodactdetailList[0].AccountSSD__c,String.valueOf(tSSDAccount.id));

        List<Apttus_Config2__PriceListItem__c> lstPLis = new List<Apttus_Config2__PriceListItem__c>();
        
        for(Product2 pod : [select id from product2 where id in :productIds]){
            
            Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
            pli.Apttus_Config2__PriceListId__c = priceList.id;
            pli.Apttus_Config2__ProductId__c = pod.id;
            pli.Apttus_Config2__ChargeType__c ='Subscription Fee';
            pli.Apttus_Config2__PriceType__c  = 'Recurring';
            pli.Apttus_Config2__Frequency__c = 'Monthly';
            pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
            pli.Apttus_Config2__PriceUom__c = 'Each';
            pli.Apttus_Config2__Active__c  = true;
            pli.Apttus_Config2__ListPrice__c = 100;
            lstPLis.add(pli);
            
        }
        insert lstPLis;
        
      
        list<Apttus_Config2__AssetLineItem__c> aliList = new list<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Name = 'Essentials Library — Florida (Westlaw PRO™)1';
        ali.Apttus_Config2__Quantity__c = 1;
        ali.Apttus_Config2__Description__c = 'Test';        
        ali.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali.Apttus_Config2__PricingDate__c = System.Today();
        ali.Apttus_Config2__IsPrimaryLine__c = TRUE;
        ali.Apttus_Config2__AssetStatus__c = 'Activated';
        ali.Apttus_Config2__LineType__c = 'Product/Service';
        ali.Apttus_Config2__LineNumber__c = 1;
        ali.Apttus_Config2__ItemSequence__c = 1;
        ali.Apttus_Config2__ProductId__c = prodObj.id;
        ali.Apttus_Config2__BillToAccountId__c = tAccount.id;
        ali.Apttus_Config2__AccountId__c = tAccount.id;
        ali.Apttus_Config2__ShipToAccountId__c = tAccount.id;
        ali.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali.APTS_Contract_Term__c = '3 Years';
        ali.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali.Apttus_Config2__PriceListId__c = priceList.id;
        ali.APTS_Subscription_Number__c = '0974107';
        ali.APTS_Info_RenewalDate__c = System.Today();
        ali.Apttus_Config2__RenewalDate__c = System.Today();
        ali.APTS_Info_PlanType__c = 'R03';
        ali.Apttus_Config2__SellingFrequency__c = 'Monthly';       
        ali.Apttus_Config2__SellingTerm__c = 1;
        ali.Apttus_Config2__NetPrice__c = 163;
        //ali.Apttus_QPConfig__ProposalId__c = cproposal.id;
        ali.APTS_SSD_Bill_To__c = tSSDAccount.Id; 
        ali.APTS_SSD_Ship_to__c = tSSDAccount.Id;  
        ali.APTS_SSD_Sold_To__c = tSSDAccount.Id;      
        aliList.add(ali);    
        
        insert aliList;
        
        //system.AssertEquals(plusProposal.Digital_Quote_Type__c, 'Best Value');
        test.stoptest(); 
    }
    
    Public static testmethod void premiumProposalAutomationTest(){
        
        test.starttest();
        Source_System_Detail__c tSSDAcc = [ select id,APTS_Customer_Category__c,Account_Name__c from Source_System_Detail__c limit 1];
        //system.AssertEquals(tSSDAcc.APTS_Customer_Category__c, null);
  
                         
        
        
        Digital_PremiumProposalAutomation dbp = new Digital_PremiumProposalAutomation();
        DataBase.executeBatch(dbp);
        Digital_PremiumProposalAutomation.createExceptionLog('','','','');
        test.stoptest(); 
    } 
    
    Public static testmethod void premiumDiffCategoryTest(){
        test.starttest();
        Product_Account_Detail__c tAccount1 = [SELECT AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Digital_Firm__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Service__c,Premium_New_Subscription__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c,Renewal_Date__c FROM Product_Account_Detail__c where Digital_Firm__c = 'Small Law' limit 1 ];
        tAccount1.Digital_Firm__c = 'Small Law';
        update tAccount1;
        
        Product_Account_Detail__c tSSDAcc22 =  [SELECT AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,Digital_Firm__c,Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Service__c,Premium_New_Subscription__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c,Renewal_Date__c FROM Product_Account_Detail__c where Digital_Firm__c = 'Small Law' limit 1 ];        
        tSSDAcc22.Digital_Firm__c = 'Small Law';
        update tSSDAcc22;
       
        
        Digital_PremiumProposalAutomation dbp = new Digital_PremiumProposalAutomation();
        DataBase.executeBatch(dbp);
        
        test.stoptest(); 
         system.AssertEquals(tSSDAcc22.Digital_Firm__c, 'Small Law');
        
        //system.AssertEquals(tSSDAcc22.APTS_Customer_Category__c, '3');
        
        
    } 

  /*  Public static testmethod void premiumCorpTest(){
        test.starttest();
        Account tAccount1 = [ select id,SAPAccountNumber__c,Customer_Group__c,APTS_Band_Number__c,APTS_Customer_Category__c,APTS_eOutput_Eligibilty__c,Digital_Firm__c from Account limit 1];
        tAccount1.FrozenMarketSegment__c='Corp Counsel Existing';
        update tAccount1;
        
        Source_System_Detail__c tSSDAcc1 = [ select id,APTS_Customer_Category__c,Account_Name__c,LCRM_Frozen_Market_Segment__c,Digital_Firm__c from Source_System_Detail__c where Account_Name__c =: tAccount1.id limit 1];
        tSSDAcc1.APTS_Customer_Category__c = '3';
        tSSDAcc1.LCRM_Frozen_Market_Segment__c='Corp Counsel Existing';
        update tSSDAcc1;
        
        
        Digital_PremiumProposalAutomation dbp = new Digital_PremiumProposalAutomation();
        DataBase.executeBatch(dbp);
        
        test.stoptest();
        system.AssertEquals(tAccount1.id, String.valueOf(tSSDAcc1.Account_Name__c));
       
        
    }*/
    
    
}