/*
    Test Class : Created for Process Builder -GLI ECC Segmentation Update on Lead
    GLI_ECC_Segmentation_Update_on_Lead
    Developer : TCS OffShore
*/
@isTest
public class GLIECCSegmentationUpdateOnLead_Test{
 
   
    public static testMethod void testAccWithAccLead() {
        
            LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = false;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
            
            recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
            recordtype contactRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            recordtype leadRT = [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            
            
            Account parentAccount = UnitTest.getAccountInstance();
            parentAccount.Name = 'Parent Test Account';
            parentAccount.Phone = '91 80 67254199';
            parentAccount.BillingCountry = 'US';
            parentAccount.BillingState='IL';
            parentAccount.BillingPostalCode = '60603-3801';
            parentAccount.Is_GLI__c = true;
            parentAccount.RecordTypeId=accountRT.Id;
            insert parentAccount;
            
            
            //Account childAccount = UnitTest.getAccountInstance();
            Account childAccount = new Account();
            childAccount.Name = 'Child Test Account';
            childAccount.Phone = '91 80 67254199';
            childAccount.BillingCountry = 'US';
            childAccount.BillingState='IL';
            childAccount.BillingPostalCode = '60603-3801';
            childAccount.Operational_Ultimate_Parent_Name1__c = parentAccount.Id;
            childAccount.Is_GLI__c = true;
            childAccount.Street_Name__c='test';
            childAccount.RecordTypeId=accountRT.Id;
            insert childAccount;
            
            Contact contact = UnitTest.getContactInstance(childAccount.Id);
            contact.RecordTypeId=contactRT.Id;
            contact.Email = 'test@tcs.com';
            
            insert contact;        
            
            List<Lead> listLead = new List<Lead>();
            Lead lead = UnitTest.getLeadInstance();
            lead.LastName='Patel';
            lead.Company = 'UTLeadAccount';
            lead.Billing_City__c = 'test';
            lead.Billing_Street__c = 'test';
            lead.Billing_State__c = 'CA';
            lead.Billing_Zip__c = 'test';
            lead.Billing_Country__c = 'US';
            lead.email = 'abc@gmail.com';
            lead.RecordTypeId = leadRT.Id;
            lead.Is_GLI__c = true;
            //lead.Account__c = childAccount.id;
            listLead.add(lead);
            
            //Legal Prof - Large
            Lead lead1 = UnitTest.getLeadInstance();
            lead1.LastName='Patel';
            lead1.Company = 'UTLeadAccount';
            lead1.Billing_City__c = 'test';
            lead1.Billing_Street__c = 'test';
            lead1.Billing_State__c = 'CA';
            lead1.Billing_Zip__c = 'test';
            lead1.Billing_Country__c = 'US';
            lead1.email = 'abcdd@gmail.com';
            lead1.RecordTypeId = leadRT.Id;
            lead1.Is_GLI__c = true;
            lead1.BU_Segment__c = 'Professional Legal';
            lead1.ECC_Top_Named_Law_Firms__c = 'AKERMAN LLP';
            listLead.add(lead1);
        
            //Legal Prof - Medium
            Lead lead2 = UnitTest.getLeadInstance();
            lead2.LastName='Patel';
            lead2.Company = 'UTLeadAccount';
            lead2.Billing_City__c = 'test';
            lead2.Billing_Street__c = 'test';
            lead2.Billing_State__c = 'CA';
            lead2.Billing_Zip__c = 'test';
            lead2.Billing_Country__c = 'US';
            lead2.email = 'abcdde@gmail.com';
            lead2.RecordTypeId = leadRT.Id;
            lead2.Is_GLI__c = true;
           // lead2.Account__c = childAccount.id;
            lead2.BU_Segment__c = 'Professional Legal';
            lead2.ECC_Number_of_Attorneys__c = 'Attorneys 11+';
            lead2.ECC_Top_Named_Law_Firms__c = 'Not on this list';
            listLead.add(lead2);
            
            //Legal Prof - Small
            Lead lead3 = UnitTest.getLeadInstance();
            lead3.LastName='Patel';
            lead3.Company = 'UTLeadAccount';
            lead3.Billing_City__c = 'test';
            lead3.Billing_Street__c = 'test';
            lead3.Billing_State__c = 'CA';
            lead3.Billing_Zip__c = 'test';
            lead3.Billing_Country__c = 'US';
            lead3.email = 'abcdde@gmail.com';
            lead3.RecordTypeId = leadRT.Id;
            lead3.Is_GLI__c = true;
            //lead3.Account__c = childAccount.id;
            lead3.BU_Segment__c = 'Professional Legal';
            lead3.ECC_Number_of_Attorneys__c = 'Attorneys 1-10';
            lead3.ECC_Top_Named_Law_Firms__c = 'Not on this list';
            listLead.add(lead3);
            
            //Tax Prof - Large
            Lead lead4 = UnitTest.getLeadInstance();
            lead4.LastName='Patel';
            lead4.Company = 'UTLeadAccount';
            lead4.Billing_City__c = 'test';
            lead4.Billing_Street__c = 'test';
            lead4.Billing_State__c = 'CA';
            lead4.Billing_Zip__c = 'test';
            lead4.Billing_Country__c = 'US';
            lead4.email = 'abcdde@gmail.com';
            lead4.RecordTypeId = leadRT.Id;
            lead4.Is_GLI__c = true;
            //lead4.Account__c = childAccount.id;
            lead4.BU_Segment__c = 'Professional Tax';
            lead4.ECC_Number_Of_Employees__c = '30+';
            listLead.add(lead4);
            
            //Legal Prof - Small
            Lead lead5 = UnitTest.getLeadInstance();
            lead5.LastName='Patel';
            lead5.Company = 'UTLeadAccount';
            lead5.Billing_City__c = 'test';
            lead5.Billing_Street__c = 'test';
            lead5.Billing_State__c = 'CA';
            lead5.Billing_Zip__c = 'test';
            lead5.Billing_Country__c = 'US';
            lead5.email = 'abcdde@gmail.com';
            lead5.RecordTypeId = leadRT.Id;
            lead5.Is_GLI__c = true;
            //lead5.Account__c = childAccount.id;
            lead5.BU_Segment__c = 'Professional Legal';
            lead5.ECC_Number_of_Attorneys__c = 'Attorneys 1-10';
            lead5.ECC_Top_Named_Law_Firms__c = 'Not on this list';
            listLead.add(lead5);
            
            //Tax Prof - Emerging
            Lead lead6 = UnitTest.getLeadInstance();
            lead6.LastName='Patel';
            lead6.Company = 'UTLeadAccount';
            lead6.Billing_City__c = 'test';
            lead6.Billing_Street__c = 'test';
            lead6.Billing_State__c = 'CA';
            lead6.Billing_Zip__c = 'test';
            lead6.Billing_Country__c = 'US';
            lead6.email = 'abcdde@gmail.com';
            lead6.RecordTypeId = leadRT.Id;
            lead6.Is_GLI__c = true;
            lead6.BU_Segment__c = 'Professional Tax';
            lead6.ECC_Number_Of_Employees__c = '1-29';
            listLead.add(lead6);
            
            //Corporate - Global 7
            Lead lead7 = UnitTest.getLeadInstance();
            lead7.LastName='Patel';
            lead7.Company = 'UTLeadAccount';
            lead7.Billing_City__c = 'test';
            lead7.Billing_Street__c = 'test';
            lead7.Billing_State__c = 'CA';
            lead7.Billing_Zip__c = 'test';
            lead7.Billing_Country__c = 'US';
            lead7.email = 'abcdde@gmail.com';
            lead7.RecordTypeId = leadRT.Id;
            lead7.Is_GLI__c = true;
            lead7.BU_Segment__c = 'Corporate';
            lead7.ECC_Top_Named_Corporations__c = 'BDO INTERNATIONAL LIMITED';
            listLead.add(lead7);
            
            //Corporate - Strategic
            Lead lead8 = UnitTest.getLeadInstance();
            lead8.LastName='Patel';
            lead8.Company = 'UTLeadAccount';
            lead8.Billing_City__c = 'test';
            lead8.Billing_Street__c = 'test';
            lead8.Billing_State__c = 'CA';
            lead8.Billing_Zip__c = 'test';
            lead8.Billing_Country__c = 'US';
            lead8.email = 'abcdde@gmail.com';
            lead8.RecordTypeId = leadRT.Id;
            lead8.Is_GLI__c = true;
            lead8.BU_Segment__c = 'Corporate';
            lead8.ECC_Top_Named_Corporations__c = 'AIG';
            listLead.add(lead8);
            
            //Corporate - Large
            Lead lead9 = UnitTest.getLeadInstance();
            lead9.LastName='Patel';
            lead9.Company = 'UTLeadAccount';
            lead9.Billing_City__c = 'test';
            lead9.Billing_Street__c = 'test';
            lead9.Billing_State__c = 'CA';
            lead9.Billing_Zip__c = 'test';
            lead9.Billing_Country__c = 'US';
            lead9.email = 'abcdde@gmail.com';
            lead9.RecordTypeId = leadRT.Id;
            lead9.Is_GLI__c = true;
            lead9.BU_Segment__c = 'Corporate';
            lead9.ECC_Top_Named_Corporations__c= 'Not on this list';
            lead9.ECC_Annual_Revenue__c= 'Equal To or Above $750M';
            listLead.add(lead9);
            
            //Corporate - Emerging
            Lead lead91 = UnitTest.getLeadInstance();
            lead91.LastName='Patel';
            lead91.Company = 'UTLeadAccount';
            lead91.Billing_City__c = 'test';
            lead91.Billing_Street__c = 'test';
            lead91.Billing_State__c = 'CA';
            lead91.Billing_Zip__c = 'test';
            lead91.Billing_Country__c = 'US';
            lead91.email = 'abcdde@gmail.com';
            lead91.RecordTypeId = leadRT.Id;
            lead91.Is_GLI__c = true;
            lead91.BU_Segment__c = 'Corporate';
            lead91.ECC_Top_Named_Corporations__c = 'Not on this list';
            lead91.ECC_Annual_Revenue__c= 'Under $750M';
            listLead.add(lead91);
            
            //Government - Federal
            Lead leadd91 = UnitTest.getLeadInstance();
            leadd91.LastName='Patel';
            leadd91.Company = 'UTLeadAccount';
            leadd91.Billing_City__c = 'test';
            leadd91.Billing_Street__c = 'test';
            leadd91.Billing_State__c = 'CA';
            leadd91.Billing_Zip__c = 'test';
            leadd91.Billing_Country__c = 'US';
            leadd91.email = 'abcdde@gmail.com';
            leadd91.RecordTypeId = leadRT.Id;
            leadd91.Is_GLI__c = true;
            leadd91.BU_Segment__c = 'Government';
            leadd91.ECC_Government_Type__c = 'Federal';
            listLead.add(leadd91);
            
            //Government - StateLocal
            Lead leadd= UnitTest.getLeadInstance();
            leadd.LastName='Patel';
            leadd.Company = 'UTLeadAccount';
            leadd.Billing_City__c = 'test';
            leadd.Billing_Street__c = 'test';
            leadd.Billing_State__c = 'CA';
            leadd.Billing_Zip__c = 'test';
            leadd.Billing_Country__c = 'US';
            leadd.email = 'abcdde@gmail.com';
            leadd.RecordTypeId = leadRT.Id;
            leadd.Is_GLI__c = true;
            leadd.BU_Segment__c = 'Government';
            leadd.ECC_Government_Type__c = 'State/Local (including County & Municipal)';
            listLead.add(leadd);
            
            //Government - Education
            Lead leadd911 = UnitTest.getLeadInstance();
            leadd911.LastName='Patel';
            leadd911.Company = 'UTLeadAccount';
            leadd911.Billing_City__c = 'test';
            leadd911.Billing_Street__c = 'test';
            leadd911.Billing_State__c = 'CA';
            leadd911.Billing_Zip__c = 'test';
            leadd911.Billing_Country__c = 'US';
            leadd911.email = 'abcdde@gmail.com';
            leadd911.RecordTypeId = leadRT.Id;
            leadd911.Is_GLI__c = true;
            leadd911.BU_Segment__c = 'Government';
            leadd911.ECC_Government_Type__c = 'Education';
            listLead.add(leadd911);
            
            insert ListLead;
            
            System.assert(ListLead!= null);
    }   

}