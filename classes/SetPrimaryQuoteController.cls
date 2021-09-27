/*
======================================================================================================================
CLASS NAME:    SetPrimaryQuoteController 
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME             DESC
2017-03-27        Karthi           Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
global with sharing class SetPrimaryQuoteController {
    public Opportunity oOpportunity{get;set;}
    public list<wrapQuotes> listWrapQuotes {get;set;}
    public class MyException extends Exception{}
    
    public SetPrimaryQuoteController(ApexPages.StandardController controller){
        oOpportunity = (Opportunity)controller.getRecord();
        oOpportunity = [select SyncedQuoteId  from Opportunity where Id = :oOpportunity.Id];
        listWrapQuotes = new list<wrapQuotes>();
        for (Quote oQuote : [select Id, QuoteNumber, Name, SAP_IDOC_Number__c, Primary_Quote__c,IsSyncing from Quote where OpportunityID = :oOpportunity.Id order by QuoteNumber]){
            wrapQuotes oWrapQuote = new wrapQuotes(oQuote);
            listWrapQuotes.add(oWrapQuote);
        }
    }
    public class wrapQuotes{
        public Quote oQuote{get;set;}
        public Boolean bSelected{get;set;}
        public wrapQuotes(Quote q){
            bSelected = q.Primary_Quote__c;
            oQuote = q;
        }
    }
    public pageReference setAsPrimary(){
        try{
            list<Quote> listQuotesToUpdate = new list<Quote>();
            boolean bUpdate = false;
            Opportunity quoteOpp;
            for(wrapQuotes owrapQuote : listWrapQuotes){
                if(owrapQuote.oQuote.Primary_Quote__c != owrapQuote.bSelected){
                    owrapQuote.oQuote.Primary_Quote__c = owrapQuote.bSelected;
                    if(owrapQuote.bSelected){
                        bUpdate = true;
                        quoteOpp = new Opportunity(Id=oOpportunity.Id);
                        quoteOpp.SyncedQuoteId = owrapQuote.oQuote.Id;
                    }
                    listQuotesToUpdate.add(owrapQuote.oQuote);
                }
            }
            if(bUpdate){
                if(!listQuotesToUpdate.isEmpty()){
                    update listQuotesToUpdate;
                }
                update quoteOpp;
                pageReference pg = new pageReference('/'+oOpportunity.Id);
                return pg;
            }
            else{
                // ApexPages.addMessages(new MyException('Please select atleast one Quote(not already a Primary) to set as Primary.')); //Replaced with custom label as part of S2E Optimization
                ApexPages.addMessages(new MyException(Label.SetPrimaryQuoteEx));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }
    webservice static boolean setAsPrimary(Id QuoteId, Id OpportunityId){
        try{
            list<Quote> listQuotesToUpdate = new list<Quote>();
            Opportunity quoteOpp;
            for(Quote oQuote : [select id, Primary_Quote__c, IsSyncing from quote where OpportunityId =:OpportunityId]){
                if(oQuote.Id == QuoteId){
                    if(!oQuote.Primary_Quote__c){
                        oQuote.Primary_Quote__c = true;
                        quoteOpp = new Opportunity(Id=OpportunityId);
                        quoteOpp.SyncedQuoteId = oQuote.Id;
                        listQuotesToUpdate.add(oQuote);
                    }
                }
                else{
                    if(oQuote.Primary_Quote__c){
                        oQuote.Primary_Quote__c = false;
                        listQuotesToUpdate.add(oQuote);
                    }
                }
            }
            if(!listQuotesToUpdate.isEmpty()){
                update listQuotesToUpdate;
                update quoteOpp;
            }
            return true;
        }
        catch(Exception ex){
            return false;
        }
    }
}