public without sharing class ESC_IntegrationUtil{
    public static List<ESC_Case_Form_Extension_Line_Item__c> formExtLineItemLst ;
    public static List<ESC_Case_Form_Extension__c> caseFormExtLst;
    public static void createDellBoomiRequest(Set<Id> caseFormExtList,boolean isCC){
    
        try{
            
           if (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){
               caseFormExtLst= [SELECT Id,ESC_Case__c,ESC_Form__c,ESC_Form__r.name,ESC_Case__r.USL_SAP_Account_Number__c,ESC_Case__r.LCRM_Sub_Bu__c,ESC_Case__r.BU_Segment__c,USL_Is_Processed__c,USL_CSSWriteOffFormTypeID__c,(
                                                               SELECT CurrencyIsoCode,ESC_Billing_Doc__c,USL_Input_Amount__c,ESC_Reason_Code__c,ESC_Item_Amount__c,ESC_Tax_Amount__c ,ESC_Net_Amount__c ,ESC_Line__c,USL_ODocType__c  from Case_Form_Extension_Line_Items__r)
                                                               FROM ESC_Case_Form_Extension__c 
                                                               Where id in:caseFormExtList and (ESC_form__r.name='Write Off Form' OR ESC_form__r.name='Write Off Exception Form' OR ESC_form__r.name='Charge Cancellation') ];
           }
             
           if(caseFormExtLst!=null && caseFormExtLst.size() > 0)  {
                USL_Integration_defaults__c intVal = new USL_Integration_defaults__c();
                if(caseFormExtLst[0].ESC_Case__r.BU_Segment__c!=null && caseFormExtLst[0].ESC_Case__r.LCRM_Sub_Bu__c!=null){
                    intVal = USLARHelper.getIntegrationDefaults(caseFormExtLst[0].ESC_Case__r.BU_Segment__c,caseFormExtLst[0].ESC_Case__r.LCRM_Sub_Bu__c);
                }
                
                    ESC_CaseFormExtensionRequestWrapper req= new ESC_CaseFormExtensionRequestWrapper();
                    ESC_CaseFormExtensionRequestWrapper.BOOMIHeader bHeader = new ESC_CaseFormExtensionRequestWrapper.BOOMIHeader();
                    bHeader.applicationId = intVal.Applicationid__c;
                    bHeader.companyId = intval.Companyid__c;
                    req.BOOMIHeader = bHeader;
                    List<ESC_CaseFormExtensionRequestWrapper.documentDetails> docDetailList = new List<ESC_CaseFormExtensionRequestWrapper.documentDetails>();
                    ESC_CaseFormExtensionRequestWrapper.InvoiceDetail invoiceDetail = new ESC_CaseFormExtensionRequestWrapper.InvoiceDetail();
                    invoiceDetail.writeOffreason = caseFormExtLst[0].USL_CSSWriteOffFormTypeID__c;
                    ESC_CaseFormExtensionRequestWrapper.account acc = new ESC_CaseFormExtensionRequestWrapper.account();
                    acc.accountNumber = caseFormExtLst[0].ESC_Case__r.USL_SAP_Account_Number__c;
                    if(caseFormExtLst[0].Case_Form_Extension_Line_Items__r!=null && caseFormExtLst[0].Case_Form_Extension_Line_Items__r.size() >0){
                    formExtLineItemLst = new List<ESC_Case_Form_Extension_Line_Item__c>();
                        for(ESC_Case_Form_Extension_Line_Item__c formExtLineItem:caseFormExtLst[0].Case_Form_Extension_Line_Items__r){
                            formExtLineItemLst.add(formExtLineItem);
                            ESC_CaseFormExtensionRequestWrapper.documentDetails docDetails = new ESC_CaseFormExtensionRequestWrapper.documentDetails();
                            docDetails.documentNumber = formExtLineItem.ESC_Billing_Doc__c;
                            docDetails.writeOffreason = '';
                            docDetails.lineNumber = formExtLineItem.ESC_Line__c;
                            if(isCC){
                                docDetails.amount = string.valueOf(formExtLineItem.ESC_Net_Amount__c);
                                docDetails.taxAmount = string.valueOf(formExtLineItem.ESC_Tax_Amount__c);
                                docDetails.documentType = formExtLineItem.USL_ODocType__c ;
                                docDetails.currency_x = formExtLineItem.CurrencyIsoCode;
                                docDetails.reasonCode = formExtLineItem.ESC_Reason_Code__c;
                            }else{
                                    if(caseFormExtLst[0].ESC_Form__r.name =='Write Off Form'){
                                        docDetails.amount = string.valueOf(formExtLineItem.USL_Input_Amount__c);
                                    }else{
                                        docDetails.amount = string.valueOf(formExtLineItem.ESC_Item_Amount__c);
                                    }
                                    
                            }
                            docDetailList.add(docDetails);
                        }
                    }
                    invoiceDetail.account = acc;
                    invoiceDetail.documentDetails = docDetailList;
                    req.InvoiceDetail = invoiceDetail;
                    httpResponse resp;
                    if(isCC){
                         resp = ESC_DellBoomiCalloutUtil.sendS4Request(req,'ESC_CCBoomiIntegration');
                    }else{
                        resp = ESC_DellBoomiCalloutUtil.sendS4Request(req,'ESCWriteoffBoomiIntegration');
                    }
                    
                    string strRes = resp.getBody();
                    system.debug('$$$PS- Response for Writeoff/CC - '+strRes);
                    if(strRes!=null){
                        if(isCC){
                            MasterCaseTriggerRecursiveCheck.checkRecursiveForCC =false;
                        }else{
                            MasterCaseTriggerRecursiveCheck.checkRecursiveForWriteOff =false; 
                        }
                        
                        ESC_Case_Form_Extension__c cFormExt = new ESC_Case_Form_Extension__c(Id=caseFormExtLst[0].id , USL_Is_Processed__c = true);
                        if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){
                            update cFormExt;
                        }
                        ESC_DellBoomiCalloutUtil.updateFormExtLineItem(resp,formExtLineItemLst,caseFormExtLst[0].ESC_Case__c,caseFormExtLst[0].ESC_Form__c,caseFormExtLst[0].ESC_Form__r.name);
                    }
                    
            } 
           
        }catch(Exception ex){
            
            system.debug('Exception : ' + ex.getMessage() + ex.getLineNumber());
           ApplicationLogUtility.logException('TXP','ESC_IntegrationUtil','createDellBoomiRequest',ex);
    }
        
    }
    
 }