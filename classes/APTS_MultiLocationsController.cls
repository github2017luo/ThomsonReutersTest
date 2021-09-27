/**
 * @description
 */
public with sharing class APTS_MultiLocationsController{
    private string configId;
    public static string BusinessObj;
    public static string configReq;
    /**
     * @description
     */
    public string bundlePageUrlStr {get; set;}
    /**
     * @description
     */
    public string BusinessObjectId{get;set;}
    /**
     * @description
     */
    public string productConfig{get;set;}
    /**
     * @description
     */
    public string configRequestId{get;set;}
    /**
     * @description
     */
    public string groupId{get;set;}
    /**
     * @description
     */
    public APTS_Group__c bundleGroup {get; set;}
    /**
     * @description
     */
    public Apttus_Config2__ProductConfiguration__c Config {get; set;}
    /**
     * @description
     */
    private List<APTS_Quote_Agreement_Locations__c> existingAgreementLocations {get; set;}
    private List<APTS_Additional_Subscription_Actions__c> existingSubscriptionActions {get; set;}
    private List<APTS_Subscriber_Locations__c> subsriberLocations {get; set;}
    /**
     * @description
     */
    public string JSONAccountsData {get; set;}
    /**
     * @description
     */
    public string JSONExistingAgreementLocations {get; set;}
    /**
     * @description
     */
    public string JSONExistingSubscriptionActions {get; set;}
    /**
     * @description
     */
    public string JSONSubscriberLocations {get; set;}
    /**
     * @description
     */
    public Apttus_Proposal__Proposal__c Proposal {get; set;}

    /**
     * @description getting asset line items by accountIds
     * @param accountIds
     * @return list
     */
    //getting asset line items by accountIds
    @RemoteAction
    public static List<Apttus_Config2__AssetLineItem__c> getAccountAssets(List<Id> accountIds) {
        
        return [SELECT Id, Name, APTS_Deal_Number__c, APTS_Deal_Type__c, APTS_SAP_MLA_Agreement_Number__c,APTS_SSD_Sold_To__c, Apttus_Config2__NetPrice__c, Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, 
                    APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.Account_Name__r.Account_Name_2__c, APTS_SSD_Sold_To__r.Name, Apttus_Config2__ProductId__r.Name, APTS_Subscription_Number__c, APTS_Contract_Number__c, APTS_Contract_Line_Number__c        
        FROM Apttus_Config2__AssetLineItem__c WHERE Apttus_Config2__AssetStatus__c = 'Activated' AND Apttus_Config2__IsInactive__c = false AND APTS_SSD_Sold_To__c in :accountIds  AND APTS_SAP_MLA_Agreement_Number__c = null AND Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c in ('06', '13') order by Name,Apttus_Config2__LineNumber__c];
    }
    /**
     * @description getting asset line items by accountIds
     * @param controller
     * 
     */
    public APTS_MultiLocationsController(ApexPages.StandardController controller){
        configId = ApexPages.currentPage().getParameters().get('id');
        configRequestId = ApexPages.currentPage().getParameters().get('configRequestId');
        BusinessObjectId = ApexPages.currentPage().getParameters().get('businessObjectId');
        productConfig = ApexPages.currentPage().getParameters().get('id');
        groupId = ApexPages.currentPage().getParameters().get('groupId');

        // BundlePage link for cancel button
        bundlePageUrlStr = '/apex/APTS_BundleGroupPage?configRequestId='+configRequestId+'&businessObjectId='+BusinessObjectId+'&id='+productConfig+'&retId='+BusinessObjectId+'&flow=ngFlow';

        initConfig();
        initGroup();
        
    }

    private void initConfig(){
         Config  = new Apttus_Config2__ProductConfiguration__c();
         // Get the Configuration record
         if (Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
         Config =  [SELECT id, name, Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c, Apttus_Config2__BusinessObjectType__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,APTS_SSD_Sold_To__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id = :configId];
         }
         businessObj = config.Apttus_Config2__BusinessObjectType__c;
         Proposal = new Apttus_Proposal__Proposal__c();
         if (Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
         Proposal = [SELECT id, APTS_SSD_Sold_To__c FROM Apttus_Proposal__Proposal__c WHERE  id = :Config.Apttus_QPConfig__Proposald__c];}
    }
    /**
     * @description
     */
    public void doinit(){
        JSONAccountsData = JSON.serialize(getSourceSystemDetails());

        existingAgreementLocations = getExistingAgreementLocations();
        existingSubscriptionActions = getExistingSubscriptionActions();
        subsriberLocations = findSubscriberLocations();
        JSONExistingAgreementLocations = JSON.serialize(existingAgreementLocations);
        JSONExistingSubscriptionActions = JSON.serialize(existingSubscriptionActions);
        JSONSubscriberLocations = JSON.serialize(subsriberLocations);
    }

    private void initGroup(){
        if (Schema.sObjectType.APTS_Group__c.isQueryable()){
        bundleGroup = [select id, APTS_Group_Name__c, APTS_Primary_Material__c, APTS_Decentralized__c  from APTS_Group__c WHERE Id =:groupId];
        }
    }

  
    private List<Source_System_Detail__c> getSourceSystemDetails(){
        return [select Id, Name, Source_System_Account_Number__c, Account_Name__r.Account_Name_2__c,City__c, Number_Street__c,State__c, Postal_Code__c FROM Source_System_Detail__c        
            WHERE Id in (select Sold_To_Account_GLI__c from Business_Partner_Function__c WHERE Related_Account_GLI__c = :Proposal.APTS_SSD_Sold_To__c AND Relationship_Type__c = 'WESTLAW Reporting')];
    }

    private List<APTS_Quote_Agreement_Locations__c> getExistingAgreementLocations(){
        return [Select Id, APTS_Subscriber_Location_SSD__c, APTS_Status__c FROM APTS_Quote_Agreement_Locations__c WHERE APTS_Quote_Proposal__c = :Config.Apttus_QPConfig__Proposald__c];
    }

    private List<APTS_Additional_Subscription_Actions__c> getExistingSubscriptionActions(){
        return [Select Id, APTS_Subscription_Number__c, APTS_Product__c FROM APTS_Additional_Subscription_Actions__c WHERE APTS_Quote_Proposal__c = :Config.Apttus_QPConfig__Proposald__c]; 
    }

    // Searching Subscriber Locations for location status Existing
    private list<APTS_Subscriber_Locations__c> findSubscriberLocations(){
        
        List<Apttus_Config2__LineItem__c> lineItems = [select Id, Name, APTS_SAP_MLA_Agreement_Number__c, APTS_Keep_Terms__c from Apttus_Config2__LineItem__c WHERE APTS_Proposal_Group__c =:groupId AND Apttus_Config2__ConfigurationId__c =:Config.Id AND APTS_SAP_MLA_Agreement_Number__c != null];

        if(lineItems == null || lineItems.size() == 0 || !lineItems.get(0).APTS_Keep_Terms__c){
            return null;
        }

        String agreementNumber = lineItems.get(0).APTS_SAP_MLA_Agreement_Number__c;

        list<APTS_Subscriber_Locations__c> subsriberLocations = getSubsriberLocations(Proposal.APTS_SSD_Sold_To__c, agreementNumber);        
        return subsriberLocations;
    }
    /**
     * @description
     * @param accountSSDId
     * @param agreementNumber
     * @return ''
     */
    public list<APTS_Subscriber_Locations__c> getSubsriberLocations(Id accountSSDId, String agreementNumber){
        
        return [Select Id, APTS_Subscriber_Location_SSD__c From APTS_Subscriber_Locations__c WHERE APTS_Status__c = 'Active' AND  APTS_Asset_Line_Item__c in 
                    (SELECT Id FROM Apttus_Config2__AssetLineItem__c WHERE Apttus_Config2__AssetStatus__c = 'Activated' AND Apttus_Config2__IsInactive__c = false 
            AND APTS_SAP_MLA_Agreement_Number__c = :agreementNumber AND APTS_SSD_Sold_To__c = :accountSSDId AND Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c = 'Q6')];
    }
    /**
     * @description
     */
    public pageReference saveData(){
        string JsonReturnedData = ApexPages.currentPage().getParameters().get('JSONData');
        system.debug(LoggingLevel.WARN,'###JsonReturnedData '+JsonReturnedData);
        //GroupLNWrapper GrpWrapper =  new GroupLNWrapper();
        string makeJSONStr = '{"ML":'+JsonReturnedData+'}';
        //system.debug('###makeJSONStr '+makeJSONStr);
        string parsedFilteredData = JsonReturnedData.replace('T00:00:00.000Z','');
        //system.debug('###parsedFilteredData '+parsedFilteredData);
        JSONParser parser = JSON.createParser(parsedFilteredData);        
        system.debug(LoggingLevel.WARN,'###parser '+parser);
        JSONReadClass WrapData = (JSONReadClass)parser.readValueAs(JSONReadClass.class);
        system.debug(LoggingLevel.WARN,'##WrapData '+WrapData);
        if(parseAndSaveData(WrapData)){
            pageReference pageRef = new pagereference('/apex/APTS_BundleGroupPage');
            pageRef.getParameters().put('configRequestId',configRequestId);
            pageRef.getParameters().put('businessObjectId',BusinessObjectId);
            pageRef.getParameters().put('retId',BusinessObjectId);
            pageRef.getParameters().put('id',productConfig);
            pageRef.getParameters().put('flow', 'ngFlow');
            pageRef.getParameters().put('isMLA', 'true');
            pageRef.getParameters().put('decentralized', String.valueOf(WrapData.decentralized));
            pageRef.setRedirect(true);
            return pageRef;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error'));
            return null;
        }
    }

    private boolean parseAndSaveData(JSONReadClass DataWrapClass){
        list<APTS_Quote_Agreement_Locations__c> bundleLocations = new list<APTS_Quote_Agreement_Locations__c>();
        list<APTS_Additional_Subscription_Actions__c> existingSubscriptions = new list<APTS_Additional_Subscription_Actions__c>();

        Set<Id> accountsToSave = new Set<Id>();
        Set<String> assetLineItemsToSave = new Set<String>();

        
        // Delete the exist data list 
        if(existingAgreementLocations != null && !existingAgreementLocations.isEmpty()){
            delete existingAgreementLocations;}
        
        
        // Delete the exist data list 
        if(existingSubscriptionActions != null && !existingSubscriptionActions.isEmpty()){
            delete existingSubscriptionActions;}

        if(DataWrapClass.SourceSystemDetails!= null && !DataWrapClass.SourceSystemDetails.isEmpty()){
            for(MLAccountWrapper accountWrapper : DataWrapClass.SourceSystemDetails){
                if(accountWrapper != null && accountWrapper.status != 'N/A'){
                    APTS_Quote_Agreement_Locations__c bundleLocation = new APTS_Quote_Agreement_Locations__c();
                    bundleLocation.APTS_Subscriber_Location_SSD__c = accountWrapper.ssd.Id;
                    bundleLocation.APTS_Quote_Proposal__c = Config.Apttus_QPConfig__Proposald__c;
                    bundleLocation.APTS_Status__c = accountWrapper.status;
                    bundleLocations.add(bundleLocation);
                    accountsToSave.add(accountWrapper.ssd.Id);
                }
            }
        }

        if(DataWrapClass.assetLineItems != null && !DataWrapClass.assetLineItems.isEmpty()){
            for(MLAssetLineItemWrapper assetLineItemWrapper : DataWrapClass.assetLineItems){
                if(assetLineItemWrapper != null && assetLineItemWrapper.isSelected){
                    APTS_Additional_Subscription_Actions__c subsciption = new APTS_Additional_Subscription_Actions__c();
                    subsciption.APTS_Quote_Proposal__c = Config.Apttus_QPConfig__Proposald__c;
                    subsciption.APTS_Sold_To_SSD__c = assetLineItemWrapper.assetLineItem.APTS_SSD_Sold_To__c;
                    subsciption.APTS_Subscription_Number__c = assetLineItemWrapper.assetLineItem.APTS_Subscription_Number__c;
                    subsciption.APTS_Product__c = assetLineItemWrapper.assetLineItem.Apttus_Config2__ProductId__r.Name;
                    subsciption.APTS_Line_Status__c = 'Cancelled';
                    subsciption.APTS_Contract_Number__c = assetLineItemWrapper.assetLineItem.APTS_Contract_Number__c;
                    subsciption.APTS_Contract_Line_Number__c = assetLineItemWrapper.assetLineItem.APTS_Contract_Line_Number__c;

                    existingSubscriptions.add(subsciption);
                    assetLineItemsToSave.add(assetLineItemWrapper.assetLineItem.APTS_Subscription_Number__c+subsciption.APTS_Product__c);
                }
            }
        }

       
        if(!bundleLocations.isEmpty()){
            upsert bundleLocations;}
        
        
        if(!existingSubscriptions.isEmpty()){
            upsert existingSubscriptions;}

        // Delete unchecked rows
        /*List<APTS_Quote_Agreement_Locations__c> agreementsToDelete = new List<APTS_Quote_Agreement_Locations__c>();
        List<APTS_Additional_Subscription_Actions__c> subscriptionActionsToDelete = new List<APTS_Additional_Subscription_Actions__c>();

        if(existingAgreementLocations != null){
            for(APTS_Quote_Agreement_Locations__c existingAgreementLocation : existingAgreementLocations){
                if(!accountsToSave.contains(existingAgreementLocation.APTS_Subscriber_Location_SSD__c))
                    agreementsToDelete.add(existingAgreementLocation);
            }
        }

        if(existingSubscriptionActions != null){
            for(APTS_Additional_Subscription_Actions__c existingSubscriptionAction : existingSubscriptionActions){
                if(!assetLineItemsToSave.contains( existingSubscriptionAction.APTS_Subscription_Number__c+existingSubscriptionAction.APTS_Product__c ))
                    subscriptionActionsToDelete.add(existingSubscriptionAction);
            }
        }

        if(!agreementsToDelete.isEmpty())
            delete agreementsToDelete;

        if(!subscriptionActionsToDelete.isEmpty())
            delete subscriptionActionsToDelete;*/

        return true;
    }
    /**
     * @description
     */
    public class JSONReadClass{
        
        public boolean decentralized;
        /**
         * @description
         */
        public list<MLAccountWrapper> SourceSystemDetails{get; set;}
        /**
         * @description
         */
        public list<MLAssetLineItemWrapper> assetLineItems{get; set;}
        /**
         * @description
         * @param SourceSystemDetails
         * @param assetLineItems
         * @param decentralized
         */
        
        public JSONReadClass(list<MLAccountWrapper> SourceSystemDetails, list<MLAssetLineItemWrapper> assetLineItems, boolean decentralized){
            this.SourceSystemDetails = SourceSystemDetails;
            this.assetLineItems = assetLineItems;
            this.decentralized = decentralized;
        }
    }
    /**
     * @description
     */
    public class MLAccountWrapper{

        public Id id;
        public String status;
        /**
         * @description
         */
        public Source_System_Detail__c ssd {get; set;}
        /**
         * @description
         */
        public boolean isSelected {get; set;}
        
        /**
         * @description
         * @param ssd
         * @param isSelected
         * @param id
         * @param status
         */
        public MLAccountWrapper(Source_System_Detail__c ssd, boolean isSelected, Id id, String status){
            this.ssd = ssd;
            this.isSelected = isSelected;
            this.id = id;
            this.status = status;
        }
    }
    /**
     * @description
     */
    public class MLAssetLineItemWrapper{
        public Id id;
        /**
         * @description
         */
        public Apttus_Config2__AssetLineItem__c assetLineItem {get; set;}
        /**
         * @description
         */
        public boolean isSelected {get; set;}
        /**
         * @description
         * @param assetLineItem
         * @param isSelected
         * @param id
         */
        public MLAssetLineItemWrapper(Apttus_Config2__AssetLineItem__c assetLineItem, boolean isSelected, Id id){
            this.assetLineItem = assetLineItem;
            this.isSelected = isSelected;
            this.id = id;
        }
    }
    /**
     * @description 
     * @return pr
     */
    public PageReference openCartPage() {
        PageReference pr = new PageReference(bundlePageUrlStr);
        pr.setRedirect(true);
        return pr;
    }
}