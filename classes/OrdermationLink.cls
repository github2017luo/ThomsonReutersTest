global class OrdermationLink{ 

    webService static String getQuoteId(Id oOpportunity){
    
        List<Quote> listQuote = new List<Quote>([select q.id, q.Name, q.QuoteNumber from Quote q where q.OpportunityId=:oOpportunity limit 1]); 
            if(listQuote.size() > 0){
                //return listQuote[0].Id;
                return listQuote[0].QuoteNumber;
            }else{
                return null;
                }   
    }        
}