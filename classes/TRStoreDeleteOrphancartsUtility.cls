/*  @description :  Batch class to delete unused trstore carts and unused carts and Proposals 
*/
public class TRStoreDeleteOrphancartsUtility implements Database.Batchable<sObject> {

    /*  @description :  Delete all unused cart records, cart records from both TRStore and transact */ 
    public static LIST<Database.DeleteResult> deleteCartDetails(LIST<Apttus_Config2__ProductConfiguration__c> toDeleteCarts){
        return database.delete(toDeleteCarts, false);
    }
    /*  @description :  Delete unused Transact proposals  */
    public static LIST<Database.DeleteResult> deleteProposalDetails(LIST<Apttus_Proposal__Proposal__c> toDeleteProposals){
        return database.delete(toDeleteProposals, false);
    }
    
    /*  @description :  Batch Start to get unused unused cart records */
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        integer noofDaysCount = 90 ;
        string cartName = 'Auto Generated';
        string cartNameTransact = 'Auto Generated';
        string cartStatus = 'New';
        string cartModifieduserId ;
        string cartModifieduserIdTransact;
        
       
        if(Static_Values__c.getAll().containsKey('cartOrphanCartDeleteDays')){
            // @description : if(Static_Values__c.getAll().get('cartOrphanCartDeleteDays').value__c.isNumeric()){
              noofDaysCount = integer.valueOf(Static_Values__c.getAll().get('cartOrphanCartDeleteDays').value__c);
            //}
        } 
        
        if(test.isRunningTest()){
            noofDaysCount = -5 ;
        }
        
        if(Static_Values__c.getAll().containsKey('cartName') ){
              cartName = Static_Values__c.getAll().get('cartName').value__c;
        } 
        if(Static_Values__c.getAll().containsKey('cartNameTransact') ){
              cartNameTransact = Static_Values__c.getAll().get('cartNameTransact').value__c;
        } 
        
        if(Static_Values__c.getAll().containsKey('cartStatus') ){
              cartStatus = Static_Values__c.getAll().get('cartStatus').value__c;
        } 
        
        if(Static_Values__c.getAll().containsKey('cartModifiedAliase') ){
              cartModifieduserId  = Static_Values__c.getAll().get('cartModifiedAliase').value__c;
        }
        
        if(Static_Values__c.getAll().containsKey('cartModifiedAliaseTransact') ){
              cartModifieduserIdTransact  = Static_Values__c.getAll().get('cartModifiedAliaseTransact').value__c;
        }
        
