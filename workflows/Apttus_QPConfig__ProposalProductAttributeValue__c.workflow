<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>APTS_PLI_Pricing_Quantity</fullName>
        <field>APTS_Pricing_Quantity__c</field>
        <formula>APTS_Pricing_Quantity__c</formula>
        <name>APTS PLI Pricing Quantity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Apttus_QPConfig__LineItemId__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_PLI_Pricing_Quantity_Type</fullName>
        <field>APTS_Pricing_Qty_Type__c</field>
        <formula>APTS_Pricing_Qty_Type__c</formula>
        <name>APTS PLI Pricing Quantity Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Apttus_QPConfig__LineItemId__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>APTS Update Pricing Quantity</fullName>
        <actions>
            <name>APTS_PLI_Pricing_Quantity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( APTS_Pricing_Quantity__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Pricing Quantity Type</fullName>
        <actions>
            <name>APTS_PLI_Pricing_Quantity_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( APTS_Pricing_Qty_Type__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
