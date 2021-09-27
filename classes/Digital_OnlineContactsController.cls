/**
 * Controller for the OnlineContacts.page that extends the 
 * Quote/Proposal standard controller
 *
 * @author  TCS
 * @version 2016-07-01
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                  Description
 * 2016-07-01   Sreenu D              Created 
 * 2016-11-01   Sreenu D              Multiple Agreement Location Changes- R2   
 * 2018-14-06   SrikanthKota          APTS_Source_System_Detail_c  is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
 * 2018-19-06   SrikanthKota          Updateed global to Public.
 * 2019-06-12   Srikanth Kota         DLT-16784-[Tech Story] [Code Scan] - Fix code scan CRITICAL issues in this Digital_OnlineContactsController and Digital_SmartMatching
 * 2019-10-22   Brenda Shields        DLT-18088 - Product User Detail PDF is not displaying correctly in Chrome / updating for PMD errors
 * 2020-10-10   Rahul Natarajan       DLT-20790 - Changed New variable name to totalbandedList
 * 2021-03-04   Brenda Shields        DLT-17212 - [ALL] Update class to create document as a file and not an attachment 
 * 2021-02-12   Kavya S               DLT-21591 - [SFDC][REN] PMD Scan
 * =============================================================================
 */
/** 
  * @description : public with sharing class Digital_OnlineContactsController {
  */
