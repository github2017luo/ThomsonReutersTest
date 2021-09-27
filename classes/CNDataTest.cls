/**
* {Purpose} – Test class for CNData.
*
* @author   Shah Kadirmohideen
* @version  2011-12-13
*/

/** 
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2011-12-13    Shah Kadirmohideen      Created  
* 2011-12-20    Shah Kadirmohideen      Added OnInstall annotation to enforce test method execution during package installation.
* 2012-01-04    Shah Kadirmohideen      Updated test_CNPhoneData() method to refer to the new phone type formatting method.
* 2012-01-20    Shah Kadirmohideen      Incorporated enhanced list (go to list) functionality related changes.
* 2012-07-12    Shah Kadirmohideen      Added support for calendar icon display      
* =============================================================================
*/
@isTest
private class CNDataTest {
    
    /**
    * Validates all the methods defined for CNContact data class
    */
    @isTest (OnInstall=false)
    private static void test_CNContactData() {
        Test.startTest();
        
        CNData.CNContact oCont = new CNData.CNContact();
        
        oCont.FirstName = 'Jenny';
        oCont.LastName = 'David';
        System.assertEquals('Jenny David', oCont.getFullNamePrepared(), 'Fullname not generated properly');
        
        oCont.FirstName = null;
        System.assertEquals('David', oCont.getFullNamePrepared(), 'Fullname not generated properly');

        System.assertEquals('David', oCont.getFullNameOrEmail(), 'FullNameOrEmail not generated properly');
        
        oCont.FirstName = null;
        oCont.LastName = null;
        oCont.EmailAddresses = new String[]{'test@test.com'};
        System.assertEquals('test@test.com', oCont.getFullNameOrEmail(), 'FullNameOrEmail not generated properly');

        System.assertEquals(false, oCont.getIsNamePresent(), 'Expected to find name');
        
        oCont.LastName = 'David';
        System.assertEquals(true, oCont.getIsNamePresent(), 'Expected to find name');

        System.assertEquals('David\'s Relationships', oCont.getRelationshipTitle(), 'Relationship title not prepared properly');
          
        oCont.FirstName = null;
        oCont.LastName = null;
        oCont.EmailAddresses = new String[]{'test@test.com'};
        System.assertEquals('test@test.com Relationships', oCont.getRelationshipTitle(), 'Relationship title not prepared properly');
        
        oCont.sources = new Set<String>{CNConstants.SOURCE_TYPE_ISPHONE, CNConstants.SOURCE_TYPE_ISEMAIL, 
                    CNConstants.SOURCE_TYPE_ISADDRESSBOOK, CNConstants.SOURCE_TYPE_ISCRM, 
                    CNConstants.SOURCE_TYPE_ISBILLING, CNConstants.SOURCE_TYPE_ISCALENDAR};
        
        System.assertEquals(true, oCont.getIsPhoneSource(), 'Phone source calculation not prepared properly');
        System.assertEquals(true, oCont.getIsCalendarSource(), 'Calendar source calculation not prepared properly');
        System.assertEquals(true, oCont.getIsEmailSource(), 'Email source calculation not prepared properly');
        System.assertEquals(true, oCont.getIsAddressBookSource(), 'Address book source calculation not prepared properly');
        System.assertEquals(true, oCont.getIsCRMSource(), 'CRM source calculation not prepared properly');
        System.assertEquals(true, oCont.getIsBillingSource(), 'Time and billing source calculation not prepared properly');
        
        oCont.phones = new List<CNData.CNPhone>{new CNData.CNPhone('111-222-3333', 'home'), new CNData.CNPhone('444-555-6666', 'work'), new CNData.CNPhone('445-232-1221', 'cell')};
        System.assertEquals('111-222-3333', oCont.getFirstPhone().phoneNumber, 'First phone number not identified properly');
        System.assertEquals('111-222-3333', oCont.getFirstPhoneNumber(), 'First phone number not identified properly');
        
        System.assertEquals(1, oCont.getCollapsedPhones().size(), 'Collapsed phone numbers not identified properly');               
        System.assertEquals(3, oCont.getExpandedPhones().size(), 'Expanded phone numbers not identified properly');
        
        oCont.EmailAddresses = new String[]{'test1@test.com', 'test2@test.com'};
        System.assertEquals('test1@test.com', oCont.getFirstEmail(), 'First email not identified properly');

        System.assertEquals(1, oCont.getCollapsedEmails().size(), 'Collapsed emails not identified properly');              
        System.assertEquals(2, oCont.getExpandedEmails().size(), 'Expanded emails not identified properly');
        
        oCont.title = 'Principal';      
        System.assertEquals(false, oCont.getIsTitleEmpty(), 'Title expected to be non empty');
        
        System.assertEquals('445-232-1221', oCont.getMobilePhoneNumber(), 'Incorrect mobile phone number returned');
        
        System.assertEquals('', oCont.getLastModificationTimeFormatted(), 'Last modification formatted time not returning the correct value');
        oCont.LastModificationTimeAlt = System.now();
        System.assertNotEquals(null, oCont.getLastModificationTimeFormatted(), 'Last modification formatted time not returning the correct value');
        
        Test.stopTest();
    }
  
