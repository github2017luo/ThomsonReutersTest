@isTest
private class Case_Creation_From_Contract_Test {
    @isTest
    private static void testCase(){
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test';
        oAccount.BillingStreet = '123 Unit Test Street';
        oAccount.BillingCity='Dallas';
        oAccount.BillingState = 'TX';
        oAccount.BillingPostalCode = '75006';
        oAccount.BillingCountry='US';
        oAccount.Sales_Org__c = 'LRA';
        insert oAccount;
        Contact con = new Contact(
          AccountId = oAccount.Id,
          FirstName = 'Generic',
          LastName  = 'Contact'
      );
        insert con;
        
        Contract cont = new Contract(
           AccountId = oAccount.Id,
           StartDate = System.today(),
           ContractTerm = 6,
           Status = 'Draft',
           CustomerSignedId = con.id,
           CustomerSignedDate = System.today()
          );
        Contract cont2 = new Contract(
           AccountId = oAccount.Id,
           StartDate = System.today(),
           ContractTerm = 6,
           Status = 'Reviewed'
           
          );
          insert cont2;
        cont2.Status = 'Approved';
        update cont2;
        
        
        test.startTest();
         insert cont;
          cont2.CustomerSignedId = con.id;
          cont2.CustomerSignedDate = System.today();
         update cont2;
        test.stopTest();
        case ca = [select id,Contract__c from case where Contract__c=: cont.id limit 1];
        contract contafterUpdate = [select id,status from contract where id=: cont2.id limit 1];
       System.assertEquals(cont.Id, ca.Contract__c);
       System.assertEquals('Signed', contafterUpdate.Status);
    }
}