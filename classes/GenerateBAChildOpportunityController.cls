global without sharing class GenerateBAChildOpportunityController {

    //public List<Billing_Account_Split__c> baSelected{get;set;} 
    Map<id,Billing_Account_Split__c> CoIdBAMap= new Map<id,Billing_Account_Split__c>();
    List<string> baSelected= new List<string>();
    public Map<String, Double> currencyConvRateMap; 
    string strOppCurr, strUsrCurr;
    public boolean InConsoleView {get;set;} 
    public String currentPageURL{get; set;}
    public Boolean isSales{get;set;}     
    public Boolean isError{get; set;} //SFD-16 ~ Added by Piyali
    String theId;
    global GenerateBAChildOpportunityController(ApexPages.StandardSetController controller) {
        //baSelected= (List<Billing_Account_Split__c>)controller.getSelected();
        baSelected= ApexPages.currentPage().getParameters().get('recs').split(',',-2);
        system.debug('***baSelected' + baSelected);
        currencyConvRateMap = getCurrencyConvRate();
        isError = false; //SFD-16 ~ Added by Piyali
    }
    
    public PageReference PopulateChildOppties(){    

        try{
            InConsoleView = AppUtil.getURLParam(ApexPages.currentPage(), 'isdtp', null) != null;
             theId = ApexPages.currentPage().getParameters().get('id');
            //MCL-2021 - Added Milestones__c & Sub_Category_2__c to the Query.
            Opportunity masterOppty = [select Name,Description,StageName,CloseDate,CurrencyIsoCode,pricebook2Id,
                                        Opportunity_Owner_s_Sales_Org__c,Amount,Account.name,Owner.name,Category__c,Sub_Category__c,
                                        Win_Loss__c,Reason__c,Was_There_a_Competitor__c,Expected_Revenue_Date__c,
                                        Expiration_Date__c,Master_Opportunity__c,Is_Child_Opportunity__c,
                                        Stage_Description__c,ForecastCategoryName,Renewal_Flag__c,Grace_Period_Indicator__c,
                                        Competitor_Name__c,Opportunity_currency__c,LATAM_Business_Unit__c,Sales_Org__c,SAP_Account_Number__c,
                                        SAP_Quotation_Document_number__c,Original_Order_Number__c,Milestones__c,Sub_Category_2__c from Opportunity where Id =: theId limit 1]; 
            strOppCurr= masterOppty.CurrencyIsoCode;
            strUsrCurr= UserInfo.getDefaultCurrency();
            system.debug('**oppcurr:userCurr' + strOppCurr+strUsrCurr);
            List<Quote> masterQuoteLst = [SELECT Status,Name,Primary_Quote__c,Is_Master_Quote__c,OP_Owner__c, Submitting_Rep__c,Order_Source__c,Purchase_Order_Date__c,
                                 Revenue_Channel__c,Division__c,LatAm_Department__c,Sold_To_SAP_Account_ID__c,Sold_To_Tax_ID__c,Bill_To_Contact__c,Billing_Type__c,
                                 Bank_Account_Num__c,Bank__c,Shipping_Notes__c,Renewal_Options__c,Revenue_Type__c,OP_Rejection_Count__c,OP_Rejection_Date__c,
                                 Payer_Customer_Name__c,Bill_To_Customer_Name__c,Ship_To_Customer_Name__c,Gross_Income_Tax_Number__c, Payment_Terms__c,  Payment_Method__c,
                                 Payer_SAP_Account_ID__c,Bill_To_SAP_Account_ID__c,Ship_To_SAP_Account_ID__c,Legacy_Number__c,Opportunity_Notes__c,TotalPrice, Plant__c,
                                 Grace_Period_Indicator__c,Approval_Status__c,pricebook2Id,LATAM_Renewal_Division__c,
                                 Sold_To_Contact__c, Additional_E_Billing_contact_emails__c, TID_Number__c, Reason__c, Was_There_A_Competitor__c, Competitor_Name__c
                                 from Quote Where OpportunityId= :masterOppty.Id AND Primary_Quote__c = true];
            Quote masterQuote; 
            if(!masterQuoteLst.isEmpty()){
                masterQuote = masterQuoteLst[0];
            }
            system.debug('***MasterOppty' +masterOppty);
             if (theId == null) {
                // Display the Visualforce page's content if no Id is passed over
                return null;
            }
            if(masterOppty.Is_Child_Opportunity__c != true && MasterOppty.StageName == '90%' && masterQuote!= null && masterQuote.Status == Label.QuotePrevalidateForApproval)
            {    
               
                List<Billing_Account_Split__c> baListUpd = new  List<Billing_Account_Split__c>();               
                List<Billing_Account_Split__c> baList = [SELECT Id,Name,Master_Opportunity__c,Child_Opportunity__c,Account__c,Account__r.Name,Subtotal_Amount__c,PO_Number__c,Invoice_Notes__c,
                                                        E_Billing_Contact__c,Boleto_Contact__c,Product_1__c,Product_1_Sales_Price__c,Product_2__c,Product_2_Sales_Price__c,
                                                        Product_3__c,Product_3_Sales_Price__c,Opportunity_Notes__c,CurrencyIsoCode,OLI_id_1__c,OLI_id_2__c,OLI_id_3__c
                                                        FROM Billing_Account_Split__c 
                                                        WHERE Master_Opportunity__c =: theId and id in:baSelected];
                SET<ID> BAIdSet= new SET<ID>();            
                Map<id,id> baCOptyIdMap= new Map<id,id>(); 
                SET<ID> exisitngCOIds= new SET<ID>();
                //Gettign the list of existing Child Opps for the selected BAS records if any.
                for(Billing_Account_Split__c ba: baList){
                    if(ba.child_Opportunity__c != null){
                        exisitngCOIds.add(ba.child_Opportunity__c);                                         
                    }
                }
                if(!exisitngCOIds.isEmpty()){
                    system.debug('****:exisitngCOIds::' +exisitngCOIds);
                    deleteExistingChildOpps(exisitngCOIds);
                }
                List<Opportunity> newChildOpps= new List<Opportunity>();
                for(Billing_Account_Split__c ba: baList){
                    Opportunity o = masterOppty.clone(false,true,false,false);
                    if(masterOppty.Renewal_Flag__c == true)
                        o.name = 'Renewal [CHILD]- ' + ba.name + '-' + ba.Account__r.Name;   
                        //o.name = 'Renewal [CHILD]- ' + ba.name + '-' + masterOppty.Name;   
                    else
                        o.name = 'New [CHILD]- ' + ba.name + '-' + ba.Account__r.Name; 
                        //o.name = 'New [CHILD]- ' + ba.name + '-' + masterOppty.Name; 
                    o.AccountId = ba.Account__c;          
                    o.Amount = ba.Subtotal_Amount__c;              
                    o.Is_Master_Opportunity__c = false;             
                    o.Master_Opportunity__c = theId.escapeHtml4();
                    o.Oppty_Mgmt_Type__c = 'Split Billing';
                    o.StageName = masterOppty.StageName;
                    o.CloseDate = masterOppty.closeDate;
                    o.Description= ba.Opportunity_Notes__c;
                    o.Billing_Account_Id__c = ba.id;
                    o.pricebook2Id = masterOppty.pricebook2Id;
                    o.Milestones__c = masterOppty.Milestones__c; //MCL-2021
                    o.Sub_Category_2__c =masterOppty.Sub_Category_2__c;//MCL-2021
                    newChildOpps.add(o);                
                    system.debug('***CO Id' +o.id);
                    BAIdSet.add(ba.id);
    
                }
                try{
                    if(!newChildOpps.isEmpty())
                    System.debug('@@@ Before Inserting CHild Oppty');
                        insert newChildOpps;            
                    System.debug('@@@ After Inserting CHild Oppty');       
                    
                    masterOppty.Is_Master_Opportunity__c = true;
                    masterOppty.Oppty_Mgmt_Type__c = 'Split Billing';
                    update masterOppty;
                
                }catch(DMLException dmlex){            
                    system.debug('***Exception occured' + dmlex.getMessage());                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,dmlex.getMessage()));
                }
                
                //update Child Opportunity field for Billing accounts
                Map<id,Opportunity> BACOMap= new Map<id,Opportunity>();
                for(Opportunity o: [SELECT Billing_Account_Id__c,Id From Opportunity where Billing_Account_Id__c IN :BAIdSet]){
                    BACOMap.put(o.Billing_Account_Id__c,o);
                    
                }
                
                system.debug('****BACOIdMap' +BACOMap);
                for(Billing_Account_Split__c ba: baList){
                    
                    if(BACOMap!= null && BACOMap.get(ba.id) != null){
                        ba.Child_Opportunity__c = BACOMap.get(ba.id).id;
                        baListUpd.add(ba);
                        CoIdBAMap.put(ba.Child_Opportunity__c,ba);
                        
                    }
                }
                if(!baListUpd.isEmpty()){
                    update baListUpd;
                }
                masterQuote.is_Master_Quote__c = true;       //701     
                update masterQuote; //701
                map<id,id> QuoteOpptymap = new map<id,id>();
                List<Quote> newQuoteLst = createChildQuotes(masterQuote,newChildOpps); //701   
                
                
              /*  if(!newQuoteLst.isEmpty()){  //If block commented by Piyali
                    for(Quote q:newQuoteLst){
                        QuoteOpptymap.put(q.OpportunityId,q.id);
                    }
                    system.debug('***QuoteOpptymap : ' + QuoteOpptymap);     
                    updateSynCQuoteList(QuoteOpptymap);
                 }  
               */
               
                //Copy Oppty Line Items to Child Opportunities
                createChildOpportunityLineItems(masterOppty,newChildOpps);  
               
               if(!newQuoteLst.isEmpty()){  //If block commented by Piyali
                    for(Quote q:newQuoteLst){
                        QuoteOpptymap.put(q.OpportunityId,q.id);
                    }
                    system.debug('***QuoteOpptymap : ' + QuoteOpptymap);     
                    updateSynCQuoteList(QuoteOpptymap);
                 }  
                 
              // createChildOpportunityLineItems(masterOppty,newChildOpps);
                //Making Master Oppty Quote as master Quote
                //masterQuote.is_Master_Quote__c = true;       //commented for 701     
                //update masterQuote; //commented for 701
                
                //Generate Child Quotes from master Quote
                //createChildQuotes(masterQuote,newChildOpps); //commented for 701 
                                // Redirect the user back to the original page           
                //Query Child Opportunities   
              
                //List<Opportunity> childOpps;            
                //childOpps = [SELECT Id FROM Opportunity Where Master_Opportunity__c= :theId];
                //system.debug('***childOpps::' +childOpps);
                system.debug('***childOpps::' +newChildOpps);

                copyContactRolesFromBAS(BACOMap,baList);
        
                //PageReference pageRef = new PageReference('/apex/OpportunityDetail?id='  +  theId  + '&sfdc.override=1');
                //if(!InConsoleView) {
                    PageReference pageRef = new PageReference('/apex/OpportunityDetail?id='  +  theId  + '&sfdc.override=1');
                    system.debug('******childOpps::' +pageRef );
                    return pageRef;
                 /*}
                 else {
                    return null;
                }*/
                //system.debug('******childOpps::' +pageRef );
                //return pageRef;
            }
            else if(masterOppty.Is_Child_Opportunity__c == true){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.MasterSaf_GCO_CO_Error));
                isError = true; //SFD-16 ~ Added by Piyali
                return null;
            }           
            else{            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Label.MasterSaf_GCO_Quote_Prevalidate_Error));
                isError = true; //SFD-16 ~ Added by Piyali
                return null;            
            }
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            isError = true; //SFD-16 ~ Added by Piyali
            return null; 
        }
    }
   
    //If any existing billign account split records are selected to generate Child opps, Existing Child Opps for the selected
    // Billing Account Split records will be deleted.
    private void deleteExistingChildOpps(set<id> childOppIds){
        try{
           //List<Opportunity> COListDel= [SELECT Id from Opportunity Where ID IN:childOppIds];
           List<Opportunity> COListDel= new List<Opportunity>();
           for(ID tempId : childOppIds){
               Opportunity tOpp = new Opportunity(id=tempId);
               COListDel.add(tOpp);
           }
           System.debug('@@@COListDel'+COListDel);
              
           if(!COListDel.isEmpty()){
                DELETE COListDel;
            }
        }
        catch(DMLException dmlEx){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,dmlEx.getMessage()));
                     
        }    
        
    }
    public PageReference goBackToOppty(){
        
        PageReference pageRef = new PageReference('/apex/OpportunityDetail?id='  +  theId  + '&sfdc.override=1');
        system.debug('******URL' +pageRef );
        return pageRef;
       
    }
    public void createChildOpportunityLineItems(Opportunity oParentOppty, List<Opportunity> newChildOpps){
    
        List<OpportunityLineItem> parentLineItems= [SELECT Id,Product2Id,OpportunityId,PricebookEntryId,Quantity,Activity_Type__c,Active_Status__c,
                                                Description,Incremental_Amount__c,List_Price__c, MOLI_id__c,Monthly_Charge__c,Surcharge_Prct__c,
                                                Renewal_Amount__c,Number_of_Contacts__c FROM OpportunityLineItem where OpportunityId = :oParentOppty.Id]; 
        //Shipping_Point__c,Storage_Location__c,,Activity_Type__c
        System.debug('0 &&&&&& My Value');
        List<OpportunityLineItem> childLineItems = new List<OpportunityLineItem>();
        Map<id,List<OpportunityLineItem>> ChildOpptyOLIListMap = new Map<id,List<OpportunityLineItem>>();
        System.debug('00 &&&&&& My Value');
        try{
            for(Opportunity co:newChildOpps){          
                ChildOpptyOLIListMap.put(co.Id , new List<OpportunityLineItem>(parentLineItems));            
            }
           System.debug('1 &&&&&& My Value');
            for(OpportunityLineItem pOLI:parentLineItems){
                System.debug('2 &&&&&& My Value'+ pOLI.MOLI_id__c);
                for(Opportunity co:newChildOpps){                
                    OpportunityLineItem cOLI = pOLI.Clone(false,true);
                    System.debug('@@@@@Active_Status__c'+cOLI.Active_Status__c);
                    cOLI.OpportunityId = co.Id;
                    System.debug(' 3 &&&&&& My Value'+ pOLI.MOLI_id__c);
                    cOLI.MOLI_id__c = pOLI.MOLI_id__c;
                    cOLI.Quantity = 1; 
                    string strBASCurr = CoIdBAMap.get(co.id).CurrencyISOCode;
                    if(strOppCurr!=strBASCurr){                     


                        if(cOLI.MOLI_id__c == CoIdBAMap.get(co.id).OLI_id_1__c)//SFD-1121 
                            cOLI.UnitPrice = getOpptyCurrencyEquivalantValue(CoIdBAMap.get(co.id).Product_1_Sales_Price__c,strOppCurr,strBASCurr);                        
                        else if(cOLI.MOLI_id__c == CoIdBAMap.get(co.id).OLI_id_2__c)
                            cOLI.UnitPrice = getOpptyCurrencyEquivalantValue(CoIdBAMap.get(co.id).Product_2_Sales_Price__c,strOppCurr,strBASCurr);
                        else if(cOLI.MOLI_id__c == CoIdBAMap.get(co.id).OLI_id_3__c)
                            cOLI.UnitPrice = getOpptyCurrencyEquivalantValue(CoIdBAMap.get(co.id).Product_3_Sales_Price__c,strOppCurr,strBASCurr);
                    }
                    else{
                        if(cOLI.MOLI_id__c == CoIdBAMap.get(co.id).OLI_id_1__c)
                            cOLI.UnitPrice = CoIdBAMap.get(co.id).Product_1_Sales_Price__c;                        
                        else if(cOLI.MOLI_id__c == CoIdBAMap.get(co.id).OLI_id_2__c)
                            cOLI.UnitPrice = CoIdBAMap.get(co.id).Product_2_Sales_Price__c;
                        else if(cOLI.MOLI_id__c == CoIdBAMap.get(co.id).OLI_id_3__c)
                            cOLI.UnitPrice = CoIdBAMap.get(co.id).Product_3_Sales_Price__c;
                    }
                 
                    childLineItems.add(cOLI);
                }
            }
            
            if(!childLineItems.isEmpty()){
                try{
                  system.debug('@@@ Before Inseting childLineItems : '+childLineItems);
                    insert childLineItems;
                    system.debug('@@@ After Inseting childLineItems : childLineItems : '+childLineItems);
                }Catch(DMLException dmlex)            
                {
                    system.debug('***Exception occured' + dmlex.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,dmlex.getMessage()));
                    
                } 
            }
        }
        Catch(Exception ex)            
        {
            system.debug('***Exception occured::' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            
        } 
       
    } 
    
    // Creates child Quote for each child opportunity from MAster Quote
    public List<Quote> createChildQuotes(Quote oMasterQuote, List<Opportunity> newChildOpps){
        System.debug('@@@@@ createChildQuotes');
        System.debug(' Step1***CoIdBAMap::' +CoIdBAMap);
        System.debug(' Step 2***newChildOpps::'+newChildOpps);
        List<Quote> newQuoteLst= new List<Quote>();
        for(Opportunity co: newChildOpps){
            Quote q= oMasterQuote.clone(false,true,false,false);  
            q.OpportunityId = co.Id;  
           // q.Name = q.Opportunity.Name + '_' + q.QuoteNumber;   
          //  q.Name = 'Renewal [CHILD]-' + CoIdBAMap.get(q.OpportunityId).name + '-' +CoIdBAMap.get(q.OpportunityId).Account__r.Name+ '_' + q.QuoteNumber;   
            q.primary_Quote__C = true;
            q.Master_Quote__c = oMasterQuote.id;            
            q.Pricing_Approval_Complete__c = true;   
            q.Pricing_Approval_Required__c = false;         
            q.Purchase_Order__c = CoIdBAMap.get(q.OpportunityId).PO_Number__c;            
            q.E_Billing_Contact__c = CoIdBAMap.get(q.OpportunityId).E_Billing_Contact__c;
            q.Boleto_Contact__c = CoIdBAMap.get(q.OpportunityId).Boleto_Contact__c;
            q.Invoice_Notes__c = CoIdBAMap.get(q.OpportunityId).Invoice_Notes__c;
            q.LATAM_Renewal_Division__c = oMasterQuote.LATAM_Renewal_Division__c;
            q.Is_Master_Quote__c = false;
            q.pricebook2Id = oMasterQuote.pricebook2Id;  
            q.Opportunity_Notes__c = CoIdBAMap.get(q.OpportunityId).Opportunity_Notes__c;          
            
            //DPS-16068
            q.Sold_To_Contact__c = oMasterQuote.Sold_To_Contact__c;
            q.Additional_E_Billing_contact_emails__c =  oMasterQuote.Additional_E_Billing_contact_emails__c;
            q.TID_Number__c = oMasterQuote.TID_Number__c;
            q.Reason__c = oMasterQuote.Reason__c ;
            q.Was_There_A_Competitor__c = oMasterQuote.Was_There_A_Competitor__c;
            q.Competitor_Name__c =  oMasterQuote.Competitor_Name__c;
            
            newQuoteLst.add(q);
        }
        
        if(!newQuoteLst.isEmpty()){
            try{
            System.debug('@@@ Before Inserting Quote'+newQuoteLst[0].isSyncing);
                insert newQuoteLst;
            System.debug('@@@ After Inserting Quote'+newQuoteLst[0].isSyncing);
                /*
                //Added this after July Release - 701
                map<id,id> QuoteOpptymap = new map<id,id>();
                //if(!newQuoteLst.isEmpty()){
                    for(Quote q:newQuoteLst){
                        QuoteOpptymap.put(q.OpportunityId,q.id);
                    }
                //}   
                system.debug('***QuoteOpptymap : ' + QuoteOpptymap);     
                updateSynCQuoteList(QuoteOpptymap);
                //Ends 701
                */
            }Catch(DMLException dmlex)            
            {
                system.debug('***Exception occured' + dmlex.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,dmlex.getMessage()));
                
            } 
            
        }
        return newQuoteLst;


    }  
    // Copies Opportunity Contact roles from MAster for Boleto and E-Billing to all child Opportunities.
    private void copyContactRolesFromBAS(Map<id,Opportunity> BACOMap,List<Billing_Account_Split__c> basList){    
        list<OpportunityContactRole> OCRLstToInsert= new list<OpportunityContactRole>();
        
        for(Billing_Account_Split__c bas: basList){
            system.debug('***BACOMap::-'+BACOMap);
            //for(Opportunity co: childOpps){
                OpportunityContactRole ocrInsert= new OpportunityContactRole();   
                if(bas.E_Billing_Contact__c != null)                        
                OCRLstToInsert.add(new OpportunityContactRole(Role= 'E-Billing Contact',ContactId= bas.E_Billing_Contact__c,opportunityId=BACOMap.get(bas.id).id));
                if(bas.Boleto_Contact__c != null)
                OCRLstToInsert.add(new OpportunityContactRole(Role= 'Boleto Contact',ContactId= bas.Boleto_Contact__c,opportunityId=BACOMap.get(bas.id).id));
                system.debug('****OCRLstToInsert::'+OCRLstToInsert);
            //}
        }
        if(!OCRLstToInsert.isEmpty()){
            insert OCRLstToInsert;    
        }
            
    }
    
    public Map<String, Double> getCurrencyConvRate(){
        if(currencyConvRateMap == null || currencyConvRateMap.size()==0){
            currencyConvRateMap = new Map<String, Double>();
            for(CurrencyType ct : [Select Id, ConversionRate, IsoCode from CurrencyType]){
                currencyConvRateMap.put(ct.IsoCode, ct.ConversionRate);
            }
            system.debug('@@ In getCurrencyConvRate function Again');
        }
        return currencyConvRateMap;
    } 
    public decimal getOpptyCurrencyEquivalantValue(decimal ValueinBASCurr,string strOppCurr,string strBASCurr){
          
        decimal decConvertAmt = (currencyConvRateMap.get(strOppCurr)/currencyConvRateMap.get(strBASCurr))*ValueinBASCurr;
        system.debug('**decConvertAmt' +decConvertAmt);
        return decConvertAmt ;
    }
 
    public void updateSynCQuoteList(MAP<ID,ID> QuoteOpptymap){
        map<Id,List<opportunitylineitem>> getOpplineitemMap = new map<Id,List<opportunitylineitem>>();
        map<Id,List<QuoteLineItem>> getQlineitemMap = new map<Id,List<QuoteLineItem>>();        
        list <QuoteLineItem> insertQuoteLineItemList = new list <QuoteLineItem>();//SFD-458
        //Ends
        try{
            List<opportunity> optyListtobeupdated = new List<opportunity>(); 
            getOpplineitemMap = createQuote.getOppLineItem(QuoteOpptymap.Keyset());
            System.debug('@@@ getOpplineitemMap'+ getOpplineitemMap);
            SET<Id> quoteIdSet= new SET<Id>();
            quoteIdSet.addAll(QuoteOpptymap.Values());
            getQlineitemMap = createQuote.getQuoteLineItem(quoteIdSet);   
            System.debug('@@@ getQlineitemMap'+getQlineitemMap);      
            List<Quote> QuoteListtobeupdated = new List<Quote>();
            list<opportunity> optyList = new list<opportunity>([select id, SyncedQuoteId,(select id,opportunityid,Primary_Quote__c,RecordTypeId from quotes) from opportunity where id IN:QuoteOpptymap.Keyset()]);
            for(opportunity oOpty:optyList){
                system.debug('QuoteSize'+oOpty.quotes.size());
                if(oOpty.quotes.size() ==1)
                {
                    quote oquote = oOpty.quotes[0];
                    oOpty.SyncedQuoteId = oQuote.id;
                    oQuote.Primary_Quote__c = true;
                    optyListtobeupdated.add(oOpty);
                    QuoteListtobeupdated.add(oQuote);
                    if(oquote.Id != null && getOpplineitemMap.containsKey(oOpty.id) && !getQlineitemMap.containsKey(oquote.Id)){
                        List<QuoteLineItem> qliLst= new List<QuoteLineItem>();
                        qliLst= createQuote.getQuoteLineItems(getOpplineitemMap.get(oOpty.id),oquote.Id);
                        insertQuoteLineItemList.addAll(qliLst);  
                    }                              
                }            
            }            
            system.debug('@@@ Before insertQuoteLineItemList' + insertQuoteLineItemList);  
            if(insertQuoteLineItemList!= null && !insertQuoteLineItemList.isEmpty())
                insert insertQuoteLineItemList; 
            system.debug('@@@After insertQuoteLineItemList' + insertQuoteLineItemList); 
             system.debug('@@@Before optyListtobeupdated' + optyListtobeupdated);
            if(!optyListtobeupdated.isEmpty())       
            {
               // update optyListtobeupdated; // Commented as part of MCL-2497
                String jsonOptyList = JSON.serialize(optyListtobeupdated);
                futureSyncOptyList(jsonOptyList);
            }   
            system.debug('@@@ After optyListtobeupdated' + optyListtobeupdated);     
        }
        catch(Exception e){
                System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
        }
        
    }    

    @future
    public static void futureSyncOptyList(String jsonOptyList){
        try{
            List<Opportunity> optyListupdate = (List<Opportunity>)JSON.deserialize(jsonOptyList,List<Opportunity>.class); 
            system.debug('$$$$$ before optyListupdate :'+optyListupdate);
            if(!optyListupdate.isEmpty()){
                update optyListupdate;
            }
            system.debug('$$$$$ after optyListupdate:' +optyListupdate);
        }catch(Exception e){
                System.debug(e+'$$$$$ Future Method Exception: '+e.getLinenumber()+e.getmessage());
        }
    }   

}