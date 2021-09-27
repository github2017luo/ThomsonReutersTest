@isTest
public class LCRM_Test_LCRM_BU_Marketing_Handler {
    
    @isTest public static void updateInsert (){
        List<Account> firstList = new List<Account>();
        List<Account> secondList = new List<Account>();
        Account acc = new Account();
        Account acc2 = new Account();
        
        //Create account 1.
        acc.Name = 'Unit Test';
        acc.Sales_Org__c = 'WEST';
        acc.Customer_Type__c = 'Individual';
        acc.Customer_Group__c = 'ACADEMIC';
        acc.Industry = 'TAX';
        acc.Account_Indicator__c = 'Branch';
        acc.FrozenMarketSegment__c = 'Frozen';
        acc.BU_Marketing_Segment__c = 'ELITE - Accounting;ELITE - Architecture';
        firstList.add(acc);
        
        //Create account2
        acc2.Name = 'Unit Test';
        acc2.Sales_Org__c = 'WEST';
        acc2.Customer_Type__c = 'Individual';
        acc2.Customer_Group__c = 'ACADEMIC';
        acc2.Industry = 'TAX';
        acc2.Account_Indicator__c = 'Branch';
        acc2.FrozenMarketSegment__c = 'Frozen';
        acc2.BU_Marketing_Segment__c = 'ELITE - Accounting;ELITE - Consulting, IT';
        secondList.add(acc2);
        
        
        Test.startTest();
        LCRM_BU_Marketing_Handler.UpdateLCRM_BU_Marketing_As_Text_insert(firstList);
        LCRM_BU_Marketing_Handler.UpdateLCRM_BU_Marketing_As_Text_update(firstList, secondList);
        System.assert(firstList[0].LCRM_BU_Marketing_As_Text__c == 'ELITE - Accounting; ELITE - Architecture', true);
        System.assert(secondList[0].LCRM_BU_Marketing_As_Text__c == 'ELITE - Accounting; ELITE - Consulting, IT', true);
        Test.stopTest(); 
        
        
        
        
    }    
}