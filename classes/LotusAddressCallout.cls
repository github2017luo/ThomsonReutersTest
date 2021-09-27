/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2020-02-05   Niket Kapasi            Created     
 *
 * Purpose :    To validate address with informatica address doctor using future method. 
 *              If successfully validated then Address_Validate__c is set to true else false                                                    
 * =============================================================================
 */
public without sharing class LotusAddressCallout {
    
    
    public static void validateAddress(List<sobject> sobjectList){
        System.debug('Inside Validate Address Future Callout');
        Set<id> leadIds = new set<id>();
        String ObjectName= sobjectList[0].getSObjectType().getDescribe().getName();
        if(ObjectName == 'Lead'){
            
            for(sobject objIns: sobjectList){
                Lead leadIns = (Lead)objIns;
                leadIds.add(leadIns.id);
            }
            if(!leadIds.isEmpty() && !SYSTEM.isFuture()){
                LotusAddressCallout.checkAddress(leadIds,ObjectName);
            }
            
        }
        
        //return null;
    }
    
    @future(callout = true)
    public static void checkAddress(set<id> Ids,String ObjectName){
    
        String countyName;
        if(SYSTEM.isFuture() && !SYSTEM.isBatch()){
            System.debug('Inside future call for  address validation');
            
            Map<String,String> validateAddressParam = new Map<String,String>();
            List<String> stringList = new List<String>();
            List<lead> updateLeadList = new List<Lead>();
            List<lead> leadRecord = [Select Id,Name,Address,County__c,PO_Box__c,
                                     Street,City,Country,CountryCode,State,StateCode,PostalCode,
                                     Address_Override__c,
                                     Address_validate__c
                                     FROM Lead WHERE id=:Ids and isConverted = false];
            if(!leadRecord.isEmpty()){
                for(Lead leadIns : leadRecord){
                    /*if(String.isNotBlank(leadIns.Street) && String.isNotBlank(leadIns.PostalCode) && String.isNotBlank(leadIns.City) &&
                      String.isNotBlank(leadIns.CountryCode) && string.isNotBlank(leadIns.StateCode)){*/
                          
                    if(String.isNotBlank(leadIns.CountryCode)){

                          validateAddressParam.put('BillingStreet',leadIns.Street);
                          validateAddressParam.put('BillingPostalCode',leadIns.PostalCode);
                          validateAddressParam.put('BillingCity',leadIns.City);
                          validateAddressParam.put('BillingCountry',leadIns.CountryCode);
                          validateAddressParam.put('BillingState',leadIns.StateCode);
                          validateAddressParam.put('BillingCounty',leadIns.County__c);
                          validateAddressParam.put('AccountName',leadIns.Name);
                          validateAddressParam.put('BillingPoBox',leadIns.PO_Box__c);
                          validateAddressParam.put('BillingProvince',leadIns.StateCode);
                    }

                }                
                System.debug('addressValues'+validateAddressParam.size());
                System.debug('addressValues'+validateAddressParam);
                system.debug('TEST');        
                
                DataQualityUtil.Address cleanseAddressIns = new DataQualityUtil.Address();
                cleanseAddressIns.Name=validateAddressParam.get('AccountName');
                cleanseAddressIns.City=validateAddressParam.get('BillingCity');
                cleanseAddressIns.Country=validateAddressParam.get('BillingCountry');
                cleanseAddressIns.County=validateAddressParam.get('BillingCounty');
                cleanseAddressIns.POBox=validateAddressParam.get('BillingPoBox');
                cleanseAddressIns.PostalCode=validateAddressParam.get('BillingPostalCode');
                cleanseAddressIns.Province=validateAddressParam.get('BillingProvince');
                cleanseAddressIns.State =validateAddressParam.get('BillingState');
                cleanseAddressIns.Street=validateAddressParam.get('BillingStreet');
                DataQualityUtil.Address oAddress;
                
                
                try{
                    oAddress = DataQualityUtil.cleanseAddress(cleanseAddressIns); 
                    System.debug('oAddress ' +oAddress);
                    stringList.add('Retrieved Result');
                    if(oAddress.County != null && oAddress.County != ''){
                    countyName = oAddress.County;
                    }                  
                    
                }
                catch(Exception e){
                    system.debug('EXCEPTION** '+e.getMessage());
                    stringList.add(e.getMessage());
                }
                    System.debug('stringList@@ '+stringList+ ' @@End of String');
                    for(Lead leadIns : leadRecord){
                        if(stringList[0].contains('The specified address may not be valid') ||
                           stringList[0].contains('The specified address is not valid')){
                           System.debug('leadIns.Address_Validate__c@@ '+leadIns.Address_Validate__c+ ' @@leadIns.Address_Validate__c');                   
                           leadIns.Address_Validate__c = false;
                           leadIns.Country = leadIns.CountryCode;
                           System.debug('leadIns.Address_Validate__c@@ '+leadIns.Address_Validate__c+ ' @@leadIns.Address_Validate__c');   
                        } 
                        else if(stringList[0].contains('Retrieved Result')){
                            System.debug('leadIns.Address_Validate__c@@ '+leadIns.Address_Validate__c+ ' @@leadIns.Address_Validate__c');   
                            leadIns.Address_Validate__c = true;
                            leadIns.Country = leadIns.CountryCode;
                            System.debug('leadIns.Address_Validate__c@@ '+leadIns.Address_Validate__c+ ' @@leadIns.Address_Validate__c');   
                        }
                        if(String.isnotblank(countyName)){
                            leadIns.County__c = countyName; 
                        }
                        
                        updateLeadList.add(leadIns);                      
                    }
                    if(!updateLeadList.isEmpty()){
                        update updateLeadList;
                    } 
                             
                
            } 
        }
        
    }
}