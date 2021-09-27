/*
 * This class contains unit tests for validating the behavior of batch class Digital_ExpireRenewalsSync. The class expires all proposals 
 * upon renewal. 
 * 
 */
 /*
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2019-04-19   Saleh Asadallahi        DLT-14808 - Expire Digital Proposals if any subscriptions have been renewed via different Opp
 * 2020-10-29   Brenda Shields          DLT-21009 - Updated for PMD violations 
 * =============================================================================
 */
 
@isTest
private class Digital_ExpireRenewalsSync_Test {
    
    @testSetup
    static void init(){
        Test.startTest();
        DCTestData.createPaymentCreditWebService();
        DCTestData.createPaymentAutoCharge();
        DCTestData.createData();
        Test.stopTest();

        //create opportunities
        List<Opportunity> oppList = new List<Opportunity>();
        
        Opportunity opp1 = DCTestData.createOpportunityRec('Test 1', DCTestData.accountId, 'Appointment Scheduled', System.Today() + 30, DCTestData.accssdid);
        opp1.Renewal_Date__c = System.today() + 100;
        oppList.add(opp1);
        
        Opportunity opp2 = DCTestData.createOpportunityRec('Test 2', DCTestData.accountId, 'Appointment Scheduled', System.Today() + 60, DCTestData.accssdid);
        opp2.Renewal_Date__c = System.today() + 100;
        oppList.add(opp2);
        
        insert oppList;
        
        //create proposals
        List<Apttus_Proposal__Proposal__c> proposalList1 = new List<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c p1 = DCTestData.createQuote(DCTestData.accountId, 'Straight Renewal');
        p1.Apttus_Proposal__Opportunity__c = oppList[0].id;
        //p1.is_Digital_Channel__c = true;
        proposalList1.add(p1);
        
        Apttus_Proposal__Proposal__c p2 = DCTestData.createQuote(DCTestData.accountId, 'Premium');
        p2.Apttus_Proposal__Opportunity__c = oppList[0].id;
        //p2.is_Digital_Channel__c = true;
        proposalList1.add(p2);
        
        Apttus_Proposal__Proposal__c p3 = DCTestData.createQuote(DCTestData.accountId, 'Manual');
        p3.Apttus_Proposal__Opportunity__c = oppList[1].id;
        //p3.is_Digital_Channel__c = true;
        proposalList1.add(p3);
        
        Apttus_Proposal__Proposal__c p4 = DCTestData.createQuote(DCTestData.accountId, 'Straight Renewal');
        p4.Apttus_Proposal__Opportunity__c = oppList[1].id;
        //p4.is_Digital_Channel__c = true;
        proposalList1.add(p4);
        
        for(Apttus_Proposal__Proposal__c p: proposalList1){
            p.Apttus_Proposal__Approval_Stage__c = 'Presented';
            //p.Digital_Mid_Contract__c = false;
        }  
        insert proposalList1;
        
        //create envelope record
        List<Apttus_DocuApi__DocuSignEnvelope__c> envList = new List<Apttus_DocuApi__DocuSignEnvelope__c>();
        for(Apttus_Proposal__Proposal__c p : proposalList1){
            Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent', p.id);
            envList.add(newEnv);
        }
        insert envList;
        
        //create asset line items
        List<Apttus_Config2__AssetLineItem__c> assetList = new List<Apttus_Config2__AssetLineItem__c>();
        
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c();
        asset1.APTS_Info_RenewalDate__c = System.today() + 100;
        asset1.Apttus_Config2__AssetStatus__c = 'Activated';
        asset1.Apttus_QPConfig__ProposalId__c = proposalList1[3].id;
        assetList.add(asset1);
        
        Apttus_Config2__AssetLineItem__c asset2 = new Apttus_Config2__AssetLineItem__c();
        asset2.APTS_SAP_MLA_Agreement_Number__c = '123456';
        asset2.APTS_Info_RenewalDate__c = System.today() + 100;
        asset2.Apttus_Config2__AssetStatus__c = 'Activated';
        asset2.Apttus_QPConfig__ProposalId__c = proposalList1[3].id;
        assetList.add(asset2);
        
        insert assetList;

        //create proposal line items
        List<Apttus_Proposal__Proposal_Line_Item__c> pLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pLineItem1 = new Apttus_Proposal__Proposal_Line_Item__c();
        pLineItem1.Apttus_Proposal__Proposal__c = proposalList1[0].id;
        pLineItem1.Apttus_QPConfig__AssetLineItemId__c = assetList[0].id;
        pLineItemList.add(pLineItem1);
        
        Apttus_Proposal__Proposal_Line_Item__c pLineItem2 = new Apttus_Proposal__Proposal_Line_Item__c();
        pLineItem2.Apttus_Proposal__Proposal__c = proposalList1[0].id;
        pLineItem2.Apttus_QPConfig__AssetLineItemId__c = assetList[1].id;
        pLineItemList.add(pLineItem2);
        
        Apttus_Proposal__Proposal_Line_Item__c pLineItem3 = new Apttus_Proposal__Proposal_Line_Item__c();
        pLineItem3.Apttus_Proposal__Proposal__c = proposalList1[1].id;
        pLineItem3.Apttus_QPConfig__AssetLineItemId__c = assetList[1].id;
        pLineItemList.add(pLineItem3);
        
        Apttus_Proposal__Proposal_Line_Item__c pLineItem4 = new Apttus_Proposal__Proposal_Line_Item__c();
        pLineItem4.Apttus_Proposal__Proposal__c = proposalList1[2].id;
        pLineItem4.Apttus_QPConfig__AssetLineItemId__c = assetList[1].id;
        pLineItemList.add(pLineItem4);
        
        Apttus_Proposal__Proposal_Line_Item__c pLineItem5 = new Apttus_Proposal__Proposal_Line_Item__c();
        pLineItem5.Apttus_Proposal__Proposal__c = proposalList1[3].id;
        pLineItem5.Apttus_QPConfig__AssetLineItemId__c = assetList[1].id;
        pLineItemList.add(pLineItem5);
        
        insert PLineItemList;
        
        Apttus_Config2__Order__c orderNew = new Apttus_Config2__Order__c(Apttus_Config2__OrderDate__c = system.today() - 365,
                                                                        Apttus_QPConfig__ProposalId__c = proposalList1[3].id);
        insert orderNew;  
    }
    

