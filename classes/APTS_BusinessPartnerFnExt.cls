/* APTS_BusinessPartnerFnExt
 * Controller class for APTS_BusinessPartnerFunctionPage page.
 *
 * Developer: Akshay Mewada, APTTUS
 * Business Owner:
 *
 * Scenario:
 *
 *
 *
   ***************************************************************************************************
   Modification Log:
   *
   *    Akshay Mewada, 10/11/2016 - Created.
   ***************************************************************************************************
*/
public with sharing class APTS_BusinessPartnerFnExt {
    Apttus_Proposal__Proposal__c proposalObj;
    ID recordID;
    public List<Business_Partner_Function__c> businessPartnerList {get; set;}
    Map<ID, Business_Partner_Function__c> businessPartnerMap;
    public String selectedBillTo {get; set;}
    public String selectedShipTo {get; set;}
    public String selectedPayer {get;set;} //SOC-6753
    public List<Business_Partner_Function__c> billToOptionList {get; set;}
    public List<Business_Partner_Function__c> shipToOptionList {get; set;}
    public List<Business_Partner_Function__c> payerOptionList {get;set;} //SOC-6753
    public boolean isBillToPartyAvail {get; set;}
    public boolean isShipToPartyAvail {get; set;}
    public boolean isPayerAvail {get;set;} //SOC-6753
    public String sortField = 'Account_SAP_Number__c';//soc-4010 bijeta Nov 17
    public String myOrder ='ASC';//soc-4010 bijeta Nov 17

  //Constructor
    public APTS_BusinessPartnerFnExt(ApexPages.StandardController stdController) {
        this.recordID = ApexPages.currentPage().getParameters().get('id');
        system.debug('APTS_BusinessPartnerFnExt - this.recordID: ' + this.recordID);
        proposalObj = new Apttus_Proposal__Proposal__c();
        businessPartnerList = new List<Business_Partner_Function__c>();
        billToOptionList = new List<Business_Partner_Function__c>();
        shipToOptionList = new List<Business_Partner_Function__c>();
        payerOptionList = new List<Business_Partner_Function__c>();  //SOC-6753
        isBillToPartyAvail = false;
        isShipToPartyAvail = false;
        isPayerAvail = false;

        fetchBusinessFunctionRecords();
    }

    public void fetchBusinessFunctionRecords()
    {
         //SOC-6753 - added APTS_Payer__c field
        proposalObj = [SELECT ID, APTS_SSD_Sold_To__c,APTS_Payer__c,
                                APTS_SSD_ship_to__c, APTS_SSD_bill_to__c
                                FROM Apttus_Proposal__Proposal__c
                                WHERE ID = :this.recordID];

        businessPartnerMap = new Map<ID, Business_Partner_Function__c>([SELECT ID, name, Related_Account_GLI__c, Sold_To_Account_GLI__c,
                                                                                Related_Account_GLI__r.Account_Name__c, Related_Account_GLI__r.Address_2__c,
                                                                                Relationship_Type__c, Account_SAP_Number__c
                                                                                FROM Business_Partner_Function__c
                                                                                WHERE Sold_To_Account_GLI__c = :proposalObj.APTS_SSD_Sold_To__c
                                        AND Account_SAP_Number__c != NULL]);
        businessPartnerList = businessPartnerMap.values();
        system.debug('APTS_BusinessPartnerFnExt - businessPartnerList: ' + businessPartnerList);
        //Prepare the select option lists
        for(Business_Partner_Function__c businessPartnerObj : businessPartnerList)
        {
            if(businessPartnerObj.Relationship_Type__c == 'Bill-to party')
            {
                billToOptionList.add(businessPartnerObj);
                isBillToPartyAvail = true;
            }
            if(businessPartnerObj.Relationship_Type__c == 'Ship-to party')
            {
                shipToOptionList.add(businessPartnerObj);
                isShipToPartyAvail = true;
            }// August SOC-6753
            if(businessPartnerObj.Relationship_Type__c == 'Payer')
            {
                payerOptionList.add(businessPartnerObj);
                isPayerAvail = true;
            }
        }
    }
//soc-4010 bijeta Nov 17 start
    public List<Business_Partner_Function__c> getBPFBill(){
       
   String q = 'SELECT ID, Account_SAP_Number__c,State__c,City__c, Related_Account_GLI__r.Account_Name__c, Related_Account_GLI__r.Number_Street__c,Related_Account_GLI__r.LCRM_PO_Box__c FROM Business_Partner_Function__c WHERE id in :billToOptionList';
        q+=' Order by ' +  String.escapeSingleQuotes(sortField) + ' ' + myOrder;
       
        billToOptionList = Database.query(q);
        system.debug('Query'+q);
       return billToOptionList;
   
   }
    
   public List<Business_Partner_Function__c> getBPFShip(){
       
   String q = 'SELECT ID, Account_SAP_Number__c,State__c,City__c, Related_Account_GLI__r.Account_Name__c, Related_Account_GLI__r.Number_Street__c, Related_Account_GLI__r.LCRM_PO_Box__c FROM Business_Partner_Function__c WHERE id in :shipToOptionList';
        q+=' Order by ' +  String.escapeSingleQuotes(sortField) + ' ' + myOrder;
       
        shipToOptionList = Database.query(q);
        system.debug('Query'+q);
       return shipToOptionList;
   
   }
   
   //SOC-6753 AUGUST
   public List<Business_Partner_Function__c> getBPFPayer(){       
   String q = 'SELECT ID, Account_SAP_Number__c,State__c,City__c, Related_Account_GLI__r.Account_Name__c, Related_Account_GLI__r.Number_Street__c, Related_Account_GLI__r.LCRM_PO_Box__c FROM Business_Partner_Function__c WHERE id in :payerOptionList';
        q+=' Order by ' +  String.escapeSingleQuotes(sortField) + ' ' + myOrder;
       
        payerOptionList = Database.query(q);
        system.debug('Query'+q);
       return payerOptionList;
   
   } 
   
   public void sortByName() {
    this.sortField = 'Related_Account_GLI__r.Account_Name__c';
     if(myOrder == ' ASC ')
        {
            myOrder = ' DESC ';
        }
        else
        {
            myOrder = ' ASC ';
        }
        this.myOrder= myOrder;      
         system.debug('order'+myOrder);     
    }
    public void sortByAccNumber() {
    this.sortField = 'Account_SAP_Number__c';
     if(myOrder == ' ASC ')
        {
            myOrder = ' DESC ';
        }
        else
        {
            myOrder = ' ASC ';
        }
        this.myOrder= myOrder;      
         system.debug('order'+myOrder);     
    }
    public void sortByCity() {
    this.sortField = 'City__c';
     if(myOrder == ' ASC ')
        {
            myOrder = ' DESC ';
        }
        else
        {
            myOrder = ' ASC ';
        }
        this.myOrder= myOrder;      
         system.debug('order'+myOrder);     
    }
//soc-4010 bijeta Nov 17 end
    public PageReference save()
    {
        system.debug('APTS_BusinessPartnerFnExt - selectedBillTo: ' + selectedBillTo);
        if(this.selectedBillTo != null)
        {
          proposalObj.APTS_SSD_bill_to__c= businessPartnerMap.get(selectedBillTo).Related_Account_GLI__c;
        }
        if(this.selectedShipTo != null)
        {
          proposalObj.APTS_SSD_ship_to__c= businessPartnerMap.get(selectedShipTo).Related_Account_GLI__c;
        }
        //SOC-6753 aUGUST
        if(this.selectedPayer != null)
        {
            proposalObj.APTS_Payer__c = businessPartnerMap.get(selectedPayer).Related_Account_GLI__c;
        }
        System.debug('APTS_BusinessPartnerFnExt - proposalObj.APTS_SSD_ship_to__c- ' + proposalObj.APTS_SSD_ship_to__c);
        System.debug('APTS_BusinessPartnerFnExt - proposalObj.APTS_SSD_bill_to__c- ' + proposalObj.APTS_SSD_bill_to__c);

        update proposalObj;
        System.debug('APTS_BusinessPartnerFnExt - proposalObj.APTS_SSD_ship_to__c- ' + proposalObj.APTS_SSD_ship_to__c);
        System.debug('APTS_BusinessPartnerFnExt - proposalObj.APTS_SSD_bill_to__c- ' + proposalObj.APTS_SSD_bill_to__c);

        PageReference ref = new PageReference('/' + this.recordID);
        ref.setRedirect(true);
        return ref;
    }

    public PageReference cancel()
    {
        PageReference ref = new PageReference('/' + this.recordID);
        ref.setRedirect(true);
        return ref;
    }

    public void onSelectionBillTo()
    {
        system.debug('APTS_BusinessPartnerFnExt - onSelectionBillTo -' + ApexPages.currentPage().getParameters());
        this.selectedBillTo = ApexPages.currentPage().getParameters().get('selectedBillTo');
        system.debug('APTS_BusinessPartnerFnExt - onSelection - selectedBillTo: ' + selectedBillTo);
    }

    public void onSelectionShipTo()
    {
        system.debug('APTS_BusinessPartnerFnExt - onSelectionShipTo -' + ApexPages.currentPage().getParameters());
        this.selectedShipTo = ApexPages.currentPage().getParameters().get('selectedShipTo');
        system.debug('APTS_BusinessPartnerFnExt - onSelection - selectedShipTo: ' + selectedShipTo);
    }
    
    //SOC-6753 AUGUST
    public void onSelectionPayer()
    {
        this.selectedPayer = ApexPages.currentPage().getParameters().get('selectedPayer');        
    }
    
    public PageReference onClickResetBillTo()
    {
      if(proposalObj.APTS_SSD_bill_to__c!= proposalObj.APTS_SSD_Sold_To__c)
      {
        proposalObj.APTS_SSD_bill_to__c= proposalObj.APTS_SSD_Sold_To__c;
        update proposalObj;
      }

      PageReference ref = new PageReference('/' + this.recordID);
      ref.setRedirect(true);
      return ref;
    }

    public PageReference onClickResetShipTo()
    {
      if(proposalObj.APTS_SSD_ship_to__c!= proposalObj.APTS_SSD_Sold_To__c)
      {
        proposalObj.APTS_SSD_ship_to__c= proposalObj.APTS_SSD_Sold_To__c;
        update proposalObj;
      }

      PageReference ref = new PageReference('/' + this.recordID);
      ref.setRedirect(true);
      return ref;
    }
    
    //S0C-6753 aUGUST
    public PageReference onClickResetPayer()
    {
      if(proposalObj.APTS_Payer__c != proposalObj.APTS_SSD_Sold_To__c)
      {
        proposalObj.APTS_Payer__c= proposalObj.APTS_SSD_Sold_To__c;
        update proposalObj;
      }

      PageReference ref = new PageReference('/' + this.recordID);
      ref.setRedirect(true);
      return ref;
    }
}