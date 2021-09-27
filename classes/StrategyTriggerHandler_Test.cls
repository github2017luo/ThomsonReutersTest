/**
 * Validates the functionality provided by the StrategyTriggerHandler class.
 *
 * @author  Nandita Shet
 * @version  2012-12-20
 */
 
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-15   John De Santiago        Created                                                                   
 * =============================================================================
 */
 
@IsTest(seealldata=true)

private class StrategyTriggerHandler_Test{
    
    public class TestException extends Exception{
    }
    
    public static testmethod void createStrategy2Oppty_Test(){
    
        Account TestAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Map<Id,Id> mapTestOppStrategy = new  Map<Id,Id>();
     
        List<Opportunity> listopp = new List<Opportunity>();
        List<SFDC_Strategy__c> liststrategies = new List<SFDC_Strategy__c>();
        
        for(Integer i=0;i<10;i++){
            listopp.add(UnitTest.getOpportunityInstance(TestAccount.Id));
        }
 
        Insert listopp;
        
        SFDC_Acct_Plan__c TestAccPlan = new SFDC_Acct_Plan__c(Account__c = TestAccount.Id , 
                                            Name='Test Acc Pln' , Account_Type__c='New Customer',Planning_Year__c='FY2012',
                                            Plan_Status__c='Not Started',Plan_FY_Product_Sales_Goal__c=1);
        Insert TestAccPlan;
        
        
        for(Opportunity oOpp : listopp){

            liststrategies.add(new SFDC_Strategy__c(Name = 'Test',SFDC_Acct_Plan__c=TestAccPlan.Id ,Strategy_Status__c='Not Started',
                                           Est_Comp_Date__c=System.today()+2, Opportunity__c = oOpp.Id));
                                                  
        }
        
       
        Insert liststrategies;
        
        for(SFDC_Strategy__c oStrategy : liststrategies){
            mapTestOppStrategy.put(oStrategy.Id,oStrategy.Opportunity__c);
           
        }
        
        Test.startTest();
        Integer i = 0;
         for(SFDC_Strategy2Oppty__c oStrategy2Oppty : [Select Opportunity_Name__c,SFDC_Strategy__c from SFDC_Strategy2Oppty__c 
                                                         where SFDC_Strategy__c IN : liststrategies]){
             System.assertEquals(oStrategy2Oppty.Opportunity_Name__c,mapTestOppStrategy.get(oStrategy2Oppty.SFDC_Strategy__c),'Error');
             i++;
         }                         
        System.assertEquals(i,10,'Error');
        Test.stopTest();                          
    }
    
    
      public static testmethod void Strategy2OpptyDuplicatePreventer_test(){
        Account TestAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Map<Id,Id> mapTestOppStrategy = new  Map<Id,Id>();
        
     
        List<Opportunity> listopp = new List<Opportunity>();
        List<SFDC_Strategy__c> liststrategies = new List<SFDC_Strategy__c>();
        
        for(Integer i=0;i<10;i++){
            listopp.add(UnitTest.getOpportunityInstance(TestAccount.Id));
        }
 
        Insert listopp;
        
        SFDC_Acct_Plan__c TestAccPlan = new SFDC_Acct_Plan__c(Account__c = TestAccount.Id , 
                                            Name='Test Acc Pln' , Account_Type__c='New Customer',Planning_Year__c='FY2012',
                                            Plan_Status__c='Not Started',Plan_FY_Product_Sales_Goal__c=1);
        Insert TestAccPlan;
        
        
        for(Opportunity oOpp : listopp){

            liststrategies.add(new SFDC_Strategy__c(Name = 'Test',SFDC_Acct_Plan__c=TestAccPlan.Id ,Strategy_Status__c='Not Started',
                                           Est_Comp_Date__c=System.today()+2, Opportunity__c = oOpp.Id));
                                                  
        }
         
       
        Insert liststrategies;
        
        for(SFDC_Strategy__c oStrategy : liststrategies){
            mapTestOppStrategy.put(oStrategy.Id,oStrategy.Opportunity__c);
           
        }
        
        
        Test.startTest();
        
        
         for(SFDC_Strategy2Oppty__c oStrategy2Oppty : [Select Opportunity_Name__c,SFDC_Strategy__c from SFDC_Strategy2Oppty__c 
                                                         where SFDC_Strategy__c IN : liststrategies]){
            try{ 
                update oStrategy2Oppty;
                SFDC_Strategy2Oppty__c newStrategy2Opty = new SFDC_Strategy2Oppty__c(Opportunity_Name__c =oStrategy2Oppty.Opportunity_Name__c ,SFDC_Strategy__c = oStrategy2Oppty.SFDC_Strategy__c );                                             
                insert newStrategy2Opty;
                throw new TestException('Error : An exception should have been thrown by the trigger but was not.'); 
            }catch(Exception e)
            {
                System.assertEquals(e.getMessage().contains('The Opportunity has already been added to this Strategy'),true,'Error');
            }   
            
        }                    
       
        Test.stopTest(); 
    
    }
    
    public static testmethod void Strategy2TrainingEventDuplicatePreventer_test(){
        Account TestAccount = UnitTest.getAccountInstance();
        Insert TestAccount;
        
        Map<Id,Id> mapTestTEStrategy = new  Map<Id,Id>();
     
        List<Training_Event__c> listTrainingEvent = new List<Training_Event__c>();
        List<SFDC_Strategy__c> liststrategies = new List<SFDC_Strategy__c>();
        
        SFDC_Acct_Plan__c TestAccPlan = new SFDC_Acct_Plan__c(Account__c = TestAccount.Id , 
                                            Name='Test Acc Pln' , Account_Type__c='New Customer',Planning_Year__c='FY2012',
                                            Plan_Status__c='Not Started',Plan_FY_Product_Sales_Goal__c=1);
        Insert TestAccPlan;
        
        for(Integer i=0;i<10;i++){
            liststrategies.add(new SFDC_Strategy__c(Name = 'Test',SFDC_Acct_Plan__c=TestAccPlan.Id ,Strategy_Status__c='Not Started',
                                           Est_Comp_Date__c=System.today()+2));
            
        }
 
        Insert liststrategies;
       
        
        for(SFDC_Strategy__c oStrategy : liststrategies){

            listTrainingEvent.add(new Training_Event__c(Training_Name__c = 'testTrainingEvent',
                                    Training_Date__c = System.Today(),Status__c = 'Pending',Strategy__c = oStrategy.Id));
                                                  
        }
        
       
        Insert listTrainingEvent;
        
        for(Training_Event__c oTrainingEvent : listTrainingEvent){
            mapTestTEStrategy.put(oTrainingEvent.Strategy__c,oTrainingEvent.Id);
           
        }
        
        Test.startTest();
        
         for(Strategy2TrainingEvent__c oStrategy2TrainingEvent : [Select Training_Event__c,Strategy__c from Strategy2TrainingEvent__c 
                                                         where Strategy__c IN : liststrategies]){
             update oStrategy2TrainingEvent;                                                         
             try{
                 Strategy2TrainingEvent__c newStrategy2TrainingEvent = new Strategy2TrainingEvent__c(Training_Event__c = oStrategy2TrainingEvent.Training_Event__c,
                                                                                                     Strategy__c = oStrategy2TrainingEvent.Strategy__c);    
                 insert newStrategy2TrainingEvent;
                 throw new TestException('Error : Trigger should throw an error but was not');
             }catch(Exception e){
                  System.assertEquals(e.getMessage().contains('The Training Event has already been added to this Strategy'),true,'Error');
             }
         }                         
        
        Test.stopTest();                          
    }
    
    
}