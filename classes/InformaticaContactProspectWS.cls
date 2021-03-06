//Generated by wsdl2apex

public class InformaticaContactProspectWS {
    public class WS_MDB_Contact_UpsertPort {
        public String endpoint_x = 'https://tr-mis-infadv.thomsonreuters.com/wsh/services/RealTime/WS_MDB_Contact_Upsert';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.informatica.com/wsdl/', 'InformaticaContactProspectWS', 'http://www.informatica.com/', 'InformaticaContactProspectWS'};
        public InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element WS_MDB_Contact_UpsertOperation(InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element WS_MDB_Contact_UpsertRequestElement) {
            InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestType request_x = new InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestType();
            InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType response_x;
            request_x.WS_MDB_Contact_UpsertRequestElement = WS_MDB_Contact_UpsertRequestElement;
            Map<String, InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType> response_map_x = new Map<String, InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType>();
            response_map_x.put('response_x', response_x);
            
            if (Test.isRunningTest()) {
                //Get Mock Response
                object oMockResponse = UnitTest.MockWebServiceResponse.get(MDBIntegrationUtil.UpsertContactServiceName);
                
                if (oMockResponse instanceof WS_MDB_Contact_UpsertResponseType) {
                    response_x = (WS_MDB_Contact_UpsertResponseType) oMockResponse;
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
                  'WS_MDB_Contact_UpsertRequest',
                  'http://www.informatica.com/wsdl/',
                  'WS_MDB_Contact_UpsertResponse',
                  'InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseType'}
                );
                
                 response_x = response_map_x.get('response_x');
            }
           
