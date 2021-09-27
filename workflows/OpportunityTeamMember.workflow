<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LatAmPartnerUserNotif</fullName>
        <description>LatAmPartnerUserNotif DPS-19367</description>
        <protected>false</protected>
        <recipients>
            <recipient>LatAm Partner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderAddress>tr.sales@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>LATAM_Mail/LatAmPartnerUserNotif</template>
    </alerts>
    <fieldUpdates>
        <fullName>LatAm_PartnerSalesPercentage</fullName>
        <field>Sales_Percentage__c</field>
        <formula>IF(
	INCLUDES(Partner_Role__c,&apos;Partner Deal Hunter&apos;), 
	IF(
		INCLUDES(Partner_Role__c,&apos;Partner Pre-Sales&apos;), 
		IF(
			INCLUDES(Partner_Role__c,&apos;Partner Deal Closer&apos;),
			1.00,
			0.50
		),
		IF(
			INCLUDES(Partner_Role__c,&apos;Partner Deal Closer&apos;),
			0.75,
			0.25
		)
	), 
	IF(
		INCLUDES(Partner_Role__c,&apos;Partner Pre-Sales&apos;), 
		IF(
			INCLUDES(Partner_Role__c,&apos;Partner Deal Closer&apos;),
			0.75,
			0.25
		),
		IF(
			INCLUDES(Partner_Role__c,&apos;Partner Deal Closer&apos;),
			0.50,
			0
		)
	)
)</formula>
        <name>LatAm_PartnerSalesPercentage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LatAm Opportunity Partner Role Assign</fullName>
        <actions>
            <name>LatAm_PartnerSalesPercentage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Partner_Role__c)) &amp;&amp; NOT(ISCHANGED(Sales_Percentage__c)) &amp;&amp; ( ISNEW() || ISCHANGED(Partner_Role__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LatAmPartnerUserNotif</fullName>
        <actions>
            <name>LatAmPartnerUserNotif</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>LatAm Partner</value>
        </criteriaItems>
        <description>DPS-19367</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
