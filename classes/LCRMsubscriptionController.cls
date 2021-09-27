/**
 * @Comment Class Name : LCRMsubscriptionController Description
 * @description
 [CRM-7821] Code behind the Subscription button on the account
 [CRM-13578]Subscription webservice should consider SSD record which belongs to logged in user Sub BU(USL/Findlaw/LMS).
 We should not consider user salesorg (this is the change from original design)
 [MCL-2516] Fixed Subscription download issue

 PURPOSE:    GLIEDW, Integration between Salesforce and EDW and middleware system is ESI.RestWebService is used for developing the subscription functionality.
 *
 */
public without sharing class LCRMsubscriptionController{
    /**
     * public listofSSD method
     * @description : public listofSSD getter setter method
     */
    public List<Source_System_Detail__c> listofSSD;
    /**
     * public webserviceName method
     * @description : public webserviceName getter setter method
     */
    private String webserviceName = 'Subscription';//private
    /**
     * public rwquestWrapper method
     * @description : public rwquestWrapper getter setter method
     */
    public LCRMsubscriptionsJsonWrapper.LCRMSubscriptionRequestWrapper rwquestWrapper;
    /**
     * public selectedwrappermap method
     * @description : public selectedwrappermap getter setter method
     */
    //DSS-3663 code block start
    public map<string, LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> selectedwrappermap;
    public list<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> selectedwrappertotal;
    public boolean tempSelectAll;

    /**
     * public renderedNonInfo
     * @description : renderedNonInfo
     */
    public Boolean renderedNonInfo{ get; set; }

    /**
     * public renderedPgblock
     * @description : renderedPgblock
     */
    public Boolean renderedPgblock{ get; set; }

    /**
     * public strSalesOrg
     * @description : strSalesOrg
     */
    public String strSalesOrg{ get; set; }

    //CRM-13578
    /**
     * public strSubBu
     * @description : strSubBu
     */
    public String strSubBu{ get; set; }

    /**
     * public Account oAccount
     * @description : oAccount getter setter method
     */
    public Account oAccount{ get; set; }

    /**
     * public sSelectedOption
     * @description : public sSelectedOption getter setter method
     */
    public string sSelectedOption{ get; set; }

    /**
     * public accountSapIdList method
     * @description : public accountSapIdList getter setter method
     */
    public List<String> accountSapIdList{ get; set; }

    /**
     * public field method
     * @description : public field getter setter method
     */
    public String field{ get; set; }

    /**
     * public sortOrder method
     * @description : public sortOrder getter setter method
     */
    public String sortOrder{ get; set; }

    /**
     * public totalNumberOfSubscription method
     * @description : public totalNumberOfSubscription getter setter method
     */
    public Integer totalNumberOfSubscription{ get; set; }

    /**
     * public sCurrentUser method
     * @description : public sCurrentUser getter setter method
     */
    public User sCurrentUser{ get; set; }

    /**
     * public sTranslatedSelectOption method
     * @description : public sTranslatedSelectOption getter setter method
     */
    public String sTranslatedSelectOption{ get; set; }

    /**
     * public accountIdSet method
     * @description : public accountIdSet getter setter method
     */
    public Set<ID> accountIdSet{ get; set; }

    /**
     * public listDisplaySubscriptionResponse method
     * @description : public listDisplaySubscriptionResponse getter setter method
     */
    public list<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listDisplaySubscriptionResponse{ get; set; }

    /**
     * public oSelectedmap method
     * @description : public oSelectedmap getter setter method
     */
    public map<string, LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> oSelectedmap{ get; set; }

    // public boolean selectall{get;set;}
    /**
     * public SelectAll method
     * @description : public SelectAll getter setter method
     */
    public boolean selectAll{ get; set; }

    /**
     * public renderAsdoc method
     * @description : public renderAsdoc getter setter method
     */
    public string renderAsdoc{ get; set; }

    /**
     * public renderAsExcel method
     * @description : public renderAsExcel getter setter method
     */
    public string renderAsExcel{ get; set; }

    /**
     * public sizeOfOpenMap method
     * @description : public sizeOfOpenMap getter setter method
     */
    public Integer sizeOfOpenMap{
        get{
            return oSelectedmap.size();
        }
    }

    //DSS-3663 code block end
    //below variables used for pagination
    /**
     * public listofSubscriptioninfo method
     * @description : public listofSubscriptioninfo getter setter method
     */
    public List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listofSubscriptioninfo{ get; set; }

    /**
     * public displaylcrmsubscription method
     * @description : public displaylcrmsubscription getter setter method
     */
    public List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> displaylcrmsubscription{ get; set; }

    /**
     * public genericDisplaylcrmsubscription method
     * @description : public genericDisplaylcrmsubscription getter setter method
     */
    public List<List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>> genericDisplaylcrmsubscription{ get; set; }

    /**
     * public ordPaginater method
     * @description : public ordPaginater getter setter method
     */
    public Paginate ordPaginater{ get; set; }

    /**
     * LCRMsubscriptionController
     * @description : LCRMsubscriptionController constructor Constructor LCRMsubscriptionController, get the SAp Account numbers from SSD according to Account parent/child relationship
     * @param controller
     */
    public LCRMsubscriptionController(ApexPages.StandardController controller){

        declarationOfVariables();

        try{
            sCurrentUser = getCurrentUser();
            sSelectedOption = 'All Active';
            strSubBu = sCurrentUser.Sub_Bu__c;
            //strSalesOrg = sCurrentUser.Sales_Org__c;
            oAccount = (Account)controller.getRecord();
            oAccount = getAccountSobject(oAccount.Id);
            accountIdSet = getAccountIdSets(oAccount);

            if (accountIdSet.size() > 0 && String.isnotblank(strSubBu)){
                listofSSD = getSourceSystemDetails(accountIdSet, strSubBu);

                if (listofSSD.size() > 0){
                    accountSapIdList = LCRMSubscriptionUtility.createSSDList(listofSSD);
                    strSalesOrg = listofSSD[0].LCRM_Sales_Org__c;
                    /*if (String.isnotblank(listofSSD[0].LCRM_Sales_Org__c)){
                     strSalesOrg = listofSSD[0].LCRM_Sales_Org__c;
                     for (Source_System_Detail__c ssd : listofSSD){
                     if (String.IsNotBlank(ssd.Source_System_Account_Number__c)){
                     accountSapIdList.add(ssd.Source_System_Account_Number__c);
                     }
                     }
                    //End For Loop
                     }*/
                } else if (listofSSD == null || listofSSD.isEmpty()){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, (Label.LCRMNoSubBUError)));
                }
                //End SSD List Size Checking
            } else{
                //Need to add new lable for SUB BU blank
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMCurrentUsersSub_BU));
            }
        } Catch (Exception Exp){

            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,  + Exp.getMessage()));
            System.debug(LoggingLevel.DEBUG, 'Error:-' + Exp.getMessage());
        }
    }

    /**
     * sortSubscription method
     * @description sortSubscription method used for while changing the sub type values from View picklist
     */
    public void sortSubscription(){
        System.debug(LoggingLevel.DEBUG, '** call sortSubscription Method**');
        field = 'MATERIAL_NUMBER';
        sortOrder = 'ascending';
        displayLCRMSubcriptioninfo();
    }

    /**
     * getSubscriptionListOptions method
     * @description GetSubscriptionListOptions method used for retrieving the value in View picklist which is displayed in the LCRMScubscription
     * VF page and this is a mandatory field in input request parameters for fetching the response from external System.
     * @return selectoption list
     */
    public List<selectoption> getSubscriptionListOptions(){
        System.debug(LoggingLevel.DEBUG, '**call Method getSubscriptionListOptions**');
        List<selectoption> subscriptionsList = new List<selectoption>();
        List<selectoption> subscriptionsList1 = new List<selectoption>();
        Map<String, SubscriptionTypes__c> mapSubscriptionTypes = SubscriptionTypes__c.getAll();
        string sProfileName = [select id, name
                               from profile
                               where id = :userinfo.getProfileId()].name.toUpperCase();

        for (SubscriptionTypes__c oSubscriptionType : mapSubscriptionTypes.values()){
            subscriptionsList = LCRMSubscriptionUtility.createSubscriptionList(oSubscriptionType, sProfileName, sCurrentUser);
            subscriptionsList1.addAll(subscriptionsList);
            
        }
        subscriptionsList1.sort();
        return subscriptionsList1;
    }

    /**
     * sortSubscriptionByfield variable
     * @description sortSubscriptionByfield method used for retrieving the value in 'Sort By' picklist which is displayed in the LCRMScubscription VF page
     and this is a mandatory field in input request parameters for fetching the response from external System.
     */
    public List<selectOption> sortSubscriptionByfield{
        get{
            System.debug(LoggingLevel.DEBUG, '**call Method sortSubscriptionByfield**');
            List<selectOption> options = new List<selectOption>();
            List<String> listOfFields = new List<String>(SubscriptionSortByField__c.getAll().Keyset());
            listOfFields.sort();
            for (String sSubsField : listOfFields){
                if (sCurrentUser.LanguageLocaleKey == 'es'){
                    options.add(new selectoption(SubscriptionSortByField__c.getInstance(sSubsField).LCRM_Sort_By__c, SubscriptionSortByField__c.getInstance(sSubsField).Spanish__c));
                } else if (sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                    options.add(new selectoption(SubscriptionSortByField__c.getInstance(sSubsField).LCRM_Sort_By__c, SubscriptionSortByField__c.getInstance(sSubsField).Portuguese__c));
                } else{
                    options.add(new SelectOption(SubscriptionSortByField__c.getInstance(sSubsField).LCRM_Sort_By__c, SubscriptionSortByField__c.getInstance(sSubsField).name));
                }
            }
            options.sort();
            return options;
        }

        set;
    }

    /**
     * getSortByOrder method
     * @description getSortByOrder method used for retrieving the value in 'Sort Order' picklist which is displayed in the LCRMScubscription VF page and
     this is a mandatory field in input request parameters for fetching the response from external System.
     *@return List of selectOption
     */
    public List<SelectOption> getSortByOrder(){
        System.debug(LoggingLevel.DEBUG, '**call Method getSortByOrder**');
        List<SelectOption> options = new List<SelectOption>();
        list<String> listOfSortOrder = new list<String>(Sort_Order__c.getAll().keySet());
        listOfSortOrder.sort();
        for (String sSortOrder : listOfSortOrder){
            if (sCurrentUser.LanguageLocaleKey == 'es'){
                options.add(new SelectOption(Sort_Order__c.getInstance(sSortOrder).LCRM_Sort_Order__c, Sort_Order__c.getInstance(sSortOrder).Spanish__c));
            } else if (sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                options.add(new SelectOption(Sort_Order__c.getInstance(sSortOrder).LCRM_Sort_Order__c, Sort_Order__c.getInstance(sSortOrder).Portuguese__c));
            } else{
                options.add(new SelectOption(Sort_Order__c.getInstance(sSortOrder).LCRM_Sort_Order__c, Sort_Order__c.getInstance(sSortOrder).English__c));
            }
        }
        options.sort();
        return options;
    }

    /**
     getSourceSystemDetails method
     * @description Get the source system details based on current logged in users sales org value should be matched with SSD sales Org field value
     *
     * @param listAccId
     * @param strSubBu
     * @return List<Source_System_Detail__c>: Return description
     */
    @testVisible
     Private List<Source_System_Detail__c> getSourceSystemDetails(Set<Id> listAccId, String strSubBu){
        System.debug(LoggingLevel.DEBUG, '**call Method getSourceSystemDetails**');
        /*List<String> strSubBuList = System.Label.LCRMstrSubBu.split(',');
        KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMOrderSubscriptionUserSubBU');//Gets the SUBBU value from KeyValueListStore__c custom settings
        String tempSubBuValues = tempObj.TextValue__c;*/
        String tempSubBuValues = KeyValueListStore__c.getInstance('LCRMOrderSubscriptionUserSubBU').TextValue__c;//Gets the SUBBU value from KeyValueListStore__c custom settings
        Set<String> subBuValueSet = new Set<String>();
        for(String val : tempSubBuValues.split(',')){
            subBuValueSet.add(val); 
            system.debug(LoggingLevel.DEBUG,'@@@SubBuValueSet inside for'+subBuValueSet);
        } 
        
        system.debug(LoggingLevel.DEBUG,'@@@SubBuValueSet'+subBuValueSet);
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        //if(strSubBu == 'USL' || strSubBu == 'FindLaw' || strSubBu == 'LMS' || strSubBu == 'US'){
        //if (strSubBuList != null && strSubBuList.contains(strSubBu)){
        //if(String.isNotEmpty(tempSubBuValues) && String.isNotBlank(tempSubBuValues) && tempSubBuValues.contains(strSubBu)){   
            System.debug(LoggingLevel.DEBUG, 'USL');
            if (Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){
                ssdList = [Select id, name, Source_System_Account_Number__c, Account_Name__c, LCRM_Sales_Org__c, LCRM_Sub_BU__c
                           from Source_System_Detail__c
                           Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c in :subBuValueSet and LCRM_Sales_Org__c != null];
            }
            return ssdList;
        /*} else{
            System.debug(LoggingLevel.DEBUG, 'Other Profiles ');
            if (Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){
                ssdList = [Select id, name, Source_System_Account_Number__c, Account_Name__c, LCRM_Sales_Org__c, LCRM_Sub_BU__c
                           from Source_System_Detail__c
                           Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c = :strSubBu and LCRM_Sales_Org__c != null];
            }
            return ssdList;*/
    }

    /**
     * displayLCRMSubcriptioninfo method
     * @description All Mandatory input parameters are passed from this method and also dont the authentication between two system and get the response from the external system
     Pagination functionalityperfomed on response list
     * @return paegreference
     */
    public pagereference displayLCRMSubcriptioninfo(){
        System.debug(LoggingLevel.DEBUG, '**call Method displayLCRMSubcriptioninfo**');
        listofSubscriptioninfo = new list<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        Map<String, SubscriptionTypes__c> mapSubscriptionTypes = SubscriptionTypes__c.getAll();

        sTranslatedSelectOption = '';
        final string applicationId = 'GLIEDW';
        String companyId = '';
        final String postBackURL = '';
        String includeActiveSubs = 'true';
        String includeLapsedSubs = 'true';
        // String maxResults = '250';
        String maxResults = LABEL.Subscription_Max_Results;
        String subType = 'ALL';
        final String startRecord = '1';
        String endRecord = '';
        String totalRecords = '';
        try{
            /*if (sSelectedOption == 'ALL Lapsed'){
             subType = 'ALL';
             includeActiveSubs = 'false';
             includeLapsedSubs = 'true';
             System.debug(LoggingLevel.DEBUG, 'sSelectedOption == ALL Lapsed**' + subType + sSelectedOption);

             }
             if (sSelectedOption == 'All Active'){
             subType = 'ALL';
             includeActiveSubs = 'true';
             includeLapsedSubs = 'false';
             }*/
            subType = LCRMSubscriptiondisplayInfoUtility.getSubtypes(sSelectedOption);
            includeActiveSubs = LCRMSubscriptiondisplayInfoUtility.getIncludeActiveTab(sSelectedOption);
            includeLapsedSubs = LCRMSubscriptiondisplayInfoUtility.getincludeLapsedSubs(sSelectedOption);
            /*if (sSelectedOption == 'Online'){
             subType = 'ONLINE';
             }
             if (sSelectedOption == 'FindLaw'){
             subType = 'FINDLAW';
             }
             if (sSelectedOption == 'Print'){
             subType = 'PRINT';
             }
             if (sSelectedOption == 'WPD'){
             subType = 'WPD';
             }*/

            //Sorting parameters set:
            List<LCRMsubscriptionsJsonWrapper.SortParmcls> listSortParms = new List<LCRMsubscriptionsJsonWrapper.SortParmcls>();

            /*if ((sSelectedOption == 'ALL Active' || sSelectedOption == 'ALL Lapsed')){
             listSortParms.add(new LCRMsubscriptionsJsonWrapper.SortParmcls());
             listSortParms[0].parmName = field;
             listSortParms[0].sortDirection = sortOrder;

             } else if ((sSelectedOption == 'WPD' || sSelectedOption == 'Online' || sSelectedOption == 'Print' || sSelectedOption == 'Findlaw')){

             listSortParms.add(new LCRMsubscriptionsJsonWrapper.SortParmcls());
             listSortParms[0].ParmName = field;
             listSortParms[0].sortDirection = sortOrder;
             }*/

            if (LCRMSubscriptiondisplayInfoUtility.sSelectedOptionForSort(sSelectedOption)){
                listSortParms.add(new LCRMsubscriptionsJsonWrapper.SortParmcls());
                listSortParms[0].ParmName = field;
                listSortParms[0].sortDirection = sortOrder;
            }
            sTranslatedSelectOption = LCRMSubscriptionUtility.gettranslatedSelectOption(sSelectedOption, sCurrentUser, mapSubscriptionTypes);
            /*if (sCurrentUser.LanguageLocaleKey == 'es'){
             if (sSelectedOption == 'All Active'){
             sTranslatedSelectOption = 'Todas las suscripciones Activas';
             }
             if (sSelectedOption == 'All Lapsed'){
             sTranslatedSelectOption = 'Todas las suscripciones Expiradas';
             }
             if (sSelectedOption == 'FindLaw'){
             sTranslatedSelectOption = 'Suscripciones FindLaw';
             }
             if (sSelectedOption == 'Online'){
             sTranslatedSelectOption = 'Suscripciones OnLine';
             }
             if (sSelectedOption == 'Print'){
             sTranslatedSelectOption = 'Suscripciones Impresas';
             }

             } else if (sCurrentUser.LanguageLocaleKey == 'pt_BR'){
             sTranslatedSelectOption = mapSubscriptionTypes.get(sSelectedOption).Portuguese__c;

             if (sSelectedOption == 'All Active'){
             sTranslatedSelectOption = 'Todas Assinaturas Ativas';
             }
             if (sSelectedOption == 'All Lapsed'){
             sTranslatedSelectOption = 'Todas Assinaturas Caducadas';
             }
             if (sSelectedOption == 'FindLaw'){
             sTranslatedSelectOption = 'FindLaw Assinaturas';
             }
             if (sSelectedOption == 'Online'){
             sTranslatedSelectOption = 'Assinaturas OnLine';
             }

             if (sSelectedOption == 'Print'){
             sTranslatedSelectOption = 'Assinturas Impresas';
             }

             } else{
             sTranslatedSelectOption = sSelectedOption + ' Subscriptions';
             }
             */
            if (applicationId == 'GLIEDW' && String.isnotblank(strSalesOrg) && accountSapIdList.size() > 0 && String.isnotblank(subType)){
                companyId = strSalesOrg.touppercase();
                //EsiHeadercls
                LCRMsubscriptionsJsonWrapper.EsiHeadercls esiHeaderRec = new LCRMsubscriptionsJsonWrapper.EsiHeadercls(applicationId, companyId, postBackURL);
                //Account
                List<LCRMsubscriptionsJsonWrapper.Accountcls> accountlst = new List<LCRMsubscriptionsJsonWrapper.Accountcls>();
                accountlst = LCRMSubscriptiondisplayInfoUtility.getAccountList(accountSapIdList);
                /*for (String accsap : accountSapIdList){
                    LCRMsubscriptionsJsonWrapper.Accountcls accountRe = new LCRMsubscriptionsJsonWrapper.Accountcls();
                    accountRe.accountNumber = accsap;
                    accountlst.add(accountRe);
                }*/
                /*System.debug(LoggingLevel.DEBUG, 'includeLapsedSubs:-' + includeLapsedSubs);
                 System.debug(LoggingLevel.DEBUG, 'subType:-' + subType);
                 System.debug(LoggingLevel.DEBUG, 'IncludeActive:-' + includeActiveSubs);
                 System.debug(LoggingLevel.DEBUG, 'StartRecords:-' + startRecord);
                 System.debug(LoggingLevel.DEBUG, 'EndRecords:-' + endRecord + 'Total Records' + totalRecords + 'MaxRecords:-' + maxResults + 'listSortParms:-' + listSortParms);
                 */
                LCRMsubscriptionsJsonWrapper.GetSubscriptionsByAccountFiltercls getSubscriptionsByAccountFilterRec = new LCRMsubscriptionsJsonWrapper.GetSubscriptionsByAccountFiltercls(subType, includeLapsedSubs, includeActiveSubs, startRecord, endRecord, totalRecords, maxResults, listSortParms);

                rwquestWrapper = new LCRMsubscriptionsJsonWrapper.LCRMSubscriptionRequestWrapper(esiHeaderRec, accountlst, getSubscriptionsByAccountFilterRec);
                //System.debug(LoggingLevel.DEBUG, 'rwquestWrapper:-' + rwquestWrapper);
                listofSubscriptioninfo = LCRMsubscriptionsJsonWrapper.getLcrmSubscriptionResponse(rwquestWrapper);
                //Pagination Logic starts
                Integer pageSize = 20;
                this.ordPaginater = new Paginate(listofSubscriptioninfo.size(), pageSize);
                //System.debug(LoggingLevel.DEBUG, 'ordPaginater-->' + this.ordPaginater);

                this.displaylcrmsubscription = new List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
                this.genericDisplaylcrmsubscription = new List<List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>>();
                //if (listofSubscriptioninfo.size() > 0){
                /*for (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse lst : listofSubscriptioninfo){

                 lst.MaterialNumber = LCRMSubscriptionUtility.checkMaterialNumber(lst);
                 if (String.isnotblank(lst.MaterialNumber)){
                 if (lst.MaterialNumber.startsWith('0')){
                 lst.MaterialNumber = lst.MaterialNumber.substring(10);
                 } else{
                 lst.MaterialNumber = lst.MaterialNumber;
                 }
                 }
                 }*/

                //This functionality is special used for rended the pageblock table
                if (listofSubscriptioninfo.size() > 0 && listofSubscriptioninfo[0].statusCode != '200' && listofSubscriptioninfo[0].statusCode != null){
                    renderedPgblock = true;
                    LCRMsubscriptionsJsonWrapper.subscriptionExceptionHandling(listofSubscriptioninfo[0].statusCode, listofSubscriptioninfo[0].statusDescription, webserviceName, strSalesOrg);
                    renderedNonInfo = true;
                    totalNumberOfSubscription = 0;
                } else if (listofSubscriptioninfo.size() > 0){
                    renderedPgblock = false;
                    renderedNonInfo = false;
                    totalNumberOfSubscription = listofSubscriptioninfo.size();
                    List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse> tempCC = new List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
                    Integer i = 0;
                    for (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse cc : listofSubscriptioninfo){
                        cc.MaterialNumber = LCRMSubscriptionUtility.checkMaterialNumber(cc);
                        //DSS-3663 code block start
                        cc.isselected = LCRMSubscriptionUtility.isSelectedDecision(selectedwrappermap, cc);
                        /*if ((selectedwrappermap != null && selectedwrappermap.containskey(cc.MaterialNumber)) || test.isrunningtest()){
                         cc.isselected = true;
                         }*/
                        if (i == pageSize){

                            this.genericDisplaylcrmsubscription.add(tempCC);
                            tempCC = new List<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
                            i = 0;
                        }
                        //DSS-3663 code block end
                        tempCC.add(cc);
                        i++;


                    }
                    System.debug(LoggingLevel.DEBUG, 'tempCC:-' + tempCC);
                    //if (!tempCC.isEmpty()){
                    this.genericDisplaylcrmsubscription.add(tempCC);
                    //}
                    System.debug(LoggingLevel.DEBUG, 'genericDisplaylcrmsubscription-->' + genericDisplaylcrmsubscription);
                    //Gets the correct list of data to show on the page
                    System.debug(LoggingLevel.DEBUG, '****index this.ordPaginater.index' + this.ordPaginater.index);
                    this.displaylcrmsubscription = this.genericDisplaylcrmsubscription.get(this.ordPaginater.index);

                    System.debug(LoggingLevel.DEBUG, 'displaylcrmsubscription-->' + displaylcrmsubscription);
                } else{
                    renderedNonInfo = true;
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMSubscriptionNoResponse));
                }

                /*} /*else{
                 renderedNonInfo = true;
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LCRMSubscriptionNoResponse));
                 }*/

            } else{
                renderedNonInfo = true;

            }

        } catch (Exception oException){
            if (oException.getMessage().contains('timed out')){
                ApexPages.addMessages(new AppUtil.AppException(Label.TimeOutException));
            } else{
                ApexPages.addMessages(oException);
                String strBody = 'the line number from where the exception was thrown is ' + oException.getLineNumber()+' and type of exception' + oException.getTypeName();
                String error = oException.getMessage();
                LCRMsubscriptionsJsonWrapper.logException(strBody, error, 'LCRM' + webserviceName + 'Services');
            }
        }
        return null;
    }

    /**
     * previousPage method
     * @description previousPage
     * @return change data method
     */
    public PageReference previousPage(){
        this.ordPaginater.decrement();
        return changeData();
    }

    /**
     * nextPage method
     * @description nextPage
     * @return change data method
     */
    public PageReference nextPage(){
        this.ordPaginater.increment();
        return changeData();
    }

    /**
     * Updatepage method
     * @description updatepage
     * @return change data method
     */
    public PageReference updatePage(){
        this.ordPaginater.updateNumbers();
        return changeData();
    }

    /**
     * changedata method
     * @description changedata
     * @return null
     */
    @testVisible
    private PageReference changeData(){
        this.displaylcrmsubscription = this.genericDisplaylcrmsubscription.get(this.ordPaginater.index);
        return null;
    }

    /**
     * SaveAsPDF method
     * @description saveAsPDF
     * @return PageReference
     */
    //DSS-3663 code block start
    public PageReference saveAsPDF(){
        processSelected();
        PageReference pr;
        if (sizeOfOpenMap > 0){
            pr = new PageReference('/apex/USLAccountSubscriptionDownloadPage');
            renderAsdoc = 'pdf';
            pr.setRedirect(false);
            return pr;
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select ateast one subscription to download'));
            return null;
        }
    }

    /**
     * saveAsExcel method
     * @description saveAsExcel
     * @return PageReference
     */
    public PageReference saveAsExcel(){
        processSelected();
        PageReference pr;
        if (sizeOfOpenMap > 0){
            pr = new PageReference('/apex/USLAccountSubscriptionDownloadPage');
            renderAsExcel = 'application/vnd.ms-excel#SubscriptionReport.xls';
            pr.setRedirect(false);
            return pr;
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select ateast one subscription to download'));
            return null;
        }
    }

    /**
     * processSelected method
     * @description processSelected
     */
    @testVisible
    private void processSelected(){
        Integer i = 0;
        for (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse wrapobj : selectedwrappertotal){
            if (wrapobj.isSelected == true){
                oSelectedmap.put(wrapobj.MaterialNumber + i, wrapobj);
                i++;
            }
        }
    }

    /**
     * saveselectedopen method
     * @description saveselectedopen
     */
    public void saveselectedopen(){
        for (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse wrapobj : displaylcrmsubscription){
            if (wrapobj.isselected){
                if (!selectedwrappermap.containskey(wrapobj.MaterialNumber)){
                    selectedwrappertotal.add(wrapobj);
                }
                selectedwrappermap.put(wrapobj.MaterialNumber, wrapobj);
            }
        }
    }

    // Changes are made to selectalllineitem() as part of MCL-2516
    /**
     * selectalllineitem method
     * @description selectalllineitem
     */
    public void selectalllineitem(){

        if (!tempSelectAll){
            tempSelectAll = true;
        } else{
            tempSelectAll = false;
        }

        selectedwrappertotal = new list<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        for (LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse wrapobj : listofSubscriptioninfo){
            selectedwrappertotal.add(wrapobj);
            selectedwrappermap.put(wrapobj.MaterialNumber, wrapobj);
            if (tempSelectAll){
                wrapobj.isselected = true;
            }
            if (!tempSelectAll){
                wrapobj.isselected = false;
                selectAll = false;
            }
        }
    }

    //DSS-3663 code block end
    /**
     * declarationOfVariables method
     * @description declarationOfVariables from constructor
     */
    @testVisible
    private void declarationOfVariables(){

        renderedNonInfo = false;
        renderedPgblock = false;
        tempSelectAll = false;
        listofSSD = new List<Source_System_Detail__c>();
        accountSapIdList = new List<String>();
        //DSS-3663 code block start
        selectedwrappermap = new map<string, LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        selectedwrappertotal = new list<LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        oSelectedmap = new map<string, LCRMsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        //DSS-3663 code block end
        field = 'MATERIAL_NUMBER';
        sortOrder = 'ascending';
        accountIdSet = new Set<ID>();
        totalNumberOfSubscription = 0;
    }

    /**
     * getCurrentUsermethod
     * @description get User Sobject for Constructor
     * @return User Sobject
     */
    @testVisible
    private User getCurrentUser(){
        User currentUser = new User();
        if (Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
            currentUser = [select LanguageLocaleKey, Sales_Org__c, Sub_Bu__c
                           from User
                           where id = :UserInfo.getUserId()];
        }
        return currentUser;
    }

    /**
     * getAccountSobject
     * @description get Account Sobject for Constructor
     * @param accId accountId
     * @return Account Sobject
     */
    @testVisible
    private Account getAccountSobject(Id accId){
        Account acc = new Account();
        if (Schema.sObjectType.account.isAccessible() || Schema.sObjectType.account.isQueryable()){
            acc = [select id, SAPAccountNumber__c, Account_Indicator__c, parentid, Sales_org__c
                   from account
                   where id = :accId];
        }
        return acc;
    }

    /**
     * getAccountSobject
     * @description get Account Sobject for Constructor
     * @param accSobj
     * @return Set Id
     */
    @testVisible
    private Set<Id> getAccountIdSets(Account accSobj){
        Set<Id> accIdSets = new Set<Id>();
        if (accSobj.parentid != null || accSobj.Account_Indicator__c == 'Branch'){
            accIdSets.add(accSobj.id);
        } else{
            List<Account> acclstSobj = new List<Account>();
            if (Schema.sObjectType.account.isAccessible() || Schema.sObjectType.account.isQueryable()){
                acclstSobj = [select id, SAPAccountNumber__c
                              from account
                              where id in :AccountDetailController.getChildAccountIds(accSobj.id)];

                System.debug(LoggingLevel.DEBUG, 'acclst:-' + acclstSobj);
                for (Account acc : acclstSobj){
                    //[select id,SAPAccountNumber__c from account where id in :AccountDetailController.getChildAccountIds(oAccount.id)])
                    accIdSets.add(acc.id);
                }
            }
        }
        return accIdSets;
    }
}