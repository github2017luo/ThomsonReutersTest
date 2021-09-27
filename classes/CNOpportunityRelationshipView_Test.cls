/**
* {Purpose} � Test class for CNOpportunityRelationshipViewController
*
* @author   Glen Cunningham
* @version  2015-12-23
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 2015-12-23    Glen Cunningham     Created      
* 2017-01-11    Denis Mitropolsky   Decreased number of iterations, modev to constant
*
* =============================================================================
*/

@isTest(seeAllData=true)
public   class CNOpportunityRelationshipView_Test {
    @isTest(seeAllData=true)
    private static void testAccountColleagueRelationshipsBasic() {
        //Setup test data 
        //now with an existing opportunity
        Account oAccount = CNUnitTest.getAccount(true);
        oAccount.Name = 'Microsoft';
        oAccount.Website = 'https://www.microsoft.com';
        update oAccount;
        Opportunity oppT = new Opportunity();
        oppT.AccountId = oAccount.Id; 
        oppT.CloseDate = system.today();
        oppT.Name = 'testsomeneme';
        oppT.StageName = 'Prospecting';
        upsert oppT;
        system.assertNotEquals(oAccount,null);      
        Test.setCurrentPage(Page.CNOpportunityView);
        ApexPages.StandardController oController = new ApexPages.StandardController(oppT);
        ApexPages.currentPage().getParameters().put('id', oppT.Id);
        system.assertNotEquals(oController,null);
        CNOpportunityRelationshipViewController cavc = new CNOpportunityRelationshipViewController(oController);
        Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());  
        CNAppUtils_14.AUTHTOKEN = 'FB2B02BEE0F652AADF7035CC831EBF73596EC884728758895CF8B1238E86AB5C4F98AA4711EFDF116669E9B3EC71F28169DD18507C0AD36FB55D778105D2C30D57221C383421488334ACF808477E22F613CABA9C1DC9760A734FC075DC4D4173'; 
        HttpResponse httpRes1 = new HttpResponse(); 
        httpRes1.setHeader('Content-Type', 'application-json');
        httpRes1.setBody('{"status":"ok","token":"_1OJRddzDLTJMxJ3AqGgLZLpUmSV32gpSlMuxMbPJY1iNfC6CCnCmpnMOOZAQBqs","userId":1,"userAccessGroupId":2,"fullName":"Local Admin","features":{"hasAddToBDSList":false,"hasAllowedToLogin":true,"hasColleagueExpansion":true,"hasCompanyExpansion":true,"hasContactExpansion":true,"hasCorporateIntelligenceShowNetworkUpdates":true,"hasDashboardShowNetworkUpdates":true,"hasEnableSignatureViewing":true,"hasExternalSync":true,"hasFirmReportsActivities":true,"hasFirmReportsCompanyOverview":true,"hasFirmReportsContactOverview":true,"hasFirmReportsFriendlyColleagues":true,"hasFirmReportsIndustryGroupOverview":true,"hasFirmReportsNewRelationships":true,"hasFirmReportsRelationshipsByTitle":true,"hasFirmReportsSearchExport":true,"hasFirmReportsUsageReport":true,"hasIndustryExpansion":true,"hasLocationExpansion":true,"hasNetworkUpdatesShowCalendarAppointments":true,"hasNetworkUpdatesShowNewRelationships":true,"hasNetworkUpdatesShowRoleChanges":true,"hasSavedSearchesCreateAndEdit":true,"hasSearchBulkEmail":true,"hasSearchColleagues":true,"hasSearchCompanies":true,"hasSearchContacts":true,"hasSearchIndustries":true,"hasSearchLocations":true,"hasSearchResultsColleagues":true,"hasSearchResultsCompanies":true,"hasSearchResultsContacts":true,"hasSearchResultsIndustries":true,"hasSearchResultsLocations":true,"hasSearchResultsNewColleagues":true,"hasSearchResultsNewContacts":true,"hasSearchResultsOutOfTouchContacts":true,"hasSearchResultsOutOfTouchPersonal":true,"hasSearchResultsStrongRelationships":true,"hasSearchResultsViews":true,"hasSharingAddressBook":true,"hasSharingCalendar":true,"hasSharingMail":true,"hasShowSourcedSignatures":true,"hasShowVCard":true,"hasSyncAddressBook":true,"hasSyncCalendar":true,"hasSyncMail":true,"hasSyncSignatures":true,"hasUserAdmin":true}}');
        httpRes1.setStatusCode(200);  
        CNAppUtils_14.oHttpResponse = httpRes1;  
        CNAppUtils_14.getResponse('https://get.test.foo', 6, 'GET', '', '', 'application/json', '');  
        ApexPages.currentPage().getParameters().put('id',oAccount.Id);
        ApexPages.currentPage().getParameters().put('token','ey0Jsdjubiouewbfrgoiboigbewwib');
        ApexPages.currentPage().getParameters().put('expires','3600'); 
        cavc.init();         
         
