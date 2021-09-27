({
    showData : function(component, event, helper) {
        var isQueue = component.get("v.isQueue");
        var showMyListView = component.get("v.showMyListView");
        if(isQueue || showMyListView){
            helper.showListViewData(component, event, helper);
        }
        
    },
    
    onListViewChange : function(component, event, helper) {
        console.log('calling showrecordsdata');
        helper.showRecordsData(component, event, helper);
    },
})