public with sharing class Digital_OnlineContactsController {
    // Variables
    public list<Online_Contacts__c> ocList;
    public transient map<string, list<Online_Contacts__c>> mocMap; // Map to hold Online Contacts without Contact Id
    public transient map<string, Online_Contacts__c> cmocMap; // Map to Online Contacts with Contact Id
    public transient map<string, list<APLIWrapper>> bandedMap;
    public set<Online_Contacts__c> bpListtoDel;
    public set<Online_Contacts__c> psListtoDel;
    //public Integer pageSize = 5;
    public string bandedMaterials = '';
    public string perSheetmaterials = '';
    //public transient OnlineContactsSerializeandDeserialize.OnlineContactsResponse olDataESI;
    //public transient OnlineContactsSerializeandDeserialize.Notification olNoteESI;
    public transient OnlineContactsSerializeandDeserializeRes.OnlineContactResponse olDataESI;
    public transient OnlineContactsSerializeandDeserializeRes.Notification olNoteESI;
    public map<String, list<APLIWrapper>> materialsMap;
    public integer olContactsSize = 0;
    public decimal checkBandedSize = 0;
    public map<string, Apttus_Proposal__Proposal_Line_Item__c> psCountMap;
    public transient map<string, string> bandedProductsMap; // to hold the Banded products Material and product description
    public Boolean isBandedValidation = False;
    string sapNo = '';
    ID quoteAcc = null;
    ID quoteSsd = null;
    public transient list<string> lineStatus; 
    public list<Apttus_Proposal__Proposal_Line_Item__c> apliUpdList;
    public set<Id> bandedApliIds;   
    
    /** 
  * @description : proposalId
  * @return : String
  */
    public string proposalId {get;set;}
    /** 
  * @description : aptProposal
  * @return : Apttus_Proposal__Proposal__c
  */
    public Apttus_Proposal__Proposal__c aptProposal {get;set;}
    /** 
  * @description : apliList
  * @return : Apttus_Proposal__Proposal_Line_Item__c
  */
    public transient list<Apttus_Proposal__Proposal_Line_Item__c> apliList {get;set;}
    /** 
  * @description : apliWrapper
  */
    public list<APLIWrapper> apliWrapper {get;set;}
    /** 
  * @description : totalbandedList
  */
    public list<APLIWrapper> totalbandedList {get; set;}
    /** 
  * @description : perSheetAPLIList
  */
    public list<APLIWrapper> perSheetAPLIList {get;set;}
    /** 
  * @description : selectedAPLIs
  */
    public list<APLIWrapper> selectedAPLIs {get; set;}
    /** 
  * @description : isSelectAll
  */
    public boolean isSelectAll {get;set;}
    /** 
  * @description : isBandedOneSelected
  */
    public boolean isBandedOneSelected {get;set;}
    /** 
  * @description : isperSheetOneSelected
  */
    public Boolean isperSheetOneSelected {get;set;}
    /** 
  * @description : isBandedSelectAll
  */
    public Boolean isBandedSelectAll {get;set;}
    /** 
  * @description : isPerSheetSelectAll
  */
    public Boolean isPerSheetSelectAll {get;set;}
    // dropdown
    /** 
  * @description : perSeatProducts
  */
    public string perSeatProducts {get;set;}
    /** 
  * @description : psProductsList
  */
    public list<SelectOption> psProductsList {get;set;}
    /** 
  * @description : dspMaterials
  */
    public list<APLIWrapper> dspMaterials {get;set;}
    /** 
  * @description : maxBandedProdQnt
  */
    public decimal maxBandedProdQnt {get;set;}
     /** 
  * @description : bandedProducts
  */
    public list<string> bandedProducts {get;set;}
    /** 
  * @description : psMaterial
  */
    public PSMaterials psMaterial {get;set;}
    /** 
  * @description : isAddReq
  */
    public Boolean isAddReq {get;set;}
    /** 
  * @description : isExCon
  */
    public Boolean isExCon {get;set;} // Flag to display Add Online contacts Button in banded materials tab if Sap Contacts exists
    /** 
  * @description : isExPSCon
  */
    public Boolean isExPSCon {get;set;} // Flag to display Add Online contacts Button in Per sheetmaterials tab if Sap Contacts exists
    // Location Dropdown
    /** 
  * @description : location
  */
    public string location {get;set;}
    /** 
  * @description : locationList
  */
    public list<SelectOption> locationList {get;set;}
    /** 
  * @description : locationMap
  */
    public map<Id, APTS_Quote_Agreement_Locations__c> locationMap {get;set;}
    /** 
  * @description : preLocation
  */
    public string preLocation {get;set;}
    /** 
  * @description : isError
  */
    public Boolean isError {get;set;}
    /** 
  * @description : Digital_OnlineContactsController
  */
    public Digital_OnlineContactsController() {
        system.debug(logginglevel.INFO, 'Beginning Processing');
    }

    // Constructor 
    /** 
     * @description : Digital_OnlineContactsController
     * @param stdCon : stdCon 
     */

    public Digital_OnlineContactsController(ApexPages.StandardController stdCon) {
        apliList = new List < Apttus_Proposal__Proposal_Line_Item__c > ();
        aptProposal = new Apttus_Proposal__Proposal__c();
        bandedApliIds = new Set < Id > ();
        apliWrapper = new List < APLIWrapper > ();
        selectedAPLIs = new List < APLIWrapper > ();
        isSelectAll = False;
        isBandedOneSelected = False;
        isperSheetOneSelected = False;
        isBandedSelectAll = False;
        isPerSheetSelectAll = False;
        ocList = new List < Online_Contacts__c > ();
        // Location Dropdown
        location = '';
        locationList = new List < SelectOption > ();
        locationMap = new Map < Id, APTS_Quote_Agreement_Locations__c > ();
        preLocation = '';
        isError = False;
        //proposalId = ApexPages.CurrentPage().getParameters().get('id'); //commented by Dinesh
        Apttus_Proposal__Proposal__c quote = (Apttus_Proposal__Proposal__c) stdcon.getrecord(); // Added by Dinesh
        proposalId = quote.id;

        // get the Quote/Proposal Line Items base on the Quote/Proposal Id
        if (!string.isEmpty(proposalId)) {
            try {
                //aptProposal = [Select Id, Name, Apttus_Proposal__Account__c,APTS_SSD_Sold_To__c, APTS_MLA_Quote__c, Apttus_Proposal__Account__r.Name, Apttus_Proposal__Account__r.External_Trial_Account_ID__c, Apttus_Proposal__Account__r.Sales_Org__c, Apttus_Proposal__Account__r.SapAccountNumber__c From Apttus_Proposal__Proposal__c Where Id =: proposalId];
                if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()) {
                    aptProposal = [Select Id, Name, Apttus_Proposal__Account__c, APTS_MLA_Quote__c, Apttus_Proposal__Account__r.Name, Apttus_Proposal__Account__r.External_Trial_Account_ID__c, APTS_SSD_Sold_To__r.LCRM_Sales_Org__c, APTS_SSD_Sold_To__r.LCRM_SAP_Account_Number__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c, APTS_SSD_Sold_To__r.LCRM_External_Trail_Acount_ID__c
                        From Apttus_Proposal__Proposal__c Where Id =: proposalId
                    ];
                }
                system.debug(logginglevel.INFO, 'aptProposal...' + aptProposal);
                //apliList = [Select Id, Name, APTS_Program_ID__c, APTS_Product_Name_Override__c, APTS_Service_Number_Override__c, Apttus_QPConfig__LineType__c, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name From Apttus_Proposal__Proposal_Line_Item__c Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed')  Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last];
                // get the Account Locations based on the quote
                if (aptProposal.APTS_MLA_Quote__c) {
                    //for(APTS_Quote_Agreement_Locations__c al : [Select Id, APTS_Subscriber_Location__c, APTS_Subscriber_Location__r.Name, APTS_Subscriber_Location__r.SAPAccountNumber__c, APTS_Subscriber_Location__r.External_Trial_Account_ID__c, APTS_Status__c From APTS_Quote_Agreement_Locations__c Where APTS_Quote_Proposal__c = :proposalId AND APTS_Status__c IN ('New', 'Existing')]) {
                    for (APTS_Quote_Agreement_Locations__c al: [Select Id, APTS_Subscriber_Location__c, APTS_Subscriber_Location_SSD__c, APTS_Subscriber_Location_SSD__r.name, APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c, APTS_Subscriber_Location_SSD__r.LCRM_External_Trail_Acount_ID__c, APTS_Subscriber_Location__r.Name, APTS_Subscriber_Location__r.SAPAccountNumber__c, APTS_Subscriber_Location__r.External_Trial_Account_ID__c, APTS_Status__c From APTS_Quote_Agreement_Locations__c Where APTS_Quote_Proposal__c =: proposalId AND APTS_Status__c IN('New', 'Existing')]) {
                        //locationMap.put(al.APTS_Subscriber_Location__c, al); //.APTS_Subscriber_Location__r.SAPAccountNumber__c);
                        //locationList.add(new SelectOption(al.APTS_Subscriber_Location__c, al.APTS_Subscriber_Location__r.SAPAccountNumber__c+' - '+al.APTS_Subscriber_Location__r.Name));                  
                        locationMap.put(al.APTS_Subscriber_Location_SSD__c, al); //.APTS_Subscriber_Location__r.SAPAccountNumber__c);
                        locationList.add(new SelectOption(al.APTS_Subscriber_Location_SSD__c, al.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c + ' - ' + al.APTS_Subscriber_Location_SSD__r.Name));
                        // assign the value if dropdown list is blank for first time
                        if (string.isEmpty(location)) {
                            //location = al.APTS_Subscriber_Location__c;
                            location = al.APTS_Subscriber_Location_SSD__c;
                            preLocation = location;
                        }
                    }
                }

                // call the method to map the Online contacts to display in the page.
                mappingLogic();
            } catch (Exception ex) {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()+ex.getLineNumber()));       
                system.debug(logginglevel.ERROR, 'Error: ' + ex.getMessage());
            }
        }
    }

    /* -------------------------------------------------------------------------------
    
    Method to perform all the Logics while loading the page/Constructor
    --------------------------------------------------------------------------------*/
   /** 
  * @description : mappingLogic
  */
    public void mappingLogic() {
        system.debug(logginglevel.INFO, 'in Mapping Method...');
        mocMap = new Map < string, List < Online_Contacts__c >> ();
        cmocMap = New Map < string, Online_Contacts__c > ();
        bandedMap = new Map < String, List < APLIWrapper >> ();
        bpListtoDel = new Set < Online_Contacts__c > ();
        psListtoDel = new Set < Online_Contacts__c > ();
        //olDataESI = new OnlineContactsSerializeandDeserialize.OnlineContactsResponse();
        //olNoteESI = new OnlineContactsSerializeandDeserialize.Notification();
        olDataESI = new OnlineContactsSerializeandDeserializeRes.OnlineContactResponse();
        olNoteESI = new OnlineContactsSerializeandDeserializeRes.Notification();
        totalbandedList = new List < APLIWrapper > ();
        perSheetAPLIList = new List < APLIWrapper > ();
        bandedMaterials = '';
        perSheetmaterials = '';
        // dropdown
        perSeatProducts = '';
        psProductsList = new List < SelectOption > ();
        dspMaterials = new List < APLIWrapper > ();
        materialsMap = new Map < String, List < APLIWrapper >> ();
        maxBandedProdQnt = null;
        bandedProducts = new List < string > ();
        lineStatus = new List < string > ();
        psCountMap = new Map < string, Apttus_Proposal__Proposal_Line_Item__c > ();
        psMaterial = new PSMaterials();
        isExCon = True;
        isExCon = True;

        //apliList = [Select Id, Name, APTS_Program_ID__c, APTS_Product_Name_Override__c, APTS_Service_Number_Override__c, Apttus_QPConfig__LineType__c, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name From Apttus_Proposal__Proposal_Line_Item__c Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed')  Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last];
        // call the method to get the online contacts from Missoa
        if (!string.isEmpty(location)) {
            //quoteAcc = location;
            quoteSsd = location;
            /*if(!string.isEmpty(locationMap.get(location).APTS_Subscriber_Location__r.External_Trial_Account_ID__c))
                sapNo = locationMap.get(location).APTS_Subscriber_Location__r.External_Trial_Account_ID__c;
            else
                sapNo = locationMap.get(location).APTS_Subscriber_Location__r.SAPAccountNumber__c; 
            */
            if (!string.isEmpty(locationMap.get(location).APTS_Subscriber_Location_SSD__r.LCRM_External_Trail_Acount_ID__c)) {
                sapNo = locationMap.get(location).APTS_Subscriber_Location_SSD__r.LCRM_External_Trail_Acount_ID__c;
            } else {
                sapNo = locationMap.get(location).APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;
            }
            if (locationMap.get(location).APTS_Status__c == 'New') {
                lineStatus.add('New');
                lineStatus.add('Amended');
            } else {
                lineStatus.add('New');
            }
        } else {
            quoteAcc = aptProposal.Apttus_Proposal__Account__c;
            quoteSsd = aptProposal.APTS_SSD_Sold_To__c;
            /*if(!string.isEmpty(aptProposal.Apttus_Proposal__Account__r.External_Trial_Account_ID__c))
                sapNo = aptProposal.Apttus_Proposal__Account__r.External_Trial_Account_ID__c;
            else
                sapNo = aptProposal.Apttus_Proposal__Account__r.SapAccountNumber__c;*/
            if (!string.isEmpty(aptProposal.APTS_SSD_Sold_To__r.LCRM_External_Trail_Acount_ID__c)) {
                sapNo = aptProposal.APTS_SSD_Sold_To__r.LCRM_External_Trail_Acount_ID__c;
            } else {
                sapNo = aptProposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;
            }
            lineStatus.add('New');
        }
        system.debug(logginglevel.INFO, 'sapNo====>...' + sapNo);
        fetchAccountOnlinePasswords(sapNo);
        // find the OLC data size nad some time we are getting blank response which giving size as 1 so to avoid that checking the contactid and count the size.
        //if(olDataESI != null && !olDataESI.onlineContacts.isEmpty()){
        if (olDataESI != null && olDataESI.onlineContact != null && !olDataESI.onlineContact.isEmpty()) {
            // for(OnlineContactsSerializeandDeserialize.onlineContacts oContacts :olDataESI.onlineContacts) { 
            for (OnlineContactsSerializeandDeserializeRes.onlineContact oContacts: olDataESI.onlineContact) {
                //if(!string.isEmpty(oContacts.contactId) && validateActiveOLC(oContacts.entitlements) && (oContacts.onlineContactType != '0997' && oContacts.onlineContactType != '0998' && oContacts.onlineContactType != '0999')) {
                if (!string.isEmpty(oContacts.contactNumber) && validateActiveOLC(oContacts.entitlements) && (oContacts.onlineContactType != '0997' && oContacts.onlineContactType != '0998' && oContacts.onlineContactType != '0999')) {
                    olContactsSize += 1;
                }
            }
        }
        system.debug(logginglevel.INFO, 'olContactsSize...' + olContactsSize);
        // get the records from Online Contacts Object to display in Page. These are user added Contacts and assign contacts to Maps baesd on ContactId is empty or not
        //for(Online_Contacts__c onl : [Select Id, Name, Material__c, ContactID__c, Is_Banded_Product__c, Account__c, First_Name__c, Middle_Name__c, Last_Name__c, Email__c, Position__c, Type__c, Sftwr_Admin__c, WLEc_Juris__c From Online_Contacts__c Where Account__c =:quoteAcc AND QuoteId__c =: proposalId Order By Name]) {
        for (Online_Contacts__c onl: [Select Id, APTS_Source_System_Detail__c, Name, Material__c, ContactID__c, Is_Banded_Product__c, Account__c, First_Name__c, Middle_Name__c, Last_Name__c, Email__c, Position__c, Type__c, Sftwr_Admin__c, WLEc_Juris__c From Online_Contacts__c Where APTS_Source_System_Detail__c =: quoteSsd AND QuoteId__c =: proposalId Order By Name]) {
            if (string.isEmpty(onl.ContactID__c)) {
                if (!mocMap.isEmpty() && mocMap.containsKey(onl.Material__c)) {
                    mocMap.get(onl.Material__c).add(onl);
                } else {
                    mocMap.put(onl.Material__c, new List < Online_Contacts__c > {
                        onl
                    });
                }
            } else {
                cmocMap.put((onl.Material__c + onl.ContactID__c), onl);
            }
            if (onl.Is_Banded_Product__c) {
                bpListtoDel.add(onl);
            } else {
                psListtoDel.add(onl);
            }
        }
        // dropdown assign null first
        psProductsList.add(new SelectOption('', '--None--'));
        //system.debug(logginglevel.INFO, 'apliList...'+apliList);
        for (Apttus_Proposal__Proposal_Line_Item__c aplis: [Select Id, Name, APTS_Program_ID__c, APTS_Product_Name_Override__c, APTS_Service_Number_Override__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__LineStatus__c, APTS_Number_of_Attorneys__c, Net_Qty_Difference__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name From Apttus_Proposal__Proposal_Line_Item__c Where(Apttus_Proposal__Proposal__c =: proposalId AND Apttus_QPConfig__LineStatus__c IN: lineStatus) Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last]) {

            // unused APLIWrapper aw = new APLIWrapper();
            // add Banded Products to Banded list
            if ((!validateProductLLCode((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c + aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP') {

                if (aplis.Apttus_QPConfig__LineStatus__c != 'Amended' && (validateProductLLCode(aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) ||
                        (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'I9'))) {

                    if (aplis.APTS_Program_ID__c != 'CPRO') {
                        bandedApliIds.add(aplis.id);
                        bandedHelper(aplis.Apttus_Proposal__Product__r.ProductCode, aplis.APTS_Number_of_Attorneys__c, aplis.Apttus_Proposal__Product__r.Name);
                    } else If(aplis.APTS_Program_ID__c == 'CPRO' && aplis.Apttus_QPConfig__LineType__c == 'Product/Service') {
                        bandedApliIds.add(aplis.id); bandedHelper(aplis.APTS_Service_Number_Override__c, aplis.APTS_Number_of_Attorneys__c, aplis.APTS_Product_Name_Override__c);
                    }

                    if (aplis.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '064') {
                        isBandedValidation = True;
                    }
                }
                // add per sheet Products to perSheet List
                else if ((aplis.Apttus_QPConfig__LineStatus__c == 'New' || (aplis.Net_Qty_Difference__c != null && aplis.Net_Qty_Difference__c > 0 && aplis.Apttus_QPConfig__LineStatus__c == 'Amended')) && (validateProductLLCode(aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, System.Label.OCPerSeatLowerLevelCodes) ||
                        (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21') ||
                        (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'I9'))) {

                    if (aplis.APTS_Program_ID__c != 'CPRO') {

                        perSeatHelper(aplis.Apttus_Proposal__Product__r.ProductCode, aplis.Apttus_Proposal__Product__r.Name, aplis);
                    } else If(aplis.APTS_Program_ID__c == 'CPRO' && aplis.Apttus_QPConfig__LineType__c == 'Product/Service') {

                        perSeatHelper(aplis.APTS_Service_Number_Override__c, aplis.APTS_Product_Name_Override__c, aplis);
                    }

                }
                system.debug(logginglevel.INFO, 'psProductsList...' + psProductsList);
            }
        }
        // then check for custom object records which are added newly 
        if (!string.isEmpty(perSheetmaterials) || !string.isEmpty(bandedMaterials)) {

            if (!mocMap.isEmpty()) {
                for (List < Online_Contacts__c > ocList: mocMap.values()) {
                    for (Online_Contacts__c olc: ocList) {
                        system.debug(logginglevel.INFO, 'Online Contact...' + olc);
                        APLIWrapper aw = new APLIWrapper();
                        aw.onlineContact = olc;
                        aw.isNewContact = True;
                        aw.isSelected = True;

                        if (olc.Is_Banded_Product__c != True && !string.isEmpty(perSheetmaterials) && perSheetmaterials.contains(olc.Material__c)) {
                            // psListtoDel.add(olc);                       
                            aw.materialNo = perSheetmaterials;
                            system.debug(logginglevel.INFO, 'aw...' + aw);
                            //  perSheetAPLIList.add(aw);                            

                            aw.materialNo = olc.Material__c;
                            mappingMaterials(aw, False);

                        } else If(!string.isEmpty(bandedMaterials) && olc.Is_Banded_Product__c == True) {
                            // bpListtoDel.add(olc);
                            aw.MaterialNo = olc.Material__c;
                            mappingMaterials(aw, True);
                            // totalbandedList.add(aw);    
                        }
                    }
                }
            }
            system.debug(logginglevel.INFO, 'materialsMap..' + materialsMap);
        }
        //system.debug(logginglevel.INFO, 'totalbandedList size...'+totalbandedList.size());
        // add the max number of rows for banded product- maxBandedProdQnt
        Integer bSize = !string.isEmpty(bandedMaterials) ? bandedMaterials.split('\n').size() : 0;
        checkBandedSize = maxBandedProdQnt != null ? maxBandedProdQnt * bSize : 0;

        if ((olContactsSize != null || olContactsSize != 0)) {
            if (!bandedMap.isEmpty()) {
                /*for(string awKey :bandedMap.keyset()) {
                    totalbandedList = bandedMap.get(awKey);
                    break;    
                }*/
                for (String materialNum: bandedMap.keySet()) {
                    totalbandedList.addAll(bandedMap.get(materialNum));
                }
            }
            // added for DLT-8943
            if (!materialsMap.isEmpty()) {
                system.debug(logginglevel.INFO, 'materialsMap..' + materialsMap.keySet());
                for (String materialNum: materialsMap.keySet()) {
                    perSheetAPLIList.addAll(materialsMap.get(materialNum));
                }
            }
            system.debug(logginglevel.INFO, 'materialsMap..' + materialsMap.keySet());
        }
        //Commented for display Add new row button.
        /* 
        if(maxBandedProdQnt != null) {
             for(Integer i = totalbandedList.size()+1; i <= ((Integer.valueof(maxBandedProdQnt))+(olContactsSize)); i++) {
                 addOnlineContactsUtil();
             }         
         } 
         // added new code line to display empty contacts for Banded products if Existing(SAP) Contact sare Empty
          if((olContactsSize == null || olContactsSize == 0) && maxBandedProdQnt != null) {
             integer bandedsize = !totalbandedList.isEmpty() ? totalbandedList.Size() : 0;                    
             for(Integer i = bandedsize+1; i <= bandedsize+10; i++) {
                 if(totalbandedList.isempty()) { 
                     addOnlineContactsUtil();
                 }
                 else if(totalbandedList.size() < (Integer.valueof(maxBandedProdQnt)+(olContactsSize)))
                     addOnlineContactsUtil();
             }
           //  isExCon = False;         
         } 
         // If banded products are not available then isExCon is False;
         if(string.isEmpty(bandedMaterials)) {
             isExCon = False;    
         }
         */
        // Display the first material contacts in the per seat tab
        displayMaterialContacts();
        system.debug(logginglevel.INFO, 'no of Queries buc...' + Limits.getQueries());
        system.debug(logginglevel.INFO, 'no of Queries buc...' + Limits.getLimitQueries());
        system.debug(logginglevel.INFO, 'perSheetAPLIList...' + perSheetAPLIList);
    }
    /* -------------------------------------------------------------------------------    
    Check the APTS_Media_Lower_Level_Code__c to find out the product is Banded or Per Seat.
    --------------------------------------------------------------------------------*/
   /** 
     * @description : validateProductLLCode
     * @param llCode : llCode 
     * @param codes : codes
     * @return : isValid
     */
    public static Boolean validateProductLLCode(string llCode, string codes) {
        Boolean isValid = False;
        if (!string.isEmpty(llCode) && !string.isEmpty(codes)) {
            for (string str: codes.split(',')) {
                if (str == llCode) {
                    isValid = True;
                    break;
                }
            }
        }
        system.debug(logginglevel.INFO, 'isValid...' + isValid);
        return isValid;
    }
    /* -------------------------------------------------------------------------------    
    method to assign the Online contacts to Banded materials
    --------------------------------------------------------------------------------*/
    /** 
     * @description : bandedHelper
     * @param productCode : productCode 
     * @param noa : noa
     * @param pName : pName
     */
    public void bandedHelper(string productCode, decimal noa, string pName) {
        if (string.isEmpty(bandedMaterials)) {
            bandedMaterials = productCode + '\n';
        } else {
            bandedMaterials += productCode + '\n';
        }
        if (maxBandedProdQnt == null) {
            maxBandedProdQnt = noa;
        } else if (maxBandedProdQnt < noa) { maxBandedProdQnt = noa;
        }
        bandedProducts.add(productCode + ' ' + pName);
        assignESIContacts(productCode, True);

    }
    /* -------------------------------------------------------------------------------    
    method to assign perSeat material contacts
    --------------------------------------------------------------------------------*/
    /** 
     * @description : perSeatHelper
     * @param productCode : productCode 
     * @param productTitle : productTitle
     * @param aplis : aplis
     */
    public void perSeatHelper(string productCode, string productTitle, Apttus_Proposal__Proposal_Line_Item__c aplis) {
        psCountMap.put(productCode, aplis);
        if (string.isEmpty(perSheetmaterials)) {
            perSheetmaterials = productCode + '\n';
        } else {
            perSheetmaterials += productCode + '\n';
        }

        // dropdown
        if (!string.isEmpty(productCode) && !string.isEmpty(productTitle)) {
            psProductsList.add(new SelectOption(productCode, productTitle));
        }
        // assign the value if dropdown list is blank for first time
        if (string.isEmpty(perSeatProducts)) {
            perSeatProducts = productCode;

        }
        // assign ESI contacts to per Sheet materials.
        assignESIContacts(productCode, False);
    }
    /* -------------------------------------------------------------------------------    
    validate the olc system(SAP) contacts Status 
    --------------------------------------------------------------------------------*/
    // public static boolean validateActiveOLC(List<OnlineContactsSerializeandDeserialize.entitlements> entitles) {
      /** 
     * @description : validateActiveOLC
     * @param entitles : entitles 
     * @return : isActive
     */  
    public static boolean validateActiveOLC(List < OnlineContactsSerializeandDeserializeRes.entitlements > entitles) {
        Boolean isActive = False;
        //for(OnlineContactsSerializeandDeserialize.entitlements entl :entitles) {
        for (OnlineContactsSerializeandDeserializeRes.entitlements entl: entitles) {
            if (entl.status == 'ACTIVE') {
                isActive = True;
                break;
            }
        }
        return isActive;
    }
    /* -------------------------------------------------------------------------------    
    map the Missoa Online Contacts to each material
    --------------------------------------------------------------------------------*/
    /** 
     * @description : assignESIContacts
     * @param material : material 
     * @param isBanded : isBanded
     */  
    public void assignESIContacts(string material, Boolean isBanded) {
        system.debug(logginglevel.INFO, 'material...' + material);
        if (olDataESI != null && (olContactsSize != null || olContactsSize != 0)) {
            //  for(OnlineContactsSerializeandDeserialize.onlineContacts oContacts :olDataESI.onlineContacts) {
            for (OnlineContactsSerializeandDeserializeRes.onlineContact oContacts: olDataESI.onlineContact) {
                system.debug(logginglevel.INFO, 'oContacts...' + oContacts); //&& !string.isEmpty(oContacts.email)
                if (!string.isEmpty(oContacts.contactNumber) && validateActiveOLC(oContacts.entitlements) && (oContacts.onlineContactType != '0997' && oContacts.onlineContactType != '0998' && oContacts.onlineContactType != '0999')) {
                    Boolean isNoMatch = True;
                    APLIWrapper aw = new APLIWrapper();
                    if (!cmocMap.isEmpty()) {
                        // loop the online contact list and check with missoa contact, if user select the contact
                        // if yes, check the isSelected checkbox else add the contact to map
                        aw = new APLIWrapper();
                        if (cmocMap.containsKey((material + oContacts.contactNumber)) && !cmocMap.get((material + oContacts.contactNumber)).Is_Banded_Product__c) {
                            // psListtoDel.add(cmocMap.get((material+oContacts.contactId)));
                            isNoMatch = False;   mappingMaterials(assignESISelectedContactsUtil(oContacts, material, cmocMap.get((material + oContacts.contactNumber))), False);
                            //  system.debug(logginglevel.INFO, 'per seat selected Contacts from Missoa..'+material+'-'+olc.ContactID__c);
                        } else {
                            if (cmocMap.containsKey((material + oContacts.contactNumber)) && cmocMap.get((material + oContacts.contactNumber)).Is_Banded_Product__c && isBanded) {
                                //system.debug(logginglevel.INFO, 'Banded selected Contacts from Missoa..'+material+'-'+olc.ContactID__c);
                                // bpListtoDel.add(cmocMap.get((material+oContacts.contactId)));
                                isNoMatch = False;  mappingMaterials(assignESISelectedContactsUtil(oContacts, material, cmocMap.get((material + oContacts.contactNumber))), True);
                                //  system.debug(logginglevel.INFO, 'Banded selected Contacts from Missoa..'+material+'-'+olc.ContactID__c);
                            }

                        }
                        if (isNoMatch == True) {
                            mappingMaterials(assignESIContactsUtil(oContacts, material), isBanded);
                        }
                    }
                    // if Online contact list is empty, then add the missoa contacts to map.
                    else {
                        mappingMaterials(assignESIContactsUtil(oContacts, material), isBanded);
                    }

                }
            }
        }

    }
    /* -------------------------------------------------------------------------------    
    Util method to assign the values from the Esi response if contact match found in Online Contacts object.
    --------------------------------------------------------------------------------*/
    /** 
     * @description : assignESISelectedContactsUtil
     * @param oContacts : oContacts 
     * @param material : material 
     * @param olc : olc   
     * @return : aw
     */ 
    public APLIWrapper assignESISelectedContactsUtil(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts, string material, Online_Contacts__c olc) {
        APLIWrapper aw = new APLIWrapper(); aw.isSelected = True;  aw.onlineContact = olc;  aw.onlineContact.First_Name__c = oContacts.Address.firstName;  aw.onlineContact.Last_Name__c = oContacts.Address.lastName; aw.materialNo = material; aw.source = oContacts.sourceId; return aw;
    }
    /* -------------------------------------------------------------------------------    
    Util method to assign the values from the Esi response if contact match not found in Online Contacts object.
    --------------------------------------------------------------------------------*/
   /** 
     * @description : assignESIContactsUtil
     * @param oContacts : oContacts 
     * @param material : material   
     * @return : aw
     */
    public APLIWrapper assignESIContactsUtil(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts, string material) {
        APLIWrapper aw = new APLIWrapper();
        aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
        //Added by priyanka 09/21
        aw.onlineContact.APTS_Source_System_Detail__c = quoteSsd;
        aw.onlineContact.QuoteId__c = proposalId;
        aw.onlineContact.Material__c = material;
        aw.onlineContact.ContactID__c = oContacts.contactNumber;
        aw.onlineContact.First_Name__c = oContacts.address.firstName;
        aw.onlineContact.Last_Name__c = oContacts.address.LastName;
        aw.onlineContact.Email__c = oContacts.address.emailAddress;
        aw.onlineContact.Position__c = oContacts.onlineContactTypeDescription;
        aw.materialNo = material;
        aw.source = oContacts.sourceId;
        system.debug(logginglevel.INFO, 'aw...' + aw);

        return aw;
    }
    /* -------------------------------------------------------------------------------    
    util method for assigning the materials based on Banded or Per Sheet
    --------------------------------------------------------------------------------*/
    /** 
     * @description : mappingMaterials
     * @param aw : aw 
     * @param isBandedM : isBandedM
     */
    public void mappingMaterials(APLIWrapper aw, Boolean isBandedM) {
        system.debug(logginglevel.INFO, 'map Materials method..');
        if (isBandedM == False) {
            if (materialsMap.containsKey(aw.materialNo)) {
                materialsMap.get(aw.materialNo).add(aw);
            } else {
                materialsMap.put(aw.materialNo, new List < APLIWrapper > {
                    aw
                });
            }
        }
        if (isBandedM == True) {

            if (bandedMap.containsKey(aw.materialNo)) {
                bandedMap.get(aw.materialNo).add(aw);
            } else {
                bandedMap.put(aw.materialNo, new List < APLIWrapper > {
                    aw
                });
            }

        }
    }
    /* -------------------------------------------------------------------------------    
    get the Online Contacts from ESI-MISSOA
    --------------------------------------------------------------------------------*/
      /** 
     * @description : fetchAccountOnlinePasswords
     * @param sapNum : sapNum 
     */ 
    public void fetchAccountOnlinePasswords(string sapNum) {
        try {
            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('OnlineContacts');
            system.debug(logginglevel.INFO, 'oWebServiceSettings...' + oWebServiceSettings);

            OnlineContactsSerializeandDeserializeReq.OnlineContactsRequest smpReq = new OnlineContactsSerializeandDeserializeReq.OnlineContactsRequest();
            //Commented as part of Jira-SOC-903
            //smpReq.GetOnlineContactsByAccountRequest.context.companyId = KeyValueListStore__c.getInstance('OrderCaptureCompanyId').TextValue__c;
            //smpReq.GetOnlineContactsByAccountRequest.context.productId = KeyValueListStore__c.getInstance('OrderCaptureProductId').TextValue__c;
            //smpReq.GetOnlineContactsByAccountRequest.context.configGroup = KeyValueListStore__c.getInstance('OrderCaptureConfigGroup').TextValue__c;
            smpReq.ESIHeader.applicationId = KeyValueListStore__c.getInstance('OrderCaptureProductId').TextValue__c;
            smpReq.Account.accountNumber = sapNum; //'1004620772';
            String strBody = JSON.serialize(smpReq);
            system.debug(logginglevel.INFO, 'strBody...' + strBody);
            HttpResponse resp = new HttpResponse();
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('POST');
            //String url = 'https://esi-dev.thomsonreuters.com/osb/GetOnlineContacts_InboundService/PS_GOCByAccount_InboundService_REST';
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            //blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            //String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
            String authorizationHeader = 'Basic ' + System.Label.Digital_AuthorizationHeader_OLC;
            //String authorizationHeader = 'Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
            //req.setHeader('Authorization', authorizationHeader);
            req.setHeader(Label.Digital_Authorization, authorizationHeader); // DLT-16784                
            req.setHeader('Content-Type', 'application/json');

            req.setBody(strBody);
            req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
            system.debug(logginglevel.INFO, 'request--->' + req);
            if (!Test.isRunningTest()) {  resp = http.send(req);
            } else {
                resp.setStatusCode(200);
                resp.setBody('{"onlineContact":[{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803f0000015d6316e227720851f7","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d6316df57a30250ab","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"lastName":"Deadline Calculator Firm Alert User"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016216427","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0998"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744d779000001641e8501e0fa903680","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744803f000001641e84f98a679d377c","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744d779000001641e84f5da216369b1","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Bethany","lastName":"Matherne","emailAddress":"bethany@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0017212835","onlineContactTypeDescription":"Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0100"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-19","appUserGuid":"ia744803f0000015d5c75858722440307","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-19","appUserGuid":"ia744d7790000015d5c75878ff3ab5bcf","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-19","appUserGuid":"ia744d7790000015d5c758824e158b1f8","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Glenda","lastName":"Mitchell","emailAddress":"glenda@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016213069","onlineContactTypeDescription":"Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0100"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803f0000015d60b9d4a94ff26db8","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803f0000015d60b9cfd99b7cf3c4","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803d0000015d60b9cdd2a0d1570d","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Aaron","lastName":"Mitchell","emailAddress":"aaron@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016215036","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-08-11","appUserGuid":"ia744803f0000015dd1f2d088b19bd572","accessEndDate":"2017-08-14","applicationId":"COBALT","status":"INACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-11","appUserGuid":"ia744803d0000015dd1f2cd56a918ccdb","accessEndDate":"2017-08-14","applicationId":"DATAROOM","status":"INACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-11","appUserGuid":"ia744d7790000015dd1f2cb6b7eb3bbfb","accessEndDate":"2017-08-14","applicationId":"SLW","status":"INACTIVE"}],"address":{"firstName":"Assistant","lastName":"Mitchell","emailAddress":"glendamitchelllawfirm@gmail.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016266393","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fbc32dfb044cec15e","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-15","appUserGuid":"ia744803f0000015de2d75c466bdbcb58","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-15","appUserGuid":"ia744803f0000015de2d759df6bdbcb56","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Assistant","lastName":"Mitchell","emailAddress":"glendamitchelllawfirm@gmail.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016271394","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fc048b5aee1f59661","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fc048b12b90e67d96","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fc048aee491858360","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Amina","lastName":"Mohammed","emailAddress":"amina@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016549291","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d60b9dc44f3ab5c83","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d60b9d98578c5ce3d","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d60b9d85f126cad01","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Corrie","lastName":"Schott","emailAddress":"corrie@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016215037","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2018-06-21","appUserGuid":"ia744803f0000016422594f32ec9b7270","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744803f000001641e850e9eba57f0d2","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744d779000001641e850c3b216369b3","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Savannah","lastName":"Welch","emailAddress":"savannah@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0017212837","onlineContactTypeDescription":"Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0100"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2018-02-20","appUserGuid":"ia744d77900000161ae304bd7500cb2ce","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-02-19","appUserGuid":"ia744d77900000161ae304dd623bb52a1","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-02-20","appUserGuid":"ia744d77900000161ae304eb0944f001d","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"BENJAMIN","lastName":"YASKO","emailAddress":"BEN@GLENDAMITCHELLLAWFIRM.COM"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016762721","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"}],"ESIHeader":{"applicationId":"SF04"}}');
            }
            string strRes = resp.getBody();
            system.debug(logginglevel.INFO, 'strRes..' + strRes);
            system.debug(logginglevel.INFO, 'strRes..' + resp.getStatusCode());
            if (resp.getStatusCode() == 200) {
                if (!resp.getBody().contains('"onlineContacts" : [ null ]')) { // added this to overcome of deserilize error
                    if (!strRes.contains('Notification')) {
                        olDataESI = (OnlineContactsSerializeandDeserializeRes.OnlineContactResponse) JSON.deserialize(resp.getbody(), OnlineContactsSerializeandDeserializeRes.OnlineContactResponse.class);
                        system.debug(logginglevel.INFO, 'olDataESI...' + olDataESI);
                    } else {
                        olNoteESI = (OnlineContactsSerializeandDeserializeRes.Notification) JSON.deserialize(resp.getbody(), OnlineContactsSerializeandDeserializeRes.Notification.class);
                        system.debug(logginglevel.INFO, 'olNoteESI..' + olNoteESI);
                    }
                }
            }
            /*else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while fetching the Online Contacts from MISSOA'));
            }*/

            if (olNoteESI != null && !string.isEmpty(olNoteESI.StatusCode) && !string.isEmpty(olNoteESI.StatusDescription)) {
                system.debug(logginglevel.INFO, 'note...');
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,olNoteESI.StatusCode +'-'+olNoteESI.StatusDescription));
            }

        } catch (Exception oException) {
            //ApexPages.addMessages(oException);
            system.debug(logginglevel.ERROR, 'Error: ' + oException.getMessage());
        }
    }
    /* -------------------------------------------------------------------------------    
     Page load Action method - to Identify the Banded Products from the Proposal Line items and Online Contacts Objects.
     If Banded Line item is not avilable and Online contacts are available, delete the Online Contacts.
    --------------------------------------------------------------------------------*/
   /** 
    * @description : validateBandedMaterials
    * @return : null
    */  
    public PageReference validateBandedMaterials() {
        system.debug(logginglevel.INFO, 'bandedMaterials...' + bandedMaterials);
        if (string.isEmpty(bandedMaterials)) {
            List < Online_Contacts__c > ocBandedList = new List < Online_Contacts__c > ();
            //ocBandedList = [Select Id, Name, Material__c, ContactID__c, Is_Banded_Product__c, Account__c, First_Name__c, Middle_Name__c, Last_Name__c, Email__c, Position__c, Type__c, Sftwr_Admin__c, WLEc_Juris__c From Online_Contacts__c Where (Account__c =:quoteAcc AND QuoteId__c =: proposalId AND Is_Banded_Product__c = True)];
            if (Schema.sObjectType.Online_Contacts__c.isAccessible()) {
                ocBandedList = [Select Id, APTS_Source_System_Detail__c, Name, Material__c, ContactID__c, Is_Banded_Product__c, Account__c, First_Name__c, Middle_Name__c, Last_Name__c, Email__c, Position__c, Type__c, Sftwr_Admin__c, WLEc_Juris__c
                    From Online_Contacts__c
                    Where(APTS_Source_System_Detail__c =: quoteSsd AND QuoteId__c =: proposalId AND Is_Banded_Product__c = True)
                ];
            }
            system.debug(logginglevel.INFO, 'ocBandedList...' + ocBandedList);
            if (!ocBandedList.isEmpty()) { Database.delete(ocBandedList, false);
            }
        }
        return null;
    }
    /** 
     * @description : getbpSelected
     * @return : null
     */
    public PageReference getbpSelected() {
        selectedAPLIs.clear();
        for (APLIWrapper accwrapper: totalbandedList) {
            if (accwrapper.isSelected != true) {
                isBandedSelectAll = False;
            } else {
                selectedAPLIs.add(accwrapper);
            }
        }

        return null;
    }
/**  
* @description : getpspSelected
     * @return : null
     */  
    public PageReference getpspSelected() {
        for (APLIWrapper accwrapper: perSheetAPLIList) {
            if (accwrapper.isSelected != true) {
                isPerSheetSelectAll = False;
            }
        }
        return null;
    }
/**  
* @description : getBandedSelected
     * @return : null
     */ 
    public PageReference getBandedSelected() {
        selectedAPLIs.clear();
        if (isBandedSelectAll != True) {
            for (APLIWrapper accwrapper: totalbandedList) {
                accwrapper.isSelected = False;
            }
        }

        if (isBandedSelectAll == True) {
            for (APLIWrapper accwrapper: totalbandedList) {
                accwrapper.isSelected = true;
                selectedAPLIs.add(accwrapper);
            }
        }

        return null;
    }

    // Add Banded Online Contacts
    /**  
* @description : addOnlineContacts
     */  
    public void addOnlineContacts() {

        //system.debug(logginglevel.INFO, 'Banded list size...'+totalbandedList.size());
        if (!string.isEmpty(bandedMaterials) && totalbandedList.size() < (maxBandedProdQnt + olContactsSize)) {
            integer bmSize = totalbandedList.size();
            for (Integer i = bmSize + 1; i <= bmSize + 10; i++) {
                if (totalbandedList.size() < (Integer.valueof(maxBandedProdQnt) + (olContactsSize))) {
                    addOnlineContactsUtil();
                }
                if (i == 1000) {  break;
                }
            }
        }

    }
    // Util method for assign the values to banded product List
    /**  
* @description : addOnlineContactsUtil
     */  
    public void addOnlineContactsUtil() {
        if (!string.isEmpty(bandedMaterials)) {
            // for(string mater :bandedMaterials.split('\n')) {
            APLIWrapper aw = new APLIWrapper();
            aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
            aw.onlineContact.APTS_Source_System_Detail__c = quoteSsd;
            aw.onlineContact.QuoteId__c = proposalId;
            aw.MaterialNo = bandedMaterials;
            aw.isNewContact = True;
            totalbandedList.add(aw);
            // } 
        }
    }
    // add perSheet Online Contacts    
/**  
* @description : addPSOnlineContactsPS
     */  
    public void addPSOnlineContactsPS() {

        if (!string.isEmpty(perSheetMaterials)) {
            APLIWrapper aw = new APLIWrapper();
            aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
            aw.onlineContact.APTS_Source_System_Detail__c = quoteSsd;
            aw.onlineContact.QuoteId__c = proposalId;
            aw.materialNo = perSeatProducts;
            aw.isNewContact = True;

            if (!string.isEmpty(perSeatProducts)) {
                dspMaterials.add(aw);
            }
        }
    }

    // add 10 Rows on click for legal Hold and Retail Window Products and max - 999
    /**  
* @description : addPSContacts
     */  
    public void addPSContacts() {
        integer size = dspMaterials.size();
        for (Integer i = size + 1; i <= size + 10; i++) {
            if (dspMaterials.size() < 999) {
                addPSOnlineContactsPS();
            }
        }
    }
    // Add rows based on the No of Attorneys for Persheet Materials
    /**  
* @description : addNAPSContact
     */  
    public void addNAPSContact() {
        if (psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c != null) {
            system.debug(logginglevel.INFO, 'psCountMap.get(perSeatProducts)..' + psCountMap.get(perSeatProducts));
            for (Integer i = dspMaterials.size() + 1; i <= Integer.valueof(psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c) + olContactsSize; i++) {
                if (dspMaterials.size() < 999) {
                    addPSOnlineContactsPS();
                }
            }
            isExPSCon = False;
            // PSMaterial.quantity = psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c;    
        }
    }
/**  
* @description : displayMaterialContacts
     */  
    public void displayMaterialContacts() {
        isPerSheetSelectAll = False;
        isAddReq = False;
        // Check sap Contacts are exists and set the flag to display the Add Online Contacts buttons in the Per sheet tab
        if (olContactsSize == null || olContactsSize == 0) { isExPSCon = False;
        } else {
            isExPSCon = True;
        }
        string mtrl = '';
        for (APLIWrapper ps: dspMaterials) {
            mtrl = ps.materialNo;
            break;
        }
        if (!string.isEmpty(mtrl)) {
            materialsMap.remove(mtrl);
            for (APLIWrapper ps: dspMaterials) {
                if (materialsMap.containsKey(ps.materialNo)) {
                    materialsMap.get(ps.materialNo).add(ps);
                } else {
                    materialsMap.put(ps.materialNo, new List < APLIWrapper > {
                        ps
                    });
                }
            }
        }
        if (materialsMap.containsKey(perSeatProducts)) {
            dspMaterials.clear();
            dspMaterials = materialsMap.get(perSeatProducts);
        } else {
            dspMaterials.clear();  addPSOnlineContactsPS();
        }
        // assign the records to list based on the line item quantity for Per Seat materials         
        // display 999 rows for Retails window and Legal Hold products
        if (psCountMap.ContainsKey(perSeatProducts) && ( /*psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' ||*/
                psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'LO' ||
                psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == '51' ||
                psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'AR' ||
                psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'PS')) {
            if (olContactsSize == null || olContactsSize == 0) {  for (Integer i = dspMaterials.size() + 1; i <= 25; i++) { addPSOnlineContactsPS(); } }
            //  PSMaterial.quantity = 999;
            isAddReq = True;
        } else if (psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c != null && (olContactsSize == null || olContactsSize == 0)) {
            system.debug(logginglevel.INFO, 'psCountMap.get(perSeatProducts)..' + psCountMap.get(perSeatProducts));
            for (Integer i = dspMaterials.size() + 1; i <= Integer.valueof(psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c) + olContactsSize; i++) { addPSOnlineContactsPS(); }
            // PSMaterial.quantity = psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c;    
        }
        // get the current Per seat material quantity and Name
        fetchPerSeatMaterial();
    }
    // get the per seat material to display in the page header
    /** 
 * @description : Method to get per seat material to display in the page holder.
 */ 
    public void fetchPerSeatMaterial() {
        if (psCountMap.ContainsKey(perSeatProducts)) {
            psMaterial.quantity = psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c;
            if (isAddReq) {
                psMaterial.quantity = 999;
            }
            if (psCountMap.get(perSeatProducts).APTS_Program_ID__c != 'CPRO') {
                psMaterial.productName = perSeatProducts + ' - ' + psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name;
            } else {
                psMaterial.productName = perSeatProducts + ' - ' + psCountMap.get(perSeatProducts).APTS_Product_Name_Override__c;
            }
        }
        system.debug(logginglevel.INFO, 'PSMaterial...' + psMaterial);
    }
/** 
 * @description : method to get per sheet selected PS
 */ 
    public void getperSheetSelectedPS() {
        selectedAPLIs.clear();
        if (isPerSheetSelectAll != True) {
            for (APLIWrapper accwrapper: dspMaterials) {
                accwrapper.isSelected = False;
            }
        }

        if (isPerSheetSelectAll) { for (APLIWrapper accwrapper: dspMaterials) { accwrapper.isSelected = True; } }
        //return null;
    }
    /**  
* @description : getpspSelectedPS
 * @return : null
     */  
    public PageReference getpspSelectedPS() {
        for (APLIWrapper accwrapper: dspMaterials) {
            if (accwrapper.isSelected != true) {
                isPerSheetSelectAll = False;
            }
        }
        return null;
    }
    // method to call on Location Change from the Page
 /** 
 * @description : method locationEvent
 */    
    public void locationEvent() {
        locationChange(False);
    }
    // method to call on change of Location in the Page
    /**  
* @description : locationChange
     * @param isRedirect : isRedirect 
     * @return : isSuccess
     */  
    public Boolean locationChange(Boolean isRedirect) {
        ocList = new List < Online_Contacts__c > ();
        Boolean isProdValReq = False;
        Boolean isReqInfoFilled = False;
        Boolean isMandatory = True;
        Boolean isSuccess = True;
        isError = False;
        Integer contactsCount = 0;
        // Banded products
        // query all Online contacts for all MLA of quote to know the count of Contacts and
        if (aptProposal.APTS_MLA_Quote__c) {
            //contactsCount = [SELECT count() FROM Online_Contacts__c WHERE (QuoteId__c = :proposalId AND Account__c != null AND Account__c != :quoteAcc AND Is_Banded_Product__c = True)];
            contactsCount = [SELECT count() FROM Online_Contacts__c WHERE(QuoteId__c =: proposalId AND APTS_Source_System_Detail__c != null AND APTS_Source_System_Detail__c !=: quotessd AND Is_Banded_Product__c = True)];
        }
        // assign the Banded products Material no and product description to bandedProductsMap  
        bandedProductsMap = new Map < string, string > ();
        assignBPMap();
        for (APLIWrapper apW: totalbandedList) {
            system.debug(logginglevel.INFO, 'apW...' + apW);
            if (apW.isSelected == True) {
                isProdValReq = True;
                If(!string.isEmpty(apW.onlineContact.First_Name__c) && !string.isEmpty(apW.onlineContact.Last_Name__c) && !string.isEmpty(apW.onlineContact.Position__c)) {
                    isMandatory = False;
                }
                else {
                    isMandatory = True;
                }
                if (isBandedValidation) {
                    if (!string.isEmpty(apW.onlineContact.First_Name__c) && !string.isEmpty(apW.onlineContact.Last_Name__c) && !string.isEmpty(apW.onlineContact.Position__c) && apW.onlineContact.Type__c == 'Admin' && !string.isEmpty(apW.onlineContact.Email__c)) {
                        isReqInfoFilled = True;
                    }
                }
                assignOCtoCustomObject(apW, True);
            }
        }
        if (!isProdValReq && !totalbandedList.isEmpty()) {  
          isSuccess = False;
        }
        if (!totalbandedList.isEmpty() && isMandatory && isProdValReq) { 
          isSuccess = False;
        }
        if (!isReqInfoFilled && isBandedValidation && isProdValReq) { 
          isSuccess = False;
        }
        //system.debug(logginglevel.INFO, 'maxBandedProdQnt..'+maxBandedProdQnt);
        system.debug(logginglevel.INFO, 'ocList...' + ocList);
        // check the selected Banded product size with Max allowed Contacts
        Boolean isDetailPage = False;
        if (!ocList.isEmpty() && ocList.size() > (checkBandedSize)) {
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCExceededPasswords+' '+System.Label.OCBandedProducts));     
            isSuccess = False;
        } else if (!ocList.isEmpty() && contactsCount + ocList.size() > (checkBandedSize)) { 
          isSuccess = False;
        }
        if (isSuccess) { 
          isDetailPage = savePSContacts();
        }
        if (isDetailPage) { 
          preLocation = Location; 
          isSuccess = True;
        } else {
            location = preLocation;
            isSuccess = False;
        }
        if (!isSuccess) {
            isError = True;
        }
        return isSuccess;
    }
    // Save the Banded online contacts in Custom Object
   /**  
* @description : save
     * @return : FALSE
     */            
    public Boolean save() {

        if (locationChange(True)) { return TRUE;
        } else {
            return FALSE;
        }
    }

    // assign the Banded products Material no and product description to bandedProductsMap. used to assign the Product desc to Online Contacts before insert.
    /** 
 * @description : assign the Banded products Material no and product description to bandedProductsMap. 
 * used to assign the Product desc to Online Contacts before insert.
 */ 
    public void assignBPMap() {
        for (String str: bandedProducts) {
            bandedProductsMap.put(str.substringBefore(' '), str.substringAfter(' '));
        }

    }
