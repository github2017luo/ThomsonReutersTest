<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_update_end_date</fullName>
        <description>This field update is used to update the child campaign end date if parent id is selected</description>
        <field>EndDate</field>
        <formula>Parent.EndDate</formula>
        <name>Campaign update end date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_update_start_date</fullName>
        <description>This field update is used to update the child campaign start date field if parent id is selected</description>
        <field>StartDate</field>
        <formula>Parent.StartDate</formula>
        <name>Campaign update start date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Child_End_Date</fullName>
        <field>EndDate</field>
        <formula>Parent.EndDate</formula>
        <name>Update Child End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Child_Start_Date</fullName>
        <field>StartDate</field>
        <formula>Parent.StartDate</formula>
        <name>Update Child Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isGLI</fullName>
        <description>The value is false if user profile is not system administration or UKI GLI Marketing Users</description>
        <field>Is_GLI__c</field>
        <literalValue>1</literalValue>
        <name>isGLI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Campaign_update_start_date_and_end_date_of_child</fullName>
        <actions>
            <name>Campaign_update_end_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Campaign_update_start_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update start date and end date of child if parent campaign is selected</description>
        <formula>AND(  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = false,Is_GLI__c ==true , NOT(ISBLANK(ParentId)),  OR( ISNEW(), ISCHANGED(ParentId)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CampaignisGLI</fullName>
        <actions>
            <name>isGLI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The field is populated with “True” based on the logged in user through a Campaign for the GLI UKI users;</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = false,ISPICKVAL( $User.Sub_Bu__c ,&apos;UKI&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Child Date populated from parent date</fullName>
        <actions>
            <name>Update_Child_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Child_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Parent.Id !=null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
