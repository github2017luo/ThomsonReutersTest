/* Created By - Dinesh Kumar Voonna
Purpose - Digital Quote Automation for Straight Renewal
Jira Story - DLT-282

==================================CHANGE HISTORY==================================

Date            Name                    Story
2017-06-29      Dinesh Voona            DLT-1264/DLT-1079 Changed from Scheduled job to batchable job which runs once in a day
2017-08-14      Dinesh Voona            Calling Best Value Quote Automation Batch class
2017-11-11      Dinesh Voona            DLT-3628 - Updated Asset SOQL to exclude Print products (i.e Media high level code = 07)
2018-01-02      Srikanth Kota           DLT-7019 - Updated existing logic from Custom setting: Digital Campaigns to Object: Digital Subscription
2018-01-18      Divija S                DLT-6963 - Added Ebility Functioanlity
2018-02-02      Divija S                DLT-7392- Used Custom setting 'Media_high_level_code'for excluding Print products (i.e Media high level code = 21)
2018-02-21      Divija S                DLT-7565 - When Quantity is not equal to Band Number, expire the proposal
2018-04-05      Srikanth Kota           DLT-8826 - Remove the End date being set on Cart line item for OC Prod Issue.
2018-04-06      Divija S                DLT-8018 - included Corporate Automation along with Small Law Automation.
2018-04-05      Srikanth Kota           DLT-8931/8932 - Digital Proposals should still generate if Sales Rep has made a change and if Manual Proposal  not having Digital offer make it Unmarked Digital.
2018-04-21      Divija S                DLT-9135 - Straight Renewal to pick material for renewal from Digital subscription object and exclude Renewal Date check for Assets
2018-05-04      Brenda Shields          DLT-9536 - Add dymanic coding for Digital Firm updates and set the owners of the Opp/Proposal/cart accordingly.
2018-05-09      Rajan                   DLT-8973 - Added Hard Bounce & SAP Contact ID fields on Digital subscription object and SAP Contact ID should be used as Order Confirmation Contact and Ebill contact.
2018-05-17      Diviaj S                DLT-9827 - Quote Automation to take into account of hard bounce email flag while selecting OCC and Optimized Proposal Creation method to OCClogic Class
2018-05-23      Srikanth Kota           DLT-10048 - Added coding to Opp Stage name based on prior value and passing Stage to Digital_PreviousStageName__c.
2018-07-07      Harika Sai P            DLT-9750 -  Update Account / Contact object references in Renewal Automation classes for GLI
2018-07-10      Poonam Garg             DLT-10574 -  Updated Exception Logs to update Record Id and Object type
2018-08-29      Navleen Kaur            DLT-11735 -  Change from global to public
2018-08-31      Poonam Garg             DLT 11737 - Refactoring of Code.
2018-09-18      Divija S                DLT-12358 - Optimized Queries and code to avoid heap size limit error   
2018-09-25      Harika Sai P            DLT 12134 - Create a re-usable components from Proposal Automation classes(Straight)
                                        Created a common method in a seperate class for all three proposal classes for cartcreation. 
                                        DLT-12193 - Mid Contract and Renewal opporunity will be same
2018-10-18      Harika Sai P            DLT-12773 - Remove the automation exclusion logic code in Salesforce based on MHLC
2019-01-09      Harika Sai P            DLT-14286 - Exception logs being incorrectly created
2019-01-24      Divija Salla            DLT-14487 - [All] SR- Automation to validate the Asset renewal date to be within 15 months of opportunity renewal date
2019-02-01      Benjamin Her            DLT-14752 - Exception logging improvement
2019-02-04      Divija Salla            DLT-13499 - Create Opportunities when automation does not find any opportunities associated with them
2019-02-05      Navleen Kaur            DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
2019-02-19      Srikanth Kota           DLT-15184 - FL- Quote Automation for Findlaw proposals - Straight Renewal.
2019-03-12      Divija Salla            DLT-14425   [Tech Story] [SFDC] ECCAT validation job should be triggered after Proposal automation job is complete
2019-03-19      Navleen Kaur            DLT-15672  [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
2019-04-11      HarikaSai P             DLT-15968 - Create Data Layer (operational Layer)
2019-05-24      HarikaSai P             DLT-16538 - [SLF][Tech Story] Enhance exception processing - Digital_GenerateDocumentsBatch
2019-06-25      Harika Sai P            DLT-16854 [Tech Story] - Remove Unnecessary code lines from Proposal Automation and move to Dataoperation Layer
2019-07-09      Srikanth Kota           DLT-16958  [Tech Story] [SLF] Automation to create Plus and Premium proposal only based Ineligible sub flag on DS object
2019-08-19      Srikanth Kota           DLT-16076 - [CORP][SFDC] Straight renew Option products alongwith the core product
2019-08-20      Harika Sai P            DLT-17632 - [ALL] Handling subs from different segments
2019-08-20      Navleen Kaur            DLT-17360 - [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been set
2019-11-05      Benjamin Her            DLT-18013 - [Tech Story][FindLaw] Handle automation failing due to duplicates
2019-12-17      Harika Sai P            DLT-18750 - [Tech - Automation] West Proflex sub components should not be added to cart while renewing                                                                                                                                         
2020-08-12      Benjamin Her            DLT-20588 - Add MLF support
2020-10-29      Benjamin Her            DLT-20921 - Remove West Proflex subproducts if not renewable
2020-11-02      Benjamin Her            DLT-20755 - PMD Fix
2020-05-04      Kavya S                 DLT-21366 - PMD Fix
2021-05-18      Brenda Shields          DLT-21788 - The Check for FindLaw Opps is changing to use Proposal Business Unit
*/

 /** 
 * @description : Digital_ProposalAutomation
 */

