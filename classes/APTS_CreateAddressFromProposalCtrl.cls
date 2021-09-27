public with sharing class APTS_CreateAddressFromProposalCtrl {
    Id accountId;
    Id proposalId;
    Id newAddressId;
    public Address__c newAddress {get; set;}
    public string exceptionMsg {get; set;}
    public boolean isError {get; set;}
    // Country & state dropdown fields- Sreenu
    public List<SelectOption> countryOpts {get; set;}
    public List<SelectOption> stateOpts {get; set;}
    public Boolean isEdit = False; // used to identify forc SC-Edit

    public APTS_CreateAddressFromProposalCtrl(){
        isError = FALSE;        
        accountId = ApexPages.currentPage().getParameters().get('accountId');
       // proposalId = ApexPages.currentPage().getParameters().get('id');
        newAddressId = ApexPages.currentPage().getParameters().get('newAddressId');
        newAddress = new Address__c(Country__c = 'US');
        newAddress.Address_Type__c = 'One Time Ship To';
        newAddress.AccountId__c = accountId;
        newAddress.Parent_Type__c = 'Account';
        countryStateList();        
    }
    public APTS_CreateAddressFromProposalCtrl(ApexPages.StandardController sc){
        isEdit = True;
        newAddress = new Address__c();
        newaddress = [SELECT AccountId__c,Address_Type__c,City__c,ContactId__c,Country__c,County__c,External_Id__c,Id,Mastering_Source__c,Name,OwnerId,Parent_Type__c,Phone__c,State__c,Street_Address_3__c,Street_Address_4__c,Street__c,SystemModstamp,Zipcode__c FROM Address__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        countryStateList();
    }
    public void countryStateList() {    
        proposalId = ApexPages.currentPage().getParameters().get('id');
        countryOpts = new List<SelectOption>();
        stateOpts = new List<SelectOption>();
        countryOpts = DataQualityUtil.listAvailableCountryOptions();
        getStates();
    }
    public PageReference doSave()
    {
        try{
            if(newAddress.Name.Length() > 35) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.OCAddressNameValidationMsg));
                return null;           
            }
            if(isEdit)
                update newAddress;
            else {
                insert newAddress;
                if(proposalId != NULL)  {
                    Apttus_Proposal__Proposal__c proposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Id =: proposalId];
                    proposal.APTS_One_Time_Ship_To__c = newAddress.Id;
                    update proposal;
                }
            }
        }catch(Exception e){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));   
            exceptionMsg = e.getMessage();
            isError = TRUE;
            return null;
        }
        return new PageReference('/'+proposalId);
    }
    
    // Method to get the State codes of Country - Sreenu
    public void getStates() {
        stateOpts = DataQualityUtil.listAvailableCountryRegionOptions(newAddress.Country__c);
    }
    
    /*public PageReference doAction(){
        String addressAPIName = 'Address__c';
        if(accountId!=null){
            
            newAddress.Address_Type__c = 'One Time Ship To';
            newAddress.AccountId__c = accountId;
            newAddress.Parent_Type__c = 'Account';
            try{
                insert newAddress;
                Apttus_Proposal__Proposal__c proposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Id =: proposalId];
                proposal.APTS_One_Time_Ship_To__c = newAddress.Id;
                update proposal;
            }catch(Exception e){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));   return null;
            }
            newAddressId = newAddress.Id;
            PageReference editPage = new PageReference('/'+newAddressId+'/e?retURL=/'+proposalId+'&cancelURL=/apex/APTS_CreateAddressFromProposal?newAddressId='+newAddressId+'%26id='+proposalId);
            return editPage;
        }
        else{
            try{
                Apttus_Proposal__Proposal__c proposal = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Id =: proposalId];
                proposal.APTS_One_Time_Ship_To__c = null;
                update proposal;
                deleteObject(newAddressId, addressAPIName);
                return doCancel();
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                return null;
            }
        }
    }*/

    public PageReference doCancel(){
        return new PageReference('/'+proposalId);
    }

    /*private void deleteObject(Id recordId, String objectAPIName){
        String query = 'SELECT Id FROM '+objectAPIName+' where Id=\''+recordId+'\'';
        List<SObject> deleteObjects = Database.query(query);
        delete deleteObjects;
    }*/
}