/**
 * This is the test class for Digital_PaymentMonitor
 */
/**
 * CHANGE HISTORY
 * =================================================================================================================
 * Date         Name                    Description
 * 2021-06-14   Brenda Shields          DLT-21895 - [INC4022734][SFDC][Monitoring][NSE] - Implement monitoring for NSE payment failures
 * =================================================================================================================
 */
/** 
 * @description : Test class for Digital_PaymentMonitor class
 */ 
@isTest(seealldata=false)
public with sharing class Digital_PaymentMonitor_Test {
    
    public static String accountId;
    public static String oppId;
    public static String quoteId;
    public static string attachmentId;
    public static String accssdid;

    // Create basic Account and Opportunity Data
    @testSetup
    static void setup() {
    	 string strFailureMessage;
    	 
        // create account, ssd and opp
        DCTestData.createData();
        
    	// Get Account id
    	Account oAcct = [Select id from Account limit 1];         
        // Get Opp id
        Opportunity oOpp = [Select id from Opportunity LIMIT 1]; 
        
        // create Lead
		Lead oLead = new Lead();
		oLead.firstname = 'Testfirst';
		oLead.lastname = 'Testlast';
		oLead.company = 'Test Company Name';
		oLead.Email = 'first.last@testmail.xxx';
		oLead.Phone = '11122223337777';
		insert oLead;
		
		strFailureMessage = 'Payment Failure Message - Invalid Care ' + 
			' Account id - ' + oAcct.Id +
			' Opportunity id - ' + oOpp.Id +
			' Lead id - ' + oLead.Id;
		
        // create Digital Exception Log records
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
        Digital_Exception_Log__c deLog1 = new Digital_Exception_Log__c();
        deLog1.Exception_Message__c = strFailureMessage;
        deLog1.Additional_Information__c = 'Payment Failed';            
        exList.add(deLog1); 
        Digital_Exception_Log__c deLog2 = new Digital_Exception_Log__c();
        deLog2.Exception_Message__c = strFailureMessage;
        deLog2.Additional_Information__c = 'Payment Failed';            
        exList.add(deLog2); 
        insert exList;
    }
    

    // test for basic Payment Monitoring processing
    @isTest static void testPaymentMonitor() {

        //assert before
        Integer expectedLimits = 0;
        Integer actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits before');

        // Test for Opp Renewal that is Ready for Renewal processing
        Test.startTest();   
        Digital_PaymentMonitor dc = new Digital_PaymentMonitor();
        database.executebatch(dc,10); 
        Test.stopTest();
        
        //assert after
        expectedLimits = 0;
        actualLimits = Limits.getEmailInvocations();
        System.assertEquals(expectedLimits, actualLimits, 'wrong limits after');
    }
    
    
    // test scheduled job class
    @isTest static void paymentScheduleTest(){
    
        test.starttest();
        try {
        	Digital_PaymentMonitorSch schdJob = new Digital_PaymentMonitorSch();
        	String sch = '0 0 23 * * ?'; 
        	system.schedule('Test Account Exec', sch, schdJob ); 
        } Catch(Exception ex) {
          	system.debug(LoggingLevel.INFO, 'Exception > '+ex);
        }
        // Check to see if the opp status has not been updated
        Opportunity oOppty = [Select id, Is_Digital_Owner_Updated__c from Opportunity LIMIT 1];
        system.AssertEquals(false, oOppty.Is_Digital_Owner_Updated__c, 'Opp should not be updated');
        test.stoptest();            
    }
    
}