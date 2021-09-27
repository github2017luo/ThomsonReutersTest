public without sharing class USL_UpdateCaseOwnerCCExp{
    @InvocableMethod(label='Update Case Owner')
    public static void updatecaseowneronapproval(list<ESC_Case_Form_Extension__c> NewCaseForm){
         List<case> Caseupdatelist = new List<Case>();
         List<Case> Caselist = new List<Case>(); 
         list<Group> g = new list<Group>();
         if (Schema.sObjectType.Group.isAccessible()){
          g=[Select Id from Group where DeveloperName =:Label.ChargeCEForm];
         }
         if (Schema.sObjectType.Case.isAccessible()){
        	 Caselist = [select id,Form_Name__c from Case where id=:NewCaseForm[0].esc_case__c];
         }
         if(NewCaseForm[0].usl_approval_status__c == 'Approved' && Caselist[0].Form_Name__c == 'Charge Cancellation Exception Form'){
             Case caseupd = new Case();
             caseupd.id = Caselist[0].id;
             caseupd.ownerid = g[0].id;
             Caseupdatelist.add(caseupd);
             if(Schema.sObjectType.Case.isUpdateable()){
                update caseupdatelist;
             }
         }
         
          
          
          
     }
}