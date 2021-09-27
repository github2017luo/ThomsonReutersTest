/* Change History **************************************************************************************************/
/**** Created By               JIRA             Description
/**** HarikaSai P, Divija S    DLT-12136,       Digital Quote Automation optimization for Cart Creation for Straight Renewal, Best and Premium.
                               DLT-12134,
                               DLT_12139
                               DLT-13174
     Navleen Kaur              DLT-14618 -      [All] Digital firm should be populated based Firm type in automation feed/file 
     Harika Sai P              DLT-17793        [CORP][SFDC] Multi Offer - Add option products to the subscription list  
     Kavya S                   DLT-21380         REN - Fixed quote automation process
     Brenda Shields 2021-04-01 DLT-21586 - [SFDC]-Removing FindLaw Approval Segment Value
                                           Change field being checked from -> APTS_Approval_Segment__c to -> APTS_Proposal_Business_Unit__c
********************************************************************************************************************/
/**
    @description Test class for Digital CartCreation
 */
@istest
private class Digital_CartCreationCommoncode_Test{

    @testSetup 
    static void settUpdata(){
        
        //Create Account,Contact and Opportunity
        
        List<KeyValueListStore__C> keyCSList = [Select Name From KeyValueListStore__C Where Name='ReasonWithCompetitor'];
        
        if((keyCSList == null) || (keyCSList.isEmpty())) {
            KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name= 'ReasonWithCompetitor',TextValue__c= 'Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other');
            insert keyCustomSetting;
        }
        
        DCTestData.createData(); 
        
         DCTestData.createPaymentCreditWebService();
        Apttus_Config2__PriceList__c priceList = [select id,name from Apttus_Config2__PriceList__c where name = 'Thomson Reuters Master - US Legal' limit 1 ];
        

        Account tAccount = new Account();
        tAccount.id = DCTestData.accountId;

        Contact tContact =new Contact();
        tContact.id = DCTestData.contactId;

        Source_System_Detail__c tSSDAccount = new Source_System_Detail__c();
        tSSDAccount.id = DCTestData.accssdid;
        //tSSDAccount.APTS_Customer_Category__c = null;
        update tSSDAccount;
        
        LCRM_Contact_SSD__c  tssdContcat = new LCRM_Contact_SSD__c();
        tssdContcat = DCTestData.createContactSSD(tContact,tSSDAccount);
        tssdContcat.LCRM_SAP_Role__c= 'WL PSWD ACTIVE;EML ORDER CONFIRM;EBILL EMAIL CONTACT;SAP - 18 BILLING/ACCT PAYABLE;';
        tssdContcat.LCRM_Job_Function__c = 'Attorney - Other';
        tssdContcat.LCRM_Source_Contact_Id__c= '12345';
        tssdContcat.LCRM_Email__c='testfirst.testlast@test.com';
        update tssdContcat;
        
        Product2 prodObj = DCTestData.createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
        //Product2 prodObj2 = DCTestData.createProduct('SL Minnesota Analytical (Westlaw PRO&trade)', '41409998', '42009561');
        Product2 upsellProd = DCTestData.createProduct('ALL States Analytical (Westlaw PRO&trade)', '40974108', '42009614');
        Product2 upsellProd2 = DCTestData.createProduct('SL National Analytical (Westlaw PRO&trade)', '42004985', '42004987');
        Product2 optionProd = DCTestData.createProduct('GC American Jurisprudence (AMJUR) (CORP) (WestlawPRO™)', '42076367', '42076368');//Harika
        optionProd.Apttus_Config2__ConfigurationType__c  = 'Option';
        optionProd.Apttus_Config2__HasOptions__c = false;
        optionProd.APTS_Module_Points__c = 1.0;
        update optionProd; 
        Product2 bundleProd = DCTestData.createProduct('Westlaw Edge Corporate Select', '', '');//Harika
        bundleProd.Apttus_Config2__ConfigurationType__c = 'Bundle';
        bundleProd.Apttus_Config2__HasOptions__c = true;
        update bundlePRod;
        
