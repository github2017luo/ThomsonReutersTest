<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Trial_Error</fullName>
        <description>DLT-19361-ODT Trial Email Template to Notify Error Information</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CX_Digital_Support</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>tr.sales@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Trial_Error</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Trial_Status_Field</fullName>
        <field>Trial_Status__c</field>
        <literalValue>Timed-out</literalValue>
        <name>Update Trial Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Trial_Status_Field_Value</fullName>
        <field>Trial_Status__c</field>
        <literalValue>Timed-out</literalValue>
        <name>Update Trial Status Field Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ODT Trial Status Update</fullName>
        <active>true</active>
        <description>This Workflow  Rule updates the Trial status filed on Trial Object record to &apos;Timed-out&apos; if the Customer does not accept the Trial after 30 days of Trial initiation.</description>
        <formula>ISPICKVAL( Trial_Status__c , &quot;Invited&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Trial_Status_Field_Value</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Trial__c.InvitedDateTime__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
