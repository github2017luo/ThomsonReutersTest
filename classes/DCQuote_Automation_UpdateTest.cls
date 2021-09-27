/* Modifiued By : Harika Sai P 11-Jun-2019*/
/*DLT-16792 Code Scan story  Added Assert statements */
@isTest
public class DCQuote_Automation_UpdateTest {
     @testsetup
    public static void testdata(){
        Test.startTest();
        DCTestData.createData();
        Test.stopTest();
        Opportunity opp = [Select id,sub_Campaign_Code__c,SAP_Account_Number__c,isdigitalSpearhead__c from Opportunity limit 1];
        Account acc = [Select id from Account limit 1];
        Source_System_Detail__c ssd = [select id from Source_System_Detail__c limit 1];
        Contact cont = [select id from Contact limit 1];
        List<Apttus_Proposal__Proposal__c> quoteList = new list<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c q1 = new Apttus_Proposal__Proposal__c();
        q1.Apttus_Proposal__Proposal_Name__c = 'Quote 1';
        q1.Apttus_Proposal__Opportunity__c = opp.Id;
        q1.Apttus_Proposal__Account__c =acc.id;
        q1.APTS_SSD_Sold_To__c = ssd.id;
        q1.APTS_SSD_bill_to__c = ssd.id;
        q1.APTS_SSD_ship_to__c = ssd.id;
        q1.Apttus_QPConfig__BillToAccountId__c = acc.id;
        q1.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        q1.Apttus_Proposal__Approval_Stage__c = 'Presented';
        q1.Digital_Quote_Type__c =  'Straight Renewal'; 
        q1.Digital_Batch_Processed__c = TRUE;
        q1.Apttus_Proposal__Primary__c = True;
        q1.DC_Updated_On_Configurator__c = TRUE;
        q1.Digital_Quote_Automation__c = TRUE;
        q1.Digital_Envelope_Created__c = TRUE;
        q1.APTS_Order_Confirmation_Contact__c = cont.id;
        q1.APTS_Approval_Segment__c = 'Small Law';
        q1.DC_Contract_Not_In_Sync__c = false;
        q1.APTS_Order_Confirmation_Contact_Email__c = 'testfirst.testlast@test.com';
        quoteList.add(q1);
        insert quoteList;
        
        list<Product_Account_Detail__c> prodactdetailList = new list<Product_Account_Detail__c>();
        Product_Account_Detail__c dsCurrent = new Product_Account_Detail__c();
        dsCurrent.Account__c = DCTestData.accountId;
        dsCurrent.AccountSSD__c = DCTestData.accssdid;
        dsCurrent.Current_Subscription__c = '42009617';
        dsCurrent.Actual_New_Subscription__c ='';
        dsCurrent.Actual_New_Service__c ='';
        dsCurrent.Premium_New_Service__c = '';
        dsCurrent.Premium_New_Subscription__c = '';     
        dsCurrent.Offer_Price__c = 5;
        dsCurrent.Quantity__c = 1;
        dsCurrent.sub_Campaign_Code__c = '3O-NoMktg001-Apr2019';
        dsCurrent.Digital_Firm__c = 'Small Law';
        dsCurrent.Type__c ='Straight';
        dsCurrent.Hard_Bounce__c = True;
        dsCurrent.SAP_Contact_Id__c = '12345';
        dsCurrent.ZP_Cust_Number__c = '1004284494';
        dsCurrent.Campaign_Code__c = '00237KI';
        dsCurrent.Renewal_Date__c = System.Today().addDays(integer.valueof(label.Digital_Max_Asset_Days.trim()));
       
        prodactdetailList.add(dsCurrent);
        insert prodactdetailList;
                
    }
    
     public static testmethod void createQuoteAutomationCycleTest(){
        Product_Account_Detail__c pdcsub = [Select id,sub_Campaign_Code__c from Product_Account_Detail__c limit 1];
        Set<String> subcampset = new Set<String>();
        String subcamp = (pdcsub.sub_Campaign_Code__c).right(7);
        subcampset.add(subcamp.toUpperCase());
         DCQuote_Automation_Update.AutorecordUpdateacctbased(subcampset); 
        
         Quote_Automation_Cycle__c q= [SELECT id,Job_status__c FROM Quote_Automation_Cycle__c LIMIT 1];   
         if(q!= null){
             system.assertEquals(q.Job_status__c,'Running');
         }
      }
      
    public static testmethod void AutomationrecordUpdateTest1(){
        Product_Account_Detail__c pdcsub = [Select id,sub_Campaign_Code__c from Product_Account_Detail__c limit 1];
        Set<String> subcampset = new Set<String>();
        String subcamp = (pdcsub.sub_Campaign_Code__c).right(7);
        subcampset.add(subcamp.toUpperCase());
   
        list<Quote_Automation_Cycle__c> quotcycl = new list<Quote_Automation_Cycle__c>();
        Quote_Automation_Cycle__c qac = new Quote_Automation_Cycle__c();
        list<String> subcamplst = new list<String>(subcampset);
        qac.Batch_ID__c = 123;
        qac.Cohrot__c = subcamplst[0];
        qac.Job_Name__c = 'Quote Process';
        qac.Job_Description__c = 'SFDC Quote Generation';
        qac.Market_Segment__c = 'SLF';
        qac.Job_status__c = 'Running';
        qac.Start_Date__c = System.now();
        qac.Cycle_Status__c = 'Running';
        quotcycl.add(qac);
         insert quotcycl;
         DCQuote_Automation_Update.AutorecordUpdateacctbased(subcampset); 
         Quote_Automation_Cycle__c q= [SELECT id,Job_status__c FROM Quote_Automation_Cycle__c LIMIT 1];
         if(q!= null){
             system.assertEquals(q.Job_status__c,'Completed');
         }
         
    }
 
    public static testmethod void ExceptionTest(){
        Product_Account_Detail__c pdcsub = [Select id,sub_Campaign_Code__c from Product_Account_Detail__c limit 1];
        Set<String> subcampset = new Set<String>();
        String subcamp = '456879fdfs';
        subcampset.add(subcamp.toUpperCase());
        DCQuote_Automation_Update.AutorecordUpdateacctbased(subcampset);
        Quote_Automation_Cycle__c q= [SELECT id,Job_status__c FROM Quote_Automation_Cycle__c LIMIT 1];
        
        
        if(q!= null){
             system.assertEquals(q.Job_status__c,'Running');
         }
        
    }
}