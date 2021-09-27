@isTest
private class APTS_ProposalProdAttributeTriggerTest {
    
    @isTest static void test_updateCPROValuesOnProposal() {
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
         insert priceList;

         
         
        
         //inserting KeyValuestore
        

List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
           
          //Inserting RecordList   
         List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
         RecordtypeIds__c recordtype=new RecordtypeIds__c();
         recordtype.Name='Pre-Pipeline Opportunities';
         recordtype.recTypeId__c='01230000001MA4c';
         recordlist.add(recordtype);
        
         RecordtypeIds__c recordtype1=new RecordtypeIds__c();
         recordtype1.Name='Pipeline Opportunities';
         recordtype1.recTypeId__c='01230000001MA4c';
         recordlist.add(recordtype1);
         insert recordlist;
        
         //Inserting Account Object
         Account a = APTS_TestDataFactory.createAccount('Test Account');
         insert a;
        
        //Dynamic Retrieval of a recordType for SSd Object and Inserting SSd
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Account_Inactive__c=false;
        insert accountSSD;
        
        //Dynamic Retrieval of a recordType for opportunity Object and Inserting Opportunity 
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        //Inserting Proposal Object
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;

        List<Apttus_Config2__LineItem__c> ListOfLineItems = New List<Apttus_Config2__LineItem__c>();
        List<Apttus_Config2__ProductAttributeValue__c> ListofPAVs = new List<Apttus_Config2__ProductAttributeValue__c>(); 
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=1); 
        ListOfLineItems.add(linObj);
  
        linObj = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__LineNumber__c = 1, 
            Apttus_Config2__ItemSequence__c = 2,
          Apttus_Config2__NetPrice__c=1 ); 
        ListOfLineItems.add(linObj);
        
        insert ListOfLineItems;
        
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c 
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Apttus_Config2__ConfigurationId__c = :prodConfig.id];      
                                     
        System.assert(lineItemsList!= null && lineItemsList.size()>0);      

        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'New';
        update prodConfig;

        //APTS_ProductConfigurationTriggerHandler.afterUpdate = false;
        prodConfig.Apttus_Config2__Status__c = 'Finalized';
        update prodConfig;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIs = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Proposal__c=proposal.id);
        
        
        Apttus_Proposal__Proposal_Line_Item__c pl2 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary Essential',
          Apttus_Proposal__Proposal__c=proposal.id);
        
        
        lstPLIs.add(pl1);
        lstPLIs.add(pl2);  
        
        insert lstPLIs;
                     
        /* Prasad : 19-Dec-2016 - Proposal Product Attribute Record Creation - Starts */ 
        List<APTS_CPRO_Material_Numbers__c> lstCPRO = new List<APTS_CPRO_Material_Numbers__c>();
        
        APTS_CPRO_Material_Numbers__c cproCustomSetting = new APTS_CPRO_Material_Numbers__c();
        cproCustomSetting.APTS_High_Points__c = 12;
        cproCustomSetting.APTS_Low_Points__c = 9;
        cproCustomSetting.APTS_Sub__c = '40988591';
        cproCustomSetting.APTS_Svc__c = '40988711';
        cproCustomSetting.Name = 'Westlaw GC (9-12 Points)';
        cproCustomSetting.Core__c = 'Primary';      
        
        APTS_CPRO_Material_Numbers__c cproCustomSetting2 = new APTS_CPRO_Material_Numbers__c();
        cproCustomSetting2.APTS_High_Points__c = 1;
        cproCustomSetting2.APTS_Low_Points__c = 1 ;
        cproCustomSetting2.APTS_Sub__c = '40988591';
        cproCustomSetting2.APTS_Svc__c = '40988711';
        cproCustomSetting2.Name = 'Westlaw GC Essentials (1 Point)';
        cproCustomSetting2.Core__c = 'Essentials';                  
                
        lstCPRO.add(cproCustomSetting);
        lstCPRO.add(cproCustomSetting2);
        
        insert lstCPRO;
        
        
        List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        
        Apttus_QPConfig__ProposalProductAttributeValue__c propattr = new Apttus_QPConfig__ProposalProductAttributeValue__c();
        propattr.Apttus_QPConfig__LineItemId__c = pl1.Id;
        propattr.APTS_Total_Number_of_Points__c  = 10; 

        Apttus_QPConfig__ProposalProductAttributeValue__c propattr2 = new Apttus_QPConfig__ProposalProductAttributeValue__c();
        propattr2.Apttus_QPConfig__LineItemId__c = pl2.Id;
        propattr2.APTS_Total_Number_of_Points__c  = 1; 

        
        lstPropAttr.add(propattr);
        lstPropAttr.add(propattr2);
        
        insert lstPropAttr; 
        
        /* Prasad : 19-Dec-2016 - Proposal Product Attribute Record Creation - Ends */ 
        test.startTest();
        LIST<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList = [SELECT id, name FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_QPConfig__ConfigurationId__c = :prodConfig.id];
        System.assert(proposalLineItemList!= null);
        System.assert(proposalLineItemList.size()>0); 

        pl1.APTS_Media_High_Level__c = 'Online';
        pl1.Apttus_QPConfig__LineStatus__c = 'New';
        pl1.APTS_Online_Contacts_Validation__c = true;
        pl1.APTS_Master_Contacts_Validation__c = true;
        update pl1;
        
        LIST< Apttus_Proposal__Proposal__c> prop1 = [SELECT APTS_Contact_Validation_Flag__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposal.id];
        If (prop1.size() > 0) {
            System.assert(prop1[0].APTS_Contact_Validation_Flag__c=true);
        }
        
        pl1.APTS_Media_High_Level__c = '06';
        pl1.APTS_Media_Lower_Level_Code__c = 'I9';
        pl1.APTS_Online_Contacts_Validation__c = true;
        update pl1;
        
        LIST< Apttus_Proposal__Proposal__c> prop2 = [SELECT APTS_Contact_Validation_Flag__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposal.id];
        If (prop2.size() > 0) {
            System.assert(prop2[0].APTS_Contact_Validation_Flag__c=true);
        }  
        
        pl1.APTS_Media_High_Level__c = '';
        pl1.APTS_Media_Lower_Level_Code__c = '2P';
        pl1.APTS_Online_Contacts_Validation__c = true;
        update pl1;
        
        
        LIST< Apttus_Proposal__Proposal__c> prop3 = [SELECT APTS_Contact_Validation_Flag__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposal.id];
        If (prop3.size() > 0) {
            System.assert(prop2[0].APTS_Contact_Validation_Flag__c=true);
        } 
        test.stopTest();             
    }
}