//Implemented as part of SOC-9607
global without sharing class APTS_CreateOrderAssetJob implements Database.Batchable<sObject> {
    //map of userid - user
    Set<ID> propList = new Set<ID>();

        //Constructor initialization
        global APTS_CreateOrderAssetJob() {
        //propList = props;
        }
        
        //Quuery method.
        global Database.QueryLocator start(Database.BatchableContext BC) {
        
        return DataBase.getQueryLocator([SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Apttus_Proposal__Approval_Stage__c ='Accepted' and DocusignOrderAssetFlag__c = true and APTS_Docusign_Order_Created__c =false and APTS_Is_Order_Created__c=false]);
        }

    //Execute Method.
        global void execute(Database.BatchableContext BC,List<Apttus_Proposal__Proposal__c> scopeprop) {
        System.debug('Batch record size'+scopeprop.size());
        List<Id> props = new List<ID>();
        // List<Id> proposals = new List<Id>();
        for(Apttus_Proposal__Proposal__c pro:scopeprop){
        props.add(pro.Id);
        }
        

        List<Apttus_Proposal__Proposal__c > proposalsToUpdate= [Select id,APTS_Docusign_Order_Created__c,Apttus_Proposal__Opportunity__c, 
                                                                Latam_APTS_Reason__c,
                                                                Apttus_Proposal__Approval_Stage__c,APTS_Order_Is_Created__c
                                                                from Apttus_Proposal__Proposal__c where id IN :props];
        for (Integer i=0;i<proposalsToUpdate.size();i++){
        if(proposalsToUpdate !=null && proposalsToUpdate[i].APTS_Order_Is_Created__c )
          {
                proposalsToUpdate[i].Latam_APTS_Reason__c='Duplicate';
                proposalsToUpdate[i].Apttus_Proposal__Approval_Stage__c='Expired';
          }
         else{       
                Apttus_QPConfig.QPConfigWebService.acceptQuote(proposalsToUpdate.get(i).id);
                proposalsToUpdate.get(i).APTS_Docusign_Order_Created__c = true;
          }
        }
        update proposalsToUpdate;
    }

//Finish method to execute at last.
global void finish(Database.BatchableContext BC) {

}
}