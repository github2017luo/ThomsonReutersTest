@RestResource(urlMapping='/proviewpostback/*')
global class proviewPostback{

   @HttpPost
    global static string doPost(){   
        String quotenumber1='';
        List<Quote> quo = new List<Quote>();
        Set<id> setOppProdId = new Set<id>();
        Set<String> mats1 = new Set<String>();
        Set<String> opdcnames = new Set<String>();
        Map<String,List<String>> mapPrDtlConPrDtl = new Map<String,List<String>>();
        Map<String,Decimal> mapProdCodeQuan = new Map<String,Decimal>();//[CR]
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
        List<Opportunity_Product_Detail_Contact__c> lstOpdtcon = new List<Opportunity_Product_Detail_Contact__c>();
        List<Opportunity_Product_Detail_Contact__c> lstOppProdDtlCntct = new List<Opportunity_Product_Detail_Contact__c>();
        List<Opportunity_Product_Detail_Contact__c> lstOpdcNoToken = new List<Opportunity_Product_Detail_Contact__c>();
        List<OpportunityProductDetail__c > lstOppProdDtl = new List<OpportunityProductDetail__c >();
        List<OpportunityLineItem> lstOLIcons = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstOLINoTokenUnassigned = new List<OpportunityLineItem>();
        System.debug('quotenumber1'+quotenumber1);
        String requestBody = RestContext.request.requestBody.toString();
        System.debug('@@@@@@@@11'+requestbody );
        ProviewSerializeandDeserialize.ProviewResponse smpRes = new ProviewSerializeandDeserialize.ProviewResponse();
        smpRes = (ProviewSerializeandDeserialize.ProviewResponse)JSON.deserialize(requestBody,ProviewSerializeandDeserialize.ProviewResponse.class);
        System.debug('@@@@@@@@'+smpRes );
        List<ProviewSerializeandDeserialize.cls_onlineContact>  olnCnt = new List<ProviewSerializeandDeserialize.cls_onlineContact>(); 
        if(requestBody.contains('Notification') ){

                 // Capturing the response in some fields and notes in Quote                   
                    if(smpRes.onlineContact!= NULL && !smpRes.onlineContact.isEmpty()){
                        olnCnt.addAll(smpRes.onlineContact);
                    }
                    System.debug('@@@@@@@@olnCnt'+smpRes.onlineContact);
                    System.debug('@@@@@@@@olnCnt 2 '+olnCnt);
                    if(olnCnt != null && !olnCnt.isEmpty()){
                        //Note objNote;
                        List<Note> noteList = new List<Note>();
                        List<Attachment> attachList = new List<Attachment>();
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
                                            if(tokn.description!= null && tokn.description!= ''){
                                                quotenumber1 = tokn.description.SubStringBefore('_');
                                                System.debug('%%%quo'+quotenumber1);
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
                            System.debug('@@@@@@@@@@@@@body 4 '+body );
                            if(body.length()<32000){                            
                            Note objNote = new Note();
                            System.debug('@@@@@@@@@@@@@body 5'+body);
                            objNote.Body = body;
                            objNote.Title = String.valueOf(name +'_Info');
                            //objNote.ParentId = quo.Id;
                            if(objNote != null){
                            System.debug('$$$$$$$$$$$$'+objNote);
                            noteList.add(objNote);
                            //INSERT objNote;
                            }
                            }
                            else{
                                Attachment objAtchmt = new Attachment();
                                objAtchmt.Body = Blob.valueOf(body);
                                objAtchmt.Name = String.valueOf(name +'_Info.txt');
                                //objAtchmt.ParentId = quo.Id; 
                                if(objAtchmt != null){
                                attachList.add(objAtchmt);
                                }
                            }
                            if(subsc!= null && !subsc.isEmpty()){
                                    for(ProviewSerializeandDeserialize.cls_subscriptions sbs :subsc){
                                        if(sbs.materialNumber!= null && !sbs.materialNumber.isEmpty()){
                                            mats.addAll(sbs.materialNumber);   
                                        }
                                    }
                                }
                            if((olCnt.firstName !='' || olCnt.firstName != null) && ((olCnt.Notification.statusCode =='Success') || (olCnt.Notification.statusCode =='\'Success\''))){
                                opdcnames.add(name);
                            }
                            if((olCnt.firstName=='' || olCnt.firstName == null) && ((olCnt.Notification.statusCode =='Success') || (olCnt.Notification.statusCode =='\'Success\''))){
                                    for(ProviewSerializeandDeserialize.cls_materialNumber mtrls :mats){
                                        System.debug('$$$$$$$2');
                                    if( mtrls.materialNumber != null &&  mtrls.materialNumber != '' ){ 
                                    mats1.add(mtrls.materialNumber);
                                    }
                                    }    
                            }
                        }
         quo = [SELECT id,QuoteNumber,OpportunityId,Opportunity.id,Opportunity.Account.SAPAccountNumber__c,Opportunity.PriceBook2.Sales_Org__c,Create_Token_for_Unused_Product_Quantity__c FROM Quote WHERE QuoteNumber =: quotenumber1];
        
        if(quo.size()>0){
        if(noteList!= null && !noteList.isEmpty()){
        for(Note note1: noteList){
            note1.ParentId = quo[0].Id;
        }
        Insert noteList;
        }
        if(attachList!= null && !attachList.isEmpty()){
            for(Attachment att: attachList){
            att.ParentId = quo[0].Id;
            }
            Insert attachList;
        }
        // Querying the OpportunityProductDetails having one shot products.
        lstOLI =[SELECT id, Product2.name, ProductCode,OpportunityId,Quantity,Unassigned_Tokens_Generated__c FROM OpportunityLineItem WHERE OpportunityId =: quo[0].Opportunity.Id AND Product2.Entitlement_Oneshot__c = true];
        
        for(OpportunityLineItem oli: lstOLI ){                  
            mapProdCodeQuan.put(oli.ProductCode,oli.Quantity); 
        }
        lstOppProdDtl = [SELECT id,Product__r.ProductCode FROM OpportunityProductDetail__c WHERE Opportunity__r.id =: quo[0].Opportunity.Id AND Product__r.Entitlement_Oneshot__c = true]; 
        
        if(lstOppProdDtl!= NULL && !lstOppProdDtl.isEmpty()){
                        for(OpportunityProductDetail__c oppProDtl : lstOppProdDtl){
                        setOppProdId.add(oppProDtl.id);    
                        }
                        if(!setOppProdId.isEmpty()){
                        lstOppProdDtlCntct =[SELECT id,Contact__r.Name,Token_Created__c,Contact__r.SAP_Contact_ID__c,Contact__r.FirstName,Contact__r.LastName ,Email__c,Product_Detail__c, Product_Detail__r.Product__r.ProductCode  FROM Opportunity_Product_Detail_Contact__c WHERE Product_Detail__c IN : setOppProdId];
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
        
        }
                        
        if(lstOpdtcon!= NULL && !lstOpdtcon.isEmpty()){
                    for(Opportunity_Product_Detail_Contact__c opProdDtlCntct: lstOpdtcon){
                            if((opProdDtlCntct.Email__c != NULL)){
                                Decimal countProdtotal = 0;
                            for(String ProdCode : mapPrDtlConPrDtl.get(opProdDtlCntct.Email__c)){
                                if(mapProdCodeQuan.keySet().contains(ProdCode)){
                                 //put the logic here to finally have a map(mapProdCodeQuan) ready with prodcode as key and left over quanity of each prod as value. 
                                  countProdtotal  = mapProdCodeQuan.get(ProdCode) -1;
                                  mapProdCodeQuan.put(ProdCode,countProdtotal);
                                  System.debug('@@@@@@@@@@1'+mapProdCodeQuan);
                                 }
                            } 
                        }
                    }
        }
        
                        if(!lstOLI.isEmpty()){
                            for(OpportunityLineItem oli: lstOLI ){  
                                if(mapProdCodeQuan.containskey(oli.ProductCode) && mapProdCodeQuan.get(oli.ProductCode)>0){
                                lstOLIcons.add(oli);
                                }
                            }
                        }
                        for(OpportunityLineItem oli: lstOLIcons){
                                    if(mats1.contains(oli.ProductCode)){
                                        oli.Unassigned_Tokens_Generated__c = true;
                                    }
                                    
                        }  
                        update lstOLIcons;           
                        for(Opportunity_Product_Detail_Contact__c opdc : lstOppProdDtlCntct){
                                if(opdcnames.contains(opdc.Contact__r.Name)){
                                opdc.Token_Created__c = true;
                                }
                        }
                        update lstOppProdDtlCntct;
                    }
        }
                
                for(Opportunity_Product_Detail_Contact__c opdc : lstOppProdDtlCntct){
                    if(opdc.Token_Created__c == false){
                        lstOpdcNoToken.add(opdc);
                    }
                }
                System.debug('lstolicons'+lstOLIcons);
                for(OpportunityLineItem oli: lstOLIcons){
                    if(oli.Unassigned_Tokens_Generated__c == false){
                        lstOLINoTokenUnassigned.add(oli);
                    }
                }
                System.debug('sizecheck'+lstOpdcNoToken.size()+lstOLINoTokenUnassigned.size()+quo[0].Create_Token_for_Unused_Product_Quantity__c);
    if((lstOpdcNoToken.size()==0 && quo.size()>0 && quo[0].Create_Token_for_Unused_Product_Quantity__c == null) || 
    (lstOpdcNoToken.size()==0 && lstOLINoTokenUnassigned.size()==0 && quo.size()>0 && quo[0].Create_Token_for_Unused_Product_Quantity__c != null)){
                quo[0].Entitlement_Status__c = 'Success';
                quo[0].Entitlement_Status_Description__c = 'Token has been created OR Resources has been added successfully';
                quo[0].Entitlement_Complete__c= true;
                if(quo[0] != null){
                        UPDATE quo[0];
                    }
                }
                
        }
        return 'success';
    }   
    }