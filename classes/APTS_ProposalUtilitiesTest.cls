@isTest
private class APTS_ProposalUtilitiesTest {

    @testSetup
    static void setupData(){
        List<WebServiceSettings__c> WebserviceList2 = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
         new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
            
            new WebServiceSettings__c(Name='LCRM_CredentialInfoServices',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};

                insert WebserviceList2;
    }

 static testMethod void testSendEmail() {
 LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
        String s,s1;
        Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=true;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Existing_Database__c=true;
        proposal.APTS_Client_Database_Code__c='12345';
        insert proposal;
       
       Attachment attach=new Attachment();     
       attach.Name='Unit Test Attachment';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=proposal.id;
       insert attach;       
       
       Attachment attach1=new Attachment();     
       attach1.Name='Contract_Signed.txt';
       Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
       attach1.body=bodyBlob;
       attach1.ContentType='.pdf';
       attach1.parentId=proposal.id;
       insert attach1;
       
       Attachment attach3=new Attachment();     
       attach3.Name='Product User Detail.doc';
       Blob bodyBlob2=Blob.valueOf('Test Product User Detail Body');
       attach3.body=bodyBlob2;
       attach3.parentId=proposal.id;
       insert attach3;
       
       // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'signed Demo.pdf'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe; 
            
       
       Test.startTest();
       //APTS_ProposalUtilities util = new APTS_ProposalUtilities();
       //s=APTS_ProposalUtilities.submitProposal(p.id, 'sgrandhi@apttus.com');
       s=APTS_ProposalUtilities.sendEmail(proposal.id, 'sgrandhi@apttus.com');
       s1=APTS_ProposalUtilities.sendEmailForDatabaseEntitlement(proposal.id, 'test@tcsa.com','Q-09738376',true,proposal.APTS_Existing_Database__c,proposal.APTS_Client_Database_Code__c,proposal.APTS_Proposal_Business_Unit__c);
       System.debug('@@@@@@@@@'+s);
       //s = APTS_ProposalUtilities.submitOrder(p.id);
       Test.stopTest();
       
       
         
       //Assert statements
       System.assertEquals(s, 'Confirmation Email Sent Successfully.');
  }
  
