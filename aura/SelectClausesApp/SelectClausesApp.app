<aura:application extends="force:slds" >
    <aura:attribute name="recordid" type="Id" description="text" />
	<c:multiSelectLookUpLWC objectName="APTS_Additional_Clauses__c" fieldName="APTS_Clause_Title__c" iconName = "standard:account" recordid = "{!v.recordid}" loadedfromcart = "false" />
</aura:application>