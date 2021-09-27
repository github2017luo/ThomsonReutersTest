import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadAddress from "@salesforce/apex/LTS_DataUtility.getLeadAddress";
import validateAddress from "@salesforce/apex/LTS_DataUtility.validateAddress";
import { updateRecord } from "lightning/uiRecordApi";
import Lotus_leadAddress_field_error from '@salesforce/label/c.Lotus_leadAddress_field_error';
export default class Lotus_LeadAddrLWC extends LightningElement {
  @api objectApiName;
  @api recordId;

  @track displayAddress = false;
  @track displaySpinner = false;
  @track readOnly = true;

  //address fields 
  @track addressOverride;
  @track addressValidate;
  @track leadCity;
  @track leadCountry;
  @track leadCountryCode;
  @track leadPostalCode;
  @track leadState;
  @track leadStateCode;
  @track leadStreet;
  @track leadCounty;
  @track mapMarkers = [];

  //Error or suggestion string
  @track errorString;
  @track validAddress = true;

  @track updateValidateField = true;

  @track resultString;
  //wire method lead address 
  @wire(getLeadAddress, { recordId: "$recordId" }) leadAddressProp({
    error, data
  }) {
    if (data) {
      console.log(JSON.stringify(data));
      //alert(JSON.stringify(data));
      this.addressOverride = data.AddressOverride;
      this.leadCity = data.LEADBILLINGCITY;
      this.leadCountry = data.LEADBILLINGCOUNTRY;
      this.leadCountryCode = data.LEADCOUNTRYCODE;
      this.leadPostalCode = data.LEADBILLINGPOSTALCODE;
      this.leadState = data.LEADBILLINGSTATE;
      this.leadStateCode = data.LEADSTATECODE;
      this.leadStreet = data.LEADBILLINGSTREET;
      this.leadCounty = data.LEADBILLINGCOUNTY;
      //alert('this.leadCountry'+this.leadCountry);
      console.log('data.AddressOverride :' + data.AddressOverride);
      console.log('data.LEADBILLINGCITY:' + data.LEADBILLINGCITY);
      console.log('data.LEADBILLINGCOUNTRY :' + data.LEADBILLINGCOUNTRY);
      console.log('data.LEADCOUNTRYCODE :' + data.LEADCOUNTRYCODE);
      console.log('data.LEADBILLINGPOSTALCODE :' + data.LEADBILLINGPOSTALCODE);
      console.log('data.LEADBILLINGSTATE :' + data.LEADBILLINGSTATE);
      console.log('data.LEADSTATECODE :' + data.LEADSTATECODE);
      console.log('data.LEADBILLINGSTREET :' + data.LEADBILLINGSTREET);
      console.log('data.LEADBILLINGCOUNTY :' + data.LEADBILLINGCOUNTY);

      this.mapMarkers = [{
        location: {
          City: '',
          Country: '',
          PostalCode: data.LEADBILLINGPOSTALCODE,
          State: '',
          Street: ''
        },
        title: 'Billing Address',
      }];

    }
    if (error) {
      console.log(JSON.stringify(error));
      //alert(JSON.stringify(error));
    }
  }


  //Method to display edit address fields
  handleEditAddress(event) {
    this.displayAddress = true;
  }

