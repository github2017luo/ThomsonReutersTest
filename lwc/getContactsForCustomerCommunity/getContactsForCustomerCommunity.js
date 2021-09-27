import { LightningElement,wire,track,api} from 'lwc';
import getContactList from '@salesforce/apex/CustomerCommunityContactsLWCController.getAllContactList';
import {NavigationMixin} from 'lightning/navigation';    
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

export default class GetContactsForCustomerCommunity extends NavigationMixin(LightningElement) {  
    @track data ;
	@track dataser;
    @track errorMsg = '';
    @track flag = false;
    @track flag1 = false;   
    @track flag3 = false;
    @track flag4 = false;
    @track isSearchChangeExecuted = false;  
    @track sortBy;
    @track sortDirection;
    @api record;  
    @api totalNumberOfRows;
    //@track displaySpinner = true;
    @track searchKey;
    rowLimit =25;
    rowOffSet=0;  
    rowLimit1 =25;
    rowOffSet1=0;
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
            type: 'text', 
            fieldName: 'conInactive', 
            sortable: true
        }
    ];
    connectedCallback() {
		getContactList({
            limitSize: this.rowLimit , offset : this.rowOffSet , searchKey : this.searchKey
        })
		.then(result => {
			this.errorMsg = '';
			console.log('33'+result);
			if(result!=null){
				console.log('@@ data :' + JSON.stringify(result));
                    this.data = result;
                    if(result.length <25){
                       this.flag = true;
                        console.log('showing first data table');
                    }
                    else{
                    this.flag1=true;
                     console.log('showing second data table');
                    }
					console.log('entered');	
			}else{
				this.errorMsg = 'No Records Found';
            }
            //this.displaySpinner = false;
		})
		.catch(error => {
			this.data = undefined;
			console.log('error =====> '+JSON.stringify(error));
			if(error) {
				this.errorMsg = error.body.message;
			}
		})
    }
    
    loadMoreData(event) { 
		event.target.isLoading = true;
        this.rowOffSet = this.rowOffSet + this.rowLimit;
        if(this.rowOffSet > 2000){
            event.target.isLoading = false;
            return;
        }
        console.log('searchkeyload--->'+this.searchKey);
        console.log('rowOffSet--->'+this.rowOffSet);
        getContactList({limitSize: this.rowLimit , offset : this.rowOffSet ,searchKey : this.searchKey
        }).then((result) => {
            if (this.data.length >= this.totalNumberOfRows) {
                event.target.enableInfiniteLoading = false;
                this.loadMoreStatus = 'No more data to load';
            } else {
			console.log('Load more Call made');  
            const currentRecord = this.data;
            //Appends new data to the end of the table
            const newData = result; // ** concat data
            this.data = currentRecord.concat(newData); // ** replace data.
            }
            });  
            event.target.isLoading = false;  
    }
	loadMoreData1(event) { 
		event.target.isLoading = true;
        this.rowOffSet1 = this.rowOffSet1 + this.rowLimit1;
        console.log('rowOffSet1--->'+this.rowOffSet1 + this.totalNumberOfRows + this.dataser.length );
        if(this.rowOffSet1 > 2000){
            event.target.isLoading = false;
            return;
        }
        //console.log('rowOffSet1--->'+this.rowOffSet1 + this.totalNumberOfRows + this.dataser.length );
        getContactList({limitSize: this.rowLimit1 , offset : this.rowOffSet1 ,searchKey : this.searchKey
        }).then((result) => {
            if (this.dataser.length >= this.totalNumberOfRows) {
                event.target.enableInfiniteLoading = false;
                this.loadMoreStatus = 'No more data to load';
            } else {
			console.log('Load more Call made');  
            const currentRecord = this.dataser;
            //Appends new data to the end of the table
            const newData = result; // ** concat data
            this.dataser = currentRecord.concat(newData); // ** replace data.
            }
            });
            event.target.isLoading = false;  
    }

   
    
    handleSearchKeyword(event) {
    
    if (event.which == 13){
        this.searchKey = event.target.value; 
    console.log('searchkey : ' + this.searchKey + this.rowOffSet1 + this.rowLimit1);
		getContactList({
            limitSize: this.rowLimit1 , offset : this.rowOffSet1 , searchKey : this.searchKey
        })
		.then(result1 => {
			this.errorMsg = '';
			console.log('33'+result1);
			if(result1!=null){
				console.log('@@ data :' + JSON.stringify(result1));
                    this.dataser = result1;
                    if(result1.length <25){
                       this.flag3 = true;
                       this.flag=false;
                       this.flag1=false;
                       this.flag4=false;
                        console.log('search first data table');
                    }
                    else{
                    this.flag4=true;
                    this.flag1=false;
                    this.flag3=false;
                    this.flag=false;
                     console.log('search second data table');
                    }
					console.log('entered');	
			}else{
				this.errorMsg = 'No Records Found';
            }
            //this.displaySpinner = false;
		})
		.catch(error => {
			this.dataser = undefined;
			console.log('error =====> '+JSON.stringify(error));
			if(error) {
				this.errorMsg = error.body.message;
			}
		})
    } 
    
  }  

    updateColumnSorting(event) {
        console.log('entered for column sorting');
        var fieldName = event.detail.fieldName;
        //console.log('fieldname  ' + fieldName + this.sortDirection);
        if (fieldName == 'contactUrlLink') {
            this.sortBy = 'name';
        }else{this.sortBy = event.detail.fieldName;
        }
       this.sortDirection = event.detail.sortDirection;   
       this.sortData(this.sortBy,this.sortDirection);
       this.sortBy = fieldName;      
   }
   updateColumnSorting1(event) {
    console.log('entered for column sorting');
    var fieldName = event.detail.fieldName;
    //console.log('fieldname  ' + fieldName + this.sortDirection);
    if (fieldName == 'contactUrlLink') {
        this.sortBy = 'name';
    }else{this.sortBy = event.detail.fieldName;
    }
   this.sortDirection = event.detail.sortDirection;   
   this.sortData1(this.sortBy,this.sortDirection);
   this.sortBy = fieldName;      
}
   sortData(fieldName, sortDirection){
    var data3 = JSON.parse(JSON.stringify(this.data));
     var key =(a) => a[fieldName]; 
    //alert(key);
    
    var reverse = sortDirection === 'asc' ? 1: -1;
    data3.sort((a,b) => {
        let valueA = key(a) ? key(a).toLowerCase() : '';
        let valueB = key(b) ? key(b).toLowerCase() : '';
        return reverse * ((valueA > valueB) - (valueB > valueA));
    });
    this.data = data3;
}      

sortData1(fieldName, sortDirection){
    var data3 = JSON.parse(JSON.stringify(this.dataser));
  var key =(a) => a[fieldName]; 
 //alert(key);
 
 var reverse = sortDirection === 'asc' ? 1: -1;
 data3.sort((a,b) => {
     let valueA = key(a) ? key(a).toLowerCase() : '';
     let valueB = key(b) ? key(b).toLowerCase() : '';
     return reverse * ((valueA > valueB) - (valueB > valueA));
 });
 this.dataser = data3;
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