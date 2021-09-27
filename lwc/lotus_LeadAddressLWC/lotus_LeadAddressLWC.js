/* eslint-disable no-loop-func */
/* eslint-disable no-unused-vars */
/* eslint-disable @lwc/lwc/no-inner-html */
/* eslint-disable no-console */
/* eslint-disable vars-on-top */
/* eslint-disable no-alert */
import { LightningElement, api, wire, track } from "lwc";
import getCountryCode from "@salesforce/apex/LTS_DataUtility.getCountryCode";
import getStateValues from "@salesforce/apex/LTS_DataUtility.getStateValues";
import validateAddress from "@salesforce/apex/LTS_DataUtility.validateAddress";
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getLeadAddress from "@salesforce/apex/LTS_DataUtility.getLeadAddress";
export default class Lotus_LeadAddressLWC extends LightningElement {
  @api objectApiName;
  @api recordId;

  @api reasonOptions;
  @api displaySpinner = false;
  @api showAddressSuggestions = false;
  @api displayAddress = false;
  @api showBillingState = false;

  @api displayStandardLeadAddress = false; //Standard

  @track AddressMap = {
    LEADBILLINGSTREET: "",
    LEADBILLINGCITY: "",
    LEADBILLINGCOUNTRY: "",
    LEADBILLINGSTATE: "",
    LEADBILLINGPOSTALCODE: "",
    LEADBILLINGCOUNTY: "",
    LEADBILLINGPOBOX: "",
    AddressOverride: false
  };
  @track mapMarkers = [];

  @track street = "";
  @track city = "";
  @track country = "";
  @track state = "";
  @track poboxcode = "";
  @track county = "";
  @track addressOverride = false;
  @track addressValidate = false;

  @track errorString;
  @track customValidation;
  @track updateRecord = true;
  @track displaySaveButton = false;
  connectedCallback() {
    getCountryCode({})
      .then(result => {
        console.log("TEST METHOD" + result);
        let objNameValues = [];
        for (let i = 0; i < result.length; i++) {
          objNameValues.push({
            label: result[i],
            value: result[i]
          });
        }
        this.reasonOptions = objNameValues;
      })
      .catch(() => { });
  }

  handleEditAddress(event) {
    this.displayAddress = true;
    this.displayStandardLeadAddress = true;
    this.street = "";
    this.city = "";
    this.state = "";
    this.country = "";
    this.county = "" ;
    this.poboxcode="";
  }

  @wire(getLeadAddress, { recordId: "$recordId" }) leadAddressProp({
    error,
    data
  }) {
    if (data !== undefined) {
      // alert(data);
      console.log(data);

      this.AddressMap.LEADBILLINGSTREET = data.LEADBILLINGSTREET;
      this.AddressMap.LEADBILLINGCITY = data.LEADBILLINGCITY;
      this.AddressMap.LEADBILLINGCOUNTRY = data.LEADBILLINGCOUNTRY;
      this.AddressMap.LEADBILLINGSTATE = data.LEADBILLINGSTATE;
      this.AddressMap.LEADBILLINGPOSTALCODE = data.LEADBILLINGPOSTALCODE;
      this.AddressMap.LEADBILLINGCOUNTY = data.LEADBILLINGCOUNTY;
      this.AddressMap.LEADBILLINGPOBOX = data.LEADBILLINGPOBOX;
      this.AddressMap.AddressOverride = data.AddressOverride;
      this.street =data.LEADBILLINGSTREET;
      this.city = data.LEADBILLINGCITY;
      this.country = data.LEADBILLINGCOUNTRY;
      this.state = data.LEADBILLINGSTATE;
      this.poboxcode = data.LEADBILLINGPOSTALCODE;
      this.county = data.LEADBILLINGCOUNTY;
      console.log("this.street "+this.street
      +" this.country "+ this.country
      +" this.city "+ this.city
      +" this.state "+ this.state
      +" this.county "+ this.county
      );
      if (
        this.AddressMap.AccountBillingState !== undefined ||
        this.AddressMap.AccountBillingState !== ""
      ) {
        this.showBillingState = true;
      }
      this.mapMarkers = [
        {
          location: {
            City: "",
            Country: "",
            PostalCode: this.AddressMap.LEADBILLINGPOSTALCODE,
            State: "",
            Street: ""
          },
          title: "Billing Address"
        }
      ];
      //console.log(this.AddressMap.AccountCity);
    }
    if (error) {
      console.log(error);
    }
  }

