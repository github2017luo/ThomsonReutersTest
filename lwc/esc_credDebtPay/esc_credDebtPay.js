import { LightningElement,api, track, wire } from 'lwc';
import getCredDebtRecs from '@salesforce/apex/ESC_ReferralAssignmentEngine.uslarLoad';
import processSelected from '@salesforce/apex/ESC_ReferralAssignmentEngine.saveSelectedInvoices';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getExtensionItems from '@salesforce/apex/ESC_ReferralAssignmentEngine.getUpdatedCaseExtensions';
//import customSR from '@salesforce/resourceUrl/customMinifiedDp';
//import {loadStyle} from 'lightning/platformResourceLoader';

const columns=[
    { label: 'DOCNUMBER', fieldName: 'docNumber' },
    { label: 'INV LIST #', fieldName: 'invList' },
    { label: 'POSTINGDATE', fieldName: 'postingDate' },
    { label: 'AMOUNT', fieldName: 'amount' },
    { label: 'SERVICESRENDEREDDATE', fieldName: 'servicesRenderedDate' },
    { label: 'D/C IND', fieldName: 'debitCreditInd' },
    { label: 'NETAR', fieldName: 'netArrers' },
    { label: 'DOCDATE', fieldName: 'docDate' },
    { label: 'DOCT', fieldName: 'doct' },
    { label: 'SHORTDESC', fieldName: 'shortDescription' },
    { label: 'LONGDESCRIPTION', fieldName: 'longDescription' },
    { label: 'BILL DATE', fieldName: 'baselineDate' },
    { label: 'INVOICENO', fieldName: 'addpdfDocId' }
];

const columns1 =[
    { label: 'DOCNUMBER', fieldName: 'docNumber' },
    { label: 'INV LIST #', fieldName: 'invList' },
    { label: 'POSTINGDATE', fieldName: 'postingDate' },
    { label: 'AMOUNT', fieldName: 'amount' },
    { label: 'NEWAMOUNT', fieldName: 'newAmount',editable: true,cellAttributes: { iconName: 'utility:edit',iconPosition:'left' } },
    { label: 'SERVICESRENDEREDDATE', fieldName: 'servicesRenderedDate' },
    { label: 'NETARRERS', fieldName: 'netArrers' },
    { label: 'SHORTDESC', fieldName: 'shortDescription' },
    { label: 'BILL DATE', fieldName: 'baselineDate' }
];

const columns2 =[
    { type: 'button-icon', typeAttributes: { iconName: 'utility:delete', name: 'delete', iconClass: 'slds-icon-text-error slds-icon_xx-small' }, fixedWidth: 50 },
    { label: 'DOCNUMBER', fieldName: 'USL_ODocNumber__c' },
    { label: 'INVOICE NUMBER', fieldName: 'USL_InvListNumber__c' },
    { label: 'DOCT', fieldName: 'USL_ODocType__c' },
    { label: 'AMOUNT', fieldName: 'ESC_Item_Amount__c' },
    { label: 'INPUT AMOUNT', fieldName: 'USL_Input_Amount__c' },
    { label: 'SHORTDESC', fieldName: 'USL_OShortDescription__c' }
];

export default class Esc_credDebtPay extends NavigationMixin(LightningElement) {

    @api caseId;
    @api formid;
    @api apId;
    bgDateData;
    edDateData;
    totalAmount=0.0;
    segmentTax;
    ossd;
    areDetailsVisible;
    showSecond = false;
    showThird = false;

    options = [
        { value: 'Open', label: 'Open' },
    ];
    value = 'Open';

    @track data = [];
    backUpData = [];
    columns = columns;
    @track selection = [];
    selectionBackup = [];
    selectionPer = [];

    data1 = [];
    columns1 = columns1;
    selectedRecords = [];
    draftValues = [];
    totalSelAmount;

    data2 = [];
    columns2 = columns2;
    @track customRecords = [];
    @track keyIndex = 0;

    csFormExtId=null;
    uslTotalAmount = 0;
    recordsToDisplay = [];

    showErrMsg = false;
    errMsg;
    trSearch = [];

    disabledDate = false;
    showSapError = false;
    disableSubmit = false;

