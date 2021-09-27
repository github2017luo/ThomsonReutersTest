<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Omni_TrialContact_AcceptTermsDate_Udpate</fullName>
        <description>Omni Trial Contact Accept Terms Date Update tp today date when Trial contact status to Accepted</description>
        <field>Accept_Terms_Date__c</field>
        <formula>NOW()</formula>
        <name>Omni TrialContact AcceptTermsDate Udpate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Omni_Trial_Contact_Unique_Name_Populate</fullName>
        <description>Omni Trial Contact Unique Name Update</description>
        <field>Unique_Name__c</field>
        <formula>TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;-&quot; +TEXT(MONTH(DATEVALUE(CreatedDate)))+&quot;-&quot; +TEXT(DAY(DATEVALUE(CreatedDate)))+&apos;|&apos;+Email__c</formula>
        <name>Omni Trial Contact Unique Name Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>TimedOut</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Trial_Contact_Name_Update</fullName>
        <field>Name</field>
        <formula>LEFT(First_Name__c  + &apos; &apos;+ Last_Name__c,80)</formula>
        <name>Trial Contact Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Trial_Primary_Contact_Update</fullName>
        <description>populate First Name last name of Primary Trial Contact</description>
        <field>Primary_Contact__c</field>
        <formula>First_Name__c +&apos; &apos;+ Last_Name__c</formula>
        <name>Trial Primary Contact Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Trials__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Entitlement_Completion_Field</fullName>
        <field>Entitlement_Completion__c</field>
        <formula>NOW()</formula>
        <name>Update Entitlement Completion Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Omni Trial Contact Accept Terms Date Update</fullName>
        <actions>
            <name>Omni_TrialContact_AcceptTermsDate_Udpate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Omni Trial Contact Accept Terms Date Update - Update today date if status is Accepted</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, OR(AND(ISCHANGED( Status__c), Text(Status__c) = &quot;Accepted&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Omni Trial Contact Unique Name Update</fullName>
        <actions>
            <name>Omni_Trial_Contact_Unique_Name_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Omni Trial Contact Unique Name Update</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, OR(ISCHANGED( Email__c ), ISBLANK( Unique_Name__c ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OmniTrialContactEntitlementCompletionFieldUpdate</fullName>
        <actions>
            <name>Update_Entitlement_Completion_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Entitlement Completion Field when the Trial contact status is Active with todays date.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, ISPICKVAL(Status__c , &apos;Active&apos;),  ISNULL(Entitlement_Completion__c)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OmniTrialContactStatusUpdate</fullName>
        <active>true</active>
        <description>This Rule will fire when the status is not updating from Invited to Accepted within the End_Date and then updating the status to TimedOut</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, AND(ISPICKVAL(Status__c   ,&apos;Invited&apos; ), Not(ISPICKVAL(Status__c   ,&apos;Accepted&apos; ))))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Status_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Trial_Contact__c.End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Trial Contact Name Update</fullName>
        <actions>
            <name>Trial_Contact_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Omni Enterprise Trial</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, OR(ISCHANGED( First_Name__c ), ISNEW(), ISCHANGED( Last_Name__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Trial Primary Contact Update</fullName>
        <actions>
            <name>Trial_Primary_Contact_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Primary Contact Firsname Last name in Primary COntact field on Trial</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,Primary__c, OR(ISNEW(), ISCHANGED( Last_Name__c ),ISCHANGED( First_Name__c ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
