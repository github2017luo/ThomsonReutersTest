import { CurrentPageReference } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { LightningElement, api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retriveAccssd from '@salesforce/apex/ESC_liveNoteLWCController.retriveAccssd';
//import { NavigationMixin } from 'lightning/navigation';

export default class Esc_LiveNoteLicenseCode extends NavigationMixin(LightningElement) {
	@api recordId;
    @track displaySpinner = true;
	@track data;
	@track errorMsg = '';
	@track recordIds='';
	@track columns  = [
		{
			label: 'Code Type',
			fieldName:'licenseDesc',
			type: 'text',
			sortable: false
		},
		{
			label: 'Email Address',
			fieldName:'licenseContact',
			type: 'text',
			sortable: false
		},
		{
			label: 'Issue Date',
			fieldName:'issueDate',
			type: 'date',
			sortable: false
		},
		{
			label: 'License Code',
			fieldName:'keyCode',
			type: 'text',
			sortable: false
        },
        {
			label: 'Tokens Required',
			fieldName:'tokensRequired',
			type: 'boolean',
			sortable: false
		},
		{
			label: 'LiveNote Seats',
			fieldName:'seats',
			type: 'number',
			sortable: false
        },
        {
			label: 'LiveNote WebSeats',
			fieldName:'webSeats',
			type: 'number',
			sortable: false
		},
		{
			label: 'Expiration Date',
			fieldName:'expirationDate',
			type: 'date',
			sortable: false
        },
        {
			label: 'Product Activated',
			fieldName:'productActivated',
			type: 'boolean',
			sortable: false
		}
	];

	connectedCallback() {
		console.log('hello'+this.recordId);
		retriveAccssd({ ssdId:this.recordId})
		.then(result => {
			this.errorMsg = '';
			console.log('33'+result);
			if(result!=null){
				console.log('@@ data :' + JSON.stringify(result));
				if(result[0].errorMsgs  == null || result[0].errorMsgs  == ''){
					this.data = result;
					console.log('entered');	
				}
				else if(result[0].errorMsgs  != null || result[0].errorMsgs  != ''){
					this.errorMsg = result[0].errorMsgs;
					console.log('entered for error');	
				}
				else {
					this.data = result;
					console.log('resultdatas'+this.data);
				}
			}else{
				this.errorMsg = 'No Records Found for the SSD Account name!';
			}
			this.displaySpinner = false;
		})
		.catch(error => {
			this.data = undefined;
			console.log('error =====> '+JSON.stringify(error));
			this.displaySpinner = false;
			if(error) {
				this.errorMsg = error.body.message;
			}
		}) 
	}

}