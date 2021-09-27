/*This class calls out to the Geneva instance to fetch the Leads refferred By the calling User 
and also fetch the Leads referred to the user in the Local instance*/
public class GlobalReferralController {
   private final String clientId;
   private final String clientSecret;
   private final String username;
   private final String password;
   private final String oppSourceField;

   
   public List<referralInputs> recordsList {get;set;}
   public List<LeadsWrapper> leadWrapList{get;set;}
   public List<OppWrapper> oppWrapList{get;set;}
   
   public List<Lead> LeadsList {get;set;}
   public List<Opportunity> OpportunityList {get;set;}
   public static List<User> userListForId = new List<User>();
    public static Map<String,Global_Referral_Integration__c> allCodes = new Map<String,Global_Referral_Integration__c>();
    
    public static string sortableField{get;set;}
    public static string sortOrder{get;set;}
    public string previoussortfield{get;set;}
    public static string sortableFieldLead{get;set;}
    public static string sortOrderLead{get;set;}
    public string previoussortfieldLead{get;set;}
    public static string sortableFieldOpp{get;set;}
    public static string sortOrderOpp{get;set;}
    public string previoussortfieldOpp{get;set;}
   
   public GlobalReferralController() {
       
       allCodes  = Global_Referral_Integration__c.getAll();
       clientId =allcodes.get('ConsumerKey').SettingValue__c;
       clientSecret =allcodes.get('ConsumerSecret').SettingValue__c;
       username=allcodes.get('IntegrationUserName').SettingValue__c;
       password  =allcodes.get('IntegrationPassword').SettingValue__c;
       oppSourceField =allcodes.get('SourceField').SettingValue__c;

       System.debug(allcodes.get('IntegrationUserName').SettingValue__c+'%%%%%%');
       //sortableField='Companyname';
       //sortOrder='asc';
       recordsList = new List<referralInputs>();
       leadWrapList = new List<LeadsWrapper>();
       oppWrapList = new List<OppWrapper>();
   }
   
   public class deserializeResponse
   {
      public String id;
      public String access_token;
   }
   
   public class ReferralIds
   {
      public String employeeId;
      
   }
   /*This method fetches the access token from the Geneva intance to make future calls using th access token*/
   public String ReturnAccessToken ()
   {
      String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
      Http h = new Http();
      HttpRequest req = new HttpRequest();
      req.setBody(reqbody);
      req.setMethod('POST');
      //req.setEndpoint('https://test.salesforce.com/services/oauth2/token');
      req.setEndpoint(allcodes.get('OAuthEndpoint').SettingValue__c);
      deserializeResponse resp1;
      try{
        HttpResponse res = h.send(req);
        resp1 = (deserializeResponse)JSON.deserialize(res.getbody(),deserializeResponse.class);
        System.debug('BODY: '+res.getBody());

        System.debug('STATUS:'+res.getStatus());

        System.debug('STATUS_CODE:'+res.getStatusCode());

      }
      catch(Exception e){
      System.debug('Exception in callout rest access token'+e);
      }
      
      
      return resp1.access_token;
   }
    /*this method makes the callout to the Geneva instance to fetch the referrals and formats the records in the wrapper class type list*/
    public void callGeneva(){
    leadWrapList.clear();
    oppWrapList.clear();
    GlobalReferralController referral= new GlobalReferralController ();
    String accessToken = referral.ReturnAccessToken();
    
    try{
       if(accessToken != null){
          //String endPoint = 'https://cs44.salesforce.com/services/apexrest/v1/createAccount/';
          //String endPoint = 'https://cs28.salesforce.com/services/apexrest/v1/createAccount/';
          String endPoint = allcodes.get('GenevaWebserviceEndpoint').SettingValue__c;
          List<ReferralIds> listSt= new List<ReferralIds>();
         //List<String> empList = getReferralIdList('Employee');
         
         for(String s:getReferralIdList('Employee')){
             ReferralIds a1= new ReferralIds();
             a1.employeeId=s;
             listSt.add(a1);
         }
         
          String jsonstr = JSON.serialize(listSt);    
         
          System.debug(jsonstr +'::::string in JSON');
          Http h2 = new Http();
          HttpRequest req1 = new HttpRequest();
          req1.setHeader('Authorization','Bearer ' + accessToken);
          req1.setHeader('Content-Type','application/json');
          req1.setHeader('accept','application/json');
          req1.setBody(jsonstr);
          req1.setMethod('POST');
          req1.setEndpoint(endPoint);
          HttpResponse res1 = h2.send(req1);
          
          System.debug('BODY: '+res1.getBody());

          System.debug('STATUS:'+res1.getStatus());

          System.debug('STATUS_CODE:'+res1.getStatusCode());

          String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
          
          recordsList  = (List<referralInputs>)JSON.deserialize(trimmedResponse ,List<referralInputs>.class);
          
          
          }
       }
       catch(Exception e){
        System.debug('Exception in the callout'+e);
       }
   }
   
