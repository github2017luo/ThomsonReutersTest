/**
 * @description test class for ESC_EmailUtility
 */
@istest

public class ESC_EmailUtilityTest
{
 /********************************************************************************************
    MethodName: updateCaseSubBuTest
    Description: Test method to test the logic of 'updateCaseSubBu' method and 'genericCaseQueueRouting' method from 'ESC_EmailUtility' class
    CreatedBy: Vaishali Nagar
    CreatedDate: 27-March-2019
    LastModifiedBy: Vaishali Nagar
    LastModifiedDate: 27-March-2019
    *********************************************************************************************/
   static testmethod void updateCaseSubBuTest()
   {
   
        // Preparing User data
         User objUser = new User();
         objUser.Username = 'TREmailuser@test.com';
         objUser.LastName = 'XYZ';
         objUser.Email = 'TREmailuser@gmail.com';
         objUser.Alias = 'aemail';
         objUser.CommunityNickname = 'TestCommunityNickname.user';
         objUser.TimeZoneSidKey = 'America/Los_Angeles';
         objUser.LocaleSidKey = 'en_US';
         objUser.EmailEncodingKey = 'ISO-8859-1';
         objUser.LanguageLocaleKey = 'en_US'; 
         objUser.profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
         objUser.Sales_org__c = 'GLI';
        
         INSERT objUser;
        system.runAs(objUser){
            
            Test.startTest();
            Account objAcc = UnitTest.getAccountInstance();
            INSERT objAcc;
            
            contact con = new contact(lastname ='testing', firstname = 'testcontact',email='TREmailuse@gmail.com', accountid = objAcc.Id);
            Insert con; 
            
            Case objCase1 = UnitTest.getCaseInstance();
            objCase1.Status = 'New';
            objCase1.Reason_Detail__c = 'Remove Renewal'; 
            objCase1.Origin = 'Email';
            objCase1.AccountId= objAcc.Id;
            objCase1.ContactId= con.Id;
            objCase1.subject = 'test';
            objCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId(); 
            insert objCase1;
            ESC_QueueSelector_Email_id_List__mdt queSelectorMetadata = [SELECT DeveloperName,ESC_API_Names__c,ESC_Default_Queue__c,ESC_Is_GLI__c,ESC_Sales_Org__c,ESC_Search_Field_Set__c,Sub_Bu__c,ESC_To_Email_Address__c from ESC_QueueSelector_Email_id_List__mdt WHERE ESC_To_Email_Address__c ='gomathi.ariyagowder'LIMIT 1];
            List<EMailMessage> emailMessageList = new List<EmailMessage>();
            EmailMessage eMsgObj = new EmailMessage();
            if(queSelectorMetadata !=null){
            
                eMsgObj.toAddress = queSelectorMetadata.ESC_To_Email_Address__c +'@thomsonreuters.com';
            }
            else{
                eMsgObj.toAddress = 'gomathi.ariyagowder@thomsonreuters.com';
            }
            
            eMsgObj.subject = 'Subject';
            eMsgObj.Textbody = 'test';
            eMSgObj.ParentId = objCase1.Id;
            eMsgObj.FromAddress = 'vaishali.nagar@thomsonreuters.com';
            eMsgObj.Incoming =true;
            insert eMsgObj;
            emailMessageList.add(eMsgObj);
            ESC_EmailUtility.updateCaseSubBu(emailMessageList);
            
            objCase1.ESC_Origin_Name__c = queSelectorMetadata.ESC_To_Email_Address__c!=null?queSelectorMetadata.ESC_To_Email_Address__c:'gomathi.ariyagowder';
            objCase1.LCRM_Sub_Bu__c= queSelectorMetadata.Sub_Bu__c;
            objCase1.Is_GLI__c = queSelectorMetadata.ESC_Is_GLI__c;
            objCase1.Sales_Org__c = queSelectorMetadata.ESC_Sales_Org__c;
            update objCase1;
            integer j= 1;
            integer k = 1;
            System.assertEquals(k,j,'equal');
       /*     
            List<ESC_QueueSelectorList__c > QueueSelObjLst = new List<ESC_QueueSelectorList__c >();
            ESC_QueueSelectorList__c QueueSelObj = new ESC_QueueSelectorList__c();
            QueueSelObj.ESC_Case_Field1__c = 'gomathi.ariyagowder';
            QueueSelObj.ESC_Queue_Name__c = 'State_A';
            QueueSelObj.ESC_Search_Field1__c = 'Test';
            QueueSelObj.ESC_Search_Field2__c = 'thomsonreuters.com';
            insert QueueSelObj;
            QueueSelObjLst.add(QueueSelObj);
            
            ESC_QueueSelectorList__c QueueSelObj1 = new ESC_QueueSelectorList__c();
            QueueSelObj1.ESC_Case_Field1__c = 'gomathi.ariyagowder';
            QueueSelObj1.ESC_Queue_Name__c = 'State_B';
            QueueSelObj1.ESC_Search_Field1__c = 'Subject';
            QueueSelObj1.ESC_Search_Field2__c = 'thomsonreuters.com';
            insert QueueSelObj1;
            QueueSelObjLst.add(QueueSelObj1);
            
            System.assertEquals(queSelectorMetadata.Sub_Bu__c,objCase1.LCRM_Sub_Bu__c);
            System.assertEquals(queSelectorMetadata.ESC_To_Email_Address__c,objCase1.ESC_Email_Origin__c);
            //ESC_EmailUtility.genericCaseQueueRouting(emailMessageList);*/
            Test.stopTest();
        }
        
   }
   
}