/**
* Controls the page which adds options to the fill up products
* @author Alex Shung
* @version 7/8/2016
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
*/
public with sharing class APTS_FillUpPageController {
    Id lineItemId;
    public Integer optionsCount {get;set;}
    public String returnLink {get;set;}
    public String resultMessage {get;set;}
    public boolean showBottomBlock { get; set; }
    public String configId { get; set; }
    public String configRequestId { get; set; }
     public String BusinessObjectId { get; set; }
     public String productConfig { get; set; }
 
   
  
    public APTS_FillUpPageController() {
        this.optionsCount = 1;
        this.showBottomBlock = false;
        lineItemId = ApexPages.currentPage().getParameters().get('lineItemId');
    }
    public PageReference doAction(){
        
        Apttus_Config2__LineItem__c liSO = [SELECT Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Id, Apttus_Config2__PriceListId__c,
                                            Apttus_Config2__LineNumber__c
                                            FROM Apttus_Config2__LineItem__c
                                            WHERE Id =: lineItemId limit 1];

        Integer optionsCount = 0;                                                
        Id cartId = liSO.Apttus_Config2__ConfigurationId__c;                                    
        try{
            optionsCount = APTS_PricingCallbackMethods.addOptionsToLineItemSO(liSO, cartId);
            }catch(Exception e){
                System.debug('retUrl :'+e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
                return null;
            }
        PageReference pf = new pageReference(ApexPages.currentPage().getHeaders().get('Referer'));  
        //PageReference pf = new PageReference('/Cart');
        PageReference currentPage = ApexPages.currentPage();
        pf.getParameters().put('configRequestId', currentPage.getParameters().get('configRequestId'));
        pf.getParameters().put('flow', currentPage.getParameters().get('flow'));
        pf.getParameters().put('id', cartId);
        //return null;
        //return null;

        Map<String,String> returnData = new Map<String,String>();
        this.optionsCount = optionsCount;
        //this.returnLink = pf.getUrl();

        this.resultMessage = optionsCount > 0 ? optionsCount+ ' Fill-Up options were added to cart' : optionsCount+' Fill-Up option was added to cart';
        this.showBottomBlock = true;


         configId = ApexPages.currentPage().getParameters().get('id');
         configRequestId = ApexPages.currentPage().getParameters().get('configRequestId');
         BusinessObjectId = ApexPages.currentPage().getParameters().get('businessObjectId');
         productConfig = ApexPages.currentPage().getParameters().get('id');
         
         string retURLStr;
         string retUrl =  '/apex/apttus-config2__Cart?configRequestId='+configRequestId+'&flow=ngcpq%23%2Fcart&id='+configId+'#/cart';
         System.debug('retUrl :'+retUrl);
         if(retUrl != null && retUrl != ''){
            retURLStr = retUrl;
         }
         else{
             retURLStr = '/apex/apttus-config2__CartDetailView?configRequestId='+configRequestId+'&businessObjectId='+BusinessObjectId+'&id='+productConfig+'&retId='+BusinessObjectId;
         }

         this.returnLink = retURLStr;

        return null;
    }
    
    public Pagereference onClickCancel() {
        Pagereference objpage = new Pagereference('/apex/apttus-config2__Cart?configRequestId='+configRequestId+'&flow=ngcpq%23%2Fcart&id='+configId+'#/cart');
        objpage.setRedirect(True);
        return objpage;
    }
}