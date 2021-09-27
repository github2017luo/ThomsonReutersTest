<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Update the Project Detail Layout Step 2</label>
    <protected>false</protected>
    <values>
        <field>fferpcore__Configuration__c</field>
        <value xsi:type="xsd:string">{
    		&quot;pse__Proj__c-pse__Project Detail Layout&quot;: {
         		&quot;fields&quot; : {
					&quot;pse__Auto_Cap_Project_Billing__c&quot; : {
						&quot;operation&quot; : {
							&quot;enable&quot; : &quot;Add&quot;,
                          	&quot;disable&quot; : &quot;Remove&quot;
                      	},
                     	&quot;anchor&quot;: {
							&quot;enable&quot;: &quot;Project Tracking__1&quot;,
							&quot;disable&quot;: &quot;Project Tracking__1&quot;
                		}
					}
				}
			}
		}</value>
    </values>
    <values>
        <field>fferpcore__DisableRevertAction__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>fferpcore__Feature__c</field>
        <value xsi:type="xsd:string">pse__Track_Projects_Against_Billing_Cap</value>
    </values>
    <values>
        <field>fferpcore__IsOptional__c</field>
        <value xsi:type="xsd:string">Optional</value>
    </values>
    <values>
        <field>fferpcore__StepDescription__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>fferpcore__StepNumber__c</field>
        <value xsi:type="xsd:double">2.0</value>
    </values>
    <values>
        <field>fferpcore__StepType__c</field>
        <value xsi:type="xsd:string">Page Layout</value>
    </values>
</CustomMetadata>
