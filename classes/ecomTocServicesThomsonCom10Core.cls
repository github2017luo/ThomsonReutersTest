//Generated by wsdl2apex

public class ecomTocServicesThomsonCom10Core {
    public class CoreSystemError {
        public String reason;
        public String errorKey;
        private String[] reason_type_info = new String[]{'reason','http://ecom.toc.services.thomson.com/1.0/core','CoreExceptionReason','1','1','false'};
        private String[] errorKey_type_info = new String[]{'errorKey','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'reason','errorKey'};
    }
    public class CoreServiceError {
        public String errorKey;
        private String[] errorKey_type_info = new String[]{'errorKey','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'errorKey'};
    }
    public class Message {
        public String id;
        public String key;
        public String severity;
        public String message;
        private String[] id_type_info = new String[]{'id','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] key_type_info = new String[]{'key','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] severity_type_info = new String[]{'severity','http://ecom.toc.services.thomson.com/1.0/core','MessageSeverity','1','1','false'};
        private String[] message_type_info = new String[]{'message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'id','key','severity','message'};
    }
    public class CoreValidationError {
        public String reason;
        public String description;
        private String[] reason_type_info = new String[]{'reason','http://ecom.toc.services.thomson.com/1.0/core','ValidationExceptionReason','1','1','false'};
        private String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'reason','description'};
    }
    public class Response {
        public String trackingId;
        public ecomTocServicesThomsonCom10Core.Message[] messages;
        private String[] trackingId_type_info = new String[]{'trackingId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] messages_type_info = new String[]{'messages','http://ecom.toc.services.thomson.com/1.0/core','Message','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'trackingId','messages'};
    }
    public class Account {
        public String accountNumber;
        public String companyId;
        private String[] accountNumber_type_info = new String[]{'accountNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] companyId_type_info = new String[]{'companyId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'accountNumber','companyId'};
    }
    public class RequestContext {
        public String productId;
        public String configGroup;
        public String language;
        public ecomTocServicesThomsonCom10Core.Account account;
        public String linkedTrackingId;
        private String[] productId_type_info = new String[]{'productId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] configGroup_type_info = new String[]{'configGroup','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] language_type_info = new String[]{'language','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] account_type_info = new String[]{'account','http://ecom.toc.services.thomson.com/1.0/core','Account','0','1','false'};
        private String[] linkedTrackingId_type_info = new String[]{'linkedTrackingId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'productId','configGroup','language','account','linkedTrackingId'};
    }
    public class Request {
        public ecomTocServicesThomsonCom10Core.RequestContext context;
        private String[] context_type_info = new String[]{'context','http://ecom.toc.services.thomson.com/1.0/core','RequestContext','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'context'};
    }
    public class CoreError {
        public String rootId;
        public String serverName;
        public ecomTocServicesThomsonCom10Core.Message[] messages;
        private String[] rootId_type_info = new String[]{'rootId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] serverName_type_info = new String[]{'serverName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] messages_type_info = new String[]{'messages','http://ecom.toc.services.thomson.com/1.0/core','Message','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'rootId','serverName','messages'};
    }
    public class Property {
        public String key;
        public String value;
        private String[] key_type_info = new String[]{'key','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] value_type_info = new String[]{'value','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'key','value'};
    }
    public class ExtensibleObject {
        public ecomTocServicesThomsonCom10Core.Property[] properties;
        private String[] properties_type_info = new String[]{'properties','http://ecom.toc.services.thomson.com/1.0/core','Property','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://ecom.toc.services.thomson.com/1.0/core','false','false'};
        private String[] field_order_type_info = new String[]{'properties'};
    }
}