@RestResource(urlMapping='/caseManagement/*')
global without sharing class CaseManagementService{ 

  /*Commnets By :- Herin Acharya  
  Inner class to deserialize Json for Attchment from ESI
  ESI is sending attachment data(Body ,name, discription etc) as below parameters.
  */
  public class Attach {
    public String Body;
    public String ContentType;
    public String Name;
    public string Description;
  }
  
  /*Commnets By :- Herin Acharya  
  Inner class to deserialize Json for Case from ESI
  ESI is sending Case data(Description ,EmailAddress, ContactId etc) as below parameters.
  */  

  public  class CaseNew{
    public string LCRMAccountSSD;
    public string ContactId;
    public string Subject;
    public String AccountName;
    public String AccountNumber;
    public String FullName;
    public String CompanyName;
    public String EmailAddress;
    public String ContactPhone;
    public String Description;
    public string CategoryType;
    public String QueryType;
    public String BusinessUnit;
    public string Product;
    public string CaseComments;
    public String UserNameForComments;
    public String EmailIdOfUser;
    public String IsoCountrycode;
    public String ProdusctsList;
    public String ProductAdditionalInfo;
    public String OnlineUserFirstName;
    public String OnlineUserLastName;
    public String OnlineUserEmail;
    public String OnlineUserNamesToDelete;
    public String RemovingAccessToProducts;
  }
  
/*Commnets By :- Herin Acharya  
Inner class to deserialize Json for Cases and Attachment from ESI
*/

 public class CaseObject{ 
    public CaseNew cases;   
    public list<Attach> Attachments; 
  }

/**************
Commnets By :- Herin Acharya
Description   :  Post call to create cases and attachment.
We are expecting parameters in JSON format from ESI and we are using Inner classes(CaseNew,CaseObject,Attach) 
to deserialize JSON.
Return Type:  String(Case Number)
***************/

@HttpPost
global static String doPost(){
  
  String Json;
  CaseObject Container = (CaseObject)System.JSON.deserialize
                        (RestContext.request.requestBody.tostring(),CaseObject.class);        
  CaseNew AemCase = new CaseNew();
  AemCase = Container.cases;
    
  if(AemCase != null ){
    
    list<Contact> ListContact = new list<Contact>([select id,AccountId,Account.Sales_Org__c from Contact 
                                  where Id =: AemCase.ContactId]);
    
    if(ListContact != null && ListContact.size() == 0){
      return json = 'Failed:Case not created ,Contact not found with Id :' + AemCase.ContactId;
    }

    Case ObjCase = new Case();   
    ObjCase.Origin= 'My TR';      
    ObjCase.ContactId = ListContact[0].id; 
    ObjCase.AccountId  = ListContact[0].AccountId; // Standard GLI Account - After GLI migration

    /**** MTR-MTR-10515 changes 
    Description : Need to set values of ESC_Unique_Identifier__c and ESC_Geographic_Impact__c for businesshour framework
    ***/

    ObjCase.ESC_Geographic_Impact__c = 'Country';
    ObjCase.ESC_Unique_Identifier__c = 'MTRWEB'; 

    if(!String.isBlank(AemCase.Subject)){ 
     ObjCase.Subject = AemCase.Subject; 
     assignRecordType(ObjCase,AemCase.Subject);
    }
    if(!String.isBlank(AemCase.Description)){ 
      ObjCase.Description = AemCase.Description;
    }
    if(!String.isBlank(AemCase.CompanyName)){ 
      ObjCase.LCRM_Organization__c = AemCase.CompanyName;
    }
    if(!String.isBlank(AemCase.CategoryType)){
      ObjCase.MYTR_Category__c  = AemCase.CategoryType;
    }
    if(!String.isBlank(AemCase.QueryType)){
      ObjCase.MYTR_Query_Type__c = AemCase.QueryType;
    }
    //Build static map to hold the region and their country codes - needs to be designed based on future requirements
    Map<String,String> codeTORegion = new Map<String,String>{'BR-pt' => 'Brazil', 'BR-en' => 'Brazil','AR-es' => 'Argentina', 'AR-en' => 'Argentina'};
    if(!String.isBlank(AemCase.BusinessUnit)){
      AssignBuAndSalesOrg(ObjCase,AemCase.BusinessUnit,ListContact[0]);
      if(!String.isBlank(AemCase.Product)){
        //Retrieve the equivalent product name from metadata
        List<MTR_AEM_SFDC_Product_Mapping__mdt> productMapping = [SELECT Region__c, AEM_Product_Name__c, 
                            SFDC_Product_Name__c FROM MTR_AEM_SFDC_Product_Mapping__mdt 
                              WHERE AEM_Product_Name__c =: AemCase.Product.trim() AND Region__c =: codeTORegion.get(AemCase.IsoCountrycode)];
        ObjCase.Product__c = productMapping[0].SFDC_Product_Name__c;
      }
    }

    if(!String.isBlank(AemCase.IsoCountrycode)){
    ObjCase.ESC_Origin_Name__c = Label.URL_to_MY_TR_Form +'//'+ AemCase.IsoCountrycode + '//getsupport';
    /**** MTR-MTR-10515 changes 
    Description : Need to set values of ESC_Country__c for businesshour framework ***/
    
    ObjCase.ESC_Country__c = codeTORegion.get(AemCase.IsoCountrycode); 
    }
    /***MTR-10702***
    if(!String.isBlank(AemCase.ProductAdditionalInfo)){
    ObjCase.Additional_Product_Information__c = AemCase.ProductAdditionalInfo; 
    }
    if(!String.isBlank(AemCase.OnlineUserNamesToDelete)){
    ObjCase.Online_User_Name_s_to_Delete__c = AemCase.OnlineUserNamesToDelete;
    }
    if(!String.isBlank(AemCase.RemovingAccessToProducts)){
    ObjCase.Are_you_removing_access_to_all_products__c = AemCase.RemovingAccessToProducts;
    } 
    */

    insert ObjCase ;

    system.debug('ObjCase-----'+ObjCase);

    case ObjReturnCaseNumber = [select casenumber from case where id=:ObjCase.id];
    system.debug('ReturnCaseNumber---'+ObjReturnCaseNumber);
    json = '{case: {CaseNumber: '+ ObjReturnCaseNumber.CaseNumber + '}';
    return json;

  }else{
    return json;
  }

}   

/*
Comments By:Herin Acharya
Assign recordType based on subject(Query type) using custom meta data type
MyTr_Case_Record_Type_Setting__mdt meta data type is created to store query type data against Case record type,
case sub type,diagnonis etc
*/

public static Case assignRecordType(Case ObjCase,String Subject){

  List<MyTr_Case_Record_Type_Setting__mdt> MapCaseRecordType = new List<MyTr_Case_Record_Type_Setting__mdt>();
  MapCaseRecordType = [Select id,MasterLabel,DeveloperName,Case_Record_Sub_Type__c,Case_Record_Type__c,Case_Type__c,
                      Record_Type_Developer_Name__c,English__c,Portuguese__c,Spanish__c,Diagnosis__c,Symptom__c from 
                      MyTr_Case_Record_Type_Setting__mdt];

  Map<String,MyTr_Case_Record_Type_Setting__mdt> mapSubjectCustSetting = new map<string,MyTr_Case_Record_Type_Setting__mdt>();
  
  for(MyTr_Case_Record_Type_Setting__mdt ObjMapCaseRecordType : MapCaseRecordType){
    mapSubjectCustSetting.put(ObjMapCaseRecordType.English__c , ObjMapCaseRecordType);
    mapSubjectCustSetting.put(ObjMapCaseRecordType.Portuguese__c , ObjMapCaseRecordType);
    mapSubjectCustSetting.put(ObjMapCaseRecordType.Spanish__c , ObjMapCaseRecordType);
  }


  MyTr_Case_Record_Type_Setting__mdt ObjCMetaType = new MyTr_Case_Record_Type_Setting__mdt();
  ObjCMetaType = mapSubjectCustSetting.get(Subject);

  if(ObjCMetaType != null && !String.isBlank(ObjCMetaType.Case_Record_Type__c) 
    && !String.isBlank(ObjCMetaType.Record_Type_Developer_Name__c)){

      Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(ObjCMetaType.Record_Type_Developer_Name__c).getRecordTypeId();
      system.debug('devRecordTypeId---'+devRecordTypeId);
      if(devRecordTypeId != null){

        ObjCase.RecordTypeId = devRecordTypeId;
        ObjCase.ESC_Case_Type__c = ObjCMetaType.Case_Record_Type__c;

        if(!String.isBlank(ObjCMetaType.Case_Record_Sub_Type__c)){
          ObjCase.ESC_Case_Sub_Type__c = ObjCMetaType.Case_Record_Sub_Type__c;
        }
        if(!String.isBlank(ObjCMetaType.Case_Type__c)){
          ObjCase.ESC_EnquiryType__c = ObjCMetaType.Case_Type__c;
        }
        if(!String.isBlank(ObjCMetaType.Symptom__c)){
          ObjCase.ESC_Customer_Symptom__c = ObjCMetaType.Symptom__c;
        }
        /******As a part of MTR-10208****
        if(!String.isBlank(ObjCMetaType.Diagnosis__c)){
          ObjCase.ESC_Diagnosis_Summary__c = ObjCMetaType.Diagnosis__c;
        }
        */
      }
    }

    return ObjCase;
}

/*
 Comments By:Herin Acharya
 Assign Sales org based on BU
 Need to use Custom label instead of static string
*/

public static case AssignBuAndSalesOrg(Case ObjCase, String BusinessUnit , Contact ObjCon){
  
  if (BusinessUnit == 'LatAm' || BusinessUnit == 'UKI' || BusinessUnit == 'USL'){
      ObjCase.Sales_Org__c =  ObjCon.Account.Sales_Org__c; //before GLI migration
      ObjCase.LCRM_Sub_BU__c = 'GGO';
      ObjCase.Is_GLI__c = False;
  }
  return ObjCase;

}


//My Tickets 
/* Comments By: Herin Acharya
  Get service for cases. Case is filtered based on Case no and Contactid
  MTR-11072 : Filter cases based on contact ID instead of email ID
*/    

  @HttpGet
  global static List<CaseWrapper> doGet(){
    //String JSON1;
    List<CaseWrapper> ResponseCaseWrappper = new List<CaseWrapper>();
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;

    String contactId = req.params.get('contactId');
    String caseNo = req.params.get('caseNo');
    List<Case> ListCases;
    boolean test=false;
    
     /* JIRA : MTR-10292 changes 
    BU region filter added - LCRM_Sub_BU__c in('LatAm', 'GGO')
    Standard Account filter changed to SSD Account (for eg Account.SAPAccountNumber__C to LCRM_Account_SSD__r.Source_System_Account_Number__c)
    */   
   // try{
      system.debug('InTry');
      if(String.isNotBlank(contactId) && String.isNotBlank(caseNo)){           
    
        ListCases = new List<Case>([SELECT  Id,ContactEmail,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,Subject, 
        ESC_Customer_Symptom__c,Product__c,contact.name,ESC_Diagnosis_Summary__c,Account.Name,contact.phone,
        Description,Owner.Name,ESC_Resolution_Comment__c,AccountId,ContactId,Account.SAPAccountNumber__C,
        ESC_Cause__c,ESC_Resolution_Code__c, ClosedDate, ContactPhone,ContactMobile,Status,Source.name,MYTR_Query_Type__c,
        MYTR_Category__c  ,Reason__c,Priority,ESC_Impact__c,Follow_Up_Date__c,Due_DateTime__c
        FROM CASE where (CaseNumber =: caseNo OR ContactId =:contactId) and Closed_Case__c = false AND LCRM_Sub_BU__c in ('LatAm', 'GGO')
        ORDER BY LastModifiedDate Desc NULLS Last]);

        ResponseCaseWrappper = CaseWrapperHelper.createCaseWrapper(ListCases);
        
        }else
        if(String.isNotBlank(contactId)){
          ListCases = new List<Case>([SELECT  Id,ContactEmail,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,Subject, 
          ESC_Customer_Symptom__c,Product__c,contact.name,ESC_Diagnosis_Summary__c,Account.Name,contact.phone,
          Description,Owner.Name,Account.SAPAccountNumber__C,ESC_Resolution_Comment__c,AccountId,ContactId,
          ESC_Cause__c,ESC_Resolution_Code__c, ClosedDate, ContactPhone,ContactMobile,Status,Source.name,MYTR_Query_Type__c,
          MYTR_Category__c  ,Reason__c,Priority,ESC_Impact__c,Follow_Up_Date__c,Due_DateTime__c
          FROM CASE where  ContactId =: contactId and Closed_Case__c = false AND LCRM_Sub_BU__c in ('LatAm', 'GGO') ORDER BY LastModifiedDate Desc NULLS Last]);
          
          ResponseCaseWrappper = CaseWrapperHelper.createCaseWrapper(ListCases);
        }else
        if(String.isNotBlank(caseNo) ){
            system.debug('InTryCaseNo');
            ListCases = new List<Case>([SELECT Id,ContactEmail,CaseNumber,CreatedDate,LastModifiedDate,LastModifiedBy.Name,
            Subject,ESC_Customer_Symptom__c,Product__c,ESC_Diagnosis_Summary__c,Account.Name,contact.phone,contact.name,             
            Description,Owner.Name,Account.SAPAccountNumber__C,ESC_Resolution_Comment__c,Source.name,MYTR_Query_Type__c,
            ESC_Cause__c,ESC_Resolution_Code__c,ClosedDate, ContactPhone,ContactMobile,Status,AccountId,ContactId,
            MYTR_Category__c  ,Reason__c,Priority,ESC_Impact__c,Follow_Up_Date__c,Due_DateTime__c,  
            (SELECT Id,title,body,RelatedRecordId,type,Visibility,LastModifiedDate,CreatedBy.name from feeds 
            where (type = 'ContentPost' OR type = 'TextPost') AND Visibility = 'AllUsers'),
            (select id,Field,NewValue,oldvalue,createddate,createdbyid,createdBy.Name from 
            Histories where field ='Status' order by createddate  desc limit 1)    
            FROM CASE where  CaseNumber =: caseNo ORDER BY LastModifiedDate Desc NULLS Last]);

            ResponseCaseWrappper = CaseWrapperHelper.createCaseWrapper(ListCases);
        }
    
   
     system.debug('ResponseCaseWrappper---'+ResponseCaseWrappper);    
     
     return ResponseCaseWrappper;
       
  }
    
}