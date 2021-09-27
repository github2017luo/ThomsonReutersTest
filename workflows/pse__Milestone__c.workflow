<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Milestone_Amount</fullName>
        <description>Created as part of DPS-15988</description>
        <field>pse__Milestone_Amount__c</field>
        <formula>Percent_To_Bill__c* pse__Project__r.pse__Bookings__c</formula>
        <name>Update Milestone Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>FF - Update Milestone Amount with Percentage Amount of Bookings</fullName>
        <actions>
            <name>Update_Milestone_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>pse__Milestone__c.Percent_To_Bill__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Created as part of DPS-15988</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
