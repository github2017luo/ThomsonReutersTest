<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Update Skill Rating Picklist Option</label>
    <protected>false</protected>
    <values>
        <field>fferpcore__Configuration__c</field>
        <value xsi:type="xsd:string">{
    &quot;name&quot;: &quot;pse__Skill_Certification_Rating__c.pse__Rating__c&quot;,
    &quot;values&quot;: {
           &quot;0 - No Rating&quot; : {
                    &quot;operation&quot;: {
                              &quot;enable&quot;: &quot;add&quot;,
                               &quot;disable&quot;: &quot;remove&quot;
                      }
            },
            &quot;None&quot; : {
                  &quot;operation&quot;: {
                              &quot;enable&quot;: &quot;remove&quot;,
                               &quot;disable&quot;: &quot;add&quot;
                      }
             }
      }
}</value>
    </values>
    <values>
        <field>fferpcore__DisableRevertAction__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>fferpcore__Feature__c</field>
        <value xsi:type="xsd:string">pse__SkillRatingPicklist</value>
    </values>
    <values>
        <field>fferpcore__IsOptional__c</field>
        <value xsi:type="xsd:string">Required</value>
    </values>
    <values>
        <field>fferpcore__StepDescription__c</field>
        <value xsi:type="xsd:string">pse__feature_console_step_upgrade_skill_rating_description</value>
    </values>
    <values>
        <field>fferpcore__StepNumber__c</field>
        <value xsi:type="xsd:double">1.0</value>
    </values>
    <values>
        <field>fferpcore__StepType__c</field>
        <value xsi:type="xsd:string">Picklist</value>
    </values>
</CustomMetadata>
