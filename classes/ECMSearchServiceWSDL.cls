//Generated by wsdl2apex

public class ECMSearchServiceWSDL {
    public class Addresses {
        public ECMSearchServiceWSDL.PartyAddress[] PartyAddress;
        private String[] PartyAddress_type_info = new String[]{'PartyAddress','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyAddress'};
    }
    public class Hierarchies {
        public ECMSearchServiceWSDL.Hierarchy[] Hierarchy;
        private String[] Hierarchy_type_info = new String[]{'Hierarchy','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'Hierarchy'};
    }
    public class PartyAddressIdentifier {
        public String PartyAddressIdentifierType;
        public String PartyAddressIdentifierValue;
        public String PartyAddressIdentifierCategory;
        private String[] PartyAddressIdentifierType_type_info = new String[]{'PartyAddressIdentifierType','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyAddressIdentifierValue_type_info = new String[]{'PartyAddressIdentifierValue','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyAddressIdentifierCategory_type_info = new String[]{'PartyAddressIdentifierCategory','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyAddressIdentifierType','PartyAddressIdentifierValue','PartyAddressIdentifierCategory'};
    }
    public class SearchPartyResponse {
        public ECMSearchServiceWSDL.SearchResults SearchPartyResponseResult;
        private String[] SearchPartyResponseResult_type_info = new String[]{'SearchPartyResponseResult','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SearchPartyResponseResult'};
    }
    public class GetRequest {
        public ECMSearchServiceWSDL.EAIHeader EAIHeader;
        public String RowId;
        public String SourceSystemCode;
        public String SourceSystemId;
        public String Username;
        public String Password;
        public String AuditToken;
        public String Header;
        private String[] EAIHeader_type_info = new String[]{'EAIHeader','urn:IcglV1Interface',null,'0','1','true'};
        private String[] RowId_type_info = new String[]{'RowId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SourceSystemCode_type_info = new String[]{'SourceSystemCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SourceSystemId_type_info = new String[]{'SourceSystemId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Username_type_info = new String[]{'Username','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Password_type_info = new String[]{'Password','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AuditToken_type_info = new String[]{'AuditToken','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Header_type_info = new String[]{'Header','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'EAIHeader','RowId','SourceSystemCode','SourceSystemId','Username','Password','AuditToken','Header'};
    }
    public class AddressSourceSystem {
        public String AddressSourceSystemId;
        public String AddressSourceSystemCode;
        private String[] AddressSourceSystemId_type_info = new String[]{'AddressSourceSystemId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressSourceSystemCode_type_info = new String[]{'AddressSourceSystemCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'AddressSourceSystemId','AddressSourceSystemCode'};
    }
    public class AddressIdentifiers {
        public ECMSearchServiceWSDL.PartyAddressIdentifier[] PartyAddressIdentifier;
        private String[] PartyAddressIdentifier_type_info = new String[]{'PartyAddressIdentifier','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyAddressIdentifier'};
    }
    public class PartyAddress {
        public String AddressRowId;
        public String AddressType;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String City;
        public String ZipPostalCode;
        public String County;
        public String State;
        public String Country;
        public ECMSearchServiceWSDL.AddressIdentifiers AddressIdentifiers;
        public String TaxVATExemptionIndicator;
        public ECMSearchServiceWSDL.SICCodes SICCodes;
        public ECMSearchServiceWSDL.PartyAttributes PartyAttributes;
        public String PrimaryAddressIndicator;
        public String PartyLegalStatus;
        public ECMSearchServiceWSDL.AddressSourceSystems AddressSourceSystems;
        private String[] AddressRowId_type_info = new String[]{'AddressRowId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressType_type_info = new String[]{'AddressType','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressLine1_type_info = new String[]{'AddressLine1','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressLine2_type_info = new String[]{'AddressLine2','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressLine3_type_info = new String[]{'AddressLine3','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressLine4_type_info = new String[]{'AddressLine4','urn:IcglV1Interface',null,'1','1','false'};
        private String[] City_type_info = new String[]{'City','urn:IcglV1Interface',null,'1','1','false'};
        private String[] ZipPostalCode_type_info = new String[]{'ZipPostalCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] County_type_info = new String[]{'County','urn:IcglV1Interface',null,'1','1','false'};
        private String[] State_type_info = new String[]{'State','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Country_type_info = new String[]{'Country','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressIdentifiers_type_info = new String[]{'AddressIdentifiers','urn:IcglV1Interface',null,'1','1','false'};
        private String[] TaxVATExemptionIndicator_type_info = new String[]{'TaxVATExemptionIndicator','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SICCodes_type_info = new String[]{'SICCodes','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyAttributes_type_info = new String[]{'PartyAttributes','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PrimaryAddressIndicator_type_info = new String[]{'PrimaryAddressIndicator','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyLegalStatus_type_info = new String[]{'PartyLegalStatus','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AddressSourceSystems_type_info = new String[]{'AddressSourceSystems','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'AddressRowId','AddressType','AddressLine1','AddressLine2','AddressLine3','AddressLine4','City','ZipPostalCode','County','State','Country','AddressIdentifiers','TaxVATExemptionIndicator','SICCodes','PartyAttributes','PrimaryAddressIndicator','PartyLegalStatus','AddressSourceSystems'};
    }
    public class PartyAttribute {
        public String TotalEmployees;
        public String TotalEmployeesEstimatedIndicator;
        public String AnnualSalesValue;
        public String AnnualSalesCurrency;
        public String AnnualSalesEstimatedIndicator;
        public String EmployeesHere;
        public String EmployeesHereEstimatedIndicator;
        public String HedgeFundAssets;
        private String[] TotalEmployees_type_info = new String[]{'TotalEmployees','urn:IcglV1Interface',null,'1','1','false'};
        private String[] TotalEmployeesEstimatedIndicator_type_info = new String[]{'TotalEmployeesEstimatedIndicator','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AnnualSalesValue_type_info = new String[]{'AnnualSalesValue','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AnnualSalesCurrency_type_info = new String[]{'AnnualSalesCurrency','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AnnualSalesEstimatedIndicator_type_info = new String[]{'AnnualSalesEstimatedIndicator','urn:IcglV1Interface',null,'1','1','false'};
        private String[] EmployeesHere_type_info = new String[]{'EmployeesHere','urn:IcglV1Interface',null,'1','1','false'};
        private String[] EmployeesHereEstimatedIndicator_type_info = new String[]{'EmployeesHereEstimatedIndicator','urn:IcglV1Interface',null,'1','1','false'};
        private String[] HedgeFundAssets_type_info = new String[]{'HedgeFundAssets','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'TotalEmployees','TotalEmployeesEstimatedIndicator','AnnualSalesValue','AnnualSalesCurrency','AnnualSalesEstimatedIndicator','EmployeesHere','EmployeesHereEstimatedIndicator','HedgeFundAssets'};
    }
    public class PartyIdentifiers {
        public ECMSearchServiceWSDL.PartyIdentifier[] PartyIdentifier;
        private String[] PartyIdentifier_type_info = new String[]{'PartyIdentifier','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyIdentifier'};
    }
    public class SearchParty {
        public ECMSearchServiceWSDL.SearchRequest SearchRequest;
        private String[] SearchRequest_type_info = new String[]{'SearchRequest','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SearchRequest'};
    }
    public class EAIHeader {
        public String applicationId;
        public String transactionId;
        public String messageId;
        public String messageHistory;
        public String tracingId;
        public DateTime timeStamp;
        public String instanceId;
        public Integer timeToLive;
        public String payloadVersion;
        private String[] applicationId_type_info = new String[]{'applicationId','urn:IcglV1Interface',null,'0','1','false'};
        private String[] transactionId_type_info = new String[]{'transactionId','urn:IcglV1Interface',null,'0','1','false'};
        private String[] messageId_type_info = new String[]{'messageId','urn:IcglV1Interface',null,'0','1','false'};
        private String[] messageHistory_type_info = new String[]{'messageHistory','urn:IcglV1Interface',null,'0','1','false'};
        private String[] tracingId_type_info = new String[]{'tracingId','urn:IcglV1Interface',null,'0','1','true'};
        private String[] timeStamp_type_info = new String[]{'timeStamp','urn:IcglV1Interface',null,'0','1','false'};
        private String[] instanceId_type_info = new String[]{'instanceId','urn:IcglV1Interface',null,'0','1','true'};
        private String[] timeToLive_type_info = new String[]{'timeToLive','urn:IcglV1Interface',null,'0','1','true'};
        private String[] payloadVersion_type_info = new String[]{'payloadVersion','urn:IcglV1Interface',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'applicationId','transactionId','messageId','messageHistory','tracingId','timeStamp','instanceId','timeToLive','payloadVersion'};
    }
    public class Hierarchy {
        public String HierarchyType;
        public String RelationshipType;
        public Integer ParentPartyId;
        private String[] HierarchyType_type_info = new String[]{'HierarchyType','urn:IcglV1Interface',null,'1','1','false'};
        private String[] RelationshipType_type_info = new String[]{'RelationshipType','urn:IcglV1Interface',null,'1','1','false'};
        private String[] ParentPartyId_type_info = new String[]{'ParentPartyId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'HierarchyType','RelationshipType','ParentPartyId'};
    }
    public class GetResults {
        public ECMSearchServiceWSDL.Party Party;
        public String AuditToken;
        public String Header;
        public String StatusCode;
        public String StatusDescription;
        private String[] Party_type_info = new String[]{'Party','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AuditToken_type_info = new String[]{'AuditToken','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Header_type_info = new String[]{'Header','urn:IcglV1Interface',null,'1','1','false'};
        private String[] StatusCode_type_info = new String[]{'StatusCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] StatusDescription_type_info = new String[]{'StatusDescription','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'Party','AuditToken','Header','StatusCode','StatusDescription'};
    }
    public class SICCode {
        public String SICCode;
        public Integer SICNumber;
        public String SICValue;
        private String[] SICCode_type_info = new String[]{'SICCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SICNumber_type_info = new String[]{'SICNumber','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SICValue_type_info = new String[]{'SICValue','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SICCode','SICNumber','SICValue'};
    }
    public class SICCodes {
        public ECMSearchServiceWSDL.SICCode[] SICCode;
        private String[] SICCode_type_info = new String[]{'SICCode','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SICCode'};
    }
    public class GetPartyResponse {
        public ECMSearchServiceWSDL.GetResults GetPartyResponseResult;
        private String[] GetPartyResponseResult_type_info = new String[]{'GetPartyResponseResult','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'GetPartyResponseResult'};
    }
    public class SearchRequest {
        public ECMSearchServiceWSDL.EAIHeader EAIHeader;
        public String Firstname;
        public String Middlename;
        public String Lastname;
        public String Fullname;
        public String Address;
        public String City;
        public String State;
        public String Country;
        public String Zipcode;
        public Integer PageSize;
        public Integer PageNumber;
        public String Username;
        public String Password;
        public String AuditToken;
        public String Header;
        private String[] EAIHeader_type_info = new String[]{'EAIHeader','urn:IcglV1Interface',null,'0','1','true'};
        private String[] Firstname_type_info = new String[]{'Firstname','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Middlename_type_info = new String[]{'Middlename','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Lastname_type_info = new String[]{'Lastname','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Fullname_type_info = new String[]{'Fullname','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Address_type_info = new String[]{'Address','urn:IcglV1Interface',null,'1','1','false'};
        private String[] City_type_info = new String[]{'City','urn:IcglV1Interface',null,'1','1','false'};
        private String[] State_type_info = new String[]{'State','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Country_type_info = new String[]{'Country','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Zipcode_type_info = new String[]{'Zipcode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PageSize_type_info = new String[]{'PageSize','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PageNumber_type_info = new String[]{'PageNumber','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Username_type_info = new String[]{'Username','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Password_type_info = new String[]{'Password','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AuditToken_type_info = new String[]{'AuditToken','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Header_type_info = new String[]{'Header','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'EAIHeader','Firstname','Middlename','Lastname','Fullname','Address','City','State','Country','Zipcode','PageSize','PageNumber','Username','Password','AuditToken','Header'};
    }
    public class AddressSourceSystems {
        public ECMSearchServiceWSDL.AddressSourceSystem[] AddressSourceSystem;
        private String[] AddressSourceSystem_type_info = new String[]{'AddressSourceSystem','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'AddressSourceSystem'};
    }
    public class Party {
        public String PartyRowId;
        public ECMSearchServiceWSDL.SourceSystems SourceSystems;
        public String PartyClass;
        public String PartyType;
        public String PrefixTitle;
        public String FullName;
        public String AdditionalName1;
        public String AdditionalName2;
        public String FirstName;
        public String MiddleName;
        public String LastName;
        public String Suffix;
        public String BlackListedPartyIndicator;
        public String PartyStatus;
        public String LocalLanguage;
        public String LocalFullName;
        public String LocalAdditionalName1;
        public String LocalAdditionalName2;
        public String LocalFirstName;
        public String LocalMiddleName;
        public String LocalLastName;
        public String MDGStatus;
        public ECMSearchServiceWSDL.Addresses Addresses;
        public ECMSearchServiceWSDL.PartyIdentifiers PartyIdentifiers;
        public String PrimaryPhoneNumber;
        public String PrimaryEmail;
        public ECMSearchServiceWSDL.SBUs SBUs;
        public ECMSearchServiceWSDL.Hierarchies Hierarchies;
        public String LastUpdateTimeStamp;
        public String LastUpdateUser;
        public Integer MatchScore;
        private String[] PartyRowId_type_info = new String[]{'PartyRowId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SourceSystems_type_info = new String[]{'SourceSystems','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyClass_type_info = new String[]{'PartyClass','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyType_type_info = new String[]{'PartyType','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PrefixTitle_type_info = new String[]{'PrefixTitle','urn:IcglV1Interface',null,'1','1','false'};
        private String[] FullName_type_info = new String[]{'FullName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AdditionalName1_type_info = new String[]{'AdditionalName1','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AdditionalName2_type_info = new String[]{'AdditionalName2','urn:IcglV1Interface',null,'1','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] MiddleName_type_info = new String[]{'MiddleName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LastName_type_info = new String[]{'LastName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Suffix_type_info = new String[]{'Suffix','urn:IcglV1Interface',null,'1','1','false'};
        private String[] BlackListedPartyIndicator_type_info = new String[]{'BlackListedPartyIndicator','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyStatus_type_info = new String[]{'PartyStatus','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalLanguage_type_info = new String[]{'LocalLanguage','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalFullName_type_info = new String[]{'LocalFullName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalAdditionalName1_type_info = new String[]{'LocalAdditionalName1','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalAdditionalName2_type_info = new String[]{'LocalAdditionalName2','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalFirstName_type_info = new String[]{'LocalFirstName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalMiddleName_type_info = new String[]{'LocalMiddleName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LocalLastName_type_info = new String[]{'LocalLastName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] MDGStatus_type_info = new String[]{'MDGStatus','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Addresses_type_info = new String[]{'Addresses','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyIdentifiers_type_info = new String[]{'PartyIdentifiers','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PrimaryPhoneNumber_type_info = new String[]{'PrimaryPhoneNumber','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PrimaryEmail_type_info = new String[]{'PrimaryEmail','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SBUs_type_info = new String[]{'SBUs','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Hierarchies_type_info = new String[]{'Hierarchies','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LastUpdateTimeStamp_type_info = new String[]{'LastUpdateTimeStamp','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LastUpdateUser_type_info = new String[]{'LastUpdateUser','urn:IcglV1Interface',null,'1','1','false'};
        private String[] MatchScore_type_info = new String[]{'MatchScore','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyRowId','SourceSystems','PartyClass','PartyType','PrefixTitle','FullName','AdditionalName1','AdditionalName2','FirstName','MiddleName','LastName','Suffix','BlackListedPartyIndicator','PartyStatus','LocalLanguage','LocalFullName','LocalAdditionalName1','LocalAdditionalName2','LocalFirstName','LocalMiddleName','LocalLastName','MDGStatus','Addresses','PartyIdentifiers','PrimaryPhoneNumber','PrimaryEmail','SBUs','Hierarchies','LastUpdateTimeStamp','LastUpdateUser','MatchScore'};
    }
    public class SBUs {
        public ECMSearchServiceWSDL.SBU[] SBU;
        private String[] SBU_type_info = new String[]{'SBU','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SBU'};
    }
    public class Parties {
        public ECMSearchServiceWSDL.Party[] Party;
        private String[] Party_type_info = new String[]{'Party','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'Party'};
    }
    public class PartyIdentifier {
        public String PartyIdentifierType;
        public String PartyIdentifierValue;
        public String PartyIdentifierCategory;
        private String[] PartyIdentifierType_type_info = new String[]{'PartyIdentifierType','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyIdentifierValue_type_info = new String[]{'PartyIdentifierValue','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PartyIdentifierCategory_type_info = new String[]{'PartyIdentifierCategory','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyIdentifierType','PartyIdentifierValue','PartyIdentifierCategory'};
    }
    public class PartyAttributes {
        public ECMSearchServiceWSDL.PartyAttribute[] PartyAttribute;
        private String[] PartyAttribute_type_info = new String[]{'PartyAttribute','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'PartyAttribute'};
    }
    public class SBU {
        public String SBUName;
        public String SubSBUName;
        private String[] SBUName_type_info = new String[]{'SBUName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SubSBUName_type_info = new String[]{'SubSBUName','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SBUName','SubSBUName'};
    }
    public class SourceSystems {
        public ECMSearchServiceWSDL.SourceSystem[] SourceSystem;
        private String[] SourceSystem_type_info = new String[]{'SourceSystem','urn:IcglV1Interface',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SourceSystem'};
    }
    public class SearchResults {
        public ECMSearchServiceWSDL.Parties Parties;
        public Integer PageNumber;
        public Integer PageSize;
        public Boolean LastPage;
        public String AuditToken;
        public String Header;
        public String StatusCode;
        public String StatusDescription;
        private String[] Parties_type_info = new String[]{'Parties','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PageNumber_type_info = new String[]{'PageNumber','urn:IcglV1Interface',null,'1','1','false'};
        private String[] PageSize_type_info = new String[]{'PageSize','urn:IcglV1Interface',null,'1','1','false'};
        private String[] LastPage_type_info = new String[]{'LastPage','urn:IcglV1Interface',null,'1','1','false'};
        private String[] AuditToken_type_info = new String[]{'AuditToken','urn:IcglV1Interface',null,'1','1','false'};
        private String[] Header_type_info = new String[]{'Header','urn:IcglV1Interface',null,'1','1','false'};
        private String[] StatusCode_type_info = new String[]{'StatusCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] StatusDescription_type_info = new String[]{'StatusDescription','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'Parties','PageNumber','PageSize','LastPage','AuditToken','Header','StatusCode','StatusDescription'};
    }
    public class GetParty {
        public ECMSearchServiceWSDL.GetRequest GetRequest;
        private String[] GetRequest_type_info = new String[]{'GetRequest','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'GetRequest'};
    }
    public class SourceSystem {
        public String SourceSystemId;
        public String SourceSystemCode;
        private String[] SourceSystemId_type_info = new String[]{'SourceSystemId','urn:IcglV1Interface',null,'1','1','false'};
        private String[] SourceSystemCode_type_info = new String[]{'SourceSystemCode','urn:IcglV1Interface',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:IcglV1Interface','true','false'};
        private String[] field_order_type_info = new String[]{'SourceSystemId','SourceSystemCode'};
    }
    public class IcglV1PortTypePort {
        public String endpoint_x = 'http://inkaban3ua-eai05:8000/osb/ECMSearchService/ProxyServ/ECMSearchService_SOAP_PS';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:IcglV1Interface', 'ECMSearchServiceWSDL'};
        public ECMSearchServiceWSDL.SearchResults SearchParty(ECMSearchServiceWSDL.EAIHeader EAIHeader,String Firstname,String Middlename,String Lastname,String Fullname,String Address,String City,String State,String Country,String Zipcode,Integer PageSize,Integer PageNumber,String Username,String Password,String AuditToken,String Header) {
            ECMSearchServiceWSDL.SearchRequest request_x = new ECMSearchServiceWSDL.SearchRequest();
            request_x.EAIHeader = EAIHeader;
            request_x.Firstname = Firstname;
            request_x.Middlename = Middlename;
            request_x.Lastname = Lastname;
            request_x.Fullname = Fullname;
            request_x.Address = Address;
            request_x.City = City;
            request_x.State = State;
            request_x.Country = Country;
            request_x.Zipcode = Zipcode;
            request_x.PageSize = PageSize;
            request_x.PageNumber = PageNumber;
            request_x.Username = Username;
            request_x.Password = Password;
            request_x.AuditToken = AuditToken;
            request_x.Header = Header;
            ECMSearchServiceWSDL.SearchResults response_x;
            Map<String, ECMSearchServiceWSDL.SearchResults> response_map_x = new Map<String, ECMSearchServiceWSDL.SearchResults>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:IcglV1Interface',
              'SearchRequest',
              'urn:IcglV1Interface',
              'SearchResults',
              'ECMSearchServiceWSDL.SearchResults'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public ECMSearchServiceWSDL.GetResults GetParty(ECMSearchServiceWSDL.EAIHeader EAIHeader,String RowId,String SourceSystemCode,String SourceSystemId,String Username,String Password,String AuditToken,String Header) {
            ECMSearchServiceWSDL.GetRequest request_x = new ECMSearchServiceWSDL.GetRequest();
            request_x.EAIHeader = EAIHeader;
            request_x.RowId = RowId;
            request_x.SourceSystemCode = SourceSystemCode;
            request_x.SourceSystemId = SourceSystemId;
            request_x.Username = Username;
            request_x.Password = Password;
            request_x.AuditToken = AuditToken;
            request_x.Header = Header;
            ECMSearchServiceWSDL.GetResults response_x;
            Map<String, ECMSearchServiceWSDL.GetResults> response_map_x = new Map<String, ECMSearchServiceWSDL.GetResults>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:IcglV1Interface',
              'GetRequest',
              'urn:IcglV1Interface',
              'GetResults',
              'ECMSearchServiceWSDL.GetResults'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}