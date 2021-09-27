public with sharing class APTS_AdditionalApprovalController {
    public Boolean initialApprovalFlag {get;set;}
    public Boolean legalLanguageChangeFlag {get;set;}
    public Boolean otherFlag {get;set;}
    public Apttus_Config2__ProductConfiguration__c cart {get;set;}
    
    public APTS_AdditionalApprovalController () {
        Id cartId = ApexPages.currentPage().getParameters().get('id');
        this.cart = [SELECT Id, APTS_Additional_Approval_Required__c, APTS_Additional_Approval_Legal__c,
            APTS_Additional_Approval_Other__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id =: cartId];
        this.initialApprovalFlag = this.cart.APTS_Additional_Approval_Required__c;
        this.legalLanguageChangeFlag = this.cart.APTS_Additional_Approval_Legal__c;
        this.otherFlag = this.cart.APTS_Additional_Approval_Other__c;
        
    }

    public void doSave(){
        this.cart.APTS_Additional_Approval_Required__c = true;
        this.cart.APTS_Additional_Approval_Legal__c = legalLanguageChangeFlag;
        this.cart.APTS_Additional_Approval_Other__c = otherFlag;
        update this.cart;
        this.repriceCart();
    }
    
    public void doCancel(){
        this.cart.APTS_Additional_Approval_Required__c = false;
        this.cart.APTS_Additional_Approval_Legal__c = false;
        this.cart.APTS_Additional_Approval_Other__c = false;
        
        update this.cart;
        this.repriceCart();
    }

    private void repriceCart(){
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = this.cart.Id;
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
    }
}