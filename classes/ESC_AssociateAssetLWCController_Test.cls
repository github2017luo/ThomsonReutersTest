@isTest(SeeAllData=false)
public class ESC_AssociateAssetLWCController_Test 
{
    static testmethod void testDataFactory1()
    {
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        String caseId1=''; 
        String caseId2='';
        String caseId3='';
        String caseId4='';
        String caseId5='';
        String caseId6='';
        
        //UnitTest.createTestData();
        List<Case> lstCase = new List<Case>();
                system.runAs(testUser){
                    Account testAcc1 = new Account();
                    testAcc1 = UnitTest.getAccountInstance();
                    testAcc1.SAPAccountNumber__c = '5491';
                    insert testAcc1;
                    
                    Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
                    insert c;
                    Source_System_Detail__c ssd= new Source_System_Detail__c(Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',LCRM_SAP_Account_Number__c = '2000000418',Source_System_Account_Number__c='2000000418',Account_Name__c=testAcc1.id);
                    insert SSD;
                    
                   
        //Preparing Case data : set1
        
      
          case objCase1= new case();
              
              
            objCase1.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase1.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase1.ESC_EnquiryType__c='Cancellation';
            objCase1.LCRM_Sub_Bu__c='US';
            objCase1.BU_Segment__c='Professional Tax';
            objCase1.ESC_Case_Type__c='Request For Action';
            objCase1.ESC_Sub_Type__c='Approved';
            objCase1.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            objCase1.ESC_Subscription_Start_Date__c=system.today();
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase1.Status='New';
            objCase1.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase1.ESC_Product_Title__c = 'Global Trade Management';
            objCase1.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase1.Subject = 'Test Cancellation';
            objCase1.AccountId=testAcc1.Id;
            objCase1.ContactId=c.Id;
            
         insert objCase1;
         
         case objCase2= new case();
              
              
            objCase2.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase2.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase2.ESC_EnquiryType__c='Cancellation';
            objCase2.LCRM_Sub_Bu__c='US';
            objCase2.BU_Segment__c='Professional Tax';
            objCase2.ESC_Case_Type__c='Request For Action';
            objCase2.ESC_Sub_Type__c='Approved';
            //objCase2.USL_SAP_Account_Number__c ='76432746';
            objCase2.ESC_Submit_For_Auto_Approval__c=false;
            objCase2.ESC_Subscription_Start_Date__c=system.today().addDays(-70);
            objCase2.ESC_Suspend_Asset__c=true;
            objCase2.Status='New';
            objCase2.AccountId=testAcc1.Id;
            objCase2.ContactId=c.Id;
            
         insert objCase2;
         
         case objCase3= new case();
              
              
            objCase3.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase3.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase3.ESC_EnquiryType__c='Writeoff';
            objCase3.LCRM_Sub_Bu__c='US';
            objCase3.BU_Segment__c='Professional Tax';
            objCase3.ESC_Case_Type__c='Request For Action';
            objCase3.ESC_Sub_Type__c='Non-Revenue Modification';
            objCase3.USL_SAP_Account_Number__c ='76432746';
            objCase3.ESC_Submit_For_Auto_Approval__c=true;
            objCase3.ESC_Subscription_Start_Date__c=system.today().addDays(-70);
            objCase3.ESC_Suspend_Asset__c=false;
            objCase3.Status='New';
            objCase3.AccountId=testAcc1.Id;
            objCase3.ContactId=c.Id;
            
         insert objCase3;
         
        
         case objCase6= new case();
              
              
            objCase6.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase6.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase6.ESC_EnquiryType__c='Modify Subscription';
            objCase6.LCRM_Sub_Bu__c='US';
            objCase6.BU_Segment__c='Professional Tax';
            objCase6.ESC_Case_Type__c='Request For Action';
            objCase6.ESC_Sub_Type__c='Non-Revenue Modification';
            objCase6.USL_SAP_Account_Number__c ='2000000418';
            objCase6.ESC_Submit_For_Auto_Approval__c=false;
            objCase6.ESC_Subscription_Start_Date__c=system.today().addDays(-70);
            objCase6.ESC_Suspend_Asset__c=false;
            objCase6.Status='New';
            objCase6.AccountId=testAcc1.Id;
            objCase6.ContactId=c.Id;
            
         insert objCase6;
         
       
        
        caseId1=objCase1.id;
        caseId2=objCase2.id;
        caseId3=objCase3.id;
        caseId6=objCase6.id;
        
        system.debug('Case 1 Navpreet'+objCase1);
        system.debug('Case 2 Navpreet'+objCase2);
        system.debug('Case 3 Navpreet'+objCase3);
       system.debug('Case 6 Navpreet'+objCase6);
        
         //Creation of Asset Line Items
         
         Apttus_Config2__AssetLineItem__c testAppasset=new Apttus_Config2__AssetLineItem__c();
          testAppasset.Name='TestApptusasset';
          testAppasset.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset.Apttus_Config2__LineType__c='Product/Service';
          testAppasset.TAX_APTS_PO_Number__c = '12345';
          testAppasset.Apttus_Config2__NetPrice__c=700.00000;

          
          Apttus_Config2__AssetLineItem__c testAppasset1=new Apttus_Config2__AssetLineItem__c();
          testAppasset1.Name='TestApptusasset';
          testAppasset1.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset1.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset1.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset1.Apttus_Config2__LineType__c='Product/Service';
          testAppasset1.TAX_APTS_PO_Number__c = '12345';
          testAppasset1.Apttus_Config2__NetPrice__c=700.00000;
          
          Apttus_Config2__AssetLineItem__c testAppasset2=new Apttus_Config2__AssetLineItem__c();
          testAppasset2.Name='TestApptusasset2';
          testAppasset2.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset2.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset2.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset2.Apttus_Config2__LineType__c='Product/Service';
          testAppasset2.TAX_APTS_PO_Number__c = '12345';
          testAppasset2.Apttus_Config2__NetPrice__c=700.00000;
          
          Apttus_Config2__AssetLineItem__c testAppasset3=new Apttus_Config2__AssetLineItem__c();
          testAppasset3.Name='TestApptusasset3';
          testAppasset3.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset3.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset3.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset3.Apttus_Config2__LineType__c='Product/Service';
          testAppasset3.TAX_APTS_PO_Number__c = '12345';
          testAppasset3.Apttus_Config2__NetPrice__c=700.00000;

          List<Apttus_Config2__AssetLineItem__c> assetLI=new List<Apttus_Config2__AssetLineItem__c>();
          
          assetLI.add(testAppasset);
          assetLI.add(testAppasset1);
          assetLI.add(testAppasset2);
          assetLI.add(testAppasset3);
          insert assetLI; 
          
          List<String> listALI=new List<String>();
          List<String> listALIPO=new List<String>();
          listALI.add(testAppasset.id);
          listALI.add(testAppasset1.id);
          listALIPO.add(testAppasset3.id);
          
           
          ESC_Case_Asset_Line_Item__c testCAsset= new ESC_Case_Asset_Line_Item__c();
          testCAsset.ESC_Case__c=objCase1.id;
          testCAsset.ESC_Asset_Line_Item__c=testAppasset2.id;
            insert testCAsset;

           test.starttest();
        
        ESC_AssociateAssetLWCController classConstruct=new ESC_AssociateAssetLWCController();
        
        //ESC_AssociateAssetLWCController.setApprovalFlag(caseId1);
        List<ESC_AssociateAssetLWCController.FatchValueWrapper> fetchPL = ESC_AssociateAssetLWCController.fatchPickListValue();
        ESC_AssociateAssetLWCController.DataTableWrapper oData1 = ESC_AssociateAssetLWCController.getAssetLineItems(caseId1);
        ESC_AssociateAssetLWCController.DataTableWrapper oData6 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId6);
        ESC_AssociateAssetLWCController.DataTableWrapper oData11= ESC_AssociateAssetLWCController.getCaseAssetLineItems(listALI,caseId1,'');
        ESC_AssociateAssetLWCController.DataTableWrapper oData16= ESC_AssociateAssetLWCController.getCaseAssetLineItems(listALIPO,caseId6,'ESC_TAX_APTS_PO_Number__c');
        List<ESC_Case_Asset_Line_Item__c> cAsseLst  = [SELECT id,ESC_Case__c,ESC_Asset_Line_Item__c from ESC_Case_Asset_Line_Item__c where (ESC_Asset_Line_Item__c in :listALI OR ESC_Asset_Line_Item__c in :listALIPO)];
        list<string> csAssetIds = new List<string>();
        for(ESC_Case_Asset_Line_Item__c oCaseLI: cAsseLst){
            if(oCaseLI.ESC_Case__c == caseId1){
                csAssetIds.add(oCaseLI.Id);
            }else{
                csAssetIds.add(oCaseLI.Id);
            }
                
        }
        ESC_AssociateAssetLWCController.setApprovalFlag(caseId1,ListALI,csAssetIds);
        ESC_AssociateAssetLWCController.DataTableWrapper oData116= ESC_AssociateAssetLWCController.updateCaseAssetLI(listALIPO,csAssetIds,caseId6,'ESC_TAX_APTS_PO_Number__c','56789');
        string validationMsg = ESC_AssociateAssetLWCController.finishMethod(listALIPO,csAssetIds,caseId6,'ESC_TAX_APTS_PO_Number__c');
        ESC_AssociateAssetLWCController.DataTableWrapper oData2 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId2);
        ESC_AssociateAssetLWCController.DataTableWrapper oData3 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId3);
        
