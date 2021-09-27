/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-07-17   Navleen Kaur            Created for GLI to format fields of Source_System_Detail__c
 * 2018-04-25   Benjamin Her            Changed SSD RecordType Label from USL to Lotus
 * 2019-06-06   Navleen Kaur            DLT-16786 : [Tech Story] [Code Scan] - Fix code scan MAJOR issues in this DC_ContactSSDFieldCapitalisation_Test.cls
 * 2021-03-25   Kavya S                 DLT-21531 : [INC3938622] [SFDC] Digital landing page reflecting the incorrect address name and PMD fix
 * ==================================================================================================================================   
 */
@IsTest
public class DC_SSDFieldValueCapitalisation_Test {
  private Static testmethod void getSSDTest(){
      Account acc= new Account();
      acc = UnitTest.getAccountInstance();
      insert acc;
      test.starttest();
      List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
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
      listOfSSD.add(accountSSD);
      DC_SSDFieldValueCapitalisation.getFormattedSSD(listOfSSD);
      system.assert(listOfSSD!=null,'SSD is null');
   }
}