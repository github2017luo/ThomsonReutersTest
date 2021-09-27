/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-07-17   Navleen Kaur            Created for GLI to format fields of Source_System_Detail__c
 * 2018-12-19   Navleen Kaur            DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
 * 2019-01-10   Navleen Kaur            DLT-14349 : [Tech Story] [Code Scan]
 * 2019-06-06   Navleen Kaur            DLT-16786 : [Tech Story] [Code Scan] - Fix code scan MAJOR issues in this DC_ContactSSDFieldCapitalisation_Test.cls
 * 2021-03-25   Kavya S                 DLT-21531 : [INC3938622] [SFDC] Digital landing page reflecting the incorrect address name and PMD fix
 *  ==================================================================================================================================   
 */
/** 
    * @description : use value of SSD name and city,format it and set that value in Digital firm name and digital billing city respectively 
       after formatting.
    */
public without sharing class DC_SSDFieldValueCapitalisation {
    /**
     * use value of SSD name and city,format it and set that value in Digital firm name and digital billing city respectively 
       after formatting.
     * this method is invoked in process builder "Digital SSD Field Value Captialisation".
    */
  @InvocableMethod
  /** 
    * @description : getFormattedSSD
    * @param listOfSSD : list of SSD
    */
    public static void getFormattedSSD(List<Source_System_Detail__c> listOfSSD) {
    
        SET<Id> ssdIDSET= new SET<Id>();
        list<Source_System_Detail__c> listSSD = new list<Source_System_Detail__c>();        
        for(Source_System_Detail__c ssd: listOfSSD){
            ssdIDSET.add(ssd.Id);
        }
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible()){
            listSSD = [Select Id,Name,Digital_Firm_Name__c,City__c,Digital_Billing_City__c from Source_System_Detail__c where Id in :ssdIDSET];
        }
        list<Source_System_Detail__c> listOfFormatSSD = new list<Source_System_Detail__c>();
        if(listSSD!=null && !listSSD.isEmpty()){
        listOfFormatSSD  = DCUtils.formatSSDFirmName(listSSD);
        }
        try{ 
            if(listOfFormatSSD!= null && listOfFormatSSD.size() >0 && Schema.sObjectType.Source_System_Detail__c.isUpdateable()){     
                update listOfFormatSSD;  
            }
        }Catch(DMLException dmlExc){
            system.debug(logginglevel.INFO,'****Exception Occurred::' + dmlExc.getMessage());
        }     
    }
}