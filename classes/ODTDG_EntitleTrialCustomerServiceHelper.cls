/********************************************************************************************************
*  @description ODTDG_EntitleTrialCustomerRecordsServiceHelper  : Helper class for recordservice 
*********************************************************************************************************/

public with sharing class ODTDG_EntitleTrialCustomerServiceHelper {
    public static boolean odtdgStopRec = true;
  /********************************************************************************************************
    *  @description getStateCode : This is to return state code 
    * @return string 
    * @param country  
    * @param state 
    *********************************************************************************************************/ 
    public static string getStateCode(string country, string state){
        if(state!=NULL && state!='' && country!=NULL && country!=''){
            if(Schema.sObjectType.Country_Region__c.isQueryable()){
                for(Country_Region__c cr : [Select Name,Region_Code__c, Region_Name__c,Country_Code__c from Country_Region__c where Country_Code__c = :country And Region_Name__c = :state And IsActive__c= true Limit 1]){
                    return cr.Region_Code__c;
                }
            }
        }
        return 'MN';
    }
    
    /********************************************************************************************************
    *  @description getContactFunctionValue : This is to return ContactFunctionValue from omni class based on segment
    * @return string 
    * @param segment   
    *********************************************************************************************************/ 
    public static string getContactFunctionValue(String segment){
        String conFnValue = '';
        conFnValue = OmniSubmitEntitlRequestJSONHelper.getContactFuntionValue(segment) ;
        return conFnValue;
    }
    
    /********************************************************************************************************
    *  @description getcustomerSegmentValue : This is to return customerSegmentValue based on segment
    * @return string 
    * @param segment   
    *********************************************************************************************************/ 
    public static string getcustomerSegmentValue(String segment){
        String custSegValue = '';
        custSegValue = ODTDG_Helper.getStaticValues(segment);
        return custSegValue;
    }
    
   /********************************************************************************************************
    *  @description getMarketingRecordID : This is to return state code 
    * @return integer 
    * @param custName  
    * @param value 
    *********************************************************************************************************/ 
    public static String getMarketingRecordID(String custName,String value){
            if(ODTDG_Helper.getStaticValues(custName)!=NULL){
                return ODTDG_Helper.getStaticValues(custName);
            }
            else{
                return value;
            }
    }
    
    /********************************************************************************************************
    *  @description getAccountName : This is to return account name for existing customer
    * @return string 
    * @param accNo 
    * @param emailBusiness  
    *********************************************************************************************************/ 
    public static Map<String,String> getAccountName(String accNo, String emailBusiness){
        
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        Map<String,String> accMap = new Map<String,String>();
        
        if(Schema.sObjectType.Source_System_Detail__c.isQueryable()){
            ssdList = [Select Id, Name, Account_Name__c, Account_Name__r.Name, Source_System_Account_Number__c FROM Source_System_Detail__c where Source_System_Account_Number__c =: accNo]; 
        }
        if(!ssdList.isEmpty()){
            accMap.put('AccountId', ssdList[0].Account_Name__c);
            accMap.put('AccountName', ssdList[0].Account_Name__r.Name);
        }
        else{
            try{
                string domain = emailBusiness.split('@').get(1);
                domain = domain.split('\\.').get(0);
                accMap.put('AccountName', domain);
                accMap.put('AccountId', null);
            }
            catch(Exception ex){
               System.debug(LoggingLevel.Info,'Exception>>>'+ ex.getMessage());
            }
        }
            
        return accMap;
    }
    
    
    /********************************************************************************************************
      *  @description sendOrderDetailsToPendo : This is sending details to Pendo 
      * 
      * @param ordList 
      * @param oldMap  
      *********************************************************************************************************/ 
      public static void sendOrderDetailsToPendo(List<Apttus_Config2__Order__c> ordList, Map<Id,Apttus_Config2__Order__c> oldMap){
        String ordSubmit = ODTDG_Helper.getStaticValues('Order Submitted');
        List<Apttus_Config2__Order__c> ordListNew = new List<Apttus_Config2__Order__c>(); 
        Map<Id,Apttus_Config2__Order__c> oldMapNew = new Map<Id,Apttus_Config2__Order__c>();

        
            for(Apttus_Config2__Order__c ord : ordList){
                 if(oldMap.containsKey(ord.Id)){
                    if(oldMap.get(ord.Id).APTS_SAP_Status__c != ordSubmit && ord.APTS_SAP_Status__c == ordSubmit){
                        
                        ordListNew.add(ord);
                        oldMapNew.put(ord.id, oldMap.get(ord.id));
                    }
                 }
                    
            }    
    

        if(!ordListNew.isEmpty() && odtdgStopRec){
            odtdgStopRec = FALSE;
            System.enqueueJob(new ODTDG_OrderStatusUpdate(ordListNew, oldMapNew));  
        }

      }
    
      /********************************************************************************************************
      *  @description getIndustryCode : This is sending details to Pendo 
      * @param customerSegmentValue 
      * @return String
      *********************************************************************************************************/ 
      public static String getIndustryCode(String customerSegmentValue){
        String code=null;
        if(customerSegmentValue!=null && customerSegmentValue!=''){
            String segmentValue=customerSegmentValue.toLowercase();
            segmentValue='ODTDG_'+segmentValue;
            code = ODTDG_Helper.getStaticValues(segmentValue);
        }
        return code;

      }

}