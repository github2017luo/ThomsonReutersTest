/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                  Name                                    Description
 * 2018-04-20   Shiva Sri Arun Koralla          DLT-8514 [NEW CUSTOMER - Buy Plan SL] Create Opportunity
 * 2018-06-28   Shiva Sri Arun Koralla          DLT-9978 [GLI] Update object field references for class "Ecom_Opportunity"
 * 2018-08-28   Shiva/Ramesh                    DLT-11546 [TECH STORY- SFDC] - Update calls as per new UI for checkout
 * 2018-08-28   Shiva Sri Arun Koralla          DLT-11729 [Tech story] [Code Scan] Fix Ecom_opportunity
 * 2018-09-12   Samreen Ali                     DLT-11472 [Update GLI field with Promo Code]- Update field Digital Promo Code
 * 2018-09-24   Samreen Ali                     DLT-12429 [Populate Sub-BU field]- Populate this field with value 'USL' 
 * 2018-10-12   Shiva Sri Arun Koralla          DLT-12343 [NSE]Update GLI Salesforce Mappings 
 * 2019-03-12   Samreen Ali                     DLT-15097 [NSE SL] Add 'Custom' to Lead/Opportunity Description field for Custom plan
 * 2019-03-18   Samreen Ali                     DLT-15640 [NSE ALL]Populate Description value from Lead to Opportunity when Converted
 * 2019-03-27   Samreen Ali                     DLT-15332 [Tech Story][NSE FL] Create/Assign Campaign ID's to SFDC
 * 2019-04-18   David Hoel                      DLT-16115 [NSE FL/GOV] Assign Campaign ID's to Gov & FL Orders
 * 2020-07-27   Benjamin Her                    DLT-20456 [Tech Story] Removal of unused Account fields. PMD Fixes
 * 2020-09-04   Benjamin Her                    DLT-20682 [NSE] Fix Promo Code issue - Resolve Invalid ID from Corp Store
 * 2021-01-20   Brenda Shields                  DLT-21352 [SFDC][ALL SEGMENTS][NSE]- Lead Primary Campaign Source
 * 2021-02-12   Kavya S                         DLT-21389 [SFDC][ALL SEGMENTS][NSE]- Desiginate Pure Digital Opportunities  
 * 2021-03-12   Kavya S                         DLT-21508 [SFDC][GOVT][Practical law][NSE] Create Account, Contact, SSD's, Opportunity, Proposal and Lead
 * 2021-05-14   Brenda Shields                  DLT-21637 If a default campaign code was used, set it to a place order Campaign code
 * ==================================================================================================================================   
 */
 
 /** 
 * @description : Utility functions for Updating the Opportunity
 */ 
