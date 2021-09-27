/************
Author: Matthew Main
Version 0.1
Date: 5/21/2018
Email:Matthew.Main@thomsonreuters.com
*************/


public class ESC_EPX_Language_List_Wrapper{

    private static boolean initialized = false;
    private static ESC_EPX_Language_List_Wrapper instance;
    private static List<Languages__c> listLanguages;
    
    //Map<Language_Name__c, Lanugages__c>
    private static Map<String, Languages__c> mapLanguagesbyName;
    private static Map<String, Languages__c> mapLanguagesbyClicktoolsISO;
    
    
 


    @TestVisible
    private ESC_EPX_Language_List_Wrapper(){
        if(initialized == false){
            initialized = true;
            
            instance = new ESC_EPX_Language_List_Wrapper();
            listLanguages = [SELECT ISO_Code__c, Charecter_Set__c, Language_Name__c, 
                                   Salesforce_ISO_Code__c, Salesforce_Language_Name__c 
                            FROM Languages__c];
            
            mapLanguagesByName = new Map<String, Languages__c>();
            mapLanguagesByClicktoolsISO = new Map<String, Languages__c>();
                            
            for(Languages__c l : listLanguages){
                mapLanguagesByName.put(l.Language_Name__c, l);
                mapLanguagesbyClicktoolsISO.put(l.ISO_Code__c, l);
            }
            
            
        }//End Initialization Check
        
        
    }
    
    public static ESC_EPX_Language_List_Wrapper getInstance(){
        if(instance == null){
            instance = new ESC_EPX_Language_List_Wrapper();
        }
        return instance;
    }

    public Languages__c getLanguageByName(String languageName){
        if(mapLanguagesByName.containsKey(languageName)){
            return mapLanguagesByName.get(languageName);
        }
        System.debug('The language passed to getLanguageByName() in Class : ESC_EPX_Language_List_Wrapper return NULL ');
        return null;
    }
    
    public Languages__c getLanguageByClicktoolsISOCode(String ISO){
        if(mapLanguagesbyClicktoolsISO.containsKey(ISO)){
            return mapLanguagesbyClicktoolsISO.get(ISO);
        }
        System.debug('The language passed to getLanguageByClicktoolsISOCode() in Class : ESC_EPX_Language_List_Wrapper return NULL ');
        return null;
    }
  

}