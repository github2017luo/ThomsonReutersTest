@isTest(seealldata=false)

public class OppTeamMemberController_Test
{
    public static testMethod void testMethodDel(){
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='OppTeamMemberController1@mydomain.com');        
        insert u1;
        
         KeyValueListStore__c kvs= new KeyValueListStore__c();
        kvs.name= 'ANZUsersProfileId';
        kvs.TextValue__C = String.valueOf([SELECT Id FROM profile WHERE name='ANZ Users'].Id).substring(0, 15);//'00e30000001ZUki';        
        
        KeyValueListStore__c kvs1= new KeyValueListStore__c();
        kvs1.name= 'LCRMSplit_AllowedStages';
        kvs1.TextValue__C = 'Appointment Scheduled,Needs Analysis,Solution Recommended,Generate Contract,Negotiate Contract,Contract Signed,Order Complete,Closed Lost';        
        
        KeyValueListStore__c kvs2= new KeyValueListStore__c();
        kvs2.name= 'LCRMSplit_ExcludeAction';
        kvs2.TextValue__C = 'Remove';        
        
        KeyValueListStore__c kvs3= new KeyValueListStore__c();
        kvs3.name= '    LCRMSplit_ProdLimit';
        kvs3.TextValue__C = '20';        
        
        KeyValueListStore__c kvs4= new KeyValueListStore__c();
        kvs4.name= 'LCRMSplit_TeamLimit';
        kvs4.TextValue__C = '20';        
        
        insert new List<KeyValueListStore__c>{kvs, kvs1, kvs2, kvs3, kvs4};
        
        List<RecordtypeIds__c > recTList = new List<RecordtypeIds__c>();
        RecordtypeIds__c recT= new RecordtypeIds__c();
        recT.name= 'Pre-Pipeline Opportunities';
        recT.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT);
        
        RecordtypeIds__c recT1= new RecordtypeIds__c();
        recT1.Name= 'Pipeline Opportunities';
        recT1.recTypeId__C = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();        
        recTList.add(recT1);
        
        RecordtypeIds__c orecordType5 = new RecordtypeIds__c ();
        orecordType5.name ='LATAM Renewal Opportunity';
        orecordType5.recTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        recTList.add(orecordType5);
        
        RecordtypeIds__c orecordType6 = new RecordtypeIds__c ();
        orecordType6.name ='LATAM Renewal Quote';
        orecordType6.recTypeId__c = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        recTList.add(orecordType6);
        
        insert recTList;
        
        Profile_List__c objPro = new Profile_List__c();
        objPro.name = 'Partner Portal User';
        objPro.Profile_Name__c = 'Partner Portal User';
        objPro.ProfileId__c = [SELECT Id FROM profile WHERE name='Partner Portal User'].Id;//'00ea00000024JzKAAU';'00ea00000024JwaAAE';
        
        Profile_List__c objPro1 = new Profile_List__c();
        objPro1.name = 'LatAm User';
        objPro1.Profile_Name__c = 'LatAm User';
        objPro1.ProfileId__c = [SELECT Id FROM profile WHERE name='LatAm User'].Id;//'00ea00000024JzKAAU';
        
        Profile_List__c objPro2 = new Profile_List__c();
        objPro2.name = 'System Administrator';
        objPro2.Profile_Name__c = 'System Administrator';
        objPro2.ProfileId__c = [SELECT Id FROM profile WHERE name='System Administrator'].Id;//'00e30000001gFezAAE';
        INSERT new List<Profile_List__c>{objPro, objPro1, objPro2};
        
        Product2 testProd1 =UnitTest.getProductInstance();
        testprod1.IsActive = true;
        Product2 testProd2 =UnitTest.getProductInstance();
        testprod2.IsActive = true;
        insert new List<Product2>{testProd1,testProd2};
        
        Id Pricebook2Id = Test.getStandardPricebookId();
        PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Pricebook2Id,Product2Id=testProd1.id,unitprice=200,UseStandardPrice = false);
        System.debug('testEntry : '+testEntry);
        insert new List<PricebookEntry>{testEntry};
        
        Account testAcc = UnitTest.getAccountInstance();
        testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();    
        testAcc.Is_GLI__c = true;    
        insert testAcc;
        
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        testopp1.Pricebook2Id = Pricebook2Id;
        testOpp1.Is_Master_Opportunity__c = true;
        testOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
        testOpp1.Is_GLI__c = TRUE;
        System.debug('Pricebook2Id  : '+testopp1.Pricebook2Id+' : '+Pricebook2Id);
        insert testOpp1;
        Opportunity opp = [select id,Pricebook2Id,Is_GLI__c  from Opportunity where id =:testOpp1.ID];
        System.debug('opp : '+opp);
        opp.Pricebook2Id = Pricebook2Id;
        update opp;
        
        List<OpportunitySplitType> overlayOpportunitySplitTypeId = [ SELECT Id, MasterLabel FROM OpportunitySplitType ];//WHERE MasterLabel = 'New Business Incremental'];
        
        OpportunitySplit oppSplitObj = new OpportunitySplit(); 
        oppSplitObj.OpportunityId = opp.Id;
        oppSplitObj.SplitOwnerId = u1.Id;
        oppSplitObj.SplitPercentage = 100;
        oppSplitObj.SplitTypeId = overlayOpportunitySplitTypeId[0].Id;
        insert oppSplitObj; 
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.ID,unitprice=100,Quantity=1, Revenue_Type__c ='Incremental');
        testLineItem1.LCRM_Units__c = 1;
        System.debug('testLineItem1 : '+testLineItem1);
        insert testLineItem1;
        
        OpportunityTeamMember testMember= new OpportunityTeamMember(OpportunityId=opp.id,UserId=u1.id);
        insert testMember;
        
        System.assertEquals(true,testMember.Id != null);
                
        ApexPages.standardController sc = new ApexPages.standardController(testMember);
        
        OppTeamMemberController oOppTeamMemberController = new OppTeamMemberController(sc);
        oOppTeamMemberController.deleteSalesTeamMember();
    }
}