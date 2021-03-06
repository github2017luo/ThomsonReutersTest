//Generated by wsdl2apex

public class ecomTocServicesThomsonComService1PD1 {  
    public class Account {
        public String accountNumber;
        public String companyId;
        private String[] accountNumber_type_info = new String[]{'accountNumber','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
        private String[] companyId_type_info = new String[]{'companyId','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        private String[] field_order_type_info = new String[]{'accountNumber','companyId'};
    }
    public class context_element {
        public String productId;
        public String configGroup;
        private String[] productId_type_info = new String[]{'productId','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] configGroup_type_info = new String[]{'configGroup','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        private String[] field_order_type_info = new String[]{'productId','configGroup'};
    }
    public class getLicensesResponse_element {
        public ecomTocServicesThomsonComService1PD1.GetLicensesResponse[] response;
        private String[] response_type_info = new String[]{'response','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        private String[] field_order_type_info = new String[]{'response'};
    }
    public class getLicenses_element {
        public ecomTocServicesThomsonComService1PD1.GetLicensesRequest request;
        private String[] request_type_info = new String[]{'request','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class License {
        public String keyCode{get;set;}
        public String licenseType{get;set;}
        public Integer seats{get;set;}
        public Date expirationDate{get;set;}
        public Date issueDate{get;set;}
        public String licenseStatus{get;set;}
        public String licenseDesc{get;set;}
        public String licenseContact{get;set;}
        public String generatedBy{get;set;}
        public Boolean tokensRequired{get;set;}
        public Integer webSeats{get;set;}
        public Boolean productActivated{get;set;}
        public Boolean outlinesIncluded{get;set;}
        public String machineID{get;set;}
        public String sequenceID{get;set;}
        private String[] keyCode_type_info = new String[]{'keyCode','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] licenseType_type_info = new String[]{'licenseType','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] seats_type_info = new String[]{'seats','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] expirationDate_type_info = new String[]{'expirationDate','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] issueDate_type_info = new String[]{'issueDate','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] licenseStatus_type_info = new String[]{'licenseStatus','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] licenseDesc_type_info = new String[]{'licenseDesc','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] licenseContact_type_info = new String[]{'licenseContact','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] generatedBy_type_info = new String[]{'generatedBy','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] tokensRequired_type_info = new String[]{'tokensRequired','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] webSeats_type_info = new String[]{'webSeats','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] productActivated_type_info = new String[]{'productActivated','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] outlinesIncluded_type_info = new String[]{'outlinesIncluded','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] machineID_type_info = new String[]{'machineID','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
        private String[] sequenceID_type_info = new String[]{'sequenceID','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        private String[] field_order_type_info = new String[]{'keyCode','licenseType','seats','expirationDate','issueDate','licenseStatus','licenseDesc','licenseContact','generatedBy','tokensRequired','webSeats','productActivated','outlinesIncluded','machineID','sequenceID'};
    }
    public class installationCodeList {
         public String installCode {get;set;}
         public Date installCodeReleaseDate {get;set;}
         public String currentRelease {get;set;}   
         private String[] installCode_type_info = new String[]{'installCode','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
         private String[] installCodeReleaseDate_type_info = new String[]{'installCodeReleaseDate','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','true'};
         private String[] currentRelease_type_info = new String[]{'currentRelease','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','true'};
         private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
         private String[] field_order_type_info = new String[]{'installCode','installCodeReleaseDate','currentRelease'};
    }
    public class GetLicensesRequest {
        public ecomTocServicesThomsonComService1PD1.context_element context;
        public ecomTocServicesThomsonComService1PD1.Account account;
     //   public String accountNumber;
    //    public String companyId;
     //   public String productId;
        public String materialNumber;
        public String licensedProduct;
        private String[] context_type_info = new String[]{'context','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] account_type_info = new String[]{'account','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] materialNumber_type_info = new String[]{'materialNumber','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] licensedProduct_type_info = new String[]{'licensedProduct','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        private String[] field_order_type_info = new String[]{'context','account','materialNumber','licensedProduct'};
    }
    public class GetLicensesResponse {
        public ecomTocServicesThomsonCom20Common.Confirmation[] confirmations;
        public String trackingId{get;set;}
        public ecomTocServicesThomsonComService1PD1.License[] licenses;
        public ecomTocServicesThomsonComService1PD1.installationCodeList[] installationCodeList;
        public String stateAbbreviation{get;set;}
        // public String installCode;
        // public Date installCodeReleaseDate;
        private String[] confirmations_type_info = new String[]{'confirmations','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','-1','true'};
        private String[] trackingId_type_info = new String[]{'trackingId','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'1','1','true'};
        private String[] licenses_type_info = new String[]{'licenses','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','-1','false'};
        private String[] installationCodeList_type_info = new String[]{'installationCodeList','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','-1','false'};       
       // private String[] installCode_type_info = new String[]{'installCode','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
       // private String[] installCodeReleaseDate_type_info = new String[]{'installCodeReleaseDate','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
        private String[] stateAbbreviation_type_info = new String[]{'stateAbbreviation','http://ecom.toc.services.thomson.com/service/1.0/subscription',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/service/1.0/subscription','false','false'};
        //private String[] field_order_type_info = new String[]{'confirmations','trackingId','licenses','installCode','installCodeReleaseDate'};
        private String[] field_order_type_info = new String[]{'confirmations','trackingId','licenses','installationCodeList','stateAbbreviation'};
    }
    public class SubscriptionServiceV01 {
     //   public String endpoint_x = 'http://dev.myacctsvcs.int.westgroup.com/ecomsoa/services/SubscriptionService';
     public String endpoint_x = 'https://mis-soa.thomsonreuters.com/ecomsoa/services/SubscriptionService';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public tocSchemasThomsonComHeaders200602.TocHeader_element header;
        private String header_hns = 'TocHeader=http://toc.schemas.thomson.com/headers/2006-02-01';
        private String[] ns_map_type_info = new String[]{'http://ecom.toc.services.thomson.com/2.0/common', 'ecomTocServicesThomsonCom20Common', 'http://toc.schemas.thomson.com/headers/2006-02-01', 'tocSchemasThomsonComHeaders200602', 'http://ecom.toc.schemas.thomson.com/headers/2007-06-01', 'ecomTocSchemasThomsonComHeaders200LN1', 'http://ecom.toc.services.thomson.com/service/1.0/subscription', 'ecomTocServicesThomsonComService1PD1', 'http://tlr.schemas.thomson.com/headers/2006-02-01', 'tlrSchemasThomsonComHeaders200602'};
        public ecomTocServicesThomsonComService1PD1.GetLicensesResponse[] getLicenses(ecomTocServicesThomsonComService1PD1.GetLicensesRequest request) {
            ecomTocServicesThomsonComService1PD1.getLicenses_element request_x = new ecomTocServicesThomsonComService1PD1.getLicenses_element();
            request_x.request = request;
            ecomTocServicesThomsonComService1PD1.getLicensesResponse_element response_x;
            Map<String, ecomTocServicesThomsonComService1PD1.getLicensesResponse_element> response_map_x = new Map<String, ecomTocServicesThomsonComService1PD1.getLicensesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'getLicenses',
              'http://ecom.toc.services.thomson.com/service/1.0/subscription',
              'getLicenses',
              'http://ecom.toc.services.thomson.com/service/1.0/subscription',
              'getLicensesResponse',
              'ecomTocServicesThomsonComService1PD1.getLicensesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.response;
        }
    }
}