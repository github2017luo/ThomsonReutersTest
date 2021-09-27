/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement, wire, api, track } from 'lwc';
import getChildObjectDetails from '@salesforce/apex/AccountHeirarchyDetailController.getChildObjectDetails';


const Opp_Colms = [
    {label: 'Account', fieldName: 'accountUrl', type: 'url',typeAttributes: {label: { fieldName: 'account' },target: '_blank'}, sortable: true},
    {label: 'Name', fieldName: 'oppUrl', type: 'url',typeAttributes: {label: { fieldName: 'name' },target: '_blank'}, sortable: true},
    {label: 'Stage', fieldName: 'stage', type: 'text'},
    {label: 'Owner', fieldName: 'ownerUrl', type: 'url', typeAttributes : {label: {fieldName: 'owner'},target: '_blank'}},
    {label: 'TotalCurrent ACV', fieldName: 'total_Current_ACV', type: 'currency'},
    {label: 'Total New ACV/Sales price', fieldName: 'total_New_ACV_or_Sales_price', type: 'currency'},
    {label: 'Total Incremental Renewal', fieldName: 'total_Increment', type: 'currency'},
    {label: 'CloseDate', fieldName: 'closeDate', type: 'Date'},
    {label: 'BU region', fieldName: 'BU_region', type: 'text'},
    {label: 'Frozen Market Current Year Segment L1', fieldName: 'BU_segment', type: 'text'}
    
];

const TE_Colms = [
    {label: 'Account', fieldName: 'accountUrl', type: 'url',typeAttributes: {label: { fieldName: 'account' },target: '_blank'}, sortable: true},
    {label: 'TE Identifier', fieldName: 'TE_Url', type: 'url',typeAttributes: {label: { fieldName: 'TE_Identifier' },target: '_blank'}, sortable: true},
    {label: 'TE Name', fieldName: 'TE_Name', type: 'text'},
    {label: 'Training Date/Start Time', fieldName: 'Training_Date_or_Start_Time', type: 'Date'},
    {label: 'Status', fieldName: 'status', type: 'picklist'},
    {label: 'Cancelled reason', fieldName: 'cancelled_reason', type: 'picklist'},
    {label: 'No. of Candidates', fieldName: 'No_of_Candidates', type: 'number'},
    {label: 'No. Trained', fieldName: 'No_Trained', type: 'number'},
    {label: 'Owner', fieldName: 'ownerUrl', type: 'url',typeAttributes:{label:{fieldName: 'owner'}, target: '_blank'}}
    
];

const ALIBill_columns = [
    {label: 'Asset Name', fieldName: 'assetUrl', type: 'url',typeAttributes: {label: { fieldName: 'name' },target: '_blank'}},
    {label: 'Status', fieldName: 'status', type: 'picklist'},
    {label: 'EndDate', fieldName: 'endDate', type: 'Date'},
    {label: 'Start Date', fieldName: 'startDate', type: 'Date'},
    {label: 'Renewal Date', fieldName: 'AptturenDates_Config2__RenewalDate__c', type: 'Date'},
    {label: 'Renewal Type', fieldName: 'APTS_Renewal_Type__c', type: 'picklist'},
    
];
const act_columns = [
    {label: 'Name', fieldName: 'leadContactUrl', type: 'url',
    typeAttributes:{label:{fieldName: 'leadConName'}, target: '_blank'},
    sortable: true}, 
    {label: 'Subject', fieldName: 'subjectURL', type: 'url',
    typeAttributes:{label:{fieldName: 'subject'}, target: '_blank'},
    sortable: true}, 
    {label: 'Activity  Type', fieldName: 'activityType', type: 'text'},     
    {label: 'Related To', fieldName: 'whatIdURL',type: 'url',
    typeAttributes:{label:{fieldName: 'whatId'}, target: '_blank'},
    sortable: true},  
    {label: 'Due Date', fieldName: 'dueDate', type: 'Date'},
    {label: 'Status', fieldName: 'status', type: 'picklist'},   
    {label: 'Owner', fieldName: 'ownerUrl', type: 'url',
    typeAttributes:{label:{fieldName: 'owner'}, target: '_blank'},
    sortable: true},
  
];
const actHis_columns = [
    {label: 'Name', fieldName: 'whoIdUrl', type: 'url',
    typeAttributes:{label:{fieldName: 'whoId'}, target: '_blank'},
    sortable: true},
    {label: 'Subject', fieldName: 'subjectURL', type: 'url',
    typeAttributes:{label:{fieldName: 'subject'}, target: '_blank'},
    sortable: true},
    {label: 'Activity  Type', fieldName: 'activityType', type: 'text'},   
    {label: 'Related To', fieldName: 'whatIdUrl', type: 'url',
    typeAttributes:{label:{fieldName: 'whatId'}, target: '_blank'},
    sortable: true},
    {label: 'Activity Date', fieldName: 'dueDate', type: 'Date'},
    {label: 'Status', fieldName: 'status', type: 'picklist'},
    {label: 'Owner', fieldName: 'ownerIdUrl', type: 'url',
    typeAttributes:{label:{fieldName: 'ownerId'}, target: '_blank'},
    sortable: true},
];
const prop_columns = [    
    {label: 'Proposal ID', fieldName: 'propUrl', type: 'url',typeAttributes:{label:{fieldName: 'name'}, target: '_blank'}},
    {label: 'Proposal Name', fieldName: 'proposalName', type: 'text'},
    {label: 'Owner FirstName', fieldName: 'ownerFN', type: 'text'},
    {label: 'Owner LastName', fieldName: 'ownerLN', type: 'text'},
    {label: 'Opportunity', fieldName: 'oppUrl', type: 'url',typeAttributes:{label:{fieldName: 'opp'}, target: '_blank'}},
    {label: 'Approval Stage', fieldName: 'stage', type: 'text'},
    {label: 'Created Date', fieldName: 'createdDate', type: 'Date'},
    {label: 'Ready for Activation Date', fieldName: 'ActivationDate', type: 'Date'}
];
const cases_columns = [
    {label: 'Case', fieldName: 'caseUrl', type: 'url',typeAttributes:{label:{fieldName: 'caseName'}, target: '_blank'}},
    {label: 'Contact', fieldName: 'contactUrl', type: 'url',typeAttributes:{label:{fieldName: 'contact'}, target: '_blank'}},
    {label: 'Subject', fieldName: 'subject', type: 'text'},
    {label: 'Priority', fieldName: 'priority', type: 'text'},
    {label: 'DateOpened', fieldName: 'dateOpened', type: 'Date'},
    {label: 'Status', fieldName: 'status', type: 'picklist'},
    {label: 'Owner', fieldName: 'ownerUrl', type: 'url',typeAttributes:{label:{fieldName: 'owner'}, target: '_blank'}},
];

