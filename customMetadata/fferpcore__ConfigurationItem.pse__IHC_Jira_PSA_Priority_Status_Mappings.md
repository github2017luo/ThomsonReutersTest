<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>IHC Jira-PSA Priority &amp; Status Mappings</label>
    <protected>false</protected>
    <values>
        <field>fferpcore__Enabled__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>fferpcore__ItemKey__c</field>
        <value xsi:type="xsd:string">project-task:mappings</value>
    </values>
    <values>
        <field>fferpcore__ItemType__c</field>
        <value xsi:type="xsd:string">psa:ihc:jira</value>
    </values>
    <values>
        <field>fferpcore__LargeData__c</field>
        <value xsi:type="xsd:string">[
  {
    &quot;PSAToJiraStatusMappings&quot;: {
      &quot;DefaultStatusValuesMapping&quot;: {
        &quot;Draft&quot;: &quot;To Do&quot;,
        &quot;Planned&quot;: &quot;To Do&quot;,
        &quot;Started&quot;: &quot;In Progress&quot;,
        &quot;Blocked&quot;: &quot;In Progress&quot;,
        &quot;Complete&quot;: &quot;Done&quot;,
        &quot;Deferred&quot;: &quot;Done&quot;
      },
      &quot;ProjectSpecificMappings&quot;: [
        {
          &quot;Example1&quot;: {
            &quot;JiraProjectKeys&quot;: [
			  &quot;KEY1&quot;,
			  &quot;KEY2&quot;
            ],
            &quot;StatusValuesMapping&quot;: {
              &quot;Draft&quot;: &quot;To Do&quot;,
			  &quot;Planned&quot;: &quot;To Do&quot;,
			  &quot;Started&quot;: &quot;In Progress&quot;,
			  &quot;Blocked&quot;: &quot;In Progress&quot;,
			  &quot;Complete&quot;: &quot;Done&quot;,
			  &quot;Deferred&quot;: &quot;Done&quot;
            }
          }
        }
      ]
    }
  },
  {
    &quot;PSAToJiraPriorityMappings&quot;: {
      &quot;DefaultPriorityValuesMapping&quot;: {
        &quot;P1&quot;: &quot;Highest&quot;,
        &quot;P2&quot;: &quot;High&quot;,
        &quot;P3&quot;: &quot;Medium&quot;,
        &quot;P4&quot;: &quot;Low&quot;,
        &quot;P5&quot;: &quot;Lowest&quot;
      },
      &quot;ProjectSpecificMappings&quot;: [
        {
          &quot;Example1&quot;: {
            &quot;JiraProjectKeys&quot;: [
              &quot;KEY1&quot;
            ],
            &quot;PriorityValuesMapping&quot;: {
              &quot;P1&quot;: &quot;Highest&quot;,
              &quot;P2&quot;: &quot;High&quot;,
              &quot;P3&quot;: &quot;Medium&quot;,
              &quot;P4&quot;: &quot;Low&quot;,
              &quot;P5&quot;: &quot;Lowest&quot;
            }
          }
        }
      ]
    }
  },
  {
    &quot;JiraToPSAStatusMappings&quot;: {
      &quot;DefaultStatusValuesMapping&quot;: {
        &quot;Open&quot;: &quot;Draft&quot;,
        &quot;In Progress&quot;: &quot;Started&quot;,
        &quot;Done&quot;: &quot;Complete&quot;,
        &quot;To Do&quot;: &quot;Planned&quot;,
        &quot;Under Review&quot;: &quot;Planned&quot;,
        &quot;Cancelled&quot;: &quot;Deferred&quot;
      },
      &quot;ProjectSpecificMappings&quot;: [
        {
          &quot;Example1&quot;: {
            &quot;JiraProjectKeys&quot;: [
              &quot;KEY1&quot;
            ],
            &quot;StatusValuesMapping&quot;: {
              &quot;Open&quot;: &quot;Draft&quot;,
              &quot;In Progress&quot;: &quot;Started&quot;,
              &quot;Done&quot;: &quot;Complete&quot;,
              &quot;To Do&quot;: &quot;Planned&quot;,
              &quot;Under Review&quot;: &quot;Planned&quot;,
              &quot;Cancelled&quot;: &quot;Deferred&quot;
            }
          }
        }
      ]
    }
  },
  {
    &quot;JiraToPSAPriorityMappings&quot;: {
      &quot;DefaultPriorityValuesMapping&quot;: {
        &quot;Highest&quot;: &quot;P1&quot;,
        &quot;High&quot;: &quot;P2&quot;,
        &quot;Medium&quot;: &quot;P3&quot;,
        &quot;Low&quot;: &quot;P4&quot;,
        &quot;Lowest&quot;: &quot;P5&quot;
      },
      &quot;ProjectSpecificMappings&quot;: [
        {
          &quot;Example1&quot;: {
            &quot;JiraProjectKeys&quot;: [
              &quot;KEY1&quot;
            ],
            &quot;PriorityValuesMapping&quot;: {
              &quot;Highest&quot;: &quot;P1&quot;,
              &quot;High&quot;: &quot;P2&quot;,
              &quot;Medium&quot;: &quot;P3&quot;,
              &quot;Low&quot;: &quot;P4&quot;,
              &quot;Lowest&quot;: &quot;P5&quot;
            }
          }
        }
      ]
    }
  }
]</value>
    </values>
    <values>
        <field>fferpcore__SObjectField__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>fferpcore__SObjectType__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>fferpcore__SmallData__c</field>
        <value xsi:type="xsd:string">1</value>
    </values>
</CustomMetadata>
