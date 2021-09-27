/* Author - Dinesh Kumar Voonna
   Purpose - If Renewal Date on opportunity passes, expire the Opportunity and its related Quote
   Scheduled Job - Once in a Day overnight
   Project - CX Digital MVP-A Sprint 1
   Jira Num - DLT-183
   Created Date - 18/05/2017

 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description * 2017-12-18   Brenda Shields          DLT-6170 - Digital Offers will be closed on midnight +1 Central Standard Time of Renewal Date
 * 2017-12-27   Brenda Shields          DLT-6920 - When expiring proposals - include setting the status to voided in ALL DocuSign Envelope records realted to the opp/Proposal
 * 2017-01-11   Brenda Shields          Updated after January release to increase test class code coverage - no functionallity was update  
 * 2018-01-17   Brenda Shields          DLT-7189 - When expiring proposals, do not update the Opportunity - reworked all logic
 * 2018-01-17   Brenda Shields          DLT-7190 - Expire proposals when there is an automation failure - "Cancelled assets in Account"
 * 2018-01-30   Brenda Shields          DLT-7479 - bug - should expire all proposals for an opp when there is an automation error
 * 2018-02-21   Divija Salla            DLT-7565 - Expire all the quotes related to an opportunity when one of the quote is expired with automation failure - 'Quantity does not match Band number' AND Proposal stage ='Expired'
 * 2018-03-19   Brenda Shields          DLT-8184 - Updated to batchable - All Auotmation Failues should work the same - add custom label for errors included, update Opp for new digital flag
 *                                      DLT-8661 - Also uncheck Is Digital Channel flag on Opp
 * 2018-06-05   Brenda Shields          DLT-10430 - Exclude Manually created proposals from Renewal Expiration process 
 * 2018-07-18   Brenda Shields          DLT-10851 - Expire Mid-Contract proposals 365 days before their renewal date
 * 2018-08-22   Brenda Sheilds          DLT-10852 - When Expiring Mid-Contract proposals - set the Digital Engagement field on the Opp
 * 2019-03-20   Navleen Kaur            DLT-15672  [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
 * 2019-04-25   Harikasai P             DLT-16195  [SLF] Expire Mid-Contract/UpSell proposals on the offer expiration date
 * 2019-06-10   HarikaSai P             DLT-16777  [ALL] Update Digital_OpportunityRenewalDateCheck to not check on Opportunity Status to determine Proposals to Expire
 * 2019-06-12   HarikaSai P             DLT-16823  [SLF] Expire Mid-Contract/UpSell proposals on the offer expiration date
 *                                      New Mid-Contract Renewals – Once they are passed 60 days after they were created (expire after the end of that month)
 *                                      OR  if they have passed their Opp Renewal date
 * 2020-07-20   Brenda Shields          DLT-20383 - Expire Digital Manual quoutes if the Opp has passed it's renewal date      
 * 2020-08-05   Rahul Natarajan         DLT-20497 - INC3608397 | [SFDC] RenewalDateCheck to update the day after the renewal date                                  
 * ==================================================================================================================================   
 */
