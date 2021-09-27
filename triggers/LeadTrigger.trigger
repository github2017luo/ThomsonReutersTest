trigger LeadTrigger on Lead (after Insert,before update,before Insert) {
//LTS_6300 : Exclusion framework
      System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
      If(LTS_ApplicationAutomationUtility.checkTriggerApplicability())
      {return;}


    List<Lead> listLead = new List<Lead>();
    List<Lead> listLeadContact = new List<Lead>();
    LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler();
    String strEvent;
    
     if(trigger.IsInsert && trigger.IsBefore){
        oLeadTriggerHandler.PopulateLeadOwner(Trigger.new);
    
    }

    
    

    for(Lead oLead : trigger.new){
    if(trigger.IsUpdate){
    if(oLead.SAPAccountNumber__c!=trigger.oldmap.get(oLead.Id).SAPAccountNumber__c && oLead.SAPAccountNumber__c== null){
      oLead.Account__c = null;
    if(oLead.Contact_SAP_ID__c !=trigger.oldmap.get(oLead.Id).Contact_SAP_ID__c && oLead.Contact_SAP_ID__c == null)
      oLead.Contact_SAP_ID__c = null;
     }
     }

    if(trigger.IsUpdate){
        strEvent = 'Update';
     if(oLead.SAPAccountNumber__c!=trigger.oldmap.get(oLead.Id).SAPAccountNumber__c){
          listLead.add(oLead);
          
      }
      if(oLead.Contact_SAP_ID__c !=trigger.oldmap.get(oLead.Id).Contact_SAP_ID__c ){
         listLeadContact.add(oLead);
         
      }
     }
       else if(trigger.IsInsert && trigger.IsAfter){
         strEvent = 'Insert';
         listLead.add(oLead);
         listLeadContact.add(oLead);
     }
     }
     
  //  oLeadTriggerHandler.PopulateAccountonLead(listLead,strEvent);   
  //  oLeadTriggerHandler.PopulateContactonLead(listLeadContact,strEvent);   
     
}