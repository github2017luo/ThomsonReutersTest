public class ReactivateEntitlementResponse {

	public class Entitlements {
		public String applicationId;
		public String appUserId;
		public String appUserPassword;
		public String appUserGuid;
	}

	public String billingGroupNumber;
	public String billingGroupName;
	public String status;
	public List<ContactInformation> contactInformation;

	public class ContactInformation {
		public String contactTransactionId;
		public String contactNumber;
		public String success;
		public List<Entitlements> entitlements;
	}

	
	public static ReactivateEntitlementResponse parse(String json) {
		return (ReactivateEntitlementResponse) System.JSON.deserialize(json, ReactivateEntitlementResponse.class);
	}
}