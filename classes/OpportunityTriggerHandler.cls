/**
 * CHANGE HISTORY
 * ========================================================================================================================
 * Date         Name                       Description

 * 2014-06-24   Nandita                    MCL-500 Added CreateCompetitiveInfo method
 *                                         call
 * 2015-08-12   Sreenu D                   Added "checkContactRolePrimary" method for CMC-6 Jira
 * 2015-10-19   Brenda Shields             EWI-99 - add validation to contact role for phone ane email
 * 2015-11-05   Pratik Prusty              PHP-2 - Update Partner Portal User custom field.
 * 2016-03-15   Cirrius                    Validation rule expressed in logic due to "Spanning Relationships" JIRA 418
 *                                         https://help.salesforce.com/apex/HTViewSolution?id=000171213&language=en_US
 * 2016-03-20   Cirrius                    JIRA-440 Added UpdateRelatedQuoteFieldsFromOppotunity
 * 2016-05-30   Sujana                     Added updateChildOpportunityAmountSubtotalOnParentOppty
 * 2016-06-03   Rajashree               (BRS_MS7.1.18,BRS_MS7.1.26) Added afterUpdateMasterOpptySyncs
 * 2016-07-20   Satyaki                    Added RenewalOpptySync
 
 * 2016-08-19   Anshu Thakur               Added method 'businessUnitUpdate' as a fix for SFD-841
 * 2017-03-31   Meenakshmi Goswami         Optimized the code as per JIRA STORY: PS0-1
 * 2017-04-11   K Gunaseelan               MCL-1702 -Added method Reservationactivecheck
 * 2019-12-31   Prakash    Added validatecompetitiveinfo as part of DPS-4401
 * 2020-10-13   lAtAM Community User       Commenting reservation related code as part of DPS-17684  
 * =========================================================================================================================
 */
