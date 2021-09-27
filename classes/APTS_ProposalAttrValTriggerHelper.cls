public class APTS_ProposalAttrValTriggerHelper {
    
    public static void updateCPROValuesOnProposal(List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstProposalAttributes){
        Map<String,APTS_CPRO_Material_Numbers__c> mapCPRORecords = APTS_CPRO_Material_Numbers__c.getAll();              
        Decimal lowpoint, highpoint; 
        String PLINAMEGC = 'Primary'; 
        String PLINAMEGC_Ess = 'Essential';
        String COREVAL = '';
        String COREVAL_ESS = 'Essentials';
        String COREVAL_PRI = 'Primary';
        Set<Id> setProduct2Ids = new Set<Id>();
        Set<Id> setPLIIds = new Set<Id>();
        Map<Id,String> mapProductIdToProductName = new Map<Id,String>();
        Map<Id,Id> mapPLIIdToProduct2Id = new Map<Id,Id>();
        Map<Id,Id> mapProposalAttrIdToPLIId = new Map<Id,Id>();
        Map<Id,Decimal> mapPLIdToTotalPoints = new Map<Id,Decimal>();
        List<Product2> lstProducts = new List<Product2>();
        List<Apttus_Proposal__Proposal_Line_Item__c> lstNewProposalLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        List<Apttus_Proposal__Proposal_Line_Item__c> lstNewProposalLineItemsForUpdate = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        for(Apttus_QPConfig__ProposalProductAttributeValue__c propattr : lstProposalAttributes){
            setPLIIds.add(propattr.Apttus_QPConfig__LineItemId__c);
            mapProposalAttrIdToPLIId.put(propattr.Id, propattr.Apttus_QPConfig__LineItemId__c);
            mapPLIdToTotalPoints.put(propattr.Apttus_QPConfig__LineItemId__c, propattr.APTS_Total_Number_of_Points__c);
        }
        if(!setPLIIds.isEmpty()){
            //SOC-4836 Added By Chirag
            lstNewProposalLineItems = [Select Id, Name, Apttus_Proposal__Product__c, APTS_Corporate_Select__c, 
                                        Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c, Apttus_QPConfig__LineStatus__c, APTS_Product_Name_Override__c 
                                        from Apttus_Proposal__Proposal_Line_Item__c 
                                        where Id In :setPLIIds ];
        }    
        
        // Prasad : 16-Dec-2016 - Commented For Change in Reference Field : Corporate Select - Starts
        /*if(!lstNewProposalLineItems.isEmpty()){
            for(Apttus_Proposal__Proposal_Line_Item__c pli : lstNewProposalLineItems){
                mapPLIIdToProduct2Id.put(pli.Id,pli.Apttus_Proposal__Product__c);
            }
        }
        //System.debug('***+++*** : ' + mapCPRORecords);
        if(!mapPLIIdToProduct2Id.isEmpty()){
            lstProducts = [Select Id, Name, APTS_Corporate_Select__c  from Product2 where Id In : mapPLIIdToProduct2Id.values()];
        }
        
        if(!lstProducts.isEmpty()){
            for(Product2 prod : lstProducts){
                //mapProductIdToProductName.put(prod.Id,prod.Name);                
                mapProductIdToProductName.put(prod.Id,prod.APTS_Corporate_Select__c);                
            }           
        }*/        
        //Prasad : 16-Dec-2016 - Commented For Change in Reference Field : Corporate Select - Ends 
        
        //SOC-4836 Added by Chirag
        map<String, APTS_CPRO_Material_Numbers__c> CPROmap =  new map<string, APTS_CPRO_Material_Numbers__c>();
        for(APTS_CPRO_Material_Numbers__c rec : APTS_CPRO_Material_Numbers__c.getAll().values()){
            CPROmap.put(rec.APTS_sub__c, rec);
        }
        system.debug('CPROmap++' + CPROmap);
        
        if( mapCPRORecords != null && !mapCPRORecords.isEmpty() && !mapPLIdToTotalPoints.isEmpty()){
            for(Apttus_Proposal__Proposal_Line_Item__c pli : lstNewProposalLineItems ){
                // Prasad : Westlaw GC Products
                if(!String.isBlank(pli.APTS_Corporate_Select__c ) 
                    && (pli.APTS_Corporate_Select__c).containsIgnoreCase(PLINAMEGC)
                    && !(pli.APTS_Corporate_Select__c).containsIgnoreCase(PLINAMEGC_Ess)){
                    for(String cpro : mapCPRORecords.keySet()){
                        COREVAL = mapCPRORecords.get(cpro).Core__c; 
                        if((COREVAL).equalsIgnoreCase(COREVAL_PRI)){
                            lowpoint =  mapCPRORecords.get(cpro).APTS_Low_Points__c;
                            highpoint = mapCPRORecords.get(cpro).APTS_High_Points__c;                                       
                            if(mapPLIdToTotalPoints.get(pli.Id) != null){
                                if(mapPLIdToTotalPoints.get(pli.Id) >= lowpoint 
                                    && mapPLIdToTotalPoints.get(pli.Id) <= highpoint){
                                        /*System.debug('***+++*** Range : ' + lowpoint + ' : ' + highpoint);
                                        System.debug('***+++*** Product Name : ' + pli.Name);
                                        System.debug('***+++*** Product Total Points : ' + pli.APTS_Total_Number_of_Points__c );*/
                                        pli.APTS_Product_Name_Override__c = mapCPRORecords.get(cpro).Name; 
                                        pli.APTS_Service_Number_Override__c = mapCPRORecords.get(cpro).APTS_Svc__c;
                                        //SOC-4836 Added by Chirag
                                        if(pli.Apttus_QPConfig__LineStatus__c != 'Renewed'){
                                            pli.APTS_Subscription_Number_Override__c = mapCPRORecords.get(cpro).APTS_Sub__c;
                                            pli.APTS_Subscription_Number__c = mapCPRORecords.get(cpro).APTS_Sub__c;  //SOC-4098 Added by Chirag 6/13/17
                                        }else{
                                            pli.APTS_Subscription_Number__c = pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c;
                                            pli.APTS_Subscription_Number_Override__c = pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c;
                                            pli.APTS_Product_Name_Override__c = CPROmap.get(pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c).Name;
                                            pli.APTS_Service_Number_Override__c = CPROmap.get(pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c).APTS_Svc__c; 
                                        }
                                        lstNewProposalLineItemsForUpdate.add(pli);
                                }
                            }
                        }    
                    }
                }
                // Prasad : Westlaw GC Essential Products
                if(!String.isBlank(pli.APTS_Corporate_Select__c )
                    && (pli.APTS_Corporate_Select__c).containsIgnoreCase(PLINAMEGC)
                    && (pli.APTS_Corporate_Select__c).containsIgnoreCase(PLINAMEGC_Ess)){
                    for(String cpro : mapCPRORecords.keySet()){
                        COREVAL = mapCPRORecords.get(cpro).Core__c; 
                        if((COREVAL).equalsIgnoreCase(COREVAL_ESS)){                        
                            lowpoint =  mapCPRORecords.get(cpro).APTS_Low_Points__c;
                            highpoint = mapCPRORecords.get(cpro).APTS_High_Points__c;               
                            if(mapPLIdToTotalPoints.get(pli.Id) != null){
                                if(mapPLIdToTotalPoints.get(pli.Id) >= lowpoint 
                                    && mapPLIdToTotalPoints.get(pli.Id) <= highpoint){
                                        /*System.debug('***+++*** Range : ' + lowpoint + ' : ' + highpoint);
                                        System.debug('***+++*** Product Name : ' + pli.Name);
                                        System.debug('***+++*** Product Total Points : ' + pli.APTS_Total_Number_of_Points__c );*/
                                        pli.APTS_Product_Name_Override__c = mapCPRORecords.get(cpro).Name; 
                                        pli.APTS_Service_Number_Override__c = mapCPRORecords.get(cpro).APTS_Svc__c;
                                        //SOC-4836 Added by Chirag
                                        if(pli.Apttus_QPConfig__LineStatus__c != 'Renewed'){
                                            pli.APTS_Subscription_Number_Override__c = mapCPRORecords.get(cpro).APTS_Sub__c;
                                            pli.APTS_Subscription_Number__c = mapCPRORecords.get(cpro).APTS_Sub__c;  //SOC-4098 Added by Chirag 6/13/17
                                        }else{
                                            pli.APTS_Subscription_Number__c = pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c;
                                            pli.APTS_Subscription_Number_Override__c = pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c;
                                            pli.APTS_Product_Name_Override__c = CPROmap.get(pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c).Name;
                                            pli.APTS_Service_Number_Override__c = CPROmap.get(pli.Apttus_QPConfig__AssetLineItemId__r.APTS_Subscription_Number__c).APTS_Svc__c; 
                                        }
                                        lstNewProposalLineItemsForUpdate.add(pli);
                                }
                            }
                        }
                    }
                }                          
            }
            if(!lstNewProposalLineItemsForUpdate.isEmpty()){
                update lstNewProposalLineItemsForUpdate;
            }
        }
    }
}