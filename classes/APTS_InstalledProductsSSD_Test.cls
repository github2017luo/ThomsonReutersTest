@isTest

public class APTS_InstalledProductsSSD_Test{ 

    public static testMethod void testData() {
    
        
     
      //Inserting keyvaluestore
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
      //Inserting recordtype
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
      //Inserting account
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
      //Dynamic Retrieval of USL Source System recordType and Creating ssd object
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
      //Inserting oppty 
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
      //Inserting proposal
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_SSD_bill_to__c=accountSSD.Id;
        insert proposal;
       //Inserting product
        Product2 produc=new Product2();
        produc.Name='TestProduct1';
        produc.Apttus_Config2__HasOptions__c=True;
        insert produc;
        
        Apttus_Config2__AssetLineItem__c assetli=new Apttus_Config2__AssetLineItem__c();
        assetli.Apttus_QPConfig__ProposalId__c=proposal.Id;
         assetli.APTS_SSD_Sold_To__c =proposal.APTS_SSD_Sold_To__c;
        assetli.APTS_SSD_Bill_To__c =proposal.APTS_SSD_bill_to__c;
        assetli.Apttus_Config2__IsInactive__c=False;
        assetli.Apttus_Config2__ProductId__c=produc.Id;
        assetli.Apttus_Config2__SellingTerm__c=3.0;
        assetli.Apttus_Config2__Quantity__c=6.0;
        insert assetli;
       
        update assetli;
        Test.startTest();
        apexpages.currentPage().getparameters().put('ssdid', accountSSD.id);
        apexpages.currentPage().getparameters().put('assetline', assetli.id);
        ApexPages.StandardController sc=new ApexPages.StandardController(accountSSD);
        APTS_InstalledProductsSSD pro=new APTS_InstalledProductsSSD(sc);
       // pro.getshipToAssetLines();
        Test.stopTest();
        }
    }