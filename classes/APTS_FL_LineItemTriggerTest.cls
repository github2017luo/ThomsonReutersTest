@isTest
private class APTS_FL_LineItemTriggerTest {

    static testMethod void testMethodOne(){
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        lCRMStrikeIronFlagINS1.TextValue__c='True';
         insert lCRMStrikeIronFlagINS1;
        //Inserting recordLists
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c=System.Label.APTS_OC_Test_Id;
        recordlist.add(recordtype1);
        insert recordlist;
        APTS_TestDataFactory.createFLTrephCodes();
        Map<String,List<String>> flcodeMap=new Map<String,List<String>>(); 
        List<APTS_TREPH_FINDLAW_CODES__c> flcodes= APTS_TREPH_FINDLAW_CODES__c.getAll().values();
        for(APTS_TREPH_FINDLAW_CODES__c pb :flcodes){    
            flcodeMap.put(pb.name,pb.value__c.split(','));
        }
        List<Apttus_Config2__ConfigLineItemCustomFields__c> customFieldsList=new List<Apttus_Config2__ConfigLineItemCustomFields__c>();
        Apttus_Config2__ConfigLineItemCustomFields__c obj=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_FL_Renewal_List_Price__c';
        obj.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,APTS_Year_2_3_Price__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Combination_Key__c,APTS_Max_Effective_Discount__c,APTS_Proposal_Business_Unit__c,APTS_Item_Category_Group__c,Apttus_Config2__ParentBundleNumber__c';
        obj.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, Apttus_Config2__PriceListItemId__r.APTS_FL_Renewal_List_Price__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__ProductId__r.APTS_Price_Call__c';
        obj.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,APTS_Year_2_3_Price__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__ParentBundleNumber__c,APTS_PAGEO_Price__c,APTS_WLEC_Product_Category__c';      
        obj.name='Custom Field Names';
        customFieldsList.add(obj);
        Apttus_Config2__ConfigLineItemCustomFields__c obj1=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj1.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.APTS_Price_Call__c,APTS_Product_Code__c,APTS_Renewal_Type__c,APTS_Renewal_Type_Default__c,Apttus_Config2__ProductId__c,APTS_Billing_Frequency_Default__c,Apttus_Config2__BillingFrequency__c';
        obj1.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__AttributeValueId__r.APTS_Number_of_Attorneys_Override__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__AttributeValueId__r.id';
        obj1.Apttus_Config2__CustomFieldNames3__c ='Apttus_Config2__ConfigurationId__r,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_ship_to__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Align_Contract_End_Dates__c';
        obj1.name='Custom Field Names1';
        customFieldsList.add(obj1);
        Apttus_Config2__ConfigLineItemCustomFields__c obj2=new Apttus_Config2__ConfigLineItemCustomFields__c(); 
        obj2.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Year_2_Adjustment__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Years_2_Plus_Adjustment__c,APTS_Keep_Terms__c,APTS_Minimum_YoY_Increase__c';
        obj2.Apttus_Config2__CustomFieldNames2__c = 'APTS_Product_Family__c,APTS_Proposal_Group__c,APTS_Group__c,APTS_Contract_Term__c,APTS_YoY_Adjustment_Type__c,Apttus_Config2__ProductId__r.ProductCode,APTS_Item_Category_Group__c,APTS_Proposal_Business_Unit__c,APTS_Combination_Key__c';
        obj2.Apttus_Config2__CustomFieldNames3__c = 'APTS_Max_Discount__c, APTS_WestPack_Discount__c,APTS_Max_Effective_Discount__c,APTS_Corporate_Select_Option__c,APTS_Contract_Term_Whole_Years__c,Apttus_Config2__ParentBundleNumber__c';
        obj2.Apttus_Config2__CustomFieldNames4__c = 'APTS_Contract_Term_Default__c,APTS_Bridge__c,APTS_Bridge_Discount__c, APTS_Corporate_Select__c,Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_Of_Attorneys__c';
        obj2.Apttus_Config2__CustomFieldNames5__c = 'APTS_Bundle__c,APTS_SAP_Deal_Type__c,APTS_Yr_1_Renewal_Default__c,APTS_Years_2_Plus_Default__c,Apttus_Config2__OptionId__r.APTS_Module_Points__c,APTS_Product_Name__c,APTS_CAT_L5__c';      
        obj2.name='Custom Field Names2';
        customFieldsList.add(obj2);
        insert customFieldsList; 
        Profile pf = [SELECT Id FROM profile WHERE name='System Administrator']; 
       User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = pf.Id, employeenumber='0144020',
        timezonesidkey='America/Los_Angeles', username='user_flLineTr@mydomain.com',Sub_Bu__c='FindLaw',Rep_Type_Description__c ='SAM-FindLaw-Account Manager');        
        insert u1;
        System.runAs(u1){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       Account a = new Account(RecordTypeId=accRecordTypeId,name='test-sg',sales_org__c='ABEP',customer_group__c='Academic',customer_type__c='Organization',customer_class_c__c='Academic Lecturer');
       a.APTS_Customer_Category__c = '5';
       insert a;
       
        WebServiceSettings__c  ws = New WebServiceSettings__c ();
        ws.Name  ='Payment AutoCharge';
        ws.Endpoint__c='https://cs47.salesforce.com/servlet/servlet.ExternalRedirect?url=https%3A%2F%2Fstg.securepayment.thomsonreuters.com%2FTRPaymentGateway%2FBilling%2FInvoiceSummary%2FTRPaymentAutoCharge';
        ws.Service_Unavailable_Message__c   ='Auto Payment Service is Currently unavailable ';
        ws.Timeout__c=6;
        ws.Active__c=true;
        insert ws;
       
       
           
    //Inserting SourceSystemDetail
      Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.RecordtypeId=ssdRecorType;
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=a.ID;
      accountSSD.APTS_Customer_Category__c='1';
      accountSSD.LCRM_Customer_Group__c='Academic';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='WEST';
      accountSSD.LCRM_FL_Annual_Spend__c=300000;
      insert accountSSD;
       
       set<string> fldirectory = new set<string>();  
     fldirectory.add('37005072');
     fldirectory.add('40987607');
     fldirectory.add('40987608');
     fldirectory.add('41680342');
     fldirectory.add('37005004');
     fldirectory.add('37005005');
     fldirectory.add('41976905');
     fldirectory.add('42088301');
            
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD', Apttus_Proposal__Account__c=a.id,Apttus_Proposal__Proposal_Name__c='TST-10', Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',APTS_Align_Contract_End_Dates__c = true);
       p.APTS_Proposal_Business_Unit__c = 'FindLaw';
       insert p;
       p.APTS_Proposal_Business_Unit__c = 'FindLaw';
       update p;
       System.assertEquals(p.APTS_Proposal_Business_Unit__c,'FindLaw','Fine');
       Apttus_Config2__ProductConfiguration__c prodConf = new Apttus_Config2__ProductConfiguration__c(Name='prod-conf1', CurrencyIsoCode = 'USD', Apttus_QPConfig__Proposald__c=p.id, APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id);
       insert prodConf;
       
