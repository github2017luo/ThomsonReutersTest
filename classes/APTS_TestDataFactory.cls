@isTest
public with sharing class APTS_TestDataFactory {
    public static Product2 createProduct(String productName, String pfamily){
        Product2 productSO        = new Product2();
        productSO.Name            = productName;
        productSO.Family          = pfamily;
        productSO.IsActive        = true;
        productSO.CurrencyIsoCode = 'USD';
        switch on pFamily{
               when 'CLEAR'{
                   productSO.APTS_Cat_L2__c =label.APTS_Clear_Product_Family;
               }
               when 'HighQ'{
                   productSO.APTS_Cat_L2__c =label.APTS_HighQ_Product_Family;
               }
               when 'PRINT LEGAL SOLUTIONS'{
                   productSO.APTS_Cat_L2__c =label.APTS_Print_Product_Family;
               }
               when 'PROVIEW LEGAL SOLUTIONS'{
                   productSO.APTS_Cat_L2__c =label.APTS_Proview_Product_Family;
               }
               when 'Rutter'{
                   productSO.APTS_Cat_L3__c =label.APTS_Rutter_Product_Family;
               }
               when 'Case Logistix'{
                   productSO.APTS_Cat_L3__c =label.APTS_Case_Logistix_Product_Family;
               }
               when 'Ediscovery'{
                   productSO.APTS_Cat_L3__c =label.APTS_Ediscovery_Product_Family;
               }
               
           }
        return productSO;
    
    }

    public static Product2 createProductForPricing(String productName, String pfamily, String highLevelCode, String lowLevelCode){
        Product2 productSO = createProduct(productName, pfamily);
        productSO.APTS_Media_High_Level_Code__c = highLevelCode;
        productSO.APTS_Media_Lower_Level_Code__c = lowLevelCode;
        return productSO;
    }
    //Added by tejasree
    public static  WebServiceSettings__c createWebServiceSetting(String webServiceName){
        WebServiceSettings__c oWebServiceSettings=new  WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Service Not Available'; 
        oWebServiceSettings.Name =webServiceName; 
        oWebServiceSettings.Timeout__c = 120;
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        return oWebServiceSettings;
    }
      
    public static  KeyValueListStore__c createCustomSetting(String name,String value){
    KeyValueListStore__c keyValueList = new KeyValueListStore__c(Name=name,TextValue__c=value);         
    return keyValueList;   
    }
    
     
    
    public static User createUser(String username,String lastname)
     {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        User usr = new User(LastName = lastname,
                           Username = username,
                           TimeZoneSidKey = 'GMT',
                           ProfileId = profileId.id,
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        return usr;
     }
     public static Account createAccount(String name) {
        Account a = new Account(Name = name,Is_GLI__c=true);
        return a;    
    }
    public static Contact createContact(String lastname,id accId) {
        Contact c = new Contact(lastName = lastname,accountId =accId);
        return c;    
    }

    public static Shipping_Method__c createShippingMethod(String name,String value){
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name=name,Value__c=value);
        return shippingMethod;
    }

  
    public static Opportunity createOpportunity(String name, Id accountId, String stageName, Date closeDate){
        Contact c= createContact('test lastname',accountId);
        Opportunity o = new Opportunity(Name = name, AccountId = accountId, stageName = stageName, CloseDate = closeDate,key_contact__c=c.Id);
        return o;
    }

    public static Apttus_Proposal__Proposal__c createProposal(Id oppId, Id ssdId){
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Opportunity__c = oppId, APTS_SSD_Sold_To__c = ssdId,recordtypeId=propRecorType);
        return p;
    }
    public static Source_system_detail__c createSourceSystem(Account acc){
        Source_system_detail__c source = new Source_system_detail__c (Account_Name__c = acc.id,Name=acc.name,Source_System_Name__c=acc.name,LCRM_Sales_Org__c='West');
        return source;
    }

    public static Apttus_Config2__ProductConfiguration__c createProductConfiguration(Id proposalId){
        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposalId);
        return prodConfig;
    }
    
    public static Apttus_Config2__Order__c createOrder(string status,Integer retrycount,Id ssdId){
        Apttus_Config2__Order__c order1=new Apttus_Config2__Order__c();
        order1.Apttus_Config2__Status__c=status;
        order1.Retry_Count__c=retrycount;
        order1.APTS_SSD_Sold_To__c=ssdId;
        return order1;
    }
    
    public static Apttus_Config2__OrderLineItem__c orderLineItem(Id orderId){
    Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
    ordline.Apttus_Config2__OrderId__c=orderId;
    return ordline;
    }
    
    public static Apttus_Config2__OrderProductAttributeValue__c orderProductAttributeValue(Id orderLineItemId ){   
    Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
    attribute.Apttus_Config2__LineItemId__c=orderLineItemId ;
    return attribute;
        }
        
        
    public static APTS_Dynamic_Bundle__c dynamicBundle(Id proposalId){
     APTS_Dynamic_Bundle__c dynamicbundle = new APTS_Dynamic_Bundle__c();
     dynamicbundle.APTS_Quote_Proposal__c=proposalId;
     return dynamicbundle;
     }
     
     public static Apttus_Approval__Approval_Request__c createApprovalRequest(Id proId){
      Apttus_Approval__Approval_Request__c ar = new Apttus_Approval__Approval_Request__c();                
      ar.Apttus_QPApprov__ProposalId__c = proId;
      return ar;
      }  
    
    public static Online_Contacts__c createOnlineContact(string pcode,Id propId,boolean flag,Id accId,string fName,string mName,string lName,string eAddress,string pos,boolean sfadmin,string juris){
        
         Online_Contacts__c onlinecontact = new Online_Contacts__c(Material__c = pcode,
         QuoteId__c =propId,  Is_Banded_Product__c = flag, Account__c = accId, First_Name__c = fName, Middle_Name__c = mName, Last_Name__c = lName,
         Email__c =eAddress, Position__c =pos,Sftwr_Admin__c = sfadmin, WLEc_Juris__c =juris);
       
        return onlinecontact;
        
    }
    
    public static Customer_Master_Contacts__c createMasterContact(Id propId,Id contID,string descr,string fName,string lName,string emailAddress){
    
    Customer_Master_Contacts__c mastercontact = new Customer_Master_Contacts__c(Quote__c =propId, Contact__c = contID,
     Customer_Type_Description__c = descr,First_Name__c =fName,Last_Name__c =lName, Email_Address__c =emailAddress);
    
        return mastercontact;
    
    }
    
    public static APTS_Additional_Subscription_Actions__c  createAdditionalSubscriberAction(String status,string subNo,Id propoId){
        APTS_Additional_Subscription_Actions__c addsub = new APTS_Additional_Subscription_Actions__c();
           addsub.APTS_Line_Status__c=status;
           addsub.APTS_Subscription_Number__c=subNo;
           addsub.APTS_Quote_Proposal__c=propoId;
           return addsub;
    
    }
    
    public static APTS_Quote_Agreement_Locations__c createAgreementLocation(string agrNo,Id propoId,string status){
      APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
      multiacc.APTS_Agreement_Number__c=agrNo;  
      multiacc.APTS_Quote_Proposal__c=propoId;
      multiacc.APTS_Status__c=status;
      return multiacc;
    
    }
    
  //added by surya
    public static Apttus_Config2__ProductConfiguration__c createCart(Id accountId, Id proposalId, Id priceListId) {
        Apttus_Config2__ProductConfiguration__c cartSO = new Apttus_Config2__ProductConfiguration__c();
        cartSO.Name = 'Product Confiuguration - 1';
        cartSO.Apttus_Config2__VersionNumber__c = 1;
        cartSO.Apttus_Config2__BusinessObjectId__c = proposalId;
        cartSO.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        cartSO.Apttus_QPConfig__Proposald__c = proposalId;
        cartSO.Apttus_Config2__Status__c = 'New';
        //Changed new ssd lookup fields instead of account lookup
        //cartSO.APTS_SSD_bill_to__c= ssdid;
        cartSO.Apttus_Config2__BillToAccountId__c = accountId;
        //cartSO.APTS_SSD_Ship_To__c= ssdid;
        cartSO.Apttus_Config2__ShipToAccountId__c= accountId;
        cartSO.Apttus_Config2__AccountId__c = accountId;
        cartSO.Apttus_Config2__PriceListId__c = priceListId;
        cartSO.Apttus_Config2__IsTransient__c = true;
        
        return cartSO;
    }   
    
    public static Apttus_Config2__PriceList__c createPriceList(String name){
        if(name == null){
            name = 'Thomson Reuters Master - US Legal';}
        return new Apttus_Config2__PriceList__c(Name = name);
    }
     public static Apttus_Config2__PriceList__c createPriceList1(String name){
        if(name == null){
            name = 'Thomson Reuters Master - Canada';}
        return new Apttus_Config2__PriceList__c(Name = name);
    }

    // Added by Chintan
    public static Apttus_Config2__PriceListItem__c createPriceLI(Apttus_Config2__PriceList__c pl,Product2 oProduct1,Integer price)
    {
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=oProduct1.id;
        pli.Apttus_Config2__ListPrice__c=price;
        
        return pli;
    }

    public static User createFindLawUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name= 'TR Legal FindLaw User'];
        User u = new User(Alias = 'standt', Email='findLaw@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='APTS_findLawUser@testorg.com');
        return u;
    }
    
   //added by tejasree
       public static Apttus_Config2__LineItem__c createApttusConfig2LineItem(Id prodConfid,Id prodid){
       Apttus_Config2__LineItem__c li2 = new Apttus_Config2__LineItem__c();
        li2.Apttus_Config2__ConfigurationId__c=prodConfid;
        li2.Apttus_Config2__ProductId__c=prodid;
        li2.Apttus_Config2__AddedBy__c = 'User';
        li2.Apttus_Config2__AdjustedPrice__c = 50;
        li2.Apttus_Config2__AdjustmentAmount__c = 50;
        li2.Apttus_Config2__AdjustmentType__c = '% Discount';
        li2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li2.Apttus_Config2__AllowProration__c = FALSE;
        li2.Apttus_Config2__AllowRemoval__c = TRUE;
        li2.Apttus_Config2__AutoRenew__c = FALSE;
        li2.Apttus_Config2__BaseExtendedCost__c = 0;
        li2.Apttus_Config2__BaseExtendedPrice__c = 100;
        li2.Apttus_Config2__BasePrice__c = 100;
        li2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li2.Apttus_Config2__ConfigStatus__c = 'Complete';
        li2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li2.Apttus_Config2__Customizable__c = FALSE;
        li2.Apttus_Config2__DeltaPrice__c = 50;
        li2.Apttus_Config2__DeltaQuantity__c = 1;
        li2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li2.Apttus_Config2__ExtendedCost__c = 0;
        li2.Apttus_Config2__ExtendedPrice__c = 100;
        li2.Apttus_Config2__Frequency__c = 'Monthly';
        li2.Apttus_Config2__Guidance__c = 'Red';
        li2.Apttus_Config2__HasAttributes__c = FALSE;
        li2.Apttus_Config2__HasBaseProduct__c = FALSE;
        li2.Apttus_Config2__HasDefaults__c = FALSE;
        li2.Apttus_Config2__HasIncentives__c = FALSE;
        li2.Apttus_Config2__HasOptions__c = FALSE;
        li2.Apttus_Config2__HasTieredPrice__c = FALSE;
        li2.Apttus_Config2__HideCopyAction__c = FALSE;
        li2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li2.Apttus_Config2__IsAssetPricing__c = FALSE;
        li2.Apttus_Config2__IsCustomPricing__c = FALSE;
        li2.Apttus_Config2__IsHidden__c = FALSE;
        li2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li2.Apttus_Config2__IsReadOnly__c = FALSE;
        li2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li2.Apttus_Config2__ItemSequence__c = 1;
        li2.Apttus_Config2__LineNumber__c = 1;
        li2.Apttus_Config2__LineSequence__c = 1;
        li2.Apttus_Config2__LineStatus__c = 'New';
        li2.Apttus_Config2__LineType__c = 'Product/Service';
        li2.Apttus_Config2__ListPrice__c = 100;
        li2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li2.Apttus_Config2__NetPrice__c = 50;
        li2.Apttus_Config2__NetUnitPrice__c = 50;
        li2.Apttus_Config2__OptionSequence__c = 0;
        li2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li2.Apttus_Config2__PriceType__c = 'Recurring';
        li2.Apttus_Config2__PriceUom__c = 'Each';
        li2.Apttus_Config2__PricingStatus__c = 'Complete';
        li2.Apttus_Config2__PrimaryLineNumber__c = 1;
        li2.Apttus_Config2__ProductVersion__c = 1;
        li2.Apttus_Config2__Quantity__c = 1;
        li2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li2.Apttus_Config2__SellingTerm__c = 1;
        li2.Apttus_Config2__SyncStatus__c = 'Pending';
        li2.Apttus_Config2__Taxable__c = FALSE;
        li2.Apttus_Config2__TaxInclusive__c = FALSE;
        li2.Apttus_Config2__Term__c = 1;
        li2.Apttus_Config2__TotalQuantity__c = 1;
        li2.Apttus_Config2__Uom__c = 'Each';
        li2.Apttus_CQApprov__Approval_Status__c = 'Pending Approval';
        li2.CurrencyIsoCode = 'USD';
        li2.APTS_Product_Family__c = 'WESTLAW';
        li2.APTS_Contract_Term__c = '2 Years';
        li2.APTS_Years_2_Plus_Adjustment__c = '4';
        return li2;
         }
         
         //added by tejasree 
         public static  APTS_Group__c createGroup(Id prodConfig){
          APTS_Group__c ag = new APTS_Group__c( APTS_ProductConfiguration__c =prodConfig, APTS_Primary_Material__c = 'West Complete Library Sub', Group_Approval_Required__c= True);
          
          return ag;
        }
       //added by surya for GLI-OC test class redesign APTS_ProposalLineItemTriggerTest 
        public static Apttus_Proposal__Proposal_Line_Item__c proposallineitem(Id prodConfig,Id proposal){
        
         //List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c();         
          pl1.Apttus_Proposal__Quantity__c=1;
          pl1.Apttus_QPConfig__ConfigurationId__c = prodConfig;
          pl1.Apttus_QPConfig__LineType__c = 'Product/Service';
          pl1.Apttus_QPConfig__LineNumber__c = 1;
          pl1.Apttus_QPConfig__ItemSequence__c = 1;
          pl1.Apttus_QPConfig__NetPrice__c=1;
          pl1.Apttus_Proposal__Proposal__c=proposal;
          return pl1;
       
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c();         
          pl2.Apttus_Proposal__Quantity__c=1;
          pl2.Apttus_QPConfig__Quantity2__c = 2;
          pl2.Apttus_QPConfig__ConfigurationId__c = prodConfig;
          pl2.Apttus_QPConfig__LineType__c = 'Product/Service';
          pl2.Apttus_QPConfig__LineNumber__c = 1; 
          pl2.Apttus_QPConfig__ItemSequence__c = 1;
          pl2.Apttus_QPConfig__NetPrice__c=1;
          pl2.Apttus_QPConfig__LineStatus__c ='Amended';
          pl2.APTS_Media_High_Level_Code__c = '21';         
          pl2.Apttus_Proposal__Proposal__c=proposal;
          return pl2;
        
        
        }
        //added by surya for GLI-OC test class redesign APTS_PricingCallbackMethodsTest
        public static Apttus_Config2__ProductOptionGroup__c  productoption(Id prodObj,Id classHierarchy)
       {
         Apttus_Config2__ProductOptionGroup__c optGroupSO = new Apttus_Config2__ProductOptionGroup__c();
         optGroupSO.Apttus_Config2__RootOptionGroupId__c = classHierarchy;
         optGroupSO.Apttus_Config2__OptionGroupId__c = classHierarchy;
         optGroupSO.Apttus_Config2__ProductId__c = prodObj;
         optGroupSO.Apttus_Config2__Sequence__c = 1;
         optGroupSO.Apttus_Config2__MaxOptions__c = 1.0;
         optGroupSO.Apttus_Config2__MinOptions__c = 0.0;
         optGroupSO.Apttus_Config2__IsLeaf__c = true;
         optGroupSO.Apttus_Config2__Left__c = 1.0;
         optGroupSO.Apttus_Config2__Right__c = 2.0;
         optGroupSO.Apttus_Config2__ModifiableType__c = 'Variable';
         optGroupSO.Apttus_Config2__RootSequence__c = 7.0;
         
         return optGroupSO;
       
       }
          public static APTS_Attribute_Settings__c attributesetting (Id prodObj)
       {
         APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
         attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj;
          return attributesetting;
       
       }
       
       public static APTS_Attribute_Value__c attributevalue1(Id prodObj)
       {
         APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=prodObj;
          return attributevalue1;
       
       }
       public static APTS_Attribute_Value__c attributevalue2(Id prodObj)
       {
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=prodObj;
          return attributevalue2;
       
       }
       public static APTS_Attribute_Value__c attributevalue3(Id prodObj)
       {
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=prodObj;
          return attributevalue3;
       
       }
       public static APTS_Attribute_Value__c attributevalue4(Id prodObj)
       {
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=prodObj;
          return attributevalue4;
       
       }
          
          public static APTS_Attribute_Value_Combination__c attributecombination(Id prodObj, Id attributevalue1,Id attributevalue2, Id attributevalue3, Id attributevalue4)
         {
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=prodObj;
          return attributecombination;
           }  
        
       
      //added by surya for GLI-OC test class redesign APTS_PricingCallbackMethodsTest 
         public static List<Apttus_Config2__LineItem__c> createApttusConfig2LineItem1(Id prodConfig,Id prodObj,Id summaryGroup1,Id pliSO,Id summaryGroup2,Id pliSO2,Id pliSO3,Id prod2Obj){
        
         List<Apttus_Config2__LineItem__c> ListOfLineItems = New List<Apttus_Config2__LineItem__c>();
         
         Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c();
          linObj.Apttus_Config2__Quantity__c=1;
          linObj.Apttus_Config2__ProductId__c=prodObj;
          linObj.Apttus_Config2__ConfigurationId__c = prodConfig;
          linObj.Apttus_Config2__LineType__c = 'Product/Service';
          linObj.Apttus_Config2__LineNumber__c = 1;
          linObj.Apttus_Config2__ItemSequence__c = 1;
          linObj.Apttus_Config2__SummaryGroupId__c = summaryGroup1;
          linObj.Apttus_Config2__NetPrice__c=10.0;
          linObj.Apttus_Config2__BasePrice__c=10.0;
          linObj.Apttus_Config2__BaseExtendedPrice__c = 10.0;
          linObj.Apttus_Config2__AdjustedPrice__c = 10.0;
          linObj.Apttus_Config2__ExtendedPrice__c = 15.0;
          linObj.Apttus_Config2__OptionPrice__c = 15.0;
          linObj.Apttus_Config2__Frequency__c = 'Monthly';
          linObj.Apttus_Config2__PriceType__c = 'Recurring';
          linObj.Apttus_Config2__PriceAdjustment__c=0;
          linObj.APTS_Contract_Term__c =null;
          linObj.Apttus_Config2__PriceListItemId__c = pliSO; 
      ListOfLineItems.add(linObj);
      
      Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c();
            linObj2.Apttus_Config2__Quantity__c=1;
            linObj2.Apttus_Config2__ProductId__c=prodObj;
            linObj2.Apttus_Config2__ConfigurationId__c = prodConfig;
            linObj2.Apttus_Config2__LineType__c = 'Product/Service';
            linObj2.Apttus_Config2__LineNumber__c = 2;
            linObj2.Apttus_Config2__ItemSequence__c = 2;
            linObj2.Apttus_Config2__SummaryGroupId__c = summaryGroup2;
            linObj2.Apttus_Config2__NetPrice__c=10.0;
            linObj2.Apttus_Config2__BasePrice__c=10.0;
            linObj2.Apttus_Config2__BaseExtendedPrice__c = 10.0;
            linObj2.Apttus_Config2__AdjustedPrice__c = 10.0;
            linObj2.Apttus_Config2__ExtendedPrice__c = 3.0;
            linObj2.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj2.Apttus_Config2__OptionPrice__c = 15.0;
            linObj2.Apttus_Config2__Frequency__c = 'Monthly';
            linObj2.Apttus_Config2__PriceType__c = 'One Time'; 
            linObj2.Apttus_Config2__PriceAdjustment__c=0;
            linObj2.APTS_Contract_Term__c ='3 Years';
            linObj2.Apttus_Config2__PriceListItemId__c = pliSO2; 
        ListOfLineItems.add(linObj2);
        
        Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c();
            linObj3.Apttus_Config2__Quantity__c=1;
            linObj3.Apttus_Config2__ProductId__c=prod2Obj;
            linObj3.Apttus_Config2__ConfigurationId__c = prodConfig;
            linObj3.Apttus_Config2__LineType__c = 'Option';
            linObj3.Apttus_Config2__LineNumber__c = 2;
            linObj3.Apttus_Config2__ItemSequence__c = 2;
            linObj3.Apttus_Config2__NetPrice__c=10.0;
            linObj3.Apttus_Config2__BasePrice__c=10.0;
            linObj3.Apttus_Config2__BaseExtendedPrice__c = 10.0;
            linObj3.Apttus_Config2__AdjustedPrice__c = 10.0;
            linObj3.Apttus_Config2__ExtendedPrice__c = 10.0;
            linObj3.Apttus_Config2__OptionPrice__c = 15.0;
            linObj3.Apttus_Config2__Frequency__c = 'Monthly';
            linObj3.Apttus_Config2__PriceType__c = 'Recurring'; 
            linObj3.Apttus_Config2__PriceAdjustment__c=0;
            linObj3.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj3.APTS_Contract_Term__c ='Existing';
            linObj3.Apttus_Config2__PriceListItemId__c = pliSO3; 
        ListOfLineItems.add(linObj3);
        
        Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c();
            linObj4.Apttus_Config2__Quantity__c=1;
            linObj4.Apttus_Config2__ProductId__c=prod2Obj;
            linObj4.Apttus_Config2__ConfigurationId__c = prodConfig;
            linObj4.Apttus_Config2__LineType__c = 'Option';
            linObj4.Apttus_Config2__LineNumber__c = 2;
            linObj4.Apttus_Config2__ItemSequence__c = 2;
            linObj4.Apttus_Config2__NetPrice__c=10.0;
            linObj4.Apttus_Config2__BasePrice__c=10.0;
            linObj4.Apttus_Config2__BaseExtendedPrice__c = 10.0;
            linObj4.Apttus_Config2__AdjustedPrice__c = 10.0;
            linObj4.Apttus_Config2__ExtendedPrice__c = 10.0;
            linObj4.Apttus_Config2__OptionPrice__c = 15.0;
            linObj4.Apttus_Config2__Frequency__c = 'Monthly';
            linObj4.Apttus_Config2__PriceType__c = 'Recurring';
            linObj4.Apttus_Config2__PriceAdjustment__c=0;
            linObj4.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj4.APTS_Contract_Term__c =null;
            linObj4.Apttus_Config2__PriceListItemId__c = pliSO3;
        ListOfLineItems.add(linObj4);

        Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c();
            linObj5.Apttus_Config2__Quantity__c=1;
            linObj5.Apttus_Config2__ProductId__c=prod2Obj;
            linObj5.Apttus_Config2__ConfigurationId__c = prodConfig;
            linObj5.Apttus_Config2__LineType__c = 'Option';
            linObj5.Apttus_Config2__LineNumber__c = 1;
            linObj5.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj5.Apttus_Config2__ItemSequence__c = 3;
            linObj5.Apttus_Config2__NetPrice__c=10.0;
            linObj5.Apttus_Config2__BasePrice__c=10.0;
            linObj5.Apttus_Config2__BaseExtendedPrice__c = 10.0;
            linObj5.Apttus_Config2__AdjustedPrice__c = 10.0;
            linObj5.Apttus_Config2__ExtendedPrice__c = 10.0;
            linObj5.Apttus_Config2__OptionPrice__c = 15.0;
            linObj5.Apttus_Config2__Frequency__c = 'Monthly';
            linObj5.Apttus_Config2__PriceType__c = 'Recurring';
            linObj5.Apttus_Config2__PriceAdjustment__c=0;
            linObj5.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj5.APTS_Contract_Term__c =null;
            linObj5.Apttus_Config2__PriceListItemId__c = pliSO3; 
            ListOfLineItems.add(linObj5);
            
            Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c();
            linObj6.Apttus_Config2__Quantity__c=1;
            linObj6.Apttus_Config2__ProductId__c=prod2Obj;
            linObj6.Apttus_Config2__ConfigurationId__c = prodConfig;
            linObj6.Apttus_Config2__LineType__c = 'Option';
            linObj6.Apttus_Config2__LineNumber__c = 1;
            linObj6.Apttus_Config2__PrimaryLineNumber__c = 1;
            linObj6.Apttus_Config2__ItemSequence__c = 3;
            linObj6.Apttus_Config2__NetPrice__c=10.0;
            linObj6.Apttus_Config2__BasePrice__c=10.0;
            linObj6.Apttus_Config2__BaseExtendedPrice__c = 10.0;
            linObj6.Apttus_Config2__AdjustedPrice__c = 10.0;
            linObj6.Apttus_Config2__ExtendedPrice__c = 10.0;
            linObj6.Apttus_Config2__OptionPrice__c = 15.0;
            linObj6.Apttus_Config2__Frequency__c = 'Monthly';
            linObj6.Apttus_Config2__PriceType__c = 'Recurring';
            linObj6.Apttus_Config2__PriceAdjustment__c=0;
            linObj6.APTS_Price_Cap_Adjustment_Percentage__c = 1;
            linObj6.APTS_Contract_Term__c =null;
            linObj6.APTS_Product_Family__c = 'PPC MANAGEMENT';            
            //linObj6.APTS_PAGEO_Price__c=attributecombination.APTS_Price__c;
            linObj6.Apttus_Config2__PriceListItemId__c = pliSO3; 
            ListOfLineItems.add(linObj6);
      
      return ListOfLineItems;
         }
         
         public static void createFLTrephCodes(){
             List<APTS_TREPH_FINDLAW_CODES__c > flcodes=new  List<APTS_TREPH_FINDLAW_CODES__c >{
             new APTS_TREPH_FINDLAW_CODES__c (Name='ENGAGEMENT SOLUTIONS',Value__c='L5_L1616_FP,L5_L0171_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='PPC MANAGEMENT',Value__c='L5_L0220_FP,L5_L0222_FP,L5_L0221_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FL DIRECTORY',Value__c='L5_L0195_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='WEBSITES',Value__c='L5_L0190_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FL NATIONAL AD PACKAGES',Value__c='40656701'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='LI TOPSPOT',Value__c='42027610'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='SL TOPSPOT',Value__c='41618485'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='AB TOPSPOT',Value__c='42027608'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='LI SPOTLIGHT',Value__c='42027609'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FL SPOTLIGHT',Value__c='37005004,40987608,41680342'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='SL SPOTLIGHT',Value__c='41937760,42686641'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='AB SPOTLIGHT',Value__c='42027607'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='BLOGS',Value__c='41819162,41874867,40987609,41093074,41093075,41093076,41093077,41174028,41246653,41336829,41413187,41378928'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='DMA',Value__c='41986777,41767150'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FL PROFILES',Value__c='30406004,30406013,40043930,40043952,40147661,40312936,41053156,41053157,41056103,41098702'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FL FOCUS PAGES',Value__c='41003359,41003360,41003551,41056102'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='VENDOR DIGITAL ADS',Value__c='41976905,37005001,37005024, 41112808, 41131054'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='ASK SL ONLINE',Value__c='42157433,41484905'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='Answering Services',Value__c='L5_L0195_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='CONNECT SOLUTIONS',Value__c='41751072,41751074,41230687,41230689,41267324,41267325,41267326,41267327,41410059'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='LANDING PAGES',Value__c='41689178,41876119,41877783,41343506,41343507'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FINDLAW LANDING PAGE HOSTIN',Value__c='42594853'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='VISIBILITY',Value__c='L5_L0220_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='CONVERSION SOLUTIONS',Value__c='L5_L0220_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='INTEGRATED MARKETING SOLUTIONS',Value__c='L5_L0220_FP'),
             new APTS_TREPH_FINDLAW_CODES__c (Name='FL TOPSPOT',Value__c='42088301,37005005,37005072,40987607'),    
             new APTS_TREPH_FINDLAW_CODES__c (Name='RETURNS RESERVE L4',Value__c='L5_L0220_FP'),         
             new APTS_TREPH_FINDLAW_CODES__c (Name='AB PROFILES',Value__c='30790796,42762345')};
             
             insert flcodes;
         }
         
}