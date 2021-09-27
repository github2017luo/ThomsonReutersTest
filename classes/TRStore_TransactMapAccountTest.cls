/**
* @file name          : TRStore_TransactMapAccountTest
* @description        : Test class
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 06/29/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 06/29/2021   Servendra Kumar    DCP-2286     Created 
* =============================================================================
**/
@isTest(seeAllData=false)
private class TRStore_TransactMapAccountTest {
    /**
     * @description
     */
    @testSetup static void setup(){        
        // insert lead
        lead ldb = new lead();
        ldb.FirstName='Servendra';
        ldb.LastName='Kumar';
        ldb.Email='servendratestDev@test.com';        
        ldb.IsConverted=false;
        ldb.Company='TCS';          
        ldb.Billing_Street__c = 'Banito Blanco 822';
        ldb.Billing_City__c = 'New Yark';
        ldb.Billing_State__c = 'NY';
        ldb.Billing_Country__c ='US';
        ldb.TRstore_Billadd_differenceto_shipping__c = true;
        ldb.SAPAccountNumber__c = '12345623';
        ldb.Is_GLI__c=true;
        insert ldb;
        
        // create Account
        createNewAccount(ldb);
        
    }
    /**
     * @description
     */
    @isTest static void testCover() {
        Lead l= [SELECT Id,Email,Company, Phone,Lead_Region__c FROM lead WHERE email = 'servendratestDev@test.com'];
        List<lead> leadList = new List<Lead>();
        TRStore_TransactMapAccount.fetchLeadDetails(leadList);
        leadList.add(l);
        TRStore_TransactMapAccount.fetchLeadDetails(leadList);
        TRStore_TransactMapAccount.mapAccountDetails(l);    
        system.assertEquals(1,leadList.size(),'Succes');
        
    }
    /**
     * createNewAccount 
     * @description
     *
     * @param l
     */
    private static void createNewAccount(lead l){
        Account oAccount = new Account();
        oAccount.Name = l.company; 
        oAccount.Email__c = l.Email;
        oAccount.CurrencyIsoCode = (l.Lead_Region__c=='UE Store Canada PRINT')? 'CAD' : 'USD' ;
        insert oAccount;
        System.debug(loggingLevel.INFO, 'New account creation '+oAccount.id);
        createNewContact(l, oAccount.id);
    }    
    /**
     * createNewContact 
     * @description
     *
     * @param l
     * @param accountId
     */
    private static void createNewContact(lead l, Id accountId){
        contact oContact = new Contact();  
        oContact.FirstName = l.firstName;
        oContact.LastName = l.LastName;
        oContact.Email = l.Email;
        oContact.AccountId = accountId;
        insert oContact;
        System.debug(loggingLevel.INFO, 'New contact creation '+oContact.id);
    }
}