   //method to query the Leads reffered to the Logged in User in the local BU
   public void sendLeadsReferred(){
   recordsList.clear();
   leadWrapList.clear();
   oppWrapList.clear();
   List<User> leadOwnerName = new List<User>();
   Map<id,String> leadOwnerMap = new Map<id,String>();
   Date twoyears = System.today().addyears(-2);
   LeadsList=[Select name,id,Status,ownerId,Company,createddate from Lead where ownerId IN :getReferralIdList('salesforceId') and LeadSource='Cross TR Referral' AND createdDate>:twoyears ORDER by createdDate DESC];
   leadOwnerName=[Select id,name from user where id IN:getReferralIdList('salesforceId')];
   for(User uservar:leadOwnerName ){
   leadOwnerMap.put(uservar.id,uservar.name);
   }
   for(Lead leadvar:LeadsList){
   LeadsWrapper leadobj = new LeadsWrapper();
   leadobj.Companyname= leadvar.company;
   leadobj.status= leadvar.status;
   leadobj.createddate= date.newinstance(leadvar.createdDate.year(), leadvar.createdDate.month(), leadvar.createdDate.day());
   leadobj.LeadOwner= leadOwnerMap.get(leadvar.ownerid);
   leadobj.LeadOwnerId= leadvar.ownerid;
   leadobj.Leadname= leadvar.name;
   leadobj.LeadId= leadvar.Id;
   leadWrapList.add(leadobj );
   }
      System.debug(oppSourceField +'*********');
   String QueryString ;
   string source ='Cross TR Referral';
   List<String> queryrefIdList = getReferralIdList('salesforceId');
     QueryString = 'Select name,id,CloseDate,account.name,StageName,Amount,createdDate,ownerId From Opportunity';
     
        QueryString += ' where ownerId IN: queryrefIdList ' ;
        QueryString += ' AND '+oppSourceField +' = \''+source +'\'';
        QueryString += ' AND createdDate>:twoyears ORDER BY createddate DESC';
       System.debug(QueryString +'&&&&&&&&&&&&&&&&'); 
       OpportunityList= Database.query(QueryString);
   //OpportunityList=[Select name,id,CloseDate,account.name,StageName,Amount,createdDate,ownerId  from Opportunity where ownerId IN :getReferralIdList('salesforceId') and LeadSource='Cross TR Referral' AND createdDate>:twoyears ORDER BY createddate DESC];
   for(Opportunity oppvar:OpportunityList){
   OppWrapper oppobj = new OppWrapper();
   oppobj.stage= oppvar.stageName;
   oppobj.createddate= date.newinstance(oppvar.createdDate.year(), oppvar.createdDate.month(), oppvar.createdDate.day());
   oppobj.OppOwner= leadOwnerMap.get(oppvar.ownerid);
   oppobj.OppOwnerId= oppvar.ownerid;
   oppobj.closeddate= oppvar.closedate;
   oppobj.Oppname= oppvar.name;
   oppobj.OppId= oppvar.Id;
   oppobj.amount= oppvar.amount;
   oppobj.companyname= oppvar.account.name;
   oppWrapList.add(oppobj );
   }
   
   
   }
   public static void test(){
       
    }
   
