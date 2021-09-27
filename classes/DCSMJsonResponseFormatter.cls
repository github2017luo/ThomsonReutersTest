//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class DCSMJsonResponseFormatter {

	public class OnlineContact {
		public String contactNumber {get;set;} 
		public String sourceId {get;set;} 
		public String contactStatus {get;set;} 
		public String onlineContactType {get;set;} 
		public String onlineContactTypeDescription {get;set;} 
		public Boolean allowContactEmails {get;set;} 
		public Address address {get;set;} 
		public List<Entitlements> entitlements {get;set;} 

		public OnlineContact(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'contactNumber') {
							contactNumber = parser.getText();
						} else if (text == 'sourceId') {
							sourceId = parser.getText();
						} else if (text == 'contactStatus') {
							contactStatus = parser.getText();
						} else if (text == 'onlineContactType') {
							onlineContactType = parser.getText();
						} else if (text == 'onlineContactTypeDescription') {
							onlineContactTypeDescription = parser.getText();
						} else if (text == 'allowContactEmails') {
							allowContactEmails = parser.getBooleanValue();
						} else if (text == 'address') {
							address = new Address(parser);
						} else if (text == 'entitlements') {
							entitlements = arrayOfEntitlements(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OnlineContact consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Account {
		public String accountNumber {get;set;} 
		public String companyId {get;set;} 
		public List<OnlineContact> onlineContact {get;set;} 

		public Account(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'accountNumber') {
							accountNumber = parser.getText();
						} else if (text == 'companyId') {
							companyId = parser.getText();
						} else if (text == 'onlineContact') {
							onlineContact = arrayOfOnlineContact(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Account consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Object esiHeader {get;set;} 
	public StatusDetails statusDetails {get;set;} 
	public List<Account> account {get;set;} 

	public DCSMJsonResponseFormatter(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'esiHeader') {
						esiHeader = parser.readValueAs(Object.class);
					} else if (text == 'statusDetails') {
						statusDetails = new StatusDetails(parser);
					} else if (text == 'account') {
						account = arrayOfAccount(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'DCSMJsonResponseFormatter consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Address {
		public String firstName {get;set;} 
		public String lastName {get;set;} 
		public String emailAddress {get;set;} 

		public Address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'emailAddress') {
							emailAddress = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Subscriptions {
		public String subscriptionNumber {get;set;} 
		public Material material {get;set;} 

		public Subscriptions(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'subscriptionNumber') {
							subscriptionNumber = parser.getText();
						} else if (text == 'material') {
							material = new Material(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Subscriptions consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Entitlements {
		public String applicationId {get;set;} 
		public String status {get;set;} 
		public String appUserGuid {get;set;} 
		public String accessStartDate {get;set;} 
		public String accessEndDate {get;set;} 
		public List<Subscriptions> subscriptions {get;set;} 

		public Entitlements(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'applicationId') {
							applicationId = parser.getText();
						} else if (text == 'status') {
							status = parser.getText();
						} else if (text == 'appUserGuid') {
							appUserGuid = parser.getText();
						} else if (text == 'accessStartDate') {
							accessStartDate = parser.getText();
						} else if (text == 'accessEndDate') {
							accessEndDate = parser.getText();
						} else if (text == 'subscriptions') {
							subscriptions = arrayOfSubscriptions(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Entitlements consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class StatusDetails {
		public String statusCode {get;set;} 
		public String statusDescription {get;set;} 
		public Object statusDetailMessage {get;set;} 

		public StatusDetails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'statusCode') {
							statusCode = parser.getText();
						} else if (text == 'statusDescription') {
							statusDescription = parser.getText();
						} else if (text == 'statusDetailMessage') {
							statusDetailMessage = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'StatusDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Material {
		public String materialNumber {get;set;} 
		public String materialDescription {get;set;} 
		public String materialType {get;set;} 
		public String internalDescription {get;set;} 

		public Material(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'materialNumber') {
							materialNumber = parser.getText();
						} else if (text == 'materialDescription') {
							materialDescription = parser.getText();
						} else if (text == 'materialType') {
							materialType = parser.getText();
						} else if (text == 'internalDescription') {
							internalDescription = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Material consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static DCSMJsonResponseFormatter parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DCSMJsonResponseFormatter(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	




    private static List<OnlineContact> arrayOfOnlineContact(System.JSONParser p) {
        List<OnlineContact> res = new List<OnlineContact>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new OnlineContact(p));
        }
        return res;
    }


    private static List<Entitlements> arrayOfEntitlements(System.JSONParser p) {
        List<Entitlements> res = new List<Entitlements>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Entitlements(p));
        }
        return res;
    }




    private static List<Account> arrayOfAccount(System.JSONParser p) {
        List<Account> res = new List<Account>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Account(p));
        }
        return res;
    }




    private static List<Subscriptions> arrayOfSubscriptions(System.JSONParser p) {
        List<Subscriptions> res = new List<Subscriptions>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Subscriptions(p));
        }
        return res;
    }





}