public without sharing class USLARdetailcontroller {

      public static final string WebserviceName ='Invoicedetail';
      public USLARInvoicedetailwrapper.ARdetail displayinv_list {get;set;}
      public string Invoicenumber{get; set;}
      public string sourceSytemId{get; set;}
      public USLARInvoicedetailwrapper.cls_details oinvlist {get;set;}
      public boolean IsError{get;set;}
      
      // public list<string> te {get;set;}
      
      public USLARdetailcontroller(ApexPages.StandardController controller) {     
          IsError=false;
          displayinv_list= new USLARInvoicedetailwrapper.ARdetail();
      
          Invoicenumber = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('invoice').escapeHtml4());
          sourceSytemId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('ssdId').escapeHtml4());
          List<String> InvoiceList= new List<String>();
          InvoiceList.add(Invoicenumber);
          String segment = '';
          String region = '';
          Source_System_detail__c  oSSD = null;
          if(String.isNotBlank(sourceSytemId) && Schema.sObjectType.Source_System_Detail__c.isAccessible()){
              
               oSSD = [select id, Source_System_Account_Number__c, Bu_segment__c, LCRM_Sub_bu__c,LCRM_Sales_org__c, 
                                                  Account_name__r.name 
                                           from source_system_detail__C 
                                           where Id = :sourceSytemId LIMIT 1];
                                           
              if(oSSD != null)
              {
                  segment = oSSD.Bu_Segment__c;
                  region = oSSD.LCRM_Sub_BU__c;
              }
               
          }
          system.debug('**SSD**' + oSSD);
          
          USL_Integration_defaults__c val = getIntegrationDefaults(segment, region);
          
          system.debug('**Integration Defaults**'+ val);
          
          USLARInvoicedetailwrapper.ARrequest arRequest = new USLARInvoicedetailwrapper.ARrequest();
          USLARInvoicedetailwrapper.EsiHeader eh=new USLARInvoicedetailwrapper.EsiHeader(val.Applicationid__c,val.Companyid__c,val.ESC_ConfigGroup__c);
          arRequest.esiHeader=eh;
          arRequest.invoiceNumberList=InvoiceList;
           
          oinvlist = new USLARInvoicedetailwrapper.cls_details();
           
           
          String calloutRequestBodyJSON = JSON.serialize(arRequest);
          HttpResponse r=USLARHelper.USLARCalloutHelper('Invoicedetail',calloutRequestBodyJSON);
          system.debug('**request**'+calloutRequestBodyJSON);
    
          String JsonResponseARdetail=r.getBody();
          system.debug('**JsonResponseARdetail**'+r.getBody());
          try{
            USLARInvoicedetailwrapper.cls_processStatus failresponse = new USLARInvoicedetailwrapper.cls_processStatus();
            if (r.getStatusCode() == 200){  
              displayinv_list = (USLARInvoicedetailwrapper.ARdetail)Json.deserialize(JsonResponseARdetail,USLARInvoicedetailwrapper.ARdetail.class);
              failresponse=displayinv_list.processStatus;
              system.debug('**JsonResponseARdetail**'+displayinv_list);
              if(displayinv_list.details!=null){
                oinvlist=displayinv_list.details[0];
              }
              else{
                ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
                commonCalloutException.setMessage(failresponse.statusDetailMessage+' : '+failresponse.statusDescription);
                throw commonCalloutException;
              }

            }
    
          }
               catch(Exception e){
          IsError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
          
      }
      
      private USL_Integration_defaults__c getIntegrationDefaults(String segment, String region){
        
        USL_Integration_defaults__c val;
        
        List<USL_Integration_defaults__c> lstDefaults = USL_Integration_defaults__c.getall().values();
        
        for(USL_Integration_defaults__c values : lstDefaults)
        {
            if(values.Segment__c == segment && values.region__c == region)
            {
                val = values;
                break;
            }
        }

        if(val == null)
        {
            val = USL_Integration_defaults__c.getValues('Integrationdefaults');
        }
        
        return val;
    }
}