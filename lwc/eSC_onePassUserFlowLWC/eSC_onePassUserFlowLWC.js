import { LightningElement, api,wire,track } from 'lwc';
import serachAccs from '@salesforce/apex/ESC_onePassUserLWCController.retriveAccs';
//import { NavigationMixin } from 'lightning/navigation';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class ESC_onePassUserFlowLWC extends LightningElement {
	@track errorMsg = '';
	strSearchAccName = '';
    @track _userName = '';
	@track data ;
	@track columns  = [
		{
			label: 'Name',
			fieldName: 'nameUrl',
			type: 'url',
			typeAttributes: {label: { fieldName: 'name' }, 
			target: '_self'},
			sortable: true
		}, 
		{
			label: 'First Name',
			fieldName:'lcrmFirstName',
			type: 'text',
			sortable: false
		},
		{
			label: 'Last Name',
			fieldName:'lcrmLastName',
			type: 'text',
			sortable: false
		},
		{
			label: 'SAP Account Number',
			fieldName:'sapAcctNumber',
			type: 'text',
			sortable: false
		},
		{
			label: 'Phone',
			fieldName:'phone',
			type: 'text',
			sortable: false
		}
	];
    @api 
    get userName(){
        return this._userName;
    }
    
    set userName(val){
        this._userName = val;
    }

    connectedCallback() {
        this.handleSearch();
    }
	/* navigateToRecordViewPage() {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.data.Id,
				actionName: 'view'
			}
		});
	}*/
	
	

	handleSearch() {
		this.errorMsg='';
		this.data='';
		if(!this._userName) {
			this.errorMsg = 'Please enter OnePass Username to search.';
			this.data = undefined;
			return;
		}
		console.log('3'+this._userName);
		serachAccs({strAccName : this._userName})
		.then(result => {
			console.log('33'+result);
			if(result!=null){
				console.log('4'+result.Id);
				this.data = result;
				console.log('resultdatas'+this.data);
			}else{
				this.errorMsg = 'No Records Found for the OnePass Username!';
			}
		})
		.catch(error => {
			this.data = undefined;
			console.log('error =====> '+JSON.stringify(error));
			if(error) {
				this.errorMsg = error.body.message;
			}
		}) 
	}

}