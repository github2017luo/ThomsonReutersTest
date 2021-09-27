/**
 *  Apttus Config & Pricing
 *  APTS_QuickQuoteController
 *
 *  @2012-2014 Apttus Inc. All rights reserved.
 *  This version is modified to enable SF1 QuickQuote from the account page.
 */
public with sharing class APTS_QuickQuoteController {

    public Account acc;
    private RecordType recType;
    private Apttus_Config2__PriceList__c pl;
    private PriceBook2 pb;
    public APTS_QuickQuoteController(ApexPages.StandardController controller) {
        acc = (Account)controller.getRecord();
        recType = [Select Id From RecordType  Where SobjectType = 'Apttus_Proposal__Proposal__c' and DeveloperName = 'Proposal'];
        
        //Apttus_Config2__ConfigSystemProperties__c prop = Apttus_Config2__ConfigSystemProperties__c.getInstance('System Properties');
        //String priceListName = prop.Apttus_S1Demo__SF1DefaultPricelistName__c == null? 'General':prop.Apttus_S1Demo__SF1DefaultPricelistName__c;
        String priceListName = 'Thomson Reuters Master - US Legal';
        pl = [SELECT Id,Name
            FROM Apttus_Config2__PriceList__c WHERE Name =:priceListName LIMIT 1];
            
        String priceBookName = 'Standard Price Book';
        pb = [Select id, name From pricebook2 WHERE Name=:priceBookName LIMIT 1];    
    }

    /**
     * Creates new Proposal with default values and redirects to app
     */
 
    public PageReference doCreateQuote() {
        /*
        // create a quick quote only if the user has an Apttus license.
        Id userId = UserInfo.getUserId();
        Integer nbrLicenses = [SELECT count() FROM UserPackageLicense WHERE PackageLicense.NamespacePrefix = 'Apttus_Proposal' 
                               AND UserId = :userId limit 1];
        if (nbrLicenses < 1) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'User does not have a valid license to create a Quick Quote!!!'));
             return null;
        }
        */
    
        Opportunity opp = new Opportunity();
        opp.Name = acc.Name +' - Optty - '+System.now();
        opp.AccountId = acc.Id;
        //opp.StageName = 'Appointment Scheduled';
        opp.StageName = '25%';
        opp.Pricebook2Id = pb.Id;
        opp.CloseDate = Date.today();
        insert opp;
        
        Apttus_Proposal__Proposal__c newProp = new Apttus_Proposal__Proposal__c();
        newProp.Apttus_Proposal__Account__c = opp.AccountId;
        newProp.Apttus_Proposal__Approval_Stage__c = 'Draft'; //make dynamic?
        newProp.Apttus_Proposal__Opportunity__c = opp.Id;
        newProp.Apttus_QPConfig__PriceListId__c = pl.Id;
        newProp.Apttus_Proposal__Proposal_Name__c = acc.Name +' - Quote - '+System.now();
        insert newProp;
/*
        PageReference pageRef = Page.Apttus_S1Demo__SF1Start;
        pageRef.getParameters().put('Id',newProp.Id);
        return pageRef;
*/
        PageReference page = new PageReference('/' + newProp.Id); 
        page.setRedirect(true); 
        return page;
    }
}