export default class accHierarchy extends LightningElement {
    @api recordId; 
    @track wrappdata;
    @track error;
    @track rowoffset =100;

    @track mOpp_columns = Opp_Colms;
    @track mTE_columns = TE_Colms;
    @track mALIBill_Columns = ALIBill_columns;
    @track mAct_Columns = act_columns;
    @track mActHis_Columns = actHis_columns;
    @track mProp_Columns = prop_columns;
    @track mCases_Columns = cases_columns;
    
    @track mOpp;
    @track mTE;
    @track mALIBill;
    @track mAct;
    @track mActHis;
    @track mCases;
    @track mProp;
    
    @wire(getChildObjectDetails, { masterAccountId: '$recordId' }) 
    ChildAccts(result) {
        if (result.data) {
            let mOpp = [];
            let mTE = [];
            let mALIBill = [];
            let mProp = [];
            let mCases = [];
            let accActivity = [];
            let accHist = [];

            for(let i in result.data.MasterAccountOpportunities){
                if(result.data.MasterAccountOpportunities){
                mOpp.push(result.data.MasterAccountOpportunities[i]);
                }
            }
            this.mOpp = mOpp;
            //console.log(JSON.stringify(this.mOpp));
            for(let i in result.data.MasterAccountTrainingEvents){
                if(result.data.MasterAccountTrainingEvents){
                mTE.push(result.data.MasterAccountTrainingEvents[i]);
                }
            }
            this.mTE = mTE;
            //console.log(JSON.stringify(this.mTE));
            for(let i in result.data.AssetLineItem){
                if(result.data.AssetLineItem){
                    mALIBill.push(result.data.AssetLineItem[i]);
                }
            }
            this.mALIBill = mALIBill;
            //console.log(JSON.stringify(this.mALIBill));
            for(let i in result.data.props){
                if(result.data.props){
                    mProp.push(result.data.props[i]);
                }
            }
            this.mProp = mProp;
            //console.log(JSON.stringify(this.mProp));
            for(let i in result.data.cases){
                if(result.data.cases){
                    mCases.push(result.data.cases[i]);
                }
            }
            this.mCases = mCases;
            //console.log(JSON.stringify(this.mCases));
            for(let i in result.data.acts){
                if(result.data.acts){
                    accActivity.push(result.data.acts[i]);
                }
             }
            this.mAct = accActivity;
            //console.log(JSON.stringify(this.mAct));

            //ActivityHistory
            for(let i in result.data.actHis){
                if(result.data.acts){
                    //alert(result.data.acts[i]);
                    accHist.push(result.data.actHis[i]);
                }
             }
            this.mActHis = accHist;
            console.log(JSON.stringify(this.mActHis));
            
        } else if (result.error) {
            this.error = result.error;
            console.log(this.error );
        }
    }    


}