/**  
* @description : assignOCtoCustomObject
     * @param apW : apW
     * @param isBanded : isBanded
     */  
    public void assignOCtoCustomObject(APLIWrapper apW, Boolean isBanded) {
        Online_Contacts__c oc = new Online_Contacts__c();
        oc.Account__c = apW.onlineContact.Account__c;
        oc.APTS_Source_System_Detail__c = apW.onlineContact.APTS_Source_System_Detail__c;
        oc.QuoteId__c = proposalId;
        oc.Material__c = apW.materialNo;
        oc.ContactID__c = apW.onlineContact.ContactID__c;
        oc.First_Name__c = apW.onlineContact.First_Name__c;
        oc.Middle_Name__c = apW.onlineContact.Middle_Name__c;
        oc.Last_Name__c = apW.onlineContact.Last_Name__c;
        oc.Email__c = apW.onlineContact.Email__c;
        oc.Position__c = apW.onlineContact.Position__c;
        oc.Type__c = apW.onlineContact.Type__c;
        oc.WLEc_Juris__c = apW.onlineContact.WLEc_Juris__c;
        //oc = apw.onlineContact;
        if (oc.Type__c == 'Admin') {
            oc.Sftwr_Admin__c = True;
        } else {
            oc.Sftwr_Admin__c = False;
        }
        if (isBanded == True) {
            oc.Is_Banded_Product__c = True;
            for (string mat: bandedMaterials.split('\n')) {
                Online_Contacts__c onlCon = new Online_Contacts__c(Account__c = oc.Account__c, APTS_Source_System_Detail__c = oc.APTS_Source_System_Detail__c, QuoteId__c = oc.QuoteId__c, Material__c = mat,
                    ContactID__c = oc.ContactID__c, First_Name__c = oc.First_Name__c, Middle_Name__c = oc.Middle_Name__c,
                    Last_Name__c = oc.Last_Name__c, Email__c = oc.Email__c, Position__c = oc.Position__c, WLEc_Juris__c = oc.WLEc_Juris__c,
                    Type__c = oc.Type__c, Is_Banded_Product__c = oc.Is_Banded_Product__c, Product_Description__c = (!bandedProductsMap.isEmpty() && bandedProductsMap.containsKey(mat)) ? bandedProductsMap.get(mat) : null);
                // onlCon.Material__c = mat;
                ocList.add(onlCon);
            }
        } else {
            oc.Product_Description__c = (!psCountMap.isEmpty() && psCountMap.containsKey(oc.Material__c)) ? psCountMap.get(oc.Material__c).Apttus_Proposal__Product__r.Name : null;
            oc.Is_Banded_Product__c = False;
            ocList.add(oc);
        }
    }
    // update the proposal line items with APTS_Online_Contacts_Validation__c = True
    /** 
 * @description : update the line items
 */ 
    public void updateLineItems() {
        apliUpdList = new List < Apttus_Proposal__Proposal_Line_Item__c > ();
        system.debug(logginglevel.INFO, 'bandedApliIds...' + bandedApliIds);
        for (Id pId: bandedApliIds) {
            Apttus_Proposal__Proposal_Line_Item__c apliRec = new Apttus_Proposal__Proposal_Line_Item__c(Id = pId, APTS_Online_Contacts_Validation__c = True);
            apliUpdList.add(apliRec);
        }

        // update the aggrement location Validation Flag
        if (aptProposal.APTS_MLA_Quote__c && !string.isEmpty(location)) {
            //APTS_Quote_Agreement_Locations__c agLoc = new APTS_Quote_Agreement_Locations__c(id = locationMap.get(quoteAcc).Id, APTS_Online_Contacts_Validation__c = True);
            APTS_Quote_Agreement_Locations__c agLoc = new APTS_Quote_Agreement_Locations__c(id = locationMap.get(quotessd).Id, APTS_Online_Contacts_Validation__c = True); Database.update(agLoc, false);
        }
        //skg moved update here
        if (!apliUpdList.isEmpty()) {
            Database.update(apliUpdList, false);
        }

    }
    // validation method for Products to fill the required fields

    // Save the online contacts in Custom Object
  /**  
* @description : savePSContacts
     * @return : TRUE
     * @return : FALSE
     */  
    public Boolean savePSContacts() {
        List < aggregateResult > results;

        try {
            // unused PageReference oPage;
            // ocList = new List<Online_Contacts__c>();            
            Set < Id > psApliIds = new Set < Id > ();
            Boolean isProdValReq = False;
            Boolean isReqInfoFilled = False;
            Boolean isWLECFilled = False;
            Boolean isProductAdded = False;
            Boolean isWLECAdded = False;
            Boolean isReqFilled = False;
            Boolean isMLA = False;
            string validationProduct = '';
            Map < string, Integer > countMap = new Map < string, Integer > ();
            // vall the below method to update the map - materialsMap with latest values of selected per seat material
            displayMaterialContacts();

            // query the all online contacts to know the count
            if (aptProposal.APTS_MLA_Quote__c) {
                //List<aggregateResult> results = [SELECT Material__c, count(Id) total FROM Online_Contacts__c WHERE (QuoteId__c = :proposalId AND Account__c != null AND Account__c != :quoteAcc AND Is_Banded_Product__c = False) Group By Material__c];
                if (Schema.sObjectType.Online_Contacts__c.isAccessible()) {
                    results = [SELECT Material__c, count(Id) total
                        FROM Online_Contacts__c
                        WHERE(QuoteId__c =: proposalId AND APTS_Source_System_Detail__c != null AND APTS_Source_System_Detail__c !=: quoteSsd AND Is_Banded_Product__c = False) Group By Material__c
                    ];
                }
                for (AggregateResult ar: results) {  countMap.put((String) ar.get('Material__c'), (Integer) ar.get('total'));
                }
            }
            string materials = '';
            for (string strKey: materialsMap.keySet()) {
                integer count = 0;
                system.debug(logginglevel.INFO, 'key..' + strKey);
                system.debug(logginglevel.INFO, 'materialsMap.get(strKey)...' + materialsMap.get(strKey));
                // Intialize the vaiables because for each per seat product need to verify the validations.
                isProdValReq = False;
                isReqInfoFilled = False;
                isWLECFilled = False;
                isProductAdded = False;
                isWLECAdded = False;
                isReqFilled = False;
                validationProduct = '';
                for (APLIWrapper wrap: materialsMap.get(strKey)) {
                    if (wrap.isSelected == True) {
                        count = count + 1;
                        isProdValReq = True;
                        if (psCountMap.ContainsKey(strKey)) {
                            psApliIds.add(psCountMap.get(strKey).Id);
                            if (!string.isEmpty(wrap.onlineContact.First_Name__c) && !string.isEmpty(wrap.onlineContact.Last_Name__c) && !string.isEmpty(wrap.onlineContact.Position__c)) {
                                isReqFilled = True;
                            } else {
                                isReqFilled = False;
                            }
                            if (!isReqFilled) {
                                validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;
                            }
                            system.debug(logginglevel.INFO, 'Brand...' + psCountMap.get(strKey).Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c);
                            if (psCountMap.get(strKey).Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '064') {
                                isProductAdded = True;
                                If(!string.isEmpty(wrap.onlineContact.First_Name__c) && !string.isEmpty(wrap.onlineContact.Last_Name__c) && !string.isEmpty(wrap.onlineContact.Position__c) && wrap.onlineContact.Type__c == 'Admin' && !string.isEmpty(wrap.onlineContact.Email__c)) {
                                    isReqInfoFilled = True;
                                }
                                if (!isReqInfoFilled) {
                                    validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;
                                }
                            }
                            if (psCountMap.get(strKey).Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '124') {
                                isWLECAdded = True;
                                if (!string.isEmpty(wrap.onlineContact.First_Name__c) && !string.isEmpty(wrap.onlineContact.Last_Name__c) && !string.isEmpty(wrap.onlineContact.Position__c) && !string.isEmpty(wrap.onlineContact.WLEc_Juris__c) && !string.isEmpty(wrap.onlineContact.Email__c)) { isWLECFilled = True;
                                }
                                if (!isWLECFilled) { validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;
                                }
                            }
                        }
                    }
                }

                if (!isProdValReq && !materialsMap.isEmpty()) { 
                  break;
                }
                if (!isReqFilled && isProdValReq) { 
                  break;
                }
                if (!isReqInfoFilled && isProductAdded && isProdValReq) { 
                  break;
                }
                if (!isWLECFilled && isWLECAdded && isProdValReq) { 
                  break;
                }
                // system.debug(logginglevel.INFO, 'Quantity...'+psCountMap.get(strKey).Apttus_Proposal__Quantity__c);
                if ((psCountMap.ContainsKey(strKey) && count > Integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c)) &&
                    ( /*psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c != '13' ||*/
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'LO' &&
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != '51' &&
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'AR' &&
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'PS')) {

                    materials = materials + psCountMap.get(strKey).Apttus_Proposal__Product__r.Name + ' ';
                    // system.debug(logginglevel.INFO, 'lower level Code...'+psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c); 
                    system.debug(logginglevel.INFO, 'materials...' + materials);
                } else if ((psCountMap.ContainsKey(strKey) && !countMap.isEmpty() && countMap.containsKey(strKey) && countMap.get(strKey) + count > Integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c)) &&
                    ( /*psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c != '13' ||*/
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'LO' &&
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != '51' &&
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'AR' &&
                        psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'PS')) {
                    isMLA = True; materials = materials + psCountMap.get(strKey).Apttus_Proposal__Product__r.Name + ' ';
                    system.debug(logginglevel.INFO, 'materials...' + materials);
                }
            }
            system.debug(logginglevel.INFO, 'isProdValReq >>' + isProdValReq);
            system.debug(logginglevel.INFO, 'materialsMap>>' + materialsMap);
            system.debug(logginglevel.INFO, 'isReqFilled >>' + isReqFilled);
            system.debug(logginglevel.INFO, 'isReqInfoFilled >>' + isReqInfoFilled);
            system.debug(logginglevel.INFO, 'isProductAdded >>' + isProductAdded);
            system.debug(logginglevel.INFO, 'isWLECFilled >>' + isWLECFilled);
            system.debug(logginglevel.INFO, 'isWLECAdded>>' + isWLECAdded);
            system.debug(logginglevel.INFO, 'materials>>' + materials);
            system.debug(logginglevel.INFO, 'isMLA>>' + isMLA);
            if (!isProdValReq && !materialsMap.isEmpty()) { 
              return False;
            }
            if (!isReqFilled && isProdValReq) { 
              return False;
            }
            if (!isReqInfoFilled && isProductAdded) { 
              return False;
            }
            if (!isWLECFilled && isWLECAdded) { 
              return False;
            }
            if (!string.isEmpty(materials) && isMLA) { 
              return False;
            } else if (!string.isEmpty(materials)) { 
              return False; 
            }
            list<APLIWrapper> mapList = new list<APLIWrapper>();
            for (List < APLIWrapper > listAWPS: materialsMap.values()) {
                mapList.addAll(listAWPS);
            }
            for (APLIWrapper apW: mapList) {
                if (apW.isSelected == True) {

                    assignOCtoCustomObject(apW, False);
                }
            }
            if (!bpListtoDel.isEmpty() || !psListtoDel.isempty()) {
                List < Online_Contacts__c > ocDelList = new List < Online_Contacts__c > ();
                ocDelList.addAll(bpListtoDel);
                ocDelList.addAll(psListtoDel);
                Database.delete(ocDelList, false);
            }
            /* if(!psListtoDel.isempty()) {
                 delete psListtoDel;
             } */
            if (!ocList.isEmpty()) {
                if (Schema.sObjectType.Online_Contacts__c.isCreateable() && Schema.sObjectType.Online_Contacts__c.isUpdateable()) {
                    upsert ocList;
                }
                // call a method to create attachment of OnlineContacts
                //onlineContactsExcel(proposalId, aptProposal.Name);
            }

            // method to update the proposal Line items
            bandedApliIds.addAll(psApliIds);
            updateLineItems();
            // call a method to create attachment of OnlineContacts
            //onlineContactsExcel(proposalId, aptProposal.Name);
            /*oPage = new PageReference('/'+proposalId);
            return oPage;*/
            return True;
        } catch (Exception ex) {
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()+Ex.getLineNumber()));     
            return False;
        }
    }
    
  
     // DLT-17212 - all attachments will now be of type File
    // Method to create a attachment with all Online Contacts
    //@Future(callout=true)
 /**  
* @description : onlineContactsExcel
     * @param proposalId : proposalId
     * @param qName : qName
     * @return : isSuccess
     */  
    public static boolean onlineContactsExcel(string proposalId, string qName) {
        boolean isSuccess = False; 
/*        
        list < Attachment > attachList;
        
        PageReference csvData = Page.OnlineContactsExport; 
        csvData.getParameters().put('id', proposalId);
        
        Attachment attach = new Attachment(); 
        attach.ContentType = 'application/pdf'; //System.Label.OCExcelContentType;
        if (!Test.isRunningTest()) {
            attach.Body = csvData.getContent();
        } else { 
          attach.Body = Blob.ValueOf('123'); 
        }
        if (Schema.sObjectType.Attachment.isAccessible()) { 
          attachList = [Select Id, Body 
                  From Attachment Where ParentId =: proposalId 
                  AND Name =: (qName + ' ' + System.Label.OCFileName) Limit 1]; 
         }
        if (attachList.isEmpty()) {
            attach.Name = qName + ' ' + System.Label.OCFileName; 
            attach.ParentId = proposalId; 
            Database.SaveResult sr = Database.insert(attach, false);
            if (sr.isSuccess()) { 
              isSuccess = TRUE; 
            }
        } else {
            for (Attachment att: attachList) { 
              att.Body = attach.Body; 
            }
            list < Database.SaveResult > sr = Database.update(attachList, false);
            if (sr[0].isSuccess()) { 
              isSuccess = TRUE;
            }
        }
*/        
    list<ContentVersion> lstContVer = new list<ContentVersion>();
    blob bPage;

        PageReference csvData = Page.OnlineContactsExport; 
        csvData.getParameters().put('id', proposalId);
        if (!Test.isRunningTest()) {
            bPage = csvData.getContent();
        } else { 
          bPage = Blob.ValueOf('123'); 
        }
        
        // check to see if this attachment already exists
        if (Schema.sObjectType.ContentVersion.isUpdateable()) { 
      // Reselect version records to get the new Document ids which were automatically created
          lstContVer = [SELECT Id, ContentDocumentId, Legacy_ParentId__c, VersionData, VersionNumber  
                          FROM ContentVersion 
                          WHERE Legacy_ParentId__c = : proposalId         
                          AND Title =: (qName + ' ' + System.Label.OCFileName) Limit 1];                 
        }
        if (lstContVer.isEmpty()) {
            // build a Content Version record 
            ContentVersion contVer = new ContentVersion();
            contVer.ContentLocation = 'S';
            contVer.VersionData = bPage; 
            contVer.IsMajorVersion = false;
            contVer.Title = String.valueOf(qName + ' ' + System.Label.OCFileName);
            contVer.Legacy_ParentId__c = proposalId; // use this field to tie the content version to the proposal
            contVer.PathOnClient = String.valueOf(qName + ' ' + System.Label.OCFileName);
      // insert content version and build link file                
            insertContentVersion(contVer);      
        } else {
          // update existing file
          lstContVer[0].VersionData = bPage;
          //lstContVer[0].VersionNumber = lstContVer[0].VersionNumber + 1;
          update lstContVer;
        }
        return isSuccess;
    }
    
    
    // This method creates ContentVersion/ContentDocument records.  
    // ContentDocumentLink records also need to be created to link the file to the quote    
    private static void insertContentVersion(ContentVersion contVer) {
    list<ContentVersion> lstContVer = new list<ContentVersion>();
        set<string> setContVerIds = new set<string>();
        Database.SaveResult[] lsr;

        system.debug(logginglevel.INFO, 'OnlineContactExcel - insert Content Version records: ' + contVer);
        
        if (!Schema.sObjectType.ContentVersion.isCreateable() || !Schema.sObjectType.ContentDocumentLink.isCreateable()) {
            throw new DCCustomException(UserInfo.getName() + ' does not have access to create: Content objects');
        }
        lstContVer.add(contVer);
        // Insert version records - this will automatically create a content documents record which we need to add 
        // to the content document link records we are creating                      
        //insert lstContVer;
        lsr =  Database.insert(lstContVer, false);
        if (lsr != null && lsr.size() > 0) {
            for (Integer i = 0; i < lsr.size(); i++) {
                if (lsr.get(i).isSuccess()) {
                  setContVerIds.add(lsr.get(i).getId());
/*                  
                } else if (!lsr.get(i).isSuccess()) {
                  // DML operation failed
                    Database.Error error = lsr.get(i).getErrors().get(0);
                    String addInfo;
                  Digital_Exception_Log__c ex = createExceptionLog(
                        error.getMessage(), 
                        'PostAcceptAttachment - Quote Id - ' + lstContVer.get(i).Legacy_ParentId__c,
                        addInfo, 
                        String.Valueof(error.getStatusCode()), 
                        'Digital_PostAcceptAttachment > Create File Attachment',
                        '', //CARTOBJ, 
                        lstContVer.get(i).Id
                    );
                    exList.add(ex);
*/                    
                }
          } // end for loop        
    } // end if
    
    // insert the content document link records
    insertContDocLink(setContVerIds);
    }
    

  // insert the Content Document Link Records
  private static void insertContDocLink(set<string> setContVerIds) {
    list<ContentDocumentLink> lstContLink = new list<ContentDocumentLink>();
            
    // Reselect version records to get the new Document ids which were automatically created
        for (ContentVersion oContVer : [SELECT Id, ContentDocumentId, Legacy_ParentId__c  
                          FROM ContentVersion 
                          WHERE id IN : setContVerIds]) {
            // create linking Content Document record 
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = oContVer.ContentDocumentId;
            cdl.LinkedEntityId = oContVer.Legacy_ParentId__c; //APTS_Custom_Quote_Proposal__c;
            system.debug(logginglevel.INFO, 'Document Quote ID : ' + cdl.LinkedEntityId);
            cdl.ShareType = 'V';
            lstContLink.add(cdl);
        }
        // insert content link records
        insert lstContLink;
    
  }
    /** 
 * @description : // Cancel Method to navigate to Proposal.
 * @return : page refererence pr
 */ 
    public PageReference cancel() {
        PageReference pr = new PageReference('/' + proposalId);
        return pr;
    }

    // Wrapper Class
    /** 
 * @description : APIWrapper, is a wrapper class with multiple methods nested
 */ 
    public class APLIWrapper {
        /** 
 * @description : Method is selected, returns a boolean value
 */ 
        public Boolean isSelected {
            get;
            set;
        }
        /** 
 * @description : Method materialNO
 */ 
        public string materialNo {
            get;
            set;
        }
        /** 
 * @description : methos online contact
 */ 
        public Online_Contacts__c onlineContact {
            get;
            set;
        }
        /** 
 * @description : Method is new contact, returns a boolean value
 */ 
        public Boolean isNewContact {
            get;
            set;
        }
        /** 
 * @description : Method source
 */ 
        public string source {
            get;
            set;
        }
        /** 
 * @description : API Wrapper
 */ 
  
        public APLIWrapper() {
            isSelected = False;
            materialNo = '';
            onlineContact = new Online_Contacts__c();
            isNewContact = False;
            source = '';
        }
    }
    
// per Sheet materials wrapper
    /** 
 * @description : Class PS materials contains multiple methods
 */ 
    public class PSMaterials {
        /** 
 * @description : Method quantity
 */ 
        public Decimal quantity {
            get;
            set;
        }
 /** 
 * @description : Method product name
 */ 
        public string productName {
            get;
            set;
        }
/** 
 * @description : Method PSMaterials
 */ 
        public PSMaterials() {
            quantity = null;
            productName = '';
        }
    }
    
}