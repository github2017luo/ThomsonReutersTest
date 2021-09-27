/*
*    This class deals with some common utility methods for the special instruction
*/
public without sharing class ESC_CommonUtilities{

    /*
    *    This method can be invoked by the special instruction process builder to copy over the 
    *    special instructions from the 
    */
    @InvocableMethod(label='Copy Special Instructions from Contact' 
                    description='Copies the account specific instructions to contact')
    public static void inheritSpecialInstructions(List<ESC_Special_Instruction__c> specialInstruction){
        
        //
        if(specialInstruction == null || specialInstruction.isEmpty()){
            return;
            }
        //check for the record type of special instruction
        
        //put in validations, null checks etc.
        List<ESC_Contact_Special_Instruction__c> csis = new List<ESC_Contact_Special_Instruction__c>();
        Set<Id> conIds = new Set<Id>();
        
        for(Contact con: [select Id from Contact where accountId =: specialInstruction[0].ESC_account__c]){
            ESC_Contact_Special_Instruction__c c = new ESC_Contact_Special_Instruction__c();
            c.ESC_contact__c = con.Id;
            c.ESC_Special_Instruction__c = specialInstruction[0].id;
            c.ESC_Contact_SI_Status__c = specialInstruction[0].ESC_Status__c;
            csis.add(c);
            conIds.add(con.Id);
        }
        if(Schema.sObjectType.ESC_Contact_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Contact_Special_Instruction__c.isCreateable()){        
        insert csis;
        }
        
        if(specialInstruction[0].ESC_status__c == 'Active'){
        List<ESC_Case_Special_Instruction__c> cssis = new List<ESC_Case_Special_Instruction__c>();
        for(Case cs: [select Id from Case where Status !='Closed' and ContactId in: ConIds]){
            ESC_Case_Special_Instruction__c c = new ESC_Case_Special_Instruction__c();
            c.ESC_Case__c = cs.Id;
            c.ESC_Special_Instruction__c = specialInstruction[0].id;
            cssis.add(c);
        }
        if(Schema.sObjectType.ESC_Case_Special_Instruction__c.isAccessible() || Schema.sObjectType.ESC_Case_Special_Instruction__c.isCreateable()){        
        insert cssis;
        }
        }
    }
}