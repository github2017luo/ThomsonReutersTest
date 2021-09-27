@istest
Public class IncentivePasswordDocument_Test{
    
    
    public static testMethod void testController(){
        
      
            Account testAcc1 = UnitTest.getAccountInstance();
            insert testAcc1;
            incentive_promotion__c testIPC = new incentive_promotion__c(account__C=testAcc1.id);
            insert testIPC;
            Incentive_Password__c testIPD = new Incentive_Password__c(Promotion__c=testIPC.id,end_date__c=system.today());
            insert testIPD;
           Test.setCurrentPageReference(Page.IncentivePasswordDocument);
            ApexPages.currentPage().getParameters().put('Type','Promo');
            ApexPages.currentPage().getParameters().put('Pid',testIPC.id);        
            IncentivePasswordDocument controller =new IncentivePasswordDocument();
            ApexPages.currentPage().getParameters().put('Type','Individual');
            ApexPages.currentPage().getParameters().put('Pid',testIPD.id);
            IncentivePasswordDocument controller2 =new IncentivePasswordDocument();
            
        }
        
    
}