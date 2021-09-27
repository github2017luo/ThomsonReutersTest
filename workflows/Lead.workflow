<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Notification</fullName>
        <description>Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Lead_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_AU_Eloqua_Sales_Manager_Group</fullName>
        <description>Email Alert to AU Eloqua Sales Manager Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>eloquaintegration.emails@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>ANZ_Sales_Templates/ANZ_New_Inbound_Lead</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_AU_Sales_Manager_Group</fullName>
        <description>Email Alert to AU Sales Manager Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ANZ_Sales_Templates/ANZ_New_Inbound_Lead</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_AU_Sales_Manager_Group</fullName>
        <ccEmails>Anthony.Robjohns@Thomsonreuters.com</ccEmails>
        <description>Email Notification to AU Sales Manager Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Inbound_lead</template>
    </alerts>
    <alerts>
        <fullName>FollowUp_email_notification_to_AU_Sales_Manager_Group</fullName>
        <ccEmails>Anthony.Robjohns@Thomsonreuters.com</ccEmails>
        <description>FollowUp email notification to AU Sales Manager Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>AU_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Follow_Up_on_Inbound_Lead</template>
    </alerts>
    <alerts>
        <fullName>New_Lead_Email_Notification_based_on_Sub_bu</fullName>
        <description>New Lead Assignment Email Notification based on Sub-bu</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Leads_New_assignment_notificationVF</template>
    </alerts>
    <alerts>
        <fullName>Order_confirmation_email_alert</fullName>
        <description>Order confirmation email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>tr.sales@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/New_Customer_Order_Confirmation_VF</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification</fullName>
        <description>Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Lead_Rejected_Email</template>
    </alerts>
    <alerts>
        <fullName>TRStore_Deloitte_Email_to_Microsite</fullName>
        <ccEmails>trstoremocrositeordersresponse@6-11zp1ly1mq65a3g183pehzjdr4pi3bflsvq5o83uagycys26r9.3-plslea2.na131.apex.salesforce.com</ccEmails>
        <ccEmails>jguthrie@deloitte.ca</ccEmails>
        <ccEmails>kisackson@deloitte.ca</ccEmails>
        <description>TRStore Deloitte Email to Microsite</description>
        <protected>false</protected>
        <recipients>
            <recipient>TRStore_Deloitte_Microsite_Users</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/TR_Store_Lead_Microsite_Approval_email</template>
    </alerts>
    <alerts>
        <fullName>TRStore_Email_to_Microsite</fullName>
        <description>TRStore Email to Microsite</description>
        <protected>false</protected>
        <recipients>
            <recipient>TRStore_PWC_Deloitte_Microsite_Users</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/TR_Store_Lead_Microsite_Approval_email</template>
    </alerts>
    <alerts>
        <fullName>TRStore_Order_Confirmation_Email_to_TriForm_Group</fullName>
        <description>TRStore Order Confirmation Email to TriForm Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>TRStore_Microsite_TriForm_Users</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/TR_Store_Lead_Microsite_Approval_email</template>
    </alerts>
    <alerts>
        <fullName>TRStore_PWC_Email_to_Microsite</fullName>
        <ccEmails>bettina.u.krebs@pwc.com</ccEmails>
        <ccEmails>kathryn.e.kingston@pwc.com</ccEmails>
        <ccEmails>trstoremocrositeordersresponse@6-11zp1ly1mq65a3g183pehzjdr4pi3bflsvq5o83uagycys26r9.3-plslea2.na131.apex.salesforce.com</ccEmails>
        <description>TRStore PWC Email to Microsite</description>
        <protected>false</protected>
        <recipients>
            <recipient>TRStore_PWC_Microsite_Users</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/TR_Store_Lead_Microsite_Approval_email</template>
    </alerts>
    <fieldUpdates>
        <fullName>ANZ_ACAD</fullName>
        <field>Industry</field>
        <literalValue>ED Academic Teacher</literalValue>
        <name>ANZ-ACAD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_ACCOUNTING</fullName>
        <field>Industry</field>
        <literalValue>AC ACCOUNTING</literalValue>
        <name>ANZ-ACCOUNTING</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_BARRISTER</fullName>
        <field>Industry</field>
        <literalValue>LE Barristers &amp; QCs</literalValue>
        <name>ANZ-BARRISTER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_COURT</fullName>
        <field>Industry</field>
        <literalValue>CT Court Federal</literalValue>
        <name>ANZ-COURT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_FED_GOVT</fullName>
        <field>Industry</field>
        <literalValue>GV Government Fed</literalValue>
        <name>ANZ-FED GOVT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_FIRM</fullName>
        <field>Industry</field>
        <literalValue>LE Legal</literalValue>
        <name>ANZ-FIRM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_IN_HOUSE</fullName>
        <field>Industry</field>
        <literalValue>TR Intercompany</literalValue>
        <name>ANZ IN HOUSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_LEAD_CORP</fullName>
        <field>Industry</field>
        <literalValue>BU Architects, Town</literalValue>
        <name>ANZ_LEAD_CORP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_LEAD_GOVT</fullName>
        <field>Industry</field>
        <literalValue>GV Government Local</literalValue>
        <name>ANZ_LEAD_GOVT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_NON_PROFIT</fullName>
        <field>Industry</field>
        <literalValue>AS CHARITY/NONPROFIT</literalValue>
        <name>ANZ NON PROFIT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_PRIVATE</fullName>
        <field>Industry</field>
        <literalValue>PRV-CONSUMER</literalValue>
        <name>ANZ-PRIVATE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_RESELLER</fullName>
        <field>Industry</field>
        <literalValue>TR Library Suppliers</literalValue>
        <name>ANZ-RESELLER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_STUDENT</fullName>
        <field>Industry</field>
        <literalValue>ED Student</literalValue>
        <name>ANZ-STUDENT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_TERTIARY_INSTITUTION</fullName>
        <field>Industry</field>
        <literalValue>ED Tertiary Inst</literalValue>
        <name>ANZ TERTIARY INSTITUTION</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ANZ_TRADE_HOUSE</fullName>
        <field>Industry</field>
        <literalValue>TR Campus Bookshops</literalValue>
        <name>ANZ-TRADE HOUSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Action_to_Save_Prior_Lead_Score</fullName>
        <description>WF Action to save previous value of Lead Score</description>
        <field>Prior_Lead_Score__c</field>
        <formula>PRIORVALUE( Lead_Scoring_Combined__c )</formula>
        <name>Action to Save Prior Lead Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update</fullName>
        <description>Approval Status field update for Latam Partner Portal Mastersaf approval process</description>
        <field>Approval_status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Latam</fullName>
        <description>Approval Status field update for Latam Partner Portal Mastersaf approval process</description>
        <field>Approval_status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Rejected</fullName>
        <field>Approval_status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Field Update-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Rejected_LM</fullName>
        <field>Approval_status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Field Update-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assigned_to_Partner_Modified</fullName>
        <field>ImpartnerPRM__PartnerLastModifiedDate__c</field>
        <name>Assigned to Partner Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assigned_to_Partner_Pending</fullName>
        <field>ImpartnerPRM__PartnerLeadAcceptance__c</field>
        <literalValue>Pending</literalValue>
        <name>Assigned to Partner Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assigned_to_Partner_Timestamp</fullName>
        <field>ImpartnerPRM__DateAssignedToPartner__c</field>
        <formula>NOW()</formula>
        <name>Assigned to Partner Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_City</fullName>
        <field>Billing_City__c</field>
        <formula>City</formula>
        <name>Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_Country</fullName>
        <field>Billing_Country__c</field>
        <formula>CASE(Country, &apos;United States&apos;, &apos;US&apos;, &apos;Australia&apos;, &apos;AU&apos;,&apos;South Africa&apos;, &apos;ZA&apos;, &apos;Singapore&apos; , &apos;SG&apos;,&apos;New Zealand&apos;, &apos;NZ&apos;, 
&apos;Ireland&apos;, &apos;IE&apos;, 
&apos;India&apos;, &apos;IN&apos;, 
&apos;Canada&apos;, &apos;CA&apos;, 
&apos;Brazil&apos;, &apos;BR&apos;, 
&apos;United Kingdom&apos;, &apos;GB&apos;
,Country)</formula>
        <name>Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_State</fullName>
        <field>Billing_State__c</field>
        <formula>State</formula>
        <name>Billing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_Street</fullName>
        <field>Billing_Street__c</field>
        <formula>Street</formula>
        <name>Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billing_Zip</fullName>
        <field>Billing_Zip__c</field>
        <formula>PostalCode</formula>
        <name>Billing Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Registration_Denied_Update</fullName>
        <field>ImpartnerPRM__DealRegistrationDenied__c</field>
        <literalValue>1</literalValue>
        <name>Deal Registration Denied Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Lead_activation_as_GLI</fullName>
        <description>Created as part of OOB lead creation for LOTUS users to default record type to GLI, DPS-12433</description>
        <field>RecordTypeId</field>
        <lookupValue>GLI</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>LCRM Lead activation as GLI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Lead_City_with_Account</fullName>
        <description>DPS-12740</description>
        <field>City</field>
        <formula>Account__r.BillingCity</formula>
        <name>LOTUS Update Lead City with Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Lead_Country_with_Account</fullName>
        <description>DPS-12740</description>
        <field>Country</field>
        <formula>Account__r.BillingCountry</formula>
        <name>LOTUS Update Lead Country with Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Lead_State_with_Account</fullName>
        <description>DPS-12740</description>
        <field>State</field>
        <formula>Account__r.BillingState</formula>
        <name>LOTUS Update Lead State with Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Lead_Street_with_Account</fullName>
        <description>DPS-12740</description>
        <field>Street</field>
        <formula>Account__r.BillingStreet</formula>
        <name>LOTUS Update Lead Street with Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Lead_ZipCode_with_Account</fullName>
        <description>DPS-12740</description>
        <field>PostalCode</field>
        <formula>Account__r.BillingPostalCode</formula>
        <name>LOTUS Update Lead Zip Code with Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LatAmUpdate_Approval_Status_to_NotSub</fullName>
        <description>DPS-19040 - Update Approval Status to Not Submitted once it is recalled from approval</description>
        <field>Approval_status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>LatAmUpdate Approval Status to NotSub</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LatAmUpdate_Approval_Status_to_Submitted</fullName>
        <description>DPS-19040 - Update Approval Status to Submitted once it is submit for Approval</description>
        <field>Approval_status__c</field>
        <literalValue>Submitted</literalValue>
        <name>LatAmUpdate Approval Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LatAm_Lead_Status_Discarded</fullName>
        <field>Status</field>
        <literalValue>Discarded</literalValue>
        <name>LatAm_Lead_Status_Discarded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_City_copy_standard_to_custom</fullName>
        <field>Billing_City__c</field>
        <formula>City</formula>
        <name>Lead City copy - standard to custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conversion_Lead_Stage</fullName>
        <description>Lead Stage field will update to SAL when Lead Status field has been updated to &quot;Converted&quot;</description>
        <field>Lead_Stage__c</field>
        <literalValue>Sales Qualified Lead (SQL)</literalValue>
        <name>Lead Conversion - Lead Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Country_copy_standard_to_custom</fullName>
        <field>Billing_Country__c</field>
        <formula>TEXT(CountryCode)</formula>
        <name>Lead Country copy - standard to custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Stage_update_SAL</fullName>
        <field>Lead_Stage__c</field>
        <literalValue>Sales Accepted Lead (SAL)</literalValue>
        <name>Lead_Stage_update_SAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_State_copy_standard_to_custom</fullName>
        <field>Billing_State__c</field>
        <formula>TEXT(StateCode)</formula>
        <name>Lead State copy - standard to custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Street_copy_standard_to_custom</fullName>
        <field>Billing_Street__c</field>
        <formula>Street</formula>
        <name>Lead Street copy - standard to custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Zip_copy_standard_to_custom</fullName>
        <field>Billing_Zip__c</field>
        <formula>PostalCode</formula>
        <name>Lead Zip copy - standard to custom</name>
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
        <fullName>Set_Timer_Active_field_to_False</fullName>
        <field>Timer_Active__c</field>
        <literalValue>0</literalValue>
        <name>Set Timer Active field to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Timer_Active_field_to_True</fullName>
        <field>Timer_Active__c</field>
        <literalValue>1</literalValue>
        <name>Set Timer Active field to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLeadStatus</fullName>
        <field>Status</field>
        <literalValue>Unworked</literalValue>
        <name>Update Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_on_Lead</fullName>
        <description>Update Email on Lead with Contact Email</description>
        <field>Email</field>
        <formula>BLANKVALUE( Email , IF( ISNULL(Contact__r.SAP_Email_1__c) || ISBLANK(Contact__r.SAP_Email_1__c) , 

IF(ISNULL(Contact__r.Email)||ISBLANK(Contact__r.Email), Contact__r.WLEC_Email_Address_1__c ,Contact__r.Email),

Contact__r.SAP_Email_1__c))</formula>
        <name>Update Email on Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_Web_to_lead_Field</fullName>
        <description>Checks Is Web to Lead when lead created in Web to Lead</description>
        <field>Is_Web_To_Lead__c</field>
        <literalValue>1</literalValue>
        <name>Update Is Web to lead Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LAtam_Created_By_Partner</fullName>
        <field>LatAm_Created_by_Partner__c</field>
        <literalValue>1</literalValue>
        <name>Update LAtam Created By Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Billing_City</fullName>
        <description>Update_Lead_Billing_City</description>
        <field>Billing_City__c</field>
        <formula>Account__r.BillingCity</formula>
        <name>Update Lead Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Billing_Country</fullName>
        <description>Update_Lead_Billing_Country</description>
        <field>Billing_Country__c</field>
        <formula>Account__r.BillingCountry</formula>
        <name>Update Lead Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Billing_State</fullName>
        <description>Update_Lead_Billing_State</description>
        <field>Billing_State__c</field>
        <formula>Account__r.BillingState</formula>
        <name>Update Lead Billing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Billing_Street</fullName>
        <description>Update_Lead_Billing_Street</description>
        <field>Billing_Street__c</field>
        <formula>Account__r.BillingStreet</formula>
        <name>Update Lead Billing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Billing_Zip</fullName>
        <description>Update_Lead_Billing_Zip</description>
        <field>Billing_Zip__c</field>
        <formula>Account__r.BillingPostalCode</formula>
        <name>Update Lead Billing Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Company</fullName>
        <description>Update_Lead_Company</description>
        <field>Company</field>
        <formula>Account__r.Name</formula>
        <name>Update Lead Company</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_County</fullName>
        <description>Update_Lead_County</description>
        <field>County__c</field>
        <formula>Account__r.County__c</formula>
        <name>Update Lead County</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_PO_Box</fullName>
        <description>Update PO Box on Lead with Account PO Box...</description>
        <field>PO_Box__c</field>
        <formula>Account__r.PO_Box__c</formula>
        <name>Update Lead PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Stage_to_TeleQualified</fullName>
        <description>Update Lead Stage to TeleQualified</description>
        <field>Lead_Stage__c</field>
        <literalValue>Tele Qualified</literalValue>
        <name>Update Lead Stage to TeleQualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_URL</fullName>
        <field>URL__c</field>
        <formula>Account__r.URL_2_1__c</formula>
        <name>Update Lead URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Website</fullName>
        <description>Update_Lead_Website</description>
        <field>Website</field>
        <formula>Account__r.Website</formula>
        <name>Update Lead Website</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tax_Number</fullName>
        <field>Tax_Number__c</field>
        <formula>Account__r.Tax_Number__c</formula>
        <name>Update Tax Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Title_on_Lead</fullName>
        <field>Title</field>
        <formula>Contact__r.Title</formula>
        <name>Update Title on Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_ACADEMIC</fullName>
        <field>Industry</field>
        <literalValue>ACAD-OTHER SCHOOL</literalValue>
        <name>WEST_ACADEMIC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_CORP</fullName>
        <field>Industry</field>
        <literalValue>CORP-OTHER</literalValue>
        <name>WEST-CORP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_FIRM</fullName>
        <field>Industry</field>
        <literalValue>FIRM-LAW SMALL</literalValue>
        <name>WEST_FIRM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_LEAD_FED_GOVT</fullName>
        <field>Industry</field>
        <literalValue>FG-OTHER</literalValue>
        <name>WEST_LEAD_FED_GOVT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_LEAD_GOVT</fullName>
        <field>Industry</field>
        <literalValue>GVT-LEGAL</literalValue>
        <name>WEST_LEAD_GOVT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_PRIVATE</fullName>
        <field>Industry</field>
        <literalValue>PRV-CONSUMER</literalValue>
        <name>WEST_PRIVATE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WEST_RESELLER</fullName>
        <field>Industry</field>
        <literalValue>RS-DISTRIBUTOR INTL</literalValue>
        <name>WEST_RESELLER</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Deal_Registration_Denied</fullName>
        <apiVersion>45.0</apiVersion>
        <endpointUrl>https://partnerportal.thomsonreuters.com/services/sfdc/DealRegistrationDenied.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>meenum.pillai@trpcorelegal.com</integrationUser>
        <name>Deal Registration Denied</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>NotifyPartnerOutbound</fullName>
        <apiVersion>42.0</apiVersion>
        <endpointUrl>https://partnerportal.thomsonreuters.com/services/sfdc/LeadNotifyPartner.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>meenum.pillai@trpcorelegal.com</integrationUser>
        <name>Notify Partner Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ANZ Manager Eloqua Lead Email</fullName>
        <actions>
            <name>Email_Alert_to_AU_Eloqua_Sales_Manager_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False, OR( Lead_Owner_Profile_Name__c = &apos;ANZ Eloqua&apos;,  ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c , &apos;LRA&apos;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ANZ Manager Lead Email</fullName>
        <actions>
            <name>Email_Alert_to_AU_Sales_Manager_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = FALSE,OwnerId=&apos;ANZ Sales Leads&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assigned to Partner</fullName>
        <actions>
            <name>Assigned_to_Partner_Modified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Assigned_to_Partner_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Assigned_to_Partner_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(ImpartnerPRM__IsDealRegistration__c == false) &amp;&amp; (ISNEW() || ISCHANGED(ImpartnerPRM__PartnerContact__c)) &amp;&amp; (ImpartnerPRM__PartnerContact__c != null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check ANZ Lead Notification Flag</fullName>
        <actions>
            <name>Set_Timer_Active_field_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OwnerId = &apos;ANZ Sales Leads&apos;, Timer_Active__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Registration Denied</fullName>
        <actions>
            <name>Deal_Registration_Denied</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>(ImpartnerPRM__IsDealRegistration__c == true) &amp;&amp;  (ImpartnerPRM__DealRegistrationDenied__c == true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LCRM Lead Deal Registration Update</fullName>
        <actions>
            <name>Deal_Registration_Denied_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False, Is_GLI__c = true, RecordType.DeveloperName =&quot;GLI&quot;, ISPICKVAL( Status , &apos;Disqualified&apos;), ISPICKVAL( LCRM_Integration_Source__c , &apos;Impartner&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LCRM Lead activation as GLI</fullName>
        <actions>
            <name>LCRM_Lead_activation_as_GLI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Created as part of OOB lead creation for LOTUS users to default record type to GLI, DPS-12433. 
Deactivated for UKI lightning and instead PB is created.
Process Builder : Lotus_Switch_TrNewRecordType_Lightning</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False, Is_GLI__c = true, RecordType.DeveloperName = &quot;Create_New_Lead&quot; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ ACADEMIC</fullName>
        <actions>
            <name>ANZ_ACAD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c, &apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;ACADEMIC&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ ACCOUNTING</fullName>
        <actions>
            <name>ANZ_ACCOUNTING</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;ACADEMIC&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ BARRISTER</fullName>
        <actions>
            <name>ANZ_BARRISTER</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;BARRISTER&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ CORP</fullName>
        <actions>
            <name>ANZ_LEAD_CORP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c, &apos;LRA&apos;)),OR(ISPICKVAL(Customer_Group__c ,&apos;CORPORATION&apos;),ISPICKVAL(Customer_Group__c ,&apos;CORPORATE&apos;)), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ COURT</fullName>
        <actions>
            <name>ANZ_COURT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;COURT&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ FED GOVT</fullName>
        <actions>
            <name>ANZ_FED_GOVT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;GOVERNMENT (FEDERAL)&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ FIRM</fullName>
        <actions>
            <name>ANZ_FIRM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c,&apos;BKRS&apos;),ISPICKVAL(Sales_Org__c,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;FIRM&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ GOVT</fullName>
        <actions>
            <name>ANZ_LEAD_GOVT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;LOCAL GOVERNMENT&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ IN HOUSE</fullName>
        <actions>
            <name>ANZ_IN_HOUSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;NON PROFIT&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ NON PROFIT</fullName>
        <actions>
            <name>ANZ_NON_PROFIT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;IN HOUSE&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ PRIVATE</fullName>
        <actions>
            <name>ANZ_PRIVATE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;PRIVATE (INDIVIDUAL, NO BUS)&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ RESELLER</fullName>
        <actions>
            <name>ANZ_RESELLER</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;RESELLER&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ STUDENT</fullName>
        <actions>
            <name>ANZ_STUDENT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,OR(ISPICKVAL(Sales_Org__c , &apos;BKRS&apos;),ISPICKVAL(Sales_Org__c ,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;STUDENT&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ TERTIARY INSTITUTION</fullName>
        <actions>
            <name>ANZ_TERTIARY_INSTITUTION</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c ,&apos;BKRS&apos;),ISPICKVAL(Sales_Org__c,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;TERTIARY INSTITUTION&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-ANZ TRADE HOUSE</fullName>
        <actions>
            <name>ANZ_TRADE_HOUSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR(ISPICKVAL(Sales_Org__c ,&apos;BKRS&apos;),ISPICKVAL(Sales_Org__c,&apos;LRA&apos;)),ISPICKVAL(Customer_Group__c ,&apos;TRADE HOUSE&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST ACADEMIC</fullName>
        <actions>
            <name>WEST_ACADEMIC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,ISPICKVAL(Sales_Org__c , &apos;WEST&apos;),ISPICKVAL(Customer_Group__c ,&apos;ACADEMIC&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST CORP</fullName>
        <actions>
            <name>WEST_CORP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISPICKVAL(Sales_Org__c ,&apos;West&apos;),ISPICKVAL(Customer_Group__c,&apos;CORPORATION&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST FED GOVT</fullName>
        <actions>
            <name>WEST_LEAD_FED_GOVT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,ISPICKVAL(Sales_Org__c , &apos;West&apos;),ISPICKVAL(Customer_Group__c ,&apos;GOVERNMENT (FEDERAL)&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST FIRM</fullName>
        <actions>
            <name>WEST_FIRM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISPICKVAL(Sales_Org__c ,&apos;West&apos;),OR(ISPICKVAL(Customer_Group__c,&apos;LAWFIRM&apos;),ISPICKVAL(Customer_Group__c ,&apos;FIRM&apos;)), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST GOVT</fullName>
        <actions>
            <name>WEST_LEAD_GOVT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,ISPICKVAL(Sales_Org__c,&apos;West&apos;),ISPICKVAL(Customer_Group__c,&apos;GOVERNMENT (STATE, LOCAL)&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST PRIVATE</fullName>
        <actions>
            <name>WEST_PRIVATE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISPICKVAL(Sales_Org__c , &apos;West&apos;),ISPICKVAL(Customer_Group__c ,&apos;PRIVATE (INDIVIDUAL, NO BUS)&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LEAD-Industry-WEST RESELLER</fullName>
        <actions>
            <name>WEST_RESELLER</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISPICKVAL(Sales_Org__c , &apos;West&apos;),ISPICKVAL(Customer_Group__c ,&apos;RESELLER&apos;), ISPICKVAL( Industry,&apos;NOT APPLICABLE&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LOTUS LEX Lead Address to copy from Account</fullName>
        <actions>
            <name>LOTUS_Update_Lead_City_with_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOTUS_Update_Lead_Country_with_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOTUS_Update_Lead_State_with_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOTUS_Update_Lead_Street_with_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOTUS_Update_Lead_ZipCode_with_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead standard address should be copied from Account Address for LOTUS lightning, DPS-12740</description>
        <formula>AND( 	$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, 	$User.UITheme = &apos;Theme4d&apos;, 	Is_GLI__c  = true, 	NOT(ISNULL(Account__c)), 	ISCHANGED(Account__c), 	PRIORVALUE( Account__c) != Account__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Address Standard to Custom Copy - Impartner</fullName>
        <actions>
            <name>Lead_City_copy_standard_to_custom</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Country_copy_standard_to_custom</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_State_copy_standard_to_custom</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Street_copy_standard_to_custom</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Zip_copy_standard_to_custom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead standard address should be copied to Lead custom address for Impartner Leads, DPS-20253</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, Is_GLI__c = true, ISPICKVAL(LCRM_Integration_Source__c, &quot;Impartner&quot;), OR( AND( NOT(ISNULL( Country )), NOT(ISBLANK( Country )) ), AND( NOT(ISNULL( State )), NOT(ISBLANK( State )) ), AND( NOT(ISNULL( City )), NOT(ISBLANK( City )) ), AND( NOT(ISNULL( Street )), NOT(ISBLANK( Street )) ), AND( NOT(ISNULL( PostalCode )), NOT(ISBLANK( PostalCode )) ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Conversion - Lead Stage</fullName>
        <actions>
            <name>Lead_Conversion_Lead_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Upon conversion, &quot;Lead Stage&quot; field will automatically update to SAL value.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISPICKVAL( Status , &apos;Converted&apos;) ,  IsConverted = true,  OR(Lead_Owner_Profile_Name__c  &lt;&gt; &apos;TR Legal US Sales User&apos;,Lead_Owner_Profile_Name__c  &lt;&gt; &apos;TR Legal FindLaw User&apos;,Lead_Owner_Profile_Name__c  &lt;&gt; &apos;TR Legal FindLaw Advanced Lead Mgmt&apos;,Lead_Owner_Profile_Name__c  &lt;&gt; &apos;LMS - User&apos;,Lead_Owner_Profile_Name__c  &lt;&gt; &apos;TR Legal US Sales User Adv Lead Mgmt&apos; ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead_Change_Lead_Status_SAL</fullName>
        <actions>
            <name>Lead_Stage_update_SAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,ISPICKVAL(PRIORVALUE(Status), &quot;Unworked&quot;) , NOT(ISPICKVAL(Status,&quot;Unworked&quot;)),ISPICKVAL(Lead_Stage__c, &quot;Marketing Qualified Lead (MQL)&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Leadsource Jigsaw</fullName>
        <actions>
            <name>Billing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Billing_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Jigsaw</value>
        </criteriaItems>
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
        <active>true</active>
        <formula>(ImpartnerPRM__NotifyPartner__c == true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Saving %27Prior Lead Score%27 field</fullName>
        <actions>
            <name>Action_to_Save_Prior_Lead_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WF to save previous value of Lead Score field created as part of DPS-11571(Ortoo Q-assign)</description>
        <formula>AND(NOT( ISBLANK(  Lead_Scoring_Combined__c )),NOT(ISCHANGED(  OwnerId  ) ),ISCHANGED(  Lead_Scoring_Combined__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRStore Microsite Deloitte Order Email</fullName>
        <actions>
            <name>TRStore_Deloitte_Email_to_Microsite</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Lead_Microsite__c</field>
            <operation>equals</operation>
            <value>Deloitte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.TRstore_Microsite_Order_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send email notification for the Deloitte microsite users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRStore Microsite Deloitte Order Email Resend Approvals</fullName>
        <actions>
            <name>TRStore_Deloitte_Email_to_Microsite</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Microsite__c</field>
            <operation>equals</operation>
            <value>Deloitte</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.TRstore_Microsite_Order_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Microsite_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Resend Request</value>
        </criteriaItems>
        <description>send email notification for the Deloitte microsite users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRStore Microsite PWC %26 Deloitte Order Email</fullName>
        <actions>
            <name>TRStore_Email_to_Microsite</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Lead_Microsite__c</field>
            <operation>equals</operation>
            <value>Deloitte,PWC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.TRstore_Microsite_Order_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send email notification for the PWC and Deloitte microsite users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRStore Microsite PWC Order Email</fullName>
        <actions>
            <name>TRStore_PWC_Email_to_Microsite</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Lead_Microsite__c</field>
            <operation>equals</operation>
            <value>PWC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.TRstore_Microsite_Order_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send email notification for the PWC microsite users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRStore Microsite PWC Order Email Resend Approvals</fullName>
        <actions>
            <name>TRStore_PWC_Email_to_Microsite</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Microsite__c</field>
            <operation>equals</operation>
            <value>PWC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.TRstore_Microsite_Order_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Microsite_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Resend Request</value>
        </criteriaItems>
        <description>send email notification for the PWC microsite users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRStore Microsite TriForm Order Email</fullName>
        <actions>
            <name>TRStore_Order_Confirmation_Email_to_TriForm_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Microsite__c</field>
            <operation>equals</operation>
            <value>Triform</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.TRstore_Microsite_Order_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send email notification for the TriForm microsite users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck ANZ Lead Notification Flag</fullName>
        <actions>
            <name>Set_Timer_Active_field_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, Business_Org__c = &apos;ANZ&apos;, Timer_Active__c = True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Fields on GLI Lead-New</fullName>
        <actions>
            <name>Update_Lead_Billing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Company</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_County</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Website</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Account Field values on GLI Lead.
Phone will not be populated from the associated Account record.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, OR( AND(ISNEW(), Account__c!=null), PRIORVALUE( Account__c) != Account__c ),   Is_GLI__c  = true )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Fields on Lead</fullName>
        <actions>
            <name>Update_Lead_Billing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Billing_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Tax_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Account Field values on Lead
Field Update for Account Phone is removed as part of MCL-2083</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,  (PRIORVALUE( Account__c) != Account__c || Account__c!=null),  Is_GLI__c = false  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact Fields on Lead</fullName>
        <actions>
            <name>Update_Email_on_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Title_on_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the Contact Field Values on Lead</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,(NOT(ISBLANK(Contact__c) || ISNULL(Contact__c))),  Is_GLI__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Created By Partner</fullName>
        <actions>
            <name>Update_LAtam_Created_By_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>DPS-17696 - Check Created By Partner checkbox if Lead is created by Partner Portal User profile</description>
        <formula>$Profile.Name =  $Label.LatAmPartnerCommunityProfile</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Stage to TeleQualified</fullName>
        <actions>
            <name>Update_Lead_Stage_to_TeleQualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>update lead stage to Tele Qualified</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,IsConverted = True, ISPICKVAL(LCRM_Status__c,&apos;Converted&apos;), Lead_Owner_Profile_Name__c = &apos;TR Legal US Sales User,TR Legal FindLaw User,TR Legal FindLaw Advanced Lead Mgmt,LMS - User,TR Legal US Sales User Adv Lead Mgmt&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web to Lead check</fullName>
        <actions>
            <name>UpdateLeadStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Is_Web_to_lead_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISPICKVAL(LeadSource ,&apos;Customer Service&apos;), Is_GLI__c = False)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
