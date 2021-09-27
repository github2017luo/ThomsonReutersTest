/*
===============================================================================
OpportunityLineItemTriggerHandler
===============================================================================

PURPOSE: Trigger Handler Class for OpportunityProducts     

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2012-04-05     Partha                 Created 
2013-07-14     Anshita                Added 'deleteOppProdDetails' method   
2015-06-17     Prathyush              Added 'errorForNewOpportunities' method  
2016-06-22     Rajashree              Added 'afterUpdateProductsSync' method
2016-07-12     Rajashree              Added 'afterUpdateRenewalProductsSync' method
2016-07-20     Rajashree              Added 'RenewalOLISyncOnInsert' method
2016-02-01     Rajesh                 Added 'syncOLIToOLIClone' method
===============================================================================
*/

Public class OpportunityLineItemTriggerHandler{
    
    public static Boolean updateRenewal_IncrAmounts_methodCalled = false;
    public static Boolean syncOpptytoQuote_methodcalled = false;
    public static Map<id,string> OLICurrencyCodeMap= new Map<id,string>(); //LatAm SFD-512
    public static boolean isInsert;//LatAm SFD-512
    public static boolean checkRecur_syncOLIToOLIClone = false;//CRM-81 check recursive flag syncOLIToOLIClone method
    
    public static void updateRenewal_IncrAmounts(Set<Id> setOpportunityLineItemId){
     // if(checkRecursive.isRenewalOLIInsert != true && checkRecursive.isRenewalQLIInsert != true){ //[Rajashree] Added this as part of renewals, was getting called on OLI insert.  
        updateRenewal_IncrAmounts_methodCalled = true;
        Id ANZUsersProfileId = KeyValueListStore__c.getInstance('ANZUsersProfileId').TextValue__c;
        map<Id, OpportunityLineItem> mapOpportunityOwner = new map<Id, OpportunityLineItem>([SELECT Id, Incremental_Amount__c, Renewal_Amount__c, Revenue_Type__c, TotalPrice, Opportunity.Owner.ProfileId,currencyISOCode from OpportunityLineItem where id in :setOpportunityLineItemId]);

        List<OpportunityLineItem> listOppLineItems = new List<OpportunityLineItem>();
        for(OpportunityLineItem oOpportunityLineItem : mapOpportunityOwner.values()){
            if(oOpportunityLineItem.Revenue_Type__c == 'Renewal' && (oOpportunityLineItem.Opportunity.Owner.ProfileId == ANZUsersProfileId || oOpportunityLineItem.Renewal_Amount__c==null || oOpportunityLineItem.Renewal_Amount__c==0)) {
                oOpportunityLineItem.Renewal_Amount__c = oOpportunityLineItem.TotalPrice;
                //oOpportunityLineItem.Incremental_Amount__c = 0;
                listOppLineItems.add(oOpportunityLineItem);
            }
            else if(oOpportunityLineItem.Revenue_Type__c == 'Incremental' && oOpportunityLineItem.Opportunity.Owner.ProfileId == ANZUsersProfileId){
                //oOpportunityLineItem.Renewal_Amount__c = 0;
               oOpportunityLineItem.Incremental_Amount__c = oOpportunityLineItem.TotalPrice;
               listOppLineItems.add(oOpportunityLineItem); 
            }           
        }
        if(!listOppLineItems.isEmpty()){
            update listOppLineItems;
        }
        
        //SFD-512
        if(isInsert){
            List<OpportunityLineItem> OLIList= new List<OpportunityLineItem>();
            OLIList.addAll(mapOpportunityOwner.values());           
            getCurrencydecimalPlaces(OLIList,true);
        }
        //Ends SFD-512
    // }
    }
    
   
    
    public static void deleteOppProdDetails(List<OpportunityLineItem> listOppLineItems){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
      //  if(profileName != 'Latam User') {  // Commented this old code for Proview Tokenisation Project's CR
      // Considering the logic is applicable for the below three profiles [Proview Tokenisation Project's CR]
       if(profileName != 'Latam User' || profileName != 'System Administrator' || profileName != 'Partner Portal User') {
        Set<String> setOppLineItemIds = new Set<String>();
        for(OpportunityLineItem oOppLineItem : listOppLineItems){
          //  setOppLineItemIds.add(((String)oOppLineItem.ID).substring(0,15));            
           setOppLineItemIds.add((String)oOppLineItem.ID);
        }
        System.debug('***setOppLineItemIds'+ setOppLineItemIds);
        list<OpportunityProductDetail__c> listOppProductDetail = [select id from OpportunityProductDetail__c where Opportunity_Line_Item_Id__c in :setOppLineItemIds];
        System.debug('***listOppProductDetail'+ listOppProductDetail);
        if(!listOppProductDetail.isEmpty()){
            delete listOppProductDetail;
        }
        }
    }
    
    public static void updateOppRenewal_IncrAmounts(map<Id, OpportunityLineItem> mapOpportunityLineItem, List<Id> ListOppIds){
    //if(checkRecursive.isRenewalOLIInsert != true){  // [Rajashree] This method was getting called on after insert OLI, stopping this for Renewals.
        Set<String> sANZSalesOrgs = new Set<String>{'LRA','BKRS','SMHK'};
        //collect opp Ids
        if(ListOppIds == null){
            ListOppIds = new List<Id>();
        }
        if(mapOpportunityLineItem !=null){
            for(OpportunityLIneItem oOppLineItem : mapOpportunityLineItem.values()){
                ListOppIds.add(oOppLineItem.OpportunityId);
            }
        }
        Id ANZUsersProfileId = KeyValueListStore__c.getInstance('ANZUsersProfileId').TextValue__c;
        Map<Id,Opportunity> mapANZOpportunities = new Map<Id, Opportunity>([select Id, Owner.ProfileId, Selling_Organization__c
            , Renewal_Flag__c 
            , Total_Incremental__c
            , Total_Renewal__c
            , (Select Id, Incremental_Amount__c, Renewal_Amount__c from OpportunityLIneitems) 
            from Opportunity where Id in :ListOppIds and Override_Revenue_Amounts__c = false]);

        List<Opportunity> listOpportunities = new List<Opportunity>();
        
        for(Opportunity oOpportunity : mapANZOpportunities.Values()){
            if((oOpportunity.Renewal_Flag__c && sANZSalesOrgs.contains(oOpportunity.Selling_Organization__c))||(oOpportunity.Owner.ProfileId == ANZUsersProfileId && !oOpportunity.Renewal_Flag__c)) {
                OpportunityUtil.RevenueAmounts oCurrentAmounts = new OpportunityUtil.RevenueAmounts(oOpportunity);
                OpportunityUtil.RevenueAmounts oRevenueAmounts = rollUpRevenueAmounts(oOpportunity.OpportunityLineItems);
                if (oCurrentAmounts.match(oRevenueAmounts) == false) {
                    Opportunity oOpportunityUpdate = new Opportunity(Id=oOpportunity.Id);
                    oOpportunityUpdate.Total_Renewal__c = oRevenueAmounts.TotalRenewalAmount;
                    oOpportunityUpdate.Total_Incremental__c = oRevenueAmounts.TotalIncrementalAmount;
                    
                    listOpportunities.add(oOpportunityUpdate);
                }
            }
        }
        system.debug('listOpportunities:'+listOpportunities);
        if(!listOpportunities.isEmpty()){
            update listOpportunities;
        }
    // }
    }
    private static OpportunityUtil.RevenueAmounts rollUpRevenueAmounts(List<OpportunityLineItem> listOpportunityLineItems) {
        OpportunityUtil.RevenueAmounts oRevenueAmounts = new OpportunityUtil.RevenueAmounts();
        
        if (listOpportunityLineItems != null && listOpportunityLineItems.isEmpty() == false) {
            for (OpportunityLineItem oOpportunityLineItem : listOpportunityLineItems) {
                oRevenueAmounts.TotalRenewalAmount += AppUtil.isNull(oOpportunityLineItem.Renewal_Amount__c, 0);
                oRevenueAmounts.TotalIncrementalAmount += AppUtil.isNull(oOpportunityLineItem.Incremental_Amount__c, 0);
            }
        }
        
        return oRevenueAmounts;
    }  
   
    
    
    public static void errorForNewOpportunities(List<OpportunityLineItem> opptyLineItems){
        
        set<Id> priceBookIds = new set<Id>();
        set<Id> OpptyIds = new set<Id>();
        
        for(OpportunityLineItem opp: opptyLineItems){
            priceBookIds.add(opp.PriceBookEntryId);
            OpptyIds.add(opp.OpportunityId);
        }
         Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        /* Commented out as part of LatAm stabilization
        if(profileName == 'Latam User') {
        list<PriceBookEntry> pbList= [SELECT Id, 
                                             Product2Id, PriceBook2.Name
                                             FROM priceBookEntry WHERE Id IN :priceBookIds];
        map<Id,Id> pbMap = new map<Id,Id>();
        map<Id, PriceBookEntry> pbEntryMap = new map<Id, PriceBookEntry>();
        
        for(PriceBookEntry pbe: pbList){
            pbMap.put(pbe.Id,pbe.Product2Id);
            pbEntryMap.put(pbe.Id,pbe);
        }
        
               
        list<Sales_Area_Product_Info__c> sapiList = [SELECT Id,
                                                            Product__c,
                                                            D_Chain_Material_Status__c FROM Sales_Area_Product_Info__c 
                                                                                       WHERE  Product__c IN: pbMap.values()];
        list<Opportunity> oppList = [SELECT Id,
                                            Renewal_Flag__c,
                                            toLabel(Sub_Category__c) FROM Opportunity Where Id IN: OpptyIds];
                                            
                                                                               
        for(OpportunityLineItem Oppty: opptyLineItems){
            for(Opportunity opp: oppList){ 
                if(Oppty.OpportunityId == opp.Id){
                    for(Sales_Area_Product_Info__c sapi: sapiList){
                   // system.debug('Price Book...'+pbEntryMap.get(Oppty.PriceBookEntryId).PriceBook2.Name);
                        if(pbMap.get(Oppty.PriceBookEntryId) == sapi.Product__c && 
                            pbEntryMap.get(Oppty.PriceBookEntryId).PriceBook2.Name == 'LLEY Price Book' ){
                        //    system.debug('yes');
                            System.debug('pbMap.get(Oppty.PriceBookEntryId)  :' +pbMap.get(Oppty.PriceBookEntryId) + 'sapi.Product__c: '+sapi.Product__c);
                            if(sapi.D_Chain_Material_Status__c == 'ZO'){
                                if(opp.Renewal_Flag__c == FALSE && opp.Sub_Category__c != System.Label.SubCategory){
                                    Oppty.addError(System.Label.MaterialStatus);
                                }
                            }
                        }
                    }
                }
            }
        }
      } */ 
    }
    
     public static void SyncOppLineItemToQuoteLineItem(List<OpportunityLineItem> opptyLineItems, Map<Id, OpportunityLineItem> oldOppLineItemMap){

        syncOpptytoQuote_methodcalled = true; // Indu
        //if(checkRecursive.isRenewalOLI != true &&  checkRecursive.isRenewalOLIInsert != true){     // Shouldnot be called for renewals, 
                                                 // these fields are synced using 'afterUpdateRenewalProductsSync' method for renewals  [ Rajashree]
        Map<String,QuoteLineItem> QuoteLineItemToProductMap =  new Map<String,QuoteLineItem>();
        List<id> QuoteItemIdList = new List<id>();
        Set<id> OpportunityIdList = new Set<id>();
        List<QuoteLineItem> UpdateQuoteLineItem  = new List<QuoteLineItem>();
        Map<String,OpportunityLineItem> OppLineItemToProductMap = new Map<String,OpportunityLineItem>();
        Map<String,Id> OppLineItemAndOppMap=  new Map<String,Id>();
        try{
            for(OpportunityLineItem OppLI: opptyLineItems){
                 If(OppLI.quantity != oldOppLineItemMap.get(OppLI.Id).quantity || OppLI.unitprice != oldOppLineItemMap.get(OppLI.Id).unitprice 
                 ||OppLI.discount != oldOppLineItemMap.get(OppLI.Id).discount ||OppLI.Revenue_Type__c != oldOppLineItemMap.get(OppLI.Id).Revenue_Type__c || OppLI.Number_of_Contacts__c  != oldOppLineItemMap.get(OppLI.Id).Number_of_Contacts__c || OppLI.Incremental_Amount__c != oldOppLineItemMap.get(OppLI.Id).Incremental_Amount__c ||
                      OppLI.Renewal_Amount__c != oldOppLineItemMap.get(OppLI.Id).Renewal_Amount__c || OppLI.Monthly_Charge__c != oldOppLineItemMap.get(OppLI.Id).Monthly_Charge__c || OppLI.Surcharge_Prct__c != oldOppLineItemMap.get(OppLI.Id).Surcharge_Prct__c || OppLI.Annual_Price__c  != oldOppLineItemMap.get(OppLI.Id).Annual_Price__c ){
                     
                      system.debug('values that chnage::new op li'+OppLI+';;old Opp LI::'+oldOppLineItemMap.get(OppLI.Id));
                      OpportunityIdList.add(OppLI.Opportunityid); 
                      system.debug('OpportunityList::'+OpportunityIdList);
                      OppLineItemToProductMap.put(OppLI.Product2Id+''+OppLI.id,OppLI); //SFD-1121 Changing the key [Rajashree]
                      OppLineItemAndOppMap.put(OppLI.product2Id+''+OppLI.id,OppLI.OpportunityId);//SFD-1121 Changing the key [Rajashree]   
                 }
             }
             
             if(OpportunityIdList!=null && OpportunityIdList.size()>0){
                 // Create Map of Product and Quote Line Item
                 List<QuoteLineItem> QuoteLIList = [Select id,quantity,MOLI_id__c,OpportunityLineId__c,unitprice,discount,QuoteId,Quote.OpportunityId,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,Description,Revenue_Type__c,Product2Id,Quote.Opportunity.All_Quote_Count__c,Quote.Opportunity.LatAm_Standardization_Quotes__c,Annual_Price__c From QuoteLineItem WHERE Quote.opportunityID IN: OpportunityIdList AND Quote.Primary_Quote__c=: True and quote.issyncing = true];
                 
                 system.debug('QuoteLIList ::'+QuoteLIList );
                 for(QuoteLineItem QuoteLI: QuoteLIList){
                     QuoteLineItemToProductMap.put(QuoteLI.Product2Id+''+QuoteLI.OpportunityLineId__c,QuoteLI); //SFD-1121 Changing the key [Rajashree]
                    // OpportunityIdList.add(QuoteLI.Quote.OpportunityId);
                 }
                 
                 for(QuoteLineItem QLItem : QuoteLIList){
                     system.debug('Indide LOOP ::');
                     if(OppLineItemToProductMap.containsKey(QLItem.Product2Id+''+QLItem.OpportunityLineId__c)){ 
                         system.debug('Second step Indide LOOP ::'+OppLineItemToProductMap.get(QLItem.Product2Id+''+QLItem.OpportunityLineId__c));
                         if(OppLineItemAndOppMap.get(QLItem.Product2Id+''+QLItem.OpportunityLineId__c) == QLItem.Quote.OpportunityId){
                             system.debug('Third step Indide LOOP ::');
                             OpportunityLineItem OppLineItem = OppLineItemToProductMap.get(QLItem.Product2Id+''+QLItem.OpportunityLineId__c);
                             System.debug('test approval : '+Approval.isLocked(QLItem.QuoteId));
                             if(Approval.isLocked(QLItem.QuoteId)){
                                 OppLineItem.addError(System.label.Validation_LockOpportunityWhileQuoteBeingApproved);
                                 continue;
                             }
                             QLItem.Revenue_Type__c = OppLineItem.Revenue_Type__c ;
                             QLItem.Number_of_Contacts__c = OppLineItem.Number_of_Contacts__c ;
                             QLItem.Incremental_Amount__c = OppLineItem.Incremental_Amount__c ;
                            // QLItem.Description = OppLineItem.Description ;
                             QLItem.Renewal_Amount__c = OppLineItem.Renewal_Amount__c;
                             //QLItem.Monthly_Charge__c = OppLineItem.Monthly_Charge__c ;
                             QLItem.Surcharge_Prct__c = OppLineItem.Surcharge_Prct__c ;
                             QLItem.quantity = OppLineItem.quantity; //Commented on 23-Aug-2016 SFD-856
                             QLItem.unitprice = OppLineItem.unitprice; //Commented on 23-Aug-2016 SFD-856
                             QLItem.discount = OppLineItem.discount; //Commented on 23-Aug-2016 SFD-856  
                             QLItem.Annual_Price__c = OppLineItem.Annual_Price__c;
                             //QLItem.MOLI_id__c = OppLineItem.MOLI_id__c;
                             UpdateQuoteLineItem.add(QLItem);
                         }    
                     }    
                 }
                 system.debug('UpdateQuoteLineItem::'+UpdateQuoteLineItem);
                 if(UpdateQuoteLineItem.size()>0)
                     Update UpdateQuoteLineItem;
                 system.debug('After UpdateQuoteLineItem::'+UpdateQuoteLineItem);
             }
         }
         catch(Exception e){
             System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
         } 
      //}
    } 
    /***** To get Opportunity currency decimal places from Currency Type ******
    ****** Method Name: getcurrencyDecimalPlaces ******************************
    Author: Harika Date: 27-01-2016 *******************************************/
    public static void getCurrencydecimalPlaces(List<OpportunityLineItem> newList, Boolean isAfter){
     //if(checkRecursive.isRenewalQLIInsert != true &&  checkRecursive.isRenewalOLIInsert != true && checkRecursive.isRenewalQLI != true && checkRecursive.isRenewalOLI != true){ //[Rajashree] Added this as part of renewals, was getting called on OLI insert.
        try{
            List<currencyType> cuuenrcyTypeLst= [SELECT ISOCOde,DecimalPlaces FROM CurrencyType WHERE IsActive=TRUE];
            Map<String,Integer> CurrencyDecimalMap= new Map<string,Integer>();
            if(cuuenrcyTypeLst!= null && cuuenrcyTypeLst.size() >0){
                for(currencyType ct:cuuenrcyTypeLst){
                    CurrencyDecimalMap.put(ct.ISOCOde,ct.DecimalPlaces);
                }
            }
            List<OpportunityLineItem> olitoInsertLst= new List<OpportunityLineItem>();
            if(!newList.isEmpty()){
                for(OpportunityLineItem oli:newList ){
                    system.debug('****CurrencyDecimalMap::' + oli.currencyISOCode + ' '+ CurrencyDecimalMap.get(oli.currencyISOCode));
                    if(CurrencyDecimalMap != null && CurrencyDecimalMap.get(oli.currencyISOCode) != null)
                        oli.Decimal_Places_for_Currency__c = CurrencyDecimalMap.get(oli.currencyISOCode);
                    else
                        oli.Decimal_Places_for_Currency__C = 2;   
                    system.debug('****Decimal_Places_for_Currency__c::' +oli.Decimal_Places_for_Currency__c);   
                    if(isAfter)
                        olitoInsertLst.add(oli);        
    
                }
                
                if(!olitoInsertLst.isEmpty() && isAfter){
                    Update olitoInsertLst;
                }
            
            }
        }catch(Exception ex)
        {
            system.debug('***Exception occured getCurrencydecimalPlaces() ::' + ex.getMEssage());
        }
     // }
    }
    /**********************************************************************************************************************************
        Purpose : Add eror while user adds 4th product in Split Billing
        Method Name : LatamProductCheck
        Author : TCS Offshore
        Date : 2016-06-23
        
  ***********************************************************************************************************************************/
    public static void LatamProductCheck (List<OpportunityLineItem> newListOLI) {
    // if(checkRecursive.isRenewalOLI != true &&  checkRecursive.isRenewalOLIInsert != true){ //[Rajashree] Added this as part of renewals, was getting called on OLI insert.     
        Map<Id,Integer> mapOLIOptyId = new Map<Id,Integer>();
        Set<id> setOpportunityID = new Set<ID>();
        for(OpportunityLineItem objOLI : newListOLI) {
            setOpportunityID.add(objOLI.OpportunityID);
        }
        if(setOpportunityID!=null && setOpportunityID.size()>0){
            Opportunity objOpp = [SELECT id, Oppty_Mgmt_Type__c FROM Opportunity WHERE id IN: setOpportunityID Limit 1];
            if(objOpp.Oppty_Mgmt_Type__c == 'Split Billing'){
                AggregateResult[] lstOppLnItm = [SELECT OpportunityId, Count(Id) count1, Opportunity.Oppty_Mgmt_Type__c
                                                 FROM OpportunityLineItem 
                                                 WHERE OpportunityId in: setOpportunityID 
                                                 GROUP BY OpportunityId,  Opportunity.Oppty_Mgmt_Type__c
                                                 HAVING Opportunity.Oppty_Mgmt_Type__c =: 'Split Billing']; // HAVING Count(Id)>= 3
                                                 
                System.Debug('***********lstOppLnItm='+lstOppLnItm);
                if(lstOppLnItm != null && lstOppLnItm.size() > 0){
                    For(AggregateResult ar : lstOppLnItm){
                        mapOLIOptyId.put((Id)ar.get('OpportunityId'), (Integer)ar.get('count1'));
                    }
                }
                system.debug('***********aggregate product'+mapOLIOptyId);
                system.debug('***********OLI newListOLI'+newListOLI);
                For(OpportunityLineItem objOLI: newListOLI) {
                    system.debug('***********OLI Oppty Mgmt Type='+objOpp.Oppty_Mgmt_Type__c);
                        if(mapOLIOptyId.get(objOLI.OpportunityId) != null){
                            mapOLIOptyId.put(objOLI.OpportunityId, mapOLIOptyId.get(objOLI.OpportunityId)+1);
                        }
                        else{
                            mapOLIOptyId.put(objOLI.OpportunityId, 1);
                        }
                        system.debug('***********aggregate product after addition='+mapOLIOptyId);
                        if(mapOLIOptyId.get(objOLI.OpportunityId) > 3) {
                            objOLI.addError(label.LatAm_SplitBillingFourthProduct);
                        }
                }
            }
        }
    //  }
    }
 /**********************************************************************************************************************************
        Purpose : To update child opportunities' products when master opportunities' products are updated(BRS_MS7.1.18,BRS_MS7.1.26)
        Method Name : afterUpdateProductsSync
        Author : Rajashree
        Date : 2016-06-23
        
  ***********************************************************************************************************************************/
 public static void afterUpdateProductsSync(Map<id,OpportunityLineItem> newMapTrigger, Map<id,OpportunityLineItem> oldMapTrigger ){
                
    if(checkRecursive.isOLISync == true){
        try{
            set<Id> setOppId = new set<Id>();
            set<String> setMaterialNumber= new set<String>();
            map<String,OpportunityLineItem> mapOppOLI =new map<String,OpportunityLineItem>();
            map<id,id> mapChildMaster = new  map<id,id>();
            Boolean boolChckOpp = false;
            Boolean boolChckQuo = false;
            List<OpportunityLineItem> lstUpdateOppLI = new List<OpportunityLineItem>();
            List<OpportunityLineItem> lstobjOppLI = new List<OpportunityLineItem>();
             List<QuoteLineItem> lstUpdateQLI = new List<QuoteLineItem>();  
             System.debug('@@@@@ newMapTrigger.values()'+newMapTrigger.values());   
            for(OpportunityLineItem op : newMapTrigger.values()){
                if(oldMapTrigger.get(op.id).Product2.Id != newMapTrigger.get(op.id).Product2.Id
           //    || oldMapTrigger.get(op.id).ListPrice!= newMapTrigger.get(op.id).ListPrice
           //    || oldMapTrigger.get(op.id).Discount  != newMapTrigger.get(op.id).Discount 
               || oldMapTrigger.get(op.id).Surcharge_Prct__c != newMapTrigger.get(op.id).Surcharge_Prct__c 
               || oldMapTrigger.get(op.id).Monthly_Charge__c  != newMapTrigger.get(op.id).Monthly_Charge__c 
               || oldMapTrigger.get(op.id).Incremental_Amount__c  != newMapTrigger.get(op.id).Incremental_Amount__c 
               || oldMapTrigger.get(op.id).Renewal_Amount__c  != newMapTrigger.get(op.id).Renewal_Amount__c 
               || oldMapTrigger.get(op.id).Number_of_Contacts__c  != newMapTrigger.get(op.id).Number_of_Contacts__c 
               || oldMapTrigger.get(op.id).Description  != newMapTrigger.get(op.id).Description
               || oldMapTrigger.get(op.id).Activity_Type__c!= newMapTrigger.get(op.id).Activity_Type__c
               || oldMapTrigger.get(op.id).Active_Status__c!= newMapTrigger.get(op.id).Active_Status__c
               ){          
                    setOppId.add(op.OpportunityId);
                    setMaterialNumber.add(op.MOLI_id__c);//SFD-1121 Changing the value of set [Rajashree]
                    mapOppOLI.put(op.OpportunityId +''+op.MOLI_id__c,op);//SFD-1121 Changing the key [Rajashree]
               }
            }
            System.debug('@@@@@setOppId'+setOppId);
            System.debug('@@@@@setMaterialNumber'+setMaterialNumber);
            System.debug('@@@@@mapOppOLI'+mapOppOLI);
            
            List<Opportunity> tempOppList = new List<Opportunity>();
            if(setOppId!=null && setOppId.size()>0){
                tempOppList = [SELECT id,(SELECT id,RenewalCheck__c, Activity_Type__c,Active_Status__c, Opportunity.SyncedQuote.Pricing_Approval_Complete__c , Product2.Id, 
                                                ProductCode, Quantity, Description,Discount, Surcharge_Prct__c,
                                                Monthly_Charge__c, TotalPrice, OpportunityId,ListPrice,
                                                Incremental_Amount__c, Renewal_Amount__c, Number_of_Contacts__c,MOLI_id__c
                                                FROM OpportunityLineItems
                                                WHERE MOLI_id__c IN: setMaterialNumber),Master_opportunity__c, Is_Master_Opportunity__c
                                                FROM Opportunity where Master_opportunity__c IN: setOppId OR ID IN :setOppId];
            }
            System.debug('@@@@@tempOppList '+tempOppList);
            List<Opportunity> lstOppty = new List<Opportunity>();
            List<Opportunity> lstChldOppty = new List<Opportunity>();
            List<Opportunity> lstChildOpp = new List<Opportunity>();
            for(Opportunity tOpp : tempOppList){
                if(setOppId.Contains(tOpp.ID) && tOpp.Is_Master_Opportunity__c == true){
                    lstOppty.add(tOpp);
                }
                if(setOppId.Contains(tOpp.ID) && tOpp.Is_Master_Opportunity__c == false && tOpp.Master_Opportunity__c !=NULL){
                    lstChldOppty.add(tOpp);
                }
                if(setOppId.Contains(tOpp.Master_opportunity__c)){
                    lstChildOpp.add(tOpp);
                }
            }
             System.debug('@@@@@lstOppty'+lstOppty);
             System.debug('@@@@@lstChldOppty'+lstChldOppty);
            System.debug('@@@@@lstChildOpp'+lstChildOpp);
            //List<Opportunity> lstOppty = [SELECT id FROM Opportunity WHERE id IN: setOppId AND Is_Master_Opportunity__c = true];
            //List<Opportunity> lstChldOppty = [SELECT id FROM Opportunity WHERE id IN: setOppId AND Is_Master_Opportunity__c = False AND Master_Opportunity__c !=NULL];
           
            if(lstOppty!=null && !lstOppty.isEmpty() && setOppId!=null && !setOppId.isEmpty()){
                /*List<Opportunity> lstChildOpp =[SELECT id,(SELECT id,RenewalCheck__c, Activity_Type__c,Active_Status__c, Opportunity.SyncedQuote.Pricing_Approval_Complete__c , Product2.Id, 
                                                ProductCode, Quantity, Description,ListPrice, Discount, Surcharge_Prct__c,
                                                Monthly_Charge__c, TotalPrice, OpportunityId,
                                                Incremental_Amount__c, Renewal_Amount__c, Number_of_Contacts__c
                                                FROM OpportunityLineItems
                                                WHERE PricebookEntry.ProductCode IN: setMaterialNumber),Master_opportunity__c
                                                FROM Opportunity where Master_opportunity__c IN: setOppId];
              */                                  
              List<opportunityLineItem> lstOLI;
              if(lstChildOpp!=null && !lstChildOpp.isEmpty()){
                for(Opportunity op :lstChildOpp){    
                 
                    mapChildMaster.put(op.id,op.Master_opportunity__c);
                    lstOLI = op.OpportunityLineItems;
                    lstobjOppLI.addAll(op.OpportunityLineItems);       
                } 
              }
              System.debug('@@@@@lstobjOppLI'+lstobjOppLI);
                OpportunityLineItem objOppLI ;
              if( lstChildOpp!=null && !lstChildOpp.isEmpty()){
                  for(OpportunityLineItem op:lstobjOppLI){
                        objOppLI= new OpportunityLineItem();
                        objOppLI.id = op.id;
                        String masterOpp= mapChildMaster.get(op.OpportunityId);
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Product2.Id  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Product2.Id){ 
                           objOppLI.Product2.Id = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Product2.Id;
                           boolChckOpp= true;
                    }
                  /*  if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).ListPrice!= oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).ListPrice){
                          objOppLI.ListPrice= mapOppOLI.get(masterOpp+''+op.MOLI_id__c).ListPrice; 
                          boolChckOpp= true;              
                    }Field is not writeable
                    
                    */
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).MOLI_id__c!= oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).MOLI_id__c){
                          objOppLI.MOLI_id__c= mapOppOLI.get(masterOpp+''+op.MOLI_id__c).MOLI_id__c; 
                          boolChckOpp= true;              
                    }
               /*     if(newMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Discount != oldMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Discount){
                          objOppLI.Discount = mapOppOLI.get(masterOpp+op.ProductCode).Discount;
                          boolChckOpp= true;
                    } */
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Surcharge_Prct__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Surcharge_Prct__c ){
                          objOppLI.Surcharge_Prct__c = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Surcharge_Prct__c;
                           boolChckOpp= true;
                    }
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Monthly_Charge__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Monthly_Charge__c ){
                          objOppLI.Monthly_Charge__c = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Monthly_Charge__c;
                           boolChckOpp= true;
                    }
                 /*   if(newMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Storage_Location__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Storage_Location__c ){
                          objOppLI.Storage_Location__c = mapOppOLI.get(masterOpp+op.ProductCode).Storage_Location__c; 
                          boolChckOpp= true;                  
                    } */
                /*    if(newMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Shipping_Point__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Shipping_Point__c ){
                          objOppLI.Shipping_Point__c = mapOppOLI.get(masterOpp+op.ProductCode).Shipping_Point__c;  
                    } */
               /*     if(newMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Activity_Type__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+op.ProductCode).Id).Activity_Type__c ){
                          objOppLI.Activity_Type__c = mapOppOLI.get(masterOpp+op.ProductCode).Activity_Type__c;
                           boolChckOpp= true;
                    } */
                    
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Incremental_Amount__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Incremental_Amount__c ){
                          objOppLI.Incremental_Amount__c = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Incremental_Amount__c;
                           System.debug('aaaaaaa');
                           boolChckOpp= true;
                    }
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Renewal_Amount__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Renewal_Amount__c ){
                         objOppLI.Renewal_Amount__c = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Renewal_Amount__c;
                          System.debug('baaaaaaa');
                          boolChckOpp= true;
                    }
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Number_of_Contacts__c  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Number_of_Contacts__c ){
                          objOppLI.Number_of_Contacts__c = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Number_of_Contacts__c;
                          System.debug('caaaaaaa');
                           boolChckOpp= true;
                    }
                    if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Description  != oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Description ){
                         objOppLI.Description = mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Description;
                          boolChckOpp= true;
                    } 
                    
                     //  objOppLI.TotalPrice = mapOppOLI.get(masterOpp+op.ProductCode).TotalPrice;
                    //   objOppLI.Quantity = mapOppOLI.get(masterOpp+op.ProductCode).Quantity;
                    if(op.RenewalCheck__c == TRUE){
                        if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Activity_Type__c!= oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Activity_Type__c){
                              objOppLI.Activity_Type__c= mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Activity_Type__c; 
                              boolChckOpp= true;              
                        }
                        if(newMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Active_Status__c!= oldMapTrigger.get(mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Id).Active_Status__c){
                              objOppLI.Active_Status__c= mapOppOLI.get(masterOpp+''+op.MOLI_id__c).Active_Status__c; 
                              boolChckOpp= true;              
                        }
                        
                    }
                    If(boolChckOpp == true){                    
                          lstUpdateOppLI.add(objOppLI);
                    }
                  }
              }
            }
             System.Debug('@@@@@@@@@@@@@@@@@ ListChildOppty'+ lstChldOppty);  
            if(lstChldOppty!=null && !lstChldOppty.isEmpty() && setOppId!=null && !setOppId.isEmpty() ){
                List<Quote> lstChldQuote = [SELECT id,(SELECT id, RenewalCheckQLI__c , Quote.Pricing_Approval_Complete__c , Product2.Id,QuoteId, Product2.ProductCode, Quantity, Description,ListPrice,
                                                Discount, Surcharge_Prct__c, Monthly_Charge__c, TotalPrice,
                                                Incremental_Amount__c, Renewal_Amount__c, Number_of_Contacts__c,MOLI_id__c
                                            FROM QuoteLineItems
                                            WHERE MOLI_id__c IN: setMaterialNumber),OpportunityId
                                            FROM Quote where OpportunityId IN: setOppId AND Primary_Quote__c = TRUE AND Is_Master_Quote__c = False AND Master_Quote__c != NULL];
                                            
               System.Debug('@@@@@@@@@@@@@@@@@ ListChildQuote'+ lstChldQuote );                             
                //List<opportunityLineItem> lstChildOLI;
                Map<id,id> mapQuoOpp= new Map<id,id>();
                List<QuoteLineItem> lstobjQLI = new List<QuoteLineItem>();
                if(lstChldQuote!=null && !lstChldQuote.isEmpty()){
                    for(Quote quo:lstChldQuote){    
                        mapQuoOpp.put(quo.id,quo.OpportunityId);
                    //  lstChildOLI = quo.OpportunityLineItems;
                        lstobjQLI.addAll(quo.QuoteLineItems);       
                    }
                }        
                QuoteLineItem objQLI ;
                if(lstobjQLI!=null && !lstobjQLI.isEmpty()){
                    for(QuoteLineItem op: lstobjQLI){
                        objQLI= new QuoteLineItem();
                        objQLI.id = op.id;
                        String childQuo= mapQuoOpp.get(op.QuoteId);
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Product2.Id != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Product2.Id){
                          objQLI.Product2.Id = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Product2.Id;
                          boolChckQuo = true;
                        }
                  /*      if(newMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).UnitPrice != oldMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).UnitPrice){
                          objQLI.ListPrice = mapOppOLI.get(childQuo+op.Product2.ProductCode).UnitPrice;
                          boolChckQuo = true;
                        } not writeable */
                        
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Surcharge_Prct__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Surcharge_Prct__c){
                          objQLI.Surcharge_Prct__c = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Surcharge_Prct__c;
                          boolChckQuo = true;
                        }
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).MOLI_id__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).MOLI_id__c){
                          objQLI.MOLI_id__c = mapOppOLI.get(childQuo+''+op.MOLI_id__c).MOLI_id__c;
                          boolChckQuo = true;
                        }
                     /*   if( newMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Storage_Location__c != oldMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Storage_Location__c){
                          objQLI.Storage_Location__c = mapOppOLI.get(childQuo+op.Product2.ProductCode).Storage_Location__c;
                          boolChckQuo = true;
                        } 
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Discount != oldMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Discount){
                          objQLI.Discount = mapOppOLI.get(childQuo+op.Product2.ProductCode).Discount;
                          boolChckQuo = true;
                        }*/
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Monthly_Charge__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Monthly_Charge__c){
                          objQLI.Monthly_Charge__c = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Monthly_Charge__c;
                          boolChckQuo = true;
                        }
                    /*    if(newMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Plant__c != oldMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Plant__c){
                          objQLI.Plant__c = mapOppOLI.get(childQuo+op.Product2.ProductCode).Plant__c; 
                          boolChckQuo = true;
                        } */
                    /*    if(newMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Shipping_Point__c != oldMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Shipping_Point__c){
                          objQLI.Shipping_Point__c = mapOppOLI.get(childQuo+op.Product2.ProductCode).Shipping_Point__c ;
                          boolChckQuo = true; 
                        } */
                     /*   if(newMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Item_Activity_Type__c != oldMapTrigger.get(mapOppOLI.get(childQuo+op.Product2.ProductCode).Id).Item_Activity_Type__c){
                          objQLI.Item_Activity_Type__c= mapOppOLI.get(childQuo+op.Product2.ProductCode).Activity_Type__c;
                          boolChckQuo = true;              
                        } */
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Incremental_Amount__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Incremental_Amount__c){
                          objQLI.Incremental_Amount__c = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Incremental_Amount__c;
                          boolChckQuo = true;
                        }
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Renewal_Amount__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Renewal_Amount__c){
                          objQLI.Renewal_Amount__c = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Renewal_Amount__c;
                          boolChckQuo = true;
                        }
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Number_of_Contacts__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Number_of_Contacts__c){
                          objQLI.Number_of_Contacts__c = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Number_of_Contacts__c;
                          boolChckQuo = true;
                        }
                        if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Description != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Description){
                          objQLI.Description = mapOppOLI.get(childQuo+''+op.MOLI_id__c).Description;
                          boolChckQuo = true;
                        }
                         
                        if(op.RenewalCheckQLI__c == TRUE){
                            if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Active_Status__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Active_Status__c){
                              objQLI.Status__c= mapOppOLI.get(childQuo+''+op.MOLI_id__c).Active_Status__c;
                              boolChckQuo = true;
                            }
                            if(newMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Activity_Type__c != oldMapTrigger.get(mapOppOLI.get(childQuo+''+op.MOLI_id__c).Id).Activity_Type__c){
                              objQLI.Item_Activity_Type__c= mapOppOLI.get(childQuo+''+op.MOLI_id__c).Activity_Type__c;
                              boolChckQuo = true;
                            }
                           
                        }
                        if(boolChckQuo == true){
                          lstUpdateQLI.add(objQLI);
                        }
                    }
                }
            }   
            if(lstUpdateOppLI!=null && !lstUpdateOppLI.isempty()){
                     //   checkRecursive.isOLISync = false;
                    Database.UPDATE(lstUpdateOppLI);
               //     checkRecursive.isOLISync = true;
            } 
            if(!lstUpdateQLI.isempty() && lstUpdateQLI != null ){
                    Database.UPDATE(lstUpdateQLI);
            } 
          
        }
        catch(Exception ex){
                 System.debug('Exception occured in OptyLineItemTriggerHandler, method afterUpdateProductsSync' + ex.getmessage() + 'line number'+ ex.getLinenumber());
        }
    }

 }
 /****************************************************************************************************************
        Purpose : To update Quotes' products when corresponding opportunities' products are updated(Renewals)
        Method Name : afterUpdateRenewalProductsSync
        Author : Rajashree
        Date : 2016-07-11
 
 *****************************************************************************************************************/
 public static void afterUpdateRenewalProductsSync(Map<id,OpportunityLineItem> newMapTrigger, Map<id,OpportunityLineItem> oldMapTrigger ){         
    if(userinfo.getProfileid() == Profile_List__c.getInstance('LatAm User').ProfileId__c ||
       userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c||
       userinfo.getProfileid() == Profile_List__c.getInstance('System Administrator').ProfileId__c
     ){
     
            checkRecursive.isRenewalQuote = false;
            checkRecursive.isRenewalOpp = false;
            checkRecursive.isRenewalQLI = false;
            checkRecursive.isRenewalQLIInsert = false;
            checkRecursive.isRenewalOLIInsert = false;
            Boolean boolChck = false;
            if(checkRecursive.isRenewalOLI == true){
                try{
                    set<Id> setOppId = new set<Id>();
                    set<String> setMaterialNumber= new set<String>();
                    map<String,OpportunityLineItem> mapOppOLI =new map<String,OpportunityLineItem>();
                    List<QuoteLineItem> lstUpdateQLI = new List<QuoteLineItem>();  
                     
                    for(OpportunityLineItem op : newMapTrigger.values()){
                        if(oldMapTrigger.get(op.id).Activity_Type__c != newMapTrigger.get(op.id).Activity_Type__c
                        ||oldMapTrigger.get(op.id).Discount != newMapTrigger.get(op.id).Discount
                        ||oldMapTrigger.get(op.id).Incremental_Amount__c != newMapTrigger.get(op.id).Incremental_Amount__c
                        ||oldMapTrigger.get(op.id).Last_Invoice_Price__c != newMapTrigger.get(op.id).Last_Invoice_Price__c
                        ||oldMapTrigger.get(op.id).Description  != newMapTrigger.get(op.id).Description 
                        ||oldMapTrigger.get(op.id).Number_of_Contacts__c  != newMapTrigger.get(op.id).Number_of_Contacts__c 
                    //  ||oldMapTrigger.get(op.id).Monthly_Charge_Calc__c!= newMapTrigger.get(op.id).Monthly_Charge_Calc__c
                        ||oldMapTrigger.get(op.id).Product2Id  != newMapTrigger.get(op.id).Product2Id 
                        ||oldMapTrigger.get(op.id).Projected_Renewal_Price__c  != newMapTrigger.get(op.id).Projected_Renewal_Price__c 
                        ||oldMapTrigger.get(op.id).Quantity != newMapTrigger.get(op.id).Quantity
                        ||oldMapTrigger.get(op.id).Quote_Item__c  != newMapTrigger.get(op.id).Quote_Item__c 
                        ||oldMapTrigger.get(op.id).Revenue_Type__c  != newMapTrigger.get(op.id).Revenue_Type__c 
                        ||oldMapTrigger.get(op.id).UnitPrice != newMapTrigger.get(op.id).UnitPrice
                        ||oldMapTrigger.get(op.id).Shipping_Point__c  != newMapTrigger.get(op.id).Shipping_Point__c 
                        ||oldMapTrigger.get(op.id).Subscription_Start_Date__c  != newMapTrigger.get(op.id).Subscription_Start_Date__c 
                        ||oldMapTrigger.get(op.id).Subscription_End_Date__c  != newMapTrigger.get(op.id).Subscription_End_Date__c 
                        ||oldMapTrigger.get(op.id).Active_Status__c != newMapTrigger.get(op.id).Active_Status__c
                        ||oldMapTrigger.get(op.id).Ship_To_Contact__c!= newMapTrigger.get(op.id).Ship_To_Contact__c
                        ||oldMapTrigger.get(op.id).Ship_To_Customer_Name__c!= newMapTrigger.get(op.id).Ship_To_Customer_Name__c
                        ||oldMapTrigger.get(op.id).Cancel_Comments__c!= newMapTrigger.get(op.id).Cancel_Comments__c
                        ||oldMapTrigger.get(op.id).Cancel_Date__c!= newMapTrigger.get(op.id).Cancel_Date__c    
                        ||oldMapTrigger.get(op.id).Cancel_Reason__c!= newMapTrigger.get(op.id).Cancel_Reason__c
                        ||oldMapTrigger.get(op.id).Storage_Location__c!= newMapTrigger.get(op.id).Storage_Location__c
                        ||oldMapTrigger.get(op.id).Annualized_Base_Price__c!= newMapTrigger.get(op.id).Annualized_Base_Price__c
                        ||oldMapTrigger.get(op.id).Bill_To_Contact__c!= newMapTrigger.get(op.id).Bill_To_Contact__c
                        ||oldMapTrigger.get(op.id).Reason_For_New_Product__c!= newMapTrigger.get(op.id).Reason_For_New_Product__c){ 
                            setOppId.add(op.OpportunityId);
                           // String OliId = op.id;
                          //  String subOliId = OliId.substring(0,15);
                            setMaterialNumber.add(op.id);  
                            mapOppOLI.put(op.OpportunityId +''+op.id ,op);//SFD-831 Changing the key [Rajashree]
                        }
                    }
                   // System.debug('1: mapOppOLI.put(op.OpportunityId +''+op.ProductCode+''+subOliId,op)'+mapOppOLI.put(op.OpportunityId +''+op.ProductCode+''+subOliId,op));
                    if( setOppId!=null && !setOppId.isEmpty() ){
                        List<Quote> lstQuote = [SELECT id,(SELECT id,OpportunityLineId__c,Item_Activity_Type__c ,Discount,Incremental_Amount__c, Last_Invoice_Price__c,
                                                    Description, Number_of_Contacts__c , Monthly_Charge__c ,Product2Id ,Product2.ProductCode,
                                                    Quantity, Quote_Item__c , Revenue_Type__c , UnitPrice , Shipping_Point__c ,Product2.Id,
                                                    Status__c, Subscription_Start_Date__c ,Projected_Renewal_Price__c,QuoteId, Cancel_Comments__c,
                                                    Cancel_Date__c, Cancel_Reason__c, Storage_Location__c,Ship_To_Contact__c, Ship_To_Customer_Name__c, Bill_To_Contact__c, Annualized_Base_Price__c,
                                                    Subscription_End_Date__c, Reason_For_New_Product__c FROM QuoteLineItems
                                                    WHERE OpportunityLineId__c IN: setMaterialNumber),OpportunityId
                                                    FROM Quote where OpportunityId IN: setOppId AND Primary_Quote__c = TRUE  AND
                                                    Opportunity.Renewal_Flag__c = TRUE AND Opportunity.RecordTypeId =:  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId() 
                                                    AND Opportunity.Master_Opportunity__c = NULL];
                        
                        Map<id,id> mapQuoOpp= new Map<id,id>();
                        List<QuoteLineItem> lstobjQLI = new List<QuoteLineItem>();
                        if( lstQuote!=null && !lstQuote.isEmpty() ){
                            for(Quote quo:lstQuote){    
                                mapQuoOpp.put(quo.id,quo.OpportunityId);
                                lstobjQLI.addAll(quo.QuoteLineItems);       
                            }
                        }
                        QuoteLineItem objQLI ;
                        if( lstobjQLI!=null && !lstobjQLI.isEmpty() ){
                            for(QuoteLineItem op: lstobjQLI){
                                objQLI= new QuoteLineItem();
                                objQLI.id = op.id;
                                
                                String Quo= mapQuoOpp.get(op.QuoteId);
                               // System.debug('2: mapOppOLI.get(Quo+''+op.OpportunityLineId__c)'+mapOppOLI.get(Quo+''+op.OpportunityLineId__c));
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Number_of_Contacts__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Number_of_Contacts__c ){
                                  objQLI.Number_of_Contacts__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Number_of_Contacts__c;
                                  boolChck = true;                                
                                }                    
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Activity_Type__c!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Activity_Type__c){
                                  objQLI.Item_Activity_Type__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Activity_Type__c; 
                                  boolChck = true;
                                }
                               
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Ship_To_Customer_Name__c!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Ship_To_Customer_Name__c){
                                  objQLI.Ship_To_Customer_Name__c= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Ship_To_Customer_Name__c; 
                                  boolChck = true;
                                }        
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Ship_To_Contact__c!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Ship_To_Contact__c){
                                  objQLI.Ship_To_Contact__c= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Ship_To_Contact__c; 
                                  boolChck = true;
                                } // SFD-911 
                               //if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Discount != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Discount){
                               //   objQLI.Discount = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Discount; 
                               //   boolChck = true;
                               // } 
                              if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Incremental_Amount__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Incremental_Amount__c){
                                  objQLI.Incremental_Amount__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Incremental_Amount__c;  
                                  boolChck = true;
                                } 
                                 if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Last_Invoice_Price__c!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Last_Invoice_Price__c){
                                  objQLI.Last_Invoice_Price__c= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Last_Invoice_Price__c; 
                                  boolChck = true;
                                }
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Description != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Description){
                                  objQLI.Description = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Description;
                                  boolChck = true;
                                }
                                                                        
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Product2Id != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Product2Id){
                                  objQLI.Product2Id = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Product2Id;
                                  boolChck = true;
                                } 
                           
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Projected_Renewal_Price__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Projected_Renewal_Price__c ){
                                  objQLI.Projected_Renewal_Price__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Projected_Renewal_Price__c;
                                  boolChck = true;
                                } 
             
                                //if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Quantity!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Quantity){
                                //  objQLI.Quantity= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Quantity;  
                                //  boolChck = true;
                                 
                                //} 
                               //Start SFD-856
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Quantity!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Quantity || newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).UnitPrice != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).UnitPrice || newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Discount != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Discount){
                                  objQLI.Quantity= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Quantity;  
                                  objQLI.UnitPrice = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).UnitPrice;
                                  objQLI.Discount = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Discount; 
                                  boolChck = true;                                 
                                  system.debug('SSSS1:'+objQLI.Quantity);
                                  system.debug('SSSS2:'+objQLI.UnitPrice);
                                }
                                //End SFD-856
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Quote_Item__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Quote_Item__c ){
                                  objQLI.Quote_Item__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Quote_Item__c ; 
                                  boolChck = true;
                                }
                               
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Revenue_Type__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Revenue_Type__c ){
                                  objQLI.Revenue_Type__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Revenue_Type__c; 
                                  boolChck = true;
                                }  
                                //if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).UnitPrice != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).UnitPrice ){
                               //   objQLI.UnitPrice = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).UnitPrice; 
                               //   boolChck = true;
                               // } 
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Shipping_Point__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Shipping_Point__c ){
                                  objQLI.Shipping_Point__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Shipping_Point__c; 
                                  boolChck = true;
                                }
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Subscription_Start_Date__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Subscription_Start_Date__c ){
                                  objQLI.Subscription_Start_Date__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Subscription_Start_Date__c; 
                                  boolChck = true;
                                }
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Subscription_End_Date__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Subscription_End_Date__c ){
                                  objQLI.Subscription_End_Date__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Subscription_End_Date__c; 
                                  boolChck = true;
                                }
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Active_Status__c!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Active_Status__c){
                                  objQLI.Status__c= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Active_Status__c; 
                                  boolChck = true;
                                }
                             // if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Material_Number__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Material_Number__c ){
                              //    objQLI.Material_Number__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Material_Number__c;
                              //    boolChck = true;
                              //}   
                             if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Annualized_Base_Price__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Annualized_Base_Price__c ){
                                  objQLI.Annualized_Base_Price__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Annualized_Base_Price__c; 
                                  boolChck = true;
                                } 
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Cancel_Date__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Cancel_Date__c){
                                  objQLI.Cancel_Date__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Cancel_Date__c; 
                                  boolChck = true;
                                } 
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Cancel_Comments__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Cancel_Comments__c){
                                  objQLI.Cancel_Comments__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Cancel_Comments__c; 
                                  boolChck = true;
                                } 
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Cancel_Reason__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Cancel_Reason__c){
                                  objQLI.Cancel_Reason__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Cancel_Reason__c; 
                                  boolChck = true;
                                } 
                               if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Storage_Location__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Storage_Location__c){
                                  objQLI.Storage_Location__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Storage_Location__c; 
                                  boolChck = true;
                                } 
                               
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id). Bill_To_Contact__c != oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Bill_To_Contact__c){
                                  objQLI.Bill_To_Contact__c = mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Bill_To_Contact__c; 
                                  boolChck = true;
                                } 
                                if(newMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Reason_For_New_Product__c!= oldMapTrigger.get(mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Id).Reason_For_New_Product__c){
                                  objQLI.Reason_For_New_Product__c= mapOppOLI.get(Quo+''+op.OpportunityLineId__c).Reason_For_New_Product__c; 
                                  boolChck = true;
                                }   //FRS 3.2.1.4  SFD-809 
                         /* Formula Fields    
                              if(newMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Net_New__c  != oldMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Net_New__c ){
                                  objQLI.Net_New__c = mapOppOLI.get(Quo+op.Product2.ProductCode).Net_New__c; 
                                } 
                             if(newMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Change_Actual_Projected__c != oldMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Change_Actual_Projected__c ){
                                  objQLI.Change_Actual_Projected__c = mapOppOLI.get(Quo+op.Product2.ProductCode).Change_Actual_Projected__c;
                                } 
                             if(newMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Product_Active__c != oldMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Product_Active__c ){
                                  objQLI.Product_Active__c = mapOppOLI.get(Quo+op.Product2.ProductCode).Product_Active__c;
                                 
                                } 
                             if(newMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Monthly_Charge_Calc__c!= oldMapTrigger.get(mapOppOLI.get(Quo+op.Product2.ProductCode).Id).Monthly_Charge_Calc__c){
                                  objQLI.Monthly_Charge_Calc__c= mapOppOLI.get(Quo+op.Product2.ProductCode).Monthly_Charge_Calc__c;
                              } */
                              if(boolChck == true){ 
                                lstUpdateQLI.add(objQLI);
                              }
                            }
                        }
                    } 
                    if(!lstUpdateQLI.isEmpty() && lstUpdateQLI != null ){
                        System.debug('*****lstUpdateQLI' + lstUpdateQLI);
                            Database.UPDATE(lstUpdateQLI);
                    } 
                } catch(Exception ex){
                         System.debug('Exception occured in OptyLineItemTriggerHandler, method afterUpdateProductsSync' + ex.getmessage() + 'line number'+ ex.getLinenumber());
                }
            }
          
            checkRecursive.isRenewalQuote = true;
            checkRecursive.isRenewalOpp = true;
            checkRecursive.isRenewalQLI = true;
            checkRecursive.isRenewalQLIInsert = true;
            checkRecursive.isRenewalOLIInsert = true;
       } 
 }
 /****************************************************************************************************************
        Purpose : To update certain custom fields of OLI when OLI is inserted on inserting QLI(Renewals)
        Method Name : RenewalOLISyncOnInsert
        Author : Rajashree
        Date : 2016-07-20
 
 *****************************************************************************************************************/

