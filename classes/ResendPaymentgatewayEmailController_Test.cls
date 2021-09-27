@isTest
public Class ResendPaymentgatewayEmailController_Test {
    public static testMethod void AutoPaymentEmail() {
        Profile pro = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        User usr = new User( Alias = 'standt', Email='standarduser@tt.com',  
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',  
        LocaleSidKey='en_US', ProfileId = pro.Id,  
        TimeZoneSidKey='America/Los_Angeles', UserName='resendpayment@tt.com'); 
        System.runAs(usr) { 
       
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
           
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist;
           
        Account a = APTS_TestDataFactory.createAccount('Pathra Test');
        a.SAPAccountNumber__c ='11334455';
        a.BillingCountry ='US';
        a.BillingState='IL';
        a.BillingPostalCode = '60603-3801';
        a.Tax_Number__c= '12345';
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Source_System_Account_Number__c='12365478';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;
        
                 
        Contact oContact = new Contact(FirstName='S',LastName='Pathra',Account=a,Accountid=a.Id);
        insert oContact;
            
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
          
            Apttus_Proposal__Proposal__c oProposal =APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
            oProposal.Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test';
            oProposal.Apttus_Proposal__Account__c=a.Id;
            oProposal.APTS_SSD_Sold_To__c=accountSSD.id;
            oProposal.APTS_PaymentGateway_URL__c='ww.tcs.com';
            oProposal.OwnerId=usr.Id;
            oProposal.APTS_Payment_Option__c = 'Credit Card';
            oProposal.APTS_Order_Confirmation_Contact__c=oContact.Id;
            insert oProposal; 
            
            Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=oProposal.Id);
            order.PaymentUrl__c='test_url';
            order.OwnerId=usr.Id;
            order.AutopaymentEmailButton__c=false;
            //order.Apttus_QPConfig__ProposalId__c=oProposal.Id;
            insert order;
            
            system.debug('Order created--------'+[select id,name,AutopaymentEmailButton__c,PaymentUrl__c,Apttus_QPConfig__ProposalId__c from Apttus_Config2__Order__c where Apttus_QPConfig__ProposalId__c =:oProposal.Id]);
        
            oProposal = [SELECT APTS_Order_Confirmation_Contact_Name__c,Owner.Name  FROM Apttus_Proposal__Proposal__c where id=:oProposal.Id];
            oProposal.APTS_Payment_Option__c = 'Auto EFT/Auto Charge';
            //oProposal.APTS_Order_Confirmation_Contact__c=oContact.Id;
            update oProposal;
            Apttus_Proposal__Proposal__c oProposalafter = [SELECT id,Owner.Name,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact__c FROM Apttus_Proposal__Proposal__c where id=:oProposal.Id];
            system.debug('oProposal'+oProposalafter.Owner.Name);
            system.debug('oProposal'+oProposalafter.APTS_Order_Confirmation_Contact_Name__c);
            PageReference pref=Page.AutopaymentButton;
            pref.getParameters().put('id',oProposal.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(oProposal);
            ResendPaymentgatewayEmailController con = new ResendPaymentgatewayEmailController(sc);
            con.AutoPaymentEmail();
            //ResendPaymentgatewayEmailController Resend = new ResendPaymentgatewayEmailController();
            //Resend.  
        }
    }
     public static testMethod void CreditIncreaseEmail() {
        Profile pro = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        User usr = new User( Alias = 'standt', Email='standarduser@tt.com',  
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',  
        LocaleSidKey='en_US', ProfileId = pro.Id,  
        TimeZoneSidKey='America/Los_Angeles', UserName='resendpayment@tt.com'); 
        System.runAs(usr) { 
       
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='True')};
        insert keyvaluestore;
           
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        insert recordlist; 
          
        Account a = APTS_TestDataFactory.createAccount('Pathra Test');
        a.SAPAccountNumber__c ='11334455';
        a.BillingCountry ='US';
        a.BillingState='IL';
        a.BillingPostalCode = '60603-3801';
        a.Tax_Number__c= '12345';
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Account_Number__c='12365478';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        insert oppty;
        
                  
        Contact oContact = new Contact(FirstName='S',LastName='Pathra',Account=a,Accountid=a.Id);
        insert oContact;
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
            
            Apttus_Proposal__Proposal__c oProposal =APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
            oProposal.Apttus_Proposal__Proposal_Name__c ='Pathra Proposal Test';
            oProposal.APTS_PaymentGateway_URL__c='';
            oProposal.OwnerId=usr.Id;
            //oProposal.OwnerId=UserInfo.getUserId();
            oProposal.APTS_Payment_Option__c = 'Credit Card';
            oProposal.Apttus_Proposal__Account__c=a.Id;
            oProposal.APTS_SSD_Sold_To__c=accountSSD.id;
            oProposal.APTS_PaymentGateway_URL__c='ww.tcs.com';
            oProposal.APTS_Order_Confirmation_Contact__c=oContact.Id;
            oProposal.APTS_Send_NACI_Form__c=true;
            oProposal.Apttus_Proposal__Approval_Stage__c='Accepted';
            insert oProposal; 
            
            Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Apttus_QPConfig__ProposalId__c=oProposal.Id);
            order.PaymentUrl__c='';
            order.OwnerId=usr.Id;
            order.AutopaymentEmailButton__c=false;
            order.Apttus_QPConfig__ProposalId__c=oProposal.Id;
            insert order;
        
            
            Apttus_Proposal__Proposal__c oProposalafter = [SELECT id,Owner.Name,APTS_Order_Confirmation_Contact_Name__c,APTS_Order_Confirmation_Contact__c FROM Apttus_Proposal__Proposal__c where id=:oProposal.Id];
            system.debug('oProposal'+oProposalafter.Owner.Name);
            system.debug('oProposal'+oProposalafter.APTS_Order_Confirmation_Contact_Name__c);
            PageReference pref=Page.AutopaymentButton;
            pref.getParameters().put('id',oProposal.Id);
            Test.setCurrentPage(pref);
            ApexPages.standardController sc = new ApexPages.standardController(oProposal);
            ResendPaymentgatewayEmailController con = new ResendPaymentgatewayEmailController(sc);
            con.CreditIncreaseEmail();
        }
    }
}