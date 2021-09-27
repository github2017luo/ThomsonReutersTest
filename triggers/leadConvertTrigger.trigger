trigger leadConvertTrigger on Lead (After Update) {
  
 
    ODTDG_LeadConvert.processLeadTrigger(trigger.newMap, trigger.oldMap);
    
 
}