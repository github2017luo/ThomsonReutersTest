/********************************************************************
* Developed for SFD - 391 bug. 
* This code tests submits Quote for an approval. Only used by Portal Users. 
* Developed by Daniel Tefera March-2016.
*********************************************************************/

@istest(seeAllData=true)
public class SubmitQuote_Test 
{
   public static testmethod void submitQuoteForApproval_Test()
    {
        Date startDate = date.newInstance(2015, 11, 21);
        Date endDate = date.newInstance(2019, 11, 21);
        
        //User portalUser = [select id from User where id =: '00529000000c415'];
        Profile portal_profile = [SELECT Id FROM Profile WHERE Name='Partner Portal User'];
        Profile latam_profile = [SELECT Id FROM Profile WHERE Name='LatAm User'];  
        Profile admin_profile = [SELECT Id FROM Profile WHERE Name='System Administrator'];   //Added     
        Id userRoleId = [select id from UserRole WHERE Name='Thomson Reuters LATAM'].id;//Added  
        
        //Added to avoid the setupa nd non setup object error to add system.runAs
        User adminUser = new User(Alias = 'adm', Email='s2eadminuser@testorg.com',  
        EmailEncodingKey='UTF-8', LastName='admin', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = admin_profile.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='s2eadminuser@testorg.com');
        insert adminUser;//Ends
        
        User latamUser = new User(Alias = 'standt', Email='s2elatamstandarduser@testorg.com',  
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = latam_profile.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='s2elatamstandarduser@testorg.com',userRoleId=userRoleId );
       
        insert latamUser;
        
        //Moved here for global declartion.
        Account TestAccount;  
        Contact portalContact;//Ends
        System.debug('username '+latamUser.UserName + ', ' + latamUser.id);
        
        //Moved here for global declartion.
        Quote Q1 = New Quote ();
        Quote Q2 = New Quote ();
        User portalUser;//Ends
        
        system.runAs(adminUser){//Added
        
            TestAccount = UnitTest.getAccountInstance();
            TestAccount.Customer_Group__c ='';
            TestAccount.OwnerId = latamUser.Id;
            Insert TestAccount;
            
            portalContact = new Contact(FirstName = 'Test', LastName = 'Guy', AccountId = TestAccount.id);
            Insert portalContact;
        
            portalUser = new User(Alias = 'portal', Email='s2elatamportaluser@testorg.com',  
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = portal_profile.Id, ContactId = portalContact.id,
            TimeZoneSidKey='America/Los_Angeles', UserName='s2elatamportaluser@testorg.com', ManagerId = latamUser.id);
            
            insert portalUser;
            
            
            System.debug('portal username '+portalUser.UserName + ', ' + portalUser.id);
            
             
            User portUser = [SELECT Id FROM User WHERE UserName = 's2elatamportaluser@testorg.com'];
            
            Reservation__c reservation = new Reservation__c(Partner_Portal_User__c = portUser.id,Partner_Account__c = TestAccount.id, Account__c = TestAccount.id,
            OwnerId= portalUser.id, Start_Date__c = startDate,End_Date__c = endDate,Business_Unit__c = 'MASTERSAF', Active__c = true, Approval_Status__c ='Approved'); 
            
            
            Product2 p = new product2(name='unittest');
            insert p;
            
            // Commented to avoid hard coding and error durig deployment
            //Pricebook2 custPb = [select Id from Pricebook2 where id =: '01sa0000000Vdro'];
            
            //Added
            Pricebook2 custPb = new Pricebook2(Name='Custom Pricebook', isActive=true);
            insert custPb ;//ends
            
            Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
            
            PricebookEntry stdpbe = new PricebookEntry(pricebook2id = stdPb.id, product2id = p.id,unitprice=1.0,isActive=true, UseStandardPrice = false);
            insert stdpbe;
            
            PricebookEntry custpbe = new PricebookEntry(pricebook2id = custPb.id, product2id = p.id,unitprice=1.0,isActive=true, UseStandardPrice = false);
            insert custpbe;
            
    
            Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
            opp1.StageName = '75%';
            opp1.OwnerId = portUser.id;
            opp1.LATAM_Business_Unit__c = 'Mastersaf';
            opp1.Sales_Org__c = 'TSL';
            opp1.Was_There_a_Competitor__c = 'No';
            opp1.Competitor_Name__c = 'BloomBerg';
            opp1.Reason__c = 'Test';
            opp1.Name__c = 'Test';
            opp1.pricebook2Id = custPb.id;
            opp1.Expiration_Date__c = System.today().adddays(1);
            opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
            opp1.Renewal_Flag__c = False;
            try{
            insert opp1;
            }
            catch(exception e){
            } 

            System.debug('Opp Stage ' + opp1.StageName);
            System.debug('OwnerId ' + opp1.OwnerId);
            System.debug('bus unit '+ opp1.LATAM_Business_Unit__c);
            System.debug('Sales org '+ opp1.Sales_Org__c);
            System.debug('Ren Flag' + opp1.Renewal_Flag__c);
            System.debug('accountId '+ opp1.AccountId );   
            System.debug('Sub_Category__c '+ opp1.Sub_Category__c);

            
            Q1.OpportunityId = opp1.id;
            Q1.Name = 'Test Quote';
            Q1.Approval_Status__c = '';
            Q1.Primary_Quote__c = true;
            Q1.Status = 'In Review';
            Q1.pricebook2Id = custPb.id;
            Q1.RecordTypeId = RecordtypeIds__c.getValues('LATAM New Quote').recTypeId__c;
            Q1.Primary_Quote__c = True;
            Q1.Promotion__c = False;
            Q1.Pricing_Approval_Required__c  = True;
            Q1.Pricing_Approval_Complete__c = False;
            
            Q1.Reservation_Manager__c = latamUser.Id; // Added by Shovon for SFD-497
            Q1.Manager_of_Reservation_Manager__c = latamUser.Id; // Added by Shovon for SFD-497
            Insert Q1;
            
            QuoteLineItem qli = new QuoteLineItem(PricebookEntryId=custpbe.Id,QuoteId=Q1.Id,Quantity=10,UnitPrice=100, Discount = 40); 
            insert qli;
            
            Q2.OpportunityId = opp1.id;
            Q2.Name = 'Test Quote';
            Q2.Approval_Status__c = '';
            Q2.Primary_Quote__c = true;
            Q2.Status = 'In Review';
            Q2.pricebook2Id = custPb.id;
            Q2.RecordTypeId = RecordtypeIds__c.getValues('LATAM New Quote').recTypeId__c;
            Q2.Primary_Quote__c = True;
            Q2.Promotion__c = False;
            //Q2.Pricing_Approval_Required__c  = True;
            Q2.Pricing_Approval_Complete__c = False;
            Insert Q2;
        } //Added   
        Test.StartTest();
        System.runAs(portalUser) 
        {    
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            System.debug('Current User: ' + UserInfo.getUserName());

            String result = SubmitQuote.submitQuoteForApproval(Q1.id);
            
          //  System.assertEquals(result, 'success');
           
            String result2 = SubmitQuote.submitQuoteForApproval(Q2.id);
           // System.assertEquals(result2, System.label.Portal_Quote_Price_Approval_Cannot_be_found);
        }
        Test.StopTest();
    }
}