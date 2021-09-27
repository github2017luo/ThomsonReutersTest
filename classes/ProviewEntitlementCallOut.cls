/**
 * CHANGE HISTORY
 * ====================================================================================================
 * Date         Name                    Description
 * 2017-18-07   Rajashree               Created the class to make a HTTP Callout to ESI for Entitlement
                                        as part of Proview Tokenisation Project.
 * =====================================================================================================
 */
 
public without sharing class ProviewEntitlementCallOut{ 
    private static List<Opportunity_Product_Detail_Contact__c> lstOpdtcon = new List<Opportunity_Product_Detail_Contact__c>();
    private static List<Opportunity_Product_Detail_Contact__c> lstOppProdDtlCntct = new List<Opportunity_Product_Detail_Contact__c>();
    private static List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
    private static List<OpportunityLineItem> lstOLIcons = new List<OpportunityLineItem>();
    private static Map<String,List<String>> mapPrDtlConPrDtl = new Map<String,List<String>>();
    private static Map<String,Decimal> mapProdCodeQuan = new Map<String,Decimal>();//[CR]
    private static Map<String,String> mapProdCodeDesc = new Map<String,String>();//[CR]
    private static Map<String,Decimal> mapProdCodeQuantity = new Map<String,Decimal>();//[CR]
    private static List<Contact> lstCon = new List<Contact>();
    private static Set<String> mats1 = new Set<String>();
    private static Set<String> opdcnames = new Set<String>();
    //private static String quoId;
    private static Quote quo;
    private static ProviewSerializeandDeserialize.ProviewRequest smpReq = new ProviewSerializeandDeserialize.ProviewRequest();
    private static List<ContentNote> cNoteList = new List<ContentNote>();
    private static List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            
    //The static method gets called from the emailService class 'ProviewEntitlementRequestHandler' in order to send the products of the Quote 'quoId' for Entitlement.
    public static void sendRequest(String quoId){ 
        if(quoId == NULL){
            return;
        }
        try{   
            getQuote(quoId);
            prePopulateRequest();// smpReq is our request where we will fill in all the parameters to be sent in our request.
            //List<Opportunity_Product_Detail_Contact__c> lstOpdtcon = new List<Opportunity_Product_Detail_Contact__c>();
            //List<Opportunity_Product_Detail_Contact__c> lstOppProdDtlCntct = new List<Opportunity_Product_Detail_Contact__c>();
            //List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
            //List<OpportunityLineItem> lstOLIcons = new List<OpportunityLineItem>();
            //Set<id> setOppProdId = new Set<id>();
            //Map<String,List<String>> mapPrDtlConPrDtl = new Map<String,List<String>>();
            //Map<String,Decimal> mapProdCodeQuan = new Map<String,Decimal>();//[CR]
            //Map<String,String> mapProdCodeDesc = new Map<String,String>();//[CR]
            //Map<String,Decimal> mapProdCodeQuantity = new Map<String,Decimal>();//[CR]
            //List<OpportunityProductDetail__c > lstOppProdDtl = new List<OpportunityProductDetail__c >();
            //List<Contact> lstCon = new List<Contact>();
            //Set<String> mats1 = new Set<String>();
            //Set<String> opdcnames = new Set<String>();
            //if(quo.Sold_To_Contact__c != NULL && Contact.SObjectType.getDescribe().isAccessible()){
            //     lstCon = [SELECT id,FirstName, LastName, Email FROM Contact WHERE id =: quo.Sold_To_Contact__c];
            //}
            getContacts();
            System.debug('@@@@'+lstCon);
            //if(OpportunityLineItem.SObjectType.getDescribe().isAccessible()){
            //    lstOLI =[SELECT id, Product2.name, ProductCode,OpportunityId,Quantity,Unassigned_Tokens_Generated__c FROM OpportunityLineItem WHERE OpportunityId =: quo.Opportunity.Id AND Product2.Entitlement_Oneshot__c = true]; // [CR]
            //}
            getOLIs();
            /*//[CR] Below for loop to create map of prod code and quantity
            for(OpportunityLineItem oli: lstOLI ){                  
                mapProdCodeQuan.put(oli.ProductCode,oli.Quantity); 
                mapProdCodeDesc.put(oli.ProductCode,oli.Product2.name);
                mapProdCodeQuantity.put(oli.ProductCode,oli.Quantity); 
            }*/
            //if(OpportunityProductDetail__c.SObjectType.getDescribe().isAccessible()){
            //    lstOppProdDtl = [SELECT id,Product__r.ProductCode FROM OpportunityProductDetail__c WHERE Opportunity__r.id =: quo.Opportunity.Id AND Product__r.Entitlement_Oneshot__c = true]; // Querying the OpportunityProductDetails having one shot products.
            //}
            getOPDs();
            /*if(lstOppProdDtl!= NULL && !lstOppProdDtl.isEmpty()){
            // Below logic is to create the map with OpportunityProductDetailContact as the key and list of all of the OpportunityProductDetails(Product code) it is associated with as the value .
                for(OpportunityProductDetail__c oppProDtl : lstOppProdDtl){
                    setOppProdId.add(oppProDtl.id);    
                }
                if(!setOppProdId.isEmpty() && Opportunity_Product_Detail_Contact__c..SObjectType.getDescribe().isAccessible()){
                    lstOppProdDtlCntct =[SELECT id,Token_Created__c,Contact__r.SAP_Contact_ID__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.Name,Email__c,Product_Detail__c, Product_Detail__r.Product__r.ProductCode  FROM Opportunity_Product_Detail_Contact__c WHERE Product_Detail__c IN : setOppProdId];
                }
                if(!lstOppProdDtlCntct.isEmpty()){
                    for(Opportunity_Product_Detail_Contact__c opCntc : lstOppProdDtlCntct){
                        // Taking Email__c as key for Associated contacts
                        if(mapPrDtlConPrDtl.keySet().contains(opCntc.Email__c)){
                            mapPrDtlConPrDtl.get(opCntc.Email__c).add(opCntc.Product_Detail__r.Product__r.ProductCode);
                        }
                        else{
                            List<String> lstOpPrdDtl = new  List<String>();
                            lstOpPrdDtl.add(opCntc.Product_Detail__r.Product__r.ProductCode);
                            mapPrDtlConPrDtl.put(opCntc.Email__c,lstOpPrdDtl);
                            lstOpdtcon.add(opCntc);
                        }
                    }
                }
            }*/
            //System.debug('@@@@@@@@opCntc'+lstOpdtcon);
            //System.debug('@@@@@@@@ mapPrDtlConPrDtl'+mapPrDtlConPrDtl);
            
            /*
            // smpReq is our request where we will fill in all the parameters to be sent in our request.
            //ProviewSerializeandDeserialize.ProviewRequest smpReq = new ProviewSerializeandDeserialize.ProviewRequest();
            
            ProviewSerializeandDeserialize.cls_referenceIds  smpRef = new ProviewSerializeandDeserialize.cls_referenceIds();
            List<ProviewSerializeandDeserialize.cls_referenceIds> smpRefrnc = new List<ProviewSerializeandDeserialize.cls_referenceIds>(); 
            smpRef.sourceSystemRefIdType = 'Opportunity';
            smpRef.value = quo.Opportunity.id;
            smpRefrnc.add(smpRef);              
            if(!smpRefrnc.isEmpty() && smpRefrnc != NULL){
                smpReq.referenceIds.addAll(smpRefrnc); 
            }
            
            smpReq.actionCode='CREATE';
            smpReq.ESIHeader.applicationId = KeyValueListStore__c.getInstance('ProviewRequestApplicationId').TextValue__c; //SF06
            smpReq.ESIHeader.companyId = quo.Opportunity.PriceBook2.Sales_Org__c;
            smpReq.ESIHeader.configGroup = KeyValueListStore__c.getInstance('BigRuleCconfigGroup').TextValue__c;
            */
            /*if(!lstCon.isEmpty()){
                for(Contact cnt : lstCon){
                // We need to send the Sold TO Contact Details always in our request.Hence adding it to our request.
                    ProviewSerializeandDeserialize.cls_contact smpCon = new ProviewSerializeandDeserialize.cls_contact();
                    List<ProviewSerializeandDeserialize.cls_contact> smpCnt = new List<ProviewSerializeandDeserialize.cls_contact>(); 
                    smpCon.contactId = cnt.id;
                    smpCon.firstName = cnt.FirstName;
                    smpCon.lastName = cnt.LastName;
                    smpCon.email = cnt.Email;
                    smpCon.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
                    smpCnt.add(smpCon); 
                    if(smpCnt!= NULL && !smpCnt.isEmpty()){
                        smpReq.contact.addAll(smpCnt); 
                    }
                }
            }*/
            mapOPDCtoReq();
            /*
            if(lstOpdtcon!= NULL && !lstOpdtcon.isEmpty()){
                for(Opportunity_Product_Detail_Contact__c opProdDtlCntct: lstOpdtcon){
                    system.debug('******Inside Online Contact for loop with SAP Online Contact********');
                    List<ProviewSerializeandDeserialize.cls_onlineContact> smpOnlCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();              
                    List<ProviewSerializeandDeserialize.cls_entitlements> smpEntl = new List<ProviewSerializeandDeserialize.cls_entitlements>();
                    List<ProviewSerializeandDeserialize.cls_subscriptions> smpSub = new List<ProviewSerializeandDeserialize.cls_subscriptions>();
                    List<ProviewSerializeandDeserialize.cls_tokenDetails> smpTok = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
                    List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>();
                    ProviewSerializeandDeserialize.cls_entitlements smpObjEntl = new ProviewSerializeandDeserialize.cls_entitlements();
                    ProviewSerializeandDeserialize.cls_subscriptions smpObjSub = new ProviewSerializeandDeserialize.cls_subscriptions();
                    ProviewSerializeandDeserialize.cls_onlineContact smpOn = new ProviewSerializeandDeserialize.cls_onlineContact();
                    ProviewSerializeandDeserialize.cls_tokenDetails smpToken= new ProviewSerializeandDeserialize.cls_tokenDetails();

                    smpToken.noOfUses = '';
                    if(quo.Opportunity.SAP_Account_Number__c != null){
                        smpToken.description = quo.QuoteNumber +'_'+ quo.Opportunity.SAP_Account_Number__c;
                    }
                    else{
                        smpToken.description = quo.QuoteNumber;
                    }
                    smpTok.add(smpToken);

                    if((opProdDtlCntct.Email__c != NULL)){
                        smpOn.contactId = opProdDtlCntct.Contact__r.SAP_Contact_ID__c;
                        smpOn.firstName = opProdDtlCntct.Contact__r.FirstName;
                        smpOn.lastName = opProdDtlCntct.Contact__r.LastName;
                        Decimal countProdtotal = 0;
                        for(String ProdCode : mapPrDtlConPrDtl.get(opProdDtlCntct.Email__c))
                        {    
                
                            // [CR]Below logic to reduce one quantity each time from the quantity value of the map, so that we get the left over quantity
                            if(mapProdCodeQuan.keySet().contains(ProdCode)){
                                //put the logic here to finally have a map(mapProdCodeQuan) ready with prodcode as key and left over quanity of each prod as value. 
                                countProdtotal  = mapProdCodeQuan.get(ProdCode) -1;
                                mapProdCodeQuan.put(ProdCode,countProdtotal);
                                System.debug('@@@@@@@@@@1'+mapProdCodeQuan);
                            }
                            ProviewSerializeandDeserialize.cls_materialNumber smpMat = new ProviewSerializeandDeserialize.cls_materialNumber();
                            smpMat.materialNumber = ProdCode;
                            smpMat.configType = quo.Opportunity.PriceBook2.Sales_Org__c;
                            smpMat.quantity = '1'; // [CR]
                            smpMat.classificationValue = String.valueOf(Integer.valueOf(mapProdCodeQuantity.get(ProdCode)));
                            smpMat.description = mapProdCodeDesc.get(ProdCode);
                            smpMtrl.add(smpMat);
                            System.debug('********2'+smpMtrl);
                        }
                    }
                    smpOn.email = opProdDtlCntct.Email__c;
                    smpOn.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
                    if(smpMtrl != NULL && !smpMtrl.isEmpty()){
                        smpObjSub.materialNumber.addAll(smpMtrl);
                    }
                    smpSub.add(smpObjSub);
                    //   smpObjEntl.domainId = 'E Reader';
                    if(smpSub!= NULL && !smpSub.isEmpty()){
                        smpObjEntl.subscriptions.addAll(smpSub);
                    }
                    if(smpTok!= NULL && !smpTok.isEmpty()){
                        smpObjEntl.tokenDetails.addAll(smpTok);
                    }
                    smpEntl.add(smpObjEntl);
                    if(smpEntl!= NULL && !smpEntl.isEmpty()){
                        smpOn.entitlements.addAll(smpEntl);
                    }
                    smpOnlCnt.add(smpOn);
                    if(smpOnlCnt!= NULL && !smpOnlCnt.isEmpty()){
                        smpReq.onlineContact.addAll(smpOnlCnt);
                    }
                }
            }
            System.debug('@@@@@@@@@@2'+mapProdCodeQuan);
            */
            mapOLItoReq();
            /*
            // [CR] Option 1 Single Use and Multi use
            if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token' || quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token'){
                for(OpportunityLineItem oli: lstOLI){                       
                    if(mapProdCodeQuan.containskey(oli.ProductCode) && mapProdCodeQuan.get(oli.ProductCode)>0){
                        List<ProviewSerializeandDeserialize.cls_onlineContact> smpOnlCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();
                        ProviewSerializeandDeserialize.cls_onlineContact smpOn = new ProviewSerializeandDeserialize.cls_onlineContact();
                        List<ProviewSerializeandDeserialize.cls_entitlements> smpEntl = new List<ProviewSerializeandDeserialize.cls_entitlements>();
                        List<ProviewSerializeandDeserialize.cls_subscriptions> smpSub = new List<ProviewSerializeandDeserialize.cls_subscriptions>();
                        List<ProviewSerializeandDeserialize.cls_tokenDetails> smpTok = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
                        List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>();
                        List<ProviewSerializeandDeserialize.cls_properties> smpPrty = new List<ProviewSerializeandDeserialize.cls_properties>();
                        List<ProviewSerializeandDeserialize.cls_property> smpPrty1 = new List<ProviewSerializeandDeserialize.cls_property>();                          
                        ProviewSerializeandDeserialize.cls_entitlements smpObjEntl = new ProviewSerializeandDeserialize.cls_entitlements();
                        ProviewSerializeandDeserialize.cls_subscriptions smpObjSub = new ProviewSerializeandDeserialize.cls_subscriptions();            
                        ProviewSerializeandDeserialize.cls_tokenDetails smpToken= new ProviewSerializeandDeserialize.cls_tokenDetails();                                            
                        smpOn.contactId = null;
                        smpOn.firstName = null;
                        smpOn.lastName = null;
                        smpOn.email = null;
                        smpOn.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
                        smpToken.noOfUses =''; 
                        if(quo.Opportunity.SAP_Account_Number__c != null){
                            smpToken.description = quo.QuoteNumber +'_'+ quo.Opportunity.SAP_Account_Number__c;
                        }
                        else{
                            smpToken.description = quo.QuoteNumber;
                        }
                        smpTok.add(smpToken);
                    
                        ProviewSerializeandDeserialize.cls_materialNumber smpMat = new ProviewSerializeandDeserialize.cls_materialNumber();
                        smpMat.materialNumber = oli.ProductCode;
                        smpMat.configType = quo.Opportunity.PriceBook2.Sales_Org__c; 
                        smpMat.description = oli.Product2.name;
                        smpMat.classificationValue = String.valueOf(Integer.valueof(oli.Quantity));
                        Integer i = Integer.valueof(mapProdCodeQuan.get(oli.ProductCode));
                        smpMat.quantity = String.valueOf(i); 
                        system.debug('******smpMat Material---->'+smpMat);
                        smpMtrl.add(smpMat);                     
                            
                        if(smpMtrl!= NULL && !smpMtrl.isEmpty()){
                            smpObjSub.materialNumber.addAll(smpMtrl);
                        }
                    
                        ProviewSerializeandDeserialize.cls_properties smpProp = new ProviewSerializeandDeserialize.cls_properties();
                        smpProp.key = 'SingleUseToken';
                        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token'){
                            smpProp.value = 'true';  
                        }   
                        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token'){
                            smpProp.value = 'false';
                        }                       
                        smpPrty.add(smpProp);
                        
                        if(smpPrty!= NULL && !smpPrty.isEmpty()){
                            smpOn.properties.addAll(smpPrty);
                        }
                        
                        ProviewSerializeandDeserialize.cls_property smpProp1 = new ProviewSerializeandDeserialize.cls_property();
                        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token'){
                            smpProp1.key = 'SingleUseToken';
                            smpProp1.value = 'true';  
                        }   
                        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token'){
                            smpProp1.key = 'MultiUseToken';
                            smpProp1.value = 'true';
                        }                       
                        smpPrty1.add(smpProp1);
                    
                        if(smpPrty1!= NULL && !smpPrty1.isEmpty()){
                            smpOn.property.addAll(smpPrty1);
                        }
                        
                        smpSub.add(smpObjSub);
                        if(smpSub!= NULL && !smpSub.isEmpty()){
                            smpObjEntl.subscriptions.addAll(smpSub);
                        }
                        if(smpTok!= NULL && !smpTok.isEmpty()){
                            smpObjEntl.tokenDetails.addAll(smpTok);
                        }
                        smpEntl.add(smpObjEntl);
                        if(smpEntl!= NULL && !smpEntl.isEmpty()){
                            smpOn.entitlements.addAll(smpEntl);
                        } 
                    
                    
                        smpOnlCnt.add(smpOn);                           
                        if(smpOnlCnt!= NULL && !smpOnlCnt.isEmpty()){
                            smpReq.onlineContact.addAll(smpOnlCnt);
                        }                         
                    } 
                }
            } */ 

            /*if(!lstOLI.isEmpty()){
                for(OpportunityLineItem oli: lstOLI ){  
                    if(mapProdCodeQuan.containskey(oli.ProductCode) && mapProdCodeQuan.get(oli.ProductCode)>0){
                            lstOLIcons.add(oli);
                    }
                }
            }*/
            /*
            // [CR] Option 2 Single Use Consolidated & Multi Use Consolidated
            if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated' || quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated'){
                if(!lstOLIcons.isEmpty() && mapProdCodeQuan.containskey(lstOLIcons[0].ProductCode) && mapProdCodeQuan.get(lstOLIcons[0].ProductCode)>0){
                    List<ProviewSerializeandDeserialize.cls_onlineContact> smpOnlCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();
                    ProviewSerializeandDeserialize.cls_onlineContact smpOn = new ProviewSerializeandDeserialize.cls_onlineContact();
                    List<ProviewSerializeandDeserialize.cls_entitlements> smpEntl = new List<ProviewSerializeandDeserialize.cls_entitlements>();
                    List<ProviewSerializeandDeserialize.cls_subscriptions> smpSub = new List<ProviewSerializeandDeserialize.cls_subscriptions>();
                    List<ProviewSerializeandDeserialize.cls_tokenDetails> smpTok = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
                    List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>(); 
                    List<ProviewSerializeandDeserialize.cls_properties> smpPrty = new List<ProviewSerializeandDeserialize.cls_properties>();           
                    List<ProviewSerializeandDeserialize.cls_property> smpPrty1 = new List<ProviewSerializeandDeserialize.cls_property>();                         
                    
                    ProviewSerializeandDeserialize.cls_entitlements smpObjEntl = new ProviewSerializeandDeserialize.cls_entitlements();
                    ProviewSerializeandDeserialize.cls_subscriptions smpObjSub = new ProviewSerializeandDeserialize.cls_subscriptions();            
                    ProviewSerializeandDeserialize.cls_tokenDetails smpToken= new ProviewSerializeandDeserialize.cls_tokenDetails();                                            
                    smpOn.contactId = null;
                    smpOn.firstName = null;
                    smpOn.lastName = null;
                    smpOn.email = null;
                    smpOn.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
                    smpToken.noOfUses =''; 
                    if(quo.Opportunity.SAP_Account_Number__c != null){
                        smpToken.description = quo.QuoteNumber +'_'+ quo.Opportunity.SAP_Account_Number__c;
                    }
                    else{
                        smpToken.description = quo.QuoteNumber;
                    }
                    smpTok.add(smpToken);
                    for(OpportunityLineItem oli: lstOLIcons){
                        ProviewSerializeandDeserialize.cls_materialNumber smpMat = new ProviewSerializeandDeserialize.cls_materialNumber();                    
                        smpMat.materialNumber = oli.ProductCode;
                        smpMat.configType = quo.Opportunity.PriceBook2.Sales_Org__c; 
                        smpMat.description = oli.Product2.name;
                        smpMat.classificationValue = String.valueOf(Integer.valueof(oli.Quantity));
                        Integer i = Integer.valueof(mapProdCodeQuan.get(oli.ProductCode));
                        smpMat.quantity = String.valueOf(i);  
                        system.debug('******smpMat Material---->'+smpMat);
                        smpMtrl.add(smpMat);
                    }  
                    if(smpMtrl!= NULL && !smpMtrl.isEmpty()){
                        smpObjSub.materialNumber.addAll(smpMtrl);
                    }
                    ProviewSerializeandDeserialize.cls_properties smpProp = new ProviewSerializeandDeserialize.cls_properties();
                    smpProp.key = 'SingleUseToken';
                    if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated'){
                        smpProp.value = 'true'; 
                    }
                    if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated'){  
                        smpProp.value = 'false'; 
                    }                       
                    smpPrty.add(smpProp);
                    
                    if(smpPrty!= NULL && !smpPrty.isEmpty()){
                        smpOn.properties.addAll(smpPrty);
                    }
                    
                    ProviewSerializeandDeserialize.cls_property smpProp1 = new ProviewSerializeandDeserialize.cls_property();
                    
                    if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated'){
                        smpProp1.key = 'SingleUseToken';
                        smpProp1.value = 'false'; 
                    }
                    if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated'){
                        smpProp1.key = 'MultiUseToken';
                        smpProp1.value = 'false'; 
                    }                       
                    smpPrty1.add(smpProp1);
                    
                    if(smpPrty1!= NULL && !smpPrty1.isEmpty()){
                        smpOn.property.addAll(smpPrty1);
                    }
                    
                    smpSub.add(smpObjSub);
                    if(smpSub!= NULL && !smpSub.isEmpty()){
                        smpObjEntl.subscriptions.addAll(smpSub);
                    }
                    if(smpTok!= NULL && !smpTok.isEmpty()){
                        smpObjEntl.tokenDetails.addAll(smpTok);
                    }
                    smpEntl.add(smpObjEntl);
                    if(smpEntl!= NULL && !smpEntl.isEmpty()){
                        smpOn.entitlements.addAll(smpEntl);
                    }   
                    smpOnlCnt.add(smpOn);  
                    if(smpOnlCnt!= NULL && !smpOnlCnt.isEmpty()){
                        smpReq.onlineContact.addAll(smpOnlCnt);
                    } 
                }
            }  */          
            mapOLItoReqConsolidated();
            sendRequestToESI();
            /*
            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ProviewManageEntitlement'); 
            // Serializing the request,and putting it in setBody.
            String strBody = JSON.serialize(smpReq);
            system.debug('strBody...'+strBody);
            HttpResponse resp = new HttpResponse();
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            req.setMethod('POST');
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);            
            req.setHeader('Content-Type',  'application/json');             
            req.setBody(strBody);
            req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
            // Receiving the JSON response
            if(!Test.isRunningtest()){
                resp = http.send(req);
            }
            else{
                resp.setHeader('Content-Type', 'application/json');
                resp.setBody('{"onlineContact" : [ {"firstName" : "HARMAN","lastName" : "CHAURASIA","email" : "rajashree.behera@thomsonreuters.com","sourceId" : "SF06","account" : {"companyId" : "LLEY" },"entitlements" : [ {"tokenDetails" : [ {"tokenNumber" : "dMwIMe6qzvewpFtt","description" : "SF974704_1005004610","url" : "http://redemptionservice.com/redeem/dMwIMe6qzvewpFtt"} ],"subscriptions" : [ {"materialNumber" : [ {"materialNumber" :"000000000042044448"} ]} ] } ],"Notification" : {"statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}}, { "contactId" : "0016079445","firstName" : "PV","lastName" : "test","email" : "saumya.ranjan@thomsonreuters.com","sourceId" : "SF06","account" : {"companyId" : "LLEY"},"entitlements" : [ {"tokenDetails" : [ {"tokenNumber" : "m7sPOpE9UVxqGLkA","description" : "SF974704_1005004610","url" : "http://redemptionservice.com/redeem/m7sPOpE9UVxqGLkA"} ],"subscriptions" : [{"materialNumber" : [ {"materialNumber" : "000000000042044448"} ]} ]} ],"Notification" : {"statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}} ],"Notification" : {"statusCode" : "Success","statusDescription" : "Token has been created OR Resources has been added successfully"}}');        
                resp.setStatusCode(200); 
            }
            String strRes = resp.getBody();
            system.debug('strRes..'+strRes);
            system.debug('strRes..'+resp.getStatusCode());

            ProviewSerializeandDeserialize.ProviewResponse smpRes = new ProviewSerializeandDeserialize.ProviewResponse();
            //List<ProviewSerializeandDeserialize.cls_onlineContact> smpRes1 = new List<ProviewSerializeandDeserialize.cls_onlineContact>();
            List<ProviewSerializeandDeserialize.cls_onlineContact>  olnCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();       

            if(resp.getBody().contains('"Notification"')){
                // Deserializing the JSON response
                smpRes = (ProviewSerializeandDeserialize.ProviewResponse)JSON.deserialize(resp.getbody(),ProviewSerializeandDeserialize.ProviewResponse.class);
            }
            System.debug('@@@@@@@@'+smpRes );
            integer i= 1;
            // if(smpRes.Notification.statusCode == 'SUCCESS') {
            if(resp.getStatusCode() == 200 && strRes.contains('Notification') ){
                // Capturing the response in some fields and notes in Quote
                if(smpRes.Notification != null){
                    if(smpRes.Notification.statusDescription != null || smpRes.Notification.statusDescription != ''){
                        quo.Entitlement_Status_Description__c = smpRes.Notification.statusDescription;
                    }
                    else{
                        quo.Entitlement_Status_Description__c = '';
                    }
                    if(smpRes.Notification.statusCode != null || smpRes.Notification.statusCode != ''){
                        if(smpRes.Notification.statusCode == 'Failed' || smpRes.Notification.statusCode == 'FAILED' || smpRes.Notification.statusCode == 'failed'){
                            quo.Entitlement_Status__c = 'Failure';
                            quo.Entitlement_Complete__c= false;
                        }
                        else if(smpRes.Notification.statusCode == 'Partial Failed' || smpRes.Notification.statusCode == 'PARTIAL FAILED' ){
                            quo.Entitlement_Status__c = 'Partial Failure';
                            quo.Entitlement_Complete__c= false;
                        }
                        else{
                            quo.Entitlement_Status__c = smpRes.Notification.statusCode;
                            quo.Entitlement_Complete__c= true;
                        }
                    }
                    else{
                        quo.Entitlement_Status__c = 'Failure';
                        quo.Entitlement_Complete__c= false;
                    }
                }
                else{
                    quo.Entitlement_Status_Description__c = '';
                    quo.Entitlement_Status__c = '';
                }
                System.debug('success');
                quo.Entitlement_Generated__c = true;
                if(Quote.SObjectType.getDescribe().isUpdateable()){
                    update quo;
                }
                if(smpRes.onlineContact!= NULL && !smpRes.onlineContact.isEmpty()){
                    olnCnt.addAll(smpRes.onlineContact);
                }
                System.debug('@@@@@@@@olnCnt'+smpRes.onlineContact);
                System.debug('@@@@@@@@olnCnt 2 '+olnCnt);
                if(olnCnt != null && !olnCnt.isEmpty()){
                    //Note objNote;
                    List<ContentNote> cNoteList = new List<ContentNote>();
                    List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                    //Attachment objAtchmt;
                    for(ProviewSerializeandDeserialize.cls_onlineContact olCnt : olnCnt){
                        String body =''; 
                        String name =''; 
                        List<ProviewSerializeandDeserialize.cls_entitlements> entlmnt = new List<ProviewSerializeandDeserialize.cls_entitlements>();
                        List<ProviewSerializeandDeserialize.cls_subscriptions> subsc= new List<ProviewSerializeandDeserialize.cls_subscriptions>();
                        List<ProviewSerializeandDeserialize.cls_materialNumber> mats= new List<ProviewSerializeandDeserialize.cls_materialNumber>();
                        List<ProviewSerializeandDeserialize.cls_tokenDetails> token = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
                        if(olCnt.firstName != null || olCnt.lastName!= null || olCnt.firstName != '' || olCnt.lastName!= ''){
                            body = '###### Online Contact ####: \n';
                            body = body +'\nName : ' + olCnt.firstName+' '+olCnt.lastName;
                            name = olCnt.firstName+' '+olCnt.lastName;
                        }
                        else{
                        body = '###### Online Contact Name ####: \n'+ '';
                        }
                        System.debug('@@@@@@@@@@@@@body1 '+body );
                        if(olCnt.Notification != null ){
                            if(olCnt.Notification.statusCode != null && olCnt.Notification.statusCode != ''){
                                body = body+ '\nOnline Contact Status : '+ olCnt.Notification.statusCode;
                            }
                            else{
                                body = body+ '\nOnline Status : '+ '';
                            }
                            if(olCnt.Notification.statusDescription != null && olCnt.Notification.statusDescription != ''){
                                body= body+ '\nOnline Contact Status Description : '+olCnt.Notification.statusDescription;
                            }
                            else{
                                body= body+ '\nOnline Status Description : '+ '';
                            }
                        }
                        body = body+ '\n\n';
                        System.debug('@@@@@@@@@@@@@body2 '+body );
                        if(olCnt.entitlements != NULL && !olCnt.entitlements.isEmpty()){
                            entlmnt.addAll(olCnt.entitlements);
                            if(entlmnt != null && !entlmnt.isEmpty()){
                                for(ProviewSerializeandDeserialize.cls_entitlements etl :entlmnt ){
                                    if(etl.subscriptions!= null && !etl.subscriptions.isEmpty()){
                                        subsc.addAll(etl.subscriptions); 
                                    }
                                    if(etl.tokenDetails!= null && !etl.tokenDetails.isEmpty()){
                                        token.addAll(etl.tokenDetails);
                                    } 
                                }
                                System.debug('@@@@@@@@@@@@@body3 '+body );
                                if(token!= null && !token.isEmpty()){
                                    body = body + '###### Token Information ####: \n';
                                    for(ProviewSerializeandDeserialize.cls_tokenDetails tokn: token){
                                        if(tokn.tokenNumber != null && tokn.tokenNumber != '' ){
                                            body = body + '\nToken Number : ' + tokn.tokenNumber ;
                                        }
                                        else{
                                            body = body + '\nToken Number : ' + '' ;
                                        }
                                        if(tokn.url!= null && tokn.url!= ''){
                                            body = body+ '\n' + 'Token URL : ' + tokn.url;
                                        }
                                        else{
                                            body = body+ '\n' + 'Token URL: ' + '' ;
                                        }
                                    }
                                }
                                body = body+ '\n\n';
                            }
                            if(subsc!= null && !subsc.isEmpty()){
                                for(ProviewSerializeandDeserialize.cls_subscriptions sbs :subsc){
                                    if(sbs.materialNumber!= null && !sbs.materialNumber.isEmpty()){
                                        mats.addAll(sbs.materialNumber);   
                                    }
                                }
                            }
                            body = body + '###### Materials Information ####: \n';
                            if(mats!= null && !mats.isEmpty()){
                                for(ProviewSerializeandDeserialize.cls_materialNumber mtrls :mats){
                                    if( mtrls.materialNumber != null &&  mtrls.materialNumber != '' ){
                                    body= body + '\nMaterial Numbers : ' + mtrls.materialNumber ;
                                    } 
                                } 
                            }
                        }
                        body = body+ '\n\n';
                        //if(body.length()<32000){                           
                        //    objNote = new Note();
                        //    objNote.Body = body;
                        //    objNote.Title = String.valueOf(name +'_Info');
                        //    objNote.ParentId = quo.Id;
                        //    if(objNote != null){
                        //        INSERT objNote;
                        //    }
                        //}
                        //else{
                        //    objAtchmt = new Attachment();
                        //    objAtchmt.Body = Blob.valueOf(body);
                        //    objAtchmt.Name = String.valueOf(name +'_Info.txt');
                        //    objAtchmt.ParentId = quo.Id; 
                        //   if(objAtchmt != null){
                        //    insert objAtchmt;
                        //    }
                        //}
                        ContentNote cNote = new ContentNote();
                        cNote.Title = String.valueOf(name +'_Info');
                        cNote.Content = Blob.valueOf(body.escapeHTML4());
                        cNoteList.add(cNote);
                        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId=cNote.Id, LinkedEntityId=quo.Id, ShareType='V', Visibility='AllUsers');
                        cdlList.add(cdl);
                        if((olCnt.firstName !='' || olCnt.firstName != null) && ((olCnt.Notification.statusCode =='Success') || (olCnt.Notification.statusCode =='\'Success\''))){
                            opdcnames.add(name);                      
                        }
                        System.debug('OPDC'+opdcnames);
                        
                        //update lstOppProdDtlCntct;
                        if((olCnt.firstName=='' || olCnt.firstName == null) && ((olCnt.Notification.statusCode =='Success') || (olCnt.Notification.statusCode =='\'Success\''))){
                                for(ProviewSerializeandDeserialize.cls_materialNumber mtrls :mats){
                                    
                                if( mtrls.materialNumber != null &&  mtrls.materialNumber != '' ){ 
                                mats1.add(mtrls.materialNumber);
                                }
                            }                  
                        }
                    }
                    if(ContentNote.SObjectType.getDescribe().isCreateable() && cNoteList.size()>0){
                        insert cNoteList;
                    }
                    if(ContentDocumentLink.SObjectType.getDescribe().isCreateable() && cdlList.size()>0){
                        insert cdlList;
                    }
                    for(Opportunity_Product_Detail_Contact__c opdc : lstOppProdDtlCntct){
                        if(opdcnames.contains(opdc.Contact__r.Name)){
                            opdc.Token_Created__c = true;
                            //update opdc;
                        }
                    }
                    if(Opportunity_Product_Detail_Contact__c.SObjectType.getDescribe().isUpdateable()){
                        update lstOppProdDtlCntct;
                    }
                    System.debug('lstOLIcons@'+lstOLIcons);
                    for(OpportunityLineItem oli: lstOLIcons){
                        if(mats1.contains(oli.ProductCode)){
                            oli.Unassigned_Tokens_Generated__c = true;
                        }
                        //update oli;          
                    }
                    if(OpportunityLineItem.SObjectType.getDescribe().isUpdateable()){
                        update lstOLIcons;
                    }
                    
                }
            }
            else{
                System.debug('Error occured while fetching the token from ESI');
                quo.Entitlement_Status__c= 'Failure';
                quo.Entitlement_Complete__c= false;
                quo.Entitlement_Generated__c = true;
                quo.Entitlement_Status_Description__c = 'Error occured while fetching the token from ESI'; 
                if(Quote.SObjectType.getDescribe().isUpdateable() && quo != null){
                    UPDATE quo;
                }
            } */
        } 
        catch(Exception oException){            
            quo.Entitlement_Generated__c = true;
            quo.Entitlement_Status__c= 'Failure';
            quo.Entitlement_Complete__c= false;
            System.debug('@@@@@@@oException.getMessage()'+oException.getMessage()+' : '+oException.getStackTraceString());
            //quo.Entitlement_Status_Description__c = 'Exception Occurred :'+oException.getMessage();
            if(Quote.SObjectType.getDescribe().isUpdateable() && quo != null){
                UPDATE quo;
            }
        } 
    }
    
    private static void getQuote(String quoId){
        quo = new Quote();
        if(Quote.SObjectType.getDescribe().isAccessible()){
            quo = [SELECT id,Create_Token_for_Unused_Product_Quantity__c,QuoteNumber,Sold_To_Contact__c,Opportunity.SAP_Account_Number__c,OpportunityId,Opportunity.id,Opportunity.Account.SAPAccountNumber__c,Opportunity.PriceBook2.Sales_Org__c FROM Quote WHERE id =: quoId];
        }
    }
    
    private static void getContacts(){
        lstCon = new List<Contact>();
        if(quo.Sold_To_Contact__c != NULL && Contact.SObjectType.getDescribe().isAccessible()){
            lstCon = [SELECT id,FirstName, LastName, Email FROM Contact WHERE id =: quo.Sold_To_Contact__c];
        }
        if(!lstCon.isEmpty()){
            for(Contact cnt : lstCon){
            // We need to send the Sold TO Contact Details always in our request.Hence adding it to our request.
                ProviewSerializeandDeserialize.cls_contact smpCon = new ProviewSerializeandDeserialize.cls_contact();
                List<ProviewSerializeandDeserialize.cls_contact> smpCnt = new List<ProviewSerializeandDeserialize.cls_contact>(); 
                smpCon.contactId = cnt.id;
                smpCon.firstName = cnt.FirstName;
                smpCon.lastName = cnt.LastName;
                smpCon.email = cnt.Email;
                smpCon.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
                smpCnt.add(smpCon); 
                if(smpCnt!= NULL && !smpCnt.isEmpty()){
                    smpReq.contact.addAll(smpCnt); 
                }
            }
        }
    }
    private static void getOLIs(){
        lstOLI = new List<OpportunityLineItem>();
        if(OpportunityLineItem.SObjectType.getDescribe().isAccessible()){
            lstOLI =[SELECT id, Product2.name, ProductCode,OpportunityId,Quantity,Unassigned_Tokens_Generated__c FROM OpportunityLineItem WHERE OpportunityId =: quo.Opportunity.Id AND Product2.Entitlement_Oneshot__c = true]; // [CR]
        }
        //[CR] Below for loop to create map of prod code and quantity
        for(OpportunityLineItem oli: lstOLI ){                  
            mapProdCodeQuan.put(oli.ProductCode,oli.Quantity); 
            mapProdCodeDesc.put(oli.ProductCode,oli.Product2.name);
            mapProdCodeQuantity.put(oli.ProductCode,oli.Quantity); 
            if(mapProdCodeQuan.containskey(oli.ProductCode) && mapProdCodeQuan.get(oli.ProductCode)>0){
                    lstOLIcons.add(oli);
            }
        }
    }

    private static void getOPDs(){
        List<OpportunityProductDetail__c> lstOppProdDtl = new List<OpportunityProductDetail__c>();
        Set<id> setOppProdId = new Set<id>();
        if(OpportunityProductDetail__c.SObjectType.getDescribe().isAccessible()){
            lstOppProdDtl = [SELECT id,Product__r.ProductCode FROM OpportunityProductDetail__c WHERE Opportunity__r.id =: quo.Opportunity.Id AND Product__r.Entitlement_Oneshot__c = true]; // Querying the OpportunityProductDetails having one shot products.
        }
        if(lstOppProdDtl!= NULL && !lstOppProdDtl.isEmpty()){
            for(OpportunityProductDetail__c oppProDtl : lstOppProdDtl){
                setOppProdId.add(oppProDtl.id);    
            }
            if(!setOppProdId.isEmpty() && Opportunity_Product_Detail_Contact__c..SObjectType.getDescribe().isAccessible()){
                lstOppProdDtlCntct =[SELECT id,Token_Created__c,Contact__r.SAP_Contact_ID__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.Name,Email__c,Product_Detail__c, Product_Detail__r.Product__r.ProductCode  FROM Opportunity_Product_Detail_Contact__c WHERE Product_Detail__c IN : setOppProdId];
            }
            if(!lstOppProdDtlCntct.isEmpty()){
                populateMapPrDtlConPrDtl();
            }
        }
        System.debug('@@@@@@@@opCntc'+lstOpdtcon);
        System.debug('@@@@@@@@ mapPrDtlConPrDtl'+mapPrDtlConPrDtl);
    }

    private static void populateMapPrDtlConPrDtl(){
        for(Opportunity_Product_Detail_Contact__c opCntc : lstOppProdDtlCntct){
            // Taking Email__c as key for Associated contacts
            if(mapPrDtlConPrDtl.keySet().contains(opCntc.Email__c)){
                mapPrDtlConPrDtl.get(opCntc.Email__c).add(opCntc.Product_Detail__r.Product__r.ProductCode);
            }
            else{
                List<String> lstOpPrdDtl = new  List<String>();
                lstOpPrdDtl.add(opCntc.Product_Detail__r.Product__r.ProductCode);
                mapPrDtlConPrDtl.put(opCntc.Email__c,lstOpPrdDtl);
                lstOpdtcon.add(opCntc);
            }
        }
    }
    
    private static void prePopulateRequest(){
        // smpReq is our request where we will fill in all the parameters to be sent in our request.
        //ProviewSerializeandDeserialize.ProviewRequest smpReq = new ProviewSerializeandDeserialize.ProviewRequest();
        
        ProviewSerializeandDeserialize.cls_referenceIds  smpRef = new ProviewSerializeandDeserialize.cls_referenceIds();
        List<ProviewSerializeandDeserialize.cls_referenceIds> smpRefrnc = new List<ProviewSerializeandDeserialize.cls_referenceIds>(); 
        smpRef.sourceSystemRefIdType = 'Opportunity';
        smpRef.value = quo.Opportunity.id;
        smpRefrnc.add(smpRef);              
        if(!smpRefrnc.isEmpty() && smpRefrnc != NULL){
            smpReq.referenceIds.addAll(smpRefrnc); 
        }
        
        smpReq.actionCode='CREATE';
        smpReq.ESIHeader.applicationId = KeyValueListStore__c.getInstance('ProviewRequestApplicationId').TextValue__c; //SF06
        smpReq.ESIHeader.companyId = quo.Opportunity.PriceBook2.Sales_Org__c;
        smpReq.ESIHeader.configGroup = KeyValueListStore__c.getInstance('BigRuleCconfigGroup').TextValue__c;
    }
    
    private static void mapOPDCtoReq(){
        if(lstOpdtcon!= NULL && !lstOpdtcon.isEmpty()){
            for(Opportunity_Product_Detail_Contact__c opProdDtlCntct: lstOpdtcon){
                system.debug('******Inside Online Contact for loop with SAP Online Contact********');
                mapOPDCtoReqContinue(opProdDtlCntct);
            }
        }
        System.debug('@@@@@@@@@@2'+mapProdCodeQuan);
    }
    private static void mapOPDCtoReqContinue(Opportunity_Product_Detail_Contact__c opProdDtlCntct){
        List<ProviewSerializeandDeserialize.cls_onlineContact> smpOnlCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();              
        List<ProviewSerializeandDeserialize.cls_entitlements> smpEntl = new List<ProviewSerializeandDeserialize.cls_entitlements>();
        List<ProviewSerializeandDeserialize.cls_subscriptions> smpSub = new List<ProviewSerializeandDeserialize.cls_subscriptions>();
        List<ProviewSerializeandDeserialize.cls_tokenDetails> smpTok = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
        List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>();
        ProviewSerializeandDeserialize.cls_entitlements smpObjEntl = new ProviewSerializeandDeserialize.cls_entitlements();
        ProviewSerializeandDeserialize.cls_subscriptions smpObjSub = new ProviewSerializeandDeserialize.cls_subscriptions();
        ProviewSerializeandDeserialize.cls_onlineContact smpOn = new ProviewSerializeandDeserialize.cls_onlineContact();
        ProviewSerializeandDeserialize.cls_tokenDetails smpToken= new ProviewSerializeandDeserialize.cls_tokenDetails();

        smpToken.noOfUses = '';
        if(quo.Opportunity.SAP_Account_Number__c != null){
            smpToken.description = quo.QuoteNumber +'_'+ quo.Opportunity.SAP_Account_Number__c;
        }
        else{
            smpToken.description = quo.QuoteNumber;
        }
        smpTok.add(smpToken);

        if((opProdDtlCntct.Email__c != NULL)){
            smpOn.contactId = opProdDtlCntct.Contact__r.SAP_Contact_ID__c;
            smpOn.firstName = opProdDtlCntct.Contact__r.FirstName;
            smpOn.lastName = opProdDtlCntct.Contact__r.LastName;
            smpMtrl = mapOPDCtoReqContinue1(opProdDtlCntct);
        }
        smpOn.email = opProdDtlCntct.Email__c;
        smpOn.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
        //if(smpMtrl != NULL && !smpMtrl.isEmpty()){
        if(checkEmptyList(smpMtrl)){
                smpObjSub.materialNumber.addAll(smpMtrl);
        }
        smpSub.add(smpObjSub);
        //   smpObjEntl.domainId = 'E Reader';
        //if(smpSub!= NULL && !smpSub.isEmpty()){
        if(checkEmptyList(smpSub)){
                smpObjEntl.subscriptions.addAll(smpSub);
        }
        //if(smpTok!= NULL && !smpTok.isEmpty()){
        if(checkEmptyList(smpTok)){
                smpObjEntl.tokenDetails.addAll(smpTok);
        }
        smpEntl.add(smpObjEntl);
        //if(smpEntl!= NULL && !smpEntl.isEmpty()){
        if(checkEmptyList(smpEntl)){
                smpOn.entitlements.addAll(smpEntl);
        }
        smpOnlCnt.add(smpOn);
        //if(smpOnlCnt!= NULL && !smpOnlCnt.isEmpty()){
        if(checkEmptyList(smpOnlCnt)){
                smpReq.onlineContact.addAll(smpOnlCnt);
        }
    }
    
    private static List<ProviewSerializeandDeserialize.cls_materialNumber> mapOPDCtoReqContinue1(Opportunity_Product_Detail_Contact__c opProdDtlCntct){
        List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>();
        Decimal countProdtotal = 0;
        for(String ProdCode : mapPrDtlConPrDtl.get(opProdDtlCntct.Email__c))
        {    

            // [CR]Below logic to reduce one quantity each time from the quantity value of the map, so that we get the left over quantity
            if(mapProdCodeQuan.keySet().contains(ProdCode)){
                //put the logic here to finally have a map(mapProdCodeQuan) ready with prodcode as key and left over quanity of each prod as value. 
                countProdtotal  = mapProdCodeQuan.get(ProdCode) -1;
                mapProdCodeQuan.put(ProdCode,countProdtotal);
                System.debug('@@@@@@@@@@1'+mapProdCodeQuan);
            }
            ProviewSerializeandDeserialize.cls_materialNumber smpMat = new ProviewSerializeandDeserialize.cls_materialNumber();
            smpMat.materialNumber = ProdCode;
            smpMat.configType = quo.Opportunity.PriceBook2.Sales_Org__c;
            smpMat.quantity = '1'; // [CR]
            smpMat.classificationValue = String.valueOf(Integer.valueOf(mapProdCodeQuantity.get(ProdCode)));
            smpMat.description = mapProdCodeDesc.get(ProdCode);
            smpMtrl.add(smpMat);
            System.debug('********2'+smpMtrl);
        }
        return smpMtrl;
    }
    
    private static Boolean checkEmptyList(List<Object> tempList){
        return (tempList!= NULL && !tempList.isEmpty());
    }
    
    private static void mapOLItoReq(){
        // [CR] Option 1 Single Use and Multi use
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token' || quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token'){
            for(OpportunityLineItem oli: lstOLI){                       
                if(mapProdCodeQuan.containskey(oli.ProductCode) && mapProdCodeQuan.get(oli.ProductCode)>0){
                    mapOLItoReqContinue(oli);
                }
            }
        }  
    }
    
    private static void mapOLItoReqContinue(OpportunityLineItem oli){
        List<ProviewSerializeandDeserialize.cls_onlineContact> smpOnlCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();
        ProviewSerializeandDeserialize.cls_onlineContact smpOn = assignSmpOn();//new ProviewSerializeandDeserialize.cls_onlineContact();
        List<ProviewSerializeandDeserialize.cls_entitlements> smpEntl = new List<ProviewSerializeandDeserialize.cls_entitlements>();
        List<ProviewSerializeandDeserialize.cls_subscriptions> smpSub = new List<ProviewSerializeandDeserialize.cls_subscriptions>();
        List<ProviewSerializeandDeserialize.cls_tokenDetails> smpTok = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
        List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = assignSmpMtrl(oli);//new List<ProviewSerializeandDeserialize.cls_materialNumber>();
        ProviewSerializeandDeserialize.cls_entitlements smpObjEntl = new ProviewSerializeandDeserialize.cls_entitlements();
        ProviewSerializeandDeserialize.cls_subscriptions smpObjSub = new ProviewSerializeandDeserialize.cls_subscriptions();            
        ProviewSerializeandDeserialize.cls_tokenDetails smpToken= new ProviewSerializeandDeserialize.cls_tokenDetails();                                            
        smpToken.noOfUses =''; 
        if(quo.Opportunity.SAP_Account_Number__c != null){
            smpToken.description = quo.QuoteNumber +'_'+ quo.Opportunity.SAP_Account_Number__c;
        }
        else{
            smpToken.description = quo.QuoteNumber;
        }
        smpTok.add(smpToken);
    
        if(checkEmptyList(smpMtrl)){
            smpObjSub.materialNumber.addAll(smpMtrl);
        }
    
        //ProviewSerializeandDeserialize.cls_properties smpProp = assignSmpProp();
        //smpPrty.add(smpProp);
        
        smpSub.add(smpObjSub);
        if(checkEmptyList(smpSub)){
            smpObjEntl.subscriptions.addAll(smpSub);
        }
        if(checkEmptyList(smpTok)){
            smpObjEntl.tokenDetails.addAll(smpTok);
        }
        smpEntl.add(smpObjEntl);
        if(checkEmptyList(smpEntl)){
            smpOn.entitlements.addAll(smpEntl);
        } 
    
        smpOnlCnt.add(smpOn);                           
        if(checkEmptyList(smpOnlCnt)){
            smpReq.onlineContact.addAll(smpOnlCnt);
        }                         
    }

    private static ProviewSerializeandDeserialize.cls_onlineContact assignSmpOn(){
        List<ProviewSerializeandDeserialize.cls_properties> smpPrty = assignSmpPrty();//new List<ProviewSerializeandDeserialize.cls_properties>();
        List<ProviewSerializeandDeserialize.cls_property> smpPrty1 = assignSmpPrty1();//new List<ProviewSerializeandDeserialize.cls_property>();                          
        ProviewSerializeandDeserialize.cls_onlineContact smpOn = new ProviewSerializeandDeserialize.cls_onlineContact();
        smpOn.contactId = null;
        smpOn.firstName = null;
        smpOn.lastName = null;
        smpOn.email = null;
        smpOn.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;
        if(checkEmptyList(smpPrty)){
            smpOn.properties.addAll(smpPrty);
        }
        
        if(checkEmptyList(smpPrty1)){
            smpOn.property.addAll(smpPrty1);
        }
        return smpOn;
    }

    private static List<ProviewSerializeandDeserialize.cls_materialNumber> assignSmpMtrl(OpportunityLineItem oli){
        List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>();
        ProviewSerializeandDeserialize.cls_materialNumber smpMat = new ProviewSerializeandDeserialize.cls_materialNumber();
        smpMat.materialNumber = oli.ProductCode;
        smpMat.configType = quo.Opportunity.PriceBook2.Sales_Org__c; 
        smpMat.description = oli.Product2.name;
        smpMat.classificationValue = String.valueOf(Integer.valueof(oli.Quantity));
        Integer i = Integer.valueof(mapProdCodeQuan.get(oli.ProductCode));
        smpMat.quantity = String.valueOf(i); 
        system.debug('******smpMat Material---->'+smpMat);
        smpMtrl.add(smpMat);                     
        return smpMtrl;
    }

    private static List<ProviewSerializeandDeserialize.cls_properties> assignSmpPrty(){
        List<ProviewSerializeandDeserialize.cls_properties> smpPrty = new List<ProviewSerializeandDeserialize.cls_properties>();
        ProviewSerializeandDeserialize.cls_properties smpProp = new ProviewSerializeandDeserialize.cls_properties();
        smpProp.key = 'SingleUseToken';
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token'){
            smpProp.value = 'true';  
        }   
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token'){
            smpProp.value = 'false';
        } 
        smpPrty.add(smpProp); 
        return smpPrty;              
    }

    private static List<ProviewSerializeandDeserialize.cls_property> assignSmpPrty1(){
        List<ProviewSerializeandDeserialize.cls_property> smpPrty1 = new List<ProviewSerializeandDeserialize.cls_property>();                          
        ProviewSerializeandDeserialize.cls_property smpProp1 = new ProviewSerializeandDeserialize.cls_property();
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token'){
            smpProp1.key = 'SingleUseToken';
            smpProp1.value = 'true';  
        }   
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token'){
            smpProp1.key = 'MultiUseToken';
            smpProp1.value = 'true';
        } 
        smpPrty1.add(smpProp1);     
        return smpPrty1;             
    }
    
    private static void mapOLItoReqConsolidated(){
        // [CR] Option 2 Single Use Consolidated & Multi Use Consolidated
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated' || quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated'){
            if(!lstOLIcons.isEmpty() && mapProdCodeQuan.containskey(lstOLIcons[0].ProductCode) && mapProdCodeQuan.get(lstOLIcons[0].ProductCode)>0){
                mapOLItoReqConsolidatedContinue();
            }
        }
    }

    private static void mapOLItoReqConsolidatedContinue(){
        List<ProviewSerializeandDeserialize.cls_onlineContact> smpOnlCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();
        ProviewSerializeandDeserialize.cls_onlineContact smpOn = assignSmpOn();//new ProviewSerializeandDeserialize.cls_onlineContact();
        List<ProviewSerializeandDeserialize.cls_entitlements> smpEntl = new List<ProviewSerializeandDeserialize.cls_entitlements>();
        List<ProviewSerializeandDeserialize.cls_subscriptions> smpSub = new List<ProviewSerializeandDeserialize.cls_subscriptions>();
        List<ProviewSerializeandDeserialize.cls_tokenDetails> smpTok = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
        List<ProviewSerializeandDeserialize.cls_materialNumber> smpMtrl = new List<ProviewSerializeandDeserialize.cls_materialNumber>(); 
        //List<ProviewSerializeandDeserialize.cls_properties> smpPrty = new List<ProviewSerializeandDeserialize.cls_properties>();           
        //List<ProviewSerializeandDeserialize.cls_property> smpPrty1 = new List<ProviewSerializeandDeserialize.cls_property>();                         
        
        ProviewSerializeandDeserialize.cls_entitlements smpObjEntl = new ProviewSerializeandDeserialize.cls_entitlements();
        ProviewSerializeandDeserialize.cls_subscriptions smpObjSub = new ProviewSerializeandDeserialize.cls_subscriptions();            
        ProviewSerializeandDeserialize.cls_tokenDetails smpToken= new ProviewSerializeandDeserialize.cls_tokenDetails();                                            
        /*smpOn.contactId = null;
        smpOn.firstName = null;
        smpOn.lastName = null;
        smpOn.email = null;
        smpOn.account.accountNumber = quo.Opportunity.Account.SAPAccountNumber__c;*/
        smpToken.noOfUses =''; 
        if(quo.Opportunity.SAP_Account_Number__c != null){
            smpToken.description = quo.QuoteNumber +'_'+ quo.Opportunity.SAP_Account_Number__c;
        }
        else{
            smpToken.description = quo.QuoteNumber;
        }
        smpTok.add(smpToken);
        for(OpportunityLineItem oli: lstOLIcons){
            ProviewSerializeandDeserialize.cls_materialNumber smpMat = new ProviewSerializeandDeserialize.cls_materialNumber();                    
            smpMat.materialNumber = oli.ProductCode;
            smpMat.configType = quo.Opportunity.PriceBook2.Sales_Org__c; 
            smpMat.description = oli.Product2.name;
            smpMat.classificationValue = String.valueOf(Integer.valueof(oli.Quantity));
            Integer i = Integer.valueof(mapProdCodeQuan.get(oli.ProductCode));
            smpMat.quantity = String.valueOf(i);  
            //system.debug('******smpMat Material---->'+smpMat);
            smpMtrl.add(smpMat);
        }  
        if(checkEmptyList(smpMtrl)){
            smpObjSub.materialNumber.addAll(smpMtrl);
        }
        /*ProviewSerializeandDeserialize.cls_properties smpProp = new ProviewSerializeandDeserialize.cls_properties();
        smpProp.key = 'SingleUseToken';
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated'){
            smpProp.value = 'true'; 
        }
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated'){  
            smpProp.value = 'false'; 
        }                       
        smpPrty.add(smpProp);
        
        if(checkEmptyList(smpPrty)){
            smpOn.properties.addAll(smpPrty);
        }
        
        ProviewSerializeandDeserialize.cls_property smpProp1 = new ProviewSerializeandDeserialize.cls_property();
        
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Single Use Token Consolidated'){
            smpProp1.key = 'SingleUseToken';
            smpProp1.value = 'false'; 
        }
        if(quo.Create_Token_for_Unused_Product_Quantity__c == 'Multi Use Token Consolidated'){
            smpProp1.key = 'MultiUseToken';
            smpProp1.value = 'false'; 
        }                       
        smpPrty1.add(smpProp1);
        
        if(checkEmptyList(smpPrty1)){
            smpOn.property.addAll(smpPrty1);
        }
        */
        smpSub.add(smpObjSub);
        if(checkEmptyList(smpSub)){
            smpObjEntl.subscriptions.addAll(smpSub);
        }
        if(checkEmptyList(smpTok)){
            smpObjEntl.tokenDetails.addAll(smpTok);
        }
        smpEntl.add(smpObjEntl);
        if(checkEmptyList(smpEntl)){
            smpOn.entitlements.addAll(smpEntl);
        }   
        smpOnlCnt.add(smpOn);  
        if(checkEmptyList(smpOnlCnt)){
            smpReq.onlineContact.addAll(smpOnlCnt);
        } 
    }
    
    private static void sendRequestToESI(){
        // get the Callout parameters from Custom Setting
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('ProviewManageEntitlement'); 
        // Serializing the request,and putting it in setBody.
        String strBody = JSON.serialize(smpReq);
        system.debug('strBody...'+strBody);
        HttpResponse resp = new HttpResponse();
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('POST');
        //req.setEndpoint(oWebServiceSettings.Endpoint__c);
        //blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
        //String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
        //req.setHeader('Authorization', authorizationHeader);     
        req.setEndpoint('Callout:ProviewManageEntitlement'); //PMD changes to avoid violation       
        req.setHeader('Content-Type',  'application/json');             
        req.setBody(strBody);
        req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
        system.debug('test req : '+req);
        system.debug('test req : '+strBody);
        // Receiving the JSON response
        if(!Test.isRunningtest()){
            resp = http.send(req);
        }
        else{
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody('{"onlineContact" : [ {"firstName" : "HARMAN","lastName" : "CHAURASIA","email" : "rajashree.behera@thomsonreuters.com","sourceId" : "SF06","account" : {"companyId" : "LLEY" },"entitlements" : [ {"tokenDetails" : [ {"tokenNumber" : "dMwIMe6qzvewpFtt","description" : "SF974704_1005004610","url" : "http://redemptionservice.com/redeem/dMwIMe6qzvewpFtt"} ],"subscriptions" : [ {"materialNumber" : [ {"materialNumber" :"000000000042044448"} ]} ] } ],"Notification" : {"statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}}, { "contactId" : "0016079445","firstName" : "PV","lastName" : "test","email" : "saumya.ranjan@thomsonreuters.com","sourceId" : "SF06","account" : {"companyId" : "LLEY"},"entitlements" : [ {"tokenDetails" : [ {"tokenNumber" : "m7sPOpE9UVxqGLkA","description" : "SF974704_1005004610","url" : "http://redemptionservice.com/redeem/m7sPOpE9UVxqGLkA"} ],"subscriptions" : [{"materialNumber" : [ {"materialNumber" : "000000000042044448"} ]} ]} ],"Notification" : {"statusCode" : "\'Success\'","statusDescription" : "\'Token Created\'"}} ],"Notification" : {"statusCode" : "Success","statusDescription" : "Token has been created OR Resources has been added successfully"}}');        
            resp.setStatusCode(200); 
        }
        sendRequestToESIContinue(resp);
    }

    private static void sendRequestToESIContinue(HttpResponse resp){
        String strRes = resp.getBody();
        system.debug('strRes..'+strRes);
        system.debug('strRes..'+resp.getStatusCode());

        ProviewSerializeandDeserialize.ProviewResponse smpRes = new ProviewSerializeandDeserialize.ProviewResponse();
        //List<ProviewSerializeandDeserialize.cls_onlineContact> smpRes1 = new List<ProviewSerializeandDeserialize.cls_onlineContact>();
        
        if(resp.getBody().contains('"Notification"')){
            // Deserializing the JSON response
            smpRes = (ProviewSerializeandDeserialize.ProviewResponse)JSON.deserialize(resp.getbody(),ProviewSerializeandDeserialize.ProviewResponse.class);
        }
        System.debug('@@@@@@@@'+smpRes );
        integer i= 1;
        // if(smpRes.Notification.statusCode == 'SUCCESS') {
        if(resp.getStatusCode() == 200 && strRes.contains('Notification') ){
            processStatus200(resp, smpRes);
        }
        else{
            System.debug('Error occured while fetching the token from ESI');
            quo.Entitlement_Status__c= 'Failure';
            quo.Entitlement_Complete__c= false;
            quo.Entitlement_Generated__c = true;
            quo.Entitlement_Status_Description__c = 'Error occured while fetching the token from ESI'; 
            if(Quote.SObjectType.getDescribe().isUpdateable() && quo != null){
                UPDATE quo;
            }
        } 
    }
    
    private static void processStatus200(HttpResponse resp, ProviewSerializeandDeserialize.ProviewResponse smpRes){
        // Capturing the response in some fields and notes in Quote
        if(smpRes.Notification != null){
            processSmpResNotificationNotNull(smpRes);
        }
        else{
            quo.Entitlement_Status_Description__c = '';
            quo.Entitlement_Status__c = '';
        }
        System.debug('success');
        quo.Entitlement_Generated__c = true;
        if(Quote.SObjectType.getDescribe().isUpdateable()){
            update quo;
        }
        List<ProviewSerializeandDeserialize.cls_onlineContact>  olnCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>();       
        if(smpRes.onlineContact!= NULL && !smpRes.onlineContact.isEmpty()){
            olnCnt.addAll(smpRes.onlineContact);
        }
        System.debug('@@@@@@@@olnCnt'+smpRes.onlineContact);
        System.debug('@@@@@@@@olnCnt 2 '+olnCnt);
        if(olnCnt != null && !olnCnt.isEmpty()){
            processStatus200Continue(resp, smpRes, olnCnt);
        }
    }

    private static void processStatus200Continue(HttpResponse resp, ProviewSerializeandDeserialize.ProviewResponse smpRes, List<ProviewSerializeandDeserialize.cls_onlineContact>  olnCnt){
        //Note objNote;
        //Attachment objAtchmt;
        for(ProviewSerializeandDeserialize.cls_onlineContact olCnt : olnCnt){
            String body =''; 
            String name =''; 
            List<ProviewSerializeandDeserialize.cls_entitlements> entlmnt = new List<ProviewSerializeandDeserialize.cls_entitlements>();
            List<ProviewSerializeandDeserialize.cls_subscriptions> subsc= new List<ProviewSerializeandDeserialize.cls_subscriptions>();
            List<ProviewSerializeandDeserialize.cls_materialNumber> mats= new List<ProviewSerializeandDeserialize.cls_materialNumber>();
            List<ProviewSerializeandDeserialize.cls_tokenDetails> token = new List<ProviewSerializeandDeserialize.cls_tokenDetails>();
            Map<String, String> tempMap = processBodyName(olCnt,new Map<String, String>{'body'=>body, 'name'=>name});
            body = tempMap.get('body');
            name = tempMap.get('name');

            if(olCnt.entitlements != NULL && !olCnt.entitlements.isEmpty()){
                entlmnt.addAll(olCnt.entitlements);
                if(entlmnt != null && !entlmnt.isEmpty()){
                    for(ProviewSerializeandDeserialize.cls_entitlements etl :entlmnt ){
                        /*if(etl.subscriptions!= null && !etl.subscriptions.isEmpty()){
                            subsc.addAll(etl.subscriptions); 
                        }
                        if(etl.tokenDetails!= null && !etl.tokenDetails.isEmpty()){
                            token.addAll(etl.tokenDetails);
                        } */
                        subsc = addSubsc(etl, subsc);
                        token = addToken(etl, token);
                    }
                    body = processBodybyTokens(token, body);
                    
                }
                
                mats = processMatsBySubsc(subsc, mats);
                body = processBodybyMats(mats, body);
            }
            body = body+ '\n\n';
            populateContentNote(name, body);
            populateopdcnames(olCnt, name, mats);
        }
        finalSaveUpdate(cNoteList, cdlList);
    }

    private static List<ProviewSerializeandDeserialize.cls_subscriptions> addSubsc(ProviewSerializeandDeserialize.cls_entitlements etl, List<ProviewSerializeandDeserialize.cls_subscriptions> subsc){
        if(etl.subscriptions!= null && !etl.subscriptions.isEmpty()){
            subsc.addAll(etl.subscriptions); 
        }
        return subsc;
    }
    
    private static List<ProviewSerializeandDeserialize.cls_tokenDetails> addToken(ProviewSerializeandDeserialize.cls_entitlements etl, List<ProviewSerializeandDeserialize.cls_tokenDetails> token){
        if(etl.tokenDetails!= null && !etl.tokenDetails.isEmpty()){
            token.addAll(etl.tokenDetails);
        } 
        return token;
    }

    private static Map<String, String> processBodyName(ProviewSerializeandDeserialize.cls_onlineContact olCnt, Map<String, String> tempMap){
        String body = tempMap.get('body');
        String name = tempMap.get('name');
        if(olCnt.firstName != null || olCnt.lastName!= null || olCnt.firstName != '' || olCnt.lastName!= ''){
            body = '###### Online Contact ####: \n';
            body = body +'\nName : ' + olCnt.firstName+' '+olCnt.lastName;
            name = olCnt.firstName+' '+olCnt.lastName;
        }
        else{
            body = '###### Online Contact Name ####: \n'+ '';
        }
        System.debug('@@@@@@@@@@@@@body1 '+body );
        if(olCnt.Notification != null ){
            body = processBodyNameContinue(olCnt, body);
        }
        body = body+ '\n\n';
        System.debug('@@@@@@@@@@@@@body2 '+body );
        tempMap.put('body',body);
        tempMap.put('name',name);
        return tempMap;
    }

    private static String processBodyNameContinue(ProviewSerializeandDeserialize.cls_onlineContact olCnt, String body){
        if(olCnt.Notification.statusCode != null && olCnt.Notification.statusCode != ''){
            body = body+ '\nOnline Contact Status : '+ olCnt.Notification.statusCode;
        }
        else{
            body = body+ '\nOnline Status : '+ '';
        }
        if(olCnt.Notification.statusDescription != null && olCnt.Notification.statusDescription != ''){
            body= body+ '\nOnline Contact Status Description : '+olCnt.Notification.statusDescription;
        }
        else{
            body= body+ '\nOnline Status Description : '+ '';
        }
        return body;
    }

    private static List<ProviewSerializeandDeserialize.cls_materialNumber> processMatsBySubsc(List<ProviewSerializeandDeserialize.cls_subscriptions> subsc, List<ProviewSerializeandDeserialize.cls_materialNumber> mats){
        if(subsc!= null && !subsc.isEmpty()){
            for(ProviewSerializeandDeserialize.cls_subscriptions sbs :subsc){
                if(sbs.materialNumber!= null && !sbs.materialNumber.isEmpty()){
                    mats.addAll(sbs.materialNumber);   
                }
            }
        }
        return mats;
    }

    private static String processBodybyMats(List<ProviewSerializeandDeserialize.cls_materialNumber> mats, String body){
        body = body + '###### Materials Information ####: \n';
        if(mats!= null && !mats.isEmpty()){
            for(ProviewSerializeandDeserialize.cls_materialNumber mtrls :mats){
                if( mtrls.materialNumber != null &&  mtrls.materialNumber != '' ){
                body= body + '\nMaterial Numbers : ' + mtrls.materialNumber ;
                } 
            } 
        }
        return body;
    }

    private static String processBodybyTokens(List<ProviewSerializeandDeserialize.cls_tokenDetails> token, String body){
        System.debug('@@@@@@@@@@@@@body3 '+body );
        if(token!= null && !token.isEmpty()){
            body = body + '###### Token Information ####: \n';
            for(ProviewSerializeandDeserialize.cls_tokenDetails tokn: token){
                if(tokn.tokenNumber != null && tokn.tokenNumber != '' ){
                    body = body + '\nToken Number : ' + tokn.tokenNumber ;
                }
                else{
                    body = body + '\nToken Number : ' + '' ;
                }
                if(tokn.url!= null && tokn.url!= ''){
                    body = body+ '\n' + 'Token URL : ' + tokn.url;
                }
                else{
                    body = body+ '\n' + 'Token URL: ' + '' ;
                }
            }
        }
        body = body+ '\n\n';
        return body;
    }
    
    private static void populateContentNote(String name, String body){
        ContentNote cNote = new ContentNote();
        cNote.Title = String.valueOf(name +'_Info');
        System.debug('populateContentNote body : '+body);
        if (body.contains('\n'))
        {
            body = '<p>' + body.escapeHTML4().replaceAll('\n','</p><p>') + '</p>';
        }
        System.debug('populateContentNote body : '+body);
        //cNote.Content = Blob.valueOf(body.escapeHTML4());
        cNote.Content = Blob.valueOf(body);
        cNoteList.add(cNote);  
    }

    private static void populateopdcnames(ProviewSerializeandDeserialize.cls_onlineContact olCnt, String name, List<ProviewSerializeandDeserialize.cls_materialNumber> mats){
        if((olCnt.firstName !='' || olCnt.firstName != null) && ((olCnt.Notification.statusCode =='Success') || (olCnt.Notification.statusCode =='\'Success\''))){
            opdcnames.add(name);                      
        }
        System.debug('OPDC'+opdcnames);
        populateMats1(olCnt, mats);
    }
    
    private static void populateMats1(ProviewSerializeandDeserialize.cls_onlineContact olCnt, List<ProviewSerializeandDeserialize.cls_materialNumber> mats){
        //update lstOppProdDtlCntct;
        if((olCnt.firstName=='' || olCnt.firstName == null) && ((olCnt.Notification.statusCode =='Success') || (olCnt.Notification.statusCode =='\'Success\''))){
            for(ProviewSerializeandDeserialize.cls_materialNumber mtrls :mats){
                if( mtrls.materialNumber != null &&  mtrls.materialNumber != '' ){ 
                mats1.add(mtrls.materialNumber);
                }
            }                  
        }
    }

    private static void finalSaveUpdate(List<ContentNote> cNoteList, List<ContentDocumentLink> cdlList){
        System.debug('cNoteList : '+cNoteList);
        if(ContentNote.SObjectType.getDescribe().isCreateable() && cNoteList.size()>0){
            insert cNoteList;
            for(ContentNote cNote : cNoteList){
                ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId=cNote.Id, LinkedEntityId=quo.Id, ShareType='V', Visibility='AllUsers');
                cdlList.add(cdl);
            }
        }
        System.debug('cdlList : '+cdlList);
        if(ContentDocumentLink.SObjectType.getDescribe().isCreateable() && cdlList.size()>0){
            insert cdlList;
        }
        for(Opportunity_Product_Detail_Contact__c opdc : lstOppProdDtlCntct){
            if(opdcnames.contains(opdc.Contact__r.Name)){
                opdc.Token_Created__c = true;
                //update opdc;
            }
        }
        if(Opportunity_Product_Detail_Contact__c.SObjectType.getDescribe().isUpdateable()){
            update lstOppProdDtlCntct;
        }
        System.debug('lstOLIcons@'+lstOLIcons);
        finalSaveUpdateContinue();
    }

    private static void finalSaveUpdateContinue(){
        for(OpportunityLineItem oli: lstOLIcons){
            if(mats1.contains(oli.ProductCode)){
                oli.Unassigned_Tokens_Generated__c = true;
            }
            //update oli;          
        }
        if(OpportunityLineItem.SObjectType.getDescribe().isUpdateable()){
            update lstOLIcons;
        }
    }

    private static void processSmpResNotificationNotNull(ProviewSerializeandDeserialize.ProviewResponse smpRes){
        if(smpRes.Notification.statusDescription != null || smpRes.Notification.statusDescription != ''){
            quo.Entitlement_Status_Description__c = smpRes.Notification.statusDescription;
        }
        else{
            quo.Entitlement_Status_Description__c = '';
        }
        if(smpRes.Notification.statusCode != null || smpRes.Notification.statusCode != ''){
            processSmpResNotificationNotNullContinue(smpRes);
        }
        else{
            quo.Entitlement_Status__c = 'Failure';
            quo.Entitlement_Complete__c= false;
        }
    }

    private static void processSmpResNotificationNotNullContinue(ProviewSerializeandDeserialize.ProviewResponse smpRes){
        if(smpRes.Notification.statusCode == 'Failed' || smpRes.Notification.statusCode == 'FAILED' || smpRes.Notification.statusCode == 'failed'){
            quo.Entitlement_Status__c = 'Failure';
            quo.Entitlement_Complete__c= false;
        }
        else if(smpRes.Notification.statusCode == 'Partial Failed' || smpRes.Notification.statusCode == 'PARTIAL FAILED' ){
            quo.Entitlement_Status__c = 'Partial Failure';
            quo.Entitlement_Complete__c= false;
        }
        else{
            quo.Entitlement_Status__c = smpRes.Notification.statusCode;
            quo.Entitlement_Complete__c= true;
        }
    }
}