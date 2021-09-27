@isTest(seeallData=true)

public class OpportunityPricingCreateController_Test{

  public testmethod static void testOptyPricingCreate(){
    Account otestAccount = UnitTest.getAccountInstance();
    Insert otestAccount;
    
    Opportunity oOpp = UnitTest.getOpportunityInstance(otestAccount.Id);
    insert oOpp;
    
    Opportunity_Product_Type__c oOptyPricing = new Opportunity_Product_Type__c(Opportunity__c=oOpp.Id,Product_Category__c = 'Australia');
    insert oOptyPricing;
    Test.StartTest();
    ApexPages.standardController sc = new ApexPages.standardController(oOptyPricing);
    OpportunityPricingCreateController oOptyPriceController = new OpportunityPricingCreateController(sc);
    oOptyPriceController.OpportunityId = oOpp.Id;
    oOptyPriceController.listOpportunityPricing.add((new Opportunity_Product_Type__c(Product_Category__c ='Australia')));
    oOptyPriceController.listOpportunityPricing.add((new Opportunity_Product_Type__c(Incremental_Amount__c=1.00)));
    oOptyPriceController.listOpportunityPricing.add((new Opportunity_Product_Type__c(Renewal_Amount__c=1.00)));

   
    oOptyPriceController.Save();
    oOptyPriceController.SaveAndNew();
    oOptyPriceController.Cancel();
    oOptyPriceController.AddMore();
    Test.StopTest();
    
  
  }

}