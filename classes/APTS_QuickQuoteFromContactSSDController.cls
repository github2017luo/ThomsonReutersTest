/**********************************************************************
 Name:  APTS_QuickQuoteFromContactSSDController

======================================================
Req: 
CRM8340 - Controller for creating quote from Contact SSD detail page
======================================================
Purpose:                                                            
Allows user to create contacts associated with the newOpportunityortunity
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL
   1.0 -   Keerthana        11/23/2017     Initial Development
***********************************************************************/
public with sharing class APTS_QuickQuoteFromContactSSDController {
 
  public id contactId;
  public id sourceSystemDetailId;
  public id accountId;
  public String accountName;
  private id proposalRecTypeId;
  private id opportunityRecTypeId ;
  //private Apttus_Config2__PriceList__c priceList;
  private PriceBook2 priceBook;
  public PriceBook2 priceBook1;
  public PriceBook2 priceBookCARS;
  public String ssdid;
  public String accId;
  public String accname;
  public String conId;
  
  public APTS_QuickQuoteFromContactSSDController () {
    //SOC-9796 PMD Fix
       conId = string.escapeSingleQuotes('contactId');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(conId))){        
            this.contactId= (String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)));
        }
        ssdid = string.escapeSingleQuotes('ssdId');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(ssdid))){
            this.sourceSystemDetailId= (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(ssdid)));
        }
        accId = string.escapeSingleQuotes('accountId');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(accId))){
            this.accountId= (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(accId)));
        }
        accname = string.escapeSingleQuotes('accountName');
        if(string.isNotBlank(ApexPages.currentPage().getParameters().get(accname))){
            this.accountName= (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(accname)));
        }
        proposalRecTypeId= Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        opportunityRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        /*String priceListName = 'Thomson Reuters Master - US Legal';
        if(Schema.sObjectType.Apttus_Config2__PriceList__c.isAccessible()){
        priceList = [SELECT Id,Name FROM Apttus_Config2__PriceList__c WHERE Name =:priceListName LIMIT 1];    
        }*/
          
        String priceBookName = 'Standard Price Book';
        if(Schema.sObjectType.pricebook2.isAccessible()){
            priceBook = [Select id, name From pricebook2 WHERE Name=:priceBookName LIMIT 1];
   }
   }

