public with sharing class ESC_CaseClosedController {

    public boolean gojs{get;set;}
    public string address{get; set;}
    public string errorMessage;
    
    public ESC_CaseClosedController() {
        gojs=true;
    }
    
     public ESC_CaseClosedController(ApexPages.StandardController controller) {
            gojs=true;
    }
    public void getaddressPT(){
        address = '/apex/ESC_RedirectPage';
    }
   public void getaddressST(){
        address = '/apex/ESC_RedirectPage'+String.escapeSingleQuotes(apexpages.CurrentPage().getParameters().get('Id').escapeHtml4());
    }
    public PageReference checkAndRedirect(){ 
        errorMessage = 'NoError';
        Case caseRecord = new Case();
        Id caseId = apexpages.CurrentPage().getParameters().get('Id');
        string cacheOpn = apexpages.CurrentPage().getParameters().get('scontrolCaching');
        PageReference closedCasePage;
        system.debug('$$$ Page Parameter: '+apexpages.CurrentPage().getParameters());
        try {
            caseRecord.id = caseId;
            caseRecord.status ='Closed';
            if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable()){
            update caseRecord;
            }
        }catch(Exception e){
            errorMessage = e.getMessage();
        }
            
        system.debug('$$$ Exception: '+errorMessage);
        if(errorMessage == 'NoError'){
            closedCasePage = new PageReference('/'+caseId);    
        }
        else{
            if(string.isBlank(cacheOpn)){
                closedCasePage = new PageReference('/'+caseId+'/s?cas7=Closed&nooverride=1&retURL=/apex/ESC_RedirectPage');
        
            }
            else{
                closedCasePage = new PageReference('/'+caseId+'/s?cas7=Closed&nooverride=1&retURL='+caseId);  
            }    
        }
        
        system.debug('PageReference ' + closedCasePage);
        closedCasePage.setRedirect(true);
        system.debug('PageReference ' + closedCasePage);
        gojs=true;
        return closedCasePage;             
    }
    
    public string getIDToOpen(){
       string val =  apexpages.CurrentPage().getParameters().get('PTId');
       return string.isBlank(val) ? '' : val;
    }
}