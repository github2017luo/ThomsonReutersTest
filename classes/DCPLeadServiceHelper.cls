/**
* @file name          : DCPLeadServiceHelper
* @description        : This class helper class for DCPLeadService class
* @author             : Servendra Kumar
* @group              : TR
* @last modified by   : Servendra Kumar
* @last modified on   : 05/20/2021
* @modification log   : CHANGE HISTORY
* =============================================================================
* Date         Name               JIRA         Description
* 05/20/2021   Servendra Kumar    DCP-1678     Created 
* =============================================================================
**/
public with sharing class DCPLeadServiceHelper {

    public static Lead lead = new Lead();
    
    /**  
    *  @description  firstString - From list of values it will return first value
    *  @param anyStringList : this will holds list of string 
    *  @return string from that list of values - first value  
    **/    
    public static String firstString(LIST<string> anyStringList){
        
         if(!anyStringList.isEmpty()){
            return anyStringList[0];
        }
        
        return null;
    }
    
    
    /**
    *  @description  getValuesFromStaticValuesCs - get values from custom settings  
    *  @param csName : string for custom settings name 
    *  @return string return type 
    **/    
    
    public static string getValuesFromStaticValuesCs(string csName){
        
        if(Static_Values__c.getAll().containsKey(csName)){
           return  Static_Values__c.getAll().get(csName).Value__c;
        }        
        return null;        
    }
    
    /**
    *  queryLeadDetails: Common Method to query lead details based on email ID and cart ID
    *  @input email ID, cart ID, boolean:isCreated, @returns List of Lead
    *  @description  queryLeadDetails  -  query lead details 
    *  @param emailIdList : lead string  
    *  @param cartList : Cart details 
    *  @param isCreated : cart created Boolean 
    *  @return : LIST<Lead> all leads 
    **/     
    public static List<Lead> queryLeadDetails(List<string> emailIdList, List<string> cartList,boolean isCreated){
        List<Lead> leadInfo= new List<Lead>();
                    
        system.debug(loggingLevel.INFO,'DCP cart List....'+cartList);
         
        if(isCreated){
            if (Schema.sObjectType.Lead.isAccessible()){
                leadInfo = [SELECT Id, Name,firstname,city,street,state ,country, postalcode, Lead_Region__c, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c,Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c from
                           Lead WHERE ( Email In: emailIdList OR Product_Configuration__c IN: cartList) AND Status != 'Disqualified' AND isConverted = false ORDER BY createdDate DESC];
            
            }
        }else{
            if (Schema.sObjectType.Lead.isAccessible()){  
                system.debug(loggingLevel.INFO,'lead id from PE'+emailIdList);
                leadInfo = [SELECT Id, Name,firstname,city,street,state ,Lead_Region__c,country,postalcode, lastname, Email,phone, isconverted, convertedAccountid, convertedcontactid,Product_Configuration__c, convertedopportunityId,company, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Country__c, Billing_Zip__c,SAPAccountNumber__c,TRstore_Billadd_differenceto_shipping__c,ShipToSSD_TRStore__c, Market_Segment__c,Lead_Microsite__c,Shipping_Phone__c,Shipping_FirstName__c, Shipping_LastName__c,Billing_Street_2__c,Shipping_Street_2__c from 
                            Lead WHERE Id In: emailIdList AND Product_Configuration__c IN: cartList ORDER BY createdDate DESC] ;
            }
        }
        
        system.debug(LoggingLevel.Info,'leadInfo'+leadInfo);
        return leadInfo;
        
    }
    /**
    *  mapCustomerDetails : map customer details on the lead fields.
    *  @input PlatForm DCPLeadRequestHandler   
    *  @description  mapCustomerDetails - map customer details  
    *  @param leadInfo : main json 
    *  @return : lead
    *   
    **/
    public static Lead mapCustomerDetails(DCPLeadRequestHandler.DCPCustomerDetails leadInfo){ 
        if(leadInfo != null){       
            lead.Is_GLI__c = true; 
            lead.firstname = leadInfo.firstName;
            lead.lastname = leadInfo.lastName;
            lead.Email = leadInfo.businessEmail;   
            lead.leadSource='Website';     
            lead.sales_org__c='GLI';  
            lead.Shipping_Phone__c = leadInfo.shippingPhoneNumber;
            lead.Operating_Unit__c = 'Print';
            
            system.debug(LoggingLevel.Info,'leadInfo.businessPhoneNumber..........'+leadInfo.businessPhoneNumber);
            if( leadInfo.businessPhoneNumber != null && leadInfo.businessPhoneNumber != ''){
                lead.MobilePhone = leadInfo.businessPhoneNumber;
                lead.phone = leadInfo.businessPhoneNumber;
            }
            
            if(leadInfo.shippingFirstName != null){
                lead.Shipping_FirstName__c = leadInfo.shippingFirstName;  
            }
            if(leadInfo.shippingLastName != null){
                lead.Shipping_LastName__c = leadInfo.shippingLastName;  
            }
            if(leadInfo.isPhysicalSameAsBillingAddress != null){
                lead.TRstore_Billadd_differenceto_shipping__c = !(leadInfo.isPhysicalSameAsBillingAddress);  
            }
            if(Static_Values__c.getAll().get('LeadRecordTypeName') != null){
                string rtName= Static_Values__c.getAll().get('LeadRecordTypeName').value__c;
                lead.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            }    
            /*  if(!aemConnectUsers.isEmpty()){
                lead.ownerId = aemConnectUsers[0].id; 
            }*/ 
        }
        mapOrganizationDetails(leadInfo);
        return lead;
    }
    /**
    *  mapOrganizationDetails : map organization details and shipping details on the lead fields.
    *  @input PlatForm DCPLeadRequestHandler.DCPCustomerDetails   
    *  @description  mapOrganizationDetails - Map the lead organization details 
    *  @param leadInfo : Parameter to have main lead json 
    *    
    **/
    private static void mapOrganizationDetails(DCPLeadRequestHandler.DCPCustomerDetails leadInfo){
        
        if(leadInfo.organizationDetails != null ) {
            DCPLeadRequestHandler.DCPLAccountDetails accountdetails = leadInfo.organizationDetails;       
            lead.SAPAccountNumber__c = accountdetails.AccountANumber;
            lead.company = accountdetails.organizationName;
            
            if(accountdetails.organizationType != null){
                lead.Market_Segment__c = accountdetails.organizationType;
            }
            
            if(accountdetails.billingAddress != null){                       
                DCPLeadRequestHandler.CustomerAddress billingaddress = accountdetails.billingAddress;     
                
                lead.Billing_Street__c = billingaddress.street1;
                lead.Billing_Street_2__c = billingaddress.street2;
                lead.Billing_City__c = billingaddress.city;
                lead.Billing_State__c = billingaddress.state;
                lead.Billing_Country__c = billingaddress.country;
                lead.Billing_Zip__c = billingaddress.zipCode;
                
            }     
        }
        if(leadInfo.shippingAddress != null){                       
            DCPLeadRequestHandler.CustomerAddress shippingAddress = leadInfo.shippingAddress;     
            
            lead.street = shippingAddress.street1;
            lead.Shipping_Street_2__c = shippingAddress.street2;
            lead.city = shippingAddress.city;
            lead.state = shippingAddress.state;
            lead.country = shippingAddress.country;
            lead.postalcode = shippingAddress.zipCode;
            if(shippingAddress.accNumber != null){
                lead.ShipToSSD_TRStore__c = shippingAddress.accNumber;
            }
                    
        }
    }
    

    

    /**
    *  @description  fetchLangParams - main method to get Lang Main param 
    *  @param lang : param to get the lang 
    *  @return string 
    **/
    public static string fetchLangParams(string lang){        
        return (Static_Values__c.getAll().containsKey(lang))? Static_Values__c.getAll().get(lang).Value__c : 'English';                        
    }

    /**
    *  mapLeadrecId : maps the Lead id based on email and cart id, if both matches we need to get that lead id.
    *  @input PlatForm DCPLeadRequestHandler   
    *  @description  mapLeadrecId - this is the method map the existing lead  
    * @param emailIds
    * @param cartIds
    *  @return
    *    
    **/
    public static id mapLeadrecId(LIST<String> emailIds, LIST<String> cartIds){
        id leadIdP1;
        id leadIdP2;
        id leadIdP3;       
        string serviceEmail =  firstString(emailIds);
        string serviceCartId = firstString(cartIds);       
        for(Lead l: queryLeadDetails(emailIds, cartIds,true)){
            if(l.email == serviceEmail  && l.Product_Configuration__c == serviceCartId && leadIdP1 == null){
                leadIdP1 = l.id;
                break;
            }else if(l.Product_Configuration__c == serviceCartId && leadIdP2  == null) {
                leadIdP2 = l.id;
            }else if(leadIdP3 == null){
                leadIdP3 = l.id;
            }
        }
         
        return mapFinalLeadId(leadIdP1 , leadIdP2, leadIdP3);
         
    }
    
    /** 
    *  @description  mapFinalLeadId - here we are mapping Lead ids from above 3 lead ids
    *  @param leadIdP1 : first Lead id
    *  @param leadIdP2 : Second Lead id
    *  @param leadIdP3 : Third Lead id
        @return
    *  
    *    
    **/     
    public static Id mapFinalLeadId(id leadIdP1, id leadIdP2, id leadIdP3){
        
        if(leadIdP1 != null || leadIdP2 != null || leadIdP3 != null){
            return ((leadIdP1 != null)? leadIdP1 :((leadIdP2 != null)? leadIdP2 : leadIdP3));
        }
        return null;
        
    }
}