    hideSubmit = true;

    connectedCallback(){

        /*
        Promise.all([
            loadStyle(this,customSR)
        ]).then(() =>{console.log('loaded');});
        */

        console.log('columns', columns);
        var today = new Date();
        //this.bgDateData = today.toISOString();
        var ed = new Date();
        ed.setDate(today.getDate() - 365);
        this.bgDateData = ed.toISOString();
        //var td = new Date();
        //td.setDate(today.getDate() + 365);
        this.edDateData = today.toISOString();
        console.log('date  '+today.toISOString());
        console.log('caseId ',this.caseId);
        console.log('formId '+this.formid);
        console.log('appId  '+this.apId);
        getCredDebtRecs({csId:this.caseId,fmId:this.formid,appId:this.apId,dateStatus:true,bDat:null,eDat:null}).then(result =>{
            let resp = JSON.parse(result);
            console.log('resp1',resp);
            if(resp.errors1?.length == 0 && resp.caseextLineItemList1?.length == 0){
            if(resp.caseexteForm.length != 0){
                this.csFormExtId = resp.caseexteForm[0].Id;
                /*
                if(resp.caseexteForm[0] && resp.caseexteForm[0].USL_Total_Amount__c){
                    this.uslTotalAmount = resp.caseexteForm[0].USL_Total_Amount__c;
                }
                */
            }
            this.uslTotalAmount = 0;
            console.log('am '+this.uslTotalAmount);
            this.areDetailsVisible = true;
            this.showThird = false;

            console.log('date '+ this.bgDateData);
            var response = JSON.parse(result);
            console.log('resp',response);
            let trData = [];
            
            //this.data = response.ooResponseopenlist;
            let respList = response.ooResponseopenlist;
            this.segmentTax = response.segTax;
            this.ossd = response.oSSD1;
            let dcInd;
            let tAmount = 0;
            for(let i=0; i<respList.length; i++)
            {
                let deCrInd='';
                if(respList[i].debitCreditInd == 'H')
                {
                    deCrInd='C';
                }
                else if(respList[i].debitCreditInd == 'S'){
                    deCrInd='D';
                }
                tAmount = tAmount+respList[i].amount;

                trData.push({'Id':respList[i].document.docNumber,'docNumber':respList[i].document.docNumber,'invList':respList[i].referencekey,
                             'postingDate':respList[i].postingDate,'amount':respList[i].amount,
                             'servicesRenderedDate':respList[i].servicesRenderedDate,'debitCreditInd':deCrInd,
                            'netArrers':respList[i].netArrers,'docDate':respList[i].docDate,
                            'doct':respList[i].document.type,'shortDescription':respList[i].shortDescription,
                            'longDescription':respList[i].longDescription,'baselineDate':respList[i].baselineDate,
                            'addpdfDocId':respList[i].document.additionalPdfDocumentId,'newAmount':respList[i].amount,
                            'ccode':respList[i].currencycode,'lnum':respList[i].lineNumber,'subItemNumber':respList[i].subItemNumber});
                            
            }
            console.log('trData',trData);
            this.data = trData;
            this.totalAmount = tAmount;
            this.backUpData = trData;
        }
        if(resp.caseextLineItemList1?.length != 0){
            if(resp.caseexteForm?.length != 0){
                this.csFormExtId = resp.caseexteForm[0].Id;
                let extAmount = resp.caseexteForm[0];
                console.log('extAmount',extAmount);
                /*
                if(resp.caseexteForm[0] && resp.caseexteForm[0].USL_Total_Amount__c){
                    this.uslTotalAmount = resp.caseexteForm[0].USL_Total_Amount__c;
                }
                */
                let amount = 0;
                for(let i=0;i<resp.caseextLineItemList1.length; i++){
                    if(resp.caseextLineItemList1[i] && resp.caseextLineItemList1[i].USL_Input_Amount__c){
                        amount = amount + Number(resp.caseextLineItemList1[i].USL_Input_Amount__c);
                    }
                }
                this.uslTotalAmount = amount;
            }
            console.log('am '+this.uslTotalAmount);
            this.data2 = resp.caseextLineItemList1;
            this.areDetailsVisible = false;
            this.showThird = true;
        }
        if(resp.errors1?.length != 0){
            console.log('error reached');
            let msg ='';
            if(resp.errors1?.length != 0){
                for(let i=0; i<resp.errors1.length; i++){
                    msg=msg+resp.errors1[i]+' ';
                }
            }
            /*
            if(resp.resErrors1?.length != 0)
            {
                for(let i=0; i<resp.resErrors1.length; i++){
                    msg=msg+resp.resErrors1[i]+' ';
                }
            }
            */
            this.showSapError=true;
            this.customErrorDialog(msg);
        }

        }).catch(error => {
            console.log('-------error-------------',error);
        })
    }

