/**
 * @description Helper for Trigger 'APTS_ContentDocumenLinkTrigger'
 */
public with sharing class APTS_ContentDocumenLinkTriggerHandler {
    
    /**
     * @description onAfterInsertContentDocuLink
     * @param isInsert 
     * @param isAfter 
     * @param cdLinkMap
     */
    public static void onAfterInsertContentDocuLink(Boolean isInsert,Boolean isAfter, Map<id, ContentDocumentLink> cdLinkMap){
      Set<id> cdList = new Set<id>(); 
      //List<id> proposalIds  =new List<id>();
      Map<String,String> mapdL=new Map<String,String>();
      Map<String,String> mapProposals=new Map<String,String>();
      
      for(ContentDocumentLink cdl :cdLinkMap.values()){
          if(cdl!=null && cdl.LinkedEntityId!=null && String.valueOf(cdl.LinkedEntityId).startsWith('a4N')){
              cdList.add(cdl.contentdocumentId);
              mapdL.put(cdl.contentdocumentId,cdl.LinkedEntityId);
          }
      }
      if(!mapdL.isEmpty() && !cdList.isEmpty()){
          mapProposals=getMapOfProposal(cdList,mapdL);
          System.debug(LoggingLevel.WARN, mapProposals);
          if(!mapProposals.isEmpty()){
              updateProposals(mapProposals);
          }
      }
        
      }
      /**
     * @description updateProposals
     * @param mapProposals 
     * 
     */     
      public static  void updateProposals(Map<String,String> mapProposals){
        List<Apttus_Proposal__Proposal__c> proposals = new List<Apttus_Proposal__Proposal__c>();

        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
           proposals = [select id, APTS_AVC_Order_Form__c from Apttus_Proposal__Proposal__c where id IN : mapProposals.values()];
        }
           if(proposals.size()>0){
                    for(Apttus_Proposal__Proposal__c proposal : proposals){
                                         System.debug(LoggingLevel.WARN, proposal.APTS_AVC_Order_Form__c);
                                       if(proposal.APTS_AVC_Order_Form__c==true){
                                           proposal.APTS_AVC_Order_Form__c=false;
                               }  
                                       
                   }
                   if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
                     update proposals;
                   }
           }       
      }
      /**
     * @description onAfterInsertContentDocuLink
     * @param cdList 
     * @param mapdL      
     * @return mapProposals
     */
      public static map<String,String> getMapOfProposal(Set<id> cdList,Map<String,String> mapdL){
          Map<String,String> mapProposals=new Map<String,String>();
      
          if(!cdList.isEmpty()){
             for(ContentVersion cv:[Select id,title,contentdocumentid from ContentVersion where contentdocumentid in :cdList]){
                 if(cv.Title.contains('AVC')){
                  mapProposals.put(cv.contentdocumentid,mapdL.get(cv.contentdocumentid));
                  }
             }
          }
          return mapProposals;
      } 
}