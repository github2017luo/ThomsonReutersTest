<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PopulateSubscribableIndicator</fullName>
        <field>Subscribable_Indicator__c</field>
        <formula>TEXT(Product2.Subscribable_Indicator__c)</formula>
        <name>PopulateSubscribableIndicator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QLITotalPriceCalculationUpdate</fullName>
        <field>Total_Price_Calculation__c</field>
        <formula>Round(Quantity * UnitPrice * (1 - IF(ISNULL(Discount), 0, Discount)), Decimal_Places_for_Currency__c )</formula>
        <name>QLITotalPriceCalculationUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Entitlement_Oneshot_Product_as_TRUE</fullName>
        <field>Entitlement_Oneshot_Product__c</field>
        <literalValue>1</literalValue>
        <name>Set Entitlement Oneshot Product as TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activity_Type_to_Downgrade</fullName>
        <field>Item_Activity_Type__c</field>
        <literalValue>Downgrade</literalValue>
        <name>Update Activity Type to Downgrade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activity_Type_to_Upgrade</fullName>
        <field>Item_Activity_Type__c</field>
        <literalValue>Uplift</literalValue>
        <name>Update Activity Type to Upgrade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PopulateSubscribableIndicator</fullName>
        <actions>
            <name>PopulateSubscribableIndicator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(  LastModifiedDate )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Entitlement Oneshot Product True</fullName>
        <actions>
            <name>Set_Entitlement_Oneshot_Product_as_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Entitlement Product checkbox  as true in QLI if related product is a one shot product. 
[Proview Tokenization]</description>
        <formula>AND(  OR(    $Profile.Name = &quot;LatAm User&quot;,    $Profile.Name = &quot;Partner Portal User&quot;,    $Profile.Name = &quot;System Administrator&quot;    ),    Product2.Entitlement_Oneshot__c = TRUE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ActivityType to Downgrade - Renewals</fullName>
        <actions>
            <name>Update_Activity_Type_to_Downgrade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update ActivityType to Downgrade - Renewals</description>
        <formula>AND( 	Quote.Renewal_Flag_Formula__c = true, 	Quote.RecordType.Name = &apos;LATAM Renewal Quote&apos;, 	!ISNEW(), 	OR( 	 		ISPICKVAL(Item_Activity_Type__c, &apos;Renewed&apos;), 		ISPICKVAL(Item_Activity_Type__c, &apos;Uplift&apos;),  		ISPICKVAL(Item_Activity_Type__c, &apos;Downgrade&apos;) 	), 		 		 	( 		(ISCHANGED(UnitPrice) || ISCHANGED(Quantity) || ISCHANGED(Discount))&amp;&amp; 			( 				OR 				( 				AND(Discount != 0,!ISNULL(Discount) ,((UnitPrice *Quantity*(1-Discount)) &lt; Projected_Renewal_Price__c)), 				AND(OR(ISNULL(Discount), ISBLANK(Discount), Discount = 0), UnitPrice *Quantity &lt; Projected_Renewal_Price__c)						 				) 			) 	) )</formula>
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
        <formula>AND( 	Quote.Renewal_Flag_Formula__c = true, 	Quote.RecordType.Name = &apos;LATAM Renewal Quote&apos;, 	!ISNEW(), 	OR( 	 		ISPICKVAL(Item_Activity_Type__c, &apos;Renewed&apos;), 		ISPICKVAL(Item_Activity_Type__c, &apos;Uplift&apos;),  		ISPICKVAL(Item_Activity_Type__c, &apos;Downgrade&apos;) 	), 	 	(  		(ISCHANGED(UnitPrice) || ISCHANGED(Quantity) || ISCHANGED(Discount))&amp;&amp; 			( 				OR 				( 				AND(Discount != 0, !ISNULL(Discount) ,(( UnitPrice*Quantity*(1-Discount)) &gt; Projected_Renewal_Price__c)), 				AND(OR(ISNULL(Discount), ISBLANK(Discount), Discount = 0),  UnitPrice*Quantity &gt; Projected_Renewal_Price__c)						 				) 			) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateTotalPriceCalculationFromTotalPrice</fullName>
        <actions>
            <name>QLITotalPriceCalculationUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.UnitPrice</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This work flow rule is to update total price calculation field to refer in QLI formula due complie size errors</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
