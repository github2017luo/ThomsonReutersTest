import { LightningElement , track, api} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import searchrecs from '@salesforce/apex/ESC_contactSearchLWCController.retriveRecs';
import ESC_Name from '@salesforce/label/c.ESC_Name';
import ESC_Account from '@salesforce/label/c.ESC_Account';
import ESC_City from '@salesforce/label/c.ESC_City';
import ESC_State from '@salesforce/label/c.ESC_State';
import ESC_TotalActiveSubscriptions from '@salesforce/label/c.ESC_TotalActiveSubscriptions';
import ESC_ErrorMsg from '@salesforce/label/c.ESC_ErrorMsg';
import ContactResults from '@salesforce/label/c.ESC_ContactResults';




export default class ESC_ContactSearchLWC extends LightningElement {

    label = {
        ESC_Name,
        ESC_Account,
        ESC_City,
        ESC_State,
        ESC_TotalActiveSubscriptions,
        ESC_ErrorMsg,
        ContactResults
    };
   @track displaySpinner = true;
   @track _lastName = '';
   @track _firstName = '';
   @track _email = '';
   @track _phone = '';
   @track _userName = '';
   @track _sapNumber = '';
   @track sortBy;
   @track sortDirection;
   @track errorMsg = '';
   @track data ;
   @track columns  = [
    {
        label: ESC_Name,
        fieldName: 'nameUrl',
        type: 'url',
        typeAttributes: {label: { fieldName: 'name' }, 
        target: '_self'},
        sortable: false
    },
    {
        label: ESC_Account,
        fieldName: 'accnameUrl',
        type: 'url',
        typeAttributes: {label: { fieldName: 'accname' }, 
        target: '_self'},
        sortable: false
    },
    {
        label: ESC_City,
        fieldName:'city',
        type: 'text',
        sortable: false
    },
    {
        label: ESC_State,
        fieldName:'state',
        type: 'text',
        sortable: false
    },
    {
        label: ESC_TotalActiveSubscriptions,
        fieldName:'totalactivesubscriptions',
        type: 'text',
        sortable: false
    }
    
];

@api 
get lastName(){
    return this._lastName;
}

set lastName(val){
    this._lastName = val;
}

@api 
get firstName(){
    return this._firstName;
}

set firstName(val){
    this._firstName = val;
}



@api 
get email(){
    return this._email;
}

set email(val){
    this._email = val;
}

@api 
get phone(){
    return this._phone;
}

set phone(val){
    this._phone = val;
}

@api 
get userName(){
    return this._userName;
}

set userName(val){
    this._userName = val;
}

@api 
get sapNumber(){
    return this._sapNumber;
}

set sapNumber(val){
    this._sapNumber = val;
}
    connectedCallback() {
        this.handleClick(Event);
    }   
   
    
    //Change attribute on Flow
    handleClick(event) {   
        this.errorMsg='';
		this.data='';
		 searchrecs({name : this._firstName+','+this._lastName,emphone : this._email+','+this._phone, sapNumber : this._sapNumber})
		.then(result => {
			//alert('33'+result);
			if(result!=null){
				//alert('4'+result);
               this.data = result;
				console.log('resultdatas'+this.data);
                
			}else{
				this.errorMsg = ESC_ErrorMsg;
			}
            this.displaySpinner = false;
		})
		.catch(error => {
			this.data = undefined;
            this.displaySpinner = false;
			//alert('error =====> '+JSON.stringify(error));
			if(error) {
				this.errorMsg = error.body.message;
			}
		}) 
         
    }

    updateColumnSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection; 
        this.sortData(this.sortBy,this.sortDirection);       
    }
    sortData(fieldName, sortDirection){
     var data1 = JSON.parse(JSON.stringify(this.data));
     //function to return the value stored in the field
     var key =(a) => a[fieldName]; 
     var reverse = sortDirection === 'asc' ? 1: -1;
     data1.sort((a,b) => {
         let valueA = key(a) ? key(a).toLowerCase() : '';
         let valueB = key(b) ? key(b).toLowerCase() : '';
         return reverse * ((valueA > valueB) - (valueB > valueA));
     });
     this.data = data1;
 }
}