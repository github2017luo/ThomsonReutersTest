/********************************************************************************************************
*  @description ODTDG_ExistingUserCheck  : class to write the existing user check  
*********************************************************************************************************/
public with sharing class ODTDG_ExistingUserCheck {
      
    /********************************************************************************************************
    * @description checkExistingUsercheck : Check the existing user details from SAP/OLC
    * @return checkExistingUsercheck  return  user details
    * @param email , expecting email
    * @param cdata expecting customer details to send 
    *********************************************************************************************************/ 
    public static ODTDG_CustomerData checkExistingUsercheck(string email, ODTDG_CustomerData cdata){

      TrialOLCOnePassByEmailRespWrap  existingCustDetails = OmniOnePassOLCCallout.getOLCOnePassWrapper(email);

      System.debug(LoggingLevel.INFO,'existingCustDetails...............'+existingCustDetails);

        if(existingCustDetails.externalContactNumber != null){
            cdata.validationData.isExistingCustomer = True;
            for(ODTDG_CustomerData_Helper.CustomerDetails c : cdata.customerDetails){
                if(c.emailAddress == email){
                     c = processdetails(existingCustDetails, c);
                     
                }
            }
            cdata.accountDetail.accountNumber = existingCustDetails.externalAccountNumber ;
            cdata.accountDetail.accountNumberSource = existingCustDetails.externalAccountNumberSource ;
            

        }


        return cdata;
    }

    private static ODTDG_CustomerData_Helper.CustomerDetails processdetails(TrialOLCOnePassByEmailRespWrap  existingCustDetails, ODTDG_CustomerData_Helper.CustomerDetails cd){

            cd.contactNumber = existingCustDetails.externalContactNumber;
            cd.contactNumberSource = existingCustDetails.externalContactNumberSource;
            cd.userAuthId = existingCustDetails.onePassId;
            cd.cobaltGUID = existingCustDetails.cobaltGUID ;
            cd.dataroamGUID = existingCustDetails.dataRoomGUID ;
            if(ODTDG_Helper.getStaticValues(existingCustDetails.profileType)!=null){
                cd.profileType = existingCustDetails.profileType;
            }
            else if(ODTDG_Helper.getStaticValues('NEW_CUSTOMER')!=null){
                cd.profileType = ODTDG_Helper.getStaticValues('NEW_CUSTOMER');
            }
            

        return cd;
    }
/*
        private static ODTDG_CustomerData_Helper.CustomerDetails processEmailUser(string email, ODTDG_CustomerData cdata){

                for(ODTDG_CustomerData_Helper.CustomerDetails c : cdata.customerDetails){
                    if(c.emailAddress == email){
                        return c;
                    }
                }
            return null;        

        }
*/

}