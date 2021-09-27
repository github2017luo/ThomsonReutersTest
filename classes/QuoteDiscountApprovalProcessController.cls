public class QuoteDiscountApprovalProcessController{
    public Id thisQuoteId {get; set; }
    
    public List <QuoteLineItem> thisQLIs = new List <QuoteLineItem>();
    
    public List <QuoteLineItem> getThisQLIs(){
    
        thisQLIs = [SELECT Id , PriceBookEntry.Product2.Name, PriceBookEntry.Product2.ProductCode, Discount, Quantity, 
        UnitPrice, TotalPrice, Number_of_Contacts__c, Item_Activity_Type__c, Projected_Renewal_Price__c, Cancel_Reason__c,
        Projected_Price_Increase__c, Actual_Price_Increase__c, Price_Increase_Discount_variance__c FROM QuoteLineItem WHERE Quote.Id= :thisQuoteId 
                 ];
        return thisQLIs;               
    }

}