   //method to get the ids of all usesrs who have the logged in user listed as the manager at all levels
   public static List<String>getReferralIdList(String Idtype){
       List<User> userListAll =[Select name,id,email,EmployeeNumber,ManagerId from User];
       List<String> referralList = new List<String>();
       List<User> userList =  GetSubordinates(userListAll ,UserInfo.getUserID());
       List<String> salesforceIdList =new List<String>();
       System.debug('$$$:::'+userList );
       for(User u :userList ){
           referralList.add(u.email);
           if(u.email.contains('thomsonreuters.com'))
           referralList.add(u.email.replace('thomsonreuters.com','tr.com'));
           if(u.email.contains('tr.com'))
           referralList.add(u.email.replace('tr.com','thomsonreuters.com'));
           salesforceIdList.add(u.Id);
       }
       salesforceIdList.add(UserInfo.getUserId());  
       User loggedUser =[Select id,email,EmployeeNumber from User where id=:UserInfo.getUserId()]; 
       referralList.add(loggedUser.email);
       
       if(loggedUser.email.contains('thomsonreuters.com'))
       referralList.add(loggedUser.email.replace('thomsonreuters.com','tr.com'));
       if(loggedUser.email.contains('tr.com'))
       referralList.add(loggedUser.email.replace('tr.com','thomsonreuters.com'));
           
       if (Idtype == 'Employee')
       return referralList;
       else
       return salesforceIdList;
   }
   /*this method returns the emailId and user id of all employees who have the looged in user listed as their 
   manager on their user record and also of employees under them at all levels.*/
   public static List<User> GetSubordinates(List<User> userListALL, String userid)
   {
   System.debug(userid+'::::::');
    for(User u:userListALL){
        if(u.ManagerId != userid)
         continue;
        userListForId.add(u);
        GetSubordinates(userListALL,u.id);
     }
     System.debug(userListForId+'::::::');
     return userListForId;
   }
   
   //method to sort the referrals
    public Pagereference doSort(){      
        //sortorder='asc'; 
        sortableField=ApexPages.currentPage().getParameters().get('node1');
        System.debug('sortableField 1st :::'+sortableField);
        System.debug('sortorder 1st :::'+sortorder);
        System.debug('previoussortfield  :::'+previoussortfield );
        //callGeneva();     
        if(previoussortfield == sortableField){
            sortorder='desc';
            previoussortfield=null;
        }
        else{
            sortorder='asc';            
            previoussortfield=sortableField;
        }
        System.debug('sortableField:::'+sortableField);
        System.debug('sortOrder::'+sortOrder);
        System.debug('previoussortfield later::'+previoussortfield);
            
        recordsList.sort();
        return null;
      }
      //method to sort the leads
      public Pagereference doSortLeads(){      
        //sortorder='asc'; 
        sortableFieldLead=ApexPages.currentPage().getParameters().get('node2');
        System.debug('sortableField 1st lead :::'+sortableFieldLead);
        System.debug('sortorder 1st lead :::'+sortorderLead);
        System.debug('previoussortfield lead  :::'+previoussortfieldLead );
        //callGeneva();     
        if(previoussortfieldLead == sortableFieldLead){
            sortorderLead='desc';
            previoussortfieldLead=null;
        }
        else{
            sortorderLead='asc';            
            previoussortfieldLead=sortableFieldLead;
        }
        System.debug('sortableField lead:::'+sortableFieldLead);
        System.debug('sortOrder lead::'+sortOrderLead);
        System.debug('previoussortfield later lead::'+previoussortfieldLead);
        leadWrapList.sort();
        return null;
      }
      
