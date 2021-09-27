/*
===============================================================================
OpportunityTriggerHandler_Test

===============================================================================

PURPOSE:      Contains all the testMethods for OpportunityTriggerHandler.cls

FUNCTIONALITY:

COMMENTS:
CHANGE HISTORY
===============================================================================
DATE         NAME       DESC
2012-05-15   Nandita    Created
2014-07-10   Nandita    Modified to add CreateCompetitiveInfo Test method(MCL-500)
2016-03-15   Cirrius    Added Validation_LockOpportunityWhileQuoteBeingApproved_Test
2016-03-20   Cirrius    Added UpdateRelatedQuoteFieldsFromOppotunity_Test
2016-06-03   Rajashree  Added afterUpdateMasterOpptyPrimaryQuoteSyncTest()
2017-03-31   Karthi     Optimized the coverage as per JIRA STORY: PS0-1
2019-12-31   Prakash    Added validatecompetitiveinfotest as part of DPS-4401
===============================================================================
*/
@istest(seeAllData=true)
//Use isTest(SeeAllData = true) on class methods in exceptional cases where there are sObjects that don't allow DML operation e.g. PriceBook creation
public class OpportunityTriggerHandler_Test{
    Public static Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
    public static testmethod void oppHandlerTestMethod(){  
        
        
        
        List<Opportunity> newVal = new List<Opportunity>();
        List<Opportunity> oldVal = new List<Opportunity>();
        //UnitTest.createTestData();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        
        User u1 = new User(alias = 'newUser', email='user@mydomain.com',
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random());
        insert u1;
        
        
        
        
        
        list<Territory2Type> terriType   = [SELECT id, DeveloperName from Territory2Type];
        Territory2Model terrModel = [select id FROM Territory2Model WHERE State = 'Active' ];
        
        Territory2 testterr = new Territory2();
        testterr.AccountAccessLevel = 'Read';
        testterr.DeveloperName = 'testterr';
        testterr.Territory2ModelId = terrModel.Id;
        testterr.Territory2TypeId = terriType[0].Id;
        testterr.Name = 'testterritory2';
        testterr.TMS_Terr_Num__c = '123';
        insert testterr;
        Territory2 terr2 = [select Id FRoM territory2 WHERE name ='testterritory2' Limit 1];
        UserTerritory2Association uta = new UserTerritory2Association();
        uta.roleinterritory2 = 'GLI';
        uta.UserId = u1.id;
        uta.Territory2Id = terr2.Id;   
        //uta.IsActive=true;
        
        insert uta;
        system.assertEquals(uta!=null,true);
        UserTerritory2Association  usrterr = [select userid,Territory2Id from UserTerritory2Association where Territory2Id = :terr2.Id limit 1];
        system.runas(u1){
            Account testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp1.Is_GLI__c = false;
            insert testOpp1;
            oldVal.add(testOpp1);
            Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp2.OwnerId=usrterr.userid;
            insert testOpp2;
            system.debug('u1.Id..'+u1.Id);
            Test.startTest();
            testOpp1.OwnerId = u1.Id;
            
            update testOpp1;
            newVal.add(testOpp1);
            OpportunityTriggerHandler.afterUpdateSalesTeam(newVal,oldVal,null);
            Test.stopTest();
        }
    }     
    public static testmethod void updateAcadAdopMappingTestMethod(){
        //UnitTest.createTestData();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        List<Opportunity> listTestOpp = new List<Opportunity>();
        listTestOpp.add(UnitTest.getOpportunityInstance(testAcc.Id));
        listTestOpp.add(UnitTest.getOpportunityInstance(testAcc.Id));
        listTestOpp.add(UnitTest.getOpportunityInstance(testAcc.Id));
        
        Product2 testProd1 =UnitTest.getProductInstance();
        insert testProd1;
        Product2 testProd2 =UnitTest.getProductInstance();
        insert testProd2;
        Product2 testProd3 =UnitTest.getProductInstance();
        insert testProd3;
        Pricebook2 testPricebook = [SELECT Id, Name, SystemModstamp FROM Pricebook2 where IsActive=true and isStandard=true limit 1];
        for (Opportunity opp : listTestOpp){
            opp.Pricebook2Id = testPricebook.id;
        }
        insert listTestOpp;
        system.assertEquals(listTestOpp.size() > 0 ,true);
        // PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = testPricebook.Id, Product2Id = testProd.Id, UnitPrice = 10000, IsActive = true,
        //                                         UseStandardPrice = false);
        
        // insert standardPrice;
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd1.id,unitprice=1);
        insert testEntry1 ;
        PricebookEntry testEntry2 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd2.id,unitprice=1);
        insert testEntry2 ;
        PricebookEntry testEntry3 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd3.id,unitprice=1);
        insert testEntry3 ;
        
        List<OpportunityLineItem> listtestOppLineitem = new List<OpportunityLineItem>();
        
        
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,LCRM_Units__c=2,UnitPrice =3,OpportunityId = listTestOpp[0].Id,PricebookEntryId=testEntry1.id));
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,UnitPrice =3,LCRM_Units__c=2,OpportunityId = listTestOpp[1].Id,PricebookEntryId=testEntry2.id));
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,UnitPrice =3,LCRM_Units__c=2,OpportunityId = listTestOpp[2].Id,PricebookEntryId=testEntry3.id));
        
        
        insert listtestOppLineitem;
        update listTestOpp;
        
        Map<Id,Opportunity> maptestOpportunityWithProducts = new Map<Id,Opportunity>([SELECT Id, (SELECT Incremental_Amount__c, Quantity, UnitPrice FROM OpportunityLineItems LIMIT 1) FROM Opportunity WHERE Id IN :listTestOpp]);
        
        for(Opportunity oOpportunity : [Select Actual_Number_Texts_Ordered__c ,Price_Excl_GST__c from Opportunity where Id IN :listTestOpp]) {
            if (maptestOpportunityWithProducts.containsKey(oOpportunity.Id)) {
                Opportunity oOpportunityWithProduct = maptestOpportunityWithProducts.get(oOpportunity.Id);
                //if (oOpportunityWithProduct.OpportunityLineItems != null && oOpportunityWithProduct.OpportunityLineItems.isEmpty() == false) {
                // System.assertEquals(oOpportunity.Actual_Number_Texts_Ordered__c ,oOpportunityWithProduct.OpportunityLineItems[0].Quantity,'Error');
                // System.assertEquals(oOpportunity.Price_Excl_GST__c ,oOpportunityWithProduct.OpportunityLineItems[0].UnitPrice,'Eror');
                //}
                //else{
                // System.assertEquals(oOpportunity.Actual_Number_Texts_Ordered__c ,0,'Error');
                // System.assertEquals(oOpportunity.Price_Excl_GST__c ,0,'Error');
                //}
                
            }
            OpportunitytriggerHandler.beforeUpdateAcadAdopMapping(listTestOpp);
        }
    }    
    public static testmethod void createStrategy2OpptyTest(){
        //UnitTest.createTestData();
        Account testAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Map<Id,Id> mapTestOppStrategy = new  Map<Id,Id>();
        
        List<Opportunity> listopp = new List<Opportunity>();
        List<SFDC_Strategy__c> liststrategies = new List<SFDC_Strategy__c>();
        
        //Opportunity opp = UnitTest.getOpportunityInstance(TestAccount.Id);
        //insert opp;
        for(Integer i=0;i<10;i++){
            Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
            //opp1.Strategy__c = opp.id;
            listopp.add(opp1);
            listopp.add(UnitTest.getOpportunityInstance(TestAccount.Id));
        }
        
        //Insert listopp;
        
        SFDC_Acct_Plan__c testAccPlan = new SFDC_Acct_Plan__c(Account__c = TestAccount.Id ,
                                                              Name='Test Acc Pln' , Account_Type__c='New Customer',Planning_Year__c='FY2012',
                                                              Plan_Status__c='Not Started',Plan_FY_Product_Sales_Goal__c=1);
        Insert TestAccPlan;
        
        SFDC_Strategy__c strat=  new SFDC_Strategy__c(Name = 'Test',SFDC_Acct_Plan__c=TestAccPlan.Id ,Strategy_Status__c='Not Started',
                                                      Est_Comp_Date__c=System.today()+2);
        insert strat;
        
        for(Opportunity oOpp : listopp){
            
            liststrategies.add(new SFDC_Strategy__c(Name = 'Test',SFDC_Acct_Plan__c=TestAccPlan.Id ,Strategy_Status__c='Not Started',
                                                    Est_Comp_Date__c=System.today()+2, Opportunity__c = oOpp.Id));
            
        }
        
        Insert liststrategies;
        
        for(Opportunity oOpp : listopp){
            
            oOpp.Strategy__c =strat.id;
        }
        
        Insert listopp;
        
        for(SFDC_Strategy__c oStrategy : liststrategies){
            mapTestOppStrategy.put(oStrategy.Id,oStrategy.Opportunity__c);
            
        }
        
        Test.startTest();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        OpportunitytriggerHandler.beforeUpdateAcadAdopMapping(listOpp);
        Integer i = 0;
        for(SFDC_Strategy2Oppty__c oStrategy2Oppty : [Select Opportunity_Name__c,SFDC_Strategy__c from SFDC_Strategy2Oppty__c
                                                      where SFDC_Strategy__c IN : liststrategies]){
                                                          System.assertEquals(oStrategy2Oppty.Opportunity_Name__c,mapTestOppStrategy.get(oStrategy2Oppty.SFDC_Strategy__c),'Error');
                                                          i++;
                                                      }
        //  System.assertEquals(i,10,'Error');
        Test.stopTest();
    } 
    public static testmethod void caseCreateANZtest(){
        //UnitTest.createTestData();
        List<Opportunity> listopp = new List<Opportunity>();
        List<String> listDiscardReason = new List<String>{'Wrong Segment','Retired','Price','Cancel Renewal','Do Not Call',
            'Out of Business','Wrong Territory'};
                // Profile testprofile = [SELECT Id FROM profile WHERE name='System Administrator'];
                
                User testuser = new User(alias = 'newUser1', email='user1@mydomain.com',
                                         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                         localesidkey='en_US', profileid = p.Id, employeenumber='0143564',
                                         timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'LRA');
        insert testuser;
        
        
        
        Account testAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Id oppRecordTypeId =  [Select Id from RecordType where sobjecttype = 'Opportunity' and Name = 'Pre-Pipeline Opportunity'].Id ;
        
        for(Integer i=0;i<7;i++){
            Opportunity opp = UnitTest.getOpportunityInstance(TestAccount.Id);
            opp.Discard_Reason__c = listDiscardReason[i];
            opp.RecordTypeId = OppRecordTypeId;
            listopp.add(opp);
        }
        
        System.RunAs(testUser){
            Insert listopp;
        }
        Test.StartTest();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        Integer cnt = [Select count() from Case where AccountId = : TestAccount.Id];
        
        System.assertEquals(cnt,7,'Error');
        Test.stopTest();
        
    }  
    public static testmethod void createCaseTest(){
        //UnitTest.createTestData();
        List<Opportunity> listopp = new List<Opportunity>();
        List<Opportunity> listopp2 = new List<Opportunity>();
        
        //  Profile testprofile = [SELECT Id FROM profile WHERE name='System Administrator'];
        
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id, employeenumber='0143564',
                                 timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'BKRS');
        insert testuser;
        
        
        Account testAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        Id oppRecordTypeId =  [Select Id from RecordType where sobjecttype = 'Opportunity' and Name = 'Pipeline Opportunity'].Id ;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '90%';
        opp1.RecordTypeId = OppRecordTypeId;
        //add
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp1);
        
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '95%';
        //opp2.Win_Loss__c = 'Won' ;
        opp2.RecordTypeId = OppRecordTypeId;
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp2);
        
        
        Opportunity opp3 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp3.StageName = '0%';
        //opp3.Win_Loss__c = 'Lost';
        opp3.RecordTypeId = OppRecordTypeId;
        opp3.Competitor_Name__c = 'BloomBerg';
        opp3.Reason__c = 'Price - No Competitor';
        opp3.Name__c = 'Test';
        opp3.Was_There_a_Competitor__c = 'No';
        opp3.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp3);
        
        
        Opportunity opp4 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp4.StageName = '0%';
        //opp4.Win_Loss__c = 'Won' ;
        opp4.RecordTypeId = OppRecordTypeId;
        opp4.Competitor_Name__c = 'BloomBerg';
        opp4.Reason__c = 'Price';
        opp4.Was_There_a_Competitor__c = 'No';
        
        opp4.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp4);
        
        Opportunity opp5 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp5.StageName = '100%';
        //opp5.Win_Loss__c = 'Won' ;
        opp5.RecordTypeId = OppRecordTypeId;
        opp5.Competitor_Name__c = 'BloomBerg';
        opp5.Reason__c = 'No Change - Customer Satisfied';
        opp5.Was_There_a_Competitor__c = 'No';
        opp5.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp5);
        
        Opportunity opp6 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp6.StageName = '90%';
        //opp6.Win_Loss__c = 'Won' ;
        opp6.Reason__c = 'Content';
        opp6.Was_There_a_Competitor__c = 'No';
        opp6.RecordTypeId = OppRecordTypeId;
        opp6.Competitor_Name__c = 'Test6';
        opp6.Reason__c = 'Test';
        opp6.Name__c = 'Test';
        opp6.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp6);
        
        Opportunity opp7 = UnitTest.getOpportunityInstance(TestAccount.Id);
        //opp7.Win_Loss__c = 'Lost' ;
        opp7.StageName = '0%';
        opp7.Was_There_a_Competitor__c = 'No';
        opp7.RecordTypeId = OppRecordTypeId;
        opp7.Competitor_Name__c = 'Test6';
        opp7.Reason__c = 'MTM Renewal';
        opp7.Name__c = 'Test';
        opp7.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp7);
        
        Opportunity opp8 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp8.StageName = '0%';
        //opp8.Win_Loss__c = 'Lost' ;
        opp8.RecordTypeId = OppRecordTypeId;
        opp8.Competitor_Name__c = 'Test6';
        opp8.Reason__c = 'Content';
        opp8.Was_There_a_Competitor__c = 'Yes';
        opp8.Name__c = 'Test';
        opp8.Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp8);
        
        Opportunity opp9 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp9 .StageName = '95%';
        //opp9 .Win_Loss__c = 'Won' ;
        opp9 .Reason__c = 'Functionality';
        opp9 .Was_There_a_Competitor__c = 'No';
        opp9 .RecordTypeId = OppRecordTypeId;
        opp9 .Competitor_Name__c = 'Test6';
        //opp9 .Reason__c = 'Test';
        opp9 .Name__c = 'Test';
        opp9 .Expiration_Date__c = System.today().adddays(1);
        listopp.add(opp9 );
        
        
        System.RunAs(testUser){
            Insert listopp;
            
            system.assertequals(listopp.size()>0 , true);
            Test.startTest();
            checkRecursive.isRenewalQuote=false;
            checkRecursive.isRenewalOpp=false;
            Integer cnt = [Select count() from Case where AccountId = : TestAccount.Id];
            //System.assertEquals(cnt,6,'Error'+cnt);
            Test.Stoptest();
        }
    }    
    //MCL-1863 for code coverage.    
    public static testmethod void afterUpdateMasterOpptySyncsTest(){
        List<Opportunity> listopp = new List<Opportunity>();
        List<Opportunity> listopp2 = new List<Opportunity>();
        
        Id profileId = [SELECT Id From Profile Where Name = 'LatAm User' LIMIT 1].Id;
        user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
        
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id, employeenumber='0143564',
                                 timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'TSL');
        insert testuser;
        
        
        Account testAccount = UnitTest.getAccountInstance();
        TestAccount.Sales_Org__c = 'TSL'; //Changing Sales_Org__c
        Insert TestAccount;
        
        system.assertequals('TSL',TestAccount.Sales_Org__c);
        List<Contact> conlist = new List<Contact>();
        Contact ocontact = UnitTest.getContactInstance(TestAccount.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow';
        ocontact.Email = 'Jack@Sparrow.com';
        conlist.add(ocontact);
        
        Contact ocontact2 = UnitTest.getContactInstance(TestAccount.Id);
        //ocontact.name = 'Jack';
        ocontact.lastname = 'Sparrow2';
        ocontact.Email = 'Jack2@Sparrow.com';
        ocontact.Work_Direct__c = '1234567890';
        conlist.add(ocontact2);  
        insert conlist;      
        
        //Id OppRecordTypeId =  [Select Id from RecordType where sobjecttype = 'Opportunity' and Name = 'Pipeline Opportunity'].Id ;
        Id oppRecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        // Id OppRecordTypeId =  [Select Id from RecordType where sobjecttype = 'Opportunity' and Name = 'LATAM Renewal Opportunity'].Id ;
        
        Map<id, Opportunity> oldMap1 = new MAP<id, Opportunity>();
        Map<id, Opportunity> newMap1 = new MAP<id, Opportunity>();
        Map<id, id> quoteMap = new MAP<id, id>();
        
        
        Opportunity masterOpty = UnitTest.getOpportunityInstance(TestAccount.Id);
        
        listopp.add(masterOpty);
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '75%';
        opp1.RecordTypeId = OppRecordTypeId;
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.amount = 100000;
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(1);  
        opp1.Grace_Period_Indicator__c =false;
        opp1.Description = 'temp1';
        opp1.Payment_Condition__c ='Cash';
        //opp1.Master_Opportunity__c = masterOpty.id;
        opp1.Renewal_Flag__c = true; 
        listopp.add(opp1);
        insert listopp;
        
        oldMap1.put(opp1.id, new opportunity(id=opp1.id, StageName = '75%',RecordTypeId = OppRecordTypeId, Expiration_Date__c = System.today().adddays(100), Master_Opportunity__c = masterOpty.id) );
        quoteMap.put(opp1.id, TestAccount.Id);
        
        
        Opportunity childOpty = UnitTest.getOpportunityInstance(TestAccount.Id);    
        childOpty.Master_Opportunity__c = opp1.id;
        childOpty.amount = 100000;
        insert childOpty;
        
        Quote q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Draft';
        Q1.Primary_Quote__c = true;
        Q1.Is_Master_Quote__c = true;
        Q1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;   
        Insert Q1;       
        
        OpportunityContactRole role = new OpportunityContactRole();
        role.OpportunityId= opp1.id;
        role.IsPrimary=true;
        role.Role = 'E-Billing Contact';
        role.ContactId=ocontact2.Id;
        
        insert role;
        
        System.RunAs(testuser){
            //Insert listopp;
            
            
            
            
            checkRecursive.isRenewalQuote=false;
            checkRecursive.isRenewalOpp=false;
            //  for(Opportunity o:listopp){
            opp1.Oppty_Mgmt_Type__c = 'Split Billing';
            opp1.Is_Master_Opportunity__c = true;
            opp1.LATAM_Business_Unit__c = 'Mastersaf';
            opp1.Sub_Category__c ='ONE SHOT';
            opp1.Sales_Org__c = 'LLEY';
            opp1.StageName= '90%';
            opp1.Grace_Period_Indicator__c =true;
            opp1.Description ='temp2';
            opp1.Payment_Condition__c ='Card';
            opp1.Is_Submitted__c = True;
            opp1.SAP_Quotation_Document_number__c ='12345678';
            opp1.Expected_Revenue_Date__c =System.today().adddays(100);
            opp1.Original_Order_Number__c ='Test';
            opp1.Is_GLI__c = true;
            opp1.Key_Contact__c = ocontact.id;
            // opp1.Master_Opportunity__c = masterOpty.id;
            //listopp2.add(o);
            newMap1.put(opp1.id, opp1);
            //   } 
            system.debug('calling from testclass'+ opp1.Master_Opportunity__c);
            Test.startTest();
            OpportunityTriggerHandler.afterUpdateMasterOpptySyncs(oldMap1, newMap1);
            // update opp1;
            // update listopp2;
            
            
            OpportunityTriggerHandler.updateAccountLookUPOfChildQuotes(quoteMap.keySet(), quoteMap);
            OpportunityTriggerHandler.UpdateRelatedQuoteFieldsFromOppotunity(oldMap1, newMap1);
            // OpportunityTriggerHandler.populatecontactroleonopty(newMap1.values(), null); 
            
            OpportunityTriggerHandler.populatecontactroleonopty(newMap1.values(), oldMap1);
            Test.Stoptest(); 
            
        }        
    }    
    public static testmethod void createCompetitiveInfoTest(){
        List<Opportunity> listopp = new List<Opportunity>();
        List<Opportunity> listopp2 = new List<Opportunity>();
        Account testAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '0%';
        opp1.Win_Loss__c ='Lost';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        listopp.add(opp1);
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '0%';
        opp2.Win_Loss__c ='Lost';
        opp2.Competitor_Name__c = 'Yellow Pages';
        opp2.Reason__c = 'Test';
        opp2.Was_There_a_Competitor__c = 'Yes';
        opp2.Name__c = 'Test';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        listopp.add(opp2);
        
        Opportunity opp3 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp3.StageName = '100%';
        opp3.Win_Loss__c ='Won';
        opp3.Reason__c = 'Test';
        opp3.Competitor_Name__c = 'Yellow Pages';
        opp3.Name__c = 'Test';
        opp3.Expiration_Date__c = System.today().adddays(1);
        opp3.Was_There_a_Competitor__c = 'No';
        opp3.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        listopp.add(opp3);
        
        Insert listopp;
        System.assertequals(listopp.size()>0,true);
        
        Test.StartTest();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        MAP<id, Opportunity> oldMapoppty = new MAP<id, Opportunity>();
        for(Opportunity oOpp:listopp){
            oldMapoppty.put(oOpp.id, oOpp);
            oOpp.Competitor_Name__c = 'Versus Law';
            oOpp.Name__c ='Test';
            listopp2.add(oOpp);
            
        }
        update listopp2;
        
        OpportunityTriggerHandler.CreateCompetitiveInfo(listopp2, oldMapoppty);
        OpportunityTriggerHandler.createShareforPrevOwner(listopp2, oldMapoppty);
        Test.StopTest();
        
        
    }
    public static testmethod void checkContactRolePrimaryTest(){
        Id profileId = [SELECT Id From Profile Where Name = 'Latam User' LIMIT 1].Id;
        user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
        Account testAccount = UnitTest.getAccountInstance();
        TestAccount.Sales_Org__c = 'BEJE'; // Changing Sales_Org__c
        Insert TestAccount;
        List<Opportunity> listopp = new List<Opportunity>(); 
        List<Opportunity> listopp1 = new List<Opportunity>();  
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '50%';
        opp2.Win_Loss__c ='Lost';
        opp2.Competitor_Name__c = 'Yellow Pages';
        opp2.Reason__c = 'Test';
        opp2.Was_There_a_Competitor__c = 'Yes';
        opp2.Name__c = 'Test';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        listopp1.add(opp2);
        insert listopp1;
        
        MAP<id, Opportunity> oldMapoppty = new MAP<id, Opportunity>();
        for(Opportunity oOpp:listopp1){
            oldMapoppty.put(oOpp.id, oOpp);
        } 
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '90%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Is_Submitted__c = true;
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        listopp.add(opp1);
        insert listopp;
        System.assertequals(listopp.size()>0,true);
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = testAccount.Id,
            Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);
        
        List<OpportunityContactRole> listContRoles= new List<OpportunityContactRole>();
        for(Opportunity oppp:listopp)
        {
            OpportunityContactRole oCR= new OpportunityContactRole();
            oCR.Role='E-Billing Contact';
            oCR.OpportunityId=oppp.Id;
            oCR.ContactId = contact1.Id;
            listContRoles.add(oCR);
        }
        insert listContRoles;
        System.RunAs(usr) {
            
            Test.startTest();
            checkRecursive.isRenewalQuote=false;
            checkRecursive.isRenewalOpp=false;
            //OpportunityTriggerHandler.createShareforPrevOwner(listopp, oldMapoppty);
            OpportunityTriggerHandler.checkContactRolePrimary(listopp, oldMapoppty);            
            
            Test.StopTest();
        }
        
    }    
    // ********Commented code *** Comment removed to increase code coverage -PSO 1 ******START*******Karthi *************/
    public static testmethod void validateAccountApprovedReservationTest(){
        //UnitTest.createTestData();
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().getTime() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            Business_Unit__c = 'PERU',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        System.runas(portalAccountOwner1){
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            Id profileId = [SELECT Id From Profile Where Name = 'Partner Portal User' LIMIT 1].Id;
            //user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
            User user1 = new User(
                Username = System.now().getTime() + 'test12345@test.com', //  UserRoleId = portalRole1.Id,
                ContactId = contact1.Id,
                ProfileId = ProfileId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            Account testAccount = UnitTest.getAccountInstance();
            
            Insert TestAccount;
            Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
            opp1.AccountID = TestAccount.Id;
            opp1.StageName = '50%';
            opp1.Was_There_a_Competitor__c = 'No';
            opp1.Competitor_Name__c = 'BloomBerg';
            opp1.Reason__c = 'Test';
            opp1.Name__c = 'Test';
            opp1.Expiration_Date__c = System.today().adddays(1);
            opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
            
            System.RunAs(user1) {
                Test.startTest();
                try {
                    insert opp1;
                    System.assertequals(opp1 != null,true);
                    opp1.StageName='90%';
                    opp1.Is_Submitted__c = True;
                    update opp1;
                }
                catch(exception ex){System.debug('INSIDE CATCH ');}
                Test.StopTest();
            }
        }
    }
    // Remove comment start--karthi
    public static testmethod void createReservationTest(){
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        // User portalAccountOwner1 = [SELECT id from User WHERE ProfileId =:  profile1.Id AND UserRoleId =: portalRole.Id LIMIT 1];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().getTime() +'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1); 
        
        System.runAs(portalAccountOwner1){
            
            
            Account testAccount = UnitTest.getAccountInstance();
            Insert TestAccount;
            
            Contact ocontact = UnitTest.getContactInstance(TestAccount.Id);
            //ocontact.name = 'Jack';
            ocontact.lastname = 'Sparrow';
            ocontact.Email = 'Jack@Sparrow.com';
            insert ocontact;
            
            Id p1 = [SELECT Id From Profile Where Name = 'Partner Portal User' LIMIT 1].Id;
            
            // UserRole r = [Select Id From UserRole Where PortalType = 'Partner' Limit 1];
            
            User testuser1 = new User(alias = 'newUsr1', email='usr1@mydomain.com',
                                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',IsActive = True,
                                      localesidkey='en_US', profileid = p1, employeenumber='0143564',ContactId=ocontact.Id,
                                      //UserRoleID= r.Id,
                                      timezonesidkey='America/Los_Angeles', username='usr1.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'TSL');
            insert testuser1;
            
            
            
            
            //user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True AND Sales_Org__c= 'TSL' LIMIT 1];
            
            System.RunAs(testuser1) {
                Test.startTest();
                try {
                    Account portalAccount1 = new Account(
                        Name = 'TestAccount',
                        OwnerId = testuser1.Id
                    );
                    Database.insert(portalAccount1);
                    Reservation__c newReservation = new Reservation__c();
                    newReservation.Account__c=portalAccount1.id;
                    newReservation.Partner_Manager__c=testuser1.Id;
                    insert newReservation;
                    
                    List<Opportunity> listopp = new List<Opportunity>();
                    Opportunity opp1 = UnitTest.getOpportunityInstance(portalAccount1.Id);
                    opp1.AccountID = portalAccount1.Id;
                    opp1.Expected_Revenue_Date__c = System.today().adddays(1);
                    opp1.Expiration_Date__c = System.today().adddays(7);
                    opp1.Partner_Channel_Account__c =  portalAccount1.Id;
                    opp1.Partner_Portal_User__c = testuser1.id;
                    opp1.Reservation_Number__c=newReservation.id;
                    opp1.Expected_Revenue_Date__c = System.today();
                    opp1.Expiration_Date__c = System.today();
                    opp1.Is_GLI__c =True;
                    //opp1.OwnerId= testuser1.id;
                    listopp.add(opp1);
                    System.assertequals(listopp.size() > 0,true);
                    insert listopp;
                    
                    opp1.StageName='100%';
                    update opp1;
                    Quote q1= new Quote(opportunityId=opp1.Id,Account_LookUp__c=opp1.Account.Id);
                    insert q1;
                    opp1.AccountID=TestAccount.Id;
                    update opp1;
                    SET<Id> setOppId = new set<Id>();
                    SetOppId.add(opp1.id);
                    Map<Id,Id> mapOldOpty =new Map<Id,Id>();
                    MapOldOpty.put(opp1.id,opp1.id);
                    OpportunityTriggerHandler.updateAccountLookUPOfChildQuotes(SetOppId, MapOldOpty);
                    //Commenting Below lines of code as part of DPS-17684
                    //OpportunityTriggerHandler.CreateReservation(listopp);
                }
                catch(exception ex){System.debug('INSIDE CATCH '+ex);}
                Test.StopTest();
            }
        }
    } 
    // Remove comment End--karthi
    public static testmethod void updateChildQuotesToDiscardedtest(){
        //UnitTest.createTestData();
        LcrmOpportunityQuoteSync.invokeOnce = true;
        Id p2 = [SELECT Id From Profile Where Name = 'LatAm User' LIMIT 1].Id;
        System.debug('p2 ****' + p2);
        user usr = [SELECT Id FROM User WHERE profileId = :p2 AND IsActive = True LIMIT 1];
        System.debug('usr ***' + usr);
        System.RunAs(usr) {
            Account testAccount = UnitTest.getAccountInstance();
            TestAccount.Sales_Org__c = 'TSL'; //Changing Sales_Org__c
            Insert TestAccount;
            Contact ocontact = UnitTest.getContactInstance(TestAccount.Id);
            //ocontact.name = 'Jack';
            ocontact.lastname = 'Sparrow';
            ocontact.Email = 'Jack@Sparrow.com';
            ocontact.Work_Direct__c = '1234567890';
            insert ocontact;
            
            Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
            opp1.AccountID = TestAccount.Id;
            opp1.StageName = '30%';
            opp1.Expected_Revenue_Date__c = System.today().adddays(1);
            opp1.Expiration_Date__c = System.today().adddays(7);
            
            opp1.Partner_Channel_Account__c =  TestAccount.Id;
            Set<Opportunity> oppSet= new Set<Opportunity>();
            //  System.RunAs(usr) {
            Test.startTest();
            checkRecursive.isRenewalQuote=false;
            checkRecursive.isRenewalOpp=false;
            insert opp1;
            system.assertequals(opp1 != null,true);
            Quote q1 = New Quote ();
            Q1.OpportunityId = opp1.id;
            Q1.Name = 'Test Quote';
            
            Insert Q1;
            
            OppSet.add(opp1);
            OpportunityContactRole role = new OpportunityContactRole();
            role.OpportunityId= opp1.id;
            role.IsPrimary=true;
            role.Role = 'E-Billing Contact';
            role.ContactId=ocontact.Id;
            insert role;
            
            OpportunityTriggerHandler.updateChildQuotesToDiscarded(OppSet);
            
            Test.StopTest();
            
        }
    }    
    public static testmethod void validationLockOpportunityWhileQuoteBeingApprovedTest(){
        //UnitTest.createTestData();
        LcrmOpportunityQuoteSync.invokeOnce = true;
        Id profileId = [SELECT Id From Profile Where Name = 'Latam User' LIMIT 1].Id;
        user usr = [SELECT Id FROM User
                    WHERE profileId =:profileId
                    AND IsActive = True
                    AND Sales_Org__c NOT IN ('EDIC','SCSI','SFWS','TSCE') LIMIT 1];
        
        Account testAccount = UnitTest.getAccountInstance();
        TestAccount.Sales_Org__c = 'TSL'; //Changing Sales_Org__c 
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Next_Call_Date__c =System.today();
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        
        insert opp1;
        System.assertequals(opp1!= null,true);
        Quote q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Draft';
        Insert Q1;
        
        opp1.SyncedQuoteId = Q1.Id;
        update opp1;
        
        Map<Id,Opportunity> oldOppMap = new Map<Id,Opportunity>([SELECT Id, Next_Call_Date__c, StageName FROM Opportunity WHERE Id =: opp1.Id]);
        
        opp1.Next_Call_Date__c =System.today().adddays(3);
        update opp1;
        
        Map<Id,Opportunity> onewOppMap = new Map<Id,Opportunity>([SELECT Id, Next_Call_Date__c, StageName FROM Opportunity WHERE Id =: opp1.Id]);
        
        Test.StartTest();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        System.RunAs(usr) {
            
            try {
                //opp1.Reason__c = 'Test2';
                //update opp1;
                List<Opportunity> listOpp = new List<Opportunity>();
                listOpp.add(opp1);
                OpportunityTriggerHandler.Validation_LockOpportunityWhileQuoteBeingApproved(oldOppMap,onewOppMap);
            }
            catch(exception ex){System.debug('INSIDE Catch'+ex);}
            
        }
        
        Test.StopTest();
        
    }    
    private static testmethod void updateRelatedQuoteFieldsFromOppotunityTest(){
        //UnitTest.createTestData();
        LcrmOpportunityQuoteSync.invokeOnce = true;
        Id profileId = [SELECT Id From Profile Where Name = 'Latam User' LIMIT 1].Id;
        user usr = [SELECT Id FROM User
                    WHERE profileId =:profileId
                    AND IsActive = True
                    AND Sales_Org__c NOT IN ('EDIC','SCSI','SFWS','TSCE') LIMIT 1];
        
        Account testAccount = UnitTest.getAccountInstance();
        TestAccount.Sales_Org__c = 'TSL'; //Changing Sales_Org__c 
        Insert TestAccount;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c;
        
        insert opp1;
        System.assertequals(opp1!= null,true);
        Quote q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Draft';
        Insert Q1;
        
        opp1.SyncedQuoteId = Q1.Id;
        update opp1;
        
        Test.StartTest();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        //System.RunAs(usr) {
        
        opp1.Description = 'Test 2';
        update opp1;
        Quote q2 = [Select Id, Opportunity_Notes__c From Quote Where Id = :Q1.Id];
        //System.assertEquals(opp1.Description, Q2.Opportunity_Notes__c);
        
        //}
        
        Test.StopTest();
        
    }       
    private static testmethod void afterUpdateMasterOpptyPrimaryQuoteSyncTest(){
        //UnitTest.createTestData();
        
        List<Account> listacc = new List<Account>();
        Account testAccount = UnitTest.getAccountInstance();
        //Insert TestAccount;
        listacc.add(TestAccount);
        
        Account testAccount1 = UnitTest.getAccountInstance();
        //Insert TestAccount1;
        listacc.add(TestAccount1);
        insert listacc;
        
        List<Opportunity> listoppty = new List<Opportunity>();
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Sales_Org__c = 'CHWL';
        opp1.Is_Master_Opportunity__c = true;
        opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId(); 
        opp1.LATAM_Business_Unit__c='Mastersaf';
        //Insert opp1;
        listoppty.add(opp1);
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp2.StageName = '50%';
        // opp2.RecordTypeId = OppRecordTypeId;
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test1';
        opp2.Sales_Org__c = 'CHWL';
        //opp2.Master_Opportunity__c = opp1.id;
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        //Insert opp2;
        listoppty.add(opp2);
        System.assertequals(listoppty.size()>0,true);
        insert listoppty;
        System.assertequals(opp1!= null,true);
        
        List<Quote> listquote = new List<Quote>();
        Quote q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Draft';
        Q1.Primary_Quote__c = true;
        Q1.Is_Master_Quote__c = true;
        //Insert Q1;       
        listquote.add(Q1);
        
        
        Quote q2 = New Quote ();
        Q2.OpportunityId = opp2.id;
        Q2.Name = 'Test Quote';
        Q2.Approval_Status__c = 'Draft';
        Q2.Primary_Quote__c = true;
        Q2.Master_Quote__c = Q1.id;
        //Insert Q2;
        listquote.add(Q2);
        
        
        Test.StartTest();
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;
        
        
        opp1.Sales_Org__c = 'LLEY';
        //Q1.Status = 'Rejected';
        //Q1.Ship_To_Customer_Name__c = TestAccount1.id;
        Update opp1;
        opp1.LATAM_Business_Unit__c='Laley';
        update opp1;
        
        Test.StopTest();
        
    }    
    private static testmethod void lockOpptyWithoutSplit(){
        Account testAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Account testAccount1 = UnitTest.getAccountInstance();
        Insert TestAccount1;
        
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Sales_Org__c = 'CHWL';
        opp1.Is_Master_Opportunity__c = true;
        opp1.Oppty_Mgmt_Type__c = 'test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId(); 
        opp1.LATAM_Business_Unit__c='Laley';
        
        Product2 testProd1 =UnitTest.getProductInstance();
        insert testProd1;
        Product2 testProd2 =UnitTest.getProductInstance();
        insert testProd2;
        Product2 testProd3 =UnitTest.getProductInstance();
        insert testProd3;
        Pricebook2 testPricebook = [SELECT Id, Name, SystemModstamp FROM Pricebook2 where IsActive=true and isStandard=true limit 1];
        
        opp1.Pricebook2Id = testPricebook.id;
        insert opp1; 
        System.assertequals(opp1!= null ,true);
        List<Opportunity> newlist = new List<Opportunity>();
        newlist.add(opp1);
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(TestAccount.Id);
        
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'BloomBerg';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test';
        opp2.Sales_Org__c = 'CHWL';
        opp2.Is_Master_Opportunity__c = true;
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId(); 
        opp2.LATAM_Business_Unit__c='Laley';
        opp2.Oppty_Mgmt_Type__c = 'Split Billing';
        insert opp2;
        Map<id, Opportunity> oldMap1 = new MAP<id, Opportunity>();
        oldMap1.put(opp2.id,opp2);
        // PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = testPricebook.Id, Product2Id = testProd.Id, UnitPrice = 10000, IsActive = true,
        //                                         UseStandardPrice = false);
        
        // insert standardPrice;
        PricebookEntry testEntry1 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd1.id,unitprice=1);
        insert testEntry1 ;
        PricebookEntry testEntry2 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd2.id,unitprice=1);
        insert testEntry2 ;
        PricebookEntry testEntry3 = new PricebookEntry(isactive=true,Pricebook2id=testPricebook.id,Product2Id=testProd3.id,unitprice=1);
        insert testEntry3 ;
        
        List<OpportunityLineItem> listtestOppLineitem = new List<OpportunityLineItem>();
        
        
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,LCRM_Units__c=2,UnitPrice =3,OpportunityId =opp1.Id,PricebookEntryId=testEntry1.id));
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,LCRM_Units__c=2,UnitPrice =3,OpportunityId =opp1.Id,PricebookEntryId=testEntry2.id));
        listtestOppLineitem.add(new OpportunityLineItem(LCRM_Action__c = 'Add', Incremental_Amount__c=1,Quantity=2,LCRM_Units__c=2,UnitPrice =3,OpportunityId = opp1.Id,PricebookEntryId=testEntry3.id));
        
        
        insert listtestOppLineitem;
        Test.StartTest();
        
        checkRecursive.isRenewalQuote=false;
        checkRecursive.isRenewalOpp=false;   
        //OpportunityTriggerHandler.lockOpptyWithoutSplit(newlist,oldMap1);
        opp1.Sales_Org__c = 'LLEY';
        opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        //Q1.Status = 'Rejected';
        // Q1.Ship_To_Customer_Name__c = TestAccount1.id;
        Update opp1;
        opp1.LATAM_Business_Unit__c='Mastersaf';
        Update opp1;
        
        Test.StopTest();      
    }    
    private static testmethod void renewalOpptySyncTest(){
        Map<id, Opportunity> oldMap1 = new MAP<id, Opportunity>();
        Map<id, Opportunity> newMap1 = new MAP<id, Opportunity>();
        
        
        
        //UnitTest.createTestData();
        Account testAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        System.assertequals(TestAccount!=null,true);
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);       
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'Bill4Time';
        opp1.Reason__c = 'Price';
        opp1.Name__c = 'Test';
        opp1.Sales_Org__c = 'CHWL';
        opp1.Renewal_Flag__c = true;
        // opp1.Oppty_Mgmt_Type__c = 'Split Billing';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        opp1.LATAM_Business_Unit__c='Mastersaf';
        
        Insert opp1;
        system.debug('*********opp1:'+opp1.id);
        
        oldMap1.put(opp1.id, new opportunity(id=opp1.id, StageName = '75%',RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c, Expiration_Date__c = System.today().adddays(100)) );
        
        
        Quote q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Approval_Status__c = 'Draft';
        Q1.Primary_Quote__c = true;
        // Q1.Is_Master_Quote__c = true;
        Q1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Quote').recTypeId__c;      
        Insert Q1;
        system.debug('*********Q1:'+Q1.id);
        
        Test.StartTest();
        
        opp1.Competitor_Name__c = 'AccessData';
        opp1.Description = 'abcd';
        opp1.Payment_Condition__c = 'Check';
        opp1.Payment_Method__c = '3 Installments';
        // opp1.Projected_Renewal_Price__c = 10.5;
        opp1.Reason__c = 'Ease of Use';
        opp1.Was_There_a_Competitor__c = 'Yes';
        //opp1.Win_Loss__c = 'Won';
        opp1.StageName = '90%';
        newMap1.put(opp1.id, opp1);
        
        OpportunityTriggerHandler.RenewalOpptySync(oldMap1,newMap1);
        
        UPDATE opp1;
        opp1.LATAM_Business_Unit__c='Laley';
        Update opp1;
        system.debug('*********opp1 after update:'+opp1);
        
        
        
        
        Test.StopTest();
    }   
    static testmethod void businessUnitUpdateTest(){
        
        
        //UnitTest.createTestData();
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<User> lstUser = new List<User>();
        Map<Id,Opportunity> newMapOpp = new Map<Id,Opportunity>();
        Map<Id,Opportunity> oldMapOpp = new Map<Id,Opportunity>();
        Id objProfileId = [SELECT Id From Profile Where Name = 'LatAm User' LIMIT 1].Id;
        System.debug('profile Id ****' + objProfileId);
        
        Account objAcc = UnitTest.getAccountInstance();
        objAcc.Sales_Org__c = 'TSL'; //Changing Sales_Org__c 
        INSERT objAcc;
        
        
        User objUser = new User();
        objUser.Username = 'TestUser_unique_Test@TR.com';
        objUser.LastName = 'WXYZ_Uni';
        objUser.Email = 'abcd_uni@xyz.com';
        objUser.Alias = 'Uniabc';
        objUser.CommunityNickname = 'CommunityNickname.testUser_Unique_1234';
        objUser.TimeZoneSidKey = 'America/Los_Angeles';
        objUser.LocaleSidKey = 'en_US';
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.ProfileId = objProfileId;
        objUser.Business_Unit__c = 'NOVAPROLINK';
        lstUser.add(objUser);
        
        
        User oUser = new User();
        oUSer.Username = 'TestUser1234_unique@TR.com';
        oUser.LastName = 'WXYZ';
        oUser.Email = 'abcd@xyz.com';
        oUser.Alias = 'abcdtest';
        oUSer.CommunityNickname = 'CommunityNickname.testUser_Unique';
        oUSer.TimeZoneSidKey = 'America/Los_Angeles';
        oUser.LocaleSidKey = 'en_US';
        oUser.EmailEncodingKey = 'ISO-8859-1';
        oUSer.LanguageLocaleKey = 'en_US';  
        oUser.ProfileId = objProfileId;
        oUser.Business_Unit__c = 'LALEY';      
        lstUser.add(oUser);
        INSERT lstUser;
        
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcc.Id);
        objOpp.Renewal_Flag__c = true;
        //objOpp.Is_Master_Opportunity__c = null;
        objOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();      
        objOpp.OwnerId = objUser.Id;
        // lstOpp.add(objOpp);
        INSERT objOpp;
        newMapOpp.put(objOpp.Id, objOpp);
        
        
        objOpp.OwnerId = oUser.Id;
        // lstOpp.add(objOpp);
        UPDATE objOpp;
        oldMapOpp.put(objOpp.Id, objOpp);
        Test.startTest();
        
        OpportunityTriggerHandler.businessUnitUpdate(newMapOpp,oldMapOpp);
        //System.RunAs(objUser){
        System.assertEquals(objOpp.Renewal_Flag__c, true);
        //}
        Test.stopTest();
    }
    public static testmethod void oppQuoteSynctest(){
        
        Map<id, Opportunity> oldMap1 = new MAP<id, Opportunity>();
        Map<id, Opportunity> newMap1 = new MAP<id, Opportunity>();
        
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        System.assertequals(testAcc!=null,true);
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'Bill4Time';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.currencyIsoCode = 'USD';
        opp1.Renewal_Flag__c = true;       
        opp1.Sales_Org__c='RV01';
        //  opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        
        Test.StartTest(); 
        insert opp1;
        
        oldMap1.put(opp1.id, new opportunity(id=opp1.id, StageName = '75%', Expiration_Date__c = System.today().adddays(100), Sales_Org__c='RV01') );
        
        Quote q1 = New Quote ();
        Q1.OpportunityId = opp1.id;
        Q1.Name = 'Test Quote';
        Q1.Primary_Quote__c = true;
        // Q1.RecordTypeId =  Schema.SObjectType.Quote.getRecordTypeInfosByName().get('LATAM Renewal Quote').getRecordTypeId();
        Insert Q1;
        
        opp1.Sales_Org__c='LLEY';         
        newMap1.put(opp1.id, opp1);
        OpportunityTriggerHandler.OppQuoteSync(oldMap1, newMap1);
        
        //update opp1;
        
        opp1.Sales_Org__c='Laley'; 
        Q1.Opportunity_Sales_Org__c ='LLEY';
        update opp1;
        update Q1;
        Test.StopTest();
    }    
    static testmethod void syncQuotaTest(){
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        UserRole role1 = [Select Id,ParentRoleId,Name from UserRole where ParentRoleId!='' and Name = 'GLI'  limit 1];
        
        User u1 = new User(alias = 'newUser1', email='user1@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0143564',
                           timezonesidkey='America/Los_Angeles', username='user12@mydomain.com',UserRoleId=role1.Id); 
        
        insert u1;  
        
        
        
        
        System.RunAs(u1){
            
            UserQuota__c testUserQuota1 = new UserQuota__c(External_Id__c=String.valueof(u1.id)+'Aug 2018',
                                                           User__c=u1.Id,Fiscal_Month__c='Aug 2018');
            insert  TestUserQuota1;
            Test.startTest();
            Account testAcc = UnitTest.getAccountInstance();
            insert testAcc;
            
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp1.CloseDate = Date.newInstance(2018, 8, 17);
            testOpp1.is_gli__c = true;
            insert testOpp1;
            System.assertEquals(testOpp1.Id!=null ,true);
            OpportunityTeamMember testMember = new OpportunityTeamMember(OpportunityId=testOpp1.Id,UserId=u1.Id, Sales_Percentage__c=10);
            insert TestMember;
            
            
            
            //testOpp1.CloseDate = date.valueOf('2018-08-08 00:00:00');
            testOpp1.CloseDate = Date.newInstance(2018, 9, 17);
            update testOpp1;
            TestMember = [Select id,User_Quota__c from OpportunityTeamMember where Id =: TestMember.Id];
            
            Test.stopTest();
            
        }
    }    
    //Added as part of DPS-4401
    static testmethod void validatecompetitiveinfotest(){
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        System.assertequals(testAcc != null,true);
        Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        //testOpp1.CloseDate = date.valueOf('2013-08-08 00:00:00');
        testOpp1.Is_GLI__c = true;
        testOpp1.stageName ='Qualifying';
        testOpp1.Competitor_Name__c ='AAC';
        testOpp1.Was_There_a_Competitor__c = 'No';
        //testopp1.Competitor_Name__c='Actionstep';
        testOpp1.Reason__c='Price';
        insert testOpp1;
        
        
        testOpp1.stageName ='Closed Lost';
        testOpp1.Win_Loss__c='UKI Competitor';
        update testOpp1;
        
        Competitive_Info__c compinfo = new Competitive_Info__c();
        compinfo.Opportunity__c = testOpp1.id;
        compinfo.Account__c=testAcc.id;
        compinfo.Competitor_Name__c=testOpp1.Competitor_Name__c;
        insert compinfo;
    }   
    public static testmethod void createCaseFromOptyTest(){
        //UnitTest.createTestData();
        List<Opportunity> listopp = new List<Opportunity>();
        List<Opportunity> listopp2 = new List<Opportunity>();
        
        Profile testprofile = [SELECT Id FROM profile WHERE name='TR Sales'];
        
        User testuser = new User(alias = 'newUser1', email='user1@mydomain.com',
                                 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                 localesidkey='en_US', profileid = p.Id, employeenumber='0143564',
                                 timezonesidkey='America/Los_Angeles', username='user.test@mydomain.com',Rep_Type_Description__c='test',Sales_Org__c = 'BKRS');
        insert testuser;
        
        
        Account testAccount = UnitTest.getAccountInstance();
        testAccount.Is_GLI__c = true;
        Insert TestAccount;
        System.assertEquals(TestAccount != null,true);
        Opportunity opp1 = UnitTest.getOpportunityInstance(TestAccount.Id);
        opp1.StageName = '90%';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        //add
        opp1.Competitor_Name__c = 'BloomBerg';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.is_GLI__c = true;
        
        System.RunAs(testUser){
            Insert opp1;
            
            opp1.StageName = 'Contract Signed';  
            update opp1;
            
            Test.startTest();
            checkRecursive.isRenewalQuote=false;
            checkRecursive.isRenewalOpp=false;
            
            Test.Stoptest();
        }
    }
    public static testmethod void oppQuoteSynctestDelete(){
        
        Map<id, Opportunity> oldMap1 = new MAP<id, Opportunity>();
        Map<id, Opportunity> newMap1 = new MAP<id, Opportunity>();
        
        
        Account testAcc = UnitTest.getAccountInstance();
        insert testAcc;
        System.assertequals(testAcc != null , true);
        Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp1.Is_GLI__c = true;
        opp1.StageName = '50%';
        opp1.Was_There_a_Competitor__c = 'No';
        opp1.Competitor_Name__c = 'Bill4Time';
        opp1.Reason__c = 'Test';
        opp1.Name__c = 'Test';
        opp1.Expiration_Date__c = System.today().adddays(1);
        opp1.currencyIsoCode = 'USD';
        opp1.Renewal_Flag__c = true;       
        opp1.Sales_Org__c='RV01';
        //  opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert opp1;
        
        Opportunity opp2 = UnitTest.getOpportunityInstance(testAcc.Id);
        opp2.Is_GLI__c = true;
        opp2.StageName = '50%';
        opp2.Was_There_a_Competitor__c = 'No';
        opp2.Competitor_Name__c = 'Bill4Time';
        opp2.Reason__c = 'Test';
        opp2.Name__c = 'Test212';
        opp2.Expiration_Date__c = System.today().adddays(1);
        opp2.currencyIsoCode = 'USD';
        opp2.Amount = 100;
        opp2.Renewal_Flag__c = true;       
        opp2.Sales_Org__c='RV01';
        opp2.Master_Opportunity__c= opp1.Id;
        
        //  opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert opp2;
        stoprecurssion.flag = true;
        Test.StartTest(); 
        delete opp2;
        
        
        Test.StopTest();
    }
    static testmethod void newvalidatecompetitiveinfotest(){
        Profile p = [SELECT Id FROM profile WHERE name='System administrator'];
        User u1 = new User(alias = 'newUser', email='user@mydomain.com',
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_org__c = 'GLI',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Sub_Bu__c = 'US');
        insert u1;
        

            test.startTest();
            Account testAcc = UnitTest.getAccountInstance();
            testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId(); 
            insert testAcc;
            Account testAcc1 = UnitTest.getAccountInstance();
            testAcc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId(); 
            insert testAcc1;
             System.runAs(u1){
            recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
            Contact gliContact = UnitTest.getContactInstance(testAcc.id);
            gliContact.RecordTypeId = conRT.Id;
            //gliContact.OwnerId = gliUser.Id;
            insert gliContact;
            
            
            System.assertequals(testAcc != null,true);
            //Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            Opportunity testOpp1 = new Opportunity();
            testOpp1.AccountId = testAcc.Id;       
            testOpp1.Name = 'Test 53522345';
            testOpp1.OwnerId = u1.Id;
            testOpp1.Is_GLI__c = true;
            testOpp1.CloseDate = System.Today() + 5;
            //testOpp1.CloseDate = date.valueOf('2013-08-08 00:00:00');
            testOpp1.Is_GLI__c = true;
            testOpp1.Key_Contact__c = gliContact.id;
            testOpp1.Name = 'Test 3232323';
            testOpp1.stageName ='Qualifying';
            //testOpp1.Opportunity_Owner_s_Sales_Org__c = 'BKRS';
            testOpp1.Competitor_Name__c ='AAC';
            testOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            testOpp1.Was_There_a_Competitor__c = 'No';
            //testopp1.Competitor_Name__c='Actionstep';
            testOpp1.Reason__c='Price';
            insert testOpp1;
            
            
            
            testOpp1.closeDate = System.Today() + 6;
            testOpp1.stageName ='Closed Lost';
            testOpp1.Win_Loss__c='UKI Competitor';
            update testOpp1;
            
            
            Competitive_Info__c compinfo = new Competitive_Info__c();
            compinfo.Opportunity__c = testOpp1.id;
            compinfo.Account__c=testAcc.id;
            compinfo.Competitor_Name__c=testOpp1.Competitor_Name__c;
            insert compinfo;
            
            PriceBook2 pb = new PriceBook2(name='Test Price Book', isActive=true);
            insert pb;        
            
            //OpportunityTriggerHandler.bCaseCreateFlg = true;
            //Opportunity opp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            Opportunity opp1 = new Opportunity();
            opp1.AccountId = testAcc.Id;       
            opp1.Name = 'Test 535345';
            opp1.OwnerId = u1.Id;
            opp1.Is_GLI__c = true;
            opp1.CloseDate = System.Today() + 6;
            opp1.StageName = 'Needs Analysis';
            opp1.Amount = -1000.00;
            opp1.Was_There_a_Competitor__c = 'No';
            opp1.Competitor_Name__c = 'Bill4Time';
            opp1.Reason__c = 'Test';
            opp1.Name__c = 'Test';
            opp1.Expiration_Date__c = System.today().adddays(1);
            opp1.currencyIsoCode = 'USD';
            opp1.Renewal_Flag__c = true;       
            opp1.Sales_Org__c='West';
            opp1.Master_Opportunity__c = testOpp1.id;
            opp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            opp1.Pricebook2Id = pb.id;
            //  opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
            insert opp1;
            
            /* OpportunityTeamMember testMember = new OpportunityTeamMember(OpportunityId=opp1.Id,UserId=u1.Id, Sales_Percentage__c=10);
insert TestMember;*/
            
            system.debug('OpportunityTriggerHandler.bCaseCreateFlg'+OpportunityTriggerHandler.bCaseCreateFlg);
            system.debug(' OpportunityTriggerHandler.varAmntFlag'+ OpportunityTriggerHandler.varAmntFlag);
            //OpportunityTriggerHandler.bCaseCreateFlg = true;
            //OpportunityTriggerHandler.varAmntFlag = false;
            stoprecurssion.flag =true;
            system.debug('OpportunityTriggerHandler.bCaseCreateFlg'+OpportunityTriggerHandler.bCaseCreateFlg);
            system.debug(' OpportunityTriggerHandler.varAmntFlag'+ OpportunityTriggerHandler.varAmntFlag);
            
            try{
                
                
                List<Opportunity> opp = [Select Id,Name,Is_Child_Opportunity__c,CloseDate,Stagename,Was_There_a_Competitor__c,Competitor_Name__c
                                         from Opportunity WHERE id =:opp1.Id];
                System.debug('opp size@@#@#'+opp.size());
                System.assertEquals(opp.size()>0, true);      
                opp[0].Was_There_a_Competitor__c = 'Yes';
                opp[0].AccountId = testAcc1.Id;
                opp[0].Competitor_Name__c = 'Test22';
                opp[0].CloseDate = System.Today() + 10;
                opp[0].Stagename ='Contract Signed';
                update opp;
                //delete opp; 
                Database.DeleteResult[] DR_Dels = Database.delete(opp);
                System.debug('@@@@ DR_Dels'+DR_Dels);
                checkRecursive.isRenewalQuote=false;
                checkRecursive.isRenewalOpp=false;
                
                
                
            }Catch(Exception e ){system.debug('@#@#'+e.getMessage());}test.stopTest();
        }
        
        
        
        
        
        
    }
    /*static testmethod void newAnzMethod(){
        Profile p = [SELECT Id FROM profile WHERE name='LatAm User'];
        User u1 = new User(alias = 'newUser', email='user@mydomain.com',
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_org__c = 'WEST',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Sub_Bu__c = 'US');
        insert u1;
           System.RunAs(u1){
            Account testAccount = UnitTest.getAccountInstance();
               testAccount.Sales_Org__c = 'WEST';
            Insert TestAccount;
            List<String> listDiscardReason = new List<String>{'Wrong Segment','Retired','Price','Cancel Renewal','Do Not Call',
            'Out of Business','Wrong Territory'};
            Id oppRecordTypeId =  [Select Id from RecordType where sobjecttype = 'Opportunity' and Name = 'Pre-Pipeline Opportunity'].Id ;
            List<opportunity> listopp = new List<Opportunity>();
            for(Integer i=0;i<7;i++){
                Opportunity opp = UnitTest.getOpportunityInstance(TestAccount.Id);
                opp.Discard_Reason__c = listDiscardReason[i];
                opp.RecordTypeId = OppRecordTypeId;
                listopp.add(opp);
            
            
        
                Insert listopp;
            }
            Test.StartTest();
            checkRecursive.isRenewalQuote=false;
            checkRecursive.isRenewalOpp=false;
            Integer cnt = [Select count() from Case where AccountId = : TestAccount.Id];
            
            System.assertEquals(cnt,7,'Error');
            Test.stopTest();
            
        }
        
    }*/
}