public without sharing class ESC_AttachmentTriggerInsertHandler {
    public static void onAfterInsert(List<Attachment> caseNewList){
            string labelName = 'ESC_ViaAttachment';
        set<String> caseIDs = new set<string>();
        List<Attachment> lstattach= new List<Attachment>();
       for(Attachment em: caseNewList){
           if(((String) em.ParentId).StartsWith('500')){
                caseIDs.add(em.parentId);
                lstattach.add(em);
            }
        }
        if(caseIDs.size()>0){
        ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(caseIDs,labelName,Label.ESC_ViaAttachment );
        //ESC_ReferalTriggerHelperClass.updateFileUPDForCases(CaseIDs);    
        }

        if(lstattach.size()>0){            
            ESC_UPD_Utility.CaseUPDCustomerAttachment(lstattach);
         }
        }
    
}