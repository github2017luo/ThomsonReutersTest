/********************************************************************** 
Name: LTSStoreErrors
====================================================== 

====================================================== 
Purpose: To store exception in LCRM_Exception_Log__c object
====================================================== 
History 
------- 
VERSION    AUTHOR                           DATE           DETAIL 
1.0        TCS Developer                01/03/2019       Initial Development  
***********************************************************************/

public without sharing class LTSStoreErrors {
    
    public static void customLTSException(List<LCRM_Exception_Log__c> exceptionList){
        
        //if(!exceptionList.isEmpty() && Schema.sObjectType.LCRM_Exception_Log__c.isCreateable()){
          if(!exceptionList.isEmpty()){
            try{
                 insert exceptionList;
            }Catch(Exception e){
                System.debug('MESAGGE @@ '+e.getMessage());
            }
           
        }
    }

}