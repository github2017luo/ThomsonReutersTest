<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PopulateProductInactivatedDate</fullName>
        <field>LCRM_Inactivated_Date__c</field>
        <formula>TODAY()</formula>
        <name>PopulateProductInactivatedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PopulateProductInactivatedDate</fullName>
        <actions>
            <name>PopulateProductInactivatedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = FALSE,LCRM_Sub_Bu__c  = &apos;UKI&apos;, IsActive  = FALSE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
