@IsTest

public class ESC_ObjectSchemaHelper_Test{
     @IsTest(SeeAllData=false) public static void ESC_ObjectSchemaHelper_Method(){ 
      
      Test.StartTest();
      
      //Providing list of dummy data for account
      
        set<string> sobj1=new set<string>();
        sobj1.add('case');

    ESC_ObjectSchemaHelper.getPickListOptions('Case' , 'Status' );

    ESC_ObjectSchemaHelper.getObjectNamesUsed('Case');
    ESC_ObjectSchemaHelper.getInfoField(sobj1);
   }
}