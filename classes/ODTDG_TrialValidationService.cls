/*
Author : Mir Umair
Date: March 2021
Description: Validation REST Service 
Returns: JSON object data class ODTDG_CustomerData
Sample Request: { "email": "test@test.com" }
@description ODTDGValidateTrialCustomer class to call validate the AEM trial user details 
*/
/********************************************************************************************************
*  @description ODTDG_TrialValidationService : to call validate the AEM trial user details
*********************************************************************************************************/
@RestResource(urlMapping='/ODTDGValidateTrialCustomer/*')
global with sharing class ODTDG_TrialValidationService {


/*
    private static ODTDG_CustomerData processTrialValidations(RestRequest req){

        if(checkValidEmail(req.params.get('emailId'))){
            return ODTDG_CustomerValidation.validateAll(req.params.get('emailId'));
        }else{
            ODTDG_CustomerData cd = new ODTDG_CustomerData(new ODTDG_CustomerData.ValidationData(),new List<ODTDG_CustomerData.Error>());
    
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('ER_InvalidEmail');
            cd.error.add(er);

            return cd;
        }
    }
*/

    private static ODTDG_CustomerData checkMultipleError(ODTDG_CustomerData cd){
        if(cd.error.size() > 1){
            List<ODTDG_CustomerData.Error> errList = new List<ODTDG_CustomerData.Error>();
            string errName = cd.validationData.isExistingCustomer ? 'EC_OTH' : 'NC_OTH';
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errName);
            errList.add(er);
            cd.error = errList;
        }
        return cd;
    }

    private static boolean checkValidEmail(string emailAdd){

        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: http://www.regular-expressions.info/email.html
        Pattern myPattern = Pattern.compile(emailRegex);
        Matcher myMatcher = myPattern.matcher(emailAdd);
         
        return (myMatcher.matches()) ? true : false;    


    }

    private static ODTDG_CustomerData postTrialValidations(string email,ODTDG_CustomerValidateJson valDataM){

        if(checkValidEmail(email)){
            return ODTDG_CustomerValidation.validateAll(email,valDataM);
        }else{
            ODTDG_CustomerData cd = new ODTDG_CustomerData(new ODTDG_CustomerData.ValidationData(),new List<ODTDG_CustomerData.Error>());
    
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('OP_ERR');
            cd.error.add(er);

            return cd;
        }
    }
/********************************************************************************************************
*  @description ValidatecustomersData: This is the main method to validate the customer data with post data 
* @return ODTDG_CustomerData as a service response we will share the customer data along with error messages if any 
*********************************************************************************************************/ 
    @HttpPost
    global static ODTDG_CustomerData validatecustomersData(){
            
            System.debug(LoggingLevel.INFO,'ReqBody...............'+RestContext.request.requestBody.tostring());
            
            ODTDG_CustomerValidateJson valDataM = ODTDG_CustomerValidateJson.parse(RestContext.request.requestBody.tostring()) ;

            System.debug(LoggingLevel.INFO,'valDataM...............'+valDataM);

            ODTDG_CustomerValidateJson.TrialValidation  valdata = valDataM.trialData;
         
       

        string primaryEmail;
        string onePassId;
        Set<string> emailsString = new set<string>();
        List<string> trialContactIdList = new List<string>();
        for(ODTDG_CustomerValidateJson.TrialContacts tc : valData.trialContacts){
        String useremail=(tc.customerEmail!=NULL)?tc.customerEmail.toLowerCase():NULL;
            if(tc.primaryUser){
                primaryEmail = useremail;
                onePassId=tc.userAuthId;
            }
            if(tc.forValidation){
                emailsString.add(useremail);
            }
            trialContactIdList.add(tc.trialContactSfId);
        }
        system.debug(LoggingLevel.INFO,'emailsString ........'+emailsString+'    '+valData.isPrimaryCheck);

        ODTDG_CustomerData cd = new ODTDG_CustomerData(new ODTDG_CustomerData.ValidationData(),new List<ODTDG_CustomerData.Error>());
        switch on valdata.trialSource{
            when 'Digital'{
                if(!valData.isPrimaryCheck){
            
                    List<String> emails = new List<String>(emailsString);
                    cd = ODTDG_ValidationDataServiceHelper.processINCBlacklist(emailsString, cd);
                    cd = ODTDG_ValidationDataServiceHelperTwo.IsCustomerDup(emails,cd,valDataM);
                        cd = ODTDG_ValidationDataServiceHelperTwo.isTrialActive(emails,cd,valDataM);
                    cd = ODTDG_ValidationDataServiceHelperTwo.IsSameDomain(primaryEmail,cd,valDataM);
                    cd = ODTDG_ValidationDataServiceHelperTwo.isAlreadyAdded(onePassId,cd);
                    system.debug(LoggingLevel.INFO,'process data ........'+cd);

                }else if(valData.isPrimaryCheck){
                
                    cd = postTrialValidations(primaryEmail,valDataM) ; 
                    cd = ODTDG_ValidationDataService.validatePrimaryUser(valDataM, cd);
                }
            }
            when 'SFDC'{
                cd = ODTDG_TandCValidation.validateEndDate(trialContactIdList,cd);
            }
        
        }
        
        cd=checkMultipleError(cd);
        
        return cd;

    }

}