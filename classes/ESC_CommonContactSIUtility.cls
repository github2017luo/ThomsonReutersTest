/**
* CHANGE HISTORY
* ============================================================================================================================
* Date         Name             JIRA          Description
* ============================================================================================================================
* 
* 2017-05-10   Karthi G        EBB-161      Update Contact SI and related Case SI when Account is changed in Contact
*                                             (InvocableMethod called from Process Builder 'Contact On Create')
* 2017-06-07   Yugender C                   Added conditions to verify with list size before executing the code. As this 
*                                              was an issue with GGO test classes
* 
* ============================================================================================================================
*/
public class ESC_CommonContactSIUtility {
    @InvocableMethod(label = 'Copy SI to Contact from Account' description='Creates Contact Special Instructions from associated Account')
    public static void inheritIntoContactSpecialInstructions(List<Contact> conList){
 if(LCRMConvertLeadController.lcrmConvertLeadFlag){ //Added for CRM-17836
        system.debug('****conList'+conList);
        Set<Id> setConId = new Set<Id>();
        Set<Id> setAccId = new Set<Id>();
        Map<Id, List<Id>> mapConAccLink = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapconSI = new Map<Id, List<Id>>();
        Map<Id, Id> mapconSI2 = new Map<Id,Id>();
        List<Id> listSI = new List<Id>();
        List<ESC_Case_Special_Instruction__c> listCaSI = new List<ESC_Case_Special_Instruction__c>();
        List<ESC_Contact_Special_Instruction__c> listConSI= new List<ESC_Contact_Special_Instruction__c>();
        
        for(Contact con:conList){
            setConId.add(con.id);
            setAccId.add(con.AccountId);
            if(!mapConAccLink.containskey(con.AccountId)){
                mapConAccLink.put(con.AccountId, new List<Id>{con.Id});
            }else{
                mapConAccLink.get(con.AccountId).add(con.Id);
            }
        }
        
        
        List<ESC_Contact_Special_Instruction__c> listOldCSI = [Select id,ESC_Special_Instruction__r.Id,ESC_Special_Instruction__c from ESC_Contact_Special_Instruction__c where 
                                                               ESC_Contact__c IN :setConId and ESC_Special_Instruction__r.ESC_Account__c !=null];
        
        if(listOldCSI.size()>0){
            for(ESC_Contact_Special_Instruction__c csi:listOldCSI){
                Id sIid = csi.ESC_Special_Instruction__r.Id;
                listSI.add(sIid);            
            }
        }
        
        
        List<Case> caseList = [Select id,ContactId,(select id,ESC_Case__c,ESC_Special_Instruction__c from Case_Special_Instructions__r 
                                                    where ESC_Special_Instruction__c in :listSI) 
                               from case where ContactId IN : setConId];  
        
        for(Case csRecord : caseList){
            for(ESC_Case_Special_Instruction__c spIns : csRecord.Case_Special_Instructions__r){
                listCaSI.add(spIns);
            }
        }
        if(listOldCSI.size()>0){
            Delete listOldCSI;
        }
        if(listCaSI.size()>0){
            Delete listCaSI;
        }
        
        List<ESC_Account_Special_Instruction__c> accsi = [Select Id,ESC_Special_Instruction__r.Id,ESC_Status__c,ESC_Account__c from ESC_Account_Special_Instruction__c where ESC_Account__c IN :setAccId];
        
        if(accsi.size()>0){
            for(ESC_Account_Special_Instruction__c asi: accsi){
                if(mapConAccLink.containsKey(asi.ESC_Account__c)){
                    for(Id conid:mapConAccLink.get(asi.ESC_Account__c)){
                        ESC_Contact_Special_Instruction__c csi= new ESC_Contact_Special_Instruction__c();
                        csi.ESC_Contact__c = conid;
                        csi.ESC_Contact_SI_Status__c =asi.ESC_Status__c ;
                        csi.ESC_Special_Instruction__c = asi.ESC_Special_Instruction__r.Id;
                        listConSI.add(csi);
                        
                    }
                    
                }
                
            }
        }
        
        if(listConSI.size()>0){
            insert listConSI;
        } 
        system.debug('listConSI'+listConSI);
        
        for(ESC_Contact_Special_Instruction__c conSI1:listConSI){
            
            if(!mapconSI.containskey(conSI1.ESC_Contact__c)){
                mapconSI.put(conSI1.ESC_Contact__c, new List<Id>{conSI1.id});
            }else{
                mapconSI.get(conSI1.ESC_Contact__c).add(conSI1.id);
            }
            
            mapconSI2.put(conSI1.id,conSI1.ESC_Special_Instruction__c);
        }   
        //Removed this query as part of optimization
        //List<ESC_Contact_Special_Instruction__c> ListNewCSI = [Select id,ESC_Special_Instruction__r.Id,ESC_Special_Instruction__c from ESC_Contact_Special_Instruction__c where ESC_Contact__c =:conList[0].Id and ESC_Special_Instruction__r.ESC_Account__c !=null and  ESC_Special_Instruction__r.ESC_Account__c =:conList[0].AccountId and ESC_Status__c='Active'];
        //system.debug('ListNewCSI'+ListNewCSI);
        List<ESC_Case_Special_Instruction__c> listCaseSI = new List<ESC_Case_Special_Instruction__c>();
        
        if(caseList.size()>0){
            for(Case c:caseList){
                
                if(mapconSI.containsKey(c.contactId)){
                    for(Id sID:mapconSI.get(c.contactId)){
                        ESC_Case_Special_Instruction__c csi1 = new ESC_Case_Special_Instruction__c();
                        csi1.ESC_Case__C = C.Id;
                        csi1.ESC_Special_Instruction__c = mapconSI2.get(sID);
                        listCaseSI.add(csi1);
                    }
                    
                }
            }
        }
        if(listCaseSI.size()>0){
            insert listCaseSI;
        } 
    } 
}
}