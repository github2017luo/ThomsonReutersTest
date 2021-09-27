/*============================================================================================
    Name                : ODTWrapperClass
    Description         : This class was created to fix PMD issues for ODT classes

    DATE            DEVELOPER       CHANGE HISTORY
    12-01-2020      Brenda Shields  DLT-21339 : [SFDC] [ODT][PMD SCAN] Critical Components Code scan issue
==============================================================================================*/
public with sharing class ODTWrapperClass {
    
    // class wrapper for ODTStartNCJCon
    // created to fix PMD ExcessivePublicCount
    public class ODTStartNCJConWrapper {
        public string selMarketSegment {get;set;}
        public string selProductBundle {get;set;}
        public list < SelectOption > marketSegments {get;set;}
        public list < SelectOption > productBundleList {get;set;}
        public Invite_Colleagues__c invColleague {get;set;}
    }
    
    
}