public class ESC_RelatedCaseController {
    
    Case selectedCase = new Case();
    public string idOfRecord {get; set;}
    public string primaryTabid {get; set;}
    public boolean booleanSubTab {get; set;}
    public string primaryTabtitle {get; set;}
    public string subTabtitle {get; set;}
    public String rectype='';
    public boolean isComplaint = false;
    public boolean hasError {get; set;}
    public Case pcase = new Case();
    public String retURL='';
    public String errmsg{get;set;}
    
   
    
    public ESC_RelatedCaseController(ApexPages.StandardController controller) {
          if (!Test.isRunningTest()) { // changes done due to error "system-sobjectexception-you-cannot-call-addfields-when-the-data-is-being-passed-into-the-controller-
         // by-the-caller during exection of test class.
        controller.addFields(new List<String>{'id', 'accountId','casenumber', 'contactId', 'Status', 'ParentId', 'Ownerid', 'ESC_Preferred_Contact_Method__c', 'Subject', 'ESC_Case_Sub_Type__c', 'Description'});
          }
        selectedCase = (Case) controller.getRecord();
        //use the following
        rectype='';
        rectype= ApexPages.currentPage().getParameters().get('rectype');
        system.debug('rectype%%'+rectype);
        primaryTabid = '/'+selectedCase.id;
        primaryTabtitle = selectedCase.casenumber;
        system.debug(selectedCase);
        booleanSubTab = false;
        hasError = false;
       // CreateRelatedCase();
       
    }
    
    
    public PageReference createRelatedCase(){
        if(string.isNotBlank(selectedCase.ParentId) && !rectype.equalsIgnoreCase('Complaint')){
           hasError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ESC_ParentExistingAlready));
           return null;
        }
        List<FeedItem> listPost= new List<FeedItem>();//EES-470
        
        Case caseRec = new Case();
        caseRec.accountId = selectedCase.accountId;
        caseRec.contactId = selectedCase.contactId;
        caseRec.Status = 'Work In Progress';
        caseRec.Ownerid = UserInfo.getUserId();
        caseRec.ESC_Preferred_Contact_Method__c = selectedCase.ESC_Preferred_Contact_Method__c;
        caseRec.Subject = selectedCase.Subject;
        caseRec.Description = selectedCase.Description;
        caseRec.ParentId = selectedCase.id;
        if(rectype=='EnhancementRequest'){
            caseRec.ESC_Case_Type__c = 'Enhancement Request';
            isComplaint = false;
        }
        else if(rectype == 'Feedback' ){
            caseRec.ESC_Case_Type__c = 'Feedback';            
            isComplaint = false;
        }
        else if(rectype == 'Complaint'){
            isComplaint = true;
            caseRec.ESC_Case_Type__c = 'Feedback';
            caseRec.ESC_Case_Sub_Type__c = 'Complaint';
            //caseRec.ParentId = selectedCase.id;
            
        }
        
        insert caseRec;
        
        idOfRecord = caseRec.id;
        caseRec = [select casenumber from case where id =:idOfRecord];
        
        //Bug fix for EES-470 
        FeedItem post= new FeedItem();
        post.ParentId=selectedCase.id;
        string userName=UserInfo.getName();
        if(rectype == 'Feedback' ){
            post.Body=userName+' '+System.Label.ESC_FeedbackMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
            listpost.add(post);
        }
        else if(rectype == 'Complaint'){ 
            post.Body=userName+' '+System.Label.ESC_ComplaintMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
            listpost.add(post);   
        }else if(rectype == 'EnhancementRequest' ){
            post.Body=userName+' '+System.Label.ESC_ERMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
            listpost.add(post);
        }
        else if(rectype == 'EnhancementRequest' ){
            post.Body=userName+' '+System.Label.ESC_ERMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
            listpost.add(post);
        }
        if(listpost.size()>0){
            insert listpost;
        }//END EES-470
        
        /*if(!isComplaint){
        pcase = [select id,parentId,casenumber from case where id=:selectedCase.id];
            Case updCase = new Case();
            updCase.id = pcase.id;
            updCase.parentId = caseRec.Id;
            update updCase;
        }*/
        //idOfRecord = caseRec.id;
        // caseRec = [select casenumber from case where id =:idOfRecord];
        subTabtitle = caseRec.casenumber;
        idOfRecord ='/'+idOfRecord;
        return null;
        //  redirectPage = new PageReference('/apex/ESC_PrimarySecondaryConsoleHandler?pTab='+primaryTabid+'&sTab='+idOfRecord);
    }
    
}