/******************************************************************************************
* Class         : OmniCallToOLCByEmailWrapper
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
 
public  without sharing class OmniCallToOLCByEmailRequestWrapper {
    public ESIHeader ESIHeader;
    public Account account;
    public String emailAddress;
    public OnlineContactFilter OnlineContactFilter;

    /**
     * @description Account
     */
    public class Account {
        public String accountNumber;
        
        /**
        * @description Account
        * @param accountNumber
        */
        public Account(String accountNumber){
            this.accountNumber = accountNumber;
        }
    }

    /*
    public ESIHeader esiHeader;
    public Account account;
    public String emailAddress;
    public OnlineContactFilter onlineContactFilter;
    */

    /**
     * @description ESIHeader
     */
    public class ESIHeader {
        public String applicationId;
        /**
        * @description ESIHeader
        * @param applicationId
        */
        public ESIHeader(String applicationId){
            this.applicationId = applicationId;
        }
    }

    /**
     * @description OnlineContactFilter
     */
    public class OnlineContactFilter {
        public String checkPrism;
        public String checkEntitlementDetails;
        /**
        * @description OnlineContactFilter
        * @param checkPrism
        * @param checkEntitlementDetails
        */
        public OnlineContactFilter(String checkPrism, String checkEntitlementDetails){
            this.checkPrism = checkPrism;
            this.checkEntitlementDetails = checkEntitlementDetails;
        }
    }

     /**
     * @description parse
     * @param json
     * @return OmniCallToOLCByEmailRequestWrapper
     */
    public static OmniCallToOLCByEmailRequestWrapper parse(String json) {
        return (OmniCallToOLCByEmailRequestWrapper) System.JSON.deserialize(json, OmniCallToOLCByEmailRequestWrapper.class);
    }
}