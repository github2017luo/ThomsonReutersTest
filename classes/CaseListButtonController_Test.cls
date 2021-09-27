@isTest
private class CaseListButtonController_Test{
  public static testMethod void massUpdateCaseCommentsTest(){
  
     List<Case> listCase = new List<Case>();
  
     Test.startTest();
       
     Case Case1=new Case(Subject='Test Case1',CaseType__c='Award Timing', Case_Type_Detail__c='Bar Adjustments',Additional_Case_Type_Detail__c='BAR',Status='Open');
     listCase.add(Case1);
     Case Case2=new Case(Subject='Test Case2',CaseType__c='Award Timing', Case_Type_Detail__c='Bar Adjustments',Additional_Case_Type_Detail__c='BAR',Status='Open');
     listCase.add(Case2);
     Case Case3=new Case(Subject='Test Case3',CaseType__c='Award Timing', Case_Type_Detail__c='Bar Adjustments',Additional_Case_Type_Detail__c='BAR',Status='Open');
     listCase.add(Case3);    
     insert listCase;
     
         
       Case oCase1=[Select id from Case where Subject='Test Case1'];
     
       ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listCase);
       stdSetController.setSelected(listCase);
       ApexPages.currentPage().getParameters().put('recs',oCase1.id);
       
       CaseListButtonController ext = new CaseListButtonController(stdSetController);
        
       for(Case oCase:listCase){ 
       ext.caseIdList.add(oCase.Id);
       }
       
       ext.caseComment='Test case comment';
       ext.caseCommentPublic=false;
       ext.updateCases();
       ext.Cancel();
     
     Test.stopTest();
  }
  
 }