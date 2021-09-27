/******
 * Test Class : ODTDG_TrialValidationService_Test
 */
/********************************************************************************************************
*  @description ODTDG_ValidationDataServiceHelper : this is the helper class to validate INC trial contacts blacklisted and other validations 
*************************************************************************************/
public with sharing class ODTDG_ValidationDataServiceHelper {
     
/********************************************************************************************************
*  @description processINCBlacklist: Method to check blacklisted INCs or domain details....
*  @param incEmails : this will accept the user email and based on that we will check blacklisted or domain data 
*  @param c : this will accept the error code and the same will return  
*  @return ODTDG_CustomerData
*********************************************************************************************************/ 
   
    public static ODTDG_CustomerData processINCBlacklist(set<string> incEmails, ODTDG_CustomerData c){
            
        MAP<string, string> incEmailMap = new MAP<string, string>();

        for(string s: incEmails){
            incEmailMap.put(s, s.substringAfter('@'));
        }

        system.debug(LoggingLevel.INFO,'incEmailMap ........'+incEmailMap);
        LIST<Digital_Blacklist_or_CompetitorList__c> dbc = new LIST<Digital_Blacklist_or_CompetitorList__c>();
        dbc = queryBlacklist(incEmailMap);
        system.debug(LoggingLevel.INFO,'competitors ........'+dbc.size());
        system.debug(LoggingLevel.INFO,'dbc.isEmpty()  ........'+dbc.isEmpty() );
        system.debug(LoggingLevel.INFO,'c.customerDetails.isEmpty()  ........'+c.customerDetails.isEmpty() );

        c.customerDetails = filterWithCustData(dbc, c, incEmails);
        
        if(!dbc.isEmpty()){
            ODTDG_CustomerData.Error er = new ODTDG_CustomerData.Error();
            er = ODTDG_ErrorCodeDataService.parseErrorMessage('NC_BL');
            c.error.add(er);
            c.validationData.isBlacklisted = TRUE;
        }

        return c;

    }

    private static LIST<ODTDG_CustomerData_Helper.CustomerDetails> filterWithCustData(LIST<Digital_Blacklist_or_CompetitorList__c> dbc,  ODTDG_CustomerData c , set<string> incEmails){
        
        if(dbc.isEmpty() && c.customerDetails.isEmpty()){
            c.customerDetails = prepareNewCustomerData(incEmails);
        }else if(dbc.isEmpty() && !c.customerDetails.isEmpty()){
            c.customerDetails = prepareExistingCustomerData(c.customerDetails);
        }else if(!dbc.isEmpty() && !c.customerDetails.isEmpty()){
            c.customerDetails = mapToExistingCustomerData(incEmails, c.customerDetails, dbc);
        }else if(!dbc.isEmpty() && c.customerDetails.isEmpty()){
            c.customerDetails = mapToBlockedCustomersOnnewList(incEmails, dbc);
        }

        return c.customerDetails;

    }


    private static LIST<Digital_Blacklist_or_CompetitorList__c> queryBlacklist(MAP<string, string> incEmailMap){
        
        LIST<string> blackStr =new LIST<string>();
        blackStr.add('Blocked');
        
        if(Static_Values__c.getAll().containsKey('ODTDGBlacklisted')){ 
            blackStr = Static_Values__c.getValues('ODTDGBlacklisted').value__c.split(';');
        }  
        system.debug(LoggingLevel.INFO,'Key values.... ........'+incEmailMap.keySet()+'      '+incEmailMap.values());

        LIST<Digital_Blacklist_or_CompetitorList__c> dbc = new LIST<Digital_Blacklist_or_CompetitorList__c>();
        if(Schema.sObjectType.Digital_Blacklist_or_CompetitorList__c.isQueryable()){
            dbc = [SELECT id, Name, Email__c , Email_Domains__c, Status__c, Type__c from Digital_Blacklist_or_CompetitorList__c WHERE ( Email__c IN: incEmailMap.keySet() OR  Email_Domains__c IN: incEmailMap.values() ) limit 49000];
            system.debug(LoggingLevel.INFO,'email list... ........'+dbc.size());

            
        }

        return dbc;
    }

    @TestVisible private static LIST<ODTDG_CustomerData_Helper.CustomerDetails> prepareNewCustomerData(set<string> emails){
       
        List<ODTDG_CustomerData_Helper.CustomerDetails> blackCusdata = new List<ODTDG_CustomerData_Helper.CustomerDetails>();

        for(string s: emails){
            ODTDG_CustomerData_Helper.CustomerDetails singleCus = new ODTDG_CustomerData_Helper.CustomerDetails();

            singleCus.emailAddress = s;
            singleCus.isBlacklisted = false;
            
            blackCusdata.add(singleCus);
        }

        return blackCusdata;
    }

    @TestVisible 
    private static LIST<ODTDG_CustomerData_Helper.CustomerDetails> prepareexistingCustomerData(list<ODTDG_CustomerData_Helper.CustomerDetails> custList){
        for(ODTDG_CustomerData_Helper.CustomerDetails s: custList){
            s.isBlacklisted = false;
        }

        return custList;
    }
    @TestVisible 
    private static LIST<ODTDG_CustomerData_Helper.CustomerDetails> mapToBlockedCustomersOnnewList(set<string> emails, LIST<Digital_Blacklist_or_CompetitorList__c> dbc){
        
        MAP<string, string> blacklistMap = new MAP<string, string>(); 
        for(Digital_Blacklist_or_CompetitorList__c dc: dbc){
            blacklistMap.put(dc.Email__c, dc.Email_Domains__c);
        }

        list<ODTDG_CustomerData_Helper.CustomerDetails> custNewList = new list<ODTDG_CustomerData_Helper.CustomerDetails>();
        for (string s: emails){
            ODTDG_CustomerData_Helper.CustomerDetails cnl = new ODTDG_CustomerData_Helper.CustomerDetails();
            if((blacklistMap.containsKey(s) || blacklistMap.values().contains(s.substringAfter('@'))) ){
                cnl.isBlacklisted = TRUE;
                cnl.emailAddress = s;

                custNewList.add(cnl);
            }else{
                cnl.isBlacklisted = FALSE;
                cnl.emailAddress = s;

                custNewList.add(cnl);
            }
        }

         

        return  custNewList;

    }

    @TestVisible 
    private static LIST<ODTDG_CustomerData_Helper.CustomerDetails> mapToExistingCustomerData(set<string> emails, list<ODTDG_CustomerData_Helper.CustomerDetails> custList,LIST<Digital_Blacklist_or_CompetitorList__c> dbc ){

        MAP<string, string> blacklistMap = new MAP<string, string>(); 
        set<string> toremoveVals = new Set<string>();
        toremoveVals.addAll(emails);

        for(Digital_Blacklist_or_CompetitorList__c dc: dbc){
            blacklistMap.put(dc.Email__c, dc.Email_Domains__c);
        }

        for (string s: emails){
            for(ODTDG_CustomerData_Helper.CustomerDetails ch: custList){
                if((blacklistMap.containsKey(s) || blacklistMap.values().contains(s.substringAfter('@'))) && s.equalsIgnoreCase(ch.emailAddress)){
                    ch.isBlacklisted = TRUE;
                    toremoveVals.remove(s);
                }
            }
        }

        if(!toremoveVals.isEmpty()){
            for(string s: toremoveVals){
                ODTDG_CustomerData_Helper.CustomerDetails singleCus = new ODTDG_CustomerData_Helper.CustomerDetails();

                singleCus.emailAddress = s;
                singleCus.isBlacklisted = false;

                custList.add(singleCus);
            }
        }

        
        return custList;
    }
    


}