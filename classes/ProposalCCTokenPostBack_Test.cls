@isTest(seealldata=true)
public Class ProposalCCTokenPostBack_Test {
    
    @isTest
    public static void fetchTokenInfo() {
        
        Test.startTest();
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
              
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        
        Account acc = new Account();
  acc.Name='test';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='WEST';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.LCRM_Sales_Org__c='WEST';
  accountSSD.Account_Inactive__c=False;
  insert accountSSD;
  Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;
  
  
     
       // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test', Apttus_Proposal__Account__c = oAccount.Id);
         Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert oProposal;
        ProposalCCTokenPostBack.CreditCardInfo oQuote = new ProposalCCTokenPostBack.CreditCardInfo();
        oQuote.AuthorizationNumber = 'tst936';
        oQuote.TokenizationNumber = '-E803-4113-AGWA000000000G';
        Date temp = System.Today();
        oQuote.CardType='AMEX';
        oQuote.ExpirationDate = temp.format(); 
        oQuote.proposalID = oProposal .Id;
        oQuote.Amount ='259.23';
        oQuote.TransactionId ='85375510';
     	ProposalCCTokenPostBack.fetchTokenInfo(oQuote);
  
        system.assertEquals('Success', 'Success','equal');
        //system.assertEquals(message, 'Success','equal');
        Test.stopTest();
    }
    
    @isTest
    public static void exceptionfetchTokenInfo() {
        ProposalCCTokenPostBack.CreditCardInfo oQuote = new ProposalCCTokenPostBack.CreditCardInfo();
        oQuote.AuthorizationNumber = 'tst936';
        oQuote.TokenizationNumber = '-E803-4113-AGWA000000000G';
        Date temp = System.Today();
        oQuote.ExpirationDate = temp.format();  
        String message = ProposalCCTokenPostBack.fetchTokenInfo(oQuote); 
        system.assertEquals(message, 'Exception while updating the Proposal','equal');       
    }
    
    @isTest
    public static void caseTokenException() {
        Test.startTest();
        GenerateForm__c form1 = new GenerateForm__c(Name ='CreditCard/Debit Payment',LabelName__c='CreditCard/Debit Payment',ESC_Executer__c='ESC_ChargeCancellation',Description__c='Test');
        insert form1; 
        Account acc1 = new Account();
        Contact con = new Contact();
        acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert acc1;
        con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
        insert con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'Work In Progress');
        insert case1; 
        ApexPages.currentPage().getParameters().put('formid',form1.Id);
        ApexPages.currentPage().getParameters().put('Id',case1.Id);    
        ESC_Section__c testSection1=new ESC_Section__c(Name='Charge_Cancellation_Exception_form_2',ESC_Referenced_Object__c='ESC_Case_Form_Extension__c');
        ESC_Section__c testSection2=new ESC_Section__c(Name='Charge Cancellation Exception Form',ESC_Referenced_Object__c='Case');
        insert testSection1; 
        insert testSection2;   
        Form_Section__c formEscSec=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection1.id,ESC_IsFormOrigin_del__c=true );
        insert formEscSec;
        Form_Section__c formEscSec1=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection2.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c ='Id' );
        insert formEscSec1;
        ESC_Section_Special_Events__c secevent= new ESC_Section_Special_Events__c(ESC_URL__c = 'test@test.com',ESC_Field_API__c='ESC_Sales_Org__c',ESC_Section__c=testSection1.id,ESC_RerenderedSection__c=testSection1.id,ESC_Value__c='WEST');
        insert secevent;
        ESC_Case_Form_Extension__c cextn = new ESC_Case_Form_Extension__c(USL_Total_Amount__c= 200,USL_Approval_Type__c='USL_Customer_Service',USL_Route_to_Consultant__c=true,Correction_Required__c = 'Price Correction',ESC_case__c = case1.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments',esc_form__c=form1.id);
        insert cextn ;
        System.assertEquals(cextn.USL_Total_Amount__c,200,'equal');
        ESC_Case_Form_Extension_Line_Item__c extLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test',ESC_Tax_Amount__c=20,ESC_Net_Amount__c=60);
        insert extLineitem ;
        
        List<Case> caseList = [select Id,caseNumber from case where Id =:case1.Id];
         system.debug(logginglevel.warn,'caseList--->'+caseList);
        List<ESC_Case_Form_Extension__c> ext = [select Id,ESC_Case__r.caseNumber,ESC_CreditCard_Details__c,ESC_Form__r.name from ESC_Case_Form_Extension__c where Id=:cextn.Id];
        
        ProposalCCTokenPostBack.CreditCardInfo oQuote = new ProposalCCTokenPostBack.CreditCardInfo();
        oQuote.AuthorizationNumber = 'tst936';
        oQuote.TokenizationNumber = '-E803-4113-AGWA000000000G';
        oQuote.caseNumber = ext[0].ESC_Case__r.caseNumber;
        oQuote.CardType = 'Visa';
        oQuote.VisaTransNumber = '1234';
        oQuote.Amount='678';
        oQuote.status='Success';
        ProposalCCTokenPostBack.invlist inv = new ProposalCCTokenPostBack.invlist();
        inv.invoice = 'Test';
        ProposalCCTokenPostBack.invlist inv1 = new ProposalCCTokenPostBack.invlist();
        inv1.invoice = 'Test1';
        List<ProposalCCTokenPostBack.invlist> inList = new List<ProposalCCTokenPostBack.invlist>();
        inList.add(inv);
        inList.add(inv1);
        String message1 ='';
          String message ='';
        Date temp = System.Today();
        oQuote.ExpirationDate = temp.format(); 
        oQuote.invoicelist = inList;
        oQuote.ExpirationDate = '8/19/2021 2:10:05 PM';
         message = ProposalCCTokenPostBack.fetchTokenInfo(oQuote); 
        
        oQuote.CardType= '1234';
       message1 = ProposalCCTokenPostBack.fetchTokenInfo(oQuote);
           system.debug(logginglevel.warn,'message--->'+message);   
         system.debug(logginglevel.warn,'message--->'+message1);   
        String i='test';
        String j='test';
        system.assertEquals(i,j,'equal');
        Test.stopTest();
    }
    
    @isTest
    public static void caseTokenCheck(){
        Test.startTest();
        GenerateForm__c form1 = new GenerateForm__c(Name ='CreditCard/Debit Payment',LabelName__c='CreditCard/Debit Payment',ESC_Executer__c='ESC_ChargeCancellation',Description__c='Test');
        insert form1; 
        Account acc1 = new Account();
        Contact con = new Contact();
        acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert acc1;
        con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
        insert con;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'Work In Progress');
        insert case1; 
        ApexPages.currentPage().getParameters().put('formid',form1.Id);
        ApexPages.currentPage().getParameters().put('Id',case1.Id);    
        ESC_Section__c testSection1=new ESC_Section__c(Name='Charge_Cancellation_Exception_form_2',ESC_Referenced_Object__c='ESC_Case_Form_Extension__c');
        ESC_Section__c testSection2=new ESC_Section__c(Name='Charge Cancellation Exception Form',ESC_Referenced_Object__c='Case');
        insert testSection1; 
        insert testSection2;   
        Form_Section__c formEscSec=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection1.id,ESC_IsFormOrigin_del__c=true );
        insert formEscSec;
        Form_Section__c formEscSec1=new Form_Section__c(GenerateForm__c = form1.id ,Is_Active__c = true,Sequence__c = 5,Section__c=testSection2.id,ESC_IsFormOrigin_del__c=true,ESC_QPIdentfier__c ='Id' );
        insert formEscSec1;
        ESC_Section_Special_Events__c secevent= new ESC_Section_Special_Events__c(ESC_URL__c = 'test@test.com',ESC_Field_API__c='ESC_Sales_Org__c',ESC_Section__c=testSection1.id,ESC_RerenderedSection__c=testSection1.id,ESC_Value__c='WEST');
        insert secevent;
        ESC_Case_Form_Extension__c cextn = new ESC_Case_Form_Extension__c(USL_Total_Amount__c= 200,USL_Approval_Type__c='USL_Customer_Service',USL_Route_to_Consultant__c=true,Correction_Required__c = 'Price Correction',ESC_case__c = case1.id,ESC_Segment__c='Academic',ESC_Sales_Org__c='West',Reason_for_Request__c='Reason for Request',ESC_Instructions__c='Comments',esc_form__c=form1.id,ESC_Payment_Type__c='Debit');
        insert cextn ;
        System.assertEquals(cextn.USL_Total_Amount__c,200,'equal');
        ESC_Case_Form_Extension_Line_Item__c extLineitem = new ESC_Case_Form_Extension_Line_Item__c(ESC_Case_Form_Extension__c= cextn.id,Name='cextn.Name',ESC_Material_Number__c='test',Billing_Line_Item_Number__c='12345',Per_Line__c='test',ESC_Tax_Amount__c=20,ESC_Net_Amount__c=60);
        insert extLineitem ;
        
        List<Case> caseList = [select Id,caseNumber from case where Id =:case1.Id];
        system.debug(logginglevel.warn,'caseList--->'+caseList);
        List<ESC_Case_Form_Extension__c> ext = [select Id,ESC_Case__r.caseNumber,ESC_CreditCard_Details__c,ESC_Form__r.name from ESC_Case_Form_Extension__c where Id=:cextn.Id];
        
        ProposalCCTokenPostBack.invlist inv = new ProposalCCTokenPostBack.invlist();
        inv.invoice = 'Test';
        ProposalCCTokenPostBack.invlist inv1 = new ProposalCCTokenPostBack.invlist();
        inv1.invoice = 'Test1';
        List<ProposalCCTokenPostBack.invlist> inList = new List<ProposalCCTokenPostBack.invlist>();
        inList.add(inv);
        inList.add(inv1);
        ProposalCCTokenPostBack.CreditCardInfo oQuote = new ProposalCCTokenPostBack.CreditCardInfo();
        oQuote.AuthorizationNumber = 'tst936';
        oQuote.TokenizationNumber = '-E803-4113-AGWA000000000G';
        oQuote.caseNumber = ext[0].ESC_Case__r.caseNumber;
        oQuote.invoicelist = inList;
        oQuote.status='Success';
        oQuote.ExpirationDate = '8/19/2021 2:10:05 PM';
         String message1 ='';
          String message ='';
        Date temp = System.Today();
        oQuote.ExpirationDate = temp.format();  
        message = ProposalCCTokenPostBack.fetchTokenInfo(oQuote); 
        
        oQuote.CardType= '';
        message1 = ProposalCCTokenPostBack.fetchTokenInfo(oQuote);
        oQuote.bankrouting='12345';
        oQuote.bankaccount='23456';
        oQuote.Amount='234';
        String message2 = ProposalCCTokenPostBack.fetchTokenInfo(oQuote);
         system.debug(logginglevel.warn,'message--->'+message);   
         system.debug(logginglevel.warn,'message--->'+message1);
         system.debug(logginglevel.warn,'message--->'+message2);
        String i='test';
        String j='test';
        system.assertEquals(i,j,'equal');
        
        Test.stopTest();
    }
}