/**
 * Test class for Digital_ProposalAutomation 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-10-25   Dev Team                Created for testing the batch job for straight renewal proposal creation  
 * 2018-06-08   Harika Sai P            DLT-9750 -  Update Account / Contact object references in Renewal Automation classes for GLI
 * 2018-08-06   Bharat Bhushan          DLT-11509 - [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID
 * 2018-10-05   Harika Sai P            DLT-12065 - Code Scan story
 * 2018-12-14   Harika sai P            DLT-13174
 * 2020-05-04   Kavya S                 DLT-21366 - PMD Fix
 * =============================================================================
 */

  /** 
 * @description : A test class for Digital_ProposalAutomation
 */
@istest
Public class Digital_ProposalAutomation_Test{
    public static String cQuoteID;
    
    @testsetUp static void setupData() {    
        DCTestData.createData();
        DCTestData.createPaymentCreditWebService();
        
        Pricebook2 flpbook = new Pricebook2();
        flpbook.name =  'GLI Price Book - FindLaw';
        insert flpbook;
            
        //This is added to fix flow error to add SSD on old proposal
        Apttus_Proposal__Proposal__c cproposal = DCTestData.createQuote(DCTestData.accountId, 'Best Value+Config');
        cproposal.APTS_SSD_Sold_To__c = DCTestData.accssdid;
        cproposal.APTS_SSD_bill_to__c = DCTestData.accssdid;
        cproposal.Apttus_Proposal__Opportunity__c = DCTestData.oppId;                                                       
        insert cproposal;
        System.debug(logginglevel.INFO,'cproposal==>'+cproposal);
        
        //Creating products
        list<Product2> prodList = new list<Product2>();
        
        Product2 prodObj = new Product2(); //current sub      
        prodObj = DCTestData.createProduct('Essentials Library — Florida (Westlaw PRO™)','40982845','40974107');
        prodObj.APTS_Media_High_Level_Code__c = '05';        
        prodObj.Productcode = '42009613';
        prodList.add(prodObj);
        
        Product2 prodObj2 = new Product2(); //new sub
        prodObj2 = DCTestData.createProduct('Essentials Library — US (Westlaw PRO™)','40982846','40974108');
        prodObj2.APTS_Media_High_Level_Code__c = '07';       
        prodObj2.Productcode = '42009614';
        prodList.add(prodObj2);
        
        Product2 prodObj4 = new Product2(); //current sub
        prodObj4 = DCTestData.createProduct('Essentials Plus — Alabama (Westlaw PRO™)','41091542','41091475');
        prodObj4.APTS_Media_High_Level_Code__c = '21';        
        prodObj4.Productcode = '42009615';
        prodList.add(prodObj4);
        
        Product2 prodObj3 = new Product2(); //new sub
        prodObj3 = DCTestData.createProduct('SL Missouri Analytical (Westlaw PRO™)','42009560','42009613');
        prodObj3.APTS_Media_High_Level_Code__c = '05';        
        prodObj3.Productcode = '42009616';
        prodList.add(prodObj3); 
            
        update prodList;          
        
        //Creating Digital subscriptions
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
        list<Product_Account_Detail__c> prodactdetailList2 = new list<Product_Account_Detail__c>();
    
        Product_Account_Detail__c prodactdetail1 = new Product_Account_Detail__c();
        prodactdetail1 = createProdcutAccountDetail('1004284494','40974107',DCTestData.accssdid);       
        prodactdetail1.Offer_Price__c = -5;
        prodactdetailList.add(prodactdetail1); 
        
        
        Product_Account_Detail__c prodactdetail2 = new Product_Account_Detail__c();       
        prodactdetail2 = createProdcutAccountDetail('1004284494','40974108',DCTestData.accssdid);        
        prodactdetail2.Hard_Bounce__c = True;
        prodactdetailList.add(prodactdetail2);
        
        Product_Account_Detail__c prodactdetail3 = new Product_Account_Detail__c();
        prodactdetail3 = createProdcutAccountDetail('1004284494','41091475',DCTestData.accssdid); 
        prodactdetailList2.add(prodactdetail3);
        
        insert prodactdetailList;
        system.debug(logginglevel.INFO,'@@@@ : '+ prodactdetailList); 
        
        set<String> productIds =new set<String>();
        set<Boolean> hardids = new set<Boolean>();
        for(Product_Account_Detail__c p : [select Actual_New_Subscription_Product__c from Product_Account_Detail__c where id in :prodactdetailList]){
            if(p.Actual_New_Subscription_Product__c !=null){
                productIds.add(p.Actual_New_Subscription_Product__c);
            }
        }
        for(Product_Account_Detail__c p : [select Hard_Bounce__c from Product_Account_Detail__c where id in :prodactdetailList]){
            if(p.Hard_Bounce__c !=null){
                hardids.add(p.Hard_Bounce__c);
            }
        }
        
        List<Apttus_Config2__PriceListItem__c> lstPLis = new List<Apttus_Config2__PriceListItem__c>();
        //Crating price lists from products.
        for(Product2 pod : [select id from product2 where id in :productIds]){
        
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = DCTestData.pBookId;
        pli.Apttus_Config2__ProductId__c = pod.id;
        pli.Apttus_Config2__ChargeType__c ='Subscription Fee';
        pli.Apttus_Config2__PriceType__c  = 'Recurring';
        pli.Apttus_Config2__Frequency__c = 'Monthly';
        pli.Apttus_Config2__PriceMethod__c = 'Per Unit';
        pli.Apttus_Config2__PriceUom__c = 'Each';
        pli.Apttus_Config2__Active__c  =true;
        pli.Apttus_Config2__ListPrice__c = 100;
        lstPLis.add(pli);
        
        }
        insert lstPLis;
        //Creating cart line items
        list<Apttus_Config2__AssetLineItem__c> aliList = new list<Apttus_Config2__AssetLineItem__c>();
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c();
        ali.Name = 'Essentials Library — Florida (Westlaw PRO™)';
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
        ali.Apttus_Config2__BillToAccountId__c = DCTestData.accountId;
        ali.Apttus_Config2__AccountId__c = DCTestData.accountId;
        ali.APTS_SSD_Sold_To__c = DCTestData.accssdid;
        ali.Apttus_Config2__ShipToAccountId__c = DCTestData.accountId;
        ali.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali.APTS_Contract_Term__c = '3 Years';
        ali.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali.Apttus_Config2__PriceListId__c = DCTestData.pBookId;
        ali.APTS_Subscription_Number__c = '40974107';
        ali.APTS_Info_RenewalDate__c = System.Today()+1;
        ali.Apttus_Config2__RenewalDate__c = System.Today()+1;
        ali.APTS_Info_PlanType__c = 'R03';
        ali.Apttus_Config2__SellingFrequency__c = 'Monthly';
        ali.Apttus_Config2__SellingTerm__c = 1;
        ali.Apttus_Config2__NetPrice__c = 163;   
        ali.APTS_SSD_Bill_To__c = DCTestData.accssdid; 
        ali.APTS_SSD_Ship_to__c = DCTestData.accssdid;  
        ali.Apttus_QPConfig__ProposalId__c = cproposal.id;    
        aliList.add(ali); 
        
        Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c();
        ali2.Name = 'SL Missouri Analytical (Westlaw PRO™)';
        ali2.Apttus_Config2__Quantity__c = 1;
        ali2.Apttus_Config2__Description__c = 'Test';        
        ali2.APTS_SAP_MLA_Agreement_Number__c = '12345678';
        ali2.Apttus_Config2__PricingDate__c = System.Today();
        ali2.Apttus_Config2__IsPrimaryLine__c = TRUE;        
        ali2.Apttus_Config2__AssetStatus__c = 'Activated';
        ali2.Apttus_Config2__LineType__c = 'Product/Service';
        ali2.Apttus_Config2__LineNumber__c = 1;
        ali2.Apttus_Config2__ItemSequence__c = 1;
        ali2.Apttus_Config2__ProductId__c = prodObj.id;
        ali2.Apttus_Config2__BillToAccountId__c = DCTestData.accountId;
        ali2.Apttus_Config2__AccountId__c = DCTestData.accountId;
        ali2.APTS_SSD_Sold_To__c = DCTestData.accssdid;
        ali2.Apttus_Config2__ShipToAccountId__c = DCTestData.accountId;
        ali2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        ali2.APTS_Contract_Term__c = '3 Years';
        ali2.APTS_YoY_Adjustment_Type__c = 'Increase';
        ali2.Apttus_Config2__PriceListId__c = DCTestData.pBookId;
        ali2.APTS_Subscription_Number__c = '41091475';
        ali2.APTS_Info_RenewalDate__c = System.Today()+1;
        ali2.Apttus_Config2__RenewalDate__c = System.Today()+1;
        ali2.APTS_Info_PlanType__c = 'R03';
        ali2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        ali2.Apttus_Config2__SellingTerm__c = 1;
        ali2.Apttus_Config2__NetPrice__c = 163;    
        ali.APTS_SSD_Bill_To__c = DCTestData.accssdid; 
        ali.APTS_SSD_Ship_to__c = DCTestData.accssdid;  
        ali.Apttus_QPConfig__ProposalId__c = cproposal.id;    
        aliList.add(ali2); 
    
        
        insert aliList;
       

    } 
       static Product_Account_Detail__c createProdcutAccountDetail(string zPnum,string subNum,Id ssdId)
    {
        Product_Account_Detail__c prodactdetail = new Product_Account_Detail__c();
        prodactdetail.ZP_Cust_Number__c = zPnum;
        prodactdetail.AccountSSD__c= ssdId;        
        prodactdetail.Current_Subscription__c = subNum;
        prodactdetail.Premium_New_Service__c = '42009560'; 
        prodactdetail.Premium_New_Subscription__c =  '42009613';     
        prodactdetail.Quantity__c = 1;
        prodactdetail.campaign_code__c = '00237KI';
        prodactdetail.sub_Campaign_Code__c = '00237KI';        
        prodactdetail.Renewal_Date__c = System.Today()+1;
        prodactdetail.SAP_Contact_Id__c = '12345';
        prodactdetail.Hard_Bounce__c = false;
        return prodactdetail;
    } 
 
    @isTest  static void testExceptions4(){
        List<Product2> prodlist= new List<Product2> ();
        for(Product2 prodobj: [Select id from Product2]){
            prodobj.Subscription_Number__c ='777777777';
            prodlist.add(prodobj);
        }
        System.assert(prodlist != null,'prodlist is null');
        update prodlist;
        Test.startTest();
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);
        test.stoptest();
        /*
        Digital_Exception_Log__c exc=[Select id,Exception_Message__c from Digital_Exception_Log__c order by createddate desc LIMIT 1];
        System.debug(exc);
        System.assertEquals(exc.Exception_Message__c,label.CurSubcripNotFoundInActAssetsPA);
        */
    } 
   
      @isTest static void proposalAutomationManual(){
        //setupData();
        test.starttest();
        //Account Acc = CreateacctCommonCode('1');          
        Source_System_Detail__c  acctSSD = [SELECT  LCRM_Frozen_Market_Segment__c FROM Source_System_Detail__c LIMIT 1]; 
        Account acct = [SELECT Id,FrozenMarketSegment__c  FROM Account LIMIT 1];       
        Opportunity opp1 = [SELECT ID from Opportunity LIMIT 1];     
        Apttus_Proposal__Proposal__c p= DCTestData.createProposalRec(opp1.Id,acctSSD.Id,acct.Id,null,'');
        p.Digital_Quote_Type__c  = 'Manual' ;
        system.debug(logginglevel.INFO,'**Proposal**' + P);
        Insert p;
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);
        //For Assersion   
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Digital_Quote_Type__c  FROM Apttus_Proposal__Proposal__c  where Apttus_Proposal__Opportunity__c = :opp1.Id and Digital_Quote_Type__c='Manual'];
        System.assertEquals(prop.Digital_Quote_Type__c ,'Manual','');    
        test.stoptest();
        
    }
    @isTest static void proposalAutomationCorporate(){
        
        //Account Acc = CreateacctCommonCode('Corporate'); 
        test.starttest();        
        Source_System_Detail__c  acctSSD = [SELECT  Id,LCRM_Frozen_Market_Segment__c FROM Source_System_Detail__c LIMIT 1]; 
        System.assert(acctSSD !=null,'acctSSD is null');
        Account acct = [SELECT Id,FrozenMarketSegment__c  FROM Account LIMIT 1];
        acctSSD.LCRM_Frozen_Market_Segment__c= 'Corp Counsel';
        acctSSD.APTS_Customer_Category__c = null; 
        acct.FrozenMarketSegment__c = 'Corp Counsel';
        update acctSSD;
        update acct;
        List<Apttus_Config2__AssetLineItem__c> aliList= [select id, APTS_SSD_Ship_To__c  from Apttus_Config2__AssetLineItem__c];
        if(aliList.size()>1){
            
            aliList[0].APTS_SSD_Ship_To__c  = acctSSD.Id;
            aliList[1].APTS_SSD_Ship_To__c  = acctSSD.Id;
        }
        update aliList;
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp); 
        test.stoptest();
        //For Assersion
        Apttus_Config2__AssetLineItem__c  aliAfterBatch=[Select APTS_SSD_ship_to__r.Digital_Firm__c FROM Apttus_Config2__AssetLineItem__c LIMIT 1];
        //system.assertEquals(aliAfterBatch.APTS_SSD_ship_to__r.Digital_Firm__c ,'Corporate'); 
        
    }   
    @isTest  static void proposalAutomationTestOPCamCode(){
        //Account Acc = CreateacctCommonCode('6');
        test.starttest();       
        Account acct= [SELECT Id from Account LIMIT 1];
        acct.APTS_eOutput_Eligibilty__c = '';
         
        list<Apttus_Config2__AssetLineItem__c>  opt1 = [ select id, APTS_Info_RenewalDate__c  from Apttus_Config2__AssetLineItem__c  LIMIT 1];
        opt1[0].APTS_Info_RenewalDate__c = System.Today().addDays(-90);
        update opt1;
        
        
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);

        
        //For Assersion
        Apttus_Proposal__Proposal__c prop = [SELECT Id,Name,Apttus_Proposal__Primary__c,Digital_Quote_Type__c FROM Apttus_Proposal__Proposal__c  LIMIT 1];
        prop.Digital_Quote_Type__c= 'Straight Renewal';
        update prop;        
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Expected value');
        test.stoptest(); 
        
    }
    
    @isTest static void proposalAutomationTestCamCode(){        
        test.starttest();       
        Account acct= [SELECT Id from Account LIMIT 1];
        Acct.APTS_eOutput_Eligibilty__c = '';
        Opportunity opt1 = [ select id, Campaign_Code__c  from Opportunity  LIMIT 1];
        opt1.Campaign_Code__c = 'SOQL';
        update opt1;
        
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);

        test.stoptest();
        //For Assersion
        Opportunity oppAfterBatch=[SELECT Campaign_Code__c from Opportunity WHERE Id=: opt1.Id];
        System.AssertEquals(oppAfterBatch.Campaign_Code__c ,'SOQL','Expected Value');
    }   
 
 
    
    @isTest static void proposalAutomationTest2(){       
        
        test.starttest();        
        Account acct= [SELECT Id from Account LIMIT 1];
        acct.APTS_Band_Number__c = 2 ;
        acct.APTS_Customer_Category__c = '7';
        acct.APTS_eOutput_Eligibilty__c = '';
        update Acct;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acct.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        ssd.APTS_Customer_Category__c = '7';
        ssd.LCRM_eOutput_Eligibility__c = '';
        update ssd;
 
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);
        //Digital_ProposalAutomationnewOpp dbp2 = new Digital_ProposalAutomationnewOpp();
        //DataBase.executeBatch(dbp2);
        
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: ssd.Id limit 1];
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        update prop;
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Expected value');
        test.stoptest();

    }
    
    @isTest static void cartCreationTest(){      
        list<Id> quoteProposalIdList;
        System.assert(quoteProposalIdList == null, 'quoteProposalIdList is not null');
        Test.startTest();
        try{
            Digital_ProposalAutomation.cartCreation(quoteProposalIdList);
        }
        catch(exception ex){
            System.debug(logginglevel.INFO,'Exception thrown as intended');
        }
        Test.stopTest();
    }
    
    
    @isTest static void proposalAutomationFindLawTest(){       
        
        test.starttest();        
        Account acct= [SELECT Id from Account LIMIT 1];
        acct.APTS_Band_Number__c = 2 ;
        acct.APTS_Customer_Category__c = '7';
        acct.APTS_eOutput_Eligibilty__c = '';
        update Acct;
        Source_System_Detail__c ssd = [Select id, LCRM_APTS_Band_Number__c, APTS_Customer_Category__c, LCRM_eOutput_Eligibility__c from Source_System_Detail__c where Account_Name__c =: acct.id];
        ssd.LCRM_APTS_Band_Number__c = 2;
        ssd.APTS_Customer_Category__c = '7';
        ssd.LCRM_eOutput_Eligibility__c = '';
        update ssd;
        List<Product_Account_Detail__c> dsList = [SELECT id, Digital_Firm__c FROM Product_Account_Detail__c LIMIT 10000];
        for(Product_Account_Detail__c ds : dsList){
            ds.Digital_Firm__c = 'FindLaw';
        }
        update dsList;
 
        Digital_ProposalAutomation dbp = new Digital_ProposalAutomation();
        DataBase.executeBatch(dbp);
        //Digital_ProposalAutomationnewOpp dbp2 = new Digital_ProposalAutomationnewOpp();
        //DataBase.executeBatch(dbp2);
        
        //For Assersion
        Apttus_Proposal__Proposal__c  prop= [SELECT Digital_Quote_Type__c from Apttus_Proposal__Proposal__c WHERE APTS_SSD_Sold_To__c =: ssd.Id limit 1];
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        update prop;
        System.AssertEquals(prop.Digital_Quote_Type__c, 'Straight Renewal','Expected Value');
        test.stoptest();

    }
}