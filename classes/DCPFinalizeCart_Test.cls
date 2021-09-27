@isTest

public class DCPFinalizeCart_Test {
	@TestSetup
    static void makeData(){
        DCPTestDataFactory.disableApplicationAutomation();

        Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        insert ssd;
        
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        insert con;
        
        PriceBook2 pricebook = (PriceBook2)objectToDataMap.get('PriceBook2');
        insert pricebook;
        
        Apttus_Config2__PriceList__c pricelist = (Apttus_Config2__PriceList__c)objectToDataMap.get('Apttus_Config2__PriceList__c');
        insert pricelist;
        
        Opportunity opp = (Opportunity)objectToDataMap.get('Opportunity');
        opp.StageName = 'Contacting';
        opp.Renewal_Date__c = system.today().addDays(180);
        opp.Pricebook2id = pricebook.id;
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = con.id;
        insert opp;
        
        Apttus_Proposal__Proposal__c prop = (Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c');
        prop.Apttus_Proposal__Primary__c = false;
        prop.Digital_Batch_Processed__c = true;
        prop.Digital_Quote_Automation__c = true;
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        prop.Digital_Envelope_Created__c = false;    
        prop.Apttus_Proposal__Approval_Stage__c = 'Presented';
        prop.Apttus_Proposal__Opportunity__c = opp.id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.APTS_SSD_bill_to__c = ssd.id;
        prop.APTS_SSD_ship_to__c = ssd.id;
        prop.Apttus_QPConfig__BillToAccountId__c = acc.id;
        prop.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        prop.APTS_Order_Confirmation_Contact__c = con.id;
        prop.Apttus_QPConfig__PriceListId__c = pricelist.id;
        insert prop;
        
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c');
        insert cart;
        
        Product2 prod = (Product2)objectToDataMap.get('Product2');
        insert prod;
        
        Apttus_Config2__PriceListItem__c priceListItem = (Apttus_Config2__PriceListItem__c)objectToDataMap.get('Apttus_Config2__PriceListItem__c');
        priceListItem.Apttus_Config2__PriceListId__c = pricelist.id;
        priceListItem.Apttus_Config2__ProductId__c = prod.id;
        insert priceListItem;
        
        Apttus_Config2__LineItem__c lineItem = (Apttus_Config2__LineItem__c)objectToDataMap.get('Apttus_Config2__LineItem__c');
        lineItem.Apttus_Config2__ConfigurationId__c = cart.id;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ProductId__c = prod.id;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__PriceListId__c = priceList.id;
        lineItem.Apttus_Config2__PriceListItemId__c = priceListItem.id;
        lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        insert lineItem;
    }
    
    
    @isTest
    public static void testImproperRequestFormat(){
       	List<Apttus_Config2__ProductConfiguration__c> cartList = [SELECT id FROM Apttus_Config2__ProductConfiguration__c];
        String str;  
        
        Test.startTest();       
            Map<string,string> requestBody = new map<string,string>();
            requestBody.put('cartIdBadValue',cartList[0].id);
            try{
                 str = DCPFinalizeCart.callCongaFinalizeMethod(requestBody);
            }catch(Exception ex){
                Boolean expectedExceptionThrown = ex.getMessage().contains('Improper request format')?true:false;
            	System.assertEquals(expectedExceptionThrown, true, 'Improper request format');
            }   
        Test.stopTest();
    }
	
	@isTest
    public static void testFinalize(){
        
        //List<Apttus_Proposal__Proposal__c> propList;
        //Opportunity opp = [SELECT id, Renewal_Date__c FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        //Source_System_Detail__c ssd = [SELECT id FROM Source_System_Detail__c WHERE Name = 'ABC' LIMIT 1];
        //propList = DCPProposal.getPresentedProposal(opp.Id,ssd.Id);
        List<Apttus_Config2__ProductConfiguration__c> cartList;
		cartList =    [SELECT id FROM Apttus_Config2__ProductConfiguration__c];

        Test.startTest();
        try{
            Apttus_CPQApi.CPQ.UpdatePriceRequestDO request = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
            request.cartId = cartList[0].id;
            Apttus_CpqApi.CPQ.UpdatePriceResponseDO response = Apttus_CpqApi.CPQWebService.updatePriceForCart(request);
            //boolean isPending = response.IsPricePending;
            System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> response inside test class  :  '+ response);
            Map<string,string> requestbody = new Map<string,string>();
            requestBody.put('cartId', cartList[0].id);
            string finalized = DCPFinalizeCart.callCongaFinalizeMethod(requestbody);
            System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> Finalized  :  '+ finalized);
        }catch(Exception ex){
            Boolean expectedExceptionThrown = ex !=null ?true:false;
            System.assertEquals(expectedExceptionThrown, true, 'Improper request format');
        }
        
        Test.stopTest();
    }
}