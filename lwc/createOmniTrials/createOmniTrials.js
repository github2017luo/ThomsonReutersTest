import { LightningElement, wire, api, track} from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import showOnlineContacts from '@salesforce/apex/OmniCallToOLCFetchOnlineContacts.showOnlineContacts';
import getProductsList from '@salesforce/apex/OmniDigitalTrialsController.getProductsList';
import { CloseActionScreenEvent } from 'lightning/actions';
import saveTrialAndChildSobjects from '@salesforce/apex/OmniTrialsCreateSobject.saveTrialAndChildSobjects';
import getExistingTrailDetails from '@salesforce/apex/OmniTrialsDetailToWrapper.getExistingTrailDetails';
import getLapsedAccount from '@salesforce/apex/OmniTrialValidation.getLapsedAccount';
import duplicateCheckCallLWC from '@salesforce/apex/OmniTrialDuplicateCheck.duplicateCheckCallLWC';

import getTrialContsWrapFromOLCOnePass from '@salesforce/apex/OmniOnePassOLCCallout.getTrialContsWrapFromOLCOnePass';
import fetchGSIContacts from '@salesforce/apex/OmniDigitalTrialsController.fetchGSIContacts';
import ssdExistingCustomerCheck from '@salesforce/apex/OmniDigitalTrialsController.ssdExistingCustomerCheck';
import fetchOpportunity from '@salesforce/apex/OmniDigitalTrialsController.fetchOpportunity';
import getDigitalBlacklistCompetitorStatus from '@salesforce/apex/OmniTrialValidation.getDigitalBlacklistCompetitorStatus';
import getDigitalDomainCheck from '@salesforce/apex/OmniTrialValidation.getDigitalDomainCheck';
import getOmniTrialsEloquaCallsLWC from '@salesforce/apex/OmniCalltoEloqua.getOmniTrialsEloquaCallsLWC';

import { reduceErrors } from './ldsUtils';
import {omniTrialBlacklistAlertLabel, omniTrialCompetitorAlertLabel, omniTrialDomainBlacklistAlertLabel,OmniTrialLapsedAccountAlertLabel,
    omniTrialSanctionAccountAlertLabel, omniTrialOpptyStageAlertLabel, omniTrialDateValidationAlertLabel,OmniPrimaryContactAlert,
    omniTrialAccountSSDCheckAlert, omniTrialProdctRequiredLabel, omniTrialContactRequiredLabel, omniTrialNoOfDayRequiredLabel,
    OmniEloquaCallSuccessMsg,OmniEloquaCallFailureMsg
} from './omniImportStandardComp';

import {STARTDATE_FIELD,ENDDATE_FIELD,NOOFDAYS_FIELD,ACCOUNT_NAME_FIELD,OPPORTUNITY_NAME_FIELD,TRIAL_STATUS_FIELD,//SOURCE_SYSTEM_FIELD CONTACT_NAME_FIELD,
    TRIAL_ID } from './omniImportStandardComp';

//Custom js class import 
import {showToast} from './omniShowToast';
import {formatDate, digitalCheckStatusBlocked, digitalCompetitorCheck} from './omniCreateHelper';
import {gsiContactsCol, selectedGSIContactsReview, selectedGSIContactsCol, 
    onlineContactColumns, selectedOnlineContsClms, selectedOnlineContsReview, 
    prdcolumns, selectedPrdcolumns, selectedPrdcolumnsReview} from './omniDataTableColumns';

