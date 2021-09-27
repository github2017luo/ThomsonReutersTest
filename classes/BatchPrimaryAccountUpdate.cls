/**********************************************************************************************************
ClassName: BatchPrimaryAccountUpdate
Description: Bacth class will update Parent account and isPrimary field based on the Business partner Function relation type "Customer Org"
DevelopedBy: Thirumalarao Madala
CreatedDate: 27-Sep-2016
Defect Fix : #SFD-18
**********************************************************************************************************/
global class BatchPrimaryAccountUpdate implements Database.Batchable<sObject>, Database.Stateful{   
    global String failureMessage = '';
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = KeyValueListStore__c.getInstance('BatchPrimaryAccountUpdate').Batch_Query__c +' '+KeyValueListStore__c.getInstance('BatchPrimaryAccountUpdate').Batch_Query_1__c; 
        
        system.debug('query...'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope1){
        system.debug('scope1...'+scope1);
        set<id> setAccid = new set<id>();
        Map<ID,Account> accountScopeMap = new Map<ID,Account>();
        Map<ID,Account> accountChildMap = new Map<ID,Account>();
        Map<ID,Account> accountParentMap = new Map<ID,Account>();
        List<Account> parentAccountSetFalseList = new List<Account>();
        Set<Id> parentAccIds = new Set<Id>();
        Set<Id> parentAccSetFalseIds = new Set<Id>();
        Map<Id, List<Account>> parentAccMap = new Map<Id, List<Account>>(); 
        Map<Id, List<Business_Partner_Function__c>> parentBPFMap = new Map<Id, List<Business_Partner_Function__c>>(); 
        Map<Id, Business_Partner_Function__c> bpfMap = new Map<Id, Business_Partner_Function__c >();    
        List<Business_Partner_Function__c> lstBpf = new List<Business_Partner_Function__c>();//[Rajashree] SFD-18 Feb Release
        Map<Id, List<Id>> selectParentAcc = new Map<Id, List<Id>>(); 
        // get the account Ids anf add to Account Ids
        Savepoint sp;
        try{
       
        /* [Rajashree] <start >Adding the below lines as now we will have scope 1 as BPFs for SFD-18 Feb Release */
         
          for(sObject s:scope1){
           lstBpf.add((Business_Partner_Function__c)s);          
          }
          for(Business_Partner_Function__c bpf : lstBpf ){
               setAccid.add(bpf.Sold_To_Account__c);          
          }
          List<Account> scope =[SELECT Id, Is_Primary__c, Sales_Org__c,ParentId, BPFAccountProcessed__c, SAPAccountNumber__c FROM Account WHERE ID IN: setAccid];
         
         /* <END>   */
         
            for(Account s: scope) {
               accountScopeMap.put(s.Id,s);
            }
            system.debug('@@@accountScopeMap...'+accountScopeMap);
            
            //get the Business partner Function records based on account Ids and relationship Type is Customer Org and add to Map
            System.debug('BPF details--'+[SELECT Id,Related_Account__c, Sold_To_Account__r.Is_Primary__c, Sold_To_Account__c, Sold_To_Account__r.SAPAccountNumber__c, Sold_To_Account__r.ParentId, Account_SAP_Number__c, Relationship_Type__c FROM Business_Partner_Function__c WHERE Sold_To_Account__c IN :accountScopeMap.keySet() AND Relationship_Type__c = 'Customer Org' AND ((LastModifiedDate = TODAY OR LastModifiedDate = YESTERDAY) OR Sold_To_Account__r.BPFAccountProcessed__c = TRUE )]);
            for(Business_Partner_Function__c bpf2 : [SELECT Id,Related_Account__c, Sold_To_Account__r.Is_Primary__c, Sold_To_Account__c, Sold_To_Account__r.SAPAccountNumber__c, Sold_To_Account__r.ParentId, Account_SAP_Number__c, Relationship_Type__c FROM Business_Partner_Function__c WHERE Sold_To_Account__c IN :accountScopeMap.keySet() AND Relationship_Type__c = 'Customer Org' AND ((LastModifiedDate = TODAY OR LastModifiedDate = YESTERDAY) OR Sold_To_Account__r.BPFAccountProcessed__c = TRUE )]) {
               bpfMap.put(bpf2.Sold_To_Account__c, bpf2);
               parentAccIds.add(bpf2.Related_Account__c);
               
               /* [Satya] <start >Adding the below lines as One and more BPFs for HBZ-2 Release */
               if(selectParentAcc!=null && selectParentAcc.containsKey(bpf2.Sold_To_Account__c)){
                    List<Id> accId1 = selectParentAcc.get(bpf2.Sold_To_Account__c);
                    accId1.add(bpf2.Related_Account__c);
                    selectParentAcc.put(bpf2.Sold_To_Account__c,accId1);
               }
               else{
                    selectParentAcc.put(bpf2.Sold_To_Account__c,new List<Id>{Id.valueOf(bpf2.Related_Account__c)});
               }
               /*[Satya] <End>*/
            }
            system.debug('@@@bpfMap...'+bpfMap);
            system.debug('@@@parentAccIds..'+parentAccIds);
            system.debug('@@@selectParentAcc..'+selectParentAcc);
            
            Map<Id,Account> accMap = new Map<ID,Account>([SELECT ID,ParentID,Is_Primary__c,Sales_org__c FROM Account WHERE ID IN :parentAccIds]);
            system.debug('@@@accMap...'+accMap);
            
            // Loop the Account Reecords and find the BPF records If BPF recs found update the Parent Id and Is Primary field of Parent Id records
            // If Not update the Parent Id as null and Check Parent Id have child records.
            system.debug('scope Account----'+scope);
            for(SObject s: scope) {
    
                Account acc = new Account();
                Acc = (Account)s;
                Account updAcc = (accountChildMap.get(acc.Id)!=null)?accountChildMap.get(acc.Id):accountScopeMap.get(acc.Id);
                system.debug('@@@updAcc ...'+updAcc );
                if(!bpfMap.isEmpty() && bpfMap.containsKey(acc.Id) && bpfMap.get(acc.Id).Account_SAP_Number__c != acc.SAPAccountNumber__c ) {
                   /* if(acc.ParentId != null)
                        parentAccSetFalseIds.add(acc.ParentId);*/ // This is not needed now,[Rajashree] SFD-18 Feb Release 
                    System.debug('inside if');
                    /* [Satya] <start >Adding the below lines as One and more BPFs for HBZ-2 Release */
                    if(selectParentAcc.get(acc.ID).size()>1)
                    {
                        List<Account> listAccount = new List<Account>();
                        for(Id acctId:selectParentAcc.get(acc.ID))
                        {
                            listAccount.add(accMap.get(acctId));
                        }
                        Account primaryAcctDet = searchForPrimaryAccount(listAccount,acc);
                        updAcc.ParentId = primaryAcctDet.id;
                    }
                    else{
                        updAcc.ParentId = bpfMap.get(acc.Id).Related_Account__c;
                    }
                    /*[Satya] <End>*/
                    
                    if(updAcc.BPFAccountProcessed__c == true){
                      updAcc.BPFAccountProcessed__c = false;//Rajashree adding this
                    }
                    if(acc.Is_Primary__c && updAcc.ParentId != acc.ID){
                        updAcc.Is_Primary__c = false;                              
                    }                           
                    if(acc.Is_Primary__c && updAcc.ParentId == acc.ID){
                        updAcc.ParentId = null;
                    }
                    accountChildMap.put(updAcc.ID,updAcc);
                    Account updAccPrnt = new Account();    
                    /* [Satya] <start >Adding the below lines as One and more BPFs for HBZ-2 Release */                 
                      if(selectParentAcc.get(acc.ID).size()>1)
                        {
                            List<Account> listAccount = new List<Account>();
                            for(Id acctId:selectParentAcc.get(acc.ID))
                            {
                                listAccount.add(accMap.get(acctId));
                            }
                           if(accountParentMap!= null && accountParentMap.size()==0){
                                updAccPrnt = searchForPrimaryAccount(listAccount,acc);
                            }else
                            {
                                Account updAccPrntDetails = searchForPrimaryAccount(listAccount,acc);
                                if(accountParentMap.get(updAccPrntDetails.Id)!=null)
                                {
                                    updAccPrnt = accountParentMap.get(updAccPrntDetails.Id);
                                }
                                else{
                                    updAccPrnt = searchForPrimaryAccount(listAccount,acc);
                                }
                                 
                            }
                            
                        }
                        else{
                            updAccPrnt = (accountParentMap.get(bpfMap.get(acc.Id).Related_Account__c)!=null)?accountParentMap.get(bpfMap.get(acc.Id).Related_Account__c):accMap.get(bpfMap.get(acc.Id).Related_Account__c);
                        }
                    /*[Satya] <End>*/
            if(accMap.get(bpfMap.get(acc.Id).Related_Account__c)!=null && accMap.get(bpfMap.get(acc.Id).Related_Account__c).ParentID == acc.ID){
                        System.debug('tester1');
                        updAccPrnt.Is_Primary__c = True;
                        updAccPrnt.ParentID = null;
                        if(updAcc.BPFAccountProcessed__c == true){
                            updAccPrnt.BPFAccountProcessed__c = false;//Rajashree SFD-18 Feb Release
                        }
                    }else{
                        System.debug('tester2');
                        updAccPrnt.Is_Primary__c = True;
                        if(updAcc.BPFAccountProcessed__c == true){
                            updAccPrnt.BPFAccountProcessed__c = false;//Rajashree SFD-18 Feb Release
                        }
                    }
                    accountParentMap.put(updAccPrnt.ID,updAccPrnt);  
                }else if(!bpfMap.isEmpty() && bpfMap.containsKey(acc.Id) && bpfMap.get(acc.Id).Account_SAP_Number__c == acc.SAPAccountNumber__c ) {
                    System.debug('inside else if');
                    updAcc.Is_Primary__c = True;
                    system.debug('@@@acc.ParentId 1'+acc.ParentId);
                    updAcc.ParentId = null;
                    system.debug('@@@acc.ParentId 2'+acc.ParentId);
                    if(updAcc.BPFAccountProcessed__c == true){
                        updAcc.BPFAccountProcessed__c = false;//Rajashree SFD-18 Feb Release
                    }
                    accountChildMap.put(updAcc.ID,updAcc);
                   /* if(acc.ParentId != null){
                    system.debug('tester raj');
                        parentAccSetFalseIds.add(acc.ParentId);// This is not needed now,[Rajashree] SFD-18 Feb Release
                    }*/
                }
                if((bpfMap.isEmpty() || (!bpfMap.isEmpty() && !bpfMap.containsKey(acc.Id))) && acc.ParentId != null) {
                   /* if(acc.ParentId != null){
                        parentAccSetFalseIds.add(acc.ParentId);
                       system.debug('tester raj2');
                     }*/ // This is not needed now,[Rajashree] SFD-18 Feb Release
                    system.debug('tester raj3');
                    updAcc.ParentId = null;
                    if(updAcc.BPFAccountProcessed__c == true){
                       updAcc.BPFAccountProcessed__c = false;//Rajashree SFD-18 Feb Release
                    }
                    accountChildMap.put(updAcc.ID,updAcc);
                }
                
                
            }
           
            // update the accounts
            system.debug('accountParentMap...'+accountParentMap);
            if(!accountParentMap.isEmpty()) {
                //update accountParentMap;
                system.debug('tester raj4');
                generateFailureMsg(Database.update(accountParentMap.values(), false),'accountParentMap');
            }
            system.debug('accountChildMap...'+accountChildMap);
            if(!accountChildMap.isEmpty()) {
                //update accountChildMap;
                system.debug('tester raj5');
                generateFailureMsg(Database.update(accountChildMap.values(), false),'accountChildMap');
            }  
            
           /* We don't want the old parent to become non primary as part of SFD-18 Feb Release [Rajashree] 
           
           system.debug('parentAccSetFalseIds...'+parentAccSetFalseIds);
            // Get the account recs and put in map and check for child recods
            System.debug('parent query : '+[SELECT Id, ParentId, Name FROM ACCOUNT WHERE ParentId IN :parentAccSetFalseIds]);
            for(Account acn :[SELECT Id, ParentId, Name FROM ACCOUNT WHERE ParentId IN :parentAccSetFalseIds]) {
                If(parentAccMap.containsKey(acn.ParentId)) {
                    parentAccMap.get(acn.ParentId).add(acn);
                    system.debug('tester raj6');
                }
                else {
                    parentAccMap.put(acn.ParentId, new List <Account> {acn});  
                    system.debug('tester raj7');  
                }
            }
            System.debug('parentAccMap : '+parentAccMap);
            
            // Get the partner funct recs and put in map 
            System.debug('parent query : '+[SELECT Id, Related_Account__c, Sold_To_Account__c FROM Business_Partner_Function__c WHERE Sold_To_Account__c IN :parentAccSetFalseIds AND Relationship_Type__c = 'Customer Org']);
            for(Business_Partner_Function__c bpf :[SELECT Id, Related_Account__c, Sold_To_Account__c FROM Business_Partner_Function__c WHERE Sold_To_Account__c IN :parentAccSetFalseIds AND Relationship_Type__c = 'Customer Org']) {
                if(bpf.Sold_To_Account__c == bpf.Related_Account__c){
                    If(parentBPFMap.containsKey(bpf.Sold_To_Account__c)) {
                        parentBPFMap.get(bpf.Sold_To_Account__c).add(bpf);
                        system.debug('tester raj8');
                    }
                    else {
                        parentBPFMap.put(bpf.Sold_To_Account__c, new List<Business_Partner_Function__c>{bpf});  
                        system.debug('tester raj9');  
                    }
                }
            }
            System.debug('parentBPFMap : '+parentBPFMap);
            
            // If Patrent Id dont have any childs then update the is Primary is False of Parent Id.
            for(Id accId :parentAccSetFalseIds) {
                system.debug('parentAccSetFalseIds...'+parentAccMap);
                if(((!parentAccMap.isEmpty() && !parentAccMap.containsKey(accId)) || parentAccMap.isEmpty() || parentAccMap.get(accId).size() < 1) 
                    && ((!parentBPFMap.isEmpty() && !parentBPFMap.containsKey(accId)) || parentBPFMap.isEmpty() || parentBPFMap.get(accId).size() < 1)) {
                    Account accpr = new Account(id = accId, Is_Primary__c = False);
                    parentAccountSetFalseList.add(accpr); 
                    system.debug('tester raj10');
                }  
            }
            system.debug('parentAccountSetFalseList...'+parentAccountSetFalseList);
            if(!parentAccountSetFalseList.isEmpty()) {
                //update parentAccountSetFalseList;
                generateFailureMsg(Database.update(parentAccountSetFalseList, false),'parentAccountSetFalseList');
                system.debug('tester raj11');
            } */
                        
        }catch(Exception e)
        {
            system.debug('Error'+e);
            failureMessage += e.getMessage()+ '\n';
            failureMessage += e.getStackTraceString()+ '\n\n';
            System.debug('Failure..'+failureMessage);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        String emailId = '';
        try{
            emailId = KeyValueListStore__c.getInstance('BatchPrimaryAccountUpdate').Failure_Email__c;
        }catch(Exception e){}
        System.debug('failureMessage : '+failureMessage);
        System.debug('emailId : '+emailId);
        if(Test.isRunningTest() || (emailId!=null && emailId!='' && failureMessage!=null && failureMessage!='')){
            Messaging.SingleEmailMessage mail1=new Messaging.SingleEmailMessage();           
            //String[] toadd=new String[]{'thirumalarao.madala@thomsonreuters.com'};
            //mail1.setToAddresses(toadd);
            String[] toadd=new String[]{emailId};
            mail1.setToAddresses(toadd);
            System.debug('Tooadd..'+toadd);
            mail1.setSubject('BatchPrimaryAccountUpdate Failed to update');
            mail1.setPlainTextBody(failureMessage); 
            mail1.setSenderDisplayName('Apex Batch Failure');
            Messaging.SendEmailResult[] res = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail1});
            System.debug('Result..'+res);
        }
    }
    
    global void generateFailureMsg(Database.SaveResult[] srList, String funct){
        for(Database.SaveResult sr :srList) {
            System.debug('sr : '+sr);
            if(!sr.isSuccess()) {
                failureMessage = 'Couldnot update the sObject' + sr.getId() + '\n';// [Rajashree] SFD-18 Feb Release ,Adding this line to get AccId which failed
                failureMessage += 'The list/map is' + ':'+ funct + ' Record Failure- ';
                for(Database.Error err : sr.getErrors()) {
                    failureMessage += err.getStatusCode() + ' : ' + err.getMessage()+ '\n'; 
                    failureMessage += 'Fields that affected this error: ' + err.getFields() + '\n';
                    
                }  
                failureMessage += '\n';         
            }
        }
    }
    /* [Satya] <start >Adding the below Method as One and more BPFs for HBZ-2 Release. Based on ranking of sales org account will identified */     
    //To Identify the primary Account
    global Account searchForPrimaryAccount(List<Account> accList, Account soldtoAcc){
        
        
        //Fetching data from customsetting
        List<Ranking_Salesorg__c> mcs = Ranking_Salesorg__c.getall().values();
        Map<String,Integer> rankMapSalesorg = new Map<String,Integer>();
        Map<String,Account> accSalesorg = new Map<String,Account>();
        Map<Integer,String> rankMap = new Map<Integer,String>();
        for(Ranking_Salesorg__c rankSales:mcs)
        {
            rankMapSalesorg.put(rankSales.Sales_org__c,Integer.valueOf(rankSales.Ranking__c));
            rankMap.put(Integer.valueOf(rankSales.Ranking__c),rankSales.Sales_org__c);
        }
        system.debug(rankMap);
        List<Integer> rankNumber = new List<Integer>();
        for(Account acc:accList)
        {
            rankNumber.add(rankMapSalesorg.get(acc.Sales_Org__c));
            accSalesorg.put(acc.Sales_Org__c,acc);
        }
        if(accSalesorg.containsKey(soldtoAcc.Sales_Org__c))
        {
            return accSalesorg.get(soldtoAcc.Sales_Org__c);
        }
        else{
            Integer smallest = rankNumber[0];
           
            for(Integer i=1; i< rankNumber.size(); i++)
            {
                    if(rankNumber[i] < smallest)
                    {
                            smallest = rankNumber[i];
                    }
            }
            String salesOrgStr = rankMap.get(smallest);
            return accSalesorg.get(salesOrgStr);
        }
        return null;
        
    }
}