public class ESC_HomePagePreviewController{

    public string selectedProfile{get;set;}
    public string selectedLanguage{get;set;}
    
    Public List<Selectoption> getProfile(){
        List<Selectoption> profiles= new List<selectoption>();
        for(profile p :[SELECT id,Name from Profile]){
            profiles.add(new selectoption(p.id,p.name));
        }
    return profiles;
    }

    Public List<Selectoption> getLanguage(){
        List<Selectoption> language= new List<selectoption>();
        list<ESC_LanguageCodes__c> langCodes= ESC_LanguageCodes__c.getall().values() ;
        for( ESC_LanguageCodes__c lng: langCodes){
            language.add(new SelectOption(lng.ESC_Country_Code__c,lng.Name));
        }
        language.sort();
        return language;
    }

    public ESC_HomePagePreviewController(ApexPages.StandardSetController controller) {
    
    }

}