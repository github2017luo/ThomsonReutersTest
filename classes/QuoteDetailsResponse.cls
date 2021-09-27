/*
 * This class has all service related to Digital configurations like Loading data using opportunity, add/Remove product from Cart. 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                  Description
 * 2018-08-15   Harika Sai P          DLT-11661 - Combine the Landing Page service into a single service 
 * 2018-09-21   Srikanth Kota         DLT-12127/ DLT-12510- SFDC changes for Marketing banner
 * 2018-10-04   Benjamin Her          DLT-12694 - Add digitallySignedDate field to QuoteHeader
 * 2019-02-19   Benjamin Her          DLT-15324 - Add basePrice field to QuoteLineItem
 * 2019-03-20   Navleen Kaur          DLT-15672  [Tech Story] [SLF] Automation Changes for New Mid Contract Flag
 * 2019-05-14   Bishanka Dassarma     DLT-16477 - Add CouponCode field to QuoteHeader
 * 2019-09-04   Srikanth kota         DLT-17452 - [CORP][SFDC] Straight renew Option products alongwith the core product
 * 2019-09-19   Bishanka Dassarma     DLT-17670 - [CORP] Help button (?) is missing and Product name is in all CAPS for Products for Option Products scenario
 * 2019-10-21   Bishanka Dassarma     DLT-17802 : [SFDC] Add material number in the onlinecontacts for the per-seat products
 * 2019-10-22   Benjamin Her          DLT-18017 - [FindLaw] Added PA and Geo field to 'QuoteLineItems' class
 * 2019-11-05   Sumanth Padarapaka    DLT-18303 - [FindLaw] Added contractNumber field to 'QuoteLineItems' class
 * 2019-11-13   Sumanth Padarapaka    DLT-18189 - [Findlaw] Added X1_Year_Experience_Flagl field to 'QuoteHeader' class
 * ==================================================================================================================================   
 */

Global class QuoteDetailsResponse {
    public List<GetQuoteResponseDetails> getQuoteResponseDetails = new List<GetQuoteResponseDetails>();
    //public ProcessStatus processStatus = new ProcessStatus();

    Global class Account {
        public String companyId;
        public String companyName;
        public Integer companySize;
        public String accountType;
        public String TerritoryNumber;
        public String sourceOrTargetReferenceNumber;
        public String digitalFirm;
        public Address address = new Address();
    }

    Global class GetQuoteResponseDetails {
        public QuoteHeader quoteHeader;
    }

    Global class Address {
        public String city;
        public String region;
        public String postalcode;
        public String country;
    }

    /*Global class ProcessStatus {
        public Integer statusCode;
        public String statusDescription;
        public String statusDetailMessage;
    }*/

    Global class Opportunity {
        public String opportunityUrl;
        public Decimal amount;
        public Date renewalDate;
        public String campaign_Code;
    }

    Global class QuoteHeader {
        public String quoteId;
        public String cartId;
        public String orderConfirmationContactSSD;
        public List<Account> accounts = new List<Account>();
        public List<Contact> contacts = new List<Contact>();
        public List<Opportunity> opportunities = new List<Opportunity>();
        public Boolean primaryQuoteFlag;
        public Boolean exempt;
        public String sendEmailOnBeHalfOf;//Added as part of DLT-9251
        public Boolean hasAddOns;
        public Boolean contract_Not_In_Sync;
        public String quoteType;
        public Boolean updatedOnConfigurator;
        public DateTime lastModifiedDate;
        public String aprovalStage;
        public String paymentOption;
        public String eSignEnvelopeId;
        public String eSignDocSignerId;
        public String eSignDocSignerName;
        public Decimal amount;
        public Decimal incrementalAmount;
        public List<QuoteLineItems> quoteLineItems = new List<QuoteLineItems>();
        public Integer termCurrent; // DLT-7943
        public String ContractType;//DLT-10373
        public Datetime digitallySignedDate; //DLT-12694
        public Boolean generateAVC;//DLT-13174
        public String couponCode;//DLT-16477
		public Boolean oneYearExperienceFlag;//DLT-18189
    }

    Global class Material {
        public String materialId;
        public String materialNumber;
        public String materialDescription;
        public String internalDescription;
        public String classificationValue;
        public Integer classificationValueSortOrder;
        public String subscriptionNumber;
        public String jurisdiction;
        public String productPlanId;
        public String productGroup;
        public Integer productGroupSortOrder;
        public String additionalInternalDescription;
    }

    Global class QuoteLineItems {
        public String lineId;
        public String ProductId;
        public String optionProductId; // DLT-17452
        public Boolean isIndigo = false;
        public List<Material> material;
        public String productName;
        public String optionProductName; // DLT-17452
        public String optionProductDescription;// DLT-17670
        public String digitalDescription;
        public String status;
        public String format;
        public String billingFrequency;
        public String shortDescription;
        public String longDescription;
        public String pricingModel;
        public Decimal firmSize; 
        public Boolean isAddOn;
        public Decimal price;
        public Decimal autoRenewalTerm;
        public String subscriptionNumber;
        public Date startDate;
        public Decimal attorney;
        public String contractTerm;
        public String renewalAdjustment;
        public String YearOnYearAdjustment;
        public Integer bandNumber;
        public String productFamily; // Added for DLT-12510
        public Decimal basePrice; //Added for DLT-15324
        
        //*** START :: Added by Rajan :: DLT-11055 - No tool tip is presented when trying reduce the number of users
        public Decimal OriginalQuantity;
        //*** END :: Added by Rajan :: DLT-11055 - No tool tip is presented when trying reduce the number of users
        
        //*** START :: Added by Rajan :: DLT-9839 - Reassign users link on Confirmation page (up-sell only)
            public List<OnlineContacts> onlineContacts = new List<OnlineContacts>();
        //*** END :: Added by Rajan :: DLT-9839 - Reassign users link on Confirmation page (up-sell only)
        public boolean isPublicAddOn;//DLT-15252
        public String PA;
        public String Geo;
	public Decimal contractNumber;
    }

    Global class Contact {
        public String contactId;
        public String firstName;
        public String lastname;
        public String name;
        public String email;
        public String Phone;
        //*** START :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
        public Boolean HardBounce;
        //*** END :: Added by Rajan :: DLT-8973 - SAP Contact ID from Analytics for Quote Generation
    }
    
    //*** START :: Added by Rajan :: DLT-9839 - Reassign users link on Confirmation page (up-sell only)
    public class OnlineContacts{
        public String contactSFId;
        public String contactExternalId;
        public String firstName;
        public String lastname;
        public String email;
        public String materialNumber;
    }
    //*** END :: Added by Rajan :: DLT-9839 - Reassign users link on Confirmation page (up-sell only)
}