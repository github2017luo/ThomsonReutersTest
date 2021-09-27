/*************************************************************
@Name:           LATAM_BatchToCreateRepAssignment_Test
@Author:         Harshpreet Singh
@CreateDate:     12/1/2019
@Test Class For: LATAM_BatchToCreateRepAssignment
************************************************************/
@isTest(SeeAllData=false)

private class LATAM_BatchToCreateRepAssignment_Test{   
    
    static testMethod void testMethod2_Canada(){
        
        //Create Custom Settings Data      
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        List<CanadaTeamRole__c> listOfCustomSettingsData = new List<CanadaTeamRole__c>();
        CanadaTeamRole__c custSetting1 = new CanadaTeamRole__c();
        custSetting1.Name = 'CARS-Small Legal-Sr Sales Rep';
        custSetting1.Name__c = 'CARS-Small Legal-Sr Sales Rep';
        listOfCustomSettingsData.add(custSetting1);
        
        CanadaTeamRole__c custSetting2 = new CanadaTeamRole__c();
        custSetting2.Name = 'CARS-Small Legal-Sales Rep';
        custSetting2.Name__c = 'CARS-Small Legal-Sales Rep';
        listOfCustomSettingsData.add(custSetting2);
        
        insert listOfCustomSettingsData;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);       
        
        Contact cont=APTS_TestDataFactory.createContact('Last Name',a.id);
        cont.FirstName='First Name';
        cont.Email='abc@gmail.com';
        cont.Phone='1234567890';
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
        
        String username = System.now().getTime() + 'test2@test.com';
        String lastname ='testcoverage';      
        User user_nm = APTS_TestDataFactory.createUser(username,lastname);
        user_nm.Email='user@mydomain.com';
        user_nm.Alias = 'User_3';
        user_nm.Firstname='Test';        
        user_nm.TimeZoneSidKey='America/Chicago'; 
        user_nm.Sub_Bu__c='Corp';
        user_nm.Sales_Force_Description__c='Office';
        user_nm.Rep_Employee_Number__c='X12345678';
        insert user_nm;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
        List<User> usList=new List<User>(); 
        User canadaUser = new User(alias = 'canur_3', email='user2@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Moore',firstname='Linette', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='canadauser_3@mydomain.com');        
        usList.add(canadaUser);
        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');  
        usList.add(u1);      
        insert usList;
        System.runAs ( u1){ 
            Territory2Model tModel=new Territory2Model();
            tModel.name='Thomson Reuters Territories';
            tModel.CurrencyIsoCode='USD';
            tModel.DeveloperName='Thomson_Reuters_Territories1';   
            insert tModel;
            List<Territory2Type> terrType= [SELECT id from Territory2Type where  description= 'CARS-Small Legal-Sr Sales Rep'];
            if(!terrType.isEmpty()){        
            Territory2 terrRecord=new Territory2 ();
            terrRecord.Territory2TypeId =terrType[0].id;
            terrRecord.Territory2Modelid=tModel.id;
            terrRecord.DeveloperName='Thomson_Reuters_Territories1';
            terrRecord.Name='Thomson_Reuters_Territories';
            
            insert terrRecord;
            ObjectTerritory2Association accTerr=new ObjectTerritory2Association ();
            accTerr.ObjectId=a.id;
            accTerr.Territory2Id=terrRecord.id ; 
            accTerr.associationCause='Territory2Manual';
            insert accTerr;
        
            UserTerritory2Association usTerr=new UserTerritory2Association ();
            usTerr.UserId=user_nm.id;
            usTerr.Territory2Id =terrRecord.id;
            insert usTerr;
            }
        }
        AccountTeamMember acctTM = new AccountTeamMember();
        acctTM.AccountId = a.Id;
        acctTM.userId =user_nm.ID;
        acctTM.TeamMemberRole = 'CARS-Small Legal-Sr Sales Rep';
        insert acctTM;
        