  //handle submit button 
  handleSubmit(event) {
    var logElem1 = this.template.querySelector('.log');
    //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
    logElem1.innerHTML = '';
    //alert(this.displaySpinner);+
    this.validAddress = true;
    /*if (event.detail.fields.CountryCode === null) {
      var logElem1 = this.template.querySelector('.log');
      //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
      logElem1.innerHTML = 'Country is mandatory';
      this.validAddress = false;
      this.displaySpinner = false;
      this.displayAddress = true;
      return;
    }*/

    this.displaySpinner = true;
    console.log(this.displaySpinner);
    event.preventDefault();       // stop the form from submitting
    const fields = event.detail.fields;
    console.log(JSON.stringify(event.detail.fields));
    //alert('Address_Validate__c'+JSON.stringify(event.detail.fields.Address_Validate__c)); 
    //alert('Address_Override__c'+JSON.stringify(event.detail.fields.Address_Override__c)); 
    if (fields.Address_Override__c === true) {
      fields.Address_Validate__c = true;
    }
    else {
      fields.Address_Validate__c = false;
      fields.Address_Override__c = false;
    }
    //alert('Address_Validate__c'+JSON.stringify(event.detail.fields.Address_Validate__c)); 
    //alert('Address_Override__c'+JSON.stringify(event.detail.fields.Address_Override__c)); 
    //alert(JSON.stringify(event.detail.fields));
    this.addressOverride = fields.Address_Override__c;
    this.leadCity = fields.City;
    this.leadCountry = fields.Country;
    //alert('this.leadCountry'+this.leadCountry);
    //alert('this.leadCountryCode'+this.leadCountryCode);
    this.leadCountryCode = fields.CountryCode;
    this.leadPostalCode = fields.PostalCode;
    this.leadState = fields.State;
    this.leadStateCode = fields.StateCode;
    this.leadStreet = fields.Street;
    this.leadCounty = fields.County__c;
    console.log('data.AddressOverride :' + this.addressOverride);
    console.log('data.LEADBILLINGCITY:' + this.leadCity);
    console.log('data.LEADBILLINGCOUNTRY :' + this.leadCountry);
    console.log('data.LEADCOUNTRYCODE :' + this.leadCountryCode);
    console.log('data.LEADBILLINGPOSTALCODE :' + this.leadPostalCode);
    console.log('data.LEADBILLINGSTATE :' + this.leadState);
    console.log('data.LEADSTATECODE :' + this.leadStateCode);
    console.log('data.LEADBILLINGSTREET :' + this.leadStreet);
    console.log('data.LEADBILLINGCOUNTY :' + this.leadCounty);

    this.mapMarkers = [{
      location: {
        City: '',
        Country: this.leadCountry,
        PostalCode: this.leadPostalCode,
        State: '',
        Street: ''
      },
      title: 'Billing Address',
    }];

    this.template.querySelector('lightning-record-edit-form').submit(fields);


    console.log(this.displaySpinner);


  }

  //cancel button
  handleReset(event) {
    this.displaySpinner = true;
    const inputFields = this.template.querySelectorAll(
      'lightning-input-field'
    );
    if (inputFields) {
      inputFields.forEach(field => {
        field.reset();
      });
    }
    this.displayAddress = false;
    this.displaySpinner = false;
  }

