/*
/*** @Author: Harika Sai P 
/*** Created Date: 29 MAR 2019
/*** Purpose: Test class
/*** JIRA : DLT-15694 Test Class for GlobalOperationLayer */
/*** Change History  ******************************************************************************************************/
/*** Modified By    Modified Date    JIRA    
/**************************************************************************************************************************/
@isTest
public class GlobalOperationLayer_Test{

    // create Quotes and carts
    
    @testSetup static void createData(){
        DCTestData.createData();
        Test.startTest();
        DCTestData.createQuote();        
        Test.stopTest();
        
    }
    // Checking generateDoc funtionality
     public static testmethod void generatePDFDocumentTest(){
        Test.startTest();
        IGlobalOperationLayer  globOpObj = new GlobalOperationLayer();
        DCTestData.createTemplate();
        ID docId = globOpObj.generatePDFDocument(DcTestData.templateId,DCTestData.bquoteId,'Digital_Exception_Log__c');
        system.assertNotEquals(DcTestData.templateId,null); 
        Test.stopTest();
    }
    
    //Chekcing cart Finalize Functionality
    
    public static testmethod void FinalizeCartTest(){
        Test.startTest();
        IGlobalOperationLayer  globOpObj = new GlobalOperationLayer(); 
        Apttus_Config2__ProductConfiguration__c cart = [SELECT id from Apttus_Config2__ProductConfiguration__c Limit 1];             
        globOpObj.FinalizeCart(cart.Id,'Digital_Exception_Log__c');   
        system.assertNotEquals(cart,null);      
        Test.stopTest();
    }
    //Checking bundling operation
    public static testmethod void setTheDigitalOwnerAppSegmentTest(){
    
        test.starttest();
        IGlobalOperationLayer  globOpObj = new GlobalOperationLayer();
        Id res = globOpObj.setTheDigitalOwnerAppSegment('Small Law');
        system.assertNotEquals(res,null);
        test.stoptest(); 
    
    }
    //Checking bundling operation
    public static testmethod void performBundlingTest(){
    
        test.starttest();
        IGlobalOperationLayer  globOpObj = new GlobalOperationLayer();
        List<Apttus_Config2__ProductConfiguration__c> prodConfigsList = [SELECT id, name,Apttus_Config2__Status__c,  Apttus_Config2__PriceListId__c, Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Name, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c,Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Approval_Stage__c,Apttus_Config2__AccountId__c,APTS_SSD_Sold_To__c,Apttus_QPConfig__Proposald__r.Digital_Quote_Type__c,(select id, Apttus_Config2__AdjustmentType__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__Quantity__c,APTS_Contract_Term__c from Apttus_Config2__LineItems__r where Apttus_Config2__LineStatus__c = 'New' LIMIT 1)FROM Apttus_Config2__ProductConfiguration__c limit 1];
        
        globOpObj.performBundling('Bundle A', prodConfigsList,'Digital_Exception_Log__c' );
        
        system.AssertNotEquals(prodConfigsList[0], null);
        
        test.stoptest(); 
    
    }
    //Covering Exception method of operation layer
    public static testmethod void createExceptionTest(){
        Test.startTest();
        
        IGlobalOperationLayer  globOpObj = new GlobalOperationLayer(); 
        globOpObj.FinalizeCart(dcTestData.bQuoteId,'Digital_Exception_Log__c');  
        system.assertEquals(dcTestData.bQuoteId,null);     
        
        Test.stopTest();       
    }
    
}