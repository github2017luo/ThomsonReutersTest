/**
 * This class contains unit tests for CNServices_14.
 *
 *	
 *
 *
 *
 */
@isTest(seeAllData=true)
private class CNServices_14_Test {
	 
  
   static testMethod void testfetchCompany(){
    	Test.startTest(); 
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();   
        //set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Collection":[{"Type":16,"Collection":[{"NumColleagues":131,"NumContacts":329,"NumRelationships":1421,"HasFamilyTree":true,"Id":"4295903627","DisplayValue":"Cvs Caremark Corporation"}],"TotalResults":1}]}');
        httpRes.setStatusCode(200);              
        CNData.CNCompany d = CNServices_14.fetchCompany('pepsico.com');
        //system.assertNotEquals(null,d);
    	Test.stopTest();
    }
     static testMethod void testAPIVersion(){
    	Test.startTest(); 
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();   
        //set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"LastUpdateTime":"2:06 PM","LastUpdateDate":"2016/01/04","CopyrightYear":"2016","Version":"15.2.0.8105"}');
        httpRes.setStatusCode(200); 
        string d = CNServices_14.ReleaseInfo('https://bdp25de.thomsonreuters.com/api/releaseinfo');
    	Test.stopTest();
    }
    static testMethod void testAutocomplete(){
    	Test.startTest();  
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();  
        //set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Collection":[{"Type":16,"Collection":[{"NumColleagues":131,"NumContacts":329,"NumRelationships":1421,"HasFamilyTree":true,"Id":"4295903627","DisplayValue":"Cvs Caremark Corporation"}],"TotalResults":1}]}');
        httpRes.setStatusCode(200);        	        
        string d = CNServices_14.AutoComplete(1,'cvs.com');
        //system.assertEquals('',d);
    	Test.stopTest();
    }
     
    static testMethod void testLoadCompany(){
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl()); 
        CNServices_14 cn = new CNServices_14();
    	//set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Collection":[{"Type":16,"Collection":[{"NumColleagues":351,"NumContacts":358,"NumRelationships":1049,"HasFamilyTree":true,"Id":"4295904718","DisplayValue":"Pepsico, Inc."}],"TotalResults":1}]}');
        httpRes.setStatusCode(200);  
          
