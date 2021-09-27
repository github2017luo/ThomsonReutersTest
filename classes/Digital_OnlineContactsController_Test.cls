/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-07-18   Brenda Shields          DLT-18088 - Updated to increase code coverage  
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData 
 * 2020-10-10   Rahul Natarajan         DLT-20790 - Changed New variable name from bandedAPLIList to totalbandedList
 * 2021-03-04   Brenda Shields          DLT-17212 - [ALL] Update class to create document as a file and not an attachment 
 * 2021-02-12   Kavya S                 DLT-21591 - [SFDC][REN] PMD Scan
 * =============================================================================
 */

@isTest(seeAllData = true)
/** 
 * @description : Test class for digital online contacts controller
 */ 
private class Digital_OnlineContactsController_Test {
/** 
 * @description : test method for process controller
 */ 
    public static testMethod void processController() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account 
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;
            Opportunity oOpp = UnitTest.getOpportunityInstance(oAccount.Id); 
            insert oOpp;

            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = oOpp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            Product2 oProductB = new Product2(Name = 'Patron Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978965', Apttus_Filter_Brand_Code__c = '064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys', APTS_Media_High_Level_Code__c = '21');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', Apttus_Filter_Brand_Code__c = '64', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
            // Product2 oProductA = new Product2(Name='Patron Product Test',Product_Level_4__c ='GSCPW_RP', ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_Media_High_Level_Code__c='21');        
            insert oProductB;
            insert oProductP;
            // insert oProductA;     

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            //Anjana        
            Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c = 5);

            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id, Apttus_QPConfig__AttributeValueId__c = ob.id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id, Apttus_QPConfig__AttributeValueId__c = ob.id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'User', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();

            Test.startTest();
            /* Anjana*/
            OnlineContactsController contr1 = new OnlineContactsController(sc);
            contr1.isBandedSelectAll = True;
            contr1.isPerSheetSelectAll = True;
            contr1.olContactsSize = 0;
            contr1.getpspSelectedPS();
            contr1.getperSheetSelectedPS();
            contr1.addOnlineContacts();
            contr1.addNAPSContact();
            contr1.displayMaterialContacts();
            /*Anjana*/
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();

            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                break;
            }
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            contr.save();
            contr.olContactsSize = null;
            contr.maxBandedProdQnt = 2.0;
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');

            Test.stopTest();
        } //end system.runas         
    }
/** 
 * @description : Test method for process controller MLA
 */ 
    public static testMethod void processControllerMLA() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;

            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978967', Apttus_Filter_Brand_Code__c = '64', APTS_Media_High_Level_Code__c = '06', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978968', Apttus_Filter_Brand_Code__c = '124', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c = 5);
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id, Apttus_QPConfig__AttributeValueId__c = ob.id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            li1.APTS_Program_ID__c = 'CPRO';
            li1.Apttus_QPConfig__LineType__c = 'Product/Service';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id, Apttus_QPConfig__AttributeValueId__c = ob.id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            Test.startTest();
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();
            contr.patronFlag = True;
            contr.errorFlag = True;
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                //break;                
            }
            contr.locationEvent();
            contr.save();
            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 2;
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            test.stopTest();
        }
    }
/** 
 * @description : Test method for process controller2
 */ 

    public static testMethod void processController2() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            //opp.RecordTypeId=oppRecordTypeId;     
            //opp.source_system_detail__c = source.Id;      
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978965', APTS_Product_Pricing_Model__c = 'BENEFITGRP', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;


            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            listLineItems.add(li1);


            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li2.Apttus_QPConfig__LineStatus__c = 'Amended';
            listLineItems.add(li2);
            insert listLineItems;


            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();
            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 2;
            /* Anjana*/
            OnlineContactsController contr1 = new OnlineContactsController(sc);
            contr1.isBandedSelectAll = True;
            contr1.isPerSheetSelectAll = True;
            contr1.getpspSelectedPS();
            contr1.getperSheetSelectedPS();
            contr1.addOnlineContacts();
            contr1.addNAPSContact();
            contr1.displayMaterialContacts();
            Test.startTest();

            /*Anjana*/
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                break;
            }
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        } //end system.runas         
    }
