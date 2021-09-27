public class ESC_ObjectSchemaHelper {
  public static Map<string,string>  relationFieldObjMap;
  static Map <String, Schema.SObjectType> schemaMap ;
  static List<SelectOption> finalList = new List<SelectOption>();
  static Map<string,List<SelectOption>> relatedOptions= new Map<string,List<SelectOption>>();

  public static List<string> relatedObjects;
  public static Map<string, Map<string,string>> getObjectNamesUsed(set<String> selectedObjectForSet){
      Map<string, Map<string,string>> relationNames = new Map<string, Map<string,string>>();
      for(string selece : selectedObjectForSet){
          relationNames.put(selece , getObjectNamesUsed(selece));
      }
      //system.debug('relationNames'+JSON.serialize(relationNames));
      return relationNames;
  }
  public static Map<string,string> getObjectNamesUsed(string selectedObject){
        Map<string,string> objectNames =new Map<string,string>();
      schemaMap = schemaMap == null? Schema.getGlobalDescribe() :schemaMap ;

      //system.debug(string.join(new List<string>(schemaMap.keyset()) ,','));
      Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
      //populate main parent object sent via call
      for(Schema.SObjectField sfield : fieldMap.Values())
      {
        schema.describefieldresult dfield = sfield.getDescribe();
        string key= dfield.getLocalName();
        string formula = string.isBlank(dfield.getCalculatedFormula()) ? 'null':dfield.getCalculatedFormula();
        string value = (dfield.getType () + ':' + dfield.getLabel () + ':' +formula);

        if(dfield.getType() == DISPLAYTYPE.reference){
          //system.debug(key+' : '+dfield.getReferenceTo());
          string tempNameOFS='';
          for(Schema.SObjectType reference : dfield.getReferenceTo()) {
            tempNameOFS = reference.getDescribe().getName();
          

          }
          string keyName ;
    
       keyName = key.endsWithIgnoreCase('ID')? key.substringBeforeLast('Id') : key;
          objectNames.put(keyName.toLowerCase() ,tempNameOFS.toLowerCase());
          //relatedObjects.add(dfield.getReferenceTo());
        }
      
        ////system.debug('#######4444' + dfield);

      }
    
      
        return objectNames;
  }
public static Map<string, Map<string,string>> getInfoField(string selectedObj){
    return getInfoField(new set<string>{selectedObj});
}
  public static Map<string, Map<string,string>> getInfoField(set<string> selectedObjSet){
    //system.debug('getInfoField called with' + selectedObjSet );
    Map<string, Map<string,string>>  apiFieldInfoForSet =new Map<string, Map<string,string>>();

    Map<string ,string> extraReferenced = new Map<string ,string>();
    for(string tempObj : selectedObjSet){

      Map<string,string> apiFieldInfo =new Map<string,string>();
      schemaMap = schemaMap == null? Schema.getGlobalDescribe() :schemaMap ;

      //system.debug(string.join(new List<string>(schemaMap.keyset()) ,','));
      Map <String, Schema.SObjectField> fieldMap = schemaMap.get(tempObj).getDescribe().fields.getMap();
      //populate main parent object sent via call
      for(Schema.SObjectField sfield : fieldMap.Values())
      {
        schema.describefieldresult dfield = sfield.getDescribe();
        string key= dfield.getLocalName();
        string formula = string.isBlank(dfield.getCalculatedFormula()) ? 'null':dfield.getCalculatedFormula();
        string value = (dfield.getType () + ':' + dfield.getLabel () + ':' +formula);

        if(dfield.getType() == DISPLAYTYPE.reference){
          ////system.debug(key+' : '+dfield.getReferenceTo());
          string tempNameOFS='';
          for(Schema.SObjectType reference : dfield.getReferenceTo()) {
            tempNameOFS = reference.getDescribe().getName();
          
          }
          extraReferenced.put(key,tempNameOFS);
          //relatedObjects.add(dfield.getReferenceTo());
        }
        apiFieldInfo.put(key.toLowerCase(), value);
        ////system.debug('#######4444' + dfield);

      }
      apiFieldInfoForSet.put(tempObj.toLowerCase(), apiFieldInfo);
    }

    //populate the referenced relation objects from above I have a map of unpopulated ones with keyy--normal name ,value exact object
  Map<string,  Map<string,string>> apiFieldInfoCollection =new   Map<string,  Map<string,string>>();
    for(string localRelationName : extraReferenced.keySet()){
        string tempObj = extraReferenced.get(localRelationName);
      Map<string,string> apiFieldInfo =new Map<string,string>();
      schemaMap = schemaMap == null? Schema.getGlobalDescribe() :schemaMap ;
      
      Map <String, Schema.SObjectField> fieldMap = schemaMap.get(tempObj).getDescribe().fields.getMap();
      
      for(Schema.SObjectField sfield : fieldMap.Values())
      {
        schema.describefieldresult dfield = sfield.getDescribe();
        string key= dfield.getLocalName();
        string formula = string.isBlank(dfield.getCalculatedFormula()) ? 'null':dfield.getCalculatedFormula();
        string value = (dfield.getType () + ':' + dfield.getLabel () + ':' +formula);

        apiFieldInfo.put(key.toLowerCase(), value);
        ////system.debug('#######4444' + dfield);

      }
      string keyName ;
    
       keyName = localRelationName.endsWithIgnoreCase('ID')? localRelationName.substringBeforeLast('Id') : localRelationName;
           // //system.debug('going key out'+keyName);
      apiFieldInfoCollection.put(keyName.toLowerCase() ,apiFieldInfo);
      
    }
apiFieldInfoForSet.putAll(apiFieldInfoCollection);
    //add info to empty



    //system.debug('getInfoField end with apiFieldInfo' + JSON.serialize(apiFieldInfoForSet) );
    return apiFieldInfoForSet;
  }



  // with parent info mergerd
  private static void addToMap (Map<string, Map<string,string>> baseMap, string pKey , string sKey ,string value){
    Map<string,string> tempMap;

    if(baseMap.containsKey(pKey)){
      tempMap = baseMap.get(pKey);
    }
    else{
      tempMap = new Map<string,string>();
    }
    tempMap.put(sKey.toLowerCase(),value);

    baseMap.put(pKey,tempMap);
  }
  




  public static List<SelectOption> getPickListOptions(string  selectedObj, string fieldName){
    list<SelectOption> options = new list<SelectOption>();
    try{
      //system.debug('getPickListOptions called with' + selectedObj + '__:__' + fieldName);
      if(fieldName.contains('.')){
        fieldName = fieldName.substringAfter('.');
           }


      // Get the object type of the SObject.
      Schema.sObjectType objType = Schema.getGlobalDescribe().get(selectedObj);

      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   

      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 

      // Get the list of picklist values for this field.
      list<Schema.PicklistEntry> values =
          fieldMap.get(fieldName).getDescribe().getPickListValues();

      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a : values)
      { 
        options.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
      //system.debug('getPickListOptions ends with' + options );

    }
    catch(exception ex){
      //system.debug('Exception for ' + fieldName );
      //system.debug('selectedObj' + selectedObj );
      system.debug('exception' + ex );
    }
    return options;
  }

  public static string getObjectNameForRelation(string refObj, string fieldAPIName){

    relationFieldObjMap = relationFieldObjMap == null?  new Map<string,string>() :relationFieldObjMap;
    //system.debug('relationFieldObjMap == null ?'+relationFieldObjMap == null);
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
}