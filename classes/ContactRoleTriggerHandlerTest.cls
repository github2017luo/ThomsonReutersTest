@istest(seeAllData=true)
public class ContactRoleTriggerHandlerTest {
    
   
    static testmethod void myUnitTest1(){
       // Create New Account
        Account oAccount = UnitTest.getAccountInstance();
        oAccount.Is_GLI__c=true;
            insert oAccount;
        //create contact records
         Contact oContact = UnitTest.getContactInstance(oAccount.Id);
        //c.LCRM_Is_GLI__c = true;
        insert oContact;
        
        //create Opportunity Records
       
         Date clsedte=Date.today();
        opportunity op=new opportunity();
        op.accountid=oAccount.Id;
        op.name='Test Opportunity';
        op.stageName='Test Stage Name1';
        op.closeDate=clsedte;
        insert op;
       
        //create opportunity contact role
        OpportunityContactRole ocr=new OpportunityContactRole();
        ocr.ContactId=oContact.Id;
        ocr.OpportunityId=op.id;
        insert ocr;
        
        // check the value of the contact field Contact_Group__c
        Contact cAfterInsert=[select id, Contact_Group__c  from contact where id=:oContact .Id and LCRM_Is_GLI__c = true];
        system.debug(cAfterInsert);
        system.assertEquals('Sales Contact', cAfterInsert.Contact_Group__c);
        
    }
    
    
    

}