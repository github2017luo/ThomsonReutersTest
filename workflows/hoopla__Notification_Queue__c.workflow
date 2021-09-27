<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>hoopla__Hoopla_Notification_Messaging</fullName>
        <apiVersion>23.0</apiVersion>
        <endpointUrl>https://hoopla-notify.herokuapp.com/notify</endpointUrl>
        <fields>CreatedDate</fields>
        <fields>Id</fields>
        <fields>hoopla__Message_ID__c</fields>
        <fields>hoopla__Message_Token__c</fields>
        <fields>hoopla__Message_Type__c</fields>
        <fields>hoopla__Message__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>shawn.gray@trpcorelegal.com</integrationUser>
        <name>Hoopla Notification Messaging</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>hoopla__Process Notifications</fullName>
        <actions>
            <name>hoopla__Hoopla_Notification_Messaging</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>hoopla__Notification_Queue__c.hoopla__Message_ID__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
