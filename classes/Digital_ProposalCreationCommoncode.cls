/* Created By - Divija S
   Purpose - Digital Quote Automation optimization for Proposal Creation for Straight Renewal, Best, Config and Premium.
   Jira Story - DLT-9827

   Modified by Divija S 11/06/2018
   DLT-9755- Update Account / Contact object references for GLI Change
   Modified By Poonam Garg 02-07-2018
   DLT-10574 Added common exception log method.
   Modified by Harika 11/07/2018
   DLT-10372 -  Quote Automation for mid-Contract up-sell Proposal  
   Modified by Bharat Bhushan 06/08/2018
   DLT-11509 - [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID
   Modified by Navleen Kaur  on Aug 29 2018
   DLT-11735 -  Change from global to public
   Modified by Divija S on 18th Sep 2018
   DLT-12358 - Optimized Queries and code to avoid heap size limit error
   Modified by Navleen Kaur on 8th Oct 2018
   DLT-12028 - Tech Story [Code Scan] Fix Digital_ProposalCreationCommoncode, Digital_ProposalCreationCommoncode_Test.
   Modified by Harika sai P on Oct 8 2018
   DLT-12193 [Tech story] Mid Contract and Renewal opporunity will be same
   Modified by Navleen Kaur on 19th Oct 2018
   DLT-12817 [TECH STORY] Update the APTS_Boolean_Count_of_Online__c for Digital straight renewals
   Modified By Harika on 22nd Oct 2018.
   DLT-12833 [Gov] Order Confirmation Contact logic
   Modified By Navleen on 6th Feb 2019
   DLT-14618-[All] Digital firm should be populated based Firm type in automation feed/file  
   Modified by Srikanth Kota 02/19/2019
   DLT-15184 - FL- Quote Automation for Findlaw proposals - Straight Renewal.    
   Modified by Divija S 8/3/2019
   DLT-15468 - [TECH Story] Fix Order Confirmation Contact issue
   Modified By Navleen Kaur on 19 Mar 2019
   DLT-15672 - [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
   Modified By Srikanth Kota on 26 April 2019
   DLT-16181 -  Approval segment values - Order Capture
   Modified By Navleen Kaur on 28 May 2019
   DLT-16591 - Find-law order form issue
   Modified By Harika Sai P on 24th Jun 2019    
   DLT-16854 [Tech Story] - Remove Unnecessary code lines from Proposal Automation and move to Dataoperation Layer
  
   2019-07-09    Srikanth Kota   DLT-16958  [Tech Story] [SLF] Automation to create Plus and Premium proposal only based Ineligible sub flag on DS object
   2019-08-20    Navleen Kaur    DLT-17360 - [ALL] Update CXD Automation class to not process an account if Digital Subscription bypass field has been set
   2020-01-23    Srikanth Kota   DLT-19222 - [REN]WIN/LOSS reason - fields on proposal
   2020-06-01    Benjamin Her    DLT-19913 - Update Ineliible Sub logic to no longer set Best offer as Primary
   2020-08-25    Benjamin Her    DLT-20634 - Critical/Blocker PMD fix
   2021-04-01    Brenda shields  DLT-21575 - Update logic to correctly set OCC and associated fields
*/
  /**
    * @description : class containing common methods for creating digital proposals for automation
    */  
