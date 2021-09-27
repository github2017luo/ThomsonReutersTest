@isTest(seeAllData=false)
public class TRSToreMicrositeapprovalsRespTest{
    
    public static testMethod  void TRSToreMicrositeapprovalsRespMet1(){

         // insert lead
        lead ldb = new lead();
        ldb.FirstName='testfname1298';
        ldb.LastName='testlname3654';
        ldb.Email='tfkjsdbfafy389y39@mailinator.com';        
        ldb.IsConverted=false;
        ldb.Company='TCS';
          
        ldb.Billing_Street__c = 'Banito Blanco 822';
        ldb.Billing_City__c = 'New Yark';
        ldb.Billing_State__c = 'New yark';
        ldb.Billing_Country__c ='United States';
        ldb.TRstore_Billadd_differenceto_shipping__c = true;
        ldb.SAPAccountNumber__c = '12345623';
        ldb.Is_GLI__c=true;
        ldb.Lead_Microsite__c='TR Store';
        insert ldb;
        
        staticValues();
        
        // Create a new email and envelope object (Mandatory)
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
        // Create the email body
        email.plainTextBody = 'Approve....Approve....';
        email.fromAddress ='test@test.com';
        String contactEmail = 'test@domain.com';
        email.ccAddresses = new String[] {'Test Domain <' + contactEmail + '>'};
        email.subject = 'PWC Microsite Order Creation - '+ldb.id;
        
        
        Messaging.InboundEmail emailreject  = new Messaging.InboundEmail();
        
        
        
        Test.startTest();
        // pass email & enveloper object as parameters here
        Messaging.InboundEmailResult result1 = TRSToreMicrositeapprovalsResp.handleInboundEmail(email, env);
         
        Test.stopTest();
        
        

    }  
    public static testMethod  void TRSToreMicrositeapprovalsRespMet2(){

         // insert lead
        lead ldb = new lead();
        ldb.FirstName='testfname1298';
        ldb.LastName='testlname3654';
        ldb.Email='tfkjsdbfafy389y39@mailinator.com';        
        ldb.IsConverted=false;
        ldb.Company='TCS';
          
        ldb.Billing_Street__c = 'Banito Blanco 822';
        ldb.Billing_City__c = 'New Yark';
        ldb.Billing_State__c = 'New yark';
        ldb.Billing_Country__c ='United States';
        ldb.TRstore_Billadd_differenceto_shipping__c = true;
        ldb.SAPAccountNumber__c = '12345623';
        ldb.Is_GLI__c=true;
        ldb.Lead_Microsite__c='TR Store';
        insert ldb;
        
        staticValues();
       
        // Create a new email and envelope object (Mandatory)
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail emailreject  = new Messaging.InboundEmail();
        
        // Create the Reject email body
        emailreject.plainTextBody = 'Reject....Reject....';
        emailreject.fromAddress ='test@test.com';
        String contactEmail2 = 'test@domain.com';
        emailreject.ccAddresses = new String[] {'Test Domain <' + contactEmail2 + '>'};
        emailreject.subject = 'PWC Microsite Order Creation - '+ldb.id;
        
        Test.startTest();
        // pass email & enveloper object as parameters here
        Messaging.InboundEmailResult result2 = TRSToreMicrositeapprovalsResp.handleInboundEmail(emailreject, env);
          
        Test.stopTest();
        
    }   
    public static testMethod  void TRSToreMicrositeapprovalsRespMet3(){

         // insert lead
        lead ldb = new lead();
        ldb.FirstName='testfname1298';
        ldb.LastName='testlname3654';
        ldb.Email='tfkjsdbfafy389y39@mailinator.com';        
        ldb.IsConverted=false;
        ldb.Company='TCS';
          
        ldb.Billing_Street__c = 'Banito Blanco 822';
        ldb.Billing_City__c = 'New Yark';
        ldb.Billing_State__c = 'New yark';
        ldb.Billing_Country__c ='United States';
        ldb.TRstore_Billadd_differenceto_shipping__c = true;
        ldb.SAPAccountNumber__c = '12345623';
        ldb.Is_GLI__c=true;
        ldb.Lead_Microsite__c='TR Store';
        insert ldb;
        
        staticValues();
        
        // Create a new email and envelope object (Mandatory)
         Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
                
        
        
        // Create the Resend email body
        Messaging.InboundEmail emailreresend  = new Messaging.InboundEmail();
        
        emailreresend.plainTextBody = 'kjkjbf....Approve....';
        emailreresend.fromAddress ='test@test.com';
        String contactEmail3 = 'test@domain.com';
        emailreresend.ccAddresses = new String[] {'Test Domain <' + contactEmail3 + '>'};
        emailreresend.subject = 'PWC Microsite Order Creation - '+ldb.id;
        
        
        
        Test.startTest();
        // pass email & enveloper object as parameters here
         Messaging.InboundEmailResult result3 = TRSToreMicrositeapprovalsResp.handleInboundEmail(emailreresend, env);
         
        Test.stopTest();
        
        

    }  
    
    public static void staticValues(){
    
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>();
        Static_Values__c stl = new Static_Values__c(name='micrositeApprovedApprovals', value__c='Approve');
        Static_Values__c sth = new Static_Values__c(name='micrositeRejectApprovals', value__c='Reject');
        Static_Values__c stc = new Static_Values__c(name='micrositeApprovedMsg', value__c='Request to Quote Create');
        Static_Values__c sts = new Static_Values__c(name='micrositeRejectMsg', value__c='Approvals Rejected'); 
        Static_Values__c stpb = new Static_Values__c(name='micrositeResendMsg', value__c= 'Resend Request');
        Static_Values__c stse = new Static_Values__c(name='OrderProcessSupportEmail', value__c= 'supportemail@mailinator.com');
        Static_Values__c stls = new Static_Values__c(name='LeadSupportEmail', value__c= 'supportemail@mailinator.com');
        Static_Values__c stIntBestRate = new Static_Values__c(name='ShipMethodMicrositeIntBestPrice', value__c= 'International best Rate');
        Static_Values__c stPayOptMicro = new Static_Values__c(name='PaymentOptionMicrosite', value__c= 'Pay by Charge Code');
    
    
        staticCSList.add(stl);
        staticCSList.add(sth);
        staticCSList.add(stc); 
        staticCSList.add(sts);
        staticCSList.add(stpb);
        staticCSList.add(stse);
        staticCSList.add(stls);
        staticCSList.add(stIntBestRate);
        staticCSList.add(stPayOptMicro);
        
        insert staticCSList;
    }
    
    
    
    
    
}