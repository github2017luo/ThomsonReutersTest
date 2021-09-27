public without sharing class CustomerCommunityContactsLWCController{
    @AuraEnabled(cacheable=true)
    public static List<DataTableWrapper1> getContact(){  
            User u = getuser();
            Contact con = getcon(u);
             System.debug(logginglevel.warn,'con---> '+con);
            List<DataTableWrapper1> dwList3 = new List<DataTableWrapper1>();
            DataTableWrapper1 dwObj3 = new DataTableWrapper1();
            dwObj3.name = con.name;
            dwObj3.contactUrlLink = '/EntCustCommunity/s/detail/'+con.id;
            dwObj3.accountName = con.account.name;
            dwObj3.title = con.title;
            dwObj3.email = con.email;
            dwObj3.eliteContactNumber = con.ESC_Contact_Number__c;
            dwObj3.mobile = con.mobilePhone;
            dwObj3.directPhone = con.phone;
            dwObj3.extension = con.Extension__c;
            dwObj3.conInactive= con.ESC_Contact_Status__c;
            dwList3.add(dwObj3);            
        return dwList3;
    }
    @AuraEnabled(cacheable=false)
    public static List<DataTableWrapper1> getAllContactList(Integer limitSize, Integer offset,string searchKey){  
        User u = new User();
        Contact con= new Contact();
        string domainName ='';
        List<Contact> contactList = new List<Contact>();
         List<Contact> finalcontactList = new List<Contact>();
        List<CustomerCommunityContactsLWCController.DataTableWrapper1> dwList1 = new List<CustomerCommunityContactsLWCController.DataTableWrapper1>();
        
            u = getuser();
            con = getcon(u);
            domainName = u.email.substringAfter('@');
            System.debug(logginglevel.warn,'domainname---> '+domainName);
            System.debug(logginglevel.warn,'con---> '+con);
            contactList = getconlist(con,domainName,searchKey);
            finalcontactList = getfinalconlist(contactList,limitSize,offset);
       
        System.debug(logginglevel.warn,'contactlist---> '+contactList);
        for(Contact cont:finalcontactList){
            DataTableWrapper1 dwObj1 = new DataTableWrapper1();
            dwObj1.name = cont.name;
            dwObj1.contactUrlLink = '/EntCustCommunity/s/detail/'+cont.id;
            dwObj1.accountName = cont.account.name;
            dwObj1.title = cont.title;
            dwObj1.email = cont.email;
            dwObj1.eliteContactNumber = cont.ESC_Contact_Number__c;
            dwObj1.mobile = cont.mobilePhone;
            dwObj1.directPhone = cont.phone;
            dwObj1.extension = cont.Extension__c;
            dwObj1.conInactive= cont.ESC_Contact_Status__c;
            dwList1.add(dwObj1);
        }            
        return dwList1;
    }
    
    
    @AuraEnabled(cacheable=false)
    public static List<DataTableWrapper2> getAllCaselist(Integer limitSize, Integer offset,string searchKey){  
        User u = new User();
        Contact con= new Contact();
        string domainName ='';
        List<Contact> contactList = new List<Contact>();
        List<CustomerCommunityContactsLWCController.DataTableWrapper1> dwList1 = new List<CustomerCommunityContactsLWCController.DataTableWrapper1>();
        List<Case> caseList = new List<Case>();
        List<CustomerCommunityContactsLWCController.DataTableWrapper2> dwList2 = new List<CustomerCommunityContactsLWCController.DataTableWrapper2>();
        //string searchKey = '';
            u = getuser();
            con = getcon(u);
            domainName = u.contact.email.substringAfter('@');
            System.debug(logginglevel.warn,'domainname---> '+domainName);
            System.debug(logginglevel.warn,'con---> '+con);
            contactList = getconlist(con,domainName,'');
            caseList = getcaselist(contactList,limitSize,offset,searchKey);      
      for(Case c : caseList){
            DataTableWrapper2 dwObj2 = new DataTableWrapper2();
            dwObj2.caseNumber = c.casenumber;
            dwObj2.caseUrlLink = '/EntCustCommunity/s/case/'+c.id+'/'+c.Subject;
            dwObj2.contactName = c.contact.name;
            dwObj2.stage = c.ESC_Stage__c;
            dwObj2.productTitle = c.ESC_Product_Title__c;
            dwObj2.productFeature = c.ESC_Product_Feature_Module__c;
            dwObj2.subject = c.Subject;
            dwObj2.status = c.Status;
            dwObj2.severity = c.ESC_Severity__c;
            dwObj2.dateOpened = c.CreatedDate;
            /*if(((String) c.OwnerId).startsWith('005')){
            dwObj2.caseOwner = c.Owner.firstname+c.owner.lastname;
            }
            else{
            dwObj2.caseOwner = c.Owner.name;
            }*/
            dwObj2.caseOwner = c.ESC_Owner_first_name__c;
            dwList2.add(dwObj2);
        }           
        return dwList2;
    }
    private static user getuser(){
        User u = new User();
        List<Contact> contactList = new List<Contact>();
         if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
            u = [SELECT contactid,contact.email,email from User where id=:UserInfo.getUserId()];
        }
        return u;
    }
    private static contact getcon(user u){
    contact con = new contact();
         if(Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable()){
             con= [Select id,name,account.name,AccountId,WLEC_EMail_Domain__c,ESC_Contact_Status__c,title,ESC_Elite_Domain__c,Contact_Inactive__c,email,ESC_Contact_Number__c,mobilePhone,Extension__c,phone,ESC_Portal_User_Profile__c from Contact 
             where id=:u.contactid];
             }
        return con;
    }
    private static List<Contact> getfinalconlist(List<contact> finalcontactlist,Integer limitSize, Integer offset){       
        
         if(offset >=2000){
             offset = 1999;
         }
         
         List<contact> conlist1 = new List<contact>();
         if((Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable()) && UserInfo.getprofileID() ==Label.ESC_TR_Customer_Super_User){
            conlist1 = [SELECT id,name,account.name,WLEC_EMail_Domain__c,title,email,ESC_Elite_Domain__c,ESC_Contact_Status__c,Contact_Inactive__c,ESC_Contact_Number__c,mobilePhone,Extension__c,phone,ESC_Portal_User_Profile__c from Contact 
                           WHERE id in:finalcontactlist ORDER BY Contact_Inactive__c LIMIT :limitSize OFFSET :offset];
              }
         return conlist1 ;
    }
    private static List<Contact> getconlist(contact con,string domainName,string searchKey){
        List<Contact> contactList =new List<Contact>();
        List<Contact> finalcontactlist =new List<Contact>();    
       // string contactDomain ='';
        List<string> conDomain = new List<String>();
        string searchStr = '%'+searchKey+'%'; 
         /*if(con.WLEC_EMail_Domain__c != null && con.WLEC_EMail_Domain__c !=''){
                 contactDomain = con.WLEC_EMail_Domain__c;
                 system.debug(logginglevel.warn,'Contact Domain--->'+contactDomain); 
             }*/
         if(con.ESC_Elite_Domain__c!= null && con.ESC_Elite_Domain__c!=''){
                  conDomain = con.ESC_Elite_Domain__c.split(',');
                  system.debug(logginglevel.warn,'Elite Domain--->'+conDomain ); 
             }
            // System.debug(logginglevel.warn,'contactDomain---> '+contactDomain);
   
        if((Schema.sObjectType.Contact.isAccessible() || Schema.sObjectType.Contact.isQueryable()) && UserInfo.getprofileID() ==Label.ESC_TR_Customer_Super_User && searchKey != null && searchKey != ''){
         contactList = [SELECT id,name,account.name,WLEC_EMail_Domain__c,title,email,ESC_Elite_Domain__c,Contact_Inactive__c,ESC_Contact_Number__c,mobilePhone,Extension__c,phone,ESC_Portal_User_Profile__c from Contact
                        WHERE accountid=:con.AccountId and ESC_BU_Originated_By__c ='Elite' and (name like :searchStr or email like :searchStr or ESC_Contact_Number__c like :searchStr or title like :searchStr)];
        }else{
         contactList = [SELECT id,name,account.name,WLEC_EMail_Domain__c,title,email,ESC_Contact_Status__c,ESC_Elite_Domain__c,Contact_Inactive__c,ESC_Contact_Number__c,mobilePhone,Extension__c,phone,ESC_Portal_User_Profile__c from Contact 
                           WHERE accountid=:con.AccountId and ESC_BU_Originated_By__c ='Elite'];
              }                           
         System.debug(logginglevel.warn,contactlist);
         for(contact c1 : contactList){
         if(c1.email != null && c1.email != ''){
           string em = c1.email.substringAfter('@');
          System.debug(logginglevel.warn,'email-->'+em);
         //if(c1.email.containsignorecase(domainName)){
         if(em.equalsignorecase(domainName)){
             finalcontactlist.add(c1);
             System.debug(logginglevel.warn,'finalcontactlist-->'+finalcontactlist);
         }
         /*if(contactDomain != null && contactDomain!='' && c1.email.containsignorecase(contactDomain) && domainName != contactDomain){
            finalcontactlist.add(c1);
            System.debug(logginglevel.warn,'finalcontactlist-->'+finalcontactlist);
         }*/
         //else{

         for(string s :conDomain){
          System.debug(logginglevel.warn,'entered else-->'+s);
             if(s!=domainName && em.equalsignorecase(s)){
                 finalcontactlist.add(c1);
                 System.debug(logginglevel.warn,'elsefinalcontactlist-->'+finalcontactlist);
                  break;
             }
            }
          //}
         }
         }
         return finalcontactlist ;
    }
    private static List<Case> getcaselist(List<contact> contactList,Integer limitSize, Integer offset,string searchKey){
        if(offset >=2000){
             offset = 1999;
         }
        List<Case> caselist = new List<Case>();
         string searchStr = '%'+searchKey+'%'; 
        if(contactList.size()>0 && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()) && searchKey != null && searchKey != ''){
            caselist = [select id,casenumber,contact.name,ESC_Owner_first_name__c,ESC_Cust_Com_Type__c,ESC_Stage__c,ESC_Cust_Com_Sub_Type__c,ESC_Product_Title__c,ESC_Product_Feature_Module__c,Subject,Status,ESC_Severity__c,CreatedDate,ownerid,owner.name,Owner.firstname,owner.lastname,ESC_Product_Segment_Brand__c from Case
            where contactid in: contactList and Is_GLI__c =true and Is_ESC_Case__c = true and ESC_Proactive_Type__c != 'Internal Origin' and ESC_Product_Segment_Brand__c='Elite' and (casenumber like :searchStr or subject like :searchStr or contact.name like :searchStr or ESC_Product_Title__c like :searchStr or ESC_Product_Feature_Module__c like :searchStr or ESC_Owner_first_name__c like :searchStr) ORDER BY CreatedDate DESC LIMIT :limitSize OFFSET :offset];
         }else{
            caselist = [select id,casenumber,contact.name,ESC_Owner_first_name__c,ESC_Cust_Com_Type__c,ESC_Stage__c,ESC_Cust_Com_Sub_Type__c,ESC_Product_Title__c,ESC_Product_Feature_Module__c,Subject,Status,ESC_Severity__c,CreatedDate,ownerid,owner.name,Owner.firstname,owner.lastname,ESC_Product_Segment_Brand__c from Case
            where contactid in: contactList and Is_GLI__c =true and Is_ESC_Case__c = true and ESC_Proactive_Type__c != 'Internal Origin' and ESC_Product_Segment_Brand__c='Elite' ORDER BY CreatedDate DESC LIMIT :limitSize OFFSET :offset];        
         }
          return caselist;
    }
    @Testvisible private class DataTableWrapper1 {
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string contactUrlLink{get;set;}
        @AuraEnabled public string accountName{get;set;} 
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public string email{get;set;}
        @AuraEnabled public string eliteContactNumber{get;set;}
        @AuraEnabled public string mobile{get;set;}
        @AuraEnabled public string directPhone{get;set;}
        @AuraEnabled public string extension{get;set;}
        @AuraEnabled public string conInactive{get;set;}
    }    
    @Testvisible private class DataTableWrapper2 {
        @AuraEnabled public String caseNumber{get;set;}
        @AuraEnabled public String caseUrlLink{get;set;}
        @AuraEnabled public String contactName {get;set;}
        @AuraEnabled public String stage{get;set;}
        @AuraEnabled public String productTitle {get;set;}
        @AuraEnabled public String productFeature {get;set;}
        @AuraEnabled public String subject {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String severity {get;set;}
        @AuraEnabled public DateTime dateOpened {get;set;}
        @AuraEnabled public String caseOwner {get;set;}
    }

 }