        CN_App_Settings__c cnapp = [SELECT Enable_Contact_Add_Action__c,Enable_Contact_Search_Action__c,Show_Colleague_Email_Data__c,Show_Colleague_Location__c,Show_Colleague_Phone_Data__c,Show_Colleague_Recency__c,Show_Colleague_Relationship_Strength__c,Show_Colleague_Source__c,Show_Colleague_Title__c,Show_Contact_Email_Data__c,Recency_as_Date__c,Show_Contact_Location__c,Show_Contact_Phone_Data__c,Show_Contact_Recency__c,Show_Contact_Relationship_Strength__c,Show_Contact_Source__c,Show_Contact_Title__c,Show_Email_Data__c,Show_Phone_Data__c FROM CN_App_Settings__c];
            system.assertEquals(cavc.ShowContactRecency, cnapp.Show_Contact_Recency__c);
            system.assertEquals(cavc.ShowContactSource, cnapp.Show_Contact_Source__c);
            system.assertEquals(cavc.ShowContactEmailData, cnapp.Show_Contact_Email_Data__c);
            system.assertEquals(cavc.ShowContactPhoneData, cnapp.Show_Contact_Phone_Data__c);
            system.assertEquals(cavc.ShowContactTitle, cnapp.Show_Contact_Title__c);
            system.assertEquals(cavc.ShowContactRelationshipStrength, cnapp.Show_Contact_Relationship_Strength__c);
            system.assertEquals(cavc.enableContactActionColumn, cnapp.Enable_Contact_Add_Action__c || cnapp.Enable_Contact_Search_Action__c);
            system.assertEquals(cavc.ShowColleagueRecency, cnapp.Show_Colleague_Recency__c);
            system.assertEquals(cavc.ShowColleagueSource, cnapp.Show_Colleague_Source__c);
            system.assertEquals(cavc.ShowColleagueEmailData, cnapp.Show_Colleague_Email_Data__c);
            system.assertEquals(cavc.ShowColleaguePhoneData, cnapp.Show_Colleague_Phone_Data__c);
            system.assertEquals(cavc.ShowColleagueTitle, cnapp.Show_Colleague_Title__c);
            system.assertEquals(cavc.ShowColleagueRelationshipStrength,     cnapp.Show_Colleague_Relationship_Strength__c);
            system.assertEquals(cavc.ShowColleagueLocation, cnapp.Show_Colleague_Location__c); 
        
         
        cavc.init();
        //set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Vcard":null,"Phone":null,"Relationships":[{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9501","Industry":null,"MailingAddress":null,"HasVisibleSignatures":true,"FirstName":"Thomas","LastName":"Boyle","Title":"Senior Director, Finance","Email":"thomas.boyle@pepsi.com","Id":1659122,"Strength":5.0,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-236-1900 x281","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"James","LastName":"Bynoe","Title":"Litigation Attorney / Team Leader","Email":"james.bynoe@pepsi.com","Id":1686925,"Strength":4.34,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-654-3802","Industry":null,"MailingAddress":null,"HasVisibleSignatures":true,"FirstName":"Chuck","LastName":"Gary","Title":"Senior Consultant, Corporate Strategy And Research","Email":"charles.gray@pepsi.com","Id":1699943,"Strength":4.15,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9500 x42716","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Steven","LastName":"Hansen","Title":"Portfolio Underwriter","Email":"steve.hansen@pepsi.com","Id":1688032,"Strength":4.04,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"914-253-2549","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Mark","LastName":"Lewis","Title":"Tax Department","Email":"mark.lewis@pepsi.com","Id":1707648,"Strength":3.77,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9500 x42499","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Alan","LastName":"Matthews","Title":"Senior Director of Information Technology","Email":"almatthews@pepsi.com","Id":1707562,"Strength":3.59,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9500 x42499","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Danette","LastName":"Perry","Title":"Senior Counsel","Email":"danette.perry@pepsi.com","Id":1648016,"Strength":3.59,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":null}],"NumResults":7}');
        httpRes.setStatusCode(200);  
        CNAppUtils_14.oHttpResponse = httpRes;     
        //
        cavc.init();
        
