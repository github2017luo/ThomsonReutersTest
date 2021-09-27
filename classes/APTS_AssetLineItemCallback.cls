global class APTS_AssetLineItemCallback implements Apttus_Config2.CustomClass.IAssetLineItemCallback3 {
    
    public list<String> assetSearchScope;
    public String assetSearchFilter;
    public Boolean isFindLawProduct;
    public string soldToSsd;
    
    global void start(Apttus_Config2.ProductConfiguration cart, String assetSearchFilter, list<String> assetSearchScope){
        
        this.assetSearchScope = assetSearchScope;
        this.assetSearchFilter = assetSearchFilter;
        
        if(cart != NULL){
            isFindLawProduct = false;
            Apttus_Config2__ProductConfiguration__c cartSO = cart.getConfigSO();
            system.debug('test sold to in installed products'+cartSO.APTS_SSD_Sold_To__c);
            soldToSsd=cartSO.APTS_SSD_Sold_To__c;
            if(cartSO.APTS_Proposal_Business_Unit__c == 'FindLaw' ) isFindLawProduct = true;
        }
    }
    
    global list<String> getAssetSearchScope(){
        return null;
    }
    
    global String getFilterExpr(Apttus_Config2.CustomClass.ActionParams params){
        String whereClause = null;
        String PriceType = 'One Time';
        String ChargeType = 'Subscription Fee';
        String ChargeTypeSP = 'Standard Price';
        String AssetStatus = 'Cancelled';
        Double ContractNumber  = null;
        //List<String> AssetStatusValues = new List<String>{'New','Pending Activation','Pending Re-activation','Activated','Pending Renewal','Renewed','Pending Cancellation','Pending Change','Pending Suspension','Incremented','Amdended','Superseded'};
        List<String> AssetStatusValues = new List<String>{'\'New\'','\'Pending Activation\'','\'Pending Re-activation\'','\'Activated\'','\'Pending Renewal\'','\'Renewed\'','\'Pending Cancellation\'','\'Pending Change\'','\'Pending Suspension\'','\'Incremented\'','\'Amdended\'','\'Superseded\''};
        system.debug('params ::'+params+' soldToSsd : :'+soldToSsd);
        //Chnaged Apttus_Config2__AccountId__c field to New Field APTS_SSD_Sold_To__c 
        //whereClause = 'APTS_SSD_Sold_To__c = ' + '\''+ params.AccountId + '\'';
        whereClause = 'APTS_SSD_Sold_To__c = ' + '\''+ soldToSsd + '\'';
        whereClause = whereClause + ' AND ';
        whereClause = whereClause + 'Apttus_Config2__IsInactive__c = false';
        whereClause = whereClause + ' AND ';
        whereClause = whereClause + '(Apttus_Config2__ChargeType__c =' + '\''+ ChargeType+ '\'';
        whereClause = whereClause + ' OR ';
        whereClause = whereClause + '(Apttus_Config2__ChargeType__c =' + '\''+ ChargeTypeSP + '\'';
        whereClause = whereClause + ' AND ';
        whereClause = whereClause + 'APTS_Contract_Number__c !=' + ContractNumber +')';
        whereClause = whereClause + ')';
        whereClause = whereClause + ' AND ';        
        whereClause = whereClause + 'Apttus_Config2__AssetStatus__c IN ('+string.join(AssetStatusValues,',')+')';
      /*  //whereClause = whereClause + ' AND ';
        //whereClause = whereClause + 'Apttus_Config2__AssetStatus__c != ' + '\''+ AssetStatus + '\'';
        if(isFindLawProduct == true ){
            whereClause = whereClause + ' AND ';
            whereClause = whereClause + 'Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c IN ' + System.Label.APTS_Product_Brand_Codes ;
            whereClause = whereClause + ' AND ';
            whereClause = whereClause + 'Apttus_Config2__EndDate__c =  NEXT_90_DAYS';
            whereClause = whereClause + ' AND ';
            whereClause = whereClause + 'Apttus_Config2__PriceType__c =' + '\''+ PriceType + '\'';
        } */
        System.debug(whereClause);
        return whereClause;    
    } 
    
     global String getQueryFilter(Id AccountID){
         //return null;
         return 'name != \'\'';
         
        /* String whereClause = null;
        String PriceType = 'Recurring';
        String AssetStatus = 'Cancelled';
        //List<String> AssetStatusValues = new List<String>{'New','Pending Activation','Pending Re-activation','Activated','Pending Renewal','Renewed','Pending Cancellation','Pending Change','Pending Suspension','Incremented','Amdended','Superseded'};
        List<String> AssetStatusValues = new List<String>{'\'New\'','\'Pending Activation\'','\'Pending Re-activation\'','\'Activated\'','\'Pending Renewal\'','\'Renewed\'','\'Pending Cancellation\'','\'Pending Change\'','\'Pending Suspension\'','\'Incremented\'','\'Amdended\'','\'Superseded\''};
        //system.debug('params ::'+params+' soldToSsd : :'+soldToSsd);
        //Chnaged Apttus_Config2__AccountId__c field to New Field APTS_SSD_Sold_To__c 
        //whereClause = 'APTS_SSD_Sold_To__c = ' + '\''+ params.AccountId + '\'';
        whereClause = 'APTS_SSD_Sold_To__c = ' + '\''+ soldToSsd + '\'';
        whereClause = whereClause + ' AND ';
        whereClause = whereClause + 'Apttus_Config2__IsInactive__c = false';
        whereClause = whereClause + ' AND ';
        whereClause = whereClause + 'Apttus_Config2__AssetStatus__c IN ('+string.join(AssetStatusValues,',')+')';*/
      /*  //whereClause = whereClause + ' AND ';
        //whereClause = whereClause + 'Apttus_Config2__AssetStatus__c != ' + '\''+ AssetStatus + '\'';
        if(isFindLawProduct == true ){
            whereClause = whereClause + ' AND ';
            whereClause = whereClause + 'Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c IN ' + System.Label.APTS_Product_Brand_Codes ;
            whereClause = whereClause + ' AND ';
            whereClause = whereClause + 'Apttus_Config2__EndDate__c =  NEXT_90_DAYS';
            whereClause = whereClause + ' AND ';
            whereClause = whereClause + 'Apttus_Config2__PriceType__c =' + '\''+ PriceType + '\'';
        } */
        //System.debug(whereClause);
        //return whereClause;
     }
    
    global void finish(){
        
    }
    
    global Boolean validateAssetTermination(Set<ID> assetIds, Set<ID> accountIds, Date effectiveDate) 
    {
        return true;
    }
   
}