public without sharing class ESC_InvoiceListWrapper{
    public class OpenWrapper{
        public boolean isselected{get;set;}
        public USLARWrapper.openedItems openlist{get;set;}
        public openwrapper(Boolean isselected,USLARWrapper.openedItems openlist){
            this.isselected = isselected;
            this.openlist = openlist;
        }
    }
    
    public class ClearedWrapper{
        public boolean isselected{get;set;}
        public USLARWrapper.clearedItems clearlist{get;set;}
        public clearedwrapper(Boolean isselected,USLARWrapper.clearedItems clearlist){
            this.isselected = isselected;
            this.clearlist = clearlist;
        }
    }
    
    public Pagiwrapper getresponses(String begindt1,String enddt1,String sapnumber){
        ESC_Invoicehelper.Openinvpagiwrapper openpagiwrap;
        ESC_Invoicehelper.Clearinvpagiwrapper clearpagiwrap;
        ESC_Invoicewrapper invwrap = new ESC_Invoicewrapper();
        boolean successresponse = false;
        Pagiwrapper pagiwrap;
        USLARWrapper oResponsealllist;
        USL_Integration_defaults__c intval;
        List<USLARWrapper.openedItems> oResponseopenlist = new List<USLARWrapper.openedItems>();
        List<USLARWrapper.clearedItems> oResponseclearlist = new List<USLARWrapper.clearedItems>();
        integer pagesize = 10;
        boolean noinvoices = false;
        Source_System_Detail__c ssd;
        if ((sapnumber != null && sapnumber  != '') && Schema.sObjectType.Source_System_Detail__c.isAccessible()){        
            ssd = [Select BU_Segment__c,LCRM_Sub_BU__c from Source_System_Detail__c where Source_System_Account_Number__c =:sapnumber];            
        }
        intval = USLARHelper.getIntegrationDefaults(ssd.BU_Segment__c,ssd.LCRM_Sub_BU__c);
        if(test.isrunningtest()){
            pagesize = 1; 
        }
        try{
            USLARWrapper.ARrequest odReqWrap = new USLARWrapper.ARrequest();         
            odReqWrap=USLARHelper.USLARRequestHelper(sapnumber,intval.Applicationid__c,intval.Companyid__c,intval.ESC_ConfigGroup__c,Begindt1,Enddt1); 
            HttpResponse response = USLARHelper.USLARCalloutHelper('Invoice',JSOn.serialize(odReqWrap)); 
            String jsonResponseAR=response.getBody();        
            validateresponse(response);
            if(response.getStatusCode() == 200 ){
                OResponsealllist=(USLARWrapper)Json.deserialize(JsonResponseAR,USLARWrapper.class);
                OResponseopenlist  = OResponsealllist.openedItems; 
                OResponseclearlist = OResponsealllist.clearedItems;
                
                successresponse = true;
            }
            /*if(OResponseopenlist.size() == 0 && OResponseclearlist.size() == 0){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No invoices available for this SAP Account number'));
                noinvoices = true;
            }*/
            noinvoices =  validateresponselist(OResponseopenlist,OResponseclearlist) ;                                                               
            if(successresponse && !noinvoices){                
                openpagiwrap= invwrap.populateOpenlist(OResponseopenlist,pageSize);
                clearpagiwrap= invwrap.populateClearlist(OResponseclearlist,pageSize);
            }
            pagiwrap = new Pagiwrapper(openpagiwrap,clearpagiwrap);
            return  pagiwrap;       
                   
                                                                                                                                                          
        }
        catch(Exception e){
            //IsError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    boolean validateresponselist(List<USLARWrapper.openedItems> oResponseopenlist,List<USLARWrapper.clearedItems> oResponseclearlist){
        boolean noinvoices = false;
        system.debug('in validate');
        if((OResponseopenlist != null && OResponseopenlist.size() == 0) && (OResponseclearlist!= null && OResponseclearlist.size() == 0)){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No invoices available for this SAP Account number'));
            noinvoices = true;
        }
            return noinvoices;
    }
    void validateresponse(HttpResponse response){
        USLARWrapper.Status failresponse = new USLARWrapper.Status();
        failresponse=(USLARWrapper.Status)Json.deserialize(response.getBody(),USLARWrapper.Status.class);
        if(response.getStatusCode() != 200){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.USL_BadReqError));
            return;
        }
        if(failresponse.processStatus!=null){
            ESC_HandlerCustomException commonCalloutException = new ESC_HandlerCustomException();
            commonCalloutException.setMessage(failresponse.processStatus.statusDescription+' : '+failresponse.processStatus.statusDetailMessage);
            throw commonCalloutException;
        }
    }
    
    public class Pagiwrapper{
        public ESC_Invoicehelper.Openinvpagiwrapper openpagiwrap{get;set;}
        public ESC_Invoicehelper.Clearinvpagiwrapper clearpagiwrap{get;set;}
        public pagiwrapper (ESC_Invoicehelper.Openinvpagiwrapper openpagiwrap,ESC_Invoicehelper.Clearinvpagiwrapper clearpagiwrap){
            this.openpagiwrap = openpagiwrap;
            this.clearpagiwrap = clearpagiwrap;
        }
    }
}