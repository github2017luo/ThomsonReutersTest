import { CurrentPageReference } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { LightningElement, api, track, wire } from 'lwc';
import getAssetLineItems from '@salesforce/apex/ESC_AssociateAssetLWCController.getAssetLineItems';
import { NavigationMixin } from 'lightning/navigation';
import fatchPickListValue from '@salesforce/apex/ESC_AssociateAssetLWCController.fatchPickListValue';
import getCaseAssetLineItems from '@salesforce/apex/ESC_AssociateAssetLWCController.getCaseAssetLineItems';
import updateCaseAssetLI from '@salesforce/apex/ESC_AssociateAssetLWCController.updateCaseAssetLI';
import setApprovalFlag from '@salesforce/apex/ESC_AssociateAssetLWCController.setApprovalFlag';
import finishMethod from '@salesforce/apex/ESC_AssociateAssetLWCController.finishMethod';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ESC_ShowAllAssetLineItem extends NavigationMixin(LightningElement) {

    @api recordId;
    @track displaySpinner = true;
    @track data;
    @track errorMsg = '';
    @track columns;
    @track preSelectedRows = [];
    @track preSelectedRows1 = [];
    @track selectedPL;
    @track isAssetLI = true;
    @track isCaseAssetLI = false;
    @track isModifySub = false;
    @track selectPLValue = false;
    selectedRows;
    inputText = '';
    @track recordIds='';
    @track draftValues = [];
    wiredsObjectData;
    
    @wire(fatchPickListValue) stageNameValues;
    //@wire(CurrentPageReference)
    connectedCallback() {


     // if(currentPageReference){
     
     
          //window.console.log('Current Page Reference...'+JSON.stringify(currentPageReference));
         // window.console.log('Current Page Reference...'+JSON.stringify(currentPageReference.state.ws));
          //if(currentPageReference.state.ws!=null && currentPageReference.state.ws!=''){
            //this.recordId=JSON.stringify(currentPageReference.state.ws).substring(19, 37);

          //}
     
     console.log('hello'+this.recordId);
     getAssetLineItems({ caseId:this.recordId})
    .then(result => {
	  this.errorMsg = '';
      this.data = '';
      this.columns  = '';
      if(result!=null){
      console.log('@@ columns :' + JSON.stringify(this.columns));
        console.log('@@ data :' + JSON.stringify(this.data));
        console.log('@@ errorMsg :' + result.errorMsg);
			if((result.errorMsg == null || result.errorMsg == '') && result.sobjList != ''){
			  this.data = result.sobjList;
			  this.columns = result.ldwList;
			  console.log('@@ columns :' + JSON.stringify(this.columns));
			  console.log('@@ data :' + JSON.stringify(this.data));
			  
			}else if((result.errorMsg!=null || result.errorMsg!='') && result.sobjList!=''){
			  console.log(' errorMsg : ' + result.errorMsg);
		  
        this.data = result.sobjList;
			  this.columns = result.ldwList;
			  this.errorMsg = result.errorMsg;
			}else{

        this.errorMsg = result.errorMsg;
      }
  }
  this.displaySpinner = false;
  })
  .catch(error => {
      console.log('-------error-------------'+error);
      this.displaySpinner = false;
  });
     }
    //}        
    
    



  getSelectedName(event) {
    const selectedRows = event.detail.selectedRows;
    this.selectedRows  = selectedRows;
    let selectedRecords = [];
    this.displaySpinner = false;
    //let selectedRecordsLst = [];
    // Display that fieldName of the selected rows
    console.log(' $$$$$$ You selected: '+ JSON.stringify(this.selectedRows));
    if(this.selectedRows != null){
        for (let i = 0; i < selectedRows.length; i++){
            selectedRecords.push(selectedRows[i].Id);
            //selectedRecordsLst.push(selectedRows);
            
          }

    }
    console.log('You selected: '+ JSON.stringify(selectedRecords));
    this.preSelectedRows = selectedRecords;
    //this.preSelectedRowsLst = selectedRecordsLst;
    console.log('selected rows : ' + selectedRows);
    if(this.preSelectedRows == null || selectedRows ==null){
        this.errorMsg = 'Please select atleast one record';
        return;

    }
   
}

getSelectedRow(event){

    const selectedRows = event.detail.selectedRows;
    this.selectedRows  = selectedRows;
    let selectedRecords = [];
    this.displaySpinner=false;
    //let selectedRecordsLst = [];
    // Display that fieldName of the selected rows
    console.log(' $$$$$$ You selected: '+ JSON.stringify(this.selectedRows));
    if(this.selectedRows != null){
        for (let i = 0; i < selectedRows.length; i++){
            selectedRecords.push(selectedRows[i].Id);
            //selectedRecordsLst.push(selectedRows);
            
          }

    }
    console.log('You selected: '+ JSON.stringify(selectedRecords));
    this.preSelectedRows = selectedRecords;
    //this.preSelectedRowsLst = selectedRecordsLst;
    console.log('selected rows : ' + selectedRows);
    if(this.preSelectedRows == null || selectedRows == null){
        this.errorMsg = 'Please select atleast one record';
        return;

    }
}
  handleClick(event) {
    this.displaySpinner = true;
    console.log('@@ preselectedrows : ' + JSON.stringify(this.preSelectedRows));
    if(this.preSelectedRows == null || this.preSelectedRows ==''){
      this.displaySpinner = false;
      this.errorMsg = 'Please select atleast one record';
      return;

  }
    getCaseAssetLineItems({ assetIds: this.preSelectedRows,caseId:this.recordId,value:'none'}) 
    .then(result => {
      this.errorMsg = '';
      this.displaySpinner = false;
      if(result!=null && result.errorMsg!='' && result.errorMsg!=null){
        this.errorMsg = result.errorMsg;
        return;

      }
      if(result!=null && result.sobjList!=null && result.sobjList!=''){
      this.isAssetLI = false;
    this.isCaseAssetLI = true;
    this.selectPLValue = false;
    this.data = result.sobjList;
        this.columns = result.ldwList;
        this.isModifySub = result.isModifySub;
        console.log('@@ columns 1:' + JSON.stringify(this.columns));
      console.log('@@ data 1:' + JSON.stringify(this.data));
      this.preSelectedRows1 = this.preSelectedRows;
      if(!this.isModifySub){
        let my_ids = [];
        for (let i = 0; i < this.data.length; i++){
          my_ids.push(this.data[i].Id);
          //selectedRecordsLst.push(selectedRows);
          
        }
      this.preSelectedRows = my_ids;

      }else{

        this.preSelectedRows = null;
      }
      

      console.log('preSelectedRows:' + this.preSelectedRows);
      }else{
        this.isAssetLI = false;
        this.isCaseAssetLI = true;
        this.errorMsg = 'The selected assets are already associated with case.';
        return;
      }
      //this.displaySpinner = false;
  })
  .catch(error => {
      console.log('-------error-------------'+error);
      this.displaySpinner = false;
      
  });
  }

   onValueSelection(event){
      // eslint-disable-next-line no-alert
      //alert(event.target.value);
      this.value = event.target.value;
      this.selectedPL = this.value;
      this.displaySpinner = true;
      if(this.value !=='---None---'){
        this.selectPLValue = true;

      }
      console.log('-------value-------------'+this.value);
      getCaseAssetLineItems({ assetIds: this.preSelectedRows1,caseId:this.recordId,value:this.value}) 
  .then(result => {
    this.wiredsObjectData = result.sobjList;
    this.isAssetLI = false;
  this.isCaseAssetLI = true;
  
    //this.data = result.sobjList;
      this.columns = result.ldwList;
      //this.isModifySub = result.isModifySub;
      console.log('@@ columns 1:' + JSON.stringify(this.columns));
    console.log('@@ data 1:' + JSON.stringify(this.data));
    this.displaySpinner = false;
})
.catch(error => {
    console.log('-------error-------------'+error);
    this.displaySpinner = false;
    
});
     // alert(event.target.value);
     }

     handleInputChange(event){
      this.inputText = event.detail.value;
      //console.log('inputText : ' +this.inputText);

     }
     handleUpdateClick(event) {
      this.errorMsg='';
      console.log('input Text : ' + this.inputText);
      console.log('preselectedrows : ' + this.preSelectedRows);
      this.displaySpinner = true;
      if(this.selectedPL == null && !this.isModifySub){
        //alert(this.selectedPL);
        //this.handleNavigateToRecord(this.recordId);
      }else{
        if(this.selectedPL == null) {
          this.errorMsg = 'Please Select Operation.';
          this.displaySpinner = false;
          return;
        }
        if(this.inputText == null || this.inputText == '') {
          this.errorMsg = 'Please enter value for PO Number.';
          this.displaySpinner = false;
          return;
        }
        if(this.preSelectedRows == null || this.preSelectedRows ==''){
          this.errorMsg = 'Please Select atleast one Record.';
          this.displaySpinner = false;
          return;

        }
        updateCaseAssetLI({ AssetLIds: this.preSelectedRows1,csAssetIds:this.preSelectedRows,caseId:this.recordId,fieldName:this.selectedPL,value:this.inputText}) 
        .then(result => {
          this.displaySpinner =false;
          this.errorMsg = result.errorMsg;
            console.log('error msg : ' + result.errorMsg);
            this.data = result.sobjList;
            //alert(JSON.stringify(this.data));
           /* if(this.errorMsg == null || this.errorMsg ==''){

                this.handleNavigateToRecord(this.recordId);
            }*/
           
            
        })
        .catch(error => {
            console.log('-------error-------------'+JSON.stringify(error));
            this.displaySpinner = false;
            
        });

      }
     
     }

     handleNavigateToRecord(rowId) {
      // Generate a URL to a User record page
      this.displaySpinner = false;
      var close = true;
      const closeclickedevt = new CustomEvent('closeclicked', {
        detail: { close },
    });

       // Fire the custom event
       this.dispatchEvent(closeclickedevt); 
      console.log('rowId : ' +rowId);
    /* this[NavigationMixin.Navigate]({
          type: 'standard__recordPage',
          attributes: {
              recordId: rowId,
              objectApiName: 'Case',
                actionName: 'view'
          },
      })
      this.isAssetLI = false;
  this.isCaseAssetLI = false;*/
  }

  handleFinishClick(event){

    this.errorMsg='';
    console.log('input Text : ' + this.inputText);
    this.displaySpinner = true;
    if(this.selectedPL == null && !this.isModifySub){
      //alert(this.selectedPL);
      if(this.preSelectedRows == null || this.preSelectedRows ==''){
        this.errorMsg = 'Please Select atleast one Record.';
        this.displaySpinner = false;
        return;

      }
      setApprovalFlag({caseId:this.recordId,assetIds:this.preSelectedRows1,csAssetIds:this.preSelectedRows}) 
        .then(result => {
          this.displaySpinner =false;
          alert('The operation is Successful,Please close the tab');
          var close = true;
      const closeclickedevt = new CustomEvent('closeclicked', {
        detail: { close },
    });
    this.dispatchEvent(closeclickedevt);
          //this.handleNavigateToRecord(this.recordId);
            
        })
        .catch(error => {
            console.log('-------error-------------'+JSON.stringify(error));
            this.displaySpinner = false;
            
        });
      
    }else{
      if(this.selectedPL == null) {
        this.errorMsg = 'Please Select Operation.';
        this.displaySpinner = false;
        return;
      }
      if(this.preSelectedRows == null || this.preSelectedRows ==''){
        this.errorMsg = 'Please Select atleast one Record.';
        this.displaySpinner = false;
        return;

      }
     /* if(this.inputText == null || this.inputText == '') {
        this.errorMsg = 'Please enter value for PO Number.';
        this.displaySpinner = false;
        return;
      }
      if(this.preSelectedRows == null || this.preSelectedRows ==''){
        this.errorMsg = 'Please Select atleast one Record.';
        this.displaySpinner = false;
        return;

      }*/
    finishMethod({ AssetLIds: this.preSelectedRows1,csAssetIds:this.preSelectedRows,caseId:this.recordId,fieldName:this.selectedPL}) 
        .then(result => {
          this.displaySpinner =false;
            
            console.log('error msg : ' + result);
            this.errorMsg = result;
            if(this.errorMsg == null || this.errorMsg ==''){
              alert('The operation is Successful,Please close the tab');
                //this.handleNavigateToRecord(this.recordId);
            }
          
        
        })
        .catch(error => {
            console.log('-------error-------------'+JSON.stringify(error));
            this.displaySpinner = false;
        });
      }
  }
  	//When save method get called from inlineEdit
   /* handleSave(event) {

      var draftValuesStr = JSON.stringify(event.detail.draftValues);
      console.log('@@ draftValuesStr ' + this.draftValuesStr);
      console.log('@@ data ' + this.data);
      updateRecords({ sobList: this.data, updateObjStr: draftValuesStr, objectName: 'ESC_Case_Asset_Line_Item__c' })
      .then(result => {
          
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Success',
                  message: 'Records updated',
                  variant: 'success'
              })
          );
          // Clear all draft values
          this.draftValues = [];
          console.log('@@ wiresSobjectData : ' +JSON.stringify(this.wiredsObjectData));
          return refreshApex(this.wiredsObjectData);
      })
      .catch(error => {
          console.log('-------error-------------'+JSON.stringify(error));
          console.log(error);
      });

  }*/


  
}