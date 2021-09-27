public with sharing class ESC_GlobalObjectSearchController {

    public map<string, List<ESC_GlobalObjectSearchFilterInstance>> filterMap {get; set;}
    Boolean hasRecords = false;
    public string selectedTab {get; set;}
    public map<string, List<string> > resultMap {get; set;}
    transient public map<string, List<ESC_GlobalObjectSearchFilterInstance>> searchResultMap {get; set;}
    public string val1 {get; set;}
    public boolean isSearchValid {get; set;}
    public transient boolean isSearchSuccessful {get; set;}
    public string primaryKeyWord {get; set;}    
    List<ESC_GlobalObjectSearchFilterInstance> collectQueryParams = new List<ESC_GlobalObjectSearchFilterInstance>();
    public transient string mainSearchKeyword='';
    transient string filterSecondary= '';
    //string query='';
    public transient List<sObject> searchResults {get; set;}
    public Boolean hasSOQLClause ;
    transient Map<string, Map<string,string>> objectSchemaForSet= new  Map<string, Map<string,string>>();
    public Map<string, Map<string,string>> resultTableLabel {get; set;}
    public Map<string, Map<string,Boolean>> showAsLink {get; set;}
    public Map<string, Map<string,string>> showAsParentLink {get;set;}
    transient public string  paginationSizeOpns {get; set;}
    public set<string> keyObjects{get; set;}
    static Map <String, Schema.SObjectType> schemaMap;
    public ESC_DataTableEntity dte {get; set;}
    public Boolean currentTheme {get; set;}

    public integer getTimeoutInMillisec(){
        return integer.valueOf(Label.ESC_Timeout);
    }

    public void adderrorMessage(){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ESC_SearchPageError));
    }
    
     public void adderrorMessageTimeout(){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_TimeoutError));
    }
    public string getDataTableEntity(){
        List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
        dteList.add(dte);
        return JSON.serialize(dteList);
    }
    //added for DSS-5594
     public String searchSAP {get;set;}
     public String searchPhone {get;set;}
     public String searchPhone2 {get;set;}
     public String searchContact {get;set;}
    //end
    @testvisible private static string getObjectNameForRelation(string refObj, string fieldAPIName){
        string obj = fieldAPIName.split('\\.')[0];
        if(fieldAPIName.contains('__r')){
            schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(refObj).getDescribe().fields.getMap();
            Schema.SObjectField sfield=fieldMap.get(obj.replace('__r', '__c'));
            schema.describefieldresult dfield = sfield.getDescribe();
            for(Schema.SObjectType reference : dfield.getReferenceTo()) {
                obj = reference.getDescribe().getName();

            }
            system.debug(fieldAPIName +' is of object '+obj);
            return obj;
        }
        else{
            return obj;
        }



    }
    private string getValueFromLabel(string customLabelName){


        if(string.isBlank(customLabelName)){
            return '';
        }

        else{
            try{
                Component.Apex.OutputText output = new Component.Apex.OutputText();
                output.expressions.value = '{!$Label.' + customLabelName + '}';
                return String.valueOf(output.value);
            }

            catch(exception ex){
                return '';
            }
        }

    }
    
    public string gethiddenRows(){
       Map<string, List<integer>> hiddenRowsMap = new Map<string, list<integer>>();
        for(string key:filterMap.keyset()){
            List<integer> hiddenRows = new List<integer>();
            Integer countO =0;
            for(ESC_GlobalObjectSearchFilterInstance egs: filterMap.get(key) ){
                if(!egs.showInFiter){
                    hiddenRows.add(countO);
                }
                countO++;
            }
            hiddenRowsMap.put(key,hiddenRows);
        }
        return JSON.serialize(hiddenRowsMap);
    }
    // this method will run a soql to custom metadata and gather all search and result fields and poplate it filterMap, resultMap
    public void setFilterResultsMap(){
        
        filterMap = new  map<string, List<ESC_GlobalObjectSearchFilterInstance>>();
        resultMap = new map<string, list<string> > ();
       
        resultTableLabel= new  Map<string, Map<string,string>>();
        showAsLink = new  Map<string, Map<string,Boolean>>();
        showAsParentLink = new  Map<string, Map<string,string>>();
        string currentUserProfile = [select Name from profile where id = :userinfo.getProfileId()][0].name;
        //currentUserProfile ='\'%'+currentUserProfile+'%\'';
        system.debug('currentUserProfile-->'+currentUserProfile);
        Set<String> fieldUniqueSet = new Set<String>();
        for (ESC_SearchSettings__mdt criteriaSetForObj: [Select ESC_ObjectAPIName1__c,ESC_ParamValue__c,ESC_HFF__c,ESC_Def__c,ESC_Hide_From_Results__c, ESC_FieldAPIName__c ,
        ESC_LabelName__c, esc_sequence__c, ESC_IsKey__c ,ESC_ShowAsLink__c,ESC_ApplicableToProfiles__c from
                                                         ESC_SearchSettings__mdt order by esc_sequence__c asc nulls last  ]) 
        {
            if(criteriaSetForObj.ESC_ApplicableToProfiles__c!=null && ((criteriaSetForObj.ESC_ApplicableToProfiles__c).containsIgnoreCase(currentUserProfile))){
                 system.debug('criteriaSetForObj-->'+criteriaSetForObj);
                hasRecords = true;
                string criteriaObj = criteriaSetForObj.ESC_ObjectAPIName1__c;
                string criteriaFieldAPI = criteriaSetForObj.ESC_FieldAPIName__c;
                Boolean isHiddenFromResults = criteriaSetForObj.ESC_Hide_From_Results__c == null? false : criteriaSetForObj.ESC_Hide_From_Results__c ;
                if(!fieldUniqueSet.contains((criteriaSetForObj.ESC_ObjectAPIName1__c+criteriaSetForObj.ESC_FieldAPIName__c))){
                    fieldUniqueSet.add(criteriaSetForObj.ESC_ObjectAPIName1__c+criteriaSetForObj.ESC_FieldAPIName__c);
                    // To get all search criterias
                    if(criteriaSetForObj.ESC_IsKey__c == true){
                        List<ESC_GlobalObjectSearchFilterInstance> tempFilterInstanceList;
                        ESC_GlobalObjectSearchFilterInstance efi= new ESC_GlobalObjectSearchFilterInstance(criteriaObj, criteriaFieldAPI , getValueFromLabel(criteriaSetForObj.ESC_LabelName__c) ,criteriaSetForObj);
                        
                        if(filterMap.containsKey(criteriaObj)){
                            tempFilterInstanceList= filterMap.get(criteriaObj);
                        }
                        else{

                            tempFilterInstanceList = new List<ESC_GlobalObjectSearchFilterInstance>();
                        }


                        tempFilterInstanceList.add(efi);

                        filterMap.put(criteriaObj , tempFilterInstanceList);
                       

                    }
                    
                   
                    // To get columns for which values have to be shown as link
                    if(!isHiddenFromResults){
                    Map<string ,Boolean> tempLinkMap;
                    Boolean tempVal=false;
                    
                     //to get the parent look up field value
                    Map<string,string> tempParentLinkMap;
                    string parentId;
                    if(showAsParentLink.containsKey(criteriaObj)){
                        tempParentLinkMap = showAsParentLink.get(criteriaObj);
                    }
                    else{
                        tempParentLinkMap = new Map<string ,string>();
                    }
                    
                    if(criteriaSetForObj.ESC_ParamValue__c!= null && criteriaSetForObj.ESC_ParamValue__c!=''){
                        parentId = criteriaSetForObj.ESC_ParamValue__c;
                        
                    }
                    if(parentId !=null){
                        tempParentLinkMap.put(criteriaSetForObj.ESC_FieldAPIName__c.toLowerCase(),parentId.toLowerCase());
                    
                    }else{
                        tempParentLinkMap.put(criteriaSetForObj.ESC_FieldAPIName__c.toLowerCase(),criteriaSetForObj.ESC_FieldAPIName__c.toLowerCase());
                    }
                    showAsParentLink.put(criteriaObj,tempParentLinkMap);
                    
                    if(showAsLink.containsKey(criteriaObj)){
                        tempLinkMap = showAsLink.get(criteriaObj);

                    }
                    else{
                        tempLinkMap = new Map<string ,Boolean>();

                    }
                    if(criteriaSetForObj.ESC_ShowAsLink__c == true){
                        tempVal =true;
                    }   

                    tempLinkMap.put(criteriaFieldAPI.toLowerCase() ,tempVal);
                    showAsLink.put(criteriaObj, tempLinkMap);



                    List<string> tempResultsList;
                    Map<string ,string> tempLabel;

                    if(resultMap.containsKey(criteriaObj)){
                        tempResultsList= resultMap.get(criteriaObj);
                        tempLabel =resultTableLabel.get(criteriaObj);
                    }
                    else{

                        tempResultsList = new List<string>();
                        tempLabel = new Map<string ,string>();

                    }
                    
                    tempResultsList.add(criteriaFieldAPI.toLowerCase());
                    tempLabel.put(criteriaFieldAPI.toLowerCase() , getValueFromLabel(criteriaSetForObj.ESC_LabelName__c));
                    resultMap.put(criteriaObj, tempResultsList);

                    resultTableLabel.put(criteriaObj , tempLabel);
                    
                    }
                }
            }

        } 
        keyObjects = filterMap.keyset();

        //System.debug(filterMap);
        if(hasRecords){
        setFilterMapFields();
        }
        else{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ESC_NotProvisionedError));
        
        }
    }
    
    // this will take care 
    
    // this method will be used to feed the field related info for search criterias 


    public void setFilterMapFields(){        
        objectSchemaForSet= ESC_ObjectSchemaHelper.getInfoField(filterMap.keyset());
        system.debug('filterMap keys'+filterMap.keyset());
         system.debug('objectSchemaForSet keys'+ JSON.serialize(objectSchemaForSet));
        for(string objectVal : filterMap.keyset()){

            Map<string,string> objectFieldInfo;
            List<ESC_GlobalObjectSearchFilterInstance> tempList = filterMap.get(objectVal);
            Integer index =0;
            for(ESC_GlobalObjectSearchFilterInstance filterInstance: tempList ){
                string fieldApiName = filterInstance.fieldApiName.toLowerCase();
                if(fieldApiName.contains('.')){
                    string[] objField = fieldApiName.split('\\.');
                    string parentObject = getObjectNameForRelation(objectVal , fieldApiName);
                    string parentObjectField = objField[1];
                   
                    objectFieldInfo= objectSchemaForSet.get(parentObject);
                    //objectFieldInfo= objectSchemaForSet.get(parentObject.toLowerCase());
                    string typeLabel = objectFieldInfo.get(parentObjectField.toLowerCase());
                    system.debug('##' + objField + parentObject + parentObjectField + objectFieldInfo + typeLabel);
                    if(!string.isBlank(typeLabel)){

                        string[] splitVal = typeLabel.split(':');

                        filterInstance.FieldLabel = string.isBlank(filterInstance.FieldLabel)? splitVal[1] :filterInstance.FieldLabel ;
                        if( resultTableLabel.get(objectVal).containsKey(filterInstance.fieldApiName)){
                            resultTableLabel.get(objectVal).put(fieldApiName , filterInstance.FieldLabel);
                        }
                        filterInstance.FieldType = splitVal[0];
                        filterInstance.ParentObj = parentObject;
                        system.debug('@@ Fieldtype:' + filterInstance.FieldType);
                        if(filterInstance.FieldType.contains('PICKLIST')){
                            filterInstance.OptionsForField = ESC_ObjectSchemaHelper.getPickListOptions(parentObject,filterInstance.FieldApiName );
                            filterInstance.isPickList = true;
                           // filterInstance.FieldValue= '.--None--.';
                            filterInstance.isTextBox = false;
                            filterInstance.isRender = false; 

                        }
                        else if(filterInstance.FieldType.contains('BOOLEAN')){

                            filterInstance.isCheckBox = true;
                            filterInstance.FieldValue= 'false';
                            filterInstance.isTextBox = false;
                            filterInstance.isRender = false;
                        }
                    }

                }
                else{
                    objectFieldInfo= objectSchemaForSet.get(objectVal.toLowerCase());
                    string typeLabel = objectFieldInfo.get(fieldApiName);
                     
                    //system.debug(' : ' +objectFieldInfo +' : '+objectVal);
                    if(!string.isBlank(typeLabel)){

                        string[] splitVal = typeLabel.split(':');
                        filterInstance.FieldLabel = string.isBlank(filterInstance.FieldLabel)? splitVal[1] : filterInstance.FieldLabel  ;
                        Boolean isFormulaField = splitVal[2] =='null'? false :true;
                        if( resultTableLabel.get(objectVal).containsKey(fieldApiName)){
                            resultTableLabel.get(objectVal).put(fieldApiName , filterInstance.FieldLabel);
                        }
                        filterInstance.FieldType = splitVal[0];
                        
                         if(filterInstance.FieldType.contains('MULTIPICKLIST')){
                            filterInstance.OptionsForField = ESC_ObjectSchemaHelper.getPickListOptions(objectVal,filterInstance.FieldApiName );
                            filterInstance.isMPickList = true;
                            filterInstance.isCheckBox = false;
                            filterInstance.FieldValue= 'false';
                            filterInstance.isTextBox = false;
                            filterInstance.isRender = false;

                        }
                        else if(filterInstance.FieldType.contains('PICKLIST')){
                            filterInstance.OptionsForField = ESC_ObjectSchemaHelper.getPickListOptions(objectVal,filterInstance.FieldApiName );
                            filterInstance.isPickList = true;
                           // filterInstance.FieldValue= '.--None--.';
                            filterInstance.isTextBox = false;
                            filterInstance.isRender = false;

                        }

                        else if(filterInstance.FieldType.contains('BOOLEAN')){

                            filterInstance.isCheckBox = true;
                            filterInstance.FieldValue= 'false';
                            filterInstance.isTextBox = false;
                            filterInstance.isRender = false;

                        }
                        
                        else if (isFormulaField){
                            filterInstance.isFormula = true;
                        }
                        else if((new set<string>{'DOUBLE'}).contains(filterInstance.FieldType)){
                            filterInstance.isInteger = true;
                            //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info , fieldApiName + ' '+filterInstance.FieldType));
                        }
                        /*  else{
                            filterInstance.FieldLabel =  filterInstance.FieldLabel + ' *';
                        }*/
                    }
                }
            }

        }

        System.debug('setFilterMapFields ended '+resultTableLabel);


        getFieldLabel();
    }

    public void getFieldLabel(){

        Map<string,string> objectFieldInfo;
        for(string keyObj : resultTableLabel.keyset()){

            for(string keyFieldapi: ( resultTableLabel.get(keyObj)).keyset() )
            {
                string fieldName = keyFieldapi.toLowerCase();
                string objectVal = keyObj.toLowerCase();
                string labelName = resultTableLabel.get(keyObj).get(fieldName);
                system.debug(fieldName +' HAS labelName ' + labelName);
                if(string.isBlank(labelName)){
                    system.debug('Inside foRlabelName ' + labelName);

                    if(fieldName.contains('.')){
                        string[] objField = fieldName.split('\\.');
                        string parentObject = objField[0];
                        string parentObjectField = objField[1];
                        objectFieldInfo= objectSchemaForSet.get(parentObject);
                        string typeLabel = objectFieldInfo.get(parentObjectField);
                        if(!string.isBlank(typeLabel)){

                            string[] splitVal = typeLabel.split(':');
                            resultTableLabel.get(keyObj).put(keyFieldapi, splitVal[1]);

                        }

                    }
                    else{
                        objectFieldInfo= objectSchemaForSet.get(objectVal);
                        string typeLabel = objectFieldInfo.get(fieldName);

                        if(!string.isBlank(typeLabel)){

                            string[] splitVal = typeLabel.split(':');
                            string label = splitVal[1];
                            resultTableLabel.get(keyObj).put(keyFieldapi, splitVal[1]);

                        }
                    }
                }
            }

        }



    }



    public ESC_GlobalObjectSearchController(){
        System.debug('ESC_GlobalObjectSearchController called');
        setFilterResultsMap();
        isSearchValid = false;
        hasSOQLClause= false;
        dte = new ESC_DataTableEntity();
        val1 ='';
        searchResults = new List<sobject>();
        currentTheme = false;
        String theme = UserInfo.getUiThemeDisplayed();
        if(theme == 'Theme4u' || theme == 'Theme4d'){
            currentTheme = true;
        }
        //added for DSS-5594
         map<string,string> paramMap = System.currentPageReference().getParameters();
        set<string> paramList = paramMap.Keyset();
        System.debug('Url from Ttech--->'+System.currentPageReference().getUrl());
        System.debug('Parammap--->'+paramMap);
        if(paramList.contains('Key1') || paramList.contains('Key2') || paramList.contains('Key3')||paramList.contains('Key4')){
        searchSAP= System.currentPageReference().getParameters().get('Key1');
        searchPhone= System.currentPageReference().getParameters().get('Key2');
        searchPhone2= System.currentPageReference().getParameters().get('Key3');
        searchContact= System.currentPageReference().getParameters().get('Key4');
        if((searchSAP != null && searchSAP != '') && searchSAP != 'NA'){
            System.debug('entered first if with SAP = '+searchSAP+'phone='+searchPhone+'phone2='+searchPhone2+'Contactid='+searchContact);
            isSearchValid = true;
            hasSOQLClause= true;
            val1 = 'Source_System_Detail__c';
            filterSecondary = 'where id!= null and Source_System_Account_Number__c = \'' + searchSAP +'\'';
            runsearchTtech();
        }
        else if((searchContact != null && searchContact != '') && searchContact.startsWith('003')){
            System.debug('entered second else if with Contactid  = '+searchSAP+'phone='+searchPhone+'Contactid='+searchContact);
            isSearchValid = true;
            hasSOQLClause= true;
            val1 = 'Contact';
            filterSecondary = 'where id = \'' + searchContact + '\'';
            runsearchTtech();
        }
        else if((searchPhone != null && searchPhone != '') || (searchPhone2 != null && searchPhone2 !='')){
            System.debug('entered third else if with searchPhone or searchPhone2  = '+searchSAP+'phone='+searchPhone+'phone2='+searchPhone2+'Contactid='+searchContact);
            isSearchValid = true;
            hasSOQLClause= true;
            val1 = 'Contact';
            string phone ='';
            if((searchPhone != null && searchPhone != '') && (searchPhone2 == null || searchPhone2 =='')){
                phone = searchPhone;
            }
            else if ((searchPhone == null || searchPhone == '') && (searchPhone2 != null && searchPhone2 !='')){
                phone = searchPhone2;
            }
            else if ((searchPhone != null && searchPhone != '') && (searchPhone2 != null && searchPhone2 !='') && (searchPhone == searchPhone2)){
                phone = searchPhone2;
            }
            if(phone != ''){
            filterSecondary = 'where id!= null and (USL_IVR_Phone_Number__c = \'' + phone + '\'OR  Standardized_Phone__c= \'' + phone + '\'OR  Standardized_MobilePhone__c = \'' + phone + '\' OR Standardized_OtherPhone__c = \'' + phone + '\')' ;
            }
            else
            {
            filterSecondary = 'where id!= null and (USL_IVR_Phone_Number__c = \'' + searchPhone + '\'OR  Standardized_Phone__c= \'' + searchPhone + '\'OR  Standardized_MobilePhone__c = \'' + searchPhone + '\' OR Standardized_OtherPhone__c = \'' + searchPhone + '\' OR USL_IVR_Phone_Number__c = \'' + searchPhone2 + '\'OR  Standardized_Phone__c= \'' + searchPhone2 + '\'OR  Standardized_MobilePhone__c = \'' + searchPhone2 + '\' OR Standardized_OtherPhone__c = \'' + searchPhone2 +'\')';
            }
            runsearchTtech();
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_SearchPageNoResults));
        }
        }          
    }
    
    public void runsearchTtech(){
        isSearchSuccessful = false;
        system.debug('$$$ Radio Option: '+filterMap);
        searchResults = new List<sObject>();
        try{
           // validfySearch();
            if((!isSearchValid && !hasSOQLClause ) ){

                throw new ESC_HandlerCustomException('Error');
            }

            else if(isSearchValid && !hasSOQLClause ){
               string querySOSl = formQuerySOSL();
               List<List<sObject>> searchList = search.query(querySOSl);
                if(searchList[0] != null && (searchList[0]).size() >0 ){
                    searchResults= searchList[0] ;
                }
            }
            else{
                string querySoql = formQuerySOQL();
                searchResults = Database.query(querySoql);
            }
            system.debug('@@searchresults' + searchResults);
            if(searchResults == null || searchResults.size()==0){
                throw new ESC_HandlerCustomException('Info Zero Results');
            }
        }
        catch(ESC_HandlerCustomException ex){
            if(ex.getMessage().equals('Error')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ESC_SearchPageError));
            }

            else if(ex.getMessage().equals('Info Zero Results')){

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_SearchPageNoResults));
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getmessage()));
        }
         isSearchSuccessful = true;
        setPaginationController();
    }

    private Boolean validfySearch(){
        
        isSearchValid = false;
        hasSOQLClause = false;
        if(filterMap !=null){
            collectQueryParams = filterMap.get(val1);
            system.debug(val1 + ':' + collectQueryParams);
            if(collectQueryParams !=null){
                primaryKeyWord='id !=null';
                string temPrim='';
                string appendCondition=' and ';
                mainSearchKeyword ='';
                integer counter = 0;
                integer varCounter = 0;
                filterSecondary = 'where id!= null';
                for(ESC_GlobalObjectSearchFilterInstance globalInstance : collectQueryParams){
                    string tempWord= globalInstance.FieldValue.trim();
                    string fieldType = globalInstance.fieldType;

                    if(String.isNotBlank(tempWord) || globalInstance.mPickListVals.size() >0)
                    {
                          system.debug(fieldType);
                         system.debug(JSON.serialize(tempWord));
                        system.debug(JSON.serialize(globalInstance.mPickListVals));
                        if(globalInstance.isPickList && tempWord.equalsignorecase('.--None--.')){
                            continue;
                        }

                        else{
                            tempWord= String.escapeSingleQuotes(tempWord);
                            if(globalInstance.isCheckBox || globalInstance.isInteger ){
                                filterSecondary +=' and ' + globalInstance.FieldApiName + ' =' + tempWord;
                                hasSOQLClause = true;
                                varCounter+=1;
                            }
                            
                            
                             else if(globalInstance.isMPickList ){
                              //  filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \'%' + tempWord + '%\'';
                                if(globalInstance.mPickListVals.size() >= 1){
                               tempWord = string.join(globalInstance.mPickListVals , ';' );
                              

                                  filterSecondary +=' and ' + globalInstance.FieldApiName + ' =\''+ tempWord +'\'';
                                hasSOQLClause = true;
                                varCounter+=1;
                                }
                            }

                            else if(globalInstance.isPickList){
                              //  filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \'%' + tempWord + '%\'';
                              /*
                                filterSecondary +=' and ' + globalInstance.FieldApiName + ' =\''+ tempWord +'\'';
                                hasSOQLClause = true;
                                varCounter+=1;*/
                                system.debug('its picklist'+globalInstance.mPickListVals);
                                 if(globalInstance.mPickListVals.size() >= 1){
                                     tempWord = '';
                                     for(string tempSTR :globalInstance.mPickListVals){
                                        tempWord += '\''+tempSTR  +'\',';
                                     }
                                     tempWord = tempWord.substring(0, tempWord.length()-1);


                                  filterSecondary +=' and ' + globalInstance.FieldApiName +' in ('+ tempWord +')';
                                hasSOQLClause = true;
                                varCounter+=1;
                                }
                            }

                            else if(globalInstance.isFormula){
                              //  filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \'%' + tempWord + '%\'';
                               
                                if(globalInstance.isSW == false){
                                    filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \''+ tempWord + '%\'';
                                }
                                else if(globalInstance.isMA == false){
                                    filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \'%' + tempWord + '%\'';
                                }
                                else if(globalInstance.isEM == false){
                                    filterSecondary +=' and ' + globalInstance.FieldApiName + ' =\''+ tempWord +'\'';
                                }
                                hasSOQLClause = true;
                                varCounter+=1;
                            }


                            else {
                                // condition for normal text searches
                                if(!globalInstance.FieldApiName.contains('.')){
                                    mainSearchKeyword+= counter==0 ? ('\'*' +tempWord+'*' ):(appendCondition+('*' +tempWord+'*' ));
                                    if(globalInstance.isMA == null){
                                    counter++;
                                    } else{
                                    hasSOQLClause = true;
                                    varCounter+=1;
                                    }
                                    system.debug(globalInstance.isMA+' Incrementing counter'+counter);
                                }
                                else{
                                    hasSOQLClause = true;
                                    varCounter+=1;
                                }
                                //filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \'%' + tempWord + '%\'';
                                if(globalInstance.isSW == false){
                                    filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \''+ tempWord + '%\'';
                                }
                                else if(globalInstance.isMA == false){
                                    filterSecondary +=' and ' + globalInstance.FieldApiName + ' LIKE \'%' + tempWord + '%\'';
                                }
                                else if(globalInstance.isEM == false){
                                    filterSecondary +=' and ' + globalInstance.FieldApiName + ' =\''+ tempWord +'\'';
                                }

                            }


                        }
                    }

                }
                system.debug(' counter: '+counter + mainSearchKeyword);
                isSearchValid = ((counter>=2 ) || (counter==1 && mainSearchKeyword.length()>=5)) ? true : false;
                system.debug('b4 hasSOQLClause: '+hasSOQLClause );
                hasSOQLClause = varCounter >=1 ? true:false;
                system.debug('a4 hasSOQLClause: '+hasSOQLClause );
                mainSearchKeyword+='\'';
            }

        }
        filterSecondary = filterSecondary.replace('id!= null and', '');
        return isSearchValid;
    }
    
    
   @testvisible private string mergeTolabel(){

        map<string, List<string> > temMap = new map<string, List<string> >(resultMap);
        List<string> fieldNames = temMap.get(val1);
       integer j =fieldNames.size();
        string valueTOReturn ='';
        for(integer i=0 ; i<j; i++ ){
        if(fieldNames[i].contains('recordtype.name')){
             valueTOReturn += 'toLabel('+fieldNames[i]+'),' ;
            }else if(fieldNames[i].contains('__r.name')){
            List<string>  tempParamValue = new List<String>();
              tempParamValue =fieldNames[i].split('\\.');
              string tempValue;
                if(tempParamValue[0].contains('__r')){
                    tempValue= tempParamValue[0].replace('__r','__c');
                }else{
                    tempValue= tempParamValue[0];
                }
                valueTOReturn += fieldNames[i]+','+tempValue+',';
            }else{
             valueTOReturn +=  fieldNames[i]+',';
            }

        }
        valueTOReturn  =  valueTOReturn.substringBeforeLast(',');
        return  valueTOReturn;
    }
    
    private string getLimit(){
        if(!test.isRunningTest()){
          return label.ESC_MaxRecords;
        }
         return '300';
    }
   @testvisible private string formQuerySOSL(){
        string query = '';
        string fieldsToBeReturned= mergeTolabel();
        string limitClause=' Limit '+getLimit();
        query= 'FIND '+mainSearchKeyword +' IN ALL FIELDS RETURNING ' +val1+ ' ('+fieldsToBeReturned+' '+filterSecondary+')' +limitClause;
        system.debug('formQuery() type sosl execution ended'+ query);
        return query;
    }

    private string formQuerySOQL(){
        string query = '';
        string fieldsToBeReturned = mergeTolabel();
        string limitClause=' Limit '+getLimit();
        query = 'select ' +fieldsToBeReturned +' from '+val1 + ' '+ filterSecondary+' '+ limitClause;
        system.debug('formQuerySOQL() execution ended'+ query);
        return query;
    }
    public void runsearch(){
        isSearchSuccessful = false;
        system.debug('$$$ Radio Option: '+filterMap);
        searchResults = new List<sObject>();
        try{
            validfySearch();
            if((!isSearchValid && !hasSOQLClause ) ){

                throw new ESC_HandlerCustomException('Error');
            }

            else if(isSearchValid && !hasSOQLClause ){
               string querySOSl = formQuerySOSL();
               List<List<sObject>> searchList = search.query(querySOSl);
                if(searchList[0] != null && (searchList[0]).size() >0 ){

                    searchResults= searchList[0] ;
                }
            }
            else{
                string querySoql = formQuerySOQL();
                searchResults = Database.query(querySoql);
            }
            system.debug('@@searchresults' + searchResults);
            if(searchResults == null || searchResults.size()==0){
                throw new ESC_HandlerCustomException('Info Zero Results');
            }
        }
        catch(ESC_HandlerCustomException ex){
            if(ex.getMessage().equals('Error')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ESC_SearchPageError));
            }

            else if(ex.getMessage().equals('Info Zero Results')){

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_SearchPageNoResults));
            }


        }
        catch(Exception ex){

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getmessage()));
        }
         isSearchSuccessful = true;
        setPaginationController();

    }

    public void setLinkValues(){
        Map<string, Boolean> linkForSearchedObj = showAsLink.get(val1);


    }


    public void setPaginationController(){
        if(string.isBlank(paginationSizeOpns)){
        List<integer> paginationSizeList = new list<Integer>();
        
        boolean textField = null;

        for(ESC_PaginationValuesGlobalSearch__c pgntnVal : ESC_PaginationValuesGlobalSearch__c.getall().values() ){
            paginationSizeList.add(integer.valueOf(pgntnVal.PaginationValue__c));

        }


        paginationSizeList.sort();
        paginationSizeOpns = Json.serialize(paginationSizeList);
        }
        system.debug('setPaginationController called'+paginationSizeOpns);
    }

    public void runFreshSearch() {
        //setFilterResultsMap();
        system.debug('selectedTab  obj IS: '+selectedTab);
        for(List<ESC_GlobalObjectSearchFilterInstance> tempList:filterMap.values()){
            for(ESC_GlobalObjectSearchFilterInstance temp:tempList){
           
            temp.initializeDefaults();
            }
        }
        isSearchValid = false;
        //getPanelVisibilty();


    }


    public class ESC_GlobalObjectSearchFilterInstance implements Comparable {
        public string fieldValue { get; set;}
        public string fieldLabel { get; set;}
        public boolean showInFiter {get; set;}
        public List<String> mPickListVals {get; set;}

        public string fieldApiName {get; set;}
        public string objectName {get
            {
            return objectName.toUpperCase();
            } set;}
        public Integer sequence;
        public string parentObj {get; set;}
        public boolean isHiddenFromResults { get;set;}
        public string fieldType {get; set;}
        public Boolean isCheckBox {get; set;}
        public Boolean isInteger {get; set;}
        public Boolean isPickList {get; set;}
        public Boolean isMPickList {get; set;}
        public Boolean isFormula {get; set;}
        public Boolean isTextBox {get; set;}
        public List<SelectOption> optionsForField {get; set;}
        public Boolean isSW {get; set;}
        public Boolean isEM {get; set;}
        public Boolean isMA {get; set;}
        public Boolean isRender {get; set;}
        ESC_SearchSettings__mdt temp ;

        public ESC_GlobalObjectSearchFilterInstance(string objectNameVal, string fieldApiNameVal, string labelName , ESC_SearchSettings__mdt esc){
            this.fieldApiName = fieldApiNameVal.toLowerCase();
            this.objectName = objectNameVal;
            this.fieldLabel = labelName;
            
           temp = esc;
           this.showInFiter = temp.ESC_HFF__c == null || !temp.ESC_HFF__c? true : false;
            this.fieldType = '';
            this.parentObj ='';
            this.optionsForField = new List<SelectOption>();
            this.isPickList = false;
            this.isMPickList = false;
            this.isCheckBox = false;
            this.isInteger = false;
            this.isTextBox = True;
            this.isFormula = false;
           
            initializeDefaults();
           

        }
        void getDefaultValueOfField(){
            this.fieldValue = '';
             this.mPickListVals = new List<string>();
            if(string.isNotBlank(this.temp.ESC_Def__c)){
                if(this.temp.ESC_Def__c.contains(',')){
                    this.mPickListVals = this.temp.ESC_Def__c.split(',');
                }
                else {
                    this.fieldValue = this.temp.ESC_Def__c;
                }
            }
        }
        
        
        public void initializeDefaults(){
              getDefaultValueOfField();
            this.isSW = false;
            this.isEM = true;
            this.isMA = true;
             this.isRender = this.isRender == null || this.isRender ? true : false;
            
        }

        public Integer compareTo(Object compareTo) {
            ESC_GlobalObjectSearchFilterInstance compareRecord = (ESC_GlobalObjectSearchFilterInstance)compareTo;
            if (sequence == compareRecord.sequence) {return 0;}
            if (sequence > compareRecord.sequence) {return 1;}
            return -1;        
        }


    }

    public class  ESC_Results {
        public sObject searchResult {get; set;}
        public Boolean isLink{get; set;}

    }
    public Component.Apex.TabPanel getMyTabs()
    {
     
        //create parent panelComponent.Apex.TabPanel myTabPanel = new Component.Apex.TabPanel();
        Component.Apex.TabPanel myTabPanel = new Component.Apex.TabPanel();
        if(hasRecords){
          System.debug('getMyTabs called string.isBlank(selectedTab)'+string.isBlank(selectedTab));
       selectedTab = string.isBlank(selectedTab)? new list<string>(keyObjects) [0] :selectedTab;
        myTabPanel.switchtype= 'client';
       String theme = UserInfo.getUiThemeDisplayed();
        if(theme == 'Theme4u' || theme == 'Theme4d'){
               myTabPanel.tabClass = 'tabCustom';
         }
         myTabPanel.value ='{!selectedTab}';       
        
         
        for (string obj: keyObjects) 
        {
            Integer i=0;
            Component.Apex.Tab myTab = new Component.Apex.Tab();
            myTab.name = obj;

            List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{obj}); // this can accept list of strings, we describe only one object here
            String objectLabel = describeSobjectsResult[0].getLabel();
            myTab.Label = objectLabel;
            //add child tabs to the parent            
     

            Component.Apex.PageBlockTable table = new Component.Apex.PageBlockTable();
            table.value=filterMap.get(obj);
            table.var = 'filterCriteria';
            //table.style='text-align:center';
            table.columnClasses = 'myRows '+obj;
             table.onkeypress = 'return noenter(event,\''+ obj +'\')';
           // table.columnsWidth = '20px, 100px ,40px,40px,40px';
           

            Component.Apex.Column firstNameCol = new Component.Apex.Column(headerValue=Label.ESC_Field_Label,headerclass ='vertical');
            firstNameCol.expressions.value = '{!filterCriteria.FieldLabel}';
            

            Component.Apex.Column secondColumn = new Component.Apex.Column(headerValue=Label.ESC_Field_Value,headerclass ='vertical');
            Component.Apex.Inputtext inp = new Component.Apex.Inputtext();
            //inp.onkeypress = 'return noenter(event,\''+ obj +'\')';
            inp.styleclass = obj+'_mtText';
            inp.style = 'width:115px';
            Component.Apex.inputCheckbox inputCheckbox = new Component.Apex.inputCheckbox();
            Component.Apex.selectList inpSelect = new Component.Apex.selectList(multiselect = true);
            Component.Apex.selectOptions inpSelectVal= new Component.Apex.selectOptions();
            /*
            Component.Apex.selectOption inpSelectValNone= new Component.Apex.selectOption();
            inpSelectValNone.itemvalue='.--None--.';
            inpSelectValNone.itemLabel='--None--';*/
           
            inpSelect.size = 3;
            
             Component.Apex.selectList inpMSelect = new Component.Apex.selectList(multiselect = true);
             
            Component.Apex.selectOptions inpMSelectVal= new Component.Apex.selectOptions();
             
            inpMSelect.size = 3;


            inp.expressions.value = '{!filterCriteria[\'FieldValue\']}';
            inp.expressions.rendered = '{!filterCriteria[\'isTextBox\']}';

            inpSelect.expressions.value = '{!filterCriteria[\'mPickListVals\']}';
            
            inpSelectVal.expressions.value = '{!filterCriteria[\'OptionsForField\']}';
            inpSelect.expressions.rendered =  '{!filterCriteria[\'isPicklist\']}';
            
            inpMSelect.expressions.value = '{!filterCriteria[\'mPickListVals\']}';
            inpMSelectVal.expressions.value = '{!filterCriteria[\'OptionsForField\']}';
            inpMSelect.expressions.rendered =  '{!filterCriteria[\'isMPicklist\']}';
            
            //inpSelect.childComponents.add(inpSelectValNone);
            inpSelect.childComponents.add(inpSelectVal);
           
             inpMSelect.childComponents.add(inpMSelectVal);

            inputCheckbox.expressions.value = '{!filterCriteria[\'FieldValue\']}';
            inputCheckbox.expressions.rendered =  '{!filterCriteria[\'isCheckBox\']}';


            secondColumn.childComponents.add(inp);
            secondColumn.childComponents.add(inpSelect);
            secondColumn.childComponents.add(inpMSelect);
            secondColumn.childComponents.add(inputCheckbox);            
           
            Component.Apex.commandButton cmdBtn = new Component.Apex.commandButton();            
            cmdBtn.value = ESC_DataTableEntity.getLabelValue('ESC_SearchBTN');           
            cmdBtn.onclick = 'refreshPageTable(\''+obj+'\'); return false;'; 
         
            
            Component.Apex.commandButton cmdBtn1 = new Component.Apex.commandButton();            
            cmdBtn1.value = Label.ESC_ResetBTN;          
            cmdBtn1.onclick = 'resetSearchJSMethod(\''+obj+'\'); return false;';  
            cmdBtn1.style='margin-left:10px';     
              

            table.childComponents.add(firstNameCol);    
            table.childComponents.add(secondColumn);
            table.childComponents.add(getMyColumn(Label.ESC_Starts_With,obj ,'{!filterCriteria[\'isSW\']}','{!filterCriteria[\'isRender\']}'));
            table.childComponents.add(getMyColumn(Label.ESC_Match_Anywhere,obj ,'{!filterCriteria[\'isMA\']}','{!filterCriteria[\'isRender\']}'));
            table.childComponents.add(getMyColumn(Label.ESC_Exact_Match,obj ,'{!filterCriteria[\'isEM\']}','{!filterCriteria[\'isRender\']}')); 

            Component.Apex.OutputPanel dynOutPanel= new Component.Apex.OutputPanel();
            // dynOutPanel.childComponents.add(sr);           
            
            dynOutPanel.childComponents.add(cmdBtn); 
            dynOutPanel.childComponents.add(cmdBtn1);
            dynOutPanel.layout='block';
            dynOutPanel.style='text-align: center;' ;                
            table.facets.footer = dynOutPanel;            
            //table.style='text-align:center(dynOutPanel)';                                
            myTab.childComponents.add(table);
            myTabPanel.childComponents.add(myTab);      
             i++; 
                              
           
                     
          
        } 
        
        
         // reset searchbutton       
           
        myTabPanel.selectedTab = selectedTab;
        System.debug('myTabPanel execution ends: '+myTabPanel.childComponents);
        }
        return myTabPanel;
    }

    private  Component.Apex.Column getMyColumn(string header , string obj , string value, string isRender){
        Component.Apex.Column thirdColumn = new Component.Apex.Column(headerValue=header,headerclass ='vertical');
        Component.Apex.selectRadio sr= new Component.Apex.selectRadio();
        sr.styleclass = 'radIo';
        sr.expressions.value = value;
        sr.expressions.rendered = isRender;        
        sr.onclick = 'runRadio(\''+obj+'\',this)'; 
        
        Component.Apex.selectOption so2 = new Component.Apex.selectOption();
        so2.itemvalue=header;
        so2.itemLabel='';
        sr.childComponents.add(so2);
        thirdColumn.childComponents.add(sr);

        return thirdColumn;
    }
    
    public String searchCategory;

    public String getsearchCategory()
    {
        return searchCategory;
    }

    public void setsearchCategory(String searchCategory)
    {
        this.searchCategory = searchCategory;
    }   


}