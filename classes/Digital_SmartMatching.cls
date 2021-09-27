/* CHANGE HISTORY
==================================================================================================================================
Date         Name                  Description
2018-07-19   Srikanth Kota         DLT-8693 - Enhanced Entitlements for users on Banded/Per-seat Products (smart matching)
2018-08-02   Srikanth Kota         DLT-11495-Update Soql with a filter condition now with the index fields to reslove handle large data at defineOLCPPMTypeUtil
2019-06-12   Srikanth Kota         DLT-16784-[Tech Story] [Code Scan] - Fix code scan CRITICAL issues in this Digital_OnlineContactsController and Digital_SmartMatching
2019-11-25   Srikanth kota         DLT-18184-Due to "APTS_Contact_Validation_Flag__c" flag , Corp multi-offer option products proposals are struck in draft status.
2020-08-27   Rahul Natarajan       DLT-20631 - [SFDC] [REN] Critical Code scan issue`   and fixed few PMD Issues
==================================================================================================================================   
*/
public with sharing class Digital_SmartMatching {

    private static Final String CANCEL_LINE_STATUS = 'Cancelled'; // DLT-16784
    private static Final string CARTSTATUS = 'Finalized'; //DLT-16784


    // this used call from Batch Job
    public static Set < id > getEntitlements(list < Apttus_Proposal__Proposal__c > dsproposallist) {


        Set < String > accSAPNumer = new Set < String > ();
        Set < id > proposalid = new Set < id > ();
        Set < id > cartid = new Set < id > ();
        List < upsellProducts > newProdustlist = new List < upsellProducts > ();
        List < activeOLC > newactiveOLClist = new List < activeOLC > ();
        Map < id, upsellProducts > upsellMap = new Map < id, upsellProducts > ();
        Map < string, List < activeOLC >> actOlcUsrMap = new Map < string, List < activeOLC >> ();

        Set < id > noActOLCproposalid = new Set < id > ();
        Set < id > updateOLCActive = new Set < id > ();
        list < Apttus_Proposal__Proposal__c > finalupdateList = new list < Apttus_Proposal__Proposal__c > ();


        for (Apttus_Proposal__Proposal__c proposal: dsproposallist) {
            proposalid.add(proposal.id);
        }
        //DLT-18184 Updated Cart to Proposal, Bez of Corp CPRO Products.
        /*
for(Apttus_Config2__ProductConfiguration__c cart: [select id,name,Apttus_Config2__Status__c ,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_Config2__Status__c = : CARTSTATUS and Apttus_QPConfig__Proposald__c in : proposalid]){
cartid.add(cart.id);

}

for(Apttus_Config2__LineItem__c lineitem  : [select id, name, Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__LineStatus__c,Apttus_Config2__Quantity__c, Apttus_Config2__ProductId__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c,Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.Service_Number__c, Apttus_Config2__ProductId__r.Subscription_Number__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c In : cartid and Apttus_Config2__LineStatus__c != 'Cancelled']){
upsellProducts newProd = new upsellProducts();
newProd.sapAccNum = lineitem.Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c;  //Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c  ,Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c
newProd.proposalid = lineitem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
newProd.materials = lineitem.Apttus_Config2__ProductId__r.ProductCode;
newProd.productPM = lineitem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c;

if(lineitem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c=='Banded'){
newProd.quantity= lineitem.Apttus_Config2__Quantity__c *2;
}
System.debug('newProd.quantity=====>'+newProd.quantity);
newProd.quantity = lineitem.Apttus_Config2__Quantity__c;
newProd.AccSSdid = lineitem.Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__c;

newProdustlist.add(newProd);
}
*/
        for (Apttus_Proposal__Proposal_Line_Item__c pLineItem: [select id, name, Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__LineStatus__c, Apttus_Proposal__Quantity__c, Apttus_Proposal__Product__c, Apttus_QPConfig__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c, Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c, Apttus_Proposal__Product__r.ProductCode, Apttus_QPConfig__Quantity2__c, Apttus_Proposal__Product__r.Service_Number__c, Apttus_Proposal__Product__r.Subscription_Number__c, APTS_Service_Number_Override__c, APTS_Subscription_Number_Override__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c In: proposalid and Apttus_QPConfig__LineStatus__c != 'Cancelled']) {
            upsellProducts newProd = new upsellProducts();
            newProd.sapAccNum = pLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c;
            //Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c  ,Apttus_Config2__ConfigurationId__r.APTS_SSD_ship_to__r.Source_System_Account_Number__c
            newProd.proposalid = pLineItem.Apttus_Proposal__Proposal__c;
            if (pLineItem.Apttus_Proposal__Product__r.ProductCode != null) {
                newProd.materials = pLineItem.Apttus_Proposal__Product__r.ProductCode;
            } else {
                newProd.materials = pLineItem.APTS_Service_Number_Override__c;
            }
            //newProd.productPM = pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c;
            if (newProd.materials != null && pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c == null) { newProd.productPM = 'Per Seat';
            } else if (newProd.materials != null && pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c != null) {
                newProd.productPM = pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c;
            }
            if (pLineItem.Apttus_QPConfig__Quantity2__c != null) {
                if (pLineItem.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c == 'Banded') { newProd.quantity = pLineItem.Apttus_QPConfig__Quantity2__c * 2; }
                System.debug('newProd.quantity=====>' + newProd.quantity);
                newProd.quantity = pLineItem.Apttus_QPConfig__Quantity2__c;
            }
            newProd.AccSSdid = pLineItem.Apttus_Proposal__Proposal__r.APTS_SSD_ship_to__c;

            newProdustlist.add(newProd);
        }

        //End DLT-18184 Updated Cart to Proposal, Bez of Corp CPRO Products.

        System.debug('newProdustlist=========>' + newProdustlist);

        for (upsellProducts newprod: newProdustlist) {

            if (!actOlcUsrMap.containsKey(newprod.sapAccNum)) {
                newactiveOLClist = fetchAccountEntitlements(newprod.sapAccNum);
                if (newactiveOLClist != null && !newactiveOLClist.isEmpty()) {
                    actOlcUsrMap.put(newprod.sapAccNum, new List < activeOLC > ());

                    actOlcUsrMap.get(newprod.sapAccNum).addall(newactiveOLClist);

                    updateOLCActive.add(newprod.proposalid);
                } else {
                    noActOLCproposalid.add(newprod.proposalid);
                }
            }

        }
        // Need to Chnage Logic here to pass other values
        System.debug('newProdustlist=========>' + newProdustlist);
        System.debug('actOlcUsrMap=========>' + actOlcUsrMap);

        if (!newProdustlist.isEmpty() && !actOlcUsrMap.isEmpty()) {
            assignSmartMatch(actOlcUsrMap, newProdustlist);
        }

        System.debug('noActOLCproposalid=========>' + noActOLCproposalid);
        // Need to Chnage Logic here to pass other values

        finalupdateList = [select id, name, Digital_Ready_Online_Export__c, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.SAPAccountNumber__c, APTS_MLA_Quote__c, (select First_Name__c, Last_Name__c, Email_Address__c, Quote__c, Material__c, Quote__r.Apttus_Proposal__Account__c from Customer_Master_Contacts__r) from Apttus_Proposal__Proposal__c where id In: updateOLCActive WITH SECURITY_ENFORCED];
        Digital_PasswordHoldersBatch.updateTempField(finalupdateList);

        return noActOLCproposalid;
    }

    //get the Online Contacts from ESI-EDW-Smart Matching -- Start fetchAccountEntitlements
    public static List < activeOLC > fetchAccountEntitlements(string sapNum) {

        List < activeOLC > esiContacts=new List < activeOLC >();
        DCSMJsonResponseFormatter olDataESI;
        DCSmJsonRequestFormatter.Notification olNoteESI;
        try {
            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('smartmatching');
            system.debug('oWebServiceSettings...' + oWebServiceSettings);

            DCSmJsonRequestFormatter.SmartMatchingRequest smpReq = new DCSmJsonRequestFormatter.SmartMatchingRequest();
            smpReq.esiHeader.applicationId = 'CXECOMM';
            smpReq.sourceSystem = 'AEM';
            smpReq.business = 'Legal';
            smpReq.targetSystem = 'EDW';
            smpReq.domain = 'COBALT';
            smpReq.domainStatus = 'Active';
            smpReq.contactStatus = 'Active';
            smpReq.Account.accountNumber = sapNum; //'1004620772';
            String strBody = JSON.serialize(smpReq);
            system.debug('strBody...' + strBody);
            HttpResponse resp = new HttpResponse();
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('POST');
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            blob headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            String autHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); //DLT-16784
            req.setHeader(Label.Digital_Authorization, autHeader); // DLT-16784 
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');

            req.setBody(strBody);
            req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());

            if (!Test.isRunningTest()) { resp = http.send(req);
            } else {
                resp.setStatusCode(200);
                resp.setBody('{ "esiHeader": null, "statusDetails": { "statusCode": "200", "statusDescription": "SUCCESS", "statusDetailMessage": null }, "account": [ { "accountNumber": "1000034394", "companyId": "WEST", "onlineContact": [ { "contactNumber": "0000214613", "sourceId": "MDB", "contactStatus": "Active", "onlineContactType": "0100", "onlineContactTypeDescription": "ATTORNEY", "allowContactEmails": true, "address": { "firstName": "JAMES", "lastName": "DANGELO", "emailAddress": "JDANGELO42@YAHOO.COM" }, "entitlements": [ { "applicationId": "COBALT", "status": "Active", "appUserGuid": "ia744c0c000000138b9f42144b3e6173f", "accessStartDate": "2013-10-18T00:00:00.000+00:00", "accessEndDate": "9999-12-31T00:00:00.000+00:00", "subscriptions": [ { "subscriptionNumber": "0119756276", "material": { "materialNumber": "000000000041409998", "materialDescription": "WN PRO ANCILLARY", "materialType": "COBALT SUB/SERVICE", "internalDescription": "WN PRO ANCILLARY" } }, { "subscriptionNumber": "011975627", "material": { "materialNumber": "000000000041713884", "materialDescription": "Practical Law Global Content", "materialType": "COBALT SUB/SERVICE", "internalDescription": "Practical Law Global Content" } } ] } ] } ] } ] } ');
            }
            string strRes = resp.getBody();
            system.debug('strRes..' + strRes);
            system.debug('strRes..' + resp.getStatusCode());
            system.debug('resp.getbody..' + resp.getbody());
            if (resp.getStatusCode() == 200) {

                olDataESI = (DCSMJsonResponseFormatter) JSON.deserialize(resp.getbody(), DCSMJsonResponseFormatter.class);
                system.debug('olDataESI...' + olDataESI);
                //assignESISelectedContactsUtil(olDataESI);
            }


            if (olNoteESI != null && !string.isEmpty(olNoteESI.StatusCode) && !string.isEmpty(olNoteESI.StatusDescription)) {
                system.debug('note...' + olNoteESI);
            }
            esiContacts= assignESISelectedContactsUtil(olDataESI);
        } catch (Exception oException) {

            system.debug('oException...' + oException);
        }
        // Modified as part of DLT-20361
        return esiContacts;
    }
    // End fetchAccountEntitlements


    // mappingLogic Start 
    public static void assignSmartMatch(Map < string, List < activeOLC >> actOlcUsrMap, List < upsellProducts > newProdustlist) {

        Set < string > exConID = new Set < string > ();
        Set < string > exProdID = new Set < string > ();
        Set < string > holdConID = new Set < string > ();
        Map < string, Set < string >> assignCheckMap = new Map < string, Set < string >> ();
        Map < string, Set < string >> perassignCheckMap = new Map < string, Set < string >> ();

        List < Online_Contacts__c > pwDholderList = new List < Online_Contacts__c > ();


        System.debug('upsellMap=========>' + newProdustlist);
        System.debug('actOlcUsrMap=========>' + actOlcUsrMap);

        for (upsellProducts proposal: newProdustlist) {
            for (activeOLC olc: actOlcUsrMap.get(proposal.sapAccNum)) {
                System.debug('proposal=============>' + proposal.materials);
                System.debug('proposal=============>' + olc.contactNumber);
                System.debug('olc.olcAssignType=============>' + olc.olcAssignType);
                //System.debug('proposal.quantity=============>'+proposal.quantity.intValue());
                System.debug('actOlcUsrMap.get(proposal.sapAccNum).size()=============>' + actOlcUsrMap.get(proposal.sapAccNum).size());
                System.debug('proposal.productPM=============>' + (proposal.quantity.intValue() * 2 > exConID.size()));
                //For Banded
                if (proposal.productPM == 'Banded' && (olc.olcAssignType == 'Banded' || olc.olcAssignType == 'Both')) {

                    if (!exProdID.contains(proposal.materials)) { exConID.clear(); }

                    if (!exConID.contains(olc.contactNumber) && (proposal.quantity.intValue() * 2 > exConID.size())) {

                        // Cechk Map
                        if (assignCheckMap.isEmpty()) {
                            createdOLC(proposal, olc); exConID.add(olc.contactNumber); exProdID.add(proposal.materials); holdConID.add(olc.contactNumber); assignCheckMap.put(proposal.proposalid, holdConID);
                        } else {
                            System.debug('==========olc.contactNumber=============>' + olc.contactNumber);
                            if (!assignCheckMap.get(proposal.proposalid).contains(olc.contactNumber)) {
                                System.debug('==========inside=============>' + olc.contactNumber);
                                createdOLC(proposal, olc); exConID.add(olc.contactNumber); exProdID.add(proposal.materials); holdConID.add(olc.contactNumber); assignCheckMap.put(proposal.proposalid, holdConID);
                            }
                            System.debug('===olc.contactNumber=============>' + assignCheckMap.get(proposal.proposalid).contains(olc.contactNumber));
                            System.debug('====mber=============>' + (actOlcUsrMap.get(proposal.sapAccNum).size() < Integer.valueOf(proposal.quantity)));

                            if (assignCheckMap.get(proposal.proposalid).contains(olc.contactNumber) && (actOlcUsrMap.get(proposal.sapAccNum).size() < proposal.quantity.intValue() * 2)) {
                                createdOLC(proposal, olc); exProdID.add(proposal.materials);
                            }
                            System.debug('=======NOT ===olc.contactNumber=============>' + olc.contactNumber);
                        }
                    } else {
                        break; //afetr check quantity not available  
                    }
                } else {
                    System.debug('==========else========================proposal=============>' + proposal.materials);
                    if (proposal.productPM == 'Banded' && !exProdID.contains(proposal.materials)) {
                        createdOLC(proposal, olc);
                        exProdID.add(proposal.materials);
                    }
                }
                //For Banded End
                //For Per Seat //&& proposal.productPM == olc.olcAssignType 
                if (proposal.productPM == 'Per Seat' && (olc.olcAssignType == 'Per Seat' || olc.olcAssignType == 'Both')) {
                    System.debug('proposal.materials=============>' + proposal.materials);
                    System.debug('exProdID.exProdID=============>' + exProdID);
                    if (!exProdID.contains(proposal.materials)) { exConID.clear();
                    }
                    System.debug('exConID=============>' + exConID);
                    System.debug('proposal.materials=============>' + proposal.materials);
                    if (!exConID.contains(olc.contactNumber) && (proposal.quantity.intValue() > exConID.size())) {
                        System.debug('perassignCheckMap=============>' + perassignCheckMap);
                        createdOLC(proposal, olc); exConID.add(olc.contactNumber); exProdID.add(proposal.materials); holdConID.add(olc.contactNumber);
                    } else {
                        break;
                    }
                } else {
                    System.debug('==========else========================proposal=============>' + proposal.materials);
                    if (proposal.productPM == 'Per Seat' && !exProdID.contains(proposal.materials)) {
                        createdOLC(proposal, olc);
                        exProdID.add(proposal.materials);
                    }
                }
                //For Per Seat End
            } //End of ActiveOLCUser
        } //End of NewProdcts
    }
    // mappingLogic Ends
    //Removed Return as part of DLT-20361
    //createdOLC Start
    public static void createdOLC(upsellProducts proposal, activeOLC olcUser) {
        List < Online_Contacts__c > spwDholderList = new List < Online_Contacts__c > ();
        System.debug('createdOLC=====proposal========>' + proposal);
        System.debug('createdOLC=====olcUser========>' + olcUser);
        Online_Contacts__c pwdHolder = new Online_Contacts__c();
        pwdHolder.QuoteId__c = proposal.proposalid;
        pwdHolder.First_Name__c = olcUser.firstName;
        pwdHolder.Last_Name__c = olcUser.lastName;
        pwdHolder.Is_Banded_Product__c = proposal.productPM == 'Banded' ? true : False;
        pwdHolder.ContactID__c = olcUser.contactNumber;
        pwdHolder.Material__c = proposal.materials;
        pwdHolder.Position__c = olcUser.olcTypeDescription;
        pwdHolder.APTS_Source_System_Detail__c = proposal.AccSSdid;
        //pwdHolder.SAP_Account_Number__c = proposal.sapAccNum;
        pwdHolder.Email__c = olcUser.email;
        spwDholderList.add(pwdHolder);
        DataBase.insert(spwDholderList, false);
    }
    //createdOLC Ends
    // Util method to assign the values from the Esi response if contact match found in activeOLCobject.
    public static List < activeOLC > assignESISelectedContactsUtil(DCSMJsonResponseFormatter olDataESI) {
        List < activeOLC > awlist = new List < activeOLC > ();
        If(olDataESI != null) {
            for (DCSMJsonResponseFormatter.Account oAcc: olDataESI.Account) {
                if (validateActiveOLC(oAcc.onlineContact)) {
                    for (DCSMJsonResponseFormatter.onlineContact olc: oAcc.onlineContact) {
                        activeOLC aw = new activeOLC();
                        aw.sapAccNum = oAcc.accountNumber;
                        aw.contactNumber = olc.contactNumber;
                        aw.firstName = olc.Address.firstName;
                        aw.lastName = olc.Address.lastName;
                        aw.email = olc.Address.emailAddress;
                        aw.olcTypeDescription = olc.onlineContactTypeDescription;
                        if (olc.Entitlements != null) {
                            aw.olcAssignType = defineOLCPPMTypeUtil(olc.Entitlements); // 
                        }
                        awlist.add(aw);
                        //break;  
                    }
                }
            }
        }
        system.debug('awlist===>...' + awlist);
        return awlist;
    }

    // Support Method toto get APTS_Product_Pricing_Model__c on SmartMatching subscription
    public static string defineOLCPPMTypeUtil(List < DCSMJsonResponseFormatter.Entitlements > entitlements) {

        string olcPPMType;
        string tMaterialNumber;
        set < string > mNumber = new set < string > ();

        if (entitlements != null) {
            for (DCSMJsonResponseFormatter.Entitlements entitl: entitlements) {
                if (entitl.status == 'Active') {
                    if (entitl.subscriptions != null) {
                        for (DCSMJsonResponseFormatter.subscriptions subscr: entitl.subscriptions) {
                            if (subscr.material.materialNumber != null) {
                                if (subscr.material.materialNumber.startsWith('0')){
                                    tMaterialNumber = subscr.material.materialNumber.substring(10);
                                }
                                else{
                                    tMaterialNumber = subscr.material.materialNumber;
                                }
                            }
                            mNumber.add(tMaterialNumber);
                        }
                    }
                }
            }
            system.debug('mNumber===>...' + mNumber);
            set < string > PPM = new set < string > ();
            //for(product2 prod: [select APTS_Product_Pricing_Model__c,Service_Number__c,ProductCode,Subscription_Number__c from product2 where Subscription_Number__c IN : mNumber and IsActive = true])
            for (Apttus_Config2__PriceListItem__c prod: [SELECT id, Apttus_Config2__ProductId__r.Service_Number__c, Apttus_Config2__ProductId__r.Subscription_Number__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.IsActive from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c != null and Apttus_Config2__ProductId__r.ProductCode != null and Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c != null and Apttus_Config2__ProductId__r.Subscription_Number__c != null and Apttus_Config2__ProductId__r.Subscription_Number__c IN: mNumber and Apttus_Config2__ProductId__r.IsActive = true]) {
                if (prod.Apttus_Config2__ProductId__r.Service_Number__c == prod.Apttus_Config2__ProductId__r.ProductCode) {
                    if (prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded' && !PPM.contains(prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)) {
                        PPM.add(prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c); olcPPMType = 'Banded';
                    } else if (prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Per Seat' && !PPM.contains(prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c)) {
                        PPM.add(prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c); olcPPMType = 'Per Seat';
                    }
                    if (PPM.contains('Banded') && PPM.contains('Per Seat')) { olcPPMType = 'Both'; }
                    system.debug('PPM.prod..' + prod.Apttus_Config2__ProductId__r.ProductCode + '=' + prod.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c);
                }
                system.debug('prod.Apttus_Config2__ProductId__r.Service_Number__c...' + prod.Apttus_Config2__ProductId__r.Service_Number__c);
            }
            system.debug('PPM...' + PPM);
            system.debug('olcPPMType===>...' + olcPPMType);
            return olcPPMType;
        }
        return null;
    }

    //validate the olc system(SAP) contacts Status 
    public static boolean validateActiveOLC(List < DCSMJsonResponseFormatter.onlineContact > olcContact) {
        Boolean isActive = False;
        for (DCSMJsonResponseFormatter.onlineContact olc: olcContact) {
            if (olc.contactStatus == 'ACTIVE') {
                isActive = True;
                break;
            }
        }
        return isActive;
    }

    // This will used to collect new Product for each proposal
    public class upsellProducts {
        public string sapAccNum {
            get;
            set;
        }
        public string AccSSdid {
            get;
            set;
        }
        public string proposalid {
            get;
            set;
        }
        public string materials {
            get;
            set;
        }
        public string productPM {
            get;
            set;
        }
        public Decimal quantity {
            get;
            set;
        }

        public upsellProducts() {
            sapAccNum = '';
            AccSSdid = '';
            proposalid = '';
            materials = '';
            productPM = '';
            quantity = 0;

        }
    }

    // This will used to collect Active contact with Product Pricing Model from Entitlements for each account.
    public class activeOLC {
        public string sapAccNum {
            get;
            set;
        }
        public string firstName {
            get;
            set;
        }
        public string lastName {
            get;
            set;
        }
        public string email {
            get;
            set;
        }
        public string contactNumber {
            get;
            set;
        }
        public string olcTypeDescription {
            get;
            set;
        }
        public string olcAssignType {
            get;
            set;
        }

        public activeOLC() {
            sapAccNum = '';
            firstName = '';
            lastName = '';
            email = '';
            contactNumber = '';
            olcTypeDescription = '';
            olcAssignType = ''; //Banded or Per Seat or Both
        }
    }
}