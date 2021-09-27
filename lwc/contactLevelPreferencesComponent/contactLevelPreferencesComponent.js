import {
    LightningElement,wire,api
} from 'lwc';
import { getRecord, getFieldValue  } from 'lightning/uiRecordApi';
import getTRPreferenceCenterLink from '@salesforce/apex/LCRMPreferenceMethod.getTRPreferenceCenterLink';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import DONOTCALL_FIELD from '@salesforce/schema/Contact.DoNotCall';
import DONOTMAIL_FIELD from '@salesforce/schema/Contact.Do_not_Mail__c';
import COUNTRY_FIELD from '@salesforce/schema/Contact.LCRM_Country__c';
import LANDLINE from '@salesforce/schema/Contact.LCRM_Consent_To_Landline_Call__c';
import CONSENTMAIL from '@salesforce/schema/Contact.LCRM_Consent_To_Mail__c';
import MOBCALL from '@salesforce/schema/Contact.LCRM_Consent_To_Mobile_Call__c';
import SMS from '@salesforce/schema/Contact.LCRM_Consent_To_SMS__c';
import DO_NOT_MAIL from '@salesforce/label/c.LTS_DoNotEmail';
import PREFERENCE_CENTER from '@salesforce/label/c.LTS_PreferenceCenter';

export default class Recordform extends LightningElement {
    @api recordId ; 
     contactObject = CONTACT_OBJECT;
     USFields = [DONOTCALL_FIELD, DONOTMAIL_FIELD];
     NONUSFields = [LANDLINE, CONSENTMAIL,MOBCALL,SMS];
     label = {
      PREFERENCE_CENTER,
      DO_NOT_MAIL
  };
     @wire (getRecord, {
        recordId:'$recordId',
        fields:['Contact.LCRM_Country__c']
      }
 )
 contact;

 @wire(getTRPreferenceCenterLink, 
  {
   contactId: '$recordId'
  }
  ) preferencecenter;
   
    get hasrendered() {
       return (getFieldValue(this.contact.data, COUNTRY_FIELD) === 'US') ? true : false;
    }
    
    handleSubmit(event) {
      console.log('onsubmit: '+ event.detail.fields);

  }
  handleSuccess(event) {
      const updatedRecord = event.detail.id;
      console.log('onsuccess: ', updatedRecord);
  }
}