    handleClick(event){

        /*
        let selectedRecs = this.template.querySelector("lightning-datatable").getSelectedRows();
        let trID=[];
        if(selectedRecs.length !=0)
        {
            for(let i=0; i<selectedRecs.length; i++){
                trID.push(selectedRecs[i].Id)
            }
        }
        */

        let bDate = this.bgDateData;
        let eDate = this.edDateData;
        console.log('bDate', bDate.substring(0,10));
        console.log('eDate', eDate);
        let bModDate = bDate.substring(0,10);
        let eModDate = eDate.substring(0,10);
        getCredDebtRecs({csId:this.caseId,fmId:this.formid,appId:this.apId,dateStatus:false,bDat:bModDate,eDat:eModDate}).then(result => {
            let resp = JSON.parse(result);
            if(resp.errors1.length == 0){
                if(resp.caseexteForm.length != 0){
                    this.csFormExtId = resp.caseexteForm[0].Id;
                    /*
                    if(resp.caseexteForm[0] && resp.caseexteForm[0].USL_Total_Amount__c){
                        this.uslTotalAmount = resp.caseexteForm[0].USL_Total_Amount__c;
                    }
                    */
                }
            console.log('date '+ this.bgDateData);
            var response = JSON.parse(result);
            console.log('resp',response);
            let trData = [];
            //this.data = response.ooResponseopenlist;
            let respList = response.ooResponseopenlist;
            this.segmentTax = response.segTax;
            this.ossd = response.oSSD1;
            let dcInd;
            let tAmount = 0.0;
            for(let i=0; i<respList.length; i++)
            {
                let deCrInd='';
                if(respList[i].debitCreditInd == 'H')
                {
                    deCrInd='C';
                }
                else if(respList[i].debitCreditInd == 'S'){
                    deCrInd='D';
                }
                tAmount = tAmount+respList[i].amount;

                trData.push({'Id':respList[i].document.docNumber,'docNumber':respList[i].document.docNumber,'invList':respList[i].referencekey,
                             'postingDate':respList[i].postingDate,'amount':respList[i].amount,
                             'servicesRenderedDate':respList[i].servicesRenderedDate,'debitCreditInd':deCrInd,
                            'netArrers':respList[i].netArrers,'docDate':respList[i].docDate,
                            'doct':respList[i].document.type,'shortDescription':respList[i].shortDescription,
                            'longDescription':respList[i].longDescription,'baselineDate':respList[i].baselineDate,
                            'addpdfDocId':respList[i].document.additionalPdfDocumentId,'newAmount':respList[i].amount,
                            'ccode':respList[i].currencycode,'lnum':respList[i].lineNumber,'subItemNumber':respList[i].subItemNumber});
            }
            console.log('trData',trData);
            this.data = trData;
            this.totalAmount = tAmount;
            //console.log('assel', JSON.stringify(trID));
            //this.selection = trID;
            this.backUpData = trData;
            this.selection = [];
            this.selectionBackup = [];
        }
        else{
            let msg ='';
            if(resp.errors1.length != 0){
                for(let i=0; i<resp.errors1.length; i++){
                    msg=msg+resp.errors1[i]+' ';
                }
            }
            if(resp.resErrors1.length != 0)
            {
                for(let i=0; i<resp.resErrors1.length; i++){
                    msg=msg+resp.resErrors1[i]+' ';
                }
            }
            
            this.customErrorDialog(msg);
        }
        }).catch(error =>{
            console.log('-------error-------------',error);
            }
        );
    }