        ApexPages.currentPage().getParameters().put('colleagueCNID', '1299');
        CNAppUtils.sHttpBodyInTestContext = CNUnitTest.getArrayOfRelationshipXML(2);         
        cavc.loadContactsForSingleColleague();
        
        CNData.CNRelationship h = cavc.hiddenColleagueRelationshipExpanded;
        system.assertEquals(null,h);
        CNData.CNRelationship h1 = cavc.hiddenContactRelationshipExpanded; 
        system.assertEquals(null,h1);
        system.assertEquals(null,cavc.isDownloadMode);              
        System.assertEquals(cavc.colleaguePaginator, null);
        System.assertNotEquals(cavc.getErrorsFound(), false, 'Error identification logic is not working');
        System.assertNotEquals(null, cavc.getAppSetting(), 'Custom setting retrieval is not working');
        System.assertEquals(false, cavc.getIsEnhancedList(), 'Enhanced list check is not working');
        List<CNData.CNRelationship> kl = new List<CNData.CNRelationship>(); 
        cavc.debugemail = kl;
        cavc.sContactCNID = '623456';
        cavc.searchText = 'abc';
        cavc.searchTextcoll = '123'; 
        //load the paginators
        cavc.relationshipsForContact = new List<CNData.CNRelationship>();
        cavc.relationshipsforcolleague = new List<CNData.CNRelationship>();
        cavc.relationshipsForColleagueUnPaged = new List<CNData.CNRelationship>();
        cavc.relationshipsForContactUnPaged = new List<CNData.CNRelationship>();
        final integer CnCount = 50;// 300;
        for(integer i=0;i< CnCount;i++){         
            CNDAta.CNContact con = new CNDAta.CNContact();      //<CNData.CNRelationship> relationships;
            con.lastname = 'testme' + string.valueOf(i);
            if(math.Mod(i,5)==0){con.lastname = '';con.firstname='test@foo.' + string.valueOf(i);}
            con.title = 'boss' + string.valueOf(i);
            if(math.Mod(i,3)==0){con.title = '';}
            if(math.Mod(i,5)==0){con.title = null;}
            con.score = 1+i;
            con.workinglocation = (math.Mod(i,2)==0)?'mars':'';
            if(math.Mod(i,5)==0){con.workinglocation = null;}
            con.emailAddresses.add('test@foo.' + string.valueOf(i));
            //if(math.Mod(i,3)==0){con.emailAddresses = null;}
            CNDAta.CNColleague coll = new CNDAta.CNColleague();
            coll.lastname = 'colltestme' + string.valueOf(i);
            if(math.Mod(i,5)==0){coll.lastname = '';coll.firstname='test@foo.' + string.valueOf(i);}
            coll.title = 'boss' + string.valueOf(i);
            if(math.Mod(i,3)==0){coll.title = '';}
            if(math.Mod(i,5)==0){coll.title = null;}
            coll.score = 1+i;
            coll.workinglocation = (math.Mod(i,2)==0)?'mars':'';
            if(math.Mod(i,5)==0){coll.workinglocation = null;}
            coll.emailAddresses.add('test@foo.' + string.valueOf(i));
            //if(math.Mod(i,3)==0){coll.emailAddresses = null;}
            CNDAta.CNRelationship cnr1 = new CNDAta.CNRelationship();
            cnr1.colleague = coll;
            CNDAta.CNRelationship cnr2 = new CNDAta.CNRelationship();
            cnr2.contact = con;
            //cavc.colleagueDetailPaginator.add(cnr1);
            //cavc.contactDetailPaginator.add(cnr2); 
            if(i<10){
                cavc.relationshipsForContact.add(cnr1);
                cavc.relationshipsforcolleague.add(cnr2);
            }
            cavc.relationshipsForColleagueUnPaged.add(cnr2);
            cavc.relationshipsForContactUnPaged.add(cnr1); 
        } 

