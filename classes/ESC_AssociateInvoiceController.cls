/**
     * @description ESC_AssociateInvoiceController
     * 
     */
public without sharing class ESC_AssociateInvoiceController{
    String caseid;
    Case caseAcc;
    USL_Integration_defaults__c intval;
    ESC_InvoiceListWrapper invhelper ;
    ESC_InvoiceHelper insavecon;
    Map<String,ESC_Invoice_Item__c> invoicemap;
    /**
     * @description Justdesc
     * @return jusdesc
     */
    public boolean showLineNumber{get;set;}
    /**
     * @description Justdesc
     * @return jusdesc
     */
    public ESC_InvoiceWrapper invwrap {get;set;}
    /**
     * @description Justdesc
     * @return jusdesc
     */
    public ESC_InvoiceListWrapper.Pagiwrapper pagiwrap {get;set;}
    /**
     * @description Justdesc
     * @param controller
     */
    
    public ESC_AssociateInvoiceController(ApexPages.StandardController controller) {        
        caseid = String.escapeSingleQuotes(Apexpages.currentpage().getparameters().get('id').escapeHtml4());
        invwrap = new ESC_InvoiceWrapper ();
        insavecon = new ESC_InvoiceHelper ();
        showLineNumber = false; 
        Invoicemap = new Map<String,ESC_Invoice_Item__c>();
        invhelper = new ESC_InvoiceListWrapper();
        invwrap.begindt = system.today().addDays(-365);
        invwrap.enddt = system.today();
        querycasessddata();
        validatesapnumber();
        //queryinvoicedata();
    }
    
    void querycasessddata(){
        Source_System_Detail__c ssd = new Source_System_Detail__c ();
        if (Schema.sObjectType.Case.isAccessible()){         
            caseacc = [Select Id,CaseNumber,BU_Segment__c,LCRM_Sub_BU__c,USL_SAP_Account_Number__c,ESC_Invoice_Numbers__c FROM Case where id =:caseid];
        }
        if ((caseacc.USL_SAP_Account_Number__c != null && caseacc.USL_SAP_Account_Number__c != '') && Schema.sObjectType.Source_System_Detail__c.isAccessible()){        
            ssd = [Select BU_Segment__c,LCRM_Sub_BU__c from Source_System_Detail__c where Source_System_Account_Number__c =:caseacc.USL_SAP_Account_Number__c];            
        }
        intval = USLARHelper.getIntegrationDefaults(ssd.BU_Segment__c,ssd.LCRM_Sub_BU__c);
        if(intval!=null && intval.ApplicationId__c == 'ESCH' && intval.companyId__c =='S100'){
            showLineNumber = true;
        }        
    }
     /**
     * @description Justdesc
     * @param showlinenumber
     * @param caseid
     * @return just
     */
    public Map<String,ESC_Invoice_Item__c> queryinvoicedata(boolean showlinenumber,String caseid){
        if (Schema.sObjectType.ESC_Invoice_Item__c.isAccessible()){
            for(ESC_Invoice_Item__c invitem : [Select ESC_InvoiceNumber__c,ESC_Line_number__c,ESC_Net_Amount__c from ESC_Invoice_Item__c where ESC_Case__c =:caseid]){
                if(showLineNumber){
                    Invoicemap.put(invitem.ESC_InvoiceNumber__c+invitem.ESC_Line_number__c,invitem);
                }
                else{
                    Invoicemap.put(invitem.ESC_InvoiceNumber__c,invitem);
                }
            }
        }
        return invoicemap;
    }

    void validatesapnumber(){
        if(Caseacc != null && (Caseacc.USL_SAP_Account_Number__c == '' || Caseacc.USL_SAP_Account_Number__c == null)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please populate the SAP Account number for the Case')); 
            return;
        }
    }
     /**
    * @description Justdesc
    * 
    */

    public void checkdate(){
        try {
            //invwrap = new ESC_InvoiceWrapper ();
            Integer iTotalNumberOfDays = 0; 
            if(invwrap.BeginDt == null || invwrap.Enddt == null){
                throw new AppUtil.AppException('Enter start date and end date');
            }
            iTotalNumberOfDays = invwrap.Begindt.daysBetween(invwrap.Enddt);            
            if(invwrap.Begindt > invwrap.Enddt){
                throw new AppUtil.AppException(Label.DateError);  
            }if(iTotalNumberOfDays > 365){
                throw new AppUtil.AppException(System.Label.AccountRec_DateRangeErrMsg); 
            } 
            callresponse();
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
    }

    void callresponse(){
        Date bd =  invwrap.Begindt;
        Date ed =  invwrap.Enddt;
        Datetime bdt = Datetime.newInstance(bd.year(), bd.month(),bd.day());
        Datetime edt = Datetime.newInstance(ed.year(), ed.month(),ed.day());
        String begindt1 = bdt.format('yyyy-MM-dd');
        String enddt1 = edt.format('yyyy-MM-dd');
        pagiwrap =  invhelper.getresponses(begindt1,enddt1,Caseacc.USL_SAP_Account_Number__c);  
    }
     /**
     * @description Justdesc
     *
     */
    public void saveInvoice(){
        try{
            invwrap.issuccess = insavecon.saveInvoices(caseid,showLineNumber,pagiwrap);
            if(invwrap.issuccess){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Save Successful')); 
            }          
        }
        catch(Exception e){
             Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage())); 
        }
    }
     /**
     * @description Justdesc
     * @return Justdesc
     */
    public PageReference previousPage(){
        System.debug(LoggingLevel.DEBUG,'**previousPage**');
        pagiwrap.openpagiwrap.paginater.decrement();
        return changeData();
    }
     /**
     * @description Justdesc
     * @return Justdesc
     */
    public PageReference nextPage(){
        System.debug(LoggingLevel.DEBUG,'**nextPage**');
        pagiwrap.openpagiwrap.paginater.increment();
        return changeData();
    }

     /**
     * @description Justdesc
     * @return Justdesc
     */
    public PageReference updatePage(){
        System.debug(LoggingLevel.WARN,'**call updatePage**');
        pagiwrap.openpagiwrap.paginater.updateNumbers();
        return changeData();
    }

    PageReference changeData(){                
        pagiwrap.openpagiwrap.openwrapperlist2= pagiwrap.openpagiwrap.openwrapperlist1.get(pagiwrap.openpagiwrap.paginater.index);
        return null;
    }
      /**
     * @description Justdesc
     * @return Justdesc
     */
    public PageReference cpreviousPage(){
        pagiwrap.clearpagiwrap.clearpaginater.decrement();
        return cchangeData();
    }

     /**
     * @description Justdesc
     * @return Justdesc
     */
    public PageReference cnextPage(){
        pagiwrap.clearpagiwrap.clearpaginater.increment();
        return cchangeData();
    }
      /**
     * @description Justdesc
     * @return Justdesc
     */
    public PageReference cupdatePage(){
        pagiwrap.clearpagiwrap.clearpaginater.updateNumbers();
        return cchangeData();
    }

    PageReference cchangeData(){
        pagiwrap.clearpagiwrap.clearwrapperlist2= pagiwrap.clearpagiwrap.clearwrapperlist1.get(pagiwrap.clearpagiwrap.clearpaginater.index);
        return null;
    }
}