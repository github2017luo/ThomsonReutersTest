import { LightningElement,api,track,wire } from 'lwc';
import getResults from '@salesforce/apex/additionalClausesMultiSelectController.getResults';
import getdefaultitems from '@salesforce/apex/additionalClausesMultiSelectController.getdefaultitems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import AdditionalClause_Field from '@salesforce/schema/Apttus_Proposal__Proposal__c.APTS_Add_l_Clauses__c';
//import AdditionalClause_Field from '@salesforce/schema/Account.Description';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import ID_FIELD from '@salesforce/schema/APTS_Additional_Clauses__c.Id';
import { NavigationMixin } from 'lightning/navigation';

export default class MultiSelectLookUpLWC extends  NavigationMixin(LightningElement){
    @api objectName ;
    @api fieldName;
    @api recordid ;
    @api Label;
    @api searchRecords = [];
    @api selectedRecords = [];
    @api required = false;
    @api iconName = 'action:new_account'
    @api LoadingText = false;
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    @track objectInfo;
    @track picklistValues;
    @api allclausesList = [];
    objectdefrecordtypeid;
    isDialogDisplay = true;
    showtopspinner = true;
    showinnerspinner = false;
    @api loadedfromcart = false;

    connectedCallback(){
        this.showtopspinner = false;
        getdefaultitems({ObjectName : 'APTS_Additional_Clauses__c', fieldName: 'APTS_Clause_Title__c', recordid : this.recordid})
        .then(result => {
           
           this.selectedRecords = result.savedresult;
            this.searchRecords = result.searchedresult;
            this.allclausesList = result.searchedresult;
            console.log('allclausesList:'+ this.allclausesList.length);
            console.log('selectedRecords:'+this.selectedRecords.length);
            console.log('this.searchRecords:'+this.searchRecords.length);

        })
        .catch(error => {
            console.log('-------error-------------'+error);
            console.log(error);
            this.showinnerspinner = false;
        });
    }
 
    searchField(event) {

        var currentText = event.target.value;
        console.log('search text: '+currentText);
        //console.log(currentText === "")
        if(currentText === ""){
            this.searchRecords= this.allclausesList;
            this.isDialogDisplay = true;

        }else{
        var selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            selectRecId.push(this.selectedRecords[i].recId);
        }
        this.LoadingText = true;
       this.showinnerspinner = true;
       // console.log('picklistvalues'+picklistValues);
       // console.log('rectype'+this.objectInfo.data.defaultRecordTypeId);
        getResults({ ObjectName: this.objectName, fieldName: this.fieldName, value: currentText, selectedRecId : selectRecId })
        .then(result => {
            this.searchRecords= result;
            this.LoadingText = false;
            this.isDialogDisplay = result.length > 0 ? true: false;
           // this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            if(currentText.length > 0 && result.length == 0) {
                this.messageFlag = true;
            }
            else {
                this.messageFlag = false;
            }

            this.showinnerspinner = false;
         
        })
        .catch(error => {
            console.log('-------error-------------'+error);
            console.log(error);
            this.showinnerspinner = false;
        });
    } 
    }
    
   setSelectedRecord(event) {
    try{
        console.log('setSelectfunction');
        this.showinnerspinner = true;
        var recId = event.currentTarget.dataset.id;
        var selectName = event.currentTarget.dataset.name;
        let selectRecId =  { 'recId' : recId ,'recName' : selectName };
        let newsObject = [];
        newsObject = [...this.selectedRecords,{ 'recId' : recId ,'recName' : selectName }];
       // newsObject.push({ 'recId' : recId ,'recName' : selectName }) ;
        ///{ 'recId' : recId ,'recName' : selectName };
        console.log('1'+JSON.stringify(newsObject));
        //this.selectedRecords.push(newsObject);
        //this.selectedRecords.recId = selectName;
        console.log('2'+JSON.stringify(this.selectedRecords));
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        let selRecords = newsObject;
		this.template.querySelectorAll('lightning-input').forEach(each => {
            each.value = '';
        });
        console.log('3');
        
        this.selectedRecords = newsObject;
        this.searchRecords = this.changelist(this.allclausesList, this.selectedRecords );
        this.showinnerspinner = false;
      
      console.log('searchlist'+ this.searchRecords.length);
        }
        
        catch(err){
            console.log('error'+e.message);
        }
    }

    removeRecord (event){
        this.showinnerspinner = true;
        let selectRecId = [];
        for(let i = 0; i < this.selectedRecords.length; i++){
            if(event.detail.name !== this.selectedRecords[i].recId)
                selectRecId.push(this.selectedRecords[i]);
        }
        this.selectedRecords = [...selectRecId];
        this.searchRecords = this.changelist(this.allclausesList, this.selectedRecords );
        console.log('selected records in remove: '+ this.searchRecords.length);
        this.showinnerspinner = false;
      
    }

    handleSave(event){
        this.showtopspinner = true;
        let concatstring = '';
        for(let i = 0; i < this.selectedRecords.length; i++){
            if(!concatstring.includes(this.selectedRecords[i].recName)){
            concatstring = concatstring + this.selectedRecords[i].recName + ';';
            }
        }
        const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordid;
            fields[AdditionalClause_Field.fieldApiName] = concatstring;

            const recordInput = { fields };

            updateRecord(recordInput)
            .then(() => {
                console.log('success'+this.recordid);
                if(this.loadedfromcart){
                    window.history.back()
                }else{
                    let url = window.location.origin+'/'+this.recordid;
                    window.open(url, "_self"); 
                }
                
            })
            .catch(error => {
                console.log('error'+JSON.stringify(error));
                this.showtopspinner = false;
            });

           }

 handleClose(event){
        try{
            if(this.loadedfromcart){
                window.history.back()
            }else{
                let url = window.location.origin+'/'+this.recordid;
                window.open(url, "_self"); 
            }


    }catch(e){
        console.log('error:'+e.message);
    }

    }

    changelist(fullList, selectedList){

         let fl = [...fullList];
        let sl = [...selectedList];

        try{

       // let fl = fullList;
       // let sl = selectedList;

        for( var i=fl.length - 1; i>=0; i--){
            for( var j=0; j<sl.length; j++){
                if(fl[i] && (fl[i].recId === sl[j].recId)){
                    fl.splice(i, 1);
               }
           }
       }
    }catch(e){
        console.log('error: '+e.message);
    }

       return fl;

    }

     

}