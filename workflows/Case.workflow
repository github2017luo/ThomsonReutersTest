<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AccountArchive</fullName>
        <ccEmails>west.mdb_team@thomson.com</ccEmails>
        <description>Upon creation of a case in the US Legal Account Archive queue – an email shall be sent to a Legal Data team mailbox (MDB_Team@thomson.com) with a link directly to the case.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Alertoncreationofa_Archive_caseVF</template>
    </alerts>
    <alerts>
        <fullName>Account_Archive_Closed_Notification</fullName>
        <description>Account Archive Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Archive_Closed_NotificationVF</template>
    </alerts>
    <alerts>
        <fullName>Account_Archive_Closed_Notification_Portuguese</fullName>
        <description>Account Archive Closed Notification Portuguese</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Archive_Closed_Notification_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Account_Archive_Closed_Notification_Spanish</fullName>
        <description>Account Archive Closed Notification Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Archive_Closed_Notification_Spanish</template>
    </alerts>
    <alerts>
        <fullName>AlertforANZCustomerCare</fullName>
        <description>This email alert will be sent to customers when case will be created for &quot;Customer Care&quot;.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>care.anz.autogen@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Legal_CustExp/ANZ_Customer_Care_for_Manual_Case</template>
    </alerts>
    <alerts>
        <fullName>AlertforANZServiceFirst</fullName>
        <description>This email alert will be sent to customers when case will be created for &quot;ServiceFirst&quot;.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>servicefirst.anz.autogen@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Legal_CustExp/ANZ_ServiceFirst_for_Manual_Case</template>
    </alerts>
    <alerts>
        <fullName>AlertforANZTechnicalCare</fullName>
        <description>This email alert will be sent to customers when case will be created for &quot;Technical Care&quot;.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>techcare.anz.autogen@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Legal_CustExp/ANZ_Technical_Care_for_Manual_Case</template>
    </alerts>
    <alerts>
        <fullName>CasePendingForMoreThan5Days</fullName>
        <description>CasePendingForMoreThan5Days</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Management_Email_Templates/Case_Status_notOPANC_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CaseSatusClosedEmail</fullName>
        <description>CaseSatusClosedEmail</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Management_Email_Templates/Case_Status_Closed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CaseStatusEscalatedPending5Days</fullName>
        <description>CaseStatusEscalatedPending5Days</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Management_Email_Templates/Case_Status_Escalated_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CaseStatusOnHoldPending3Days</fullName>
        <description>CaseStatusOnHoldPending3Days</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Management_Email_Templates/Case_Status_On_Hold_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Notification</fullName>
        <description>Case Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ESC_GSI_Salesperson_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Ticket_Inquiry/Case_Create_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Owner_Change</fullName>
        <description>Case Owner Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Old_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Management_Email_Templates/Case_Owner_Not_Queue_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Referral_Response_Time_is_voilated</fullName>
        <description>Case Referral Response Time is voilated</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>GGO_Referral_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>GGO_Referral_Owner_Mgr_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Service_Email/GGO_Referral_SLA_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Response_time_Voilated</fullName>
        <description>Case Response time Voilated</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Service_Email/GGO_Case_SLA_Escalation_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Waiting_for_Response_Notification</fullName>
        <description>Case Waiting for Response Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ESC_GSI_Salesperson_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Ticket_Inquiry/Case_Waiting_for_Response_Notification</template>
    </alerts>
    <alerts>
        <fullName>Caselines_Cust_Support</fullName>
        <description>Caselines Customer Support Email alert for Web to case</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Caselines/Caselines_Customer_Support</template>
    </alerts>
    <alerts>
        <fullName>Change_Owner_of_Case</fullName>
        <description>Change Owner of Case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notification_Case_Owner_Change</template>
    </alerts>
    <alerts>
        <fullName>Closed_Case_Email_Notification_to_Owner</fullName>
        <description>Closed Case Email Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <field>ESC_GSI_Salesperson_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Close_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>Contact_Inactivate_Closed_NotificationVF</fullName>
        <description>Contact Inactivate Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contact_Inactivate_Closed_NotificationVF</template>
    </alerts>
    <alerts>
        <fullName>Corp_GTaxCase_AutoResponse</fullName>
        <ccEmails>gtm.support.latam@1bp08e0bzld64r2snm44bv3zss8fmwzl4zi8jbhlvvqmxho4pd.w-lnx6eae.na79.case.salesforce.com</ccEmails>
        <description>Corp GTaxCase AutoResponse</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Corp_Internal_Templates/CorpGTaxAutoResponse</template>
    </alerts>
    <alerts>
        <fullName>Corp_GTaxCase_ClosureMail</fullName>
        <ccEmails>gtm.support.latam@1bp08e0bzld64r2snm44bv3zss8fmwzl4zi8jbhlvvqmxho4pd.w-lnx6eae.na79.case.salesforce.com</ccEmails>
        <description>Corp GTaxCase ClosureMail</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Corp_Internal_Templates/CorpGTaxClosuremail</template>
    </alerts>
    <alerts>
        <fullName>DQA_Request_Closed_Notification</fullName>
        <description>DQA Request Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DQA_Request_Closed_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>ESC_Customer_portal_case_Ack_For_Other_Severity</fullName>
        <ccEmails>thomsonreuterscustomersupportelite@thomsonreuters.com</ccEmails>
        <description>ESC Customer portal case Ack For Other Severity</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportelite@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Elite/Elite_Customer_community_Non_Urgernt_Auto_Response_Customer_Support</template>
    </alerts>
    <alerts>
        <fullName>ESC_Customer_portal_case_when_severity_is_Urgent_System_Down</fullName>
        <ccEmails>thomsonreuterscustomersupportelite@thomsonreuters.com</ccEmails>
        <description>ESC Customer portal case when severity is Urgent System Down</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportelite@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Elite/Elite_Customer_portal_Severity_Urgent_Auto_Acknowledgement</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_AU_Sales_Escalation_Group</fullName>
        <description>Email Alert to AU Sales Escalation Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Sales_Escalation</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>eloquaintegration.emails@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Sales_Templates/AU_Sales_Escalation_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_AU_Training_Group</fullName>
        <description>Email Alert to AU Training Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Training</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>eloquaintegration.emails@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Sales_Templates/ANZ_New_Inbound_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Bra_Corp_Licenciamento</fullName>
        <description>Email Alert to Bra.Corp.Licenciamento</description>
        <protected>false</protected>
        <recipients>
            <recipient>Bra_Corp_Licenciamento</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>care.anz.autogen@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Case_Creation_on_Oppty_Stage_update</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_NZ_Sales_Escalation_Group</fullName>
        <description>Email Alert to NZ Sales Escalation Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>NZ_Sales_Escalation</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>eloquaintegration.emails@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Sales_Templates/NZ_Sales_Escalation_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Queue_Email</fullName>
        <description>Email to Queue Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>GLI_Training_Email_Templates/Email_forCase_in_TrainingEventQueueVF</template>
    </alerts>
    <alerts>
        <fullName>GGO_CloseCaseSurvey_EmailAlert_with_link</fullName>
        <description>GGO_CloseCaseSurvey_EmailAlert with link</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportggo@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Service_Email/GGO_CloseCaseSurvey_Email</template>
    </alerts>
    <alerts>
        <fullName>GGO_CloseCaseSurvey_EmailAlert_without_link</fullName>
        <description>GGO_CloseCaseSurvey_EmailAlert without link</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportggo@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Service_Email/GGO_CloseCaseSurvey_Email_without_link</template>
    </alerts>
    <alerts>
        <fullName>GGO_Partner_CloseCaseSurvey_EmailAlert_without_link</fullName>
        <description>GGO_Partner_CloseCaseSurvey_EmailAlert without link</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportggo@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Service_Email/GGO_CloseCaseSurvey_Email_Partner</template>
    </alerts>
    <alerts>
        <fullName>GGO_Web2Case_ES_AutoResponse</fullName>
        <description>GGO Web2Case ES AutoResponse</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportggo@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Service_Email/GGO_Spanish_Case_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>GGO_Web2Case_pt_BR_AutoResponse</fullName>
        <description>GGO Web2Case pt BR AutoResponse</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupportggo@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Service_Email/GGO_Portuguese_Case_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>GLI_Web2Case_AutoResponse</fullName>
        <description>GLI Web2Case AutoResponse</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customersupportuki@tr.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLI_Service_Email_templates/GLI_Auto_Response_Customer_Support_Web2Case</template>
    </alerts>
    <alerts>
        <fullName>GLI_Web2Case_AutoResponse_Solcara</fullName>
        <description>GLI Web2Case AutoResponse_Solcara</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customersupportuki@tr.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLI_Service_Email_templates/Solcara_UKI_Support_Auto_Response_Web2Case</template>
    </alerts>
    <alerts>
        <fullName>GLI_Web2Case_AutoResponse_To_Rep</fullName>
        <description>GLI Web2Case AutoResponse To Rep_InternalWebForm</description>
        <protected>false</protected>
        <recipients>
            <field>ESC_UKI_WebForm_Rep_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customersupportuki@tr.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLI_Service_Email_templates/GLI_Auto_Response_Customer_Support_Web2Case</template>
    </alerts>
    <alerts>
        <fullName>GLI_Web2Case_ClosureMail_To_Rep_InternalWebForm</fullName>
        <description>GLI Web2Case ClosureMail To Rep_InternalWebForm</description>
        <protected>false</protected>
        <recipients>
            <field>ESC_UKI_WebForm_Rep_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customersupportuki@tr.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GLI_Service_Email_templates/Case_closure_Alert_Internal_Rep</template>
    </alerts>
    <alerts>
        <fullName>Grace_Period_Extn_Request</fullName>
        <description>Grace Period Extn Request</description>
        <protected>false</protected>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>everydaysupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LATAM_Mail/Grace_Period_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>LatAm_Grace_Period_Entitlement_Email_Alert</fullName>
        <description>LatAm Grace Period Entitlement Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Entitlement_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LATAM_Mail/Case_Grace_Period_Extn_Entitlement_Updt2</template>
    </alerts>
    <alerts>
        <fullName>NewCaseEmail</fullName>
        <description>NewCaseEmail</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Case_Management_Email_Templates/Case_Status_New_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notifying_Billing_Processor</fullName>
        <ccEmails>TREBillingContractsProcessing@thomsonreuters.com</ccEmails>
        <description>Billing processor needs to be notified that a client is ready for billing and mattering so that he knows to commence the billing and mattering process.</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Billing_Processor_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notifying_Training_Admin</fullName>
        <ccEmails>trainingrequest@tr.com</ccEmails>
        <description>Notifying Training Admin</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>GLI_Training_Email_Templates/Notification_to_Training_Admin</template>
    </alerts>
    <alerts>
        <fullName>RISK_UpdateOrderOnCaseClosed</fullName>
        <ccEmails>taxsapcustomerquotecreationservice@x-1rs3pm9z46ydmtl8y4q61ehuksrab61yf8h9y47kbwou5x0kmn.3-plslea2.na131.apex.salesforce.com</ccEmails>
        <description>RISK_UpdateOrderOnCaseClosed</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/RISK_UpdateOrderOnCaseClosed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_To_Opportunity_Owner</fullName>
        <description>Send Email To Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Grace_Period_Extension_Approval_English</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Opportunity_Owner_rejection</fullName>
        <description>Send Email to Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Grace_Period_Extension_Rejection</template>
    </alerts>
    <alerts>
        <fullName>USL_Case_Closed_Email_Alert</fullName>
        <description>USL Case Closed Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Close_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>USL_SCM_Acknowledgement</fullName>
        <description>This used to send auto response for SCM queue</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>USL_Service_Cloud_Internal_Templates/USL_Auto_Response_SCMSupport</template>
    </alerts>
    <alerts>
        <fullName>USL_TAM_Acknowledgement</fullName>
        <description>This used to send auto response for TAMM queue</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>thomsonreuterscustomersupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>USL_Service_Cloud_Internal_Templates/USL_Auto_Response_TAMSupport</template>
    </alerts>
    <alerts>
        <fullName>X24_Hours_after_case_opened</fullName>
        <description>24 Hours after case opened</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Case_Assignment</template>
    </alerts>
    <alerts>
        <fullName>X24_Hours_after_case_opened_Brazil</fullName>
        <description>24 Hours after case opened - Brazil</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SL_Help_Desk_Admin/Asignacion_de_caso</template>
    </alerts>
    <alerts>
        <fullName>X48_Hours_after_case_is_opened</fullName>
        <description>48 Hours after case is opened</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Case_Escalation</template>
    </alerts>
    <alerts>
        <fullName>X48_Hours_after_case_opened_Brazil</fullName>
        <description>48 Hours after case opened - Brazil</description>
        <protected>false</protected>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SL_Help_Desk_Admin/Asignacion_de_caso</template>
    </alerts>
    <alerts>
        <fullName>send_Email_to_Case_Owner_Manger</fullName>
        <description>send Email to Case Owner Manger</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Grace_Period_Extension_Status_Update</template>
    </alerts>
    <alerts>
        <fullName>send_Email_to_Case_Owner_Mgr_Partner</fullName>
        <description>send Email to Case Owner Manger Partner</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Reservation_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Grace_Period_Extension_Status_Upd_Prtnr</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_field_Update</fullName>
        <description>sub type will be approved</description>
        <field>ESC_Sub_Type__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_SAP_MDG_to_Datos_Clientes_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Datos_Clientes</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign SAP MDG to Datos Clientes Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_OP_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Order_Processing_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to OP Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CASE_Set_Priority_Medium_After_7_Day</fullName>
        <field>Priority</field>
        <literalValue>Medium</literalValue>
        <name>CASE - Set Priority - Medium After 7 Day</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPQ_Pricing_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>CPQ_Pricing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPQ Pricing Owner Update</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Acceptance_Delay_Update2</fullName>
        <field>USL_Case_Acceptance_Delay__c</field>
        <formula>( FLOOR( Now() - CreatedDate ) )*24 + ( FLOOR( MOD( (Now() - CreatedDate ) * 24, 24 ) ) )*60 + ( ROUND( MOD( (Now() - CreatedDate ) * 24 * 60, 60 ), 0 ) )</formula>
        <name>Case Acceptance Delay Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_RT_update_to_DQA_Request_Closed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DQA_Request_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case RT update to DQA Request Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_RT_update_to_DQA_Request_DQA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DQA_Request_DQA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case RT update to DQA Request-DQA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Record_Type_Update</fullName>
        <description>Update Record Type to Elite Closed CPQ Requests.</description>
        <field>RecordTypeId</field>
        <lookupValue>Elite_Closed_CPQ_Requests</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Set_closed_time_stamp</fullName>
        <field>Closed_Time_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Case - Set closed time stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Set_closed_time_stamp_to_blank</fullName>
        <description>Time stamp needs to be blank - as status in now in &quot;Not Closed&quot; category</description>
        <field>Closed_Time_Stamp__c</field>
        <name>Case - Set closed time stamp to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_owner_to_DQA_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>DQA_Request_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case owner to DQA Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Suspend_asset</fullName>
        <description>this field will help in changing asset status</description>
        <field>ESC_Suspend_Asset__c</field>
        <literalValue>1</literalValue>
        <name>Check Suspend asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Checked_IsAssigned_field</fullName>
        <field>LCRM_Is_Assigned__c</field>
        <literalValue>1</literalValue>
        <name>Checked IsAssigned  field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Accepted_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>Client_Accepted</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Client Accepted Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Negotiation_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>Contract_Negotiation</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Contract Negotiation Owner Update</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contracts_Clearing_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>Contracts_Clearing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Contracts Clearing Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESC_Set_Incident_Start_Time</fullName>
        <description>Defaults Incident Start Time to Date/Time Opened when a case gets created</description>
        <field>ESC_Incident_Start_Time__c</field>
        <formula>CreatedDate</formula>
        <name>ESC_Set Incident Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESC_Set_Preferred_Contact_is_Email</fullName>
        <field>ESC_Preferred_Contact_Method__c</field>
        <literalValue>Email</literalValue>
        <name>ESC_Set Preferred Contact is Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESC_Update_Resolution_Comment</fullName>
        <field>ESC_Resolution_Comment__c</field>
        <formula>&apos;No Action Taken&apos;</formula>
        <name>Update Resolution Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FiveDaysCheck_Field_Update</fullName>
        <description>This updates the field with system date/time when the workflow triggers.</description>
        <field>FiveDaysCheck__c</field>
        <formula>Now()</formula>
        <name>FiveDaysCheck Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Milestone_Referral_Flag</fullName>
        <field>GGO_Referral_Response_Time_Flag__c</field>
        <literalValue>0</literalValue>
        <name>GGO Milestone Referral Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_UpdatGGO_Updatee_IsEscalated_to_TRUE</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE1</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE30</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE31</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE32</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE33</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE34</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GGO_Update_IsEscalated_to_TRUE35</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>GGO Update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GLI_Unset_Resolution_time_Flag</fullName>
        <field>GLI_Resolution_Response_Time_Flag__c</field>
        <literalValue>0</literalValue>
        <name>GLI Unset Resolution time Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Modified_Field_Update</fullName>
        <description>Last Modified Date field is updated with current system date when workflow rule is evaluated.</description>
        <field>Last_Modified_Date__c</field>
        <formula>Now()</formula>
        <name>Last Modified Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NotifyPartnerUncheck</fullName>
        <field>ImpartnerPRM__NotifyPartner__c</field>
        <literalValue>0</literalValue>
        <name>Notify Partner Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_Name_and_Number</fullName>
        <field>Subject</field>
        <formula>Account.Name  &amp;&quot; &quot; &amp;  Account.SAPAccountNumber__c</formula>
        <name>Populate Account Name and Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_Flag30</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_Flag31</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_Flag32</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_Flag33</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_Flag34</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_Flag35</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReSet_Case_Acceptance_FlagUSL1</fullName>
        <field>ESC_Case_Acceptance_Flag__c</field>
        <literalValue>0</literalValue>
        <name>ReSet Case Acceptance Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recalled_Update_Approval_Status_to_Rec</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Recalled:Update Approval Status to Rec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recalled_Update_Status_to_Clo</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Recalled:Update Status to Clo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_field_update</fullName>
        <description>Sub type will be rejected</description>
        <field>ESC_Sub_Type__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Next_Response_Time_Flag_True</fullName>
        <description>On sucess of First reponse Time set Next Response Time Flag to True</description>
        <field>GLI_Resolution_Response_Time_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Set Next Response Time Flag True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subscription_Start_Date</fullName>
        <field>ESC_Subscription_Start_Date__c</field>
        <formula>IF(ISBLANK(ESC_Subscription_Start_Date__c),TODAY(),ESC_Subscription_Start_Date__c)</formula>
        <name>Subscription Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ThreeDaysCheck_Field_Update</fullName>
        <description>This updates the field with system date/time when the workflow triggers.</description>
        <field>ThreeDaysCheck__c</field>
        <formula>Now()</formula>
        <name>ThreeDaysCheck Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USL_Case_Acceptance_Delay_Update</fullName>
        <field>USL_Case_Acceptance_Delay__c</field>
        <formula>( FLOOR( Now() - CreatedDate ) )*24 + ( FLOOR( MOD( (Now() - CreatedDate ) * 24, 24 ) ) )*60 + ( ROUND( MOD( (Now() - CreatedDate ) * 24 * 60, 60 ), 0 ) )</formula>
        <name>Case Acceptance Delay Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Submit_for_autoApproval</fullName>
        <field>ESC_Submit_For_Auto_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Submit for auto Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Submit_for_auto_Approval</fullName>
        <field>ESC_Submit_For_Auto_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Submit for auto Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Submit_forauto_Approval</fullName>
        <field>ESC_Submit_For_Auto_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Submit for auto Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFlag</fullName>
        <field>ESC_Next_Response_Time_Flag__c</field>
        <literalValue>0</literalValue>
        <name>UpdateFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMilestoneType</fullName>
        <field>GGO_Referral_Milestone_Type__c</field>
        <name>UpdateMilestoneType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateReferralMilestoneCreateFlag</fullName>
        <field>GGO_Referral_Milestone_Entry_Flag__c</field>
        <literalValue>0</literalValue>
        <name>UpdateReferralMilestoneCreateFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSTatus</fullName>
        <field>Status</field>
        <literalValue>Work In Progress</literalValue>
        <name>UpdateSTatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Address_1</fullName>
        <field>LCRM_Address_1__c</field>
        <formula>Account.BillingStreet</formula>
        <name>Update Address 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Address_2</fullName>
        <field>LCRM_Address_2__c</field>
        <formula>Account.Street_Address_2__c</formula>
        <name>Update Address 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Pen</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending  Approval</literalValue>
        <name>Update Approval Status to Pen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Rej</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status to Rej</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_City</fullName>
        <field>LCRM_City__c</field>
        <formula>Account.BillingCity</formula>
        <name>Update City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country</fullName>
        <field>LCRM_Country__c</field>
        <formula>Account.BillingCountry</formula>
        <name>Update Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Extended_GP_Date</fullName>
        <field>Extended_Grace_Period_Date__c</field>
        <formula>Quote__r.Grace_Period_Days__c + 30</formula>
        <name>Update Extended GP Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_GLI_Milestone_Reference_Date</fullName>
        <field>GLI_Milestone_Reference_Date__c</field>
        <formula>NOW()</formula>
        <name>Update GLI Milestone Reference Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_GP_Date</fullName>
        <field>Grace_Period_Expiration_Date_Value__c</field>
        <formula>Quote__r.Grace_Period_Days__c</formula>
        <name>Update GP Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_Staus_Change_Flag</fullName>
        <field>GLI_Is_Status_Change__c</field>
        <literalValue>1</literalValue>
        <name>Update Is Staus Change Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postcode</fullName>
        <field>LCRM_Postcode_Zip__c</field>
        <formula>Account.BillingPostalCode</formula>
        <name>Update Postcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_to_FindLaw</fullName>
        <field>Product__c</field>
        <literalValue>FindLaw</literalValue>
        <name>Update Product to “FindLaw”</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_State</fullName>
        <field>LCRM_State__c</field>
        <formula>Account.BillingState</formula>
        <name>Update State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Active</fullName>
        <description>SRS # 3.2.6.2.1.	Update Status to Active (As per Celeste in 2/22 mtg.  )</description>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>Update Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Working</fullName>
        <field>Status</field>
        <literalValue>Work In Progress</literalValue>
        <name>Update Status to Working In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_UPD_flag</fullName>
        <field>ESC_UPD__c</field>
        <literalValue>0</literalValue>
        <name>Update UPD flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_sub_type_for_credit_check</fullName>
        <field>ESC_Sub_Type__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update sub type for credit check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Approval_Status_to_App</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>update Approval Status to App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_IsEscalated_to_TRUE</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>update IsEscalated to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>NotifyPartnerOutbound</fullName>
        <apiVersion>42.0</apiVersion>
        <endpointUrl>https://partners.partnerco.com/services/sfdc/CaseNotifyPartner.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>meenum.pillai@trpcorelegal.com</integrationUser>
        <name>Notify Partner Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ANZ-AU Training Case Email</fullName>
        <actions>
            <name>Email_Alert_to_AU_Training_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Owner:User.FirstName = &apos;AU Training&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Sales Escalation</fullName>
        <actions>
            <name>Email_Alert_to_AU_Sales_Escalation_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Alert to AU Sales Escalation Group</description>
        <formula>AND ( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Owner:Queue.DeveloperName = &apos;AU_Sales_Escalation&apos; ,OR(ISCHANGED( OwnerId ), ISNEW() ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Archive Closed Notification GLI</fullName>
        <actions>
            <name>Account_Archive_Closed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow notifies the user that created an Archive Request case that their case has been closed with the resulting action.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.DeveloperName  == &apos;GLI_Archive_Requests&apos; &amp;&amp;   IsClosed == TRUE &amp;&amp;   (TEXT(Type) == &apos;Activate Account&apos; || TEXT(Type) == &apos;Inactivate Account&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign SAP MDG to Datos Clientes Queue</fullName>
        <actions>
            <name>Assign_SAP_MDG_to_Datos_Clientes_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a case is set to status SAP MDG, this workflow changes the owner to the Datos Clientes queue.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,TEXT(Status) = &apos;SAP MDG&apos;, RecordType.Name &lt;&gt; &apos;LatAm&apos;, RecordType.Name &lt;&gt; &apos;Elite CPQ Requests&apos;, RecordType.Name &lt;&gt; &apos;Elite Closed CPQ Requests&apos;, Is_ESC_Case__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CASE - Set Priority to High After 7 Days</fullName>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,(ISPICKVAL(Priority , &quot;Medium&quot;) &amp;&amp; CreatedBy.Profile.Name = &quot;LatAm User&quot;) &amp;&amp; IsClosed = False &amp;&amp; RecordType.DeveloperName &lt;&gt; &apos;Site_Originated&apos; &amp;&amp; RecordType.DeveloperName &lt;&gt; &apos;Elite_CPQ_Requests&apos; &amp;&amp; RecordType.DeveloperName &lt;&gt; &apos;Elite_Closed_CPQ_Requests&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CASE - Set Priority to Medium After 7 Days</fullName>
        <active>true</active>
        <formula>$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False &amp;&amp; (ISPICKVAL(Priority , &quot;Low&quot;) &amp;&amp; OR(CreatedBy.Profile.Name = &quot;LatAm User&quot;,CreatedBy.Profile.Name = $Setup.GGO_Profiles__c.Profiles__c)) &amp;&amp; IsClosed = False &amp;&amp; RecordType.DeveloperName &lt;&gt; &apos;Site_Originated&apos; &amp;&amp; RecordType.DeveloperName &lt;&gt; &apos;Elite_CPQ_Requests&apos; &amp;&amp; RecordType.DeveloperName &lt;&gt; &apos;Elite_Closed_CPQ_Requests&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CASE_Set_Priority_Medium_After_7_Day</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CPQ Pricing Update</fullName>
        <actions>
            <name>CPQ_Pricing_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Sales Rep/CPQ User updates Status field on Case to ‘CPQ Pricing’, assign Case to CPQ Pricing queue.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.Name = &apos;Elite CPQ Requests&apos;,Text(Status) = &apos;CPQ Pricing&apos;, Is_GLI__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPQ Request Close Update</fullName>
        <actions>
            <name>Notifying_Billing_Processor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Case is Closed, update Record Type to Elite Closed CPQ Requests and Billing processor needs to be notified that a client is ready for billing and mattering so that he knows to commence the billing and mattering process.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.Name = &apos;Elite CPQ Requests&apos;,TEXT(Status) = &apos;Closed&apos;, Is_GLI__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Assignment to DQA Queue</fullName>
        <actions>
            <name>Case_owner_to_DQA_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,OR( RecordType.DeveloperName = &apos;DQA_Request&apos;, RecordType.DeveloperName = &apos;GLI_Archive_Requests&apos; ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation on Opportunity Stage update</fullName>
        <actions>
            <name>Email_Alert_to_Bra_Corp_Licenciamento</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sending Email alert on Case creation after oppty reaches 95 %</description>
        <formula>AND(  ISPICKVAL(ANZ_Issue__c ,&apos;Entitlement&apos;) , Owner:Queue.DeveloperName = &apos;Bra_Corp_Licenciamento&apos; , ISPICKVAL( Sales_Org__c , &apos;TSL&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Pending 5 Or More Days</fullName>
        <actions>
            <name>CasePendingForMoreThan5Days</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>FiveDaysCheck_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>A mail is to be sent every 5 days, if case status is not equal to On Hold, Plazo Vencido (Escalated), Abierto (Open), Nuevo (New), or Cerrado (Closed)&apos;, and there has been no activity on it for 5 or more  business days.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Five_Days_Pending_Case__c  &gt;= 5, NOT(ISPICKVAL( Status , &quot;On Hold&quot;)),NOT(ISPICKVAL( Status , &quot;Escalated&quot;)),NOT(ISPICKVAL( Status , &quot;Open&quot;)),NOT(ISPICKVAL( Status , &quot;New&quot;)),NOT(ISPICKVAL( Status , &quot;Closed&quot;)),IF(ISNULL(FiveDaysCheck__c),TRUE, (( NOW() - FiveDaysCheck__c) &gt;=5)),  RecordType.DeveloperName  = &quot;Site_Originated&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case RT update to DQA Request Closed</fullName>
        <actions>
            <name>DQA_Request_Closed_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_RT_update_to_DQA_Request_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,CONTAINS(RecordTypeId, $Setup.FieldId__c.DQA_Request_DQA_Case__c), ISCHANGED(Status), TEXT(Status) == &apos;Closed&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case RT update to DQA Request-DQA</fullName>
        <actions>
            <name>Case_RT_update_to_DQA_Request_DQA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,CONTAINS(RecordTypeId, $Setup.FieldId__c.DQA_Request_Case__c), ISCHANGED(OwnerId), CONTAINS(PRIORVALUE( OwnerId ), $Setup.FieldId__c.DQARequestQueueId__c), CONTAINS(OwnerId, $User.Id), $Profile.Name = &apos;DQA User&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Escalated Pending 5 Days</fullName>
        <actions>
            <name>CaseStatusEscalatedPending5Days</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>FiveDaysCheck_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>A mail is to be sent every 5 days, if case status equals &apos;Escalated&apos;, and there has been no activity on it for 5 business days.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,(MOD( Five_Days_Pending_Case_Escl__c ,5) = 0),ISPICKVAL( Status , &quot;Escalated&quot;), IF(Five_Days_Pending_Case_Escl__c =0, FALSE, TRUE),IF(FiveDaysCheck__c &lt;&gt;null,(( NOW() - FiveDaysCheck__c) &gt;= 5),TRUE),RecordType.DeveloperName  = &quot;Site_Originated&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Status On Hold Pending 3 Days</fullName>
        <actions>
            <name>CaseStatusOnHoldPending3Days</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ThreeDaysCheck_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>A mail is to be sent every 3 days, if case status equals &apos;On Hold&apos;, and there has been no activity on it for 3 business days.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,(MOD(Three_Days_Pending_Case__c,3) = 0), ISPICKVAL( Status , &quot;On Hold&quot;),IF(Three_Days_Pending_Case__c = 0, FALSE, TRUE),IF(ThreeDaysCheck__c &lt;&gt;null,(( NOW()  -  ThreeDaysCheck__c ) &gt;= 3),TRUE),RecordType.DeveloperName  = &quot;Site_Originated&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status changed from Closed to Other</fullName>
        <actions>
            <name>Case_Set_closed_time_stamp_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>7 statuses that are considered as &quot;Closed&quot; category -
Cancelled,Completed,Delivered,Duplicate,Released,Resolved,Closed
status changes from &quot;Closed&quot; category to &quot;Not Closed&quot; category- Time stamp needs to be removed.</description>
        <formula>AND ( IsChanged(Status),  OR( isPickVal(PRIORVALUE(Status),&quot;Completed&quot;), isPickVal(PRIORVALUE(Status),&quot;Cancelled&quot;), isPickVal(PRIORVALUE(Status),&quot;Closed&quot;), isPickVal(PRIORVALUE(Status),&quot;Delivered&quot;), isPickVal(PRIORVALUE(Status),&quot;Released&quot;), isPickVal(PRIORVALUE(Status),&quot;Resolved&quot;), isPickVal(PRIORVALUE(Status),&quot;Duplicate&quot;) ),  NOT(OR( isPickVal(Status,&quot;Completed&quot;), isPickVal(Status,&quot;Cancelled&quot;), isPickVal(Status,&quot;Closed&quot;), isPickVal(Status,&quot;Delivered&quot;), isPickVal(Status,&quot;Released&quot;), isPickVal(Status,&quot;Resolved&quot;), isPickVal(Status,&quot;Duplicate&quot;) )) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status changed to close</fullName>
        <actions>
            <name>Case_Set_closed_time_stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>7 statuses that are considered as &quot;Closed&quot; category -
status changes from &quot;Not Closed&quot; category to &quot;Closed&quot; category- Time stamp needs to be put.
status changes from &quot;Closed&quot; category to &quot;Closed&quot; category - no need to change time stamp</description>
        <formula>AND ( IsChanged(Status),  NOT(OR( isPickVal(PRIORVALUE(Status),&quot;Completed&quot;), isPickVal(PRIORVALUE(Status),&quot;Cancelled&quot;), isPickVal(PRIORVALUE(Status),&quot;Closed&quot;), isPickVal(PRIORVALUE(Status),&quot;Delivered&quot;), isPickVal(PRIORVALUE(Status),&quot;Released&quot;), isPickVal(PRIORVALUE(Status),&quot;Resolved&quot;), isPickVal(PRIORVALUE(Status),&quot;Duplicate&quot;) )),  OR( isPickVal(Status,&quot;Completed&quot;), isPickVal(Status,&quot;Cancelled&quot;), isPickVal(Status,&quot;Closed&quot;), isPickVal(Status,&quot;Delivered&quot;), isPickVal(Status,&quot;Released&quot;), isPickVal(Status,&quot;Resolved&quot;), isPickVal(Status,&quot;Duplicate&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Client Accepted Update</fullName>
        <actions>
            <name>Client_Accepted_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Sales Rep/CPQ User  updates Status field on Case to ‘Client Accepted’, assign Case to Client Accepted queue.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.Name = &apos;Elite CPQ Requests&apos;, TEXT(Status) = &apos;Client Accepted&apos;, Is_GLI__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Inactivate Closed Notification GLI</fullName>
        <actions>
            <name>Contact_Inactivate_Closed_NotificationVF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow notifies the user that created an Inactivate contact Request case that their case has been closed with the resulting action.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.DeveloperName  == &apos;GLI_Archive_Requests&apos; &amp;&amp;   IsClosed == TRUE &amp;&amp;   (TEXT(Type) == &apos;Activate Contact&apos; || TEXT(Type) == &apos;Inactivate Contact&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Negotiation Update</fullName>
        <actions>
            <name>Contract_Negotiation_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Sales Rep/CPQ User updates Status field on Case to ‘Contract Negotiation’, assign Case to Contract Negotiation queue</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.Name = &apos;Elite CPQ Requests&apos;, TEXT(Status) = &apos;Contract Negotiation&apos;, Is_GLI__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contracts Clearing Update</fullName>
        <actions>
            <name>Contracts_Clearing_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Sales Rep/CPQ User  updates Status field on Case to ‘Contracts Clearing’, assign Case to Contracts Clearing queue.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,RecordType.Name = &apos;Elite CPQ Requests&apos;, TEXT(Status) = &apos;Contracts Clearing&apos;, Is_GLI__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DQA Request Closed notification to Case Owner</fullName>
        <actions>
            <name>DQA_Request_Closed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Case Creator on case closure</description>
        <formula>$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False &amp;&amp; RecordType.DeveloperName == &apos;DQA_Request_Closed&apos; &amp;&amp; IsClosed == TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESC Update credit check status</fullName>
        <active>true</active>
        <formula>AND( NOT($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Process_Builders__c), TEXT( Origin )= &apos;Credit Check&apos; , TEXT(ESC_Sub_Type__c) &lt;&gt;  &apos;Approved&apos;, TEXT(ESC_Sub_Type__c) &lt;&gt;  &apos;Rejected&apos;, TEXT(ESC_Case_Type__c) = &apos;Request for Action&apos; ,  BU_Segment__c = $Setup.ESC_segment_Region_Lotus__c.SegmentTax__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ESC_Update_Resolution_Comment</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Status_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_sub_type_for_credit_check</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.GLI_Milestone_Reference_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ESC_Initial Email to Case set</fullName>
        <actions>
            <name>ESC_Set_Incident_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ESC_Set_Preferred_Contact_is_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Is_ESC_Case__c = true, OR(Ispickval(Origin,&quot;Email&quot;), Ispickval(Origin,&quot;Web&quot;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GLI Training Event Case Creation</fullName>
        <actions>
            <name>Notifying_Training_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Whenever a GLI Training Event Case is created, it has to assigned to GLI Training Users queue and an email notification needs to be sent to Training Admin.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Is_GLI__c = true, RecordType.Name = &apos;GLI Training Event Request&apos;, Owner:Queue.QueueName = &apos;GLI Training Event Requests&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LCRM Case Assign to GLI Training Event Queue</fullName>
        <actions>
            <name>Email_to_Queue_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False &amp;&amp; RecordType.DeveloperName = &apos;GLI_Training_Event_Request&apos;  &amp;&amp;    Owner:Queue.DeveloperName = &apos;GLI_USL_Training_Events&apos; &amp;&amp; ISCHANGED(OwnerId) &amp;&amp;  OR( UPPER(LCRM_Country__c) =&apos;US&apos;, UPPER(LCRM_Country__c) =&apos;USA&apos;, UPPER(LCRM_Country__c) =&apos;UNITED STATES&apos;, UPPER(LCRM_Country__c) =&apos;UNITED STATES OF AMERICA&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LCRM Checked IsAsssigned when case claimed from Queue</fullName>
        <actions>
            <name>Checked_IsAssigned_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False &amp;&amp; RecordType.DeveloperName = &apos;GLI_Training_Event_Request&apos; &amp;&amp; BEGINS(PRIORVALUE( OwnerId ), &apos;00G&apos;) &amp;&amp; BEGINS( OwnerId , &apos;005&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last Modified Date Update</fullName>
        <actions>
            <name>Last_Modified_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow sets the last modified date value on &apos;Last_Modified_Date__c&apos; field.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,OR(RecordType.DeveloperName  = &quot;ANZ&quot;,RecordType.DeveloperName  = &quot;Site_Originated&quot;) , OR(ISCHANGED( Status ), ISCHANGED( OwnerId ),ISCHANGED( Follow_Up_Date__c ), ISCHANGED( Special_Event__c ), ISCHANGED( Value_Retained__c ), ISCHANGED( Rejected_Reason__c ), ISCHANGED( Escalation_Level_Number__c ), ISCHANGED( Due_DateTime__c ), ISCHANGED( AccountId ), ISCHANGED( Opportunity__c ), ISCHANGED( Quote__c ), ISCHANGED( WPD_Type__c ), ISCHANGED( Value__c ), ISCHANGED( Appointment_Date__c ), ISCHANGED( Approval_Status__c ), ISCHANGED( Description ), ISCHANGED( Reason ), ISCHANGED( CaseType__c ) , ISCHANGED( ANZ_Issue__c ), ISCHANGED( Reason__c ) , ISCHANGED( Reason_Detail__c ) , ISCHANGED( Sales_Org__c ), ISCHANGED( Type ), ISCHANGED( Subject ), ISCHANGED( CreatedDate ), ISCHANGED( ClosedDate ), ISCHANGED( Origin ),  ISCHANGED( ContactId ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LatAm Case Assignment Notification</fullName>
        <actions>
            <name>Change_Owner_of_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a LatAm user changes the Case Owner to another LatAm User the new LatAm user should get an e-mail saying a Case has been assigned</description>
        <formula>$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False &amp;&amp; Owner:User.Profile.Name = &quot;LatAm User&quot; &amp;&amp; OwnerId &lt;&gt; $User.Id &amp;&amp; RecordType.DeveloperName  &lt;&gt;  &apos;Site_Originated&apos; &amp;&amp; RecordType.DeveloperName  &lt;&gt;  &apos;Elite_CPQ_Requests&apos; &amp;&amp; RecordType.DeveloperName  &lt;&gt;  &apos;Elite_Closed_CPQ_Requests&apos;  &amp;&amp;  Is_ESC_Case__c  = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NZ Sales Escalation</fullName>
        <actions>
            <name>Email_Alert_to_NZ_Sales_Escalation_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Alert to NZ Sales Escalation</description>
        <formula>AND ( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Owner:Queue.DeveloperName = &apos;NZ_Sales_Escalation&apos; ,OR(ISCHANGED( OwnerId ), ISNEW() ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Partner</fullName>
        <actions>
            <name>NotifyPartnerUncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NotifyPartnerOutbound</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>(ImpartnerPRM__NotifyPartner__c == true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate FindLaw Sales Org and Product</fullName>
        <actions>
            <name>Populate_Account_Name_and_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Product_to_FindLaw</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c), $Profile.Name  = &apos;TR Legal FindLaw User&apos;, OR( RecordType.Name &lt;&gt; &apos;Findlaw Inquiry&apos;, RecordType.Name &lt;&gt; &apos;LatAm&apos; ), RecordType.Name &lt;&gt; &apos;Elite CPQ Requests&apos;, RecordType.Name &lt;&gt; &apos;Elite Closed CPQ Requests&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Training Event Case Address</fullName>
        <actions>
            <name>Update_Address_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Address_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postcode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_State</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The address should be populated with the address of the associated account.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Is_GLI__c = True , RecordType.Name = &apos;GLI Training Event Request&apos;, NOT(ISBLANK(Account.Name)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>USLAccountArchive</fullName>
        <actions>
            <name>AccountArchive</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Upon creation of a case in the US Legal Account Archive queue – an email shall be sent to a Legal Data team mailbox (MDB_Team@thomson.com) with a link directly to the case.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,  Owner:Queue.DeveloperName = &apos;USL Account Archive Queue&apos;, RecordType.Name &lt;&gt; &apos;LatAm&apos;, RecordType.Name &lt;&gt; &apos;Elite CPQ Requests&apos;, RecordType.Name &lt;&gt; &apos;Elite Closed CPQ Requests&apos;, Is_ESC_Case__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Grace Period Days</fullName>
        <actions>
            <name>Update_Extended_GP_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_GP_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISNULL(Quote__c) &amp;&amp; !ISNULL(Quote__r.Grace_Period_Days__c) &amp;&amp; ISPICKVAL(Reason__c, &apos;Grace Period Extension&apos;) &amp;&amp; RecordType.DeveloperName  &lt;&gt;  &apos;Site_Originated&apos; &amp;&amp; RecordType.DeveloperName  &lt;&gt;  &apos;Elite_CPQ_Requests&apos; &amp;&amp; RecordType.DeveloperName  &lt;&gt;  &apos;Elite_Closed_CPQ_Requests&apos;  &amp;&amp;  Is_ESC_Case__c  = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Order for Risk BUs</fullName>
        <actions>
            <name>RISK_UpdateOrderOnCaseClosed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Created this for DOC-12443</description>
        <formula>AND( Is_ESC_Case__c = true, IsClosed = true, ISPICKVAL( Origin,&apos;Case&apos;),OR(TEXT(ESC_Product_Segment_Brand__c) = &apos;Risk&apos;,ESC_Unique_Identifier__c = &apos;Acritas-Billing&apos;,ESC_Unique_Identifier__c = &apos;Caselines-Billing&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
