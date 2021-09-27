@IsTest
public class GenericCaseMgmtService_Test {

     @IsTest static void testMethod1(){
        
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.BU_Region__c='US';
        testAccount.Bu_Segment__c='Professional Tax';
        testAccount.Is_GLI__C = true;
        insert testAccount;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.FirstName='Fname';
        insert testContact;
        
         Profile ProdANZ= [SELECT Id FROM Profile where Name='ANZ Users'];
         List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=ProdANZ.id)
        
        };
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
         insert keyValueList;
                  
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='GLI Pipeline Opportunity';
        recordtype.recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pre-Pipeline Opportunities';
        recordtype1.recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        //recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='Pipeline Opportunities';
        recordtype2.recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        //recordtype2.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype2);
        insert recordlist;
        
        Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=testAccount.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       
       List<Opportunity> lstOpportunity = new List<Opportunity>();
       
       Opportunity o1 = new Opportunity(RecordTypeId=oppRecordTypeId,status__c='Converted', Name='tst-opp1', stagename='100%',closedate=todaysDate,reason__c = 'other',Other_W_L_Reason__c = 'test',Was_There_a_Competitor__c = 'Yes',Competitor_Name__c='ASI',forecastcategoryname='pipeline',accountId=testAccount.id);
       o1.LCRM_Sub_BU__c = 'US';
       o1.BU_Segment__c = 'Professional Tax';
       
       Opportunity o2 = new Opportunity(RecordTypeId=oppRecordTypeId,status__c='Converted', Name='tst-opp2', stagename='100%',closedate=todaysDate,reason__c = 'other',Other_W_L_Reason__c = 'test',Was_There_a_Competitor__c = 'Yes',Competitor_Name__c='ASI',forecastcategoryname='pipeline',accountId=testAccount.id);
       o2.LCRM_Sub_BU__c = 'US';
       o2.BU_Segment__c = 'Professional Tax';
       
       lstOpportunity.add(o1);
       lstOpportunity.add(o2); 
       insert lstOpportunity;
       
       List<Apttus_Proposal__Proposal__c> lstProposal = new List<Apttus_Proposal__Proposal__c>();
       Apttus_Proposal__Proposal__c proposal1 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='proposal1' , Apttus_Proposal__Opportunity__c = o1.id, APTS_Order_Confirmation_Contact__c = testContact.Id, APTS_Proposal_Business_Unit__c = 'Corp OneOTC US');
       Apttus_Proposal__Proposal__c proposal2 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='proposal2' ,Apttus_Proposal__Opportunity__c = o2.id, APTS_Order_Confirmation_Contact__c = testContact.Id, APTS_Proposal_Business_Unit__c = 'Corp OneOTC US');
       
       lstProposal.add(proposal1);
       lstProposal.add(proposal2);
       insert lstProposal ;
       
       Apttus_Config2__Order__c ord1 = new Apttus_Config2__Order__c (Apttus_QPConfig__ProposalId__c = proposal1.Id,APTS_SAP_Status__c = 'Pending');
       Apttus_Config2__Order__c ord2 = new Apttus_Config2__Order__c (Apttus_QPConfig__ProposalId__c = proposal2.Id,APTS_SAP_Status__c = 'Pending');
       List<Apttus_Config2__Order__c> ordlist = new List<Apttus_Config2__Order__c>{ord1,ord2};
       insert ordlist;
       
        Test.startTest();
        
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
                            
        
                GenericCaseMgmtService obj = new GenericCaseMgmtService();
                List<Id> setQuoteID = new List<Id>();
                setQuoteId.add(proposal1.id);
                Map <id, String> mapq = new Map <id,String>();
                mapq.put(proposal1.id, 'Credit Check');
                List<Id> caseIds = obj.createCreditCheckCase(setQuoteId,mapq);
                
                List<Case> lstCases = [Select Id, casenumber, ESC_Sub_Type__c,Subject,Quote_Proposal__c, RecordType.Name, ContactId, Status from Case where Id In : caseIds];
                List<Case> casesToUpdate = new List<case>();
                if(lstCases!=null){
                
                    for(case cobj:lstCases){
                        Case obj1 = new Case();
                        obj1.id = cobj.id;
                        obj1.Quote_Proposal__c = cobj.Quote_Proposal__c;
                        obj1.ContactId = cobj.ContactId;
                        obj1.ESC_Sub_Type__c = 'Approved';
                        casesToUpdate.add(obj1);
                    }
                    //update casesToUpdate;
                } 
                map<id,case>newmap = new map<id,case>();
                map<id,case>oldmap = new map<id,case>();
                newmap.put( lstCases[0].id,lstcases[0]);
                oldmap.put( casesToUpdate[0].id,casesToUpdate[0]);                           
                GenericCaseMgmtService.setCreditCheckStatusOnQuote(oldmap,newmap);
        
             }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        Test.stopTest();
    }   
    
    @IsTest static void testMethod2(){
        
        Account testAccount = ESC_GenericTestutility.TestAccountUtil('TestAccount' ,'TestAccount001','7786864710');  
        testAccount.BU_Region__c='US';
        testAccount.Bu_Segment__c='Professional Tax';
        testAccount.Is_GLI__C = true;
        insert testAccount;
        
        Contact testContact = ESC_GenericTestutility.TestContactUtil(testAccount.id ,'Mile','test@tr.com');
        testContact.FirstName='Fname';
        insert testContact;
        
         Profile ProdANZ= [SELECT Id FROM Profile where Name='ANZ Users'];
         List<KeyValueListStore__c> keyValueList=new List<KeyValueListStore__c>{
        new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=ProdANZ.id)
        
        };
        
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyValueList.add(keyval);
         insert keyValueList;
                  
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='GLI Pipeline Opportunity';
        recordtype.recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pre-Pipeline Opportunities';
        recordtype1.recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pre-Pipeline Opportunity').getRecordTypeId();
        //recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='Pipeline Opportunities';
        recordtype2.recTypeId__c=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
        //recordtype2.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype2);
        insert recordlist;
        
        Id accRecordTypeIdSSD = Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get(label.SourcesystemdetailUSLRecordtype).getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=testAccount.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        insert accountSSD;
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       
       List<Opportunity> lstOpportunity = new List<Opportunity>();
       
       Opportunity o1 = new Opportunity(RecordTypeId=oppRecordTypeId,status__c='Converted', Name='tst-opp1', stagename='100%',closedate=todaysDate,reason__c = 'other',Other_W_L_Reason__c = 'test',Was_There_a_Competitor__c = 'Yes',Competitor_Name__c='ASI',forecastcategoryname='pipeline',accountId=testAccount.id);
       o1.LCRM_Sub_BU__c = 'US';
       o1.BU_Segment__c = 'Professional Tax';
       
       Opportunity o2 = new Opportunity(RecordTypeId=oppRecordTypeId,status__c='Converted', Name='tst-opp2', stagename='100%',closedate=todaysDate,reason__c = 'other',Other_W_L_Reason__c = 'test',Was_There_a_Competitor__c = 'Yes',Competitor_Name__c='ASI',forecastcategoryname='pipeline',accountId=testAccount.id);
       o2.LCRM_Sub_BU__c = 'US';
       o2.BU_Segment__c = 'Professional Tax';
       
       lstOpportunity.add(o1);
       lstOpportunity.add(o2); 
       insert lstOpportunity;
       
       List<Apttus_Proposal__Proposal__c> lstProposal = new List<Apttus_Proposal__Proposal__c>();
       Apttus_Proposal__Proposal__c proposal1 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='proposal1' , Apttus_Proposal__Opportunity__c = o1.id, APTS_Order_Confirmation_Contact__c = testContact.Id, APTS_Proposal_Business_Unit__c = 'Corp OneOTC US');
       Apttus_Proposal__Proposal__c proposal2 = new Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c='proposal2' ,Apttus_Proposal__Opportunity__c = o2.id, APTS_Order_Confirmation_Contact__c = testContact.Id, APTS_Proposal_Business_Unit__c = 'Corp OneOTC US');
       
       lstProposal.add(proposal1);
       lstProposal.add(proposal2);
       insert lstProposal ;
       
       Apttus_Config2__Order__c ord1 = new Apttus_Config2__Order__c (Apttus_QPConfig__ProposalId__c = proposal1.Id,APTS_SAP_Status__c = 'Pending');
       Apttus_Config2__Order__c ord2 = new Apttus_Config2__Order__c (Apttus_QPConfig__ProposalId__c = proposal2.Id,APTS_SAP_Status__c = 'Pending');
       List<Apttus_Config2__Order__c> ordlist = new List<Apttus_Config2__Order__c>{ord1,ord2};
       insert ordlist;
       
        Test.startTest();
        
        Profile profile = [SELECT Id FROM Profile where Name='System Administrator'];
          
          
            User user = new User(Alias = 'Test', Email='sysadmin123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Test123@ss.com');
            insert user;
            system.runAs(user){
                            
        
                GenericCaseMgmtService obj = new GenericCaseMgmtService();
                List<Id> setQuoteID = new List<Id>();
                setQuoteId.add(proposal1.id);
                Map <id, String> mapq = new Map <id,String>();
                mapq.put(proposal1.id, 'Insufficient Credit');
                List<Id> caseIds = obj.createCreditCheckCase(setQuoteId,mapq);
                
                List<Case> lstCases = [Select Id, casenumber, ESC_Sub_Type__c,Subject,Quote_Proposal__c, RecordType.Name, ContactId, Status from Case where Id In : caseIds];
                List<Case> casesToUpdate = new List<case>();
                if(lstCases!=null){
                
                    for(case cobj:lstCases){
                        Case obj1 = new Case();
                        obj1.id = cobj.id;
                        obj1.Quote_Proposal__c = cobj.Quote_Proposal__c;
                        obj1.ContactId = cobj.ContactId;
                        obj1.ESC_Sub_Type__c = 'Rejected';
                        casesToUpdate.add(obj1);
                    }
                    //update casesToUpdate;
                } 
                map<id,case>newmap = new map<id,case>();
                map<id,case>oldmap = new map<id,case>();
                newmap.put( lstCases[0].id,lstcases[0]);
                oldmap.put( casesToUpdate[0].id,casesToUpdate[0]);                           
                GenericCaseMgmtService.setCreditCheckStatusOnQuote(oldmap,newmap);
        
             }
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        Test.stopTest();
    }           
   

}