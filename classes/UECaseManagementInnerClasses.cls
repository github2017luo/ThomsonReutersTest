/********************************************************************************
Class Name : UECaseManagementInnerClasses
@description : This class encloses inner classes used for UE case management
********************************************************************************
Modification Details:
Date                    description                             Owner
29/09/2020              Created                                 Deepika Motamarri
13/01/2021              DUE-7463:Added reasonID,languge fields  Deepthi KB
                        to the request structure-CREATECASE
*********************************************************************************/
public class UECaseManagementInnerClasses {
    
    //Inner Class Declarations
  
   /********************************************************************************
   @description : Request Structure for CREATECASE Operation
   *********************************************************************************/ 
   public class CaseDetailsWrapper{
       
       public string contactId;
       public string subject;
       public String phoneNumber;
       public String description;
       public String queryType;
       public string product;
       public String currentFormURL;
       public String queryCategory;
       public String reasonID;
       public String categoryCode;
       public String language;
       public String alternateEmail;
       /** @description SAP Account Number */
       public string sapAccountNumber{get;set;}
   }//end ofcaseDetailsWrapper


   /********************************************************************************
   Class Name : DeleteFeedWrapper
   @description : Request Structure for DELETEATTACHMENT Operation
   *********************************************************************************/ 
   /* global class DeleteFeedWrapper{
       public string contentVersionId;
       public string contentDocumentId;
       public string feedItemId;        
   }*/
   //end of DeleteFeedWrapper

}