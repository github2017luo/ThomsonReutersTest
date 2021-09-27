/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                     Name                                          Description
 * 2018-10-25   Ramesh Reddy/Shiva Koralla        DLT-12928 [NSE SL/CP/GOV] Initiate Bridge Trial Passcode after every purchase
 * 2021-06-14	Ameeta A						  DLT-21859 [SLF][CORP][GOVT][MLF] Provide temporary Credentials to NTO Customer
 * ==================================================================================================================================   
 */
public  without sharing class Ecom_NonTrailPromoPassword {
    
    static final String WEST_LAW_NEXT = 'WestlawNext';
    
    @InvocableMethod(label='Trigger ST mails' description='It gets the NSE proposal Id from Proposal when its accepted and triggers short term credentials mail')
    public static void getqid(List<Id> qIdList) {
        //System.debug('@@@@@qIdList'+qIdList);
        for(Id ql : qIdList)
        {
            promotionCall(ql);
        }
        
    }
    
    public static void promotionCall(Id proposal) {
        try {
            promotions(proposal);
        } catch(Exception ex) {
            DCUtils.trackLog(ex,'Ecom_NonTrailPromoPassword','promotionCall, Future');
        }        
        
    }

    
    @future(callout=true)
    public static void promotions(String proposalId) {
        If(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible())
        {
        Apttus_Proposal__Proposal__c proposal = [
            SELECT Id, Apttus_Proposal__Account__c, Apttus_Proposal__Proposal_Name__c, APTS_Customer_Pricing_Segment__c, APTS_Proposal_Business_Unit__c,is_Digital_Channel__c 
            FROM Apttus_Proposal__Proposal__c 
            WHERE Id = :proposalId
        ];
        
        
        try {
            requestOpenPromotionsCall(WEST_LAW_NEXT, proposal);
        } catch(Exception ex) {
            DCUtils.trackLog(ex,'Ecom_NonTrailPromoPassword','requestOpenPromotionsCall');
        }
       }
    }
    
    
    // WestlawNext
    public static void requestOpenPromotionsCall(string sTabName, Apttus_Proposal__Proposal__c proposal) {
        String accountId = proposal.Apttus_Proposal__Account__c;
        APTSECOM_Store__c store;
        Boolean isWestLaw = false;
        Boolean isPracLaw = false;
        
        if(proposal.is_Digital_Channel__c){
            List<Apttus_Proposal__Proposal_Line_Item__c> propLinItemList = [Select Id, Name,Apttus_Proposal__Product__r.Name, Apttus_Proposal__Proposal__c FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =: proposal.id];
            
            for(Apttus_Proposal__Proposal_Line_Item__c pli : propLinItemList){
                String pliName = pli.Apttus_Proposal__Product__r.Name;
                if(pliName.containsIgnoreCase('Westlaw')){
                    isWestLaw = true;
                    break;
                }else{
                    isPracLaw = true;
                    break;
                }
            }
        }
        
        System.debug(LoggingLevel.INFO,'pricing'+proposal.APTS_Customer_Pricing_Segment__c+'name'+proposal.Apttus_Proposal__Proposal_Name__c+'Businessunit'+proposal.APTS_Proposal_Business_Unit__c);
        if(Schema.sObjectType.APTSECOM_Store__c.isAccessible() && Schema.sObjectType.APTSECOM_Store__c.isUpdateable() && proposal.APTS_Customer_Pricing_Segment__c == Label.ECOM_CORP_CUSTOMER_PRICING_SEGMENT) {
            if(proposal.Apttus_Proposal__Proposal_Name__c.contains('Corporate Westlaw') || isWestLaw ) {
               store = [
                   SELECT Id, Non_TrailPassword_Promotion_Number__c, APTSECOM_Store_Title__c 
                   FROM APTSECOM_Store__c 
                   WHERE APTSECOM_Store_Title__c =: 'Corporate Westlaw' LIMIT 1
               ];
            } else {
               store = [
                   SELECT Id, Non_TrailPassword_Promotion_Number__c, APTSECOM_Store_Title__c 
                   FROM APTSECOM_Store__c 
                   WHERE APTSECOM_Store_Title__c =: 'Corporate' LIMIT 1
               ];
            }
        }
        else if( (proposal.APTS_Customer_Pricing_Segment__c != Label.ECOM_CORP_CUSTOMER_PRICING_SEGMENT) 
          && (proposal.APTS_Proposal_Business_Unit__c != 'FindLaw') ) {
                
                if(proposal.Apttus_Proposal__Proposal_Name__c.contains('Small Law Practical Law') || isPracLaw) {
                    store = [
                        SELECT Id, Non_TrailPassword_Promotion_Number__c 
                        FROM APTSECOM_Store__c 
                        WHERE APTSECOM_Store_Title__c =: 'Small Law Practical Law' LIMIT 1
                    ];
                }
                else if(proposal.Apttus_Proposal__Proposal_Name__c.contains('Small Law') || isWestLaw ) {
                    store = [
                        SELECT Id, Non_TrailPassword_Promotion_Number__c, APTSECOM_Store_Title__c 
                        FROM APTSECOM_Store__c 
                        WHERE APTSECOM_Store_Title__c =: 'Small Law' LIMIT 1
                    ];
                } else {
                    store = [
                        SELECT Id, Non_TrailPassword_Promotion_Number__c 
                        FROM APTSECOM_Store__c 
                        WHERE APTSECOM_Customer_Pricing_Segment__c = :proposal.APTS_Customer_Pricing_Segment__c LIMIT 1
                    ];
                }            
        }
        
        List<Incentive_Promotion__c> selectedPromotions = requestOpenPromotions(sTabName, UserInfo.getUserId(), accountId, store);
        System.debug(LoggingLevel.INFO,'selectedPromotions > ' + selectedPromotions);
        requestPassword( selectedPromotions, getContactByAccountId(accountId), UserInfo.getUserId() );
        
    }
    
    
    // Reference  class: IncentivePasswordController, LineNO: 732 
    static List<Incentive_Promotion__c> requestOpenPromotions(string sTabName, id Assignedto, String accountId, APTSECOM_Store__c store){
        
        List<Incentive_Promotion__c> selectedPromotions = new List<Incentive_Promotion__c>();
        List<IncentivePasswordController.IncentivePromotion> listIncentivePromotions = new List<IncentivePasswordController.IncentivePromotion>();
        IncentivePasswordRegistration.OpenPromotionRequest oPromotionRequest = new IncentivePasswordRegistration.OpenPromotionRequest();
        
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
        oPromotionRequest.endpoint= oWebServiceSettings.Endpoint__c;
        oPromotionRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        //oPromotionRequest.username=oWebServiceSettings.Username__c;
        //oPromotionRequest.password= oWebServiceSettings.Password__c;
        try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();
          oPromotionRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
        IncentivePromoTypes__c oIncentivePromoTypes = IncentivePromoTypes__c.getInstance(sTabName);
        System.debug(LoggingLevel.INFO,'===oIncentivePromoTypes====' + oIncentivePromoTypes);
    
        oPromotionRequest.DomainName = oIncentivePromoTypes.DomainName__c;
        oPromotionRequest.CompanyCode = oIncentivePromoTypes.CompanyCode__c;
        oPromotionRequest.PromotionType = oIncentivePromoTypes.Type__c;
    System.debug(LoggingLevel.INFO,'===oPromotionRequest====' + oPromotionRequest);
        
        IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();
        List<IncentivePasswordRegistration.Promotion> listPromotions = oRegistrationService.requestOpenPromotions(oPromotionRequest);
        System.debug(LoggingLevel.INFO,'===listPromotions====' + listPromotions);
    
        for (IncentivePasswordRegistration.Promotion oRegistrationPromotion : listPromotions) {
            Incentive_Promotion__c oPromotion = new Incentive_Promotion__c();
      System.debug(LoggingLevel.INFO,'===oRegistrationPromotion====' + oRegistrationPromotion);
            oPromotion.Account__c = accountId;
            oPromotion.Assigned_To__c = Assignedto;
            //  oPromotion.Reason__c = PublicRecordsPromotion.Reason__c;
            oPromotion.Name = oRegistrationPromotion.PromotionId;
            oPromotion.Description__c = oRegistrationPromotion.Description;
            oPromotion.Promotion_Number__c = oRegistrationPromotion.PromotionNumber;
            oPromotion.Start_Date__c = oRegistrationPromotion.StartDate;
            oPromotion.End_Date__c = (oRegistrationPromotion.EndDate == date.valueof('9999-12-31') ? date.valueof('2999-12-31') : oRegistrationPromotion.EndDate);
            oPromotion.Domain_name__c = oRegistrationPromotion.DomainName;
            oPromotion.Promotion_key__c = oRegistrationPromotion.Key;
            oPromotion.Promotion_type__c = oRegistrationPromotion.Type;
            oPromotion.title__c = oRegistrationPromotion.Title;
            oPromotion.Company_Code__c = oRegistrationPromotion.CompanyCode;
            IncentivePasswordController.IncentivePromotion oIncentivePromotion = new IncentivePasswordController.IncentivePromotion();
            oIncentivePromotion.Promotion = oPromotion;
            
            if(oPromotion.Promotion_Number__c == store.Non_TrailPassword_Promotion_Number__c) {
                system.debug(LoggingLevel.INFO,'==oRegistrationPromotion=== > ' + oRegistrationPromotion);
                selectedPromotions.add(oPromotion);
                listIncentivePromotions.add(oIncentivePromotion);
                break;
            }
            
        }
        return selectedPromotions;
        // return listIncentivePromotions;
    }
    
    
    // Reference  class: IncentivePasswordController, LineNO: 793
    private static void requestPassword(List<Incentive_Promotion__c> selectedPromotions, List<contact> selectedContactList, String assigned_to){
        
        IncentivePasswordRegistration.PromotionPasswordRequest oPasswordRequest = new IncentivePasswordRegistration.PromotionPasswordRequest();
        List<Incentive_Password__c> ListIncentivePwds = new List<Incentive_Password__c>();
        system.debug(LoggingLevel.INFO,'==selectedPromotions=== > ' + selectedPromotions);
        for(Incentive_Promotion__c promotion : selectedPromotions) {
            oPasswordRequest.keys.add(promotion.promotion_key__c);                  
        }
        system.debug(LoggingLevel.INFO,'==selectedContactList=== > ' + selectedContactList);
        for(contact con:selectedContactList) {
            IncentivePasswordRegistration.PromotionUserContact cont = new IncentivePasswordRegistration.PromotionUserContact();
            cont.MdbContactId = (con.MDB_Contact_ID__c == null ? string.valueof(con.id) : con.MDB_Contact_ID__c);  
            //cont.USLContactId=string.valueof(con.id);  
            oPasswordRequest.Contacts.add(cont);
        }
        
        // westlaw would be False here 
        
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('Incentive Passwords');       
        oPasswordRequest.endpoint= oWebServiceSettings.Endpoint__c;
        oPasswordRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        //oPasswordRequest.username=oWebServiceSettings.Username__c;
        //oPasswordRequest.password= oWebServiceSettings.Password__c;
        try{
          String accessToken=DellBoomiTokenGeneration.getAuthToken();
          oPasswordRequest.accessToken=accessToken;
            }
                catch(Exception e){
                ApexPages.addMessages(e);
        } 
        IncentivePasswordRegistration oRegistrationService = new IncentivePasswordRegistration();        
        List<IncentivePasswordRegistration.PromotionPassword> listPasswords = oRegistrationService.requestPromotionPasswords(oPasswordRequest);
        List<Incentive_Promotion__c> incentivePromotions = new List<Incentive_Promotion__c>();
        List<Incentive_Promotion__c> incentivePromotionsupd = new List<Incentive_Promotion__c>();             
        Map<string,Incentive_Promotion__c> keyIdPair = new Map<string,Incentive_Promotion__c>();
        
        String accountId = '';
        for(Incentive_Promotion__c promotion : selectedPromotions) {
       system.debug(LoggingLevel.INFO,'==promotion=== > ' + promotion);
            promotion.Last_request_date__c = system.now();
            promotion.assigned_to__c = assigned_to;
            accountId = promotion.Account__c;
            
            keyIdPair.put(promotion.Promotion_Key__c, promotion);
            incentivePromotions.add(promotion); 
            
        }
        system.debug(LoggingLevel.INFO,'==incentivePromotions=== > ' + incentivePromotions);
        
        If(Schema.sObjectType.Incentive_Promotion__c.isAccessible() && Schema.sObjectType.Incentive_Promotion__c.isUpdateable() && Schema.sObjectType.Incentive_Promotion__c.isCreateable()) {
        upsert incentivePromotions; 
        }  
        
        
        Map<id, Contact> contactsTemplateMap = new Map<id, Contact>(selectedContactList);
      
        for(IncentivePasswordRegistration.PromotionPassword pwd : listPasswords) { 
            Incentive_Password__c oIncentivePwd = new Incentive_Password__c();
            oIncentivePwd.LCRM_Trial_Indicator__c = false;
            oIncentivePwd.LCRM_Automated_Email__c = true;
            
            for(contact con : selectedContactList) {
                if(con.mdb_contact_id__c != null && con.mdb_contact_id__c != '') {
                    if(con.mdb_contact_id__c == pwd.MdbContactId ) {
                        oIncentivePwd.contact__c = con.id;
                    } 
                } else {               
                    if(string.valueof(con.id) == pwd.MdbContactId) {
                        oIncentivePwd.contact__c = con.id;
                    }
                }                              
            }
            
            for(Incentive_Promotion__c promotion : selectedPromotions) {
                if(Promotion.promotion_key__c != null && promotion.promotion_key__c == pwd.PromoKey) {
                    oIncentivePwd.Promotion__c = keyIdPair.get(promotion.promotion_key__c).id;                           
                }    
            }
            
            oIncentivePwd.name = pwd.IncentiveOnlineId;
            oIncentivePwd.Password__c = pwd.IncentivePassword;
            oIncentivePwd.LCRM_Account__c = accountId;
            oIncentivePwd.Start_Date__c = pwd.IncentiveStartDate;
            oIncentivePwd.End_Date__c = pwd.IncentiveEndDate;
            ListIncentivePwds.add(oIncentivePwd);   
            
        }
       
        If(Schema.sObjectType.Incentive_Password__c.isAccessible() && Schema.sObjectType.Incentive_Password__c.isUpdateable() && Schema.sObjectType.Incentive_Password__c.isCreateable()) {
        insert ListIncentivePwds;
        system.debug(LoggingLevel.INFO,'===contactsTemplateMap=== > ' + contactsTemplateMap);
        sendEmailTemplateToPwdContact(contactsTemplateMap, ListIncentivePwds);
        }
    
    }
    
    
    private static void sendEmailTemplateToPwdContact(Map<id,Contact> sendEmailTemplateToPwdContact, List<Incentive_Password__c> ListIncentivePwds){
        boolean sendEmailcheck = true;
        If(Schema.sObjectType.EmailTemplate.isAccessible()){
        EmailTemplate nontrialtemplateId = [
            SELECT Id, Name, TemplateType 
            FROM EmailTemplate 
            WHERE Name = :Label.LCRM_NonTrial_EmailTemplateName
        ];
        
        List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();

        String LCRMSubBu = LCRMGenericComponent.getUserBU();
         //for(Contact con : sendEmailTemplateToPwdContact.values()){
        for(Incentive_Password__c pwdEmail : ListIncentivePwds) {                    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            // Who you are sending the email to
            Id contactId = pwdEmail.Contact__c;
            mail.setTargetObjectId(contactId);    
            // The email template ID used for the email 
            mail.setTemplateId(nontrialtemplateId.Id); 
            mail.setWhatId(pwdEmail.Id); 
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            // mail.setReplyTo('recruiting@acme.com'); 
            mail.setSenderDisplayName(Label.LCRM_EmailSender_Name);                
            mail.setSaveAsActivity(true); 
            System.debug(LoggingLevel.INFO,'mail' + mail);
            mailsList.add(mail);
            // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            
        }
        
        Messaging.sendEmail(mailsList);
       }
    }
    
    
    static List<Contact> getContactByAccountId(String recordid) {
        List<Contact> contList = new List<Contact>();
        If(Schema.sObjectType.Contact.isAccessible()){
            contList = [SELECT name,id, SAP_Contact_ID__c, FirstName, Email, Phone, Lastname, class__c, SAP_Role__c, MDB_Contact_ID__c FROM Contact WHERE Accountid = :recordid];
        }
                
       return contList;
        
    }
    
}