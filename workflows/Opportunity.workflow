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
        <template>LATAM_Mail/Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>CreateSAPCustomer</fullName>
        <ccEmails>sapcustomerquotecreationservice@1uvmq1f3fwbknannrpnr8p6fv4bc79d2qwsmtzz4ss00f24kya.3-plslea2.al.apex.salesforce.com</ccEmails>
        <description>CreateSAPCustomer</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CreateSAPCustomer_Opp</template>
    </alerts>
    <alerts>
        <fullName>CreateSAPQuotefromOpp</fullName>
        <ccEmails>sapcustomerquotecreationservice@1uvmq1f3fwbknannrpnr8p6fv4bc79d2qwsmtzz4ss00f24kya.3-plslea2.al.apex.salesforce.com</ccEmails>
        <description>CreateSAPQuotefromOpp</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CreateSAPQuote_Opp</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Email_Owner_of_Opportunity_Closure_English</fullName>
        <description>LATAM Email Owner of Opportunity Closure - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Order_Form/Opportunity_Closed_100_English</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Email_Owner_of_Opportunity_Closure_Portugueuse</fullName>
        <description>LATAM Email Owner of Opportunity Closure - Portugueuse</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Order_Form/Opportunity_Closed_100_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Email_Owner_of_Opportunity_Closure_Spanish</fullName>
        <description>LATAM Email Owner of Opportunity Closure - Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>tlr.miscrmoperations@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LatAm_Order_Form/Opportunity_Closed_100_Spanish</template>
    </alerts>
    <alerts>
        <fullName>LCRM_Email_Alert_for_Renewal_Cancellation_Notification</fullName>
        <description>Email Alert for Renewal Cancellation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>LCRM_Owners_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LCRM_Renewal_Cancellatn_Notification</template>
    </alerts>
    <alerts>
        <fullName>LOTUS_High_Deal_Alert_for_Order_Complete_Opportunities</fullName>
        <description>Created a email alert for closed won opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>Corporate_Segment_Leader</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LOTUS_Opportunity_Email_Templates/Alert_for_Order_Complete_Opportunities</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification</fullName>
        <description>Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Rejection_Notification</template>
    </alerts>
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
        <field>ImpartnerPRM__PartnerOpportunityAcceptance__c</field>
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
        <fullName>Change_Forecast_commit</fullName>
        <field>Sales_Priority__c</field>
        <literalValue>COMMIT</literalValue>
        <name>Change Forecast commit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Custom_Last_Modified</fullName>
        <field>New_LastModified__c</field>
        <formula>IF( Owner.Id = LastModifiedBy.Id, LastModifiedDate , 
New_LastModified__c
)</formula>
        <name>Custom Last Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Override_Revenue_Amount</fullName>
        <field>Override_Revenue_Amounts__c</field>
        <literalValue>1</literalValue>
        <name>Default Override Revenue Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hoopla_Action_Event_Trigger</fullName>
        <field>Hoopla_ActionEvent_Triggered__c</field>
        <literalValue>1</literalValue>
        <name>Hoopla Action Event Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IS_System_Generated</fullName>
        <field>Latam_Is_System_Generated__c</field>
        <literalValue>1</literalValue>
        <name>System Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Approved_Cancelaltn_Approval_Status</fullName>
        <field>LCRM_Cancellation_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Cancellation Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Reject_Cancellation_Approval_Status</fullName>
        <field>LCRM_Cancellation_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Reject Cancellation Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Update_Total_Actual_Incremental_USL</fullName>
        <description>CRM-17856: Update Total Actual Incremental field with the value of Calculated Incremental - USL. User can update these values</description>
        <field>LCRM_Total_Actual_Incremental__c</field>
        <formula>IF(  (ISCHANGED( Amount ) || ( ISNEW() &amp;&amp; ISBLANK( LCRM_Total_Actual_Incremental__c ) )) 
 &amp;&amp;  HasOpportunityLineItem = False ,  Amount, IF( ( NOT( ISCHANGED( LCRM_Total_Actual_Incremental__c ) ) 
 &amp;&amp; PRIORVALUE( LCRM_Total_Actual_Incremental__c ) = PRIORVALUE( LCRM_Calculated_Incremental_USL__c ) ) || ISNULL( LCRM_Total_Actual_Incremental__c ) || 
 ISCHANGED( LCRM_Total_Incremental_USL__c ), LCRM_Calculated_Incremental_USL__c, LCRM_Total_Actual_Incremental__c ) )</formula>
        <name>LCRM Update Total Actual Incremental USL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Update_Total_Actual_Renewal_USL</fullName>
        <description>CRM-17856: Update Total Actual Renewal field with the value of Calculated Renewal - USL. User can update these values</description>
        <field>LCRM_Total_Actual_Renewal__c</field>
        <formula>IF((NOT(ISCHANGED(LCRM_Total_Actual_Renewal__c)) &amp;&amp; PRIORVALUE(LCRM_Total_Actual_Renewal__c)=PRIORVALUE(LCRM_Calculated_Renewal_USL__c)) || ISNULL(LCRM_Total_Actual_Renewal__c) || ISCHANGED( LCRM_Calculated_Renewal_USL__c), 
LCRM_Calculated_Renewal_USL__c, 
LCRM_Total_Actual_Renewal__c)</formula>
        <name>LCRM Update Total Actual Renewal USL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Updated_Cancelled_Status_to_Open</fullName>
        <field>LCRM_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Updated Cancelled Status to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Sum_of_Product</fullName>
        <field>Sum_of_Software__c</field>
        <formula>IF(
(NOT(ISCHANGED(Sum_of_Software__c)) &amp;&amp; PRIORVALUE(Sum_of_Software__c)=PRIORVALUE(LCRM_New_ACV_Sales_Price_Product__c)) 
|| 
ISNULL(Sum_of_Software__c) || ISCHANGED(LCRM_New_ACV_Sales_Price_Product__c), 
LCRM_New_ACV_Sales_Price_Product__c, 
Sum_of_Software__c)</formula>
        <name>LOTUS Update Sum of Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOTUS_Update_Sum_of_Services</fullName>
        <field>Sum_of_Services__c</field>
        <formula>IF(
(NOT(ISCHANGED(Sum_of_Services__c)) &amp;&amp; PRIORVALUE(Sum_of_Services__c)=PRIORVALUE(LCRM_New_ACV_Sales_Price_Service__c)) 
|| 
ISNULL(Sum_of_Services__c) || ISCHANGED(LCRM_New_ACV_Sales_Price_Service__c), 
LCRM_New_ACV_Sales_Price_Service__c, 
Sum_of_Services__c)</formula>
        <name>LOTUS Update Sum of Services</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Modify_Manual_renewal_stage_change</fullName>
        <field>Manual_Renewal_stage_change__c</field>
        <literalValue>0</literalValue>
        <name>Modify Manual renewal stage change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
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
        <fullName>PartnerPortalUserUpdate</fullName>
        <description>When profile is partner portal user then set the partner portal user field as true.</description>
        <field>Parter_Portal_User_Confirmed__c</field>
        <literalValue>1</literalValue>
        <name>PartnerPortalUserUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Offer_Code</fullName>
        <description>Populate Offer Code field based on selected Primary Campaign Source.</description>
        <field>Offer_Code__c</field>
        <formula>Campaign.Offer_Code__c</formula>
        <name>Populate Offer Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection</fullName>
        <field>Rejected__c</field>
        <literalValue>1</literalValue>
        <name>Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Actual_Close_Date</fullName>
        <description>Update the Actual Close Date field when an Opportunity reaches Stage 100%.</description>
        <field>Actual_Close_Date__c</field>
        <formula>Now()</formula>
        <name>Update Actual Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount</fullName>
        <description>Update Amount with the sum of Total Renewal and Total Incremental</description>
        <field>Amount</field>
        <formula>Total_Incremental__c +  Total_Renewal__c</formula>
        <name>Update Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount_for_GLI</fullName>
        <field>Amount</field>
        <formula>LCRM_Total_Incremental__c +  LCRM_Total_Renewal__c +  LCRM_Total_Services_Amt__c</formula>
        <name>Update Amount for GLI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Field</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Approved Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Time</fullName>
        <field>Approved_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field_Is_Migrated_Opportunity</fullName>
        <field>Is_Migrated__c</field>
        <literalValue>1</literalValue>
        <name>Update Field Is Migrated Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsSubmitted_to_False</fullName>
        <field>Is_Submitted__c</field>
        <literalValue>0</literalValue>
        <name>Update IsSubmitted to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsSubmitted_to_True</fullName>
        <field>Is_Submitted__c</field>
        <literalValue>1</literalValue>
        <name>Update IsSubmitted to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Offer_Desc_on_Opportunity</fullName>
        <field>Offer_Description__c</field>
        <formula>Campaign.Offer_Description__c</formula>
        <name>Update Offer Desc on Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_CloseDate</fullName>
        <description>DPS-12940