/**********************************************************************
Method Name : doCreateQuote
Description : On click of 'Quick Quote' button on Contact Source System Detail detail page , 
              creates new Opportunity and then quote for that opportunity if valid Source Sytem Detail exists for that Contact Source System Detail

***********************************************************************/              
              
              
  public PageReference doCreateQuote() {
      Source_System_Detail__c ssd;
      //Set<String> SubBuWestSet=new Set<String>{'Findlaw','LMS','USL'};
      User loggedUser;
      if(sourceSystemDetailId==null)
       {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Quote cannot be created without Account SSD.'));
        return null;
       }
       //Commented as part of CrossSell
        /*if(Schema.sObjectType.user.isAccessible()){
         loggedUser=[select id,Sub_Bu__c,Segment__c,Default_Catalog__c from user where id =: UserInfo.getUserId()];
        }*/
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible()){
             ssd =[select id,Source_System_Account_Number__c,LCRM_Sales_Org__c, BU_Segment__c from Source_System_Detail__c where id=:sourceSystemDetailId ];
        }
        List<Business_Partner_Function__c> businnesPartner = new List<Business_Partner_Function__c> ();
        if(Schema.sObjectType.Business_Partner_Function__c.isAccessible()){
        businnesPartner =[Select id,Sold_To_Account_GLI__c,Relationship_Type__c  from Business_Partner_Function__c where Sold_To_Account_GLI__r.Id=:ssd.id];
        }
        Boolean status =false;
        for(Business_Partner_Function__c bp :businnesPartner ){
            if(bp.Relationship_Type__c =='Sold to party' || bp.Relationship_Type__c =='Sold-to party' || bp.Relationship_Type__c =='Sold To'){
            status = true;
            break;
            }
        }
        //Commented as part of CrossSell
        /*if( ssd.LCRM_Sales_Org__c !='WEST' && !String.isBlank(loggedUser.Default_Catalog__c)
         && (subBuWestSet.contains( loggedUser.Default_Catalog__c))){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Proposal can only be created on an SSD account in the WEST Sales Org'));
            return null;
        }
      //DOC - 3650 changes start here 
      if( ssd.LCRM_Sales_Org__c !=label.SALESORGCARS &&  loggedUser.Sub_Bu__c==label.SALESORGCAN){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Proposal can only be created on an SSD account in the '+ Label.SALESORGCARS +' Sales Org'));
        return null;
        }*/
      //DOC-3650 changes end here
        /*  else if(businnesPartner.size() == 0 && ssd.Source_System_Account_Number__c!=null &&(loggedUser.Sub_Bu__c =='USL' ||loggedUser.Sub_Bu__c =='Findlaw' ||loggedUser.Sub_Bu__c=='LMS')){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sold To Account required for Proposal creation'));
        return null;
        }
        else if(businnesPartner.size() > 0 && status ==false && (loggedUser.Sub_Bu__c =='USL' ||loggedUser.Sub_Bu__c =='Findlaw' ||loggedUser.Sub_Bu__c=='LMS')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sold To Account required for Proposal creation'));
            return null;
        }
        //Added as part of DOC-280
        else */
        if((ssd.Source_System_Account_Number__c!=null && businnesPartner.size() == 0) || (businnesPartner.size() > 0 && status ==false)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sold To Account required for Proposal creation'));
        return null;
        }
        Opportunity newOpportunity= new Opportunity();
        //newOpportunity.Name = accountName +' - Optty - '+System.now();   //SOC-9796 PMD Fix
        newOpportunity.Name = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(accname))) +' - Optty - '+System.now();
       // newOpportunity.AccountId = accountId;
        newOpportunity.AccountId = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(accId)));
        newOpportunity.StageName = 'Needs analysis';
    //DOC-280
        String priceBookName1 = label.LOTUSTRPriceBook;
        if(ssd.LCRM_Sales_Org__c != null){
            if(ssd.LCRM_Sales_Org__c == 'TA78'|| ssd.LCRM_Sales_Org__c == 'TA61' || ssd.LCRM_Sales_Org__c == 'CARS' || System.Label.Risk_Sales_Orgs.contains(ssd.LCRM_Sales_Org__c)){
                if(Schema.sObjectType.pricebook2.isAccessible()){
                    priceBook1 = [Select id, name From pricebook2 WHERE Name=:priceBookName1 LIMIT 1]; 
                    newOpportunity.Pricebook2Id = priceBook1.Id;
                }       
            }
        }//DOC-280
        //DOC - 3650 changes start here   
        /*String priceBookNameCARs = System.Label.OC_PriceBookCanada;
        system.debug('Price book'+priceBookNameCARs);
      if(ssd.LCRM_Sales_Org__c == 'CARS'){        
        if(Schema.sObjectType.pricebook2.isAccessible()){
            priceBookCARS = [Select id, name From pricebook2 WHERE Name=:priceBookNameCARs LIMIT 1];
            system.debug('Price book details'+priceBookCARS);
            newOpportunity.Pricebook2Id = priceBookCARS.Id;
        }
      }*/
      //DOC- 3650 changes end here

        else{newOpportunity.Pricebook2Id = priceBook.Id;}
        //newOpportunity.Pricebook2Id = priceBook.Id;
        newOpportunity.CloseDate = Date.today();
        //newOpportunity.Source_System_Detail__c =sourceSystemDetailId;   //SOC-9796 PMD Fix
        newOpportunity.Source_System_Detail__c =(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(ssdid)));
        //newOpportunity.Key_Contact__c=contactId;
        newOpportunity.Key_Contact__c=(String) (string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(conId)));
        newOpportunity.recordtypeid=opportunityRecTypeId ;
        try{
         if(Schema.sObjectType.Opportunity.isCreateable()){
        insert newOpportunity;
        }
        }
        catch(Exception e){
            System.debug('Exception has occured:::'+ e);
        }
        Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c();
       // newProposal.Apttus_Proposal__Account__c = accountId;   //SOC-9796 PMD Fix
         newProposal.Apttus_Proposal__Account__c =(String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(accId)));
        // newProposal.APTS_SSD_Sold_To__c= sourceSystemDetailId;   //SOC-9796 PMD Fix
        newProposal.APTS_SSD_Sold_To__c = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(ssdid)));
        newProposal.Apttus_Proposal__Approval_Stage__c = 'Draft'; //make dynamic?
        newProposal.Apttus_Proposal__Opportunity__c= newOpportunity.Id;
        //newProposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
        //newProposal.Apttus_Proposal__Proposal_Name__c = accountName +' - Quote - '+System.now();   //SOC-9796 PMD Fix
        newProposal.Apttus_Proposal__Proposal_Name__c = (String)(string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get(accname))) +' - Quote - '+System.now();
        newProposal.recordtypeId=proposalRecTypeId;
          //SOC-9796 PMD Fix
        //DOC-6773 (Legal Name Changes)
        //Commented as part of CrossSell
        /*if(ssd.LCRM_Sales_Org__c == 'TA78' && ssd.BU_Segment__c == 'Corporate'){
            newProposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC US';
        } else if (ssd.LCRM_Sales_Org__c == 'TA61' && ssd.BU_Segment__c == 'Corporate') {
            newProposal.APTS_Proposal_Business_Unit__c = 'Corp OneOTC UK';
        }else if (ssd.LCRM_Sales_Org__c == 'S100' && ssd.BU_Segment__c == 'Professional Tax') {
            newProposal.APTS_Proposal_Business_Unit__c = 'Tax Professional';
        }*/
        //End-DOC-6773
        //Added as part of CrossSell
        Map<String,String> pbus = new Map<String,String>();
        if (Schema.sObjectType.APTS_Proposal_Business_Unit_Default__mdt.isAccessible()){
                List<APTS_Proposal_Business_Unit_Default__mdt> propbus = [Select APTS_Proposal_Business_Unit__c,APTS_Sales_Org__c,MasterLabel from APTS_Proposal_Business_Unit_Default__mdt];
                for(APTS_Proposal_Business_Unit_Default__mdt var : propbus){
                    if(var.APTS_Sales_Org__c != null && var.APTS_Proposal_Business_Unit__c != null){
                        pbus.put(var.APTS_Sales_Org__c,var.APTS_Proposal_Business_Unit__c);
                    }
                }
            }
        if(!pbus.isEmpty() && pbus !=null && ssd.LCRM_Sales_Org__c != null){
            if(pbus.containskey(ssd.LCRM_Sales_Org__c)){
                newProposal.APTS_Proposal_Business_Unit__c = pbus.get(ssd.LCRM_Sales_Org__c);
            }
        }
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isCreateable()){
        insert newProposal ;
        }
        PageReference page = new PageReference('/' + newProposal .Id); 
        page.setRedirect(true); //redirecting to the new proposal detail page
        return page;
  
  
  } 
}