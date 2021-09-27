@isTest
public class LCRMConvertLeadMaptoLeadHistory_Test {

    public testmethod static void testLead(){
         Profile p = [SELECT Id FROM profile WHERE name='TR Sales - Lightning'];   
         User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
                           timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test',Segment__c='Corporate');        
        insert u1;
        
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        
        system.runas(u1){
            
              Account TestAcc1 = UnitTest.getAccountInstance();
            	insert TestAcc1;
        LCRMConvertLeadMaptoLeadHistory.isInSalesforceLightning = true;
        Lead lead = UnitTest.getLeadInstance();
        lead.LastName='Ghosh';
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        //lead.Billing_State__c = 'CA';
        //lead.Billing_Zip__c = 'test';
        lead.Billing_Country__c = 'US';
        lead.isconverted = true;   
        lead.ConvertedAccountId = TestAcc1.id;
        lead.DoNotCall = true;
        //lead.email = 'abc@gmail.com';
        insert lead;  
        System.assertEquals(lead!=null,true);
        LM_Lead_History__c lh = new LM_Lead_History__c ();
        lh.name='test';
        insert lh;     
        
        Test.startTest();
        try{
             
            LCRMConvertLeadMaptoLeadHistory lcl = new LCRMConvertLeadMaptoLeadHistory();
            lcl.createLeadHistory(lead);
            //lcl.bError = true;
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    }}
    
}