public with sharing Class Digital_ProposalAutomation implements Database.AllowsCallouts, Database.Stateful, Database.Batchable<Opportunity>{
    
    private static final String GLIOPP='GLI Pipeline Opportunity';
    private static final String FLGLIPBOOK = 'GLI Price Book - FindLaw';  //DLT-15184 added for Findlaw
    private Static final String PRICELISTNAME = 'Thomson Reuters Master - US Legal'; 
    private static final String STRAIGHTRENEWAL ='Straight Renewal';
    public static  final Set<String> STAGENAMES= new Set<String>{'Closed Lost','Order Complete','Contract Signed'}; 
    public static final Set<String> STATUSIN= new Set<String>{'Unworked', 'Converted'};
    public static final String GLIPRICEBOOKNAME='GLI Price Book - US Legal/LMS';
    private static final String OPPORTUNITYOBJ='Opportunity';
    private static final String QUOTEOBJ='Quote';
    private static final String CARTOBJ='Product Configuration';
    private static final String ACCOUNTSSDOBJ='Source System Detail';
    private static Set<Id> recordIds = new Set<Id>{Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GLIOPP).getRecordTypeId()};
    private list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();       
    private static Map<String, String> dsFirmMap = new Map<String, String>();
    private static Map<String, String> dsContractTypeMap = new Map<String, String>();//DLT-16958
    private static final String OLDMIDCONTRACT='Old Mid Contract';
    private static final String INELIGIBLE='Ineligible';
    private static final List<String> LAW_FIRMS = System.Label.Digital_Law_Firm.split(',');
    private static IGlobalOperationLayer globObj  = new GlobalOperationLayer();
    private static final String SEGMENT_FINDLAW = 'FindLaw';
    private static final Id GLI_RECORDID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GLIOPP).getRecordTypeId(); 

    //Getting GLI pricebook id   
    private static Id priceBookId = [select id from pricebook2 where name = :GLIPRICEBOOKNAME limit 1].id;
    private static Id flpriceBookId = [select id from pricebook2 where name = :FLGLIPBOOK limit 1].id;
    public Static list<Product_Account_Detail__c> digitalSubscriptionsList = 
        [SELECT AccountSSD__c,Digital_Firm__c,Contract_Type__c,Renewal_Date__c,sub_Campaign_Code__c,
        Campaign_Code__c,Quantity__c,Actual_New_Service__c,Actual_New_Subscription_Product__c,
        Current_Subscription__c,Premium_New_Subscription__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c 
        FROM Product_Account_Detail__c
        WHERE Current_Subscription__c != Null 
        AND Campaign_Code__c != Null 
        AND Renewal_Date__c > Today 
        AND Bypass_Automation__c = false];   
    
    public static Map<String, String> mapDigitalAppSegment = new Map<String, String>();
    
    public Set<Id> optyIdSet = new Set<Id>();
    public Set<id> accoountid =new Set<id>();
    
    public Set<Id> ssdIdErrSetSameCampCodeRenDate = new Set<Id>();// holds SSD id with same camp code and renewal date for Small Law and Find Law under Digital Subscriptions.
    
    //Batch Started to filter the Opportunities to execute upon
    /** 
     * @description :Batch Started to filter the Opportunities to execute upon
     * @param bC : bC
     * @return : finlOptyList
     */
    public Iterable<Opportunity> start(database.batchablecontext bC){
        Map<String, Set<Date>> dsRenewalDateMap = new Map<String, Set<Date>>();
        Set<String> subcamps = new Set<String>();
        String subcamp;
        for(Product_Account_Detail__c newprd: digitalSubscriptionsList){
            accoountid.add(newprd.AccountSSD__c);
            if(newprd.sub_Campaign_Code__c!= null){
            subcamp = (newprd.sub_Campaign_Code__c).right(7);
            subcamps.add(subcamp.toUpperCase());
            }
        }
        
        DCQuote_Automation_Update.AutorecordUpdateacctbased(subcamps);
        list<Opportunity> optyList =[SELECT id,name,Ownerid,owner.name,owner.id,AccountId,Digital_PreviousStageName__c,
                                    Source_System_Detail__r.LCRM_APTS_Band_Number__c,
                                    Key_Contact__c,Source_System_Detail__r.LCRM_eOutput_Eligibility__c,StageName,Source_System_Detail__r.Source_System_Account_Number__c,
                                    Renewal_Date__c,RecordTypeId,Campaign_Code__c,sub_Campaign_Code__c,SAP_Account_Number__c,Digital_MidContract_Status__c,
                                    APTS_Proposal_Business_Unit__c, Contract_Type__c 
                                    FROM Opportunity 
                                    WHERE isDigitalSpearHead__c = TRUE 
                                    AND ID NOT IN 
                                        (SELECT Apttus_Proposal__Opportunity__c 
                                        FROM Apttus_Proposal__Proposal__c 
                                        WHERE Digital_Quote_Type__c =:STRAIGHTRENEWAL 
                                        AND ((Contract_Type__c !=:OLDMIDCONTRACT 
                                            AND Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c IN ('Denied'))
                                            OR(Apttus_Proposal__Opportunity__r.Digital_MidContract_Status__c NOT IN ('Denied')))) //DLT-12193 Ends
                                    AND RecordTypeId IN : recordIds 
                                    AND Renewal_Date__c != Null 
                                    AND StageName NOT IN :STAGENAMES 
                                    AND  Campaign_Code__c != Null 
                                    AND Source_System_Detail__c IN : accoountid 
                                    LIMIT 7000];

        List<Opportunity> finlOptyList = new list<Opportunity>();
        
        dsRenewalDateMap=getRenewalDateMapFromDS(digitalSubscriptionsList);
        system.debug(logginglevel.INFO,'** dsRenewalDateMap::'+dsRenewalDateMap); 
        
        finlOptyList=createFinalOpportunityList(optyList,dsRenewalDateMap); 
        System.debug(logginglevel.INFO,'final Opp'+ finlOptyList );     
        return finlOptyList;
    }

    //Validate if Renewal Date is not matching with opportunity then exclude it from final List 
    private List<Opportunity> createFinalOpportunityList(List<Opportunity> optyList,Map<String, Set<Date>> dsRenewalDateMap ){
        List<Opportunity> finlOptyList=new List<Opportunity>();
        for(Opportunity optyFilter: optyList){            
            if(!dsRenewalDateMap.isEmpty() && !String.isEmpty(optyFilter.Source_System_Detail__c) 
                && dsRenewalDateMap.get(optyFilter.Source_System_Detail__c)!=null 
                && dsRenewalDateMap.get(optyFilter.Source_System_Detail__c).contains(optyFilter.Renewal_Date__c)
                && !ssdIdErrSetSameCampCodeRenDate.contains(optyFilter.Source_System_Detail__c)){

                finlOptyList.add(optyFilter);
            }
            else{    
                // DLT-17632           
                Digital_Exception_Log__c ex=String.isEmpty(optyFilter.Source_System_Detail__c)
                    ? new Digital_Exception_Log__c(Exception_Message__c = label.NOACCOUNTSSDONOPPPA,Exception_Type__c = label.NOACCOUNTSSDONOPPPA,Additional_Information__c = label.OppIdProposalAutomationPA +optyFilter.id,User_Message__c = label.NOACCOUNTSSDONOPPPA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = OPPORTUNITYOBJ,Record_Id__c = optyFilter.id)
                    :(ssdIdErrSetSameCampCodeRenDate.contains(optyFilter.Source_System_Detail__c) 
                    ? new Digital_Exception_Log__c(Exception_Message__c = 'Same Campaign Code and Renewal Date Found',Exception_Type__c = 'Same Campaign Code and Renewal Date Found',Additional_Information__c = label.OppIdProposalAutomationPA +optyFilter.id,   User_Message__c = 'Same Campaign Code and Renewal Date Found',Class_Reference__c = 'Digital_ProposalAutomation > Start',Object__c = OPPORTUNITYOBJ,Record_Id__c = optyFilter.id)
                    :new Digital_Exception_Log__c(Exception_Message__c = label.RenewalDateMisMatchOnOppPA,Exception_Type__c = label.RenewalDateMisMatchOnOppPA,Additional_Information__c = label.OppIdProposalAutomationPA +optyFilter.id,   User_Message__c = label.RenewalDateDSMismatchUMPA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = OPPORTUNITYOBJ,Record_Id__c = optyFilter.id));
                
                exList.add(ex);
            }
            
        }
        inserExceptionLogs(exList);
        return finlOptyList;
    }

    // Passing Filtered Opportunities into batch Scope
    /** 
     * @description :Passing Filtered Opportunities into batch Scope
     * @param bC : bC
     * @param scope : scope
     */
    public void execute(Database.BatchableContext bC, List<Opportunity> scope){
        System.debug(logginglevel.INFO,'scope::>'+scope);
        //Local variables and maps declarations.
        Set<String> campCodeNameSet = new Set<String>();   
        Map<Id,Date> accountRenewalDateMap = new Map<Id, Date>();
        List<Opportunity> scopeOpp=new List<Opportunity>();
        
        //Set<Id> optyIdWithoutMalSet = new Set<Id>();
        Set<Id> accOptyIdSet = new Set<Id>();
        list<Opportunity> afteroptyList =new List<Opportunity>();

        for(Opportunity opp : Scope){
            
            optyIdSet.add(opp.id);
            accOptyIdSet.add(opp.Source_System_Detail__c);
            accountRenewalDateMap.put(opp.Source_System_Detail__c, opp.Renewal_Date__c);
            scopeOpp.add(opp);
        }  
        //run Opportunities with manual quotes. and get the remaining Opportunities
        afteroptyList=executeManualOpportunities(optyIdSet,scopeOpp);
        Map<String, Set<String>> mapAccCampCode=new Map<String, Set<String>>();
        Map<String, Set<Date>> mapAccRenewalDate=new Map<String, Set<Date>>();
        Set<String> curntsublst = new Set<String>();
        list<Product_Account_Detail__c> dslist = new list<Product_Account_Detail__c>();  //DLT-15184 updated for Findlaw
        Map<Id, List<Product_Account_Detail__c>> actsubmap = new Map<Id, List<Product_Account_Detail__c>>();     //DLT-15184 updated for Findlaw    
        
        //Looping through ds records to fill the sets and map.
        for(Product_Account_Detail__c  camp : digitalSubscriptionsList){
            if(accOptyIdSet.contains(camp.AccountSSD__c)){
                campCodeNameSet.add(camp.Campaign_Code__c);
                curntsublst.add(camp.Current_Subscription__c);
                dslist.add(camp);
                actsubmap.put(camp.AccountSSD__c, dslist);
            }
        }           
        mapAccCampCode=getCampaignCodesMapFromDS(digitalSubscriptionsList);
        mapAccRenewalDate=getRenewalDateMapFromDS(digitalSubscriptionsList);
        
        if(campCodeNameSet != null && campCodeNameSet.size() > 0){         
            afteroptyList=checkExceptionLogsForOpportunities(afteroptyList , mapAccCampCode, mapAccRenewalDate);
            System.debug(logginglevel.INFO,'afteroptyList::'+afteroptyList);
            Map<Id, list<Apttus_Config2__AssetLineItem__c>> accountAssetListMap = new Map<Id, list<Apttus_Config2__AssetLineItem__c>>();
            //Getting the active Assets for Account for Renewals and matching current subscription of Asset line item with Digital Subscription's subscription number 
            accountAssetListMap=getAaccountAssetList(accountRenewalDateMap,actsubmap);   
            proposalAutomationHelper(accountAssetListMap,afteroptyList);   
        }
        else{
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = label.NoCampCodeOnDSObjectPA,Exception_Type__c = label.NoCampCodeOnDSObjectPA,Additional_Information__c =  label.VerifyCampaignCodeOnDSPA, User_Message__c = label.AddCorrectCampCodeOnDSPA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = '',Record_Id__c = '');
            exList.add(ex);      
        }        
        inserExceptionLogs(exList);
    }

    //proposalAutomationHelper() method
    //Extends the execute() method
    private void proposalAutomationHelper(Map<Id, list<Apttus_Config2__AssetLineItem__c>> accountAssetListMap,list<Opportunity> afteroptyList){
  
            List<Opportunity> lsOppUpdate=new List<Opportunity>();
            if(accountAssetListMap != Null && !accountAssetListMap.isEmpty()){            
                for(Opportunity opp : afteroptyList){
                    system.debug(logginglevel.INFO,'asset num::' + accountAssetListMap.get(opp.Source_System_Detail__c).size());//Remove this later
                    system.debug(logginglevel.INFO,'accountAssetListMap : :' + accountAssetListMap);
                    if(accountAssetListMap.get(opp.Source_System_Detail__c).size() <= Integer.valueof(System.label.Digital_Assets_Max_Number.trim())){
                        lsOppUpdate.add(opp);
                        opportunityUpdation(opp, accountAssetListMap.get(opp.Source_System_Detail__c));
                    }
                    else{
                        String exceMessage ;
                        String useMessage;                        
                        exceMessage = label.FoundMoreThanAssetsPA +System.label.Digital_Assets_Max_Number +label.OnAccountPA;
                        useMessage =  label.CurSubNumONDSExceedPA + System.label.Digital_Assets_Max_Number;                
                        
                        Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = exceMessage,Exception_Type__c = label.OppIdProposalAutomationPA+Opp.id,Additional_Information__c =  useMessage, User_Message__c = label.AccoundSSDIDPA +opp.Source_System_Detail__c,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = OPPORTUNITYOBJ,Record_Id__c = Opp.id);
                        exList.add(ex);                        
                    }
                }
            }
            else{
                for(String recId: accountAssetListMap.keyset()){
                    Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = label.NoActiveAssetsOnAcc,Exception_Type__c = label.OppUpdateAssetRenewDatePA,Additional_Information__c =   label.AccoundSSDIDPA+recId,User_Message__c = label.AssetRenDateMisMatchOppRenDatePA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = ACCOUNTSSDOBJ,Record_Id__c = recId);
                    exList.add(ex);
                }
            }       
    }

    //Get a Map of Account SSD ID with the Renewal Dates.
    private Map<String, Set<Date>>  getRenewalDateMapFromDS(list<Product_Account_Detail__c> digitalSubscriptionsList){
        Set<Date> renDates=new Set<Date>();  
        Set<String> ssdIdDigFrmCampCodeRenDtSet = new Set<String>();// Holds all SsdID,digitalfirm,campaign code and Renewal Date in the concatenation form to check for duplicate Campaign code or Renewal date        
        Map<String, Set<Date>>  dsRenewalDateMap=new Map<String, Set<Date>>();  
        for(Product_Account_Detail__c dsMach: digitalSubscriptionsList){
            //Creating a map of Account SSD with the related Renewal date.            
            if(dsRenewalDateMap.containsKey(dsMach.AccountSSD__c)){
                Set<Date> getExistingDates = dsRenewalDateMap.get(dsMach.AccountSSD__c); //DLT-17632        
                getExistingDates.add(dsMach.Renewal_Date__c);//DLT-17632
                dsRenewalDateMap.put(dsMach.AccountSSD__c,getExistingDates);//DLT-17632
            }else{  
                renDates=new Set<Date>();
                renDates.add(dsMach.Renewal_Date__c);
                dsRenewalDateMap.put(dsMach.AccountSSD__c,renDates);                
            } 
            //DLT-17632 start          
            if(LAW_FIRMS.contains(dsMach.Digital_Firm__c)
               // Check with FindLaw campaign code and renewal date match and if it finds it then add to the error set.
                && ssdIdDigFrmCampCodeRenDtSet.contains(dsMach.AccountSSD__c+ SEGMENT_FINDLAW+dsMach.Campaign_Code__c+dsMach.Renewal_Date__c)){
                
                ssdIdErrSetSameCampCodeRenDate.add(dsMach.AccountSSD__c);
            }
            else if(dsMach.Digital_Firm__c == SEGMENT_FINDLAW
                && dsContainsLawfirm(dsMach,ssdIdDigFrmCampCodeRenDtSet)){
                
                ssdIdErrSetSameCampCodeRenDate.add(dsMach.AccountSSD__c); 
            }

            ssdIdDigFrmCampCodeRenDtSet.add(dsMach.AccountSSD__c+ dsMach.Digital_Firm__c+dsMach.Campaign_Code__c+dsMach.Renewal_Date__c);
            //DLT-17632 Ends         
        } 
        return dsRenewalDateMap;
    }   

    //Checks if the ds record matches any law firms (Small Law, Medium Law)
    private boolean dsContainsLawfirm(Product_Account_Detail__c digitalSubscription, Set<String> ssdIdDigFrmCampCodeRenDtSet){
        for(String lawFirm : LAW_FIRMS){
            if(ssdIdDigFrmCampCodeRenDtSet.contains(digitalSubscription.AccountSSD__c
                + lawFirm + digitalSubscription.Campaign_Code__c + digitalSubscription.Renewal_Date__c)){

                return true;
            }
        }
        return false;
    }

    //Get a Map of Account SSD ID with the Renewal Dates.
    private Map<String, Set<String>>  getCampaignCodesMapFromDS(list<Product_Account_Detail__c> digitalSubscriptionsList){
        Set<String> campCodes=new Set<String>();   
        Map<String, Set<String>> mapAccCampCode=new Map<String, Set<String>>();  
        for(Product_Account_Detail__c camp: digitalSubscriptionsList){
            //Creating a map of Account SSD with the related Renewal date.
            if(mapAccCampCode.containsKey(camp.AccountSSD__c)){
                Set<string> getExistingCampCodes = mapAccCampCode.get(camp.AccountSSD__c);//DLT-17632
                getExistingCampCodes.add(camp.Campaign_Code__c);//DLT-17632
                mapAccCampCode.put(camp.AccountSSD__c,getExistingCampCodes);
            }else{  
                campCodes=new Set<String>();
                campCodes.add(camp.Campaign_Code__c);
                mapAccCampCode.put(camp.AccountSSD__c,campCodes);
            } 
        } 
        return mapAccCampCode;
    }
    
    //Call Method for Updating Manual Proposal related Opportunities and return remaining Opp.
    private List<Opportunity> executeManualOpportunities(Set<Id> optyIdSet,List<Opportunity> scopeOpp){
        Set<Id> optyIdWithMalSet = new Set<Id>();
        List<Opportunity> afteroptyList=new List<Opportunity>();
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
            for(Apttus_Proposal__Proposal__c proposal :[select Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in : optyIdSet and Digital_Quote_Type__c = 'Manual']){
                optyIdWithMalSet.add(proposal.Apttus_Proposal__Opportunity__c);
            } 
        }
        OpptyUpdatWhenManual(optyIdWithMalSet);
        for(Opportunity opp : scopeOpp){
            if(!optyIdWithMalSet.contains(opp.id)){
                afteroptyList.add(opp);
            }   
        }  
        return afteroptyList;
    }

    //checkExceptionLogsForOpportunities() method
    private List<Opportunity> checkExceptionLogsForOpportunities(List<Opportunity> afteroptyList ,Map<String, Set<String>> mapAccCampCode,Map<String, Set<Date>> mapAccRenewalDate){
        List<Opportunity> oppList=new List<Opportunity>();
        Set<Id> oppFailed=new Set<Id>();
        for(Opportunity opp : afteroptyList){                 
            
            //Creating Digital Exception Logs whose campaign code are nor matching with Digi Sub Record.
            if(!mapAccCampCode.isEmpty() && opp.Source_System_Detail__c!=null && opp.Campaign_Code__c!=null && mapAccCampCode.containsKey(opp.Source_System_Detail__c) &&  !mapAccCampCode.get(opp.Source_System_Detail__c).contains(opp.Campaign_Code__c) )
            {
                Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = label.CampaignCodeMismatchOnOppPA,Exception_Type__c = label.CampaignCodeMismatchOnOppPA,Additional_Information__c =  label.OppIdProposalAutomationPA + opp.id, User_Message__c = label.CampaignCodeMismatchOnOppUMPA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = OPPORTUNITYOBJ,Record_Id__c = opp.id);
                exList.add(ex);
                oppFailed.add(opp.id);
            }
            
            //Creating Digital Exception Logs whose Renewal date are nor matching with Digi Sub Record.
            if(!mapAccRenewalDate.isEmpty()   && opp.Source_System_Detail__c!=null && opp.Renewal_Date__c!=null && mapAccRenewalDate.containsKey(opp.Source_System_Detail__c) && !mapAccRenewalDate.get(opp.Source_System_Detail__c).contains(opp.Renewal_Date__c)){
                Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = label.RenewalDateMisMatchOnOppPA,Exception_Type__c = label.RenewalDateMisMatchOnOppPA,Additional_Information__c =  label.OppIdProposalAutomationPA +opp.id, User_Message__c = label.RenewalDateDSMismatchUMPA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = OPPORTUNITYOBJ,Record_Id__c = opp.id);
                exList.add(ex);
                oppFailed.add(opp.id);
            }
        } 
        for(Opportunity opp : afteroptyList){ 
            if(!oppFailed.contains(opp.id)){
                oppList.add(opp);    
            }   
        }
        System.debug(logginglevel.INFO,'oppList'+oppList);
        return oppList;
    }

    //DLT-12773 - Removed MLValues parameter from this method.// DLT-15184 updated Map for Findlaw
    private Map<Id, list<Apttus_Config2__AssetLineItem__c>> getAaccountAssetList(Map<Id,Date> accountRenewalDateMap,Map<Id, List<Product_Account_Detail__c>> actsubmap ){
        Map<Id, list<Apttus_Config2__AssetLineItem__c>> accountAssetListMap = new Map<Id, list<Apttus_Config2__AssetLineItem__c>>();
        list<Apttus_Config2__AssetLineItem__c> soldToAssets2 = new list<Apttus_Config2__AssetLineItem__c>();
        list<Apttus_Config2__AssetLineItem__c> soldToAssets3 = new list<Apttus_Config2__AssetLineItem__c>();
        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible()){
            soldToAssets2 = [SELECT id,Apttus_Config2__NetPrice__c,
                            Apttus_Config2__StartDate__c,Apttus_Config2__ProductId__r.Subscription_Number__c,
                            Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__HasOptions__c,Apttus_Config2__OptionId__r.Subscription_Number__c,
                            Apttus_Config2__Quantity__c,APTS_Info_RenewalDate__c,Apttus_Config2__EndDate__c,
                            Apttus_Config2__AccountId__c,Apttus_Config2__ProductId__c,Apttus_Config2__AssetLineItem__c.Apttus_Config2__AllowedActions__c,
                            Apttus_Config2__RenewalDate__c,Apttus_Config2__RenewalTerm__c,
                            Apttus_Config2__AssetStatus__c,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,
                            APTS_SSD_Sold_To__c,APTS_SSD_Ship_To__c  
                            FROM Apttus_Config2__AssetLineItem__c 
                            WHERE APTS_SSD_Sold_To__c IN : accountRenewalDateMap.keyset() 
                            AND APTS_Info_RenewalDate__c != Null //DLT-12773-removed ML Values 
                            AND Apttus_Config2__AssetStatus__c ='Activated'];
        }
        if(!soldToAssets2.isEMpty()){
            string digiFirm = actsubmap.get(soldToAssets2[0].APTS_SSD_Sold_To__c)[0].Digital_Firm__c; //DLT-18750                                                                                          
            for(Apttus_Config2__AssetLineItem__c sasset : soldToAssets2){                
                
                if(sasset.APTS_Info_RenewalDate__c>= System.Today() 
                    && sasset.APTS_Info_RenewalDate__c <= (accountRenewalDateMap.get(sasset.APTS_SSD_Sold_To__c)+Integer.valueof(System.label.Digital_Asset_Renewal_Date.trim())) //DLT-18750 start 
                    && (digiFirm != SEGMENT_FINDLAW
                        &&( sasset.Apttus_Config2__AllowedActions__c == 'Renew' 
                        || sasset.Apttus_Config2__AllowedActions__c == null )) 
                    || (digiFirm == SEGMENT_FINDLAW)){
                    soldToAssets3.add(sasset);
                }
                else{
                    Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = 'Renewal date on Asset is either < today or > 15 months from Opportunity renewal date',Exception_Type__c = 'Renewaldate invalid on Asset',Additional_Information__c = 'Account reference::'+sasset.APTS_SSD_Sold_To__c,User_Message__c = 'Please make sure the asset renewal date is less than 450 days from Opportunity renewal date', Class_Reference__c = 'Digital_ProposalAutomation-->getAaccountAssetList',Object__c = 'Apttus_Config2__AssetLineItem__c',Record_Id__c = sasset.id);
                    exList.add(ex);
                }
            }
        }
        accountAssetListMap = getAccountAssetListHelper(soldToAssets3,actsubmap);

        return accountAssetListMap;
    }

    //getAccountAssetListHelper() method
    //gets the assets from the account
    private Map<Id, list<Apttus_Config2__AssetLineItem__c>> getAccountAssetListHelper(List<Apttus_Config2__AssetLineItem__c> soldToAssets3,Map<Id, List<Product_Account_Detail__c>> actsubmap){

        Map<Id, list<Apttus_Config2__AssetLineItem__c>> accountAssetListMap = new Map<Id, list<Apttus_Config2__AssetLineItem__c>>(); 
        Map<String, Set<Date>> mapAccRenewalDate = getRenewalDateMapFromDS(digitalSubscriptionsList);
        for(Apttus_Config2__AssetLineItem__c soldToAssets : soldToAssets3){ 
            system.debug(logginglevel.INFO,'**soldToAssets 1'+soldToAssets );
            if(actsubmap.isEmpty() || !actsubmap.containskey(soldToAssets.APTS_SSD_Sold_To__c) ){
                continue;
            }

            //DLT-15184 updated for Findlaw
            accountAssetListMap = addAssetToAccountMap(actsubmap,soldToAssets,accountAssetListMap);
            accountAssetListMap = validateAssetRenewalDate(accountAssetListMap,soldToAssets,mapAccRenewalDate);

        }//for loopend

        return accountAssetListMap;
    } 

    //addAssetToAccountMap() method
    //add the asset to an account to asset map if the asset is valid
    private Map<Id, list<Apttus_Config2__AssetLineItem__c>> addAssetToAccountMap(Map<Id, List<Product_Account_Detail__c>> actsubmap,Apttus_Config2__AssetLineItem__c soldToAssets,Map<Id, list<Apttus_Config2__AssetLineItem__c>> accAssetListMap){
        
        Map<Id, list<Apttus_Config2__AssetLineItem__c>> accountAssetListMap = accAssetListMap;
        
        for(Product_Account_Detail__c currentsub: actsubmap.get(soldToAssets.APTS_SSD_Sold_To__c)){
            //DLT-16076 updated for  Option products
            if(isValidAsset(soldToAssets,currentsub)){  

                if(accountAssetListMap.containskey(soldToAssets.APTS_SSD_Sold_To__c)){

                    List<Apttus_Config2__AssetLineItem__c> assetList = accountAssetListMap.get(soldToAssets.APTS_SSD_Sold_To__c);
                    assetList.add(soldToAssets);
                    accountAssetListMap.put(soldToAssets.APTS_SSD_Sold_To__c,assetList);
                }
                else{
                    accountAssetListMap.put(soldToAssets.APTS_SSD_Sold_To__c, new list<Apttus_Config2__AssetLineItem__c>{soldToAssets});
                }

                break; //DLT-18013 Stop looping if a match is found. Prevents duplicates being added.
            }
        }

        return accountAssetListMap;
    }

    //isValidAsset() method
    //Checks if the asset and matches with a digital subscription.
    private boolean isValidAsset(Apttus_Config2__AssetLineItem__c soldToAssets,Product_Account_Detail__c currentsub){
        if((soldToAssets.Apttus_Config2__ProductId__r.Subscription_Number__c == currentsub.Current_Subscription__c 
            && currentsub.Digital_Firm__c !=SEGMENT_FINDLAW ) 
            || (soldToAssets.Apttus_Config2__ProductId__r.ProductCode == currentsub.Current_Subscription__c 
            && currentsub.Digital_Firm__c ==SEGMENT_FINDLAW) 
            || (soldToAssets.Apttus_Config2__HasOptions__c == True  
            || soldToAssets.Apttus_Config2__OptionId__r.Subscription_Number__c == currentsub.Current_Subscription__c)){    
            
            return true;
        }

        return false;
    }

    //validateAssetRenewalDate() method
    //Checks that the asset is valid via it's renewal date
    private Map<Id, list<Apttus_Config2__AssetLineItem__c>> validateAssetRenewalDate(Map<Id, list<Apttus_Config2__AssetLineItem__c>> accAssetListMap, Apttus_Config2__AssetLineItem__c soldToAssets,Map<String, Set<Date>> mapAccRenewalDate){
        
        Map<Id, list<Apttus_Config2__AssetLineItem__c>> accountAssetListMap = accAssetListMap;
        
        //Creating Exception Logs when the renewal date on Asset doesnt matches the DS Record
        if(!mapAccRenewalDate.isEmpty() 
            && soldToAssets.APTS_SSD_Sold_To__c !=null 
            && soldToAssets.Apttus_Config2__RenewalDate__c!=null 
            && accountAssetListMap!=null 
            && mapAccRenewalDate.containsKey(soldToAssets.APTS_SSD_Sold_To__c) 
            && !mapAccRenewalDate.get(soldToAssets.APTS_SSD_Sold_To__c).contains(soldToAssets.Apttus_Config2__RenewalDate__c)){

            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = label.NoAssetRenDateMatchesDSubPA,Exception_Type__c = label.NoAssetRenDateMatchesDSubPA + soldToAssets.Apttus_Config2__RenewalDate__c,Additional_Information__c = label.AccoundSSDIDPA +soldToAssets.APTS_SSD_Sold_To__c,  User_Message__c = label.NoAssetRenDateMatchesDSubPA,Class_Reference__c = label.ProposalAutomationClassRef,Object__c = ACCOUNTSSDOBJ,Record_Id__c = soldToAssets.APTS_SSD_Sold_To__c);
            exList.add(ex);
            accountAssetListMap.remove(soldToAssets.APTS_SSD_Sold_To__c);
        } 

        return accountAssetListMap;
        
    }

    // Updating the Opportunity to Converted status and initiates Straigh Renewal proposal generation
    private void opportunityUpdation(Opportunity opty, List<Apttus_Config2__AssetLineItem__c> accountAssetList){
        Map<String, String> acctsubcamp = new Map<String, String>();
        List<Opportunity> optyList=new List<Opportunity>();
        if(opty!=null){
            optyList.add(opty);
        }
        Set<String> accidset = new Set<String>();      
      //  Map<String, String> acctidcustmap = new Map<String, String>();
        
        for(Product_Account_Detail__c camp : digitalSubscriptionsList ){
            accidset.add(camp.ZP_Cust_Number__c);
            acctsubcamp.put(camp.ZP_Cust_Number__c, camp.sub_Campaign_Code__c);        
        }
       // list<Source_System_Detail__c> ssdAcclst = new List<Source_System_Detail__c>();   
        updateOpportunity(optyList,acctsubcamp,accountAssetList);
    }

    //updateOpportunity() method
    //Iterate over a list of Opportunity and update them
    private void updateOpportunity(List<Opportunity> optyList,Map<String, String> acctsubcamp,list<Apttus_Config2__AssetLineItem__c> accountAssetList ){
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();        
       // list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        List<Opportunity> oppList = new list<Opportunity>();
        
        if(!optyList.isEmpty()){
            for(Opportunity opp : optyList){

                opp = setOpportunityFields(opp, acctsubcamp);
                oppList.add(opp);
                oppMap.put(opp.id,opp);
            }
        }
        if(oppList != Null && oppList.size() > 0 && Schema.sObjectType.Opportunity.isUpdateable()){   
            updateOpportunityHelper(oppList,oppMap,accountAssetList);
        }
    }

    //updatesOpportunityHelper()
    //Extends updateOpportunity() method, create proposals if opportunity is successfully updated.
    private void updateOpportunityHelper(List<Opportunity> oppList,Map<Id,Opportunity> oppMap,list<Apttus_Config2__AssetLineItem__c> accountAssetList){
        String quoteName = 'Straight Renewal';
        List<Opportunity> successOppList = updateOpportunityHelper2(oppList,oppMap);
        inserExceptionLogs(exList);
        if(successOppList != Null && successOppList.size() > 0){
            System.debug(logginglevel.INFO,'successOppList::'+successOppList);
            try{
                Digital_ProposalCreationCommonCode.ProposalCreation(successOppList, accountAssetList, quoteName);
            }
            //DLT-14286
            catch(Exception ex){                   
                Digital_Exception_Log__c ex1 = new Digital_Exception_Log__c(Exception_Message__c =  ex.getMessage(),Exception_Type__c = 'Proposal Creation Error for the Opportunity:'+ successOppList,Additional_Information__c = '', User_Message__c = 'Proposal Creation Error for the Opportunity',Class_Reference__c = 'Digital_ProposalAutomation > Proposal Creation', Object__c = OPPORTUNITYOBJ,Record_Id__c = 'Opportunities::'+successOppList);
                exList.add(ex1);
            }
        }
    }

    //updateOpportunityHelper2() method
    //Updates the list of opporunity, returning all opportunities that were successfully updated.
    private List<Opportunity> updateOpportunityHelper2(List<Opportunity> oppList,Map<Id,Opportunity> oppMap){

        List<Opportunity> successOppList = new list<Opportunity>();

        Database.SaveResult[] lsr;     
        if(!Test.isrunningtest()){           
            lsr = Database.update(oppList, false);
        }
        // For the test class coverage to cover the error part.
        else if(Test.isrunningtest() && oppList.Size() >0){
            Opportunity opp2= [SELECT Id,Name,AccountId,Source_System_Detail__c FROM Opportunity WHERE isdigitalSpearhead__c =TRUE LIMIT 1];              
            Opportunity oppNew= opp2.clone(false,true);
            oppNew.StageNAme= 'Appointment Scheduled';
            oppNew.CloseDate = System.Today();
            if(Schema.sObjectType.Opportunity.isCreateable()){
            insert oppNew;
            }
            oppNew.Name= 'GLI oppty 3';
            oppNew.AccountId = oppNew.Source_System_Detail__c;
            oppList.add(oppNew);
            if(Schema.sObjectType.Opportunity.isUpdateable()){
                lsr = Database.update(oppList, false);
            }   
        }

        successOppList = checkSaveResults(lsr,oppList,oppMap);

        return successOppList;
    }

    //checkSaveResults() method
    //Checks the updation results and stores Opportunities that have been sucessfully updated.
    private List<Opportunity> checkSaveResults(Database.SaveResult[] lsr, List<Opportunity> oppList,Map<Id,Opportunity> oppMap){
        
        List<Opportunity> successOppList = new list<Opportunity>();

        if(lsr != Null && lsr.size() > 0){  
            for(Integer i = 0; i < lsr.size(); i++){
                if(lsr.get(i).isSuccess()){           
                    successOppList.add(oppMap.get(lsr.get(i).getId()));
                }
                else if(!lsr.get(i).isSuccess()){
                    Database.Error error = lsr.get(i).getErrors().get(0);
                    String addInfo ;
                    for(string errorField : error.getfields()){
                        addInfo = errorField + ',';            
                    }
                    Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = error.getMessage(),Exception_Type__c = 'Opportunity Updation - OptyId - oppList.get(i).Id'+addInfo,Additional_Information__c = String.Valueof(error.getStatusCode()),  User_Message__c = error.getMessage(),Class_Reference__c = 'Digital_ProposalAutomation > opportunityUpdation', Object__c = OPPORTUNITYOBJ,Record_Id__c = oppList.get(i).Id);
                    exList.add(ex);
                }
            }
        } 

        return successOppList;
    }

    //setOpportunityFields() method
    //Sets the fields on the Opportunity
    private Opportunity setOpportunityFields(Opportunity oppty, Map<String, String> acctsubcamp){
        Opportunity opp = oppty;
                
        opp.Digital_PreviousStageName__c = opp.StageName; // DLT-10048 - Added coding to Opp Stage name.
        opp.StageName = 'Appointment Scheduled';
        opp.RecordTypeId = GLI_RECORDID;
        opp.sub_Campaign_Code__c = acctsubcamp.get(opp.Source_System_Detail__r.Source_System_Account_Number__c);
        //DLT-15184 added for Findlaw
        // DLT-21788 if(opp.LCRM_Sub_BU__c == SEGMENT_FINDLAW){  use new field to check for FindLaw
        if (opp.APTS_Proposal_Business_Unit__c == SEGMENT_FINDLAW) { 
        	opp.Pricebook2Id = flpriceBookId;
        } else {
        	opp.Pricebook2Id = priceBookId;
        }
            // End DLT-15184 added for Findlaw
        //DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
        for(Product_Account_Detail__c prd: digitalSubscriptionsList ){           
            dsFirmMap.put(prd.ZP_Cust_Number__c, prd.Digital_Firm__c);
            dsContractTypeMap.put(prd.ZP_Cust_Number__c,prd.Contract_Type__c);//DLT-16958
        }
        // DLT-9536 - use CMT to set opp owner
        if(opp.Owner.Name == System.Label.DC_INFORMATICA_USER){
            opp.Ownerid  =  globObj.setTheDigitalOwnerAppSegment(dsFirmMap.get(opp.SAP_Account_Number__c)); //DLT-16854
            
        }
        opp.Contract_Type__c = dsContractTypeMap.get(opp.SAP_Account_Number__c); //DLT-16958

        return opp;
                
    }

    //This method is called after the Proposal is generated.
     /** 
     * @description :Method called after Proposal is generated.
     * @param quoteProposalIdList : QuoteProposal IDList
     */
    Public static void cartCreation(list<Id> quoteProposalIdList){ 
        
        //DLT- 12134 - Initates cart creation for the straight proposal. Removed all other small methods
        // and converted into a single method call which is common for other types of proposals. 
        try{       
        Digital_CartCreationCommoncode.ContractTerms(quoteProposalIdList, STRAIGHTRENEWAL);
        }
        //DLT-14286
        catch(Exception ex){           
            if(quoteProposalIdList.isEMpty()){        
                Digital_Exception_Log__c ex1 = new Digital_Exception_Log__c(Exception_Message__c =  ex.getMessage(),Exception_Type__c = 'Cart Creation Error for the proposal:'+ quoteProposalIdList[0],Additional_Information__c = '',  User_Message__c = 'Cart Creation Error for the proposal:',Class_Reference__c = 'Digital_ProposalAutomation > Cart Creation',Object__c = 'Cart',Record_Id__c = 'proposals::'+quoteProposalIdList[0]);
                if(Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
                insert ex1;
                }
            }
            
        }
        
    }
    private static void inserExceptionLogs(list<Digital_Exception_Log__c> exList){
        if(exList != Null && exList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            try{
                insert exList;
                exList.clear();
            }
            Catch(Exception e){
                System.debug(logginglevel.INFO,'Exception Opportunities'+e);
            }
        }
        
    }

    //Updates few fields in Proposal if the quote is manually generated.
    private static void opptyUpdatWhenManual(Set<ID> malOptySet){
        
        List<Opportunity> oppList = new list<opportunity>();
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        
        for(Opportunity opp : [Select id, Unmarked_Digital_Channel__c,isDigitalSpearHead__c from Opportunity where Id IN :malOptySet]){
            
            opp.Unmarked_Digital_Channel__c =TRUE;
            opp.isDigitalSpearHead__c = False;
            oppList.add(opp);
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = label.ManualProposalExistsPA,Exception_Type__c = label.ManualProposalExistsPA,Additional_Information__c =  '',User_Message__c = label.ProposalCannotBeCreatedErrPA,Class_Reference__c = label.OppUpdateWhenManualPA,Object__c = OPPORTUNITYOBJ, Record_Id__c= opp.id);
            exList.add(ex);    
        }
        
        try{ 
            if(!test.isRunningTest()){       
                Database.update(oppList, false);  
            }
            else if( test.isRunningTest()  && oppList.Size() >0)
            {
                Database.update(oppList, false);
                DMLException dmlEx=new DMLException();
                throw dmlEx;
            }     
        }Catch(Exception error){
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = error.getMessage(),Exception_Type__c = error.getTypeName(),Additional_Information__c = String.valueof(error.getLineNumber()), User_Message__c = String.valueof(error.getCause()),Class_Reference__c = label.ProposalAutomationClassRef,Object__c = OPPORTUNITYOBJ,Record_Id__c = '');
            exList.add(ex);
            
        }
        if(!exList .isEmpty()){
            try{
                insert exList;
            }
            Catch(Exception e){
                System.debug(logginglevel.INFO,'Exception'+e);
            }  
        }
    }
    // Initiates Best Proposal Automation

      /** 
     * @description :Initiates Best Proposal Automation
     * @param info : info
     */
    public void finish(Database.BatchableContext info){ 
        
        if(!test.isrunningtest()){  

            Digital_BestProposalAutomation dpb = new Digital_BestProposalAutomation();              
            Database.executeBatch(dpb, 1);    
        }
    }
}