      //method to sort opportunities
      public Pagereference doSortOpps(){      
        //sortorder='asc'; 
        sortableFieldOpp=ApexPages.currentPage().getParameters().get('node3');
        System.debug('sortableField 1st lead :::'+sortableFieldOpp);
        System.debug('sortorder 1st lead :::'+sortorderOpp);
        System.debug('previoussortfield lead  :::'+previoussortfieldOpp );
        //callGeneva();     
        if(previoussortfieldOpp== sortableFieldOpp){
            sortorderOpp='desc';
            previoussortfieldOpp=null;
        }
        else{
            sortorderOpp='asc';            
            previoussortfieldOpp=sortableFieldOpp;
        }
        System.debug('sortableField lead:::'+sortableFieldOpp);
        System.debug('sortOrder lead::'+sortorderOpp);
        System.debug('previoussortfield later lead::'+previoussortfieldOpp);
        oppWrapList.sort();
        return null;
      }
   
   // wrapper for the referrals from Geneva to sort
   public class referralInputs  implements comparable{
          public String Companyname { get; set; }
          public String LeadOwner{ get; set; }
           public String ReferralDetail{ get; set; }
          public Decimal CorporatePayout{ get; set; }
          public Date PaymentSubmission{ get; set; }
          public Date BUCreatedDate{ get; set; }
          public Date BULastModifiedDate{ get; set; }
          public String LeadStatus{ get; set; }
          public Date OpportunityCloseDate{ get; set; }
          public String OpportunityOwner{ get; set; }
          public Decimal OpportunityValue{ get; set; }
          public String LeadReceivedBy{ get; set; }
          public String OpportunityStage{ get; set; }
          public String ReferrerEmail{ get; set; }
          public String ReferrerEmployeeId{ get; set; }
          //public String sortableField{ get; set; }
          //public String sortOrder{ get; set; }  
        
