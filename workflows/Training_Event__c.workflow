<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Owner_and_Owner_s_Manager_to_close_training_event</fullName>
        <description>Notify Owner and Owner&apos;s Manager to close training event</description>
        <protected>false</protected>
        <recipients>
            <field>LCRM_Owner_s_Manager_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLI_Training_Email_Templates/Close_training_event_notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Owner_and_Owners_Manager</fullName>
        <description>Notify Owner and Owner&apos;s Manager</description>
        <protected>false</protected>
        <recipients>
            <field>LCRM_Owner_s_Manager_s_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLI_Training_Email_Templates/Status_NotificationVF</template>
    </alerts>
    <alerts>
        <fullName>Notifying_Opportunity_Owner</fullName>
        <description>Notifying Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <field>LCRM_Opportunity_Owner_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GLI_Training_Email_Templates/Notification_to_Opportunity_Owner</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_Offer_Code_field</fullName>
        <description>Populate Offer Code field based on selected Campaign Name.</description>
        <field>Offer_Code__c</field>
        <formula>Campaign_Name__r.Offer_Code__c</formula>
        <name>Populate Offer Code field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Tracking_Code</fullName>
        <description>As Campaign Name is populated, tracking code will assigned.</description>
        <field>Tracking_Code__c</field>
        <formula>Campaign_Name__r.Tracking_Code__c</formula>
        <name>Populate Tracking Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Close training event notification</fullName>
        <active>true</active>
        <description>This is to notify the trainer and his manager if a training event is not closed even after 5 working days of training date.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,LCRM_Is_GLI__c = True, RecordType.Name = &apos;GLI&apos;, Training_Date__c &lt;&gt; null, NOT(ISPICKVAL( Status__c , &apos;Completed&apos;)), LCRM_Sub_Bu__c = &apos;UKI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_Owner_and_Owner_s_Manager_to_close_training_event</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Training_Event__c.LCRM_5_Business_Days_from_training_date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notification to Opportunity Owner for a new training event</fullName>
        <active>true</active>
        <description>Whenever a new training event is created from an opportunity, the opportunity owner needs to be notified.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, LCRM_Is_GLI__c  = True, RecordType.Name = &apos;GLI&apos;, LCRM_Created_from_Opportunity__c = True,  Training_Date__c &lt;&gt; null)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notifying_Opportunity_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Training_Event__c.Training_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Offer Code field based on selected Campaign Name</fullName>
        <actions>
            <name>Populate_Offer_Code_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Tracking_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Offer Code field based on selected Campaign Name.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, ISNEW() || ISCHANGED( Campaign_Name__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Status notification</fullName>
        <active>true</active>
        <description>If the status of the training event is not changed from pending to contacted within two days, the owner and his manager need to be notified.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,LCRM_Is_GLI__c = True, RecordType.Name = &apos;GLI&apos;,   ISPICKVAL(Status__c , &apos;Pending&apos;) , LCRM_Sub_Bu__c = &apos;UKI&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_Owner_and_Owners_Manager</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Training_Event__c.LCRM2_business_days_from_record_creation__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
