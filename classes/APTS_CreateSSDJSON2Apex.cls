public class APTS_CreateSSDJSON2Apex {

    public context context{get;set;}
        public String confirmUrl{get;set;}
        public String extSapAcct{get;set;}
        public customer customer{get;set;}
        public String externalAccountId{get;set;}
        public list<extensibleAttributes> extensibleAttributes{get;set;}
        public ESIHeader ESIHeader{get;set;}
        
    //public APTS_CreateSSDJSON2Apex (){}
    public class sourceOrTargetReference{
        public String referenceID{get;set;}
        public list<extensibleAttributes> extensibleAttributes{get;set;}
        public String sourceOrTargetSystemName{get;set;}
    }
    public class extensibleAttributes{
        
        public String key{get;set;}
        public String value{get;set;}
        
    }
    public class ESIHeader{
        public String postBackURL{get;set;}
        public String timeStamp{get;set;}
        public String instanceId{get;set;}
        public String tracingId{get;set;}
        public String companyId{get;set;}
        public String messageHistory{get;set;}
        public String configGroup{get;set;}
        public String messageId{get;set;}
        public String payloadVersion{get;set;}
        public String transactionId{get;set;}
        public list<extensibleAttributes> extensibleAttributes{get;set;}
        public String applicationId{get;set;}
    }
    public class customer{
        public String action{get;set;}
        public String currency_x{get;set;}
        public String language{get;set;}
        public String legalStatus{get;set;}
        public list<extensibleAttributes> extensibleAttributes{get;set;}
        public String altKN{get;set;}
        public list<sourceOrTargetReference> sourceOrTargetReference{get;set;}
        public String salesOrg{get;set;}
        public list<address> address_x{get;set;}
        public String distributionChannel{get;set;}
        public Boolean isActive{get;set;}
        public String division{get;set;}
        public Boolean isPrimary{get;set;}
        public String externalAccountId{get;set;}
        public String industryCode{get;set;}
        public String accountCustomerAddressID{get;set;}
        public String parentAccountNumber{get;set;}
        public String relationshipModel{get;set;}
        public String accountType{get;set;}
        public String merchantCategoryClassificationCode{get;set;}
        public String companyName{get;set;}
        public String segment{get;set;}
        public String companyId{get;set;}
        public String applyDate{get;set;}
        public String accountNumber{get;set;}
        public String accountStatus{get;set;}
        public String hierarchyType{get;set;}
        public String KNOwned{get;set;}
        public String vatCode{get;set;}
        public String accountGroup{get;set;}
        public String partnerType{get;set;}
        public String accountClass{get;set;}
        public list<complianceJobRole> complianceJobRole{get;set;}
        public String primaryBillingNumber{get;set;}
        public String jurisdictionCode{get;set;}
        public String legacyThomsonCustomerId{get;set;}
        public String taxCodeType{get;set;}
        public String customerJourney{get;set;}
        public String lastUpdatedDate{get;set;}
        public String website{get;set;}
        public String taxCode1{get;set;}
        public String taxCode2{get;set;}
        
        public customer(){
        address_x = new List<Address>();
        }
    }
    public class context{
        public String allowAdminEmails{get;set;}
        public String requestor{get;set;}
        public String userId{get;set;}
        public String accountType{get;set;}
        public list<extensibleAttributes> extensibleAttributes{get;set;}
        public String internalUserId{get;set;}
        public String emailAddress{get;set;}
        public Boolean internalUser{get;set;}
        public String fax{get;set;}
        public String adminName{get;set;}
        public String extension{get;set;}
        public String adminEmail{get;set;}
        public String phone{get;set;}
        public String alternateEmailAddress{get;set;}
        public String middleName{get;set;}
        public String lastName{get;set;}
        public String firstName{get;set;}
    }
    public class complianceJobRole{
        public String Id{get;set;}
        public String description{get;set;}
    }
    public class address{
        public String street1{get;set;}
        public String city{get;set;}
        public String street3{get;set;}
        public String district{get;set;}
        public String street2{get;set;}
        public String region{get;set;}
        public String title{get;set;}
        public String county{get;set;}
        public list<extensibleAttributes> extensibleAttributes{get;set;}
        public String postalcode{get;set;}
        public String emailAddress{get;set;}
        public String country{get;set;}
        public String fax{get;set;}
        public String poBox{get;set;}
        public String extension{get;set;}
        public String alternateEmailAddress{get;set;}
        public String phone{get;set;}
        public String building{get;set;}
        public String middleName{get;set;}
        public String floor{get;set;}
        public String lastName{get;set;}
        public String room{get;set;}
        public String firstName{get;set;}
    }

}