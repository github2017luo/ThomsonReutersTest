/**
 * CHANGE HISTORY
 * ===========================================================================================================
 * Date         Name                    Description
 * 2017-18-07   Rajashree               Created a consolidated class to store APEX code created from converting 
                                                the JSON sample received from ESI for both request and response.
 * ============================================================================================================
 */


global class ProviewSerializeandDeserialize {
    //json serialization class to construct a request
     
   global class ProviewRequest {
        public cls_referenceIds[] referenceIds;
        public cls_ESIHeader ESIHeader;
        public cls_onlineContact[] onlineContact;
        public cls_contact[] contact;
        public String actionCode; 
        public ProviewRequest(){
            referenceIds = new List<cls_referenceIds>() ;
            ESIHeader = new cls_ESIHeader();
            onlineContact = new List<cls_onlineContact>();
            contact = new List<cls_contact>();
            actionCode = '';
        }
     }
    public class cls_referenceIds {
        public String sourceSystemRefIdType ;  //?   --------> Opportunity ??
        public String value;//?   Is this the number tag ??? Opportinty id
        public cls_referenceIds(){
            sourceSystemRefIdType ='';
            value='';
        }
    }
    public class cls_contact {
        public cls_account account;
        public String contactId; //? --> Sold_to_Contact_ID__c
        public String firstName;  //? ---> Sold_To_Contact__c.firstname
        public String lastName ;//?  ---> Sold_To_Contact__c.lastname
        public String email;   //?  ---> Sold_To_Contact__c.email2
        public cls_contact() {
            account = new cls_account();
            contactId ='';   
            firstName = '';   
            lastName = ''; 
            email = '';   
        }
    }
    public class cls_account {
        public String accountNumber ;  //?   --- > SAP Account Number
        public cls_account(){
            accountNumber = '';
        }
    }
   
    public class cls_ESIHeader { 
        public String applicationId;  //?  
        public String companyId ;  //?---> Reuse the Orderpostback parameter
        public String configGroup ; //? --->  IXOS Mapping custom settings.
        public cls_ESIHeader(){
            applicationId ='';   
            companyId='';   
            configGroup='';  
        }
    }
    public class cls_onlineContact {
        public String contactId; //?
        public String firstName; //?
        public String lastName; //?
        public String email;  //?
        public cls_account account ;
        public cls_entitlements[] entitlements ;
        public cls_Notification Notification; // Needed to get response status
        public cls_properties[] properties;
        public cls_property[] property;
        public cls_onlineContact(){
            contactId='';
            firstName='';
            lastName='';
            email='';
            account = new cls_account();  
            properties= new List<cls_properties>();
            property= new List<cls_property>();
            entitlements= new List<cls_entitlements>();
            Notification = new cls_Notification();
           
        }
    }  
     public class cls_entitlements {
      //  public String domainId ;//?    ----- > E reader ???
        public cls_subscriptions[] subscriptions;
        public cls_tokenDetails[] tokenDetails; // Needed to get response token
        public cls_entitlements(){
         //   domainId = ''; 
            subscriptions = new List<cls_subscriptions>();
            tokenDetails = new List<cls_tokenDetails>();
        }
    }
    public class cls_subscriptions {
     //   public String subNumber; //?   
        public cls_materialNumber[] materialNumber ;
        //public cls_properties[] properties;
        public cls_lines[] lines;      // ----> OLI Line Number
        public cls_subscriptions(){
            lines= new List<cls_lines>();    
            materialNumber = new List<cls_materialNumber>();
           // properties= new List<cls_properties>();
         //   subNumber ='';
        }
    } 
    public class cls_lines{
        public String lineNumber; 
        public cls_lines(){
         lineNumber ='';        
        }
    }
    public class cls_materialNumber {
        public String materialNumber;//? --> Product2
        public String configType; // Sales org
        public String quantity; 
        public String description; 
        public String classificationValue;   
        public cls_materialNumber(){
            materialNumber= '';  
            configType ='';
            description ='';
        }
    } 
    
   public class cls_properties {
        public String key;  //?
        public String value;    //?
    }
    public class cls_property {
        public String key;  //?
        public String value;    //?
    }  
    // class to deserialize the Json response
   global class ProviewResponse {
      public cls_Notification Notification;
        public cls_onlineContact[] onlineContact;
       // public cls_contact contact;
        public ProviewResponse(){
            Notification = new cls_Notification();
            onlineContact = new List<cls_onlineContact>();
          //  contact = new cls_contact();
        }  
   }
   
 
    public class cls_Notification {
        public String statusCode;   
        public String statusDescription;
        public cls_Notification(){
             statusCode='';   
             statusDescription='';        
        } 
    }
    public class cls_tokenDetails {
        public String tokenNumber;  //?
        public String noOfUses; //?
        public String noOfRedeemed; //?
        public String description;  //?
        public String issuedDate;   //?
        public String endDate;  //?
       public String status;   //?
        public String url;  //?
       public String actionCode;   //?   
        public cls_tokenDetails(){
            tokenNumber='';  
            noOfUses=''; 
            noOfRedeemed=''; 
            description='';  
            issuedDate='';  
            status='';   
            url='';  
           actionCode='';
        }
    }
}