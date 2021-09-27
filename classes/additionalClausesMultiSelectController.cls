public with sharing class additionalClausesMultiSelectController {
    public additionalClausesMultiSelectController() {
        
    }
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
        
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();
        
        if(String.isNotEmpty(value)) {
             Final String repRecordtypeId = Schema.SObjectType.APTS_Additional_Clauses__c.getRecordTypeInfosByName().get('Representative Clause').getRecordTypeId();
        	Boolean Istemplateadmin = isadmin();
             String query;
            if(Istemplateadmin){
            query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            }else{
                query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId AND RecordTypeId='+'\'' +repRecordtypeId +'\'';
            }
            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
            }
        }
        return sObjectResultList;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
        public SObJectResult() {
            
        }
    }
    
    @AuraEnabled
    public static map<String, List<SObJectResult> > getdefaultitems(String ObjectName, String fieldName, String recordid) {
        
        Final String repRecordtypeId = Schema.SObjectType.APTS_Additional_Clauses__c.getRecordTypeInfosByName().get('Representative Clause').getRecordTypeId();
        Boolean Istemplateadmin = isadmin();
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        List<SObJectResult> sObjectfulldata = new List<SObJectResult>();
        map<String, List<SObJectResult> > resultmap = new map<String, List<SObJectResult> >(); 
        
        String selectedClauses = [select APTS_Add_l_Clauses__c from Apttus_Proposal__Proposal__c where Id = :recordid].APTS_Add_l_Clauses__c;
        if(selectedClauses != null){
            list<string> selectedClausesList = selectedClauses.split(';');
            system.debug(selectedClausesList);
            
            if(selectedClausesList.size() > 0) {
                String query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' IN: selectedClausesList';
                system.debug(query);
                for(sObject so : Database.Query(query)) {
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
                }
            }
        }
        String query;
        if(Istemplateadmin){
            //query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE ' +fieldName+' NOT IN: selectedClausesList order by '+fieldName+' ASC';
             query = 'Select Id,'+fieldName+' FROM '+ObjectName+' order by '+fieldName+' ASC';
        }else{
        	//query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE RecordTypeId='+'\'' +repRecordtypeId +'\' AND' +fieldName+' NOT IN: selectedClausesList order by '+fieldName+' ASC';
        	query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE RecordTypeId='+'\'' +repRecordtypeId + '\' order by '+fieldName+' ASC';
        }
        system.debug(query);
        for(sObject so : Database.Query(query)) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectfulldata.add(new SObjectResult(fieldvalue, so.Id));
        }
        resultmap.put('searchedresult', sObjectfulldata);
        resultmap.put('savedresult', sObjectResultList);
        return resultmap;
    }
    
    private static Boolean isAdmin(){
        
        list<string> adminClausesPermList = system.label.Additional_Clauses_A.split(',');
        List<PermissionSetAssignment> permissionsetlist = [SELECT AssigneeId, PermissionSet.Name From PermissionSetAssignment 
                                                           WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name in :adminClausesPermList];
        if(permissionsetlist.Size()> 0){
            return true;
        }else{
            return false;
        }
    }
}