  static testMethod void testSendEmail1() {
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
       String s;
      String s1;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        insert proposal;
       
       Attachment attach=new Attachment();     
       attach.Name='Contract_Signed.txt';
       Blob bodyBlob=Blob.valueOf('Signed Contract Body');
       attach.body=bodyBlob;
       attach.ContentType='.pdf';
       attach.parentId=proposal.id;
       insert attach;
       
       Attachment attach1=new Attachment();     
       attach1.Name='Test_cvms.txt';
       Blob bodyBlob1=Blob.valueOf('Test CVMS Body');
       attach1.body=bodyBlob1;
       attach1.ContentType='.pdf';
       attach1.parentId=proposal.id;
       insert attach1;              

       Attachment attach2=new Attachment();     
       attach2.Name='Product User Detail.txt';
       Blob bodyBlob2=Blob.valueOf('Test Product User Detail Body');
       attach2.body=bodyBlob2;
       attach2.parentId=proposal.id;
       insert attach2;
       
       Attachment attach3=new Attachment();     
       attach3.Name='Product User Detail.doc';
       Blob bodyBlob3=Blob.valueOf('Test Product User Detail Body');
       attach3.body=bodyBlob3;
       attach3.parentId=proposal.id;
       insert attach3;
       
              
       Test.startTest();
       //APTS_ProposalUtilities util = new APTS_ProposalUtilities();
       //s=APTS_ProposalUtilities.submitProposal(p.id, 'sgrandhi@apttus.com');
       //s=APTS_ProposalUtilities.sendEmail(p.id, 'sgrandhi@apttus.com');
       
       s=APTS_ProposalUtilities.sendEmail(proposal.id, 'sgrandhi@apttus.com');
      
       Test.stopTest();
         
       //Assert statements
       System.assertEquals(s, 'Confirmation Email Sent Successfully.');
       }  
       /*static testMethod void testProposal() {
       LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
        APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
        String s,s1,s2,s3,s4,s5;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        //accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Customer_Group__c='GOVERNMENT';
        accountSSD.LCRM_Sales_Org__c='CARS';
        accountSSD.LCRM_Industry__c = 'test';
        insert accountSSD;
           
        // insert contact
        contact con = APTS_TestDataFactory.createContact('testcon',a.id);
        con.FirstName='TestFirst';
        con.email='test123@abc.com';
        insert con ;
           
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
        
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=false;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Assent_Customer_Name__c='Test User';
        proposal.APTS_Order_Confirmation_Contact__c=con.id;
        proposal.Customer_Group__c = 'CORPORATION';
        proposal.APTS_Proposal_Business_Unit__c = 'Canada';
        proplist.add(proposal);
        Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal1.RecordtypeId=propRecorType;
        proposal1.APTS_Law_Enforcement_Required__c='Yes';
        proplist.add(proposal1);
        insert proplist;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
       
        Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = 'Online',
          APTS_Media_High_Level_Code__c = '06',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        insert pl1;
        
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = 'Online',
          APTS_Media_High_Level_Code__c = '21',
          APTS_Media_Lower_Level_Code__c = 'F4',
          APTS_Item_Category_Group__c = 'ZPR2',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        insert pl2;
        
        Apttus_QPConfig__ProposalProductAttributeValue__c a1 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub',Apttus_QPConfig__LineItemId__c=pl1.id);
        insert a1;
           
           List<WebServiceSettings__c> lstofWebServ = new List<WebServiceSettings__c>();
        WebServiceSettings__c WebserveCred = new WebServiceSettings__c();
        WebserveCred.name = 'LCRM_CredentialInfoServices';       
        WebserveCred.Active__c = true;
        WebserveCred.Endpoint__c = 'https://esi-dev.thomsonreuters.com/osb/AccountService/AccountService_RestService/getCredentialInfo';
        WebserveCred.Password__c = 'Gliu$er123';
        WebserveCred.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        WebserveCred.Timeout__c = 120;
        WebserveCred.Username__c = 'gliuser';
        lstofWebServ.add(WebserveCred);
        
        if(lstofWebServ.size()>0){
            insert lstofWebServ;
        }
      
        
         IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
         testIXOSCodeMap.Company_Code__c = '0010';
         testIXOSCodeMap.Dist_Chan_Code__c= 'W';
         testIXOSCodeMap.Division_Code__c = 'W';
         testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
         testIXOSCodeMap.Name = 'CredTest';
         insert testIXOSCodeMap;
            List<ContentVersion> lstVersions=new List<ContentVersion>(); 
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'AVC Demo.pdf'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            lstVersions.add(conVer);
            ContentVersion conVer1 = new ContentVersion();
            conVer1.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer1.PathOnClient = 'Demo.doc'; // The files name, extension is very important here which will help the file in preview.
            conVer1.Title = 'AVC Demo.doc'; // Display name of the files
            conVer1.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            lstVersions.add(conVer1);
            
            ContentVersion conVer2 = new ContentVersion();
            conVer2.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer2.PathOnClient = 'Demo.docx'; // The files name, extension is very important here which will help the file in preview.
            conVer2.Title = 'AVC Demo.docx'; // Display name of the files
            conVer2.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            lstVersions.add(conVer2);
            
            ContentVersion conVer3 = new ContentVersion();
            conVer3.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer3.PathOnClient = 'Demo.rtf'; // The files name, extension is very important here which will help the file in preview.
            conVer3.Title = 'AVC Demo.rtf'; // Display name of the files
            conVer3.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            lstVersions.add(conVer3);
            insert lstVersions;
            List<ContentDocumentLink>  lstcdlinks=new List<ContentDocumentLink>();     
            for(ContentVersion cv: [SELECT id, ContentDocumentId FROM ContentVersion WHERE Id =:lstVersions]){
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = cv.ContentDocumentId;
                cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                lstcdlinks.add(cde);
            }
           
            insert lstcdlinks;             

            pl1.Apttus_qpconfig__attributevalueid__c=a1.id;
            update pl1;
            
            pl2.APTS_Media_High_Level_Code__c='21';
            update pl2;
       s=APTS_ProposalUtilities.validateProposalForSignatureBlock(proposal.id);
       s1=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
       s2=APTS_ProposalUtilities.validateProposalForAssentFields(proposal.id);
       s3=APTS_ProposalUtilities.submitOrder(proposal.id);
       s4=APTS_ProposalUtilities.generateAVC(proposal.id);       
       s5=APTS_ProposalUtilities.sendEmail(proposal.id,'testOU@thomsonreuters.com');
       Test.stopTest();
       }*/
static testMethod void testUnitProposal() {
           KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c keyvaluestoretax =new  KeyValueListStore__c();
        keyvaluestoretax.Name='LCRMOpptyTerritoryStageValues';
        keyvaluestoretax.TextValue__c='Contract Signed,Order Complete,Closed Lost';
    KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        List<KeyValueListStore__c> keylist = new List<KeyValueListStore__c>{keyvaluestore,keyvaluestoretax,keyval};
        insert keylist;

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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
        APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
        String s,s1,s2,s3,s4,s5;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        //accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Customer_Group__c='GOVERNMENT';
        accountSSD.LCRM_Sales_Org__c='WEST';
        accountSSD.Source_System_Account_Number__c='56736483';
        insert accountSSD;
           
        // insert contact
        contact con = APTS_TestDataFactory.createContact('testcon',a.id);
        con.FirstName='TestFirst';
        con.email='test123@abc.com';
        insert con ;
           
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        
        List<Apttus_Proposal__Proposal__c> proplist = new List<Apttus_Proposal__Proposal__c>();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=true;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Assent_Customer_Name__c='Test User';
        proposal.APTS_Order_Confirmation_Contact__c=con.id;
    //proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c=accountSSD.Source_System_Account_Number__c;
        proplist.add(proposal);
        Apttus_Proposal__Proposal__c proposal1 = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal1.RecordtypeId=propRecorType;
        proposal1.APTS_Law_Enforcement_Required__c='Yes';
    //proposal1.APTS_SSD_Sold_To__r.Source_System_Account_Number__c=accountSSD.Source_System_Account_Number__c;
        proplist.add(proposal1);
        insert proplist;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
    
   
       
       Test.startTest();
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = 'Online',
          APTS_Media_High_Level_Code__c = '',
          //APTS_Product_Family__c='CLEAR',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        insert pl1;
        
        Apttus_QPConfig__ProposalProductAttributeValue__c a1 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub',Apttus_QPConfig__LineItemId__c=pl1.id);
        insert a1;
        
         IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
         insert codeMap;
         
             
            pl1.Apttus_qpconfig__attributevalueid__c=a1.id;
            update pl1;
       //s=APTS_ProposalUtilities.validateProposalForSignatureBlock(proposal.id);
        s5=APTS_ProposalUtilities.validateForSignatureBlock(proposal.id);
      s1=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
       s2=APTS_ProposalUtilities.validateProposalForAssentFields(proposal.id);
       s3=APTS_ProposalUtilities.submitOrder(proposal.id);
       s4=APTS_ProposalUtilities.generateAVC(proposal.id);       
       
       Test.stopTest();
       }
       
