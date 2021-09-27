public class ESC_HPQ_SOQLBuilderController {
    public String selectedField {get;set;}
    public String previewQuery {get;set;}
    public String relatedfield {get;set;}
    public boolean hasError {get; set;}
    public String firstFilter {get;set;}
    public String secondFilter {get;set;}
    public string Operator {get;Set;}
     static String jsonMapRec;
    public List<selectoption> relatedOptions {get;set;}
    public list<selectoption> filterList {get;set;}
    public String selectedFieldType{get;set;}
    public string selectedFilterType{get;set;}
    public List<SelectedFieldsWrapper> selectedFields{get;private set;}
    public string selectedFilterFieldAPI{get;set;}
    public boolean isDisabled {get; set;}
    public boolean showRefresh {get; set;}
    public string isValidQuery{get; set;}
    public String sortCriteria {get;set;}
    Map<string, schema.SObjectType> gd = Schema.getGlobalDescribe(); 
    private Schema.SObjectType objectType = null;
    private Map<string, Schema.SObjectField> fieldsMap = null;
    public ESC_HomePageQuery__c thisRecord{get;set;}
    public ESC_DataTableEntity dte {get; set;}
    private transient Map<string,List<PicklistWrapper>> pickListOpns = new Map<string,List<PicklistWrapper>>();
    List<PicklistWrapper> originObjectPL = new List<PicklistWrapper>();    
    public pageReference Validate(){
        try{
            Database.query(previewQuery);
            isValidQuery = 'mystyleValid';
        }
        catch(exception ex){
            isValidQuery = 'mystyleInvalid';
        }
        return null;
    }
    public void refreshNow(){
    }
    public pageReference SaveFinal(){
        try{
            List<string> returnedNames = new List<string>();
            List<string> truncationList = new List<string>();
            List<string> labelList = new List<string>();
            List<string> returnedsecondaryNames = new List<string>();
            
            for(SelectedFieldsWrapper sf:selectedFields){
                if(sf.showRemove){
                    if(string.isNotBlank(sf.truncateValue)){
                        string truncPair = sf.fieldAPI + ':'+sf.truncateValue ;
                        truncationList.add(truncPair);
                    }
                    if(string.isNotBlank(sf.overrideLabel)){
                        string labelPapir = sf.fieldAPI + ':'+sf.overrideLabel ;
                        labelList.add(labelPapir);
                    }

                    returnedNames.add(sf.fieldAPI);
                    
                    if(sf.showInMiniLayout){
                        returnedsecondaryNames.add(sf.fieldAPI);
                    }
                }
                else if(sf.fieldAPI.equalsIgnoreCase(thisRecord.ESC_DefaultSortCol__c)){
                    thisRecord.ESC_DefaultSortCol__c = '';
                }
            }
            thisRecord.ESC_NoTruncation__c = string.join(truncationList,',');
            thisRecord.ESC_OverrideLabelsForfields__c = string.join(labelList,',');
            thisRecord.ESC_ReturnedColumns__c = string.join(returnedNames,',');
            thisRecord.ESC_ReturnedSecondaryColumns__c = string.join(returnedsecondaryNames,',');
            update(thisRecord);
            populateSelectedValues();
            populateTruncations();
            populateOverrideLabels();
            isDisabled = false;
            if(selectedFields !=null && selectedFields.size()>0)
                selectedFields.sort();
            formQuery();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Save Successful'));
            // showRefresh = true;
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getmessage()));
            showRefresh = false;
        }
        return null;
    }
    public void formQuery2(){
        previewQuery = 'select ';
        List<string> toBeSelected = new List<string>();
        for(SelectedFieldsWrapper sf:selectedFields){
            if(sf.showRemove)
                toBeSelected.add(sf.fieldAPI);
        }
        string ff =getFinalFilter(thisRecord , false);
        previewQuery = string.isNotBlank(ff) ? previewQuery + ' '+string.join(toBeSelected, ',')+' from '+thisRecord.ESC_ObjectType__c +' where '+ff
                :previewQuery + ' '+string.join(toBeSelected, ',')+' from '+thisRecord.ESC_ObjectType__c;
        previewQuery += ' Limit 1';
    }
    public void formQuery(){
        showRefresh = false;
        isValidQuery = '';
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Form Query Called'+sortCriteria));
        Map<String, Object> newOrder;
        if(string.isNotBlank(sortCriteria)){
            newOrder =  (Map<String, Object>) JSON.deserializeUntyped(sortCriteria);
            ////system.debug(newOrder);
        }
        previewQuery = 'select ';
        List<string> toBeSelected = new List<string>();
        if(selectedFields !=null){
            selectedFields.sort();
            for(SelectedFieldsWrapper sf:selectedFields){
                ////system.debug(sf);
                if(string.isNotBlank(sortCriteria) && string.isNotBlank(string.valueOf(newOrder.get(string.valueOf(sf.sequenceValue))))){
                    ////system.debug('old Seq'+sf.sequenceValue);
                    sf.sequenceValue = integer.valueOf(newOrder.get(string.valueOf(sf.sequenceValue)));
                     if(string.isNotBlank(thisRecord.ESC_DefaultSortCol__c) && thisRecord.ESC_DefaultSortCol__c.equalsIgnoreCase(sf.fieldAPI) )
                        sf.defaultSortBy = true;
                        else
                        sf.defaultSortBy = false;
                    ////system.debug('New Seq'+sf.sequenceValue);
                }
            }
            ////system.debug(selectedFields);
            selectedFields.sort();
            ////system.debug(selectedFields);
            for(SelectedFieldsWrapper sf:selectedFields){
                if(sf.showRemove)
                    toBeSelected.add(sf.fieldAPI);
            }
            string ff =getFinalFilter(thisRecord,false);
            previewQuery = string.isNotBlank(ff) ? previewQuery + ' '+string.join(toBeSelected, ',')+' from '+thisRecord.ESC_ObjectType__c +' where '+ff
                    :previewQuery + ' '+string.join(toBeSelected, ',')+' from '+thisRecord.ESC_ObjectType__c;
        }
        previewQuery += ' Limit 1';
        sortCriteria = '';
    }
    string getFinalFilter(ESC_HomePageQuery__c esc , boolean isSubQuery){
        string filterCriteria= '';
        integer limitOfRecords = 1;
        string query='';
        string addCriteria = '';
        if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Current User Only')){
            filterCriteria= esc.ESC_FilterCriteria__c;
            addCriteria = 'OwnerId = \''+getOwners(true)+'\'';
            addCriteria = string.isNotBlank(esc.ESC_FilterCriteria__c)? (' and '+ addCriteria) : (addCriteria) ;
        }
        else if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Current User\'s Queue')){
            filterCriteria= esc.ESC_FilterCriteria__c;
            string mergedIDs = getOwners(false);
            if(string.isNotBlank(mergedIDs)){
                addCriteria = 'OwnerId in ('+mergedIDs+')';
                addCriteria = string.isNotBlank(esc.ESC_FilterCriteria__c)? (' and '+ addCriteria) : (addCriteria) ;
            }

        }
        else if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Enhanced')){
            addCriteria = esc.ESC_FilterCriteria__c;
            addCriteria = addCriteria.replace('%user%', '\''+getOwners(true)+'\'').replace('%queue%', getOwners(false));
            addCriteria = subQueryResults(addCriteria);
        }
         else if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Approval Process')){
             if(string.isNotBlank(esc.ESC_FilterCriteria__c))
              addCriteria = esc.ESC_FilterCriteria__c;
                String temp;
                String jsonMapRecs =gettargetobjectlst(esc.ESC_ObjectType__c);
                if(jsonMapRecs!=''){
                    Map<Id,List<Id>> jsonMapRec = (Map<Id,List<Id>>)JSON.deserialize(jsonMapRecs, Map<Id,List<Id>>.class);
                    temp = '';

                    for(Id recid:jsonMapRec.keyset()){
                        String temp1 = '\''+recid+'\'';
                        temp = temp!=''?temp+','+temp1:temp1;
                    }
                }
                 if(string.isNotBlank(temp)){
                addCriteria += ' Id in ('+temp+')';
               
                }
                

            }
        if(string.isNotBlank(addCriteria)){
            if(string.isBlank(filterCriteria))
                filterCriteria= addCriteria;
            else
                filterCriteria+= ' '+ addCriteria;
        }
        if(!isSubQuery && esc.ESC_ObjectType__c.equalsIgnoreCase('case') && string.isNotBlank(esc.ESC_ReturnedColumns__c) &&  esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_UPD__c') != -1 )
        {
            esc.ESC_ReturnedColumns__c +=',ESC_UPD_Action__c';
        }

        return filterCriteria;
    }
 public String  getObjectPrefixID(String objName){
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        system.debug('==>m is==>'+m);
        Schema.SObjectType s = m.get(objName) ;
        system.debug('==>Sobject Type is ==>'+s);
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        return keyPrefix;
    }
