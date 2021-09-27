/********************
Author: Matthew Main
Date: 4/30/2018
Version: 1.0
********************/

public class ESC_EPx_Country_To_Lang_Map_Wrapper{

    //Singleton Instance of class
    private static ESC_EPx_Country_To_Lang_Map_Wrapper instance;
    
    //Key = UserRole+Country
    static Map<String, ESC_EPX_Country_To_Lang_Map__mdt > langMap = new Map<String, ESC_EPX_Country_To_Lang_Map__mdt >();
    static List<Languages__c> langList = new List<Languages__c>();
    static Boolean initialized = false;
    

    @TestVisible
    private ESC_EPx_Country_To_Lang_Map_Wrapper(){
    
        List<ESC_EPX_Country_To_Lang_Map__mdt> listCountryToLang = [SELECT id, User_Role__c, ESC_EPX_Country_List__c, ESC_EPX_Language_List__r.Language__c FROM ESC_EPX_Country_To_Lang_Map__mdt];
        String key;
        System.debug('ListCountryToLang' + listCountryToLang);
        
        if(listCountryToLang != null){
            for(ESC_EPX_Country_To_Lang_Map__mdt c : listCountryToLang){
                key = c.User_Role__c + c.ESC_EPX_Country_List__c;
                System.debug('LangMap Key:' + key);
                langMap.put(key,c);
            }
        }
       
        langList = [SELECT Charecter_Set__c, ISO_Code__c, Language_Name__c from Languages__c];
        initialized = true;
    }
    
    public static ESC_EPx_Country_To_Lang_Map_Wrapper getInstance(){
        if(initialized == false){
            instance = new ESC_EPx_Country_To_Lang_Map_Wrapper();
        }
        System.debug(langMap);
        return instance;
    }

    public Map<String, ESC_EPX_Country_To_Lang_Map__mdt> getMap(){
        return langMap;
    }
    
    
    public Languages__c getLanguage(String userRole, String Country){
        if(userRole == null || userRole == '' || country == null || country == ''){
            return getLanguagefromString('English (Default)');
        }
        System.debug('LangMap get(' + userRole+Country +')');
        return getLanguagefromString(langMap.get(userRole+Country).ESC_EPX_Language_List__r.Language__c);
    }
    
    
    private Languages__c getLanguagefromString(String languageName){      
        for(Languages__c l : langList){
            if(l.Language_Name__c == languageName){
                return l;
            }
        } 
        return null;
    }

}