    /**
    * Validates all the methods defined for CNRelationship data class
    */
    @isTest (OnInstall=false)
    private static void test_CNRelationshipData() {
        Test.startTest();
        
        CNData.CNRelationship oRel = new CNData.CNRelationship();

        oRel.sources = new Set<String>{CNConstants.SOURCE_TYPE_ISPHONE, CNConstants.SOURCE_TYPE_ISEMAIL, 
                    CNConstants.SOURCE_TYPE_ISADDRESSBOOK, CNConstants.SOURCE_TYPE_ISCRM, 
                    CNConstants.SOURCE_TYPE_ISBILLING, CNConstants.SOURCE_TYPE_ISCALENDAR};
        
        System.assertEquals(true, oRel.getIsPhoneSource(), 'Phone source calculation not prepared properly');
        System.assertEquals(true, oRel.getIsCalendarSource(), 'Calendar source calculation not prepared properly');
        System.assertEquals(true, oRel.getIsEmailSource(), 'Email source calculation not prepared properly');
        System.assertEquals(true, oRel.getIsAddressBookSource(), 'Address book source calculation not prepared properly');
        System.assertEquals(true, oRel.getIsCRMSource(), 'CRM source calculation not prepared properly');
        System.assertEquals(true, oRel.getIsBillingSource(), 'Time and billing source calculation not prepared properly');
        
        oRel.index = 1;
        System.assertEquals(2, oRel.getHiddenRowIndex(), 'Hidden row index calculation not done properly');
        
        System.assertEquals('none', oRel.getInnerTableDisplay(), 'Inner table display calculation not done properly');
        System.assertEquals('', oRel.getInnerTableDisplay(), 'Inner table display calculation not done properly');
        
        CNPaginator.displayLastUpdateDate = true;
        oRel.display = true;
        System.assertEquals(true, oRel.getIsDisplayLastUpdateDate(), 'last update date display decision is not working');
        
        Test.stopTest();
    }

    /**
    * Validates all the methods defined for CNPhone data class
    */
    @isTest (OnInstall=false)
    private static void test_CNPhoneData() {
        Test.startTest();
        
        CNData.CNPhone oPhone = new CNData.CNPhone('111-222-3333', 'Work');
        System.assertEquals('work', oPhone.getTypeFormatted(), 'Phone formatting is incorrect');
        System.assertEquals('111-222-3333 (work)', oPhone.getPhoneNumberWithType(), 'Phone formatting along with type is incorrect');
        
        System.assertEquals(false, oPhone.isMobilePhone(), 'Mobile phone decision is not correct');
        oPhone.Type = 'cell';
        System.assertEquals(true, oPhone.isMobilePhone(), 'Mobile phone decision is not correct');
        
        Test.stopTest();
    }
    @isTest (OnInstall=false)
    
