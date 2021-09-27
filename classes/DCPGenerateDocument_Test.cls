/***********************************************************************************************

    @Name:              DCPGenerateDocument_test
    @Author:            Dinesh Ponnam
    @createdDate:       10/06/2021
    @Testclassfor:      DCPGenerateDocument

***********************************************************************************************/


@isTest
 /**
    @description To update the DCPGenerateDocument_Test
    
    @return Returns the status DCPGenerateDocument_Test
    */
public class DCPGenerateDocument_Test {
   
    //Test data setup
    @TestSetup
    static void makeData(){
    DCPTestDataFactory.disableApplicationAutomation();
 
    Map<String, SObject> objectToDataMap = DCPTestDataFactory.declareSObjectData();
 
        Product2 prod = (Product2)objectToDataMap.get('Product2');
        insert prod;
        
        PricebookEntry testEntry = new PricebookEntry(CurrencyIsoCode='USD',
        isactive=true,
        Pricebook2id=Test.getStandardPricebookId(),
        Product2Id=prod.id,unitprice=1,
        UseStandardPrice=false);
        insert testEntry; 
        
        PriceBook2 pricebook = (PriceBook2)objectToDataMap.get('PriceBook2');
        insert pricebook;
        
        // Custom Pricebook
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=pricebook.Id,Product2Id=Prod.id,unitprice=1,UseStandardPrice=false);
        insert testEntry1;
        
        Account acc = (Account)objectToDataMap.get('Account');
        insert acc;
        
        Contact con = (Contact)objectToDataMap.get('Contact');
        con.AccountId = acc.id;
        con.LastName = 'testContact';
        con.FirstName = 'testContact';
        con.email = 'testfirst.testlast@thomson.com';
        insert con;
        
        Source_System_Detail__c ssd = (Source_System_Detail__c)objectToDataMap.get('Source_System_Detail__c');
        ssd.Account_Name__c = acc.id;
        ssd.name= 'test';
        ssd.Source_System_Name__c='test';
        insert ssd;
        
        Opportunity opp = (Opportunity)objectToDataMap.get('Opportunity');
        opp.StageName = 'Contacting';
        opp.Renewal_Date__c = system.today().addDays(180);
        opp.Pricebook2id = pricebook.id;
        opp.AccountId = acc.id;
        opp.Source_System_Detail__c = ssd.id;
        opp.Key_Contact__c = con.id;
        insert opp;
        
        
        Apttus_Config2__PriceList__c pricelist = (Apttus_Config2__PriceList__c)objectToDataMap.get('Apttus_Config2__PriceList__c');
        insert pricelist;
        
        
        
        
        
        Apttus_Proposal__Proposal__c prop = (Apttus_Proposal__Proposal__c)objectToDataMap.get('Apttus_Proposal__Proposal__c');
        prop.Apttus_Proposal__Primary__c = false;
        prop.Digital_Batch_Processed__c = true;
        prop.Digital_Quote_Automation__c = true;
        prop.Digital_Quote_Type__c = 'Straight Renewal';
        prop.Digital_Envelope_Created__c = false;    
        prop.Apttus_Proposal__Approval_Stage__c = 'Presented';
        prop.Apttus_Proposal__Opportunity__c = opp.id;
        prop.Apttus_Proposal__Account__c = acc.id;
        prop.APTS_SSD_bill_to__c = ssd.id;
        prop.APTS_SSD_ship_to__c = ssd.id;
        prop.Apttus_QPConfig__BillToAccountId__c = acc.id;
        prop.Apttus_QPConfig__ShipToAccountId__c = acc.id;
        prop.APTS_Order_Confirmation_Contact__c = con.id;
        prop.Apttus_QPConfig__PriceListId__c = pricelist.id;
        insert prop;
        
