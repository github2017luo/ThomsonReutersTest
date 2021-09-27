/*************************************************************
@Name:           Latam_AssetRenewalCallbackTest
@Author:         Harshpreet Singh
@CreateDate:     12/1/2019
@Test Class For: Latam_AssetRenewalCustomCallback
************************************************************/
@isTest
public class Latam_AssetRenewalCallbackTest{    
    
    @isTest static void callback_Canada() 
    {        
        //create installed setting custom setting
        Apttus_Config2__InstalledProductsSettings__c installedSetting = new Apttus_Config2__InstalledProductsSettings__c();
        installedSetting.Name = 'Primary Settings';
        installedSetting.Apttus_Config2__RenewalExecutionMode__c = 'OnDemand';
        installedSetting.Apttus_Config2__RenewalDefaultPriceBook__c = 'LOTUS Price Book - Canada';
        installedSetting.Apttus_Config2__RenewalBusinessObjectType__c = 'Proposal';        
        installedSetting.Apttus_Config2__RenewalLeadTime__c = 9999;
        insert installedSetting;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
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
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('LastName',a.id);
        cont.FirstName='FirstName';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';        
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('Account SSD '+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Canada';
        proposal.RecordtypeId = propRecorType;        
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;              
        insert proposal; 
        Test.StartTest();
        
        Latam_AssetRenewalCustomCallback callback = new Latam_AssetRenewalCustomCallback();
        callback.getAssetFilterExpr();
        callback.getConfigProperties(null);
        Test.StopTest();
    }
    
}