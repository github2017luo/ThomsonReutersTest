//Generated by wsdl2apex

public class InformaticaCustomerMatchWS {
    public class WS_CustomerMatchResponseType {
        public InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] WS_CustomerMatchResponseElement;
        private String[] WS_CustomerMatchResponseElement_type_info = new String[]{'WS_CustomerMatchResponseElement','http://www.informatica.com/wsdl/','WS_CustomerMatchResponseElement_element','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'WS_CustomerMatchResponseElement'};
    }
    public class WS_CustomerMatchRequestType {
        public InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element[] WS_CustomerMatchRequestElement;
        private String[] WS_CustomerMatchRequestElement_type_info = new String[]{'WS_CustomerMatchRequestElement','http://www.informatica.com/wsdl/','WS_CustomerMatchRequestElement_element','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'WS_CustomerMatchRequestElement'};
    }
    public class WS_CustomerMatchRequestElement_element {
        public String ID;
        public String NAME;
        public String NAME2;
        public String NAME3;
        public String ADDRESS;
        public String CITY;
        public String ZIPCODE;
        public String COUNTRYCODE;
        private String[] ID_type_info = new String[]{'ID','http://www.informatica.com/wsdl/','ID_element','0','1','false'};
        private String[] NAME_type_info = new String[]{'NAME','http://www.informatica.com/wsdl/','NAME_element','0','1','false'};
        private String[] NAME2_type_info = new String[]{'NAME2','http://www.informatica.com/wsdl/','NAME2_element','0','1','false'};
        private String[] NAME3_type_info = new String[]{'NAME3','http://www.informatica.com/wsdl/','NAME3_element','0','1','false'};
        private String[] ADDRESS_type_info = new String[]{'ADDRESS','http://www.informatica.com/wsdl/','ADDRESS_element','0','1','false'};
        private String[] CITY_type_info = new String[]{'CITY','http://www.informatica.com/wsdl/','CITY_element','0','1','false'};
        private String[] ZIPCODE_type_info = new String[]{'ZIPCODE','http://www.informatica.com/wsdl/','ZIPCODE_element','0','1','false'};
        private String[] COUNTRYCODE_type_info = new String[]{'COUNTRYCODE','http://www.informatica.com/wsdl/','COUNTRYCODE_element','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'ID','NAME','NAME2','NAME3','ADDRESS','CITY','ZIPCODE','COUNTRYCODE'};
    }
    public class WS_Customer_MatchPort {
        public String endpoint_x = 'https://tr-mis-infadv.thomsonreuters.com/wsh/services/RealTime/WS_Customer_Match';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.informatica.com/wsdl/', 'InformaticaCustomerMatchWS', 'http://www.informatica.com/', 'InformaticaCustomerMatchWS'};
        public InformaticaCustomerMatchWS.WS_CustomerMatchResponseElement_element[] WS_Customer_MatchOperation(InformaticaCustomerMatchWS.WS_CustomerMatchRequestElement_element[] WS_CustomerMatchRequestElement) {
            InformaticaCustomerMatchWS.WS_CustomerMatchRequestType request_x = new InformaticaCustomerMatchWS.WS_CustomerMatchRequestType();
            InformaticaCustomerMatchWS.WS_CustomerMatchResponseType response_x;
            request_x.WS_CustomerMatchRequestElement = WS_CustomerMatchRequestElement;
            Map<String, InformaticaCustomerMatchWS.WS_CustomerMatchResponseType> response_map_x = new Map<String, InformaticaCustomerMatchWS.WS_CustomerMatchResponseType>();
            response_map_x.put('response_x', response_x);
            
            if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(DataQualityUtil.AccountMatchingServiceName);
                
                if (oMockResponse instanceof WS_CustomerMatchResponseType) {
                    response_x = (WS_CustomerMatchResponseType) oMockResponse;
                }
            }
            else {
                WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'http://www.informatica.com/wsdl/',
	              'WS_CustomerMatchRequest',
	              'http://www.informatica.com/wsdl/',
	              'WS_CustomerMatchResponse',
	              'InformaticaCustomerMatchWS.WS_CustomerMatchResponseType'}
	            );
                
                response_x = response_map_x.get('response_x');
            }
            
