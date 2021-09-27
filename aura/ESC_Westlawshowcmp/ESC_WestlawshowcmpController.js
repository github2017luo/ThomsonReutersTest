({
    doInit : function(component, event, helper) {
        //component.set('v.recordId', component.get("v.pageReference").state.Id);
        //console.log(component.get("v.pageReference").state.Id);
        var recID = component.get("v.recordId");
        component.set("v.Spinner", true);
        console.log(component.get("v.recordId"));
        var action = component.get("c.viewrefAttorney");
        action.setParams({
            accountid: recID
        });
        action.setCallback(this, function(response){
            console.info('response', response);
            var state = response.getState();
            console.log(state);
            if (response.getState() === "SUCCESS") {
            var data = response.getReturnValue();
            console.log(data);
            component.set("v.data", data);
            component.set("v.attcount",data[0].count);
            component.set("v.activecount",data[1].count);    
            component.set("v.data1", data[0].DataTableWrapper);
			component.set("v.data2", data[1].DataTableWrapper);
            component.set('v.columns', [     
    		{label: 'Last Name', fieldName: 'lastName', type: 'text',cellAttributes: { alignment: 'center'}}, 
 			{label: 'First Name', fieldName: 'firstName', type: 'text',cellAttributes: { alignment: 'center'}}]);
            component.set("v.Spinner", false);
            component.set("v.isdata", true);
            }
            else{
                console.log("callback error", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    getattorney : function(component, event, helper) {
        console.log('entered for ref count');
    	component.set("v.isattorney", true);
    	component.set("v.isactive", false);
        var pageSize = component.get("v.pageSize");
        component.set("v.totalRecords", component.get("v.attcount"));
        var attdata = component.get("v.data1");
                component.set("v.startPage", 0);                
                component.set("v.endPage", pageSize - 1);
                var PagList = [];
                for ( var i=0; i< pageSize; i++ ) {
                    if ( component.get("v.data1").length> i )
                        PagList.push(attdata[i]);    
                }
                component.set('v.PaginationList1', PagList);
    	
	},
 	getactive : function(component, event, helper) {
        console.log('entered for active count');
    	component.set("v.isattorney", false);
    	component.set("v.isactive", true);
        var pageSize = component.get("v.pageSize");
        component.set("v.totalRecords", component.get("v.activecount"));
        var attdata = component.get("v.data2");
                component.set("v.startPage", 0);                
                component.set("v.endPage", pageSize - 1);
                var PagList = [];
                for ( var i=0; i< pageSize; i++ ) {
                    if ( component.get("v.data2").length> i )
                        PagList.push(attdata[i]);    
                }
                component.set('v.PaginationList2', PagList);
    
	},
     next: function (component, event, helper) {
        var att = component.get("v.isattorney");
         var active = component.get("v.isactive");
         if(att){
  			var sObjectList = component.get("v.data1");
         }
         if (active){
            var sObjectList = component.get("v.data2");
         }
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PagList = [];
        var counter = 0;
        for ( var i = end + 1; i < end + pageSize + 1; i++ ) {
            if ( sObjectList.length > i ) {
                PagList.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        if(att){
        component.set('v.PaginationList1', PagList);
        }
    	if(active){
         component.set('v.PaginationList2', PagList);
    	 }
 },
 previous: function (component, event, helper) {
  		 var att = component.get("v.isattorney");
         var active = component.get("v.isactive");
         if(att){
  			var sObjectList = component.get("v.data1");
         }
         if (active){
            var sObjectList = component.get("v.data2");
         }
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var PagList = [];
        var counter = 0;
        for ( var i= start-pageSize; i < start ; i++ ) {
            if ( i > -1 ) {
                PagList.push(sObjectList[i]);
                counter ++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        if(att){
        component.set('v.PaginationList1', PagList);
        }
    	if(active){
         component.set('v.PaginationList2', PagList);
    	 }
 },
  close: function (component, event, helper) {
      if(component.get("v.isattorney")){
         component.set("v.isattorney", false); 
      }
      if(component.get("v.isactive")){
         component.set("v.isactive", false); 
      } 
  }
})