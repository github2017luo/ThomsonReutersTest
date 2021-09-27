/********************************************************************************************
    ClassName: RenewalRequestController_Test
    Description: Class test the code of class "RenewalRequestController".
    CreatedBy: Sushen Adhikary 
    CreatedDate: 04-Aug-2016
    LastModifiedBy: Anshu Thakur 
    LastModifiedDate: 11-Aug-2016
    Reason for Change:
    Revision:
    Fixed Defect#:
    *********************************************************************************************/
@isTest
private class RenewalRequestController_Test{
    
    static testMethod void testLogicRenewalRequest()
    {
        //Calling test data method from UnitTest class to use prepared custom setting values
        UnitTest.createTestData();
        
        //Preparing Account data
        Account objAcct = UnitTest.getAccountInstance();                
        INSERT objAcct;
        System.assert(objAcct.Id != null);
        
        //*** Starting Logic for Full Cancel
        //Preparing Opportunity data : Full Cancel
        Opportunity objOpp = UnitTest.getOpportunityInstance(objAcct.Id);
        objOpp.Name__c = 'Test Renewal Opp1';
        objOpp.StageName = '50%';
        objOpp.CloseDate = System.today().addDays(1);
        objOpp.Renewal_Flag__c = true;
        //objOpp.Sales_Org__c = 'ABEP';
        objOpp.Sales_Org__c = 'LLEY';
        objOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'LATAM_Renewal_Opportunity' LIMIT 1].Id;
       
        INSERT objOpp;   
        
        
        //Preparing Product data : Full Cancel
        Product2 objProd = UnitTest.getProductInstance();
        objProd.IsActive = true;
        INSERT objProd;
        
        //Preparing PricebookEntry data : Full Cancel
        PricebookEntry objPBE = new PricebookEntry(isactive=true, Pricebook2id=Test.getStandardPricebookId(), Product2Id=objProd.id, unitprice=200);
        INSERT objPBE; 
        
        //Preparing OpportunityLineItem data : Full Cancel
        OpportunityLineItem objOLI = new OpportunityLineItem(opportunityId=objOpp.id, PricebookEntryId=objPBE.id, unitprice=200, Quantity=1, Revenue_Type__c 

='Renewal');
        objOLI.OpportunityId = objOpp.Id; 
        INSERT objOLI;
        
        //Preparing data for Quote : Full Cancel
        Quote objQty = new Quote();
        objQty.OpportunityId = objOpp.id;
        objQty.Name = 'Test Renewal Qty1';
        objQty.Pricebook2Id = Test.getStandardPricebookId();
        objQty.Status = 'Draft';
        objQty.Approval_Status__c = '';
        objQty.Primary_Quote__c = true;
        objQty.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote' AND DeveloperName = 'LATAM_Renewal_Quote' LIMIT 1].Id;
        INSERT objQty;
        
        Renewal_request__c rr = new Renewal_request__c();
        rr.name = 'Test renewal';        
        INSERT rr;
                
        objQty.Renewal_request__c = rr.ID;
        UPDATE objQty;
              
        //Preparing QuoteLineItem data : Full Cancel
        QuoteLineItem objQLI = new QuoteLineItem();
        objQLI.QuoteId = objQty.Id;
        objQLI.PricebookEntryId = objPBE.Id;
        objQLI.Quantity = 1;
        objQLI.UnitPrice = 200;
        objQLI.Revenue_Type__c ='Renewal';       
        INSERT objQLI;        
        //*** Ending logic for Full Cancel
        
