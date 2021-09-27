public class ESC_EPX_User_Wrapper{

    //static List<ESC_EPX_Team_Supported_Lang__mdt> custSetSupportedLanguages;
    static Map<String, List<String>> mapSupportedLanguages;
    static List<ESC_EPX_Team_Lang_Settings__mdt> custMetTeamLangSetting;
    
    //Map<UserRole,ESC_EPX_Team_Lang_Settings__mdt>
    static Map<String,ESC_EPX_Team_Lang_Settings__mdt> mapTeamLangSetting;
    
    //Map<LanguageName, Languages__c>
    static Map<String,Languages__c> MapLanguages;
    List<Languages__c> listLanguages;
    
    static List<ESC_EPX_Language_List__mdt> listCustomSetLangs;
    static Map<id, String> mapCustSetLangs;
    
    
    String userRoleId;
    public UserRole userRole;
    String teamLangSetting;
    Languages__c teamLang;
    User manager;
    static Profile profile;
    
   
    
    public ESC_EPX_User_Wrapper(){
          
        if(mapSupportedLanguages == null){
            mapSupportedLanguages = new Map<String, List<String>>();
        }
        if(mapTeamLangSetting == null){
            mapTeamLangSetting = new Map<String,ESC_EPX_Team_Lang_Settings__mdt>();
        }
        if(MapLanguages == null){
            MapLanguages = new Map<String,Languages__c>();
            listLanguages = [SELECT Id, Charecter_Set__c, ISO_Code__c, Salesforce_ISO_Code__c, Language_Name__c FROM Languages__c];
            
            for(Languages__c lang : listLanguages){
                MapLanguages.put(lang.Language_Name__c, lang);
            } 
        }    
        
        userRoleId = UserInfo.getUserRoleId();
        
        if(userRoleID != null){
            userRole = [SELECT DeveloperName, Name FROM UserRole WHERE Id = : userRoleId limit 1]; 
        }
        else{
            System.debug('User is not assinged to a user role');
        }
      
        if(custMetTeamLangSetting == null){
          
          custMetTeamLangSetting = [SELECT User_Role__c, Language_Choice__c, Language__r.Language__c FROM ESC_EPX_Team_Lang_Settings__mdt];
          
          for(ESC_EPX_Team_Lang_Settings__mdt teamSettings : custMetTeamLangSetting){
              mapTeamLangSetting.put(teamSettings.User_Role__c,teamSettings);              
          }
        }
    
    }
    
    public List<ESC_EPX_Language_List__mdt> getListCustomSetLangs(){
        if(listCustomSetLangs == null){
            listCustomSetLangs = new List<ESC_EPX_Language_List__mdt>();
            listCustomSetLangs = [SELECT Id, Language__c from ESC_EPX_Language_List__mdt];
        }
        
        return listCustomSetLangs;
    }
    
    public Map<id, String> getMapCustSetLangs(){
        if(mapCustSetLangs == null){
            List<ESC_EPX_Language_List__mdt> langList = getListCustomSetLangs();
            mapCustSetLangs = new Map<id, String>();
            
            for(ESC_EPX_Language_List__mdt l : langList){
                mapCustSetLangs.put(l.id, l.language__c);
            }
        }
        
        return mapCustSetLangs;
    }
    
    public String getTeamLangSetting(){
        if(userRole == null){
            System.debug('Unable to get team lang setting because the user is not assigned to a user role');
            return null;
        }
    
        if(teamLangSetting == null){
            if(mapTeamLangSetting.containsKey(userRole.DeveloperName)){
                teamLangSetting = mapTeamLangSetting.get(userRole.DeveloperName).Language_Choice__c.subString(0,1);
            }
            else{
                return null;
            }
        }
        return teamLangSetting; 
    }
    
    
    public Languages__c getTeamLanguage(){
        if(teamLang == null){
            System.debug('*****mapTeamLangSetting****:'+mapTeamLangSetting);
            ESC_EPX_Team_Lang_Settings__mdt teamSettings = mapTeamLangSetting.get(userRole.DeveloperName);
            String language = getMapCustSetLangs().get(teamSettings.Language__c);
            teamLang = MapLanguages.get(language);          
        }
        return teamLang;
    }

    public static Profile getUserProfile() {
        if(profile == null){
            profile = [select Name from profile where id = : UserInfo.getProfileId() Limit 1];
        }

        return profile;

    }
    
   
  

}