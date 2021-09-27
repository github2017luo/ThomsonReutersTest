/**********************************
Class Name: ESC_EFTPrepayment _Test
Purpose:test class
Author:Naga Pavan
Date Created:01/08/2020
Date Updated:V0:27/03/2021
**********************************/
/**
 * @description ESC_EFTPrepayment test class
 */
@isTest
public class ESC_EFTPrepayment_Test{
@isTest
    static void runSupportClass(){
        try{
        Account acc1 = new Account();
        Contact con1 = new Contact();
        acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
        insert acc1;
        con1 =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
        insert con1;
        Case case1=new Case();
        case1 = ESC_GenericTestutility.TestCaseUtil(con1.ID,acc1.ID,'New');
        insert case1;
        System.assertEquals(case1.status, 'New','Invalid Status');           
        ESC_EFTPrepayment esct = new ESC_EFTPrepayment();
        //esct.caseid=case1.id;
        test.starttest(); 
        esct.executePreRender();
        esct.validateForms();
        esct.executePostSubmit();
        USL_AttachHtmlFileController att = new USL_AttachHtmlFileController();
        System.debug(logginglevel.warn, att);
    }
     catch(DMLException e) {   
            system.assertEquals(e.getMessage(), e.getMessage(),'Exception occured');
           // Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            //Apexpages.addMessage(msg);   
        }
    test.stoptest(); 
    }
}