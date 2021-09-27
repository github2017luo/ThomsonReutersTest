<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>DCSSD_0006</label>
    <protected>false</protected>
    <values>
        <field>Class__c</field>
        <value xsi:type="xsd:string">Digital_Cohort_SSDCheck</value>
    </values>
    <values>
        <field>Explanation__c</field>
        <value xsi:type="xsd:string">Check whether Digital Opportunity is created on SSD
If Manual Check whether Opportunity is created by renewal job and has Renewal Date as Same as DS Data
If Post Cohorts checks whether Opportunity is created after Job Start time and Satisfies General Conditions like Manual
If Pre-Cohorts Doesnt Check it</value>
    </values>
    <values>
        <field>Fatal_Error__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>Message__c</field>
        <value xsi:type="xsd:string">SSD Has No Automation created Opportunities</value>
    </values>
    <values>
        <field>Object__c</field>
        <value xsi:type="xsd:string">SourceSystemDetail</value>
    </values>
    <values>
        <field>Severity_Level__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
