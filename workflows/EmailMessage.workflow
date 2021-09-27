<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Description</fullName>
        <field>Description</field>
        <formula>TextBody</formula>
        <name>Case Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Subject</fullName>
        <field>Subject</field>
        <formula>Subject</formula>
        <name>Case Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Email FindLaw Sales Ops</fullName>
        <actions>
            <name>Case_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email FindLaw Sales Ops</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Copies email subject &amp; body to case subject &amp; description respectively</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
