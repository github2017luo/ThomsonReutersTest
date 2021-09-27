<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Trial_Product_Name_Update</fullName>
        <description>Omni Trial Enterprise</description>
        <field>Name</field>
        <formula>LEFT(Product_Name__r.Name, 80)</formula>
        <name>Trial Product Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Trial Product Name Update</fullName>
        <actions>
            <name>Trial_Product_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Omni Enterprise Trial</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, OR(ISCHANGED( Product_Name__c ), ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
