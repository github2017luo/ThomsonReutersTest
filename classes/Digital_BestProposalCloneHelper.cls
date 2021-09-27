/* 
---------------
History 
---------------  

Modified by Brenda Shields on May 04 2018
DLT-9536 - Add dymanic coding for Digital Firm updates and set the owners of the Opp/Proposal/cart accordingly.

Modified by Srikanth Kota on Aug 13 2018
DLT-11665 - Config type proposal should expire if products product not part of the Digital configurator category.

Modified by Navleen Kaur  on Aug 29 2018
DLT-11735 -  code scan[Access permissions before SOQL/DML]


Modified by Navleen Kaur  on Feb 07 2019
DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file

2019-06-11   Srikanth Kota      DLT-16794-[Tech Story] [Code Scan] Fix code scan Major issues in this Digital_BestProposalCloneHelper
2019-06-24   Harika Sai P       DLT-16854 [Tech Story] - Remove Unnecessary code lines from Proposal Automation and move to Dataoperation Layer

*/
public without sharing class Digital_BestProposalCloneHelper {
    
    public static list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
    public static id mollyUserId;    
    public static Map<String, String> dsFirmMap = new Map<String, String>();
    private static IGlobalOperationLayer globObj  = new GlobalOperationLayer();
    public static void cloneProposal(List<Opportunity> digitalOpp,Id bestMollyUserId,List<Product_Account_Detail__c> dcList){        
        
        // map to lookup opportunity owner based on Digital Firm value
       /* if(Schema.sObjectType.Digital_Firm_Defaults__mdt.isAccessible()){
            for(Digital_Firm_Defaults__mdt oDefaults: [SELECT Label, Opportunity_Owner_Id__c, Proposal_Approval_Segment__c                                                      
                                                       FROM Digital_Firm_Defaults__mdt]){                                                  
                                                           mapDigitalOwner.put(oDefaults.Label, oDefaults.Opportunity_Owner_Id__c);        
                                                       }
        }
        system.debug('execute: Digital Firms Opp Owner Ids: ' + mapDigitalOwner);*/
        
        String quoteType = 'Best Value';
        String query = '';
        set<String> campCodeNameSet = new Set<String>();
        list<Opportunity> bestConfigOpp = new list<Opportunity>();
        mollyUserId = bestMollyUserId;
        
        System.debug('dcList-->'+dcList);
        for(Product_Account_Detail__c camp : dcList ){
            campCodeNameSet.add(camp.Campaign_Code__c);
            dsFirmMap.put(camp.ZP_Cust_Number__c, camp.Digital_Firm__c);
        }
        
        for(Opportunity opp : digitalOpp){
            
            if(campCodeNameSet.contains(opp.Campaign_Code__c)){
                bestConfigOpp.add(opp);
            }
        }
        
        query = queryAllFields('Apttus_Proposal__Proposal__c');
        query = query + ' Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in : bestConfigOpp and Digital_Quote_Type__c=\''+String.escapeSingleQuotes(quoteType)+'\'';
        
        List<Apttus_Proposal__Proposal__c> bestValConfigQuoteList  = new List<Apttus_Proposal__Proposal__c>();
        bestValConfigQuoteList = Database.query(query);
        
        if(bestValConfigQuoteList != null && bestValConfigQuoteList.size()>0){
            
            for(Apttus_Proposal__Proposal__c prop : bestValConfigQuoteList){
                createBestValueConfigQuote(prop);
            }
        }
        else{
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = 'Opportunity Campaign Code does not have configuration flag checked';
            ex.Exception_Type__c = 'Quote Clone - Opty Id - '+digitalOpp[0].id;//failed record from the list
            ex.Additional_Information__c = 'Account Id - '+digitalOpp[0].AccountId;            
            ex.User_Message__c = 'Please check configuration flag in Digital_Campaigns__c custom setting';
            ex.Class_Reference__c = 'Digital_BestProposalAutomation > Digital_BestProposalCloneHelper > cloneProposal';
            exList.add(ex);
        }
        
    }
    
    // create quote for Best 
    public static void createBestValueConfigQuote(Apttus_Proposal__Proposal__c bestValConfigQuote){
        
        String quoteId = bestValConfigQuote.id;
        Integer i=0;
        Database.SaveResult[] lsr;
        list<Id> successCartList = new list<Id>();
        List<Apttus_Proposal__Proposal__c> lstProposalUpdateDigitalflag = new list<Apttus_Proposal__Proposal__c>();
        try {
            
            if(bestValConfigQuote != null){
                
                Apttus_Proposal__Proposal__c bestValconfigQuoteCloned = new Apttus_Proposal__Proposal__c();
                bestValconfigQuoteCloned = bestValConfigQuote.clone(false,true,false,false);
                bestValconfigQuoteCloned.Digital_Quote_Type__c = 'Best Value+Config';
                bestValconfigQuoteCloned.Apttus_Proposal__Proposal_Name__c = bestValConfigQuote.Apttus_Proposal__Opportunity__r.Name + ' - Config';
                // DLT-9536 - Set the Proposal owner based on the Digital Firm
                if(bestValConfigQuote.Owner.Name == System.Label.DC_INFORMATICA_USER){
                    ID digtlOwnerId = globObj.setTheDigitalOwnerAppSegment(dsFirmMap.get(bestValConfigQuote.APTS_SSD_bill_to__r.Source_System_Account_Number__c));//DLT-16854
                    /*bestValconfigQuoteCloned.Ownerid = mapDigitalOwner.get(dsFirmMap.get(bestValConfigQuote.APTS_SSD_bill_to__r.Source_System_Account_Number__c));
                    bestValconfigQuoteCloned.createdById = mapDigitalOwner.get(dsFirmMap.get(bestValConfigQuote.APTS_SSD_bill_to__r.Source_System_Account_Number__c));*/
                    //DLT-16854
                    bestValconfigQuoteCloned.Ownerid = digtlOwnerId;
                    bestValconfigQuoteCloned.createdById = digtlOwnerId;
                    
                } else {
                    bestValconfigQuoteCloned.Ownerid = bestValConfigQuote.Apttus_Proposal__Opportunity__r.OwnerId;
                    bestValconfigQuoteCloned.createdById = bestValConfigQuote.Apttus_Proposal__Opportunity__r.OwnerId;
                } 
                
                Database.SaveResult sr = Database.insert(bestValconfigQuoteCloned,false);
                if(!sr.isSuccess()){  
                    
                    Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
                    Database.Error error = sr.getErrors().get(0);
                    String failedDML = error.getMessage();
                    ex.Exception_Message__c = failedDML;
                    ex.Exception_Type__c = 'Quote Clone - Quote Id - '+bestValConfigQuote.id;//failed record from the list
                    for(string errorField : error.getfields()){
                        ex.Additional_Information__c += errorField + ',';            
                    }
                    ex.User_Message__c = String.Valueof(error.getStatusCode());
                    ex.Class_Reference__c = 'Digital_BestProposalAutomation > Digital_BestProposalCloneHelper > createBestValueConfigQuote';
                    exList.add(ex);
                    
                }
                else{
                    
                    String query = queryAllFields('Apttus_Config2__ProductConfiguration__c');
                    query = query + 'Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =\''+String.escapeSingleQuotes(quoteId)+'\'';
                    
                    List<Apttus_Config2__ProductConfiguration__c> bestValConfigCartList = new List<Apttus_Config2__ProductConfiguration__c>();
                    List<Apttus_Config2__ProductConfiguration__c> bestValConfigCartListCloned = new List<Apttus_Config2__ProductConfiguration__c>();
                    bestValConfigCartList = Database.query(query);
                    if(bestValConfigCartList !=null && bestValConfigCartList.size()>0){
                        
                        for(Apttus_Config2__ProductConfiguration__c bestValConfigCart : bestValConfigCartList){
                            
                            Apttus_Config2__ProductConfiguration__c bestValConfigCartCloned = new Apttus_Config2__ProductConfiguration__c();
                            bestValConfigCartCloned = bestValConfigCart.clone(false,true,false,false);
                            bestValConfigCartCloned.Apttus_QPConfig__Proposald__c = bestValconfigQuoteCloned.id;
                            bestValConfigCartCloned.Apttus_Config2__BusinessObjectRefId__c = bestValconfigQuoteCloned.id;
                            // DLT-9536 - Set the Proposal owner based on the Digital Firm
                            bestValConfigCartCloned.OwnerId = bestValconfigQuoteCloned.Ownerid;
                            bestValConfigCartCloned.CreatedbyId = bestValconfigQuoteCloned.Ownerid;
                            
                            bestValConfigCartListCloned.add(bestValConfigCartCloned);
                        }
                        
                        if(!Test.isRunningTest()){
                            lsr = Database.insert(bestValConfigCartListCloned,false);
                        }else if(Test.isRunningTest() && bestValConfigCartListCloned.size() >0){
                            Apttus_Config2__ProductConfiguration__c bestValConfigCartFail = new Apttus_Config2__ProductConfiguration__c();
                            bestValConfigCartFail.APTS_SSD_Bill_To__c = bestValConfigCartListCloned[0].OwnerId;
                            bestValConfigCartListCloned.add(bestValConfigCartFail );
                            lsr = Database.insert(bestValConfigCartListCloned,false);
                        }
                        
                        if(lsr != Null && lsr.size() > 0){  
                            for(i = 0; i < lsr.size(); i++){
                                if(lsr.get(i).isSuccess()){
                                    successCartList.add(lsr.get(i).getId());
                                }
                                else if(!lsr.get(i).isSuccess()){
                                    Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
                                    Database.Error error = lsr.get(i).getErrors().get(0);
                                    String failedDML = error.getMessage();
                                    ex.Exception_Message__c = failedDML;
                                    ex.Exception_Type__c = 'Cart Creation - Quote Id - '+bestValConfigCartListCloned.get(i).Apttus_QPConfig__Proposald__c;//failed record from the list
                                    for(string errorField : error.getfields()){
                                        ex.Additional_Information__c += errorField + ',';            
                                    }
                                    ex.User_Message__c = String.Valueof(error.getStatusCode());
                                    ex.Class_Reference__c = 'Digital_BestProposalAutomation > Digital_BestProposalCloneHelper> createBestValueConfigQuote';
                                    exList.add(ex);
                                }
                            }
                        }
                        
                        if(successCartList != null && successCartList.size()>0){
                            
                            for(Apttus_Config2__ProductConfiguration__c cart : bestValConfigCartListCloned){
                                cart.Name = cart.id;
                            }
                            Database.update (bestValConfigCartListCloned,false);
                            
                            map<String,String> mapSummaryGroup = new map<String,String>();
                            
                            query = queryAllFields('Apttus_Config2__SummaryGroup__c');
                            query = query + 'Apttus_Config2__SummaryGroup__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c  =\''+String.escapeSingleQuotes(quoteId)+'\'';
                            
                            List<Apttus_Config2__SummaryGroup__c> bestValSummaryGroupList = new List<Apttus_Config2__SummaryGroup__c>();
                            List<Apttus_Config2__SummaryGroup__c> bestValSummaryGroupListCloned = new List<Apttus_Config2__SummaryGroup__c>();
                            bestValSummaryGroupList = Database.query(query);
                            
                            if(bestValSummaryGroupList !=null && bestValSummaryGroupList.size()>0){
                                
                                for(Apttus_Config2__SummaryGroup__c sg :bestValSummaryGroupList){
                                    
                                    Apttus_Config2__SummaryGroup__c summaryCloned = new Apttus_Config2__SummaryGroup__c();
                                    summaryCloned = sg.clone(false,true,false,false);
                                    summaryCloned.Apttus_Config2__ConfigurationId__c = bestValConfigCartListCloned[0].id;
                                    bestValSummaryGroupListCloned.add(summaryCloned);
                                }
                                
                                Database.insert(bestValSummaryGroupListCloned,false);
                                i=0;
                                for(Apttus_Config2__SummaryGroup__c sg :bestValSummaryGroupListCloned){
                                    mapSummaryGroup.put(bestValSummaryGroupList.get(i).id,sg.id);
                                    i++;
                                }
                            }
                            
                            map<String,String> mapAdHocGroup = new map<String,String>();
                            
                            query = queryAllFields('Apttus_Config2__AdHocGroup__c');
                            query = query + 'Apttus_Config2__AdHocGroup__c  where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =\''+String.escapeSingleQuotes(quoteId)+'\'';
                            
                            List<Apttus_Config2__AdHocGroup__c> bestValAdhocGroupList = new List<Apttus_Config2__AdHocGroup__c>();
                            List<Apttus_Config2__AdHocGroup__c> bestValAdhocGroupListCloned = new List<Apttus_Config2__AdHocGroup__c>();
                            bestValAdhocGroupList = Database.query(query);
                            
                            if(bestValAdhocGroupList != null && bestValAdhocGroupList.size()>0){
                                
                                for(Apttus_Config2__AdHocGroup__c ad : bestValAdhocGroupList){
                                    
                                    Apttus_Config2__AdHocGroup__c adCloned = new Apttus_Config2__AdHocGroup__c();
                                    adCloned = ad.clone(false,true,false,false);
                                    adCloned.Apttus_Config2__ConfigurationId__c = bestValConfigCartListCloned[0].id;
                                    bestValAdhocGroupListCloned.add(adCloned);
                                    
                                }
                                Database.insert(bestValAdhocGroupListCloned,false);
                                i=0;
                                for(Apttus_Config2__AdHocGroup__c ad : bestValAdhocGroupListCloned){
                                    mapAdHocGroup.put(bestValAdhocGroupList.get(i).id,ad.id);
                                    i++;
                                }
                            }
                            
                            query = queryAllFields('Apttus_Config2__LineItem__c');
                            query = query + 'Apttus_Config2__LineItem__c  where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =\''+String.escapeSingleQuotes(quoteId)+'\'';
                            
                            List<Apttus_Config2__LineItem__c> bestValconfigCartLineList = new List<Apttus_Config2__LineItem__c>();
                            List<Apttus_Config2__LineItem__c> bestValconfigCartLineListCloned = new List<Apttus_Config2__LineItem__c>();
                            bestValconfigCartLineList = Database.query(query);
                            // Added as per the  DLT-11665
                            if(configProductValidation(bestValconfigCartLineList)){
                                
                                if(bestValconfigCartLineList != null && bestValconfigCartLineList.size()>0){
                                    
                                    for(Apttus_Config2__LineItem__c line : bestValconfigCartLineList){
                                        
                                        Apttus_Config2__LineItem__c bestValConfigLineCloned = new Apttus_Config2__LineItem__c();
                                        bestValConfigLineCloned = line.clone(false,true,false,false);
                                        bestValConfigLineCloned.Apttus_Config2__ConfigurationId__c = bestValConfigCartListCloned[0].id;
                                        bestValConfigLineCloned.Apttus_Config2__AdHocGroupId__c = mapAdHocGroup.get(line.Apttus_Config2__AdHocGroupId__c);
                                        bestValConfigLineCloned.Apttus_Config2__SummaryGroupId__c = mapSummaryGroup.get(line.Apttus_Config2__SummaryGroupId__c);
                                        bestValconfigCartLineListCloned.add(bestValConfigLineCloned);
                                    }
                                    
                                    database.insert(bestValconfigCartLineListCloned,false);
                                    
                                }
                                
                                query = queryAllFields('Apttus_Approval__Approval_Request__c');
                                query = query + ' Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c =\''+String.escapeSingleQuotes(quoteId)+'\'';
                                
                                List<Apttus_Approval__Approval_Request__c> lstApprovalRequest = new List<Apttus_Approval__Approval_Request__c>();
                                List<Apttus_Approval__Approval_Request__c> lstApprovalRequestCloned = new List<Apttus_Approval__Approval_Request__c>();
                                lstApprovalRequest = Database.query(query);
                                
                                if(lstApprovalRequest != null && lstApprovalRequest.size() > 0){
                                    
                                    
                                    string processinstanceId = lstApprovalRequest[0].Apttus_Approval__ProcessInstanceId__c;
                                    query = queryAllFields('Apttus_Approval__ApprovalProcessInstance__c');
                                    query = query + 'Apttus_Approval__ApprovalProcessInstance__c  where id =\''+String.escapeSingleQuotes(processinstanceId)+'\'';
                                    
                                    Apttus_Approval__ApprovalProcessInstance__c processInstance = new Apttus_Approval__ApprovalProcessInstance__c();
                                    Apttus_Approval__ApprovalProcessInstance__c processInstanceCloned = new Apttus_Approval__ApprovalProcessInstance__c();
                                    
                                    processInstance = Database.query(query);
                                    processInstanceCloned = processInstance.clone(false,true,false,false);
                                    processInstanceCloned.Apttus_Approval__BusinessObjectId__c = bestValConfigCartListCloned[0].id;
                                    
                                    Database.insert(processInstanceCloned,false);
                                    
                                    for(Apttus_Approval__Approval_Request__c ar : lstApprovalRequest){
                                        
                                        Apttus_Approval__Approval_Request__c arcloned = new Apttus_Approval__Approval_Request__c();
                                        arcloned = ar.clone(false,true,false,false);
                                        arcloned.Apttus_Approval__ProcessInstanceId__c = processInstanceCloned.id;
                                        arcloned.Apttus_Approval__Object_Id__c = bestValConfigCartListCloned[0].id;
                                        arcloned.Apttus_Approval__Object_Name__c = bestValConfigCartListCloned[0].Name;
                                        arcloned.Apttus_CQApprov__CartId__c = bestValConfigCartListCloned[0].id;
                                        arcloned.Apttus_QPApprov__ProposalId__c = quoteId;
                                        arcloned.Best_Value_Request_Id__c = ar.id;
                                        lstApprovalRequestCloned.add(arcloned);
                                    }
                                    
                                    database.insert(lstApprovalRequestCloned,false);
                                    
                                    map<String,String> mapOldArNewAr = new map<String,String>();
                                    i=0;
                                    for(Apttus_Approval__Approval_Request__c ar : lstApprovalRequestCloned){
                                        mapOldArNewAr.put(lstApprovalRequest.get(i).id,ar.id);
                                        i++;
                                    }
                                    
                                    
                                    for(Apttus_Approval__Approval_Request__c ar : lstApprovalRequestCloned){
                                        ar.Apttus_Approval__ParentRequestId__c = mapOldArNewAr.get(ar.Apttus_Approval__ParentRequestId__c);
                                    }
                                    database.update(lstApprovalRequestCloned,false);
                                    
                                }
                                
                                
                                
                                query = queryAllFields('Apttus_Proposal__Proposal_Line_Item__c');
                                query = query + 'Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =\''+String.escapeSingleQuotes(quoteId)+'\'';
                                
                                List<Apttus_Proposal__Proposal_Line_Item__c> bestValConfigPropLines  = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                                List<Apttus_Proposal__Proposal_Line_Item__c> bestValConfigPropLinesCloned  = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                                bestValConfigPropLines = Database.query(query);
                                
                                if(bestValConfigPropLines !=null && bestValConfigPropLines.size()>0){
                                    
                                    for(Apttus_Proposal__Proposal_Line_Item__c pli : bestValConfigPropLines){
                                        
                                        Apttus_Proposal__Proposal_Line_Item__c pliCloned = new Apttus_Proposal__Proposal_Line_Item__c();
                                        pliCloned = pli.clone(false,true,false,false);
                                        pliCloned.Apttus_Proposal__Proposal__c = bestValconfigQuoteCloned.id;
                                        bestValConfigPropLinesCloned.add(pliCloned);
                                        
                                    }
                                    database.insert(bestValConfigPropLinesCloned,false);
                                }
                            }else{
                                bestValconfigQuoteCloned.Digital_Quote_Failure_Reason__c = Label.Digital_ConfigProdValidationMsg;
                            }
                        }
                    } 
                }
                
                bestValconfigQuoteCloned.Digital_Batch_Processed__c = true;
                bestValConfigQuote.Digital_Batch_Processed__c = true;
                lstProposalUpdateDigitalflag.add(bestValConfigQuote);
                lstProposalUpdateDigitalflag.add(bestValconfigQuoteCloned);
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                    update lstProposalUpdateDigitalflag;
                }  
            }
        }Catch(Exception e){
            System.debug('Exception occured while clonning best value quote : '+e);
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = 'Best Value Quote Clone - '+ quoteId;
            ex.User_Message__c = String.Valueof(e.getStackTraceString());
            ex.Class_Reference__c = 'Digital_BestValueProposalCloneAutomation > createBestValueConfigQuote';
            exList.add(ex);
        }
        
        if(exList != Null && exList.size() > 0){
            try{
                database.insert(exList,false);
            }
            Catch(Exception e){
                System.debug('Exception'+e);
            }  
        }
        
    }
    
    public static string queryAllFields(String sobjectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sobjectApiName).getDescribe().fields.getMap();
        
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }            
        }
        // Select the Opp owner id/name so we can correctly set the new Proposal owner
        if(sobjectApiName == 'Apttus_Proposal__Proposal__c'){
            commaSepratedFields = commaSepratedFields + ', ' + 
                'Apttus_Proposal__Opportunity__r.Name, Owner.Name, Apttus_Proposal__Opportunity__r.Owner.Name, ' + 
                'Apttus_Proposal__Opportunity__r.OwnerId, APTS_SSD_ship_to__r.Source_System_Account_Number__c';
        }
        
        //String query = 'select ' + commaSepratedFields + ' from ' + sobjectApiName;
        String query = 'select ' + commaSepratedFields + ' from ';
        
        return query;
    }
    
    // Added  for Product Validation as per the Digital configurator Product Category Hierarchy    
    public static Boolean configProductValidation(List<Apttus_Config2__LineItem__c> bestValconfigCartLineList){
        
        Boolean  isProdValidation = false;
        
        Set<id> configProductSet =new Set<Id>();
        Set<id> productClearSet =new Set<Id>();
        
        for(Apttus_Config2__LineItem__c  lineitem: bestValconfigCartLineList ){
            if(lineitem.Apttus_Config2__LineStatus__c=='New'){
                configProductSet.add(lineitem.Apttus_Config2__ProductId__c);
            }
        }
        
        if(Schema.sObjectType.Apttus_Config2__ProductClassification__c.isAccessible()){
            for (Apttus_Config2__ProductClassification__c  prodClass :[Select Apttus_Config2__ClassificationId__c,Apttus_Config2__ClassificationId__r.Name,Apttus_Config2__ProductId__c from Apttus_Config2__ProductClassification__c where Apttus_Config2__ClassificationId__r.Apttus_Config2__PrimordialId__r.Name = 'Digital Configurator' and Apttus_Config2__ProductId__c =: configProductSet]){
                productClearSet.add(prodClass.Apttus_Config2__ProductId__c);
            }
        }
        
        if(configProductSet.equals(productClearSet)){
            isProdValidation = true;
        }
        
        System.debug('productClearSet==>'+productClearSet); 
        System.debug('configProductSet==>'+configProductSet);
        System.debug('isProdValidation==>'+isProdValidation);
        
        return isProdValidation;
    }
    
}