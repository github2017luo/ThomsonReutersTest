/**
* {Purpose} � This class provides a test for CNContactRElationshipService
* 
* @author   Glen Cunningham
* @version  2015.12.04
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description 
*2015-12-04		Glen Cunningham 		created
* =============================================================================
*/
@isTest(seeAllData=true)
private  class CNContactRElationshipService_Test {
	private class CNWebserviceResult {
		/* Public variables */
		public List<CNData.CNRelationship> listRelationships {get; set;}
		public List<CNData.CNContact> listContacts {get; set;}
		public String sContactCNID {get; set;}
		public String sCompanyCNID {get; set;}
		public Integer iTotalRelationships {get; set;}
		public Boolean errorFound {get; set;}

		/* CONSTRUCTORS */

		public CNWebserviceResult() {
			errorFound = false;
		}
	}  
	private class testCNEnhancedListHandler extends CNEnhancedListHandler{
		
		//Prepares the query string for the table    
	    public override String getQueryString(){
	    	return 'sdfgsdfg';
	    }
	      
	    //Converts the data structs from one format to another
	    public override List<CNData.CNRelationship> massageRelationships(List<CN_Relationship__c> listRelationshipInSObject) {
			List<CNData.CNRelationship> listRels = CNAppUtils.convertCustomObjectToContactRelationship(listRelationshipInSObject, true);
			List<CNData.CNRelationship> listMassagedRels = new List<CNData.CNRelationship>();
			//Integer iAlternateIndex = 0;
			for (CNData.CNRelationship oRel : listRels) {
				System.debug('oRel: ' + oRel);

				oRel.display = true;    
				oRel.enhancedList = true;
				oRel.index = integer.valueOf(oRel.contact.CNID);//iAlternateIndex++;
				listMassagedRels.add(oRel);

				if (oRel.contact.LastModificationTimeAlt != null) {
					CNPaginator.displayLastUpdateDate = true;
				}

				CNData.CNContact oHiddenCont = new CNData.CNContact();
				oHiddenCont.CNID = oRel.contact.CNID;
				oHiddenCont.firstName = oRel.contact.firstName;
				oHiddenCont.lastName = oRel.contact.lastName;
				oHiddenCont.emailAddresses = oRel.contact.emailAddresses;

				CNData.CNRelationship oHiddenRelationship = new CNData.CNRelationship();
				oHiddenRelationship.contact = oHiddenCont;
				oHiddenRelationship.display = false;
				oHiddenRelationship.index = integer.valueOf(oHiddenCont.CNID);//iAlternateIndex++;
				listMassagedRels.add(oHiddenRelationship); 
			}
			return listMassagedRels;
		}
	    
		//Loads queue handler record
		public override void loadQueueHandler(){
			
		}
	}
	private class testCNListHandler extends CNListHandler{
		//Pulls the initial set of records from CN which are required to display the first page. Returns true if CN has more data to return.
		public override Boolean fetchInitialDataFromCN(){
			return true;
		}

		//Pulls additional set of records from CN which are required to display subsequent pages. Returns true if CN has more data to return.
		public override Boolean fetchMoreDataFromCN(){
			return true;
		}

		//Manipulates the input data for display purposes
		public override List<Object> massageNextPageData(List<Object> nextPageData){
			return nextPageData;
		}

		//pulls the initial set of relationship records from SFDC
		public override Boolean fetchAllDataFromSFDC(){
			return true;
		}

		//Loads queue handler record
		public override void loadQueueHandler(){}

