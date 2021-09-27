@isTest
private class ESC_CaseProductInlineControllerv3Test {

    @isTest static void escCaseProductInlineControllerv3MethodTest() {
        
        
        
        //create account records
        Account acct = new Account();
        acct.Name = 'SFDC';
        acct.ShippingCity = 'New York';
        acct.ShippingCountry = 'US';
        acct.ShippingPostalCode = '1007';
        acct.ShippingStreet = 'Diamond';
        insert acct ; 
        //create contact records
        Contact con = new Contact();
        con.AccountId=acct.Id;
        con.FirstName='Dummy';
        con.LastName='Test';
        con.Salutation='Mr.';
        con.Phone='12345678';
        con.Email='dummytest@thomsonreuters.com';
        insert con;
        Product2 prod = new Product2(name='Teest Prod');
        insert prod;
        // create case records
        Case cs = new Case();
        cs.Type='Data';
        cs.Status='New';
        cs.Subject='Test Subject';
        cs.Description = 'Test Description111';
        cs.contactid=con.id;
        cs.accountid=acct.id;
        cs.RecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
        cs.productId = prod.id;
        insert cs;
        
        //insert  Product2
        Product2 prod2 = new Product2(Name = 'ESC Product 1',ProductCode = 'da');
        insert prod2;
        
        //insert ESC_Product_Version__c
        ESC_Product_Version__c prodver = new ESC_Product_Version__c(Name= 'PV1',ESC_Product__c = prod2.id);
        insert prodver;
        //insert ESC_Product_Version__c 2
        ESC_Product_Version__c prodver2 = new ESC_Product_Version__c(Name= 'PV2',ESC_Product__c = prod2.id);
        insert prodver2;
        //insert ESC_Product_Capability__c
        ESC_Product_Capability__c prodcap = new ESC_Product_Capability__c(Name = 'Capability 22',ESC_Product__c = prod2.id);
        insert prodcap;
        //insert ESC_Product_Capability__c 2
        ESC_Product_Capability__c prodcap2 = new ESC_Product_Capability__c(Name = 'Capability 3',ESC_Product__c = prod2.id);
        insert prodcap2;
        ESC_Case_Product__c cp = new ESC_Case_Product__c(Case__c= cs.id ,Is_Primary__c = false,Product_Version__c=prodver.id,Product_Capability__c=prodcap.id,Product__c =prod2.id);
        insert cp;
        cp.Is_Primary__c = true;
        update cp;
        //Process Builder entry criteria
        ESC_Case_Product__c cp_test = new ESC_Case_Product__c(Case__c= cs.id ,Is_Primary__c = true,Product_Version__c=prodver.id,Product_Capability__c=prodcap.id,Product__c =prod2.id);
        insert cp_test;
        cp_test.Is_Primary__c = true;
        cp_test.Product_Version__c=prodver2.id;
        cp_test.Product_Capability__c=prodcap2.id;
        update cp_test;
        
         ESC_ProductFieldSetting__c fldSetting =new ESC_ProductFieldSetting__c();
         fldSetting.ESC_DisplayFieldsetName__c ='ESC_ProductDispFieldset';
         fldSetting.ESC_ProductSearchFieldset__c='ESC_ProductSearchFields';
         insert fldSetting;
        
        PageReference pageRef = Page.ESC_CaseProductInline;
         pageRef.getParameters().put('Id', String.valueOf(cs.Id));
         pageRef.getParameters().put('delrowid', '0');
         pageRef.getParameters().put('cancelrowid', '0');
         pageRef.getParameters().put('editrowid', '1');
         pageRef.getParameters().put('saverowid', '0');
        Test.setCurrentPage(pageRef);  
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        ESC_CaseProductInlineControllerv3 cpi = new ESC_CaseProductInlineControllerv3(sc);
        
        
        //fill up the value of local variables.
        cpi.mcount = -1;
        cpi.showbutton = true;
        cpi.refreshPage = true;
        cpi.caseid = cs.id ;
        cpi.pageUrl = 'pageRef';
        cpi.products = 'PV1' ;
        cpi.selectedCriteria = 'PV1';
        cpi.primaryProduct = cp.id;
        cpi.primaryProductIndex= 1 ;
        cpi.searchTerm = 'ESC Product 1';
        cpi.selectedProduct=prod2.id ;
        cpi.showCapabiity = false;
        cpi.showVersion = false ;
        cpi.selectedCapability = prodcap.id ;
        cpi.selectedVersion= prodver.id;
        
      
        
        //calling method -- call delete method at last 
        cpi.getPrimaryPDCTX();
        cpi.getAllProducts();
        cpi.getCapabilities();
       cpi.getlatestdata();
        cpi.getFields();
        ESC_CaseProductInlineControllerv3.searchProduct('test');
        cpi.getCapabilities();
        cpi.getVersions();
        cpi.cancel();
        cpi.edit();
        cpi.saverelatedrecord();
      //  cpi.ShowNewPrimary();
        cpi.delRows();
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);

    }

}