<aura:application extends="ltng:outApp" controller="additionalClausesMultiSelectController"> 
<!--<aura:attribute name="selectedRecordsList" type="additionalClausesMultiSelectController.SObjectResult[]" description="text" ></aura:attribute>
<aura:attribute name="searchedRecordsList" type="additionalClausesMultiSelectController.SObjectResult[]" description="text" ></aura:attribute>
<aura:attribute name="recordid" type="Id" description="text" ></aura:attribute>
<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
<lightning:card title="" class="slds-p-around_medium">

    <c:multiSelectLookUpLWC objectName="APTS_Additional_Clauses__c" fieldName="APTS_Clause_Title__c" 
                      iconName = "standard:account" onselected="{!c.selectedRecords}" selectedRecords="{!v.selectedRecordsList}" recordid = "{!v.recordid}" 
                      searchRecords="{!v.searchedRecordsList}" allclausesList="{!v.searchedRecordsList}"/>
</lightning:card>-->
    
     <aura:attribute name="recordid" type="Id" description="text" />
    <div class="slds-box">
        <c:multiSelectLookUpLWC objectName="APTS_Additional_Clauses__c" fieldName="APTS_Clause_Title__c" iconName = "standard:account" recordid = "{!v.recordid}" />
    </div>
</aura:application>