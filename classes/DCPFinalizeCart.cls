/********************************************************************************
Class Name : DCPFinalizeCart
@description : This class is used to finalize cart.
***************************************************************************************

Modification Details
    Date             Description                                            Owner
04/05/2021           Class Created                                          By Herin Acharya

*********************************************************************************/


public without sharing class DCPFinalizeCart{
    
    /**
    @description call the conga cart finalize method
    @param requestBody will contain "cartId" as a parameter.
    @return Returns string in case of success OR thows execption in case of failure
    */
    
    public static string callCongaFinalizeMethod(Map<String,String> requestBody){
       
       //String returnString;
       if(requestBody.containskey('cartId') && !String.isBlank(requestBody.get('cartId'))){
            try{
                String cartId = requestBody.get('cartId');
                Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
                request.CartId = cartId;
                Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
                System.debug(LoggingLevel.DEBUG, '*** DEBUGGING FROM DEV *** >> RESPONSE  :  '+ response);
                return 'Cart finalized successfully';
                //return returnString; 
            }
            catch(Exception ex){
                //string exceptionString = ex.getStackTraceString();
                throw new DCCustomException(ex.getStackTraceString()); 
            }    
       }else{
            //string improperRequest = 'Improper request format';
            throw new DCCustomException('Improper request format');       
       }                
    }
      
}