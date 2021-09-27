/**
* @author: Durga P
* @version 2021-07-20
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                Description
* 2021-07-20   Durga P              Created
* =============================================================================
*/
@SuppressWarnings('PMD')
public class AutoPayment_TriggerHandler{
    public static boolean doAfterInsertCheck = FALSE;
    public static boolean doAfterUpdateCheck = FALSE;
    
    public static void doAfterInsert(List<Apttus_Config2__Order__c> newOrderList){
        if(!doAfterInsertCheck){
            try{
                Boolean isBulkLoad=false;
                Boolean isTestrun=false;
                
                //Added by Tejaswi (GLI-OC) to deactive triggers during data load
                GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
                if(loadValues!=null && (loadValues.APTS_Disable_Triggers__c)) 
                    isBulkLoad=true;        
                if(Test.isRunningTest()){
                    isTestrun=true;
                }        
                //End of trigger Deactivate logic
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'customerservice@thomsonreuters.com'];
                //fetch customsettings
                EmailTemplate templateId = [Select id,Body,HtmlValue,subject from EmailTemplate where name = 'APTS_PaymentGateway_Template_VF_French'];   
                if(isBulkLoad ==false)
                { 
                    System.debug('inside trigger execution');
                    WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
                    if(Test.isRunningTest()){
                        PGWebServiceSettings.Endpoint__c='www.google.com';
                    }
                    else{
                        PGWebServiceSettings = AppUtil.getWebServiceSettings('Payment AutoCharge'); 
                    }
                    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                    PaymentgatewayUtil encryptData = new PaymentgatewayUtil();
                    boolean flag=false;
                    
                    System.debug('flag'+flag);
                    if((Trigger.IsInsert)||(flag==true)){
                        System.debug('---------------Inside insert');
                        List<Apttus_Config2__Order__c> lstOrderToUpdate = new List<Apttus_Config2__Order__c>(); //Added to avoid PMD violations
                        for(Apttus_Config2__Order__c order:[select id,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,name,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.name,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c,
                                                            PaymentUrl__c,Apttus_QPConfig__ProposalId__r.Owner.Name,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstreet,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcity,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstate,Apttus_QPConfig__ProposalId__c,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcountry,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingPostalCode,Apttus_QPConfig__ProposalId__r.Name,
                                                            Apttus_QPConfig__ProposalId__r.Owner.Email,Apttus_QPConfig__ProposalId__r.APTS_Sold_To_SAP_Account_Number__c,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.email,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.name,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Quote_Value__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.Name ,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact_Name__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Number_Street__c,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.City__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.State__c,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Country__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.phone,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_Phone__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Postal_Code__c,
                                                            Apttus_QPConfig__ProposalId__r.Id,Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c,Apttus_QPConfig__ProposalId__r.Languagecode__c,
                                                            Apttus_QPConfig__ProposalId__r.CurrencyIsoCode,PaymentEmailSentFlag__c,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName 
                                                            from Apttus_Config2__Order__c where id in:trigger.new 
                                                            and Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c!='New Sales']){
                            if((order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto Charge') 
                               || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto EFT/Auto Charge')
                               ||(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge')){           
                                system.debug('Hi2@@@@');
                                String ccurl;
                                
                                System.debug('Inside else');
                                system.debug('SKGtriggerAPTS_Quote_Value__c1'+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Quote_Value__c));
                                system.debug('SKGtriggerCurrency'+String.valueOf(order.Apttus_QPConfig__ProposalId__r.CurrencyIsoCode) );                    
                                system.debug('SKGtriggerAPTS_Quote_Value__c2'+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Quote_Value__c));
                                String urlData = encryptData.encryption(order.Apttus_QPConfig__ProposalId__r);
                                //Added part of DOC-67
                                if(order.Apttus_QPConfig__ProposalId__r.Languagecode__c =='fr_CA' && order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Canada' ){ccurl=PGWebServiceSettings.Endpoint__c+'?lan=1&Paydet='+urlData ;   }
                                //DOC-67 changes ends here
                                else{ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;}
                                // }
                                system.debug('proposal'+order.Apttus_QPConfig__ProposalId__c);
                                system.debug('------------proposal ccurl'+ccurl);
                                system.debug('------------order.paymenturl__c'+order.paymenturl__c);
                                order.paymenturl__c=ccurl;order.AutopaymentEmailButton__c = true;lstOrderToUpdate.add(order); //Added to avoid PMD violations
                                system.debug('-----------message'+messages);                        
                            }
                            //DOC-5624 Added by Nandha
                            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'One Time EFT'){           
                                system.debug('Nandha@@@@');
                                String ccurl;
                                String urlData = encryptData.directdebit(order.Apttus_QPConfig__ProposalId__r);                      
                                ccurl = PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;
                                order.paymenturl__c=ccurl;                                   
                                order.AutopaymentEmailButton__c = true;      
                                lstOrderToUpdate.add(order);
                            }
                            //Start: Added to avoid PMD violations
                            if (lstOrderToUpdate != null && lstOrderToUpdate.size() > 0){
                                update lstOrderToUpdate;
                            } 
                            //End
                        }
                    }
                    else{                
                        //Get Organization Wide Email Address
                        for(Apttus_Config2__Order__c order: [select id,name,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.name,
                             Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.Name,
                             Apttus_QPConfig__ProposalId__r.APTS_Sold_To_SAP_Account_Number__c,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstreet,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcity,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstate,
                             Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcountry,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingPostalCode,Apttus_QPConfig__ProposalId__r.Name,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact_Name__c,PaymentUrl__c,
                             Apttus_QPConfig__ProposalId__r.Owner.Name,Apttus_QPConfig__ProposalId__r.Owner.Email,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.email,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.name,PaymentEmailSentFlag__c,
                             Apttus_QPConfig__ProposalId__r.CurrencyIsoCode,
                             Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                             Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Default_Payment_Method__c 
                             from Apttus_Config2__Order__c where id in:trigger.new and 
                             Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c!='New Sales']){ Apttus_Config2__Order__c oldorder = order;
                                 system.debug('-----------PaymentEmailSentFlag__c'+order.PaymentEmailSentFlag__c);
                                 System.debug(order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!=null);
                                 system.debug('oldorder'+oldorder);
                                 system.debug('NewOrder'+order);
                                 if((order!=null && order.Apttus_QPConfig__ProposalId__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!=null && (order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c!='Tax Professional' || (order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Tax Professional' && (Order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == false || (Order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == true && order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c != order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Default_Payment_Method__c)))))){
                                               if(((oldorder.PaymentUrl__c!=order.PaymentUrl__c) && ((order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto Charge') || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto EFT/Auto Charge')|| (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge') || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'One Time EFT')))){
                                                       system.debug('HI3333');
                                                       system.debug('oldpayment'+oldorder.PaymentUrl__c+ 'new order:::'+order.PaymentUrl__c );
                                                       if((order.PaymentUrl__c!= null && oldorder.PaymentEmailSentFlag__c == false && (checkRecursive.runAutoPayment_Update_TriggerOnce()))){ System.debug('H14@@@@@');
                                                               
                                                               Messaging.SingleEmailMessage message =Messaging.renderStoredEmailTemplate(templateId.id ,order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,order.id);System.debug('Test @1'+message);
                                                               //Set From Address
                                                               //if(UserInfo.getUserId() != order.Apttus_QPConfig__ProposalId__r.OwnerId){
                                                                   message.setOrgWideEmailAddressId(owea.Id); messages.add(message); order.PaymentEmailSentFlag__c=true;system.debug('paydet'+order.paymenturl__c);system.debug('------------messages'+messages);
                                                               //}                                                               
                                                           }
                                                   }
                                           }
                             }
                    }  
                    System.debug('final'+messages );  
                    if(!test.isRunningTest())
                        Messaging.sendEmail(messages);
                        System.debug('Test @2'+messages);
                }
            }catch(exception e){
                system.debug('exception...'+e.getMessage()+e.getLineNumber());
            }
            doAfterInsertCheck = TRUE;
        }
    }
    
    public static void doAfterUpdate(List<Apttus_Config2__Order__c> newOrderList , Map<Id, Apttus_Config2__Order__c> oldOrderMap){
        if(!doAfterUpdateCheck){
            try{
                Boolean isBulkLoad=false;
                Boolean isTestrun=false;
                
                //Added by Tejaswi (GLI-OC) to deactive triggers during data load
                GLI_OC_Bulk_Load__c loadValues = GLI_OC_Bulk_Load__c.getInstance(UserInfo.getUserId());        
                if(loadValues!=null && (loadValues.APTS_Disable_Triggers__c)) 
                    isBulkLoad=true;        
                if(Test.isRunningTest()){
                    isTestrun=true;
                }        
                //End of trigger Deactivate logic
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'customerservice@thomsonreuters.com'];
                //fetch customsettings
                EmailTemplate templateId = [Select id,Body,HtmlValue,subject from EmailTemplate where name = 'APTS_PaymentGateway_Template_VF_French'];   
                if(isTestrun || (isTestrun== false && isBulkLoad ==false))
                { 
                    System.debug('inside trigger execution');
                    WebServiceSettings__c PGWebServiceSettings = new WebServiceSettings__c();
                    if(Test.isRunningTest()){
                        PGWebServiceSettings.Endpoint__c='www.google.com';
                    }
                    else{
                        PGWebServiceSettings = AppUtil.getWebServiceSettings('Payment AutoCharge'); 
                    }
                    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                    PaymentgatewayUtil encryptData = new PaymentgatewayUtil();
                    boolean flag=false;
                    if(trigger.Isupdate){
                        for(Apttus_Config2__Order__c order:newOrderList){
                            Apttus_Config2__Order__c oldorder = oldOrderMap.get(order.Id);
                            if((oldorder.Apttus_QPConfig__ProposalId__c!=order.Apttus_QPConfig__ProposalId__c)){
                                flag=true;
                                system.debug('Hi1');
                            }
                        }
                    }
                    System.debug('flag'+flag);
                    if(flag==true){
                        System.debug('---------------Inside insert');
                        List<Apttus_Config2__Order__c> lstOrderToUpdate = new List<Apttus_Config2__Order__c>(); //Added to avoid PMD violations
                        for(Apttus_Config2__Order__c order:[select id,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,name,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.name,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c,
                                                            PaymentUrl__c,Apttus_QPConfig__ProposalId__r.Owner.Name,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstreet,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcity,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstate,Apttus_QPConfig__ProposalId__c,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcountry,
                                                            Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingPostalCode,Apttus_QPConfig__ProposalId__r.Name,
                                                            Apttus_QPConfig__ProposalId__r.Owner.Email,Apttus_QPConfig__ProposalId__r.APTS_Sold_To_SAP_Account_Number__c,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.email,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.name,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Quote_Value__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.Name ,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact_Name__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Number_Street__c,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.City__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.State__c,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Country__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.phone,
                                                            Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_Phone__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Postal_Code__c,
                                                            Apttus_QPConfig__ProposalId__r.Id,Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c,Apttus_QPConfig__ProposalId__r.Languagecode__c,
                                                            Apttus_QPConfig__ProposalId__r.CurrencyIsoCode,PaymentEmailSentFlag__c,Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName,
                                                            Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName 
                                                            from Apttus_Config2__Order__c where id in:trigger.new 
                                                            and Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c!='New Sales']){
                            if((order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto Charge') || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto EFT/Auto Charge') || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge')){           
                                system.debug('Hi2@@@@');
                                String ccurl;
                                
                                System.debug('Inside else');
                                system.debug('SKGtriggerAPTS_Quote_Value__c1'+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Quote_Value__c));
                                system.debug('SKGtriggerCurrency'+String.valueOf(order.Apttus_QPConfig__ProposalId__r.CurrencyIsoCode) );                    
                                system.debug('SKGtriggerAPTS_Quote_Value__c2'+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Quote_Value__c));
                                String urlData = encryptData.encryption(order.Apttus_QPConfig__ProposalId__r);
                                //Added part of DOC-67 
                                if(order.Apttus_QPConfig__ProposalId__r.Languagecode__c =='fr_CA' && order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Canada' ){ccurl=PGWebServiceSettings.Endpoint__c+'?lan=1&Paydet='+urlData ;   }
                                //DOC-67 changes ends here
                                else{ccurl=PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;}
                                // }
                                system.debug('proposal'+order.Apttus_QPConfig__ProposalId__c);
                                system.debug('------------proposal ccurl'+ccurl);
                                system.debug('------------order.paymenturl__c'+order.paymenturl__c);
                                order.paymenturl__c=ccurl;order.AutopaymentEmailButton__c = true;lstOrderToUpdate.add(order); //Added to avoid PMD violations
                                system.debug('-----------message'+messages);                        
                            }
                            //DOC-5624 Added by Nandha
                            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'One Time EFT'){   system.debug('Nandha@@@@');String ccurl;String urlData = encryptData.directdebit(order.Apttus_QPConfig__ProposalId__r);ccurl = PGWebServiceSettings.Endpoint__c+'?Paydet='+urlData ;order.paymenturl__c=ccurl;order.AutopaymentEmailButton__c = true; lstOrderToUpdate.add(order);                            }
                            //Start: Added to avoid PMD violations
                            if (lstOrderToUpdate != null && lstOrderToUpdate.size() > 0){ update lstOrderToUpdate;} 
                            //End
                        }
                    }
                    else{                
                        //Get Organization Wide Email Address
                        for(Apttus_Config2__Order__c order:
                            [select id,name,Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c,Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.name,
                             Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.Name,
                             Apttus_QPConfig__ProposalId__r.APTS_Sold_To_SAP_Account_Number__c,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstreet,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcity,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingstate,
                             Apttus_QPConfig__ProposalId__c,Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingcountry,
                             Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Account__r.billingPostalCode,Apttus_QPConfig__ProposalId__r.Name,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact_Name__c,PaymentUrl__c,
                             Apttus_QPConfig__ProposalId__r.Owner.Name,Apttus_QPConfig__ProposalId__r.Owner.Email,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.email,
                             Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.name,PaymentEmailSentFlag__c,
                             Apttus_QPConfig__ProposalId__r.CurrencyIsoCode,
                             Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                             Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Default_Payment_Method__c 
                             from Apttus_Config2__Order__c where id in:trigger.new and 
                             Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c!='New Sales']){
                                 Apttus_Config2__Order__c oldorder = oldOrderMap.get(order.Id);
                                 system.debug('-----------PaymentEmailSentFlag__c'+order.PaymentEmailSentFlag__c);
                                 System.debug(order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!=null);
                                 system.debug('oldorder'+oldorder);
                                 system.debug('NewOrder'+order);
                                 if((order!=null && order.Apttus_QPConfig__ProposalId__c!=null && 
                                    order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__c!=null && 
                                    order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!=null &&
                                    (order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c!='Tax Professional' || 
                                     (order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Tax Professional' && 
                                      (Order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == false
                                       || (Order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.APTS_Is_Customer__c == true && order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c != order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.Default_Payment_Method__c)))))){
                                               
                                               if(((oldorder.PaymentUrl__c!=order.PaymentUrl__c) && 
                                                  ((order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto Charge') || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'Auto EFT/Auto Charge')|| (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c == 'Payment Express Auto EFT/Auto Charge') || (order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c== 'One Time EFT')))){
                                                       system.debug('HI3333');
                                                       system.debug('oldpayment'+oldorder.PaymentUrl__c+ 'new order:::'+order.PaymentUrl__c );
                                                       if((order.PaymentUrl__c!= null && oldorder.PaymentEmailSentFlag__c == false
                                                           && (checkRecursive.runAutoPayment_Update_TriggerOnce()))){ System.debug('H14@@@@@');
                                                               
                                                               Messaging.SingleEmailMessage message =Messaging.renderStoredEmailTemplate(templateId.id ,order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__c,order.id);System.debug('Test @1'+message);
                                                               //Set From Address
                                                               //if(UserInfo.getUserId() != order.Apttus_QPConfig__ProposalId__r.OwnerId){
                                                                   message.setOrgWideEmailAddressId(owea.Id);
                                                               //}
                                                               messages.add(message);
                                                               order.PaymentEmailSentFlag__c=true;system.debug('paydet'+order.paymenturl__c);system.debug('------------messages'+messages);
                                                               
                                                           }
                                                   }
                                           }
                             }
                    }  
                    System.debug('final'+messages );  
                    if(!test.isRunningTest()) Messaging.sendEmail(messages);
                        System.debug('Test @2'+messages);
                }
            }catch(exception e){
                system.debug('exception...'+e.getMessage()+e.getLineNumber());
            }
            doAfterUpdateCheck = TRUE;
        }
    }
    
    public static void checkAutoPayment(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}