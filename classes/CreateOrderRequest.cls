/**
 * @description
 */
global class CreateOrderRequest {
    /**
     * @description
     */
    public OrderRequest CreateOrderRequest {get; set;}
    /**
     * @description
     */
    Public CreateOrderRequest(){
    
    CreateOrderRequest = new OrderRequest ();
    }
    
    /**
     * @description
     */
  global class OrderRequest{
  
        Public ESIHeader ESIHeader;
        Public orderHeader orderHeader;
        Public List<orderLapseLines> orderLapseLines;
        Public List<orderLines> orderLines;
       
        /**
         * @description
        */
        Public OrderRequest(){
  
        orderHeader= new orderHeader();
        orderLapseLines= new List<orderLapseLines>();
        ESIHeader= new ESIHeader();
        orderLines= new List<orderLines>();
        
        }
  }
    /**
     * @description
     */
    global class ESIHeader{
       public String applicationId;
       public String transactionId;
       public String messageId;
       public String messageHistory;
       public String tracingId;
       public String timeStamp;
       public String instanceId;
       public String configGroup;
       public String payloadVersion;
       
       /**
     * @description
     */
       public ESIHeader(){
        applicationId='SF04';
        transactionId='WEST';
        messageId='';
        messageHistory='';
        tracingId='';
        timeStamp='';
        instanceId='';
        configGroup='';
        payloadVersion='';
      }
       }
       /**
     * @description
     */
     global class orderHeader{  
         
        public string originatingOrderNumber;
        public string approvalNumber;   
        public string referenceNumber;
        public string oaMode;
        public Datetime orderTimestamp;
        public string type;
        public string description;
        public string quoteNumber;
        public string brandingName;
        public string orderCurrency;
        public string orderedBy;
        public string confirmUrl;
        public string esignDate;
        public string numberOfAttorneys; 
        public boolean completeDelivery=true;
        public boolean eBillExempt =true;
        public string NoCombine;
        public string orderPeriodicValue;
        public string salesOffice; 
        public string paymentMethod;
        public string revenueChannel;
        public string orderSource;
        public string incoTerms;
        public string poNumber;
        public string holdForReview;
        public string renewalValue;
        public string profileId;
        public string WLDID;
        public decimal netAnnualAmount; //Findlaw Changes
        
        public string workItemLabel;
        public string orderReason;
        public string CustSupMktSeg;
        public string yourReference;
        public boolean saveCreditCardFlag=true;
        Public String oneTimeValue;
        
        public String costCenter;
        
        public creditCardPayment creditCardPayment;
        Public List<orderAddress> orderAddress;
        Public orderRep orderRep;
        Public List<orderContact> orderContact;
        Public List<onlineContacts> onlineContacts;
        Public properties properties;
        Public List<orderNotes> orderNotes;
        Public accountPayment accountPayment;
        //Public orderDeal orderDeal; Sreenu Changes for FindLaw
        Public List<orderDeal> orderDeal; // Sreenu changes for FindLaw
        Public List<attachments> attachments;
        Public eftPayment eftPayment;
        Public List<MLAInfo> MLAInfo;
        Public boolean creditApproval; //SOC-4827
        //Doc-15792 
      Public String trialId;           //trials change
      Public List<OfferWrapper> offerData;  //trials change
        /**
         * @description
         */
        public orderHeader()
    {
         
         originatingOrderNumber ='';
         approvalNumber = '';
         oneTimeValue='';
         referenceNumber ='';
         poNumber='';
         oaMode ='';
         orderTimestamp =null;
         type='';
         description ='';
         costCenter = '';
         quoteNumber ='';
         brandingName ='';
         orderCurrency ='';
         orderedBy ='';
         confirmUrl ='';
         esignDate ='';
         numberOfAttorneys =''; 
         completeDelivery =false;
         eBillExempt = false;
         NoCombine ='';
         orderPeriodicValue ='';
         salesOffice =''; 
         paymentMethod ='';
         revenueChannel ='';
         orderSource ='';
         incoTerms ='';
         holdForReview='';
         renewalValue='';
         profileId='';
         WLDID='';
         netAnnualAmount = 0;
         creditCardPayment=new creditCardPayment();
         orderAddress = new List<orderAddress> ();
         orderRep = new orderRep ();
         orderContact = new List<orderContact> ();
         onlineContacts = new List<onlineContacts> ();
         properties = new properties ();
         orderNotes = new List<orderNotes> ();
         accountPayment = new accountPayment ();
         orderDeal = new List<orderDeal>(); // Sreenu Changes for FindLaw to List
         attachments  = new List<attachments> ();
         eftPayment =new eftPayment ();
         MLAInfo = new List<MLAInfo>();
        
         workItemLabel ='';
         orderReason ='';
         CustSupMktSeg ='';
         yourReference ='';
         saveCreditCardFlag =false;
         creditApproval =false; //SOC-4827
         //doc-15792
       trialId='';
       offerData= new List<OfferWrapper>();  //trials change
        }
    }
    /**
         * @description
         */
    global class eftPayment{
    
    public string amount;
    public string bankAccount;
    public string bankRouting;
    Public properties properties;
     
    /**
    * @description
    */
     Public eftPayment(){
    
     amount ='';
     bankAccount ='';
     bankRouting ='';
    
    }
  }
    /**
         * @description
         */
    global class properties{
    
        Public string key;
        Public string value;
        /**
         * @description
         */
        Public properties(){
    
         key ='';
         value ='';
    }
  
    
    }
    /**
         * @description
         */
    global class creditCardPayment{
        public string amount;
        public string cardNumber;
        public string expiration;
        public string authorizationNumber;
        public string authorizationTransaction;
        public string cardType;
        public string cvv;	
      public List<properties> properties;
       /**
         * @description
         */
       public creditCardPayment(){
         amount ='';
         cardNumber ='';
         expiration ='';
         authorizationNumber ='';
         authorizationTransaction ='';
         cardType='MC';
         cvv ='';
       properties = new List<properties>();
       
    
    }
    
    }
    /**
  * @description Wrapper class for offers
  */
  public class OfferWrapper{
  
  public string offerId;
  /**
  * @description Wrapper class for offers
  */
  public OfferWrapper(){ 
      offerId='';
  }
  
  
  
  }
    /**
         * @description
         */
   global class accountPayment{
         public string amount;
         public string accountNumber;
         public String paymentTerm;
         Public properties properties;
         /**
         * @description
         */
          public accountPayment(){
          amount ='';
          accountNumber ='';
          paymentTerm ='';
    }
    }
    /**
    * @description
    */
    global class orderAddress{
    
        public string partnerType;
        public string shippingAmount;
        public string shippingMethod;
        public string accountNumber;
        public string name1;
        public string name2;
        public string name3;
        public string street1; 
        public string street2;
        public string street3;
        public string street4; 
        public string city; 
        public string region;
        public string postal;
        public string country;
        public string phone;
        
        public string vatNumber;
        public string taxReferenceNumber;
        public string addressChange;
        public string doBusinessAs;
        
        public string vaorganizationTypetNumber;
        public string attentionDepartment;
        public string extAccountNumber;
        public string district;
        public string fax;
        public string poBox;
        Public properties properties;
        Public account account;
        /**
        * @description
        */
        public orderAddress(){
    
         partnerType ='';
         shippingAmount ='';
         shippingMethod ='';
         accountNumber ='';
         name1 ='';
         name2 ='';
         name3 ='';
         street1 =''; 
         street2 ='';
         street3 ='';
         street4 =''; 
         city =''; 
         region ='';
         postal ='';
         country ='';
         phone ='';
         vatNumber ='';
         taxReferenceNumber ='';
         addressChange ='';
         doBusinessAs ='';
         vaorganizationTypetNumber ='';
         attentionDepartment ='';
         extAccountNumber ='';
         district ='';
        
        
         fax ='';
         poBox ='';
         account= new account();
        
    
    }
        
    
    }
    /**
    * @description
    */
     global class account{
    
       public string accountNumber;
       public string companyId;
       /**
        * @description
        */
        public account(){
    
        accountNumber ='';
        companyId ='';
        
    }
    }
    /**
    * @description
    */
    global class orderRep{
    
       public string repNumber;
       public string firstName;
       public string lastName;
       public string phone;
       public string email;
       Public properties properties;
       /**
        * @description
        */
        public orderRep(){
    
        repNumber ='';
        firstName ='';
        lastName ='';
        phone ='';
        email ='';
       
    }
    }
    /**
    * @description
    */
    global class orderContact{
      
      public string addressType;
        public string firstName;
        public string lastName;
        public string phone;
        public string phoneExtension;
        public string emailAddress;
        public string contactNumber;
        public string department; 
        public string fax;
        public string function;
        public string building; 
        public string floor; 
        public string room;
        public string contactType;
        Public properties properties;
        /**
        * @description
        */
        public  orderContact(){
      
      addressType ='';
         firstName ='';
         lastName ='';
         phone ='';
         phoneExtension ='';
         emailAddress ='';
         contactNumber ='';
         department =''; 
         fax ='';
         function ='';
         building =''; 
         floor =''; 
         room ='';
         contactType ='';
         
        
    }
        
    }
    //MLA
    /**
    * @description
    */
    global class MLAInfo{
      
      
        Public properties properties;
        Public List<MLAHeader> MLAHeader;
        Public List<CustomerGroup> CustomerGroup;
        Public List<ContentMaterials> ContentMaterials;
        Public List<CustomerDetails> CustomerDetails;
        Public List<UserDetails> UserDetails;
        /**
        * @description
        */
        public  MLAInfo(){
        properties = new properties ();
        MLAHeader = new List<MLAHeader>();
        CustomerGroup=new List<CustomerGroup>();
        ContentMaterials= new List<ContentMaterials>();
        CustomerDetails = new List<CustomerDetails>();
        UserDetails = new List<UserDetails>();
        
    }
        
    }
    /**
    * @description
    */
    global class MLAHeader{
      
      
        public string soldTo;
        public string lineNumber;
        public string material;
        public string mlaOption;
        public string determineBillPayer;
        public string determineBillTo;
        public string noOfAttorneys;
        public string discountPercent;
        public string discountValue;
        public string surcharge;
        public string agreementNetPrice;
        public string agreementNum;
        public string pricingOption;
        Public properties properties;
       
        /**
        * @description
        */
        public  MLAHeader(){
         
         soldTo='';
         lineNumber='';
         material='';
         mlaOption='';
         determineBillPayer='';
         determineBillTo='';
         noOfAttorneys='';
         discountPercent='';
         discountValue='';
         surcharge='';
         agreementNetPrice='';
         agreementNum='';
         pricingOption='';
         properties = new properties ();
      
    }
        
    }
    /**
    * @description
    */
    global class CustomerGroup{
      
      
        public string lineNumber;
        public string locationAcc;
        public string material;
        public string billPayer;
        public string billTo;
        public string validFrom;
        public string validTo;
        public string allocationPerc;        
        Public properties properties;
       
        /**
        * @description
        */
        public  CustomerGroup(){
         
         lineNumber='';
         locationAcc='';
         material='';
         billPayer='';
         billTo='';
         validFrom='';
         validTo='';
         allocationPerc=''; 
         properties = new properties ();
      
    }
        
    }
    /**
    * @description
    */
    global class ContentMaterials{
      
      
        public string lineNumber;
        public string material;
        public string locationAcc;
        public string noOfAllocations;
        public string validFrom;
        public string validTo;      
        Public properties properties;
       
        /**
        * @description
        */
        public  ContentMaterials(){
         
             lineNumber='';
             material='';
             locationAcc='';
             noOfAllocations='';
             validFrom='';
             validTo=''; 
             properties = new properties ();
      
    }
        
    }
    /**
    * @description
    */
    global class CustomerDetails{
    
        public string custNumber;
        public string isPrimary;
        Public properties properties;
        /**
        * @description
        */
        public CustomerDetails(){
            
            custNumber='';
            isPrimary='';
            properties = new properties ();
        }
        }
        /**
        * @description
        */
     global class UserDetails{
        
        public string locationAcc;
        public string contactNum;
        public string firstName;
        public string lastName;
        public string contactType;
        public string email;
        Public properties properties;
        /**
        * @description
        */
      public UserDetails(){
          
          locationAcc='';
          contactNum='';
          firstName='';
          lastName='';
          contactType='';
          email='';
          properties = new properties ();
      
      }
     }
    
    //MLA ends
    /**
    * @description
    */
    global class orderDeal{
        //Sreenu changes for FindLaw Order
        public string dealSerialNumber;
        public string programId;
        //Sreenu changes end
        public string dealId;
        public string startDate;
        public string endDate;
        Public properties properties;
        Public List<lineItems> lineItems;
        Public string actionCode; //May release - SOC-5982
        /**
        * @description
        */
        Public orderDeal(){
         dealSerialNumber = ''; 
         programId = '';
         dealId = '';
         startDate = '';
         endDate = '';
         lineItems = new List<lineItems>();
         actionCode = ''; //May release - SOC-5982
    }
        
    }
    /**
    * @description
    */
    global class lineItems{
    
      public string lineNumber;
      public string existingSub;
      public string existingSubLine;
      public string recordType;
      public string discount;
      public string quanity;
      Public properties properties;
      /**
        * @description
        */
      public lineItems(){
    
       lineNumber ='';
       existingSub= '';
       existingSubLine= '';
       recordType= '';
       discount ='';
       quanity= '';
      
    }
    }
    /**
    * @description
    */
   global class attachments{
    
       Public string type;
       Public string status;
       Public string path;
       Public string contents;
       Public properties properties;
       /**
        * @description
        */
       Public  attachments(){
    
       
        type ='';
        status ='';
        path ='';
        contents ='';
       
    }
       
    }
    /**
    * @description
    */
   global class onlineContacts{
    
        public string firstName;
        public string lastName;
        public string phone;
        public string phoneExtension;
        public string emailAddress;
        public string contactNumber;
        public string onlineContactType;
        public string externalContactNumber; 
        Public lineNumberLink lineNumberLink;
        Public properties properties;
        Public string locationAccountNumber; //SOC-7060
        /**
        * @description
        */
        Public onlineContacts(){
    
         firstName ='';
         lastName ='';
         phone ='';
         phoneExtension ='';
         emailAddress ='';
         contactNumber ='';
         onlineContactType ='';
         externalContactNumber =''; 
         lineNumberLink= new lineNumberLink ();
         locationAccountNumber =''; //SOC-7060
    }
    }
    
    //Inside online contact
    /**
    * @description
    */
    global class lineNumberLink{
          
          public string lineNumber;
          public string externalId;
          public string contactState;
          public string sendEmail;
          public string selectiveAccess;
          /**
            * @description
            */
          public  lineNumberLink(){
          
           lineNumber =null;
           externalId ='';
           contactState ='';
           sendEmail ='';
           selectiveAccess ='';
    }
    }
    /**
    * @description
    */
   global class orderNotes{
    
         public string type;
         public string lineType;
         public string notes;
         /**
    * @description
    */
          public orderNotes(){
    
          type ='';
          lineType ='';
          notes ='';
       
    }
    }
    //OrderLineitem details
    /**
    * @description
    */
    global class orderLapseLines{
    
       
       public string materialId;
       public string contractNumber;
       public string dealType;
       public string contractLineNumber;
       public string description;
       public string reasonCode;
       public string dealNumber;
       public string agreementNumber;//Bijeta May SOC-5984
       public Date lapseDate;
       public string lapseCode;
       public string lapseQuantity;
       Public properties properties;
       public string specialOfferLapseFlag; //SOC-5987
       /**
    * @description
    */
       public  orderLapseLines(){
    
       
        materialId ='';
        contractNumber ='';
        dealType ='';
        contractLineNumber ='';
        description ='';
        reasonCode ='OL';
        dealNumber ='';
        agreementNumber ='';//Bijeta May SOC-5984
        lapseDate =null;
        lapseCode ='OL';
        lapseQuantity ='';
        specialOfferLapseFlag =''; //SOC-5987
    }
    }
    /**
    * @description
    */
    global class orderLines{
    
        
        public string lineNumber;
        public string referenceNumber;
        public Decimal quantity;
        public string unitOfMeasure='NA';
        public Decimal listAmount;
        public Decimal netAmount;
        public string saID;
        public string programId;
        public Decimal taxAmount;
        public Decimal shippingAmount;
        public Decimal handlingAmount;
        public string shippingMethod;
        public Date priceDate;
        public string billOfmaterialType;
        public string itemCategory;
        public string noBomExplosion;
        public string storageLocation; 
        public boolean taxExempt =true;
        public string linePoNumber;
        public string revRecType;
        
        public string numberOfUsers;
        public string numberOfConcurrentUsers;
        public string relatedLine;
        public string paymentMethod;
        public string numberOfAttorneys;
        public string billPlanType;
        public string billOfMaterialsType;
        
        public string billPlanUpdateRule;
        public string autoLapseFlag;
        public string shippingPoint;
        public string entryOrderType;
        public string priceQuantity;
        public string componentId;
        public string acceptanceDate;
        public string advancePerc;
        public string revType;
        public boolean outClause;
        public boolean keepTerms;
        public boolean amendmentFlag;
      
        public material material;
        public subscriptionDetail subscriptionDetail;
        Public properties properties;
        Public onlineDetail onlineDetail;
        Public  List<adjustments> adjustments;
        Public lineNotes lineNotes;
        public string freeServiceDays; //Findlaw Changes
        Public Date AdjRnwlStDate;  //Findlaw Changes
        public boolean bundleType; //SOC-5992
        public List<naicData> naicData;//Roma
        public string adjRnwlBaseValue;
        /**
        * @description
        */
        public orderLines(){
            material = new material();
            subscriptionDetail= new subscriptionDetail();
            properties = new properties();
            onlineDetail = new onlineDetail();
            adjustments= new  List<adjustments>();
            lineNotes= new lineNotes();
            
            
            
         lineNumber ='';
         referenceNumber ='';
         outClause=False;
         quantity =null;
         unitOfMeasure ='NA';
         netAmount=null;
         programId='';
         listAmount =null;
         billOfMaterialsType='';
         taxAmount =null;
         shippingAmount =null;
         handlingAmount =null;
         shippingMethod ='';
         priceDate =null;
         priceQuantity='';
         billOfmaterialType ='';
         itemCategory ='';
         noBomExplosion ='';
         storageLocation ='';
         saID=''; 
         taxExempt =true;
         linePoNumber ='';
         keepTerms=false;
         revRecType ='';
         numberOfUsers ='';
         numberOfConcurrentUsers ='';
         relatedLine ='';
         paymentMethod ='';
         numberOfAttorneys ='';
         billPlanType ='';
         billPlanUpdateRule ='';
         autoLapseFlag ='';
         shippingPoint ='';
         entryOrderType ='';
         componentId='';
         acceptanceDate='';
         advancePerc='';
         revType='';
         freeServiceDays = '';
         AdjRnwlStDate= null;
         bundleType=false; //SOC-5992
         adjRnwlBaseValue='';
     }
   }
    //Roma Starts
    /**
    * @description
    */
    global class naicData{
    public string naicNumber;
    public string naicName;
    /**
    * @description
    */
        public naicData(){
        naicNumber= '';
        naicName = '';
        }
    }
   
   //Roma Ends
   /**
    * @description
    */
   global class material{
    
         public string materialId;
         public string externalMaterialId;
         public string productAccessType; //SOC-8627 Patrons 
         public string productGroup;
         public string productFormat;
         public string productTaxCode;
         public string priceType;
         public string description;
         public string plant;
         public string sourceId;
         public string locationCode; // Sreenu FindLaw Changes
         public string practiceArea; // Sreenu FindLaw Changes
         public string serviceMaterialId;
         Public properties properties;
         /**
    * @description
    */
          public material(){
    
          materialId ='';
          externalMaterialId ='';
          productAccessType = ''; //SOC-8627 Patrons
          productGroup ='';
          productFormat ='';
          productTaxCode ='';
          priceType ='';
          description ='';
          plant ='';
          sourceId ='';
          locationCode = '';        
          practiceArea = '';
          serviceMaterialId='';
    
    }
    
    }
    /**
    * @description
    */
    global class onlineDetail{
    
         public string domain;
         public string classification;
         Public properties properties;
         /**
    * @description
    */
         public onlineDetail(){
    
         domain='';
         classification='';
         
        
    }
        
    }
    /**
    * @description
    */
  global class subscriptionDetail{
    
         public Date contractStartDate;
         public Date contractEndDate;
         public string subscriptionType;
         public string contractNumber;
         public string contractLineNumber;
         public string termType='DAY';
         Public List<terms> terms;
         Public properties properties;
        /**
    * @description
    */
        public subscriptionDetail(){
    
         contractStartDate =null;
         contractEndDate =null;
          subscriptionType ='';
          contractNumber ='';
          contractLineNumber ='';
          termType='';
          terms = new List<terms>();
    }
   }
   /**
    * @description
    */
   global class terms{
    
    public string period;
    public String termLength;
    public string percentIncrease;
    public Decimal baseValue;
    public Decimal userRate;
    Public properties properties;
    /**
    * @description
    */
    public terms(){
    
    period='';
    termLength=null;
    percentIncrease=null;
    baseValue=null;
    userRate=null;
    
  }
         
    }
    /**
    * @description
    */
  global class adjustments{
    
        public string promotionCode;
        public string type='PERCENT';
        public string discountType='';//SOC-6755 May Bijeta
        public Decimal amount;
        Public properties properties;
        /**
    * @description
    */
        public adjustments(){
    
        promotionCode=null;
        type='PERCENT';
        discountType='';//SOC-6755 May Bijeta
        amount=null;    
    }
    }
    /**
    * @description
    */
    global class lineNotes{
    
        public string type;
        public string lineType;
        
        public string notes;
        /**
        * @description
        */
        public lineNotes(){
    
        type='PERCENT';
        lineType='';
        notes='';
    }
    }
    /**
    * @description
    */
    global class deserialization
    {
    
        public string Code;
        public string Description;
        public string Status;
        /**
        * @description
        */
        Public deserialization()
    {
    
         Code='';
         Description='';
         Status='';
        }
    }
    
    }