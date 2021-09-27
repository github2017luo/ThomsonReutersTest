/* 
*@author Original : Tejaswi Nissankula (UX010800)
*@date Original   : 12 Dec 2017 
*@description     : (CRM-9456)Batch class to handle the Order submission to ESI.If the Order is successfully submitted to ESI we are updating the status of order record to 'Submitted' else we will log the failed order record in integration log object. 
*/
global class Aptts_BatchOrderSubmission implements  Database.Batchable<sObject>,Database.AllowsCallouts{
    global Order_Submission__c orderSub=Order_Submission__c.getInstance('Order_Submission');
    global String query;
    global List<Apttus_Config2__Order__c> sendEmailupdateList {get;set;}
    
    global List<APTS_Case_Brand__mdt> casebrandlist = new List<APTS_Case_Brand__mdt>();
    
    //Start method is used to retrive the Order records whose status is pending,retrycount lessthan equal to 3 and created date is less than diff date(based on period mentioned in custom setting of Order submission)
    global Database.QueryLocator start(Database.BatchableContext bc){
        try{
            system.debug('In batchordersubmission start');
            DateTime now=DateTime.now();
            if(orderSub!=null){
                Boolean runOldOrderProcess = false;
                KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
                if(keyValueListRec !=NULL){
                    runOldOrderProcess = TRUE;
                }
                DateTime diff=now.addDays(integer.valueOf(-orderSub.Period__c*7));//Used to limit the records based on diff date 
                system.debug('diff::'+diff);
                string diffdate=string.escapeSingleQuotes(diff.format('yyyy-MM-dd'));
                string difftime=string.escapeSingleQuotes(diff.format('HH:mm:ss'));
                string diffzone=string.escapeSingleQuotes(diff.format('Z'));
                //DOC-3179 - Added by Nandha : Starts Here
                DateTime difftax=now.addDays(integer.valueOf(-orderSub.Period__c*10));
                system.debug('diff::'+diff);
                string diffdatetax = string.escapeSingleQuotes(diff.format('yyyy-MM-dd'));
                string difftimetax = string.escapeSingleQuotes(diff.format('HH:mm:ss'));
                string diffzonetax =  string.escapeSingleQuotes(diff.format('Z'));
                //DOC-3179 - Added by Nandha : Ends Here
                //Query
                //DOC-3179 - Added by Nandha : Changed the criteria in order to support for Tax Prof
                query='Select id,name,APTS_SAP_Status__c,Retry_Count__c,Apttus_Config2__Status__c, ';
                query+= 'APTS_SSD_Sold_To__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,LastModifiedDate, ';
                query+= 'CreatedDate,APTS_SendEmail__c,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c, ';
                query+= 'Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c,Apttus_QPConfig__ProposalId__r.APTS_Send_NACI_Form__c, ';
                query+= 'Apttus_QPConfig__ProposalId__r.Credit_Check_Flag__c,Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c, ';
                query+= 'Apttus_QPConfig__ProposalId__r.APTS_Bank_Account_Number__c,Apttus_QPConfig__ProposalId__r.APTS_Bank_Name__c, ';
                query+= 'Apttus_QPConfig__ProposalId__r.APTS_Bank_Routing_Number__c,APTS_SSD_Ship_To__r.APTS_ZPEND_Flag__c, ';
                query+= 'APTS_SSD_Ship_To__c, APTS_SSD_Ship_To__r.Source_System_Account_Number__c, ';
                query+= 'APTS_SSD_bill_to__c , APTS_SSD_bill_to__r.Source_System_Account_Number__c , APTS_SSD_bill_to__r.APTS_ZPEND_Flag__c, ';
                query+= 'APTS_Payer__c, APTS_Payer__r.Source_System_Account_Number__c , APTS_Payer__r.APTS_ZPEND_Flag__c,Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c ';
                query+= 'from Apttus_Config2__Order__c where Apttus_Config2__Status__c=\'Pending\'  and ';
                
                query+= 'APTS_SAP_Status__c!=\'Case Created\'  and '; //Added by Kruti Shah for DOC-12286
                 
                query+= 'Retry_Count__c<='+(orderSub.Retry_Count__c).setscale(0)+' and CreatedDate>='+diffdate+'T'+difftime+diffzone+' and ';
                if(runOldOrderProcess){
                    query+= '(APTS_Proposal_Business_Unit__c != \'Tax Professional\' or (APTS_Proposal_Business_Unit__c = \'Tax Professional\' and ';
                }else{
                    query+= '((APTS_Proposal_Business_Unit__c = \'Tax Professional\' and ';
                }
                query+= '((APTS_SSD_Sold_To__r.APTS_Is_Customer__c = true and APTS_SSD_Sold_To__r.Default_Payment_Method__c <> NULL) or (Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c = \'Bill to Account\') or '; 
                query+= '((Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c = \'One Time EFT\' and (APTS_SSD_Sold_To__r.APTS_Is_Customer__c = false OR (APTS_SSD_Sold_To__r.APTS_Is_Customer__c=true and APTS_SSD_Sold_To__r.Default_Payment_Method__c = NULL)) and ';
                query+= 'Apttus_QPConfig__ProposalId__r.APTS_Bank_Account_Number__c != NULL and Apttus_QPConfig__ProposalId__r.APTS_Bank_Name__c != NULL ';
                query+= 'and Apttus_QPConfig__ProposalId__r.APTS_Bank_Routing_Number__c != NULL) and ';
                query+= '(Apttus_QPConfig__ProposalId__r.Payment_Status__c = \'Completed\')) or ';
                
                query+=  '((Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c = \'Auto EFT/Auto Charge\' or Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c = \'Payment Express Auto EFT/Auto Charge\' or ';
                query+= 'Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c = \'Credit Card\') and ';
                query+= '((APTS_SSD_Sold_To__r.APTS_Is_Customer__c = false OR (APTS_SSD_Sold_To__r.APTS_Is_Customer__c=true and APTS_SSD_Sold_To__r.Default_Payment_Method__c = NULL)) and Apttus_QPConfig__ProposalId__r.Payment_Status__c = \'Completed\'))) ';
                
                query+= 'and ((APTS_SAP_Status__c = \'Pending\' ';
                query+= 'and CreatedDate >= '+diffdate+'T'+difftime+diffzone+') or (APTS_SAP_Status__c = \'Credit Pass\' and ';
                query+=  'CreatedDate>='+diffdatetax+'T'+difftimetax+diffzonetax+')))) '; 
                
                system.debug('Kh*** query::===> '+query);
                system.debug('Kh*** results :::===> '+Database.getQueryLocator(query));
                return Database.getQueryLocator(query);
            }else{
                system.debug('No Custom setting record exist');
                return Database.getQueryLocator(query);
            }    
        }catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause: '+ex.getCause());
            system.debug('Error LineNumber: '+ex.getLineNumber());
            system.debug('Error Message: '+ex.getStackTraceString());
            return Database.getQueryLocator(query);
        }
        
    }
    //Here the scope is one,so execute will be run for each order record.Execute method is used to submit the order to ESI.
    global void execute(Database.BatchableContext bc,List<Apttus_Config2__Order__c> orderRecs){
        try{
            Boolean runOldOrderProcess = false;
            KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
            if(keyValueListRec !=NULL){
                runOldOrderProcess = TRUE;
            }
            system.debug('In batchordersubmission execute:: orderRecs size '+orderRecs.size());
            //List<Apttus_Config2__Order__c> retryCountUpdateList=new List<Apttus_Config2__Order__c>();//List is used to store the order records when retry count or status updated.
            List<Apttus_Config2__Order__c> failedOrders=new list<Apttus_Config2__Order__c>();//Reset the Retycount of orders to 0 when retry count is 3 and lastmodfied date is more than a day compared with todays date
            List<Apttus_Config2__Order__c> finalOrderListToUpdate=new List<Apttus_Config2__Order__c>();//Final Order List to update
            //Added by Priyanka
            
            List<Id> orderIds = new List<Id>();
            for(Apttus_Config2__Order__c orderSSD:orderRecs){
                orderIds.add(orderSSD.id);
                System.debug('Orders%%%%%%%%%%%'+orderSSD.id);
            }
            //List<Apttus_Config2__AssetLineItem__c> assets= [Select id,Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_ship_to__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_bill_to__c from Apttus_Config2__AssetLineItem__c where Apttus_QPConfig__ProposalId__c IN :proposals];
            List<Apttus_Config2__OrderLineItem__c> orderLineitems= [Select id,APTS_SSD_Ship_to__c,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__AssetLineItemId__r.APTS_SSD_bill_to__c,Apttus_Config2__AssetLineItemId__r.APTS_SSD_Ship_to__c,Apttus_Config2__AssetLineItemId__r.APTS_SSD_Sold_To__c,Apttus_QPConfig__ProposalId__c,Apttus_Config2__OrderId__c,Apttus_Config2__OrderId__r.APTS_SSD_Ship_To__c,Apttus_Config2__OrderId__r.APTS_SSD_bill_to__c,Apttus_Config2__OrderId__r.APTS_SSD_Sold_To__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_ship_to__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_bill_to__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c IN :orderIds ];
            
            Map<Id,Apttus_Config2__OrderLineItem__c> orderMap = new Map<Id,Apttus_Config2__OrderLineItem__c>();
            for(Apttus_Config2__OrderLineItem__c oli :orderLineitems){
                
                orderMap.put(oli.Apttus_Config2__AssetLineItemId__c,oli);
            }
            List<Apttus_Config2__AssetLineItem__c> assets =[Select id,Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_ship_to__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_bill_to__c from Apttus_Config2__AssetLineItem__c where id in : orderMap.keySet()];
            System.debug('assets::'+assets);
            List<Apttus_Config2__AssetLineItem__c> assetsToUpdate = new List<Apttus_Config2__AssetLineItem__c>();
            Apttus_Config2__OrderLineItem__c assetOli = new Apttus_Config2__OrderLineItem__c();
            System.debug('orderline item::'+assetOli );
            for(Apttus_Config2__AssetLineItem__c asl: assets){
                assetOli = orderMap.get(asl.id);
                if(assetOli.APTS_SSD_Ship_to__c == null || String.valueOf(assetOli.APTS_SSD_Ship_to__c) ==''){
                    asl.APTS_SSD_Ship_to__c = assetOli.Apttus_Config2__OrderId__r.APTS_SSD_Ship_To__c;
                    assetsToUpdate.add(asl);
                }
            }
            
            
            //Added by Priyanka ends
            List<Integration_Logger__c> intLoggerupdateList=new List<Integration_Logger__c>();
            Set<Id> esiSubmittedOrderIdSet=new set<Id>();
            Boolean executionstatus=false;
            Boolean sapNumberCreationStatus;
            Set<Id> taxprofSSDs = new Set<Id>();
            List<Apttus_Config2__Order__c> updateorderList=new List<Apttus_Config2__Order__c>();
            
            //Start: Added by Kruti Shah for DOC-12286
            String strGlobalPBU = '';            
            List<APTS_Integration_Variables__mdt> orderSubmissionEsiList=[Select MasterLabel,Value__c 
                                                                          from APTS_Integration_Variables__mdt];
            for(APTS_Integration_Variables__mdt var : orderSubmissionEsiList){
                if(var.MasterLabel == 'RISKGlobalProposalBusinessUnit'){
                    strGlobalPBU = var.Value__c;
                }              
            
            }            
            //End: Added by Kruti Shah for DOC-12286 
            casebrandlist = [Select MasterLabel,DeveloperName,APTS_Case_Brand_Value__c,APTS_Case_Type__c,APTS_Product_Family__c,APTS_Proposal_Business_Unit__c from APTS_Case_Brand__mdt];
            
            //if(orderRecs.size()>0){
                for(Apttus_Config2__Order__c rec : orderRecs){
                    
                    //DOC-8652 - Zpend Triggering for partner Functions - By Poorva
                    if(taxprofSSDs!= null){
                        taxprofSSDs.clear();
                    }
                    if(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Tax Professional' &&
                       ((rec.APTS_SSD_Ship_To__c!=null && rec.APTS_SSD_Ship_To__r.Source_System_Account_Number__c==null)||
                        (rec.APTS_SSD_bill_to__c!=null && rec.APTS_SSD_bill_to__r.Source_System_Account_Number__c==null)||
                        (rec.APTS_Payer__c !=null && rec.APTS_Payer__r.Source_System_Account_Number__c==null))){
                            
                            if(rec.APTS_SSD_Ship_To__c!=null && rec.APTS_SSD_Ship_To__r.Source_System_Account_Number__c==null && !rec.APTS_SSD_Ship_To__r.APTS_ZPEND_Flag__c){
                                taxprofSSDs.add(rec.APTS_SSD_Ship_To__c);
                            }
                            if(rec.APTS_SSD_bill_to__c!=null && rec.APTS_SSD_bill_to__r.Source_System_Account_Number__c==null && !rec.APTS_SSD_bill_to__r.APTS_ZPEND_Flag__c){
                                taxprofSSDs.add(rec.APTS_SSD_bill_to__c);
                            }
                            if(rec.APTS_Payer__c !=null && rec.APTS_Payer__r.Source_System_Account_Number__c==null && !rec.APTS_Payer__r.APTS_ZPEND_Flag__c){
                                taxprofSSDs.add(rec.APTS_Payer__c);
                            }
                            if(!taxprofSSDs.isEmpty()){
                                for(Id ssdId : taxprofSSDs){
                                    CreateSSDCustomerFromDellBoomi.triggerCustomerCreation(ssdId,rec.Apttus_QPConfig__ProposalId__c);                            
                                }
                            } 
                            
                            continue;
                            
                        }
                    //DOC-8652 Ends here------------
                    
                    system.debug('rec id'+rec.id+' sold to ssd'+rec.APTS_SSD_Sold_To__c+'retry cunt'+rec.Retry_Count__c+'order sub'+orderSub);
                    //When Sold to of SSD record not equal to null,SAP Number of SSD not equal to null and retry count <=3
                    if(rec.APTS_SSD_Sold_To__c!=null && (rec.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!=null || strGlobalPBU.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c)) && rec.Retry_Count__c<=orderSub.Retry_Count__c){           
                        if(rec.Retry_Count__c<3){
                            if(strGlobalPBU.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c)){
                                if(runOldOrderProcess){
                                    executionstatus=callcasecreation(rec);
                                }
                            }else if(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                                system.debug('entering dellboomi call$$$$$$$$$');
                                executionstatus=calltaxordersubmission(rec);
                            }else{
                                if(runOldOrderProcess){
                                    executionstatus=callOrderSubmissionClass(rec);  
                                }
                            }
                            System.debug('Tax Profeesional BU Execution status is equal to '+executionstatus);
                            //DOC-3179 - Added by Nandha to support for Tax business unit
                            if(!executionstatus && (rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c != 'Tax Professional' || (rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Tax Professional' && rec.APTS_SAP_Status__c != 'Order Credit Block'))){ 
                                rec.Retry_Count__c=rec.Retry_Count__c+1;
                                updateorderList.add(rec);
                            }else if(executionstatus && rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                                System.debug('Tax Profeesional BU Execution status = true');
                                rec.APTS_SAP_Status__c='Order Submitted';
                                updateorderList.add(rec);
                                esiSubmittedOrderIdSet.add(rec.Id);
                                //System.debug('updating assetttttttttttttttttttt');
                                //update assetsToUpdate;
                            }else if(executionstatus && strGlobalPBU.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c)){
                                rec.APTS_SAP_Status__c='Case Created';
                                updateorderList.add(rec); 
                                update assetsToUpdate;
                            }
                            else if(executionstatus){
                                rec.Apttus_Config2__Status__c='Submitted';
                                updateorderList.add(rec);
                                esiSubmittedOrderIdSet.add(rec.Id);
                            }
                            system.debug('inside if of retrycount:: Id '+rec.Id+' retry count '+rec.Retry_Count__c+' rec status '+rec.Apttus_Config2__Status__c);
                        }else if(rec.Retry_Count__c==3){
                            system.debug('Retry Count'+rec.Retry_Count__c);
                            failedOrders.add(rec);
                        }
                    }//when SAP number of SSD record equal to null then call Big rule method to create SAP number
                    else if(rec.APTS_SSD_Sold_To__r.Source_System_Account_Number__c==null 
                            && rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c !='Tax Professional' && !strGlobalPBU.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c)){
                                if(rec.Retry_Count__c<3){
                                    //ZPND request
                                    system.debug('Zpend Request');
                                    sapNumberCreationStatus=CreateSSDCustomerFromESI.triggerCustomerCreation(rec.APTS_SSD_Sold_To__c,rec.Id);
                                    system.debug('##### sapNumberCreationStatus'+sapNumberCreationStatus);
                                    if(sapNumberCreationStatus){
                                        //executionstatus=callOrderSubmissionClass(rec);
                                        system.debug('##### SAP Number generated successfully');
                                        /*system.debug('##### executionstatus'+executionstatus);
                                        if(!executionstatus){
                                        rec.Retry_Count__c=rec.Retry_Count__c+1;
                                        updateorderList.add(rec);
                                        }else if(executionstatus){
                                        rec.Apttus_Config2__Status__c='Submitted';
                                        updateorderList.add(rec);
                                        esiSubmittedOrderIdSet.add(rec.Id);
                                        System.debug('updating in else');
                                        }  */ 
                                    }else{
                                        rec.Retry_Count__c=rec.Retry_Count__c+1;
                                        updateorderList.add(rec);
                                        system.debug('Error in creation of SAP Number for SSd Record');
                                    }
                                }else if(rec.Retry_Count__c==3){
                                    failedOrders.add(rec);
                                }
                            }
                    
                }
                system.debug('udateorderlist '+updateorderList);
                if(updateorderList!=null && updateorderList.size()>0){
                    finalOrderListToUpdate.addAll(updateorderList);
                }
                system.debug('failedorderslist '+failedOrders);
                system.debug('##### finalOrderListToUpdate'+finalOrderListToUpdate);
                //Failed order list is used to reset the retry count and email triggering of Order records when it is a day or more it reached the maximum failure 
                /*if(failedOrders!=null && failedOrders.size()>0){
                system.debug('failed order size'+failedOrders.size());
                for(Apttus_Config2__Order__c failedRec:failedOrders){
                system.debug('Last modified date:: '+failedRec.LastModifiedDate+' Today date:: '+Date.Today()+' Diff:: '+Date.valueOf(failedRec.LastModifiedDate).daysBetween(Date.Today()));
                if(Date.valueOf(failedRec.LastModifiedDate).daysBetween(Date.Today())>=1 && failedRec.Retry_Count__c==3){
                failedRec.Retry_Count__c=0;
                failedRec.APTS_SendEmail__c=false;
                retryCountUpdateList.add(failedRec);
                }
                }
                }*/
                //if(retryCountUpdateList!=null && retryCountUpdateList.size()>0) finalOrderListToUpdate.addAll(retryCountUpdateList);
                if(finalOrderListToUpdate!=null && finalOrderListToUpdate.size()>0){
                    update finalOrderListToUpdate;
                }
                system.debug('##### finalOrderListToUpdate'+finalOrderListToUpdate);
                system.debug('##### esiSubmittedOrderIdSet'+esiSubmittedOrderIdSet);
                if(esiSubmittedOrderIdSet!=null && esiSubmittedOrderIdSet.size()>0){
                    intLoggerupdateList=[Select Id,Success__c from Integration_Logger__c where Order__c in:esiSubmittedOrderIdSet];
                    System.debug('updating intLoggerupdateList'+intLoggerupdateList);
                    if(intLoggerupdateList!=null && intLoggerupdateList.size()>0){
                        for(Integration_Logger__c logRec : intLoggerupdateList){
                            logRec.Success__c=True; 
                        }
                        update intLoggerupdateList;
                    }
                    System.debug('updating intLoggerupdateList'+intLoggerupdateList);
                    System.debug('updating assetttttttttttttttttttt');
                    update assetsToUpdate;
                }
            //}
        }catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause: '+ex.getCause());
            system.debug('Error LineNumber: '+ex.getLineNumber());
            system.debug('Error Message: '+ex.getStackTraceString());
        }
        
    }
    
    //Finish method will be used to send mails to support team when order reaches maximum failures
    //Finish method will be used to send mails to support team when order reaches maximum failures
    global void finish(Database.BatchableContext bc){
        
        try{
            Set<String> supportedBusinessUnits=new Set<String>{'SCS',label.SALESORGCAN,'Corp OneOTC US','Corp OneOTC UK'};
                List<Apttus_Config2__Order__c> failedOrdersToSupportTeam=new list<Apttus_Config2__Order__c>();
            List<Apttus_Config2__Order__c> sendEmailupdateList=new List<Apttus_Config2__Order__c>();
            List<OrgWideEmailAddress> owea;
            string emailTemplateId;
            List<string> emailListOfGLITeam=new List<string>();
            List<string> emailListOfFindlawTeam=new List<string>();
            failedOrdersToSupportTeam=[Select Id,Name,Apttus_QPConfig__ProposalId__r.Name,Retry_Count__c,APTS_Proposal_Business_Unit__c,APTS_SendEmail__c from Apttus_Config2__Order__c where APTS_SendEmail__c=false and Retry_Count__c=3];
            system.debug('entered in finish method'+' Failed Orders'+failedOrdersToSupportTeam);
            //Retieve the emailid of support team
            List<Email_Address_of_Support_Team__mdt> emailidofsuppotteam=[Select EmailId__c,DeveloperName from Email_Address_of_Support_Team__mdt where DeveloperName IN ('GLI_OC_Support_team','GLI_OC_L2Support_Team','FL_OC_Mail_Group') Limit 3];
            
            if(emailidofsuppotteam!=null && emailidofsuppotteam.size()>0){
                for(Integer i=0;i<emailidofsuppotteam.size();i++){
                    
                    if(emailidofsuppotteam[i].DeveloperName =='GLI_OC_Support_team'){
                        emailListOfGLITeam.add(emailidofsuppotteam[i].EmailId__c);
                    }else if(emailidofsuppotteam[i].DeveloperName =='FL_OC_Mail_Group'){ 
                        emailListOfFindlawTeam.add(emailidofsuppotteam[i].EmailId__c);
                    }else if(emailidofsuppotteam[i].DeveloperName =='GLI_OC_L2Support_Team'){
                        emailListOfGLITeam.add(emailidofsuppotteam[i].EmailId__c);
                        emailListOfFindlawTeam.add(emailidofsuppotteam[i].EmailId__c);
                    }
                    
                }
            }
            
            for(EmailTemplate emailTemplateRec: [select Id,Name from EmailTemplate where DeveloperName= 'Failed_Order_Notification' LIMIT 1]){ 
                emailTemplateId =emailTemplateRec.id;
            }
            
            //Get the OrgWideEmailAddress to use as the From email address
            owea = [select Id from OrgWideEmailAddress where DisplayName = 'Salesforce Notification'];
            if(failedOrdersToSupportTeam!=null && failedOrdersToSupportTeam.size()>0){
                system.debug('failed order size'+failedOrdersToSupportTeam.size());
                
                List<Messaging.SingleEmailMessage> emailList=new List<Messaging.SingleEmailMessage>();
                for(Apttus_Config2__Order__c failedRec:failedOrdersToSupportTeam){
                    system.debug('failedRecId'+failedRec.Id);
                    Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(owea[0].Id);
                    if(supportedBusinessUnits.contains(failedRec.APTS_Proposal_Business_Unit__c)){ 
                        mail.setToAddresses(emailListOfGLITeam);
                    }
                    else if(failedRec.APTS_Proposal_Business_Unit__c =='FindLaw'){
                        mail.setToAddresses(emailListOfFindlawTeam);
                    }
                    mail.setTargetObjectId(userinfo.getUserId());
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setsaveAsActivity(false);
                    mail.setWhatId(failedRec.Id);
                    mail.setTemplateId(emailTemplateId); 
                    emailList.add(mail);
                    failedRec.APTS_SendEmail__c=true;
                    sendEmailupdateList.add(failedRec);
                }
                system.debug('size of email templates :: '+emailList.size());
                Messaging.sendEmail(emailList);
                
                if(sendEmailupdateList!=null && sendEmailupdateList.size()>0){
                    update sendEmailupdateList;
                }
            }
        }catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            system.debug('Error Cause: '+ex.getCause());
            system.debug('Error LineNumber: '+ex.getLineNumber());
            system.debug('Error Message: '+ex.getStackTraceString());
        }
        
    }
    public Boolean callOrderSubmissionClass(Apttus_Config2__Order__c rec){
        Boolean executionstatus=false;
        APTS_Ordersubmissionwrapper submissionWrapperResponse = new APTS_Ordersubmissionwrapper();
        if(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'FindLaw'){ //Findlaw changes
            submissionWrapperResponse =APTS_FindLawOrderQueuetoESI.FLorderSubmissionToESI(rec.Id);    
        }
        else if(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'SCS'){
            submissionWrapperResponse =APTS_OrderQueuetoESI.orderSubmissionToESI(rec.ID);//Findlaw Changes
        }
        else if(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK'){
            submissionWrapperResponse =APTS_CORP_OrderQueuetoESI.corporateorderSubmissionToESI(rec.id);//Corporate Changes
        }
        else if(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Canada'){ 
            submissionWrapperResponse =APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(rec.ID);//CARS Changes
        }
        if(submissionWrapperResponse !=NULL && submissionWrapperResponse.isSuccess){
            return TRUE;
        }
        return executionstatus;
    }
    
    public Boolean callcasecreation(Apttus_Config2__Order__c rec){
        Boolean executionstatus=false;
        String billingcase = '',entcase = '';
        GenericCaseMgmtService casecall = new GenericCaseMgmtService();
        //Start: Added by Kruti Shah
        for(APTS_Case_Brand__mdt val : casebrandlist){
            if(val.APTS_Product_Family__c == rec.Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c && val.APTS_Proposal_Business_Unit__c.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c) && val.APTS_Case_Type__c != null && val.APTS_Case_Type__c.contains('Billing')){
                billingcase = val.APTS_Case_Brand_Value__c;
            }
            if(val.APTS_Product_Family__c == rec.Apttus_QPConfig__ProposalId__r.APTS_Case_Brand_Value__c && val.APTS_Proposal_Business_Unit__c.contains(rec.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c) && val.APTS_Case_Type__c != null && val.APTS_Case_Type__c.contains('Entitlement')){
                entcase = val.APTS_Case_Brand_Value__c;
            }
        }
            try{
                system.debug('KS--> rec.Apttus_QPConfig__ProposalId__r.ID '+rec.Apttus_QPConfig__ProposalId__r.ID);
                List<Id> listofprop = new List<Id>{rec.Apttus_QPConfig__ProposalId__c};
                Map<Id,String> failurereason = new Map<Id,String>();
                List<Id> createdcases = new List<Id>();
            if(billingcase != null && billingcase != ''){
                failurereason.put(rec.Apttus_QPConfig__ProposalId__c,billingcase);
                createdcases = casecall.createCreditCheckCase(listofprop,failurereason);
                    }
            if(createdcases != null && createdcases.size() > 0 && entcase != null && entcase != ''){
                failurereason.put(rec.Apttus_QPConfig__ProposalId__c,entcase);
                    createdcases = casecall.createCreditCheckCase(listofprop,failurereason); 
                }
                system.debug('KS--> createdCases '+createdcases);
            if((billingcase != null && billingcase != '') || (entcase != null && entcase != '')){
                if(createdCases == null || createdCases.size() ==0){
                    system.debug('KS--> inside If');
                    executionstatus = false;
                    IntegrationLogger.OCAddMessage('Case not Created for Order.', rec.ID, 'Order', 'Case Creation for Order.', 'Outound', 'OrderSubmission', false, rec.id);    
                }else{
                    executionstatus = True;
                    system.debug('KS--> inside else');
                    IntegrationLogger.OCAddMessage('Case creation successfull for Order. Case Id is: '+createdcases.get(0), rec.ID, 'Order', 'Case Creation for Order.', 'Outound', 'OrderSubmission', true, rec.id);    
                }      
            }      
            }catch(Exception ex){
                executionstatus = False;
                system.debug('KS--> inside catch exception');
                IntegrationLogger.OCAddMessage('Case not Created for Order. '+ex.getMessage(), rec.ID, 'Order', 'Case Creation for Order.', 'Outound', 'OrderSubmission', false, rec.id);    
        }
        //End: Added by Kruti Shah
        return executionstatus;
    }
    public Boolean calltaxordersubmission(Apttus_Config2__Order__c rec){
        Boolean executionstatus=false;
        if((rec.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c=='Accepted' && (rec.Apttus_QPConfig__ProposalId__r.APTS_Send_NACI_Form__c ==true || rec.Apttus_QPConfig__ProposalId__r.Credit_Check_Flag__c== true)) && rec.APTS_SAP_Status__c == 'Pending' && rec.APTS_SSD_Sold_To__r.Source_System_Account_Number__c != NULL && rec.APTS_SSD_Sold_To__r.Source_System_Account_Number__c != ''){
            String creditstatus = CreditCheckCallout1.creditchekcallout(rec.id);
            rec.APTS_SAP_Status__c = creditstatus;
            System.debug('Credit check @ 1'+rec.APTS_SAP_Status__c);
        }else if(((rec.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c=='Accepted' && (rec.Apttus_QPConfig__ProposalId__r.APTS_Send_NACI_Form__c ==true || rec.Apttus_QPConfig__ProposalId__r.Credit_Check_Flag__c== true)) && rec.APTS_SAP_Status__c == 'Credit Pass' && rec.APTS_SSD_Sold_To__r.Source_System_Account_Number__c != NULL && rec.APTS_SSD_Sold_To__r.Source_System_Account_Number__c != '') || (rec.Apttus_QPConfig__ProposalId__r.APTS_Send_NACI_Form__c != true && rec.Apttus_QPConfig__ProposalId__r.Credit_Check_Flag__c != true && rec.APTS_SAP_Status__c == 'Pending')){
            executionstatus=APTS_Hana_OrderQueuetoBOOMI.DellBoomiorderSubmissionToBOOMI(rec.id);
            System.debug('Credit check @ 2');
        }
        return executionstatus;
    }
    
}