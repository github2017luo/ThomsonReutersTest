public class USL_WestLawContactController {
    
    public WLresponse WLRes{get;set;}
    public List<String> ConSAPIdList{get;set;}
    public LCRM_Contact_SSD__c  ConSSD{get;set;}
    public Boolean iserror{get;set;}
    
   // public USL_Integration_defaults__c val;

    //= USL_Integration_defaults__c.getValues('Integrationdefaults');
    
    public USL_WestLawContactController(ApexPages.StandardController controller){
          //  val = USL_Integration_defaults__c.getValues('Integrationdefaults');
         
       WLRes=new WLresponse();
        ConSAPIdList = new List<String>();
         iserror=false;
         ConSSD = (LCRM_Contact_SSD__c)controller.getRecord();
         ConSSD = [Select Id,LCRM_Contact_ID__c,LCRM_Source_Contact_Id__c,LCRM_Account_SSD__r.LCRM_Sales_Org__c,LCRM_Account_SSD__r.Source_System_Account_Number__c,LCRM_Account_SSD__r.Account_Name__r.Sales_Org__c  FROM LCRM_Contact_SSD__c where id = :ConSSD.id ];  
       
 
           ConSAPIdList.add(ConSSD.LCRM_Source_Contact_Id__c);
           
           
           system.debug('**list**'+ConSAPIdList);
           
   
       WLRes=contactdetails(ConSAPIdList);  
        
    }
    
    public WLresponse contactdetails(List<String> SAPConID){
         USL_Integration_defaults__c val = USL_Integration_defaults__c.getValues('Integrationdefaults');
        WLresponse res= new WLresponse();
        responsewrapper tempres=new responsewrapper();
        try{
        WLConRequest req= new WLConRequest();
        req.Domain=val.domainid__c;
        req.contact=SAPConID;
        
        String calloutRequestBodyJSON = JSON.serialize(req);
        HttpResponse r=USLARHelper.USLARCalloutHelper('USL_WestLawUserPref',calloutRequestBodyJSON);
        system.debug('**WLresponse**'+r);
       if(r.getStatusCode() != 200) {
           ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
           commonCalloutException.setMessage('A callout exception occurred with a status of: ' + r.getStatusCode());
           throw commonCalloutException;
           iserror=true;
        }
        tempres.isSuccess = TRUE;
        tempres.responseBodyJSON = r.getBody();
        
        } catch (Exception e) {
            tempres.isSuccess = FALSE;
            tempres.errorMessage = 'Exception Message: ' + e.getMessage();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            iserror=true;
        }

        if(tempres.IsSuccess){
            system.debug('Response '+tempres.responseBodyJSON);
        res =(WLresponse)JSON.deserialize(tempres.responseBodyJSON, WLresponse.class);
          if(integer.valueof(res.Notification.statusCode)!=200){      
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,res.Notification.statusDescription));       
           }
        }
        else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,tempres.errorMessage));
         iserror=true;
         system.debug(res);
        }
        return res;
    }
    
    
    public class WLConRequest{
        public String domain;
        public List<String> contact;
        public ESIheader ESIHeader;
        USL_Integration_defaults__c val = USL_Integration_defaults__c.getValues('Integrationdefaults');
        
        public WLConRequest(){
           
            Domain='';
            ESIHeader= new EsiHeader(val.Applicationid__c,val.Companyid__c);
            contact=new List<String>();
        }
    }
     public class EsiHeader {
        public String applicationId{get;set;}
        public String companyId{get;set;}
        
        public EsiHeader(String appid,String comid){
            this.applicationId=appid;
            this.companyId=comid;
        }
    }
    public class WLresponse{
    public cls_esiHeader esiHeader{get;set;}
    public cls_Notification Notification{get;set;}
    public List<cUserPreferences> UserPreferences{get;set;}
    }
  public class cls_esiHeader {
        public String applicationId{get;set;}   //SC
        public String messageId{get;set;}   //d907065c-623c-47c1-9e25-7e2388a26f9d
    }
  public    class cls_Notification {
        public String statusCode{get;set;}  //200
        public String statusDescription{get;set;}   //Success
    }
  public class cUserPreferences {
        public List<cpreference> preference{get;set;}
        public String domain{get;set;}  //COBALT
        public String contactNumber{get;set;}   //0010377042
        public String customerNumber{get;set;}  //1000486310
        public String guid{get;set;}//ia744d779000001368307450ff4ba46f8
        public String startTime{get;set;}   //00:00:00
    }
 public class cpreference {
        public String prefName{get;set;}    //ONLINE HELP
        public String prefValue{get;set;}   //3
        public String prefDesc{get;set;}    //Online Help for Customers
        public String startDate{get;set;}   //2012-04-06
        public String endDate{get;set;} //2014-12-01
    }
    
    
    public class responsewrapper{
        public responsewrapper () { }
        public String responseBodyJSON { get; set; }
        public Boolean isSuccess { get; set; }
        public String errorMessage { get; set; }
    }

}