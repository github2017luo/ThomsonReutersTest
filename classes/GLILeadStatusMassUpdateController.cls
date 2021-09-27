/**
*   {Purpose} - Controller class for GLILeadStatusMassUpdate Visualforce Page.
*               
*               Test code coverage provided by the following class:
*               - GLILeadStatusMassUpdateControllerTest 
*
*   CHANGE HISTORY
*   =============================================================================
*   Date        Name                Description
*   20180918    Jason Flippen       Created
*   =============================================================================
**/

/**
     * @description  GLILeadStatusMassUpdateController
     */
public without sharing class GLILeadStatusMassUpdateController {

    private ApexPages.StandardSetController controller;
    /**
     * @comment electedLeadList
     * @description selectedLeadList
     */
    public List<Lead> selectedLeadList {get;set;}
    /**
     * @comment leadUpdate
     * @description leadUpdate
     */
    public Lead leadUpdate {get;private set;}
    
    

    /**
    *   {Purpose} - Constructor for class.
    *
    *   CHANGE HISTORY
    *   =============================================================================
    *   Date        Name                Description
    *   20180918    Jason Flippen       Created
    *   =============================================================================
    **/

    /**
     * @description  GLILeadStatusMassUpdateController
     * @param  standardSetController
     */
    public GLILeadStatusMassUpdateController(ApexPages.StandardSetController standardSetController) {
        
        // Initialize Variables.
        this.selectedLeadList = new List<Lead>();
        this.leadUpdate = new Lead();
        this.controller = standardSetController;
        
        // Retrieve the expected fields for the selected Lead records.
        List<Lead> tempLeadList = (List<Lead>)standardSetController.getSelected();
        if (!tempLeadList.isEmpty()) {
            Set<Id> leadIdSet = new Set<Id>();
            for (Lead l : tempLeadList) {
                leadIdSet.add(l.Id);
            }
            
            if (!leadIdSet.isEmpty() && Schema.sObjectType.Lead.isQueryable()) {
                this.selectedLeadList = [SELECT Id,
                                                Disqualification_Justification__c,
                                                Status,
                                                TRWayLeadMgmt__Panorama_DQ_Reason__c,
                                                TRWayLeadMgmt__Panorama_Competitor__c
                                         FROM   Lead
                                         WHERE  Id IN :leadIdSet];
            }
        }
        
    } // End Method: Constructor()
    
    /**
    *   {Purpose} - Method to update the selected Lead records with the values
    *               selected on the page.
    *
    *   CHANGE HISTORY
    *   =============================================================================
    *   Date        Name                Description
    *   20180918    Jason Flippen       Created
    *   =============================================================================
    **/
    /**
     * @description  save
     * @return pageref
     */
    public PageReference save() {
        
        PageReference pageRef = controller.cancel();
        
        List<Lead> updateLeadList = updateLeadList(selectedLeadList,leadUpdate);
        //created new method for PMD
        
        // If we have records to update, update them.        
        if (!updateLeadList.isEmpty() && Schema.sObjectType.Lead.isUpdateable()) {
            try {
                update updateLeadList;
            }
            catch(Exception ex) {
                // Log the error
                String errorPoint = 'GLILeadStatusMassUpdateController.Save()';
                String errorMessage = ex.getMessage();
                TR_Retention__Error_Log__c newErrorLog = new TR_Retention__Error_Log__c(TR_Retention__Error_Point__c = errorPoint, TR_Retention__Error_Message__c = errorMessage);
                
                if(Schema.sObjectType.TR_Retention__Error_Log__c.isCreateable()){  
                insert newErrorLog; }
                
                // Display a clean error message to the User.                
                pageRef = null;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.GLILeadStatusMassUpdate_Page_Save_Error_Msg));
            }
        }
        
        return pageRef;
        
    } // End Method: save()
    
    /**
    *   {Purpose} - Method to cancel out of the page and return to the previous page.
    *
    *   CHANGE HISTORY
    *   =============================================================================
    *   Date        Name                Description
    *   20180918    Jason Flippen       Created
    *   =============================================================================
    **/
    /**
     * @description  cancel
     * @return pageref
     */
    public PageReference cancel() {
        PageReference pageRef = controller.cancel();
        return pageRef;
    } // End Method: cancel()
    

    /**
     * @description  updateLeadList
     * @param selectedLeadList
     * @param leadUpdate
     * @return updateLeadList
     */
    public static List<Lead> updateLeadList(List<Lead> selectedLeadList, Lead leadUpdate){
        List<Lead> updateLeadList = new List<Lead>();
        for (Lead l : selectedLeadList) {
            
            Boolean addToList = false;
            
            // Make sure we're only updating Leads whose values have actually changed.
            if (l.Status != leadUpdate.Status) {
                l.Status = leadUpdate.Status;
                addToList = true;
            }
            if (l.TRWayLeadMgmt__Panorama_DQ_Reason__c != leadUpdate.TRWayLeadMgmt__Panorama_DQ_Reason__c) {
                l.TRWayLeadMgmt__Panorama_DQ_Reason__c = leadUpdate.TRWayLeadMgmt__Panorama_DQ_Reason__c;
                addToList = true;
            }
            if (l.Disqualification_Justification__c != leadUpdate.Disqualification_Justification__c) {
                l.Disqualification_Justification__c = leadUpdate.Disqualification_Justification__c;
                addToList = true;
            }
            if (l.TRWayLeadMgmt__Panorama_Competitor__c != leadUpdate.TRWayLeadMgmt__Panorama_Competitor__c) {
                l.TRWayLeadMgmt__Panorama_Competitor__c = leadUpdate.TRWayLeadMgmt__Panorama_Competitor__c;
                addToList = true;
            }
            
            if (addToList == true) {
                updateLeadList.add(l);
            }
            
        }
        return updateLeadList;
    }
    
}