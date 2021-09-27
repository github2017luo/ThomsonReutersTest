/*============================================================================================
Name                : ODT_StartImmediateTrialHandlerTest
Description         : This class is developed as part of CXD-ODT project and serves as a Test Class for ODT_StartImmediateTrialHandler  
Created Date        : 11/7/2019
Author              : Sneha Wali
==============================================================================================*/
/**
 * Test class 
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-03-23   Brenda Shields          DLT-19804 - Move State/Country references from Account/Contact/Leads to methods in DCTestData                                
 * =============================================================================
 */

@isTest(Seealldata=false)
public class ODT_StartImmediateTrialHandlerTest {
    public static testMethod  void testDisplayICProduct(){                                     
                Profile p1 = [SELECT Id FROM Profile WHERE Name=:'ANZ Users'];  
                User u = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'AND Profile.id =:p1.id limit 1];
                Map<String,Schema.RecordTypeInfo> recordTypes = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
                Id optyPipeRecTypeId = recordTypes.get('Pipeline Opportunity').getRecordTypeId(); 
                Id optyPreRecTypeID = recordTypes.get('Pre-Pipeline Opportunity').getRecordTypeId();
                Id optyGLIRecTypeID = recordTypes.get('GLI Pipeline Opportunity').getRecordTypeId();
                System.debug('Pipeline'+optyPipeRecTypeId+'Pre-pipeline'+optyPreRecTypeID+'GLI pipeline'+optyGLIRecTypeID);
                
                //Keyvalue setting for OpportunityUtil class
                KeyValueListStore__C keyCustomSetting = new KeyValueListStore__c(Name= 'ANZUsersProfileId',TextValue__c= p1.id);
                insert keyCustomSetting;
                
                List<WebServiceSettings__c> WebserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease',Service_Unavailable_Message__c='Service not Available'),
                    new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
                    new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
                    new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.thomsonreuters.com/ebs/entitlement/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
                  insert WebserviceList;
                
                
                //Creation of 3 record types.
                RecordtypeIds__c recT= new RecordtypeIds__c();
                recT.name= 'Pre-Pipeline Opportunities';
                recT.recTypeId__C = optyPipeRecTypeId != null? optyPreRecTypeID : '012a0000001ZJxn';        
                insert recT;
                
                RecordtypeIds__c recT1= new RecordtypeIds__c();
                recT1.Name= 'Pipeline Opportunities';
                recT1.recTypeId__C = optyPipeRecTypeId != null? optyPipeRecTypeId : '012a0000001ZJxn';
                insert recT1; 
                
                RecordtypeIds__c recT2= new RecordtypeIds__c();
                recT2.Name= 'GLI Pipeline Opportunity';
                recT2.recTypeId__C = optyGLIRecTypeID != null? optyGLIRecTypeID : '012a0000001ZJxn';
                insert recT2;
                
                Pricebook2 pbook = new Pricebook2();
                pbook.name =  'GLI Price Book - US Legal/LMS';        
                pbook.IsActive = true;
                insert pbook;
                
                // Create Account
                Account newAcct = DCTestData.createAccount('Test Class Account');
                newAcct.OwnerId=UserInfo.getUserId();    
                insert newAcct;
                
                //Create AccountSSD record
                Source_System_Detail__c accSSD = new Source_System_Detail__c();
                accSSD.Name = 'Test Account SSD';
                accSSD.Source_System_Name__c = 'Test System';
                accSSD.Source_System_Account_Number__c = '173468930';
                accSSD.Account_Name__c = newAcct.id;
                accSSD.Trial_Status__c = 'Invited';
                accSSD.LCRM_Market_Segment__c = 'SLF 4-6';
                insert accSSD;
                
                //Create Contact
                Contact con = new Contact();
                con.FirstName = 'John';
                con.LastName = 'Ray';
                con.SAP_Contact_ID__c = '0006271252';
                con.AccountId = newAcct.id; 
                con.Email = 'john.ray@tr.com';    
                insert con;
                
                //create opportunity
                Opportunity opp = new Opportunity();
                opp.Name = 'Test Opportunity';
                opp.closeDate = System.Today() + 5;
                opp.recordTypeId = optyPreRecTypeID;
                opp.Owner = u;
                opp.StageName='Prospect';
                opp.AccountId = newAcct.Id;
                opp.Pricebook2id = pbook.id ;
                opp.Source_System_Detail__c = accSSD.Id;
                insert opp;
        
                //To create ODT Product Bundle Records
               // List<ODT_Product_Bundle__c> listPrdBnlODT = New List<ODT_Product_Bundle__c>();
                ODT_Product_Bundle__c prdBndl1 = New ODT_Product_Bundle__c();
                prdBndl1.Name='Indigo';
                prdBndl1.Bundle_ID__c = '725545';
                prdBndl1.Is_Active__c = true;
                prdBndl1.Is_Enabled_For_Sales_Rep_Trial__c = true;
                prdBndl1.Product_Category__c = 'IND1';
                prdBndl1.Bundle_Type__c = 'CTX'; 
                prdBndl1.Business_Type__c = 'SLF';
                prdBndl1.Contacts_User_Type__c = 'NCJ';
                prdBndl1.Profile_ID__c= '431';
                prdBndl1.SAP_Promotion_Code__c = '1234';
               // listPrdBnlODT.add(prdBndl1);
               // insert listPrdBnlODT;
                insert prdBndl1;
                
                //create Trial
                Trial__c tr=new Trial__c();
                //tr.Account_Name__c=newAcct.Id;
                tr.Source_System_Detail__c = accSSD.id;
                tr.Trial_Id__c='56576';
                //tr.Contact_LeadId__c=newLead.Id;
                tr.Contact_id_SAP__c=con.SAP_Contact_ID__c;
                tr.Trial_Source__c='SFDC';
                tr.InvitedDateTime__c=System.today()-200;
                tr.Trial_Status__c = 'Invited';
                tr.Trial_Start_Date__c = System.today();
                tr.Trial_End_Date__c = System.today()+7;
                tr.ODT_Trial_Extend_Date__c=system.today()+10;
                tr.ODT_SAP_Account_Number__c = accSSD.Source_System_Account_Number__c;
                tr.ODT_Product_Bundle__c = prdBndl1.ID;
                tr.Profile_Type__c='Existing_User_Same_Domain';
                insert tr; 
                
                //create Opportunity trial
                Opportunity_Trial__c opTrial = new Opportunity_Trial__c();
                opTrial.Trial__c = tr.id;
                opTrial.Opportunity__c = opp.id;
                insert opTrial; 
                
                
                //create Invited Colleague
                Invite_Colleagues__c invitedClg1 = New Invite_Colleagues__c();
                invitedClg1.First_Name__c = 'test invite';
                invitedClg1.Last_Name__c = 'tessstt';
                invitedClg1.Trial_Status__c = 'Invited';
                invitedClg1.Trial__c = tr.id;
                invitedClg1.Source_System_Detail__c = accSSD.id;
                invitedClg1.Email__c = 'invclgemail@test.com';
                invitedClg1.Primary_User__c = true;
                invitedClg1.SapContactId__c = con.SAP_Contact_ID__c;
                //invitedClg1.Lead__c = lead.id; 
                insert invitedClg1;
        
                Test.startTest();
                apexpages.currentpage().getparameters().put('id', tr.id);
                ApexPages.StandardController cont = new ApexPages.StandardController(tr);
                ODT_StartImmediateTrialHandler trialIC = new ODT_StartImmediateTrialHandler(cont);
                trialIC.getInvitedColleagueTrial();
                trialIC.getTrial();
                trialIC.updateStatus();
                trialIC.back();
                Test.stopTest();         
    }
}