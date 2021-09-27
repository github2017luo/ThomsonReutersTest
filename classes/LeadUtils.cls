/**
 * Contains methods for Lead Trigger After Event
 * Converts Lead to PPO if web to lead for Practical Law
 *
 * @author  Nandita Shet
 * @version  2013-06-14
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-06-14   Nandita Shet        Created Class and methods for Converting
                                    Lead to PPO coming from Web for Practical Law
 * =============================================================================
 */ 



public class LeadUtils{
 
   public static Map<String,String> mapAccountfields = new Map<String,String>{'Sales_Org__c'=>'Sales Org ' ,
                                                                        'Billing_City__c'=>'Billing City ' ,
                                                                        'Billing_Street__c'=>'Billing Street ' ,
                                                                        'Industry' =>'Industry ',
                                                                        'Customer_Type__c'=>'Customer Type ' ,
                                                                        'Billing_Country__c'=>'Billing Country ' ,
                                                                        'Customer_Class__c'=>'Customer Class ',
                                                                        'Customer_Group__c'=>'Customer Group '};
                                                                        
  public static void ConvertleadtoPPO(List<Lead> listleadtoconvert,Map<Id,Lead> mapleadtoconvert){
    List<Opportunity> listOpportunity = new List<Opportunity>();   
    List<Database.LeadConvert> listdbleadConvert = new List<Database.LeadConvert>();
    Map<Id,Lead> mapLead = new Map<Id,Lead>();
    
    Schema.DescribeSObjectResult Opportunitydescresult = Schema.SObjectType.Opportunity; 
    Map<String,Schema.RecordTypeInfo> rectypeMapByName = Opportunitydescresult.getRecordTypeInfosByName();
    String strOwnerId = '';
    
    
    listleadtoconvert = [Select Id,Name,OwnerID,Owner.email,Owner.name,Account__r.OwnerId,Account__c,Lead_Id__c,
                            Sales_Org__c,Billing_City__c,Billing_Street__c,Industry,Customer_Type__c,
                            Billing_Country__c,Customer_Class__c,Customer_Group__c,Contact__c,Contact__r.Name,Campaign_Code__c from Lead where Id IN : listleadtoconvert];
                            
                            
    for(Lead oLead_convert : listleadtoconvert){ 
        mapLead.put(oLead_convert.Id,oLead_convert);
        String Optyname = 'Trial-'+(oLead_convert.Contact__r.Name!=null && oLead_convert.Contact__r.Name!=''?oLead_convert.Contact__r.Name:oLead_convert.Name)+'-'+(oLead_convert.Campaign_Code__c!=null?String.valueof(oLead_convert.Campaign_Code__c):'');
        strOwnerId  = oLead_convert.OwnerId;System.debug(oLead_convert.Account__c + '=='+checkRequiredFields(oLead_convert)+'****'+strOwnerId+'Owner name'+oLead_convert.Owner.name);
        if(oLead_convert.Account__c!=null && checkRequiredFields(oLead_convert) 
                && (strOwnerId.substring(0,3)=='005' && !oLead_convert.Owner.name.startsWith('Admin')) ){
            Database.LeadConvert dbleadConvert = new Database.LeadConvert();
            dbleadConvert.setLeadId(oLead_convert.Id);
           // dbleadConvert.setOwnerId(oLead_convert.Account__r.OwnerId);
            dbleadConvert.setOwnerId(oLead_convert.OwnerId);
            dbleadConvert.setAccountId(oLead_convert.Account__c);
            dbleadConvert.setOpportunityName(Optyname.right(120));
            if(oLead_convert.Contact__c!=null)
                dbleadConvert.setContactId(oLead_convert.Contact__c);
            dbleadConvert.setConvertedStatus('Converted');
            listdbleadConvert.add(dbleadConvert);
    }
    }
    
     if(!listdbleadConvert.IsEmpty()){
       try{
         List<Database.LeadConvertResult> listLeadConvertResult = Database.convertLead(listdbleadConvert);

         for(Database.LeadConvertResult oLeadConvertResult : listLeadConvertResult){

           if(oLeadConvertResult.success){
             listOpportunity.add(new Opportunity(Id = oLeadConvertResult.getOpportunityId(),RecordTypeId= rectypeMapByName.get('Pre-Pipeline Opportunity').getRecordTypeId(),
                                                 StageName='1%',description  = mapleadtoconvert.get(oLeadConvertResult.getLeadId()).description,
                                                 Source__c = mapleadtoconvert.get(oLeadConvertResult.getLeadId()).LeadSource,
                                                 Type = mapleadtoconvert.get(oLeadConvertResult.getLeadId()).Type__c,
                                                 Status__c = 'Converted'));
                                                 
          
           }else if(!oLeadConvertResult.success){
               for(Integer i=0;i<oLeadConvertResult.errors.size();i++){
                   IntegrationLogger.addmessage(oLeadConvertResult.errors[i].message+'Fields:'+String.join(oLeadConvertResult.errors[i].fields,';'),oLeadConvertResult.leadId,'Lead','','','Web to PPO',false);  
               }
           }
         }
             update listOpportunity;
     
     }catch(Exception Ex){
         String strObjectId = '';

         if(Ex.getTypeName()=='DMLException' || Ex.getTypeName()=='EmailException'){
             strObjectId = Ex.getDmlId(0);
         }else{
             strObjectId = String.valueof(Ex.getLineNumber());
         }
         IntegrationLogger.addmessage(Ex.getMessage(),Ex.getTypeName(),strObjectId ,'','','Web To PPO',false);

     }
     }
   }
   
   
   public static boolean checkRequiredFields(Lead olead){
      
        for(String sfield : mapAccountfields.Keyset()){
           if(olead.get(sfield)==null){ 
             return false;
               
            }
        } 
       return true;
    
    }

    public static void validateLeadAddress(Lead oLead){
            DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
            Lead oClonedLead = oLead.clone();
            oAddress.Name = oClonedLead.Company;
            oAddress.Street = oClonedLead.Billing_Street__c;
            oAddress.City = oClonedLead.Billing_City__c;
            oAddress.State = oClonedLead.Billing_State__c;
            oAddress.PostalCode = oClonedLead.Billing_Zip__c;
            oAddress.Country = oClonedLead.Billing_Country__c;
            oAddress.County = oClonedLead.County__c;
            oAddress.Province = '';
            oAddress.POBox = oClonedLead.PO_Box__c;
            system.debug('oAddress:'+oAddress);
            oAddress = DataQualityUtil.cleanseAddress(oAddress);
            system.debug('oAddress post cleanse:'+oAddress);
            oLead.Billing_Street__c = oAddress.Street;
            oLead.Billing_City__c = oAddress.City;
            oLead.Billing_State__c = oAddress.State;
            oLead.Billing_Zip__c = oAddress.PostalCode;
            oLead.Billing_Country__c = oAddress.Country;
            oLead.County__c = oAddress.County;
            oLead.PO_Box__c = oAddress.POBox;
    }

}