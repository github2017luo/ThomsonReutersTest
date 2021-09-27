@isTest
public without sharing class APTS_FL_Validation_CallbackHelper_Test {
    
    public static List<Apttus_Config2__LineItem__c> OLItemList;
    private static final string USL_RECORDTPYE='USL_Source_Systems';
    
    @isTest static void New1(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('30790769');newMap.add(p1);
         Product2 p2 = NewProduct('41817449');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
     
      Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
     
     
     
     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
         insert OLItemList;
         
         List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj1.Id]; 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodThree(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        
       
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        insert procodes;
        
       FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30010890';
         firmList.Product_Family__c='PPC';
         insert firmList;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='30790769'; insert prodObj;

         Product2 prod2Obj = new Product2();
         prod2Obj.Name = 'Network Services 2.0';
         prod2Obj.APTS_Media_High_Level_Code__c = '07';
         prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
         lNewProducts.Add(prod2Obj); 
         insert prod2Obj;
         
         Product2 prod3Obj = new Product2();
         prod3Obj.Name = 'Network Services 2.0';
         prod3Obj.APTS_Media_High_Level_Code__c = '07';
         prod3Obj.APTS_Media_Lower_Level_Code__c = 'BB';
         prod3Obj.productcode = '41093075';
         insert  prod3Obj;        
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41767150');newMap.add(p1);
         Product2 p2 = NewProduct('41076128');newMap.add(P2);
         Product2 p3 = NewProduct('41053157');newMap.add(p3);
         Product2 p4 = NewProduct('42532854');newMap.add(p4);
         Product2 p5 = NewProduct('42532855');newMap.add(p5);
         Product2 p6 = NewProduct('42532852');newMap.add(p6);
         Product2 p7 = NewProduct('42532853');newMap.add(p7);
         Product2 p8 = NewProduct('41986777');newMap.add(p8);
         Product2 p9 = NewProduct('42118619');newMap.add(p9);
         Product2 p10 =NewProduct('41053156');newMap.add(p10);
         Product2 p11 = NewProduct('42027607');newMap.add(p11);
         Product2 p12 = NewProduct('42027608');newMap.add(p12);
         Product2 p13 = NewProduct('41680342');newMap.add(p13);
         Product2 p14 = NewProduct('40987608');newMap.add(p14);
         Product2 p15 = NewProduct('37005004');newMap.add(p15);
         Product2 p16 = NewProduct('37005072');newMap.add(p16);
         Product2 p17 = NewProduct('40987607');newMap.add(p17);
         Product2 p18 = NewProduct('37005005');newMap.add(p18);
         Product2 p19 = NewProduct('42088301');newMap.add(p19);
         Product2 p20 = NewProduct('42027609');newMap.add(p20);
         Product2 p21 = NewProduct('42027610');newMap.add(p21);
         Product2 p22 = NewProduct('41937760');newMap.add(p22);
         Product2 p23 = NewProduct('41618485');newMap.add(p23);
         Product2 p24 = NewProduct('41976905');newMap.add(p24);
         Product2 p25 = NewProduct('40483699');newMap.add(p25);
         Product2 p26 = NewProduct('40542344');newMap.add(p26);
         Product2 p27 = NewProduct('40542345');newMap.add(p27);
         Product2 p28 = NewProduct('40656696');newMap.add(p28);
         Product2 p29 = NewProduct('40485592');newMap.add(p29);
         Product2 p30 = NewProduct('40586465');newMap.add(p30);
         Product2 p31 = NewProduct('41093075');newMap.add(p31);
         Product2 p32 = NewProduct('41378928');newMap.add(p32);
         Product2 p33 = NewProduct('41817449');newMap.add(p33);
         Product2 p34 = NewProduct('30790769');newMap.add(p34);
         Product2 p35 = NewProduct('41819162');newMap.add(p35);
         Product2 p36 = NewProduct('41323281');newMap.add(p36);
         Product2 p37 = NewProduct('41325003');newMap.add(p37);
         Product2 p38 = NewProduct('41701486');newMap.add(p38);
         Product2 p39 = NewProduct('41323282');newMap.add(p39);
         Product2 p40 = NewProduct('40666911');newMap.add(p40);
         Product2 p41 = NewProduct('41895338');newMap.add(p41);
         Product2 p42 = NewProduct('41343504');newMap.add(p42);
         Product2 p43 = NewProduct('30010890');newMap.add(p43);
         
        Insert newMap;
         Map<String,Product2> newMapping = New Map<String,Product2>();
         for(Product2 p:newMap){
             newMapping.put(p.Productcode,p);
         }
        Map<String,String> mPPC = New Map<String,String>();
         for(Product2 p:newMap){
             mPPC.put(p.Productcode,p.Productcode);
         }
         Map<String,String> mfirmSite = New Map<String,String>();
         for(Product2 p:newMap){
             mfirmSite.put(p.Productcode,p.Productcode);
         }
        Map<ID,Apttus_Config2__ProductAttributeValue__c> mProductAtribute = New Map<ID,Apttus_Config2__ProductAttributeValue__c>(); 


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
         System.debug('Proposallineitemlist...'+lstPLIs);
         
         //sakshi
         Apttus_Config2__AssetLineItem__c assetcreation=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_QPConfig__ProposalId__c =proposal.id,APTS_Renewal_Eligible__c = 'No', APTS_Info_PlanType__c = 'ABCD');
       insert assetcreation;
         List<Apttus_Config2__AssetAttributeValue__c> attributesList=new List<Apttus_Config2__AssetAttributeValue__c>();
         Apttus_Config2__AssetAttributeValue__c attribute1=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='English', APTS_PPC_Website_Selection__c='FirmSite or FindLaw Landing Page Hosting',Apttus_Config2__AssetLineItemId__c=assetcreation.id);
         Apttus_Config2__AssetAttributeValue__c attribute2=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='Español', APTS_PPC_Website_Selection__c='FirmSite or FindLaw Landing Page Hosting',Apttus_Config2__AssetLineItemId__c=assetcreation.id);
         Apttus_Config2__AssetAttributeValue__c attribute3=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='English', APTS_PPC_Website_Selection__c='Third Party Site (No Landing Pages)',Apttus_Config2__AssetLineItemId__c=assetcreation.id);
         Apttus_Config2__AssetAttributeValue__c attribute4=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='Español', APTS_PPC_Website_Selection__c='Third Party Site (No Landing Pages)',Apttus_Config2__AssetLineItemId__c=assetcreation.id);
         attributesList.add(attribute1);
         attributesList.add(attribute2);
         attributesList.add(attribute3);
         attributesList.add(attribute4);
         insert attributesList;
         
         
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        insert asset;
         Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod3Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
        insert asset1;
         List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>();
         APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
         caval.Name='test'; insert caval;
         
         APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
         com.Name  ='test';
         com.APTS_Attribute_Value0__c =caval.id;
         com.APTS_Attribute_Value1__c=caval.id;
         com.APTS_Attribute_Value2__c=caval.id;
         com.APTS_Attribute_Value3__c=caval.id;
         insert com;
         Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41767150').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a1);
         
         Apttus_Config2__AssetLineItem__c a2 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41076128').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a2);
         Apttus_Config2__AssetLineItem__c a3 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41053157').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a3);
         Apttus_Config2__AssetLineItem__c a4 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532854').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a4);
         Apttus_Config2__AssetLineItem__c a5 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532855').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a5);
         Apttus_Config2__AssetLineItem__c a6 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532852').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a6);
         Apttus_Config2__AssetLineItem__c a7 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532853').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a7);
         Apttus_Config2__AssetLineItem__c a8 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41986777').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a8);
         Apttus_Config2__AssetLineItem__c a9 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42118619').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a9);
         Apttus_Config2__AssetLineItem__c a10 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41053156').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a10);
         Apttus_Config2__AssetLineItem__c a11 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027607').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a11);
         Apttus_Config2__AssetLineItem__c a112 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027607').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a112);
         Apttus_Config2__AssetLineItem__c a12 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027608').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a12);
         Apttus_Config2__AssetLineItem__c a13 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41680342').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a13);
         Apttus_Config2__AssetLineItem__c a14 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40987608').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a14);
         Apttus_Config2__AssetLineItem__c a15 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('37005004').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a15);
         Apttus_Config2__AssetLineItem__c a16 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('37005072').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a16);
         Apttus_Config2__AssetLineItem__c a17 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40987607').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a17);
         Apttus_Config2__AssetLineItem__c a18 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('37005005').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a18);
         Apttus_Config2__AssetLineItem__c a19 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42088301').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a19);
         Apttus_Config2__AssetLineItem__c a20 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027609').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a20);
         Apttus_Config2__AssetLineItem__c a21 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027610').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a21);
         
         Apttus_Config2__AssetLineItem__c a22 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41937760').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a22);
         
         Apttus_Config2__AssetLineItem__c a23 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41618485').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a23);
         Apttus_Config2__AssetLineItem__c a24 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41976905').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a24);
         Apttus_Config2__AssetLineItem__c a25 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40483699').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a25);
         Apttus_Config2__AssetLineItem__c a26 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40542344').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a26);
         Apttus_Config2__AssetLineItem__c a27 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40542345').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a27);
         Apttus_Config2__AssetLineItem__c a28 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40656696').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a28);
         Apttus_Config2__AssetLineItem__c a29 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40485592').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a29);
         
         Apttus_Config2__AssetLineItem__c a30 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40666911').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a30);
         Apttus_Config2__AssetLineItem__c a31 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41895338').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         Apttus_Config2__AssetLineItem__c a32 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41343504').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10); 
        
        //sakshi
        Apttus_Config2__AssetLineItem__c a33 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30010890').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='30010890',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__AttributeValueId__c=attribute1.id);                                                                              
         Apttus_Config2__AssetLineItem__c a34 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30010890').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='30010890',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__AttributeValueId__c=attribute2.id);
        Apttus_Config2__AssetLineItem__c a35 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30010890').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='30010890',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__AttributeValueId__c=attribute3.id);
        Apttus_Config2__AssetLineItem__c a36 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30010890').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='30010890',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__AttributeValueId__c=attribute4.id);
         
         lNewAsetline.Add(a31);
         lNewAsetline.Add(a32);
         lNewAsetline.Add(a33);
         lNewAsetline.Add(a34);
         lNewAsetline.Add(a35);
         lNewAsetline.Add(a36);
         insert lNewAsetLine;
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); //prod19bj
         
         Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = newMap[0].Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = newMap[1].Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
           
          

            Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 8, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
         
         
            
         
         Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[3].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 9, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[4].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 10, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
         
         Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[5].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 10, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 

            Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[6].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 11, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);    
      
         Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[7].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 11, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);   


            Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[8].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
           
           Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[9].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[10].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 13, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
         
         Apttus_Config2__LineItem__c linObj14 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[11].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 13, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
        Apttus_Config2__LineItem__c linObj14b = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=10,
            Apttus_Config2__ProductId__c=newMap[11].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 13, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
            Apttus_Config2__LineItem__c linObj15 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[12].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c linObj16 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[13].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c linObj17 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[14].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj18 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[15].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);            
           
            
            Apttus_Config2__LineItem__c linObj19 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[16].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj19b = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=10,
            Apttus_Config2__ProductId__c=newMap[16].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj20 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[17].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj21 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[18].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj22 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[19].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj23 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[20].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj24 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[21].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj25 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[22].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj26 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[23].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj27 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[24].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj28 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[25].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj29 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[26].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj30 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[27].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj31 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[28].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj32 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[29].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj33 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[30].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj34 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[31].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj35 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[32].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj36 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[33].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            
            Apttus_Config2__LineItem__c linObj37 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[34].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj38 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[35].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj39 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[36].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj40 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[37].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj41 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[38].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj42 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[39].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
                   
            Apttus_Config2__LineItem__c linObj43 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[40].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            Apttus_Config2__LineItem__c linObj44 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[11].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
             APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj2,linObj44,linObj3,linObj4,linObj5,linObj6,linObj7,linObj8,linObj9,linObj10,linObj11,linObj12,linObj13,linObj14,linObj15,linObj16,linObj,linObj17,linObj18,linObj19,linObj20,linObj21,linObj22,linObj23,linObj24,linObj25,linObj26,linObj27,linObj28,linObj29,linObj30,linObj31,linObj32,linObj33,linObj34,linObj35,linObj36,linObj37,linObj38,linObj39,linObj40,linObj41,linObj42,linObj43,linObj14b,linObj19b};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }       
    
    @isTest static void testMethod3825(){
    Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;

        insertStaticValues();
        
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;
        
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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


        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get(USL_RECORDTPYE).getRecordTypeId();
        Source_System_Detail__c accountSSD=APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
        proposal.APTS_Proposal_Business_Unit__c = 'SCS'; 
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          //prodObj.APTS_Media_High_Level_Code__c = '06';
          //prodObj.Family = 'PRINT';
          insert prodObj;  

          Product2 prod2Obj = new Product2();
          prod2Obj.Name = 'Network Services 2.0';
          prod2Obj.APTS_Media_High_Level_Code__c = '13';
          prod2Obj.APTS_Media_Lower_Level_Code__c = '2Q';

          insert prod2Obj;    

        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
       
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;


        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;        
        
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          //APTS_New_Bridge_Discount__c = 3.3,
          //Apttus_Config2__LineStatus__c = 'Renewed',
          
          //APTS_Media_Lower_Level_Code__c = 'SS',
          //APTS_Keep_Terms__c = True,
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          //Apttus_Config2__LineStatus__c = 'Cancelled',
          Apttus_Config2__PriceListItemId__c = pliSO.id); 

        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;

        
 
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            //APTS_Group_Primary_Material_Name__c='PROFLEX',
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prod2Obj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj2};
            
        insert OLItemList;

        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX';
        insert bundlePageSettings;
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c , APTS_Product_Family__c   
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      

        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             

        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , lineItemsList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
        @isTest static void testMethodTwo(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        insertStaticValues();
         
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41976905');newMap.add(p1);
         Product2 p2 = NewProduct('41618485');newMap.add(P2);                               
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            
            Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line21 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
           
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line11,line21};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }       
    
    @isTest static void testMethodfour(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
         
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41937760');newMap.add(p1);
         Product2 p2 = NewProduct('42027610');newMap.add(P2);
         Product2 p3= NewProduct('41618485');newMap.add(P3); 
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj.APTS_Upgrade_Downgrade_Eligible__c = true;
         prodobj.ProductCode='41937760'; insert prodObj;
         
        Map<String,String> mProductsCods = New Map<String,String>();
        String scodes ='30790769,30790796,41948733,41903514,41903515,41948732,41874867,41819164,41817448,41937760';
        for(String s :scodes.split(',')){
            mProductsCods.put(s,s);
        }
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line121 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12,line121};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }       
    
    @isTest static void testMethodfive(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
         
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42088301');newMap.add(p1);
         Product2 p2 = NewProduct('42027609');newMap.add(P2); //37005005
        Product2 p3 = NewProduct('37005005');newMap.add(P3); //37005005
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line121 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line1211 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12,line111,line121,line1211};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodsix(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('37005005');newMap.add(p1);
        Product2 p2 = NewProduct('40987607');newMap.add(P2);
            Product2 p3 = NewProduct('40987608');newMap.add(p3);

         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line121 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line1211 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12,line111,line121,line1211,line2};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void testMethodseven(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('37005072');newMap.add(p1);
         Product2 p2 = NewProduct('37005004');newMap.add(P2);
         Product2 p3 = NewProduct('37005005');newMap.add(P3);
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
         Apttus_Config2__LineItem__c line121 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
         
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12,line121,line2,line3};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodeight(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40987608');newMap.add(p1);
         Product2 p2 = NewProduct('41680342');newMap.add(P2);
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        Apttus_Config2__LineItem__c line121 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12,line111,line121};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodnine(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        insertStaticValues();
         
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40987608');newMap.add(p1);
         Product2 p2 = NewProduct('41680342');newMap.add(P2);        
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void testMethodten(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42027607');newMap.add(p1);
         Product2 p2 = NewProduct('42027608');newMap.add(P2);        
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c line12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         Apttus_Config2__LineItem__c line121 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line12,line111,line121};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    
     @isTest static void testMethodeleven(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41680342');newMap.add(p1);
         Product2 p2 = NewProduct('37005072');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void method1(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        //Source_System_Detail__c ssd = new Source_System_Detail__c(Name='TestSSD',Source_System_Name__c='TestSS1', Account_Name__c=a.Id);
       // insert ssd;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42027609');newMap.add(p1);
         Product2 p2 = NewProduct('42027610');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
      @isTest static void method2(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
       List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42027610');newMap.add(p1);
         Product2 p2 = NewProduct('42027609');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void method3(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41937760');newMap.add(p1);
         Product2 p2 = NewProduct('41618485');newMap.add(p2);
         Product2 p3 = NewProduct('42027610');newMap.add(p3);
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line41 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4,line41};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void method4(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41618485');newMap.add(p1);
         Product2 p2 = NewProduct('41937760');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void method5(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41618485');newMap.add(p1);
         Product2 p2 = NewProduct('41937760');newMap.add(p2);          
         Product2 p3 = NewProduct('41767150');newMap.add(p3);
         Product2 p4 = NewProduct('41076128');newMap.add(p4);
         Product2 p5 = NewProduct('40485592');newMap.add(p5);
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line5 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line6 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[3].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line7 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[4].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4,line5,line6,line7};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void method6(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41618485');newMap.add(p1);
         Product2 p2 = NewProduct('41937760');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='42027608'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=6,
          Apttus_Config2__ProductId__c=prodobj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
           
           Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line111 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
         Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=6,
            Apttus_Config2__ProductId__c=newMap[1].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            
            
             //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line11,line111,line2,line3,line4};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    
     @isTest static void New2(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41378928');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);


         Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[1].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
     
     
     
     
     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void New3(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40666911');newMap.add(p1);
         Product2 p2 = NewProduct('41817449');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New4(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41076128');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New5(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41053157');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New7(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42532855');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New6(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42532854');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    
    @isTest static void New8(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42532852');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void New9(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42532853');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void New10(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41986777');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New11(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40542344');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New13(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42118619');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void New12(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40542344');newMap.add(p1);
         Product2 p2 = NewProduct('41093075');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
     @isTest static void New14(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
 
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40542344');newMap.add(p1);
         Product2 p2 = NewProduct('40483699');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='40586465'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     
     Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=4,
          Apttus_Config2__ProductId__c=newMap[1].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
     @isTest static void New15(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     

         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('40542345');newMap.add(p1);
         Product2 p2 = NewProduct('40485592');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
          
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     
     Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=4,
          Apttus_Config2__ProductId__c=newMap[1].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

     List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
         insert OLItemList;       
        
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
     @isTest static void new16(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        Map<String,String> mProductcodes6 = New Map<String,String>();
        
        Product_Codes_Set6__c prodCode6 = new Product_Codes_Set6__c();
        prodCode6.Name='30405006';
        insert prodCode6;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        
       
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        insert procodes;
        
       FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30405006';
         firmList.Product_Family__c='Firmsite';
         insert firmList;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='30790769'; insert prodObj;

         Product2 prod2Obj = new Product2();
         prod2Obj.Name = 'Network Services 2.0';
         prod2Obj.APTS_Media_High_Level_Code__c = '07';
         prod2Obj.APTS_Media_Lower_Level_Code__c = 'BB';
         lNewProducts.Add(prod2Obj); 
         insert prod2Obj;
         
         Product2 prod3Obj = new Product2();
         prod3Obj.Name = 'Network Services 2.0';
         prod3Obj.APTS_Media_High_Level_Code__c = '07';
         prod3Obj.APTS_Media_Lower_Level_Code__c = 'BB';
         prod3Obj.productcode = '41093075';
         insert  prod3Obj;        
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41767150');newMap.add(p1);
         Product2 p2 = NewProduct('41076128');newMap.add(P2);
         Product2 p3 = NewProduct('41053157');newMap.add(p3);
         Product2 p4 = NewProduct('42532854');newMap.add(p4);
         Product2 p5 = NewProduct('42532855');newMap.add(p5);
         Product2 p6 = NewProduct('42532852');newMap.add(p6);
         Product2 p7 = NewProduct('42532853');newMap.add(p7);
         Product2 p8 = NewProduct('41986777');newMap.add(p8);
         Product2 p9 = NewProduct('42118619');newMap.add(p9);
         Product2 p10 =NewProduct('41053156');newMap.add(p10);
         Product2 p11 = NewProduct('42027607');newMap.add(p11);
         Product2 p12 = NewProduct('42027608');newMap.add(p12);
         Product2 p13 = NewProduct('41680342');newMap.add(p13);
         Product2 p14 = NewProduct('40987608');newMap.add(p14);
         Product2 p15 = NewProduct('37005004');newMap.add(p15);
         Product2 p16 = NewProduct('37005072');newMap.add(p16);
         Product2 p17 = NewProduct('40987607');newMap.add(p17);
         Product2 p18 = NewProduct('37005005');newMap.add(p18);
         Product2 p19 = NewProduct('42088301');newMap.add(p19);
         Product2 p20 = NewProduct('42027609');newMap.add(p20);
         Product2 p21 = NewProduct('42027610');newMap.add(p21);
         Product2 p22 = NewProduct('41937760');newMap.add(p22);
         Product2 p23 = NewProduct('41618485');newMap.add(p23);
         Product2 p24 = NewProduct('41976905');newMap.add(p24);
         Product2 p25 = NewProduct('40483699');newMap.add(p25);
         Product2 p26 = NewProduct('40542344');newMap.add(p26);
         Product2 p27 = NewProduct('40542345');newMap.add(p27);
         Product2 p28 = NewProduct('40656696');newMap.add(p28);
         Product2 p29 = NewProduct('40485592');newMap.add(p29);
         Product2 p30 = NewProduct('40586465');newMap.add(p30);
         Product2 p31 = NewProduct('41093075');newMap.add(p31);
         Product2 p32 = NewProduct('41378928');newMap.add(p32);
         Product2 p33 = NewProduct('41817449');newMap.add(p33);
         Product2 p34 = NewProduct('30790769');newMap.add(p34);
         Product2 p35 = NewProduct('41819162');newMap.add(p35);
         Product2 p36 = NewProduct('41323281');newMap.add(p36);
         Product2 p37 = NewProduct('41325003');newMap.add(p37);
         Product2 p38 = NewProduct('41701486');newMap.add(p38);
         Product2 p39 = NewProduct('41323282');newMap.add(p39);
         Product2 p40 = NewProduct('40666911');newMap.add(p40);
         Product2 p41 = NewProduct('41895338');newMap.add(p41);
         Product2 p42 = NewProduct('41343504');newMap.add(p42);
         Product2 p43 = NewProduct('41689176');newMap.add(p43);
         
        Insert newMap;
         Map<String,Product2> newMapping = New Map<String,Product2>();
         for(Product2 p:newMap){
             newMapping.put(p.Productcode,p);
         }
         Map<String,String> mfirmSite = new Map<String,String>();
         for(Product2 p:newMap){
             mfirmSite.put(p.Productcode,p.Productcode);
         }

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
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        insert asset;
         Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod3Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
        insert asset1;
         List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>();
         APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
         caval.Name='test'; insert caval;
         
         APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
         com.Name  ='test';
         com.APTS_Attribute_Value0__c =caval.id;
         com.APTS_Attribute_Value1__c=caval.id;
         com.APTS_Attribute_Value2__c=caval.id;
         com.APTS_Attribute_Value3__c=caval.id;
         insert com;
         Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41767150').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a1);
         
         Apttus_Config2__AssetLineItem__c a2 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41076128').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a2);
         Apttus_Config2__AssetLineItem__c a3 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41053157').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a3);
         Apttus_Config2__AssetLineItem__c a4 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532854').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a4);
         Apttus_Config2__AssetLineItem__c a5 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532855').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a5);
         Apttus_Config2__AssetLineItem__c a6 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532852').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a6);
         Apttus_Config2__AssetLineItem__c a7 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42532853').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a7);
         Apttus_Config2__AssetLineItem__c a8 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41986777').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a8);
         Apttus_Config2__AssetLineItem__c a9 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42118619').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a9);
         Apttus_Config2__AssetLineItem__c a10 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41053156').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a10);
         Apttus_Config2__AssetLineItem__c a11 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027607').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a11);
         Apttus_Config2__AssetLineItem__c a112 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027607').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a112);
         Apttus_Config2__AssetLineItem__c a12 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027608').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a12);
         Apttus_Config2__AssetLineItem__c a13 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41680342').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a13);
         Apttus_Config2__AssetLineItem__c a14 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40987608').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a14);
         Apttus_Config2__AssetLineItem__c a15 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('37005004').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a15);
         Apttus_Config2__AssetLineItem__c a16 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('37005072').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a16);
         Apttus_Config2__AssetLineItem__c a17 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40987607').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a17);
         Apttus_Config2__AssetLineItem__c a18 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('37005005').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a18);
         Apttus_Config2__AssetLineItem__c a19 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42088301').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a19);
         Apttus_Config2__AssetLineItem__c a20 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027609').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a20);
         Apttus_Config2__AssetLineItem__c a21 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('42027610').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a21);
         
         Apttus_Config2__AssetLineItem__c a22 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41937760').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a22);
         
         Apttus_Config2__AssetLineItem__c a23 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41618485').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a23);
         Apttus_Config2__AssetLineItem__c a24 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41976905').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a24);
         Apttus_Config2__AssetLineItem__c a25 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40483699').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a25);
         Apttus_Config2__AssetLineItem__c a26 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40542344').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a26);
         Apttus_Config2__AssetLineItem__c a27 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40542345').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a27);
         Apttus_Config2__AssetLineItem__c a28 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40656696').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a28);
         Apttus_Config2__AssetLineItem__c a29 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40485592').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a29);
         
         Apttus_Config2__AssetLineItem__c a30 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('40666911').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         lNewAsetline.Add(a30);
         Apttus_Config2__AssetLineItem__c a31 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41895338').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
         Apttus_Config2__AssetLineItem__c a32 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41343504').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='Live Site (Non Firmsite)',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);  
        Apttus_Config2__AssetLineItem__c a33 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41689176').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10); 
        Apttus_Config2__AssetLineItem__c a34 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41689176').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='NON-FIRMSITE/LAWINFO',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);                                                                                                                                             
         lNewAsetline.Add(a31);
         lNewAsetline.Add(a32);
         lNewAsetline.Add(a33);
         lNewAsetline.Add(a34);
         insert lNewAsetLine;
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prod2Obj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup2;
        
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = prodObj.Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); //prod19bj
         
         Apttus_Config2__LineItem__c linObj3 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = newMap[0].Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c linObj4 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',
            Apttus_Config2__OptionId__c = newMap[1].Id,
            Apttus_Config2__SummaryGroupId__c = summaryGroup2.id,
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__OptionPrice__c = 5.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            APTS_Proposal_Group__c = proposalGroup.Id,
            APTS_Group__c = proposalGroup.APTS_Group_Name__c,
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[1].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[1].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[1].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[1].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[1].Id;
          Insert attributecombination;
           
          

            Apttus_Config2__LineItem__c linObj5 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 8, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
         
         
            
         
         Apttus_Config2__LineItem__c linObj6 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[3].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 9, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c linObj7 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[4].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 10, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
         
         Apttus_Config2__LineItem__c linObj8 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[5].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 10, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 

            Apttus_Config2__LineItem__c linObj9 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[6].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 11, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);    
      
         Apttus_Config2__LineItem__c linObj10 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[7].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 11, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);   


            Apttus_Config2__LineItem__c linObj11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[8].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
           
           Apttus_Config2__LineItem__c linObj12 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[9].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            
            Apttus_Config2__LineItem__c linObj13 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[10].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 13, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
         
         Apttus_Config2__LineItem__c linObj14 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[11].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 13, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            Apttus_Config2__LineItem__c linObj15 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[12].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
         Apttus_Config2__LineItem__c linObj16 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[13].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c linObj17 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[14].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj18 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[15].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);            
           
            
            Apttus_Config2__LineItem__c linObj19 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[16].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj20 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[17].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj21 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[18].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj22 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[19].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj23 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[20].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj24 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[21].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj25 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[22].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj26 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[23].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj27 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[24].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj28 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[25].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj29 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[26].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj30 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[27].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj31 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[28].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj32 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[29].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj33 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[30].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj34 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[31].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c linObj35 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[32].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c linObj36 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[33].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            
            Apttus_Config2__LineItem__c linObj37 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[34].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj38 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[35].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj39 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[36].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj40 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[37].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj41 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[38].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Option',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj42 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[39].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
                   
            Apttus_Config2__LineItem__c linObj43 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[40].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);  
            
            Apttus_Config2__LineItem__c linObj44 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[11].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',            
            APTS_Bridge__c = '1 Month',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
        

            //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj2,linObj44,linObj3,linObj4,linObj5,linObj6,linObj7,linObj8,linObj9,linObj10,linObj11,linObj12,linObj13,linObj14,linObj15,linObj16,linObj,linObj17,linObj18,linObj19,linObj20,linObj21,linObj22,linObj23,linObj24,linObj25,linObj26,linObj27,linObj28,linObj29,linObj30,linObj31,linObj32,linObj33,linObj34,linObj35,linObj36,linObj37,linObj38,linObj39,linObj40,linObj41,linObj42,linObj43};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
     }
     
  
     @isTest static void new66(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
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
         
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;   
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          
         insert pliSO;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='40987607'; 
          insert prodObj;
          
          Product2 prodObj1 = new Product2();
          prodObj1.Name = 'Network Services 1.0';
          prodObj1.APTS_Media_High_Level_Code__c = '08';
          prodObj1.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj1.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj1.ProductCode='42027608'; 
          insert prodObj1;

          APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
          attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj.id;
          insert attributesetting;
          
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue1.APTS_Product__c=prodObj.id;
          Insert attributevalue1;
          
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue2.APTS_Product__c=prodObj.id;
          Insert attributevalue2;
          
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue3.APTS_Product__c=prodObj.id;
          Insert attributevalue3;
          
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';
          attributevalue4.APTS_Parent_Attribute__c=attributevalue3.id;
          attributevalue4.APTS_Product__c=prodObj.id;
          insert attributevalue4;
 
          
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Product__c=prodObj.id;
          insert attributecombination;
          
          APTS_Attribute_Value_Combination__c attributecombination1 = new APTS_Attribute_Value_Combination__c();
          attributecombination1.Name='Marshall-General';
          attributecombination1.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination1.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination1.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination1.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination1.APTS_Product__c=prodObj.id;
          insert attributecombination1;
          
          
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
          Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination1.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
            insert OLItemList;

        
         
            
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj1.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
     }
     
  /*   @isTest static void new67(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
         proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert proposal;   
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          
         insert pliSO;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='42027608'; 
          insert prodObj;
          
                                                                                 

          APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
          attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj.id;
          insert attributesetting;
          
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue1.APTS_Product__c=prodObj.id;
          Insert attributevalue1;
          
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue2.APTS_Product__c=prodObj.id;
          Insert attributevalue2;
          
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue3.APTS_Product__c=prodObj.id;
          Insert attributevalue3;
          
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';
          attributevalue4.APTS_Parent_Attribute__c=attributevalue3.id;
          attributevalue4.APTS_Product__c=prodObj.id;
          insert attributevalue4;
 
          
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Product__c=prodObj.id;
          insert attributecombination;
          
           Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.id,APTS_SSD_Sold_To__c = prodConfig.APTS_SSD_Sold_To__c,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='123456',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='NON-FIRMSITE/LAWINFO',
                                                                                     APTS_Combination_Key__c=attributecombination.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
        insert asset1;  
          
          
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
          

            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
            insert OLItemList;

        
         
            
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
     }
     
      @isTest static void new68(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;   
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          
         insert pliSO;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41343504'; 
          insert prodObj;
          
          Product2 prodObj1 = new Product2();
          prodObj1.Name = 'Network Services 1.0';
          prodObj1.APTS_Media_High_Level_Code__c = '08';
          prodObj1.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj1.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj1.ProductCode='41689176'; 
          insert prodObj1;

          APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
          attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj.id;
          insert attributesetting;
          
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue1.APTS_Product__c=prodObj.id;
          Insert attributevalue1;
          
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue2.APTS_Product__c=prodObj.id;
          Insert attributevalue2;
          
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue3.APTS_Product__c=prodObj.id;
          Insert attributevalue3;
          
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';
          attributevalue4.APTS_Parent_Attribute__c=attributevalue3.id;
          attributevalue4.APTS_Product__c=prodObj.id;
          insert attributevalue4;
 
          
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Product__c=prodObj.id;
          insert attributecombination;
          
          APTS_Attribute_Value_Combination__c attributecombination1 = new APTS_Attribute_Value_Combination__c();
          attributecombination1.Name='Marshall-General';
          attributecombination1.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination1.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination1.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination1.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination1.APTS_Product__c=prodObj.id;
          insert attributecombination1;
          
          
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
          Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj1.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination1.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
            insert OLItemList;

        
         
            
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj1.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
     }
     */
      @isTest static void new69(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;   
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          
         insert pliSO;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='30405006'; 
          insert prodObj;
          
          Product2 prodObj1 = new Product2();
          prodObj1.Name = 'Network Services 1.0';
          prodObj1.APTS_Media_High_Level_Code__c = '08';
          prodObj1.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj1.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj1.ProductCode='30405007'; 
          insert prodObj1;
 
          FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30405006';
         firmList.Product_Family__c='Firmsite';
         insert firmList;
         
         FirmSiteVSPPC__c firmList1=new FirmSiteVSPPC__c();
         firmList1.Name='30405007';
         firmList1.Product_Family__c='Firmsite';
         insert firmList1;
 
          APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
          attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj.id;
          insert attributesetting;
          
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue1.APTS_Product__c=prodObj.id;
          Insert attributevalue1;
          
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue2.APTS_Product__c=prodObj.id;
          Insert attributevalue2;
          
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue3.APTS_Product__c=prodObj.id;
          Insert attributevalue3;
          
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';
          attributevalue4.APTS_Parent_Attribute__c=attributevalue3.id;
          attributevalue4.APTS_Product__c=prodObj.id;
          insert attributevalue4;
 
          
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Product__c=prodObj.id;
          insert attributecombination;
          
          APTS_Attribute_Value_Combination__c attributecombination1 = new APTS_Attribute_Value_Combination__c();
          attributecombination1.Name='Marshall-General';
          attributecombination1.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination1.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination1.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination1.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination1.APTS_Product__c=prodObj.id;
          insert attributecombination1;
          
          
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
          Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj1.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
     APTS_Combination_Key__c = attributecombination1.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'Cancelled',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);

            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj,linObj1};
            insert OLItemList;

        
         
            
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj1.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
     }
  /*    @isTest static void new70(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;   
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          
         insert pliSO;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
        List<Product2> lNewProducts = new List<Product2>();
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='30405006'; 
      prodobj.APTS_Attrbased_config__c= TRUE;
          insert prodObj;
 
          FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30405006';
         firmList.Product_Family__c='Firmsite';
         insert firmList;
         
         FirmSiteVSPPC__c firmList1=new FirmSiteVSPPC__c();
         firmList1.Name='30405007';
         firmList1.Product_Family__c='Firmsite';
         insert firmList1;
 
          APTS_Attribute_Settings__c attributesetting = new APTS_Attribute_Settings__c();
          attributesetting.Name='State';
          attributesetting.APTS_API_Method_Name__c='APTS_FL_Qty__c';
          attributesetting.Product__c=prodObj.id;
          insert attributesetting;
          
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue1.APTS_Product__c=prodObj.id;
          Insert attributevalue1;
          
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue2.APTS_Product__c=prodObj.id;
          Insert attributevalue2;
          
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalue3.APTS_Product__c=prodObj.id;
          Insert attributevalue3;
          
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';
          attributevalue4.APTS_Parent_Attribute__c=attributevalue3.id;
          attributevalue4.APTS_Product__c=prodObj.id;
          insert attributevalue4;
 
          
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Product__c=prodObj.id;
          insert attributecombination;
          
          APTS_Attribute_Value_Combination__c attributecombination1 = new APTS_Attribute_Value_Combination__c();
          attributecombination1.Name='Marshall-General';
          attributecombination1.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination1.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination1.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination1.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination1.APTS_Product__c=prodObj.id;
          insert attributecombination1;
          
          
          Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          APTS_Combination_Key__c = attributecombination.Id,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',         
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
            insert OLItemList;

        
         
            
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
     }
      @isTest static void newFirmsite(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        Map<String,String> mProductcodes6 = New Map<String,String>();
        
        Product_Codes_Set6__c prodCode6 = new Product_Codes_Set6__c();
        prodCode6.Name='30405006';
        insert prodCode6;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        
       
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        insert procodes;
        
       FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30405006';
         firmList.Product_Family__c='Firmsite';
         insert firmList;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
    
        List<Product2> lNewProducts = new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_High_Level_Code__c = '08';
        prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
        prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        prodobj.ProductCode='30405006';
    insert prodObj;      
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('30405006');newMap.add(p1); 
         Insert newMap;
     
         Map<String,Product2> newMapping = New Map<String,Product2>();
         for(Product2 p:newMap){
             newMapping.put(p.Productcode,p);
         }
         Map<String,String> mfirmSite = new Map<String,String>();
         for(Product2 p:newMap){
             mfirmSite.put(p.Productcode,p.Productcode);
         }

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
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        insert asset;
         List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>();
         APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
         caval.Name='test'; insert caval;
         
         APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
         com.Name  ='test';
         com.APTS_Attribute_Value0__c =caval.id;
         com.APTS_Attribute_Value1__c=caval.id;
         com.APTS_Attribute_Value2__c=caval.id;
         com.APTS_Attribute_Value3__c=caval.id;
         insert com;
         Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30405006').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='123456',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__LineType__c ='Product/Service');
         lNewAsetline.Add(a1);
         insert lNewAsetLine;

         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
    
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        
     
      
            //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj2};
            insert OLItemList;
         
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
   }  
      @isTest static void newFirmsitetest(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        Map<String,String> mProductcodes6 = New Map<String,String>();
        
        Product_Codes_Set6__c prodCode6 = new Product_Codes_Set6__c();
        prodCode6.Name='30405006';
        insert prodCode6;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        
       
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        insert procodes;
        
       FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30405006';
         firmList.Product_Family__c='Firmsite';
         insert firmList;

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
    
        List<Product2> lNewProducts = new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_High_Level_Code__c = '08';
        prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
        prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        prodobj.ProductCode='30405006';
    insert prodObj;      
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('30405006');newMap.add(p1); 
         Insert newMap;
     
         Map<String,Product2> newMapping = New Map<String,Product2>();
         for(Product2 p:newMap){
             newMapping.put(p.Productcode,p);
         }
         Map<String,String> mfirmSite = new Map<String,String>();
         for(Product2 p:newMap){
             mfirmSite.put(p.Productcode,p.Productcode);
         }

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
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        insert asset;
         List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>();
         APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
         caval.Name='test'; insert caval;
         
         APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
         com.Name  ='test';
         com.APTS_Attribute_Value0__c =caval.id;
         com.APTS_Attribute_Value1__c=caval.id;
         com.APTS_Attribute_Value2__c=caval.id;
         com.APTS_Attribute_Value3__c=caval.id;
         insert com;
         Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30405006').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='123456',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__LineType__c ='Product/Service');
         lNewAsetline.Add(a1);
         insert lNewAsetLine;

         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
    
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
        
     
      
            //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj2};
            insert OLItemList;
         
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
   } */
      @isTest static void newCheck(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        Map<String,String> mProductcodes6 = New Map<String,String>();
        
        Product_Codes_Set6__c prodCode6 = new Product_Codes_Set6__c();
        prodCode6.Name='30405006';
        insert prodCode6;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        insert procodes;
        
       /*FirmSiteVSPPC__c firmList=new FirmSiteVSPPC__c();
         firmList.Name='30405006';
         firmList.Product_Family__c='Firmsite';
         insert firmList;*/

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;
    
        List<Product2> lNewProducts = new List<Product2>();
        Product2 prodObj = new Product2();
        prodObj.Name = 'Network Services 1.0';
        prodObj.APTS_Media_High_Level_Code__c = '08';
        prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
        prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
        prodobj.ProductCode='30790796';
    insert prodObj;      
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('30790796');newMap.add(p1); 
         Insert newMap;
     
         Map<String,Product2> newMapping = New Map<String,Product2>();
         for(Product2 p:newMap){
             newMapping.put(p.Productcode,p);
         }
         Map<String,String> mfirmSite = new Map<String,String>();
         for(Product2 p:newMap){
             mfirmSite.put(p.Productcode,p.Productcode);
         }

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
         System.debug('Proposallineitemlist...'+lstPLIs);
           List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstPropAttr = new List<Apttus_QPConfig__ProposalProductAttributeValue__c>();
        System.debug('ProposalAttrrList...'+lstPropAttr);
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        insert asset;
         List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>();
         APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
         caval.Name='test'; insert caval;
         
         APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
         com.Name  ='test';
         com.APTS_Attribute_Value0__c =caval.id;
         com.APTS_Attribute_Value1__c=caval.id;
         com.APTS_Attribute_Value2__c=caval.id;
         com.APTS_Attribute_Value3__c=caval.id;
         insert com;
         /*Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('30405006').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='123456',
                                                                                        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__LineType__c ='Product/Service');
         lNewAsetline.Add(a1);
         insert lNewAsetLine;*/

         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
    
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO2;   

        APTS_Group__c proposalGroup =new APTS_Group__c();
       proposalGroup.APTS_GrossAmount__c = 0;
       proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
       proposalGroup.APTS_Group_Name__c ='Print Bundle A';
       proposalGroup.APTS_NetAmount__c=0;
       insert proposalGroup;
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
             insert summaryGroup1;
        Apttus_Config2__LineItem__c linObj2 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=2,
          Apttus_Config2__ProductId__c=prodObj.id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',
          Apttus_Config2__SummaryGroupId__c = summaryGroup1.id,
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',
          APTS_Proposal_Group__c = proposalGroup.Id,
          APTS_Group__c = proposalGroup.APTS_Group_Name__c,
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
     
     
     
            //linObj221
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj2};
            insert OLItemList;
         
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj2.Id];      
        System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
   } 
   @isTest static void abogadoPremiumTest(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
        
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
         
        /*PA_GEO__c  pageo = New PA_GEO__c();
         pageo.Name='41378928';
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051,42762345';
         insert pageo;
        */
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= APTS_TestDataFactory.createSourceSystem(a);
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=a;
        insert oppty;
        
        

        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
         proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
         proposal.APTS_Approval_Segment__c  ='FindLaw';
        insert proposal;
        
        proposal.APTS_Proposal_Business_Unit__c  ='FindLaw';
        update proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('42762345');newMap.add(p1);
         Product2 p2 = NewProduct('42762345');newMap.add(p2);          
         
         Insert newMap;
        
         
         
         Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
          pliSO.Apttus_Config2__Active__c = true;
          pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO.APTS_Max_Fill_Up_Price__c = 5;
        insert pliSO;
          Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
          pliSO2.Apttus_Config2__Active__c = true;
          pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
          pliSO2.APTS_Max_Fill_Up_Price__c = 5;
          insert pliSO2;         
        
          APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
          attributevalue1.Name='Insurance';
          attributevalue1.APTS_Attribute_Name__c='State';          
          attributevalue1.APTS_Product__c=newMap[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap[0].Id;
          Insert attributecombination;
         
         Apttus_Config2__AssetLineItem__c assetcreation=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=newMap[0].id,APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__Quantity__c=1,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_QPConfig__ProposalId__c =proposal.id,APTS_Renewal_Eligible__c = 'No', APTS_Info_PlanType__c = 'ABCD');
         insert assetcreation;
          
         
          
            Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
         prodobj.ProductCode='41937760'; insert prodObj;
          
           Apttus_Config2__LineItem__c linObj = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[0].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);       
     
     
     
     
         List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj};
         insert OLItemList;
         
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());  
          Apttus_Config2__LineItem__c linObj1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=16,
          Apttus_Config2__ProductId__c=newMap[1].id,
           // Apttus_Config2__AttributeValueId__c = propattr.id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 1, 
          Apttus_Config2__ItemSequence__c = 1,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 10.0,
          Apttus_Config2__AdjustedPrice__c = 10.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);   
          OLItemList = new List<Apttus_Config2__LineItem__c>{linObj1};
          insert OLItemList;    
          Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());  
          Test.stopTest();                                              
    } 
   public Static Product2 NewProduct(String ProductCode){
        Product2 prod3Obj = new Product2();
        prod3Obj.Name = 'Network Services 2.0';
        prod3Obj.APTS_Media_High_Level_Code__c = '07';
        prod3Obj.APTS_Media_Lower_Level_Code__c = 'BB';
        prod3Obj.productcode = ProductCode;
        return prod3Obj;
    }  
    
    @isTest static void insertStaticValues(){
    
          LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        
        insert staticCSList ;
    
    } 
}