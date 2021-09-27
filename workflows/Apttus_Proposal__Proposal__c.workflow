<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APTS_AutoPay_Email</fullName>
        <description>APTS AutoPay Email</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Order_Confirmation_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_AutoPay_Form_Template</template>
    </alerts>
    <alerts>
        <fullName>APTS_AutoPay_PE_Email</fullName>
        <description>APTS AutoPay PE Email</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Order_Confirmation_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_AutoPay_PE_Form_Template</template>
    </alerts>
    <alerts>
        <fullName>APTS_Send_Order_Rejection_email_to_rep</fullName>
        <description>APTS_Send Order Rejection email to rep</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_OrderRejectionEmailTemplate</template>
    </alerts>
    <alerts>
        <fullName>Digital_Quote_Failure_Reason_Email</fullName>
        <ccEmails>EBSCXDigitalSupport@thomsonreuters.com</ccEmails>
        <description>Digital Quote Failure Reason Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Digital_Quote_Failure_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Send_Mail_To_CVM</fullName>
        <description>Email Alert to Send Mail To CVM</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_CVM_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/Apttus_Special_Offer_email_template</template>
    </alerts>
    <alerts>
        <fullName>Forward_to_signee</fullName>
        <description>Forward to signee</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Order_Confirmation_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Forward_To_Signee1</template>
    </alerts>
    <alerts>
        <fullName>NACI_Form_Email</fullName>
        <description>NACI Form Email</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Order_Confirmation_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>customerservice@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_NACI_Form_Template_Fr</template>
    </alerts>
    <alerts>
        <fullName>NSE_Order_Complete_Alert</fullName>
        <description>NSE Order Complete Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Opp_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>tr.sales@thomsonreuters.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/NSE_Account_Executive_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_EBS_CX_Digital_Support</fullName>
        <ccEmails>EBSCXDigitalSupport@thomsonreuters.com</ccEmails>
        <description>Notify EBS CX Digital Support</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Proposal_Not_Updated_to_Accepted</template>
    </alerts>
    <alerts>
        <fullName>Notifyy_CX_Digital_Support</fullName>
        <ccEmails>APP-CX-DIGITAL@thomson.com</ccEmails>
        <description>Notifyy CX Digital Support</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Digital_proposal_not_accepted</template>
    </alerts>
    <alerts>
        <fullName>Order_Confirmation_Contact</fullName>
        <description>Order Confirmation Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Previous_Order_Confirmation_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Order_confirmation_Contact_update</template>
    </alerts>
    <alerts>
        <fullName>TR_Store_French_Order_Confirmation_Email_Alert</fullName>
        <description>TR Store French Order Confirmation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Order_Confirmation_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>customersupport.legaltaxcanada@tr.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/TRStore_Order_Confirmation_Email_French</template>
    </alerts>
    <alerts>
        <fullName>TR_Store_Order_Confirmation_Email_Alert</fullName>
        <description>TR Store Order Confirmation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>APTS_Order_Confirmation_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>customersupport.legaltaxcanada@tr.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/TRStore_Order_Confirmation_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>APTS_Check_COB_Default</fullName>
        <description>To make the checkbox false</description>
        <field>APTS_Check_COB__c</field>
        <literalValue>0</literalValue>
        <name>APTS_Check_COB_Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Clear_Quote_Validity_Override</fullName>
        <field>APTS_Quote_Validity_Override__c</field>
        <name>APTS Clear Quote Validity Override</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Record_Type_Special_Offer</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SpecialOffer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS Record Type Special Offer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Uncheck_Credit_Check_Field</fullName>
        <field>Credit_Check_Flag__c</field>
        <literalValue>0</literalValue>
        <name>APTS Uncheck Credit Check Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Uncheck_LMS_Field_Update</fullName>
        <field>APTS_LMS_Catalog__c</field>
        <literalValue>0</literalValue>
        <name>APTS Uncheck LMS Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Uncheck_NACI_Field</fullName>
        <field>APTS_Send_NACI_Form__c</field>
        <literalValue>0</literalValue>
        <name>APTS Uncheck NACI Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateApprovalStage</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>APTS_UpdateApprovalStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRenewalProposalName</fullName>
        <description>Update Renewal proposal name to limit 80 characters.</description>
        <field>Apttus_Proposal__Proposal_Name__c</field>
        <formula>LEFT(TRIM(Apttus_Proposal__Proposal_Name__c),80)</formula>
        <name>APTS_UpdateRenewalProposalName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Approval_St_to_Not_Submitted</fullName>
        <field>Apttus_QPApprov__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Update Approval Status to Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Credit_Check_Field</fullName>
        <field>Credit_Check_Flag__c</field>
        <literalValue>1</literalValue>
        <name>APTS Update Credit Check Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Email_Confirmation_Contact</fullName>
        <field>APTS_Order_Confirmation_Contact_Email__c</field>
        <formula>APTS_Order_Confirmation_Contact__r.Email</formula>
        <name>APTS Update Email Confirmation Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Proposal_Business_Unit</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>FindLaw</literalValue>
        <name>APTS Update Proposal Business Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Ready_To_Generate</fullName>
        <field>Apttus_Proposal__ReadyToGenerate__c</field>
        <literalValue>1</literalValue>
        <name>Check Ready To Generate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Not_in_Sync</fullName>
        <field>DC_Contract_Not_In_Sync__c</field>
        <literalValue>1</literalValue>
        <name>Contract Not in Sync</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Digital_Proposal_Update_Env_ID</fullName>
        <description>Update the DocuSign Envelope ID field to null if this is a cloned proposal</description>
        <field>DocuSign_Envelope_ID__c</field>
        <name>Digital Proposal Update Env ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forward_signee</fullName>
        <field>Forward_to_signee__c</field>
        <literalValue>0</literalValue>
        <name>Reset Forward signee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NACI_FORM_Resend</fullName>
        <field>CreditincreaseEmailButton__c</field>
        <literalValue>1</literalValue>
        <name>NACI FORM Resend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_in_Sync</fullName>
        <field>DC_Contract_Not_In_Sync__c</field>
        <literalValue>1</literalValue>
        <name>Not in Sync</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PBU_set_to_Canada</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>Canada</literalValue>
        <name>PBU set to Canada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposal_Business_Unit_to_Corp_OneOTC_UK</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>Corp OneOTC UK</literalValue>
        <name>Proposal Business Unit to Corp OneOTC UK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposal_Business_Unit_to_Corp_OneOTC_US</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>Corp OneOTC US</literalValue>
        <name>Proposal Business Unit to Corp OneOTC US</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_Method_Canada</fullName>
        <field>APTS_Ground_Shipping__c</field>
        <literalValue>International best Rate</literalValue>
        <name>Shipping Method Canada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TaxProfBU</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>Tax Professional</literalValue>
        <name>TaxProfBU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Ready_To_Generate</fullName>
        <field>Apttus_Proposal__ReadyToGenerate__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Ready To Generate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordType</fullName>
        <description>Updates record type to &apos;Expired Proposal&apos;</description>
        <field>RecordTypeId</field>
        <lookupValue>Expired_Proposal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Findlaw_quote_Business_Unit</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>FindLaw</literalValue>
        <name>Update Findlaw quote Business Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Order_Confirmation_Email_Field</fullName>
        <field>APTS_Order_Confirmation_Contact_Email__c</field>
        <formula>APTS_Order_Confirmation_Contact__r.Email</formula>
        <name>Update Order Confirmation Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proposal_Business_Unit_to_SCS</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>SCS</literalValue>
        <name>Update Proposal Business Unit to SCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sent_to_CVM</fullName>
        <field>APTS_CVM_Email_Sent__c</field>
        <literalValue>0</literalValue>
        <name>Update Sent to CVM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_quote_Business_Unit</fullName>
        <field>APTS_Proposal_Business_Unit__c</field>
        <literalValue>SCS</literalValue>
        <name>Update quote Business Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>APTS Email - AutoPay</fullName>
        <actions>
            <name>APTS_AutoPay_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND((!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c),ISPICKVAL(Apttus_Proposal__Approval_Stage__c ,&quot;Accepted&quot;), ISPICKVAL( APTS_Payment_Option__c ,&quot;Autocharge&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS Email - AutoPay with PE</fullName>
        <actions>
            <name>APTS_AutoPay_PE_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND((!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c),ISPICKVAL(Apttus_Proposal__Approval_Stage__c ,&quot;Accepted&quot;), ISPICKVAL( APTS_Payment_Option__c ,&quot;Autocharge with Payment Express&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS Email - NACI Form</fullName>
        <actions>
            <name>NACI_Form_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NACI_FORM_Resend</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 	(!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c), 	NOT(ISBLANK(APTS_PaymentGateway_URL__c)), 	OR( 		APTS_Send_NACI_Form__c, 		APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c == &apos;&apos;, 		APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c == &apos;NEW&apos;, 		APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c == &apos;INA&apos; 	), 	TEXT(Apttus_Proposal__Approval_Stage__c) == &apos;Accepted&apos;, 	AND( 		APTS_SSD_Sold_To__r.LCRM_Customer_Group__c != &apos;GOVERNMENT&apos;, 		APTS_SSD_Sold_To__r.LCRM_Customer_Group__c != &apos;FEDERAL GOVERNMENT&apos; 	), 	IF( 		NOT(ISPICKVAL(APTS_Proposal_Business_Unit__c, &apos;Tax Professional&apos;)) &amp;&amp; 		APTS_Send_NACI_Form__c &amp;&amp;  		APTS_NACI_Form__c,  		true, 		false 	) ,  	NOT( ISPICKVAL( Digital_Quote_Type__c, &apos;New Sales&apos;) ) ,  	ISPICKVAL( TR_Store_Source__c , &apos;&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS Send Mail To CVM</fullName>
        <actions>
            <name>Email_Alert_to_Send_Mail_To_CVM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Sent_to_CVM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Send Mail to CVM on click of button &apos;Send To CVM&apos;</description>
        <formula>AND((!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c), APTS_CVM_Email_Sent__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Ready to Generate</fullName>
        <actions>
            <name>Check_Ready_To_Generate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), TEXT( APTS_Proposal_Business_Unit__c) = &quot;FindLaw&quot;) , AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), TEXT( APTS_Proposal_Business_Unit__c) = &quot;Canada&quot;) , AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), TEXT( APTS_Proposal_Business_Unit__c) = &quot;Corp OneOTC US&quot;) , AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), TEXT( APTS_Proposal_Business_Unit__c) = &quot;Corp OneOTC UK&quot;) , AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), TEXT( APTS_Proposal_Business_Unit__c) = &quot;SCS&quot;, NOT(ISBLANK ( APTS_Order_Confirmation_Contact__r.Email )) ), AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), TEXT( APTS_Proposal_Business_Unit__c) = &quot;Tax Professional&quot;), AND( NOT(ISBLANK( Apttus_QPConfig__ConfigurationFinalizedDate__c )), OR(TEXT( APTS_Proposal_Business_Unit__c) = &quot;Argentina-LLEY&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Brazil-TSL&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Hong Kong-SMHK&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;India-INWL&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Australia-PNG-LRA&quot;,TEXT(APTS_Proposal_Business_Unit__c) = &quot;NZ-Fiji-BKRS&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;FACT-TRFR&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Russia-1S&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;SouthKorea-DUZON&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;SMGE&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Dofiscal&quot;) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Special Offer Record Type</fullName>
        <actions>
            <name>APTS_Record_Type_Special_Offer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Quote_Type__c</field>
            <operation>equals</operation>
            <value>Special Offer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS Tax Email - NACI Form</fullName>
        <actions>
            <name>NACI_Form_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NACI_FORM_Resend</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 	(!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c), 	ISPICKVAL(APTS_Proposal_Business_Unit__c, &apos;Tax Professional&apos;), 	TEXT(Apttus_Proposal__Approval_Stage__c) = &apos;Accepted&apos;, 	CreditincreaseEmailButton__c=false, 	APTS_Sold_To_SAP_Account_Number__c != null, 	NOT(ISBLANK(APTS_PaymentGateway_URL__c)), 	OR( 		APTS_Send_NACI_Form__c, 		APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c == &apos;&apos;, 		CONTAINS(APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c, &apos;NEW&apos;), 		APTS_SSD_Sold_To__r.LCRM_Credit_Risk_Category__c == &apos;INA&apos; 	), 	AND( 		APTS_SSD_Sold_To__r.LCRM_Customer_Group__c != &apos;GOVERNMENT&apos;, 		APTS_SSD_Sold_To__r.LCRM_Customer_Group__c != &apos;FEDERAL GOVERNMENT&apos; 	), 	OR( 		ISPICKVAL(APTS_Payment_Option__c, &apos;Auto EFT/Auto Charge&apos;), 		ISPICKVAL(APTS_Payment_Option__c, &apos;Bill to Account&apos;) 	), 	OR( 		APTS_SSD_Sold_To__r.APTS_Is_Customer__c = false, 		AND( 			APTS_SSD_Sold_To__r.APTS_Is_Customer__c = true, 			APTS_SSD_Sold_To__r.Default_Payment_Method__c != &apos;Auto EFT/Auto Charge&apos;, 			APTS_SSD_Sold_To__r.Default_Payment_Method__c != &apos;Bill to Account&apos; 		) 	), 	NOT( ISPICKVAL( Digital_Quote_Type__c, &apos;New Sales&apos;) ) ,  	ISPICKVAL( TR_Store_Source__c , &apos;&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Uncheck LMS Flag</fullName>
        <actions>
            <name>APTS_Uncheck_LMS_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Proposal_Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>SCS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_LMS_Catalog__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Uncheck NACI field</fullName>
        <actions>
            <name>APTS_Uncheck_Credit_Check_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_Uncheck_NACI_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>5 AND (1 OR (1 AND 2) OR (1 AND 3) OR 4 OR (2 AND 4))</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Payment_Option__c</field>
            <operation>equals</operation>
            <value>Payment Express Auto EFT/Auto Charge</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Send_NACI_Form__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Credit_Check_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Payment_Option__c</field>
            <operation>equals</operation>
            <value>Credit Card</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Tax Professional</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Uncheck Ready to Generate</fullName>
        <actions>
            <name>Uncheck_Ready_To_Generate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK(Apttus_QPConfig__ConfigurationFinalizedDate__c), AND ( TEXT( APTS_Proposal_Business_Unit__c) = &quot;SCS&quot;, ISBLANK ( APTS_Order_Confirmation_Contact__r.Email ) ), AND ( TEXT( APTS_Proposal_Business_Unit__c) = &quot;FindLaw&quot;, ISBLANK ( APTS_Order_Confirmation_Contact__r.Email ) ), AND( TEXT( APTS_Proposal_Business_Unit__c) = &quot;Canada&quot; , OR( ISBLANK ( APTS_Order_Confirmation_Contact__r.Email ) , ( NOT(APTS_Ebilling_exempt__c) &amp;&amp; ( APTS_Ebilling_contact__r.Email==null || APTS_Ebilling_contact__c==null ) ) ) ) , AND ( TEXT( APTS_Proposal_Business_Unit__c) = &quot;Corp OneOTC US&quot;, ISBLANK ( APTS_Order_Confirmation_Contact__r.Email ) ), AND ( TEXT( APTS_Proposal_Business_Unit__c) = &quot;Corp OneOTC UK&quot;, ISBLANK ( APTS_Order_Confirmation_Contact__r.Email ) ), AND ( TEXT( APTS_Proposal_Business_Unit__c) = &quot;Tax Professional&quot;, OR( ISBLANK ( APTS_Order_Confirmation_Contact__r.Email), ISPICKVAL(Apttus_Proposal__Approval_Stage__c,&quot;In Review&quot;), ISPICKVAL(Apttus_Proposal__Approval_Stage__c,&quot;Approval Required&quot;) ) ),AND( ISBLANK ( APTS_Order_Confirmation_Contact__r.Email ), OR(TEXT( APTS_Proposal_Business_Unit__c) = &quot;Argentina-LLEY&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Brazil-TSL&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Hong Kong-SMHK&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;India-INWL&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Australia-PNG-LRA&quot;,TEXT(APTS_Proposal_Business_Unit__c) = &quot;NZ-Fiji-BKRS&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;FACT-TRFR&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Russia-1S&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;SouthKorea-DUZON&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;SMGE&quot;,TEXT( APTS_Proposal_Business_Unit__c) = &quot;Dofiscal&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Credit Flag</fullName>
        <actions>
            <name>APTS_Update_Credit_Check_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  	TEXT( APTS_Proposal_Business_Unit__c )  = &apos;Tax Professional&apos;, 	Credit_Check_Flag__c = false,  	OR( 		APTS_SSD_Sold_To__r.APTS_Is_Customer__c = false, 		AND( 			APTS_SSD_Sold_To__r.APTS_Is_Customer__c = true, 			APTS_SSD_Sold_To__r.Default_Payment_Method__c != TEXT(APTS_Payment_Option__c) 		) 	), 	AND( 		TEXT(APTS_Payment_Option__c)  &lt;&gt; &apos;Payment Express Auto EFT/Auto Charge&apos;, 		TEXT(APTS_Payment_Option__c)  &lt;&gt; &apos;One Time EFT&apos;, 		TEXT(APTS_Payment_Option__c)  &lt;&gt; &apos;Credit Card&apos; 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Email Confirmation Contact</fullName>
        <actions>
            <name>Update_Order_Confirmation_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( APTS_Order_Confirmation_Contact__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Proposal Business Unit to Canada</fullName>
        <actions>
            <name>PBU_set_to_Canada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF(OR(TEXT(Owner:User.Sub_Bu__c)== $Label.SALESORGCAN , AND( TEXT(Owner:User.Sub_Bu__c) == $Label.SUBBUGLOBAL , Apttus_Proposal__Opportunity__r.LCRM_Sub_BU__c = $Label.SALESORGCAN),AND(TEXT($User.Sub_Bu__c) == $Label.SALESORGTAXREG, TEXT($User.Segment__c) == $Label.SALESORGTAX , TEXT( Apttus_Proposal__Opportunity__r.Source_System_Detail__r.LCRM_Sales_Org__c) == $Label.SALESORGCARS), AND( OR( TEXT($User.Sub_Bu__c) == $Label.SUBBUGLOBAL ,TEXT( $User.Segment__c ) == $Label.SUBBUGLOBAL),TEXT( Apttus_Proposal__Opportunity__r.Source_System_Detail__r.LCRM_Sales_Org__c) == $Label.SALESORGCARS)) ,True,False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Proposal Business Unit to Corp OneOTC UK</fullName>
        <actions>
            <name>Proposal_Business_Unit_to_Corp_OneOTC_UK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  	ISBLANK(  			TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c ) ),ISPICKVAL( Apttus_Proposal__Opportunity__r.Source_System_Detail__r.LCRM_Sales_Org__c , &apos;TA61&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Proposal Business Unit to Corp OneOTC US</fullName>
        <actions>
            <name>Proposal_Business_Unit_to_Corp_OneOTC_US</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  	ISBLANK(  			TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c ) ),		  	OR(  		ISPICKVAL( Apttus_Proposal__Opportunity__r.Source_System_Detail__r.LCRM_Sales_Org__c , &apos;OneOTC US&apos;),  		ISPICKVAL( Apttus_Proposal__Opportunity__r.Source_System_Detail__r.LCRM_Sales_Org__c , &apos;TA78&apos;)  		)  	)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Proposal Business Unit to FindLaw</fullName>
        <actions>
            <name>APTS_Update_Proposal_Business_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( AND(  ISBLANK( TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c ) ) ,ISPICKVAL(Owner:User.Default_Catalog__c , &apos;FindLaw&apos;) ), AND(ISPICKVAL(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;),ISPICKVAL(Owner:User.Default_Catalog__c ,&apos;LMS&apos;) ), AND(ISPICKVAL(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;),ISPICKVAL(Owner:User.Default_Catalog__c ,&apos;USL&apos;) ), AND(ISPICKVAL(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;),ISPICKVAL(APTS_SSD_Sold_To__r.LCRM_Sales_Org__c ,&apos;West&apos;), ISPICKVAL(Owner:User.Segment__c ,&apos;Global&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Proposal Business Unit to SCS</fullName>
        <actions>
            <name>Update_Proposal_Business_Unit_to_SCS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(  AND( ISNULL( TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c )) ,OR(ISPICKVAL(Owner:User.Default_Catalog__c , &apos;USL&apos;),ISPICKVAL(Owner:User.Default_Catalog__c , &apos;LMS&apos;))),  AND(  ISPICKVAL(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c,&apos;SCS&apos;) ,ISPICKVAL(Owner:User.Default_Catalog__c , &apos;FindLaw&apos;)  ),  AND(ISPICKVAL(APTS_SSD_Sold_To__r.LCRM_Sales_Org__c ,&apos;West&apos;),OR(ISPICKVAL(Owner:User.Segment__c ,&apos;Corporate&apos;), ISPICKVAL(Owner:User.Segment__c ,&apos;Global&apos;)))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Proposal Business Unit to Tax Prof</fullName>
        <actions>
            <name>TaxProfBU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(TEXT($User.Sub_Bu__c) == $Label.SALESORGTAXREG, TEXT($User.Segment__c) == $Label.SALESORGTAX,  (RecordType.Name == &apos;Proposal&apos; || RecordType.Name == &apos;TR Proposal&apos;), TEXT( Apttus_Proposal__Opportunity__r.Source_System_Detail__r.LCRM_Sales_Org__c) == $Label.SALESORGS100)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Canada_Shipping method</fullName>
        <actions>
            <name>Shipping_Method_Canada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Canada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.TR_Store_Source__c</field>
            <operation>notContain</operation>
            <value>TR Store</value>
        </criteriaItems>
        <description>Update Shipping method to International best Rate for Canada</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Check_COB_Default</fullName>
        <actions>
            <name>APTS_Check_COB_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>FindLaw</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>Making APTS_Check_COB__c checkbox False.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Clear Quote Validity Override</fullName>
        <actions>
            <name>APTS_Clear_Quote_Validity_Override</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears Quote Validity Override when finalized</description>
        <formula>ISCHANGED(Apttus_QPConfig__ConfigurationFinalizedDate__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_OrderRejectionEmailTemplate</fullName>
        <actions>
            <name>APTS_Send_Order_Rejection_email_to_rep</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(!$Setup.GLI_OC_Bulk_Load__c.APTS_Disable_Workflow_Rule__c) &amp;&amp; NOT(ISPICKVAL(PRIORVALUE( Apttus_Proposal__Approval_Stage__c ),&apos;Rejected&apos;)) &amp;&amp; ISPICKVAL(Apttus_Proposal__Approval_Stage__c,&apos;Rejected&apos;) &amp;&amp; ISPICKVAL(APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Quote_Approval_Recall</fullName>
        <actions>
            <name>APTS_UpdateApprovalStage</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_Update_Approval_St_to_Not_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_QPApprov__Approval_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Reset the approval status to Not Submitted after cancellation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_UpdateApprovalStage</fullName>
        <actions>
            <name>APTS_UpdateApprovalStage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_UpdateRenewalProposalName</fullName>
        <actions>
            <name>APTS_UpdateRenewalProposalName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Proposal_Name__c</field>
            <operation>startsWith</operation>
            <value>Renew</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_QPConfig__IsSystemGenerated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule updated renewal proposals name as it will be the Renewal Oppty name as well. And Opportunity name limit is 120 characters only.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Digital Clone Proposal Update</fullName>
        <actions>
            <name>Digital_Proposal_Update_Env_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.is_Digital_Channel__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.DocuSign_Envelope_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update a Digital Renewal that is being cloned to blank out the Envelope ID</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Digital Quote Failure Reason Notification</fullName>
        <actions>
            <name>Digital_Quote_Failure_Reason_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>DLT-7326 : Send email to CXD support team when ever there is quote failure.</description>
        <formula>AND(ISCHANGED(Digital_Quote_Failure_Reason__c), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;NA&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Qualifying&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Appointment Scheduled&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Needs Analysis&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Solution Recommended&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Generate Contract&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Negotiate Contract&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Contract Signed&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Order Complete&quot;)), NOT(CONTAINS(Digital_Quote_Failure_Reason__c, &quot;Closed Lost&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Forward to Signee</fullName>
        <actions>
            <name>Forward_to_signee</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contract_Not_in_Sync</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Forward_signee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (  ISCHANGED(APTS_Order_Confirmation_Contact__c),  Forward_to_signee__c, Apttus_Proposal__Primary__c,  NOT(ISBLANK((APTS_Order_Confirmation_Contact__c))),  is_Digital_Channel__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Order confirmation contact update</fullName>
        <actions>
            <name>Order_Confirmation_Contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Not_in_Sync</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( ISCHANGED(APTS_Order_Confirmation_Contact__c), Digital_OCC_Flag__c, Apttus_Proposal__Primary__c, NOT(ISBLANK((&apos;APTS_Order_Confirmation_Contact__c&apos;))), is_Digital_Channel__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposal Has Not Updated to Accepted</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>notEqual</operation>
            <value>Accepted,Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Digitally_Signed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends email when proposal is not moved to Accepted after Digitally SIgned Date has been filled in 1 hour.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notifyy_CX_Digital_Support</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Proposal Not Updated to Accepted</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>notEqual</operation>
            <value>Accepted,Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Digitally_Signed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends email when proposal is not moved to Accepted after Digitally SIgned Date has been filled after 24 hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_EBS_CX_Digital_Support</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TR Store Order Confirmation Email</fullName>
        <actions>
            <name>TR_Store_Order_Confirmation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Language__c</field>
            <operation>equals</operation>
            <value>English</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.TR_Store_Source__c</field>
            <operation>contains</operation>
            <value>TR Store</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.TR_Store_Source__c</field>
            <operation>equals</operation>
            <value>UE Store Canada PRINT</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TR Store Order Confirmation Email French</fullName>
        <actions>
            <name>TR_Store_French_Order_Confirmation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Language__c</field>
            <operation>equals</operation>
            <value>French</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.TR_Store_Source__c</field>
            <operation>contains</operation>
            <value>TR Store</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.TR_Store_Source__c</field>
            <operation>equals</operation>
            <value>UE Store Canada PRINT</value>
        </criteriaItems>
        <description>send email notification for the TR Store Canada French users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Business unit from Findlaw Opportunity</fullName>
        <actions>
            <name>Update_Findlaw_quote_Business_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISPICKVAL(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c,&apos;FindLaw&apos;),NOT(ISNULL(TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c) )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Business unit from SCS Opportunity</fullName>
        <actions>
            <name>Update_quote_Business_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c) ==&apos;SCS&apos;,NOT(ISBLANK(TEXT(Apttus_Proposal__Opportunity__r.APTS_Proposal_Business_Unit__c) )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateRecordTypeOfExpiredProposals</fullName>
        <actions>
            <name>UpdateRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Apttus_Proposal__Approval_Stage__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Expired Proposal</value>
        </criteriaItems>
        <description>Updates the record type of expired proposals if the record type is not &apos;Expired Proposals&apos;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