               test.stoptest();
       }
 }
 
 static testmethod void testDataFactory2()
    {
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        String caseId1=''; 
        String caseId2='';
        String caseId3='';
        String caseId4='';
        String caseId5='';
        String caseId6='';
        
        //UnitTest.createTestData();
        List<Case> lstCase = new List<Case>();
                system.runAs(testUser){
                    Account testAcc1 = new Account();
                    testAcc1 = UnitTest.getAccountInstance();
                    testAcc1.SAPAccountNumber__c = '5491';
                    insert testAcc1;
                    
                    Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
                    insert c;
                    Source_System_Detail__c ssd= new Source_System_Detail__c(Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',LCRM_SAP_Account_Number__c = '2000000418',Source_System_Account_Number__c='2000000418',Account_Name__c=testAcc1.id);
                    insert SSD;
                    
                   
        //Preparing Case data : set1
        
      
          case objCase1= new case();
              
              
            objCase1.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase1.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase1.ESC_EnquiryType__c='Suspend';
            objCase1.LCRM_Sub_Bu__c='US';
            objCase1.BU_Segment__c='Professional Tax';
            objCase1.ESC_Case_Type__c='Request For Action';
            objCase1.ESC_Sub_Type__c='Approved';
            objCase1.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            //objCase1.ESC_Subscription_Start_Date__c=system.today();
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase1.Status='New';
            objCase1.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase1.ESC_Product_Title__c = 'Global Trade Management';
            objCase1.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase1.Subject = 'Test Cancellation';
            objCase1.AccountId=testAcc1.Id;
            objCase1.ContactId=c.Id;
            
         insert objCase1;
         
        case objCase2= new case();
              
              
            objCase2.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase2.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase2.ESC_EnquiryType__c='Unsuspend';
            objCase2.LCRM_Sub_Bu__c='US';
            objCase2.BU_Segment__c='Professional Tax';
            objCase2.ESC_Case_Type__c='Request For Action';
            objCase2.ESC_Sub_Type__c='Approved';
            objCase2.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            //objCase2.ESC_Subscription_Start_Date__c=system.today();
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase2.Status='New';
            objCase2.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase2.ESC_Product_Title__c = 'Global Trade Management';
            objCase2.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase2.Subject = 'Test Cancellation';
            objCase2.AccountId=testAcc1.Id;
            objCase2.ContactId=c.Id;
            
         insert objCase2;
         
         
         case objCase3= new case();
              
              
            objCase3.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase3.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase3.ESC_EnquiryType__c='Modify Future Cancellation';
            objCase3.LCRM_Sub_Bu__c='US';
            objCase3.BU_Segment__c='Professional Tax';
            objCase3.ESC_Case_Type__c='Request For Action';
            objCase3.ESC_Sub_Type__c='Approved';
            objCase3.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            objCase3.ESC_Subscription_Start_Date__c=system.today().addDays(4);
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase3.Status='New';
            objCase3.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase3.ESC_Product_Title__c = 'Global Trade Management';
            objCase3.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase3.Subject = 'Test Cancellation';
            objCase3.AccountId=testAcc1.Id;
            objCase3.ContactId=c.Id;
            
         insert objCase3;
        
        
        caseId1=objCase1.id;
        caseId2=objCase2.id;
        caseId3=objCase3.id;
        //caseId4=objCase4.id;
        //caseId5=objCase5.id;
        //caseId6=objCase6.id;
        
        system.debug('Case 1 Navpreet'+objCase1);
        system.debug('Case 2 Navpreet'+objCase2);
        
         //Creation of Asset Line Items
         
         Apttus_Config2__AssetLineItem__c testAppasset=new Apttus_Config2__AssetLineItem__c();
          testAppasset.Name='TestApptusasset';
          testAppasset.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset.Apttus_Config2__LineType__c='Product/Service';
          testAppasset.TAX_APTS_PO_Number__c = '12345';
          testAppasset.Apttus_Config2__NetPrice__c=700.00000;

          
          Apttus_Config2__AssetLineItem__c testAppasset1=new Apttus_Config2__AssetLineItem__c();
          testAppasset1.Name='TestApptusasset';
          testAppasset1.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset1.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset1.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset1.Apttus_Config2__LineType__c='Product/Service';
          testAppasset1.TAX_APTS_PO_Number__c = '12345';
          testAppasset1.Apttus_Config2__NetPrice__c=700.00000;
          
          Apttus_Config2__AssetLineItem__c testAppasset2=new Apttus_Config2__AssetLineItem__c();
          testAppasset2.Name='TestApptusasset2';
          testAppasset2.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset2.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset2.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset2.Apttus_Config2__LineType__c='Product/Service';
          testAppasset2.TAX_APTS_PO_Number__c = '12345';
          testAppasset2.Apttus_Config2__NetPrice__c=700.00000;
          
          Apttus_Config2__AssetLineItem__c testAppasset3=new Apttus_Config2__AssetLineItem__c();
          testAppasset3.Name='TestApptusasset3';
          testAppasset3.Apttus_Config2__AssetStatus__c='Activated';
          testAppasset3.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset3.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset3.Apttus_Config2__LineType__c='Product/Service';
          testAppasset3.TAX_APTS_PO_Number__c = '12345';
          testAppasset3.Apttus_Config2__NetPrice__c=700.00000;
          
          Apttus_Config2__AssetLineItem__c testAppasset4=new Apttus_Config2__AssetLineItem__c();
          testAppasset4.Name='TestApptusasset3';
          testAppasset4.Apttus_Config2__AssetStatus__c='Pending Cancellation';
          testAppasset4.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset4.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset4.Apttus_Config2__LineType__c='Product/Service';
          testAppasset4.TAX_APTS_PO_Number__c = '12345';
          testAppasset4.Apttus_Config2__NetPrice__c=700.00000;

          List<Apttus_Config2__AssetLineItem__c> assetLI=new List<Apttus_Config2__AssetLineItem__c>();
          
          assetLI.add(testAppasset);
          assetLI.add(testAppasset1);
          assetLI.add(testAppasset2);
          assetLI.add(testAppasset3);
          assetLI.add(testAppasset4);
          insert assetLI; 
          
          List<String> listALI=new List<String>();
          //listALI.add(testAppasset.id);
          //listALI.add(testAppasset1.id);
          //listALI.add(testAppasset3.id);
          listALI.add(testAppasset4.id);
           
          ESC_Case_Asset_Line_Item__c testCAsset= new ESC_Case_Asset_Line_Item__c();
          testCAsset.ESC_Case__c=objCase1.id;
          testCAsset.ESC_Asset_Line_Item__c=testAppasset2.id;
            insert testCAsset;

           test.starttest();
        
        ESC_AssociateAssetLWCController classConstruct=new ESC_AssociateAssetLWCController();
        
        ESC_AssociateAssetLWCController.DataTableWrapper oData3 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId3);
        ESC_AssociateAssetLWCController.DataTableWrapper oData33= ESC_AssociateAssetLWCController.getCaseAssetLineItems(listALI,caseId3,'');
        List<ESC_Case_Asset_Line_Item__c> cAsseLst  = [SELECT id,ESC_Case__c,ESC_Asset_Line_Item__c from ESC_Case_Asset_Line_Item__c where ESC_Asset_Line_Item__c in :listALI];
        list<string> csAssetIds = new List<string>();
        for(ESC_Case_Asset_Line_Item__c oCaseLI: cAsseLst){
            if(oCaseLI.ESC_Case__c == caseId3){
                csAssetIds.add(oCaseLI.Id);
            }else{
                csAssetIds.add(oCaseLI.Id);
            }
                
        }
        ESC_AssociateAssetLWCController.setApprovalFlag(caseId3,ListALI,csAssetIds);
        ESC_AssociateAssetLWCController.DataTableWrapper oData1 = ESC_AssociateAssetLWCController.getAssetLineItems(caseId1);
        ESC_AssociateAssetLWCController.DataTableWrapper oData2 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId2);
        
               test.stoptest();
       }
 }
 
 static testmethod void testDataFactory3()
    {
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        String caseId1=''; 
        String caseId2='';
        String caseId3='';
        String caseId4='';
        String caseId5='';
        String caseId6='';
        
        //UnitTest.createTestData();
        List<Case> lstCase = new List<Case>();
                system.runAs(testUser){
                    Account testAcc1 = new Account();
                    testAcc1 = UnitTest.getAccountInstance();
                    testAcc1.SAPAccountNumber__c = '5491';
                    insert testAcc1;
                    
                    Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
                    insert c;
                    Source_System_Detail__c ssd= new Source_System_Detail__c(Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',LCRM_SAP_Account_Number__c = '2000000418',Source_System_Account_Number__c='2000000418',Account_Name__c=testAcc1.id);
                    insert SSD;
                    
                   
       
         case objCase4= new case();
              
              
            objCase4.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase4.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase4.ESC_EnquiryType__c='Modify Future Cancellation';
            objCase4.LCRM_Sub_Bu__c='US';
            objCase4.BU_Segment__c='Professional Tax';
            objCase4.ESC_Case_Type__c='Request For Action';
            objCase4.ESC_Sub_Type__c='Non-Revenue Modification';
            objCase4.USL_SAP_Account_Number__c ='76432746';
            objCase4.ESC_Submit_For_Auto_Approval__c=false;
            objCase4.ESC_Subscription_Start_Date__c=system.today().addDays(-70);
            objCase4.ESC_Suspend_Asset__c=false;
            objCase4.Status='New';
            objCase4.AccountId=testAcc1.Id;
            objCase4.ContactId=c.Id;
            
         insert objCase4;
         
         case objCase5= new case();
              
              
            objCase5.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase5.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase5.ESC_EnquiryType__c='Suspend';
            objCase5.LCRM_Sub_Bu__c='US';
            objCase5.BU_Segment__c='Professional Tax';
            objCase5.ESC_Case_Type__c='Request For Action';
            objCase5.ESC_Sub_Type__c='Non-Revenue Modification';
            objCase5.USL_SAP_Account_Number__c ='76432746';
            objCase5.ESC_Submit_For_Auto_Approval__c=false;
            objCase5.ESC_Subscription_Start_Date__c=system.today().addDays(-70);
            objCase5.ESC_Suspend_Asset__c=false;
            objCase5.Status='New';
            objCase5.AccountId=testAcc1.Id;
            objCase5.ContactId=c.Id;
            
         insert objCase5;
         case objCase7= new case();
              
              
            objCase7.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase7.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase7.ESC_EnquiryType__c='Cancellation';
            objCase7.LCRM_Sub_Bu__c='US';
            objCase7.BU_Segment__c='Professional Tax';
            objCase7.ESC_Case_Type__c='Request For Action';
            objCase7.ESC_Sub_Type__c='Non-Revenue Modification';
            objCase7.USL_SAP_Account_Number__c ='76432746';
            objCase7.ESC_Submit_For_Auto_Approval__c=true;
            objCase7.ESC_Subscription_Start_Date__c=system.today().addDays(-70);
            objCase7.ESC_Suspend_Asset__c=false;
            objCase7.Status='New';
            objCase7.AccountId=testAcc1.Id;
            objCase7.ContactId=c.Id;
            
         insert objCase7;
         
         case objCase8= new case();
              
              
            objCase8.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase8.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase8.ESC_EnquiryType__c='Cancellation';
            objCase8.LCRM_Sub_Bu__c='US';
            objCase8.BU_Segment__c='Professional Tax';
            objCase8.ESC_Case_Type__c='Request For Action';
            objCase8.ESC_Sub_Type__c='Approved';
            objCase8.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            //objCase8.ESC_Subscription_Start_Date__c=system.today();
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase8.Status='New';
            objCase8.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase8.ESC_Product_Title__c = 'Global Trade Management';
            objCase8.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase8.Subject = 'Test Cancellation';
            objCase8.AccountId=testAcc1.Id;
            objCase8.ContactId=c.Id;
            
         insert objCase8;
        
        test.starttest();
        
        ESC_AssociateAssetLWCController.DataTableWrapper oData4 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId4);
        ESC_AssociateAssetLWCController.DataTableWrapper oData5 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId5);
        ESC_AssociateAssetLWCController.DataTableWrapper oData7 = ESC_AssociateAssetLWCController.getAssetLineItems(objCase7.Id);
        ESC_AssociateAssetLWCController.DataTableWrapper oData8 = ESC_AssociateAssetLWCController.getAssetLineItems(objCase8.Id);
       
               test.stoptest();
       }
 }
 
 static testmethod void testDataFactory4()
    {
        
        Profile testprofile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            Alias = 'oslfu',
            Email = 'testslcccf@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es',
            ProfileId = testprofile.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c = 'USL',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testslcccf@testorg.com'
        );
        insert testUser;
        String caseId1=''; 
        String caseId2='';
        String caseId3='';
        String caseId4='';
        String caseId5='';
        String caseId6='';
        
        //UnitTest.createTestData();
        List<Case> lstCase = new List<Case>();
                system.runAs(testUser){
                    Account testAcc1 = new Account();
                    testAcc1 = UnitTest.getAccountInstance();
                    testAcc1.SAPAccountNumber__c = '5491';
                    insert testAcc1;
                    
                    Contact c=new Contact(AccountID=testacc1.id,firstname='testcon',lastname='contact',email='test@oslcccf.com');
                    insert c;
                    Source_System_Detail__c ssd= new Source_System_Detail__c(Source_System_Name__c='test SSD',LCRM_Market_Segment__c='Solo',LCRM_SAP_Account_Number__c = '2000000418',Source_System_Account_Number__c='2000000418',Account_Name__c=testAcc1.id);
                    insert SSD;
                    
                   
        //Preparing Case data : set1
        
      
          case objCase1= new case();
              
              
            objCase1.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase1.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase1.ESC_EnquiryType__c='Suspend';
            objCase1.LCRM_Sub_Bu__c='US';
            objCase1.BU_Segment__c='Professional Tax';
            objCase1.ESC_Case_Type__c='Request For Action';
            objCase1.ESC_Sub_Type__c='Approved';
            objCase1.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            //objCase1.ESC_Subscription_Start_Date__c=system.today();
            objCase1.ESC_Suspend_Asset__c=true;
            objCase1.Status='New';
            objCase1.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase1.ESC_Product_Title__c = 'Global Trade Management';
            objCase1.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase1.Subject = 'Test Cancellation';
            objCase1.AccountId=testAcc1.Id;
            objCase1.ContactId=c.Id;
            
         insert objCase1;
         
        case objCase2= new case();
              
              
            objCase2.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase2.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase2.ESC_EnquiryType__c='Unsuspend';
            objCase2.LCRM_Sub_Bu__c='US';
            objCase2.BU_Segment__c='Professional Tax';
            objCase2.ESC_Case_Type__c='Request For Action';
            objCase2.ESC_Sub_Type__c='Approved';
            //objCase2.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            //objCase2.ESC_Subscription_Start_Date__c=system.today();
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase2.Status='New';
            objCase2.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase2.ESC_Product_Title__c = 'Global Trade Management';
            objCase2.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase2.Subject = 'Test Cancellation';
            objCase2.AccountId=testAcc1.Id;
            objCase2.ContactId=c.Id;
            
         insert objCase2;
         
         
         case objCase3= new case();
              
              
            objCase3.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Action').getRecordTypeId();
            objCase3.ESC_Case_Sub_Type__c = 'Orders, Pricing & Subscriptions';
            objCase3.ESC_EnquiryType__c='Remove Future Cancellation';
            objCase3.LCRM_Sub_Bu__c='US';
            objCase3.BU_Segment__c='Professional Tax';
            objCase3.ESC_Case_Type__c='Request For Action';
            objCase3.ESC_Sub_Type__c='Approved';
            objCase3.USL_SAP_Account_Number__c ='2000000418';
            //objCase1.ESC_Submit_For_Auto_Approval__c=true;
            objCase3.ESC_Subscription_Start_Date__c=system.today().addDays(4);
            //objCase1.ESC_Suspend_Asset__c=true;
            objCase3.Status='New';
            objCase3.ESC_Product_Segment_Brand__c = 'ONESOURCE';
            objCase3.ESC_Product_Title__c = 'Global Trade Management';
            objCase3.ESC_Resolution_Comment__c = 'Test Cancellation';
            objCase3.Subject = 'Test Cancellation';
            objCase3.AccountId=testAcc1.Id;
            objCase3.ContactId=c.Id;
            
         insert objCase3;
        
        
        caseId1=objCase1.id;
        caseId2=objCase2.id;
        caseId3=objCase3.id;
        //caseId4=objCase4.id;
        //caseId5=objCase5.id;
        //caseId6=objCase6.id;
        
        system.debug('Case 1 Navpreet'+objCase1);
        system.debug('Case 2 Navpreet'+objCase2);
        
         //Creation of Asset Line Items
         
         
          Apttus_Config2__AssetLineItem__c testAppasset4=new Apttus_Config2__AssetLineItem__c();
          testAppasset4.Name='TestApptusasset3';
          testAppasset4.Apttus_Config2__AssetStatus__c='Pending Cancellation';
          testAppasset4.APTS_SSD_Sold_To__c  = ssd.id;
          testAppasset4.Apttus_Config2__AccountId__c=testAcc1.id;
          testAppasset4.Apttus_Config2__LineType__c='Product/Service';
          testAppasset4.TAX_APTS_PO_Number__c = '12345';
          testAppasset4.Apttus_Config2__NetPrice__c=700.00000;

          List<Apttus_Config2__AssetLineItem__c> assetLI=new List<Apttus_Config2__AssetLineItem__c>();
          
          assetLI.add(testAppasset4);
          insert assetLI; 
          
          List<String> listALI=new List<String>();
          //listALI.add(testAppasset.id);
          //listALI.add(testAppasset1.id);
          //listALI.add(testAppasset3.id);
          listALI.add(testAppasset4.id);
           
         
           test.starttest();
        
        ESC_AssociateAssetLWCController classConstruct=new ESC_AssociateAssetLWCController();
        
        ESC_AssociateAssetLWCController.DataTableWrapper oData3 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId3);
        ESC_AssociateAssetLWCController.DataTableWrapper oData33= ESC_AssociateAssetLWCController.getCaseAssetLineItems(listALI,caseId3,'');
        List<ESC_Case_Asset_Line_Item__c> cAsseLst  = [SELECT id,ESC_Case__c,ESC_Asset_Line_Item__c from ESC_Case_Asset_Line_Item__c where ESC_Asset_Line_Item__c in :listALI];
        list<string> csAssetIds = new List<string>();
        for(ESC_Case_Asset_Line_Item__c oCaseLI: cAsseLst){
            if(oCaseLI.ESC_Case__c == caseId3){
                csAssetIds.add(oCaseLI.Id);
            }else{
                csAssetIds.add(oCaseLI.Id);
            }
                
        }
        ESC_AssociateAssetLWCController.setApprovalFlag(caseId3,ListALI,csAssetIds);
        ESC_AssociateAssetLWCController.DataTableWrapper oData1 = ESC_AssociateAssetLWCController.getAssetLineItems(caseId1);
        ESC_AssociateAssetLWCController.DataTableWrapper oData2 =ESC_AssociateAssetLWCController.getAssetLineItems(caseId2);
        
               test.stoptest();
       }
 }
}