public with Sharing class Digital_ProposalCreationCommoncode {
    
    public Static String priceListName = 'Thomson Reuters Master - US Legal'; 
    public Static list<Apttus_Config2__PriceList__c> plNameList = [SELECT Id,Name FROM   Apttus_Config2__PriceList__c WHERE Name =:priceListName LIMIT 1]; 
    private static IGlobalOperationLayer globObj  = new GlobalOperationLayer();   
    private static Final String OLDMIDCONTRACT='Old Mid Contract';
    private static Final String INELIGIBLE='Ineligible'; 

    // Get the list of Full Contract Terms
    private static List<DC_Contract_Term_V2__mdt> getFullContractTerms(String quoteName){
        List<DC_Contract_Term_V2__mdt> fullContractTerms = new List<DC_Contract_Term_V2__mdt>();
        if(quoteName == 'Straight Renewal'){
            if(Schema.sObjectType.DC_Contract_Term_V2__mdt.isAccessible()){
                fullContractTerms = [select Customer_Category__c,Default_Customer_Category__c, Default_Contract_Term__c,Markup_Percentage__c,
                                 YoY_1_Renewal__c,DC_Years_2_Plus_Adjustment__c,Contract_Term__c,Quote_Type__c,Segment__c From DC_Contract_Term_V2__mdt where Quote_Type__c='Straight Renewal'];
            }                    
        } 
        return fullContractTerms ;    
    }

    private static Map<Id,Id> getEbillEmailContact(list<LCRM_Contact_SSD__c> contactList,Integer ebilCount){
        Map<Id,Id> accConIdMap2 = new Map<Id,Id>();        
        if(ebilCount == 1){
            for(LCRM_Contact_SSD__c ct : contactList){
                if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT')){
                    //accConIdMap2.put(ct.LCRM_Account_SSD__r.id,ct.LCRM_Contact__r.id);
                    accConIdMap2.put(ct.LCRM_Account_SSD__r.id,ct.id); 
                    system.debug(logginglevel.INFO, 'Map2-->'+accConIdMap2);                      
                    break;
                }
            }
        }
        else if(ebilCount > 1){
            for(LCRM_Contact_SSD__c ct : contactList){
                if(ct.LCRM_Job_Function__c != NULL && ct.LCRM_SAP_Role__c != Null && 
                    ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT')){
                    accConIdMap2.put(ct.LCRM_Account_SSD__r.id,ct.id);
                    system.debug(logginglevel.INFO, 'Map21-->'+accConIdMap2);
                    break;
                }
            }
        } 
        return accConIdMap2;
    }

    private static integer incrementeBillCount(integer eBillCount,LCRM_Contact_SSD__c ct){
        integer count = eBillCount;
        if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT')){              
            count++;                      
        }
        return count;
    }
    
    private static integer incrementSAPCount(integer sapCount,LCRM_Contact_SSD__c ct){
        integer count = sapCount;
        if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('SAP - 18 BILLING/ACCT PAYABLE')){
            count++;
        }
        return count;
    }
    
    private static integer incrementEmailCount(integer emailCount,LCRM_Contact_SSD__c ct){
        integer count = emailCount;
        if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM')){
            count++;
        }
        return count;
    }
    
    private static integer incrementEmailPWDCount(integer emailPWDCount,LCRM_Contact_SSD__c ct){
        integer count = emailPWDCount;
        if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EML PASSWORD CONTACT')){
            count++;
        }
        return count;
    }
    
    private static integer incrementAttorneyCount(integer attorneyCount,LCRM_Contact_SSD__c ct){
        integer count = attorneyCount;
        
        if(ct.LCRM_Job_Function__c != Null 
            && (ct.LCRM_SAP_Role__c == Null 
            || (!ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT') 
            && !ct.LCRM_SAP_Role__c.contains('SAP - 18 BILLING/ACCT PAYABLE') 
            && !ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM') 
            && !ct.LCRM_SAP_Role__c.contains('EML PASSWORD CONTACT')) )  
            && ct.LCRM_Job_Function__c.contains('Attorney')){

            count++;    
        }
        return count;
    }
    
    private static integer incrementWLCount(integer wlCount,LCRM_Contact_SSD__c ct){
        integer count = wlCount;
        if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('WL PSWD ACTIVE')){
            count++;                      
        }
        return count;
    }
    
    private static integer incrementWLAttorneyCount(integer attorneyCount,LCRM_Contact_SSD__c ct){
        integer count = attorneyCount;

        if(ct.LCRM_Job_Function__c != Null 
            && (ct.LCRM_SAP_Role__c == Null 
            || (!ct.LCRM_SAP_Role__c.contains('WL PSWD ACTIVE') 
            && !ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM') ) ) 
            && ct.LCRM_Job_Function__c.contains('Attorney')){

            count ++;    
        }
        return count;
    }
    
    
    //DLT-12833 : Changed the method name form getKeyContactCorporate.
  /**
    * @description : method to get key contacts for non small law accounts
    * @param hardbounce : hardboune indicator
    * @param contactList : list of ssd contacts
    * @param hbcontact : map of hardbounce contacts
    * @param hbtrueContact : map of true hardbounce contacts
    * @return list of contact ssd records
    */      
    public static List<LCRM_Contact_SSD__c> getKeyContactGovSLF23Corporate(integer hardbounce,list<LCRM_Contact_SSD__c> contactList,
        Map<Id, Boolean> hbcontact,Map<Id, Boolean> hbtrueContact ){

        List<LCRM_Contact_SSD__c> keyContacts=new List<LCRM_Contact_SSD__c>();
        integer ebillCount = 0;
        integer sapCount = 0;
        integer emlCount = 0;
        integer attorneyCount = 0; 
        integer emlPWDCount = 0; //DLT-12833

        //Null check
        if(contactList == null || hbcontact == null || hbtrueContact == null || hardbounce == null){
            return contactList;
        }
        for(LCRM_Contact_SSD__c ct : contactList){
            if(ct.LCRM_Hard_Bounce__c!= True && hardbounce > 0){
                ebillCount = incrementeBillCount(ebillCount,ct);
                sapCount = incrementSAPCount(sapCount,ct);
                emlCount = incrementEmailCount(emlCount,ct);
     
                //DLT-12833 
                emlPWDCount = incrementEmailPWDCount(emlPWDCount,ct);
                attorneyCount = incrementAttorneyCount(attorneyCount,ct);
            }
            else if(hardbounce == 0){
                ebillCount = incrementeBillCount(ebillCount,ct);
                sapCount = incrementSAPCount(sapCount,ct);
                emlCount = incrementEmailCount(emlCount,ct);
      
                //DLT-12833
                emlPWDCount = incrementEmailPWDCount(emlPWDCount,ct);
                attorneyCount = incrementAttorneyCount(attorneyCount,ct);
           }
        }
        if(ebillCount == 1){
            for(LCRM_Contact_SSD__c ct : contactList){
                if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT') && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id))){
                    keyContacts.add(ct);
                    break;
                }
            }
        }
        else if(ebillCount > 1){
            for(LCRM_Contact_SSD__c ct : contactList){
                if(ct.LCRM_Job_Function__c != NULL && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && ct.LCRM_SAP_Role__c != Null && ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT')){
                    keyContacts.add(ct);
                    break;
                }
            }
        }
        if(keyContacts.isEmpty() || keyContacts == Null ){
            if(sapCount == 1){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('SAP - 18 BILLING/ACCT PAYABLE') && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id))){
                        keyContacts.add(ct);
                        break;
                    }
                }
            }
            else if(sapCount > 1){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_Job_Function__c != NULL && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && ct.LCRM_SAP_Role__c != Null && ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('SAP - 18 BILLING/ACCT PAYABLE')){
                        keyContacts.add(ct);
                        break;
                    }
                }
            }
        }
        if(keycontacts.isEmpty() || keyContacts== Null ){
            if(emlCount == 1){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM') && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id))){
                        keyContacts.add(ct);
                        break;
                    }
                }
            }
            else if(emlCount > 1){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_Job_Function__c != NULL && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && ct.LCRM_SAP_Role__c != Null && ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM')){
                            keyContacts.add(ct);
                            break;
                    }
                }
            }
        }
        //DLT-12833 start
        if(keycontacts.isEmpty() || keyContacts== Null ){
            if(emlPWDCount == 1){                
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EML PASSWORD CONTACT') && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id))){
                        keyContacts.add(ct);                       
                        break;
                    }
                }
            }
            else if(emlPWDCount > 1){                
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_Job_Function__c != NULL && ((hbcontact!= null && hbcontact.containsKey(ct.id)) || (hbtrueContact!= null &&  hbtrueContact.containsKey(ct.id))) && ct.LCRM_SAP_Role__c != Null && ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('EML PASSWORD CONTACT')){
                        
                        keyContacts.add(ct);
                        break;
                    }
                }
            }
        }//DLT-12833 Ends.
        
        if(keyContacts.isEmpty() || keyContacts== Null){
            if(attorneyCount > 0){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_Job_Function__c != Null && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && (ct.LCRM_SAP_Role__c == Null || (!ct.LCRM_SAP_Role__c.contains('EBILL EMAIL CONTACT') && !ct.LCRM_SAP_Role__c.contains('SAP - 18 BILLING/ACCT PAYABLE') && !ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM') ) ) && ct.LCRM_Job_Function__c.contains('Attorney')){
                        keyContacts.add(ct);
                        break;
                    }    
                }
            }
            else{
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)){
                        keyContacts.add(ct);                    
                        break;  
                    } 
                }
            }        
        }
        return keyContacts;
    }  

  /**
    * @description : method to get contacts for small law accounts
    * @param hardbounce : hardboune indicator
    * @param contactList : list of ssd contacts
    * @param hbcontact : map of hardbounce contacts
    * @param hbtrueContact : map of true hardbounce contacts
    * @return list of contact ssd records
    */  
    public static List<LCRM_Contact_SSD__c> getKeyContactSmallLaw(integer hardbounce,list<LCRM_Contact_SSD__c> contactList,
        Map<Id, Boolean> hbcontact,Map<Id, Boolean> hbtrueContact ){
        integer wlCount = 0;
        integer emlCount = 0;
        integer attorneyCount = 0;
        List<LCRM_Contact_SSD__c> keyContacts=new List<LCRM_Contact_SSD__c>();

        //Null check
        if(contactList == null || hbcontact == null || hbtrueContact == null || hardbounce == null){
            return contactList;
        }
        for(LCRM_Contact_SSD__c ct : contactList){
            if(!ct.LCRM_Hard_Bounce__c && hardbounce > 0){
                system.debug(logginglevel.INFO, 'contactname-->'+ct.id);
                wlCount = incrementWLCount(wlCount,ct);
                emlCount = incrementEmailCount(emlCount,ct);
                attorneyCount = incrementWLAttorneyCount(attorneyCount,ct);
            }
            else if(hardbounce == 0){
                wlCount = incrementWLCount(wlCount,ct);
                emlCount = incrementEmailCount(emlCount,ct);
                attorneyCount = incrementWLAttorneyCount(attorneyCount,ct);
            }
        } 
        if(wlCount == 1){
            for(LCRM_Contact_SSD__c ct : contactList){
                if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('WL PSWD ACTIVE') && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id))){
                    keyContacts.add(ct);
                    break;
                }
            }
        }
        else if(wlCount > 1){
            for(LCRM_Contact_SSD__c ct : contactList){
                if(ct.LCRM_Job_Function__c != NULL && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && ct.LCRM_SAP_Role__c != Null && ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('WL PSWD ACTIVE')){
                    keyContacts.add(ct);
                    break;
                }
            }
        }   
        if(keyContacts.isEmpty() || keyContacts == Null ){
            if(emlCount == 1){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_SAP_Role__c != Null && ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM') && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id))){
                        keyContacts.add(ct);
                        break;
                    }
                }
            }
            else if(emlCount > 1){
                for(LCRM_Contact_SSD__c ct :contactList){
                    if(ct.LCRM_Job_Function__c != NULL && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && ct.LCRM_SAP_Role__c != Null && ct.LCRM_Job_Function__c.contains('Attorney') && ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM')){
                        keyContacts.add(ct);
                        break;
                    }
                }
            }
        }
        if( keyContacts.size() == 0 ||  keyContacts== Null){
            if(attorneyCount > 0){
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(ct.LCRM_Job_Function__c != Null && (hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)) && (ct.LCRM_SAP_Role__c == Null || (!ct.LCRM_SAP_Role__c.contains('WL PSWD ACTIVE') && !ct.LCRM_SAP_Role__c.contains('EML ORDER CONFIRM') ) ) && ct.LCRM_Job_Function__c.contains('Attorney')){
                        keyContacts.add(ct);
                        break;    
                    }    
                }
            }
            else{
                for(LCRM_Contact_SSD__c ct : contactList){
                    if(hbcontact.containsKey(ct.id) || hbtrueContact.containsKey(ct.id)){
                        keyContacts.add(ct);
                        break;   
                    }
                }
            }        
        }
        return  keyContacts;                    
     }

  /**
    * @description : method to get DS information
    * @param quoteName : quote name - type
    * @param opp : opportunity record
    * @return ds record
    */  
    @testVisible
     public Static Product_Account_Detail__c getDSObject(String quoteName, Opportunity opp){
        list<Product_Account_Detail__c> digitalSubscriptionsList = new list<Product_Account_Detail__c>();
        list<Product_Account_Detail__c> digitalSubscriptionsListst = new list<Product_Account_Detail__c>();
        list<Product_Account_Detail__c> digitalSubscriptionsListbest = new list<Product_Account_Detail__c>();
        list<Product_Account_Detail__c> digitalSubscriptionsListprem = new list<Product_Account_Detail__c>();    
        Product_Account_Detail__c dSobj =new Product_Account_Detail__c();
        if(Schema.sObjectType.Product_Account_Detail__c.isAccessible()){
        digitalSubscriptionsList = [SELECT AccountSSD__c,Renewal_Date__c,Campaign_Code__c,Quantity__c,Digital_Firm__c,
                                     Actual_New_Service__c,Actual_New_Subscription__c,Actual_New_Subscription_Product__c,Current_Subscription__c,
                                     Premium_New_Service__c,Premium_New_Subscription__c,Type__c,ZP_Cust_Number__c,SAP_Contact_Id__c,Hard_Bounce__c,Contract_Type__c,Default_Add_On__c FROM Product_Account_Detail__c 
                                     where ZP_Cust_Number__c = :opp.SAP_Account_Number__c // Added this to resolve prod issue for limit error more than 50000 rows
                                     AND (Current_Subscription__c != Null OR (Actual_New_Service__c != Null AND Actual_New_Subscription__c != Null) OR (Premium_New_Service__c != Null AND Premium_New_Subscription__c != Null))
                                     AND Campaign_Code__c != Null AND Renewal_Date__c > Today AND Bypass_Automation__c = false];
        }                             
        system.debug(logginglevel.INFO, 'digitalsub==>'+digitalSubscriptionsList );
        for(Product_Account_Detail__c pdc: digitalSubscriptionsList){
            if(quoteName == 'Straight Renewal' && pdc.Current_Subscription__c != Null){
                digitalSubscriptionsListst.add(pdc);
            }   
            else if(quoteName == 'Best Value' && ((pdc.Actual_New_Service__c != Null && pdc.Actual_New_Subscription__c != Null) || pdc.Current_Subscription__c != Null) && (pdc.Type__c == 'Plus' || pdc.Type__c =='Config' || pdc.Type__c =='Premium')){
                    digitalSubscriptionsListbest.add(pdc);
            }    
            else if(quoteName == 'Premium' && pdc.Type__c=='Premium' && pdc.Type__c !='Config' && ((pdc.Premium_New_Service__c != Null && pdc.Premium_New_Subscription__c != Null) || pdc.Current_Subscription__c != Null)){
                    digitalSubscriptionsListprem.add(pdc);
            }    
        }  
        if(quoteName == 'Straight Renewal'){
            for(Product_Account_Detail__c tempDSobj : digitalSubscriptionsListst){
                //DLT-12193 : Added condtions to exclude mid contrat DS Record if opportunity mid contract status is denied
                //and to get DS records to create straight propsals for denied mid contract type opportunities.
                if((opp.renewal_date__c == tempDSobj.Renewal_Date__c && opp.Campaign_Code__c == tempDSobj.Campaign_Code__c && opp.SAP_Account_Number__c  == tempDSobj.ZP_Cust_Number__c)
                && (opp.Digital_MidContract_Status__c!='Denied' || (opp.Digital_MidContract_Status__c =='Denied' && tempDSobj.Contract_Type__c != OLDMIDCONTRACT))){
                    dsObj = tempDSobj;
                }
            }
        }
        else if(quoteName == 'Best Value'){
            for(Product_Account_Detail__c tempDSobj : digitalSubscriptionsListbest){
                //DLT-12193 : Added condtions to exclude mid contrat DS Record if opportunity mid contract status is denied
                //and to get DS records to create straight propsals for denied mid contract type opportunities.
                if((opp.renewal_date__c == tempDSobj.Renewal_Date__c && opp.Campaign_Code__c == tempDSobj.Campaign_Code__c && opp.SAP_Account_Number__c  == tempDSobj.ZP_Cust_Number__c)
                && (opp.Digital_MidContract_Status__c!='Denied' || (opp.Digital_MidContract_Status__c =='Denied' && tempDSobj.Contract_Type__c != OLDMIDCONTRACT))){
                    dsObj = tempDSobj;
                }
            }
        }
        else if(quoteName == 'Premium'){
            for(Product_Account_Detail__c tempDSobj : digitalSubscriptionsListprem){
                //DLT-12193 : Added condtions to exclude mid contrat DS Record if opportunity mid contract status is denied
                //and to get DS records to create straight propsals for denied mid contract type opportunities.
                if((opp.renewal_date__c == tempDSobj.Renewal_Date__c && opp.Campaign_Code__c == tempDSobj.Campaign_Code__c && opp.SAP_Account_Number__c  == tempDSobj.ZP_Cust_Number__c)
                && (opp.Digital_MidContract_Status__c!='Denied' || (opp.Digital_MidContract_Status__c =='Denied' && tempDSobj.Contract_Type__c != OLDMIDCONTRACT ))){
                    dsObj = tempDSobj;
                }
            }
        }
        return dsObj;
    } 

  /**
    * @description : method to create Proposal records
    * @param digitalOpp : list of opportunities
    * @param assetLineItemsList : list of asset line items
    * @param quoteName : quote name - type
    */  
    public static void proposalCreation(List<Opportunity> digitalOpp, List<Apttus_Config2__AssetLineItem__c> assetLineItemsList, String quoteName){          
    
        // map to lookup opportunity owner based on Digital Firm value
        //setTheDigitalOwnerAppSegment(); //Removed and moved to Globaloperation layer    
        system.debug(logginglevel.INFO, 'digitalOpp==>'+assetLineItemsList);   
        list<Apttus_Proposal__Proposal__c> quoteProposalList = new list<Apttus_Proposal__Proposal__c>();  
        List<Id> successQuoteList = new List<Id>(); 
        map<Id,Id> accConIdMap = new map<Id,Id>();
        map<Id,Id> accConIdMap2 = new map<Id,Id>();
        map<Id,Id> conConIdMap = new map<Id,Id>();
        Set<Id> accountIdSet = new Set<Id>();    
        map<Id,Opportunity> accountOptyMap = new map<Id,Opportunity>();
        Database.SaveResult[] lsr; 
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        map<Id, list<LCRM_Contact_SSD__c>> accContactListMap = new map<Id, list<LCRM_Contact_SSD__c>>();
        map<Id, String> conIdEmailMap = new map<Id, String>();
        //Map<Id,String> conIdEmailMap2 = new Map<Id,String>();
        Integer ebilCount = 0;
        Boolean canceledFlag = False;
        //String type;
        List<DC_Contract_Term_V2__mdt> fullContractTerms = new List<DC_Contract_Term_V2__mdt>(); 
        fullContractTerms =getFullContractTerms(quoteName);
        //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
        map<String,Id> sapConIdMap = new map<String,Id>();  //Used to maintain SAP Contact ID vs Contact ID
        map<String,Id> sapConSSDIdMap = new map<String,Id>(); //Used to maintain SAP Contact ID and Contact SSD ID
        map<String,String> conConMap = new map<String,String>();
        List<LCRM_Contact_SSD__c> hardBounceConList = new List<LCRM_Contact_SSD__c>();
        //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
        map<Id, Boolean> hbcontact = new map<Id, Boolean>();
        map<Id, Boolean> hbtrueContact = new map<Id, Boolean>();
        List<Opportunity> lsOppToUpdate=new List<Opportunity>();
        Product_Account_Detail__c dsObj = null;
        list<Source_System_Detail__c> ssdList = new list<Source_System_Detail__c>();
        string strSAPContactID;
        
        if(digitalOpp != Null && digitalOpp.size() > 0 && (assetLineItemsList.size() > 0 || quoteName!= 'Straight Renewal')){
            for(Opportunity opp : digitalOpp){
                dsobj = getDSObject(quoteName,opp);
                if(opp.Source_System_Detail__c != Null){
                    accountIdSet.add(opp.Source_System_Detail__c);
                    accountOptyMap.put(opp.Source_System_Detail__c, opp);                
                    system.debug(logginglevel.INFO, 'accountOptyMap'+accountOptyMap);
                }    
            }
        
            if(accountIdSet != Null && accountIdSet.size() > 0){
                ssdList =   [SELECT id, name, LCRM_APTS_Band_Number__c,
                                (SELECT AccountSSD__c, Campaign_Code__c,Quantity__c,Actual_New_Service__c,
                                Actual_New_Subscription_Product__c,Current_Subscription__c,Premium_New_Subscription__c,
                                Product_Pricing_Model__c 
                                FROM Digital_Product_AccountSSD_Details__r
                                WHERE (Actual_New_Service__c != Null 
                                AND Actual_New_Subscription__c != Null)
                                AND Campaign_Code__c != Null 
                                AND Type__c IN ('Plus','Config','Premium') 
                            AND Renewal_Date__c >= Today) 
                            FROM Source_System_Detail__c 
                            WHERE id IN: accountIdSet
                            WITH SECURITY_ENFORCED];
            
                //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
                for (LCRM_Contact_SSD__c con : [select id, LCRM_Account_SSD__r.id, LastModifiedDate, LCRM_Hard_Bounce__c,
                		LCRM_Contact__r.Id, LCRM_Contact__r.Email, LCRM_Contact__r.SAP_Contact_ID__c, LCRM_SAP_Role__c,
                		LCRM_Job_Function__c, LCRM_Email__c, LCRM_Source_Contact_Id__c 
                		from LCRM_Contact_SSD__c 
                		where LCRM_Account_SSD__r.id IN : accountIdSet AND LCRM_Email__c != Null 
                		order by LastModifiedDate DESC]) {
                    
                    if (con.LCRM_Source_Contact_Id__c != null && con.LCRM_Source_Contact_Id__c != '') {
                        sapConIdMap.put(con.LCRM_Source_Contact_Id__c, con.LCRM_Contact__c);
                        sapConSSDIdMap.put(con.LCRM_Source_Contact_Id__c,con.id);
                        ConConMap.put(con.id, con.LCRM_Contact__r.id);
                    }
                    //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
                
                    conIdEmailMap.put(con.Id, con.LCRM_Contact__r.Email!=null? con.LCRM_Contact__r.Email: con.LCRM_Email__c); 
                    if(accContactListMap.containskey(con.LCRM_Account_SSD__c)){
                        List<LCRM_Contact_SSD__c> contactList = accContactListMap.get(con.LCRM_Account_SSD__c);
                        contactList.add(con);
                        accContactListMap.put(con.LCRM_Account_SSD__c, contactList);
                    }           
                    else{
                        accContactListMap.put(con.LCRM_Account_SSD__c, new List<LCRM_Contact_SSD__c> {con});
                    }
                }
            }  //End of for loop
        
            if(accContactListMap.size() > 0){
                for(Id aId : accContactListMap.keyset()){
                    //added by Divija
                    system.debug(logginglevel.INFO, 'optydata'+accountOptyMap);                    
                    if(String.isBlank(accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c)||!accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('USG')||!accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('NEL')){
                        for(LCRM_Contact_SSD__c ct : accContactListMap.get(aId)){    
                            ebilCount = incrementeBillCount(ebilCount,ct); 
                            system.debug(logginglevel.INFO, 'ebilcount value1--->'+ebilCount);
                        }
                        accConIdMap2=getEbillEmailContact(accContactListMap.get(aId),ebilCount);
                    } 
                    //added by Divija                    
                        
                    system.debug(logginglevel.INFO, 'dsObj.Digital_Firm__c'+dsObj.Digital_Firm__c);
                    if(accountOptyMap.get(aId).Source_System_Detail__r.LCRM_APTS_Band_Number__c == 1 && dsObj.Digital_Firm__c!= 'Corporate'
                            && dsObj.Digital_Firm__c!= 'Government'){                       
                        
                        integer hardbounce = 0;                        
                        for(LCRM_Contact_SSD__c ct : accContactListMap.get(aId)){
                            if(!ct.LCRM_Hard_Bounce__c){
                                hardbounce++;
                            }
                        }                        
                        
                        for(LCRM_Contact_SSD__c ct : accContactListMap.get(aId)){
                            if(hardbounce!= 0 && !ct.LCRM_Hard_Bounce__c){
                                hbcontact.put(ct.id, ct.LCRM_Hard_Bounce__c);
                            }
                            if(hardbounce== 0){
                                hbtrueContact.put(ct.id, ct.LCRM_Hard_Bounce__c);
                            }
                        }

                        List<LCRM_Contact_SSD__c> keyContacts=getKeyContactSmallLaw(hardbounce,accContactListMap.get(aId),hbcontact,hbtrueContact);
                        system.debug(logginglevel.INFO, 'keyContacts::'+keyContacts);
                        for(LCRM_Contact_SSD__c ct :keyContacts){
                            accConIdMap.put(ct.LCRM_Account_SSD__r.id,ct.id);
                            conConIdMap.put(ct.id, ct.LCRM_Contact__r.id);
                        }
                    }
                    //if band number is more than 1 or if Corporate Customer
                    else{
                        
                        integer hardbounce = 0;
                        //hardbounce check on Contact record
                        for(LCRM_Contact_SSD__c ct : accContactListMap.get(aId)){
                            if(ct.LCRM_Hard_Bounce__c!= True){
                                hardbounce++;
                            }
                        }
                        system.debug(logginglevel.INFO, 'hardbounce-->'+hardbounce);
                        for(LCRM_Contact_SSD__c ct : accContactListMap.get(aId)){
                            if(hardbounce!= 0 && !ct.LCRM_Hard_Bounce__c){
                                hbcontact.put(ct.id, ct.LCRM_Hard_Bounce__c);
                            }
                            if(hardbounce== 0){
                                hbtrueContact.put(ct.id, ct.LCRM_Hard_Bounce__c);
                            }
                            
                        }
                        List<LCRM_Contact_SSD__c > keyContacts=getKeyContactGovSLF23Corporate(hardbounce,accContactListMap.get(aId),hbcontact,hbtrueContact);
                        for(LCRM_Contact_SSD__c ct :keyContacts){
                            accConIdMap.put(ct.LCRM_Account_SSD__r.id,ct.id);
                            conConIdMap.put(ct.id, ct.LCRM_Contact__r.id);
                        }
                        
                    }
                    system.debug(logginglevel.INFO, 'hbcontact and hbtrueContact-->'+hbcontact + ' ' +hbtrueContact);                    
                }//End of for loop
            }            
            else{
                Digital_Exception_Log__c ex = createExceptionLog( 'No Contacts found on the Account','Quote Creation - Opty Id - '+digitalOpp[0].id,'Account Id - '+digitalOpp[0].Source_System_Detail__r.id,'Please check contacts have email address or not','Digital_ProposalAutomation > ProposalCreation');
                exList.add(ex);
            }
            system.debug(logginglevel.INFO, 'Rajan accConIdMap=====>'+accConIdMap);
            if(accConIdMap != Null && accConIdMap.size() > 0){   
                for(Opportunity opp : digitalOpp){
                    //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
                    //Get the DS Object
                    dsObj = getDSObject(quoteName, opp);                
                    system.debug(logginglevel.INFO, 'Rajan dsObj--->'+DSobj);
                    strSAPContactId = '';
                    // the sap contact in the ds records doesn't have it leading zeros
                    if (dsObj != null && dsObj.SAP_Contact_Id__c != null && dsObj.SAP_Contact_Id__c != '') {
                    	strSAPContactId = dsObj.SAP_Contact_ID__c.leftPad(10, '0');
                    }
                    
                    if (strSAPContactId != '' && sapConIdMap.containsKey(strSAPContactId)) {
                        opp.Key_Contact__c = sapConIdMap.get(strSAPContactId);
                    } else {
                        opp.Key_Contact__c = conConIdMap.get(accConIdMap.get(opp.Source_System_Detail__r.id));
                    }    
                    system.debug(logginglevel.INFO, 'opp.Key_Contact__c: ' + opp.Key_Contact__c);
                
                    Apttus_Proposal__Proposal__c quoteProposal = createProposal(opp, quoteName, dsObj);
                    quoteProposal.Apttus_QPConfig__PriceListId__c = plNameList[0].Id;
                    
                    // DLT-19222 -WinLoss Update on Proposal / Digital  for all segments and all digital type proposal.
                        quoteProposal.Latam_APTS_Win_Loss__c ='Won';
                        quoteProposal.Latam_APTS_Reason__c ='Digital';
                        //End DLT-19222
                        
                    // If digital subscription is mid contract type, update quote to mid-contract.
                    if (quoteName == 'Straight Renewal') {
                        for (DC_Contract_Term_V2__mdt tempsMdtss : fullContractTerms ) {
                            if (tempsMdtss.Default_Contract_Term__c == true && tempsMdtss.Segment__c == dsObj.Digital_Firm__c) {
                                quoteProposal.DC_Default_Contract_Term__c = tempsMdtss.Contract_Term__c;
                            }
                        }
                        quoteProposal.DC_Default_Quantity__c = 1;
                    }
                
                    if (strSAPContactId != '' && sapConIdMap.containsKey(strSAPContactId)) {
                        quoteProposal.APTS_Order_Confirmation_Contact__c = opp.Key_Contact__c;
                        quoteProposal.APTS_Order_Confirmation_Contact_Email__c = sapConSSDIdMap.get(strSAPContactId)!= null?conIdEmailMap.get(sapConSSDIdMap.get(strSAPContactId)): '';
                        quoteProposal.Order_Confirmation_Contact_SSD__c = sapConSSDIdMap.get(strSAPContactId);
                        quoteProposal.APTS_Ebilling_contact__c = sapConIdMap.get(strSAPContactId);
                        quoteProposal.APTS_Ebill_Contact_Email__c = sapConSSDIdMap.get(strSAPContactId)!= null?conIdEmailMap.get(sapConSSDIdMap.get(strSAPContactId)):'';
                        
                        if(DSobj.Hard_Bounce__c){                        
                            
                            LCRM_Contact_SSD__c hardBounceCon = new LCRM_Contact_SSD__c(id=sapConSSDIdMap.get(strSAPContactId));
                            hardBounceCon.LCRM_Hard_Bounce__c = DSobj.Hard_Bounce__c;
                            hardBounceConList.add(hardBounceCon);
                            system.debug(logginglevel.INFO, 'Rajan---Inside Hardbounce-----hardBounceCon----->'+hardBounceCon);
                        }
                        system.debug(logginglevel.INFO, 'Rajan---IF-----quoteProposal.APTS_Order_Confirmation_Contact__c----->'+quoteProposal.APTS_Order_Confirmation_Contact__c);
                        system.debug(logginglevel.INFO, 'Rajan---IF-----quoteProposal.APTS_Ebilling_contact__c----->'+quoteProposal.APTS_Ebilling_contact__c);
                    }else{
                        quoteProposal.APTS_Order_Confirmation_Contact__c = opp.Key_Contact__c;
                        quoteProposal.APTS_Order_Confirmation_Contact_Email__c = conIdEmailMap.get(accConIdMap.get(opp.Source_System_Detail__r.id));
                        quoteProposal.Order_Confirmation_Contact_SSD__c = accConIdMap.get(opp.Source_System_Detail__r.id);
                        //ebil contact assignment based on eoutpt eligibilty field on Account     
                        for (Id aId : accContactListMap.keyset()){
                            if (String.isNotBlank(accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c)){
                                if (accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('USG')||accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('NEL')){
                                    quoteProposal.APTS_Ebilling_exempt__c = TRUE;
                                    system.debug(logginglevel.INFO, 'Ebil Contact exempt--->'+quoteProposal.APTS_Ebilling_exempt__c);
                                }
                            }
                            else if ((ebilCount == 0)&&(String.isBlank(accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c)||!accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('USG')||!accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('NEL')||String.isBlank(accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c))){
                            quoteProposal.APTS_Ebilling_contact__c = conConIdMap.get(accConIdMap.get(opp.Source_System_Detail__r.id));
                            quoteProposal.APTS_Ebill_Contact_Email__c= conIdEmailMap.get(accConIdMap.get(opp.Source_System_Detail__r.id));
                                system.debug(logginglevel.INFO, 'Ebil Contact--->'+quoteProposal.APTS_Ebilling_contact__c);
                            }
                            else if((ebilCount != 0)&&(String.isBlank(accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c)||!accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('USG')||!accountOptyMap.get(aId).Source_System_Detail__r.LCRM_eOutput_Eligibility__c.contains('NEL'))){
                            quoteProposal.APTS_Ebilling_contact__c = ConConMap.get(accConIdMap2.get(opp.Source_System_Detail__r.id));
                            quoteProposal.APTS_Ebill_Contact_Email__c= conIdEmailMap.get(accConIdMap2.get(opp.Source_System_Detail__r.id));
                                system.debug(logginglevel.INFO, 'Ebil Contact email--->'+quoteProposal.APTS_Ebill_Contact_Email__c);
                            }
                        } 
                    }
                    if(DSobj.Digital_Firm__c =='FindLaw'){
                        quoteProposal.APTS_Proposal_Business_Unit__c = 'FindLaw';
                    }else{
                    quoteProposal.APTS_Proposal_Business_Unit__c  = 'SCS';
                    }
                    //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
                    if(quoteName == 'Straight Renewal'){
                        for(Apttus_Config2__AssetLineItem__c asset : assetLineItemsList){
                            if(asset.Apttus_Config2__AssetStatus__c == 'Cancelled'){
                                quoteProposal.Digital_Quote_Failure_Reason__c = 'Cancelled assets in Account';   
                                canceledFlag = TRUE;     
                            }
                        }
                    }
                    else{
                    //update qote failure reason when quantity doesn't match band number
                        for(Source_System_Detail__c act: ssdList){
                            for(Product_Account_Detail__c pact: act.Digital_Product_AccountSSD_Details__r){
                                if(pact.Product_Pricing_Model__c == 'Banded'){
                                    if(pact.Quantity__c!= act.LCRM_APTS_Band_Number__c){
                                        system.debug(logginglevel.INFO, 'Automation Failure: Band mismatch: Account: ' + act.id + ' Digital Detail Account: ' + pact.AccountSSD__c);
                                        // DLT-8184 - do not expire the proposals for automation errors
                                        
                                        quoteProposal.Digital_Quote_Failure_Reason__c = 'Quantity does not match Band number';
                                    }
                                }
                            }
                        }
                    }
                    quoteProposalList.add(quoteProposal); 
                    // quoteProposal.Apttus_Proposal__Opportunity__r.Key_Contact__c = opp.Key_Contact__c;
                    lsOppToUpdate.add(opp);
                    //update opp;
                    system.debug(logginglevel.INFO, 'quoteProposalList==>'+quoteProposalList);
                }
            }
            //Update Opportunity
            if(!lsOppToUpdate.isEmpty() && Schema.sObjectType.Opportunity.isUpdateable()){
                update lsOppToUpdate;
            }
            //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
            system.debug(logginglevel.INFO, 'Rajan hardBounceConList ----->'+hardBounceConList);
            if(hardBounceConList != null && !hardBounceConList.isEmpty()){
                Database.SaveResult[] saveRes = Database.update(hardBounceConList,false);
                system.debug(logginglevel.INFO, 'Rajan hardBounceConList After update----->'+hardBounceConList);
                if(saveRes != Null && saveRes.size() > 0){  
                    for(Integer i = 0; i < saveRes.size(); i++){
                        if(!saveRes.get(i).isSuccess()){
                            
                            Database.Error error = saveRes.get(i).getErrors().get(0);
                            String additionalInfo;
                            for(string errorField : error.getfields()){
                                additionalInfo = errorField + ',';            
                            }
                            Digital_Exception_Log__c ex = createExceptionLog(error.getMessage(), 'Hard Bounce Contact Updation - Opty Id - '+quoteProposalList.get(i).Apttus_Proposal__Opportunity__c, additionalInfo, String.Valueof(error.getStatusCode()), 'Digital_ProposalAutomation > ProposalCreation');
                            exList.add(ex);
                        }
                    }
                }
            }
            //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
            if(quoteProposalList != NULL && !quoteProposalList.isEmpty()){  
                if(!test.isRunningTest()){                      
                    lsr = Database.insert(quoteProposalList,false); 
                }else if(test.isRunningTest() && quoteProposalList.size() >0){
                    Apttus_Proposal__Proposal__c propNewFail= new Apttus_Proposal__Proposal__c();                 
                    propNewFail.APTS_SSD_Sold_To__c =  quoteProposalList[0].Apttus_QPConfig__PriceListId__c;            
                    quoteProposalList.add(propNewFail);
                    lsr = Database.insert(quoteProposalList,false); 
                        
                }     
                system.debug(logginglevel.INFO, 'Quote Creation'+quoteProposalList);
                if(lsr != Null && lsr.size() > 0){  
                    for(Integer i = 0; i < lsr.size(); i++){
                        if(lsr.get(i).isSuccess()){
                            successQuoteList.add(lsr.get(i).getId());
                        }
                        else if(!lsr.get(i).isSuccess()){
                            Database.Error error = lsr.get(i).getErrors().get(0);
                            String additionalInfo;
                            for(string errorField : error.getfields()){
                            additionalInfo = errorField + ',';            
                            }                        
                            Digital_Exception_Log__c ex = createExceptionLog(error.getMessage(), 'Quote Creation - Opty Id - '+quoteProposalList.get(i).Apttus_Proposal__Opportunity__c, additionalInfo, String.Valueof(error.getStatusCode()), 'Digital_ProposalAutomation > ProposalCreation');
                            exList.add(ex);
                        }
                        if(canceledFlag == TRUE){

                            Digital_Exception_Log__c ex = createExceptionLog( 'Cancelled assets in Account','Quote Creation - Opty Id - '+quoteProposalList.get(i).Apttus_Proposal__Opportunity__c,'Quote Id - '+lsr.get(i).getId(),'Please check Asset Line Items on Account with canceled status','Digital_ProposalAutomation > ProposalCreation');
                            exList.add(ex);    
                        } 
                    }
                } 
            }
            if(successQuoteList != Null && successQuoteList.size() > 0){
                //Create Cart for Proposal  
                if(quoteName == 'Straight Renewal'){
                    Digital_ProposalAutomation.CartCreation(successQuoteList);
                }  
                else if(quoteName == 'Best Value'){
                    Digital_BestProposalAutomation.createCartForProposal(successQuoteList);
                }   
                else if(quoteName == 'Premium'){
                    Digital_PremiumProposalAutomation.createCartForProposal(successQuoteList);
                }   
            }
        
            if(exList != Null && exList.size() > 0){
                try{
                    if (Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
                        insert exList;
                    }
                }
                Catch(Exception e){
                    system.debug(logginglevel.INFO, 'Exception Opportunities'+e);
                }
            }
        }
    }
    
  /**
    * @description : method to create Proposal records
    * @param opp : opportunity record
    * @param quoteName : quote name - type of quote
    * @param dsObj : DS record
    * @return Proposal record
    */  
    @testVisible
    public static Apttus_Proposal__Proposal__c  createProposal(Opportunity opp, String quoteName, Product_Account_Detail__c dsObj) {
        Apttus_Proposal__Proposal__c quoteProposal = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Opportunity__c = opp.id,APTS_SSD_Sold_To__c= opp.Source_System_Detail__c,APTS_SSD_bill_to__c=opp.Source_System_Detail__c,Apttus_Proposal__Account__c = opp.AccountId);
        system.debug(logginglevel.INFO, '@@dsObj'+dsObj);         
        quoteProposal.Apttus_Proposal__Primary__c=quoteName == 'Straight Renewal' ? true: false;
        if(dsObj != null){
            quoteProposal.Contract_Type__c =  dsObj.Contract_Type__c;
            opp.Contract_Type__c = dsObj.Contract_Type__c;
            if(quoteName == 'Straight Renewal'){                  
                //Added by Navleen :: DLT-12817 [TECH STORY] Update the APTS_Boolean_Count_of_Online__c for Digital straight renewals
                quoteProposal.APTS_Boolean_Count_of_Online__c =TRUE;   
                
                if(dsObj.Contract_Type__c != null && dsObj.Contract_Type__c.trim()!= null) {
                    quoteProposal.Apttus_Proposal__Proposal_Name__c = opp.Name+'- '+dsObj.Contract_Type__c.trim()+' Straight';
                    if(dsObj.Contract_Type__c != INELIGIBLE){
                        opp.Digital_MidContract_Status__c = 'Working';
                    } //DLT-16958
                } 
                else{
                    quoteProposal.Apttus_Proposal__Proposal_Name__c = opp.Name+' - Straight';
                }   
                //Start :: added by Navleen as part of DLT-16591
                if(dsObj.Digital_Firm__c =='FindLaw'){                              
                    quoteProposal.APTS_Align_Contract_End_Dates__c = True;
                    system.debug(logginglevel.INFO, '#**%findlaw'+quoteProposal.APTS_Align_Contract_End_Dates__c);
                }
                //END :: added by Navleen as part of DLT-16591    
            }                
            else if(quoteName == 'Best Value'){              
                if(dsObj.Contract_Type__c != null && dsObj.Contract_Type__c.trim()!= null ) { //DLT-16958
                    quoteProposal.Apttus_Proposal__Proposal_Name__c = opp.Name+'- '+dsObj.Contract_Type__c.trim()+' Plus';                         
                    if(dsObj.Contract_Type__c != INELIGIBLE){
                        opp.Digital_MidContract_Status__c = 'Working';
                    } //DLT-16958
                }               
                else{
                    quoteProposal.Apttus_Proposal__Proposal_Name__c = opp.Name+' - Plus';                         
                }
            }                                      
            else if(quoteName == 'Premium'){
                if(dsObj.Contract_Type__c != null && dsObj.Contract_Type__c.trim()!= null ){         //DLT-16958  
                    quoteProposal.Apttus_Proposal__Proposal_Name__c = opp.Name+'- '+dsObj.Contract_Type__c.trim()+' Premium';
                    if(dsObj.Contract_Type__c != INELIGIBLE){
                        opp.Digital_MidContract_Status__c = 'Working';
                    } //DLT-16958
                }               
                else{
                    quoteProposal.Apttus_Proposal__Proposal_Name__c = opp.Name+' - Premium';                          
                }
            }
        }
        
        // DLT-9536 - Set the Proposal owner and Approval Segment based on the Digital Firm
        if(opp.Owner.Name == System.Label.DC_INFORMATICA_USER){
            //quoteProposal.Ownerid = mapDigitalOwner.get(DSobj.Digital_Firm__c);
            // DLT-16854 starts
            Id digitalOwnerID = globObj.setTheDigitalOwnerAppSegment(DSobj.Digital_Firm__c);
            quoteProposal.Ownerid = digitalOwnerID;
            quoteProposal.createdById =digitalOwnerID;
            // DLT-16854 Ends here        
        } else {
            quoteProposal.Ownerid = opp.Owner.Id;
            quoteProposal.createdById = opp.Owner.Id;
        }
        
        quoteProposal.Apttus_Proposal__ReadyToGenerate__c = TRUE;
        quoteProposal.Digital_Batch_Processed__c = TRUE; 
        if(quoteName == 'Straight Renewal'){
            quoteProposal.Digital_Quote_Type__c = 'Straight Renewal';
        }  
        else if(quoteName == 'Best Value'){
            quoteProposal.Digital_Quote_Type__c = 'Best Value';
        }  
        else if(quoteName == 'Premium'){
            quoteProposal.Digital_Quote_Type__c = 'Premium';
        }  
        quoteProposal.Digital_Quote_Automation__c = TRUE;
        //quoteProposal.APTS_Approval_Segment__c = dsObj.Digital_Firm__c; //DLT-15184 added for Findlaw //DLT-16181
        return  quoteProposal;   
    }
    
  /**
    * @description : method to create exception records
    * @param exMessage : error message
    * @param exType : error type
    * @param additionalInfo : additional error info
    * @param userMessage : user message
    * @param classRef : class reference
    * @return Exception record
    */    
    public static Digital_Exception_Log__c createExceptionLog(String exMessage, String exType, String additionalInfo, String userMessage, String classRef) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        ex.User_Message__c = userMessage;
        ex.Class_Reference__c = classRef ;
            
        return ex;
    }
}