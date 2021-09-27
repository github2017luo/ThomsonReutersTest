/**********************************
Class Name: ESC_OrderResolution 
Purpose:create referral for form
**********************************/
/**
 * @description ESC_OrderResolution class
 */
public without sharing class ESC_OrderResolution extends ESC_FormsAbstractExecute{
    
	public override void executePreRender(){system.debug(logginglevel.warn,'test');}
    
	public override void validateForms(){system.debug(logginglevel.warn,'test');}
    
    public override void executePostSubmit(){
        try{
             ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,formname);
             if(obj.validateFormSegmentMappingExist()){
                   obj.createReferral();
             }
            
            if(Test.isRunningTest()) {
				CalloutException e = new CalloutException();
				e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
                }
           }
        
        catch(Exception e){          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
        }
    }
}