    handleNext(event){

        let ocredit = 0;
        let odebit = 0;
        let showPage = true;

        console.log('se', JSON.stringify(this.selection));
        console.log('se1', JSON.stringify(this.selectionBackup));
        let se =[];
        for(let i=0;i<this.selection.length; i++){
            let filRec = this.backUpData.filter(r =>r['Id'] == this.selection[i])
            if(filRec.length != 0){
                se.push(filRec[0]);
            }
        }
        console.log('sdat1',JSON.stringify(se));
        //let selectedRecs = this.template.querySelector("lightning-datatable").getSelectedRows();
        let selectedRecs = se
        console.log('srec', selectedRecs);
        if(selectedRecs.length == 0)
        {
            showPage = false;
            this.customErrorDialog('No items selected- Please select an Open Debit item');
        }
        else
        {
            this.selectedRecords = selectedRecs;

            for(let i=0;i<selectedRecs.length;i++)
            {
                if(selectedRecs[i].debitCreditInd == 'C')
                {
                    ocredit++;
                }
                if(selectedRecs[i].debitCreditInd == 'D')
                {
                    odebit++;
                }
            }

            if(ocredit > 0 && odebit > 0 && this.segmentTax != this.ossd.BU_Segment__c){
                showPage = false;
                this.customErrorDialog('This Credit Card Payment request cannot be processed with the selection of open credits. Please de-select these items and select only open debit item.');
            }
            else if(ocredit > 0 && odebit == 0 && this.segmentTax != this.ossd.BU_Segment__c){
                showPage = false;
                this.customErrorDialog('This Credit Card Payment request cannot be processed with the selection of open credits. Please de-select these items and select open debit item.');
            }
            else if(this.segmentTax == this.ossd.BU_Segment__c){
                this.customErrorDialog('Payment cannot be processed because the line items selected equal a credit balance.')
            }
        }
        if(showPage == true){
            this.areDetailsVisible = false;
            this.showSecond = true;
            this.data1 = this.selectedRecords;
            let amount = 0;
            for(let i=0; i<this.selectedRecords.length; i++){
                amount = amount+Number(this.selectedRecords[i].newAmount);
            }
            this.totalSelAmount = amount;
        }       
    }

    customErrorDialog(msg){

        console.log('reached1');
        console.log('reached1 msg', msg);
        /*
        const evt = new ShowToastEvent({
            title: 'Error',
            message: msg,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
        */
        this.showErrMsg = true;
        this.errMsg = msg;
    }

    handleBack(event){
        this.areDetailsVisible = true;
        this.showSecond = false;
        this.totalSelAmount = 0;
        this.showErrMsg = false;
        this.data = this.backUpData;
        this.selection = this.selectionBackup;
    }

    handleSave(event){
        let dfValues = event.detail.draftValues;
        console.log('dfvalues',dfValues);
        let updatedData = this.data1;
        let customData = this.customRecords;
        if(dfValues.length != 0){
            for(let i=0; i<dfValues.length;i++){
                for(let j=0; j<updatedData.length;j++){
                    if(updatedData[j].Id == dfValues[i].Id){
                        updatedData[j].newAmount = dfValues[i].newAmount;
                    }
                }
            }
        }
        console.log('updated Data', updatedData);
        
        let amount = 0;
        for(let i=0; i<updatedData.length; i++){
            amount = amount+Number(updatedData[i].newAmount);
        }
        if(customData.length != 0){
            for(let i=0; i<customData.length; i++){
                if(customData[i].amount != ''){
                    amount = amount+Number(customData[i].amount);
                }
            }
        }
        this.totalSelAmount = amount;
        
        this.draftValues = [];
        this.hideSubmit = true;
    }

