/**
 * @description ESC_ListViewController class for home page
 */
public without sharing class ESC_ListViewController {  
    @AuraEnabled
    /**
     * @description fetchListViews
     * @param strObjName
     * @param myLstViewName
     * @return list<string>
     */
    public static list<String> fetchListViews(String strObjName,boolean myLstViewName) {
        list<String> lstListViews = new list<String>();
        List<string> queueNameLst = new List<string>();
        List<string> groupNameList = new List<string>();
        Map<string,Id> groupIdMap = new Map<String,Id>();
        list<ListView> lstViews;
        boolean isDepartment = false;
        boolean isDefaultQueue = false;
        try{
            
            if(strObjName != null && strObjName !=  ' ' && strObjName.length() != 0) {  
                User uObj = new User();
                if (Schema.sObjectType.user.isAccessible() || Schema.sObjectType.user.isQueryable()){
                    uObj = [SELECT name,id,Department from user where id=:UserInfo.getUserId()];
                } 
                if(uObj.Department!=null && uObj.Department!=''){
                    isDepartment = true;
                 }
                List<GroupMember> gm;
                if(isDepartment && !myLstViewName){
                    if (Schema.sObjectType.GroupMember.isAccessible() || Schema.sObjectType.GroupMember.isQueryable()){
                       gm = [Select Group.name,GroupId,group.developername from GroupMember where (UserOrGroupId =:UserInfo.getUserId() OR Group.name=:uObj.Department) and (Group.Type = 'Queue' OR Group.Type = 'Regular')];  
                    }    
                }else{
                    
          gm = [Select Group.name,GroupId,group.developername from GroupMember where UserOrGroupId =:UserInfo.getUserId() and (Group.Type = 'Queue' OR Group.Type = 'Regular')];                    
                }
                
            system.debug(LoggingLevel.WARN,'## gm: ' +gm);
                if(gm!=null && gm.size() >0){
                    for(GroupMember gmObj:gm){
                    if(string.valueOf(gmObj.GroupId).startsWith('00G')){
                      groupIdMap.put(gmObj.Group.developername,gmObj.groupId);
                  }
                    queueNameLst.add(gmObj.Group.Name);
                    } 
                }
                system.debug(LoggingLevel.WARN,'@@ groupIdMap : ' + groupIdMap);
                groupNameList = getGroupLWs(groupIdMap,strObjName);
                system.debug(LoggingLevel.WARN,'@@ queueNameLst : ' + queueNameLst);
            //if(queueNameLst!=null && queueNameLst.size() >0){
                if(myLstViewName){
                    if (Schema.sObjectType.ListView.isAccessible() || Schema.sObjectType.ListView.isQueryable()){
                        lstViews = [Select DeveloperName,NamespacePrefix,Name,sobjectType From ListView where (SobjectType ='Case') and CreatedById=:UserInfo.getUserId()];
                    }
                }else if(queueNameLst!=null && queueNameLst.size() >0){
                    
                    lstViews = [Select DeveloperName,NamespacePrefix,Name,sobjectType From ListView where SobjectType =: strObjName and (Name in:queueNameLst OR DeveloperName in:groupNameList)];
                }
                system.debug(LoggingLevel.WARN,'@@ lstViews : ' + lstViews);
                if(lstViews!=null && lstViews.size() >0){
                    for(ListView iterator:lstViews) {
                        String listname;
                        if(uObj.Department!=null && uObj.Department.equalsIgnoreCase(iterator.Name)){
                           isDefaultQueue  = true;
                           listname  =iterator.Name+':'+iterator.DeveloperName;
                            if(lstListViews!=null && lstListViews.size() > 0){
                                lstListViews.add(0,Listname);
                            }else{
                                
                                lstListViews.add(Listname);
                            }
                            
                        }else{
                             Listname =iterator.Name+':'+iterator.DeveloperName;
                         system.debug(LoggingLevel.WARN,'test'+Listname );
                           lstListViews.add(Listname);
                            
                        }
                   system.debug(LoggingLevel.WARN,'@@ listname : ' + Listname);
                    }
                    if(!isDefaultQueue && !myLstViewName ){
                        string listname  ='--None--'+':'+'';
                        lstListViews.add(0,listname);
                        
                    }
                    
                    system.debug(LoggingLevel.WARN,'@@ lstListViews :: ' + lstListViews);
                    return lstListViews;
                }
                
        //}   
        
            }
        }catch(Exception ex){
                
                system.debug(LoggingLevel.WARN,'@@ Exception Occured : ' +ex.getMessage() +ex.getLineNumber());
        }
        return null;
    }
      
    private static List<string> getGroupLWs(Map<string,id> mapOfGroupNameIds,string objName){
          List<ESC_Home_Page_ListViews__c> groupLWsLst = new List<ESC_Home_Page_ListViews__c>();
          if(Schema.sObjectType.ESC_Home_Page_ListViews__c.isAccessible() || Schema.sObjectType.ESC_Home_Page_ListViews__c.isQueryable()){
          
              groupLWsLst = [SELECT ESC_Group_Name__c,ESC_ListViewName__c,ESC_ObjectName__c FROM ESC_Home_Page_ListViews__c
                             WHERE ESC_Group_Name__c in:mapOfGroupNameIds.keyset()];
          }
          List<string> groupNameLst = new List<string>();
          if(groupLWsLst !=null && groupLWsLst.size() > 0){
              for(ESC_Home_Page_ListViews__c gw:groupLWsLst){
                  
                  if(mapOfGroupNameIds.get(gw.ESC_Group_Name__c)!=null && gw.ESC_ObjectName__c ==objName){
                      groupNameLst.add(gw.ESC_ListViewName__c);
                  }
              }
          }
          return groupNameLst;
      }
}