         public referralInputs(String LeadOwner,String Companyname,String ReferralDetail,decimal CorporatePayout,date PaymentSubmission ,date BUCreatedDate,
         date BULastModifiedDate,String LeadStatus,date OpportunityCloseDate,String OpportunityOwner,decimal OpportunityValue,
         String LeadReceivedBy,String OpportunityStage,String ReferrerEmail,String ReferrerEmployeeId ){
            this.LeadOwner = LeadOwner;
            this.Companyname = Companyname;
             this.ReferralDetail=ReferralDetail;
          this.CorporatePayout=CorporatePayout;
          this.PaymentSubmission=PaymentSubmission;
          this.BUCreatedDate=BUCreatedDate;
         this.BULastModifiedDate=BULastModifiedDate;
          this.LeadStatus=LeadStatus;
          this.OpportunityCloseDate=OpportunityCloseDate;
          this.OpportunityOwner=OpportunityOwner;
          this.OpportunityValue=OpportunityValue;
          this.LeadReceivedBy=LeadReceivedBy;
          this.OpportunityStage=OpportunityStage;
          this.ReferrerEmail=ReferrerEmail;
          this.ReferrerEmployeeId=ReferrerEmployeeId;
      
              //this.sortableField = sortableField;
              //this.sortOrder = sortOrder;
        }
        public Integer compareTo(Object compareTo) {
             referralInputs compWrap = (referralInputs)compareTo;
             if(sortOrder == 'asc'){
                if(sortableField == 'LeadOwner'){     
                        if (LeadOwner == compWrap.LeadOwner) return 0;
                      if (LeadOwner > compWrap.LeadOwner) return 1;
                      return -1;        
                }
                if(sortableField == 'Companyname'){     
                        if (Companyname == compWrap.Companyname) return 0;
                      if (Companyname > compWrap.Companyname) return 1;
                      return -1;        
                }
                if(sortableField == 'CorporatePayout'){
                       if (CorporatePayout == compWrap.CorporatePayout) return 0;
                      if (CorporatePayout > compWrap.CorporatePayout) return 1;
                      return -1;        
                }
                if(sortableField == 'PaymentSubmission'){
                       if (PaymentSubmission == compWrap.PaymentSubmission) return 0;
                      if (PaymentSubmission > compWrap.PaymentSubmission) return 1;
                      return -1;        
                }
                if(sortableField == 'BUCreatedDate'){
                       if (BUCreatedDate == compWrap.BUCreatedDate ) return 0;
                      if (BUCreatedDate > compWrap.BUCreatedDate) return 1;
                      return -1;        
                }
                if(sortableField == 'BULastModifiedDate'){
                       if (BULastModifiedDate== compWrap.BULastModifiedDate) return 0;
                      if (BULastModifiedDate > compWrap.BULastModifiedDate) return 1;
                      return -1;        
                }
                if(sortableField == 'LeadStatus'){
                       if (LeadStatus == compWrap.LeadStatus) return 0;
                      if (LeadStatus > compWrap.LeadStatus) return 1;
                      return -1;        
                }
                if(sortableField == 'OpportunityCloseDate'){
                       if (OpportunityCloseDate == compWrap.OpportunityCloseDate) return 0;
                      if (OpportunityCloseDate > compWrap.OpportunityCloseDate) return 1;
                      return -1;        
                }
                if(sortableField == 'OpportunityOwner'){
                       if (OpportunityOwner == compWrap.OpportunityOwner) return 0;
                      if (OpportunityOwner > compWrap.OpportunityOwner) return 1;
                      return -1;        
                }
                if(sortableField == 'OpportunityValue'){
                       if (OpportunityValue == compWrap.OpportunityValue) return 0;
                      if (OpportunityValue > compWrap.OpportunityValue) return 1;
                      return -1;        
                }
                if(sortableField == 'LeadReceivedBy'){
                       if (LeadReceivedBy == compWrap.LeadReceivedBy) return 0;
                      if (LeadReceivedBy > compWrap.LeadReceivedBy) return 1;
                      return -1;        
                }
                if(sortableField == 'OpportunityStage'){
                       if (OpportunityStage == compWrap.OpportunityStage) return 0;
                      if (OpportunityStage > compWrap.OpportunityStage) return 1;
                      return -1;        
                }
                if(sortableField == 'ReferrerEmail'){
                       if (ReferrerEmail == compWrap.ReferrerEmail) return 0;
                      if (ReferrerEmail > compWrap.ReferrerEmail) return 1;
                      return -1;        
                }
            }else{
                  if(sortableField == 'LeadOwner'){     
                        if (LeadOwner == compWrap.LeadOwner) return 0;
                      if (LeadOwner > compWrap.LeadOwner) return -1;
                      return 1;        
                }
                if(sortableField == 'Companyname'){     
                        if (Companyname == compWrap.Companyname) return 0;
                      if (Companyname > compWrap.Companyname) return -1;
                      return 1;        
                }
                if(sortableField == 'CorporatePayout'){
                       if (CorporatePayout == compWrap.CorporatePayout) return 0;
                      if (CorporatePayout > compWrap.CorporatePayout) return -1;
                      return 1;        
                }
                if(sortableField == 'PaymentSubmission'){
                       if (PaymentSubmission == compWrap.PaymentSubmission) return 0;
                      if (PaymentSubmission> compWrap.PaymentSubmission) return -1;
                      return 1;        
                }
                if(sortableField == 'BUCreatedDate'){     
                        if (BUCreatedDate== compWrap.BUCreatedDate) return 0;
                      if (BUCreatedDate> compWrap.BUCreatedDate) return -1;
                      return 1;        
                }
                if(sortableField == 'BULastModifiedDate'){
                       if (BULastModifiedDate== compWrap.BULastModifiedDate) return 0;
                      if (BULastModifiedDate > compWrap.BULastModifiedDate) return -1;
                      return 1;        
                }
                if(sortableField == 'LeadStatus'){
                       if (LeadStatus == compWrap.LeadStatus) return 0;
                      if (LeadStatus > compWrap.LeadStatus) return -1;
                      return 1;        
                }
                if(sortableField == 'OpportunityCloseDate'){
                       if (OpportunityCloseDate == compWrap.OpportunityCloseDate) return 0;
                      if (OpportunityCloseDate > compWrap.OpportunityCloseDate) return -1;
                      return 1;        
                }
                if(sortableField == 'OpportunityValue'){
                       if (OpportunityValue == compWrap.OpportunityValue) return 0;
                      if (OpportunityValue > compWrap.OpportunityValue) return -1;
                      return 1;        
                }
                if(sortableField == 'OpportunityOwner'){
                       if (OpportunityOwner == compWrap.OpportunityOwner) return 0;
                      if (OpportunityOwner > compWrap.OpportunityOwner) return -1;
                      return 1;        
                }
                if(sortableField == 'LeadReceivedBy'){
                       if (LeadReceivedBy == compWrap.LeadReceivedBy) return 0;
                      if (LeadReceivedBy > compWrap.LeadReceivedBy) return -1;
                      return 1;        
                }
                if(sortableField == 'OpportunityStage'){
                       if (OpportunityStage == compWrap.OpportunityStage) return 0;
                      if (OpportunityStage > compWrap.OpportunityStage) return -1;
                      return 1;        
                }
                if(sortableField == 'ReferrerEmail'){
                       if (ReferrerEmail == compWrap.ReferrerEmail) return 0;
                      if (ReferrerEmail > compWrap.ReferrerEmail) return -1;
                      return 1;        
                }
            }
            
            return null;
        }    
        
    }
    //Wrapper for the Lead records to sort
    public class LeadsWrapper  implements comparable{
          public String LeadOwner { get; set; }
          public String LeadId { get; set; }
          public String Leadname { get; set; }
          public String LeadOwnerId { get; set; }
          public String Companyname{ get; set; }
          public Date createdDate{ get; set; }
          public String company{ get; set; }
          public String status{ get; set; }
          public LeadsWrapper(){}
        
