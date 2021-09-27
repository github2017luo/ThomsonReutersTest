/*
    Class : APTS_AccInstalledProductsController
*/
public without Sharing class APTS_AccInstalledProductsController {
    
    public List<Apttus_Config2__AssetLineItem__c> shipToAssetLines { get;private set; }
    public ApexPages.StandardController stdController;
    private Account acc; 
    public Boolean hasActiveAssets { get;private set; }
    //constructor
    public APTS_AccInstalledProductsController(ApexPages.StandardController controller) {
        hasActiveAssets = false;
        this.stdController = controller;
        acc = (Account)controller.getRecord();
        if(acc == null){
             return;
        }
        //Replaced  Apttus_Config2__ShipToAccountId__c field with Apttus_Config2__AccountId__c in query filter condition as part of CRM-14603
           //SOC-9796 PMD Fix
        if(Apttus_Config2__AssetLineItem__c.sObjectType.getDescribe().isAccessible()){
            shipToAssetLines = [Select Id, Name,Apttus_Config2__AccountId__c,Apttus_Config2__ShipToAccountId__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name , Apttus_Config2__AssetCode__c, 
            Apttus_Config2__ChargeType__c, Apttus_Config2__Quantity__c, Apttus_Config2__NetPrice__c,Apttus_Config2__AssetStatus__c,
            APTS_Material_Number__c, Apttus_Config2__BundleAssetId__c, Apttus_Config2__HasOptions__c,
            APTS_Info_PlanType__c, APTS_Info_RenewalDate__c, Apttus_Config2__ProductId__r.Media_Lower_Level__c   
            from Apttus_Config2__AssetLineItem__c
           // where Apttus_Config2__ShipToAccountId__c = :acc.Id
            where Apttus_Config2__AccountId__c = :acc.Id
            AND Apttus_Config2__IsInactive__c = False AND Apttus_Config2__AssetStatus__c != 'Cancelled'];
        }  
       //example[x].round(System.RoundingMode.FLOOR)
       for (integer j=0; j < shipToAssetLines.size(); j++)
       {
          if (shipToAssetLines.get(j).Apttus_Config2__Quantity__c != null){
              shipToAssetLines.get(j).Apttus_Config2__Quantity__c = shipToAssetLines.get(j).Apttus_Config2__Quantity__c.round(System.RoundingMode.FLOOR);
          }
          if (shipToAssetLines.get(j).Apttus_Config2__SellingTerm__c != null){
              shipToAssetLines.get(j).Apttus_Config2__SellingTerm__c = shipToAssetLines.get(j).Apttus_Config2__SellingTerm__c.round(System.RoundingMode.FLOOR);
          }
       }
        
        if(shipToAssetLines != null && !shipToAssetLines.isEmpty()) {
            hasActiveAssets = true;
        }
    }
}