/** 
* @author Kunal Mishra
* @date 22/06/2021
* @description Batch Class to allow HTTP callouts to Contract EXpress to create documents
*/

@SuppressWarnings('PMD.AvoidGlobalModifier,PMD.CognitiveComplexity,PMD.NcssMethodCount,PMD.ApexDoc,PMD.DebugsShouldUseLoggingLevel,PMD.StdCyclomaticComplexity,PMD.CyclomaticComplexity')
global class RenewalQuoteBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        String soqlQuery = 'SELECT ID,Sold_to_Account__c,SAP_Quote_Number__c,CurrencyIsoCode,Customer_Support_URL__c,Status__c,Sold_To_SSDL__c,Sold_to_SSDL__r.Name,Sold_to_SSDL__r.Source_System_Account_Number__c,Salesorg__c,Sold_to_Account_Name__c,Sold_to_Account_Number__c,Sold_to_SSD__c,Renewal_Start_Date__c,Renewal_End_Date__c,Renewal_Date__c,(SELECT ID,currencyISOCode,Agreement_Number__c,Deal_Number__c,Client_PO_Number__c,Product__c,Product_Name__c,Product_Code__c,List_Price__c,Monthly_List_Price__c,Notice_Due_Date__c,Renewal_Date__c,Quantity__c FROM Renewal_Line_Items__r) FROM Renewal_Quote__c WHERE Status__c =\'In Progress\'' ;
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<Renewal_Quote__c> scope){
        
        
        String customerSupport;
        string templateValue = 'RenewalNoticeTR';
        String termsAndConditions;
        String agrOrDealNumber;
        string rliCurrency;
        string rliPO ='';
        list<Renewal_Quote__c> listOfFailedRecords = new list<Renewal_Quote__c>();
        list<Renewal_Quote__c> listOfCompletedRecords = new list<Renewal_Quote__c>();
        list<ContentVersion> cvList = new list<ContentVersion>();
        
        map<ID,Renewal_Quote__c> mapOfRenewalIDtoQuote = new map<ID,Renewal_Quote__c>();
        map<ID,List<Renewal_Line_Item__c>> mapOfRenewalIDtoLineItem = new map<ID,List<Renewal_Line_Item__c>>();
        map<ID,ContentVersion> mapOFRenewalQuoteToContentVersion = new map<ID,ContentVersion>();
        map<String,String> mapOfSalesOrgToTemplateValues = new map<String,String>();
        
        for(Renewal_Template_Values__mdt tempValues : [SELECT ID,Label,SalesOrg__c,Template__c FROM Renewal_Template_Values__mdt]){
                mapOfSalesOrgToTemplateValues.put(tempValues.SalesOrg__c,tempValues.Template__c);
        }
        

        for(Renewal_Quote__c rQ : scope){
        mapOfRenewalIDtoQuote.put(rQ.ID,rQ);
        mapOfRenewalIDtoLineItem.put(rQ.ID,rQ.Renewal_Line_Items__r);
        system.debug(mapOfRenewalIDtoLineItem);}
        String xmlData;
    
    for(ID id : mapOfRenewalIDtoLineItem.keyset()){
        Integer i=1;
        customerSupport = mapOfRenewalIDtoQuote.get(id).Customer_Support_URL__c;
        xmlData = '<?xml version="1.0" encoding="UTF-8"?><Session xmlns="http://schemas.business-integrity.com/dealbuilder/2006/answers"><Variable Name="AccountName"><Value>'+mapOfRenewalIDtoQuote.get(id).Sold_to_SSDL__r.Name+'</Value></Variable><Variable Name="AccountNumber"><Value>'+mapOfRenewalIDtoQuote.get(id).Sold_to_SSDL__r.Source_System_Account_Number__c+'</Value></Variable><Variable Name="RenewalMonthStartDate"><Value>'+mapOfRenewalIDtoQuote.get(id).Renewal_Start_Date__c+'</Value></Variable><Variable Name="currency"><Value>'+mapOfRenewalIDtoQuote.get(id).CurrencyIsoCode+'</Value></Variable><Variable Name="RenewalMonthEndDate"><Value>'+mapOfRenewalIDtoQuote.get(id).Renewal_End_Date__c+'</Value></Variable><Variable Name="RenewalMonthEndDate"><Value>'+mapOfRenewalIDtoQuote.get(id).Renewal_End_Date__c+'</Value></Variable>';
        if(mapOfRenewalIDtoQuote.get(id).Salesorg__c!=null){
            if(mapOfSalesOrgToTemplateValues.containsKey(mapOfRenewalIDtoQuote.get(id).Salesorg__c)){
                templateValue = mapOfSalesOrgToTemplateValues.get(mapOfRenewalIDtoQuote.get(id).Salesorg__c);
                termsAndConditions = salesorgBasedTNC(mapOfRenewalIDtoQuote.get(id).Salesorg__c);
            }else{
                templateValue = 'RenewalNoticeTR';
            }
        }
        for(Renewal_Line_Item__c rLI : mapOfRenewalIDtoLineItem.get(id)){
            agrOrDealNumber = getAgrOrDealNumber(rLI.Agreement_Number__c,rLI.Deal_Number__c);
            rliCurrency = rLI.CurrencyIsoCode;
            rliPO = rLI.Client_PO_Number__c ==null?'':rLI.Client_PO_Number__c;
            //xmlData+='<Variable Name="ProductNoticeDueDate" RepeatContext="['+i+']"><Value>'+rLI.Notice_Due_Date__c+'</Value></Variable><Variable Name="PO" RepeatContext="['+i+']"><Value>'+rLI.Client_PO_Number__c+'</Value></Variable><Variable Name="ProductCode" RepeatContext="['+i+']"><Value>'+rLI.Product_Code__c+'</Value></Variable><Variable Name="ProductDescription" RepeatContext="['+i+']"><Value>'+rLI.Product_Name__c+'</Value></Variable><Variable Name="PRODUCTRENEWALDATE" RepeatContext="['+i+']"><Value>'+rLI.Renewal_Date__c+'</Value></Variable><Variable Name="ProductAnnualRenewalAmount" RepeatContext="['+i+']"><Value>'+rLI.Monthly_List_Price__c+'</Value></Variable><Variable Name="ProductMonthlyRenewalAmount" RepeatContext="['+i+']"><Value>'+rLI.List_Price__c+'</Value></Variable>';
            xmlData+='<Variable Name="ProductNoticeDueDate" RepeatContext="['+i+']"><Value>'+rLI.Notice_Due_Date__c+'</Value></Variable><Variable Name="PO" RepeatContext="['+i+']"><Value>'+rliPO+'</Value></Variable><Variable Name="ProductCode" RepeatContext="['+i+']"><Value>'+agrOrDealNumber+'</Value></Variable><Variable Name="ProductDescription" RepeatContext="['+i+']"><Value>'+rLI.Product_Name__c.replaceAll( '&([^;]+(?!(?:\\w|;)))', '&amp;$1' )+'</Value></Variable><Variable Name="PRODUCTRENEWALDATE" RepeatContext="['+i+']"><Value>'+rLI.Renewal_Date__c+'</Value></Variable><Variable Name="ProductAnnualRenewalAmount" RepeatContext="['+i+']"><Value>'+rLI.List_Price__c+'</Value></Variable><Variable Name="DealNumber" RepeatContext="['+i+']"><Value>'+rLI.Deal_Number__c+'</Value></Variable><Variable Name="AgreementNumber" RepeatContext="['+i+']"><Value>'+rLI.Agreement_Number__c+'</Value></Variable><Variable Name="ProductMonthlyRenewalAmount" RepeatContext="['+i+']"><Value>'+rLI.Monthly_List_Price__c+'</Value></Variable>';
            i++;
           }
        xmlData+='<Variable Name="NumberOfExpiringProducts"> <Value>'+(i-1)+'</Value> </Variable><Variable Name="CustomerServiceURL"> <Value>'+customersupport+'</Value> </Variable><Variable Name="TermsandConditionsHyperlink"> <Value>'+termsAndConditions+'</Value> </Variable><Variable Name="TaxHyperlink"> <Value>'+System.Label.RenewalQuote_Tax_URL+'</Value> </Variable><Variable Name="currency"> <Value>'+rliCurrency+'</Value> </Variable></Session>';
        system.debug('Request Data'+xmlData);
        xmlData = xmlData.replaceAll( '&([^;]+(?!(?:\\w|;)))', '&amp;$1' );
                HttpRequest req1 = new HttpRequest();
                req1.setEndpoint('callout:ContractExpress/rest/api/contracts?template='+templateValue);
                //req1.setEndpoint('callout:ContractExpress/rest/api/contracts);
                
                req1.setMethod('POST');
                req1.setHeader('Content-Type', 'application/json');
                req1.setHeader('Accept','application/json');
                req1.setHeader('Content-Length', '0');
                //req1.set
                
                
                system.debug('+++ Requestis '+ req1);
                Http http1 = new Http();
                HTTPResponse res1 = http1.send(req1);  
                System.debug('+++++ res1 '+ res1.getBody());
                
                //system.debug('++++ Opportujnity is '+ opps);
                
                
                ContractExpressWrapper.postContract cwPC = (ContractExpressWrapper.postContract)JSON.deserialize(res1.getBody(), ContractExpressWrapper.postContract.Class);
                System.debug('+++++ res1 '+ cwPC);
                
                
                
                    HttpRequest req2 = new HttpRequest();
                    req2.setEndpoint('callout:ContractExpress/rest/api/contracts/'+cwPC.contractId+'/answers/');
                    //req1.setEndpoint('callout:ContractExpress/rest/api/contracts);
                    
                    req2.setMethod('POST');
                    req2.setHeader('Content-Type', 'application/json');
                    req2.setHeader('Accept','application/json');
                    req2.setBody(xmlData);
                    system.debug('FINAL OUTPUT'+xmlData);
                    //req1.set
                    
                    
                    system.debug('+++ Request2 is '+ req2);
                    Http http2 = new Http();
                    HTTPResponse res2 = http2.send(req2);  
                    System.debug('Status Code'+res2.getStatusCode());
                    if(res2.getStatusCode()!=500){
                    System.debug('+++++ res2 '+ res2.getBody());
                    
                    //Generate Contract document. It might throw an error as completing the answer takes few seconds
                    
                    HttpRequest req3 = new HttpRequest();
                    req3.setEndpoint('callout:ContractExpress/rest/api/contracts/'+cwPC.contractId+'/documents/');
                    //req1.setEndpoint('callout:ContractExpress/rest/api/contracts);
                    
                    req3.setMethod('GET');
                    req3.setHeader('Content-Type', 'application/json');
                    req3.setHeader('Accept','application/json');
                    req3.setHeader('Content-Length', '0');
                    //req1.set
                    
                    
                    system.debug('+++ Request3 is '+ req3);
                    Http http3 = new Http();
                    HTTPResponse res3 = http3.send(req3);  
                    System.debug('+++++ res3 '+ res3.getBody());
                    
                    //ContractExpressWrapper.doc cwDoc = (ContractExpressWrapper.doc)JSON.deserialize(res3.getBody(), ContractExpressWrapper.doc.Class);
                    Map<String, Object> m =    (Map<String, Object>)JSON.deserializeUntyped(res3.getBody());
                    List<Object> documentObject = (List<Object>)m.get('documents');
                    system.debug('+++ Document object is '+ documentObject);
                    
                    Map<String, Object> a2 =  (Map<String, Object>)documentObject[0];
                    
                    system.debug('+++ a2 is '+ a2);
                    Integer documentId = (Integer)a2.get('documentId');
                    system.debug('++ Document Id is '+ documentId);
                    
                    if(documentId != null){
                        
                        //List<ContractExpressWrapper.Documents1> ceDocuments = cwDoc.documents;    
                        //Get the particular Document
                        
                        HttpRequest req4 = new HttpRequest();
                        req4.setEndpoint('callout:ContractExpress/rest/api/contracts/'+cwPC.contractId+'/documents/'+documentId+'/content');
                        //req1.setEndpoint('callout:ContractExpress/rest/api/contracts);
                        
                        req4.setMethod('GET');
                        req4.setHeader('Content-Length', '0');
                        //req1.set
                        
                        
                        system.debug('+++ Request4 is '+ req4);
                        Http http4 = new Http();
                        HTTPResponse res4 = http4.send(req4);  
                        System.debug('+++++ res4 '+ res4.getBody());
                        
                            
                        
                                                        
                            //Create a Content Version
                            ContentVersion cv = new ContentVersion();
                            cv.Title = 'Document';
                            cv.PathOnClient = 'Document.pdf';
                            cv.VersionData = res4.getbodyasblob();
                            cv.IsMajorVersion = true;
                            cv.Renewal_Quote_ID__c = ID;

                            cvList.add(cv);
                            mapOFRenewalQuoteToContentVersion.put(ID,cv);

                            
                    }else{
                        System.debug('+++ Inside Else');
                    }
                    
                     mapOfRenewalIDtoQuote.get(id).Status__c='Completed';
                    listOfCompletedRecords.add(mapOfRenewalIDtoQuote.get(id));
                    
                 }
                 else{
                     mapOfRenewalIDtoQuote.get(id).Status__c='Failed';
                     listOfFailedRecords.add(mapOfRenewalIDtoQuote.get(id));
                 }   
                
        }
        
        
         if(!listOfFailedRecords.isEmpty())
             {RenewalQuoteTriggerHelper.updateFRecordsPostCallout(listOfFailedRecords);}
          
         if(!cvList.isEmpty())
             {RenewalQuoteTriggerHelper.processContentDocuments(cvList,mapOfRenewalIDtoQuote);}
    
    }
    
    private static string salesorgBasedTNC(string salesOrg){
        String termsAndConditions;
        
        if(salesOrg !='' && salesOrg == 'TA61'){
            termsAndConditions = System.label.RenwalQuoteTnC_UK; 
        }else if(salesOrg !='' && salesOrg == 'TA78'){
            termsAndConditions = System.label.RenwalQuoteTnC_US; 
        }else if(salesOrg !='' && salesOrg == 'CARS'){
            termsAndConditions = System.label.RenwalQuoteTnC_Frn; 
        }else if(salesOrg !='' && salesOrg == 'WEST'){
            termsAndConditions = System.label.RenwalQuoteTnC_WEST;
        }else{
            termsAndConditions = System.label.RenwalQuoteTnC;
        }
        return termsAndConditions;
    }
    
    @TestVisible
    private static string getAgrOrDealNumber(string agrNum,String dealNum){
        String agrOrDealNumber;
        if(agrNum!= Null){
            agrOrDealNumber = agrNum;
        }else if(agrNum == Null && dealNum != Null){
            agrOrDealNumber = dealNum;
        }else{
            agrOrDealNumber = '';
        }
        return agrOrDealNumber;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(LoggingLevel.INFO, 'Batch Finish Method');
    }
        
}