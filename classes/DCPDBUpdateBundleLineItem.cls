/********************************************************************************
Class Name : DCPDBPopulateLineItemsDetails                          
@description : This class is for dynamic bundling.
***************************************************************************************

Modification Details
    Date             DCPDBPopulateLineItemsDetails                          Owner
10/06/2021           Class Created                                          By Herin Acharya

*********************************************************************************/
public without sharing class DCPDBUpdateBundleLineItem{
    public static id cartId;
    
    /** 
    @description 
    @param cartIDToLineItemsMap
    */ 
    public static void updateDynamicBundleLineItem(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap){

        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();
        Map<String,Decimal> linseq = new Map<String,Decimal>();
        
        cartId = DCPDynamicBundling.objectCart.id;

        Map<String,Apttus_Config2__LineItem__c> fieldmap = new Map<String,Apttus_Config2__LineItem__c>();
        populateFieldMap(fieldmap,cartId,cartIDToLineItemsMap.get(cartId));

        //This logic is for populating dynamic bundle line item details.... AGAIN????
        List<Apttus_Config2__LineItem__c> lilist = cartIDToLineItemsMap.get(cartId);
        for(Apttus_Config2__LineItem__c li: lilist){
            if(DCPDynamicBundling.cartToBundleData.get(cartId).prdcode != null && DCPDynamicBundling.cartToBundleData.get(cartId).prdcode.contains(li.APTS_Product_Code__c)){
                linseq.put(li.APTS_Totaling_Summary_Group__c,li.Apttus_Config2__LineNumber__c);
                if(fieldmap != null && fieldmap.get(li.APTS_Totaling_Summary_Group__c) != null){
                    li.APTS_Bridge__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Bridge__c;
                    li.APTS_New_Bridge_Discount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_New_Bridge_Discount__c;
                    li.APTS_Contract_Term__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Contract_Term__c;
                    li.APTS_Years_2_Plus_Adjustment__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).APTS_Years_2_Plus_Adjustment__c;
                    li.Apttus_Config2__BillingFrequency__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__BillingFrequency__c;
                    li.Apttus_Config2__AdjustmentType__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentType__c;
                    li.Apttus_Config2__AdjustmentAmount__c = fieldmap.get(li.APTS_Totaling_Summary_Group__c).Apttus_Config2__AdjustmentAmount__c;
                    lineitemlist.add(li);
                }
            }
            
        }
            //end of logic to again update dynamic bundle
        

        if(!lineitemlist.isEmpty() && !Test.isRunningTest()
           && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
            update lineitemlist;
        }
        updateLineItemSequence(cartIDToLineItemsMap,linseq);
    }
    
    /** 
    @description 
    @param fieldmap
    @param cartId
    @param liList
    */
    public static void populateFieldMap(Map<String,Apttus_Config2__LineItem__c> fieldmap,Id cartId,List<Apttus_Config2__LineItem__c> liList){
        Apttus_Config2__LineItem__c adjustedLineItem;
        for(Apttus_Config2__LineItem__c li: liList){
            if(DCPDynamicBundling.cartToBundleData.get(cartId).prdcode != null && !DCPDynamicBundling.cartToBundleData.get(cartId).prdcode.contains(li.APTS_Product_Code__c)){
                fieldmap.put(li.APTS_Totaling_Summary_Group__c,li);
                //If a line item has adjustment amount, store the line item to be put into 'fieldmap'
                if(li.Apttus_Config2__AdjustmentAmount__c != null && li.Apttus_Config2__AdjustmentAmount__c != 0){
                    adjustedLineItem = li;
                }
            }
        }
        //Update 'fieldmap' with line item that contains adjustment amount
        if(adjustedLineItem != null){
            fieldmap.put(adjustedLineItem.APTS_Totaling_Summary_Group__c,adjustedLineItem);
        }
        return;
    }
    
    private static void updateLineItemSequence(Map<id,List<Apttus_Config2__LineItem__c>> cartIDToLineItemsMap,Map<String,Decimal> linseq){

        List<Apttus_Config2__LineItem__c> lineitemlist = new List<Apttus_Config2__LineItem__c>();
        //Id configId = cartId;
        List<Apttus_Config2__LineItem__c> lilist = cartIDToLineItemsMap.get(cartId);
        Decimal count2 = 0;
        //Sets line item sequence for dynamic bundle subproducts
        for(Apttus_Config2__LineItem__c li : lilist){
            if((new List<String>{'New','Amended'}).contains(li.Apttus_Config2__LineStatus__c ) &&
                (DCPDynamicBundling.cartToBundleData.get(cartId).prdcode != null && 
                !DCPDynamicBundling.cartToBundleData.get(cartId).prdcode.contains(li.APTS_Product_Code__c)) && 
                linseq.get(li.APTS_Totaling_Summary_Group__c)!=null && 
                li.APTS_Bundle__c.contains('Bundle'))
                {
                li.Apttus_Config2__LineSequence__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                li.Apttus_Config2__LineNumber__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                li.Apttus_Config2__ItemSequence__c = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
                linseq.put(li.APTS_Totaling_Summary_Group__c,li.Apttus_Config2__LineSequence__c);
                lineitemlist.add(li);
                count2 = linseq.get(li.APTS_Totaling_Summary_Group__c) + 1;
            }
        }
        //Sets line item sequence of products not in dynamic bundle
        setLineItemSequence(lineitemlist,lilist,count2);    
        //DOC-13387 : Added for Dynamic Bundle Tiered Pricing: Ends Here
        
        if(!lineitemlist.isEmpty() && !Test.isRunningTest()){
            update lineitemlist;
        }  
    }
    
    private static void setLineItemSequence(List<Apttus_Config2__LineItem__c> lineitemlist,List<Apttus_Config2__LineItem__c> lilist,Decimal count2){

        for(Apttus_Config2__LineItem__c li : lilist){
            if((li.Apttus_Config2__LineStatus__c == 'New' || li.Apttus_Config2__LineStatus__c=='Amended') && li.APTS_Bundle__c == null && count2 > 0){
                li.Apttus_Config2__LineNumber__c = count2;
                li.Apttus_Config2__LineSequence__c = count2;
                li.Apttus_Config2__ItemSequence__c = count2;
                lineitemlist.add(li);
                count2 = count2 + 1;
            }
        }  
        setCancelledLineItemSequence(lineitemlist,lilist,count2);

    }
    
    private static void setCancelledLineItemSequence(List<Apttus_Config2__LineItem__c> lineitemlist,List<Apttus_Config2__LineItem__c> lilist,Decimal count2){
        for(Apttus_Config2__LineItem__c li : lilist){
            if(li.Apttus_Config2__LineStatus__c != 'New' && li.Apttus_Config2__LineStatus__c!='Amended' && count2 > 0){
                li.Apttus_Config2__LineSequence__c = count2;
                li.Apttus_Config2__LineNumber__c = count2;                
                lineitemlist.add(li);
                count2 = count2 + 1;
            }
        }
    }
}