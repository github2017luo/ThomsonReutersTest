@isTest
private with sharing class APTS_CustomSolutionctrlTest {
    
      @isTest static void testMethodOne(){
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         insert LCRMStrikeIronFlagINS1;
      
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = 'SLF 2-3';
        a.BillingPostalCode='1234';
        insert a;

        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BillToAccountId__c=a.id;
        prodConfig.Apttus_Config2__AccountId__c=a.id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.LCRM_Sub_Bu__c='FindLaw';
          prodObj.APTS_Attrbased_config__C =true;
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.ProductCode = '40586465';
          insert prodObj;  
      
          Product2 prodObjExpo = new Product2();
          prodObjExpo.Name = 'FINDLAW EXPOSURE PACK';
          prodObjExpo.LCRM_Sub_Bu__c='FindLaw';
          prodObjExpo.APTS_Attrbased_config__C =true;
          prodObjExpo.APTS_Media_Lower_Level_Code__c = 'H5';
          prodObjExpo.ProductCode = '40656701';
          prodObjExpo.APTS_CustomUI_Category__c = 'SpotLights';
          insert prodObjExpo; 
          
          Product2 prod1 = new Product2();
          prod1.Name = 'FINDLAW DIRECTORY TOPSPOT';
          prod1.LCRM_Sub_Bu__c='FindLaw';
          prod1.APTS_Attrbased_config__C =true;
          prod1.APTS_Media_Lower_Level_Code__c = 'H5';
          prod1.APTS_CustomUI_Category__c = 'TopSpots';
          prod1.ProductCode = '37005005';
          insert prod1;  
          
          Product2 prod2 = new Product2();
          prod2.Name = 'FINDLAW DIRECTORY SPOTLIGHT';
          prod2.LCRM_Sub_Bu__c='FindLaw';
          prod2.APTS_Attrbased_config__C =true;
          prod2.APTS_Media_Lower_Level_Code__c = 'H5';
          prod2.APTS_CustomUI_Category__c = 'SpotLights';
          prod2.ProductCode = '37005004';
          insert prod2; 
          
          Product2 prod3 = new Product2();
          prod3.Name = 'FINDLAW DIRECTORY COUNTY TOPSPOT';
          prod3.LCRM_Sub_Bu__c='FindLaw';
          prod3.APTS_Attrbased_config__C =true;
          prod3.APTS_Media_Lower_Level_Code__c = 'H5';
          prod3.APTS_CustomUI_Category__c = 'TopSpots';
          prod3.ProductCode = '37005072';
          insert prod3;  
          
          Product2 prod4 = new Product2();
          prod4.Name = 'FINDLAW DIRECTORY COUNTY SPOTLIGHT';
          prod4.LCRM_Sub_Bu__c='FindLaw';
          prod4.APTS_Attrbased_config__C =true;
          prod4.APTS_Media_Lower_Level_Code__c = 'H5';
          prod4.APTS_CustomUI_Category__c = 'TopSpots';
          prod4.ProductCode = '41680342';
          insert prod4; 
          
          Product2 prod5 = new Product2();
          prod5.Name = 'FINDLAW DIGITAL MARKETING ACCELERATOR';
          prod5.LCRM_Sub_Bu__c='FindLaw';
          prod5.APTS_Attrbased_config__C =true;
          prod5.APTS_Media_Lower_Level_Code__c = 'F8';
          prod5.APTS_CustomUI_Category__c = 'Miscellaneous';
          prod5.ProductCode = '41767150';
          insert prod5; 
          
          APTS_Attribute_Value__c attributevalueexpmisc1 = new APTS_Attribute_Value__c();
          attributevalueexpmisc1.Name='Ohio';
          attributevalueexpmisc1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexpmisc1.APTS_Product__c=prod5.id;
          attributevalueexpmisc1.IsMetro__c=false;
          Insert attributevalueexpmisc1;
          APTS_Attribute_Value__c attributevalueexpmisc2 = new APTS_Attribute_Value__c();
          attributevalueexpmisc2.Name='Franklin (Columbus, OH)';
          attributevalueexpmisc2.APTS_Attribute_Name__c='County';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexpmisc2.APTS_Product__c=prod5.id;
          attributevalueexpmisc2.IsMetro__c=false;
          Insert attributevalueexpmisc2;
          
          APTS_Attribute_Value__c attributevalueexp1 = new APTS_Attribute_Value__c();
          attributevalueexp1.Name='California';
          attributevalueexp1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp1.APTS_Product__c=prod1.id;
          attributevalueexp1.IsMetro__c=false;
          Insert attributevalueexp1;
          
          APTS_Attribute_Value__c attributevalueexp2 = new APTS_Attribute_Value__c();
          attributevalueexp2.Name='Insurance';
          attributevalueexp2.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp2.APTS_Product__c=prod1.id;
          attributevalueexp2.IsMetro__c=false;
          Insert attributevalueexp2;
          
          APTS_Attribute_Value__c attributevalueexp3 = new APTS_Attribute_Value__c();
          attributevalueexp3.Name='Insurance Law';
          attributevalueexp3.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp3.APTS_Product__c=prod1.id;
          attributevalueexp3.IsMetro__c=false;
          Insert attributevalueexp3;
          
          APTS_Attribute_Value__c attributevalueexp4 = new APTS_Attribute_Value__c();
          attributevalueexp4.Name='Los Angeles-Long Beach, CA';
          attributevalueexp4.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp4.APTS_Product__c=prod1.id;
          attributevalueexp4.IsMetro__c=false;
          Insert attributevalueexp4;
          
          APTS_Attribute_Value__c attributevalueexp5 = new APTS_Attribute_Value__c();
          attributevalueexp5.Name='San Diego, CA';
          attributevalueexp5.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp5.APTS_Product__c=prod1.id; 
          attributevalueexp5.IsMetro__c=false;
          Insert attributevalueexp5;
          
          APTS_Attribute_Value__c attributevalueexp6 = new APTS_Attribute_Value__c();
          attributevalueexp6.Name='San Jose, CA';
          attributevalueexp6.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp6.APTS_Product__c=prod1.id;
          attributevalueexp6.IsMetro__c=false;
          Insert attributevalueexp6;

          APTS_Attribute_Value__c attributevalueexp7 = new APTS_Attribute_Value__c();
          attributevalueexp7.Name='California';
          attributevalueexp7.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp7.APTS_Product__c=prod2.id;
          attributevalueexp7.IsMetro__c=false;
          Insert attributevalueexp7;
          
          APTS_Attribute_Value__c attributevalueexp8 = new APTS_Attribute_Value__c();
          attributevalueexp8.Name='Insurance';
          attributevalueexp8.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp8.APTS_Product__c=prod2.id;
          attributevalueexp8.IsMetro__c=false;
          Insert attributevalueexp8;
          
          APTS_Attribute_Value__c attributevalueexp9 = new APTS_Attribute_Value__c();
          attributevalueexp9.Name='Insurance Law';
          attributevalueexp9.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp9.APTS_Product__c=prod2.id;
          attributevalueexp9.IsMetro__c=false;
          Insert attributevalueexp9;
          
          APTS_Attribute_Value__c attributevalueexp10 = new APTS_Attribute_Value__c();
          attributevalueexp10.Name='Los Angeles-Long Beach, CA';
          attributevalueexp10.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp10.APTS_Product__c=prod2.id;
          attributevalueexp10.IsMetro__c=false;
          Insert attributevalueexp10;
          
          APTS_Attribute_Value__c attributevalueexp11 = new APTS_Attribute_Value__c();
          attributevalueexp11.Name='San Diego, CA';
          attributevalueexp11.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp11.APTS_Product__c=prod2.id;
           attributevalueexp11.IsMetro__c=false;
          Insert attributevalueexp11;
          
          APTS_Attribute_Value__c attributevalueexp12 = new APTS_Attribute_Value__c();
          attributevalueexp12.Name='San Jose, CA';
          attributevalueexp12.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp12.APTS_Product__c=prod2.id;
           attributevalueexp12.IsMetro__c=false;
          Insert attributevalueexp12;
          
          APTS_Attribute_Value__c attributevalueexp13 = new APTS_Attribute_Value__c();
          attributevalueexp13.Name='Massachusetts';
          attributevalueexp13.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp13.APTS_Product__c=prodObjExpo.id;
          attributevalueexp13.IsMetro__c=false;
          Insert attributevalueexp13;
          
           APTS_Attribute_Value__c attributevalueexp14 = new APTS_Attribute_Value__c();
          attributevalueexp14.Name='Crimes & Misdemeanors';
          attributevalueexp14.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp14.APTS_Product__c=prodObjExpo.id;
          attributevalueexp14.IsMetro__c=false;
          Insert attributevalueexp14;
          
           APTS_Attribute_Value__c attributevalueexp15 = new APTS_Attribute_Value__c();
          attributevalueexp15.Name='Criminal Law';
          attributevalueexp15.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp15.APTS_Product__c=prodObjExpo.id;
          attributevalueexp15.IsMetro__c=false;
          Insert attributevalueexp15;
          
           APTS_Attribute_Value__c attributevalueexp16 = new APTS_Attribute_Value__c();
          attributevalueexp16.Name='Massachusetts';
          attributevalueexp16.APTS_Attribute_Name__c='Statewide';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp16.APTS_Product__c=prodObjExpo.id;
          attributevalueexp16.IsMetro__c=false;
          Insert attributevalueexp16;

          APTS_Attribute_Value_Combination__c attr1= new APTS_Attribute_Value_Combination__c();
          attr1.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr1.APTS_Attribute_Value0__c= attributevalueexp1.id;
          attr1.APTS_Attribute_Value1__c= attributevalueexp4.id;
          attr1.APTS_Attribute_Value2__c= attributevalueexp2.id;
          attr1.APTS_Attribute_Value3__c= attributevalueexp3.id;
          attr1.APTS_Inventory_Available__c=10.0;
          attr1.APTS_Exposure_Pack_Disc__c = 1.5;
          attr1.APTS_Price__c = 100;
          attr1.APTS_Product__c=prod1.id;
          attr1.APTS_CustomUI_Category__c='SpotLights';
          attr1.APTS_Product_Name__c = 'FINDLAW DIRECTORY TOPSPOT';
          attr1.APTS_Product_Code__c = '37005005';
          insert attr1;
          
          List<APTS_Attribute_Value_Combination__c> attrList1=new List<APTS_Attribute_Value_Combination__c>();
          APTS_Attribute_Value_Combination__c attrcombmisc= new APTS_Attribute_Value_Combination__c();
          attrcombmisc.Name='Franklin-Tax Law';
          attrcombmisc.APTS_Attribute_Value0__c= attributevalueexpmisc1.id;
          attrcombmisc.APTS_Attribute_Value1__c= attributevalueexpmisc2.id;
          attrcombmisc.Attribute2_Name__c = 'Family';
          attrcombmisc.Attribute3_Name__c = 'Family Law';
          attrcombmisc.Attribute0_Name__c = 'Ohio';
          attrcombmisc.Attribute1_Name__c = 'Ohio';
          attrcombmisc.APTS_Product__c=prod5.id;
          attrcombmisc.APTS_CustomUI_Category__c='Miscellaneous';
          attrcombmisc.APTS_Product_Name__c = 'FINDLAW DIGITAL MARKETING ACCELERATOR';
          attrcombmisc.APTS_Product_Code__c = '41767150';
          
          APTS_Attribute_Value_Combination__c attr2= new APTS_Attribute_Value_Combination__c();
          attr2.Name='San Diego, CA-Insurance Law';
          attr2.APTS_Attribute_Value0__c=attributevalueexp1.id;
          attr2.APTS_Attribute_Value1__c=attributevalueexp5.id;
          attr2.APTS_Attribute_Value2__c=attributevalueexp2.id;
          attr2.APTS_Attribute_Value3__c=attributevalueexp3.id;
          attr2.APTS_Inventory_Available__c=0.0;
          attr2.APTS_Product__c=prod1.id;
          attr2.APTS_CustomUI_Category__c='TopSpots';
          attr2.APTS_Product_Name__c = 'FINDLAW DIRECTORY TOPSPOT';
          attr2.APTS_Product_Code__c = '37005005';
          insert attr2;

          APTS_Attribute_Value_Combination__c attr3= new APTS_Attribute_Value_Combination__c();
          attr3.Name='San Jose, CA-Insurance Law';
          attr3.APTS_Attribute_Value0__c=attributevalueexp1.id;
          attr3.APTS_Inventory_Available__c=5.0;
          attr3.APTS_Attribute_Value1__c=attributevalueexp6.id;
          attr3.APTS_Attribute_Value2__c=attributevalueexp2.id;
          attr3.APTS_Attribute_Value3__c=attributevalueexp3.id;
          attr3.APTS_Product__c=prod1.id;
          attr3.APTS_CustomUI_Category__c='TopSpots';
          attr3.APTS_Product_Name__c = 'FINDLAW DIRECTORY TOPSPOT';
          attr3.APTS_Product_Code__c = '37005005';
          insert attr3;

          APTS_Attribute_Value_Combination__c attr4= new APTS_Attribute_Value_Combination__c();
          attr4.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr4.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr4.APTS_Attribute_Value1__c=attributevalueexp10.id;
          attr4.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr4.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr4.APTS_Inventory_Available__c=97.0;
          attr4.APTS_Product__c=prod2.id;
          attr4.APTS_CustomUI_Category__c='SpotLights';
          attr4.APTS_Product_Name__c = 'FINDLAW DIRECTORY SPOTLIGHT';
          attr4.APTS_Product_Code__c = '37005004';
          insert attr4;
          
          APTS_Attribute_Value_Combination__c attr5= new APTS_Attribute_Value_Combination__c();
          attr5.Name='San Diego, CA-Insurance Law';
          attr5.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr5.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr5.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr5.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr5.APTS_Inventory_Available__c=98.0;
          attr5.APTS_Product__c=prod2.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          insert attr5;
          
          APTS_Attribute_Value_Combination__c attr6= new APTS_Attribute_Value_Combination__c();
          attr6.Name='San Diego, CA-Insurance Law';
          attr6.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr6.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr6.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr6.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr6.APTS_Inventory_Available__c=0;
          attr6.Attribute3_Name__c = 'Insurance Law';
          attr6.APTS_Product__c=prod1.id;
          attr6.APTS_CustomUI_Category__c='TopSpots';
          attr6.APTS_Product_Name__c = 'FINDLAW DIRECTORY TOPSPOT';
          attr6.APTS_Product_Code__c = '37005005';
          
          APTS_Attribute_Value_Combination__c attr7= new APTS_Attribute_Value_Combination__c();
          attr7.Name='San Diego, CA-Insurance Law';
          attr7.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr7.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr7.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr7.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr7.APTS_Inventory_Available__c=98.0;
          attr7.Attribute3_Name__c = 'Insurance Law';
          attr7.APTS_Product__c=prod1.id;
          attr7.APTS_CustomUI_Category__c='SpotLights';
          attr7.APTS_Product_Name__c = 'FINDLAW DIRECTORY SPOTLIGHT';
          attr7.APTS_Product_Code__c = '37005005';
          
          APTS_Attribute_Value_Combination__c attr8= new APTS_Attribute_Value_Combination__c();
          attr8.Name='San Diego, CA-Insurance Law';
          attr8.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr8.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr8.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr8.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr8.APTS_Inventory_Available__c=98.0;
          attr8.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          //insert attr8;
          
          APTS_Attribute_Value_Combination__c attr9= new APTS_Attribute_Value_Combination__c();
          attr9.Name='San Diego, CA-Insurance Law';
          attr9.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr9.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr9.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr9.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr9.Attribute3_Name__c = attributevalueexp9.name;
          attr9.APTS_Inventory_Available__c=98.0;
          attr9.APTS_Product__c=prod1.id;
          attr9.APTS_CustomUI_Category__c='SpotLights';
          attr9.APTS_Product_Name__c = 'FINDLAW DIRECTORY TOPSPOT';
          attr9.APTS_Product_Code__c = '37005005';
         
          APTS_Attribute_Value_Combination__c attributecomExpo1 = new APTS_Attribute_Value_Combination__c();
          attributecomExpo1.Name = 'Massachusetts-Criminal Law';
          attributecomExpo1.APTS_Product__c = prodObjExpo.id;
          attributecomExpo1.APTS_Attribute_Value0__c=attributevalueexp13.id;
          attributecomExpo1.APTS_Attribute_Value1__c=attributevalueexp14.id;
          attributecomExpo1.APTS_Attribute_Value2__c=attributevalueexp15.id;
          attributecomExpo1.APTS_Attribute_Value3__c=attributevalueexp16.id;
          attributecomExpo1.Attribute3_Name__c = 'Massachusetts';
          attributecomExpo1.APTS_Inventory_Available__c=98.0;
          attributecomExpo1.APTS_CustomUI_Category__c='SpotLights';
          attributecomExpo1.APTS_Product_Name__c = 'FINDLAW EXPOSURE PACK';
          attributecomExpo1.APTS_Product_Code__c = '40656701';
            
          attrList1.add(attrcombmisc);
          attrList1.add(attr6);
          attrList1.add(attr7);
          attrList1.add(attr9);
          attrList1.add(attributecomExpo1);
          insert attrList1;
          
          List<String> keys = new List<String>{};
          List<Double> values = new List<Double>{};
          Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
          
          for(APTS_Attribute_Value_Combination__c objAttr : attrList1)
          {
              keys.add(objAttr.Id);
              values.add(10);
              Cache.session.put('local.FindLawpaGeo.requestDO'+objAttr.Id, request);
          }
          
           Apttus_Config2__ClassificationName__c className= new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__Active__c=true;
        className.Apttus_Config2__HierarchyLabel__c='ExposureLabel';
        className.Apttus_Config2__Type__c='Option Group';
        className.Name='ExposureLabelName';
        insert className;
         
         Apttus_Config2__ClassificationHierarchy__c optionclass= new Apttus_Config2__ClassificationHierarchy__c();
        optionclass.Apttus_Config2__DefaultSearchCategory__c=false;
        optionclass.Apttus_Config2__ExpandedByDefault__c=false;
        optionclass.Apttus_Config2__HideAllSearchFilters__c=false;
        optionclass.Apttus_Config2__IncludeInTotalsView__c=true;
        optionclass.Apttus_Config2__IsHidden__c=false;
        optionclass.Apttus_Config2__IsPicklist__c=false;
        optionclass.Apttus_Config2__Label__c='ExposureLabelName';
        optionclass.Apttus_Config2__Modifiable__c=true;
        optionclass.DC_Is_Title_Visible__c=false;
        optionclass.Apttus_Config2__HierarchyId__c=className.id;
        optionclass.Name='ExposureLabelName';
        insert optionclass;
        
        Apttus_Config2__ProductOptionGroup__c optiongroup1=new Apttus_Config2__ProductOptionGroup__c();
        optiongroup1.Apttus_Config2__IsHidden__c=false;
        optiongroup1.Apttus_Config2__IsLeaf__c=true;
        optiongroup1.Apttus_Config2__IsPicklist__c=false;
        optiongroup1.Apttus_Config2__Sequence__c=0;
        optiongroup1.Apttus_Config2__OptionGroupId__c=optionclass.id;
        optiongroup1.Apttus_Config2__ProductId__c=prodObjExpo.id;
        optiongroup1.Apttus_Config2__RootOptionGroupId__c=optionclass.id;
        insert optiongroup1;
        
         Apttus_Config2__ProductOptionComponent__c option1 = new Apttus_Config2__ProductOptionComponent__c();
            option1.Apttus_Config2__AllowCloning__c= false;
            option1.Apttus_Config2__AutoUpdateQuantity__c=false;
            option1.Apttus_Config2__Default__c=false;
            option1.Apttus_Config2__Modifiable__c=false;
            option1.Apttus_Config2__Sequence__c=0;
            option1.Apttus_Config2__Required__c=false;
            option1.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option1.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option1.Apttus_Config2__ComponentProductId__c=prod1.id;
         insert option1;
         
         Apttus_Config2__ProductOptionComponent__c option2 = new Apttus_Config2__ProductOptionComponent__c();
            option2.Apttus_Config2__AllowCloning__c= false;
            option2.Apttus_Config2__AutoUpdateQuantity__c=false;
            option2.Apttus_Config2__Default__c=false;
            option2.Apttus_Config2__Modifiable__c=false;
            option2.Apttus_Config2__Sequence__c=0;
            option2.Apttus_Config2__Required__c=false;
            option2.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option2.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option2.Apttus_Config2__ComponentProductId__c=prod2.id;
         insert option2;
         
         Apttus_Config2__ProductOptionComponent__c option3 = new Apttus_Config2__ProductOptionComponent__c();
            option3.Apttus_Config2__AllowCloning__c= false;
            option3.Apttus_Config2__AutoUpdateQuantity__c=false;
            option3.Apttus_Config2__Default__c=false;
            option3.Apttus_Config2__Modifiable__c=false;
            option3.Apttus_Config2__Sequence__c=0;
            option3.Apttus_Config2__Required__c=false;
            option3.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option3.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option3.Apttus_Config2__ComponentProductId__c=prod3.id;
         insert option3;
         
          Apttus_Config2__ProductOptionComponent__c option4 = new Apttus_Config2__ProductOptionComponent__c();
            option4.Apttus_Config2__AllowCloning__c= false;
            option4.Apttus_Config2__AutoUpdateQuantity__c=false;
            option4.Apttus_Config2__Default__c=false;
            option4.Apttus_Config2__Modifiable__c=false;
            option4.Apttus_Config2__Sequence__c=0;
            option4.Apttus_Config2__Required__c=false;
            option4.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option4.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option4.Apttus_Config2__ComponentProductId__c=prod4.id;
         insert option4;
         
         List<Apttus_Config2__ProductOptionComponent__c> listoptions= new List<Apttus_Config2__ProductOptionComponent__c> ();
         listoptions.add(option1);
         listoptions.add(option2);
         listoptions.add(option3);
         listoptions.add(option4);

        Apttus_Config2__ProductHierarchyView__c prodHierView = new Apttus_Config2__ProductHierarchyView__c();
        prodHierView.Apttus_Config2__HierarchyId__c=className.id;
        prodHierView.Apttus_Config2__ChildLevel__c=0;
        prodHierView.Apttus_Config2__ParentLevel__c=1;
        insert prodHierView;
            
          APTS_FindLaw_GEO_Defualts__c geoDefaults = new APTS_FindLaw_GEO_Defualts__c();
          geoDefaults.Name='1234';
          insert geoDefaults;
          
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
          
          APTS_Attribute_Value_Combination__c attributecombination2 = new APTS_Attribute_Value_Combination__c();
          attributecombination2.Name='Marshall-General';
          attributecombination2.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination2.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination2.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination2.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination2.APTS_Product__c=prodObj.id;
          insert attributecombination2;
          
          //added by Gowthami
          APTS_Attribute_Value_Combination__c attributecomExpo = new APTS_Attribute_Value_Combination__c();
          attributecomExpo.Name = 'Ohio-Bankruptcy Law';
          attributecomExpo.APTS_Product__c = prodObjExpo.id;
          insert attributecomExpo;
          
          List<String> listattrcomb = new List<String>();
          listattrcomb.add(attributecombination.Id);
          listattrcomb.add(attributecombination2.Id);
          
          List<Apttus_Config2__LineItem__c> listofli = new List<Apttus_Config2__LineItem__c>();
          Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prod1.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attr1.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20);
            
            Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prod2.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attr4.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20);
            
            Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prodObjExpo.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attributecomExpo1.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20); 
            listofli.add(lineItem1);
            listofli.add(lineItem2);
            listofli.add(lineItem3);

          Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(name='ali_test', Apttus_Config2__AccountId__c=a.id, CurrencyIsoCode='USD', Apttus_Config2__AssetStatus__c='Activated', Apttus_Config2__ProductId__c=prod5.id, Apttus_Config2__Quantity__c=1.256, Apttus_Config2__IsInactive__c = False, Apttus_Config2__SellingTerm__c=6.39);
          ali.Apttus_QPConfig__ProposalId__c=proposal.Id;
          
          Apttus_Config2__AssetLineItem__c ali2 = new Apttus_Config2__AssetLineItem__c(name='ali_test', APTS_Combination_Key__c=attr6.Id, Apttus_Config2__AccountId__c=a.id, CurrencyIsoCode='USD', Apttus_Config2__AssetStatus__c='Activated', Apttus_Config2__ProductId__c=prod1.id, Apttus_Config2__Quantity__c=1.256, Apttus_Config2__IsInactive__c = False, Apttus_Config2__SellingTerm__c=6.39);
          ali2.Apttus_QPConfig__ProposalId__c=proposal.Id;
          //insert ali;
            List<Apttus_Config2__AssetLineItem__c> listOfAssetLines = new List<Apttus_Config2__AssetLineItem__c>();
            listOfAssetLines.add(ali);
            listOfAssetLines.add(ali2);
          insert listOfAssetLines;
           
          String attrcomExpo= attributecomExpo.id;
          String attrcomExpo1=attributecomExpo1.id;
          List<String> attrExpoList=new List<String>();
          attrExpoList.add(attrcomExpo);
          attrExpoList.add(attrcomExpo1);
          List<String> list1 = new List<String>();
          List<String> list2 = new List<String>();
          List<String> list3 = new List<String>();
          List<String> list4 = new List<String>();
          List<String> list5 = new List<String>();
          List<String> list6 = new List<String>();
          List<String> list7 = new List<String>();
          List<String> list8 = new List<String>();
          List<String> list9 = new List<String>();
          List<String> list10 = new List<String>();
          List<String> list11 = new List<String>();
          List<String> list12 = new List<String>();
          List<String> list13 = new List<String>();
          List<String> list14 = new List<String>();
          List<String> list15 = new List<String>();
          List<String> list16 = new List<String>();
          List<String> list17 = new List<String>();
          list1.add(attributevalue1.Id);
          list2.add(attributevalue2.Id);
          list3.add(attributevalue3.Id);
          list4.add(attributevalue4.Name);
          list5.add('');
          list6.add('');
          list7.add('');
          list8.add(attributevalueexp1.Name);
          list9.add(attributevalueexp2.Name);
          list10.add(attributevalueexp3.Name);
          list11.add('');
          list12.add('');
          list13.add(attributevalue4.Name);
          
          system.debug('inside if'+cartID);
          List<String> cartIdList=new List<String>();
          cartIdList.add(cartID);
          PageReference myVfPage = Page.APTS_CustomSolutionPage;
          Test.setCurrentPage(myVfPage);
          ApexPages.currentPage().getParameters().put('id', cartID);
          ApexPages.currentPage().getParameters().put('configRequestId', cartID);
          ApexPages.currentPage().getParameters().put('businessObjectId', cartID);
          APTS_CustomSolutionctrl customclass = new APTS_CustomSolutionctrl();
          customclass.returnToCart();
          customclass.goToCart();
          customclass.exit();
          customclass.cancel2();
          customclass.cancel();
          
          String s1='No';
          String s2='Yes';
          Decimal discount=1.0;
          List<String> stringList = new  List<String> ();
          List<String> stringList1 = new  List<String> ();
          stringList.add(s1);
          stringList1.add(s2);
          String atrr = 'Insurance Law';
          String attrValue = 'Criminal Law';
          List<String> attrList3 = new List<String>();
          attrList3.add(atrr);
          attrList3.add(attrValue);
          string parentattrval='123';
          APTS_CustomSolutionctrl.getProducts();
          APTS_CustomSolutionctrl.getDefaultAttribute(cartID);
          APTS_CustomSolutionctrl.getGeoDefault(geoDefaults.Name);
          APTS_CustomSolutionctrl.getGeoDefault('1111');
          APTS_CustomSolutionctrl.getattributeSetting(prodObj.id);
          APTS_CustomSolutionctrl.getattributeValues(prodObj.id,attributesetting.Name,null);
          APTS_CustomSolutionctrl.getattributeValues(prodObj.id,attributesetting.Name,attributesetting.id);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list6,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list7,list11,list13,list12);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list7,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list6,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list5);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list6,list5);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObjExpo.id,prodObjExpo.ProductCode,list8,list9,list10,stringList);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prod5.id,prod5.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.AttrValCombinationUI wrapMethod=new APTS_CustomSolutionctrl.AttrValCombinationUI();
          wrapMethod.attributeValueInstance=attributecomExpo;
          wrapMethod.isInstalled=true;
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObjExpo.id,prodObjExpo.ProductCode,list8,list9,list7,stringList);
          system.debug('inside if'+cartID);
          
          Test.startTest();
          
          String jsonWrapper = '{"productId":"'+prodObj.id+'","combinationKey":"'+attributecombination.Id+'","cartId":"'+cartID+'","attorney":"2","apiName":"'+attributesetting.APTS_API_Method_Name__c+'"}';
          List<String> listStr = new List<String>();
          listStr.add(jsonWrapper);
