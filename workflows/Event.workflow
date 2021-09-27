<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activity_Type_custom_Event</fullName>
        <field>Activity_Type_custom__c</field>
        <formula>TEXT(Type)</formula>
        <name>Activity Type (custom) - Event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Event_Comments</fullName>
        <field>Description</field>
        <formula>IF(LEN(Description) &gt; 252, LEFT(Description,252)&amp;&quot;…&quot;,Description)</formula>
        <name>Update Event Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Event_Comments_Field</fullName>
        <field>Comments__c</field>
        <formula>IF(LEN(Description) &gt; 50, LEFT(Description,50)&amp;&quot;…&quot;,Description)</formula>
        <name>Update Event Comments Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Populate Activity Type %28custom%29 - Event</fullName>
        <actions>
            <name>Activity_Type_custom_Event</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,Text( Type )&lt;&gt; &apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Comments for Event Related List</fullName>
        <actions>
            <name>Update_Event_Comments_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c= False,True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