        cavc.relationshipsForColleagueUnPaged[5].contact.cnid='1299';
        cavc.relationshipsForColleague[1].contact.cnid='1299';

        cavc.searchName = true;
        cavc.searchTitle = true;
        cavc.searchEmail = true;
        cavc.searchLocation = true;
        cavc.paginator = new CNPaginator();
        cavc.innerpageSize = 10; 
        cavc.ShowContactRecency = true;
        cavc.ShowContactSource = true;
        cavc.ShowContactEmailData = true;
        cavc.ShowContactPhoneData = true;
        cavc.ShowContactTitle = true;
        cavc.ShowContactRelationshipStrength = true;
        cavc.enableContactActionColumn = true;
        cavc.ShowColleagueRecency = true;
        cavc.ShowColleagueSource = true;
        cavc.ShowColleagueEmailData = true;
        cavc.ShowColleaguePhoneData = true;
        cavc.ShowColleagueTitle = true;
        cavc.ShowColleagueRelationshipStrength = true;
        cavc.ShowColleagueLocation = true;
        /*cavc.ShowRecencyAsDate = true;
        cavc.displayoauthPopUp = true;
        cavc.cookie = 'ewrfg2e562435tfgqrewfg1q3454316451t3';
        cavc.showOAuth = true;
        cavc.oAuthPWDnew1 = 'newpassword';
        cavc.oAuthPWDnew2 = 'newpassword';
        cavc.sColleagueCNID = 'cn231425';*/
        cavc.contactPaginator = new CNPaginator();
        cavc.colleagueDetailPaginator = new CNPaginator();
        cavc.contactDetailPaginator = new CNPaginator(); 
        //cavc.relationshipsForContact = new List<CNData.CNRelationship>();
        //cavc.relationshipsForColleagueUnPaged = new List<CNData.CNRelationship>();
        //cavc.relationshipsForContactUnPaged = new List<CNData.CNRelationship>();
        cavc.hiddenColleagueRelationshipExpanded = new CNData.CNRelationship();
        cavc.hiddenContactRelationshipExpanded = new CNData.CNRelationship();
        cavc.isDownloadMode = false;
        cavc.serviceDown = false;
        cavc.showPageLoadingMsg = false;  
        cavc.sSelectedTab = 'contact';
        cavc.sAcctId = '0001002345023456aac';
        cavc.noDataMessage = 'haha';
        cavc.useGlobalSearch = false;
        cavc.isSensitiveData = false;  
        cavc.showContactEmail = true;
        cavc.showContactPhone = true;
        //cavc.oAuthUser = 'someone';
        //cavc.oAuthPwd = 'topsecret';
        cavc.actionDelimiter = '|';
        //cavc.WhichSort = 'outer'; 
        cavc.innerColleagueID = 'wergt564325ftg';
        cavc.innerContactID = '324534rfewdqf';
        
