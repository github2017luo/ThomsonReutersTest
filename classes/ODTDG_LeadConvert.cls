/*
Author : Mallikarjuna Rao
Date: Aug 2021
Description: This class is for mainly to convert Trial Leads 
@description ODTDG_LeadConvert class to convert Lead scenarios 
*/
/********************************************************************************************************
*  @description ODTDG_LeadConvert class to convert Lead scenarios 
*********************************************************************************************************/
/*
* CHANGE HISTORY
* ========================================================================================================
* Date          Name                JIRA        Description
* 2021-08-23    Brenda Shields      DCP-4144    Add SAP Account Number as a new parameter into this method
* ========================================================================================================
*/
public with sharing class ODTDG_LeadConvert {

    /********************************************************************************************************
    * @description getTrialsDetails: This is the method to return Trial details 
    * @param onepassId , expected onepass id of user 
    * @param sapAccountNumber , expected SAP/OLC account number - this will be null if few cases 
    * @param productFamily , product family
    * @return ODTDG_TrialRecord : Trial Data
    *********************************************************************************************************/ 
    public static ODTDG_TrialRecord getTrialsDetails(string onepassId, string sapAccountNumber, string productFamily){
        ODTDG_TrialRecord trialRecord;
    //Hello world
        id trialId = getTrialId(onepassId, sapAccountNumber, productFamily);
        if(trialId != null){
            LIST<Ent_Trial__c> trials = new List<Ent_Trial__c>();
            trials = getTrialDetails(trialId);

            for(Ent_Trial__c et: trials){
                trialRecord = parseTrialsDetails(et);
            }
        }
        return trialRecord;
    }

    private static LIST<Ent_Trial__c> getTrialDetails(id trialId){
       LIST<Ent_Trial__c> entTrials = new LIST<Ent_Trial__c>();
        if(Schema.sObjectType.Ent_Trial__c.isQueryable() && Schema.sObjectType.Trial_Product__c.isQueryable() && Schema.sObjectType.Ent_Trial__c.isQueryable()){
            
            entTrials = [SELECT id, Name, Lead__c, Is_Lead_Converted__c, Number_of_Days__c, Trial_Source__c, Trial_Status__c, Profile_Type__c, Trial_Start_Date__c, External_Account_Number__c, External_Account_Number_Source__c,Is_Lapsed__c,
                            (SELECT id, Name, First_Name__c, Last_Name__c, Email__c, COBALT_GUID__c, DATAROOM_GUID__c,One_Pass_ID__c,Contact_Phone__c, Status__c, External_Contact_Number__c, External_Contact_Number_Source__c,Primary__c, Profile_Type__c FROM Trial_Contacts__r ),
                            (SELECT id, name, Material_Number__c, Segment__c, Product_Offerings__c, Product_name__r.Product_Offering__c FROM Trial_Products1__r )
                            FROM Ent_Trial__c WHERE id=: trialId WITH SECURITY_ENFORCED];                         
        }
        return entTrials ;
    }

    private static ODTDG_TrialRecord parseTrialsDetails(Ent_Trial__c et){
        ODTDG_TrialRecord tr;// = new ODTDG_TrialRecord();
        system.debug(LoggingLevel.INFO,'ODTDG_TrialRecord'+tr);

        ODTDG_TrialRecord_TrialHelper trialdt = new ODTDG_TrialRecord_TrialHelper();
        system.debug(LoggingLevel.INFO,'ODTDG_TrialRecord_TrialHelper'+trialdt);
        LIST<ODTDG_TrialRecord_ContactHelper.TrialContacts> trialConList = new LIST<ODTDG_TrialRecord_ContactHelper.TrialContacts>();
        List<ODTDG_TrialRecord.TrialProdInfo> trialProdInfo = new List<ODTDG_TrialRecord.TrialProdInfo>();

        trialConList.addAll(parseTrialsContacts(et));
        trialProdInfo.addAll(parseTrialsProducts(et));

        tr = parseTrialDetails(et);
        tr.odtdgTrialDetails.trialProdInfo = trialProdInfo;
        tr.odtdgTrialDetails.trialContacts = trialConList;

        return tr;
    }

    private static ODTDG_TrialRecord parseTrialDetails(Ent_Trial__c et){
        ODTDG_TrialRecord trialrecord = new ODTDG_TrialRecord ();

        
        ODTDG_TrialRecord_TrialHelper.TrialInfo trInfo = new ODTDG_TrialRecord_TrialHelper.TrialInfo();  
        ODTDG_TrialRecord_TrialHelper.TrialAccountInfo  trAccInfo = new ODTDG_TrialRecord_TrialHelper.TrialAccountInfo();

        trInfo.trialStatus = et.Trial_Status__c;
       // trInfo.trialStartDate = et.Trial_Start_Date__c;
           if(et.Number_of_Days__c != null){
            trInfo.trialDuration = integer.valueOf(et.Number_of_Days__c);
           } 
        trInfo.trialProfileType = et.Profile_Type__c; 
        trInfo.webStore = et.Trial_Source__c;
        trInfo.trialSfId = et.id;
        trInfo.leadId = et.Is_Lead_Converted__c ==true?trInfo.leadId:et.Lead__c;        

        trAccInfo.accountNumber = et.External_Account_Number__c;
        trAccInfo.accountNumSource = et.External_Account_Number_Source__c;
        trAccInfo.isLapsed = et.Is_Lapsed__c;
        ///trAccInfo.customerSegment =  et.
       
        // odtTD = new trialrecord.odtdgTrialDetails();
        
        trialrecord.odtdgTrialDetails.trialInfo = trInfo;
        trialrecord.odtdgTrialDetails.trialAccountInfo = trAccInfo;

        return trialrecord;
    }

    private static  List<ODTDG_TrialRecord.TrialProdInfo> parseTrialsProducts(Ent_Trial__c et){
        List<ODTDG_TrialRecord.TrialProdInfo> trialProdInfo = new List<ODTDG_TrialRecord.TrialProdInfo>();

        for(Trial_Product__c tp: et.Trial_Products1__r ){
            ODTDG_TrialRecord.TrialProdInfo tpInfo = new ODTDG_TrialRecord.TrialProdInfo();
            tpInfo.productOffering = tp.Product_name__r.Product_Offering__c;
            tpInfo.trialProductNumber = tp.Material_Number__c;
            tpInfo.productSfId = tp.id;

            trialProdInfo.add(tpInfo);

        }

        return trialProdInfo;

    }

    private static LIST<ODTDG_TrialRecord_ContactHelper.TrialContacts> parseTrialsContacts(Ent_Trial__c et){
        LIST<ODTDG_TrialRecord_ContactHelper.TrialContacts> trialConList = new LIST<ODTDG_TrialRecord_ContactHelper.TrialContacts>();
        for(Trial_Contact__c tc: et.Trial_Contacts__r){
            ODTDG_TrialRecord_ContactHelper.TrialContacts cont = new ODTDG_TrialRecord_ContactHelper.TrialContacts () ;

            cont.firstName = tc.First_Name__c;
            cont.lastName = tc.Last_Name__c;
            cont.email = tc.Email__c;
            cont.trialContactSfId = tc.id;
            cont.primaryUser = tc.Primary__c;      
            cont.cobaltGUID = tc.COBALT_GUID__c; 
            cont.dataroomGUID = tc.DATAROOM_GUID__c;  
            cont.userAuthId = tc.One_Pass_ID__c;
            cont.contactNumber = tc.External_Contact_Number__c; 
            cont.contactNumSource = tc.External_Contact_Number_Source__c; 
            cont.trialStatus = tc.Status__c;
            cont.businessPhone = tc.Contact_Phone__c;
            cont.profileType = tc.Profile_Type__c;


            trialConList.add(cont);
        }
        return trialConList;
    }



    private static id getTrialId(string onepassId, string sapAccountNumber, string productFamily) {

        integer noOfTrialDays = 90;
        
        if(ODTDG_Helper.getStaticValues('ODTDG_TrialNoOfDays') != null){
            noOfTrialDays = integer.valueOf(ODTDG_Helper.getStaticValues('ODTDG_TrialNoOfDays'));
        }
        Date  trialEndDate = system.today()- noOfTrialDays;
        
        if(Schema.sObjectType.Trial_Product_Contact__c.isQueryable()){
            list<Trial_Product_Contact__c> trialProducts = new List<Trial_Product_Contact__c>();
            // added check to make sure the Trial is associated with a lead
            if (sapAccountNumber == null || sapAccountNumber == '') {    
                trialProducts = [SELECT id, Trials__c
                                 FROM Trial_Product_Contact__c 
                                 WHERE  Trial_Contact__r.One_Pass_ID__c =: onepassId AND
                                        Trials__r.Trial_End_Date__c >=: trialEndDate AND
                                        Trial_Product__r.Product_Offerings__c =:productFamily
                                 ORDER BY lastModifiedDate DESC];
            } else {
                trialProducts = [SELECT id, Trials__c 
                                 FROM Trial_Product_Contact__c 
                                 WHERE  Trial_Contact__r.One_Pass_ID__c =: onepassId AND
                                        Trials__r.Trial_End_Date__c >=: trialEndDate AND
                                        Trial_Product__r.Product_Offerings__c =: productFamily AND
                                        Trials__r.Account_SSD__c =: sapAccountNumber
                                 ORDER BY lastModifiedDate DESC];
            }
            if(!trialProducts.isEmpty()){
                return trialProducts[0].Trials__c;
            }else{
                return null;
            }
        }
        return null;
        
    }
     
     
     
     private static void checkConvertedDetails(List<id> leadIds){
        MAP<id, Lead> leadsList = new MAP<id, Lead>();
        LIST<Ent_Trial__c> trials = new LIST<Ent_Trial__c>();

       if(Schema.sObjectType.lead.isQueryable() && Schema.sObjectType.Ent_Trial__c.isQueryable()){
         
            leadsList =new MAP<ID, Lead>([SELECT id, name, isConverted, convertedOpportunityId, convertedAccountId, 
                                            (SELECT id, Name, Lead__c FROM Trials1__r) FROM Lead where ID IN: leadIds AND convertedOpportunityId != null
                                            ] );
        }

        for(Lead l: leadsList.values()){
            for(Ent_Trial__c t: l.Trials1__r){
               trials.add(new Ent_Trial__c(id=t.id, Opportunity__c=l.convertedOpportunityId, Account__c=l.convertedAccountId));
            }
        }

        LIST<Database.SaveResult> updateResults = Database.Update(trials, FALSE);
        system.debug(LoggingLevel.INFO,'updateResults............'+updateResults);

    }

    /********************************************************************************************************
    *  @description processLeadTrigger: This is the method to perform lead convert details  
    * @param newLeadsMap , expected new lead ids 
    * @param oldLeadMap , expected old lead ids 
    *********************************************************************************************************/ 
    public static void processLeadTrigger(MAP<id, Lead> newLeadsMap, MAP<id, Lead> oldLeadMap){
        List<id> convertedIds = new List<id>();
        
        for(Lead l: newLeadsMap.values()){
            if(l.isConverted && !oldLeadMap.get(l.id).isConverted){
                convertedIds.add(l.id);
            }
        }
       
       if(!convertedIds.isEmpty()){
           ODTDG_LeadConvert.checkConvertedDetails(convertedIds);
       }  
    }
}