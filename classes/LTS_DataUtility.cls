/**
 * @File Name          : LTS_DataUtility.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2/18/2020, 8:09:34 PM
 * @Modification Log   : 
 * Ver       Date            Author              Modification
 * 1.0    2/18/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public without sharing class LTS_DataUtility {
    
    public boolean serviceError = false;
    
    
    @AuraEnabled(cacheable=true)
    public static List<String> getCountryCode() {
        List<String> countrycodestring = new List<String>();
        Map<String,String> countryCodeMap = new Map<String,String>();
        List<String> addressString = new List<String>();
        List<Country__c> lstCountry = New List<Country__c>(Country__c.getAll().values());
        System.debug('lstCountry** '+lstCountry);
        for(Country__c countryCode : lstCountry){
            if(String.isNotBlank(countryCode.Country_Code__c) && String.isNotBlank(countryCode.Name)){
                String mergedString = countryCode.Country_Code__c +'-'+countryCode.Name;
                countrycodestring.add(mergedString);
                countryCodeMap.put(countryCode.Country_Code__c,mergedString);
                
                //addressString.add(countrycode.Name);
            }            
        }
        addressString.addAll(countryCodeMap.values());
        addressString.sort();
        System.debug('@@countryCodeMap '+countryCodeMap);
        //return countryCodeMap;
        return addressString;
    }
    //
    
    //Get State value based on Country Code 
    @AuraEnabled(cacheable=false)
    public static List<String> getStateValues(string countrycodestr){
        List<String> stateString = new List<String>();
        System.debug('countrycodestr@@ '+countrycodestr);
        List<Country_Region__c> lstCountry = New List<Country_Region__c>(Country_Region__c.getAll().values());  
        
        for(Country_Region__c statesIns : lstCountry){
            if(statesIns.Country_Code__c == countrycodestr){
                stateString.add(statesIns.Region_Code__c+'-'+statesIns.Region_Name__c);
            }
            
        }
        System.debug('stateString@@ '+stateString);
        stateString.sort();
        return stateString;
    }
    
    
    
    
    @AuraEnabled(cacheable=true)
    public static  Map<String,String> getAccountAddress(Id recordId) {
        
        Map<String,String> addressMap = new Map<String,String>();
        
           if(Schema.sObjectType.Account.isAccessible() || Schema.sObjectType.Account.isQueryable()){
        List<Account> accountList = [Select id,Name, BillingStreet,Street_Address_2__c ,Street_Address_3__c ,Street_Address_4__c ,Street_Address_5__c ,PO_Box__c ,ANZ_Building__c ,ANZ_DX_Number__c,Suite_Number__c,ANZ_Level__c,ANZ_Suburb__c ,BillingCity,BillingPostalCode,County__c,BillingCountry,BillingState,ECM_Party_ID__c,recordtype.name FROM Account WHERE id=:recordId];
        System.debug(''+accountList);
        if(!accountList.isempty()){
            for(Account recordAcc:accountList ){
                addressMap.put('BillingStreet',recordAcc.BillingStreet);
                addressMap.put('BillingStreet2',recordAcc.Street_Address_2__c);
                addressMap.put('AccountId',recordAcc.Id);
                addressMap.put('County',recordAcc.County__c);
                addressMap.put('BillingPostalCode',recordAcc.BillingPostalCode);
                addressMap.put('BillingCity',recordAcc.BillingCity);
                addressMap.put('BillingCountry',recordAcc.BillingCountry);
                addressMap.put('BillingState',recordAcc.BillingState);
                addressMap.put('Name',recordAcc.Name);
                addressMap.put('PoBox',recordAcc.PO_Box__c);
                addressMap.put('SuiteNumber',recordAcc.Suite_Number__c);
                addressMap.put('ECMPartyID',recordAcc.ECM_Party_ID__c);
                addressMap.put('RecordtypeName',recordAcc.recordtype.name);
                
                
            }
            
        }
           }
        System.debug('addressMap### '+addressMap.size());
        return addressMap;
    }
    /*@AuraEnabled(cacheable=true)
    public static void updateRecord(Account record){
        update record;  
    }
    
   @AuraEnabled(cacheable=true)
    public static List<String> addressCallout(){
        //check BillingStreet and Po-Box empty check
        //check street lenghth validation 
        //check billing city length
        //check billing postal code length
        
        return null;
        
    }*/
    
    //validate address
    @AuraEnabled(cacheable=false)
    public static  List<String> validateAddress(Map<String,String> validateAddressParam){
        System.debug('addressValues'+validateAddressParam.size());
        System.debug('addressValues'+validateAddressParam);
        system.debug('TEST');        
        List<String> stringList = new List<String>();
        /*DataQualityUtil.Address cleanseAddressIns = new DataQualityUtil.Address();
        cleanseAddressIns.Name='Test';
        cleanseAddressIns.City='Mumbai';
        cleanseAddressIns.Country='IN';
        cleanseAddressIns.County='Mumbai';        
        cleanseAddressIns.POBox='400086';
        cleanseAddressIns.PostalCode=validateBillingPostalCode;
        cleanseAddressIns.Province='TEST'; 
        cleanseAddressIns.State = 'Maharashtra';
        cleanseAddressIns.Street=validateBillingStreet;
        DataQualityUtil.Address oAddress;*/
        
        /*BillingStreet: this.impBillingStreet,
            BillingPostalCode: this.impPostalcode,
            BillingCity: this.impBillingCity,
            BillingCountry:this.impBillingCountry,
            BillingState:this.impBillingState,
            BillingCounty:this.impCounty,
            AccountName:this.impName,
            BillingPoBox:this.PoBox,
            BillingProvince:this.impProvince*/
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
            System.debug('@@Address INF :: '+oAddress);         
            stringList.add('Retrieved Result');
            if(oAddress.county != null && oAddress.county != ''){
                stringList.add(oAddress.county); //1-county
            }
           /* if(oAddress.Street != null && oAddress.Street != ''){
                stringList.add(oAddress.Street); //2-Street
            }
            if(oAddress.City != null && oAddress.City != ''){
                stringList.add(oAddress.City); //3-City
            }
            if(oAddress.State != null && oAddress.State != ''){
                stringList.add(oAddress.State); //4-State
            }
            if(oAddress.PostalCode != null && oAddress.PostalCode != ''){
                stringList.add(oAddress.PostalCode); //5-PostalCode
            }
            if(oAddress.Country != null && oAddress.Country != ''){
                stringList.add(oAddress.Country); //6-Country
            }
            if(oAddress.POBox != null && oAddress.POBox != ''){
                stringList.add(oAddress.POBox); //7-POBox
            }*/
            
        }
        catch(Exception e){
            system.debug('EXCEPTION** '+e.getMessage());
            stringList.add(e.getMessage());
        }
        return stringList;
        
        
    }
    
    //populate Bu region 
    @Auraenabled(cacheable = false)
    public static string populateBuRegion(Id accountId,String billingCountry){
        LCRMPopulateBuRegionSegment  accRegionUpdate = new LCRMPopulateBuRegionSegment();
        String buRegion = accRegionUpdate.updateAccountBURegion(accountId,billingCountry);
        return buRegion;
    }
    
     @AuraEnabled(cacheable=true)
    public static  Map<String,String> getLeadAddress(Id recordId) {
        
        Map<String,String> addressMap = new Map<String,String>();
        
        List<Lead> leadList = [Select Id,Address,Billing_Street__c,Billing_City__c,
                               Billing_Country__c,Billing_State__c,Billing_Zip__c,County__c,PO_Box__c,
                               Street,City,Country,countrycode,State,statecode,PostalCode,Address_Override__c FROM Lead WHERE id=:recordId];

        System.debug(''+leadList);
        if(!leadList.isempty()){

        for(Lead recordAcc:leadList ){
                /*addressMap.put('LEADBILLINGSTREET',recordAcc.Billing_Street__c);
                addressMap.put('LEADBILLINGCITY',recordAcc.Billing_City__c);
                addressMap.put('LEADBILLINGCOUNTRY',recordAcc.Billing_Country__c);
                addressMap.put('LEADBILLINGSTATE',recordAcc.Billing_State__c);
                addressMap.put('LEADBILLINGPOSTALCODE',recordAcc.Billing_Zip__c);
                addressMap.put('LEADBILLINGCOUNTY',recordAcc.County__c);
                addressMap.put('LEADBILLINGPOBOX',recordAcc.PO_Box__c);*/
            
            
            //Standard Fields.
               addressMap.put('LEADBILLINGSTREET',recordAcc.Street);
                addressMap.put('LEADBILLINGCITY',recordAcc.City);
                addressMap.put('LEADBILLINGCOUNTRY',recordAcc.Country);
                addressMap.put('LEADBILLINGSTATE',recordAcc.State);
                addressMap.put('LEADBILLINGPOSTALCODE',recordAcc.PostalCode);
                addressMap.put('LEADBILLINGCOUNTY',recordAcc.County__c);
                addressMap.put('LEADBILLINGPOBOX',recordAcc.PostalCode);
                addressMap.put('AddressOverride',String.valueof(recordAcc.Address_Override__c));
                addressMap.put('LEADSTATECODE',recordAcc.statecode);
                addressMap.put('LEADCOUNTRYCODE',recordAcc.countrycode);
              
               
              
           
 }
        }
        System.debug('addressMap### '+addressMap.size());
        return addressMap;
    }

    //Get Excluded countries 
    @AuraEnabled(cacheable=true)
    public static  List<String> getExcludedCountries() {
        List<String> mapExcludeCountry= new List<String>();
        if(Schema.SObjectType.Exclude_Country__mdt.isAccessible()&& Schema.SObjectType.Exclude_Country__mdt.isQueryable()){
            for(LOTUS_Exclude_Country__mdt ec:[Select label,Country_Code__c from LOTUS_Exclude_Country__mdt]){
                mapExcludeCountry.add(ec.Country_Code__c);
            } 
        }
        if(!mapExcludeCountry.isEmpty()){
            return mapExcludeCountry;
        }
        else{
            return null;
        }
    }

    
    
    
}