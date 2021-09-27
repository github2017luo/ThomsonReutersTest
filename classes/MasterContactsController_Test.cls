@isTest
public class MasterContactsController_Test {

     public static testMethod void processController1() {
     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
         Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com',Sub_Bu__c = 'USL',Default_Catalog__c= 'USL');        
        insert u1;
        System.runAs(u1){
        Account a = APTS_TestDataFactory.createAccount('Sree Test');
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
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
     
       
       
        
        Contact oContact = UnitTest.getContactInstance(a.Id);
        oContact.SAP_Role__c = 'TECHNICAL CONTACT;CLEAR PRIMARY CONT;EML PSWD CONTACT;PATRON ACC TECH CONT;ADMINISTRATOR;SRR MEDIA CONTACT;PT INTER MEDIA CONT;PT INTRA MEDIA CONT;PT SENTRY MEDIA CONT;COMPLIANCE LEARNING';
        oContact.Email='unitTest@tcs.com';
        oContact.Phone='8764556756';
        insert oContact;
        
        List <LCRM_Contact_SSD__c> contactssdList = new List <LCRM_Contact_SSD__c>();
         
         
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c(LCRM_Contact__c=oContact.Id, LCRM_SAP_Role__c=oContact.SAP_Role__c, LCRM_Source_Contact_Id__c='3453463635635');
        contactssdList.add(conSSD);
         
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        oProposal.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        oProposal.Apttus_Proposal__Account__c=a.Id;
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.APTS_Order_Confirmation_Contact__r=oContact;
        oProposal.Digital_Quote_Type__c='Manual';
        oProposal.recordtypeId=propRecorType;
        insert oProposal;
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '06', Subscription_Number__c = '41409998');
        Product2 oProduct1 = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978967', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '05', Subscription_Number__c = '41409997', APTS_Media_Lower_Level_Code__c='NZ');
        Product2 oProduct2 = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978968', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '13', Subscription_Number__c = '41409996', APTS_Media_Lower_Level_Code__c='NT');
        Product2 oProduct3 = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978969', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '13', Subscription_Number__c = '41409996', APTS_Media_Lower_Level_Code__c='NX');
        Product2 oProduct4 = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978977', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '13', Subscription_Number__c = '41409996', APTS_Media_Lower_Level_Code__c='NW');
        Product2 oProduct5 = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978978', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '05', Subscription_Number__c = '41409996', APTS_Media_Lower_Level_Code__c='E9');
        insert new List<Product2>{oProductB, oProductP, oProduct1, oProduct2, oProduct3, oProduct4, oProduct5};      
         Test.startTest(); 
         List<Customer_Master_Contacts__c> mstrConList = new List<Customer_Master_Contacts__c>();        
        createMasterContacts(oProposal.Id, oContact.Id, conSSD.Id, mstrConList);
        insert mstrConList;
        insert contactssdList;
         
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = a.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        insert oc1; 
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProduct1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li3);
        Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProduct2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li4);
        Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProduct3.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li5);
        Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProduct4.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li6);
        Apttus_Proposal__Proposal_Line_Item__c li7 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProduct5.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li7);
        insert listLineItems; 
        
        
        
        PageReference pageRef = Page.MasterContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        MasterContactsController contr= new MasterContactsController(sc);
       
        for(MasterContactsController.MCWrapper mw : contr.patronConList) {
            mw.isSelected = False;
            break;
        }
        /*for(MasterContactsControllerNew.MCWrapper mw : contr.patronConList) {
            mw.isSelected = True;
            break;
        } */
        contr.save();
        contr.cancel();
        contr.mcListHelper(conSSD.LCRM_SAP_Role__c.split(';'), conSSD);        
        
        system.assertEquals(a.Name, 'Sree Test');
        }
        Test.stopTest();
        }

        public static void createMasterContacts(Id oProposalId, Id oContactId, Id conSSDId, List<Customer_Master_Contacts__c> mstrConList) {
            
            Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Material__c ='41727130,', Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc1);
            Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Material__c = '1234568978966,', Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'PATRON ACC TECH CONT', From_IP_Address__c = '5.32.60.224', To_IP_Address__c = '5.32.60.224', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc2);
            Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc3); 
            Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', From_IP_Address__c = '5.32.60.224', To_IP_Address__c = '5.32.60.224', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc4);
            Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc5);
            Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc6);
            Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc7);
            Customer_Master_Contacts__c mc8 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', From_IP_Address1__c = '5.32.60.224', To_IP_Address1__c = '5.32.60.224', First_Name__c = 'Sreenu1', Last_Name__c = 'Daram1', Email_Address__c= 'sreenu.d1@tcs.com');
            mstrConList.add(mc8);
            Customer_Master_Contacts__c mc9 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', From_IP_Address2__c = '5.32.60.224', To_IP_Address2__c = '5.32.60.224', First_Name__c = 'Sreenu2', Last_Name__c = 'Daram2', Email_Address__c= 'sreenu.d2@tcs.com');
            mstrConList.add(mc9);
            Customer_Master_Contacts__c mc10 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Material__c = '1234568978966,', Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'PATRON ACC TECH CONT', From_IP_Address1__c = '5.32.60.224', To_IP_Address1__c = '5.32.60.224', First_Name__c = 'Sreenu3', Last_Name__c = 'Daram3', Email_Address__c= 'sreenu.d3@tcs.com');
            mstrConList.add(mc10);
            Customer_Master_Contacts__c mc11 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Material__c = '1234568978966,', Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'PATRON ACC TECH CONT', From_IP_Address2__c = '5.32.60.224', To_IP_Address2__c = '5.32.60.224', First_Name__c = 'Sreenu4', Last_Name__c = 'Daram4', Email_Address__c= 'sreenu.d4@tcs.com');
            mstrConList.add(mc11);
            Customer_Master_Contacts__c mc12 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'SRR MEDIA CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc12);
            Customer_Master_Contacts__c mc13 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'PT INTER MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc13);
            Customer_Master_Contacts__c mc14 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'PT INTRA MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc14);
            Customer_Master_Contacts__c mc15 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'PT SENTRY MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc15);
            Customer_Master_Contacts__c mc16 = new Customer_Master_Contacts__c(Quote__c = oProposalId, Contact__c = oContactId, Contact_SDD__c = conSSDId, Customer_Type_Description__c = 'COMPLIANCE LEARNING', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
            mstrConList.add(mc16);
            
        }       
        
        public static testMethod void processController2() {
     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
       List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
           List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
     
        Account a = APTS_TestDataFactory.createAccount('Sree Test');
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
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
     
       
       
        
        Contact oContact = UnitTest.getContactInstance(a.Id);
        oContact.SAP_Role__c = 'TECHNICAL CONTACT;CLEAR PRIMARY CONT;EML PSWD CONTACT;PATRON ACC TECH CONT;ADMINISTRATOR';
        oContact.Email='unitTest@tcs.com';
        oContact.Phone='8764556756';
        insert oContact;
        
        List <LCRM_Contact_SSD__c> contactssdList = new List <LCRM_Contact_SSD__c>();
         
         
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c(LCRM_Contact__c=oContact.Id, LCRM_SAP_Role__c=oContact.SAP_Role__c, LCRM_Source_Contact_Id__c='3453463635635');
        contactssdList.add(conSSD);
         
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        oProposal.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        oProposal.Apttus_Proposal__Account__c=a.Id;
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.APTS_Order_Confirmation_Contact__r=oContact;
        oProposal.Digital_Quote_Type__c='Manual';
        oProposal.recordtypeId=propRecorType;
        insert oProposal;
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys', Apttus_Filter_Brand_Code__c = '064');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Brand_Code__c = '076', APTS_Media_High_Level_Code__c = '06', Subscription_Number__c = '41409998');
        insert oProductB;
        insert oProductP;  
        
        Test.startTest();    
                
        List<Customer_Master_Contacts__c> mstrConList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Material__c ='41727130,', Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Material__c = '1234568978966,', Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', From_IP_Address__c = '5.32.60.224', To_IP_Address__c = '5.32.60.224', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', From_IP_Address__c = '5.32.60.224', To_IP_Address__c = '5.32.60.224', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc5);
        
        insert mstrConList;
        
        insert contactssdList;
         
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = a.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        insert oc1; 
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems; 
        
        PageReference pageRef = Page.MasterContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        MasterContactsController contr= new MasterContactsController(sc);
       
        for(MasterContactsController.MCWrapper mw : contr.patronConList) {
            mw.isSelected = False;
            break;
        }
        /*for(MasterContactsControllerNew.MCWrapper mw : contr.patronConList) {
            mw.isSelected = True;
            break;
        } */
        contr.save();
        contr.cancel();
        contr.mcListHelper(conSSD.LCRM_SAP_Role__c.split(';'), conSSD);        
        
        system.assertEquals(a.Name, 'Sree Test');
        Test.stopTest();
        }
        
         public static testMethod void processController3() {
     
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        
       List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='false')};
        insert keyvaluestore;
           List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
     
        Account a = APTS_TestDataFactory.createAccount('Sree Test');
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
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
     
       
       
        
        Contact oContact = UnitTest.getContactInstance(a.Id);
        oContact.SAP_Role__c = 'TECHNICAL CONTACT;CLEAR PRIMARY CONT;EML PSWD CONTACT;PATRON ACC TECH CONT;ADMINISTRATOR;PRINT IP CONT';
        oContact.Email='unitTest@tcs.com';
        oContact.Phone='8764556756';
        insert oContact;
        
        List <LCRM_Contact_SSD__c> contactssdList = new List <LCRM_Contact_SSD__c>();
         
         
        LCRM_Contact_SSD__c conSSD = new LCRM_Contact_SSD__c(LCRM_Contact__c=oContact.Id, LCRM_SAP_Role__c=oContact.SAP_Role__c, LCRM_Source_Contact_Id__c='3453463635635');
        contactssdList.add(conSSD);
         
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c .getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        oProposal.Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test';
        oProposal.Apttus_Proposal__Account__c=a.Id;
        oProposal.APTS_Payment_Option__c='Credit Card';
        oProposal.APTS_Order_Confirmation_Contact__r=oContact;
        oProposal.Digital_Quote_Type__c='Manual';
        oProposal.recordtypeId=propRecorType;
        insert oProposal;
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '41727130', Apttus_Config2__Uom__c = 'Attorneys' );
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', Apttus_Config2__Uom__c = 'Seats', APTS_Media_Lower_Level_Code__c= 'CQ', APTS_Media_High_Level_Code__c = '21', Subscription_Number__c = '41409998');
        insert oProductB;
        insert oProductP;  
        
        Test.startTest();    
                
        List<Customer_Master_Contacts__c> mstrConList = new List<Customer_Master_Contacts__c>();  
        Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Material__c ='41727130,', Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc1);
        Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Material__c = '1234568978966,', Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', From_IP_Address__c = '5.32.60.224', To_IP_Address__c = '5.32.60.224', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc2);
        Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc3); 
        Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'PRINT IP CONT', From_IP_Address__c = '5.32.60.224', To_IP_Address__c = '5.32.60.224', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc4);
        Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Contact_SDD__c = conSSD.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
        mstrConList.add(mc5);
        
        insert mstrConList;
        
        insert contactssdList;
         
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = a.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        insert oc1; 
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems; 
        
        PageReference pageRef = Page.MasterContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        MasterContactsController contr= new MasterContactsController(sc);
       
        for(MasterContactsController.MCWrapper mw : contr.patronConList) {
            mw.isSelected = False;
            break;
        }
        /*for(MasterContactsControllerNew.MCWrapper mw : contr.patronConList) {
            mw.isSelected = True;
            break;
        } */
        contr.save();
        contr.cancel();
        contr.mcListHelper(conSSD.LCRM_SAP_Role__c.split(';'), conSSD);        
        
        system.assertEquals(a.Name, 'Sree Test');
        Test.stopTest();
        }
}