  handleChange(event) {
    const field1 = event.target.name;
    if (field1 === "CountryCode") {
      this.country = event.target.value;
    }
    var selectedbillingCountry = this.country;
    console.log("Country Code " + selectedbillingCountry);
    // eslint-disable-next-line no-alert
    //console.log(event.detail.value);
    //this.value = event.detail.value;

    //to render state field
    /*var selectedbillingCountry = this.template.querySelector(
      ".countryCodeClass"
    ).value;*/
    //console.log('selectedbillingCountry@@@ ' + selectedbillingCountry);
    //var countrycode = '';
    this.countrycode = selectedbillingCountry.slice(0, 2);
    //console.log('countrycode@@@@ ' + this.countrycode);
    getStateValues({ countrycodestr: this.countrycode })
      .then(countryStateresult => {
        //console.log('@@@STATE ' + countryStateresult);
        if (countryStateresult.length > 0) {
          this.showBillingState = true;
        } else {
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
      })
      .catch(() => { });
    console.log("Country Code " + selectedbillingCountry);
    console.log("this.country " + this.country);
  }

  handleCancelClick(event) {
    this.displayAddress = false;
    this.displayStandardLeadAddress = false;
    this.showAddressSuggestions = false;
    var logElem1 = this.template.querySelector(".log");
    //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
    logElem1.innerHTML = "";

    this.street = "";
    this.city = "";
    this.country = "";
    this.state = "";
    this.poboxcode = "";
    this.county = "";
  }

  handleCountyValue(event) {
    
    const field = event.target.name;
    /*
    if (field === "BillingCounty") {
      this.county = event.target.value;
    }
    if (typeof this.county === "undefined" || this.county === "") {     
      this.county = "";
      this.AddressMap.LEADBILLINGCOUNTY = "";
    }*/

    if((event.target.value !== "" || typeof this.county === "undefined") && event.target.value !== this.AddressMap.LEADBILLINGCOUNTY){
      this.county = event.target.value;
    }  
    else if(event.target.value === this.AddressMap.LEADBILLINGCOUNTY){
      this.county =  this.AddressMap.LEADBILLINGCOUNTY;
    }  
    this.street =this.AddressMap.LEADBILLINGSTREET;
    this.city = this.AddressMap.LEADBILLINGCITY;
    this.country = this.AddressMap.LEADBILLINGCOUNTRY;
    this.state = this.AddressMap.LEADBILLINGSTATE;
    this.poboxcode = this.AddressMap.LEADBILLINGPOSTALCODE;
    
    this.displaySaveButton = true;

    
  }

  handleSave(event) {
    var logElem1 = this.template.querySelector(".log");
    //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
    logElem1.innerHTML = "";
    this.displaySpinner = true;


    console.log("this.street" + this.street);
    console.log("this.city" + this.city);
    console.log("this.country" + this.country);
    console.log("this.state" + this.state);
    console.log("this.poboxcode" + this.poboxcode);
    console.log("this.county" + this.county);
    console.log("this.county" + this.addressOverride);   

    /*alert("this.street "+this.street
    +" this.country "+ this.country
    +" this.city "+ this.city
    +" this.state "+ this.state
    +" this.county "+ this.county
    );*/

    console.log(event.target.label);
    
   
    /*this.street = event.target.street;
   his.city = event.target.city;
    this.country = event.target.country;
    this.state = event.target.province;
    this.poboxcode = event.target.postalCode;
    this.county = event.target.County; */

    console.log("this.street" + this.street);
    console.log("this.city" + this.city);
    console.log("this.country" + this.country);
    console.log("this.state" + this.state);
    console.log("this.poboxcode" + this.poboxcode);
    console.log("this.county" + this.county);


    /*if (typeof this.street === "undefined" || this.street === "") {
      this.street = "";
    }

    if (typeof this.city === "undefined" || this.city === "") {
      this.city = "";
    }

    if (typeof this.country === "undefined" || this.country === "") {
      this.country = "";
    } /*else {
      this.country = this.country.slice(0, 2);
    }*/
    /*if (typeof this.state === "undefined" || this.state === "") {
      this.state = "";
    }

    if (typeof this.poboxcode === "undefined" || this.poboxcode === "") {
      this.poboxcode = "";
    }

    if (typeof this.county === "undefined" || this.county === "") {
      this.county = "";
    }*/
    


    console.log("Validate and save");
    //Validate and Save
    let dataToValidate = {
      BillingStreet: this.street,
      BillingPostalCode: this.poboxcode,
      BillingCity: this.city,
      BillingCountry: this.country,
      BillingState: this.state,
      BillingCounty: this.county,
      AccountName: "Company Name",
      BillingPoBox: this.poboxcode,
      BillingProvince: ""
    };
    console.log('dataToValidate'+dataToValidate);
    console.log(this.addressOverride);
    if(this.addressOverride === true){
      this.addressOverride = true;
      this.addressValidate = true;
    }
    else{
      this.addressOverride = false;
      this.addressValidate = false;
    }
    //if (this.addressOverride === true) {
      // alert('ALERT INSIDE Override'+this.addressOverride);
      console.log("override address");
      const recordInputOvr = {
        fields: {
          Id: this.recordId,
          County__c: this.county,
          Address_Validate__c: this.addressValidate,
          City: this.city,
          Street: this.street,
          PostalCode: this.poboxcode,
          Country: this.country,
          State: this.state,
          Address_Override__c: this.addressOverride
        }
      };
      console.log("recordInput **" + recordInputOvr);
      updateRecord(recordInputOvr)
        .then(() => {
          
          this.AddressMap.LEADBILLINGSTREET = recordInputOvr.fields.Street;
          this.AddressMap.LEADBILLINGCITY = recordInputOvr.fields.City;
          this.AddressMap.LEADBILLINGCOUNTRY = recordInputOvr.fields.Country;
          this.AddressMap.LEADBILLINGSTATE = recordInputOvr.fields.State;
          this.AddressMap.LEADBILLINGPOSTALCODE = recordInputOvr.fields.PostalCode;
          this.AddressMap.LEADBILLINGCOUNTY = recordInputOvr.fields.County__c;
          // this.AddressMap.LEADBILLINGPOBOX = recordInputOvr.fields.PostalCode;
          this.AddressMap.AddressOverride = recordInputOvr.fields.Address_Override__c;
          this.mapMarkers = [
            {
              location: {
                City: "",
                Country: "",
                PostalCode: recordInputOvr.fields.PostalCode,
                State: "",
                Street: ""
              },
              title: "Billing Address"
            }
          ];

          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "Lead address updated",
              variant: "success"
            }),
            (this.fieldErrorCheck = false),
            (this.displaySpinner = false)
          );
          this.logElem1 = "";
          this.addressOverride = false;
          this.displayAddress = false;
          this.displayStandardLeadAddress = false;
          this.displaySaveButton = false;
        })
        .catch(error => {
          if (error.body.output.errors[0].message !== "") {
            this.customValidation = error.body.output.errors[0].message;
            console.log("ERROR");
            this.logElem1 = this.template.querySelector(".customValidation");

            logElem1.innerHTML = this.customValidation;
            this.addressOverride = true;
          }
          console.log("ERROR" + error);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error Updating Lead Address",
              message: error.body.message,
              variant: "error"
            })
          );

          this.displaySpinner = false;
          this.addressOverride = true;
        });
    //} 
    /* start of else else {
      console.log('ALERT INSIDE VALIDATE'+this.addressOverride);
      validateAddress({ validateAddressParam: dataToValidate })
        .then(result => {
          this.updateRecord = true;
          console.log(result);
          console.log(result);
          //alert(result[0]);
          //alert(result[1]);
        

          if(result[1] !== ""){
            this.county = result[1];
          }      
          //alert('VALIDATE ADDRESS');
          var validateError = false;
          //alert(result[0]);
          //alert(result[1]);
          for (let i = 0; i < result.length; i++) {
            //alert(result[i]);
          
            if (result[i].includes("The specified address may not be valid") || 
            result[i].includes("The specified address is not valid")) {
              this.showAddressSuggestions = true;
              this.updateRecord = false;
              this.validateError = true;
              this.errorString = result[i];
              //alert(this.errorString);
              this.logElem1 = this.template.querySelector(".log");
              //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
              logElem1.innerHTML = this.errorString;

              this.displaySpinner = false;
              this.displayAddress = true;
              
              //alert(this.updateRecord);
            } 
            
           

          }
          if(this.updateRecord === true){
            //alert("this.updateRecord"+this.updateRecord);
            const recordInput = {
              fields: {
                Id: this.recordId,
                County__c: this.county,
                Address_Validate__c: false,
                City: this.city,
                Street: this.street,
                PostalCode: this.poboxcode,
                Country: this.country,
                State: this.state,
                Address_Override__c: this.addressOverride
              }
            };
            console.log('recordInput'+recordInput);
            updateRecord(recordInput)
              .then(() => {
                
                this.AddressMap.LEADBILLINGSTREET = recordInput.fields.Street;
                this.AddressMap.LEADBILLINGCITY = recordInput.fields.City;
                this.AddressMap.LEADBILLINGCOUNTRY = recordInput.fields.Country;
                this.AddressMap.LEADBILLINGSTATE = recordInput.fields.State;
                this.AddressMap.LEADBILLINGPOSTALCODE = recordInput.fields.PostalCode;
                this.AddressMap.LEADBILLINGCOUNTY = recordInput.fields.County__c;
                this.AddressMap.LEADBILLINGPOBOX = recordInput.fields.PostalCode;
                this.mapMarkers = [
                  {
                    location: {
                      City: "",
                      Country: "",
                      PostalCode: recordInput.fields.PostalCode,
                      State: "",
                      Street: ""
                    },
                    title: "Billing Address"
                  }
                ];
  
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Success",
                    message: "Lead address updated",
                    variant: "success"
                  }),
                  this.fieldErrorCheck = false,
                  this.displaySpinner = false
                );
                this.addressOverride = false;
                this.displayAddress = false;
                this.displayStandardLeadAddress = false;
                this.displaySaveButton = false;
              })
              .catch(error => {
                if (error.body.output.errors[0].message !== "") {
                  this.customValidation = error.body.output.errors[0].message;
                  console.log("ERROR");
                  this.logElem1 = this.template.querySelector(
                    ".customValidation"
                  );
  
                  logElem1.innerHTML = this.customValidation;
                }
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Error Updating Lead Address",
                    message: error.body.message,
                    variant: "error"
                  })
                );
                this.displaySpinner = false;
                this.addressOverride = false;
              });
          } 

        }
        )
        .catch(error => {
          if (error.body.output.errors[0].message !== "") {
            this.customValidation = error.body.output.errors[0].message;
            console.log("ERROR");
            this.logElem1 = this.template.querySelector(".customValidation");
            logElem1.innerHTML = this.customValidation;
          }
          console.log(error.message);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error Updating Lead Address",
              message: error.body.message,
              variant: "error"
            })
          );
          this.updateRecord = false;
          this.displaySpinner = false;
          this.addressOverride = false;
        });         
          
          
       
    } end of else */

    //override address
  }

  handleChangeStandardAddress(event) {
    /*alert(event.target.street);
    alert(event.target.city);
    alert(event.target.province);
    alert(event.target.country);
    alert(event.target.postalCode);*/
    console.log(event.target);
    if((typeof event.target.street !== "undefined" || event.target.street !== "") && event.target.street !== this.AddressMap.LEADBILLINGSTREET){
      this.street = event.target.street;
    }
    else if(event.target.street === this.AddressMap.LEADBILLINGSTREET){
      this.street =  this.AddressMap.LEADBILLINGSTREET;
    }

    if((typeof event.target.city !== "undefined"|| event.target.city !== "" )&& event.target.city !== this.AddressMap.LEADBILLINGCITY){
      this.city = event.target.city;
    }
    else if(event.target.city === this.AddressMap.LEADBILLINGCITY){
      this.city =  this.AddressMap.LEADBILLINGCITY;
    }

    if((typeof event.target.country !== "undefined"|| event.target.country !== "" ) && event.target.country !== this.AddressMap.LEADBILLINGCOUNTRY){
      this.country = event.target.country;
    }
    else if(event.target.country === this.AddressMap.LEADBILLINGCOUNTRY){
      this.country =  this.AddressMap.LEADBILLINGCOUNTRY;
    }


    if((typeof event.target.province !== "undefined"|| event.target.province !== "") && event.target.province !== this.AddressMap.LEADBILLINGSTATE){
      this.state = event.target.province;
    }
    else if(event.target.province === this.AddressMap.LEADBILLINGSTATE){
      this.state =  this.AddressMap.LEADBILLINGSTATE;
    }
    
    if((event.target.postalCode !== "undefined"|| event.target.postalCode !== "") && event.target.postalCode !== this.AddressMap.LEADBILLINGPOSTALCODE){
      this.poboxcode = event.target.postalCode;
    }  
    else if(event.target.postalCode === this.AddressMap.LEADBILLINGPOSTALCODE){
      this.poboxcode =  this.AddressMap.LEADBILLINGPOSTALCODE;
    }  

    if((event.target.county !== "" || typeof this.county === "undefined") && event.target.county !== this.AddressMap.LEADBILLINGCOUNTY){
      this.county = event.target.postalCode;
    }  
    else if(event.target.value === this.AddressMap.LEADBILLINGCOUNTY){
      this.county =  this.AddressMap.LEADBILLINGCOUNTY;
    }  
    
   
    this.displaySaveButton = true;

    console.log("this.street "+this.street
    +" this.country "+ this.country
    +" this.city "+ this.city
    +" this.state "+ this.state
    +" this.county "+ this.county
    +" this.poboxcode "+ this.poboxcode
    );
    console.log("this.AddressMap.LEADBILLINGSTREET "+this.AddressMap.LEADBILLINGSTREET
    +" this.AddressMap.LEADBILLINGCITY "+ this.AddressMap.LEADBILLINGCITY
    +" this.AddressMap.LEADBILLINGCOUNTRY "+ this.AddressMap.LEADBILLINGCOUNTRY
    +" this.AddressMap.LEADBILLINGSTATE "+ this.AddressMap.LEADBILLINGSTATE
    +"this.AddressMap.LEADBILLINGPOSTALCODE "+ this.AddressMap.LEADBILLINGPOSTALCODE
    );
    
    //this.county = "";
    /*if (this.street === "undefined" || this.street === "") {
      this.AddressMap.LEADBILLINGSTREET = "";
      this.street = ""
      //alert(this.street);
    }
    if (this.city === "undefined" || this.city === "") {
      this.AddressMap.LEADBILLINGCITY = "";
      this.city = ""
      //alert(this.street);
    }
    if (this.country === "undefined" || this.country === "") {
    this.AddressMap.LEADBILLINGCOUNTRY = "";
    this.country = ""
     //alert(this.street);
    } 
    if (this.state === "undefined" || this.state === "") {
      this.AddressMap.LEADBILLINGSTATE = "" ;
      this.state = ""
      //alert(this.street);
    }

    if (this.poboxcode === "undefined" || this.poboxcode === "") {
      this.AddressMap.LEADBILLINGPOSTALCODE = "";
      this.poboxcode = ""
      //alert(this.street);
    }*/
   /* if ((typeof this.street === "undefined" || this.street === "" ) && this.AddressMap.LEADBILLINGSTREET !== "") {     
      this.street = this.AddressMap.LEADBILLINGSTREET;
    }    
    if ((typeof this.city === "undefined" || this.city === "") && this.AddressMap.LEADBILLINGCITY !== ""){     
      this.city = this.AddressMap.LEADBILLINGCITY;
    }
    if ((typeof this.country === "undefined" || this.country === "") && this.AddressMap.LEADBILLINGCOUNTRY !== ""){     
      this.country = this.AddressMap.LEADBILLINGCOUNTRY;
    }
    if ((typeof this.state === "undefined" || this.state === "")&& this.AddressMap.LEADBILLINGSTATE !== "") {     
      this.state = this.AddressMap.LEADBILLINGSTATE;
    }
    if ((typeof this.county === "undefined" || this.county === "")&& this.AddressMap.LEADBILLINGPOSTALCODE !== "") {     
      this.poboxcode =  this.AddressMap.LEADBILLINGPOSTALCODE;
    }*/
    
   

  }

  handleAddressOverride(event) {
    this.addressOverride = event.target.checked;

    //alert(this.addressOverride);
  }

  handleValidateAddress(event){  
    
    this.displaySpinner = true; 

    this.street =this.AddressMap.LEADBILLINGSTREET;
    this.city = this.AddressMap.LEADBILLINGCITY;
    this.country = this.AddressMap.LEADBILLINGCOUNTRY;
    this.state = this.AddressMap.LEADBILLINGSTATE;
    this.poboxcode = this.AddressMap.LEADBILLINGPOSTALCODE;
    this.county = this.AddressMap.LEADBILLINGCOUNTY;
  
    
    console.log("INSIDE VALIDATE ADDRESS BTN ");
    console.log("this.street" + this.street);
    console.log("this.city" + this.city);
    console.log("this.country" + this.country);
    console.log("this.state" + this.state);
    console.log("this.poboxcode" + this.poboxcode);
    console.log("this.county" + this.county);
    console.log("this.county" + this.addressOverride);  
    
    let dataToValidate = {
      BillingStreet: this.street,
      BillingPostalCode: this.poboxcode,
      BillingCity: this.city,
      BillingCountry: this.country,
      BillingState: this.state,
      BillingCounty: this.county,
      AccountName: "Company Name",
      BillingPoBox: this.poboxcode,
      BillingProvince: ""
    };

    validateAddress({ validateAddressParam: dataToValidate })
        .then(result => {
          this.updateRecord = true;
          console.log(result);
          console.log(result);
          //alert(result[0]);
          //alert(result[1]);
        

          if(result[1] !== ""){
            this.county = result[1];
          }      
          //alert('VALIDATE ADDRESS');
          var validateError = false;
          //alert(result[0]);
          //alert(result[1]);
          for (let i = 0; i < result.length; i++) {
            //alert(result[i]);
          
            if (result[i].includes("The specified address may not be valid") || 
            result[i].includes("The specified address is not valid")) {
              //this.showAddressSuggestions = true;
              this.updateRecord = false;
              //this.validateError = true;
              this.errorString = result[i];
              //alert(this.errorString);
             /* this.logElem1 = this.template.querySelector(".log");
              //logElem.innerHTML = wrapper.getElementsByTagName('ul') + "<br/>";
              logElem1.innerHTML = this.errorString;*/

              this.displaySpinner = true;
              this.displayAddress = false;
              
              //alert(this.updateRecord);
            } 
            
            /*else {
              /*alert(result[1]);
              if(result[1] !== ''){
                this.county = result[1];
              }
              //alert(this.updateRecord);
              this.updateRecord = true;
              this.county = result[1];
              //this.street = result[2];
              //this.city = result[3];
              //this.state = result[4];
              //this.poboxcode = result[5];
              //this.country = result[6];
            }*/

          }
          //if(this.updateRecord === true){
            //alert("this.updateRecord"+this.updateRecord);
            const recordInput = {
              fields: {
                Id: this.recordId,
                County__c: this.county,
                Address_Validate__c: this.updateRecord,
                City: this.city,
                Street: this.street,
                PostalCode: this.poboxcode,
                Country: this.country,
                State: this.state,
                Address_Override__c: this.addressOverride
              }
            };
            console.log('recordInput'+recordInput);
            updateRecord(recordInput)
              .then(() => {
                
                this.AddressMap.LEADBILLINGSTREET = recordInput.fields.Street;
                this.AddressMap.LEADBILLINGCITY = recordInput.fields.City;
                this.AddressMap.LEADBILLINGCOUNTRY = recordInput.fields.Country;
                this.AddressMap.LEADBILLINGSTATE = recordInput.fields.State;
                this.AddressMap.LEADBILLINGPOSTALCODE = recordInput.fields.PostalCode;
                this.AddressMap.LEADBILLINGCOUNTY = recordInput.fields.County__c;
                this.AddressMap.LEADBILLINGPOBOX = recordInput.fields.PostalCode;
                this.mapMarkers = [
                  {
                    location: {
                      City: "",
                      Country: "",
                      PostalCode: recordInput.fields.PostalCode,
                      State: "",
                      Street: ""
                    },
                    title: "Billing Address"
                  }
                ];
  
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Success",
                    message: "Lead address updated",
                    variant: "success"
                  }),
                  this.fieldErrorCheck = false,
                  this.displaySpinner = false
                );
                this.addressOverride = false;
                this.displayAddress = false;
                this.displayStandardLeadAddress = false;
              })
              .catch(error => {
                if (error.body.output.errors[0].message !== "") {
                  this.customValidation = error.body.output.errors[0].message;
                  console.log("ERROR");
                  this.logElem1 = this.template.querySelector(
                    ".customValidation"
                  );
  
                  logElem1.innerHTML = this.customValidation;
                }
                this.dispatchEvent(
                  new ShowToastEvent({
                    title: "Error Updating Lead Address",
                    message: error.body.message,
                    variant: "error"
                  })
                );
                this.displaySpinner = false;
                this.addressOverride = false;
              });
          //} 

          

        }
        )
        .catch(error => {
          if (error.body.output.errors[0].message !== "") {
            this.customValidation = error.body.output.errors[0].message;
            console.log("ERROR");
            this.logElem1 = this.template.querySelector(".customValidation");
            logElem1.innerHTML = this.customValidation;
          }
          console.log(error.message);
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Error Updating Lead Address",
              message: error.body.message,
              variant: "error"
            })
          );
          this.updateRecord = false;
          this.displaySpinner = false;
          this.addressOverride = false;
        });   
        

  }
}