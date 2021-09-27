@istest
public class TaxDocumentTriggerHandler_test{

    static testmethod void updateTaxDocumentTypeTest(){
    
        account acc = new account();
        acc.name = 'test Account';
        acc.Tax_Document_Type__c = 'CM-05 Certificate (Formulario Multilateral);Turnover Certificate (Ingresos Brutos)';
        insert acc;
        
        Tax_Document__c tax1 = new Tax_Document__c();
        tax1.Tax_Document_Type__c = 'Turnover Certificate (Ingresos Brutos)';
        tax1.name = 'Turnover test Account';
        tax1.account__c = acc.id;
        insert tax1;
        
        delete tax1;        
       }
 }