@isTest
public class Tax_Assets_Online_Contacts_Test {
  public static testmethod void assetonlinecontacts(){
        
        id quoteSSD;
        
        
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='TaxProfessional_OnlineContact',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings;
        
        KeyValueListStore__c keyvaluestore= new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        
       
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        
        PageReference pageRef = Page.Tax_Assets_Online_Contacts;
        pageRef.getParameters().put('assetnumber', 'A-6969');
        Test.setCurrentPage(pageRef);
        // ApexPages.StandardController sc = new ApexPages.StandardController(proposal);
        Tax_Assets_Online_Contacts contr= new Tax_Assets_Online_Contacts();
       
        //contr.fetchContacts('A-6969');
        
        test.stopTest();
    }
}