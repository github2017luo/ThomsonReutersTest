public  class RenewalTemplateAddressPopulation
{
    public Id opportunityId {get;set;}
    public Decimal price {get;set;}
    public SalesOrgMapping__c getaddressMapping()
    {
        String org = [select Id,Sales_Org__c from Opportunity where Id = :opportunityId].Sales_Org__c; 
        SalesOrgMapping__c addrMapping = SalesOrgMapping__c.getInstance(org);
        return addrMapping;
    }
}