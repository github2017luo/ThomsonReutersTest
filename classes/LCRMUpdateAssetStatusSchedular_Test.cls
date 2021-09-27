@isTest
public class LCRMUpdateAssetStatusSchedular_Test{

    @testSetup static void testDataSetUp() {
        recordtype accountRT = [select id from recordtype where name ='GLI Account' and sobjecttype='Account' limit 1];
        
        LCRM_BatchSize__c bs = new LCRM_BatchSize__c(LCRM_UpdateAssetStatus__c='200');
        insert bs;
        
        Account gliAccount = UnitTest.getAccountInstance();
        gliAccount.Name = 'Parent Test Account';
        gliAccount.Is_GLI__c = true;
        gliAccount.RecordTypeId=accountRT.Id;
        insert gliAccount;
        
        Asset gliAsset = new Asset();
        gliAsset.AccountId = gliAccount.Id;
        gliAsset.Name = 'Test Asset';
        gliAsset.LCRM_Is_GLI__c = TRUE;
        gliAsset.Status = 'Active';
        gliAsset.TR_Retention__Contract_End_Date__c = System.today().addDays(-2);
        insert gliAsset;
    }
    
    @isTest public static void testStatusChange(){
        Test.startTest();
        
        LCRMUpdateAssetStatus obj = new LCRMUpdateAssetStatus();
        obj.createExceptionLog('Test error','#1214125');
        
            LCRMUpdateAssetStatusSchedular sh = new LCRMUpdateAssetStatusSchedular();
            String cron = '0 0 0 * * ?'; 
            system.schedule('Test LCRMUpdateAssetStatusSchedular', cron, sh); 
        Test.stopTest();
    } 
}