        date tobeConsiderDate = system.today().addDays(noofDaysCount*(-1));
        System.debug(loggingLevel.INFO,'todate'+tobeConsiderDate);
        //return Database.getQueryLocator([Select id from Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c = null AND Name IN: cartNameList AND Apttus_Config2__Status__c =: cartStatus AND LastModifiedById IN: cartModifieduserIdList  AND LastModifiedDate <=: tobeConsiderDate ]);
        return Database.getQueryLocator([Select id, Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c, Apttus_QPConfig__Proposald__r.LastModifiedDate  from Apttus_Config2__ProductConfiguration__c WHERE ((Apttus_QPConfig__Proposald__c = null AND Name =:cartName AND Apttus_Config2__Status__c =: cartStatus AND LastModifiedById =:cartModifieduserId) OR (Name =:cartNameTransact AND Apttus_Config2__Status__c =: cartStatus AND LastModifiedById =:cartModifieduserIdTransact))  AND LastModifiedDate <=: tobeConsiderDate ]);
    }
    
    /*  @description :  Execute method starts, writing delete carts */
    public void execute(Database.BatchableContext bc, List<Apttus_Config2__ProductConfiguration__c> records){
         
        // process each batch of records
       // LIST<id> configIds = new LIST<id>();
        MAP<id, Apttus_Config2__ProductConfiguration__c> pcMap = new MAP<id, Apttus_Config2__ProductConfiguration__c>(); 
        System.debug(loggingLevel.INFO,'records'+records);
        for(Apttus_Config2__ProductConfiguration__c pc: records ){
            pcMap.put(pc.id, pc);
                        
        }
        
       
        
        
        LIST<Lead> leads= new LIST<lead>([Select id, firstName, lastName, Product_Configuration__c from Lead WHERE Product_Configuration__c IN: records ]);
        
        for(Lead l: leads){
            pcMap.remove(l.Product_Configuration__c );
        }
        System.debug(loggingLevel.INFO,'size'+pcMap.size());
       
        LIST<Apttus_Proposal__Proposal__c> proposalsDeletes = filterProposalsToDelete(pcMap.Values());
       
        
       LIST<Database.DeleteResult> detRes = deleteCartDetails(pcMap.Values());
       LIST<Database.DeleteResult> propDeleteRes = deleteProposalDetails(proposalsDeletes);
       
       inActivateUEProposalRecords(pcMap.Keyset());
       
       System.debug(loggingLevel.INFO,'detRes'+detRes);
       System.debug(loggingLevel.INFO,'propDeleteRes'+propDeleteRes);
        
    }
    
    /*  @description :  Final method      */
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        Integer i=0;
        i++;
    } 
    /*  @description :     get transact unused quotes...........*/
    public static LIST<Apttus_Proposal__Proposal__c> filterProposalsToDelete(LIST<Apttus_Config2__ProductConfiguration__c> proposalsRec){
    
      //  LIST<Apttus_Config2__ProductConfiguration__c> tobeDeleteList = new LIST<Apttus_Config2__ProductConfiguration__c>();
        
        integer noofDaysCount = 90 ;
        if(Static_Values__c.getAll().containsKey('cartOrphanCartDeleteDays')){
            //if(Static_Values__c.getAll().get('cartOrphanCartDeleteDays').value__c.isNumeric()){
              noofDaysCount = integer.valueOf(Static_Values__c.getAll().get('cartOrphanCartDeleteDays').value__c);
            //}
        } 
        date tobeConsiderDate = system.today().addDays(noofDaysCount*(-1));
         
         system.debug(loggingLevel.INFO,'Hello carts to delete'+proposalsRec);
         LIST<Apttus_Proposal__Proposal__c> proposalsToDelete = new LIST<Apttus_Proposal__Proposal__c>();
         
        for(Apttus_Config2__ProductConfiguration__c c: proposalsRec){
            
             system.debug(loggingLevel.INFO,'c.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c........'+c.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c);
            
            if(c.Apttus_QPConfig__Proposald__c != null){
                if(c.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c == 'Draft' && c.Apttus_QPConfig__Proposald__r.LastModifiedDate <= tobeConsiderDate){
                    //tobeDeleteList.add(c);
                    proposalsToDelete.add(new Apttus_Proposal__Proposal__c(id=c.Apttus_QPConfig__Proposald__c ));
                }
            }
        }
        
         system.debug(loggingLevel.INFO,'tobeDeleteList........'+proposalsToDelete);
            
        return proposalsToDelete;
             
        
    }
    
     
    /*  @description :    Inactivate UE related object dat after deleted Carts and proposals ........... */
    private static void inActivateUEProposalRecords(set<ID> proposalsIds){
        
            LIST<UE_Proposal__c> ueProposalsIds = new LIST<UE_Proposal__c>();
            
            if(Schema.sObjectType.UE_Proposal__c.isAccessible()){
                ueProposalsIds = [SELECT id, InActive__c from UE_Proposal__c WHERE cartId__c IN: proposalsIds];
            }
            
            for(UE_Proposal__c u : ueProposalsIds ){
                u.InActive__c = TRUE;
            }
            
            if(!ueProposalsIds.isEmpty()){
                Database.update(ueProposalsIds, false);
            }    
    }
    
    
}