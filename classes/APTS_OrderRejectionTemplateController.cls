public  class APTS_OrderRejectionTemplateController
{
    public Id quoteId{get;set;}
    public List<Apttus_Proposal__Proposal_Line_Item__c> getLineItems()
    {
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems;
        lineItems= [SELECT Apttus_Proposal__Product__r.name,APTS_Combination_Key__r.Name, APTS_Combination_Key__r.APTS_Inventory_Available__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =: quoteId AND APTS_Combination_Key__c!=null AND Apttus_QPConfig__LineStatus__c='New' AND (APTS_Combination_Key__r.APTS_Inventory_Available__c=0 OR APTS_Combination_Key__r.APTS_Inventory_Available__c=null) AND APTS_Combination_Key__r.APTS_Product__r.APTS_Inventory_Applicable__c=true];
        return lineItems;
    }
}