       @isTest static void testProposal1() {
       LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
     List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c >();
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        WebServiceSettings__c oWebServiceSettings1 = APTS_TestDataFactory.createWebServiceSetting('LCRM_CredentialInfoServices');
        webServiceList.add(oWebServiceSettings);
        webServiceList.add(oWebServiceSettings1);
        insert webServiceList;
       APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
       String s,s1,s2,s3,s4;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        Contact cont = new Contact(FirstName='MansiPU',LastName='N',AccountId=a.Id,ESC_tocLanguage__c = 'French',Email = 'test@gmail.com');
        insert cont;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234567890';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
           system.debug('@123testSSD' +accountSSD);
           
           
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        oppty.key_contact__c= cont.id;
        insert oppty;
           system.debug('@123testopty' +oppty);
        Test.startTest();
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=false;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Order_Confirmation_Contact__c=cont.id;
       //proposal.APTS_Proposal_Business_Unit__c = 'Findlaw';
        insert proposal;
           system.debug('@123testprop' +proposal);
           
                 
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
       
         List<Apttus_Proposal__Proposal_Line_Item__c> proplist = new List<Apttus_Proposal__Proposal_Line_Item__c>();
         Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          apttus_proposal__proposal__c=proposal.id,apts_cat_l5__c='l5_l1341_fp');
          
          
        proplist.add(pl2);
        
