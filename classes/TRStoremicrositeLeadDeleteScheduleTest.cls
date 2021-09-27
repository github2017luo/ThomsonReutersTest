@isTest(seeAllData=false)
public class TRStoremicrositeLeadDeleteScheduleTest{


    public static testMethod void testData(){
        
        
        lead ld = new lead();
        ld.FirstName='TestFirstname';
        ld.LastName='TestLastName';
        ld.Email='testfirst.testlast@test.com';
        ld.IsConverted=false;
        ld.Company='TestCompany';
        ld.Lead_Microsite__c = 'PWC';
        
        insert ld;
        
        // micrositesToDeleteTimeFrame 
        LIST<Static_Values__c> stList = new LIST<Static_Values__c>();
        Static_Values__c stlc = new Static_Values__c(name='micrositesToDeleteTimeFrame', value__c= '0 0 21 ? * MON-FRI *');
        Static_Values__c stoc = new Static_Values__c(name='micrositesToDelete', value__c= 'PWC,Deloitte');
        Static_Values__c stdv = new Static_Values__c(name='MicrositeLeaddeletedays', value__c= '0');
        Static_Values__c stde = new Static_Values__c(name='micrositedeleteleadsemailTemplate', value__c= 'We have completed the microsite leads deletion, Please find the results');
        Static_Values__c stdt = new Static_Values__c(name='micrositesNoOfRecordstoDelete', value__c= '200');
         
        stList.add(stlc);
        stList.add(stoc);
        stList.add(stdv);
        stList.add(stde);
        stList.add(stdt);
        
        insert stList;
        
        
        test.starttest();
         TRStoremicrositeLeadDeleteSchedule myClass = new TRStoremicrositeLeadDeleteSchedule();   
         myClass.execute(null);
         test.stopTest();
        
        
    
    }

}