public with sharing class APTS_LineItemTriggerHandler {
    
    public static boolean beforeUpdate = false;
    public static boolean beforeInsert = false;
    public static boolean beforeDelete = false;
    public static boolean afterUpdate = false;
    public static boolean afterInsert = false;
    public static boolean afterDelete = false;
    
    //Nov Release
    public static Set<String> promoCodesSet = new Set<String>{'683239I69907', '683239H88754', '683239C93872', '683239I79441', '683239J56642', '683239J59302', 
                                                '683239J59303', '683239J59304', '683239J59305', '683239J59306', '683239J59307', '683239J59308', '683239J59309', 
                                                '683239J59310', '683239J59311', '683239J59312', '683239J59313', '683239J59314', '683239J59315', '683239J59316', 
                                                '683239J59317', '683239J59318', '683239J59319', '683239J59320', '683239J59321'};
    public APTS_LineItemTriggerHandler() {
    }
    public void onBeforeInsert(List<Apttus_Config2__LineItem__c > lineItems){
    if(checkRecursive.runBeforeInsertOnce()){
        List<Apttus_Config2__LineItem__c > findLawLineItems=new List<Apttus_Config2__LineItem__c >();
        //List<Apttus_Config2__LineItem__c> corporateLineItems=new List<Apttus_Config2__LineItem__c>();//DOC-3563 changes
        List<Apttus_Config2__LineItem__c> SCSandCanadaLineItems=new List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__LineItem__c> corpandRiskLineItems=new List<Apttus_Config2__LineItem__c>();   //Added as part of Risk Sep Release
        for(Apttus_Config2__LineItem__c lineItem:lineItems){
            
            //Nov Release
            
            //descoped WF - Bridge values on lapsed lines
            if(promoCodesSet.contains(lineItem.Apttus_Config2__IncentiveCode__c)){
                lineItem.APTS_Exclude_Incremental_Growth_Approval__c = true;
            }//descoped WF - Check Incentive Code to exclude incremental growth
            if(lineItem.APTS_Proposal_Business_Unit__c=='FindLaw'){
               if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Combination_Key__c != null){
                   lineItem.Apttus_Config2__IsCustomPricing__c = true;
               }//descoped WF - APTS_FL_Directory_ISCustomPricing
               findLawLineItems.add(lineItem); 
           }
               
           //if(lineItem.APTS_Proposal_Business_Unit__c=='FindLaw')
            // findLawLineItems.add(lineItem);
            //DOC-3563 starts
           /*else if(lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC US'||lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK'){
             system.debug('proposalBusinessUnit'+lineItem.APTS_Proposal_Business_Unit__c);
             corporateLineItems.add(lineItem);
           } */  //Commented as part of Risk Sep Release
           //DOC-3563 ends  
             if(lineItem.APTS_Proposal_Business_Unit__c=='SCS'|| lineItem.APTS_Proposal_Business_Unit__c =='Canada'){
             SCSandCanadaLineItems.add(lineItem);
            }
            //Added as part of Risk Sep Release
            if(lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC US'||lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK' || 
                (lineItem.APTS_Proposal_Business_Unit__c != null && System.Label.Risk_PBUs.contains(lineitem.APTS_Proposal_Business_Unit__c))){
             system.debug('proposalBusinessUnit'+lineItem.APTS_Proposal_Business_Unit__c);
             corpandRiskLineItems.add(lineItem);
           } 
            /*
            //DOC-1557 starts
            System.debug('KS--> lineItem.APTS_Product_Family__c '+lineItem.APTS_Product_Family__c);
            System.debug('KS--> lineItem.APTS_Proposal_Business_Unit__c '+lineItem.APTS_Proposal_Business_Unit__c);
            if(lineItem.APTS_Product_Family__c != null 
                && (lineItem.APTS_Proposal_Business_Unit__c=='Corp OneOTC US' || lineItem.APTS_Proposal_Business_Unit__c=='Corp OneOTC UK')){
                if(lineItem.APTS_Product_Family__c == 'Corp - NRA/OTEA' && lineItem.APTS_Renewal_Type__c == null){
                    lineItem.APTS_Renewal_Type__c = 'Evergreen';
                }else if(lineItem.APTS_Product_Family__c != 'Corp - NRA/OTEA' && lineItem.APTS_Renewal_Type__c == null){
                    lineItem.APTS_Renewal_Type__c = 'Auto Renew';
                }
            }
            */
        }
        if (!beforeInsert){
           // beforeInsert = true;// Added by Ravi to avoid "too many SOQL 201 error".
           // if(!findLawLineItems.isEmpty())
           //   APTS_FL_LineItemTriggerHelper.populateCategory(findLawLineItems);
           
           if(!SCSandCanadaLineItems.isEmpty()){
             APTS_LineItemTriggerHelper.multiYearTieredPricingSCSandCanada(SCSandCanadaLineItems);
           }
                //DOC-3563 changes
            if(!corpandRiskLineItems.isEmpty()){
             system.debug('calling corp and risk line items for MultiTieredPricing');
             APTS_CORP_LineItemTriggerHelper.multiYearTieredPricing(corpandRiskLineItems);}  
        }
    }
    }

    public void onAfterInsert(Map<Id, Apttus_Config2__LineItem__c> mapOldObjects, Apttus_Config2__LineItem__c[] listNewObjects, Map<Id, Apttus_Config2__LineItem__c> mapNewObjects){
        
        if (!afterInsert){
       //if(checkRecursive.runAfterInsertOnce()){
            afterInsert = true; 
            APTS_LineItemTriggerHelper.calculateIncrementGrowth(listNewObjects[0].Apttus_Config2__ConfigurationId__c);
           // APTS_LineItemTriggerHelper.updateContactTerm(listNewObjects); //Added by Chirag
        }
    }
    
    public void onAfterUpdate(Map<Id, Apttus_Config2__LineItem__c> mapOldObjects, Apttus_Config2__LineItem__c[] listNewObjects, Map<Id, Apttus_Config2__LineItem__c> mapNewObjects){
        
        if (!afterUpdate){
    //if(checkRecursive.runAfterUpdateOnce()){
            afterUpdate = true;
            /*List<Apttus_Config2__LineItem__c> recs1 = new List<Apttus_Config2__LineItem__c>();
            for (Apttus_Config2__LineItem__c lineitem: listNewObjects) {
                Apttus_Config2__LineItem__c l = mapOldObjects.get(lineitem.id); 
                if (lineitem.APTS_Contract_Term_Whole_Years__c != l.APTS_Contract_Term_Whole_Years__c)
                    recs1.add(lineitem);
            }*/
            Id configId = listNewObjects[0].Apttus_Config2__ConfigurationId__c;
            APTS_LineItemTriggerHelper.calculateIncrementGrowth(configId);
            //if (recs1.size() > 0)
            //APTS_LineItemTriggerHelper.updateContactTerm(recs1);  //Added by Chirag
        }
    }
    
    public void onAfterDelete(Apttus_Config2__LineItem__c[] listOldObjects){
        
       // if (!afterDelete){
           // APTS_LineItemTriggerHelper.updateContactTerm(listOldObjects);  //Added by Chirag
       // }
    }
    
    public void onBeforeDelete(Apttus_Config2__LineItem__c[] listObjects){
        
        if (!beforeDelete){
            APTS_LineItemTriggerHelper.calculateIncrementGrowth(listObjects[0].Apttus_Config2__ConfigurationId__c);
        }
    }
    
    /*
     * Below code added by Bhupendra Jain on 27-Oct-16 for Before Update logic.
     * Requirement is to populate five Approval Required Checkboxes on basis of specific criteria.
     */
    public void onBeforeUpdate(Apttus_Config2__LineItem__c[] lineItems) {
    //if(checkRecursive.runonBeforeUpdateOnce()){
         List<Apttus_Config2__LineItem__c > findLawLineItems=new List<Apttus_Config2__LineItem__c >();
         List<Apttus_Config2__LineItem__c > otherLineItems=new List<Apttus_Config2__LineItem__c >();
         List<Apttus_Config2__LineItem__c> corporateLineItems=new List<Apttus_Config2__LineItem__c>();//DOC-3563 changes
         List<Apttus_Config2__LineItem__c> SCSandCanadaLineItems=new List<Apttus_Config2__LineItem__c>();
         //Added as part of Risk Sep Release
         List<Apttus_Config2__LineItem__c> corpandRiskLineItems=new List<Apttus_Config2__LineItem__c>();
         Set<Id> findLawcartIdSet=new Set<id>();
        for(Apttus_Config2__LineItem__c lineItem:lineItems){
        
            //Nov Release
             findLawcartIdSet.add(lineItem.Apttus_Config2__ConfigurationId__c); //Added as part of descope
             if(promoCodesSet.contains(lineItem.Apttus_Config2__IncentiveCode__c)){
                lineItem.APTS_Exclude_Incremental_Growth_Approval__c = true;
            }//descoped WF - Check Incentive Code to exclude incremental growth
            if(lineItem.Apttus_Config2__LineStatus__c!='New'){
                lineItem.APTS_New_Bridge_Discount__c = null;
                lineItem.APTS_Bridge__c = null;
                lineItem.APTS_Bridge_Discount__c = null;
            }//descoped WF - Bridge values on lapsed lines
            if(lineItem.APTS_Proposal_Business_Unit__c=='FindLaw'){
                if(lineItem.Apttus_Config2__LineStatus__c == 'Renewed' && lineItem.APTS_Combination_Key__c != null){
                    lineItem.Apttus_Config2__IsCustomPricing__c = true;
                }//descoped WF - APTS_FL_Directory_ISCustomPricing
                findLawLineItems.add(lineItem);
            }
            
        
            //if(lineItem.APTS_Proposal_Business_Unit__c=='FindLaw')
            // findLawLineItems.add(lineItem);
        //SOC-8629 Added by Chirag
        //DOC-547 Added by Nandha
        else if(lineItem.APTS_Proposal_Business_Unit__c=='SCS'|| lineItem.APTS_Proposal_Business_Unit__c =='Canada' || lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional')
             otherLineItems.add(lineItem);
             //DOC-3563 changes
        else if(lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC US'||lineItem.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK' ||
                (lineItem.APTS_Proposal_Business_Unit__c != null && System.Label.Risk_PBUs.contains(lineitem.APTS_Proposal_Business_Unit__c))){
             otherLineItems.add(lineItem); 
             corpandRiskLineItems.add(lineItem);
        }
         if(lineItem.APTS_Proposal_Business_Unit__c=='SCS'|| lineItem.APTS_Proposal_Business_Unit__c =='Canada'){
             SCSandCanadaLineItems.add(lineItem);             
         }
        }
        if (!beforeUpdate){
          //  beforeUpdate = True; //Added by Dinesh for Too many SOQL error fix
           if(!otherLineItems.isEmpty())
             APTS_LineItemTriggerHelper.populateAllApprovalRequiredCB(otherLineItems);
           if(!findLawLineItems.isEmpty())
             APTS_FL_LineItemTriggerHelper.populateAllApprovalRequiredCB(findLawLineItems,findLawcartIdSet); //Added parameter as part of descope
             if(!SCSandCanadaLineItems.isEmpty()){
             APTS_LineItemTriggerHelper.multiYearTieredPricingSCSandCanada(SCSandCanadaLineItems);
           }
             //DOC-3563 changes     
           /*if(!corporateLineItems.isEmpty()){       
             //APTS_CORP_LineItemTriggerHelper.multiYearTieredPricing(corporateLineItems);//DOC-3563     //Commented as part of Risk Sep Release 
             //APTS_CORP_LineItemTriggerHelper.populateAllApprovalsRequiredforCorp(corporateLineItems);//DOC-4586     
           }*/   
           //Added as part of Risk Sep Release
           if(!corpandRiskLineItems.isEmpty()){       
             APTS_CORP_LineItemTriggerHelper.multiYearTieredPricing(corpandRiskLineItems);  
             APTS_CORP_LineItemTriggerHelper.populateAllApprovalsRequiredforCorp(corpandRiskLineItems);//DOC-4586         
            }
        }
   // }
    // Changes done by Bhupendra Jain on 27-Oct-16 for Before Update logic ends here
    
    //Merged Code as part of SOC-6701 Start--Zakeer
    
    //Added by Gayatri  - to populate FLQty field
    
/*    public Static void populateFLQty(List<Apttus_Config2__LineItem__c > lConfiglines){
      set<id> accountidlist = new set<id>();      
      list<Apttus_Config2__LineItem__c> cclist = new list<Apttus_Config2__LineItem__c >();
      List<Apttus_Config2__LineItem__c> configLineItemList=[SELECT ID, Apttus_Config2__ProductId__c,APTS_FL_Qty__c,Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__r.productcode,Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c 
                                                            FROM Apttus_Config2__LineItem__c 
                                                            WHERE ID IN :lConfiglines];

      for(Apttus_Config2__LineItem__c lineItem : configLineItemList){              
          accountidlist.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c);    
      }    
      List<Apttus_Config2__AssetLineItem__c> assetLineItemList = [SELECT ID, Apttus_Config2__ProductId__c,Apttus_Config2__Quantity__c
                                                              FROM Apttus_Config2__AssetLineItem__c 
                                                              WHERE Apttus_Config2__AccountId__c  IN :accountidlist                                                             
                                                              AND Apttus_Config2__AssetStatus__c = 'Activated'];  
                                                           
                                                              
      for(Apttus_Config2__LineItem__c cc : lConfiglines){
          Decimal count =0;
            for(Apttus_Config2__AssetLineItem__c  aa :assetLineItemList){   
                if(cc.Apttus_Config2__ProductId__c == aa.Apttus_Config2__ProductId__c  )
                 count  = count + aa.Apttus_Config2__Quantity__c;             
            }
            system.debug('count====>'+count);
            cc.APTS_FL_Qty__c  = integer.valueOf(count + cc.Apttus_Config2__Quantity__c);
            //cc.APTS_FL_Qty__c  = 2;     
            system.debug('cc.APTS_FL_Qty__c====>'+cc.APTS_FL_Qty__c);              
      }
    }  */
    //SOC-6701 End
}}