import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import retriveAccssd from '@salesforce/apex/ESC_ProdocLWCController.retriveAccssd';
import { CurrentPageReference } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

export default class esc_ProdocKeyCodes extends NavigationMixin(LightningElement){
    @api recordId;
    @track displaySpinner = true;
	@track data1;
	@track data2;
	@track errorMsg = '';
	@track recordIds='';
	@track columns1  = [
		{
			label: 'State',
			fieldName:'state',
			type: 'text',
			fixedWidth: 100,
			sortable: false
		},
		{
			label: 'Release Date',
			fieldName:'releaseDate',
			type: 'date',
			fixedWidth:150,
			sortable: false
		},
		{
			label: 'Install Code',
			fieldName:'installCode',
			type: 'text',
			fixedWidth:250,
			sortable: false
        },
        {
			label: 'Current Release',
			fieldName:'currentRelease',
			type: 'text',
			fixedWidth:150,
			sortable: false
		}
       
	];
    @track columns2  = [
        {
			label: 'State',
			fieldName:'state',
			type: 'text',
			fixedWidth: 100,
			sortable: false
		},
		{
			label: 'Registration Code',
			fieldName:'regCode',
			type: 'text',
			fixedWidth:300,
			sortable: false
		},
		{
			label: 'License Type',
			fieldName:'licenseType',
			fixedWidth:150,
			type: 'text',
			sortable: false
        },
        {
			label: 'Machine ID',
			fieldName:'macId',
			type: 'text',
			fixedWidth:250,
			sortable: false
		},
		
		{
			label: 'Number of Seats',
			fieldName:'seats',
			type: 'text',
			fixedWidth:150,
			sortable: false
        },
		{
			label: 'Expiration Date',
			fieldName:'expirationDate',
			fixedWidth:150,
			type: 'date',
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
				if(result.errorMsgs  == null || result.errorMsgs  == ''){
					this.data1 = result.mainTable;
					this.data2 = result.subTable;
					console.log('entered');	
				}
				else {
					this.errorMsg = result.errorMsgs;
					console.log('entered for error');	
				}
			}else{
				this.errorMsg = 'No Records Found for the SSD Account name!';
			}
			this.displaySpinner = false;
		})
		.catch(error => {
			this.data = undefined;
			this.displaySpinner = false;
			console.log('error =====> '+JSON.stringify(error));
			if(error) {
				this.errorMsg = error.body.message;
			}
		}) 
	}
}