/***********************************************************************************************
Purpose      : Dispaly totalprice and CurrencyIsoCode of not cancelled QuoteLineItems
Developed By : TCS Offshore-Renewal Notice
Date         : 09/15/2016
Changed Log  :
************************************************************************************************/

public  class TRFetchQuoteLineItems
{
    public Id quoteId {get;set;}
    public List<QuoteLineItem> qutLnItm{get;set;}
    public Decimal totalPrice = 0;
    String totalAmount ;
    public Opportunity oppDetails{get;set;}
    public String currencyIso{get;set;} 
    public String renewalDispatchCmnts{get;set;}
    public Boolean isUSD = true; //Mrinmoy Added to fix issue 1242
    
    ////// Fetch the list of quote LineItems of a particular quote
    public List<QuoteLineItem> getqutLineItems()
    {
        qutLnItm= [select Status__c,Product2.name,Quantity,UnitPrice,TotalPrice,Total_Price_Calc__c,Subscription_Start_Date__c,Subscription_End_Date__c from QuoteLineItem where QuoteId= :quoteId and Status__c != 'Cancelled'];  
        return qutLnItm;
    }
    
    /******Get Renewal Dispatch Comments******************************/
    
    public String getRenewalDispatchComments()
    {
        Quote q = [select Id,RenewalNoticeComments__c from Quote where Id= :quoteId]; 
        renewalDispatchCmnts = q.RenewalNoticeComments__c; 
        return renewalDispatchCmnts;
        
        //return 'asdf';
    }
    
    ///////Get the Currency Iso Code of the quote from the related opportunity
    public String getIsoCode(){
        oppDetails = [Select Id,CurrencyIsoCode from Opportunity Where SyncedQuote.Id = :quoteId];
        currencyIso = oppDetails.CurrencyIsoCode;
        return currencyIso; 
    }  
    
    
    ///// Get the total amount of quotelineItems
    public String getTotalAmount()
    {
        qutLnItm = getqutLineItems();
        for(QuoteLineItem qLI : qutLnItm)
        {
            if(qLI.Status__c != 'Cancelled')
            {
                //totalPrice = totalPrice + (qLI.Quantity*qLI.UnitPrice);
                totalPrice = totalPrice + qLI.Total_Price_Calc__c;
            }           
        }
        //Formating Total Price
        totalAmount = string.valueof(totalPrice.format());
        if(string.valueof(totalPrice.format()).right(3).contains('.'))
        {
            String fAmaount=totalAmount.substringBefore('.');
            String lAmaount=totalAmount.substringAfter('.'); 
            if(lAmaount.length()==1)
            {
                lAmaount=lAmaount+'0';            
            }           
            fAmaount=fAmaount.replaceAll(',','.');
            totalAmount=fAmaount+','+lAmaount;
        } 
        else if(string.valueof(totalPrice.format()).right(3).contains(',')){
            isUSD = false;
            String fAmaount=totalAmount.substringBefore(',');
            String lAmaount=totalAmount.substringAfter(',');
            if(lAmaount.length()==1){
                lAmaount=lAmaount+'0';            
            }
            totalAmount=fAmaount+','+lAmaount;
        }
        //Mrinmoy Restructured the code to fix issue 1242   
        else if(string.valueof(totalPrice.format()).contains('.')==false)
        {
        if(isUSD)      
            {    
            totalAmount=totalAmount.replaceAll(',','.');
            totalAmount=totalAmount+',00';
            }
        }

        else{
            totalAmount=totalAmount+',00';
        }
        //totalAmount= totalAmount+currencyIso;
        return totalAmount;

    }
    
    
}