/**
 * CHANGE HISTORY
 * =============================================================================
 * Name                : ODT_NCJCreateEntitlementPrimary
 * Description         : This class is serving as controller class for the VF page 'NCJCreateEntitlementPrimary'. The main purpose is to display 
 *              an error or success message on the Trial page based on the response of ODT One pass Error Service.                      
 * Created Date        : 2/11/2019 
 * Author              : Ameeta Antonio
 * Change History
 * 16-11-2020       Rahul       DLT-21092-Made PMD fixes
 * =============================================================================
 */
public without sharing class ODT_NCJCreateEntitlementPrimary {

    public Boolean checkError1 {
        get;
        set;
    }
    public Boolean checkError2 {
        get;
        set;
    }
    public Boolean checkError3 {
        get;
        set;
    }
    public string trialID {
        get;
        set;
    }
    public List < Trial__c > trialList;
    public ODT_NCJCreateEntitlementPrimary(ApexPages.StandardController controller) {
        trialID = apexpages.currentpage().getparameters().get('id');
        checkError1 = false;
        checkError2 = false;
        checkError3 = false;
    }
    public void callService() {
        trialList = new List < Trial__c > ([Select Id, Source_System_Detail__c, Profile_Type__c, Profile_ID__c, SAP_Promotion_Code__c, Lapsed_Reason_Code__c, Is_Lapsed__c, ODT_Email__c, Trial_Initiated_Account_Number__c, One_Pass_Identifier__c, User_Auth_ID__c,
            Source_System_Detail__r.Account_Name__c, Source_System_Detail__r.Account_Name__r.Name, Contact_id_SAP__c, Contact_LeadId__c, ODT_SAP_Account_Number__c, Trial_Id__c, ODT_Product_Bundle__c, ODT_Trial_Product_Category__c, Trial_Status__c,
            Trial_Source__c, Primary_User_First_Name__c, Primary_User_Last_Name__c, Service_Count__c, Contact_LeadId__r.Company, Trial_End_Date__c, Trial_Start_Date__c, GUID__c, GSI_Trial__c FROM Trial__c where Id =: trialID
        ]);
        if (trialList.size() > 0) {
            for (Trial__c t: trialList) {
                if (t.GSI_Trial__c == false) {
                    checkEntitlementStatus(t);
                } else {
                    checkError3 = true;
                }
            }
        }
    }
    public void checkEntitlementStatus(Trial__c t) {
        Boolean checkEntitlement = ODT_OnePassErrorService.checkError(t, null, 'Trial');
        if (checkEntitlement == false) {
            checkError1 = true;
        } else if (checkEntitlement == true) {
            checkError2 = true;
        }
    }
    public PageReference closePopup() {
        PageReference myVFPage = new PageReference('/' + trialID);
        myVFPage.setRedirect(true);
        return myVFPage;
    }
}