        CNData.CNCompany d = CNServices_14.LoadCompany('','pepsico.com');
        //system.assertNotEquals(null,d);
    	Test.stopTest();
    } 
    
    static testMethod void testfetchCompanyContacts(){
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();    	
        CNData.CNWebserviceResult x =  CNServices_14.fetchCompanyContacts('Pepsico, Inc.', 'pepsico.com', '4295904718', 10,0, false);
    	Test.stopTest();
    }  
      
     
     static testMethod void fetchRelationshipsForColleague(){
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();
    	//set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Vcard":null,"Phone":null,"Relationships":[{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9501","Industry":null,"MailingAddress":null,"HasVisibleSignatures":true,"FirstName":"Thomas","LastName":"Boyle","Title":"Senior Director, Finance","Email":"thomas.boyle@pepsi.com","Id":1659122,"Strength":5.0,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-236-1900 x281","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"James","LastName":"Bynoe","Title":"Litigation Attorney / Team Leader","Email":"james.bynoe@pepsi.com","Id":1686925,"Strength":4.34,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-654-3802","Industry":null,"MailingAddress":null,"HasVisibleSignatures":true,"FirstName":"Chuck","LastName":"Gary","Title":"Senior Consultant, Corporate Strategy And Research","Email":"charles.gray@pepsi.com","Id":1699943,"Strength":4.15,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9500 x42716","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Steven","LastName":"Hansen","Title":"Portfolio Underwriter","Email":"steve.hansen@pepsi.com","Id":1688032,"Strength":4.04,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"914-253-2549","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Mark","LastName":"Lewis","Title":"Tax Department","Email":"mark.lewis@pepsi.com","Id":1707648,"Strength":3.77,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9500 x42499","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Alan","LastName":"Matthews","Title":"Senior Director of Information Technology","Email":"almatthews@pepsi.com","Id":1707562,"Strength":3.59,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null},{"OrganizationId":0,"OrganizationName":null,"Phone":"617-357-9500 x42499","Industry":null,"MailingAddress":null,"HasVisibleSignatures":false,"FirstName":"Danette","LastName":"Perry","Title":"Senior Counsel","Email":"danette.perry@pepsi.com","Id":1648016,"Strength":3.59,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"192 days","RelationshipCount":null}],"NumResults":7}');
        httpRes.setStatusCode(200);  
        CNAppUtils_14.oHttpResponse = httpRes;        
        CNData.CNWebserviceResult x =  CNServices_14.fetchRelationshipsForColleague('681', '4295904718', 10,0);
        system.assertNotEquals(null,x);        
     	Test.stopTest();
    } 
   static testMethod void fetchRelationshipsForContactEmail(){
    	Test.startTest();
    	//set up response
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Collection":[{"Type":1,"Collection":[{"Title":"Senior Director, Finance","OrganizationName":"Pepsico, Inc.","NumColleagues":30,"Id":"1659122","DisplayValue":"Thomas Boyle"}],"TotalResults":1}]}');
        httpRes.setStatusCode(200);  
        CNAppUtils_14.oHttpResponse = httpRes;        
        CNData.CNWebserviceResult x =  CNServices_14.fetchRelationshipsForContactEmail('thomas.boyle@pepsi.com' ,10); 
        system.assertEquals(null,x);
    	Test.stopTest();
    }    
     
     static testMethod void fetchRelationshipsForContactCNID(){
    	Test.startTest();
    	//set up response
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Filters":[{"lowValue":1,"highValue":5,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"},{"id":2,"name":"AddressBook"},{"id":11,"name":"Signature"}],"name":"sources","on":false,"currentValue":null},{"lowValue":119,"highValue":394,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":119,"highValue":441,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},{"name":"recency","on":false,"currentValue":null},{"values":["Boston","Geneva","London","New York"],"name":"office","on":false,"currentValue":null},{"values":["Business & Finance","Employment","Litigation","Real Estate","Secretarial Support"],"name":"department","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Office","RenderType":4,"Fields":["Office"]},{"Title":"Department","RenderType":4,"Fields":["Department"]}],"Results":[{"Office":"New York","Department":"Real Estate","Phone":"","FirstName":"Harry","LastName":"Kimmel","Title":"Partner","Email":"harkimmel@yourcompany.com","Id":301,"Strength":5.12,"SourcesBitmask":8193,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"London","Department":"Real Estate","Phone":"","FirstName":"Troy","LastName":"Lai","Title":"Managing Partner","Email":"troy.lai@yourcompany.com","Id":681,"Strength":5.00,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Geneva","Department":"Real Estate","Phone":"","FirstName":"Nick","LastName":"Schmidt","Title":"Partner","Email":"nicschmidt@yourcompany.com","Id":428,"Strength":4.58,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Boston","Department":"Secretarial Support","Phone":"","FirstName":"Anthony","LastName":"Anderson","Title":"Of Counsel","Email":"Anthony.Anderson@yourcompany.com","Id":649,"Strength":4.50,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Boston","Department":"Employment","Phone":"","FirstName":"Ben","LastName":"Sexson","Title":"Legal Specialist","Email":"bensexson@yourcompany.com","Id":516,"Strength":4.47,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Boston","Department":"Employment","Phone":"","FirstName":"Lauren","LastName":"Ryan","Title":"Associate Account Manager","Email":"lauryan@yourcompany.com","Id":540,"Strength":4.36,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"London","Department":"Real Estate","Phone":"","FirstName":"Steven","LastName":"Kelly","Title":"Associate","Email":"stekelly@yourcompany.com","Id":1015,"Strength":4.32,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Boston","Department":"Real Estate","Phone":"","FirstName":"David","LastName":"Unsworth","Title":"Associate","Email":"davunsworth@yourcompany.com","Id":33097,"Strength":4.15,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Boston","Department":"Real Estate","Phone":"","FirstName":"Chandler","LastName":"Skelly","Title":"Associate","Email":"chaskelly@yourcompany.com","Id":1000,"Strength":3.92,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1},{"Office":"Boston","Department":"Business & Finance","Phone":"","FirstName":"Keith","LastName":"Perez","Title":"Partner","Email":"keiperez@yourcompany.com","Id":441,"Strength":3.70,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":1}],"NumResults":30,"TrackedSearchId":38285}');
        httpRes.setStatusCode(200);  
        CNAppUtils_14.oHttpResponse = httpRes;        
        CNData.CNWebserviceResult x =  CNServices_14.fetchRelationshipsForContactCNID('681', 10, 0, false);
        system.assertNotEquals(null,x);
    	Test.stopTest();
    }         
    //test json error handling
    static testMethod void testJSON(){
    	Test.startTest();
    	//set up response
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('<failed');
        httpRes.setStatusCode(404);  
        CNAppUtils_14.oHttpResponse = httpRes;        
        CNData.CNWebserviceResult x =  CNServices_14.fetchRelationshipsForContactCNID('681', 10, 0, false);
        system.assertNotEquals(null,x);
        boolean b =  CNServices_14.validateJsonData('<failed', 'test api', false); 
        //system.assertNotEquals(true,b);
        b =  CNServices_14.validateJsonData('{"Collection":[{"Type":16,"Collection":[{"NumColleagues":351,"NumContacts":358,"NumRelationships":1049,"HasFamilyTree":true,"Id":"4295904718","DisplayValue":"Pepsico, Inc."}],"TotalResults":1}]}', 'test api', false); 
        system.assertNotEquals(false,b);
    	Test.stopTest();
    }   
    //test fetchAuthenticationCookie(Boolean bForceAuthentication)
    static testMethod void testCookie(){
    	Test.startTest();    	
        CNServices_14 cn = new CNServices_14();
        string b = CNServices_14.fetchAuthenticationCookie(false);
        system.assertNotEquals('',b);
        b = CNServices_14.fetchAuthenticationCookie(true);
        system.assertNotEquals('',b);
    	Test.stopTest();
    }
    //test validate json
    static testMethod void testValidateJSON(){
    	Test.startTest();    	
        CNServices_14 cn = new CNServices_14();
    	Boolean b = CNServices_14.validateJsonData('<this is a test', 'some api', false);
    	system.assertNotEquals(true,b);
    	b = CNServices_14.validateJsonData('{"LastUpdateTime":"10:22 AM","LastUpdateDate":"2015/11/24","CopyrightYear":"2015","Version":"15.2.0.7857"}', 'some api', false);
    	system.assertNotEquals(false,b);
    	Test.stopTest();
    }
     static testMethod void testfetchCompanyColleagues(){
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());   
        CNServices_14 cn = new CNServices_14();
    	//set up response
        HttpResponse httpRes = new HttpResponse(); 
        httpRes.setHeader('Content-Type', 'application-json');
        httpRes.setBody('{"Filters":[{"lowValue":1,"highValue":6,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"},{"id":2,"name":"AddressBook"},{"id":7,"name":"Calendar"},{"id":11,"name":"Signature"}],"name":"sources","on":false,"currentValue":null},{"lowValue":119,"highValue":599,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":119,"highValue":2583,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},{"name":"recency","on":false,"currentValue":null},{"values":["Austin","Barcelona","Boston","Charlotte","Geneva","London","Los Angeles","Madrid","New York","Sydney","Valencia","Washington","Washington DC"],"name":"office","on":false,"currentValue":null},{"values":["Administrative Support","Business & Finance","Commercial Law","Employment","Federal","Finance","Human Resources","Immigration","Information Services","Intellectual Property","Litigation","M & A","Office Services","Public Law","Real Estate","Secretarial Support"],"name":"department","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Office","RenderType":4,"Fields":["Office"]},{"Title":"Department","RenderType":4,"Fields":["Department"]}],"Results":[{"Office":"Charlotte","Department":"Public Law","Phone":"","FirstName":"Timothy","LastName":"Dragelin","Title":"Senior Managing Director","Email":"tim.dragelin@yourcompany.com","Id":479,"Strength":6.16,"SourcesBitmask":8193,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-25T00:00:00","Recency":"123 days","RelationshipCount":4},{"Office":"New York","Department":"Commercial Law","Phone":"","FirstName":"Jack","LastName":"Callahan","Title":"Director of Business Development","Email":"jcallahan@yourcompany.com","Id":533,"Strength":5.71,"SourcesBitmask":513,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-11T00:00:00","Recency":"196 days","RelationshipCount":80},{"Office":"Washington","Department":"Federal","Phone":"","FirstName":"Victor","LastName":"Hitchcox","Title":"Partner","Email":"vichitchcox@yourcompany.com","Id":33120,"Strength":5.54,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-25T00:00:00","Recency":"123 days","RelationshipCount":4},{"Office":"London","Department":"Real Estate","Phone":"","FirstName":"Troy","LastName":"Lai","Title":"Managing Partner","Email":"troy.lai@yourcompany.com","Id":681,"Strength":5.41,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":7},{"Office":"New York","Department":"Real Estate","Phone":"","FirstName":"Harry","LastName":"Kimmel","Title":"Partner","Email":"harkimmel@yourcompany.com","Id":301,"Strength":5.34,"SourcesBitmask":8193,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-28T17:52:18.72","Recency":"119 days","RelationshipCount":5},{"Office":"Boston","Department":"Business & Finance","Phone":"","FirstName":"Erin","LastName":"Young","Title":"Partner","Email":"eriyoung@yourcompany.com","Id":444,"Strength":5.31,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-15T00:00:00","Recency":"133 days","RelationshipCount":1},{"Office":"Boston","Department":"Public Law","Phone":"","FirstName":"Aaron","LastName":"Foulke","Title":"Partner","Email":"aarfoulke@yourcompany.com","Id":476,"Strength":5.28,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-22T00:00:00","Recency":"126 days","RelationshipCount":5},{"Office":"Boston","Department":"Public Law","Phone":"","FirstName":"Carson","LastName":"Halladay","Title":"Human Resources","Email":"carhalladay@yourcompany.com","Id":486,"Strength":5.27,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-18T00:00:00","Recency":"130 days","RelationshipCount":7},{"Office":"Washington","Department":"Federal","Phone":"","FirstName":"Richard","LastName":"Bank","Title":"Partner","Email":"rbank@yourcompany.com","Id":33114,"Strength":5.21,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-25T00:00:00","Recency":"123 days","RelationshipCount":4},{"Office":"London","Department":"Commercial Law","Phone":"","FirstName":"Hannah","LastName":"Leigh","Title":"Director of Marketing","Email":"hleigh@yourcompany.com","Id":536,"Strength":5.20,"SourcesBitmask":1,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-11T00:00:00","Recency":"196 days","RelationshipCount":32}],"NumResults":351,"TrackedSearchId":38280}');
        httpRes.setStatusCode(200);  
        CNAppUtils_14.oHttpResponse = httpRes;          
        Test.setMock(HttpCalloutMock.class, new CNWebServiceMockImpl());         
        CNData.CNWebserviceResult x =  CNServices_14.fetchCompanyColleagues('Pepsico, Inc.', 'pepsico.com', '4295904718', 10,0, false);
        system.assertNotEquals(null,x); 
    	Test.stopTest();
    }  
}