/**
 * @description ESC_BusHrsUtility class for BH on case
 */
public without sharing class ESC_busHrsUtility{
 /**
     * @description lstMapping
     */
    public static List<ESCSegmentRegionMappingSet__c> lstMapping;
     /**
     * @description userTimezoneMap
     */
    public static Map<Id,User> userTimezoneMap;
     /**
     * @description isBusinessHourUpdated 
     */
    public static Boolean isBusinessHourUpdated = false;
     /**
     * @description caseCreationMapping 
     */
    public static List<ESC_Case_Creation_Field_Mapping__mdt> caseCreationMapping = new List<ESC_Case_Creation_Field_Mapping__mdt>();//Added for Risk
     /**
     * @description setBushrsOnCase
     * @param newCaseList
     */
    public static void setBushrsOnCase(List<Case> newCaseList){
        system.debug(LoggingLevel.WARN,'@@ Case:' + newCaseList);
        
        try{
             
            List<Id> emIDSet = new List<Id>();
            Set<string> subBu = new Set<String>();
            Set<String> region = new Set<String>();
            Set<string> origin = new Set<String>();
            Set<String> source = new Set<String>();
            //Map<Id,Case> caseEMailMessageMap= new Map<Id,Case>();
            Map<String,String> map2 = new Map<String,String>();
            Map<String,String> map3 = new Map<String,String>();
            Map<String,String> mapdevname = new Map<String,String>();
            
            Map<Id,Id> mapbushrs= new Map<Id,Id>();
            string caseFields = '';
            string query= '';
            string caseQuery = '';
            Map<string,ESC_Segment_Region_BH_Selector_Field__mdt> queueSelectorMap = new Map<string,ESC_Segment_Region_BH_Selector_Field__mdt>();
            Map < String, Id > map1 = new Map < String, Id > ();
            Map < String, String > emailMessageLKPValueMap = new Map < String, String > ();
            String curUserTimeZone = '';
            Map < Id, Case > mapcase = new Map < Id, Case > ();
            
            Set<id> setownerid = new Set<Id>();
            boolean queryflag=false;
             
            for(Case eMsg:newCaseList){
                //if(eMsg.entitlementid ==null){
                emIDSet.add(eMsg.Id);
                mapbushrs.put(eMsg.Id,eMsg.businesshoursid);
                //caseEMailMessageMap.put(eMsg.Id,eMsg);
                subBu.add(eMsg.BU_Segment__c);
                region.add(eMsg.LCRM_Sub_BU__c);
                origin.add(eMsg.Origin);
                source.add(eMsg.ESC_Unique_Identifier__c);
                
                //Added for Risk
                mapcase.put(eMsg.Id,eMsg);
                //}
            }
             System.debug(LoggingLevel.WARN,'isBusinessHourUpdated123 ---> '+isBusinessHourUpdated );
            system.debug(LoggingLevel.WARN,'@@ Case1:' + emIDSet);
            if(isBusinessHourUpdated == false ){
            System.debug(LoggingLevel.WARN,'isBusinessHourUpdated ---> '+isBusinessHourUpdated );
            for( ESC_Segment_Region_BH_Selector_Field__mdt queueSelectorObj:[SELECT id,DeveloperName,ESC_Is_Inactive__c,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_Origin__c,ESC_Region__c,ESC_Segment__c,ESC_Source__c,ESC_TimeZone__c from ESC_Segment_Region_BH_Selector_Field__mdt 
                                                                             where (ESC_Region__c in:region and ESC_Origin__c in:origin and 
                                                                             ESC_Source__c in:source and ESC_Is_Inactive__c=false)]){
                                                                                 system.debug(LoggingLevel.WARN,'@@ Case2:' + queueSelectorObj);
                                                                                 
                                                                               //  String seg1=queueSelectorObj.ESC_Segment__c== null?'':queueSelectorObj.ESC_Segment__c;
                                                                                 String seg2=queueSelectorObj.ESC_Region__c== null?'':queueSelectorObj.ESC_Region__c;
                                                                                 String seg3=queueSelectorObj.ESC_Origin__c== null?'':queueSelectorObj.ESC_Origin__c;
                                                                                 String seg4=queueSelectorObj.ESC_Source__c== null?'':queueSelectorObj.ESC_Source__c;
                                                                                 
                                                                                 if(!queueSelectorMap.containsKey(seg2+seg3+seg4))
                                                                                 {
                                                                                     queueSelectorMap.put(seg2+seg3+seg4,queueSelectorObj);
                                                                                     mapdevname.put(queueSelectorObj.DeveloperName,seg2+seg3+seg4);
                                                                                 }
                                                                                 
                                                                                 List<string> fieldApiList = new List<string>();
                                                                                 
                                                                                 if(queueSelectorObj.ESC_Case_Field1__c!=null && queueSelectorObj.ESC_Case_Field1__c!='' ){
                                                                                      caseFields+=queueSelectorObj.ESC_Case_Field1__c+',';
                                                                                  }
                                                                                  if(queueSelectorObj.ESC_Case_Field2__c!=null && queueSelectorObj.ESC_Case_Field2__c!='' ){
                                                                                      caseFields+=queueSelectorObj.ESC_Case_Field2__c+',';
                                                                                 }
                                                                                 if(queueSelectorObj.ESC_Case_Field3__c!=null && queueSelectorObj.ESC_Case_Field3__c!='' ){
                                                                                      caseFields+=queueSelectorObj.ESC_Case_Field3__c+',';
                                                                                 }
                                                                                 if(queueSelectorObj.ESC_Case_Field4__c!=null && queueSelectorObj.ESC_Case_Field4__c!='' ){
                                                                                      caseFields+=queueSelectorObj.ESC_Case_Field4__c+',';
                                                                                     }
                                                                                     if(queueSelectorObj.ESC_Case_Field5__c!=null && queueSelectorObj.ESC_Case_Field5__c!='' ){
                                                                                      caseFields+=queueSelectorObj.ESC_Case_Field5__c+',';
                                                                                     }
                                                                                
                                                                                 if(queueSelectorObj.ESC_TimeZone__c!=null){
                                                                                     queryflag =true;
                                                                                 }
                                                                             }
            system.debug(LoggingLevel.WARN,'@@ Case3:' + queueSelectorMap);
            system.debug(LoggingLevel.WARN,'@@ Case4:' + caseFields);
            if(queueSelectorMap.keyset().size()>0){
                  if(lstMapping == null){
                 lstMapping = [SELECT ESC_LKP__c,ESC_Case_Field1__c,ESC_Case_Field2__c,ESC_Case_Field3__c,ESC_Case_Field4__c,ESC_Case_Field5__c,ESC_IsRecType_BusHours__c,ESC_CaseValLKP__c,ESC_BusHours__c,ESC_Timezones__c,ESC_Related_Met_Name__c FROM ESCSegmentRegionMappingSet__c 
                                                                  WHERE ESC_Related_Met_Name__c IN: mapdevname.keyset() and ESC_IsRecType_BusHours__c='Business Hours'];
                }                                                                  
                system.debug(LoggingLevel.WARN,'@@ Case5:' + lstMapping);
                if(lstMapping.size()>0){
                    system.debug(LoggingLevel.WARN,'@@ Case6:' + lstMapping);
                    if((caseFields!=null && caseFields!='') || queryflag){
                    //Start - Adding new code to handle duplicate fields in CaseFields
                    if((caseFields!=null && caseFields!='') ){
                            Set<String> setDup = new Set<String>();
                            for(String cfield:caseFields.split(',')){
                                setDup.add(cfield);
                            }
                            String temp = '';
                            for(String s:setDup){
                                if(temp == ''){
                                    temp = s + ',';
                                }else{
                                    temp = temp + s +',';
                                }
                            }
                            caseFields = temp;
                    }  
                    
                    system.debug(LoggingLevel.WARN,'@@ Case44:' + caseFields); 
                    //End - Adding new code to handle duplicate fields in CaseFields
                        if((caseFields.containsignorecase('ownerid'))){
                        caseQuery = 'SELECT id,'+caseFields+'casenumber,BU_Segment__c,LCRM_Sub_BU__c,Origin,ESC_Unique_Identifier__c,createdbyid FROM Case WHERE id IN: emIDSet';
                        }else if(caseFields.containsignorecase('createdbyid')){
                        caseQuery = 'SELECT id,'+caseFields+'casenumber,BU_Segment__c,LCRM_Sub_BU__c,Origin,ESC_Unique_Identifier__c,ownerid FROM Case WHERE id IN: emIDSet';
                        }else if(caseFields.containsignorecase('ownerid') && caseFields.containsignorecase('createdbyid')){
                        caseQuery = 'SELECT id,'+caseFields+'casenumber,BU_Segment__c,LCRM_Sub_BU__c,Origin,ESC_Unique_Identifier__c FROM Case WHERE id IN: emIDSet';
                        }else{
                        caseQuery = 'SELECT id,'+caseFields+'casenumber,BU_Segment__c,LCRM_Sub_BU__c,Origin,ESC_Unique_Identifier__c,ownerid,createdbyid FROM Case WHERE id IN: emIDSet';
                        }
                    }
                    system.debug(LoggingLevel.WARN,'### dynamic query case ###' +caseQuery);
                    List<Case> caseList = new List<Case>();
                    if(caseQuery!= '' && caseQuery != null){
                        caseList = Database.query(caseQuery);
                    }
                    system.debug('### casequery ###' + caseList);
                    for(Case caseObj:caseList){
                        //caseEMailMessageMap.put(caseObj.id,caseObj);
                        setownerid.add(caseObj.ownerid);
                         if(UserInfo.getName() != 'Automated Process')
                         {
                         setownerid.add(caseObj.createdbyid);
                        }
                    }
                    if(queryflag){
                    if(userTimezoneMap==null){
                        userTimezoneMap = new Map<Id,User>([Select id,TimeZoneSidKey from User where id In :setownerid or id=:UserInfo.getUserId()]);
                        }
                    }
                    system.debug(LoggingLevel.WARN,'@@casemap'+userTimezoneMap);
                    for(Case caseObj:caseList){
                      //  String cas1 = caseObj.BU_Segment__c== null?'':caseObj.BU_Segment__c;
                        String cas2 = caseObj.LCRM_Sub_BU__c== null?'':caseObj.LCRM_Sub_BU__c;
                        String cas3 = caseObj.Origin== null?'':caseObj.Origin;
                        String cas4 = caseObj.ESC_Unique_Identifier__c== null?'':caseObj.ESC_Unique_Identifier__c;
                        ESC_Segment_Region_BH_Selector_Field__mdt queueSelector = queueSelectorMap.get(cas2+cas3+cas4);
                        
                        system.debug('queueSelector***'+queueSelector);
                        
                        List<string> fieldApiLst = new List<string>();
                        string lkp='';
                        if(caseFields!=''){
                            //fieldApiLst = caseFields.split(',');
                            //system.debug('fs***'+fieldApiLst);
                            //system.debug('caseFields***'+caseFields);
                            for(string cfield:caseFields.split(',')){
                                system.debug(LoggingLevel.WARN,'fs***'+cfield);
                                if( cfield.contains('.')){
                                    String rname1;
                                    List<String> list1 = new List<String>();
                                    for(String s : cfield.split('\\.')){
                                        list1.add(s);
                                    }
                                    String t1=list1[0];
                                    String t2=list1[1];
                                    if(caseObj.getSObject(t1)!=null){
                                        rname1= string.valueOf(caseObj.getSObject(t1).get(t2));
                                    }
                                    if(rname1!=null){
                                        lkp+=rname1;
                                    }
                                }
                                else if (cfield != null && cfield != ''){
                                    String temp=String.Valueof(caseObj.get(cfield));
                                    if(temp!=null&&temp!=''){
                                        lkp=lkp +temp ;
                                    }
                                }
                                
                                system.debug(LoggingLevel.WARN,'lkp***'+lkp);
                            }
                        }
                        
                        else if(queueSelector.ESC_TimeZone__c!=null){
                            if(userTimezoneMap.keyset().size()>0){
                                if(queueSelector.ESC_TimeZone__c == 'Owner'){
                                    curUserTimeZone = userTimezoneMap.get(caseObj.Ownerid).TimeZoneSidKey;
                                }else if(queueSelector.ESC_TimeZone__c == 'User'){
                                    curUserTimeZone = userTimezoneMap.get(Userinfo.getuserid()).TimeZoneSidKey;
                                }else if(queueSelector.ESC_TimeZone__c == 'Creator'){
                                    curUserTimeZone = userTimezoneMap.get(caseObj.createdbyid).TimeZoneSidKey;
                                }
                                
                                map3.put(caseObj.id,curUserTimeZone);
                                system.debug(LoggingLevel.WARN,'@@case7'+map3);
                            }
                        }
                        
                        system.debug(LoggingLevel.WARN,'lkp***'+lkp);
                        if(lkp!='' && lkp!=null){
                            emailMessageLKPValueMap.put(caseObj.Id,lkp);
                        }
                    }
                    
                    System.debug(LoggingLevel.WARN,'### emailMessageLKPValueMap ### ' + emailMessageLKPValueMap);
                    
                    
                    if(!emailMessageLKPValueMap.isEmpty()){
                        //Change where cond of below query with picklist value as Business Hours
                        for(ESCSegmentRegionMappingSet__c queueSelectLkpObj:lstMapping)
                        {
                            for(String temp:emailMessageLKPValueMap.values() ){
                                if(queueSelectLkpObj.ESC_CaseValLKP__c == temp){
                                    map1.put(queueSelectLkpObj.ESC_CaseValLKP__c,queueSelectLkpObj.ESC_BusHours__c);
                                }
                            }
                        }
                    }else if(curUserTimeZone!=''){
                        for(ESCSegmentRegionMappingSet__c obj:lstMapping){
                            if(obj.ESC_Timezones__c == curUserTimeZone){
                                map2.put(curUserTimeZone,obj.ESC_BusHours__c);
                            }
                        }
                        
                    }
                    system.debug(LoggingLevel.WARN,'Map1**'+map1);
                    
                    List<case> caseIdLst = new List<case>();
                    //for(Id csIds:emailMessageLKPValueMap.keyset()){
                    //emIDSet
                    for(Id csIds:emIDSet){
                        system.debug(LoggingLevel.WARN,'is insert : ' + trigger.isInsert);
                        system.debug(LoggingLevel.WARN,'is update : ' + trigger.isUpdate);
                        system.debug(LoggingLevel.WARN,'setCaseFields ' + ESC_EmailUtility.setcaseFields);
                        Case cs;
                        //Added for Risk
                        if(Trigger.isInsert || ESC_EmailUtility.setcaseFields){
                                cs =  setCaseFieldBasedOnMapping(mapcase.get(csIds).BU_Segment__c, mapcase.get(csIds).LCRM_Sub_BU__c, mapcase.get(csIds).Origin,mapcase.get(csIds).ESC_Unique_Identifier__c);
                                system.debug(LoggingLevel.WARN,'cs is'+cs);
                            }
                        if(cs==null){
              cs = new Case();
            }
                        
                        cs.Id = csIds;
                        system.debug(LoggingLevel.WARN,'##Mapentitlement'+ mapcase.get(csIds).entitlementid);
                        if(mapcase.get(csIds).entitlementid == null && emailMessageLKPValueMap.keyset().size()>0 && emailMessageLKPValueMap.get(csIds)!=null){
                            if(map1.keyset().size()>0 && map1.get(emailMessageLKPValueMap.get(csIds))!=null){
                                cs.BusinessHoursId =map1.get(emailMessageLKPValueMap.get(csIds));
                                if(mapbushrs.get(csIds)!=cs.BusinessHoursId){
                            caseIdLst.add(cs);
                                }
                            }
                        }else if(mapcase.get(csIds).entitlementid == null && map3.keyset().size()>0 && map3.get(csIds)!=null){
                            if(map2.keyset().size()>0 && map2.get(map3.get(csIds))!=null){
                            cs.BusinessHoursId =map2.get(map3.get(csIds));
                            if(mapbushrs.get(csIds)!=cs.BusinessHoursId){
                            caseIdLst.add(cs);
                            }
                            }
                        }else{//Added for risk
                            if(Trigger.isInsert || ESC_EmailUtility.setcaseFields){
                                caseIdLst.add(cs);
                            }
                        }
                        
                    }
                    system.debug(LoggingLevel.WARN,'### caseIdLst ###' + caseIdLst);
                    if(caseIdLst!=null && !caseIdLst.isEmpty() && isBusinessHourUpdated ==false) {
                        if(Schema.sObjectType.case.isUpdateable() || Schema.sObjectType.case.isAccessible()){
                            isBusinessHourUpdated =true;
                            update(caseIdLst);
                        }
                        
                    }
                }
            }
        } 
        }
        catch(Exception ex){
            system.debug(LoggingLevel.WARN,'exception'+ex);
        } 
    }

   
    /**
     * @description setBushrsOnCase
     * @param segment
     * @param region
     * @param integrationType
     * @param uniquedentifier
     * @return Case
     */
     public static Case setCaseFieldBasedOnMapping(String segment, String region, String integrationType, string uniquedentifier){
     List<ESC_Case_Creation_Field_Mapping__mdt> caseCreationMapping = new List<ESC_Case_Creation_Field_Mapping__mdt>();
        if(Schema.sObjectType.ESC_Case_Creation_Field_Mapping__mdt.isAccessible() && Schema.sObjectType.ESC_Case_Creation_Field_Mapping__mdt.isQueryable()){  
            caseCreationMapping = [Select Segment__c, Region__c, Integration_Type__c, Field_API_Name__c, Field_Value__c
                                                                         From ESC_Case_Creation_Field_Mapping__mdt
                                                                         where Segment__c =:segment AND Region__c =:region AND
                                                                                Integration_Type__c = :integrationType AND Unique_Identifier__c=:Uniquedentifier];
        } 
    if(caseCreationMapping.size()>0){
        Case oCase = new Case();        
        map <String,String> queueIdMap=new map<string,string>(); 
        List <string> queuenamelist = new List<string>(); 
        system.debug(LoggingLevel.WARN,'case creation mapping'+casecreationmapping); 
        for(ESC_Case_Creation_Field_Mapping__mdt oMapping: caseCreationMapping){
            if(oMapping.Field_API_Name__c == 'OwnerId' && oMapping.Field_Value__c != null && oMapping.Field_Value__c != '')
                {
                    queuenamelist.add(oMapping.Field_Value__c);
                }
        } 
        for(Group grp : [Select id,developername from group where developername IN :queuenamelist]){
            queueIdMap.put(grp.developername,grp.id);
        }     
        for(ESC_Case_Creation_Field_Mapping__mdt oMapping: caseCreationMapping)
        {
                //oCase.put('ESC_Unique_Identifier__c', oMapping.Unique_Identifier__c);  
                if(oMapping.Field_API_Name__c == 'OwnerId' && oMapping.Field_Value__c != null && oMapping.Field_Value__c != '' && queueIdMap != null && queueIdMap.containsKey(oMapping.Field_Value__c)){
                    oCase.put(oMapping.Field_API_Name__c,queueIdMap.get(oMapping.Field_Value__c) );
        }else if(oMapping.Field_API_Name__c == 'ESC_Case_Type__c' && oMapping.Field_Value__c != null && oMapping.Field_Value__c != ''){
                    oCase.put('RecordTypeId', ESC_Utility.recordTypeNameToId('Case',oMapping.Field_Value__c));   
          oCase.put(oMapping.Field_API_Name__c,oMapping.Field_Value__c );                 
        }
                else{
                    oCase.put(oMapping.Field_API_Name__c, oMapping.Field_Value__c);
        }
                
            
        }
        system.debug(LoggingLevel.WARN,'+++oCase'+oCase);
        return oCase;  
   }
   return null;
    }
}