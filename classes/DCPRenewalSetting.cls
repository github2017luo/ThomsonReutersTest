/**
    @description Class for fetcing Renewal Custom/Metadata Settings
    CHANGE HISTORY
    ================================================
    Date            Developer           Description
    23-04-2021      Benjamin Her        Initial Creation
    05-06-2021      Vishnu Santhosh     Inside getValue method - Changed 'contains' method to 'equals'
    
 */
public without sharing class DCPRenewalSetting{

    /**
        @description Stores the queried renewal setting
     */
    public static List<DCP_Renewal_Setting__mdt> renewalSettings = new List<DCP_Renewal_Setting__mdt>();
    
    /**
        @description Run queries on Renewal Settings Custom Metadata Object
         @return Returns the queried renewal settings
     */
    public static List<DCP_Renewal_Setting__mdt> getRenewalSetting(){
        renewalSettings = [SELECT Field_Name__c, Field_Value__c 
                        FROM DCP_Renewal_Setting__mdt 
                        WITH SECURITY_ENFORCED];
        
        return renewalSettings;
    }
    /**
        @description Run queries on Renewal Settings Custom Metadata Object
        @param fieldName Used to fetch the corresponding field value
         @return Returns the field value. If there is no matching field, returns null string.
     */
    public static String getValue(String fieldName){
        for (DCP_Renewal_Setting__mdt renewalSetting : renewalSettings){
            if(renewalSetting.Field_Name__c.equals(fieldName)){
                return renewalSetting.Field_Value__c;
            }
        }
        return '';
    }
}