/**
* {Purpose} � This class provides a test for CNPaginator
* 
* @author   Glen Cunningham
* @version  2015.12.04
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description 
*2015-12-04     Glen Cunningham         created
* =============================================================================
*/
@isTest(seeAllData=true)
private  class CNPaginator_Test {
 
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
    static testMethod void runTests(){
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
        List<Contact> lcon = CNUnitTest.getContacts(acct.Id, 13, true);
        testCNEnhancedListHandler oEListHandler = new testCNEnhancedListHandler();
        List<CNData.CNRelationship> lrr = oEListHandler.massageRelationships(lCNR) ;
        testCNListHandler cn = new testCNListHandler();     
        cn.listdata = lCNR;
        CNPaginator c = new CNPaginator();
        testCNEnhancedListHandler oEL = new testCNEnhancedListHandler();
        CNPaginator c1 = new CNPaginator(oEL) ;
        CNPaginator cnp = new CNPaginator(cn);
        cnp.oListHandler.listData = lrr;         
        cnp.relationships = lrr;        
        cnp.pageNo = '1';
        
        system.debug('last - start');
        system.debug('Current Page Number: ' + cnp.getcurrentPageNo());
        system.debug('Current Page Size: ' + cnp.getcurrentPageSize());
        system.debug('End of Pages: ' + cnp.getEndOfPages());
        system.debug('Last Index: ' + cnp.getlastindex());        
        system.debug('Last Page Size: ' + cnp.getlastPageSize());
        system.debug('Pager End Number: ' + cnp.getpagerEndNumber());
        system.debug('Pager Start Number: ' + cnp.getpagerStartNumber());
        system.debug('Size: ' + cnp.getSize());
        system.debug('Total Pages: ' + cnp.getTotalPages());
        system.debug('Total Records: ' + cnp.getTotalRecords());
        system.debug('###');
        cnp.last();
        system.debug('//###');
        system.debug('Current Page Number: ' + cnp.getcurrentPageNo());
        system.debug('Current Page Size: ' + cnp.getcurrentPageSize());
        system.debug('End of Pages: ' + cnp.getEndOfPages());
        system.debug('Last Index: ' + cnp.getlastindex());        
        system.debug('Last Page Size: ' + cnp.getlastPageSize());
        system.debug('Pager End Number: ' + cnp.getpagerEndNumber());
        system.debug('Pager Start Number: ' + cnp.getpagerStartNumber());
        system.debug('Size: ' + cnp.getSize());
        system.debug('Total Pages: ' + cnp.getTotalPages());
        system.debug('Total Records: ' + cnp.getTotalRecords());
        system.debug('last - end');
        
        cnp.setsortBy('emailAsc');
        system.assertEquals('emailAsc',cnp.getSortBy());
        cnp.setinnersortBy('emailAsc');
        system.assertEquals('emailAsc',cnp.getinnerSortBy());
        cnp.setwhichSort('inner');
        system.assertEquals('inner',cnp.getwhichSort());
        
        cnp.sortDataBy();
        cnp.setwhichSort('outer10');
        cnp.sortDataBy();       
        cnp.setsortBy('nameAsc');
        cnp.sortDataBy();
        cnp.setsortBy('titleAsc');
        cnp.sortDataBy();
        cnp.next();
        cnp.previous();
        cnp.last();
        cnp.first();
        cnp.specificpage();
        cnp.Elipsis();
        cnp.backElipsis();
        integer sz = cnp.getsize();
        cnp.setpagerStartNumber(1);
        system.assertEquals(cnp.getpagerStartNumber(),1);
        cnp.setpagerEndNumber(10);
        system.assertEquals(cnp.getpagerEndNumber(),10);
        integer x11 = cnp.getEndOfPages();
        system.debug('End of pages: ' + x11);
        integer x12 = cnp.getTotalPages();
        system.debug('Total pages: ' + x12);
        cnp.setcurrentPageNo(2); 
        system.assertEquals(1,cnp.getcurrentPageNo());
        integer x13 = cnp.getlastindex();
        integer x14 = cnp.getlastPageSize();
        integer x15 = cnp.getcurrentPageSize();
        system.debug('Current page size' + x15);
        integer x16 = cnp.getloadCapacity();
        boolean b1 = cnp.getbCNHasNoMoreData();
        String s11 = cnp.getRecordsCountOnTabName(); 
        Boolean b2 = cnp.getHasNextPageLabel(); 
        Boolean b3 = cnp.getDisplayLastUpdateDate();  
        List<CNData.CNRelationship> l1= cnp.getAllRelationshipsInCache();
        List<CNData.CNRelationship> l2 = cnp.getRelationships(); 
    }
}