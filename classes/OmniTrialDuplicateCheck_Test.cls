/** 
* OmniTrialDuplicateCheck_Test method
* @description : OmniTrialDuplicateCheck_Test
*/
@isTest
public class OmniTrialDuplicateCheck_Test {
    /** 
* @description : testP1
*/
    @isTest
    public static void duplicateCheck1(){
        
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        insert acc;
        
        ent_Trial__c trc= new ent_Trial__c();
        trc.account__c = acc.id;
        trc.Trial_Start_Date__c  =system.today();
        trc.Trial_End_Date__c = system.today();
        insert trc;
        
        Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trc.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Invited';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlcon.Name= 'Test Name';
        insert trlCon;
        
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trc.id;
        trprd.Name= 'Test Name';
        insert trprd;
        
        list<string> productCodes = new list<string>{'824925','34008203'};
        list<string> emails = new list<string>{'get2arpit@me.com','amohanty008@gmail.com.merge'};
        list<string> res = OmniTrialDuplicateCheck.duplicateCheckCallLWC(productCodes,emails);
        system.assertEquals(1, res.size(), 'SUCCESS');
    }
}