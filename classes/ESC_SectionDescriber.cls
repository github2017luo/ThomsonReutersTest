public class ESC_SectionDescriber {
    public  List<String> fsAPINameList {get; set;}
    public  Map<String ,Boolean> fieldEditableInfoMap {get; set;}
    public String objectName {get; set;}
    public string refFieldSet{get; set;}
    public List<SObject> sobjList;
    public SObject sobj{get; set;}
    public integer count{get; set;}
    public string styleCLS {get; set;}
    public  Boolean isTabular{get; set;}
    public  Boolean isInitilaized{get; set;}
    public Boolean isVFP{get; set;}
    public Boolean isPlainLayout{get; set;}
    public string vfComponentName{get; set;}
      public  Map<String,String> readOnlyFieldsMap{get; set;}   
          
    public integer layoutColumns{get; set;}
    public Boolean isEditableSection {get; set;}
    public Boolean isRendered {get; set;}
    public String referencedRecordType{get;set;}
        public void setsobjList(List<SObject> sobjL){
            sobjList = sobjL;
            
        }
          public List<SObject> getsobjList(){
            return sobjList;
        }
    public ESC_SectionDescriber(){
        isEditableSection=false;
      isPlainLayout = false;
      isTabular = false;
      isVFP = false;
      isInitilaized =false;
      isRendered = true;
      fsAPINameList = new List<String>();
       readOnlyFieldsMap= new Map<String,String>();
      sobjList = new List<SObject>();
      fieldEditableInfoMap = new  Map<String ,Boolean> ();
    }
    
    public void setEditableProp(){
          if(this.objectName.equalsignoreCase('ESC_Case_Form_Extension__c') || this.objectName.equalsignoreCase('ESC_Case_Form_Extension_Line_Item__c')){
              this.isEditableSection = true;
          }
          else{
               this.isEditableSection = false;
          }
    }
    
    public void setNonEditableFields(){
        
    }

    public integer getNumberOFCOlumns(string layoutType){
      integer columns = 1;
      if(layoutType.equals('2 Columns'))
        columns = 2;
      else if(layoutType.equals('3 Columns'))
        columns = 3;

      return columns;
    }
  
  }