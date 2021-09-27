@isTest 
private class APTS_AccInstalledProductsControllerTest {
    static testMethod void pageTest()
    {
       
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='BusinessPartnerBillPay', value__c='Bill-to party'),
                                                                         new Static_Values__c(name='BusinessPartnerShipPay', value__c='Ship-to party'),
                                                                         new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        
        insert staticCSList ;
        
       
       
        //Test converage for the myPage visualforce page
        PageReference pageRef = Page.APTS_CustomInstalledProducts;
        Test.setCurrentPageReference(pageRef);
        Account newAccount = new Account (name='XYZ Organization');
        insert newAccount;
        
        //create product
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware');
        insert prod;

        Apttus_Proposal__Proposal__c prop =new Apttus_Proposal__Proposal__c();
        prop.Apttus_Proposal__Account__c=newAccount.Id;
        insert prop;

        // creat asset line items     
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(name='ali_test', Apttus_Config2__AccountId__c=newAccount.id, CurrencyIsoCode='USD', Apttus_Config2__AssetStatus__c='Activated', Apttus_Config2__ProductId__c=prod.id, Apttus_Config2__Quantity__c=1.256, Apttus_Config2__IsInactive__c = False, Apttus_Config2__SellingTerm__c=6.39);
        ali.Apttus_QPConfig__ProposalId__c=prop.Id;
        insert ali;
        
        Test.StartTest();
        
        ApexPages.StandardController sc = new ApexPages.standardController(newAccount);
        // create an instance of the controller
        APTS_AccInstalledProductsController myPageCon = new APTS_AccInstalledProductsController(sc);
        //try calling methods/properties of the controller in all possible scenarios
        Test.StopTest();
    }
    
    static testMethod void pageTest_nullAccount()
    {
        //Test converage for the myPage visualforce page
        PageReference pageRef = Page.APTS_CustomInstalledProducts;
        Test.setCurrentPageReference(pageRef);
        Account newAccount = new Account (name='XYZ Organization');
        insert newAccount;
        
        //create product
        Product2 prod = new Product2(Name = 'Laptop X200', 
                                     Family = 'Hardware');
        insert prod; 

        Apttus_Proposal__Proposal__c prop =new Apttus_Proposal__Proposal__c();
        prop.Apttus_Proposal__Account__c=newAccount.Id;
        insert prop;

        // creat asset line items     
        Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(name='ali_test', CurrencyIsoCode='USD', Apttus_Config2__AssetStatus__c='Activated', Apttus_Config2__ProductId__c=prod.id, Apttus_Config2__Quantity__c=1.256, Apttus_Config2__IsInactive__c = False, Apttus_Config2__SellingTerm__c=6.39);
        ali.Apttus_QPConfig__ProposalId__c=prop.Id;
        insert ali;
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.standardController(newAccount);
        // create an instance of the controller
        APTS_AccInstalledProductsController myPageCon = new APTS_AccInstalledProductsController(sc);
        //try calling methods/properties of the controller in all possible scenarios
        Test.StopTest();
    }    
    
}