        cavc.iTotalInnerPages = 3;
        cavc.iTotalInnerRecords = 29;
        
        cavc.getiCurrentInnerPage();
        //cavc.updatePassword();
        cavc.setiCurrentInnerPage(4);
        system.assertEquals(cavc.getiCurrentInnerPage(),4);
        system.assertEquals(cavc.iStartInnerPage,1);
        system.assertEquals(cavc.iEndInnerPage,4);
        
        cavc.setiCurrentInnerPagecoll(9);
        system.assertEquals(cavc.iTotalInnerPagescoll, CnCount / 10);  // 30
        system.assertEquals(cavc.getiCurrentInnerPagecoll(),9);
        system.assertEquals(cavc.iStartInnerPagecoll,6); 
        system.assertEquals(cavc.iEndInnerPagecoll,0);
        
        cavc.setiCurrentInnerPage(6);
        system.assertEquals(cavc.iStartInnerPage,6);
        system.assertEquals(cavc.iEndInnerPage,CnCount / 10);
        
        cavc.setiCurrentInnerPagecoll(4);
        system.assertEquals(cavc.iStartInnerPagecoll,1); 
        system.assertEquals(cavc.iEndInnerPagecoll,4);
        cavc.closePopup();
        system.assertEquals(cavc.displayPopup,false);
        cavc.showPopup();
        system.assertEquals(cavc.displayPopup,true);
        /*cavc.closeoauthPopup();
        system.assertEquals(cavc.showOAuth,false);
        cavc.submitoauthPopup();
        system.assertEquals(cavc.showOAuth,false);
        cavc.sHREF = 'boo';
        system.assertEquals('boo',cavc.sHref);*/
        cavc.iTotalInnerPages = 5;
        cavc.icurrentinnerpage = 2;
        cavc.iStartInnerPage = 1;
        
        cavc.innerlast();
        cavc.innerfirst();
        cavc.innernext();
        cavc.innerprevious();
        cavc.setiCurrentInnerPage(3);
        cavc.innerpageSize = 10;
        cavc.iCurrentInnerPage = 8;//12;
        cavc.innerpagebynumber();
        cavc.innerElipsis();
        system.assertEquals(cavc.getinnerEndOfPages(),1);
        system.assertEquals(cavc.getinnerEndOfPagesCol(),1);
        cavc.setiCurrentInnerPage(6);//616);
        cavc.iStartInnerPage = 4;//6;
        cavc.innerbackElipsis();
        cavc.innerpagebynumbercoll();
        cavc.innerfirstcoll();
        cavc.innerlastcoll();
        cavc.innernextcoll();
        cavc.innerpreviouscoll();
        cavc.innerElipsiscoll();
        cavc.innerbackElipsiscoll();
        cavc.getinnerEndOfPagescoll();
        cavc.debug();
        cavc.innerSortDataBycoll();
        cavc.innerSortDataBy();
        cavc.loadContactsForSingleColleague();
        cavc.loadColleaguesForSingleContact();
        cavc.getErrorsFound();
        cavc.getAppSetting();
        cavc.getIsEnhancedList();
        //cavc.getDisplayColleagueTable();
        //cavc.getDisplayContactTable();
        cavc.searchText = 'abc';
        cavc.searchTextcoll = '123';
        cavc.resetSearchCon();
        cavc.searchListsCon();
        cavc.resetSearchColl();
        cavc.searchListsColl();
        cavc.searchText = 'test';
        cavc.searchTextcoll = 'test';
        cavc.resetSearchCon();
        cavc.searchListsCon();
        cavc.resetSearchColl();
        cavc.searchListsColl(); 
        Test.startTest(); 
        
