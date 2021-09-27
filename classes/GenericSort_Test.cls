/*
===============================================================================
GenericSort_Test
===============================================================================

PURPOSE:      Contains all testMethods for Generic sort.

FUNCTIONALITY:  

COMMENTS:    

CHANGE HISTORY
===============================================================================
DATE      NAME          DESC
2012-01-16  Partha      Created
===============================================================================
*/
@isTest
public with sharing class GenericSort_Test{
    public static testMethod void sortAscendingTest(){
        Account acc = new account(Name='test');
        insert acc;
        List<Opportunity> opps = new List<Opportunity>();
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random(),Accountid=acc.id));
        } 
        Test.startTest();
        Long start = system.currentTimeMillis();
        opps=GenericSort.sortList(opps,'Amount','asc');
        system.debug('***'+string.valueof(system.currentTimeMillis() - start));
        Test.stopTest(); 
        //Assert the list was sorted correctly
        Decimal assertValue = -1;
        for(Opportunity o : opps){
        //System.debug('Opp value: ' + o.amount);
            System.assert(assertValue <= o.amount);
            assertValue = o.amount;
        } 
        opps=GenericSort.sortList(opps,'Accountid','asc'); 
    } 
    
    public static testMethod void sortDescendingTest(){ 
        List<Opportunity> opps = new List<Opportunity>();
        for(integer i = 0; i<1000; i++){
            opps.add(new Opportunity(Name = 'test' + i, Amount = 1000 * Math.random()));
        } 
        Test.startTest();
        opps=GenericSort.sortList(opps,'Amount','desc');
        Test.stopTest(); 
        //Assert the list was sorted correctly
        Decimal assertValue = 1001;
        for(Opportunity o : opps){
        //System.debug('Opp value: ' + o.amount);
            System.assert(assertValue >= o.amount);
            assertValue = o.amount;
        }  
    }
}