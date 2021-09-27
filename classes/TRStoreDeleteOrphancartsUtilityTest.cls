@istest(seealldata=false)
public class TRStoreDeleteOrphancartsUtilityTest{
/*
    @description test class for TRStoreDeleteOrphancartsUtility
*/


        //@description Started test coverage for TRStoreDeleteOrphancartsUtility
        public static testmethod void batchexecute(){
    
            TRStore_OrderTest.createStaticValues();
            
            LIST<Apttus_Config2__ProductConfiguration__c> cartLists = new LIST<Apttus_Config2__ProductConfiguration__c>(); 
            Apttus_Config2__ProductConfiguration__c cartRec = TRStore_OrderTest.createProductConfigurations();
            Apttus_Config2__ProductConfiguration__c cart1 =  insertDummyCart();
            Apttus_Config2__ProductConfiguration__c cart2 =  insertDummyCart();
            Apttus_Config2__ProductConfiguration__c cart3 =  insertDummyCart();
            
            cartLists.add(cartRec);
            cartLists.add(cart1);
            cartLists.add(cart2);
            cartLists.add(cart3);
             
             Database.insert(cartLists, false);
            System.assert(cartLists != null, 'Inserted cart List');
             
             system.debug(loggingLevel.INFO,'Hello...........      '+cart2.lastModifiedByID);
             
             
            integer noofDaysCount = 90 ;
            string cartName = 'Auto Generated';
            string cartStatus = 'New';
            string cartModifieduserId = userinfo.getuserId() ;
            
             date tobeConsiderDate = system.today().addDays(noofDaysCount*(1));
       
       
            LIST<Apttus_Config2__ProductConfiguration__c> cartListsQuery =  [Select id from Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c = null AND Name =: cartName AND Apttus_Config2__Status__c =: cartStatus AND LastModifiedBy.id=: cartModifieduserId  AND LastModifiedDate <=: tobeConsiderDate ];
            
             system.debug(loggingLevel.INFO,'cartListsQuery ..........    '+cartListsQuery );
           
            
             
            lead ld = new lead();
            ld.FirstName='TestFirstname';
            ld.LastName='TestLastName';
            ld.Email='testfirst.testlast@test.com';
            ld.IsConverted=false;
            ld.Company='TestCompany';
            ld.Lead_Microsite__c = 'PWC';
            ld.Product_Configuration__c = cart1.id;
            
            insert ld;
            
             TRStoreDeleteOrphancartsUtilitySchedule myClass = new TRStoreDeleteOrphancartsUtilitySchedule();   
             myClass.execute(null);
            
            
        }
        
        //@description get user cart record
        public static Apttus_Config2__ProductConfiguration__c  insertDummyCart(){
              
            Apttus_Config2__ProductConfiguration__c prodConfigObj = new Apttus_Config2__ProductConfiguration__c();
            prodConfigObj.Name = 'Auto Generated';
            prodConfigObj.Apttus_Config2__Status__c ='New';
             
             
             return prodConfigObj ;
        }
        
        
}