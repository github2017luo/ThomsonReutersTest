public class CreateEntitlementResponse {

	public ESIHeader ESIHeader;
	public Notification Notification;

	public class ESIHeader {
		public String transactionId;
	}

	public class Notification {
		public String statusCode;
		public String statusDescription;
		public String statusDetailMessage;
	}

	
	public static CreateEntitlementResponse parse(String json) {
		return (CreateEntitlementResponse) System.JSON.deserialize(json, CreateEntitlementResponse.class);
	}
}