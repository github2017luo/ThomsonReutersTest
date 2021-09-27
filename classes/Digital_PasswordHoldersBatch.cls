/* CHANGE HISTORY
==================================================================================================================================
Date            Name                    Description
2018-06-14      Srikanth Kota           DLT-9757 - APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
2018-07-07      Srikanth Kota           DLT-10513 - If OLC returns null users, automation should assign  Master Contact to all Password Holder(using OCC).
2019-10-16      Srikanth kota           DLT-17812 - Digital_PasswordHoldersBatch class is failing with "First error: Too many DML rows: 10001
2019-11-20      Harika Sai P            DLT-18184 - Due to "APTS_Contact_Validation_Flag__c" flag , Corp multi-offer option products proposals are struck in draft status.
2020-03-31      Benjamin Her            DLT-19620 - Password Holders not getting created
2020-10-10      Rahul Natarajan         DLT-20790 - Changed New variable name from bandedAPLIList to totalbandedList
==================================================================================================================================   
*/

global class Digital_PasswordHoldersBatch implements Database.Batchable < Apttus_Proposal__Proposal__c > , Database.AllowsCallouts {

    global static list < Apttus_Proposal__Proposal__c > proposalList = new list < Apttus_Proposal__Proposal__c > ();
    global static Digital_OnlineContactsController.APLIWrapper emptyAPLIWrapper = new Digital_OnlineContactsController.APLIWrapper();
    global static Set < id > finalPropol = new Set < id > ();

    global Iterable < Apttus_Proposal__Proposal__c > start(database.batchablecontext BC) {
        //DLT-17812 updated with APTS_Contact_Validation_Flag__c where only pick which has Password Holders/Master Validation Messages.
        proposalList = [select id, name, Digital_Ready_Online_Export__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_MLA_Quote__c, (select First_Name__c, Last_Name__c, Email_Address__c, Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c from Customer_Master_Contacts__r) from Apttus_Proposal__Proposal__c where is_Digital_Channel__c = TRUE AND Digital_Batch_Processed__c = TRUE AND APTS_Validation_Messages__c != Null AND Digital_Quote_Type__c IN('Best Value', 'Best Value+Config', 'Premium') AND APTS_Order_Confirmation_Contact_Email__c != Null AND Apttus_Proposal__Approval_Stage__c IN('Draft', 'Approved') AND ID IN(select Quote__C from Customer_Master_Contacts__c) AND APTS_SSD_Sold_To__c != NULL AND APTS_Contact_Validation_Flag__c != True];
        //proposalList =[select id,name,Digital_Ready_Online_Export__c,APTS_SSD_Sold_To__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,Apttus_Proposal__Account__c,Apttus_Proposal__Account__r.SAPAccountNumber__c,APTS_MLA_Quote__c,(select First_Name__c,Last_Name__c,Email_Address__c,Quote__c,Material__c,Quote__r.Apttus_Proposal__Account__c from Customer_Master_Contacts__r) from Apttus_Proposal__Proposal__c where id IN ('a4N0m0000005wTKEAY')];

        return proposalList;
    }
    global void execute(Database.BatchableContext bc, List < Apttus_Proposal__Proposal__c > scope) {
        System.debug('scope==>' + scope);

        try {
            passwordHolderHelper(scope);
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();
            ex.Additional_Information__c = String.valueof(e.getLineNumber());
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_PasswordHoldersBatch > Execute';
            insert ex;
        }

    }

    public static void passwordHolderHelper(list < Apttus_Proposal__Proposal__c > scope) {

        List < Online_Contacts__c > onlineContacts = new List < Online_Contacts__c > ();
        Set < id > noSfolcPropol = new Set < id > ();

        noSfolcPropol = Digital_SmartMatching.getEntitlements(scope);
        System.debug('noSfolcPropol=========>' + noSfolcPropol);
        if (Test.isRunningTest()) {
            Digital_AddPasswordHolderProcess.getOrderOnlineContact(scope);
            noSfolcPropol = Digital_AddPasswordHolderProcess.getnoSfOlcPropalID();
        }
        List < Online_Contacts__c > newsfOLClist = new List < Online_Contacts__c > (Digital_AddPasswordHolderProcess.getnewOLClist());
        System.debug('onlineContacts====>' + onlineContacts);
        System.debug('noSfolcPropol==>' + noSfolcPropol);
        onlineContacts.addAll(newsfOLClist);
        System.debug('onlineContacts====>' + onlineContacts);
        // If No Online Contacts in SF Get use Services Active Contacts and Map it.
        system.debug('newsfOLClist==>' + newsfOLClist);

        Map < string, Map < string, Decimal >> proplineQuantMap = new Map < string, Map < string, Decimal >> ();
        list < Apttus_Proposal__Proposal__c > noSfolcPropList = [select id, name, Digital_Ready_Online_Export__c, APTS_SSD_Sold_To__c, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_MLA_Quote__c, (select First_Name__c, Last_Name__c, Email_Address__c, Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c, Quote__r.APTS_SSD_Sold_To__c from Customer_Master_Contacts__r) from Apttus_Proposal__Proposal__c where id IN: noSfolcPropol];
        proplineQuantMap.putAll(upSellobjct(noSfolcPropList));

        for (Apttus_Proposal__Proposal__c proposal: noSfolcPropList) {

            ApexPages.StandardController scon = new ApexPages.StandardController(proposal);
            Digital_OnlineContactsController oCon = new Digital_OnlineContactsController(scon);

            system.debug('oCon==>' + oCon);
            System.debug('totalbandedList==>' + oCon.totalbandedList);
            System.debug('perSheetAPLIList==>' + oCon.perSheetAPLIList);
            System.debug('selectedAPLIs==>' + oCon.selectedAPLIs);
            System.debug('apliWrapper==>' + oCon.apliWrapper);
            System.debug('apliWrapper==>' + oCon.cmocMap);
            System.debug('apliWrapper==>' + oCon.dspMaterials);

            if (oCon != Null && oCon.totalbandedList.size() > 0 || oCon.perSheetAPLIList.size() > 0) {

                //Adds online contacts for banded product
                onlineContacts.addAll(getBandedOnlineContacts(proposal, oCon));

                //Add online contacts for per seat product
                onlineContacts.addAll(getPerSeatOnlineContacts(proposal, oCon, proplineQuantMap));

            } else {

                //Add online contacts from master contacts
                onlineContacts.addAll(getOnlineContactFromMasterContact(proposal));

            }

            System.debug('oCon.totalbandedList==> .. ' + oCon.totalbandedList);
            System.debug('oCon.dspMaterials==> .. ' + oCon.dspMaterials);
            System.debug('oCon.psProductsList==> .. ' + oCon.psProductsList);

        }
        System.debug('onlineContacts====>' + onlineContacts);
        if (onlineContacts.size() > 0) {
            System.debug('onlineContacts====>' + onlineContacts);
            // onlineContacts.addAll(newsfOLClist);
            System.debug('onlineContacts====>' + onlineContacts);
            olcCreation(onlineContacts);
            System.debug('finalPropol====>' + finalPropol);
            proposalList.addAll([select id, name, Digital_Ready_Online_Export__c, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_MLA_Quote__c, (select First_Name__c, Last_Name__c, Email_Address__c, Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c from Customer_Master_Contacts__r) from Apttus_Proposal__Proposal__c where id IN: finalPropol]);
        }
        System.debug('proposalList====>' + proposalList);
        updateTempField(proposalList);
    }

    //gets online contact from master contact
    public static List < Online_Contacts__c > getOnlineContactFromMasterContact(Apttus_Proposal__Proposal__c proposal) {

        System.debug('proposal.Customer_Master_Contacts__r===>' + proposal.Customer_Master_Contacts__r);

        List < Online_Contacts__c > onlineContacts = new List < Online_Contacts__c > ();

        for (Customer_Master_Contacts__c mcon: proposal.Customer_Master_Contacts__r) {

            List < String > newSubnumber = mcon.Material__c.split(',');
            for (String Material: newSubnumber) {
                System.debug('mcon===>' + mcon);
                Online_Contacts__c tempOLCMastCon = new Online_Contacts__c();
                tempOLCMastCon.First_Name__c = mcon.First_Name__c;
                tempOLCMastCon.Last_Name__c = mcon.Last_Name__c;
                tempOLCMastCon.Email__c = mcon.Email_Address__c;
                tempOLCMastCon.Type__c = 'Admin';
                tempOLCMastCon.Position__c = 'Attorney';
                system.debug('Material If::' + Material);
                if (Material != 'null' && Material != null && Material != '') { //DLT-18184 start
                    system.debug('Material::' + Material);
                    tempOLCMastCon.Is_Banded_Product__c = isBandedProduct(Material);
                } //DLT-18184 ends
                else {
                    system.debug('Material Else::' + Material);
                    tempOLCMastCon.Is_Banded_Product__c = false;
                }
                tempOLCMastCon.QuoteId__c = mcon.Quote__c;
                tempOLCMastCon.Account__c = mcon.Quote__r.Apttus_Proposal__Account__c;
                tempOLCMastCon.APTS_Source_System_Detail__c = mcon.Quote__r.APTS_SSD_Sold_To__c;
                //tempOLCMastCon.Material__c = mcon.Material__c.substringBefore(',');
                tempOLCMastCon.Material__c = Material;
                System.debug('proposal.tempOLCMastCon===>' + tempOLCMastCon);
                onlineContacts.add(tempOLCMastCon);

            }
        }

        return onlineContacts;
    }

    //gets online contact for banded product
    public static List < Online_Contacts__c > getBandedOnlineContacts(Apttus_Proposal__Proposal__c proposal, Digital_OnlineContactsController oCon) {

        List < Online_Contacts__c > onlineContacts = new List < Online_Contacts__c > ();

        //Added Banded form Services 
        for (Digital_OnlineContactsController.APLIWrapper apli: oCon.totalbandedList) {
            List < Online_Contacts__c > tempOLCBanded = new List < Online_Contacts__c > ();
            tempOLCBanded.add(apli.onlineContact);
            for (Online_Contacts__c oLCb: tempOLCBanded) {
                oLCb.Is_Banded_Product__c = TRUE;
                oLCb.QuoteId__c = proposal.id;
                oLCb.APTS_Source_System_Detail__c = proposal.APTS_SSD_Sold_To__c;
                oLCb.Account__c = proposal.Apttus_Proposal__Account__c;
                onlineContacts.add(oLCb);
            }
        }
        return onlineContacts;
    }

    //gets online contact for per seat product
    public static List < Online_Contacts__c > getPerSeatOnlineContacts(Apttus_Proposal__Proposal__c proposal, Digital_OnlineContactsController oCon, Map < string, Map < string, Decimal >> proplineQuantMap) {

        List < Online_Contacts__c > onlineContacts = new List < Online_Contacts__c > ();
        Set < string > exConID = new Set < string > ();
        Set < string > exProdID = new Set < string > ();

        for (Digital_OnlineContactsController.APLIWrapper apli: oCon.perSheetAPLIList) {

            List < Online_Contacts__c > tempOLCPerSeat = new List < Online_Contacts__c > ();
            tempOLCPerSeat.add(apli.onlineContact);
            for (Online_Contacts__c oLCp: tempOLCPerSeat) {

                if (!exProdID.contains(oLCp.Material__c)) {
                    exConID.clear();
                }
                oLCp.Is_Banded_Product__c = FALSE;
                oLCp.QuoteId__c = proposal.id;
                oLCp.APTS_Source_System_Detail__c = proposal.APTS_SSD_Sold_To__c;
                oLCp.Account__c = proposal.Apttus_Proposal__Account__c;
                System.debug('proplineQuantMap==>' + proplineQuantMap);
                System.debug('proposalId=========>' + proplineQuantMap.get(proposal.id));
                System.debug('Material__c==>' + proplineQuantMap.get(proposal.id).get(oLCp.Material__c));
                if (!exConID.contains(oLCp.ContactID__c) && (proplineQuantMap.get(proposal.id).get(oLCp.Material__c).intValue() > exConID.size())) {
                    onlineContacts.add(oLCp);
                    exConID.add(oLCp.ContactID__c);
                    exProdID.add(oLCp.Material__c);
                } else {
                    break;
                }
            }
        }

        return onlineContacts;
    }

    public static void updateTempField(list < Apttus_Proposal__Proposal__c > qList) {
        //Copyied from Digital_OnlineContactsController to Run Online Contacts Validation
        List < Apttus_Proposal__Proposal_Line_Item__c > apliUpdList = new List < Apttus_Proposal__Proposal_Line_Item__c > ();
        List < Apttus_Proposal__Proposal_Line_Item__c > aplinItermdList = new List < Apttus_Proposal__Proposal_Line_Item__c > ();
        List < APTS_Quote_Agreement_Locations__c > agLocList = new List < APTS_Quote_Agreement_Locations__c > ();
        List < APTS_Quote_Agreement_Locations__c > agLocUpList = new List < APTS_Quote_Agreement_Locations__c > ();
        List < Apttus_Proposal__Proposal__c > qUpList = new List < Apttus_Proposal__Proposal__c > ();

        System.debug('qList====>' + qList);
        system.debug('aplinItermdList==>' + aplinItermdList);
        Set < Id > psApliIds = new Set < Id > ();

        for (Apttus_Proposal__Proposal__c proposallistID: qList) {
            psApliIds.add(proposallistID.id);

        }

        aplinItermdList = [Select Id, Name, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, APTS_Online_Contacts_Validation__c From Apttus_Proposal__Proposal_Line_Item__c Where Apttus_Proposal__Proposal__c =: psApliIds];
        agLocList = [Select Id, APTS_Subscriber_Location__c, APTS_Subscriber_Location__r.Name, APTS_Subscriber_Location__r.SAPAccountNumber__c, APTS_Subscriber_Location__r.External_Trial_Account_ID__c, APTS_Status__c From APTS_Quote_Agreement_Locations__c Where APTS_Quote_Proposal__c =: psApliIds and APTS_Status__c IN('New', 'Existing')];
        System.debug('aplinItermdList====>' + aplinItermdList);
        System.debug('agLocList====>' + agLocList);
        for (Apttus_Proposal__Proposal_Line_Item__c pId: aplinItermdList) {
            Apttus_Proposal__Proposal_Line_Item__c apliRec = new Apttus_Proposal__Proposal_Line_Item__c(Id = pId.id, APTS_Online_Contacts_Validation__c = True);
            apliUpdList.add(apliRec);
        }
        Database.update(apliUpdList, false);

        for (APTS_Quote_Agreement_Locations__c agAccLocID: agLocList) {
            APTS_Quote_Agreement_Locations__c agLoc = new APTS_Quote_Agreement_Locations__c(Id = agAccLocID.Id, APTS_Online_Contacts_Validation__c = True);
            agLocUpList.add(agLoc);
        }
        Database.update(agLocUpList, false);

        // Old Code update only Digital_Ready_Online_Export__c
        if (qList.size() > 0) {
            for (Apttus_Proposal__Proposal__c quote: qList) {
                Apttus_Proposal__Proposal__c pquote = new Apttus_Proposal__Proposal__c(id = quote.id, APTS_Contact_Validation_Flag__c = True);
                pquote.Digital_Ready_Online_Export__c = TRUE;
                qUpList.add(pquote);
            }
            System.debug('qUpList====>' + qUpList);
            Database.update(qUpList, false);
        }
    }
    // Added this method to provide Product is Banded or Per Seat. 
    public static boolean isBandedProduct(String material) {
        Boolean isActive = False;
        String pPModel;

        pPModel = [Select APTS_Product_Pricing_Model__c From Product2 Where productCode =: material Limit 1].APTS_Product_Pricing_Model__c;

        if (pPModel == 'Banded') {
            isActive = True;
        }

        if (pPModel == 'Per Seat') {
            isActive = False;
        }
        return isActive;
    }
    //Add new to Creation of online conatct 
    Public static void olcCreation(List < Online_Contacts__c > olcContacts) {

        List < Online_Contacts__c > olcList = new list < Online_Contacts__c > ();
        System.debug('olcContacts=====>' + olcContacts);
        if (olcContacts.size() > 0) {
            for (Online_Contacts__c oLcObjt: olcContacts) {
                Online_Contacts__c olcSele = new Online_Contacts__c();
                olcSele.Account__c = oLcObjt.Account__c;
                olcSele.APTS_Source_System_Detail__c = oLcObjt.APTS_Source_System_Detail__c;
                olcSele.QuoteId__c = oLcObjt.QuoteId__c;
                olcSele.Is_Banded_Product__c = oLcObjt.Is_Banded_Product__c;
                olcSele.Email__c = oLcObjt.Email__c;
                olcSele.ProductId__c = oLcObjt.ProductId__c;
                olcSele.Material__c = oLcObjt.Material__c;
                olcSele.First_Name__c = oLcObjt.First_Name__c;
                olcSele.Middle_Name__c = oLcObjt.Middle_Name__c;
                olcSele.Last_Name__c = oLcObjt.Last_Name__c;
                olcSele.Position__c = oLcObjt.Position__c;
                olcSele.ContactID__c = oLcObjt.ContactID__c;
                olcSele.Type__c = oLcObjt.Type__c;
                olcSele.WLEc_Juris__c = oLcObjt.WLEc_Juris__c;
                if (oLcObjt.Type__c == 'Admin')
                    olcSele.Sftwr_Admin__c = True;
                else
                    olcSele.Sftwr_Admin__c = False;
                finalPropol.add(oLcObjt.QuoteId__c);
                olcList.add(olcSele);
                system.debug('finalPropol==>' + finalPropol);
            }
            system.debug('olcList==>' + olcList);
            Database.insert(olcList, false);
        }
    }

    public static Map < string, Map < string, Decimal >> upSellobjct(list < Apttus_Proposal__Proposal__c > dsproposallist) {

        Set < id > proposalid = new Set < id > ();
        String CANCEL_LINE_STATUS = 'Cancelled';
        string cartStatus = 'Finalized';

        List < Digital_SmartMatching.upsellProducts > newProdustlist = new List < Digital_SmartMatching.upsellProducts > ();

        Map < string, Decimal > lineitemMap = new Map < string, Decimal > ();
        Map < string, Map < string, Decimal >> proplineitemMap = new Map < string, Map < string, Decimal >> ();

        for (Apttus_Proposal__Proposal__c proposal: dsproposallist) {
            proposalid.add(proposal.id);
        }

        //DLT-19620 Query and variable assignments updated to get data from Proposal Line Item
        for (Apttus_Proposal__Proposal_Line_Item__c pLineItem: [SELECT id, name, Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__c, Apttus_Proposal__Proposal__c,
                Apttus_QPConfig__LineStatus__c, Apttus_Proposal__Quantity__c, Apttus_Proposal__Product__c,
                Apttus_QPConfig__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c,
                Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c, Apttus_Proposal__Product__r.ProductCode,
                Apttus_QPConfig__Quantity2__c, Apttus_Proposal__Product__r.Service_Number__c, Apttus_Proposal__Product__r.Subscription_Number__c,
                APTS_Service_Number_Override__c, APTS_Subscription_Number_Override__c
                FROM Apttus_Proposal__Proposal_Line_Item__c
                WHERE Apttus_Proposal__Proposal__c IN: proposalid AND Apttus_QPConfig__LineStatus__c != 'Cancelled'
            ]) {

            Digital_SmartMatching.upsellProducts newProd = new Digital_SmartMatching.upsellProducts();
            newProd.sapAccNum = pLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c; //Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c  ,Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c
            newProd.proposalid = pLineItem.Apttus_Proposal__Proposal__c;

            if (pLineItem.Apttus_Proposal__Product__r.ProductCode != null) {
                newProd.materials = pLineItem.Apttus_Proposal__Product__r.ProductCode;
            } else {
                newProd.materials = pLineItem.APTS_Service_Number_Override__c;
            }

            if (newProd.materials != null && pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c == null) {
                newProd.productPM = 'Per Seat';
            } else if (newProd.materials != null && pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c != null) {
                newProd.productPM = pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c;
            }

            if (pLineItem.Apttus_QPConfig__Quantity2__c != null) {
                if (pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c == 'Banded') {
                    newProd.quantity = pLineItem.Apttus_QPConfig__Quantity2__c * 2;
                } else {
                    newProd.quantity = pLineItem.Apttus_QPConfig__Quantity2__c;
                }
                System.debug('newProd.quantity=====>' + newProd.quantity);
            }

            newProd.AccSSdid = pLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__c;
            newProdustlist.add(newProd);
        }

        for (Digital_SmartMatching.upsellProducts newprod: newProdustlist) {
            lineitemMap.put(newprod.materials, newProd.quantity);
            proplineitemMap.put(newprod.proposalid, lineitemMap);
        }
        System.debug('proplineitemMap=====>' + proplineitemMap);
        return proplineitemMap;
    }
    global void finish(Database.BatchableContext info) {

        Digital_OnlineContactsExport doce = new Digital_OnlineContactsExport();
        database.executeBatch(doce, 1);

    }
}