@isTest
public class ESC_SectionDescriber_test  {

public static testmethod void testmethod1(){
    test.starttest();
    string vfComponentName;
    string refFieldSet;
    SObject sobj;
    integer count;
    string styleCLS;
    integer layoutColumns;
    String referencedRecordType;
    ESC_SectionDescriber ins = new ESC_SectionDescriber();
    ins.setNonEditableFields();
    ins.getsobjList();
    ins.objectName='ESC_Case_Form_Extension__c';
    ins.setEditableProp();
    List<SObject> Lsobj=new List<SObject>();
    ins.setsobjList(Lsobj);
    
    
    ins.objectName='';
    ins.setEditableProp();
    string layoutType='2 Columns';
    ins.getNumberOFCOlumns(layoutType);
    string layoutType1='3 Columns';
    ins.getNumberOFCOlumns(layoutType1);
    ins.vfComponentName = 'vfcomp';
    ins.referencedRecordType='refrecType';
    ins.refFieldSet='refFldset';
    ins.count=3;
    ins.styleCLS='srtr';
    ins.layoutColumns=8;
    
    ESC_Case_Form_Extension__c trt=new ESC_Case_Form_Extension__c();
    ins.sobj=trt;
    test.stoptest();
}
    
     
}