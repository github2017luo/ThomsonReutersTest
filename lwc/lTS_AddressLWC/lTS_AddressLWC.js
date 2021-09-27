/* eslint-disable @lwc/lwc/no-document-query */
/* eslint-disable @lwc/lwc/no-inner-html */
/* eslint-disable guard-for-in */
/* eslint-disable no-alert */
/* eslint-disable consistent-return */

/* eslint-disable no-redeclare */
/* eslint-disable no-unused-vars */
/* eslint-disable vars-on-top */
/* eslint-disable no-console */

import { LightningElement, api, wire, track } from 'lwc';

import getCountryCode from '@salesforce/apex/LTS_DataUtility.getCountryCode';
import getStateValues from '@salesforce/apex/LTS_DataUtility.getStateValues';
import validateAddress from '@salesforce/apex/LTS_DataUtility.validateAddress';
import populateBuRegion from '@salesforce/apex/LTS_DataUtility.populateBuRegion';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountAddress from '@salesforce/apex/LTS_DataUtility.getAccountAddress';
import Billing_Street_or_PO_Box from '@salesforce/label/c.Billing_Street_or_PO_Box';

export default class LTS_AddressLWC extends LightningElement {

    @api recordId;
    @api objectApiName;
    @api countrycodetrack;
    @api accountAddress;
    @api displayAddress = false;
    @api EditButtonAddress = false;
    @api showBillingState = false;
    @api reasonOptions;
    @api countryOptions;
    @api fieldErrorCheck = false;
    @api postalCodeIsBlank = false;
    @api displaySpinner = false;
    @api recursiveCheck = false;
    @api spinner = false;

    /* */
    @track mapMarkers = [];
    @track AddressMap = {
        AccountId: "",
        AccountCity: "",
        AccountPostalCode: "",
        AccountBillingCountry: "",
        AccountBillingStreet: "",
        AccountBillingStreet2: "",
        AccountBillingState: "",
        PoBox: "",
        SuiteNumber: "",
        County:""


    };
    @track countryCodeValue = '';
    @track countrycode;
    @track error;

    @track clickedButtonLabel;
    @track displayAddressSuggestion = false;


    @track impName;
    @track impBillingCity;
    @track impBillingState;
    @track impBillingCountry;
    @track impPostalcode;
    @track impBillingStreet;
    @track impBillingStreet2;
    @track impCounty;
    @track impProvince;
    @track impPoBox;
    @track impSuiteNumber;
    @track impBuRegion;

    @track errorString;
    @track errorString1;


    connectedCallback() {
        this.fieldErrorCheck = false;
        this.postalCodeIsBlank = false;
        getCountryCode({}).then(result => {
            console.log('TEST METHOD' + result);
            let objNameValues = [];
            for (let i = 0; i < result.length; i++) {
                objNameValues.push({
                    label: result[i],
                    value: result[i]
                });
            }
            this.reasonOptions = objNameValues;
        })
            .catch(() => {
            })





    }


