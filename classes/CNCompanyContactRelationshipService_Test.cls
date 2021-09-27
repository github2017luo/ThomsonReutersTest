/**
* {Purpose} Test Class for CNCompanyContactRelationshipService
*
* @author   Glen Cunningham
* @version  2015.11.5
*/ 

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
*  
* =============================================================================
*/
@isTest (SeeAllData=true)
private class CNCompanyContactRelationshipService_Test {
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
    
    static testMethod void myUnitTest() {
        Account a = CNUnitTest.getAccount(true);
         
        Test.startTest();
        RecordType r;
        List<RecordType>Listr = [SELECT id,sObjectType FROM RecordType where name= 'contact'];
        for(RecordType t:Listr){
            if(t.sObjectType.contains('CN_Relationship')){
                r=t;
            }
        }
        
        Account acct = CNUnitTest.getAccount(true);
        Contact con = CNUnitTest.getContact(acct.Id, true);
        CN_Webservice_Queue__c wsq = CNUnitTest.getWebserviceQueue(acct.Id, con.Id, system.now().addDays(1), true) ;
        List<CN_Relationship__c> lCNR = CNUnitTest.getRelationships(wsq.id, 20, true, r.Id);
        List<Contact> lcon = CNUnitTest.getContacts(acct.Id, 10, true);
        testCNEnhancedListHandler oEListHandler = new testCNEnhancedListHandler();
        List<CNData.CNRelationship> lrr = oEListHandler.massageRelationships(lCNR) ;
        
        CNCompanyContactRelationshipService cn = new CNCompanyContactRelationshipService(acct.id, '422345', lrr, 0);
 
        system.assertEquals(cn.fetchInitialDataFromCN(),true);
        system.assertEquals(cn.fetchMoreDataFromCN(),false);
        system.assertEquals(cn.fetchAllDataFromSFDC(),true);
        cn.loadQueueHandler();
        system.assertEquals(cn.getCachedRelationshipsCount(),20);
        CNCompanyContactRelationshipService.fetchRestOfDataFromCN_Async(a.id,10, a.id, '54673567') ;
         List<Object> o = cn.massageNextPageData(lrr);
        cn.loadQueueHandler();
        system.assertEquals(20,cn.iTotalRecords);
        Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cnq = new CNServices_14();        
        CNData.CNWebserviceResult x =  CNServices_14.fetchCompanyContacts('Pepsico, Inc.', 'pepsico.com', '4295904718', 10,0, false);
        
        
        CNData.CNContact oCont = new CNData.CNContact();
        
         CNData.CNRelationship xw = CNCompanyContactRelationshipService.convertContactIntoRelationship(oCont);
        test.stopTest();
    }

    static testMethod void companyColleaugeRelationshipServiceTest() {
        Account a = CNUnitTest.getAccount(true);
         
        Test.startTest();

        RecordType r;
        List<RecordType>Listr = [SELECT id,sObjectType FROM RecordType where name= 'contact'];
        for(RecordType t:Listr){
            if(t.sObjectType.contains('CN_Relationship')){
                r=t;
            }
        }
        
        Account acct = CNUnitTest.getAccount(true);
        Contact con = CNUnitTest.getContact(acct.Id, true);
        CN_Webservice_Queue__c wsq = CNUnitTest.getWebserviceQueue(acct.Id, con.Id, system.now().addDays(1), true) ;
        List<CN_Relationship__c> lCNR = CNUnitTest.getRelationships(wsq.id, 20, true, r.Id);
        List<Contact> lcon = CNUnitTest.getContacts(acct.Id,16, true);
        testCNEnhancedListHandler oEListHandler = new testCNEnhancedListHandler();
        List<CNData.CNRelationship> lrr = oEListHandler.massageRelationships(lCNR) ;
        
        CNCompanyColleageRelationshipService cn = new CNCompanyColleageRelationshipService(acct.id, '422345', 'Microsoft', 'microsoft.com');
        
        //CNCompanyContactRelationshipService cn = new CNCompanyContactRelationshipService(acct.id, '422345', lrr, 0);
        
        system.assertEquals(false, cn.fetchInitialDataFromCN()); // fake, not expecting any data
        system.assertEquals(false, cn.fetchMoreDataFromCN());
        system.assertEquals(true, cn.fetchAllDataFromSFDC());
        
        cn.loadQueueHandler();      
        system.assertEquals(0, cn.getCachedRelationshipsCount());
/*
        CNCompanyColleageRelationshipService.fetchRestOfDataFromCN_Async(a.id,10, a.id, '54673567') ;
         List<Object> o = cn.massageNextPageData(lrr);
        cn.loadQueueHandler();
        system.assertEquals(20,cn.iTotalRecords);
        Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cnq = new CNServices_14();        
        CNData.CNWebserviceResult x =  CNServices_14.fetchCompanyContacts('Pepsico, Inc.', 'pepsico.com', '4295904718', 10,0, false);
        
        CNData.CNContact oCont = new CNData.CNContact();        
        CNData.CNRelationship xw = CNCompanyContactRelationshipService.convertContactIntoRelationship(oCont);
*/
        
        test.stopTest();
    }
}