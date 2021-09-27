public class ODT_OnePassErrorResponse {
    public ESIHeader ESIHeader;
	public Notification Notification;
    public ODT_OnePassErrorResponse(){}
	public class ESIHeader {
		public String applicationId;	//CXODT
		public String transactionId;	//f994e430-81cf-4891-ab09-3e84a77a1b6a
	}
	public class Notification {
		public String statusCode;	//200
		public String statusDescription;	//SUCCESS
		public String statusDetailMessage;	//Registration Key Added Successfully
	}
}