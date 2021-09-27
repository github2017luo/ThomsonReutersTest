({    		
    // Call function on focus of text box
    onfocus : function(component,event,helper){       
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');        
        var getInputkeyWord = '';
    },
    // Call function on blur of text box
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    // Call function on key press event of textbox
    keyPressController : function(component, event, helper) {       
        var getInputkeyWord = component.get("v.SearchKeyWord");   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    // Clear value from parent component
    executeClearMethod:  function(component, event, helper) {
        helper.clearValue(component,event,helper);
    },
    // Clear value from Campaign lookup text field
    clearCampaign :function(component,event,heplper){
        var pillTarget = component.find("lookup-pillCampaign");
        var lookUpTarget = component.find("lookupFieldCampaign"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedCampaignRecord", {} );
        console.log('selected campaign details-----002'+component.get("v.selectedCampaignRecord").Id);   
    },
    // Clear search value after cancel
    clearSearchValueFunc : function(component,event,helper){
        helper.clearValue(component,event,helper);
    },
    // Fire event and render list after enetering search value 
    handleRecordComponentEvent : function(component, event, helper) {        
        var selectedRecordFromEvent = event.getParam("selectedRecFromEvent");
        var newlst =[];
        component.set("v.selectedCampaign" , selectedRecordFromEvent);
        console.log('selected campaign deails 001-----'+ selectedRecordFromEvent.Name);
         newlst.push(selectedRecordFromEvent);
        console.log('NewList push value------'+newlst);
        var oName = 'campaign';
        component.set("v.selectedCampaignRecord" , selectedRecordFromEvent);
            component.set("v.IconName" , "standard:campaign");  
        console.log('selected campaign deails 1-----'+ component.get("v.selectedCampaignRecord"));
        var forclose = component.find("lookup-pillCampaign");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupFieldCampaign");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
    },
    
    // Fire event and render list after enetering search value - Campaign
    handleCampaignLookUpEvent : function(component, event, helper){
        var newlst =[];
        var lookupRecId = event.getParam("campaignRecordId"); 
        var oName = 'campaign';
        var forclose = component.find("lookup-pillCampaign");
        $A.util.addClass(forclose, 'slds-hide');
        $A.util.removeClass(forclose, 'slds-show');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-open');
        $A.util.removeClass(forclose, 'slds-is-close');
        
        var lookUpTarget = component.find("lookupFieldCampaign");
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide'); 
        if(oName == 'campaign' && lookupRecId !=null && lookupRecId !='' && lookupRecId.Id !='' && lookupRecId.Id !=null){ 
            var selectedCampaignFromEvent = {Id:lookupRecId.Id , Name: lookupRecId.Name};         
            component.set("v.selectedCampaignRecord" , selectedCampaignFromEvent); 
            newlst.push(selectedCampaignFromEvent);
            console.log('selected campaign deails 2-----'+component.get("v.selectedCampaignRecord"));
            var forclose = component.find("lookup-pillCampaign");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupFieldCampaign");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
    },
})