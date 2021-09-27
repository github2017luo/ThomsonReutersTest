import { LightningElement, api, track, wire } from 'lwc';

import validateAddress from '@salesforce/apex/LTS_DataUtility.validateAddress';
import populateBuRegion from '@salesforce/apex/LTS_DataUtility.populateBuRegion';
import getAccountAddress from '@salesforce/apex/LTS_DataUtility.getAccountAddress';
import getExcludedCountries from '@salesforce/apex/LTS_DataUtility.getExcludedCountries';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord } from 'lightning/uiRecordApi';
import Lotus_accountAddress_field_error from '@salesforce/label/c.Lotus_accountAddress_field_error';


export default class Lotus_AccountAddressLWC extends LightningElement {
    @api recordId;
    @api objectApiName;

    @track displaySpinner = false;
    @track EditButtonAddress = false;
    @track displayAddress = false;
    @track excludedCountries = [];
    @track skipState = false;


    @track impBillingStreet;
    @track impBillingCity;
    @track impBillingState;
    @track impBillingCountry;
    @track impPostalcode;
    @track impCounty;
    @track impBillingStateCode;
    @track impBillingCountryCode;

    @track impName;
    @track impProvince;
    @track impBuRegion;

    @track errorString;
    @track mapMarkers = [];

    @track handleError;



    @track validAddress = true;
    @track regionCheck = false;
    @track readonly = true;

    @wire(getExcludedCountries) countries({error,data}){
        if(data){
            console.log('Data ==> '+JSON.stringify(data));
          
            //alert('Data ==>'+JSON.stringify(data));

            for(let i = 0;i<=data.length;i++){

                this.excludedCountries.push(data[i]);
            }
            //alert('excludedCountries ==>'+this.excludedCountries);
            //alert('excludedCountries ==>'+this.excludedCountries.includes('TC'));
            
        }
        else if(error){
           console.log('error ==> '+JSON.stringify(data));
        }
    }