public  String gettargetobjectlst( String objType){
        List<ProcessInstance> lstpinst = new List<ProcessInstance>();
        List<ProcessInstanceWorkitem> lstpwitem = new List<ProcessInstanceWorkitem>();
        Set<String> setpInstance = new Set<String>();
        Set<String> setacct = new Set<String>();
        Map<Id,List<Id>> mapRecs = new Map<Id,List<Id>>();
        jsonMapRec = '';
        string currentUserId = userinfo.getUserId();
        string queueIDS = getOwners(false);
        string setOfOwners = '(\'' +currentUserId+'\',' + queueIDS +')';
        string queryP = 'SELECT Id,ActorId,OriginalActorId,CreatedDate,ProcessInstanceId,CreatedById FROM ProcessInstanceWorkitem where (ActorId in '+setOfOwners+ ' or OriginalActorId in '+setOfOwners+ ')';
        lstpwitem = Database.query(queryP);
        if(lstpwitem.size()>0){
            for(ProcessInstanceWorkitem item:lstpwitem){
                setpInstance.add(item.ProcessInstanceId);
            }

            if(setpInstance.size()>0){
                lstpinst= [select id,targetobjectid,status,(SELECT Id FROM workitems) from ProcessInstance where id IN :setpInstance];
                for(ProcessInstance pi:lstpinst){
                    if(getObjectPrefixID(objType) == String.valueof(pi.targetobjectid).left(3)){
                        for(ProcessInstanceWorkitem pwitems:pi.workitems){
                            if(!mapRecs.containskey(pi.targetobjectid)){
                                mapRecs.put(pi.targetobjectid, new List<Id>{pwitems.id});
                            }else{
                                mapRecs.get(pi.targetobjectid).add(pwitems.id);
                            }
                        }

                    }
                }
            }
            if(mapRecs.size()>0){
                jsonMapRec = JSON.serialize(mapRecs);
            }
        }

        return jsonMapRec;
        //Use below code to deserialize in called method to make it back to map
        // Map<Id,List<Id>> jsonMapRec = (Map<Id,List<Id>>)JSON.deserialize(jsonMapRec, Map<Id,List<Id>>.class);

    }
    string getSubQuery(string homePageQueryName){
         ESC_HomePageQuery__c subQueryRec = [select ESC_ObjectType__c,ESC_ReturnedColumns__c,ESC_NoTruncation__c,ESC_AssignedTo__c,ESC_DefaultSortCol__c,
            ESC_OverrideLabelsForfields__c,ESC_FilterCriteria__c,ESC_ReturnedSecondaryColumns__c from ESC_HomePageQuery__c where name = : homePageQueryName][0];
         string querySub = getFinalFilter(subQueryRec , true);
         querySub = 'select '+ subQueryRec.ESC_ReturnedColumns__c +' from '+subQueryRec.ESC_ObjectType__c+' where '+querySub;
          system.debug('querySub' +querySub);
         List<sObject> resultsSub = Database.query(querySub);
        set<string> idsSet = new set<string>();
        idsSet.add('\'xxxxxxxxxxxxxxxxxx\'');
        for(sObject sobj1:resultsSub){
           string valueOfR = (String)sobj1.get(subQueryRec.ESC_ReturnedColumns__c) ;
          if(string.isNotBlank(valueOfR))
            idsSet.add('\''+  valueOfR +'\'');
        }
            
           
            return string.join(new List<string>(idsSet), ','); 
     }
     
    public  string subQueryResults(string crit){
        try{
         string ptString = '%Query=';
        /*if(crit.contains(ptString)){
           
            string[] splitted = crit.split(ptString);
            system.debug(splitted);
            for(Integer count=0;count < =splitted.size();count++){
                if(Math.Mod(count,2) !=0){
                    string queryName = splitted[count].substringBefore('%');
                    string idSet = getSubQuery(queryName);
                    crit  = crit.replace(ptString+queryName+'%',idSet);
                }
            }
        } */
        while(crit.contains(ptString)){
            string queryName = crit.substringBetween(ptString,'%');
            string idSet = getSubQuery(queryName);
             crit  = crit.replace(ptString+queryName+'%',idSet);
        }
        }
        catch(exception ex){
            
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while executing subquery field: '+ex.getmessage()));
        }
        return crit;
    }
    @testvisible private string getOwners(Boolean isUser){
        if(isUser)
            return UserInfo.getUserId();
        List<string> QueueIDsList  = new List<string>();
        for(GroupMember queuIDs : [Select Group.ID from GroupMember where UserOrGroupId = :UserInfo.getUserId() and Group.Type = 'Queue']){
            string queuID  ='\''+ queuIDs.GroupID+'\'';
            QueueIDsList.add(queuID);
        }
        string mergedIDs ='';
        if(QueueIDsList.size() ==0){
            QueueIDsList.add('\'xxxxxxxxxxxxxxxxxx\'');
        }
        mergedIDs = string.join(QueueIDsList, ',');
        return mergedIDs;
    }
    public string getDataTableEntity(){
        List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
        dteList.add(dte);
        return JSON.serialize(dteList);
    }
    public class SelectedFieldsWrapper implements Comparable{
        public String fieldAPI {get;set;}
        public String fieldDisplayName{get;set;}
        public String overrideLabel{get;set;}
        public Boolean defaultSortBy{get; set;}
        public String truncateValue{get;set;}
        public integer sequenceValue{get;set;}
        public boolean showRemove{get; set;}
        public boolean showInMiniLayout {get;set;}
        public string objectNameMain;
        public SelectedFieldsWrapper(string objectNameMain){
            showRemove = true;
            showInMiniLayout = false;
            this.objectNameMain = objectNameMain;
            this.defaultSortBy = false;
        }
      
            public void populateFieldValue(String fld, String objectName){
            try{ 
                system.debug('populateFieldValue called'+fld);
                fld =fld.trim();
                if(String.isBlank(fld)) return;
                this.fieldAPI = fld;
                String fldLabel = fld;
                 Map<string,string> relationNames = ESC_ObjectSchemaHelper.getObjectNamesUsed(objectNameMain);
                 system.debug('relationNames'+JSON.serialize(relationNames));
                Schema.DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objectName).getDescribe();
                Map<String, Schema.SObjectField> fieldsMap = obj.fields.getMap();
                if(fld.contains('.')){
                    // --c or normalStandard
                    if(!fld.contains('__r')){                   
                        objectName = fld.substringBefore('.');
                        if(objectName.indexOf('__') ==-1 && relationNames.containsKey(objectName.toLowerCase())){
                          
                         objectName = relationNames.get(objectName.toLowerCase());
                        }
                         system.debug(objectName);
                        obj = Schema.getGlobalDescribe().get(objectName).getDescribe();
                         
                        fieldsMap = obj.fields.getMap();
                    }
                    else{ 
                        objectName = fld.substringBefore('.').replace('__r','__c');
                        if(fieldsMap.containsKey(objectName)){
                            for(SObjectType  o: fieldsMap.get(objectName).getDescribe().getReferenceTo()){
                                obj = o.getDescribe();
                                fieldsMap = obj.fields.getMap();
                                break;
                            }
                        }
                    }
                    fldLabel = fld.substringAfter('.');                
                }
                if(fieldsMap.containsKey(fldLabel))
                this.fieldDisplayName = obj.getLabel() + ' - ' + fieldsMap.get(fldLabel).getDescribe().getLabel();
                else
                this.fieldDisplayName = obj.getLabel() + ' - ' + fldLabel;
           }
            catch(exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error with field: '+fld+' for object: '+objectName+'||'+ex.getmessage()));
            }
        }
        

        public Integer compareTo( Object obj){
            SelectedFieldsWrapper sfw = (SelectedFieldsWrapper ) obj;
            if(this.sequenceValue < sfw.sequenceValue)
                return -1;
            else if(this.sequenceValue > sfw.sequenceValue)
                return 1;
            return 0;
        }
    }
    public ESC_HPQ_SOQLBuilderController(ApexPages.StandardController controller) {
       if(!Test.isRunningTest()){
        controller.addFields(new List<String>{'ESC_ObjectType__c','ESC_DefOrder__c','ESC_ReturnedColumns__c','ESC_NoTruncation__c','ESC_AssignedTo__c','ESC_DefaultSortCol__c',
            'ESC_OverrideLabelsForfields__c','ESC_FilterCriteria__c','ESC_ReturnedSecondaryColumns__c'});
              thisRecord = (ESC_HomePageQuery__c) controller.getRecord();
       }
       else{
           ID id=((ESC_HomePageQuery__c) controller.getRecord()).id;
           
            thisRecord = [select ESC_ObjectType__c,ESC_DefOrder__c,ESC_ReturnedColumns__c,ESC_NoTruncation__c,ESC_AssignedTo__c,ESC_DefaultSortCol__c,ESC_OverrideLabelsForfields__c,ESC_FilterCriteria__c,ESC_ReturnedSecondaryColumns__c from ESC_HomePageQuery__c where id=:id ];
       }
      
        selectedFields = new List<SelectedFieldsWrapper>();
        dte = new ESC_DataTableEntity();
        populateSelectedValues();
        isDisabled = false;
        if(selectedFields !=null && selectedFields.size()>0)
            selectedFields.sort();
        formQuery();
        showRefresh = false;
        getAllPickListOptions();
       // showInMiniLayout = false;
    }
    private void populateObjectData(){
        if(thisRecord.ESC_ObjectType__c == null) return;
        if(objectType == null){
            objectType = gd.get(thisRecord.ESC_ObjectType__c);
            fieldsMap = objectType.getDescribe().fields.getMap();
        }
    }
   
   
   
    // Method to populate the fields prestored in record
    public void populateSelectedValues(){
        ////system.debug('populateSelectedValues execution called' + selectedFields);
        if(String.isBlank(thisRecord.ESC_ReturnedColumns__c))
        {
            ////system.debug('populateSelectedValues ESC_ReturnedColumns__c is null ' );
            return;
        }
        selectedFields = new List<SelectedFieldsWrapper>();
        Integer count =0;     
        /*
        if(!thisRecord.ESC_ReturnedColumns__c.contains(',')){
            SelectedFieldsWrapper sfw = new SelectedFieldsWrapper();
            sfw.populateFieldValue(thisRecord.ESC_ReturnedColumns__c, thisRecord.ESC_ObjectType__c);
            sfw.sequenceValue = count++;
            selectedFields.add(sfw);
            return;
        }
         */
        for(String fld : thisRecord.ESC_ReturnedColumns__c.split(',')){          
            SelectedFieldsWrapper sfw = new SelectedFieldsWrapper(thisRecord.ESC_ObjectType__c);
            if(string.isNotBlank(thisRecord.ESC_DefaultSortCol__c) && thisRecord.ESC_DefaultSortCol__c.equalsIgnoreCase(fld) )
            sfw.defaultSortBy = true;
            sfw.populateFieldValue(fld, thisRecord.ESC_ObjectType__c);
            sfw.sequenceValue = count++;
            selectedFields.add(sfw);
        }
        populateTruncations();
        populateOverrideLabels();
        ////system.debug('populateSelectedValues execution ended' + selectedFields);        
        populateSecondaryNames();
    }
    public void populateTruncations(){
        String truncValues = thisRecord.ESC_NoTruncation__c;
        if (truncValues == null) return;
        ////system.debug('truncValues'+truncValues);
        for (String tvs : truncValues.split(',')){
            String fld = tvs;
            String val = '0';
            if(tvs.contains(':')){
                fld = tvs.substringBefore(':');
                val = tvs.substringAfter(':');
            }
            else{
                fld = tvs;
                val = '0';
            }
            ////system.debug('fld'+fld);
            ////system.debug('val'+val);
            if(selectedFields == null)
                return;
            for(SelectedFieldsWrapper sfw: selectedFields){
                if(sfw.fieldAPI.equalsIgnoreCase(fld)){
                    sfw.truncateValue = val;
                    break;
                }            
            }
        }
    }
    public void populateOverrideLabels(){
        string overrideValues = thisrecord.ESC_OverrideLabelsForfields__c;
        if (overrideValues == null) return;
        for(string ovl : overrideValues.split(',')){
            string fld = '';
            string val = '';
            if(ovl.contains(':')){
                fld = ovl.substringBefore(':');
                val = ovl.substringAfter(':');               
            }
            if(selectedFields == null)
                return;
            for(SelectedFieldsWrapper sfw: selectedFields){
                if(sfw.fieldAPI.equalsIgnoreCase(fld)){
                    sfw.overrideLabel = val;
                    break;
                }            
            }
        }
    }
    
    public void populateSecondaryNames(){
        string secondaryNames = thisrecord.ESC_ReturnedSecondaryColumns__c;
        if (secondaryNames == null) return;
        for(string sNFld : secondaryNames.split(',')){
            for(SelectedFieldsWrapper sfw: selectedFields){
                if(sfw.fieldAPI.equalsIgnoreCase(sNFld)){
                    sfw.showInMiniLayout = true;
                    break;
                }            
            }
        }
    }
    
    
    public pageReference addRecords(){
         try{
             system.debug('addRecords called selectedField ' +selectedField);
        if(string.isNotBlank(selectedField) || string.isNotBlank(relatedField)){
            populateObjectData();
        selectedFields = selectedFields == null? new List<SelectedFieldsWrapper>() :selectedFields;
        
        Schema.DescribeFieldResult dfr = fieldsMap.get(selectedField).getDescribe();
        SelectedFieldsWrapper sfw = new SelectedFieldsWrapper(thisRecord.ESC_ObjectType__c);
        if(dfr.getType().name() != 'REFERENCE'){
            sfw.populateFieldValue(selectedField, thisRecord.ESC_ObjectType__c);
        }
        else{        
            if(string.isBlank(relatedField )){
                system.debug('selectedField ' +selectedField);
                sfw.populateFieldValue(selectedField, thisRecord.ESC_ObjectType__c);
            }
            else{
            for(SObjectType c : dfr.getReferenceTo()){
                string relatedObjectName = c.getDescribe().getName();
                sfw.populateFieldValue(relatedField, relatedObjectName);
                
            }  }
            //sfw.populateFieldValue(selectedField+'.'+relatedField, thisRecord.ESC_ObjectType__c);
        }
        sfw.sequenceValue = selectedFields.size();
        selectedFields.add(sfw);
        selectedfields.sort();
        relatedField = '';
        }
       }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getmessage()));
        }
   
        return null;
     
    }
    public void toggleDel(){          
        String selRow = ApexPages.currentPage().getParameters().get('index');
        if(String.isBlank(selRow)) return;
        for(integer i = 0; i< selectedFields.size(); i++){
            if(selectedFields[i].fieldAPI == selRow){
                //selectedFields.remove(i);
                if(selectedFields[i].showRemove)
                    selectedFields[i].showRemove = false;
                else
                    selectedFields[i].showRemove = true;
                break;
            }
        }  
    }

    public List<PicklistWrapper> fetchSecondaryValues(string selectedField){
        List<PicklistWrapper> tempOpns = new List<PicklistWrapper>();
        ////system.debug('fetchSecondaryValues called' +selectedField);
        
        relatedField = null;
        if(fieldsMap == null)
        populateObjectData();
        
    
            
            Schema.DescribeFieldResult dfr = fieldsMap.get(selectedField).getDescribe();
            string relationshipName = dfr.getRelationshipName();
            for(SObjectType c : dfr.getReferenceTo()){
                Map<string, SObjectfield> relatedFieldsmap = c.getdescribe().fields.getMap();
                for (SObjectfield d : relatedFieldsmap.values()){
                    tempOpns.add(new PicklistWrapper(relationshipName+'.'+d.getDescribe().getName(), d.getDescribe().getLabel()));
                }
                
            }  
        tempOpns.sort();
        return tempOpns;
    }
    public string getAllPickListOptions(){

        if(thisRecord.ESC_ObjectType__c == null) return null;
        populateObjectData();
        
        pickListOpns = new Map<string,List<PicklistWrapper>>();
        originObjectPL = new List<PicklistWrapper>();

        for(Schema.SObjectField fld : fieldsMap.values()){       
            string fType = fld.getDescribe().getType().name();
            List<PicklistWrapper> tempOpns;
            if(fType  == 'REFERENCE'){
                string referencedObjectName = '';
                schema.describefieldresult dfield = fld.getDescribe();
                for(Schema.SObjectType reference : dfield.getReferenceTo()) {
                    referencedObjectName = reference.getDescribe().getName();
                    break;

                }
                tempOpns = fetchSecondaryValues(fld.getDescribe().getName());
            //   ////system.debug('Main option foreign key '+ fld.getDescribe().getName());
               // ////system.debug('referencedObjectName via method '+ referencedObjectName);
               
                // ////system.debug('Main option foreign value '+ fld.getDescribe().getLabel() +'>>');
                pickListOpns.put(fld.getDescribe().getName() , tempOpns);
                originObjectPL.add(new PicklistWrapper(fld.getDescribe().getName() , fld.getDescribe().getLabel() +'>>'));
            }
            else{
                string currObjKey = '.currObj';
                if(!pickListOpns.containsKey(currObjKey)){
                        tempOpns = new List<PicklistWrapper>();
                        pickListOpns.put(currObjKey, tempOpns);
                }
                tempOpns = pickListOpns.get(currObjKey);
                
                tempOpns.add(new PicklistWrapper(fld.getDescribe().getName(), fld.getDescribe().getLabel()) );
                pickListOpns.put(currObjKey, tempOpns);
                 //////system.debug('Main option direct k value '+ fld.getDescribe().getLabel());
                  //////system.debug('Main option direct k ey '+ fld.getDescribe().getName());
            
            }
        }
    pickListOpns.put('.currObjR',originObjectPL);
    
        for(string key:pickListOpns.keyset()){
            //system.debug('key- '+key);
                //system.debug('b4 pickListOpns: '+pickListOpns.get(key));
            pickListOpns.get(key).sort();
                //system.debug('a4 pickListOpns: '+pickListOpns.get(key));
        }
        return JSON.serialize(pickListOpns);
    }
    public class PicklistWrapper implements Comparable{
        public string opnLabel{get; private set;}
        public string opnValue{get; private set;} 
        
        public PicklistWrapper(string value, string label){
            this.opnLabel = label;
            this.opnValue = value;
        }
        
            public Integer compareTo( Object obj){
            PicklistWrapper sfw = (PicklistWrapper ) obj;
            if(this.opnLabel < sfw.opnLabel)
                return -1;
            else if(this.opnLabel > sfw.opnLabel)
                return 1;
            return 0;
        }
        
    
    }

}