/**
* Extended Validation Callback class for Corporate 
*
* @author  TCS
* @version 2019-04-08
*/
/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2019-04-08  Kruti Shah               Created
* =============================================================================
*/
global with sharing class APTS_CORP_Validation_CallbackHelper {
    
    public Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {
        Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true); 
        Apttus_Config2__ProductConfiguration__c Productconfig = New Apttus_Config2__ProductConfiguration__c();
        List<Apttus_Config2__LineItem__c> lineItems = new List<Apttus_Config2__LineItem__c>();
        String priceCallProductNames;
        Integer bridgemonths;         
        Boolean dollarAmountsIncomplete;   
        String bridgeDaysProductNames;
        //Start: Added by Kruti Shah (DOC-10107)
        set<String> restrictedBridgeValues = new set<String>();
        restrictedBridgeValues.add('7 Days');
        restrictedBridgeValues.add('14 Days');
        restrictedBridgeValues.add('28 Days');
        restrictedBridgeValues.add('N/a');
        //End: Added by Kruti Shah (DOC-10107)
        if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible() && !Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isQueryable()){
            return null;}        
        Productconfig = [Select ID,Apttus_QPConfig__Proposald__r.APTS_Proposal_Business_Unit__c 
                         from Apttus_Config2__ProductConfiguration__c 
                         where ID =:cart.getConfigSO().Id];
                         
        if(!Schema.sObjectType.Apttus_Config2__LineItem__c.isAccessible() && !Schema.sObjectType.Apttus_Config2__LineItem__c.isQueryable()){
            return null;}
        
                                           lineItems = [SELECT Apttus_Config2__EndDate__c,APTS_Product_Name__c,APTS_Proposal_Business_Unit__c,APTS_Availability_Date__c,
                                                       Apttus_Config2__ProductId__c,Apttus_Config2__LineStatus__c,APTS_Contract_Term__c,                                                                
                                                       Apttus_Config2__ChargeType__c, Apttus_Config2__PriceType__c,Apttus_Config2__ProductId__r.APTS_Availability_Date__c,
                                                       Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c,APTS_Contract_Term_Number__c,
                                                       Apttus_Config2__ProductId__r.Name,APTS_Renewal_Type__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c,Apttus_Config2__BasePrice__c,
                                                       APTS_Yr_2_Amount__c,APTS_Yr_3_Amount__c,APTS_Yr_4_Amount__c,APTS_Yr_5_Amount__c,APTS_Term_Type__c,APTS_Bridge__c,Apttus_Config2__StartDate__c
                                                       ,APTS_Bridge_Eligibility__c,APTS_Start_Date__c,APTS_Years_2_Plus_Adjustment__c
                                                       FROM Apttus_Config2__LineItem__c 
                                                       WHERE Apttus_Config2__ConfigurationId__c = :cart.getConfigSO().Id];
        
         for(Apttus_Config2__LineItem__c lineItem : lineItems){          
            dollarAmountsIncomplete=false;
          if(lineItem.APTS_Proposal_Business_Unit__c != 'Tax Professional'&& lineItem.APTS_Proposal_Business_Unit__c != 'Canada' && lineItem.APTS_Proposal_Business_Unit__c != 'SCS'){
              System.debug('Inside Term Number Block');
                if(lineItem.APTS_Contract_Term_Number__c !=null 
                    &&( lineItem.Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c != null
                    && lineItem.Apttus_Config2__ProductId__r.APTS_FL_Renewal_Only_Clone__c == 'Yes'))
              {                       
                system.debug('KS-->APTS_Contract_Term_Number__c '+lineItem.APTS_Contract_Term_Number__c);          
                if(lineItem.APTS_Contract_Term_Number__c > 12){
                    //result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Contract Term must be 1 year for past version products.'));                
                    //result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Contract Term must be 1 year for past version products : \''+lineItem.Apttus_Config2__ProductId__r.Name  +'\' '));
                     result.Messages.add(new ApexPages.Message(ApexPages.Severity.INFO, 'Do not create a multi year contract for expired version except for fiscal filers : \''+lineItem.Apttus_Config2__ProductId__r.Name  +'\' '));
                    //result.isSuccess = false;                  
                    //return result; 
                }
              }
              
                if(lineItem.APTS_Contract_Term_Number__c !=null 
                && lineItem.APTS_Renewal_Type__c !=null && lineItem.APTS_Renewal_Type__c=='Evergreen')                  
              {                       
                system.debug('KS-->APTS_Contract_Term_Number__c '+lineItem.APTS_Contract_Term_Number__c);          
                if(lineItem.APTS_Contract_Term_Number__c > 12){             
                    result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, Label.APTS_ValidationCallbackMessage + '\''+lineItem.Apttus_Config2__ProductId__r.Name  +'\' '));
                    result.isSuccess = false;                  
                    return result; 
                }
              }
              if(lineItem.APTS_Contract_Term_Number__c !=null && (lineItem.Apttus_Config2__LineStatus__c == 'New' || lineItem.Apttus_Config2__LineStatus__c == 'Renewed')){
                 if(lineItem.APTS_Contract_Term_Number__c==36){
                     if((lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c==null) || (lineItem.APTS_Yr_2_Amount__c==null && lineItem.APTS_Yr_3_Amount__c!=null))
                        dollarAmountsIncomplete=true;
                 }else if(lineItem.APTS_Contract_Term_Number__c==48){
                      if((lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null) && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null)){
                          dollarAmountsIncomplete=true;
                      }
                 }else if(lineItem.APTS_Contract_Term_Number__c==60){
                      if((lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null) && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null || lineItem.APTS_Yr_5_Amount__c==null)){
                           dollarAmountsIncomplete=true;
                      }
                 }
              }
            }
            //DOC-7883 Roma Starts
              if(lineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional'){ 
                    
                    if((lineItem.APTS_Contract_Term_Number__c ==null || String.valueOf(lineItem.APTS_Contract_Term_Number__c) =='' ||lineItem.Apttus_Config2__ChargeType__c !='Subscription Fee' ) && (lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null)){
                        dollarAmountsIncomplete=true;
                    }
                    else{  
                        if(lineItem.APTS_Contract_Term_Number__c !=null && lineItem.Apttus_Config2__LineStatus__c != null && (lineItem.Apttus_Config2__LineStatus__c == 'New' || lineItem.Apttus_Config2__LineStatus__c == 'Renewed')){
                            if(lineItem.APTS_Contract_Term_Number__c==12){
                                if(lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null)
                                    dollarAmountsIncomplete=true;                                
                            }                            
                            else if(lineItem.APTS_Contract_Term_Number__c==24){
                                if(lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null)
                                    dollarAmountsIncomplete=true;                                
                            }                            
                            else if(lineItem.APTS_Contract_Term_Number__c==36){
                                if((lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c==null) || (lineItem.APTS_Yr_2_Amount__c==null && lineItem.APTS_Yr_3_Amount__c!=null) || (lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null))
                                    dollarAmountsIncomplete=true;
                            }
                            else if(lineItem.APTS_Contract_Term_Number__c==48){
                                system.debug('APTS_Contract_Term_Number__c--'+lineItem.APTS_Contract_Term_Number__c);
                                if(((lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null) && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null)) || lineItem.APTS_Yr_5_Amount__c!=null ){
                                    dollarAmountsIncomplete=true;
                                    system.debug('APTS_Contract_Term_Number__c--'+lineItem.APTS_Contract_Term_Number__c);
                                }
                            }else if(lineItem.APTS_Contract_Term_Number__c==60){
                                if((lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null) && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null || lineItem.APTS_Yr_5_Amount__c==null)){
                                    dollarAmountsIncomplete=true;
                                }
                            }
                        } 
                    }  
                    //DOC-9921,DOC-9923 : Added by Nandha : Starts Here
                    if(lineItem.APTS_Term_Type__c != NULL){ 
                        if(lineItem.APTS_Bridge__c == '1 Month' || lineItem.APTS_Bridge__c == '2 Months' || lineItem.APTS_Bridge__c == '3 Months' || lineItem.APTS_Bridge__c == '4 Months' || lineItem.APTS_Bridge__c == '5 Months' || lineItem.APTS_Bridge__c == '6 Months' || lineItem.APTS_Bridge__c == '7 Months' || lineItem.APTS_Bridge__c == '8 Months' || lineItem.APTS_Bridge__c == '9 Months'){
                            bridgemonths = integer.valueof(lineItem.APTS_Bridge__c.left(1));
                        }else if(lineItem.APTS_Bridge__c == '10 Months' || lineItem.APTS_Bridge__c == '11 Months'){
                            bridgemonths = integer.valueof(lineItem.APTS_Bridge__c.left(2));
                        }
                        if((lineItem.APTS_Term_Type__c == 'Co-Term' || lineItem.APTS_Term_Type__c == 'Future Start Date and Co-Term') && lineItem.Apttus_Config2__StartDate__c != NULL && lineItem.Apttus_Config2__EndDate__c != NULL && bridgemonths == NULL && (((lineItem.Apttus_Config2__StartDate__c.monthsBetween(lineItem.Apttus_Config2__EndDate__c)) + 1) > 11)){
                            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'End Date for a Co-term must be less than a year. Please adjust End Date.'));
                            result.isSuccess = false;  
                            return result;
                        }
                        else if(lineItem.APTS_Term_Type__c == 'Co-Term' && lineItem.APTS_Bridge__c != NULL && (lineItem.APTS_Bridge__c == '1 Month' || lineItem.APTS_Bridge__c == '2 Months' || lineItem.APTS_Bridge__c == '3 Months' || lineItem.APTS_Bridge__c == '4 Months' || lineItem.APTS_Bridge__c == '5 Months' || lineItem.APTS_Bridge__c == '6 Months' || lineItem.APTS_Bridge__c == '7 Months' || lineItem.APTS_Bridge__c == '8 Months' || lineItem.APTS_Bridge__c == '9 Months' || lineItem.APTS_Bridge__c == '10 Months' || lineItem.APTS_Bridge__c == '11 Months')){ 
                            result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'Bridge is not applicable with Co-term. Please select Term Type= Future Start Date and Co-Term'));
                            result.isSuccess = false;  
                            return result;
                        }
                        else if(lineItem.APTS_Term_Type__c == 'Future Start Date and Co-Term' && lineItem.Apttus_Config2__StartDate__c != NULL && lineItem.APTS_Bridge__c != NULL){ 
                            if(lineItem.Apttus_Config2__StartDate__c != NULL && bridgemonths != NULL && lineItem.Apttus_Config2__StartDate__c != System.Date.today().addMonths(1).addMonths(bridgemonths).toStartOfMonth()){
                                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'Please select Start Date which is 1st of the Month after Bridge Period Ends'));
                                result.isSuccess = false;  
                                return result;
                            }
                            else if(lineItem.Apttus_Config2__StartDate__c != NULL && lineItem.Apttus_Config2__EndDate__c != NULL && bridgemonths != NULL && ((lineItem.Apttus_Config2__StartDate__c.monthsBetween(lineItem.Apttus_Config2__EndDate__c) + 1 + bridgemonths) > 11)){
                                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'Please select End Date which do not exceed more than 11 Months from the Bridge Start Date'));
                                result.isSuccess = false;  
                                return result;
                            }
                        }
                    }
                    //DOC-9921,DOC-9923 : Added by Nandha : Ends Here
                    
                    //Start: Added by Kruti Shah (DOC-10107)
                    System.debug('KS-->lineItem.APTS_Bridge__c '+lineItem.APTS_Bridge__c);
                    System.debug('KS-->lineItem.APTS_Bridge_Eligibility__c '+lineItem.APTS_Bridge_Eligibility__c);
                    
                    if(lineItem.APTS_Bridge__c != null && lineItem.APTS_Bridge_Eligibility__c != null 
                       && lineItem.APTS_Bridge_Eligibility__c == 'Yes' && restrictedBridgeValues.contains(lineItem.APTS_Bridge__c) ){
                           if(bridgeDaysProductNames==null)
                               bridgeDaysProductNames=lineItem.Apttus_Config2__ProductId__r.Name;
                           else if(!bridgeDaysProductNames.contains(lineItem.Apttus_Config2__ProductId__r.Name))
                               bridgeDaysProductNames=bridgeDaysProductNames+','+lineItem.Apttus_Config2__ProductId__r.Name;
                       }
                    
                    if(bridgeDaysProductNames != null){
                        System.debug('KS--> Inside Bridge Validation for TAx Professional');
                        result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, 'Bridge for 7/14/28 days not applicable for \''+bridgeDaysProductNames  +'\' '+'. Please reselect Bridge in Months or select "None" and Reprice."'));
                        result.isSuccess = false;                  
                        return result;
                    }
                    //End: Added by Kruti Shah (DOC-10107)                 
          }
          //Added as part of DOC-12660 for Risk Spree Wave2
          if(lineItem.APTS_Proposal_Business_Unit__c != null && System.Label.Risk_PBUs.contains(lineItem.APTS_Proposal_Business_Unit__c)){
              System.debug('Inside Risk Block');
              if((lineItem.APTS_Term_Type__c != NULL && lineItem.APTS_Term_Type__c == 'Delivery Date') && lineItem.APTS_Start_Date__c == NULL){
                  result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'Please ensure Start Date is populated as Term Type selected is Delivery Date'));
                  result.isSuccess = false;  
                  return result;
              }
          }          
          if(lineItem.APTS_Proposal_Business_Unit__c == 'Canada' || lineItem.APTS_Proposal_Business_Unit__c == 'SCS'){ 
          System.debug('Inside Canada or SCS validation');
          //Added as part of DOC-13241
              if(lineItem.APTS_Years_2_Plus_Adjustment__c != NULL && lineItem.APTS_Yr_2_Amount__c != NULL){
                  result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error,'You must use either YOY 2+% or the Ramped Pricing fields. Please update your line items accordingly.'));
                  result.isSuccess = false;  
                  return result;
              }
              if((lineItem.APTS_Contract_Term_Number__c ==null || String.valueOf(lineItem.APTS_Contract_Term_Number__c) =='') && (lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null)){
                        dollarAmountsIncomplete=true;
                    }
                    else{  
                        if(lineItem.APTS_Contract_Term_Number__c !=null && lineItem.Apttus_Config2__LineStatus__c != null && (lineItem.Apttus_Config2__LineStatus__c == 'New' || lineItem.Apttus_Config2__LineStatus__c == 'Renewed')){
                            if(lineItem.APTS_Contract_Term_Number__c==12){
                                if(lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null)
                                    dollarAmountsIncomplete=true;                                
                            }                            
                            else if(lineItem.APTS_Contract_Term_Number__c==24){
                                if(lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null)
                                    dollarAmountsIncomplete=true;                                
                            }                            
                            else if(lineItem.APTS_Contract_Term_Number__c==36){
                                if((lineItem.APTS_Yr_2_Amount__c!=null && lineItem.APTS_Yr_3_Amount__c==null) || (lineItem.APTS_Yr_2_Amount__c==null && lineItem.APTS_Yr_3_Amount__c!=null) || (lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null))
                                    dollarAmountsIncomplete=true;
                            }
                            else if(lineItem.APTS_Contract_Term_Number__c==48){
                                system.debug('APTS_Contract_Term_Number__c--'+lineItem.APTS_Contract_Term_Number__c);
                                if(((lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null) && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null)) || lineItem.APTS_Yr_5_Amount__c!=null ){
                                    dollarAmountsIncomplete=true;
                                    system.debug('APTS_Contract_Term_Number__c--'+lineItem.APTS_Contract_Term_Number__c);
                                }
                            }else if(lineItem.APTS_Contract_Term_Number__c==60){
                                if((lineItem.APTS_Yr_2_Amount__c!=null || lineItem.APTS_Yr_3_Amount__c!=null || lineItem.APTS_Yr_4_Amount__c!=null || lineItem.APTS_Yr_5_Amount__c!=null) && (lineItem.APTS_Yr_2_Amount__c==null || lineItem.APTS_Yr_3_Amount__c==null || lineItem.APTS_Yr_4_Amount__c==null || lineItem.APTS_Yr_5_Amount__c==null)){
                                    dollarAmountsIncomplete=true;
                                }
                            }
                        } 
                    }
          
          }
          if(dollarAmountsIncomplete){
                result.Messages.add(new ApexPages.Message(ApexPages.Severity.Error, Label.APTS_MultiTieredPricingIncomplete));
                result.isSuccess = false;                  
                return result;
             }
        }
        return result;
    }
    
}