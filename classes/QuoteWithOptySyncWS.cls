/**
* CHANGE HISTORY
* =========================================================================================================
* Date         Name                    Description
* 2018-07-20   TCS         			   Created. Initial code to Sync Quote with Opportunity.
*/
global class QuoteWithOptySyncWS {
    webservice static String syncQuoteWithOpty(String s){
        system.debug('++++ INput from Infa '+ s);
        Integer quotesProcessed=0;
        String quoteIdsStr='';
        List<Id> quoteIDs = new List<Id>();
        String output=null;
        try{
            if(s!=null)
            	quoteIDs =(List<Id>)s.split(';');
            for(Id quoteId: quoteIDs){
                system.debug('+++ inside FOR ');
                boolean serviceResponse = Apttus_QPConfig.QPConfigWebService.syncWithOpportunity(quoteId, true);
                
                if(serviceResponse){
                    system.debug('+++ inside service response '+ quoteId);
                    quotesProcessed++;
                    quoteIdsStr+= quoteIds + ';';
                    
                }
                
            }
            
        }catch(exception e){
            system.debug('+++  GET CAUSE  '+ e.getCause());
            system.debug('+++  GET getStackTraceString  '+ e.getStackTraceString());
            return e.getStackTraceString();
        } 
        return quotesProcessed +' out of '+ quoteIDs.size() + 'were successfully processed. The Quote Ids are - '+ quoteIdsStr ;
        
    }
    
    
}