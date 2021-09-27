/**
 * Util class to make REST Callouts, Notify owner about Error & log the Error details in Integration_Logger__c custom Obj
 *
 * @author  TCS/Sreenu Daram
 * @version 2017-05-26
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-05-26   Sreenu                     Created                                                                
 * =============================================================================
 */
 
public class OrderSubmissionCalloutUtil {
    
     public static HTTPResponse sendRequest(CreateOrderRequest oReq, string errMsg, string objName, string wsName, string reqMethod, string contentType, Id orderId,Decimal retryCount) {
        Httprequest req = new httprequest();
        HTTPResponse res = new HTTPResponse();
        try {
             WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings(wsName);             
             req.setEndpoint(oWebServiceSettings.Endpoint__c);
             req.setHeader('Content-Type', contentType);            
             req.setBody(JSON.serialize(oReq));
             req.setmethod(reqMethod);
             blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
             String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
             req.setHeader('Authorization', authorizationHeader);
             system.debug('request body...'+JSON.serialize(oReq));
             system.debug('request...'+req);
             Http http = new Http();             
             if(!Test.isRunningTest()) 
                 res = http.send(req);
             System.debug('response...'+res);             
        }
        catch(Exception ex){    
            System.debug('Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            logException(req.getBody(), errMsg, objName, False, orderId,retryCount);          
        }
        return res;
    }
    
    public static void sendEmailtoQuoteOwner(HTTpResponse res, string recName, string ownerEmail, string subBody, string sub, string errMsg, string objName, Id orderId,Decimal retryCount){
        if(res.getStatusCode()!=200) {
            // call method to log the request
            logException(res.getbody(), errMsg, objName, False, orderId,retryCount);
            List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(new List<String>{ownerEmail});
            emailToSend.setPlainTextBody(subBody+recName);
            emailToSend.setSubject(sub);
            lstMsgsToSend.add(emailToSend);                
            Messaging.sendEmail(lstMsgsToSend);
        }
        else
            logException(res.getbody(), errMsg, objName, True, orderId,retryCount);
        System.debug('res.getbody()...'+res.getbody());            
     }
     
     public static void logException(string reqBody, string error, string objName, boolean isSuccess, Id recId,Decimal retryCount) {
        if(retryCount>=1){
      system.debug('Order Queue ESI LogException Retry COunt ::'+retryCount);
      List<Integration_Logger__c> intLogList=[Select Id from Integration_Logger__c where Order__c=:recId];
      system.debug('intLogList :: '+intLogList);
      if(intLogList!=null && intLogList.size()==1){
        IntegrationLogger.updateMessage(intLogList[0].Id, false,error);
      }
    }else{
      system.debug('else part of LogException Retry COunt :: '+retryCount);
      IntegrationLogger.OCAddMessage(error,'', 'Quote/Proposal', reqBody, 'Outbound','OrderSubmission',false,recId);
         
    } 
    }
    
    //method to assign the Address field values to the Order address
    /*public static CreateOrderRequest.orderAddress assignAddessValues(string partnerType, string shipping, string sapNumber, string name, string nameTwo, string nameThree, string st1, string st2, string st3, string st4, string city, string state, string country, string postalCode, string phone, string fax, string poBox) {
        CreateOrderRequest.orderAddress ordaddress = new CreateOrderRequest.orderAddress();
        ordaddress.partnerType = partnerType;
        if(!string.isEmpty(shipping))
            ordaddress.shippingMethod = Shipping_Method__c.getInstance(shipping).Value__c;
        ordaddress.account.accountNumber = sapNumber;
        ordaddress.name1 = name;
        ordaddress.name2 = nameTwo;
        ordaddress.name3 = nameThree;
        ordaddress.street1 = st1;
        ordaddress.street2 = st2;
        ordaddress.street3 = st3;
        ordaddress.street4 = st4;
        ordaddress.city = city;         
        ordaddress.region = state;
        ordaddress.country = country;
        ordaddress.postal = postalCode;
        ordaddress.phone = phone;
        ordaddress.fax = fax;
        ordaddress.poBox = poBox;
        return ordaddress;
    }
    */
     /*=================================================================================
    Method to set MYR/ Contact Terms details for Order Line Items
    ===================================================================================*/
   /* public static List<CreateOrderRequest.terms> orderTerms(string contractTerm, Decimal baseValue, string adjustment,String Renewal, string status) {        
        List<CreateOrderRequest.terms> listTerms = new List<CreateOrderRequest.terms>();
        //Contract Term =1
        if(string.valueof(contractTerm)=='1 Year'){
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed')            
                listTerms = orderTermsUtil('1',baseValue,adjustment,Renewal,true,1);            
            else
                listTerms = orderTermsUtil('1',baseValue,adjustment,'0',false,1);            
        }         
        //Contract Term =2  
        if(string.valueof(contractTerm)=='2 Years'){
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed')            
                listTerms = orderTermsUtil('2',baseValue,adjustment,Renewal,true,2);            
            else
               listTerms = orderTermsUtil('2',baseValue,adjustment,'0',false,2);            
        }
        //Contract Term =3
        if(string.valueof(contractTerm)=='3 Years'){
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed')           
                listTerms = orderTermsUtil('3',baseValue,adjustment,Renewal,true,3);            
            else
                listTerms = orderTermsUtil('3',baseValue,adjustment,'0',false,3);            
        }
        return listTerms;
    }  
    */
         /*=================================================================================
    Method to set MYR Terms details
    ===================================================================================*/
   /* public static List<CreateOrderRequest.terms> orderTermsUtil(string contractTerm, Decimal baseValue, string adjustment,String Renewal,Boolean isRenewel, Integer period) {
        List<CreateOrderRequest.terms> termsList = new List<CreateOrderRequest.terms>();
        integer count = null;
        for(Integer i=1; i <= period; i++) {
            if(i == 1 && isRenewel) 
                 termsList.add(termUtil(contractTerm,string.ValueOf(i),Renewal,baseValue,0));            
            // If it is not renewel and First term then send Adjustment as 0
            else if(i == 1 && !isRenewel) 
                 termsList.add(termUtil(contractTerm,string.ValueOf(i),'0',baseValue,0));            
            else 
                 termsList.add(termUtil(contractTerm,string.ValueOf(i),adjustment,baseValue,0));            
        }
        return termsList;
    }  */
    
     /*=================================================================================
    Method For MYR/ Contact Terms details values mapping
    ===================================================================================*/    
   /* public static CreateOrderRequest.terms termUtil(string tLen, string period, string percInc, Decimal bValue, Decimal uRate) {
        CreateOrderRequest.terms term = new CreateOrderRequest.terms();
        term.termLength= tLen;
        term.period= period;
        term.percentIncrease= percInc;
        term.baseValue= bValue;
        term.userRate= uRate;
        return term;
    }*/
   
}