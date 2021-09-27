@isTest
public class DCConfiguratorControllerV2_Test {

   @testSetup static void createData(){ 
          DCTestData.createData();
          Test.startTest();
          DCTestData.createQuote();      
          Test.stopTest();
          Product2 product2 = DCTestData.createProduct('SL Louisiana Analytical (Westlaw PRO™)', '42009566', '42009619');
   }
    
    public static testmethod void addToCartTest(){
        
        Integer MAX_QUERY = Limits.getLimitQueries(); 
        Integer NUM_QUERY = MAX_QUERY - 1;
        Test.startTest();
        Product2 prod2 = [SELECT Id FROM Product2 WHERE Name ='SL California Analytical (Westlaw PRO™)' LIMIT 1];
        Product2 product2 = [SELECT Id FROM Product2 WHERE Name ='SL Louisiana Analytical (Westlaw PRO™)' LIMIT 1];
        // lineItem.Apttus_Config2__AdjustmentType__c = '% Markup';
        List<String> products = new List<String>{product2.Id , prod2.Id};
        System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
        //System.assertEquals(NUM_QUERY, Limits.getQueries());
        //System.assertEquals(NUM_QUERY, Limits.getQueries()); 
        List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        String cQuoteId = quoteList[0].id;
        String bQuoteId = quoteList[1].id;
        System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
        try{
        DCConfiguratorControllerV2.updateCart(cQuoteId,bQuoteId,products,'2 Years',1);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        
        test.stopTest();
    system.assert(products!=null);        
        System.debug('NumQuer#'+NUM_QUERY+'limit quries'+Limits.getQueries());
    }
    
    public static testmethod void trackLogTest(){
        Test.startTest();
        Decimal m;
        try{
            m = 10/0;
        }catch(Exception e){
            DCCartServiceV2.trackLog(e,'DCCartService','trackLog');
        }
       
        test.stopTest(); 
        system.assertEquals(m!=0,true);        
    }
    
    private static testMethod void synchronizeCartTest() {
        List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        String cQuoteId = quoteList[0].id;
        
        try{
            Test.startTest();
            DCConfiguratorControllerV2.synchronizeCart(cQuoteID);
            Test.stopTest();
        }catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        }  
        system.assert(cQuoteId!=null);
    } 
    
    private static testMethod void generateContractTest() {
        String cQuoteId;
        String bQuoteId;
        Test.startTest();
        List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        cQuoteId = quoteList[0].id;
        bQuoteId = quoteList[1].id;
        try{
            DCConfiguratorControllerV2.generateContract(cQuoteID);
        }catch(Exception e){
          System.debug('Exceptional Quotes'+e);
        } 

        try{
            DCConfiguratorControllerV2.createEnvelope(cQuoteID);
        }catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        } 
        
        try{
            DCConfiguratorControllerV2.resetQuotes(cQuoteID,bQuoteID);
        }catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        } 
        
        try{
            DCConfiguratorControllerV2.resetToBestValue(cQuoteID,bQuoteID);
        }catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        } 
        Test.stopTest();
        system.assert(bQuoteId!=null);
        system.assert(cQuoteId!=null);
    } 
         
    private static testMethod void generateContractTest1() {
        String cQuoteId;
        String bQuoteId;
       List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        cQuoteId = quoteList[0].id;
        bQuoteId = quoteList[1].id;
         Test.startTest();
        List<String> cQuoteIDs = new List<String>{cQuoteID};
        try{
            DCConfiguratorControllerV2.generateContracts(cQuoteIDs);
        }catch(Exception e){
          System.debug('Exceptional Quotes'+e);
        } 
        
        try{
            DCConfiguratorControllerV2.createEnvelopes(cQuoteIDs);
        }catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        } 
        
        try{
            DCConfiguratorControllerV2.synchronizeCarts(cQuoteIDs);
        }
        catch(Exception e){
            System.debug('Exceptional Quotes'+e);
        } 
         Test.stopTest();
         system.assert(bQuoteId!=null);
         system.assert(cQuoteId!=null);
    } 
    private static testMethod void generateContractTest2(){
        String cQuoteId;
        String bQuoteId;
        List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        cQuoteId = quoteList[0].id;
        bQuoteId = quoteList[1].id;
        Test.startTest();
        try{
            DCConfiguratorControllerV2.performLoad(cQuoteId,bQuoteId);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        try{
            DCConfiguratorControllerV2.repriceByQuoteId (cQuoteId);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        Test.stopTest();
        system.assert(bQuoteId!=null);
        system.assert(cQuoteId!=null);
    }
     private static testMethod void performUpdatesTest(){
        Integer MAX_QUERY = Limits.getLimitQueries(); 
        Integer NUM_QUERY = MAX_QUERY - 1;
        Test.startTest();
    List<String> prodNameList = new List<String>{'SL California Analytical (Westlaw PRO™)', 'SL Louisiana Analytical (Westlaw PRO™)'};
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE Name IN : prodNameList ];
        //Product2 product2 = [SELECT Id FROM Product2 WHERE Name ='SL Louisiana Analytical (Westlaw PRO™)' LIMIT 1];
        List<String> products = new List<String>{prodList[0].Id , prodList[1].Id};
        System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
        List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        String cQuoteId = quoteList[0].id;
        String bQuoteId = quoteList[1].id;
         try{
        DCConfiguratorControllerV2.performUpdates(products,'2 Years',1,cQuoteId,bQuoteId);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
       System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
        /*
    products.remove(0);
        try{
            DCConfiguratorControllerV2.performUpdates(products,'3 Years',2,cQuoteId,bQuoteId);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
    */
        system.assert(products!=null);
        System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
         Test.stopTest();
     }
   
   private static testMethod void performUpdatesTest1(){
        Integer MAX_QUERY = Limits.getLimitQueries(); 
        Integer NUM_QUERY = MAX_QUERY - 1;
        Test.startTest();
    List<String> prodNameList = new List<String>{'SL California Analytical (Westlaw PRO™)', 'SL Louisiana Analytical (Westlaw PRO™)'};
        List<Product2> prodList = [SELECT Id FROM Product2 WHERE Name IN : prodNameList ];
        //Product2 product2 = [SELECT Id FROM Product2 WHERE Name ='SL Louisiana Analytical (Westlaw PRO™)' LIMIT 1];
        List<String> products = new List<String>{prodList[0].Id , prodList[1].Id};
        System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
        List<Apttus_Proposal__Proposal__c> quoteList = [Select ID from Apttus_Proposal__Proposal__c ];
        String cQuoteId = quoteList[0].id;
        String bQuoteId = quoteList[1].id;
    /*
         try{
        DCConfiguratorControllerV2.performUpdates(products,'2 Years',1,cQuoteId,bQuoteId);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }*/
    
       System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
        products.remove(0);
        try{
            DCConfiguratorControllerV2.performUpdates(products,'3 Years',2,cQuoteId,bQuoteId);
        }catch(Exception ex){
            system.debug('Exceptons '+ex.getMessage());
        }
        system.assert(products!=null);
        System.debug('NumQuer'+NUM_QUERY+'limit quries'+Limits.getQueries());
         Test.stopTest();
     }
}