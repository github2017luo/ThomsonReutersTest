global without sharing class scheduledLeadSLAEmailsBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {   
   
      boolean isAccept = true;
      //For Accept Warning
      string Query1= 'SELECT Id,Name,Accept_By__c,Accept_SLA_Violation_End_Date__c,Accept_SLA_Warning_Date__c,Accept_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name,createdbyid,Sales_Org__c FROM LEAD WHERE Status = \'Unworked\' AND Business_Org__c != null AND Lead_Scoring_Combined__c != null  AND  Accept_SLA_Warning_Date__c <= TODAY AND Accept_By_Date__c > TODAY';
      batchLMSLAEmails b1 = new batchLMSLAEmails(Query1,isAccept ,false); 
      database.executebatch(b1,5);
      //For Accept violation
      // the following select was changedfor MCL-1401 by SKG
      //string Query2= 'SELECT Id,Name,Accept_By__c,Accept_SLA_Violation_End_Date__c,Accept_SLA_Warning_Date__c,Accept_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name FROM LEAD WHERE Status = \'Unworked\' AND Business_Org__c != null AND Lead_Scoring_Combined__c != null AND Accept_By_Date__c <= TODAY AND Accept_SLA_Violation_End_Date__c >= TODAY';
      string Query2= 'SELECT Id,Name,Accept_By__c,Accept_SLA_Violation_End_Date__c,Accept_SLA_Warning_Date__c,Accept_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name,createdbyid,Sales_Org__c FROM LEAD WHERE Status = \'Unworked\' AND Business_Org__c != null AND Lead_Scoring_Combined__c != null AND Accept_By_Date__c <= TODAY';
      batchLMSLAEmails b2 = new batchLMSLAEmails(Query2,isAccept ,false); 
      database.executebatch(b2,5);
      
      boolean isConvert = true;
      //For Convert Warning      
      string Query3= 'SELECT Id,Name,Convert_By__c,Convert_SLA_Violation_End_Date__c,Convert_SLA_Warning_Date__c,Convert_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name,createdbyid,Sales_Org__c FROM LEAD WHERE Status NOT IN(\'Discarded\',\'Converted\') AND Business_Org__c != null AND Lead_Scoring_Combined__c != null  AND  Convert_SLA_Warning_Date__c <= TODAY AND Convert_By_Date__c > TODAY';
      batchLMSLAEmails b3 = new batchLMSLAEmails(Query3,false,isConvert); 
      database.executebatch(b3,5);
      //For Convert violation
      // the following select was changedfor MCL-1401 by SKG      
      //string Query4= 'SELECT Id,Name,Convert_By__c,Convert_SLA_Violation_End_Date__c,Convert_SLA_Warning_Date__c,Convert_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name FROM LEAD WHERE Status NOT IN(\'Discarded\',\'Converted\') AND Business_Org__c != null AND Lead_Scoring_Combined__c != null AND Convert_By_Date__c <= TODAY AND Convert_SLA_Violation_End_Date__c >= TODAY';
      string Query4= 'SELECT Id,Name,Convert_By__c,Convert_SLA_Violation_End_Date__c,Convert_SLA_Warning_Date__c,Convert_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name,createdbyid,Sales_Org__c FROM LEAD WHERE Status NOT IN(\'Discarded\',\'Converted\') AND Business_Org__c != null AND Lead_Scoring_Combined__c != null AND Convert_By_Date__c <= TODAY';
      batchLMSLAEmails b4 = new batchLMSLAEmails(Query4,false,isConvert); 
      database.executebatch(b4,5);      
     
   }
}