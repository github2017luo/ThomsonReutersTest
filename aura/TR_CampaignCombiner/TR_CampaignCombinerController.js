({ 
    doInit : function(component, event, helper){
        var recordId = component.get("v.recordId");
        component.set("v.currentrecordId",recordId);
         helper.getStatusPickList(component, event, helper);
        helper.getTypePickList(component, event, helper);
        helper.getStatusMemPickList(component, event, helper);
        console.log('I m in doint function');
        console.log('current record Id-----'+recordId);
        component.set("v.showCheckBoxModal",true);
        helper.getCurrentRecord(component, event, helper); 
    },
    
    closeCheckBoxModal: function(component,event,helper){
        component.set("v.showCheckBoxModal", false);
        if(component.get("v.currentcmpcheckboxstatus") == true){
            component.set("v.currentcmpcheckboxModal",true); 
        }
        if(component.get("v.existingcmpcheckboxstatus") == true){
            component.set("v.existingcmpcheckboxModal",true); 
        }
        if(component.get("v.newcmpcheckboxstatus") == true){
            component.set("v.newcmpcheckboxModal",true); 
        }
    },
    handlecurrentcmpcheckbox: function(component,event,helper){
        var currentcmp = component.find("currentcmp").get("v.value");
        component.set("v.currentcmpcheckboxstatus",currentcmp);
        console.log('currentcmp-----'+currentcmp);
        if(currentcmp == true){
            // component.set("v.showCheckBoxModal", false);
            component.set("v.existingcmpcheckbox", true);
            component.set("v.newcmpcheckbox", true);
        }
    },
    handleexistingcmpcheckbox: function(component,event,helper){
        var existingcmp = component.find("existingcmp").get("v.value");
        component.set("v.existingcmpcheckboxstatus",existingcmp);
        if(existingcmp== true){
            //component.set("v.showCheckBoxModal", false);
            component.set("v.currentcmpcheckbox", true);
            component.set("v.newcmpcheckbox", true);
        }
    },
    handlenewcmpcheckbox: function(component,event,helper){
        var newcmp = component.find("newcmp").get("v.value");
        component.set("v.newcmpcheckboxstatus",newcmp);
        if(newcmp== true){
            //component.set("v.showCheckBoxModal", false);
            component.set("v.currentcmpcheckbox", true);
            component.set("v.existingcmpcheckbox", true);
        }
    },
    
    handleAddCurrentCmpCheckbox: function(component,event,helper){
        var addcmp = component.find("currentCampActiveStatus").get("v.value");
        component.set("v.currentCampActivestatus",addcmp);
        console.log('Add checkbox status------'+addcmp);
    },
    
    handleExcludeCurrentCmpCheckbox: function(component,event,helper){
        var excludecmp = component.find("currentCampExcludeStatus").get("v.value");
        component.set("v.currentCampExcludestatus",excludecmp);
        console.log('Add checkbox status------'+excludecmp);
    },
    
    handleAddExistingCmpCheckbox: function(component,event,helper){
        var addcmp = component.find("selectedCampActiveStatus").get("v.value");
        component.set("v.existingCampActivestatus",addcmp);
        console.log('Add checkbox status------'+addcmp);
    },
    
    handleExcludeExistingCmpCheckbox: function(component,event,helper){
        var excludecmp = component.find("selectedCampExcludeStatus").get("v.value");
        component.set("v.existingCampExcludeStatus",excludecmp);
        console.log('Exclude checkbox status------'+excludecmp);
    },
    
    handleExcludeNewCmpCheckbox: function(component,event,helper){
        var excludecmp = component.find("newCampExcludeStatus").get("v.value");
        component.set("v.newCampExcludeStatus",excludecmp);
        console.log('Exclude checkbox status------'+excludecmp);
    },
    
    
    handleAddNewCmpCheckbox: function(component,event,helper){
        var addcmp = component.find("newCampActiveStatus").get("v.value");
        component.set("v.newCampActivestatus",addcmp);
        console.log('Add checkbox status------'+addcmp);
    },
    
    CombineWithCurrentCampaign: function(component, event, helper){
        helper.helperCombineWithCurrentCampaign(component, event, helper); 
        
    },
    
    CombineWithSelectedCampaign: function(component, event, helper){
        helper.helperCombineWithSelectedCampaign(component, event, helper); 
        
    },
    
     CombineWithNewCampaign: function(component, event, helper){
        helper.helperCombineWithNewCampaign(component, event, helper); 
        
    },
    
    CombineWithNewCampaign: function(component, event, helper){
        helper.helperCombineWithNewCampaign(component, event, helper); 
        
    },
    
    
    /*Method to handel redirect after clicking cancel button*/
    handleCancel : function(component, event,helper)
    {
        var relatedList= component.get("v.relatedList");
        if(!relatedList){
            $A.get("e.force:closeQuickAction").fire();
            event.preventDefault();
        }
        else
        {
            var recordId= component.get("v.recordId");
            var action2 = $A.get('e.force:navigateToURL');
            if(action2){
                action2.setParams({
                    "url":'/lightning/r/Campaign/'+recordId+'/view'
                });
            } 
            action2.fire();
        }
        $A.get('e.force:refreshView').fire();
    },
    
    handleCreateCampaign: function(component, event, helper){
        helper.createNewCampaign(component, event, helper);
    },
    
    
    handleName: function(component, event, helper){
        var campName = component.find("name").get("v.value");
        console.log(campName);
        console.log('event value name----'+event.getSource().get("v.value"));
        component.set("v.campName",campName);
    },
    handlevalidation: function(component, event, helper){
        helper.validation(component, event, helper);
        var validationState=component.get("v.validationState");
        if(validationState==true){
            helper.createNewCampaign(component, event, helper);
        }
    },
    
    handleStartDate: function(component, event, helper){
        var campStartDate = component.find("start").get("v.value");
        console.log(campStartDate);
        console.log('event value sdate----'+event.getSource().get("v.value"));
        component.set("v.campStartDate",campStartDate);
    },
    
    handleEndDate: function(component, event, helper){
        var campEndDate = component.find("end").get("v.value");
        console.log(campEndDate);
        console.log('event value naedate----'+event.getSource().get("v.value"));
        component.set("v.campEndDate",campEndDate);
    },
    
    handleType: function(component, event, helper){
        var selType = event.getSource().get("v.value");
        console.log('event value selType----'+event.getSource().get("v.value"));
        component.set("v.selectedType",selType);
        var campType = component.find("type").get("v.value");
        console.log(campType);
        console.log('event value type----'+event.getSource().get("v.value"));
        component.set("v.campType",campType);
    },
    
    handleStatus: function(component, event, helper){
        var selStatus = event.getSource().get("v.value");
        console.log('event value selStatus----'+event.getSource().get("v.value"));
        component.set("v.selectedStatus",selStatus);
        var campStatus = component.find("status").get("v.value");
        console.log(campStatus);
        console.log('event value naedate----'+event.getSource().get("v.value"));
        component.set("v.campStatus",campStatus);
    },
    
    handleNewStatus: function(component, event, helper){
        var newStatus = event.getSource().get("v.value");
        component.set("v.newselectedStatus",newStatus);
        console.log('New Campaign Members status value----'+newStatus);
    },
    
    getSelectedCampaign: function(component, event, helper){
        var getSelectedCampaignId = component.get("v.selectedCampaignLookUpRec").Id;
        console.log('getSelectedCampaign-----'+getSelectedCampaignId);
    },
    
    closeTableModel: function(component, event, helper){
        component.set("v.isSelectedRecord",false);
    },
    
    
    handleCombineCurrentCampaign: function(component, event, helper){
        component.set("v.CombineCurrentCampaign",true);
    },
    
    handleCombineSelectedCampaign: function(component, event, helper){
        var selectedCamp=component.get("v.selectedCampaignLookUpRec").Id;
        component.set("v.selectedCampId",selectedCamp);
        console.log('selectedcamid------'+selectedCamp);
        if(selectedCamp!=null && selectedCamp!=''){
            helper.getSelectedCampaign(component, event, helper);
            component.set("v.CombineSelectedCampaign",true);
            component.set("v.existingcmpcheckboxModal",false);
        }else{
            component.set("v.errorMessage","Please select a Target Campaign to Combine");
        }
    },
    
    handleCombineSelectedCampaignCancel: function(component, event, helper){
        component.set("v.CombineSelectedCampaign",false);
        var recordId=component.get("v.selectedCampaignLookUpRec").Id;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "recordID":recordId,
            "slideDevName":"detail",
            "url":  "/lightning/r/Campaign/"+recordId+"/view"
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    handleCombineWithSelectedCampaign: function(component, event, helper){
        helper.combineWithSelectedCampaign(component, event, helper);
    },
    
    
    handleCombineWithNewCampaign: function(component, event, helper){
        helper.combineWithNewCampaign(component, event, helper);
    },
    
    handleCombineCurrentCampaignCancel: function(component, event, helper){
        component.set("v.CombineCurrentCampaign",false);
        $A.get('e.force:refreshView').fire();
    },
    
    handleCombineWithNewCampaignCancel: function(component, event, helper){
        component.set("v.newCampaignstate",false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "recordID":component.get("v.newCreatedCampaignId"),
            "slideDevName":"detail",
            "url":  "/lightning/r/Campaign/"+component.get("v.newCreatedCampaignId")+"/view"
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    handleCurrentAdd: function(component, event, helper){
        helper.loadAdddataTable(component, event, helper);
    },
    
    handleCurrentExclude: function(component, event, helper){
        helper.loadExcludedataTable(component, event, helper);
    },
    
    
    handleNewAdd: function(component, event, helper){
        helper.addSelectedWithNewCampaigns(component, event, helper);
    },
    
        handleClear: function(component, event, helper){
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            var lines = component.get("v.multiselectedAddCurrentLookUpRecords");
            var lineslength = lines.length;
            if(lineslength!=0){
                var self = this;  // safe reference
                var index = event.target.dataset.index;
                helper.clearAddList(component, index);
                console.log('index : ' + index);
            }else{
                component.set("v.noRecordsClearMessage",'No Records to Clear');
            }
        }else if(isSelected){
            var lines = component.get("v.multiselectedAddExistingLookUpRecords");
            var lineslength = lines.length;
            if(lineslength!=0){
                var self = this;  // safe reference
                var index = event.target.dataset.index;
                helper.clearAddList(component, index);
                console.log('index : ' + index);
            }else{
                component.set("v.noRecordsClearMessage",'No Records to Clear');
            }
        }else{
            var lines = component.get("v.multiselectedAddNewLookUpRecords");
            var lineslength = lines.length;
            if(lineslength!=0){
                var self = this;  // safe reference
                var index = event.target.dataset.index;
                helper.clearAddList(component, index);
                console.log('index : ' + index);
            }else{
                component.set("v.noRecordsClearMessage",'No Records to Clear');
            }
        }
    },
    
    handleClearExclude: function(component, event, helper){
        var isCurrent=component.get("v.currentcmpcheckboxstatus");
        console.log('Current status------'+isCurrent);
        var isSelected=component.get("v.existingcmpcheckboxstatus");
        console.log('Existing status------'+isSelected);
        var isNew=component.get("v.newcmpcheckboxstatus");
        console.log('New status------'+isNew);
        if(isCurrent){
            var lines = component.get("v.multiselectedExcludeCurrentLookUpRecords");
            var lineslength = lines.length;
            if(lineslength!=0){
                var self = this;  // safe reference
                var index = event.target.dataset.index;
                helper.clearExcludeList(component, index);
                console.log('index : ' + index);
            }else{
                component.set("v.noRecordsClearMessage",'No Records to Clear');
            }
        }else if(isSelected){
            var lines = component.get("v.multiselectedExcludeExistingLookUpRecords");
            var lineslength = lines.length;
            if(lineslength!=0){
                var self = this;  // safe reference
                var index = event.target.dataset.index;
                helper.clearExcludeList(component, index);
                console.log('index : ' + index);
            }else{
                component.set("v.noRecordsClearMessage",'No Records to Clear');
            }
        }else{
            var lines = component.get("v.multiselectedExcludeNewLookUpRecords");
            var lineslength = lines.length;
            if(lineslength!=0){
                var self = this;  // safe reference
                var index = event.target.dataset.index;
                helper.clearExcludeList(component, index);
                console.log('index : ' + index);
            }else{
                component.set("v.noRecordsClearMessage",'No Records to Clear');
            }
        }
    },
    
    navigateCampaign : function(component,event,helper){
        var recId = event.getParam('row').Id;
        console.log('Inside Row Action-------');
        component.set("v.selectedtableCampaign",recId);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "recordID":component.get("v.selectedtableCampaign"),
            "slideDevName":"detail",
            "url":  "/lightning/r/Campaign/"+component.get("v.selectedtableCampaign")+"/view"
        });
        urlEvent.fire();
        $A.get('e.force:refreshView').fire();
    }

})