public with sharing class Ecom_Opportunity
{  
   
    private static String description = '';

    /** 
     * @description : Update GLI Opportunity
     * @param oppid : Opportunity id
     * @param gliCon : Contact id
     * @param ssdAcc : SSD Account  
     * @param ownerId : Owner Id
     * @param storeOrder : Store Order   
     * @param leadDesc : Lead description
     * @param leadtrackingcode : Lead tracking code
     * @param leadoffercode : Lead offer code
     * @return : Opportunity
     */
    public static Opportunity updateConvertedOpportunity(String oppid,Contact gliCon, Source_System_Detail__c ssdAcc, String ownerId, Ecom_OrderRequest.cls_storeOrder storeOrder, String leadDesc, String leadtrackingcode, String leadoffercode)
    {
        Id oppOwner = ownerId;
        Id priceBookId;

    priceBookId = getPriceBook(string.valueof(storeOrder.storeName));
    /*
        if(storeOrder.storeName == 'FindLaw'){
            priceBookId = [SELECT id FROM pricebook2 WHERE name = 'GLI Price Book - FindLaw' LIMIT 1].id;
        }
        else{
            priceBookId = [SELECT id FROM pricebook2 WHERE name = 'GLI Price Book - US Legal/LMS' LIMIT 1].id;
        }
        */
        
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity opp = new Opportunity();
        Opportunity oppstage = [Select Name FROM Opportunity where Id =:oppid];
        
        opp.id = oppid;
        opp.Source_System_Detail__c = ssdAcc.Id;
        opp.CloseDate = Date.today();
        opp.RecordTypeId = recordTypeId;
        opp.Pricebook2Id = priceBookId; 
        opp.Is_Digital_New_Sales__c = true;
        opp.Is_GLI__c = true;
        opp.OwnerId = oppOwner; 
        opp.Key_Contact__c = gliCon.Id; 
        Boolean res;
        //DLT-21389
        String oppname=oppstage.Name;
        String newWord = 'Assisted ' + oppname ;
        opp.Name=newWord;
        
        // Note: Do not change the sequence of if condition
        opp = setOpportunityFieldsFromMapping(opp);
            
        if(leadtrackingcode != null)
        {
            opp.Campaign_Tracking_Code__c = leadtrackingcode; // Update lead Tracking code
        } 
        
        if(leadoffercode != null)
             {
            opp.Offer_Code__c = leadoffercode;
            opp.CampaignId = leadoffercode;
        }
        
        if(leadDesc != null){
            if(opp.Description != null){
                opp.Description = leadDesc + ';' + opp.Description;
            }
            else{
                opp.Description = leadDesc; // Update lead Description
            }
        }
        res = leadDesc.contains(Label.Ecom_GetQuote_Clicked);
        if(storeOrder.additionalInfo.isGetQuoteClicked == true && res == false)
        {
          opp.Description =  opp.Description + ' ' + Label.Ecom_GetQuote_Clicked;
        }
        
        if(storeOrder.promocode != null)  
        {
          opp.Digital_Promo_Code__c = storeOrder.promocode; // Update promo code field          
        }
        
                                                                                                                                  
        System.debug(LoggingLevel.INFO, '====Opportunity Field Values===' + opp); 

        if(Schema.sObjectType.Opportunity.isUpdateable())
        {
           update opp;
        }
        return opp;
        
    }
    
    
    private static id getPriceBook(string storeName) {
    Id priceBookId;
    
        if(storeName == 'FindLaw'){
            priceBookId = [SELECT id FROM pricebook2 WHERE name = 'GLI Price Book - FindLaw' LIMIT 1].id;
        }
        else{
            priceBookId = [SELECT id FROM pricebook2 WHERE name = 'GLI Price Book - US Legal/LMS' LIMIT 1].id;
        }
        return priceBookId;
    }  

    //setOpportunityFieldsFromMapping() method
    //Set opportunity fields based on Ecom_OrderService_Mappings__mdt
    private static Opportunity setOpportunityFieldsFromMapping(Opportunity opp){

        Opportunity tempOpp = opp;
        for(Ecom_OrderService_Mappings__mdt ordSerMap : [SELECT Id, DeveloperName, Ecom_Owner__c, Ecom_StoreName__c, Customer_Pricing_Segment__c, 
                                                            Ecom_Field_API__c, Ecom_Field_Value__c, Ecom_Object__c 
                                                        FROM Ecom_OrderService_Mappings__mdt 
                                                        WHERE Ecom_Object__c = 'Opportunity'])
        {
            if(ordSerMap.Ecom_Field_API__c == 'Description'){
                description = ordSerMap.Field_Value__c;
                continue;
            }
            tempOpp.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
        }

        return tempOpp;
    }//end of setOpportunityFieldsFromMapping() method
    
    
    /** 
     * @description : used in Ecom_order Service
     * @param opportunityId : Opportunity id
     * @param customerDetails : Customer Details
     */
    public static void updateOpportunityForOrganizationchange(String opportunityId, Ecom_OrderRequest.cls_customerDetails customerDetails)
    {
        Opportunity oppUpdate = new Opportunity();
        oppUpdate.Id = opportunityId;                     
        oppUpdate.Name = customerDetails.organizationName; 
        update oppUpdate;           
    }
    
  
    /** 
     * @description : Method to update campaignId on opportunity when Opportunity StageName Changes and update promo code on opportunity- Ecom_orderservice Call  
     * @param ref : Class reference
     * @param storeOrder : store Order
     */    
    public static void updateOpportunityWithCampaignCode(Ecom_OrderRequest.cls_references ref, Ecom_OrderRequest.cls_storeOrder storeOrder)
    {    
        Opportunity oppStage = [SELECT Name, StageName, Source_System_Detail__r.LCRM_Customer_Group__c 
                    FROM Opportunity WHERE Id = :ref.opportunityId AND AccountId = :ref.accountId];
        
        Opportunity opp = new Opportunity();
        opp.Id = ref.opportunityId;
        //DLT-21389
        String oppname = oppStage.Name;
        String stringToRemove = 'Assisted';
        String result = oppname.remove(stringToRemove);
        opp.Name=result;
        
        if (oppStage.StageName == System.Label.Ecom_Stage_NegotiateContract || oppStage.StageName == System.Label.Ecom_Stage_ContractSigned 
          || oppStage.StageName == System.Label.Ecom_Stage_OrderComplete) {   
            try {
                opp.CampaignId = getCampaignId(oppStage,storeOrder);
            } catch(Exception ex) {
                DCUtils.trackLog(ex,'Ecom_Opportunity','updateOpportunityWithCampaignCode');
            }
        }
                 
        if (storeOrder.promocode != null) {
            opp.Digital_Promo_Code__c = storeOrder.promocode;   // update promo code 
        } else {
            opp.Digital_Promo_Code__c = '';
        }
        
        if (Schema.sObjectType.Opportunity.isUpdateable()) {    
           update opp;
        }       
    }


    /** 
     * @description : getCampaignId() method
     * @param opp : Opportunity record
     * @param storeOrder : store Order
     * @return : 'campaignId' based on the SSD's Customer Group
     */     
    public static String getCampaignId(Opportunity opp, Ecom_OrderRequest.cls_storeOrder storeOrder){
        // set list of default campaign codes
        list<string> lstDefaultCampaigns = system.label.Ecom_DefaultCampaigns.split(',');
        String campaignId = '';
        
        // DLT-21352 - if a primary campaign has already been set on the Lead, use that campaign and do not set a default
        list<Lead> oLead = new list<Lead>();

        if (Schema.sObjectType.Lead.isQueryable()) {
            oLead = [select Id, ConvertedOpportunityId, Primary_Campaign_Source__c
          			from Lead where ConvertedOpportunityId =: opp.Id];
        }
        // set the campaign code that was on the lead
        if (!oLead.isEmpty() && oLead[0].Primary_Campaign_Source__c != null) {
        	system.debug(logginglevel.INFO, 'Found Campaign: ' + campaignId);
          	campaignId = oLead[0].Primary_Campaign_Source__c;
        }
        // if this campaign is not a default code, use it, else set one of the place order codes
        if (campaignId != '' && !lstDefaultCampaigns.contains(campaignId)) {
        	system.debug(logginglevel.INFO, 'Campaign Good: ' + campaignId);
          	return campaignId;
        }
		system.debug(logginglevel.INFO, 'Set Default Campaign');
    	// set the appropriate place order campaign code
        if(opp.Source_System_Detail__r.LCRM_Customer_Group__c == 'FIRM') // small law
        {
            campaignId  = System.Label.Ecom_SmallLaw_CampaignCode;
        }
        else if(opp.Source_System_Detail__r.LCRM_Customer_Group__c == 'CORPORATION')  // corporate
        { 
            campaignId = getCorporateCampaignId(storeOrder.selectedProducts[0].productId);
        } 
        else if(opp.Source_System_Detail__r.LCRM_Customer_Group__c == 'GOVERNMENT')  // government
        {
            campaignId  = System.Label.Ecom_Government_CampaignCode;
        }
        
        if(storeOrder.storeName == 'FindLaw')  // findlaw
        {
            campaignId  = System.Label.Ecom_FindLaw_CampaignCode;
        }
        
        if(storeOrder.storeName == 'Small Law Practical Law')
        {
            campaignId  = System.Label.Ecom_PLSmallLaw_CampaignCode;
        }
        //DLT-21508 - Creating deafult Campaign ID for GovtPL 
       if(storeOrder.storeName == 'Government Practical Law')
        {    
           campaignId  = System.Label.Ecom_GovtPracticalLaw;
        }
	system.debug(logginglevel.INFO, 'New Campaign: ' + campaignId);
        return campaignId;
    } //end of getCampaignId() method


    /** 
     * @description : getCorporateCampaignId()
     * @param productId : Product Id
     * @return : 'campaignId' for Corp customer based on Product Familiy
     */       
    public static String getCorporateCampaignId(Id productId){
        String campaignId = '';
        List<Product2> prod2 = new List<Product2>();
        List<Campaign> campaignl = new List<Campaign>();

        if (Schema.sObjectType.Product2.isQueryable()) {
            prod2 = [SELECT Family FROM Product2 WHERE id =: productId];
        }
        if (Schema.sObjectType.Campaign.isQueryable()) {
            campaignl = [SELECT Id FROM Campaign WHERE Id =: System.Label.Ecom_CorporateWestlaw_CampaignCode];
        }

        if (!prod2.isEmpty() && prod2[0].Family != '') {
            String productfamily = prod2[0].Family;

            if (productfamily.contains('WEST') && !campaignl.isEmpty()) {
                System.debug(LoggingLevel.INFO, '===opp.CampaignId1====' + campaignl[0].Id);
                campaignId = System.Label.Ecom_CorporateWestlaw_CampaignCode;
            } else if (productfamily.contains('PRACTICAL')) {
                campaignId = System.Label.Ecom_Corporate_CampaignCode;
            }
        }
        
        return campaignId;
    } //end of getCorporateCampaignId() method


    /** 
     * @description : Create a Lead History
     * @param accountId : Account id
     * @param contactId : Contact id
     * @param oppId : Opportunity id  
     * @param ownerId : Owner Id
     * @param leadDetails : Details from Lead                 
     */ 
    public static void createLeadHistory(String accountId, String contactId, String oppId, String ownerId, Lead leadDetails)
    {
         
         System.debug(LoggingLevel.INFO, '===lead details in his'+leadDetails);
         
        LM_Lead_History__c lHistory = new LM_Lead_History__c();

        lHistory.name= leadDetails.name;
        lHistory.Account_Name__c= leadDetails.company; 
        lHistory.Name__c = leadDetails.name;
        lHistory.Status__c = 'Sales Qualified';
        lHistory.Lead_Source__c = leadDetails.LeadSource;
        lHistory.Source_Type__c = leadDetails.Source__c;
        lHistory.Source_Desc__c = leadDetails.Source_Desc__c;
        lHistory.Primary_Campaign_Source__c = leadDetails.Primary_Campaign_Source__c;
        lHistory.Tracking_Code__c = leadDetails.Tracking_Code__c;
        lHistory.Campaign_Code__c = leadDetails.Campaign_Code__c;
        lHistory.Campaign_Cell__c = leadDetails.Campaign_Cell__c;
        lHistory.LeadID18__c = leadDetails.LeadID18__c;
        lHistory.Lead__c = leadDetails.id;
        lHistory.Lead_ID__c = leadDetails.id;
        lHistory.Opportunity__c = oppId;
        lHistory.Account_ID__c = accountId;
        lHistory.Contact__c = contactId;
        lHistory.Lead_Owner__c = 'SLF Synergy';
        lHistory.OwnerId = ownerId;
        lHistory.Operating_Unit__c = leadDetails.Operating_Unit__c;
        lHistory.Line_of_Business__c = leadDetails.Line_of_Business__c;
        // Check if the user has create access on the Lead object
        try {
            if (Schema.sObjectType.LM_Lead_History__c.isCreateable()) {
                insert lHistory;
            } else {
                throw new DCCustomException('Failed to insert Lead History');
            }
        } catch(Exception ex) {
            DCUtils.trackLog(ex,'Ecom_lead','createLeadHistory');
        }

    }
    
}