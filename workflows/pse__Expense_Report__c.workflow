<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>pse__NotifySlack_ExpenseReport_Approval</fullName>
        <apiVersion>49.0</apiVersion>
        <endpointUrl>https://api-gateway.services.financialforce.com/api/salesforce/v1.0/approval</endpointUrl>
        <fields>Id</fields>
        <fields>OwnerId</fields>
        <fields>pse__Billable__c</fields>
        <fields>pse__First_Expense_Date__c</fields>
        <fields>pse__Project__c</fields>
        <fields>pse__Resource__c</fields>
        <fields>pse__Total_Billable_Amount__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>03380000000fequaa4@00d30000000plslea2</integrationUser>
        <name>Notify Slack - Expense Report - Approval</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>
