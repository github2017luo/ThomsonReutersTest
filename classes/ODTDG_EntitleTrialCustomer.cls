/********************************************************************************************************
 *  @description ODTDG_EntitleTrialCustomer : service class to process react entitlement process  
*********************************************************************************************************/

@RestResource(urlMapping='/ODTDGTrialInitiationService/*')
global with sharing class ODTDG_EntitleTrialCustomer {    
    
    
        public static boolean tocoverCatchBlock = false;
    
    // Post Method ODTDG_TrialRecord ODTDG_TrialRecord.OdtdgTrialDetails
    /********************************************************************************************************
     *  @description createNewTrial : Main post methos to hold incoming request 
     * @return ODTDG_EntitlementWrapper : result of request 
    *********************************************************************************************************/

    @HTTPPost
    global static ODTDG_EntitlementWrapper  createNewTrial() {
        
     /*   ODTDG_TrialRecord container = (ODTDG_TrialRecord)System.JSON.deserialize(
            RestContext.request.requestBody.tostring(), 
            ODTDG_TrialRecord.class);
        */
        ODTDG_EntitlementWrapper trialrec = new ODTDG_EntitlementWrapper();


        try{ 
            System.debug(LoggingLevel.INFO,'ReqBody...............'+RestContext.request.requestBody.tostring());
            ODTDG_TrialRecord container = ODTDG_TrialRecord.parse(RestContext.request.requestBody.tostring());
            System.debug(LoggingLevel.INFO,'valDataM...............'+container);

            //processTrialEntitlements trialrec = ODTDG_EntitleTrialCustomerService.createTrialRecord(container);
            trialrec = ODTDG_EntitleTrialCustomerService.processTrialEntitlements(container);

            if(tocoverCatchBlock){// Tocoverage the catch block 
                    String s;
                s.toLowerCase();
            }

        }catch(exception e){
            System.debug(LoggingLevel.INFO,'Trial Record Create error ...............'+e);
            string errNameBL = 'OP_ERR';
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
            er.message = string.valueOf(e);

            trialrec.errors.add(er);

            trialrec = ODTDG_EntitleTrialCustomerRecordsService.getFailureMsg(trialrec);
        } 
            
               
       // return  JSON.serialize(trialrec,true) ; 
       return trialrec;    
    }
}