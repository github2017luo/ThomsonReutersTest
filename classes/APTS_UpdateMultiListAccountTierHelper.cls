/**
* @description Helper class of UpdateMultiListAccountTier for Order Capture functionality
*/
public without sharing class APTS_UpdateMultiListAccountTierHelper{
    
    public static PaymentgatewayUtil encryptData = new PaymentgatewayUtil();
    
    /**
     * @description Method for updating the Payment Gateway link in Order object
     * @param oldObjectsmap of type Map<Id,Source_System_Detail__c>
     * @param newObjects of type Source_System_Detail__c[]
    */
    public static void updatessdproporder(Map<Id,Source_System_Detail__c> oldObjectsmap,Source_System_Detail__c[] newObjects){
        List<Id> proposalIds = new List<Id>();
        Map<Id,Apttus_Config2__Order__c> orderMap = new Map<Id,Apttus_Config2__Order__c>();
        List<Apttus_Config2__Order__c> updateorderlist = new List<Apttus_Config2__Order__c>();
        proposalIds = queryrecords1(newObjects,oldObjectsmap);
        orderMap = queryrecords2(proposalIds);
        updateproposal(proposalIds);
        WebServiceSettings__c pGWebServiceSettings = new WebServiceSettings__c(); 
        pGWebServiceSettings = AppUtil.getWebServiceSettings('Payment AutoCharge'); 
        for(Apttus_Proposal__Proposal__c proposal : [Select id,Languagecode__c,OwnerId,APTS_Proposal_Business_Unit__c,Owner.Name,APTS_NACI_Form__c,APTS_Send_NACI_Form__c,Apttus_Proposal__Account__r.billingstreet,Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,Apttus_Proposal__Account__r.phone,Apttus_Proposal__Account__r.billingPostalCode ,APTS_Sold_To_SAP_Account_Number__c,APTS_Order_Confirmation_Contact__r.name,APTS_Order_Confirmation_Contact__r.email,APTS_SSD_Sold_To__r.name,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Assent_Name_of_Rep__r.Name,APTS_PaymentGateway_URL__c,Name,APTS_Quote_Value__c,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Order_Confirmation_Contact__c,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,APTS_SSD_Sold_To__r.City__c,APTS_SSD_Sold_To__r.Number_Street__c,APTS_SSD_Sold_To__r.State__c,APTS_SSD_Sold_To__r.Country__c,APTS_SSD_Sold_To__r.LCRM_Phone__c,APTS_SSD_Sold_To__r.Postal_Code__c,Credit_Check_Flag__c,APTS_Order_Confirmation_Contact__r.FirstName,APTS_Order_Confirmation_Contact__r.LastName,currencyISOCode from Apttus_Proposal__Proposal__c where Id IN :orderMap.keyset()]){
            String urlData;
            if(proposal.APTS_Payment_Option__c == 'One Time EFT'){
                urlData = encryptData.directdebit(proposal);
            }else if(proposal.APTS_Payment_Option__c != 'Bill To Account'){
                urlData = encryptData.encryption(proposal);
            }
            String ccurl;
            if(proposal.Languagecode__c == 'fr_CA' && proposal.APTS_Proposal_Business_Unit__c == 'Canada' ){
                ccurl=pGWebServiceSettings.Endpoint__c+'?lan=1&Paydet='+urlData ;   
            }else if(urlData != null){
                ccurl=pGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;
            }
            System.debug(LoggingLevel.DEBUG,'size@@@@@@@@@@@@'+orderMap.get(proposal.id));
            System.debug(LoggingLevel.DEBUG,'curl'+ccurl);
            //Added Busines Unit condition as part of DOC-4080
            if(proposal.APTS_Payment_Option__c != 'Bill To Account'){
                Apttus_Config2__Order__c temp = orderMap.get(proposal.id); 
                temp.paymenturl__c=ccurl;
                temp.AutopaymentEmailButton__c = true;
                temp.PaymentEmailSentFlag__c= true;
                System.debug(LoggingLevel.DEBUG,'update temp'+temp);
                updateorderlist.add(temp);
            }             
        }
        updateorder(updateorderlist);
    }
    
    /**
     * @description Method for collecting SSD and Proposal records
     * @param newObjects of type List<Source_System_Detail__c>
     * @param oldObjectsmap of type Map<Id,Source_System_Detail__c>
     * @return List<Id>
    */
    private static List<Id> queryrecords1(List<Source_System_Detail__c> newObjects,Map<Id,Source_System_Detail__c> oldObjectsmap){
        List<Id> uodatessdList = new List<Id>();
        List<Id> proposalIds = new List<Id>();
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        for(Source_System_Detail__c ssd : newObjects){
            Source_System_Detail__c oldSSD = oldObjectsmap.get(ssd.Id);
            if((oldSSD.Source_System_Account_Number__c!=ssd.Source_System_Account_Number__c)){
                uodatessdList.add(ssd.id);
            }
        }
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){ 
            proposalList = [Select id,APTS_Proposal_Business_Unit__c from Apttus_Proposal__Proposal__c where APTS_SSD_Sold_To__c in :uodatessdList];
        }
        for(Apttus_Proposal__Proposal__c prop:proposalList ){
            //Added Busines Unit condition as part of DOC-4080
            /*if(prop.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                taxpropIds.add(prop.id);
            }*/
            proposalIds.add(prop.id);
        } 
        return proposalIds;
    }
    
    /**
     * @description Method for collecting Order records
     * @param proposalIds of type List<Id>
     * @return Map<Id,Apttus_Config2__Order__c>
    */
    private static Map<Id,Apttus_Config2__Order__c> queryrecords2(List<Id> proposalIds){
        List<Apttus_Config2__Order__c> lorder = new List<Apttus_Config2__Order__c>();
        Map<Id,Apttus_Config2__Order__c> orderMap = new Map<Id,Apttus_Config2__Order__c>();
        if(Schema.sObjectType.Apttus_Config2__Order__c.isAccessible()){
            lorder = [Select id,AutopaymentEmailButton__c,name,paymenturl__c,Apttus_QPConfig__ProposalId__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__c in :proposalIds];
        }
        for(Apttus_Config2__Order__c ord : lorder){
            System.debug(LoggingLevel.DEBUG,ord.Apttus_QPConfig__ProposalId__c+'**********************'+ord);
            orderMap.put(ord.Apttus_QPConfig__ProposalId__c,ord);
        }
        return orderMap;
    }
    
    /**
     * @description Method for updating Payment Gateway mail in Proposal object
     * @param proposalIds of type List<Id>
    */
    private static void updateproposal(List<Id> proposalIds){
        List<Apttus_Proposal__Proposal__c> updateProposal = new List<Apttus_Proposal__Proposal__c>();
        WebServiceSettings__c creditIncreaseWebServiceSettings = new WebServiceSettings__c();
        creditIncreaseWebServiceSettings = AppUtil.getWebServiceSettings('PaymentCreditIncrease');
        for(Apttus_Proposal__Proposal__c proposal : [Select id,Languagecode__c,OwnerId,APTS_Proposal_Business_Unit__c,Owner.Name,APTS_NACI_Form__c,APTS_Send_NACI_Form__c,Apttus_Proposal__Account__r.billingstreet,Apttus_Proposal__Account__r.billingcity,Apttus_Proposal__Account__r.billingstate,Apttus_Proposal__Account__r.billingcountry,Apttus_Proposal__Account__r.phone,Apttus_Proposal__Account__r.billingPostalCode ,APTS_Sold_To_SAP_Account_Number__c,APTS_Order_Confirmation_Contact__r.name,APTS_Order_Confirmation_Contact__r.email,APTS_SSD_Sold_To__r.name,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Assent_Name_of_Rep__r.Name,APTS_PaymentGateway_URL__c,Name,APTS_Quote_Value__c,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Amount__c,APTS_One_Time_Ship_To__c ,APTS_Order_Confirmation_Contact__c,APTS_Assent_Customer_Name__c,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact_Email__c,APTS_Payment_Option__c,APTS_SSD_Sold_To__r.City__c,APTS_SSD_Sold_To__r.Number_Street__c,APTS_SSD_Sold_To__r.State__c,APTS_SSD_Sold_To__r.Country__c,APTS_SSD_Sold_To__r.LCRM_Phone__c,APTS_SSD_Sold_To__r.Postal_Code__c,Credit_Check_Flag__c,APTS_Order_Confirmation_Contact__r.FirstName,APTS_Order_Confirmation_Contact__r.LastName,currencyISOCode from Apttus_Proposal__Proposal__c where Id IN: proposalIds]){
            String crediturlData = encryptData.creditIncreaseEncryption(proposal);
            String creditccurl = creditIncreaseWebServiceSettings.Endpoint__c+'?Paydet='+crediturlData ;
            if(proposal .Languagecode__c =='fr_CA' && proposal.APTS_Proposal_Business_Unit__c=='Canada' ){
                creditccurl=creditIncreaseWebServiceSettings.Endpoint__c+'?lan=1&Paydet='+crediturlData ;   
            }
            if(creditccurl!=proposal.APTS_PaymentGateway_URL__c){
                System.debug(LoggingLevel.DEBUG,'Inside if');
                proposal.APTS_PaymentGateway_URL__c=creditccurl;
                if(proposal.APTS_Proposal_Business_Unit__c != 'Tax Professional'){
                    proposal.APTS_Send_NACI_Form__c=true;
                }
                System.debug(LoggingLevel.DEBUG,'URL'+proposal.APTS_PaymentGateway_URL__c);
                updateProposal.add(proposal);
            }
        }
        updateprop(updateProposal);
    }
    
    /**
     * @description Method for updating Proposal object
     * @param updateProposal of type List<Apttus_Proposal__Proposal__c>
    */
    private static void updateprop(List<Apttus_Proposal__Proposal__c> updateProposal){
        if(updateProposal != null && updateProposal.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
            update updateProposal;
        }
    }
    
    /**
     * @description Method for updating Order object
     * @param updateorderlist of type List<Apttus_Config2__Order__c>
    */
    private static void updateorder(List<Apttus_Config2__Order__c> updateorderlist){
        if(updateorderlist != NULL && updateorderlist.size() > 0 && Schema.sObjectType.Apttus_Config2__Order__c.isUpdateable()){
            update updateorderlist;
        }
    }
}