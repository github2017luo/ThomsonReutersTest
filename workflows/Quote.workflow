<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Cancellation_Approval_Notification</fullName>
        <description>Cancellation Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Approval_Notification_Cancellation</template>
    </alerts>
    <alerts>
        <fullName>Cancellation_Recall_Email</fullName>
        <description>Cancellation Recall Email</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_s_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Cancellation_Recall_Email_English</template>
    </alerts>
    <alerts>
        <fullName>CaseClosureNotificationFullCancelEmailAlert</fullName>
        <description>CaseClosureNotificationFullCancelEmailAlert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Case_Closure_Notification_Full_Cancel</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Email_Owner_about_OP_Rejection_Portugueuse</fullName>
        <description>LATAM Email Owner about OP Rejection - Portugueuse</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Order_Processing_Rejected_Quote_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Email_Owner_about_OP_Rejection_Spanish</fullName>
        <description>LATAM Email Owner about OP Rejection - Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Order_Processing_Rejected_Quote_Spanish</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Email_Rep_after_OP_Rejection_English</fullName>
        <description>LATAM Email Owner about OP Rejection - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Order_Processing_Rejected_Quote_English</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Quote_Approved_by_Manager_English</fullName>
        <description>LATAM Quote Approved by Manager - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Quote_Approved_by_Manager_English</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Quote_Approved_by_Manager_Portuguese</fullName>
        <description>LATAM Quote Approved by Manager - Portuguese</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Quote_Approved_by_Manager_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Quote_Approved_by_Manager_Spanish</fullName>
        <description>LATAM Quote Approved by Manager - Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Quote_Approved_by_Manager_Spanish</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Quote_Rejected_by_Manager_English</fullName>
        <description>LATAM Quote Rejected by Manager - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Quote_Rejected_by_Manager_English</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Quote_Rejected_by_Manager_Portuguese</fullName>
        <description>LATAM Quote Rejected by Manager - Portuguese</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Quote_Rejected_by_Manager_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>LATAM_Quote_Rejected_by_Manager_Spanish</fullName>
        <ccEmails>bindu.raavi@tcs.com</ccEmails>
        <description>LATAM Quote Rejected by Manager - Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Quote_Rejected_by_Manager_Spanish</template>
    </alerts>
    <alerts>
        <fullName>LatAm_Grace_Period_Entitlement_Email_Alert</fullName>
        <description>LatAm Grace Period Entitlement Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Entitlement_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>LATAM_Mail/Case_Grace_Period_Extn_Entitlement_Updt2</template>
    </alerts>
    <alerts>
        <fullName>Order_Team_Quote_Rejection</fullName>
        <description>Order Team Quote Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Reservation_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Order_Team_Quote_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Partner_Sales_Admin_Quote_Rejection</fullName>
        <description>Partner Sales Admin Quote Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Partner_Sales_Admin_Quote_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Price_Approved_English</fullName>
        <description>Price Approved - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Price_Approved_English</template>
    </alerts>
    <alerts>
        <fullName>Price_Approved_Portuguese</fullName>
        <description>Price Approved- Portuguese</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Price_Approved_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Price_Approved_Spanish</fullName>
        <description>Price Approved- Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Price_Approved_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Price_Reject_English</fullName>
        <description>Price Reject- English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Discount_Price_Reject_English</template>
    </alerts>
    <alerts>
        <fullName>Price_Reject_Portuguese</fullName>
        <description>Price Reject- Portuguese</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Discount_Price_Reject_Portuguese</template>
    </alerts>
    <alerts>
        <fullName>Price_Reject_Spanish</fullName>
        <description>Price Reject- Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Discount_Price_Reject_Spanish</template>
    </alerts>
    <alerts>
        <fullName>ProviewSendRequest</fullName>
        <ccEmails>proviewentitlementrequestservice@f-gykvmqzgsleov4fqihuxfz0fyru2dew84lmkd8etqpz9664cf.3-plslea2.na68.apex.salesforce.com</ccEmails>
        <description>ProviewSendRequest : To call ProviewEntitlementRequestHandler class</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ProviewSendRequest</template>
    </alerts>
    <alerts>
        <fullName>Recall_Email_English</fullName>
        <description>Recall Email - English</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_s_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Discount_Price_Recall_Email_English</template>
    </alerts>
    <alerts>
        <fullName>Recall_Email_Portugueges</fullName>
        <description>Recall Email - Portugueges</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_s_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Discount_Price_Recall_Email_Portugueges</template>
    </alerts>
    <alerts>
        <fullName>Recall_Email_Spanish</fullName>
        <description>Recall Email - Spanish</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_s_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LatAm_Order_Form/Discount_Price_Recall_Email_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Notification_Cancellation</fullName>
        <description>Rejection Notification Cancellation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>LATAM_Mail/Rejection_Notification_Cancellation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_status</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LATAM_New_Quote</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Approval status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>BJ Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>BJ Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>BJ Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>BJ Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>BJ Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>BJ Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>BJ Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BJ_Update_Quote_Status_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>BJ Update Quote Status to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_account_contact_change</fullName>
        <field>Account_Contact_Change_Indicator__c</field>
        <literalValue>1</literalValue>
        <name>Check account, contact change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChileFinal_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>ChileFinal QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>Chile Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Chile Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Chile Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Update_ApprovalStatus_to_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>Chile Update ApprovalStatus to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>Chile Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Update_Approval_status_to_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>Chile Update Approval status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Chile_Update_Quote_Status_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Chile Update Quote Status to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estado_Propuesta_Aprovada</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Estado Propuesta Aprovada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estado_Propuesta_En_Revision</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Estado Propuesta En Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estado_Propuesta_Presentado</fullName>
        <field>Status</field>
        <literalValue>Presented</literalValue>
        <name>Estado Propuesta Presentado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estado_Propuesta_Rechazada</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Estado Propuesta Rechazada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>FS Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Approval_status_to_pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>FS Approval status to pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>FS Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>FS Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>FS Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>FS Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>FS Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>FS Update QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>FT  Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>FT Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>FT Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>FT Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>FT Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>FT Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>FT Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FT_Update_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>FT Update QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEYApproval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>LLEYApproval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEYQuote_Status_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>LLEYQuote Status to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEY_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>LLEY Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEY_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>LLEY Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEY_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>LLEY Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEY_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>LLEY Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEY_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>LLEY Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLEY_Update_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>LLEY Update QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>MS Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>MS Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>MS Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>MS Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>MS Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>MS Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>MS Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Update_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>MS Update QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>NV Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>NV Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>NV Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>NV Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>NV Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>NV Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>NV Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NV_Update_Quote_Status_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>NV Update Quote Status to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>PG Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>PG Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>PG Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>PG Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>PG Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>PG Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>PG Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PG_Update_Quote_Status_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>PG Update Quote Status to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Approval_Complete</fullName>
        <field>Pricing_Approval_Complete__c</field>
        <literalValue>1</literalValue>
        <name>Price Approval Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Approval_Not_Required</fullName>
        <field>Pricing_Approval_Required__c</field>
        <literalValue>0</literalValue>
        <name>Pricing Approval Not Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Approval_Required</fullName>
        <field>Pricing_Approval_Required__c</field>
        <literalValue>1</literalValue>
        <name>Pricing Approval Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Approval_Required_False</fullName>
        <field>Pricing_Approval_Required__c</field>
        <literalValue>0</literalValue>
        <name>Pricing Approval Required_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QuoteApproval_Status_Cancellation_Approv</fullName>
        <description>Field update added for Cancellation Approval (Renewals- FRS_1.86)</description>
        <field>Approval_Status__c</field>
        <literalValue>Cancellation Approved</literalValue>
        <name>QuoteApprovalStatus CancellationApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_ApprovalStatus_CancellationRejecte</fullName>
        <description>Field update added for Pending Cancellation Approval (Renewals- FRS_1.86)</description>
        <field>Approval_Status__c</field>
        <literalValue>Cancellation Rejected</literalValue>
        <name>Quote ApprovalStatusCancellationRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>RP Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>RP Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>RP Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>RP Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>RP Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>RP Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>RP Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RP_Update_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>RP Update QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>RT Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>RT Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>RT Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>RT Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>RT Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>RT Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>RT Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Update_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>RT Update QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>RV Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>RV Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>RV Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>RV Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>RV Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>RV Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>RV Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RV_Update_Quote_Status_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>RV Update Quote Status to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewals_Pricing_Approval_Required_False</fullName>
        <field>Pricing_Approval_Required__c</field>
        <literalValue>0</literalValue>
        <name>Renewals Pricing Approval Required_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pricing_Approval_Required_To_True</fullName>
        <field>Pricing_Approval_Required__c</field>
        <literalValue>1</literalValue>
        <name>Set Pricing Approval Required To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Purchase_Order_Date</fullName>
        <field>Purchase_Order_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Purchase Order Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_for_processing_Cancellation</fullName>
        <description>Field update added for Pending Cancellation Approval (Renewals- FRS_1.86)</description>
        <field>Status</field>
        <literalValue>Submitted for Processing</literalValue>
        <name>Submitted for processing Cancellation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdApproval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>TdApproval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdApproval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>TdApproval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdFinal_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>TdFinal Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdQuote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>TdQuote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdQuote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>TdQuote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdUpdate_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>TdUpdate Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TdUpdate_QuoteStatus_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>TdUpdate QuoteStatus to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Td_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Td Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Approval_Status_to_PAR</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approval Rejected</literalValue>
        <name>UR Approval Status to PAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Approval_status_to_Pricing_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pricing Approved</literalValue>
        <name>UR Approval status to Pricing Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Final_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>UR Final Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Final_QuoteStatus_to_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>UR Final QuoteStatus to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Quote_status_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>UR Quote status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Quote_status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>UR Quote status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Update_Approval_Status_to_PPA</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Pricing Approval</literalValue>
        <name>UR Update Approval Status to PPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UR_Update_Quote_Status_to_InReview</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>UR Update Quote Status to InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unassign_OP_Owner</fullName>
        <field>OP_Owner__c</field>
        <name>Unassign OP Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateQuoteStatusSubmittedforProcessing</fullName>
        <field>Status</field>
        <literalValue>Submitted for Processing</literalValue>
        <name>UpdateQuoteStatusSubmittedforProcessing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <description>If OP Rejected , then change Approval status to Quote Rejected.</description>
        <field>Approval_Status__c</field>
        <literalValue>Quote Rejected</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to</fullName>
        <field>Approval_Status__c</field>
        <name>Update Approval Status to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_MGT_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Manager Approval</literalValue>
        <name>Update Approval Status to MGT Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_QuoteApproved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Quote Approved</literalValue>
        <name>Update Approval Status to QuoteApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Quote Rejected</literalValue>
        <name>Update Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field_Is_Migrated_Quote</fullName>
        <field>Is_Migrated__c</field>
        <literalValue>1</literalValue>
        <name>Update Field Is Migrated Quote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_OP_Rejection_Count</fullName>
        <field>OP_Rejection_Count__c</field>
        <formula>OP_Rejection_Count__c +1</formula>
        <name>Update OP Rejection Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_OP_Rejection_Date</fullName>
        <field>OP_Rejection_Date__c</field>
        <formula>NOW()</formula>
        <name>Update OP Rejection Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Order_Reviewed_by</fullName>
        <field>Order_Reviewed_by__c</field>
        <formula>OP_Owner__r.FirstName &amp;&quot; &quot;&amp;OP_Owner__r.LastName</formula>
        <name>Update Order Reviewed by</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_to_MGT_Approval</fullName>
        <field>Status</field>
        <literalValue>MGT Approval – Pending Review</literalValue>
        <name>Update Quote Status to MGT Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Draft</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>Update Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_in_Review</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Update Status to in Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_Manager_Approval_Date</fullName>
        <field>Submitted_for_Manager_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Submitted Manager Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updatemanageremail</fullName>
        <field>Owner_s_Manager_Email__c</field>
        <formula>OpportunityOwnerManagerEmail__c</formula>
        <name>Updatemanageremail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Case Closure Notification Full Cancel</fullName>
        <actions>
            <name>CaseClosureNotificationFullCancelEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>equals</operation>
            <value>LATAM Renewal Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Renewal_Flag_Formula__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Order Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check_Account_Contact_Change</fullName>
        <actions>
            <name>Check_account_contact_change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FRS_1.28 - Renewals</description>
        <formula>AND(  NOT(ISNEW()),  RecordType.Name = &quot;LATAM Renewal Quote&quot;,  OR(  ISCHANGED( Bill_To_Customer_Name__c ),  ISCHANGED( Bill_To_Contact__c ),  ISCHANGED( Ship_To_Customer_Name__c ),  ISCHANGED( Sold_To_Contact__c ),  ISCHANGED( Payer_Customer_Name__c )  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CopyOpportunityOwnerManagerEmail</fullName>
        <actions>
            <name>Updatemanageremail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(OpportunityOwnerManagerEmail__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Approval - English</fullName>
        <actions>
            <name>Price_Approved_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Approved&quot;),  ISPICKVAL(Approval_Status__c ,&quot;Pricing Approved&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Language__c = &quot;English&quot;,  Opportunity.Owner.Language__c = &quot;Inglés&quot;,  Opportunity.Owner.Language__c = &quot;Inglês&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Approval - Portuguese</fullName>
        <actions>
            <name>Price_Approved_Portuguese</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Approved&quot;),  ISPICKVAL(Approval_Status__c ,&quot;Pricing Approved&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Language__c = &quot;Portuguese (Brazilian)&quot;,  Opportunity.Owner.Language__c = &quot;Português (Brasil)&quot;,  Opportunity.Owner.Language__c = &quot;Portugués (Brasileño)&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Approval - Spanish</fullName>
        <actions>
            <name>Price_Approved_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Approved&quot;),  ISPICKVAL(Approval_Status__c ,&quot;Pricing Approved&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Language__c = &quot;Spanish&quot;,  Opportunity.Owner.Language__c = &quot;Espanhol&quot;,  Opportunity.Owner.Language__c = &quot;Español&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Recall - English</fullName>
        <actions>
            <name>Recall_Email_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pending Pricing Approval&quot;), ISPICKVAL(Status,&quot;In Review&quot;), ISPICKVAL(Approval_Status__c ,&quot;&quot;), Is_Child_Quote_MSaf__c &lt;&gt; TRUE,     Master_Quote__c == NULL,  OR(Opportunity.Owner.Manager.Language__c = &quot;English&quot;,  Opportunity.Owner.Manager.Language__c = &quot;Inglés&quot;,  Opportunity.Owner.Manager.Language__c = &quot;Inglês&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Recall - Portuguese</fullName>
        <actions>
            <name>Recall_Email_Portugueges</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pending Pricing Approval&quot;), ISPICKVAL(Status,&quot;In Review&quot;), ISPICKVAL(Approval_Status__c ,&quot;&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Manager.Language__c = &quot;Portuguese (Brazilian)&quot;,  Opportunity.Owner.Manager.Language__c = &quot;Português (Brasil)&quot;,  Opportunity.Owner.Manager.Language__c = &quot;Portugués (Brasileño)&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Recall - Spanish</fullName>
        <actions>
            <name>Recall_Email_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pending Pricing Approval&quot;), ISPICKVAL(Status,&quot;In Review&quot;),  ISPICKVAL(Approval_Status__c ,&quot;&quot;),  Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Manager.Language__c = &quot;Spanish&quot;,  Opportunity.Owner.Manager.Language__c = &quot;Espanhol&quot;,  Opportunity.Owner.Manager.Language__c = &quot;Español&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Rejects - English</fullName>
        <actions>
            <name>Price_Reject_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(   ISPICKVAL(Status,&quot;Rejected&quot;),  ISPICKVAL(Approval_Status__c ,&quot;Pricing Approval Rejected&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Language__c = &quot;English&quot;,  Opportunity.Owner.Language__c = &quot;Inglés&quot;,  Opportunity.Owner.Language__c = &quot;Inglês&quot;)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Rejects - Portuguese</fullName>
        <actions>
            <name>Price_Reject_Portuguese</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Rejected&quot;),  ISPICKVAL(Approval_Status__c ,&quot;Pricing Approval Rejected&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Language__c = &quot;Portuguese (Brazilian)&quot;,  Opportunity.Owner.Language__c = &quot;Português (Brasil)&quot;,  Opportunity.Owner.Language__c = &quot;Portugués (Brasileño)&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Discount Price Final Rejects - Spanish</fullName>
        <actions>
            <name>Price_Reject_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Rejected&quot;),  ISPICKVAL(Approval_Status__c ,&quot;Pricing Approval Rejected&quot;),   Is_Child_Quote_MSaf__c &lt;&gt; TRUE,  Master_Quote__c == NULL,  OR(Opportunity.Owner.Language__c = &quot;Spanish&quot;,  Opportunity.Owner.Language__c = &quot;Espanhol&quot;,  Opportunity.Owner.Language__c = &quot;Español&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Owner after Mgr Approves - English</fullName>
        <actions>
            <name>LATAM_Quote_Approved_by_Manager_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Submitted for Processing&quot;), ISPICKVAL( Approval_Status__c,&quot;Quote Approved&quot;),  OR(Opportunity.Owner.Language__c = &quot;English&quot;,  Opportunity.Owner.Language__c = &quot;Inglés&quot;,  Opportunity.Owner.Language__c = &quot;Inglês&quot;),Is_Child_Quote_MSaf__c &lt;&gt; true  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Owner after Mgr Approves - Portuguese</fullName>
        <actions>
            <name>LATAM_Quote_Approved_by_Manager_Portuguese</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Status,&quot;Submitted for Processing&quot;),   ISPICKVAL( Approval_Status__c,&quot;Quote Approved&quot;),  OR(Opportunity.Owner.Language__c = &quot;Portuguese (Brazilian)&quot;, Opportunity.Owner.Language__c = &quot;Português (Brasil)&quot;, Opportunity.Owner.Language__c = &quot;Portugués (Brasileño)&quot;), Is_Child_Quote_MSaf__c &lt;&gt; true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Owner after Mgr Approves - Spanish</fullName>
        <actions>
            <name>LATAM_Quote_Approved_by_Manager_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Submitted for Processing&quot;),  ISPICKVAL( Approval_Status__c,&quot;Quote Approved&quot;),  OR(Opportunity.Owner.Language__c = &quot;Spanish&quot;, Opportunity.Owner.Language__c = &quot;Espanhol&quot;, Opportunity.Owner.Language__c = &quot;Español&quot;), Is_Child_Quote_MSaf__c &lt;&gt; true  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Owner after Mgr Rejects - English</fullName>
        <actions>
            <name>LATAM_Quote_Rejected_by_Manager_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Rejected&quot;), ISPICKVAL( Approval_Status__c,&quot;Quote Rejected&quot;),  OR(Opportunity.Owner.Language__c = &quot;English&quot;,  Opportunity.Owner.Language__c = &quot;Inglés&quot;,  Opportunity.Owner.Language__c = &quot;Inglês&quot;), Is_Child_Quote_MSaf__c &lt;&gt; true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Owner after Mgr Rejects - Portuguese</fullName>
        <actions>
            <name>LATAM_Quote_Rejected_by_Manager_Portuguese</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Rejected&quot;), ISPICKVAL( Approval_Status__c,&quot;Quote Rejected&quot;),  OR(Opportunity.Owner.Language__c = &quot;Portuguese (Brazilian)&quot;, Opportunity.Owner.Language__c = &quot;Português (Brasil)&quot;, Opportunity.Owner.Language__c = &quot;Portugués (Brasileño)&quot;), Is_Child_Quote_MSaf__c &lt;&gt; true   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Owner after Mgr Rejects - Spanish</fullName>
        <actions>
            <name>LATAM_Quote_Rejected_by_Manager_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;Rejected&quot;), ISPICKVAL( Approval_Status__c,&quot;Quote Rejected&quot;),  OR(Opportunity.Owner.Language__c = &quot;Spanish&quot;, Opportunity.Owner.Language__c = &quot;Espanhol&quot;, Opportunity.Owner.Language__c = &quot;Español&quot;),Is_Child_Quote_MSaf__c &lt;&gt; true  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Rep after OP Rejection - English</fullName>
        <actions>
            <name>LATAM_Email_Rep_after_OP_Rejection_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Status,&quot;OP Rejected&quot;),Opportunity.Owner.Profile.Name!=&apos;Partner Portal User&apos;, OR(Opportunity.Owner.Language__c = &quot;English&quot;,  Opportunity.Owner.Language__c = &quot;Inglés&quot;,  Opportunity.Owner.Language__c = &quot;Inglês&quot;), Is_Child_Quote_MSaf__c &lt;&gt; true  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Rep after OP Rejection - Portuguese</fullName>
        <actions>
            <name>LATAM_Email_Owner_about_OP_Rejection_Portugueuse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;OP Rejected&quot;),Opportunity.Owner.Profile.Name!=&apos;Partner Portal User&apos;,   OR(Opportunity.Owner.Language__c = &quot;Portuguese (Brazilian)&quot;, Opportunity.Owner.Language__c = &quot;Português (Brasil)&quot;, Opportunity.Owner.Language__c = &quot;Portugués (Brasileño)&quot;) , Is_Child_Quote_MSaf__c &lt;&gt; true  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Email Rep after OP Rejection - Spanish</fullName>
        <actions>
            <name>LATAM_Email_Owner_about_OP_Rejection_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISPICKVAL(Status,&quot;OP Rejected&quot;), Opportunity.Owner.Profile.Name!=&apos;Partner Portal User&apos;,  OR(Opportunity.Owner.Language__c = &quot;Spanish&quot;, Opportunity.Owner.Language__c = &quot;Espanhol&quot;, Opportunity.Owner.Language__c = &quot;Español&quot;) , Is_Child_Quote_MSaf__c &lt;&gt; true  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LATAM Update Quote after OP Rejection</fullName>
        <actions>
            <name>Update_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_OP_Rejection_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_OP_Rejection_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>OP Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LatAm Grace Period Entitlement Email</fullName>
        <actions>
            <name>LatAm_Grace_Period_Entitlement_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(  Renewal_Options__c ,&apos;Opt-In - Negotiable Renewal&apos;),  NOT(ISPICKVAL(  Opportunity.StageName ,&apos;0%&apos;)),  NOT(ISPICKVAL(  Opportunity.StageName ,&apos;100%&apos;)),  TODAY() &gt;Opportunity.Grace_Period_Expiration_Date__c, NOT(ISNULL( Entitlement_Email__c ))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lock the quote record</fullName>
        <actions>
            <name>Approval_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Quote.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Pricing Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Manager Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sales_Org__c</field>
            <operation>notEqual</operation>
            <value>EDIC,SCSI,SFWS,TSCE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Renewal_Flag_Formula__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>LATAM Renewal Quote</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Order Reviewed By from Op Owner Field</fullName>
        <actions>
            <name>Update_Order_Reviewed_by</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populating Order_Reviewed_by__c field with data of the &quot;OP_Owner_c&quot; Quote field when that field is populated the first time</description>
        <formula>AND( NOT(ISBLANK(OP_Owner__c)), ISBLANK( Order_Reviewed_by__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pricing Approval Not Required</fullName>
        <actions>
            <name>Pricing_Approval_Not_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Determines when Pricing approval required checkbox should be false based on the discount threshold and Business units</description>
        <formula>AND(  	NOT($RecordType.Name = &quot;LATAM Renewal Quote&quot;), NOT(ISPICKVAL(Opportunity.Account.Customer_Class_c__c , &quot;Reseller&quot;)),  	OR( 		AND( Pricing_Approval_Required__c = True, OR( OR( Discount_Threshold__c &lt;= 0.1, ISBLANK(Discount_Threshold__c) ), Promotion__c = True ), AND( OR(Business_Unit__c = &apos;Revista - Telesales&apos;, Business_Unit__c = &apos;Chile&apos; ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;) ) ) ) , AND( Pricing_Approval_Required__c = True, AND( $Profile.Name != &quot;Partner Portal User&quot;, Opportunity.Owner.Profile.Name!=&quot;Partner Portal User&quot; ), OR( OR( Discount_Threshold__c &lt;= 0.1, ISBLANK(Discount_Threshold__c) ), Promotion__c = True ), AND( OR( Business_Unit__c = &apos;Mastersaf&apos;,Business_Unit__c = &apos;Colombia&apos;,Business_Unit__c = &apos;Integration Point&apos;,Business_Unit__c = &apos;GTM&apos;, Business_Unit__c = &apos;Novaprolink&apos;, Business_Unit__c = &apos;TEDESCO&apos;, Business_Unit__c = &apos;Revista - Print&apos;, Business_Unit__c = &apos;Revista - Online&apos; ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;) ) ) ), AND( Pricing_Approval_Required__c = True, $Profile.Name = &quot;Partner Portal User&quot;, OR( OR( Discount_Threshold__c &lt;= 0, ISBLANK(Discount_Threshold__c) ), Promotion__c = True ), AND( OR( Business_Unit__c = &apos;Mastersaf&apos;,Business_Unit__c = &apos;Colombia&apos;,Business_Unit__c = &apos;Integration Point&apos;, Business_Unit__c = &apos;Novaprolink&apos;,Business_Unit__c = &apos;GTM&apos;, Business_Unit__c = &apos;TEDESCO&apos;, Business_Unit__c = &apos;Revista - Print&apos;, Business_Unit__c = &apos;Revista - Online&apos; ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;) ) ) ), AND( Pricing_Approval_Required__c = True, OR( OR( Discount_Threshold__c &lt;= 0.05, ISBLANK(Discount_Threshold__c) ), Promotion__c = True ),Business_Unit__c = &apos;Bejerman&apos;,ISPICKVAL(Opportunity.Sales_Org__c , &quot;BEJE&quot;) ), AND( Pricing_Approval_Required__c = True, OR( OR( Discount_Threshold__c &lt;= 0.05, ISBLANK(Discount_Threshold__c) ), Promotion__c = True ),Business_Unit__c = &apos;Laley&apos;,ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;) ), AND( Pricing_Approval_Required__c = True, OR( OR( Discount_Threshold__c &lt;= 0, ISBLANK(Discount_Threshold__c) ), Promotion__c = True ), AND( OR( Business_Unit__c = &apos;Uruguay&apos;, Business_Unit__c = &apos;Paraguay&apos; ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLUR&quot;) ) ) ), AND( Pricing_Approval_Required__c = True, Sales_Sub_Category__c = &quot;Renewal&quot;, NOT( AND( OR( Business_Unit__c = &apos;Revista - Print&apos;, Business_Unit__c = &apos;Laley&apos;, Business_Unit__c = &apos;Chile&apos;, Business_Unit__c = &apos;Paraguay&apos; ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;) ), OR( TRIM(TEXT(Account_LookUp__r.Sales_Org__c)) == TRIM(Sales_Org__c), AND( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;) ), AND( ISPICKVAL(Account_LookUp__r.Sales_Org__c , &quot;LLEY&quot;) ) ) ) ) ), AND( Pricing_Approval_Required__c = True, $Profile.Name = &quot;Partner Portal User&quot;, OR( OR( Discount_Threshold__c &lt;= 0.0, ISBLANK(Discount_Threshold__c), ISNULL(Discount_Threshold__c) ), Promotion__c = True ),ISPICKVAL(Opportunity.Sales_Org__c , &quot;DFCL&quot;)), AND( Pricing_Approval_Required__c = True, OR($Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR( OR( Discount_Threshold__c &lt;= 0.1, ISBLANK(Discount_Threshold__c), ISNULL(Discount_Threshold__c) ), Promotion__c = True ),ISPICKVAL(Opportunity.Sales_Org__c , &quot;DFCL&quot;))  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pricing Approval Required</fullName>
        <actions>
            <name>Pricing_Approval_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Pricing approval required is true based on the discount threshold and Business units</description>
        <formula>AND(  NOT(ISPICKVAL(Opportunity.Account.Customer_Class_c__c , &quot;Reseller&quot;)), NOT(ISPICKVAL( $User.Sales_Org__c ,&quot;EDIC&quot;)), RecordType.Name=&apos;LATAM New Quote&apos;,  NOT(ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pricing Approved&quot;)),  NOT( OR( Promotion__c = True, ISPICKVAL(Opportunity.Sub_Category__c,&quot;Renewal&quot;), Opportunity.Renewal_Flag__c = True ) ),  OR( AND(Discount_Threshold__c &gt; 0.1, AND( OR ( Business_Unit__c = &apos;Mastersaf&apos;,Business_Unit__c = &apos;Colombia&apos;, Business_Unit__c = &apos;Integration Point&apos;, Business_Unit__c = &apos;Novaprolink&apos;, Business_Unit__c = &apos;TEDESCO&apos;, Business_Unit__c = &apos;GTM&apos;, Business_Unit__c = &apos;Revista - Print&apos;, Business_Unit__c = &apos;Revista - Online&apos;, Business_Unit__c = &apos;Revista - Telesales&apos;, Business_Unit__c = &apos;Chile&apos; ), OR ( ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;),ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;) ) ) ),  AND( Discount_Threshold__c &gt; 0.05,Business_Unit__c = &apos;Bejerman&apos;,ISPICKVAL(Opportunity.Sales_Org__c , &quot;BEJE&quot;) ),   AND( Discount_Threshold__c &gt; 0.1,Business_Unit__c = &apos;SL - Corporate&apos;,ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;) ),  AND( Discount_Threshold__c &gt; 0.05,OR(Business_Unit__c = &apos;Laley&apos;, Business_Unit__c = &apos;SL - Corporate&apos;),ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;)),   AND(Discount_Threshold__c &gt; 0, AND( OR ( Business_Unit__c = &apos;Paraguay&apos;, Business_Unit__c = &apos;Uruguay&apos; ), OR ( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLUR&quot;) ) ) ),  AND(Discount_Threshold__c &gt; 0, OR($Profile.Name = &quot;Partner Portal User&quot;, Opportunity.Owner.Profile.Name=&quot;Partner Portal User&quot;), AND( OR ( Business_Unit__c = &apos;Mastersaf&apos;,Business_Unit__c = &apos;Colombia&apos;, Business_Unit__c = &apos;Integration Point&apos;,Business_Unit__c = &apos;GTM&apos;,Business_Unit__c = &apos;Novaprolink&apos;, Business_Unit__c = &apos;TEDESCO&apos;, Business_Unit__c = &apos;Revista - Print&apos;, Business_Unit__c = &apos;Revista - Online&apos; ), OR ( ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;) ) ) ),AND(OR( $Profile.Name = &quot;LatAm User&quot;,$Profile.Name = &quot;System Administrator&quot; ), Discount_Threshold__c &gt; 0.1, ISPICKVAL(Opportunity.Sales_Org__c , &quot;DFCL&quot;)),AND( $Profile.Name = &quot;Partner Portal User&quot;,Discount_Threshold__c &gt; 0.0, ISPICKVAL(Opportunity.Sales_Org__c , &quot;DFCL&quot;)) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ProviewEntitlementRequestMail</fullName>
        <actions>
            <name>ProviewSendRequest</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>((((1 AND 5) OR (3 AND 4 AND 2)) AND 6) AND 7)</booleanFilter>
        <criteriaItems>
            <field>Quote.Entitlement_Path__c</field>
            <operation>equals</operation>
            <value>Post Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Entitlement_Path__c</field>
            <operation>equals</operation>
            <value>Pre Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Submitted for Processing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Quote Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>Order Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Entitlement_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Entitlement_Product_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Workflow rule to fire an email alert to send the quote for Pre or Post order entitlement.[Proview Tokenisation Project]</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote Migration from FSCO to TSL Sales org</fullName>
        <actions>
            <name>Update_Field_Is_Migrated_Quote</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(PRIORVALUE(Opportunity_Sales_Org__c), &quot;FSCO&quot;),ISPICKVAL(Opportunity_Sales_Org__c, &quot;TSL&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quote Migration from RV01 to TSL Sales org</fullName>
        <actions>
            <name>Update_Field_Is_Migrated_Quote</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as part of brazil legal eco system for migration of legal one products to TSL</description>
        <formula>AND(ISPICKVAL(PRIORVALUE(Opportunity_Sales_Org__c), &quot;RV01&quot;),ISPICKVAL(Opportunity_Sales_Org__c, &quot;TSL&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals Pricing Approval Not Required</fullName>
        <actions>
            <name>Renewals_Pricing_Approval_Required_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Renewals pricing approve false for variance less than 30%</description>
        <formula>AND( $RecordType.Name = &quot;LATAM Renewal Quote&quot;, Renewal_Flag_Formula__c = True, Primary_Quote__c =True, Pricing_Approval_Required__c = True, NOT(ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pricing Approved&quot;)), OR( Promotion__c = True, AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR( Discount_Threshold__c &lt; 0.05, ISNULL(Discount_Threshold__c), ISBLANK(Discount_Threshold__c) ), OR( Price_Increase_Discount_variance__c &lt;= 0.3, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), ISPICKVAL(Opportunity.Sales_Org__c , &quot;BEJE&quot;) ) , AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR( Discount_Threshold__c &lt; 0.1, ISNULL(Discount_Threshold__c), ISBLANK(Discount_Threshold__c) ), OR( Price_Increase_Discount_variance__c &lt;= 0.1, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR( Discount_Threshold__c &lt; 0.1, ISNULL(Discount_Threshold__c), ISBLANK(Discount_Threshold__c) ), OR( Price_Increase_Discount_variance__c &lt;= 0.3, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;) ) ),AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), 	OR( Discount_Threshold__c &lt;= 0.05, ISNULL(Discount_Threshold__c), ISBLANK(Discount_Threshold__c) ), OR ( Price_Increase_Discount_variance__c &lt;= 0.3, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), OR(  ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;) ) ),  AND( OR( $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR( Discount_Threshold__c &lt;= 0, ISNULL(Discount_Threshold__c), ISBLANK(Discount_Threshold__c) ), OR( Price_Increase_Discount_variance__c &lt;= 0, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR( Discount_Threshold__c = 0, ISNULL(Discount_Threshold__c), ISBLANK(Discount_Threshold__c) ), OR( Price_Increase_Discount_variance__c &lt;= 0, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;),ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLUR&quot;) ) ),AND(OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ),   OR ( Price_Increase_Discount_variance__c &lt;= 0.3, ISNULL(Price_Increase_Discount_variance__c), ISBLANK(Price_Increase_Discount_variance__c) ), ISPICKVAL(Opportunity.Sales_Org__c , &quot;DFCL&quot;) ) )	)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals Pricing Approval Required</fullName>
        <actions>
            <name>Pricing_Approval_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Pricing approval checkbox set to true if Price Increase Discount variance exceeds 30%</description>
        <formula>AND( $RecordType.Name = &quot;LATAM Renewal Quote&quot;, Renewal_Flag_Formula__c = True, Primary_Quote__c =True, Promotion__c = False, Pricing_Approval_Required__c = False, NOT(ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pricing Approved&quot;)), OR( AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Price_Increase_Discount_variance__c&gt;0.3, NOT(ISNULL(Price_Increase_Discount_variance__c)), NOT(ISBLANK(Price_Increase_Discount_variance__c)),ISPICKVAL(Opportunity.Sales_Org__c , &quot;BEJE&quot;)), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ),OR( Price_Increase_Discount_variance__c&gt;0.1, NOT(ISNULL(Price_Increase_Discount_variance__c)), NOT(ISBLANK(Price_Increase_Discount_variance__c))), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;) ) ),AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), OR(Price_Increase_Discount_variance__c&gt;0.3, NOT(ISNULL(Price_Increase_Discount_variance__c)), NOT(ISBLANK(Price_Increase_Discount_variance__c))), OR(ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;),ISPICKVAL(Opportunity.Sales_Org__c , &quot;DFCL&quot;))), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Price_Increase_Discount_variance__c&gt;0, NOT(ISNULL(Price_Increase_Discount_variance__c)), NOT(ISBLANK(Price_Increase_Discount_variance__c)), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;),ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLUR&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Price_Increase_Discount_variance__c&gt;0.3, NOT(ISNULL(Price_Increase_Discount_variance__c)), NOT(ISBLANK(Price_Increase_Discount_variance__c)), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;) ) ), AND( OR( $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Price_Increase_Discount_variance__c&gt;0, NOT(ISNULL(Price_Increase_Discount_variance__c)), NOT(ISBLANK(Price_Increase_Discount_variance__c)), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Discount_Threshold__c &gt; 0.05, NOT(ISNULL(Discount_Threshold__c)), NOT(ISBLANK(Discount_Threshold__c)), OR(ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;BEJE&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Discount_Threshold__c &gt; 0.1, NOT(ISNULL(Discount_Threshold__c)), NOT(ISBLANK(Discount_Threshold__c)), OR(ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Discount_Threshold__c &gt; 0.1, NOT(ISNULL(Discount_Threshold__c)), NOT(ISBLANK(Discount_Threshold__c)), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;) ) ), AND( OR( $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Discount_Threshold__c &gt; 0, NOT(ISNULL(Discount_Threshold__c)), NOT(ISBLANK(Discount_Threshold__c)), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;TSL&quot;) ) ), AND( OR( $Profile.Name = &quot;LatAm User&quot;, $Profile.Name = &quot;Partner Portal User&quot;, $Profile.Name = &quot;System Administrator&quot; ), Discount_Threshold__c &gt; 0, NOT(ISNULL(Discount_Threshold__c)), NOT(ISBLANK(Discount_Threshold__c)), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;),ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLUR&quot;) ) ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reseller Pricing Approval Checked</fullName>
        <actions>
            <name>Set_Pricing_Approval_Required_To_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FRS =  SFD-449.  &quot;Pricing Approval Required&quot; will be checked when Quotes Highest Discount is greater than Max Reseller Discount percentage.</description>
        <formula>AND( Discount_Threshold__c &gt; Max_Reseller_Discount_Percentage__c, RecordType.Name=&apos;LATAM New Quote&apos;, OR( Business_Unit__c = &apos;Revista - Print&apos;, Business_Unit__c = &apos;Laley&apos;, Business_Unit__c = &apos;Chile&apos;, Business_Unit__c = &apos;Paraguay&apos; ), ISPICKVAL(Opportunity.Account.Customer_Class_c__c , &quot;Reseller&quot;), OR( ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;), ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;) ), NOT(ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pricing Approved&quot;)), NOT(OR(ISPICKVAL(Opportunity.StageName,&quot;95%&quot;),ISPICKVAL(Opportunity.StageName,&quot;100%&quot;))), Promotion__c = False, Reseller_Discount_Config_Is_Valid_F__c == True, OR( TRIM(TEXT(Account_LookUp__r.Sales_Org__c)) == TRIM(Sales_Org__c), AND(ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;) ), AND( ISPICKVAL(Account_LookUp__r.Sales_Org__c , &quot;LLEY&quot;) ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reseller Pricing Approval UnChecked</fullName>
        <actions>
            <name>Pricing_Approval_Required_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FRS =  SFD-449.  &quot;Pricing Approval Required&quot; will be UnChecked when Quotes Highest Discount is less than  or equal to Max Reseller Discount percentage.</description>
        <formula>AND(		 	OR(		 		Discount_Threshold__c &lt;= Max_Reseller_Discount_Percentage__c, 		Promotion__c = True		 	), 	RecordType.Name=&apos;LATAM New Quote&apos;, 	OR( 		Business_Unit__c = &apos;Revista - Print&apos;, 		Business_Unit__c = &apos;Laley&apos;, 		Business_Unit__c = &apos;Chile&apos;, 		Business_Unit__c = &apos;Paraguay&apos; 	), 	ISPICKVAL(Opportunity.Account.Customer_Class_c__c , &quot;Reseller&quot;), 	OR( 		ISPICKVAL(Opportunity.Sales_Org__c , &quot;RV01&quot;), 		ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;), 		 		ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPCL&quot;), 		ISPICKVAL(Opportunity.Sales_Org__c , &quot;LPTC&quot;), 		ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLPA&quot;) 	),	 	NOT(ISPICKVAL(PRIORVALUE(Approval_Status__c),&quot;Pricing Approved&quot;)), 	NOT(OR(ISPICKVAL(Opportunity.StageName,&quot;95%&quot;),ISPICKVAL(Opportunity.StageName,&quot;100%&quot;))),			 	Reseller_Discount_Config_Is_Valid_F__c == True, 	OR( 		TRIM(TEXT(Account_LookUp__r.Sales_Org__c)) == TRIM(Sales_Org__c), 		AND( 			 			ISPICKVAL(Opportunity.Sales_Org__c , &quot;LLEY&quot;) 		), 		AND( 			ISPICKVAL(Account_LookUp__r.Sales_Org__c , &quot;LLEY&quot;) 			 		) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send an email to Partner user Manager on rejection of quote by Order Team</fullName>
        <actions>
            <name>Order_Team_Quote_Rejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email needs to be sent to Manager of the Partner User if the quote is rejected by the Order Team</description>
        <formula>AND(Opportunity.Owner.Profile.Name=&apos;Partner Portal User&apos;,ISPICKVAL( Status , &apos;OP Rejected&apos;), Is_Child_Quote_MSaf__c  &lt;&gt; true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send an email to Partner user on rejection of quote by Partner Sales Admin</fullName>
        <actions>
            <name>Partner_Sales_Admin_Quote_Rejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email needs to be sent to the Partner Portal Users if the quote is rejected by Partner Sales Admin</description>
        <formula>AND(Opportunity.Owner.Profile.Name=&apos;Partner Portal User&apos;,AND(NOT( ISBLANK( Partner_Rejection_Reason__c ) ), ISCHANGED( Partner_Rejection_Reason__c )), ISPICKVAL( Status , &apos;Rejected&apos;),  OR(ISPICKVAL(PRIORVALUE(Status),&apos;Sales Admin - Pending Review&apos;),ISPICKVAL(PRIORVALUE(Status),&apos;Rejected&apos;)),  Is_Child_Quote_MSaf__c  &lt;&gt; true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