    private static void test_getters() {
        Test.startTest();
         Set<String> s = new Set<string>();
         s.add('hello');
         CNData.CNContact c =  new CNData.CNContact();
         c.sources = s;
         system.assert(c.sources.size()>0);
         c.company = new CNData.CNCompany();
         system.assertNotEquals(null,c.company);
         CNData.CNRelationship cr = new  CNData.CNRelationship();
         List<CNData.CNRelationship> lr = new List<CNData.CNRelationship>();
         lr.add(cr);
         c.relationships = lr;
         system.assertNotEquals(null,c.relationships);           
         c.normalizedScore = 2;
         system.assertEquals(2,c.normalizedScore );
         c.score  = 2.00;
         system.assertEquals(2.00,c.score );
         c.workingLocation  = 'test location';
         system.assertEquals('test location',c.workingLocation );
         List<String> i = new List<String>();
         i.add('test1');
         i.add('test2');
         c.identifiers = i;
         system.assertEquals(c.identifiers.size(),2);
         c.IsDeleted = false;
         system.assertEquals(false,c.IsDeleted);
         c.LastModificationTime = '2015-08-13T19:34:22.000Z';
         system.assertEquals('2015-08-13T19:34:22.000Z',c.LastModificationTime);
         DateTime d = DateTime.parse('11/6/2014 12:00 AM');
         c.LastModificationTimeAlt = d;
         system.assertEquals(d,c.LastModificationTimeAlt); 
         c.NumberOfRelationships = 22;
         system.assertEquals(22,c.NumberOfRelationships);
         List<CNData.CNAddress> addresses = new List<CNData.CNAddress>();
         CNData.CNAddress ad = new CNData.CNAddress();
         addresses.add(ad);
         c.addresses = addresses;
         system.assertEquals(c.addresses.size(),1);
         CNPaginator paginator = new CNPaginator();
         C.paginator = paginator;
         system.assertNotEquals(null,c.paginator);
         system.assertEquals(c.getIsSignatureSource(),false);
         system.assertEquals(c.getMobilePhoneNumber(),null);
         system.assertNotEquals(null,c.getConcatenatedPhones());
         system.assertEquals('',c.getConcatenatedEmails());
         CNData.CNColleague cc = new CNData.CNColleague();
         cc.department = 'development';
         system.assertEquals('development', cc.department);
        
         CnData.CNCompany cdcnc = new CnData.CNCompany();
        cdcnc.IsOa = true;
        System.assert(cdcnc.IsOa);
         cdcnc.CNID = '500123456';
         system.assertEquals('500123456',cdcnc.CNID);
         List<CNData.CNContact> cdcd = new List<CNData.CNContact>();
         cdcd.add(c);
         cdcnc.contacts = cdcd;
         system.assertNotEquals(cdcd.size(),0);
         cdcnc.firmOrganizationScore = 8.00;
         system.assertEquals(8.00,cdcnc.firmOrganizationScore);
        cdcnc.hasRelationship= true;
        system.assertEquals(true,cdcnc.hasRelationship);
        cdcnc.isClient = true;
        system.assertEquals(true,cdcnc.isClient);
        cdcnc.companyName = 'Test Company';
        system.assertEquals('Test Company',cdcnc.companyName);
        cdcnc.normalizedFirmOrganizationScore = 37;
        system.assertEquals(37,cdcnc.normalizedFirmOrganizationScore);
        cdcnc.relationships = lr;
        system.assertNotEquals(null,cdcnc.relationships);
        cdcnc.sources = s;
        system.assertNotEquals(null,cdcnc.sources);
        cdcnc.identifiers = i;
        system.assertNotEquals(null,cdcnc.identifiers);
        cdcnc.IsDeleted = false;
        system.assertEquals(false,cdcnc.IsDeleted);
        cdcnc.NumberOfColleagues = 245;
        system.assertEquals(245,cdcnc.NumberOfColleagues);
        cdcnc.NumberOfContacts = 1025;
        system.assertEquals(1025,cdcnc.NumberOfContacts);
    Test.stopTest();
    }
    