    rowSelection(event){
        this.showErrMsg = false;

        
        console.log('test', event.detail);
        let trID = [];
        let utrID  = [];
        let allSelectedRows = this.selection;
        let allFilterSelectedRows = this.selection;
        let selectedRecs = this.template.querySelector("lightning-datatable").getSelectedRows();

        let selectedIds = selectedRecs.map(row => row.Id);
            console.log('Ids',selectedIds);
            let unselectedRows = this.data.filter(row => !selectedIds.includes(row.Id));
            console.log('unse '+JSON.stringify(unselectedRows));
            let unselectedIds = unselectedRows.map(row => row.Id);
            console.log('unselectedIds',unselectedIds);

        if(selectedRecs.length !=0)
        {
            if(this.searchKey == null){
                console.log('row reached')
                for(let i=0; i<selectedRecs.length; i++)
                {
                    trID.push(selectedRecs[i].Id);
                }
            }
            else
            {
                for(let i=0; i<selectedRecs.length;i++)
                {
                    let filterRecs = allSelectedRows.filter(r => r == selectedRecs[i].Id);
                    if(filterRecs.length == 0){
                        trID.push(selectedRecs[i].Id);
                    }
                }
                trID.push(...allSelectedRows);
                console.log('tr '+JSON.stringify(trID));
            }
            //this.selection = trID;
            //this.selectionBackup = trID;
            //let utrID  = [];
            if(trID.length != 0){
                for(let i=0; i<trID.length; i++){
                    let filterRows = unselectedIds.filter(r => r == trID[i]);
                    if(filterRows.length == 0)
                    {
                        utrID.push(trID[i]);
                    }
                }
            }
            
            this.selection = utrID;
            this.selectionBackup = utrID;
            console.log('urows', utrID);
            console.log('rsel '+ JSON.stringify(this.selection));
        }

        if(trID.length == 0)
        {
            console.log('unselected status');
            for(let i=0;i<allFilterSelectedRows.length;i++){
                let filtRows = unselectedIds.filter(r => r == allFilterSelectedRows[i]);
                if(filtRows.length == 0){
                    utrID.push(allFilterSelectedRows[i]);
                }
            }

            this.selection = utrID;
            this.selectionBackup = utrID;
            console.log('urows', utrID);
            console.log('rsel '+ JSON.stringify(this.selection));
        }
    }

    handleDateChange(event){
        if(event.target.name == 'bgDate'){
            this.bgDateData = event.target.value;
            //this.disabledDate = false;
            //this.showErrMsg = false;
        }
        if(event.target.name == 'edDate'){
            this.edDateData = event.target.value;
            
            //this.disabledDate = false;
            //this.showErrMsg = false;
        }

        var today = new Date();
        //var selDate = event.target.value;
        var selDate = this.edDateData;
        var toDate = today.toISOString();

        var formatToDate = toDate.substring(0,10);
        var toNum = selDate.split('-');
        var formNum = formatToDate.split('-');
        console.log('s1', selDate);
        console.log('s2', toDate);
        var dateOne = new Date(formNum[0], formNum[1], formNum[2]);   
        var dateTwo = new Date(toNum[0], toNum[1], toNum[2]);
        console.log('d1',dateOne);
        console.log('d2',dateTwo);
        if(dateTwo > dateOne)
        {
            this.showErrMsg = true;
            this.customErrorDialog('Future Dates cannot be allowed');
            this.disabledDate = true;
        }
        else{

            this.disabledDate = false;
            this.showErrMsg = false;
            this.dateRangeChecker();
        }
        
        
    }

    dateRangeChecker(){

        let date1 = new Date(this.bgDateData);
        let date2 = new Date(this.edDateData);
        
        let fmResult = Math.abs(date2.getTime() - date1.getTime());
        console.log('result', fmResult);
        var differDays = Math.ceil(fmResult / (1000 * 3600 * 24)); 
        console.log('days', differDays);
        if(differDays > 365){
            this.showErrMsg = true;
            this.customErrorDialog('Date Range cannot more than one year');
            this.disabledDate = true;
        }
        else{
            this.disabledDate = false;
            this.showErrMsg = false;
        }
    }

