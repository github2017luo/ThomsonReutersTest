public abstract class ESC_FormsAbstractExecute{
    
    public String formId{get;set;}
    public String formName{get;set;}
    public String caseId{get;set;}
    public Map<String, ESC_ComponentControllerBase> componentControllerMap{get;set;}
    public abstract void executePreRender();
    public abstract void validateForms();
    public abstract void executePostSubmit();
}