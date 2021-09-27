@istest
public with sharing class IXOSServices_Test{
    Private static testMethod Void testIxos(){
        IXOSServices.IXOSRequest oRequest = new IXOSServices.IXOSRequest();
            oRequest.SystemId = '1';        
            List<IXOSDocumenttype__c> ixosdoc = IXOSDocumenttype__c.getall().values();
            List<String> doclist = new list<string>();
            for(IXOSDocumenttype__c i : ixosdoc){
                doclist.add(i.name);
            }
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('IXOS');       
            oRequest.endpoint= oWebServiceSettings.Endpoint__c;
            oRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            oRequest.username=oWebServiceSettings.Username__c;
            oRequest.password= oWebServiceSettings.Password__c;
            IxosWSObjects.DocumentHeader oDocumentHeader = new IxosWSObjects.DocumentHeader();
            IXOSServices.DocumentHeader oDocHeader = new IXOSServices.DocumentHeader(oDocumentHeader);
            oDocHeader = new IXOSServices.DocumentHeader();
            oDocHeader.AcctSapId = decimal.valueof('1');
            
            oDocHeader.OrderNumber = 'Test';
            oRequest.DocumentHeaderList = new List<IXOSServices.DocumentHeader>();
            oRequest.DocumentHeaderList.add(oDocHeader);
      
            IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance('West Group');
            oRequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
            oRequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            oRequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            oRequest.DivisionCode = oIXOSCodeMap.Division_Code__c;            
            
            oRequest.DocumentTypeList=doclist;      
            IxosServices oIxosServices = new IxosServices();
            List<IXOSServices.IXOSDocument> IXOSDocumentList =oIxosServices.GetIXOSDocumentDetails(oRequest);
    }
}