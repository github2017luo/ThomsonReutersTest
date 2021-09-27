/*
GSI Contacts datatable columns
*/
const gsiContactsCol = () => {
    return [
        {
            label: 'Action', type: 'button-icon', initialWidth: 75,
            typeAttributes: {
                iconName: 'utility:add', title: 'Add', name: 'add',
                variant: 'border-filled',alternativeText: 'Assign'
            }
        },
        {label:'First Name',fieldName:'firstName', type:'text'},  
        {label:'Last Name',fieldName:'lastName', type:'text'},
        {label:'Email',fieldName:'email', type:'email'} ,
        {label:'Online Contact Designation',fieldName:'onlineContactDesignation', type:'boolean'},
        //{label:'Primary Contact',fieldName:'gsiPrimaryFlag', type:'Checkbox'},
    ];
};

const selectedGSIContactsReview = () => {
    return [
        {label:'Name',fieldName:'fullName', type:'text'},  
        {label:'Email',fieldName:'email', type:'Email'},
    ];
};

const selectedGSIContactsCol = () => {
    return [
        {
            label: 'Action',
            type: 'button-icon',
            initialWidth: 75,
            typeAttributes: {
                iconName: 'utility:dash',
                title: 'Remove',
                name: 'remove',
                variant: 'border-filled',
                alternativeText: 'Assign'
            }
        },
        {label:'First Name',fieldName:'firstName', type:'text'},  
        {label:'Last Name',fieldName:'lastName', type:'text'},
        {label:'Email',fieldName:'email', type:'Email'},
        {label:'Online Contact Designation',fieldName:'onlineContactDesignation', type:'boolean'},
        //{label:'Primary Contact',fieldName:'gsiPrimaryFlag', type:'Checkbox'}
    ];
};


/*
    Online Contacts data table columns
*/

const onlineContactColumns = () => {
    return [
        {
            label: 'Action',
            type: 'button-icon',
            initialWidth: 75,
            typeAttributes: {
                iconName: 'utility:add',
                title: 'Add',
                name: 'add',
                variant: 'border-filled',
                alternativeText: 'Assign'
            }
        },
            { label: 'First Name', fieldName: 'firstName', type: 'text' },
            { label: 'Last Name', fieldName: 'lastName', type: 'text' },
            { label: 'Email', fieldName: 'email', type: 'email'},
            { label: 'Status', fieldName: 'oLCStatus', type: 'text'},
    ];
};

const selectedOnlineContsClms = () => {
    return [
        {
            label: 'Action',
            type: 'button-icon',
            initialWidth: 75,
            typeAttributes: {
                iconName: 'utility:dash',
                title: 'Remove',
                name: 'remove',
                variant: 'border-filled',
                alternativeText: 'Assign'
            }
        },
            { label: 'First Name', fieldName: 'firstName', type: 'text' },
            { label: 'Last Name', fieldName: 'lastName', type: 'text' },
            { label: 'Email', fieldName: 'email', type: 'email'},
            { label: 'Status', fieldName: 'oLCStatus', type: 'text'},
    ];
};

const selectedOnlineContsReview = () => {
    return [
        {label: 'Name', fieldName: 'fullName', type: 'text' },
        { label: 'Email', fieldName: 'email', type: 'email'},
    ];
};

/*
    Product data table columns
*/
const prdcolumns = () => {
    return [
        {
            label: 'Action',
            type: 'button-icon',
            initialWidth: 75,
            typeAttributes: {
                iconName: 'utility:add',
                title: 'Add',
                name: 'add',
                variant: 'border-filled',
                alternativeText: 'Assign'
            }
        },//{ label: 'Id', fieldName: 'Id' },
        {  
            label: "Name",  
            fieldName: "recordLink",  
            type: "url",  
            typeAttributes: { label: { fieldName: "productName" }, tooltip:"Name", target: "_blank" }  
        },
        //{ label: 'Name', fieldName: 'productName' },
        { label: 'Material Number', fieldName: 'productCode' },
        { label: 'Segment', fieldName: 'segmentType' },
        { label: 'Relationship Type', fieldName: 'relationshipType' },
        {  
            label: "Base Material",  
            fieldName: "baseMaterialLink",  
            type: "url",  
            typeAttributes: { label: { fieldName: "baseMaterialName" }, tooltip:"Name", target: "_blank" }  
        },
    ];
};


const selectedPrdcolumns = () => {
    return [

        {  
            label: "Name",  
            fieldName: "recordLink",  
            type: "url",  
            typeAttributes: { label: { fieldName: "productName" }, tooltip:"Name", target: "_blank" }  
        },
        { label: 'Material Number', fieldName: 'productCode' },
        { label: 'Segment', fieldName: 'segmentType' },
        { label: 'Relationship Type', fieldName: 'relationshipType' },
        {  
            label: "Base Material",  
            fieldName: "baseMaterialLink",  
            type: "url",  
            typeAttributes: { label: { fieldName: "baseMaterialName" }, tooltip:"Name", target: "_blank" }  
        },
    ];
};

const selectedPrdcolumnsReview = () => {
    return [
        {  
            label: "Name",  
            fieldName: "recordLink",  
            type: "url",  
            typeAttributes: { label: { fieldName: "productName" }, tooltip:"Name", target: "_blank" }  
        },
        { label: 'Material Number', fieldName: 'productCode' },
        { label: 'Segment', fieldName: 'segmentType' },
        { label: 'Relationship Type', fieldName: 'relationshipType' },
        {  
            label: "Base Material",  
            fieldName: "baseMaterialLink",  
            type: "url",  
            typeAttributes: { label: { fieldName: "baseMaterialName" }, tooltip:"Name", target: "_blank" }  
        }, 
    ];
};

export { gsiContactsCol, selectedGSIContactsReview, selectedGSIContactsCol, 
    onlineContactColumns, selectedOnlineContsClms, selectedOnlineContsReview, 
    prdcolumns, selectedPrdcolumns, selectedPrdcolumnsReview};