/* eslint-disable no-console */
import { LightningElement,wire,track,api} from 'lwc';
import getApprovals from '@salesforce/apex/ESC_ApprovalProcessLWCController.getApprovals';

export default class ESC_ApprovalProcessPageLWC extends LightningElement {
    @track error;
    @track data ;
    @track flag = false;
    @track sortBy;
    @track sortDirection;
   
    @track columns = [
        {
            label: 'Action',
            fieldName: 'appLinkUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'appLink' }, 
            target: '_self'},
            sortable: false
        },
        {
            label: 'Approval Type',
            fieldName: 'type',
            type: 'text',
            sortable: true
        },
        {
            label: 'Case',
            fieldName: 'caseUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'caseNumber' }, 
            target: '_self'},
            sortable: true
        },
        {
            label: 'Account Name',
            fieldName: 'accountNameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'accountName' }, 
            target: '_self'},
            sortable: true
        },
        {
            label: 'Account Number',
            fieldName: 'accountNumber',
            type: 'text',
            sortable: true
        },
        {
            label: 'Case Owner',
            fieldName: 'ownerNameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'ownerName' }, 
            target: '_self'},
            sortable: true
        },
        {
            label: 'Case Created Date',
            fieldName: 'createdDate',
            type: 'text',
            sortable: true
        },
        {
            label: 'Total Net Price',
            fieldName: 'totNetPrice',
            type: 'text',
            sortable: true
        },
        {
            label: 'Forms',
            fieldName: 'formUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'formName' }, 
            target: '_self'},
            sortable: true
        },
		{
            label: 'Name',
            fieldName: 'nameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'name' }, 
            target: '_self'},
            sortable: true
        },
        {
            label: 'Total Amount',
            fieldName: 'totalAmount',
            type: 'text',
            sortable: true
        },
        {
            label: 'Form Created Date',
            fieldName: 'frmCreatedDate',
            type: 'text',
            sortable: true
        },
        {
            label: 'Segment/Region',
            fieldName: 'segmentregion',
            type: 'text',
            sortable: true
        },
        {
            label: 'Article Classif',
            fieldName: 'articleClass',
            type: 'text',
            sortable: true
        },
        
    ];
   
   @wire(getApprovals)
    wiredOpps(result) {
      if(result!=null){
        if (result.data) {
            this.data = result.data;
             } else if (result.error) {
            this.flag=true;
            this.error = result.error;
        }
       }
        else{
            this.flag=true;
        }
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