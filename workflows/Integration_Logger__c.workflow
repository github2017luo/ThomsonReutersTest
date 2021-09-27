<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_an_email_to_TR_Store_Support_Team</fullName>
        <description>Send an email to TR Store Support Team</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TRStore_SupportEmailTemplate</template>
    </alerts>
    <rules>
        <fullName>TRStore_SendEmailToSupportTeam</fullName>
        <actions>
            <name>Send_an_email_to_TR_Store_Support_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Error_in_Lead_convert_Order_Process_flow</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Integration_Logger__c.Is_Escalated_to_Support__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Integration_Logger__c.Exception_Module__c</field>
            <operation>equals</operation>
            <value>TRStore</value>
        </criteriaItems>
        <description>When there is an exception while lead conversion/ ordder processing on TR Store, a task is created for support team and an email is sent to support team.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Error_in_Lead_convert_Order_Process_flow</fullName>
        <assignedTo>sandhyarani.sp@trpcorelegal.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>There is an error in Lead convert/ Order Process flow. Please check the error in mail, and resolve accordingly</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Pending</status>
        <subject>Error in Lead convert/ Order Process flow</subject>
    </tasks>
</Workflow>