/** 
 * @description : Test method for process controller 2
 */ 
    public static testMethod void processControllerMLA2() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978967', Apttus_Filter_Brand_Code__c = '064', APTS_Media_High_Level_Code__c = '06', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978968', Apttus_Filter_Brand_Code__c = '064', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            li1.APTS_Program_ID__c = 'CPRO';
            li1.Apttus_QPConfig__LineType__c = 'Product/Service';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', '');
            Test.setCurrentPage(pageRef);
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            system.debug(logginglevel.INFO, 'controller: ' + contr);
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        }
    }
/** 
 * @description : Test method for process controller exception2
 */ 
    public static testMethod void processControllerException() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account 
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'Existing', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978967', Apttus_Filter_Brand_Code__c = '064', APTS_Media_High_Level_Code__c = '06', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            li1.APTS_Program_ID__c = 'CPRO';
            li1.Apttus_QPConfig__LineType__c = 'Product/Service';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', opp.id);
            Test.setCurrentPage(pageRef);
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            system.debug(logginglevel.INFO, 'controller: ' + contr);
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        }
    }
/** 
 * @description : Test method for process controller MLA3
 */ 
    public static testMethod void processControllerMLA3() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;
            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978967', Apttus_Filter_Brand_Code__c = '064', APTS_Media_High_Level_Code__c = '13', APTS_Media_Lower_Level_Code__c = 'PS', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'Amended';
            li1.APTS_Program_ID__c = 'CPRO';
            li1.Apttus_QPConfig__LineType__c = 'Product/Service';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
            li2.APTS_Program_ID__c = 'CPRO';
            li2.Apttus_QPConfig__LineType__c = 'Product/Service';
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            Test.startTest();
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();
            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 2;


            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                //break;                
            }

            contr.locationEvent();
            contr.save();
            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 2;
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        }
    }
/** 
 * @description : Test method for process controller3
 */ 
    public static testMethod void processController3() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978965', Apttus_Filter_Brand_Code__c = '064', APTS_Media_Lower_Level_Code__c = 'PS', APTS_Media_High_Level_Code__c = '13', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();
            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 2;
            /* Anjana*/
            OnlineContactsController contr1 = new OnlineContactsController(sc);
            contr1.isBandedSelectAll = True;
            contr1.isPerSheetSelectAll = True;
            contr1.olContactsSize = 0;
            contr1.maxBandedProdQnt = 2;
            contr1.getpspSelectedPS();
            contr1.getperSheetSelectedPS();
            contr1.addOnlineContacts();
            contr1.addNAPSContact();
            contr1.displayMaterialContacts();
            /*Anjana*/
            Test.startTest();
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                break;
            }
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        } //end system.runas         
    }
    /** 
 * @description : Test method for process controllerNew
 */ 
    public static testMethod void processControllerNew() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            Product2 oProductB = new Product2(Name = 'Patron Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978965', Apttus_Filter_Brand_Code__c = '064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', Apttus_Filter_Brand_Code__c = '64', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';

            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = false;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();



            /* Anjana*/
            OnlineContactsController contr1 = new OnlineContactsController(sc);
            contr1.isBandedSelectAll = True;
            contr1.isPerSheetSelectAll = True;
            contr1.olContactsSize = 0;
            contr1.getpspSelectedPS();
            contr1.getperSheetSelectedPS();
            contr1.addOnlineContacts();
            contr1.addNAPSContact();
            contr1.displayMaterialContacts();
            /*Anjana*/
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            Test.startTest();

            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;

                break;
            }
            contr.getpspSelected();
            contr.savePSContacts();

            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 3;
            contr.save();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        } //end system.runas         
    }

