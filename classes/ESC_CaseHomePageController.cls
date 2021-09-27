global with sharing class ESC_CaseHomePageController {
  public static Boolean noBandShow{get; set;}
  public static List<Result> resultList{ get; set;}
  List<string> blockNames{get; set;}
  public  string showAllData{get; set;}
  static Boolean isInitialized;
  public string localName{get; set;}
  public List<TruncateInfo> tr ;
  public static Component.Apex.OutputPanel myPanel{get; set;}
  Map <String, Schema.SObjectType> schemaMap ;
  Map<string,string>  relationFieldObjMap ;
  public static  List<Dashboard> lstdbs{get;set;}
  public static Map<string,string> objecctPreZMap = new Map<String,string>();
  static string overRiddenProfileId;
  public static string pageName;
   public static string overRiddenQuery;
  public string currentvfpage{get;set;}
  public string overriddenLimit{get;set;}
  public string groups{get; set;}
  public static string style {get;set;}
  public static ESC_MilestoneAlertConfigSetting__c mac; 
  public static Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
  public static Integer totSize{get;set;}
  public static Integer missedCount{get;set;}  
  static String jsonMapRec;
  public static Boolean milestonepage{get; set;}
  public static Boolean isMSreferral{get; set;}
  public static Map<string,string> dateFormatMap;
  public string localeValue;
  public string currentDateFormat{get;set;}
 
public string getlocale(){
    string userLanguage = [SELECT LanguageLocaleKey,LocaleSidKey  FROM User WHERE Id = :UserInfo.getUserId()].LocaleSidKey ;
    
    return userLanguage;
}

  public Boolean getInitializedStatus(string pageName){
   
    totSize = 0;
    missedCount=0;
    schemaMap = Schema.getGlobalDescribe();
    resultList = new List<Result>();
   
   //
    list<QueryBuilder> queryList = initializeApplicableQueriesFromObject(pageName);
    system.debug('Executed initializeApplicableQueriesFromObject');



    for(QueryBuilder qbd: queryList ){

      Result res= new Result(qbd);
      resultList.add(res);


    }
     system.debug('Executed  running ApplicableQueriesFromObject');
    addAdditionalInfo();
    system.debug('Executed addAdditionalInfo');
    if(!milestonepage){
        filterOnBaseOfSecondColumn();
    }
    //jsonString=jsonString.replace('"', '&quot;');
   // system.debug('jsonString' +JSON.serialize(resultList));
    return false;
  }
  public map<string,object> convertTolowerAllkeys(Map<string,object> v){
      Map<string,object> newMap = new  map<string,object> ();
      for(string key : v.keySet()){
         newMap.put(key.toLowerCase(),v.get(key));
      }
      return newMap;
  }
  public void filterOnBaseOfSecondColumn(){
    //  system.debug('filterOnBaseOfSecondColumn');
      for(Result resO : resultList){
          if(!resO.isFirstHidden){
               // system.debug(' free to go');
           continue;}
          
            List<SObject> filteredResults = new List<SObject>();
            List<SObject> nonFilteredResults =resO.resultObj;
            set<string> usedKeys = new set<string>();
         
            string firstField = resO.apiNames[1];
             //system.debug('found first hidden' +firstField);
            for(SObject sobj : nonFilteredResults){
                  Map<String,Object> fieldMap =convertTolowerAllkeys(sobj.getPopulatedFieldsAsMap());
                // system.debug('the keySet' +fieldMap.keySet());
                string fieldValue = '';
                if(firstField.contains('.')){
                   object o = fieldMap.get(firstField.substringBefore('.'));
                   SObject sc = (SObject)o;
                   fieldValue =(string)sc.get(firstField.substringAfter('.'));
                  //  system.debug('field val'+sc.get(firstField.substringAfter('.')));
                }
                else{
                    fieldValue = ''+fieldMap.get(firstField);
                }
                
             
               
                if(!usedKeys.contains(fieldValue)){
                    filteredResults.add(sobj);
                    usedKeys.add(fieldValue);
                }
                else{
                     system.debug('usedKeys contains already '+fieldValue);
                }

            }
            if(filteredResults.size() >0){
                resO.resultObj = filteredResults;
            }
      }
     
  }

  public string getDataTableEntity(){
    ESC_DataTableEntity dte = new ESC_DataTableEntity();
    List<ESC_DataTableEntity> dteList = new List<ESC_DataTableEntity>();
    dteList.add(dte);
    return JSON.serialize(dteList);
  }

  @testvisible public string getObjectNameForRelation(string refObj, string fieldAPIName){
    if(relationFieldObjMap == null){
      relationFieldObjMap = new Map<string,string>();
    }
    schemaMap = schemaMap == null? Schema.getGlobalDescribe() :schemaMap ;
    string obj = fieldAPIName.split('\\.')[0];
    string tempObj = obj.replace('__r', '__c');
    string key = obj+':'+tempObj;
    if(relationFieldObjMap.containsKey(key)){
      return relationFieldObjMap.get(key);
    }
    Map <String, Schema.SObjectField> fieldMap = schemaMap.get(refObj).getDescribe().fields.getMap();
    Schema.SObjectField sfield=fieldMap.get(tempObj);
    schema.describefieldresult dfield = sfield.getDescribe();
    for(Schema.SObjectType reference : dfield.getReferenceTo()) {
      obj = reference.getDescribe().getName();

    }
    relationFieldObjMap.put(key , obj);
    return obj;
  }
 

  //will merge all applicable permission set and the permission set handling the profiles in the scenario as applicable
  //1) if profile is overriddedn using query parameter , in that scenario only profile related PermissionSet will be used
  //2) in scenario where its running in normal mode, there in all PermissionSets applicable to logged in user and its profile will be used
  @testvisible private List<string> getApplicablePermissionSetIds(){

    List<string> applicableIDS = new List<string>();
    if(string.isBlank(overRiddenProfileId)){
      //system.debug('overRiddenProfileId isBlank');
      string currentUserId = userinfo.getUserId();
      for(PermissionSet psObj :  [SELECT Id FROM PermissionSet where id in (SELECT PermissionSetId
          FROM PermissionSetAssignment
          WHERE Assigneeid = :currentUserId) and IsOwnedByProfile = false]){
        applicableIDS.add(psObj.id);
      }
      applicableIDS.add([select id from permissionset where ProfileId = :userinfo.getProfileId()][0].id);


    }
    else{
      applicableIDS.add([select id from permissionset where ProfileId = :overRiddenProfileId][0].id);
    }
  //  system.debug('applicableIDS'+applicableIDS);
    return applicableIDS;
  }

  //method to get visibility of fields for a set 
  /*
  @testvisible private Map<string, Map<string,Boolean>> getInfoFieldVisibility(set<string> selectedObjSet){
    Map<string, Map<string,Boolean>> fieldVisibiltyMap = new Map<string, Map<string,Boolean>>();
    List<string> applicableIDS = getApplicablePermissionSetIds();
    //system.debug('applicableIDS-->' + applicableIDS);
    string currentUserProfileId = string.isBlank(overRiddenProfileId)? userinfo.getProfileId() :overRiddenProfileId  ;
    //system.debug('overRiddenProfileId-->'+overRiddenProfileId +'userinfo.getProfileId() is ' +userinfo.getProfileId());
    for(string objectI : selectedObjSet  ){
        system.debug('objectI'+objectI);
      List< Schema.SObjectField> fields = schemaMap.get(objectI).getDescribe().fields.getMap().Values();



      Map<string,Boolean> temVisi = new Map<string,Boolean>();
      for(FieldPermissions fp : [SELECT Id, Field, SObjectType, PermissionsRead FROM FieldPermissions WHERE SObjectType = :objectI and parentid in :applicableIDS]){
        string fieldName = fp.Field.toLowerCase().split('\\.')[1];
        //system.debug('fp-->'+fp);

        system.debug(fp.PermissionsRead+' visible ||fieldName-->'+fieldName);
        temVisi.put(fieldName , true);



      }


      fieldVisibiltyMap.put(objectI.toLowerCase() ,temVisi );
    }



    //system.debug('getInfoFieldVisibility-->'+fieldVisibiltyMap);

    return fieldVisibiltyMap;
  }
  
  */
  /*
    This method is responsible to query HOMEPAGEQUERY object records based on profile. Also the visibility of users visibiity will be done
    
    */
    private string getProfileNameOfLoggedInUser(){
       string currentUserProfileId = string.isBlank(overRiddenProfileId)?userinfo.getProfileId() :overRiddenProfileId  ;

    string currentUserProfile = [select Name from profile where id = :currentUserProfileId][0].name;
    currentUserProfile ='\'%'+currentUserProfile+'%\'';
    return currentUserProfile;
    }
  @testvisible    private list<QueryBuilder>  initializeApplicableQueriesFromObject(string pageName){

    list<QueryBuilder> queryList = new list<QueryBuilder> ();
    Map<string, Boolean> objectVisibiltyMap = new Map<string, Boolean>(); 

    set<string> queryAPINames= new set<string>();
    integer limitVal = 800;
    
   string  currentUserProfile  = getProfileNameOfLoggedInUser();
    string objectVisibilityQuery = 'SELECT PermissionsRead,SobjectType FROM ObjectPermissions WHERE (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE Assignee.ID= \''+String.escapeSingleQuotes(userinfo.getUserId())+'\'))';
    for(ObjectPermissions op: Database.query(objectVisibilityQuery)){
      objectVisibiltyMap.put( op.SobjectType , op.PermissionsRead);
      //system.debug('objectVisibiltyMap'+op.SobjectType +' : ' +op.PermissionsRead);
    }
    //system.debug('pageName'+pageName);
    if(milestonepage){
        mac = ESC_MilestoneAlertConfigSetting__c.getValues('1');
   
        string query = string.isBlank(localName)?'SELECT name,ESC_OWidths__c,ESC_DefOrder__c,ESC_ShowAccept__c,ESC_DefaultSortCol__c,ESC_AssignedTo__c,ESC_FilterCriteria__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,ESC_IsFirstHidden__c ,ESC_ReturnedColumns__c,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c,ESC_ReturnedSecondaryColumns__c,ESC_Milestone_Name__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+' and ESC_isInActive__c = false and ESC_isMissedMilestone__c = true order by ESC_Sequence__c nulls last limit '+limitval:
          'SELECT name,ESC_OWidths__c,ESC_ShowAccept__c,ESC_DefOrder__c,ESC_AssignedTo__c,ESC_FilterCriteria__c,ESC_DefaultSortCol__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,ESC_ReturnedColumns__c,ESC_IsFirstHidden__c ,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c,ESC_ReturnedSecondaryColumns__c,ESC_Milestone_Name__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+'and name =\''+localName+'\'  and ESC_isInActive__c = false and ESC_isMissedMilestone__c = true order by ESC_Sequence__c nulls last limit '+limitval;
       // system.debug('MissedMileStone query: '+query);
        
        for(ESC_HomePageQuery__c block: Database.query(query)){
          if(objectVisibiltyMap.containsKey(block.ESC_ObjectType__c) && !objectVisibiltyMap.get(block.ESC_ObjectType__c)){
            continue;
          }
        
          QueryBuilder qbd= new QueryBuilder(block,pageName);
          queryList.add(qbd);
        }
       
      // style = setcolour(9);
    }
    else{
        
        string query = string.isBlank(localName)?'SELECT name,ESC_OWidths__c,ESC_DefOrder__c,ESC_ShowAccept__c,ESC_DefaultSortCol__c,ESC_AssignedTo__c,ESC_FilterCriteria__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,ESC_IsFirstHidden__c ,ESC_ReturnedColumns__c,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+' and ESC_isInActive__c = false order by ESC_Sequence__c nulls last limit '+limitval:
          'SELECT name,ESC_ShowAccept__c,ESC_OWidths__c,ESC_DefOrder__c,ESC_AssignedTo__c,ESC_DefaultSortCol__c,ESC_FilterCriteria__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,ESC_ReturnedColumns__c,ESC_IsFirstHidden__c ,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+'and name =\''+localName+'\'  and ESC_isInActive__c = false order by ESC_Sequence__c nulls last limit '+limitval;
        // //system.debug('query'+query);
        //string query = 'SELECT name,ESC_AssignedTo__c,ESC_FilterCriteria__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,name,ESC_ReturnedColumns__c,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+' order by ESC_Sequence__c nulls last limit '+limitval;
        for(ESC_HomePageQuery__c block: Database.query(query)){
          if(objectVisibiltyMap.containsKey(block.ESC_ObjectType__c) && !objectVisibiltyMap.get(block.ESC_ObjectType__c)){
            continue;
          }
         
          QueryBuilder qbd= new QueryBuilder(block,pageName);
          queryList.add(qbd);
          
    }
     queryList.sort();
    } 

    return queryList;
  }
  @testvisible    private string getValueFromLabel(string customLabelName){

    if(string.isBlank(customLabelName)){
      return '';
    }

    else{
      try{
        return String.valueOf(  ESC_DataTableEntity.getLabelValue(customLabelName));    
      }

      catch(exception ex){

        return '';
      }
    }

  }
  @testvisible    private  Map<string , string> getOverRiddenNames(string names){

    Map<string , string> fieldNameMapO = new Map<string,string>();
   
    if(string.isNotBlank(names)){
      for(string namePair : names.split(',')){
        string[] pair = namePair.split(':');
        if(pair.size() == 2){
          string labelName = getValueFromLabel(pair[1].trim());
          if(string.isNotBlank(labelName)){
             if(milestonepage){
                if(!(pair[0].trim().toLowerCase()).ContainsIgnoreCase('Milestonetype')){
                    fieldNameMapO.put('case.'+pair[0].trim().toLowerCase(),labelName);
                }else{
                    fieldNameMapO.put(pair[0].trim().toLowerCase(),labelName);
                }
             }else{
                fieldNameMapO.put(pair[0].trim().toLowerCase(),labelName);
             }
          }
        }
      }
    }

    return fieldNameMapO;
  }

    @testvisible    private void addAdditionalInfo (){
        Map<string, Map<string,string>> fetchFormSchema ;
        set<string> objectsUsed = new set<string>();
        blockNames = new List<string>();
        string objectPre = 'xxx|';
        
        for(Result res:resultList ){
            objectsUsed.add(res.objectName);
        }
        //fetchFormSchema = ESC_ObjectSchemaHelper.getInfoField(objectsUsed);

        Map<string, Map<string,string>> relationNames = ESC_ObjectSchemaHelper.getObjectNamesUsed(objectsUsed);
       // system.debug('relationNames: ' + JSON.serialize(relationNames));
        objectsUsed = new set<string>();
        for(Result res:resultList ){
            Map<string , string> fieldNameMapO = getOverRiddenNames(res.overRideNames);
            Map<string,string> objectsUsedMap = relationNames.get(res.objectName);


            blockNames.add(res.blockName);
            for(string name: res.apiNames){
                string obj= res.objectName;
                string finalObject = obj;
                string fieldName = name;
                string labelName ='';

                try{
                    if (fieldNameMapO.containsKey(fieldName.toLowerCase())){
                        labelName = fieldNameMapO.get(fieldName.toLowerCase());
                        
                    }
                    else if(fieldName.contains('.') ){

                        string[] splitter= name.split('\\.');
                        //  system.debug('started with object'+obj);
                        obj = splitter[0];
                        //system.debug('intermediate with object'+obj);
                        fieldName = splitter[1];

                        //system.debug('intermediate2 with object'+obj);
                        if(obj.equalsignorecase('case_collaborations__r')){
                            labelName='mmm|esc_case_collaborator__c';
                        }
                        else if(obj.equalsignorecase('casemilestones')){
                            labelName='mmm|casemilestone';
                        }
                        else if(obj.containsignorecase('casemilestones.milestonetype')){
                            labelName='milestonetype';
                        }
                        else if((obj.indexOf('__r') != -1)){
                            obj = obj.replace('__r', '__c');
                            finalObject = objectsUsedMap.get(obj);
                            //  system.debug('final object for --r'+obj);
                            labelName = objectPre + finalObject;
                            
                        }
                        else if((obj.indexOf('__') == -1 && objectsUsedMap.containsKey(obj))){
                            finalObject = objectsUsedMap.get(obj);
                            //labelName = ((fetchFormSchema.get(obj)).get(fieldName)).split(':')[1];
                              labelName = objectPre + finalObject;
                            //system.debug('final object for normal'+obj);
                        }

                    }  
                    else{
                       // labelName = ((fetchFormSchema.get(obj)).get(fieldName)).split(':')[1]; 
                          labelName = objectPre + obj;
                    }
                   



                }
                catch(exception e){
                    system.debug('error handling '+fieldName+' inside obj: '+obj +objectsUsedMap.containsKey(obj));
                }
               // system.debug('finalobject: '+finalobject);
                labelName = fieldName.endsWithIgnoreCase('ID') ? labelName.replace(' ID','') :labelName;

                //system.debug('unable to find in '+obj+ ' for:'+fieldName);

                //system.debug('final labelName'+labelName);

                res.apiNamesMap.put(name.toLowerCase(),labelName);
                objectsUsed.add(finalobject);
                //  res.visibilityList.put(name.toLowerCase(),true);


            }
        }

    /**if(!milestonepage){
        //populateVisibility(objectsUsed , relationNames);
    }**/
    }
 /*
private void populateVisibility(set<string> objectsUsed ,Map<string, Map<string,string>> relationNames){
      SET<sTRING> allobjectsUsed = new set<string>(objectsUsed);
     
     for(string key1 : relationNames.keyset()){
         Map<string,string> tempMap = relationNames.get(key1);
         for(string key2 : tempMap.keyset()){
             allobjectsUsed.add(tempMap.get(key2));
         }
     }
 Map<string, Map<string,Boolean>> objectVisibilityMap= getInfoFieldVisibility(allobjectsUsed);
    //system.debug('populateVisibility'+JSON.serialize(objectVisibilityMap));
    //system.debug('relationNames'+JSON.serialize(relationNames));
    for(Result res:resultList ){

      Map<string,string> objectsUsedMap = relationNames.get(res.objectName);
      blockNames.add(res.blockName);
      for(string name: res.apiNames){
        string obj= res.objectName;
        string fieldName = name;
        Boolean isVisible = false;
          Map <String, Schema.SObjectField> fieldMapMain;  
        Schema.SObjectField sfieldMain;                  
        schema.describefieldresult dfieldMain ; 

        try{

          if(fieldName.contains('.') ){

            string[] splitter= name.split('\\.');
            //system.debug('started with object'+obj);
            obj = splitter[0];
            //system.debug('intermediate with object'+obj);
            fieldName = splitter[1];

            //system.debug('intermediate2 with object'+obj);
            if((obj.indexOf('__r') != -1)){
              obj = obj.replace('__r', '__c');
              obj = objectsUsedMap.get(obj);

            }
            else if((obj.indexOf('__') == -1 && objectsUsedMap.containsKey(obj))){
              obj = objectsUsedMap.get(obj);


            }
          } 
          
          isVisible = (objectVisibilityMap.get(obj.toLowerCase()).containsKey(fieldName.toLowerCase()))?(objectVisibilityMap.get(obj.toLowerCase())).get(fieldName.toLowerCase()) : true;

        if(objectVisibilityMap.get(obj.toLowerCase()).containsKey(fieldName.toLowerCase())){
          isVisible = true;
        }
        else{
          try{
            fieldMapMain = schemaMap.get(obj).getDescribe().fields.getMap();
            sfieldMain = fieldMapMain.get(fieldName.toLowerCase());
            dfieldMain = sfieldMain.getDescribe();
            if( !dfieldMain.isPermissionable() || dfieldMain.getType() == Schema.DisplayType.reference || string.isNotBlank(dfieldMain.getCompoundFieldName())) {
              isVisible = true;
              //system.debug(name.toLowerCase() + ' name || visibilityTrue: '+isVisible);
            }

            else{
              //system.debug('dfieldMain-->'+dfieldMain);
              isVisible = false;
              //system.debug(name.toLowerCase() + ' name || visibility: '+isVisible);
            }

          }
          catch(exception ex){
            //system.debug(obj+' || exception for-->'+fieldName +'_______'+res.blockName);
          }
        }
      
        res.visibilityList.put(name.toLowerCase(),isVisible);
        }
        catch(exception e){
          //system.debug('error handling '+fieldName+' inside obj: '+obj +objectsUsedMap.containsKey(obj));
        }
      // res.visibilityList.put(name.toLowerCase(),true);
      }
    }

  }
  */
  public string getBlockTruncateColumns (){
    //getInitializedStatus();
  system.debug('getBlockTruncateColumns started'+resultList);
    tr = new List<TruncateInfo>();
    for(integer i=0; i< resultList.size(); i++){
      List<Integer> applicableColumns = new List<integer>();
      //system.debug('resultList[i].nonTruncateColumns' +resultList[i].nonTruncateColumns);
      //system.debug('resultList[i].truncateColumnsSize' +resultList[i].truncateColumnsSize);
      TruncateInfo trObj = new TruncateInfo();
      for(integer j=0; j< resultList[i].nonTruncateColumns.size();j++){

        trObj.columnsConfig.put(resultList[i].nonTruncateColumns[j],resultList[i].truncateColumnsSize[j]);

      }
      tr.add(trObj);

    }
 system.debug('getBlockTruncateColumns ended');

    return JSON.serialize(tr);
  }

  public List<string> getAllPushTopicNames(){
    List<string> pushTopicNames = new List<string>();
    try{
      ESC_PushTopicNotifications__c eptn = ESC_PushTopicNotifications__c.getInstance();
      for(string pushTopicName : eptn.PushTopicName__c.split(',')){
        pushTopicNames.add('/topic/'+pushTopicName.trim());

      }
    }
    catch(exception ex){
        system.debug('Exception' + ex);
    }
    /**for(Result res:resultList){
        if(string.isNotBlank(res.pushTopicName)){
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, '/topic/'+res.pushTopicName));
            //pushTopicNames.add('/topic/'+res.pushTopicName);
        }
    }**/
    return pushTopicNames;
  }
  public string getpushTopicSet(){
    set<string> pushTopicNames = new set<string>(getAllPushTopicNames());

    return JSON.serialize(pushTopicNames);
  }
/**public ESC_CaseHomePageController(ESC_CaseHomePageShowMoreController smc){
    localName = smc.localName;
    noBandShow = true;
    String currentPage = String.valueOf(ApexPages.currentPage());
     pageName  = currentPage.substringBetween('/apex/', '?');
     overRiddenQuery = ApexPages.currentPage().getParameters().get('query');
      resultList = new List<Result>();
     milestonepage = false;
    //getInitializedStatus(pageName);
     list<QueryBuilder> queryList = new list<QueryBuilder> ();
    string  currentUserProfile  = getProfileNameOfLoggedInUser();
    string query = 'SELECT name,ESC_ShowAccept__c,ESC_OWidths__c,ESC_DefOrder__c,ESC_AssignedTo__c,ESC_DefaultSortCol__c,ESC_FilterCriteria__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,ESC_ReturnedColumns__c,ESC_IsFirstHidden__c ,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+'and name =\''+localName+'\'  and ESC_isInActive__c = false order by ESC_Sequence__c nulls last limit 1';
        // //system.debug('query'+query);
        //string query = 'SELECT name,ESC_AssignedTo__c,ESC_FilterCriteria__c,ESC_ObjectType__c,ESC_OverrideLabelsForfields__c,ESC_CustomLabel__c,ESC_Limit__c,ESC_PgntnEnabled__c,name,ESC_ReturnedColumns__c,ESC_Sequence__c,ESC_pushTopicName__c,ESC_NoTruncation__c FROM ESC_HomePageQuery__c where ESC_Profiles__c like '+currentUserProfile+' order by ESC_Sequence__c nulls last limit '+limitval;
        for(ESC_HomePageQuery__c block: Database.query(query)){
         
          QueryBuilder qbd= new QueryBuilder(block,pageName);
          queryList.add(qbd);
        }
         for(QueryBuilder qbd: queryList ){

      Result res= new Result(qbd);
      resultList.add(res);


    }
}**/

  public ESC_CaseHomePageController(){
 //
      
        isInitialized = false;
        milestonepage=false;
        //logic to get the date format for show more functionality
        List<String> dateFormats = getFormats().split(',');
        system.debug('Dateformats' + dateFormatMap);
        localeValue = getLocale();
        for(String localName : dateFormatMap.keySet()){
        System.debug('checklocale:-->'+localeValue.startsWith(localName));
            if(string.isNotBlank(localname) && localeValue.startsWith(localName)){
                currentDateFormat = dateFormatMap.get(localName);
                break;
            }
            
        }
        System.debug('currentDateFormat-->'+currentDateFormat);
        if(string.isBlank(currentDateFormat)){
            currentDateFormat = Label.DefaultDateFormat;
        }
        System.debug('currentDateFormat-->'+currentDateFormat);    
        
        
          
    string noBand = ApexPages.currentPage().getParameters().get('noBand');
    localName = ApexPages.currentPage().getParameters().get('lName');
    if(ApexPages.currentPage().getParameters().get('profile') != null){
    overRiddenProfileId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('profile').escapeHtml4());
    }
     //pageName = ApexPages.currentPage().getUrl().substringBetween('/apex/', '?');
     String currentPage = String.valueOf(ApexPages.currentPage());
     pageName  = currentPage.substringBetween('/apex/', '?');
     system.debug('$$$ pageName: '+pageName );
     noBandShow = string.isBlank(noBand) || !noBand.equalsIgnoreCase('true') ? null: true;
     IF(noBandShow == null){
     initializeReports();
     }
    //Main method responsible for querying the homepagequery object records and fetch applciable queries to execute in later phases
       
        try{  
     if(pageName == Label.ESC_CurrentPageName || pageName == 'ESC_MissedMilestoneConsolePage'){
        milestonepage=true;
        mac = ESC_MilestoneAlertConfigSetting__c.getValues('1');
         //style = setcolour(totSize);
     }
    style=mac!=null?mac.X1stLevelColor__c:'';
    
    }
 catch(exception e){
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, e.getMessage()));
    }
   getInitializedStatus(pageName);
    
  }
  public static Component.Apex.OutputPanel initializeReports(){
    myPanel = new Component.Apex.OutputPanel();
    Boolean status = false;
    lstdbs =new List<Dashboard>();
    try{

      ESC_HomePageReports__c hpr;
      if(string.isBlank(overRiddenProfileId)){
        hpr = ESC_HomePageReports__c.getInstance();
      }else {
        hpr = ESC_HomePageReports__c.getInstance(overRiddenProfileId);
      }
      if(hpr.ESC_Dashboard_Id__c!=null && hpr.ESC_Dashboard_Id__c!=''){
        List<Id> dashboardIds = hpr.ESC_Dashboard_Id__c.split(',');
        if(dashboardIds!=null && dashboardIds.size()>0){
            if(Schema.sObjectType.dashboard.isAccessible() || Schema.sObjectType.dashboard.isQueryable()){
                lstdbs = [select id,DeveloperName, Title, Description from dashboard where id=:dashboardIds];
            }
          
        }
      }
       if(hpr.ESC_ReportIDS__c != null){
      string[] reportIDS = hpr.ESC_ReportIDS__c.split(',');
      for(string reportObj : reportIDS ){

        integer cacheAge = Integer.valueOf(hpr.ESC_CacheAge__c == null ? 400000 : hpr.ESC_CacheAge__c);
        string reportcID = reportObj.trim();
        status = true;
        Component.Apex.OutputPanel internalPanel  = new Component.Apex.OutputPanel();
        internalPanel.styleclass ='blockOP';

        noBandShow = noBandShow == null? false: noBandShow;
        internalPanel.childComponents.add(new Component.analytics.reportChart(reportid = reportcID,size = 'small',showrefreshbutton = true,cacheAge =  cacheAge));
        myPanel.childComponents.add(internalPanel);

      }
}

    }
    catch (exception ex){
      myPanel.childComponents.add(new Component.Apex.outputText(value = ex.getMessage()));
    }
    finally{
      if(!status){
        myPanel.childComponents.add(new Component.Apex.outputText(value = Label.ESC_ZeroReportsMSG));
        noBandShow = noBandShow == null? true:noBandShow;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_ZeroReportsMSG));
      }
      else{
        noBandShow = noBandShow == null? false:noBandShow;
      }
    }

    return myPanel;
  }
  public static Component.Apex.OutputPanel getComp(){
    Component.Apex.OutputPanel op = new Component.Apex.OutputPanel();

    for(Result result: resultList){
      Component.Apex.pageBlock pb= new Component.Apex.pageBlock();
      pb.expressions.title = '{!result.blockName}';
      pb.id = 'MyBlock';

      Component.Apex.pageBlockButtons pbBtn= new Component.Apex.pageBlockButtons();

    }
    return op;

  }
  @RemoteAction
  global static String updateOwner(Id selectedIDForOwnerUpdate){

    if(selectedIDForOwnerUpdate == null){
      return null;
    }
    String idToOpen = selectedIDForOwnerUpdate;
    String objectName = selectedIDForOwnerUpdate.getSObjectType().getDescribe().getName();
    try{
      string query = 'select OwnerId from ' +String.escapeSingleQuotes(objectName) +' where id=\''+String.escapeSingleQuotes(selectedIDForOwnerUpdate)+'\'';
        system.debug('query123--->'+query);
      if(objectName.equalsIgnoreCase('ESC_Case_Collaborator__c')){
        query = 'select OwnerId,ESC_Referral_Status__c,ESC_Case__c,name from ' + String.escapeSingleQuotes(objectName) +' where id=\''+String.escapeSingleQuotes(selectedIDForOwnerUpdate)+'\''; 
      }
      if(objectName.equalsIgnoreCase('Case')){
        query = 'select OwnerId,CaseNumber from ' + String.escapeSingleQuotes(objectName) +' where id=\''+String.escapeSingleQuotes(selectedIDForOwnerUpdate)+'\''; 
        system.debug('query1234--->'+query);
      }
      SObject referencedObj = Database.query(query);

      referencedObj.put('OwnerId' , UserInfo.getUserId());

      if(objectName.equalsIgnoreCase('ESC_Case_Collaborator__c')){
        referencedObj.put('ESC_Referral_Status__c' , 'Accepted');
        idToOpen =(String) referencedObj.get('ESC_Case__c') ;
      }
        if(Schema.sObjectType.Case.fields.OwnerId.isUpdateable() || Schema.sObjectType.ESC_Case_Collaborator__c.Fields.ESC_Referral_Status__c.isUpdateable()){
            update referencedObj;
            
        }
        

      return idToOpen;
    }
    catch (exception ex){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getmessage()));
      return '**'+ ex.getmessage();
    }
  }

  public static String getFormats(){
    List<String> formatsAvail = new List<string>();
    // //system.debug('getFormats called');
    dateFormatMap = new Map<string,string>();
    for(ESC_DateFormats__mdt edf:[select Locale__c,ESC_Format__c from ESC_DateFormats__mdt]){
      dateFormatMap.put(edf.Locale__c,edf.ESC_Format__c);
      formatsAvail.add(edf.ESC_Format__c);
    }
    return Json.serialize(formatsAvail);
  }

  public static String  getObjectPrefixID(String objName){
      if(objecctPreZMap.containsKey(objName) ){
       return objecctPreZMap.get(objName);
      }else{
        
        //system.debug('==>m is==>'+m);
        Schema.SObjectType s = m.get(objName) ;
        //system.debug('==>Sobject Type is ==>'+s);
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        objecctPreZMap.put(objName , keyPrefix);
         return keyPrefix;
       }
       
    }
    
    public static String gettargetobjectlst( String objType){
        List<ProcessInstance> lstpinst = new List<ProcessInstance>();
        List<ProcessInstanceWorkitem> lstpwitem = new List<ProcessInstanceWorkitem>();
        Set<String> setpInstance = new Set<String>();
        Set<String> setacct = new Set<String>();
        Map<Id,List<Id>> mapRecs = new Map<Id,List<Id>>();
        jsonMapRec = '';
        List<string> setOfOwners = new List<string>();
        for( GroupMember gm:[Select Group.ID from GroupMember where UserOrGroupId = :UserInfo.getUserId() and Group.Type = 'Queue']){
            setOfOwners.add(gm.Group.ID);
        }
        setOfOwners.add(userinfo.getUserId());
        //string queryP = 'SELECT Id,ActorId,OriginalActorId,CreatedDate,ProcessInstanceId,CreatedById FROM ProcessInstanceWorkitem where (ActorId in '+setOfOwners+ ' or OriginalActorId in '+setOfOwners+ ')';
        //lstpwitem = Database.query(queryP);
       if(Schema.sObjectType.ProcessInstanceWorkitem.Fields.ActorId.isAccessible()){
            lstpwitem =[SELECT Id,ActorId,OriginalActorId,CreatedDate,ProcessInstanceId,CreatedById FROM ProcessInstanceWorkitem 
                        where ActorId in :setOfOwners];
        }
       if(lstpwitem.size()>0){
            for(ProcessInstanceWorkitem item:lstpwitem){
                setpInstance.add(item.ProcessInstanceId);
            }
           
            if(setpInstance.size()>0){
                   if(Schema.sObjectType.ProcessInstance.isAccessible() || Schema.sObjectType.ProcessInstance.isQueryable()){ 
                   // || Schema.sObjectType.ProcessInstanceWorkitem.isAccessible()  || Schema.sObjectType.ProcessInstanceWorkitem.isQueryable())
                         lstpinst= [select id,targetobjectid,status,(SELECT Id FROM workitems) from ProcessInstance where id IN :setpInstance];                    
                   }
               
                
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
        //Map<Id,List<Id>> jsonMapRec = (Map<Id,List<Id>>)JSON.deserialize(jsonMapRec, Map<Id,List<Id>>.class);
        
    }
    
    @RemoteAction
    global static String getApprovalRecord(Id selectedIDForApproval){
    //system.debug('$$$1'+selectedIDForApproval);
    if(selectedIDForApproval == null){
      return null;
    }
     List<ProcessInstance> pinst = new List<ProcessInstance>();
     if(Schema.sObjectType.ProcessInstance.isAccessible() || Schema.sObjectType.ProcessInstance.isQueryable()){
     pinst = [select id,targetobjectid,status,(SELECT Id FROM workitems) from ProcessInstance where targetobjectid = :selectedIDForApproval];
     }
     //system.debug('$$$1'+pinst);
     if(pinst.size()>0){
     for(ProcessInstance pi:pinst){
        for(ProcessInstanceWorkitem witem:pi.workitems){
            return (String) witem.id;
        }
      }
     }
     return null;
    }

    
    Public void refreshCaseListJS(){
        try{
      //system.debug('$$$ Inside RefreshCaseListJS Method');
      getInitializedStatus(Label.ESC_CurrentPageName);
     //style = setcolour(totSize);
        }
        catch(exception e){
            //system.debug(e.getMessage());
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage())); 
        }

    }
    
    public string setcolour(integer i){
    string color;
    if(i == mac.X1stLevelThreshold__c){color = mac.X1stLevelColor__c;}
    else if (i== mac.X2ndLevelThreshold__c){color = mac.X2ndLevelColor__c ;}
    else {color = mac.X3rdLayerColor__c;}
    system.debug(i+' '+color);
    return color;
  }
  
  
  //Internal classes used 
    public class TruncateInfo{
    public Map<Integer ,string> columnsConfig {get; set;}
    public TruncateInfo(){
      this.columnsConfig = new Map<Integer ,string>();
    }
  }
    public abstract class baseClass{
        public   List<string> apiNames {get; set;}
        public Boolean hasToShowAccept {get; set;}
        public Boolean isOfMissedMilstoneType {get; set;}
        public transient Boolean isASC{get; set;}
        public  string objectName ;
        public  string blockName {get; set;}
         public  string blockLocalName {get; set;}
        public  Boolean showAccept {get; set;}
        public  string pushTopicName {get; set;}
        public  string ownerInfo ;
        public  List<string> ownerIdentifiers {get; set;}
        public  Boolean isUserBlock ;
        public  Boolean isFirstHidden ;
        public integer columnToHide;
        public  Boolean isQueueBlock ;
        public  Boolean isApprovalProcess ;
        public  Boolean isPaginationEnabled ;
        public  string overRideNames ;
        public  List<string> apiNoTruncate ;
        public  string fullQuery ;
        public  List<SObject> resultObj{get;set;}
        public  List<SObject> secondaryResultObj{get;set;}
        public  Map<string, string> apiNamesMap {get; set;}
        public  string objectPrefix {get; set;}
        public  List<Integer> nonTruncateColumns;
        public  List<string> truncateColumnsSize {get; set;}
        public Map<string, string> columnDimensions {get; set;}
        public string styleclass{get; set;}
        public Map<string,Boolean> visibilityList{get; set;}
        public  Boolean showApproval {get; set;}
        public Integer sortDefCol {get; set;}
        public  string msname;
        
    }

    public class Result extends baseClass implements ESC_VFComponentAttributable  {
        List<String> calculatedFields;
        Map<string,Object> calculatedFieldsMap;
         public List<string> getIapiNamesMissedMileStoneCalculatedFields(){return calculatedFields;}    
         public Map<string, object> getICalculateFieldsMap(){return calculatedFieldsMap;}
        public List<string>  getIapiNames() { if(!apiNames.isEmpty()){ return apiNames; }
        else {return new List<String>();}
        }
        public Boolean getISortASC(){return isASC;}
        public string getIobjectName(){return objectName;}
        public string getIblockName(){ return blockName;}
         public string getIblockLocalName(){ return blockLocalName;}
        public integer getIsortDefCol(){return sortDefCol; }
        public Boolean  getIshowAccept(){ return showAccept;}
        public Boolean  getIshowApproval(){ return showApproval;}
        public Boolean  getIisFirstHidden(){ return isFirstHidden;}
        public string getIpushTopicName(){ return pushTopicName;}
        public string getIOwnerInfo(){ return ownerInfo;}
        public  List<string> getIownerIdentifiers(){ return ownerIdentifiers;}
        public Boolean getIisUserBlock(){ return isUserBlock;}
        public Boolean getIisQueueBlock(){ return isQueueBlock;}
        public Boolean getIisPaginationEnabled(){ return isPaginationEnabled;}
        public string getIoverRideNames(){ return overRideNames;}
        public List<string> getIapiNoTruncate(){ return apiNoTruncate;}
        public string getIfullQuery(){ return fullQuery;}
        public  List<SObject> getIresultObj(){ return resultObj;}
        public Map<string, string> getIapiNamesMap(){ return apiNamesMap;}
        public string getIobjectPrefix(){ return objectPrefix;}
        public List<Integer> getInonTruncateColumns(){ return nonTruncateColumns;}
        public  List<string> getItruncateColumnsSize(){ return truncateColumnsSize;}
         public Map<string,string> getIColumnsDimensions(){ return columnDimensions;}
        public string getIstyleclass(){ return styleclass;}
        public Map<string,Boolean> getIvisibilityList(){ return visibilityList;}
        public  List<SObject> getIsecondaryResultObj() {return secondaryResultObj ;}
        public Boolean getIHasToShowAccept() {return hasToShowAccept;}
        public integer getIHideColumn () {return columnToHide;}
        public Result( QueryBuilder qbd ){
            this.truncateColumnsSize = new List<string>();
            this.hasToShowAccept = qbd.hasToShowAccept;
            this.fullQuery = qbd.fullQuery;
            this.blockLocalName = qbd.blockLocalName;
            this.isApprovalProcess = qbd.isApprovalProcess;
            this.resultObj = getResults(this.fullQuery);
            this.blockName = qbd.blockName;
            this.apiNames =  qbd.apiNames;
            this.objectName= qbd.objectName.toLowerCase();
            this.overRideNames = qbd.overRideNames;
            this.apiNamesMap = new Map<string, string>();
            this.showAccept = qbd.showAccept;
            this.isUserBlock = qbd.isUserBlock;
            this.isQueueBlock = qbd.isQueueBlock;
            this.isFirstHidden = qbd.isFirstHidden;
            this.isASC = qbd.isASC == null ? true : qbd.isASC;
            this.pushTopicName = string.isNotBlank(qbd.pushTopicName) ? qbd.pushTopicName :'';
            this.ownerInfo =qbd.ownerInfo;
            this.showApproval = qbd.showApproval;
            this.ownerIdentifiers =  qbd.ownerIdentifiers;
            this.isPaginationEnabled =qbd.isPaginationEnabled;
            this.objectPrefix = Schema.getGlobalDescribe().get(this.objectName).getDescribe().getkeyprefix();
            this.nonTruncateColumns = getIndexOfTruncateCoulumns(qbd.apiNoTruncate);
            system.debug( 'this.nonTruncateColumns '+JSON.serialize( this.nonTruncateColumns));
            this.columnDimensions = getColumnDimensions(qbd.columnDimList);
            this.styleclass = getStyleClassfunc();
            this.visibilityList = new Map<string,Boolean>();
            this.sortDefCol =  qbd.sortDefCol;
            this.columnToHide = fetchColumnToHide();
        }
        
        public integer fetchColumnToHide(){
           system.debug('this.showAccept'+this.showAccept);
           system.debug( 'this.isQueueBlock'+this.isQueueBlock );
           system.debug( 'this.showApproval'+this.showApproval);
             system.debug(this.isFirstHidden);
            if(this.isFirstHidden){
                if( this.showAccept || this.isQueueBlock || this.showApproval || this.hasToShowAccept  ) {
                 return 1;
                } else {
                 return 0;
                }
            }
            else {
                return -1;
            }
        }

        public string getStyleClassfunc(){
            string nameCls = '';
            if(this.isPaginationEnabled){
                nameCls = 'myClassPagination';
            }
            else{
                nameCls = 'myClassNoPagination';
            }
            nameCls += ' myTablecls';
            return nameCls;
        }

        private List<sobject> getResults(string query){
            system.debug('query+getResults'+query);
            totsize=100;
            try{
                List<sobject> qResult = Database.query(query);
                system.debug('$$$ Data Result:'+JSON.serialize(qResult));
              //totSize = totSize + qResult.size();    
                  if(milestonepage && qResult.size()>0 ){
                    Id sampleId = (Id)(qResult[0].get('id'));
                    String objectType=sampleId.getSObjectType().getDescribe().getName();
                    List<sobject> removableList = new List<sobject>();
                    List<sobject> finalList = new List<sobject>();
                     for(Sobject s:qResult){
                        if(objectType.equalsIgnoreCase('Casemilestone')){
                            Integer tr= Integer.valueof(((String)s.get('timeremaininginmins')).split(':')[0]);
                            if(tr>mac.X1stLevelThreshold__c){
                                if(style!=mac.X3rdLayerColor__c && style!=mac.X2ndLevelColor__c){
                                style=mac.X1stLevelColor__c; // No milestones are breached(GREEN)
                                }
                                removableList.add(s);
                            }
                            else if(tr<=mac.X1stLevelThreshold__c && tr>0){
                                if(style!=mac.X3rdLayerColor__c){
                                style=mac.X2ndLevelColor__c;  // Milestones about to breach(AMBER)
                                }
                                missedCount++;
                            }
                            else{
                                style=mac.X3rdLayerColor__c; // breached (RED)
                                missedCount++;
                            }
                        }
                        else{
                            Case cm= (Case)s;
                            List<Casemilestone> milestonelist= new List<CaseMilestone>();
                            milestonelist= cm.casemilestones;
                                if(milestonelist.size()>0){
                                    for(CaseMilestone m:milestonelist){
                                        Integer tr= Integer.valueof(((String)m.timeremaininginmins).split(':')[0]);
                                        if(tr>15){
                                            totSize=(Integer)mac.X1stLevelThreshold__c; // No milestones are breached(GREEN)
                                            removableList.add(s);
                                        }
                                        else if(tr<=15 && tr>0){
                                            totSize=(Integer)mac.X2ndLevelThreshold__c;  // Milestones about to breach(AMBER)
                                            missedCount++;
                                        }
                                        else{
                                            totSize=(Integer)mac.X3rdLevelThreshold__c; // breached (RED)
                                            missedCount++;
                                        }
                                    }
                                    
                                }else{
                                    removableList.add(s);
                                }
                        }
                      }     
                      for(Sobject i:qResult){   
                        if(! removableList.contains(i)){
                            finalList.add(i); 
                        }
                      }
                      if(finalList.size()>0){    
                        return finalList; 
                      }
                  }
                // return Database.query(query);
    
                return qResult;
            }catch( exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, this.blockName+'@ Query: '+query+' Error:'+e.getMessage()));
                return new List<sobject>();
            }

        }
        
        private Map<string,string> getColumnDimensions(List<string> columNamesList){
            Map<string,string> preMap = new Map<string, string>();
           for(string val :columNamesList){
               preMap.put(val.split(':')[0],val.split(':')[1]);
           }
           
            Map<string,string> returnedMap = new  Map<string,string>();
            
            string defaultD = 'xxx';
            for (string name: this.apiNames){
                string dimes = '';
                 if(preMap.containsKey(name)){
                    //system.debug(name.split(':'));
                    try{
                        //system.debug('1-->'+columNames.split(name+':')[1]);
                        
                        dimes =preMap.get(name);

                    }
                    catch(exception e){
                        //system.debug('2-->');
                      dimes =defaultD;
                    }
                 }
                else{
                     dimes =defaultD;
                }
                returnedMap.put(name,dimes);
                 }
               
                return returnedMap;
             
        }

        private List<integer> getIndexOfTruncateCoulumns(List<string> columNamesList){
            string columNames = string.join(columNamesList,',').toLowerCase();
            List<integer> lst = new List<integer> ();
            Integer index = 0;
            //system.debug('this.apiNames size : '+ this.apiNames.size());
           // system.debug('this.truncateColumnsSize size : '+ this.truncateColumnsSize);
            for (string name: this.apiNames){
               
               // system.debug('for  field name: '+ name);
                string size = '10';
                if(columNames.indexOf(name+':') !=-1){
                    //system.debug(name.split(':'));
                    try{
                      // system.debug('1-->'+columNames.split(name+':')[1]);
                        //size = (columNames.split(name+':')[1]).substringbefore();
                        size = (columNames.split(name+':')[1]).substringbefore(',');

                    }
                    catch(exception e){
                        //system.debug('2-->');
                        size = '0';
                    }
                }
                else if(columNames.contains(name) ){
                    //system.debug('3-->');
                    size = '0';

                }
                //system.debug('size at index '+ index + ' limit: ' +size);
                this.truncateColumnsSize.add(size);
               lst.add(index++);
                
            }
            system.debug('this.truncateColumnsSize size : '+ this.truncateColumnsSize.size());
            //system.debug('5-->'+lst);
            return lst;
        }

    }
    
    
        
           
            
    public class QueryBuilder extends baseClass implements comparable{
        public string profileI {get; set;}
        public string defaultSortColumn {get;set;}
        public List<string> columnDimList {get;set;}
        public integer sequence {get; set;}
        public String msname{get;set;}
        public Integer compareTo(Object compareTo) {
            //typecaseting of objecttype to QueryBuilder type
         QueryBuilder compareRecord = (QueryBuilder)compareTo;
         
          if (this.Sequence == compareRecord.Sequence) { return 0 ;}
            if (Sequence > compareRecord.Sequence) { return 1 ;}
            return -1;  
            
            
        }
        
            public QueryBuilder(){
                system.debug('');
            }
            
            

        public QueryBuilder(ESC_HomePageQuery__c esc, String pageName){
            //system.debug('$$$ Page:'+pageName);
            this.defaultSortColumn = esc.ESC_DefaultSortCol__c;
            this.isQueueBlock = esc.ESC_AssignedTo__c.equalsIgnoreCase('Current User\'s Queue') ? true:false;
            this.isApprovalProcess =string.isNotBlank(esc.ESC_AssignedTo__c) && esc.ESC_AssignedTo__c.equalsIgnoreCase('Approval Process') ? true:false;
            
            if(milestonepage){
              
                  if(esc.ESC_ObjectType__c.equalsIgnoreCase('case')){
                         this.objectName = 'casemilestone';
                           this.apiNames= getFieldAPINames(esc.ESC_ReturnedSecondaryColumns__c, this.objectName);
                     }
                     else if(esc.ESC_ObjectType__c.equalsIgnoreCase('ESC_Case_Collaborator__c')){
                            this.objectName = 'case';
                            this.msname= esc.ESC_Milestone_Name__c;
                           this.apiNames= getFieldAPINames(esc.ESC_ReturnedSecondaryColumns__c, this.objectName);
                     }
            }else{
                this.apiNames= getFieldAPINames(esc.ESC_ReturnedColumns__c);
                 this.objectName = esc.ESC_ObjectType__c;
            }
             this.isASC = esc.ESC_DefOrder__c;
            this.fullQuery = formQuery(esc, pageName);
            this.blockName = getBlockName(esc);
           this.blockLocalName = esc.name;
            this.hasToShowAccept = esc.ESC_ShowAccept__c == null? false: esc.ESC_ShowAccept__c;
            this.isFirstHidden = esc.ESC_IsFirstHidden__c == null?false :esc.ESC_IsFirstHidden__c;
            this.defaultSortColumn = esc.ESC_DefaultSortCol__c;
            this.sequence = getSequenceValue(esc.ESC_Sequence__c);
            this.isPaginationEnabled =esc.ESC_PgntnEnabled__c;
            this.pushTopicName = string.isNotBlank(esc.ESC_pushTopicName__c) ? esc.ESC_pushTopicName__c : '';
            if(milestonepage){
                this.overRideNames = esc.ESC_OverrideLabelsForfields__c;
                if(esc.ESC_ObjectType__c.equalsIgnoreCase('case')){
                    this.overRideNames += (string.isNotBlank(esc.ESC_OverrideLabelsForfields__c)? ',' : '') + 'MilestoneType.Name:ESC_Milestone_Type';
                }
                else{
                    this.overRideNames += (string.isNotBlank(esc.ESC_OverrideLabelsForfields__c)? ',' : '') + 'casemilestones.MilestoneType.Name:ESC_Milestone_Type';
                }
            }else{
            this.overRideNames = esc.ESC_OverrideLabelsForfields__c;
            }

            this.isUserBlock = esc.ESC_AssignedTo__c.equalsIgnoreCase('Current User Only') ? true:false;


            this.ownerInfo = UserInfo.getUserId();

            this.ownerIdentifiers =isQueueBlock? getownerIdentifiers(this.ownerInfo) : new list<string>{this.ownerInfo};
            this.apiNoTruncate = getFieldAPINames(esc.ESC_NoTruncation__c);
            this.columnDimList =  getFieldAPINames(esc.ESC_OWidths__c);
        }

        public integer getSequenceValue(string sq){
            integer value = Integer.valueOf(sq.substringbefore(':'));
            return value;
        }

        private string getBlockName(ESC_HomePageQuery__c esc){
            string customLabelName = esc.ESC_CustomLabel__c;
            
            if(string.isBlank(customLabelName)){
                return esc.name;
            }

            else{
                return String.valueOf(ESC_DataTableEntity.getLabelValue(customLabelName));
            }
        }
        private list<string> getownerIdentifiers(string ownerId){
            List<string> ownerIdentifiers = new list<string>();
            for(GroupMember queuIDs : [Select Group.ID from GroupMember where UserOrGroupId = :UserInfo.getUserId() and Group.Type = 'Queue']){
                ownerIdentifiers.add(queuIDs.GroupID);
            }
            return ownerIdentifiers;
        }
        
        private List<string> getFieldAPINames(string returnedColumns, String objName){
             List<string> tfieldNames = new list<string>();
            List<string> fieldNames = new List<string>();
            if(string.isNotBlank(returnedColumns)){
                returnedColumns = returnedColumns.toLowerCase();
                tfieldNames= returnedColumns.split(',');
                integer count = 0;
                for(string var:tfieldNames ){
                    if(!var.containsIgnoreCase('case.')){
                        if(var.equalsIgnoreCase('casenumber')){
                            fieldNames.add('caseid');
                        }
                        else if(objName.equalsIgnoreCase('Casemilestone')){
                        fieldNames.add('case.'+var.trim());
                        }
                        else if(objName.equalsIgnoreCase('case')){
                            if(var.containsIgnoreCase('ESC_Case__r.')){
                                string te=var.removeStartIgnoreCase('ESC_Case__r.');
                                    fieldNames.add(te);                             
                            }
                            else{
                                    fieldNames.add('case_collaborations__r.'+var.trim());
                            }
                        }
                    }
                    else{
                    fieldNames.add(var.trim());
                    }
                    count++;
                }
                
            }
            if(objName.equalsIgnoreCase('Casemilestone')){
                fieldNames.addAll(Label.ESC_MS_MilestoneFields.split(','));
            }
            else{
                for(String s:Label.ESC_MS_MilestoneFields.split(',')){
                    fieldNames.add('casemilestones.'+s);
                }
            }
        
            return fieldNames;
        }

        private List<string> getFieldAPINames(string returnedColumns){
            Boolean isAPIRun = false;

            if(this.apiNames == null || this.apiNames.size() == 0){
                isAPIRun = true;
                this.sortDefCol = 0;
                if(this.isApprovalProcess || this.isQueueBlock){
                
                   // if(this.isFirstHidden != null && !this.isFirstHidden)
                    this.sortDefCol = 1;
                    
                }
                
                 //   system.debug(   'this.sortDefCol'+  this.sortDefCol);   
            }
            //system.debug(isAPIRun ? 'ITSAPRun'+this.defaultSortColumn : 'itsNotAPIRun');

            List<string> tfieldNames = new list<string>();
            List<string> fieldNames = new List<string>();
            if(string.isNotBlank(returnedColumns)){
                returnedColumns = returnedColumns.toLowerCase();
                tfieldNames= returnedColumns.split(',');
                integer count = 0;
                for(string var:tfieldNames ){
                    if(isAPIRun && string.isNotBlank(this.defaultSortColumn ) && this.defaultSortColumn.equalsIgnoreCase(var)) { 
                        this.sortDefCol = this.sortDefCol+count;
                        //system.debug('sortDefCol '+sortDefCol);
                        //system.debug('field sort by '+var); 
                    }
                    fieldNames.add(var.trim());
                    count++;
                }
            }
        
            return fieldNames;
        } 

        private string formQuery(ESC_HomePageQuery__c esc , String pageName){
            this.showAccept =false;
            this.showApproval =false; 
            string filterCriteria= '';
            integer limitOfRecords = 200;
            integer offset = 0;
            string overriddenLimit = ApexPages.currentPage().getParameters().get('limit');
            
             string overriddenOffset = ApexPages.currentPage().getParameters().get('offset'); 
            if(string.isNotBlank(overriddenLimit)){
                limitOfRecords = Integer.valueOf(overriddenLimit.substringBefore('.'));
            }
            else if(esc.ESC_Limit__c !=null){
                limitOfRecords = Integer.valueOf(esc.ESC_Limit__c);
            }
             if(string.isNotBlank(overriddenOffset)){
                offset = Integer.valueOf(overriddenOffset.substringBefore('.'));
            }


            string query='';
            string addCriteria = '';


            if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Current User Only')){
                if(milestonepage){
                    if(esc.ESC_ObjectType__c.equalsIgnoreCase('case')){
                        filterCriteria = Label.ESC_MSMyCases;
                        addCriteria = '  Case.OwnerId = \''+getOwners(true)+'\''+' and iscompleted=false  order by timeremaininginmins desc';
                        addCriteria = string.isNotBlank(Label.ESC_MSMyCases)? (' and '+ addCriteria) : (addCriteria) ;
                    }
                    else if(esc.ESC_ObjectType__c.equalsIgnoreCase('esc_case_collaborator__c')){
                        filterCriteria= esc.ESC_FilterCriteria__c;
                        //filterCriteria = Label.ESC_MSMyReferrals;
                        addCriteria = 'OwnerId = \''+getOwners(true)+'\'';
                        addCriteria = string.isNotBlank(esc.ESC_FilterCriteria__c)? (' and '+ addCriteria) : (addCriteria) ;
                    }
                }else{
                    filterCriteria= esc.ESC_FilterCriteria__c;
                    addCriteria = 'OwnerId = \''+getOwners(true)+'\'';
                    addCriteria = string.isNotBlank(esc.ESC_FilterCriteria__c)? (' and '+ addCriteria) : (addCriteria) ;
                }

            }

            else if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Current User\'s Queue')){
                if(milestonepage){
                    if(esc.ESC_ObjectType__c.equalsIgnoreCase('case')){             
                        filterCriteria = Label.ESC_MSMyCases;
                        this.showAccept  = true;
                        string mergedIDs = getOwners(false);
                        if(string.isNotBlank(mergedIDs)){    
                            addCriteria = ' Case.OwnerId in ('+mergedIDs+')' +' and iscompleted=false  order by timeremaininginmins desc';
                            addCriteria = string.isNotBlank(Label.ESC_MSMyCases)? (' and '+ addCriteria) : (addCriteria) ;
                        } 
                    }                    
                    else if(esc.ESC_ObjectType__c.equalsIgnoreCase('esc_case_collaborator__c')){
                        filterCriteria= esc.ESC_FilterCriteria__c;
                        //filterCriteria = Label.ESC_MSMyReferrals;
                        addCriteria = 'OwnerId in ('+getOwners(false)+')';
                        addCriteria = string.isNotBlank(esc.ESC_FilterCriteria__c)? (' and '+ addCriteria) : (addCriteria) ;
                    }
                }else{
                    filterCriteria= esc.ESC_FilterCriteria__c;
                    this.showAccept  = true;
                    string mergedIDs = getOwners(false);
                    if(string.isNotBlank(mergedIDs)){

                        addCriteria = 'OwnerId in ('+mergedIDs+')';
                        addCriteria = string.isNotBlank(esc.ESC_FilterCriteria__c)? (' and '+ addCriteria) : (addCriteria) ;

                    }
                }

            }
            else if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Enhanced')){
                if(milestonepage){
                    addCriteria = esc.ESC_FilterCriteria__c;
                    addCriteria = addCriteria.replace('%user%', '\''+getOwners(true)+'\'').replace('%queue%', getOwners(false));
                    addCriteria = subQueryResults(addCriteria);
                }
                else{
                    addCriteria = esc.ESC_FilterCriteria__c;
                    addCriteria = addCriteria.replace('%user%', '\''+getOwners(true)+'\'').replace('%queue%', getOwners(false));
                     addCriteria = subQueryResults(addCriteria);
                }

            }
            else if(esc.ESC_AssignedTo__c.equalsIgnoreCase('Approval Process')){
                this.showApproval =true; 
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
                addCriteria = 'Id in ('+temp+')';

            }
            if(string.isNotBlank(addCriteria)){
                if(string.isBlank(filterCriteria)){
                    filterCriteria= addCriteria;
                } else {
                    filterCriteria+= ' '+ addCriteria;
                }
            }
            if((esc.ESC_ObjectType__c.equalsIgnoreCase('case') && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_UPD__c') != -1 ) )
            {
                   esc.ESC_ReturnedColumns__c +=',ESC_UPD_Action__c';
                
            }
            if(esc.ESC_ObjectType__c.equalsIgnoreCase('ESC_Case_Collaborator__c') && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Case__r.ESC_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Case__r.ESC_UPD__c') != -1){
                esc.ESC_ReturnedColumns__c +=',ESC_Case__r.ESC_UPD_Action__c';
            }
            if(esc.ESC_ObjectType__c.equalsIgnoreCase('case') && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Resolver_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_UPD_Resolver__c') != -1 )
            {
                esc.ESC_ReturnedColumns__c +=',ESC_Resolver_UPD_Action__c';
            }
            if(esc.ESC_ObjectType__c.equalsIgnoreCase('ESC_Case_Collaborator__c') && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Case__r.ESC_Resolver_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Case__r.ESC_UPD_Resolver__c') != -1){
                esc.ESC_ReturnedColumns__c +=',ESC_Case__r.ESC_Resolver_UPD_Action__c';
            }
            if(esc.ESC_ObjectType__c.equalsIgnoreCase('case') && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Customer_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_UPD_Customer__c') != -1 )
            {
                esc.ESC_ReturnedColumns__c +=',ESC_Customer_UPD_Action__c';
            }
            if(esc.ESC_ObjectType__c.equalsIgnoreCase('ESC_Case_Collaborator__c') && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Case__r.ESC_Customer_UPD_Action__c') == -1 && esc.ESC_ReturnedColumns__c.indexOfignorecase('ESC_Case__r.ESC_UPD_Customer__c') != -1 )
            {
                esc.ESC_ReturnedColumns__c +=',ESC_Case__r.ESC_Customer_UPD_Action__c';
            }
            if(milestonepage){
                if((esc.ESC_ObjectType__c).equalsIgnoreCase('Case')){
                    
                    query= 'select '+ string.join(this.apiNames ,',') + ' from CaseMilestone where '+ filterCriteria +' Limit ' + limitOfRecords;
                }
                else{   
                    String refIdList= '';
                    String caseIdList= '';
                    String refquery='select Id,ESC_Case__c from ESC_Case_Collaborator__c where '+ filterCriteria;
                    //system.debug(refquery);
                    List<ESC_Case_Collaborator__c> reflist= database.query(refquery);
                    for(ESC_Case_Collaborator__c r:reflist){
                        refIdList=string.isNotBlank(refIdList)? (refIdList+',\''+r.Id+'\'') : (refIdList+'\''+r.Id+'\'') ;
                        caseIdList=string.isNotBlank(caseIdList)? (caseIdList+',\''+r.ESC_Case__c+'\'') : (caseIdList+'\''+r.ESC_Case__c+'\'') ;
                    }
                    if(refIdList==''){
                        refIdList='\'xxxxxxxxxxxxxxx\'';
                    }
                    if(caseIdList==''){
                        caseIdList='\'xxxxxxxxxxxxxxx\'';
                    }
                    refIdList='('+refIdList+')';
                    caseIdList='('+caseIdList+')';
                    List<String> parentFnames = new List<String>();
                    Map<String,List<String>> childQueryMap = new Map<String,List<String>>();
                    for(String t:('case_collaborations__r,casemilestones').split(',')){
                        childQueryMap.put(t,new List<String>());
                    }
                    System.debug('this.apinames_'+this.apinames);
                    for(String fname: this.apinames){
                        if(!fname.contains('.')){
                            parentFnames.add(fname);
                        }
                        else{
                            List<String> tempList= fname.split('\\.');
                            if(childQueryMap.containsKey(tempList[0])){
                                if(tempList.size()==2){
                                    childQueryMap.get(tempList[0]).add(tempList[1]);
                                } else{
                                    String temp= tempList[0];
                                    templist.remove(0);
                                    childQueryMap.get(temp).add(String.join(tempList,'.'));
                                }
                            } 
                        }
                    }
                    System.debug('parentFnames1'+parentFnames);
                    String innerquery='';
                    if(childQueryMap.size()>0){
                        List<String> lstmstname =new List<String>();
                            List<Milestonetype> mslst;
                        if(msname!=null){
                            
                            lstmstname.addall(msname.split(','));
                            if(Schema.sObjectType.MilestoneType.isAccessible() || Schema.sObjectType.MilestoneType.isQueryable()){
                                mslst = [select id,name from MilestoneType where name = :lstmstname];
                            System.debug('msname****'+msname);
                            }
                            
                        }
                        for(String iq:childQueryMap.keyset()){
                            String iqcriteria='';
                            //String msid='\'5570v0000008OPG\'';
                            String msdlist='';
                            //System.debug('msname****'+msname);
                            //List<Milestonetype> mslst;
                            List<String> lstmsid =new List<String>();
                            //List<String> lstmstname =new List<String>();
                            if(msname!=null){
                            //lstmstname.addall(msname.split(','));
                            //mslst = [select id,name from MilestoneType where name = :lstmstname];
                            for(MilestoneType mst:mslst){
                            lstmsid.add(mst.id);
                            }
                            }
                            for(String str:lstmsid){
                            msdlist = string.isNotBlank(msdlist)? (msdlist+',\''+str+'\'') : (msdlist+'\''+str+'\'') ;
                            }
                            if(msdlist==''){
                                msdlist='\'xxxxxxxxxxxxxxx\'';
                            }
                            msdlist='('+msdlist+')';
                            if(iq=='casemilestones'){
                                if(msdlist!=null && msdlist!=''){
                                iqcriteria='where iscompleted=false and  caseid in '+caseIdList+' and milestonetypeid in  '+msdlist+' order by timeremaininginmins desc';
                                }
                            }else{
                                iqcriteria='where id in '+refIdList;
                            }
                            if(innerquery==''){
                                innerquery='(select id,'+ String.join(childQueryMap.get(iq) ,',')+' from '+iq+' '+iqcriteria+' limit 5)';
                            } else {
                                innerquery=innerquery+', (select id,'+ String.join(childQueryMap.get(iq) ,',')+' from '+iq+' '+iqcriteria+' limit 5)';
                            }
                        }
                    }
                    system.debug('parentFnames:-'+String.join(parentFnames ,','));
                    system.debug('innerquery:-'+innerquery);
                    query='select id,'+String.join(parentFnames ,',')+','+innerquery+' from case where id in '+caseIdList+' and '+Label.ESC_MSMyReferrals+'  LIMIT '+limitOfRecords;
                   system.debug('***Query**'+query);
                    
                }
            }
            else{
            query= 'select '+ esc.ESC_ReturnedColumns__c+ ' from '+esc.ESC_ObjectType__c+' where '+ filterCriteria +' Limit ' + limitOfRecords + ' offset '+offset;
            }
            system.debug('query'+query);
            return query;


        }

        @testvisible private string getOwners(Boolean isUser){
            if(isUser){
                return UserInfo.getUserId();
            }
            List<string> queueIDsList  = new List<string>();
            for(GroupMember queuIDs : [Select Group.ID from GroupMember where UserOrGroupId = :UserInfo.getUserId() and Group.Type = 'Queue']){

                string queuID  ='\''+ queuIDs.GroupID+'\'';
                queueIDsList.add(queuID);
            }
            string mergedIDs ='';
            if(queueIDsList.size() ==0){
                queueIDsList.add('\'xxxxxxxxxxxxxxxxxx\'');
            }
            mergedIDs = string.join(queueIDsList, ',');
            return mergedIDs;
        }
        
     @testvisible string getSubQuery(string homePageQueryName){
         ESC_HomePageQuery__c subQueryRec = [select ESC_ObjectType__c,ESC_ReturnedColumns__c,ESC_NoTruncation__c,ESC_AssignedTo__c,ESC_DefaultSortCol__c,
            ESC_OverrideLabelsForfields__c,ESC_FilterCriteria__c,ESC_ReturnedSecondaryColumns__c,ESC_Milestone_Name__c from ESC_HomePageQuery__c where name = : homePageQueryName][0];
         string querySub = getFinalFilter(subQueryRec , true);
         querySub = 'select '+ String.escapeSingleQuotes(subQueryRec.ESC_ReturnedColumns__c) +' from '+String.escapeSingleQuotes(subQueryRec.ESC_ObjectType__c)+' where '+querySub;
          system.debug('querySub' +querySub);
         List<sObject> resultsSub = Database.query(querySub);
        
        set<string> idsSet = new set<string>();
        idsSet.add('\'xxxxxxxxxxxxxxxxxx\'');
        for(sObject sobj1:resultsSub){
           string valueOfR = (String)sobj1.get(subQueryRec.ESC_ReturnedColumns__c) ;
          if(string.isNotBlank(valueOfR)) {
            idsSet.add('\''+  valueOfR +'\'');
          }
        }
            
           
            return string.join(new List<string>(idsSet), ','); 
     }
     
     
    @testvisible  string getFinalFilter(ESC_HomePageQuery__c esc , boolean isSubQuery){
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
        if(string.isNotBlank(addCriteria)){
            if(string.isBlank(filterCriteria)){
                filterCriteria= addCriteria;
            } else {
                filterCriteria+= ' '+ addCriteria;
            }
        }
        
        return filterCriteria;
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

    }

}