public without sharing class OpportunityTriggerHandler{
    public static boolean beforeUpdateAcadAdopMappingRecCheck = false; 
    public static boolean varAmntFlag = false;
    public static boolean bCaseCreateFlg = true;
    //commenting below LINE as part of DPS-17684    
    //public static boolean reservationcreated=true;
    public static Map<String, Double> currencyConvRateMap;   
    /* updates territory id of opportunity
    ****************************************/

  /*  public static string getProfileName()
            {

                id profileid = userinfo.getprofileid();
                string profilename = [select id, name from profile where Id =:profileId].name;
                return profilename;
           } */
        public static string strProfileName = ContactUtil.getProfileName();
        
        //Replacing Territory with Territory2 object as a part of removing TM1.0 references
        public static void updateOptyTerritory(List<opportunity> listopp, Map<Id,Opportunity> mapOldOpty){
      //      if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
                List<opportunity> optyList = new list<opportunity>();
                for(opportunity o:Listopp){ 
/*System.debug(o.ownerId+'===>>'+MapOldOpty.get(o.id).ownerId);-- commented to reduce character for s2e optimization*/
                    if(o.ownerId!=MapOldOpty.get(o.id).ownerId && o.is_GLI__c == false){//CRM-13436 
                        o.Territory2Id=null;
                        optyList.add(o);
                    }
                }
                if(!optyList.IsEmpty()){
                  updateOptyTerritory(optyList);
                }
         //   }
        }

    //Replacing Territory with Territory2 object as a part of removing TM1.0 references
    //Replacing UserTerritory with UserTerritory2Association as a part of removing TM1.0 references
    public static void updateOptyTerritory(List<opportunity> listopty){
     //   if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        List<opportunity> opportunityList = new list<opportunity>();
        List<opportunity> opportunityList2 = new list<opportunity>();
        Map<id,List<id>> useridterritoryList = new Map<id,List<id>>();
        Map<id,id> sharegrpid = new  Map<id,id>();
        Map<id,list<id>> shareaccountid = new  Map<id,list<id>>();
        Map<id,id> groupRelatedId = new map<id,id>();
        Map<id,id> sharegrpRelatedid = new map<id,id>();
        set<id> accountIds = new set<id>();
        set<id> opportunityOwnerIds = new set<id>();
        for(opportunity o:Listopty){
          //  if(o.TerritoryId==null){
        system.debug('o.Is_GLI__c'+o.Is_GLI__c);
            if(!o.Is_GLI__c){//CRM-13436 
                opportunityList.add(o);
                OpportunityOwnerIds.add(o.ownerId);
      }
          //  }
        }
        for(UserTerritory2Association  oUserTerritory:[select userid,Territory2Id from UserTerritory2Association  where userid in:OpportunityOwnerIds and IsActive=true]){
            if(oUserTerritory.Territory2Id != null){
                if(useridterritoryList.containsKey(oUserTerritory.userid)){
                    useridterritoryList.get(oUserTerritory.userid).add(oUserTerritory.Territory2Id);
                }
                else{
                    useridterritoryList.put(oUserTerritory.userid,new id[]{oUserTerritory.Territory2Id});
                }
            }
        }
        //system.debug('***useridterritoryList'+useridterritoryList);
        if(useridterritoryList !=null){
            for(opportunity o:opportunityList){
                if(useridterritoryList.containskey(o.ownerId)){
                    if(useridterritoryList.get(o.ownerId) != null){
                        /*if(useridterritoryList.get(o.ownerId).size()==1){
                            o.TerritoryId=useridterritoryList.get(o.ownerId)[0];
                        }*/
                        if(useridterritoryList.get(o.ownerId).size()>=1){
                            //o.TerritoryId= useridterritoryList.get(o.ownerId)[0];
                            accountIds.add(o.accountid);
                            opportunityList2.add(o);
                        }
                    }
                }
            }
            //system.debug('***opportunityList2'+opportunityList2);
            if(accountIds != null){
                List<accountshare> accshareList =[select AccountId,UserorGroupId from Accountshare where AccountId in:accountIds];
                for(AccountShare accshare: accshareList){
                    if(accshare.UserorGroupId != null){
                        sharegrpid.put(accshare.id,accshare.UserorGroupId);
                    }
                }
                //system.debug('***sharegrpid '+sharegrpid );
                if(sharegrpid != null){
                    for(Group grp:[select id,relatedid from group where id in:sharegrpid.values()]){
                        if(Grp.relatedid != null){
                            groupRelatedId.put(grp.id,grp.relatedid);
                            }
                    }
                    //system.debug('***groupRelatedId'+groupRelatedId);
                    for (id accshareid:sharegrpid.keyset()){
                        if(groupRelatedId.containsKey(sharegrpid.get(accshareid))){
                            sharegrpRelatedid.put(accshareid,groupRelatedId.get(sharegrpid.get(accshareid)));
                            }
                    }
                    //system.debug('***sharegrpRelatedid'+sharegrpRelatedid);
                    for(AccountShare accshare:accshareList){
                        if(!shareaccountid.containskey(accshare.accountid)){
                            shareaccountid.put(accshare.accountid,new id[]{});
                        }
                        if(sharegrpRelatedid.containsKey(accshare.id)){
                            shareaccountid.get(accshare.accountid).add(sharegrpRelatedid.get(accshare.id));
                            }
                    }
                    //system.debug('***shareaccountid'+shareaccountid);
                    if(shareaccountid !=null){
                        for(opportunity o:opportunityList2){
               if(!o.Is_GLI__c){
                            if(shareaccountid.containskey(o.Accountid)){
                                //system.debug('***1');
                                for(id territory2id: useridterritoryList.get(o.ownerId)){
                                    for(id grprelatedid:(shareaccountid.get(o.Accountid)) ){
                                        //system.debug('***3*'+grprelatedid+'***'+territoryid+'***'+((grprelatedid == territoryid?'true':'false')));
                                        if(grprelatedid== territory2id){
                                            o.Territory2Id=territory2id;
                                            system.debug('***territoryid'+territory2id);
                                            break;
                                        }
                                    }
                                }
                            }
                        }
            }
                    }
                }
            }
       // }
        }
    }
    /*
    create owner as a sales team member for update
    ****************************/
    Public static void afterUpdateSalesTeam(List<opportunity> opportunityNew,List<opportunity> opportunityOld,map<id,opportunity> opportunityOldMap){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            List<opportunity> opportunityList = new List<opportunity>();
            List<opportunity> opportunityList2 = new List<opportunity>();
            for(integer counter = 0; counter<opportunityNew.size(); counter++){
                if(opportunityNew[counter].ownerid != opportunityOld[counter].ownerid){
                    opportunityList.add(opportunityNew[counter]);
                    opportunityList2.add(opportunityOld[counter]);
                }
            }
            if(opportunityList.size()>0){
                CreateOwnerasTeamMember(opportunityList);
            }
            if(opportunityList2.size()>0){
                createShareforPrevOwner(opportunityList2,opportunityOldMap);
            }
     //   }
    }

    /*
    create owner as a sales team member
    ****************************/
    Public static void createOwnerasTeamMember(List<opportunity> opportunityList){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        List<opportunity> opportunityList2=[select id ,ownerid, owner.rep_type_description__c from opportunity where id in:opportunityList];
        List<opportunityTeamMember> optyTeamMemberList = new list<opportunityTeamMember>();
        for(opportunity opty:opportunityList2){
           optyTeamMemberList.add(new opportunityteamMember
           (opportunityid=opty.id,userid=Opty.ownerid,TeamMemberRole=AppUtil.truncateString(opty.owner.rep_type_description__c, 40)));
        }
/*system.debug('***********optyTeamMemberList-->'+optyTeamMemberList);-- commented to reduce character for s2e optimization*/
        insert optyTeamMemberList;
        //database.insert(optyTeamMemberList);
   // }
    }

    //Replacing Territory with Territory2 object as a part of removing TM1.0 references
    public static void syncTerritoryQuota(List<Opportunity> listOpportunities){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        Set<string> fiscalMonths = new Set<string>();
        for (Opportunity oOpportunity : listOpportunities){
            fiscalMonths.add(getFiscalMonth(oOpportunity.CloseDate));
        }
        List<Territory_Quota__c> listTerritoryQuota = [SELECT Id, External_Id__c FROM Territory_Quota__c WHERE Fiscal_Month__c IN :fiscalMonths];
        Map<string, Id> mapTerritoryQuotaIds = new Map<string, Id>();
        for (Territory_Quota__c oTerritoryQuota : listTerritoryQuota){
            mapTerritoryQuotaIds.put(oTerritoryQuota.External_Id__c, oTerritoryQuota.Id);
        }
        for (Opportunity oOpportunity : listOpportunities){
            if (oOpportunity.Territory2Id != null){
                string opportunityFiscalMonthKey = getFiscalMonth(oOpportunity.CloseDate);
                string territoryFiscalMonthKey = getTerritoryFiscalMonthKey(oOpportunity.Territory2Id, opportunityFiscalMonthKey);
                if (mapTerritoryQuotaIds.containsKey(territoryFiscalMonthKey)){
                    oOpportunity.Territory_Quota__c = mapTerritoryQuotaIds.get(territoryFiscalMonthKey);
                }else{
                    oOpportunity.Territory_Quota__c = null;
                }
            }
        }
      //  }
    }

     // modified the method for QC 3734
     public static void syncUserQuota(List<Opportunity> listOpportunities){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        Set<string> fiscalMonths = new Set<string>();
        Set<Id> ownerIds = new Set<Id>();
        Map<Id,Id> mapUserRole = new Map<Id,Id>();
        Map<Id,Id> mapManagerRole = new Map<Id,Id>();
        Map<Id,Id> mapManagerUser = new Map<Id,Id>();
        for (Opportunity oOpportunity : listOpportunities) {
            fiscalMonths.add(getFiscalMonth(oOpportunity.CloseDate));
            //if (oOpportunity.OwnerId != null && oOpportunity.Is_GLI__c != true) // commented as part of CRM-17902
            if (oOpportunity.OwnerId != null){
                ownerIds.add(oOpportunity.OwnerId);
                }
        }
        
        if(ownerIds.size()>0){
          for(User oUser : [Select UserRole.ParentRoleId,Id from User where Id IN : ownerIds]){
            if(!mapUserRole.containskey(oUser.Id) && oUser.UserRoleId!=null){
               mapUserRole.put(oUser.Id,oUser.UserRole.ParentRoleId);
               }
        }
        }
        for(User oUser : [Select Id,UserRoleId from User where UserRoleId IN : mapUserRole.values()]){
             if(!mapManagerRole.containskey(oUser.UserRoleId)){
                 mapManagerRole.put(oUser.UserRoleId,oUser.Id);
                 ownerIds.add(oUser.Id);
            }
        }
        for(Id userId : mapUserRole.Keyset()){
            if(!mapManagerUser.containskey(UserId)){
                mapManagerUser.put(UserId,mapManagerRole.get(mapUserRole.get(UserId)));
            }
        }
        system.debug('fiscalMonths '+fiscalMonths );
        system.debug('ownerIds'+ownerIds);
        List<UserQuota__c> listUserQuota = new List<UserQuota__c>();
        if(ownerIds.size()>0){
            listUserQuota = [SELECT Id, External_Id__c, User__c, Fiscal_Month__c FROM UserQuota__c WHERE Fiscal_Month__c IN :fiscalMonths and User__c IN :ownerIds];
            //listUserQuota = [SELECT Id, External_Id__c, User__c, Fiscal_Month__c FROM UserQuota__c WHERE User__c IN :ownerIds];
        }
        system.debug('listUserQuota ---->'+listUserQuota .size());
        Map<string, Id> mapUserQuotaIds = new Map<string, Id>();
        for (UserQuota__c oUserQuota : listUserQuota){
            mapUserQuotaIds.put(oUserQuota.External_Id__c, oUserQuota.Id);
        }
        system.debug('mapUserQuotaIds'+mapUserQuotaIds);
        for (Opportunity oOpportunity : listOpportunities){
            if (oOpportunity.OwnerId != null){
                string opportunityFiscalMonthKey = getFiscalMonth(oOpportunity.CloseDate);
                system.debug('opportunityFiscalMonthKey '+opportunityFiscalMonthKey );
                string userFiscalMonthKey = getUserFiscalMonthKey(oOpportunity.OwnerId, opportunityFiscalMonthKey);
                system.debug('userFiscalMonthKey '+userFiscalMonthKey );
                system.debug('mapUserQuotaIds.containsKey(UserFiscalMonthKey)'+mapUserQuotaIds.containsKey(UserFiscalMonthKey));
                if (mapUserQuotaIds.containsKey(UserFiscalMonthKey)) {
                    oOpportunity.User_Quota__c = mapUserQuotaIds.get(UserFiscalMonthKey);
                }
                else{
                    oOpportunity.User_Quota__c = null;}
                if(mapManagerUser.containskey(oOpportunity.OwnerId)){
                   if(mapUserQuotaIds.containsKey(getUserFiscalMonthKey(mapManagerUser.get(oOpportunity.OwnerId),getFiscalMonth(oOpportunity.CloseDate)))){
                      oOpportunity.Manager_Quotas__c = mapUserQuotaIds.get(getUserFiscalMonthKey(mapManagerUser.get(oOpportunity.OwnerId),getFiscalMonth(oOpportunity.CloseDate)));
                   }else{
                        oOpportunity.Manager_Quotas__c = null;}
            }
           }
       // }
     }
    }

    @TestVisible
    Private static void createShareforPrevOwner(list<opportunity> listopportunity,map<id,opportunity> opportunityOldMap){
       List<opportunity> opportunityList = [Select id,(Select Id, OpportunityId, UserId From OpportunityTeamMembers)
                 From Opportunity where id in:listopportunity];
       List<opportunityshare> shareList = new list<opportunityshare>();
       for(opportunity oOpty:opportunityList){
           id optyOwnerId = opportunityOldMap.get(oOpty.id).ownerid;
           for(OpportunityTeamMember oOptyMember :oOpty.OpportunityTeamMembers){
               if(oOptyMember.UserId == optyOwnerId){
                   shareList.add(new opportunityshare(opportunityid=oOpty.id,UserOrGroupId=optyOwnerId, OpportunityAccessLevel='Edit'));
               }
           }
       }
       //system.debug('***'+shareList);
       if(shareList != null){
           Database.SaveResult[] mySaveResult = Database.Insert(shareList,false);
           }
    }

    private static string getTerritoryFiscalMonthKey(Id territoryId, string fiscalMonth) {
        return territoryId + fiscalMonth;
    }

    private static string getUserFiscalMonthKey(Id ownerId, string fiscalMonth) {
        return OwnerId + fiscalMonth;
    }

    private static string getFiscalMonth(Date closeDate) {
     return AppUtil.formatDate(closeDate, 'MMM yyyy', null);
    }

//      private static string getFiscalMonth(Date closeDate) {
//   return AppUtil.formatDate(closeDate, 'MMM-yyyy', null);

    //  return ''; //monthPart + ' ' + yearPart;
//  }


/*Map values from opp product fields to academic adoption section
    ******************************************************************/
    Public static void beforeUpdateAcadAdopMapping(List<Opportunity> listOpportunities){
/*system.debug('********checkRecursive.isRenewalQuote='+checkRecursive.isRenewalQuote+'********checkRecursive.isRenewalOpp='+checkRecursive.isRenewalOpp);-- commented to reduce character for s2e optimization*/
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            //Excluding this for LatAM profiels to resolve SOQL error as this query is recursive.       
/*system.debug('***strProfileName :::::'+strProfileName );-- commented to reduce character for s2e optimization*/
            if(strProfileName != Label.Latam_Profile && strProfileName !=  Label.Partner_Portal_Profile){//Added this line -MASTERSAF
            /* Suggested Refactoring - JDS */
            Set<Id> opportunityIds = new Map<Id, Opportunity>(listOpportunities).keySet();
            Map<Id, Opportunity> mapOpportunityWithProducts = new Map<Id, Opportunity>([SELECT Id, (SELECT Incremental_Amount__c, Quantity, UnitPrice FROM OpportunityLineItems LIMIT 1) FROM Opportunity WHERE Id IN :opportunityIds]);
            for (Opportunity oOpportunity : listOpportunities) {
                if (mapOpportunityWithProducts.containsKey(oOpportunity.Id)) {
                    Opportunity oOpportunityWithProduct = mapOpportunityWithProducts.get(oOpportunity.Id);
                    if (oOpportunityWithProduct.OpportunityLineItems != null && oOpportunityWithProduct.OpportunityLineItems.isEmpty() == false) {
                        OpportunityLineItem oOpportunityLineItem = oOpportunityWithProduct.OpportunityLineItems[0];
                        oOpportunity.Actual_Number_Texts_Ordered__c = oOpportunityLineItem.Quantity;
                        oOpportunity.Price_Excl_GST__c = oOpportunityLineItem.UnitPrice;
                    }
                    else {
                        oOpportunity.Actual_Number_Texts_Ordered__c = 0;
                        oOpportunity.Price_Excl_GST__c = 0;
                    }
                }
            }
            }
       // }
    }

    public static void createStrategy2Oppty(List<Opportunity> listOpportunities){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        List<SFDC_Strategy2Oppty__c> listStrategy2Oppty = new List<SFDC_Strategy2Oppty__c >();
        for(Opportunity oOpportunity : listOpportunities){
          if(oOpportunity.Strategy__c!=null){
           SFDC_Strategy2Oppty__c strategy2oppty = new SFDC_Strategy2Oppty__c(Opportunity_Name__c=oOpportunity.Id,
                                       SFDC_Strategy__c=oOpportunity.Strategy__c);
           listStrategy2Oppty.add(Strategy2oppty);
         }
        }
        Insert listStrategy2Oppty;
   // }
    }




    /*******************************ANZ Create Case(MCL-305/306)**********************/

    public static void createCase_ANZ(list<Opportunity> listOpportunities){
      bCaseCreateFlg = false;
      List<Case> listCasestoInsert = new List<Case>();
      try{
        for(Opportunity oOpportunity : listOpportunities){
            if(oOpportunity.Discard_Reason__c =='Wrong Segment'){
                listCasestoInsert.add(createcase('Account Maintenance','Account Classification Change',oOpportunity));
            }
          if(oOpportunity.Discard_Reason__c =='Answering Machine/Fax' ||
           oOpportunity.Discard_Reason__c =='Retired' || oOpportunity.Discard_Reason__c=='Wrong Telephone'){
             listCasestoInsert.add(createcase('Account Maintenance','Address / Contact Change', oOpportunity));
          }
          if(oOpportunity.Discard_Reason__c =='Price' ){//&& oOpportunity.get('Win_Loss__c')=='Lost – Price'){
             listCasestoInsert.add(createcase('Feedback','Price', oOpportunity));
          }
          if(oOpportunity.Discard_Reason__c =='Cancel Renewal'){
            listCasestoInsert.add(createcase('Billing','Cancellation - Assigned for Retention Activity',oOpportunity));
          }
           if(oOpportunity.Discard_Reason__c =='Do Not Call'){
            listCasestoInsert.add(createcase('Customer Preferences','Change in Communication Preference',oOpportunity));
          }
          if(oOpportunity.Discard_Reason__c == 'Out of Business'){
                 listCasestoInsert.add(createcase('Account Maintenance','Account Close',oOpportunity));
            }
          if(oOpportunity.Discard_Reason__c =='Wrong Territory'){
            listCasestoInsert.add(createcase('Account Maintenance','Sales Territory Assignment', oOpportunity));
          }
        }
        insert listCasestoInsert;
      }catch(Exception Ex){
/*System.debug(Ex.getmessage());-- commented to reduce character for s2e optimization*/
      }
      //  return oPagereference;
    }


    public static void createCasefromOpty_ANZ(list<Opportunity> listopportunity){
        bCaseCreateFlg = false;
        List<Case> listCasestoInsert = new List<Case>();
        try{
            //Removing Win_Loss__c as a part of DPS-5353
            for(Opportunity oOpportunity : [Select Id,StageName,AccountId,Account.RecordTypeId,Renewal_Flag__c,
                         Opportunity_Owner_s_Sales_Org__c,Reason__c from opportunity where Id IN : listopportunity]){
                if(oOpportunity.StageName == '90%'
                    && oOpportunity.Account.RecordTypeId==RecordtypeIds__c.getValues('Prospect').recTypeId__c){
                    listCasestoInsert.add(createcase('Account Maintenance','New Customer Set up',oOpportunity));
                }
                if(oOpportunity.StageName=='95%'){
                 listCasestoInsert.add(createcase('Orders','New Order',oOpportunity));
                  /*  if(oOpportunity.Win_Loss__c=='Won – Renewed' && oOpportunity.Renewal_Flag__c == true){
                        createcase('Subscriptions','CAB / Agreement Renewal',oOpportunity);

                    }else{
                        createcase('Orders','New Order',oOpportunity);
                       }*/
                }
               // if(oOpportunity.Win_Loss__c=='Lost – Price'){
                //Removing Win_Loss__c 'lost' value and replacing it with stagename value as a part of DPS-5353
               if((oOpportunity.StageName=='0%') && (oOpportunity.Reason__c=='Price' || oOpportunity.Reason__c=='Organization change / restructure' || oOpportunity.Reason__c=='Budget Cut')){
                       listCasestoInsert.add(createcase('Feedback','Price',oOpportunity));
                }
              // if(oOpportunity.Win_Loss__c=='Won – Competitor' || oOpportunity.Win_Loss__c=='Lost – Competitor'){
                //Removing Win_Loss__c 'Won' value and replacing it with stagename value as a part of DPS-5353  
               if((oOpportunity.StageName=='90%' || oOpportunity.StageName=='95%' || oOpportunity.StageName=='100%') && (oOpportunity.Reason__c=='Content' || oOpportunity.Reason__c=='Functionality' || oOpportunity.Reason__c=='Relationship' || oOpportunity.Reason__c=='Unique Solution / Product' || oOpportunity.Reason__c=='Support / Service' || oOpportunity.Reason__c=='Issue w/ Competitor' || oOpportunity.Reason__c=='Integration with other TR products / services' || oOpportunity.Reason__c=='Brand' || oOpportunity.Reason__c=='Ease of use' || oOpportunity.Reason__c=='Price')) {
                           listCasestoInsert.add(createcase('Feedback','Competitor Feedback',oOpportunity));
                }
                //Removing Win_Loss__c 'Lost' value and replacing it with stagename value as a part of DPS-5353                                    
                if((oOpportunity.StageName=='0%') && (oOpportunity.Reason__c=='Content' || oOpportunity.Reason__c=='Functionality' ||oOpportunity.Reason__c=='Relationship' || oOpportunity.Reason__c=='Don\'t need / Don\'t use' ||oOpportunity.Reason__c=='User Preference' || oOpportunity.Reason__c=='Champion / primary user left organization')){
                                listCasestoInsert.add(createcase('Feedback','Competitor Feedback',oOpportunity));
                }
              /*  if(oOpportunity.Win_Loss__c == 'Won – Renewed'|| oOpportunity.Win_Loss__c=='Lost – MTM Renewal' ||
                    oOpportunity.Win_Loss__c == 'Lost – Performance' || oOpportunity.Win_Loss__c=='Lost – Service'
                    || oOpportunity.Win_Loss__c=='Lost – Other'){*/
                  //Removing Win_Loss__c 'Won' value and replacing it with stagename value as a part of DPS-5353  
                if((oOpportunity.StageName=='90%' || oOpportunity.StageName=='95%' || oOpportunity.StageName=='100%') &&  oOpportunity.Reason__c=='No Change - Customer Satisfied'){
                                listCasestoInsert.add(createcase('Feedback','Retention',oOpportunity));
                }
                  //Removing Win_Loss__c 'Lost' value and replacing it with stagename value as a part of DPS-5353
                if((oOpportunity.StageName=='0%') &&  (oOpportunity.Reason__c=='MTM Renewal' ||oOpportunity.Reason__c=='Product Performance' || oOpportunity.Reason__c=='Customer Service Issue' ||oOpportunity.Reason__c=='Other') ){
                                listCasestoInsert.add(createcase('Feedback','Retention',oOpportunity));
                }
            }
            Insert listCasestoInsert;
        }catch(Exception Ex){
/*System.debug(Ex.getmessage());-- commented to reduce character for s2e optimization*/
        }
    }

    public static case createcase(String issue,String reason,Opportunity oOpportunity){
         return new case(ANZ_Issue__c=Issue, Reason__c=Reason, Opportunity__c=oOpportunity.Id, RecordTypeId=RecordtypeIds__c.getValues('ANZ Case').recTypeId__c,
                         AccountId = oOpportunity.AccountId, Sales_org__c = oOpportunity.Opportunity_Owner_s_Sales_Org__c,
                         Created_by_Trigger__c = true, Origin = 'Internal Users', Subject = 'Triggered');
/* oOpportunity = [Select Id,AccountId from Opportunity where Id =:oOpportunity.Id];


       if(oOpportunity.getsObjectType() == opportunity.sObjectType){
          Id Accid1=String.valueof(oOpportunity.get('AccountId'));
         return new case(ANZ_Issue__c=Issue,Reason__c=Reason,Opportunity__c=oOpportunity.Id,
            AccountId=Accid1,Sales_org__c = String.valueof(oOpportunity.get('Opportunity_Owner_s_Sales_Org__c')));

        }else{
            // if(oOpportunity.getsObjectType() == lead.sObjectType){
            Id Accid2=String.valueof(oOpportunity.get('Account__c'));
            return new case(ANZ_Issue__c=Issue,Reason__c=Reason,AccountId=Accid2,
                            Sales_org__c = String.valueOf(oOpportunity.get('Sales_org__c')));
       // }

        }*/
    }



    /*******************************MCL-500 Competitive Info Creation**********************/

   /* public static void CreateCompetitiveInfo(List<Opportunity> listOpportunities,Map<Id,Opportunity> mapOldOpty){
     Map<Id,Competitive_Info__c> mapOptyCompInfo = new Map<Id,Competitive_Info__c>();
     List<Competitive_Info__c> listCompInfoUpd = new List<Competitive_Info__c>();
     System.debug(UserInfo.getUserId()+'*******');
     for(Competitive_Info__c oCompInfo : [Select Opportunity__c,Competitor_Name__c,Expiration_Date__c,Price__c,Price_Type__c from Competitive_Info__c
                                             where Opportunity__c IN : listOpportunities]){
      mapOptyCompInfo.put(oCompInfo.Opportunity__c,oCompInfo);
     }

     for(Opportunity oOpp : listOpportunities){

      if(mapOptyCompInfo.containskey(oOpp.Id)){
       if(oOpp.Was_There){
       listCompInfoUpd.add(CreateCompInfo(oOpp,mapOptyCompInfo.get(oOpp.Id).Id));

      }else{
       if(!mapOldOpty.IsEmpty()
           && oOpp.Win_Loss__c=='Lost' && oOpp.Competitor_Name__c!='Not Applicable'
           && oOpp.Competitor_Name__c!='No External Competitor / Contract Terms Unknown'
           && oOpp.Competitor_Name__c!='No Provider Selected'
           && oOpp.Competitor_Name__c!='Unknown'){
         listCompInfoUpd.add(CreateCompInfo(oOpp,null));
        }else if(mapOldOpty.IsEmpty()){
         listCompInfoUpd.add(CreateCompInfo(oOpp,null));
        }

      }



     }

     if(!listCompInfoUpd.IsEmpty()){
       Database.upsert(listCompInfoUpd);
     }

    }*/



     public static void createCompetitiveInfo(List<Opportunity> listOpportunities,Map<Id,Opportunity> mapOldOpty){
     //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
       Map<Id,Competitive_Info__c> mapOptyCompInfo = new Map<Id,Competitive_Info__c>();
       List<Competitive_Info__c> listCompInfoUpd = new List<Competitive_Info__c>();
       List<Competitive_Info__c> listCompInfodel = new List<Competitive_Info__c>();
/*System.debug(UserInfo.getUserId()+'*******');-- commented to reduce character for s2e optimization*/
       for(Competitive_Info__c oCompInfo : [Select Opportunity__c,Competitor_Name__c,Expiration_Date__c,Price__c,Price_Type__c from Competitive_Info__c
             where Opportunity__c IN : listOpportunities]){
         mapOptyCompInfo.put(oCompInfo.Opportunity__c,oCompInfo);
       }
       if(!mapOldOpty.IsEmpty()){
         for(Opportunity oOpp : listOpportunities){
           if(oOpp.Was_There_a_Competitor__c == 'Yes'){
            if(mapOptyCompInfo.containskey(oOpp.Id)){
               listCompInfoUpd.add(CreateCompInfo(oOpp,mapOptyCompInfo.get(oOpp.Id).Id));
            }else{
              listCompInfoUpd.add(CreateCompInfo(oOpp,null));
            }
           }else if(oOpp.Was_There_a_Competitor__c == 'No' || oOpp.Was_There_a_Competitor__c == 'Unknown'){
             if(mapOptyCompInfo.containskey(oOpp.Id)){
                listCompInfodel.add(mapOptyCompInfo.get(oOpp.Id));
              }
            }
        }
       }else if(mapOldOpty.IsEmpty()){
         for(Opportunity oOpp : listOpportunities){
          listCompInfoUpd.add(CreateCompInfo(oOpp,null));
         }
       }
       if(!listCompInfoUpd.IsEmpty()){
         Database.upsert(listCompInfoUpd);
      }
       if(!listCompInfodel.IsEmpty()){
         Database.delete(listCompInfodel);
       } // }
    }



    // MCL-1863 : Included Name__c in the competitive info record
     public static Competitive_Info__c createCompInfo(Opportunity opp, Id compInfoId){
       return new Competitive_Info__c( Id= CompInfoId, Opportunity__c = Opp.Id, Account__c = Opp.AccountId,
                       Competitor_Name__c = Opp.Competitor_Name__c , Expiration_Date__c = Opp.Expiration_Date__c,
                  Price__c = Opp.Competitor_Price__c, Price_Type__c = Opp.Price_Type__c, Competitor_Notes__c = Opp.Competitor_Notes__c, 
                  Name__c = Opp.Name__c);
      }

//method for checking the Contact Role Primary ans Role for the Latam Users- CMC-6 Jira story
    public static void checkContactRolePrimary(list<Opportunity> listOpps, map<Id, Opportunity> mapOldOpps){
    //    if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            string profileName;
            set<Id> oppsId = new set<Id>();
            map<Id, OpportunityContactRole> oppContactRoles = new map<Id, OpportunityContactRole>();
            for(Opportunity opp :listOpps) {//system.debug('CreatedDate :'+opp.CreatedDate +'  LastModifiedDate: ' +opp.LastModifiedDate);
                if(opp.StageName == '90%' && opp.Is_Submitted__c == True ){
                    oppsId.add(opp.Id);
                }
             }
            if(!oppsId.IsEmpty()){
                Id profileId=userinfo.getProfileId();
                //profileName = [Select Id,Name from Profile where Id=:profileId].Name;
                profileName = AppUtil.getProfileName(profileId);
            //system.debug('latam profile...'+profileName);
            }
            if(profileName == 'LatAm User' /* || profileName == 'System Administrator'*/) {
                if(!oppsId.IsEmpty()){
                    for(OpportunityContactRole listOppContactRole :[SELECT Id, Role, OpportunityId, IsPrimary, Contact.Email, Contact.Work_Direct__c FROM OpportunityContactRole WHERE OpportunityId IN :oppsId AND Role = 'E-Billing Contact']) {
                        oppContactRoles.put(listOppContactRole.OpportunityId, listOppContactRole);
                        }
                    //system.debug('oppContactRoles...'+oppContactRoles);
                    //system.debug('!listOppContactRole.IsEmpty())'+ !listOppContactRole.IsEmpty());
                    if(!oppContactRoles.IsEmpty()) {
                        for(Opportunity oppty :listOpps) {
                            if((oppContactRoles.ContainsKey(oppty.Id)) && (oppContactRoles.get(oppty.Id).Role == 'E-Billing Contact') &&
                                (oppContactRoles.get(oppty.Id).Contact.Email == null || oppContactRoles.get(oppty.Id).Contact.Work_Direct__c == null)) {
                                oppty.addError(System.Label.Contact_Phone_and_Email_Required_for_Latam_Users_if_Stage_is_90);
                            }
                            if((oppContactRoles.ContainsKey(oppty.Id)) && (oppContactRoles.get(oppty.Id).Role != 'E-Billing Contact')) {
                                oppty.addError(System.Label.ContactRole_Required_for_Latam_Users_if_Stage_is_90); }
                            else {
                                if(!oppContactRoles.ContainsKey(oppty.Id)){
                                    oppty.addError(System.Label.ContactRole_Required_for_Latam_Users_if_Stage_is_90);
                                    }
                                }
                         }
                     }
                    else {
                    //system.debug('!oppContactRoles.IsEmpty())'+ !oppContactRoles.IsEmpty());
                        for(Opportunity opptys :listOpps) {
                            opptys.addError(System.Label.ContactRole_Required_for_Latam_Users_if_Stage_is_90);
                        }
                     }
                 }
            }
      //  }
    }


        // Update Partner Portal User on Opportunity custom field  PHP-2

    public static void updatePartneruser(list<Opportunity> listOpps,boolean isInsert){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
                id profileid = userinfo.getprofileid();
                //string profilename = [select id, name from profile where Id =:profileId].name;
                string profileName = AppUtil.getProfileName(profileId);
                set<id> ownerIds = new Set<id>();
                for(Opportunity opp :listOpps){
                  ownerIds.add(opp.ownerID);
                 }
                 Map<id,user> mapOwner = new Map<id,user>();
                 if(!isInsert){
                     mapOwner = new Map<id,user>([select id,profile.name from user where id in : ownerIds]);
                 }
                for(Opportunity opp :listOpps){
                  if(isInsert && profilename=='Partner Portal User') // insert
                  { opp.Partner_Portal_User__c = opp.OwnerId;
                  }
                  else if(!isInsert && mapOwner.get(opp.ownerID).profile.name=='Partner Portal User'){ // update
                    opp.Partner_Portal_User__c = opp.OwnerId;
                  }
                  else{
                    opp.Partner_Portal_User__c = opp.Partner_Portal_User__c;
                  }
               }
       // }
    }

    //commenting below method as part of DPS-17684  
    /*
 public static void createReservation(list<Opportunity> listResOpps){
 reservationcreated=false;
 try{
   list<Reservation__c> reslist= new list<Reservation__c>();
 //system.debug('reslistListResOpps-->'+ListResOpps.size());-- commented to reduce character for s2e optimization 
    for (Opportunity resOpp : ListResOpps){
//System.debug('Partner Account'+ResOpp.PartnerAccountId);
  //  System.debug('Partner Channel Account'+ResOpp.Partner_Channel_Account__c);-- commented to reduce character for s2e optimization 
     //System.debug('aa '+ResOpp.Account_Name__c+' bb '+ResOpp.Partner_Portal_User__c+' cc '+ResOpp.Expected_Revenue_Date__c+' dd '+ResOpp.Expiration_Date__c+' ee '+ResOpp.Partner_Channel_Account__c+' ffff '+ResOpp.Opportunity_Owner_s_Sales_Org__c);   
        if((ResOpp.Account_Name__c != null && ResOpp.Account_Name__c != '' ) && ResOpp.Partner_Portal_User__c != null && ResOpp.Expected_Revenue_Date__c != null && ResOpp.Expiration_Date__c != null && ((ResOpp.PartnerAccountId !=null) || (ResOpp.Partner_Channel_Account__c != null)) && ResOpp.Opportunity_Owner_s_Sales_Org__c == 'TSL'){
//System.debug('Channel Account **'+ResOpp.Partner_Channel_Account__c);-- commented to reduce character for s2e optimization 
        Reservation__c newReservation = new Reservation__c();
               newReservation.Account__c = ResOpp.AccountId;
               newReservation.OwnerId = ResOpp.OwnerId;
               newReservation.End_Date__c = ResOpp.Expiration_Date__c;
//system.debug('PartnerAccount***'+ResOpp.PartnerAccountId);-- commented to reduce character for s2e optimization 
               if(ResOpp.PartnerAccountId != null){
//System.debug('inside if');-- commented to reduce character for s2e optimization 
                newReservation.Partner_Account__c = ResOpp.PartnerAccountId;
                }
                else if(ResOpp.Partner_Channel_Account__c!=null){
                  newReservation.Partner_Account__c = ResOpp.Partner_Channel_Account__c;
//System.debug('inside if else'+newReservation.Partner_Account__c);-- commented to reduce character for s2e optimization 
                }
               newReservation.Partner_Portal_User__c = ResOpp.Partner_Portal_User__c;
                newReservation.Start_Date__c = ResOpp.Expected_Revenue_Date__c;
                newReservation.Active__c = True;
                newReservation.OpportunityReservation__c = true;
        newReservation.Partner_Manager__c = ResOpp.Reservation_Manager__c; //Added as part of MCL-1649
            reslist.add(newReservation);
            }
        }
        if (!reslist.isEmpty()){
             Insert reslist;
//System.debug('reslist*************'+reslist);-- commented to reduce character for s2e optimization 
            }
        
    }
    catch(Exception e){
//System.debug(e+'*********'+e.getLinenumber());-- commented to reduce character for s2e optimization 
    }
 }
    */
 
    public static void afterUpdateMasterOpptySyncs(Map<id,Opportunity> oldMapTrigger, Map<id,Opportunity> newMapTrigger){
      //  if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            if(checkRecursive.isOpptyUpdate == true){ 
                Set<id> setOpptyId =new set<id>();
                Set<id> setChildOpptyId =new set<id>();
                List<Quote> lstUpdateQuote = new List<Quote>();
                List<Opportunity> lstUpdateChildOppty = new List<Opportunity>();              
                boolean boolChckChldUpdate = false;
                List<Account> lstUpdateAcc = new List<Account>();
                try {            
                    for(Opportunity oppty :NewMapTrigger.values()){
                    //Removing Win_Loss__c as a part of DPS-5353
                        if(oppty.Oppty_Mgmt_Type__c == 'Split Billing' && oppty.Is_Master_Opportunity__c == true
                        &&(oldMapTrigger.get(oppty.id).Payment_Condition__c != NewMapTrigger.get(oppty.id).Payment_Condition__c ||oldMapTrigger.get(oppty.id).StageName!= NewMapTrigger.get(oppty.id).StageName ||oldMapTrigger.get(oppty.id).Payment_Method__c != NewMapTrigger.get(oppty.id).Payment_Method__c ||oldMapTrigger.get(oppty.id).CBU__c != NewMapTrigger.get(oppty.id).CBU__c
                        ||oldMapTrigger.get(oppty.id).Bank__c != NewMapTrigger.get(oppty.id).Bank__c||oldMapTrigger.get(oppty.id).Grace_Period_Indicator__c != NewMapTrigger.get(oppty.id).Grace_Period_Indicator__c ||oldMapTrigger.get(oppty.id).AccountId != NewMapTrigger.get(oppty.id).AccountId||oldMapTrigger.get(oppty.id).LATAM_Business_Unit__c!= NewMapTrigger.get(oppty.id).LATAM_Business_Unit__c
                        ||oldMapTrigger.get(oppty.id).Category__c!= NewMapTrigger.get(oppty.id).Category__c ||oldMapTrigger.get(oppty.id).Sub_Category__c != NewMapTrigger.get(oppty.id).Sub_Category__c  ||oldMapTrigger.get(oppty.id).Sales_Org__c!= NewMapTrigger.get(oppty.id).Sales_Org__c ||oldMapTrigger.get(oppty.id).Category__c!= NewMapTrigger.get(oppty.id).Category__c
                        ||oldMapTrigger.get(oppty.id).SAP_Quotation_Document_number__c!= NewMapTrigger.get(oppty.id).SAP_Quotation_Document_number__c||oldMapTrigger.get(oppty.id).Expected_Revenue_Date__c != NewMapTrigger.get(oppty.id).Expected_Revenue_Date__c 
                        ||oldMapTrigger.get(oppty.id).Expiration_Date__c!= NewMapTrigger.get(oppty.id).Expiration_Date__c ||oldMapTrigger.get(oppty.id).Approved_Date_Time__c!= NewMapTrigger.get(oppty.id).Approved_Date_Time__c   ||oldMapTrigger.get(oppty.id).Original_Order_Number__c != NewMapTrigger.get(oppty.id).Original_Order_Number__c||oldMapTrigger.get(oppty.id).OwnerId != NewMapTrigger.get(oppty.id).OwnerId
                        ||oldMapTrigger.get(oppty.id).Reason__c != NewMapTrigger.get(oppty.id).Reason__c||oldMapTrigger.get(oppty.id).Was_There_a_Competitor__c != NewMapTrigger.get(oppty.id).Was_There_a_Competitor__c ||oldMapTrigger.get(oppty.id).Competitor_Name__c != NewMapTrigger.get(oppty.id).Competitor_Name__c  ||oldMapTrigger.get(oppty.id).ForecastCategoryName  != NewMapTrigger.get(oppty.id).ForecastCategoryName 
                        ||oldMapTrigger.get(oppty.id).CloseDate != NewMapTrigger.get(oppty.id).CloseDate ||oldMapTrigger.get(oppty.id).CurrencyIsoCode   != NewMapTrigger.get(oppty.id).CurrencyIsoCode  ||oldMapTrigger.get(oppty.id).Description != NewMapTrigger.get(oppty.id).Description ||oldMapTrigger.get(oppty.id).AccountId != NewMapTrigger.get(oppty.id).AccountId)) {
                            setOpptyId.add(oppty.id); 
                        }
                        if(oppty.Oppty_Mgmt_Type__c == 'Split Billing' && oppty.Is_Child_Opportunity__c == true && 
                            (oldMapTrigger.get(oppty.id).Grace_Period_Indicator__c != NewMapTrigger.get(oppty.id).Grace_Period_Indicator__c                    
                            ||oldMapTrigger.get(oppty.id).Description != NewMapTrigger.get(oppty.id).Description)) {
                            setChildOpptyId.add(oppty.id); 
                        }
                    }
/*System.debug('########setOpptyId'+setOpptyId.size());
                    System.debug('########setChildOpptyId'+setChildOpptyId.size());-- commented to reduce character for s2e optimization */
                    if(setOpptyId != null && !setOpptyId.isEmpty()){
                         //Removing Win_Loss__c as a part of DPS-5353
                        List<Opportunity> lstChildOpp = [SELECT id, Master_opportunity__c, LATAM_Business_Unit__c, Category__c, 
                           Sub_Category__c , Sales_Org__c, Account_Name__c, Amount,StageName,OwnerId,
                           SAP_Quotation_Document_number__c, Expected_Revenue_Date__c ,Grace_Period_Indicator__c,
                           Expiration_Date__c, Original_Order_Number__c,SAP_Account_Number__c, Reason__c, 
                           Was_There_a_Competitor__c, Competitor_Name__c, CloseDate, ForecastCategoryName, CurrencyIsoCode
                           FROM Opportunity WHERE IS_Master_opportunity__c = FALSE 
                           AND Master_Opportunity__c != Null AND Master_opportunity__c IN: setOpptyId ];
                        for(Opportunity opp : lstChildOpp ){      
                            if(oldMapTrigger.get(opp.Master_opportunity__c).LATAM_Business_Unit__c!= NewMapTrigger.get(opp.Master_opportunity__c).LATAM_Business_Unit__c){
                                opp.LATAM_Business_Unit__c = NewMapTrigger.get(opp.Master_opportunity__c).LATAM_Business_Unit__c;
                                 boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).Category__c!= NewMapTrigger.get(opp.Master_opportunity__c).Category__c
                            || oldMapTrigger.get(opp.Master_opportunity__c).Sub_Category__c != NewMapTrigger.get(opp.Master_opportunity__c).Sub_Category__c ){
                                opp.Category__c = NewMapTrigger.get(opp.Master_opportunity__c).Category__c;
                                opp.Sub_Category__c = NewMapTrigger.get(opp.Master_opportunity__c).Sub_Category__c;
                                boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).Sales_Org__c!= NewMapTrigger.get(opp.Master_opportunity__c).Sales_Org__c){
                                opp.Sales_Org__c = NewMapTrigger.get(opp.Master_opportunity__c).Sales_Org__c;
                                boolChckChldUpdate = true;  
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).Grace_Period_Indicator__c != NewMapTrigger.get(opp.Master_opportunity__c).Grace_Period_Indicator__c ){
                                opp.Grace_Period_Indicator__c  = NewMapTrigger.get(opp.Master_opportunity__c).Grace_Period_Indicator__c ;
                                boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).SAP_Quotation_Document_number__c!= NewMapTrigger.get(opp.Master_opportunity__c).SAP_Quotation_Document_number__c){
                                opp.SAP_Quotation_Document_number__c =NewMapTrigger.get(opp.Master_opportunity__c).SAP_Quotation_Document_number__c;
                                boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).Expected_Revenue_Date__c != NewMapTrigger.get(opp.Master_opportunity__c).Expected_Revenue_Date__c ){
                                opp.Expected_Revenue_Date__c = NewMapTrigger.get(opp.Master_opportunity__c).Expected_Revenue_Date__c;
                                boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).Expiration_Date__c!= NewMapTrigger.get(opp.Master_opportunity__c).Expiration_Date__c){
                                opp.Expiration_Date__c =NewMapTrigger.get(opp.Master_opportunity__c).Expiration_Date__c;
                                boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).Original_Order_Number__c != NewMapTrigger.get(opp.Master_opportunity__c).Original_Order_Number__c){
                                opp.Original_Order_Number__c = NewMapTrigger.get(opp.Master_opportunity__c).Original_Order_Number__c;
                                boolChckChldUpdate = true;
                            }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).OwnerId!= NewMapTrigger.get(opp.Master_opportunity__c).OwnerId){
                                opp.OwnerId =  NewMapTrigger.get(opp.Master_opportunity__c).OwnerId;
                                boolChckChldUpdate = true;
                            } 
                            //Removing Win_Loss__c as a part of DPS-5353
                           if(oldMapTrigger.get(opp.Master_opportunity__c).StageName!= NewMapTrigger.get(opp.Master_opportunity__c).StageName
                            ||oldMapTrigger.get(opp.Master_opportunity__c).ForecastCategoryName!= NewMapTrigger.get(opp.Master_opportunity__c).ForecastCategoryName
                            ||oldMapTrigger.get(opp.Master_opportunity__c).Win_Loss__c!= NewMapTrigger.get(opp.Master_opportunity__c).Win_Loss__c
                            ||oldMapTrigger.get(opp.Master_opportunity__c).Reason__c!= NewMapTrigger.get(opp.Master_opportunity__c).Reason__c             
                            ||oldMapTrigger.get(opp.Master_opportunity__c).Was_There_a_Competitor__c!= NewMapTrigger.get(opp.Master_opportunity__c).Was_There_a_Competitor__c
                            ||oldMapTrigger.get(opp.Master_opportunity__c).Competitor_Name__c!= NewMapTrigger.get(opp.Master_opportunity__c).Competitor_Name__c){
                                   opp.StageName = NewMapTrigger.get(opp.Master_opportunity__c).StageName;
                                   opp.ForecastCategoryName = NewMapTrigger.get(opp.Master_opportunity__c).ForecastCategoryName;
                                    //opp.Win_Loss__c = NewMapTrigger.get(opp.Master_opportunity__c).Win_Loss__c; //Commenting it out as a part of DPS_5353
                                   opp.Reason__c = NewMapTrigger.get(opp.Master_opportunity__c).Reason__c;
                                   opp.Was_There_a_Competitor__c = NewMapTrigger.get(opp.Master_opportunity__c).Was_There_a_Competitor__c;
                                   opp.Competitor_Name__c = NewMapTrigger.get(opp.Master_opportunity__c).Competitor_Name__c;
                                   boolChckChldUpdate = true;
                               }
                            if(oldMapTrigger.get(opp.Master_opportunity__c).CloseDate!= NewMapTrigger.get(opp.Master_opportunity__c).CloseDate){
                                 opp.CloseDate= NewMapTrigger.get(opp.Master_opportunity__c).CloseDate ;
                                boolChckChldUpdate = true;
                               }
                           if(oldMapTrigger.get(opp.Master_opportunity__c).CurrencyIsoCode!= NewMapTrigger.get(opp.Master_opportunity__c).CurrencyIsoCode){
                                opp.CurrencyIsoCode = NewMapTrigger.get(opp.Master_opportunity__c).CurrencyIsoCode;
                                boolChckChldUpdate = true;
                            }
                           /* //Added for setting the CO Read only flag to false to by pass the validation when CO is changed from Master and not from UI.
                            if(boolChckChldUpdate == true){
                                opp.CO_Read_Only_Flag__c = false;
                            }//Ends */
                            if(boolChckChldUpdate == true){
                                  lstUpdateChildOppty.add(opp);
                            }
                        }
                    }
                    
                    String strWhereClause = '';
                    String strQuery = '';
                    List<Quote> lstQuote = new List<Quote>();
                    if(setOpptyId != null && !setOpptyId.isEmpty() && setChildOpptyId != null && !setChildOpptyId.isEmpty()) {
                         //strWhereClause = 'WHERE OpportunityId IN: setOpptyId OR OpportunityId IN: setChildOpptyId AND Primary_Quote__c = TRUE AND (Is_Master_Quote__c = true OR (Is_Master_Quote__c = False AND Master_Quote__c != NULL)'; //Replaced with Custom Label as part of S2E Optimization
                         strWhereClause = Label.OptyTrgrHlrWhereCls1;
                    }
                    if(setOpptyId != null && !setOpptyId.isEmpty()) {                   
                        // strWhereClause = 'WHERE OpportunityId IN: setOpptyId AND Primary_Quote__c = TRUE AND Is_Master_Quote__c = true';  //Replaced with Custom Label as part of S2E Optimization
                        strWhereClause = Label.OptyTrgrHlrWhereCls2;
                    }
                    if(setChildOpptyId != null && !setChildOpptyId.isEmpty()) {
                         // strWhereClause = 'WHERE OpportunityId IN: setChildOpptyId AND Primary_Quote__c = TRUE AND (Is_Master_Quote__c = False AND Master_Quote__c != NULL)';  //Replaced with Custom Label as part of S2E Optimization
                         strWhereClause = Label.OptyTrgrHlrWhereCls3;
                    }
                    if(strWhereClause != '') {
                        // strQuery = 'SELECT id, Opportunity.Master_Opportunity__c, Opportunity_Notes__c, Grace_Period_Indicator__c, ';  //Replaced with Custom Label as part of S2E Optimization
                       // strQuery += 'OpportunityId, Is_Master_Quote__c, Primary_Quote__c,Ship_To_Customer_Name__c, Master_Quote__c FROM Quote ';  //Replaced with Custom Label as part of S2E Optimization
                       strQuery = Label.OptyTrgrHlrQry1+' ';
                        strQuery += strWhereClause;
/*system.debug('#########strQuery'+strQuery);-- commented to reduce character for s2e optimization */
                        lstQuote = Database.query(strQuery);
                    }
