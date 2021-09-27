<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APTS_Send_ready_for_COB_notification_to_rep</fullName>
        <description>APTS_Send ready for COB notification to rep</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Proposal_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_Ready_For_COB_Template</template>
    </alerts>
    <alerts>
        <fullName>Order_Confirmation_Email_to_contact</fullName>
        <description>Order Confirmation Email to contact</description>
        <protected>false</protected>
        <recipients>
            <field>Apttus_Config2__PrimaryContactId__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TRStore_Order_Confirmation_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Order_Rejection_email_to_rep</fullName>
        <description>Send Order Rejection email to rep</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_Order_Rejection_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>APTS_Update_Proposal_Owner_EmailId</fullName>
        <field>APTS_Proposal_Owner_Email__c</field>
        <formula>Apttus_QPConfig__ProposalId__r.Owner:User.Email</formula>
        <name>APTS_Update_Proposal_Owner_EmailId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus_Config2__SetOriginalOrderNumber</fullName>
        <description>Set original order number from the auto generated order number</description>
        <field>Apttus_Config2__OriginalOrderNumber__c</field>
        <formula>Name</formula>
        <name>Set Original Order Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>APTS_FL_Update_ProposalOwnerEmail_On_Order</fullName>
        <actions>
            <name>APTS_Update_Proposal_Owner_EmailId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( Apttus_QPConfig__ProposalId__c ) ) &amp;&amp;  APTS_Proposal_Business_Unit__c ==&apos;FindLaw&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Order_Rejection_Email_Template</fullName>
        <actions>
            <name>Send_Order_Rejection_email_to_rep</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends order cancellation email to rep if inventory is not available</description>
        <formula>(!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c)&amp;&amp; NOT(ISPICKVAL(PRIORVALUE(APTS_SAP_Status__c),&apos;No Inventory Available&apos;)) &amp;&amp;  ISPICKVAL(APTS_SAP_Status__c,&apos;No Inventory Available&apos;) &amp;&amp;  ISPICKVAL(Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Send Ready for COB notification to rep</fullName>
        <actions>
            <name>APTS_Send_ready_for_COB_notification_to_rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends the email to rep notifying that contract has been generated and ready for COB to be filled out</description>
        <formula>(!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c) &amp;&amp; NOT(ISPICKVAL(PRIORVALUE(APTS_SAP_Status__c),&apos;Ready for COB&apos;)) &amp;&amp; ISPICKVAL(APTS_SAP_Status__c,&apos;Ready for COB&apos;) &amp;&amp; ISPICKVAL(Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Apttus_Config2__Set Original Order Number</fullName>
        <actions>
            <name>Apttus_Config2__SetOriginalOrderNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__Order__c.Apttus_Config2__OriginalOrderNumber__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set original order number for new orders. The order number is auto generated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Confirmation Email</fullName>
        <actions>
            <name>Order_Confirmation_Email_to_contact</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email alert on order creation for TR Store&apos;s orders</description>
        <formula>TR_Store_Source__c  = &apos;TR Store Canada Print&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
