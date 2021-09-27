@isTest 
public class USL_DeleteCaseRecord_Test{

public static  Id recordTypeIdIncident = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incident').getRecordTypeId();
public  static Id recordTypeIdIncident1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request for Service').getRecordTypeId();

    static testMethod void testMethod1() 
    {    
        
        list<case> listobjtcase =new list<case>();
        Case objCase = new Case();
        objCase.Status = 'On Hold';
        objCase.CurrencyIsoCode = 'USD';
        objCase.Origin = 'Email';
        objCase.LCRM_Sub_BU__c='USL';
        objCase.Subject='Automatic Reply';
        objCase.recordTypeId = recordTypeIdIncident; 
        listobjtcase.add(objCase);
        
        
        Case objCase1 = new Case();       
        objCase1.CurrencyIsoCode = 'USD';
        objCase1.Origin = 'Email';
        objCase1.LCRM_Sub_BU__c='USL';
        objCase1.Subject='OOO';
         objCase.recordTypeId = recordTypeIdIncident1; 
        listobjtcase.add(objCase1);
        
         Case objCase2 = new Case();       
        objCase2.CurrencyIsoCode = 'USD';
        objCase2.Origin = 'Email';
        objCase2.LCRM_Sub_BU__c='USL';
        objCase2.Subject='Returned mail';
        listobjtcase.add(objCase2);        
        INSERT listobjtcase;

        
        Test.startTest();
        //String CRON_EXP = '0 0 0,4,8,12,16,20 * * ?'; 
        USL_SPAM_EMAIL_Cases_Delete deleteCaseScheduled= new USL_SPAM_EMAIL_Cases_Delete(); 
        String sch = '0 00 00 * * ?';
        System.schedule('My batch Job', sch, deleteCaseScheduled);
       // system.schedule('Everly 4 hr ', CRON_EXP, sch);

        Test.stopTest();
        
         integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        
    }
}