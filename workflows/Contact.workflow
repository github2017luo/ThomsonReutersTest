<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Conact_LRCM_Sub_BU</fullName>
        <field>LRCM_Created_by_SubBU__c</field>
        <formula>TEXT($User.Sub_Bu__c)</formula>
        <name>Conact_LRCM_ Sub_BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LCRM_Update_is_CDS_Flag_to_True</fullName>
        <field>LCRM_Is_CDS_Ready__c</field>
        <literalValue>1</literalValue>
        <name>Update is CDS Flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mailing_Country</fullName>
        <field>MailingCountry</field>
        <formula>CASE(MailingCountry, &apos;United States&apos;, &apos;US&apos;, &apos;Australia&apos;, &apos;AU&apos;,&apos;South Africa&apos;, &apos;ZA&apos;, &apos;Singapore&apos; , &apos;SG&apos;,&apos;New Zealand&apos;, &apos;NZ&apos;, 
&apos;Ireland&apos;, &apos;IE&apos;, 
&apos;India&apos;, &apos;IN&apos;, 
&apos;Canada&apos;, &apos;CA&apos;, 
&apos;Brazil&apos;, &apos;BR&apos;, 
&apos;United Kingdom&apos;, &apos;GB&apos;
,MailingCountry)</formula>
        <name>Mailing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Contact_Email_2_with_SAP_Email</fullName>
        <field>Email</field>
        <formula>SAP_Email_1__c</formula>
        <name>Populate Contact Email 2 with SAP Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_type_to_GLI_Contact</fullName>
        <field>RecordTypeId</field>
        <lookupValue>GLI_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record type to GLI Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_type_to_GLI_Contact_CDS</fullName>
        <field>RecordTypeId</field>
        <lookupValue>GLI_Contact_CDS</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record type to GLI Contact - CDS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WPD_Record_To_TRUE</fullName>
        <field>WPD_Record__c</field>
        <literalValue>1</literalValue>
        <name>Set WPD_Record__c To TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_First_Name</fullName>
        <description>Update Contact First Name to Upper Case</description>
        <field>FirstName</field>
        <formula>UPPER(FirstName )</formula>
        <name>Update Contact First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Inactivated_Date</fullName>
        <field>Contact_Inactivated_Date__c</field>
        <formula>today()</formula>
        <name>Update Contact Inactivated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Last_Name</fullName>
        <description>Update Contact Last Name to Upper Case</description>
        <field>LastName</field>
        <formula>UPPER(LastName )</formula>
        <name>Update Contact Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Owner_to_Informatica_User</fullName>
        <description>When GLI Contact is created, the Contact owner is updated to &quot;Informatica GLI Integration&quot;.</description>
        <field>OwnerId</field>
        <lookupValue>informatica_gli_integration@trpcorelegal.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Contact Owner to Informatica User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_SAP_Phone</fullName>
        <description>Phone is Contact SAP Phone 1</description>
        <field>Phone</field>
        <formula>Work_Direct__c</formula>
        <name>Update Contact SAP Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateAccountSapPhone</fullName>
        <description>workflow rule to update Account SAP phone field</description>
        <field>Account_SAP_Phone1__c</field>
        <formula>Account.Phone</formula>
        <name>updateAccountSapPhone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CONTACT-Update Contact Name to Upper Case</fullName>
        <actions>
            <name>Update_Contact_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Contact_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Contact Name to Upper Case</description>
        <formula>AND( NOT( ISBLANK( FirstName ) ) , NOT( ISBLANK(  LastName ) ),$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = False, LCRM_Is_GLI__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Data%2Ecom Country</fullName>
        <actions>
            <name>Mailing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule changes the country to the 2 digit code on the contact record when it is brought over from data.com</description>
        <formula>AND( MailingCountry  &lt;&gt; &quot;x&quot;,$Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Inactivated Date</fullName>
        <actions>
            <name>Update_Contact_Inactivated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggers the update of the &apos;Contact Inactivated Date&apos; when a Contact is marked &apos;Contact Inactive&apos;</description>
        <formula>AND(Contact_Inactive__c  = True,  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Phone Update for Work Direct</fullName>
        <actions>
            <name>Update_Contact_SAP_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Keep the Work Direct Phone in sync with the Contact SAP Phone 1 field (Phone)</description>
        <formula>AND(NOT(LCRM_Is_GLI__c), ISBLANK(SAP_Contact_ID__c), Phone &lt;&gt; Work_Direct__c, $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact record type changed to GLI Contact</fullName>
        <actions>
            <name>Record_type_to_GLI_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the current record type is GLI Contact - CDS and Is CDS Ready is changed to false, then record type is changed to GLI Contact.</description>
        <formula>AND(RecordType.Name = &apos;GLI Contact - CDS&apos; ,  LCRM_Is_GLI__c = True, LCRM_Is_CDS_Ready__c  =  False, $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact record type changed to GLI Contact - CDS</fullName>
        <actions>
            <name>Record_type_to_GLI_Contact_CDS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Once the “Is CDS Ready” flag is set to “True” and “Is GLI” = True, the record type is changed to GLI Contact - CDS.</description>
        <formula>AND(RecordType.Name = &apos;GLI Contact&apos; ,  LCRM_Is_CDS_Ready__c  =  True ,  LCRM_Is_GLI__c = True, $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LRCM_Sub_BU</fullName>
        <actions>
            <name>Conact_LRCM_Sub_BU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the Sub-BU of the created user</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False, OR( ISPICKVAL($User.Sub_Bu__c,&quot;Elite&quot;), ISPICKVAL($User.Sub_Bu__c,&quot;UKI&quot;), ISPICKVAL($User.Sub_Bu__c,&quot;LMS&quot;), ISPICKVAL($User.Sub_Bu__c,&quot;USL&quot;), ISPICKVAL($User.Sub_Bu__c,&quot;FindLaw&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Contact Email 2</fullName>
        <actions>
            <name>Populate_Contact_Email_2_with_SAP_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNULL(Email) ||  ISBLANK( Email ) &amp;&amp; ( PRIORVALUE(Email )=Email ) &amp;&amp; NOT(LCRM_Is_GLI__c) &amp;&amp;  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Test For WPD Contact</fullName>
        <actions>
            <name>Set_WPD_Record_To_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ((not (isblank(WLEC_External_Id__c))  || contains(CreatedBy.Profile.Name,&apos;WPD&apos;)), $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact Owner to Informatica User</fullName>
        <actions>
            <name>Update_Contact_Owner_to_Informatica_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When GLI Contact is created, the Contact owner is updated to &quot;Informatica GLI Integration&quot;</description>
        <formula>AND(Account.Is_GLI__c = True,  $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = False)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update is CDS Ready</fullName>
        <actions>
            <name>LCRM_Update_is_CDS_Flag_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule created by LCRM to update &quot;Is CDS Ready&quot; field based on Email StrikeIron validation</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c  = False,Account.Is_GLI__c=True,  OR(NOT(ISBLANK(Email)),Email!= NULL) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>updateAccountSapPhone</fullName>
        <actions>
            <name>updateAccountSapPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>updates the Account SAP Phone field from Account Phone field.</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = False, NOT(LCRM_Is_GLI__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
