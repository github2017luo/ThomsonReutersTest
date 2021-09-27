public without sharing class APTS_ProductConfigApprovalExtension {
    private Apttus_CQApprov.CartApprovalEmailController controller;
    

  public String getOrgUrl()
    {
        return System.URL.getSalesforceBaseUrl().toExternalForm();
    }
    
    public APTS_ProductConfigApprovalExtension(Apttus_CQApprov.CartApprovalEmailController aec)
    {
        controller = aec;        
    }

    public List<Apttus_Config2__LineItem__c> getLineItems(){
        Id cartId = controller.getRequestSO().Apttus_CQApprov__CartId__c;

        List<Apttus_Config2__LineItem__c> lineItems = [SELECT 
                Id, Name, Apttus_Config2__LineNumber__c, Apttus_Config2__LineType__c,APTS_Group_Primary_Material__c, APTS_Group_Primary_Material_Name__c, APTS_Contract_Term__c, Apttus_Config2__Quantity__c,   
                Apttus_Config2__PriceUom__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__BasePrice__c, Apttus_Config2__NetPrice__c, Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c,
                Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__OptionId__r.ProductCode,Apttus_Config2__OptionId__r.Name, Apttus_Config2__ProductId__r.Description, Apttus_Config2__LineStatus__c,  Apttus_Config2__ProductId__r.Name, APTS_Yr_1_Renewal_Adjustment__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ExtendedPrice__c,Apttus_Config2__IncentiveCode__c 
            FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :cartId order by Name,Apttus_Config2__LineNumber__c];
        
        return lineItems;
    }
}