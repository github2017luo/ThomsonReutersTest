<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TR_Retention__Update_Name</fullName>
        <field>Name</field>
        <formula>TR_Retention__Activity_Subject__r.Name</formula>
        <name>Update Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>TR_Retention__Set Rule Name to Activity Subject</fullName>
        <actions>
            <name>TR_Retention__Update_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL(TR_Retention__Activity_Subject__r.TR_Retention__Activity_Subject__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
