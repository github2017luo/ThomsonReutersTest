/********************************************************************************
Class Name : DCPRenewalOpportunity
@description : This class is used by DCPGetRenewal class to populate Opportunity JSON data.
***************************************************************************************

CHANGE HISTORY
==================================================================================
Date                        Owner                       Description 
16-04-2021             Vishnu Santhosh                  DCP-1157 | Class Created   
25-06-2021                  Dinesh                      DCP-2211 | Added autoRenewalDate 
25-06-2021              Vishnu Santhosh                 DCP-2212 | Added minimumAttorneys & maximumAttorneys
09-09-2021                Benjamin Her                  DCP-4671 Added campaign code
13-09-2021                Benjamin Her                  DCP-5114 Update logic for minimum number of attorney
*********************************************************************************/

public without sharing class DCPRenewalOpportunity {
    
    /**
        @description Populates the Opportunity Wrapper
        @param opp Opportunity instance with details to be populated.
        @param ssd Source System instance to get Digital Firm Information.
        @return Returns populated opportunity wrapper instance.
     */
    public static DCPRenewalOpportunityWrapper populateOpportunityDetails(Opportunity opp, Source_System_Detail__c ssd){
        
        DCPRenewalOpportunityWrapper objOpportunityWrapper = new DCPRenewalOpportunityWrapper();
        objOpportunityWrapper.isDigital = opp.isDigitalSpearHead__c;
        objOpportunityWrapper.renewalDate = opp.Renewal_Date__c;
        objOpportunityWrapper.opportunityId = opp.Id;
        objOpportunityWrapper.autoRenewalDate = opp.Renewal_Date__c.AddDays(1); //dinesh
        objOpportunityWrapper.campaignCode = opp.Campaign_Code__c;
        objOpportunityWrapper.subCampaignCode = opp.sub_Campaign_Code__c;

        System.debug(LoggingLevel.FINE, '*** DEBUGGING FROM DEV *** >>   : DCPRenewalSetting.getValue(Small Law Minimum Attorneys) '+ DCPRenewalSetting.getValue('Small Law Minimum Attorneys'));
        
        String firm = ssd.Digital_Firm__c.toLowerCase();
        switch on firm {
            when 'small law' {
                objOpportunityWrapper.maximumAttorneys = Integer.valueOf(DCPRenewalSetting.getValue('Small Law Maximum Attorneys'));
            }
            when 'medium law' {
                objOpportunityWrapper.maximumAttorneys = Integer.valueOf(DCPRenewalSetting.getValue('Medium Law Maximum Attorneys'));
            }
            when 'government' {
                objOpportunityWrapper.maximumAttorneys = Integer.valueOf(DCPRenewalSetting.getValue('Government Maximum Attorneys'));
            }
            when 'corporate' {
                objOpportunityWrapper.maximumAttorneys = Integer.valueOf(DCPRenewalSetting.getValue('Corporate Maximum Attorneys'));
            }
        }
        objOpportunityWrapper.minimumAttorneys = getMininumNumberOfAttorney(ssd);

       
        return objOpportunityWrapper;
    }

    private static integer getMininumNumberOfAttorney(Source_System_Detail__c ssd){
        Double minimumAttorney = 0;
        if(ssd.LCRM_APTS_Band_Number__c != null){
            minimumAttorney = ssd.LCRM_APTS_Band_Number__c;
        }
        else{
            for(Apttus_Config2__AssetLineItem__c asset : ssd.Asset_Line_Items1__r){
                if(asset.Apttus_Config2__Quantity__c > minimumAttorney){
                    minimumAttorney = asset.Apttus_Config2__Quantity__c;
                }
            }
        }

        return Integer.valueOf(minimumAttorney);
    }
}