            return response_x.WS_MDB_Contact_UpsertResponseElement;
        }
    }
    public class WS_MDB_Contact_UpsertRequestType {
        public InformaticaContactProspectWS.WS_MDB_Contact_UpsertRequestElement_element WS_MDB_Contact_UpsertRequestElement;
        private String[] WS_MDB_Contact_UpsertRequestElement_type_info = new String[]{'WS_MDB_Contact_UpsertRequestElement','http://www.informatica.com/wsdl/','WS_MDB_Contact_UpsertRequestElement_element','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'WS_MDB_Contact_UpsertRequestElement'};
    }
    public class WS_MDB_Contact_UpsertResponseType {
        public InformaticaContactProspectWS.WS_MDB_Contact_UpsertResponseElement_element WS_MDB_Contact_UpsertResponseElement;
        private String[] WS_MDB_Contact_UpsertResponseElement_type_info = new String[]{'WS_MDB_Contact_UpsertResponseElement','http://www.informatica.com/wsdl/','WS_MDB_Contact_UpsertResponseElement_element','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'WS_MDB_Contact_UpsertResponseElement'};
    }
    public class WS_MDB_Contact_UpsertResponseElement_element {
        public String MDB_CUSTID;
        public String MDB_CONTACTID;
        private String[] MDB_CUSTID_type_info = new String[]{'MDB_CUSTID','http://www.informatica.com/wsdl/','MDB_CUSTID_element','0','1','false'};
        private String[] MDB_CONTACTID_type_info = new String[]{'MDB_CONTACTID','http://www.informatica.com/wsdl/','MDB_CONTACTID_element','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'MDB_CUSTID','MDB_CONTACTID'};
    }
    public class WS_MDB_Contact_UpsertRequestElement_element {
        public String MDB_CUSTID;
        public String MDB_CONTACTID;
        public String SAP_CONTACTID;
        public String EXTERNAL_SYSTEM;
        public String EXTERNAL_ID;
        public String NAME_TITLE;
        public String NAME_LAST;
        public String NAME_FIRST;
        public String GENDER;
        public String MARITAL_STATUS;
        public String CONTACT_DEPARTMENT;
        public String JOB_FUNCTION;
        public String ONLINE_FLAG;
        public String SOURCE_ID;
        public String NON_SAP_EMAIL;
        public String CONTACT_FUNCTION_CODE;
        public String PERM_MKT_SOURCE_ID;
        public String PHONE;
        public String FAX;
        public String NO_TELEMARKETING_IND;
        public String NO_SALESCARD_IND;
        public String NO_ADVERTISING_IND;
        public String WLEC_DO_NOT_CALL;
        public String CONTACT_ROLES;
        public String CASE_LOADS;
        public String CONTACT_ASSOCATIONS;
        public String CONTACT_EXTERNAL_SYSTEMS;
        public String CONTACT_DELETE_FLAG;
        public String INACTIVE_REASON_CODE;
        public String LAST_UPDATE_USER;
        public String LAST_UPDATE_SYSTEM;
        public String BUYING_HABITS;
        public String CALL_FREQUENCY;
        public String CONTACT_AD_MATERIAL;
        public String CONTACT_HIGH_LVL_PERSON;
        public String CONTACT_NOTES;
        public String VIP_IND;
        public String WORK_DIRECT;
        public String MOBILE;
        public String HOME_PHONE;
        public String WORK_FAX;
        public String ASSISTANT_PHONE;
        private String[] MDB_CUSTID_type_info = new String[]{'MDB_CUSTID','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] MDB_CONTACTID_type_info = new String[]{'MDB_CONTACTID','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] SAP_CONTACTID_type_info = new String[]{'SAP_CONTACTID','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] EXTERNAL_SYSTEM_type_info = new String[]{'EXTERNAL_SYSTEM','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] EXTERNAL_ID_type_info = new String[]{'EXTERNAL_ID','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NAME_TITLE_type_info = new String[]{'NAME_TITLE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NAME_LAST_type_info = new String[]{'NAME_LAST','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NAME_FIRST_type_info = new String[]{'NAME_FIRST','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] GENDER_type_info = new String[]{'GENDER','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] MARITAL_STATUS_type_info = new String[]{'MARITAL_STATUS','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_DEPARTMENT_type_info = new String[]{'CONTACT_DEPARTMENT','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] JOB_FUNCTION_type_info = new String[]{'JOB_FUNCTION','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] ONLINE_FLAG_type_info = new String[]{'ONLINE_FLAG','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] SOURCE_ID_type_info = new String[]{'SOURCE_ID','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NON_SAP_EMAIL_type_info = new String[]{'NON_SAP_EMAIL','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_FUNCTION_CODE_type_info = new String[]{'CONTACT_FUNCTION_CODE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] PERM_MKT_SOURCE_ID_type_info = new String[]{'PERM_MKT_SOURCE_ID','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] PHONE_type_info = new String[]{'PHONE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] FAX_type_info = new String[]{'FAX','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NO_TELEMARKETING_IND_type_info = new String[]{'NO_TELEMARKETING_IND','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NO_SALESCARD_IND_type_info = new String[]{'NO_SALESCARD_IND','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] NO_ADVERTISING_IND_type_info = new String[]{'NO_ADVERTISING_IND','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] WLEC_DO_NOT_CALL_type_info = new String[]{'WLEC_DO_NOT_CALL','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_ROLES_type_info = new String[]{'CONTACT_ROLES','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CASE_LOADS_type_info = new String[]{'CASE_LOADS','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_ASSOCATIONS_type_info = new String[]{'CONTACT_ASSOCATIONS','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_EXTERNAL_SYSTEMS_type_info = new String[]{'CONTACT_EXTERNAL_SYSTEMS','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_DELETE_FLAG_type_info = new String[]{'CONTACT_DELETE_FLAG','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] INACTIVE_REASON_CODE_type_info = new String[]{'INACTIVE_REASON_CODE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] LAST_UPDATE_USER_type_info = new String[]{'LAST_UPDATE_USER','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] LAST_UPDATE_SYSTEM_type_info = new String[]{'LAST_UPDATE_SYSTEM','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] BUYING_HABITS_type_info = new String[]{'BUYING_HABITS','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CALL_FREQUENCY_type_info = new String[]{'CALL_FREQUENCY','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_AD_MATERIAL_type_info = new String[]{'CONTACT_AD_MATERIAL','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_HIGH_LVL_PERSON_type_info = new String[]{'CONTACT_HIGH_LVL_PERSON','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] CONTACT_NOTES_type_info = new String[]{'CONTACT_NOTES','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] VIP_IND_type_info = new String[]{'VIP_IND','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] WORK_DIRECT_type_info = new String[]{'WORK_DIRECT','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] MOBILE_type_info = new String[]{'MOBILE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] HOME_PHONE_type_info = new String[]{'HOME_PHONE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] WORK_FAX_type_info = new String[]{'WORK_FAX','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] ASSISTANT_PHONE_type_info = new String[]{'ASSISTANT_PHONE','http://www.informatica.com/wsdl/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.informatica.com/wsdl/','true','false'};
        private String[] field_order_type_info = new String[]{'MDB_CUSTID','MDB_CONTACTID','SAP_CONTACTID','EXTERNAL_SYSTEM','EXTERNAL_ID','NAME_TITLE','NAME_LAST','NAME_FIRST','GENDER','MARITAL_STATUS','CONTACT_DEPARTMENT','JOB_FUNCTION','ONLINE_FLAG','SOURCE_ID','NON_SAP_EMAIL','CONTACT_FUNCTION_CODE','PERM_MKT_SOURCE_ID','PHONE','FAX','NO_TELEMARKETING_IND','NO_SALESCARD_IND','NO_ADVERTISING_IND','WLEC_DO_NOT_CALL','CONTACT_ROLES','CASE_LOADS','CONTACT_ASSOCATIONS','CONTACT_EXTERNAL_SYSTEMS','CONTACT_DELETE_FLAG','INACTIVE_REASON_CODE','LAST_UPDATE_USER','LAST_UPDATE_SYSTEM','BUYING_HABITS','CALL_FREQUENCY','CONTACT_AD_MATERIAL','CONTACT_HIGH_LVL_PERSON','CONTACT_NOTES','VIP_IND','WORK_DIRECT','MOBILE','HOME_PHONE','WORK_FAX','ASSISTANT_PHONE'};
    }
}