    //Address Fields
    @wire(getAccountAddress, { recordId: '$recordId' }) accountAddressProp({ error, data }) {
        if (data !== undefined) {
            // alert(data);
            // console.log(data);
            this.AddressMap.AccountCity = data.BillingCity;
            this.AddressMap.AccountPostalCode = data.BillingPostalCode;
            this.AddressMap.AccountBillingCountry = data.BillingCountry;
            //this.countryCodeValue = data.BillingCountry;
            this.AddressMap.AccountBillingStreet = data.BillingStreet;
            this.AddressMap.AccountBillingStreet2 = data.BillingStreet2;

            this.AddressMap.PoBox = data.PoBox;
            this.AddressMap.SuiteNumber = data.SuiteNumber;
            this.AddressMap.AccountId = data.AccountId;
            this.AddressMap.AccountBillingState = data.BillingState;
            this.AddressMap.PoBox = data.PoBox;
            this.AddressMap.SuiteNumber = data.SuiteNumber;
            this.AddressMap.County = data.County;

            //alert('ECM PArty ID'+data.ECMPartyID);
            //alert('RecordtypeName'+data.RecordtypeName);

            //Edit Address Button Code
            if ((data.ECMPartyID !== null && data.ECMPartyID !== undefined) && (data.RecordtypeName === 'GLI Account-ECM')) {
                this.EditButtonAddress = true;
            }
            this.impName = data.Name;
            this.impCounty = data.County;
            this.impProvince = data.County;



            if (this.AddressMap.AccountBillingState !== undefined || this.AddressMap.AccountBillingState !== '') {
                this.showBillingState = true;
            }
            this.mapMarkers = [{
                location: {
                    City: '',
                    Country: '',
                    PostalCode: this.AddressMap.AccountPostalCode,
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


    //button success

    handleClick(event) {
        //alert('1');
        this.displaySpinner = true;
        this.fieldErrorCheck = false;
        this.clickedButtonLabel = event.target.label;
        this.errorString = '';

        var logElem = this.template.querySelector('.log');
        //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
        logElem.innerHTML = '';
        //alert('2');





        var billingCity = '';
        if (this.template.querySelector('.cityClass').value !== undefined) {
            billingCity = this.template.querySelector('.cityClass').value;

        }
        else {
            billingCity = this.AddressMap.AccountCity

        }

        var billingCountry = '';
        var finalCountryString = '';
        if (this.template.querySelector('.countryCodeClass').value !== undefined) {
            billingCountry = this.template.querySelector('.countryCodeClass').value;
            finalCountryString = billingCountry.slice(0, 2);
        }
        else {
            billingCountry = this.AddressMap.AccountBillingCountry;
            finalCountryString = billingCountry;

        }

        var billingState = '';
        var splitStateString = '';
        var finalStateString = '';
        if (this.showBillingState === true) {
            if (this.template.querySelector('.stateClass').value !== undefined) {
                billingState = this.template.querySelector('.stateClass').value;
                splitStateString = billingState.split("-");
                finalStateString = splitStateString[0];
            }
            else {
                billingState = this.AddressMap.AccountBillingState;
                finalStateString = billingState;

            }
        }
        /* var billingCountry = '';
         if (this.template.querySelector('.countryCodeClass').value !== undefined) {
             billingCountry = this.template.querySelector('.countryCodeClass').value !== undefined
         }
         else {
             billingCountry = this.AddressMap.AccountBillingCountry;
         }*/

        var billingPostalCode = this.template.querySelector('.postalClass').value;
        var billingstreet = this.template.querySelector('.billingStreetClass').value;
        var billingstreet2 = this.template.querySelector('.billingStreet2Class').value;
        var PoBox = this.template.querySelector('.POBoxClass').value;
        var SuiteNumber = this.template.querySelector('.SuiteNumberClass').value;
        var accountCounty = this.template.querySelector('.countyClass').value;

         if(billingPostalCode === '' || billingPostalCode == null || billingPostalCode === undefined){
            this.fieldErrorCheck = true;  
         }



        this.impBillingCity = billingCity;
        this.impBillingState = finalStateString;
        this.impBillingCountry = finalCountryString;
        this.impPostalcode = billingPostalCode;
        this.impBillingStreet = billingstreet;
        this.impBillingStreet2 = billingstreet2;
        this.impPoBox = PoBox;
        this.impSuiteNumber = SuiteNumber;
        this.impCounty = accountCounty;

        console.log('' + this.impBillingStreet2 + '' + this.impPoBox + '' + this.impSuiteNumber + '');

        console.log(' ' + this.impBillingCity +
            ' ' + this.impBillingCountry +
            ' ' + this.impBillingState +
            ' ' + this.impBillingStreet +
            ' impCounty' + this.impCounty +
            ' ' + this.impName +
            ' ' + this.impPoBox +
            ' ' + this.impPostalcode +
            ' ' + this.impProvince);

        let dataToValidate = {
            BillingStreet: this.impBillingStreet,
            BillingPostalCode: this.impPostalcode,
            BillingCity: this.impBillingCity,
            BillingCountry: this.impBillingCountry,
            BillingState: this.impBillingState,
            BillingCounty: this.impCounty,
            AccountName: this.impName,
            BillingPoBox: this.impPoBox,
            BillingProvince: this.impProvince
        }

        



        console.log(this.impBillingStreet + ' @@@@ ' + this.impPostalcode);

        // alert('param1 '+Object.keys(this.validateAddressParam).length);
        validateAddress({ validateAddressParam: dataToValidate })
            .then(result => {
                console.log(result);
                //alert('VALIDATE ADDRESS');
                var validateError = false;
                for (let i = 0; i < result.length; i++) {
                    console.log('RESULT 1 : ' + i)
                    console.log(result[i]);
                    console.log('TestCase : ' +this.fieldErrorCheck);
                    if(this.fieldErrorCheck === true){
                        this.displaySpinner = false;
                        this.displayAddress = true;
                        
                    }else if (result[i].includes("The specified address may not be valid")) {

                        this.validateError = true;
                        this.errorString = result[i];
                        //alert(this.errorString);
                        var logElem1 = this.template.querySelector('.log');
                        //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
                        logElem1.innerHTML = this.errorString;

                        this.displaySpinner = false;
                        this.displayAddress = true;

                    }
                    else {
                        this.validateError = false;
                        //alert('accountId: ' + this.recordId + 'BillingCountry ' + this.impBillingCountry);
                        //GetBuRegion
                        populateBuRegion({ accountId: this.recordId, billingCountry: this.impBillingCountry }).then(
                            resultBuRegion => {
                                //alert('resultBuRegion'+resultBuRegion);
                                if (resultBuRegion !== '' || resultBuRegion !== 'undefined') {
                                    this.impBuRegion = resultBuRegion;
                                }
                                //alert(resultBuRegion);



                                if (this.fieldErrorCheck === false) {
                                    // alert(this.fieldErrorCheck);
                                    const recordInput = {
                                        fields: {
                                            Id: this.recordId,
                                            BillingCity: billingCity,
                                            BillingStreet: billingstreet,
                                            BillingPostalCode: billingPostalCode,
                                            BillingCountry: finalCountryString,
                                            BillingState: finalStateString,
                                            Street_Address_2__c: this.impBillingStreet2,
                                            PO_Box__c: this.impPoBox,
                                            Suite_Number__c: this.impSuiteNumber,
                                            BU_Region__c: this.impBuRegion,
                                            County__c: this.impCounty

                                        },
                                    };
                                    //const recordInput = { fields };
                                    console.log(recordInput);
                                    updateRecord(recordInput)
                                        .then(() => {
                                            this.mapMarkers = [{
                                                location: {
                                                    City: '',
                                                    Country: '',
                                                    PostalCode: recordInput.fields.BillingPostalCode,
                                                    State: '',
                                                    Street: ''
                                                },
                                                title: 'Billing Address',
                                            }];
                                            this.AddressMap.AccountBillingStreet = recordInput.fields.BillingStreet;
                                            this.AddressMap.AccountPostalCode = recordInput.fields.BillingPostalCode;
                                            this.AddressMap.AccountBillingState = recordInput.fields.BillingState;
                                            this.AddressMap.AccountCity = recordInput.fields.BillingCity;
                                            this.AddressMap.AccountBillingCountry = recordInput.fields.BillingCountry;

                                            this.dispatchEvent(
                                                new ShowToastEvent({
                                                    title: 'Success',
                                                    message: 'Account address updated',
                                                    variant: 'success'
                                                }),
                                                this.fieldErrorCheck = false,
                                                this.displaySpinner = false,



                                            );
                                            // Display fresh data in the form
                                            //return refreshApex(this.account);
                                            this.displayAddress = false;
                                            //location.mapid.reload();
                                        })
                                        .catch(error => {
                                            //console.log('ERROR ' + error);
                                            this.dispatchEvent(
                                                new ShowToastEvent({
                                                    title: 'Error Updating Account Address',
                                                    message: error.message.body,
                                                    variant: 'error'
                                                })
                                            );
                                            this.displaySpinner = false;
                                        });
                                } }
                        );

                        /*if (this.fieldErrorCheck === false) {
                            // alert(this.fieldErrorCheck);
                            const recordInput = {
                                fields: {
                                    Id: this.recordId,
                                    BillingCity: billingCity,
                                    BillingStreet: billingstreet,
                                    BillingPostalCode: billingPostalCode,
                                    BillingCountry: finalCountryString,
                                    BillingState: finalStateString,
                                    Street_Address_2__c: this.impBillingStreet2,
                                    PO_Box__c: this.impPoBox,
                                    Suite_Number__c: this.impSuiteNumber

                                },
                            };
                            //const recordInput = { fields };
                            console.log(recordInput);
                            updateRecord(recordInput)
                                .then(() => {
                                    this.mapMarkers = [{
                                        location: {
                                            City: '',
                                            Country: '',
                                            PostalCode: recordInput.fields.BillingPostalCode,
                                            State: '',
                                            Street: ''
                                        },
                                        title: 'Billing Address',
                                    }];
                                    this.AddressMap.AccountBillingStreet = recordInput.fields.BillingStreet;
                                    this.AddressMap.AccountPostalCode = recordInput.fields.BillingPostalCode;
                                    this.AddressMap.AccountBillingState = recordInput.fields.BillingState;
                                    this.AddressMap.AccountCity = recordInput.fields.BillingCity;
                                    this.AddressMap.AccountBillingCountry = recordInput.fields.BillingCountry;

                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Success',
                                            message: 'Account address updated',
                                            variant: 'success'
                                        }),
                                        this.fieldErrorCheck = false,
                                        this.displaySpinner = false,



                                    );
                                    // Display fresh data in the form
                                    //return refreshApex(this.account);
                                    this.displayAddress = false;
                                    //location.mapid.reload();
                                })
                                .catch(error => {
                                    //console.log('ERROR ' + error);
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Error Updating Account Address',
                                            message: error.message.body,
                                            variant: 'error'
                                        })
                                    );
                                    this.displaySpinner = false;
                                });
                        } */

                    }

                }
                this.fieldErrorCheck = this.validateError;
            })
            .catch(error => {
                console.log(error.message);
            })
        console.log('this.fieldErrorCheck@@@ ' + this.fieldErrorCheck);
    }


    //handleCancelClick - Method takes you back to displayAddress template
    handleCancelClick(event) {
        this.displayAddress = false;

    }
    label = {
        Billing_Street_or_PO_Box,
    };

    //populate state field
    handleChange(event) {
        // eslint-disable-next-line no-alert
        //console.log(event.detail.value);
        //this.value = event.detail.value;

        //to render state field       
        var selectedbillingCountry = this.template.querySelector('.countryCodeClass').value;
        //console.log('selectedbillingCountry@@@ ' + selectedbillingCountry);
        //var countrycode = '';
        this.countrycode = selectedbillingCountry.slice(0, 2);
        //console.log('countrycode@@@@ ' + this.countrycode);
        getStateValues({ countrycodestr: this.countrycode }).then(countryStateresult => {
            //console.log('@@@STATE ' + countryStateresult);
            if (countryStateresult.length > 0) {
                this.showBillingState = true;
            }
            else {
                this.showBillingState = false;
            }
            let countryOptionsValues = [];
            for (let i = 0; i < countryStateresult.length; i++) {
                countryOptionsValues.push({
                    label: countryStateresult[i],
                    value: countryStateresult[i]
                });

            }
            this.countryOptions = countryOptionsValues;
            //console.log('this.countryOptions' + this.countryOptions);
        }).catch(() => { });
    }

    handleEditAddress(event) {
        this.displayAddress = true;
        //alert(this.AddressMap.AccountId);
        getAccountAddress({ recordId: this.AddressMap.AccountId }).then(result => {
            console.log(result);
            for (let accountRec in result) {
                console.log(accountRec);
                console.log('@accountRec' + result[accountRec]);


            }

        })

    }

    countryChange(event) {

    }


    myFunction = function () {
        alert('INSIDE myFunction');
        var lists = document.getElementsByTagName("ul");
        alert(lists);
        for (var i = 0; i < lists.length; ++i) {
            var items = lists[i].getElementsByTagName("li");
            alert(items[i]);
            for (var j = 0; j < items.length; ++j) {
                alert(items[j]);
                console.log(items[j]);
            }

        }
    }

    str2DOMElement = function (html) {
        var wrapper = document.createElement('ul');
        wrapper.innerHTML = html;
        var div = wrapper.firstChild;
        alert(div);
        return div;
    }



}