  //handlesuccess
  handleSuccess(event) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: 'Success',
        message: 'Lead address updated',
        variant: 'success'
      }),

      this.displaySpinner = false,
      this.displayAddress = false
    );
  }

  //handleError
  handleError(event) {
    //alert('Event');
    //alert('Event' + JSON.stringify(event));
    console.log('event' + event);
    var logElem1 = this.template.querySelector('.log');
    //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
    logElem1.innerHTML = event.detail.detail;
    this.validAddress = false;
    this.displaySpinner = false;
    this.displayAddress = true;
    return;

  }

  //handleValidateAddress
  handleValidateAddress(event) {
    this.updateValidateField = true;
    this.displaySpinner = true;
    console.log('data.AddressOverride :' + this.addressOverride);
    console.log('data.LEADBILLINGCITY:' + this.leadCity);
    console.log('data.LEADBILLINGCOUNTRY :' + this.leadCountry);
    console.log('data.LEADCOUNTRYCODE :' + this.leadCountryCode);
    console.log('data.LEADBILLINGPOSTALCODE :' + this.leadPostalCode);
    console.log('data.LEADBILLINGSTATE :' + this.leadState);
    console.log('data.LEADSTATECODE :' + this.leadStateCode);
    console.log('data.LEADBILLINGSTREET :' + this.leadStreet);
    console.log('data.LEADBILLINGCOUNTY :' + this.leadCounty);
    //alert('this.leadCountry'+this.leadCountry);
    //alert('this.leadCountryCode'+this.leadCountryCode);
    /*if (this.leadCountryCode === null || this.leadCountryCode === '' || this.leadCountryCode === undefined) {
    
      var logElem1 = this.template.querySelector('.log');
      //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
      logElem1.innerHTML = Lotus_leadAddress_field_error;
      this.validAddress = false;
      this.displaySpinner = false;     
      return;
    }*/

    let dataToValidate = {
      BillingStreet: this.leadStreet,
      BillingPostalCode: this.leadPostalCode,
      BillingCity: this.leadCity,
      BillingCountry: this.leadCountryCode,
      BillingState: this.leadState,
      BillingCounty: this.leadCounty,
      AccountName: "Company Name",
      BillingPoBox: this.leadPostalCode,
      BillingProvince: this.leadStateCode
    };

    validateAddress({ validateAddressParam: dataToValidate })
      .then(result => {
        console.log('Testing');
        console.log('RESULT@@ ' + JSON.stringify(result));
        this.resultString = result;

        console.log('resultString@@' + this.resultString);
        /*if (result[1] !== "") {
          this.leadCounty = result[1];
        }*/

        console.log('Result Length' + result.length);
        for (let i = 0; i < result.length; i++) {
          console.log('Testing' + i);
          console.log('result' + result[i]);
          var resultString = result[i];
          console.log('@@resultString' + resultString);
          console.log(resultString.includes("The specified address may not be valid"));
          console.log(resultString.includes("The specified address is not valid"));
          if (resultString.includes("The specified address may not be valid") ||
            resultString.includes("The specified address is not valid")) {
            console.log('INCLUDES');
            this.updateValidateField = false;
            this.errorString = result[i];
            this.displaySpinner = false;
            return;

          }
          else if ((!resultString.includes("The specified address may not be valid") ||
            !resultString.includes("The specified address is not valid") ||
            !resultString.includes("Retrieved Result")) && result[i] !== "" && resultString !== "Retrieved Result" ) {
            console.log('INCLUDES COUNTY');
            this.leadCounty = resultString;
          }

        }  //end of for 
        //alert('this.leadCountry'+this.leadCountry);
        //alert('this.leadCountryCode'+this.leadCountryCode);
        //  Country: this.leadCountry,

        console.log('updateValidateField' + this.updateValidateField);
        console.log('this.addressOverride' + this.addressOverride);
        var addressOverrideBoolean;
        if (this.addressOverride == "true") {
          addressOverrideBoolean = true;
        }
        else if (this.addressOverride == "false") {
          addressOverrideBoolean = false;
        }
        const recordInput = {
          fields: {
            Id: this.recordId,
            County__c: this.leadCounty,
            Address_Validate__c: this.updateValidateField,
            City: this.leadCity,
            Street: this.leadStreet,
            PostalCode: this.leadPostalCode,
            CountryCode: this.leadCountryCode,
            Country: this.leadCountryCode,
            StateCode: this.leadStateCode,
            Address_Override__c: addressOverrideBoolean
          }
        };

        console.log('recordInput' + recordInput);
        updateRecord(recordInput)
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Lead address updated",
                variant: "success"
              }),

              this.displaySpinner = false,
              this.displayAddress = false
            );

            this.mapMarkers = [{
              location: {
                City: '',
                Country: '',
                PostalCode: this.leadPostalCode,
                State: '',
                Street: ''
              },
              title: 'Billing Address',
            }];
          })
          .catch(error => {

            this.dispatchEvent(
              new ShowToastEvent({
                title: "Failure",
                message: "Error while updating address" + error.body.message,
                variant: "Failure"
              }),

              this.displaySpinner = false,
              this.displayAddress = false
            );

          });

      })
      .catch(error => {
        console.log('RESULT@@ ' + JSON.stringify(error));
        this.displaySpinner = false;
      });

  }

}