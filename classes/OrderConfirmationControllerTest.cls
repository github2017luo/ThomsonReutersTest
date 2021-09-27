/**
 * This test class is used to test the OrderConfirmationController class.  That class builds order information for the Order 
 * Confirmation email
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-02-21   Brenda Shields          DLT-19568 - Cleanup PMD Errors
 * =============================================================================
 */
@istest (seealldata=false)
public class OrderConfirmationControllerTest {
    /**
 	 * @description get order for Order Confirmation Processing
 	 */
    public static Apttus_Config2__Order__c order {get;set;}
    
    /** 
 	 * @description setup test data
 	 */
    public static void setupData(){
        Account acc = new Account();
        acc.Name='test';
        acc.Customer_Group__c='FEDERAL GOVERNMENT';
        acc.CurrencyIsoCode='USD';
        acc.Sales_Org__c='WEST';
        Insert acc;

        Contact oContact = UnitTest.getContactInstance(acc.Id);
        oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
        insert oContact;
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        insert oProductB;
        insert oProductP;

            
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
        insert oProposal;

        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
            
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems;
        
        order = new Apttus_Config2__Order__c();
        order.Apttus_Config2__Type__c='New';
        order.Apttus_Config2__Status__c='Ready for Activation';
        order.Apttus_Config2__SoldToAccountId__c=acc.id;
        order.Apttus_Config2__BillToAccountId__c=acc.id;
        order.Apttus_Config2__ShipToAccountId__c=acc.id;
        order.Apttus_QPConfig__ProposalId__c=oProposal.id;
        insert order;
        
        Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
        cart.Apttus_QPConfig__Proposald__c = oProposal.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.id;
        cart.Apttus_Config2__AccountId__c = acc.id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.id;
        cart.Digital_Pending_Cart__c = TRUE;
        cart.Apttus_Config2__Status__c = 'Finalized';
        insert cart;
        
        Apttus_Config2__LineItem__c line = new Apttus_Config2__LineItem__c();
        line.Apttus_Config2__ConfigurationId__c = cart.id;
        line.Apttus_Config2__LineNumber__c = 1;
        line.Apttus_Config2__ItemSequence__c = 1;
        line.Apttus_Config2__LineType__c = 'Product/Service';
        line.Apttus_Config2__BillToAccountId__c = acc.id;
        line.Apttus_Config2__ShipToAccountId__c = acc.id;
        insert line;
        
        Apttus_Config2__OrderLineItem__c ordLine =  new Apttus_Config2__OrderLineItem__c();
        ordLine.APTS_Contract_Term__c='1 Year';
        ordLine.Apttus_Config2__OrderId__c=order.id;
        ordLine.Apttus_Config2__Quantity__c=1.000;
        ordLine.Apttus_Config2__ProductId__c=oProductB.id;
        ordLine.APTS_Group__c='Bundle A';  
        ordLine.APTS_Bridge__c='1 Month';
        insert ordLine;


        Apttus_Config2__OrderLineItem__c ordLine22 =  new Apttus_Config2__OrderLineItem__c();
        ordLine22.Apttus_Config2__OrderId__c=order.id;
        ordLine22.Apttus_Config2__Quantity__c=1.000; 
        ordLine22.Apttus_Config2__LineStatus__c='Cancelled'; 
        insert ordLine22;  

        Apttus_Config2__OrderLineItem__c ordLine23 =  new Apttus_Config2__OrderLineItem__c();
        ordLine23.Apttus_Config2__OrderId__c=order.id;
        ordLine23.Apttus_Config2__Quantity__c=1.000; 
        ordLine23.Apttus_Config2__LineStatus__c='Cancelled'; 
        insert ordLine23;

        Apttus_Config2__OrderLineItem__c ordLine1 =  new Apttus_Config2__OrderLineItem__c();
        ordLine1.Apttus_Config2__Uom__c='Each';
        ordLine1.APTS_New_Bridge_Discount__c=1;
        ordLine1.APTS_Contract_Term__c='2 Years';  
        ordLine1.Apttus_Config2__Quantity__c=1.000;
        ordLine1.Apttus_Config2__ProductId__c=oProductP.id;
        ordLine1.Apttus_Config2__OrderId__c=order.id;
        insert ordLine1;  

    }
    
    /**
 	 * @description Test method for Order Confirmation processing
 	 */
    public static testMethod void testOrderDetails() {
    	// Start Test for Order Confirmation 
        Test.startTest();
        setupData();
        
        OrderConfirmationController orderConfCntl = new OrderConfirmationController();
        OrderConfCntl.orderId = order.id;
        orderConfCntl.splcharStr = '•';
        List<Apttus_Config2__LineItem__c> orderLineItemList = OrderConfCntl.getOrderLineItemList();
        Test.stopTest();
        
        system.assertNotEquals(orderLineItemList, null, 'Order List Successfully Created.');
    }
}