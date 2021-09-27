@isTest(SeeAllData=true)
private class OptyTeamMember_Test {
    
    @isTest static void test_method_one(){
        
        Account account = new Account();
        account.Name = 'Test Account';
        //account.Sales_Org__c = 'ABEP';
        account.Sales_Org__c = 'LLEY';
        account.Customer_Type__c = 'Individual';
        account.Customer_Group__c = 'ACADEMIC';
        account.Customer_Class_c__c = 'Academic';
        account.Tax_Number_Type__c = 'C.I.';
        account.Tax_Number__c = '3212343';
        account.Industry_Code_1__c = 'ACADEMIC DEPT';
        account.Industry = 'AC ACCOUNTING';
        account.BillingCountry = 'IN';
        account.BillingState = 'KA';
        account.BillingCity = 'Bangalore';
        insert account;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName = '95%';
        opp.CloseDate = system.today() + 10;
        opp.AccountId = account.id;
        opp.Win_Loss__c = 'Won – Downgrade';
	  opp.Reason__c = 'Brand';
        insert opp;
        
        Opportunity_Product_Type__c oppProduct = new     Opportunity_Product_Type__c();
        oppProduct.Opportunity__c = opp.Id;
        insert oppProduct;

        OpportunityTeamMember oppTeam = new OpportunityTeamMember();
        oppTeam.OpportunityId = opp.Id;
        oppTeam.UserId = Userinfo.getUserId();
        oppTeam.TeamMemberRole = 'LatAm User';
        oppTeam.Hoopla_Secondry__c = true;
        insert oppTeam;
        
        OpportunityTeamMember oppTeam1 = new OpportunityTeamMember();
        oppTeam1.OpportunityId = opp.Id;
        oppTeam1.UserId = Userinfo.getUserId();
        oppTeam1.TeamMemberRole = 'LatAm User';
        oppTeam1.Hoopla_Secondry__c = true;
        
        Test.startTest();
        try{
            insert oppTeam1;
        }catch(Exception e){
            
        }
        Test.stopTest();
        
    }
}