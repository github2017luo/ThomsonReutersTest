public without sharing class APTS_CloneExpiredQuote{
     public String proposalId {get;set;} 
     public PageReference pg;
     public APTS_CloneExpiredQuote(ApexPages.StandardController controller) {
     proposalId =controller.getRecord().id;
    //redirect();
    }
    public APTS_CloneExpiredQuote(){    
     //redirect();    
    }
    public Pagereference redirect(){
      KeyValueListStore__c proposalrecordtypeId = KeyValueListStore__c.getvalues('ApttusProposalRecordtypeId');
        //SOC-9796 PMD Fix
        if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
        Apttus_Proposal__Proposal__c quoteToClone =[Select id,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Account__c,APTS_SSD_Sold_To__c  from Apttus_Proposal__Proposal__c  where id=:proposalId ];
             //SOC-9796 PMD Fix
           if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isCreateable()){
            Apttus_Proposal__Proposal__c clonedquote= quoteToClone.clone(false,true,false,false);
                   clonedquote.recordtypeID= proposalrecordtypeId.TextValue__c;
                   insert clonedquote;
                    pg = new PageReference('/'+clonedquote.Id);              
                   
        }
      }
       return pg;
    }
    
}