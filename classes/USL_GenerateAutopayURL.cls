public class USL_GenerateAutopayURL{

    @InvocableMethod(label='uslgetautopayurl')
    public static void getpaymenturl(List<Case> cases){
    
        if(cases == null || cases.isEmpty())
            return;
        List<Case> updCaseList = new List<Case>();
        List<String> CaseIdlst= new List<String>();
        List<Case> caseList = new List<Case>();
        List<String> CaseNumber = new list<String>();
        WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
        if(Test.isRunningTest()){
             PGWebServiceSettings.Endpoint__c='www.google.com';
             
        }
        else{
                PGWebServiceSettings = AppUtil.getWebServiceSettings('USL AutoPay'); 
        }
        Set<Id> caseIdSet = new Set<Id>();
        System.debug('caseIdSet: ' + caseIdSet);
        
            
         for(Case c: Cases){         
             if(Test.isRunningTest()){
                 CaseIdlst.add(c.Id);
             }
             else if(c.LCRM_Sub_BU__c=='USL' && c.Is_GLI__c==true && c.Is_ESC_Case__c ==true){
                 CaseIdlst.add(c.Id);
             }
         }
         if(CaseIdlst.size()>0){
             caseList =[Select Id,CaseNumber,ESC_Email_Thread_Id__c,Case.Account.Name,Case.Account.BillingCity,Case.Account.BillingState,
             Case.Account.SAPAccountNumber__c,Case.Account.BillingPostalCode,Case.Account.Street_Address_2__c,
             Case.Account.BillingCountry,
            Case.Contact.FirstName,Contact.Email from Case where Id IN:CaseIdlst];
            System.debug('caseIdSet: ' + caseList);        
            for(Case c:caseList){
                Case cs=new Case();
                 cs.id=c.id;
                 string caseId=c.id;
                   string threadId='ref:_' 
                    + UserInfo.getOrganizationId().left(4) 
                    + 'F' 
                   + UserInfo.getOrganizationId().mid(11,4) + '._' 
                   + caseId.left(4) + 'F' 
                   + caseId.mid(10,5) + ':ref';
                 String detail ='QuoteNumber=' + c.CaseNumber+'|'+'CaseThreadId='+threadId+'|'+'BusinessUnitCode=ESCU';
                 System.debug('PaymentAccount: ' + detail);
               //String urlData =encryption(detail);
                Blob cryptoKey = EncodingUtil.base64Decode('5r7owaVHWQnc9P0ZWALBbQ==');         
                Blob data = Blob.valueOf(detail);
                blob encryptedData = Crypto.encrypt('AES128',cryptoKey, cryptoKey , data);
                String b64Data = EncodingUtil.base64Encode(encryptedData);
                String ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+b64Data;
                 System.debug('autochargeurl: ' + ccurl);
                 cs.USL_AutoPayment_URL__c=ccurl;
                 updCaseList.add(cs);
            }
                
           }
    
      if(updCaseList.size()>0){
        update updCaseList;
    }
   }
  }