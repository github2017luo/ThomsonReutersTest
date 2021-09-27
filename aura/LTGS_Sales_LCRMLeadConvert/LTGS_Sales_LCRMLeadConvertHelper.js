({
    doProcessing : function(component) {
        
        var disquaError = $A.get("$Label.c.ODT_LeadDisqualified");
        var trialLeadcheck = component.get("v.simpleLead.Is_Trial_Lead__c");
        var trialLeadStatus = component.get("v.simpleLead.Status");
        var lcrmLeadSegment  = component.get("v.simpleLead2.BU_Segment__c");
        var lcrmLeadIndustry = component.get("v.simpleLead2.Industry");
        var lcrmLanguagePreference = component.get("v.simpleLead.Language_Preference__c");
        var profileName = component.get("v.profileName");
        var EmailCheck = component.get("v.simpleLead.Email");
        var lcrmEmailerror = $A.get("$Label.c.LCRM_GLI_Lead_Convert"); 
        var validationMsg = [];
        
        if(trialLeadcheck && (trialLeadStatus === 'Disqualified')){
            alert(disquaError);
        }else{
            if((profileName === 'TR Sales' || profileName === 'TR Sales Ops'|| 
                profileName ==='TR Marketing' || profileName === 'TR Read Only' || 
                profileName === 'TR Sales - Lightning' ) && 
               (typeof lcrmLeadSegment === "undefined" || lcrmLeadSegment === "" ||lcrmLeadSegment === null )){
                validationMsg.push('BU Segment');
            } if((profileName === 'TR Sales' || profileName === 'TR Sales Ops'|| 
                  profileName ==='TR Marketing' || profileName === 'TR Read Only' || 
                  profileName === 'TR Sales - Lightning')&& 
                 (lcrmLeadIndustry === "" ||typeof lcrmLeadIndustry === "undefined" || lcrmLeadIndustry === null)){
                validationMsg.push('Industry');
            } if (lcrmLanguagePreference === "" || lcrmLanguagePreference === "undefined" || lcrmLanguagePreference === null){
                validationMsg.push('Language preference');
            } if (EmailCheck === "" || typeof EmailCheck === "undefined" || EmailCheck === null){
                validationMsg.push('Email');
            } 
            if(validationMsg != ''){
                var str = validationMsg.toString();
                str = str.split(",").join("\n -->");
                alert(lcrmEmailerror + '\n -->' +str);
            }else{
                var urlEvent = $A.get("e.force:navigateToURL");
                var recordId = component.get("v.recordId");    
                urlEvent.setParams({
                    "url": "/apex/LCRMConvertLead?id="+recordId
                });
                urlEvent.fire();
            }
        }
    }
    
})