        string sjsonCompany = '{"Collection":[{"Type":16,"Collection":[{"NumColleagues":59,"NumContacts":101,"NumRelationships":124,"HasFamilyTree":true,"Id":"4295907168","DisplayValue":"Microsoft Corp"}],"TotalResults":1}]}';
        CNData_14_AutoComplete cnda = CNData_14_AutoComplete.parse(sjsonCompany);
        CNData_14_AutoComplete.Collection ocoll =  CNData_14_AutoComplete.getSingleItem(0, cnda);
        CNData.CNCompany  oCompany = CNData_14_AutoComplete.MapTo(ocoll);
        string jsonColl = '{"Filters":[{"lowValue":4,"highValue":4,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"}],"name":"sources","on":false,"currentValue":null},{"lowValue":271,"highValue":274,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":307,"highValue":419,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},{"name":"recency","on":false,"currentValue":null},{"values":["Boston"],"name":"office","on":false,"currentValue":null},{"values":["Administrative Support","Secretarial Support"],"name":"department","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Office","RenderType":4,"Fields":["Office"]},{"Title":"Department","RenderType":4,"Fields":["Department"]}],"Results":[{"Office":"Boston","Department":"Secretarial Support","Phone":"","FirstName":"Marina","LastName":"Cordero","Title":"Legal Secretary / Community Service Coordinator","Email":"marcordero@yourcompany.com","Id":537,"Strength":4.16,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-25T00:00:00","Recency":"271 days","RelationshipCount":1},{"Office":"Boston","Department":"Administrative Support","Phone":"","FirstName":"Bryan","LastName":"Winn","Title":"Helpdesk Analyst II","Email":"brywinn@yourcompany.com","Id":529,"Strength":3.67,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-22T00:00:00","Recency":"274 days","RelationshipCount":1}],"NumResults":2,"TrackedSearchId":39353}';
        CNData_14_Colleague oColleagues = CNData_14_Colleague.parse(jsonColl);        
        list<CNData.CNColleague> collist =  CNData_14_Colleague.MapTo(oColleagues.Results, oCompany); 
        string jsoncont = '{"Filters":[{"lowValue":5,"highValue":5,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"},{"id":2,"name":"AddressBook"}],"name":"sources","on":false,"currentValue":null},{"lowValue":315,"highValue":315,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":427,"highValue":1840,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},{"name":"recency","on":false,"currentValue":null},{"lowValue":315,"highValue":315,"name":"userActivity","on":false,"currentValue":null},{"values":[{"id":6,"name":"Executive/Board"}],"name":"seniority","on":false,"currentValue":null},{"values":[],"name":"functions","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Company","RenderType":3,"Fields":["OrganizationName"]}],"Results":[{"PermId":null,"OrganizationId":4295907168,"OrganizationName":"Microsoft Corp","OAId":4295907168,"Phone":"425-703-2006","Industry":"<IndustryGroupPaths><IndustryGroupPath>Information &amp;gt; Publishing Industries (except Internet) &amp;gt; Software Publishers</IndustryGroupPath><IndustryGroupPath>Information &amp;gt; Publishing Industries (except Internet) &amp;gt; Newspaper, Periodical, Book, and Directory Publishers &amp;gt; Book Publishers</IndustryGroupPath><IndustryGroupPath>Information &amp;gt; Motion Picture and Sound Recording Industries &amp;gt; Sound Recording Industries &amp;gt; Music Publishers</IndustryGroupPath><IndustryGroupPath>Manufacturing &amp;gt; Computer and Electronic Product Manufacturing &amp;gt; Semiconductor and Other Electronic Component Manufacturing &amp;gt; Printed Circuit Assembly (Electronic Assembly) Manufacturing</IndustryGroupPath><IndustryGroupPath>Manufacturing &amp;gt; Computer and Electronic Product Manufacturing &amp;gt; Manufacturing and Reproducing Magnetic and Optical Media &amp;gt; Magnetic and Optical Recording Media Manufacturing</IndustryGroupPath><IndustryGroupPath>Professional, Scientific, and Technical Services &amp;gt; Computer Systems Design and Related Services &amp;gt; Custom Computer Programming Services</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Satya","LastName":"Nadela","Title":"Chief Executive Officer","Email":"satya.nadela@microsoft.com","Id":2465130,"Strength":4.72,"SourcesBitmask":3,"MostRecentSource":1,"MostRecentSourceDate":"2015-01-12T00:00:00","Recency":"315 days","RelationshipCount":3}],"NumResults":1,"TrackedSearchId":39408}';
        CNData_14_Contact oContacts = CNData_14_Contact.parse(jsoncont);        
        list<CNData.CNContact> conlist =  CNData_14_Contact.MapTo(oContacts.Results, oCompany); 
        