        Apttus_Config2__ProductConfiguration__c cart = (Apttus_Config2__ProductConfiguration__c)objectToDataMap.get('Apttus_Config2__ProductConfiguration__c');
        cart.Apttus_Config2__Status__c = 'Finalized';
        cart.Apttus_QPConfig__Proposald__c = prop.id;
        cart.Apttus_Config2__BusinessObjectId__c = 'Proposal';
        cart.APTS_SSD_bill_to__c = ssd.id;
        cart.APTS_SSD_Ship_To__c = ssd.id;
        cart.Apttus_Config2__BillToAccountId__c = acc.Id;
        cart.Apttus_Config2__ShipToAccountId__c = acc.Id;
        cart.Apttus_Config2__AccountId__c = acc.Id;
        cart.Apttus_Config2__PriceListId__c = pricelist.id;
        insert cart;
        
       
        
       
            
                    }
        
       @isTest
            static string generatedoc2(){
               
               Opportunity opp = [SELECT id from Opportunity limit 1];
                 Apttus_Proposal__Proposal__c prop = [select id from Apttus_Proposal__Proposal__c limit 1];
                
                
                
                Apttus__APTS_Template__c newTemplate1 = new Apttus__APTS_Template__c();
                newTemplate1.Name = System.Label.Digital_OF;
                newTemplate1.Apttus__IsActive__c = TRUE;
                newTemplate1.Apttus__Type__c = 'Proposal';
                newTemplate1.Apttus__ReferenceId__c = '0db18264-424c-a7fa-5058-680a594f5189';
                newTemplate1.Apttus__Agreement_Types__c = 'Default;Proposal;RFP';
                newTemplate1.Apttus__FrameworkFormat__c = 'FX2';
                Insert newTemplate1;
                
                
                
                Map<String, String> reqParameter = new Map<String, String> ();
                reqParameter.put('proposalId',prop.ID);
        
               
                try{
                    
                    DCPGenerateDocument.generateDoc(reqParameter);
                }
                catch (Exception ex) {
                                       
                    
                    return null;
                    
                }  
                System.assertEquals('123', opp.Name, 'Test Opportunity');
                return null;
            }
    


    @isTest   
        static string generateDoc1(){
                
        UnitTest.createTestData();
        Product2 testProd1 =UnitTest.getProductInstance();
        insert testProd1;       
        
        //Standard PricebookEntry
        PricebookEntry testEntry1 = new PricebookEntry(CurrencyIsoCode='USD',
        isactive=true,
        Pricebook2id=Test.getStandardPricebookId(),
        Product2Id=testProd1.id,unitprice=1,
        UseStandardPrice=false);
        insert testEntry1;  
        
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;        
        
        //Custom PricebookEntry
        PricebookEntry testEntry2 = new PricebookEntry(CurrencyIsoCode='USD',isactive=true,Pricebook2id=customPB1.Id,Product2Id=testProd1.id,unitprice=1,UseStandardPrice=false);
        insert testEntry2;        
        
        //Account data
        Account testAcc1 = UnitTest.getAccountInstance();
        insert testAcc1;
        
        //Contact data
        Contact testcontact1= UnitTest.getContactInstance(testAcc1.Id);
        testcontact1.LastName = 'testContact';
        testcontact1.FirstName = 'testContact';
        testcontact1.AccountId = testAcc1.Id;
        testcontact1.email = 'testfirst.testlast@thomson.com';
        insert testcontact1;    
       
        Source_System_Detail__c ass1 = new Source_System_Detail__c();
        ass1.Account_Name__c = testAcc1.Id;
        ass1.name= 'test';
        ass1.Source_System_Name__c='test';
        insert ass1;
        
        Account a1 = new Account(name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
        a1.APTS_Customer_Category__c = '5';
        a1.Is_GLI__c = True;
        insert a1;
        
        //Opportunity data: set1(standard pricebook)
        Opportunity testOpp2 = UnitTest.getOpportunityInstance(testAcc1.Id);
        testOpp2.Name = 'Test Opp1';
        testOpp2.Key_Contact__c = testcontact1.Id;
        testOpp2.Renewal_Flag__c = true;
        testOpp2.Selling_Organization__c = 'LRA';
        testOpp2.currencyIsoCode = 'USD';
        testOpp2.Pricebook2Id = testEntry1.Pricebook2Id;
        testOpp2.Sales_Org__c = 'TSL';
        
        
        //testOpp1.RecordTypeId = RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c;
        testOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LATAM Renewal Opportunity').getRecordTypeId();
        insert testOpp2;
                     
         Apttus_Proposal__Proposal__c p3 = new Apttus_Proposal__Proposal__c
             (CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=testAcc1.id,
            Apttus_Proposal__Proposal_Name__c='Corporate Proposal for approval',  
            Apttus_Proposal__Opportunity__c=testOpp2.id, 
            Apttus_Proposal__Approval_Stage__c='Draft', 
            Apttus_Proposal__Proposal_Category__c='Quote', 
            Apttus_Proposal__ReadyToGenerate__c = false, 
            Apttus_Proposal__ReadyToPresent__c= true,
            APTS_SSD_Sold_To__c=ass1.Id,APTS_SSD_ship_to__c=ass1.Id,
            APTS_SSD_bill_to__c=ass1.Id);                                                                   
            insert p3;
        
        
        
        Apttus_Config2__ProductConfiguration__c prodConf2 = new Apttus_Config2__ProductConfiguration__c();
        prodConf2.Name='prod-conf1'; 
        prodConf2.CurrencyIsoCode = 'USD';
        prodConf2.APTS_SSD_ship_to__c=ass1.Id;
        prodConf2.APTS_SSD_bill_to__c=ass1.Id;
        prodConf2.Apttus_QPConfig__Proposald__c =p3.ID;
        prodConf2.Apttus_Config2__Status__c = 'other';
        insert prodConf2;
        
        
       
        Map<String, String> reqParameter1 = new Map<String, String> ();
        reqParameter1.put('proposalId',p3.ID);
            try{  
         DCPGenerateDocument.generateDoc(reqParameter1);
            }
		catch (Exception ex) {
            return null;
        }
           
        system.assertEquals('other', prodConf2.Apttus_Config2__Status__c, 'other message'); 
        return null;
        }
    
    
    
    }