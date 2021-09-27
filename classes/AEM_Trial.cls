/*============================================================================================
    Name                : AEM_Trial
    Description         : This class is developed as part of CXD-ODT project for 'getTrailDetails' Service
                          The service in response returns Account, Contact and Trial record details based on SAPaccount number, SAPcontact number and Trial Campaign
    Created Date        : 1/16/2018
    Author              : TCS CXD ODT team
    Modification History: Modified by Harshitha 
                          DLT-8843:Adding one more parameter into the Service, 'Trial Campaign'
==============================================================================================*/

@RestResource(urlMapping='/TrialDetails/*')
global with Sharing class AEM_Trial {
    @Httpget
    global static TrialWrapper Tr() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        if(!test.isRunningTest())
        res.addHeader('Cache-Control','public,max-age=43200');
        String sapAccountNum= req.params.get('sapAccountNum');
        String sapContactId= req.params.get('sapContactId');
        String campaignId= req.params.get('campaignId');
        Account ac=new Account();                    
        TrialWrapper Trwrp;
        Source_System_Detail__c ssdacct = new Source_System_Detail__c(); 
        
        if(sapAccountNum !='' && sapAccountNum != null ){
        try{
           ssdacct= [Select id,name,Source_System_Account_Number__c,OLC_Account_Number__c,(SELECT Id,Name,LCRM_Contact_ID__c from Contact_SSDs__r),(SELECT Contact_id_SAP__c,Contact_LeadId__c,Contact_Name__c,CreatedById,CreatedDate,CurrencyIsoCode,Id,InvitedDateTime__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,PrimaryContact__c,SystemModstamp,Trial_Campaign__c,Trial_End_Date__c,Trial_Id__c,Trial_Products_Recommendation__c,Trial_products__c,Trial_Source__c,Trial_Start_Date__c,Trial_Status__c FROM Trials__r WHERE Contact_id_SAP__c=:sapContactId AND Trial_campaign__c=:campaignId order by LastModifiedDate desc LIMIT 1) from Source_System_Detail__c where (Source_System_Account_Number__c= :sapAccountNum OR OLC_Account_Number__c = :sapAccountNum) limit 1];
          //ac=[SELECT Id,Name,SAPAccountNumber__c,(SELECT Id,Name,LCRM_Contact_ID__c from LCRM_Contact_SSD__c) FROM Account WHERE SAPAccountNumber__c= :ssdacct.Source_System_Account_Number__c];  
           }catch(System.QueryException e){
            System.debug('Could not find any Account for the SAP account number provided');
        }
        
        
        system.debug('Account SSD.........'+ac);
        
        //Check if account is null
        if(ssdacct.id !=null){
                system.debug('account' +ac);
                Trwrp= new TrialWrapper(ssdacct,'Data Found');
        }           
        else{
            system.debug('Account SSD from 42.........');
             Trwrp=new TrialWrapper(null,'No Data Found');
        }
        return Trwrp;
          }else{
              Trwrp=new TrialWrapper(null,'No Data Found in SFDC');
              return Trwrp;
          }
        }
        global class TrialWrapper{
            Source_System_Detail__c TrialDetails;           
            String Message;           
            
            TrialWrapper(Source_System_Detail__c a,String msg){
                this.TrialDetails= a;                
                this.Message=msg;
              
            }
        }        
    }