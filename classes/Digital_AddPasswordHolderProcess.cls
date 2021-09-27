/* CHANGE HISTORY
 ==================================================================================================================================
Date         Name                  Description
2018-06-21   Srikanth Kota         DLT-9757 - APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
2020-08-27   Rahul Natarajan       DLT-20631 - [SFDC] [REN] Critical Code scan issue` and Fixed few PMD Violations
==================================================================================================================================   
 */
public with sharing class Digital_AddPasswordHolderProcess {


    public static List < Online_Contacts__c > newOLClist;
    public static Map < String, List < Online_Contacts__c >> oldSFMaterialOLCMap;
    public static Map < String, Map < String, List < Online_Contacts__c >>> oldpricingModelMap;
    public static Map < String, List < Online_Contacts__c >> oldOLCKeysetMap;
    public static Map < Id, List < proposalMaterial >> newproposalMaterial;
    public static Map < String, Map < String, Boolean >> olcCheckKeyMap;
    public static Map < ID, Map < String, List < Online_Contacts__c >>> accIdOlclistMap;
    public static Map < ID, Set < ID >> propoAccIdMap;
    public static Map < ID, Set < String >> oldAccIdOLCIdBandedMap;
    public static Map < Id, Map < String, Boolean >> accOlcConIdMap;
    public static Map < String, List < Online_Contacts__c >> chckQuantityMap;
    public static Set < id > noSfolcPropol;


    public static void getOrderOnlineContact(List < Apttus_Proposal__Proposal__c > qpList) {
        system.debug('qpList==>' + qpList);
        Set < Id > orderProlId = new Set < Id > ();
        Set < Id > accountId = new Set < Id > ();
        List < Online_Contacts__c > sfOLC = new List < Online_Contacts__c > ();
        //set<String> oldSFOLCMatrl = new set<String>();
        oldSFMaterialOLCMap = new Map < String, List < Online_Contacts__c >> ();
        Set < Id > proCartId = new Set < Id > ();
        oldpricingModelMap = new Map < String, Map < String, List < Online_Contacts__c >>> ();
        oldOLCKeysetMap = new Map < String, List < Online_Contacts__c >> ();
        newproposalMaterial = new Map < Id, List < proposalMaterial >> ();
        olcCheckKeyMap = new Map < String, Map < String, Boolean >> ();
        accIdOlclistMap = new Map < ID, Map < String, List < Online_Contacts__c >>> ();
        propoAccIdMap = new Map < ID, Set < ID >> ();
        newOLClist = new List < Online_Contacts__c > ();
        noSfolcPropol = new Set < id > ();

        Map < String, List < Online_Contacts__c >> oldOLCMap = new Map < String, List < Online_Contacts__c >> ();
        //Get Old OLC 
        if (qpList != Null) {

            for (Apttus_Proposal__Proposal__c optyProposal: qpList) {
                if (optyProposal.APTS_SSD_Sold_To__c != null) {
                    Map < String, List < Online_Contacts__c >> tempAccoldOLCKeyConMap = new Map < String, List < Online_Contacts__c >> (getAccOldOLC(optyProposal.APTS_SSD_Sold_To__c));
                    System.debug('getAccOLC==>' + getAccOldOLC(optyProposal.APTS_SSD_Sold_To__c));
                    accIdOlclistMap.put(optyProposal.APTS_SSD_Sold_To__c, tempAccoldOLCKeyConMap);
                }
                noSfolcPropol.add(optyProposal.id);
            }
            System.debug('accIdOlclistMap==>' + accIdOlclistMap);
        }
        //New proposal
        for (Apttus_Config2__ProductConfiguration__c proConfig: [Select id, Apttus_QPConfig__Proposald__c, Apttus_Config2__AccountId__c, APTS_SSD_Sold_To__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c IN: qpList and Apttus_Config2__Status__c = 'Finalized']) {

            proCartId.add(proConfig.id);

            if (!propoAccIdMap.containsKey(proConfig.APTS_SSD_Sold_To__c)){
                propoAccIdMap.put(proConfig.APTS_SSD_Sold_To__c, new Set < ID > ());
            }
            propoAccIdMap.get(proConfig.APTS_SSD_Sold_To__c).add(proConfig.Apttus_QPConfig__Proposald__c);
        }
        System.debug('proCartId====>' + proCartId);

        if (proCartId != Null && !accIdOlclistMap.isEmpty() && accIdOlclistMap != null) {

            Set < String > newProductCodeSet = new Set < String > ();
            Set < String > pPMSet = new Set < String > {
                'Banded',
                'Per Seat'
            };

            List < Apttus_Config2__LineItem__c > lineItemList = new List < Apttus_Config2__LineItem__c > ();

           if(Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible()){
            lineItemList = [select id, name, Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PrimaryLineNumber__c,
                Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,
                Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, APTS_Number_of_Attorneys__c
                from Apttus_Config2__LineItem__c
                WHERE Apttus_Config2__ConfigurationId__c =: proCartId AND Apttus_Config2__LineStatus__c = 'New'
                and Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c IN: pPMSet
            ];
           }

            System.debug('lineItemList==>' + lineItemList);
            List < proposalMaterial > propolist = new List < proposalMaterial > ();
            for (Apttus_Config2__LineItem__c lineItem: lineItemList) {

                //New list
                proposalMaterial propoMatNuM = new proposalMaterial();

                if (!newProductCodeSet.contains(lineItem.id)) {

                    if (lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded') {
                        propoMatNuM.isBanded = True;
                        propoMatNuM.Quantity = lineItem.APTS_Number_of_Attorneys__c * 2;
                    }
                    if (lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Per Seat') {
                        propoMatNuM.isBanded = False;
                        propoMatNuM.Quantity = lineItem.APTS_Number_of_Attorneys__c;
                    }
                    propoMatNuM.materialNum = lineItem.Apttus_Config2__ProductId__r.ProductCode;
                    propoMatNuM.isAssigned = False;
                    newProductCodeSet.add(lineItem.id);
                }

                propolist.add(propoMatNuM);

                if (!newproposalMaterial.containsKey(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c)){
                    newproposalMaterial.put(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, new List < proposalMaterial > ());
                }
                    

                newproposalMaterial.get(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).add(propoMatNuM);
                //End New list
                System.debug('Apttus_Config2__BillToAccountId__c==>' + lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c);
                List < Online_Contacts__c > olcBOLClist = accIdOlclistMap.get(lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c).get('Banded');
                List < Online_Contacts__c > olcPsOLClist = accIdOlclistMap.get(lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c).get('Per Seat');

                ///New Mapping sfOLC 
                /* If(newOLClist.isEmpty()){
                    if(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded'){
                    integer bcount = 0;
                    for(Online_Contacts__c oldOCL:olcPsOLClist){
                    newOLClist.add(assignESIContactsUtil(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c,lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,lineItem.Apttus_Config2__ProductId__r.ProductCode,True,oldOCL)); 
                    if(++bcount==(lineItem.APTS_Number_of_Attorneys__c*2))
                    break;
                    }
                    }
                    
                    if(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Per Seat'){
                    integer count = 0;
                    for(Online_Contacts__c oldOCL:olcPsOLClist){
                    newOLClist.add(assignESIContactsUtil(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c,lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,lineItem.Apttus_Config2__ProductId__r.ProductCode,False,oldOCL)); 
                    linPCode.add(lineItem.Apttus_Config2__ProductId__r.ProductCode);
                    if(++count==lineItem.APTS_Number_of_Attorneys__c)
                    break;
                    }
                    }
                    
                    }else{
                    if(!linPCode.contains(lineItem.Apttus_Config2__ProductId__r.ProductCode)){
                    
                    if(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded'){
                    integer bcount = 0;
                    for(Online_Contacts__c oldOCL:olcPsOLClist){
                    newOLClist.add(assignESIContactsUtil(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c,lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,lineItem.Apttus_Config2__ProductId__r.ProductCode,True,oldOCL)); 
                    if(++bcount==(lineItem.APTS_Number_of_Attorneys__c*2))
                    break;
                    }
                    }
                    
                    if(lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Per Seat'){
                    integer count = 0;
                    for(Online_Contacts__c oldOCL:olcPsOLClist){
                    newOLClist.add(assignESIContactsUtil(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c,lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,lineItem.Apttus_Config2__ProductId__r.ProductCode,False,oldOCL)); 
                    if(++count==lineItem.APTS_Number_of_Attorneys__c)
                    break;
                    }
                    }
                    }
                    }
                    */

                System.debug('olcBOLClist====>' + olcBOLClist);
                System.debug('olcPsOLClist====>' + olcPsOLClist);
                System.debug('PPM====>' + lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c);
                if (!olcBOLClist.isEmpty() || !olcPsOLClist.isEmpty()) {
                    if (lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Banded') {
                        if (!olcBOLClist.isEmpty()) {
                            integer bcount = 0;
                            for (Online_Contacts__c oldOCL: olcBOLClist) {
                                newOLClist.add(assignESIContactsUtil(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, lineItem.Apttus_Config2__ProductId__r.ProductCode, True, oldOCL));
                                if (++bcount == (lineItem.APTS_Number_of_Attorneys__c * 2)){
                                    break;
                                }
                            }
                        }

                        //noSfolcPropol.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);

                    }

                    if (lineItem.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c == 'Per Seat') {
                        if (!olcPsOLClist.isEmpty()) {
                            integer count = 0;
                            for (Online_Contacts__c oldOCL: olcPsOLClist) {
                                newOLClist.add(assignESIContactsUtil(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__AccountId__c, lineItem.Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, lineItem.Apttus_Config2__ProductId__r.ProductCode, False, oldOCL));
                                //linPCode.add(lineItem.Apttus_Config2__ProductId__r.ProductCode);
                                if (++count == lineItem.APTS_Number_of_Attorneys__c){
                                    break;
                                }
                            }
                        }

                        //noSfolcPropol.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
                        System.debug('newOLClist===PS=>' + newOLClist);
                    }
                } else {

                    noSfolcPropol.add(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c);
                }

                //end New Mapping sfOLC
            }
            System.debug('propolist==>' + propolist);
            System.debug('newOLClist==>' + newOLClist);

        }
        System.debug('newproposalMaterial==>' + newproposalMaterial);
        System.debug('NewpropoAccIdMap==>' + propoAccIdMap);
        //New proposal End
        getnewOLClist();
        //olcCreation(newOLClist);

    }

    public static Online_Contacts__c assignESIContactsUtil(Id accountId, Id ssdAccountId, Id proposalID, string newMaterial, Boolean isBanded, Online_Contacts__c olc) {
        chckQuantityMap = new Map < String, List < Online_Contacts__c >> ();
        List < Online_Contacts__c > newOLClist = new List < Online_Contacts__c > ();
        string keyStr = '';
        if (isBanded) {
            keyStr = 'Banded';
        } else {
            keyStr = 'Per Seat';
        }

        Online_Contacts__c oc = new Online_Contacts__c();
        oc.Account__c = accountId;
        oc.APTS_Source_System_Detail__c = ssdAccountId;
        oc.QuoteId__c = proposalID;
        oc.Material__c = newMaterial;
        oc.ContactID__c = olc.ContactID__c;
        oc.First_Name__c = olc.First_Name__c;
        oc.Middle_Name__c = olc.Middle_Name__c;
        oc.Last_Name__c = olc.Last_Name__c;
        oc.Email__c = olc.Email__c;
        oc.Position__c = olc.Position__c;
        oc.Type__c = olc.Type__c;
        oc.WLEc_Juris__c = olc.WLEc_Juris__c;
        if (oc.Type__c == 'Admin'){
            oc.Sftwr_Admin__c = True;
        }
        else{
            oc.Sftwr_Admin__c = False;
        }
        oc.Is_Banded_Product__c = isBanded;
        newOLClist.add(oc);
        //chckQuantityMap.put(material,newOLClist);
        //System.debug('newOLClist==>'+chckQuantityMap);
        //insert newOLClist;
        return oc;
    }

    public class proposalMaterial {
        //public Id proposalId;
        public boolean isBanded;
        public String materialNum;
        public Decimal Quantity;
        public boolean isAssigned = False;
    }

    public static Set < Id > getnoSfOlcPropalID() {
        return noSfolcPropol;
    }

    public static List < Online_Contacts__c > getnewOLClist() {
        System.debug('newOLClist==>' + newOLClist);
        return newOLClist;
    }

    // DLT-20631 - Declared oldOLCAccKeysetMap at Top and Returned it at end instead of null
    public static Map < String, List < Online_Contacts__c >> getAccOldOLC(ID accountId) {
        Map < String, List < Online_Contacts__c >> oldOLCAccKeysetMap = new Map < String, List < Online_Contacts__c >> ();
        if (accountId != null) {
            //Set<Id> oProposalId = new Set<Id>();
            List < Online_Contacts__c > sfOLC = new List < Online_Contacts__c > ();

            Set < String > olConIdBandedSet = new Set < String > ();
            System.debug('accountId==>' + accountId);
            /*for(Apttus_Config2__OrderLineItem__C Orlin: [Select id,Apttus_Config2__OrderId__r.Apttus_QPConfig__ProposalId__c from Apttus_Config2__OrderLineItem__C where Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AssetStatus__c='Activated' and Apttus_Config2__AssetLineItemId__r.Apttus_Config2__AccountId__c = : accountId]){
            oProposalId.add(Orlin.Apttus_Config2__OrderId__r.Apttus_QPConfig__ProposalId__c);
            }
            
            System.debug('orderProlId==>'+oProposalId); 
            //sfOLC =[Select Name,Account__r.Name,First_Name__c,Last_Name__c,Middle_Name__c,Email__c,Account__c,QuoteId__c,ContactID__c,SAP_Account_Number__c,Is_Banded_Product__c,Product_Description__c,WLEc_Juris__c,Sftwr_Admin__c,Type__c,Position__c from Online_Contacts__c Where QuoteId__c IN: oProposalId ];
            
            
            if(Test.isRunningTest()){
                sfOLC =[Select Name, Account__r.Name, First_Name__c, Last_Name__c, Middle_Name__c, Email__c, Account__c, QuoteId__c, ContactID__c, SAP_Account_Number__c, Is_Banded_Product__c, WLEc_Juris__c, Sftwr_Admin__c, Type__c, Position__c from Online_Contacts__c limit 10 ]; 
            }else{
                sfOLC =[Select Name, Account__r.Name, First_Name__c, Last_Name__c, Middle_Name__c, Email__c, Account__c, APTS_Source_System_Detail__c,QuoteId__c, ContactID__c, SAP_Account_Number__c, Is_Banded_Product__c, WLEc_Juris__c, Sftwr_Admin__c, Type__c, Position__c from Online_Contacts__c Where (QuoteId__r.Apttus_Proposal__Approval_Stage__c ='Accepted' and QuoteId__r.Apttus_Proposal__Primary__c=True) AND APTS_Source_System_Detail__c =:accountId];
            }
            */
            if(Schema.sObjectType.Online_Contacts__c.isAccessible()){
            sfOLC = [Select Name, Account__r.Name, First_Name__c, Last_Name__c, Middle_Name__c, Email__c, Account__c, APTS_Source_System_Detail__c, QuoteId__c, ContactID__c, SAP_Account_Number__c, Is_Banded_Product__c, WLEc_Juris__c, Sftwr_Admin__c, Type__c, Position__c from Online_Contacts__c Where(QuoteId__r.Apttus_Proposal__Approval_Stage__c = 'Accepted'
                and QuoteId__r.Apttus_Proposal__Primary__c = True) AND APTS_Source_System_Detail__c =: accountId];
            }
            System.debug('sfOLC ==Order=>' + sfOLC);
            System.debug('sfOLC ==>' + sfOLC.size());

            List < Online_Contacts__c > olcPerSeatOne = new List < Online_Contacts__c > ();
            List < Online_Contacts__c > olcBandedOne = new List < Online_Contacts__c > ();
            for (Online_Contacts__c olc: sfOLC) {

                if (olc.Is_Banded_Product__c == False) {
                    olcPerSeatOne.add(olc);
                }

                if (olc.Is_Banded_Product__c == True) {
                    if (!olConIdBandedSet.contains(olc.ContactID__c)) {
                        olcBandedOne.add(olc);
                        olConIdBandedSet.add(olc.ContactID__c);
                    }
                }
            }
            System.debug('olcPerSeatOne==>' + olcPerSeatOne);
            System.debug('olcPerSeatOne==>' + olcPerSeatOne.size());
            System.debug('olcIdBandedSet==>' + olConIdBandedSet);
            System.debug('olcBandedOne==>' + olcBandedOne);
            System.debug('olcBandedOne==>' + olcBandedOne.size());
            oldOLCAccKeysetMap.put('Per Seat', olcPerSeatOne);

            oldOLCAccKeysetMap.put('Banded', olcBandedOne);

            System.debug('oldOLCAccKeysetMap==>' + oldOLCAccKeysetMap);
            System.debug('oldOLCAccKeysetMap ==Order=>' + oldOLCAccKeysetMap.get('Per Seat'));
            System.debug('oldOLCAccKeysetMap ==Order=>' + oldOLCAccKeysetMap.get('Banded'));
            System.debug('oldOLCAccKeysetMap ==Order=>' + oldOLCAccKeysetMap.get('Per Seat').size());
            System.debug('oldOLCAccKeysetMap ==Order=>' + oldOLCAccKeysetMap.get('Banded').size());

        }
        return oldOLCAccKeysetMap;
    }

}