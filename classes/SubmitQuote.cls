/********************************************************************
* Developed for SFD - 391 bug. 
* This code submits Quote for an approval. Only used by Portal Users. 
* Developed by Daniel Tefera March-2016.
*********************************************************************/

global class SubmitQuote{
    webService static String submitQuoteForApproval(Id q)
    {
        final String APPROVAL_PROCES_NOT_FOUND = 'NO_APPLICABLE_PROCESS';
        try
        {        
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            
            req1.setObjectId(q);
            
            req1.setSubmitterId(UserInfo.getUserId());
            
            Approval.ProcessResult result = Approval.process(req1);

            return 'success';
            
        }
        catch(Exception e)
        {
            if(e.getmessage().contains(APPROVAL_PROCES_NOT_FOUND)) 
                return System.label.Portal_Quote_Price_Approval_Cannot_be_found;
            else    
                return 'The following error message occoured please contact your System Adminstrator '+e.getmessage();
        }
        
     }
        
        
}