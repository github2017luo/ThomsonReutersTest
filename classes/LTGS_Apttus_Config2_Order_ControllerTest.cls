@isTest
public class LTGS_Apttus_Config2_Order_ControllerTest {
    @isTest
    static void validate_getApttus_Config2_OrderId(){
        Apttus_Proposal__Proposal__c AP= new Apttus_Proposal__Proposal__c();
        insert AP;
        //LTGS_Apttus_Config2_Order_Controller testObj= new LTGS_Apttus_Config2_Order_ControllerTest();
        Integer no = LTGS_Apttus_Config2_Order_Controller.getApttus_Config2_OrderId(AP.Id);
        //System.debug('no '+no);
        //System.assertEquals(no, 1);
         Boolean result = LTGS_Apttus_Config2_Order_Controller.acceptQuote(AP.Id);
        //result = LTGS_Apttus_Config2_Order_Controller.acceptQuote('Exception');
    }
    
}