    @isTest(seeAllData = true)
    private static void testRelationshipCompareTo() {
        Test.startTest();
        CNData.CNContact contact = new CNData.CNContact();
        contact.score = 1;
        contact.lastName = 'Watson';
        contact.title = 'Doctor';
        contact.recencyNumber = 1;
        contact.emailAddresses.Add('jwatson@baiker.com');
        contact.emailAddresses.Add('jwatson221@baiker.com');
        
        CNData.CNRelationship rSource = new CNData.CNRelationship();
        rSource.display = true;
        rSource.contact = contact;
        CNData.CNRelationship rTarget = new CNData.CNRelationship();
        rTarget.display = true;
        rTarget.contact = contact;
        
        {
            CNData.whichSort = 'inner';
            
            CNData.innersortBy = 'innerscoreAsc';
            System.assertEquals(0, rSource.compareTo(rTarget), 'contact.scores are not equal'); // contact.score equal            
            CNData.innersortBy = 'innerscoreDesc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.scores are not equal'); // contact.score equal
    
            CNData.innersortBy = 'innernameAsc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.lastName');            
            CNData.innersortBy = 'innernameDesc';
            System.assertEquals(0, rSource.compareTo(rTarget), 'contact.lastName');
            
            CNData.innersortBy = 'innertitleAsc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.title');        
            CNData.innersortBy = 'innertitleDesc';
            System.assertEquals(0, rSource.compareTo(rTarget), 'contact.title');
            
            CNData.innersortBy = 'inneremailAsc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.emailAddresses');        
            CNData.innersortBy = 'inneremailDesc';
            System.assertEquals(0, rSource.compareTo(rTarget), 'contact.emailAddresses');
            
            CNData.innersortBy = 'innerrecencyAsc';
            System.assertEquals(0, rSource.compareTo(rTarget), 'contact.recencyNumber');        
            CNData.innersortBy = 'innerrecencyDesc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.recencyNumber');
            
            CNData.innersortBy = 'UNKNOWN';
            System.assertEquals(-1, rSource.compareTo(rTarget), '-1');
        }
        
        {
            CNData.whichSort = 'NOT_EXISTS';
            CNData.sortBy = 'emailAsc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.emailAddresses');        
            CNData.innersortBy = 'emailDesc';
            System.assertEquals(1, rSource.compareTo(rTarget), 'contact.emailAddresses');
            
            CNData.sortBy = 'NOT_EXISTS';
            System.assertEquals(-1, rSource.compareTo(rTarget), '-1');            
        }
        
        Test.stopTest();
    }
    
    @isTest(seeAllData=true)
    private static void testProps(){        
        test.startTest();       
        CNData.CNRelationship cn1 = new CNData.CNRelationship();
        cn1.display = true;     
        CNAppUtils cau = new CNAppUtils();
        CN_App_Settings__c cvb = CNAppUtils.getAppCustomSetting();      
        cn1.setShowColleagueEmailData(true);
        system.assertEquals(true,cn1.getShowColleagueEmailData());
        
        cn1.setShowColleaguePhoneData(true);
        system.assertEquals(true,cn1.getShowColleaguePhoneData());
        
        cn1.setShowColleagueRecency(true);
        system.assertEquals(true,cn1.getShowColleagueRecency());
        
        cn1.setShowColleagueRelationshipStrength(true);
        system.assertEquals(true,cn1.getShowColleagueRelationshipStrength());
        cn1.setShowColleagueSource(true);
        system.assertEquals(true,cn1.getShowColleagueSource());
        cn1.setShowColleagueTitle(true);
        system.assertEquals(true,cn1.getShowColleagueTitle());
        cn1.setShowContactEmailData(true);
        system.assertEquals(true,cn1.getShowContactEmailData());
        cn1.setShowContactLocation(true);
        system.assertEquals(true,cn1.getShowContactLocation());
        cn1.setShowContactPhoneData(true);
        system.assertEquals(true,cn1.getShowContactPhoneData());
        cn1.setShowContactRecency(true);
        system.assertEquals(true,cn1.getShowContactRecency());
        cn1.setShowContactRelationshipStrength(true);
        system.assertEquals(true,cn1.getShowContactRelationshipStrength());
        cn1.setShowContactSource(true);
        system.assertEquals(true,cn1.getShowContactSource());
        cn1.setShowContactSource(true);
        system.assertEquals(true,cn1.getShowContactSource());
        cn1.setShowContactTitle(true);
        system.assertEquals(true,cn1.getShowContactTitle());
        cn1.setShowEmailData(true);
        system.assertEquals(true,cn1.getShowEmailData());
        cn1.setShowPhoneData(true);
        system.assertEquals(true,cn1.getShowPhoneData());
        cn1.setshowContactEmail(true);
        system.assertEquals(true,cn1.getshowContactEmail());
        cn1.setshowContactPhone(true);
        system.assertEquals(true,cn1.getshowContactPhone());
        cn1.setenableContactActionColumn(true);
        system.assertEquals(true,cn1.getenableContactActionColumn());
        cn1.setenableContactSearchColumn(true);
        system.assertEquals(true,cn1.getenableContactSearchColumn());
        cn1.setenableContactAddColumn(true);
        system.assertEquals(true,cn1.getenableContactAddColumn());       
        
        cn1.setShowColleagueLocation(true);
        system.assertEquals(false,cn1.getShowColleagueLocation());
        
        CNData.CNIndustry cni = new CNData.CNIndustry();
        cn1.industry=cni;
        system.assertEquals(cni,cn1.industry); 
        cn1.isSensitiveData=true;
        system.assertEquals(true,cn1.isSensitiveData);     
        cn1.d1='1';
        system.assertEquals('1',cn1.d1); 
        cn1.d2 = '2';
        system.assertEquals('2',cn1.d2);
        cn1.d3 = '3';
        system.assertEquals('3',cn1.d3);  
        cn1.d4 = '4';
        system.assertEquals('4',cn1.d4);
        cn1.d5 = '5';
        system.assertEquals('5',cn1.d5);
        cn1.d6 = '6';
        system.assertEquals('6',cn1.d6);
        cn1.d7 = '7';
        system.assertEquals('7',cn1.d7);
        CNDAta.innerTableData itd = new CNDAta.innerTableData();
        CNDAta.CNRelationship cnr = new CNDAta.CNRelationship();
        cnr.Type='toContact';
        cnr.score=4.34;
        cnr.normalizedScore=4;
        cnr.colleague = new CNDAta.CNColleague();
        cnr.contact = new CNData.CNContact();
        cnr.company = new CNData.CNCompany();
        CNDAta.CNContact con = new CNDAta.CNContact();
        con.POBox= '123';
        con.StreetAddress= '12312some streeet';
        con.Locality= ' my locality';
        con.Region= 'the region';
        con.PostalCode='02116';
        con.recencynumber=45;
        con.lastname= 'test1';
        
        // Email sort ASC       
        CNDAta.sortBy='emailAsc';
        CNDAta.innersortBy='inneremailAsc';
        CNDAta.whichSort='outer';
        system.assertNotEquals(con.getIsVisitSource(),null);
        system.assertNotEquals(con.getIsAccntMgr(),null);
        system.assertNotEquals(con.getIsIARelationship(),null);
        system.assertNotEquals(con.getIsReferral(),null);
        CNDAta.CNWebserviceResult cws = new CNDAta.CNWebserviceResult();
        cws.listRelationships = new List<CNData.CNRelationship>();
        cws.listContacts = new List<CNData.CNContact>();
        cws.sContactCNID = 'cn123456';
        cws.sCompanyCNID = 'cn098765';
        cws.iTotalRelationships = 100;
        cws.errorFound = false;
        CNDAta.innerTableData itd1 = new CNDAta.innerTableData();
        itd1.relationshipListFull = new List<CNData.CNRelationship>();
        itd1.relationshipListDisplayPage = new List<CNData.CNRelationship>();
        itd1.CNID = 'cn12345';
        itd1.pagerStartNumber = 5;
        itd1.pagerEndNumber = 10;
        itd1.pagerCurrentNumber = 7;

        itd1.sortOrder = 'emailAsc';
        itd1.typeOf = 'outer';
        itd1.hiddenColleagueRelationshipExpanded = new CNData.CNRelationship();
        itd1.hiddenContactRelationshipExpanded = new CNData.CNRelationship();
        itd1.lastIndex = 23;
        cnr.checkForSensitiveData();
        cnr.contact = con;
        CNData.CNContact con1 = new CNDAta.CNContact();
        con1.POBox= '123';
        con1.StreetAddress= '12312some streeet';
        con1.Locality= ' my locality';
        con1.Region= 'the region';
        con1.PostalCode='02116';
        con1.recencynumber=45;
        con1.lastname= 'test2';
        CNDAta.CNRelationship cnr1 = new CNDAta.CNRelationship();
        cnr1.Type='toContact';
        cnr1.score=4.35;
        cnr1.normalizedScore=4;      
        cnr1.contact = con1; 
        
        CNData.sortBy='nameAsc';
        List<CNDAta.CNRelationship> cnlist = new List<CNDAta.CNRelationship>();
        cnlist.add(cnr);
        cnlist.add(cnr1);
        cnlist.sort();
        
        CNData.sortBy='nameAsc';
        CNDAta.whichSort='outer';
        cnlist.sort(); 
        CNData.sortBy='nameDesc';
        cnlist.sort(); 
        CNData.sortBy='titleAsc'; 
        cnlist.sort();
        CNData.sortBy='titleDesc';
        cnlist.sort(); 
        CNData.sortBy='scoreAsc'; 
        cnlist.sort();
        CNData.sortBy='scoreDesc';
        cnlist.sort(); 
        CNData.sortBy='recencyAsc'; 
        cnlist.sort();
        CNData.sortBy='recencyDesc';
        cnlist.sort();
        itd1.sortOrder = 'innerscoreAsc';
        itd1.typeOf = 'inner';
        itd1.relationshipListFull.sort(); 
        itd1.sortOrder = 'inneremailAsc';
        itd1.relationshipListFull.sort(); 
        test.stopTest();
    }
    @isTest
    private static void testPageMessages(){
        test.startTest();
            myException x =  new myException();
            CNData.CNExceptionInfo exClass = new CNData.CNExceptionInfo(x,ApexPages.Severity.ERROR,
            'testclassname','sMethodName','sMoreInfo',false,false,'test subject'); 
            //system.assertEquals(exClass.oExp,x);
            system.assertEquals(exClass.oSeverity,ApexPages.Severity.ERROR);
            system.assertEquals(exClass.sClassName,'testclassname');
            system.assertEquals(exClass.sMethodName,'sMethodName');
            system.assertEquals(exClass.sMoreInfo,'sMoreInfo');
            system.assertEquals(exClass.bAddToPage,false);
            system.assertEquals(exClass.bSendEmail,false);
            system.assertEquals(exClass.sEmailSubject,'test subject');
            system.assertEquals(exClass.bAddDebugInfoToPage,true);
            exClass = new CNData.CNExceptionInfo('this is a test',ApexPages.Severity.ERROR,'testclassname',
            'sMethodName','sMoreInfo',false,false,false,'test subject');    
            system.assertEquals(true,exClass.bAddDebugInfoToEmail,false);
        test.stopTest();
    }
    private class myException extends Exception{
        Exception myException(){
            return null;
        }
    }
}