        string sCompanyCNID = CNServices_14.CNCompanyID;//oColleagueService.companyCNID;    
        CNCompanyColleageRelationshipService oColleagueService = new CNCompanyColleageRelationshipService(oAccount.Id, sCompanyCNID, oAccount.Name, 'test.com');      
            system.assertNotEquals(oColleagueService,null,'Colleague Service is null');  
            system.debug('@#$!@#oColleagueService.iTotalRecords=' + oColleagueService.iTotalRecords);
            CNData.CNCompany comp =  CNServices_14.fetchCompany('test.com');    //pulll back company while colleague is not functioning

            CNPaginator colleaguePaginator = new CNPaginator(oColleagueService);  
            //loads contacts
            //    system.debug('invoking contact relationship service with records: ' + oColleagueService.listContactRelationships);

            CNCompanyContactRelationshipService oContactService = new CNCompanyContactRelationshipService(oAccount.Id, sCompanyCNID, oColleagueService.listContactRelationships, oColleagueService.iTotalContactRecords);
            system.debug('******CNCompanyContactRelationshipService call :' + oAccount.Id + ' ' + sCompanyCNID + ' ' + oColleagueService.listContactRelationships + ' ' +oColleagueService.iTotalContactRecords);

            //      
            system.debug('$#@%@#$^%# oContactService: ' + oContactService);
            oContactService.iTotalRecords = oContactService.listData.size();

