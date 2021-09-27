<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TaxProfcreatesoldtoCustomer</fullName>
        <ccEmails>taxsapcustomerquotecreationservice@x-1rs3pm9z46ydmtl8y4q61ehuksrab61yf8h9y47kbwou5x0kmn.3-plslea2.na131.apex.salesforce.com</ccEmails>
        <description>TaxProfcreatesoldtoCustomer</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TaxprofCreateSoldToCustomer</template>
    </alerts>
    <rules>
        <fullName>TaxProf Trigger SoldTo ZPND</fullName>
        <actions>
            <name>TaxProfcreatesoldtoCustomer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(AND( APTS_Proposal_Business_Unit__c == &apos;Tax Professional&apos;, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.RecordType.Name = &apos;LOTUS Source Systems&apos;, Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c = NULL, ISCHANGED(Apttus_Config2__Status__c),ISPICKVAL(Apttus_Config2__Status__c , &apos;Finalized&apos;), Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.APTS_ZPEND_Flag__c = false ),AND( CONTAINS(&apos;SCS,FindLaw,Corp OneOTC US,Corp OneOTC UK,Canada,Argentina-LLEY,Brazil-TSL&apos;,APTS_Proposal_Business_Unit__c),ISPICKVAL(Apttus_Config2__Status__c , &apos;Finalized&apos;),ISCHANGED(Apttus_Config2__Status__c), Apttus_QPConfig__Proposald__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c = NULL))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
