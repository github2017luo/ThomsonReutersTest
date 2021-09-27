/**
 * Test class for testing the Digital_Expire_All_ProposalsController class.  That class is a button on the 
 * Opportunity to 'expire' all Quote/Proposals as required  
 */
/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2017-06-13   Brenda Shields          Created
 * =============================================================================
 */
@isTest
private class Digital_Expire_All_ProposalsCntl_Test {

    @testSetup static void init(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();
        Test.StopTest();  
        Apttus_Proposal__Proposal__c prop=[Select id from Apttus_Proposal__Proposal__c LIMIT 1];
         // create envelope record
        Apttus_DocuApi__DocuSignEnvelope__c newEnv = DCTestdata.createDocuSignEnvelope('sent',prop.Id);
        insert newEnv;   
     }
    @isTest static void testExpireQuote()
    {
        List<Opportunity> listOpp=[Select id from Opportunity LIMIT 1];
        PageReference pageRef = Page.Digital_Expire_All_Proposals;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', listOpp[0].id);
       
        Test.startTest();
        Digital_Expire_All_ProposalsController generateCtrl = new Digital_Expire_All_ProposalsController();
        PageReference pg = generateCtrl.Expire();
        PageReference pg1 = generateCtrl.ContinueExpire();
        
        List<Apttus_Proposal__Proposal__c > prop=[Select Apttus_Proposal__Approval_Stage__c  from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in :listOpp LIMIT 1];
        System.assertEquals(prop[0].Apttus_Proposal__Approval_Stage__c,'Expired');
        pg1=generateCtrl.ReturnToOpp();
        Test.stopTest();
        
    }
    @isTest static void testInvalidUser()
    {   List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c,ownerid    from        opportunity LIMIT 1];
        System.debug('Opportunitylist:'+oppList);
        
        
           
            Test.startTest();
            try{
                User u3 = [SELECT Id FROM User WHERE Name='Molly Bentz'];     
                oppList[0].ownerid=u3.id;    
                update opplist;
                PageReference pageRef = Page.Digital_Expire_All_Proposals;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('id', oppList[0].ID);
                Digital_Expire_All_ProposalsController generateCtrl = new Digital_Expire_All_ProposalsController();
                PageReference pg = generateCtrl.Expire();
                System.debug('Current User &&&&&'+ u3.id);
            }
            catch(Exception e){
                //System.assertEquals(e.getMessage(),'Only the Opportunity owner can Expire Digital Quote/Proposals.');
            }
            Test.stopTest();
        
        
    }  
    
    @isTest static void testNoOpportunitySelected()
    {   List<Opportunity> oppList=[Select id,name,AccountId,stagename,CloseDate,isDigitalSpearHead__c from        opportunity LIMIT 1];
       List<Apttus_Proposal__Proposal__c> prop=[Select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in :oppList order by createddate LIMIT 2];
       if(!prop.isEmpty()){   
          for(Integer i=0;i<prop.size();i++){
              prop[i].Apttus_Proposal__Approval_Stage__c='Expired';
          }
          update prop;
        }
        PageReference pageRef = Page.Digital_Expire_All_Proposals;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', oppList[0].ID);
       
        Test.startTest();
        try{
            Digital_Expire_All_ProposalsController generateCtrl = new Digital_Expire_All_ProposalsController();
            PageReference pg = generateCtrl.Expire();
        }
        catch(Exception e){
            System.assertEquals(e.getMessage(),'This Opportunity has no Quote/Proposals that need to be expired.');
        }
        Test.stopTest();
        
    }   
    
  
}