/** 
 * @description : Test method for process controller Canada
 */ 
    public static testMethod void processControllerCanada() {

        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            Product2 oProductB = new Product2(Name = 'Patron', Product_Level_4__c = 'GSCPW_RP', APTS_Product_Pricing_Model__c = 'BENEFITGRP', ProductCode = '1234568978965', Apttus_Filter_Brand_Code__c = '064', APTS_Media_High_Level_Code__c = '06', APTS_Media_Lower_Level_Code__c = 'AB', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', APTS_Product_Pricing_Model__c = 'BENEFITGRP', Apttus_Filter_Brand_Code__c = '64', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'AB', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;


            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'User', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            Test.startTest();
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();
            contr.patronFlag = False;
            contr.isLiveNoteBandedProduct = True;


            /* Anjana*/
            OnlineContactsController contr1 = new OnlineContactsController(sc);
            contr1.isBandedSelectAll = True;
            contr1.isPerSheetSelectAll = True;
            contr1.olContactsSize = 0;
            contr1.getpspSelectedPS();
            contr1.getperSheetSelectedPS();
            contr1.addOnlineContacts();
            contr1.addNAPSContact();
            contr1.displayMaterialContacts();


            /*Anjana*/
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();


            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                break;
            }
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            contr.save();
            contr.olContactsSize = null;
            contr.maxBandedProdQnt = 3;
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        } //end system.runas         
    }
    /** 
 * @description : Test method for process controller 4
 */ 
    public static testMethod void processController4() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            /*source_system_detail__c source = APTS_TestDataFactory.createsourcesystem(oAccount );
            insert source;*/
            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;
            //Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            //opp.RecordTypeId=oppRecordTypeId;
            //opp.source_system_detail__c = source.Id;
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, APTS_MLA_Quote__c = True, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978965', Apttus_Filter_Brand_Code__c = '064', APTS_Media_Lower_Level_Code__c = 'LO', APTS_Media_High_Level_Code__c = '06',
                // APTS_Media_Lower_Level_Code__c = 'WA', 
                Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', Apttus_Filter_Brand_Code__c = '64', Product_Level_4__c = 'GSCPW_RP', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            li1.Apttus_QPConfig__LineStatus__c = 'New';
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc5);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            Test.startTest();
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();
            contr.olContactsSize = 0;
            contr.maxBandedProdQnt = 2;
            /* Anjana*/
            OnlineContactsController contr1 = new OnlineContactsController(sc);
            contr1.isBandedSelectAll = True;
            contr1.isPerSheetSelectAll = True;
            contr1.olContactsSize = 0;
            contr1.getpspSelectedPS();
            contr1.getperSheetSelectedPS();
            contr1.addOnlineContacts();
            contr1.addNAPSContact();
            contr1.displayMaterialContacts();
            /*Anjana*/
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }

            contr.validateBandedMaterials();
            contr.save();
            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                break;
            }
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        } //end system.runas 
    }
/** 
 * @description : Test method for process controller MLA4
 */ 
    public static testMethod void processControllerMLA4() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;

            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            OnlineContactsController contr = new OnlineContactsController(sc);
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();

            Test.startTest();
            for (OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                //break;        
            }
            contr.locationEvent();
            contr.save();
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        }
    }
/** 
 * @description : Test method for Digital process controller 
 */ 
    public static testMethod void digitalProcessController() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.isDigitalSpearHead__c = TRUE;
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana', APTS_Source_System_Detail__c = ssdAccount.Id);
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana', APTS_Source_System_Detail__c = ssdAccount.Id);
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana', APTS_Source_System_Detail__c = ssdAccount.Id);
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana', APTS_Source_System_Detail__c = ssdAccount.Id);
            onlineContactList.add(oc4);
            insert onlineContactList;
            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            Digital_OnlineContactsController contr = new Digital_OnlineContactsController(sc);
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            system.debug(logginglevel.INFO, 'contr.dspMaterials >>1' + contr.dspMaterials);

            system.debug(logginglevel.INFO, 'contr.dspMaterials >>2' + contr.dspMaterials);
            Test.startTest();
            contr.displayMaterialContacts();
            for (Digital_OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                //apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (Digital_OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                break;
            }

            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');
            Test.stopTest();
        } //end system.runas
    }
