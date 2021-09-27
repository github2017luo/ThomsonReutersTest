public without sharing class ESC_FormGenratorController extends ESC_PageControllerBase{
    
    public GenerateForm__c gForm{get; set;}
    public ESC_SectionDetails esd {get;set;}
    public List<String> sectionIDS{get; set;}
    public Map<String,string> sectionIdentifierMap{get; set;}
    public Map<String,ESC_SectionDescriber> sectionDescriberMap{get; set;}
    public List<String> initView{get;set;}
    public boolean hasMasterOrigin = false;
    public set<string> relatedSectionNames = new set<string>();
    public string specificFormID;
    public string specificFormName;
    public string recordID;
    public Boolean hasError{get; set;}
    public ESC_Case_Form_Extension__c singleExtension {get; set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> singleExtensionLineItemsList {get; set;}
    public string getSectionIDSJson(){
        return JSON.serialize(sectionIDS);
    }
    public ESC_FormGenratorController(){
        specificFormName = '';
        hasError= false;
        specificFormID = string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('formID').escapeHtml4());
        if(ApexPages.currentPage().getParameters().get('FormName') != null){
            specificFormName = string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('FormName').escapeHtml4());
        }    
        singleExtension = new ESC_Case_Form_Extension__c ();
        singleExtensionLineItemsList = new List<ESC_Case_Form_Extension_Line_Item__c>();
        
        recordID = string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id').escapeHtml4());
        
        string masterQueryparamKey;
        esd = new ESC_SectionDetails();
        sectionIDS = new List<string>();
        sectionIdentifierMap = new Map<string,string>();
        sectionDescriberMap = new  Map<String,ESC_SectionDescriber>();
        if(Schema.sObjectType.GenerateForm__c.isAccessible() || Schema.sObjectType.GenerateForm__c.isQueryable()){
         gForm = [SELECT name,Description__c,Form_Footer__c,Form_Header__c,Id,LabelName__c,ESC_Executer__c FROM GenerateForm__c where id = :specificFormID ];
        }
        for(Form_Section__c fs : [SELECT Section__c ,Section__r.name,Sequence__c ,ESC_QPIdentfier__c,ESC_ParentFormSection__c,ESC_ParentFormSection__r.ESC_QPIdentfier__c ,ESC_IsFormOrigin_del__c,
                                  Section__r.ESC_Referenced_Object__c, Section__r.ESC_Referenced_Record_Type__c
                                  FROM Form_Section__c WHERE GenerateForm__c = : specificFormID and  Is_Active__c = true order by Sequence__c]){
                                      
                                      sectionIDS.add(fs.Section__c);
                                      sectionIdentifierMap.put(fs.Section__c,fs.Section__r.name);
                                      sectionDescriberMap.put(fs.Section__r.name, new ESC_SectionDescriber() );
                                      esd.allformSections.add(fs);
                                      
                                      if(fs.ESC_IsFormOrigin_del__c){
                                          esd.hasMasterOrigin = true;
                                          masterQueryparamKey = fs.ESC_QPIdentfier__c;
                                          esd.masterObject = fs.Section__r.ESC_Referenced_Object__c;
                                          if(ApexPages.currentPage().getParameters().get(masterQueryparamKey) !=null){
                                          esd.masterRecordID = string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(masterQueryparamKey).escapeHtml4());
                                          system.debug('masterRecordID ---> :' + esd.masterRecordID );
                                          }  
                                      }
                                      if(string.isNotBlank(fs.ESC_QPIdentfier__c)){
                                          relatedSectionNames.add(fs.ESC_QPIdentfier__c);
                                      }
                                      
                                  }
        
        if(esd.hasMasterOrigin && string.isNotBlank(esd.masterRecordID)){
            string query = 'select '+string.escapeSingleQuotes(string.join(new List<string>(relatedSectionNames),',')) +' from '+string.escapeSingleQuotes(esd.masterObject) +' where '+string.escapeSingleQuotes(masterQueryparamKey)+' =\''+string.escapeSingleQuotes(esd.masterRecordID)+'\'';
            system.debug(query);
            esd.masterRecord = Database.query(query);
        }
        if(!String.isBlank(gForm.ESC_Executer__c)){
            Type aClass = type.forName(gForm.ESC_Executer__c);
            ESC_FormsAbstractExecute absExec = (ESC_FormsAbstractExecute) aClass.newInstance();
            absExec.formId = specificFormID;
            absExec.formName = specificFormName;
            absExec.caseId = esd.masterRecordID;
            absExec.componentControllerMap = getComponentControllerMap();
             // absExec.executePreRender();           
           // Added as part of DSS-7885 tax
            try
            {
            absExec.executePreRender();
            }
             catch(Exception e){
                hasError= true;
                system.debug('Exception: '+e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
                
                
            } 
        }
    }
    public void adderrorMessage(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ESC_CSSFormsMandate));
    } 
    
    
    public PageReference saveTheResults(){
        
        Savepoint sp = Database.setSavepoint();
        try{
            for(ESC_ComponentControllerBase ecb:getComponentControllerMap().values()){
                ecb.saveComponent();
                
            }
          //  for(String s:getComponentControllerMap().keyset()){ 
           //           system.debug('Map: Key is '+s+':'+getComponentControllerMap().get(s));
          //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, s+':'+getComponentControllerMap().get(s))); 
          //          }
            try{
                if(!String.isBlank(gForm.ESC_Executer__c)){
                    Type aClass = type.forName(gForm.ESC_Executer__c);
                    ESC_FormsAbstractExecute absExec = (ESC_FormsAbstractExecute) aClass.newInstance();
                    absExec.formId = specificFormID;
                    absExec.caseId = esd.masterRecordID;
                    absExec.formName = specificFormName;
                    absExec.componentControllerMap = getComponentControllerMap();
                    //for(String s:absExec.componentControllerMap.keyset()){ 
                    //  system.debug('Map: Key is '+s+':'+absExec.componentControllerMap.get(s));
                    //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, s+':'+absExec.componentControllerMap.get(s))); 
                    //}
                    absExec.validateForms();
                    absExec.executePostSubmit();
                }
            }
            catch(Exception e){
                system.debug('Exception: '+e.getMessage());
                system.debug('Trace: '+ e.getStackTraceString());
                throw new ESC_HandlerCustomException('Exception :' + e.getMessage());
            }                   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Your data is saved succesfully' )); 
        }
        catch(exception e){
            system.debug('Exception: '+e.getMessage());
            system.debug('Trace: '+ e.getStackTraceString());
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Save Failed From, rolling Back changes ' + e.getmessage())); 
            Database.rollback(sp);
        }
        
        return null;
    }
   
    public void onloadrerender(){
        try{
      initView = new List<String>();
         for(String secname:sectionIdentifierMap.values()){
             ESC_FormGeneratorCompController fGCS = (ESC_FormGeneratorCompController)getComponentControllerMap().get(secname);
             if(fGCS.fieldDescpn == null){ continue;}
             for(String s:fGCS.fieldDescpn.keyset()){
                 system.debug('PC FieldAPI '+s);
                 List<ESC_FormGeneratorCompController.FieldDescriber> fdList = (List<ESC_FormGeneratorCompController.FieldDescriber>)JSON.deserialize(fGCS.fieldDescpn.get(s),List<ESC_FormGeneratorCompController.FieldDescriber>.class);
                 system.debug('PC fdList '+fdList);
                 for(ESC_FormGeneratorCompController.FieldDescriber fd:fdList){
                     system.debug('PC fd '+fd);
                    ESC_FormGeneratorCompController fGCC = (ESC_FormGeneratorCompController)getComponentControllerMap().get(sectionIdentifierMap.get(fd.sectionToReRender));
                    system.debug('PC fGCC '+fGCC);
                    if(fGCC!=null){
                      if(fd.fieldRerenederValue==fGCS.currentDescribedSection.sobj.get(s)){
                          system.debug('PC true '+fd.fieldRerenederValue+'=='+fGCS.currentDescribedSection.sobj.get(s));
                          fGCC.currentDescribedSection.isRendered=true;
                          initView.add(fd.sectionToReRender);
                      }
                      else{
                          system.debug('PC fasle ');
                          fGCC.currentDescribedSection.isRendered=false;
                      }
                    }
              }
             }
        }
        
            
    }
   
    catch(exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'onloadrerender error'+e.getmessage()));
    }
       
    }
    
}