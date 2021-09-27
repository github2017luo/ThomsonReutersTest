import { LightningElement, api,wire,track } from 'lwc';
import serachAccs from '@salesforce/apex/ESC_onePassUserLWCController.retriveAccs';
//import { NavigationMixin } from 'lightning/navigation';

export default class ESC_onePassUserLWC extends LightningElement {
	@track errorMsg = '';
	strSearchAccName = '';
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

	/* navigateToRecordViewPage() {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.data.Id,
				actionName: 'view'
			}
		});
	}*/

	handleAccountName(event) {
		this.strSearchAccName = event.detail.value;
	}

	handleSearch() {
		this.errorMsg='';
		this.data='';
		if(!this.strSearchAccName) {
			this.errorMsg = 'Please enter OnePass Username to search.';
			this.data = undefined;
			return;
		}
		console.log('3'+this.strSearchAccName);
		serachAccs({strAccName : this.strSearchAccName})
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