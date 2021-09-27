<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_Contract_Owner</fullName>
        <description>Email to Contract Owner (Sales Rep)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/LCRMExpiringTrialNotificationTemplateVF</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Update Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_Approval</fullName>
        <field>Status</field>
        <literalValue>Pending Approval</literalValue>
        <name>Update Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Update Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reviewed</fullName>
        <field>Status</field>
        <literalValue>Reviewed</literalValue>
        <name>Update Reviewed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ExpiringTrialNotification</fullName>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,TEXT(LCRM_Transaction_Type__c) = &apos;Unpaid Trial&apos;, TEXT(Status) = &apos;Activated&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_to_Contract_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contract.TR_Retention__Contract_End_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
