<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OLITotalPriceCalculationUpdate</fullName>
        <field>Total_Price_Calculation__c</field>
        <formula>ROUND(Quantity * UnitPrice * (1 - IF(ISNULL(Discount), 0, Discount)), Decimal_Places_for_Currency__c )</formula>
        <name>OLITotalPriceCalculationUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMOLI_id</fullName>
        <field>MOLI_id__c</field>
        <formula>LEFT(Id,15)</formula>
        <name>UpdateMOLI_id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activity_Type_to_Downgrade</fullName>
        <field>Activity_Type__c</field>
        <literalValue>Downgrade</literalValue>
        <name>Update Activity Type to Downgrade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activity_Type_to_Upgrade</fullName>
        <field>Activity_Type__c</field>
        <literalValue>Uplift</literalValue>
        <name>Update Activity Type to Upgrade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Family</fullName>
        <field>LCRM_Product_Category__c</field>
        <formula>if(ISBLANK(Product2.LCRM_Product_Category__c),&quot;&quot;, 
if(Product2.LCRM_Product_Category__c= &quot;Service&quot;,&quot;Service&quot;,if(Product2.LCRM_Product_Category__c= &quot;Product&quot;, &quot;Product&quot;, 
if(Product2.LCRM_Product_Category__c= &quot;Maintenance&quot;, &quot;Maintenance&quot;,&quot;&quot;))))</formula>
        <name>Update Product Family</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LCRM_PopulateProductFamily</fullName>
        <actions>
            <name>Update_Product_Family</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, Is_GLI__c = True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PopulateMOLIOnMOLI</fullName>
        <actions>
            <name>UpdateMOLI_id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = FALSE, Opportunity.Is_Child_Opportunity__c  &lt;&gt; True)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update ActivityType to Downgrade - Renewals</fullName>
        <actions>
            <name>Update_Activity_Type_to_Downgrade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update ActivityType to Downgrade - Renewals</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, 	Opportunity.Renewal_Flag__c = true, 	Opportunity.RecordType.Name = &apos;LATAM Renewal Opportunity&apos;, 	!ISNEW(), 	OR( 	 		ISPICKVAL(Activity_Type__c, &apos;Renewed&apos;), 		ISPICKVAL(Activity_Type__c, &apos;Uplift&apos;),  		ISPICKVAL(Activity_Type__c, &apos;Downgrade&apos;) 	), 	 	(  		(ISCHANGED(UnitPrice) || ISCHANGED(Quantity) || ISCHANGED(Discount))&amp;&amp; 			( 				TotalPrice &lt; Projected_Renewal_Price__c 			) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ActivityType to Upgrade - Renewals</fullName>
        <actions>
            <name>Update_Activity_Type_to_Upgrade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update ActivityType to Upgrade - Renewals</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false, 	Opportunity.Renewal_Flag__c = true, 	Opportunity.RecordType.Name = &apos;LATAM Renewal Opportunity&apos;, 	!ISNEW(), 	OR( 	 		ISPICKVAL(Activity_Type__c, &apos;Renewed&apos;), 		ISPICKVAL(Activity_Type__c, &apos;Uplift&apos;),  		ISPICKVAL(Activity_Type__c, &apos;Downgrade&apos;) 	),   	( 		(ISCHANGED(UnitPrice) || ISCHANGED(Quantity) || ISCHANGED(Discount)) &amp;&amp; 			( 				TotalPrice &gt; Projected_Renewal_Price__c 				 			) 	)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateTotalPriceCalculationFromTotalPrice</fullName>
        <actions>
            <name>OLITotalPriceCalculationUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This work flow rule is to update total price calculation field to refer in OLI to make sync with QLI Total Price formula</description>
        <formula>AND( $Setup.LTS_Disable_Application_Automation__c.LTS_Disable_Workflow_Rules__c = false,UnitPrice &lt;&gt; null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
