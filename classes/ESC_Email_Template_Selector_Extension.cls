public class ESC_Email_Template_Selector_Extension{

    private final ESC_EPx_Template_Selector__c templateSelector;
    public String selectedTemplateId { public get; public set; }

    public List<SelectOption> getMyPersonalTemplateOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for (EmailTemplate t : [
            SELECT Id,Name 
            FROM EmailTemplate
            WHERE Folder.DeveloperName = : 'EPx_Email_Templates'
            AND isActive = true
        ]) {
            options.add(new SelectOption(t.Id,t.name));
        }
        return options;
    }
    
    public String getTemplateName(){
        ESC_EPx_Template_Selector__c ts = [Select ESC_EPx_Email_Template__c FROM ESC_EPx_Template_Selector__c where id = : templateSelector.id];
          try{
            EmailTemplate template = [SELECT name from EmailTemplate where ID =:ts.ESC_EPx_Email_Template__c limit 1];
            return template.name;
        }
        catch(exception e){
            System.debug('Unable to find email template');
        }
        return null;
    }

    public ESC_Email_Template_Selector_Extension(ApexPages.StandardController stdController) {
        this.templateSelector = (ESC_EPx_Template_Selector__c)stdController.getRecord();
    }
    
    Public string[] getselectedProfileList(){
        List<ESC_EPx_Template_Selector__c> hq1  = [Select Profile__c from ESC_EPx_Template_Selector__c where id =:templateSelector.id];
        if(hq1 != null && hq1.size() > 0 && hq1[0].Profile__c !=null){
           return hq1[0].Profile__c.split(',');
        }
        else{
            return null;
        }
    }
    
    
    public void setselectedProfileList(string[] vals){
        templateSelector.Profile__c = string.join(vals,',');
    }
    
     Public List<Selectoption> getprofileList(){
        List<Selectoption> profiles= new List<selectoption>();
        // for(profile p :[SELECT id,Name from Profile ]){
        for(profile p :[SELECT Id,Name,UserLicenseId FROM Profile where UserLicenseId in (SELECT Id FROM UserLicense where name ='Salesforce')]){
            profiles.add(new selectoption(p.name,p.name));
        }
    return profiles;
    }

    
    public string[] getselectedRecordTypeList(){
        List<ESC_EPx_Template_Selector__c> hq1  = [Select Record_Type__c from ESC_EPx_Template_Selector__c where id =:templateSelector.id];
        if(hq1 != null && hq1.size() > 0 && hq1[0].Record_Type__c !=null){
           return hq1[0].Record_Type__c.split(',');
        }
        else{
            return null;
        }
    }
    
    public void setselectedRecordTypeList(string[] vals){
        templateSelector.Record_Type__c = string.join(vals,',');
    }
    
     Public List<Selectoption> getRecordTypeList(){
        List<Selectoption> cases= new List<selectoption>();
        
        List<RecordType> caseRecordTypes = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case'];
        /*Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(rt.name);
        System.assertEquals(rtById,rtByName);*/

        
        for(RecordType rt: caseRecordTypes){
            cases.add(new selectoption(rt.name, rt.name));
        }
    return cases;
    }
    
    
      
}