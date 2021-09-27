@isTest
public Class APTS_QuoteDocPostBack_Test {
    /**
     * @description fetchQuoteDoc
     */
    public static testMethod void fetchQuoteDoc() {
    
        
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount;       
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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

        Account a = APTS_TestDataFactory.createAccount('Test Account');
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
        
        //Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id);
        Apttus_Proposal__Proposal__c oProposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert oProposal;

        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        ContentVersion cv = new ContentVersion();
           cv.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv.Title = 'signed Demo.pdf'; // Display name of the files
           cv.VersionData = beforeblob; // converting your binary string to Blog
           insert cv;
   
               //ContentVersion cv2 = [SELECT Id, Title,VersionData, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
           //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                       
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe = new ContentDocumentLink();
           cDe.ContentDocumentId = conDoc;
           cDe.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe;
           
              
           APTS_QuoteDocPostBack.Quote vQuote = new APTS_QuoteDocPostBack.Quote();
           vQuote.attachhmentId= conDoc;
   
           Blob docBody = APTS_QuoteDocPostBack.fetchQuoteDoc(vQuote); 
           system.assertEquals(beforeblob, cv.VersionData,'Not Equal'); 
   
           APTS_QuoteDocPostBack.Quote vQuote1 = new APTS_QuoteDocPostBack.Quote();
           vQuote1.attachhmentId= '';
   
           Blob docBody1 = APTS_QuoteDocPostBack.fetchQuoteDoc(vQuote1);  
     
    }
    /**
     * @description fetchQuoteDoc
     */
    
    public static testMethod void fetchQuote1() {
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount;       
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(Name = 'Thomson Reuters Master - US Legal');
        insert priceList;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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

        Account a = APTS_TestDataFactory.createAccount('Test Account');
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
        
        //Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id);
        Apttus_Proposal__Proposal__c oProposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        oProposal.APTS_AVC_Order_Form__c = True;
        insert oProposal;

        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        ContentVersion cv = new ContentVersion();
           cv.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv.Title = 'AVC signed Demo.pdf'; // Display name of the files
           cv.VersionData = beforeblob; // converting your binary string to Blog
           insert cv;
   
               //ContentVersion cv2 = [SELECT Id, Title,VersionData, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
           //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                       
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe = new ContentDocumentLink();
           cDe.ContentDocumentId = conDoc;
           cDe.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe;
           
              
           APTS_QuoteDocPostBack.Quote vQuote = new APTS_QuoteDocPostBack.Quote();
           vQuote.attachhmentId= cv.ContentDocumentId;
   
           Blob docBody = APTS_QuoteDocPostBack.fetchQuoteDoc(vQuote); 
           system.assertEquals(beforeblob, cv.VersionData,'Not Equal'); 
   
           APTS_QuoteDocPostBack.Quote vQuote1 = new APTS_QuoteDocPostBack.Quote();
           vQuote1.attachhmentId= '';
   
           Blob docBody1 = APTS_QuoteDocPostBack.fetchQuoteDoc(vQuote1);  
     
    }
    /*public static testMethod void fetchQuote() {
        APTS_QuoteDocPostBack.Quote oQuote1 = new APTS_QuoteDocPostBack.Quote();
        oQuote1.cVId = '';     
    }*/

}