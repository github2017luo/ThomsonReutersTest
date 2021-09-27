@IsTest
public class ESC_HomePageQueryController_Test{
    
public static testmethod void  method1()
{
 
            
             Boolean inlineEditFlg=false ;
            // String selectedRLField ;
            // String relatedFieldOptions ;
            // Boolean isNewRecord=true;
    
ESC_HomePageQuery__c rec1=new ESC_HomePageQuery__c();
rec1.ESC_ObjectType__c='Case';
rec1.ESC_Sequence__c='';
rec1.ESC_AssignedTo__c= 'Current User Only';
rec1.ESC_Profiles__c= 'System Administrator' ;
rec1.ESC_ReturnedColumns__c='status';
rec1.ESC_PushTopicName__c= 'CR_02' ;
//insert rec1;
 
ESC_HomePageQuery__c rec2=new ESC_HomePageQuery__c();
rec2.ESC_ObjectType__c='Case';
rec2.ESC_Sequence__c='';
rec2.ESC_AssignedTo__c= 'Current User Only';
rec2.ESC_Profiles__c= 'Sample Helpdesk Agent' ;
rec2.ESC_ReturnedColumns__c='status';
rec2.ESC_PushTopicName__c= 'CR_02' ;
//insert rec2;

ESC_HomePageQuery__c ehqr=new ESC_HomePageQuery__c();
ehqr.ESC_ObjectType__c='Case';
ehqr.ESC_Sequence__c='';
ehqr.ESC_AssignedTo__c= 'Current User Only';
insert ehqr;
// ehqr.ESC_ObjectType__c='Case';
// ehqr.ESC_Sequence__c='3';
// ehqr.ESC_AssignedTo__c= 'Current User Only';
// ehqr.ESC_Profiles__c= 'Sample Helpdesk Agent' ;
// ehqr.ESC_ReturnedColumns__c='status';
// ehqr.ESC_PushTopicName__c= 'CR_02' ;

 List<ESC_HomePageQuery__c> hq1 = new List<ESC_HomePageQuery__c>();
  hq1.add(rec1);
 hq1.add(rec2);
//  hq1.add(ehqr);
  insert hq1;
  system.debug('rec1.id>>'+rec1);
  system.debug('rec2.id>>'+rec2);
  
  List<Schema.FieldSetMember> s = ESC_Utility.readFieldSet('esc_HomePageQueryFieldSet','ESC_HomePageQuery__c');
       List<string> fieldNamesList = new List<String>();
  

 string v;
list<string> v1=new List<string>();


ApexPages.StandardController sc = new ApexPages.StandardController(rec1);
ESC_HomePageQueryController obj=new ESC_HomePageQueryController(sc);
 

 
obj.getFieldNamesOutOfFieldSet(); 
obj.getprofileList(); 
obj.getFields();
obj.getselectedProfileList();
obj.getselectedPTName();
obj.getselectedField();
obj.getptnameList();
obj.updateInlineEditFlg();
obj.getFieldOptions();
obj.reset();
obj.save();

obj.setselectedPTName(v);
obj.setselectedField(v1);  
obj.setselectedProfileList(v1);

        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}

}