        AccountTeamMember acctTM2 = new AccountTeamMember();
        acctTM2.AccountId = a.Id;
        acctTM2.userId =UserInfo.getUserId();
        acctTM2.TeamMemberRole = 'CARS-Small Legal-Sales Rep';
        insert acctTM2;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        
        List<Apttus_Proposal__Proposal__c> lstOfprops = new List<Apttus_Proposal__Proposal__c>();
        for(Integer i = 1; i <= 20; i++){
            Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c (Apttus_Proposal__Account__c=a.Id);
            proposal.Apttus_Proposal__Proposal_Name__c='Renew Canada'+i;
            proposal.Apttus_Proposal__Approval_Stage__c='Void';
            proposal.Apttus_Proposal__Account__c = a.Id;
            proposal.APTS_Proposal_Business_Unit__c='Canada';
            proposal.RecordtypeId = propRecorType;           
            proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
            proposal.Apttus_Proposal__Account__c = a.Id;
            proposal.Apttus_QPConfig__IsSystemGenerated__c =true;
            proposal.Auto_Renewal_Quote__c=true;
            proposal.createdDate = Date.Today();
            lstOfprops.add(proposal);
        }
        Insert lstOfprops ;
        
        Apttus_Config2__PriceList__c priceListCanada = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - Canada');
        insert priceListCanada;
        
        Apttus_Proposal__Proposal__c proposal1= [select name,id,ownerid from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c =: a.Id limit 1];                        
        proposal1.ownerid=acctTM.userId;
        update proposal1;
        
        Apttus_Config2__ProductConfiguration__c config=new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c =proposal1.id);
        insert config;
        
        Product2 product= APTS_TestDataFactory.createProduct('Test Product1', null);
        insert product;
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=priceListCanada.id;
        pli.Apttus_Config2__ProductId__c=product.id;
        pli.Apttus_Config2__ListPrice__c=200;
        insert pli;
        
        Apttus_Config2__AssetLineItem__c ALineitems=new Apttus_Config2__AssetLineItem__c();
        ALineitems.Name='Asset ABC';
        ALineitems.Apttus_QPConfig__ProposalId__c=proposal1.id;
        insert ALineitems;
        
        config.Apttus_Config2__Status__c='Finalized';     
        
        Apttus_Proposal__Proposal_Line_Item__c propLi= new Apttus_Proposal__Proposal_Line_Item__c ();
        propLi.Apttus_QPConfig__ConfigurationId__c = config.id;
        propLi.Apttus_Proposal__Product__c = product.id;
        propLi.Apttus_QPConfig__PriceListId__c = priceListCanada.id;
        propLi.Apttus_QPConfig__PriceListItemId__c = pli.id;
        propLi.Apttus_QPConfig__LineStatus__c = 'renewed';
        propLi.Apttus_Proposal__Quantity__c=1;
        propLi.Apttus_Proposal__Proposal__c=proposal1.id;
        propLi.Apttus_QPConfig__AssetLineItemId__c = ALineitems.id;
        insert propLi;
        
        PriceBook2 pb=new PriceBook2(Name ='TR Pricebook');
        insert pb; 
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.AccountId = a.Id;
        oppty.Name = 'Unit Test Opportuntiy';
        oppty.CloseDate = System.Today() + 5;
        oppty.StageName = 'Prospect';        
        oppty.Sales_Org__c='LLEY';
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Category__c='ONE SHOT';
        oppty.Pricebook2Id =pb.Id;
        insert oppty;
        
        proposal1.Apttus_Proposal__Opportunity__c = oppty.ID;   
        update proposal1;
        
        Test.startTest();
        
        LATAM_BatchToCreateRepAssignment ldProp = new LATAM_BatchToCreateRepAssignment();
        Id batchId = Database.executeBatch(ldProp);
        Database.QueryLocator ql = ldProp.start(null);
        ldProp.execute(null,lstOfprops);
        ldProp.Finish(null);
        Test.stopTest();
    }
}