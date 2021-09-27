public with sharing class ESC_HomePageQueryController {

    ESC_HomePageQuery__c hq = new ESC_HomePageQuery__c ();
    public Boolean isNewRecord = false;
    public ESC_HomePageQuery__c ehqr{get;set;} 
    public Boolean inlineEditFlg {get;set;} 
    public String selectedRLField {get;set;}
    public String relatedFieldOptions {get;set;}


      
   // public String selectedObject { get; set; }
   //  public String selectedField { get; set; }
    
    public ESC_HomePageQueryController(ApexPages.StandardController controller) {
        try{
       if (!Test.isRunningTest())
       {controller.addFields(getFieldNamesOutOfFieldSet());
       }
     this.ehqr = (ESC_HomePageQuery__c)controller.getRecord();
    inlineEditFlg = true;
    if(ehqr.id == null ){
        ehqr = new ESC_HomePageQuery__c();
        isNewRecord = true;
    }
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getmessage()));
        }

    }
    
      public List<string> getFieldNamesOutOfFieldSet(){
         List<Schema.FieldSetMember> s = ESC_Utility.readFieldSet('esc_HomePageQueryFieldSet','ESC_HomePageQuery__c');
       List<string> fieldNamesList = new List<String>();
        
        for(Schema.FieldSetMember f : s) {
           fieldNamesList.add(f.getFieldPath());
        }
        return fieldNamesList;
    }
    
    
    public List<Schema.FieldSetMember> getFields() {
            system.debug('Inside Method: ');
        return SObjectType.ESC_HomePageQuery__c.FieldSets.esc_HomePageQueryFieldSet.getFields();
    }
    
    
    Public string[] getselectedProfileList(){
        List<ESC_HomePageQuery__c> hq1  = [Select ESC_Profiles__c from ESC_HomePageQuery__c where id =:ehqr.id];
        if(hq1 != null && hq1.size() > 0 && hq1[0].ESC_Profiles__c !=null){
           return hq1[0].ESC_Profiles__c.split(',');
        }
        else{
            return null;
        }
    }
    
    
    public void setselectedProfileList(string[] vals){
        ehqr.ESC_Profiles__c = string.join(vals,',');
    }
    
    
    
    Public List<Selectoption> getprofileList(){
        List<Selectoption> profiles= new List<selectoption>();
        // for(profile p :[SELECT id,Name from Profile ]){
        for(profile p :[SELECT Id,Name,UserLicenseId FROM Profile where UserLicenseId in (SELECT Id FROM UserLicense where name ='Salesforce')]){
            profiles.add(new selectoption(p.name,p.name));
        }
    return profiles;
    }
    
    Public string getselectedPTName(){
        List<ESC_HomePageQuery__c> hq1  = [Select ESC_PushTopicName__c from ESC_HomePageQuery__c where id =:ehqr.id];
        if(hq1 != null && hq1.size() > 0 && hq1[0].ESC_PushTopicName__c !=null){
           return hq1[0].ESC_PushTopicName__c;
        }
        else{
            return null;
        }
    }
    
    
    public void setselectedPTName(string val){
        ehqr.ESC_PushTopicName__c = val;
    }
    
   /* Public string getselectedSequenceName(){
        List<ESC_HomePageQuery__c> hq1  = [Select ESC_Sequence__c from ESC_HomePageQuery__c where id =:ehqr.id];
        if(hq1 != null && hq1.size() > 0 && hq1[0].ESC_Sequence__c !=null){
           return hq1[0].ESC_Sequence__c;
        }
        else{
            return null;
        }
    }
    
    
    public void setselectedSequenceName(string val1){
        ehqr.ESC_Sequence__c= val1;
    }
    */
    
    
    Public List<Selectoption> getptnameList(){
        List<Selectoption> ptnames = new List<selectoption>();
            ptnames.add(new selectoption('','-- none --'));
        for(pushtopic p :[SELECT id,Name from pushtopic]){
            ptnames.add(new selectoption(p.name,p.name));
        }
    return ptnames;
    }
   
    // QueryBuilder logic
        Public string[] getselectedField(){
        List<ESC_HomePageQuery__c> hq1  = [Select ESC_ReturnedColumns__c from ESC_HomePageQuery__c where id =:ehqr.id];
        if(hq1 != null && hq1.size() > 0 && hq1[0].ESC_ReturnedColumns__c != null){
           return hq1[0].ESC_ReturnedColumns__c.split(',');
        }
        else{
            return null;
        }
    }
    
    
    public void setselectedField(string[] vals){
        ehqr.ESC_ReturnedColumns__c = string.join(vals,',');
    }
     



    public void updateInlineEditFlg(){
        inlineEditFlg = false;
    }
    
    // HomePageQueryBuilderPage Logic
/*    public SelectOption[] getObjectOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
        for(SObjectType sType: Schema.getGlobalDescribe().values()) {
            DescribeSObjectResult res = sType.getDescribe();
            results.add(new SelectOption(res.getName(), res.getLabel()));
        }
        return results;
    }
  */  
  
  
    public SelectOption[] getFieldOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
      //  if(selectedObject != null) {
          if(ehqr.ESC_ObjectType__c != null && ehqr.ESC_ObjectType__c != '-- None --'){
            for(SObjectField sField: Schema.getGlobalDescribe().get(ehqr.ESC_ObjectType__c).getDescribe().fields.getMap().values()) {
                DescribeFieldResult res = sField.getDescribe();
                results.add(new SelectOption(res.getName(), res.getLabel()));
              // results.add(new SelectOption(res.getName(), res.getName()));
            }
        }
        return results;
    }
    
    
    public PageReference save(){
      try{
          if(isNewRecord && ehqr != null){
              insert ehqr;
          }else{
              if(ehqr != null){
                update ehqr;
              }
          }
      }catch(exception e){

          if(e.getMessage().contains('duplicate')){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Duplicate value for Sequence Field exists. Please check the value'));
          system.debug(e);
         
          }
           return null;
      }      
        
        PageReference pgRef;
        
        if(!inlineEditFlg){
            //pgRef = new PageReference('/ESC_HomePageQueryInlineEditPage');
            inlineEditFlg = true;
            return null;
        }else{
            pgRef = new PageReference('/'+ehqr.id);
        }
        pgRef.setRedirect(true);
        return pgRef;
        
                
    }
   
   //Method to get the original data of record, can be used in cancel button
   public void getQueryData(Id ehqrid){
        ehqr = [select id,ESC_ObjectType__c,ESC_AssignedTo__c, ESC_Sequence__c,ESC_Limit__c,ESC_ReturnedColumns__c,ESC_OverrideLabelsForfields__c,
                       ESC_NoTruncation__c,ESC_PgntnEnabled__c,ESC_PushTopicName__c,ESC_IsInActive__c,ESC_CustomLabel__c,ESC_Profiles__c,ESC_FilterCriteria__c
                       from ESC_HomePageQuery__c where id=:ehqrid];
   }
   public void reset(){
       if(ehqr.id != null){
           getQueryData(ehqr.id);
       }
       
       inlineEditFlg = true;
     
   }
   
 
}