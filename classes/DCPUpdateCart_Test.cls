@isTest
public class DCPUpdateCart_Test
{
        @isTest
        public static void updateCartTest(){
            
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
        cart.Apttus_Config2__Status__c = 'Finalized';
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BusinessObjectId__c = 'Proposal';
        cart.APTS_SSD_bill_to__c = ssd.id;
        cart.APTS_SSD_Ship_To__c = ssd.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.Id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.Id;
        cart.Apttus_Config2__AccountId__c = acc.Id;
        cart.Apttus_Config2__PriceListId__c = pricelist.id;
        insert cart;
        Product2 prod = (Product2)objectToDataMap.get('Product2');
        //prod.APTS_Product_Pricing_Model__c = 'Banded';
        prod.APTS_Product_Pricing_Model__c ='Per Seat';
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
        insert lineItem;
    
 
        List<Apttus_Config2__ProductConfiguration__c> testCart =    [SELECT id,Name,Apttus_Config2__Status__c,Apttus_QPConfig__Proposald__c,
                                                                        (SELECT id,Name
                                                                        FROM Apttus_Config2__LineItems__r)
                                                                        FROM Apttus_Config2__ProductConfiguration__c];
        
        list<DCPUpdateCartRequest.PerSeatProductDetails>dpList= new list<DCPUpdateCartRequest.PerSeatProductDetails>();
        List<Apttus_Config2__LineItem__c> lineItems = new List<Apttus_Config2__LineItem__c>();
   
             lineItems = DCPCart.getCartLineItems(testCart[0].id);
             for(Apttus_Config2__LineItem__c line : lineItems) {
             
             
         DCPUpdateCartRequest.PerSeatProductDetails dp=new DCPUpdateCartRequest.PerSeatProductDetails();
                dp.lineItemId=line.Name;
                dp.perSeatQuantity=1;
                dpList.add(dp);

          DCPUpdateCartRequest dcpreq= new DCPUpdateCartRequest(); 
                dcpreq.cartId=testCart[0].Id;
                dcpreq.bandedQuantity=1;
                dcpreq.contractTerm='3 Years';
                dcpreq.perSeatProducts=dpList;
             
        Test.startTest();
              String cartupdate= DCPUpdateCart.updateCart(dcpreq); 
        Test.stopTest();
             
              system.assertEquals('cartUpdated', cartupdate,'CartNotUpdatedSuccessfully');
         }
     

}
}