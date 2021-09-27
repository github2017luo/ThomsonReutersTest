/******
* Class : ODTDG_TandCValidation
 */
/********************************************************************************************************
*  @description ODTDG_TandCValidation : this is the helper class to validate trial contacts duplicate
*************************************************************************************/

public with sharing class ODTDG_TandCValidation {

private static ODTDG_CustomerData_Helper.CustomerDetails checkTrialActive(ODTDG_CustomerData_Helper.CustomerDetails singleCus,String status,String trialId){
    String odtdgActiveStatusS = ODTDG_Helper.getStaticValues('ODTDG_ActiveStatus');
    singleCus.isTrialActive=false;
    if(odtdgActiveStatusS.contains(status)){
        singleCus.isTrialActive=true;
        singleCus.trialId=trialId;
    }
    return singleCus;
}

private static ODTDG_CustomerData entitleError(ODTDG_CustomerData cd,String profile){
    
    String errName;
    if(profile==ODTDG_Helper.getStaticValues('ODTDG_NEW_CUSTOMER')){
        errName = 'NC_EXP';
    }
    else{
        errName = 'EC_EXP';
    }
    ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
    er = ODTDG_ErrorCodeDataService.parseErrorMessage(errName);
    cd.error.add(er);
    
    return cd;
}

/********************************************************************************************************
*  @description validateEndDate: Method to check if product offering and other request fields are valid
*  @param trialConIds : this will pass the customer input data
*  @param cd : this will pass the customer input data
*  @return ODTDG_EntitlementWrapper : error response for service
*********************************************************************************************************/ 
    public static ODTDG_CustomerData validateEndDate(LIST<id> trialConIds,ODTDG_CustomerData cd){
      
        List<ODTDG_CustomerData_Helper.CustomerDetails> cusdata = new List<ODTDG_CustomerData_Helper.CustomerDetails>();

 
        date trialEndDate=date.today();
        List<string> conStatus=new List<String>();
        string profileType;
        string tandCAccStatus = ODTDG_Helper.getStaticValues('ODTDG_TandCAccStatus'); 
        
        if(Schema.sObjectType.Trial_Contact__c.isQueryable()){
            for(Trial_Contact__c tcon : [SELECT Id,Trials__c, Trials__r.Trial_End_Date__c, Trials__r.Trial_Status__c, status__c,Profile_Type__c FROM Trial_Contact__c WHERE ID IN: trialConIds]){
                ODTDG_CustomerData_Helper.CustomerDetails singleCus = new ODTDG_CustomerData_Helper.CustomerDetails();

                trialEndDate= tcon.Trials__r.Trial_End_Date__c;
                conStatus.add(tcon.status__c);
                profileType = tcon.Profile_Type__c;

                singleCus.trialContactSfId = tcon.id;
                singleCus=checkTrialActive(singleCus,tcon.status__c,tcon.Trials__c);
                cusdata.add(singleCus);

            }
          
        }
        if((date.today() > trialEndDate && trialEndDate!=null) ){
            cd=entitleError(cd,profileType);
        }
        for(string s:conStatus){
        if(!tandCAccStatus.contains(s)){
            string errName = ODTDG_Helper.getStaticValues('ODTDG_TandCEntInvalidStatus');
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errName);
            cd.error.add(er);
            break;
        }
        }
        cd.customerDetails=cusdata;
        return cd;
        
    }

    
}