            return response_x.WS_CustomerMatchResponseElement;
        }
    }
    public class WS_CustomerMatchResponseElement_element {
        public String SOURCE_ID;
        public String SOURCE_NAME;
        public String SOURCE_NAME2;
        public String SOURCE_NAME3;
        public String SOURCE_ADDRESS;
        public String SOURCE_CITY;
        public String SOURCE_ZIPCODE;
        public String SOURCE_COUNTRYCODE;
        public String MATCH_MDBID;
        public String MATCH_SAPID;
        public String MATCH_NAME;
        public String MATCH_NAME2;
        public String MATCH_NAME3;
        public String MATCH_ADDRESS;
        public String MATCH_CITY;
        public String MATCH_ZIPCODE;
        public String MATCH_COUNTRYCODE;
        public String MATCH_SCORE;
        private String[] SOURCE_ID_type_info = new String[]{'SOURCE_ID','http://www.informatica.com/wsdl/','SOURCE_ID_element','0','1','false'};
        private String[] SOURCE_NAME_type_info = new String[]{'SOURCE_NAME','http://www.informatica.com/wsdl/','SOURCE_NAME_element','0','1','false'};
        private String[] SOURCE_NAME2_type_info = new String[]{'SOURCE_NAME2','http://www.informatica.com/wsdl/','SOURCE_NAME2_element','0','1','false'};
        private String[] SOURCE_NAME3_type_info = new String[]{'SOURCE_NAME3','http://www.informatica.com/wsdl/','SOURCE_NAME3_element','0','1','false'};
        private String[] SOURCE_ADDRESS_type_info = new String[]{'SOURCE_ADDRESS','http://www.informatica.com/wsdl/','SOURCE_ADDRESS_element','0','1','false'};
        private String[] SOURCE_CITY_type_info = new String[]{'SOURCE_CITY','http://www.informatica.com/wsdl/','SOURCE_CITY_element','0','1','false'};
        private String[] SOURCE_ZIPCODE_type_info = new String[]{'SOURCE_ZIPCODE','http://www.informatica.com/wsdl/','SOURCE_ZIPCODE_element','0','1','false'};
        private String[] SOURCE_COUNTRYCODE_type_info = new String[]{'SOURCE_COUNTRYCODE','http://www.informatica.com/wsdl/','SOURCE_COUNTRYCODE_element','0','1','false'};
        private String[] MATCH_MDBID_type_info = new String[]{'MATCH_MDBID','http://www.informatica.com/wsdl/','MATCH_MDBID_element','0','1','false'};
        private String[] MATCH_SAPID_type_info = new String[]{'MATCH_SAPID','http://www.informatica.com/wsdl/','MATCH_SAPID_element','0','1','false'};
        private String[] MATCH_NAME_type_info = new String[]{'MATCH_NAME','http://www.informatica.com/wsdl/','MATCH_NAME_element','0','1','false'};
        private String[] MATCH_NAME2_type_info = new String[]{'MATCH_NAME2','http://www.informatica.com/wsdl/','MATCH_NAME2_element','0','1','false'};
        private String[] MATCH_NAME3_type_info = new String[]{'MATCH_NAME3','http://www.informatica.com/wsdl/','MATCH_NAME3_element','0','1','false'};
        private String[] MATCH_ADDRESS_type_info = new String[]{'MATCH_ADDRESS','http://www.informatica.com/wsdl/','MATCH_ADDRESS_element','0','1','false'};
        private String[] MATCH_CITY_type_info = new String[]{'MATCH_CITY','http://www.informatica.com/wsdl/','MATCH_CITY_element','0','1','false'};
        private String[] MATCH_ZIPCODE_type_info = new String[]{'MATCH_ZIPCODE','http://www.informatica.com/wsdl/','MATCH_ZIPCODE_element','0','1','false'};
        private String[] MATCH_COUNTRYCODE_type_info = new String[]{'MATCH_COUNTRYCODE','http://www.informatica.com/wsdl/','MATCH_COUNTRYCODE_element','0','1','false'};
        private String[] MATCH_SCORE_type_info = new String[]{'MATCH_SCORE','http://www.informatica.com/wsdl/','MATCH_SCORE_element','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'SOURCE_ID','SOURCE_NAME','SOURCE_NAME2','SOURCE_NAME3','SOURCE_ADDRESS','SOURCE_CITY','SOURCE_ZIPCODE','SOURCE_COUNTRYCODE','MATCH_MDBID','MATCH_SAPID','MATCH_NAME','MATCH_NAME2','MATCH_NAME3','MATCH_ADDRESS','MATCH_CITY','MATCH_ZIPCODE','MATCH_COUNTRYCODE','MATCH_SCORE'};
    }
}