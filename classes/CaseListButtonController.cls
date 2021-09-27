/********************************************************************************
@Auther : Asha Aramani
Created Date: 09/02/2016
Purpose :This Controller handles Adding Mass Case Comments from Case List View.
Associated for VF page : AddingMassCaseComments 
    
CHANGE HISTORY
=============================================================================
 Date         Name                    Description
                                                                                                              
=============================================================================    

**********************************************************************************/


public with sharing class CaseListButtonController {

    public String caseComment{get;set;}
    public Boolean caseCommentPublic{get;set;}
    
    @TestVisible private List<Id> caseIdList = new List<Id>();
    
    @TestVisible private ApexPages.StandardSetController standardController;
            
    public CaseListButtonController(ApexPages.StandardSetController controller) {
        this.standardController = controller;
        caseIdList = (List<Id>)ApexPages.currentPage().getParameters().get('recs').split(',',-2);
    } 
    
    public static PageReference listView(Schema.sObjectType destinationSObject) {
       Schema.DescribeSObjectResult destination = destinationSObject.getDescribe();
       PageReference pageRef = new PageReference('/' + destination.getKeyPrefix() );
       pageRef.setRedirect(true);
       return pageRef;
    }
    
    public PageReference Cancel(){
    
     return listView(Case.sObjectType);
    
    }
    
    public PageReference updateCases() {
                        
        List<CaseComment> childCComment = new List<CaseComment>();
        for (Id caseId :caseIdList){ 
             CaseComment newCComment= new CaseComment();
             newCComment.CommentBody = caseComment;
             newCComment.IsPublished = caseCommentPublic;
             newCComment.ParentId = caseId;
             childCComment.add(newCComment);   

        }
        
        if(!childCComment.isEmpty()){
        insert childCComment;
        }
        
      return listView(Case.sObjectType); 
  
    }

}