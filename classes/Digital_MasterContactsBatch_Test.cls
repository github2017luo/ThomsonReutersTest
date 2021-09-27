@isTest
private class Digital_MasterContactsBatch_Test {

    @testSetup 
    static void mcSettUptest() {
        
        DCTestData.createData();
        Test.startTest();   
        DCTestData.createQuote();      
        Test.stopTest();
        
        Contact oContact = [Select id, Email, SAP_Role__c, SAP_Contact_ID__c,AccountId from Contact where id =: DCTestData.contactId];
        Source_System_Detail__c oSSD = [Select id from Source_System_Detail__c where id =: DCTestData.accssdid];
        LCRM_Contact_SSD__c oSSDContact = DCTestData.createContactSSD(oContact, oSSD);

        list<contact> clist = [select id,SAP_Role__c  from contact where SAP_Role__c = 'EML ORDER CONFIRM'];
        for(Contact c : clist){
            c.SAP_Role__c = 'TECHNICAL CONTACT;CLEAR PRIMARY CONT;EML PSWD CONTACT;PATRON ACC TECH CONT;ADMINISTRATOR';
        }
        update clist;


        opportunity opp= [select id,name,Source_System_Detail__c from opportunity where accountId =: DCTestData.accountId limit 1];

        DCTestData.createProduct('SL California Analytical (Westlaw PRO™)', '42009567', '42009617');
        DCTestData.createProduct('SL Minnesota Analytical (Westlaw PRO&trade)', '41409998', '42009561');
        list<product2> prod = [select id,APTS_Media_Lower_Level_Code__c,APTS_Media_High_Level_Code__c,Apttus_Filter_Brand_Code__c from product2 where Productcode IN ('41409998','42009567')];
        prod[1].Apttus_Filter_Brand_Code__c = '076';
        prod[1].name = prod[1].name+ ' Patron Access';
        update prod;
        

        list<Apttus_Proposal__Proposal_Line_Item__c> linelist = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        for(product2 p : prod){
            Apttus_Proposal__Proposal_Line_Item__c line = new Apttus_Proposal__Proposal_Line_Item__c();
            line.Apttus_Proposal__Proposal__c = DCTestData.bQuoteId;   
            line.Apttus_QPConfig__LineStatus__c = 'New';
            line.Apttus_Proposal__Product__c = p.id; 
            linelist.add(line);       
        } 
        insert linelist;
        
        system.AssertEquals(oSSD.id, opp.Source_System_Detail__c);
        
    }
    
    public static testmethod void mcContacttest(){
            

        test.starttest();
        
        Digital_MasterContactsBatch dmc = new Digital_MasterContactsBatch();
        Database.executeBatch(dmc,1);
        
        // covers after MasterContacts created on helper class  
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.id = DCTestData.bQuoteId;
        
        LCRM_Contact_SSD__c mcSSDContact = [Select id,LCRM_Contact__c,LCRM_Contact__r.FirstName,LCRM_Contact__r.LastName,LCRM_Contact__r.Email,LCRM_Contact__r.Phone from  LCRM_Contact_SSD__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_MasterContactsController contr= new Digital_MasterContactsController(sc);
        contr.mcAssignHelper(mcSSDContact);
        
        system.AssertEquals(contr.proposalId, String.valueOf(oProposal.id));

        test.stoptest();
    }
    
    public static testmethod void mcContactExtest(){
    
        test.starttest();
        

        Digital_MasterContactsBatch dmc = new Digital_MasterContactsBatch();
        dmc.createExceptionLog('Makeexception','testclass','coverage');
        Database.executeBatch(dmc,1);
        
        Apttus_Proposal__Proposal__c oProposal = new Apttus_Proposal__Proposal__c();
        oProposal.id = DCTestData.bQuoteId;
        
        LCRM_Contact_SSD__c mcSSDContact = [Select id,LCRM_Contact__c,LCRM_Contact__r.FirstName,LCRM_Contact__r.LastName,LCRM_Contact__r.Email,LCRM_Contact__r.Phone from  LCRM_Contact_SSD__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_MasterContactsController contr= new Digital_MasterContactsController(sc);
        contr.mcAssignHelper(mcSSDContact);
        
        system.AssertEquals(contr.proposalId, String.valueOf(oProposal.id));
        
        test.stoptest();
    
    }
    

}