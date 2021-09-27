<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SendEmailWhenIdeaUpdated</fullName>
        <description>SendEmailWhenIdeaUpdated</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/IdeaCreatedEmailTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>Updatename</fullName>
        <field>Name__c</field>
        <formula>$User.FirstName+&apos; &apos;+ $User.LastName</formula>
        <name>Updatename</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>SendEmailWhenIdeaUpdated</fullName>
        <actions>
            <name>SendEmailWhenIdeaUpdated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent to the creator of Idea.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update name</fullName>
        <actions>
            <name>Updatename</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
