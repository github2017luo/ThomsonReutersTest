/**
 * This class contains unit tests for CNData_14_Colleague_Test

 */
@isTest(seeAllData=true)
private class CNData_14_Contact_Test {

	static testMethod void testParse() {
		string json = '{"Filters":[{"lowValue":1,"highValue":6,"name":"strength","on":false,"currentValue":null},{"values":[{"id":1,"name":"Email"},{"id":2,"name":"AddressBook"},{"id":7,"name":"Calendar"},{"id":11,"name":"Signature"}],"name":"sources","on":false,"currentValue":null},{"lowValue":122,"highValue":590,"name":"firmActivity","on":false,"currentValue":null},{"lowValue":123,"highValue":2660,"name":"newRelationships","on":false,"currentValue":null},{"name":"title","on":false,"currentValue":null},	{"name":"recency","on":false,"currentValue":null},{"lowValue":122,"highValue":590,"name":"userActivity","on":false,"currentValue":null},{"values":[{"id":3,"name":"Entry-Level"},{"id":4,"name":"Mid-Level"},{"id":5,"name":"Management/Advisor"},{"id":6,"name":"Executive/Board"}],"name":"seniority","on":false,"currentValue":null},{"values":[{"id":1,"name":"Engineering/Technology"},{"id":2,"name":"Finance"},{"id":4,"name":"Legal"},{"id":7,"name":"Marketing/PR"},{"id":5,"name":"Sales/Business Development"},{"id":6,"name":"Service/Support"}],"name":"functions","on":false,"currentValue":null}],"ColumnMetaData":[{"Title":"Strength","RenderType":0,"Fields":["Strength"]},{"Title":"Recency","RenderType":1,"Fields":["MostRecentSource","MostRecentSourceDate"]},	{"Title":"Sources","RenderType":4,"Fields":["SourcesBitmask"]},{"Title":"Name","RenderType":2,"Fields":["GivenName","FamilyName"]},{"Title":"Title","RenderType":3,"Fields":["Title"]},{"Title":"Email Address","RenderType":3,"Fields":["Email"]},{"Title":"Company","RenderType":3,"Fields":["OrganizationName"]}],"Results":[{"OrganizationId":4295904718,"OrganizationName":"Pepsico, Inc.","Phone":"1-800-344-0213","Industry":"<IndustryGroupPaths><IndustryGroupPath>Real Estate and Rental and Leasing &amp;gt; Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)</IndustryGroupPath><IndustryGroupPath>Manufacturing &amp;gt; Food Manufacturing &amp;gt; Other Food Manufacturing &amp;gt; Coffee and Tea Manufacturing</IndustryGroupPath><IndustryGroupPath>Manufacturing &amp;gt; Food Manufacturing &amp;gt; Other Food Manufacturing &amp;gt; Flavoring Syrup and Concentrate Manufacturing</IndustryGroupPath><IndustryGroupPath>Wholesale Trade &amp;gt; Merchant Wholesalers, Nondurable Goods &amp;gt; Grocery and Related Product Merchant Wholesalers &amp;gt; Other Grocery and Related Products Merchant Wholesalers</IndustryGroupPath><IndustryGroupPath>Wholesale Trade &amp;gt; Wholesale Electronic Markets and Agents and Brokers &amp;gt; Business to Business Electronic Markets</IndustryGroupPath><IndustryGroupPath>Wholesale Trade &amp;gt; Wholesale Electronic Markets and Agents and Brokers &amp;gt; Wholesale Trade Agents and Brokers</IndustryGroupPath><IndustryGroupPath>Retail Trade &amp;gt; Miscellaneous Store Retailers &amp;gt; Other Miscellaneous Store Retailers &amp;gt; Pet and Pet Supplies Stores</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":"<Address><PostalCode>32070</PostalCode></Address>","HasVisibleSignatures":true,"FirstName":"Thomas","LastName":"Spratt","Title":"Assistant Vice President","Email":"thomas.spratt@pepsi.com","Id":1669790,"Strength":6.00,"SourcesBitmask":8193,"MostRecentSource":1,"MostRecentSourceDate":"2015-02-10T00:00:00","Recency":"198 days","RelationshipCount":15},{"OrganizationId":4295904718,"OrganizationName":"Pepsico, Inc.","Phone":"617-357-9501","Industry":"<IndustryGroupPaths><IndustryGroupPath>Real Estate and Rental and Leasing &amp;gt; Lessors of Nonfinancial Intangible Assets (except Copyrighted Works)</IndustryGroupPath><IndustryGroupPath>Manufacturing &amp;gt; Food Manufacturing &amp;gt; Other Food Manufacturing &amp;gt; Coffee and Tea Manufacturing</IndustryGroupPath><IndustryGroupPath>Manufacturing &amp;gt; Food Manufacturing &amp;gt; Other Food Manufacturing &amp;gt; Flavoring Syrup and Concentrate Manufacturing</IndustryGroupPath><IndustryGroupPath>Wholesale Trade &amp;gt; Merchant Wholesalers, Nondurable Goods &amp;gt; Grocery and Related Product Merchant Wholesalers &amp;gt; Other Grocery and Related Products Merchant Wholesalers</IndustryGroupPath><IndustryGroupPath>Wholesale Trade &amp;gt; Wholesale Electronic Markets and Agents and Brokers &amp;gt; Business to Business Electronic Markets</IndustryGroupPath><IndustryGroupPath>Wholesale Trade &amp;gt; Wholesale Electronic Markets and Agents and Brokers &amp;gt; Wholesale Trade Agents and Brokers</IndustryGroupPath><IndustryGroupPath>Retail Trade &amp;gt; Miscellaneous Store Retailers &amp;gt; Other Miscellaneous Store Retailers &amp;gt; Pet and Pet Supplies Stores</IndustryGroupPath></IndustryGroupPaths>","MailingAddress":"<Address><POBox></POBox><StreetAddress></StreetAddress><Locality></Locality><Region></Region><PostalCode></PostalCode></Address>","HasVisibleSignatures":true,"FirstName":"Thomas","LastName":"Boyle","Title":"Senior Director, Finance","Email":"thomas.boyle@pepsi.com","Id":1659122,"Strength":5.95,"SourcesBitmask":8195,"MostRecentSource":1,"MostRecentSourceDate":"2015-04-23T00:00:00","Recency":"126 days","RelationshipCount":30}],"NumResults":358,"TrackedSearchId":38341}';
		CNData_14_Contact obj = CNData_14_Contact.parse(json);
		System.assert(obj != null);
		list<CNData.CNContact> ccon = CNData_14_Contact.MapTo(obj); 
		CNData.CNCompany oCompany = new CNData.CNCompany();
		list<CNData_14_Contact.Results> cl = obj.Results;
		list<CNData.CNContact> ccon1 = CNData_14_Contact.MapTo(cl, oCompany);
		CNData_14_Contact.Results r = new CNData_14_Contact.Results();
		r.OrganizationId  = 2452345;
		r.OrganizationName = 'ttestt';
		r.Phone = '123-456-7777';    
		r.Industry = 'tools';
		r.MailingAddress = '123 somne3 st';
		r.HasVisibleSignatures = false;
		r.FirstName  = 'testy';
		r.LastName  = 'terster';
		r.Title = 'Mr.';
		r.Email = 'myemail@test.co';
		r.Id = 24523;
		r.Strength = 2.0;
		r.SourcesBitmask = 1;
		r.MostRecentSource = 2;
		r.MostRecentSourceDate = '09-09-2009';
		r.Recency = 'foo';
		r.RelationshipCount = 9; 
		CN_App_Settings__c capp = [SELECT Recency_as_Date__c FROM CN_App_Settings__c limit 1];
		capp.Recency_as_Date__c = !capp.Recency_as_Date__c;
		update capp;
		obj = CNData_14_Contact.parse(json);
		System.assert(obj != null);
		ccon = CNData_14_Contact.MapTo(obj); 
		oCompany = new CNData.CNCompany();
		cl = obj.Results;
		ccon1 = CNData_14_Contact.MapTo(cl, oCompany);
		r = new CNData_14_Contact.Results();
	}
}