    @isTest 
    static void expireRenewalSyncCancelledAssetTest() {
        
        List<Apttus_Config2__AssetLineItem__c> assetList = new List<Apttus_Config2__AssetLineItem__c>();
        for(Apttus_Config2__AssetLineItem__c asset : [SELECT id, Apttus_Config2__AssetStatus__c FROM Apttus_Config2__AssetLineItem__c]){
            asset.Apttus_Config2__AssetStatus__c = 'Cancelled';
            assetList.add(asset);
        }
        update assetList;
        
        //make sure all proposals commited
        Integer validProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, validProposals, 'Proposals should be Presented');
        
        
        Integer sentEnv = [
            select count() 
            from Apttus_DocuApi__DocuSignEnvelope__c 
            where APTTUS_DOCUAPI__STATUS__C = 'sent'
        ]; 
        system.assertEquals(4, sentEnv, 'Envelope status should be sent');
        
        Test.startTest();
        Digital_ExpireRenewalsSync ers = new Digital_ExpireRenewalsSync();
        Database.executeBatch(ers, 50);
        Test.stopTest();
        
        validProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(0, validProposals, 'Proposals should be Presented');  
            
        Integer expiredProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Expired' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, expiredProposals, 'Proposals should be Expired');
        
        Integer voidedEnv = [
            select count() 
            from Apttus_DocuApi__DocuSignEnvelope__c 
            where APTTUS_DOCUAPI__STATUS__C = 'voided'
        ]; 
       system.assertEquals(4, expiredProposals, 'Envelopes should be voided');         
    }


    @isTest 
    static void expireRenewalSyncRenewedAssetTest() {
        
        Apttus_Config2__Order__c renewedOrder = [SELECT id, Apttus_Config2__OrderDate__c FROM Apttus_Config2__Order__c LIMIT 1];
        renewedOrder.Apttus_Config2__OrderDate__c = system.today() + 365;
        update renewedOrder;
        
        //make sure all proposals commited
        Integer validProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, validProposals, 'All proposals should be Presented');
        
        
        Integer sentEnv = [
            select count() 
            from Apttus_DocuApi__DocuSignEnvelope__c 
            where APTTUS_DOCUAPI__STATUS__C = 'sent'
        ]; 
        //System.assertEquals(4, sentEnv);
        
        //renew the subscription
        Apttus_Config2__AssetLineItem__c asset2 = [
                select id, APTS_Info_RenewalDate__c 
                from Apttus_Config2__AssetLineItem__c 
                where APTS_SAP_MLA_Agreement_Number__c = '123456'
                limit 1
        ];
        
        asset2.APTS_Info_RenewalDate__c = System.today() + 465;
        update asset2;
        
        Test.startTest();
        Digital_ExpireRenewalsSync ers = new Digital_ExpireRenewalsSync();
        Database.executeBatch(ers, 50);
        Test.stopTest();
        
        
        validProposals = [select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and is_Digital_Channel__c = true];
        system.assertEquals(2, validProposals, 'All proposals should be Presneted');  
            
        Integer expiredProposals = [select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Expired' and is_Digital_Channel__c = true];
        system.assertEquals(2, expiredProposals, 'All proposals should be Expired');
        
        Integer voidedEnv = [select count() 
            from Apttus_DocuApi__DocuSignEnvelope__c 
            where APTTUS_DOCUAPI__STATUS__C = 'voided']; 
        system.assertEquals(2, expiredProposals, 'All envelopes should be voided');         
    }
    
    
    @isTest 
    static void expireRenewalSyncErrorTest() {
        //make sure all proposals commited
        
        Opportunity opp1 = [select id, Renewal_Date__c from Opportunity where name = 'Test 1' limit 1];
        opp1.Renewal_Date__c = null;
        update opp1; 
        
        Integer validProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, validProposals, 'All Proposals should be Presented');
        
        
        Integer sentEnv = [
            select count() 
            from Apttus_DocuApi__DocuSignEnvelope__c 
            where APTTUS_DOCUAPI__STATUS__C = 'sent'
        ]; 
        system.assertEquals(4, sentEnv, 'All Envelopes should have a status of Sent');
        
        //renew the subscription
        Apttus_Config2__AssetLineItem__c asset2 = [
                select id, APTS_Info_RenewalDate__c 
                from Apttus_Config2__AssetLineItem__c 
                where APTS_SAP_MLA_Agreement_Number__c = '123456'
                limit 1
        ];
        
        asset2.APTS_Info_RenewalDate__c = System.today() + 465;
        update asset2;
        
        Test.startTest();
        Digital_ExpireRenewalsSync ers = new Digital_ExpireRenewalsSync();
        Database.executeBatch(ers, 50);
        Test.stopTest();
        
        
        validProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, validProposals, 'All Proposals should be presented');  
            
        Integer expiredProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Expired' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(0, expiredProposals, 'No proposals should be Expired');
        
        Integer voidedEnv = [
            select count() 
            from Apttus_DocuApi__DocuSignEnvelope__c 
            where APTTUS_DOCUAPI__STATUS__C = 'voided'
        ]; 
        system.assertEquals(0, expiredProposals, 'No envelopes should have a status of voided');       
    }
    
    
    @isTest
    static void exceptionLogTest(){
        List<Apttus_Proposal__Proposal__c> pList = new List<Apttus_Proposal__Proposal__c>();
        for(Integer i = 0; i < 10; i++){
            pList.add(new Apttus_Proposal__Proposal__c());
        }
        
        test.startTest();
        Digital_ExpireRenewalsSync.updateProposals(pList);
        test.stopTest();
        
        integer createdProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, createdProposals, 'All proposals should be Presented');  
    }

    
    @isTest 
    static void schExpireRenewalsTest(){

        // test for successfully processing

        test.starttest();
        Digital_ExpireRenewalsSyncSch ders = new Digital_ExpireRenewalsSyncSch();
        ders.execute(null);
        test.stoptest();
         
        integer createdProposals = [
            select count()
            from Apttus_Proposal__Proposal__c
            where Apttus_Proposal__Approval_Stage__c = 'Presented' and 
            is_Digital_Channel__c = true
            ];
        system.assertEquals(4, createdProposals, 'All proposals should be Presneted');    
    }
    
}