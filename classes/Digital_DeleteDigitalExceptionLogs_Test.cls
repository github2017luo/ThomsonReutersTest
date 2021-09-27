@isTest
private class Digital_DeleteDigitalExceptionLogs_Test {
    
    //Creating data for test
    @testSetup
    static void delLogtestSetup(){
        //Getting Records from custom meta data
        List<Digital_DeleteDigiExcLog30Day__mdt> lstLog = [SELECT id, No_Of_Days__c FROM Digital_DeleteDigiExcLog30Day__mdt where Label = '30Days'];

    } 
    
    //Creating test method to test the functionality of start() method inside Digital_DeleteDigitalExceptionLogs Batch class
    //Testing Pos scenario
    public static testMethod void testDigiExBatchPos(){
                
        List<Digital_Exception_Log__c> digiEXLogLst = new List<Digital_Exception_Log__c>();
        
        Digital_Exception_Log__c log1 = new Digital_Exception_Log__c();
        log1.Exception_Type__c = 'Test Exception Type';
        log1.User_Message__c = 'Test User Message 1';
        log1.CreatedDate = System.today()-32;
        digiEXLogLst.add(log1);
        
        Digital_Exception_Log__c log2 = new Digital_Exception_Log__c();
        log2.Exception_Type__c = 'Test Exception Type';
        log2.User_Message__c = 'Test User Message 2';
        log2.CreatedDate = System.today()-32;
        digiEXLogLst.add(log2);
        
        Digital_Exception_Log__c log3 = new Digital_Exception_Log__c();
        log3.Exception_Type__c = 'Test Exception Type';
        log3.User_Message__c = 'Test User Message 3';
        log3.CreatedDate = System.today()-32;
        digiEXLogLst.add(log3);

        Digital_Exception_Log__c log4 = new Digital_Exception_Log__c();
        log4.Exception_Type__c = 'Test Exception Type';
        log4.User_Message__c = 'Test User Message 4';
        log4.CreatedDate = System.today()-32;
        digiEXLogLst.add(log4);

        Digital_Exception_Log__c log5 = new Digital_Exception_Log__c();
        log5.Exception_Type__c = 'Test Exception Type';
        log5.User_Message__c = 'Test User Message 5';
        log5.CreatedDate = System.today()-25;
        digiEXLogLst.add(log5);        
        insert digiEXLogLst;
        
        List<Digital_Exception_Log__c> logLst = [Select id, Name from Digital_Exception_Log__c];
        System.assertEquals(logLst.size(), 5);
        System.debug('test 1 log size 1:' +logLst.size());
        test.starttest();
        Digital_DeleteDigitalExceptionLogs digiLog = new Digital_DeleteDigitalExceptionLogs();
        Database.executeBatch(digiLog);
        test.stoptest();
        List<Digital_Exception_Log__c> logLst2 = [Select id, Name from Digital_Exception_Log__c];
        System.assertEquals(logLst2.size(), 2);
        System.debug('test 1 log size 2:' +logLst2.size());
    } 
    
    //Testing neg scenario
    public static testMethod void testDigiExBatchNeg(){
                
        List<Digital_Exception_Log__c> digiEXLogLst = new List<Digital_Exception_Log__c>();
        
        Digital_Exception_Log__c log1 = new Digital_Exception_Log__c();
        log1.Exception_Type__c = 'Test Exception Type';
        log1.User_Message__c = 'Test User Message 1';
        log1.CreatedDate = System.today()-25;
        digiEXLogLst.add(log1);
        
        Digital_Exception_Log__c log2 = new Digital_Exception_Log__c();
        log2.Exception_Type__c = 'Test Exception Type';
        log2.User_Message__c = 'Test User Message 2';
        log2.CreatedDate = System.today()-25;
        digiEXLogLst.add(log2);
        
        Digital_Exception_Log__c log3 = new Digital_Exception_Log__c();
        log3.Exception_Type__c = 'Test Exception Type';
        log3.User_Message__c = 'Test User Message 3';
        log3.CreatedDate = System.today()-25;
        digiEXLogLst.add(log3);

        Digital_Exception_Log__c log4 = new Digital_Exception_Log__c();
        log4.Exception_Type__c = 'Test Exception Type';
        log4.User_Message__c = 'Test User Message 4';
        log4.CreatedDate = System.today()-25;
        digiEXLogLst.add(log4);

        Digital_Exception_Log__c log5 = new Digital_Exception_Log__c();
        log5.Exception_Type__c = 'Test Exception Type';
        log5.User_Message__c = 'Test User Message 5';
        log5.CreatedDate = System.today()-25;
        digiEXLogLst.add(log5);        
        insert digiEXLogLst;
        
        List<Digital_Exception_Log__c> logLst = [Select id, Name from Digital_Exception_Log__c];
        System.assertEquals(logLst.size(), 5);
        System.debug('test 1 log size 1:' +logLst.size());
        test.starttest();
        Digital_DeleteDigitalExceptionLogs digiLog = new Digital_DeleteDigitalExceptionLogs();
        Database.executeBatch(digiLog);
        test.stoptest();
        List<Digital_Exception_Log__c> logLst2 = [Select id, Name from Digital_Exception_Log__c];
        System.assertEquals(logLst2.size(), 5);
        System.debug('test 1 log size 2:' +logLst2.size());
    } 
}