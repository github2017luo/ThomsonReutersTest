<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TR_Retention__Contract_Rule_Name_Unique</fullName>
        <field>TR_Retention__Contract_Rule_Name__c</field>
        <formula>TR_Retention__Contract_Value__c+&apos; &apos;+TR_Retention__Sub_BU__c+&apos; &apos;+TR_Retention__Product_Family__c</formula>
        <name>Contract Rule Name Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>TR_Retention__Contract Rule Name Unique</fullName>
        <actions>
            <name>TR_Retention__Contract_Rule_Name_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TR_Retention__Retention_Parent_Criteria__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Contract Rule Name is Unique</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
