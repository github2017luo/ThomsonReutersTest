/********************************************************************************************
    ClassName: RenewalTemplateShipBillAddressPopulation
    Description: Class is being used by VF Component : TRRenewalTemplateBillShipAddressSPA  and TRRenewalTemplateBillShipAddressPOR.
                 This class is used to fetch Shiping and biling account's address of a quote.
    DevelopedBy: TCS Offshore
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
public  class RenewalTemplateShipBillAddressPopulation
{
    public Id accountId {get;set;}
    public Account getaddressMapping()
    {
        Account acc = [select Id,BillingStreet,BillingCity,BillingPostalCode,BillingCountry,BillingState from Account where Id = :accountId]; 
            return acc;
    
    }
}