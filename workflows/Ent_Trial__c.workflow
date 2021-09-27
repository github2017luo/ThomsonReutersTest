<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Omni_Trial_Id_Populate</fullName>
        <description>Populate Trial Id (Ent Trial record Id 18 Digit) when record is created</description>
        <field>Trial_Id__c</field>
        <formula>Id &amp;

MID(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ012345&quot;,(
IF(FIND(MID(Id,1,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,1,0)
+IF(FIND(MID(Id,2,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,2,0)
+IF(FIND(MID(Id,3,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,4,0)
+IF(FIND(MID(Id,4,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,8,0)
+IF(FIND(MID(Id,5,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,16,0)
)+1,1)

&amp;

MID(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ012345&quot;,(
IF(FIND(MID(Id,6,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,1,0)
+IF(FIND(MID(Id,7,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,2,0)
+IF(FIND(MID(Id,8,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,4,0)
+IF(FIND(MID(Id,9,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,8,0)
+IF(FIND(MID(Id,10,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,16,0)
)+1,1)

&amp;

MID(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ012345&quot;,(
IF(FIND(MID(Id,11,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,1,0)
+IF(FIND(MID(Id,12,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,2,0)
+IF(FIND(MID(Id,13,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,4,0)
+IF(FIND(MID(Id,14,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,8,0)
+IF(FIND(MID(Id,15,1), &quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;)&gt;0,16,0)
)+1,1)</formula>
        <name>Omni Trial Id Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Entitlement_Completion_in_Trial</fullName>
        <field>Entitlement_Complete__c</field>
        <formula>NOW()</formula>
        <name>Update Entitlement Completion in Trial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Omni Trial Id Acc Name Org Type Populate</fullName>
        <actions>
            <name>Omni_Trial_Id_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Omni Trial - Populate Trial Id (18 digit record Id), Account Name, Organization Type when Ent Trial Record is created</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false, OR(ISCHANGED( Account__c ),  ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OmniTrialEntitlementCompletionFieldUpdate</fullName>
        <actions>
            <name>Update_Entitlement_Completion_in_Trial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Entitlement Completion Field when the Trial status is Active with todays date and time.</description>
        <formula>AND($Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c =false,  ISNULL(Entitlement_Complete__c ),ISPICKVAL(Trial_Status__c , &apos;Active&apos;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
