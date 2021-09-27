@isTest(seealldata=true)

public class createQuoteLatAm_Test{

    public static testMethod void testCreateQuote() {
    
        try{
    
            //-------test records creation BEGIN---------
           /* KeyValueListStore__c kvs= new KeyValueListStore__c();
            kvs.name= 'ANZUsersProfileId';
            kvs.TextValue__C = '00e30000001ZUki';        
            insert kvs;
            
                       
            RecordtypeIds__c recT= new RecordtypeIds__c();
            recT.name= 'Pre-Pipeline Opportunities';
            recT.recTypeId__C = '012a0000001ZJxn';        
            insert recT;
            
            RecordtypeIds__c recT1= new RecordtypeIds__c();
            recT1.Name= 'Pipeline Opportunities';
            recT1.recTypeId__C = '012a0000001ZJxn';
            insert recT1;
            
            LatamGeneral__c lg= new LatamGeneral__c();
            lg.Name= 'Opp Stage 1';
            lg.Value__C = '1%';
            insert lg;*/
            
           /* BigRuleGenericSettings__c bg= new BigRuleGenericSettings__c();
            bg.Name= 'QS:TSL';
            bg.Value__C = 'review,draft';
            insert bg;*/ 
            list<opportunity>insertOpportunityList = new list <opportunity>();
            Account testAcc = UnitTest.getAccountInstance();
            testAcc.Sales_Org__c = 'TSL';
            insert testAcc;
            
            Product2 testProd1 =UnitTest.getProductInstance();
            testprod1.IsActive = true;
            insert testProd1;
            
            PricebookEntry testEntry = new PricebookEntry(isactive=true,Pricebook2id=Test.getStandardPricebookId(),Product2Id=testProd1.id,unitprice=200);
            insert testEntry;
            
            Opportunity testOpp1 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp1.name='MyOppty';
            testOpp1.Selling_Organization__c = 'LRA';
            testopp1.Pricebook2Id = Test.getStandardPricebookId();
           // testOpp1.StageName = BigRuleGenericSettings__c.getInstance('QS:TSL').Value__c;
            testOpp1.StageName = '75%';
            insertOpportunityList.add (testOpp1);
            
            Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc.Id);
            testOpp2.name='MyOppty_withoutQuote';
            testOpp2.Selling_Organization__c = 'LRA';
            testopp2.Pricebook2Id = Test.getStandardPricebookId();
            testOpp2.StageName = '50%';
            insertOpportunityList.add (testOpp2);
            
            insert insertOpportunityList;
            
            list<OpportunityLineItem > olinitemList = new list <OpportunityLineItem >();
            OpportunityLineItem testLineItem = new OpportunityLineItem(opportunityId=testOpp1.id,PricebookEntryId=testEntry.id,unitprice=100,Quantity=1);
            insert testLineItem;
            olinitemList.add(testLineItem);
            
            set<Id> opportunityIdset=new set<Id>();
            opportunityIdset.add(testOpp1.id);
      		
            Quote Q1 = New Quote ();
            Q1.OpportunityId = Testopp1.id;
            Q1.Pricebook2Id = Test.getStandardPricebookId();
            Q1.Name = 'Quote_MyOppty';
            insert Q1;
            /*List<QuoteLineItem> oQuoteLineItem = new List<QuoteLineItem>();
            QuoteLineItem testquoteLineItem = new QuoteLineItem() ;
            testquoteLineItem.QuoteId = Q1.id;
            testquoteLineItem.PricebookEntryId = testentry.Id;
            testquoteLineItem.Quantity = 1;
            testquotelineItem.UnitPrice = 200;
            insert testQuoteLineItem;
            oQuoteLineItem.add(testQuoteLineItem);*/
            
      
           Test.startTest();
           string str= createQuote.triggerQuoteCreationFrmOpp(testOpp1.id);
           createQuote.triggerQuoteCreationFrmOpp(testOpp2.id);
   			createQuote.triggerQuoteCreationFrmAcc(testAcc.id);
          	createQuote.getQuoteLineItems(olinitemList,Q1.Id);
          	createQuote.getOppLineItem (opportunityIdset);
           Test.stopTest(); 
           
        }Catch(DMLException dmlex){
            throw dmlex;
        
        }
        catch(Exception ex){
            throw ex;
        }
    }
}