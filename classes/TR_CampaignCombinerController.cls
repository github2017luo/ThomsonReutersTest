/**
* @author:        Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* @company:       TCS
* @Date:          2020-01-29
* @Description:   A class to Add or Exclude CampaignMembers to the Target Campaign. 
* @see 
* changelog
*/
public with sharing class TR_CampaignCombinerController {
    
    /**
* This method is used to fetch Current Campaign Details
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the Campaign record
*/ 
    
    @AuraEnabled   
    public static List<Campaign> fetchCurrentCampaign(Id campId) {
        try{
            List<Campaign> cmp=[select id,Name,StartDate,EndDate,Status,Type,IsActive,ParentId,NumberOfContacts,NumberOfLeads,OwnerId from Campaign where id=: campId];
            system.debug('The campaign value-----'+cmp);
            if(!cmp.isEmpty()){
                return cmp;
            }
            if(Test.isRunningTest()){
                throw new CalloutException();
            }
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
        return null; 
    } 
    
    /**
* This method is used to fetch the Selected Campaign Details
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the selected Campaign Record
*/ 
    
    @AuraEnabled   
    public static List<Campaign> fetchSelectedCampaign(Id campId) {
        try{
            List<Campaign> cmp=[select id,Name,StartDate,EndDate,Status,Type,IsActive,ParentId,NumberOfContacts,NumberOfLeads,OwnerId from Campaign where id=: campId];
            system.debug('The campaign value-----'+cmp);
            if(!cmp.isEmpty()){
                return cmp;
            }
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
        return null; 
    }
    
    /**
* This method is used to fetch New Campain Details
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the new Campaign Record
*/
    
    @AuraEnabled   
    public static List<Campaign> fetchNewCampaign(Id campId) {
        try{
            List<Campaign> cmp=[select id,Name,StartDate,EndDate,Status,Type,IsActive,ParentId,NumberOfContacts,NumberOfLeads,OwnerId from Campaign where id=: campId];
            system.debug('The campaign value-----'+cmp);
            if(!cmp.isEmpty()){
                return cmp;
            }
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
        return null; 
    } 
    
    /**
* This method is used to fetch the Number of Contacts and Leads after Combvining the Campaigns
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the campaign record
*/
    
    @AuraEnabled   
    public static List<Campaign> fetchMembersAfterCombine(Id campId) {
        try{
            List<Campaign> cmp=[select id,NumberOfContacts,NumberOfLeads from Campaign where id=: campId];
            system.debug('The campaign value-----'+cmp);
            if(!cmp.isEmpty()){
                return cmp;
            }
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
        return null; 
    } 
    
     /**
* This method is used to fetch Campaign Status Dynamically
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the Campaign status picklist values
*/ 

      @AuraEnabled
    public static Map<String, String> getStatusPickList(){
        Map<String, String> options = new Map<String, String>();
        //get Campaign language Field Describe
        Schema.DescribeFieldResult fieldResult = Campaign.Status.getDescribe();
        //get Campaign language Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }

              return options;  
}
    
      /**
* This method is used to fetch CampaignMember Status Picklist Values Dynamically
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the CampaignMember Status Picklist Values
*/ 
    
     @AuraEnabled
    public static Map<String, String> getStatusMemPickList(){
        Map<String, String> options = new Map<String, String>();
        //get Campaign language Field Describe
        Schema.DescribeFieldResult fieldResult = CampaignMember.Status.getDescribe();
        //get Campaign language Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
              return options;  
}
    
    /**
* This method is used to fetch Campaign Type Picklist Values Dynamically
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the Campaign Type Picklist Values
*/ 
    
    @AuraEnabled
    public static Map<String, String> getTypePickList(){

        Map<String, String> options = new Map<String, String>();
        //get Campaign language Field Describe
        Schema.DescribeFieldResult fieldResult = Campaign.Type.getDescribe();
        //get Campaign language Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
              return options;             
}
    
    /**
* This method is used to fetch the Campaign Owner
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the Owner details
*/
    
    @AuraEnabled   
    public static User fetchCampaignOwner(Id ownerId) {
        try{
            User usr=[select id,Name from User where id=: ownerId];
            system.debug('The User value-----'+usr);
            if(usr!=null){
                return usr;
            }
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
        return null; 
    } 
    
        /**
* This method is used to fetch the Campaign Parent
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-02-05
* @return   returns the Owner details
*/
    
    @AuraEnabled   
    public static List<Campaign> fetchCampaignParent(Id parentId) {
        try{
            List<Campaign> pcmp=[select id,Name from Campaign where id=:parentId];
            system.debug('The Parent value-----'+pcmp);
            if(pcmp!=null){
                return pcmp;
            }
        }
        catch(Exception err){
            throw new AuraHandledException(err.getMessage());
        }
        return null; 
    } 
    
    
    /**
* This method is used to create new Campaign
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the Id of new Campaign
*/
    
    @AuraEnabled
    public static List<String> campaignCreate(String CampaignName,Date StartDate,Date EndDate,String Type,String Status) {
        try{
            List<String> result = new List<String>();
            campaign newCampaign = new campaign();
            newCampaign.Name = CampaignName;
            newCampaign.StartDate=StartDate;
            newCampaign.EndDate=EndDate;
            newCampaign.Type=Type;
            newCampaign.Status=Status;
            insert newCampaign;
            if(newCampaign.Id!=null){
                result.add(newCampaign.Id);
                result.add('Success');
                return result;
            }
        }catch (exception e) {
            throw new AuraHandledException(e.getMessage());					
        }
        return null;
    }	
    
    /**
* This method is used to combine Campaigns if there are no members to Exclude
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the count of Contacts and Leads after Combining
*/
    @AuraEnabled 
    public static List<String> CampaignCombinerOnlyAdd(List<Campaign> selectedCmp,Id targetCampId,Boolean intersectionForAdds,String status){
        Integer maxCount = 1000;
        String resultMessage;
        Integer membersAdded;
        list<campaignMember> membersToAdd = new list<campaignMember>();
        list<campaignMember> existingMembers = new list<campaignMember>();
        list<sobject> membersToAddC = new list<campaignMember>();
        list<sobject> membersToAddL = new list<campaignMember>();
        List<String> result = new List<String>();
        set<Id> addSet = new set<Id>();
        set<id> existingCons = new set<id>();
        set<id> existingLeads = new set<id>();
        set<Id> allCampaignIds = new set<Id>{targetCampId};
            if (!selectedCmp.isEmpty()) {
                for (campaign c : selectedCmp) {
                    addSet.add(c.id);
                    allCampaignIds.add(c.id);
                }
                // get existing lead and contact ids from the target campaign, so we can avoid dupes
                existingMembers = [select id, contactid, leadId from campaignmember 
                                   where campaignid = : targetCampId and
                                   (contactId != null or lead.isConverted = false)];
                
                for (campaignMember cm : existingMembers) {
                    if (cm.contactId != null) existingCons.add(cm.contactId);
                    if (cm.leadId != null) existingCons.add(cm.leadId);
                }
                
                if (intersectionForAdds) {
                    // get ids of contacts and lead that are in all selected campaigns to add
                    integer siz = addSet.size();
                    
                    membersToAddC=[select contactId from campaignmember where campaignId in : addSet and contactId != null 
                                   and contactId not in : existingCons group by contactId having count_distinct(campaignId) = : siz];
                    
                    system.debug('members to addc--------'+membersToAddC);
                    
                    membersToAddL=[select leadId from campaignmember where campaignId in : addSet and leadId != null 
                                   and leadId not in : existingLeads and lead.isConverted = false 
                                   group by leadId having count_distinct(campaignId) = : siz];
                    system.debug('members to addl--------'+membersToAddL);
                    
                } else {
                    // get ids of contacts and lead that are in any of the selected campaigns to add
                    membersToAddC =[select contactid from campaignmember where contactid != null 
                                    and contactid not in : existingCons
                                    and campaignid in : addSet group by contactid];
                    
                    system.debug('membersToAddC======='+membersToAddC);
                    
                    membersToAddL =[select leadid from campaignmember where leadId != null 
                                    and leadid not in : existingLeads
                                    and lead.isConverted = false
                                    and campaignid in : addSet group by leadid];
                    system.debug('membersToAddL======='+membersToAddL);
                }
                // create new member records to add to the target campaign
                for (sobject cm : membersToAddC) {
                    // bail out if there are too many
                    //if (membersToAdd.size() == maxCount) break;
                    membersToAdd.add(
                        new CampaignMember(
                            campaignId = targetCampId,
                            contactId = (id)(cm.get('contactId')),
                            status = status
                        )
                    );
                }
                for (sobject cm : membersToAddL) {
                    // bail out if there are too many
                    //if (membersToAdd.size() == maxCount) break;
                    membersToAdd.add(
                        new CampaignMember(
                            campaignId = targetCampId,
                            leadId = (id)(cm.get('leadId')),
                            status = status
                        )
                    );
                }
            }
        if (membersToAdd.isEmpty()) {
            //result.add('Error'); 
            result.add('No members to add or remove.');
        }else{
            
             try {
                    // resultMessage = '';
                    
                    if (!membersToAdd.isEmpty()) {
                        insert membersToAdd;				
                        membersAdded = membersToAdd.size();
                        resultMessage = 'Added ' + membersAdded.format() + ' campaign member' + ((membersAdded==1) ? '. ' : 's. ');
                        result.add(resultMessage);
                    }
                   
                }catch (exception e) {
                    resultMessage = null;
                    result.add( resultMessage );
                    throw new AuraHandledException(e.getMessage());
                }
            
        }	       
        return result;
    }
    
    /**
* This method is used to Combine the Campaign Members based on the add and substract intersection criteria
* <p>since 48.0 (Force.com ApiVersion)</p>
* <p>
* changelog
* <br> - Jayanth Kumar <jayanth.kumar@thomsonreuters.com>
* <br> -- Created
* </p>
* @author   Jayanth Kumar
* @date     2020-01-29
* @return   returns the message indicating the number of contacts and leads added or removed
*/
    
    @AuraEnabled 
    public static List<String> CampaignCombinerWithAddExclude(List<Campaign> campaignsToAdd,List<Campaign> campaignsToSub,Id targetCampId,Boolean intersectionForAdds,Boolean intersectionForSub,String status){
        Integer maxCount = 1000;
        String resultMessage;
        Integer membersAdded;
        Integer membersRemoved;
        List<String> result = new List<String>();
        if (campaignsToAdd.isEmpty() || campaignsToSub.isEmpty()) {
            //result.add('Error');
            result.add('No members to combine');	
        }else{
            set<Id> allCampaignIds = new set<Id>{targetCampId};
                set<Id> addSet = new set<Id>();
            set<Id> subtractSet = new set<Id>();
            for (campaign c : campaignsToAdd) {
                addSet.add(c.id);
                allCampaignIds.add(c.id);
            }
            for (campaign c : campaignsToSub) {
                subtractSet.add(c.id);
                allCampaignIds.add(c.id);
            }
            list<sobject> membersToAvoidC = new list<campaignMember>();
            list<sobject> membersToAvoidL = new list<campaignMember>();
            set<id> avoidSetC = new set<id>();
            set<id> avoidSetL = new set<id>();
            
            list<campaignMember> membersToRemove = new list<campaignMember>();
            list<campaignMember> membersToAdd = new list<campaignMember>();
            
            if (!subtractSet.isEmpty() && subtractSet != null) {
                if (intersectionForSub) {
                    system.debug('inside substratction set----'+intersectionForSub);
                    // get ids of contacts and lead that are in all selected campaigns to exclude
                    integer siz = subtractSet.size();
                    membersToAvoidC=[select contactid from campaignmember where contactid != null
                                     and campaignid in : subtractSet group by contactid having count_distinct(campaignid) = : siz];
                    system.debug('members to Avoidc--------'+membersToAvoidC);
                    
                    membersToAvoidL=[select leadid from campaignmember where leadId != null and campaignid in : subtractSet
                                     and lead.isConverted = false group by leadid having count_distinct(campaignid) = : siz];
                    system.debug('members to AvoidL--------'+membersToAvoidL);
                } else {
                    // get ids of contacts and lead that are in any of the selected campaigns to exclude
                    membersToAvoidC=[select contactid from campaignmember where contactid != null
                                     and campaignid in : subtractSet group by contactid];
                    system.debug('members to Avoidc--------'+membersToAvoidC); 
                    
                    membersToAvoidL =[select leadid from campaignmember where leadId != null and campaignid in : subtractSet 
                                      and lead.isConverted = false group by leadid];
                    system.debug('members to AvoidL--------'+membersToAvoidL);
                } 
                // add the ids to sets
                for (sobject cm : membersToAvoidC) avoidSetC.add((id)(cm.get('contactId')));
                for (sobject cm : membersToAvoidL) avoidSetL.add((id)(cm.get('leadId')));
                
                // get members of the target campaign that we want to remove
                membersToRemove = [select id from campaignmember where campaignid = : targetCampId 
                                   and (contactId in : avoidSetC or leadId in :avoidSetL)];
            }
            list<campaignMember> existingMembers = new list<campaignMember>();
            list<sobject> membersToAddC = new list<campaignMember>();
            list<sobject> membersToAddL = new list<campaignMember>();
            set<id> existingCons = new set<id>();
            set<id> existingLeads = new set<id>();
            
            if (!addSet.isEmpty()) {
                // get existing lead and contact ids from the target campaign, so we can avoid dupes
                existingMembers = [select id, contactid, leadId from campaignmember 
                                   where campaignid = : targetCampId and
                                   (contactId != null or lead.isConverted = false)];
                
                for (campaignMember cm : existingMembers) {
                    if (cm.contactId != null) existingCons.add(cm.contactId);
                    if (cm.leadId != null) existingCons.add(cm.leadId);
                }
                
                if (intersectionForAdds) {
                    // get ids of contacts and lead that are in all selected campaigns to add
                    integer siz = addSet.size();
                    
                    membersToAddC=[select contactId from campaignmember where campaignId in : addSet and contactId != null 
                                   and contactId not in : existingCons and contactId not in : avoidSetC group by contactId having count_distinct(campaignId) = : siz];
                    
                    system.debug('members to addc--------'+membersToAddC);
                    
                    membersToAddL=[select leadId from campaignmember where campaignId in : addSet and leadId != null 
                                   and leadId not in : existingLeads and leadId not in : avoidSetL and lead.isConverted = false 
                                   group by leadId having count_distinct(campaignId) = : siz];
                    system.debug('members to addl--------'+membersToAddL);
                    
                } else {
                    // get ids of contacts and lead that are in any of the selected campaigns to add
                    membersToAddC =[select contactid from campaignmember where contactid != null 
                                    and contactid not in : existingCons and contactid not in : avoidSetC
                                    and campaignid in : addSet group by contactid];
                    
                    system.debug('membersToAddC======='+membersToAddC);
                    
                    membersToAddL =[select leadid from campaignmember where leadId != null 
                                    and leadid not in : existingLeads and leadid not in : avoidSetL
                                    and lead.isConverted = false
                                    and campaignid in : addSet group by leadid];
                    system.debug('membersToAddL======='+membersToAddL);
                }
                // create new member records to add to the target campaign
                for (sobject cm : membersToAddC) {
                    // bail out if there are too many
                   // if (membersToAdd.size() == maxCount) break;
                    membersToAdd.add(
                        new CampaignMember(
                            campaignId = targetCampId,
                            contactId = (id)(cm.get('contactId')),
                            status = status
                        )
                    );
                }
                for (sobject cm : membersToAddL) {
                    // bail out if there are too many
                   // if (membersToAdd.size() == maxCount) break;
                    membersToAdd.add(
                        new CampaignMember(
                            campaignId = targetCampId,
                            leadId = (id)(cm.get('leadId')),
                            status = status
                        )
                    );
                }
            }
            
            if (membersToAdd.isEmpty() && membersToRemove.isEmpty()) {
                //result.add('Error'); 
                result.add('No members to add or remove.');
            }else{
                try {
                        // resultMessage = '';
                        
                        if (!membersToAdd.isEmpty()) {
                            insert membersToAdd;				
                            membersAdded = membersToAdd.size();
                            resultMessage = 'Added ' + membersAdded.format() + ' campaign member' + ((membersAdded==1) ? '. ' : 's. ');
                            result.add(resultMessage);
                        }
                        if (!membersToRemove.isEmpty()) {
                            delete membersToRemove;
                            membersRemoved = membersToRemove.size();
                            resultMessage = 'Removed ' + membersRemoved.format() + ' campaign member' + ((membersRemoved==1) ? '.' : 's.');	
                            result.add( resultMessage );
                        }
                        if (resultMessage == '' || resultMessage == null) {
                            resultMessage = 'No members to add or remove.';
                            result.add( resultMessage );
                        }
                        
                    } catch (exception e) {
                        resultMessage = null;
                        result.add( resultMessage );
                        throw new AuraHandledException(e.getMessage());
                    }
            }
        }    
        return result; 
    }
}