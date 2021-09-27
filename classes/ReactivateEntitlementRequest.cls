public class ReactivateEntitlementRequest {

	public class Account {
		public String accountNumber;
	}

	public class Subscriptions {
		public String offerId;
		public String dataOwner;
		public String offerChannel;
		public String trialAdjEndTimestamp;
	}

	public class OnlineContacts {
		public String contactNumber;
		public Account account;
		public String sourceId;
		public Entitlements entitlements;
	}

	public ESIHeader ESIHeader;
	public List<OnlineContacts> onlineContacts;

	public class Entitlements {
		public String templateId;
		public String templateType;
		public Subscriptions subscriptions;
	}

	public class ESIHeader {
		public String applicationId;
		public String companyId;
		public String transactionId;
	}

	
	public static ReactivateEntitlementRequest parse(String json) {
		return (ReactivateEntitlementRequest) System.JSON.deserialize(json, ReactivateEntitlementRequest.class);
	}
}