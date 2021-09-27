public class APTS_CreateSSDJSON2ApexResponse {
    public ESIHeader ESIHeader;
    public String customerNumber;
    public String prevAcct;
    public List<PartnerFunction> partnerFunction;

    public class PartnerFunction {
        public String salesOrg;
        public String distChannel;
        public String division;
        public String functionId;
        public String counter;
        public String businessPartner;
        public Object vendorCreditorNumber;
        public String contactNumber;
        public String personnalNumber;
        public Object description;
        public Object defaultPartner;
    }

    public class ESIHeader {
        public String applicationId;
    }

    
    public static APTS_CreateSSDJSON2ApexResponse parse(String json) {
        return (APTS_CreateSSDJSON2ApexResponse) System.JSON.deserialize(json, APTS_CreateSSDJSON2ApexResponse.class);
    }
}