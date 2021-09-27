<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TR_Retention__Comb_Value</fullName>
        <field>TR_Retention__Activity_SubjectText__c</field>
        <formula>TR_Retention__SUB_BU__c  &amp;  TR_Retention__Activity_Subject__c</formula>
        <name>Comb Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>TR_Retention__Unique activity subject</fullName>
        <actions>
            <name>TR_Retention__Comb_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TR_Retention__Retention_Activity_Subject__c.TR_Retention__SUB_BU__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TR_Retention__Retention_Activity_Subject__c.TR_Retention__Activity_Subject__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
