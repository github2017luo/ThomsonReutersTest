public without sharing class ESC_AssociateAssetLWCController {
    public static Case oCase;
    public static List<Apttus_Config2__AssetLineItem__c> apttusAssetLItemList;
    public static Map<string,Apttus_Config2__AssetLineItem__c> apttusAssetLIMap = new Map<string,Apttus_Config2__AssetLineItem__c>();
    public static List<Source_System_Detail__c> oSSD ;
    public static string caseId;
    public static string validationMsg = '';
    public static boolean isModifySub = false;
    public ESC_AssociateAssetLWCController() {
        apttusAssetLItemList = new List<Apttus_Config2__AssetLineItem__c>();
        oSSD = new List<Source_System_Detail__c>();
        
    }

    
    public static string  dataFactory(string caseId){
        
        if(string.isNotBlank(caseId)){
        
        try{
    if(Schema.sObjectType.Case.isAccessible()){
            
           oCase = [SELECT id,recordTypeId,ESC_EnquiryType__c,LCRM_Sub_Bu__c,BU_Segment__c,Is_ESC_Case__c,ESC_Case_Type__c,ESC_Sub_Type__c,
                      USL_SAP_Account_Number__c ,ESC_Submit_For_Auto_Approval__c,ESC_Total_Net_Price1__c,ESC_Subscription_Start_Date__c,
                      ESC_Suspend_Asset__c,AccountId
                      From Case WHERE id=:caseId and AccountId !=null ];
        }
        
        system.debug('@@ oCase : ' +  oCase);
        if(oCase!=null){
        caseId = oCase.Id;
        if(string.isBlank(oCase.USL_SAP_Account_Number__c) || string.isBlank(oCase.ESC_EnquiryType__c)){
                validationMsg  = System.Label.ESC_SAPAccTypeNullCheck;
                system.debug('');
                return validationMsg;

            }
            
         if(!(oCase.ESC_EnquiryType__c== 'Cancellation' || oCase.ESC_EnquiryType__c== 'Suspend' || oCase.ESC_EnquiryType__c== 'Unsuspend' || oCase.ESC_EnquiryType__c== 'Modify Subscription' || oCase.ESC_EnquiryType__c== 'Modify Future Cancellation' || oCase.ESC_EnquiryType__c== 'Remove Future Cancellation'))
             {
              validationMsg  = System.Label.ESC_TypeCheck;
              return validationMsg;
            }
            if((oCase.ESC_EnquiryType__c== 'Cancellation' || oCase.ESC_EnquiryType__c== 'Suspend' || oCase.ESC_EnquiryType__c== 'Unsuspend' || oCase.ESC_EnquiryType__c== 'Modify Subscription')&& oCase.ESC_Sub_Type__c == null)
             {
              validationMsg  = System.Label.ESC_SubTypeCheck;
              return validationMsg;
            }
            if(oCase.ESC_Suspend_Asset__c){

                validationMsg  = System.Label.ESC_SuspendAsset;
                system.debug('');
                return validationMsg;
            }
            if(oCase.ESC_Submit_For_Auto_Approval__c){

               validationMsg  = System.Label.ESC_SubmitForApprovalErrMsg;
                system.debug('');
                return validationMsg;
            }
            if(oCase.ESC_Subscription_Start_Date__c < Date.Today() && (oCase.ESC_EnquiryType__c =='Cancellation' ||
            oCase.ESC_EnquiryType__c =='Unsuspend' || oCase.ESC_EnquiryType__c =='Suspend')){

                validationMsg = System.Label.ESC_SuscriptionDateErrMsg;
                system.debug('');
                return validationMsg;
            }
            if((oCase.ESC_Subscription_Start_Date__c <= Date.Today() || oCase.ESC_Subscription_Start_Date__c == null) && oCase.ESC_EnquiryType__c =='Modify Future Cancellation'){

                validationMsg = System.Label.ESC_AssetModifyCancellationDateError;
                system.debug('');
                return validationMsg;
            }
           /* if(oCase.ESC_Subscription_Start_Date__c > Date.Today() && (
            oCase.ESC_EnquiryType__c =='suspend')){

                validationMsg = 'Only Immediate suspend date is supported for Suspend type';
                system.debug('');
                return validationMsg;
            }*/
           
          if( oCase.ESC_EnquiryType__c == 'Cancellation')
          {
            //Validation check to make sure thatt he agent select the mandatory fields which will be used for the automatic case closure for Mainly RFA.
            List<Case> lstCase = new List<Case>();
                lstCase.add(oCase);
            Map<Id, string> mapCaseAndError = ESC_Utility.checkValidationErrorsForAutomaticClosure(lstCase);
                if(mapCaseAndError != null && mapCaseAndError.containsKey(oCase.Id))
                {
                    string result = mapCaseAndError.get(oCase.Id);
                    if(string.IsNotBlank(result))
                    {
                        //Show the mandatroy validation message by taking the result label
                       // Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,result));    
                        //IsError = true;
                        validationMsg = result;
                        return validationMsg;
                    }
                } 
                
               }                
            
            
            if(string.isNotBlank(oCase.ESC_EnquiryType__c) && oCase.ESC_EnquiryType__c == 'Modify Subscription' && oCase.ESC_Sub_Type__c == 'Non-Revenue Modification'){
                isModifySub = true;
            }
            if(string.isNotBlank(oCase.ESC_Case_Type__c) && ocase.ESC_Case_Type__c=='Request For Action'
            && string.isNotBlank(oCase.ESC_EnquiryType__c) && (oCase.ESC_EnquiryType__c =='Cancellation' || 
            oCase.ESC_EnquiryType__c =='Unsuspend' || oCase.ESC_EnquiryType__c =='Suspend'|| oCase.ESC_EnquiryType__c== 'Modify Future Cancellation' || oCase.ESC_EnquiryType__c== 'Remove Future Cancellation') || oCase.ESC_EnquiryType__c == 'Modify Subscription' ){
            string AccountId;
                if(Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                    oSSD = [SELECT id,Account_Name__c,LCRM_SAP_Account_Number__c,Source_System_Account_Number__c from Source_System_Detail__c
                        WHERE Source_System_Account_Number__c=: oCase.USL_SAP_Account_Number__c];
                }
                /*if(oSSD !=null && oSSD.size() > 0 ){
                    AccountId = oSSD[0].Account_Name__c;
                }else{
                    AccountId = oCase.AccountId;
                }*/
                if(oCase.ESC_EnquiryType__c == 'Cancellation'  ){
                    if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && oSSD!=null){
                    apttusAssetLItemList = [SELECT id,Name,Apttus_Config2__AccountId__c,Apttus_Config2__StartDate__c,
                                            Apttus_Config2__AssetStatus__c,Apttus_Config2__EndDate__c,Asset_Auto_Number__c,
                                            Apttus_Config2__LineType__c,TAX_APTS_PO_Number__c,APTS_Contract_Number__c,
                                            Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c
                                            FROM Apttus_Config2__AssetLineItem__c 
                                            WHERE APTS_SSD_Sold_To__c = : oSSD[0].id 
                                            AND Apttus_Config2__AssetStatus__c in ( 'Suspended','Activated')
                                            AND Apttus_Config2__LineType__c ='Product/Service'];
                                        }

                }else if(oCase.ESC_EnquiryType__c =='Unsuspend' ){
                    if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && oSSD!=null){
                    apttusAssetLItemList = [SELECT id,Name,Apttus_Config2__AccountId__c,Apttus_Config2__StartDate__c,
                                            Apttus_Config2__EndDate__c,Apttus_Config2__AssetStatus__c,Asset_Auto_Number__c,
                                            Apttus_Config2__LineType__c,TAX_APTS_PO_Number__c,APTS_Contract_Number__c,
                                            Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c
                                            FROM Apttus_Config2__AssetLineItem__c 
                                            WHERE APTS_SSD_Sold_To__c = : oSSD[0].id 
                                            //Apttus_Config2__AccountId__c =:AccountId 
                                            AND Apttus_Config2__AssetStatus__c in ( 'Suspended')
                                            AND Apttus_Config2__LineType__c ='Product/Service']; 
                    
                    }
                }
                    else if (oCase.ESC_EnquiryType__c == 'Suspend' )
                    {
                        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && oSSD!=null){
                    apttusAssetLItemList = [SELECT id,Name,Apttus_Config2__AccountId__c,Apttus_Config2__StartDate__c,
                                            Apttus_Config2__EndDate__c,Apttus_Config2__AssetStatus__c,Asset_Auto_Number__c,
                                            Apttus_Config2__LineType__c,TAX_APTS_PO_Number__c,APTS_Contract_Number__c,
                                            Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c
                                            FROM Apttus_Config2__AssetLineItem__c 
                                            WHERE APTS_SSD_Sold_To__c = : oSSD[0].id 
                                            //Apttus_Config2__AccountId__c =:AccountId 
                                            AND Apttus_Config2__AssetStatus__c ='Activated'
                                            AND Apttus_Config2__LineType__c ='Product/Service']; 
                        
                    }
                    
                    }
                      else if (oCase.ESC_EnquiryType__c == 'Modify Subscription' && oCase.ESC_Sub_Type__c == 'Non-Revenue Modification' )
                    {
                        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && oSSD!=null){
                    apttusAssetLItemList = [SELECT id,Name,Apttus_Config2__AccountId__c,Apttus_Config2__StartDate__c,
                                            Apttus_Config2__EndDate__c,Apttus_Config2__AssetStatus__c,Asset_Auto_Number__c,
                                            Apttus_Config2__LineType__c,TAX_APTS_PO_Number__c,APTS_Contract_Number__c,
                                            Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c
                                            FROM Apttus_Config2__AssetLineItem__c 
                                            WHERE APTS_SSD_Sold_To__c = : oSSD[0].id 
                                            //Apttus_Config2__AccountId__c =:AccountId 
                                            AND Apttus_Config2__AssetStatus__c in ('Activated','Pending Cancellation')
                                            AND Apttus_Config2__LineType__c ='Product/Service']; 
                        
                       }
                    }
                      else if (oCase.ESC_EnquiryType__c == 'Modify Future Cancellation' || oCase.ESC_EnquiryType__c == 'Remove Future Cancellation' )
                    {
                        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && oSSD!=null){
                    apttusAssetLItemList = [SELECT id,Name,Apttus_Config2__AccountId__c,Apttus_Config2__StartDate__c,
                                            Apttus_Config2__EndDate__c,Apttus_Config2__AssetStatus__c,Asset_Auto_Number__c,
                                            Apttus_Config2__LineType__c,TAX_APTS_PO_Number__c,APTS_Contract_Number__c,
                                            Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c
                                            FROM Apttus_Config2__AssetLineItem__c 
                                            WHERE APTS_SSD_Sold_To__c = : oSSD[0].id  
                                            //Apttus_Config2__AccountId__c =:AccountId 
                                            AND Apttus_Config2__AssetStatus__c ='Pending Cancellation'
                                            AND Apttus_Config2__LineType__c ='Product/Service']; 
                        
                    }
                   }
                
                
                system.debug('@@ asset Line item List : ' + apttusAssetLItemList );
                if(apttusAssetLItemList!=null && apttusAssetLItemList.size() > 0){
                //apttusAssetLIMap 
                    for(Apttus_Config2__AssetLineItem__c assetList:apttusAssetLItemList){
                        apttusAssetLIMap.put(assetList.Id,assetList);
                    }
                }else{
                    validationMsg = System.Label.ESC_AssetLIBlank;
                    return validationMsg;
                }
                
                if(oCase.ESC_Subscription_Start_Date__c == null && (oCase.ESC_EnquiryType__c =='Cancellation' || oCase.ESC_EnquiryType__c =='Suspend' || oCase.ESC_EnquiryType__c =='Unsuspend')){
                    if(oCase.ESC_EnquiryType__c =='Cancellation'){
                        validationMsg = System.Label.ESC_ImmediateCancellation;
                    }else if(oCase.ESC_EnquiryType__c =='Suspend'){
                        validationMsg = System.Label.ESC_ImmediateSuspend;
                    }    else{
                        validationMsg = System.Label.ESC_ImmediateUnsuspend;
                    }
                    
                    system.debug('');
                    return validationMsg;
                }
                
    }
    }
    
    }catch(Exception Ex){
        system.debug('@@ Exception in dataFactory method : ' + ex.getMessage());
        validationMsg  = ex.getMessage();
        return validationMsg ;
    }
        }else{
            validationMsg = '';
        
        }
    system.debug('@@ validation msg : ' + validationMsg);
    return validationMsg;
    }
    @AuraEnabled
    public static DataTableWrapper getAssetLineItems(String caseId) {
        DataTableWrapper oDatatableWrapper;
                 try{
                     oDatatableWrapper = new DataTableWrapper();
                     if(caseId != null){
                     
                         string validationMsg = dataFactory(caseId);
                         system.debug('@@ validationMsg');
                       
                        if(validationMsg!='' && validationMsg!=null){
                            oDatatableWrapper.errorMsg = validationMsg;
                            if(validationMsg == System.Label.ESC_ImmediateCancellation || validationMsg == System.Label.ESC_ImmediateSuspend || validationMsg == System.Label.ESC_ImmediateUnsuspend){
                                oDatatableWrapper.ldwList = getColumns();
                                oDatatableWrapper.sobjList = getRecords();
                                oDatatableWrapper.isModifySub  = isModifySub;
                            }
                            
                        } else{
                            oDatatableWrapper.ldwList = getColumns();
                            oDatatableWrapper.sobjList = getRecords();
                            oDatatableWrapper.isModifySub  = isModifySub;
                        }
                     }
                   
               
               }catch(Exception Ex){
                    system.debug('@@ Exception in dgetAssetLineItems method : ' + ex.getMessage());
                    odatatableWrapper.errorMsg = ex.getMessage();
               } 

            
        
        return oDatatableWrapper;
    }

  /*  @AuraEnabled
    public static DataTableWrapper updatedCaseAssetLI(string csAssetId) {
        ESC_Case_Asset_Line_Item__c caseAssetLIObj;
        caseAssetLIObj = [SELECT Name,id,ESC_Case__c,ESC_Asset_Number__c,ESC_Asset_PO_Number__c,ESC_TAX_APTS_PO_Number__c,ESC_Asset_Line_Item__c,ESC_Net_Price__c,ESC_Asset_Line_Item__r.Name,ESC_Asset_Auto_Number__c FROM ESC_Case_Asset_Line_Item__c
                         WHERE id = :csAssetId];
                         
                        return null;
    }*/
    @AuraEnabled
    public static DataTableWrapper getCaseAssetLineItems(List<string> assetIds,string caseId,string value) {
        system.debug('Case Id : ' +caseId);
        system.debug(' Asset Id : ' + assetIds);
        system.debug('value : ' + value);
        DataTableWrapper oDatatableWrapper = new DataTableWrapper();
        
        try{
        string validationMsg = dataFactory(caseId);
        system.debug('validationMsg ' + validationMsg);
        if(string.isNotBlank(validationMsg) && (validationMsg!=System.Label.ESC_ImmediateCancellation && validationMsg != System.Label.ESC_ImmediateSuspend && validationMsg != System.Label.ESC_ImmediateUnsuspend)){
            oDatatableWrapper.errorMsg = validationMsg;
            return oDatatableWrapper;
        }
        if(oCase.ESC_EnquiryType__c== 'Cancellation'){
            for(string oAssetId:assetIds){
                if(!apttusAssetLIMap.isEmpty() && apttusAssetLIMap.containsKey(oAssetId)){
                    if(oCase.ESC_Subscription_Start_Date__c !=null && oCase.ESC_Subscription_Start_Date__c > apttusAssetLIMap.get(oAssetId).Apttus_Config2__EndDate__c){
                        validationMsg = System.Label.ESC_CancellationDateGreaterEndDate;
                        oDatatableWrapper.errorMsg = validationMsg;
                        return oDatatableWrapper;
                    }
                }
            }
        }
        
        Set<Id> caseAssetLISetIds = new Set<Id>();
        system.debug('Map of Asset Line Item : ' + apttusAssetLIMap);
        List<ESC_Case_Asset_Line_Item__c> caseAssetLIList = new List<ESC_Case_Asset_Line_Item__c>();
        Map<string,ESC_Case_Asset_Line_Item__c> caseAssetLIMap = new Map<string,ESC_Case_Asset_Line_Item__c>();
        List<ESC_Case_Asset_Line_Item__c> caseAssetLILst = new List<ESC_Case_Asset_Line_Item__c>();
        
        caseAssetLIList = [SELECT Name,id,ESC_Case__c,ESC_Asset_Number__c,ESC_Asset_PO_Number__c,ESC_case__r.casenumber,ESC_Asset_Line_Item__r.TAX_APTS_PO_Number__c,ESC_Asset_Line_Item__c,ESC_Net_Price__c,ESC_Asset_Line_Item__r.Name,ESC_Asset_Auto_Number__c FROM ESC_Case_Asset_Line_Item__c
                         WHERE ESC_Case__c = :caseId ];
        
        system.debug('caseAssetLIList : ' + caseAssetLIList );                 
        
        if(caseAssetLIList !=null && caseAssetLIList.size() >0){
            for(ESC_Case_Asset_Line_Item__c  caseAssetLI:caseAssetLIList ){
                    caseAssetLIMap.put(caseAssetLI.ESC_Asset_Line_Item__c,caseAssetLI);
            }
        }
        
        system.debug('caseAssetLIMap: ' + caseAssetLIMap);                 
            for(String assetId:assetIds){
                ESC_Case_Asset_Line_Item__c oCaseAssetLI;
                if(!caseAssetLIMap.isEmpty()){
                oCaseAssetLI = new ESC_Case_Asset_Line_Item__c();
                        if(!caseAssetLIMap.containsKey(assetId)){
                            ocaseAssetLI.ESC_Case__c = caseId;
                            ocaseAssetLI.ESC_Asset_Line_Item__c = assetId;
                            oCaseAssetLI.ESC_Net_Price__c = apttusAssetLIMap.get(assetId).Apttus_Config2__NetPrice__c;
                            oCaseAssetLI.ESC_TAX_APTS_PO_Number__c = apttusAssetLIMap.get(assetId).TAX_APTS_PO_Number__c;
                             oCaseAssetLI.ESC_Asset_Auto_Number__c = apttusAssetLIMap.get(assetId).Asset_Auto_Number__c;                            
                            caseAssetLILst.add(oCaseAssetLI);
                        }
                        
                }
                else{
                           oCaseAssetLI  = new ESC_Case_Asset_Line_Item__c();
                            ocaseAssetLI.ESC_Case__c = caseId;
                            ocaseAssetLI.ESC_Asset_Line_Item__c = assetId;
                            oCaseAssetLI.ESC_Net_Price__c = apttusAssetLIMap.get(assetId).Apttus_Config2__NetPrice__c;
                            oCaseAssetLI.ESC_TAX_APTS_PO_Number__c = apttusAssetLIMap.get(assetId).TAX_APTS_PO_Number__c;
                            oCaseAssetLI.ESC_Asset_Auto_Number__c = apttusAssetLIMap.get(assetId).Asset_Auto_Number__c;
                            caseAssetLILst.add(oCaseAssetLI);
                }
                
            }
        
        system.debug('caseAssetLILst : ' + caseAssetLILst);
        if(caseAssetLILst!=null && caseAssetLILst.size() > 0){
        
            insert caseAssetLILst;
        }
        List<LabelDescriptionWrapper> labelList = new List<LabelDescriptionWrapper>();
        labelList.add(new LabelDescriptionWrapper('Name','Name','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Case Number','ESC_Case__r.casenumber','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset Number','ESC_Asset_Line_Item__r.Asset_Auto_Number__c','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset Start Date','ESC_Asset_Start_Date__c','FORMULA',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset End Date','ESC_Asset_End_Date__c','FORMULA',true,false));
        labelList.add(new LabelDescriptionWrapper('Net Price','ESC_Net_Price__c','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset Status','ESC_Asset_Status__c','FORMULA',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset Product','ESC_Asset_Product__c','FORMULA',true,false));
        labelList.add(new LabelDescriptionWrapper('Contract Number','ESC_Contract_Number__c','STRING',true,false));
        
        
       if(value == 'ESC_TAX_APTS_PO_Number__c'){
           labelList.add(new LabelDescriptionWrapper('Asset PO Number','ESC_Asset_PO_Number__c','FORMULA',true,false));
            labelList.add(new LabelDescriptionWrapper('PO Number','ESC_TAX_APTS_PO_Number__c','STRING',true,false));
        }
            
       
        List<map<string,object>> sObjectMap = new List<map<string,object>>();
        for(ESC_Case_Asset_Line_Item__c oCaseAssetLI:caseAssetLILst){
            caseAssetLISetIds.add(oCaseAssetLI.id);
            
        }
        
        List<ESC_Case_Asset_Line_Item__c> caseAssetList =[SELECT Name,id,ESC_Case__c,ESC_Asset_Start_Date__c,ESC_Asset_End_Date__c,ESC_Asset_Status__c,
                                                         ESC_Contract_Number__c,ESC_Asset_Product__c,ESC_Asset_Line_Item__r.Asset_Auto_Number__c
                                                         ,ESC_Asset_Number__c,ESC_Asset_PO_Number__c,ESC_TAX_APTS_PO_Number__c,ESC_case__r.casenumber,
                                                         ESC_Asset_Line_Item__r.APTS_Contract_Number__c,ESC_Asset_Line_Item__c,ESC_Net_Price__c,ESC_Asset_Line_Item__r.Name FROM ESC_Case_Asset_Line_Item__c
                                                         WHERE id in :caseAssetLISetIds];
                         
        if(caseAssetList !=null && caseAssetList.size() > 0){
            for(ESC_Case_Asset_Line_Item__c oCaseAssetLI:caseAssetList){
                Map<string,object>  dataMap = new Map<string,object>();
                dataMap.put('Id',oCaseAssetLI.id);
                dataMap.put('Name',oCaseAssetLI.Name);
                dataMap.put('ESC_Asset_Line_Item__r.Asset_Auto_Number__c',oCaseAssetLI.ESC_Asset_Line_Item__r.Asset_Auto_Number__c);
                dataMap.put('ESC_Case__r.casenumber',oCaseAssetLI.ESC_Case__r.casenumber);
                dataMap.put('ESC_Asset_Start_Date__c',oCaseAssetLI.ESC_Asset_Start_Date__c);
                dataMap.put('ESC_Asset_End_Date__c',oCaseAssetLI.ESC_Asset_End_Date__c);
                dataMap.put('ESC_Net_Price__c',string.valueOf(oCaseAssetLI.ESC_Net_Price__c));
                dataMap.put('ESC_Asset_Product__c',oCaseAssetLI.ESC_Asset_Product__c);
                dataMap.put('ESC_Asset_Status__c',oCaseAssetLI.ESC_Asset_Status__c);
               dataMap.put('ESC_Contract_Number__c',string.valueOf(oCaseAssetLI.ESC_Asset_Line_Item__r.APTS_Contract_Number__c)); 
               // if(value == 'ESC_TAX_APTS_PO_Number__c'){
                dataMap.put('ESC_Asset_PO_Number__c',oCaseAssetLI.ESC_Asset_PO_Number__c);
                    dataMap.put('ESC_TAX_APTS_PO_Number__c',oCaseAssetLI.ESC_TAX_APTS_PO_Number__c);
                //}
                
                sObjectMap.add(dataMap);
            }
        }
        system.debug('LabelList : ' + labelList);
        system.debug('sObjectMap : ' + sObjectMap);
                
                oDatatableWrapper.ldwList = labelList;
                oDatatableWrapper.sobjList = sObjectMap;
                oDatatableWrapper.isModifySub  = isModifySub;
                
      }catch(Exception Ex){
          system.debug('@@ Exception in dataFactory method : ' + ex.getMessage());
            oDatatableWrapper.errorMsg = ex.getMessage();
      }
    return oDatatableWrapper ;
    
    }
    public static List<LabelDescriptionWrapper> getColumns(){

        List<LabelDescriptionWrapper> labelList = new List<LabelDescriptionWrapper>();
        labelList.add(new LabelDescriptionWrapper('Name','Name','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset Number','Asset_Auto_Number__c','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Start Date','Apttus_Config2__StartDate__c','DATE',true,false));
        labelList.add(new LabelDescriptionWrapper('End Date','Apttus_Config2__EndDate__c','DATE',true,false));
        labelList.add(new LabelDescriptionWrapper('Net Price','Apttus_Config2__NetPrice__c','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Asset Status','Apttus_Config2__AssetStatus__c','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Product','Apttus_Config2__ProductId__r.Name','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('Contract Number','APTS_Contract_Number__c','STRING',true,false));
        labelList.add(new LabelDescriptionWrapper('PO Number','TAX_APTS_PO_Number__c','STRING',true,false));
        system.debug('@@ labelLIst : ' +labelLIst);
        return labelList;
    }

    public static List<map<string,object>> getRecords(){
        List<map<string,object>> sObjectMap = new List<map<string,object>>();
        if(apttusAssetLItemList!=null && apttusAssetLItemList.size() > 0){
            for(Apttus_Config2__AssetLineItem__c assetLst:apttusAssetLItemList){
                Map<string,object>  dataMap = new Map<string,object>();
                dataMap.put('Id',assetLst.id);
                dataMap.put('Name',assetLst.Name);
                dataMap.put('Asset_Auto_Number__c',assetLst.Asset_Auto_Number__c);
                dataMap.put('Apttus_Config2__StartDate__c',assetLst.Apttus_Config2__StartDate__c);
                dataMap.put('Apttus_Config2__EndDate__c',assetLst.Apttus_Config2__EndDate__c);
                dataMap.put('Apttus_Config2__NetPrice__c',string.valueOf(assetLst.Apttus_Config2__NetPrice__c));
                dataMap.put('Apttus_Config2__AssetStatus__c',assetLst.Apttus_Config2__AssetStatus__c);
                dataMap.put('Apttus_Config2__ProductId__r.Name',assetLst.Apttus_Config2__ProductId__r.Name);
                 dataMap.put('APTS_Contract_Number__c',string.valueOf(assetLst.APTS_Contract_Number__c));
                dataMap.put('TAX_APTS_PO_Number__c',assetLst.TAX_APTS_PO_Number__c);
                sObjectMap.add(dataMap);
            }
        }
        
        system.debug('@@ sObjectMap : ' +sObjectMap);
        return sObjectMap;
    }
    
     @AuraEnabled(cacheable = true)
    public static List < FatchValueWrapper > fatchPickListValue() {
        // Describe the SObject using its object type.
       
        // Create a list of wrapper to store picklist value/lable
        list < FatchValueWrapper > objWrapper = new list < FatchValueWrapper > ();
 
        FatchValueWrapper oFatchValueWrapper = new FatchValueWrapper();
            oFatchValueWrapper.slabel = 'PO Number';
            oFatchValueWrapper.svalue = 'ESC_TAX_APTS_PO_Number__c';
            objWrapper.add(oFatchValueWrapper);
        
        return objWrapper;
 
    }
    
     @AuraEnabled
    public static DatatableWrapper updateCaseAssetLI(List<string> AssetLIds,List<string> csAssetIds,string caseId,string fieldName,string value) {
    DatatableWrapper oDataTableWrapper = new DatatableWrapper();
        try{
        List<ESC_Case_Asset_Line_Item__c > csAssetLILst = new List<ESC_Case_Asset_Line_Item__c >();
        List<ESC_Case_Asset_Line_Item__c > csAssetLILstToUpdate = new List<ESC_Case_Asset_Line_Item__c >();
        string sQuery = 'SELECT id,Name,ESC_Asset_Line_Item__r.APTS_Contract_Number__c,ESC_Asset_Status__c,ESC_Asset_Product__c,ESC_Asset_Line_Item__c,ESC_Asset_Start_Date__c,ESC_Asset_End_Date__c,ESC_Net_Price__c,ESC_Asset_Line_Item__r.Asset_Auto_Number__c,ESC_Case__r.casenumber,ESC_Asset_PO_Number__c,' + fieldName + ' FROM ESC_Case_Asset_Line_Item__c WHERE ESC_Asset_Line_Item__c in:AssetLIds and ESC_Case__c =:caseId';
        csAssetLILst = Database.query(sQuery);
        List<map<string,object>> sObjectMap = new List<map<string,object>>();
        system.debug('sQuery : ' +sQuery);
        system.debug('csAssetLILst : ' + csAssetLILst);
        if(csAssetLILst !=null && csAssetLILst.size() > 0){
        for(ESC_Case_Asset_Line_Item__c oCAssetLI: csAssetLILst){
            //Apttus_Config2__AssetLineItem__c caseAssetLIObj = oCAssetLI.clone();
            if(csAssetIds.contains(oCAssetLI.Id)){
                oCAssetLI.ESC_TAX_APTS_PO_Number__c= value;
            }
            csAssetLILstToUpdate.add(oCAssetLI);
        }  
       } 
       
       system.debug('@@ AssetLILstToUpdate : ' + csAssetLILstToUpdate);
        if(csAssetLILstToUpdate!=null && csAssetLILstToUpdate.size() > 0){
            if(Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isAccessible() || Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isUpdateable()){
                update csAssetLILstToUpdate;
            }
            
            for(ESC_Case_Asset_Line_Item__c csAssetObj:csAssetLILstToUpdate){
                Map<string,object>  dataMap = new Map<string,object>();
                dataMap.put('Id',csAssetObj.id);
                dataMap.put('Name',csAssetObj.Name);
                dataMap.put('ESC_Asset_Line_Item__r.Asset_Auto_Number__c',csAssetObj.ESC_Asset_Line_Item__r.Asset_Auto_Number__c);
                dataMap.put('ESC_Case__r.casenumber',csAssetObj.ESC_Case__r.casenumber);
                dataMap.put('ESC_Asset_Start_Date__c',csAssetObj.ESC_Asset_Start_Date__c);
                dataMap.put('ESC_Asset_End_Date__c',csAssetObj.ESC_Asset_End_Date__c);
                dataMap.put('ESC_Net_Price__c',string.valueOf(csAssetObj.ESC_Net_Price__c));
                dataMap.put('ESC_Asset_Product__c',csAssetObj.ESC_Asset_Product__c);
                dataMap.put('ESC_Asset_Status__c',csAssetObj.ESC_Asset_Status__c);
                dataMap.put('ESC_Contract_Number__c',string.valueOf(csAssetObj.ESC_Asset_Line_Item__r.APTS_Contract_Number__c));
               // if(value == 'ESC_TAX_APTS_PO_Number__c'){
                dataMap.put('ESC_Asset_PO_Number__c',csAssetObj.ESC_Asset_PO_Number__c);
                    dataMap.put('ESC_TAX_APTS_PO_Number__c',csAssetObj.ESC_TAX_APTS_PO_Number__c);
                //}
                
                sObjectMap.add(dataMap);
                
            }
            oDataTableWrapper.sobjList = sObjectMap;
           
        } else{
            oDatatableWrapper.errorMsg = 'Please select atleast one case Asset Line Item record to update.';
            return oDatatableWrapper;
        }
        
        }  catch(Exception ex){
            system.debug('Exception occured in updateCaseAssetLI () : ' + ex.getMessage());
            oDatatableWrapper.errorMsg = ex.getMessage();
            return oDatatableWrapper;
        }      
        
        return oDatatableWrapper;
    }
    
    
     @AuraEnabled
    public static string finishMethod(List<string> AssetLIds,List<string> csAssetIds,string caseId,string fieldName) {
    
        try{
            List<ESC_Case_Asset_Line_Item__c > csAssetLILst = new List<ESC_Case_Asset_Line_Item__c >();
            List<ESC_Case_Asset_Line_Item__c > csAssetLILstToDel = new List<ESC_Case_Asset_Line_Item__c >();
            string sQuery = 'SELECT id,Name,ESC_Asset_Line_Item__c,ESC_Contract_Number__c,ESC_Asset_Line_Item__r.Asset_Auto_Number__c,ESC_Case__r.casenumber,ESC_Case__c,ESC_Asset_PO_Number__c,' + fieldName + ' FROM ESC_Case_Asset_Line_Item__c WHERE ESC_Asset_Line_Item__c in:AssetLIds and ESC_Case__c = :caseId';
            csAssetLILst = Database.query(sQuery);
            system.debug('@@ case assetIds : ' + csAssetIds);
            
           string assetNo = '';
            for(ESC_Case_Asset_Line_Item__c oCAssetLI: csAssetLILst){
            //Apttus_Config2__AssetLineItem__c caseAssetLIObj = oCAssetLI.clone();
            system.debug('@@ case assetIds : ' + csAssetIds);
            system.debug('@@ case assetIds : ' + oCAssetLI.Id);
                if((oCAssetLI.ESC_TAX_APTS_PO_Number__c == null || oCAssetLI.ESC_TAX_APTS_PO_Number__c == '') && csAssetIds.contains(oCAssetLI.Id)){
                    assetNo +=oCAssetLI.ESC_Asset_Line_Item__r.Asset_Auto_Number__c + ',';
                }else if(!csAssetIds.contains(oCAssetLI.Id)){
                    csAssetLILstToDel.add(oCAssetLI);
                }
            
            } 
            if(assetNo!='') {
             
                assetNo ='Please update PO Number for '+ assetNo.removeEnd(',');
                return assetNo;
            }else{
                if(csAssetLILstToDel!=null && csAssetLILstToDel.size() > 0){
                    delete csAssetLILstToDel;
                }
                Case oCase = [SELECT id,ESC_EnquiryType__c,ESC_Suspend_Asset__c from case where id = :caseId];
                    system.debug('');
                    if(oCase!=null && !oCase.ESC_Suspend_Asset__c && (oCase.ESC_EnquiryType__c== 'Modify Subscription')){
                        oCase.ESC_Suspend_Asset__c =true;
                        update oCase;
                  }
            }
              
            
       }catch(Exception ex){
            return ex.getmessage();
       }
       return null;
    }
    
    @AuraEnabled
    public static void setApprovalFlag(string caseId,List<string> assetIds,List<string> csAssetIds){
       try{
               if(csAssetIds!=null && csAssetIds.size() > 0){
                   Double totalNetPrice = 0;
                   List<ESC_Case_Asset_Line_Item__c > csAssetLILst = new List<ESC_Case_Asset_Line_Item__c >();
                   List<ESC_Case_Asset_Line_Item__c > csAssetLILstToDel = new List<ESC_Case_Asset_Line_Item__c >();
                    string sQuery = 'SELECT id,Name,ESC_Asset_Line_Item__c,ESC_Asset_Line_Item__r.Apttus_Config2__NetPrice__c FROM ESC_Case_Asset_Line_Item__c WHERE ESC_Asset_Line_Item__c in:assetIds and ESC_Case__c = :caseId';
                    csAssetLILst = Database.query(sQuery);
                    system.debug('@@ csAssetLILst : ' + csAssetLILst);
                for(ESC_Case_Asset_Line_Item__c cAsset:csAssetLILst){
                    if(csAssetIds.contains(cAsset.Id)){
                        totalNetPrice += cAsset.ESC_Asset_Line_Item__r.Apttus_Config2__NetPrice__c;
                    }else{
                        csAssetLILstToDel.add(cAsset);
                    }
                
                }
                
                    if(csAssetLILstToDel!=null && csAssetLILstToDel.size() > 0){
                        delete csAssetLILstToDel;
                    }
                   Case oCase = [SELECT id,ESC_Subscription_Start_Date__c,ESC_Sub_Type__c,ESC_Account_Lock_Unlock_Flag__c,ESC_Total_Net_Price1__c,ESC_Submit_For_Auto_Approval__c,ESC_EnquiryType__c,ESC_Suspend_Asset__c from case where id = :caseId];
                        system.debug('');
                        if(oCase!=null && !oCase.ESC_Submit_For_Auto_Approval__c && (oCase.ESC_EnquiryType__c== 'Cancellation' || oCase.ESC_EnquiryType__c== 'Suspend' || oCase.ESC_EnquiryType__c== 'Unsuspend')){
                            oCase.ESC_Submit_For_Auto_Approval__c=true;
                            oCase.ESC_Total_Net_Price1__c = totalNetPrice;
                            if(assetIds.size() == csAssetIds.size() && (oCase.ESC_EnquiryType__c== 'Suspend' || oCase.ESC_EnquiryType__c== 'Unsuspend') && oCase.ESC_Sub_Type__c =='Payment'){
                                oCase.ESC_Account_Lock_Unlock_Flag__c = true;
                            }
                            if(oCase.ESC_Subscription_Start_Date__c == null)
                            oCase.ESC_Subscription_Start_Date__c=Date.Today();
                            update oCase;
                  }
                   if(oCase!=null && !oCase.ESC_Submit_For_Auto_Approval__c && oCase.ESC_EnquiryType__c== 'Remove Future Cancellation' ){
                             List<Apttus_Config2__AssetLineItem__c> lstUpdate = new List<Apttus_Config2__AssetLineItem__c>();
                             List<id> Parentbundleid= new List<id>();
                             if(Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isAccessible() && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isQueryable()){
                             for(ESC_Case_Asset_Line_Item__c csassetlineItem : [select id,name,ESC_Asset_Number__c,ESC_Asset_Line_Item__c,ESC_Asset_Status__c from ESC_Case_Asset_Line_Item__c
                                                                             where ESC_Case__c =:caseId])
                                                                          {
                                                                           Apttus_Config2__AssetLineItem__c apptuslinitem = new Apttus_Config2__AssetLineItem__c();
                                                                           apptuslinitem.id= csassetlineItem.ESC_Asset_Line_Item__c;
                                                                           apptuslinitem.Apttus_Config2__AssetStatus__c='Activated';
                                                                           apptuslinitem.Apttus_Config2__CancelledDate__c=null;
                                                                           apptuslinitem.APTS_Cancellation_Reason_Code__c=null;
                                                                           lstUpdate.add(apptuslinitem);
                                                                           Parentbundleid.add(csassetlineItem.ESC_Asset_Line_Item__c);
                                                                          }                               
                              }
                             
                             if(Parentbundleid.size()>0 && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){                                     
                                     for(Apttus_Config2__AssetLineItem__c childasset : [SELECT id,Apttus_Config2__CancelledDate__c,TAX_APTS_PO_Number__c ,Apttus_Config2__BundleAssetId__c,Apttus_Config2__AssetStatus__c,Apttus_Config2__EndDate__c,Asset_Auto_Number__c,APTS_Cancellation_Reason_Code__c,APTS_Unlock_Reason_Code__c,APTS_Suspend_Lock_Reason_Code__c From Apttus_Config2__AssetLineItem__c where Apttus_Config2__BundleAssetId__c IN: Parentbundleid]){
                                     childasset.Apttus_Config2__AssetStatus__c='Activated';
                                     childasset.Apttus_Config2__CancelledDate__c=null;
                                     lstUpdate.add(childasset);
                             } }
                                              
                              if(lstUpdate.size()>0 && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isUpdateable()){
                                Update lstUpdate;
                              }
                            
                    
                  }else if(oCase!=null && !oCase.ESC_Submit_For_Auto_Approval__c && oCase.ESC_EnquiryType__c== 'Modify Future Cancellation' ){
                      List<Apttus_Config2__AssetLineItem__c> lstUpdate = new List<Apttus_Config2__AssetLineItem__c>();
                             List<id> Parentbundleid= new List<id>();
                             if(Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isAccessible() && Schema.sObjectType.ESC_Case_Asset_Line_Item__c.isQueryable()){
                             for(ESC_Case_Asset_Line_Item__c csassetlineItem : [select id,name,ESC_Asset_Number__c,ESC_Asset_Line_Item__c,ESC_Asset_Status__c from ESC_Case_Asset_Line_Item__c where ESC_Case__c =:caseId])
                                                                          {
                                                                           Apttus_Config2__AssetLineItem__c apptuslinitem = new Apttus_Config2__AssetLineItem__c();
                                                                           apptuslinitem.id= csassetlineItem.ESC_Asset_Line_Item__c;
                                                                           datetime myDate =oCase.ESC_Subscription_Start_Date__c;
                                                                           datetime newDate = mydate.addHours(12);
                                                                           apptuslinitem.Apttus_Config2__CancelledDate__c = newDate;
                                                                           lstUpdate.add(apptuslinitem);
                                                                           Parentbundleid.add(csassetlineItem.ESC_Asset_Line_Item__c);
                                                                          }                               
                              }
                             
                             if(Parentbundleid.size()>0 && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){                                     
                                     for(Apttus_Config2__AssetLineItem__c childasset : [SELECT id,Apttus_Config2__BundleAssetId__c,Apttus_Config2__CancelledDate__c FROM Apttus_Config2__AssetLineItem__c where Apttus_Config2__BundleAssetId__c IN: Parentbundleid]){
                                     datetime myDate =oCase.ESC_Subscription_Start_Date__c;
                                     datetime newDate = mydate.addHours(12);
                                     childasset.Apttus_Config2__CancelledDate__c=newDate;
                                     lstUpdate.add(childasset);
                             } }
                                              
                              if(lstUpdate.size()>0 && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isUpdateable()){
                                Update lstUpdate;
                              } 
                  
               
                     
               }  }
          }catch(Exception ex){
               system.debug('@@ exception : ' + ex.getMessage());
           }
           
    }
        //Method to save records in inline edit
  /*  @AuraEnabled
    public static void updateRecords(List<sObject> sobList, String updateObjStr, String objectName) {
        system.debug('@@ sobList : ' + sobLIst);
        system.debug('@@ updateObjStr : ' + updateObjStr);
        system.debug('@@ objectName : ' + objectName);
        schema.SObjectType sobjType = Schema.getGlobalDescribe().get(ObjectName);
        Map<String, Schema.sObjectField> sObjectFields = sobjType.getDescribe().fields.getMap();
        List<sObject> updateList = new List<sObject>();
        List<Object> obList = (List<object>) json.deserializeUntyped(updateObjStr);
        for(object ob : obList) {
            Map<String, object> obmap = (Map<String, object>)ob;
            String rowKey = (String)obmap.get('CaseAssetTable');
            Integer rowKeyInt = Integer.ValueOf(rowKey.removeStart('row-'));
            
            sobject sObj = sobList[rowKeyInt];
            for(string fieldName : obmap.keySet()) {
            system.debug('@@ fieldName : ' + fieldName);
                if(fieldName != 'CaseAssetTable') {
                    Object value = obmap.get(fieldName);
                    Schema.DisplayType valueType = sObjectFields.get(fieldName).getDescribe().getType();
                    if (value instanceof String && valueType != Schema.DisplayType.String)
                    {
                        String svalue = (String)value;
                        if (valueType == Schema.DisplayType.Date)
                            sObj.put(fieldName, Date.valueOf(svalue));
                        else if(valueType == Schema.DisplayType.DateTime) {
                            try{
                                System.debug( (DateTime)value);
                            }catch(exception ex) {
                                system.debug(ex.getmessage());
                            }
                            String d1 = svalue;
                            list<String> d2 = d1.split('-');
                            list<integer> timeComponent = new list<integer>();
                            timeComponent.add(Integer.valueOf(d2[0]));
                            timeComponent.add(Integer.valueOf(d2[1]));
                            timeComponent.add(Integer.valueOf(d2[2].left(2)));
                            
                            String t = d2[2].substringBetween('T','.');
                            
                            list<String> time1 = t.split(':');
                            timeComponent.add(Integer.valueOf(time1[0]));
                            timeComponent.add(Integer.valueOf(time1[1]));
                            timeComponent.add(Integer.valueOf(time1[2]));
                            
                            Datetime dt = Datetime.newInstance(timeComponent[0],timeComponent[1],timeComponent[2],timeComponent[3],timeComponent[4],timeComponent[5]);
                            sObj.put(fieldName, dt);
                        }
                        //
                        else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                            sObj.put(fieldName, svalue == '' ? null : Decimal.valueOf(svalue));
                        else if (valueType == Schema.DisplayType.Double)
                            sObj.put(fieldName, svalue == '' ? null : Double.valueOf(svalue));
                        else if (valueType == Schema.DisplayType.Integer)
                            sObj.put(fieldName, Integer.valueOf(svalue));
                        else if (valueType == Schema.DisplayType.Base64)
                            sObj.put(fieldName, Blob.valueOf(svalue));
                        else
                            sObj.put(fieldName, svalue);
                    }
                    else
                        sObj.put(fieldName, value);
                }
               
            }
            updateList.add(sObj);
        }
        
        update updateList;
    }*/

 // wrapper class 
    public with sharing class FatchValueWrapper {
        @auraEnabled public string slabel {get;set;}
        @auraEnabled public string svalue {get;set;}
    }
        public class DataTableWrapper {
        @AuraEnabled
        public List<LabelDescriptionWrapper> ldwList;
        @AuraEnabled
        public List<Map<string,object>> sobjList;
        @AuraEnabled
        public boolean isModifySub;
        @AuraEnabled
        public string errorMsg;
        /*@AuraEnabled
        public string keyId;
        @AuraEnabled
        public Integer totalCount;*/
        
       
    }

    public class LabelDescriptionWrapper {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public boolean sortable;
        @AuraEnabled
        public boolean editable;
        
        public LabelDescriptionWrapper(String labelTemp, String fieldNameTemp, String typeTemp, boolean sortableTemp,boolean editableTemp) {
            label     = labelTemp;
            fieldName = fieldNameTemp;
            type      = typeTemp;
            sortable  = sortableTemp;
            editable = editableTemp;
            
        }
            
    }
    
}