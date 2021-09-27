public without sharing class ESC_SpecialInstructionsStatusChange{

    /*
    *    This method can be invoked by the special instruction process builder to update status accross account, contact 
    *    & case junction objects 
    */
    @InvocableMethod(label='Update SI Status in Junction Objs' 
                    description='Updates special instructions status in account, contact & case')
    public static void inheritSpecialInstructionsStatusChange(List<ESC_Special_Instruction__c> specialInstruction){
        
        //if list is empty lets keep it nothing
        if(specialInstruction == null || specialInstruction.isEmpty()){
            return;
            }
            
        List<ESC_Account_Special_Instruction__c> lstOfAccSIs = new List<ESC_Account_Special_Instruction__c>();
        List<ESC_Contact_Special_Instruction__c> lstOfConSIs = new List<ESC_Contact_Special_Instruction__c>();
        List<ESC_Case_Special_Instruction__c> lstOfNewCaseSIs = new List<ESC_Case_Special_Instruction__c>();
        List<ESC_Case_Special_Instruction__c> lstOfDelCaseSIs = new List<ESC_Case_Special_Instruction__c>();
        
        map<id,ESC_Special_Instruction__c> mapOfSIs;
        Set<id> setOfSIIds = new Set<id>();
        Set<id> setOfConIds = new Set<id>();
        
        for(ESC_Special_Instruction__c si:specialInstruction){
            setOfSIIds.add(si.id);
            }
        if(!setOfSIIds.isEmpty()){
            mapOfSIs= new map<id,ESC_Special_Instruction__c>(
                                    [select Id,name,ESC_Status__c from ESC_Special_Instruction__c where id IN: setOfSIIds]);
                                    }
        
        for(ESC_Account_Special_Instruction__c asi: [select Id, ESC_Account_SI_Status__c, ESC_Special_Instruction__c from ESC_Account_Special_Instruction__c where ESC_Special_Instruction__c in : setOfSIIds]){
            ESC_Special_Instruction__c si1= mapOfSIs.get(asi.ESC_Special_Instruction__c);
            asi.ESC_Account_SI_Status__c =  si1.ESC_Status__c;
            lstOfAccSIs.add(asi);
        }
            
        for(ESC_Contact_Special_Instruction__c consi: [select Id, ESC_Contact_SI_Status__c, ESC_Contact__c, ESC_Special_Instruction__c from ESC_Contact_Special_Instruction__c where ESC_Special_Instruction__c in : setOfSIIds]){
            ESC_Special_Instruction__c si2= mapOfSIs.get(consi.ESC_Special_Instruction__c);
            consi.ESC_Contact_SI_Status__c = si2.ESC_Status__c;
            setOfConIds.add(consi.ESC_Contact__c);
            lstOfConSIs.add(consi);
        }
        
        for(ESC_Case_Special_Instruction__c cssi: [select Id, ESC_Special_Instruction__c from ESC_Case_Special_Instruction__c where ESC_Special_Instruction__c in : setOfSIIds]){
            ESC_Special_Instruction__c si3= mapOfSIs.get(cssi.ESC_Special_Instruction__c);
            if(si3.ESC_Status__c=='Inactive'){
                lstOfDelCaseSIs.add(cssi);
                }
        }
        List<Case> lstOfCase = new List<Case>();
        if(Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isQueryable()){
        lstOfCase = [select Id from Case where Status !='Closed' and ContactId in: setOfConIds];
        }
        for(ESC_Special_Instruction__c si4 : specialInstruction){
            if(si4.ESC_Status__c=='Active'){       
                for(case ca : lstOfCase){
                    ESC_Case_Special_Instruction__c c = new ESC_Case_Special_Instruction__c();
                    c.ESC_Case__c = ca.Id;
                    c.ESC_Special_Instruction__c = specialInstruction[0].id;
                    lstOfNewCaseSIs.add(c);
                }
            }
        }
            
        if(!lstOfAccSIs.isEmpty() && (Schema.sObjectType.ESC_Account_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Account_Special_Instruction__c.isUpdateable())){
            update lstOfAccSIs;
            }
        if(!lstOfConSIs.isEmpty() && (Schema.sObjectType.ESC_Contact_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Contact_Special_Instruction__c.isUpdateable())){
            update lstOfConSIs;
            }
        if(!lstOfNewCaseSIs.isEmpty() && (Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isCreateable())){
            insert lstOfNewCaseSIs; 
            }
        if(!lstOfDelCaseSIs.isEmpty() && (Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isDeletable())){
            delete lstOfDelCaseSIs;  
            }
             
    } 
}