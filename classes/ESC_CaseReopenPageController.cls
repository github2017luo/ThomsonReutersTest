/**********************************
Class Name: ESC_CaseReopenPageController 
Purpose:
Author:Mousumi Panda
Date Created:07/06/2017
Date Updated:V0:
**********************************/

public class ESC_CaseReopenPageController {
    public ApexPages.StandardController casCntrl {get;set;}
    String caseid = null;
    public Case cas {get;set;}
    public String result {get;set;}
    public string callfunc{get;set;}
    public String isCaseDetail;

    public ESC_CaseReopenPageController(ApexPages.StandardController controller) {
    result = 'fail';
    caseid = controller.getRecord().Id;
    system.debug('params@@ '+ApexPages.currentPage().getParameters());
    isCaseDetail='true';
    }
    
    public void initializeCaseRecord(){
    cas = new Case();   
    cas = [Select id,RecordType.Name from Case where id=:caseid]; 
    cas.Status='Work In Progress';
    
    String openRecordType =cas.RecordType.Name.substringBefore(' (');
    system.debug('OpenRecordType *************'+openRecordType);
    cas.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(openRecordType).getRecordTypeId();
     system.debug('Cas.RecordTypeId *************'+cas.RecordTypeId);
   // if(cas.RecordType.Name=='Incident (Read Only)' || cas.RecordType.Name== 'Hot Topic (Read Only)')
    cas.ESC_Fix_Applied_Time__c= null;
    cas.ESC_Service_Restored__c= null;
    cas.ESC_Resolved_by__c= null;
    casCntrl = new ApexPages.StandardController(cas);
   
    casCntrl.save();
  
}

 public PageReference initializeCaseRecordForBtn(){
     try {
         InitializeCaseRecord();
         string cacheOpn = apexpages.CurrentPage().getParameters().get('scontrolCaching');
        PageReference openedCasePage;
        system.debug('shh!! '+apexpages.CurrentPage().getParameters());
        if(string.isBlank(cacheOpn)){
        openedCasePage = new PageReference('/apex/ESC_RedirectPage');
        
        }
        else{
          openedCasePage = new pagereference('/'+caseid);
        }
        system.debug('PageReference ' + openedCasePage);
        openedCasePage.setRedirect(true);
        return openedCasePage;
     }
     catch(Exception e){
    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'There is an issue updating this record : '+e);
    ApexPages.addMessage(msg);
    return null;
  }
 }

public PageReference initializeCaseRecordForPA(){
       try {
    InitializeCaseRecord();   
    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.ESCReopenSuccessMessage);
    ApexPages.addMessage(msg);
    
    result ='True';
     }
     catch(Exception e){
    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'There is an issue updating this record : '+e);
    ApexPages.addMessage(msg);
   
  }
   return null;
 }
 
 public string getResultVal(){
     return result;
 }
 
    

}