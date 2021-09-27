global class CreateS4HANAOrderRequest {
    public List<Material> lstOfMaterial;
    public CreateS4HANAOrderRequest(){
        orderHeader= new orderHeader();
        BOOMIHeader= new BOOMIHeader();
        orderLines= new List<orderLines>();
        lstOfMaterial = new List<Material>();
        
    }

    public class Account {
        public String accountNumber;
        public String companyId;
        public String companyCode;
        public String companyName;
        public String accountType;
        public String isActive;
        public String accountStatus;
        public String currency_x;
        public String salesOrg;
        public String distributionChannel;
        public String division;
        public List<address> address;
        public String externalAccountId;
        
        public Account(){
            accountNumber='';
            companyId='';
            companyName='';
            accountType='';        
            currency_x='';
            accountStatus = '';
            isActive='false';
            salesOrg='';
            distributionChannel='';
            division='';
            address = new List<address>();
            companyCode = '';
            externalAccountId = '';
        }
    }
     public Class address{
       public String firstName;
        public String lastName;
        public String middleName;
        public String phone;
        public String emailAddress;
        public String extension;
        public String fax;
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
        public String externalContactId;     
                
        public address(){
            firstName = '';
            lastName = '';
            middleName = '';
            title= '';
            floor= '';
            room= '';
            building= '';
            alternateEmailAddress= '';
            poBox= '';
            
            phone = '';
            emailAddress = '';
            extension= '';
            fax= '';
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
            poBox=''; 
            alternateEmailAddress='';
            building='';
            floor=''; 
            room=''; 
            externalContactId='';
        }
    }
    public class OrderHeader {
        public String orderTimestamp;
        public String purchaseOrderNumber;
        public Date purchaseDate;
        public String orderCurrency;
        public List<OrderAddress> orderAddress= new List<OrderAddress>();
        public List<OrderContact> orderContact = new List<orderContact>();
        public CreditCardPayment creditCardPayment;
        public String esignDate;
        public String orderPeriodicValue;
        public String oneTimeValue;
        public String salesOffice;
        public String paymentMethod;
        Public accountPayment accountPayment;
        public List<QuoteDetails> quoteDetails = new List<QuoteDetails>();
        Public List<onlineContacts> onlineContacts;
        public String orderType;
        public String orderNumber;
        public String actionCode;
        public orderRepresentative orderRepresentative;
    public eftPayment eftPayment;
        
        public OrderHeader(){
            orderTimestamp ='';
            purchaseOrderNumber='';
            purchaseDate=null;
            orderCurrency='';
            creditCardPayment = new creditCardPayment();
            esignDate='';
            orderPeriodicValue='';
            oneTimeValue='';
            salesOffice='';
            paymentMethod='';
            onlineContacts = new List<onlineContacts>();
            accountPayment = new accountPayment();
            orderType = '';
            orderNumber = '';
            orderRepresentative = new orderRepresentative();
        eftPayment = new eftPayment();
        }
    }
    
    

    public class Material_Z {
        public Material material;
        
        public material_z(){
            material = new Material();
        }
    }

    public class Account_Z {
        public String accountNumber;
    }

    public class SubscriptionTerms {
        public Integer period;
        public Double percentIncrease;
        public Double baseValue;
        public Double userRate;
        public String termLength;
        
        public SubscriptionTerms (){
            period=0;
            percentIncrease=0.00;
            baseValue=0.00;
            userRate=0.00;
            termLength='';
        }
    }

    public BOOMIHeader BOOMIHeader;
    public OrderHeader orderHeader;
    public List<OrderLines> orderLines;

    public class OrderLines {
        public String orderLineNumber;
        public String sourceOrTargetReferenceLineNumber;
        public Integer quantity;
        public String unitOfMeasure;
        public Decimal listAmount;
        public Decimal netAmount;
        public Decimal taxAmount;
        public String shippingMethod;
        public Material_z materialz;
        public String onlineChargesEligible;
        public SubscriptionDetail subscriptionDetail;
        public String taxExempt;
        public String linePurchaseOrderNumber;
        public Integer numberOfUsers;
        public String priceDate;
        public String paymentMethod;
        public String copyCreditCardInfo;
        public String effectiveDate;
        public Date endDate;
        public String acceptanceDate;
        public String billPlanType;
        Public  List<adjustments> adjustments;
        public Material material;
        public List<bandRange> bandRange;
        public List<assets> assets;
        public String actionCode;
        public String bundleIdentifier;
        public String relatedLine;
        public Integer numberOfConcurrentUsers;
        public Boolean ipFlag;
        public Boolean isOnlinecontactsExist;
        public Boolean numberOfAdditionalUsers;
        
        public OrderLines(){
            orderLineNumber='';
            sourceOrTargetReferenceLineNumber='';
            quantity =0;
            unitOfMeasure ='';
            listAmount=0.00;
            netAmount=0;
            taxAmount=0;
            ShippingMethod='';        
            onlineChargesEligible='';        
            taxExempt='';
            linePurchaseOrderNumber='';
            numberOfUsers =0;
            priceDate='';
            paymentMethod='';
            copyCreditCardInfo='';
            effectiveDate= null;
            endDate=null;
            acceptanceDate='';
            billPlanType='';
            subscriptionDetail = new SubscriptionDetail();
            materialz = new Material_z();
            adjustments= new  List<adjustments>();
            material = new Material();
            bandRange =  new List<bandRange>();
            assets = new List<assets>();
            actionCode = '';
            bundleIdentifier = '';
            relatedLine = '';
            ipFlag = false;
            isOnlinecontactsExist= true;
            numberOfAdditionalUsers = false;
            
        }
    }

    public class OrderAddress {
        public String partnerType;
        public Account account;
        public String postalcode;
        public String country;
        public String city;
        public String firstName;
        public String region;
        
        public OrderAddress(){
            partnerType='';
            account = new Account();
            region = '';
            city = '';
            firstName = '';
            country = '';
            postalCode = '';
        }
    }

    public class Material {
        public String materialId;       
        public String materialNumber;
        public String materialDescription;
        public String materialType;
        public Material material;
        public String productDelivery;
        public String productVarient;
        
        public Material(){
            materialId = '';                    
            materialNumber ='';
            materialDescription='';
            materialType='';
            productDelivery= '';
            productVarient= '';
        }
    }

    public class CreditCard {
        public String name;
        public String cardNumber;
        public String token;
        public String cardType;
        public String customerName;
        public String cvv;
        public String expiration;
        public String paymentTerm;
        
        public CreditCard(){
            name = '';
            cardNumber = '';
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
        public String creditCardcurrency;
        public Decimal authorizationAmount;
        
        public CreditCardAuthorization(){
            authorizationNumber = '';
            authorizationTransaction='';
            transactionId = '';
           
            creditCardcurrency = '';
            authorizationAmount=0.0;
        }
    }
    public class CreditCardPayment {
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
        
        public String paymentTerm;
        
        public AccountPayment(){
            paymentTerm = '';
            
        }
    }
 
    public class BOOMIHeader {
        public String applicationId;
        public String transactionId;
        public String timeStamp;
        
        public BOOMIHeader(){
        applicationId ='';
        transactionId='';
        timeStamp='';
        }
    }

    public class SubscriptionDetail {
        public String contractNumber;
        public String contractLineNumber;
        public String contractStartDate;
        public String contractEndDate;
        public List<SubscriptionTerms> subscriptionTerms;
        public String renewalPlanType;
        public String revenueType;
        public String termType;        
        public Decimal cotermPrice;
        
        public SubscriptionDetail (){
            contractNumber ='';
            contractLineNumber='';
            contractStartDate='';
            contractEndDate='';
            subscriptionTerms = new List<SubscriptionTerms>();
            renewalPlanType='';
            revenueType='';
            termType='';
        }
    }

    public class QuoteDetails {
        public String quoteType;
        public String quoteNumber;
        public String orderItemNumber;
        public String RetractQuoteNumber;
        
        public QuoteDetails(){
            quoteType = '';
            quoteNumber ='';
            orderItemNumber='';
            RetractQuoteNumber='';
        
        }
    }

    public class OrderContact {
        public String contactNumber;
        public String department;
        public String language;
        public String systemReferenceID;
        public String sourceId;
        public String contactType;
        public String status;
        public String createDate;
        public String endDate;
        public String hardBounce;
        public String currencyCode;
        public address address;
        public ContactFunction contactFunction;
        
        public orderContact(){
            contactNumber ='';
            department='';
            language='';
            systemReferenceID='';
            sourceId='';
            contactType='';
            status='';
            createDate='';
            endDate='';
            hardBounce='';
            currencyCode='';
            address = new address();
            contactFunction = new ContactFunction();
        
        }
    }
    public Class OnlineContacts{
        public String lastName;
        public String middleName;
        public String firstName;
        public String phone;
        public String locationAccount;
        //public String extension;
        //public String fax;
        public String emailAddress;
        public String language;
        public String contactNumber;
        public List<lineNumberLink> lineNumberLink;
        public String onlineContactType;
              
        public OnlineContacts(){
            lastName  = '';
            middleName  = '';
            firstName  = '';
            phone  = '';         
            language='';  
            emailAddress  = '';            
            contactNumber  = '';
            lineNumberLink = new List<lineNumberLink>();
            onlineContactType = '';
            locationAccount = '';
            
        }
    }
     public Class Adjustments {
        
        public String discountType;
        public String discountPeriod;
         public decimal discountPercent;
        
        public Adjustments(){
            discountType = '';
            discountPeriod = '';
            discountPercent = 0.0;
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
    
    
    public class lineNumberLink{
       public String actionCode;
       public String lineNumber;
       public List<jobRole> jobRole;
       public lineNumberLink(){
           actionCode = '';
           lineNumber = '';
           jobRole = new List<jobRole>();
       }
       
    }
    
    public class jobRole{
        public String role;
        public String roleDesc;
        public jobRole(){
            role = '';
            roleDesc = '';
        }
    }
    
    public class bandRange{
        public String bandLow;
        public String bandHigh;
        public String baseCount;
        public String userCap;
        public String userAvailable;
        public String userCount; 
        
        public bandRange(){
            bandLow = '';
            bandHigh = '';
            baseCount = '';
            userCap = '';
            userAvailable = '';
            userCount ='';
        
        }
    }
    
    public class assets{
        
        public String assetId ;
        public String Quantity;
        public String sourceOrderAssetLineItemId;   
    
        public assets(){
            assetId = '';
            Quantity = '';
            sourceOrderAssetLineItemId = '';
        }
    }
    
     public class orderRepresentative{
        public String representativeNumber;
        public String representativeName;
        public String emailAddress;
        public orderRepresentative(){
            emailAddress = '';
        }
    }   
    public class eftPayment{
        public String bankAccount;
        public String bankRouting;
        public String bankName;
        public eftPayment(){
            bankAccount = '';
            bankRouting = '';
            bankName = '';
        }
    }
}