        //*** Starting Logic for Remove
        //Preparing Opportunity data : Remove Renewal
        Opportunity objOppRem = UnitTest.getOpportunityInstance(objAcct.Id);
        objOppRem.Name__c = 'Test Renewal Opp1';
        objOppRem.StageName = '50%';
        objOppRem.CloseDate = System.today().addDays(1);
        objOppRem.Renewal_Flag__c = true;
        //objOppRem.Sales_Org__c = 'ABEP';
        objOppRem.Sales_Org__c = 'LLEY';
        objOppRem.SAP_Quotation_Document_number__c = '50674414';
        objOppRem.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'LATAM_Renewal_Opportunity' LIMIT 1].Id;
       
        INSERT objOppRem;       
        
        //Preparing Product data : Remove Renewal
        Product2 objProdRem = UnitTest.getProductInstance();
        objProdRem.IsActive = true;
        INSERT objProdRem;
        
        //Preparing PricebookEntry data : Remove Renewal
        PricebookEntry objPBERem = new PricebookEntry(isactive=true, Pricebook2id=Test.getStandardPricebookId(), Product2Id=objProdRem.id, unitprice=200);
        INSERT objPBERem; 
        
        //Preparing OpportunityLineItem data : Remove Renewal
        OpportunityLineItem objOLIRem = new OpportunityLineItem(opportunityId=objOppRem.id, PricebookEntryId=objPBERem.id, unitprice=200, Quantity=1, Revenue_Type__c 

='Renewal');
        objOLIRem.OpportunityId = objOppRem.Id; 
        INSERT objOLIRem;
        
        //Preparing data for Quote : Remove Renewal
        Quote objQtyRem = new Quote();
        objQtyRem.OpportunityId = objOppRem.id;
        objQtyRem.Name = 'Test Renewal Qty1';
        objQtyRem.Pricebook2Id = Test.getStandardPricebookId();
        objQtyRem.Status = 'Draft';
        objQtyRem.Approval_Status__c = '';
        objQtyRem.Primary_Quote__c = true;                
        objQtyRem.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Quote' AND DeveloperName = 'LATAM_Renewal_Quote' LIMIT 1].Id;
        INSERT objQtyRem;
        
        //Preparing QuoteLineItem data : Remove Renewal
        QuoteLineItem objQLIRem = new QuoteLineItem();
        objQLIRem.QuoteId = objQtyRem.Id;
        objQLIRem.PricebookEntryId = objPBERem.Id;
        objQLIRem.Quantity = 1;
        objQLIRem.UnitPrice = 200;
        objQLIRem.Revenue_Type__c ='Renewal';       
        INSERT objQLIRem;        
        //*** Ending logic for Remove
        
        //Preparing User data : LaTam User
        User objLaTamUser = UnitTest.getUserInstance();
        objLaTamUser.Username = 'testLaTamUser@case.com';
        objLaTamUser.CommunityNickname = 'testTRUser';
        objLaTamUser.profileId = [SELECT Id FROM Profile WHERE Name = 'LatAm User' LIMIT 1].Id;
        objLaTamUser.ManagerID = [SELECT Id FROM User WHERE Profile.Name = 'LatAm User' LIMIT 1].Id;
        INSERT objLaTamUser;
        
        User objOtherUser = UnitTest.getUserInstance();
        objOtherUser.Username = 'testOtherUser@case.com';
        objOtherUser.CommunityNickname = 'testOtherUser';
        objOtherUser.profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
        INSERT objOtherUser;
        
        User runningUser = [SELECT ID FROM User WHERE Id =: UserInfo.getUserId()];  
        runningUser.ManagerID = [SELECT Id FROM User WHERE Profile.Name = 'LatAm User' LIMIT 1].Id;
        UPDATE runningUser;
        
        System.assert(objLaTamUser.Id != null);
        
        Test.StartTest();
        
        ApexPages.currentPage().getParameters().put('quoteId', objQty.Id);
        ApexPages.currentPage().getParameters().put('type', 'FullCancel'); 
        
       
        RenewalRequestController objRRC = null;
                
        {
          // System.runAs(objLaTamUser)
         // { 
                objRRC = new  RenewalRequestController(); 
                objRRC.objRR.Cancel_Reason__c = 'Budget';
                objRRC.objRR.Cancel_Comments__c = 'Test Comm for Cancel request.';                 
                objRRC.saveRenewalRequest();
          //  }
        }
        {
                    
           // System.runAs(objLaTamUser)
           // { 
                objRRC = new  RenewalRequestController(); 
                objRRC.objRR.Cancel_Reason__c = 'Budget';
                objRRC.objRR.Cancel_Comments__c = 'Test Comm for Cancel request.';
                objRRC.objRR.Was_There_a_Competitor__c = null;               
                objRRC.saveRenewalRequest();
                objRRC.getCompetitorName();
                objRRC.objRR.Was_There_a_Competitor__c = 'Unknown';
                objRRC.getCompetitorName(); 
                objRRC.objRR.Was_There_a_Competitor__c='Yes';
                objRRC.getCompetitorName(); 
                objRRC.objRR.Was_There_a_Competitor__c='test';
                objRRC.getCompetitorName(); 
                objRRC.objRR.Was_There_a_Competitor__c = 'No';
                objRRC.saveRenewalRequest();
           // }
        }
          
        {
            objQty.Pricing_Approval_Required__c = true;        
            UPDATE objQty;
            
            //System.runAs(objLaTamUser)
           // { 
                objRRC = new  RenewalRequestController(); 
                objRRC.objRR.Cancel_Reason__c = 'Budget';
                objRRC.objRR.Cancel_Comments__c = 'Test Comm for Cancel request.';
                objRRC.saveRenewalRequest();
           // }
        }       
        {
       objOpp.Sales_Org__c = 'ABEP';
       UPDATE objOpp;
        
         objRRC = new  RenewalRequestController(); 
         objRRC.objRR.Cancel_Reason__c = 'Budget';
         objRRC.objRR.Cancel_Comments__c = 'Test Comm for Cancel request.';
         objRRC.saveRenewalRequest();
        }
      
          objOpp.Renewal_Flag__c = false;
           UPDATE objOpp;
            
         objRRC = new  RenewalRequestController();    
         objRRC.objRR.Cancel_Reason__c = 'Budget';
         objRRC.objRR.Cancel_Comments__c = 'Test Comm for Cancel request.';   
         objRRC.saveRenewalRequest();    
            
         objRRC = new  RenewalRequestController();    
         objRRC.objRR.Cancel_Reason__c = 'Budget';
         objRRC.objRR.Cancel_Comments__c = 'Test Comm for Cancel request.';   
        System.runAs(objOtherUser)
        
         {            
                 objRRC.saveRenewalRequest();  
             }  
        
        {
            ApexPages.currentPage().getParameters().put('quoteId', objQtyRem.Id);
            ApexPages.currentPage().getParameters().put('type', 'Remove');  
           // System.runAs(objLaTamUser)
           // { 
                objRRC = new  RenewalRequestController(); 
                objRRC.objRR.Remove_Reason__c = 'Trial';
                objRRC.objRR.Remove_Comments__c = 'Test Comments for Remove Renewal.';
                objRRC.saveRenewalRequest();
           // }
        }
        Test.StopTest();
    }
}