            CNPaginator contactPaginator = new CNPaginator(oContactService);
        
        
        //cavc.relationshipsForColleagueUnPaged 
        string jsoncollcont = '{"Vcard":null,"Phone":null,"Relationships":[{"PermId":null,"OrganizationId":0,"OrganizationName":null,"OAId":null,"Phone":null,"Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Carl","LastName":"Ichan","Title":"Chairman","Email":"carl.ichan@microsoft.com","Id":2491684,"Strength":4.15,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-03-09T00:00:00","Recency":"259 days","RelationshipCount":null},{"PermId":null,"OrganizationId":0,"OrganizationName":null,"OAId":null,"Phone":null,"Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"","LastName":"","Title":"","Email":"chwillia@microsoft.com","Id":2490774,"Strength":1.24,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2014-06-08T00:00:00","Recency":"1 year<br>168 days","RelationshipCount":null}],"NumResults":2}';
        cavc.colleaguePaginator =  colleaguePaginator;
        cavc.contactPaginator = contactPaginator;
        colleaguePaginator.setinnerSortBy('inneremailAsc');
        CNData.innersortBy = 'inneremailAsc';
        CNData.whichSort = 'inner';
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('inneremailDesc');
        CNData.innersortBy = 'inneremailDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innerlocationAsc');
        CNData.innersortBy = 'innerlocationAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innerlocationDesc');
        CNData.innersortBy = 'innerlocationDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innernameAsc');
        CNData.innersortBy = 'innernameAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innernameDesc');
        CNData.innersortBy = 'innernameDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innerscoreAsc');
        CNData.innersortBy = 'innerscoreAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innerscoreDesc');
        CNData.innersortBy = 'innerscoreDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innertitleAsc');
        CNData.innersortBy = 'innertitleAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innertitleDesc');
        CNData.innersortBy = 'innertitleDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innerrecencyAsc');
        CNData.innersortBy = 'innerrecencyAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        
        colleaguePaginator.setinnerSortBy('innerrecencyDesc');
        CNData.innersortBy = 'innerreencyDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'contact';  
        cavc.innerSortDataBycoll();
        ///////////////////////////////////////////////////////////////////////////////////////////
        contactPaginator.setinnerSortBy('inneremailAsc');
        CNData.innersortBy = 'inneremailAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('inneremailDesc');
        CNData.innersortBy = 'inneremailDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innerlocationAsc');
        CNData.innersortBy = 'innerlocationAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innerlocationDesc');
        CNData.innersortBy = 'innerlocationDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innernameAsc');
        CNData.innersortBy = 'innernameAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innernameDesc');
        CNData.innersortBy = 'innernameDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innerscoreAsc');
        CNData.innersortBy = 'innerscoreAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innerscoreDesc');
        CNData.innersortBy = 'innerscoreDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innertitleAsc');
        CNData.innersortBy = 'innertitleAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innertitleDesc');
        CNData.innersortBy = 'innertitleDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        ApexPages.currentPage().getParameters().put('mode','load');
        cavc.skipexecution();
        
        contactPaginator.setinnerSortBy('innerrecencyAsc');
        CNData.innersortBy = 'innerrecencyAsc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        
        contactPaginator.setinnerSortBy('innerrecencyDesc');
        CNData.innersortBy = 'innerrecencyDesc';
        CNData.whichSort = 'inner'; 
        //cavc.whichSort = 'colleague';  
        cavc.innerSortDataBy();
        ApexPages.currentPage().getParameters().put('mode','load');
        cavc.skipexecution();
        
        cavc.getContactRelationship(cavc.relationshipsForContactUnPaged[1].colleague.cnid, true);
        cavc.getContactRelationship(cavc.relationshipsForContactUnPaged[2].colleague.cnid, false);
        cavc.getColleagueRelationship(cavc.relationshipsForContactUnPaged[1].colleague.cnid, true);
        cavc.getColleagueRelationship(cavc.relationshipsForContactUnPaged[2].colleague.cnid, false);
             
        //relationshipsForColleagueUnPaged.size()>0 && whichSort == 'contact')
        ApexPages.currentPage().getParameters().put('searchCurrentTab','Account');
        ApexPages.currentPage().getParameters().put('searchType','Contact');
        cavc.searchText = 'test';
        cavc.searchListsCon();  
        cavc.resetSearchCon();  
        //
        ApexPages.currentPage().getParameters().put('searchCurrentTab','Account');
        ApexPages.currentPage().getParameters().put('searchType','Colleague');
        cavc.searchTextcoll = 'test';
        cavc.searchListsColl(); 
        cavc.resetSearchColl(); 
         //now with no lead company match
         oAccount = CNUnitTest.getAccount(true);
        oAccount.Website = 'https://www.microsoft.com';
        oAccount.Name = 'Microsoft';
        update oAccount;
        Opportunity oppT1 = new Opportunity();
        oppT1.AccountId = oAccount.Id;
        oppT1.CloseDate = system.Today();
        oppT1.Name = 'FooBarTest';
        oppT1.StageName = 'Qualification';
        upsert oppT1;
        Test.setCurrentPage(Page.CNOpportunityView);
        ApexPages.StandardController oController1 = new ApexPages.StandardController(oppT1);
        ApexPages.currentPage().getParameters().put('id', oppT1.Id);
        system.assertNotEquals(oController1,null);
        CNOpportunityRelationshipViewController cavc1 = new CNOpportunityRelationshipViewController(oController1);
        Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        cavc.loadContactsForSingleColleague();
        Test.stopTest();
    } 
}