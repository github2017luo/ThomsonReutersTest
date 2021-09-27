@istest
private class TaxDocumentLoadController_test{

    static testmethod void taxUploadMethod(){
    
    Account acc = new account();
    acc.Tax_Document_Type__c = 'CM-05 Certificate (Formulario Multilateral)';
    acc.name = 'test account';
    insert acc;
    
    /*Opportunity opp = new Opportunity();
    opp.name = 'test opp';
    opp.accountId = acc.id;
    opp.stagename = '75%';
    opp.closedate = System.today();    
    insert opp;*/
    
    Tax_Document__c tax1 = new Tax_Document__c();
    
    
    Tax_Document__c tax2 = new Tax_Document__c();
    //insert tax2;
    
    Tax_Document__c tax3 = new Tax_Document__c();
    //insert tax3;
    
    Tax_Document__c tax4 = new Tax_Document__c();
   // insert tax4;
    
    Attachment attach1 = new Attachment(Name='test1.pdf',body= Blob.ValueOf('123'));
    Attachment attach2 = new attachment(name='test2.pdf',body= blob.valueOf('456'));
    Attachment attach3 = new attachment(name='test3.pdf',body= blob.valueOf('789'));
    Attachment attach4 = new attachment(name='test4.pdf',body= blob.valueOf('852'));
    
    test.starttest();
    PageReference pr = Page.TaxDocumentLoad;
    System.CurrentPageReference().getParameters().put('accountId',acc.id);
    ApexPages.StandardController sc = new ApexPages.StandardController(tax1);
    TaxDocumentLoadController tdctrl = new TaxDocumentLoadController(sc);
    tdctrl.cm_05_file = attach1;
    tdctrl.turnover_file = attach2;
    tdctrl.exemption_file = attach3;
    tdctrl.other_file = attach4;
    tdctrl.tax1 = tax1;
    tdctrl.tax2 = tax2;
    tdctrl.tax3 = tax3;
    tdctrl.tax4 = tax4;
    
    tdctrl.save();
    tdctrl.cancel();
    
    TaxDocumentLoadController tdctrl1 = new TaxDocumentLoadController(sc);
    tdctrl1.save();
    
    test.stoptest();
    
}
}