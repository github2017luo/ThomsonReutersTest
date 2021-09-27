/**********************************
Class Name:ESCCreateCaseFromContactConroller 
Purpose:Used in by Page "ESCCreateCaseFromContact" to Create Case from Contact related list
Author:Mousumi/Rupesh/Manish
Date Created:08/05/2017
Date Updated:V0:
***********************************/


public without sharing class ESC_CreateCaseFromContactController {
    public Contact objCon;
    public Id contactId{get;set;}
    public string callfunc{get;set;}
    public Case oCase{get;set;}
    
    public ESC_CreateCaseFromContactController(ApexPages.StandardSetController controller) {
    /*List<String> contactfields= new List<String>();
    contactfields.add('AccountId');
    controller.AddFields(contactfields);*/
        contactId=(String)(String.escapesinglequotes(ApexPages.currentPage().getParameters().get('id')));
    }
    
    //Action Funtion called on the VF page load
    
    public PageReference createCase(){
        List<User> userList = new List<User>();
        List<businesshours> curUserBH = new List<businesshours>();
        //Added for DSS-9111 New Service case lex button for lightning
        if(UserInfo.getUiThemeDisplayed() =='Theme4t' || UserInfo.getUiThemeDisplayed() =='Theme4d'||UserInfo.getUiThemeDisplayed() =='Theme4u')  {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, system.label.Case_Error_message));         
            return null;
          }
        else{ 
            if( Schema.sObjectType.Contact.isAccessible()){  
                objCon=[Select Id,AccountId From Contact where Id =: contactId];
            }
            Userlist = [Select TimeZoneSidKey,sub_bu__c from User where id =: USerInfo.getUserId()];
            //Get User's Timezone Associated Active business hours onto the newly created case
            if(Schema.sObjectType.businesshours.isAccessible()){
                curUserBH = [select TimeZoneSidKey,isactive, name from businesshours where TimeZoneSidKey=:Userlist[0].TimeZoneSidKey
                    and isactive=true   limit 1];
            }
            oCase = new Case();
            List<ESC_CasefromContactFieldValueList__c> cc= ESC_CasefromContactFieldValueList__c.getall().values();
            String recordtypeId ='';
            String rectype='';
            String bhrs='';
            rectype = ESC_SegmentregionUtility.getDetailInfo(contactId,'Rectype');
        //bhrs = ESC_SegmentregionUtility.getDetailInfo(contactId,'BusHrs',null);
            if(rectype!=''){
                recordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(rectype).recordTypeId;
            }
            for(ESC_CasefromContactFieldValueList__c c:cc){
            
                if(c.Name=='recordTypeId'){
                    if(recordtypeId ==''){
                    recordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(c.ESC_Value__c).recordTypeId;
                    }
                    c.ESC_Value__c=recordtypeId;
                }            
                oCase.put(c.Name,c.ESC_Value__c);
            
            }
        
            oCase.AccountId = objCon.AccountId;
            oCase.ContactId = objCon.Id;
            if(!LCRMGenericComponent.isLotusUser() && !(Userlist[0].Sub_bu__c == 'Elite')){
                if(bhrs =='' && curUserBH.size()>0){        
                    oCase.BusinessHoursId = curUserBH[0].Id;
                }
                else{
                    oCase.BusinessHoursId = bhrs;
                }
                oCase=GLIGenericUtilityHelper.setGLI(oCase);
            }
            else{
                if(oCase.Sales_Org__c==null){
                    oCase.Sales_Org__c='GLI';
                }
            }
            try{
                if(Schema.sObjectType.Case.isCreateable()){
                    insert oCase;
                }
            }
            catch(Exception ex)
            {  
                ApexPages.addMessages(ex);
                return null;
            }
            callfunc='<script> OpenUrl(); </script>';
            return null;
         //return new PageReference('/'+oCase.Id);
       } 
    }
}