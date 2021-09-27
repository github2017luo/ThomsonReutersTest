/*
Covered in testResponse() of CreateSSDCustomerFromBOOMI_Test
*/
public class APTS_CreateSSDJSON2ApexResponseBOOMI {
    
    public List<StatusDetails> StatusDetails;
    public String customerNumber;
    public String prevAcct;
    public BOOMIHeader BOOMIHeader;
    

    public class BOOMIHeader {
        public String applicationId;
    }
    public class StatusDetails {
        public String statusCode{get;set;}
        public String statusDescription{get;set;}
        public String statusMessage{get;set;}
    }
    public static APTS_CreateSSDJSON2ApexResponseBOOMI parse(String json) {
        return (APTS_CreateSSDJSON2ApexResponseBOOMI) System.JSON.deserialize(json, APTS_CreateSSDJSON2ApexResponseBOOMI.class);
    }
}