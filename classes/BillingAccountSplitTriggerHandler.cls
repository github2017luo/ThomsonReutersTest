public class BillingAccountSplitTriggerHandler{

    /***********************************(BRS_MS7.1.18,BRS_MS7.1.26)************************************************
    Purpose:To update child quote's , child oppty's fields/ lineItems when Billing Account Split's field is updated
    Method Name:afterUpdateBAQuoteSync, getCurrencyConvRate, getOpptyCurrencyEquivalantValue
    Author: Rajashree
    Date: 2016-06-03     
    **************************************************************************************************************/
    static Map<String, Double> currencyConvRateMap = new Map<String, Double>();
    public static Map<String, Double> getCurrencyConvRate(){
       
            for(CurrencyType ct : [Select Id, ConversionRate, IsoCode from CurrencyType]){
                currencyConvRateMap.put(ct.IsoCode, ct.ConversionRate);
            }
      
        return currencyConvRateMap;
    } 

    public static decimal getOpptyCurrencyEquivalantValue(Decimal ValueinUserCurr,string strOppCurr,string strUsrCurr){
        currencyConvRateMap=  getCurrencyConvRate();
        decimal decConvertAmt = (currencyConvRateMap.get(strOppCurr)/currencyConvRateMap.get(strUsrCurr))*ValueinUserCurr;
        system.debug('**decConvertAmt' +decConvertAmt);
        return decConvertAmt ;
    }     


 public static void afterUpdateBAQuoteSync(Map<id,Billing_Account_Split__c> newMapTrigger, Map<id,Billing_Account_Split__c> oldMapTrigger) 
    {       
            Set<Id> setChildOpptyId = new Set<Id>();
            Map<id,id> mapChildOppBillAccId = new Map<id,id>();
            List<Quote> lstUpdateQuote = new List<Quote>();
            List<OpportunityContactRole> lstUpsertCOCR = new List<OpportunityContactRole>();
            List<Opportunity> lstUpdateOppty = new List<Opportunity>();
            List<QuoteLineItem> lstUpdateQLI = new List<QuoteLineItem>();
            List<QuoteLineItem> lstQuoLineItem = new List<QuoteLineItem>();
            Map<String, Decimal> mapChildOppBASId = new Map<String, Decimal>();
            Boolean boolCheck = false;
            Boolean boolCH = false;
            String strOppCurr, strUsrCurr;
            Set<ID> setEbillingConID = new set<Id>();
            Set<ID> setBoletoConID= new set<Id>();
           
            try{           
                for(Billing_Account_Split__c bas : newMapTrigger.values()) {                 
                    if( oldMapTrigger.get(bas.id).PO_Number__c != NewMapTrigger.get(bas.id).PO_Number__c 
                      || oldMapTrigger.get(bas.id).Invoice_Notes__c != NewMapTrigger.get(bas.id).Invoice_Notes__c
                      || oldMapTrigger.get(bas.id).Account__c!= NewMapTrigger.get(bas.id).Account__c
                      || oldMapTrigger.get(bas.id).Opportunity_Notes__c != NewMapTrigger.get(bas.id).Opportunity_Notes__c                          
                      || oldMapTrigger.get(bas.id).Product_1_Sales_Price__c != NewMapTrigger.get(bas.id).Product_1_Sales_Price__c
                      || oldMapTrigger.get(bas.id).Product_2_Sales_Price__c != NewMapTrigger.get(bas.id).Product_2_Sales_Price__c
                      || oldMapTrigger.get(bas.id).Product_3_Sales_Price__c != NewMapTrigger.get(bas.id).Product_3_Sales_Price__c
                      || oldMapTrigger.get(bas.id).Boleto_Contact__c  != NewMapTrigger.get(bas.id).Boleto_Contact__c 
                      || oldMapTrigger.get(bas.id).E_Billing_Contact__c != NewMapTrigger.get(bas.id).E_Billing_Contact__c ){                     
                       if(bas.Product_1__c != NULL && bas.Child_Opportunity__c != NULL) {
                             mapChildOppBASId.put(bas.Child_Opportunity__c+'-'+ bas.Product_1__c+''+bas.OLI_id_1__c, bas.Product_1_Sales_Price__c); //SFD-1121 Changing the key [Rajashree]
                            }
                       if(bas.Product_2__c != NULL && bas.Child_Opportunity__c != NULL) {
                            mapChildOppBASId.put(bas.Child_Opportunity__c+'-'+ bas.Product_2__c+''+bas.OLI_id_2__c, bas.Product_2_Sales_Price__c);//SFD-1121 Changing the key [Rajashree]
                        }
                        if(bas.Product_3__c != NULL &&  bas.Child_Opportunity__c != NULL) {
                            mapChildOppBASId.put(bas.Child_Opportunity__c+'-'+bas.Product_3__c+''+bas.OLI_id_3__c, bas.Product_3_Sales_Price__c); //SFD-1121 Changing the key [Rajashree]                        
                        }   
                        if(bas.E_Billing_Contact__c != null){
                            setEbillingConID.add(oldMapTrigger.get(bas.id).E_Billing_Contact__c);
                        }
                        if(bas.Boleto_Contact__c != null){
                            setBoletoConID.add(oldMapTrigger.get(bas.id).Boleto_Contact__c);
                        }
                        mapChildOppBillAccId.put(bas.Child_Opportunity__c,bas.Id);
                           setChildOpptyId.add(bas.Child_Opportunity__c);
                     }                
                }  
                lstQuoLineItem =[SELECT id ,Quote.Pricing_Approval_Complete__c, Quote.OpportunityId,Quote.Opportunity.CurrencyIsoCode,UnitPrice,MOLI_id__c , Product2.Id FROM QuoteLineItem WHERE Quote.OpportunityId IN:setChildOpptyId];
                
                //strUsrCurr= UserInfo.getDefaultCurrency();

            for(QuoteLineItem objQLI : lstQuoLineItem) {
            strOppCurr= objQLI.Quote.Opportunity.CurrencyIsoCode;
            String strBAScurr = String.valueOf(newMapTrigger.get(mapChildOppBillAccId.get(objQLI.Quote.OpportunityId)).CurrencyIsoCode);
            if(strOppCurr!=strBAScurr){                     
                system.debug('mismatch');            
                    objQLI.UnitPrice = getOpptyCurrencyEquivalantValue(mapChildOppBASId.get(objQLI.Quote.OpportunityId +'-'+ objQLI.Product2.Id+''+objQLI.MOLI_id__c),strOppCurr,strBAScurr);   //SFD-1121                     
                    system.debug('$$$$$$$$$$$$$$$$objQLI.UnitPrice' + objQLI.UnitPrice);
                    boolCheck= true;

            }
            else{       
             system.debug('match');                                
                        objQLI.UnitPrice = mapChildOppBASId.get(objQLI.Quote.OpportunityId +'-'+ objQLI.Product2.Id+''+objQLI.MOLI_id__c);// SFD-1121
                        boolCheck= true;

            }
                    
                    lstUpdateQLI.add(objQLI);                
                }
                If(setChildOpptyId != null && !setChildOpptyId.isEmpty()) {
                    List<Opportunity> lstOpp =[SELECT id,(SELECT Id,opportunityId, Role FROM OpportunityContactRoles
                                                WHERE opportunityId IN: setChildOpptyId 
                                                AND 
                                                ((ROLE =  'E-Billing Contact' AND contactId IN: setEbillingConID)
                                                OR (ROLE = 'Boleto Contact' AND contactId IN: setBoletoConID))),
                                                  Description, AccountId 
                                               FROM Opportunity 
                                               WHERE id IN: setChildOpptyId ];
  
                    List<OpportunityContactRole> lstOppConRole = new List<OpportunityContactRole>();
 
                    boolean boolChck = false;
 
                    for(Opportunity opp: lstOpp) {
                        if(opp.OpportunityContactRoles != NULL)
                            lstOppConRole.addAll(opp.OpportunityContactRoles);
                        If(newMapTrigger.get(mapChildOppBillAccId.get(opp.id)).Account__c != oldMapTrigger.get(mapChildOppBillAccId.get(opp.id)).Account__c) {
                            opp.AccountId = newMapTrigger.get(mapChildOppBillAccId.get(opp.id)).Account__c;
                            boolChck =true;
                        }
                        If(newMapTrigger.get(mapChildOppBillAccId.get(opp.id)).Opportunity_Notes__c != oldMapTrigger.get(mapChildOppBillAccId.get(opp.id)).Opportunity_Notes__c) {
                            opp.Description = newMapTrigger.get(mapChildOppBillAccId.get(opp.id)).Opportunity_Notes__c;
                            boolChck =true;
                        }
                        lstUpdateOppty.add(opp);
                    }
                    Map<String, OpportunityContactRole> mapOppConRole = new Map<String, OpportunityContactRole>();
                    if(lstOppConRole!= NULL){
                        for(OpportunityContactRole opCR :lstOppConRole){
                            if(opCR.Role == 'E-Billing Contact')
                                mapOppConRole.put(opcr.OpportunityID +'EB', opCr);
                            if(opCR.Role == 'Boleto Contact')
                                mapOppConRole.put(opcr.OpportunityID + 'BC', opCr);
                        }
                    }
                     
                   for(Billing_Account_Split__c bas : newMapTrigger.values()) {    
                       if(mapOppConRole.get(bas.Child_Opportunity__c + 'EB') != NULL) {
                           OpportunityContactRole objOPCR = new OpportunityContactRole();
                           objOPCR.Opportunityid = bas.Child_Opportunity__c;
                           objOPCR.Id = mapOppConRole.get(bas.Child_Opportunity__c + 'EB').Id;
                           objOPCR.contactId = bas.E_Billing_Contact__c;
                           lstUpsertCOCR.add(objOPCR);
                           boolCH = true;
                        }
                    else {
                        OpportunityContactRole objOPCR = new OpportunityContactRole();                        
                        objOPCR.Opportunityid = bas.Child_Opportunity__c;
                        objOPCR.contactId = bas.E_Billing_Contact__c;
                        objOPCR.ROLE =  'E-Billing Contact';
                        lstUpsertCOCR.add(objOPCR);
                        boolCH = true;
                    }
                    if(mapOppConRole.get(bas.Child_Opportunity__c + 'BC') != NULL) {
                        OpportunityContactRole objOPCR = new OpportunityContactRole();
                        objOPCR.Opportunityid = bas.Child_Opportunity__c;
                        objOPCR.ID = mapOppConRole.get(bas.Child_Opportunity__c + 'BC').Id;
                        objOPCR.contactId = bas.Boleto_Contact__c;
                        lstUpsertCOCR.add(objOPCR);
                        boolCH = true;
                    }
                    else {
                        OpportunityContactRole objOPCR = new OpportunityContactRole();
                        objOPCR.Opportunityid = bas.Child_Opportunity__c;
                        objOPCR.contactId = bas.Boleto_Contact__c;
                        objOPCR.ROLE = 'Boleto Contact';
                        lstUpsertCOCR.add(objOPCR);
                        boolCH = true;
                    }
                    
                    }
                    List<Quote> lstQuote = [SELECT id, Purchase_Order__c , OpportunityId, Primary_Quote__c, Is_Master_Quote__c, Master_Quote__c
                                            FROM Quote 
                                            where OpportunityId IN: setChildOpptyId
                                            AND Primary_Quote__c = TRUE 
                                            AND Is_Master_Quote__c = False
                                            AND Master_Quote__c != NULL];
                    Boolean boolChk = false;                                            
                  
                    for(Quote quo : lstQuote) {                    
                        if(quo.Master_Quote__c != NULL && quo.Is_Master_Quote__c == false && mapChildOppBillAccId != NULL) {                         
                            if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).PO_Number__c != NULL) {
                                if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).PO_Number__c != 
                                            oldMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).PO_Number__c) {
                                    quo.Purchase_Order__c = newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).PO_Number__c;
                                    boolChk =true;
                                }
                            }
                          else { 
                               quo.Purchase_Order__c = '';
                               boolChk =true;
                          }

                             if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Invoice_Notes__c != NULL){
                              if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Invoice_Notes__c != oldMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Invoice_Notes__c)
                             {
                                quo.Invoice_Notes__c = newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Invoice_Notes__c;
                                boolChk =true;
                             }
                          }
                             else{
                                quo.Invoice_Notes__c ='';
                                boolChk =true;
                              }
                          
                        if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Boleto_Contact__c != NULL){
                              if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Boleto_Contact__c != oldMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Boleto_Contact__c)
                             {
                                quo.Boleto_Contact__c = newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).Boleto_Contact__c;
                                boolChk =true;
                             }
                          }
                       /*      else{
                                quo.Boleto_Contact__c ='';
                                boolChk =true;
                              } */
                          
                         
                         if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).E_Billing_Contact__c != NULL){
                              if(newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).E_Billing_Contact__c != oldMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).E_Billing_Contact__c)
                             {
                                quo.E_Billing_Contact__c = newMapTrigger.get(mapChildOppBillAccId.get(quo.OpportunityId)).E_Billing_Contact__c;
                                boolChk =true;
                             }
                          }
                       /*      else{
                                quo.E_Billing_Contact__c ='';
                                boolChk =true;
                              } */
                              
                          /*if(boolChk == true){
                             quo.CQ_Read_Only_Flag__c = false;
                             }*/
                        } 
                        
                         
                       
                        
                        lstUpdateQuote.add(quo);
                    }  
                    /* List<Quote> lstUpdateQuoteForFlagReset = new List<Quote>();    
                    if(lstUpdateQuote != null && !lstUpdateQuote.isEmpty()  && boolChk == true) {
                        Database.UPDATE(lstUpdateQuote);
                        for(Quote q: lstUpdateQuote){
                            q.CQ_Read_Only_Flag__c= true;
                            lstUpdateQuoteForFlagReset.add(q);
                        }
                    }
                    if(lstUpdateQuoteForFlagReset != null && !lstUpdateQuoteForFlagReset.isEmpty()) {
                
                    UPDATE lstUpdateQuoteForFlagReset;
                }*/
                 
                   if(lstUpdateOppty != null && !lstUpdateOppty.isEmpty()  && boolChck == true) {
                        Database.UPDATE(lstUpdateOppty);
                   }
                   if(lstUpdateQLI != null && !lstUpdateQLI.isEmpty() && boolCheck == true) {
                        Database.UPDATE(lstUpdateQLI);
                   }
                 if(lstUpsertCOCR != null && !lstUpsertCOCR.isEmpty() && boolCH == true ) {
                        Database.UPSERT(lstUpsertCOCR);
                   }
                   if(lstUpdateQuote!= null && !lstUpdateQuote.isEmpty() && boolChk == true ) {
                        Database.UPDATE(lstUpdateQuote);
                   }
                } 
         }
            catch(Exception ex){
                System.debug('Exception occured in BillingAccountSplitTriggerHandler, method afterUpdateBAQuoteSync' + ex.getmessage() + 'line number'+ ex.getLinenumber());
            }
                   
    }
   
    /***********************************(BRS_MS7.1.18,BRS_MS7.1.26)********************************************
    Purpose:To delete child opportunity/quote whenever corresponding BAS is deleted
    Method Name:beforeDeleteBAChildOppQuoteSync
    Author: Rajashree
    Date: 2016-06-13     
    ************************************************************************************************************/
  
     public static void beforeDeleteBAChildOppQuoteSync(List<Billing_Account_Split__c> oldtrigger){
    
          try{
                Set<Id> setChldOppId = new Set<Id>();
                List<Opportunity> lstChldOpp = new List<Opportunity>();
                List<Quote> lstChldQuote = new List<Quote>();
                List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem>();
                
                for(Billing_Account_Split__c bas : oldtrigger) {
                    if(bas.Child_Opportunity__c != null) {
                        setChldOppId.add(bas.Child_Opportunity__c);         
                    }
                }
                if(setChldOppId!= null && !setChldOppId.isEmpty()){
                    lstChldOpp = [SELECT Id FROM Opportunity WHERE Id IN: setChldOppId]; 
                    lstChldQuote =[SELECT Id,OpportunityId FROM Quote WHERE OpportunityId IN: setChldOppId];
                    lstOppLineItem =[SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN: setChldOppId];
                   
                   if(lstOppLineItem!= null && !lstOppLineItem.isEmpty()){
                        DELETE lstOppLineItem ;
                   }
                   if(lstChldQuote!= null && !lstChldQuote.isEmpty()) {
                        DELETE lstChldQuote;
                    } 
                   
                    if(lstChldOpp!= null && !lstChldOpp.isEmpty()) {
                        DELETE lstChldOpp;
                    }
                    
                  }    
             }
             catch(Exception ex){
                System.debug('Exception occured in BillingAccountSplitTriggerHandler, method beforeDeleteBAChildOppQuoteSync' + ex.getmessage() + 'line number'+ ex.getLinenumber());
             }          
            
      }
      
      /****************************************************************************************************
    Purpose:To prevent deletion of BAS when Quote is submitted for Approval
    Method Name:beforeDeleteBAChildOppQuoteSync
    Author: Satyaki
    Defect: SFD-745
    Date: 2016-08-29 
    ************************************************************************************************************/
  
     public static void beforeDeleteBAS(List<Billing_Account_Split__c> oldtrigger){
    
          try{
              Set<Id> setBAS = new Set<Id>();
              List<Billing_Account_Split__c> lstBAS= new List<Billing_Account_Split__c>();
              Map<Id,Billing_Account_Split__c> mapBASId = new Map<Id,Billing_Account_Split__c>();
              
              for(Billing_Account_Split__c bas : oldtrigger) {
                  setBAS.add(bas.Id);
              }
              
              if(setBAS != null && !setBAS.isEmpty()) { 
              lstBAS = [Select Id,Master_Opportunity__r.StageName,Master_Opportunity__r.SyncedQuote.Approval_Status__c FROM Billing_Account_Split__c WHERE Id IN: setBAS AND
                                (Master_Opportunity__r.SyncedQuote.Approval_Status__c =: 'Pending Manager Approval' 
                                OR Master_Opportunity__r.SyncedQuote.Approval_Status__c =: 'Pending Pricing Approval' 
                                OR Master_Opportunity__r.StageName =: '95%' 
                                OR Master_Opportunity__r.StageName =: '100%')];
              } 
             
              if(lstBAS != null && !lstBAS.isEmpty()) {
                 for(Billing_Account_Split__c bas: lstBAS){
                    mapBASId.put(bas.id, bas); 
                 }
              }
             
              system.debug('Step9.99: '+mapBASId);
              for(Billing_Account_Split__c bas : oldtrigger) {
                    system.debug('Step9.999: '+bas);
                    system.debug('Step9.998: '+mapBASId.get(bas.Id));
                    if(bas.Id == mapBASId.get(bas.Id).Id) {
                        bas.addError(Label.BAS_Undelete);
                    }
               }                      
          }
          catch(Exception ex){
            System.debug('Exception occured in BillingAccountSplitTriggerHandler, method beforeDeleteBAS' + ex.getmessage() + 'line number'+ ex.getLinenumber());
          }          
      }
  
  }