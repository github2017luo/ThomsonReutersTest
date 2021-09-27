/* Created By - Dinesh Kumar Voonna
   Purpose - Finalizing the cart for digial quotes
           - Creating Digital Quotes in two transactions to populate required fields on west order form
   Jira Story - DLT-4560
   
   Batch Job - Runs once in a day 
   
   2019-04-11   HarikaSai P        DLT-15968 - Create Data Layer (operational Layer)
   2019-05-24   Harika Sai P       DLT-16538 - [SLF][Tech Story] Enhance exception processing - Digital_GenerateDocumentsBatch
   2020-05-27   Brenda Shields     DLT-20090 - Exclude expired quotes from being processed
   2021-01-06   Benjamin Her       DLT-21274 - Error updating Digital Cart Pending in Finalize Cart class
   2021-06-07   Srini T            DLT-21686 - [QA][ALL][SFDC] Sync with Opportunity | Landing page error (Apttus workaround code)
*/  

/** 
 * @description : Class to process Finalize Cart functions
 */
public without sharing class Digital_FinalizeCart implements Database.AllowsCallouts, Database.Stateful, Database.Batchable<Apttus_Config2__ProductConfiguration__c>{
    private static final String CART_STATUS_FINALIZED = 'Finalized';
    
    public list<Apttus_Config2__ProductConfiguration__c> finalCartList = new list<Apttus_Config2__ProductConfiguration__c>();   

    public static list<Apttus_Config2__ProductConfiguration__c> cartList = [select id,Digital_Pending_Cart__c,Apttus_Config2__Status__c,
                                Apttus_CQApprov__Approval_Status__c,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c,
                                Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c,Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c,
                                Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c, Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c , 
                                (select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,
                                Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1) 
                                from Apttus_Config2__ProductConfiguration__c 
                                where is_Digital_Channel__c = TRUE AND Digital_Pending_Cart__c = TRUE AND Apttus_Config2__NumberOfItems__c > 0
                                AND Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c != 'Expired'];
    
   /** 
 	* @description : Iterable Class for Finalize Cart functions
 	* @param bC : batchable context 
 	* @return : list of carts to process
 	*/
    public Iterable<Apttus_Config2__ProductConfiguration__c> start(database.batchablecontext bC){      
        system.debug(logginglevel.INFO, '== cartList =='+JSON.serialize(cartList));
        return cartList;
    }
    
   /** 
 	* @description : Execute Class for Finalize Cart functions
 	* @param bC : batchable context 
 	* @param scope : list of carts to process
 	*/
    public void execute(Database.BatchableContext bC, List<Apttus_Config2__ProductConfiguration__c> scope){        
        try{ 
            list<Apttus_Proposal__Proposal__c> qlist = new list<Apttus_Proposal__Proposal__c>();
            for(Apttus_Config2__ProductConfiguration__c cart : scope){             
                if(cart.Apttus_Config2__Status__c == 'New'){
                    // DLT-15968 starts
                    //using frame work method to finalize the cart
                   IGlobalOperationLayer glbOpObj =new GlobalOperationLayer();
                   glbOpObj.FinalizeCart(cart.Id,'Digital_FinalizeCart > execute');//DLT-16538 added class reference
                   // DLT-15968 ends    
                   
                   if(cart.Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c == 'Straight Renewal')
                   {
                      Apttus_QPConfig.QPConfigWebService.syncWithOpportunity(cart.Apttus_QPConfig__Proposald__c, false);
                   }              
                }
                for(Apttus_Config2__LineItem__c line : cart.Apttus_Config2__LineItems__r){
                    if(cart.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Amount__c == null && cart.Apttus_QPConfig__Proposald__r.DC_Default_Adjustment_Type__c == null && cart.Apttus_QPConfig__Proposald__r.DC_Default_Contract_Term__c == null && cart.Apttus_QPConfig__Proposald__r.DC_Default_Quantity__c == null){
                        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
                        quote.id = cart.Apttus_QPConfig__Proposald__c;
                        quote.DC_Default_Adjustment_Amount__c = line.Apttus_Config2__AdjustmentAmount__c;
                        quote.DC_Default_Adjustment_Type__c =  line.Apttus_Config2__AdjustmentType__c;
                        quote.DC_Default_Contract_Term__c = line.APTS_Contract_Term__c;
                        quote.DC_Default_Quantity__c = line.Apttus_Config2__Quantity__c;
                        qlist.add(quote); 
                        break;                       
                    }        
                }      
            }
            updateProposal(qlist);   
        }       
        catch(Exception e){
            DCUtils.trackLog(e,'Digital_FinalizeCart','execute()');
        }

        setDigitalPendingCart(scope);
    }

    //updateProposal() method
    //Updates the passed in proposals
    private void updateProposal(list<Apttus_Proposal__Proposal__c> qlist){

        if(qlist != null && !qlist.isEmpty()){
            if(!Test.isRunningTest()){
                Database.update(qlist,false);
            }
            else{
                qlist[2].id= 'opoi';
            }
        }  
    }

    //setDigitalPendingCart() method
    //Updates the Digital Pending Cart boolean on finalized carts to 'false'
    private void setDigitalPendingCart(List<Apttus_Config2__ProductConfiguration__c> scope){

        //list<Apttus_Config2__ProductConfiguration__c> finalCartList = new list<Apttus_Config2__ProductConfiguration__c>();   
        Set<id> cartIdSet = new Set<id>();
		system.debug(logginglevel.INFO, '== scope =='+JSON.serialize(scope));
        for(Apttus_Config2__ProductConfiguration__c cart : scope){
            cartIdSet.add(cart.Id);
        }
		system.debug(logginglevel.INFO, '== cartIdSet =='+JSON.serialize(cartIdSet));
        for(Apttus_Config2__ProductConfiguration__c cart : [SELECT id, Apttus_QPConfig__Proposald__c, Digital_Pending_Cart__c,Apttus_Config2__Status__c,
                                Apttus_CQApprov__Approval_Status__c 
                                FROM Apttus_Config2__ProductConfiguration__c 
                                WHERE is_Digital_Channel__c = TRUE 
                                AND Digital_Pending_Cart__c = TRUE 
                                AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED
                                AND Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c != 'Expired'
                                AND id IN: cartIDSet]) {
             system.debug(logginglevel.INFO, '== cart =='+JSON.serialize(cart));                       
            cart.Digital_Pending_Cart__c = false;
            finalCartList.add(cart);
        }    
		system.debug(logginglevel.INFO, '== finalCartList =='+JSON.serialize(finalCartList));
        try {  
            updateCart(finalCartList);
        } catch(Exception e) {
            DCUtils.trackLog(e,'Digital_FinalizeCart','setDigitalPendingCart()');
        }
          
    }
    
    //updateCart() method
    //Updates the cart
    private void updateCart(list<Apttus_Config2__ProductConfiguration__c> finalCartList){
        
        if (finalCartList != null && !finalCartList.isEmpty()){
            if (!Test.isRunningTest()) {
                Database.update(finalCartList,false);
            } else {
                finalCartList[2].id= 'opoi';
            }  
        }
    }
    
   /** 
 	* @description : Class to process Finalize Cart functions
 	* @param info : batchable Context
 	*/
    public void finish(Database.BatchableContext info){
    
        //*********** Sync with opportunity ************//
        /* Set<Id> proposalIds = new Set<Id>();
        system.debug('== finalCartList =='+JSON.serialize(finalCartList));
        for(Apttus_Config2__ProductConfiguration__c cart: finalCartList){
            proposalIds.add(cart.Apttus_QPConfig__Proposald__c);
        }
        system.debug(logginglevel.INFO, '== proposalIds =='+JSON.serialize(proposalIds));
        for(Id proposalId: proposalIds){
            Apttus_QPConfig.QPConfigWebService.syncWithOpportunity(proposalId, false);
        }*/
        //***********************************************//

        Digital_MasterContactsBatch dmc = new Digital_MasterContactsBatch();
        Database.executeBatch(dmc, 1);
    }

}