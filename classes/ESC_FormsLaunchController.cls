public without sharing class ESC_FormsLaunchController {
    public string formname {get;set;}
    public string caseid{get;set;}
    public String formid {get;set;}
    public string onlinesubsformid {get;set;}
    public string printsubsformid {get;set;}
    public string Prepaymentformid {get;set;}
    public string CreditDebitformid {get;set;}
    public string westlawformid {get;set;}
    public string ccformid {get;set;}
    public string retformname {get;set;}
    public boolean isformsubmit{get;set;}
    public List<ESC_Case_Form_Extension__c> formextlist;
    List<Case> Caselist ;
    public boolean iswriteoff {get;set;} 
    public boolean iscc{get;set;}   
    public boolean isnotfederal {get;set;}
    //DSS_6459
    public boolean isFormsSegmentRegionMappingNull{get;set;}
    public List<ESC_FormsSegmentRegionMapping__c> formSegmtRegMappingList{get;set;}
    public Map<string,ESC_FormsSegmentRegionMapping__c> formSegmtRegionMap;
    public string landingURL{get;set;}
    public Map<string,string> formLabelNameMap{get;set;}
    public static boolean accountReceivableAndBillingScreen{get;set;}
    public static boolean accountMaintenanceScreen{get;set;}
    public static boolean ordersScreen{get;set;}
    public static boolean SubscriptionCancellationScreen{get;set;}
    
    public ESC_FormsLaunchController(ApexPages.StandardController controller) {
        iswriteoff = false;
        iscc = false; 
        isnotfederal = true;
        caseList = new List<Case>();
        isformsubmit = false;
        accountReceivableAndBillingScreen = false;
        accountMaintenanceScreen = false;
        ordersScreen = false;
        SubscriptionCancellationScreen = false;
        isFormsSegmentRegionMappingNull=true;      
        formextlist = new List<ESC_Case_Form_Extension__c>();
        formSegmtRegMappingList = new List<ESC_FormsSegmentRegionMapping__c>();
        for(GenerateForm__c GF:[Select id,Name from GenerateForm__c where name ='OnlineSubsLapseForm' OR 
                                name ='PrintSubsLapseForm' OR name='CreditCard/Debit Payment' OR name='Charge Cancellation' OR name='Prepayment Form' OR name='Westlaw Access Control & Preferences']){
            if(GF.name =='OnlineSubsLapseForm')
                onlinesubsformid=GF.Id;
            else if(GF.name =='PrintSubsLapseForm')
                printsubsformid=GF.Id;
            else if(GF.name =='CreditCard/Debit Payment')
                CreditDebitformid=GF.Id;
            else if(GF.name =='Prepayment Form')
                Prepaymentformid=GF.Id;
            else if(GF.name =='Westlaw Access Control & Preferences')
                westlawformid=GF.Id;
            else if(GF.name =='Charge Cancellation')
                ccformid=GF.id;
        }
        
        caseid = controller.getRecord().id;
        system.debug('CreditDebitformid@@'+CreditDebitformid);
        Caselist = [select id,USL_SAP_Account_Number__c,ESC_Product_Segment_Brand__c,BU_Segment__c,Form_Name_New__c,LCRM_Sub_BU__c from case where id =:caseid];
        system.debug('@@ caseList: ' + caseList[0]+ ': ' +caseList[0].BU_segment__c + ': ' + CaseList[0].LCRM_Sub_BU__c + ': ' + CaseList[0].Form_Name_New__c);
        formextlist = [select esc_form__c,esc_form__r.name,recordtype.name from ESC_Case_Form_Extension__c where ESC_Case__c=:caseid];
        system.debug('formext list is'+formextlist);
        if(caseList[0].ESC_Product_Segment_Brand__c == null){
            isFormsSegmentRegionMappingNull = false;
            isformsubmit  = true;
        }
        if(Schema.sObjectType.ESC_FormsSegmentRegionMapping__c.isAccessible() && Schema.sObjectType.ESC_FormsSegmentRegionMapping__c.isQueryable() && (caseList[0].ESC_Product_Segment_Brand__c != null && caseList[0].ESC_Product_Segment_Brand__c != '')){  
            formSegmtRegMappingList =[Select ESC_CSS_Form__c,ESC_CSS_Form__r.name,ESC_LandingURL__c,ESC_Permission_Set_Assigned__c,ESC_Record_Type_Name__c,
                                      ESC_Region__c,ESC_Product_Segment_Brand__c,ESC_Segment__c,ESC_Form_Section__c,ESC_Form_Label_Name__c 
                                      from ESC_FormsSegmentRegionMapping__c 
                                      WHERE ESC_Product_Segment_Brand__c =: caseList[0].ESC_Product_Segment_Brand__c                                                                          
                                      order by ESC_Form_Label_Name__c ,ESC_Form_Section__c];
                                      
        }
        
        system.debug('@@ formsegregionList: ' + formSegmtRegMappingList );
        if(formSegmtRegMappingList.size() >0){
            
            isFormsSegmentRegionMappingNull = false;
            isformsubmit  = true;
            formSegmtRegionMap = new Map<string,ESC_FormsSegmentRegionMapping__c>();
            //formNameMap = new Map<string,string>();
            formLabelNameMap = new Map<string,string>();
            for(ESC_FormsSegmentRegionMapping__c oFormSegRegion: formSegmtRegMappingList){
                if(!formSegmtRegionMap.containskey(oFormSegRegion.ESC_CSS_Form__r.name)){
                    formSegmtRegionMap.put(oFormSegRegion.ESC_CSS_Form__r.name,oFormSegRegion);
                    
                }
                formLabelNameMap.put(oFormSegRegion.ESC_form_Label_Name__c,'');
                
                //set the flag to show screen dynamically based on data in custom object
                if(oFormSegRegion.ESC_Form_Section__c == System.Label.ESC_AccountsReceivableBilling){
                    accountReceivableAndBillingScreen = true;
                }
                if(oFormSegRegion.ESC_Form_Section__c == System.Label.ESC_AccountMaintenance){
                    accountMaintenanceScreen = true;
                }
                if(oFormSegRegion.ESC_Form_Section__c == System.Label.ESC_Orders){
                    ordersScreen = true;
                }
                if(oFormSegRegion.ESC_Form_Section__c == System.Label.ESC_SubscriptionCancellation){
                    SubscriptionCancellationScreen = true;
                }
                
            }
        }
        
        if(formextlist.size() > 0){
           retformname = formextlist[0].esc_form__r.name;
           isformsubmit = true;
           for(ESC_Case_Form_Extension__c caseExtForm: formextlist){
               for(ESC_FormsSegmentRegionMapping__c oFormSegRegion: formSegmtRegMappingList){
                  if((oFormSegRegion.ESC_CSS_Form__r.name == caseExtForm.esc_form__r.name )){
                   if(string.isBlank(oFormSegRegion.ESC_record_Type_Name__c)){
                       formLabelNameMap.put(oFormSegRegion.ESC_Form_Label_Name__c,oFormSegRegion.ESC_Form_Label_Name__c);
                       break;
                   }else if(caseList[0].Form_Name_New__c!=null && caseList[0].Form_Name_New__c.containsIgnoreCase(oFormSegRegion.ESC_record_Type_Name__c)){
                       formLabelNameMap.put(oFormSegRegion.ESC_Form_Label_Name__c,oFormSegRegion.ESC_Form_Label_Name__c);
                       break;
                   }
                   
                   
                  } 
               }
           }
        }
        
        List<PermissionSet> PSList = [SELECT Id FROM PermissionSet where name = 'USL_Service_Charge_cancellation_writeoff_Admin'];
        List<PermissionSetAssignment> PSAList = [Select id from PermissionsetAssignment where AssigneeId =:Userinfo.getUserId() and PermissionSetId =:PSList[0].id];
        List<PermissionSet> PSList1 = [SELECT Id FROM PermissionSet where name = 'USL_Service_Charge_Cancellation_Access'];
        List<PermissionSetAssignment> PSAList1 = [Select id from PermissionsetAssignment where AssigneeId =:Userinfo.getUserId() and PermissionSetId =:PSList1[0].id];
        List < SetupEntityAccess> SEA =[SELECT Id, Parent.Name, Parent.Profile.Name, Parent.Profile.Id FROM SetupEntityAccess WHERE Parent.Profile.Id = :UserInfo.getProfileId()  AND SetupEntityId in (SELECT Id FROM ApexPage WHERE Name IN ('USL_WriteoffPage') AND NamespacePrefix = null)];
        List < SetupEntityAccess> SEA1 =[SELECT Id, Parent.Name, Parent.Profile.Name, Parent.Profile.Id FROM SetupEntityAccess WHERE Parent.Profile.Id = :UserInfo.getProfileId()  AND SetupEntityId in (SELECT Id FROM ApexPage WHERE Name IN ('USL_ChargeCancellation') AND NamespacePrefix = null)];
        if(!PSAList.isempty() || !SEA.isEmpty())
        iswriteoff = true; 
        if(!PSAList1.isempty() ||!SEA1.isEmpty())       
        iscc = true;

    }
    public void displayform(){
        List<Source_System_Detail__c> SSDList = new List<Source_System_Detail__c>();
        formname = Apexpages.currentpage().getparameters().get('formname');
        system.debug('@@ formname' + formname);
        if(formname != null && formname != '' && isFormsSegmentRegionMappingNull){
          formid = [Select id from GenerateForm__c where name =:formname].id;
        }else if(formname != null && formname != '' && !isFormsSegmentRegionMappingNull && !formSegmtRegionMap.isEmpty()){
            formid = formSegmtRegionMap.get(formname)!=null?formSegmtRegionMap.get(formname).ESC_CSS_Form__c:'';
            landingURL = formSegmtRegionMap.get(formname)!=null?formSegmtRegionMap.get(formname).ESC_LandingURL__c:'';
        }
        system.debug('@@ formid && formname && landingURL && sectionName:' + formid + formname + landingURL);
        if(formname == 'IFF Adjustment'){
          if(caselist.size() > 0)
          SSDList = [Select LCRM_Market_Segment__c from Source_System_Detail__c where Source_System_Account_Number__c=:caseList[0].USL_SAP_Account_Number__c];
          if(SSDList.size() > 0){
          if(SSDList[0].LCRM_Market_Segment__c != null && SSDList[0].LCRM_Market_Segment__c.equalsignorecase('Federal Government')){
              isnotfederal = false ;
          }
          }
        }
        string url = '/apex/ESC_FormGenerator?formID='+formid+'&Id='+caseid;
        
    }
}