<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Deactivate_User_True</fullName>
        <description>Field update to set the Deactivate User flag to true. This signals the trigger to take further action</description>
        <field>Deactivate_User__c</field>
        <literalValue>1</literalValue>
        <name>Deactivate User &gt; True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Deactivate User</fullName>
        <active>true</active>
        <criteriaItems>
            <field>User_License_Activation_Log__c.Deactivate_User__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Time based workflow rule to deactivate the user when the deactivation date is reached on the log record</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_User_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User_License_Activation_Log__c.Deactivation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
