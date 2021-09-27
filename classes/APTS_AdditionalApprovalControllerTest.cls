@isTest
public class APTS_AdditionalApprovalControllerTest {
    static testMethod void testDoSave(){
        PageReference pageRef = Page.APTS_Additional_Approval;
		Test.setCurrentPage(pageRef);

		Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
        insert cart;
        ApexPages.currentPage().getParameters().put('id', cart.Id);


        APTS_AdditionalApprovalController controller = new APTS_AdditionalApprovalController();
        controller.doSave();
        cart = [SELECT Id, APTS_Additional_Approval_Required__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id =: cart.Id];
        System.assert(cart.APTS_Additional_Approval_Required__c);
        
		controller.doCancel();
        cart = [SELECT Id, APTS_Additional_Approval_Required__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id =: cart.Id];
        System.assert(!cart.APTS_Additional_Approval_Required__c);
    }
}