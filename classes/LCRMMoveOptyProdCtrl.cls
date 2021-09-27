/*
===============================================================================
LCRMOpportunitySplitController
===============================================================================

PURPOSE: Controller Class for LCRMOpportunitySplit Page

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2017-06-20      Rajesh                  Created 
===============================================================================
*/
public class LCRMMoveOptyProdCtrl {
    //Properties
    public Opportunity opp {get;set;}//source opp record
    public PagingOpportunity pagOppObj{get;set;}//this property is used for pagination of Opportunity List on UI
    public Boolean showProducts{get;set;}//flag to control products section visibilty on UI
    public Boolean showOpps{get;set;}//flag used to control Opp section visiblity on UI
    public Set<String> exlStagesSet{get;set;}
    
    //contructor
    public LCRMMoveOptyProdCtrl(ApexPages.StandardController controller){
        showProducts = false;
        showOpps = true;
        try{
            Id oppID = ((Opportunity)controller.getRecord()).ID;
            opp = [SELECT ID, Name, StageName, Expected_End_Date__c, LCRM_Sub_BU__c, accountID, Expiration_Date__c, Is_GLI__c, CurrencyIsoCode, LCRM_Split_On__c, LCRM_Transaction_Type__c, LCRM_Target_Opportunity__c, ContractId, Renewal_Flag__c FROM OPPORTUNITY WHERE ID = :oppID];
            pagOppObj = new PagingOpportunity();
            pagOppObj.oppRec = opp;
            String keyLabel = 'LCRMMergeOpportunityExcludeStage';
            List<String> exlStagesList = (KeyValueListStore__c.getValues(keyLabel) == null || 
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c == null || 
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c == '')?
                                   new List<String>():
                                   KeyValueListStore__c.getValues(keyLabel).TextValue__c.split(',');
            exlStagesSet = new Set<String>();
            exlStagesSet.addAll(exlStagesList);
            pagOppObj.exlStagesSet = exlStagesSet;
            if(exlStagesSet!=null && !exlStagesSet.contains(opp.StageName)){
                showOpps = true;
            }else{
                showOpps = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_MergeOppPageStageErrMsg));
            }
        }catch(Exception e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception trace : '+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
    }
    
    //method used to toggle showProducts for Product section visibility on UI
    public void showProducts(){
        if(showProducts == true)showProducts = false;
        else showProducts = true;
    }
    
    //method used get list of product that will be displayed on UI
    public List<OpportunityLineItem> getOppProdList(){
        List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();
        if(opp != null && opp.id != null){
            try{
                oppProdList = [SELECT ID , Product2ID, Product2.Name, LCRM_Product_Category__c, LCRM_Product_Type__c, LCRM_Action__c, LCRM_Units__c, LCRM_Current_ACV__c, LCRM_New_ACV_SalesPrice__c, LCRM_Incremental_Amount__c, LCRM_Source_Opportunity__c FROM OPPORTUNITYLINEITEM WHERE OPPORTUNITYID = :opp.ID];
            }catch(Exception e){
                System.debug('Exception : '+e.getMessage());
                System.debug('Exception trace : '+e.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }
            if((oppProdList == NULL || oppProdList.size()<=0) && showOpps == true){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_MergeOppNoProdError));
            }
        }
        return oppProdList;
    }
    
    //method used to show target opp product details on popup
    public List<OPPORTUNITYLINEITEM> getSelOppProdDetails(){
        List<OPPORTUNITYLINEITEM> oliList = new List<OPPORTUNITYLINEITEM>();
        if(pagOppObj.selectOpp !=null && pagOppObj.selectOpp!=''){
            Opportunity selOpp = getSelOppDetails();
            List<OPPORTUNITYLINEITEM> tempTarOliList;
            Set<ID> prodIdSet = new Set<ID>();
            if(selOpp!=null){
                tempTarOliList = selOpp.OPPORTUNITYLINEITEMS;
            }
            if(tempTarOliList!=null && tempTarOliList.size()>0){
                oliList.addAll(tempTarOliList);
                for(OPPORTUNITYLINEITEM oli : tempTarOliList){
                    prodIdSet.add(oli.Product2Id);
                }
            }
            List<OPPORTUNITYLINEITEM> tempSourceOliList = getOppProdList();
            if(tempSourceOliList != null && tempSourceOliList.size()>0){
                for(OPPORTUNITYLINEITEM oli : tempSourceOliList){
                    //if(!prodIdSet.contains(oli.Product2Id)){
                        oliList.add(oli);
                    //}
                    prodIdSet.add(oli.Product2Id);
                }
            }
        }
        return oliList;
    }
    
    //method used to get target opp details to be showed on popup
    public Opportunity getSelOppDetails(){
        Opportunity selOpp = new Opportunity();
        if(pagOppObj.selectOpp !=null && pagOppObj.selectOpp!=''){
            selOpp = [SELECT NAME, Account.Name, StageName, LCRM_Transaction_Type__c, Expected_Start_Date__c, Expected_End_Date__c, LCRM_Total_New_ACV_Sales_Price__c, Renewal_Flag__c, LCRM_Sub_BU__c,(SELECT ID , Product2ID, Product2.Name, LCRM_Product_Category__c, LCRM_Product_Type__c, LCRM_Action__c, LCRM_Units__c, LCRM_Current_ACV__c, LCRM_New_ACV_SalesPrice__c, LCRM_Incremental_Amount__c, LCRM_Source_Opportunity__c FROM OPPORTUNITYLINEITEMS) FROM OPPORTUNITY WHERE ID = :pagOppObj.selectOpp];
        }
        return selOpp;
    }
    
    //method used to retrieve list of OLI that will be transferred to target Opportunity
    public List<OpportunityLineItem> getOppProdForTransfer(String oppID){
        List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();
        String objectName = 'OpportunityLineItem';  
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        for(String s : objectFields.keySet()) {
           if(s.toLowerCase() =='unitprice'){
               continue;
           }
           query += ' ' + s + ',';
        }
        
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
        
        query += ' FROM ' + objectName;
        
        query += ' WHERE OpportunityID = \''+oppID+'\''; 
        System.debug('Query : '+query);  
        try {
            oppProdList = database.query(query);
        }catch (QueryException e){
            System.debug('Exception : '+e.getMessage());
            System.debug('Exception trace : '+e.getStackTraceString());
            oppProdList = new List<OpportunityLineItem>();
        }
        return oppProdList;
    }
    
    //method that is used to tranfer OLI from source to target Opp 
    public PageReference transferProds(){
        System.debug('selectOpp : transferProds : '+pagOppObj.selectOpp);
        PageReference redirectPage = null;
        Savepoint sp;
        //condition to check if no target opp was selected
        if(pagOppObj.selectOpp == null || pagOppObj.selectOpp == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_MergeOppNoOppSelected));
        }
        else{
            try{
                List<OpportunityLineItem> oppProdList = getOppProdForTransfer(opp.ID);
                System.debug('oppProdList  : transferProds : '+oppProdList);
                //condition to check if no OLI are available for tranfer
                if(oppProdList == NULL || oppProdList.size()<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_MergeOppNoProdError));
                }else{
                    Opportunity selOpp = getSelOppDetails();
                    List<OPPORTUNITYLINEITEM> tempTarOliList;
                    Set<ID> prodIdSet = new Set<ID>();
                    tempTarOliList = selOpp.OPPORTUNITYLINEITEMS;
                    if(tempTarOliList!=null && tempTarOliList.size()>0){
                        for(OPPORTUNITYLINEITEM oli : tempTarOliList){
                            prodIdSet.add(oli.Product2Id);
                        }
                    }
                    List<OpportunityLineItem> oppProdCloneList = new List<OpportunityLineItem>();
                    for(OpportunityLineItem oli : oppProdList){
                        //if(!prodIdSet.contains(oli.Product2Id)){
                            OpportunityLineItem oliClone = oli.clone(true, true, false, false);
                            oliClone.ID= null;
                            oliClone.LCRM_Previous_Contract__c = opp.ContractID;
                            oliClone.LCRM_Source_Opportunity__c = oliClone.OpportunityID;
                            oliClone.OpportunityID = pagOppObj.selectOpp;
                            oppProdCloneList.add(oliClone);
                        //}
                        prodIdSet.add(oli.Product2Id);
                    }
                    System.debug('oppProdCloneList : transferProds : '+oppProdCloneList.size()+' : '+oppProdCloneList);
                    sp = Database.setSavepoint();
                    insert oppProdCloneList;
                    //oppProdList.add(new OpportunityLineItem());
                    delete oppProdList;
                    Opportunity oppUpdt = new Opportunity(ID=opp.ID, LCRM_Target_Opportunity__c=pagOppObj.selectOpp);
                    update oppUpdt;
                    redirectPage = new PageReference('/' + pagOppObj.selectOpp);
                } 
            }catch(Exception e){
                System.debug('Exception : '+e.getMessage());
                System.debug('Exception trace : '+e.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.LCRM_MergeOppProdMoveFailed + e.getMessage()));
                if(sp!=null)Database.rollback(sp);
            }
        }
        return redirectPage;
    }
    
    //wrapper class to handle pagination of Target Opportunity List
    public class PagingOpportunity{
        //List<OppWrapper> oppWrapList{get;set;}
        //page size is dynamically set using custom settings
        Integer pageSize = (KeyValueListStore__c.getValues('LCRMMergeOpportunityPageSize') == null || 
                                   KeyValueListStore__c.getValues('LCRMMergeOpportunityPageSize').TextValue__c == null || 
                                   KeyValueListStore__c.getValues('LCRMMergeOpportunityPageSize').TextValue__c == '')?
                                   (20):Integer.valueOf(KeyValueListStore__c.getValues('LCRMMergeOpportunityPageSize').TextValue__c);
        public Opportunity oppRec{get;set;}
        public Integer totalRecords{get;set;}
        public Integer totalPages{get;set;}
        public String selectOpp{get;set;}
        public Set<String> exlStagesSet{get;set;}
        
        // instantiate the StandardSetController from a query locator
        public ApexPages.StandardSetController con {
            get{
                if(con == null) {
                    Date expDate = Date.Today().addDays(60);
                    con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, StageName, LCRM_Transaction_Type__c, Expected_Start_Date__c, Expected_End_Date__c, LCRM_Total_New_ACV_Sales_Price__c, Renewal_Flag__c, LCRM_Sub_BU__c FROM Opportunity WHERE Is_GLI__c = true AND LCRM_Sub_BU__c = :oppRec.LCRM_Sub_BU__c AND 
                                        accountID = :oppRec.accountID AND Expected_End_Date__c = :oppRec.Expected_End_Date__c AND ID <> :oppRec.ID AND 
                                        CurrencyIsoCode = :oppRec.CurrencyIsoCode  AND LCRM_Split_On__c = FALSE AND 
                                        StageName NOT IN :exlStagesSet AND
                                        /*LCRM_Transaction_Type__c = 'Pro-Rata' AND*/
                                        Expiration_Date__c > :expDate Order By Name LIMIT 50000]));
                    //con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name FROM Opportunity Order By Name LIMIT 53]));
                    // sets the number of records in each page set
                    con.setPageSize(pageSize);
                    totalRecords = [Select count() from Opportunity WHERE Is_GLI__c = true AND LCRM_Sub_BU__c = :oppRec.LCRM_Sub_BU__c AND 
                                        accountID = :oppRec.accountID AND Expected_End_Date__c = :oppRec.Expected_End_Date__c AND ID <> :oppRec.ID AND 
                                        CurrencyIsoCode = :oppRec.CurrencyIsoCode  AND LCRM_Split_On__c = FALSE AND 
                                        StageName NOT IN :exlStagesSet AND
                                        /*LCRM_Transaction_Type__c = 'Pro-Rata' AND*/
                                        Expiration_Date__c > :expDate LIMIT 50000];
                        //totalRecords = [Select count() from Opportunity LIMIT 53];
                    totalPages = (totalRecords/pageSize)+1;
                }
                return con;
            }
            set;
        }
        
        //method used to set the target Opportunity
        public void selectOpp(){
            selectOpp = System.currentPagereference().getParameters().get('oppid');
            system.debug('selectOpp : ' +selectOpp);
            //return null;
        }
    
        // returns a list of wrapper objects for the sObjects in the current page set
        public List<Opportunity> getOppWrapList() {
            return (List<Opportunity>)con.getRecords();
        }
        /*public List<OppWrapper> getOppWrapList() {
            oppWrapList = new List<OppWrapper>();
            for (Opportunity tempOpp : (List<Opportunity>)con.getRecords()){
                oppWrapList.add(new OppWrapper(tempOpp));
            }
            return oppWrapList;
        }*/
        
        // indicates whether there are more records after the current page set.
        public Boolean hasNext {
            get {
                return con.getHasNext();
            }
            set;
        }
    
        // indicates whether there are more records before the current page set.
        public Boolean hasPrevious {
            get {
                return con.getHasPrevious();
            }
            set;
        }
    
        // returns the page number of the current page set
        public Integer pageNumber {
            get {
                return con.getPageNumber();
            }
            set;
        }
    
         // returns the first page of records
         public void first() {
             con.first();
             selectOpp = '';
         }
    
         // returns the last page of records
         public void last() {
             con.last();
             selectOpp = '';
         }
    
         // returns the previous page of records
         public void previous() {
             con.previous();
             selectOpp = '';
         }
    
         // returns the next page of records
         public void next() {
             con.next();
             selectOpp = '';
         }

        // returns the PageReference of the original page, if known, or the home page.
        public void cancel() {
            con.cancel();
        }
        
        public boolean AllowMovePrev {
            get{ 
                return (pageNumber > 1); 
            }
        } 
        
        public boolean AllowMoveNext {
            get{ 
                return (pageNumber < totalPages); 
            }
        }
    }
    
    /*public class OppWrapper{
        public boolean sel{get;set;}
        public Opportunity opp{get;set;}
        
        public OppWrapper(){
            sel = false;
            opp = new Opportunity();
        }
        
        public OppWrapper(Opportunity opp){
            sel = false;
            this.opp = opp;
        }
    }*/

}