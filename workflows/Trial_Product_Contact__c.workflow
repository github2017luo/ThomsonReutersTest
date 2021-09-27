<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateEntitlementCompletionDateTimeinTPC</fullName>
        <field>Entitlement_Completion_Date__c</field>
        <formula>NOW()</formula>
        <name>UpdateEntitlementCompletionDateTimeinTPC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>OmniTrialProductContactEntitlementCompletionFieldUpdate</fullName>
        <actions>
            <name>UpdateEntitlementCompletionDateTimeinTPC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>update Entitlement Completion date/Time Field when the Trial Product contact Entitlement status is Complete with todays date.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, (UPPER(Entitlement_Status__c)  == &apos;COMPLETE&apos;), ISNULL( Entitlement_Completion_Date__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
