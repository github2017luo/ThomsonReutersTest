<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>APTS_Update_Asset_Infa_Flag</fullName>
        <field>APTS_AssetCancel_Infa_flag__c</field>
        <literalValue>1</literalValue>
        <name>APTS Update Asset Infa Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Asset_Status</fullName>
        <field>Apttus_Config2__AssetStatus__c</field>
        <literalValue>Cancelled</literalValue>
        <name>APTS Update Asset Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>APTS Update Grace Period Assets to Cancelled</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Tax Professional</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.Apttus_Config2__AssetStatus__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.APTS_Renewal_Type__c</field>
            <operation>equals</operation>
            <value>Term Commitment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.Latam_GP_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>APTS_Update_Asset_Infa_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>APTS_Update_Asset_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Config2__AssetLineItem__c.Latam_GP_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>APTS Update Non Grace Period Assets to Cancelled</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Tax Professional</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.Apttus_Config2__AssetStatus__c</field>
            <operation>equals</operation>
            <value>Activated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.APTS_Renewal_Type__c</field>
            <operation>equals</operation>
            <value>Auto Renew,Term Commitment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.APTS_MYR_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__AssetLineItem__c.Latam_GP_End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow cancels the non grace period assets which are expired</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>APTS_Update_Asset_Infa_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>APTS_Update_Asset_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Config2__AssetLineItem__c.APTS_MYR_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