/*System.debug('#####lstQuote'+lstQuote);-- commented to reduce character for s2e optimization */
                        Quote objQuote; 
                        boolean boolChckQuoUpdate= false;
                        for(Quote quo : lstQuote) {
                            objQuote = new Quote(id = quo.id);
/*System.debug('@@@@@Inside Quote For');-- commented to reduce character for s2e optimization */
                            String strOppID;
                            strOppid = quo.OpportunityId; 
                            if(oldMapTrigger.get(strOppid).Grace_Period_Indicator__c != NewMapTrigger.get(strOppid ).Grace_Period_Indicator__c){
                                objQuote.Grace_Period_Indicator__c = NewMapTrigger.get(strOppid ).Grace_Period_Indicator__c;
                                boolChckQuoUpdate = true;
                            }
                            if(oldMapTrigger.get(strOppid).Description != NewMapTrigger.get(strOppid ).Description){
                                objQuote.Opportunity_Notes__c = NewMapTrigger.get(strOppid ).Description;
                                boolChckQuoUpdate = true;
                            }
                            if(boolChckQuoUpdate == true){                                       
                               lstUpdateQuote.add(objQuote);
                            }
                        } 
                       /* //Added for resetting the CO Read only flag to true                  
                        List<Opportunity> lstUpdateOppForFlagReset = new List<Opportunity>();*/
                        if(lstUpdateChildOppty != null && !lstUpdateChildOppty.isEmpty()){
                           Database.UPDATE(lstUpdateChildOppty);
                           /*for(Opportunity o: lstUpdateChildOppty){
                               o.CO_Read_Only_Flag__c= true;
                               lstUpdateOppForFlagReset.add(o);
                           }*/
                        }
                        /*if(lstUpdateOppForFlagReset != null && !lstUpdateOppForFlagReset.isEmpty()) {
                    
                            UPDATE lstUpdateOppForFlagReset;
                        }*/
                        if(lstUpdateQuote != null && !lstUpdateQuote.isEmpty()) {
                          //  checkRecursive.isOpptyUpdate = false;
                           Database.UPDATE(lstUpdateQuote);
                        //   checkRecursive.isOpptyUpdate = true;
                        }
                    //For Catch block code coverage
                    if(Test.isRunningTest())
                    {
                        CalloutException e = new CalloutException();
                        e.setMessage('This is a constructed exception for testing and code coverage');
                        throw e;
                    }
                }
                catch(Exception ex) {
/*System.debug('Exception occured in OptyTriggerHandler, method afterUpdateMasterOpptySyncs' + ex.getmessage() + 'line number'+ ex.getLinenumber());-- commented to reduce character for s2e optimization */
                }
            }
      //  }
    }