    handleSubmit(event) {

        this.displaySpinner = true;
        this.validAddress = true;

        var logElem = this.template.querySelector('.log');
        //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
        logElem.innerHTML = '';
        //alert('2');

        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        console.log('fields' + JSON.stringify(event.detail.fields));
        console.log('BillingCity' + (event.detail.fields.BillingCity));
        console.log('BillingCountry' + (event.detail.fields.BillingCountry));
        console.log('BillingCountryCode' + (event.detail.fields.BillingCountryCode));
        console.log('BillingPostalCode' + (event.detail.fields.BillingPostalCode));
        console.log('BillingState' + (event.detail.fields.BillingState));
        console.log('BillingStateCode' + (event.detail.fields.BillingStateCode));
        console.log('BillingStreet' + (event.detail.fields.BillingStreet));
        console.log('County__c' + (event.detail.fields.County__c));
        console.log('BU_Region__c' + (event.detail.fields.BU_Region__c));

        this.impBillingStreet = event.detail.fields.BillingStreet;
        this.impBillingCity = event.detail.fields.BillingCity;
        this.impBillingState = event.detail.fields.BillingState;
        this.impBillingStateCode = event.detail.fields.BillingStateCode;
        this.impBillingCountry = event.detail.fields.BillingCountry;
        this.impBillingCountryCode = event.detail.fields.BillingCountryCode;
        this.impPostalcode = event.detail.fields.BillingPostalCode;
        this.impCounty = event.detail.fields.County__c;
        this.impBuRegion = event.detail.fields.BU_Region__c;
/*
        if (event.detail.fields.BillingCountryCode === null && this.excludedCountries.includes(event.detail.fields.BillingCountryCode) === false &&
        event.detail.fields.BillingStateCode === null && event.detail.fields.BillingStreet === null && event.detail.fields.BillingCity === null
        && event.detail.fields.BillingPostalCode === null
        ) {
            var logElem1 = this.template.querySelector('.log');
            //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
            logElem1.innerHTML = 'Address fields are mandatory';
            this.validAddress = false;
            this.displaySpinner = false;
            this.displayAddress = true;
            return;
        } || event.detail.fields.BillingPostalCode === null
*/
       if(event.detail.fields.BillingCountryCode !==  null && this.excludedCountries.includes(event.detail.fields.BillingCountryCode) === true){
            this.skipState = true;
        }
        if( this.skipState === true && (event.detail.fields.BillingStreet === null ||  event.detail.fields.BillingCity === null
            )){
                var logElem1 = this.template.querySelector('.log');
                logElem1.innerHTML = Lotus_accountAddress_field_error;
                this.validAddress = false;
                this.displaySpinner = false;
                this.displayAddress = true;
                return;

        }
        else if (this.skipState === false && (event.detail.fields.BillingStreet === null ||  event.detail.fields.BillingCity === null
            || event.detail.fields.BillingPostalCode === null || event.detail.fields.BillingCountryCode === null ||    event.detail.fields.BillingStateCode === null)){
                var logElem1 = this.template.querySelector('.log');
                logElem1.innerHTML = Lotus_accountAddress_field_error;
                this.validAddress = false;
                this.displaySpinner = false;
                this.displayAddress = true;
                return;
        }
        if( this.impPostalcode !== null){
            var str = this.impPostalcode;
            var strLength = str.length;
            if(str.length > 10){
                var logElem1 = this.template.querySelector('.log');
                logElem1.innerHTML = "Postal Code cannot exceed 10 characters.";
                this.validAddress = false;
                this.displaySpinner = false;
                this.displayAddress = true;
                return;
            }
        }

        let dataToValidate = {
            BillingStreet: this.impBillingStreet,
            BillingPostalCode: this.impPostalcode,
            BillingCity: this.impBillingCity,
            BillingCountry: this.impBillingCountryCode,
            BillingState: this.impBillingStateCode,
            BillingCounty: this.impCounty,
            AccountName: this.impName,
            BillingPoBox: this.impPoBox,
            BillingProvince: this.impBillingStateCode
        }
        validateAddress({ validateAddressParam: dataToValidate })
            .then(result => {
                this.validAddress = true;
                console.log('@@RESULT@@' + result);
                //alert('VALIDATE ADDRESS');
                var validateError = false;
                console.log(' result.length ' + result.length);
                for (let i = 0; i < result.length; i++) {
                    if (result[i].includes("The specified address may not be valid") ||
                        result[i].includes("The specified address is not valid")) {


                        this.errorString = result[i];
                        //alert(this.errorString);
                        var logElem1 = this.template.querySelector('.log');
                        //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
                        logElem1.innerHTML = this.errorString;
                        this.validAddress = false;
                        this.displaySpinner = false;
                        this.displayAddress = true;
                        return;



                    }
                    // else {



                    // }

                }

                populateBuRegion({ accountId: this.recordId, billingCountry: this.impBillingCountryCode }).then(
                    resultBuRegion => {
                        if (resultBuRegion !== '' && resultBuRegion !== 'undefined') {
                            this.impBuRegion = resultBuRegion;
                            console.log('this.impBuRegion' + this.impBuRegion);



                            if (this.impBuRegion !== '' && this.impBuRegion !== 'undefined' && this.impBuRegion !== null) {
                                fields.BU_Region__c = this.impBuRegion;
                                console.log(' fields.BU_Region__c' + fields.BU_Region__c);
                                console.log('fields' + JSON.stringify(fields));

                                this.regionCheck = true;


                            }
                            if (this.regionCheck === true && this.validAddress === true) {

                                const updateFields = event.detail.fields;
                                //alert(JSON.stringify(updateFields));
                                updateFields.BU_Region__c = this.impBuRegion;
                                //alert(  updateFields.BU_Region__c );
                                this.template.querySelector('lightning-record-edit-form').submit(updateFields);
                                //alert('test' + this.template.querySelector('lightning-record-edit-form').submit(updateFields));
                                
                                this.mapMarkers = [{
                                    location: {
                                        City: '',
                                        Country: '',
                                        PostalCode: this.impPostalcode,
                                        State: '',
                                        Street: ''
                                    },
                                    title: 'Billing Address',
                                }];
                               
                               
                                this.displayAddress = true;

                                

                            }



                            /*  if (this.validAddress == true) {
                                 const updateFields = event.detail.fields;
                                 console.log('fields' + JSON.stringify(updateFields));
                                 if (updateFields != null) {
                                     updateFields.BU_Region__c = this.impBuRegion;
                                 }
                                if (updateFields != null) {
                                     this.regionCheck = true;
                                     //this.template.querySelector('lightning-record-edit-form').submit(updateFields);
                                 }
                                 if (updateFields.BillingPostalCode !== null
                                     && updateFields.BillingPostalCode !== ''
                                     && updateFields.BillingPostalCode !== 'undefined') {
                                     this.mapMarkers = [{
                                         location: {
                                             City: '',
                                             Country: '',
                                             PostalCode: updateFields.BillingPostalCode,
                                             State: '',
                                             Street: ''
                                         },
                                         title: 'Billing Address',
                                     }];
                                 }
        
                                 this.displaySpinner = false;
                                 this.displayAddress = false;
        
                             }*/


                        }                   
                    }).catch(error => {
                        
                       console.log('ERROR ' + error);
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error Updating Account Address',
                                message: error.message.body,
                                variant: 'error'
                            })
                        );
                        this.displaySpinner = false;
                    });                

            })
            .catch(error => {
                console.log('ERROR ' + error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Updating Account Address',
                        message: error.message.body,
                        variant: 'error'
                    })
                );
                this.displaySpinner = false;
                console.log('END of validate address submit');
            });



        console.log('END of handle submit');


    }

    handleReset(event) {
        this.displaySpinner = true;
        this.displayAddress = false;

        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.displaySpinner = false;
    }

    handleEditAddress(event) {
        this.displayAddress = true;
        this.readonly = true;
    }

    handleSuccess(event) {
        this.accountId = event.detail.id;   
        this.handleError = '';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Account address updated',
                variant: 'success'
            }),
            this.fieldErrorCheck = false,
            this.displaySpinner = false,
            this.displayAddress = false



        );
    }

    handleError(event) {
        this.displaySpinner = false;
        alert(JSON.stringify(event));
       // this.handleError = event.detail.message;    
        var logElem1 = this.template.querySelector('.log');
        //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
        logElem1.innerHTML =  event.detail.detail;
        this.validAddress = false;       
        this.displayAddress = true;

    }

    //Address Fields
    @wire(getAccountAddress, { recordId: '$recordId' }) accountAddressProp({ error, data }) {
        if (data !== undefined) {

            //Edit Address Button Code
            if ((data.ECMPartyID !== null && data.ECMPartyID !== undefined) && (data.RecordtypeName === 'GLI Account-ECM')) {
                this.EditButtonAddress = true;
            }

            this.mapMarkers = [{
                location: {
                    City: '',
                    Country: '',
                    PostalCode: data.BillingPostalCode,
                    State: '',
                    Street: ''
                },
                title: 'Billing Address',
            }];
            //console.log(this.AddressMap.AccountCity);
        }
        if (error) {
            console.log(error);
        }
    }

 

}