        Apttus_Proposal__Proposal_Line_Item__c pl3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          APTS_Cat_L2__c= label.APTS_Clear_Product_Family,
          APTS_Product_Family__c='CLEAR',                    
          Apttus_Proposal__Proposal__c=proposal.id,apts_cat_l5__c='l5_l1341_fp');
          
        proplist.add(pl3);
        insert proplist;
        
        Apttus_QPConfig__ProposalProductAttributeValue__c a2 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Ship & Enter Sub APP',Apttus_QPConfig__LineItemId__c=pl2.id);
        insert a2; 
        
         /*Account testAcc1 = UnitTest.getAccountInstance();
        testAcc1.SAPAccountNumber__c = '12346';
        testAcc1.Sales_Org__c = 'WEST';
        insert testAcc1;*/
        
         IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
         insert codeMap;
          
        
           Attachment attach1=new Attachment();     
           attach1.Name='AVC Order Form';
           Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
           attach1.body=bodyBlob1;
           attach1.parentId=proposal.id;
           insert attach1;
           
           // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.doc'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'signed Demo.doc'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe; 
           
       s=APTS_ProposalUtilities.validateProposalForSignatureBlock(proposal.id);
       s1=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
       s2=APTS_ProposalUtilities.validateProposalForAssentFields(proposal.id);
       s3=APTS_ProposalUtilities.generateAVC(proposal.id);
       s4=APTS_ProposalUtilities.sendEmail(proposal.id,'test1@thomsonreuters.com');
       Test.stopTest();
       }
       
       static testMethod void testProposal2() {
       LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
     IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
        insert codeMap;
         List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c >();
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        WebServiceSettings__c oWebServiceSettings1 = APTS_TestDataFactory.createWebServiceSetting('LCRM_CredentialInfoServices');
        webServiceList.add(oWebServiceSettings);
        webServiceList.add(oWebServiceSettings1);
        insert webServiceList;
       String s;
           String s1;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=false;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        insert proposal;
       
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
       
             
         Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          APTS_Cat_L2__c= label.APTS_Clear_Product_Family,  
          APTS_Product_Family__c='CLEAR',                 
          Apttus_Proposal__Proposal__c=proposal.id);
          
        insert pl2;
        Test.startTest();
        Apttus_QPConfig__ProposalProductAttributeValue__c a2 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Ship & Enter Sub APP',Apttus_QPConfig__LineItemId__c=pl2.id);
        insert a2; 
        
       
        
         IXOSCodeMap__c testIXOSCodeMap = new IXOSCodeMap__c();
         testIXOSCodeMap.Company_Code__c = '0010';
         testIXOSCodeMap.Dist_Chan_Code__c= 'W';
         testIXOSCodeMap.Division_Code__c = 'W';
         testIXOSCodeMap.Sales_Org_Code__c = 'WEST';
         testIXOSCodeMap.Name = 'CredTest';
         insert testIXOSCodeMap;  
        
        
            Attachment attach1=new Attachment();     
           attach1.Name='AVC Order Form';
           Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
           attach1.body=bodyBlob1;
           attach1.parentId=proposal.id;
           insert attach1;
           
           // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.XLS'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Demo.XLS'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe; 
      
       s1=APTS_ProposalUtilities.generateAVC(proposal.id);
       s=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
           //s3=APTS_ProposalUtilities.submitOrder(proposal.id);
       Test.stopTest();
       }
       
       
       static testMethod void testProposal21() {
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
       
       String s,s1,s2,s3,s4,s5;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        insert proposal;
       
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
         Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          //prodObj.Sub_Bu__c='FindLaw';
          prodObj.APTS_Attrbased_config__C =true;
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.ProductCode = '40586465';
          insert prodObj;  
          
          APTS_FindLaw_GEO_Defualts__c geoDefaults = new APTS_FindLaw_GEO_Defualts__c();
          geoDefaults.Name='1234';
          insert geoDefaults;
          
          APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
          attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj.id;
          insert attributesetting;
          
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue1.APTS_Product__c=prodObj.id;
          Insert attributevalue1;
          
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue2.APTS_Product__c=prodObj.id;
          Insert attributevalue2;
          
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue3.APTS_Product__c=prodObj.id;
          Insert attributevalue3;
          
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue4.APTS_Product__c=prodObj.id;
          Insert attributevalue4;
          
                    
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Inventory_Available__c=0;
          attributecombination.APTS_Product__c=prodObj.id;
          insert attributecombination;
          
          List<Apttus_Proposal__Proposal_Line_Item__c> pl2 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
          Apttus_Proposal__Proposal_Line_Item__c pl3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          APTS_Combination_Key__c=attributecombination.id,
          Apttus_Proposal__Product__c=prodObj.id,
          APTS_Cat_L2__c= label.APTS_Clear_Product_Family, 
          APTS_Product_Family__c='CLEAR', 
          Apttus_QPConfig__LineStatus__c='New',   
          Apttus_Proposal__Proposal__c=proposal.id);
          pl2.add(pl3);
          insert pl2;
       
        Test.startTest();
            
       List<Apttus_Proposal__Proposal_Line_Item__c> PLI = APTS_ProposalUtilities.validateProposalForInventory(proposal.id);
          
      s=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
       
       s3=APTS_ProposalUtilities.submitOrder(proposal.id);
       s4=APTS_ProposalUtilities.generateAVC(proposal.id);  
       Test.stopTest();
       }
       static testMethod void testGenerateExposurePackAttachment() {
       LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
        
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
       
       String s;
        APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
       
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_FL_Product_Language__c='PI-LL-ExposurePack';
        insert proposal;
        
        Attachment findlawAttachment=new Attachment(name='Findlaw Attachment Form',ParentId=proposal.id,body=Blob.valueOf('Test'));
        insert findlawAttachment;
        
        // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.XLS'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Demo.XLS'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe; 
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        
         Product2 prodObj = new Product2();
          prodObj.Name = 'Findlaw Exposure Pack';
          //prodObj.Sub_Bu__c='FindLaw';
          prodObj.APTS_Attrbased_config__C =true;
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.ProductCode = '40656701';
          insert prodObj;  
       
        Test.startTest();
            
       String errorMessage = APTS_ProposalUtilities.generateExposurePackAttachment(proposal.id);       
       Test.stopTest();
       }
       static testMethod void testGenerateExposurePackAttachment2() {
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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
       
       String s;
       APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
       
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_FL_Product_Language__c='PI-LL-ExposurePack';
        insert proposal;
       
        
       
        Test.startTest();
            
       String errorMessage = APTS_ProposalUtilities.generateExposurePackAttachment(proposal.id);
          // s=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
       Test.stopTest();
       }
   static testMethod void testProposalcontentversion() {
   String json = '{'+
        '  \"getCredentialInfoResponse\" : {'+
        '    \"CredentialInfoItem\" : [ {'+
        '      \"accountNumber\" : \"1000497321\",'+
        '      \"domain\" : \"WESTLAW\",'+
        '      \"credentialProgress\" : \"null\",'+
        '      \"credentialProgressDesc\" : \"null\",'+
        '      \"credentialStatus\" : \"AA\",'+
        '      \"credentialStatusDesc\" : \"Approved - All\",'+
        '      \"businessType\" : \"null\",'+
        '      \"businessTypeDesc\" : \"null\",'+
        '      \"restrictionCls\" : \"null\",'+
        '      \"restrictionClsDesc\" : \"null\",'+
        '      \"progessDt\" : \"0000-00-00\",'+
        '      \"statusDt\" : \"0000-00-00\",'+
        '      \"responseStatus\" : \"null\",'+
        '      \"responseStatusDescription\" : \"null\"'+
        '    } ],'+
        '    \"BusinessRestrictionItem\" : [ {'+
        '      \"accountNumber\" : \"1000497321\",'+
        '      \"businessRestriction\" : \"null\",'+
        '      \"businessRestrictionDesc\" : \"null\",'+
        '      \"responseStatus\" : \"E\",'+
        '      \"responseStatusDescription\" : \"No Data Found\"'+
        '    } ]'+
        '  }'+
        '}';
   LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
          KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c keyValue1 = new KeyValueListStore__c(name='ReasonWithCompetitor', TextValue__c = 'Content');
        KeyValueListStore__c keyvaluestoretax =new  KeyValueListStore__c();
        keyvaluestoretax.Name='LCRMOpptyTerritoryStageValues';
        keyvaluestoretax.TextValue__c='Contract Signed,Order Complete,Closed Lost';
        List<KeyValueListStore__c> keylist = new List<KeyValueListStore__c>{keyvaluestore,keyValue1,keyvaluestoretax};
        insert keylist;

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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
     List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c >();
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        WebServiceSettings__c oWebServiceSettings1 = APTS_TestDataFactory.createWebServiceSetting('LCRM_CredentialInfoServices');
        webServiceList.add(oWebServiceSettings);
        webServiceList.add(oWebServiceSettings1);
        insert webServiceList;
       
       APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
       String s,s1,s2,s3,s4;
       list<LCRMCredentialJsonWrapper.CredentialInfoItemcls> credinfolist = new list<LCRMCredentialJsonWrapper.CredentialInfoItemcls>();
       LCRMCredentialJsonWrapper.SSDResponseWrapper obj = new LCRMCredentialJsonWrapper.SSDResponseWrapper();
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_Wet_Signature__c=false;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Wet_Signature__c = true;
        insert proposal;
       
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
       
         List<Apttus_Proposal__Proposal_Line_Item__c> proplist = new List<Apttus_Proposal__Proposal_Line_Item__c>();
         Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        proplist.add(pl2);
        
        Apttus_Proposal__Proposal_Line_Item__c pl3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          APTS_Cat_L2__c= label.APTS_Clear_Product_Family,
          APTS_Product_Family__c='CLEAR',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        proplist.add(pl3);
        insert proplist;
        
        Apttus_QPConfig__ProposalProductAttributeValue__c a2 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Ship & Enter Sub APP',Apttus_QPConfig__LineItemId__c=pl2.id);
        insert a2; 
        
        
        
         IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
         insert codeMap;
          
        
        Test.startTest();
        obj = LCRMCredentialJsonWrapper.parse(json);
       credinfolist = LCRMCredentialJsonWrapper.getjsonresponse(json);
           //LCRMCredentialJsonWrapper.SSDResponseWrapper obj = LCRMCredentialJsonWrapper.parse(json);
           // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'AVC Demo.pdf'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe; 
            obj = LCRMCredentialJsonWrapper.parse(json);
       credinfolist = LCRMCredentialJsonWrapper.getjsonresponse(json);
       s=APTS_ProposalUtilities.validateProposalForSignatureBlock(proposal.id);
      s1=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
      
       s2=APTS_ProposalUtilities.validateProposalForAssentFields(proposal.id);
       s3=APTS_ProposalUtilities.generateAVC(proposal.id);
       s4=APTS_ProposalUtilities.sendEmail(proposal.id,'sgrandhi@apttus.com');     
       Test.stopTest();
       }
       static testMethod void testTaxProfCode() {
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
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
        Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
        insert priceList;
       APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
       
           String s;
           Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_FL_Product_Language__c='PI-LL-ExposurePack';
        proposal.APTS_Proposal_Business_Unit__c = 'Tax Professional'; 
        insert proposal;
       
        Attachment attach1=new Attachment();     
           attach1.Name='AVC Order Form';
           Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
           attach1.body=bodyBlob1;
           attach1.parentId=proposal.id;
           insert attach1;
           
           // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.XLS'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Signed_Demo.XLS'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe; 
        
       Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
       insert prodConfig;
       Test.startTest();
       Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          Apttus_Proposal__Proposal__c=proposal.id,
          APTS_Proposal_Business_Unit__c = 'Tax Professional');
          
        insert pl1;
        
        s=APTS_ProposalUtilities.validateProposalForSignatureBlock(proposal.id);
        string s1=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
           
       Test.stopTest();
       }
       static testMethod void testProposalcorpcontentversion() {
       
       LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;
          KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c keyValue1 = new KeyValueListStore__c(name='ReasonWithCompetitor', TextValue__c = 'Content');
        KeyValueListStore__c keyvaluestoretax =new  KeyValueListStore__c();
        keyvaluestoretax.Name='LCRMOpptyTerritoryStageValues';
        keyvaluestoretax.TextValue__c='Contract Signed,Order Complete,Closed Lost';
        List<KeyValueListStore__c> keylist = new List<KeyValueListStore__c>{keyvaluestore,keyValue1,keyvaluestoretax};
        insert keylist;

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
    Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
    insert priceList;
     List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c >();
        WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
        WebServiceSettings__c oWebServiceSettings1 = APTS_TestDataFactory.createWebServiceSetting('CredentialInfoServices');
        webServiceList.add(oWebServiceSettings);
        webServiceList.add(oWebServiceSettings1);
        insert webServiceList;
       
       APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
       insert configSettings;
       String s,s1;
       Account a = APTS_TestDataFactory.createAccount('test-sg');
        a.sales_org__c='ABEP';
        a.customer_group__c='Academic';
        a.customer_type__c='Organization';
        a.customer_class_c__c='Academic Lecturer';
        insert a;
        System.assertEquals( 'test-sg',a.Name,'Success');

        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        accountSSD.Source_System_Account_Number__c='1234';
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
      //Inserting opportunity  
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Name='tst-opp';
        oppty.forecastcategoryname='Omitted';
        oppty.stagename='0%';
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.RecordtypeId=propRecorType;
        proposal.APTS_SSD_Sold_To__c=accountSSD.id;
        proposal.APTS_Wet_Signature__c = true;
        proposal.APTS_Existing_Database__c = true;
        proposal.APTS_Client_Database_Code__c = '12345';
        proposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        insert proposal;
       
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
       
         List<Apttus_Proposal__Proposal_Line_Item__c> proplist = new List<Apttus_Proposal__Proposal_Line_Item__c>();
         Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        proplist.add(pl2);
        
        Apttus_Proposal__Proposal_Line_Item__c pl3 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = '',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Media_High_Level__c = '',
          APTS_Media_High_Level_Code__c = '',
          APTS_Cat_L2__c= label.APTS_Clear_Product_Family,
          APTS_Product_Family__c='CLEAR',
          Apttus_Proposal__Proposal__c=proposal.id);
          
        proplist.add(pl3);
        insert proplist;
        
        Apttus_QPConfig__ProposalProductAttributeValue__c a2 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Ship & Enter Sub APP',Apttus_QPConfig__LineItemId__c=pl2.id);
        insert a2; 
        
         
        
         IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
         insert codeMap;
          
        
        Test.startTest();
           
           // Insert Files as attachments
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Demo.docx'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Signed_AVC Demo.docx'; // Display name of the files
            conVer.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer;
                    
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe;           
       s = APTS_ProposalUtilities.sendEmail(proposal.id,'sgrandhi@apttus.com'); 
       s1=APTS_ProposalUtilities.sendEmailForDatabaseEntitlement(proposal.id, 'test@tcsa.com','Q-09738376',true,proposal.APTS_Existing_Database__c,proposal.APTS_Client_Database_Code__c,proposal.APTS_Proposal_Business_Unit__c);    
       
       
       // Insert Files as attachments
            ContentVersion conVer1 = new ContentVersion();
            conVer1.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer1.PathOnClient = 'Demo.doc'; // The files name, extension is very important here which will help the file in preview.
            conVer1.Title = 'Signed_AVC Demo.doc'; // Display name of the files
            conVer1.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer1;
                    
            Id conDoc1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer1.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe1 = new ContentDocumentLink();
            cDe1.ContentDocumentId = conDoc1;
            cDe1.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe1.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe1;    
            String s2, s3;       
       s2 = APTS_ProposalUtilities.sendEmail(proposal.id,'sgrandhi@apttus.com'); 
       s3=APTS_ProposalUtilities.sendEmailForDatabaseEntitlement(proposal.id, 'test@tcsa.com','Q-09738376',true,proposal.APTS_Existing_Database__c,proposal.APTS_Client_Database_Code__c,proposal.APTS_Proposal_Business_Unit__c); 
          
           // Insert Files as attachments
            ContentVersion conVer2 = new ContentVersion();
            conVer2.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer2.PathOnClient = 'Demo.rtf'; // The files name, extension is very important here which will help the file in preview.
            conVer2.Title = 'Signed_AVC Demo.doc'; // Display name of the files
            conVer2.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
            insert conVer2 ;
                    
            Id conDoc2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer2.Id].ContentDocumentId;
 
            //Create ContentDocumentLink
            ContentDocumentLink cDe2 = new ContentDocumentLink();
            cDe2.ContentDocumentId = conDoc2;
            cDe2.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
            cDe2.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
            insert cDe2;    
            String s4, s5;       
       s4 = APTS_ProposalUtilities.sendEmail(proposal.id,'sgrandhi@apttus.com'); 
       s5=APTS_ProposalUtilities.sendEmailForDatabaseEntitlement(proposal.id, 'test@tcsa.com','Q-09738376',true,proposal.APTS_Existing_Database__c,proposal.APTS_Client_Database_Code__c,proposal.APTS_Proposal_Business_Unit__c); 
           // Insert Files as attachments
 /*  ContentVersion conVer3 = new ContentVersion();
   conVer3.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
   conVer3.PathOnClient = 'Demo.png';// The files name, extension is very important here which will help the file in preview.
   conVer3.Title = 'Signed_AVC Demo.png'; // Display name of the files
   conVer3.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
   insert conVer3 ;
           
   Id conDoc3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer3.Id].ContentDocumentId;

   //Create ContentDocumentLink
   ContentDocumentLink cDe3 = new ContentDocumentLink();
   cDe3.ContentDocumentId = conDoc3;
   cDe3.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
   cDe3.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
   insert cDe3;    
   String s6, s7;       
s6 = APTS_ProposalUtilities.sendEmail(proposal.id,'sgrandhi@apttus.com'); 
s7=APTS_ProposalUtilities.sendEmailForDatabaseEntitlement(proposal.id, 'test@tcsa.com','Q-09738376',true,proposal.APTS_Existing_Database__c,proposal.APTS_Client_Database_Code__c,proposal.APTS_Proposal_Business_Unit__c);   */
       Test.stopTest();
   }
    static testMethod void testParse() {
        String json = '{'+
        '  \"getCredentialInfoResponse\" : {'+
        '    \"CredentialInfoItem\" : [ {'+
        '      \"accountNumber\" : \"1000497321\",'+
        '      \"domain\" : \"WESTLAW\",'+
        '      \"credentialProgress\" : \"null\",'+
        '      \"credentialProgressDesc\" : \"null\",'+
        '      \"credentialStatus\" : \"AA\",'+
        '      \"credentialStatusDesc\" : \"Approved - All\",'+
        '      \"businessType\" : \"null\",'+
        '      \"businessTypeDesc\" : \"null\",'+
        '      \"restrictionCls\" : \"null\",'+
        '      \"restrictionClsDesc\" : \"null\",'+
        '      \"progessDt\" : \"0000-00-00\",'+
        '      \"statusDt\" : \"0000-00-00\",'+
        '      \"responseStatus\" : \"null\",'+
        '      \"responseStatusDescription\" : \"null\"'+
        '    } ],'+
        '    \"BusinessRestrictionItem\" : [ {'+
        '      \"accountNumber\" : \"1000497321\",'+
        '      \"businessRestriction\" : \"null\",'+
        '      \"businessRestrictionDesc\" : \"null\",'+
        '      \"responseStatus\" : \"E\",'+
        '      \"responseStatusDescription\" : \"No Data Found\"'+
        '    } ]'+
        '  }'+
        '}';
        Test.startTest();
        LCRMCredentialJsonWrapper.SSDResponseWrapper obj = LCRMCredentialJsonWrapper.parse(json);
        Test.stopTest();
        System.assert(obj != null);
    }
  @isTest static void testProposal5() {
  LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
   insert test2;
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
Apttus_Config2__PriceList__c priceList=new Apttus_Config2__PriceList__c( name = 'Thomson Reuters Master - US Legal');
insert priceList;
List<WebServiceSettings__c> webServiceList=new List<WebServiceSettings__c >();
   WebServiceSettings__c oWebServiceSettings = APTS_TestDataFactory.createWebServiceSetting('PaymentCreditIncrease');
   WebServiceSettings__c oWebServiceSettings1 = APTS_TestDataFactory.createWebServiceSetting('LCRM_CredentialInfoServices');
   webServiceList.add(oWebServiceSettings);
   webServiceList.add(oWebServiceSettings1);
   insert webServiceList;
  APTS_ConfigApprovalSettings__c configSettings=new APTS_ConfigApprovalSettings__c(name='SignoffRequiredAmount',Threshold_Amount__c=1000.00);
  insert configSettings;
  String s,s1,s2,s3,s4;
  Account a = APTS_TestDataFactory.createAccount('test-sg');
   a.sales_org__c='ABEP';
   a.customer_group__c='Academic';
   a.customer_type__c='Organization';
   a.customer_class_c__c='Academic Lecturer';
   insert a;
   Contact cont = new Contact(FirstName='MansiPU',LastName='N',AccountId=a.Id,ESC_tocLanguage__c = 'French',Email = 'test@gmail.com');
   insert cont;
   System.assertEquals( 'test-sg',a.Name,'Success');
   
   Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
   Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
   accountSSD.RecordtypeId=ssdRecorType;
   accountSSD.Account_Inactive__c=false;
   accountSSD.Source_System_Account_Number__c='1234567890';
   accountSSD.LCRM_Customer_Group__c='Academic';
   accountSSD.LCRM_Sales_Org__c='WEST';
   insert accountSSD;
      system.debug('@123testSSD' +accountSSD);
      
      
 //Inserting opportunity  
   Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
   Opportunity oppty=APTS_TestDataFactory.createOpportunity('tst-opp',a.id,'Needs Analysis',Date.Today());
   oppty.RecordtypeId=opptyRecorType;
   oppty.Source_System_Detail__c=accountSSD.id;
   oppty.Name='tst-opp';
   oppty.forecastcategoryname='Omitted';
   oppty.stagename='0%';
   oppty.Account=a;
   oppty.key_contact__c= cont.id;
   insert oppty;
      system.debug('@123testopty' +oppty);
   Test.startTest();
 //Inserting proposal
   Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
   proposal.RecordtypeId=propRecorType;
   proposal.APTS_Wet_Signature__c=false;
   proposal.APTS_SSD_Sold_To__c=accountSSD.id;
   proposal.APTS_Order_Confirmation_Contact__c=cont.id;
  //proposal.APTS_Proposal_Business_Unit__c = 'Findlaw';
 //  proposal.APTS_Validation_Messages__c='Password Holder';
   insert proposal;
      system.debug('@123testprop' +proposal);
      
            
   Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
   insert prodConfig;
  
    List<Apttus_Proposal__Proposal_Line_Item__c> proplist = new List<Apttus_Proposal__Proposal_Line_Item__c>();
    Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
     Apttus_Proposal__Quantity__c=1,
     Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
     Apttus_QPConfig__LineType__c = '',
     Apttus_QPConfig__LineNumber__c = 1, 
     Apttus_QPConfig__ItemSequence__c = 1,
     Apttus_QPConfig__NetPrice__c=1,
     APTS_Media_High_Level__c = '',
     APTS_Media_High_Level_Code__c = '',
     apttus_proposal__proposal__c=proposal.id,apts_cat_l5__c='l5_l1341_fp');
     
     
   proplist.add(pl2);
   
   Apttus_Proposal__Proposal_Line_Item__c pl3 = new Apttus_Proposal__Proposal_Line_Item__c(          
     Apttus_Proposal__Quantity__c=1,
     Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
     Apttus_QPConfig__LineType__c = '',
     Apttus_QPConfig__LineNumber__c = 1, 
     Apttus_QPConfig__ItemSequence__c = 1,
     Apttus_QPConfig__NetPrice__c=1,
     APTS_Media_High_Level__c = 'Online',
     APTS_Media_High_Level_Code__c = '',
     APTS_Cat_L2__c= label.APTS_Clear_Product_Family,
     APTS_Product_Family__c='CLEAR',                    
     Apttus_Proposal__Proposal__c=proposal.id,apts_cat_l5__c='l5_l1341_fp');
     
   proplist.add(pl3);
   insert proplist;
   
   Apttus_QPConfig__ProposalProductAttributeValue__c a2 = new Apttus_QPConfig__ProposalProductAttributeValue__c(SCS_Print_Purchase_Options__c='Ship & Enter Sub APP',Apttus_QPConfig__LineItemId__c=pl2.id);
   insert a2; 
   
    /*Account testAcc1 = UnitTest.getAccountInstance();
   testAcc1.SAPAccountNumber__c = '12346';
   testAcc1.Sales_Org__c = 'WEST';
   insert testAcc1;*/
   
    IXOSCodeMap__c codeMap=new IXOSCodeMap__c(name='WEST',Company_Code__c='0010',Dist_Chan_Code__c='W',Division_Code__c='W',Sales_Org_Code__c='WEST');
    insert codeMap;
     
   
      Attachment attach1=new Attachment();     
      attach1.Name='AVC Order Form';
      Blob bodyBlob1=Blob.valueOf('Signed Contract Body');
      attach1.body=bodyBlob1;
      attach1.parentId=proposal.id;
      insert attach1;
      
      // Insert Files as attachments
    
       ContentVersion conVer1 = new ContentVersion();
       conVer1.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
       conVer1.PathOnClient = 'Demo.docx'; // The files name, extension is very important here which will help the file in preview.
       conVer1.Title = 'signed Demo.docx'; // Display name of the files
       conVer1.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
       insert conVer1;
              
   
       Id conDoc1 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer1.Id].ContentDocumentId;
    
       //Create ContentDocumentLink

       ContentDocumentLink cDe1 = new ContentDocumentLink();
       cDe1.ContentDocumentId = conDoc1;
       cDe1.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
       cDe1.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
       insert cDe1; 
   
  s=APTS_ProposalUtilities.validateProposalForSignatureBlock(proposal.id);
  s1=APTS_ProposalUtilities.validateProposalForManualOrderSubmission(proposal.id);
  s2=APTS_ProposalUtilities.validateProposalForAssentFields(proposal.id);
  s3=APTS_ProposalUtilities.generateAVC(proposal.id);
  s4=APTS_ProposalUtilities.sendEmail(proposal.id,'test1@thomsonreuters.com');
   /*  ContentVersion conVer2 = new ContentVersion();
       conVer2.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
       conVer2.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
       conVer2.Title = 'signed Demo.pdf'; // Display name of the files
       conVer2.VersionData = blob.valueOf('Test File'); // converting your binary string to Blog
       insert conVer1;
              
   
       Id conDoc2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer2.Id].ContentDocumentId;
    
       //Create ContentDocumentLink

       ContentDocumentLink cDe2 = new ContentDocumentLink();
       cDe2.ContentDocumentId = conDoc2;
       cDe2.LinkedEntityId = proposal.Id; // you can use objectId,GroupId etc
       cDe2.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
       insert cDe2; 
      s4=APTS_ProposalUtilities.sendEmail(proposal.id,'test1@thomsonreuters.com');*/
  Test.stopTest();
  }
   
     }