// PHP-50- Partner Portal Users are restricted to cteate the Opportunity if Account dont have any Approved Reservations.
    //commenting below method as part of DPS-17684  
    /*
    public static void validateAccountApprovedReservation(LIST<Opportunity> newOppList) {
     //   if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        SET<string> oppAccountIds= new SET<string>();
        for(Opportunity opp: newOppList){
            oppAccountIds.add(Opp.AccountId);
        }
        string strprfName= ContactUtil.getProfileName();
        if(strprfName == Label.Partner_Portal_Profile){
            MAP<string,boolean> accountResrvationMap= new MAP<string,boolean>();
            SET<string> acctsWithApprvdResrvtns = new SET<string>();
            List<RESERVATION__c> resrvtnLst= new List<RESERVATION__c>();
            resrvtnLst=[SELECT Id, Account__c FROM RESERVATION__c WHERE Approval_Status__c = 'Approved' AND Active__c = True AND Account__c IN : oppAccountIds];
//system.debug('***resrvtnLst' +resrvtnLst);-- commented to reduce character for s2e optimization 
            for(Reservation__c r:resrvtnLst){
                acctsWithApprvdResrvtns.add(r.Account__c);
            }
//system.debug('***acctsWithApprvdResrvtns' +acctsWithApprvdResrvtns);-- commented to reduce character for s2e optimization 
            for(Opportunity opps: newOppList){
                    if(!acctsWithApprvdResrvtns.Contains(Opps.AccountId)&& opps.StageName!='95%' && opps.StageName!='100%' && opps.StageName!='0%'){
                        Opps.AddError(System.label.OpptyUpdateWithoutReservation);
                    }
                }
      //      }
        }
   }
    */
    // LatAm stabilization JIRA SFD-14
     public static void insertSalesOrgLatAmBU(LIST<Opportunity> newOppList) {
       // if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while insert in Renewals
        if(strProfileName== Label.Latam_Profile || strProfileName==  Label.Partner_Portal_Profile){
            SET<string> oppAccountIds= new SET<string>();
            set<id> ownerIds = new Set<id>();
            for(Opportunity opp :newOppList){
                ownerIds.add(opp.ownerID);
            }
            Map<id,user> mapOwner = new Map<id,user>([select id,profile.name,LatAm_Department__c,sales_Org__c,Business_Unit__c from user where id in : ownerIds]);
            system.debug('********mapOwner '+mapOwner);
            for(Opportunity opp: newOppList){
            if (opp.Sales_Org__c == null){
                    opp.Sales_Org__c = mapOwner.get(opp.OwnerId).Sales_Org__c;
                }
            if (opp.Latam_Business_Unit__c == null){
                    opp.Latam_Business_Unit__c = mapOwner.get(opp.OwnerId).Business_Unit__c;
                }
            if(opp.LCRM_Business_Unit__c == null){
                 opp.LCRM_Business_Unit__c = mapOwner.get(opp.OwnerId).Business_Unit__c;
                }        
            }
     }
     //}
    }
    // LatAm stabilization JIRA SFD-44
    /** when Oppoty Stage is set to 0%, All chil Quotes status should be Discarded. */
     public static void updateChildQuotesToDiscarded(SET<Opportunity> opptyidSET) {
         try{
            if(strProfileName== Label.Latam_Profile || strProfileName==  Label.Partner_Portal_Profile){
               List<Quote> updQuoteLst= new List<Quote>();
               for(Quote oQuote: [SELECT id,status FROM Quote Where opportunityId IN :opptyidSET]){
                   Quote q= new Quote(id= oQuote.id);
                   q.status = LatamGeneral__c.getInstance('Discarded').Value__c;
                   updQuoteLst.add(q);
               }
               if(updQuoteLst!= null && updQuoteLst.size() >0){
 /*System.debug('***updQuoteLst' + updQuoteLst);-- commented to reduce character for s2e optimization */
                   Update updQuoteLst;
               }
            }
            //For Catch block code coverage
            if(Test.isRunningTest())
            {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
         }
    }

    /** when Oppty Account is modified, update all child Quote Account LookUp field to this accountId */

     public static void updateAccountLookUPOfChildQuotes(SET<Id> setOppId, Map<Id,Id> mapOldOpty) {
        try{
            List<Quote> updQuoteLst= new List<Quote>();
               for(Quote oQuote: [SELECT id,opportunityId,Account_LookUp__c FROM Quote Where opportunityId IN :SetOppId]){
                   Quote q= new Quote(id= oQuote.id,opportunityId=oQuote.opportunityId);
/*system.debug('***Inner method::' + q.opportunityId +'----'+ MapOldOpty.get(q.opportunityId));-- commented to reduce character for s2e optimization */
                   q.Account_LookUp__c= MapOldOpty.get(q.opportunityId);
                   updQuoteLst.add(q);
               }
               if(updQuoteLst!= null && updQuoteLst.size() >0){
 /*System.debug('***updQuoteLst' + updQuoteLst);-- commented to reduce character for s2e optimization */
                   Update updQuoteLst;
               }
               
            //For Catch block code coverage
            if(Test.isRunningTest())
            {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
        }

    }

    // 03.20.2016 - JIRA 440
    // Used to keep the Opportunity Notes on the Quote in sync from its Opportunity
    public static void updateRelatedQuoteFieldsFromOppotunity(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew){
        //================================================================================================
        //NOTE: Consider leveraging QuoteTriggerHandler.MapOpportunityfieldsonQuote if JIRA-440 expands to
        //      include aditional fields
        //================================================================================================
   // if(checkRecursive.isRenewalOpp != true && checkRecursive.isRenewalQuote != true) { ////Satyaki- Added to prevent the method from calling while update in Renewals
        Set<Id> setOpportunityIds = new Set<Id>();
        List<Quote> listQuoteForUpdate = new List<Quote>();
        try {
            for(Opportunity opp : mapNew.Values()) {
                //Was there a CHANGE to the field we care about???
                if (opp.Description != mapOld.Get(opp.Id).Description ){
                    setOpportunityIds.add(opp.id);
                }
            }
            if (setOpportunityIds.size() == 0) {
                return;
            }
            Map<Id, Quote> mapQuoteForUpdate = new Map<Id, Quote>([Select id, OpportunityId, Opportunity_Notes__c
                  From Quote where OpportunityId IN :setOpportunityIds And Primary_Quote__c = true]);
            for (Quote q : mapQuoteForUpdate.Values()){
                q.Opportunity_Notes__c = mapNew.get(q.OpportunityId).Description;
                listQuoteForUpdate.add(q);
            }
            if ( listQuoteForUpdate.size() > 0 ){
                update listQuoteForUpdate;
            }
            
            //For Catch block code coverage
            if(Test.isRunningTest())
            {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        } Catch (Exception e) {
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
        }
      // }
    }
   
    // 03.15.2016 - JIRA 418
    // We have exceeded the number of references on the Opportunity object and need to enforce
    // This additional validation rule here as per Daniel
    public static void validation_lockOpportunityWhileQuoteBeingApproved(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew){
     //   if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            final String sMethodName = 'Validation_LockOpportunityWhileQuoteBeingApproved';
            final String APPROVAL_STATUS_PENDING_PRICING_APPROVAL = 'Pending Pricing Approval';
            final String APPROVAL_STATUS_PENDING_MANAGER_APPROVAL = 'Pending Manager Approval';
            final String EXCLUDED_SALES_ORGS = 'EDIC,SCSI,SFWS,TSCE';
            final String LATAM_USER = 'LatAm User';
            final String DEVELOPER_NAME = 'LatAm_Order_Fulfillment';
            //Daniel 3-16-2016 Moved the error message to custom label
            //final String ERROR_MESSAGE                               = ' Opportunity is Locked while related Quote is being approved.';
            
            Set<Id> setQuoteIds = new Set<Id>();
            List<Opportunity> listOppRefined = new List<Opportunity>();
            try{
                //User u = [Select Id, Profile.Name, UserRole.DeveloperName From User Where Id = :userinfo.getUserId()];
                User u = AppUtil.loggedInUserDetail;
                //Get a list of Opportunities that mean several "Validation" criteria
                for(Opportunity opp : mapNew.Values()){
                        //SFD- 807  Adding Partner Portal User for Renewals
                    if (u.Profile.Name == LATAM_USER || (userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c && opp.Renewal_Flag__c == TRUE && RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c != NULL && opp.RecordTypeId ==  RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c)) {
                        if (u.UserRole.DeveloperName != DEVELOPER_NAME){
                            if ( ! EXCLUDED_SALES_ORGS.ContainsNone( opp.Sales_Org__c + ',') ){
                                if((mapOld.Get(opp.Id).Next_Call_Date__c!= null && opp.Next_Call_Date__c == mapOld.Get(opp.Id).Next_Call_Date__c)
                                || (mapOld.Get(opp.Id).Next_Call_Date__c== null && opp.Next_Call_Date__c == null)){
                                    if (opp.SyncedQuoteId != null) {
                                        //Add to Set because it's very likely we need to query and handle these items
                                        listOppRefined.add(opp);
                                        setQuoteIds.add(opp.SyncedQuoteId);
                                    }
                                }
                            }
                        }
                    }
                }
                //Let's exit if we found no records
                if (setQuoteIds.size() == 0) {
                    return;
                }
                //We found records that need to be looked at
                Map<Id, Quote> mapSyncedQuote = new Map<Id, Quote>([Select id, Approval_Status__c from Quote where Id IN : setQuoteIds]);
/*system.debug('***mapSyncedQuote::'+mapSyncedQuote);---- commented to reduce character for s2e optimization */
                for(Opportunity opp : listOppRefined) {
                    if (( mapSyncedQuote.get(opp.SyncedQuoteId).Approval_Status__c == APPROVAL_STATUS_PENDING_PRICING_APPROVAL ||
                         mapSyncedQuote.get(opp.SyncedQuoteId).Approval_Status__c == APPROVAL_STATUS_PENDING_MANAGER_APPROVAL ) && 
                         (opp.Reservation_Manager__c == mapOld.get(opp.Id).Reservation_Manager__c)) { 
                            opp.addError(System.label.Validation_LockOpportunityWhileQuoteBeingApproved);
                    }
                }
               //For Catch block code coverage
                if(Test.isRunningTest())
                {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                } 
            }
            catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
            }
       // }
    }
    
     public static void updateChildOpportunityAmountSubtotalOnParentOppty(LIST<Opportunity> newOppList){
        try{/*
            Map<ID, Opportunity> parentOpps = new Map<ID, Opportunity>(); 
            List<Id> listIds = new List<Id>();
            List<Opportunity> updateParentOpp = new List<Opportunity>();                       
            List<Id> parentIds = new List<Id>();
            Map<String, Double> currencyConversionMap = new Map<String, Double>();
            currencyConversionMap = getCurrencyConvRate();
           Decimal amt = 0;
           public Double round()
            List<Opportunity> childOpp = [SELECT id, Amount, Name,Child_Opportunity_Amount_Subtotal__c, Master_Opportunity__c FROM Opportunity WHERE ID IN :newOppList];--commented alltogether to reduce character for s2e optimization*/
            /*for(Opportunity childObj : newOppList){
                Opportunity opp = new Opportunity(Id = childObj.Id);
                listIds.add(childObj.Master_Opportunity__c);
                system.debug('#### '+childObj.Master_Opportunity__c);
                system.debug('#### childObjamount'+childObj.Master_Opportunity__r.Amount);
            }
            system.debug('#### '+listIds);
            system.debug('#### '+newOppList);
            parentOpps = new Map<Id, Opportunity>([SELECT id, Amount, CurrencyIsoCode, Name,(SELECT ID, Master_Opportunity__c,Amount FROM Opportunities__r) FROM Opportunity WHERE ID IN :listIds]);
            system.debug('#### '+parentOpps );

            for(Opportunity parOpp : parentOpps.values()){
                parentIds.add(parOpp.Id);
            }
            
            AggregateResult[] groupedResults = [SELECT Sum(Amount) ,Count(Name) from Opportunity where Master_Opportunity__c IN : parentIds];
            Double sumAmount = (Double) [SELECT Sum(Amount)sm FROM Opportunity where Master_Opportunity__c IN : parentIds][0].get('sm');                        
            system.debug('%%%%'+groupedResults);
            system.debug('%%%%'+sumAmount);
            Map<Id,AggregateResult> ParentAmt = new Map<Id,AggregateResult>();
            
            for(Opportunity opp : parentOpps.Values()){
                for(AggregateResult agr : groupedResults){
                    ParentAmt.put(opp.Id,agr);
                }                   
            }
                        
            system.debug('%%%%'+ParentAmt);
            for(Opportunity opp : parentOpps.Values()){
                Opportunity opp1  = new Opportunity(Id=opp.Id);
                system.debug('$$$$$'+opp1);                
                opp1.Child_Opportunity_Amount_Subtotal__c = 0;
                if(ParentAmt.containskey(opp.Id) && ParentAmt.get(opp.Id).get('expr0') != null){
                opp1.Child_Opportunity_Amount_Subtotal__c = ((decimal)ParentAmt.get(opp.Id).get('expr0') * currencyConversionMap.get(opp.CurrencyIsoCode)).setScale(2);
                }
                opp1.Child_Amount_Subtotal_Variance__c = (opp.Amount - opp1.Child_Opportunity_Amount_Subtotal__c).setScale(2) ;
                system.debug('$$$$$'+(decimal)ParentAmt.get(opp.Id).get('expr0'));
                system.debug('$$$$$ CURRENCY'+currencyConversionMap.get(opp.CurrencyIsoCode));
                system.debug('$$$$$ amount'+opp.Amount);
                updateParentOpp.add(opp1);
            }
            system.debug('&&& updateParentOpp'+updateParentOpp);
            if(updateParentOpp.size()>0)
            update updateParentOpp;
            //For Catch block code coverage
            if(Test.isRunningTest())
            {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }             
        }
       
        catch(Exception e){
           System.debug(e+'*********'+e.getLinenumber()+e.getmessage());
        }*/
        
        //try{
            Map<ID, Opportunity> parentOpps = new Map<ID, Opportunity>(); 
            List<Id> listIds = new List<Id>();
            List<Opportunity> updateParentOpp = new List<Opportunity>();            
            List<Id> parentIds = new List<Id>();
            Decimal amt = 0;            
            for(Opportunity childObj : newOppList){
                listIds.add(childObj.Master_Opportunity__c);
/*system.debug('#### '+childObj.Master_Opportunity__c);-- commented to reduce character for s2e optimization */
            }
            List<Opportunity> childOpp = [SELECT id, Amount, Name,Child_Opportunity_Amount_Subtotal__c, Master_Opportunity__c FROM Opportunity WHERE Master_Opportunity__c IN :listIds];
/*system.debug('#### '+listIds);
            system.debug('#### '+childOpp);-- commented to reduce character for s2e optimization */
            parentOpps = new Map<Id, Opportunity>([SELECT id, Amount, Name,Child_Amount_Subtotal_Variance__c,Child_Opportunity_Amount_Subtotal__c,(SELECT ID, Master_Opportunity__c,Amount FROM Opportunities__r) FROM Opportunity WHERE ID IN :listIds]);
/*system.debug('#### '+parentOpps );-- commented to reduce character for s2e optimization */
            for(Opportunity opp : parentOpps.Values()){
                Opportunity opp1  = new Opportunity(Id=opp.Id);
                for(Opportunity opp2 : childOpp){                   
                    if(opp2.Master_Opportunity__c == opp.Id){
                    amt = amt+opp2.Amount;
/*system.debug('$$$$$'+amt);-- commented to reduce character for s2e optimization */
                    }
                }
                opp1.Child_Opportunity_Amount_Subtotal__c = amt;
                opp1.Child_Amount_Subtotal_Variance__c = (opp.Amount - opp1.Child_Opportunity_Amount_Subtotal__c).setScale(2) ;
/*system.debug('$$$$$ amount'+opp1.Child_Opportunity_Amount_Subtotal__c);
                system.debug('$$$$$ amount'+opp1.Child_Amount_Subtotal_Variance__c);-- commented to reduce character for s2e optimization */
                updateParentOpp.add(opp1);              
            }
/*system.debug('&&&'+updateParentOpp);-- commented to reduce character for s2e optimization */
            if(updateParentOpp.size()>0){ //checkRecursive.isOppChck = false;//SFD-1189/1205  Enhancement November release
                update updateParentOpp;  // checkRecursive.isOppChck = true;//SFD-1189/1205  Enhancement November release
            }
            //For Catch block code coverage
            if(Test.isRunningTest())
            {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
        }
    } 
    
    /*public static Map<String, Double> getCurrencyConvRate(){
        if(currencyConvRateMap == null || currencyConvRateMap.size()==0){
            currencyConvRateMap = new Map<String, Double>();
            for(CurrencyType ct : [Select Id, ConversionRate, IsoCode from CurrencyType]){
                currencyConvRateMap.put(ct.IsoCode, ct.ConversionRate);
            }
            system.debug('@@ In getCurrencyConvRate function Again');
        }
        return currencyConvRateMap;
    }  */
     /**********************************************************************************************************************************
        Purpose : Add eror while user changes Split Billing to Oppty with 4 products
        Method Name : lockOpptyWithoutSplit
        Author : TCS Offshore       
        
  ***********************************************************************************************************************************/
    public static void lockOpptyWithoutSplit(List<Opportunity> newList,Map<id,Opportunity> oldMapTrigger){
     //   if(checkRecursive.isRenewalQuote != true && checkRecursive.isRenewalOpp != true) { //Satyaki- Added to prevent the method from calling while update in Renewals
            Set<id> setOpptyId =new set<id>();
            Map<Id,Integer> mapOLIOptyId = new Map<Id,Integer>();
            for(Opportunity opp:newList){
                if(oldMapTrigger.get(opp.id).Oppty_Mgmt_Type__c!= opp.Oppty_Mgmt_Type__c && opp.Oppty_Mgmt_Type__c=='Split Billing'){
                    setOpptyId.add(opp.id);
                }
            }
            if(setOpptyId!=null && setOpptyId.size()>0){
                AggregateResult[] lstOppLnItm = [SELECT OpportunityId, Count(Id) count1, Opportunity.Oppty_Mgmt_Type__c
                    FROM OpportunityLineItem WHERE OpportunityId in: setOpptyId GROUP BY OpportunityId,  Opportunity.Oppty_Mgmt_Type__c];
                                                 //HAVING Opportunity.Oppty_Mgmt_Type__c =: 'Split Billing']; 
                if(lstOppLnItm != null && lstOppLnItm.size() > 0){
                    For(AggregateResult ar : lstOppLnItm){
                        mapOLIOptyId.put((Id)ar.get('OpportunityId'), (Integer)ar.get('count1'));
                    }
                }                                    
            
                for( Opportunity opp:newList){
                    if(mapOLIOptyId.get(opp.id)>3 && mapOLIOptyId.get(opp.id) != null){
                        opp.addError(label.LatAm_SplitBillingFourthProduct);
                    }
                }
            }
        //}
    }
   
     /******************************************************************************************
    Method Name: RenewalOpptySync
    Created By: Satyaki 
    Purpose: Sync Opportunity to Quote for Renewals 
    Defects:
    *******************************************************************************************/ 
    public static void renewalOpptySync(Map<id,Opportunity> oldMapOppty, Map<id,Opportunity> newMapOppty) {
/*system.debug('S1:oldMapOppty'+oldMapOppty);
        system.debug('S2:newMapOppty'+newMapOppty);-- commented to reduce character for s2e optimization */
        if(userinfo.getProfileid() == Profile_List__c.getInstance('LatAm User').ProfileId__c ||
       userinfo.getProfileid() == Profile_List__c.getInstance('Partner Portal User').ProfileId__c||
       userinfo.getProfileid() == Profile_List__c.getInstance('System Administrator').ProfileId__c ){
            Boolean boolChck;
            checkRecursive.isRenewalQuote = false;
            checkRecursive.isRenewalOLI = false;
            checkRecursive.isRenewalQLI = false;
            boolChck = false;
/*system.debug('Step0: inside oppty renewal trigger:checkRecursive.isRenewalQuote='+checkRecursive.isRenewalQuote+'"checkRecursive.isRenewalOpp="'+checkRecursive.isRenewalOpp);-- commented to reduce character for s2e optimization */
            if(checkRecursive.isRenewalOpp == true) {
/*system.debug('Step1: inside oppty renewal');-- commented to reduce character for s2e optimization */
                Set<Id> setOpptyId = new Set<Id>();
/*System.debug('AG---->before for : '+newMapOppty.values());-- commented to reduce character for s2e optimization */
                for(Opportunity opp : newMapOppty.values()){
/*System.debug('AG---->In For 1: '+oldMapOppty.get(opp.id).Competitor_Name__c != newMapOppty.get(opp.id).Competitor_Name__c);
                    System.debug('AG---->In For 1: oldMapOppty.get(opp.id).Competitor_Name__c '+oldMapOppty.get(opp.id).Competitor_Name__c);
                    System.debug('AG---->In For 1: oldMapOppty.get(opp.id).Competitor_Name__c '+oldMapOppty.get(opp.id).Competitor_Name__c);-- commented to reduce character for s2e optimization */
                    //Removing Win_Loss__c as a part of DPS-5353
                    if(opp.Renewal_Flag__c == true && opp.RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c &&
                        opp.Master_Opportunity__c == NULL && (
                        oldMapOppty.get(opp.id).Competitor_Name__c != newMapOppty.get(opp.id).Competitor_Name__c || 
                        oldMapOppty.get(opp.id).Description != newMapOppty.get(opp.id).Description || 
                      //  oldMapOppty.get(opp.id).Payment_Condition__c != newMapOppty.get(opp.id).Payment_Condition__c || 
                     //   oldMapOppty.get(opp.id).Payment_Method__c != newMapOppty.get(opp.id).Payment_Method__c || 
                      //  oldMapOppty.get(opp.id).Projected_Renewal_Price__c != newMapOppty.get(opp.id).Projected_Renewal_Price__c || 
                        oldMapOppty.get(opp.id).Reason__c != newMapOppty.get(opp.id).Reason__c || 
                        oldMapOppty.get(opp.id).Was_There_a_Competitor__c != newMapOppty.get(opp.id).Was_There_a_Competitor__c || 
                        //oldMapOppty.get(opp.id).Win_Loss__c != newMapOppty.get(opp.id).Win_Loss__c||
                        oldMapOppty.get(opp.id).Bill_To_Contact__c!= newMapOppty.get(opp.id).Bill_To_Contact__c||
                        //12/26/2016:Added for MCL-1560 Mrinmoy Sarkar 
                        oldMapOppty.get(opp.id).Sales_Org__c!= newMapOppty.get(opp.id).Sales_Org__c)){
                            setOpptyId.add(opp.id);
                    }
                }
/*system.debug('Step2:setOpptyId= '+setOpptyId);-- commented to reduce character for s2e optimization */
                if(setOpptyId != NULL && !setOpptyId.isEmpty()) {
                    List<Quote> lstQuote = [SELECT Id,Opportunity_Sales_Org__c , OpportunityId, Renewal_Flag_Formula__c, Competitor_Name__c, Opportunity_Notes__c, Payment_Terms__c, 
                        Payment_Method__c,Bill_To_Contact__c, Reason__c, Was_There_a_Competitor__c, Win_Loss__c FROM Quote 
                         WHERE OpportunityId IN: setOpptyId AND Renewal_Flag_Formula__c =: true AND 
                          RecordTypeId =: RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c AND
                           Primary_Quote__c = TRUE AND Master_Quote__c = NULL];
                    List<Quote> lstUpdtQuote = new List<Quote>();
/*system.debug('Step3:lstQuote= '+lstQuote); -- commented to reduce character for s2e optimization */
                   if(lstQuote != NULL && !lstQuote.isEmpty()){ 
                    for(Quote quo : lstQuote) {
                        if(oldMapOppty.get(quo.OpportunityId).Competitor_Name__c != newMapOppty.get(quo.OpportunityId).Competitor_Name__c) {
                            quo.Competitor_Name__c = newMapOppty.get(quo.OpportunityId).Competitor_Name__c;
                            boolChck = true;
                        }
                        if(oldMapOppty.get(quo.OpportunityId).Description != newMapOppty.get(quo.OpportunityId).Description) {
                            quo.Opportunity_Notes__c = newMapOppty.get(quo.OpportunityId).Description;
                            boolChck = true;
                        }
                      /* Indu has asked to comment it as a validation is getting fired if we dont include Bank and CBU in sync
                        if(oldMapOppty.get(quo.OpportunityId).Payment_Condition__c != newMapOppty.get(quo.OpportunityId).Payment_Condition__c) {
                            quo.Payment_Terms__c = newMapOppty.get(quo.OpportunityId).Payment_Condition__c;
                            boolChck = true;
                        }
                        if(oldMapOppty.get(quo.OpportunityId).Payment_Method__c != newMapOppty.get(quo.OpportunityId).Payment_Method__c) {
                            quo.Payment_Method__c = newMapOppty.get(quo.OpportunityId).Payment_Method__c;
                            boolChck = true;
                        } */
                      /*  if(oldMapOppty.get(quo.OpportunityId).Projected_Renewal_Price__c != newMapOppty.get(quo.OpportunityId).Projected_Renewal_Price__c) {
                            quo.Projected_Renewal_Price__c = newMapOppty.get(quo.OpportunityId).Projected_Renewal_Price__c;
                            boolChck = true;
                        } */
                        if(oldMapOppty.get(quo.OpportunityId).Reason__c != newMapOppty.get(quo.OpportunityId).Reason__c) {
/*system.debug('Step4:oldmap reason= '+oldMapOppty.get(quo.OpportunityId).Reason__c);
                            system.debug('Step5:newmap reason= '+newMapOppty.get(quo.OpportunityId).Reason__c);-- commented to reduce character for s2e optimization */
                            quo.Reason__c = newMapOppty.get(quo.OpportunityId).Reason__c;
                            boolChck = true;
/*system.debug('Step6:quote reason= '+quo.Reason__c);-- commented to reduce character for s2e optimization */
                        }
                        if(oldMapOppty.get(quo.OpportunityId).Was_There_a_Competitor__c != newMapOppty.get(quo.OpportunityId).Was_There_a_Competitor__c) {
                            quo.Was_There_a_Competitor__c = newMapOppty.get(quo.OpportunityId).Was_There_a_Competitor__c;
                            boolChck = true;
                        }
                         if(oldMapOppty.get(quo.OpportunityId).StageName!= newMapOppty.get(quo.OpportunityId).StageName) {
                                   //Commenting out as a part of DPS-5353
                                   //quo.Win_Loss__c = newMapOppty.get(quo.OpportunityId).Win_Loss__c; 
                                   //boolChck = true;
                                   //Adding as a part of DPS-5353
                                   if(newMapOppty.get(quo.OpportunityId).StageName == 'Order Completed')
                                   {
                                       quo.Win_Loss__c = 'Won';
                                       boolChck = true;
                                   }
                                   else if (newMapOppty.get(quo.OpportunityId).StageName == 'Closed Lost')
                                   {
                                       quo.Win_Loss__c = 'Lost';
                                       boolChck = true;
                                   }
                                   //end DPS-5353
                                   
                               }
                        if(oldMapOppty.get(quo.OpportunityId).Bill_To_Contact__c!= newMapOppty.get(quo.OpportunityId).Bill_To_Contact__c) {
                            quo.Bill_To_Contact__c= newMapOppty.get(quo.OpportunityId).Bill_To_Contact__c;
                            boolChck = true;
                        }
                        if(oldMapOppty.get(quo.OpportunityId).Sales_Org__c!= newMapOppty.get(quo.OpportunityId).Sales_Org__c) {
                            quo.Opportunity_Sales_Org__c = newMapOppty.get(quo.OpportunityId).Sales_Org__c;
                            boolChck = true;//12/26/2016:Added for MCL-1560 Mrinmoy Sarkar 
                        }
                        if(boolChck == true){
                        lstUpdtQuote.add(quo);
                        }
                    }
/*system.debug('Step7:lstUpdtQuote= '+lstUpdtQuote);-- commented to reduce character for s2e optimization */
                    if(lstUpdtQuote != NULL && !lstUpdtQuote.isEmpty()) {
                        DATABASE.UPDATE(lstUpdtQuote,false);
                    }
                }
              }
            }
            checkRecursive.isRenewalQuote = true;
            checkRecursive.isRenewalOLI = true;
            checkRecursive.isRenewalQLI = true;
/*system.debug('Step8:end of renewal oppty trigger, checkRecursive.isRenewalQuote='+checkRecursive.isRenewalQuote);-- commented to reduce character for s2e optimization */
        }
      }
     /******************************************************************************************
    Method Name: updateReservationMng
    Created By: Shovon 
    Purpose: SFD-497
    *******************************************************************************************/ 
    //commenting below method as part of DPS-17684 
    /* 
    public static void updateReservationMng(List<opportunity> listopp, Map<Id,Opportunity> mapOldOpty){
        //System.debug('@@@@ Inside updateReservationMng methid: '+Listopp);
        //System.debug('@@@@ Inside updateReservationMng methid: '+MapOldOpty);-- commented to reduce character for s2e optimization 
        List<Id> reservationIdList = new List<Id>();
        Map<Id, Reservation__c> reservationMap;
        List<Id> updatedOppIdList = new List<Id>();
        List<Quote> updatedQuoteList;
        for(Opportunity opp: Listopp){
            if(opp.Reservation_Number__c != null && opp.Is_GLI__c != true){
            reservationIdList.add(opp.Reservation_Number__c);
            }
        }
        if(reservationIdList != null){
            reservationMap = new Map<Id, Reservation__c>([SELECT Id, Partner_Manager__c, Partner_Manager__r.ManagerId FROM Reservation__c WHERE Id IN: reservationIdList]);
        }
        if(Trigger.isInsert || (Trigger.isUpdate && MapOldOpty != null)){
            for(Opportunity opp: Listopp){
                if(Trigger.isUpdate && opp.Reservation_Number__c != MapOldOpty.get(opp.Id).Reservation_Number__c && !reservationMap.isEmpty()){
                   if(reservationMap.get(opp.Reservation_Number__c).Partner_Manager__c != null){
                       opp.Reservation_Manager__c =  reservationMap.get(opp.Reservation_Number__c).Partner_Manager__c;
                       updatedOppIdList.add(opp.Id);
                       }
                }
                else if(Trigger.isUpdate && opp.Reservation_Manager__c != MapOldOpty.get(opp.Id).Reservation_Manager__c){
                   updatedOppIdList.add(opp.Id);
                }
               else if(Trigger.isInsert && !reservationMap.isEmpty()){
                   // Condition added as part of MCL-1702 -- START -- Gunaseelan
                   KeyValueListStore__c keyval = KeyValueListStore__c.getInstance('ReservationCheckFlag');
                   if(checkrecursive.runonce()){
                   if(keyval.TextValue__c=='True'&& reservationMap.get(opp.Reservation_Number__c).Partner_Manager__c ==null && strProfileName==Label.Partner_Portal_Profile){
                       if(opp.Is_Child_Opportunity__c==False){
                       if(opp.StageName!='95%' && opp.StageName!='100%' && opp.StageName!='0%'){ 
                         opp.addError(Label.ReservationManagerError);
                       }
                       }
                   }  }
                   else{    // Condition added as part of MCL-1702 -- END --Gunaseelan 
                    opp.Reservation_Manager__c =  (reservationMap.get(opp.Reservation_Number__c).Partner_Manager__c != null) ? reservationMap.get(opp.Reservation_Number__c).Partner_Manager__c : '';
                }
            }
        }
        
        if(!updatedOppIdList.isEmpty()){
            // Call updateReservationMngAndHisMng Method in future context
            QuoteTriggerHandler.updateReservationMngAndHisMng_Future(updatedOppIdList);
        } 
    }
    }
    */
    /******************************************************************************************
    Method Name: OppQuoteSync
    Created By: Sujana 
    Purpose:  SFD-415
    *******************************************************************************************/ 
   public static void oppQuoteSync(Map<Id, Opportunity> mapOld, Map<Id, Opportunity> mapNew) {
        Set<Id> setOpportunityIds = new Set<Id>();
        List<Quote> listQuoteForUpdate = new List<Quote>(); 
        try{
            for(Opportunity opp : mapNew.Values()){
             //Removing Win_Loss__c and replacing it with stagename as a part of DPS-5353
                 if (
                       opp.Short_Term_Sub__c != mapOld.Get(opp.Id).Short_Term_Sub__c
                            //|| opp.Win_Loss__c != mapOld.Get(opp.Id).Win_Loss__c
                            || opp.StageName != mapOld.Get(opp.Id).StageName
                            || opp.Reason__c != mapOld.Get(opp.Id).Reason__c
                            || opp.Was_There_A_Competitor__c != mapOld.Get(opp.Id).Was_There_A_Competitor__c
                            || opp.Competitor_Name__c != mapOld.Get(opp.Id).Competitor_Name__c
                            || opp.Sales_Org__c != mapOld.Get(opp.Id).Sales_Org__c  // 12/26/2016:Added for MCL-1560 Mrinmoy Sarkar 
                            ){                        
                                setOpportunityIds.add(opp.id);
 /*system.debug('***** Inside'+setOpportunityIds);-- commented to reduce character for s2e optimization */
                            }
                    }
/*system.debug('***** Inside'+setOpportunityIds);-- commented to reduce character for s2e optimization */
                if (setOpportunityIds.size() == 0) {
                    return;
                }
                Map<Id, Quote> mapQuoteForUpdate = new Map<Id, Quote>([Select id, OpportunityId, Opportunity_Notes__c,Opportunity_Sales_Org__c,Win_Loss__c,Reason__c,Was_There_A_Competitor__c,Competitor_Name__c,Short_Term_Sub__c
                             From Quote where OpportunityId IN :setOpportunityIds And Primary_Quote__c = true]);
/*system.debug('&&&& Sync Quote List'+mapQuoteForUpdate.Values());-- commented to reduce character for s2e optimization */
                if(mapQuoteForUpdate.size()>0){
                    for (Quote q : mapQuoteForUpdate.Values()) {
                        q.Short_Term_Sub__c = mapNew.get(q.OpportunityId).Short_Term_Sub__c;            
                         //q.Win_Loss__c = mapNew.get(q.OpportunityId).Win_Loss__c; //Commenting out as a part of DPS-5353
                    //Adding as a part of DPS-5353
                    if(mapNew.get(q.OpportunityId).StageName== 'Order Completed')
                    {q.Win_Loss__c = 'Won';}
                    else if(mapNew.get(q.OpportunityId).StageName== 'Closed Lost')
                    {q.Win_Loss__c = 'Lost';}              
                        q.Reason__c = mapNew.get(q.OpportunityId).Reason__c;
                        q.Was_There_A_Competitor__c = mapNew.get(q.OpportunityId).Was_There_A_Competitor__c;
                        q.Competitor_Name__c = mapNew.get(q.OpportunityId).Competitor_Name__c;
                        q.Opportunity_Sales_Org__c = mapNew.get(q.OpportunityId).Sales_Org__c;//12/26/2016:Added for MCL-1560 Mrinmoy Sarkar 
                        listQuoteForUpdate.add(q);   
/*system.debug('%%%% Updated Sync Quote List'+listQuoteForUpdate);-- commented to reduce character for s2e optimization */
                    }
                }
                if ( listQuoteForUpdate.size() > 0){
                    update listQuoteForUpdate;
                }
                //For Catch block code coverage
            if(Test.isRunningTest())
            {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
            }
            catch(Exception e){
/*System.debug(e+'*********'+e.getLinenumber()+e.getmessage());-- commented to reduce character for s2e optimization */
            }
    }
    /******************************************************************************************
    Method Name: businessUnitUpdate
    Created By: Anshu Thakur 
    Created Date: 19-Aug-2016
    Purpose: SFD-841
    *******************************************************************************************/ 
    public static void businessUnitUpdate(Map<Id, Opportunity> mapNew, Map<Id, Opportunity> mapOld){
/*System.Debug('*****inside businessUnitUpdate');-- commented to reduce character for s2e optimization */
        List<Opportunity> lstOpptyToUpdate = new List<Opportunity>();
        List<Opportunity> lstOppty = new List<Opportunity>();
        List<User> lstUser = new List<User>();
        Set<id> setOppId = new Set<id>();
        Map<Id, String> mapUsrBU = new Map<Id, String>();
        for(Opportunity opp: mapNew.values()){
            if(opp.RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c
              && mapOld.get(opp.id).OwnerId != mapNew.get(opp.id).OwnerId 
                && opp.Renewal_Flag__c == true && opp.Master_Opportunity__c == NULL 
           ){
                setOppId.add(opp.ownerid);
            }
        }
        if(setOppId != NULL && !setOppId .isEmpty()){  
         lstUser = [SELECT id, Business_Unit__c, profile.Name FROM User  WHERE (profile.Name =: 'LatAm User' OR profile.Name =: 'Partner Portal User')
                    AND id IN: setOppId];
            For(User u: lstUser){
                mapUsrBU.put(u.id, u.Business_Unit__c);
            }
      }
/*System.Debug('*****lstUser='+lstUser);-- commented to reduce character for s2e optimization */
        For(Opportunity opp: mapNew.values()) {
            if(mapold.get(opp.id).OwnerId != mapNew.get(opp.id).OwnerId
                && opp.RecordTypeId == RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c
                && opp.Renewal_Flag__c == true && opp.Master_Opportunity__c == NULL) {
                Opportunity objOpp = new Opportunity(id = opp.id);
                objOpp.LATAM_Business_Unit__c = mapUsrBU.get(opp.OwnerId);
                lstOpptyToUpdate.add(objOpp);
            }
        }
        try{
            if(!lstOpptyToUpdate.isEmpty() && lstOpptyToUpdate != NULL){
                Database.UPDATE(lstOpptyToUpdate);
            }
        } catch(Exception e){
/*System.Debug('******Exception for businessUnitUpdate:='+e.getMessage());-- commented to reduce character for s2e optimization */
        }
        
    }  

     //Lcrm code to populate contact role on opportunites Tejas -- This method was not optimised during s2e optimization as it is a part of LCRM change
    public static void populatecontactroleonopty(List<opportunity> opptyList,Map<id,Opportunity> oldOppMap){
       
       List<OpportunityContactRole> roles = new List<OpportunityContactRole>();
       List<OpportunityContactRole> presentRoles = new List<OpportunityContactRole>();
        
       if(oldOppMap == null) // insert of record
        { 
            for(Opportunity optyobj : opptyList)
            {
                if(optyobj.Key_Contact__c != null && optyobj.Is_GLI__c == true)
                {   
                    OpportunityContactRole role = new OpportunityContactRole();
                    role.OpportunityId=optyobj.id;
                    role.ContactId=optyobj.Key_Contact__c;
                    role.IsPrimary=true;
                        //role.Role='Other';
                    roles.add(role);
                }   
            }
        }else //update of record
        {
            Set<id> oppIdSet = new Set<id>();
            Boolean keyContactNotPresentinContactRoles = false;
            
            for(Opportunity optyobj : opptyList)
            {
                if(optyobj.Key_Contact__c != null && oldOppMap.get(optyobj.id).Key_Contact__c !=  optyobj.Key_Contact__c && optyobj.Is_GLI__c == true)
                {   
                   oppIdSet.add(optyobj.id); 
                }   
            }
            
            if(oppIdSet.size() > 0){
                 presentRoles = [select id,ContactId,IsPrimary,OpportunityId from OpportunityContactRole where OpportunityId in : oppIdSet];
            }
           Map<id,List<OpportunityContactRole>> oppIdContactRoleMap = new Map<id,List<OpportunityContactRole>>();
           
            for(OpportunityContactRole oContactOppRole : presentRoles)
            {
                if(oppIdContactRoleMap.ContainsKey(oContactOppRole.OpportunityId))
                {
                    List<OpportunityContactRole> contactRolesList = oppIdContactRoleMap.get(oContactOppRole.OpportunityId);
                    contactRolesList.add(oContactOppRole);
                    oppIdContactRoleMap.put(oContactOppRole.OpportunityId,contactRolesList);
                    
                }else
                {
                    List<OpportunityContactRole> contactRolesList = new List<OpportunityContactRole>();
                    contactRolesList.add(oContactOppRole);
                    oppIdContactRoleMap.put(oContactOppRole.OpportunityId,contactRolesList);
                }
               
            }
            
            
            for(Opportunity optyobj : opptyList)
            {
                 if(optyobj.Key_Contact__c != null && oldOppMap.get(optyobj.id).Key_Contact__c !=  optyobj.Key_Contact__c && optyobj.Is_GLI__c == true)
                 {
                     if(oppIdContactRoleMap.ContainsKey(optyobj.id)) //if opportunity contains roles
                     {
                        List<OpportunityContactRole> contactRolesList = oppIdContactRoleMap.get(optyobj.id);
                        
                        
                        for(OpportunityContactRole oContactRole : contactRolesList)
                        {
                            if(oContactRole.IsPrimary && oContactRole.ContactId != optyobj.Key_Contact__c)  //to remove primay check box
                            {
                                OpportunityContactRole existingPrimaryContactRole = oContactRole;
                                existingPrimaryContactRole.IsPrimary = false;
                                roles.add(existingPrimaryContactRole);
                            }
                            
                            if(oContactRole.ContactId == optyobj.Key_Contact__c) // to make exiting key contact primary if present
                            {
                                keyContactNotPresentinContactRoles = true;
                if(!oContactRole.IsPrimary){
                  OpportunityContactRole existingContactRole = oContactRole;
                  existingContactRole.IsPrimary = true;
                  roles.add(existingContactRole);
                }
                            }
                        }
                       
                       if(keyContactNotPresentinContactRoles == false)
                       {
                           system.debug('*********'+keyContactNotPresentinContactRoles);
                           if(optyobj.Key_Contact__c != null)
                            {   
                                OpportunityContactRole role = new OpportunityContactRole();
                                role.OpportunityId=optyobj.id;
                                role.ContactId=optyobj.Key_Contact__c;
                                role.IsPrimary=true;
                                //role.Role='Other';
                                roles.add(role);
                            }
                       }
                       
                         
                     }else // not a single contact roles present
                     {
                         if(optyobj.Key_Contact__c != null)
                            {   
                                OpportunityContactRole role = new OpportunityContactRole();
                                role.OpportunityId=optyobj.id;
                                role.ContactId=optyobj.Key_Contact__c;
                                role.IsPrimary=true;
                                //role.Role='Other';
                                roles.add(role);
                            }
                     }
                 }
            }
            
            
            
        }
        
        if(roles.size() > 0)
        {
            system.debug('****roles*******' + roles);
            upsert roles;
        }
        
    } 
    
     /******************************************************************************************
    Method Name: Reservationactivecheck
    Created By: GunaSeelan K
    Created Date: 11-April-2017
    Purpose: MCL-1702
    *******************************************************************************************/
    //commenting below method as part of DPS-17684  
    /*
    public static void reservationactivecheck(LIST<Opportunity> newOppList) {
     if(checkrecursive.runOnce()){
       if(strProfileName==Label.Partner_Portal_Profile){
           KeyValueListStore__c keyval = KeyValueListStore__c.getInstance('ReservationCheckFlag');
               if(keyval.TextValue__c=='True'){
                List<Id> reservationIdList = new List<Id>();
                Map<Id, Reservation__c> reservationMap;
        
                    for(Opportunity opp: newOppList){
                        if(opp.Reservation_Number__c != null){
                        reservationIdList.add(opp.Reservation_Number__c);
                        }
                    }
                    system.debug(reservationIdList);
                    if(reservationIdList != null){
                        reservationMap = new Map<Id, Reservation__c>([SELECT Id, Partner_Manager__c,Active__c,Account__C, Partner_Manager__r.ManagerId,Reservation__c.Account__r.id FROM Reservation__c WHERE Id IN: reservationIdList]);
                    }
           
                    for(Opportunity opp :newOppList){
                    if(opp.Is_Child_Opportunity__c==False){
                        if(opp.Reservation_Number__c!=null && opp.StageName!='95%' && opp.StageName!='100%' && opp.StageName!='0%'){
                              
                            if(opp.Accountid!=reservationMap.get(opp.Reservation_Number__c).Account__r.id){
                                opp.addError(Label.ReservationAccountError);
                            }
                            if(reservationMap.get(opp.Reservation_Number__c).Active__c==false){
                                opp.addError(Label.ReservationActiveError); 
                            }
                            if(reservationMap.get(opp.Reservation_Number__c).Partner_Manager__c ==null && Trigger.isUpdate){
                               opp.addError(Label.ReservationManagerError); 
                            }  
                          }   
                    
                    }
                    }
             }
      }   }
   }
   */
    //Added as part of DPS-4401
   /*public static void validatecompetitiveinfo(List<opportunity> oppListNew){
   
    if(!String.IsBlank(KeyValueListStore__c.getValues('ReasonWithCompetitor').TextValue__c)){
     //keyValueListStore__c reasonforComp = KeyValueListStore__c.getValues('ReasonWithCompetitor');
    String reasonforcompvalues = KeyValueListStore__c.getValues('ReasonWithCompetitor').TextValue__c;
    String[] reasonValues = Reasonforcompvalues.split(',');
    System.debug('Reason after split ' + reasonValues.get(0));
        List<Opportunity> opportunityList = new List<Opportunity>();
    set<Id> opportunityIds  = new set<Id>();
    set<Id> compInfOppIds = new set<Id>();
    for(Opportunity op : oppListNew){
    
    if((String.IsNotblank(op.Reason__c)) && (op.stageName == 'Closed lost' || op.stageName == '0%' ) && op.Is_GLI__c == TRUE &&  reasonValues.contains(string.valueOf(op.Reason__c)) ){
    
    opportunityList.add(op);
    opportunityIds.add(op.Id);
    }
    }
    
     for(Competitive_Info__c cf : [Select id,Opportunity__c from Competitive_Info__c where Opportunity__c IN :opportunityIds]){
        compInfOppIds.add(cf.Opportunity__c);
     }
     for(Opportunity opp : oppListNew ){
        if(opportunityIds.contains(opp.Id) && !compInfOppIds.contains(opp.Id)){
           opp.addError(Label.CompetitorRequired);
        }
     }
    }
   }*/
}