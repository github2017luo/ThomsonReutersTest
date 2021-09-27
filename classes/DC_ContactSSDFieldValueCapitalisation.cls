/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-07-17   Navleen Kaur            Created for GLI to format fields of Contact SSD
 * 2018-12-19   Navleen Kaur            DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
 * 2019-01-10   Navleen Kaur            DLT-14349 : [Tech Story] [Code Scan]
 * 2019-06-06   Navleen Kaur            DLT-16786 : [Tech Story] [Code Scan] - Fix code scan MAJOR issues in this DC_ContactSSDFieldCapitalisation_Test.cls
 * ==================================================================================================================================   
 */
public without sharing class DC_ContactSSDFieldValueCapitalisation {
    /**
     * use value of contact SSD first name ,format it and set that value in Digital first name after formatting.
     * this method is invoked in process builder "Digital Contact Field Value Captialisation".
    */
   @InvocableMethod
    public static void getFormattedContactSSD(List<LCRM_Contact_SSD__c> listOfSSD) {
    
        SET<Id> ssdIDSET= new SET<Id>();  
        list<LCRM_Contact_SSD__c> listSSD = new list<LCRM_Contact_SSD__c>();    
        for(LCRM_Contact_SSD__c ssd: listOfSSD){
            ssdIDSET.add(ssd.Id);
        }
        if(Schema.sObjectType.LCRM_Contact_SSD__c.isAccessible()){
            listSSD = [Select Id,LCRM_First_Name__c,Digital_FirstName__c from LCRM_Contact_SSD__c where Id in :ssdIDSET];
        }
        list<LCRM_Contact_SSD__c> listOfFormatSSD = new list<LCRM_Contact_SSD__c>();
        if(listSSD!=null && !listSSD.isEmpty()){
        listOfFormatSSD  = DCUtils.formatContactSSDFirstName(listSSD);
        }
        try{
        if(listOfFormatSSD!=null && !listOfFormatSSD.isEmpty()  && Schema.sObjectType.LCRM_Contact_SSD__c.isUpdateable()){
            update listOfFormatSSD; 
        }
        }Catch(DMLException dmlExc){
            system.debug('****Exception Occurred::' + dmlExc.getMessage());
        }         
    }
}