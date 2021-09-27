public class USLSubbillingcontroller {

     public static final string WebserviceName ='USLBillingplan';
     public string Subscriptionnumber{get; set;}
     public string Subscriptionlineitem{get; set;}
     public list<USLSubbillingplanwrapper.cls_billPlanDetails> billlist {get;set;}
     public USLSubbillingplanwrapper.Billingresponsewrapper item {get;set;}
     USL_Integration_defaults__c val = USL_Integration_defaults__c.getValues('Integrationdefaults');
      public boolean IsError{get;set;}
        public USLSubbillingcontroller(ApexPages.StandardController controller) {     
            
            billlist = new list<USLSubbillingplanwrapper.cls_billPlanDetails>();
            item = new USLSubbillingplanwrapper.Billingresponsewrapper();
             Subscriptionnumber = ApexPages.currentPage().getParameters().get('Subnumber');
             Subscriptionlineitem = ApexPages.currentPage().getParameters().get('Sublineitem');
             
              USLSubbillingplanwrapper.Billingrequestwrapper billreq = new USLSubbillingplanwrapper.Billingrequestwrapper();
             
              USLSubbillingplanwrapper.EsiHeader eh=new USLSubbillingplanwrapper.EsiHeader(val.Applicationid__c,val.Companyid__c);
              USLSubbillingplanwrapper.SubscriptionDetails sub=new USLSubbillingplanwrapper.SubscriptionDetails(Subscriptionnumber,Subscriptionlineitem);
              billreq.esiHeader=eh;
              billreq.subscriptionDetails=sub;
         
             String calloutRequestBodyJSON = JSON.serialize(billreq);
             system.debug('**request**'+calloutRequestBodyJSON);
             HttpResponse r=USLARHelper.USLARCalloutHelper('USLBillingplan',calloutRequestBodyJSON);
        
        
  
          String JsonResponsebilling=r.getBody();
           system.debug('**JsonResponsebilling**'+r.getBody());
         
          try{
            USLSubbillingplanwrapper.cls_statusDetails failresponse = new USLSubbillingplanwrapper.cls_statusDetails();
            if (r.getStatusCode() == 200){  
              item = (USLSubbillingplanwrapper.Billingresponsewrapper)Json.deserialize(JsonResponsebilling,USLSubbillingplanwrapper.Billingresponsewrapper.class);
             failresponse=item.statusDetails[0];
             system.debug('fail'+failresponse);
             system.debug('**item.billPlanDetails***'+item.billPlanDetails);
             if(item.billPlanDetails!=null){
                 billlist=item.billPlanDetails;
             
             
              }
              else{
                ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                commonCalloutException.setMessage(failresponse.statusDetailMessage+' : '+failresponse.statusDescription);
                system.debug('commonCalloutException'+commonCalloutException);
                // IsError=true;
                throw commonCalloutException;
                 //system.debug('commonCalloutException'+commonCalloutException);
              }
}
            }
    
          
               catch(Exception e){
          IsError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
             
             
                }
                

    
    
}