public static void RenewalOLISyncOnInsert(Map<Id, OpportunityLineItem> newOpportunityLineItemMap, List<OpportunityLineItem> lstnewTriggerOLI) {
          
        checkRecursive.isRenewalQuote = false;
        checkRecursive.isRenewalOpp = false;
        checkRecursive.isRenewalQLI = false;
        checkRecursive.isRenewalOLI = false;
        checkRecursive.isRenewalQLIInsert = false;
         checkRecursive.isRenwlQLINotUpdt = false;
        Boolean boolChck = false;
        if(checkRecursive.isRenewalOLIInsert == true){
             List<OpportunityLineItem> lstOLInew;
             List<OpportunityLineItem> lstOLIupdate = new List<OpportunityLineItem>();
             List<QuoteLineItem> lstQLI;
             Set<id> setQuoteId = new set<id>();
             Map<String, QuoteLineItem> mapQLI = new Map<String, QuoteLineItem>();
             Map<String, String> mapOpptyQuote = new Map<String, String>();       
             lstOLInew = [SELECT id, OpportunityId, Opportunity.SyncedQuoteId ,Ship_To_Contact__c, Product2Id, Reason_For_New_Product__c, Opportunity.Renewal_Flag__c, Opportunity.RecordTypeId 
                             FROM OpportunityLineItem
                             WHERE id IN: newOpportunityLineItemMap.keySet()
                             AND Opportunity.Renewal_Flag__c =: true
                             AND Opportunity.RecordTypeId =: Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId() 
                             AND Opportunity.Master_Opportunity__c = NULL];
            if(lstOLInew!=null && !lstOLInew.isEmpty()){
                 For(OpportunityLineItem oli: lstOLInew) {
                   //  String OliId = oli.id;
                   //  String subOliId = OliId.substring(0,15);
                        String subOliId = oli.id;
                     setQuoteId.add(oli.Opportunity.SyncedQuoteId);
                     mapOpptyQuote.put(oli.OpportunityId+''+subOliId , oli.Opportunity.SyncedQuoteId +''+subOliId); //SFD-831 Changing the key and value [Rajashree]
                }
            }
            if(setQuoteId!=null && !setQuoteId.isEmpty()){
                lstQLI = [SELECT id,OpportunityLineId__c, QuoteId ,Quantity, UnitPrice, Discount,Status__c,Annualized_Base_Price__c, Item_Activity_Type__c, Product2Id, Bill_To_Contact__c,
                             Bill_To_Customer_Name__c, Last_Invoice_Price__c,  Previous_Subscription_Number__c,Reason_For_New_Product__c,
                             Projected_Renewal_Price__c, Quote_Item__c, Revenue_Type__c , Shipping_Point__c,  Number_of_Contacts__c,
                             Ship_To_Customer_Name__c, Ship_To_Contact__c, Storage_Location__c, Subscription_End_Date__c, Subscription_Start_Date__c,Tax_Code__c 
                             FROM QuoteLineItem
                             WHERE QuoteId IN: setQuoteId 
                             AND Quote.Primary_Quote__c = TRUE
                             AND Quote.Renewal_Flag_Formula__c =: true
                             AND Quote.RecordTypeId =: Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId() 
                             AND Quote.Master_Quote__c = NULL];
            }            
          //   System.debug('************ lstQLI '+lstQLI.size());   
            if(lstQLI != null && !lstQLI.isEmpty()){            
                For(QuoteLineItem qli: lstQLI) {
                System.debug('$$$$$$$qli.OpportunityLineId__c'+ qli.OpportunityLineId__c);
                    mapQLI.put((qli.QuoteId +''+qli.OpportunityLineId__c), qli);//SFD-831 Changing the key
                }
            }
             //system.debug('########mapQLI='+mapQLI);
             OpportunityLineItem objOLI = new OpportunityLineItem();
             
             if(mapQLI != null && !mapQLI.isEmpty()){
                For(OpportunityLineItem oli: lstnewTriggerOLI){
                     //system.debug('########mapOpptyQuote get inside if='+mapOpptyQuote.get(qli.OpportunityId));
                     //system.debug('########mapQLI get inside if='+mapQLI.get(mapOpptyQuote.get(qli.OpportunityId)).Number_of_Contacts__c);
                     
                     objOLI = new OpportunityLineItem(id = oli.id); 
                    // String OliId = oli.id;
                    // String subOliId = OliId.substring(0,15);
                        String subOliId = oli.id;
                     if(mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)) != null){     
                      
                     System.debug('$$$ SubString OLI'+ subOliId );               
                         {
                         objOLI.Number_of_Contacts__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Number_of_Contacts__c;
                         boolChck = true;
                         }
                        {
                         objOLI.Reason_For_New_Product__c= mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Reason_For_New_Product__c;
                         boolChck = true;
                         }//FRS 3.2.1.4  SFD-809
                         {
                         objOLI.Ship_To_Contact__c= mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Ship_To_Contact__c;
                         boolChck = true;
                         }// SFD-911
                         {
                         objOLI.Annualized_Base_Price__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Annualized_Base_Price__c ;
                         boolChck = true;                            
                         }
                         {
                          objOLI.Quantity = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Quantity;
                          objOLI.UnitPrice = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).UnitPrice ;
                          objOLI.Discount = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Discount ;
                          boolChck = true;                                 
                         
                         }
                         
                         {
                         objOLI.Bill_To_Contact__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Bill_To_Contact__c ;
                         boolChck = true;
                         }
                        {
                        objOLI.Bill_To_Customer_Name__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Bill_To_Customer_Name__c ;
                        boolChck = true;
                        }                                   
                        {
                        objOLI.Last_Invoice_Price__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Last_Invoice_Price__c ;
                        boolChck = true;
                        }
                       // if(mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+oli.Product2Id+''+oli.id)).Material_Number__c != null){
                        //      objOLI.Material_Number__c = string.valueOf(mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+oli.Product2Id+''+oli.id)).Material_Number__c) ;
                        //      boolChck = true;
                       //  } 
                         {
                         objOLI.Previous_Subscription_Number__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Previous_Subscription_Number__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Projected_Renewal_Price__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Projected_Renewal_Price__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Quote_Item__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Quote_Item__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Revenue_Type__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Revenue_Type__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Shipping_Point__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Shipping_Point__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Ship_To_Customer_Name__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Ship_To_Customer_Name__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Storage_Location__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Storage_Location__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Subscription_End_Date__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Subscription_End_Date__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Subscription_Start_Date__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Subscription_Start_Date__c ;
                         boolChck = true;
                         }
                         {
                         objOLI.Tax_Code__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Tax_Code__c ;
                         boolChck = true;
                         }
                         //objOLI.Active_Status__c= mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Status__c;
                        {
                        objOLI.Activity_Type__c = mapQLI.get(mapOpptyQuote.get(oli.OpportunityId+''+subOliId)).Item_Activity_Type__c;
                        boolChck = true;
                        }     
                    }
                     //system.debug('########objOLI get inside if='+objOLI);
                    if(objOLI != null && boolChck == true){
                         lstOLIupdate.add(objOLI);
                    }
                }
            }
             //system.debug('########lstOLIupdate='+lstOLIupdate);
            try{
                 if(lstOLIupdate != null && !lstOLIupdate.isempty()){
                     Database.Update(lstOLIupdate);
                    // Update lstOLIupdate;
                 }
             } catch (Exception e){
                 //system.debug('########Update failure for lstOLIupdate='+e.getMessage());
                 e.getMessage();
            }
            lstOLIupdate = new List<OpportunityLineItem>(); 
        }
 
        checkRecursive.isRenewalQuote = true;
        checkRecursive.isRenewalOpp = true;
        checkRecursive.isRenewalQLI = true;
        checkRecursive.isRenewalOLI = true;
        checkRecursive.isRenewalQLIInsert = true;
        checkRecursive.isRenwlQLINotUpdt = true;
         
    }
  
   
    /************************************************************************************************************
        Purpose: To update the Subtotal amount in Billing Account while Opportunity Product is deleted, Delete 
                 Product from CHild Opportunity also
        Method Name: updateBillingAccountSubtotal
        Author: Debarghya Sen
        Date: 2016-06-30
        Defect: SFD-675
    ************************************************************************************************************/
    public static void updateBillingAccountSubtotal(List<OpportunityLineItem> lstdeleteOLI){
        
        system.debug('**********deleted MOLI:'+lstdeleteOLI);
        List<Billing_Account_Split__c> lstBillingAccount = new List<Billing_Account_Split__c>();
        List<Billing_Account_Split__c> lstBillingAccounttoUpdate = new List<Billing_Account_Split__c>();
        List<Opportunity> lstChildOppty = new List<Opportunity>();
        List<OpportunityLineItem> lstChildOpptyLineItem = new List<OpportunityLineItem>();
        Set<Id> setOppProdID = new Set<Id>();
        Set<Id> setOppID = new Set<Id>();
        Set<Id> setChildOppID = new Set<Id>();
        Set<String> setOLIID = new Set<String>();
        
        for(OpportunityLineItem objOLI: lstdeleteOLI){
            if(objOLI.Product2Id != null){
                setOppProdID.add(objOLI.Product2Id);
                setOppID.add(objOLI.OpportunityId);
                setOLIID.add(objOLI.MOLI_id__c);//SFD-1121
            }
        }
        
        system.debug('**********SET of MOLI:'+setOLIID);
        system.debug('**********SET of Oppty:'+setOppID);
        
        lstBillingAccount = [SELECT Id, Master_Opportunity__c, Product_1__c, Product_1_Sales_Price__c, 
                                    Product_1_Quantity__c, Product_2__c, Product_2_Sales_Price__c, Product_2_Quantity__c, 
                                    Product_3__c, Product_3_Sales_Price__c, Product_3_Quantity__c, 
                                    OLI_id_1__c, OLI_id_2__c, OLI_id_3__c
                            FROM Billing_Account_Split__c
                            WHERE Master_Opportunity__c IN: setOppID AND 
                                ((OLI_id_1__c IN: setOLIID) OR 
                                (OLI_id_2__c IN: setOLIID) OR 
                                (OLI_id_3__c IN: setOLIID))]; //SFD-1121
                                
        system.debug('************List of BAS:'+lstBillingAccount);
        
        For(OpportunityLineItem objOLIdel: lstdeleteOLI){
            For(Billing_Account_Split__c objBAS: lstBillingAccount){
                if(objBAS.OLI_id_1__c == objOLIdel.MOLI_id__c){
                    objBAS.Product_1__c = null;
                    objBAS.Product_1_Sales_Price__c = null;
                    objBAS.Product_1_Quantity__c = null;
                    objBAS.OLI_id_1__c = null;
                    lstBillingAccounttoUpdate.add(objBAS);
                }
                else if(objBAS.OLI_id_2__c == objOLIdel.MOLI_id__c){
                    objBAS.Product_2__c = null;
                    objBAS.Product_2_Sales_Price__c = null;
                    objBAS.Product_2_Quantity__c = null;
                    objBAS.OLI_id_2__c = null;
                    lstBillingAccounttoUpdate.add(objBAS);
                }
                else if(objBAS.OLI_id_3__c == objOLIdel.MOLI_id__c){
                    objBAS.Product_3__c = null;
                    objBAS.Product_3_Sales_Price__c = null;
                    objBAS.Product_3_Quantity__c = null;
                    objBAS.OLI_id_3__c = null;
                    lstBillingAccounttoUpdate.add(objBAS);
                }
            }
        }
        System.Debug('***********BAS update List='+lstBillingAccounttoUpdate);
        try{
            if(lstBillingAccounttoUpdate.size()>0){
                UPDATE lstBillingAccounttoUpdate;
            }
        } catch(Exception ex){
            System.debug('***********Exception in BAS update after Product deletion:'+ex.getMessage());
        }
        
        lstChildOppty = [SELECT id, Master_Opportunity__c 
                        FROM Opportunity
                        WHERE Master_Opportunity__c IN: setOppID AND Is_Child_Opportunity__c =: true];
                        
        For(Opportunity objChldOpp: lstChildOppty){
            setChildOppID.add(objChldOpp.id);
        }
        lstChildOpptyLineItem = [SELECT id, OpportunityId, Product2Id 
                                FROM OpportunityLineItem
                                WHERE OpportunityId IN: setChildOppID 
                                AND MOLI_id__c IN: setOLIID];
                                
        System.Debug('*****DEB******ChildOLI delete List='+lstChildOpptyLineItem);
        if(lstChildOpptyLineItem.size()>0){
            delete lstChildOpptyLineItem;
        }
        try{
            if(lstChildOpptyLineItem.size()>0){
                DELETE lstChildOpptyLineItem;
            }
        } catch(Exception ex){
            System.debug('***********Exception in COLI deletion after MOLI deletion:'+ex.getMessage());
        }
        
        
    } 
  
  //As part of MCL-1689
    public static void SyncOppLIValueFromQuoteLIonBeforeInsert(List<OpportunityLineItem> newOLIs){
    
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
        set<Id> UpdatedOpp = new set<Id>();
        Map<String,QuoteLineItem> QuoteLineItemToProductMap = new Map<String,QuoteLineItem>();
        
        system.debug('newOLIs:::'+newOLIs);
        try{
            for(OpportunityLineItem OLI: newOLIs){
                UpdatedOpp.add(OLI.Opportunityid); 
            }
            system.debug('UpdatedOpp : '+UpdatedOpp); 
            
            // Create Map of Product and Opportunity Line Item
            List<QuoteLineItem> QLIList = [Select Id,Item_Activity_Type__c,MOLI_id__c,Status__c,quantity,Annual_Price__c,unitprice,discount,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,OpportunityLineId__c,Description,Revenue_Type__c,QuoteId,Product2Id,Quote.OpportunityId 
                                                    from QuoteLineItem where Quote.OpportunityId=: UpdatedOpp
                                                    AND quote.Primary_Quote__c =: True 
                                                    and quote.issyncing =:true];
             
            for(QuoteLineItem QLI : QLIList){
                //if(!QuoteLineItemToProductMap.containsKey(QLI.Product2Id))
                QuoteLineItemToProductMap.put(QLI.Product2Id,QLI); 
            }
             
            system.debug('QuoteLineItemToProductMap::'+QuoteLineItemToProductMap);
            system.debug('newOLIs::'+newOLIs);
            
            for(OpportunityLineItem OppLI: newOLIs){
                if(QuoteLineItemToProductMap.containsKey(OppLI.Product2Id)){
                    
                    QuoteLineItem LI = QuoteLineItemToProductMap.get(OppLI.Product2Id); 
                    if(OppLI.OpportunityID == LI.Quote.OpportunityID){
                        System.debug('@@@@After Insert Getting Updated : OppLI.id'+OppLI.Product2Id+''+OppLI.id);
                        system.debug('LI.Revenue_Type__c::'+OppLI.Revenue_Type__c );
                        OppLI.Revenue_Type__c = LI.Revenue_Type__c ;
                        OppLI.Number_of_Contacts__c = LI.Number_of_Contacts__c ;
                        OppLI.Incremental_Amount__c = LI.Incremental_Amount__c ;
                        OppLI.Renewal_Amount__c = LI.Renewal_Amount__c ;
                        OppLI.Monthly_Charge__c = LI.Monthly_Charge__c ;
                        OppLI.Surcharge_Prct__c = LI.Surcharge_Prct__c ;
                        OppLI.Discount = LI.Discount; 
                        OppLI.Annual_Price__c = LI.Annual_Price__c; 
                        System.debug('@@@LI.Status__c'+LI.Status__c);
                        OppLI.Active_Status__c = LI.Status__c;
                        System.debug('@@@OppLI.Active_Status__c'+OppLI.Active_Status__c);
                        OppLI.Activity_Type__c = LI.Item_Activity_Type__c;
                        system.debug('$$$LI.MOLI_id__c'+LI.MOLI_id__c);
                        OppLI.MOLI_id__c= LI.MOLI_id__c;
                        system.debug('$$$OppLi.MOLI_id__c'+OppLi.MOLI_id__c);
                        lstOLI.add(OppLI);
                    }  
                }
            }
            system.debug('$$$UpdateOppLineItemList'+newOLIs);
          /*  if(lstOLI != NULL && !lstOLI.isEmpty()){
             UPDATE lstOLI ;                  
            }*/
             
        }catch(Exception e){
            System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
        }   
      
    }
  
  
   /* Calling this from after insert trigger instead of before insert : SFD-1121 [Rajashree] */
  public static void SyncOppLIValueFromQuoteLIonInsert(List<OpportunityLineItem> newOLIs){
    
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
        set<Id> UpdatedOpp = new set<Id>();
        Map<String,QuoteLineItem> QuoteLineItemToProductMap = new Map<String,QuoteLineItem>();
         
        try{
            for(OpportunityLineItem OLI: newOLIs){
                UpdatedOpp.add(OLI.Opportunityid); 
            }
            system.debug('UpdatedOpp : '+UpdatedOpp); 
            
            // Create Map of Product and Opportunity Line Item
            List<QuoteLineItem> QLIList = [Select Id,Item_Activity_Type__c,MOLI_id__c,Status__c,quantity,Annual_Price__c,unitprice,discount,Surcharge_Prct__c,Monthly_Charge__c,Number_of_Contacts__c,Incremental_Amount__c,Renewal_Amount__c,OpportunityLineId__c,Description,Revenue_Type__c,QuoteId,Product2Id,Quote.OpportunityId 
                                                    from QuoteLineItem where Quote.OpportunityId=: UpdatedOpp
                                                    AND quote.Primary_Quote__c =: True 
                                                    and quote.issyncing =:true];
             
            for(QuoteLineItem QLI : QLIList){
                QuoteLineItemToProductMap.put(QLI.Product2Id+''+QLI.OpportunityLineId__c,QLI); //SFD-1121 Changing the key [Rajashree]
            }
             
            system.debug('QuoteLineItemToProductMap::'+QuoteLineItemToProductMap);
            List<OpportunityLineItem> oppLIs = [SELECT ID,Product2Id,OpportunityID ,Active_Status__c, Revenue_Type__c ,Number_of_Contacts__c, Incremental_Amount__c ,Renewal_Amount__c ,
                                                      Monthly_Charge__c ,Surcharge_Prct__c,Discount , Annual_Price__c ,MOLI_id__c, Activity_Type__c 
                                                      FROM  OpportunityLineItem WHERE ID IN: newOLIs];
            for(OpportunityLineItem OppLI: oppLIs){
                if(QuoteLineItemToProductMap.containsKey(OppLI.Product2Id+''+OppLI.id)){
                    
                    QuoteLineItem LI = QuoteLineItemToProductMap.get(OppLI.Product2Id+''+OppLI.id); 
                    if(OppLI.OpportunityID == LI.Quote.OpportunityID){
                        System.debug('@@@@After Insert Getting Updated : OppLI.id'+OppLI.Product2Id+''+OppLI.id);
                        system.debug('LI.Revenue_Type__c::'+OppLI.Revenue_Type__c );
                        OppLI.Revenue_Type__c = LI.Revenue_Type__c ;
                        OppLI.Number_of_Contacts__c = LI.Number_of_Contacts__c ;
                        OppLI.Incremental_Amount__c = LI.Incremental_Amount__c ;
                        OppLI.Renewal_Amount__c = LI.Renewal_Amount__c ;
                        OppLI.Monthly_Charge__c = LI.Monthly_Charge__c ;
                        OppLI.Surcharge_Prct__c = LI.Surcharge_Prct__c ;
                        OppLI.Discount = LI.Discount; 
                        OppLI.Annual_Price__c = LI.Annual_Price__c; 
                        System.debug('@@@LI.Status__c'+LI.Status__c);
                        OppLI.Active_Status__c = LI.Status__c;
                        System.debug('@@@OppLI.Active_Status__c'+OppLI.Active_Status__c);
                        OppLI.Activity_Type__c = LI.Item_Activity_Type__c;
                        system.debug('$$$LI.MOLI_id__c'+LI.MOLI_id__c);
                        OppLI.MOLI_id__c= LI.MOLI_id__c;//Rajashree added this for Feb Release
                        system.debug('$$$OppLi.MOLI_id__c'+OppLi.MOLI_id__c);
                        lstOLI.add(OppLI);
                    }  
                }
            }
            system.debug('$$$UpdateOppLineItemList'+newOLIs);
            if(lstOLI != NULL && !lstOLI.isEmpty()){
             UPDATE lstOLI ;                  
            }
             
        }catch(Exception e){
            System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
        }   
      
    }
    
    //CRM-81 method to sync records from OLI to OLI Clone object 
    public static void syncOLIToOLIClone(String action, Set<ID> oliIDSet){
        System.debug('action : '+action);
        System.debug('oliIDSet : '+oliIDSet);
        //check if no ID's are passed for processing
        if(oliIDSet !=null && oliIDSet.size()>0){
            if(action == 'delete'){
                List<LCRM_Opportunity_Product_Clone__c> oliCloneList;
                try{
                    oliCloneList = [SELECT ID FROM LCRM_Opportunity_Product_Clone__c 
                            WHERE LCRM_Opp_Prod_ID__c IN :oliIDSet];
                }catch(Exception e){
                    LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                    excepObj.LCRM_Exception_Message__c = e.getMessage();
                    excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
                    excepObj.LCRM_Exception_Type__c = 'OpportunityLineItem delete query';
                    excepObj.LCRM_Record_Ids__c = String.valueOf(oliIDSet);
                    excepObj.LCRM_User_ID__c = userinfo.getUserId();
                    insert excepObj;
                }
                //delete clone records 
                if(oliCloneList!=null && oliCloneList.size()>0){
                    try{
                        Delete oliCloneList;
                    }catch(Exception e){
                        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                        excepObj.LCRM_Exception_Message__c = e.getMessage();
                        excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
                        excepObj.LCRM_Exception_Type__c = 'OpportunityLineItem delete';
                        excepObj.LCRM_Record_Ids__c = String.valueOf(oliIDSet);
                        excepObj.LCRM_User_ID__c = userinfo.getUserId();
                        insert excepObj;
                        throw e;
                    }
                }
                return;// return for delete action
            }
            
            Map<ID,OpportunityLineItem> oliFilteredMap = new Map<ID,OpportunityLineItem>();
            try{
                //query OLI record with filter conditions
                oliFilteredMap = new Map<ID,OpportunityLineItem>([SELECT ID, CurrencyIsoCode, OpportunityID, LCRM_Action__c, 
                                               LCRM_Current_ACV__c, LCRM_Incremental_Amount__c, LCRM_New_ACV_SalesPrice__c, 
                                               LCRM_Product_Category__c, LCRM_Product_Segment__c, Product2ID 
                                               FROM OpportunityLineItem 
                                               where ID IN :oliIDSet AND 
                                               Opportunity.LCRM_Split_On__c =TRUE AND
                                               Opportunity.Is_GLI__c = TRUE]);// AND LCRM_Action__c <> 'Remove'
            }catch(Exception e){
                System.debug('Exception : '+e.getStackTraceString());
                return;
            }
            System.debug('oliFilteredMap : '+oliFilteredMap);
            //if no OLI records satisfy filter conditions then return as no records to process
            if((oliFilteredMap == null || oliFilteredMap.size()<=0)){
                return;
            }
            //query OLI Clone records and create MAP
            Map<String,LCRM_Opportunity_Product_Clone__c> oliCloneMap = new Map<String,LCRM_Opportunity_Product_Clone__c>();
            for(LCRM_Opportunity_Product_Clone__c oliCloneTemp : [SELECT ID,LCRM_Action__c, LCRM_Current_ACV__c, LCRM_Incremental_Amount__c, 
                            LCRM_New_ACV_SalesPrice__c, LCRM_Opportunity__c, LCRM_Opp_Prod_ID__c, LCRM_Product__c, 
                            LCRM_Product_Segment__c FROM LCRM_Opportunity_Product_Clone__c 
                            WHERE LCRM_Opp_Prod_ID__c IN :oliFilteredMap.keySet()]){
                oliCloneMap.put(oliCloneTemp.LCRM_Opp_Prod_ID__c, oliCloneTemp);
            }
            System.debug('oliCloneMap : '+oliCloneMap);
            if(action == 'insert' || action == 'update'){
                //get Action's list from Custom Settings that should be excluded for inserting new OLI Clone records
                String ExcludeActionString = 'LCRMSplit_ExcludeActions';
                List<String> ExcludeActionList = (KeyValueListStore__c.getValues(ExcludeActionString) == null || 
                                   KeyValueListStore__c.getValues(ExcludeActionString).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(ExcludeActionString).TextValue__c == '')?
                                   new List<String>():
                                   KeyValueListStore__c.getValues(ExcludeActionString).TextValue__c.split(',');
                Set<String> ExcludeActionSet = new Set<String>();
                ExcludeActionSet.addAll(ExcludeActionList);
                System.debug('ExcludeActionSet : '+ExcludeActionSet);
                               
                Set<ID> oppIdSet = new Set<ID>();
                List<LCRM_Opportunity_Product_Clone__c> oProdCloneList = new List<LCRM_Opportunity_Product_Clone__c>();
                //loop to insert/update OLI clone records
                for(OpportunityLineItem oProd : oliFilteredMap.Values()){
                    LCRM_Opportunity_Product_Clone__c oPTemp = new LCRM_Opportunity_Product_Clone__c();
                    //System.debug('oPTemp.ID : '+oPTemp.ID);
                    if(oliCloneMap != null && oliCloneMap.get(oProd.ID) !=null){
                        oPTemp  = oliCloneMap.get(oProd.ID);
                    }else{
                        //if OLI Action is in excluse list then skip inserting new record
                        if(ExcludeActionSet.contains(oProd.LCRM_Action__c)){
                            continue;
                        }
                        oPTemp.LCRM_Opportunity__c = oProd.OpportunityID;
                    }
                    oPTemp.LCRM_Opp_Prod_ID__c = oProd.ID;
                    oPTemp.LCRM_Product__c = oProd.Product2Id;
                    oPtemp.CurrencyIsoCode = oProd.CurrencyIsoCode;
                    oPTemp.LCRM_Action__c = oProd.LCRM_Action__c;
                    oPTemp.LCRM_Current_ACV__c = oProd.LCRM_Current_ACV__c;
                    oPTemp.LCRM_New_ACV_SalesPrice__c = oProd.LCRM_New_ACV_SalesPrice__c;
                    oPTemp.LCRM_Product_Segment__c = oProd.LCRM_Product_Segment__c;
                    oProdCloneList.add(oPTemp);
                    oppIdSet.add(oProd.OpportunityID);
                }
                System.debug('oProdCloneList : '+oProdCloneList);
                if(oProdCloneList.size()>0){
                    upsert oProdCloneList;
                }
                List<LCRM_Opportunity_Team_Clone__c> oTeamCloneList;
                Set<String> oSplitSet = new Set<String>();
                try{
                    oTeamCloneList = [SELECT ID, LCRM_Opportunity__c FROM LCRM_Opportunity_Team_Clone__c where LCRM_Opportunity__c IN :oppIdSet];
                    //create set of String to have info about already present split records
                    for(LCRM_Opportunity_Split__c osplit : [SELECT ID, LCRM_Opportunity_Product_Clone__c, LCRM_Opportunity_Team_Clone__c, 
                                                            LCRM_Opportunity__c, LCRM_Percent__c FROM LCRM_Opportunity_Split__c 
                                                            WHERE LCRM_Opportunity__c IN :oppIdSet]){
                        oSplitSet.add(osplit.LCRM_Opportunity_Product_Clone__c+':'+osplit.LCRM_Opportunity_Team_Clone__c);
                    }
                }catch(Exception e){}
                System.debug('oSplitSet : '+oSplitSet);
                System.debug('oTeamCloneList : '+oTeamCloneList);
                System.debug('oProdCloneList : '+oProdCloneList);
                
                //loop to insert new split records
                List<LCRM_Opportunity_Split__c> oSplitInsList = new List<LCRM_Opportunity_Split__c>();
                if(oTeamCloneList != null && oTeamCloneList.size()>0){
                    for(LCRM_Opportunity_Team_Clone__c oTeam : oTeamCloneList){
                        for(LCRM_Opportunity_Product_Clone__c oProd : oProdCloneList){
                            //System.debug('1 : '+oTeam.LCRM_Opportunity__c);
                            //System.debug('2 : '+oProd.LCRM_Opportunity__c);
                            //System.debug('3 : '+oProd.ID);
                            //System.debug('4 : '+oTeam.ID);
                            //System.debug('5 : '+!oSplitSet.contains(oProd.ID+':'+oTeam.ID));
                            //System.debug('6 : '+oProd.LCRM_Action__c);
                            //System.debug('7 : '+!ExcludeActionSet.contains(oProd.LCRM_Action__c));
                            if(oTeam.LCRM_Opportunity__c == oProd.LCRM_Opportunity__c && !oSplitSet.contains(oProd.ID+':'+oTeam.ID) && !ExcludeActionSet.contains(oProd.LCRM_Action__c)){
                                LCRM_Opportunity_Split__c oSplit = new LCRM_Opportunity_Split__c();
                                oSplit.LCRM_Opportunity_Team_Clone__c = oTeam.ID;
                                oSplit.LCRM_Opportunity_Product_Clone__c = oProd.ID;
                                oSplit.LCRM_Opportunity__c = oTeam.LCRM_Opportunity__c;
                                oSplit.LCRM_Percent__c = 0;
                                oSplit.CurrencyIsoCode = oProd.CurrencyIsoCode;
                                oSplitInsList.add(oSplit);
                            }
                        }
                    }
                }
                System.debug('oSplitInsList : '+oSplitInsList);
                insert oSplitInsList;
            }/*else if(action == 'update'){
                List<LCRM_Opportunity_Product_Clone__c> oProdCloneList = new List<LCRM_Opportunity_Product_Clone__c>();
                for(OpportunityLineItem oProd : oliFilteredMap.Values()){
                    if(oliCloneMap!=null && oliCloneMap.get(oProd.ID)!=null){
                        LCRM_Opportunity_Product_Clone__c oPTemp = oliCloneMap.get(oProd.ID);
                        oPTemp.LCRM_Action__c = oProd.LCRM_Action__c;
                        oPTemp.LCRM_Current_ACV__c = oProd.LCRM_Current_ACV__c;
                        oPTemp.LCRM_New_ACV_SalesPrice__c = oProd.LCRM_New_ACV_SalesPrice__c;
                        oPTemp.LCRM_Product_Segment__c = oProd.LCRM_Product_Segment__c;
                        oProdCloneList.add(oPTemp);
                    }
                }
                System.debug('oProdCloneList : '+oProdCloneList);
                if(oProdCloneList.size()>0){
                    update oProdCloneList;
                }
            }*/
        }
    }


 public static void updateTotalPriceOnOptyProdDtl(Map<String, Decimal> mapOLITotalSalesPrice){
        List<OpportunityProductDetail__c> opdList = new List<OpportunityProductDetail__c>();            
        if(!mapOLITotalSalesPrice.isEmpty()){
            opdList = [select id, Sales_Total_Price__c, Opportunity_Line_Item_Id__c from OpportunityProductDetail__c where Opportunity_Line_Item_Id__c IN:mapOLITotalSalesPrice.keyset()];
        }
        system.debug(opdList);
        
        List<OpportunityProductDetail__c> opdListUpd = new List<OpportunityProductDetail__c>();
        for(OpportunityProductDetail__c opdRec:opdList){
            opdRec.Sales_Total_Price__c = mapOLITotalSalesPrice.get(opdRec.Opportunity_Line_Item_Id__c);  
            opdListUpd.add(opdRec);
        }
        
        if(opdListUpd.size()>0){
            update opdListUpd;
        }
    }
}