    handleRow(event){
        if(this.customRecords.length == 0) {
            console.log('Row reached');
            this.keyIndex+1;
            this.customRecords.push({billDoc:'',amount:'',lineNumber:'',refNumber:'',deInd:'',netar:'',sDec:'',bDate:''});
            this.disableSubmit = true;
        }
        else{
            console.log('second row '+JSON.stringify(this.customRecords[0]));
            if(this.customRecords[this.customRecords.length -1].billDoc != ''){
                this.disableSubmit = true;
                this.keyIndex+1;
                this.customRecords.push({billDoc:'',amount:'',lineNumber:'',refNumber:'',deInd:'',netar:'',sDec:'',bDate:''});
            }
            else{
                this.customErrorDialog('Billing Doc field should have a value');
            }
        }
        
        
        console.log('rec2 '+JSON.stringify(this.customRecords));
    }

    handleSubmit(event){

        console.log('finalData ',this.data1);
        let customRecs = [];
        for(let i=0;i<this.data1.length; i++)
        {
            this.data1[i].newAmount = Number(this.data1[i].newAmount);
        }
        if(this.customRecords.length != 0){
            for(let i=0;i<this.customRecords.length;i++){
                if(this.customRecords[i].billDoc !=null && this.customRecords[i].billDoc != '')
                {
                    this.customRecords[i].amount = Number(this.customRecords[i].amount);
                    customRecs.push(this.customRecords[i]);
                }
                
            }
        }
        let selData = this.data1;
        let upAmount = this.totalSelAmount + this.uslTotalAmount;
        console.log('finalData ',selData);
        console.log('upAmount ',upAmount);
        console.log('test@ '+JSON.stringify(this.customRecords));
        
        let ossDData = this.ossd;
        processSelected({processData:JSON.stringify(selData),processCustomData:JSON.stringify(customRecs),businessSeg:ossDData.BU_Segment__c,businessSubBu:ossDData.LCRM_Sub_BU__c,caseDatatId:this.caseId,formDataId:this.formid,systemSrcAccNumber:ossDData.Source_System_Account_Number__c,newAmount1:this.totalSelAmount,extFromId:this.csFormExtId,updatedAmount:upAmount}).then(result =>{
            
            this.showSecond = false;
            this.showThird = true;
            let resp = JSON.parse(result);
            console.log('result', resp);

            /*
            this[NavigationMixin.Navigate]({
                "type": "standard__webPage",
                "attributes": {
                    "url": resp.urlString
                }
            });
            */

            window.open(resp.urlString);
            this.data2 = resp.caseextLineItemList2;
          
            this.totalSelAmount = 0;
            this.uslTotalAmount = 0;
            this.customRecords = [];
            this.selection = [];
            this.selectionBackup =[];

        }).catch(error => {
            console.log('-------error-------------',error);
        });
        
    }

    changeHandler(event){
        console.log('handler reached');
        if(event.target.name == 'billDoc'){
            if(event.target.value.length == 0){
                this.customErrorDialog('Billing Doc field should have a value');
                this.disableSubmit = true;
            }
            else{
                this.showErrMsg = false;
                this.disableSubmit = false;
            }
            this.customRecords[event.target.accessKey].billDoc = event.target.value;
        }
        else if(event.target.name == 'amount'){
            this.customRecords[event.target.accessKey].amount = event.target.value;
            this.calculateAmount();
        }
        else if(event.target.name == 'lineNumber'){
            this.customRecords[event.target.accessKey].lineNumber = event.target.value;
        }
        else if(event.target.name == 'refNumber'){
            this.customRecords[event.target.accessKey].refNumber = event.target.value;
        }
        else if(event.target.name == 'deInd'){
            this.customRecords[event.target.accessKey].deInd = event.target.value;
        }
        else if(event.target.name == 'netar'){
            this.customRecords[event.target.accessKey].netar = event.target.value;
        }
        else if(event.target.name == 'doct'){
            this.customRecords[event.target.accessKey].doct = event.target.value;
        }
        else if(event.target.name == 'sDec'){
            this.customRecords[event.target.accessKey].sDec = event.target.value;
        }
        else if(event.target.name == 'bDate'){
            this.customRecords[event.target.accessKey].bDate = event.target.value;
        }
        console.log('crec', this.customRecords);
    }

