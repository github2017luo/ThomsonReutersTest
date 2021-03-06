//Generated by wsdl2apex

public class IxosWS {
    public class GetIXOSDocumentDetails_element {
        public String SystemId;
        public IxosWSObjects.DocumentHeader[] DocumentHeader;
        public String CompanyCode;
        public String SalesOrgCode;
        public String DistChanCode;
        public String DivisionCode;
        public Date IxosDocBegDt;
        public Date IxosDocEndDt;
        public String[] DocumentType;
        private String[] SystemId_type_info = new String[]{'SystemId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DocumentHeader_type_info = new String[]{'DocumentHeader','http://west.thomson.com/crm/rocketxsd/2.0/ixosdocument','DocumentHeader','1','-1','false'};
        private String[] CompanyCode_type_info = new String[]{'CompanyCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] SalesOrgCode_type_info = new String[]{'SalesOrgCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DistChanCode_type_info = new String[]{'DistChanCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] DivisionCode_type_info = new String[]{'DivisionCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] IxosDocBegDt_type_info = new String[]{'IxosDocBegDt','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] IxosDocEndDt_type_info = new String[]{'IxosDocEndDt','http://www.w3.org/2001/XMLSchema','date','0','1','false'};
        private String[] DocumentType_type_info = new String[]{'DocumentType','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/2.0/ixosdocument','true','false'};
        private String[] field_order_type_info = new String[]{'SystemId','DocumentHeader','CompanyCode','SalesOrgCode','DistChanCode','DivisionCode','IxosDocBegDt','IxosDocEndDt','DocumentType'};
    }
    public class GetIXOSDocumentDetailsResponse_element {
        public IxosWSObjects.IXOSDocument[] IXOSDocument;
        private String[] IXOSDocument_type_info = new String[]{'IXOSDocument','http://west.thomson.com/crm/rocketxsd/2.0/ixosdocument','IXOSDocument','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/2.0/ixosdocument','true','false'};
        private String[] field_order_type_info = new String[]{'IXOSDocument'};
    }
    public class IXOSDocument_v2_0Port {
        public String endpoint_x = 'http://crmrocketdev.int.westgroup.com/rocketdeploy/services/IXOSDocument_v2_0Port';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/2.0/ixosdocument', 'IxosWSObjects', 'http://west.thomson.com/crm/rocketservices/2.0/ixosdocument', 'IxosWS'};
        public IxosWSObjects.IXOSDocument[] GetIXOSDocumentDetails(String SystemId,IxosWSObjects.DocumentHeader[] DocumentHeader,String CompanyCode,String SalesOrgCode,String DistChanCode,String DivisionCode,Date IxosDocBegDt,Date IxosDocEndDt,String[] DocumentType) {
            IxosWS.GetIXOSDocumentDetails_element request_x = new IxosWS.GetIXOSDocumentDetails_element();
            IxosWS.GetIXOSDocumentDetailsResponse_element response_x;
            request_x.SystemId = SystemId;
            request_x.DocumentHeader = DocumentHeader;
            request_x.CompanyCode = CompanyCode;
            request_x.SalesOrgCode = SalesOrgCode;
            request_x.DistChanCode = DistChanCode;
            request_x.DivisionCode = DivisionCode;
            request_x.IxosDocBegDt = IxosDocBegDt;
            request_x.IxosDocEndDt = IxosDocEndDt;
            request_x.DocumentType = DocumentType;
            Map<String, IxosWS.GetIXOSDocumentDetailsResponse_element> response_map_x = new Map<String, IxosWS.GetIXOSDocumentDetailsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'GetIXOSDocumentDetails',
              'http://west.thomson.com/crm/rocketservices/2.0/ixosdocument',
              'GetIXOSDocumentDetails',
              'http://west.thomson.com/crm/rocketservices/2.0/ixosdocument',
              'GetIXOSDocumentDetailsResponse',
              'IxosWS.GetIXOSDocumentDetailsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.IXOSDocument;
        }
    }
}