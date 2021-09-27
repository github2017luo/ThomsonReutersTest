/**
* CHANGE HISTORY
* ============================================================================================================================
* Date         Name             JIRA          Description
* ============================================================================================================================
* 
* 2017-05-10   Karthi G        EBB-161     1. Copy Special Instructions to Case_Special_Instruction__c on Create/Edit of case 
*                                          2. Delete CaSI when case is closed or Account and contact associated is  removed
*                                             (InvocableMethod called from Process Builder 'Case Special Instruction')
* 
* ============================================================================================================================
*/

public without sharing class ESC_CommonCaseSIUtility {
    @InvocableMethod(label = 'Copy SI for Case' description='Creates Case Special Instructions')
    public static void inheritIntoCaseSpecialInstructions(List<Case> caseList){
        
        ESC_Static_Values__c sv = ESC_Static_Values__c.getInstance('CaseSIDeleteOnCaseClosure');
        
        Set<Id> setCaseId = new Set<Id>();
        Set<Id> setConId = new Set<Id>();
        Set<Id> setAccId = new Set<Id>();
        
        List<ESC_Case_Special_Instruction__c> lstcsi = new List<ESC_Case_Special_Instruction__c>();
        List<ESC_Case_Special_Instruction__c> lstcsi2 = new List<ESC_Case_Special_Instruction__c>();
        List<ESC_Case_Special_Instruction__c> listCaseSI = new List<ESC_Case_Special_Instruction__c>();
        List<ESC_Account_Special_Instruction__c> lstAccSI = new List<ESC_Account_Special_Instruction__c>();
        List<ESC_Contact_Special_Instruction__c> lstconSI = new List<ESC_Contact_Special_Instruction__c>();
        List<ESC_Case_Special_Instruction__c> listOldCSI = new List<ESC_Case_Special_Instruction__c> ();
        Map<Id, List<Id>> mapconSI = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapaccSI = new Map<Id, List<Id>>();
        
        for(Case cs:caseList){
            setCaseId.add(cs.id);
            if(cs.ContactId != null){
                setConId.add(cs.ContactId);
            }
            if(cs.AccountId != null){
                setAccId.add(cs.AccountId);
            }
        }
        if(Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isQueryable()){
        listOldCSI = [Select id,name,ESC_Case__r.status,ESC_Case__r.isclosed from ESC_Case_Special_Instruction__c where ESC_Case__c IN :setCaseId];
        }
            
        if(setConId.size()>0 && (Schema.sObjectType.ESC_Contact_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Contact_Special_Instruction__c.isQueryable())){
            lstconSI = [Select Id,ESC_Special_Instruction__c,ESC_Status__c,ESC_Contact__c from  ESC_Contact_Special_Instruction__c 
                                                        where ESC_Status__c='Active' and ESC_Contact__c IN :setConId];
        }
        if(setAccId.size()>0 && (Schema.sObjectType.ESC_Account_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Account_Special_Instruction__c.isQueryable())){
            lstAccSI = [Select Id,ESC_Special_Instruction__c,ESC_Status__c,ESC_Account__c from ESC_Account_Special_Instruction__c 
                                                        where ESC_Status__c='Active' and ESC_Account__c IN :setAccId ];
        }
        for(ESC_Case_Special_Instruction__c csi:listOldCSI){
            if(csi.ESC_Case__r.isclosed == TRUE){
                lstcsi.add(csi);
            }else{
                lstcsi2.add(csi);
            }
        }
        
        for(ESC_Contact_Special_Instruction__c csi: lstconSI){
            if(!mapconSI.containskey(csi.ESC_Contact__c)){
                mapconSI.put(csi.ESC_Contact__c, new List<Id>{csi.ESC_Special_Instruction__c});
            }else{
                mapconSI.get(csi.ESC_Contact__c).add(csi.ESC_Special_Instruction__c);
            }
        }
        
        for(ESC_Account_Special_Instruction__c asi: lstAccSI){
            if(!mapaccSI.containskey(asi.ESC_Account__c)){
                mapaccSI.put(asi.ESC_Account__c, new List<Id>{asi.ESC_Special_Instruction__c});
            }else{
                mapaccSI.get(asi.ESC_Account__c).add(asi.ESC_Special_Instruction__c);
            }
        }
        
        if(lstcsi.size()>0 && sv.ESC_Value__c == 'ON' && (Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isDeletable())){
            delete lstcsi;             // Delete CaSI on change of contact or account, if case is closed or if account and contact are removed
        }
        if(lstcsi2.size()>0 && (Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isDeletable())){
            delete lstcsi2;             // Delete CaSI on change of contact or account, if case is closed or if account and contact are removed
        }
        
        for(Case cs:caseList){
            if(cs.IsClosed != true &&(cs.ContactId!=null || cs.AccountId != null)){
                
                // Execute and create CaSI when Case contact is not null(Copy CaSI from Contact_Special_Instruction__c)
                If(cs.ContactId!=null){
                    if(mapconSI.containsKey(cs.ContactId)){
                        for(Id sid:mapconSI.get(cs.ContactId)){
                            ESC_Case_Special_Instruction__c csi1 = new ESC_Case_Special_Instruction__c();
                            csi1.ESC_Case__C = cs.Id;
                            csi1.ESC_Special_Instruction__c = sid;
                            listCaseSI.add(csi1);
                        }
                    }
                }
                // Execute and create CaSI when Case contact null and Account is not null(Copy CaSI from Account_Special_Instruction__c)
                else If(cs.AccountId != null && cs.ContactId == null){
                    if(mapaccSI.containsKey(cs.AccountId)){
                        for(Id sid:mapaccSI.get(cs.AccountId)){
                            ESC_Case_Special_Instruction__c csi1 = new ESC_Case_Special_Instruction__c();
                            csi1.ESC_Case__C = cs.Id;
                            csi1.ESC_Special_Instruction__c = sid;
                            listCaseSI.add(csi1);
                        }
                    }
                }
            }
        }
        
        if(listCaseSI.size()>0 && (Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isCreateable())){
            insert listCaseSI;
        }
    } 
}