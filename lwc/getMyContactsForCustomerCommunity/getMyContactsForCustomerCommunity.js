import { LightningElement,wire,track,api} from 'lwc';
import getContactList from '@salesforce/apex/CustomerCommunityContactsLWCController.getContact';
import {NavigationMixin} from 'lightning/navigation';    

export default class GetMyContactsForCustomerCommunity extends NavigationMixin(LightningElement) {
    @track error;
    @track data;	
	@track errorMsg = '';
    @track flag = false;
    @track sortBy;
    @track sortDirection;
    @api record;
   
    @track columns = [
        
        {
            label: 'Name',
            fieldName: 'contactUrlLink',
            type: 'url',
            typeAttributes: {label: { fieldName: 'name' },tooltip:{fieldName: 'name'} ,
            target: '_self'},
            sortable: true
        },
        {
            label: 'Title',
            fieldName: 'title',
            type: 'text',
            sortable: true
        },
        {
            label: 'Email',
            fieldName: 'email',
            type: 'text',
            sortable: true
        },
        {
            label: 'Elite Contact Number',
            fieldName: 'eliteContactNumber',
            type: 'text',
            sortable: true
        },
        {
            label: 'Mobile',
            fieldName: 'mobile',
            type: 'text',
            sortable: true
        },
        {
            label: 'Direct phone',
            fieldName: 'directPhone',
            type: 'text',
            sortable: true
        },
        {
            label: 'Extension',
            fieldName: 'extension',
            type: 'text',
            sortable: true
        },
        {
            label: 'Contact Status',
            fieldName: 'conInactive',
            type: 'text',
            sortable: true
        }
    ];   
    connectedCallback() {
		getContactList()
		.then(result => {
			this.errorMsg = '';
			console.log('33'+result);
			if(result!=null){
				console.log('@@ data :' + JSON.stringify(result));
					this.data = result;
					console.log('entered');	
			}else{
				this.errorMsg = 'No Records Found';
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
    updateColumnSorting(event) {
        console.log('entered for column sorting');
       this.sortBy = event.detail.fieldName;
       this.sortDirection = event.detail.sortDirection; 
       this.sortData(this.sortBy,this.sortDirection);       
   }
   sortData(fieldName, sortDirection){
    var data3 = JSON.parse(JSON.stringify(this.data));
    //function to return the value stored in the field
    var key =(a) => a[fieldName]; 
    var reverse = sortDirection === 'asc' ? 1: -1;
    data3.sort((a,b) => {
        let valueA = key(a) ? key(a).toLowerCase() : '';
        let valueB = key(b) ? key(b).toLowerCase() : '';
        return reverse * ((valueA > valueB) - (valueB > valueA));
    });
    this.data = data3;
}

navigateToRecordViewPage(event) {
    this.record = event.detail.row;
    console.log('record : ' + JSON.stringify(this.record));
    console.log('record : ' +this.record.contactUrlLink);
    // View a custom object record.
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.record.contactUrlLink,
            objectApiName: 'Contact', // objectApiName is optional
            actionName: 'view'
        }
    });
}
}