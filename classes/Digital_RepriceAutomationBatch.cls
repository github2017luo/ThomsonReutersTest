/*
History
   -------
2020-02-09   Srikanth Kota DLT-18966 [Tech] Improve Reprice job to run for specific business segments.
*/

global class Digital_RepriceAutomationBatch implements Database.AllowsCallouts, Database.Batchable<Apttus_Config2__ProductConfiguration__c>{
    Public Boolean hasPendingItems;
   // Public Map<Apttus_Config2__ProductConfiguration__c, Boolean> cartpricepending = new Map<Apttus_Config2__ProductConfiguration__c, Boolean>();     
   //Public List<Apttus_Config2__ProductConfiguration__c> cartslist = new List<Apttus_Config2__ProductConfiguration__c>();
    
    global Iterable<Apttus_Config2__ProductConfiguration__c> start(database.batchablecontext BC){ 
     //DLT-18966
     Set<string> businessSegment = new Set<string>();
     Map<String, Digital_Reprice__c> repriceSegmentMap = Digital_Reprice__c.getAll();

        for(Digital_Reprice__c Segment : repriceSegmentMap.values()) {
            if(Segment.Enable_Reprice__c == true){
                businessSegment.add(Segment.Business_Segment__c);
            }
        }
      // DLT-18966 End Update Below Soql withBusiness Segment  
      list<Apttus_Config2__ProductConfiguration__c> carts = [select id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.APTS_Quote_Validity_Override__c, Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c,Apttus_QPConfig__Proposald__r.APTS_Pricing_Valid_Date__c, Apttus_QPConfig__Proposald__r.APTS_Validation_Messages__c,Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact__c,Apttus_QPConfig__Proposald__r.APTS_Order_Confirmation_Contact_Email__c, (Select id, Name, Apttus_Config2__PricingStatus__c,Apttus_Config2__ConfigurationId__c from Apttus_Config2__LineItems__r) from Apttus_Config2__ProductConfiguration__c 
                                                               where (Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.isDigitalSpearHead__c = TRUE AND 
                                                               Apttus_Config2__Status__c = 'Finalized' AND 
                                                               Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c = 'Presented' AND 
                                                               Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c IN ('Best Value', 'Premium', 'Best Value+Config') AND
                                                               Apttus_QPConfig__Proposald__r.APTS_Approval_Segment_Default__c IN : businessSegment )]; //DLT-18966
    
        System.debug('Cart list-->'+carts.size());
       
       return carts;
    }
   
    global void execute(Database.BatchableContext BC, List<Apttus_Config2__ProductConfiguration__c> scope){ 
    APTS_LineItemTriggerHandler.afterUpdate = true;
    APTS_ProductConfigurationTriggerHandler.afterUpdate = true; 
      System.debug('Scope listInExecutemethod-->'+scope);
       List<Id> cartdet = new List<Id>();
        List<Apttus_Config2__LineItem__c> acllist = new List<Apttus_Config2__LineItem__c>();
       Set<id> cartid = new Set<id>();
        
       if(scope!= Null){
           System.debug('Scope list-->'+scope);
       for(Apttus_Config2__ProductConfiguration__c cart: scope){
           for(Apttus_Config2__LineItem__c line: cart.Apttus_Config2__LineItems__r){
               System.debug('Enter line item'+line);
            if(line!= Null ){
            Apttus_Config2__LineItem__c acl = new Apttus_Config2__LineItem__c ();
            acl.id = line.id;
            acl.Apttus_Config2__PricingStatus__c = 'Pending';
            acl.Apttus_Config2__ConfigurationId__c = line.Apttus_Config2__ConfigurationId__c;
            acllist.add(acl);
           // cartid.add(acl.Apttus_Config2__ConfigurationId__c);
            
            }
           }
           
         }
          update acllist;
          System.debug('acllist'+acllist);
          for(Apttus_Config2__ProductConfiguration__c cart: scope){
           Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
                        objUpdatePriceRequestDO.CartId = cart.Id;
                        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
                        System.debug('result-->'+result);
                        hasPendingItems = result.IsPricePending;
                        if(hasPendingItems!= False)
                           cartdet.add(cart.Id);
                         System.debug('cartdet-->'+cartdet);
           
       }
           
       
           
       
                    List<Apttus_Proposal__Proposal__c> proplst = new List <Apttus_Proposal__Proposal__c>();
                    List<Apttus_Config2__ProductConfiguration__c> cartdetlst = [Select id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.APTS_Quote_Validity_Override__c,Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c,Apttus_QPConfig__Proposald__r.APTS_Pricing_Valid_Date__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c
                                                                               from Apttus_Config2__ProductConfiguration__c where id In: scope];
                   for(Apttus_Config2__ProductConfiguration__c cart: cartdetlst){
                       Apttus_Proposal__Proposal__c apc = new Apttus_Proposal__Proposal__c();
                           apc.id = cart.Apttus_QPConfig__Proposald__r.id;
                           apc.DC_Contract_Not_In_Sync__c = True;
                       /* if(cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c >= (Date.today() + 60)){
                           if(!(cart.Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c < (Date.today() - 30))){
                               apc.APTS_Quote_Validity_Override__c = cart.Apttus_QPConfig__Proposald__r.APTS_Pricing_Valid_Date__c - 1;
                               }
                           else{
                               apc.APTS_Quote_Validity_Override__c = null ;
                               }
                        }
                       else if (cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c < Date.today())
                             apc.APTS_Quote_Validity_Override__c = null ;
                       else
                           apc.APTS_Quote_Validity_Override__c = cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c;
                       
                         System.debug('date value'+cart.Apttus_QPConfig__Proposald__r.APTS_Quote_Validity_Override__c); */
                           proplst.add(apc);
                   }    
                   if(proplst.size()>0){
                       update proplst;
                   }
           
       }
    
      
     System.debug('queryresult-->'+limits.getQueries()+ 'next-->'+limits.getLimitQueries());
     repriceupdate(cartdet);
        System.debug('queryresult-->'+limits.getQueries()+ 'next-->'+limits.getLimitQueries());
     }   
          public static Digital_Exception_Log__c createExceptionLog(string additinformation, string classref, string exceptmessage, string excepttype, string usermessage){
       Digital_Exception_Log__c exLog = new Digital_Exception_Log__c();
       exLog.Additional_Information__c = additinformation;
       exLog.Class_Reference__c = classref;
       exLog.Exception_Message__c = exceptmessage;
       exLog.Exception_Type__c = excepttype;
       exLog.User_Message__c = usermessage;
       
       return exLog;
   }
   
   Public static void repriceupdate(list<Id> cartpricelst){
       System.debug('queryresult2-->'+limits.getQueries()+ 'next-->'+limits.getLimitQueries());
        list<Digital_Exception_Log__c> exList = new list<Digital_Exception_Log__c>();
       List<Apttus_Config2__ProductConfiguration__c> cartdetlst = [Select id,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.APTS_Quote_Validity_Override__c, Apttus_QPConfig__Proposald__r.Apttus_QPConfig__ConfigurationFinalizedDate__c,Apttus_QPConfig__Proposald__r.APTS_Pricing_Valid_Date__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c from Apttus_Config2__ProductConfiguration__c where id In: cartpricelst];
       List<Id> cartdet2 = new List<Id>();
       List<Apttus_Proposal__Proposal__c> proplst = new List <Apttus_Proposal__Proposal__c>();
       for(Apttus_Config2__ProductConfiguration__c cart: cartdetlst){
          System.debug('keyset-->'+cartdetlst);
           if(cart!= Null){
                 Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
                 objUpdatePriceRequestDO.CartId = cart.Id;
                 Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
                 System.debug('result2-->'+result);
                
                 Apttus_Proposal__Proposal__c apc = new Apttus_Proposal__Proposal__c();
                   apc.id = cart.Apttus_QPConfig__Proposald__r.id;
                   apc.DC_Contract_Not_In_Sync__c = True;
                   
             /*  if(cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c >= (Date.today() + 60)){
                           if(!(cart.Apttus_QPConfig__Proposald__r.APTS_Pricing_Valid_Date__c <= (Date.today()-30))){
                               apc.APTS_Quote_Validity_Override__c = cart.Apttus_QPConfig__Proposald__r.APTS_Pricing_Valid_Date__c - 1;
                               }
                           else{
                               apc.APTS_Quote_Validity_Override__c = null ;
                               }
                }
                 else if (cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c < Date.today())
                             apc.APTS_Quote_Validity_Override__c = null ;
                       else
                           apc.APTS_Quote_Validity_Override__c = cart.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__r.Renewal_Date__c;
                       
                 System.debug('date value'+cart.Apttus_QPConfig__Proposald__r.APTS_Quote_Validity_Override__c); */
                   proplst.add(apc);
                if(result.IsPricePending!= False){
                   cartdet2.add(cart.id);
                   System.debug('apc value'+proplst);
                   System.debug('cartdet2'+cartdet2);
               //  cartdet2.add(cart.Apttus_QPConfig__Proposald__r);
                 
               }
           }
       }
                           
                if(!cartdet2.isempty())
                {
                   
                    update proplst;
                    repriceupdate(cartdet2);
                }
                   
 }   
    
global void finish(Database.BatchableContext info){ 
     
      
   }
}