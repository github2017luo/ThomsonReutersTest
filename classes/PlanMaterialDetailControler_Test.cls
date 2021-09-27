/**
 * ====================================================================================================================
 * TEST CLASS NAME: PlanMaterialDetailControler_Test
 * ======================================================================================================================
 * PURPOSE:   Validates the functionality provided by the PlanMaterialDetailControler class.

 * CHANGE HISTORY
 * ===================================================================================================================
 * Date         Name                    Description
 * 2017-03-31  Meenakshmi Goswami                   Created as per JIRA STORY: PS0-1
 * ===================================================================================================================
 */
@istest 
public with sharing class PlanMaterialDetailControler_Test { 
   public static testMethod void testPlanMaterialDetail(){
      Account oAccount = UnitTest.getAccountInstance();
     
    insert oAccount;
        
        pageReference pgPlanMaterialDetailpage = page.PlanMaterialDetailpage;
        Test.setCurrentPage(pgPlanMaterialDetailpage);
        ApexPages.currentPage().getParameters().put('Id', oAccount.Id);
        ApexPages.currentPage().getParameters().put('SAP','1003574733');
        ApexPages.currentPage().getParameters().put('matkey', '1234');
        ApexPages.currentPage().getParameters().put('matPrice','1003574733');
        ApexPages.currentPage().getParameters().put('Month','5');
        ApexPages.StandardController oStandardController  = new ApexPages.StandardController(oAccount);
        //Apputil.getWebServiceSettings('ContentOptimizerService');
      /*  
        WebServiceSettings__c oKeyValue7 = new WebServiceSettings__c();
        oKeyValue7.name = 'ContentOptimizerService';       
        oKeyValue7.Active__c = true;
        oKeyValue7.Endpoint__c = 'https://tacss.thomsonreuters.com/rocketdeploy/services/Order_v5_0Port';
        oKeyValue7.Password__c = 'sfdconepass123';
        oKeyValue7.Service_Unavailable_Message__c = 'Orders setting for the Web service';
        oKeyValue7.Timeout__c = 120;
        oKeyValue7.Username__c = 'Salesforce';
        INSERT oKeyValue7;
      
           ContentOptimizerServiceWS.Customer outputCustomer = new ContentOptimizerServiceWS.Customer();
        outputCustomer.AddrStateCode = 'NY';
    outputCustomer.ZwAcctSapId = 1000000139;
    
    UnitTest.MockWebServiceResponse.put('ContentOptimizerService',outputCustomer);
    ContentOptimizerServiceWS.MaterialContent outputMaterialContent = new ContentOptimizerServiceWS.MaterialContent();
    outputMaterialContent.AcctSapId = 1000000139;
    outputMaterialContent.PrimaryMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
    for (integer i=0; i<20; i++) {    
      ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
        oMatch.materialnumber = i;    
       oMatch.MaterialDesc = 'SAP-' + i;    
       oMatch.listprice = i + 100;          
        outputMaterialcontent.PrimaryMaterials.add(oMatch);
    }
      
    outputMaterialContent.PublicMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
    for (integer i=0; i<20; i++) {    
      ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
        oMatch.materialnumber = i;    
       oMatch.MaterialDesc = 'SAP-' + i;    
       oMatch.listprice = i + 100;          
        outputMaterialcontent.PublicMaterials.add(oMatch);
    }
  
    outputMaterialContent.OtherMaterials = new List<ContentOptimizerServiceWS.MaterialItem>();
    for (integer i=0; i<20; i++) {    
      ContentOptimizerServiceWS.MaterialItem oMatch = new ContentOptimizerServiceWS.MaterialItem();  
        oMatch.materialnumber = i;    
       oMatch.MaterialDesc = 'SAP-' + i;    
       oMatch.listprice = i + 100;          
        outputMaterialcontent.OtherMaterials.add(oMatch);
    } */  
       //execute test
        test.startTest();
         PlanMaterialDetailControler controller = New PlanMaterialDetailControler (oStandardController);
        controller.PlanType='1234';
         controller.SearchPlanMatchDBSs(); 
         PlanMaterialDetailControler.MatchItems mi=new PlanMaterialDetailControler.MatchItems();
         
         PlanMaterialDetailControler.PlanMatchDetail pmd=new PlanMaterialDetailControler.PlanMatchDetail();
         pmd.materialnumber=123;
        pmd.materialdescription='test';
        pmd.listprice=1.0;
        
        PlanMaterialDetailControler.PlanMatchDBS pmds=new PlanMaterialDetailControler.PlanMatchDBS();
        pmds.dbs='test1';
        pmds.dbsdescription='test2';
        pmds.inplan=false;
        pmds.inplantrans=1234;
        pmds.ancillarytrans=5678;
        pmds.wsdtrans=9874;
        
        PlanMaterialDetailControler.ExcessDBS edb=new PlanMaterialDetailControler.ExcessDBS();
        edb.dbs='test1';
        edb.dbsdescription='test2';
        edb.inplan=false;
        edb.inplantrans=1234;
        edb.ancillarytrans =69854;
        edb.wsdtrans=98745;
       
        
        PlanMaterialDetailControler.MaterialID mid=new PlanMaterialDetailControler.MaterialID();
        mid.MaterialKey=1236589;
              
        test.stopTest();
        
   }
}