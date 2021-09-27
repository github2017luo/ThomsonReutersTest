<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ESC_NotPublished</fullName>
        <field>ValidationStatus</field>
        <literalValue>Not Validated</literalValue>
        <name>ESC_NotPublished</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESC_Published</fullName>
        <field>ValidationStatus</field>
        <literalValue>Validated</literalValue>
        <name>ESC_Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Approved</fullName>
        <field>ESC_Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Update Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Rejected</fullName>
        <field>ESC_Approval_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Update Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>ESC_Publish</fullName>
        <action>PublishAsNew</action>
        <label>ESC_Publish</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
