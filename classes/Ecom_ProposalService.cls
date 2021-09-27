/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date                 Name                                            Description
 * 2018-04-18   Ramesh Reddy                    DLT-8515 - [NEW CUSTOMER - Buy Plan SL] Create Proposal
 * 2018-06-28   Shiva Sri Arun Koralla          DLT-9978 [GLI] Update object field references for class "Ecom_ProposalService"
 * 2018-07-17   Prashob Anto                    DLT-1063 [Code Scan]
 * 2018-08-28   Shiva/Ramesh                    DLT-11546 [TECH STORY- SFDC] - Update calls as per new UI for checkout
 * 2018-08-28   Shiva Sri Arun Koralla          DLT-11729 [Tech story] [Code Scan] Fix Ecom_proposalservice
 * 2018-11-19   Ramesh Reddy                    DLT-13117 - [NSE ALL] Create a 2nd SSD Account for Guest Users with different physical address
 * 2019-01-18   Shiva Sri Arun Koralla          DLT-14087 [NSE ALL] Enroll Customer into E-Billing unless opting out
 * 2019-02-14   Samreen Ali                     DLT-15124 [NSE CP] Update Proposal Name to '<Account Name> Practical Law Order'
 * ==================================================================================================================================   
 */

public without sharing class Ecom_ProposalService 
{ 
    
    private Static Final String PRODUCT_PRICING_MODEL_BANDED = 'Banded';    
    public static String priceListId ;
    public static APTSECOM_Store__c store;
    
    public static List<Apttus_Proposal__Proposal__c>  proposalCreation(String opportunityId, Id ownerId, LCRM_Contact_SSD__c contactSSD, APTSECOM_Store__c store,String planName)
    {
        List<Source_System_Detail__c> ssdetails;
         
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible()) {
            ssdetails = [Select Id From Source_System_Detail__c where Account_Name__c =: contactSSD.LCRM_Account_SSD__r.Account_Name__c];    
        }
        
        list<Apttus_Proposal__Proposal__c> propList = new list<Apttus_Proposal__Proposal__c>();
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.Apttus_Proposal__Opportunity__c = opportunityId;
        proposal.Apttus_Proposal__Account__c = contactSSD.LCRM_Account_SSD__r.Account_Name__c;
        //proposal.Apttus_QPConfig__PriceListId__c = priceListId;
        proposal.Apttus_QPConfig__PriceListId__c = store.APTSECOM_Price_List__c;
        proposal.APTS_Order_Confirmation_Contact__c = contactSSD.LCRM_Contact__c;
        proposal.APTS_Order_Confirmation_Contact_Email__c = contactSSD.LCRM_Email__c;  
        proposal.Order_Confirmation_Contact_SSD__c = contactSSD.Id;           
        proposal.Apttus_Proposal__Proposal_Name__c = contactSSD.Name + '-' + store.Name + '-' + planName;
        
        proposal.APTS_SSD_Sold_To__c = contactSSD.LCRM_Account_SSD__c ;
        proposal.APTS_SSD_bill_to__c = contactSSD.LCRM_Account_SSD__c ;
        proposal.APTS_Payer__c = contactSSD.LCRM_Account_SSD__c ;
        proposal.Apttus_QPConfig__BillToAccountId__c = contactSSD.LCRM_Account_SSD__r.Account_Name__c;
        proposal.Apttus_QPConfig__ShipToAccountId__c = contactSSD.LCRM_Account_SSD__r.Account_Name__c;
        
        System.debug(LoggingLevel.ERROR, 'ssdetails Test > '+ssdetails); 
        proposal.APTS_SSD_ship_to__c = (ssdetails.size() > 1) ? ssdetails[1].Id : contactSSD.LCRM_Account_SSD__c ;
                     
        proposal.OwnerId = ownerId;                   
        proposal.CreatedById = ownerId; 
        proposal.APTS_Customer_Pricing_Segment__c = store.APTSECOM_Customer_Pricing_Segment__c;
        proposal.Customer_Group__c = contactSSD.LCRM_Account_SSD__r.LCRM_Customer_Group__c ; 
 
        proposal.Apttus_Proposal__Primary__c = TRUE;
        proposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
        proposal.Apttus_Proposal__ReadyToGenerate__c = TRUE;
        proposal.Digital_Quote_Automation__c = FALSE;
        proposal.Digital_Quote_Type__c = 'New Sales';
        proposal.Digital_Batch_Processed__c = FALSE;
        proposal.APTS_Ebilling_exempt__c = TRUE;
        proposal.DC_Contract_Not_In_Sync__c = true;
		proposal.Latam_APTS_Reason__c='Digital';
                
        //Splitting into multiple queries because custom metadata have some limitation when it comes to SOQL(Disjunctions not supported)        

        
        List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping = new List<Ecom_OrderService_Mappings__mdt>(); 
        
        if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible()) {
             lstOrderServiceMapping = [SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c,Ecom_Object__c,Ecom_Field_API__c,Ecom_Field_Value__c
                                                                        FROM Ecom_OrderService_Mappings__mdt 
                                                                        WHERE Ecom_Object__c = 'Apttus_Proposal__Proposal__c'  
                                                                        AND Ecom_StoreName__c = :store.Name];
        
            lstOrderServiceMapping.addAll([SELECT Id, DeveloperName, Customer_Pricing_Segment__c, Ecom_StoreName__c,Ecom_Object__c,Ecom_Field_API__c,Ecom_Field_Value__c 
                                                                        FROM Ecom_OrderService_Mappings__mdt 
                                                                        WHERE Ecom_Object__c = 'Apttus_Proposal__Proposal__c'  
                                                                        AND Ecom_StoreName__c = null]);
        }
        
        for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping)
        {
            proposal.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
        }       
       
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isCreateable()) 
        {
          insert proposal;    
            if(ssdetails.size() > 1)
            {
                updateProposal(proposal.Id, ssdetails[1].Id );
            }
        }
       
        System.debug('====check values in proposal after insertion==='+proposal);
        
        propList.add(proposal);
        return propList;
    }
    
    public static void updateProposal(String proposalId, String shiptoId){
        System.debug(LoggingLevel.ERROR, 'proposal shiptoId > '+shiptoId +'<>'+proposalId);
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.Id = proposalId;
        proposal.APTS_SSD_ship_to__c = shiptoId;
        
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()) 
        {
           update proposal;
        }
        System.debug(LoggingLevel.ERROR,'====check in future ==='+[select Id,name,APTS_SSD_bill_to__c,APTS_SSD_ship_to__c from Apttus_Proposal__Proposal__c where Id=: proposalId ]);
    }
        
   //Reprice cart- Ecom_orderService Call
    public static boolean reprice (Id cartId)
    {
        
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = cartId;
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
                 
        return result.IsPricePending;
    }
    
    //Update purchase order number on proposal - Ecom_orderService Call
    public static void updateProposalOnPlaceOrder(Ecom_OrderRequest.cls_references ref, Ecom_OrderRequest.cls_storeOrder storeOrder)
    {
        Apttus_Proposal__Proposal__c  updprop = new Apttus_Proposal__Proposal__c (); 
        if(storeOrder.purchaseOrderNum != null)
        {                  
            updprop.Id = ref.proposalId;
            updprop.Apttus_QPConfig__PONumber__c = storeOrder.purchaseOrderNum; 
        }
        
        if(storeOrder.additionalInfo.isBillToAccount != null && storeOrder.additionalInfo.isBillToAccount)
        {
            updprop.Id = ref.proposalId;
            updprop.APTS_Payment_Option__c = Label.Ecom_Proposal_Payment_Option;
        }
        
        if(storeOrder.isExistingCustomer == true)
        {
            storeOrder.additionalInfo.isEbillingChecked = true;
        }
        
        if(storeOrder.additionalInfo.isEbillingChecked == true && storeOrder.additionalInfo.isEbillingChecked != null)
        { 
            updprop.Id = ref.proposalId;
            updprop.APTS_Ebilling_exempt__c = FALSE; 
            
            if(storeOrder.isExistingCustomer == false)
            {
                updprop.APTS_Ebilling_contact__c = ref.contactId;
            }
            else
            {
                List<Contact> conRes;
                if(Schema.sObjectType.Contact.isAccessible()) {
                    conRes = [Select Id,SAP_Role__c,Account.id From Contact Where SAP_Role__c =: label.Ecom_EbillSapRole AND Account.id =: ref.accountId];
                }
                              
                if(conRes.isEmpty())
                {
                    updprop.APTS_Ebilling_contact__c = ref.contactId;               
                }
                else
                {
                    updprop.APTS_Ebilling_contact__c = conRes[0].Id;               
                }                          
            }
        }
        
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable() && updprop.Id != null) 
        {
            update updprop;
        }  
    }

  //Encryption Data required for AEM from sfdc,to naviagte to Payment Section on Check Out Page
    public static String encryption(Apttus_Proposal__Proposal__c proposal )
    {
       
        String urlData;
        Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');
       // system.debug('/.,.,'+cryptokey);
       // string detail = 'CustomerName='+proposal.APTS_Assent_Customer_Name__c+            '|'+'CustomerAccount='+proposal.APTS_Order_Confirmation_Contact_Name__c+'|'+'CustomerEmail='+proposal.APTS_Order_Confirmation_Contact_Email__c;
        String sapAccountNumber = String.isBlank(proposal.Apttus_Proposal__Account__r.SAPAccountNumber__c) ? '': proposal.Apttus_Proposal__Account__r.SAPAccountNumber__c;
        Decimal amount = proposal.APTS_Quote_Value__c == null ? 0 : proposal.APTS_Quote_Value__c.setScale(2);
        WebServiceSettings__c enterprisewsdl = AppUtil.getWebServiceSettings('EnterpriseWSDL');
        WebServiceSettings__c postback = AppUtil.getWebServiceSettings('PostbackLocation');
        String detail = 'QuoteNumber=' + proposal.Name + '|' + 'PaymentCurrency=USD' + 
                        '|' + 'AccountNumber=' + sapAccountNumber + // proposal.Apttus_Proposal__Account__r.SAPAccountNumber__c+
                        '|' + 'EmailAddress=' + proposal.APTS_Order_Confirmation_Contact_Email__c + 
                        '|' + 'PaymentAmount=' + amount + // proposal.APTS_Quote_Value__c.setScale(2) + 
                        '|' + 'CustomerName='+ proposal.APTS_Order_Confirmation_Contact_Name__c + //  + proposal.Apttus_Proposal__Account__r.Name + 
                        '|' + 'ContactName=' + proposal.APTS_Order_Confirmation_Contact_Name__c + 
                        '|' + 'TRPaymentCompanyId=CXDigital'+'|' + 'CustomerAddress=' + proposal.Apttus_Proposal__Account__r.billingstreet+ 
                        '|' + 'City=' + proposal.Apttus_Proposal__Account__r.billingcity + 
                        '|' + 'State=' + proposal.Apttus_Proposal__Account__r.billingstate+ 
                        '|' + 'Country=' + proposal.Apttus_Proposal__Account__r.billingcountry+ 
                        '|' + 'Telephone=' + proposal.Apttus_Proposal__Account__r.phone+ 
                        '|' + 'PostalCode=' + proposal.Apttus_Proposal__Account__r.billingPostalCode +  
                        '|BusinessUnitCode=CXDG'+'|Id='+proposal.Id+
                        '|TermsAndConditions='+proposal.APTS_Payment_Option__c+
                        '|' + 'EnterpriseWsdlLocation='+enterprisewsdl.Endpoint__c+
                        '|' + 'CCTokenPostBackWsdlLocation='+postback.Endpoint__c;
        
        System.debug('DETAIL:'+detail);
        Blob data = Blob.valueOf(detail);
        blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
        String b64Data = EncodingUtil.base64Encode(encryptedData);
        return b64Data;
    }

}