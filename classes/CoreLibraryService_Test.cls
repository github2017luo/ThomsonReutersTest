@istest(seealldata=false)
public with sharing class CoreLibraryService_Test{
    Private static testMethod Void testGetCoreLibraryCodes(){
       
        
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c ws2 = new WebServiceSettings__c();
        ws2.name = 'CoreLibraryService';       
        ws2.Active__c = true;
        ws2.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/corelibraryservice/dev/v1';
        ws2.Password__c = '$aleForce';
        ws2.Service_Unavailable_Message__c = 'Core Library Service is not available';
        ws2.Timeout__c = 120;
        ws2.Username__c = 'Salesforce';
        insert ws2;         
        
         
         Test.startTest();
         Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock()); 
        
        CoreLibraryService.CoreLibraryMaterials testObj = new CoreLibraryService.CoreLibraryMaterials(new CoreLibraryWS.CoreLibraryMaterial());
        CoreLibraryService.CoreLibraries testobj1 = new CoreLibraryService.CoreLibraries(new CoreLibraryWS.CoreLibrary());
        CoreLibraryService.drop_leading_zeros('000123573987');
        
        CoreLibraryService.CodeRequest oCoderequest = new CoreLibraryService.CodeRequest();
        oCodeRequest.MarketSegment = 27;
        list<string> testliststring = CoreLibraryService.GetCoreLibraryCodes(oCoderequest);
        
        
        CoreLibraryService.CoreLibraryRequest oCoreLibraryRequest = new CoreLibraryService.CoreLibraryRequest();
        oCoreLibraryRequest.MarketSegment = 27;
        oCoreLibraryRequest.CoreLibraryCode = 'NC';
        list<CoreLibraryService.CoreLibraries> testlistlibraries = CoreLibraryService.GetCoreLibraries(oCoreLibraryRequest);
        
        CoreLibraryService.CoreLibraryMaterialRequest oCoreLibraryMaterialRequest = new CoreLibraryService.CoreLibraryMaterialRequest();
        oCoreLibraryMaterialRequest.MDBID = 'test';
        oCoreLibraryMaterialRequest.MarketSegment = 27;
        oCoreLibraryMaterialRequest.CoreLibrary = new  list<CorelibraryWS.CoreLibrary>();
        list<CoreLibraryService.CoreLibraryMaterials> testlistMaterials = CoreLibraryService.GetCoreLibraryMaterial(oCoreLibraryMaterialRequest);
        
        //Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock()); 
        
        Test.stopTest();
        
        
        
        
        
    
        
    }
    
    Private static testMethod Void testGetCoreLibraryCodes2(){
       
        
        
        WebServiceSettings__c ws1= new WebServiceSettings__c();
        ws1.Name='Dellboomi SFDC Legal';
        ws1.Username__c='Username';
        ws1.Password__c='Password';
        ws1.Endpoint__c='https://dev.api.apigarden-qa.thomsonreuters.com/boomi/oauth2/token';
        ws1.Service_Unavailable_Message__c='Service_Unavailable';
        insert ws1;
        
        WebServiceSettings__c ws2 = new WebServiceSettings__c();
        ws2.name = 'CoreLibraryService';       
        ws2.Active__c = true;
        ws2.Endpoint__c = 'https://api-test.thomsonreuters.com/boomi/corelibraryservice/dev/v1';
        ws2.Password__c = '$aleForce';
        ws2.Service_Unavailable_Message__c = 'Core Library Service is not available';
        ws2.Timeout__c = 120;
        ws2.Username__c = 'Salesforce';
        insert ws2;         
        
         
         Test.startTest();
         //Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock()); 
        
        CoreLibraryService.CoreLibraryMaterials testObj = new CoreLibraryService.CoreLibraryMaterials(new CoreLibraryWS.CoreLibraryMaterial());
        CoreLibraryService.CoreLibraries testobj1 = new CoreLibraryService.CoreLibraries(new CoreLibraryWS.CoreLibrary());
        CoreLibraryService.drop_leading_zeros('000123573987');
        
        CoreLibraryService.CodeRequest oCoderequest = new CoreLibraryService.CodeRequest();
        oCodeRequest.MarketSegment = 27;
        list<string> testliststring = CoreLibraryService.GetCoreLibraryCodes(oCoderequest);
        
        
        CoreLibraryService.CoreLibraryRequest oCoreLibraryRequest = new CoreLibraryService.CoreLibraryRequest();
        oCoreLibraryRequest.MarketSegment = 27;
        oCoreLibraryRequest.CoreLibraryCode = 'NC';
        list<CoreLibraryService.CoreLibraries> testlistlibraries = CoreLibraryService.GetCoreLibraries(oCoreLibraryRequest);
        
        CoreLibraryService.CoreLibraryMaterialRequest oCoreLibraryMaterialRequest = new CoreLibraryService.CoreLibraryMaterialRequest();
        oCoreLibraryMaterialRequest.MDBID = 'test';
        oCoreLibraryMaterialRequest.MarketSegment = 27;
        oCoreLibraryMaterialRequest.CoreLibrary = new  list<CorelibraryWS.CoreLibrary>();
        list<CoreLibraryService.CoreLibraryMaterials> testlistMaterials = CoreLibraryService.GetCoreLibraryMaterial(oCoreLibraryMaterialRequest);
        
        Test.setMock(HttpCalloutMock.class, new  DellBoomiTokenGeneration_Test.DellBoomiCalloutMock()); 
        
        Test.stopTest();
        
        
        
        
        
    
        
    }

}