<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Alert_Severity_Rating_of_Important</fullName>
        <field>Severity__c</field>
        <literalValue>Important</literalValue>
        <name>Alert Severity Rating of Important</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Alert_Severity_Rating_of_Informational</fullName>
        <field>Severity__c</field>
        <literalValue>Informational</literalValue>
        <name>Alert Severity Rating of Informational</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Alert_Severity_Rating_of_Severe</fullName>
        <field>Severity__c</field>
        <literalValue>Severe</literalValue>
        <name>Alert Severity Rating of Severe</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Active_Alert_Flag</fullName>
        <description>This field update inactivates Account Alert</description>
        <field>Active_Alert__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Active Alert Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Integration</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Integration_Account_Alert</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Integration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sub_BU_to_Elite</fullName>
        <description>Updates Sub-BU to Elite when an Account Alert is created via integration from CRMoD.</description>
        <field>Sub_BU__c</field>
        <literalValue>Elite</literalValue>
        <name>Update Sub-BU to Elite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sub_BU_to_UKI</fullName>
        <description>Updates Sub-BU to UKI when an Account Alert is created via integration from SAPMEP.</description>
        <field>Sub_BU__c</field>
        <literalValue>UKI</literalValue>
        <name>Update Sub-BU to UKI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Alert Category Customer Service</fullName>
        <actions>
            <name>Alert_Severity_Rating_of_Informational</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Alert_Category__c</field>
            <operation>equals</operation>
            <value>Customer Service</value>
        </criteriaItems>
        <description>Workflow to update &apos;Customer Service&apos; Alert Category to &apos;Informational&apos; Alert Severity Rating.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert Category Financial</fullName>
        <actions>
            <name>Alert_Severity_Rating_of_Important</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Alert_Category__c</field>
            <operation>equals</operation>
            <value>Financial</value>
        </criteriaItems>
        <description>Workflow to update &apos;Financial&apos; Alert Category to &apos;Important&apos; Alert Severity Rating.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert Category Governance</fullName>
        <actions>
            <name>Alert_Severity_Rating_of_Severe</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Alert_Category__c</field>
            <operation>equals</operation>
            <value>Governance</value>
        </criteriaItems>
        <description>Workflow to update &apos;Governance&apos; Alert Category to &apos;Severe&apos; Alert Severity Rating.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert Category Sales</fullName>
        <actions>
            <name>Alert_Severity_Rating_of_Informational</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Alert_Category__c</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <description>Workflow to update &apos;Sales&apos; Alert Category to &apos;Informational&apos; Alert Severity Rating.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inactivate Account Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Active_Alert__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Alert__c.Account_Alert_Expiry__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Inactivate the Account Alert once it exceeds the expiry date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Uncheck_Active_Alert_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account_Alert__c.Account_Alert_Expiry__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Record Type to Integration Account Alert</fullName>
        <actions>
            <name>Update_Record_Type_to_Integration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Source_System__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Triggers the change of record type to &apos;Integration Account Alert&apos; when the Source System of the Account Alert is populated via integration.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Sub-BU to Elite</fullName>
        <actions>
            <name>Update_Sub_BU_to_Elite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Source_System__c</field>
            <operation>equals</operation>
            <value>CRMoD</value>
        </criteriaItems>
        <description>Updates the Sub-BU field to Elite when an Alert is created via integration with CRMoD.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Sub-BU to UKI</fullName>
        <actions>
            <name>Update_Sub_BU_to_UKI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Alert__c.Source_System__c</field>
            <operation>equals</operation>
            <value>SAPMEP</value>
        </criteriaItems>
        <description>Updates the Sub-BU field to UKI when an Alert is created via integration with SAPMEP.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
