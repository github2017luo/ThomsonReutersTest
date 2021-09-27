/*
===============================================================================
generateProposalCCTokenController
===============================================================================

PURPOSE: Generate credit card token   

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2016-09-14     Sreenu                  Created                                          
===============================================================================
*/

public class generateProposalCCTokenController{

    public Boolean showInputFields {get;set;}
    public Apttus_Proposal__Proposal__c oQuote {get;set;}
    public string sToken;
    public string sTimeStamp;
    public string creditCardNumber{get;set;}
    public string userProfile{get;set;}
    public string productId{get;set;}
    public string statusCode;
    public string errorMessage;
    public generateProposalCCTokenController(ApexPages.StandardController oController) {
        showInputFields =false;
        oQuote = (Apttus_Proposal__Proposal__c) oController.getRecord();
        oQuote = [select id,APTS_Payment_Option__c,APTS_Credit_Card_Token__c,APTS_Token_Generated_Date__c ,APTS_Card_Expiration_Date__c,APTS_Card_Type__c from Apttus_Proposal__Proposal__c where Id = :oQuote.Id];
        productId=KeyValueListStore__c.getInstance('ProductId').TextValue__c;
        userProfile = [select Name from Profile where Id = :UserInfo.getProfileId()].Name;
    }
    
    public void refreshPage(){
        showInputFields = true;
        oQuote.APTS_Card_Type__c ='';
        oQuote.APTS_Card_Expiration_Date__c =null;
        
    }
 
    public pageReference generateToken(){
        try{
            string JSONString = getWSResponse(); 
            if(JSONString != '')
                parseCreditCardWSresponse(JSONString);
            if(statusCode == '1000' ){
                if(sToken != '' && sTimeStamp!= ''){
                    oQuote.APTS_Credit_Card_Token__c = sToken;
                    oQuote.APTS_Token_Generated_Date__c = DateTime.valueOf(sTimeStamp);
                    update oQuote;
                    showInputFields =false; 
                }
            }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
                    myMsg.getComponentLabel();
                    Apexpages.addMessage(myMsg); 
                    showInputFields =true; 
                 }
        }
        catch(Exception ex){
            system.debug('$$$$Exception in generate token: '+ex.getMessage());
            IntegrationLogger.addMessage(ex.getMessage(), oQuote.id, 'Quote', '', 'Outbound','Generate Credit Card Token',false); 
            ApexPages.addMessages(ex);
            showInputFields =true;
               
        }
        creditCardNumber = '';
        return null;
    }
    public pageReference clear(){
        showInputFields = false;
        creditCardNumber = '';
        Pagereference pg= new PageReference('/apex/generateProposalCreditCardToken?id='+oQuote.id);
        pg.setredirect(true);
        return pg; 
    }
    public void parseCreditCardWSresponse(string JSONstring){
        JSONParser parser = JSON.createParser(JSONString);
        while (parser.nextToken() != null) {
             if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                if(parser.getText() == 'Token'){             
                    parser.nextToken();
                    sToken = parser.getText();      
                }
                else if(parser.getText() == 'Timestamp'){
                    parser.nextToken();
                    sTimestamp = parser.getText();
                }else if(parser.getText() == 'Message'){
                    parser.nextToken();
                    errorMessage=parser.getText(); 
                }else if (parser.getText() == 'StatusCode'){
                    parser.nextToken();
                    statusCode=parser.getText(); 
                }
            }
        }
    }
    public string getWSResponse(){
        HttpRequest request = new HttpRequest();
        string endpoint = KeyValueListStore__c.getInstance('PaymetricEndpoint').TextValue__c;        
        endpoint += '&cardNumber=' + creditCardNumber;
        endpoint += '&productid=' + productId;
        
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/xml');            

        System.debug(request.getEndpoint());
        request.setTimeout(60000);
                
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug(response.getBody());
        if(response.getBody().indexOf('{') != -1)
            return response.getBody().substring(response.getBody().indexOf('{'),response.getBody().lastIndexOf('}')+1);
        else 
            return '';
    }
}