export default class LightningDatatableExample extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName; 
    @track isProductLoaded = false;
    
    @track prdcolumns = prdcolumns();
    @track selectedPrdcolumns = selectedPrdcolumns(); 
    @track selectedPrdcolumnsReview = selectedPrdcolumnsReview();

    @api searchKey = '';
    @track isValidToShowGSIContacts = true;//Omni check whether GSI or Online contacts to be displayed
    
    //selectedTrialContactWrap = []; // in this var, will store Trial Contact Wrapper clas List for selected contact
    
    //to store trial record details and passto apex for record creation
    @track trialRecord = {
        Trial_Start_Date__c :STARTDATE_FIELD,
        Trial_End_Date__c : ENDDATE_FIELD,
        Number_of_Days__c : NOOFDAYS_FIELD,
        Account__c:  ACCOUNT_NAME_FIELD,
        Opportunity__c:  OPPORTUNITY_NAME_FIELD,
        Trial_Status__c:  TRIAL_STATUS_FIELD,
        //Contact_Name__c: CONTACT_NAME_FIELD,
        //Source_System_Detail__c: SOURCE_SYSTEM_FIELD,
        Id: TRIAL_ID
    };

   

    @track isError ;
    
    // non-reactive variables
    refreshGSITable;
    
    @track trailGSIContsToDisplay = []; //Omni - this will store GSI contacts list
    @track trailOnlineContsToDisplay = []; //Omni - this will store GSI contacts list
    @track trailContactsToDisplay = [];//Omni - Both GSI and Online Contacts
    @track trailContactsSelected = [];//Omni - Both GSI and Online Contacts

    @track optySobject = [];//Omni -  store Opty data  
    
    @track trialContTableColumns = []; //Omni - store columns related to Contact display - dyanamic
    @track trialContTableColumnsSeleted = []; //Omni - store columns related to selected Contact dyanamic
    @track selectedRecord=[]; //get Primary contact email for auto selected on UI
    @track selectedPrimaryContName=[]; //get Primary contact Name for auto selected on UI
    //review page and trial console page var
    @track isTrialConsoleSection = true; //Omni
    @track isReviewPage = false; //Omni

    @track isErrorSpinner = false;//show spinner 

    @track accountId = null; //store Account Id used in create COntact section
    @track optyLink = null; 
    @track optyName = null; 
    @track sapAccNum = null;
    @track SSDsapAccNum = null;
    //@track accSanctionedStatus = null;
    //@track optyStage = null;
    connectedCallback(){
        this.isErrorSpinner = true;// start spinner

        this.optyLink = '/' + this.recordId;
        let optyPromise = fetchOpportunity({recordId : this.recordId})
            .then(result => {
                this.optySobject = result;
                
            })
            .catch(error =>{
                console.log(JSON.stringify(error));
                const errorMsg = reduceErrors(error);
                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching Opportunity.'));
            })

        optyPromise.then(()=>{

            console.log('this.optySobject: '+JSON.stringify(this.optySobject));
                    
            this.accountId = this.optySobject.Account.Id;// this is used while creating contact
            this.optyName = this.optySobject.Name;
            this.ssdId = this.optySobject.Source_System_Detail__c;
            this.SSDsapAccNum = null;
            try{
                this.SSDsapAccNum = this.optySobject.Source_System_Detail__r.Source_System_Account_Number__c;
                console.log('SSDsapAccNum: '+this.SSDsapAccNum);
            }catch(err){

            }
            
            var trialLapsedAccountDetails = [];
            var isExistingCustomer = false;
            let getLapsedAccountPromise = getLapsedAccount({accountID : this.SSDsapAccNum})
                .then(result => {
                    trialLapsedAccountDetails = result;
                })
                .catch(error =>{
                    console.log(JSON.stringify(error));
                    const errorMsg = reduceErrors(error);
                    this.dispatchEvent(showToast('error','sticky','Error!','Error While checking Lapsed Account.'));
                })

            let ssdExistingCheckPromise = ssdExistingCustomerCheck({accountId : this.accountId})
                .then(result => {
                    isExistingCustomer = result;
                })
                .catch(error =>{
                    console.log(JSON.stringify(error));
                    const errorMsg = reduceErrors(error);
                    this.dispatchEvent(showToast('error','sticky','Error!','Error While checking Existing Account SSD.'));
                })

                
            getLapsedAccountPromise.then(()=>{
                ssdExistingCheckPromise.then(()=>{
                    var isErrorInInitialCheck = false;
                    
                    if(this.optySobject !== undefined && (this.optySobject.StageName === 'Order Complete' || this.optySobject.StageName === 'Closed Lost')){
                        this.dispatchEvent(showToast('error','sticky','Error!',omniTrialOpptyStageAlertLabel));
                        this.closeQuickAction();
                        this.isErrorInInitialCheck  = true;
                    }
                    else if(this.optySobject != undefined && (this.optySobject.Account.Sanctioned_Status__c === 'Blocked/Denied' || this.optySobject.Account.Sanctioned_Status__c === 'Sanctioned')){
                        this.dispatchEvent(showToast('error','sticky','Error!',omniTrialSanctionAccountAlertLabel));
                        this.closeQuickAction();
                        this.isErrorInInitialCheck  = true;
                    }
                    else if(isExistingCustomer && (this.ssdId === undefined || this.ssdId === null || this.SSDsapAccNum === null || this.SSDsapAccNum === undefined) ){ 
                        this.dispatchEvent(showToast('error','sticky','Error!',omniTrialAccountSSDCheckAlert));
                        this.closeQuickAction();
                        this.isErrorInInitialCheck  = true;
                    }
                    else if(this.optySobject !== undefined && trialLapsedAccountDetails !== null ){//&& trialLapsedAccountDetails.length > 0
                        this.dispatchEvent(showToast('error','sticky','Error!',OmniTrialLapsedAccountAlertLabel +' : '+'Reason Code: '+trialLapsedAccountDetails.lapsedReasonCode+'&& Description: '+trialLapsedAccountDetails.lapsedreasonDesc));
                        //this.dispatchEvent(showToast('error','sticky','Error!',OmniTrialLapsedAccountAlertLabel +' : '+JSON.stringify(trialLapsedAccountDetails)));
                        this.closeQuickAction();
                        this.isErrorInInitialCheck  = true;
                    }
                    
                    if(isErrorInInitialCheck){
                        this.isErrorSpinner = true; //keep starting  
                    }
                    if(!this.isErrorInInitialCheck)
                    {
    
                        let gsiContactPromises = fetchGSIContacts({accId : this.optySobject.Account.Id})
                            .then(result =>{
                                this.refreshGSITable = result;
                                this.trailGSIContsToDisplay = result;   
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                const errorMsg = reduceErrors(error);
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching GSI Contats.'));
                            })
                    
                        let onlineContactPromises = showOnlineContacts({accountID: this.SSDsapAccNum})
                            .then(result =>{
                                this.trailOnlineContsToDisplay = result; 
                            })
                            .catch(error =>{
                                console.log(JSON.stringify(error));
                                const errorMsg = reduceErrors(error);
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching Online Contacts.'));
                            })
    
                        gsiContactPromises.then(() => {
                            onlineContactPromises.then(() => {
                                
                                //-----------------------------------------------------------
                                if(this.trailOnlineContsToDisplay.length > 0){
                                    this.isValidToShowGSIContacts = false;
                                
                                    
                                    this.trialContTableColumns = onlineContactColumns();
                                    this.trialContTableColumnsSeleted = selectedOnlineContsClms();
                                    this.trialContTableColumnsReview = selectedOnlineContsReview();
                                    
                                    
                                    this.trailContactsToDisplay.push(...this.trailOnlineContsToDisplay);
                                }
                                else{
                                    this.isValidToShowGSIContacts = true;
                                    
                                    this.trialContTableColumns = gsiContactsCol();
                                    this.trialContTableColumnsSeleted = selectedGSIContactsCol();
                                    this.trialContTableColumnsReview = selectedGSIContactsReview();
    
                                    this.trailContactsToDisplay.push(...this.trailGSIContsToDisplay);
                                }
    
                                //Lets check here if Saved Trial is available on Opportunity
                                var entTrialsWrap = [];
                                let entTrialPromise = getExistingTrailDetails({trialId : '', optyId : this.recordId, trialStatus : 'Draft'})
                                                    .then(result=>{
                                                        entTrialsWrap = JSON.parse(JSON.stringify(result));
                                                    })
                                                    .catch(error =>{
                                                    console.log(JSON.stringify(error));
                                                    const errorMsg = reduceErrors(error);
                                                    this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching existing Trial Details.'));
                                                    })
                                entTrialPromise.then(()=>{
                                    
    
                                    if(entTrialsWrap != null && entTrialsWrap != undefined){
    
                                        console.log('entTrial:'+JSON.stringify(entTrialsWrap));
                                        
                                        this.trialStartDate = entTrialsWrap.entTrial.Trial_Start_Date__c;
                                        this.NoOfDaysForTrail = entTrialsWrap.entTrial.Number_of_Days__c;
                                        this.trialEndDate = entTrialsWrap.entTrial.Trial_End_Date__c;

                                        this.trialRecord.Id = entTrialsWrap.entTrial.Id;
                                        
                                        this.trailContactsSelected = entTrialsWrap.trialContacts;
                                        this.seletedProductList = entTrialsWrap.trialProducts;
                                        
                                        if(this.seletedProductList){

                                            var tempOppList = [];  
                                            for (var i = 0; i < this.seletedProductList.length; i++) {  
                                                let tempRecord = Object.assign({}, this.seletedProductList[i]); //cloning object  
                                                tempRecord.recordLink = "/" + tempRecord.trialPrdId;

                                                if(tempRecord.baseMaterialNumber !== undefined){
                                                    tempRecord.baseMaterialLink = "/" + tempRecord.baseMaterialNumber;  
                                                }
                                                console.log('tempRecord: '+JSON.stringify(tempRecord));
                                                if(tempRecord.relationshipType === 'Plan to Plan'){
                                                    tempRecord.baseMaterialNumber = null;
                                                    tempRecord.baseMaterialName = null;
                                                    tempRecord.baseMaterialLink = null;
                                                }
                                                tempOppList.push(tempRecord);  
                                            }  
                                            this.seletedProductList = tempOppList;
                                        }

                                        //Primary contact Radio button selection
                                        this.selectedRecord.push(entTrialsWrap.primaryContactEmail);
                                        this.selectedPrimaryContName.push(entTrialsWrap.primaryContactName);
                                        //remove already selected contacts from this.trailContactsToDisplay list
                                        var trailContactsSelectedSaved = JSON.parse(JSON.stringify(this.trailContactsSelected));
                                        var allTrialConts = JSON.parse(JSON.stringify(this.trailContactsToDisplay));
                                        const selectedEmailIds = trailContactsSelectedSaved.map(e => e.email);
                                        let filterResults = allTrialConts.filter(e => !selectedEmailIds.includes(e.email));
                                        this.trailContactsToDisplay = filterResults;
                                        this.trailContactsSelectedTemp = this.trailContactsSelected;

                                        this.isErrorSpinner = false;
                                    }
                                    else{
                                        this.isErrorSpinner = false;
                                    }
                                    
                                });
    
                                
                                
                            });
                        });
                        
                    }                    
                });//end of SSD check
            });//end of Lapsed Account check
        })   
    
    }

    productNameSearch = ''; //Store input search string from LWC

    getProductInput(event){
        this.productNameSearch = event.target.value;
    }
    
    @track searchProductResult = [] ;
    @track seletedProductList =[];
    @track isValidToShowProducts = false;
  
    @track error;
    searchProducts(event){
        this.isProductLoaded=true;
        getProductsList({productName :this.productNameSearch})
        .then(result =>{
            let productData = result;
            console.log('@@@: '+JSON.stringify(productData));
            // Excluding selected products from the search results
            if(this.seletedProductList.length==0){
                this.searchProductResult = productData;
                this.isValidToShowProducts = false;
            }else
            {
                this.isValidToShowProducts = true;
                var selectedProducts = JSON.parse(JSON.stringify(this.seletedProductList));
                var searchProducts = JSON.parse(JSON.stringify(productData));
                const productIds = selectedProducts.map(e => e.trialPrdId);
                let filterResults = searchProducts.filter(e => !productIds.includes(e.trialPrdId));
                this.searchProductResult = filterResults;
               
            }      
            
            if(this.searchProductResult){

                var tempOppList = [];  
                for (var i = 0; i < this.searchProductResult.length; i++) {  
                    let tempRecord = Object.assign({}, this.searchProductResult[i]); //cloning object  
                    tempRecord.recordLink = "/" + tempRecord.trialPrdId;
                    if(tempRecord.baseMaterialNumber !== undefined){
                        tempRecord.baseMaterialLink = "/" + tempRecord.baseMaterialNumber;  
                    }
                    if(tempRecord.relationshipType === 'Plan to Plan'){
                        tempRecord.baseMaterialNumber = null;
                        tempRecord.baseMaterialName = null;
                        tempRecord.baseMaterialLink = null;
                    }
                    tempOppList.push(tempRecord);  
                }  
                this.searchProductResult = tempOppList;
            }

            if(this.searchProductResult.length > 0){
                this.isValidToShowProducts = true;
            }else{
                this.isValidToShowProducts = false;
            }
            this.error = undefined;
            this.isProductLoaded=false;
        })
        .catch(error =>{
            this.error = error;
            this.searchProductResult = [];
            this.isProductLoaded=false;
            console.log('Error Msg:: '+JSON.stringify(error));
            const errorMsg = reduceErrors(error);
             this.dispatchEvent(showToast('error','sticky','Error!','Error while searching products'));
            //show msg toast
        })
        
    }
    
    
    selectedPrd = [];
    handleRowActions(event){
        this.isProductLoaded = true;
        var row = event.detail.row;
        const action = event.detail.action;

        //get List of Product Code
        var selectedProducts = JSON.parse(JSON.stringify(this.seletedProductList));
        const prodCodes = selectedProducts.map(e => e.productCode);
        prodCodes.push(row.productCode);//add current Product Code
        //get List of Email Ids
        var selectedTrialContacts = JSON.parse(JSON.stringify(this.trailContactsSelected));
        const emailIds = selectedTrialContacts.map(e => e.email);
        
        //Trial duplicate check 
        var duplicateCheckResult = [];

        let duplicatePromise = duplicateCheckCallLWC({prodCodes : prodCodes, emailIds : emailIds})
                        .then(result =>{
                            duplicateCheckResult = JSON.parse(JSON.stringify(result));
                        })
                        .catch(error =>{
                        console.log('Error in DUplicate Check: '+JSON.stringify(error));
                        const errorMsg = reduceErrors(error);
                        this.dispatchEvent(showToast('error','sticky','Error!','Error while checking Duplicate Trial.'));
                        }) 

        duplicatePromise.then(()=>{

            if(duplicateCheckResult.length <= 0){
                //var row = event.detail.row;
                //const action = event.detail.action;
                let rows  = JSON.parse(JSON.stringify(this.searchProductResult));
                
                var index = rows.map(x => {
                return x.trialPrdId;
                }).indexOf(row.trialPrdId);
                
                
                rows.splice(index, 1);
                this.searchProductResult = rows;
                
                this.selectedPrd.push(row);
                this.seletedProductList = JSON.parse(JSON.stringify(this.selectedPrd));
            }
            else{
                //error for duplicate 
                let errorDuplicateMsg = duplicateCheckResult[0];
                //let errorDuplicate = JSON.stringify(duplicateCheckResult);
                //errorDuplicate = errorDuplicate.replace(/[["]/g, "");
                //errorDuplicate = errorDuplicate.replace(/["]]/g, "");
                console.log('errorDuplicate:: '+errorDuplicateMsg)
                this.dispatchEvent(showToast('error','dismissible','Error!',errorDuplicateMsg));
            }
            this.isProductLoaded=false;
        })
        
    }

    handleRowRemove(event){
        var row = event.detail.row;
        let rows  = JSON.parse(JSON.stringify(this.seletedProductList));
        
        var index = rows.map(x => {
            return x.trialPrdId;
            }).indexOf(row.trialPrdId);
            
            
        rows.splice(index, 1);
        this.seletedProductList = rows;
        this.selectedPrd = rows;
        this.searchProductResult = [...this.searchProductResult, row];
        if(this.searchProductResult.length > 0){
            this.isValidToShowProducts = true;
        }else{
            this.isValidToShowProducts = false;
        }

    }

    trailContactsSelectedTemp = [];//omni Temp variable to push row
    //Omni Add Row Contact Action
    handleRowAddTrailContact(event){
        this.isErrorSpinner= true;
        var row = event.detail.row;
        
        var isValidEmail = true; //DPS-20337 - scenario 1
        var isValidNotCompetitor = true; //DPS-20337 - scenario 2
        var isValidDomain = true; //DPS-20337 - scenario 3

        var isErrorInDomainCompCheck = false; //Internal check if no error in above 3 scenario, then only call Onepass/Olc
                                
        if(row.email !== undefined && row.email !== null){

            var rowEmailId = row.email;
            var emailIdLower = rowEmailId.toLowerCase();
            var domain = rowEmailId.substring(rowEmailId.lastIndexOf("@") +1);
            let promisess =  getDigitalBlacklistCompetitorStatus({emailId : emailIdLower})
                            .then(result =>{
                                
                               isValidEmail = digitalCheckStatusBlocked(result);
                               isValidNotCompetitor = digitalCompetitorCheck(result);
                               
                            })
                            .catch(error =>{
                                console.log('inside ERROR fun 2: '+JSON.stringify(error));
                                const errorMsg = reduceErrors(error);
                                this.isErrorSpinner= false;
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while checking Digital Black List Competitors.'));
                            })
            let promisesDomain =  getDigitalDomainCheck({domainName : domain})
                             .then(result =>{
                                        
                                if(result === false){
                                    isValidDomain = false;
                                }  
                                    
                              })
                              .catch(error =>{
                                console.log('inside ERROR fun 2: '+JSON.stringify(error));
                                const errorMsg = reduceErrors(error);
                                this.isErrorSpinner= false;
                                this.dispatchEvent(showToast('error','sticky','Error!','Error while checking email Domain.'));
                                })                
          
            promisess.then(() => {
                promisesDomain.then(()=>{

                    if(isValidEmail === false){
                        isErrorInDomainCompCheck = true;
                        this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialBlacklistAlertLabel));
                    }   
                    else if(isValidNotCompetitor === false){
                        isErrorInDomainCompCheck = true;
                        this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialCompetitorAlertLabel));
                    }
                    else if(isValidDomain === false){
                        isErrorInDomainCompCheck = true;
                        this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialDomainBlacklistAlertLabel));
                    }
                    
                    if(isValidEmail === true && isValidNotCompetitor === true && isValidDomain === true){
                        
                        //Duplicate Trial Check
                        //get List of Email Ids and Produc Codes
                        var selectedProducts = JSON.parse(JSON.stringify(this.seletedProductList));
                        const prodCodes = selectedProducts.map(e => e.productCode);
                        var selectedTrialContacts = JSON.parse(JSON.stringify(this.trailContactsSelected));
                        const emailIds = selectedTrialContacts.map(e => e.email);

                        var emailTOcheck = [];
                        emailTOcheck.push(rowEmailId);
                        var duplicateCheckResult = null;
                        let duplicatePromise = duplicateCheckCallLWC({prodCodes : prodCodes, emailIds : emailTOcheck})
                                            .then(result =>{
                                                duplicateCheckResult = JSON.parse(JSON.stringify(result));
                                           })
                                            .catch(error =>{
                                            console.log('Error in DUplicate Check: '+JSON.stringify(error));
                                            const errorMsg = reduceErrors(error);
                                            this.isErrorSpinner= false;
                                            this.dispatchEvent(showToast('error','sticky','Error!','Error while checking Duplicate Trial.'));
                                            }) 

                        duplicatePromise.then(()=>
                        {
                            if(duplicateCheckResult.length <= 0)
                            {
                                //puhs to selected befor
                                let rows  = JSON.parse(JSON.stringify(this.trailContactsToDisplay));
                                var index = rows.map(x => {
                                return x.email;
                                }).indexOf(row.email);
                                
                                rows.splice(index, 1);
                                this.trailContactsToDisplay =JSON.parse(JSON.stringify(rows));
                                this.trailContactsSelectedTemp.push(row);
                                this.trailContactsSelected = JSON.parse(JSON.stringify(this.trailContactsSelectedTemp));
                            }
                            else{

                                //let errorDuplicate = JSON.stringify(duplicateCheckResult);
                                let errorDuplicateMsg = duplicateCheckResult[0];
                                //errorDuplicate = errorDuplicate.replace(/[["]/g, "");
                                //errorDuplicate = errorDuplicate.replace(/["]]/g, "");          
                                console.log('errorDuplicate:: '+errorDuplicateMsg)
                                this.dispatchEvent(showToast('error','dismissible','Error!',errorDuplicateMsg));
                                //this.dispatchEvent(showToast('error','dismissible','Error!',JSON.stringify(duplicateCheckResult)));
                            }
                        });// end Duplicate Promise then

                    }
                    this.isErrorSpinner= false;
                });
                
            });
        }
        else{
            this.isErrorSpinner= false;
            this.dispatchEvent(showToast('error','dismissible','Error!','This Contact is not valid Email Id  so You cannot add it.'));
        }
    }

    //Omni Remove Reow from Contact Table
    handleRowRemoveTrialContact(event){
        this.isErrorSpinner= true;
        var row = event.detail.row;
        let rows  = JSON.parse(JSON.stringify(this.trailContactsSelected));
        var index = rows.map(x => {
            return x.email;
            }).indexOf(row.email);
            
            
        rows.splice(index, 1);
        this.trailContactsSelected = rows;
        this.trailContactsSelectedTemp = rows;

        this.trailContactsToDisplay = [...this.trailContactsToDisplay, row];
        this.isErrorSpinner= false;
    }

    getPrimaryContactReview(event){
        //this.dispatchEvent(showToast('error','dismissible','Error!','You cannot change it on review page!'));
        
    }
    
    getPrimaryContact(event){
         
        if(event.detail.selectedRows.length > 0)
        {
            this.selectedRecord = [];
            this.selectedPrimaryContName = [];
            let tempArray  = JSON.parse(JSON.stringify(this.trailContactsSelected));
            for (var i in tempArray)
            {
                if(tempArray[i].email == event.detail.selectedRows[0].email){
                    tempArray[i].isPrimaySelectedFromUI = true;
                    
                }else{
                    tempArray[i].isPrimaySelectedFromUI = false;
                }
            }
            this.trailContactsSelected = tempArray;

            //safer side iterating looop
            this.selectedRecordTemp = [];
            let tempArrayTemp  = JSON.parse(JSON.stringify(this.trailContactsSelectedTemp));
            for (var i in tempArrayTemp)
            {
                if(tempArrayTemp[i].email == event.detail.selectedRows[0].email){
                    tempArrayTemp[i].isPrimaySelectedFromUI = true;
                    
                }else{
                    tempArrayTemp[i].isPrimaySelectedFromUI = false;
                }
            }
            this.trailContactsSelectedTemp = tempArrayTemp;

            this.selectedRecord.push(event.detail.selectedRows[0].email);
            this.selectedPrimaryContName.push(event.detail.selectedRows[0].firstName +' '+event.detail.selectedRows[0].lastName);
        }   
    }

    closeQuickAction() {
        //this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent( new CustomEvent('closeQuickAction'));
    }
    createContacts(event){
        
        var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
                
            });
        
        } else {
            this.dispatchEvent(showToast('error','dismissible','Error creating record!','Please enter all the required fields'));
            this.isErrorSpinner = false;
        }
        
    }
    
    contactCreationSuccess(event){
        //this.isErrorSpinner = true;
        this.refreshGSIContacts();// to refresh

        const payload = event.detail;
        //this.isErrorSpinner = false;
        
        this.itemList = [
            {
                id: 0
            }
        ];
        const inputFields = this.template.querySelectorAll(
            '.contactField'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }

        this.dispatchEvent(showToast('success','dismissible','Success!','Contacts are successfully created.'));
        
        
    }

    refreshGSIContacts()
    {
        var trailContactsToDisplayTemp = [];
        let gsiContactPromises = fetchGSIContacts({accId : this.optySobject.Account.Id})
                    .then(result =>{
                        trailContactsToDisplayTemp = result; 
                      })
                    .catch(error =>{
                        console.log(JSON.stringify(error));
                        const errorMsg = reduceErrors(error);
                        this.dispatchEvent(showToast('error','sticky','Error!','Error while fetching GSI Contacts.'));
                    });

        gsiContactPromises.then(()=>{
            let selectedList  = JSON.parse(JSON.stringify(this.trailContactsSelected));
            var searchContacts = JSON.parse(JSON.stringify(trailContactsToDisplayTemp));
            const emailList = selectedList.map(e => e.email);
            console.log('emailList: '+emailList);
            let filterResults = searchContacts.filter(e => !emailList.includes(e.email));
            this.trailContactsToDisplay = filterResults;
            
        });

    }
    //add contact
    keyIndex = 0;
    @track itemList = [
        {
            id: 0
        }
    ];

    addRow() {
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        this.itemList = this.itemList.concat(newItem);
    }

    removeRow(event) {
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
    }
    @track trialStartDate= formatDate(new Date());
    @track trialEndDate;
    @track NoOfDaysForTrail;
    calculateTrialEndDate(event){

        var days =event.target.value;
        this.NoOfDaysForTrail = event.target.value;

        if(parseInt(this.NoOfDaysForTrail) >= 1 && this.trialStartDate !== null && parseInt(this.NoOfDaysForTrail) <= 30){
            var result = new Date(this.trialStartDate);
            var updatedDate = result.setDate(result.getDate() + parseInt(days));
            this.trialEndDate = formatDate(new Date(updatedDate));
        }else{
            this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialDateValidationAlertLabel));
        }
        
    }
    getTrialStartDate(event){
        this.trialStartDate = event.target.value;
        this.trialEndDate = null;
        this.NoOfDaysForTrail = 0;

    }

    
    
    backToConsolePage(event){
        this.isTrialConsoleSection = true;
        this.isReviewPage = false;
        
    }

    goToReviewPage(event){
        this.isErrorSpinner = true;
        console.log(JSON.stringify(this.trailContactsSelected));
        var IsPrimaryContactSeleted = false;
        if(!IsPrimaryContactSeleted && this.trailContactsSelected != null)
        {
            let tempArray  = JSON.parse(JSON.stringify(this.trailContactsSelected));
            
            for (var i in tempArray)
            {
                if(tempArray[i].isPrimaySelectedFromUI == true){
                    //flag set to true
                    IsPrimaryContactSeleted = true;// Making sure that User has selected Primary Contact radio button
                }
            }
        }
        if(this.trialStartDate === null){
            this.dispatchEvent(showToast('error','dismissible','Error!','Please enter required fields (Start Date)'));
            this.isErrorSpinner = false;
            return false;
        }
        else if(this.NoOfDaysForTrail === undefined || this.NoOfDaysForTrail === null || this.NoOfDaysForTrail <= 0){
            this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialNoOfDayRequiredLabel));
            this.isErrorSpinner = false;
            return false;
        }
        else if(this.seletedProductList.length < 1){
            this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialProdctRequiredLabel));
            this.isErrorSpinner = false;
            return false;
        }
       //GSI Contact 
       else if(this.trailContactsSelected.length < 1 ){
            this.dispatchEvent(showToast('error','dismissible','Error!',omniTrialContactRequiredLabel));
            this.isErrorSpinner = false;
            return false;
        }
        else if(!IsPrimaryContactSeleted){
            this.dispatchEvent(showToast('error','dismissible','Error!',OmniPrimaryContactAlert));
            this.isErrorSpinner = false;
            return false;
        }
        else
        {
            //call to OLC/One pass
            var trialContsUpdated = null;
            let olcOnepasspromise = getTrialContsWrapFromOLCOnePass({selectedContacts :JSON.stringify(this.trailContactsSelected)})
                        .then(result =>{
                               trialContsUpdated = result;
                        })
                        .catch(error =>{
                            console.log(JSON.stringify(error));
                            this.dispatchEvent(showToast('error','sticky','Error!','Error while calling One Pass.'));
                        })
            
            olcOnepasspromise.then(()=>{
                console.log('trialContsUpdated WITH onepass OLC:'+JSON.stringify(trialContsUpdated));

                this.trailContactsSelected = trialContsUpdated;

                //this.seletedProductList = entTrialsWrap.trialProducts;
                
                /*if(this.seletedProductList){

                    var tempOppList = [];  
                    for (var i = 0; i < this.seletedProductList.length; i++) {  
                        let tempRecord = Object.assign({}, this.seletedProductList[i]); //cloning object  
                        tempRecord.recordLink = "/" + tempRecord.trialPrdId;

                        if(tempRecord.baseMaterialNumber !== undefined){
                            tempRecord.baseMaterialLink = "/" + tempRecord.baseMaterialNumber;  
                        }
                        if(tempRecord.relationshipType === 'Plan to Plan'){
                            tempRecord.baseMaterialNumber = null;
                            tempRecord.baseMaterialName = null;
                            tempRecord.baseMaterialLink = null;
                        }
                        tempOppList.push(tempRecord);  
                    }  
                    this.seletedProductList = tempOppList;
                }

                console.log('this.trailContactsSelected WITH onepass OLC:'+JSON.stringify(this.trailContactsSelected));
*/
                this.isTrialConsoleSection = false;
                this.isReviewPage = true;   
                this.isErrorSpinner = false;     
            });
            
       }
       
    return true;
    }

    saveTrials(event)
    {
        
        this.isErrorSpinner = true;
        this.trialRecord.Trial_Start_Date__c = this.trialStartDate;
        this.trialRecord.Trial_End_Date__c= this.trialEndDate;
        this.trialRecord.Account__c  = this.accountId;
        this.trialRecord.Number_of_Days__c = this.NoOfDaysForTrail;
        this.trialRecord.Opportunity__c = this.recordId;
        this.trialRecord.Trial_Status__c = 'Draft';
        console.log('entTrialsWrap: Save'+this.trialRecord);

        if(this.trailContactsSelected){

            var tempContUpdated = [];  
            for (var i = 0; i < this.trailContactsSelected.length; i++) {  
                
                let tempRecord = Object.assign({}, this.trailContactsSelected[i]); //cloning object  
                tempRecord.trialStatus = 'Draft';
                tempRecord.requestType = 'TRIAL';
                tempContUpdated.push(tempRecord);  
            }  
            this.trailContactsSelected = tempContUpdated;
        }

        var entTrialsWrap = [];
        let savePromise = saveTrialAndChildSobjects({trialSobj : this.trialRecord,selectedProducts :JSON.stringify(this.seletedProductList), selectedContacts :JSON.stringify(this.trailContactsSelected)})
                            .then(result =>{
                                this.error = undefined;
                                entTrialsWrap = result;
                                console.log('@@@---: '+JSON.stringify(entTrialsWrap));
                                
                        })
                        .catch(error =>{
                            console.log(JSON.stringify(error));
                            const errorMsg = reduceErrors(error);
                            this.dispatchEvent(showToast('error','sticky','Error!','Error while saving Trial Details.'));
                        })

        savePromise.then(()=>{
            if(entTrialsWrap != null && entTrialsWrap != undefined)
            {
                this.trailContactsSelected = entTrialsWrap.trialContacts;
                this.seletedProductList = entTrialsWrap.trialProducts;
                
                if(this.seletedProductList){

                    var tempOppList = [];  
                    for (var i = 0; i < this.seletedProductList.length; i++) {  
                        let tempRecord = Object.assign({}, this.seletedProductList[i]); //cloning object  
                        tempRecord.recordLink = "/" + tempRecord.trialPrdId;

                        if(tempRecord.baseMaterialNumber !== undefined){
                            tempRecord.baseMaterialLink = "/" + tempRecord.baseMaterialNumber;  
                        }
                        if(tempRecord.relationshipType === 'Plan to Plan'){
                            tempRecord.baseMaterialNumber = null;
                            tempRecord.baseMaterialName = null;
                            tempRecord.baseMaterialLink = null;
                        }
                        tempOppList.push(tempRecord);  
                    }  
                    this.seletedProductList = tempOppList;
                }

                //Primary contact Radio button selection
                this.selectedRecord.push(entTrialsWrap.primaryContactEmail);
                
                this.dispatchEvent(showToast('success','dismissible','Success!','Trial Details are saved sucessfully.'));
                this.isErrorSpinner = false;        
            }
        });//end save promise
    }

    submitTrials(event){ 
        this.isErrorSpinner = true;
        this.trialRecord.Trial_Start_Date__c = this.trialStartDate;
        this.trialRecord.Trial_End_Date__c= this.trialEndDate;
        this.trialRecord.Account__c  = this.accountId;
        this.trialRecord.Number_of_Days__c = this.NoOfDaysForTrail;
        this.trialRecord.Opportunity__c = this.recordId;
        this.trialRecord.Trial_Status__c = 'Rep Initiated';

        if(this.trailContactsSelected){

            var tempContUpdated = [];  
            for (var i = 0; i < this.trailContactsSelected.length; i++) {  
                
                let tempRecord = Object.assign({}, this.trailContactsSelected[i]); //cloning object  
                tempRecord.trialStatus = 'Rep Initiated';
                tempRecord.requestType = 'TRIAL';
        
                tempContUpdated.push(tempRecord);  
            }  
            this.trailContactsSelected = tempContUpdated;
        }

        console.log('@save IN: Submit Trial this.trailContactsSelected: '+JSON.stringify(this.trailContactsSelected));
        console.log('@save IN: Submit Trial this.seletedProductList: '+JSON.stringify(this.seletedProductList));

        var entTrialsWrap = [];
        let savePromise = saveTrialAndChildSobjects({trialSobj : this.trialRecord,selectedProducts :JSON.stringify(this.seletedProductList), selectedContacts :JSON.stringify(this.trailContactsSelected)})
                            .then(result =>{
                                this.error = undefined;
                                entTrialsWrap = result;
                                console.log('@save IN: Submit Trial: '+JSON.stringify(entTrialsWrap));
                                
                        })
                        .catch(error =>{
                            console.log(JSON.stringify(error));
                            const errorMsg = reduceErrors(error);
                            this.dispatchEvent(showToast('error','sticky','Error!','Error while saving Trial Details.'));
                        })

        savePromise.then(()=>{
            if(entTrialsWrap != null && entTrialsWrap != undefined)
            {
                this.trailContactsSelected = entTrialsWrap.trialContacts;
                this.seletedProductList = entTrialsWrap.trialProducts;
                
                if(this.seletedProductList){

                    var tempOppList = [];  
                    for (var i = 0; i < this.seletedProductList.length; i++) {  
                        let tempRecord = Object.assign({}, this.seletedProductList[i]); //cloning object  
                        tempRecord.recordLink = "/" + tempRecord.trialPrdId;

                        if(tempRecord.baseMaterialNumber !== undefined){
                            tempRecord.baseMaterialLink = "/" + tempRecord.baseMaterialNumber;  
                        }
                        if(tempRecord.relationshipType === 'Plan to Plan'){
                            tempRecord.baseMaterialNumber = null;
                            tempRecord.baseMaterialName = null;
                            tempRecord.baseMaterialLink = null;
                        }
                        tempOppList.push(tempRecord);  
                    }  
                    this.seletedProductList = tempOppList;
                }


                //Primary contact Radio button selection
                this.selectedRecord.push(entTrialsWrap.primaryContactEmail);
                
                //Create List for Trial Prd Ids and Trial Contact Ids
                let trialContIds = [];
                var trialContSeleted = JSON.parse(JSON.stringify(this.trailContactsSelected));
                for (let i = 0; i < trialContSeleted.length; i++) {
                    trialContIds.push(trialContSeleted[i].trialContRecordId);
                }

                let  trialPrdIds= [];
                var trialPrdSeleted = JSON.parse(JSON.stringify(this.seletedProductList));
                for (let i = 0; i < trialPrdSeleted.length; i++) {
                    trialPrdIds.push(trialPrdSeleted[i].trialPrdRecordId);
                }
                
                var trialId = entTrialsWrap.entTrial.Id;

                var eloquaResult;
                //calling Submit Trial button to Eloqua
                let eloqua = getOmniTrialsEloquaCallsLWC({trialId : JSON.stringify(trialId),trialContIds : JSON.stringify(trialContIds), trialProdIds :JSON.stringify(trialPrdIds)})
                        .then(result =>{
                            eloquaResult = result;
                        })
                        .catch(error =>{
                            console.log(JSON.stringify(error));
                            this.dispatchEvent(showToast('error','sticky','Error!','Error while doing Eloqua Call.'));
                        })
                eloqua.then(()=>{
                    console.log('eloquaResult: '+JSON.stringify(eloquaResult));

                    if(eloquaResult === true){
                        this.dispatchEvent(showToast('success','sticky','Success!',OmniEloquaCallSuccessMsg));
                        
                        this.closeQuickAction();
                        this.isErrorInInitialCheck  = true;

                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: trialId,
                                objectApiName: 'Ent_Trial__c',
                                actionName: 'view'
                            }
                        });

                    }
                    else{
                        this.dispatchEvent(showToast('error','sticky','Error!',OmniEloquaCallFailureMsg));
                        this.closeQuickAction();
                        this.isErrorInInitialCheck  = true;

                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: trialId,
                                objectApiName: 'Ent_Trial__c',
                                actionName: 'view'
                            }
                        });
                    }
                    this.isErrorSpinner = false;        
                });
            }
        });//end save promise

        
    }
}

function validateEmailStatus(emailId) {
    
    getDigitalBlacklistCompetitorStatus({emailId : emailId})
    .then(result =>{
        if(result.Status__c === 'Blocked'){
            return true;    
        }else{
            return false;
        } 
    })
    .catch(error =>{
        const errorMsg = reduceErrors(error);
    })
}