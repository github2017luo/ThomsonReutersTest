/**
 * CHANGE HISTORY
 * =============================================================================
 * Name                : ODT_NCJCreateEntitlementINC
 * Description         : This class is serving as controller class for the VF page 'NCJCreateEntitlementINC'. The main purpose is to display 
 * 						 an error or success message on the Invited Colleague page based on the response of ODT One pass Error Service.                      
 * Created Date        : 2/11/2019 
 * Author              : Ameeta Antonio
 * =============================================================================
 */
public without sharing class ODT_NCJCreateEntitlementINC {

    //public Boolean checkEntitlement{get; set;}
    public Boolean checkError {
        get;
        set;
    }
    public string incID {
        get;
        set;
    }
    //public Invite_Colleagues__c invColleague{get; set;}
    public List < Invite_Colleagues__c > incList;

    public ODT_NCJCreateEntitlementINC(ApexPages.StandardController controller) {
        System.Debug('Page Controller->'+controller);
    }

    public void callService() {
        checkError = false;
        incID = apexpages.currentpage().getparameters().get('id');

        incList = new List < Invite_Colleagues__c > ([Select ID, Source_System_Detail__c, Email__c, First_Name__c, Last_Name__c, Primary_User__c, Trial__c, SapContactId__c, Trial__r.ODT_SAP_Account_Number__c, Trial__r.Profile_Type__c, User_Auth_ID__c, One_Pass_Identifier__c, Service_Count__c,
            Trial__r.Contact_LeadId__c, Trial__r.Id, Trial__r.Contact_LeadId__r.Company, Trial__r.Trial_Source__c, Trial__r.Trial_End_Date__c, Trial__r.Is_Lapsed__c, Trial__r.Trial_Start_Date__c, Trial__r.Trial_Id__c, GUID__c FROM Invite_Colleagues__c where Id =: incID
        ]);

        if (incList.size() > 0) {
            for (Invite_Colleagues__c inc: incList) {
                //invColleague = incList[0];
                Boolean checkEntitlement = ODT_OnePassErrorService.checkError(null, inc, 'IC');
                if (checkEntitlement == false) {
                    checkError = true;
                } else if (checkEntitlement == true) {
                    checkError = false;
                }
            }
        }
    }

    public PageReference closePopup() {
        PageReference myVFPage = new PageReference('/' + incID);
        myVFPage.setRedirect(true);
        return myVFPage;
    }
}