        system.debug(LoggingLevel.DEBUG,'prodIds' + prodObj.Id + upsellProd.Id + upsellProd2.Id + optionProd.Id + bundleProd.Id);
        Opportunity tOppty = new Opportunity();
        tOppty.id = DCTestData.oppId;
        tOppty.AccountId = tAccount.id;
        tOppty.Source_System_Detail__c = tSSDAccount.id;
        tOppty.Campaign_Code__c ='00237KI';
        tOppty.Renewal_Date__c = system.today().addDays(50);
        tOppty.Key_Contact__c = tContact.id;
        update tOppty;
        
        
        Opportunity ftOppty = new Opportunity();
        ftOppty.id = DCTestData.oppId;
        ftOppty.AccountId = tAccount.id;
        ftOppty.Source_System_Detail__c = tSSDAccount.id;
        ftOppty.Campaign_Code__c ='00237KI';
        ftOppty.Renewal_Date__c = system.today().addDays(50);
        ftOppty.Key_Contact__c = tContact.id;
        ftOppty.LCRM_Sub_BU__c=  'FindLaw';
        //ftOppty.Owner = U1;
        update ftOppty;
        
        test.starttest();
        Apttus_Proposal__Proposal__c stProposal = DCTestData.createQuote(tAccount.id ,'Straight Renewal');
        stProposal.Apttus_Proposal__Opportunity__c = tOppty.id; 
        insert  stProposal;
        
      
        Apttus_Proposal__Proposal__c plusProposal = DCTestData.createQuote(tAccount.id ,'Best Value');
        plusProposal.Apttus_Proposal__Opportunity__c = tOppty.id;
        insert plusProposal;
        
        //This is added to fix flow error to add SSD on old proposal
       /* Apttus_Proposal__Proposal__c cproposal = DCTestData.createQuote(tAccount.Id, 'Best Value+Config');
        cproposal.APTS_SSD_Sold_To__c = tSSDAccount.id;
        cproposal.APTS_SSD_bill_to__c = tSSDAccount.id;
        cproposal.Apttus_Proposal__Opportunity__c = tOppty.id;
        insert cproposal;*/
        /*
        opportunity opptyList =  [Select id,name,Ownerid,owner.name,owner.id,AccountId,Source_System_Detail__c,Source_System_Detail__r.LCRM_APTS_Band_Number__c,
                                  Source_System_Detail__r.LCRM_eOutput_Eligibility__c,Status__c,StageName,Renewal_Date__c,RecordTypeId,Campaign_Code__c, Source_System_Detail__r.Digital_Firm__c, 
                                  SAP_Account_Number__c FROM Opportunity where AccountId =: tAccount.id limit 1];
        

        LCRM_Contact_SSD__c lcrmlist =[select id,LCRM_Account_SSD__r.id,LastModifiedDate,LCRM_Hard_Bounce__c,LCRM_Contact__r.Id,LCRM_Contact__r.Email,LCRM_Contact__r.SAP_Contact_ID__c,LCRM_SAP_Role__c,LCRM_Job_Function__c,LCRM_Email__c,LCRM_Source_Contact_Id__c from LCRM_Contact_SSD__c where LCRM_Account_SSD__r.id =: tSSDAccount.Id ];
        */

        
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>(
            [SELECT AccountSSD__c,Type__c,Campaign_Code__c,Quantity__c,Actual_New_Service__c,
            Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Service__c,
            Premium_New_Subscription__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c,Renewal_Date__c 
            FROM Product_Account_Detail__c 
            LIMIT 50000]);
        
        Product_Account_Detail__c dsPremium =  new Product_Account_Detail__c();
        //DCTestData.createDigitalSubscriptions('42009614','42009614', 'Premium', '1004284494', System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim())), '00237KI');
        
