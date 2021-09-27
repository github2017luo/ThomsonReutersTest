({

    showCreateRecordModal: function (component, entityApiName) {
        var createRecordEvent = $A.get("e.force:createRecord");
        var recordId = component.get("v.recordId");
        var myMap = new Map();
        var accountId = '';
        var accountName = '';
        var firstName = '';
        var lastName = '';
        var phone = '';
        var email = '';
        var billingCountry = '';
        var billingstate = '';
        var billingCity = '';
        var billingStreet = '';
        var billingPostalCode = '';
        var billingCountryCode = '';
        var billingStateCode = '';
        var languageReference = '';
        var frozenSegment = '';

        var accountDetailsAction = component.get("c.getAccountDetails");
        accountDetailsAction.setParams({
            "contactId": recordId
        });
        accountDetailsAction.setCallback(this, function (response) {

            if (response.getState() === 'SUCCESS') {
                var accountDetails = response.getReturnValue();
                console.log("accountDetails: " + JSON.stringify(accountDetails));


                for (let key in accountDetails) {

                    myMap.set(key, accountDetails[key]);


                }
                //Fire event
                accountId = myMap.get('ACCOUNTID');
                accountName = myMap.get('ACCOUNTNAME');
                firstName = myMap.get('CONTACTTFIRSTNAME');
                lastName = myMap.get('CONTACTLASTNAME');
                phone = myMap.get('CONTACTPHONE');
                billingCountry = myMap.get('ACCOUNBILLINGCOUNTRY');
                billingstate = myMap.get('ACCOUNBILLINGSTATE');
                billingCity = myMap.get('ACCOUNBILLINGCITY');
                billingStreet = myMap.get('ACCOUNTSTREET');
                billingPostalCode = myMap.get('ACCOUNBILLINGPOSTALCODE');
                billingCountryCode = myMap.get('ACCOUNBILLINGCOUNTRYCODE');
                billingStateCode = myMap.get('ACCOUNBILLINGSTATECODE');
                languageReference = myMap.get('CONTACTLANGUAGEPRESFERENCE');
                email = myMap.get('CONTACTEMAIL');
                frozenSegment = myMap.get('ACCOUNTFROZENSEGMENT');

                component.set("v.leadRecordTypeId", myMap.get('LEADRECORDTYPEID'));

                var leadrecordtye = component.get("v.leadRecordTypeId");

                createRecordEvent.setParams({
                    "entityApiName": entityApiName,
                    "recordTypeId": leadrecordtye,
                    "defaultFieldValues": {
                        "Contact__c": recordId,
                        "Account__c": accountId,
                        "Company": accountName,
                        "FirstName": firstName,
                        "LastName": lastName,
                        "Phone": phone,
                        "Email": email,
                        "Country": billingCountry,
                        "CountryCode": billingCountryCode,
                        "State": billingstate,
                        "StateCode": billingStateCode,
                        "Street": billingStreet,
                        "PostalCode": billingPostalCode,
                        "City": billingCity,
                        "Language_Preference__c": languageReference,
                        "BU_Segment__c": frozenSegment
                    }

                });

                createRecordEvent.fire();

            }
            else if (response.getState() === 'ERROR') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(accountDetailsAction);



    }
})