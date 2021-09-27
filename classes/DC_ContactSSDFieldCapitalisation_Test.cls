/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-07-17   Navleen Kaur            Created for GLI to format fields of Contact SSD
 * 2018-08-07   Bharat Bhushan          DLT-11509- [TECH STORY] SAP Contact ID field to modify as per GLI to be replace with Source Contact ID
 * 2018-04-25   Benjamin Her            Changed SSD RecordType Label from USL to Lotus
 * 2019-06-06   Navleen Kaur            DLT-16786 : [Tech Story] [Code Scan] - Fix code scan MAJOR issues in this DC_ContactSSDFieldCapitalisation_Test.cls
 * ==================================================================================================================================   
 */
@IsTest
public class DC_ContactSSDFieldCapitalisation_Test {
   private Static testmethod void getSSD_Test(){
      Account acc= new Account();
      acc = UnitTest.getAccountInstance();
      insert acc;
       
      test.starttest();
      Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.RecordtypeId=ssdRecorType;
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID; 
      accountSSD.City__c = 'BANGALORE';
      accountSSD.Account_Inactive__c = false;  
      //accountSSD.Source_System_Account_Number__c = acc.SAPAccountNumber__c;    
      accountSSD.LCRM_Frozen_Market_Segment__c = 'Solo Law Firm';
      accountSSD.LCRM_SAP_Account_Number__c = '1004284494';        
      accountSSD.LCRM_APTS_Band_Number__c= 1;
      accountSSD.APTS_Customer_Category__c = '3';
      accountSSD.LCRM_eOutput_Eligibility__c= ''; 
      accountSSD.LCRM_Sales_Org__c= 'WEST';
      accountSSD.State__c = 'California';
      insert accountSSD;
       
      Contact con = new contact();
      con = UnitTest.getContactInstance(acc.id);
      insert con;
       
      LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c();
      conSSD.LCRM_Contact__c=con.Id;
      conSSD.LCRM_SAP_Role__c=con.SAP_Role__c;
      conSSD.LCRM_Source_Contact_Id__c=con.SAP_Contact_ID__c;
      conSSD.LCRM_Account_SSD__c = accountSSD.Id;
      conSSD.LCRM_Email__c= con.Email;
      insert conSSD;
      List<LCRM_Contact_SSD__c> listOfSSD = new List<LCRM_Contact_SSD__c>();
      listOfSSD.add(conSSD);
      DC_ContactSSDFieldValueCapitalisation.getFormattedContactSSD(listOfSSD);
      system.assert(listOfSSD!=null);
   }
}