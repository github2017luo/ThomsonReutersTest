<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_IC_Name</fullName>
        <field>Name</field>
        <formula>First_Name__c  + &apos; &apos;+ Last_Name__c</formula>
        <name>Update IC Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Unique_Identifier</fullName>
        <field>Unique_Identifier__c</field>
        <formula>TEXT(TODAY())&amp;&apos;|&apos;&amp;Email__c</formula>
        <name>Update Unique Identifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ODT IC Name</fullName>
        <actions>
            <name>Update_IC_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(CreatedDate))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Unique Identifier For Invited Colleague</fullName>
        <actions>
            <name>Update_Unique_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
