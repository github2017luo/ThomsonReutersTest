<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>User_Follow_up_date</fullName>
        <ccEmails>crmsupport@thomsonreuters.com</ccEmails>
        <description>User Follow up date</description>
        <protected>false</protected>
        <senderAddress>thomsonreuterscustomersupport@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/User_Follow_up_date_template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Temporary_Access_to_User</fullName>
        <description>Grant temporary access to user</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Temporary Access to User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Email alert for Follow up date</fullName>
        <actions>
            <name>User_Follow_up_date</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email alert will be sent to CRM team on updating User Follow up date field</description>
        <formula>AND( ISCHANGED(Follow_up_Date__c),  NOT(ISNULL(Follow_up_Date__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
