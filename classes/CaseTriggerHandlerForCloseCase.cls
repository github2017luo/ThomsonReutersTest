public class CaseTriggerHandlerForCloseCase {
// public static boolean bflag = true;
 /********************************************************************************************
    MethodName: updateQuoteOnCaseClosure
    Description: Method is called from the trigger "CaseAfterEventListner".
                 Method creates a new case when manager approve the Quote for Cancellation request.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public static void updateQuoteOnCaseClosure(List<Case> lstNewCase) 
    { 
        System.Debug('In method "updateQuoteOnCaseClosure", lstNewCase='+ lstNewCase);
        //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
        Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId();        
        //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
        Id caseRecordTypeEliteClosedCPQ =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId(); 
         
        if(lstNewCase != null && lstNewCase.size() > 0)
        { 
            Set<ID> setRemoveQtyId = new Set<ID>();
            Set<ID> setCancelQtyId = new Set<ID>();
            
            for(Case c : lstNewCase){ 
                if(String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteClosedCPQ){
                    if(c.Status =='Closed' && c.Reason_Detail__c == 'Remove Renewal') {
                       setRemoveQtyId.add(c.Quote__c);
                    }  
                    else if(c.Status =='Closed' && c.Reason_Detail__c == 'Full Cancellation') {
                       setCancelQtyId.add(c.Quote__c);
                       System.Debug('Cancelled Quote Id'+setCancelQtyId);
                    } 
                }
            } 
            
            System.Debug('setRemoveQtyId='+ setRemoveQtyId);
            System.Debug('setCancelQtyId='+ setCancelQtyId);
            
            if(setRemoveQtyId.size() > 0){
                List<Quote> listQuote = [SELECT ID, OpportunityId FROM Quote WHERE ID IN:setRemoveQtyId];
                if(listQuote != null && listQuote.size() > 0){
                    WebserviceResponseHandler.updateQuoteOnRemoveSuccess(listQuote,''); 
                } 
            }
            
            if(setCancelQtyId.size() > 0){
                List<Quote> listQuote = [SELECT ID, OpportunityId FROM Quote WHERE ID IN:setCancelQtyId];
                System.Debug('Quote list'+listQuote);
                if(listQuote != null && listQuote.size() > 0){
                    updateQuoteOnManagerApprove(listQuote); 
                } 
            }            
        }
    }
    
    /********************************************************************************************
    MethodName: updateQuoteOnManagerApprove
    Description: Method is called from the method "updateQuoteOnCaseClosure".
                 Method updates Quote and related objects when Case is closed for Cancellation request.
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    public static void updateQuoteOnManagerApprove(List<Quote> lstProcessQuote)
    {
        try{
            System.Debug('Start update operation on case closure, Method = updateQuoteOnManagerApprove');
            
            List<Quote> lstUpdateQuote = new List<Quote>();
            List<Opportunity> lstUpdateOpprty = new List<Opportunity>();
            Set<Id> setQuoteId = new Set<Id>();
            Set<Id> setOpprtyId = new Set<Id>();            
            Set<Id> setQtyId = new Set<Id>();
            
            for(Quote qt : lstProcessQuote){
                setQtyId.add(qt.Id);
            }
            
            Map<String, Renewal_Request__c> mapQtyRR = new Map<String, Renewal_Request__c>();
            Map<String, Renewal_Request__c> mapOppRR = new Map<String, Renewal_Request__c>();
            
            for(Renewal_Request__c rr : [SELECT Quote__c, Opportunity__c, Was_There_a_Competitor__c, Competitor_Name__c, Cancel_Reason__c, Cancel_Comments__c FROM Renewal_Request__c WHERE Quote__c IN : setQtyId ORDER BY CreatedDate DESC]){
                if(mapQtyRR.get(rr.Quote__c) == null){
                    mapQtyRR.put(rr.Quote__c, rr);
                }
                
                if(mapOppRR.get(rr.Opportunity__c) == null){
                    mapOppRR.put(rr.Opportunity__c, rr);
                }
            }           
            
            List<Quote> lstUncheckQuote = new List<Quote>();
            List<Opportunity> lstCheckOpp = new List<Opportunity>();
            
            for(Quote objQty : lstProcessQuote){
                setQuoteId.add(objQty.Id);
                setOpprtyId.add(objQty.OpportunityId);  
                
                //Preparing Quote for update.
                Quote objUpdateQty = new Quote();
                objUpdateQty.Id = objQty.Id;
                objUpdateQty.Status = 'Order Cancelled';
                objUpdateQty.Cancel_Date__c = Date.Today();
                objUpdateQty.Win_Loss__c = 'Lost';
                objUpdateQty.Reason__c = mapQtyRR.get(objQty.Id).Cancel_Reason__c;
                objUpdateQty.Was_There_a_Competitor__c = mapQtyRR.get(objQty.Id).Was_There_a_Competitor__c;
                objUpdateQty.Competitor_Name__c = mapQtyRR.get(objQty.Id).Competitor_Name__c;
                objUpdateQty.Cancel_Comments__c = mapQtyRR.get(objQty.Id).Cancel_Comments__c;  
                objUpdateQty.IsSkipQtyLockingValidation__c = true;
                lstUpdateQuote.add(objUpdateQty);
                
                //  
                objUpdateQty = new Quote(); 
                objUpdateQty.Id = objQty.Id;
                objUpdateQty.IsSkipQtyLockingValidation__c = false; 
                lstUncheckQuote.add(objUpdateQty);
                
                //Preparing Opportunity for update.
                Opportunity objUpdateOpp = new Opportunity();
                objUpdateOpp.Id = objQty.OpportunityId;
                objUpdateOpp.StageName = '0%';
                objUpdateOpp.Status__c = 'Discarded';
                objUpdateOpp.Win_Loss__c = 'Lost';
                objUpdateOpp.Reason__c = mapQtyRR.get(objQty.Id).Cancel_Reason__c;
                objUpdateOpp.Was_There_a_Competitor__c = mapQtyRR.get(objQty.Id).Was_There_a_Competitor__c;
                objUpdateOpp.Competitor_Name__c = mapQtyRR.get(objQty.Id).Competitor_Name__c;
                //objUpdateOpp.IsSkipOppLockingValidation__c = true;
                lstUpdateOpprty.add(objUpdateOpp);
                
                //
                Opportunity objTempOpp = new Opportunity();
                objTempOpp.Id = objQty.OpportunityId;
                objTempOpp.IsSkipOppLockingValidation__c = true;
                lstCheckOpp.add(objTempOpp);
            }
            
            //Preparing Quote Line Item for update
            List<QuoteLineItem> lstUpdateQLI = new List<QuoteLineItem>();
            for(QuoteLineItem qll : [SELECT Id, QuoteId, Status__c, Cancel_Reason__c, Cancel_Comments__c, Cancel_Date__c FROM QuoteLineItem WHERE QuoteId IN : setQuoteId]){
                //qll.Status__c = 'Cancelled';  
                qll.Cancel_Reason__c = mapQtyRR.get(qll.QuoteId).Cancel_Reason__c;
                qll.Cancel_Comments__c = mapQtyRR.get(qll.QuoteId).Cancel_Comments__c;
                qll.Cancel_Date__c = Date.Today();
                lstUpdateQLI.add(qll);
            }
            
            //Preparing Opportunity Line Item for update
            List<OpportunityLineItem> lstUpdateOppLI = new List<OpportunityLineItem>();
            for(OpportunityLineItem opli : [SELECT Id, OpportunityId, Status__c, Cancel_Reason__c, Cancel_Comments__c, Cancel_Date__c FROM OpportunityLineItem WHERE OpportunityId IN : setOpprtyId]){
                //opli.Status__c = 'Cancelled';   
                opli.Cancel_Reason__c = mapOppRR.get(opli.OpportunityId).Cancel_Reason__c;
                opli.Cancel_Comments__c = mapOppRR.get(opli.OpportunityId).Cancel_Comments__c;
                opli.Cancel_Date__c = Date.Today();
                lstUpdateOppLI.add(opli);
            }
            
            //By pass Opp validation rule
            UPDATE lstCheckOpp;
            
            //
            if(lstUpdateQuote.size() > 0){                       
                UPDATE lstUpdateQuote;                  
            }
            
            if(lstUpdateQLI.size() > 0){                
                UPDATE lstUpdateQLI;                    
            }            
            
            if(lstUpdateOppLI.size() > 0){               
                UPDATE lstUpdateOppLI;  
            }
            
            if(lstUncheckQuote.size() > 0){
                UPDATE lstUncheckQuote;
            }
            
            if(lstUpdateOpprty.size() > 0){                
                checkRecursive.isAllowChildQuoteDiscard = false;
                UPDATE lstUpdateOpprty;   
                checkRecursive.isAllowChildQuoteDiscard = true;                
            }
            
            System.Debug('Update operation is successfully completed, Method = updateQuoteOnManagerApprove');
        }
        catch(DmlException ex) {
            System.Debug('Exception occured on update Quote and other related objects, Method = updateQuoteOnManagerApprove, Class = CaseTriggerHandlerForCloseCase, ERROR='+ ex);                      
        }
    }
        /* AG - 03-Aug-2016 - Start */
    /********************************************************************************************
    MethodName: updateOpptyGracePeriodDaysOnCaseCloser
    Description: Method is called from the trigger CaseAfterEventListener.
                 to Update Opportunity Grace_Period_Days__c when case is closed mannually
    DevelopedBy: TCS Offshore, Kolkata 
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
    
    /* Update Opportunity Grace_Period_Days__c when case is closed mannually */ 
      
    public static void updateOpptyGracePeriodDaysOnCaseCloser(map<Id, Case> mapOldCases, list<Case> Triggernew) 
    {
        if(checkRecursive.runCaseUpdateForGPDaysOnce == true){
            System.debug('checkRecursive.runCaseUpdateForGPDaysOnce---->'+checkRecursive.runCaseUpdateForGPDaysOnce);
            checkRecursive.runCaseUpdateForGPDaysOnce = false;
            System.debug('After checkRecursive.runCaseUpdateForGPDaysOnce---->'+checkRecursive.runCaseUpdateForGPDaysOnce);
            if(Triggernew.size()>0){
                Set<Id> Idset=new Set<Id>();
                List<Opportunity> opptyUpdtList= new List<Opportunity>();//instantiated
                //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
                Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId();
                //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
                Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId();
                 
                for(Case c:Triggernew) {
                    System.debug('GP_log---->c.Status - c.Approval_Status__c - c.Reason__c' + c.Status + ' c.Approval_Status__c '+c.Approval_Status__c+'c.Reason__c - '+c.Reason__c);
                    if(c.Status!=null && c.Approval_Status__c!=null && c.Reason__c!=null && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ){
                        if(mapOldCases.get(c.Id).Status!= 'Closed' && c.Status=='Closed' && c.Approval_Status__c.equals('Approved') && c.Reason__c.equals('Grace Period Extension')) {
                                Idset.add(c.Opportunity__c);//Set of related oppty id's                
                        } 
                    }
                }
                System.debug('Before Opportuny Update -> opptyUpdtList'+opptyUpdtList);
                if(Idset.size()>0) {
                    for(Opportunity opp:[select  id,Name,Grace_Period_Days__c,SyncedQuote.Grace_Subscription_Status_Formula__c from Opportunity where SyncedQuoteID<>null and id in :Idset]) {
                        Opportunity opp1=new Opportunity();
                        System.debug('Before Opportuny Update -> opptyUpdtList'+opp.Grace_Period_Days__c);
                        if(opp.SyncedQuote.Grace_Subscription_Status_Formula__c != null && opp.SyncedQuote.Grace_Subscription_Status_Formula__c.equals('Expired')==false){
                            if(opp.Grace_Period_Days__c == null){                            
                                opp.Grace_Period_Days__c  = 30;
                            }
                            else{
                                opp.Grace_Period_Days__c  = opp.Grace_Period_Days__c +30;
                            }
                            opp1.Id=opp.Id;
                            opp1.Grace_Period_Days__c=opp.Grace_Period_Days__c;
                            opptyUpdtList.add(opp1);//build oppty list
                        
                            System.debug('after Opportunity Update -> opptyUpdtList'+opptyUpdtList+'-->'+opp.Grace_Period_Days__c);
                        }
                    }
                }
                
                if(opptyUpdtList.size()>0){
                    try{
                        Database.SaveResult[] sr = Database.Update(opptyUpdtList);
                        System.debug('Updated Successful'+sr);
                    }
                    catch(Exception e){
                        System.debug('Failed to update Opportunity field Grace_Period_Days__c'+e);
                    }
                } 
            }  
        }/*else{
            System.debug('In else checkRecursive.runCaseUpdateForGPDaysOnce---->'+checkRecursive.runCaseUpdateForGPDaysOnce);
            checkRecursive.runCaseUpdateForGPDaysOnce = true;
        } */
        checkRecursive.runCaseUpdateForGPDaysOnce = true;
    }
    //Added to submit the case for approval upon saving the case from detail page
    public static void submitForApprovalCase(list<Case> Triggernew)
    {
        try{
            User currUser = [Select Id, Name, Sales_org__c, profile.name from User where Id=:UserInfo.getUserId()];
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            List<Approval.ProcessSubmitRequest> reqList = new List<Approval.ProcessSubmitRequest>();
            Set<Id> quoteIdSet = new Set<Id>();
            //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
            Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId(); 
            //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
            Id caseRecordTypeEliteClosedCPQ =  Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId(); 
            for (Case c:Triggernew) {
                if(String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteClosedCPQ)
                    quoteIdSet.add(c.Quote__c);
            }
            System.debug('Before Submit');
            Map<Id, Quote> quoteMap = new Map<Id, Quote>([Select Id,Primary_Quote__c,Opportunity.Renewal_Flag__c from Quote where Id in:quoteIdSet]);
            for (Case c:Triggernew) {
                if(currUser.profile.name!=null && currUser.Sales_org__c!=null && c.Reason__c!=null 
                && c.Origin!=null && c.Opportunity__c != null && c.Quote__c != null && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteClosedCPQ){
        
                    if (
                            (
                                currUser.profile.name.equals('LatAm User') 
                                || currUser.profile.name.equals('Partner Portal User')
                                || currUser.profile.name.equals('System Administrator')
                            )
                            &&
                            (
                                //REMOVED ABEP AS PART OF HER-20
                                /* currUser.Sales_org__c.equals('ABEP') 
                                || currUser.Sales_org__c.equals('BEJE')
                                || currUser.Sales_org__c.equals('FSCO')
                                || currUser.Sales_org__c.equals('LLEY')
                                || currUser.Sales_org__c.equals('LLPA')
                                || currUser.Sales_org__c.equals('LLUR')
                                || currUser.Sales_org__c.equals('LPCL')
                                || currUser.Sales_org__c.equals('LPTC')
                                || currUser.Sales_org__c.equals('RV01')
                                || currUser.Sales_org__c.equals('TSL') */ 
                                
                                
                                currUser.Sales_org__c.equals('BEJE')
                                || currUser.Sales_org__c.equals('LLEY')
                                || currUser.Sales_org__c.equals('LLPA')
                                || currUser.Sales_org__c.equals('LLUR')
                                || currUser.Sales_org__c.equals('LPCL')
                                || currUser.Sales_org__c.equals('LPTC')
                                || currUser.Sales_org__c.equals('RV01')
                                || currUser.Sales_org__c.equals('TSL')
                                || currUser.Sales_org__c.equals('DFCL')
                            )
                            &&
                            (
                                c.Reason__c.equals('Grace Period Extension') 
                                && c.Origin.equals('Created by System')
                                && c.Opportunity__c != null && c.Quote__c != null                                                         
                                && quoteMap.get(c.Quote__c).Primary_Quote__c==true
                                && quoteMap.get(c.Quote__c).Opportunity.Renewal_Flag__c==true
                            )
                        ) 
                        {
                            if(c.Approval_Status__c==null || c.Approval_Status__c=='') { 
                                // create the new approval request to submit
                                    
                                //req.setComments('Submitted for approval.');
                                System.debug('c.Id'+c.Id);
                                req.setObjectId(c.Id);
                                reqList.add(req);  
                                System.debug('req---->'+req);              
                                System.debug('reqList'+reqList);
                                // display if the reqeust was successful
                                
                            } 
                            
                        }
                    }
        
            }
            if(reqList.size()>0){
                List<Approval.ProcessResult> result = Approval.process(reqList);
                System.debug('Submitted for approval successfully: '+result);
            }
        }
        catch(Exception e){
            System.debug('Approval related exception - '+e);
        }
    
    }
    
    public static void updateEmailForGracePeriodOnQuoteCase(list<Case> Triggernew) 
    {
        System.debug('updateEmailForGracePeriodOnQuoteCase -- Entry');
        checkRecursive.runCaseUpdateForGPDaysOnce = false;
        try{
             if(checkRecursive.runCaseUpdateForGPOnce==true){
                checkRecursive.runCaseUpdateForGPOnce=false;
                
                System.debug('Triggernew.size()'+Triggernew.size());
                if(Triggernew.size()>0){
                    Set<Id> quoteIdSet=new Set<Id>();
                    List<Quote> quoteUpdtList= new List<Quote>();//instantiated
                    List<Case> caseListWithQuote= new List<Case>();//instantiated
                    List<QuoteLineItem> quoteLIUpdtList= new List<QuoteLineItem>();//instantiated
                    List<QuoteLineItem> quoteLIUpdtListAll= new List<QuoteLineItem>();//instantiated
                    List<Case> caseToUpdate= new List<Case>();//instantiated
                    List<Quote> quoteToUpdate= new List<Quote>();//instantiated
                    String email='';
                    
                    Map<Id,Quote> quoteMapWithLineItem = new Map<Id,Quote>();
                    //Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite CPQ Requests').getRecordTypeId();
                    Id caseRecordTypeEliteCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_CPQ_Requests').getRecordTypeId();
                    //Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Elite Closed CPQ Requests').getRecordTypeId();
                    Id caseRecordTypeEliteClosedCPQ = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Elite_Closed_CPQ_Requests').getRecordTypeId(); 
                     
                    for(Case c:Triggernew) {
                        System.debug('GP_log----> c.Reason__c' + c.Reason__c+'Approval.isLocked(c.Quote__c)'+Approval.isLocked(c.Quote__c));
                        if(c.Quote__c!=null && Approval.isLocked(c.Quote__c)==false && c.Reason__c!=null && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteCPQ && String.valueOf(c.RecordTypeId)!=caseRecordTypeEliteClosedCPQ){
                            if(c.Reason__c.equals('Grace Period Extension')) {                                                    
                                quoteIdSet.add(c.Quote__c);//Set of related oppty id's   
                                caseListWithQuote.add(c);                                    
                            } 
                        }                
                    }
                    System.debug('quoteIdSet.size()'+quoteIdSet.size());
                    if(quoteIdSet.size()>0) {                
                        quoteMapWithLineItem = new Map<Id,Quote>([select  id,Name,Business_Unit__c,Sales_Org__c,(Select Id, QuoteId,Product2Id,Product2.Application_Domain__c from QuoteLineItems) from Quote where id in :quoteIdSet]);                    
                        //quoteLIUpdtListAll = [Select Id, QuoteId,Product2Id,Product2.Application_Domain__c  from QuoteLineItem where QuoteId in :quoteIdSet];
                    }
                    
                    System.debug('quoteMapWithLineItem---->'+quoteMapWithLineItem);
                    System.debug('caseListWithQuote.size()---->'+caseListWithQuote.size());
                    System.debug('quoteLIUpdtListAll---->'+quoteLIUpdtListAll);
                    
                    if(caseListWithQuote.size()>0){
                        for(Case c:caseListWithQuote) { 
                            
                            //if(quoteLIUpdtListAll.size()>0){
                                //for(QuoteLineItem qliAll:quoteLIUpdtListAll) {
                                    //if(c.Quote__c!=null && qliAll.QuoteId!=null){
                                        //if(c.Quote__c == qliAll.QuoteId){
                                            //quoteLIUpdtList.add(qliAll);
                                        //}
                                    //}
                                //}
                            //}
                            
                            //Quote qu=new Quote();
                            //qu=quoteMapWithLineItem.get(c.Id);
                            quoteLIUpdtList=(quoteMapWithLineItem.get(c.Quote__c)).QuoteLineItems;
                            System.debug('quoteLIUpdtList---->'+quoteLIUpdtList);
                            //System.debug('qu---->'+qu);
                            if((quoteMapWithLineItem.get(c.Quote__c)).Sales_Org__c!=null){
                                if((quoteMapWithLineItem.get(c.Quote__c).Sales_Org__c).equals('BEJE')){
                                    if(quoteLIUpdtList.size()>0){
                                        for(QuoteLineItem qli : quoteLIUpdtList) {
                                            if(qli.Product2.Application_Domain__c!=null){
                                                System.debug('qli.Product2.Application_Domain__c---->'+qli.Product2.Application_Domain__c);
                                                if(qli.Product2.Application_Domain__c.equals('BEJE')){
                                                    //email='bejerman.legacy@thomsonreuters.com';
                                                    email=Label.GP_BEJE_Email;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                                /*else if(((quoteMapWithLineItem.get(c.Quote__c)).Sales_Org__c).equals('FSCO')){
                                    if(quoteLIUpdtList.size()>0){
                                        for(QuoteLineItem qli : quoteLIUpdtList) {
                                            if(qli.Product2.Application_Domain__c==null){                                            
                                                //email='fsco@thomsonreuters.com';
                                                email=Label.GP_FSCO_Email;
                                                break;
                                                
                                            }
                                        }
                                    }
                                }*/
                                else if(((quoteMapWithLineItem.get(c.Quote__c)).Sales_Org__c).equals('TSL')){
                                    if(quoteLIUpdtList.size()>0){
                                        for(QuoteLineItem qli : quoteLIUpdtList) {
                                            if(qli.Product2.Application_Domain__c!=null && (quoteMapWithLineItem.get(c.Id)).Business_Unit__c!=null){
                                                if(qli.Product2.Application_Domain__c.equals('TSL') && (((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('NovaProlink')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('novaprolink')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('NOVAPROLINK')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('Novaprolink'))){
                                                    //email='novaprolink@thomsonreuters.com';
                                                    email=Label.GP_TSLNovaProlink_Email;
                                                    break;
                                                }
                                                if(qli.Product2.Application_Domain__c.equals('TSL') && (((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('Mastersaf')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('mastersaf')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('MASTERSAF'))){
                                                    //email='mastersaf.licenciamento@thomsonreuters.com';
                                                    email=Label.GP_TSLMastersaf_Email;
                                                    break;
                                                }
                                                if(qli.Product2.Application_Domain__c.equals('TSL') && (((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('Tedesco')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('tedesco')||((quoteMapWithLineItem.get(c.Id)).Business_Unit__c).equals('TEDESCO'))){
                                                    //email='tedesco@thomsonreuters.com';
                                                    email=Label.GP_TSLTedesco_Email;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                            System.debug('email final ---->'+email);
                            if(email!='' && email!=null){
                                //List<Case> caseToUpdate= new List<Case>();//instantiated
                                //List<Quote> quoteToUpdate= new List<Quote>();//instantiated
                                Case caseToUpdateObj=new Case(Id=c.Id);
                                caseToUpdateObj.Entitlement_Email__c=email;
                                caseToUpdate.add(caseToUpdateObj);
                                Quote quoteToUpdateObj=new Quote(Id=c.Quote__c);
                                quoteToUpdateObj.Entitlement_Email__c=email;
                                quoteToUpdate.add(quoteToUpdateObj);
                            }                        
                        }                    
                    }
                    if(quoteToUpdate.size()>0){
                        try{
                            Database.SaveResult[] sr = Database.Update(quoteToUpdate);
                            System.debug('Updated Successful'+sr);
                        }
                        catch(Exception e){
                            System.debug('Failed to update Quote Entitlement Email - '+e);
                        }
                    }
                     
                    System.debug('caseToUpdate.size()'+caseToUpdate.size()+'checkRecursive.runCaseUpdateForGPOnce '+checkRecursive.runCaseUpdateForGPOnce);
                    if(caseToUpdate.size()>0){
                        System.debug('caseToUpdate---->'+caseToUpdate);
                        try{
                            System.debug('caseToUpdate---->1'+caseToUpdate);
                            Update caseToUpdate;
                            System.debug('Updated Successful case'+caseToUpdate);
                            
                        }
                        catch(Exception e){
                            System.debug('Failed to update Case Entitlement Email - '+e);
                        }
                    }
                    
                    
                    
                }
                
            }
            else{
                checkRecursive.runCaseUpdateForGPOnce=true;
            }
        }
        catch(Exception e){
            System.debug('Failed to update Case Entitlement Email - '+e);
        }
    }
    
    /*******************************************************************/
}