       List<Product2> productList=new List<Product2>();
       Product2 prod1 = new Product2(name='prod1', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '40483699');
       Product2 prod2 = new Product2(name='prod2', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40485592');
       Product2 prod3 = new Product2(name='prod3', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483696');
       Product2 prod4 = new Product2(name='prod4', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40483693');
       Product2 prod5 = new Product2(name='prod5', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41915678');
       Product2 prod6 = new Product2(name='prod6', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41892830');
       Product2 prod7 = new Product2(name='prod7', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41767150');
       Product2 prod8 = new Product2(name='prod8', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='42124052');
       Product2 prod9 = new Product2(name='prod9', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41822784');
       Product2 prod10 = new Product2(name='prod10', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41777796');
       Product2 prod11 = new Product2(name='prod11', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40542344');
       Product2 prod12= new Product2(name='prod12', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='40542345');
       Product2 prod13= new Product2(name='prod13', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode='41876119');
       Product2 prod14 = new Product2(name='prod14', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42157433');
       Product2 prod15 = new Product2(name='prod15', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '41180810');
       Product2 prod16 = new Product2(name='prod16', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '41053157');
       Product2 prod17 = new Product2(name='prod17', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '40586465');
       Product2 prod18 = new Product2(name='prod18', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '41895338');
       Product2 prod19 = new Product2(name='prod19', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '40666911');
       Product2 prod20 = new Product2(name='prod20', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42594853');
       Product2 prod21 = new Product2(name='prod21', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42532852');
       Product2 prod22 = new Product2(name='prod22', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '30010890');
       Product2 prodA = new Product2(name='prodA', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42532852');
     Product2 prodB = new Product2(name='prodB', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42532853');
     Product2 prodC = new Product2(name='prodC', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42532854');
     Product2 prodD = new Product2(name='prodD', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42532855');
     Product2 prodfldir=new Product2(name='prodD', Media_High_Level__c='Online', CurrencyIsoCode = 'USD',ProductCode = '42088301');
     
      Product2 prodObjExpo = new Product2();
          prodObjExpo.Name = 'FINDLAW EXPOSURE PACK';
          prodObjExpo.LCRM_Sub_Bu__c='FindLaw';
          prodObjExpo.APTS_Attrbased_config__C =true;
          prodObjExpo.APTS_Media_Lower_Level_Code__c = 'H5';
          prodObjExpo.ProductCode = '40656701';
          //insert prodObjExpo; 
       productList.add(prodfldir); 
       productList.add(prod1);
       productList.add(prod2);
       productList.add(prod3);
       productList.add(prod4);
       productList.add(prod5);
       productList.add(prod6);
       productList.add(prod7);
       productList.add(prod8);
       productList.add(prod9);
       productList.add(prod10);
       productList.add(prod11);
       productList.add(prod12);
       productList.add(prod13);
       productList.add(prod14);
       productList.add(prod15);
       productList.add(prod16);
       productList.add(prod17);
       productList.add(prod18);
       productList.add(prod19);
       productList.add(prod20);
       productList.add(prod21);
       productList.add(prod22);
     productList.add(prodA);
     productList.add(prodB);
     productList.add(prodC);
     productList.add(prodD);
     productList.add(prodObjExpo);
       insert productList;
         Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
         className.Apttus_Config2__Active__c = true;
         className.Apttus_Config2__GuidePage__c = 'APTPSGuidedSelling';
         className.Apttus_Config2__HierarchyLabel__c = 'Thomson Products';
         className.Apttus_Config2__Type__c = 'Offering';
         className.Name = 'Thomson Products';
         insert className;
            
         Apttus_Config2__ClassificationHierarchy__c classHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
         classHierarchy.Apttus_Config2__GuidePage__c = 'APTPSGuidedSelling';
         classHierarchy.Apttus_Config2__HierarchyId__c = className.Id;
         classHierarchy.Apttus_Config2__Label__c = 'Thomson Products';
         classHierarchy.Apttus_Config2__Left__c = 1.0;
         classHierarchy.Apttus_Config2__Level__c = 0.0;
         classHierarchy.Apttus_Config2__MaxOptions__c = 1.0;
         classHierarchy.Apttus_Config2__MinOptions__c = 1.0;
         classHierarchy.Apttus_Config2__Left__c = 2.0;
         insert classHierarchy;

         Apttus_Config2__ProductClassification__c prodClassification = new Apttus_Config2__ProductClassification__c();
         prodClassification.Apttus_Config2__ProductId__c = prodfldir.Id;
         prodClassification.Apttus_Config2__MaxQuantity__c =2.0;
         prodClassification.Apttus_Config2__MinQuantity__c = 1.0;
         prodClassification.Apttus_Config2__ClassificationId__c = classHierarchy.Id;
       
        insert prodClassification;
     APTS_Attribute_Value__c attributevalueexp1 = new APTS_Attribute_Value__c();
          attributevalueexp1.Name='California';
          attributevalueexp1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp1.APTS_Product__c=prodObjExpo.id;
        //  attributevalueexp1.IsMetro__c=false;
          Insert attributevalueexp1;
          
          APTS_Attribute_Value__c attributevalueexp2 = new APTS_Attribute_Value__c();
          attributevalueexp2.Name='Insurance';
          attributevalueexp2.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp2.APTS_Product__c=prodObjExpo.id;
        //  attributevalueexp2.IsMetro__c=false;
          Insert attributevalueexp2;
          
          APTS_Attribute_Value__c attributevalueexp3 = new APTS_Attribute_Value__c();
          attributevalueexp3.Name='Insurance Law';
          attributevalueexp3.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp3.APTS_Product__c=prodObjExpo.id;
       //   attributevalueexp3.IsMetro__c=false;
          Insert attributevalueexp3;
          
          APTS_Attribute_Value__c attributevalueexp4 = new APTS_Attribute_Value__c();
          attributevalueexp4.Name='Los Angeles-Long Beach, CA';
          attributevalueexp4.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp4.APTS_Product__c=prodObjExpo.id;
        //  attributevalueexp4.IsMetro__c=false;
          Insert attributevalueexp4;
     
     APTS_Attribute_Value_Combination__c attr1= new APTS_Attribute_Value_Combination__c();
          attr1.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr1.APTS_Attribute_Value0__c= attributevalueexp1.id;
          attr1.APTS_Attribute_Value1__c= attributevalueexp4.id;
          attr1.APTS_Attribute_Value2__c= attributevalueexp2.id;
          attr1.APTS_Attribute_Value3__c= attributevalueexp3.id;
          attr1.APTS_Inventory_Available__c=3;
      attr1.APTS_Exposure_Pack_Disc__c=93;
          attr1.APTS_Product__c=prodObjExpo.id;
        insert attr1;
     
        //Date farthestEndDate = Date.newInstance(2010, 01 , 10);
       
       List<Apttus_Config2__LineItem__c> insertList=new List<Apttus_Config2__LineItem__c>();
       //List<Apttus_Config2__LineItem__c> updateList=new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItemfldir=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id ,Findlaw_Approval_Required__c=false, Apttus_Config2__ProductId__c=prodfldir.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id ,Findlaw_Approval_Required__c=false, Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem4=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem5=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem6=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem7=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem8=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c ='New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem9=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20) ;
        Apttus_Config2__LineItem__c lineItem10=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        System.debug(LoggingLevel.WARN,' #######' +lineItem1.APTS_Proposal_Business_Unit__c);
        Apttus_Config2__LineItem__c lineItem11=new Apttus_Config2__LineItem__c(Apttus_Config2__Guidance__c='Yellow',Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem12=new Apttus_Config2__LineItem__c(Apttus_Config2__Guidance__c='Yellow',Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem13=new Apttus_Config2__LineItem__c(Apttus_Config2__Guidance__c='Yellow',Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem14=new Apttus_Config2__LineItem__c(Apttus_Config2__Guidance__c='Yellow',Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem15=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod11.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem16=new Apttus_Config2__LineItem__c(APTS_Contract_Term__c='1 Month',Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod12.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem17=new Apttus_Config2__LineItem__c(APTS_Contract_Term__c='1 Month',Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod13.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 100,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem18=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod14.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem19=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod15.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem20=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod16.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem21=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod17.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem22=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod18.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem23=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod19.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
        Apttus_Config2__LineItem__c lineItem24=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod20.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=30,APTS_Contract_Term__c ='1 Month');
        Apttus_Config2__LineItem__c lineItem25=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod21.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20,APTS_Contract_Term__c='2 Years') ;
        Apttus_Config2__LineItem__c lineItem26=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod16.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
        Apttus_Config2__LineItem__c lineItem27=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod17.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
        Apttus_Config2__LineItem__c lineItem28=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod18.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
    Apttus_Config2__LineItem__c lineItem30=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod22.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20);
     Apttus_Config2__LineItem__c lineItem29=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prodObjExpo.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Cancelled',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
        
    Apttus_Config2__LineItem__c lineItemA=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prodA.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
    Apttus_Config2__LineItem__c lineItemB=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prodB.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
    Apttus_Config2__LineItem__c lineItemC=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prodC.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
    Apttus_Config2__LineItem__c lineItemD=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prodD.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=1);
    
        insertList.add(lineItemfldir);
        insertList.add(lineItem1);
        insertList.add(lineItem2);
        insertList.add(lineItem3);
        insertList.add(lineItem4);
        insertList.add(lineItem5);
        insertList.add(lineItem6);
        insertList.add(lineItem7);
        insertList.add(lineItem8);
        insertList.add(lineItem9);
        insertList.add(lineItem10);
        insertList.add(lineItem11);
        insertList.add(lineItem12);
        insertList.add(lineItem13);
        insertList.add(lineItem14);
        insertList.add(lineItem15);
        insertList.add(lineItem16);
        insertList.add(lineItem17);
        insertList.add(lineItem18);
        insertList.add(lineItem19);
        insertList.add(lineItem20);
        insertList.add(lineItem21);
        insertList.add(lineItem22);
        insertList.add(lineItem23);
        insertList.add(lineItem24);
        insertList.add(lineItem25);
        insertList.add(lineItem26);
        insertList.add(lineItem27);
        insertList.add(lineItem28);
    insertList.add(lineItem29);
    insertList.add(lineItem30);
    insertList.add(lineItemA);
    insertList.add(lineItemB);
    insertList.add(lineItemC);
    insertList.add(lineItemD);
    
       insert insertList;
        System.debug(LoggingLevel.WARN,'#######' +insertList);
        
       Apttus_Config2__AssetLineItem__c asset=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',Apttus_QPConfig__ProposalId__c =p.id,APTS_Renewal_Eligible__c = 'No', APTS_Info_PlanType__c = 'ABCD');
       insert asset;
       System.debug(LoggingLevel.WARN,' #######' +asset);
       
      List<Apttus_Config2__LineItem__c> insertRenewedList=new List<Apttus_Config2__LineItem__c>();
     
       Apttus_Config2__LineItem__c lineItemnew1=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c ='New',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__AssetLineItemId__c = asset.id);
       Apttus_Config2__LineItem__c lineItemnew2=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__AssetLineItemId__c = asset.id);
     Apttus_Config2__LineItem__c lineItemE=new Apttus_Config2__LineItem__c(Apttus_Config2__ConfigurationId__c=prodConf.id , Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__LineType__c ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__LineStatus__c = 'Renewed',Apttus_Config2__ChargeType__c = 'Subscription Fee',Apttus_Config2__ItemSequence__c = 1,Apttus_Config2__LineNumber__c = 1,Apttus_Config2__ListPrice__c = 100,Apttus_Config2__NetAdjustmentPercent__c = -50,Apttus_Config2__NetPrice__c = 50,Apttus_Config2__NetUnitPrice__c = 50,Apttus_Config2__AdjustedPrice__c = 50,Apttus_Config2__AdjustmentAmount__c = 50,Apttus_Config2__AdjustmentType__c = '% Discount',Apttus_Config2__AddedBy__c = 'User',CurrencyIsoCode = 'USD',Apttus_Config2__EndDate__c=system.today()+20,Apttus_Config2__Quantity__c=20,APTS_Contract_Term__c='2 Years');
      insertRenewedList.add(lineItemnew1);
    insertRenewedList.add(lineItemnew2);
    insertRenewedList.add(lineItemE);
    insert insertRenewedList;
       
       Map<String,Apttus_Config2__AssetLineItem__c> mapOfProductCodeAndAssets = New Map<String,Apttus_Config2__AssetLineItem__c>();
       mapOfProductCodeAndAssets.put(asset.Apttus_Config2__ProductId__r.ProductCode, asset);
    
        List<Apttus_Config2__AssetAttributeValue__c> attributesList=new List<Apttus_Config2__AssetAttributeValue__c>();
         Apttus_Config2__AssetAttributeValue__c attribute1=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='English', APTS_PPC_Website_Selection__c='FirmSite or FindLaw Landing Page Hosting',Apttus_Config2__AssetLineItemId__c=asset.id);
         Apttus_Config2__AssetAttributeValue__c attribute2=new Apttus_Config2__AssetAttributeValue__c(APTS_PPC_Type__c='New PPC',APTS_PPC_Language_Selection__c='Español', APTS_PPC_Website_Selection__c='FirmSite or FindLaw Landing Page Hosting',Apttus_Config2__AssetLineItemId__c=asset.id);
         attributesList.add(attribute1);
         attributesList.add(attribute2);
         insert attributesList;
         
       List<Apttus_Config2__AssetLineItem__c> assetLinesList = New List<Apttus_Config2__AssetLineItem__c>();
       Apttus_Config2__AssetLineItem__c assetfldir=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prodfldir.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset1=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod1.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset2=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod2.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset3=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod3.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset4=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod4.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset5=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod5.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute1.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset6=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod6.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset7=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod7.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset8=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod8.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset9=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod9.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       Apttus_Config2__AssetLineItem__c asset10=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=prod10.id,Apttus_Config2__Quantity__c=5,Apttus_Config2__AssetStatus__c ='Activated',Apttus_Config2__LineType__c  ='Product/Service',APTS_SSD_ship_to__c=accountSSD.id,Apttus_Config2__AttributeValueId__c=attribute2.id,Apttus_QPConfig__ProposalId__c =p.id,Apttus_Config2__EndDate__c=system.today()+20);
       System.debug(LoggingLevel.WARN,' #######' + asset10.APTS_SSD_ship_to__c);
       assetLinesList.add(asset1);
       assetLinesList.add(asset2);
       assetLinesList.add(asset3);
       assetLinesList.add(asset4);
       assetLinesList.add(asset5);
       assetLinesList.add(asset6);
       assetLinesList.add(asset7);
       assetLinesList.add(asset8);
       assetLinesList.add(asset9);
       assetLinesList.add(asset10);
       assetLinesList.add(assetfldir);
       insert assetLinesList;
       
         mapOfProductCodeAndAssets.put(asset7.Apttus_Config2__ProductId__r.ProductCode, asset7);
         mapOfProductCodeAndAssets.put(asset8.Apttus_Config2__ProductId__r.ProductCode, asset8);
         
       test.startTest();     
        List<Apttus_Config2__LineItem__c> lalllins = [SELECT APTS_Approval_Segment__c,APTS_Bridge_Discount__c,APTS_Bridge_Length__c,APTS_Bridge_Monthly_Charge__c,APTS_Bridge__c,APTS_Bundle__c,
                           APTS_Cancelled_Adjustment_Amount__c,APTS_Category_Name__c,APTS_Cat_L5__c,APTS_Combination_Key__c,APTS_Contract_End_Date__c,APTS_Contract_Line_Number__c,
                           APTS_Contract_Number__c,APTS_Contract_Start_Date__c,APTS_Contract_Term_Default__c,APTS_Contract_Term_Number__c,APTS_Contract_Term_Whole_Years__c,
                           APTS_Contract_Term__c,APTS_Corporate_Approval_Required__c,APTS_Corporate_Select_Option__c,APTS_Count_APP__c,APTS_Customer_Category__c,
                           APTS_Deal_Not_Complete__c,APTS_Deal_Number__c,APTS_Deal_Type__c,APTS_DefaultNetPrice__c,APTS_FL_Annual_Spend__c,APTS_FL_Current_price__c,
                           APTS_FL_Qty__c,APTS_FL_Renewal_List_Price__c,APTS_Format__c,APTS_FS_IM_Approval_Required__c,APTS_Government_Approval_Required__c,
                           APTS_Group_Primary_Material_Name__c,APTS_Group_Primary_Material__c,APTS_Group_Type__c,APTS_Group__c,APTS_Guidance_Approval_Required__c,
                           APTS_Has_Online_Assets__c,APTS_Info_PlanType__c,APTS_Keep_Terms__c,APTS_Legal_Contract_Clauses__c,APTS_Line_Level_Approval_Required__c,APTS_Margin_Type__c,
                           APTS_Max_Discount__c,APTS_Max_Effective_Discount__c,APTS_Media_High_Level_Code__c,APTS_Media_High_Level__c,APTS_New_Bridge_Discount__c,
                           APTS_Number_of_Attorneys_on_Acct__c,APTS_Number_of_Attorneys__c,APTS_PAGEO_Price__c,APTS_PPC_Approval_Required__c,APTS_PPC_Landing_Approval_Required__c,
                           APTS_PPC_Mgmt_Fee_Override__c,APTS_Price_Cap_Adjustment_Percentage__c,APTS_Print_Branding__c,APTS_Print_Product_Approval_Required__c,
                           APTS_Print_Purchase_Options__c,APTS_Print_Type__c,APTS_Product_Code__c,APTS_Product_Details__c,APTS_Product_Detail__c,APTS_Product_Family__c,
                           APTS_Product_Group_Primary_Material__c,APTS_Product_Name__c,APTS_Product_Or_Option_Name__c,APTS_Program_ID__c,APTS_Promo_Quote_Yearly_Value__c,
                           APTS_Proposal_Business_Unit__c,APTS_Proposal_Group__c,APTS_Purchase_Options__c,APTS_RepType_Approval_Required__c,APTS_Rep_Type_Description__c,
                           APTS_RLP_FLApproval_Required__c,APTS_SAP_Deal_Number__c,APTS_SAP_Deal_Primary_Material__c,APTS_SAP_Deal_Type__c,APTS_SAP_MLA_Agreement_Number__c,
                           APTS_Short_Term_Bridge_Approval__c,APTS_Small_Law_Approval_Required__c,APTS_SSD_ship_to__c,APTS_Subscription_Number__c,APTS_Todays_Date__c,
                           APTS_Totaling_Summary_Group__c,APTS_Total_Contract_Length__c,APTS_User_Lookup__c,APTS_WaivedProduct_Approval_Required__c,APTS_WestPack_Discount__c,
                           APTS_Yearly_Total__c,APTS_Years_2_3_Charges_Disc_Surc__c,APTS_Years_2_Plus_Adjustment__c,APTS_Years_2_Plus_Default__c,APTS_Years_3_5_Adjustment__c,
                           APTS_Years_3_5_Adj_Default__c,APTS_Years_6_10_Adjustment__c,APTS_Years_6_10_Adj_Default__c,APTS_Year_2_3_Price__c,APTS_Year_2_Adjustment__c,
                           APTS_Year_2_Adj_Default__c,APTS_YoY_Adjustment_Type__c,APTS_YOY_Least_Increase__c,APTS_Yr_1_Renewal_Adjustment__c,APTS_Yr_1_Renewal_Default__c,
                           Apttus_Config2__AddedByRuleInfo__c,Apttus_Config2__AddedBy__c,Apttus_Config2__AdHocGroupId__c,Apttus_Config2__AdjustedPrice__c,Apttus_Config2__AdjustmentAmount__c,
                           Apttus_Config2__AdjustmentType__c,Apttus_Config2__AllocateGroupAdjustment__c,Apttus_Config2__AllowableAction__c,Apttus_Config2__AllowManualAdjustment__c,
                           Apttus_Config2__AllowProration__c,Apttus_Config2__AllowRemoval__c,Apttus_Config2__AssetId__c,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__AssetQuantity__c,
                           Apttus_Config2__AttributeValueId__c,Apttus_Config2__AutoRenewalTerm__c,Apttus_Config2__AutoRenewalType__c,Apttus_Config2__AutoRenew__c,
                           Apttus_Config2__BaseCostOverride__c,Apttus_Config2__BaseCost__c,Apttus_Config2__BaseExtendedCost__c,Apttus_Config2__BaseExtendedPrice__c,Apttus_Config2__BasePriceMethod__c,Apttus_Config2__BasePriceOverride__c,
                           Apttus_Config2__BasePrice__c,Apttus_Config2__BaseProductId__c,Apttus_Config2__BillingFrequency__c,Apttus_Config2__BillingPreferenceId__c,Apttus_Config2__BillingRule__c,
                           Apttus_Config2__BillToAccountId__c,Apttus_Config2__ChargeGroupId__c,Apttus_Config2__ChargeType__c,Apttus_Config2__ClassificationHierarchyInfo__c,
                           Apttus_Config2__ClassificationHierarchy__c,Apttus_Config2__ClassificationId__c,Apttus_Config2__CollaborationParentLineNumber__c,Apttus_Config2__CollaborationRequestId__c,
                           Apttus_Config2__Comments__c,Apttus_Config2__CommitmentQuantity__c,Apttus_Config2__ConfigStatus__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConstraintCheckStatus__c,
                           Apttus_Config2__ContractNumbers__c,Apttus_Config2__CopySourceBundleNumber__c,Apttus_Config2__CopySourceLineNumber__c,Apttus_Config2__CopySourceNumber__c,Apttus_Config2__Cost__c,Apttus_Config2__CouponCode__c,
                           Apttus_Config2__Customizable__c,Apttus_Config2__DeltaPrice__c,Apttus_Config2__DeltaQuantity__c,Apttus_Config2__DerivedFromId__c,Apttus_Config2__Description__c,Apttus_Config2__EndDate__c,Apttus_Config2__ExtendedCost__c,
                           Apttus_Config2__ExtendedDescription__c,Apttus_Config2__ExtendedPrice__c,Apttus_Config2__ExtendedQuantity__c,Apttus_Config2__FlatOptionPrice__c,Apttus_Config2__Frequency__c,Apttus_Config2__GroupAdjustmentPercent__c,
                           Apttus_Config2__Guidance__c,Apttus_Config2__HasAttributes__c,Apttus_Config2__HasBaseProduct__c,Apttus_Config2__HasDefaults__c,Apttus_Config2__HasIncentives__c,Apttus_Config2__HasOptions__c,Apttus_Config2__HasTieredPrice__c,
                           Apttus_Config2__HideCopyAction__c,Apttus_Config2__HideInvoiceDisplay__c,Apttus_Config2__IncentiveAdjustmentAmount__c,Apttus_Config2__IncentiveBasePrice__c,Apttus_Config2__IncentiveCode__c,Apttus_Config2__IncentiveExtendedPrice__c,
                           Apttus_Config2__IncentiveId__c,Apttus_Config2__IncentiveType__c,Apttus_Config2__IsAssetPricing__c,Apttus_Config2__IsCustomPricing__c,Apttus_Config2__IsHidden__c,Apttus_Config2__IsOptional__c,Apttus_Config2__IsOptionRollupLine__c,
                           Apttus_Config2__IsPrimaryLine__c,Apttus_Config2__IsPrimaryRampLine__c,Apttus_Config2__IsQuantityModifiable__c,Apttus_Config2__IsReadOnly__c,Apttus_Config2__IsSellingTermReadOnly__c,
                           Apttus_Config2__IsUsageTierModifiable__c,Apttus_Config2__ItemSequence__c,Apttus_Config2__LineNumber__c,Apttus_Config2__LineSequence__c,Apttus_Config2__LineStatus__c,Apttus_Config2__LineType__c,
                           Apttus_Config2__ListPrice__c,Apttus_Config2__LocationId__c,Apttus_Config2__MaxPrice__c,Apttus_Config2__MaxUsageQuantity__c,Apttus_Config2__MinMaxPriceAppliesTo__c,Apttus_Config2__MinPrice__c,
                           Apttus_Config2__MinUsageQuantity__c,Apttus_Config2__NetAdjustmentPercent__c,Apttus_Config2__NetPrice__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__OptionCost__c,Apttus_Config2__OptionGroupLabel__c,Apttus_Config2__OptionId__c,
                           Apttus_Config2__OptionPrice__c,Apttus_Config2__OptionSequence__c,Apttus_Config2__ParentBundleNumber__c,Apttus_Config2__PaymentTermId__c,Apttus_Config2__PriceAdjustmentAmount__c,Apttus_Config2__PriceAdjustmentAppliesTo__c,
                           Apttus_Config2__PriceAdjustmentType__c,Apttus_Config2__PriceAdjustment__c,Apttus_Config2__PriceGroup__c,Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__PriceListId__c,Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMethod__c,
                           Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__PricingDate__c,Apttus_Config2__PricingGuidance__c,Apttus_Config2__PricingStatus__c,Apttus_Config2__PricingSteps__c,
                           Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Apttus_Config2__ProductVersion__c,Apttus_Config2__Quantity__c,Apttus_Config2__RelatedAdjustmentAmount__c,
                           Apttus_Config2__RelatedAdjustmentAppliesTo__c,Apttus_Config2__RelatedAdjustmentType__c,Apttus_Config2__RelatedItemId__c,Apttus_Config2__RelatedPercentAppliesTo__c,Apttus_Config2__RelatedPercent__c,
                           Apttus_Config2__RenewalAdjustmentAmount__c,Apttus_Config2__RenewalAdjustmentType__c,Apttus_Config2__RollupPriceMethod__c,Apttus_Config2__RollupPriceToBundle__c,Apttus_Config2__SellingFrequency__c,
                           Apttus_Config2__SellingTerm__c,Apttus_Config2__ServiceLocationId__c,Apttus_Config2__ShipToAccountId__c,Apttus_Config2__StartDate__c,Apttus_Config2__StatusDetails__c,Apttus_Config2__SummaryGroupId__c,
                           Apttus_Config2__SyncStatus__c,Apttus_Config2__Taxable__c,Apttus_Config2__TaxCodeId__c,Apttus_Config2__TaxInclusive__c,Apttus_Config2__Term__c,Apttus_Config2__TotalQuantity__c,Apttus_Config2__TransferPriceLineItemId__c,Apttus_Config2__UnitCostAdjustment__c,
                           Apttus_Config2__UnitPriceAdjustmentAuto__c,Apttus_Config2__UnitPriceAdjustmentManual__c,Apttus_Config2__Uom__c,Apttus_CQApprov__Approval_Status__c,Apttus_Filter_Brand__c,CreatedById,CreatedDate,CurrencyIsoCode,Customer_Pricing_Segment__c,Findlaw_LapseApproval_Required__c,FL_Years_2_3_Charges__c,Id,
                           Inventory_Applicable__c,Inventory_Available_Product_Detail__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,Name,Rollup_Base_Price__c,Rollup_Netprice__c,SAP_Account_Number__c,APTS_PPC_Rounded_Value__c,APTS_Renewal_Approval_Required__c,SystemModstamp,Apttus_Config2__ProductId__r.ProductCode,
                           APTS_Exposure_Pack_Disc__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_SSD_ship_to__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Align_Contract_End_Dates__c,Apttus_Config2__AttributeValueId__r.APTS_PPC_Mgmt_Fee_Override__c ,
                           Apttus_Config2__AttributeValueId__r.APTS_PPC_Type__c ,Apttus_Config2__AttributeValueId__r.APTS_PPC_Website_Selection__c  ,Apttus_Config2__AttributeValueId__r.APTS_PPC_Language_Selection__c  FROM Apttus_Config2__LineItem__c where ID IN :insertList];
       set<Id> findlawcartIdSet=new Set<Id>{prodConf.id};
       APTS_FL_LineItemTriggerHelper.populateAllApprovalRequiredCB(lalllins,findlawcartIdSet);
       APTS_FL_LineItemTriggerHelper.populateCategory(lalllins);
       test.stopTest();
       }
       
    }

}