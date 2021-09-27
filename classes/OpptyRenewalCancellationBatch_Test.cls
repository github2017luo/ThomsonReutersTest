@isTest( seeAllData = false)
public class OpptyRenewalCancellationBatch_Test{

    public static testmethod void unitTest(){
        KeyValueListStore__c keyValue = new KeyValueListStore__c(name='ANZUsersProfileId', TextValue__c = '00e30000001ZUki');
        insert keyValue;
            // KeyValueListStore__c Insert All for update Some Fields When Oppty Closed Lost
            List<KeyValueListStore__c> lstOfKeyStore = new List<KeyValueListStore__c>();
        //For Opportunity
        KeyValueListStore__c KeyvalueStore = new KeyValueListStore__c();
        KeyvalueStore.Name = 'LCRM Oppty Reason';
        KeyvalueStore.TextValue__c = 'Billing System Cancellation';
        lstOfKeyStore.add(KeyvalueStore);

        KeyValueListStore__c KeyvalueStore1 = new KeyValueListStore__c();
        KeyvalueStore1.Name='LCRM Oppty Win Loss'; 
        KeyvalueStore1.TextValue__c = 'Lost';
        lstOfKeyStore.add(KeyvalueStore1);

        KeyValueListStore__c KeyvalueStore2 = new KeyValueListStore__c();
        KeyvalueStore2.Name= 'LCRM Oppty Competitor?';
        KeyvalueStore2.TextValue__c = 'No';
        lstOfKeyStore.add(KeyvalueStore2);
        //End Opportunity

        //For Task type
        KeyValueListStore__c KeyTaskvalueSt = new KeyValueListStore__c();
        KeyTaskvalueSt.name='LCRM Task Type';
        KeyTaskvalueSt.TextValue__c='To Do';
        lstOfKeyStore.add(KeyTaskvalueSt);
        //Task Status
        KeyValueListStore__c KeyTaskstatusval = new KeyValueListStore__c();
        KeyTaskstatusval.name='LCRM Task Status';
        KeyTaskstatusval.TextValue__c='In Progress';
        lstOfKeyStore.add(KeyTaskstatusval);
        //Task Subject
        KeyValueListStore__c KeyTaskSubval = new KeyValueListStore__c();
        KeyTaskSubval.name='LCRM Task Subject';
        KeyTaskSubval.TextValue__c='Please update Customer Cancellation Reason and optional Competitor information on the Opportunity Win/Loss information.';
        lstOfKeyStore.add(KeyTaskSubval);
        //Task Priority
        KeyValueListStore__c KeyTaskPrival = new KeyValueListStore__c();
        KeyTaskPrival.name='LCRM Task Priority';
        KeyTaskPrival.TextValue__c='Normal';
        lstOfKeyStore.add(KeyTaskPrival);
        //Task Value End
        //OpportunityLineIteam Action
        KeyValueListStore__c KeyOpptyProdActionVal = new KeyValueListStore__c();
        KeyOpptyProdActionVal.name='LCRM Oppty Prod Action';
        KeyOpptyProdActionVal.TextValue__c='Cancel';
        lstOfKeyStore.add(KeyOpptyProdActionVal);
        //OpportunityLineIteam LCRM_Cancel_Reason

        KeyValueListStore__c KeyOpptyProdRes = new KeyValueListStore__c();
        KeyOpptyProdRes.name='LCRM Oppty Prod CancelReason';
        KeyOpptyProdRes.TextValue__c='Billing System Cancellation';
        lstOfKeyStore.add(KeyOpptyProdRes);
        //End OpportunityLine Iteam

        if(lstOfKeyStore.size()>0){ 
        insert lstOfKeyStore;
        }
        //
        RecordtypeIds__c rt = new RecordtypeIds__c(name = 'Pre-Pipeline Opportunities', recTypeId__c='01230000001MA4hAAG');
        insert rt;
        RecordtypeIds__c rt1 = new RecordtypeIds__c(name = 'Pipeline Opportunities', recTypeId__c='01230000001MA4gAAG');
        insert rt1;
        RecordtypeIds__c rt2 = new RecordtypeIds__c(name = 'LATAM Renewal Opportunity', recTypeId__c='01213000000AXGKAA4');
        insert rt2;
        RecordtypeIds__c rt3 = new RecordtypeIds__c(name = 'GLI Pipeline Opportunity', recTypeId__c='012e00000000wRJAAY');
        insert rt3;
       /* profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        */
        //
        Product2 testProd =UnitTest.getProductInstance();
        insert testProd;        
        //Standard PricebookEntry 
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry;        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;        
        //Custom PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB.Id,Product2Id=testProd.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;        
        //
         System.assertEquals(testEntry1.pricebook2id, customPB.id);
        //
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        recordtype opptyRT = [select id from recordtype where name ='GLI Pipeline Opportunity' and sobjecttype='Opportunity' limit 1];
        recordtype conRT = [select id from recordtype where name ='GLI Contact' and sobjecttype='Contact' limit 1];
       
        Profile ukiProfile = [SELECT Id FROM profile WHERE name='UKI Users'];
        UserRole ukiRole = [SELECT Id FROM UserRole WHERE Name = 'Legal'];
        PermissionSet trainingPermissionSet = [SELECT Id FROM PermissionSet WHERE name='LCRM_GLI_Training_Users']; 
        
        User gliUser;
        System.runAs(new User(Id=UserInfo.getUserId())){       
            gliUser = UnitTest.getUserInstance();
            gliUser.Username = 'TestUser1@TR.com';
            gliUser.profileid = ukiProfile.Id;
            gliUser.UserRoleId = ukiRole.Id;
            gliUser.Sub_Bu__c = 'UKI';
            insert gliUser;
        
            }
       
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Test Account Training Event';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        gliAccount.OwnerId = gliUser.Id;
        insert gliAccount;
        
        Contact gliContact = UnitTest.getContactInstance(gliAccount.id);
        gliContact.RecordTypeId = conRT.Id;
        gliContact.OwnerId = gliUser.Id;
        insert gliContact;
        
        System.assertEquals(gliContact.AccountId, gliAccount.id);
        
        List<Opportunity> OpptyList = new  List<Opportunity>();
        
        Opportunity gliOpty = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOpty.Name = 'Test Opportunity Training Event';
        gliOpty.Key_Contact__c = gliContact.id;
        gliOpty.Renewal_Flag__c = true;
        gliOpty.currencyIsoCode = 'USD';
        gliOpty.StageName = 'Needs Analysis';
        gliOpty.LCRM_Status__c = 'Cancelled'; 
        gliOpty.LCRM_Cancellation_Process__c = false;
        gliOpty.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOpty.is_gli__c = true;
        gliOpty.LCRM_Sub_BU__c='UKI';
        gliOpty.RecordTypeId = opptyRT.Id;
        gliOpty.CurrencyIsoCode = 'USD';
        gliOpty.Expiration_Date__c=Date.Today();
        gliOpty.OwnerId = gliUser.Id;
        System.debug('gliOpty : '+gliOpty);
        OpptyList.add(gliOpty);
        //insert gliOpty;
           
        //
        
        //Opportunity Product   
        Opportunity gliOptyRenew = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOptyRenew.Name = 'Oppty Renewal Cancellation';
        gliOptyRenew.Key_Contact__c = gliContact.id;
        gliOptyRenew.Renewal_Flag__c = true;
        gliOptyRenew.currencyIsoCode = 'USD';
        gliOptyRenew.StageName = 'Closed Lost';
        gliOptyRenew.Win_Loss__c='Lost';
        gliOptyRenew.Reason__c='Other';
        gliOptyRenew.Was_There_a_Competitor__c ='No';
        
        gliOptyRenew.LCRM_Status__c = 'Open'; 
        gliOptyRenew.LCRM_Cancellation_Process__c = false;
        gliOptyRenew.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOptyRenew.is_gli__c = true;
        gliOptyRenew.LCRM_Sub_BU__c='UKI';
        gliOptyRenew.RecordTypeId = opptyRT.Id;
        gliOptyRenew.CurrencyIsoCode = 'USD';
        gliOptyRenew.Expiration_Date__c=Date.Today();
        gliOptyRenew.OwnerId = gliUser.Id;
        System.debug('gliOptyRenew : '+gliOptyRenew);
        OpptyList.add(gliOptyRenew);
       
        //Pending Cancel Status
        Opportunity gliOptyPendingCancel = UnitTest.getOpportunityInstance(gliAccount.id);
        gliOptyPendingCancel.Name = 'Test Opportunity Training Event';
        gliOptyPendingCancel.Key_Contact__c = gliContact.id;
        gliOptyPendingCancel.Renewal_Flag__c = true;
        gliOptyPendingCancel.currencyIsoCode = 'USD';
        gliOptyPendingCancel.StageName = 'Needs Analysis';
        gliOptyPendingCancel.LCRM_Status__c = 'Pending Cancel'; 
        gliOptyPendingCancel.LCRM_Cancellation_Process__c = false;
        gliOptyPendingCancel.LCRM_Cancellation_Approval_Status__c='Approved'; 
        gliOptyPendingCancel.is_gli__c = true;
        gliOptyPendingCancel.LCRM_Sub_BU__c='UKI';
        gliOptyPendingCancel.RecordTypeId = opptyRT.Id;
        gliOptyPendingCancel.CurrencyIsoCode = 'USD';
        gliOptyPendingCancel.Expiration_Date__c=Date.Today();
        gliOptyPendingCancel.OwnerId = gliUser.Id;
        System.debug('gliOptyPendingCancel : '+gliOptyPendingCancel);
        OpptyList.add(gliOptyPendingCancel);
       
        //check size of Opportunity
        if(OpptyList.size()>0){
            insert OpptyList;
        }
        System.debug('OpptyList:-'+OpptyList);
        //Opportunity Products 
        list<OpportunityLineItem> OpptyProductlist = new list<OpportunityLineItem>();
        OpportunityLineItem testLineItem1 = new OpportunityLineItem(opportunityId=OpptyList[0].id,PricebookEntryId=testEntry.ID,unitprice=100,Quantity=1,LCRM_New_ACV_SalesPrice__c=1,LCRM_Units__c=1, Revenue_Type__c ='Renewal');
        testLineItem1.LCRM_Units__c = 1;
        testLineItem1.LCRM_Action__c= 'Renew'; 
        System.debug('testLineItem1 : '+testLineItem1);
        OpptyProductlist.add(testLineItem1);
        //insert testLineItem1;   
        
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=OpptyList[1].id,PricebookEntryId=testEntry.ID,unitprice=100,Quantity=1,LCRM_New_ACV_SalesPrice__c=1,LCRM_Units__c=1, Revenue_Type__c ='Renewal');
        testLineItem.LCRM_Units__c = 1;
        testLineItem.LCRM_Action__c= 'Renew'; 
        OpptyProductlist.add(testLineItem);
        //
        OpportunityLineItem LineItemPendingCancel = new OpportunityLineItem(opportunityId=OpptyList[2].id,PricebookEntryId=testEntry.ID,unitprice=100,Quantity=1,LCRM_New_ACV_SalesPrice__c=1,LCRM_Units__c=1, Revenue_Type__c ='Renewal');
        LineItemPendingCancel.LCRM_Units__c = 1;
        LineItemPendingCancel.LCRM_Action__c= 'Renew';
        
        System.debug('LineItemPendingCancel : '+LineItemPendingCancel);
        OpptyProductlist.add(LineItemPendingCancel);
            
        if(OpptyProductlist.size()>0){
            insert OpptyProductlist;
        }
        //
        System.assertEquals(OpptyProductlist[0].opportunityId, OpptyList[0].id);
        System.assertEquals(OpptyProductlist[1].opportunityId, OpptyList[1].id);
        System.assertEquals(OpptyProductlist[2].opportunityId, OpptyList[2].id);
        //
        OpptyRenewalCancellation_Batch OpptyRenw = new OpptyRenewalCancellation_Batch();
        Database.executeBatch(OpptyRenw,200);
       }//End Of the UnitTest
      
}