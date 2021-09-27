//Generated by wsdl2apex

public class ContactPersonIDWSDL {
    public class wf_m_MCM_GERATE_PERSON_ID_NEWPort {
        public String endpoint_x = 'http://gustavus:7334/wsh/services/RealTime/wf_m_MCM_GERATE_PERSON_ID_NEW';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.informatica.com/', 'ContactPersonIDWSDL', 'http://www.informatica.com/wsdl/', 'ContactPersonIDWSDLObjects'};
        public ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseElement_element wf_m_MCM_GERATE_PERSON_ID_NEWOperation(ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestElement_element WS_GENERATE_NEW_PERSON_IDRequestElement) {
            ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestType request_x = new ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDRequestType();
            request_x.WS_GENERATE_NEW_PERSON_IDRequestElement = WS_GENERATE_NEW_PERSON_IDRequestElement;
            ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseType response_x;
            Map<String, ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseType> response_map_x = new Map<String, ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://www.informatica.com/wsdl/',
              'WS_GENERATE_NEW_PERSON_IDRequest',
              'http://www.informatica.com/wsdl/',
              'WS_GENERATE_NEW_PERSON_IDResponse',
              'ContactPersonIDWSDLObjects.WS_GENERATE_NEW_PERSON_IDResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.WS_GENERATE_NEW_PERSON_IDResponseElement;
        }
    }
}