//Generated by wsdl2apex

public class CoreLibraryWS {
    public class GetCoreLibraries_element {
        public Integer MarketSegmentId;
        public String CoreLibraryCode;
        private String[] MarketSegmentId_type_info = new String[]{'MarketSegmentId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] CoreLibraryCode_type_info = new String[]{'CoreLibraryCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'MarketSegmentId','CoreLibraryCode'};
    }
    public class GetCoreLibrariesResponse_element {
        public CoreLibraryWS.CoreLibrary[] CoreLibrary;
        private String[] CoreLibrary_type_info = new String[]{'CoreLibrary','http://west.thomson.com/crm/rocketxsd/3.0/corelibrary','CoreLibrary','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'CoreLibrary'};
    }
    public class GetCoreLibraryCodes_element {
        public Integer MarketSegmentId;
        private String[] MarketSegmentId_type_info = new String[]{'MarketSegmentId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'MarketSegmentId'};
    }
    public class CoreLibrary {
        public String CoreLibraryId;
        public String CoreLibraryDesc;
        private String[] CoreLibraryId_type_info = new String[]{'CoreLibraryId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CoreLibraryDesc_type_info = new String[]{'CoreLibraryDesc','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'CoreLibraryId','CoreLibraryDesc'};
    }
    public class GetCoreLibraryCodesResponse_element {
        public String[] CoreLibraryCode;
        private String[] CoreLibraryCode_type_info = new String[]{'CoreLibraryCode','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'CoreLibraryCode'};
    }
    public class CoreLibrary_v3_0Port {
        public String endpoint_x = 'http://crmrocketdev.int.westgroup.com/rocketdeploy/services/CoreLibrary_v3_0Port';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary', 'CoreLibraryWS', 'http://west.thomson.com/crm/rocketxsd/3.0/corelibrary', 'CoreLibraryWS'};
        public CoreLibraryWS.CoreLibrary[] GetCoreLibraries(Integer MarketSegmentId,String CoreLibraryCode) {
            CoreLibraryWS.GetCoreLibraries_element request_x = new CoreLibraryWS.GetCoreLibraries_element();
            CoreLibraryWS.GetCoreLibrariesResponse_element response_x = new CoreLibraryWS.GetCoreLibrariesResponse_element();
            request_x.MarketSegmentId = MarketSegmentId;
            request_x.CoreLibraryCode = CoreLibraryCode;
            Map<String, CoreLibraryWS.GetCoreLibrariesResponse_element> response_map_x = new Map<String, CoreLibraryWS.GetCoreLibrariesResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest())
            {
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'GetCoreLibraries',
              'http://west.thomson.com/crm/rocketservices/3.0/corelibrary',
              'GetCoreLibraries',
              'http://west.thomson.com/crm/rocketservices/3.0/corelibrary',
              'GetCoreLibrariesResponse',
              'CoreLibraryWS.GetCoreLibrariesResponse_element'}
            );
            }
            response_x = response_map_x.get('response_x');
            return response_x.CoreLibrary;
        }
        public CoreLibraryWS.CoreLibraryMaterial[] GetAccountCoreLibraryMaterials(String MdbId,Integer MarketSegmentId,CoreLibraryWS.CoreLibrary[] CoreLibrary) {
            CoreLibraryWS.GetAccountCoreLibraryMaterials_element request_x = new CoreLibraryWS.GetAccountCoreLibraryMaterials_element();
            CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element response_x = new CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element();
            request_x.MdbId = MdbId;
            request_x.MarketSegmentId = MarketSegmentId;
            request_x.CoreLibrary = CoreLibrary;
            Map<String, CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element> response_map_x = new Map<String, CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest())
            {
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'GetAccountCoreLibraryMaterials',
              'http://west.thomson.com/crm/rocketservices/3.0/corelibrary',
              'GetAccountCoreLibraryMaterials',
              'http://west.thomson.com/crm/rocketservices/3.0/corelibrary',
              'GetAccountCoreLibraryMaterialsResponse',
              'CoreLibraryWS.GetAccountCoreLibraryMaterialsResponse_element'}
            );
            }
            response_x = response_map_x.get('response_x');
            return response_x.CoreLibraryMaterial;
        }
        public String[] GetCoreLibraryCodes(Integer MarketSegmentId) {
            CoreLibraryWS.GetCoreLibraryCodes_element request_x = new CoreLibraryWS.GetCoreLibraryCodes_element();
            CoreLibraryWS.GetCoreLibraryCodesResponse_element response_x = new CoreLibraryWS.GetCoreLibraryCodesResponse_element();
            request_x.MarketSegmentId = MarketSegmentId;
            Map<String, CoreLibraryWS.GetCoreLibraryCodesResponse_element> response_map_x = new Map<String, CoreLibraryWS.GetCoreLibraryCodesResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest())
            {
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'GetCoreLibraryCodes',
              'http://west.thomson.com/crm/rocketservices/3.0/corelibrary',
              'GetCoreLibraryCodes',
              'http://west.thomson.com/crm/rocketservices/3.0/corelibrary',
              'GetCoreLibraryCodesResponse',
              'CoreLibraryWS.GetCoreLibraryCodesResponse_element'}
            );
            }
            response_x = response_map_x.get('response_x');
            return response_x.CoreLibraryCode;
        }
    }
    public class CoreLibraryMaterial {
        public String SubStatus;
        public Integer Quantity;
        public String MaterialNumber;
        public String MaterialDesc;
        public String CoreLibraryDesc;
        public Integer Priority;
        private String[] SubStatus_type_info = new String[]{'SubStatus','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Quantity_type_info = new String[]{'Quantity','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] MaterialNumber_type_info = new String[]{'MaterialNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] MaterialDesc_type_info = new String[]{'MaterialDesc','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CoreLibraryDesc_type_info = new String[]{'CoreLibraryDesc','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Priority_type_info = new String[]{'Priority','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketxsd/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'SubStatus','Quantity','MaterialNumber','MaterialDesc','CoreLibraryDesc','Priority'};
    }
    public class GetAccountCoreLibraryMaterials_element {
        public String MdbId;
        public Integer MarketSegmentId;
        public CoreLibraryWS.CoreLibrary[] CoreLibrary;
        private String[] MdbId_type_info = new String[]{'MdbId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] MarketSegmentId_type_info = new String[]{'MarketSegmentId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] CoreLibrary_type_info = new String[]{'CoreLibrary','http://west.thomson.com/crm/rocketxsd/3.0/corelibrary','CoreLibrary','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'MdbId','MarketSegmentId','CoreLibrary'};
    }
    public class GetAccountCoreLibraryMaterialsResponse_element {
        public CoreLibraryWS.CoreLibraryMaterial[] CoreLibraryMaterial;
        private String[] CoreLibraryMaterial_type_info = new String[]{'CoreLibraryMaterial','http://west.thomson.com/crm/rocketxsd/3.0/corelibrary','CoreLibraryMaterial','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://west.thomson.com/crm/rocketservices/3.0/corelibrary','true','false'};
        private String[] field_order_type_info = new String[]{'CoreLibraryMaterial'};
    }
}