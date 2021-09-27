<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Update the Project Detail Layout</label>
    <protected>false</protected>
    <values>
        <field>fferpcore__Configuration__c</field>
        <value xsi:type="xsd:string">{
    		&quot;pse__Proj__c-pse__Project Detail Layout&quot;: {
       			&quot;sections&quot; : {
              		&quot;Project Tracking&quot;: {
                		&quot;operation&quot; : &quot;Add&quot;,
                		&quot;anchor&quot;: &quot;Information&quot;,
                		&quot;detail&quot;: &quot;true&quot;,
                		&quot;edit&quot;: &quot;true&quot;,
                		&quot;style&quot;: &quot;TwoColumnsLeftToRight&quot;
					}
				},
         		&quot;fields&quot; : {
              		&quot;pse__Apply_Billing_Cap__c&quot; : {
						&quot;operation&quot; : {
							&quot;enable&quot; : &quot;Add&quot;,
                          	&quot;disable&quot; : &quot;Remove&quot;
                      	},
                     	&quot;anchor&quot;: {
							&quot;enable&quot;: &quot;Project Tracking__0&quot;,
							&quot;disable&quot;: &quot;Project Tracking__0&quot;
                		}
					},
					&quot;pse__Alert_Threshold__c&quot; : {
						&quot;operation&quot; : {
							&quot;enable&quot; : &quot;Add&quot;,
						 	&quot;disable&quot; : &quot;Remove&quot;
					 	},
						&quot;anchor&quot;: {
							&quot;enable&quot;: &quot;Project Tracking__1&quot;,
							&quot;disable&quot;: &quot;Project Tracking__1&quot;
				   		}
			   		},
			   		&quot;pse__Email_Alert_Recipient__c&quot; : {
						&quot;operation&quot; : {
							&quot;enable&quot; : &quot;Add&quot;,
							&quot;disable&quot; : &quot;Remove&quot;
				 		},
						&quot;anchor&quot;: {
							&quot;enable&quot;: &quot;pse__Alert_Threshold__c&quot;,
							&quot;disable&quot;: &quot;pse__Alert_Threshold__c&quot;
						}
					},
					&quot;pse__Percentage_Used__c&quot; : {
						&quot;operation&quot; : {
							&quot;enable&quot; : &quot;Add&quot;,
							&quot;disable&quot; : &quot;Remove&quot;
			 			},
						&quot;anchor&quot;: {
							&quot;enable&quot;: &quot;pse__Apply_Billing_Cap__c&quot;,
							&quot;disable&quot;: &quot;pse__Apply_Billing_Cap__c&quot;
						},
						&quot;behaviour&quot; : &quot;Readonly&quot;
					},
					&quot;pse__Remaining_Amount__c&quot; : {
						&quot;operation&quot; : {
							&quot;enable&quot; : &quot;Add&quot;,
							&quot;disable&quot; : &quot;Remove&quot;
						},
						&quot;anchor&quot;: {
							&quot;enable&quot;: &quot;pse__Percentage_Used__c&quot;,
							&quot;disable&quot;: &quot;pse__Percentage_Used__c&quot;
						},
						&quot;behaviour&quot; : &quot;Readonly&quot;
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
        <value xsi:type="xsd:string">Required</value>
    </values>
    <values>
        <field>fferpcore__StepDescription__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>fferpcore__StepNumber__c</field>
        <value xsi:type="xsd:double">1.0</value>
    </values>
    <values>
        <field>fferpcore__StepType__c</field>
        <value xsi:type="xsd:string">Page Layout</value>
    </values>
</CustomMetadata>