         public LeadsWrapper(String LeadOwner,String Leadname, String LeadId,String LeadOwnerId,String Companyname,Date createdDate,String status){
            this.LeadOwner = LeadOwner;
            this.LeadId = LeadId;
            this.LeadOwnerId = LeadOwnerId;
            this.Companyname = Companyname;
            this.createdDate=createdDate;
            this.status= status;
            this.Leadname=Leadname;
        }
        public Integer compareTo(Object compareTo) {
             LeadsWrapper leadWrap = (LeadsWrapper)compareTo;
             if(sortOrderLead == 'asc'){
                if(sortableFieldLead == 'LeadOwner'){     
                        if (LeadOwner == leadWrap.LeadOwner) return 0;
                      if (LeadOwner > leadWrap.LeadOwner) return 1;
                      return -1;        
                }
                if(sortableFieldLead == 'Companyname'){     
                        if (Companyname == leadWrap.Companyname) return 0;
                      if (Companyname > leadWrap.Companyname) return 1;
                      return -1;        
                }
                if(sortableFieldLead == 'createdDate'){
                       if (createdDate == leadWrap.createdDate) return 0;
                      if (createdDate > leadWrap.createdDate) return 1;
                      return -1;        
                }
                if(sortableFieldLead == 'status'){
                       if (status == leadWrap.status) return 0;
                      if (status > leadWrap.status) return 1;
                      return -1;        
                }
                if(sortableFieldLead == 'Leadname'){
                       if (Leadname== leadWrap.Leadname) return 0;
                      if (Leadname > leadWrap.Leadname) return 1;
                      return -1;        
                }
                
            }else{
                  if(sortableFieldLead == 'LeadOwner'){     
                        if (LeadOwner == leadWrap.LeadOwner) return 0;
                      if (LeadOwner > leadWrap.LeadOwner) return -1;
                      return 1;        
                }
                if(sortableFieldLead == 'Companyname'){     
                        if (Companyname == leadWrap.Companyname) return 0;
                      if (Companyname > leadWrap.Companyname) return -1;
                      return 1;        
                }
                if(sortableFieldLead == 'createdDate'){
                       if (createdDate == leadWrap.createdDate) return 0;
                      if (createdDate > leadWrap.createdDate) return -1;
                      return 1;        
                }
                if(sortableFieldLead == 'status'){
                       if (status == leadWrap.status) return 0;
                      if (status> leadWrap.status) return -1;
                      return 1;        
                }
                if(sortableFieldLead == 'Leadname'){
                       if (Leadname== leadWrap.Leadname) return 0;
                      if (Leadname > leadWrap.Leadname) return -1;
                      return 1;        
                }
                
            }
            
            return null;
        }    
        
    }
    //Wrapper for the opportunity records to sort
    public class OppWrapper  implements comparable{
          public String OppOwner { get; set; }
          public String OppId { get; set; }
          public String Oppname { get; set; }
          public String OppOwnerId { get; set; }
          public String Companyname{ get; set; }
          public Date createdDate{ get; set; }
          public Date closedDate{ get; set; }
          public String stage{ get; set; }
          public Decimal amount{ get; set; }
          public OppWrapper(){}
        
