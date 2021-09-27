/********************************************************************************
Class Name : CaseResourceLatam
Description : This is a REST Resource. This class add the comment details to the
                case and also sends the case details based on parameters sent
Parameters : Case Number
*********************************************************************************
Modification Details:
Date                    Description                     Owner
16/05/2019              Created                         Herin Acharya
*********************************************************************************/
@RestResource(urlMapping='/createCaseLatam/*')
global with sharing class CaseResourceLatam {   
   

    /********************************************************************************
    Method Name : addComment - Post Method
    Description : This method adds the case commnet details in SFDC against the case
                    into the objects- feedItem, feedAttachment, contentVersion
    Parameters : Case Number
    Return Type:  None
    *********************************************************************************/

    @HttpPost
    global static String addComment(){

        //Initialize variables
        string json;
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String caseNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        currentCaseect container = (currentCaseect)System.JSON.deserialize
                          (RestContext.request.requestBody.tostring(),currentCaseect.class);        

        caseDetails obtainedCaseDetails = new caseDetails();
        obtainedCaseDetails = container.cases;

        list<Case> lstCurrentCase = new list<case>([SELECT id,Description, ContactId , Subject, casenumber,LCRM_Organization__c,
                                                    Sales_Org__c, ESC_Origin_Name__c, Origin,MYTR_Category__c   ,MYTR_Query_Type__c,LCRM_Sub_BU__c,
                                                    LCRM_Account_SSD__r.Account_Name__c 
                                                    FROM Case WHERE CaseNumber =: caseNumber LIMIT 1]);

        system.debug('lst_case----'+lstCurrentCase);
        Case currentCase;
        
        //Add comment only if the case details are available in the org
        if(lstCurrentCase !=NULL && !lstCurrentCase.isEmpty()){
            currentCase = new Case();
            currentCase = lstCurrentCase[0];
            
            list<contact> currentContact = new list<contact>([select id,name 
                        from contact where id =:obtainedCaseDetails.ContactId limit 1]);
            
            //Create the data based on if the contact is available
            if(currentContact != NULL && !currentContact.isEmpty()){
                
                //Initialize variablesfor feedItem, feedAttachment and contentVersion creation
                FeedItem ObjFeedItem;
                list<ContentVersion> ContentVersionToInsert = new list<ContentVersion>();
                List<feedAttachment> ListFeedAttachments = new List<feedAttachment>();
                List<FeedItem> ListFeedItem = new List<FeedItem>();
                
                //If attachments are available, create contentVersion record for each attachment
                if(container.attachments != null && container.attachments.size() > 0){
                    for (Attach att :container.attachments){
                        ContentVersion cv = new ContentVersion();
                        String CvaName = String.valueOf(att.name).substringBeforeLast('.');
                        cv.Title = CvaName;
                        cv.PathOnClient =att.name;
                        cv.VersionData = EncodingUtil.base64Decode(att.body);
                        ContentVersionToInsert.add(cv);
                    }
                    insert ContentVersionToInsert;
                }
                system.debug('ContentVersionToInsert--'+ContentVersionToInsert);
                //Create the feedItem record for the comment
                ObjFeedItem = new FeedItem();
                ObjFeedItem.ParentId = currentCase.id; //eg. case id, custom object id..
                
                //Populate the fields of Feed Item record
                ObjFeedItem.Status ='Published';
                ObjFeedItem.Visibility = 'AllUsers';
                if(!String.isBlank(obtainedCaseDetails.CaseComments)){
                    ObjFeedItem.Body = obtainedCaseDetails.CaseComments; 
                }
                //Populate type as content post if attachements are available for that post
                if(container.attachments!= null && container.attachments.size()>0){
                    ObjFeedItem.Type = 'ContentPost';
                    ObjFeedItem.RelatedRecordId = ContentVersionToInsert[0].id;
                }
                else{
                    ObjFeedItem.Type = 'TextPost';
                }   
                          
                insert ObjFeedItem;
                
                //FeedAtchment record is created for only one contentVersion record that is populated on FeedItem,
                //for the rest create feedattachment records
                
                if(container.attachments!= null && container.attachments.size()>1){
                    system.debug('ContentVersionToInsert--'+ContentVersionToInsert);
                    for(ContentVersion objCv : ContentVersionToInsert){
                        if(ObjFeedItem.RelatedRecordId != objCv.id){
                            feedAttachment feedAttachment = new FeedAttachment();
                            feedAttachment.FeedEntityId = ObjFeedItem.Id;
                            feedAttachment.RecordId = objCv.id; 
                            feedAttachment.Type = 'CONTENT'; 
                            ListFeedAttachments.add(feedAttachment);
                        }
                    }  
                    insert ListFeedAttachments;
                }
                
                //Insert data into the junction object
                Feed_Item_Contact__c juncDetails = new Feed_Item_Contact__c();
                juncDetails.Case__c = currentCase.id;
                juncDetails.Feed_Item_ID__c = ObjFeedItem.id;
                juncDetails.Contact__c = obtainedCaseDetails.ContactId;
                
                insert juncDetails;

                json = 'case updated successfully';
                return json;

            }else{
                return json = 'Failed:Contact not found with Id:' + obtainedCaseDetails.ContactId;    
            }
        }else{
            return json = 'Failed:Case not found';
        }// End of check for case details
    } //endof addCOmments method
    
/********************************************************************************
Method Name : doGet - Get Method
Description : This method adds the case commnet details in SFDC against the case
                into the objects- feedItem, feedAttachment, contentVersion
Parameters : Category, AccountNumber,Email Id
Return Type : List of Cases

Last Modified : Herin Acharya || Date : 30/07/2019 || JIRA : MTR-10292
Change Description : Using SSD Account(Source_System_Detail__c) instead of standard Account in filter criteria
                     Sending 
                     
Change Description : MTR-11072-  Filter cases based on contact ID instead of email ID
*********************************************************************************/
//Get Case Detail All Tickect   
@HttpGet
global static List<CaseWrapper> doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String category = req.params.get('category');
    String account =req.params.get('accountNo');
    String contactId = req.params.get('contactId'); 

    system.debug('category---'+category);
    system.debug('account ---'+account ) ;
    system.debug('contactId---'+contactId ) ;
    List<Case> caseList = new List <Case>();
    List<CaseWrapper> ResponseCaseWrappper = new List<CaseWrapper>();

    /* JIRA : MTR-10292 changes 
    BU region filter added - LCRM_Sub_BU__c in ('LatAm', 'GGO')
    Standard Account filter changed to SSD Account (for eg Account.SAPAccountNumber__C to LCRM_Account_SSD__r.Source_System_Account_Number__c)
    */ 
    try{           
    if(String.isNotBlank(category) && String.isNotBlank(account) && String.isNotBlank(contactId)){  
        system.debug('InIFFF');  
        caseList = [SELECT  Id,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,Subject,ESC_Customer_Symptom__c,
        Product__c,contact.name,ESC_Diagnosis_Summary__c,Account.Name,contact.phone,Description,Owner.Name,
        Account.SAPAccountNumber__C,ESC_Resolution_Comment__c,ESC_Cause__c,ESC_Resolution_Code__c,
        ClosedDate, Status,Source.name,MYTR_Query_Type__c,MYTR_Category__c,ContactEmail,ContactId,ContactPhone,ContactMobile,AccountId,
        Reason__c,Priority,ESC_Impact__c,Follow_Up_Date__c,Due_DateTime__c,LCRM_Account_SSD__c FROM CASE 
        Where (ContactId =:contactId OR Account.SAPAccountNumber__c=: account) 
        AND MYTR_Category__c =:category AND LCRM_Sub_BU__c in ('LatAm', 'GGO') AND Closed_Case__c = false 
        ORDER BY LastModifiedDate Desc NULLS Last];

    }else
    if(String.isNotBlank (category) && String.isNotBlank(account)){    
        system.debug('InElseIF1');
        caseList = [SELECT  Id,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,Subject,ESC_Customer_Symptom__c,
        Product__c,contact.name,ESC_Diagnosis_Summary__c,contact.phone,Description,Owner.Name,AccountId,
        Account.SAPAccountNumber__C,Account.Name,ESC_Resolution_Comment__c,ESC_Cause__c,ESC_Resolution_Code__c,
        ClosedDate, Status,Source.name,MYTR_Query_Type__c,MYTR_Category__c ,ContactEmail,ContactId,ContactPhone,ContactMobile,
        Reason__c,Priority,ESC_Impact__c,Follow_Up_Date__c,Due_DateTime__c 
        FROM CASE Where (Account.SAPAccountNumber__c =: account) 
        AND MYTR_Category__c=:category AND LCRM_Sub_BU__c in ('LatAm', 'GGO') AND Closed_Case__c = false 
         ORDER BY LastModifiedDate Desc NULLS Last];
    }else
    if(String.isNotBlank(category) && String.isNotBlank(contactId)){
        system.debug('InElseIF2');    
        caseList = [SELECT  Id,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,Subject,
        ESC_Customer_Symptom__c,ContactId,ContactPhone,ContactMobile,AccountId,
        Product__c,contact.name,ESC_Diagnosis_Summary__c,Account.Name,contact.phone,Description,Owner.Name,
        Account.SAPAccountNumber__C,ESC_Resolution_Comment__c,ESC_Cause__c,ESC_Resolution_Code__c,
        ClosedDate,Status,Source.name,MYTR_Query_Type__c,MYTR_Category__c,ContactEmail,Reason__c,Priority,ESC_Impact__c,
        Follow_Up_Date__c,Due_DateTime__c,LCRM_Account_SSD__c
        FROM CASE Where (ContactId =:contactId ) AND MYTR_Category__c =:category AND LCRM_Sub_BU__c in ('LatAm', 'GGO') AND Closed_Case__c = false 
        ORDER BY LastModifiedDate Desc NULLS Last];
    }

    }catch(Exception ex)
    {
        System.debug('Exception'+ex.getMessage());
    }
    ResponseCaseWrappper = CaseWrapperHelper.createCaseWrapper(caseList);
    return ResponseCaseWrappper;
}
    //Inner class to hold the attachment details of the case
   public class Attach {
        public String Body;
        public String ContentType;
        public String Name;
        public string Description;
    }
    
    //Inner class to hold the case details
    public class caseDetails{
        public String subject;
        public String accountName;
        public String accountNumber;
        public String fullName;
        public String companyName;
        public String emailAddress;
        public String contactPhone;
        public String description;
        public string categoryType;
        public String queryType;
        public String businessUnit;
        public String attachmentComment;
        public String additionalComment;
        public string CaseComments;
        public String UserNameForComments;
        public String EmailIdOfUser;
        public String ContactId;

    }
   public class currentCaseect{ 
        public caseDetails cases;   
        public list<Attach> attachments; 
    }
}