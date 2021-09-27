trigger APTS_AttachmentTrigger on Attachment (after insert) {
    List<id> attList = new List<id>();   
  for(Attachment att :Trigger.New){
   if(att.Name.contains('AVC')){
   attList.add(att.ParentId);
   }
  }
  List<Apttus_Proposal__Proposal__c> proposals = [select id, APTS_AVC_Order_Form__c from Apttus_Proposal__Proposal__c where id IN : attList];
    if(proposals.size()>0){
             for(Apttus_Proposal__Proposal__c proposal : proposals){
                                if(proposal.APTS_AVC_Order_Form__c==true){
                                    proposal.APTS_AVC_Order_Form__c=false;
                        }  
                                
            }
      update proposals;
           }
    
     }