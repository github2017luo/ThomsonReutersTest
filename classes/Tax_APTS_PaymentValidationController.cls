/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2019-12-07   Roma                    DOC- 8724 For Payment Option Validation for Existing and New Customer                                                                  
* =============================================================================
*/
public with sharing class Tax_APTS_PaymentValidationController {
    public Apttus_Proposal__Proposal__c oQuote {get;set;} 
    public String pay {get;set;}
    public Apttus_Proposal__Proposal__c prop {get;set;} 
    Set<Id> listOfProposal = new Set<Id>();
    set<Id> sAccIds = new set<Id>();
    List<Apttus_Proposal__Proposal_Line_Item__c> subsPLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>();
    List<Apttus_Proposal__Proposal_Line_Item__c> oneTypePLIs= new List<Apttus_Proposal__Proposal_Line_Item__c>();
    map<id,string> ssdAccountNumber = new map<id,string>();
    String sAccNo;
    String sourcePaymentOption;
    Decimal amount;
    Decimal amtST= 250.00;
    Decimal amtOT= 750.00;
    Map<Id,Source_System_Detail__c> ssdIds;
    String test;
    List<selectOption> options = new List<selectOption>();
    public Tax_APTS_PaymentValidationController(ApexPages.StandardController oController) {
        
        prop = (Apttus_Proposal__Proposal__c) oController.getRecord();
        
        System.debug('*** updateProductSubTypeFlags listOfProposal is ' +  prop);
        for(Apttus_Proposal__Proposal_Line_Item__c pLineItem : [select ID,Apttus_Proposal__Product__c,Apttus_QPConfig__PriceType__c,Apttus_QPConfig__ChargeType__c,
                                                                Apttus_QPConfig__LineType__c,Apttus_QPConfig__OptionId__c,Apttus_Proposal__Proposal__c, 
                                                                /*Apttus_Proposal__Proposal__r.Tax_Payment_Option__c,*/Apttus_Proposal__Proposal__r.APTS_Tax_Payment_Selection__c,Apttus_Proposal__Proposal__r.APTS_Quote_Value__c,Related_Quote_Proposal__c,
                                                                Apttus_QPConfig__AssetLineItemId__c,Apttus_QPConfig__LineStatus__c
                                                                from Apttus_Proposal__Proposal_Line_Item__c 
                                                                where Apttus_Proposal__Proposal__c =: prop.Id])
        {
            System.debug('*** updateProductSubTypeFlags listOfProposal is ' + pLineItem);
            //List of subscription products
            if((pLineItem.Apttus_QPConfig__LineStatus__c == 'New' || pLineItem.Apttus_QPConfig__LineStatus__c == 'Renewed') &&
               plineitem.Apttus_QPConfig__PriceType__c != 'One Time' && plineitem.Apttus_QPConfig__ChargeType__c =='Subscription Fee')
                subsPLIs.add(pLineItem);
            system.debug('Roma ########### subs '+ subsPLIs); 
            //List of One Time products
            if((pLineItem.Apttus_QPConfig__LineStatus__c == 'New' || pLineItem.Apttus_QPConfig__LineStatus__c == 'Renewed') &&
               plineitem.Apttus_QPConfig__PriceType__c == 'One Time' && plineitem.Apttus_QPConfig__ChargeType__c =='Standard Price')
                oneTypePLIs.add(pLineItem);
            system.debug('Roma ########### oneTime '+ oneTypePLIs);
        }
        
        prop = [Select Id, 
                Name,
                recordType.Name,
                APTS_SSD_Sold_To__c,
                APTS_Proposal_Business_Unit__c, 
                Tax_Payment_Option__c,
                Apttus_Proposal__Approval_Stage__c,
                APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                APTS_SSD_Sold_To__r.Number_Street__c,
                APTS_SSD_Sold_To__r.Name,
                APTS_SSD_Sold_To__r.State__c,
                APTS_SSD_Sold_To__r.Country__c,
                APTS_SSD_Sold_To__r.City__c,
                APTS_SSD_Sold_To__r.LCRM_Phone__c,
                APTS_SSD_Sold_To__r.Postal_Code__c,
                //Added by Kruti Shah for DOC-10571
                APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                APTS_Quote_Value__c,
                Apttus_Proposal__Account__r.SAPAccountNumber__c,
                Apttus_Proposal__Account__r.Name,
                APTS_Sold_To_SAP_Account_Number__c,
                Apttus_Proposal__Amount__c,
                APTS_Payer__c,
                //APTS_ZPEND_Check__c,
                APTS_Tax_Payment_Selection__c,
                APTS_Payment_Option__c
                
                from Apttus_Proposal__Proposal__c where Id =:prop.Id];
        system.debug('Roma ########### SSDs MAP '+ prop);
        sAccIds.add(prop.APTS_SSD_Sold_To__c);
        
        //if(prop.Tax_Payment_Option__c==null){
        //prop.APTS_Payment_Option__c= 'Payment Express Auto EFT/Auto Charge';
        //}
        //searchAccNames();
        
    }
    public List<SelectOption> getPayName() {    
        
        if(Schema.sObjectType.Source_System_Detail__c.isAccessible() && sAccIds.size()>0 && !sAccIds.isEmpty())   
            ssdIds = new Map<Id,Source_System_Detail__c>([SELECT Id,Name,Source_System_Account_Number__c,/*Tax_Payment_Option__c,*/Default_Payment_Method__c FROM Source_System_Detail__c WHERE Id IN : sAccIds Limit 10]);
        system.debug('Roma ########### SSDs MAP '+ ssdIds);
        if(prop.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            if(ssdIds != null)
                if(ssdIds.containsKey(prop.APTS_SSD_Sold_To__c) && ssdIds.get(prop.APTS_SSD_Sold_To__c) != null)
            {
                sAccNo = ssdIds.get(prop.APTS_SSD_Sold_To__c).Source_System_Account_Number__c ;
                if(ssdIds.get(prop.APTS_SSD_Sold_To__c) != null && String.valueOf(ssdIds.get(prop.APTS_SSD_Sold_To__c).Default_Payment_Method__c) != null)
                    sourcePaymentOption = ssdIds.get(prop.APTS_SSD_Sold_To__c).Default_Payment_Method__c ;
                system.debug('Roma ########### SSDs '+ sAccNo +' #####sourcePaymentOption '+ sourcePaymentOption  ); 
            }
            Schema.DescribeFieldResult fieldResult = Apttus_Proposal__Proposal__c.APTS_Payment_Option__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            //For new customer 
            
            if(sAccNo == null)
            {
                //Defaulting Payment option value to Payment Express for New Customer
                
                if(prop.APTS_Payment_Option__c==null){
                    options.clear();
                    options.add(new SelectOption('Payment Express Auto EFT/Auto Charge','Payment Express Auto EFT/Auto Charge'));
                    prop.APTS_Payment_Option__c= 'Payment Express Auto EFT/Auto Charge';
                    //prop.APTS_Payment_Option__c= prop.Tax_Payment_Option__c;
                    pay= prop.APTS_Payment_Option__c;
                    system.debug('LASt ########### oneType '+ prop.APTS_Payment_Option__c+ amtOT +' ###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                    
                }
            }     
            
            /*for(Schema.PicklistEntry f : ple){
            if(prop.Tax_Payment_Option__c!=null && (f.getLabel()==prop.Tax_Payment_Option__c)){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            System.debug('Roma Test **'+ options);
            } 
            }*/
            
            if((sAccNo == null || sAccNo != null) && prop.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == False)
            {  
                for(Schema.PicklistEntry f : ple){
                    if((subsPLIs.size() > 0 && !subsPLIs.isEmpty() && oneTypePLIs.size() > 0 && !oneTypePLIs.isEmpty()) || (subsPLIs.size() > 0 && !subsPLIs.isEmpty()))
                    {                        
                        amount= (prop.APTS_Quote_Value__c/12).setScale(2);
                        system.debug('amount : '+amount);
                        if(amount<=amtST){
                            options.clear();
                            options.add(new SelectOption('Payment Express Auto EFT/Auto Charge','Payment Express Auto EFT/Auto Charge'));                            
                        }
                        if(amount>amtST){
                            options.clear();
                            options.add(new SelectOption('Payment Express Auto EFT/Auto Charge','Payment Express Auto EFT/Auto Charge'));
                            options.add(new SelectOption('Bill to Account','Bill to Account'));
                            options.add(new SelectOption('Auto EFT/Auto Charge','Auto EFT/Auto Charge'));
                        }
                        pay= prop.APTS_Payment_Option__c;
                        break;
                    }
                    
                    if(oneTypePLIs.size() > 0 && !oneTypePLIs.isEmpty() && subsPLIs.size() == 0 && subsPLIs.isEmpty())
                    {
                        amount= prop.APTS_Quote_Value__c.setScale(2);
                        Decimal amount1 = prop.APTS_Quote_Value__c.setScale(2);
                        if(amount<amtOT){
                            options.clear();
                            options.add(new SelectOption('Payment Express Auto EFT/Auto Charge','Payment Express Auto EFT/Auto Charge'));
                            options.add(new SelectOption('One time EFT','One time EFT'));
                            options.add(new SelectOption('Credit Card','Credit Card'));
                            
                            system.debug('LASt ########### oneType '+ prop.APTS_Payment_Option__c+ amtOT +' ###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                        }
                        if(amount>=amtOT){
                            // prop.APTS_Tax_Payment_Selection__c = '4';
                            options.clear();
                            options.add(new SelectOption('Payment Express Auto EFT/Auto Charge','Payment Express Auto EFT/Auto Charge')); 
                            options.add(new SelectOption('One time EFT','One time EFT'));
                            options.add(new SelectOption('Credit Card','Credit Card'));
                            options.add(new SelectOption('Bill to Account','Bill to Account'));
                            options.add(new SelectOption('Auto EFT/Auto Charge','Auto EFT/Auto Charge'));
                            
                            system.debug('LASt ########### oneType '+ prop.APTS_Payment_Option__c+'###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                        } 
                        pay= prop.APTS_Payment_Option__c;  
                        break;
                    }
                    
                } 
            } 
            
            if(sAccNo != null && prop.APTS_SSD_Sold_To__r.APTS_Is_Customer__c== True)
            {
                //For Existing Customer                
                //Defaulting payment option value in quote from SSDs Payment Option field                 
                //Commenting until we are getting Source System Account Object: Payment Option Field
                if(sourcePaymentOption != null && sourcePaymentOption == prop.APTS_Payment_Option__c)
                {
                    prop.APTS_Payment_Option__c= sourcePaymentOption;
                    String payOpt= sourcePaymentOption;
                    options.clear();
                    options.add(new SelectOption(payOpt,payOpt));
                    pay= prop.APTS_Payment_Option__c;  
                    system.debug('LASt ########### oneType '+ prop.APTS_Payment_Option__c+ sourcePaymentOption+' ###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                } 
                /*
                if((sAccNo == null || sAccNo != null) && prop.APTS_SSD_Sold_To__r.APTS_Is_Customer__c== True)
                {        
                if(prop.Tax_Payment_Option__c == 'Bill to Account')
                {
                for( Schema.PicklistEntry f : ple)
                {
                if((subsPLIs.size() > 0 && !subsPLIs.isEmpty() && oneTypePLIs.size() > 0 && !oneTypePLIs.isEmpty()) || (subsPLIs.size() > 0 && !subsPLIs.isEmpty()))
                {
                options.clear();
                options.add(new SelectOption('Bill to Account','Bill to Account'));
                
                options.add(new SelectOption('Auto EFT/Auto Charge','Auto EFT/Auto Charge'));
                
                system.debug('LASt ########### subs '+ prop.Tax_Payment_Option__c+'###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                break;
                }   
                
                if(oneTypePLIs.size() > 0 && !oneTypePLIs.isEmpty() && subsPLIs.size() == 0 && subsPLIs.isEmpty())
                {
                options.clear();
                options.add(new SelectOption('One time EFT','One time EFTt'));
                
                options.add(new SelectOption('Credit Card','Credit Card'));
                // pay= prop.Tax_Payment_Option__c;            
                system.debug('LASt ########### subs '+ prop.Tax_Payment_Option__c+'###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                break;
                }   
                pay= prop.Tax_Payment_Option__c;      
                }                     
                }                   
                }*/
                //Commenting until we are getting Source System Account Object: Payment Option Field
                //Adding code for Existing Customer for now as Payment option is not yet developed 
                if(sourcePaymentOption == null){
                    options.clear();
                    // options.add(new SelectOption('Auto Charge','Auto Charge'));
                    options.add(new SelectOption('Payment Express Auto EFT/Auto Charge','Payment Express Auto EFT/Auto Charge')); 
                    options.add(new SelectOption('One time EFT','One time EFT'));
                    options.add(new SelectOption('Credit Card','Credit Card'));
                    options.add(new SelectOption('Bill to Account','Bill to Account'));
                    options.add(new SelectOption('Auto EFT/Auto Charge','Auto EFT/Auto Charge'));
                    
                    system.debug('LASt ########### oneType '+ prop.APTS_Payment_Option__c+'###Payment Select '+prop.APTS_Tax_Payment_Selection__c +'**Amount ' + amount); 
                    pay= prop.APTS_Payment_Option__c;  
                    //break;
                  }  
            } 
        }
        if(prop.APTS_Payment_Option__c!=null && prop.APTS_Payment_Option__c!=''){
            if(options.size()<=0){
                options.add(new SelectOption(prop.APTS_Payment_Option__c,prop.APTS_Payment_Option__c));
            }
            pay= prop.APTS_Payment_Option__c;
        }
        return options;
    }
    
    public PageReference save(){
        if(prop.Apttus_Proposal__Approval_Stage__c != 'Presented' && prop.Apttus_Proposal__Approval_Stage__c != 'Accepted'){
            test=pay;
            prop.APTS_Payment_Option__c=pay;
            prop.Tax_Payment_Option__c= pay;
            update prop;
            system.debug('Payment selected*** '+ test+'**** Propos ** '+prop); 
            
            PageReference p= new PageReference('/'+oQuote);
            p.setRedirect(true);
            return null;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Payment option is not allowed Change'));
            return null;
        } 
    }
}