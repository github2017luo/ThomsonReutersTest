/**
 * Contains helper methods for ServiceNotes Class
 * Contains the methods which will process the request and response
 *
 * @author  Srikanth Kuruva
 * @version  2012-12-14
 *
  * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-06-13   Matthew Main            Added  getServiceNotesInfoESI and getServiceNoteItemDetailESI Methods for ESI Integration ESD-381
 * =============================================================================
 */
 
public with sharing class ServiceNotesServices{
    public static final string WebServiceName = 'ServiceNoteServices';
    public static final string MockCalloutGetServiceNoteItems = 'GetServiceNoteItems';
    public static final string MockCalloutGetServiceNoteDetail = 'GetServiceNoteDetail';    


    public static List<ServiceNoteItem> getServiceNotesInfo(ServiceNotesRequest oServiceNotesRequest){        
        
       // Map<string, ServiceNoteItem> mapServiceNoteDetail = new Map<string, ServiceNoteItem>();
       List<ServiceNoteItem> listServiceNoteDetail = new List<ServiceNoteItem>();
       
        ServiceNotesWS.ServiceNote_v3_0Port srvc = new ServiceNotesWS.ServiceNote_v3_0Port();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);
                
        srvc.inputHttpHeaders_x = new Map<String, String>();
        srvc.endpoint_x = oWebServiceSettings.Endpoint__c;
        srvc.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        srvc.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        srvc.outputHttpHeaders_x = new Map<String,String>();
        
        List<ServiceNotesWSObjects.ServiceNoteItem> outputServiceNotes = new List<ServiceNotesWSObjects.ServiceNoteItem>();
        if(Test.isRunningTest())
        {
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            outputServiceNotes = (list<ServiceNotesWSObjects.ServiceNoteItem>) oMockResponse.mapMockWebServiceResponse.get(MockCalloutGetServiceNoteItems);
        }
        else
        {
            outputServiceNotes = srvc.GetServiceNoteItems(oServiceNotesRequest.sSystemId, oServiceNotesRequest.dcAcctSAPId, oServiceNotesRequest.dBegDt, oServiceNotesRequest.dEndDt);
        }
        if (outputServiceNotes != null)
        {
            for (ServiceNotesWSObjects.ServiceNoteItem ServiceNote : outputServiceNotes)
            {
                ServiceNoteItem ServiceNoteItemSingle = new ServiceNoteItem();
                ServiceNoteItemSingle.ServiceNoteId = ServiceNote.ServiceNoteId;
                ServiceNoteItemSingle.StatusId = ServiceNote.StatusId;
                ServiceNoteItemSingle.StatusDesc = ServiceNote.StatusDesc;
                ServiceNoteItemSingle.DepartmentId = ServiceNote.DepartmentId;
                ServiceNoteItemSingle.DepartmentDesc = ServiceNote.DepartmentDesc;
                ServiceNoteItemSingle.Requester = ServiceNote.Requester;
                ServiceNoteItemSingle.ContactMethod = ServiceNote.ContactMethod;
                ServiceNoteItemSingle.PriorityId = ServiceNote.PriorityId;
                ServiceNoteItemSingle.PriorityDesc = ServiceNote.PriorityDesc;
                //ServiceNoteItemSingle.ActivityCodeId = ServiceNote.ActivityCodeId;
                //ServiceNoteItemSingle.ActivityCodeDesc = ServiceNote.ActivityCodeDesc;
                ServiceNoteItemSingle.ActivityCodeItemList = new List<ServiceNoteActivity>();
                for (ServiceNotesWSObjects.ActivityCodeItem ActivityCodeItemSingle : ServiceNote.ActivityCodeItemList)
                {
                    ServiceNoteActivity sna = new ServiceNoteActivity();
                    sna.ActivityCodeDesc = ActivityCodeItemSingle.ActivityCodeDesc;
                    sna.ActivityCodeId = ActivityCodeItemSingle.ActivityCodeId;
                    ServiceNoteItemSingle.ActivityCodeItemList.add(sna);
                }            
                ServiceNoteItemSingle.ShortDesc = ServiceNote.ShortDesc;
                ServiceNoteItemSingle.LongDesc = ServiceNote.LongDesc;
                ServiceNoteItemSingle.CreateTS = ServiceNote.CreateTS;
                ServiceNoteItemSingle.ChangedBy = ServiceNote.ChangedBy;
                ServiceNoteItemSingle.ChangedOnDate = ServiceNote.ChangedOnDate;
                
                //mapServiceNoteDetail.put(oServiceNotesRequest.sSystemId+ServiceNote.ServiceNoteId,ServiceNoteItemSingle);
                listServiceNoteDetail.add(ServiceNoteItemSingle);
            }
        }
        //return mapServiceNoteDetail;
        return listServiceNoteDetail;
    }

    public static ServiceNoteItem getServiceNoteItemDetail(ServiceNoteItemDetailRequest oServiceNoteItemDetailRequest)
    {
        ServiceNoteItem ServiceNoteItemDetail = new ServiceNoteItem();
        ServiceNotesWS.ServiceNote_v3_0Port srvc = new ServiceNotesWS.ServiceNote_v3_0Port();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

        srvc.inputHttpHeaders_x = new Map<String, String>();
        srvc.endpoint_x = oWebServiceSettings.Endpoint__c;
        srvc.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        srvc.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        srvc.outputHttpHeaders_x = new Map<String,String>();
        //system.debug(oServiceNoteItemDetailRequest);
        ServiceNotesWSObjects.ServiceNoteItem outputServiceNote;
        if(Test.isRunningTest())
        {
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            outputServiceNote = (ServiceNotesWSObjects.ServiceNoteItem)oMockResponse.mapMockWebServiceResponse.get(MockCalloutGetServiceNoteDetail);
        }
        else
        {
            outputServiceNote = srvc.GetServiceNoteDetail(oServiceNoteItemDetailRequest.sSystemId, oServiceNoteItemDetailRequest.sServiceNoteId);
        }
        //ServiceNoteItemDetail.ServiceNoteId = outputServiceNote.ServiceNoteId;
        system.debug('outputServiceNote:'+outputServiceNote);
        ServiceNoteItemDetail.ServiceNoteId = outputServiceNote.ServiceNoteId;
        ServiceNoteItemDetail.StatusId = outputServiceNote.StatusId;
        ServiceNoteItemDetail.StatusDesc = outputServiceNote.StatusDesc;
        ServiceNoteItemDetail.DepartmentId = outputServiceNote.DepartmentId;
        ServiceNoteItemDetail.DepartmentDesc = outputServiceNote.DepartmentDesc;
        ServiceNoteItemDetail.Requester = outputServiceNote.Requester;
        ServiceNoteItemDetail.ContactMethod = outputServiceNote.ContactMethod;
        ServiceNoteItemDetail.PriorityId = outputServiceNote.PriorityId;
        ServiceNoteItemDetail.PriorityDesc = outputServiceNote.PriorityDesc;
        ServiceNoteItemDetail.ActivityCodeItemList = new List<ServiceNoteActivity>();
        for (ServiceNotesWSObjects.ActivityCodeItem ActivityCodeItemSingle : outputServiceNote.ActivityCodeItemList)
        {
            ServiceNoteActivity sna = new ServiceNoteActivity();
            sna.ActivityCodeDesc = ActivityCodeItemSingle.ActivityCodeDesc;
            sna.ActivityCodeId = ActivityCodeItemSingle.ActivityCodeId;
            ServiceNoteItemDetail.ActivityCodeItemList.add(sna);
        }
        ServiceNoteItemDetail.ShortDesc = outputServiceNote.ShortDesc;
        ServiceNoteItemDetail.LongDesc = outputServiceNote.LongDesc;
        //system.debug('outputServiceNote.LongDesc:'+outputServiceNote.LongDesc);
        //system.debug('ServiceNoteItemDetail.LongDesc:'+ServiceNoteItemDetail.LongDesc);
        ServiceNoteItemDetail.CreateTS = outputServiceNote.CreateTS;
        ServiceNoteItemDetail.ChangedBy = outputServiceNote.ChangedBy;
        ServiceNoteItemDetail.ChangedOnDate = outputServiceNote.ChangedOnDate;
        return ServiceNoteItemDetail;
    }

    public static List<ServiceNoteItem> getServiceNotesInfoESI(ServiceNotesRequest oServiceNotesRequest){
        String WebServiceName = 'USL_ServiceNoteServicesESI';
        // Map<string, ServiceNoteItem> mapServiceNoteDetail = new Map<string, ServiceNoteItem>();
        List<ServiceNoteItem> listServiceNoteDetail = new List<ServiceNoteItem>();

        ServiceNotesWS.ServiceNote_v4_0ESI_Implementation srvc = new ServiceNotesWS.ServiceNote_v4_0ESI_Implementation();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

        srvc.inputHttpHeaders_x = new Map<String, String>();
        //srvc.endpoint_x = oWebServiceSettings.Endpoint__c;
        srvc.timeout_x = (oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
        Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        srvc.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        srvc.outputHttpHeaders_x = new Map<String,String>();

        List<ServiceNotesWSObjects.ServiceNoteItem> outputServiceNotes = new List<ServiceNotesWSObjects.ServiceNoteItem>();
        if(Test.isRunningTest()) {
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            outputServiceNotes = (list<ServiceNotesWSObjects.ServiceNoteItem>) oMockResponse.mapMockWebServiceResponse.get(MockCalloutGetServiceNoteItems);
        }
        else {
            outputServiceNotes = srvc.GetServiceNoteItems(oServiceNotesRequest.sSystemId, oServiceNotesRequest.dcAcctSAPId, oServiceNotesRequest.dBegDt, oServiceNotesRequest.dEndDt);
        }
        if (outputServiceNotes != null)
        {
            for (ServiceNotesWSObjects.ServiceNoteItem ServiceNote : outputServiceNotes)
            {
                ServiceNoteItem ServiceNoteItemSingle = new ServiceNoteItem();
                ServiceNoteItemSingle.ServiceNoteId = ServiceNote.ServiceNoteId;
                ServiceNoteItemSingle.StatusId = ServiceNote.StatusId;
                ServiceNoteItemSingle.StatusDesc = ServiceNote.StatusDesc;
                ServiceNoteItemSingle.DepartmentId = ServiceNote.DepartmentId;
                ServiceNoteItemSingle.DepartmentDesc = ServiceNote.DepartmentDesc;
                ServiceNoteItemSingle.Requester = ServiceNote.Requester;
                ServiceNoteItemSingle.ContactMethod = ServiceNote.ContactMethod;
                ServiceNoteItemSingle.PriorityId = ServiceNote.PriorityId;
                ServiceNoteItemSingle.PriorityDesc = ServiceNote.PriorityDesc;
                //ServiceNoteItemSingle.ActivityCodeId = ServiceNote.ActivityCodeId;
                //ServiceNoteItemSingle.ActivityCodeDesc = ServiceNote.ActivityCodeDesc;
                ServiceNoteItemSingle.ActivityCodeItemList = new List<ServiceNoteActivity>();
                for (ServiceNotesWSObjects.ActivityCodeItem ActivityCodeItemSingle : ServiceNote.ActivityCodeItemList)
                {
                    ServiceNoteActivity sna = new ServiceNoteActivity();
                    sna.ActivityCodeDesc = ActivityCodeItemSingle.ActivityCodeDesc;
                    sna.ActivityCodeId = ActivityCodeItemSingle.ActivityCodeId;
                    ServiceNoteItemSingle.ActivityCodeItemList.add(sna);
                }
                ServiceNoteItemSingle.ShortDesc = ServiceNote.ShortDesc;
                ServiceNoteItemSingle.LongDesc = ServiceNote.LongDesc;
                ServiceNoteItemSingle.CreateTS = ServiceNote.CreateTS;
                ServiceNoteItemSingle.ChangedBy = ServiceNote.ChangedBy;
                ServiceNoteItemSingle.ChangedOnDate = ServiceNote.ChangedOnDate;

                //mapServiceNoteDetail.put(oServiceNotesRequest.sSystemId+ServiceNote.ServiceNoteId,ServiceNoteItemSingle);
                listServiceNoteDetail.add(ServiceNoteItemSingle);
            }
        }
        //return mapServiceNoteDetail;
        return listServiceNoteDetail;
    }

    public static ServiceNoteItem getServiceNoteItemDetailESI(ServiceNoteItemDetailRequest oServiceNoteItemDetailRequest){
        String WebServiceName = 'USL_ServiceNoteServicesdetailESI';
        ServiceNoteItem ServiceNoteItemDetail = new ServiceNoteItem();
        ServiceNotesWS.ServiceNote_v4_0ESI_Implementation srvc = new ServiceNotesWS.ServiceNote_v4_0ESI_Implementation();
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(WebServiceName);

        srvc.inputHttpHeaders_x = new Map<String, String>();
        //srvc.endpoint_x = oWebServiceSettings.Endpoint__c;
        srvc.timeout_x = (oWebServiceSettings.Timeout__c * 100).intValue(); //Convert seconds to milliseconds
        Blob blobCredentials = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        string sAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(blobCredentials);
        srvc.inputHttpHeaders_x.put('Authorization', sAuthorizationHeader);
        srvc.outputHttpHeaders_x = new Map<String,String>();
        //system.debug(oServiceNoteItemDetailRequest);
        ServiceNotesWSObjects.ServiceNoteItem outputServiceNote;
        if(Test.isRunningTest())
        {
            MockWebserviceResponses oMockResponse = new MockWebserviceResponses();
            outputServiceNote = (ServiceNotesWSObjects.ServiceNoteItem)oMockResponse.mapMockWebServiceResponse.get(MockCalloutGetServiceNoteDetail);
        }
        else {
            try {
                outputServiceNote = srvc.GetServiceNoteDetail(oServiceNoteItemDetailRequest.sSystemId, oServiceNoteItemDetailRequest.sServiceNoteId);

            }
            catch(Exception e){
                throw e;
            }
        }

        if(outputServiceNote == null){
            return null;
        }
        else {
            //ServiceNoteItemDetail.ServiceNoteId = outputServiceNote.ServiceNoteId;
            system.debug('outputServiceNote:' + outputServiceNote);
            ServiceNoteItemDetail.ServiceNoteId = outputServiceNote.ServiceNoteId;
            ServiceNoteItemDetail.StatusId = outputServiceNote.StatusId;
            ServiceNoteItemDetail.StatusDesc = outputServiceNote.StatusDesc;
            ServiceNoteItemDetail.DepartmentId = outputServiceNote.DepartmentId;
            ServiceNoteItemDetail.DepartmentDesc = outputServiceNote.DepartmentDesc;
            ServiceNoteItemDetail.Requester = outputServiceNote.Requester;
            ServiceNoteItemDetail.ContactMethod = outputServiceNote.ContactMethod;
            ServiceNoteItemDetail.PriorityId = outputServiceNote.PriorityId;
            ServiceNoteItemDetail.PriorityDesc = outputServiceNote.PriorityDesc;
            ServiceNoteItemDetail.ActivityCodeItemList = new List<ServiceNoteActivity>();
            for (ServiceNotesWSObjects.ActivityCodeItem ActivityCodeItemSingle : outputServiceNote.ActivityCodeItemList) {
                ServiceNoteActivity sna = new ServiceNoteActivity();
                sna.ActivityCodeDesc = ActivityCodeItemSingle.ActivityCodeDesc;
                sna.ActivityCodeId = ActivityCodeItemSingle.ActivityCodeId;
                ServiceNoteItemDetail.ActivityCodeItemList.add(sna);
            }
            ServiceNoteItemDetail.ShortDesc = outputServiceNote.ShortDesc;
            ServiceNoteItemDetail.LongDesc = outputServiceNote.LongDesc;
            //system.debug('outputServiceNote.LongDesc:'+outputServiceNote.LongDesc);
            //system.debug('ServiceNoteItemDetail.LongDesc:'+ServiceNoteItemDetail.LongDesc);
            ServiceNoteItemDetail.CreateTS = outputServiceNote.CreateTS;
            ServiceNoteItemDetail.ChangedBy = outputServiceNote.ChangedBy;
            ServiceNoteItemDetail.ChangedOnDate = outputServiceNote.ChangedOnDate;
            return ServiceNoteItemDetail;
        }
    }


    public class ServiceNoteItem {
        public String ServiceNoteId{get;set;}
        public String StatusId{get;set;}
        public String StatusDesc{get;set;}
        public String DepartmentId{get;set;}
        public String DepartmentDesc{get;set;}
        public String Requester{get;set;}
        public String ContactMethod{get;set;}
        public String PriorityId{get;set;}
        public String PriorityDesc{get;set;}
        public List<ServiceNoteActivity> ActivityCodeItemList{get;set;}        
        public String ShortDesc{get;set;}
        public String LongDesc{get;set;}
        public DateTime CreateTS{get;set;}
        public String ChangedBy{get;set;}
        public Date ChangedOnDate{get;set;}
    }
    
    public class ServiceNoteActivity
    {
        public String ActivityCodeId{get;set;}
        public String ActivityCodeDesc{get;set;}
    }
    
    public class ServiceNotesRequest{
        public String sSystemId{get;set;}
        public Decimal[] dcAcctSAPId{get;set;}
        public Date dBegDt{get;set;}
        public Date dEndDt{get;set;}
    }
    
    public class ServiceNoteItemDetailRequest{
        public String sSystemId{get;set;}
        public String sServiceNoteId{get;set;}
    }

}