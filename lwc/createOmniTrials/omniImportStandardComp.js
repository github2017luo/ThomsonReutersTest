import omniTrialBlacklistAlertLabel from '@salesforce/label/c.OmniTrialBlacklistAlertLabel';
import omniTrialCompetitorAlertLabel from '@salesforce/label/c.OmniTrialCompetitorAlertLabel';
import omniTrialDomainBlacklistAlertLabel from '@salesforce/label/c.OmniTrialDomainBlacklistAlertLabel';
import omniTrialSanctionAccountAlertLabel from '@salesforce/label/c.OmniTrialSanctionAccountAlertLabel';
import omniTrialOpptyStageAlertLabel from '@salesforce/label/c.OmniTrialOpptyStageAlertLabel';
import omniTrialDateValidationAlertLabel from '@salesforce/label/c.OmniTrialDateValidationAlertLabel';
import omniTrialAccountSSDCheckAlert from '@salesforce/label/c.OmniTrialAccountSSDCheckAlert';
import omniTrialProdctRequiredLabel from '@salesforce/label/c.OmniTrialProdctRequiredLabel';
import omniTrialContactRequiredLabel from '@salesforce/label/c.OmniTrialContactRequiredLabel';
import omniTrialNoOfDayRequiredLabel from '@salesforce/label/c.OmniTrialNoOfDayRequiredLabel';
import OmniTrialLapsedAccountAlertLabel from '@salesforce/label/c.OmniTrialLapsedAccountAlertLabel';
import OmniEloquaCallSuccessMsg from '@salesforce/label/c.OmniEloquaCallSuccessMsg';
import OmniEloquaCallFailureMsg from '@salesforce/label/c.OmniEloquaCallFailureMsg';
import OmniPrimaryContactAlert from '@salesforce/label/c.OmniPrimaryContactAlert';

import OPTYNAME_FIELD from '@salesforce/schema/Opportunity.Name';
import OPTYSTAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import OPTYOWNER_NAME_FIELD from '@salesforce/schema/Opportunity.Owner.Name';
import OPTYACCID_FIELD from '@salesforce/schema/Opportunity.AccountId';
import OPTYCONTACTEMAIL_FIELD from '@salesforce/schema/Opportunity.Key_Contact__r.Email';
import OPTYACCSSD_FIELD from '@salesforce/schema/Opportunity.Source_System_Detail__c';
import OPTYACCSAPNUMBER_FIELD from '@salesforce/schema/Opportunity.Account.SAPAccountNumber__c';
import OPTYACCSANCTIONEDSTATUS_FIELD from '@salesforce/schema/Opportunity.Account.Sanctioned_Status__c';


// Importing Trial Object fields
import STARTDATE_FIELD from '@salesforce/schema/Ent_Trial__c.Trial_Start_Date__c';
import ENDDATE_FIELD from '@salesforce/schema/Ent_Trial__c.Trial_End_Date__c';
import NOOFDAYS_FIELD from '@salesforce/schema/Ent_Trial__c.Number_of_Days__c';
import ACCOUNT_NAME_FIELD from  '@salesforce/schema/Ent_Trial__c.Account__c';
import OPPORTUNITY_NAME_FIELD from  '@salesforce/schema/Ent_Trial__c.Opportunity__c';
import TRIAL_STATUS_FIELD from  '@salesforce/schema/Ent_Trial__c.Trial_Status__c';
//import CONTACT_NAME_FIELD from  '@salesforce/schema/Ent_Trial__c.Contact_Name__c';
//import SOURCE_SYSTEM_FIELD from  '@salesforce/schema/Ent_Trial__c.Source_System_Detail__c';
import TRIAL_ID from  '@salesforce/schema/Ent_Trial__c.Id';

import ProductFamily from '@salesforce/schema/Product2.Family';
import PRODUCT_OBJECT from '@salesforce/schema/Product2';

export{omniTrialBlacklistAlertLabel, omniTrialCompetitorAlertLabel, omniTrialDomainBlacklistAlertLabel,OmniTrialLapsedAccountAlertLabel,
    omniTrialSanctionAccountAlertLabel, omniTrialOpptyStageAlertLabel, omniTrialDateValidationAlertLabel, OmniPrimaryContactAlert,
    omniTrialAccountSSDCheckAlert, OmniEloquaCallSuccessMsg, OmniEloquaCallFailureMsg, omniTrialProdctRequiredLabel, omniTrialContactRequiredLabel,omniTrialNoOfDayRequiredLabel,
    OPTYNAME_FIELD, OPTYSTAGE_FIELD, OPTYOWNER_NAME_FIELD, OPTYACCID_FIELD, OPTYCONTACTEMAIL_FIELD, OPTYACCSSD_FIELD,
    OPTYACCSAPNUMBER_FIELD, OPTYACCSANCTIONEDSTATUS_FIELD, ProductFamily, PRODUCT_OBJECT
};

export {STARTDATE_FIELD,ENDDATE_FIELD,NOOFDAYS_FIELD,ACCOUNT_NAME_FIELD,OPPORTUNITY_NAME_FIELD,TRIAL_STATUS_FIELD//SOURCE_SYSTEM_FIELD,CONTACT_NAME_FIELD,
    ,TRIAL_ID};