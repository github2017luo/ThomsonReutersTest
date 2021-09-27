/* Class: TRStore_ErrorHandlerTest
* Purpose: Coverage for  Class TRStore_ErrorHandler 
* Created: 11/03/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-11-03   Avudaiappan A     DUE-6169   Test Coverage Started
* =============================================================================
*/
@isTest(seeAllData = False)
public class TRStore_ErrorHandlerTest {

    public static testMethod void testData(){
       Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>'Exception','webServiceName'=>'CreateProposalAPI','requestType'=>'Getting records from UEProposal','reqMsg'=>'Exception Class Name: TRStoreCreateProposalAPI','module'=>'UEStore','recId'=>'','supportEmail'=>'abc@sample.com','toSupport'=>'true'};
       System.assert(errorHandlerMap!=null,'Error handler map populated');
       TRStore_ErrorHandler.logException(errorHandlerMap);
  }

}