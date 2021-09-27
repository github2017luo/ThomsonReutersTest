public class ESIResponseGetSubscription{
	public notification notification;
    public onlineContact[] onlineContact;
    
	public class notification {
		public String statusCode;	//500
		public String statusDescription;	//FAILURE
		public String statusDetailMessage;	//Success : 0 Failure : 1
		public String trackingId;
        
        public notification(){}
	}
	public class onlineContact {
		public String contactNumber;	//0006328280
		public entitlements[] entitlements;
        public onlineContact(){}
	}
	public class entitlements {
		public subscriptions[] subscriptions;
	}
	public class subscriptions {
		public String subscriptionStatus;	//400
		public String subscriptionMessage;	//One or more contacts in the list does not have a active trial matching the offer id
		public String trialEffDate;
		public String trialEndDate;
		public String trialReasonCode;	//Other
	}

	

}