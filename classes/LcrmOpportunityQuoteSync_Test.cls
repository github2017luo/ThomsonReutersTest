@isTest
public class LcrmOpportunityQuoteSync_Test {
    
    
    @testSetup static void setup() {
                
        TRWaySales__Exit_Criteria_and_I_Ack_Config__c panaroma= new TRWaySales__Exit_Criteria_and_I_Ack_Config__c();
        panaroma.Name='Criteria and I Ack Settings';
        panaroma.TRWaySales__Display_Exit_Criteria_for_Non_Sequential__c=true;
        panaroma.TRWaySales__I_acknowledge_exception__c='TR Legal Sales Rep';
        panaroma.TRWaySales__I_acknowledge_required__c=true;
        insert panaroma;
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'Payment AutoCharge',
        Service_Unavailable_Message__c = 'Auto Payment Service is Currently unavailable',        
        Endpoint__c = 'https://stg.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentAutoCharge');
        insert oWebServiceSettings ;
        
        WebServiceSettings__c o1WebServiceSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'PaymentCreditIncrease',
        Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable',        
        Endpoint__c = 'https://qa.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease');
        insert o1WebServiceSettings ;
        
        KeyValueListStore__c kv1= new KeyValueListStore__c();
        kv1.Name='ANZUsersProfileId';
        kv1.TextValue__c='00e30000001ZUki';
        insert kv1;
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        insert keyval;
        
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = '012a0000001ZJxn';        
        insert recT;
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = '012a0000001ZJxn';
        insert recT1;
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = '012M0000000509c';
        insert orecordType5;
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = '012M0000000509X';
        insert orecordType6;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = '00ea00000024JwaAAE';
        INSERT objPro;
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = '00ea00000024JzKAAU';
        INSERT objPro1;
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = '00e30000001gFezAAE';
        INSERT objPro2;
        
        
        //insert account 
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.Is_GLI__c = true;
        insert testAcc;
        //insert contact 
        Contact objCon1 = UnitTest.getContactInstance(testAcc.Id);
        insert objCon1;
        
        
        //insert account ssd
        List<Source_System_Detail__c> listOfSSD = new List<Source_System_Detail__c>();
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        
        Source_System_Detail__c accountSSD2= new Source_System_Detail__c();
        accountSSD2.RecordtypeId=ssdRecorType;
        accountSSD2.Name='ABCTest23232';
        accountSSD2.Source_System_Name__c='ABCTest23232';
        accountSSD2.Account_Name__c=testAcc.ID;
        accountSSD2.APTS_Customer_Category__c='1';
        accountSSD2.LCRM_Customer_Group__c='Academic';
        
        accountSSD2.Account_Inactive__c=false;
        accountSSD2.LCRM_Sales_Org__c='WEST';
        accountSSD2.APTS_Has_Online_Assets__c=true;        
        listOfSSD.add(accountSSD2);
        
        
        
        Source_System_Detail__c accountSSD3= new Source_System_Detail__c();
        accountSSD3.RecordtypeId=ssdRecorType;
        accountSSD3.Name='ABCTestNew';
        accountSSD3.Source_System_Name__c='ABCTestNew';
        accountSSD3.Account_Name__c=testAcc.ID;
        accountSSD3.APTS_Customer_Category__c='1';
        accountSSD3.LCRM_Customer_Group__c='Academic';
        
        accountSSD3.Account_Inactive__c=false;
        accountSSD3.LCRM_Sales_Org__c='WEST';
        accountSSD3.APTS_Has_Online_Assets__c=true; 
        listOfSSD.add(accountSSD3);
        insert listOfSSD;
        
        
        //insert contact ssd
        List<LCRM_Contact_SSD__c> listOfcSSD = new List<LCRM_Contact_SSD__c>();
        LCRM_Contact_SSD__c cssd1 = new LCRM_Contact_SSD__c();
        cssd1.LCRM_First_Name__c = 'First contact ssd';
        cssd1.LCRM_Contact__c = objCon1.id;
        cssd1.LCRM_Account_SSD__c = listOfSSD[0].id;
        
        LCRM_Contact_SSD__c cssd2 = new LCRM_Contact_SSD__c();
        cssd2.LCRM_First_Name__c = 'First contact ssd';
        cssd2.LCRM_Contact__c = objCon1.id;
        cssd2.LCRM_Account_SSD__c = listOfSSD[0].id;
        
        listOfcSSD.add(cssd1);
        listOfcSSD.add(cssd2);
        
        insert listOfcSSD;
        
        //insert opportunity
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp1.Name = 'Test OpportunityQuoteSync 786';
        testOpp1.Is_GLI__c = true;
        testOpp1.Source_System_Detail__c=listOfSSD[0].Id;
        testOpp1.Bill_To_Account_SSD__c = listOfSSD[0].Id;
        insert testOpp1;
        
        //insert opportunity
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        testOpp2.Is_GLI__c = true;
        testOpp2.Source_System_Detail__c=listOfSSD[0].Id;
        testOpp1.Bill_To_Account_SSD__c = listOfSSD[0].Id;       
        insert testOpp2;
        
        //Insert Pricelist
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        //insert quote/proposal
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> listQuotes= new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,
                                                                          Apttus_Proposal__Primary__c =true, 
                                                                          Apttus_Proposal__Proposal_Name__c='TST-10', 
                                                                          Apttus_Proposal__Opportunity__c=testOpp1.id, 
                                                                          Apttus_Proposal__Account__c=testAcc.id,
                                                                          Apttus_Proposal__Approval_Stage__c='Draft');
        
        Apttus_Proposal__Proposal__c p2 = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,
                                                                           Apttus_Proposal__Primary__c =true, 
                                                                           Apttus_Proposal__Proposal_Name__c='TST-11', 
                                                                           Apttus_Proposal__Opportunity__c=testOpp2.id, 
                                                                           Apttus_Proposal__Account__c=testAcc.id,
                                                                           Apttus_Proposal__Approval_Stage__c='Draft');
        
        listQuotes.add(p);
        listQuotes.add(p2);
        
        insert listQuotes;
    }
    
    @istest static void checkOpportunityQuoteSync() {
                test.startTest();  
        List<lcrm_opportunity_quote_sync__mdt> testList = [Select Object_name__c,                                                          
                                                           Key_field__c,
                                                           Target_field__c,
                                                           Sync_active__c FROM lcrm_opportunity_quote_sync__mdt WHERE Object_name__c = 'Opportunity' AND Sync_active__c = true];
        
        opportunity opp = [Select id,Bill_To_Account_SSD__c,Bill_To_Contact_SSD__c,Payer_Account_SSD__c,Ship_To_Account_SSD__c,Ship_To_Contact__c 
                           FROM Opportunity WHERE Name = 'Test OpportunityQuoteSync 786'];
        Source_System_Detail__c ssd = [Select id,name FROM Source_System_Detail__c WHERE Name = 'ABCTestNew' limit 1];
        LCRM_Contact_SSD__c cssd = [Select id,name FROM LCRM_Contact_SSD__c WHERE LCRM_First_Name__c = 'First contact ssd' limit 1];
        
      
        List<opportunity> oppList = new   List<opportunity>();
        opp.Bill_To_Account_SSD__c = ssd.id;       
        oppList.add(opp);  
        update oppList;
        test.stopTest();
        
        
        
    }
    
    @istest static void checkQuoteOpportunitySync(){
              
        Test.startTest();
        Source_System_Detail__c ASS = [Select ID,Name from Source_System_Detail__c where Name='ABCTest23232' limit 1];
        LCRM_Contact_SSD__c CSS= [select ID, Name,LCRM_First_Name__c from LCRM_Contact_SSD__c where LCRM_First_Name__c='First contact ssd' limit 1];
       // opportunity opp = [Select Id,Account.Id,Name,Source_System_Detail__c,Bill_To_Contact_SSD__c FROM Opportunity WHERE Name = 'Test OpportunityQuoteSync 786'];
        List<String> records= new List<String>{'TST-10','TST-11'};
        List<Apttus_Proposal__Proposal__c> listProposal=[Select ID, Name,Apttus_Proposal__Proposal_Name__c, APTS_Payer__c,APTS_SSD_bill_to__c,APTS_Bill_To_Contact__c,APTS_SSD_ship_to__c,APTS_Ship_To_Contact__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c IN: records];
        for(Apttus_Proposal__Proposal__c p:listProposal){
            p.APTS_Payer__c=ASS.Id;
            p.APTS_SSD_bill_to__c=ASS.Id;
            p.APTS_Bill_To_Contact__c=CSS.Id;
            p.APTS_SSD_ship_to__c=ASS.Id;
            p.APTS_Ship_To_Contact__c=CSS.Id;
        }
        update listProposal;
        Test.stopTest();
    }
    @istest static void checkQuoteOpportunitySync2(){

        Test.startTest();
        opportunity opp = [Select Id,Account.Id,Name,Source_System_Detail__c,Bill_To_Contact_SSD__c FROM Opportunity WHERE Name = 'Test OpportunityQuoteSync 786'];
        
        Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c pro = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId,
                                                                          Apttus_Proposal__Primary__c =true, 
                                                                          Apttus_Proposal__Proposal_Name__c='TST-15', 
                                                                          Apttus_Proposal__Opportunity__c=opp.id, 
                                                                          Apttus_Proposal__Account__c=opp.Account.id,
                                                                          Apttus_Proposal__Approval_Stage__c='Draft');
        
        insert pro;
        Test.stopTest();
           
    }    

    @istest static void flowCoverageTest(){
        //coverage for the flow : LCRM_Create_Task_When_Oppty_is_Closed_Won_Order_Complete
        //coverage for the flow: Post_to_chatter_Opportunity_Team_Member_details
       	Test.startTest();
        Profile adminProfile = [SELECT Id FROM profile WHERE name='System Administrator'];
        User gliUser;
        gliUser = UnitTest.getUserInstance();
        gliUser.Username = 'TestUser1@TR.com';
        gliUser.profileid = adminProfile.Id;
        gliUser.Email='testuser@thomsonreuters.com';
        gliUser.Alias = 'igli';
        gliUser.FirstName='Informatica';
        gliUser.LastName='GLI Integration';
        gliUser.EmailEncodingKey='UTF-8';
        gliUser.LocaleSidKey='en_US';
        gliUser.LanguageLocaleKey='en_US';
        gliUser.TimeZoneSidKey='America/Los_Angeles';
        gliUser.Sub_Bu__c = 'USL';
        
        insert gliUser; 
       
        Opportunity opp=[Select ID, Name,StageName,Is_GLI__c,LCRM_Sub_BU__c,Owner.Id from Opportunity where Name='Test OpportunityQuoteSync 786' limit 1];
	
        //dAA.LTS_Disable_Process_Builders__c =false;
        opp.StageName='Order Complete';
        opp.Reason__c = 'Brand';
        opp.Was_There_a_Competitor__c='No';
        opp.Is_GLI__c=true;
        opp.LCRM_Sub_BU__c='UKI';
        update opp;
        
        OpportunityTeamMember TestMember = new OpportunityTeamMember(OpportunityId=opp.Id,UserId=gliUser.Id, Sales_Percentage__c=10);
      	Insert TestMember;
        Test.stopTest();
        }
}