    removeRow(event){
        
        let count = 0;

        if(this.customRecords.length >= 1){
            this.customRecords.splice(event.target.accessKey,1);
            this.keyIndex-1;
        }

        if(this.customRecords.length != 0)
        {
            for(let i=0; i<this.customRecords.length; i++){
                if(this.customRecords[i].billDoc == ''){
                    count++;
                }
            }

        }
        else{
            this.showErrMsg = false;
            this.disableSubmit = false;
        }
        if(count >=1){
            this.customErrorDialog('Billing Doc field should have a value');
            this.disableSubmit = true;
        }
        else{
            this.showErrMsg = false;
            this.disableSubmit = false;
        }
    }

    calculateAmount(){
        
        this.totalSelAmount = 0;

        let updatedData = this.data1;
        let customData = this.customRecords;

        let amount = 0;
        if(updatedData.length != 0){
            for(let i=0; i<updatedData.length; i++){
                amount = amount+Number(updatedData[i].newAmount);
            }
            
        }
        if(customData.length != 0){
            for(let i=0; i<customData.length; i++){
                console.log('amount '+amount);
                console.log('amount1 '+Number(customData[i].amount));
                amount = amount+Number(customData[i].amount);
            }
        }
        this.totalSelAmount = amount;
        console.log('amount '+ amount);
    }

    handleMain(event){

        this.showThird = false;
        this.areDetailsVisible = true;

        var today = new Date();
        var ed = new Date();
        ed.setDate(today.getDate() - 365);
        this.bgDateData = ed.toISOString();
        this.edDateData = today.toISOString();

        getCredDebtRecs({csId:this.caseId,fmId:this.formid,appId:this.apId,dateStatus:true,bDat:null,eDat:null}).then(result =>{

            let resp = JSON.parse(result);
            if(resp.errors1.length == 0 && resp.resErrors1.length == 0){
                console.log('date '+ this.bgDateData);
            var response = JSON.parse(result);
            console.log('resp',response);
            let trData = [];
            
            //this.data = response.ooResponseopenlist;
            let respList = response.ooResponseopenlist;
            this.segmentTax = response.segTax;
            this.ossd = response.oSSD1;
            let dcInd;
            let tAmount = 0;
            for(let i=0; i<respList.length; i++)
            {
                let deCrInd='';
                if(respList[i].debitCreditInd == 'H')
                {
                    deCrInd='C';
                }
                else if(respList[i].debitCreditInd == 'S'){
                    deCrInd='D';
                }
                tAmount = tAmount+respList[i].amount;

                trData.push({'Id':respList[i].document.docNumber,'docNumber':respList[i].document.docNumber,'invList':respList[i].referencekey,
                             'postingDate':respList[i].postingDate,'amount':respList[i].amount,
                             'servicesRenderedDate':respList[i].servicesRenderedDate,'debitCreditInd':deCrInd,
                            'netArrers':respList[i].netArrers,'docDate':respList[i].docDate,
                            'doct':respList[i].document.type,'shortDescription':respList[i].shortDescription,
                            'longDescription':respList[i].longDescription,'baselineDate':respList[i].baselineDate,
                            'addpdfDocId':respList[i].document.additionalPdfDocumentId,'newAmount':respList[i].amount,
                            'ccode':respList[i].currencycode,'lnum':respList[i].lineNumber,'subItemNumber':respList[i].subItemNumber});
                            
            }
            console.log('trData',trData);
            this.data = trData;
            this.totalAmount = tAmount;
            this.backUpData = trData;
            this.selection = [];
            this.selectionBackup = [];
            this.customRecords = [];
            }

            if(resp.caseextLineItemList1?.length != 0){
                if(resp.caseexteForm?.length != 0){
                    this.csFormExtId = resp.caseexteForm[0].Id;
                    //let extAmount = resp.caseexteForm[0];
                    //console.log('extAmount',extAmount);
                    
                    let amount = 0;
                    for(let i=0;i<resp.caseextLineItemList1.length; i++){
                        if(resp.caseextLineItemList1[i] && resp.caseextLineItemList1[i].USL_Input_Amount__c){
                            amount = amount + Number(resp.caseextLineItemList1[i].USL_Input_Amount__c);
                        }
                    }
                    this.uslTotalAmount = amount;
                }
            }
            
        }).catch();
    }