//          APTS_CustomSolutionctrl.addToCart(prodObj.id,listattrcomb,cartID,2,attributesetting.APTS_API_Method_Name__c);
          APTS_CustomSolutionctrl.addToCart(listStr);
          APTS_CustomSolutionctrl.getPriceForExposurePack1(prodObjExpo.id,prodObjExpo.ProductCode,list1,list2,list3);
          APTS_CustomSolutionctrl.getPriceForExposurePack2(list8,list9,list10);
          APTS_CustomSolutionctrl.getPriceForExposurePack2(list8,list9,list10);
          APTS_CustomSolutionctrl.getPriceForExposurePack3(new List<APTS_Attribute_Value_Combination__c>(), stringList,list8,list9,list10,attr1);
          APTS_CustomSolutionctrl.getPriceForExposurePack3(attrList1, stringList1,list8,list9,list10,attr4);
          APTS_CustomSolutionctrl.addingProductsToCart(attrList1, 'Yes');
          customclass.getAssetLines('Test');
          Cache.session.put('local.FindLawpaGeo.listOfAttributeValueCombs', attrList1);
          Cache.Session.put('local.FindLawpaGeo.AssetLineItems', listOfAssetLines);
          
          APTS_CustomSolutionctrl.processAttbValueCombs('Yes', true, priceList.Id, cartId, keys, values);
          APTS_CustomSolutionctrl.processAttbValueCombs('No', true, priceList.Id, cartId, keys, values);
          
          APTS_CustomSolutionctrl.addToBundle(attr6.Id);
          APTS_CustomSolutionctrl.getToCart(cartID);
          Test.stopTest();
        } 
       
       @isTest static void testMethodTwo(){
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         insert LCRMStrikeIronFlagINS1;
      
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = 'SLF 2-3';
        a.BillingPostalCode='1234';
        insert a;

        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BillToAccountId__c=a.id;
        prodConfig.Apttus_Config2__AccountId__c=a.id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.LCRM_Sub_Bu__c='FindLaw';
          prodObj.APTS_Attrbased_config__C =true;
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.ProductCode = '40586465';
          insert prodObj;  
      
          Product2 prodObjExpo = new Product2();
          prodObjExpo.Name = 'FINDLAW EXPOSURE PACK';
          prodObjExpo.LCRM_Sub_Bu__c='FindLaw';
          prodObjExpo.APTS_Attrbased_config__C =true;
          prodObjExpo.APTS_Media_Lower_Level_Code__c = 'H5';
          prodObjExpo.ProductCode = '40656701';
          insert prodObjExpo; 
          
          Product2 prod1 = new Product2();
          prod1.Name = 'FINDLAW DIRECTORY TOPSPOT';
          prod1.LCRM_Sub_Bu__c='FindLaw';
          prod1.APTS_Attrbased_config__C =true;
          prod1.APTS_Media_Lower_Level_Code__c = 'H5';
          prod1.APTS_CustomUI_Category__c = 'TopSpots';
          prod1.ProductCode = '37005005';
          insert prod1;  
          
          Product2 prod2 = new Product2();
          prod2.Name = 'FINDLAW DIRECTORY SPOTLIGHT';
          prod2.LCRM_Sub_Bu__c='FindLaw';
          prod2.APTS_Attrbased_config__C =true;
          prod2.APTS_Media_Lower_Level_Code__c = 'H5';
          prod2.APTS_CustomUI_Category__c = 'SpotLights';
          prod2.ProductCode = '37005004';
          insert prod2; 
          
          Product2 prod3 = new Product2();
          prod3.Name = 'FINDLAW DIRECTORY COUNTY TOPSPOT';
          prod3.LCRM_Sub_Bu__c='FindLaw';
          prod3.APTS_Attrbased_config__C =true;
          prod3.APTS_Media_Lower_Level_Code__c = 'H5';
          prod3.APTS_CustomUI_Category__c = 'TopSpots';
          prod3.ProductCode = '37005072';
          insert prod3;  
          
          Product2 prod4 = new Product2();
          prod4.Name = 'FINDLAW DIRECTORY COUNTY SPOTLIGHT';
          prod4.LCRM_Sub_Bu__c='FindLaw';
          prod4.APTS_Attrbased_config__C =true;
          prod4.APTS_Media_Lower_Level_Code__c = 'H5';
          prod4.APTS_CustomUI_Category__c = 'TopSpots';
          prod4.ProductCode = '41680342';
          insert prod4; 
          
          Product2 prod5 = new Product2();
          prod5.Name = 'FINDLAW DIGITAL MARKETING ACCELERATOR';
          prod5.LCRM_Sub_Bu__c='FindLaw';
          prod5.APTS_Attrbased_config__C =true;
          prod5.APTS_Media_Lower_Level_Code__c = 'F8';
          prod5.APTS_CustomUI_Category__c = 'Miscellaneous';
          prod5.ProductCode = '41767150';
          insert prod5; 
          
          APTS_Attribute_Value__c attributevalueexpmisc1 = new APTS_Attribute_Value__c();
          attributevalueexpmisc1.Name='Ohio';
          attributevalueexpmisc1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexpmisc1.APTS_Product__c=prod5.id;
          attributevalueexpmisc1.IsMetro__c=false;
          Insert attributevalueexpmisc1;
          APTS_Attribute_Value__c attributevalueexpmisc2 = new APTS_Attribute_Value__c();
          attributevalueexpmisc2.Name='Franklin (Columbus, OH)';
          attributevalueexpmisc2.APTS_Attribute_Name__c='County';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexpmisc2.APTS_Product__c=prod5.id;
          attributevalueexpmisc2.IsMetro__c=false;
          Insert attributevalueexpmisc2;
          
          APTS_Attribute_Value__c attributevalueexp1 = new APTS_Attribute_Value__c();
          attributevalueexp1.Name='California';
          attributevalueexp1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp1.APTS_Product__c=prod1.id;
          attributevalueexp1.IsMetro__c=false;
          Insert attributevalueexp1;
          
          APTS_Attribute_Value__c attributevalueexp2 = new APTS_Attribute_Value__c();
          attributevalueexp2.Name='Insurance';
          attributevalueexp2.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp2.APTS_Product__c=prod1.id;
          attributevalueexp2.IsMetro__c=false;
          Insert attributevalueexp2;
          
          APTS_Attribute_Value__c attributevalueexp3 = new APTS_Attribute_Value__c();
          attributevalueexp3.Name='Insurance Law';
          attributevalueexp3.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp3.APTS_Product__c=prod1.id;
          attributevalueexp3.IsMetro__c=false;
          Insert attributevalueexp3;
          
          APTS_Attribute_Value__c attributevalueexp4 = new APTS_Attribute_Value__c();
          attributevalueexp4.Name='Los Angeles-Long Beach, CA';
          attributevalueexp4.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp4.APTS_Product__c=prod1.id;
          attributevalueexp4.IsMetro__c=false;
          Insert attributevalueexp4;
          
          APTS_Attribute_Value__c attributevalueexp5 = new APTS_Attribute_Value__c();
          attributevalueexp5.Name='San Diego, CA';
          attributevalueexp5.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp5.APTS_Product__c=prod1.id; 
          attributevalueexp5.IsMetro__c=false;
          Insert attributevalueexp5;
          
          APTS_Attribute_Value__c attributevalueexp6 = new APTS_Attribute_Value__c();
          attributevalueexp6.Name='San Jose, CA';
          attributevalueexp6.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp6.APTS_Product__c=prod1.id;
          attributevalueexp6.IsMetro__c=false;
          Insert attributevalueexp6;

          APTS_Attribute_Value__c attributevalueexp7 = new APTS_Attribute_Value__c();
          attributevalueexp7.Name='California';
          attributevalueexp7.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp7.APTS_Product__c=prod2.id;
          attributevalueexp7.IsMetro__c=false;
          Insert attributevalueexp7;
          
          APTS_Attribute_Value__c attributevalueexp8 = new APTS_Attribute_Value__c();
          attributevalueexp8.Name='Insurance';
          attributevalueexp8.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp8.APTS_Product__c=prod2.id;
          attributevalueexp8.IsMetro__c=false;
          Insert attributevalueexp8;
          
          APTS_Attribute_Value__c attributevalueexp9 = new APTS_Attribute_Value__c();
          attributevalueexp9.Name='Insurance Law';
          attributevalueexp9.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp9.APTS_Product__c=prod2.id;
          attributevalueexp9.IsMetro__c=false;
          Insert attributevalueexp9;
          
          APTS_Attribute_Value__c attributevalueexp10 = new APTS_Attribute_Value__c();
          attributevalueexp10.Name='Los Angeles-Long Beach, CA';
          attributevalueexp10.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp10.APTS_Product__c=prod2.id;
          attributevalueexp10.IsMetro__c=false;
          Insert attributevalueexp10;
          
          APTS_Attribute_Value__c attributevalueexp11 = new APTS_Attribute_Value__c();
          attributevalueexp11.Name='San Diego, CA';
          attributevalueexp11.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp11.APTS_Product__c=prod2.id;
           attributevalueexp11.IsMetro__c=false;
          Insert attributevalueexp11;
          
          APTS_Attribute_Value__c attributevalueexp12 = new APTS_Attribute_Value__c();
          attributevalueexp12.Name='San Jose, CA';
          attributevalueexp12.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp12.APTS_Product__c=prod2.id;
           attributevalueexp12.IsMetro__c=false;
          Insert attributevalueexp12;
          
          APTS_Attribute_Value__c attributevalueexp13 = new APTS_Attribute_Value__c();
          attributevalueexp13.Name='Massachusetts';
          attributevalueexp13.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp13.APTS_Product__c=prodObjExpo.id;
          attributevalueexp13.IsMetro__c=false;
          Insert attributevalueexp13;
          
           APTS_Attribute_Value__c attributevalueexp14 = new APTS_Attribute_Value__c();
          attributevalueexp14.Name='Crimes & Misdemeanors';
          attributevalueexp14.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp14.APTS_Product__c=prodObjExpo.id;
          attributevalueexp14.IsMetro__c=false;
          Insert attributevalueexp14;
          
           APTS_Attribute_Value__c attributevalueexp15 = new APTS_Attribute_Value__c();
          attributevalueexp15.Name='Criminal Law';
          attributevalueexp15.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp15.APTS_Product__c=prodObjExpo.id;
          attributevalueexp15.IsMetro__c=false;
          Insert attributevalueexp15;
          
           APTS_Attribute_Value__c attributevalueexp16 = new APTS_Attribute_Value__c();
          attributevalueexp16.Name='Massachusetts';
          attributevalueexp16.APTS_Attribute_Name__c='Statewide';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp16.APTS_Product__c=prodObjExpo.id;
          attributevalueexp16.IsMetro__c=false;
          Insert attributevalueexp16;

          APTS_Attribute_Value_Combination__c attr1= new APTS_Attribute_Value_Combination__c();
          attr1.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr1.APTS_Attribute_Value0__c= attributevalueexp1.id;
          attr1.APTS_Attribute_Value1__c= attributevalueexp4.id;
          attr1.APTS_Attribute_Value2__c= attributevalueexp2.id;
          attr1.APTS_Attribute_Value3__c= attributevalueexp3.id;
          attr1.APTS_Inventory_Available__c=0.0;
          attr1.APTS_Product__c=prod1.id;
         // attr1.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attr1;
          
          List<APTS_Attribute_Value_Combination__c> attrList1=new List<APTS_Attribute_Value_Combination__c>();
          APTS_Attribute_Value_Combination__c attrcombmisc= new APTS_Attribute_Value_Combination__c();
          attrcombmisc.Name='Franklin-Tax Law';
          attrcombmisc.APTS_Attribute_Value0__c= attributevalueexpmisc1.id;
          attrcombmisc.APTS_Attribute_Value1__c= attributevalueexpmisc2.id;
         //attrcombmisc.APTS_Inventory_Available__c=0.0;
          attrcombmisc.APTS_Product__c=prod5.id;
         // attr1.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attrcombmisc;
          
          APTS_Attribute_Value_Combination__c attr2= new APTS_Attribute_Value_Combination__c();
          attr2.Name='San Diego, CA-Insurance Law';
          attr2.APTS_Attribute_Value0__c=attributevalueexp1.id;
          attr2.APTS_Attribute_Value1__c=attributevalueexp5.id;
          attr2.APTS_Attribute_Value2__c=attributevalueexp2.id;
          attr2.APTS_Attribute_Value3__c=attributevalueexp3.id;
          attr2.APTS_Inventory_Available__c=0.0;
          attr2.APTS_Product__c=prod1.id;
         // attr2.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attr2;
          
           APTS_Attribute_Value_Combination__c attr3= new APTS_Attribute_Value_Combination__c();
          attr3.Name='San Jose, CA-Insurance Law';
          attr3.APTS_Attribute_Value0__c=attributevalueexp1.id;
          attr3.APTS_Inventory_Available__c=5.0;
          attr3.APTS_Attribute_Value1__c=attributevalueexp6.id;
          attr3.APTS_Attribute_Value2__c=attributevalueexp2.id;
          attr3.APTS_Attribute_Value3__c=attributevalueexp3.id;
          attr3.APTS_Product__c=prod1.id;
          //attr3.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attr3;
          
           APTS_Attribute_Value_Combination__c attr4= new APTS_Attribute_Value_Combination__c();
          attr4.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr4.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr4.APTS_Attribute_Value1__c=attributevalueexp10.id;
          attr4.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr4.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr4.APTS_Inventory_Available__c=97.0;
          attr4.APTS_Product__c=prod2.id;
          //attr4.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          insert attr4;
          
          APTS_Attribute_Value_Combination__c attr5= new APTS_Attribute_Value_Combination__c();
          attr5.Name='San Diego, CA-Insurance Law';
          attr5.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr5.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr5.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr5.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr5.APTS_Inventory_Available__c=98.0;
          attr5.APTS_Product__c=prod2.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          insert attr5;
          
          APTS_Attribute_Value_Combination__c attr6= new APTS_Attribute_Value_Combination__c();
          attr6.Name='San Diego, CA-Insurance Law';
          attr6.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr6.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr6.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr6.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr6.APTS_Inventory_Available__c=98.0;
          attr6.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          //insert attr6;
          
          APTS_Attribute_Value_Combination__c attr7= new APTS_Attribute_Value_Combination__c();
          attr7.Name='San Diego, CA-Insurance Law';
          attr7.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr7.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr7.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr7.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr7.APTS_Inventory_Available__c=98.0;
          attr7.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
         // insert attr7;
          
          APTS_Attribute_Value_Combination__c attr8= new APTS_Attribute_Value_Combination__c();
          attr8.Name='San Diego, CA-Insurance Law';
          attr8.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr8.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr8.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr8.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr8.APTS_Inventory_Available__c=98.0;
          attr8.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          //insert attr8;
          
          APTS_Attribute_Value_Combination__c attr9= new APTS_Attribute_Value_Combination__c();
          attr9.Name='San Diego, CA-Insurance Law';
          attr9.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr9.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr9.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr9.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr9.APTS_Inventory_Available__c=98.0;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
         // insert attr9;
         
          APTS_Attribute_Value_Combination__c attributecomExpo1 = new APTS_Attribute_Value_Combination__c();
          attributecomExpo1.Name = 'Massachusetts-Criminal Law';
          attributecomExpo1.APTS_Product__c = prodObjExpo.id;
          attributecomExpo1.APTS_Attribute_Value0__c=attributevalueexp13.id;
          attributecomExpo1.APTS_Attribute_Value1__c=attributevalueexp14.id;
          attributecomExpo1.APTS_Attribute_Value2__c=attributevalueexp15.id;
          attributecomExpo1.APTS_Attribute_Value3__c=attributevalueexp16.id;
          attributecomExpo1.APTS_Inventory_Available__c=98.0;
    
          attrList1.add(attr6);
          attrList1.add(attr7);
          attrList1.add(attr9);
          attrList1.add(attributecomExpo1);
          insert attrList1;
          
           Apttus_Config2__ClassificationName__c className= new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__Active__c=true;
        className.Apttus_Config2__HierarchyLabel__c='ExposureLabel';
        className.Apttus_Config2__Type__c='Option Group';
        className.Name='ExposureLabelName';
        insert className;
         
         Apttus_Config2__ClassificationHierarchy__c optionclass= new Apttus_Config2__ClassificationHierarchy__c();
        optionclass.Apttus_Config2__DefaultSearchCategory__c=false;
        optionclass.Apttus_Config2__ExpandedByDefault__c=false;
        optionclass.Apttus_Config2__HideAllSearchFilters__c=false;
        optionclass.Apttus_Config2__IncludeInTotalsView__c=true;
        optionclass.Apttus_Config2__IsHidden__c=false;
        optionclass.Apttus_Config2__IsPicklist__c=false;
        optionclass.Apttus_Config2__Label__c='ExposureLabelName';
        optionclass.Apttus_Config2__Modifiable__c=true;
        optionclass.DC_Is_Title_Visible__c=false;
        optionclass.Apttus_Config2__HierarchyId__c=className.id;
        optionclass.Name='ExposureLabelName';
        insert optionclass;
        
        Apttus_Config2__ProductOptionGroup__c optiongroup1=new Apttus_Config2__ProductOptionGroup__c();
        optiongroup1.Apttus_Config2__IsHidden__c=false;
        optiongroup1.Apttus_Config2__IsLeaf__c=true;
        optiongroup1.Apttus_Config2__IsPicklist__c=false;
        optiongroup1.Apttus_Config2__Sequence__c=0;
        optiongroup1.Apttus_Config2__OptionGroupId__c=optionclass.id;
        optiongroup1.Apttus_Config2__ProductId__c=prodObjExpo.id;
        optiongroup1.Apttus_Config2__RootOptionGroupId__c=optionclass.id;
        insert optiongroup1;
        
         Apttus_Config2__ProductOptionComponent__c option1 = new Apttus_Config2__ProductOptionComponent__c();
            option1.Apttus_Config2__AllowCloning__c= false;
            option1.Apttus_Config2__AutoUpdateQuantity__c=false;
            option1.Apttus_Config2__Default__c=false;
            option1.Apttus_Config2__Modifiable__c=false;
            option1.Apttus_Config2__Sequence__c=0;
            option1.Apttus_Config2__Required__c=false;
            option1.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option1.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option1.Apttus_Config2__ComponentProductId__c=prod1.id;
         insert option1;
         
         Apttus_Config2__ProductOptionComponent__c option2 = new Apttus_Config2__ProductOptionComponent__c();
            option2.Apttus_Config2__AllowCloning__c= false;
            option2.Apttus_Config2__AutoUpdateQuantity__c=false;
            option2.Apttus_Config2__Default__c=false;
            option2.Apttus_Config2__Modifiable__c=false;
            option2.Apttus_Config2__Sequence__c=0;
            option2.Apttus_Config2__Required__c=false;
            option2.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option2.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option2.Apttus_Config2__ComponentProductId__c=prod2.id;
         insert option2;
         
         Apttus_Config2__ProductOptionComponent__c option3 = new Apttus_Config2__ProductOptionComponent__c();
            option3.Apttus_Config2__AllowCloning__c= false;
            option3.Apttus_Config2__AutoUpdateQuantity__c=false;
            option3.Apttus_Config2__Default__c=false;
            option3.Apttus_Config2__Modifiable__c=false;
            option3.Apttus_Config2__Sequence__c=0;
            option3.Apttus_Config2__Required__c=false;
            option3.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option3.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option3.Apttus_Config2__ComponentProductId__c=prod3.id;
         insert option3;
         
          Apttus_Config2__ProductOptionComponent__c option4 = new Apttus_Config2__ProductOptionComponent__c();
            option4.Apttus_Config2__AllowCloning__c= false;
            option4.Apttus_Config2__AutoUpdateQuantity__c=false;
            option4.Apttus_Config2__Default__c=false;
            option4.Apttus_Config2__Modifiable__c=false;
            option4.Apttus_Config2__Sequence__c=0;
            option4.Apttus_Config2__Required__c=false;
            option4.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option4.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option4.Apttus_Config2__ComponentProductId__c=prod4.id;
         insert option4;
         
         List<Apttus_Config2__ProductOptionComponent__c> listoptions= new List<Apttus_Config2__ProductOptionComponent__c> ();
         listoptions.add(option1);
         listoptions.add(option2);
         listoptions.add(option3);
         listoptions.add(option4);

        Apttus_Config2__ProductHierarchyView__c prodHierView = new Apttus_Config2__ProductHierarchyView__c();
        prodHierView.Apttus_Config2__HierarchyId__c=className.id;
        prodHierView.Apttus_Config2__ChildLevel__c=0;
        prodHierView.Apttus_Config2__ParentLevel__c=1;
        insert prodHierView;
            
          APTS_FindLaw_GEO_Defualts__c geoDefaults = new APTS_FindLaw_GEO_Defualts__c();
          geoDefaults.Name='1234';
          insert geoDefaults;
          
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
          
          APTS_Attribute_Value_Combination__c attributecombination2 = new APTS_Attribute_Value_Combination__c();
          attributecombination2.Name='Marshall-General';
          attributecombination2.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination2.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination2.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination2.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination2.APTS_Product__c=prodObj.id;
          insert attributecombination2;
          
          //added by Gowthami
          APTS_Attribute_Value_Combination__c attributecomExpo = new APTS_Attribute_Value_Combination__c();
          attributecomExpo.Name = 'Ohio-Bankruptcy Law';
          attributecomExpo.APTS_Product__c = prodObjExpo.id;
          insert attributecomExpo;
          
          List<String> listattrcomb = new List<String>();
          listattrcomb.add(attributecombination.Id);
          listattrcomb.add(attributecombination2.Id);
          
          List<Apttus_Config2__LineItem__c> listofli = new List<Apttus_Config2__LineItem__c>();
          Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prod1.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attr1.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20);
            
            Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prod2.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attr4.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20);
            
            Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prodObjExpo.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attributecomExpo1.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20); 
            listofli.add(lineItem1);
            listofli.add(lineItem2);
            listofli.add(lineItem3);

          Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(name='ali_test', Apttus_Config2__AccountId__c=a.id, CurrencyIsoCode='USD', Apttus_Config2__AssetStatus__c='Activated', Apttus_Config2__ProductId__c=prod5.id, Apttus_Config2__Quantity__c=1.256, Apttus_Config2__IsInactive__c = False, Apttus_Config2__SellingTerm__c=6.39);
          ali.Apttus_QPConfig__ProposalId__c=proposal.Id;
          insert ali;
        
          String attrcomExpo= attributecomExpo.id;
          String attrcomExpo1=attributecomExpo1.id;
          List<String> attrExpoList=new List<String>();
          attrExpoList.add(attrcomExpo);
          attrExpoList.add(attrcomExpo1);
          List<String> list1 = new List<String>();
          List<String> list2 = new List<String>();
          List<String> list3 = new List<String>();
          List<String> list4 = new List<String>();
          List<String> list5 = new List<String>();
          List<String> list6 = new List<String>();
          List<String> list7 = new List<String>();
           List<String> list8 = new List<String>();
            List<String> list9 = new List<String>();
          List<String> list10 = new List<String>();
          List<String> list11 = new List<String>();
          List<String> list12 = new List<String>();
          List<String> list13 = new List<String>();
          List<String> list14 = new List<String>();
          List<String> list15 = new List<String>();
          List<String> list16 = new List<String>();
          List<String> list17 = new List<String>();
          list1.add(attributevalue1.Id);
          list2.add(attributevalue2.Id);
          list3.add(attributevalue3.Id);
          list4.add(attributevalue4.Name);
          list5.add('');
          list6.add('');
          list7.add('');
          list8.add(attributevalueexp1.Name);
          list9.add(attributevalueexp2.Name);
          list10.add(attributevalueexp3.Name);
          list11.add('');
          list12.add('');
          list13.add(attributevalue4.Name);
          
          system.debug('inside if'+cartID);
          List<String> cartIdList=new List<String>();
          cartIdList.add(cartID);
          PageReference myVfPage = Page.APTS_CustomSolutionPage;
          Test.setCurrentPage(myVfPage);
          ApexPages.currentPage().getParameters().put('id', cartID);
          APTS_CustomSolutionctrl customclass = new APTS_CustomSolutionctrl();
          customclass.returnToCart();
          customclass.goToCart();
          customclass.exit();
          customclass.cancel2();
          customclass.cancel();
            List<Apttus_Config2__ProductOptionComponent__c> availableOptionsInBundleList;
         availableOptionsInBundleList = [select Id,Apttus_Config2__ComponentProductId__c,Apttus_Config2__Required__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ComponentProductId__r.Name 
                                                                                                from Apttus_Config2__ProductOptionComponent__c 
                                                                                                where Apttus_Config2__ParentProductId__c = '01t30000003hyDz'];
                      
          
          //String s1='No';
          String s2='Yes';
          Decimal discount=1.0;
          List<String> stringList = new  List<String> ();
           List<String> stringList1 = new  List<String> ();
          //stringList.add(s1);
          stringList1.add(s2);
          String atrr = 'Insurance Law';
          String attrValue = 'Criminal Law';
          List<String> attrList3 = new List<String>();
          attrList3.add(atrr);
          attrList3.add(attrValue);
          string parentattrval='123';
          APTS_CustomSolutionctrl.getProducts();
          APTS_CustomSolutionctrl.getDefaultAttribute(cartID);
          APTS_CustomSolutionctrl.getattributeSetting(prodObj.id);
          APTS_CustomSolutionctrl.getattributeValues(prodObj.id,attributesetting.Name,null);
          APTS_CustomSolutionctrl.getattributeValues(prodObj.id,attributesetting.Name,attributesetting.id);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list6,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list7,list11,list13,list12);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list7,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list6,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list5);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list6,list5);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObjExpo.id,prodObjExpo.ProductCode,list8,list9,list10,stringList);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prod5.id,prod5.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.AttrValCombinationUI wrapMethod=new APTS_CustomSolutionctrl.AttrValCombinationUI();
          wrapMethod.attributeValueInstance=attributecomExpo;
          wrapMethod.isInstalled=true;
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObjExpo.id,prodObjExpo.ProductCode,list8,list9,list7,stringList);
          system.debug('inside if'+cartID);
          Test.startTest();
            
           String jsonWrapper = '{"productId":"'+prodObj.id+'","combinationKey":"'+attributecombination.Id+'","cartId":"'+cartID+'","attorney":"2","apiName":"'+attributesetting.APTS_API_Method_Name__c+'"}';
          List<String> listStr = new List<String>();
          listStr.add(jsonWrapper);
           
    //      APTS_CustomSolutionctrl.addToCart(prodObj.id,listattrcomb,cartID,2,attributesetting.APTS_API_Method_Name__c);
           APTS_CustomSolutionctrl.addToCart(listStr);
          APTS_CustomSolutionctrl.getToCart(cartID);
          Test.stopTest();
          //APTS_CustomSolutionctrl.getPriceForExposurePack(prodObjExpo.id,prodObjExpo.ProductCode,list1,list2,list5,stringList,list8,list9,list10);
       }
    
        @isTest static void testMethodThree(){
         KeyValueListStore__c LCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        LCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        LCRMStrikeIronFlagINS1.TextValue__c='True';
         insert LCRMStrikeIronFlagINS1;
      
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = 'SLF 2-3';
        a.BillingPostalCode='1234';
        insert a;

        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        insert proposal;

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BillToAccountId__c=a.id;
        prodConfig.Apttus_Config2__AccountId__c=a.id;
        insert prodConfig;
        ID cartID = prodConfig.Id;

        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.LCRM_Sub_Bu__c='FindLaw';
          prodObj.APTS_Attrbased_config__C =true;
          prodObj.APTS_Media_Lower_Level_Code__c = '2Q';
          prodObj.ProductCode = '40586465';
          insert prodObj;  
      
          Product2 prodObjExpo = new Product2();
          prodObjExpo.Name = 'FINDLAW EXPOSURE PACK';
          prodObjExpo.LCRM_Sub_Bu__c='FindLaw';
          prodObjExpo.APTS_Attrbased_config__C =true;
          prodObjExpo.APTS_Media_Lower_Level_Code__c = 'H5';
          prodObjExpo.ProductCode = '40656701';
          insert prodObjExpo; 
          
          Product2 prod1 = new Product2();
          prod1.Name = 'FINDLAW DIRECTORY TOPSPOT';
          prod1.LCRM_Sub_Bu__c='FindLaw';
          prod1.APTS_Attrbased_config__C =true;
          prod1.APTS_Media_Lower_Level_Code__c = 'H5';
          prod1.APTS_CustomUI_Category__c = 'TopSpots';
          prod1.ProductCode = '37005005';
          insert prod1;  
          
          Product2 prod2 = new Product2();
          prod2.Name = 'FINDLAW DIRECTORY SPOTLIGHT';
          prod2.LCRM_Sub_Bu__c='FindLaw';
          prod2.APTS_Attrbased_config__C =true;
          prod2.APTS_Media_Lower_Level_Code__c = 'H5';
          prod2.APTS_CustomUI_Category__c = 'SpotLights';
          prod2.ProductCode = '37005004';
          insert prod2; 
          
          Product2 prod3 = new Product2();
          prod3.Name = 'FINDLAW DIRECTORY COUNTY TOPSPOT';
          prod3.LCRM_Sub_Bu__c='FindLaw';
          prod3.APTS_Attrbased_config__C =true;
          prod3.APTS_Media_Lower_Level_Code__c = 'H5';
          prod3.APTS_CustomUI_Category__c = 'TopSpots';
          prod3.ProductCode = '37005072';
          insert prod3;  
          
          Product2 prod4 = new Product2();
          prod4.Name = 'FINDLAW DIRECTORY COUNTY SPOTLIGHT';
          prod4.LCRM_Sub_Bu__c='FindLaw';
          prod4.APTS_Attrbased_config__C =true;
          prod4.APTS_Media_Lower_Level_Code__c = 'H5';
          prod4.APTS_CustomUI_Category__c = 'TopSpots';
          prod4.ProductCode = '41680342';
          insert prod4; 
          
          Product2 prod5 = new Product2();
          prod5.Name = 'FINDLAW DIGITAL MARKETING ACCELERATOR';
          prod5.LCRM_Sub_Bu__c='FindLaw';
          prod5.APTS_Attrbased_config__C =true;
          prod5.APTS_Media_Lower_Level_Code__c = 'F8';
          prod5.APTS_CustomUI_Category__c = 'Miscellaneous';
          prod5.ProductCode = '41767150';
          insert prod5;

          Product2 prod6 = new Product2();
          prod6.Name = 'FINDLAW DIGITAL MARKETING ACCELERATOR';
          prod6.LCRM_Sub_Bu__c='FindLaw';
          prod6.APTS_Attrbased_config__C =true;
          prod6.APTS_Media_Lower_Level_Code__c = 'F8';
          prod6.APTS_CustomUI_Category__c = 'Miscellaneous';
          prod6.ProductCode = '42157433';
          insert prod6;       
          
          APTS_Attribute_Value__c attributevalueexpmisc1 = new APTS_Attribute_Value__c();
          attributevalueexpmisc1.Name='Ohio';
          attributevalueexpmisc1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexpmisc1.APTS_Product__c=prod5.id;
          attributevalueexpmisc1.IsMetro__c=false;
          Insert attributevalueexpmisc1;
          APTS_Attribute_Value__c attributevalueexpmisc2 = new APTS_Attribute_Value__c();
          attributevalueexpmisc2.Name='Franklin (Columbus, OH)';
          attributevalueexpmisc2.APTS_Attribute_Name__c='County';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexpmisc2.APTS_Product__c=prod5.id;
          attributevalueexpmisc2.IsMetro__c=false;
          Insert attributevalueexpmisc2;
          
          APTS_Attribute_Value__c attributevalueexp1 = new APTS_Attribute_Value__c();
          attributevalueexp1.Name='California';
          attributevalueexp1.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp1.APTS_Product__c=prod1.id;
          attributevalueexp1.IsMetro__c=false;
          Insert attributevalueexp1;
          
          APTS_Attribute_Value__c attributevalueexp2 = new APTS_Attribute_Value__c();
          attributevalueexp2.Name='Insurance';
          attributevalueexp2.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp2.APTS_Product__c=prod1.id;
          attributevalueexp2.IsMetro__c=false;
          Insert attributevalueexp2;
          
          APTS_Attribute_Value__c attributevalueexp3 = new APTS_Attribute_Value__c();
          attributevalueexp3.Name='Insurance Law';
          attributevalueexp3.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp3.APTS_Product__c=prod1.id;
          attributevalueexp3.IsMetro__c=false;
          Insert attributevalueexp3;
          
          APTS_Attribute_Value__c attributevalueexp4 = new APTS_Attribute_Value__c();
          attributevalueexp4.Name='Los Angeles-Long Beach, CA';
          attributevalueexp4.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp4.APTS_Product__c=prod1.id;
          attributevalueexp4.IsMetro__c=false;
          Insert attributevalueexp4;
          
          APTS_Attribute_Value__c attributevalueexp5 = new APTS_Attribute_Value__c();
          attributevalueexp5.Name='San Diego, CA';
          attributevalueexp5.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp5.APTS_Product__c=prod1.id; 
          attributevalueexp5.IsMetro__c=false;
          Insert attributevalueexp5;
          
          APTS_Attribute_Value__c attributevalueexp6 = new APTS_Attribute_Value__c();
          attributevalueexp6.Name='San Jose, CA';
          attributevalueexp6.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp6.APTS_Product__c=prod1.id;
          attributevalueexp6.IsMetro__c=false;
          Insert attributevalueexp6;

          APTS_Attribute_Value__c attributevalueexp7 = new APTS_Attribute_Value__c();
          attributevalueexp7.Name='California';
          attributevalueexp7.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp7.APTS_Product__c=prod2.id;
          attributevalueexp7.IsMetro__c=false;
          Insert attributevalueexp7;
          
          APTS_Attribute_Value__c attributevalueexp8 = new APTS_Attribute_Value__c();
          attributevalueexp8.Name='Insurance';
          attributevalueexp8.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp8.APTS_Product__c=prod2.id;
          attributevalueexp8.IsMetro__c=false;
          Insert attributevalueexp8;
          
          APTS_Attribute_Value__c attributevalueexp9 = new APTS_Attribute_Value__c();
          attributevalueexp9.Name='Insurance Law';
          attributevalueexp9.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp9.APTS_Product__c=prod2.id;
          attributevalueexp9.IsMetro__c=false;
          Insert attributevalueexp9;
          
          APTS_Attribute_Value__c attributevalueexp10 = new APTS_Attribute_Value__c();
          attributevalueexp10.Name='Los Angeles-Long Beach, CA';
          attributevalueexp10.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp10.APTS_Product__c=prod2.id;
          attributevalueexp10.IsMetro__c=false;
          Insert attributevalueexp10;
          
          APTS_Attribute_Value__c attributevalueexp11 = new APTS_Attribute_Value__c();
          attributevalueexp11.Name='San Diego, CA';
          attributevalueexp11.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp11.APTS_Product__c=prod2.id;
           attributevalueexp11.IsMetro__c=false;
          Insert attributevalueexp11;
          
          APTS_Attribute_Value__c attributevalueexp12 = new APTS_Attribute_Value__c();
          attributevalueexp12.Name='San Jose, CA';
          attributevalueexp12.APTS_Attribute_Name__c='Metro';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp12.APTS_Product__c=prod2.id;
           attributevalueexp12.IsMetro__c=false;
          Insert attributevalueexp12;
          
          APTS_Attribute_Value__c attributevalueexp13 = new APTS_Attribute_Value__c();
          attributevalueexp13.Name='Massachusetts';
          attributevalueexp13.APTS_Attribute_Name__c='State';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp13.APTS_Product__c=prodObjExpo.id;
          attributevalueexp13.IsMetro__c=false;
          Insert attributevalueexp13;
          
           APTS_Attribute_Value__c attributevalueexp14 = new APTS_Attribute_Value__c();
          attributevalueexp14.Name='Crimes & Misdemeanors';
          attributevalueexp14.APTS_Attribute_Name__c='Practice Category';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp14.APTS_Product__c=prodObjExpo.id;
          attributevalueexp14.IsMetro__c=false;
          Insert attributevalueexp14;
          
           APTS_Attribute_Value__c attributevalueexp15 = new APTS_Attribute_Value__c();
          attributevalueexp15.Name='Criminal Law';
          attributevalueexp15.APTS_Attribute_Name__c='Practice Area';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp15.APTS_Product__c=prodObjExpo.id;
          attributevalueexp15.IsMetro__c=false;
          Insert attributevalueexp15;
          
           APTS_Attribute_Value__c attributevalueexp16 = new APTS_Attribute_Value__c();
          attributevalueexp16.Name='Massachusetts';
          attributevalueexp16.APTS_Attribute_Name__c='Statewide';
          //attributevalue.APTS_Parent_Attribute__c=attributesetting;
          attributevalueexp16.APTS_Product__c=prodObjExpo.id;
          attributevalueexp16.IsMetro__c=false;
          Insert attributevalueexp16;

          APTS_Attribute_Value_Combination__c attr1= new APTS_Attribute_Value_Combination__c();
          attr1.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr1.APTS_Attribute_Value0__c= attributevalueexp1.id;
          attr1.APTS_Attribute_Value1__c= attributevalueexp4.id;
          attr1.APTS_Attribute_Value2__c= attributevalueexp2.id;
          attr1.APTS_Attribute_Value3__c= attributevalueexp3.id;
          attr1.APTS_Inventory_Available__c=0.0;
          attr1.APTS_Product__c=prod1.id;
         // attr1.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attr1;
          
          List<APTS_Attribute_Value_Combination__c> attrList1=new List<APTS_Attribute_Value_Combination__c>();
          APTS_Attribute_Value_Combination__c attrcombmisc= new APTS_Attribute_Value_Combination__c();
          attrcombmisc.Name='Franklin-Tax Law';
          attrcombmisc.APTS_Attribute_Value0__c= attributevalueexpmisc1.id;
          attrcombmisc.APTS_Attribute_Value1__c= attributevalueexpmisc2.id;
         //attrcombmisc.APTS_Inventory_Available__c=0.0;
          attrcombmisc.APTS_Product__c=prod5.id;
         // attr1.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attrcombmisc;
          
          APTS_Attribute_Value_Combination__c attr2= new APTS_Attribute_Value_Combination__c();
          attr2.Name='San Diego, CA-Insurance Law';
          attr2.APTS_Attribute_Value0__c=attributevalueexp1.id;
          attr2.APTS_Attribute_Value1__c=attributevalueexp5.id;
          attr2.APTS_Attribute_Value2__c=attributevalueexp2.id;
          attr2.APTS_Attribute_Value3__c=attributevalueexp3.id;
          attr2.APTS_Inventory_Available__c=0.0;
          attr2.APTS_Product__c=prod1.id;
         // attr2.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attr2;
          
           APTS_Attribute_Value_Combination__c attr3= new APTS_Attribute_Value_Combination__c();
          attr3.Name='San Jose, CA-Insurance Law';
          attr3.APTS_Attribute_Value0__c=attributevalueexp1.id;
          attr3.APTS_Inventory_Available__c=5.0;
          attr3.APTS_Attribute_Value1__c=attributevalueexp6.id;
          attr3.APTS_Attribute_Value2__c=attributevalueexp2.id;
          attr3.APTS_Attribute_Value3__c=attributevalueexp3.id;
          attr3.APTS_Product__c=prod1.id;
          //attr3.APTS_Product__r.APTS_CustomUI_Category__c='TopSpots';
          insert attr3;
          
           APTS_Attribute_Value_Combination__c attr4= new APTS_Attribute_Value_Combination__c();
          attr4.Name='Los Angeles-Long Beach, CA-Insurance Law';
          attr4.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr4.APTS_Attribute_Value1__c=attributevalueexp10.id;
          attr4.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr4.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr4.APTS_Inventory_Available__c=97.0;
          attr4.APTS_Product__c=prod2.id;
          //attr4.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          insert attr4;
          
          APTS_Attribute_Value_Combination__c attr5= new APTS_Attribute_Value_Combination__c();
          attr5.Name='San Diego, CA-Insurance Law';
          attr5.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr5.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr5.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr5.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr5.APTS_Inventory_Available__c=98.0;
          attr5.APTS_Product__c=prod2.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          insert attr5;
          
          APTS_Attribute_Value_Combination__c attr6= new APTS_Attribute_Value_Combination__c();
          attr6.Name='San Diego, CA-Insurance Law';
          attr6.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr6.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr6.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr6.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr6.APTS_Inventory_Available__c=98.0;
          attr6.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          //insert attr6;
          
          APTS_Attribute_Value_Combination__c attr7= new APTS_Attribute_Value_Combination__c();
          attr7.Name='San Diego, CA-Insurance Law';
          attr7.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr7.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr7.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr7.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr7.APTS_Inventory_Available__c=98.0;
          attr7.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
         // insert attr7;
          
          APTS_Attribute_Value_Combination__c attr8= new APTS_Attribute_Value_Combination__c();
          attr8.Name='San Diego, CA-Insurance Law';
          attr8.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr8.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr8.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr8.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr8.APTS_Inventory_Available__c=98.0;
          attr8.APTS_Product__c=prod1.id;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
          //insert attr8;
          
          APTS_Attribute_Value_Combination__c attr9= new APTS_Attribute_Value_Combination__c();
          attr9.Name='San Diego, CA-Insurance Law';
          attr9.APTS_Attribute_Value0__c=attributevalueexp7.id;
          attr9.APTS_Attribute_Value1__c=attributevalueexp11.id;
          attr9.APTS_Attribute_Value2__c=attributevalueexp8.id;
          attr9.APTS_Attribute_Value3__c=attributevalueexp9.id;
          attr9.APTS_Inventory_Available__c=98.0;
          //attr5.APTS_Product__r.APTS_CustomUI_Category__c='SpotLights';
         // insert attr9;
         
          APTS_Attribute_Value_Combination__c attributecomExpo1 = new APTS_Attribute_Value_Combination__c();
          attributecomExpo1.Name = 'Massachusetts-Criminal Law';
          attributecomExpo1.APTS_Product__c = prodObjExpo.id;
          attributecomExpo1.APTS_Attribute_Value0__c=attributevalueexp13.id;
          attributecomExpo1.APTS_Attribute_Value1__c=attributevalueexp14.id;
          attributecomExpo1.APTS_Attribute_Value2__c=attributevalueexp15.id;
          attributecomExpo1.APTS_Attribute_Value3__c=attributevalueexp16.id;
          attributecomExpo1.APTS_Inventory_Available__c=98.0;
    
          attrList1.add(attr6);
          attrList1.add(attr7);
          attrList1.add(attr9);
          attrList1.add(attributecomExpo1);
          insert attrList1;
          
           Apttus_Config2__ClassificationName__c className= new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__Active__c=true;
        className.Apttus_Config2__HierarchyLabel__c='ExposureLabel';
        className.Apttus_Config2__Type__c='Option Group';
        className.Name='ExposureLabelName';
        insert className;
         
         Apttus_Config2__ClassificationHierarchy__c optionclass= new Apttus_Config2__ClassificationHierarchy__c();
        optionclass.Apttus_Config2__DefaultSearchCategory__c=false;
        optionclass.Apttus_Config2__ExpandedByDefault__c=false;
        optionclass.Apttus_Config2__HideAllSearchFilters__c=false;
        optionclass.Apttus_Config2__IncludeInTotalsView__c=true;
        optionclass.Apttus_Config2__IsHidden__c=false;
        optionclass.Apttus_Config2__IsPicklist__c=false;
        optionclass.Apttus_Config2__Label__c='ExposureLabelName';
        optionclass.Apttus_Config2__Modifiable__c=true;
        optionclass.DC_Is_Title_Visible__c=false;
        optionclass.Apttus_Config2__HierarchyId__c=className.id;
        optionclass.Name='ExposureLabelName';
        insert optionclass;
        
        Apttus_Config2__ProductOptionGroup__c optiongroup1=new Apttus_Config2__ProductOptionGroup__c();
        optiongroup1.Apttus_Config2__IsHidden__c=false;
        optiongroup1.Apttus_Config2__IsLeaf__c=true;
        optiongroup1.Apttus_Config2__IsPicklist__c=false;
        optiongroup1.Apttus_Config2__Sequence__c=0;
        optiongroup1.Apttus_Config2__OptionGroupId__c=optionclass.id;
        optiongroup1.Apttus_Config2__ProductId__c=prodObjExpo.id;
        optiongroup1.Apttus_Config2__RootOptionGroupId__c=optionclass.id;
        insert optiongroup1;
        
         Apttus_Config2__ProductOptionComponent__c option1 = new Apttus_Config2__ProductOptionComponent__c();
            option1.Apttus_Config2__AllowCloning__c= false;
            option1.Apttus_Config2__AutoUpdateQuantity__c=false;
            option1.Apttus_Config2__Default__c=false;
            option1.Apttus_Config2__Modifiable__c=false;
            option1.Apttus_Config2__Sequence__c=0;
            option1.Apttus_Config2__Required__c=false;
            option1.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option1.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option1.Apttus_Config2__ComponentProductId__c=prod1.id;
         insert option1;
         
         Apttus_Config2__ProductOptionComponent__c option2 = new Apttus_Config2__ProductOptionComponent__c();
            option2.Apttus_Config2__AllowCloning__c= false;
            option2.Apttus_Config2__AutoUpdateQuantity__c=false;
            option2.Apttus_Config2__Default__c=false;
            option2.Apttus_Config2__Modifiable__c=false;
            option2.Apttus_Config2__Sequence__c=0;
            option2.Apttus_Config2__Required__c=false;
            option2.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option2.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option2.Apttus_Config2__ComponentProductId__c=prod2.id;
         insert option2;
         
         Apttus_Config2__ProductOptionComponent__c option3 = new Apttus_Config2__ProductOptionComponent__c();
            option3.Apttus_Config2__AllowCloning__c= false;
            option3.Apttus_Config2__AutoUpdateQuantity__c=false;
            option3.Apttus_Config2__Default__c=false;
            option3.Apttus_Config2__Modifiable__c=false;
            option3.Apttus_Config2__Sequence__c=0;
            option3.Apttus_Config2__Required__c=false;
            option3.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option3.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option3.Apttus_Config2__ComponentProductId__c=prod3.id;
         insert option3;
         
          Apttus_Config2__ProductOptionComponent__c option4 = new Apttus_Config2__ProductOptionComponent__c();
            option4.Apttus_Config2__AllowCloning__c= false;
            option4.Apttus_Config2__AutoUpdateQuantity__c=false;
            option4.Apttus_Config2__Default__c=false;
            option4.Apttus_Config2__Modifiable__c=false;
            option4.Apttus_Config2__Sequence__c=0;
            option4.Apttus_Config2__Required__c=false;
            option4.Apttus_Config2__ParentProductId__c = '01t30000003hyDz';
            option4.Apttus_Config2__ProductOptionGroupId__c = optiongroup1.id ;
            option4.Apttus_Config2__ComponentProductId__c=prod4.id;
         insert option4;
         
         List<Apttus_Config2__ProductOptionComponent__c> listoptions= new List<Apttus_Config2__ProductOptionComponent__c> ();
         listoptions.add(option1);
         listoptions.add(option2);
         listoptions.add(option3);
         listoptions.add(option4);

        Apttus_Config2__ProductHierarchyView__c prodHierView = new Apttus_Config2__ProductHierarchyView__c();
        prodHierView.Apttus_Config2__HierarchyId__c=className.id;
        prodHierView.Apttus_Config2__ChildLevel__c=0;
        prodHierView.Apttus_Config2__ParentLevel__c=1;
        insert prodHierView;
            
          APTS_FindLaw_GEO_Defualts__c geoDefaults = new APTS_FindLaw_GEO_Defualts__c();
          geoDefaults.Name='1234';
          insert geoDefaults;
          
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
          
          APTS_Attribute_Value_Combination__c attributecombination2 = new APTS_Attribute_Value_Combination__c();
          attributecombination2.Name='Marshall-General';
          attributecombination2.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination2.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination2.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination2.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination2.APTS_Product__c=prodObj.id;
          insert attributecombination2;
          
          //added by Gowthami
          APTS_Attribute_Value_Combination__c attributecomExpo = new APTS_Attribute_Value_Combination__c();
          attributecomExpo.Name = 'Ohio-Bankruptcy Law';
          attributecomExpo.APTS_Product__c = prodObjExpo.id;
          insert attributecomExpo;
          
          List<String> listattrcomb = new List<String>();
          listattrcomb.add(attributecombination.Id);
          listattrcomb.add(attributecombination2.Id);
          
          List<Apttus_Config2__LineItem__c> listofli = new List<Apttus_Config2__LineItem__c>();
          Apttus_Config2__LineItem__c lineItem1=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prod1.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attr1.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20);
            
            Apttus_Config2__LineItem__c lineItem2=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prod2.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attr4.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20);
            
            Apttus_Config2__LineItem__c lineItem3=new Apttus_Config2__LineItem__c(
           
            Apttus_Config2__ProductId__c=prodObjExpo.id,
             Apttus_Config2__LineType__c ='Product/Service',
             Apttus_Config2__LineStatus__c = 'New',
             Apttus_Config2__ChargeType__c = 'Subscription Fee',
             Apttus_Config2__ItemSequence__c = 1,
             APTS_Combination_Key__c = attributecomExpo1.Id,
             Apttus_Config2__ConfigurationId__c = cartID,
            Apttus_Config2__Quantity__c=20); 
            listofli.add(lineItem1);
            listofli.add(lineItem2);
            listofli.add(lineItem3);

          Apttus_Config2__AssetLineItem__c ali = new Apttus_Config2__AssetLineItem__c(name='ali_test', Apttus_Config2__AccountId__c=a.id, CurrencyIsoCode='USD', Apttus_Config2__AssetStatus__c='Activated', Apttus_Config2__ProductId__c=prod5.id, Apttus_Config2__Quantity__c=1.256, Apttus_Config2__IsInactive__c = False, Apttus_Config2__SellingTerm__c=6.39);
          ali.Apttus_QPConfig__ProposalId__c=proposal.Id;
          insert ali;
        
          String attrcomExpo= attributecomExpo.id;
          String attrcomExpo1=attributecomExpo1.id;
          List<String> attrExpoList=new List<String>();
          attrExpoList.add(attrcomExpo);
          attrExpoList.add(attrcomExpo1);
          List<String> list1 = new List<String>();
          List<String> list2 = new List<String>();
          List<String> list3 = new List<String>();
          List<String> list4 = new List<String>();
          List<String> list5 = new List<String>();
          List<String> list6 = new List<String>();
          List<String> list7 = new List<String>();
           List<String> list8 = new List<String>();
            List<String> list9 = new List<String>();
          List<String> list10 = new List<String>();
          List<String> list11 = new List<String>();
          List<String> list12 = new List<String>();
          List<String> list13 = new List<String>();
          List<String> list14 = new List<String>();
          List<String> list15 = new List<String>();
          List<String> list16 = new List<String>();
          List<String> list17 = new List<String>();
          list1.add(attributevalue1.Id);
          list2.add(attributevalue2.Id);
          list3.add(attributevalue3.Id);
          list4.add(attributevalue4.Name);
          list5.add('');
          list6.add('');
          list7.add('');
          list8.add(attributevalueexp1.Name);
          list9.add(attributevalueexp2.Name);
          list10.add(attributevalueexp3.Name);
          list11.add('');
          list12.add('');
          list13.add(attributevalue4.Name);
          
          system.debug('inside if'+cartID);
          List<String> cartIdList=new List<String>();
          cartIdList.add(cartID);
          PageReference myVfPage = Page.APTS_CustomSolutionPage;
          Test.setCurrentPage(myVfPage);
          ApexPages.currentPage().getParameters().put('id', cartID);
          APTS_CustomSolutionctrl customclass = new APTS_CustomSolutionctrl();
          customclass.returnToCart();
          customclass.goToCart();
          customclass.exit();
          customclass.cancel2();
          customclass.cancel();
        List<Apttus_Config2__ProductOptionComponent__c> availableOptionsInBundleList;
         availableOptionsInBundleList = [select Id,Apttus_Config2__ComponentProductId__c,Apttus_Config2__Required__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ComponentProductId__r.Name 
                                                                                                from Apttus_Config2__ProductOptionComponent__c 
                                                                                                where Apttus_Config2__ParentProductId__c = '01t30000003hyDz'];
                      
          
          //String s1='No';
          String s2='Yes';
          String prodCode='';
          Decimal discount=1.0;
          List<String> stringList = new  List<String> ();
           List<String> stringList1 = new  List<String> ();
          //stringList.add(s1);
          stringList1.add(s2);
          String atrr = 'Insurance Law';
          String attrValue = 'Criminal Law';
          List<String> attrList3 = new List<String>();
          attrList3.add(atrr);
          attrList3.add(attrValue);
          string parentattrval='123';
          APTS_CustomSolutionctrl.getProducts();
          APTS_CustomSolutionctrl.getDefaultAttribute(cartID);
          APTS_CustomSolutionctrl.getattributeSetting(prodObj.id);
          APTS_CustomSolutionctrl.getattributeValues(prodObj.id,attributesetting.Name,null);
          APTS_CustomSolutionctrl.getattributeValues(prodObj.id,attributesetting.Name,attributesetting.id);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list6,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list7,list11,list13,list12);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list7,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list6,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list3,list5);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list2,list6,list5);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list4);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObj.id,prodObj.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObjExpo.id,prodObjExpo.ProductCode,list8,list9,list10,stringList);
          //APTS_CustomSolutionctrl.getattributeCombination(cartID,prod5.id,prod5.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prod6.id,prod6.ProductCode,list1,list5,list3,list6);
          APTS_CustomSolutionctrl.AttrValCombinationUI wrapMethod=new APTS_CustomSolutionctrl.AttrValCombinationUI();
          wrapMethod.attributeValueInstance=attributecomExpo;
          wrapMethod.isInstalled=true;
          APTS_CustomSolutionctrl.getattributeCombination(cartID,prodObjExpo.id,prodObjExpo.ProductCode,list8,list9,list7,stringList);
          system.debug('inside if'+cartID);
          Test.startTest();
            String jsonWrapper = '{"productId":"'+prodObj.id+'","combinationKey":"'+attributecombination.Id+'","cartId":"'+cartID+'","attorney":"2","apiName":"'+attributesetting.APTS_API_Method_Name__c+'"}';
          List<String> listStr = new List<String>();
          listStr.add(jsonWrapper);
            
     //     APTS_CustomSolutionctrl.addToCart(prodObj.id,listattrcomb,cartID,2,attributesetting.APTS_API_Method_Name__c);
            APTS_CustomSolutionctrl.addToCart(listStr);
            APTS_CustomSolutionctrl.getToCart(cartID);
          Test.stopTest();
          //APTS_CustomSolutionctrl.getPriceForExposurePack(prodObjExpo.id,prodObjExpo.ProductCode,list1,list2,list5,stringList,list8,list9,list10);
       }
        
    @isTest static void testMethodFour(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'LatAM Helpdesk Agent'].Id;
        User objUser = APTS_TestDataFactory.createUser('testUserFindLawC@test.com', 'TestU');
        objUser.ProfileId = profileId;
        objUser.Email = 'test@test.com';
        objUser.Alias = 'testu';
        insert objUser;
        
        Account a = APTS_TestDataFactory.createAccount('Test Account');
        a.FrozenMarketSegment__c = 'SLF 2-3';
        a.BillingPostalCode='1234';
        insert a;
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.APTS_Proposal_Business_Unit__c='FindLaw';
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        prodConfig.Apttus_Config2__BillToAccountId__c=a.id;
        prodConfig.Apttus_Config2__AccountId__c=a.id;
        insert prodConfig;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'FINDLAW DIRECTORY TOPSPOT';
        prod1.LCRM_Sub_Bu__c='FindLaw';
        prod1.APTS_Attrbased_config__C =true;
        prod1.APTS_Media_Lower_Level_Code__c = 'H5';
        prod1.APTS_CustomUI_Category__c = 'TopSpots';
        prod1.ProductCode = '37005005';
        insert prod1;
        
        Product2 prodObjExpo = new Product2();
        prodObjExpo.Name = 'FINDLAW DIRECTORY SPOTLIGHT';
        prodObjExpo.LCRM_Sub_Bu__c='FindLaw';
        prodObjExpo.APTS_Attrbased_config__C =true;
        prodObjExpo.APTS_Media_Lower_Level_Code__c = 'H5';
        prodObjExpo.ProductCode = '40656701';
        prodObjExpo.APTS_CustomUI_Category__c = 'SpotLights';
        insert prodObjExpo;
        
        APTS_Attribute_Value__c attributevalueexp1 = new APTS_Attribute_Value__c();
        attributevalueexp1.Name='California';
        attributevalueexp1.APTS_Attribute_Name__c='State';
        attributevalueexp1.APTS_Product__c=prod1.id;
        attributevalueexp1.IsMetro__c=false;
        Insert attributevalueexp1;
        
        APTS_Attribute_Value__c attributevalueexp4 = new APTS_Attribute_Value__c();
        attributevalueexp4.Name='California';
        attributevalueexp4.APTS_Attribute_Name__c='Metro';
        attributevalueexp4.APTS_Product__c=prod1.id;
        attributevalueexp4.IsMetro__c=false;
        Insert attributevalueexp4;
        
        APTS_Attribute_Value__c attributevalueexp2 = new APTS_Attribute_Value__c();
        attributevalueexp2.Name='Insurance';
        attributevalueexp2.APTS_Attribute_Name__c='Practice Category';
        attributevalueexp2.APTS_Product__c=prod1.id;
        attributevalueexp2.IsMetro__c=false;
        Insert attributevalueexp2;
        
        APTS_Attribute_Value__c attributevalueexp3 = new APTS_Attribute_Value__c();
        attributevalueexp3.Name='Insurance Law';
        attributevalueexp3.APTS_Attribute_Name__c='Practice Area';
        attributevalueexp3.APTS_Product__c=prod1.id;
        attributevalueexp3.IsMetro__c=false;
        Insert attributevalueexp3;
        
        APTS_Attribute_Value_Combination__c attr1= new APTS_Attribute_Value_Combination__c();
        attr1.Name='Los Angeles-Long Beach, CA-Insurance Law';
        attr1.APTS_Attribute_Value0__c= attributevalueexp1.id;
        attr1.APTS_Attribute_Value1__c= attributevalueexp4.id;
        attr1.APTS_Attribute_Value2__c= attributevalueexp2.id;
        attr1.APTS_Attribute_Value3__c= attributevalueexp3.id;
        attr1.APTS_Inventory_Available__c=0;
        attr1.APTS_Exposure_Pack_Disc__c = 1.5;
        attr1.APTS_Price__c = 100;
        attr1.APTS_Product__c=prod1.id;
        insert attr1;
        
        APTS_Attribute_Value__c attributevalueexp13 = new APTS_Attribute_Value__c();
        attributevalueexp13.Name='California';
        attributevalueexp13.APTS_Attribute_Name__c='State';
        attributevalueexp13.APTS_Product__c=prodObjExpo.id;
        attributevalueexp13.IsMetro__c=false;
        Insert attributevalueexp13;
          
        APTS_Attribute_Value__c attributevalueexp14 = new APTS_Attribute_Value__c();
        attributevalueexp14.Name='Insurance';
        attributevalueexp14.APTS_Attribute_Name__c='Practice Category';
        attributevalueexp14.APTS_Product__c=prodObjExpo.id;
        attributevalueexp14.IsMetro__c=false;
        Insert attributevalueexp14;
          
        APTS_Attribute_Value__c attributevalueexp15 = new APTS_Attribute_Value__c();
        attributevalueexp15.Name='Insurance Law';
        attributevalueexp15.APTS_Attribute_Name__c='Practice Area';
        attributevalueexp15.APTS_Product__c=prodObjExpo.id;
        attributevalueexp15.IsMetro__c=false;
        Insert attributevalueexp15;

        APTS_Attribute_Value_Combination__c attributecomExpo1 = new APTS_Attribute_Value_Combination__c();
        attributecomExpo1.Name = 'Massachusetts-Criminal Law';
        attributecomExpo1.APTS_Product__c = prodObjExpo.id;
        attributecomExpo1.APTS_Attribute_Value0__c=attributevalueexp13.id;
        attributecomExpo1.APTS_Attribute_Value1__c=attributevalueexp13.id;
        attributecomExpo1.APTS_Attribute_Value2__c=attributevalueexp14.id;
        attributecomExpo1.APTS_Attribute_Value3__c=attributevalueexp15.id;
        attributecomExpo1.Attribute3_Name__c = 'Insurance Law';
        attributecomExpo1.APTS_Inventory_Available__c=0;
        insert attributecomExpo1;
        
        APTS_Attribute_Value_Combination__c objAttbComb2 = attr1.clone(false, false, false, false);
        objAttbComb2.APTS_Inventory_Available__c=10;
        insert objAttbComb2;
        
        Set<ID> attrIds = new Set<ID>();
        attrIds.add(attr1.Id);
        attrIds.add(attributecomExpo1.Id);
        attrIds.add(objAttbComb2.Id);
        
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        List<APTS_Attribute_Value_Combination__c> attrList1=new List<APTS_Attribute_Value_Combination__c>();
        attrList1 = [Select Id, name,APTS_Configuration_Description__c,APTS_Product__c,Attribute2_Name__c, Attribute0_Name__c, APTS_CustomUI_Category__c, APTS_Inventory_Available__c,
                     Attribute1_Name__c, APTS_Product_Name__c, APTS_Product_Code__c, Attribute3_Name__c from APTS_Attribute_Value_Combination__c 
                     where id IN :attrIds];
        
        List<String> keys = new List<String>{};
        List<Double> values = new List<Double>{};
        for(APTS_Attribute_Value_Combination__c objAttr : attrList1)
        {
            keys.add(objAttr.Id);
            values.add(10);
        }
        List<String> listAttb3 = new List<String>();
        listAttb3.add('No');

        Test.startTest();
        System.runAs(objUser){
            APTS_CustomSolutionctrl ctrl = new APTS_CustomSolutionctrl();
        }
        Cache.session.put('local.FindLawpaGeo.listOfAttributeValueCombs', new List<APTS_Attribute_Value_Combination__c>());
        APTS_CustomSolutionctrl.processAttbValueCombs('Yes', true, null, null, new List<String>(), new List<Double>());
        Cache.session.put('local.FindLawpaGeo.listOfAttributeValueCombs', attrList1);
        APTS_CustomSolutionctrl.processAttbValueCombs('No', true, priceList.Id, prodConfig.Id, keys, values);
        
        APTS_CustomSolutionctrl.processAttbValueCombs('No', true, priceList.Id, prodConfig.Id, keys, values);
        APTS_CustomSolutionctrl.processAttbValueCombs('Yes', true, priceList.Id, prodConfig.Id, keys, values);
        
        APTS_CustomSolutionctrl.getPriceForExposurePack3(attrList1, listAttb3, new List<String>{'California'},new List<String>{'Insurance'},new List<String>{'Insurance Law'},attr1);
        APTS_CustomSolutionctrl.addingProductsToCart(attrList1, 'No');
        Test.stopTest();
    }
}