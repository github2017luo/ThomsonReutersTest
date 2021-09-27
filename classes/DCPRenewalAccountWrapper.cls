/********************************************************************************
Class Name : DCPRenewalAccountWrapper
@description : Request Structure for Account Array
********************************************************************************
CHANGE HISTORY
===============================================================================
Date                         Developer              Description
23-04-2021                  Benjamin Her            Initial Creation

*/ 
public class DCPRenewalAccountWrapper{
    public string accountId;
    public string ssdId;
    public string accountNumber;
    public string accountName;
    public Address accountAddress;


    /**
    @description Constructor
    */
    public DCPRenewalAccountWrapper(){
        accountAddress = new Address();
    }
    /**
    * @description Class for the Address details components.
    */
    public class Address{
        public String addressStreet;
        public String addressCity;
        public String addressState;
        public String addressPostalCode;
        public String addressCounty;
        public String addressCountry;
        public string addressPOBox;
    }

    
}