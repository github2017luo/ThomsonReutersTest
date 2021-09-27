/**
     * @description OmniCallToOLCByEmailResponseWrapper
*/
public class OmniCallToOLCByEmailResponseWrapper {

    @AuraEnabled public ESIHeader esiHeader;
    @AuraEnabled public List<OnlineContact> onlineContact;
    /**
     * @description OnlineContact 
     */
    public class OnlineContact {
        @AuraEnabled public String contactNumber;
        @AuraEnabled public Address address;
        @AuraEnabled public Account account;
        @AuraEnabled public String sourceId;
        @AuraEnabled public String endDate;
        @AuraEnabled public List<OmniOLCEntitlementsWrapper.Entitlements> entitlements;
        @AuraEnabled public String onlineContactType;
        @AuraEnabled public String onlineContactTypeDescription;
        @AuraEnabled public Boolean allowContactEmails;
    }

    /**
     * @description Account 
     */
    public class Account {
        @AuraEnabled public String accountNumber;
        @AuraEnabled public String companyId;
    }
   

    /**
     * @description Address 
     */
    public class Address {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String emailAddress;
    }

     /**
     * @description ESIHeader
     */
    public class ESIHeader {
        @AuraEnabled public String applicationId;
    }

     /**
     * @description parse
     * @param json
     * @return OmniCallToOLCByEmailResponseWrapper
     */
    public static OmniCallToOLCByEmailResponseWrapper parse(String json) {
        return (OmniCallToOLCByEmailResponseWrapper) System.JSON.deserialize(json, OmniCallToOLCByEmailResponseWrapper.class);
    }
}