public class CreateEntitlementRequest {

	public class OnlineContact {
		public String contactNumber;
		public Address address;
		public Account account;
		public String primaryRequester;
		public String invited;
		public List<ExtensibleAttributes> extensibleAttributes;
		public List<Entitlements> entitlements;
	}

	public class Account {
		public String accountNumber;
	}

	public class Address {
		public String firstName;
		public String lastName;
		public String phone;
		public String emailAddress;
		public String country;
	}

	public String actionCode;
	public Boolean isTrial;
	public List<OnlineContact> onlineContact;
	public ESIHeader ESIHeader;

	public class ExtensibleAttributes {
		public String key;
		public String value;
	}

	public class Entitlements {
		public String templateId;
		public String templateType;
		public String appUserGuid;
		public String accessStartDate;
		public String accessEndDate;
		public List<ExtensibleAttributes> extensibleAttributes;
	}

	public class ESIHeader {
		public String applicationId;
		public String transactionId;
		public String companyId;
		public String configGroup;
	}

	
	public static CreateEntitlementRequest parse(String json) {
		return (CreateEntitlementRequest) System.JSON.deserialize(json, CreateEntitlementRequest.class);
	}
}