		//Returns the total cached relationships count
		public override Integer getCachedRelationshipsCount(){
			return 5;
		}
	}	
	static testMethod void runTests(){
		Account a = CNUnitTest.getAccount(true);
		Contact con = CNUnitTest.getContact(a.Id,true);
		Test.startTest();
	    Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
		CNContactRElationshipService cn = new CNContactRElationshipService(con.Id, con.email);
		system.assertEquals(cn.fetchInitialDataFromCN(),null);
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
		system.assertEquals(cn.fetchAllDataFromSFDC(),false);
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());
		system.assertEquals(cn.fetchMoreDataFromCN(),false);
		cn.loadQueueHandler();
		system.assertEquals(0,cn.getCachedRelationshipsCount());
		CNContactRElationshipService.fetchRestOfDataFromCN_Async('', 12, con.Id, '');
		//set up data
		RecordType r;
		List<RecordType>Listr = [SELECT id,sObjectType FROM RecordType where name= 'contact'];
		for(RecordType t:Listr){
			if(t.sObjectType.contains('CN_Relationship')){
				r=t;
			}
		}
		Account acct = CNUnitTest.getAccount(true);
		Contact con1 = CNUnitTest.getContact(acct.Id, true);
		CN_Webservice_Queue__c wsq = CNUnitTest.getWebserviceQueue(acct.Id, con.Id, system.now().addDays(1), true) ;
		List<CN_Relationship__c> lCNR = CNUnitTest.getRelationships(wsq.id, 20, true, r.Id);
		List<Contact> lcon = CNUnitTest.getContacts(acct.Id, 3, true);
		CNData.CNWebserviceResult wsr = new CNData.CNWebserviceResult();
		testCNEnhancedListHandler cern = new testCNEnhancedListHandler();
		List<CNData.CNRelationship> xxx = cern.massageRelationships(lCNR);
		wsr.listRelationships = xxx;
		integer p=0;
		wsr.listContacts = new List<CNData.CNContact>();
		for(Contact c:lcon){
			CNData.CNContact ccc = new CNData.CNContact();
			p++;
			ccc.CNID = 'T12345' + p;
			ccc.firstName = c.firstname;
			ccc.lastName = c.lastname;
			ccc.fullName = c.name;
			List<String> emailAddresses = new List<string>();
			emailAddresses.add('testme@email.foo');
			ccc.emailAddresses = emailAddresses;
			ccc.title = 'big boss';
			List<CNData.CNPhone> phones  = new List<CNData.CNPhone>();
			CNData.CNPhone phone = new CNData.CNPhone('123-456-7890' , 'cell'); 
			phones.add(phone);
			ccc.phones = phones; 
			CNData.CNCompany company = new CNData.CNCompany();
			 
			company.CNID = 'T12432354';
			ccc.company = company;
			Set<String> sources  = new Set<String>();
			sources.add('email');
			ccc.sources = sources;
			ccc.relationships  = xxx;
			ccc.normalizedScore = 3;
			ccc.score = 4.23;
			ccc.workingLocation = 'London';
			ccc.POBox = '123-324';
			ccc.StreetAddress = 'some street';
			ccc.Locality = 'some test local';
			ccc.Region = 'Antartica';
			ccc.PostalCode = 'AS23-B43526-098';
			List<String> identifiers = new List<String>(); 
			identifiers.add('Dr');
			ccc.identifiers = identifiers;
			ccc.IsDeleted = false;
			ccc.LastModificationTime = '2015-12-12';
			DateTime LastModificationTimeAlt = DateTime.Now();
			ccc.LastModificationTimeAlt = LastModificationTimeAlt;
			ccc.recencyNumber = 1234;
			ccc.NumberOfRelationships = 30;	
			List<CNData.CNAddress> addresses = new List<CNData.CNAddress>();
			ccc.addresses = addresses;
			List<String> signatures = new List<string>();
			signatures.add('foobar');
			ccc.addresses = addresses;
			ccc.innerRelationshipExpanded = false;
			testCNListHandler cn12 = new testCNListHandler();
			cn.listdata = lCNR;
			CNPaginator cnp = new CNPaginator(cn12);
			ccc.paginator = cnp;			
			wsr.listContacts.add(ccc);
		}
		wsr.sContactCNID = 'AD234235';
		wsr.sCompanyCNID = 'CN432534';
		wsr.iTotalRelationships = 20;
		wsr.errorFound = false;
		cn.oResult = wsr;
		cn.fetchMoreDataFromCN();
		//add webservice and call everything again
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl()); 
		CNServices_14 cnser = new CNServices_14();  
        //set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Collection":[{"Type":16,"Collection":[{"NumColleagues":131,"NumContacts":329,"NumRelationships":1421,"HasFamilyTree":true,"Id":"4295903627","DisplayValue":"Cvs Caremark Corporation"}],"TotalResults":1}]}');
        httpRes.setStatusCode(200);       	        
         
		cn = new CNContactRElationshipService(con.Id, con.email);
		system.assertEquals(cn.fetchInitialDataFromCN(),null);
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
		system.assertNotEquals(cn.fetchAllDataFromSFDC(),null);
		Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());
		system.assertNotEquals(cn.fetchMoreDataFromCN(),true);
		cn.loadQueueHandler();
		system.assertEquals(0,cn.getCachedRelationshipsCount());
		CNContactRElationshipService.fetchRestOfDataFromCN_Async('', 12, con.Id, '');
		CNContactRElationshipService.fetchRestOfDataFromCN_Async('', 12, con.Id, '00161000002kQb8');
 		CNContactRElationshipService.fetchRestOfDataFromCN_Async('00161000002kQb8', 12, con.Id, '');
		
		//CNContactRElationshipService.oQueueHandler.updateColleagueStatus(CNContactRElationshipService.oQueueHandler.ALL_DATA_RECEIVED_STATUS);
		CNContactRElationshipService.fetchRestOfDataFromCN_Async('', 12, con.Id, '00161000002kQb8');
		CNContactRElationshipService.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(null, '00161000002kQb8', null, 'Colleague');
		cn.fetchAllDataFromSFDC();
		//system.assertEquals(cn.iTotalRecords,0);
		test.stopTest();
	}
}