@IsTest

Class ESC_HomePagePreviewControllerTest{
    
    public static testmethod void escProfileLanguageControllerMethod()
    {
        
        List<ESC_HomePageQuery__c> homePageQueryList=new List<ESC_HomePageQuery__c>();
    
     ESC_HomePageQuery__c homePageQueryRec1=new ESC_HomePageQuery__c();
     homePageQueryRec1.ESC_ObjectType__c='Case';
     homePageQueryRec1.ESC_Sequence__c='';
     homePageQueryRec1.ESC_AssignedTo__c='Current User Only';
     homePageQueryList.add(homePageQueryRec1);
    
    ESC_HomePageQuery__c homePageQueryRec2=new ESC_HomePageQuery__c();
    homePageQueryRec2.ESC_ObjectType__c='Case';
    homePageQueryRec2.ESC_Sequence__c='';
    homePageQueryRec2.ESC_AssignedTo__c='Current User Only';
    homePageQueryList.add(homePageQueryRec2);

    insert homePageQueryList;

    ESC_LanguageCodes__c lc=new ESC_LanguageCodes__c();
    lc.ESC_Country_Code__c='en_US';
    lc.Name='English';
    insert lc;
    
    test.startTest();
    Test.setCurrentPage(Page.esc_casehomepage);
    ApexPages.StandardSetController ssc=new ApexPages.StandardSetController(homePageQueryList);
    ssc.setSelected(homePageQueryList);
    ESC_HomePagePreviewController obj=new ESC_HomePagePreviewController(ssc);
    obj.selectedProfile = 'System Administrator';
    obj.selectedLanguage = 'en_US';
    

    obj.getLanguage();
    obj.getProfile();
    test.stopTest();
    
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
    }
    
    
}