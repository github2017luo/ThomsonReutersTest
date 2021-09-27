/**
 * comment: MexicoUtility 
 * @description : LaTam Utility Class 
 *
 */
public class MexicoUtility {   
  	/**
     * comment : classBasedOrgValues method
     * @description : This method shares the metadata from custom metadata
     * @param custommetadataRecordName : custommetadataRecordName , custom metadata recordname passed from other apex class 
     * @param fieldName : sles org / businessUnit
     * @return salesorgorbusinessunit values 
     */
    
    public static Map<String,String> classBasedOrgValues(String custommetadataRecordName,String fieldName){
        Map<String,String> genericMap = new Map<String,String>();
        Map<String,String> salesOrgMap = new Map<String,String>();
        Map<String,String> businessUnitMap = new Map<String,String>();
        //Map<String,String> taxNumberTypeMap = new Map<String,String>();
        if(fieldName == 'Sales_Org__c'){
            
            
            LaTam_Mexico_Static_Values__mdt salesOrgStaticValue = LaTam_Mexico_Static_Values__mdt.getInstance(custommetadataRecordName);
            //system.debug('staticValues'+salesOrgStaticValue.Sales_Org__c);
            List<String> salesOrgList = (salesOrgStaticValue.Sales_Org__c).split(',');
            
            
            for(String st : salesOrgList){
                salesOrgMap.put(st,st);
            }
            //system.debug(salesOrgMap.size());
            //system.debug('SALES ORG MAP '+salesOrgMap);
            if(salesOrgMap.size() > 0 ){
                genericMap.putAll(salesOrgMap);
            }
            
        }
        else if(fieldName == 'Business_Unit__c'){
            LaTam_Mexico_Static_Values__mdt salesOrgStaticValue = LaTam_Mexico_Static_Values__mdt.getInstance(custommetadataRecordName);
            //system.debug('staticValues'+salesOrgStaticValue.Business_Unit__c);
            List<String> salesOrgList = (salesOrgStaticValue.Business_Unit__c).split(',');
            
            
            for(String st : salesOrgList){
                businessUnitMap.put(st,st);
            }
            //system.debug(businessUnitMap.size());
            //system.debug('businessUnitMap MAP '+businessUnitMap);
            if(businessUnitMap.size() > 0 ){
                genericMap.putAll(businessUnitMap);
            }
        }        
        
        return genericMap;
    }
    
}