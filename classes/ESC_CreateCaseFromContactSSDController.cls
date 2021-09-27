public without sharing class ESC_CreateCaseFromContactSSDController {


public LCRM_Contact_SSD__c ObjConSSD;
public Id contactSSDId{get;set;}
public string callfunc{get;set;}
public Case oCaseSSD{get;set;}



    public ESC_CreateCaseFromContactSSDController(ApexPages.StandardSetController controller) {

        contactSSDId=ApexPages.currentPage().getParameters().get('id');

    }
    public ESC_CreateCaseFromContactSSDController(ApexPages.StandardController controller) {

        contactSSDId=ApexPages.currentPage().getParameters().get('id');

    }


      
 public PageReference CreateCase(){
   
        ObjConSSD=[Select Id,LCRM_Contact__c,LCRM_SAP_Account_Number__c,LCRM_Contact__r.accountid From LCRM_Contact_SSD__c where Id =: contactSSDId];
        String curUserTimeZone = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId()].TimeZoneSidKey;
        
        List<businesshours> curUserBH = [select TimeZoneSidKey, name from businesshours where TimeZoneSidKey=:curUserTimeZone limit 1];
        
        oCaseSSD = new Case();
        List<ESC_CasefromContactFieldValueList__c> cc= ESC_CasefromContactFieldValueList__c.getall().values();
        String recordtypeId ='';
        String rectype='';
        String bhrs='';
        rectype = ESC_SegmentregionUtility.getDetailInfo(ObjConSSD.LCRM_Contact__c,'Rectype');
        //bhrs = ESC_SegmentregionUtility.getDetailInfo(ObjConSSD.LCRM_Contact__c,'BusHrs');
        if(rectype!=''){
            recordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(rectype).recordTypeId;
        }
        for(ESC_CasefromContactFieldValueList__c c:cc){
        
           if(c.Name=='RecordTypeId'){
             if(recordtypeId ==''){
             recordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(c.ESC_Value__c).RecordTypeId;
             }
             c.ESC_Value__c=recordtypeId;
           }
        /*  if(c.Name=='Business_Unit__c'){
             BusinessHours bh = [select id from businesshours where Name=: c.ESC_Value__c limit 1];
             oCase.BusinessHoursId=bh.Id;
          }
         */ 
          oCaseSSD.put(c.Name,c.ESC_Value__c);
          
        }
        if(!LCRMGenericComponent.isLotusUser()){
       if(bhrs ==''){
        if(curUserBH.size()>0){
            oCaseSSD.BusinessHoursId = curUserBH[0].Id;
        }
        }else{
        oCaseSSD.BusinessHoursId = bhrs;
        }
        }
        oCaseSSD.AccountId = ObjConSSD.LCRM_Contact__r.accountid;
        oCaseSSD.ContactId = ObjConSSD.LCRM_Contact__c;
        oCaseSSD.Contact_Source_System__c=ObjConSSD.Id;
        oCaseSSD.USL_SAP_Account_Number__c=ObjConSSD.LCRM_SAP_Account_Number__c;
        if(!LCRMGenericComponent.isLotusUser()){
        oCaseSSD=GLIGenericUtilityHelper.setGLI(oCaseSSD);
        }else{
            if(oCaseSSD.Sales_Org__c==null){
                oCaseSSD.Sales_Org__c='GLI';
            }
        }
        
        
         
        //system.debug('oCase.Sales_Org__c****'+oCase.Sales_Org__c);
        //system.debug('oCase.Is_GLI__c****'+oCase.Is_GLI__c);
        try{
        insert oCaseSSD;
        }
        catch(Exception ex)
        {  ApexPages.addMessages(ex);return null; }
        callfunc='<script> OpenUrl(); </script>';
        return null;
      // return new PageReference('/'+contactId);
      
    }
}