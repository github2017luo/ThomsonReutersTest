<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateUniqueChannelAndLeadScore</fullName>
        <description>Updates UniqueChannelAndLeadScore field for duplicate check</description>
        <field>UniqueChannelAndLeadScore__c</field>
        <formula>TEXT(Channel__c)  &amp;  TEXT(Lead_Score__c)</formula>
        <name>UpdateUniqueChannelAndLeadScore</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>UpdateLeadChannelAndScoreUniqueField</fullName>
        <actions>
            <name>UpdateUniqueChannelAndLeadScore</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>It will update UniqueChannelAndLeadScore field with a combination of Channel and LeadScore</description>
        <formula>TEXT(Channel__c)  &lt;&gt; null &amp;&amp; TEXT(Channel__c)  &lt;&gt; &apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