         public OppWrapper(String OppOwner,String Oppname, String OppId,String OppOwnerId,String Companyname,Date createdDate,Date closedDate ,String stage,Decimal Amount){
            this.OppOwner = OppOwner;
            this.OppId = OppId;
            this.OppOwnerId = OppId;
            this.Companyname = Companyname;
            this.createdDate=createdDate;
            this.closedDate=closedDate;
            this.amount=amount;
            this.stage= stage;
            this.Oppname=Oppname;
        }
        public Integer compareTo(Object compareTo) {
             OppWrapper oppWrap = (OppWrapper)compareTo;
             if(sortOrderOpp == 'asc'){
                if(sortableFieldOpp == 'OppOwner'){     
                        if (OppOwner == oppWrap.OppOwner) return 0;
                      if (OppOwner > oppWrap.OppOwner) return 1;
                      return -1;        
                }
                if(sortableFieldOpp == 'Companyname'){     
                        if (Companyname == oppWrap.Companyname) return 0;
                      if (Companyname > oppWrap.Companyname) return 1;
                      return -1;        
                }
                if(sortableFieldOpp == 'createdDate'){
                       if (createdDate == oppWrap.createdDate) return 0;
                      if (createdDate > oppWrap.createdDate) return 1;
                      return -1;        
                }
                if(sortableFieldOpp == 'stage'){
                       if (stage == oppWrap.stage) return 0;
                      if (stage > oppWrap.stage) return 1;
                      return -1;        
                }
                if(sortableFieldOpp == 'Oppname'){
                       if (Oppname== oppWrap.Oppname) return 0;
                      if (Oppname > oppWrap.Oppname) return 1;
                      return -1;        
                }
                if(sortableFieldOpp == 'Amount'){
                       if (amount== oppWrap.amount) return 0;
                      if (amount > oppWrap.amount) return 1;
                      return -1;        
                }
                if(sortableFieldOpp == 'ClosedDate'){
                       if (ClosedDate== oppWrap.ClosedDate) return 0;
                      if (ClosedDate > oppWrap.ClosedDate) return 1;
                      return -1;        
                }
                
            }else{
                  if(sortableFieldOpp == 'OppOwner'){     
                        if (OppOwner == oppWrap.OppOwner) return 0;
                      if (OppOwner > oppWrap.OppOwner) return -1;
                      return 1;        
                }
                if(sortableFieldOpp == 'Companyname'){     
                        if (Companyname == oppWrap.Companyname) return 0;
                      if (Companyname > oppWrap.Companyname) return -1;
                      return 1;        
                }
                if(sortableFieldOpp == 'createdDate'){
                       if (createdDate == oppWrap.createdDate) return 0;
                      if (createdDate > oppWrap.createdDate) return -1;
                      return 1;        
                }
                if(sortableFieldOpp == 'stage'){
                       if (stage == oppWrap.stage) return 0;
                      if (stage > oppWrap.stage) return -1;
                      return 1;        
                }
                if(sortableFieldOpp == 'Oppname'){
                       if (Oppname== oppWrap.Oppname) return 0;
                      if (Oppname > oppWrap.Oppname) return -1;
                      return 1;        
                }
                if(sortableFieldOpp == 'Amount'){
                       if (amount== oppWrap.amount) return 0;
                      if (amount > oppWrap.amount) return -1;
                      return 1;        
                }
                if(sortableFieldOpp == 'ClosedDate'){
                       if (ClosedDate== oppWrap.ClosedDate) return 0;
                      if (ClosedDate > oppWrap.ClosedDate) return -1;
                      return 1;        
                }
                
            }
            
            return null;
        }    
        
    }
}