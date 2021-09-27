public class ESC_FormGeneratorCompController extends ESC_ComponentControllerBase {
    public string sectionIDE {
        get;
        set;
    }
    public string sectionName {
        get;
        set;
    }
    public ESC_SectionDescriber currentDescribedSection {
        get;
        set;
    }
    private Boolean isFirst = true;
    public boolean IsAddRow = false;
    public ESC_SectionDetails scd {
        get;
        set;
    }
    Map < string, object > fieldValue = new Map < string, object > ();
    public integer rowNumberParam {
        get;
        set;
    }
    public List < Sobject > fieldVal;
    public Map < string, FieldDescriber > preDescribedFieldMap {
        get;
        set;
    }
    public Map < string, string > fieldDescpn {
        get;
        set;
    }
    public ESC_Case_Form_Extension__c singleExtension {
        get;
        set;
    }
    public List < ESC_Case_Form_Extension_Line_Item__c > singleExtensionLineItemsList {
        get;
        set;
    }

    public ESC_FormGeneratorCompController() {
        system.debug('ESC_FormGeneratorCompController called' + scd);
        scd = new ESC_SectionDetails();

        preDescribedFieldMap = new Map < string, FieldDescriber > ();

    }
    public void formRerenderCall() {
        string renderedStatus = Apexpages.currentPage().getParameters().get('statusRendered');
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, key + ' key swapped' + currentDescribedSection.isRendered));
        currentDescribedSection.isRendered = renderedStatus == 'true' ? true : false;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, key + ' key swapped' + currentDescribedSection.isRendered));
    }

    public PageReference imitateFormSubmit() {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'just fired'));
        return null;
    }
    public List < SObject > getSobj(String sObjectApiName, List < String > fields, String rType) {
        List < SObject > sobjList = new List < SObject > ();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectApiName);
        SObject newSobject;

        if (fieldVal != null && fieldVal.size() > 0 && !IsAddRow) {
            if (sObjectApiName.equalsignorecase('ESC_Case_Form_Extension_Line_Item__c'))
                sobjList.addall(fieldVal);
            else
                newSObject = fieldVal[0];
        } else {
            // currentDescribedSection.isEditableSection
            if (sObjectApiName == 'ESC_Case_Form_Extension__c') {
                newSobject = singleExtension;
            } else
                newSobject = targetType.newSObject();

            Map < string, Schema.SObjectField > fieldDscpMap = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().fields.getMap();
            for (string field: fields) {
                Schema.DescribeFieldResult fieldDscp = fieldDscpMap.get(field).getDescribe();

                Schema.DisplayType FldType = fieldDscp.getType();

                if (test.isrunningTest()) {
                    try {
                        newSobject.put(field, Schema.getGlobalDescribe().get(sObjectApiName).getDescribe().fields.getMap().get(field).getDescribe().getDefaultValue());

                    } catch (exception ex) {
                        system.debug('Error with getSobj()  ' + ex.getStackTraceString());
                        system.debug('Error field ' + field);
                        system.debug('Error field ' + fieldDscp);
                        system.debug('Error sObjectApiName ' + sObjectApiName);
                    }
                }
            }
            IsAddRow = false;
        }


        if (sObjectApiName == 'ESC_Case_Form_Extension__c') {
            newSobject = (ESC_Case_Form_Extension__c) newSobject;
            if (rType != null) {
                Id recordTypeId = Schema.SObjectType.ESC_Case_Form_Extension__c.getRecordTypeInfosByName().get(rType).getRecordTypeId();
                newSobject.put('recordTypeId', recordTypeId);
            }

        } else if (sObjectApiName == 'ESC_Case_Form_Extension_Line_Item__c') {
            newSobject = (ESC_Case_Form_Extension_Line_Item__c) newSobject;
        }
        if (sobjList.size() == 0)
            sobjList.add(newSobject);

        return sobjList;
    }

    public override void saveComponent() {
        //imitateFormSubmit();
        List < Sobject > DeleteLIList = new List < Sobject > ();
        List < Sobject > InsertLIList = new List < Sobject > ();
        system.debug('Current Des Sec ' + JSON.Serialize(currentDescribedSection));
        system.debug('preDescribedFieldMap' + JSON.Serialize(preDescribedFieldMap));

        try {
            string caseiD = ApexPages.currentPage().getParameters().get('id');
            string formID = ApexPages.currentPage().getParameters().get('formId');
            system.debug('crrent desc' + currentDescribedSection.isRendered + '####' + currentDescribedSection.isEditableSection + '****');
            for (String APIname: currentDescribedSection.fsAPINameList) {
                system.debug('pre map' + preDescribedFieldMap + 'apiname is' + apiname);
                if (preDescribedFieldMap.get(APIname).isMandatory && currentDescribedSection.isRendered && currentDescribedSection.isEditableSection) {
                    if (currentDescribedSection.objectName.equalsignoreCase('ESC_Case_Form_Extension__c')) {
                        system.debug('Checking field: ' + APIname + '[' + currentDescribedSection.sobj.get(APIname) + ']');
                        if (currentDescribedSection.sobj.get(APIname) == null || currentDescribedSection.sobj.get(APIname) == '') {
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Mandatory fields are missing'));
                            throw new ESC_HandlerCustomException('Mandatory field ' + Schema.getGlobalDescribe().get(currentDescribedSection.objectName).getDescribe().fields.getMap().get(APIname).getDescribe().getlabel() + ' is missing');
                        }
                    } else if (currentDescribedSection.objectName.equalsignoreCase('ESC_Case_Form_Extension_Line_Item__c')) {
                        for (Sobject so: currentDescribedSection.sobjList) {
                            if (so != null) {
                                system.debug('Checking field: ' + APIname + '[' + so.get(APIname) + ']');
                                if (so.get(APIname) == null || so.get(APIname) == '') {
                                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Mandatory fields are missing'));
                                    throw new ESC_HandlerCustomException('Mandatory field ' + Schema.getGlobalDescribe().get(currentDescribedSection.objectName).getDescribe().fields.getMap().get(APIname).getDescribe().getlabel() + ' is missing');
                                }
                            }
                        }
                    }
                }
                Schema.DisplayType FldType = Schema.getGlobalDescribe().get(currentDescribedSection.objectName).getDescribe().fields.getMap().get(APIname).getDescribe().getType();

                if (FldType == Schema.DisplayType.Boolean) {
                    if (currentDescribedSection.objectName.equalsignoreCase('ESC_Case_Form_Extension__c')) {
                        if (currentDescribedSection.sobj.get(APIname) == null || currentDescribedSection.sobj.get(APIname) == '') {
                            currentDescribedSection.sobj.put(APIname, false);
                        }
                    } else if (currentDescribedSection.objectName.equalsignoreCase('ESC_Case_Form_Extension_Line_Item__c')) {
                        for (Sobject so: currentDescribedSection.sobjList) {
                            if (so.get(APIname) == null || so.get(APIname) == '') {
                                so.put(APIname, false);
                            }
                        }
                    }
                }
            }

            if (currentDescribedSection.isEditableSection && currentDescribedSection.isRendered) {

                if (currentDescribedSection.objectName.equalsignoreCase('ESC_Case_Form_Extension__c')) {
                    Boolean isNew = true;
                    ESC_Case_Form_Extension__c toMake = (ESC_Case_Form_Extension__c)(currentDescribedSection.sobj);
                    for (ESC_Case_Form_Extension__c prevFormExten: [select id from ESC_Case_Form_Extension__c where ESC_Case__c =: caseid and ESC_Form__c =: formid Limit 1]) {

                        toMake.id = prevFormExten.id;
                        system.debug('Sobject before update :' + tomake);
                        update(toMake);
                        isNew = false;

                    }
                    if (isNew) {
                        currentDescribedSection.sobj.put('ESC_Case__c', caseiD);
                        currentDescribedSection.sobj.put('ESC_Form__c', formID);
                        if (currentDescribedSection.sobj.get('id') != null)
                            currentDescribedSection.sobj.put('id', null);
                        insert currentDescribedSection.sobj;
                    }

                } else {
                    List < ESC_Case_Form_Extension__c > ecsList = [select id from ESC_Case_Form_Extension__c where ESC_Case__c =: caseid and ESC_Form__c =: formid Limit 1];
                    ESC_Case_Form_Extension__c ecs;
                    if (ecsList.size() == 0) {
                        ecs = new ESC_Case_Form_Extension__c();
                        ecs.ESC_Case__c = caseiD;
                        ecs.ESC_Form__c = formID;
                        insert ecs;
                    } else {
                        ecs = ecsList[0];
                    }
                    list < ESC_Case_Form_Extension_Line_Item__c > oldOnes = [select Id from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c =: ecs.Id];
                    if (!oldOnes.isEmpty()) delete oldOnes;
                    List < SObject > newOnes = new List < SObject > ();
                    for (SObject sob: currentDescribedSection.sobjList) {
                        if (sob != null) {
                            sob.put('ESC_Case_Form_Extension__c', ecs.id);
                            sob.put('id', null);
                            newOnes.add(sob);
                        }
                    }
                    currentDescribedSection.sobjList = newOnes;
                    insert(currentDescribedSection.sobjList);
                }
                system.debug(' Save successfuly' + JSON.serialize(currentDescribedSection.sobjList));
            }
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'An exception occurred: ' + e.getmessage()));
            system.debug('Exception: ' + e.getMessage());
            system.debug('Trace: ' + e.getStackTraceString());
            throw new ESC_HandlerCustomException('Exception :' + e.getMessage());
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'An exception occurred: ' + e.getmessage()));
            system.debug('Exception: ' + e.getMessage());
            system.debug('Trace: ' + e.getStackTraceString());
            throw new ESC_HandlerCustomException('Exception :' + e.getMessage());
        }

    }

    public PageReference addRow() {
        try {
            IsAddRow = true;            
            for (Sobject sob: getSobj(currentDescribedSection.objectName, currentDescribedSection.fsAPINameList,
                    currentDescribedSection.referencedRecordType)) {
                singleExtensionLineItemsList.add((ESC_Case_Form_Extension_Line_Item__c) sob);
                currentDescribedSection.sobjList.add((ESC_Case_Form_Extension_Line_Item__c) sob);
                break;
            }
            system.debug(singleExtensionLineItemsList.size());
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, JSON.serialize(currentDescribedSection)));
            // currentDescribedSection.sobjList = singleExtensionLineItemsList;
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'An exception occurred while adding rows: ' + e.getmessage()));
        }
        return null;
    }

    public void delRow() {
        List < Sobject > tempSobjList = new List < Sobject > ();

        system.debug(currentDescribedSection.sobjList.size() + ' Before Delete ' + currentDescribedSection.sobjList);
        integer rownum = 0;
        system.debug(rowNumberParam);
        try {
            //  rownum = Integer.valueof(Apexpages.currentPage().getParameters().get('rownum1'));
            rownum = rowNumberParam - 1;
        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
        //singleExtensionLineItemsList.remove(rownum);
        integer count = 0;
        for (Sobject so: currentDescribedSection.sobjList) {
            if (so != null && rownum != count)
                tempSobjList.add(so);
            else {
                system.debug(rownum + ' skipping out ' + so);

            }
            count++;
        }
        singleExtensionLineItemsList = tempSobjList;
        system.debug(tempSobjList.size() + ' After Delete ' + singleExtensionLineItemsList);
        currentDescribedSection.sobjList = tempSobjList;
        //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error , json.serialize(currentDescribedSection.sobjList) ));
        // return null;
    }

    public static List < Schema.FieldSetMember > readFieldSet(String fieldSetName, String ObjectName) {
        try {
            Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
            return fieldSetObj.getFields();
        } catch (exception e) {
            throw new ESC_HandlerCustomException('Exception with fieldset :' + fieldSetName + ': under object: ' + ObjectName + '-->' + e.getMessage());
        }
    }

    public void populateAllSectionValuesMap(string idOfSection, string fieldsToFetch) {
        fieldValue = new Map < string, Object > ();
        string caseiD = string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        string formID = string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('formId'));
        system.debug('scd.allformSections ' + JSON.Serialize(scd.allformSections));
        for (Form_Section__c fs: scd.allformSections) {
            if (fs.Section__c.equals(idOfSection)) {
                if (string.isNotBlank(fs.ESC_QPIdentfier__c)) {
                    try {
                        if(scd.masterRecord == null)
                        throw new ESC_HandlerCustomException('Exception under populateAllSectionValuesMap proper case is not associated/ Is Form Origin? type section with query parameter not found' );
                        system.debug('master record is'+scd.masterRecord+'fs.ESC_QPIdentfier__c is'+fs.ESC_QPIdentfier__c);
                        string masterRecoID = (string)scd.masterRecord.get(string.isBlank(fs.ESC_QPIdentfier__c)?'id':fs.ESC_QPIdentfier__c);
                        system.debug('masterrecordid is'+masterrecoID);
                        fieldVal = scd.getSectionDetailsSOBJ(masterRecoID, fieldsToFetch, fs.Section__r.ESC_Referenced_Object__c);
                    } catch (Exception e) {
                        
                          throw new ESC_HandlerCustomException('Exception under populateAllSectionValuesMap1 :' + e.getStackTraceString() + ' || '+e.getmessage());
                    }
                } else if (string.isBlank(fs.ESC_QPIdentfier__c) && (fs.Section__r.ESC_Referenced_Object__c.equalsignorecase('ESC_Case_Form_Extension__c') || fs.Section__r.ESC_Referenced_Object__c.equalsignorecase('ESC_Case_Form_Extension_Line_Item__c'))) {
                    // system.debug('inside case extensions');
                    try {
                        fieldVal = scd.getSectionDetailsSOBJ(caseiD, formID, fieldsToFetch, fs.Section__r.ESC_Referenced_Object__c);
                    } catch (Exception e) {
                        throw new ESC_HandlerCustomException('Exception under populateAllSectionValuesMap2 :'+e.getMessage());
                    }
                }
                system.debug(key + 'all values ' + fieldval);
                break;
            }
        }

    }
    public void setPrePopulatedFieldInformation(List < ESC_Section_Field__c > describedFieldList) {
        for (ESC_Section_Field__c describedField: describedFieldList) {
            FieldDescriber fld = new FieldDescriber(describedField.ESC_Field_API__c);
            fld.labelName = string.isNotBlank(describedField.ESC_Override_Label__c) ? describedField.ESC_Override_Label__c : fld.labelName;
            fld.isMandatory = describedField.ESC_Mandatory__c != null && describedField.ESC_Mandatory__c ? true : false;

            preDescribedFieldMap.put(describedField.ESC_Field_API__c, fld);

        }

    }
    private void populateFieldDescriberMap(Schema.FieldSetMember fsm) {

        string fieldAPI = fsm.getFieldPath();
        if (string.isBlank(fieldAPI)) {
            system.debug('Blank' + fsm);
        }
        //required on fieldSet Level or object Level
        Boolean isRequired = fsm.getRequired() || fsm.getDBRequired();
        FieldDescriber fld;
        if (preDescribedFieldMap.containsKey(fieldAPI)) {
            fld = preDescribedFieldMap.get(fieldAPI);
        } else {
            fld = new FieldDescriber(fieldAPI);
        }
        // System.debug('fld.isMandatory?? '+fld.isMandatory);
        fld.isMandatory = fld.isMandatory || isRequired;
        preDescribedFieldMap.put(fieldAPI, fld);

    }
    @testvisible
    private void populateFieldDescriberMapEvents(List < ESC_Section_Special_Events__c > esceventsList) {

        Map < string, List < FieldDescriber >> preDescribedFieldMapEvents = new Map < string, List < FieldDescriber >> ();
        for (ESC_Section_Special_Events__c escevents: esceventsList) {
            List < FieldDescriber > eventsDescribed;
            string fieldAPI = escevents.ESC_Field_API__c;
            if (preDescribedFieldMapEvents.containsKey(fieldAPI)) {
                eventsDescribed = preDescribedFieldMapEvents.get(fieldAPI);
            } else {
                eventsDescribed = new List < FieldDescriber > ();
            }
            FieldDescriber fld = new FieldDescriber(fieldAPI);
            fld.sectionToReRender = escevents.ESC_RerenderedSection__c;
            fld.fieldRerenederValue = escevents.ESC_Value__c;
            fld.url = escevents.ESC_URL__c;

            eventsDescribed.add(fld);
            preDescribedFieldMapEvents.put(fieldAPI, eventsDescribed);


        }
        system.debug('preDescribedFieldMapEvents' + preDescribedFieldMapEvents);
        fieldDescpn = new Map < string, string > ();
        set < string > unusedFields = new set < String > (currentDescribedSection.fsAPINameList);
        unusedFields.removeall(preDescribedFieldMapEvents.keySet());
        for (string key: unusedFields) {
            List < FieldDescriber > eventsDescribed = new List < FieldDescriber > {
                new FieldDescriber()
            };
            preDescribedFieldMapEvents.put(key, eventsDescribed);
        }
        for (string key: preDescribedFieldMapEvents.keySet()) {
            fieldDescpn.put(key, (JSON.serialize(preDescribedFieldMapEvents.get(key))));
        }
    }

    public void getSection() {
        try {
            system.debug(currentDescribedSection.isInitilaized + 'getSection called ends with currentDescribedSection.sobjList- ' + currentDescribedSection.sobjList.size());
            

            if (!currentDescribedSection.isInitilaized) {
                //  system.debug('successfuly received'+JSON.serialize(scd));
                //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, json.serialize(datetime.now()) ));
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'data'+isFirst +json.serialize(singleExtension) ));
                List < ESC_Section_Field__c > describedFieldList = [select ESC_Field_API__c, ESC_Mandatory__c, ESC_Override_Label__c from ESC_Section_Field__c where ESC_Section__c =: sectionIDE];
                List < ESC_Section_Special_Events__c > esceventsList = [select ESC_Field_API__c, ESC_RerenderedSection__c, ESC_Value__c, ESC_URL__c from ESC_Section_Special_Events__c where ESC_Section__c =: sectionIDE];

                for (ESC_Section__c fs: [SELECT ESC_Label__c, ESC_Layout__c, ESC_Read_Only_Fields__c, ESC_Referenced_Fieldset__c,
                        ESC_Referenced_Object__c, ESC_Referenced_Record_Type__c,
                        ESC_Visual_Force_Page_Name__c, ESC_Default_Render__c, name FROM ESC_Section__c WHERE id =: sectionIDE
                    ]) {
                    sectionName = fs.name;
                    currentDescribedSection.referencedRecordType = fs.ESC_Referenced_Record_Type__c;
                    currentDescribedSection.layoutColumns = currentDescribedSection.getNumberOFCOlumns(fs.ESC_Layout__c);
                    if (fs.ESC_Layout__c.equals('Visual Force')) {
                        currentDescribedSection.vfComponentName = fs.ESC_Visual_Force_Page_Name__c;
                        currentDescribedSection.isVFP = true;

                    }

                    // Type = Normal Layout with fields
                    else if (string.isNotBlank(fs.ESC_Referenced_Fieldset__c)) {
                        currentDescribedSection.objectName = fs.ESC_Referenced_Object__c;
                        system.debug('current object is' + currentDescribedSection.objectName);
                        currentDescribedSection.setEditableProp();
                        if (currentDescribedSection.isEditableSection)
                            setPrePopulatedFieldInformation(describedFieldList);
                        List < String > fsAPINameList = new List < String > ();
                        for (Schema.FieldSetMember fsm: readFieldSet(fs.ESC_Referenced_Fieldset__c, fs.ESC_Referenced_Object__c)) {
                            fsAPINameList.add(fsm.getFieldPath());
                            //if(currentDescribedSection.isEditableSection)
                            populateFieldDescriberMap(fsm);

                        }
                        populateAllSectionValuesMap(sectionIDE, string.join(fsAPINameList, ','));
                        currentDescribedSection.isPlainLayout = true;
                        currentDescribedSection.fsAPINameList = fsAPINameList;
                        //Added as part of DSS-6989 to show the Fields as read only fields
                         Map<string,string> readOnlyFieldAPINameMap = new Map<string,string>();
                        //List<string> readOnlyFieldAPINameList = fs.ESC_Read_Only_Fields__c!=null?fs.ESC_Read_Only_Fields__c.split(','):new List<String>();
                        system.debug('## readOnlyFieldAPINameMap :' + readOnlyFieldAPINameMap );
                         for(string fieldApi:fsAPINameList){
                                if(fs.ESC_Read_Only_Fields__c!=null && fs.ESC_Read_Only_Fields__c!='' && fs.ESC_Read_Only_Fields__c.containsIgnoreCase(fieldApi)){
                                    readOnlyFieldAPINameMap.put(fieldApi,fieldApi);
                                }else{
                                    readOnlyFieldAPINameMap.put(fieldApi,'');
                                }
                            }
                        
                       if(!readOnlyFieldAPINameMap.isEmpty()){
                           currentDescribedSection.readOnlyFieldsMap = readOnlyFieldAPINameMap;
                       }
                       //End ofDSS-6989
                        if (currentDescribedSection.objectName.equalsignorecase('ESC_Case_Form_Extension_Line_Item__c')) {
                            for (Sobject sob: getSobj(currentDescribedSection.objectName, currentDescribedSection.fsAPINameList,
                                    currentDescribedSection.referencedRecordType)) {
                                singleExtensionLineItemsList.add((ESC_Case_Form_Extension_Line_Item__c) sob);
                                currentDescribedSection.sobjList.add((ESC_Case_Form_Extension_Line_Item__c) sob);
                                // break;
                            }
                            // = singleExtensionLineItemsList;
                        } else {
                            currentDescribedSection.sobjList = getSobj(fs.ESC_Referenced_Object__c, fsAPINameList, fs.ESC_Referenced_Record_Type__c);
                            List < Sobject > tempSobjList = new List < Sobject > ();
                            for (Sobject so: currentDescribedSection.sobjList) {
                                if (so != null)
                                    tempSobjList.add(so);
                                // break;
                            }
                            currentDescribedSection.sobjList = tempSobjList;

                        }


                        currentDescribedSection.refFieldSet = fs.ESC_Referenced_Fieldset__c;
                        currentDescribedSection.sobj = currentDescribedSection.sobjList[0];
                        system.debug('Initial SobjList ' + currentDescribedSection.sobjList);
                        populateFieldDescriberMapEvents(esceventsList);
                        currentDescribedSection.isRendered = fs.ESC_Default_Render__c == null || fs.ESC_Default_Render__c == false ? true : false;
                        if (fs.ESC_Layout__c.equals('Tabular')) {
                            currentDescribedSection.isTabular = true;
                            currentDescribedSection.isPlainLayout = false;
                        }



                    }
                }
                currentDescribedSection.isInitilaized = true;
            }
        } catch (exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'GetSection() error with' + sectionIDE + ' ' + ex.getmessage()));
            system.debug('Error 2:' + ex.getMessage());
            system.debug(ex.getStackTraceString());
        }
        sectionIDE = '';
        system.debug(currentDescribedSection.isInitilaized + 'getSection called ends with currentDescribedSection.sobjList- ' + currentDescribedSection.sobjList.size());
        //system.debug(singleExtensionLineItemsList.size()+'singleExtensionLineItemsList getSection called ends with   ' + key);
    }


    public class FieldDescriber {
        public String labelName {
            get;
            set;
        }
        public String fieldAPI {
            get;
            set;
        }
        public Boolean isMandatory {
            get;
            set;
        }
        public String sectionToReRender {
            get;
            set;
        }
        public String fieldRerenederValue {
            get;
            set;
        }
        public String url {
            get;
            set;
        }

        public FieldDescriber() {
            labelName = 'xxx';
            isMandatory = false;
            sectionToReRender = 'xxx';
            fieldRerenederValue = 'xxx';
            url = 'xxx';
            fieldAPI = 'xxx';
        }
        public FieldDescriber(string fieldAPI) {
            labelName = 'xxx';
            isMandatory = false;
            sectionToReRender = 'xxx';
            fieldRerenederValue = 'xxx';
            url = 'xxx';
            fieldAPI = fieldAPI;
        }
    }


}