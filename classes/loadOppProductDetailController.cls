/**
 * Controller for load details vf page
 *
 * @author  Anshita Sharma
 * @version 2013-07-11
 */

/**
 * CHANGE HISTORY
 * ===============================================================================================================================
 * Date         Name                    Description
 * 2013-07-10   Anshita Sharma          Created        
 * 2016-03-28   Prathyush Reddy         Modified the total class according to requirement SFD-33   
 * 2016-11-14   Rajashree               Modified the class according to requirement SFD-1121(Duplicate Products to be considered)                                     
 * ===============================================================================================================================
 */
public with sharing class loadOppProductDetailController{
    public class MyException extends Exception {}
        
    public String opportunityId {get;set;}
    public Map<String,String> mapfieldTitles {get;set;}
    public Opportunity oOpportunity {get;set;}
    public RecordType oRecordType {get;set;}
    public map<Id,Contact> mapContacts {get;set;}
    public Account oAccount{get;set;}
    public boolean bQuickSave{get;set;}
    public String oppRedirectURl{get; set;}
    public Boolean isSales{get;set;}
    public String currentPageURL{get; set;}
    
    
    public String prdId{get;set;}
    public List<Contact> conList{get;set;}
    public List<SelectOption> conOptions{get;set;}
    public Integer selectedCon {get;set;}
    
    public Map<ID,OpportunityProductDetail__c> prodctDetailMap{get;set;}
    public Map<ID,List<Opportunity_Product_Detail_Contact__c>> mapOppDetailContacts{get;set;}
    public Set<OpportunityProductDetail__c> oppDetails{get;set;}
    public List<WrapDetail> tableDataList{set;get;}    
    public Map<ID,OpportunityProductDetail__c> productMap{set;get;}
    public Integer selectedProd{set;get;}
    public Set<Id> oliIdSet;
    public Map<Id,Id> oliIdMap;
    public Boolean isError;
    
    public loadOppProductDetailController(ApexPages.StandardController oStdController){
        /*isSales=false;
        isSidebar = false;
        isShowHeader = false;
        currentPageURL = Apexpages.currentPage().getUrl();
        if(String.isNotBlank(currentPageURL) && currentPageURL.contains('Frame')){
            isSales = false;
            isSidebar = false;
            isShowHeader = false;
        }else{
            isSales = true;
            isSidebar = true;
            isShowHeader = true;
        }*/
        
        if(oStdController.getId() == null){
            opportunityId = System.currentPageReference().getParameters().get('oppId');
            oppRedirectURl = System.URL.getSalesforceBaseUrl().toExternalForm()+opportunityId;
            //opportunityId = '006n0000005sDIF';
        }else{
            Id OppProductDetailId = oStdController.getId();
            OpportunityProductDetail__c oOppProductDetail = [Select Opportunity__c From OpportunityProductDetail__c Where ID =:OppProductDetailId];
            OpportunityId = oOppProductDetail.Opportunity__c;
        }
        
        initController();
        bQuickSave = false;
        conList = new List<Contact>();
        conOptions = new List<SelectOption>();
        isError = false;
    }
    
     
    public void initController(){
        oOpportunity = [Select Name, AccountId From Opportunity Where ID = :OpportunityId ];        
        //Initialize the Account
        oAccount = [Select Name From Account Where Id = :oOpportunity.AccountId];                   
        init();
    }

    public PageReference save(){
        isError = false;  
        List<Contact> constoUpdate = new List<Contact>();         
        List<Opportunity_Product_Detail_Contact__c> allOPDCList = new List<Opportunity_Product_Detail_Contact__c>(); 
        List<Opportunity_Product_Detail_Contact__c> deleteOPDCList = new List<Opportunity_Product_Detail_Contact__c>();
        List<OpportunityProductDetail__c> deletePrdDetails = new List<OpportunityProductDetail__c>();          
        Set<Id> contactsWithNoEmail = new Set<Id>();
        Set<String> setOLIid = new Set<String>();
        
        //insert product detail records for which currently Product details are not present
        List<OpportunityProductDetail__c> insPrdDetails = new List<OpportunityProductDetail__c>();    
        Set<ID> prodLIIds = new Set<ID>();    
        
        for(WrapDetail wdtl: tableDataList){
            
            //checking for the dplicate emails
            Set<String> emailSet = new Set<String>();
            //String strMoliId = String.valueOf(wdtl.oLIId).substring(0,15);
            setOLIid.add(String.valueOf(wdtl.oLIId).substring(0,15));
            for(WrapDetailContact wrpdtlc : wdtl.wrapDetailContactList){
            
             if(wrpdtlc.opdc.Email__c != null && wrpdtlc.opdc.Contact__c != null){
                 if(emailSet.contains(wrpdtlc.opdc.Email__c)){
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.Duplicate_Emails_Found));
                     return null;
                  }else{
                      emailSet.add(wrpdtlc.opdc.Email__c);
                  }  
             }
            
               
            }
            
            //getting the record details to insert productdetail records
            
            /*if(wdtl.prdDetail == null && wdtl.wrapDetailContactList[0].opdc.Contact__c !=null){
            prodLIIds.add(wdtl.oLIId);//Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]
            System.debug('@@@@@@yes added 4444!!'+wdtl.oLIId);
                insPrdDetails.add(new OpportunityProductDetail__c(Opportunity_Line_Item_Id__c=wdtl.oLIId,Product__c=wdtl.prodId,Account__c=oAccount.Id,Opportunity__c=opportunityId));//Opportunity_Line_Item_Id__c is assigned with OLI Id, no need of map ,SFD-1121 [Rajashree]
            }*/
            
        }
        
        System.debug('******OLI ID from wrapper:'+setOLIid);
        List<OpportunityLineItem> lstOli = new List<OpportunityLineItem>();
        Map<Id,Integer> mapProdContCount = new Map<Id,Integer>();
        lstOli = [Select Id, MOLI_id__c, Name, Product2.Name, Quantity, Number_of_Contacts__c from OpportunityLineItem where OpportunityId =: OpportunityId AND MOLI_id__c IN: setOLIid AND Entitlement_Oneshot__c = TRUE];
        System.debug('*****lstOli' + lstOli);
        System.debug('*****OpportunityId' + OpportunityId);
        if(lstOli != null && !lstOli.isEmpty()){
            for(OpportunityLineItem oli : lstOli){
                if(Integer.valueOf(oli.Quantity) == null){
                    mapProdContCount.put(oli.MOLI_id__c,0);    
                }
                else{
                    mapProdContCount.put(oli.MOLI_id__c,Integer.valueOf(oli.Quantity));
                }    
            }
        }
        System.debug('*****mapProdContCount' + mapProdContCount); 
        Map<Id,List<Opportunity_Product_Detail_Contact__c>> mapProdContact = new Map<Id,List<Opportunity_Product_Detail_Contact__c>>();
        system.debug('*****OPD wrapper:'+ tableDataList);
        for(WrapDetail wdtl: tableDataList){ 
            //checking for the number of contacts: PTL-59
            system.debug('*****OPDC wrapper:'+wdtl.wrapDetailContactList);            
            for(WrapDetailContact wrpdtlc : wdtl.wrapDetailContactList){
                System.Debug('*****OPD*****>>'+wrpdtlc.opdc.Product_Detail__c+'<<*****Line Item ID*******>>'+wrpdtlc.opdc.Product_Detail__r.Opportunity_Line_Item_Id__c);
                //System.debug('*****mapProdContact.keySet()****'+mapProdContact.keySet().contains(opdc.Product_Detail__r.Opportunity_Line_Item_Id__c));
                if(wrpdtlc.opdc.Contact__c != null){
                    if(mapProdContact.keySet().contains(wdtl.oLIId)){
                        //System.debug('***111 allOPDCList' + allOPDCList);
                        //mapProdContact.get(opdc.Product_Detail__r.Opportunity_Line_Item_Id__c).add(opdc);
                        mapProdContact.get(wdtl.oLIId).add(wrpdtlc.opdc);
                    }
                    else{
                        List<Opportunity_Product_Detail_Contact__c> lstOpPrdDtlCon = new  List<Opportunity_Product_Detail_Contact__c>();
                        lstOpPrdDtlCon.add(wrpdtlc.opdc);
                        System.debug('*****opdc.Product_Detail__r' + wrpdtlc.opdc.Product_Detail__c);
                        System.debug('***opdc.Product_Detail__r.Opportunity_Line_Item_Id__c' + wrpdtlc.opdc.Product_Detail__r.Opportunity_Line_Item_Id__c);
                        //mapProdContact.put(opdc.Product_Detail__r.Opportunity_Line_Item_Id__c,lstOpPrdDtlCon);
                        mapProdContact.put(wdtl.oLIId, lstOpPrdDtlCon);
                        //lstOpdtcon.add(opCntc);
                        //System.debug('***222 allOPDCList' + allOPDCList);
                    }
                    
                }
            }            
            if(mapProdContact.get(wdtl.oLIId) != null){
                if(wdtl.prdDetail == null && mapProdContact.get(wdtl.oLIId).size() > 0){
                prodLIIds.add(wdtl.oLIId);//Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]
                System.debug('@@@@@@yes added 4444!!'+wdtl.oLIId);
                    insPrdDetails.add(new OpportunityProductDetail__c(Opportunity_Line_Item_Id__c=wdtl.oLIId,Product__c=wdtl.prodId,Account__c=oAccount.Id,Opportunity__c=opportunityId));//Opportunity_Line_Item_Id__c is assigned with OLI Id, no need of map ,SFD-1121 [Rajashree]
                }
            }
        }
        if(mapProdContCount != null && !mapProdContCount.isEmpty()){
            if(mapProdContact != null && !mapProdContact.isEmpty()){
                for(Id idMoliId : mapProdContact.keySet()){
                    System.debug('***mapProdContact.get(idMoliId).size()' + mapProdContact.get(idMoliId).size());
                    if(mapProdContact.get(idMoliId).size() != 0){
                        if(mapProdContact.get(idMoliId).size() > mapProdContCount.get(idMoliId)){
                            System.debug('*****mapProdContact.get(idMoliId).size()' + mapProdContact.get(idMoliId).size());
                            System.debug('*****mapProdContCount.get(idMoliId)' + mapProdContCount.get(idMoliId));
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.Prod_Contact_Count_Check));
                            isError = true;
                            //setProdNoCont.add(idMoliId);
                            //System.debug('*****setProdNoCont' + setProdNoCont);
                            return null;   
                        }
                    }                
                } 
            }
        }
        INSERT insPrdDetails;
        
        System.debug('@@@@@ Insert Details'+insPrdDetails);
        //get the new product detail records(ID) associated with the product, assuming that only PrductDetail for one Product
        Map<ID,OpportunityProductDetail__c> newOpdtlMap = new Map<ID,OpportunityProductDetail__c>();
        for(OpportunityProductDetail__c opDtl : [SELECT ID,Opportunity_Line_Item_Id__c, Account__c, Product__r.Name, Product__c FROM OpportunityProductDetail__c Where Opportunity__c =:OpportunityId and Opportunity_Line_Item_Id__c IN :prodLIIds]){//Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]
            newOpdtlMap.put(opDtl.Opportunity_Line_Item_Id__c, opDtl);//Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]
        }
        System.debug('@@@@@ newOpdtlMap'+newOpdtlMap);
        
        //update the corresponding product detail contact records with the new product detail ID
        for(WrapDetail wdtl: tableDataList){
            OpportunityProductDetail__c opdetail = newOpdtlMap.get(wdtl.oLIId);
            System.debug('@@@@@ opdetail '+opdetail );
            if(opdetail!=null){
                wdtl.prdDetail = opdetail.ID;
                List<WrapDetailContact> newWrapDtlContacts = new List<WrapDetailContact>();
                for(WrapDetailContact wrpdtlc : wdtl.wrapDetailContactList){
                    wrpdtlc.opdc.Product_Detail__c = opdetail.Id;
                    newWrapDtlContacts.add(wrpdtlc);
                }
                wdtl.wrapDetailContactList = newWrapDtlContacts;
                tableDataList[wdtl.rowNumber] = wdtl;
            }
        }        
        for(WrapDetail wdtl: tableDataList){
            System.debug('*****tableDataList' + tableDataList);
            System.debug('*****wdtl.wrapDetailContactList' + wdtl.wrapDetailContactList); 
            Integer totValidPrdContacts = 0, emptyWrpdtlcCount = 0 ;  
            List<WrapDetailContact> wrpContactList = new List<WrapDetailContact>();
            for(WrapDetailContact wrpdtlc : wdtl.wrapDetailContactList){
               // System.debug(wrpdtlc.opdc.Product_Detail__c+'~~~~~~~~'+wrpdtlc.opdc.Contact__c+'~~~~~~~~'+mapContacts.get(wrpdtlc.opdc.Contact__c)+'~~~~~~'+mapContacts.get(wrpdtlc.opdc.Contact__c).Email);
                if(wrpdtlc.opdc.Product_Detail__c <> null && mapContacts.get(wrpdtlc.opdc.Contact__c)<>null){
                    if (mapContacts.get(wrpdtlc.opdc.Contact__c).Email == null) {
                        System.debug('coming here for contact update');
                        if(!contactsWithNoEmail.contains(wrpdtlc.opdc.Contact__c)){
                            constoUpdate.add(new Contact(Id = wrpdtlc.opdc.Contact__c, Email = wrpdtlc.opdc.Email__c));
                            contactsWithNoEmail.add(wrpdtlc.opdc.Contact__c);
                        }
                    }
                     allOPDCList.add(wrpdtlc.opdc); 
                }

                if(wrpdtlc.opdc.Contact__c == null&&wrpdtlc.opdc.ID<>null){
                    deleteOPDCList.add(new Opportunity_Product_Detail_Contact__c(ID=wrpdtlc.opdc.ID));
                    wrpdtlc.opdc.ID = null; 
                }
                if(wrpdtlc.opdc.Contact__c == null){
                    emptyWrpdtlcCount++;
                }
                 wrpContactList.add(wrpdtlc);
            }
            if(wdtl.wrapDetailContactList.size() - emptyWrpdtlcCount < 1){
                if(wdtl.prdDetail<>null){
                   deletePrdDetails.add(new OpportunityProductDetail__c(ID=wdtl.prdDetail));
                   wdtl.prdDetail = null;
                }
            }
            wdtl.wrapDetailContactList = wrpContactList; 
            tableDataList[wdtl.rowNumber] = wdtl;
            
        }        
        /* ****** Added by Priyanka as a part of PTL 59 Start ******* */        
        /*
        Set<String> setMoliId = new Set<String>();
        Set<Id> setProdNoCont = new Set<Id>(); 
        map<id, id> mapOPD_OLI = new map<id, id>();
        if(tableDataList != null && !tableDataList.isEmpty()){
            for(WrapDetail wdtl: tableDataList){
                System.debug('*****wdtl.oLIId' + wdtl.oLIId);
                String strMoliId = String.valueOf(wdtl.oLIId).substring(0,15);
                System.debug('*****strMoliId' + strMoliId);
                setMoliId.add(strMoliId);
                setProdNoCont.add(wdtl.prdDetail);
                System.debug('*****setProdNoCont' + setProdNoCont);
                if(!mapOPD_OLI.keySet().contains(wdtl.prdDetail)){
                    mapOPD_OLI.put(wdtl.prdDetail ,wdtl.oLIId);
                }
                System.debug('*****setMoliId' + setMoliId);    
            }
        }
        system.debug('*****mapOPD_OLI******'+mapOPD_OLI);
        
        List<OpportunityLineItem> lstOli = new List<OpportunityLineItem>();
        Map<Id,Integer> mapProdContCount = new Map<Id,Integer>();
        lstOli = [Select Id, MOLI_id__c, Name, Product2.Name, Quantity, Number_of_Contacts__c from OpportunityLineItem where OpportunityId =: OpportunityId AND MOLI_id__c IN: setMoliId];
        System.debug('*****lstOli' + lstOli);
        System.debug('*****OpportunityId' + OpportunityId);
        if(lstOli != null && !lstOli.isEmpty()){
            for(OpportunityLineItem oli : lstOli){
                if(Integer.valueOf(oli.Quantity) == null){
                    mapProdContCount.put(oli.MOLI_id__c,0);    
                }
                else{
                    mapProdContCount.put(oli.MOLI_id__c,Integer.valueOf(oli.Quantity));
                }    
            }
        }
        System.debug('*****mapProdContCount' + mapProdContCount);       
        
        
        Map<Id,List<Opportunity_Product_Detail_Contact__c>> mapProdContact = new Map<Id,List<Opportunity_Product_Detail_Contact__c>>();
        System.debug('*******allOPDCList******'+allOPDCList);
        if(allOPDCList != null && !allOPDCList.isEmpty()){
            for(Opportunity_Product_Detail_Contact__c opdc : allOPDCList){
                System.Debug('*****OPD*****>>'+opdc.Product_Detail__c+'<<*****Line Item ID*******>>'+opdc.Product_Detail__r.Opportunity_Line_Item_Id__c);
                System.debug('*****mapProdContact.keySet()****'+mapProdContact.keySet().contains(opdc.Product_Detail__r.Opportunity_Line_Item_Id__c));
                if(mapProdContact.keySet().contains(mapOPD_OLI.get(opdc.Product_Detail__c))){
                     System.debug('***111 allOPDCList' + allOPDCList);
                    //mapProdContact.get(opdc.Product_Detail__r.Opportunity_Line_Item_Id__c).add(opdc);
                    mapProdContact.get(mapOPD_OLI.get(opdc.Product_Detail__c)).add(opdc);
                }
                else{
                    List<Opportunity_Product_Detail_Contact__c> lstOpPrdDtlCon = new  List<Opportunity_Product_Detail_Contact__c>();
                    lstOpPrdDtlCon.add(opdc);
                    System.debug('*****opdc.Product_Detail__r' + opdc.Product_Detail__c);
                    System.debug('***opdc.Product_Detail__r.Opportunity_Line_Item_Id__c' + opdc.Product_Detail__r.Opportunity_Line_Item_Id__c);
                    //mapProdContact.put(opdc.Product_Detail__r.Opportunity_Line_Item_Id__c,lstOpPrdDtlCon);
                    mapProdContact.put(mapOPD_OLI.get(opdc.Product_Detail__c), lstOpPrdDtlCon);
                    //lstOpdtcon.add(opCntc);
                     System.debug('***222 allOPDCList' + allOPDCList);
                }     
            }
        }
        List<OpportunityProductDetail__c> lstProdDets = new List<OpportunityProductDetail__c>();
        List<OpportunityProductDetail__c> lstProdDetsCont1 = new List<OpportunityProductDetail__c>();        
        System.debug('***333 allOPDCList' + allOPDCList);
        System.debug('***mapProdContact' + mapProdContact);        
        if(mapProdContact != null && !mapProdContact.isEmpty()){
            for(Id idMoliId : mapProdContact.keySet()){
                System.debug('***mapProdContact.get(idMoliId).size()' + mapProdContact.get(idMoliId).size());
                if(mapProdContact.get(idMoliId).size() != 0){
                    if(mapProdContact.get(idMoliId).size() > mapProdContCount.get(idMoliId)){
                        System.debug('*****mapProdContact.get(idMoliId).size()' + mapProdContact.get(idMoliId).size());
                        System.debug('*****mapProdContCount.get(idMoliId)' + mapProdContCount.get(idMoliId));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.Prod_Contact_Count_Check));
                        isError = true;
                        //setProdNoCont.add(idMoliId);
                        //System.debug('*****setProdNoCont' + setProdNoCont);
                        //return null;   
                    }
                }                
            }                       
            if(isError){
                System.debug('*****setProdNoCont' + setProdNoCont);
                List<OpportunityProductDetail__c> lstProdDetsCont2 = new List<OpportunityProductDetail__c>();
                lstProdDetsCont2 = [SELECT Id FROM OpportunityProductDetail__c WHERE Id IN: setProdNoCont];
                System.debug('*****lstProdDetsCont2' + lstProdDetsCont2);             
                lstProdDets = [SELECT Id, (SELECT Id FROM Opportunity_Product_Detail_Contacts__r) FROM OpportunityProductDetail__c WHERE Id IN: setProdNoCont];
                System.debug('*****lstProdDets' + lstProdDets);
                for(OpportunityProductDetail__c opdc : lstProdDets){
                    System.debug('*****opdc.Opportunity_Product_Detail_Contact__r.size()' + opdc.Opportunity_Product_Detail_Contacts__r.size());
                    if(opdc.Opportunity_Product_Detail_Contacts__r.size() == 0){
                        lstProdDetsCont1.add(opdc);    
                    }
                }
                delete lstProdDetsCont1;
                initController();
                return null;
            }
        }
        System.debug('*****mapProdContact' + mapProdContact); 
        */      
        /* ****** Added by Priyanka as a part of PTL 59 End ******* */
        //lstProdDetsCont = [SELECT Id FROM OpportunityProductDetail__c WHERE Id IN: setProdNoCont];
        try{
            System.debug('*****allOPDCList' + allOPDCList);
            if(!isError){                
                upsert allOPDCList;
                update constoUpdate;  
                delete deleteOPDCList;
                delete deletePrdDetails;
            }
            if(bQuickSave){ 
                bQuickSave = false;           
                return null;
            }
            else{
                return new PageReference('/' +opportunityId );
            }
        }catch(Exception e){
            if(e.getMessage().contains('DUPLICATE_VALUE'))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.Duplicate_Emails_Found));
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.Email_Cannot_be_Empty));   
            return null;   
        }
    }
    
    public PageReference cancel(){
        PageReference ref = null;
        ref = new PageReference('/' +opportunityId );
        ref.setRedirect(true);
        return ref;
    }
    /*public PageReference cancel1(){
        PageReference ref = null;
        ref = new PageReference('/' +opportunityId );
        ref.setRedirect(true);
        return ref;
    }*/
    
    public void quickSave(){
        bQuickSave = true;
        save();
        bQuickSave = false;
    }
    
    
    
    private void init(){
    
        List<ID> oppLIIds = new List<ID>();
        Set<ID> productIdsWithNoDetail = new Set<ID>();
        mapContacts = new map<Id,Contact>([Select Name, Email,SAP_Contact_ID__c  From Contact Where AccountId = :oAccount.Id Order By Name LIMIT 999]);
     
        mapOppDetailContacts = new Map<ID,List<Opportunity_Product_Detail_Contact__c>>();
        oliIdMap = new Map<Id,Id>();

        oliIdSet = new Set<Id>();
        for(OpportunityLineItem ol : [Select Id,Product2Id,PricebookEntry.Product2.Name,OpportunityId From OpportunityLineItem where OpportunityId =:opportunityId]){
        //    oliIdMap.put(ol.Product2Id,ol.Id); No need of this map ,SFD-1121 [Rajashree]
            oppLIIds.add(ol.Id);//Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]
        }

        //prepare Product__c to ProductDetails map
        Map<ID,OpportunityProductDetail__c> topDetailMap = new Map<ID,OpportunityProductDetail__c>();
        productIdsWithNoDetail.addAll(oppLIIds);
        Set<ID> topProdDetailIds = new Set<ID>();
        for(OpportunityProductDetail__c opDtl : [SELECT ID,Opportunity_Line_Item_Id__c, Account__c, Product__r.Name, Product__c FROM OpportunityProductDetail__c Where Opportunity__c =:OpportunityId and Opportunity_Line_Item_Id__c IN :oppLIIds]){//Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]
            topProdDetailIds.add(opDtl.Id);
            topDetailMap.put(opDtl.Opportunity_Line_Item_Id__c,opDtl);
           if(productIdsWithNoDetail.contains(opDtl.Opportunity_Line_Item_Id__c))  productIdsWithNoDetail.remove(opDtl.Opportunity_Line_Item_Id__c); //Using OLI ID instead of Product2Id ,SFD-1121 [Rajashree]           
        }
        Map<ID,List<Opportunity_Product_Detail_Contact__c>> topDetailContactsMap = new Map<ID,List<Opportunity_Product_Detail_Contact__c>>();

        //prepare ProductDetail to ProductDetailContacts map
        for(Opportunity_Product_Detail_Contact__c oppDtlContact : [SELECT Contact__c ,Contact__r.Email, Email__c, Product_Detail__r.Product__c,Product_Detail__c, SAP_Contact_ID__c, Product_Detail__r.Opportunity_Line_Item_Id__c  FROM Opportunity_Product_Detail_Contact__c Where Product_Detail__c IN :topProdDetailIds]){ //Added By Priyanka
           List<Opportunity_Product_Detail_Contact__c> tempContacts = topDetailContactsMap.get(oppDtlContact.Product_Detail__c);
           if(tempContacts == null)
               tempContacts = new List<Opportunity_Product_Detail_Contact__c>(); 
           tempContacts.add(oppDtlContact);   
           
           topDetailContactsMap.put(oppDtlContact.Product_Detail__c,tempContacts);

        }                

        
        //preparing table data
        tableDataList = new List<WrapDetail>();        
        Boolean headerReq = true;
        Integer rowNumber = 0;
        for(ID opLIId : oppLIIds){
           WrapDetail wdtl;
           Boolean isFirst = true;
           List<WrapDetailContact> wrpdtlList = new List<WrapDetailContact>();
           List<OpportunityLineItem> lstOLI =[SELECT Id, Product2Id from OpportunityLineItem WHERE id =:opLIId ]; 
           if(productIdsWithNoDetail.contains(opLIId)){
               WrapDetailContact wrpdtl;
               if(isFirst){ 
                   wrpdtl = new WrapDetailContact(new OpportunityProductDetail__c(Product__c=lstOLI[0].Product2Id,Account__c=oAccount.Id,Opportunity__c=opportunityId),new Opportunity_Product_Detail_Contact__c(),wrpdtlList.size());           
                   isFirst = false;
               }else{
                   wrpdtl = new WrapDetailContact(null,new Opportunity_Product_Detail_Contact__c(),wrpdtlList.size());                          
               }
               wrpdtlList.add(wrpdtl);
               wdtl = new WrapDetail(headerReq,rowNumber,null,lstOLI[0].Product2Id,wrpdtlList,opLIId);
               System.debug('@@@@@ prodwithNODetail block'+wdtl);
           }else{
               OpportunityProductDetail__c oprdtl =  topDetailMap.get(opLIId);
                
              if(topDetailContactsMap.get(oprdtl.ID) != null){
               if(topDetailContactsMap.get(oprdtl.ID).size()>0){
               
                   for(Opportunity_Product_Detail_Contact__c opdc : topDetailContactsMap.get(oprdtl.ID)){
                       WrapDetailContact wrpdtl;
                       if(isFirst){ 
                           wrpdtl = new WrapDetailContact(oprdtl,opdc,wrpdtlList.size());
                           isFirst = false;
                       }else{
                           wrpdtl = new WrapDetailContact(null,opdc,wrpdtlList.size());
                       }                        
                       wrpdtlList.add(wrpdtl);    
                       System.debug('@@@@@ wrpdtl'+wrpdtl); 
                       System.debug('@@@@@ wrpdtlList'+wrpdtlList); 
                   }
               }
               
               else{
                   WrapDetailContact wrpdtl;
                   if(isFirst){
                       wrpdtl = new WrapDetailContact(oprdtl,new Opportunity_Product_Detail_Contact__c(Product_Detail__c=oprdtl.Id),wrpdtlList.size());
                       isFirst = false;
                   }else{
                       wrpdtl = new WrapDetailContact(null,new Opportunity_Product_Detail_Contact__c(Product_Detail__c=oprdtl.Id),wrpdtlList.size());
                   }                         
                   wrpdtlList.add(wrpdtl);     
                   System.debug('@@@@@ wrpdtl'+wrpdtl); 
                   System.debug('@@@@@ wrpdtlList'+wrpdtlList);                    
               }
              }
              else{
                   WrapDetailContact wrpdtl;
                   if(isFirst){
                       wrpdtl = new WrapDetailContact(oprdtl,new Opportunity_Product_Detail_Contact__c(Product_Detail__c=oprdtl.Id),wrpdtlList.size());
                       isFirst = false;
                   }else{
                       wrpdtl = new WrapDetailContact(null,new Opportunity_Product_Detail_Contact__c(Product_Detail__c=oprdtl.Id),wrpdtlList.size());
                   }                         
                   wrpdtlList.add(wrpdtl);   
                   System.debug('@@@@@ wrpdtl'+wrpdtl); 
                   System.debug('@@@@@ wrpdtlList'+wrpdtlList);                    
               }
               
               wdtl = new WrapDetail(headerReq,rowNumber,oprdtl.ID,lstOLI[0].Product2Id,wrpdtlList,opLIId);
               System.debug('@@@@@ prodwithDetail block'+wdtl);
          }
          headerReq = false;
          rowNumber++;
          System.debug('@@@@@@@ Before wdtl'+wdtl);
          tableDataList.add(wdtl);
          System.debug('@@@@@@@ After wdtl'+wdtl);
          System.debug('@@@@@@@Table Data List'+tableDataList);
          
        }
        
    }
    

    
    public class WrapDetailContact{
       public OpportunityProductDetail__c opdetail{get;set;}
       public Opportunity_Product_Detail_Contact__c opdc{get;set;}
       public Integer rowNumber {get;set;}
       WrapDetailContact(OpportunityProductDetail__c opdetail, Opportunity_Product_Detail_Contact__c opdc, Integer rowNum){
            this.opdetail = opdetail;
            this.opdc = opdc;
            this.rowNumber = rowNum;
        }
        
    }
    
   
   public class WrapDetail{
       public Boolean header{get;set;}
       public Integer rowNumber{set;get;}
       public Id prdDetail{get;set;}
       public Id prodId{get;set;}
       public Id oLIId{get;set;} //Adding a new variable OLI ID  ,SFD-1121 [Rajashree]
       public List<WrapDetailContact> wrapDetailContactList{get;set;}
       WrapDetail(Boolean header,Integer rowNumber,Id prdDetail,Id prodId, List<WrapDetailContact> wrapDetailContactList,Id oLIId){//SFD- 1121
           this.header= header;
           this.rowNumber = rowNumber;
           this.prdDetail = prdDetail;
           this.prodId = prodId;
           this.oLIId = oLIId;//1121
           this.wrapDetailContactList = wrapDetailContactList;
       }
   }

    /**
    * 
    */
    public List<SelectOption> getContactSelectOptions() {
        List<SelectOption> listContactSelectOptions = new List<SelectOption>();
        
        listContactSelectOptions.add(new SelectOption('','-- None --'));
        for(Contact oContact : mapContacts.Values()){
            listContactSelectOptions.add(new SelectOption(oContact.ID,oContact.Name));
        }
        return listContactSelectOptions;
    }

    public void addContact(){ 
       WrapDetail wpdtl = tableDataList[selectedProd];
       List<WrapDetailContact> wpdContacts = wpdtl.wrapDetailContactList;
       if(wpdContacts == null){
           wpdContacts = new List<WrapDetailContact>();
       }    
       WrapDetailContact wdetailc = new WrapDetailContact(null,new Opportunity_Product_Detail_Contact__c(Product_Detail__c=wpdtl.prdDetail), wpdContacts.size());
       wpdContacts.add(wdetailc);
       wpdtl.wrapDetailContactList = wpdContacts;
       tableDataList[selectedProd] = wpdtl;

    }
    
    public void handleContactChange() {
        //System.debug(selectedProd + ';' + selectedCon);
        WrapDetail wpdtl = tableDataList[selectedProd];
        if (wpdtl.wrapDetailContactList == null) return;
        WrapDetailContact wdetailc = wpdtl.wrapDetailContactList[selectedCon];
        wdetailc.opdc.Email__c = (wdetailc.opdc.Contact__c <> null) ? mapContacts.get(wdetailc.opdc.Contact__c).Email : '';
    }
}