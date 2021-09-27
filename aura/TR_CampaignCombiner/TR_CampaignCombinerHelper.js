({ 
    getCurrentRecord: function(component, event, helper)
    {
        var recordId=component.get("v.currentrecordId");
        var action = component.get('c.fetchCurrentCampaign');
        action.setParams({"campId": recordId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                component.set("v.currentCampaign",response.getReturnValue());
                component.set("v.currentCampaignName",response.getReturnValue()[0].Name);
                component.set("v.currentCampaignOwner",response.getReturnValue()[0].OwnerId);
                component.set("v.currentCampaignParent",response.getReturnValue()[0].ParentId);
                component.set("v.currentCampaignStatus",response.getReturnValue()[0].Status);
                component.set("v.currentCampaignStartDate",response.getReturnValue()[0].StartDate);
                component.set("v.currentCampaignEndDate",response.getReturnValue()[0].EndDate);
                component.set("v.currentCampaignContacts",response.getReturnValue()[0].NumberOfContacts);
                component.set("v.currentCampaignLeads",response.getReturnValue()[0].NumberOfLeads);
                component.set("v.currentCampaignActive",response.getReturnValue()[0].IsActive);
                component.set("v.currentCampaignType",response.getReturnValue()[0].Type);
                //component.set("v.selectedCampaignLookUpRec",response.getReturnValue());
                // console.log('selected campaign----'+component.get("v.selectedCampaignLookUpRec"));
                console.log('response value------'+response.getReturnValue());
                console.log('response value------'+response.getReturnValue()[0].Name);
                if(component.get("v.currentCampaignOwner")!=null){
                    this.fetchCurrentCampaignOwner(component,event,helper);
                }
                if(component.get("v.currentCampaignParent")!=null){
                    this.fetchCurrentCampaignParent(component,event,helper);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    getSelectedCampaign: function(component, event, helper)
    {
        var recordId=component.get("v.selectedCampId");
        var action = component.get('c.fetchSelectedCampaign');
        action.setParams({"campId": recordId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                component.set("v.selectedCampaignName",response.getReturnValue()[0].Name);
                component.set("v.selectedCampaignOwner",response.getReturnValue()[0].OwnerId);
                component.set("v.selectedCampaignParent",response.getReturnValue()[0].ParentId);
                component.set("v.selectedCampaignStatus",response.getReturnValue()[0].Status);
                component.set("v.selectedCampaignStartDate",response.getReturnValue()[0].StartDate);
                component.set("v.selectedCampaignEndDate",response.getReturnValue()[0].EndDate);
                component.set("v.selectedCampaignContacts",response.getReturnValue()[0].NumberOfContacts);
                component.set("v.selectedCampaignLeads",response.getReturnValue()[0].NumberOfLeads);
                component.set("v.selectedCampaignActive",response.getReturnValue()[0].IsActive);
                component.set("v.selectedCampaignType",response.getReturnValue()[0].Type);
                console.log('response value------'+response.getReturnValue());
                console.log('response value------'+response.getReturnValue()[0].Name);
                if(component.get("v.selectedCampaignOwner")!=null){
                    this.fetchSelectedCampaignOwner(component,event,helper);
                }
                if(component.get("v.selectedCampaignParent")!=null){
                    this.fetchSelectedCampaignParent(component,event,helper);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    getNewCampaign: function(component, event, helper)
    {
        var recordId=component.get("v.newCreatedCampaignId");
        var action = component.get('c.fetchNewCampaign');
        action.setParams({"campId": recordId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                component.set("v.newCampaignName",response.getReturnValue()[0].Name);
                component.set("v.newCampaignOwner",response.getReturnValue()[0].OwnerId);
                component.set("v.newCampaignParent",response.getReturnValue()[0].ParentId);
                component.set("v.newCampaignStatus",response.getReturnValue()[0].Status);
                component.set("v.newCampaignStartDate",response.getReturnValue()[0].StartDate);
                component.set("v.newCampaignEndDate",response.getReturnValue()[0].EndDate);
                component.set("v.newCampaignContacts",response.getReturnValue()[0].NumberOfContacts);
                component.set("v.newCampaignLeads",response.getReturnValue()[0].NumberOfLeads);
                component.set("v.newCampaignActive",response.getReturnValue()[0].IsActive);
                component.set("v.newCampaignType",response.getReturnValue()[0].Type);
                console.log('response value------'+response.getReturnValue());
                console.log('response value------'+response.getReturnValue()[0].Name);
                if(component.get("v.newCampaignOwner")!=null){
                    this.fetchNewCampaignOwner(component,event,helper);
                }
                if(component.get("v.newCampaignParent")!=null){
                    this.fetchNewCampaignParent(component,event,helper);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,

	getStatusPickList: function(component, event, helper) {
        var action = component.get("c.getStatusPickList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var statusMap = [];
                for(var key in result){
                    statusMap.push({key: key, value: result[key]});
                }
                component.set("v.statusMap", statusMap);
                console.log("Status values-----"+statusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getStatusMemPickList: function(component, event, helper) {
        var action = component.get("c.getStatusMemPickList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var statusMemMap = [];
                for(var key in result){
                    statusMemMap.push({key: key, value: result[key]});
                }
                component.set("v.statusMemMap", statusMemMap);
                console.log("StatusMem values-----"+statusMemMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getTypePickList: function(component, event, helper) {
        var action = component.get("c.getTypePickList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var typeMap = [];
                for(var key in result){
                    typeMap.push({key: key, value: result[key]});
                }
                component.set("v.typeMap", typeMap);
                console.log("Type values-----"+typeMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    fetchSelectedCampaignOwner: function(component, event, helper)
    {
        var ownerId=component.get("v.selectedCampaignOwner");
        var action = component.get('c.fetchCampaignOwner');
        action.setParams({"ownerId": ownerId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside owner method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                component.set("v.selectedCampaignOwnerName",response.getReturnValue().Name);
                console.log('campaign owner name-----'+response.getReturnValue().Name);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    fetchNewCampaignOwner: function(component, event, helper)
    {
        var ownerId=component.get("v.newCampaignOwner");
        var action = component.get('c.fetchCampaignOwner');
        action.setParams({"ownerId": ownerId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside owner method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                component.set("v.newCampaignOwnerName",response.getReturnValue().Name);
                console.log('campaign owner name-----'+response.getReturnValue().Name);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    fetchCurrentCampaignOwner: function(component, event, helper)
    {
        var ownerId=component.get("v.currentCampaignOwner");
        var action = component.get('c.fetchCampaignOwner');
        action.setParams({"ownerId": ownerId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside owner method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                component.set("v.currentCampaignOwnerName",response.getReturnValue().Name);
                console.log('campaign owner name-----'+response.getReturnValue().Name);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    fetchCurrentCampaignParent: function(component, event, helper)
    {
        var parentId=component.get("v.currentCampaignParent"); 
        console.log('parentId---------'+parentId);
        var action = component.get('c.fetchCampaignParent');
        action.setParams({"parentId": parentId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside Parent method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                component.set("v.currentCampaignParentName",response.getReturnValue()[0].Name); 
                console.log('Current campaign Parent name-----'+response.getReturnValue()[0].Name);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    fetchCampaignParent: function(component, event, helper)
    {
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            var parentId=component.get("v.currentCampaignParent"); 
        }else if(isSelected){
            var parentId=component.get("v.selectedCampaignParent");   
        }else{
            var parentId=component.get("v.newCampaignParent");
        }
        console.log('parentId---------'+parentId);
        var action = component.get('c.fetchCampaignParent');
        action.setParams({"parentId": parentId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside Parent method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                if(isCurrent){
                    component.set("v.currentCampaignParentName",response.getReturnValue()[0].Name); 
                    console.log('Current campaign Parent name-----'+response.getReturnValue()[0].Name);
                }else if(isSelected){
                    component.set("v.selectedCampaignParentName",response.getReturnValue()[0].Name); 
                    console.log('Selected campaign Parent name-----'+response.getReturnValue()[0].Name); 
                }else{
                    component.set("v.NewCampaignParentName",response.getReturnValue()[0].Name); 
                    console.log('New campaign Parent name-----'+response.getReturnValue()[0].Name);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    fetchSelectedCampaignParent: function(component, event, helper)
    {
        var parentId=component.get("v.selectedCampaignParent");  
        var action = component.get('c.fetchCampaignParent');
        action.setParams({"parentId": parentId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside Parent method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                component.set("v.selectedCampaignParentName",response.getReturnValue().Name); 
                console.log('Selected campaign Parent name-----'+response.getReturnValue().Name);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    fetchNewCampaignParent: function(component, event, helper)
    {
        var parentId=component.get("v.newCampaignParent");  
        var action = component.get('c.fetchCampaignParent');
        action.setParams({"parentId": parentId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('------------Inside Parent method--------------');
            console.log('response state-----'+state);
            if (state === "SUCCESS") {
                console.log('-------Inside success method---------');
                component.set("v.newCampaignParentName",response.getReturnValue().Name); 
                console.log('New campaign Parent name-----'+response.getReturnValue().Name);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    } ,
    
    
    createNewCampaign: function(component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        var newCampName=component.get("v.campName");
        var newCampStartDate=component.get("v.campStartDate");
        var newCampEndDate=component.get("v.campEndDate");
        var newCampType=component.get("v.selectedType");
        var newCampStatus=component.get("v.selectedStatus");
        if (newCampName == null || newCampName == "") {
            //component.set("v.errMsg", "Please enter a Name");
            toastEvent.setParams({
                "title": "Missing Campaign Name!",
                "message": "Please Enter Campaign Name",
                "type":"error"
            });
            toastEvent.fire();
        }else if(newCampEndDate < newCampStartDate){
            console.log('Inside date check condition');
            toastEvent.setParams({
                "title": "End date cannot be less than Start Date!",
                "message": "Please Enter valid End Date",
                "type":"error"
            });
            toastEvent.fire();  
        }else{
            var action = component.get('c.campaignCreate');
            action.setParams({"CampaignName": newCampName,
                              "StartDate":newCampStartDate,
                              "EndDate":newCampEndDate,
                              "Type":newCampType,
                              "Status":newCampStatus
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('New Campaign state-----'+state);
                if (state === "SUCCESS") {
                    component.set("v.newCampaignstate",true);
                    component.set("v.newcmpcheckboxModal",false);
                    component.set("v.newCreatedCampaignId",response.getReturnValue()[0]);
                    console.log('new Campaign ID with list-----'+response.getReturnValue()[0]);
                    this.getNewCampaign(component,event,helper);
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "New Campaign" + " " + newCampName +" " + " Created Successfully",
                        "type":"success"
                    });
                    toastEvent.fire();
                }else if (state === "ERROR") {
                    var errors = response.getError();	
                    if(errors){
                        if (errors[0] && errors[0].message){
                            var errMsg = errors[0].message;
                            component.set("v.errorMessage",errMsg);
                            console.log('errorMessage[0]------------'+errors[0].message);
                        }
                    }else{
                        component.set("v.errorMessage","Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
            
        }
        
    },
    
    helperCombineWithCurrentCampaign: function(component, event, helper){
        var recordId=component.get("v.currentrecordId");
        var memberStatus = component.get("v.newselectedStatus");
        console.log('selected Ids List--------'+component.get("v.multiselectedAddCurrentLookUpRecords"));
        var selectedCampaign=component.get("v.multiselectedAddCurrentLookUpRecords");
        console.log('selected Ids List size--------'+selectedCampaign.length);
        var excludeCampaign = component.get("v.multiselectedExcludeCurrentLookUpRecords");
        var addIntersection = component.get("v.currentCampActivestatus");
        var excludeIntersection = component.get("v.currentCampExcludestatus");
        if(selectedCampaign.length == 0 && excludeCampaign.length==0){
            component.set("v.errorMessage","No Members to Combine");
        }else if(selectedCampaign.length == 0 && excludeCampaign.length>0){
            component.set("v.errorMessage","No Members to Combine");
        }else if(selectedCampaign.length > 0 && excludeCampaign.length==0){
            this.combineAdd(component,event,helper);
        }else{
            var action = component.get('c.CampaignCombinerWithAddExclude');
            action.setParams({"campaignsToAdd": selectedCampaign,
                              "campaignsToSub":excludeCampaign,
                              "targetCampId":recordId,
                              "intersectionForAdds":addIntersection,
                              "intersectionForSub":excludeIntersection,
                              "status":memberStatus
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('Combine response state-----'+state);
                if (state === "SUCCESS") {
                    console.log('----------Inside combine success state-----------');
                    console.log('response return value-----'+response.getReturnValue());
                    this.membersCountAfterCmobine(component,event,helper);
                    component.set("v.isCombined",true);
                    var successMessage = response.getReturnValue();
                    if(successMessage){
                        var succMsg = successMessage[0];
                        if(!$A.util.isUndefinedOrNull(successMessage[1])){
                            console.log('------inside null check state-----');
                            succMsg=succMsg+""+successMessage[1]; 
                        }
                        component.set("v.combinesuccessMessage",succMsg);
                        console.log('successMessage message-------'+succMsg);
                        console.log('concatinated success message----------'+succMsg);
                    }else{
                        component.set("v.combinesuccessMessage","Add and Exclude Combine Success");
                    }
                    //component.set("v.combinesuccessMessage",successMessage);
                    //console.log('success message-----'+component.get("v.combinesuccessMessage"));
                }else if (state === "ERROR") {
                    var errors = response.getError();	
                    console.log('Error message-------'+errors[0].message);
                    if(errors){
                        if (errors[0] && errors[0].message){
                            var errMsg = errors[0].message;
                            component.set("v.errorMessage",errMsg);
                        }
                        console.log('Error message-------'+errMsg);
                    }else{
                        component.set("v.errorMessage","Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);  
        }
    },
    
    helperCombineWithSelectedCampaign: function(component, event, helper){
        var recordId=component.get("v.selectedCampaignLookUpRec").Id;
        console.log('Selected Campaign record ID-----'+recordId);
        var memberStatus = component.get("v.newselectedStatus");
        console.log('selected Ids List--------'+component.get("v.multiselectedAddExistingLookUpRecords"));
        var selectedCampaign=component.get("v.multiselectedAddExistingLookUpRecords");
        console.log('selected Ids List size--------'+selectedCampaign.length);
        var excludeCampaign = component.get("v.multiselectedExcludeExistingLookUpRecords");
        var addIntersection = component.get("v.existingCampActivestatus");
        var excludeIntersection = component.get("v.existingCampExcludeStatus");
        if(selectedCampaign.length == 0 && excludeCampaign.length==0){
            component.set("v.errorMessage","No Members to Combine");
        }else if(selectedCampaign.length == 0 && excludeCampaign.length>0){
            component.set("v.errorMessage","No Members to Combine");
        }else if(selectedCampaign.length > 0 && excludeCampaign.length==0){
            this.combineSelectedAdd(component,event,helper);
        }else{
            var action = component.get('c.CampaignCombinerWithAddExclude');
            action.setParams({"campaignsToAdd": selectedCampaign,
                              "campaignsToSub":excludeCampaign,
                              "targetCampId":recordId,
                              "intersectionForAdds":addIntersection,
                              "intersectionForSub":excludeIntersection,
                              "status":memberStatus
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('Combine response state-----'+state);
                if (state === "SUCCESS") {
                    console.log('----------Inside combine success state-----------');
                    console.log('response return value-----'+response.getReturnValue());
                    this.membersCountSelectedAfterCmobine(component,event,helper);
                    component.set("v.isCombined",true);
                    var successMessage = response.getReturnValue();
                    if(successMessage){
                        var succMsg = successMessage[0];
                        if(!$A.util.isUndefinedOrNull(successMessage[1])){
                            console.log('------inside null check state-----');
                            succMsg=succMsg+""+successMessage[1]; 
                        }
                        component.set("v.combinesuccessMessage",succMsg);
                        console.log('successMessage message-------'+succMsg);
                        console.log('concatinated success message----------'+succMsg);
                    }else{
                        component.set("v.combinesuccessMessage","Add and Exclude Combine Success");
                    }
                    //component.set("v.combinesuccessMessage",successMessage);
                    //console.log('success message-----'+component.get("v.combinesuccessMessage"));
                }else if (state === "ERROR") {
                    var errors = response.getError();	
                    console.log('Error message-------'+errors[0].message);
                    if(errors){
                        if (errors[0] && errors[0].message){
                            var errMsg = errors[0].message;
                            component.set("v.errorMessage",errMsg);
                        }
                        console.log('Error message-------'+errMsg);
                    }else{
                        component.set("v.errorMessage","Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
            
        }
    },
    
    helperCombineWithNewCampaign: function(component, event, helper){
        var recordId=component.get("v.newCreatedCampaignId");
        console.log('New Campaign record ID-----'+recordId);
        var memberStatus = component.get("v.newselectedStatus");
        console.log('selected Ids List--------'+component.get("v.multiselectedAddNewLookUpRecords"));
        var selectedCampaign=component.get("v.multiselectedAddNewLookUpRecords");
        console.log('selected Ids List size--------'+selectedCampaign.length);
        var excludeCampaign = component.get("v.multiselectedExcludeNewLookUpRecords");
        var addIntersection = component.get("v.newCampActiveStatus");
        var excludeIntersection = component.get("v.newCampExcludeStatus");
        if(selectedCampaign.length == 0 && excludeCampaign.length==0){
            component.set("v.errorMessage","No Members to Combine");
        }else if(selectedCampaign.length == 0 && excludeCampaign.length>0){
            component.set("v.errorMessage","No Members to Combine");
        }else if(selectedCampaign.length > 0 && excludeCampaign.length==0){
            this.combineNewAdd(component,event,helper);
        }else{
            var action = component.get('c.CampaignCombinerWithAddExclude');
            action.setParams({"campaignsToAdd": selectedCampaign,
                              "campaignsToSub":excludeCampaign,
                              "targetCampId":recordId,
                              "intersectionForAdds":addIntersection,
                              "intersectionForSub":excludeIntersection,
                              "status":memberStatus
                             });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('Combine response state-----'+state);
                if (state === "SUCCESS") {
                    console.log('----------Inside combine success state-----------');
                    console.log('response return value-----'+response.getReturnValue());
                    this.membersCountNewAfterCmobine(component,event,helper);
                    component.set("v.isCombined",true);
                    var successMessage = response.getReturnValue();
                    if(successMessage){
                        var succMsg = successMessage[0];
                        if(!$A.util.isUndefinedOrNull(successMessage[1])){
                            console.log('------inside null check state-----');
                            succMsg=succMsg+""+successMessage[1]; 
                        }
                        component.set("v.combinesuccessMessage",succMsg);
                        console.log('successMessage message-------'+succMsg);
                        console.log('concatinated success message----------'+succMsg);
                    }else{
                        component.set("v.combinesuccessMessage","Add and Exclude Combine Success");
                    }
                    //component.set("v.combinesuccessMessage",successMessage);
                    //console.log('success message-----'+component.get("v.combinesuccessMessage"));
                }else if (state === "ERROR") {
                    var errors = response.getError();	
                    console.log('Error message-------'+errors[0].message);
                    if(errors){
                        if (errors[0] && errors[0].message){
                            var errMsg = errors[0].message;
                            component.set("v.errorMessage",errMsg);
                        }
                        console.log('Error message-------'+errMsg);
                    }else{
                        component.set("v.errorMessage","Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);  
        }
    },
    
    membersCountAfterCmobine:function(component,event,helper){
        var recordId=component.get("v.currentrecordId");
        var action = component.get('c.fetchMembersAfterCombine');
        action.setParams({"campId": recordId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('After Combine-----'+state);
            if (state === "SUCCESS") {
                console.log('response value-----'+response.getReturnValue());
                component.set("v.currentCampaignContacts",response.getReturnValue()[0].NumberOfContacts);
                component.set("v.currentCampaignLeads",response.getReturnValue()[0].NumberOfLeads);
                console.log('Number of contacts----------'+response.getReturnValue()[0].NumberOfContacts);
                console.log('Number of leads----------'+response.getReturnValue()[0].NumberOfLeads);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    },
    
    membersCountSelectedAfterCmobine:function(component,event,helper){
        var recordId=component.get("v.selectedCampaignLookUpRec").Id;
        var action = component.get('c.fetchMembersAfterCombine');
        action.setParams({"campId": recordId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('After Combine-----'+state);
            if (state === "SUCCESS") {
                console.log('response value-----'+response.getReturnValue());
                component.set("v.selectedCampaignContacts",response.getReturnValue()[0].NumberOfContacts);
                component.set("v.selectedCampaignLeads",response.getReturnValue()[0].NumberOfLeads);
                console.log('Number of contacts----------'+response.getReturnValue()[0].NumberOfContacts);
                console.log('Number of leads----------'+response.getReturnValue()[0].NumberOfLeads);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    },
    
    membersCountNewAfterCmobine:function(component,event,helper){
        var recordId=component.get("v.newCreatedCampaignId");
        var action = component.get('c.fetchMembersAfterCombine');
        action.setParams({"campId": recordId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('After Combine-----'+state);
            if (state === "SUCCESS") {
                console.log('response value-----'+response.getReturnValue());
                component.set("v.newCampaignContacts",response.getReturnValue()[0].NumberOfContacts);
                component.set("v.newCampaignLeads",response.getReturnValue()[0].NumberOfLeads);
                console.log('Number of contacts----------'+response.getReturnValue()[0].NumberOfContacts);
                console.log('Number of leads----------'+response.getReturnValue()[0].NumberOfLeads);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);            
    },
    
    combineAdd:function(component,event,helper){
        var recordId=component.get("v.currentrecordId");
        var selectedCampaign=component.get("v.multiselectedAddCurrentLookUpRecords");
        var memberStatus = component.get("v.newselectedStatus");
        var addIntersection = component.get("v.currentCampActivestatus");
        var action = component.get('c.CampaignCombinerOnlyAdd');
        action.setParams({"selectedCmp":selectedCampaign,
                          "targetCampId":recordId,
                          "intersectionForAdds":addIntersection,
                          "status":memberStatus
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Inside only Add State-----'+state);
            if (state === "SUCCESS") {
                console.log('----------Inside Add Only success state-----------');
                console.log('response return value-----'+response.getReturnValue());
                this.membersCountAfterCmobine(component,event,helper);
                component.set("v.isCombined",true);
                var successMessage = response.getReturnValue();
                if(successMessage){
                    var succMsg = successMessage[0];
                    component.set("v.combinesuccessMessage",succMsg);
                    console.log('successMessage message-------'+succMsg);
                }else{
                    component.set("v.combinesuccessMessage","Add and Exclude Combine Success");
                }
                //component.set("v.combinesuccessMessage",successMessage);
                //console.log('success message-----'+component.get("v.combinesuccessMessage"));
            }else if (state === "ERROR") {
                var errors = response.getError();	
                console.log('Error message-------'+errors[0].message);
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                    console.log('Error message-------'+errMsg);
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);         
    },
    
    combineSelectedAdd:function(component,event,helper){
        var recordId=component.get("v.selectedCampaignLookUpRec").Id;
        var memberStatus = component.get("v.newselectedStatus");
        console.log('selected Ids List--------'+component.get("v.multiselectedAddExistingLookUpRecords"));
        var selectedCampaign=component.get("v.multiselectedAddExistingLookUpRecords");
        console.log('selected Ids List size--------'+selectedCampaign.length);
        var addIntersection = component.get("v.existingCampActivestatus");
        var action = component.get('c.CampaignCombinerOnlyAdd');
        action.setParams({"selectedCmp":selectedCampaign,
                          "targetCampId":recordId,
                          "intersectionForAdds":addIntersection,
                          "status":memberStatus
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Inside only Add State-----'+state);
            if (state === "SUCCESS") {
                console.log('----------Inside Add Only success state-----------');
                console.log('response return value-----'+response.getReturnValue());
                this.membersCountAfterCmobine(component,event,helper);
                component.set("v.isCombined",true);
                var successMessage = response.getReturnValue();
                if(successMessage){
                    var succMsg = successMessage[0];
                    component.set("v.combinesuccessMessage",succMsg);
                    console.log('successMessage message-------'+succMsg);
                }else{
                    component.set("v.combinesuccessMessage","Add and Exclude Combine Success");
                }
                //component.set("v.combinesuccessMessage",successMessage);
                //console.log('success message-----'+component.get("v.combinesuccessMessage"));
            }else if (state === "ERROR") {
                var errors = response.getError();	
                console.log('Error message-------'+errors[0].message);
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                    console.log('Error message-------'+errMsg);
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);         
    },
    
    combineNewAdd:function(component,event,helper){
        var recordId=component.get("v.newCreatedCampaignId");
        var memberStatus = component.get("v.newselectedStatus");
        console.log('selected Ids List--------'+component.get("v.multiselectedAddNewLookUpRecords"));
        var selectedCampaign=component.get("v.multiselectedAddNewLookUpRecords");
        console.log('selected Ids List size--------'+selectedCampaign.length);
        var addIntersection = component.get("v.newCampActiveStatus");
        var action = component.get('c.CampaignCombinerOnlyAdd');
        action.setParams({"selectedCmp":selectedCampaign,
                          "targetCampId":recordId,
                          "intersectionForAdds":addIntersection,
                          "status":memberStatus
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Inside only Add State-----'+state);
            if (state === "SUCCESS") {
                console.log('----------Inside Add Only success state-----------');
                console.log('response return value-----'+response.getReturnValue());
                this.membersCountAfterCmobine(component,event,helper);
                component.set("v.isCombined",true);
                var successMessage = response.getReturnValue();
                if(successMessage){
                    var succMsg = successMessage[0];
                    component.set("v.combinesuccessMessage",succMsg);
                    console.log('successMessage message-------'+succMsg);
                }else{
                    component.set("v.combinesuccessMessage","Add and Exclude Combine Success");
                }
                //component.set("v.combinesuccessMessage",successMessage);
                //console.log('success message-----'+component.get("v.combinesuccessMessage"));
            }else if (state === "ERROR") {
                var errors = response.getError();	
                console.log('Error message-------'+errors[0].message);
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                    console.log('Error message-------'+errMsg);
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);         
    },
    
    
    loaddataTable : function(component, event, helper){
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            component.set("v.mycolumns", [
                {label: 'Name', fieldName: 'UniqueName__c', type:'url', 
                 typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'UniqueName__c'},target: '_blank'}},
                {label: 'Start Date', fieldName: 'StartDate', type: 'Date'},
                {label: 'Contacts in Campaign', fieldName: 'NumberOfContacts',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"},
                {label: 'Leads in Campaign', fieldName: 'NumberOfLeads',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"}
            ]);
            var records =component.get("v.multiselectedAddCurrentLookUpRecords");
            if(records.length !=0){
                records.forEach(function(record){
                    console.log('record name --------------'+record.Name);
                    record.UniqueName__c = '/'+record.Id;
                });
            }
        }else if(isSelected){
            component.set("v.mycolumns", [
                {label: 'Name', fieldName: 'UniqueName__c', type:'url', 
                 typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'UniqueName__c'},target: '_blank'}},
                {label: 'Start Date', fieldName: 'StartDate', type: 'Date'},
                {label: 'Contacts in Campaign', fieldName: 'NumberOfContacts',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"},
                {label: 'Leads in Campaign', fieldName: 'NumberOfLeads',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"}
            ]);
            var records =component.get("v.multiselectedAddExistingLookUpRecords");
            if(records.length !=0){
                records.forEach(function(record){
                    console.log('record name --------------'+record.Name);
                    record.UniqueName__c = '/'+record.Id;
                });
            }
        }else{
            component.set("v.mycolumns", [
                {label: 'Name', fieldName: 'UniqueName__c', type:'url', 
                 typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'UniqueName__c'},target: '_blank'}},
                {label: 'Start Date', fieldName: 'StartDate', type: 'Date'},
                {label: 'Contacts in Campaign', fieldName: 'NumberOfContacts',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"},
                {label: 'Leads in Campaign', fieldName: 'NumberOfLeads',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"}
            ]);
            var records =component.get("v.multiselectedAddNewLookUpRecords");
            if(records.length !=0){
                records.forEach(function(record){
                    console.log('record name --------------'+record.Name);
                    record.UniqueName__c = '/'+record.Id;
                });
            }
        }
    },
    
    loaddataTableExclude : function(component, event, helper){
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            component.set("v.mycolumns", [
                {label: 'Name', fieldName: 'UniqueName__c', type:'url', 
                 typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'UniqueName__c'},target: '_blank'}},
                {label: 'Start Date', fieldName: 'StartDate', type: 'Date'},
                {label: 'Contacts in Campaign', fieldName: 'NumberOfContacts',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"},
                {label: 'Leads in Campaign', fieldName: 'NumberOfLeads',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"}
            ]);
            var records =component.get("v.multiselectedExcludeCurrentLookUpRecords");
            if(records.length !=0){
                records.forEach(function(record){
                    console.log('record name --------------'+record.Name);
                    record.UniqueName__c = '/'+record.Id;
                });
            }
        }else if(isSelected){
            component.set("v.mycolumns", [
                {label: 'Name', fieldName: 'UniqueName__c', type:'url', 
                 typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'UniqueName__c'},target: '_blank'}},
                {label: 'Start Date', fieldName: 'StartDate', type: 'Date'},
                {label: 'Contacts in Campaign', fieldName: 'NumberOfContacts',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"},
                {label: 'Leads in Campaign', fieldName: 'NumberOfLeads',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"}
            ]);
            var records =component.get("v.multiselectedExcludeExistingLookUpRecords");
            if(records.length !=0){
                records.forEach(function(record){
                    console.log('record name --------------'+record.Name);
                    record.UniqueName__c = '/'+record.Id;
                });
            }
        }else{
            component.set("v.mycolumns", [
                {label: 'Name', fieldName: 'UniqueName__c', type:'url', 
                 typeAttributes: {label: { fieldName: 'Name' },value:{fieldName: 'UniqueName__c'},target: '_blank'}},
                {label: 'Start Date', fieldName: 'StartDate', type: 'Date'},
                {label: 'Contacts in Campaign', fieldName: 'NumberOfContacts',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"},
                {label: 'Leads in Campaign', fieldName: 'NumberOfLeads',type: 'number' , typeAttributes: "{ minimum-integer-digits='9'}"}
            ]);
            var records =component.get("v.multiselectedExcludeNewLookUpRecords");
            if(records.length !=0){
                records.forEach(function(record){
                    console.log('record name --------------'+record.Name);
                    record.UniqueName__c = '/'+record.Id;
                });
            }
        }
    },
    
    
    loadAdddataTable: function(component, event, helper){
        component.set("v.isLoadTable",true);
        this.loaddataTable(component,event,helper);
    },
    
    loadExcludedataTable: function(component, event, helper){
        component.set("v.isSelectedExclude",true);
        this.loaddataTableExclude(component,event,helper);
    },
    
    clearAddList: function(component,  index){
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            console.log('-------------Inside current status-----'+isCurrent);
            var lines = component.get("v.multiselectedAddCurrentLookUpRecords");
            var lineslength = lines.length;
            lines.splice(index,lineslength);
            component.set("v.multiselectedAddCurrentLookUpRecords", lines);
            component.set("v.isLoadTable",false);
            component.set("v.recordsClearMessage",'Records Cleared Successfully');
        }else if(isSelected){
            console.log('-------------Inside Existing status-----'+isSelected);
            var lines = component.get("v.multiselectedAddExistingLookUpRecords");
            var lineslength = lines.length;
            lines.splice(index,lineslength);
            component.set("v.multiselectedAddExistingLookUpRecords", lines);
             component.set("v.isLoadTable",false);
            component.set("v.recordsClearMessage",'Records Cleared Successfully');
        }else{
            console.log('-------------Inside New status-----'+isNew);
            var lines = component.get("v.multiselectedAddNewLookUpRecords");
            var lineslength = lines.length;
            lines.splice(index,lineslength);
            component.set("v.multiselectedAddNewLookUpRecords", lines); 
             component.set("v.isLoadTable",false);
            component.set("v.recordsClearMessage",'Records Cleared Successfully');
        }
    },
    
    clearExcludeList: function(component,  index){
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            console.log('-------------Inside current status-----'+isCurrent);
            var lines = component.get("v.multiselectedExcludeCurrentLookUpRecords");
            var lineslength = lines.length;
            lines.splice(index,lineslength);
            component.set("v.multiselectedExcludeCurrentLookUpRecords", lines);
             component.set("v.isSelectedExclude",false);
            component.set("v.recordsClearMessage",'Records Cleared Successfully');
        }else if(isSelected){
            console.log('-------------Inside Existing status-----'+isSelected);
            var lines = component.get("v.multiselectedExcludeExistingLookUpRecords");
            var lineslength = lines.length;
            lines.splice(index,lineslength);
            component.set("v.multiselectedExcludeExistingLookUpRecords", lines);
            component.set("v.isSelectedExclude",false);
            component.set("v.recordsClearMessage",'Records Cleared Successfully');
        }else{
            console.log('-------------Inside New status-----'+isNew);
            var lines = component.get("v.multiselectedExcludeNewLookUpRecords");
            var lineslength = lines.length;
            lines.splice(index,lineslength);
            component.set("v.multiselectedExcludeNewLookUpRecords", lines);  
            component.set("v.isSelectedExclude",false);
            component.set("v.recordsClearMessage",'Records Cleared Successfully');
        }
    },
    
    addSelectedWithNewCampaigns: function(component, event, helper){
        var addCampId=component.get("v.selectedCampaignCombineWithNewCampaignLookUpRec").Id;
        var action = component.get('c.loadAddition');
        action.setParams({"addcmp": addCampId,
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Addition state-----'+state);
            if (state === "SUCCESS") {
                component.set("v.isSelectedRecord",true);
                console.log("isSelectedRecord status-----"+component.get("v.isSelectedRecord"));
                console.log('Addition list----'+response.getReturnValue());
                component.set("v.listOfSelectedCampaigns",response.getReturnValue());
                console.log('add response-----'+response.getReturnValue()[0].Id);
                console.log('add response-----'+response.getReturnValue()[0].Name);
                console.log('add response-----'+response.getReturnValue()[0].NumberOfContacts);
                this.loaddataTable(component,event,helper);
            }else if (state === "ERROR") {
                var errors = response.getError();	
                if(errors){
                    if (errors[0] && errors[0].message){
                        var errMsg = errors[0].message;
                        component.set("v.errorMessage",errMsg);
                    }
                }else{
                    component.set("v.errorMessage","Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    }
})