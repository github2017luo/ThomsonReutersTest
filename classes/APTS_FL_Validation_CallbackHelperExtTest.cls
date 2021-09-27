@isTest
public class APTS_FL_Validation_CallbackHelperExtTest {

    public Static Product2 NewProduct(String ProductCode){
        Product2 prod3Obj = new Product2();
        prod3Obj.Name = 'Network Services 2.0';
        prod3Obj.APTS_Media_High_Level_Code__c = '07';
        prod3Obj.APTS_Media_Lower_Level_Code__c = 'BB';
        prod3Obj.productcode = ProductCode;
        return prod3Obj;
    }

     @isTest static void testMethodOne(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        Product_codes__c procodes3= new Product_codes__c();
        procodes3.Name='41618485';
        Product_codes__c procodes4= new Product_codes__c();
        procodes4.Name='42686641';
        
         Product_codes__c procodes1= new Product_codes__c();
        procodes1.Name='41076128';
        
        
         Product_codes__c procodes2= new Product_codes__c();
        procodes2.Name='42532854';
        
        
         
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        newList.add(procodes1);
        newList.add(procodes2);
        newList.add(procodes3);
        newList.add(procodes4);
        insert newList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        
        insert staticCSList ;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
 
        List<Product_Codes_Set1__c> prdListSet1=new List<Product_Codes_Set1__c>();
        prdListSet1.add(prodSet1);
        insert prdListSet1;
         
         Product_Codes_Set2__c prodSet2= new Product_Codes_Set2__c();
        prodSet2.Name='41771511';
        insert prodSet2;
        
        Product_Codes_Set3__c prodSet3 = new Product_Codes_Set3__c();
        prodSet3.Name='40043923';
        insert prodSet3;
        Product_Codes_Set6__c prodSet6= new Product_Codes_Set6__c();
        prodSet6.Name='30405004';
        
        Product_Codes_Set4__c prodSet4 = new Product_Codes_Set4__c();
        prodSet4.Name='40485591';
        insert prodSet4;
        
        Product_Codes_Set5__c prodSet5 = new Product_Codes_Set5__c();
        prodSet5.Name='40475630';
        insert prodSet5;

        List<Product_Codes_Set6__c> listCodes=new List<Product_Codes_Set6__c>();
        listCodes.add(prodSet6);
        insert listCodes;
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,42686641,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051';
         insert pageo;
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap = New List<Product2>();
         Product2 p1 = NewProduct('41817449');newMap.add(p1);
         Product2 p2 = NewProduct('41618485');newMap.add(p2);   
         Product2 p46 = NewProduct('42686641');newMap.add(p46);
         Product2 p3 = NewProduct('41076128');newMap.add(p3); 
         Product2 p4 = NewProduct('42532854');newMap.add(p4); 
         Product2 p5 = NewProduct('42532855');newMap.add(p5);  
         Product2 p6 = NewProduct('42532852');newMap.add(p6);    
         Product2 p7 = NewProduct('42532853');newMap.add(p7);  
         Product2 p8 = NewProduct('41986777');newMap.add(p8);
         Product2 p9 = NewProduct('42118619');newMap.add(p9); 
         Product2 p10 = NewProduct('41053156');newMap.add(p10);
      //,,,,,42565209
          Product2 p11 = NewProduct('41003359');newMap.add(p11);
          Product2 p12 = NewProduct('42564669');newMap.add(p12);
          Product2 p13 = NewProduct('40542344');newMap.add(p13);
          Product2 p14 = NewProduct('40542345');newMap.add(p14); 
          Product2 p15 = NewProduct('40656696');newMap.add(p15);
          Product2 p16 = NewProduct('41819162');newMap.add(p16);
          Product2 p17 = NewProduct('41323281');newMap.add(p17); 
          Product2 p18 = NewProduct('41323282');newMap.add(p18);
          Product2 p19 = NewProduct('41325003');newMap.add(p19);
          Product2 p20 = NewProduct('41701486');newMap.add(p20);
          Product2 p21 = NewProduct('42565209');newMap.add(p21);
          Product2 p22 = NewProduct('42089522');newMap.add(p22);
          Product2 p23 = NewProduct('42089521');newMap.add(p23);
          Product2 p24 = NewProduct('41618486');newMap.add(p24);
          Product2 p25 = NewProduct('42089523');newMap.add(p25);
          Product2 p26 = NewProduct('42089524');newMap.add(p26);
          Product2 p27 = NewProduct('41180810');newMap.add(p27);
          Product2 p28 = NewProduct('41767150');newMap.add(p28);
          Product2 p29 = NewProduct('40485593');newMap.add(p29);
          Product2 p30 = NewProduct('40043926');newMap.add(p30);
          Product2 p31 = NewProduct('40485593');newMap.add(p31);
          Product2 p32 = NewProduct('40483699');newMap.add(p32);
          Product2 p33 = NewProduct('40043923');newMap.add(p33);
          Product2 p34 = NewProduct('30405006');newMap.add(p34);
          Product2 p35 = NewProduct('40261790');newMap.add(p35);
          Product2 p36 = NewProduct('40483700');newMap.add(p36);
          Product2 p37 = NewProduct('40485591');newMap.add(p37);
          Product2 p38 = NewProduct('30405004');newMap.add(p38);
          Product2 p39 = NewProduct('40052427');newMap.add(p39);
          Product2 p40 = NewProduct('41771511');newMap.add(p40);
          Product2 p41 = NewProduct('40485591');newMap.add(p41);
          Product2 p42 = NewProduct('40475630');newMap.add(p42);
          Product2 p43 = NewProduct('40666911');newMap.add(p43);
          Product2 p44 = NewProduct('41378928');newMap.add(p44);
          Product2 p45 = NewProduct('42686641');newMap.add(p45);
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
          prodobj.ProductCode='41817449';insert prodObj;

          Product2 prodObj1 = new Product2();
          prodObj1.Name = 'Network Services 1.0';
          prodObj1.APTS_Media_High_Level_Code__c = '08';
          prodObj1.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj1.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj1.ProductCode='41767150';insert prodObj1;
          
          Product2 prodObj31 = new Product2();
          prodObj31.Name = 'Network Services 1.0';
          prodObj31.APTS_Media_High_Level_Code__c = '08';
          prodObj31.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj31.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj31.ProductCode='41618485';insert prodObj31;
          
           Product2 prodObj2 = new Product2();
          prodObj2.Name = 'Network Services 1.0';
          prodObj2.APTS_Media_High_Level_Code__c = '08';
          prodObj2.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj2.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj2.ProductCode='41076128';insert prodObj2;
          
          Product2 prodObj3 = new Product2();
          prodObj3.Name = 'Network Services 1.0';
          prodObj3.APTS_Media_High_Level_Code__c = '08';
          prodObj3.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj3.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj3.ProductCode='42532854';insert prodObj3;
          
          Product2 prodObj4 = new Product2();
          prodObj4.Name = 'Network Services 1.0';
          prodObj4.APTS_Media_High_Level_Code__c = '08';
          prodObj4.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj4.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj4.ProductCode='42532852';insert prodObj4;
          
          Product2 prodObj5 = new Product2();
          prodObj5.Name = 'Network Services 1.0';
          prodObj5.APTS_Media_High_Level_Code__c = '08';
          prodObj5.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj5.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj5.ProductCode='42532855';insert prodObj5;
          
           Product2 prodObj6 = new Product2();
          prodObj6.Name = 'Network Services 1.0';
          prodObj6.APTS_Media_High_Level_Code__c = '08';
          prodObj6.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj6.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj6.ProductCode='42532853';insert prodObj6;
          
           Product2 prodObj7 = new Product2();
          prodObj7.Name = 'Network Services 1.0';
          prodObj7.APTS_Media_High_Level_Code__c = '08';
          prodObj7.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj7.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj7.ProductCode='41986777';insert prodObj7;
          
          Product2 prodObj8 = new Product2();
          prodObj8.Name = 'Network Services 1.0';
          prodObj8.APTS_Media_High_Level_Code__c = '08';
          prodObj8.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj8.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj8.ProductCode='42118619';insert prodObj8;
          
           Product2 prodObj9 = new Product2();
          prodObj9.Name = 'Network Services 1.0';
          prodObj9.APTS_Media_High_Level_Code__c = '08';
          prodObj9.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj9.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj9.ProductCode='41003359';insert prodObj9;
          
           Product2 prodObj10 = new Product2();
          prodObj10.Name = 'Network Services 1.0';
          prodObj10.APTS_Media_High_Level_Code__c = '08';
          prodObj10.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj10.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj10.ProductCode='40666911';insert prodObj10;
          
          Product2 prodObj13 = new Product2();
          prodObj13.Name = 'Network Services 1.0';
          prodObj13.APTS_Media_High_Level_Code__c = '08';
          prodObj13.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj13.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj13.ProductCode='42565209';insert prodObj13;
           
          Product2 prodObj11 = new Product2();
          prodObj11.Name = 'Network Services 1.0';
          prodObj11.APTS_Media_High_Level_Code__c = '08';
          prodObj11.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj11.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj11.ProductCode='42564669';insert prodObj11;
          
          /*Product2 prodObj12 = new Product2();
          prodObj12.Name = 'Network Services 1.0';
          prodObj12.APTS_Media_High_Level_Code__c = '08';
          prodObj12.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj12.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj12.ProductCode='41817449';insert prodObj12;*/

          Product2 prodObj14 = new Product2();
          prodObj14.Name = 'Network Services 1.0';
          prodObj14.APTS_Media_High_Level_Code__c = '08';
          prodObj14.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj14.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj14.ProductCode='40542344';insert prodObj14;
          
          Product2 prodObj15 = new Product2();
          prodObj15.Name = 'Network Services 1.0';
          prodObj15.APTS_Media_High_Level_Code__c = '08';
          prodObj15.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj15.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj15.ProductCode='40483699';insert prodObj15;
          
           Product2 prodObj16 = new Product2();
          prodObj16.Name = 'Network Services 1.0';
          prodObj16.APTS_Media_High_Level_Code__c = '08';
          prodObj16.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj16.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj16.ProductCode='40542345';insert prodObj16;
          
           Product2 prodObj17 = new Product2();
          prodObj17.Name = 'Network Services 1.0';
          prodObj17.APTS_Media_High_Level_Code__c = '08';
          prodObj17.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj17.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj17.ProductCode='40485592';insert prodObj17;
          
          Product2 prodObj18 = new Product2();
          prodObj18.Name = 'Network Services 1.0';
          prodObj18.APTS_Media_High_Level_Code__c = '08';
          prodObj18.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj18.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj18.ProductCode='42089522';insert prodObj18;
          
           Product2 prodObj19 = new Product2();
          prodObj19.Name = 'Network Services 1.0';
          prodObj19.APTS_Media_High_Level_Code__c = '08';
          prodObj19.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj19.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj19.ProductCode='42089521';insert prodObj19;
          
          Product2 prodObj20 = new Product2();
          prodObj20.Name = 'Network Services 1.0';
          prodObj20.APTS_Media_High_Level_Code__c = '08';
          prodObj20.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj20.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj20.ProductCode='41618486';insert prodObj20;
          
          Product2 prodObj21 = new Product2();
          prodObj21.Name = 'Network Services 1.0';
          prodObj21.APTS_Media_High_Level_Code__c = '08';
          prodObj21.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj21.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj21.ProductCode='42089523';insert prodObj21;
          
           Product2 prodObj22 = new Product2();
          prodObj22.Name = 'Network Services 1.0';
          prodObj22.APTS_Media_High_Level_Code__c = '08';
          prodObj22.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj22.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj22.ProductCode='41180810';insert prodObj22;
          
           Product2 prodObj23 = new Product2();
          prodObj23.Name = 'Network Services 1.0';
          prodObj23.APTS_Media_High_Level_Code__c = '08';
          prodObj23.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj23.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj23.ProductCode='41053156';insert prodObj23;
          
           Product2 prodObj24 = new Product2();
          prodObj24.Name = 'Network Services 1.0';
          prodObj24.APTS_Media_High_Level_Code__c = '08';
          prodObj24.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj24.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj24.ProductCode='30405004';insert prodObj24;
          
          Product2 prodObj25 = new Product2();
          prodObj25.Name = 'Network Services 1.0';
          prodObj25.APTS_Media_High_Level_Code__c = '08';
          prodObj25.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj25.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj25.ProductCode='42089524';
          insert prodObj25;
          
           Product2 prodObj26 = new Product2();
          prodObj26.Name = 'Network Services 1.0';
          prodObj26.APTS_Media_High_Level_Code__c = '08';
          prodObj26.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj26.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj26.ProductCode='40043926'; 
          insert prodObj26;
          
           Product2 prodObj27 = new Product2();
          prodObj27.Name = 'Network Services 1.0';
          prodObj27.APTS_Media_High_Level_Code__c = '08';
          prodObj27.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj27.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj27.ProductCode='40043926'; 
          insert prodObj27;
          
           Product2 prodObj28 = new Product2();
          prodObj28.Name = 'Network Services 1.0';
          prodObj28.APTS_Media_High_Level_Code__c = '08';
          prodObj28.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj28.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj28.ProductCode='40485593'; 
          insert prodObj28;
          
           Product2 prodObj29 = new Product2();
          prodObj29.Name = 'Network Services 1.0';
          prodObj29.APTS_Media_High_Level_Code__c = '08';
          prodObj29.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj29.APTS_Corporate_Select__c = 'Primary Essentials';
          prodObj29.ProductCode='40485594'; 
          insert prodObj29;
          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj6.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);
            
