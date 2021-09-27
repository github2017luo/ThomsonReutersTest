<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>USL_Write_Off</fullName>
        <ccEmails>west.arsupportstaff@thomson.com</ccEmails>
        <description>USL Write Off</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>USL_Service_Cloud_Internal_Templates/Write_Off_Enhancements1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Id_update</fullName>
        <field>ESC_Approver_Id__c</field>
        <formula>$User.EmployeeNumber</formula>
        <name>Approval Id update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Name_update</fullName>
        <field>USL_Approver_name__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Approval Name update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Status_Update</fullName>
        <field>USL_Approval_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Rejected Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USL_Initial_Status_Update</fullName>
        <field>USL_Approval_Status__c</field>
        <formula>&quot;Awaiting Approval&quot;</formula>
        <name>Initial Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USL_Recall_Status_Update</fullName>
        <field>USL_Approval_Status__c</field>
        <formula>&quot;Recall&quot;</formula>
        <name>Recall Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>USL_Status_update</fullName>
        <field>USL_Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
