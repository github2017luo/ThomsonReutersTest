public with sharing class ListButtonController {

     /*public ListButtonController(ApexPages.StandardSetController controller) {

        controller.setPageSize(10);

    } */
    
     public Lead lead {get;set;}
     public boolean flag {get;set;}
     public boolean shouldRender {get;set;}
      
    private ApexPages.StandardSetController standardController;

    public ListButtonController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        lead = (Lead) standardController.getRecord(); 
        flag = true;
        shouldRender = true;
    }

 /*public ListButtonController ()
    {
        lead = new Lead();
        flag = true;
      
    }*/
   public void hideSectionOnChange()
    {
      
        if(lead.Status == 'Discarded'){
            flag = false;
            shouldRender = true;
         }
       else if(lead.Status == 'Unworked'){
            shouldRender = false;
            flag = true;
       }
       else {
           flag = true;
            shouldRender = true;
       }
    }


    public PageReference updateLeads()
    {       
        // Call StandardSetController 'save' method to update (optional, you can use your own DML)
        return standardController.save();   
    }
    
    
}