public class ODT_OnePassErrorRequest {

    public ESIHeader ESIHeader;
	public String actionCode;	//ADD_REG_KEYS
    public List<OnlineContact> onlineContact;
    public ODT_OnePassErrorRequest(){}
	public class ESIHeader {
		public String applicationId;	//CXODT
		public String transactionId;	//f994e430-81cf-4891-ab09-3e84a77a1b6a
		public String companyId;	//WEST
	}
	public class OnlineContact {
		public String contactNumber;	//1233131313
		public Address address;
		public Account account;
		public Entitlements[] entitlements;
		public String onePassIdentifier;	//be3c19f51f3c4010a6d38d5b68886cd5
	}
	public class Address {
		public String firstName;	//test
		public String lastName;	//user
		public String emailAddress;	//abhi20sep01@mailinator.com
	}
	public class Account {
		public String accountNumber;	//7000011358
	}
	public class Entitlements {
		public String applicationId;	//COBALT
		public String authId;	//123456-987654
	}
}