public without sharing class Digital_OpportunityRenewalDateCheck implements Database.AllowsCallouts, Database.Batchable < Apttus_Proposal__Proposal__c > {
    /**
     * Enables scheduling for this class.
     * @param   scContext   the context of the method execution.
     */
    public list < String > lstFailures = new list < String > (Label.Digital_Automation_Failure_Messages.split(','));
    // DLT-20497 Removed +1 on renewalDate to Expire Quotes lesser than today
    public date renewalDate = system.today();
    public date midcontractDate = system.today() + 365;
    private static Final String OLD_MID_CONTRACT = 'Old Mid Contract';
    private static Final String NEW_MID_CONTRACT = 'New Mid Contract';
    private static final string ENVELOPE_STATUS_SENT = 'sent';
    private static final string ENVELOPE_STATUS_VOIDED = 'voided';
    private static final string QUOTE_STATUS_EXPIRED = 'Expired';
    public static list < Digital_Exception_Log__c > exList = new list < Digital_Exception_Log__c > ();

    // checking on the following to expire
    // Renewal Proposals that have passeed their Renewal date
    // Old Mid-Contract Renewals – Once they are less than one year prior to their Opp Renewal date
    // New Mid-Contract Renewals – Once they are passed 60 days after they were created (expire after the end of that month)
    //                             OR  if they have passed their Opp Renewal date
    // Proposals with Automation errors 
    // DLT-20383 - Remove check to not select Digital Manual quoutes - and Digital_Quote_Type__c != 'Manual'  
    public list < Apttus_Proposal__Proposal__c > batchProposalList = [select Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.Renewal_Date__c,
        id, Apttus_Proposal__Approval_Stage__c, is_Digital_Channel__c, Digital_Quote_Failure_Reason__c, Digital_Quote_Type__c, Contract_Type__c, createdDate
        from Apttus_Proposal__Proposal__c
        where is_Digital_Channel__c = true and Apttus_Proposal__Approval_Stage__c in ('Draft', 'Approval', 'In Review', 'Approved', 'Approval Required', 'Generated', 'Presented')
        and((Contract_Type__c !=: OLD_MID_CONTRACT and Apttus_Proposal__Opportunity__r.Renewal_Date__c <: renewalDate) // 16777 Removed Opportunity status                
            or(Contract_Type__c =: NEW_MID_CONTRACT and CreatedDate < LAST_N_DAYS: 61) //DLT-16823                                                                   
            or(Digital_Quote_Failure_Reason__c in: lstFailures) or(Contract_Type__c =: OLD_MID_CONTRACT and Apttus_Proposal__Opportunity__r.Renewal_Date__c <: midcontractDate)) //16777 Removed Opportunity Status                
        order by Apttus_Proposal__Opportunity__c
    ];

    public Iterable < Apttus_Proposal__Proposal__c > start(database.batchablecontext bC) {
        system.debug('batchProposalList::' + batchProposalList);
        return batchProposalList;

    }

    public void execute(Database.BatchableContext bC, List < Apttus_Proposal__Proposal__c > scope) {
        List < Apttus_Proposal__Proposal__c > listProposals = new list < Apttus_Proposal__Proposal__c > ();
        for (Apttus_Proposal__Proposal__c proposal: scope) {
            listProposals.add(proposal);
        }
        Digital_OpportunityRenewalDateCheck.ExpireProposals(listProposals);
    }

    public static void expireProposals(List < Apttus_Proposal__Proposal__c > listProposals) {

        // create a test date so we don't expire all testing quotes in dev/qa orgs
        //Date renewalDate = Date.newInstance(2017, 05, 20);
        // DLT-20497 Removed +1 on renewalDate to Expire Quotes lesser than today
        Date renewalDate = system.today();
        date midcontractDate = system.today() + 365;
        system.debug('>>> Renewal Expiration Date: ' + renewalDate + ' Mid-Contract Expiration Date: ' + midcontractDate);
        // Set of Opportunities to update additional proposals with automation errors
        Set < Id > optyIdSet = new Set < Id > ();
        // Set of Opportunities to update Expiration flags
        Set < Id > optyIdToUpdate = new Set < Id > ();
        Set < Id > proposalIdSet = new Set < Id > ();
        Set < Id > proposalsToUpdate = new Set < Id > ();
        Map < Id, List < Apttus_Proposal__Proposal__c >> optyQuoteListMap = new Map < Id, List < Apttus_Proposal__Proposal__c >> ();
        //List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        List < Apttus_Proposal__Proposal__c > proposalExpireList = new List < Apttus_Proposal__Proposal__c > ();
        Database.SaveResult[] lsr;
        Database.SaveResult[] lsr2;
        list < Id > successQuoteList = new list < Id > ();
        list < Opportunity > lstFinalOpps = new list < Opportunity > ();

        Map < Id, string > oppFailures = new Map < Id, string > ();

        Set < String > errMsgs = new Set < String > ();
        List < String > lstMsgs = new List < String > (Label.Digital_Automation_Failure_Messages.split(','));
        errMsgs.addAll(lstMsgs);

        // start processing
        if (listProposals.size() > 0 && listProposals != Null) {

            // get Opportunities to update
            for (Apttus_Proposal__Proposal__c oProError: listProposals) {
                // get the Automation error from the proposal so it can be added to other proposals on that opportunity
                if (!optyIdSet.contains(oProError.Apttus_Proposal__Opportunity__c) && errMsgs.contains(oProError.Digital_Quote_Failure_Reason__c)) {
                    // get set of Opp ids for all Automation errors
                    optyIdSet.add(oProError.Apttus_Proposal__Opportunity__c);
                    // save message to add to other proposals
                    oppFailures.put(oProError.Apttus_Proposal__Opportunity__c, oProError.Digital_Quote_Failure_Reason__c);
                    // For Automation errors - update Opps with new flag as these are unmarked as digital when they are expired
                    if (!optyIdToUpdate.contains(oProError.Apttus_Proposal__Opportunity__c)) {
                        optyIdToUpdate.add(oProError.Apttus_Proposal__Opportunity__c);
                        Opportunity oppUpdate = new Opportunity();
                        OppUpdate.Id = oProError.Apttus_Proposal__Opportunity__c;
                        OppUpdate.Unmarked_Digital_Channel__c = true;
                        oppUpdate.isDigitalSpearHead__c = false;
                        lstFinalOpps.add(OppUpdate);
                    }
                }
                //For Mid-Contract proposal expirations - set the Digital Engagement field
                if (oProError.Contract_Type__c == OLD_MID_CONTRACT && oProError.Apttus_Proposal__Opportunity__r.Renewal_Date__c < midcontractDate &&
                    !optyIdToUpdate.contains(oProError.Apttus_Proposal__Opportunity__c)) {
                    // For Mid-contract expirations - update Opps with new flag as these are unmarked as digital when they are expired
                    optyIdToUpdate.add(oProError.Apttus_Proposal__Opportunity__c);
                    Opportunity oppUpdate = new Opportunity();
                    oppUpdate.Id = oProError.Apttus_Proposal__Opportunity__c;
                    oppUpdate.Unmarked_Digital_Channel__c = true;
                    oppUpdate.isDigitalSpearHead__c = false;
                    oppUpdate.DRS_Status_Digital__c = 'Non-Digital / Ready for Channel';
                    lstFinalOpps.add(OppUpdate);
                }
            }

            // loop through all the proposal and exipre them as needed
            for (Apttus_Proposal__Proposal__c oProposal: listProposals) {

                // update the renewal date to gmt +1 day at 1 AM
                DateTime dtRenewal = DateTime.newInstanceGmt(oProposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c.year(),
                    oProposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c.month(), oProposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c.day() + 1, 1, 0, 0);

                // expire Renewal Date Proposals  , expires new mid contract proposals also if the opportunity Renewal date is passed.   
                if (oProposal.Contract_Type__c != OLD_MID_CONTRACT && dtRenewal < system.now()) {
                    system.debug('***Expiring Renewal Date: Opp id: ' + oProposal.Apttus_Proposal__Opportunity__c + ', Proposal id: ' + oProposal.Id + ', Renewal Date: ' + oProposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c);
                    // expire the proposal
                    if (!proposalsToUpdate.contains(oProposal.id)) {
                        proposalsToUpdate.add(oProposal.id);
                        Apttus_Proposal__Proposal__c finalProposal = new Apttus_Proposal__Proposal__c();
                        finalProposal.id = oProposal.id;
                        finalProposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
                        proposalExpireList.add(finalProposal);
                        // bulid a list of Proposal IDs that we want to 'void' the DocuSign envelopes for
                        proposalIdSet.add(oProposal.id);
                    }
                    // expire Mid-Contract Proposals
                } else if (oProposal.Contract_Type__c == OLD_MID_CONTRACT && oProposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c < midcontractDate) {
                    system.debug('***Expiring Mid-Contract: Opp id: ' + oProposal.Apttus_Proposal__Opportunity__c + ', Proposal id: ' + oProposal.Id + ', Renewal Date: ' + oProposal.Apttus_Proposal__Opportunity__r.Renewal_Date__c);
                    // expire the proposal
                    if (!proposalsToUpdate.contains(oProposal.id)) {
                        proposalsToUpdate.add(oProposal.id);
                        Apttus_Proposal__Proposal__c finalProposal = new Apttus_Proposal__Proposal__c();
                        finalProposal.id = oProposal.id;
                        finalProposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
                        proposalExpireList.add(finalProposal);
                        // bulid a list of Proposal IDs that we want to 'void' the DocuSign envelopes for
                        proposalIdSet.add(oProposal.id);
                    }
                }
                //DLT-16195 Starts
                else if (oProposal.Contract_Type__c == NEW_MID_CONTRACT && (!Test.isRunningTest() ? ((System.today() >= (oProposal.CreatedDate + 60))) : true) && oProposal.Apttus_Proposal__Approval_Stage__c != 'Expired') {
                    Date expDate = Date.valueOf((oProposal.CreatedDate + 60));
                    // Expire new mid contracts after the end of the month after it's been active for 60 days
                    Date lastDayOfMonth = expDate.addMonths(1).toStartofMonth(); //.addDays(-1); 
                    system.debug('New MidCon ExpiryDate::' + lastDayOfMonth);

                    // expire the proposal if proposal creation date falls on the last day of the month after adding 60 days from  the Proposal creation Date.
                    if ((!Test.isRunningTest() ? ((Date.ValueOf(system.Today()) >= lastDayOfMonth)) : true) && !proposalsToUpdate.contains(oProposal.id)) {
                        system.debug('new midconract to be expired::');
                        proposalsToUpdate.add(oProposal.id);
                        Apttus_Proposal__Proposal__c finalProposal = new Apttus_Proposal__Proposal__c();
                        finalProposal.id = oProposal.id;
                        finalProposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
                        proposalExpireList.add(finalProposal);
                        // bulid a list of Proposal IDs that we want to 'void' the DocuSign envelopes for
                        proposalIdSet.add(oProposal.id);
                    }
                } //DLT-16195 Ends
                // expire Automation Error Proposals   
                else {
                    system.debug('***Expiring Auto Error: Opp id: ' + oProposal.Apttus_Proposal__Opportunity__c + ', Proposal id: ' + oProposal.Id + ', Auto Error: ' + oProposal.Digital_Quote_Failure_Reason__c);
                    // expire the proposal
                    if (!proposalsToUpdate.contains(oProposal.id)) {
                        proposalsToUpdate.add(oProposal.id);
                        Apttus_Proposal__Proposal__c finalProposal = new Apttus_Proposal__Proposal__c();
                        finalProposal.id = oProposal.id;
                        finalProposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
                        proposalExpireList.add(finalProposal);
                    }
                }
            }
        } // end of reviewing all proposals

        // get any associated proposal from this batch
        list < Apttus_Proposal__Proposal__c > proposalAutoList = [select Apttus_Proposal__Opportunity__c, Apttus_Proposal__Opportunity__r.Renewal_Date__c,
            id, Apttus_Proposal__Approval_Stage__c, is_Digital_Channel__c, Digital_Quote_Failure_Reason__c, Digital_Quote_Type__c
            from Apttus_Proposal__Proposal__c
            where is_Digital_Channel__c = TRUE and Apttus_Proposal__Approval_Stage__c != 'Expired'
            AND Digital_Quote_Failure_Reason__c in ('', 'NA')
            AND Apttus_Proposal__Opportunity__c in: optyIdSet and Digital_Quote_Type__c != 'Manual'
            order by Apttus_Proposal__Opportunity__c
        ];

        // expire associated proposals
        if (proposalAutoList.size() > 0 && proposalAutoList != Null) {
            for (Apttus_Proposal__Proposal__c oAutoProposal: proposalAutoList) {
                if (!proposalsToUpdate.contains(oAutoProposal.id)) {
                    proposalsToUpdate.add(oAutoProposal.id);
                    Apttus_Proposal__Proposal__c finalProposal = new Apttus_Proposal__Proposal__c();
                    finalProposal.id = oAutoProposal.id;
                    finalProposal.Apttus_Proposal__Approval_Stage__c = 'Expired';
                    // add the message to other quote on this opp
                    if (oppFailures.containsKey(oAutoProposal.Apttus_Proposal__Opportunity__c)) {
                        finalProposal.Digital_Quote_Failure_Reason__c = 'Associated Proposal Failure Message: ' + oppFailures.get(oAutoProposal.Apttus_Proposal__Opportunity__c);
                    }
                    proposalExpireList.add(finalProposal);
                }
            }
        }

        System.debug('Proposal List to Expire: ' + proposalExpireList);
        if (proposalExpireList.size() > 0 && proposalExpireList != Null) {
            lsr = Database.update(proposalExpireList, False);
            if (lsr.size() > 0 && lsr != Null) {
                for (Integer i = 0; i < lsr.size(); i++) {
                    string updatedItemId = proposalExpireList.get(i).id;
                    if (!lsr.get(i).isSuccess()) { handleException(i, lsr, updatedItemId); }
                }
            }
        } // end of proposal update

        // Update Opportunity records
        if (lstFinalOpps != null && lstFinalOpps.size() > 0) {
            lsr2 = Database.update(lstFinalOpps, False);
            if (lsr2.size() > 0 && lsr2 != Null) {
                for (Integer i = 0; i < lsr2.size(); i++) {
                    string updatedOppId = lstFinalOpps.get(i).id;
                    if (!lsr2.get(i).isSuccess()) { handleException(i, lsr2, updatedOppId); }
                }
            }
        }

        // Void all apprporiate DocuSign Envelopes
        updateEnvelopeRecords(proposalIdSet);

        // insert any errors
        try {
            if (exList.size() > 0 && exList != Null) { insert exList; }
        }
        Catch(Exception e) {
            System.debug('Exception' + e);
        }

    }


    // Update all DocuSign Envelopes status of expired quotes to 'voided'       
    public static void updateEnvelopeRecords(set < Id > setProposalIds) {
        Database.SaveResult[] lsr1;
        list < Apttus_DocuApi__DocuSignEnvelope__c > envsToUpdate = new list < Apttus_DocuApi__DocuSignEnvelope__c > ();

        // if no access to the object, report error and return          
        if (!schema.sObjectType.Apttus_DocuApi__DocuSignEnvelope__c.isAccessible()) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = 'No access to DocuSign Envelope Records.',Exception_Type__c = 'Record select Error',Additional_Information__c = ',',User_Message__c = '',Class_Reference__c = 'Digital_OpportunityRenewalDateCheck - updateEnvelopeRecords'); exList.add(ex); return;
        }

        // Void all apprporiate DocuSign Envelopes
        list < Apttus_DocuApi__DocuSignEnvelope__c > envList = [select id, APTTUS_DOCUAPI__STATUS__C from Apttus_DocuApi__DocuSignEnvelope__c
            where APTTUS_DOCUAPI__STATUS__C =: ENVELOPE_STATUS_SENT AND APTTUS_DOCUAPI__PARENTID__C in: setProposalIds
        ];
        if (envList.size() > 0 && envList != Null) {
            for (Apttus_DocuApi__DocuSignEnvelope__c oEnvUpdate: envList) {
                // update status to voided
                Apttus_DocuApi__DocuSignEnvelope__c finalEnvelope = new Apttus_DocuApi__DocuSignEnvelope__c();
                finalEnvelope.id = oEnvUpdate.id;
                finalEnvelope.APTTUS_DOCUAPI__STATUS__C = 'voided';
                envsToUpdate.add(finalEnvelope);
                system.debug('Envelope - moving status to voided for id: ' + oEnvUpdate.Id);
            }
        }
        // Update Envelope records
        if (envsToUpdate != null && envsToUpdate.size() > 0) {
            lsr1 = Database.update(envsToUpdate, False);
            if (lsr1.size() > 0 && lsr1 != Null) {
                for (Integer i = 0; i < lsr1.size(); i++) {
                    string updatedEnvId = envsToUpdate.get(i).id;
                    if (!lsr1.get(i).isSuccess()) { handleException(i, lsr1, updatedEnvId); }
                }
            }
        }
    }


    public static void handleException(integer i, Database.saveresult[] updateList, Id updatedRecordId) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();Database.Error error = UpdateList.get(i).getErrors().get(0);ex.Exception_Message__c = error.getMessage();ex.Exception_Type__c = 'Record Update Error: Id - ' + updatedRecordId; //failed record from the list
        for (string errorField: error.getfields()) { ex.Additional_Information__c += errorField + ',';}
        ex.User_Message__c = String.Valueof(error.getStatusCode());ex.Class_Reference__c = 'Digital_OpportunityRenewalDateCheck - OptyQuotesExpiration';exList.add(ex);
    } // end of error handling


    //Internal Classes
    public class Digital_OpportunityRenewalDateCheckException extends Exception {}

    public void finish(Database.BatchableContext bC) {

        string strOrgName = 'Production';
        if (UserInfo.getUserName().substringAfterLast('.com') != null) {
            strOrgName = UserInfo.getUserName().substringAfterLast('.');
        }
        AsyncApexJob a = [Select Id, Status, ExtendedStatus, NumberOfErrors, JobItemsProcessed, TotalJobItems from AsyncApexJob where Id =: BC.getJobId()];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
            'brenda.shields@tr.com'
        };
        mail.setToAddresses(toAddresses);
        mail.setSubject(strOrgName + ': Digital Product Plan XREF Batch ' + a.Status);
        mail.setPlainTextBody('Proposals Expired: ' + a.TotalJobItems + ', with ' + a.NumberOfErrors + ' failures.');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}