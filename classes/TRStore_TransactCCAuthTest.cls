@isTest
private class TRStore_TransactCCAuthTest {
    public static testMethod void testData(){
  // insert static values
    Static_Values__c sv = new Static_Values__c(name='TR_CCAUTH_callout', value__c='callout:Transact_CCAuth');
    insert sv;
    }

    @isTest static  void testccAuthCallout() {
        testData();
        String sandboxName = 'CCAUTH';//URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = 'callout:Transact_test_Auth';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
        TRStore_TransactCCAuth cc = new TRStore_TransactCCAuth();    
    Test.setMock(HttpCalloutMock.class, new TRStore_CCAUTHMockResponse());

        TRStore_TransactCCAuth.AuthResponse response = cc.processRequest('-E343-6785-5YMB44533000000D','VISA','0925');
        system.debug('CCAUTH Response $$:'+response);
        System.assert(true, response<>null);
    }

  @isTest static  void testccAuthPRODCallout() {
    testData();
        String sandboxName = 'CCAUTH';
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = 'callout:Transact_test_Auth';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
        TRStore_TransactCCAuth cc = new TRStore_TransactCCAuth();    
    Test.setMock(HttpCalloutMock.class, new TRStore_CCAUTHMockResponse());

        TRStore_TransactCCAuth.AuthResponse response = cc.processRequest('-E343-6785-5YMB44533000000D','VISA','0920');
        System.assert(true, response<>null);
    }
    
    @isTest static  void testccAuthFakeCallout() {
    testData();
        String sandboxName = 'CCAUTH';//URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = 'callout:Transact_test_Auth';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
        TRStore_TransactCCAuth cc = new TRStore_TransactCCAuth();
        cc.fakeItForTest = true;
    Test.setMock(HttpCalloutMock.class, new TRStore_CCAUTHMockResponse());

        TRStore_TransactCCAuth.AuthResponse response = cc.processRequest('-E343-6785-5YMB44533000000D','VISA','0920');
        System.assert(true, response<>null);
    }
    
    @isTest static  void testccAuthImproperReqCallout() {
     testData();
         String sandboxName = 'CCAUTH';//URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
        Static_Values__c staticValues = new Static_Values__c();
        staticValues.Value__c = '';
        staticValues.name = sandboxName <> null ? 'TR_'+sandboxName+'_callout' : 'TR_prod_callout';
         TRStore_TransactCCAuth cc = new TRStore_TransactCCAuth();
    Test.setMock(HttpCalloutMock.class, new TRStore_CCAUTHMockResponse());

        TRStore_TransactCCAuth.AuthResponse response = cc.processRequest('-E343-6785-5YMB44533000000D','VISA','0920');
    system.debug('FAKE CCAUTH Response $$:'+response);
        System.assert(true, response<>null);
    }
    
    @isTest static  void testccAuthEmptyReqCallout() {
    testData();
         TRStore_TransactCCAuth cc = new TRStore_TransactCCAuth();
        cc.fakeItForTest = true;
        TRStore_TransactCCAuth.AuthResponse response = cc.processRequest('','','');
        System.assert(true, response<>null);
    }
}