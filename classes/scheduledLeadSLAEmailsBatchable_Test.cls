@istest
class scheduledLeadSLAEmailsBatchable_Test{

   static testmethod void Testmethod1() {
   
    ILMGeneral__c ilmGen=new ILMGeneral__c();
    ilmGen.name= 'AllowedProfilesForSLAEmails';
    ilmGen.Value__C = 'System Administrator';        
    insert ilmGen;
     
    Lead l = new Lead();
    l.Company = 'test1';
    l.FirstNAme= 'test1';
    l.LAstNAme= 'test1';
    l.Accept_SLA_Warning_Date__c = Date.ValueOf('2015-08-19 13:00:00');
    l.Accept_By__c = DateTime.ValueOf('2015-08-20 13:00:00');
    l.Accept_SLA_Violation_End_Date__c= Date.ValueOf('2015-08-21');
    
    l.Convert_SLA_Warning_Date__c =Date.ValueOf('2015-08-19 13:00:00');
    l.Convert_By__c = DateTime.ValueOf('2015-08-20 13:00:00');
    l.Convert_SLA_Violation_End_Date__c=Date.ValueOf('2015-08-21');
    l.Sales_Org__c='LRA';
        
    
    insert l;
    
    // Schedule the test job
    Test.StartTest();
    scheduledLeadSLAEmailsBatchable sh1 = new scheduledLeadSLAEmailsBatchable();
    String sch = '0 0 23 * * ?'; 
    system.schedule('scheduledLeadSLAEmailsBatchable', sch, sh1);
    Test.stopTest();
    
    
   }
}