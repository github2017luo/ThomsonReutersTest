<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Configure SCM for Engagement</label>
    <protected>false</protected>
    <values>
        <field>fferpcore__Configuration__c</field>
        <value xsi:type="xsd:string">{
				&quot;fferpcore:EngagementWizardSetup&quot;: {
					&quot;Lightning App&quot;: &quot;&quot;
				},
				&quot;fferpcore:engagementSetupFeature&quot;: {
					&quot;Lightning Component&quot;: &quot;&quot;
				}
			}</value>
    </values>
    <values>
        <field>fferpcore__DisableRevertAction__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>fferpcore__Feature__c</field>
        <value xsi:type="xsd:string">fferpcore__Engagement</value>
    </values>
    <values>
        <field>fferpcore__IsOptional__c</field>
        <value xsi:type="xsd:string">Optional</value>
    </values>
    <values>
        <field>fferpcore__StepDescription__c</field>
        <value xsi:type="xsd:string">fferpcore__ErpFeatureStepDescriptionConfigureSCMForEngagement</value>
    </values>
    <values>
        <field>fferpcore__StepNumber__c</field>
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>fferpcore__StepType__c</field>
        <value xsi:type="xsd:string">Lightning Component</value>
    </values>
</CustomMetadata>
