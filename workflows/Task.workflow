<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activity_Type_custom_Task</fullName>
        <field>Activity_Type_custom__c</field>
        <formula>TEXT(Type)</formula>
        <name>Activity Type (custom) - Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TR_Retention__Update_Completion_Date_on_Task</fullName>
        <field>TR_Retention__Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Completion Date on Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Short_Comments</fullName>
        <field>Comments__c</field>
        <formula>IF(LEN(Description) &gt; 50, LEFT(Description,50)&amp;&quot;…&quot;,Description)</formula>
        <name>Update Short Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Populate Activity Type %28custom%29 - Task</fullName>
        <actions>
            <name>Activity_Type_custom_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, TEXT(Type)  &lt;&gt; &apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TR_Retention__Update Completion Date on Task</fullName>
        <actions>
            <name>TR_Retention__Update_Completion_Date_on_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>This workflow rule updates the completion date on the Task when the status of task is set to &quot;Completed&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Comments for Task Related List</fullName>
        <actions>
            <name>Update_Short_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