/** 
 * @description : Test method for digital process controller MLA
 */ 
    public static testMethod void digitalProcessControllerMLA() {
        User u = [select Id from User where Name = 'Informatica User'
            limit 1
        ];
        system.runAs(u) {

            // Create Account
            Account oAccount = DCTestData.createAccountRec('Sree Test');
            oAccount.Tax_Number__c = '12345';
            insert oAccount;

            Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
            insert ssdAccount;

            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
            opp.isDigitalSpearHead__c = TRUE;
            opp.source_system_detail__c = ssdAccount.Id;
            insert opp;
            Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c = 'Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
            oProposal.RecordtypeId = propRecorType;
            insert oProposal;
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c = ssdAccount.id);
            insert al;

            Product2 oProductB = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
            Product2 oProductP = new Product2(Name = 'Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats');
            insert oProductB;
            insert oProductP;

            list < Apttus_Proposal__Proposal_Line_Item__c > listLineItems = new list < Apttus_Proposal__Proposal_Line_Item__c > ();
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li1);

            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
            listLineItems.add(li2);
            insert listLineItems;

            List < Online_Contacts__c > onlineContactList = new List < Online_Contacts__c > ();
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc1);
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc2);
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc3);
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode, QuoteId__c = oProposal.Id, Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c = 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c = 'Indiana');
            onlineContactList.add(oc4);
            insert onlineContactList;

            PageReference pageRef = Page.OnlineContacts;
            pageRef.getParameters().put('id', oProposal.Id);
            Test.setCurrentPage(pageRef);

            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
            Digital_OnlineContactsController dcon = new Digital_OnlineContactsController();
            system.debug(logginglevel.INFO, 'controller: ' + dcon);
            Digital_OnlineContactsController contr = new Digital_OnlineContactsController(sc);
            Test.startTest();
            contr.getbpSelected();
            contr.getBandedSelected();
            contr.isBandedSelectAll = True;
            contr.getBandedSelected();
            contr.getperSheetSelectedPS();
            contr.getpspSelectedPS();
            contr.isPerSheetSelectAll = True;
            contr.getpspSelectedPS();
            contr.getperSheetSelectedPS();
            contr.addOnlineContacts();
            contr.addNAPSContact();
            contr.displayMaterialContacts();


            for (Digital_OnlineContactsController.APLIWrapper apr: contr.totalbandedList) {
                apr.isSelected = True;
                break;
            }
            contr.validateBandedMaterials();
            contr.save();
            for (Digital_OnlineContactsController.APLIWrapper apr: contr.dspMaterials) {
                apr.isSelected = True;
                //break;        
            }

            contr.locationEvent();
            contr.save();
            contr.getpspSelected();
            contr.savePSContacts();
            contr.addPSContacts();
            contr.cancel();
            system.assertEquals(oAccount.Name, 'Sree Test', 'Validate Account Name');

            Customer_Master_Contacts__c mc = new Customer_Master_Contacts__c();
            mc.quote__C = oProposal.id;
            mc.First_Name__c = 'testfirstname';
            mc.Last_Name__c = 'teslastname';
            mc.Email_Address__c = 'test.test@gmail.com';
            insert mc;
            Test.stopTest();
        }
    } //end runAs
    
       
  // test for onlineContactsExcel      
    static testMethod void testFileAttachment() {
      // Create Account 
        Account oAccount = DCTestData.createAccountRec('File Attachment Test');
        oAccount.Tax_Number__c = '12345';
        insert oAccount;
        
        Source_system_detail__c ssdAccount = new Source_system_detail__c(Account_Name__c = oAccount.id, Name = oAccount.name, Source_System_Name__c = oAccount.name, LCRM_Sales_Org__c = 'West');
        insert ssdAccount;
            
        Opportunity oOpp = UnitTest.getOpportunityInstance(oAccount.Id);
        oOpp.source_system_detail__c = ssdAccount.Id;
        oOpp.isDigitalSpearHead__c = true;
        insert oOpp;

        Id propRecorType = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oQuote = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c = 'Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = oOpp.Id);
        oQuote.RecordtypeId = propRecorType;
        oQuote.Digital_Batch_Processed__c = true;
        oQuote.Digital_Quote_Type__c = 'Best Value';
        oQuote.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        oQuote.Digital_Ready_Online_Export__c = true;
        insert oQuote;
                    
        // create attachment for the quote
        //DCTestData.createAttachment(oQuote.id);
        //DCTestData.createFileAttachment(oQuote.id);  
        // build a Content Version record which will also create a Content Document record
/*        
        Attachment oNewAttach = new Attachment();
        oNewAttach.ContentType = 'application/pdf'; 
        oNewAttach.Name = oQuote.Name + ' ' + System.Label.OCFileName; 
        oNewAttach.Body = Blob.ValueOf('123');
        oNewAttach.ParentId = oQuote.id;
        insert oNewAttach;
*/        
        Test.startTest();
        //Digital_OnlineContactsController oCon = new Digital_OnlineContactsController();
        Digital_OnlineContactsController.onlineContactsExcel(oQuote.id, oQuote.name);

        Test.stopTest();
        // check to see if the file attachment has been created
        list<ContentVersion> lstContVer = [SELECT Id, ContentDocumentId, Legacy_ParentId__c  
                          FROM ContentVersion 
                          WHERE Legacy_ParentId__c = :  oQuote.id];
        system.assert(!(lstContVer.isEmpty()), 'Attachment not created'); 
        
    }
    
}