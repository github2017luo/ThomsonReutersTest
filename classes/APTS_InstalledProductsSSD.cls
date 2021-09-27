/*
    Class : APTS_InstalledProductsSSD
*/
public class APTS_InstalledProductsSSD {
    
    public List<Apttus_Config2__AssetLineItem__c> shipToAssetLines { get;private set; }
    public ApexPages.StandardController stdController;
    private Source_System_Detail__c ssd; 
    public Boolean hasActiveAssets { get;private set; }
    //constructor
    public APTS_InstalledProductsSSD(ApexPages.StandardController controller) {

        hasActiveAssets = false;
        this.stdController = controller;
        ssd = (Source_System_Detail__c)controller.getRecord();
        System.debug('DEV DEBUG: ssd: ' + ssd);
        
        if(ssd == null) return;
        
        Source_System_Detail__c ssdAcc = [SELECT Id, Name, Account_Name__c 
                                          FROM Source_System_Detail__c 
                                          WHERE Id = :ssd.Id];
        
        System.debug('DEV DEBUG: ssdAcc: ' + ssdAcc);
        //Replaced  APTS_SSD_Ship_to__c field with APTS_SSD_Sold_To__c in query filter condition as part of CRM-14603
        shipToAssetLines = [SELECT Id, Name, APTS_SSD_Sold_To__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.Name , Apttus_Config2__AssetCode__c, 
                                    Apttus_Config2__ChargeType__c, Apttus_Config2__Quantity__c, Apttus_Config2__NetPrice__c,Apttus_Config2__AssetStatus__c, APTS_SAP_MLA_Agreement_Number__c, 
                                    APTS_Material_Number__c, Apttus_Config2__BundleAssetId__c, Apttus_Config2__HasOptions__c, Apttus_Config2__SellingTerm__c,
                                    APTS_Info_PlanType__c, APTS_Info_RenewalDate__c,Apttus_Config2__ProductId__r.Media_Lower_Level__c   
                            FROM Apttus_Config2__AssetLineItem__c
                            //WHERE APTS_SSD_Ship_to__c = :ssd.Id 
                            WHERE APTS_SSD_Sold_To__c = :ssd.Id
                            AND Apttus_Config2__IsInactive__c = False AND Apttus_Config2__AssetStatus__c != 'Cancelled'];
            
            System.debug('DEV DEBUG: shipToAssetLines: ' + shipToAssetLines.size() +'--'+ shipToAssetLines);
            
       //example[x].round(System.RoundingMode.FLOOR)
       for (integer j=0; j < shipToAssetLines.size(); j++) {
          if (shipToAssetLines.get(j).Apttus_Config2__Quantity__c != null)
              shipToAssetLines.get(j).Apttus_Config2__Quantity__c = shipToAssetLines.get(j).Apttus_Config2__Quantity__c.round(System.RoundingMode.FLOOR);

          if (shipToAssetLines.get(j).Apttus_Config2__SellingTerm__c != null)
              shipToAssetLines.get(j).Apttus_Config2__SellingTerm__c = shipToAssetLines.get(j).Apttus_Config2__SellingTerm__c.round(System.RoundingMode.FLOOR);
       }
        
        if(shipToAssetLines != null && !shipToAssetLines.isEmpty()) {
            hasActiveAssets = true;
        }
    }
}