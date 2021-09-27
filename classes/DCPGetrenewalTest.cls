/**
    @description Test class for DCPGetRenewal
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    2021-06-10      Satish Inturi       DCP_2032 | Initial Creation
	2021-06-29      Vishnu Santhosh		DCP-2439 | Fixed PMD Violations
 */

@isTest
public class DCPGetrenewalTest {
    private static final String DIGITAL_QUOTE_TYPE_PLUS = 'Best Value';
    private static final String DIGITAL_QUOTE_TYPE_MANUAL = 'Manual';
    private static final String DIGITAL_QUOTE_TYPE_STRAIGHT = 'Straight Renewal'; 
    private static final String DIGITAL_QUOTE_TYPE_PREMIUM = 'Premium'; 

    static testMethod string queryData(){
        DCPTestDataFactory.disableApplicationAutomation();
        UnitTest.createTestData();
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;        
        //Standard PricebookEntry
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //Account data
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;        
        //Contact data
        Contact testcontact= UnitTest.getContactInstance(testAcc.Id);
        testcontact.LastName = 'Testcontact';
        testcontact.FirstName = 'Testcontact';
        testcontact.AccountId = testAcc.Id;
        testcontact.email = 'testfirst.testlast@thomson.com';
        insert testcontact;    
       
        Source_System_Detail__c ass = new Source_System_Detail__c();
        ass.Account_Name__c = testAcc.Id;
        ass.name= 'test';
        ass.Source_System_Name__c='test';
        insert ass;
        //Opportunity data: set1(standard pricebook)
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Name = 'Test Opp1';
        testOpp1.Key_Contact__c = testcontact.Id;
        testOpp1.Renewal_Flag__c = true;
        testOpp1.Selling_Organization__c = 'LRA';
        testOpp1.currencyIsoCode = 'USD';
        testOpp1.Pricebook2Id = testEntry.Pricebook2Id;
        testOpp1.Sales_Org__c = 'TSL';
        testOpp1.Renewal_Date__c = system.today().addDays(180);
        //testOpp1.autoRenewalDate=testOpp1.Renewal_Date__c.addDays(1);
        //testOpp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp1;
       
        Map<String, String> reqParameter = new Map<String, String> ();
        reqParameter.put('oppId', testOpp1.Id);
        reqParameter.put('ssdId', ass.Id);
        try{
        DCPRenewalResponse response = new DCPRenewalResponse();
        Test.startTest();
        response = DCPGetRenewal.getDCPRenewalResponse(reqParameter);
        Test.stopTest();
        System.debug(LoggingLevel.DEBUG,'** DEBUGGING : '+DCPGetRenewal.getDCPRenewalResponse(reqParameter));
        Contact retrievedContact = new Contact();
        retrievedContact = [SELECT Id,FirstName From Contact LIMIT 1];
        System.assertEquals(response.data.contactData.FirstName, retrievedContact.FirstName, 'The returned data is not correct !');
        }
        Catch(exception ex){
            return null;
        }
    
        return null;
    }
     static testMethod void manualOfferReplacementTest(){
 Apttus_Proposal__Proposal__c straightProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_STRAIGHT);
 Apttus_Proposal__Proposal__c plusProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_PLUS);
