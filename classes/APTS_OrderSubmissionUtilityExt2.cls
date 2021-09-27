/**
 * @description Helper class for APTS_OrderQueueToESI    
 */
public with sharing class APTS_OrderSubmissionUtilityExt2{
    /**
    * @description onlineContactAssign
    * @return onlineContactAssign
    * @param multiAcccon
    * @param multiAcc
    * @param materialBrandCodeMap
    */
    public static CreateOrderRequest.UserDetails onlineContactAssign(Online_Contacts__c multiAcccon, APTS_Quote_Agreement_Locations__c multiAcc, Map<string, string> materialBrandCodeMap) {
        CreateOrderRequest.UserDetails userDetails= new CreateOrderRequest.UserDetails();
        System.debug(LoggingLevel.WARN,'#### multiAcccon'+multiAcccon+'##### multiAcc'+multiAcc+'########materialBrandCodeMap'+materialBrandCodeMap);
        if(checkSSDCond(multiAcccon,multiAcc)){
            userDetails.locationAcc=multiAcccon.APTS_Source_System_Detail__r.Source_System_Account_Number__c;
            if(checkMultiAccCond(multiAcccon,materialBrandCodeMap)){
                userDetails.contactType='0230';
            }  
            else if(multiAcccon.Position__c == 'Non-Attorney'){  
                userDetails.contactType='0090';
                }
            else {
                switch on multiAcccon.Position__c{
                    when 'Attorney' {
                        userDetails.contactType='0100';
                    }
                    when 'Clerk' {
                        userDetails.contactType='0050';
                    }
                    when 'Judge' {
                        userDetails.contactType='0080';
                    }
                    when 'Librarian' {
                        userDetails.contactType='0060';
                    }
                    when 'Paralegal' {
                        userDetails.contactType='0030';
                    }
                    when 'Administrator' {
                        userDetails.contactType='0290';
                    }
                    when 'Analyst' {
                        userDetails.contactType='0310';
                    }
                    when 'Supervisor' {
                        userDetails.contactType='0280';
                    }
                    when 'Clear Administrator' {
                        userDetails.contactType='0290';
                    }
                    when 'Clear Analyst' {
                        userDetails.contactType='0310';
                    }
                    when 'Clear Investigator' {
                        userDetails.contactType='0300';
                    }
                    when 'Clear Supervisor' {
                        userDetails.contactType='0280';
                    }
                    when 'Clear Technical' {
                        userDetails.contactType='0270';
                    }
                    when 'Summer Associates' {
                        userDetails.contactType='0270';
                    } 
                }
            }
            userDetails.contactNum=multiAcccon.ContactID__c;
            userDetails.firstName=multiAcccon.First_Name__c;
            userDetails.lastName=multiAcccon.Last_Name__c;                        
            userDetails.email=multiAcccon.Email__c;
        }
        System.debug(LoggingLevel.WARN,'############### userDetails'+userDetails);
            return userDetails;
    }

        /**
         * @description checkSSDCond
         * @return checkSSDCond
         * @param multiAcccon
         * @param multiAcc
         */
        public static boolean checkSSDCond(Online_Contacts__c multiAcccon, APTS_Quote_Agreement_Locations__c multiAcc){
            Boolean isBlnSsd =False;
            if(multiAcccon.APTS_Source_System_Detail__c==multiAcc.APTS_Subscriber_Location_SSD__c){
                isBlnSsd =true;
            }
            return isBlnSsd;
        }

        /**
         * @description checkMultiAccCond
         * @return checkMultiAccCond
         * @param multiAcccon
         * @param materialBrandCodeMap
         */
        public static Boolean checkMultiAccCond(Online_Contacts__c multiAcccon, Map<string, string> materialBrandCodeMap) {
            Boolean isblnCheck =False;
            if(multiAcccon.Type__c=='Admin' && !materialBrandCodeMap.isEmpty() && materialBrandCodeMap.containsKey(multiAcccon.Material__c) && materialBrandCodeMap.get(multiAcccon.Material__c) == '064') {
                isblnCheck = true;
            }
        return isblnCheck;
        }

         /**
           * @description assignOrderLineitemCategory
           * @param strMap
           * @param ordline
         */
        public static void assignOrderLineitemCategory(Map<string,string> strMap, CreateOrderRequest.orderLines ordline) {
            String icGroup = strMap.get('icGroup');
            String billFrequency = strMap.get('billFrequency');
            //string programId = strMap.get('programId');
            //if(programId != 'WCMP') { -  SOC-5965
                if(icGroup =='ZPMT') {
                    if(billFrequency =='Yearly'){
                    ordline.itemCategory='ZGR5';}
                    else if(billFrequency =='Monthly'){ 
                    ordline.itemCategory='ZGRP';}
                }
                else if(icGroup =='ZPAL') {
                if(billFrequency =='Yearly'){
                ordline.itemCategory='ZGR3';}
                    else if(billFrequency =='Monthly') {
                    ordline.itemCategory='ZGR2';}
                } 
            //} - SOC-5965
        }

        /**
         * @description validateMLLCode
         * @param llCode
         * @param codes
         * @return Boolean
         */
        public static Boolean validateMLLCode(string llCode, string codes){
            Boolean isValid = False;
            if(!string.isEmpty(llCode) && !string.isEmpty(codes)){
                for(string str :codes.split(',')){
                    if(str == llCode){
                        isValid = True;
                        break;
                    }
                }
            }
            System.debug(LoggingLevel.WARN,'isValid...'+isValid);
            return isValid;
        }

}