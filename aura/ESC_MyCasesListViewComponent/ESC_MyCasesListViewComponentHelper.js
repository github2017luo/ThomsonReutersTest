({
    showListViewData : function(component, event, helper) {
        //var strValue = component.find("inputName").get("v.value");
        var strValue = component.get("v.objectName");
        var mylstViewValue = component.get("v.showMyListView");
        var setOptions = component.find("selectvalues");
        component.set("v.objName", strValue);
        var action = component.get("c.fetchListViews");
        action.setParams({
            "strObjName" : strValue,
            "myLstViewName" : mylstViewValue
        });
        var optionValues = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS") {             
                $A.util.removeClass(component.find('div1'), 'slds-hide');
                $A.util.addClass(component.find('div1'), 'slds-show');
                var listviewvalue = response.getReturnValue();
                if(listviewvalue != null && listviewvalue != undefined) {
                    
                    if(mylstViewValue){
                        
                      optionValues.push({
                        class:"optionclass",
                        label:"--None--",
                        value:""
                    });  
                    }
                    
                    for(var i=0; i<listviewvalue.length; i++) {
                        var listViewSplt = listviewvalue[i].split(':');
                        console.log('## listviews: '+listViewSplt);
                        optionValues.push({
                        class:"optionclass",
                        label:listViewSplt[0],
                        value:listViewSplt[1]
                    });
                }
                setOptions.set("v.options", optionValues);
                   if(!mylstViewValue){
                        var selectedName = listviewvalue[0].split(':')[1];
                        if(selectedName !=null && selectedName != ''){
                            console.log('## selectedName : ' + selectedName);
                          component.find("selectvalues").set("v.value",selectedName);
                       	  helper.showRecordsData(component, event, helper);  
                        }
                        
					}
                }else{
                    $A.util.addClass(component.find('div1'), 'slds-hide');
                    $A.util.removeClass(component.find('div2'), 'slds-hide');
                	$A.util.addClass(component.find('div2'), 'slds-show');
                    
                }
                
            }else if(status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
        });
        $A.enqueueAction(action); 
    },
    
    showRecordsData : function(component, event, helper) {
        var selectedName = component.find("selectvalues").get("v.value");
        var lstApi = selectedName.replace(/ /g,'');  
        console.log('## selected listview: '+lstApi);
        component.set("v.viewName", lstApi);
        component.set("v.body" , []);
        $A.createComponent(
            "lightning:listView",
            {
                "objectApiName" : component.get("v.objectName"),
                "listName" : component.get("v.viewName"),              
                "rows": 20,
                "showActionBar":true,
                "enableInlineEdit":true,                
                "showSearchBar":true,
                "showRowLevelActions":true
            },
            function(newListView, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newListView);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        );  
    },   
})