@isTest
private class EmailNotification_LeadAssignment_Test {
    @isTest
    private static void testCase(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole psRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Legal' limit 1];// Updated this method to fix test class error for CRM-1324
        User u1;
          System.runAs ( new User(Id = UserInfo.getUserId()) ) {
              u1 = new User(alias = 'newUser1', email='user12@mydomain12.com', 
                           emailencodingkey='UTF-8', lastname='Testing12', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           Sales_Org__c = 'GLI', timezonesidkey='America/Los_Angeles', username='usertest123@mydomain.com.prod',UserRoleId = psRole.Id);        
             insert u1;
              
          }
        System.runAs(u1){
            Lead testLead = new Lead();
            testLead.Company = 'test lead';
            testLead.FirstName = 'test';
            testLead.LastName  = 'Lead';
             testLead.Status = 'Unworked';
          testLead.LCRM_Influence_Level__c = false;
          testLead.Industry = 'ACAD-WEG SCH-PARALGL';
          testLead.Sequenced_in_Outreach__c = false;
          testLead.Telequalified_Appointment_Complete__c = false; 
          testLead.Lead_Region__c = 'Rep Generated'; 
          testLead.Lead_Scoring_Combined__c = 'A2';
          testLead.TRWayLeadMgmt__Panorama_Lead_Stage__c = 'Qualified Lead';
          testLead.Billing_State__c = 'KA';
          testLead.Billing_Country__c = 'IN';
          testLead.BU_Segment__c = 'Professional Tax';
          testLead.ECC_Number_Of_Employees__c = '1-29';
          testLead.Sales_Org__c = 'WEST';
          testLead.Is_GLI__c = true;
          testLead.Customer_Type__c = 'Organization';                              
          insert testLead;
          Lead testLead2 = new Lead();
          testLead2.Company = 'test lead2';
          testLead2.FirstName = 'test';
          testLead2.LastName  = 'Lead2';
          testLead2.Status = 'Unworked';
          testLead2.LCRM_Influence_Level__c = false;
          testLead2.Industry = 'ACAD-WEG SCH-PARALGL';
          testLead2.Sequenced_in_Outreach__c = false;
          testLead2.Telequalified_Appointment_Complete__c = false; 
          testLead2.Lead_Region__c = 'Rep Generated'; 
          testLead2.Lead_Scoring_Combined__c = 'A4';
          testLead2.TRWayLeadMgmt__Panorama_Lead_Stage__c = 'Qualified Lead';
          testLead2.Billing_State__c = 'KA';
          testLead2.Billing_Country__c = 'IN';
          testLead2.BU_Segment__c = 'Professional Tax';
          testLead2.ECC_Number_Of_Employees__c = '1-29';
          testLead2.Sales_Org__c = 'WEST';
          testLead2.Is_GLI__c = true;
          testLead2.Customer_Type__c = 'Organization';                              
          insert testLead2;
         
            test.startTest();
             
            testLead.Lead_Scoring_Combined__c = 'A1';
            update testLead;
            testLead2.Lead_Scoring_Combined__c = 'A3';
            update testLead2;
            
            test.stopTest();
            
            FeedItem chatterPost = [select Id, ParentId from FeedItem where ParentId =:testLead.Id ];
            System.assertEquals(testLead.id, chatterPost.ParentId);
            FeedItem chatterPost2 = [select Id, ParentId from FeedItem where ParentId =:testLead2.Id ];
            System.assertEquals(testLead2.id, chatterPost2.ParentId);
        }
    }

}