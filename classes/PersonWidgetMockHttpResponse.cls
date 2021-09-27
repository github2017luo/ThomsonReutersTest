@isTest
global class PersonWidgetMockHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        PersonWidgetIntegrationHelper.PersonWidgetWrapper helperObj = new PersonWidgetIntegrationHelper.PersonWidgetWrapper();
        helperObj.output_PersonFName = 'test';
        helperObj.output_PersonLName = 'tester';
        helperObj.output_PersonID = '123456';
        helperObj.output_PersonLastUp = '05/18/15 Wed 3:45pm';
        helperObj.output_countContactAll = '2';
        helperObj.output_countContactRecAct = '3';
        helperObj.output_countLeadOpen = '4';
        helperObj.output_countLeadUnWork = '5';
        helperObj.output_countOppOpen = '6';
        helperObj.output_countOppClose = '7';
        helperObj.output_countOppOnDem = '8';
        helperObj.output_countSubsAll = '9';
        helperObj.output_countSubsNext90 = '1';
        helperObj.output_countSubsAccess = '1';
        helperObj.output_countMarkActLast90 = '2';
        helperObj.output_countSalesActLast90 = '3';
        helperObj.output_hisContactList = new List<PersonWidgetIntegrationHelper.HistoryData>();
        for(Integer i = 0; i<2; i++){ 
            PersonWidgetIntegrationHelper.HistoryData hw = new PersonWidgetIntegrationHelper.HistoryData();
            hw.UpdateDate = 'data11';
            hw.Name = 'data12';
            hw.ChangedValue = 'data13';
            helperObj.output_hisContactList.add(hw);
        }
        helperObj.output_hisLeadList = new List<PersonWidgetIntegrationHelper.HistoryData>();
        for(Integer i = 0; i<2; i++){ 
            PersonWidgetIntegrationHelper.HistoryData hw = new PersonWidgetIntegrationHelper.HistoryData();
            hw.UpdateDate = '2015-10-21T03:41:19Z';
            hw.Name = 'data12';
            hw.ChangedValue = 'data13';
            helperObj.output_hisLeadList.add(hw);
        }
        helperObj.output_hisOppList = new List<PersonWidgetIntegrationHelper.HistoryData>();
        for(Integer i = 0; i<2; i++){ 
            PersonWidgetIntegrationHelper.HistoryData hw = new PersonWidgetIntegrationHelper.HistoryData();
            hw.UpdateDate = 'data11';
            hw.Name = 'data12';
            hw.ChangedValue = 'data13';
            helperObj.output_hisOppList.add(hw);
        }
        helperObj.output_hisSubsList = new List<PersonWidgetIntegrationHelper.HistoryData>();
        for(Integer i = 0; i<2; i++){ 
            PersonWidgetIntegrationHelper.HistoryData hw = new PersonWidgetIntegrationHelper.HistoryData();
            hw.UpdateDate = 'data11';
            hw.Name = 'data12';
            hw.ChangedValue = 'data13';
            helperObj.output_hisSubsList.add(hw);
        }
        helperObj.output_hisMarkActList = new List<PersonWidgetIntegrationHelper.HistoryData>();
        for(Integer i = 0; i<2; i++){ 
            PersonWidgetIntegrationHelper.HistoryData hw = new PersonWidgetIntegrationHelper.HistoryData();
            hw.UpdateDate = 'data11';
            hw.Name = 'data12';
            hw.ChangedValue = 'data13';
            helperObj.output_hisMarkActList.add(hw);
        }
        helperObj.output_hisSalesActList = new List<PersonWidgetIntegrationHelper.HistoryData>();
        for(Integer i = 0; i<2; i++){ 
            PersonWidgetIntegrationHelper.HistoryData hw = new PersonWidgetIntegrationHelper.HistoryData();
            hw.UpdateDate = 'data11';
            hw.Name = 'data12';
            hw.ChangedValue = 'data13';
            helperObj.output_hisSalesActList.add(hw);
        }
        
        String jsonString = JSON.serialize(helperObj);
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonString);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}