Apttus_Proposal__Proposal__c premiumProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_PREMIUM);
Apttus_Proposal__Proposal__c manualProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_MANUAL,Display_in_CXD_Renewals__c=true);

         //Test for orders without any manual entries
               List<Apttus_Proposal__Proposal__c> inputFirstCart = new List<Apttus_Proposal__Proposal__c>();
               List<Apttus_Proposal__Proposal__c> outputFirstCart = new List<Apttus_Proposal__Proposal__c>();
                inputFirstCart.add(straightProposal);
                inputFirstCart.add(plusProposal);
                inputFirstCart.add(premiumProposal);
                outputFirstCart = DCPGetRenewal.manualOfferReplacement(inputFirstCart);
                 System.assertEquals(outputFirstCart.size(),3,'cart length exceed to 3');
         
        //Test for orders with one manual entry and three digital created proposals
               List<Apttus_Proposal__Proposal__c> inputSecondCart = new List<Apttus_Proposal__Proposal__c>();
               List<Apttus_Proposal__Proposal__c> outputSecondCart = new List<Apttus_Proposal__Proposal__c>();
                
                inputSecondCart.add(manualProposal);
                outputSecondCart = DCPGetRenewal.manualOfferReplacement(inputSecondCart); 
                inputSecondCart.add(straightProposal);
                outputSecondCart = DCPGetRenewal.manualOfferReplacement(inputSecondCart); 
                inputSecondCart.add(plusProposal);
               outputSecondCart = DCPGetRenewal.manualOfferReplacement(inputSecondCart); 
                inputSecondCart.add(premiumProposal);
                outputSecondCart = DCPGetRenewal.manualOfferReplacement(inputSecondCart); 
               inputSecondCart.remove(1);
               outputSecondCart = DCPGetRenewal.manualOfferReplacement(inputSecondCart);
         inputSecondCart.remove(1);
               outputSecondCart = DCPGetRenewal.manualOfferReplacement(inputSecondCart);
                 //Test for orders with three manual entry and three digital created proposals
               List<Apttus_Proposal__Proposal__c> inputFourthCart = new List<Apttus_Proposal__Proposal__c>();
               List<Apttus_Proposal__Proposal__c> outputFourthCart = new List<Apttus_Proposal__Proposal__c>();
                 inputFourthCart.add(manualProposal);
                inputFourthCart.add(manualProposal);
           inputFourthCart.add(premiumProposal);
         outputFourthCart = DCPGetRenewal.manualOfferReplacement(inputFourthCart);
          outputFourthCart.remove(2);
         inputFourthCart.add(plusProposal);
         outputFourthCart = DCPGetRenewal.manualOfferReplacement(inputFourthCart);
                inputFourthCart.add(straightProposal);
        /* outputFourthCart = DCPGetRenewal.manualOfferReplacement(inputFourthCart);
                inputFourthCart.add(plusProposal);
         outputFourthCart = DCPGetRenewal.manualOfferReplacement(inputFourthCart);*/
                inputFourthCart.add(premiumProposal);
         outputFourthCart = DCPGetRenewal.manualOfferReplacement(inputFourthCart);
                inputFourthCart.add(manualProposal);
                 outputFourthCart = DCPGetRenewal.manualOfferReplacement(inputFourthCart);
         
           //Test for orders with more than three manually created proposals
               List<Apttus_Proposal__Proposal__c> inputFifthCart = new List<Apttus_Proposal__Proposal__c>();
               List<Apttus_Proposal__Proposal__c> outputFifthCart = new List<Apttus_Proposal__Proposal__c>();
                inputFifthCart.add(manualProposal);
                inputFifthCart.add(plusProposal);
                inputFifthCart.add(premiumProposal);
                inputFifthCart.add(manualProposal);
                inputFifthCart.add(manualProposal);
                inputFifthCart.add(manualProposal);
                outputFifthCart = DCPGetRenewal.manualOfferReplacement(inputFifthCart);
                system.assertEquals(3, outputFifthCart.size(), 'cart size is not 3 in ouptput');
                  system.assert(outputFifthCart[0].Digital_Quote_Type__c==DIGITAL_QUOTE_TYPE_MANUAL,'First item is not Manual');
         // DCPGetRenewal.manualOfferReplacement(List < Apttus_Proposal__Proposal__c> carts) 
   
     }
    static testMethod void ifCartListContainsThreeDigitalProposalsTest(){
        Apttus_Proposal__Proposal__c straightProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_STRAIGHT);
 Apttus_Proposal__Proposal__c plusProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_PLUS);
Apttus_Proposal__Proposal__c premiumProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_PREMIUM);
Apttus_Proposal__Proposal__c manualProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_MANUAL,Display_in_CXD_Renewals__c=true);

 
//Test for orders with two manual entry and three digital created proposals
               List<Apttus_Proposal__Proposal__c> inputThirdCart = new List<Apttus_Proposal__Proposal__c>();
               List<Apttus_Proposal__Proposal__c> outputThirdCart = new List<Apttus_Proposal__Proposal__c>();
         inputThirdCart.add(manualProposal);
                inputThirdCart.add(manualProposal);
         outputThirdCart = DCPGetRenewal.manualOfferReplacement(inputThirdCart);
                inputThirdCart.add(straightProposal);
         outputThirdCart = DCPGetRenewal.manualOfferReplacement(inputThirdCart);
                inputThirdCart.add(plusProposal);
         outputThirdCart = DCPGetRenewal.manualOfferReplacement(inputThirdCart);
                inputThirdCart.add(premiumProposal);
                  system.assert(outputThirdCart[0].Digital_Quote_Type__c==DIGITAL_QUOTE_TYPE_STRAIGHT,'First item is not Manual');
                outputThirdCart = DCPGetRenewal.manualOfferReplacement(inputThirdCart);
         inputThirdCart.remove(1);
               outputThirdCart = DCPGetRenewal.manualOfferReplacement(inputThirdCart);
         inputThirdCart.remove(1);
               outputThirdCart = DCPGetRenewal.manualOfferReplacement(inputThirdCart); 
         
        
    }
    
    
     static testMethod void checkIfCartContainsFourItemsWithoutManualOffersTest(){
 Apttus_Proposal__Proposal__c straightProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_STRAIGHT);
 Apttus_Proposal__Proposal__c plusProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_PLUS);
Apttus_Proposal__Proposal__c premiumProposal = new Apttus_Proposal__Proposal__c (Digital_Quote_Type__c=DIGITAL_QUOTE_TYPE_PREMIUM);

         //Test for orders without any manual entries
               List<Apttus_Proposal__Proposal__c> inputFirstCart = new List<Apttus_Proposal__Proposal__c>();
               List<Apttus_Proposal__Proposal__c> outputFirstCart = new List<Apttus_Proposal__Proposal__c>();
                inputFirstCart.add(straightProposal);
                inputFirstCart.add(plusProposal);
                inputFirstCart.add(premiumProposal);
                         inputFirstCart.add(premiumProposal);
                outputFirstCart = DCPGetRenewal.manualOfferReplacement(inputFirstCart);
         System.assertEquals(outputFirstCart.size(),3,'cart length exceed to 3');}
}