&apos;Close Date&apos; to Update to Current Date when an Opportunity Closes</description>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Update Opportunity CloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected_Field</fullName>
        <field>Rejected__c</field>
        <literalValue>0</literalValue>
        <name>Update Rejected Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage</fullName>
        <field>StageName</field>
        <literalValue>95%</literalValue>
        <name>Update Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_on_Pre_Pipeline_Opportunity</fullName>
        <description>Update Stage to 0% on Pre-Pipeline Opportunity when Status is changed to &apos;Discarded&apos;.</description>
        <field>StageName</field>
        <literalValue>0%</literalValue>
        <name>Update Stage on Pre-Pipeline Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateContactPhone</fullName>
        <description>update ContactPhone field from Account Phone field</description>
        <field>ContactPhone__c</field>
        <formula>Account.Phone</formula>
        <name>updateContactPhone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Deal_Registration_Approved</fullName>
        <apiVersion>45.0</apiVersion>
        <endpointUrl>https://partnerportal.thomsonreuters.com/services/sfdc/DealRegistrationApproved.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>meenum.pillai@trpcorelegal.com</integrationUser>
        <name>Deal Registration Approved</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>NotifyPartnerOutbound</fullName>
        <apiVersion>42.0</apiVersion>
        <endpointUrl>https://partnerportal.thomsonreuters.com/services/sfdc/OpportunityNotifyPartner.ashx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>meenum.pillai@trpcorelegal.com</integrationUser>
        <name>Notify Partner Outbound</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
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
        <formula>(ImpartnerPRM__IsDealRegistration__c == false) &amp;&amp;  (ISNEW() || ISCHANGED(ImpartnerPRM__PartnerContact__c)) &amp;&amp;  (ImpartnerPRM__PartnerContact__c != null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CloseDate To Update to CurrentDate When Opportunity Close</fullName>
        <actions>
            <name>Update_Opportunity_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>DPS-12940
&apos;Close Date&apos; to Update to Current Date when an Opportunity Closes</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, 	  Is_GLI__c, ISCHANGED(StageName),  RecordTypeId = &apos;01213000001FuIL&apos;, 	OR(ISPICKVAL(StageName,&quot;Order Complete&quot;), ISPICKVAL(StageName,&quot;Closed Lost&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Custom Last Modified</fullName>
        <actions>
            <name>Custom_Last_Modified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,OwnerId &lt;&gt; null )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Registration Approved</fullName>
        <actions>
            <name>Deal_Registration_Approved</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>(ImpartnerPRM__IsDealRegistration__c == true)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Hoopla Action Event Trigger</fullName>
        <actions>
            <name>Hoopla_Action_Event_Trigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, Amount  &gt;= 1000 ,ISPICKVAL(StageName, &quot;95 % || 100 %&quot;)   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Opportunity Owner on Closure - English</fullName>
        <actions>
            <name>LATAM_Email_Owner_of_Opportunity_Closure_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false ,(TEXT(StageName) = &quot;100%&quot;), OR(Owner.Profile.Name = &apos;LatAm User&apos;, Owner.Profile.Name = &apos;Partner Portal User&apos;, $User.Username = $Label.InformaticaUserName), OR(Owner.Language__c = &quot;English&quot;,  Owner.Language__c = &quot;Inglés&quot;,  Owner.Language__c = &quot;Inglês&quot;), Is_Child_Opportunity__c &lt;&gt; true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Opportunity Owner on Closure - Portuguese</fullName>
        <actions>
            <name>LATAM_Email_Owner_of_Opportunity_Closure_Portugueuse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,(TEXT(StageName) = &quot;100%&quot;), OR(  Owner.Profile.Name = &apos;LatAm User&apos;, Owner.Profile.Name = &apos;Partner Portal User&apos;, $User.Username = $Label.InformaticaUserName), OR(Owner.Language__c = &quot;Portuguese (Brazilian)&quot;,  Owner.Language__c = &quot;Português (Brasil)&quot;,  Owner.Language__c = &quot;Portugués (Brasileño)&quot; ), Is_Child_Opportunity__c &lt;&gt; true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Opportunity Owner on Closure - Spanish</fullName>
        <actions>
            <name>LATAM_Email_Owner_of_Opportunity_Closure_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,(TEXT(StageName) = &quot;100%&quot;), OR(  Owner.Profile.Name = &apos;LatAm User&apos;, Owner.Profile.Name = &apos;Partner Portal User&apos;, $User.Username = $Label.InformaticaUserName), OR(Owner.Language__c = &quot;Spanish&quot;, Owner.Language__c = &quot;Espanhol&quot;, Owner.Language__c = &quot;Español&quot;), Is_Child_Opportunity__c &lt;&gt; true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LCRM Update Actual Close Date</fullName>
        <actions>
            <name>Update_Actual_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the Actual Close Date field on the Opportunity when the Stage reaches Order Complete.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,RecordType.DeveloperName = &quot;GLI_Pipeline_Opportunity&quot;,	 ISPICKVAL(StageName,&quot;Order Complete&quot;),  ISCHANGED(StageName),  NOT(ISPICKVAL(PRIORVALUE(StageName),&quot;Order Complete&quot;))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LCRM Update Total Actual Incremental and Total Actual Renewal - USL</fullName>
        <actions>
            <name>LCRM_Update_Total_Actual_Incremental_USL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LCRM_Update_Total_Actual_Renewal_USL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOTUS_Update_Sum_of_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LOTUS_Update_Sum_of_Services</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CRM-17856: Update Total Actual Incremental and Total Actual Renewal fields with the value of Calculated Incremental - USL and Calculated Renewal - USL respectively. User can update these values</description>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, RecordType.DeveloperName = &quot;GLI_Pipeline_Opportunity&quot;,  Is_GLI__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LOTUS - High Deal Alert for Order Complete Opportunities</fullName>
        <actions>
            <name>LOTUS_High_Deal_Alert_for_Order_Complete_Opportunities</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Based on the story DPS-9654(email alert to the Corporate Segment leadership on Opportunities that are CLOSE WON and that are over 20,000 usd)</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, BU_Segment__c = &apos;Corporate&apos;, LCRM_Total_Actual_Incremental__c &gt; 19999, ISPICKVAL(StageName,&quot;Order Complete&quot;), Is_GLI__c = True, RecordTypeId= $Label.GLI_Pipeline_Opportunity )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LatAm Default Override Revenue Amount</fullName>
        <actions>
            <name>Default_Override_Revenue_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false ,OR(CreatedBy.Profile.Name = &quot;LatAm User&quot;, CreatedBy.Profile.Name= &quot;Partner Portal User&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Modify Forecast commit when stage changes to 95%25</fullName>
        <actions>
            <name>Change_Forecast_commit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,ISPICKVAL( StageName , &quot;95%&quot;))</formula>
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
        <fullName>Opportunity Migration from FSCO to TSL Sales org</fullName>
        <actions>
            <name>Update_Field_Is_Migrated_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,ISPICKVAL(PRIORVALUE(Sales_Org__c), &quot;FSCO&quot;),ISPICKVAL(Sales_Org__c, &quot;TSL&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Migration from RV01 to TSL Sales org</fullName>
        <actions>
            <name>Update_Field_Is_Migrated_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as part of brazil legal eco system for migration of legal one products to TSL</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,ISPICKVAL(PRIORVALUE(Sales_Org__c), &quot;RV01&quot;),ISPICKVAL(Sales_Org__c, &quot;TSL&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Partner Portal User Opportunity Create</fullName>
        <actions>
            <name>PartnerPortalUserUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a new opportunity is created by anyone with the profile of Partner Portal User, two fields must auto populate. They are “Partner Account” and “Partner Portal User”.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,Owner.Profile.Name = &apos;Partner Portal User&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Offer Code field based on selected Primary Campaign Source%2E</fullName>
        <actions>
            <name>Populate_Offer_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Offer_Desc_on_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Offer Code field based on selected Primary Campaign Source.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,(ISNEW()&amp;&amp; CampaignId &lt;&gt; null) || ISCHANGED(CampaignId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renew Optty</fullName>
        <actions>
            <name>IS_System_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>startsWith</operation>
            <value>Renew</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Revert Manual Renewal stage change flag</fullName>
        <actions>
            <name>Modify_Manual_renewal_stage_change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, Manual_Renewal_stage_change__c  = TRUE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Actual Close Date</fullName>
        <actions>
            <name>Update_Actual_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the Actual Close Date field on the Opportunity when the Stage reaches 100%.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, ISPICKVAL(StageName,&quot;100%&quot;),  ISCHANGED(StageName),  NOT(ISPICKVAL(PRIORVALUE(StageName),&quot;100%&quot;))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Amount</fullName>
        <actions>
            <name>Update_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Amount with the sum of Total Renewal and Total Incremental</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,OR( Total_Incremental__c  &gt; 0, Total_Renewal__c  &gt; 0))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage on Pre-Pipeline Opportunity</fullName>
        <actions>
            <name>Update_Stage_on_Pre_Pipeline_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Stage on Pre-Pipeline Opportunity.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, RecordType.DeveloperName  = &quot;Pre-Pipeline Opportunity&quot;, ISPICKVAL(Status__c,&quot;Discarded&quot;),NOT(ISPICKVAL(StageName,&quot;0%&quot;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>triggerSAPCustomerCreation</fullName>
        <actions>
            <name>CreateSAPCustomer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,OR(RecordType.Name = &apos;Pipeline Opportunity&apos;,RecordType.Name = &apos;LATAM Renewal Opportunity&apos;) &amp;&amp; Account.RecordType.Name = &apos;Prospect&apos; &amp;&amp;  (ISCHANGED(StageName) || ISNEW()) &amp;&amp; (ISPICKVAL(StageName, &apos;75%&apos;) || ISPICKVAL(StageName, &apos;90%&apos;) || ISPICKVAL(StageName, &apos;95%&apos;) || ISPICKVAL(StageName, &apos;100%&apos;)  ) &amp;&amp; NOT((ISPICKVAL(Account.Sales_Org__c,&apos;BKRS&apos;) || ISPICKVAL(Account.Sales_Org__c,&apos;LRA&apos;)|| ISPICKVAL(Account.Sales_Org__c,&apos;SMGE&apos;) ||  ISPICKVAL(Account.Sales_Org__c,&apos;EDIC&apos;) || ISPICKVAL(Account.Sales_Org__c,&apos;SFWS&apos;) || ISPICKVAL(Account.Sales_Org__c,&apos;TSCE&apos;) || ISPICKVAL(Account.Sales_Org__c,&apos;SCSI&apos;) ||    ISPICKVAL(Account.Source__c,&apos;Practical Law&apos;)|| Account.NameTwo__c = &apos;Practical Law&apos;)) &amp;&amp;  NOT( NOT(ISBLANK(Lead_ID__c)) &amp;&amp; ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>triggerSAPQuoteCreationfromOpp</fullName>
        <actions>
            <name>CreateSAPQuotefromOpp</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,RecordType.Name = &apos;Pipeline Opportunity&apos; &amp;&amp;  Account.RecordType.Name = &apos;Customer&apos;  &amp;&amp;  NOT(Quote_Creation_Complete__c) &amp;&amp;  Is_Child_Opportunity__c  &lt;&gt; true  &amp;&amp;    (   (    ISPICKVAL(StageName, &apos;75%&apos;) ||     ISPICKVAL(StageName, &apos;90%&apos;) ||     ISPICKVAL(StageName, &apos;100%&apos;)    ) ||    (     ISPICKVAL(StageName, &apos;95%&apos;) &amp;&amp;      (       ISBLANK(Lead_ID__c)      )   )    ) &amp;&amp; NOT((ISPICKVAL(Account.Sales_Org__c,&apos;BKRS&apos;) || ISPICKVAL(Account.Sales_Org__c,&apos;LRA&apos;)|| ISPICKVAL(Account.Sales_Org__c,&apos;SMHK&apos;) || ISPICKVAL(Account.Sales_Org__c,&apos;SMGE&apos;) ||  ISPICKVAL(Account.Sales_Org__c,&apos;EDIC&apos;) ||  ISPICKVAL(Account.Source__c,&apos;Practical Law&apos;) || Account.NameTwo__c = &apos;Practical Law&apos;)) &amp;&amp; NOT(Require_Manual_Trigger_for_Quote__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>updateContactPhone field</fullName>
        <actions>
            <name>updateContactPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>update ContactPhone field from Account Phone field</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
