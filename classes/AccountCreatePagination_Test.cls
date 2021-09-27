@isTest
private class AccountCreatePagination_Test{
  public static testMethod void accCrtPagTestMethod(){
    Account acc = new Account(Name='BANK OF MONTREAL', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
    //insert acc;
       
      test.StartTest();
        
            AccountCreatePagination accPagination = new AccountCreatePagination();
            
            DataQualityUtil.ECMAccountInfo ECMAccountInfo = new DataQualityUtil.ECMAccountInfo();
        
            ECMAccountInfo.Name = 'Test123';    
            ECMAccountInfo.Street1 = '12-34';
            ECMAccountInfo.Street2 = '2395 MIDWAY RD';
            ECMAccountInfo.Country = 'US';                  
            ECMAccountInfo.City = 'CARROLLTON';
            ECMAccountInfo.PostalCode = '75006-2521';
            ECMAccountInfo.AddressId = 'AB123';
                
            AccountCreateController.MatchedECMAccount matchedEMCAcc = new AccountCreateController.MatchedECMAccount();            
            matchedEMCAcc.ECMAccountInfo = ECMAccountInfo;
            List<AccountCreateController.MatchedECMAccount> ecmList = new List<AccountCreateController.MatchedECMAccount>{matchedEMCAcc};
            accPagination.listMatchedECMAccounts = ecmList;
            accPagination.PageIndex = 0;
            
            
            
            accPagination.initPaging();
            Integer pgSz = accPagination.PageSize;
            system.assert(!accPagination.AllowMoveNext);
            system.assert(!accPagination.AllowMovePrev);
            system.assertEquals(1,accPagination.CurrentPageRecordSize);
            system.assertEquals(1,accPagination.CurrentPage.size());
            system.assertEquals(1,accPagination.RecordStart);
            system.assertEquals(1,accPagination.RecordEnd);
            accPagination.movePrev();
            accPagination.moveNext();
            
            
        Test.StopTest();        
   }
}