Public class sendReferral{
public sendReferral() {
accountid= apexpages.currentpage().getParameters().get('accountid');
oTask= new task();
}
public string accountid{get;set;}
Public task oTask{get;set;}
//public string Emailurl{get;set;}
Public string getEmailurl(){
Pagereference sendEmail = new pagereference('/_ui/core/email/author/EmailAuthor');
sendEmail.getParameters().put('p3_lkid',accountid);
string retURL='/apex/sendreferralEmail?category='+(oTask.Activity_category__c==null?'':oTask.Activity_category__c)+'&tracking='+(oTask.Tracking_code__c==null?'':oTask.Tracking_code__c)+'&accountid='+accountid;
string cancelURL='/'+accountid;
sendEmail.getParameters().put('retURL',retURL);
sendEmail.getParameters().put('cancelURL',cancelURL);
return sendEmail.getURL();
}
}