public without sharing class ESC_ContactSICaseUtility{
    
    @InvocableMethod(label='Copy Contact SI for Case' description='Copies the contact specific instructions to case')
    public static void inheritIntCaseSpecialInstructions(List<ESC_Special_Instruction__c> specialInstruction){
        List<ESC_Case_Special_Instruction__c> lstcssis = new List<ESC_Case_Special_Instruction__c>();
        Set<Id> setConId = new Set<Id>();
        Map<Id, List<Id>> mapconcase = new Map<Id, List<Id>>();
        for(ESC_Special_Instruction__c si:specialInstruction){
            if(si.ESC_contact__c!=null){
                setConId.add(si.ESC_contact__c);
            }
        }
        List<Case> caselst = new List<Case>();
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
        caselst  = [select Id,contactId from Case where IsClosed != true and ContactId IN :setConId];
        }
        for(Case c: caselst){
            if(!mapconcase.containskey(c.contactId)){
                mapconcase.put(c.contactId, new List<Id>{c.Id});
            }else{
                mapconcase.get(c.contactId).add(c.Id);
            }
        }
        //check for the record type of special instruction
        //put in validations, null checks etc.
        system.debug(specialInstruction);
        for(ESC_Special_Instruction__c si:specialInstruction){
            if(si.ESC_status__c == 'Active' && si.ESC_Contact__c!=null){
                if(mapconcase.containskey(si.ESC_Contact__c)){
                    for(Id csid:mapconcase.get(si.ESC_Contact__c)){
                        ESC_Case_Special_Instruction__c csi = new ESC_Case_Special_Instruction__c();
                        csi.ESC_Case__c = csid;
                        csi.ESC_special_instruction__c = si.id;
                        lstcssis.add(csi);
                    }
                }
            }
        }           
        
        system.debug(lstcssis);
        if(lstcssis.size()>0 && (Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isCreateable())){  
            insert lstcssis;        
        }
    }
}