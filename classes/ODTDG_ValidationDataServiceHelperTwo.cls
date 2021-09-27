/******
 * Test Class : ODTDG_TrialValidationService_Test
 */
/********************************************************************************************************
*  @description ODTDG_ValidationDataServiceHelperTwo : this is the helper class to validate trial contacts duplicate
*************************************************************************************/

public with sharing class ODTDG_ValidationDataServiceHelperTwo {

private static boolean mapDuplicateCheck(String e,list<String> res){
        for(string s:res){
            if(s.Contains(e)){
                return true;
            }
        }
        return false;

    }

    private static ODTDG_CustomerData duplicateCheck(List<String> emails,ODTDG_CustomerValidateJson valDataM,ODTDG_CustomerData c){
        
        String customerSegment;
        List<String> productCategory=new List<String>();
        List<String> productCodes=new List<String>();
        list<string> res = new list<string>();

            if(valDataM.trialData.customerSegment!=null){
                customerSegment=valDataM.trialData.customerSegment;
            }
            if(valDataM.trialData.productOffering!=null){
                productCategory.add(valDataM.trialData.productOffering);
            }
            
            System.debug(LoggingLevel.INFO,'customerSegment... '+customerSegment);
      System.debug(LoggingLevel.INFO,'productCategory... '+productCategory);
            if(customerSegment!=null && !productCategory.isEmpty()){
                productCodes = ODTDG_Helper.getProductCode(productCategory,customerSegment);
            }
    System.debug(LoggingLevel.INFO,'productCodes... '+productCodes);
        res = OmniTrialDuplicateCheck.duplicateCheckCallLWC(productCodes,emails);
        System.debug(LoggingLevel.INFO,'OmniDupRes..... '+res);

        if(!res.isEmpty()){
            c.validationData.isCustomerDup = true;
        }
        else{
            c.validationData.isCustomerDup = false;
        }

        for(String e:emails){
            boolean result= mapDuplicateCheck(e,res);
            for(ODTDG_CustomerData_Helper.CustomerDetails ch: c.customerDetails){
                if(ch.emailAddress==e){
                    ch.isCustomerDup = result;
                }
            }
        }
        return c;
    }



 /********************************************************************************************************
*  @description isCustomerDup: Method to check Duplicate 
*  @param emails : this will accept the list of user email and based on that we will duplicate with respect to material number
*  @param c : this will accept the error code and the same will return  
*  @param valDataM : this will pass the customer input data
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 

    public static ODTDG_CustomerData isCustomerDup(List<string> emails,ODTDG_CustomerData c,ODTDG_CustomerValidateJson valDataM){
        
        c = duplicateCheck(emails,valDataM,c);
        
         if(c.validationData.isCustomerDup){
            string errNameBL = c.validationData.isExistingCustomer ? 'EC_DT' : 'NC_DT';
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errNameBL);
            c.error.add(er);
        }
       
        return c;
    } 


 /********************************************************************************************************
*  @description isSameDomain: Method to check added user is in same domain
*  @param primaryEmail : email of primary user
*  @param c : this will accept the error code and the same will return  
*  @param valDataM : this will pass the customer input data
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 

    public static ODTDG_CustomerData isSameDomain(String primaryEmail,ODTDG_CustomerData c,ODTDG_CustomerValidateJson valDataM){
        
        boolean isError=false;
        String primaryDomain=primaryEmail.substringAfter('@');
        for(ODTDG_CustomerData_Helper.CustomerDetails ch: c.customerDetails){
            if((!ch.isPrimary) && (ch.emailAddress.substringAfter('@')!=primaryDomain)){
                ch.isDifferentDomain=true;
                isError=true;
            }
        }
        
         if(isError){
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('NC_DC');
            c.error.add(er);
        }
       
        return c;
    } 
    
    
         /********************************************************************************************************
*  @description isAlreadyAdded: Method to check user already added to this trial
*  @param onePassId : onepassid of primary user
*  @param c : this will pass the customer input data
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 

    public static ODTDG_CustomerData isAlreadyAdded(String onePassId, ODTDG_CustomerData c){
        
        Trial_Contact__c cm = ODTDG_Helper.getTrialContact(onePassId);
        ID trialId = cm.Trials__c;
        boolean isError=false;
        List<String> emails=new List<String>();

        if(Schema.sObjectType.Trial_Contact__c.isQueryable()){
            List<Trial_Contact__c> contacts = [SELECT Id, Trials__c, Name, First_Name__c, Last_Name__c, Email__c, One_Pass_ID__c, Primary__c, lead__c, Status__c 
                                            FROM Trial_Contact__c 
                                            WHERE trials__c=:trialId];
              for(Trial_Contact__c con:contacts){
                  emails.add(con.Email__c);
              }
        }

        for(ODTDG_CustomerData_Helper.CustomerDetails ch: c.customerDetails){
            if((!ch.isPrimary) && (emails.Contains(ch.emailAddress))){
                ch.isAlreadyAdded=true;
                isError=true;
            }
        }

        
         if(isError){
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('IU_DU');
            c.error.add(er);
        }
       
        return c;
    }
    
    /********************************************************************************************************
*  @description validateProduct: Method to check if product offering is valid
*  @param valReq : this will pass the customer input data
*  @param cd : this will pass response
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 
    public static ODTDG_CustomerData validateProduct(ODTDG_CustomerValidateJson valReq, ODTDG_CustomerData cd){
        ODTDG_CustomerValidateJson.TrialValidation  valdata = valReq.trialData;
        
        List<String> prodOffering = new List<String>();

        prodOffering.add(valdata.productOffering);
        List<String> pCodeList = ODTDG_Helper.getProductCode(prodOffering, valdata.customerSegment);
        if(pCodeList.isEmpty()){
            string errName = 'OP_NF';
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage(errName);
            
            cd.error.add(er);
        }
        return cd;
    }
    
    private static ODTDG_CustomerData mapIsTrialActive(String email, String trialId, ODTDG_CustomerData c){
    for(ODTDG_CustomerData_Helper.CustomerDetails ch: c.customerDetails){
        if(ch.emailAddress==email){
            ch.isTrialActive= true;
            ch.trialId=trialId;
        }
    }
    
    return c;
}


/********************************************************************************************************
*  @description isTrialActive : Method to check if product offering is valid
*  @param emails : this will pass the customer input data
*  @param c : this will pass response
*  @param valDataM : this will pass response
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 
    public static ODTDG_CustomerData isTrialActive(List<string> emails,ODTDG_CustomerData c,ODTDG_CustomerValidateJson valDataM){
        
        String customerSegment;
        List<String> productCategory=new List<String>();
        List<String> productCodes=new List<String>();
        String odtdgActiveStatusS = ODTDG_Helper.getStaticValues('ODTDG_ActiveStatus');
        List<String> odtdgActiveStatus=new List<String>();
        
        switch on odtdgActiveStatusS{
           when null, ''{
               odtdgActiveStatus = new List<String>(); 
           }
           when else{
               odtdgActiveStatus = odtdgActiveStatusS.split(';');
           }
        }

        if(valDataM.trialData.customerSegment!=null){
            customerSegment=valDataM.trialData.customerSegment;
        }
        if(valDataM.trialData.productOffering!=null){
            productCategory.add(valDataM.trialData.productOffering);
        }
            
        if(customerSegment!=null && !productCategory.isEmpty()){
            productCodes = ODTDG_Helper.getProductCode(productCategory,customerSegment);
        }

        if(Schema.sObjectType.Trial_Product_Contact__c.isQueryable()){
            
            for(Trial_Product_Contact__c auser : [SELECT Id,Trial_Contact__r.Status__c,Trial_Contact__r.Email__c,trial_product__r.Material_Number__c,Trials__r.ID,Trials__r.Trial_End_Date__c 
                                            FROM Trial_Product_Contact__c 
                                            WHERE Trial_Contact__r.Email__c in :emails and trial_product__r.Material_Number__c in :productCodes  and Trial_Contact__r.Status__c in :odtdgActiveStatus order by createdDate asc])
            {
                c=mapIsTrialActive(auser.Trial_Contact__r.Email__c,auser.Trials__r.ID,c);
            }                           

        }

        return c;
    }

}