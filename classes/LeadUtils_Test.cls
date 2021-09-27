/**
 * Contains Test methods for Lead Trigger After Event and Leadutil class
 *
 * @author  Nandita Shet
 * @version  2013-06-24
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-24   Nandita Shet        Created test Class and test methods for 
                                    LeadUtils class
 * =============================================================================
 */ 





@IsTest(SeeAlldata = true)

Private class LeadUtils_Test{

    public static String randomGenerator(){
        double temp = Math.random();
        String tempStr = String.valueOf(temp);
        tempStr = tempStr.split('\\.')[1];
        return tempStr;
    }

    public static testmethod void testleadconvert(){
    
        Profile testprofile = [SELECT Id FROM profile WHERE name='System Administrator'];   
         
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = testprofile.Id, employeenumber='0143564',
            timezonesidkey='America/Los_Angeles', username='user10@mydomain.com',Rep_Type_Description__c='test');   
        insert testuser;
        
        
        System.runAS(testuser){
    
            List<Account> listestaccount = new List<Account>();
            List<Lead> listtestLead = new List<Lead>();   
            
            
            
            Account account1 = UnitTest.getAccountInstance();
            account1.Name = 'UTLeadAccount1';
            listestaccount.add(account1);
            
            Account account2 = UnitTest.getAccountInstance();
            account2.Name = 'UTLeadAccount2';
            //account2.Legacy_System_ID__c = '1234';
            account2.Legacy_System_ID__c = randomGenerator();
            account2.BillingCity = 'test';
            account2.BillingStreet = 'test'; 
            account2.BillingCountry = 'IN';
            account2.BillingState = 'GJ';
            account2.Customer_Class_c__c = 'None';
            listestaccount.add(account2);
            
            Account account3 = UnitTest.getAccountInstance();
            account3.Name = 'UTLeadAccount3';
            account3.Legacy_System_ID__c = randomGenerator();
            //account3.Legacy_System_ID__c = '2345';
            listestaccount.add(account3);
            insert listestaccount;

            
            
          /*  Contact testContact = UnitTest.getContactInstance(account2.Id);
            testContact.External_ID__c = '123';
            insert testContact;
             test.stopTest();*/
            
            Lead lead1 = UnitTest.getLeadInstance();
            lead1.Company = 'test';
            lead1.LeadSource = 'Website';
            lead1.Source__c = 'Practical Law';
            lead1.Legacy_System_ID__c = randomGenerator();
            //lead1.Legacy_System_ID__c = '1234';
            lead1.External_Contact_ID__c = '123';
            lead1.OwnerId = testuser.Id;
            listtestLead.add(lead1);
    
            //Lead lead2 = new lead(Company = 'test',LeadSource = 'Website',Source__c = 'Practical Law',Legacy_System_ID__c = '2345'
            //,OwnerId = testuser.Id,Billing_Street__c='Gokul',Billing_City__c='Bangalore',Billing_Zip__c='343434',Billing_State__c='Karnataka',
            //firstname='Test1',lastname='Test2',Business_Org__c='Tax Profile',Phone='349876254245',Email='test@gamil.com');
            Lead lead2 = new lead(Company = 'test',LeadSource = 'Website',Source__c = 'Practical Law',Legacy_System_ID__c = randomGenerator()
            ,OwnerId = testuser.Id,Billing_Street__c='Gokul',Billing_City__c='Bangalore',Billing_Zip__c='343434',Billing_State__c='Karnataka',
            firstname='Test1',lastname='Test2',Business_Org__c='Tax Profile',Phone='349876254245',Email='test@gamil.com');
            
            insert lead2;
    
            /*Lead lead3 = UnitTest.getLeadInstance();
            lead3.Company = 'test';            
            lead3.LeadSource = 'Website';
            lead3.Source__c = 'Practical Law';
            lead3.Legacy_System_ID__c = '1234';
            lead3.OwnerId = testuser.Id;            
            listtestLead.add(lead3);
    
            Lead lead4 = UnitTest.getLeadInstance();
            lead4.Company = 'test';
            lead4.Source__c = 'Practical Law';
            lead4.Legacy_System_ID__c = '1234';
            lead4.OwnerId = testuser.Id;            
            listtestLead.add(lead4);
            
            Lead lead5 = UnitTest.getLeadInstance();
            lead5.Company = 'test';            
            lead5.Source__c = 'Practical Law';
            lead5.LeadSource = 'Website';
            listtestLead.add(lead5);*/
            
          //  insert listtestLead;
            
           // listtestLead= [Select IsConverted from Lead where Id IN : listtestLead];
            
           
           /* test.startTest();
            for(Lead otestLead : listtestLead){
              if(otestLead.Id == lead1.id)
                    System.assertEquals(otestLead.IsConverted,false,'Error:Lead Convert failed');
                    
              else if(otestLead.id == lead2.id)
                    System.assertEquals(otestLead.IsConverted,false,'Error:Lead Converted without required values');*/
                    
                     // list<LM_SLA__C> LMSLA = new List<LM_SLA__C> {Lead_Score__c='A1'};
                test.startTest();       
                    List<LM_SLA__C> LMSLA = new List<LM_SLA__C>(); 
                    LM_SLA__C LMSLA1 = new LM_SLA__C();
                         LMSLA1.Lead_Score__c='A1';    
                         LMSLA1.Send_Notification_Email__c=true;
                            LMSLA1.Channel__c='Tax Profile';
                            
                      list<Lead> NewLeadList = new list<Lead>();
                      Map<id,Lead> NewLeadList1 = new map<id,Lead>();
                      Lead NewLeadListinsert = new lead();
//                      NewLeadListinsert.lead.id='2F07M29000000KroJ';
                      NewLeadListinsert.Company='TCS';
                  //   .. NewLeadListinsert.name='TCS1';
                      NewLeadListinsert.firstname='Test1';
                      NewLeadListinsert.lastname='Test2';
                      NewLeadListinsert.Business_Org__c='Tax Profile';
                      NewLeadListinsert.Lead_Scoring_Combined__c='A1';
                    //  NewLeadListinsert.Ownerid='2F07M29000000KroJ';
                      NewLeadListinsert.Source_Desc__c='UAT';
                      NewLeadListinsert.Description='test Lead';
                      NewLeadListinsert.Billing_Street__c='Gokul';
                      NewLeadListinsert.Billing_City__c='Bangalore';
                      NewLeadListinsert.Billing_Zip__c='343434';
                      NewLeadListinsert.Billing_State__c='Karnataka';
                       NewLeadListinsert.Source__c='UAT';
                       NewLeadListinsert.Phone='349876254245';
                       NewLeadListinsert.Email='test@gamil.com';
                              
                              insert LMSLA;
                              
                              insert NewLeadList;
                              
                  //            LeadUtils.NewLeadCreation(NewLeadList);
                             LeadUtils.ConvertleadtoPPO(NewLeadList,NewLeadList1); 
                             LeadUtils.checkRequiredFields(lead2);
                             DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
    
                             Schema.DescribeSObjectResult Opportunitydescresult = Schema.SObjectType.Opportunity; 
                             Map<String,Schema.RecordTypeInfo> rectypeMapByName = Opportunitydescresult.getRecordTypeInfosByName();
                             String strOwnerId = '';
    /**
     * Validates that an address is properly validated for required information
     */
            String newOwner;
       List<Messaging.SingleEmailMessage> listSingleEmailMessages = new List<Messaging.SingleEmailMessage>();            
       List<String> toAddresses = new List<String>();      
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           toAddresses.add('2F07M29000000KroJ');
            mail.setSaveAsActivity(false);
             mail.setSubject('Alert - Lead Has Been Created'); 
          if(!toAddresses.isEmpty())
         {
           OrgWideEmailAddress[] owea;
                    //Get the OrgWideEmailAddress to use as the From email address
                 owea = [select Id from OrgWideEmailAddress where DisplayName = 'MIS CRM Operations'];
         
        
        //  string sLink = System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ nLead.Id; 
                    if (owea.size() > 0) {
                         mail.setOrgWideEmailAddressId(owea.get(0).Id); 
                         system.debug('***OrgWideaddress: ' + owea.get(0).Id);          
                     }  
                                       
               
           }       
                   /*if(newOwner.substring(0,3)=='005')
                     {
                     mail.setToAddresses(toAddresses);       
                    mail.setSaveAsActivity(false);
                    mail.setSubject('Alert - Lead ' + nLead.name+ ' Has Been Created');  
                     mail.setHtmlBody('Please be aware that the following Lead has been Created.' +
                        '<p>Account : ' + nLead.Company + 
                        '<p>Contact: ' + nLead.firstname +'  '+nLead.lastname + 
                        '<p>Description: ' + nLead.Description + 
                        '<p>Accept By: ' + nLead.Accept_By__C+ 
                        '<p>Lead Score: ' + nLead.Lead_Scoring_Combined__c+ 
                        '<p>Source Type: ' + nLead.Source__c+ 
                        '<p>Source Description: ' + nLead.Source_Desc__c+ 
                        '<p>Phone: ' + nLead.Phone+ 
                        '<p>Email: ' + nLead.Email+ 
                        '<p>Address: ' + nLead.Billing_Street__c+'\r\n' +nLead.Billing_City__c+nLead.Billing_Zip__c+'\r\n'+ nLead.Billing_State__c+                        
                         '<p>You can access Lead ' + nLead.Name + ' directly by clicking <a href="' + sLink + '">here</a>');
                    listSingleEmailMessages.add(mail); 
                   } 
                   }*/
              /*else if(otestLead.id == lead3.id)    
                  System.assertEquals(otestLead.IsConverted,true,'Error:Lead Convert failed');  
                    
              else if(otestLead.id == lead4.id)    
                    System.assertEquals(otestLead.IsConverted,false,'Error:Lead Converted without required values');
                    
              else if(otestLead.id == lead5.id)    
                    System.assertEquals(otestLead.IsConverted,false,'Error:Lead Converted without required values'); */                        
            }
            
            test.stopTest();
   
 



}
    }