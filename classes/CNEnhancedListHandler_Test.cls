/**
* {Purpose} � This class provides a test for CNEnhancedListHandler
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
private class CNEnhancedListHandler_Test {
        private class CNEnhancedListColleageService extends CNEnhancedListHandler {
            //Private variables
            private String sAcctId;
    
            /* CONSTRUCTORS */
            public CNEnhancedListColleageService(String sAcctId) {
                this.sAcctId = sAcctId;
                this.tabName = 'Colleague';
                System.debug('sAcctId: ' + sAcctId);
                initSetController();
            }
    
            /* PUBLIC METHODS */
            public override String getQueryString() {
                String sQuery = CNAppUtils.prepareRelationshipSOQL('Colleague', sAcctId, null, -1, sSortBy, sSortDirection, sStartsWith);
                return sQuery;
            }
    
            //Loads queue handler record from custom object
            public override void loadQueueHandler() {
                if (oQueueHandler == null) {
                    this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sAcctId, null, null, 'Colleague');
                }
            } 
    
            public override List<CNData.CNRelationship> massageRelationships(List<CN_Relationship__c> listRelationshipInSObject) {
                List<CNData.CNRelationship> listRels =  CNAppUtils.convertCustomObjectToColleagueRelationship(listRelationshipInSObject, true);
                List<CNData.CNRelationship> listMassagedRels = new List<CNData.CNRelationship>();
                //due to paging we need to handle index and hiddenRowIndex values so they 
                //sequence correctly for current page/recordset not keep going 1-10  
                //so assign cnid as the index here and in javascript match on that    
                //gmc integer iAlternateIndex = (CNAccountRelationshipViewController.localIndex>0)?CNAccountRelationshipViewController.localIndex:0; //starts at 0
    
                for (CNData.CNRelationship oRel : listRels) {
                    oRel.display = true;
                    oRel.enhancedList = true;
                    oRel.index = integer.valueOf(oRel.colleague.CNID);//iAlternateIndex++;
                    listMassagedRels.add(oRel);
    
                    CNData.CNColleague oHiddenCol = new CNData.CNColleague();
                    oHiddenCol.CNID = oRel.colleague.CNID;
                    oHiddenCol.firstName = oRel.colleague.firstName;
                    oHiddenCol.lastName = oRel.colleague.lastName;
                    oHiddenCol.emailAddresses = oRel.colleague.emailAddresses;
    
                    CNData.CNRelationship oHiddenRelationship = new CNData.CNRelationship();
                    oHiddenRelationship.colleague = oHiddenCol;
                    oHiddenRelationship.display = false;
                    //
                    oHiddenRelationship.setShowColleagueEmailData(false);
                    oHiddenRelationship.setShowColleagueLocation(false);
                    oHiddenRelationship.setShowColleaguePhoneData(false);
                    oHiddenRelationship.setShowColleagueRecency(false);
                    oHiddenRelationship.setShowColleagueRelationshipStrength(false);
                    oHiddenRelationship.setShowColleagueSource(false);
                    oHiddenRelationship.setShowColleagueTitle(false);
                    oHiddenRelationship.setShowContactEmailData(false);
                    oHiddenRelationship.setShowContactLocation(false);
                    oHiddenRelationship.setShowContactPhoneData(false);
                    oHiddenRelationship.setShowContactRecency(false);
                    oHiddenRelationship.setShowContactRelationshipStrength(false);
                    oHiddenRelationship.setShowContactSource(false);
                    oHiddenRelationship.setShowContactTitle(false);
                    oHiddenRelationship.setShowEmailData(false);
                    oHiddenRelationship.setShowPhoneData(false);
                    oHiddenRelationship.setshowContactEmail(false);
                    oHiddenRelationship.setshowContactPhone(false);   
                    //
                    oHiddenRelationship.index = integer.valueOf(oHiddenCol.CNID);//iAlternateIndex++;
                    listMassagedRels.add(oHiddenRelationship);          
                }
                return listMassagedRels;          
            }
        }

        private class CNEnhancedListContactService extends CNEnhancedListHandler {
            //Private variables
            private String sAcctId;
    
            /* CONSTRUCTORS */
            public CNEnhancedListContactService(String sAcctId) {
                this.sAcctId = sAcctId;
                this.tabName = 'Contact';
                System.debug('sAcctId: ' + sAcctId);
                initSetController();
            }
    
            /* PUBLIC METHODS */
            public override String getQueryString() {
                String sQuery = CNAppUtils.prepareRelationshipSOQL('Contact', sAcctId, null, -1, sSortBy, sSortDirection, sStartsWith);
                List<CN_Relationship__c> listRels = (List<CN_Relationship__c>) Database.query(sQuery + ' limit 1');
                if (listRels.size() == 1) {
                    CNPaginator.displayLastUpdateDate = listRels.get(0).Last_Modification_Time__c != null;
                }
                return sQuery;
            }
    
            //Loads queue handler record from custom object
            public override void loadQueueHandler() {
                if (oQueueHandler == null) {
                    this.oQueueHandler = new CNAppUtils.CNWebServiceQueueHandler(sAcctId, null, null, 'Contact');
                }
            } 
    
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
    
        }  

    static testMethod void myUnitTest() {
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
        CNEnhancedListColleageService tce = new CNEnhancedListColleageService(acct.id);
        tce.getQueryString();
        List<CNData.CNRelationship> l1 = tce.getRelationships();
        PageReference p = tce.nextPage();
        PageReference p1 = tce.prevPage();
        PageReference p2 = tce.filterPage();
        PageReference p3 = tce.sortPage();
        Integer x = tce.getTotalRecords();
         Boolean b = tce.getHasPreviousPage();
         Boolean b1 = tce.getHasNextPage();
         CNEnhancedListHandler ce = tce.getCurrentReference();
         
        CNEnhancedListContactService tcc = new CNEnhancedListContactService(acct.id);
        tcc.getQueryString();
        List<CNData.CNRelationship> l2 = tcc.getRelationships();
    }
}