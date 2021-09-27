/*============================================================================================
    Name                : LapsedAccountResponse
    Description         : This class is developed as part of CXD-ODT project and serves as a wrapper class for lapsed account service response. 
    Created Date        : 11/6/2018 
    Author              : TCS CXD ODT team
 
==============================================================================================*/
public class LapsedAccountResponse {

    public LapsedAccountResponse(){}

    public class Account {
        public String accountNumber;
    }

    public class PriceRates {
        public String priceRateType;
        public String priceRate;
    }

    public class BandRange {
        public Integer userCount;
    }

    public class Classifications {
        public String classificationName;
        public String classificationType;
    }

    public List<StatusDetails> statusDetails;
    public List<Subscription> subscription;
    //public List<SubscriptionLines> subscriptionLines;

    public class StatusDetails {
        public String statusCode;
        public String statusDescription;
    }

    public class SubscriptionLines {
        public String subscriptionLineNumber;
        public String practiceAreaCode;
        public String practiceAreaDescription;
        public String locationCode;
        public String locationDescription;
        public String dealId;
        public String lapseDate;
        public String lapsedReasonCode;
        public String lapsedReasonDescription;
        public String contentGroupNumber;
        public String titleId;
        public Boolean autoRenewFlag;
        public String firstYearDiscount;
        public Integer netAmount;
        public List<PriceRates> priceRates;
    }

    public class Adjustments {
        public String discountCode;
        public String discountAmount;
        public String discountPercent;
        public String discountReason;
    }

    public class Material {
        public String materialNumber;
        public String materialDescription;
    }

    public class Subscription {
        public String subscriptionNumber;
        public String subscriptionType;
        public String subscriptionStatus;
        public Material material;
        public List<Adjustments> adjustments;
        public List<Account> account;
        public List<SubscriptionLines> subscriptionLines;
        public BandRange bandRange;
        public String startDate;
        public String endDate;
        public List<Classifications> classifications;
        public String storageKey;
        public List<String> levelCode;
        public List<String> levelValue;
    }

    /*
    public static LapsedAccountResponse parse(String json) {
        return (LapsedAccountResponse) System.JSON.deserialize(json, LapsedAccountResponse.class);
    }*/
}