/**
* JSON Class to send Order Details
*
* @author  TCS
* @version 2018-09-14
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description
* 2018-09-14   Chintan Jadwani                  Created 
* =============================================================================
* As part LOC-6066 :: Create class containing JSON Fields
*/
global class CorpCreateOrderRequest {
    
    // public OrderRequest createOrderRequest {get; set;}
    
    public ESIHeader esiHeader;
    public orderHeader orderHeader;
    public List<orderLines> orderLines;
    public List<Material> lstOfMaterial;
    public List<orderLapseLines> orderLapseLines;
    
    public CorpCreateOrderRequest(){
        // createOrderRequest = new OrderRequest();
        orderHeader= new orderHeader();
        esiHeader= new ESIHeader();
        orderLines= new List<orderLines>();
        lstOfMaterial = new List<Material>();
        orderLapseLines= new List<orderLapseLines>();
    }
    
    /*global class OrderRequest {
        public ESIHeader esiHeader;
        public orderHeader orderHeader;
        public List<orderLapseLines> orderLapseLines;
        public List<orderLines> orderLines;

        public OrderRequest(){
            orderHeader= new orderHeader();
            orderLapseLines= new List<orderLapseLines>();
            esiHeader = new ESIHeader();
            orderLines = new List<orderLines>();
        }
    }*/
    
    global Class esiHeader {
        public String applicationId;
        public String messageId;
        public String transactionId;
        // public String messageHistory;
        // public String tracingId;
        public String timeStamp;
        public String instanceId;
        public String companyId;
        public String configGroup;
        public String postBackURL;        
        public String payloadVersion;
        //public List<extensibleAttributes> extensibleAttributes;
        
        public esiHeader(){
            applicationId = 'SF07';
            messageId = '';
            transactionId= '';
            // tracingId= '';
            // messageHistory= '';
            timeStamp = '';
            instanceId = '';
            companyId = '';
            configGroup = '';
            postBackURL = '';
            payloadVersion= '';
            //extensibleAttributes= new List<extensibleAttributes>();
        }
    }
    
    /*global class extensibleAttributes{
        public String systemIdentifier;
        public String key;
        public String value;
        
        public extensibleAttributes(){
            systemIdentifier = '';
            key= '';
            value= '';                   
        }
        
    }*/
    
    global Class OrderHeader {
        
        public String OrderNumber;
        public String actionCode; 
        public String sourceOrTargetReferenceNumber;
        public DateTime orderTimestamp;
        public String orderType;
        public boolean creditApproval;  //DOC-2388
        public String orderAutomationMode;
        public String purchaseOrderNumber;
        public String orderCurrency;
        public String esignDate;
        public Decimal orderPeriodicValue;
        public String oneTimeValue;
        public String salesOffice;
        public String paymentMethod;
        public String confirmUrl;
        public String productStatus;
        public Decimal noOfAttorneys;
        public String orderReason;
        public String orderDescription;
        public String orderedBy;
        public String orderSource;
        public String customerMarketSegment;
        public String revenueChannel;
        public String shippingMode;
        public String workFlowMode;
        public String costCenter;
        public String completeDelivery;
        public String internationCodificationTerms;
        public List<Account> Account;
        Public accountPayment accountPayment;
        //public List<extensibleAttributes> extensibleAttributes;
        public boolean eBillExempt;
        public String holdForReview;
        public String renewalValue;
        public String profileId;        
        public String applyDate;
        public String billingStopDate;        
        public String WLDID;                          
        public String ObjectType;
        public String isFeedsRequest;  
        public String workItemLabel;
        public List<OrderAddress> orderAddress;
        public List<OrderDeal> orderDeal;
        //public List<ShippingDetails> shippingDetails;
        Public OrderRepresentative orderRepresentative;
        public creditCardPayment creditCardPayment;
        public QuoteDetails quoteDetails;
        public List<OrderContact> orderContact;
        Public List<onlineContacts> onlineContacts;
        Public List<attachments> attachments;
        Public List<orderNotes> orderNotes;
        
        public OrderHeader(){
            OrderNumber = '';
            actionCode = '';
            sourceOrTargetReferenceNumber = '';
            orderTimestamp = DateTime.now();
            orderType = '';
            orderAutomationMode = '';
            purchaseOrderNumber = '';
            orderCurrency = '';
            creditApproval=false;
            esignDate = '';
            orderPeriodicValue = 0.0;
            oneTimeValue = '';
            salesOffice = '';
            paymentMethod = '';
            confirmUrl = '';
            productStatus = '';
            noOfAttorneys = 0;
            orderReason = '';
            orderDescription = '';
            orderedBy = '';
            orderSource = '';
            customerMarketSegment = '';
            revenueChannel = '';
            shippingMode = '';
            workFlowMode = '';
            costCenter = '';
            completeDelivery = '';
            internationCodificationTerms = '';
            orderAddress = new List<OrderAddress>();
            orderDeal = new List<OrderDeal>();
            Account = new List<Account>();
            oneTimeValue = '';
            salesOffice = '';
            paymentMethod = '';
            holdForReview = '';
            renewalValue = '';
            profileId = '';
            confirmUrl = '';
            applyDate = '';
            billingStopDate = '';
            productStatus = '';
             eBillExempt =false;
            //extensibleAttributes = new List<extensibleAttributes>();
            WLDID = '';
            ObjectType = '';
            isFeedsRequest = '';
            workItemLabel = '';
            orderNotes = new List<orderNotes> ();
            //shippingDetails = new List<ShippingDetails>();
            orderRepresentative = new OrderRepresentative();
            creditCardPayment = new CreditCardPayment();
            quoteDetails = new QuoteDetails();
            orderContact = new List<OrderContact>();
            accountPayment = new accountPayment();
            onlineContacts = new List<onlineContacts>();
            attachments  = new List<attachments> ();
        }
    }
    
   /* public Class ShippingDetails{
        public String firstName;
        public String lastName;
        public String middleName;
        public String name;
        public String phone;
        public String extension;
        public String fax;
        public String emailAddress;
        public String title;
        public String street1;
        public String street2;
        public String street3;
        public String street4;
        public String city;
        public String district;
        public String region;
        public String county;
        public String postalcode;
        public String country;
        public String poBox;
        public String alternateEmailAddress;
        public String building;
        public String floor;
        public String room;
        public String shippingAmount ;
        public String shippingMethod;
        public String shipCarrier;
        public String vatNumber;
        public String taxReferenceNumber;
        public String addressChange;
        public String doBusinessAs;
        public String organizationType;
        public String attentionDepartment;
        public String extAccountNumber;
        public String partnerType;
        public List<extensibleAttributes> extensibleAttributes;
        List<Account> Account;
    
        public ShippingDetails(){
            firstName  = '';
            lastName  = '';
            middleName  = '';
            name  = '';
            phone  = '';
            extension  = '';
            fax  = '';
            emailAddress  = '';
            title  = '';
            street1  = '';
            street2  = '';
            street3  = '';
            street4  = '';
            city  = '';
            district  = '';
            region  = '';
            county  = '';
            postalcode  = '';
            country  = '';
            poBox  = '';
            alternateEmailAddress  = '';
            building  = '';
            floor  = '';
            room  = '';
            shippingAmount = '';
            shippingMethod  = '';
            shipCarrier  = '';
            vatNumber  = '';
            taxReferenceNumber  = '';
            addressChange  = '';
            doBusinessAs  = '';
            organizationType  = '';
            attentionDepartment  = '';
            extAccountNumber  = '';
            partnerType  = '';
            extensibleAttributes = new List<extensibleAttributes>();
            Account= new List<Account>();
        }
    }
    */
    /*public Class OrderLineDealDetails {
        
        public String orderLineNumber;
        public String existingSub;
        public String existingSubLine;
        public String recordType;
        public String discount;
        public Integer quantity;
        public List<extensibleAttributes> extensibleAttributes;
        
        public OrderLineDealDetails(){
            orderLineNumber = '';
            existingSub = '';
            existingSubLine = '';
            recordType = '';
            discount = '';
            quantity = 0;
            extensibleAttributes= new List<extensibleAttributes>();
        }
    }*/
    
    public Class Account{  
        
        public String accountNumber;
        public String companyId;
        public String accountType;
        public String accountStatus;
        
        public String accountName;
        public String companyName;
        public String parentAccountNumber;
        public String accountDirectorID;
        public String accountDirectorName;
        public String ownerId;
        public String ownerName;
        public String locationCountry;
        public String industryCode;
        public String isPrimary;
        public String isActive;
        public String action;
        public String companySize;
        public String digitalFirm;
        public String sourceOrTargetReferenceNumber; 
        public String TerritoryNumber;
        public List<Address> Address;
        //public List<extensibleAttributes> extensibleAttributes;
        //public List<sourceOrTargetReference> sourceOrTargetReference;
        public String partnerType;
        public String vatCode;
        public String hierarchyType;
        public String KNOwned;
        public String accountGroup;
        public String accountClass;
        public String primaryBillingNumber;
        public String legacyThomsonCustomerId;
        public String customerJourney;
        public String website;
        public String applyDate;
        public String segment;
        public String merchantCategoryClassificationCode;
        public String relationshipModel;
        public String accountCustomerAddressID;
        public String externalAccountId;
        public String division;
        public String companyCode;
        public String distributionChannel;
        public String salesOrg;
        public String altKN;
        public String legalStatus;
        public String language;    
        //public List<complianceJobRole> complianceJobRole;
        public String jurisdictionCode;
        public String taxCodeType;
        public String lastUpdatedDate;
        public String licenseId;
        public String isUnderMaintenance;        
             
        
        public Account(){
            accountNumber = '';
            companyId = '';
            accountType = '';
            accountStatus = '';
            
            accountName= '';
            companyName= '';
            parentAccountNumber= '';
            accountDirectorName= '';
            accountDirectorID= '';
            ownerId= '';
            ownerName= '';
            locationCountry= '';
            industryCode= '';
            isPrimary='true';
            isActive='false';
            action= '';
            companySize= '';
            digitalFirm= '';
            sourceOrTargetReferenceNumber= '';
            TerritoryNumber= '';
            Address = new List<Address>();
            //extensibleAttributes= new List<extensibleAttributes>();
            partnerType= '';
            vatCode= '';
            hierarchyType= '';
            KNOwned= '';
            accountGroup= '';
            accountClass= '';
            primaryBillingNumber= '';
            legacyThomsonCustomerId= '';
            customerJourney= '';
            website= '';
            applyDate= '';
            segment= '';
            merchantCategoryClassificationCode= '';
            relationshipModel= '';
            accountCustomerAddressID= '';
            externalAccountId= '';
            division= '';
            companyCode= '';
            distributionChannel= '';
            salesOrg= '';
            altKN= '';
            legalStatus= '';
            language= '';
            //complianceJobRole= new List<complianceJobRole>();
            //sourceOrTargetReference =new List<sourceOrTargetReference>();
            jurisdictionCode= '';
            taxCodeType= '';
            lastUpdatedDate= '';
            licenseId= '';
            isUnderMaintenance= '';
        }
    }
    
   /* public class complianceJobRole{
        public String Id;
        public String description;
        
        public complianceJobRole(){
             Id= '';
             description= '';
        }
    }*/
    
    /*public class sourceOrTargetReference{
        public String sourceOrTargetSystemName ;
        public String referenceID;
        public String serviceName;
        public String serviceOperationName;
        public List<extensibleAttributes> extensibleAttributes;
        
        public sourceOrTargetReference(){
            sourceOrTargetSystemName= '';
            referenceID= '';
            serviceName= '';
            serviceOperationName= '';
            extensibleAttributes= new List<extensibleAttributes>();
        }
    }*/
    
    public Class Address{
       public String firstName;
        public String lastName;
        public String middleName;
        public String name;
        public String phone;
        public String emailAddress;
        public String extension;
        public String fax;
        //public List<extensibleAttributes> extensibleAttributes;
        public String title; 
        public String street1;        
        public String street2;
        public String street3;
        public String street4;
        public String city;
        public String region;
        public String district;
        public String county;
        public String postalcode;
        public String country;
        public String poBox; 
        public String alternateEmailAddress;
        public String building;
        public String floor; 
        public String room;         
        public String shippingAmount;
        public String shippingMethod;
        public String shipCarrier; 
        public String vatNumber;
        public String taxReferenceNumber;
        public String addressChange;
        public String doBusinessAs;
        public String organizationType;
        public String attentionDepartment;
        public String extAccountNumber;
        public String partnerType;
        public String externalContactId;
        
        public Address(){
            firstName = '';
            lastName = '';
            middleName = '';
            name= '';
            title= '';
            floor= '';
            room= '';
            building= '';
            alternateEmailAddress= '';
            poBox= '';
            shipCarrier= '';
            phone = '';
            emailAddress = '';
            extension= '';
            fax= '';
            //extensibleAttributes = new List<extensibleAttributes>();
            street1 = '';
            street2 = '';
            street3= '';
            street4 = '';
            city = '';
            district= '';
            region = '';
            county = '';
            postalcode = '';
            country = '';
            shippingAmount = '';
            shippingMethod = '';
            vatNumber = '';
            taxReferenceNumber = '';
            addressChange = '';
            doBusinessAs = '';
            organizationType = '';
            attentionDepartment = '';
            extAccountNumber = '';
            partnerType = '';
            externalContactId='';
        }
    }
    
    public Class LineNumberLink{
        
        public Integer lineNumber;
        public List<JobRole> jobRole;
        public String externalId;
        public String sendEmail;
        public String selectiveAccess;
        public String contactState;
        //public List<extensibleAttributes> extensibleAttributes;
        
        public LineNumberLink(){
            lineNumber = lineNumber;
            jobRole = new List<JobRole>();
            externalId = '';
            sendEmail = '';
            selectiveAccess = '';
            contactState= '';
            //extensibleAttributes = new List<extensibleAttributes>();
        }
    }
    
    public Class CreditCard{
        public String name;
        public String creditCardNumber;
        public String token;
        public String cardType;
        public String customerName;
        public String cvv;
        public String expiration;
        public String paymentTerm;
        
        public CreditCard(){
            name = '';
            creditCardNumber = '';
            token = '';
            cardType = '';
            customerName = '';
            cvv = '';
            expiration = '';
            paymentTerm = '';
        }
    }
    
    public Class CreditCardAuthorization{
        
        public String authorizationNumber;
        public String authorizationTransaction;
        public String transactionId;
        public String authorizationAmount;
        public String creditCardcurrency;
        
        public CreditCardAuthorization(){
            authorizationNumber = '';
            authorizationTransaction='';
            transactionId = '';
            authorizationAmount = '';
            creditCardcurrency = '';
        }
    }
    
    public Class OrderAddress{
        public String firstName;
        public String lastName;
        public String middleName;
        public String name;
        public String phone;
        public String emailAddress;
        public String extension;
        public String fax;
        //public List<extensibleAttributes> extensibleAttributes;
        public String title; 
        public String street1;        
        public String street2;
        public String street3;
        public String street4;
        public String city;
        public String region;
        public String district;
        public String county;
        public String postalcode;
        public String country;
        public String poBox; 
        public String alternateEmailAddress;
        public String building;
        public String floor; 
        public String room;         
        public String shippingAmount;
        public String shippingMethod;
        public String shipCarrier; 
        public String vatNumber;
        public String taxReferenceNumber;
        public String addressChange;
        public String doBusinessAs;
        public String organizationType;
        public String attentionDepartment;
        public String extAccountNumber;
        public String partnerType;
        Public Account account;
        
        public OrderAddress(){
            firstName = '';
            lastName = '';
            middleName = '';
            name= '';
            title= '';
            floor= '';
            room= '';
            building= '';
            alternateEmailAddress= '';
            poBox= '';
            shipCarrier= '';
            phone = '';
            emailAddress = '';
            extension= '';
            fax= '';
            //extensibleAttributes = new List<extensibleAttributes>();
            street1 = '';
            street2 = '';
            street3= '';
            street4 = '';
            city = '';
            district= '';
            region = '';
            county = '';
            postalcode = '';
            country = '';
            shippingAmount = '';
            shippingMethod = '';
            vatNumber = '';
            taxReferenceNumber = '';
            addressChange = '';
            doBusinessAs = '';
            organizationType = '';
            attentionDepartment = '';
            extAccountNumber = '';
            partnerType = '';
            account = new Account();            
        }
    }
    
    public Class OrderContact{
        public String contactNumber;
        public String contactType;
        public String status;
        public String department;
        public String systemReferenceID;
        public String language;
        public String sourceId;        
        public String createDate;
        public String endDate;
        public String hardBounce;
        //public List<sourceOrTargetReference> sourceOrTargetReference;
        //public List<extensibleAttributes> extensibleAttributes;
        public Address address;
        public List<Account> Account;
        public ContactFunction contactFunction;
        
        
        public OrderContact(){
            contactNumber = '';
            contactType = '';
            status = '';
            department= '';
            systemReferenceID= '';
            language= '';
            sourceId= '';
            status= '';
            createDate= '';
            endDate= '';
            hardBounce= '';
            //sourceOrTargetReference = new List<sourceOrTargetReference>();
            //extensibleAttributes= new List<extensibleAttributes>();
            address = new Address();
            Account= new List<Account>();            
            contactFunction = new ContactFunction();
        }
    }
    
    public Class OrderDeal{
        public String dealId;
        public String startDate;
        public String endDate;
        public String dealSerialNumber;
        public String programId;
        //public List<OrderLineDealDetails> orderLineDealDetails;
        //public List<extensibleAttributes> extensibleAttributes;
        
        public OrderDeal(){
            dealId = '';
            startDate = '';
            endDate = '';
            dealSerialNumber = '';
            programId = '';
            //extensibleAttributes= new List<extensibleAttributes>();
            //orderLineDealDetails = new List<orderLineDealDetails>();
        }
    }
    
    public Class OnlineContacts{
        public String lastName;
        public String middleName;
        public String name;
        public String phone;
        public String extension;
        public String fax;
        public String emailAddress;
        public String language;
        public String contactNumber;
        public String onlineContactType;
        public String contactType; //DOC-4477
        public String externalContactNumber;
        public String firstName;
        Public string locationAccountNumber;
        Public string location;
        //public List<extensibleAttributes> extensibleAttributes;
        public List<lineNumberLink> lineNumberLink;
        
        public OnlineContacts(){
            lastName  = '';
            middleName  = '';
            name  = '';
            phone  = '';
            extension  = '';
            fax  = '';
            emailAddress  = '';
            language  = '';
            contactNumber  = '';
            onlineContactType  = '';
            contactType ='';
            externalContactNumber  = '';
            firstName  = '';
            locationAccountNumber = '';
            location = '';
            lineNumberLink = new List<lineNumberLink>();
            //extensibleAttributes= new List<extensibleAttributes>();
        }
    }
    
    public Class OrderRepresentative{
        public String firstName;
        public String lastName;
        public String middleName;
        public String phone;
        public String emailAddress;
        public String representativeNumber;
        
        public OrderRepresentative(){
            firstName = '';
            lastName = '';
            middleName = '';
            phone = '';
            emailAddress = '';
            representativeNumber = '';
        }
    }
    
    public Class OrderNotes{
        public String type;
        public String lineType;
        public String notes;

        public OrderNotes(){
            type = '';
            lineType = '';
            notes = '';
        }
    }
    
    public Class QuoteDetails{
        public String quoteType;
        public String quoteNumber;
        public String latamAccountCreditRisk ;
        
        public QuoteDetails(){
            quoteType = '';
            quoteNumber = '';
            latamAccountCreditRisk = ''; 
        }
    }
    
    public Class EFTPayment{
        public String bankAccount;
        public String bankRouting;
        public String accountNumber;
        public String paymentTerm;
        public String amount;
        
        public EFTPayment(){
            bankAccount = '';
            bankRouting = '';
            accountNumber = '';
            paymentTerm = '';
            amount = '';
        }
    }
    
    public Class CreditCardPayment{
        public Decimal amount;
        public CreditCard creditCard;
        public CreditCardAuthorization creditCardAuthorization;
        public CreditCardPayment(){
            amount = 0.0;
            creditCard = new CreditCard();
            creditCardAuthorization = new  CreditCardAuthorization();
        }
    }

    public Class AccountPayment{
        public String accountNumber;
        public String paymentTerm;
        public String amount;
        
        public AccountPayment(){
            accountNumber = '';
            paymentTerm = '';
            amount = '';
        }
    }
    
    public Class Material{
        public String materialId;
        public String materialDescription;
        public String materialType;
        public String configType;
        public String productPlanId;
        public String plant;
        public List<Material> material;
        public Integer quantity;
        
        public Material(){
            materialId = '';
            materialDescription = '';
            materialType = '';
            configType = '';
            productPlanId = '';
            material = new list<Material>();
            plant = '';
            quantity = 0;
        }
        
    }
    
    public Class SubscriptionTerms{
        public String period;
        public SubscriptionTerms(){
            period = '';
        }
    }
    
    public Class OrderLines{
        
        public Decimal orderLineNumber;
        public String actionCode;
        public String sourceOrTargetReferenceLineNumber;
        public Integer quantity;
        public String unitOfMeasure;
        public Decimal listAmount;
        public Decimal netAmount;
        public String taxAmount;
        public String shippingAmount;
        public String handlingAmount;
        public String shippingMethod;
        public String onlineChargesEligible;
        public String contractLineNumber;
        public Date contractStartDate;
        public Date contractEndDate;
        public String subscriptionType;
        public String termType;
        public String percentIncrease;
        public String baseValue;
        public String userRate;
        public String termLength;
        public String taxExempt;
        public String numberOfUsers;
        public String numberOfConcurrentUsers;
        public String priceDate;
        public String relatedLine;
        public String assetNumber;
        public String noOfAttorneys;
        public String billingAccount;
        public Boolean adtlCustSpecPrice; //DOC-1866
        public Date effectiveDate;
        public Date endDate;
        public String billPlanType;
        public String billOfMaterialsType;
        public String billPlanUpdateRule;
        public String programId;
        public String itemCategory;
        public String outClause;
        public String noBillOfMaterialsExplosion;
        public String serviceAgreementId;
        public Boolean keepTerms;
        public String acceptanceDate;
        public String advancePercentage;
        public String freeServiceDays;
        public String amendmentFlag;
        public String productType;
        public String itemCategoryGroupCode;
        public String brandName;
        public String fiscalFilerMonth;
        public Material material;
        public SubscriptionDetail subscriptionDetail;
        public OrderLapseLines orderLapseLines;
        public Assets assets;
        Public  List<adjustments> adjustments;
                
        public OrderLines(){
            orderLineNumber = 0;
            actionCode = '';
            sourceOrTargetReferenceLineNumber = '';
            quantity = 0;
            unitOfMeasure = '';
            listAmount = 0.0;
            netAmount = 0.0;
            taxAmount = '';
            shippingAmount = '';
            handlingAmount = '';
            shippingMethod = '';
            onlineChargesEligible = '';
            contractLineNumber = '';
            contractStartDate = null;
            contractEndDate = null;
            subscriptionType = '';
            termType = '';
            percentIncrease = '';
            baseValue = '';
            userRate = '';
            termLength = '';
            adtlCustSpecPrice = false;
            taxExempt = '';
            numberOfUsers = '';
            numberOfConcurrentUsers = '';
            priceDate = '';
            relatedLine = '';
            assetNumber = '';
            noOfAttorneys = '';
            billingAccount = '';
            effectiveDate = null;
            endDate = null;
            billPlanType = '';
            billOfMaterialsType = '';
            billPlanUpdateRule = '';
            programId = '';
            itemCategory = '';
            outClause = '';
            noBillOfMaterialsExplosion = '';
            serviceAgreementId = '';
            keepTerms = false;
            acceptanceDate = '';
            advancePercentage = '';
            freeServiceDays = '';
            amendmentFlag = '';
            brandName = '';
            productType = '';
            itemCategoryGroupCode = '';
            material = new Material();
            subscriptionDetail = new SubscriptionDetail();
            orderLapseLines = new OrderLapseLines();
            assets = new Assets();
            adjustments= new  List<adjustments>();           
        }
    }
    
    public Class SubscriptionDetail{
        
        public Date contractStartDate;
        public Date contractEndDate;
        public string subscriptionType;
        public string contractNumber;
        public string contractLineNumber;
        public string termType = 'DAY';
        public String renewalPlanType;
        public List<terms> subscriptionTerms;
        public properties properties;
        public boolean donotRenewFlag; //DOC-2209
        
        public SubscriptionDetail(){
            contractStartDate = null;
            contractEndDate = null;
            subscriptionType = '';
            contractNumber = '';
            contractLineNumber = '';
            termType = '';
            renewalPlanType = '';
            donotRenewFlag=false;
            subscriptionTerms = new List<terms>();
        }
    }
    
    public class Terms{
    
        public string period;
        public String termLength;
        public string percentIncrease;
        public Decimal baseValue;
        public Decimal userRate;
        Public properties properties;
    
        public Terms(){
            period = '';
            termLength = null;
            percentIncrease = null;
            baseValue = null;
            userRate = null;
        }
    }//DOC-2391
    public Class JobRole{
        public String role;
                
        public JobRole(){
            role ='';         
        }
    }
    
    global class properties{
        public string key;
        public string value;
        
        public properties(){
            key = '';
            value = '';
        }
    }
    
    public Class Adjustments {
        
        public String discountType;
        public String discountCode;
        public String discountAmount;
        public String discountPercent;
        public String discountPeriod;
        public String discountReason;

        
        public Adjustments(){
            discountType = '';
            discountCode = '';
            discountAmount = '';
            discountPercent = '';
            discountPeriod = '';
            discountReason = '';
        }
    }

    public Class LineNotes {
        public String type;
        public String lineType;
        public String notes;
        
        public LineNotes(){
            type = '';
            lineType = '';
            notes = '';
        }
    }
    
    public Class Assets{
        public String assetId;
        public Integer Quantity;
        public String sourceOrderAssetLineItemId;
        
        public Assets(){
            assetId = '';
            quantity = 0;
            sourceOrderAssetLineItemId = '';
        }
    }
    
    public Class OnlineDetail{
        public String domain;
        public String classification;
        
        public OnlineDetail(){
            domain = '';
            classification = '';
        }
    }
    
    public class attachments{    
        public String attchmentStatus;
        public String attachmentPath;
        public String attachmentType;
        public String attachmentContents;
        //public List<extensibleAttributes> extensibleAttributes;
        
        public attachments(){
            attchmentStatus= '';
            attachmentPath= '';
            attachmentType= '';
            attachmentContents= '';
            //extensibleAttributes= new List<extensibleAttributes>();
        
        }
    }
    
    public class ContactFunction{
        
        public String accountNumber;
        public Boolean isPrimary;
        public String action;
        public String scope;
        public String functionValue;
        public Boolean licenseManagerFlag;
        
        public ContactFunction(){
            accountNumber = '';
            isPrimary = false;
            action = '';
            scope = '';
            functionValue = '';
            licenseManagerFlag = false;
        }
    }
    
    global class orderLapseLines{
       
        public string materialId;
        public Integer contractNumber;
        public string dealType;
        public Integer contractLineNumber;
        public string description;
        public string reasonCode;
        public string dealNumber;
        public string agreementNumber;
        public Date lapseDate;
        public String lapseCode;
        public Integer lapseQuantity;
        Public properties properties;
        public String specialOfferLapseFlag;
       
        public orderLapseLines(){
            materialId = '';
            // contractNumber = '';
            dealType = '';
            // contractLineNumber = '';
            description = '';
            reasonCode = '';
            dealNumber = '';
            agreementNumber = '';
            lapseDate = null;
            lapseCode = '';
            // lapseQuantity = 0;
            specialOfferLapseFlag = '';
        }
    }
}