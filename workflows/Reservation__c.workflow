<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Partner_from_Reservation_Approval</fullName>
        <description>Alert Partner from Reservation Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Approved_Reservation_from_Partner_Portal</template>
    </alerts>
    <alerts>
        <fullName>Alert_Partner_from_Reservation_Approval_NT</fullName>
        <description>Alert Partner from Reservation Approval NT</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Approved_Reservation_from_Partner_Portal</template>
    </alerts>
    <alerts>
        <fullName>Alert_Partner_from_Reservation_Approval_RT</fullName>
        <description>Alert Partner from Reservation Approval RT</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Approved_Reservation_from_Partner_Portal</template>
    </alerts>
    <alerts>
        <fullName>Alert_Partner_from_Reservation_Rejection</fullName>
        <description>Alert Partner from Reservation Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Rejected_Reservation_from_Partner_Portal</template>
    </alerts>
    <alerts>
        <fullName>Alert_Partner_from_Reservation_Rejection_NT</fullName>
        <description>Alert Partner from Reservation Rejection NT</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Rejected_Reservation_from_Partner_Portal</template>
    </alerts>
    <alerts>
        <fullName>Alert_Partner_from_Reservation_Rejection_RT</fullName>
        <description>Alert Partner from Reservation Rejection RT</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Rejected_Reservation_from_Partner_Portal</template>
    </alerts>
    <alerts>
        <fullName>Reservation_Expires_in_7_days</fullName>
        <description>Reservation Expires in 7 days</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Reservation_Near_Experation</template>
    </alerts>
    <alerts>
        <fullName>Reservation_will_expire_in_7_days</fullName>
        <description>Reservation will expire in 7 days</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Portal_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Reservation_Near_Experation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Activate_a_reservation_after_approval</fullName>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Activate a reservation after approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Activate_a_reservation_after_approval_NT</fullName>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Activate a reservation after approval NT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Activate_a_reservation_after_approval_RT</fullName>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Activate a reservation after approval RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Res_NT</fullName>
        <description>Approval Status updated to Approved  -  Latam Partner Portal Novaprolink /Tedesco Approval process.</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Field Update Res NT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Res_RT</fullName>
        <description>Approval Status updated to Approved  -  Latam Partner Portal Revista Approval Process</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Field Update Res RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Res_Rej_NT</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Field Update Res Rej NT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Res_Rej_RT</fullName>
        <description>Approval Status updated to Rejected  -  Latam Partner Portal Portal Revista Rejected Process.</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Field Update Res Rej RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Res_Reject</fullName>
        <description>Approval Status field update for Reservations  -  Latam Partner Portal Mastersaf rejected process</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Field Update- Res Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update_Reservation</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Field Update Reservation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disable_Expired_Reservation</fullName>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Disable Expired Reservation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reservation_Approval_Status_Field_Update</fullName>
        <description>When a reservation is created internally by a Latam user the field Approval Status need to be marked as Approved.</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Reservation Approval Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Activate the Approved Reservation for Partner Portal Users</fullName>
        <actions>
            <name>Activate_a_reservation_after_approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Reservation__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Disable the Active checkbox of Reservation until Reservation Approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Disable Default Active Reservation for Partner Portal Users</fullName>
        <actions>
            <name>Disable_Expired_Reservation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Disable the Active checkbox of Reservation until Reservation Approved.</description>
        <formula>AND($Profile.Name = &quot;Partner Portal User&quot;,   Active__c = True, NOT(ISPICKVAL(Approval_Status__c, &quot;Approved&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Disable Expired Reservation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Reservation__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Reservation__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disable_Expired_Reservation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Reservation__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Reservation Approval Status Update</fullName>
        <actions>
            <name>Reservation_Approval_Status_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a reservation is created internally by a Latam user the field Approval Status need to be marked as Approved.</description>
        <formula>$Profile.Name = &quot;LatAm User&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Reservation Expires in 7 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Reservation__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Reservation__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reservation_will_expire_in_7_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Reservation__c.End_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