    callRowAction(event){

        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;  
        if ( actionName === 'delete' ){
            console.log('recId '+recId);
            getExtensionItems({extId:recId}).then(result => {
                console.log(JSON.stringify(result));
                let response = result;
                if(response.length > 0){
                    this.data2 = response;
                }
                else{
                    this.showThird = false;
                    this.areDetailsVisible = true;

                    var today = new Date();
        var ed = new Date();
        ed.setDate(today.getDate() - 365);
        this.bgDateData = ed.toISOString();
        this.edDateData = today.toISOString();

        getCredDebtRecs({csId:this.caseId,fmId:this.formid,appId:this.apId,dateStatus:true,bDat:null,eDat:null}).then(result =>{

            let resp = JSON.parse(result);
            if(resp.errors1.length == 0 && resp.resErrors1.length == 0){
                console.log('date '+ this.bgDateData);
            var response = JSON.parse(result);
            console.log('resp',response);
            let trData = [];
            
            //this.data = response.ooResponseopenlist;
            let respList = response.ooResponseopenlist;
            this.segmentTax = response.segTax;
            this.ossd = response.oSSD1;
            let dcInd;
            let tAmount = 0;
            for(let i=0; i<respList.length; i++)
            {
                let deCrInd='';
                if(respList[i].debitCreditInd == 'H')
                {
                    deCrInd='C';
                }
                else if(respList[i].debitCreditInd == 'S'){
                    deCrInd='D';
                }
                tAmount = tAmount+respList[i].amount;

                trData.push({'Id':respList[i].document.docNumber,'docNumber':respList[i].document.docNumber,'invList':respList[i].referencekey,
                             'postingDate':respList[i].postingDate,'amount':respList[i].amount,
                             'servicesRenderedDate':respList[i].servicesRenderedDate,'debitCreditInd':deCrInd,
                            'netArrers':respList[i].netArrers,'docDate':respList[i].docDate,
                            'doct':respList[i].document.type,'shortDescription':respList[i].shortDescription,
                            'longDescription':respList[i].longDescription,'baselineDate':respList[i].baselineDate,
                            'addpdfDocId':respList[i].document.additionalPdfDocumentId,'newAmount':respList[i].amount,
                            'ccode':respList[i].currencycode,'lnum':respList[i].lineNumber,'subItemNumber':respList[i].subItemNumber});
                            
            }
            console.log('trData',trData);
            this.data = trData;
            this.totalAmount = tAmount;
            this.backUpData = trData;
            }
        }).catch(error =>{
            console.log('-------error-------------',error);
            });
                }

            }).catch(error =>{
                console.log('-------error-------------',error);
                });
        }
    }

    handleCellChange(event){
        console.log('cell change detected');
        this.hideSubmit = false;
    }

    handelCancelChange(event){
        this.hideSubmit = true;
    }

    handleKeyChange1(event){
    
        /*
        let selectedRecs = this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecs.length !=0)
        {
            for(let i=0; i<selectedRecs.length; i++)
            {
                let fres = this.selection.filter(rec => rec == selectedRecs[i].Id);
                if(fres.length == 0){
                    this.trSearch.push(selectedRecs[i].Id);
                }
            }
        }
        console.log('srec',selectedRecs);
        let trID=[];
        */
        //trID.push('5000077441');
    //let trDat = this.trSearch;  
    const searchKey = event.target.value;
    console.log('search key', searchKey);
    console.log('search len', searchKey.length);
    if(searchKey.length > 0){
      
      this.searchKey = searchKey;
      this.recordsToDisplay = this.backUpData.filter(rec => JSON.stringify(rec).toLowerCase().includes(searchKey.toLowerCase()));
      console.log('rec', this.recordsToDisplay);
      this.data = this.recordsToDisplay;
      //this.selection = this.trSearch;
    }
    else{
        this.data = this.backUpData;
        let backId = [];
        for(let i=0;i<this.selectionBackup.length;i++){
            backId.push(this.selectionBackup[i]);
        }
        this.selection = backId;
        console.log('sel1 '+JSON.stringify(this.selection));
    }
    }
}