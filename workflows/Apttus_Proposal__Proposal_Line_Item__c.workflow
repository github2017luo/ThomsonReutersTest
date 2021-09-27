<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>APTS_Contract_Subs_Display_Field_Update</fullName>
        <field>APTS_Contract_Sub_Type_French_Display__c</field>
        <formula>CASE(Contract_Subscription_Type_Text__c, &apos;Ship &amp; Enter Subscription&apos; , &apos;Expédier Et Ajouter Abonnement&apos;, &apos;Subscription Only&apos;, &apos;Abonnement Seulement&apos;,&apos;Ship Only-No Subscription&apos;,&apos;Expédier Seulement – Sans Abonnement&apos;,&apos;Entitle only - no subscription&apos;,&apos;Autoriser seulement – Sans Abonnement&apos;,&apos;Entitle &amp; Enter Subscription&apos;,&apos;Autoriser &amp; Ajouter Abonnement&apos;,&apos;Seminars&apos;,&apos;Séminaire&apos;,&apos;&apos;)</formula>
        <name>APTS Contract Subs Display Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Contract_Subscription_Field_Update</fullName>
        <field>APTS_Contract_Subscription__c</field>
        <formula>CASE(APTS_Print_Purchase_Options__c , &quot;Ship &amp; Enter Sub&quot; , &quot;Ship &amp; Enter Subscription&quot;, &quot;Sub Only&quot;, &quot;Subscription Only&quot;,&quot;Ship Only&quot;,&quot;Ship Only-No Subscription&quot;,NULL)</formula>
        <name>APTS Contract Subscription Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Contract_WL_Flex_Windows_New</fullName>
        <description>The checkbox will return true when Sub# equals 41659192, 41659193, 41659194 and 41659195</description>
        <field>APTS_Contract_WL_Flex_Windows_New__c</field>
        <literalValue>1</literalValue>
        <name>APTS_Contract_WL Flex Windows_New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Apttus_Proposal__Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Count_for_KMBridge_Product_New</fullName>
        <description>To check the checkbox when Contract Order Type EQUALS Subscription Plus Bridge (see below) and Cat Hierarchy L5EQUALSL5_L0167_FP</description>
        <field>APTS_Count_for_KMBridge_Product_New__c</field>
        <literalValue>1</literalValue>
        <name>APTS_Count for KMBridge Product_New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Apttus_Proposal__Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateNetPriceOfLineItem_FieldUpdat</fullName>
        <description>Update Proposal line item field with Line Item&apos;s Net Price value.</description>
        <field>APTS_Line_Item_Net_Price__c</field>
        <formula>Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__NetPrice__c</formula>
        <name>APTS_UpdateNetPriceOfLineItem_FieldUpdat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Effective_Date_Update</fullName>
        <field>APTS_Renewal_Effective_Date__c</field>
        <formula>Apttus_QPConfig__AssetLineItemId__r.APTS_Info_RenewalDate__c</formula>
        <name>Renewal Effective Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Material_Number</fullName>
        <description>DOC-7195 (Version / Non Version Product)</description>
        <field>APTS_Renewal_Material_Number__c</field>
        <formula>if((APTS_Proposal_Business_Unit__c = &apos;Corp OneOTC US&apos;
|| APTS_Proposal_Business_Unit__c = &apos;Corp OneOTC UK&apos;)
&amp;&amp; ISPICKVAL(Apttus_QPConfig__LineStatus__c , &apos;Renewed&apos;),
if(NOT(ISBLANK(Apttus_QPConfig__OptionId__c)),
if(NOT(ISBLANK(Apttus_QPConfig__OptionId__r.APTS_Availability_Date__c)),
Apttus_QPConfig__OptionId__r.APTS_SwapAndVersion__c,
APTS_Service_Number__c),
if(NOT(ISBLANK(Apttus_Proposal__Product__r.APTS_Availability_Date__c)),
Apttus_Proposal__Product__r.APTS_SwapAndVersion__c,
APTS_Service_Number__c)
),
&apos;&apos;)</formula>
        <name>Renewal Material Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>To_Update_Net_Price_Display_Value</fullName>
        <field>APTS_Net_Price_PrintProview_No_Sub__c</field>
        <formula>APTS_Net_Price_display__c</formula>
        <name>To Update Net Price Display Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Count_Of_Online_Field</fullName>
        <field>APTS_Boolean_Count_of_Online__c</field>
        <literalValue>1</literalValue>
        <name>Update Count Of Online Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Apttus_Proposal__Proposal__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Long_Product_Description</fullName>
        <description>Update Long Product Description from Option or Product2</description>
        <field>Long_Product_Desc__c</field>
        <formula>IF(NOT(ISBLANK(Apttus_QPConfig__OptionId__c)), Apttus_QPConfig__OptionId__r.Long_Product_Desc__c , Apttus_Proposal__Product__r.Long_Product_Desc__c)</formula>
        <name>Update Long Product Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Renewal_Description</fullName>
        <description>DOC-7195 (Version / Non Version Product)</description>
        <field>APTS_Renewal_Description__c</field>
        <formula>If((APTS_Proposal_Business_Unit__c = &apos;Corp OneOTC US&apos;
|| APTS_Proposal_Business_Unit__c = &apos;Corp OneOTC UK&apos;)
&amp;&amp; ISPICKVAL(Apttus_QPConfig__LineStatus__c , &apos;Renewed&apos;),
If(NOT(ISBLANK(Apttus_QPConfig__DerivedFromId__r.APTS_Renewal_Description__c)),
Apttus_QPConfig__DerivedFromId__r.APTS_Renewal_Description__c,Long_Product_Desc__c)
,&apos;&apos;)</formula>
        <name>Update Renewal Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Findlaw_Renewal_only</fullName>
        <field>APTS_FL_Renewal_OnlyFlag__c</field>
        <literalValue>1</literalValue>
        <name>update Findlaw Renewal only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Apttus_Proposal__Proposal__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>APTS Contract Subscription Display</fullName>
        <actions>
            <name>APTS_Contract_Subs_Display_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule updates the Contract Subscription Type Display field</description>
        <formula>NOT( ISBLANK( Contract_Subscription_Type_Text__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS NetPrice PrintProview NoSub Update</fullName>
        <actions>
            <name>To_Update_Net_Price_Display_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3) OR (2 AND 3 AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Media_High_Level_Code__c</field>
            <operation>equals</operation>
            <value>07,21,08</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Contract_Subscription_Type__c</field>
            <operation>equals</operation>
            <value>Ship Only-No Subscription,Entitle only - no subscription,Seminars,Ship-Entitle-No Subscription</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.Apttus_QPConfig__LineType__c</field>
            <operation>notEqual</operation>
            <value>Option,Misc</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Media_High_Level_Code__c</field>
            <operation>equals</operation>
            <value>02</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Canada</value>
        </criteriaItems>
        <description>To Update the field APTS Net Price PrintProview No Sub on Proposal Line Item</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS Populate Long Product Description</fullName>
        <actions>
            <name>Renewal_Effective_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Renewal_Material_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Long_Product_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Renewal_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Update Contract Subscription</fullName>
        <actions>
            <name>APTS_Contract_Subscription_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>Canada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Media_High_Level_Code__c</field>
            <operation>equals</operation>
            <value>02</value>
        </criteriaItems>
        <description>This rule updates the Contract Subscription field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Contract WL Flex Windows_New</fullName>
        <actions>
            <name>APTS_Contract_WL_Flex_Windows_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Subscription_Number__c</field>
            <operation>equals</operation>
            <value>41659192,41659193,41659194,41659195</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.Apttus_QPConfig__LineStatus__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>The checkbox will return true when Sub# equals 41659192, 41659193, 41659194 and 41659195</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Count for KMBridge Product_New</fullName>
        <actions>
            <name>APTS_Count_for_KMBridge_Product_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Contract_Order_Type__c</field>
            <operation>equals</operation>
            <value>Subscription Plus Bridge (see below)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Cat_L5__c</field>
            <operation>equals</operation>
            <value>L5_L0167_FP</value>
        </criteriaItems>
        <description>It will check the checkbox when Contract Order Type EQUALS Subscription Plus Bridge (see below) and Cat Hierarchy L5EQUALSL5_L0167_FP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_UpdateNetPriceOfLineItem</fullName>
        <actions>
            <name>APTS_UpdateNetPriceOfLineItem_FieldUpdat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>It will update Net Price of Line Item on the Proposal line Item field.</description>
        <formula>NOT(ISNULL(Apttus_QPConfig__DerivedFromId__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Count Of Online Field</fullName>
        <actions>
            <name>Update_Count_Of_Online_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Apttus_QPConfig__PriceType__c, &apos;Recurring&apos;) &amp;&amp;  ISPICKVAL(Apttus_QPConfig__ChargeType__c , &apos;Subscription Fee&apos;) &amp;&amp; ISPICKVAL(Apttus_QPConfig__LineStatus__c , &apos;New&apos;) &amp;&amp; ISPICKVAL(Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c, &apos;FindLaw&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update FindLawRenewal Flag</fullName>
        <actions>
            <name>update_Findlaw_Renewal_only</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.Apttus_QPConfig__LineStatus__c</field>
            <operation>equals</operation>
            <value>Renewed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Proposal_Business_Unit__c</field>
            <operation>equals</operation>
            <value>FindLaw</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
