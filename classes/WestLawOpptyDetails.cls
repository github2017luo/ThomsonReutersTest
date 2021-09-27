/*
* This class has westlaw service related to SAP Account Number and returns corresponding OppID, Acc ID and Trial Data
* 
* CHANGE HISTORY
* ==================================================================================================================================
* Date         Name                    Description
* 2018-07-12   Rajan Tatuskar          DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types
* 2018-08-16   Rajan Tatuskar          DLT-11707 - Utilizing Digitally reviewed flag for suppressing in-product notification when Renewal offer not reviewed and approved
* 2018-09-10   Rajan Tatuskar          DLT-10215 - Enable/Disable In Product Notifications
* 2019-03-20   Navleen Kaur            DLT-15672  [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
* 2019-04-22   Srikanth Kota           DLT-16179  [SLF] - Prevent new contract proposal displayed in In product notification 
* 2019-04-22   Srikanth Kota           DLT-16178  [SLF] Only Primary proposal Need to be consider for WestLawOpptyDetails service
* 2019-05-12   Srikanth kota           DLT-18594  [FL] Fix In-product notification for FindLaw.
* 2020-08-05   Rahul Natarajan         DLT-20503   [PL] [REN][SFDC] Add Subcampagn Code Field and Made Few PMD fixes
* 2021-02-23   Ameeta Antonio		   DLT-21440 - [SFDC][REN][ML] In product Renewal Prompt and fixed PMD errors.
* 2021-05-10   Ameeta Antonio		   DLT-21743   Enable MLF SSD query for ODT Practical Law Trials
=================================================================================================================================
*/
/** 
* @description : Webservice to return related details based on SAP AccountNum
*/
@RestResource(urlMapping = '/westLawOpportunity/*')
global with sharing class WestLawOpptyDetails {
    
    private static Final String OLDMIDCONTRACT = 'Old Mid Contract';
    private static Final Set < String > MIDCONTRACT = new Set < String > {
        'Old Mid Contract',
            '    New Mid Contract'
            }; // DLT-16179
                
                private static Set < Id > optyIds = new Set < Id > ();
    /** 
* @description : GET method of the webservice
* @return AccOptyWrapper
*/
    @HttpGet
    global static AccOptyWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        //DLT-20503 Gave If Else braces
        if (!test.isRunningTest()){
            res.addHeader('Cache-Control', 'public,max-age=43200');
        }
        
        
        //String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);        
        String sapAccountNum = req.params.get('sapAccountNum');
        //String TrialId= req.params.get('TrialId');
        
        List < Opportunity > optyList = new List < Opportunity > ();
        //Set < Id > optyIds = new Set < Id > ();
        Set < Id > optyIdFiltered = new Set < Id > ();
        //Contact con;
        //Account acc;
        AccOptyWrapper wrapperObj;
        Source_System_Detail__c acc = new Source_System_Detail__c();
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        //AccTrialWrappercls wrapperObj2;
        
        try {
            
            ssd = [Select Id,Source_System_Account_Number__c,BU_Segment_Level_2__c from Source_System_Detail__c where Source_System_Account_Number__c =: sapAccountNum WITH SECURITY_ENFORCED];
                        
            if(ssd.BU_Segment_Level_2__c == 'Medium Law'){
               acc = [Select id, name, Source_System_Account_Number__c, OLC_Account_Number__c, LCRM_Phone__c, LCRM_Website__c, Trial_Status__c,Digital_Firm__c,(SELECT Id, Trial_Status__c, Trial_Id__c, Trial_End_Date__c from Trials__r ORDER BY Trial_End_Date__c DESC) from Source_System_Detail__c where(Source_System_Account_Number__c =: sapAccountNum OR OLC_Account_Number__c =: sapAccountNum) WITH SECURITY_ENFORCED]; 
            }else{
            //*** START :: Added by Rajan :: DLT-11707 - Utilizing Digitally reviewed flag for suppressing in-product notification when Renewal offer not reviewed and approved
            // DLT-11707 - added "Digital_Review_Complete__c = true" criteria in SQOL Query for Opportunity
            //*** START :: Added by Rajan :: DLT-10215 - Enable/Disable In Product Notifications
            // DLT-10215 - added "Account_Name__r.Disable_In_Product_Notifications__c = false" criteria in SQOL Query for Source_System_Detail__c
            acc = [Select id, name, Source_System_Account_Number__c, OLC_Account_Number__c, LCRM_Phone__c, LCRM_Website__c, Trial_Status__c,Digital_Firm__c, (SELECT Id FROM Opportunities__r WHERE isDigitalSpearHead__c = true AND Digital_Review_Complete__c = true), (SELECT Id, LCRM_Account_SSD__r.Trial_Status__c, LCRM_Contact__r.ContactGUID__c, LCRM_Contact__r.ContactTrialEligibility__c, LCRM_Contact__r.ContactPrimaryUserFlag__c from Contact_SSDs__r), (SELECT Id, Trial_Status__c, Trial_Id__c, Trial_End_Date__c from Trials__r ORDER BY Trial_End_Date__c DESC) from Source_System_Detail__c where(Source_System_Account_Number__c =: sapAccountNum OR OLC_Account_Number__c =: sapAccountNum) AND Account_Name__r.Disable_In_Product_Notifications__c = false AND BU_Segment_Level_2__c <> 'Medium Law' WITH SECURITY_ENFORCED];
            //*** END :: Added by Rajan :: DLT-10215 - Enable/Disable In Product Notifications
            //*** END :: Added by Rajan :: DLT-11707 - Utilizing Digitally reviewed flag for suppressing in-product notification when Renewal offer not reviewed and approved
            // acc= [SELECT Id, Name, Phone, Website,Trial_Status__c,SAPAccountNumber__c,(SELECT Id FROM Opportunities WHERE isDigitalSpearHead__c=true),(SELECT Id,account.Trial_Status__c, ContactGUID__c,ContactTrialEligibility__c,ContactPrimaryUserFlag__c from Contacts),(SELECT Id, Trial_Status__c,Trial_Id__c,Trial_End_Date__c from Trials__r ORDER BY Trial_End_Date__c DESC ) FROM Account WHERE SAPAccountNumber__c= :sapAccountNum];
        	}
        } catch (System.QueryException e) {
            System.debug(LoggingLevel.INFO,'Could not find any Account for the SAP account number provided');
        }
        
        //Checking if there's any oppty record and pulling the Ids into a Set
        wrapperObj = retrieveSetOfOppty(acc);
        
        
        //Checking if there's any oppty Id record and pulling the opty id into a Set based on proposal stage 
        if (optyIds != null && optyIds.size() >= 1) {
            system.debug(LoggingLevel.INFO,'optyIds=========>' + optyIds);
            //*** START :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types //DLT-16178 update Apttus_Proposal__Primary__c and Contract_Type__c
            //for(Apttus_Proposal__Proposal__c ap :[SELECT id,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE Digital_Quote_Type__c != 'Manual' AND Contract_Type__c != :OLDMIDCONTRACT AND Apttus_Proposal__Approval_Stage__c IN ('Presented') AND Apttus_Proposal__Primary__c = TRUE  AND Apttus_Proposal__Opportunity__c IN :optyIds]){                                              
            // DLT-18594
            for (Apttus_Proposal__Proposal__c ap: [SELECT id, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__Proposal__c WHERE Digital_Quote_Type__c != 'Manual'
                                                   AND Contract_Type__c NOT IN: MIDCONTRACT AND Apttus_Proposal__Approval_Stage__c IN('Presented') AND Apttus_Proposal__Primary__c = TRUE AND APTS_Proposal_Business_Unit__c != 'FindLaw'
                                                   AND Apttus_Proposal__Opportunity__c IN: optyIds
                                                  ]) {
                                                      system.debug(LoggingLevel.INFO,'================>' + ap.Apttus_Proposal__Opportunity__c);
                                                      optyIdFiltered.add(ap.Apttus_Proposal__Opportunity__c);
                                                  }
            //*** END :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types
            System.debug(LoggingLevel.INFO,'@@@@@@@@@@54filterde' + optyIdFiltered);
        } else {
            System.debug(LoggingLevel.INFO,'@@@@@@@@@@54' + acc);
            wrapperObj = new AccOptyWrapper(acc, null, 'Could not find any opportunity for the SAP account number provided');
        }
        
        //Checking if there's any filtered oppty record and pulling the opty records into a List 
        if (optyIdFiltered != null && optyIdFiltered.size() >= 1) {
            try {
                //*** START :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types  //DLT-16178 update Apttus_Proposal__Primary__c  and Contract_Type__c
                //optyList = [SELECT Id,accountId,Name,Renewal_Date__c,(SELECT Id, Name, Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__R00N70000001yUfDEAU__r WHERE Digital_Quote_Type__c != 'Manual' AND Contract_Type__c != :OLDMIDCONTRACT AND Apttus_Proposal__Approval_Stage__c IN ('Presented') AND Apttus_Proposal__Primary__c = TRUE) FROM Opportunity WHERE Id IN :optyIdFiltered];
                //DLT-18594
                optyList = [SELECT Id, accountId, Name,sub_Campaign_Code__c,Renewal_Date__c, (SELECT Id, Name, Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__R00N70000001yUfDEAU__r WHERE Digital_Quote_Type__c != 'Manual'
                                                                                              AND Contract_Type__c NOT IN: MIDCONTRACT AND Apttus_Proposal__Approval_Stage__c IN('Presented') AND Apttus_Proposal__Primary__c = TRUE AND APTS_Proposal_Business_Unit__c != 'FindLaw') FROM Opportunity WHERE Id IN: optyIdFiltered WITH SECURITY_ENFORCED];
                // DLT-20503 - Added sub_Campaign_Code__c field in above query
                //*** END :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types 
                wrapperObj = new AccOptyWrapper(acc, optyList, 'No Error');
            } catch (System.QueryException e) {
                System.debug(LoggingLevel.INFO,'Could not find any filtered opty for the SAP account number provided');
            }
        } else {
            System.debug(LoggingLevel.INFO,'@@@@@@@@@@67' + acc);
            wrapperObj = new AccOptyWrapper(acc, null, 'Could not find any opportunity for the SAP account number provided');
        }
        
        
        return wrapperObj;
    }
    
    /** 
* @description : method to retrieve set of oppty id's
* @param acc : SSD query
* @return AccOptyWrapper
*/    
    private static AccOptyWrapper retrieveSetOfOppty(Source_System_Detail__c acc){
        AccOptyWrapper wrapperObj;
        if (acc != null) {
            if (acc.Opportunities__r != null && acc.Opportunities__r.size() >= 1) {
                for (Opportunity op: acc.Opportunities__r) {
                    optyIds.add(op.Id);
                }
                System.debug(LoggingLevel.INFO,'@@@@@afterloop' + optyIds);
            } else {
                System.debug(LoggingLevel.INFO,'@@@@@@@@@@39' + acc);
                wrapperObj = new AccOptyWrapper(acc, null, 'Could not find any opportunity for the SAP account number provided');
            }
        } else {
            wrapperObj = new AccOptyWrapper(null, null, 'Could not find any account for the SAP account number provided');
        }
        return wrapperObj;
    }
    
    /** 
* @description : Creating this wrapper class in case service wants more unrelated Obj data in future
*/ 
    global class AccOptyWrapper {
        //Account acc;
        // Contact ContactTrialPreference;
        //DLT-20503 Changed to LowerCase Variable - Opty & AccTrialWrapper
        List < Opportunity > opty;
        AccTrialWrappercls accTrialWrapper;
        String message;
        
        AccOptyWrapper(Source_System_Detail__c acc, List < Opportunity > op, String msg) {
            //this.acc=ac;
            //*** START :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types
            if (op != null) {
                for (Opportunity tempOpp: op) {
                    tempOpp.accountId = acc.id;
                }
            }
            //*** END :: Added by Rajan :: DLT-10853 - Ensure In-Product WESTLAW notifications do not appear based on certain Proposal types 
            this.opty = op;
            //this.ContactTrialPreference=con;
            this.message = msg;
            
            if (acc != null){
                //DLT-20503 Gave If Else braces
                accTrialWrapper = new AccTrialWrappercls(acc, 'msg');
            }
            else {
                accTrialWrapper = new AccTrialWrappercls(null, 'msg');
            }
        }
    }
    
    /** 
* @description : wrapper class for trials
*/ 
    global class AccTrialWrappercls {
        //DLT-20503 Changed to LowerCase Variable - Status & TrialEligibility
        String status;
        String trialEligibility;
        String mssg;
        String accountID;
        String accountName;
        
        AccTrialWrappercls(Source_System_Detail__c acc, String m) {
            if (acc != null) {
                status = acc.Trial_Status__c;
                accountID = acc.Id;
                accountName = acc.Name;
                
                if (acc.Trial_Status__c == null){
                    //DLT-20503 Gave If Else braces
                    trialEligibility = 'true';
                }
                else {
                    String s = Label.ODT_Trial_Difference;
                    //DLT-20503 Changed to LowerCase Variable
                    Integer odtDifference = 180;
                    //DLT-20503 Gave If Else braces
                    if (s.isNumeric()){
                        odtDifference = integer.valueOf(s);
                    }
                    
                    trialEligibility = checkTrialEligibility(acc,odtDifference);
                    
                }
                mssg = m;
            } else {
                trialEligibility = null;
            }
        }
 
    /** 
* @description : method to check trial eligibility
* @param acc : Source_System_Detail__c
* @param odtDifference : Integer
* @return String
*/        
        public String checkTrialEligibility(Source_System_Detail__c acc, Integer odtDifference){
        String trialEligibility;
        for (Trial__c tr: acc.Trials__r) {
            switch on tr.Trial_Status__c{
                when 'Invited','Rep Initiated','Timed-out'{
                	trialEligibility = 'true';
                }
                when 'Accepted'{
                	trialEligibility = 'false';
                    break;
                }
                when 'Expired'{
                    //DLT-20503 Changed to LowerCase Variable
                    Integer trialDifference = tr.Trial_End_Date__c.DaysBetween(System.today());
                    system.debug(LoggingLevel.INFO,'Dates..........' + trialDifference);
                    if (trialDifference > odtDifference) {
                        trialEligibility = 'true';
                    } else {
                        trialEligibility = 'false';
                        break;
                    }
                }
            }
        }
        return trialEligibility;
    }
        
    }
 
   
}