           Apttus_Config2__AssetLineItem__c a2 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj1.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);
            Apttus_Config2__AssetLineItem__c a3 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj2.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);
            Apttus_Config2__AssetLineItem__c a4 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj3.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
            Apttus_Config2__AssetLineItem__c a5 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj4.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
            
            Apttus_Config2__AssetLineItem__c a6 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj5.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
            Apttus_Config2__AssetLineItem__c a7 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj6.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                        APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
            Apttus_Config2__AssetLineItem__c a8 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj7.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
            Apttus_Config2__AssetLineItem__c a9 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj8.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1); 
            Apttus_Config2__AssetLineItem__c a10 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj9.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1); 
            Apttus_Config2__AssetLineItem__c a11 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj10.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1); 
            Apttus_Config2__AssetLineItem__c a12 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj11.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                 
             Apttus_Config2__AssetLineItem__c a13 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj13.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                             
             Apttus_Config2__AssetLineItem__c a14 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj14.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
             Apttus_Config2__AssetLineItem__c a15 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj15.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
             Apttus_Config2__AssetLineItem__c a16 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj16.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
              Apttus_Config2__AssetLineItem__c a17 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj17.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
                Apttus_Config2__AssetLineItem__c a18 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj18.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
                  Apttus_Config2__AssetLineItem__c a19 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj19.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);
                   Apttus_Config2__AssetLineItem__c a20 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj20.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                                                                       
                     Apttus_Config2__AssetLineItem__c a21 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__ProductId__c=prodObj21.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
                     Apttus_Config2__AssetLineItem__c a22 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj22.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                
                                                                                         
                 Apttus_Config2__AssetLineItem__c a23 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj23.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);           
                    Apttus_Config2__AssetLineItem__c a24 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj24.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                                                                      
            Apttus_Config2__AssetLineItem__c a25 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj25.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                                                                      
                Apttus_Config2__AssetLineItem__c a26 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                                                                      
            Apttus_Config2__AssetLineItem__c a27 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj26.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);  
             Apttus_Config2__AssetLineItem__c a28 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj4.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);    
            Apttus_Config2__AssetLineItem__c a29 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj1.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);
                 Apttus_Config2__AssetLineItem__c a30 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj2.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__LineType__c ='Product/Service',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                             
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          alist.add(a2);
           alist.add(a3);
            alist.add(a4);
            alist.add(a5);
            alist.add(a6);
            alist.add(a7);
            alist.add(a8);
            alist.add(a9);
            alist.add(a10);
            alist.add(a11);
            alist.add(a12);
            alist.add(a13);
            alist.add(a14);
            alist.add(a15);
            alist.add(a16);
            alist.add(a17);
            alist.add(a18);
            alist.add(a19);
            alist.add(a20);
            alist.add(a21);
            alist.add(a22);
            alist.add(a23);
            alist.add(a24);
            alist.add(a25);
            alist.add(a26);
            alist.add(a27);
            alist.add(a28);
            alist.add(a29);
            alist.add(a30);
          insert alist;
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
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 12, 
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
            
            Apttus_Config2__LineItem__c line11 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
             Apttus_Config2__LineItem__c line62 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
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
            Apttus_Config2__LineStatus__c='New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
            /* Apttus_Config2__LineItem__c line63 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
             Apttus_Config2__LineItem__c line64 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
             Apttus_Config2__LineItem__c line65 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); 
            
             /*Apttus_Config2__LineItem__c line66 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id); */
            
            Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line21 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[1].Id,
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
            Apttus_Config2__LineStatus__c ='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line22 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line23 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[3].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
              Apttus_Config2__LineItem__c line24 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
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
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line26 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[6].Id,
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
            Apttus_Config2__LineStatus__c ='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line25 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[5].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line27 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[7].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line28 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[7].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
             //linObj221
             
             Apttus_Config2__LineItem__c line29 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[9].Id,
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
            Apttus_Config2__LineStatus__c ='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             
             Apttus_Config2__LineItem__c line30 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[10].Id,
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
            Apttus_Config2__LineStatus__c ='New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line31 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[11].Id,
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
            Apttus_Config2__LineStatus__c ='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line32 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[12].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 12, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=10.0,            
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring', 
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years', 
            Apttus_Config2__LineStatus__c ='New',
            APTS_Bridge__c = '1 Month',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
               Apttus_Config2__LineItem__c line33 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[13].Id,
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
            
             Apttus_Config2__LineItem__c line34 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[14].Id,
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
            
            Apttus_Config2__LineItem__c line35 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[15].Id,
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
            
            Apttus_Config2__LineItem__c line36 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[16].Id,
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
            
            
            Apttus_Config2__LineItem__c line37 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[17].Id,
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
            
            Apttus_Config2__LineItem__c line38 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[18].Id,
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
            
             Apttus_Config2__LineItem__c line39 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[19].Id,
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
            
            Apttus_Config2__LineItem__c line40 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[20].Id,
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
            
             Apttus_Config2__LineItem__c line41 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[21].Id,
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
            
            Apttus_Config2__LineItem__c line42 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[22].Id,
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
            
            Apttus_Config2__LineItem__c line43 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[23].Id,
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
            
            Apttus_Config2__LineItem__c line44 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[24].Id,
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
            
             
            Apttus_Config2__LineItem__c line45 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[25].Id,
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
            
              
            Apttus_Config2__LineItem__c line46 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[26].Id,
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
            
              Apttus_Config2__LineItem__c line47= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[27].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
              Apttus_Config2__LineItem__c line48= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[28].Id,
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
            
            Apttus_Config2__LineItem__c line49= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[29].Id,
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
            
             Apttus_Config2__LineItem__c line50= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[30].Id,
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
            
            
             Apttus_Config2__LineItem__c line51= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[31].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line52= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[32].Id,
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
            
             Apttus_Config2__LineItem__c line53= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[33].Id,
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
            
            Apttus_Config2__LineItem__c line54= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[34].Id,
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
            
            Apttus_Config2__LineItem__c line55= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[35].Id,
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
            
             Apttus_Config2__LineItem__c line56= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[36].Id,
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
            
            
            Apttus_Config2__LineItem__c line57= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[37].Id,
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
            
             
            Apttus_Config2__LineItem__c line58= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[38].Id,
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
            
            Apttus_Config2__LineItem__c line59= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[39].Id,
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
            
             Apttus_Config2__LineItem__c line60= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[41].Id,
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
            
             Apttus_Config2__LineItem__c line61= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[40].Id,
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
            
             Apttus_Config2__LineItem__c line66 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[8].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line63= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[41].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line64= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[42].Id,
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
            Apttus_Config2__LineStatus__c='New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line65= new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[43].Id,
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
            Apttus_Config2__LineStatus__c='New',
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line67 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[27].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 50, 
            Apttus_Config2__ItemSequence__c = 50,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
              
            Apttus_Config2__LineItem__c line68 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[2].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 51, 
            Apttus_Config2__ItemSequence__c = 51,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line69 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[3].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 52, 
            Apttus_Config2__ItemSequence__c = 52,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line70 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[3].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 53, 
            Apttus_Config2__ItemSequence__c = 53,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line71 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[4].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 54, 
            Apttus_Config2__ItemSequence__c = 54,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line72 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[5].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 55, 
            Apttus_Config2__ItemSequence__c = 55,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line73 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[5].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 56, 
            Apttus_Config2__ItemSequence__c = 56,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line74 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[6].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 56, 
            Apttus_Config2__ItemSequence__c = 56,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line75 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[7].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 57, 
            Apttus_Config2__ItemSequence__c = 57,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line76 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[9].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 58, 
            Apttus_Config2__ItemSequence__c = 58,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line77 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[10].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 59, 
            Apttus_Config2__ItemSequence__c = 59,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line78 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[20].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 60, 
            Apttus_Config2__ItemSequence__c = 60,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line79 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[11].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 61, 
            Apttus_Config2__ItemSequence__c = 61,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line80 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[12].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 62, 
            Apttus_Config2__ItemSequence__c = 62,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             
            Apttus_Config2__LineItem__c line81 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[13].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 63, 
            Apttus_Config2__ItemSequence__c = 63,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line82 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[14].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 64, 
            Apttus_Config2__ItemSequence__c = 64,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line83 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[15].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 65, 
            Apttus_Config2__ItemSequence__c = 65,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line84 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[16].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 66, 
            Apttus_Config2__ItemSequence__c = 66,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line85 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[17].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 67, 
            Apttus_Config2__ItemSequence__c = 67,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line86 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[18].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 68, 
            Apttus_Config2__ItemSequence__c = 68,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line87 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[19].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 69, 
            Apttus_Config2__ItemSequence__c = 69,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line88 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[20].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 70, 
            Apttus_Config2__ItemSequence__c = 70,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line89 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[22].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 71, 
            Apttus_Config2__ItemSequence__c = 71,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line90 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[23].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 72, 
            Apttus_Config2__ItemSequence__c = 72,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line91 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[24].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 73, 
            Apttus_Config2__ItemSequence__c = 73,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line92 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[25].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 74, 
            Apttus_Config2__ItemSequence__c = 74,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line93 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[27].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 75, 
            Apttus_Config2__ItemSequence__c = 75,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
            Apttus_Config2__LineItem__c line94 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[26].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 76, 
            Apttus_Config2__ItemSequence__c = 76,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
         
             Apttus_Config2__LineItem__c line95 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[42].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 77, 
            Apttus_Config2__ItemSequence__c = 77,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line96 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[29].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 78, 
            Apttus_Config2__ItemSequence__c = 78,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line97 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=prodObj17.id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
 
            Apttus_Config2__LineItem__c line98 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[8].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line99 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[31].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line100 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[43].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line101 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[21].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
              Apttus_Config2__LineItem__c line102 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line103 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
              Apttus_Config2__LineItem__c line104= new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap[27].Id,
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
            Apttus_Config2__LineStatus__c = 'New',
            APTS_Combination_Key__c=attributecombination.id,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
    
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line11,line21,line22,line23,line80,line24,line25,line26,line27,line28,line29,line30,line31,line32,line33,line34,line35,line36,line37,line38,line39,line40,line41,line42,line43,line44,line45,line46,line47,line48,line49,line50,line51,line52,line53,line54,line55,line56,line57,line58,line59,line61,line60,line62,line63,line64,line65,line66,line67,line68,line69,line70,line71,line72,line73,line74,line75,line76,line77,line78,line79,line81,line82,line83,line84,line85,line86,line87,line88,line89,line90,line91,line92,line93,line94,line95,line96,line97,line98,line99,line100,line101,line102,line103,line104};
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
        @isTest static void testMethodTwo(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41817449';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('41817449');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41817449';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 79, 
            Apttus_Config2__ItemSequence__c = 79,
            Apttus_Config2__NetPrice__c=12.0,
            Apttus_Config2__BasePrice__c=12.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            
              Apttus_Config2__LineItem__c line4= new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 14, 
            Apttus_Config2__ItemSequence__c =14,
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
            
             Apttus_Config2__LineItem__c line5= new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 15, 
            Apttus_Config2__ItemSequence__c = 15,
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
            
             Apttus_Config2__LineItem__c line6= new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineType__c = 'Product/Service',            
            Apttus_Config2__LineNumber__c = 16, 
            Apttus_Config2__ItemSequence__c = 16,
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
    
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3,line4,line5,line6};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodThree(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42532854';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42532854');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='42532854';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 3, 
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=12.0,
            Apttus_Config2__BasePrice__c=12.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodFour(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42532855';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42532855');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='42532854';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 2, 
            Apttus_Config2__ItemSequence__c = 2,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 3, 
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=12.0,
            Apttus_Config2__BasePrice__c=12.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
            Apttus_Config2__LineItem__c line4 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 3, 
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=13.0,
            Apttus_Config2__BasePrice__c=13.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            Apttus_Config2__LineItem__c line5 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 3, 
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=14.0,
            Apttus_Config2__BasePrice__c=14.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
            
             Apttus_Config2__LineItem__c line6 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 3, 
            Apttus_Config2__ItemSequence__c = 3,
            Apttus_Config2__NetPrice__c=15.0,
            Apttus_Config2__BasePrice__c=15.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3,line4,line5,line6};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodFive(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42532853';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42532853');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='42532853';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 55, 
          Apttus_Config2__ItemSequence__c = 55,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 65, 
            Apttus_Config2__ItemSequence__c = 65,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 75, 
            Apttus_Config2__ItemSequence__c = 75,
            Apttus_Config2__NetPrice__c=12.0,
            Apttus_Config2__BasePrice__c=12.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodSix(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42532853';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42532853');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='42532853';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 55, 
          Apttus_Config2__ItemSequence__c = 55,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 65, 
            Apttus_Config2__ItemSequence__c = 65,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 75, 
            Apttus_Config2__ItemSequence__c = 75,
            Apttus_Config2__NetPrice__c=12.0,
            Apttus_Config2__BasePrice__c=12.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    
    @isTest static void testMethodSeven(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41986777';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('41986777');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 55, 
          Apttus_Config2__ItemSequence__c = 55,
          Apttus_Config2__NetPrice__c=10.0,
          Apttus_Config2__BasePrice__c=10.0,
          Apttus_Config2__BaseExtendedPrice__c = 15.0,
          Apttus_Config2__AdjustedPrice__c = 15.0,
          Apttus_Config2__OptionPrice__c = 5.0,
          Apttus_Config2__Frequency__c = 'Monthly',
          Apttus_Config2__PriceType__c = 'Recurring', 
          Apttus_Config2__PriceAdjustment__c=0,
          APTS_Contract_Term__c ='3 Years',          
          Apttus_Config2__ChargeType__c = 'Subscription Fee',          
          Apttus_Config2__LineStatus__c = 'New',    //Added by Sakshi for test coverage
          Apttus_Config2__PriceListItemId__c = pliSO.id);
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 53, 
            Apttus_Config2__ItemSequence__c = 53,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 16.0,
            Apttus_Config2__AdjustedPrice__c = 16.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 54, 
            Apttus_Config2__ItemSequence__c = 54,
            Apttus_Config2__NetPrice__c=17.0,
            Apttus_Config2__BasePrice__c=17.0,
            Apttus_Config2__BaseExtendedPrice__c = 17.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodEight(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42118619';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='42118619';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42118619');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 58, 
          Apttus_Config2__ItemSequence__c = 58,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 59, 
            Apttus_Config2__ItemSequence__c = 59,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 60, 
            Apttus_Config2__ItemSequence__c = 60,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    
    @isTest static void testMethodNine(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41053156';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='41053156';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('41053156');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 58, 
          Apttus_Config2__ItemSequence__c = 58,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 59, 
            Apttus_Config2__ItemSequence__c = 59,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 60, 
            Apttus_Config2__ItemSequence__c = 60,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodTen(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='40052427';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('40052427');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 60, 
          Apttus_Config2__ItemSequence__c = 60,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 61, 
            Apttus_Config2__ItemSequence__c = 61,
            Apttus_Config2__NetPrice__c=11.0,
            Apttus_Config2__BasePrice__c=11.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 62, 
            Apttus_Config2__ItemSequence__c = 62,
            Apttus_Config2__NetPrice__c=10.0,
            Apttus_Config2__BasePrice__c=10.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodEleven(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42565209';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42565209');newMap1.add(p1);
         Insert newMap1;
        
         
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 60, 
          Apttus_Config2__ItemSequence__c = 60,
          Apttus_Config2__NetPrice__c=105.0,
          Apttus_Config2__BasePrice__c=105.0,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 61, 
            Apttus_Config2__ItemSequence__c = 61,
            Apttus_Config2__NetPrice__c=116.0,
            Apttus_Config2__BasePrice__c=116.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 62, 
            Apttus_Config2__ItemSequence__c = 62,
            Apttus_Config2__NetPrice__c=108.0,
            Apttus_Config2__BasePrice__c=108.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line3.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodTwelve(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42089522';
        procodes.Name='42089521';
        procodes.Name='40666911';
        procodes.Name='40542344';
        procodes.Name='40483699';
        procodes.Name='40542345';
        procodes.Name='40485592';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='40052427';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42089522');newMap1.add(p1);
         Product2 p2 = NewProduct('42089521');newMap1.add(p2);
         Product2 p3 = NewProduct('40666911');newMap1.add(p3);
         Product2 p4 = NewProduct('40542344');newMap1.add(p4);
         Product2 p5 = NewProduct('40483699');newMap1.add(p5);
         Product2 p6 = NewProduct('40542345');newMap1.add(p6);
         Product2 p7 = NewProduct('40485592');newMap1.add(p7);
            
         Insert newMap1;
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 60, 
          Apttus_Config2__ItemSequence__c = 60,
          Apttus_Config2__NetPrice__c=105.0,
          Apttus_Config2__BasePrice__c=105.0,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 61, 
            Apttus_Config2__ItemSequence__c = 61,
            Apttus_Config2__NetPrice__c=116.0,
            Apttus_Config2__BasePrice__c=116.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 62, 
            Apttus_Config2__ItemSequence__c = 62,
            Apttus_Config2__NetPrice__c=108.0,
            Apttus_Config2__BasePrice__c=108.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodThirteen(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='42564669';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='42564669';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('42564669');newMap1.add(p1);
         Insert newMap1;
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41986777';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 60, 
          Apttus_Config2__ItemSequence__c = 60,
          Apttus_Config2__NetPrice__c=105.0,
          Apttus_Config2__BasePrice__c=105.0,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 61, 
            Apttus_Config2__ItemSequence__c = 61,
            Apttus_Config2__NetPrice__c=116.0,
            Apttus_Config2__BasePrice__c=116.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 62, 
            Apttus_Config2__ItemSequence__c = 62,
            Apttus_Config2__NetPrice__c=108.0,
            Apttus_Config2__BasePrice__c=108.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    @isTest static void testMethodFourteen(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        Product_codes__c procodes= new Product_codes__c();
        procodes.Name='41053157';
        //insert procodes;
        //insert procodes1;
        
        List<Product_codes__c> newList=new List<Product_codes__c>();
        newList.add(procodes);
        
        insert newList;
        
        Map<String,String> mapcheck= new Map<String,String>();
        mapcheck.put(procodes.Name,procodes.Name);
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;
        
        Product_Codes_Set1__c prodSet1= new Product_Codes_Set1__c();
        prodSet1.Name='41053157';
        
        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
        
        //Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('USL_Source_Systems').getRecordTypeId();
        Id ssdRecorType=SObjectType.Source_System_Detail__c.getRecordTypeInfosByDeveloperName().get('USL_Source_Systems').getRecordTypeId();
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

        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(proposal.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        ID cartID = prodConfig.Id;     
         
         
         List<Product2> newMap1 = New List<Product2>();
         
         Product2 p1 = NewProduct('41053157');newMap1.add(p1);
         Insert newMap1;
         
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
          attributevalue1.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue1;
       
          APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
          attributevalue2.Name='Kansas';
          attributevalue2.APTS_Attribute_Name__c='State';          
          attributevalue2.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue2;
       
          APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
          attributevalue3.Name='Marshall';
          attributevalue3.APTS_Attribute_Name__c='State';          
          attributevalue3.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue3;
       
          APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
          attributevalue4.Name='0-2';
          attributevalue4.APTS_Attribute_Name__c='State';          
          attributevalue4.APTS_Product__c=newMap1[0].Id;
          Insert attributevalue4;
       
       
          APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
          attributecombination.Name='Marshall-General';
          attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
          attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
          attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
          attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
          attributecombination.APTS_Price__c=15.00;
          attributecombination.APTS_Product__c=newMap1[0].Id;
          Insert attributecombination;
          
          Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='41053157';insert prodObj;

          
           Apttus_Config2__AssetLineItem__c a1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c=prodObj.id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
                                                                                         APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=1);                                                                            
          List<Apttus_Config2__AssetLineItem__c> alist= new List<Apttus_Config2__AssetLineItem__c>();
          alist.add(a1);
          
          insert alist;
           Apttus_Config2__LineItem__c line1 = new Apttus_Config2__LineItem__c(
          APTS_Deal_Number__c=5,  
          Apttus_Config2__Quantity__c=1,
          Apttus_Config2__ProductId__c=newMap1[0].id,
          Apttus_Config2__ConfigurationId__c = prodConfig.id, 
          Apttus_Config2__LineType__c = 'Product/Service',          
          Apttus_Config2__LineNumber__c = 601, 
          Apttus_Config2__ItemSequence__c = 602,
          Apttus_Config2__NetPrice__c=135.0,
          Apttus_Config2__BasePrice__c=105.0,
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
          
              Apttus_Config2__LineItem__c line2 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 611, 
            Apttus_Config2__ItemSequence__c = 611,
            Apttus_Config2__NetPrice__c=116.0,
            Apttus_Config2__BasePrice__c=116.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'Cancelled',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);

            Apttus_Config2__LineItem__c line3 = new Apttus_Config2__LineItem__c(
            Apttus_Config2__Quantity__c=1,
            Apttus_Config2__ProductId__c=newMap1[0].Id,
            Apttus_Config2__ConfigurationId__c = prodConfig.id, 
            Apttus_Config2__LineNumber__c = 62, 
            Apttus_Config2__ItemSequence__c = 62,
            Apttus_Config2__NetPrice__c=108.0,
            Apttus_Config2__BasePrice__c=108.0,
            Apttus_Config2__BaseExtendedPrice__c = 10.0,
            Apttus_Config2__AdjustedPrice__c = 10.0,
            Apttus_Config2__Frequency__c = 'Monthly',
            Apttus_Config2__PriceType__c = 'Recurring',
            Apttus_Config2__PriceAdjustment__c=0,
            APTS_Contract_Term__c ='3 Years',
            Apttus_Config2__AdjustmentAmount__c = 1,
            Apttus_Config2__ChargeType__c = 'Subscription Fee',
            Apttus_Config2__LineStatus__c = 'New',
            Apttus_Config2__PriceListItemId__c = pliSO2.id);
    
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{line1,line2,line3};
            insert OLItemList;    
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :line1.Id];                                 
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }
    
    @isTest static void testMethodval(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051,41618485';
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
         Product2 p44 = NewProduct('41618485');newMap.add(p44);
         
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
         
        Apttus_Config2__AssetLineItem__c a37 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41618485').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='30010890',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__AttributeValueId__c=attribute4.id);
        
         lNewAsetline.Add(a31);
         lNewAsetline.Add(a32);
         lNewAsetline.Add(a33);
         lNewAsetline.Add(a34);
         lNewAsetline.Add(a35);
         lNewAsetline.Add(a36);
         //lNewAsetline.Add(a37);
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
    
    @isTest static void testMethodval1(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051,41618485';
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
         Product2 p41 = NewProduct('41895338');newMap.add(p41);//41895338
         Product2 p42 = NewProduct('41343504');newMap.add(p42);//41343504
         Product2 p43 = NewProduct('30010890');newMap.add(p43);//30010890
         Product2 p44 = NewProduct('42686641');newMap.add(p44);//41618485
         
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
         
        Apttus_Config2__AssetLineItem__c a37 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= newMapping.get('41618485').id,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='30010890',APTS_PPC_Spend_Type__c  ='New PPC',APTS_PPC_Website_Type__c ='FirmSite',
                                                                                     APTS_Combination_Key__c=com.id,Apttus_Config2__LineType__c ='Product/Service',APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10,Apttus_Config2__AttributeValueId__c=attribute4.id);
        
         lNewAsetline.Add(a31);
         lNewAsetline.Add(a32);
         lNewAsetline.Add(a33);
         lNewAsetline.Add(a34);
         lNewAsetline.Add(a35);
         lNewAsetline.Add(a36);
         //insert lNewAsetLine;
         
         
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
            
            Apttus_Config2__LineItem__c linObj45 = new Apttus_Config2__LineItem__c(
            APTS_Deal_Number__c=5,
            Apttus_Config2__Quantity__c=15,
            Apttus_Config2__ProductId__c=newMap[43].Id,
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
            //List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj45 ,linObj2,linObj44,linObj3,linObj4,linObj5,linObj6,linObj7,linObj8,linObj9,linObj10,linObj11,linObj12,linObj13,linObj14,linObj15,linObj16,linObj,linObj17,linObj18,linObj19,linObj20,linObj21,linObj22,linObj23,linObj24,linObj25,linObj26,linObj27,linObj28,linObj29,linObj30,linObj31,linObj32,linObj33,linObj34,linObj35,linObj36,linObj37,linObj38,linObj39,linObj40,linObj41,linObj42,linObj43,linObj14b,linObj19b};
            List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj45};
            insert OLItemList;
         
                 
            
        List<Apttus_Config2__LineItem__c> lineItemsList = [SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__ConfigurationId__c, Apttus_Config2__ConfigurationId__r.APTS_SSD_Sold_To__c, Apttus_Config2__LineNumber__c,
                                     Apttus_Config2__ItemSequence__c, Apttus_Config2__LineType__c, Apttus_Config2__LineStatus__c, Apttus_Config2__PriceListItemId__r.APTS_Max_Fill_Up_Price__c, Apttus_Config2__NetPrice__c, APTS_Contract_Term__c,
                                     APTS_Years_2_Plus_Default__c, APTS_Years_2_Plus_Adjustment__c, Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c, APTS_Proposal_Group__c, APTS_Group__c, APTS_Bridge__c        
                                     FROM Apttus_Config2__LineItem__c 
                                     WHERE Id = :linObj.Id OR Id = :linObj2.Id];      
        //System.debug('APTS_Proposal_Group__c'+lineItemsList.get(0).APTS_Proposal_Group__c);                             
        Test.startTest();
         Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();                                              
    }   
    
    @isTest static void testMethodval2(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051,41618485';
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
         Product2 p41 = NewProduct('41895338');newMap.add(p41);//41895338
         Product2 p42 = NewProduct('41343504');newMap.add(p42);//41343504
         Product2 p43 = NewProduct('30010890');newMap.add(p43);//30010890
         Product2 p44 = NewProduct('42686641');newMap.add(p44);//41618485
         
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
         
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod3Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
        List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>{asset,asset1};
        insert lNewAsetline;
        
        APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
        caval.Name='test'; 
        insert caval;
         
        APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
        com.Name  ='test';
        com.APTS_Attribute_Value0__c =caval.id;
        com.APTS_Attribute_Value1__c=caval.id;
        com.APTS_Attribute_Value2__c=caval.id;
        com.APTS_Attribute_Value3__c=caval.id;
        insert com;
         
        List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        pliList.add(pliSO);
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        pliList.add(pliSO2); 
        insert pliList;     

        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
        proposalGroup.APTS_Group_Name__c ='Print Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        insert proposalGroup;
        
        List<Apttus_Config2__SummaryGroup__c> sgList = new List<Apttus_Config2__SummaryGroup__c>();
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
        sgList.add(summaryGroup1);
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
        sgList.add(summaryGroup2);
        insert sgList;
         
        List<APTS_Attribute_Value__c> avList = new List<APTS_Attribute_Value__c>();
        APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
        attributevalue1.Name='Insurance';
        attributevalue1.APTS_Attribute_Name__c='State';          
        attributevalue1.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue1);
        APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
        attributevalue2.Name='Kansas';
        attributevalue2.APTS_Attribute_Name__c='State';          
        attributevalue2.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue2);
        APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
        attributevalue3.Name='Marshall';
        attributevalue3.APTS_Attribute_Name__c='State';          
        attributevalue3.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue3);
        APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
        attributevalue4.Name='0-2';
        attributevalue4.APTS_Attribute_Name__c='State';          
        attributevalue4.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue4);
        insert avList;

        APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
        attributecombination.Name='Marshall-General';
        attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
        attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
        attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
        attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
        attributecombination.APTS_Price__c=15.00;
        attributecombination.APTS_Product__c=newMap[1].Id;
        Insert attributecombination;
            
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

        List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj25};
        insert OLItemList;
         
        Test.startTest();
            Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();    
    }  
    
    
    @isTest static void testMethodval3(){
        Apttus_Config2__PriceList__c priceList = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert priceList;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        insert staticCSList ;
        
        APTS_ConfigBundlePageSettings__c bundlePageSettings = new APTS_ConfigBundlePageSettings__c();
        bundlePageSettings.Name = 'Bundle Page Properties';
        bundlePageSettings.Banded_Products_MLL__c = '2Q,49,72,BA,J9,L2,LB,M4,P7,Q3,WA,LB,PX,BB';
        insert bundlePageSettings;
        
        APTS_Product_Rules__c productRule = new APTS_Product_Rules__c(name='1',APTS_Same_Material_on_Account__c = '08BB');
        insert productRule;
        
        APTS_Product_Rules__c productRule1 = new APTS_Product_Rules__c(name='Primary Essentials',APTS_Max_no_of_Points__c = 10, APTS_Max_no_of_Users__c = 5);
        insert productRule1;

        //insertStaticValues();
        WebServiceSettings__c oWebServiceSettings = new WebServiceSettings__c();
        oWebServiceSettings.Service_Unavailable_Message__c = 'Payment Credit Increase Service is currently unavailable'; 
        oWebServiceSettings.Name = 'PaymentCreditIncrease'; 
        oWebServiceSettings.Timeout__c = 120; 
        oWebServiceSettings.Endpoint__c = 'https://dev.securepayment.thomsonreuters.com/TRPaymentGateway/Billing/InvoiceSummary/TRPaymentCreditIncrease'; 
        oWebServiceSettings.Active__c = true;
        insert oWebServiceSettings;

        Account a = APTS_TestDataFactory.createAccount('Test Account');
        
        insert a;
        
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
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
         pageo.Product_Code__c='41093075,41093077,41093076,40987609,41093074,41819162,41874867,41819164,41817448,41767150,41915207,41893121,41822783,41771511,42124051,41618485';
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
         Product2 p41 = NewProduct('41895338');newMap.add(p41);//41895338
         Product2 p42 = NewProduct('41343504');newMap.add(p42);//41343504
         Product2 p43 = NewProduct('30010890');newMap.add(p43);//30010890
         Product2 p44 = NewProduct('42686641');newMap.add(p44);//41618485
         
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
         
        Apttus_Config2__AssetLineItem__c asset = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prodObj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1));
        Apttus_Config2__AssetLineItem__c asset1 = new Apttus_Config2__AssetLineItem__c(name='test',Apttus_Config2__ProductId__c= prod3Obj.Id ,APTS_SSD_Sold_To__c = accountSSD.Id,Apttus_Config2__AssetStatus__c='Activated',APTS_Subscription_Number__c='40656551',
        APTS_Deal_Type__c='WCMP', APTS_Info_PlanType__c='S00',Apttus_Config2__StartDate__c= Date.newInstance(2018, 1, 1),Apttus_Config2__Quantity__c=10);
        List<Apttus_Config2__AssetLineItem__c> lNewAsetline = New List<Apttus_Config2__AssetLineItem__c>{asset,asset1};
        insert lNewAsetline;
        
        APTS_Attribute_Value__c  caval = New APTS_Attribute_Value__c ();
        caval.Name='test'; 
        insert caval;
         
        APTS_Attribute_Value_Combination__c  com = New APTS_Attribute_Value_Combination__c ();
        com.Name  ='test';
        com.APTS_Attribute_Value0__c =caval.id;
        com.APTS_Attribute_Value1__c=caval.id;
        com.APTS_Attribute_Value2__c=caval.id;
        com.APTS_Attribute_Value3__c=caval.id;
        insert com;
         
        List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO.APTS_Max_Fill_Up_Price__c = 5;
        pliList.add(pliSO);
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__PriceListId__c = priceList.Id;
        pliSO2.APTS_Max_Fill_Up_Price__c = 5;
        pliList.add(pliSO2); 
        insert pliList;     

        APTS_Group__c proposalGroup =new APTS_Group__c();
        proposalGroup.APTS_GrossAmount__c = 0;
        proposalGroup.APTS_Group_Name_Original__c ='Print Bundle A';
        proposalGroup.APTS_Group_Name__c ='Print Bundle A';
        proposalGroup.APTS_NetAmount__c=0;
        insert proposalGroup;
        
        List<Apttus_Config2__SummaryGroup__c> sgList = new List<Apttus_Config2__SummaryGroup__c>();
        Apttus_Config2__SummaryGroup__c summaryGroup1 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 1,
                Apttus_Config2__LineNumber__c = 1
            );
        sgList.add(summaryGroup1);
        Apttus_Config2__SummaryGroup__c summaryGroup2 = new Apttus_Config2__SummaryGroup__c(
                Apttus_Config2__ConfigurationId__c = prodConfig.id, 
                Name = 'WEST PROFLEX Bundle A - Test group 2',
                Apttus_Config2__LineType__c = 'Group Total',
                Apttus_Config2__ItemSequence__c = 2,
                Apttus_Config2__LineNumber__c = 1
            );
        sgList.add(summaryGroup2);
        insert sgList;
         
        List<APTS_Attribute_Value__c> avList = new List<APTS_Attribute_Value__c>();
        APTS_Attribute_Value__c attributevalue1 = new APTS_Attribute_Value__c();
        attributevalue1.Name='Insurance';
        attributevalue1.APTS_Attribute_Name__c='State';          
        attributevalue1.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue1);
        APTS_Attribute_Value__c attributevalue2 = new APTS_Attribute_Value__c();
        attributevalue2.Name='Kansas';
        attributevalue2.APTS_Attribute_Name__c='State';          
        attributevalue2.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue2);
        APTS_Attribute_Value__c attributevalue3 = new APTS_Attribute_Value__c();
        attributevalue3.Name='Marshall';
        attributevalue3.APTS_Attribute_Name__c='State';          
        attributevalue3.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue3);
        APTS_Attribute_Value__c attributevalue4 = new APTS_Attribute_Value__c();
        attributevalue4.Name='0-2';
        attributevalue4.APTS_Attribute_Name__c='State';          
        attributevalue4.APTS_Product__c=newMap[1].Id;
        avList.add(attributevalue4);
        insert avList;

        APTS_Attribute_Value_Combination__c attributecombination = new APTS_Attribute_Value_Combination__c();
        attributecombination.Name='Marshall-General';
        attributecombination.APTS_Attribute_Value0__c=attributevalue1.id;
        attributecombination.APTS_Attribute_Value1__c=attributevalue2.id;
        attributecombination.APTS_Attribute_Value2__c=attributevalue3.id;
        attributecombination.APTS_Attribute_Value3__c=attributevalue4.id;
        attributecombination.APTS_Price__c=15.00;
        attributecombination.APTS_Product__c=newMap[1].Id;
        Insert attributecombination;
            
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
            
        List<Apttus_Config2__LineItem__c> OLItemList = new List<Apttus_Config2__LineItem__c>{linObj37};
        insert OLItemList;
         
        Test.startTest();
            Apttus_Config2.CallbackTester.testValidationCallback
                                              ( cartID
                                              , OLItemList
                                              , null
                                              , new APTS_Validation_Callback ());   
        Test.stopTest();    
    }
    
    @isTest static void insertStaticValues(){
    
          LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{  new Static_Values__c(name='skiptoNullifyCreditCardDetails', value__c='Guest')
                                                                         
                                                                         };
        
        insert staticCSList ;
    
    }
        
}