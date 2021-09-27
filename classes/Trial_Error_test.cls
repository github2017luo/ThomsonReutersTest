@isTest
public class Trial_Error_test{

    @isTest
    Static Void dataone(){
        Trial__c t1=new Trial__c();
        
        Test.startTest();
        insert t1;
        t1.Error_Code__c='NC-OF ';
        t1.Error_Description2__c='Order failure in Hybris or ESI';
		update t1;
        Test.stopTest();
    }
}