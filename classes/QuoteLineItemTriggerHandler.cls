/**
 * This class will contain the helper methods for quoteLineItem evenListeners.
 *
 * @author  Harika
 * @version  2015-18-12
 */
 /**
 * CHANGE HISTORY
 * ===============================================================================================
 * Date         Name                    Description
 * 2015-18-01   Harika                    Created
 * 2016-20-07   Debarghya                 Added method 'RenewalQLISyncOnInsert'
   2016-20-07   Satyaki                   Added method 'RenewalQLISync'
   2016-25-07   Priyanka                  Added method 'upliftDowngradePartialCancelHandler'
 * ==============================================================================================
 */
 public class QuoteLineItemTriggerHandler{
      public static Boolean syncQuotetoOppty_methodcalled = false; // Indu added
     public static void MapValuesOfQuoteLineItem(list<QuoteLineItem> listQuoteLineItem){
         Map<String,QuoteLineItem> QuoteLineItemToProductMap =  new Map<String,QuoteLineItem>();
         List<id> QuoteItemIdList = new List<id>();
         Set<id> OpportunityIdList = new Set<id>();
         List<QuoteLineItem> UpdateQuoteLineItem  = new List<QuoteLineItem>();
         Map<String,OpportunityLineItem> OppLineItemToProductMap = new Map<String,OpportunityLineItem>();
         Map<String,Id> OppLineItemAndOppMap=  new Map<String,Id>();
         
         for(QuoteLineItem QLI : listQuoteLineItem){
             QuoteItemIdList.add(QLI.Id);  
         } 
         
         // Create Map of Product and Quote Line Item
         List<QuoteLineItem> QuoteLIList = [Select id,QuoteId,Quote.OpportunityId,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,Description,Revenue_Type__c,Product2Id,Quote.Opportunity.All_Quote_Count__c,Quote.Opportunity.LatAm_Standardization_Quotes__c,currencyISOCode,MOLI_id__c,OpportunityLineId__c from QuoteLineItem Where Id IN: QuoteItemIdList];
         
         for(QuoteLineItem QuoteLI: QuoteLIList){
             QuoteLineItemToProductMap.put(QuoteLI.Product2Id+''+QuoteLI.OpportunityLineId__c,QuoteLI); //SFD-1121 Changing the key [Rajashree]
             system.debug('***:: QuoteLineItemToProductMap ' +QuoteLineItemToProductMap);             
             OpportunityIdList.add(QuoteLI.Quote.OpportunityId);             
         }
         
         // Create Map of Product and Opportunity Line Item
         List<OpportunityLineItem> OLIList = [Select Id,MOLI_id__c,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,Description,Revenue_Type__c,OpportunityId,Product2Id from OpportunityLineItem where OpportunityId=: OpportunityIdList];
         
         for(OpportunityLineItem OppLI : OLIList){
             OppLineItemToProductMap.put(OppLI.product2Id+''+OppLI.id,OppLI); //SFD-1121 Changing the key [Rajashree]
             OppLineItemAndOppMap.put(OppLI.product2Id+''+OppLI.id,OppLI.OpportunityId); //SFD-1121 Changing the key [Rajashree]  
             system.debug('***:: QuoteLineItemToProductMap ' +QuoteLineItemToProductMap );  
             system.debug('***:: OppLineItemAndOppMap' +OppLineItemAndOppMap);  
         }
         
         for(QuoteLineItem QLItem : QuoteLIList){
             system.debug('QLItem...'+QLItem);
             system.debug('***QLItem.Quote.Opportunity.LatAm_Standardization_Quotes__c' +QLItem.Quote.Opportunity.LatAm_Standardization_Quotes__c + '  ' +QLItem.Quote.Opportunity.All_Quote_Count__c);
             If(QLItem.Quote.Opportunity.LatAm_Standardization_Quotes__c >0 || QLItem.Quote.Opportunity.All_Quote_Count__c == 0){
                 system.debug('***inside QLI::'+QLItem.Product2Id);
                 if(OppLineItemToProductMap.containsKey(QLItem.Product2Id+''+QLItem.OpportunityLineId__c)){ 
                     if(OppLineItemAndOppMap.get(QLItem.Product2Id+''+QLItem.OpportunityLineId__c) == QLItem.Quote.OpportunityId){
                         OpportunityLineItem OppLineItem = OppLineItemToProductMap.get(QLItem.Product2Id+''+QLItem.OpportunityLineId__c);
                         QLItem.Revenue_Type__c = OppLineItem.Revenue_Type__c ;
                         QLItem.Number_of_Contacts__c = OppLineItem.Number_of_Contacts__c ;
                         QLItem.Incremental_Amount__c = OppLineItem.Incremental_Amount__c ;
                         QLItem.Description = OppLineItem.Description ;
                         QLItem.Renewal_Amount__c = OppLineItem.Renewal_Amount__c;
                         //QLItem.Monthly_Charge__c = OppLineItem.Monthly_Charge__c ;
                         QLItem.Surcharge_Prct__c = OppLineItem.Surcharge_Prct__c ;                         
                         UpdateQuoteLineItem.add(QLItem);
                     }    
                 }    
             }
         }         
         
         if(UpdateQuoteLineItem.size()>0)
         System.debug('Before ###### ListQLI'+UpdateQuoteLineItem);
             Update UpdateQuoteLineItem;
         //SFD-512    
         System.debug('After ###### ListQLI'+UpdateQuoteLineItem);
         getCurrencydecimalPlaces(QuoteLIList,true);
    }
     
    public static void SyncQuoteLIValueToOppLI(List<QuoteLineItem> newQLIs, Map<Id, QuoteLineItem> oldQuoteLineItemMap){
      system.debug('%%%%% Flag'+checkRecursive.isRenewalQLIInsert);
      system.debug('%%%%% Flag2'+checkRecursive.isRenewalOLIInsert);
      system.debug('%%%%% Flag2'+checkRecursive.isRenewalQLI);
      system.debug('%%%%% Flag2'+checkRecursive.isRenewalOLI);

         syncQuotetoOppty_methodcalled= true;
         set<Id> UpdatedQuoteLineItem = new set<Id>();
         Map<String,QuoteLineItem> QuoteLineItemToProductMap =  new Map<String,QuoteLineItem>();
         Map<id,QuoteLineItem> QLIDetailMap = new Map<id,QuoteLineItem>();
         Map<String,OpportunityLineItem> OppLineItemToProductMap = new Map<String,OpportunityLineItem>();
         Map<String,Id> OppLineItemAndOppMap =  new Map<String,Id>();
         List<id> QLIOppIdList =  new List<id>();
         List<OpportunityLineItem> UpdateOppLineItemList = new List<OpportunityLineItem>();
         
         try{
             for(QuoteLineItem QLI: newQLIs){
                 system.debug('QLI..'+QLI);
                 system.debug('oldQuoteLineItemMap.get(QLI.Id)..'+oldQuoteLineItemMap.get(QLI.Id));
                 If(QLI.unitprice != oldQuoteLineItemMap.get(QLI.Id).unitprice||QLI.Quantity!= oldQuoteLineItemMap.get(QLI.Id).Quantity||QLI.Discount != oldQuoteLineItemMap.get(QLI.Id).Discount || QLI.Revenue_Type__c != oldQuoteLineItemMap.get(QLI.Id).Revenue_Type__c || QLI.Number_of_Contacts__c  != oldQuoteLineItemMap.get(QLI.Id).Number_of_Contacts__c || QLI.Incremental_Amount__c != oldQuoteLineItemMap.get(QLI.Id).Incremental_Amount__c ||
                      QLI.Renewal_Amount__c != oldQuoteLineItemMap.get(QLI.Id).Renewal_Amount__c || QLI.Monthly_Charge__c != oldQuoteLineItemMap.get(QLI.Id).Monthly_Charge__c || QLI.Surcharge_Prct__c!= oldQuoteLineItemMap.get(QLI.Id).Surcharge_Prct__c || QLI.Annual_Price__c != oldQuoteLineItemMap.get(QLI.Id).Annual_Price__c ){
                      
                      UpdatedQuoteLineItem.add(QLI.id); 
                      QuoteLineItemToProductMap.put(QLI.Product2Id+''+QLI.OpportunityLineId__c,QLI);//SFD-1121 Changing the key [Rajashree]  
                 }
             }
             
             List<QuoteLineItem> QuoteLineItemDetailList = [Select id,MOLI_id__c,OpportunityLineId__c,quantity,unitprice,discount,Revenue_Type__c,Surcharge_Prct__c ,Number_of_Contacts__c,Renewal_Amount__c ,Description ,Monthly_Charge__c,Incremental_Amount__c ,Product2id,quote.Opportunityid,quote.Primary_Quote__c,Annual_Price__c from QuoteLineItem where ID IN: UpdatedQuoteLineItem AND quote.Primary_Quote__c =: True and quote.issyncing =:true];       
             
             for(QuoteLineItem qote: QuoteLineItemDetailList){
                 QLIDetailMap.put(qote.id,qote);
                 QLIOppIdList.add(qote.quote.Opportunityid);
             }
             
             // Create Map of Product and Opportunity Line Item
             List<OpportunityLineItem> OLIList = [Select Id,MOLI_id__c,quantity,unitprice,discount,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,Description,Revenue_Type__c,OpportunityId,Product2Id,Annual_Price__c from OpportunityLineItem where OpportunityId=: QLIOppIdList];
             
             for(OpportunityLineItem OppLI : OLIList){
                 OppLineItemToProductMap.put(OppLI.product2Id+''+OppLI.id,OppLI); //SFD-1121 Changing the key [Rajashree]
                 OppLineItemAndOppMap.put(OppLI.product2Id+''+OppLI.id,OppLI.OpportunityId); //SFD-1121 Changing the key [Rajashree]  
             }
             
             system.debug('OppLineItemToProductMap::'+OppLineItemToProductMap);
             system.debug('$$$QuoteLineItemDetailList::'+QuoteLineItemDetailList);
             
             for(QuoteLineItem LI: QuoteLineItemDetailList ){
                 system.debug('Line 105');
                 if(OppLineItemToProductMap.containsKey(LI.Product2Id+''+LI.OpportunityLineId__c)){
                     OpportunityLineItem OppLI = OppLineItemToProductMap.get(LI.Product2Id+''+LI.OpportunityLineId__c); 
                     if(OppLI.OpportunityID == LI.Quote.OpportunityID){
                         system.debug('LI.Revenue_Type__c::'+LI.Revenue_Type__c );
                         OppLI.Revenue_Type__c = LI.Revenue_Type__c ;
                         OppLI.Number_of_Contacts__c = LI.Number_of_Contacts__c ;
                         OppLI.Incremental_Amount__c = LI.Incremental_Amount__c ;
                         //OppLI.Description = LI.Description ; 
                         OppLI.Renewal_Amount__c = LI.Renewal_Amount__c ;
                         OppLI.Monthly_Charge__c = LI.Monthly_Charge__c ;
                         OppLI.Surcharge_Prct__c = LI.Surcharge_Prct__c ;
                         OppLI.Discount = LI.Discount; // Indu 
                         OppLI.Quantity= LI.Quantity; // Rajashree added for [SFD-1138]
                         OppLI.unitprice = LI.unitprice;// Rajashree added for [SFD-1138]
                         OppLI.Annual_Price__c = LI.Annual_Price__c; // Sujana [SFD-415]  
                         UpdateOppLineItemList.add(OppLI);  
                     }  
                 }
             }
             system.debug('$$$UpdateOppLineItemList'+UpdateOppLineItemList);
            /* for(OpportunityLineItem OppLI: OLIList){
                 
                 
                 if(QLIDetailMap.containsKey(OppLI.Product2Id)){   
                     QuoteLineItem LI = QLIDetailMap.get(OppLI.Product2Id);
                     system.debug('Primary Quote::'+QLIDetailMap.get(LI.id).quote.Primary_Quote__c );
                     system.debug('OPPID ::'+LI.Quote.OpportunityId );
                     system.debug('Line Item ::'+LI );
                     if(QLIDetailMap.get(LI.id).quote.Primary_Quote__c == True && OppLineItemAndOppMap.get(OppLI.Product2Id+''+OppLI.id) == LI.Quote.OpportunityId){
                         system.debug('LI.Revenue_Type__c::'+LI.Revenue_Type__c );
                         OppLI.Revenue_Type__c = LI.Revenue_Type__c ;
                         OppLI.Number_of_Contacts__c = LI.Number_of_Contacts__c ;
                         OppLI.Incremental_Amount__c = LI.Incremental_Amount__c ;
                         OppLI.Description = LI.Description ; 
                         OppLI.Renewal_Amount__c = LI.Renewal_Amount__c ;
                         OppLI.Monthly_Charge__c = LI.Monthly_Charge__c ;
                         UpdateOppLineItemList.add(OppLI);   
                     }    
                 }      
             }*/
             
             if(UpdateOppLineItemList.size()>0)
                 Update UpdateOppLineItemList;
         }     
         catch(Exception e){
             System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
         }
    }
    //***** To get Opportunity currency decimal places from Currency Type ******
    //****** Method Name: getcurrencyDecimalPlaces ******************************
    //Author: Harika Date: 27-02-2016 *******************************************/
    public static void getCurrencydecimalPlaces(List<QuoteLineItem> newList, Boolean isAfter){
        try{
            List<currencyType> cuuenrcyTypeLst= [SELECT ISOCOde,DecimalPlaces FROM CurrencyType WHERE IsActive=TRUE];
            Map<String,Integer> CurrencyDecimalMap= new Map<string,Integer>();
            if(cuuenrcyTypeLst!= null && cuuenrcyTypeLst.size() >0){
                for(currencyType ct:cuuenrcyTypeLst){
                    CurrencyDecimalMap.put(ct.ISOCOde,ct.DecimalPlaces);
                }
            }
            List<QuoteLineItem> qlitoInsertLst= new List<QuoteLineItem>();
            if(!newList.isEmpty()){
                for(QuoteLineItem qli:newList ){
                    system.debug('****CurrencyDecimalMap::' + qli.currencyISOCode + ' '+ CurrencyDecimalMap.get(qli.currencyISOCode));
                    if(CurrencyDecimalMap != null && CurrencyDecimalMap.get(qli.currencyISOCode) != null)
                        qli.Decimal_Places_for_Currency__c = CurrencyDecimalMap.get(qli.currencyISOCode);
                    else
                        qli.Decimal_Places_for_Currency__C = 2;   
                    system.debug('****Decimal_Places_for_Currency__c::' +qli.Decimal_Places_for_Currency__c);   
                    if(isAfter)
                        qlitoInsertLst.add(qli);        
    
                }
                
                if(!qlitoInsertLst.isEmpty() && isAfter){
                    Update qlitoInsertLst;
                }
            
            }
        }catch(Exception ex)
        {
            system.debug('***Exception occured getCurrencydecimalPlaces() ::' + ex.getMEssage());
        }
     }
  /******************************************************************************************
    Method Name: RenewalQLISync
    Created By: Satyaki 
    Purpose: Sync QLI to OLI for Renewals 
    Defects:
   *****************************************************************************************/
      public static void RenewalQLISync(Map<Id, QuoteLineItem> newQuoteLineItemMap, Map<Id, QuoteLineItem> oldQuoteLineItemMap){   
     if(userinfo.getProfileid() == Profile_List__c.getInstance('LatAm User').ProfileId__c ||
        userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c||
        userinfo.getProfileid() == Profile_List__c.getInstance('System Administrator').ProfileId__c){
            // syncQuotetoOppty_methodcalled= true;
        System.debug('#######Step 1 oldmap'+ oldQuoteLineItemMap);
        System.debug('#######Step 2 newmap'+ newQuoteLineItemMap);
            checkRecursive.isRenewalOpp = false;
            checkRecursive.isRenewalQuote = false;
            checkRecursive.isRenewalOLI = false;
            checkRecursive.isRenewalQLIInsert = false;
            checkRecursive.isRenewalOLIInsert = false;
            Boolean boolChck = false;
             
             if(checkRecursive.isRenewalQLI == true) {
                 try{
                System.debug('#######Step 3 is RenewalQLI'+ checkRecursive.isRenewalQLI);
                     List<OpportunityLineItem> UpdateOppLineItemList = new List<OpportunityLineItem>();
                     set<Id> setQuoId = new set<Id>();
                     set<String> setMaterialNumber= new set<String>();
                     map<String,QuoteLineItem> mapQuoQLI =new map<String,QuoteLineItem>();
                     
                     for(QuoteLineItem QLI: newQuoteLineItemMap.values()){
                      //   system.debug('Step1: '+QLI);
                         system.debug('########Step 4 oldQuoteLineItemMap.get(QLI.Id)..'+oldQuoteLineItemMap.get(QLI.Id));
                         If(newQuoteLineItemMap.get(QLI.Id).Item_Activity_Type__c != oldQuoteLineItemMap.get(QLI.Id).Item_Activity_Type__c || 
                            newQuoteLineItemMap.get(QLI.Id).Annualized_Base_Price__c != oldQuoteLineItemMap.get(QLI.Id).Annualized_Base_Price__c || 
                            newQuoteLineItemMap.get(QLI.Id).Discount  != oldQuoteLineItemMap.get(QLI.Id).Discount || 
                            newQuoteLineItemMap.get(QLI.Id).Incremental_Amount__c != oldQuoteLineItemMap.get(QLI.Id).Incremental_Amount__c ||
                            newQuoteLineItemMap.get(QLI.Id).Last_Invoice_Price__c != oldQuoteLineItemMap.get(QLI.Id).Last_Invoice_Price__c || 
                            newQuoteLineItemMap.get(QLI.Id).Description != oldQuoteLineItemMap.get(QLI.Id).Description || 
                            newQuoteLineItemMap.get(QLI.Id).Number_of_Contacts__c  != oldQuoteLineItemMap.get(QLI.Id).Number_of_Contacts__c || 
                            newQuoteLineItemMap.get(QLI.Id).Projected_Renewal_Price__c != oldQuoteLineItemMap.get(QLI.Id).Projected_Renewal_Price__c ||
                            newQuoteLineItemMap.get(QLI.Id).Quantity != oldQuoteLineItemMap.get(QLI.Id).Quantity || 
                            newQuoteLineItemMap.get(QLI.Id).Quote_Item__c != oldQuoteLineItemMap.get(QLI.Id).Quote_Item__c || 
                            newQuoteLineItemMap.get(QLI.Id).Revenue_Type__c  != oldQuoteLineItemMap.get(QLI.Id).Revenue_Type__c || 
                            newQuoteLineItemMap.get(QLI.Id).UnitPrice != oldQuoteLineItemMap.get(QLI.Id).UnitPrice ||
                            newQuoteLineItemMap.get(QLI.Id).Shipping_Point__c != oldQuoteLineItemMap.get(QLI.Id).Shipping_Point__c || 
                            newQuoteLineItemMap.get(QLI.Id).Status__c != oldQuoteLineItemMap.get(QLI.Id).Status__c || 
                            newQuoteLineItemMap.get(QLI.Id).Ship_To_Contact__c != oldQuoteLineItemMap.get(QLI.Id).Ship_To_Contact__c || 
                            newQuoteLineItemMap.get(QLI.Id).Ship_To_Customer_Name__c!= oldQuoteLineItemMap.get(QLI.Id).Ship_To_Customer_Name__c|| 
                            newQuoteLineItemMap.get(QLI.Id).Subscription_End_Date__c != oldQuoteLineItemMap.get(QLI.Id).Subscription_End_Date__c || 
                            newQuoteLineItemMap.get(QLI.Id).Subscription_Start_Date__c!= oldQuoteLineItemMap.get(QLI.Id).Subscription_Start_Date__c||
                            newQuoteLineItemMap.get(QLI.Id).Cancel_Date__c!= oldQuoteLineItemMap.get(QLI.Id).Cancel_Date__c||
                            newQuoteLineItemMap.get(QLI.Id).Cancel_Comments__c!= oldQuoteLineItemMap.get(QLI.Id).Cancel_Comments__c||
                            newQuoteLineItemMap.get(QLI.Id).Cancel_Reason__c!= oldQuoteLineItemMap.get(QLI.Id).Cancel_Reason__c||
                            newQuoteLineItemMap.get(QLI.Id).Storage_Location__c!= oldQuoteLineItemMap.get(QLI.Id).Storage_Location__c||
                            newQuoteLineItemMap.get(QLI.Id).Bill_To_Contact__c!= oldQuoteLineItemMap.get(QLI.Id).Bill_To_Contact__c ||
                            newQuoteLineItemMap.get(QLI.Id).Reason_For_New_Product__c!= oldQuoteLineItemMap.get(QLI.Id).Reason_For_New_Product__c){
                                setQuoId.add(QLI.QuoteId);
                                setMaterialNumber.add(QLI.OpportunityLineId__c);
                                mapQuoQLI.put(QLI.QuoteId +''+QLI.OpportunityLineId__c ,QLI);//SFD-831 Changing the key [Rajashree]
                              //UpdatedQuoteLineItem.add(QLI.id); 
                              //QuoteLineItemToProductMap.put(QLI.Product2Id,QLI);  
                         }
                     }
                     system.debug('Step11: setMaterialNumber: ' +setMaterialNumber);
                     system.debug('Step12: mapQuoQLI: ' +mapQuoQLI);
                     if(setQuoId != NULL && !setQuoId.isEmpty()) {
                     // Create Map of Product and Opportunity Line Item
                         List<Opportunity> lstOpp = [SELECT id, (Select Id,quantity,unitprice,discount,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,
                                                                Annualized_Base_Price__c, Last_Invoice_Price__c, Activity_Type__c, Projected_Renewal_Price__c,Reason_For_New_Product__c, 
                                                                Quote_Item__c, Shipping_Point__c, Active_Status__c, Subscription_End_Date__c, Subscription_Start_Date__c, 
                                                                Incremental_Amount__c,Ship_To_Customer_Name__c, Ship_To_Contact__c , Renewal_Amount__c,Description,Revenue_Type__c,OpportunityId,Product2Id,Product2.ProductCode,
                                                                Cancel_Date__c, Cancel_Comments__c, Cancel_Reason__c, Storage_Location__c, Bill_To_Contact__c 
                                                                from OpportunityLineItems where Id IN: setMaterialNumber),SyncedQuoteId
                                                                FROM Opportunity WHERE SyncedQuoteId IN: setQuoId AND Renewal_Flag__c =: true AND SyncedQuote.Primary_Quote__c =: TRUE AND 
                                                                RecordTypeId =: RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c AND 
                                                                Master_Opportunity__c = NULL];
                         
                        Map<id,id> mapQuoOpp= new Map<id,id>();
                        List<OpportunityLineItem> lstobjOLI = new List<OpportunityLineItem>();
                        if( lstOpp!=null && !lstOpp.isEmpty() ){
                            for(Opportunity opp : lstOpp ){    
                                mapQuoOpp.put(opp.id,opp.SyncedQuoteId);
                                lstobjOLI.addAll(opp.OpportunityLineItems);       
                            }
                        }
                        OpportunityLineItem objOLI;
                        if( lstobjOLI!=null && !lstobjOLI.isEmpty() ){ 
                             for(OpportunityLineItem OLI: lstobjOLI ){
                                 system.debug('Step 4');
                                 objOLI= new OpportunityLineItem();
                                 objOLI.id = OLI.id;
                                 String Opp= mapQuoOpp.get(OLI.OpportunityId);
                                // String OliId = OLI.id;
                               //  String subOliId = OliId.substring(0,15);
                                if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Number_of_Contacts__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Number_of_Contacts__c) {
                                    objOLI.Number_of_Contacts__c = mapQuoQLI.get(Opp+''+OLI.id).Number_of_Contacts__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Item_Activity_Type__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Item_Activity_Type__c) {
                                    objOLI.Activity_Type__c = mapQuoQLI.get(Opp+''+OLI.id).Item_Activity_Type__c; 
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Annualized_Base_Price__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Annualized_Base_Price__c) {
                                    objOLI.Annualized_Base_Price__c = mapQuoQLI.get(Opp+''+OLI.id).Annualized_Base_Price__c;
                                    boolChck = true;
                                 } 
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Ship_To_Customer_Name__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Ship_To_Customer_Name__c) {
                                    objOLI.Ship_To_Customer_Name__c= mapQuoQLI.get(Opp+''+OLI.id).Ship_To_Customer_Name__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Ship_To_Contact__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Ship_To_Contact__c ) {
                                    objOLI.Ship_To_Contact__c = mapQuoQLI.get(Opp+''+OLI.id).Ship_To_Contact__c ;
                                    boolChck = true;
                                 }//SFD-911 
                                  //if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Discount != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Discount) {
                                  //  objOLI.Discount = mapQuoQLI.get(Opp+''+OLI.id).Discount;
                                  //  boolChck = true;
                                // }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Incremental_Amount__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Incremental_Amount__c) {
                                    objOLI.Incremental_Amount__c = mapQuoQLI.get(Opp+''+OLI.id).Incremental_Amount__c; 
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Last_Invoice_Price__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Last_Invoice_Price__c) {
                                    objOLI.Last_Invoice_Price__c = mapQuoQLI.get(Opp+''+OLI.id).Last_Invoice_Price__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Description != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Description) 
                                 {
                                    objOLI.Description = mapQuoQLI.get(Opp+''+OLI.id).Description;
                                    boolChck = true;
                                    //system.debug('Step 4.5: QLI Description='+LI.Description);
                                 } 
                                // if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Material_Number__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Material_Number__c) {
                                 //   objOLI.Material_Number__c = string.valueOf(mapQuoQLI.get(Opp+''+OLI.id).Material_Number__c);
                                  //  boolChck = true;
                                // } 
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Product2.Id != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Product2.Id){
                                   objOLI.Product2.Id = mapQuoQLI.get(Opp+''+OLI.id).Product2.Id;
                                   boolChck = true;
                                 } 
                                
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Projected_Renewal_Price__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Projected_Renewal_Price__c) {
                                    objOLI.Projected_Renewal_Price__c = mapQuoQLI.get(Opp+''+OLI.id).Projected_Renewal_Price__c;
                                    boolChck = true;
                                 } 
                                 //Blocked by piyali
                                // if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Quantity != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Quantity) {
                                //    objOLI.Quantity = mapQuoQLI.get(Opp+''+OLI.id).Quantity;
                                //    boolChck = true;
                                // }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Quote_Item__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Quote_Item__c) {
                                    objOLI.Quote_Item__c = mapQuoQLI.get(Opp+''+OLI.id).Quote_Item__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Revenue_Type__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Revenue_Type__c) {
                                    objOLI.Revenue_Type__c = mapQuoQLI.get(Opp+''+OLI.id).Revenue_Type__c;
                                    boolChck = true;
                                 } 
                                 //Blocked by Piyali
                                 //if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.Product2Id).Id).UnitPrice != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.Product2Id).Id).UnitPrice) {
                                  //  objOLI.UnitPrice = mapQuoQLI.get(Opp+''+OLI.Product2Id).UnitPrice;
                                  //  boolChck = true;
                                // }
                                 //Start SFD-856
                                if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Quantity != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Quantity || newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).UnitPrice != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).UnitPrice || newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Discount != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Discount) {
                                    objOLI.Quantity = mapQuoQLI.get(Opp+''+OLI.id).Quantity;
                                    objOLI.UnitPrice = mapQuoQLI.get(Opp+''+OLI.id).UnitPrice;
                                    objOLI.Discount = mapQuoQLI.get(Opp+''+OLI.id).Discount;
                                    boolChck = true;
                                    system.debug('SSS1:'+objOLI.Quantity);
                                    system.debug('SSS2:'+objOLI.UnitPrice);
                                 }
                                 //End SFD-856
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Shipping_Point__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Shipping_Point__c) {
                                    objOLI.Shipping_Point__c = mapQuoQLI.get(Opp+''+OLI.id).Shipping_Point__c;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Status__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Status__c) {
                                    objOLI.Active_Status__c = mapQuoQLI.get(Opp+''+OLI.id).Status__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Subscription_End_Date__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Subscription_End_Date__c) {
                                    objOLI.Subscription_End_Date__c = mapQuoQLI.get(Opp+''+OLI.id).Subscription_End_Date__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Subscription_Start_Date__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Subscription_Start_Date__c) {
                                    objOLI.Subscription_Start_Date__c = mapQuoQLI.get(Opp+''+OLI.id).Subscription_Start_Date__c;
                                    boolChck = true;
                                 }
                                 if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Cancel_Date__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Cancel_Date__c) {
                                  objOLI.Cancel_Date__c = mapQuoQLI.get(Opp+''+OLI.id).Cancel_Date__c;
                                  boolChck = true;
                                } 
                               if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Cancel_Comments__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Cancel_Comments__c) {
                                  objOLI.Cancel_Comments__c = mapQuoQLI.get(Opp+''+OLI.id).Cancel_Comments__c;
                                  boolChck = true;
                                } 
                               if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Cancel_Reason__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Cancel_Reason__c) {
                                  objOLI.Cancel_Reason__c = mapQuoQLI.get(Opp+''+OLI.id).Cancel_Reason__c; 
                                  boolChck = true;
                                } 
                               if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Storage_Location__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Storage_Location__c) {
                                   objOLI.Storage_Location__c = mapQuoQLI.get(Opp+''+OLI.id).Storage_Location__c; 
                                   boolChck = true;
                                } 
                                if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Reason_For_New_Product__c!= oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Reason_For_New_Product__c) {
                                   objOLI.Reason_For_New_Product__c = mapQuoQLI.get(Opp+''+OLI.id).Reason_For_New_Product__c; 
                                   boolChck = true;
                                }//FRS 3.2.1.4  SFD-809
                               if(newQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Bill_To_Contact__c != oldQuoteLineItemMap.get(mapQuoQLI.get(Opp+''+OLI.id).Id).Bill_To_Contact__c ) {
                                   objOLI.Bill_To_Contact__c  = mapQuoQLI.get(Opp+''+OLI.id).Bill_To_Contact__c ; 
                                   boolChck = true;
                                } 
                                if(boolChck == true){   
                                   UpdateOppLineItemList.add(objOLI);     
                                }
                             }
                        }
                     }
                     system.debug('Step5$$$UpdateOppLineItemList'+UpdateOppLineItemList);
                    
                     
                     if(UpdateOppLineItemList != NULL && !UpdateOppLineItemList.isEmpty())
                         DATABASE.UPDATE(UpdateOppLineItemList);
                 }     
                 catch(Exception e){
                     System.debug(e+'Step6*********'+e.getLinenumber()+e.getmessage());
                 }
             }
            checkRecursive.isRenewalOpp = true;
            checkRecursive.isRenewalQuote = true;
            checkRecursive.isRenewalOLI = true;   
            checkRecursive.isRenewalQLIInsert = true;
            checkRecursive.isRenewalOLIInsert = true;
        } 
    }    
   
 public static void RenewalQLISyncOnInsert(Map<Id, QuoteLineItem> newQuoteLineItemMap, List<QuoteLineItem> lstnewTriggerQLI) {
  
        checkRecursive.isRenewalOpp = false;
        checkRecursive.isRenewalQuote = false;
        checkRecursive.isRenewalOLI = false; 
        checkRecursive.isRenewalQLI = false;
        checkRecursive.isRenewalOLIInsert = false;
        checkRecursive.isRenwlQLINotUpdt = false;
        Boolean boolChck = false;
        if(checkRecursive.isRenewalQLIInsert == true){
             List<QuoteLineItem> lstQLInew;
             List<QuoteLineItem> lstQLIupdate = new List<QuoteLineItem>();
             List<OpportunityLineItem> lstOLI;
             Set<id> setOpptyId = new set<id>();
             Map<String, OpportunityLineItem> mapOLI = new Map<String, OpportunityLineItem>();
             //Map<id, String> mapOpptyQuote = new Map<id, String>();
             Map<String, String> mapOpptyQuote = new Map<String, String>();   
             lstQLInew = [SELECT id, QuoteId,OpportunityLineId__c,Quote.OpportunityId, Product2Id, Ship_To_Contact__c ,Quote.Renewal_Flag_Formula__c, Quote.RecordTypeId, Reason_For_New_Product__c 
                         FROM QuoteLineItem 
                         WHERE id IN: newQuoteLineItemMap.keySet()
                         AND Quote.Primary_Quote__c = TRUE
                         AND Quote.Renewal_Flag_Formula__c =: true
                         AND Quote.RecordTypeId =: RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c
                         AND Quote.Master_Quote__c = NULL];
             //system.debug('########lstQLInew='+lstQLInew);
             if(lstQLInew != null && lstQLInew.size() > 0){
                 For(QuoteLineItem qli: lstQLInew) {
                     setOpptyId.add(qli.Quote.OpportunityId);
                     mapOpptyQuote.put(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c, qli.Quote.OpportunityId+''+qli.Product2Id+''+qli.OpportunityLineId__c);//SFD-831 Changing the key and value[Rajashree]
                 }
             }
             //system.debug('########setOpptyId='+setOpptyId);
             //system.debug('########mapOpptyQuote='+mapOpptyQuote);
             
             if(setOpptyId != null && setOpptyId.size() > 0){
                 lstOLI = [SELECT id, OpportunityId,Active_Status__c,Quantity, UnitPrice, Discount  , Activity_Type__c, Product2Id, Bill_To_Contact__c, Number_of_Contacts__c,
                              Bill_To_Customer_Name__c, Last_Invoice_Price__c, Previous_Subscription_Number__c,Reason_For_New_Product__c, 
                              Projected_Renewal_Price__c, Quote_Item__c, Revenue_Type__c , Shipping_Point__c, Annualized_Base_Price__c,
                              Ship_To_Customer_Name__c, Storage_Location__c, Subscription_End_Date__c,Ship_To_Contact__c ,Subscription_Start_Date__c,Tax_Code__c 
                             FROM OpportunityLineItem
                             WHERE OpportunityId IN: setOpptyId AND Opportunity.Master_Opportunity__c = NULL];
             }            
             //system.debug('########lstOLI='+lstOLI);
             if(lstOLI != null && lstOLI.size() > 0){            
                 For(OpportunityLineItem oli: lstOLI) {
                   //  String OliId = oli.id;
                   //  String subOliId = OliId.substring(0,15);
                     mapOLI.put((oli.OpportunityId +''+oli.Product2Id+''+oli.id), oli);//SFD-831 Changing the key [Rajashree]
                     System.debug('$$$$$$ mapOLI'+ mapOLI);
                     System.debug('$$$$$$ mapOLI'+ oli.id);
                 }
             }
             //system.debug('########mapOLI='+mapOLI);
             QuoteLineItem objQLI = new QuoteLineItem();
             if(mapOLI != null && !mapOLI.isEmpty()){
                 For(QuoteLineItem qli: lstnewTriggerQLI){
                     //system.debug('########mapOpptyQuote get inside if='+mapOpptyQuote.get(qli.QuoteId));
                     //system.debug('########mapOLI get inside if='+mapOLI.get(mapOpptyQuote.get(qli.QuoteId)).Number_of_Contacts__c);
                     
                     objQLI = new QuoteLineItem(id = qli.id); 
                     system.debug('$$$ qli.OpportunityLineId__c:'+qli.OpportunityLineId__c);
                     if(mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)) != null){    
                                       
                         {
                         objQLI.Number_of_Contacts__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Number_of_Contacts__c;
                         boolChck = true;
                         }
                       {
                         objQLI.Annualized_Base_Price__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Annualized_Base_Price__c ; 
                         boolChck = true;
                         }
                         {
                         objQLI.Reason_For_New_Product__c= mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Reason_For_New_Product__c; 
                         boolChck = true;
                         }//FRS 3.2.1.4  SFD-809
                         {
                         objQLI.Bill_To_Contact__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Bill_To_Contact__c ;
                         boolChck = true;
                         }
                         {
                          objQLI.Quantity = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Quantity ;
                          objQLI.UnitPrice = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).UnitPrice ;
                          objQLI.Discount = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Discount ;
                          boolChck = true; 
                          }  
                         {
                         objQLI.Bill_To_Customer_Name__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Bill_To_Customer_Name__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Last_Invoice_Price__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Last_Invoice_Price__c ;
                         boolChck = true;
                         }
                      // if(mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id)).Material_Number__c != null){
                       //       objQLI.Material_Number__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id)).Material_Number__c ;
                        //      boolChck = true;
                       //  } 
                         {
                         objQLI.Previous_Subscription_Number__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Previous_Subscription_Number__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Projected_Renewal_Price__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Projected_Renewal_Price__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Quote_Item__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Quote_Item__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Revenue_Type__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Revenue_Type__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Shipping_Point__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Shipping_Point__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Ship_To_Customer_Name__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Ship_To_Customer_Name__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Ship_To_Contact__c= mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Ship_To_Contact__c;
                         boolChck = true;
                         }//SFD- 911
                         {
                         objQLI.Storage_Location__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Storage_Location__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Subscription_End_Date__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Subscription_End_Date__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Subscription_Start_Date__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Subscription_Start_Date__c ;
                         boolChck = true;
                         }
                         {
                         objQLI.Tax_Code__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Tax_Code__c ;
                         boolChck = true;
                         }
                          {
                         objQLI.Status__c= mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Active_Status__c;
                         boolChck = true;
                         }
                     
                         {
                         objQLI.Item_Activity_Type__c = mapOLI.get(mapOpptyQuote.get(qli.QuoteId+''+qli.Product2Id+''+qli.OpportunityLineId__c)).Activity_Type__c; 
                         boolChck = true;
                         } 
                     }
                     //system.debug('########objQLI get inside if='+objQLI);
                     if(objQLI != null && boolChck == true){
                         lstQLIupdate.add(objQLI);
                     }
                 }
             }
             //system.debug('########lstQLIupdate='+lstQLIupdate);
             try{
                 if(lstQLIupdate != null && !lstQLIupdate.isempty()){
                     Database.Update(lstQLIupdate);
                    // Update lstQLIupdate;
                 }
             } catch (Exception e){
                 //system.debug('########Update failure for lstQLIupdate='+e.getMessage());
                 e.getMessage();
             }
             lstQLIupdate = new List<QuoteLineItem>(); 
          }
          
        checkRecursive.isRenewalOpp = true;
        checkRecursive.isRenewalQuote = true;
        checkRecursive.isRenewalOLI = true; 
        checkRecursive.isRenewalQLI = true; 
        checkRecursive.isRenewalOLIInsert = true;
        checkRecursive.isRenwlQLINotUpdt = true;
   }
       
   public static void SyncQuoteLIValueFromOppLIonInsert(List<QuoteLineItem> newQLIs){
        set<Id> UpdatedQuote = new set<Id>();
        Map<String,QuoteLineItem> QuoteLineItemToProductMap =  new Map<String,QuoteLineItem>();
        Map<String,ID> quoteToOppMap = new Map<String,id>();
        Map<String,OpportunityLineItem> OppLineItemToProductMap = new Map<String,OpportunityLineItem>();
        Map<String,Id> OppLineItemAndOppMap =  new Map<String,Id>();
        String OpportunityLineItemId = '';
        List<id> QLIOppIdList =  new List<id>();
         
        try{
            for(QuoteLineItem QLI: newQLIs){
                UpdatedQuote.add(QLI.quoteid); 
                QuoteLineItemToProductMap.put(QLI.Product2Id+''+QLI.MOLI_id__c,QLI);//SFD-1121 Changing the key [Rajashree] 
            }
            system.debug('UpdatedQuote : '+UpdatedQuote); 
            system.debug('QuoteLineItemToProductMap : '+QuoteLineItemToProductMap); 
            
            List<Quote> QuoteDetailList = [Select id,Opportunityid,Primary_Quote__c from Quote where ID IN: UpdatedQuote];       
            system.debug('QuoteDetailList : '+QuoteDetailList ); 
             
            for(Quote qote: QuoteDetailList ){
                quoteToOppMap .put(qote.id,qote.Opportunityid);
                QLIOppIdList.add(qote.Opportunityid);
            }
            //system.debug('QLIDetailMap : '+QLIDetailMap.size()); 
            system.debug('QLIOppIdList : '+QLIOppIdList); 
             
            // Create Map of Product and Opportunity Line Item
            List<OpportunityLineItem> OLIList = [Select Id,quantity,MOLI_id__c,Activity_Type__c,Active_Status__c,Annual_Price__c,unitprice,discount,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,Description,Revenue_Type__c,OpportunityId,Product2Id from OpportunityLineItem where OpportunityId=: QLIOppIdList];
            system.debug('OLIList..'+OLIList); 
            for(OpportunityLineItem OppLI : OLIList){
                OppLineItemToProductMap.put(OppLI.product2Id+''+OppLI.MOLI_id__c,OppLI); //SFD-1121 Changing the key [Rajashree]
                OppLineItemAndOppMap.put(OppLI.product2Id+''+OppLI.MOLI_id__c,OppLI.OpportunityId);//SFD-1121 Changing the key [Rajashree]   
            }
             
            system.debug('OppLineItemToProductMap::'+OppLineItemToProductMap);
             
            for(QuoteLineItem LI: newQLIs){
            
                system.debug('OpportunityLineId__c::'+LI.OpportunityLineId__c);
                OpportunityLineItemId = !string.isEmpty(LI.OpportunityLineId__c) ? LI.OpportunityLineId__c.left(15) : null;
                if(OppLineItemToProductMap.containsKey(LI.Product2Id+''+OpportunityLineItemId)){   
                system.debug('OppLineItemToProductMap.containsKey(LI.Product2Id+LI.MOLI_id__c)::'+OppLineItemToProductMap.containsKey(LI.Product2Id+''+LI.OpportunityLineId__c));
                system.debug('(LI.Product2Id+LI.MOLI_id__c)::'+LI.Product2Id+LI.MOLI_id__c);            
                 OpportunityLineItem OppLI = OppLineItemToProductMap.get(LI.Product2Id+''+OpportunityLineItemId); 
                    if(OppLI.OpportunityID == quoteToOppMap.get(LI.QuoteID)){
                        system.debug('LI.Revenue_Type__c::'+LI.Revenue_Type__c );
                        LI.Revenue_Type__c = OppLI.Revenue_Type__c ;
                        LI.Number_of_Contacts__c = OppLI.Number_of_Contacts__c ;
                        LI.Incremental_Amount__c = OppLI.Incremental_Amount__c ;
                        LI.Renewal_Amount__c = OppLI.Renewal_Amount__c ;
                        LI.Monthly_Charge__c = OppLI.Monthly_Charge__c ;
                        LI.Surcharge_Prct__c = OppLI.Surcharge_Prct__c ;
                        LI.Discount = OppLI.Discount; 
                        LI.Annual_Price__c = OppLI.Annual_Price__c; 
                        LI.Item_Activity_Type__c = OppLI.Activity_Type__c; 
                        System.debug('@@@OppLI.Active_Status__c'+OppLI.Active_Status__c);
                        LI.Status__c= OppLI.Active_Status__c;
                        System.debug('@@@LI.Status__c'+LI.Status__c);
                        system.debug('$$$OppLI.MOLI_id__c'+OppLI.MOLI_id__c);
                        LI.MOLI_id__c= OppLI.MOLI_id__c;
                        system.debug('$$$LI.MOLI_id__c'+LI.MOLI_id__c);
                    }  
                }
            }
            system.debug('$$$UpdateOppLineItemList'+newQLIs);
             
        }catch(Exception e){
            System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
        }  
    }
}