        dsPremium.Account__c = tAccount.id;
        dsPremium.AccountSSD__c = tSSDAccount.Id;
        dsPremium.Premium_New_Service__c = '40974108';
        dsPremium.Premium_New_Subscription__c = '42009614';
        //dsPremium.Current_Subscription__c = '42009617';
        dsPremium.Actual_New_Subscription_Product__c = upsellProd.id;
        dsPremium.Actual_New_Subscription__c ='';
        dsPremium.Actual_New_Service__c ='';
        dsPremium.Offer_Price__c = 5;
        dsPremium.Quantity__c = 1;
        dsPremium.Current_Term_Length__c = 3;
        dsPremium.Year1_YoYvalue__c = 7;
        dsPremium.Year3_YoYvalue__c = 2;
        dsPremium.Digital_Firm__c = 'Small Law';
        dsPremium.Type__c ='Premium';
        dsPremium.Hard_Bounce__c = True;
        dsPremium.SAP_Contact_Id__c = '12345';
        dsPremium.ZP_Cust_Number__c = '1004284494';
        dsPremium.Campaign_Code__c = '00237KI';
        dsPremium.Offer_Price__c = 4;
        dsPremium.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsPremium);
        
        
        Product_Account_Detail__c dsPremium2 =  new Product_Account_Detail__c();
        
        dsPremium2.Account__c = tAccount.id;
        dsPremium2.AccountSSD__c = tSSDAccount.Id;
        dsPremium2.Premium_New_Service__c = '42004985';
        dsPremium2.Premium_New_Subscription__c = '42004987';
        //dsPremium2.Current_Subscription__c = '42009617';
        dsPremium2.Actual_New_Subscription_Product__c = upsellProd2.id;
        dsPremium2.Actual_New_Subscription__c ='';
        dsPremium2.Actual_New_Service__c ='';
        dsPremium2.Offer_Price__c = 5;
        dsPremium2.Quantity__c = 1;
        dsPremium2.Digital_Firm__c = 'Small Law';
        dsPremium2.Type__c ='Premium';
        dsPremium2.Hard_Bounce__c = True;
        dsPremium2.SAP_Contact_Id__c = '12345';
        dsPremium2.ZP_Cust_Number__c = '1004284494';
        dsPremium2.Campaign_Code__c = '00237KI';
        dsPremium2.Offer_Price__c = 4;
        dsPremium2.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsPremium2);
        
       
        
        Product_Account_Detail__c dsPlusAddOn=  new Product_Account_Detail__c();
        
        dsPlusAddOn.Account__c = tAccount.id;
        dsPlusAddOn.AccountSSD__c = tSSDAccount.Id;
        dsPlusAddOn.Contract_Type__c  = 'New Mid Contract';
        dsPlusAddOn.Add_On_Svc__c = '42004985';
        dsPlusAddOn.Add_On_Sub__c= '42004987';  
        dsPlusAddOn.Actual_New_Subscription_Product__c = upsellProd2.id;      
        dsPlusAddOn.Default_Add_On__c = true;       
        dsPlusAddOn.Offer_Price__c = 5;
        dsPlusAddOn.Quantity__c = 1;
        dsPlusAddOn.Digital_Firm__c = 'Small Law';
        dsPlusAddOn.Add_on_Type__c ='Plus';
        dsPlusAddOn.Type__c ='Premium';
        dsPlusAddOn.Hard_Bounce__c = True;
        dsPlusAddOn.SAP_Contact_Id__c = '12345';
        dsPlusAddOn.ZP_Cust_Number__c = '1004284494';
        dsPlusAddOn.Campaign_Code__c = '00237KI';
        dsPlusAddOn.Offer_Price__c = 4;
        dsPlusAddOn.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsPlusAddOn);
        
        
        Product_Account_Detail__c dsPlus1 =  new Product_Account_Detail__c();
        
        dsPlus1.Account__c = tAccount.id;
        dsPlus1.AccountSSD__c = tSSDAccount.Id;    
        dsPlus1.Actual_New_Subscription_Product__c = upsellProd.id;
        dsPlus1.Actual_New_Subscription__c ='42009614';
        dsPlus1.Actual_New_Service__c = '40974108';
        dsPlus1.Offer_Price__c = -5;
        dsPlus1.Quantity__c = 1;
        dsPlus1.Digital_Firm__c = 'Small Law';
        dsPlus1.Type__c ='Premium';
        dsPlus1.Hard_Bounce__c = True;
        dsPlus1.SAP_Contact_Id__c = '12345';
        dsPlus1.ZP_Cust_Number__c = '1004284494';
        dsPlus1.Campaign_Code__c = '00237KI';
        dsPlus1.Offer_Price__c = 4;
        dsPlus1.Current_Term_Length__c = 2;
        dsPlus1.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsPlus1);
        
       
        

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
        dsCurrent.Digital_Firm__c = 'Small Law';
        dsCurrent.Type__c ='Premium';
        dsCurrent.Hard_Bounce__c = True;
        dsCurrent.SAP_Contact_Id__c = '12345';
        dsCurrent.ZP_Cust_Number__c = '1004284494';
        dsCurrent.Campaign_Code__c = '00237KI';
        dsCurrent.Offer_Price__c = 4;
        dsPlus1.Current_Term_Length__c = 2;
        dsCurrent.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        prodactdetailList.add(dsCurrent);
       
        Product_Account_Detail__c dsOptionStraight = new Product_Account_Detail__c();
        dsOptionStraight.Account__c = tAccount.id;
        dsOptionStraight.AccountSSD__c = tSSDAccount.Id;
        dsOptionStraight.Current_Subscription__c = '42076368';       
        dsOptionStraight.Offer_Price__c = 5;
        dsOptionStraight.Quantity__c = 1;
        dsOptionStraight.Digital_Firm__c = 'Corporate';
        dsOptionStraight.Type__c ='Premium';
        dsOptionStraight.Hard_Bounce__c = True;
        dsOptionStraight.SAP_Contact_Id__c = '12345';
        dsOptionStraight.ZP_Cust_Number__c = '1004284494';
        dsOptionStraight.Campaign_Code__c = '00237KI';
        dsOptionStraight.Offer_Price__c = 4;
        dsOptionStraight.Bundle_Id__c = bundlePRod.Id;
        dsOptionStraight.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        dsOptionStraight.Contract_Type__c  = 'New Mid Contract';
        dsOptionStraight.Default_Add_On__c = true; 
        dsOptionStraight.Add_On_Svc__c  = '42004985';
        dsOptionStraight.Add_On_Sub__c= '42004987'; 
        prodactdetailList.add(dsOptionStraight);
        
        Product_Account_Detail__c dsOption = new Product_Account_Detail__c();
        dsOption.Account__c = tAccount.id;
        dsOption .AccountSSD__c = tSSDAccount.Id;
        dsOption.Premium_New_Service__c = '42076367';
        dsOption.Premium_New_Subscription__c = '42076368';        
        dsOption.Actual_New_Subscription_Product__c = optionProd.id;
        dsOption.Actual_New_Subscription__c ='';
        dsOption.Actual_New_Service__c ='';
        dsOption.Offer_Price__c = 5;
        dsOption.Quantity__c = 1;
        dsOption.Digital_Firm__c = 'Corporate';
        dsOption.Type__c ='Premium';
        dsOption.Hard_Bounce__c = True;
        dsOption.SAP_Contact_Id__c = '12345';
        dsOption.ZP_Cust_Number__c = '1004284494';
        dsOption.Campaign_Code__c = '00237KI';
        dsOption.Offer_Price__c = 4;
        dsOption.Bundle_Id__c = bundlePRod.Id;
        dsOption.Add_On_Svc__c  = '42004985';
        dsOption.Add_On_Sub__c  = '42004987';
        
        dsOption.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        
        prodactdetailList.add(dsOption);
        
        Product_Account_Detail__c dsOptionBest = new Product_Account_Detail__c();
        dsOptionBest.Account__c = tAccount.id;
        dsOptionBest .AccountSSD__c = tSSDAccount.Id;             
        dsOptionBest.Actual_New_Subscription_Product__c = optionProd.id;
        dsOptionBest.Actual_New_Subscription__c ='42076368';
        dsOptionBest.Actual_New_Service__c ='42076367';
        dsOptionBest.Offer_Price__c = 5;
        dsOptionBest.Quantity__c = 1;
        dsOptionBest.Digital_Firm__c = 'Corporate';
        dsOptionBest.Type__c ='Premium';
        dsOptionBest.Hard_Bounce__c = True;
        dsOptionBest.SAP_Contact_Id__c = '12345';
        dsOptionBest.ZP_Cust_Number__c = '1004284494';
        dsOptionBest.Campaign_Code__c = '00237KI';
        dsOptionBest.Offer_Price__c = 4;
        dsOptionBest.Bundle_Id__c = bundlePRod.Id;
        dsOptionBest.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
        dsOptionBest.Contract_Type__c  = 'New Mid Contract';
        dsOptionBest.Default_Add_On__c = true;  
        dsOptionBest.Add_On_Svc__c  = '42004985';
        dsOptionBest.Add_On_Sub__c  = '42004987';
        dsOptionBest.Add_on_Type__c = 'Plus';
        prodactdetailList.add(dsOptionBest);
        
        insert prodactdetailList;
        
        set<String> productIds = new set<String>();
        for(Product_Account_Detail__c p : [select Actual_New_Subscription_Product__c from Product_Account_Detail__c where id in :prodactdetailList]){
            if(p.Actual_New_Subscription_Product__c !=null){
                productIds.add(p.Actual_New_Subscription_Product__c);
            }
        }
            productIds.add(upsellProd2.Id);
        test.stoptest();
         system.AssertEquals(prodactdetailList[0].AccountSSD__c,String.valueOf(tSSDAccount.id),'Assert failed');
        
        
        List<Apttus_Config2__PriceListItem__c> lstPLis = new List<Apttus_Config2__PriceListItem__c>();
        Pricebook2 pbook1 = new Pricebook2();
        pbook1.name =  'GLI Price Book - FindLaw';
        insert pbook1;
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
        ali.Apttus_QPConfig__ProposalId__c = stproposal.id;
        ali.APTS_SSD_Bill_To__c = tSSDAccount.Id; 
        ali.APTS_SSD_Ship_to__c = tSSDAccount.Id;  
        ali.APTS_SSD_Sold_To__c = tSSDAccount.Id;      
        aliList.add(ali);    
        
        insert aliList;
        
       Apttus_Config2__ClassificationName__c className= new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__Active__c=true;
        className.Apttus_Config2__HierarchyLabel__c='ExposureLabel';
        className.Apttus_Config2__Type__c='Option Group';
        className.Name='ExposureLabelName';
        insert className;
        
         Apttus_Config2__ClassificationHierarchy__c optionclass= new Apttus_Config2__ClassificationHierarchy__c();
        optionclass.Apttus_Config2__DefaultSearchCategory__c=false;
        optionclass.Apttus_Config2__ExpandedByDefault__c=false;
        optionclass.Apttus_Config2__HideAllSearchFilters__c=false;
        optionclass.Apttus_Config2__IncludeInTotalsView__c=true;
        optionclass.Apttus_Config2__IsHidden__c=false;
        optionclass.Apttus_Config2__IsPicklist__c=false;
        optionclass.Apttus_Config2__Label__c='ExposureLabelName';
        optionclass.Apttus_Config2__Modifiable__c=true;
        optionclass.DC_Is_Title_Visible__c=false;
        optionclass.Apttus_Config2__HierarchyId__c=className.id;
        optionclass.Name='ExposureLabelName';
        insert optionclass;
        
        Apttus_Config2__ProductOptionGroup__c optiongroup1=new Apttus_Config2__ProductOptionGroup__c();
        optiongroup1.Apttus_Config2__IsHidden__c=false;
        optiongroup1.Apttus_Config2__IsLeaf__c=true;
        optiongroup1.Apttus_Config2__IsPicklist__c=false;
        optiongroup1.Apttus_Config2__Sequence__c=0;
        optiongroup1.Apttus_Config2__OptionGroupId__c=optionclass.id;
        optiongroup1.Apttus_Config2__ProductId__c=optionProd.id;
        optiongroup1.Apttus_Config2__RootOptionGroupId__c=optionclass.id;
        insert optiongroup1;
        
        Apttus_Config2__ProductOptionComponent__c option1 = new Apttus_Config2__ProductOptionComponent__c();
        option1.Apttus_Config2__AllowCloning__c= false;
        option1.Apttus_Config2__AutoUpdateQuantity__c=false;
        option1.Apttus_Config2__Default__c=false;
        option1.Apttus_Config2__Modifiable__c=false;
        option1.Apttus_Config2__Sequence__c=0;
        option1.Apttus_Config2__Required__c=false;
        option1.Apttus_Config2__ParentProductId__c = bundlePRod.Id;
        option1.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
        option1.Apttus_Config2__ComponentProductId__c=optionProd.id;
        insert option1;
        
         List<Product_Account_Detail__c > dSubList = [
            SELECT Bundle_Id__c, Campaign_Code__c, ZP_Cust_Number__c, Digital_Firm__c, Contract_Type__c, 
                Add_on_Type__c, Default_Add_On__c, Add_On_Sub__c, Add_On_Svc__c, Current_Term_Length__c, 
                Type__c, Premium_New_Service__c, Premium_New_Subscription__c, Year1_YoYvalue__c, Year2_YoYvalue__c, 
                Year3_YoYvalue__c, AccountSSD__c, Actual_New_Service__c, Actual_New_Subscription__c, 
                Actual_New_Subscription_Product__c, Actual_New_Subscription_Product__r.APTS_Module_Points__c, 
                Quantity__c, Current_Subscription__c, Offer_Price__c, Renewal_Date__c, DC_Contract_Number__c 
            FROM Product_Account_Detail__c 
            WHERE ZP_Cust_Number__c ='1004284494' AND Campaign_Code__c != null 
            AND Renewal_Date__c > Today AND Bypass_Automation__c = false
        ]; 
        
        for(Product_Account_Detail__c  p: dSubList){
            system.debug(LoggingLevel.DEBUG,'p::' + p);
        }
        
        system.AssertEquals(plusProposal.Digital_Quote_Type__c, 'Best Value','Assert failed');

    }   
    
    private static testmethod void cartCodetestStraight(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        test.starttest();
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Straight Renewal');
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed');                                                
        test.stoptest();
        
    }
    private static testmethod void cartCodetestBest(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        
        
        test.starttest();
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Best Value');
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed');
        test.stoptest();
        
    }
   private static testmethod void cartCodetestPremium(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        test.starttest();
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Premium');
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed'); 
        test.stoptest();
        
  }
  
    private static testmethod void cartCodetestAddOptionsPremium(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        test.starttest();
        
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Premium');
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed');
        test.stoptest();
        
    }
  
    private static testmethod void cartCodetestAddOptionsBest(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        test.starttest();    
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Best Value');        
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed');
        Product2 optionProd = [SELECT id FROM Product2 WHERE Name = 'GC American Jurisprudence (AMJUR) (CORP) (WestlawPRO™)' LIMIT 1];
        Apttus_Config2__ProductOptionComponent__c prodOptComp = [SELECT id,Apttus_Config2__ComponentProductId__c 
                                                                FROM Apttus_Config2__ProductOptionComponent__c 
                                                                WHERE Apttus_Config2__ComponentProductId__c =: optionProd.id 
                                                                LIMIT 1];
        Product_Account_Detail__c pad = [
            SELECT Bundle_Id__c, Campaign_Code__c, ZP_Cust_Number__c, Digital_Firm__c, Contract_Type__c, 
                Add_on_Type__c, Default_Add_On__c, Add_On_Sub__c, Add_On_Svc__c, Current_Term_Length__c, 
                Type__c, Premium_New_Service__c, Premium_New_Subscription__c, Year1_YoYvalue__c, Year2_YoYvalue__c, 
                Year3_YoYvalue__c, AccountSSD__c, Actual_New_Service__c, Actual_New_Subscription__c, 
                Actual_New_Subscription_Product__c, Actual_New_Subscription_Product__r.APTS_Module_Points__c, 
                Quantity__c, Current_Subscription__c, Offer_Price__c, Renewal_Date__c, DC_Contract_Number__c,One_Year_Experience_Flag__c  
            FROM Product_Account_Detail__c 
            WHERE Actual_New_Subscription_Product__c =: optionProd.id LIMIT 1];

        Digital_BundleProductCreation.createOptionProduct(pad,prodOptComp.id,prodOptComp.Apttus_Config2__ComponentProductId__c);
        
        test.stoptest();
        
    }
    private static testmethod void cartCodetestOptionsStraight(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        test.starttest();    
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Straight Renewal');        
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed');
        test.stoptest();
        
    }
  
    private static testmethod void cartCodetestStraightRenDatePast(){
        
        List<id> proposalidlist = new List<id>();
        
        for(Apttus_Proposal__Proposal__c prop :[select id,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c limit 3]){
            proposalidlist.add(prop.id);
        }
        test.starttest();
        List<Apttus_Config2__AssetLineItem__c> aliList = new List<Apttus_Config2__AssetLineItem__c>();
        for(Apttus_Config2__AssetLineItem__c ali : [SELECT APTS_Info_RenewalDate__c,Apttus_Config2__RenewalDate__c FROM Apttus_Config2__AssetLineItem__c limit 1]){
            ali.APTS_Info_RenewalDate__c = System.Today() - 2;
            ali.Apttus_Config2__RenewalDate__c = System.Today() - 2;
            aliList.add(ali);
        }
        update aliList;
        Digital_CartCreationCommoncode.ContractTerms(proposalidlist,'Straight Renewal');
        system.AssertNotEquals(proposalidlist.size(), 0,'Assert failed');                                                
        test.stoptest();
        
    }

  private static testmethod void addAdjustmentTest(){

    List<Product_Account_Detail__c> padlist = new List<Product_Account_Detail__c>();
    for(Product_Account_Detail__c pad: [SELECT Bundle_Id__c, Campaign_Code__c, ZP_Cust_Number__c, Digital_Firm__c, Contract_Type__c, 
                                            Add_on_Type__c, Default_Add_On__c, Add_On_Sub__c, Add_On_Svc__c, Current_Term_Length__c, 
                                            Type__c, Premium_New_Service__c, Premium_New_Subscription__c, Year1_YoYvalue__c, Year2_YoYvalue__c, 
                                            Year3_YoYvalue__c, AccountSSD__c, Actual_New_Service__c, Actual_New_Subscription__c, 
                                            Actual_New_Subscription_Product__c, Actual_New_Subscription_Product__r.APTS_Module_Points__c, 
                                            Quantity__c, Current_Subscription__c, Offer_Price__c, Renewal_Date__c, DC_Contract_Number__c 
                                        FROM Product_Account_Detail__c 
                                        WHERE Current_Subscription__c != null
                                    ]){
        pad.Digital_Firm__c = 'Government';
        padlist.add(pad);
    }
    
    update padlist;

    List<Id> listid = new List<Id>();
    for(Apttus_Proposal__Proposal__c prop :[select id from Apttus_Proposal__Proposal__c WHERE Digital_Quote_Type__c = 'Straight Renewal' LIMIT 1]){
        listid.add(prop.id);
    }
    test.startTest();
    System.AssertNotEquals(listid, null, 'SOQL returned null');
    Digital_CartCreationCommonCode.ContractTerms(listid, 'Straight Renewal');
    test.stopTest();

    }
  
    private static testmethod void findlawAdjustmentTest(){
        Map<String, List<Product_Account_Detail__c>> acctDSmap;
        Apttus_Config2__AssetLineItem__c soldToAssets;
        
        test.startTest();
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
        lineItem = Digital_CartCreationHelper.getFindLawStraightAdjustmentValue(lineItem, acctDSmap, soldToAssets);
        System.AssertNotEquals(lineItem , null, 'Line Item is null');
        test.stopTest();
    }
    private static testmethod void oneYearExpTest(){
    
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
        test.startTest();
        lineItem = Digital_CartCreationHelper.updateLineItemToOneYearExperience(lineItem, TRUE, 10);
        lineItem = Digital_CartCreationHelper.updateLineItemToOneYearExperience(lineItem, TRUE, -10);
        System.AssertNotEquals(lineItem , null, 'Line Item is null');
        test.stopTest();
    
    }

    private static testmethod void populateBundleDataTest(){
        Product2 optionProd = [SELECT id FROM Product2 WHERE Name = 'GC American Jurisprudence (AMJUR) (CORP) (WestlawPRO™)' LIMIT 1];
        Product_Account_Detail__c pad = [
            SELECT Bundle_Id__c, Campaign_Code__c, ZP_Cust_Number__c, Digital_Firm__c, Contract_Type__c, 
                Add_on_Type__c, Default_Add_On__c, Add_On_Sub__c, Add_On_Svc__c, Current_Term_Length__c, 
                Type__c, Premium_New_Service__c, Premium_New_Subscription__c, Year1_YoYvalue__c, Year2_YoYvalue__c, 
                Year3_YoYvalue__c, AccountSSD__c, Actual_New_Service__c, Actual_New_Subscription__c, 
                Actual_New_Subscription_Product__c, Actual_New_Subscription_Product__r.APTS_Module_Points__c, 
                Quantity__c, Current_Subscription__c, Offer_Price__c, Renewal_Date__c, DC_Contract_Number__c,One_Year_Experience_Flag__c  
            FROM Product_Account_Detail__c 
            WHERE Actual_New_Subscription_Product__c =: optionProd.id LIMIT 1];
        System.assert(pad!=null,'No DS records pulled');
        Test.startTest();
        Digital_BundleProductCreation.populateBundleData(pad);//First call
        Digital_BundleProductCreation.populateBundleData(pad);//Second call
        Test.stopTest();
    }
}