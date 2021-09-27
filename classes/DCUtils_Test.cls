@isTest
public class DCUtils_Test {
    
    @testSetup static void setupData(){
          DCTestData.createData();
          Test.startTest();
          DCTestData.createQuote();
          Source_System_Detail__c SSD = [select id from Source_System_Detail__c limit 1];
          Contact con = [select id,SAP_Role__c,SAP_Contact_ID__c,Email from Contact limit 1];
          DCTestData.createContactSSD(con,SSD);
          Test.stopTest();
    }
    //added by Navleen
    public static testmethod void capitalisationAccountTest(){
      test.starttest();
      List<Source_System_Detail__c> listOfSSD = [select id,Name,Digital_Firm_Name__c,City__c,Digital_Billing_City__c from Source_System_Detail__c limit 1];
      listOfSSD = DCUtils.formatSSDFirmName(listOfSSD);
      system.assert(listOfSSD != null, 'Error in DCUtils.formatSSDFirmName() method');
      test.stoptest();
     }
    //added by Navleen
    public static testmethod void capitalisationContactTest(){
      test.starttest();
      List<LCRM_Contact_SSD__c> listOfContact = [select id,LCRM_First_Name__c,Digital_FirstName__c from LCRM_Contact_SSD__c limit 1]; 
      listOfContact = DCUtils.formatContactSSDFirstName(listOfContact);
      system.assert(listOfContact != null, 'Error in DCUtils.formatContactSSDFirstName() method');
      test.stoptest();
  }
    
    public static testmethod void TestRepriceByQuoteId(){
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        
        Apttus_Config2__ProductConfiguration__c bCartRec = [SELECT id, Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =: cQuoteRec.Id limit 1];
        
        Test.startTest();
        DCUtils.repriceByQuoteId(bQuoteRec.Id);
        
        Apttus_Config2__LineItem__c liso = new Apttus_Config2__LineItem__c();
        DCUtils.addToLineItem(liso, 'Apttus_Config2__BillingFrequency__c', 'Monthly');
            
        Apttus_CPQApi.CPQ.AddMultiProductResponseDO response = DCUtils.addMultipleProducts( new Set<String>{testProduct.Id}, 3, bCartRec.Id, liso );
        
        System.assertNotEquals(response,null);
        
        DCUtils.removeLineItems( new List<Integer>{1}, bCartRec.Id );
        
        DCUtils.ProductDetails productDetails = new DCUtils.ProductDetails();
        productDetails.productId = testProduct.Id;
        productDetails.quantity = 3;
        
        Apttus_CPQApi.CPQ.AddMultiProductResponseDO response1 = DCUtils.addMultipleProducts(new List<DCUtils.ProductDetails> {productDetails}, bCartRec.Id, liSO );
        
        Test.stopTest();
        
        System.assertNotEquals(response1,null);
        
        
        
        try{
            Decimal d = 1/0;
        }Catch(Exception ex){
            DCUtils.trackLog(ex, 'DCUtils_Test', 'repriceByQuoteId');
        }
        
        
    }
    
    public static testmethod void TestOLCMethods(){
        Account testAcc = [select id from Account where Name = 'Test Account' limit 1];
        
        Apttus_Proposal__Proposal__c cQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value+Config' limit 1];
        
        Apttus_Proposal__Proposal__c bQuoteRec = [select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'Quote 1' AND Digital_Quote_Type__c = 'Best Value' limit 1];
        
        Product2 testProduct = [select id from Product2 where Name = 'SL California Analytical (Westlaw PRO™)' limit 1];
        
        Source_System_Detail__c accountSSD = [select id, LCRM_SAP_Account_Number__c from Source_System_Detail__c where LCRM_SAP_Account_Number__c = '1004284494' limit 1];
        
        List<Online_Contacts__c> OLCList = DCTestData.createOnline(bQuoteRec.Id,testAcc.Id);
        
        DCUtils.OnlineContact onlineCon = new DCUtils.OnlineContact();
        onlineCon.contactId = OLCList[0].id;
        onlineCon.firstName = 'Test FirstName';
        onlineCon.lastName = 'Test LastName';
        onlineCon.email = 'FirstName.LastName@TR.com';
        onlineCon.companyId = testAcc.Id ;
        onlineCon.sourceId = 'SAP';
        onlineCon.onlineContactType = '';
        onlineCon.onlineContactTypeDescription = '';
        onlineCon.allowContactEmails = true;
        onlineCon.selectedProduct=DCTestData.createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
        
        DCUtils.OnlineContact onlineCon1 = new DCUtils.OnlineContact();
        onlineCon1.contactId = OLCList[1].id;
        onlineCon1.firstName = 'Test FirstName';
        onlineCon1.lastName = 'Test LastName';
        onlineCon1.email = 'FirstName.LastName@TR.com';
        onlineCon1.companyId = testAcc.Id ;
        onlineCon1.sourceId = 'SAP';
        onlineCon1.onlineContactType = '';
        onlineCon1.onlineContactTypeDescription = '';
        onlineCon1.allowContactEmails = true;
        onlineCon1.selectedProduct=DCTestData.createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
        
        List<DCUtils.OnlineContact> OLCWrapList = new List<DCUtils.OnlineContact> {onlineCon, onlineCon1};
        
        DCUtils.OCAddRemoveRequest addRemRequest = new DCUtils.OCAddRemoveRequest();
        addRemRequest.quoteId = bQuoteRec.Id;
        addRemRequest.accountId = accountSSD.Id;
        addRemRequest.productId = testProduct.Id;
        addRemRequest.removeOnlineContact = false;
        addRemRequest.onlineContactList = OLCWrapList;
        
        DCUtils.OCAddRemoveRequest addRemRequest1 = new DCUtils.OCAddRemoveRequest();
        addRemRequest1.quoteId = cQuoteRec.Id;
        addRemRequest1.accountId = accountSSD.Id;
        addRemRequest1.productId = testProduct.Id;
        addRemRequest1.removeOnlineContact = true;
        addRemRequest1.onlineContactList = OLCWrapList;
        
        List<DCUtils.OCAddRemoveRequest> addRemRequestList = new List<DCUtils.OCAddRemoveRequest> {addRemRequest, addRemRequest1};
        
        Test.startTest();
        DCUtils.addRemoveOnlineContacts(addRemRequestList);
        
        List<Online_Contacts__c>  OLCConList = DCUtils.createOCInstanceList(addRemRequestList[0]);
        Test.stopTest();
        
        System.assertNotEquals(OLCConList,null);
    
    }
}