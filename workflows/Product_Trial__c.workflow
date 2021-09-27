<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_to_Customer_Service_to_enable_Access</fullName>
        <ccEmails>smhk.csd.intl@thomsonreuters.com</ccEmails>
        <description>Email Notification to Customer Service to enable Access</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Product_Trial_Approval_Emails/Product_Trial_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Product_Trial_Nearing_Expiry</fullName>
        <description>Product Trial Nearing Expiry</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Product_Trial_Approval_Emails/Trial_Nearing_Expiry1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Trial Expiry Notification</fullName>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Product_Trial_Nearing_Expiry</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Product_Trial__c.Trial_End_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
