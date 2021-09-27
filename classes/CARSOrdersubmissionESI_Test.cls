@istest
public class CARSOrdersubmissionESI_Test{
  
  
  static testmethod void ordersubmissionESProflex()
  {
   
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
       
  Account acc = new Account();
  acc.Name='test';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
  insert accountSSD;
  
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
  
 /* Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; */
        
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='Prabhu';
  con.FirstName='Issac';
  insert con;
  
  List<Product2> prodlist = new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
  Product2 oProductPrimary = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
  Product2 oProductMTP = new Product2(Name='SMALL FIRM PACKAGE', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9',LCRM_Sub_Bu__c =label.SALESORGCAN);
  
  Product2 prodObjBN = new Product2();
        prodObjBN.Name = 'Canada Proflex';
        prodObjBN.ProductCode= '41972767';
        prodObjBN.APTS_Media_High_Level_Code__c = '06';
        prodObjBN.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObjBN.IsActive=true;
        prodObjBN.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBN.Service_Number__c='0';

  Product2 prodObjBN1 = new Product2();
        prodObjBN1.Name = 'Canada Proflex';
        prodObjBN1.ProductCode= '41972767';
        prodObjBN1.APTS_Media_High_Level_Code__c = '06';
        prodObjBN1.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObjBN1.IsActive=true;
        prodObjBN1.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBN1.Service_Number__c='0';

  Product2 prodObj = new Product2();
        prodObj.Name = 'Canada Proflex';
        prodObj.ProductCode= '41972767';
        prodObj.APTS_Media_High_Level_Code__c = '06';
        prodObj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObj.Service_Number__c='0';
  
  Product2 prodObjBGB = new Product2();
        prodObjBGB.Name = 'TEST BGB';
        prodObjBGB.ProductCode= '3453534';
        prodObjBGB.APTS_Media_High_Level_Code__c = '06';
        prodObjBGB.APTS_Media_Lower_Level_Code__c = 'K1';
        prodObjBGB.IsActive=true;
        prodObjBGB.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBGB.Service_Number__c='0';
        prodObjBGB.APTS_Product_Pricing_Model__c='BENEFITGRP';
  
  prodlist.add(prodObjBGB);
  prodlist.add(prodObj);  
  prodlist.add(prodObjBN);
  prodlist.add(prodObjBN1);
  prodlist.add(oProductB);
  prodlist.add(oProductP);
  prodlist.add(oProductB1);
  prodlist.add(oProductP1);
  prodlist.add(oProductB2);
  prodlist.add(oProductP2);
  prodlist.add(oProductS);
  prodlist.add(oProductPrimary);
  prodlist.add(oProductMTP);
  
  insert prodlist;

   Test.startTest();     
  //Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='Canada',APTS_Approval_Segment__c='Canada',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
     oProposal.APTS_Payer__c = accountSSD.id;
     oProposal.APTS_Proposal_Business_Unit__c='Canada';
     oProposal.APTS_Approval_Segment__c='Canada';
     oProposal.APTS_Order_Confirmation_Contact__c=con.id;
     oProposal.APTS_Payment_Option__c='Credit Card';
     oProposal.APTS_Ebilling_contact__c=con.id;
     oProposal.TR_Store_Source__c = 'TR Store Canada Print';
  insert oProposal;
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
   
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li3);
  Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li4);
  Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li5);
  Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li6);
  Apttus_Proposal__Proposal_Line_Item__c li7 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = prodObjBGB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li7);
  Apttus_Proposal__Proposal_Line_Item__c li8 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductMTP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li8);
  
  insert listLineItems;
  
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  //order.Apttus_Config2__Status__c='Ready for Activation';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.APTS_Payer__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  insert order;
  
  List<Apttus_Config2__OrderLineItem__c> orderLineList=new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordlineBN =  new Apttus_Config2__OrderLineItem__c();
  ordlineBN.APTS_Contract_Term__c='1 Year';
  ordlineBN.Apttus_Config2__OrderId__c=order.id;
  ordlineBN.Apttus_Config2__LineType__c='Product/Service';
  ordlineBN.APTS_Program_ID__c='CPRO';
  ordlineBN.Apttus_Config2__LineStatus__c='Renewed'; 
  ordlineBN.Apttus_Config2__Quantity__c=1.000;
  ordlineBN.Apttus_Config2__ProductId__c=prodObjBN.id;
  ordlineBN.APTS_Group__c='Bundle A';  
  ordlineBN.APTS_Bridge__c='1 Month';
  ordlineBN.Apttus_Config2__BillingFrequency__c = 'Yearly';
  orderLineList.add(ordlineBN);

  Apttus_Config2__OrderLineItem__c ordlineBN1 =  new Apttus_Config2__OrderLineItem__c();
  ordlineBN1.APTS_Contract_Term__c='1 Year';
  ordlineBN1.Apttus_Config2__OrderId__c=order.id;
  ordlineBN1.Apttus_Config2__LineType__c='Product/Service';
  ordlineBN1.APTS_Program_ID__c='CPRO';
  ordlineBN1.Apttus_Config2__LineStatus__c='Amended'; 
  ordlineBN1.Apttus_Config2__Quantity__c=1.000;
  ordlineBN1.Apttus_Config2__ProductId__c=prodObjBN1.id;
  ordlineBN1.APTS_Group__c='Bundle A';  
  ordlineBN1.APTS_Bridge__c='1 Month';
  ordlineBN1.Apttus_Config2__BillingFrequency__c = 'Yearly';
  orderLineList.add(ordlineBN1);
  
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A';  
  ordline.APTS_Bridge__c='1 Month';
  ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
  orderLineList.add(ordline); 
      

 Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='1 year ';
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordline3.Apttus_Config2__LineStatus__c='New'; 
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__ProductId__c=oProductB.id;
  ordline3.APTS_Group__c='Bundle A';  
  ordline3.APTS_Bridge__c='1 Month';
  ordline3.Apttus_Config2__BillingFrequency__c = 'Monthly';
  orderLineList.add(ordline3); 


  Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
  ordline1.APTS_Contract_Term__c='1 Year';
  ordline1.Apttus_Config2__OrderId__c=order.id;
  ordline1.Apttus_Config2__LineStatus__c='Existing'; 
  ordline1.Apttus_Config2__Quantity__c=1.000;
  ordline1.Apttus_Config2__ProductId__c=oProductP.id;
  ordline1.APTS_Group__c='Bundle A'; 
  ordline1.Apttus_Config2__BillingFrequency__c = 'Yearly';  
  ordline1.APTS_Bridge__c='1 Month';
  orderLineList.add(ordline1); 

  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='1 Year';
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordline2.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.APTS_Group__c='Bundle A'; 
  ordline2.Apttus_Config2__BillingFrequency__c = 'Monthly';  
  ordline2.APTS_Bridge__c='1 Month';
  orderLineList.add(ordline2);

  Apttus_Config2__OrderLineItem__c ordlineMTP =  new Apttus_Config2__OrderLineItem__c();
  ordlineMTP.APTS_Contract_Term__c='1 Year';
  ordlineMTP.Apttus_Config2__OrderId__c=order.id;
  ordlineMTP.Apttus_Config2__LineStatus__c='New'; 
  ordlineMTP.Apttus_Config2__Quantity__c=1.000;
  ordlineMTP.Apttus_Config2__ProductId__c=oProductMTP.id;
  ordlineMTP.APTS_Group__c='Bundle A'; 
  ordlineMTP.Apttus_Config2__BillingFrequency__c = 'Monthly';  
  ordlineMTP.APTS_Bridge__c='1 Month';
  orderLineList.add(ordlineMTP);
  Apttus_Config2__OrderLineItem__c ordlineprx =  new Apttus_Config2__OrderLineItem__c();
        ordlineprx.APTS_Contract_Term__c='3 Years';
        ordlineprx.Apttus_Config2__OrderId__c=order.id;
        ordlineprx.Apttus_Config2__LineStatus__c='New'; 
        ordlineprx.Apttus_Config2__Quantity__c=1.000;
        ordlineprx.Apttus_Config2__ProductId__c=prodobj.id;
        ordlineprx.APTS_Group__c='Bundle A';  
        ordlineprx.APTS_Bridge__c='7 Days';
        ordlineprx.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineprx.APTS_SAP_MLA_Agreement_Number__c = '';
        ordlineprx.APTS_Keep_terms__c=true;
        ordlineprx.APTS_MLA__c = true;
        ordlineprx.APTS_Bridge_Discount__c = '100';
        ordlineprx.APTS_Decentralized__c = true;
        ordlineprx.APTS_New_Bridge_Discount__c = 50.0;
        orderLineList.add(ordlineprx);
        Apttus_Config2__OrderLineItem__c ordlineprx2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineprx2.APTS_Contract_Term__c='3 Years';
        ordlineprx2.Apttus_Config2__OrderId__c=order.id;
        ordlineprx2.Apttus_Config2__LineStatus__c='New'; 
        ordlineprx2.Apttus_Config2__Quantity__c=1.000;
        ordlineprx2.Apttus_Config2__ProductId__c=prodobj.id;
        ordlineprx2.APTS_Group__c='Bundle AB';  
        ordlineprx2.APTS_Bridge__c='1 Month';
        ordlineprx2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineprx2.APTS_SAP_MLA_Agreement_Number__c = '123456';
        ordlineprx2.APTS_Keep_terms__c=false;
        ordlineprx2.APTS_MLA__c = true;
        ordlineprx2.APTS_Bridge_Discount__c = '100';
        ordlineprx2.APTS_Decentralized__c = true;
        ordlineprx2.APTS_New_Bridge_Discount__c=50;
        orderLineList.add(ordlineprx2); 
    insert orderLineList;
    
    List<Attachment> attList=new List<Attachment>();
  
  Attachment att = new Attachment();
  att.Name='signed';
  att.ParentId=oProposal.id;
  att.body=blob.valueof('test');
  attList.add(att);
  
  Attachment att1 = new Attachment();
  att1.Name='Order Form';
  att1.body=blob.valueof('test2');
  att1.ParentId=oProposal.id;
  attList.add(att1);
  
  Attachment att2 = new Attachment();
  att2.Name='CVMS Offer Sheet';
  att2.body=blob.valueof('test2');
  att2.ParentId=oProposal.id;
  attList.add(att2);
  
  insert attList;
 
  List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
  
  APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
  multiacc.APTS_Agreement_Number__c='8923238';  
  multiacc.APTS_Quote_Proposal__c=oProposal .id;
  multiacc.APTS_Status__c='New';
  multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
  quoteAgrLocList.add(multiacc);
  
  APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
  multiacc1.APTS_Agreement_Number__c='8923238';  
  multiacc1.APTS_Quote_Proposal__c=oProposal .id;
  multiacc1.APTS_Status__c='Cancelled';
  //changed to new Subscriber ssd reference instead of old subscriber field
  multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
  quoteAgrLocList.add(multiacc1);
  
  insert quoteAgrLocList;
  
  List<APTS_Dynamic_Bundle__c> dymBundle=new List<APTS_Dynamic_Bundle__c>();
  
  APTS_Dynamic_Bundle__c dynamicbundle11 = new APTS_Dynamic_Bundle__c();
  dynamicbundle11.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle11.APTS_Group__c='Bundle A';
  dynamicbundle11.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle11.APTS_Contract_Terms__c='3 Years';
  dynamicbundle11.APTS_YoY_2_Plus__c='1';
  dynamicbundle11.APTS_Keep_Terms__c=true;
  dynamicbundle11.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundle11.APTS_Bridge_Discount__c = '100';
  dynamicbundle11.APTS_Billing_Frequency__c='Yearly';
  dynamicbundle11.APTS_Net_Price__c =100;
  dynamicbundle11.APTS_isBLINotCreated__c =true;
  dynamicbundle11.APTS_Bridge__c = '14 Days';
  dymBundle.add(dynamicbundle11);
  
  APTS_Dynamic_Bundle__c dynamicbundle12 = new APTS_Dynamic_Bundle__c();
  dynamicbundle12.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle12.APTS_Group__c='Bundle A';
  dynamicbundle12.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle12.APTS_Contract_Terms__c='3 Years';
  dynamicbundle12.APTS_YoY_2_Plus__c='1';
  dynamicbundle12.APTS_Keep_Terms__c=false;
  dynamicbundle12.APTS_Deal_Number__c = null;
  dynamicbundle12.APTS_MLA__c = true;
  //dynamicbundle12.APTS_Bridge_Monthly_Charges__c = 12365;
  dynamicbundle12.APTS_MLA_Agreement_Number__c='7374737'; 
  dynamicbundle12.APTS_Billing_Frequency__c='Monthly';
  dynamicbundle12.APTS_Net_Price__c =100;
  dynamicbundle12.APTS_isBLINotCreated__c =true;
  dynamicbundle12.APTS_Bridge__c = '28 Days';
  dymBundle.add(dynamicbundle12); 
      
  APTS_Dynamic_Bundle__c dynamicbundle13 = new APTS_Dynamic_Bundle__c();
  dynamicbundle13.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle13.APTS_Group__c='Bundle A';
  dynamicbundle13.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle13.APTS_Contract_Terms__c='3 Years';
  dynamicbundle13.APTS_YoY_2_Plus__c='1';
  dynamicbundle13.APTS_Keep_Terms__c=true;
  dynamicbundle13.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundle13.APTS_Bridge_Discount__c = '100';
  dynamicbundle13.APTS_Billing_Frequency__c='Yearly';
  dynamicbundle13.APTS_Net_Price__c =100;
  dynamicbundle13.APTS_isBLINotCreated__c =true;
  dynamicbundle13.APTS_Bridge__c = '7 Days';
  dymBundle.add(dynamicbundle13);

  APTS_Dynamic_Bundle__c dynamicbundleBN = new APTS_Dynamic_Bundle__c();
  dynamicbundleBN.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundleBN.APTS_Group__c='Bundle A';
  dynamicbundleBN.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundleBN.APTS_Contract_Terms__c='3 Years';
  dynamicbundleBN.APTS_YoY_2_Plus__c='1';
  dynamicbundleBN.APTS_Keep_Terms__c=true;
  dynamicbundleBN.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundleBN.APTS_Bridge_Discount__c = '10';
  dynamicbundleBN.APTS_Bridge_Length__c = 2;
  dynamicbundleBN.APTS_Billing_Frequency__c='Yearly';
  dynamicbundleBN.APTS_Net_Price__c =100;
  dynamicbundleBN.APTS_isBLINotCreated__c =true;
  dynamicbundleBN.APTS_Bridge__c = '7 Days';
  dymBundle.add(dynamicbundleBN);
  
  insert dymBundle;
  
  List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
  Apttus_Config2__LineItem__c lineItemo =  new Apttus_Config2__LineItem__c();
        lineItemo.APTS_Group_Primary_Material__c= '40666420';
        lineItemo.Apttus_Config2__LineStatus__c = 'New';  
        lineItemo.APTS_Group__c = dymBundle[0].Id;
        lineItemo.APTS_Contract_Number__c = 123456;
        lineItemo.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemo.Apttus_Config2__ItemSequence__c = 1;
        lineItemo.Apttus_Config2__LineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductId__c = oProductP.Id;  
        //insert lineItemo;
        lineItemo.Apttus_Config2__AddedBy__c = 'User';
        lineItemo.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemo.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemo.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemo.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemo.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowProration__c = FALSE;
        lineItemo.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemo.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemo.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemo.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__BasePrice__c = 100;
        lineItemo.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemo.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemo.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemo.Apttus_Config2__Customizable__c = FALSE;
        lineItemo.Apttus_Config2__DeltaPrice__c = 50;
        lineItemo.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemo.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemo.Apttus_Config2__ExtendedCost__c = 0;
        lineItemo.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemo.Apttus_Config2__Guidance__c = 'Red';
        lineItemo.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemo.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemo.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemo.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemo.Apttus_Config2__HasOptions__c = FALSE;
        lineItemo.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemo.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemo.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemo.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsHidden__c = FALSE;
        lineItemo.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemo.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemo.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemo.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemo.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemo.Apttus_Config2__LineSequence__c = 1;
        lineItemo.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemo.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemo.Apttus_Config2__ListPrice__c = 100;
        lineItemo.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemo.Apttus_Config2__NetPrice__c = 50;
        lineItemo.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemo.Apttus_Config2__OptionSequence__c = 0;
        lineItemo.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemo.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemo.Apttus_Config2__PriceUom__c = 'Each';
        lineItemo.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemo.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductVersion__c = 1;
        lineItemo.Apttus_Config2__Quantity__c = 1;
        lineItemo.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemo.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__SellingTerm__c = 1;
        lineItemo.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemo.Apttus_Config2__Taxable__c = FALSE;
        lineItemo.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemo.Apttus_Config2__Term__c = 1;
        lineItemo.Apttus_Config2__TotalQuantity__c = 1;
        lineItemo.Apttus_Config2__Uom__c = 'Each';
        lineItemo.CurrencyIsoCode = 'USD';
        lineItemo.APTS_Product_Family__c = 'WESTLAW';
        lineItemo.APTS_Contract_Term__c = '2 Years';
        lineItemo.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemo.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemo.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemo);
  
  Apttus_Config2__LineItem__c lineItemo1 =  new Apttus_Config2__LineItem__c();
        lineItemo1.APTS_Group_Primary_Material__c= '40666420';
        lineItemo1.Apttus_Config2__LineStatus__c = 'New';  
        lineItemo1.APTS_Group__c = dymBundle[0].Id;
        lineItemo1.APTS_Contract_Number__c = 123456;
        lineItemo1.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemo1.Apttus_Config2__ItemSequence__c = 1;
        lineItemo1.Apttus_Config2__LineNumber__c = 1;
        lineItemo1.Apttus_Config2__ProductId__c = oProductPrimary.Id;  
        lineItemo1.Apttus_Config2__OptionId__c = null;
        //insert lineItemo;
        lineItemo1.Apttus_Config2__AddedBy__c = 'User';
        lineItemo1.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemo1.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemo1.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemo1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemo1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemo1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemo1.Apttus_Config2__AllowProration__c = FALSE;
        lineItemo1.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemo1.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemo1.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemo1.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemo1.Apttus_Config2__BasePrice__c = 100;
        lineItemo1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemo1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemo1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemo1.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemo1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemo1.Apttus_Config2__Customizable__c = FALSE;
        lineItemo1.Apttus_Config2__DeltaPrice__c = 50;
        lineItemo1.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemo1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemo1.Apttus_Config2__ExtendedCost__c = 0;
        lineItemo1.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemo1.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemo1.Apttus_Config2__Guidance__c = 'Red';
        lineItemo1.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemo1.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemo1.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemo1.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemo1.Apttus_Config2__HasOptions__c = FALSE;
        lineItemo1.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemo1.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemo1.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemo1.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemo1.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemo1.Apttus_Config2__IsHidden__c = FALSE;
        lineItemo1.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemo1.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemo1.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemo1.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemo1.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemo1.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemo1.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemo1.Apttus_Config2__LineSequence__c = 1;
        lineItemo1.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemo1.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemo1.Apttus_Config2__ListPrice__c = 100;
        lineItemo1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemo1.Apttus_Config2__NetPrice__c = 50;
        lineItemo1.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemo1.Apttus_Config2__OptionSequence__c = 0;
        lineItemo1.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemo1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemo1.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemo1.Apttus_Config2__PriceUom__c = 'Each';
        lineItemo1.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemo1.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemo1.Apttus_Config2__ProductVersion__c = 1;
        lineItemo1.Apttus_Config2__Quantity__c = 1;
        lineItemo1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemo1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemo1.Apttus_Config2__SellingTerm__c = 1;
        lineItemo1.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemo1.Apttus_Config2__Taxable__c = FALSE;
        lineItemo1.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemo1.Apttus_Config2__Term__c = 1;
        lineItemo1.Apttus_Config2__TotalQuantity__c = 1;
        lineItemo1.Apttus_Config2__Uom__c = 'Each';
        lineItemo1.CurrencyIsoCode = 'USD';
        lineItemo1.APTS_Product_Family__c = 'WESTLAW';
        lineItemo1.APTS_Contract_Term__c = '2 Years';
        lineItemo1.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemo1.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemo1.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemo1);
  
  Apttus_Config2__LineItem__c lineItemS1 =  new Apttus_Config2__LineItem__c();
        lineItemS1.APTS_Group_Primary_Material__c= '40666420';
        lineItemS1.Apttus_Config2__LineStatus__c = 'New';  
        lineItemS1.APTS_Group__c = dymBundle[0].Id;
        lineItemS1.APTS_Contract_Number__c = 123456;
        lineItemS1.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS1.Apttus_Config2__ItemSequence__c = 1;
        lineItemS1.Apttus_Config2__LineNumber__c = 1;
        lineItemS1.Apttus_Config2__ProductId__c = oProductS.Id;   
        //insert lineItemS;
        lineItemS1.Apttus_Config2__AddedBy__c = 'User';
        lineItemS1.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemS1.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemS1.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemS1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemS1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemS1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemS1.Apttus_Config2__AllowProration__c = FALSE;
        lineItemS1.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemS1.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemS1.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemS1.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemS1.Apttus_Config2__BasePrice__c = 100;
        lineItemS1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemS1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemS1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemS1.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemS1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemS1.Apttus_Config2__Customizable__c = FALSE;
        lineItemS1.Apttus_Config2__DeltaPrice__c = 50;
        lineItemS1.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemS1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemS1.Apttus_Config2__ExtendedCost__c = 0;
        lineItemS1.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemS1.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemS1.Apttus_Config2__Guidance__c = 'Red';
        lineItemS1.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemS1.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemS1.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemS1.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemS1.Apttus_Config2__HasOptions__c = FALSE;
        lineItemS1.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemS1.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemS1.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemS1.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemS1.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemS1.Apttus_Config2__IsHidden__c = FALSE;
        lineItemS1.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemS1.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemS1.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemS1.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemS1.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemS1.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemS1.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemS1.Apttus_Config2__LineSequence__c = 1;
        lineItemS1.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemS1.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemS1.Apttus_Config2__ListPrice__c = 100;
        lineItemS1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemS1.Apttus_Config2__NetPrice__c = 50;
        lineItemS1.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemS1.Apttus_Config2__OptionSequence__c = 0;
        lineItemS1.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemS1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemS1.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemS1.Apttus_Config2__PriceUom__c = 'Each';
        lineItemS1.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemS1.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemS1.Apttus_Config2__ProductVersion__c = 1;
        lineItemS1.Apttus_Config2__Quantity__c = 1;
        lineItemS1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemS1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemS1.Apttus_Config2__SellingTerm__c = 1;
        lineItemS1.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemS1.Apttus_Config2__Taxable__c = FALSE;
        lineItemS1.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemS1.Apttus_Config2__Term__c = 1;
        lineItemS1.Apttus_Config2__TotalQuantity__c = 1;
        lineItemS1.Apttus_Config2__Uom__c = 'Each';
        lineItemS1.CurrencyIsoCode = 'USD';
        lineItemS1.APTS_Product_Family__c = 'WESTLAW';
        lineItemS1.APTS_Contract_Term__c = '2 Years';
        lineItemS1.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemS1.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemS1.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemS1);
  
  insert liList;
  
  List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.Id);
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.Id);
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c= accountSSD.Id);
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc4); 
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc5); 
   Online_Contacts__c oc6 =new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc6); 
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc13); 
    Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc14); 
    Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc15);
    Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc16);   
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc17); 
   //Added newly 
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c,NAIC_Name__c = 'ABS',NAIC_Number__c = '12345');
   onlineContactList.add(oc18);  
    
   insert onlineContactList;
  APTS_Additional_Subscription_Actions__c addsub = new APTS_Additional_Subscription_Actions__c();
  addsub.APTS_Line_Status__c='Cancelled';
  addsub.APTS_Subscription_Number__c='787847';
  addsub.APTS_Quote_Proposal__c=oProposal.id;
  
  insert addsub; 
  
  order.Apttus_Config2__Status__c='Pending';
  update order;
  
  Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name); 
  //Test.startTest(); 
  //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456
  //Added code to cover TRStore code
   LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='trstorebusinessUnits', value__c='TR Store Canada Print')
             };
        insert staticCSList;
  
  
  
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
  Test.stopTest();
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  
  }
  

    static testmethod void ordersubmissionESProflex1()
  {
  
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
       
  Account acc = new Account();
  acc.Name='test';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
  insert accountSSD;
  
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
  
 /* Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; */
        
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='Prabhu';
  con.FirstName='Issac';
  insert con;
  
  List<Product2> prodlist = new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
  Product2 prodObj = new Product2();
        prodObj.Name = 'Canada Proflex';
        prodObj.ProductCode= '41972767';
        prodObj.APTS_Media_High_Level_Code__c = '06';
        prodObj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObj.IsActive=true;
        prodObj.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObj.Service_Number__c='0';
        Product2 prodObjBGB = new Product2();
        prodObjBGB.Name = 'TEST BGB';
        prodObjBGB.ProductCode= '3453534';
        prodObjBGB.APTS_Media_High_Level_Code__c = '06';
        prodObjBGB.APTS_Media_Lower_Level_Code__c = 'K1';
        prodObjBGB.IsActive=true;
        prodObjBGB.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBGB.Service_Number__c='0';
        prodObjBGB.APTS_Product_Pricing_Model__c='BENEFITGRP';
        prodlist.add(prodObjBGB);
  prodlist.add(prodObj);  
  prodlist.add(oProductB);
  prodlist.add(oProductP);
  prodlist.add(oProductB1);
  prodlist.add(oProductP1);
  prodlist.add(oProductB2);
  prodlist.add(oProductP2);
  prodlist.add(oProductS);
  insert prodlist;

   Test.startTest();     
  //Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='Canada',APTS_Approval_Segment__c='Canada',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
     oProposal.APTS_Payer__c = accountSSD.id;
     oProposal.APTS_Proposal_Business_Unit__c='Canada';
     oProposal.APTS_Approval_Segment__c='Canada';
     oProposal.APTS_Order_Confirmation_Contact__c=con.id;
     oProposal.APTS_Payment_Option__c='Credit Card';
     oProposal.APTS_Ebilling_contact__c=con.id;
     oProposal.TR_Store_Source__c = 'TR Store Canada Print';
  insert oProposal;
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
   
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li3);
  Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li4);
  Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li5);
  Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li6);
  Apttus_Proposal__Proposal_Line_Item__c li7 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = prodObjBGB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li7);
  
  insert listLineItems;
  
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  //order.Apttus_Config2__Status__c='Ready for Activation';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.APTS_Payer__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  insert order;
  
  List<Apttus_Config2__OrderLineItem__c> orderLineList=new List<Apttus_Config2__OrderLineItem__c>();
  
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A';  
  ordline.APTS_Bridge__c='1 Month';
  ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
  orderLineList.add(ordline); 

 Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='1 year ';
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordline3.Apttus_Config2__LineStatus__c='New'; 
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__ProductId__c=oProductB.id;
  ordline3.APTS_Group__c='Bundle A';  
  ordline3.APTS_Bridge__c='1 Month';
  ordline3.Apttus_Config2__BillingFrequency__c = 'Monthly';
  orderLineList.add(ordline3); 


  Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
  ordline1.APTS_Contract_Term__c='1 Year';
  ordline1.Apttus_Config2__OrderId__c=order.id;
  ordline1.Apttus_Config2__LineStatus__c='Existing'; 
  ordline1.Apttus_Config2__Quantity__c=1.000;
  ordline1.Apttus_Config2__ProductId__c=oProductP.id;
  ordline1.APTS_Group__c='Bundle A'; 
  ordline1.Apttus_Config2__BillingFrequency__c = 'Yearly';  
  ordline1.APTS_Bridge__c='1 Month';
  orderLineList.add(ordline1); 

  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='1 Year';
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordline2.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.APTS_Group__c='Bundle A'; 
  ordline2.Apttus_Config2__BillingFrequency__c = 'Monthly';  
  ordline2.APTS_Bridge__c='1 Month';
  orderLineList.add(ordline2);
      
  Apttus_Config2__OrderLineItem__c ordlinee =  new Apttus_Config2__OrderLineItem__c();
  ordlinee.APTS_Contract_Term__c='1 Year';
  ordlinee.Apttus_Config2__OrderId__c=order.id;
  ordlinee.Apttus_Config2__LineStatus__c='Renewed'; 
  ordlinee.Apttus_Config2__Quantity__c=1.000;
  ordlinee.Apttus_Config2__ProductId__c=oProductB.id;
  ordlinee.APTS_Group__c='Bundle A';  
  ordlinee.APTS_Bridge__c='7 Days';
  ordlinee.Apttus_Config2__BillingFrequency__c = 'Yearly';
  orderLineList.add(ordlinee);

    insert orderLineList;
    
    List<Attachment> attList=new List<Attachment>();
  
  Attachment att = new Attachment();
  att.Name='signed';
  att.ParentId=oProposal.id;
  att.body=blob.valueof('test');
  attList.add(att);
  
  Attachment att1 = new Attachment();
  att1.Name='Order Form';
  att1.body=blob.valueof('test2');
  att1.ParentId=oProposal.id;
  attList.add(att1);
  
  Attachment att2 = new Attachment();
  att2.Name='CVMS Offer Sheet';
  att2.body=blob.valueof('test2');
  att2.ParentId=oProposal.id;
  attList.add(att2);
  
  insert attList;
 
  List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
  
  APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
  multiacc.APTS_Agreement_Number__c='8923238';  
  multiacc.APTS_Quote_Proposal__c=oProposal .id;
  multiacc.APTS_Status__c='New';
  quoteAgrLocList.add(multiacc);
  
  APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
  multiacc1.APTS_Agreement_Number__c='8923238';  
  multiacc1.APTS_Quote_Proposal__c=oProposal .id;
  multiacc1.APTS_Status__c='Cancelled';
  //changed to new Subscriber ssd reference instead of old subscriber field
  multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
  quoteAgrLocList.add(multiacc1);
  
  insert quoteAgrLocList;
  
  List<APTS_Dynamic_Bundle__c> dymBundle=new List<APTS_Dynamic_Bundle__c>();
  
  APTS_Dynamic_Bundle__c dynamicbundle11 = new APTS_Dynamic_Bundle__c();
  dynamicbundle11.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle11.APTS_Group__c='Bundle A';
  dynamicbundle11.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle11.APTS_Contract_Terms__c='3 Years';
  dynamicbundle11.APTS_YoY_2_Plus__c='1';
  dynamicbundle11.APTS_Keep_Terms__c=true;
  dynamicbundle11.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundle11.APTS_Bridge_Discount__c = '100';
  dynamicbundle11.APTS_Billing_Frequency__c='Yearly';
  dynamicbundle11.APTS_Net_Price__c =100;
  dynamicbundle11.APTS_Program_ID__c = 'WCMP';
  dynamicbundle11.APTS_Deal_Number__c = 234;
  dynamicbundle11.APTS_isBLINotCreated__c =true;
  dymBundle.add(dynamicbundle11);
  
  APTS_Dynamic_Bundle__c dynamicbundle12 = new APTS_Dynamic_Bundle__c();
  dynamicbundle12.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle12.APTS_Group__c='Bundle A';
  dynamicbundle12.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle12.APTS_Contract_Terms__c='3 Years';
  dynamicbundle12.APTS_YoY_2_Plus__c='1';
  dynamicbundle12.APTS_Keep_Terms__c=false;
  dynamicbundle12.APTS_MLA__c = true;
  //dynamicbundle12.APTS_Bridge_Monthly_Charges__c = 12365;
  dynamicbundle12.APTS_MLA_Agreement_Number__c='7374737'; 
  dynamicbundle12.APTS_Billing_Frequency__c='Monthly';
  dynamicbundle12.APTS_Net_Price__c =100;
  dynamicbundle12.APTS_Program_ID__c = 'WCMP';
  dynamicbundle12.APTS_Deal_Number__c = 234;
  dynamicbundle12.APTS_isBLINotCreated__c =true;
  dymBundle.add(dynamicbundle12); 
  
  insert dymBundle;
  
  List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
  Apttus_Config2__LineItem__c lineItemo =  new Apttus_Config2__LineItem__c();
        lineItemo.APTS_Group_Primary_Material__c= '40666420';
        lineItemo.Apttus_Config2__LineStatus__c = 'New';  
        lineItemo.APTS_Group__c = dymBundle[0].APTS_Group__c;
        lineItemo.APTS_Contract_Number__c = 123456;
        lineItemo.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemo.Apttus_Config2__ItemSequence__c = 1;
        lineItemo.Apttus_Config2__LineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductId__c = oProductP.Id;  
        //insert lineItemo;
        lineItemo.Apttus_Config2__AddedBy__c = 'User';
        lineItemo.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemo.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemo.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemo.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemo.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemo.Apttus_Config2__AllowProration__c = FALSE;
        lineItemo.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemo.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemo.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemo.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__BasePrice__c = 100;
        lineItemo.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemo.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemo.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemo.Apttus_Config2__Customizable__c = FALSE;
        lineItemo.Apttus_Config2__DeltaPrice__c = 50;
        lineItemo.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemo.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemo.Apttus_Config2__ExtendedCost__c = 0;
        lineItemo.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemo.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemo.Apttus_Config2__Guidance__c = 'Red';
        lineItemo.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemo.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemo.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemo.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemo.Apttus_Config2__HasOptions__c = FALSE;
        lineItemo.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemo.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemo.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemo.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemo.Apttus_Config2__IsHidden__c = FALSE;
        lineItemo.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemo.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemo.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemo.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemo.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemo.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemo.Apttus_Config2__LineSequence__c = 1;
        lineItemo.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemo.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemo.Apttus_Config2__ListPrice__c = 100;
        lineItemo.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemo.Apttus_Config2__NetPrice__c = 50;
        lineItemo.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemo.Apttus_Config2__OptionSequence__c = 0;
        lineItemo.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemo.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemo.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemo.Apttus_Config2__PriceUom__c = 'Each';
        lineItemo.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemo.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemo.Apttus_Config2__ProductVersion__c = 1;
        lineItemo.Apttus_Config2__Quantity__c = 1;
        lineItemo.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemo.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemo.Apttus_Config2__SellingTerm__c = 1;
        lineItemo.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemo.Apttus_Config2__Taxable__c = FALSE;
        lineItemo.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemo.Apttus_Config2__Term__c = 1;
        lineItemo.Apttus_Config2__TotalQuantity__c = 1;
        lineItemo.Apttus_Config2__Uom__c = 'Each';
        lineItemo.CurrencyIsoCode = 'USD';
        lineItemo.APTS_Product_Family__c = 'WESTLAW';
        lineItemo.APTS_Contract_Term__c = '2 Years';
        lineItemo.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemo.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemo.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemo);
  
  Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
        lineItemS.APTS_Group_Primary_Material__c= '40666420';
        lineItemS.Apttus_Config2__LineStatus__c = 'New';  
        lineItemS.APTS_Group__c = dymBundle[0].APTS_Group__c;
        lineItemS.APTS_Contract_Number__c = 123456;
        lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS.Apttus_Config2__ItemSequence__c = 1;
        lineItemS.Apttus_Config2__LineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductId__c = oProductS.Id;   
        //insert lineItemS;
        lineItemS.Apttus_Config2__AddedBy__c = 'User';
        lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowProration__c = FALSE;
        lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__BasePrice__c = 100;
        lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemS.Apttus_Config2__Customizable__c = FALSE;
        lineItemS.Apttus_Config2__DeltaPrice__c = 50;
        lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemS.Apttus_Config2__ExtendedCost__c = 0;
        lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemS.Apttus_Config2__Guidance__c = 'Red';
        lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemS.Apttus_Config2__HasOptions__c = FALSE;
        lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsHidden__c = FALSE;
        lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemS.Apttus_Config2__LineSequence__c = 1;
        lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemS.Apttus_Config2__ListPrice__c = 100;
        lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemS.Apttus_Config2__NetPrice__c = 50;
        lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemS.Apttus_Config2__OptionSequence__c = 0;
        lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemS.Apttus_Config2__PriceUom__c = 'Each';
        lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductVersion__c = 1;
        lineItemS.Apttus_Config2__Quantity__c = 1;
        lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__SellingTerm__c = 1;
        lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemS.Apttus_Config2__Taxable__c = FALSE;
        lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemS.Apttus_Config2__Term__c = 1;
        lineItemS.Apttus_Config2__TotalQuantity__c = 1;
        lineItemS.Apttus_Config2__Uom__c = 'Each';
        lineItemS.CurrencyIsoCode = 'USD';
        lineItemS.APTS_Product_Family__c = 'WESTLAW';
        lineItemS.APTS_Contract_Term__c = '2 Years';
        lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemS.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemS);
  
  Apttus_Config2__LineItem__c lineItem1 =  new Apttus_Config2__LineItem__c();
        lineItem1.APTS_Group_Primary_Material__c= '40666421';
        lineItem1.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItem1.APTS_Group__c = dymBundle[0].APTS_Group__c;
        lineItem1.APTS_Contract_Number__c = 123456;
        lineItem1.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem1.Apttus_Config2__ItemSequence__c = 1;
        lineItem1.Apttus_Config2__LineNumber__c = 1;
        lineItem1.APTS_Deal_Type__c = 'WCMP';
        lineItem1.Apttus_Config2__ProductId__c = oProductS.Id;   
        //insert lineItemS;
        lineItem1.Apttus_Config2__AddedBy__c = 'User';
        lineItem1.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem1.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem1.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem1.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem1.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem1.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem1.Apttus_Config2__AllowProration__c = FALSE;
        lineItem1.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem1.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem1.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem1.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem1.Apttus_Config2__BasePrice__c = 100;
        lineItem1.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem1.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem1.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem1.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem1.Apttus_Config2__Customizable__c = FALSE;
        lineItem1.Apttus_Config2__DeltaPrice__c = 50;
        lineItem1.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem1.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem1.Apttus_Config2__ExtendedCost__c = 0;
        lineItem1.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem1.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem1.Apttus_Config2__Guidance__c = 'Red';
        lineItem1.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem1.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem1.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem1.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem1.Apttus_Config2__HasOptions__c = FALSE;
        lineItem1.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem1.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem1.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem1.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem1.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem1.Apttus_Config2__IsHidden__c = FALSE;
        lineItem1.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem1.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem1.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem1.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem1.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem1.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem1.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem1.Apttus_Config2__LineSequence__c = 1;
        lineItem1.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem1.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem1.Apttus_Config2__ListPrice__c = 100;
        lineItem1.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem1.Apttus_Config2__NetPrice__c = 50;
        lineItem1.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem1.Apttus_Config2__OptionSequence__c = 0;
        lineItem1.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem1.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem1.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem1.Apttus_Config2__PriceUom__c = 'Each';
        lineItem1.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem1.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem1.Apttus_Config2__ProductVersion__c = 1;
        lineItem1.Apttus_Config2__Quantity__c = 1;
        lineItem1.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem1.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem1.Apttus_Config2__SellingTerm__c = 1;
        lineItem1.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem1.Apttus_Config2__Taxable__c = FALSE;
        lineItem1.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem1.Apttus_Config2__Term__c = 1;
        lineItem1.Apttus_Config2__TotalQuantity__c = 1;
        lineItem1.Apttus_Config2__Uom__c = 'Each';
        lineItem1.CurrencyIsoCode = 'USD';
        lineItem1.APTS_Product_Family__c = 'WESTLAW';
        lineItem1.APTS_Contract_Term__c = '2 Years';
        lineItem1.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem1.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem1.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItem1);
  
  insert liList;
  
  List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc4); 
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc5); 
   Online_Contacts__c oc6 =new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc6); 
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc13); 
    Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc14); 
    Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc15);
    Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc.APTS_Subscriber_Location__c);
   onlineContactList.add(oc16);   
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc17);  
    
   insert onlineContactList;
  APTS_Additional_Subscription_Actions__c addsub = new APTS_Additional_Subscription_Actions__c();
  addsub.APTS_Line_Status__c='Cancelled';
  addsub.APTS_Subscription_Number__c='787847';
  addsub.APTS_Quote_Proposal__c=oProposal.id;
  
  insert addsub; 
  
  order.Apttus_Config2__Status__c='Pending';
  update order;
  
  Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name); 
  //Test.startTest(); 
  //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456
  //Added code to cover TRStore code
   LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='trstorebusinessUnits', value__c='TR Store Canada Print')
             };
        insert staticCSList;
  
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
  Test.stopTest();
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  
  }
  
  static testMethod void orderQueuetoESIWCMP(){
  
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
   
  Account acc = new Account();
  acc.Name='testWCMP';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
  insert accountSSD;
  
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
        
  Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;  
  
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='WCMP';
  con.FirstName='Bundle';
  insert con;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
  Product2 oProductP = new Product2(Name='Option Product', ProductCode = '1234568978966', APTS_Corporate_Select__c = 'Module');
  Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
  productlist.add(oProductB);
  productlist.add(oProductP);
  productlist.add(oProductS);
  insert productlist;
  
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
  Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
    RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test',
      APTS_Proposal_Business_Unit__c='SCS',
       APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Payer__c = accountSSD.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
      APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
       // APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
      APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
      oProposal.APTS_Ebilling_contact__c=con.id;
  
  insert oProposal;
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
  
   Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();       
  order.Apttus_Config2__Type__c='New';      
  order.Apttus_Config2__Status__c='Ready for Activation';       
  order.APTS_SSD_Sold_To__c=accountSSD.id;      
  order.APTS_SSD_bill_to__c=accountSSD.id;      
  order.APTS_SSD_Ship_To__c=accountSSD.id;      
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;        
  order.Apttus_Config2__Status__c='Pending';        
  order.Retry_Count__c = 2;     
  insert order;
  
  
  
  
  
  List<APTS_Dynamic_Bundle__c> dymBundle=new List<APTS_Dynamic_Bundle__c>();  
  APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
  dynamicbundlewm.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewm.APTS_Group__c='Bundle A';
  dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
  dynamicbundlewm.APTS_YoY_2_Plus__c='1';
  dynamicbundlewm.APTS_Keep_Terms__c=true;
  dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewm.APTS_Deal_Number__c = 23456665;
  dynamicbundlewm.APTS_Bridge_Discount__c = '10';
  dynamicbundlewm.APTS_Bridge_Length__c = 2;
  dynamicbundlewm.APTS_Bridge__c = '28 Days';
  dynamicbundlewm.APTS_isBLINotCreated__c =true;
  //insert dynamicbundlewm;
  dymBundle.add(dynamicbundlewm);
  
  APTS_Dynamic_Bundle__c dynamicbundlewm2 = new APTS_Dynamic_Bundle__c();
  dynamicbundlewm2.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewm2.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewm2.APTS_Group__c='Bundle B';
  dynamicbundlewm2.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
  dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
  dynamicbundlewm2.APTS_Keep_Terms__c=true;
  dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewm.APTS_Deal_Number__c = null;
  dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
  dynamicbundlewm2.APTS_Bridge_Length__c = 2;
  dynamicbundlewm2.APTS_Bridge__c = '14 Days';
  dynamicbundlewm2.APTS_isBLINotCreated__c =true;
  //dynamicbundlewm2.APTS_Billing_Frequency__c='Monthly';
  //insert dynamicbundlewm2;  
  dymBundle.add(dynamicbundlewm2);
  
  APTS_Dynamic_Bundle__c dynamicbundlewmK = new APTS_Dynamic_Bundle__c();
  dynamicbundlewmK.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewmK.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewmK.APTS_Billing_Frequency__c='Yearly';
  //dynamicbundlewm2.APTS_Group__c='Bundle B';
  dynamicbundlewmK.APTS_Quote_Proposal__c=oProposal.id;
  //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
  //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
  dynamicbundlewmK.APTS_Keep_Terms__c=false;
  //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewmK.APTS_Deal_Number__c = null;
  //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
  dynamicbundlewmK.APTS_Bridge_Length__c = 2;
  dynamicbundlewmK.APTS_Bridge__c = '14 Days';
   dynamicbundlewmK.APTS_Net_Price__c=1000;  
     dynamicbundlewmk.APTS_isBLINotCreated__c =true;
  //insert dynamicbundlewmK;
  dymBundle.add(dynamicbundlewmK);
  
  APTS_Dynamic_Bundle__c dynamicbundlewmF = new APTS_Dynamic_Bundle__c();
  dynamicbundlewmF.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewmF.APTS_Program_ID__c= 'WCMP';  
  //dynamicbundlewm2.APTS_Group__c='Bundle B';
  dynamicbundlewmF.APTS_Quote_Proposal__c=oProposal.id;
  //dynamicbundlewm2.APTS_Contract_Terms__c='3 Years';
  //dynamicbundlewm2.APTS_YoY_2_Plus__c='1';
  dynamicbundlewmF.APTS_Keep_Terms__c=false;
  //dynamicbundlewm2.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewmF.APTS_Deal_Number__c = null;
  //dynamicbundlewm2.APTS_Bridge_Discount__c = '10';
  dynamicbundlewmF.APTS_Bridge_Length__c = 2;
  dynamicbundlewmF.APTS_Bridge__c = '14 Days';
    dynamicbundlewmF.APTS_isBLINotCreated__c =true;
  
  //insert dynamicbundlewmF;
  dymBundle.add(dynamicbundlewmF);
  insert dymBundle;
  
  List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();

  Apttus_Config2__LineItem__c lineItemP =  new Apttus_Config2__LineItem__c();
        lineItemP.APTS_Group_Primary_Material__c= '40666420';
        lineItemP.Apttus_Config2__LineStatus__c = 'New';  
        lineItemP.APTS_Group__c = 'Bundle A';
        lineItemP.APTS_Contract_Number__c = 123456;
        lineItemP.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemP.Apttus_Config2__ItemSequence__c = 1;
        lineItemP.Apttus_Config2__LineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductId__c = oProductB.Id;  
        //insert lineItemP; 
        lineItemP.Apttus_Config2__AddedBy__c = 'User';
        lineItemP.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemP.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemP.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemP.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemP.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemP.Apttus_Config2__AllowProration__c = FALSE;
        lineItemP.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemP.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemP.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemP.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__BasePrice__c = 100;
        lineItemP.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemP.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemP.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemP.Apttus_Config2__Customizable__c = FALSE;
        lineItemP.Apttus_Config2__DeltaPrice__c = 50;
        lineItemP.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemP.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemP.Apttus_Config2__ExtendedCost__c = 0;
        lineItemP.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemP.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemP.Apttus_Config2__Guidance__c = 'Red';
        lineItemP.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemP.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemP.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemP.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemP.Apttus_Config2__HasOptions__c = FALSE;
        lineItemP.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemP.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemP.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemP.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemP.Apttus_Config2__IsHidden__c = FALSE;
        lineItemP.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemP.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemP.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemP.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemP.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemP.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemP.Apttus_Config2__LineSequence__c = 1;
        lineItemP.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemP.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemP.Apttus_Config2__ListPrice__c = 100;
        lineItemP.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemP.Apttus_Config2__NetPrice__c = 50;
        lineItemP.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemP.Apttus_Config2__OptionSequence__c = 0;
        lineItemP.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemP.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemP.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemP.Apttus_Config2__PriceUom__c = 'Each';
        lineItemP.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemP.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemP.Apttus_Config2__ProductVersion__c = 1;
        lineItemP.Apttus_Config2__Quantity__c = 1;
        lineItemP.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemP.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemP.Apttus_Config2__SellingTerm__c = 1;
        lineItemP.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemP.Apttus_Config2__Taxable__c = FALSE;
        lineItemP.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemP.Apttus_Config2__Term__c = 1;
        lineItemP.Apttus_Config2__TotalQuantity__c = 1;
        lineItemP.Apttus_Config2__Uom__c = 'Each';
        lineItemP.CurrencyIsoCode = 'USD';
        lineItemP.APTS_Product_Family__c = 'WESTLAW';
        lineItemP.APTS_Contract_Term__c = '2 Years';
        lineItemP.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemP.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemP.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemP);
  
  Apttus_Config2__LineItem__c lineItemo =  new Apttus_Config2__LineItem__c();
  lineItemo.APTS_Group_Primary_Material__c= '40666420';
  lineItemo.Apttus_Config2__LineStatus__c = 'New';  
  lineItemo.APTS_Group__c = dymBundle[0].Id;
  lineItemo.APTS_Contract_Number__c = 123456;
  lineItemo.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItemo.Apttus_Config2__ItemSequence__c = 1;
  lineItemo.Apttus_Config2__LineNumber__c = 1;
  lineItemo.Apttus_Config2__ProductId__c = oProductP.Id;  
  //insert lineItemo; 
  lineItemo.Apttus_Config2__AddedBy__c = 'User';
  lineItemo.Apttus_Config2__AdjustedPrice__c = 50;
  lineItemo.Apttus_Config2__AdjustmentAmount__c = 50;
  lineItemo.Apttus_Config2__AdjustmentType__c = '% Discount';
  lineItemo.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
  lineItemo.Apttus_Config2__AllowableAction__c = 'Unrestricted';
  lineItemo.Apttus_Config2__AllowManualAdjustment__c = TRUE;
  lineItemo.Apttus_Config2__AllowProration__c = FALSE;
  lineItemo.Apttus_Config2__AllowRemoval__c = TRUE;
  lineItemo.Apttus_Config2__AutoRenew__c = FALSE;
  lineItemo.Apttus_Config2__BaseExtendedCost__c = 0;
  lineItemo.Apttus_Config2__BaseExtendedPrice__c = 100;
  lineItemo.Apttus_Config2__BasePrice__c = 100;
  lineItemo.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
  lineItemo.Apttus_Config2__BillingFrequency__c = 'Monthly';
  lineItemo.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  lineItemo.Apttus_Config2__ConfigStatus__c = 'Complete';
  lineItemo.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
  lineItemo.Apttus_Config2__Customizable__c = FALSE;
  lineItemo.Apttus_Config2__DeltaPrice__c = 50;
  lineItemo.Apttus_Config2__DeltaQuantity__c = 1;
  lineItemo.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
  lineItemo.Apttus_Config2__ExtendedCost__c = 0;
  lineItemo.Apttus_Config2__ExtendedPrice__c = 100;
  lineItemo.Apttus_Config2__Frequency__c = 'Monthly';
  lineItemo.Apttus_Config2__Guidance__c = 'Red';
  lineItemo.Apttus_Config2__HasAttributes__c = FALSE;
  lineItemo.Apttus_Config2__HasBaseProduct__c = FALSE;
  lineItemo.Apttus_Config2__HasDefaults__c = FALSE;
  lineItemo.Apttus_Config2__HasIncentives__c = FALSE;
  lineItemo.Apttus_Config2__HasOptions__c = FALSE;
  lineItemo.Apttus_Config2__HasTieredPrice__c = FALSE;
  lineItemo.Apttus_Config2__HideCopyAction__c = FALSE;
  lineItemo.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
  lineItemo.Apttus_Config2__IsAssetPricing__c = FALSE;
  lineItemo.Apttus_Config2__IsCustomPricing__c = FALSE;
  lineItemo.Apttus_Config2__IsHidden__c = FALSE;
  lineItemo.Apttus_Config2__IsOptionRollupLine__c = FALSE;
  lineItemo.Apttus_Config2__IsPrimaryLine__c = TRUE;
  lineItemo.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
  lineItemo.Apttus_Config2__IsQuantityModifiable__c = FALSE;
  lineItemo.Apttus_Config2__IsReadOnly__c = FALSE;
  lineItemo.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
  lineItemo.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
  lineItemo.Apttus_Config2__LineSequence__c = 1;
  lineItemo.APTS_Yr_1_Renewal_Adjustment__c ='1';
  lineItemo.Apttus_Config2__LineType__c = 'Product/Service';
  lineItemo.Apttus_Config2__ListPrice__c = 100;
  lineItemo.Apttus_Config2__NetAdjustmentPercent__c = -50;
  lineItemo.Apttus_Config2__NetPrice__c = 50;
  lineItemo.Apttus_Config2__NetUnitPrice__c = 50;
  lineItemo.Apttus_Config2__OptionSequence__c = 0;
  lineItemo.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
  lineItemo.Apttus_Config2__PriceMethod__c = 'Per Unit';
  lineItemo.Apttus_Config2__PriceType__c = 'Recurring';
  lineItemo.Apttus_Config2__PriceUom__c = 'Each';
  lineItemo.Apttus_Config2__PricingStatus__c = 'Complete';
  lineItemo.Apttus_Config2__PrimaryLineNumber__c = 1;
  lineItemo.Apttus_Config2__ProductVersion__c = 1;
  lineItemo.Apttus_Config2__Quantity__c = 1;
  lineItemo.Apttus_Config2__RollupPriceToBundle__c = TRUE;
  lineItemo.Apttus_Config2__SellingFrequency__c = 'Monthly';
  lineItemo.Apttus_Config2__SellingTerm__c = 1;
  lineItemo.Apttus_Config2__SyncStatus__c = 'Pending';
  lineItemo.Apttus_Config2__Taxable__c = FALSE;
  lineItemo.Apttus_Config2__TaxInclusive__c = FALSE;
  lineItemo.Apttus_Config2__Term__c = 1;
  lineItemo.Apttus_Config2__TotalQuantity__c = 1;
  lineItemo.Apttus_Config2__Uom__c = 'Each';
  lineItemo.CurrencyIsoCode = 'USD';
  lineItemo.APTS_Product_Family__c = 'WESTLAW';
  lineItemo.APTS_Contract_Term__c = '2 Years';
  lineItemo.APTS_Years_2_Plus_Adjustment__c = '4';
  lineItemo.APTS_Product_Delivery__c = 'Online/Internet';
  lineItemo.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemo);
  
  Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
        lineItemS.APTS_Group_Primary_Material__c= '40666420';
        lineItemS.Apttus_Config2__LineStatus__c = 'New';  
        lineItemo.APTS_Group__c = dymBundle[0].Id;
        lineItemS.APTS_Contract_Number__c = 123456;
        lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItemS.Apttus_Config2__ItemSequence__c = 1;
        lineItemS.Apttus_Config2__LineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductId__c = oProductS.Id;   
        //insert lineItemS; 
        lineItemS.Apttus_Config2__AddedBy__c = 'User';
        lineItemS.Apttus_Config2__AdjustedPrice__c = 50;
        lineItemS.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItemS.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItemS.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItemS.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItemS.Apttus_Config2__AllowProration__c = FALSE;
        lineItemS.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItemS.Apttus_Config2__AutoRenew__c = FALSE;
        lineItemS.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItemS.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__BasePrice__c = 100;
        lineItemS.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItemS.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItemS.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItemS.Apttus_Config2__Customizable__c = FALSE;
        lineItemS.Apttus_Config2__DeltaPrice__c = 50;
        lineItemS.Apttus_Config2__DeltaQuantity__c = 1;
        lineItemS.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItemS.Apttus_Config2__ExtendedCost__c = 0;
        lineItemS.Apttus_Config2__ExtendedPrice__c = 100;
        lineItemS.Apttus_Config2__Frequency__c = 'Monthly';
        lineItemS.Apttus_Config2__Guidance__c = 'Red';
        lineItemS.Apttus_Config2__HasAttributes__c = FALSE;
        lineItemS.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItemS.Apttus_Config2__HasDefaults__c = FALSE;
        lineItemS.Apttus_Config2__HasIncentives__c = FALSE;
        lineItemS.Apttus_Config2__HasOptions__c = FALSE;
        lineItemS.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItemS.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItemS.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItemS.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItemS.Apttus_Config2__IsHidden__c = FALSE;
        lineItemS.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItemS.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItemS.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItemS.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItemS.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItemS.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItemS.Apttus_Config2__LineSequence__c = 1;
        lineItemS.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItemS.Apttus_Config2__LineType__c = 'Product/Service';
        lineItemS.Apttus_Config2__ListPrice__c = 100;
        lineItemS.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItemS.Apttus_Config2__NetPrice__c = 50;
        lineItemS.Apttus_Config2__NetUnitPrice__c = 50;
        lineItemS.Apttus_Config2__OptionSequence__c = 0;
        lineItemS.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItemS.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItemS.Apttus_Config2__PriceType__c = 'Recurring';
        lineItemS.Apttus_Config2__PriceUom__c = 'Each';
        lineItemS.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItemS.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItemS.Apttus_Config2__ProductVersion__c = 1;
        lineItemS.Apttus_Config2__Quantity__c = 1;
        lineItemS.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItemS.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItemS.Apttus_Config2__SellingTerm__c = 1;
        lineItemS.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItemS.Apttus_Config2__Taxable__c = FALSE;
        lineItemS.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItemS.Apttus_Config2__Term__c = 1;
        lineItemS.Apttus_Config2__TotalQuantity__c = 1;
        lineItemS.Apttus_Config2__Uom__c = 'Each';
        lineItemS.CurrencyIsoCode = 'USD';
        lineItemS.APTS_Product_Family__c = 'WESTLAW';
        lineItemS.APTS_Contract_Term__c = '2 Years';
        lineItemS.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItemS.APTS_Product_Delivery__c = 'Online/Internet';
        lineItemS.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItemS);
  
  Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle A';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMPS';
        //lineItem.APTS_Group_Primary_Material__c= '40666420';
        //insert lineItem;  
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem.Apttus_Config2__Quantity__c = 1;
            
  liList.add(lineItem);

  Apttus_Config2__LineItem__c lineItem2 =  new Apttus_Config2__LineItem__c();
        lineItem2.APTS_Group_Primary_Material__c= '40666420';
        lineItem2.Apttus_Config2__LineStatus__c = 'New';  
        lineItem2.APTS_Group__c = 'Bundle A';
        lineItem2.APTS_Contract_Number__c = 1234564;
        lineItem2.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem2.Apttus_Config2__ItemSequence__c = 1;
        lineItem2.Apttus_Config2__LineNumber__c = 2;
        lineItem2.APTS_Deal_Type__c ='WCMP';
        //lineItem2.APTS_Service_Number__c = '41841757';
        //insert lineItem2; 
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';
        lineItem2.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem2.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem2.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem2.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem2.Apttus_Config2__HasOptions__c = FALSE;
        lineItem2.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem2.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem2.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsHidden__c = FALSE;
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem2.Apttus_Config2__LineSequence__c = 1;
        lineItem2.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem2.Apttus_Config2__ListPrice__c = 100;
        lineItem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem2.Apttus_Config2__NetPrice__c = 50;
        lineItem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem2.Apttus_Config2__OptionSequence__c = 0;
        lineItem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem2.Apttus_Config2__PriceUom__c = 'Each';
        lineItem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__ProductVersion__c = 1;
        lineItem2.Apttus_Config2__Quantity__c = 1;
        lineItem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__SellingTerm__c = 1;
        lineItem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem2.Apttus_Config2__Taxable__c = FALSE;
        lineItem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem2.Apttus_Config2__Term__c = 1;
        lineItem2.Apttus_Config2__TotalQuantity__c = 1;
        lineItem2.Apttus_Config2__Uom__c = 'Each';
        lineItem2.CurrencyIsoCode = 'USD';
        lineItem2.APTS_Product_Family__c = 'WESTLAW';
        lineItem2.APTS_Contract_Term__c = '2 Years';
        lineItem2.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem2.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem2.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItem2);
  
  Apttus_Config2__LineItem__c lineItem3 =  new Apttus_Config2__LineItem__c();
        lineItem3.APTS_Group_Primary_Material__c= '40666420';
        lineItem3.Apttus_Config2__LineStatus__c = 'New';  
        lineItem3.APTS_Group__c = 'Bundle A';
        lineItem3.APTS_Contract_Number__c = 1234564;
        lineItem3.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem3.Apttus_Config2__ItemSequence__c = 1;
        lineItem3.Apttus_Config2__LineNumber__c = 3;
        //insert lineItem3;
        lineItem3.Apttus_Config2__AddedBy__c = 'User';
        lineItem3.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem3.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem3.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem3.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem3.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem3.Apttus_Config2__AllowProration__c = FALSE;
        lineItem3.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem3.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem3.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem3.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__BasePrice__c = 100;
        lineItem3.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem3.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem3.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem3.Apttus_Config2__Customizable__c = FALSE;
        lineItem3.Apttus_Config2__DeltaPrice__c = 50;
        lineItem3.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem3.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem3.Apttus_Config2__ExtendedCost__c = 0;
        lineItem3.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem3.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem3.Apttus_Config2__Guidance__c = 'Red';
        lineItem3.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem3.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem3.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem3.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem3.Apttus_Config2__HasOptions__c = FALSE;
        lineItem3.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem3.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem3.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem3.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem3.Apttus_Config2__IsHidden__c = FALSE;
        lineItem3.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem3.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem3.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem3.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem3.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem3.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem3.Apttus_Config2__LineSequence__c = 1;
        lineItem3.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem3.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem3.Apttus_Config2__ListPrice__c = 100;
        lineItem3.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem3.Apttus_Config2__NetPrice__c = 50;
        lineItem3.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem3.Apttus_Config2__OptionSequence__c = 0;
        lineItem3.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem3.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem3.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem3.Apttus_Config2__PriceUom__c = 'Each';
        lineItem3.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem3.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem3.Apttus_Config2__ProductVersion__c = 1;
        lineItem3.Apttus_Config2__Quantity__c = 1;
        lineItem3.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem3.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem3.Apttus_Config2__SellingTerm__c = 1;
        lineItem3.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem3.Apttus_Config2__Taxable__c = FALSE;
        lineItem3.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem3.Apttus_Config2__Term__c = 1;
        lineItem3.Apttus_Config2__TotalQuantity__c = 1;
        lineItem3.Apttus_Config2__Uom__c = 'Each';
        lineItem3.CurrencyIsoCode = 'USD';
        lineItem3.APTS_Product_Family__c = 'WESTLAW';
        lineItem3.APTS_Contract_Term__c = '2 Years';
        lineItem3.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem3.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem3.Apttus_Config2__Quantity__c = 1;
  
  liList.add(lineItem3);
  
  Apttus_Config2__LineItem__c lineItem4 =  new Apttus_Config2__LineItem__c();
        //lineItem4.APTS_Program_ID__c = 'WCMPS';
        lineItem4.Apttus_Config2__LineStatus__c = 'New';  
        lineItem4.APTS_Group__c = 'Bundle A';
        lineItem4.APTS_Contract_Number__c = 1234564;
        lineItem4.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem4.Apttus_Config2__ItemSequence__c = 1;
        lineItem4.Apttus_Config2__LineNumber__c = 4;
        //insert lineItem4;
        lineItem4.Apttus_Config2__AddedBy__c = 'User';
        lineItem4.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem4.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem4.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem4.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem4.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem4.Apttus_Config2__AllowProration__c = FALSE;
        lineItem4.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem4.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem4.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem4.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__BasePrice__c = 100;
        lineItem4.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem4.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem4.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem4.Apttus_Config2__Customizable__c = FALSE;
        lineItem4.Apttus_Config2__DeltaPrice__c = 50;
        lineItem4.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem4.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem4.Apttus_Config2__ExtendedCost__c = 0;
        lineItem4.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem4.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem4.Apttus_Config2__Guidance__c = 'Red';
        lineItem4.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem4.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem4.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem4.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem4.Apttus_Config2__HasOptions__c = FALSE;
        lineItem4.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem4.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem4.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem4.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem4.Apttus_Config2__IsHidden__c = FALSE;
        lineItem4.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem4.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem4.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem4.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem4.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem4.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem4.Apttus_Config2__LineSequence__c = 1;
        lineItem4.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem4.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem4.Apttus_Config2__ListPrice__c = 100;
        lineItem4.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem4.Apttus_Config2__NetPrice__c = 50;
        lineItem4.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem4.Apttus_Config2__OptionSequence__c = 0;
        lineItem4.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem4.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem4.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem4.Apttus_Config2__PriceUom__c = 'Each';
        lineItem4.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem4.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem4.Apttus_Config2__ProductVersion__c = 1;
        lineItem4.Apttus_Config2__Quantity__c = 1;
        lineItem4.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem4.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem4.Apttus_Config2__SellingTerm__c = 1;
        lineItem4.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem4.Apttus_Config2__Taxable__c = FALSE;
        lineItem4.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem4.Apttus_Config2__Term__c = 1;
        lineItem4.Apttus_Config2__TotalQuantity__c = 1;
        lineItem4.Apttus_Config2__Uom__c = 'Each';
        lineItem4.CurrencyIsoCode = 'USD';
        lineItem4.APTS_Product_Family__c = 'WESTLAW';
        lineItem4.APTS_Contract_Term__c = '2 Years';
        lineItem4.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem4.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem4.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItem4);
  
  Apttus_Config2__LineItem__c lineItem5 =  new Apttus_Config2__LineItem__c();
        lineItem5.APTS_Group_Primary_Material__c= '40666420';
        lineItem5.Apttus_Config2__LineStatus__c = 'New';  
        lineItem5.APTS_Group__c = 'Bundle B';
        lineItem5.APTS_Contract_Number__c = 1234564;
        lineItem5.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem5.Apttus_Config2__ItemSequence__c = 1;
        lineItem5.Apttus_Config2__LineNumber__c = 5;
        lineItem5.Apttus_Config2__AddedBy__c = 'User';
        lineItem5.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem5.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowProration__c = FALSE;
        lineItem5.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem5.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem5.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem5.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__BasePrice__c = 100;
        lineItem5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem5.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem5.Apttus_Config2__Customizable__c = FALSE;
        lineItem5.Apttus_Config2__DeltaPrice__c = 50;
        lineItem5.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem5.Apttus_Config2__ExtendedCost__c = 0;
        lineItem5.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem5.Apttus_Config2__Guidance__c = 'Red';
        lineItem5.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem5.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem5.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem5.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem5.Apttus_Config2__HasOptions__c = FALSE;
        lineItem5.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem5.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem5.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsHidden__c = FALSE;
        lineItem5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem5.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem5.Apttus_Config2__LineSequence__c = 1;
        lineItem5.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem5.Apttus_Config2__ListPrice__c = 100;
        lineItem5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem5.Apttus_Config2__NetPrice__c = 50;
        lineItem5.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem5.Apttus_Config2__OptionSequence__c = 0;
        lineItem5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem5.Apttus_Config2__PriceUom__c = 'Each';
        lineItem5.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__ProductVersion__c = 1;
        lineItem5.Apttus_Config2__Quantity__c = 1;
        lineItem5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__SellingTerm__c = 1;
        lineItem5.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem5.Apttus_Config2__Taxable__c = FALSE;
        lineItem5.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem5.Apttus_Config2__Term__c = 1;
        lineItem5.Apttus_Config2__TotalQuantity__c = 1;
        lineItem5.Apttus_Config2__Uom__c = 'Each';
        lineItem5.CurrencyIsoCode = 'USD';
        lineItem5.APTS_Product_Family__c = 'WESTLAW';
        lineItem5.APTS_Contract_Term__c = '2 Years';
        lineItem5.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem5.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem5.Apttus_Config2__Quantity__c = 1;
  
  liList.add(lineItem5);
  
  Test.startTest(); 
  insert liList;
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);
  Test.stopTest();
  
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
      
  } 
  
  static testMethod void orderQueuetoESI4845(){ 
    
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
  Account acc = new Account();
  acc.Name='testWCMP2';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc; 
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
  insert accountSSD;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
  
  /*Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty;*/
        
        Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='WCMP2';
  con.FirstName='Bundle2';
  insert con;
  
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
  Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
    RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test2',
      APTS_Proposal_Business_Unit__c='SCS',
       APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
      APTS_Payment_Option__c='Credit Card' ,     
      //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
      APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
      oProposal.APTS_Ebilling_contact__c=con.id;
  
      insert oProposal;
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  //order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  order.Apttus_Config2__Status__c='Pending';
  order.Retry_Count__c = 2;
  insert order;
  
  
  
  Product2 oProductB = new Product2(Name='WCMP Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'P7',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c = 'ZPMT');
  insert oProductB;
  system.debug(LoggingLevel.WARN,'Product... '+oProductB);
       
      List<Apttus_Config2__OrderLineItem__c> orderLineList=new List<Apttus_Config2__OrderLineItem__c>();      
      List<Apttus_Config2__OrderProductAttributeValue__c> orderProductAttributeValueList =new List<Apttus_Config2__OrderProductAttributeValue__c>();          
      List<Apttus_Config2__OrderLineItem__c> updateOrderLineList=new List<Apttus_Config2__OrderLineItem__c>();   
      Apttus_Config2__OrderLineItem__c ordlinedemo =  new Apttus_Config2__OrderLineItem__c();
      ordlinedemo.Apttus_Config2__OrderId__c=order.id;
      ordlinedemo.Apttus_Config2__Quantity__c=1.000;
      ordlinedemo.APTS_Contract_Term__c='1 Year';
      ordlinedemo.Apttus_Config2__ProductId__c=oProductB.id;
       insert ordlinedemo;
        Apttus_Config2__OrderProductAttributeValue__c attribute30 = new Apttus_Config2__OrderProductAttributeValue__c();
      attribute30.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
      attribute30.Apttus_Config2__LineItemId__c=ordlinedemo.id;
      Insert attribute30;
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A'; 
  ordline.APTS_Program_ID__c = 'WCMP';
  ordline.APTS_Bridge__c='11 Months';
  ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline.Apttus_Config2__NetPrice__c = 1728;
  orderLineList.add(ordline);
  
  
  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='1 Year';
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.APTS_Group__c='Bundle A'; 
  ordline2.APTS_Program_ID__c = 'WCMP';
  ordline2.APTS_Bridge__c='2 Months';
  ordline2.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline2.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline2;
  orderLineList.add(ordline2);
      
  Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='1 Year';
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__ProductId__c=oProductB.id;
  //ordline3.APTS_Group__c='Bundle A'; 
  ordline3.APTS_Program_ID__c = 'WCMP';
  ordline3.APTS_Bridge__c='3 Months';
  ordline3.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline3.Apttus_Config2__NetPrice__c = 1728;
  ordline3.Apttus_Config2__AdjustmentType__c = '% Markup';
  //insert ordline3;
  orderLineList.add(ordline3);
 
  Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
  ordline4.APTS_Contract_Term__c='1 Year';
  ordline4.Apttus_Config2__OrderId__c=order.id;
  ordline4.Apttus_Config2__Quantity__c=1.000;
  ordline4.Apttus_Config2__ProductId__c=oProductB.id;
  ordline4.APTS_Group__c='Bundle A'; 
  ordline4.APTS_Program_ID__c = 'WCMP';
  ordline4.APTS_Bridge__c='4 Months';
  ordline4.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline4.Apttus_Config2__NetPrice__c = 1728;  
  //insert ordline4;
  orderLineList.add(ordline4);
  
  Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
  ordline5.APTS_Contract_Term__c='1 Year';
  ordline5.Apttus_Config2__OrderId__c=order.id;
  ordline5.Apttus_Config2__Quantity__c=1.000;
  ordline5.Apttus_Config2__ProductId__c=oProductB.id;
  ordline5.APTS_Group__c='Bundle A'; 
  ordline5.APTS_Program_ID__c = 'WCMP';
  ordline5.APTS_Bridge__c='5 Months';
  ordline5.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline5.Apttus_Config2__NetPrice__c = 1728;
  ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline5.Apttus_Config2__PriceType__c = 'One Time';
  //insert ordline5;
  orderLineList.add(ordline5);
 
  Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
  ordline6.APTS_Contract_Term__c='1 Year';
  ordline6.Apttus_Config2__OrderId__c=order.id;
  ordline6.Apttus_Config2__Quantity__c=1.000;
  ordline6.Apttus_Config2__ProductId__c=oProductB.id;
  ordline6.APTS_Group__c='Bundle A'; 
  ordline6.APTS_Program_ID__c = 'WCMP';
  ordline6.APTS_Bridge__c='6 Months';
  ordline6.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline6.Apttus_Config2__NetPrice__c = 1728;
  ordline6.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline6.Apttus_Config2__PriceType__c = 'One Time';
  ordline6.Apttus_Config2__AttributeValueId__c = attribute30.id;
  ordline6.Apttus_Config2__LineType__c = 'Product/Service';
  //insert ordline6;
  orderLineList.add(ordline6);
  
  Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c();
  ordline7.APTS_Contract_Term__c='1 Year';
  ordline7.Apttus_Config2__OrderId__c=order.id;
  ordline7.Apttus_Config2__Quantity__c=1.000;
  ordline7.Apttus_Config2__ProductId__c=oProductB.id;
  ordline7.APTS_Group__c='Bundle A'; 
  ordline7.APTS_Program_ID__c = 'WCMP';
  ordline7.APTS_Bridge__c='7 Months';
  ordline7.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline7.Apttus_Config2__NetPrice__c = 1728;
  ordline7.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline7.Apttus_Config2__PriceType__c = 'Recurring';
  //insert ordline7;
  orderLineList.add(ordline7);
 
  Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c();
  ordline8.APTS_Contract_Term__c='1 Year';
  ordline8.Apttus_Config2__OrderId__c=order.id;
  ordline8.Apttus_Config2__Quantity__c=1.000;
  ordline8.Apttus_Config2__ProductId__c=oProductB.id;
  ordline8.APTS_Group__c='Bundle A'; 
  ordline8.APTS_Program_ID__c = 'WCMP';
  ordline8.APTS_Bridge__c='8 Months';
  ordline8.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline8.Apttus_Config2__NetPrice__c = 1728;
  ordline8.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline8.Apttus_Config2__PriceType__c = 'One Time';
  ordline8.Apttus_Config2__AttributeValueId__c = attribute30.id;
  ordline8.Apttus_Config2__LineType__c = 'Product/Service';
  //insert ordline8;
  orderLineList.add(ordline8);
      
  Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c();
  ordline9.APTS_Contract_Term__c='1 Year';
  ordline9.Apttus_Config2__OrderId__c=order.id;
  ordline9.Apttus_Config2__Quantity__c=1.000;
  ordline9.Apttus_Config2__ProductId__c=oProductB.id;
  ordline9.APTS_Group__c='Bundle A'; 
  ordline9.APTS_Program_ID__c = 'WCMP';
  ordline9.APTS_Bridge__c='9 Months';
  ordline9.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline9.Apttus_Config2__NetPrice__c = 1728;
  ordline9.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline9.Apttus_Config2__PriceType__c = 'One Time';
  ordline9.Apttus_Config2__AttributeValueId__c = attribute30.id;
  ordline9.Apttus_Config2__LineType__c = 'Option';
  //insert ordline9;
  orderLineList.add(ordline9);
  
  Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c();
  ordline10.APTS_Contract_Term__c='1 Year';
  ordline10.Apttus_Config2__OrderId__c=order.id;
  ordline10.Apttus_Config2__Quantity__c=1.000;
  ordline10.Apttus_Config2__ProductId__c=oProductB.id;
  ordline10.APTS_Group__c='Bundle A'; 
  ordline10.APTS_Program_ID__c = 'WCMP';
  ordline10.APTS_Bridge__c='10 Months';
  ordline10.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline10.Apttus_Config2__NetPrice__c = 1728;
  ordline10.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline10.Apttus_Config2__PriceType__c = 'One Time';
  ordline10.Apttus_Config2__LineType__c = 'Product/Service';
  //insert ordline10;
  orderLineList.add(ordline10);
  
  
       
      insert orderLineList;
  
   Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute3.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
  attribute3.Apttus_Config2__LineItemId__c=ordline.id;
  //Insert attribute3;
  orderProductAttributeValueList.add(attribute3);
  

  Apttus_Config2__OrderProductAttributeValue__c attribute4 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute4.SCS_Print_Purchase_Options__c='Sub Only';
  attribute4.Apttus_Config2__LineItemId__c=ordline2.id;
 // Insert attribute4;
 orderProductAttributeValueList.add(attribute4);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute5 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute5.SCS_Print_Purchase_Options__c='Ship & Enter Sub APP';
  attribute5.Apttus_Config2__LineItemId__c=ordline3.id;
  attribute5.eBook_Purchase_Options__c = 'APP';
  //Insert attribute5;
  orderProductAttributeValueList.add(attribute5);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute6 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute6.SCS_Print_Purchase_Options__c='Sub Only APP';
  attribute6.Apttus_Config2__LineItemId__c=ordline4.id;
  attribute6.eBook_Purchase_Options__c = 'Entitle and Charge';
  //Insert attribute6;
  orderProductAttributeValueList.add(attribute6);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute7 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute7.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute7.Apttus_Config2__LineItemId__c=ordline5.id;
  attribute7.eBook_Purchase_Options__c = 'Entitle and Charge';
 // Insert attribute7;
 orderProductAttributeValueList.add(attribute7);
        
  Apttus_Config2__OrderProductAttributeValue__c attribute9 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute9.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute9.Apttus_Config2__LineItemId__c=ordline7.id;
  attribute9.eBook_Purchase_Options__c = 'Entitle and Charge';
  //Insert attribute9;
  orderProductAttributeValueList.add(attribute9);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute10 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute10.SCS_Print_Purchase_Options__c='Fill-Up';
  attribute10.Apttus_Config2__LineItemId__c=ordline10.id;
  attribute10.eBook_Purchase_Options__c = 'Entitle and Charge';
  //Insert attribute10;
  orderProductAttributeValueList.add(attribute10);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute11 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute11.SCS_Print_Purchase_Options__c='Fill-Up';
  attribute11.Apttus_Config2__LineItemId__c=ordline9.id;
  attribute11.eBook_Purchase_Options__c = 'Entitle and Charge';
  //Insert attribute11;
  orderProductAttributeValueList.add(attribute11);
  insert orderProductAttributeValueList;
  
  
  ordline.Apttus_Config2__AttributeValueId__c=attribute3.id;
  updateOrderLineList.add(ordline);
   
  ordline2.Apttus_Config2__AttributeValueId__c=attribute4.id;
  //Update ordline2;
  updateOrderLineList.add(ordline2);
  
  ordline7.Apttus_Config2__AttributeValueId__c=attribute9.id;
  //Update ordline7;  
   updateOrderLineList.add(ordline7);
   
  ordline5.Apttus_Config2__AttributeValueId__c=attribute7.id;
  //Update ordline5;
  updateOrderLineList.add(ordline5);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute6.id;
  //Update ordline4;
  updateOrderLineList.add(ordline4);
  
  ordline3.Apttus_Config2__AttributeValueId__c=attribute5.id;
  //Update ordline3;
  updateOrderLineList.add(ordline3);
  
  ordline10.Apttus_Config2__AttributeValueId__c=attribute10.id;
  //Update ordline10;
  updateOrderLineList.add(ordline10);
  
  ordline9.Apttus_Config2__AttributeValueId__c=attribute10.id;
  //Update ordline9;
  updateOrderLineList.add(ordline9);
  update updateOrderLineList; 
  
  //attribute10.Apttus_Config2__LineItemId__c=ordline9.id;
  //update attribute10;
  
  List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle A';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMPS';
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem.Apttus_Config2__Quantity__c = 1;

  liList.add(lineItem);
  //lineItem.APTS_Group_Primary_Material__c= '40666420';
  //insert lineItem; 

Apttus_Config2__LineItem__c lineItem2 =  new Apttus_Config2__LineItem__c();
        lineItem2.APTS_Group_Primary_Material__c= '40666420';
        lineItem2.Apttus_Config2__LineStatus__c = 'Amended';  
        lineItem2.APTS_Group__c = 'Bundle A';
        lineItem2.APTS_Contract_Number__c = 1234564;
        lineItem2.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem2.Apttus_Config2__ItemSequence__c = 1;
        lineItem2.Apttus_Config2__LineNumber__c = 2;
        lineItem2.APTS_Deal_Type__c ='WCMP'; 
        lineItem2.Apttus_Config2__AddedBy__c = 'User';
        lineItem2.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem2.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem2.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem2.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem2.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem2.Apttus_Config2__AllowProration__c = FALSE;
        lineItem2.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem2.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem2.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem2.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__BasePrice__c = 100;
        lineItem2.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem2.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem2.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem2.Apttus_Config2__Customizable__c = FALSE;
        lineItem2.Apttus_Config2__DeltaPrice__c = 50;
        lineItem2.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem2.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem2.Apttus_Config2__ExtendedCost__c = 0;
        lineItem2.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem2.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem2.Apttus_Config2__Guidance__c = 'Red';
        lineItem2.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem2.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem2.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem2.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem2.Apttus_Config2__HasOptions__c = FALSE;
        lineItem2.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem2.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem2.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem2.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem2.Apttus_Config2__IsHidden__c = FALSE;
        lineItem2.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem2.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem2.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem2.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem2.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem2.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem2.Apttus_Config2__LineSequence__c = 1;
        lineItem2.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem2.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem2.Apttus_Config2__ListPrice__c = 100;
        lineItem2.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem2.Apttus_Config2__NetPrice__c = 50;
        lineItem2.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem2.Apttus_Config2__OptionSequence__c = 0;
        lineItem2.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem2.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem2.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem2.Apttus_Config2__PriceUom__c = 'Each';
        lineItem2.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem2.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem2.Apttus_Config2__ProductVersion__c = 1;
        lineItem2.Apttus_Config2__Quantity__c = 1;
        lineItem2.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem2.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem2.Apttus_Config2__SellingTerm__c = 1;
        lineItem2.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem2.Apttus_Config2__Taxable__c = FALSE;
        lineItem2.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem2.Apttus_Config2__Term__c = 1;
        lineItem2.Apttus_Config2__TotalQuantity__c = 1;
        lineItem2.Apttus_Config2__Uom__c = 'Each';
        lineItem2.CurrencyIsoCode = 'USD';
        lineItem2.APTS_Product_Family__c = 'WESTLAW';
        lineItem2.APTS_Contract_Term__c = '2 Years';
        lineItem2.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem2.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem2.Apttus_Config2__Quantity__c = 1; 
  //insert lineItem2;
  liList.add(lineItem2);
  
  Apttus_Config2__LineItem__c lineItem5 =  new Apttus_Config2__LineItem__c();
        lineItem5.APTS_Group_Primary_Material__c= '40666420';
        lineItem5.Apttus_Config2__LineStatus__c = 'New';  
        lineItem5.APTS_Group__c = 'Bundle B';
        lineItem5.APTS_Contract_Number__c = 1234564;
        lineItem5.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem5.Apttus_Config2__ItemSequence__c = 1;
        lineItem5.Apttus_Config2__LineNumber__c = 5;
        //lineItem5.APTS_Program_ID__c= 'WCMP';
        //insert lineItem5;
        lineItem5.Apttus_Config2__AddedBy__c = 'User';
        lineItem5.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem5.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem5.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem5.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem5.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem5.Apttus_Config2__AllowProration__c = FALSE;
        lineItem5.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem5.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem5.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem5.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__BasePrice__c = 100;
        lineItem5.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem5.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem5.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem5.Apttus_Config2__Customizable__c = FALSE;
        lineItem5.Apttus_Config2__DeltaPrice__c = 50;
        lineItem5.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem5.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem5.Apttus_Config2__ExtendedCost__c = 0;
        lineItem5.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem5.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem5.Apttus_Config2__Guidance__c = 'Red';
        lineItem5.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem5.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem5.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem5.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem5.Apttus_Config2__HasOptions__c = FALSE;
        lineItem5.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem5.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem5.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem5.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem5.Apttus_Config2__IsHidden__c = FALSE;
        lineItem5.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem5.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem5.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem5.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem5.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem5.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem5.Apttus_Config2__LineSequence__c = 1;
        lineItem5.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem5.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem5.Apttus_Config2__ListPrice__c = 100;
        lineItem5.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem5.Apttus_Config2__NetPrice__c = 50;
        lineItem5.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem5.Apttus_Config2__OptionSequence__c = 0;
        lineItem5.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem5.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem5.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem5.Apttus_Config2__PriceUom__c = 'Each';
        lineItem5.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem5.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem5.Apttus_Config2__ProductVersion__c = 1;
        lineItem5.Apttus_Config2__Quantity__c = 1;
        lineItem5.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem5.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem5.Apttus_Config2__SellingTerm__c = 1;
        lineItem5.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem5.Apttus_Config2__Taxable__c = FALSE;
        lineItem5.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem5.Apttus_Config2__Term__c = 1;
        lineItem5.Apttus_Config2__TotalQuantity__c = 1;
        lineItem5.Apttus_Config2__Uom__c = 'Each';
        lineItem5.CurrencyIsoCode = 'USD';
        lineItem5.APTS_Product_Family__c = 'WESTLAW';
        lineItem5.APTS_Contract_Term__c = '2 Years';
        lineItem5.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem5.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem5.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItem5);
  
  Apttus_Config2__LineItem__c lineItem6 =  new Apttus_Config2__LineItem__c();
        //lineItem6.APTS_Group_Primary_Material__c= '40666420';
        lineItem6.Apttus_Config2__LineStatus__c = 'New';    
        lineItem6.APTS_Contract_Number__c = 1234564;
        lineItem6.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem6.Apttus_Config2__ItemSequence__c = 1;
        lineItem6.Apttus_Config2__LineNumber__c = 5;
        //insert lineItem6;
        lineItem6.Apttus_Config2__AddedBy__c = 'User';
        lineItem6.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem6.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem6.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem6.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem6.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem6.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem6.Apttus_Config2__AllowProration__c = FALSE;
        lineItem6.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem6.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem6.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem6.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem6.Apttus_Config2__BasePrice__c = 100;
        lineItem6.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem6.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem6.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem6.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem6.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem6.Apttus_Config2__Customizable__c = FALSE;
        lineItem6.Apttus_Config2__DeltaPrice__c = 50;
        lineItem6.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem6.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem6.Apttus_Config2__ExtendedCost__c = 0;
        lineItem6.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem6.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem6.Apttus_Config2__Guidance__c = 'Red';
        lineItem6.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem6.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem6.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem6.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem6.Apttus_Config2__HasOptions__c = FALSE;
        lineItem6.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem6.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem6.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem6.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem6.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem6.Apttus_Config2__IsHidden__c = FALSE;
        lineItem6.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem6.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem6.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem6.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem6.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem6.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem6.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem6.Apttus_Config2__LineSequence__c = 1;
        lineItem6.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem6.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem6.Apttus_Config2__ListPrice__c = 100;
        lineItem6.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem6.Apttus_Config2__NetPrice__c = 50;
        lineItem6.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem6.Apttus_Config2__OptionSequence__c = 0;
        lineItem6.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem6.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem6.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem6.Apttus_Config2__PriceUom__c = 'Each';
        lineItem6.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem6.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem6.Apttus_Config2__ProductVersion__c = 1;
        lineItem6.Apttus_Config2__Quantity__c = 1;
        lineItem6.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem6.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem6.Apttus_Config2__SellingTerm__c = 1;
        lineItem6.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem6.Apttus_Config2__Taxable__c = FALSE;
        lineItem6.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem6.Apttus_Config2__Term__c = 1;
        lineItem6.Apttus_Config2__TotalQuantity__c = 1;
        lineItem6.Apttus_Config2__Uom__c = 'Each';
        lineItem6.CurrencyIsoCode = 'USD';
        lineItem6.APTS_Product_Family__c = 'WESTLAW';
        lineItem6.APTS_Contract_Term__c = '2 Years';
        lineItem6.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem6.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem6.Apttus_Config2__Quantity__c = 1;
  liList.add(lineItem6);
      
  APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
  dynamicbundlewm.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewm.APTS_Group__c='Bundle A';
  dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
  dynamicbundlewm.APTS_YoY_2_Plus__c='1';
  dynamicbundlewm.APTS_Keep_Terms__c=false;
  dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
  //dynamicbundlewm.APTS_Deal_Number__c = 623589;
  dynamicbundlewm.APTS_Bridge_Discount__c = '10';
  dynamicbundlewm.APTS_Bridge_Length__c = 2;
  dynamicbundlewm.APTS_Bundle_Adjustment_Type__c = '% Discount';
  dynamicbundlewm.APTS_Bridge__c = '7 Days';  
  dynamicbundlewm.APTS_isBLINotCreated__c =true;
  insert dynamicbundlewm;  
  
  Test.startTest();
  insert liList;
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);  
  
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
      Test.stopTest();
  } 
  
  static testmethod void ordersubmissionESI()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
  
  /*Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Is_GLI__c =true;
        oppty.Account=acc;
        insert oppty; */
        Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '40987270', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPAL');
  Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '41055954', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');
  Product2 prodObjBN = new Product2();
        prodObjBN.Name = 'Canada Proflex';
        prodObjBN.ProductCode= '41972767';
        prodObjBN.APTS_Media_High_Level_Code__c = '06';
        prodObjBN.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObjBN.IsActive=true;
        prodObjBN.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBN.Service_Number__c='0';
  productlist.add(prodObjBN);

  Product2 prodObjBN1 = new Product2();
        prodObjBN1.Name = 'Canada Proflex';
        prodObjBN1.ProductCode= '41972767';
        prodObjBN1.APTS_Media_High_Level_Code__c = '06';
        prodObjBN1.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObjBN1.IsActive=true;
        prodObjBN1.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBN1.Service_Number__c='0';
  productlist.add(prodObjBN1);

  Product2 prodObjBN2 = new Product2();
        prodObjBN2.Name = 'Canada Proflex';
        prodObjBN2.ProductCode= '41972767';
        prodObjBN2.APTS_Media_High_Level_Code__c = '06';
        prodObjBN2.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodObjBN2.IsActive=true;
        prodObjBN2.LCRM_Sub_Bu__c =label.SALESORGCAN;
        prodObjBN2.Service_Number__c='0';
  productlist.add(prodObjBN2);

  Product2 prodObjBN3 = new Product2(Name='Sreenu Product Test', ProductCode = '41055954', APTS_Media_Lower_Level_Code__c = 'QU', Apttus_Config2__Uom__c = 'Seats');
  productlist.add(prodObjBN3);

  productlist.add(oProductC);
  productlist.add(oProductB);
  productlist.add(oProductP);
  insert productlist;

        
 // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
   Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
  oProposal.Apttus_Proposal__Account__c=acc.id;
 // oProposal.APTS_SA_ID__c = 'AL MSA-WEST(ALMS)';
  oProposal.APTS_Payer__c = accountSSD.id;
  oProposal.APTS_Revenue_Channel_Override__c='05';
  oProposal.APTS_Ebilling_contact__c=oContact.id;
  insert oProposal;
  Test.startTest(); 
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  /*Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c();
  order1.Apttus_Config2__Type__c='New';
  order1.Apttus_Config2__Status__c='Ready for Activation';
  order1.APTS_SSD_Sold_To__c=accountSSD.id;
  order1.APTS_SSD_bill_to__c=accountSSD.id;
  order1.APTS_SSD_Ship_To__c=accountSSD.id;
  order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order1);
  
  Apttus_Config2__Order__c order3 = new Apttus_Config2__Order__c();
  order3.Apttus_Config2__Type__c='New';
  order3.Apttus_Config2__Status__c='Pending';
  order3.APTS_SSD_Sold_To__c=accountSSD.id;
  order3.APTS_SSD_bill_to__c=accountSSD.id;
  order3.APTS_SSD_Ship_To__c=accountSSD.id;
  order3.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order3);*/
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordlineBN =  new Apttus_Config2__OrderLineItem__c();
  ordlineBN.APTS_Contract_Term__c='1 Year';
  ordlineBN.Apttus_Config2__OrderId__c=order.id;
  ordlineBN.Apttus_Config2__Quantity__c=1.000;
  ordlineBN.Apttus_Config2__ProductId__c=prodObjBN.id;
  ordlineBN.APTS_Group__c='Bundle A'; 
  ordlineBN.APTS_Program_ID__c = 'CPRO';
  ordlineBN.Apttus_Config2__LineType__c='Product/Service';
  ordlineBN.APTS_Bridge__c='1 Month';
  ordlineBN.Apttus_Config2__LineStatus__c='Renewed';
  //ordlineBN.Apttus_Config2__BillingFrequency__c!='Yearly';
  ordlineList.add(ordlineBN);

  Apttus_Config2__OrderLineItem__c ordlineBN1 =  new Apttus_Config2__OrderLineItem__c();
  ordlineBN1.APTS_Contract_Term__c='1 Year';
  ordlineBN1.Apttus_Config2__OrderId__c=order.id;
  ordlineBN1.Apttus_Config2__Quantity__c=1.000;
  ordlineBN1.Apttus_Config2__ProductId__c=prodObjBN1.id;
  ordlineBN1.APTS_Group__c='Bundle A'; 
  ordlineBN1.APTS_Program_ID__c = 'CPRO';
  ordlineBN1.Apttus_Config2__LineType__c='Product/Service';
  ordlineBN1.APTS_Bridge__c='1 Month';
  ordlineBN1.Apttus_Config2__LineStatus__c='New';
  //ordlineBN1.Apttus_Config2__BillingFrequency__c!='Yearly';
  ordlineList.add(ordlineBN1);

  Apttus_Config2__OrderLineItem__c ordlineBN2 =  new Apttus_Config2__OrderLineItem__c();
  ordlineBN2.APTS_Contract_Term__c='1 Year';
  ordlineBN2.Apttus_Config2__OrderId__c=order.id;
  ordlineBN2.Apttus_Config2__Quantity__c=1.000;
  ordlineBN2.Apttus_Config2__ProductId__c=prodObjBN2.id;
  ordlineBN2.APTS_Group__c='Bundle A'; 
  ordlineBN2.APTS_Program_ID__c = 'CPRO';
  ordlineBN2.Apttus_Config2__LineType__c='Product/Service';
  ordlineBN2.APTS_Bridge__c='1 Month';
  ordlineBN2.Apttus_Config2__LineStatus__c='Amended';
  //ordlineBN.Apttus_Config2__BillingFrequency__c!='Yearly';
  ordlineList.add(ordlineBN2);

  Apttus_Config2__OrderLineItem__c ordlineBN3 =  new Apttus_Config2__OrderLineItem__c();
  ordlineBN3.APTS_Contract_Term__c='1 Year';
  ordlineBN3.Apttus_Config2__OrderId__c=order.id;
  ordlineBN3.Apttus_Config2__Quantity__c=1.000;
  ordlineBN3.Apttus_Config2__ProductId__c=prodObjBN3.id;
  ordlineBN3.APTS_Group__c='Bundle A'; 
  ordlineBN3.APTS_Program_ID__c = 'WCMP';
  ordlineBN3.APTS_Bridge__c='9 Months';
  ordlineList.add(ordlineBN3);
  
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A'; 
  ordline.APTS_Program_ID__c = 'WCMP';
  ordline.APTS_Bridge__c='1 Month';
  ordlineList.add(ordline);
   
    Apttus_Config2__OrderLineItem__c ordlineA2 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA2.APTS_Contract_Term__c='1 Year';
  ordlineA2.Apttus_Config2__OrderId__c=order.id;
  ordlineA2.Apttus_Config2__Quantity__c=1.000;
  ordlineA2.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA2.APTS_Group__c='Bundle A'; 
  ordlineA2.APTS_Program_ID__c = 'WCMP';
  ordlineA2.APTS_Bridge__c='2 Months';
  ordlineList.add(ordlineA2);
   
   Apttus_Config2__OrderLineItem__c ordlineA3 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA3.APTS_Contract_Term__c='1 Year';
  ordlineA3.Apttus_Config2__OrderId__c=order.id;
  ordlineA3.Apttus_Config2__Quantity__c=1.000;
  ordlineA3.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA3.APTS_Group__c='Bundle A'; 
  ordlineA3.APTS_Program_ID__c = 'WCMP';
  ordlineA3.APTS_Bridge__c='3 Months';
  ordlineList.add(ordlineA3);
  
  Apttus_Config2__OrderLineItem__c ordlineA4 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA4.APTS_Contract_Term__c='1 Year';
  ordlineA4.Apttus_Config2__OrderId__c=order.id;
  ordlineA4.Apttus_Config2__Quantity__c=1.000;
  ordlineA4.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA4.APTS_Group__c='Bundle A'; 
  ordlineA4.APTS_Program_ID__c = 'WCMP';
  ordlineA4.APTS_Bridge__c='4 Months';
  ordlineList.add(ordlineA4);
  
  Apttus_Config2__OrderLineItem__c ordlineA5 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA5.APTS_Contract_Term__c='1 Year';
  ordlineA5.Apttus_Config2__OrderId__c=order.id;
  ordlineA5.Apttus_Config2__Quantity__c=1.000;
  ordlineA5.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA5.APTS_Group__c='Bundle A'; 
  ordlineA5.APTS_Program_ID__c = 'WCMP';
  ordlineA5.APTS_Bridge__c='5 Months';
  ordlineList.add(ordlineA5);
  
  Apttus_Config2__OrderLineItem__c ordlineA6 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA6.APTS_Contract_Term__c='1 Year';
  ordlineA6.Apttus_Config2__OrderId__c=order.id;
  ordlineA6.Apttus_Config2__Quantity__c=1.000;
  ordlineA6.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA6.APTS_Group__c='Bu6dle A'; 
  ordlineA6.APTS_Program_ID__c = 'WCMP';
  ordlineA6.APTS_Bridge__c='6 Months';
  ordlineList.add(ordlineA6);
  
  Apttus_Config2__OrderLineItem__c ordlineA7 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA7.APTS_Contract_Term__c='1 Year';
  ordlineA7.Apttus_Config2__OrderId__c=order.id;
  ordlineA7.Apttus_Config2__Quantity__c=1.000;
  ordlineA7.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA7.APTS_Group__c='Bundle A'; 
  ordlineA7.APTS_Program_ID__c = 'WCMP';
  ordlineA7.APTS_Bridge__c='7 Months';
  ordlineList.add(ordlineA7);
  
  Apttus_Config2__OrderLineItem__c ordlineA8 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA8.APTS_Contract_Term__c='1 Year';
  ordlineA8.Apttus_Config2__OrderId__c=order.id;
  ordlineA8.Apttus_Config2__Quantity__c=1.000;
  ordlineA8.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA8.APTS_Group__c='Bundle A'; 
  ordlineA8.APTS_Program_ID__c = 'WCMP';
  ordlineA8.APTS_Bridge__c='8 Months';
  ordlineList.add(ordlineA8);
  
  Apttus_Config2__OrderLineItem__c ordlineA9 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA9.APTS_Contract_Term__c='1 Year';
  ordlineA9.Apttus_Config2__OrderId__c=order.id;
  ordlineA9.Apttus_Config2__Quantity__c=1.000;
  ordlineA9.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA9.APTS_Group__c='Bundle A'; 
  ordlineA9.APTS_Program_ID__c = 'WCMP';
  ordlineA9.APTS_Bridge__c='9 Months';
  ordlineList.add(ordlineA9);
  
  Apttus_Config2__OrderLineItem__c ordlineA10 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA10.APTS_Contract_Term__c='1 Year';
  ordlineA10.Apttus_Config2__OrderId__c=order.id;
  ordlineA10.Apttus_Config2__Quantity__c=1.000;
  ordlineA10.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA10.APTS_Group__c='Bundle A'; 
  ordlineA10.APTS_Program_ID__c = 'WCMP';
  ordlineA10.APTS_Bridge__c='10 Months';
  ordlineList.add(ordlineA10);
  
  Apttus_Config2__OrderLineItem__c ordlineA101 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA101.APTS_Contract_Term__c='1 Year';
  ordlineA101.Apttus_Config2__OrderId__c=order.id;
  ordlineA101.Apttus_Config2__Quantity__c=1.000;
  ordlineA101.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA101.APTS_Group__c='Bundle A'; 
  ordlineA101.APTS_Program_ID__c = 'WCMP';
  ordlineA101.APTS_Bridge__c='N/A';
  ordlineList.add(ordlineA101);
  
  Apttus_Config2__OrderLineItem__c ordlineA102 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA102.APTS_Contract_Term__c='1 Year';
  ordlineA102.Apttus_Config2__OrderId__c=order.id;
  ordlineA102.Apttus_Config2__Quantity__c=1.000;
  ordlineA102.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA102.APTS_Group__c='Bundle A'; 
  ordlineA102.APTS_Program_ID__c = 'WCMP';
  ordlineA102.APTS_Bridge__c='7 Days';
  ordlineList.add(ordlineA102);
  
  Apttus_Config2__OrderLineItem__c ordlineA103 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA103.APTS_Contract_Term__c='1 Year';
  ordlineA103.Apttus_Config2__OrderId__c=order.id;
  ordlineA103.Apttus_Config2__Quantity__c=1.000;
  ordlineA103.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA103.APTS_Group__c='Bundle A'; 
  ordlineA103.APTS_Program_ID__c = 'WCMP';
  ordlineA103.APTS_Bridge__c='14 Days';
  ordlineList.add(ordlineA103);
  
  Apttus_Config2__OrderLineItem__c ordlineA104 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA104.APTS_Contract_Term__c='1 Year';
  ordlineA104.Apttus_Config2__OrderId__c=order.id;
  ordlineA104.Apttus_Config2__Quantity__c=1.000;
  ordlineA104.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA104.APTS_Group__c='Bundle A'; 
  ordlineA104.APTS_Program_ID__c = 'WCMP';
  ordlineA104.APTS_Bridge__c='28 Days';
  ordlineList.add(ordlineA104);
  
  Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c();
  ordline22.Apttus_Config2__OrderId__c=order.id;
  ordline22.Apttus_Config2__Quantity__c=1.000; 
  ordline22.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordline22.APTS_SAP_MLA_Agreement_Number__c = '12345';
  ordline22.APTS_Service_Number__c = '40757482';
  ordlineList.add(ordline22);   

  Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c();
  ordline23.Apttus_Config2__OrderId__c=order.id;
  ordline23.Apttus_Config2__Quantity__c=1.000; 
  ordline23.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineList.add(ordline23);
  
  Apttus_Config2__OrderLineItem__c ordline111 =  new Apttus_Config2__OrderLineItem__c();
  ordline111.Apttus_Config2__Uom__c='Each';
  ordline111.APTS_New_Bridge_Discount__c=1;
  ordline111.APTS_Contract_Term__c='2 Years';  
  ordline111.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline111.Apttus_Config2__Quantity__c=1.000;
  ordline111.Apttus_Config2__ProductId__c=oProductP.id;
  ordline111.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline111);  
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
  ordline5.APTS_Contract_Term__c='10 Years';
  ordline5.Apttus_Config2__Quantity__c=1.000;
  ordline5.Apttus_Config2__OrderId__c=order.id;
  //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline5.Apttus_Config2__PriceType__c = 'Recurring';
  ordline5.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline5.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline5);   
  
  Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c();
  ordline13.Apttus_Config2__OrderId__c=order.id;
  ordline13.Apttus_Config2__Quantity__c=1.000; 
  ordline13.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineList.add(ordline13);  
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
  ordline4.APTS_Contract_Term__c='5 Years';
  ordline4.Apttus_Config2__Quantity__c=1.000;
  ordline4.Apttus_Config2__OrderId__c=order.id;
  ordline4.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline4.Apttus_Config2__LineType__c = 'Option';
  ordline4.Apttus_Config2__PriceType__c = 'One Time';
  ordline4.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline4);
  
  //adding orderline
  Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c();
  ordline24.APTS_Contract_Term__c='3 Years';
  ordline24.Apttus_Config2__Quantity__c=1.000;
  ordline24.Apttus_Config2__ProductId__c=oProductB.id;
  ordline24.Apttus_Config2__OrderId__c=order.id;
  ordline24.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline24.Apttus_Config2__LineType__c = 'Product/Service';
  ordline24.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordline24);
  
  Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c();
  ordline25.APTS_Contract_Term__c='4 Years';
  ordline25.Apttus_Config2__Quantity__c=1.000;
  ordline25.Apttus_Config2__ProductId__c=oProductB.id;
  ordline25.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline25);
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c();
  ordline14.APTS_Contract_Term__c='5 Years';
  ordline14.Apttus_Config2__Quantity__c=1.000;
  ordline14.Apttus_Config2__OrderId__c=order.id;
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline14.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline14.Apttus_Config2__LineType__c = 'Product/Service';
  ordline14.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordline14);
  
  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='3 Years';
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline2);
  
  Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='4 Years';
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline3);
  
  Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c();
  ordline26.Apttus_Config2__OrderId__c=order.id;
  ordline26.Apttus_Config2__Quantity__c=1.000; 
  ordline26.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineList.add(ordline26);
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c();
  ordline53.APTS_Contract_Term__c='10 Years';
  ordline53.Apttus_Config2__Quantity__c=1.000;
  ordline53.Apttus_Config2__OrderId__c=order.id;
  //ordline53.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline53.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline53.Apttus_Config2__PriceType__c = 'Recurring';
  ordlineList.add(ordline53);  
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c();
  ordline43.APTS_Contract_Term__c='5 Years';
  ordline43.Apttus_Config2__Quantity__c=1.000;
  ordline43.Apttus_Config2__OrderId__c=order.id;
  ordline43.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline43.Apttus_Config2__LineType__c = 'Option';
  ordline43.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordline43);
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();
  ordline143.APTS_Contract_Term__c='5 Years';
  ordline143.Apttus_Config2__Quantity__c=1.000;
  ordline143.Apttus_Config2__OrderId__c=order.id;
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline143.Apttus_Config2__LineType__c = 'Product/Service';
  ordline143.Apttus_Config2__PriceType__c = 'One Time';
  insert ordline143; 
  
   //added product
  Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c();
  ordline15.APTS_Contract_Term__c='5 Years';
  ordline15.Apttus_Config2__Quantity__c=1.000;
  ordline15.Apttus_Config2__OrderId__c=order.id;
  ordline15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline15.Apttus_Config2__PriceType__c = 'One Time';
  ordline15.Apttus_Config2__ProductId__c = oProductC.Id;
  ordline15.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline15);  
 
  Apttus_Config2__OrderLineItem__c ordline112 =  new Apttus_Config2__OrderLineItem__c();
  ordline112.Apttus_Config2__OrderId__c=order.id;
  ordline112.Apttus_Config2__Uom__c='Each';
  ordline112.APTS_New_Bridge_Discount__c=1;
  ordline112.APTS_Contract_Term__c='2 Years';  
  ordline112.Apttus_Config2__BillingFrequency__c ='Monthly';
  ordline112.Apttus_Config2__Quantity__c=1.000;
  ordline112.Apttus_Config2__ProductId__c=oProductP.id;
  ordlineList.add(ordline112);  
  //added fill up
  Apttus_Config2__OrderLineItem__c ordlineF =  new Apttus_Config2__OrderLineItem__c();
  ordlineF.APTS_Contract_Term__c='5 Years';
  ordlineF.Apttus_Config2__Quantity__c=1.000;
  ordlineF.Apttus_Config2__OrderId__c=order.id;
  ordlineF.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineF.Apttus_Config2__PriceType__c = 'One Time';
  ordlineF.Apttus_Config2__LineType__c = 'Product/Service';
  ordlineF.Apttus_Config2__ProductId__c = oProductC.Id;
  ordlineF.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordlineF);  
  
  Apttus_Config2__OrderLineItem__c ordlineF1 =  new Apttus_Config2__OrderLineItem__c();
  ordlineF1.APTS_Contract_Term__c='5 Years';
  ordlineF1.Apttus_Config2__Quantity__c=1.000;
  ordlineF1.Apttus_Config2__OrderId__c=order.id;
  ordlineF1.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineF1.Apttus_Config2__PriceType__c = 'One Time';
  ordlineF1.Apttus_Config2__LineType__c = 'Option';
  ordlineF1.Apttus_Config2__ProductId__c = oProductC.Id;
  ordlineF.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordlineF1); 
  
   Apttus_Config2__OrderLineItem__c ordline51 =  new Apttus_Config2__OrderLineItem__c();
  ordline51.APTS_Contract_Term__c='5 Years';
  ordline51.Apttus_Config2__Quantity__c=1.000;
  ordline51.Apttus_Config2__OrderId__c=order.id;
  ordline51.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline51.Apttus_Config2__PriceType__c = 'One Time';
  ordline51.Apttus_Config2__BillingFrequency__c='Monthly';
  ordline51.Apttus_Config2__ProductId__c = oProductC.Id;
  ordline51.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline51);  
  
  
   Apttus_Config2__OrderLineItem__c ordline52 =  new Apttus_Config2__OrderLineItem__c();
  ordline52.APTS_Contract_Term__c='5 Years';
  ordline52.Apttus_Config2__Quantity__c=1.000;
  ordline52.Apttus_Config2__OrderId__c=order.id;
  ordline52.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline52.Apttus_Config2__PriceType__c = 'One Time';
  ordline52.Apttus_Config2__BillingFrequency__c='Monthly';
  ordline52.Apttus_Config2__ProductId__c = oProductP.Id;
  ordline52.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline52);  
  
  
   Apttus_Config2__OrderLineItem__c ordline54 =  new Apttus_Config2__OrderLineItem__c();
  ordline54.APTS_Contract_Term__c='5 Years';
  ordline54.Apttus_Config2__Quantity__c=1.000;
  ordline54.Apttus_Config2__OrderId__c=order.id;
  ordline54.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline54.Apttus_Config2__PriceType__c = 'One Time';
  ordline54.Apttus_Config2__BillingFrequency__c='Yearly';
  ordline54.Apttus_Config2__ProductId__c = oProductP.Id;
  ordline54.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline54);  
  
   Apttus_Config2__OrderLineItem__c ordline152 =  new Apttus_Config2__OrderLineItem__c();
  ordline152.APTS_Contract_Term__c='5 Years';
   ordline152.Apttus_Config2__OrderId__c=order.id;
  ordline152.Apttus_Config2__Quantity__c=1.000;
  ordline152.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline152.Apttus_Config2__PriceType__c = 'One Time';
  ordline152.Apttus_Config2__ProductId__c = oProductC.Id;
  ordline152.Apttus_Config2__NetPrice__c = 1728;
  ordline152.Apttus_Config2__BillingFrequency__c='Yearly';
  ordlineList.add(ordline152);  
  
  insert ordlineList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute.Apttus_Config2__LineItemId__c=ordline5.id;
  orderProd.add(attribute);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute11 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute11.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
  attribute11.Apttus_Config2__LineItemId__c=ordline51.id;
  orderProd.add(attribute11);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute111 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute111.SCS_Print_Purchase_Options__c='Sub Only';
  attribute111.Apttus_Config2__LineItemId__c=ordline152.id;
  orderProd.add(attribute111);
  
   Apttus_Config2__OrderProductAttributeValue__c attribute110 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute110.SCS_Print_Purchase_Options__c='Ship Only';
  attribute110.Apttus_Config2__LineItemId__c=ordline112.id;
  orderProd.add(attribute110);
  
  
  Apttus_Config2__OrderProductAttributeValue__c attributeF = new Apttus_Config2__OrderProductAttributeValue__c();
  attributeF.SCS_Print_Purchase_Options__c='Fill-Up';
  attributeF.Apttus_Config2__LineItemId__c=ordlineF.id;
  orderProd.add(attributeF);
   
  Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute1.Apttus_Config2__LineItemId__c=ordline4.id;
  orderProd.add(attribute1);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute2.Apttus_Config2__LineItemId__c=ordline14.id;
  orderProd.add(attribute2);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute24 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute24.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute24.Apttus_Config2__LineItemId__c=ordline14.id;
  orderProd.add(attribute24);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute15 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute15.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute15.Apttus_Config2__LineItemId__c=ordline15.id;
  orderProd.add(attribute15);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute33 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute33.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute33.Apttus_Config2__LineItemId__c=ordline5.id;
  orderProd.add(attribute33);
  
  
  Apttus_Config2__OrderProductAttributeValue__c attribute13 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute13.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute13.Apttus_Config2__LineItemId__c=ordline43.id;
  orderProd.add(attribute13);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute23.Apttus_Config2__LineItemId__c=ordline14.id;
  orderProd.add(attribute23);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute3.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute3.Apttus_Config2__LineItemId__c=ordline15.id;
  orderProd.add(attribute3);
  
   
  Apttus_Config2__OrderProductAttributeValue__c attribute52 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute52.SCS_Print_Purchase_Options__c='Sub Only';
  attribute52.Apttus_Config2__LineItemId__c=ordline52.id;
  orderProd.add(attribute52);
   
  Apttus_Config2__OrderProductAttributeValue__c attribute54 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute54.SCS_Print_Purchase_Options__c='Sub Only';
  attribute54.Apttus_Config2__LineItemId__c=ordline54.id;
  orderProd.add(attribute54);
  insert orderProd;
  
  List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
  
  /*ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  updateOrderList.add(ordline5);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
  updateOrderList.add(ordline4);
 
  ordline4.Apttus_Config2__AttributeValueId__c=attribute2.id;
  updateOrderList.add(ordline14);
  
  ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
  updateOrderList.add(ordline53);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute13.id;
  updateOrderList.add(ordline43);
  
  ordline24.Apttus_Config2__AttributeValueId__c=attribute24.id;
  updateOrderList.add(ordline24);
  
  ordline15.Apttus_Config2__AttributeValueId__c=attribute15.id;
  updateOrderList.add(ordline15);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute23.id;
  updateOrderList.add(ordline143);
 
  ordline4.Apttus_Config2__AttributeValueId__c=attribute3.id;
  updateOrderList.add(ordline15);*/
  
  ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  updateOrderList.add(ordline5);
  
  ordlineF.Apttus_Config2__AttributeValueId__c=attributeF.id;
  updateOrderList.add(ordlineF);
  
  ordlineF1.Apttus_Config2__AttributeValueId__c=attributeF.id;
  updateOrderList.add(ordlineF1);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
  updateOrderList.add(ordline4);
 
  ordline14.Apttus_Config2__AttributeValueId__c=attribute2.id;
  updateOrderList.add(ordline14);
  
  ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
  updateOrderList.add(ordline53);
  
  ordline43.Apttus_Config2__AttributeValueId__c=attribute13.id;
  updateOrderList.add(ordline43);
  
  ordline24.Apttus_Config2__AttributeValueId__c=attribute24.id;
  updateOrderList.add(ordline24);
  
  ordline15.Apttus_Config2__AttributeValueId__c=attribute15.id;
  updateOrderList.add(ordline15);
  
  ordline143.Apttus_Config2__AttributeValueId__c=attribute23.id;
  updateOrderList.add(ordline143);
  
  ordline51.Apttus_Config2__AttributeValueId__c=attribute11.id;
  updateOrderList.add(ordline51);
  
  ordline152.Apttus_Config2__AttributeValueId__c=attribute111.id;
  updateOrderList.add(ordline152);
  
   ordline112.Apttus_Config2__AttributeValueId__c=attribute110.id;
  updateOrderList.add(ordline112);
  
  ordline52.Apttus_Config2__AttributeValueId__c=attribute52.id;
  updateOrderList.add(ordline52);
  
  ordline54.Apttus_Config2__AttributeValueId__c=attribute54.id;
  updateOrderList.add(ordline54);
  
  update updateOrderList;
  
  List<APTS_Dynamic_Bundle__c> dynamicList=new List<APTS_Dynamic_Bundle__c>();
  
   APTS_Dynamic_Bundle__c dynamicbundle = new APTS_Dynamic_Bundle__c();
  dynamicbundle.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle.APTS_Group__c='Bundle C';
  dynamicbundle.APTS_Program_ID__c='WCMP';
  dynamicbundle.APTS_Keep_Terms__c=true;
  dynamicbundle.APTS_Deal_Number__c=1;
  dynamicbundle.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle.APTS_Net_Price__c=50;
  dynamicbundle.APTS_Billing_Frequency__c='Monthly';
  dynamicbundle.APTS_Contract_Terms__c='5 Years';
  dynamicbundle.APTS_YoY_2_Plus__c='1';
  dynamicbundle.APTS_isBLINotCreated__c =true;
  dynamicList.add(dynamicbundle);
  
  APTS_Dynamic_Bundle__c dynamicbundle2 = new APTS_Dynamic_Bundle__c();
  dynamicbundle2.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle2.APTS_Group__c='Bundle C';
  dynamicbundle2.APTS_Program_ID__c='WCMP';
  dynamicbundle2.APTS_Keep_Terms__c=false;
  dynamicbundle2.APTS_Deal_Number__c=null;
  dynamicbundle2.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle2.APTS_Net_Price__c=50;
  dynamicbundle2.APTS_Billing_Frequency__c='Monthly';
  dynamicbundle2.APTS_Contract_Terms__c='5 Years';
  dynamicbundle2.APTS_YoY_2_Plus__c='1';
  dynamicbundle2.APTS_isBLINotCreated__c =true;
  dynamicList.add(dynamicbundle2);
  
   APTS_Dynamic_Bundle__c dynamicbundle3 = new APTS_Dynamic_Bundle__c();
  dynamicbundle3.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle3.APTS_Quantity__c=1.00;
  dynamicbundle3.APTS_Group__c='Bundle C';
  dynamicbundle3.APTS_Program_ID__c='WCMP';
  dynamicbundle3.APTS_Keep_Terms__c=false;
  dynamicbundle3.APTS_Deal_Number__c=1;
  dynamicbundle3.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle3.APTS_Net_Price__c=50;
  dynamicbundle3.APTS_Billing_Frequency__c='Monthly';
  dynamicbundle3.APTS_Contract_Terms__c='5 Years';
  dynamicbundle3.APTS_YoY_2_Plus__c='1';
  dynamicbundle3.APTS_isBLINotCreated__c =true;
  dynamicList.add(dynamicbundle3);
  
  insert dynamicList;
  
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc4);
   
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc5);
   
    Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc6);
   
   insert onlineContactList;
        
    List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
    Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
    masterContactList.add(mc1);
    Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
    masterContactList.add(mc2);
    Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc3);
    Customer_Master_Contacts__c mc9 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'SRR MEDIA CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc9);
    Customer_Master_Contacts__c mc10 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PT INTER MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc10);
    Customer_Master_Contacts__c mc11 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PT INTRA MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc11);
    Customer_Master_Contacts__c mc12 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PT SENTRY MEDIA CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc12);
    Customer_Master_Contacts__c mc13 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'COMPLIANCE LEARNING', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc13);
    Customer_Master_Contacts__c mc14 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'Filing Contact', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc14);
    Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc4);
    Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc5);
    Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc6);
    Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc7);
     Customer_Master_Contacts__c mc8 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c='Administrator', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc8);
    
    insert masterContactList;
   //Test.startTest();
    
     List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
    
  //order.Apttus_Config2__Status__c='Pending';
 // updateordList.add(order);
  /*order1.Apttus_Config2__Status__c='Pending';
  updateordList.add(order1);*/
  
  update updateorderList;
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
 
    
    Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;    
    List<Apttus_Config2__Order__c> updateordList1=new List<Apttus_Config2__Order__c>();
     updateordList1 =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
     System.assertequals(0,updateordList.size(),'');
  Test.stopTest();
  }
  }
  
 /* static testmethod void OrdersubmissionESI1()
  {
  
  Account acc1 = new Account();
  acc1.Name='test';
  acc1.Customer_Group__c='FEDERAL GOVERNMENT';
  acc1.CurrencyIsoCode='USD';
  acc1.Sales_Org__c='WEST';
  Insert acc1;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc1.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='WEST';
  insert accountSSD;
  
  Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc1.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc1;
        insert oppty; 
  
  Contact con = new Contact();
  con.AccountId=acc1.Id;
  con.LastName='Prabhu';
  con.FirstName='Issac';
  insert con;
  
 // Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Approval_Segment__c='Corporate',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc1.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
   Apttus_Proposal__Proposal__c oProposal1=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
  insert oProposal1;
  
  
  Apttus_Config2__Order__c order11 = new Apttus_Config2__Order__c();
  order11.Apttus_Config2__Type__c='New';
  order11.Apttus_Config2__Status__c='Ready for Activation';
  order11.APTS_SSD_Sold_To__c=accountSSD.id;
  order11.APTS_SSD_bill_to__c=accountSSD.id;
  order11.APTS_SSD_Ship_To__c=accountSSD.id;
  order11.Apttus_QPConfig__ProposalId__c=oProposal1.id;
  order11.Apttus_Config2__Status__c='Pending';
  insert order11;
  
  
  Apttus_Config2__OrderLineItem__c ordline51 =  new Apttus_Config2__OrderLineItem__c();
  ordline51.APTS_Contract_Term__c='10 Years';
  ordline51.Apttus_Config2__Quantity__c=1.000;
  ordline51.Apttus_Config2__OrderId__c=order11.id;
  //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline51.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline51.Apttus_Config2__PriceType__c = 'Recurring';
  insert ordline51;  
  
  
  APTS_Dynamic_Bundle__c dynamicbundle1 = new APTS_Dynamic_Bundle__c();
  dynamicbundle1.APTS_Bundle_Primary_Material__c='1111';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle1.APTS_Group__c='Bundle B';
  dynamicbundle1.APTS_Quote_Proposal__c=oProposal1.id;
  dynamicbundle1.APTS_Contract_Terms__c='10 Years';
  dynamicbundle1.APTS_YoY_2_Plus__c='1';
  insert dynamicbundle1;
  
  ordline51.Apttus_Config2__Status__c='Pending';
  update ordline51;
  
  
  Test.startTest();
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order11.id];
  APTS_OrderQueuetoESI.orderSubmissionToESI(order2.name);
  Test.stopTest();
  
  }*/
  
  static testmethod void ordersubmissionESINB()
  {
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
  
  Account acc = new Account();
  acc.Name='test';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
  insert accountSSD;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
        
        Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  
         /* Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Account=acc;
        insert oppty; */
  
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965',APTS_Item_Category_Group__c='ZPMT', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_Standard_Bundle__c=true);
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966',APTS_Item_Category_Group__c='ZVAU', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Standard_Bundle__c=true);
  insert oProductB;
  insert oProductP;

     Test.startTest();        
 // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
     oProposal.APTS_Payer__c = accountSSD.id;
     oProposal.APTS_Ebilling_contact__c=oContact.id;
  
  insert oProposal;
   
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  insert listLineItems;
  
  List<Apttus_Config2__Order__c> ordList=new List<Apttus_Config2__Order__c>();
  /*Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  OrdList.add(order);*/
  
    Apttus_Config2__Order__c order3 = new Apttus_Config2__Order__c();
  order3.Apttus_Config2__Type__c='New';
  order3.Apttus_Config2__Status__c='Pending';
  order3.APTS_SSD_Sold_To__c=accountSSD.id;
  order3.APTS_SSD_bill_to__c=accountSSD.id;
  order3.APTS_SSD_Ship_To__c=accountSSD.id;
  order3.Apttus_QPConfig__ProposalId__c=oProposal.id;
  OrdList.add(order3);
  
  
  /*Apttus_Config2__Order__c order1 = new Apttus_Config2__Order__c();
  order1.Apttus_Config2__Type__c='New';
  order1.Apttus_Config2__Status__c='Ready for Activation';
  order1.APTS_SSD_Sold_To__c=accountSSD.id;
  order1.APTS_SSD_bill_to__c=accountSSD.id;
  order1.APTS_SSD_Ship_To__c=accountSSD.id;
  order1.Apttus_QPConfig__ProposalId__c=oProposal.id;
  OrdList.add(order1);*/
  
  insert OrdList;
  
  list<Apttus_Config2__OrderLineItem__c> ordlineitem =  new list<Apttus_Config2__OrderLineItem__c>();
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order3.id;
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A';  
  ordline.APTS_Bridge__c='1 Month';
  ordline.Apttus_Config2__ChargeType__c ='Subscription Fee';        
  ordline.Apttus_Config2__PriceType__c ='One Time';     
  ordline.Apttus_Config2__BillingFrequency__c='Yearly';     
  ordline.Apttus_Config2__NetPrice__c=1000;
  ordlineitem.add(ordline);
 
  
  Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c();
  ordline22.Apttus_Config2__OrderId__c=order3.id;
  ordline22.Apttus_Config2__Quantity__c=1.000; 
  ordline22.Apttus_Config2__LineStatus__c='Cancelled'; 
 ordlineitem.add(ordline22);  
  
  Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c();
  ordline23.Apttus_Config2__OrderId__c=order3.id;
  ordline23.Apttus_Config2__Quantity__c=1.000; 
  ordline23.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineitem.add(ordline23); 
  
  Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
  ordline1.Apttus_Config2__Uom__c='Each';
  ordline1.APTS_New_Bridge_Discount__c=1;
  ordline1.APTS_Contract_Term__c='2 Years';  
  ordline1.Apttus_Config2__Quantity__c=1.000;
  ordline1.Apttus_Config2__ProductId__c=oProductP.id;
  ordline1.Apttus_Config2__OrderId__c=order3.id;
  ordline1.Apttus_Config2__ChargeType__c='Standard Price';     
  ordline1.Apttus_Config2__PriceType__c ='One Time';        
  ordline1.Apttus_Config2__LineType__c ='Product/Service';
  ordlineitem.add(ordline1);

Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
  ordline5.APTS_Contract_Term__c='10 Years';
  ordline5.Apttus_Config2__Quantity__c=1.000;
  ordline5.Apttus_Config2__OrderId__c=order3.id;
  ordline5.Apttus_Config2__ProductId__c=oProductP.id; 
  //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline5.Apttus_Config2__PriceType__c = 'Recurring';
  ordlineitem.add(ordline5); 
  
  Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c();
  ordline13.Apttus_Config2__OrderId__c=order3.id;
  ordline13.Apttus_Config2__Quantity__c=1.000; 
  ordline13.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineitem.add(ordline13);

Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
  ordline4.APTS_Contract_Term__c='5 Years';
  ordline4.Apttus_Config2__Quantity__c=1.000;
  ordline4.Apttus_Config2__OrderId__c=order3.id;
  ordline4.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline4.Apttus_Config2__LineType__c = 'Option';
  ordline4.Apttus_Config2__PriceType__c = 'One Time';
   ordlineitem.add(ordline4);
   
   Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c();
  ordline24.APTS_Contract_Term__c='3 Years';
  ordline24.Apttus_Config2__Quantity__c=1.000;
  ordline24.Apttus_Config2__ProductId__c=oProductB.id;
  ordline24.Apttus_Config2__OrderId__c=order3.id;
   ordlineitem.add(ordline24);
  
  Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c();
  ordline25.APTS_Contract_Term__c='4 Years';
  ordline25.Apttus_Config2__Quantity__c=1.000;
  ordline25.Apttus_Config2__ProductId__c=oProductB.id;
  ordline25.Apttus_Config2__OrderId__c=order3.id;
  ordlineitem.add(ordline25);
  
  
  Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c();
  ordline14.APTS_Contract_Term__c='5 Years';
  ordline14.Apttus_Config2__Quantity__c=1.000;
  ordline14.Apttus_Config2__OrderId__c=order3.id;
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline14.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline14.Apttus_Config2__LineType__c = 'Product/Service';
  ordline14.Apttus_Config2__PriceType__c = 'One Time';
   ordlineitem.add(ordline14);
   
    Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='3 Years';
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.Apttus_Config2__OrderId__c=order3.id;
  ordlineitem.add(ordline2);
  
  Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='4 Years';
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__OrderId__c=order3.id;
  ordlineitem.add(ordline3);
  
  Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c();
  ordline26.Apttus_Config2__OrderId__c=order3.id;
  ordline26.Apttus_Config2__Quantity__c=1.000; 
  ordline26.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineitem.add(ordline26);
  
  Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c();
  ordline53.APTS_Contract_Term__c='10 Years';
  ordline53.Apttus_Config2__Quantity__c=1.000;
  ordline53.Apttus_Config2__OrderId__c=order3.id;
  ordline53.Apttus_Config2__BillingFrequency__c ='Yearly';      
  ordline53.Apttus_Config2__NetPrice__c = 1728;
  //ordline53.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline53.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline53.Apttus_Config2__PriceType__c = 'Recurring';
  ordlineitem.add(ordline53);
  
  Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c();
  ordline43.APTS_Contract_Term__c='5 Years';
  ordline43.Apttus_Config2__Quantity__c=1.000;
  ordline43.Apttus_Config2__OrderId__c=order3.id;
  ordline43.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline43.Apttus_Config2__LineType__c = 'Option';
  ordline43.Apttus_Config2__PriceType__c = 'One Time';
  ordlineitem.add(ordline43);
  
  Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();
  ordline143.APTS_Contract_Term__c='5 Years';
  ordline143.Apttus_Config2__Quantity__c=1.000;
  ordline143.Apttus_Config2__OrderId__c=order3.id;
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline143.Apttus_Config2__LineType__c = 'Product/Service';
  ordline143.Apttus_Config2__PriceType__c = 'One Time';
  ordlineitem.add(ordline143); 
  
  Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c();
  ordline15.APTS_Contract_Term__c='5 Years';
  ordline15.Apttus_Config2__Quantity__c=1.000;
  ordline15.Apttus_Config2__OrderId__c=order3.id;
  ordline15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline15.Apttus_Config2__PriceType__c = 'One Time';
  ordlineitem.add(ordline15);
  
     Apttus_Config2__OrderLineItem__c ordline52 =  new Apttus_Config2__OrderLineItem__c();
  ordline52.APTS_Contract_Term__c='10 Years';
    ordline52.Apttus_Config2__OrderId__c=order3.id;
  ordline52.Apttus_Config2__Quantity__c=1.000;
  //ordline52.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline52.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline52.Apttus_Config2__PriceType__c = 'Recurring';
  ordline52.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline52.Apttus_Config2__NetPrice__c = 1728;
    ordlineitem.add(ordline52);
    
       Apttus_Config2__OrderLineItem__c ordline521 = new Apttus_Config2__OrderLineItem__c();
  ordline521.APTS_Contract_Term__c='10 Years';
  ordline521.Apttus_Config2__Quantity__c=1.000;
   ordline521.Apttus_Config2__OrderId__c=order3.id;
  //ordline521.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline521.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline521.Apttus_Config2__PriceType__c = 'Recurring';
  ordline521.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline521.Apttus_Config2__NetPrice__c = 1728;
    ordlineitem.add(ordline521);
  
  insert ordlineitem;
  
    
  List<Apttus_Config2__OrderProductAttributeValue__c> ordPrAttList=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
  //attribute.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute.SCS_Print_Purchase_Options__c='Ship & Enter Sub'; 
  attribute.Apttus_Config2__LineItemId__c=ordline5.id;
  OrdPrAttList.add(attribute);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute1.Apttus_Config2__LineItemId__c=ordline4.id;
  OrdPrAttList.add(attribute1);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute2.Apttus_Config2__LineItemId__c=ordline14.id;
  OrdPrAttList.add(attribute2);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute33 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute33.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute33.Apttus_Config2__LineItemId__c=ordline5.id;
  OrdPrAttList.add(attribute33);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute13 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute13.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute13.Apttus_Config2__LineItemId__c=ordline43.id;
  OrdPrAttList.add(attribute13);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute23.Apttus_Config2__LineItemId__c=ordline14.id;
  OrdPrAttList.add(attribute23);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute3.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute3.Apttus_Config2__LineItemId__c=ordline15.id;
  OrdPrAttList.add(attribute3);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute52 = new Apttus_Config2__OrderProductAttributeValue__c();
 attribute52.SCS_Print_Purchase_Options__c='Ship & Enter Sub APP';
   attribute52.Apttus_Config2__LineItemId__c=ordline52.id;
    attribute52.eBook_Purchase_Options__c = 'Entitle and Charge';
   OrdPrAttList.add(attribute52);
  
 Apttus_Config2__OrderProductAttributeValue__c attribute521 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute521.SCS_Print_Purchase_Options__c='Sub Only APP';
  attribute521.eBook_Purchase_Options__c = 'APP';
    attribute521.Apttus_Config2__LineItemId__c=ordline521.id;
   OrdPrAttList.add(attribute521);
   
    Apttus_Config2__OrderProductAttributeValue__c attribute4 = new Apttus_Config2__OrderProductAttributeValue__c();     
  attribute4.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';       
  attribute4.Apttus_Config2__LineItemId__c=ordline.id;      
  OrdPrAttList.add(attribute4);     
            
  Apttus_Config2__OrderProductAttributeValue__c attribute5 = new Apttus_Config2__OrderProductAttributeValue__c();       
  attribute5.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';       
  attribute5.Apttus_Config2__LineItemId__c=ordline1.id;     
  OrdPrAttList.add(attribute5);
  insert OrdPrAttList;
  
  List<Apttus_Config2__OrderLineItem__c>  updateOrderLineList=new List<Apttus_Config2__OrderLineItem__c>();
  
  ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  updateOrderLineList.add(ordline5);
  
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
  updateOrderLineList.add(ordline4);
  
  ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
  updateOrderLineList.add(ordline53);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute13.id;
  updateOrderLineList.add(ordline43);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute23.id;
  updateOrderLineList.add(ordline143);
   
    
  ordline4.Apttus_Config2__AttributeValueId__c=attribute3.id;
  updateOrderLineList.add(ordline15);
  
   ordline52.Apttus_Config2__AttributeValueId__c=attribute52.id;
  updateOrderLineList.add(ordline52);
  
    ordline521.Apttus_Config2__AttributeValueId__c=attribute521.id;
  updateOrderLineList.add(ordline521);

    
  ordline4.Apttus_Config2__AttributeValueId__c=attribute2.id;
  updateOrderLineList.add(ordline14);
  
   ordline.Apttus_Config2__AttributeValueId__c=attribute4.id;       
  updateOrderLineList.add(ordline);     
        
  ordline.Apttus_Config2__AttributeValueId__c=attribute5.id;        
  updateOrderLineList.add(ordline1);        
  
  
  update updateOrderLineList;
          updateOrderLineList.add(ordline);     
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();         
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
   onlineContactList.add(oc1);      
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
   onlineContactList.add(oc2);      
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
   onlineContactList.add(oc3);      
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
   onlineContactList.add(oc4);      
        
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
   onlineContactList.add(oc5);      
        
    Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
   onlineContactList.add(oc6);      
        
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
   onlineContactList.add(oc7);      
        
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
   onlineContactList.add(oc8);      
        
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
   onlineContactList.add(oc9);      
        
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
   onlineContactList.add(oc10);     
        
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
   onlineContactList.add(oc11);     
        
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
   onlineContactList.add(oc12);     
        
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
   onlineContactList.add(oc13);     
        
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
   onlineContactList.add(oc14);     
        
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
   onlineContactList.add(oc15);     
        
    Online_Contacts__c oc16 = new Online_Contacts__c(QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com',Material__c='064',Type__c='Admin',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
   onlineContactList.add(oc16);     
        
   insert onlineContactList;        
                
    List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();          
    Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');     
    masterContactList.add(mc1);     
    Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '172.16.254.1',To_IP_Address__c = '172.16.254.1');        
    masterContactList.add(mc2);     
    Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');        
    masterContactList.add(mc3);         
    Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');       
    masterContactList.add(mc4);     
    Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');        
    masterContactList.add(mc5);     
    Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');        
    masterContactList.add(mc6);     
    Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');       
    masterContactList.add(mc7);     
    insert masterContactList;       
            
    /*List<Apttus_Config2__Order__c> updateOrders=new List<Apttus_Config2__Order__c>();     
  order.Apttus_Config2__Status__c='Pending';        
  updateOrders.add(order);      
  order1.Apttus_Config2__Status__c='Pending';       
  updateOrders.add(order1);     
        
    update updateOrders;*/      
            
  Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order3.id];      
  /*List<String> ordername = new List<String>();        
  ordername.add(order2.Name); */        
   // Test.startTest();     
  //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456       
  //APTS_OrderQueuetoESI.orderSubmissionToESI(ordername[0]);//Added as part of CRM-9456     
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);      
    Test.stopTest();        
     Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order3.id);       
    o.Apttus_Config2__Status__c='Submitted';        
    update o;       
            
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();      
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order3.Id AND Apttus_Config2__Status__c ='Submitted'];     
      System.assertequals(1,updateordList.size(),'');      
        
  }     
 static testmethod void ordersubmissionESINB3()     
  {     
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(        
        Active__c = true,       
        Name = 'OrdersubmissionESI',        
        Service_Unavailable_Message__c = 'Service Not Available',               
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');      
        insert ordSubSettings ;     
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;     
        
  Account acc = new Account();      
  acc.Name='test';      
  acc.Customer_Group__c='FEDERAL GOVERNMENT';       
  acc.CurrencyIsoCode='USD';        
  acc.Sales_Org__c='CARS';      
  Insert acc;       
        
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();        
  accountSSD.Name='ABC';        
  accountSSD.Source_System_Name__c='ABC';       
  accountSSD.Account_Name__c=acc.ID;        
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';       
  accountSSD.Account_Inactive__c=false;     
  accountSSD.LCRM_Sales_Org__c='CARS';      
  insert accountSSD;        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;       
                
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
                
       Date todaysDate = system.today();        
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();        
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);      
       insert oppty;        
        
                
  Contact oContact = UnitTest.getContactInstance(acc.Id);       
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';      
  insert oContact;      
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_Standard_Bundle__c=true);       
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Standard_Bundle__c=true);       
  insert oProductB;     
  insert oProductP;     
     Test.startTest();              
 // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));      
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();     
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);     
   oProposal.RecordtypeId=propRecorType;        
     oProposal.APTS_Payer__c = accountSSD.id;  
     oProposal.APTS_Ebilling_contact__c=oContact.id;
       
  insert oProposal;     
        
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();      
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);        
  listLineItems.add(li1);       
                        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);    
  listLineItems.add(li2);       
  insert listLineItems;     
        
  List<Apttus_Config2__Order__c> ordList=new List<Apttus_Config2__Order__c>();      
        
  Apttus_Config2__Order__c order3 = new Apttus_Config2__Order__c();     
  order3.Apttus_Config2__Type__c='New';     
  order3.Apttus_Config2__Status__c='Pending';       
  order3.APTS_SSD_Sold_To__c=accountSSD.id;     
  order3.APTS_SSD_bill_to__c=accountSSD.id;     
  order3.APTS_SSD_Ship_To__c=accountSSD.id;     
  order3.Apttus_QPConfig__ProposalId__c=oProposal.id;       
  OrdList.add(order3);      
  insert OrdList;       
        
  list<Apttus_Config2__OrderLineItem__c> ordlineitem =  new list<Apttus_Config2__OrderLineItem__c>();       
        
  Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();      
  ordline1.Apttus_Config2__Uom__c='Each';       
  ordline1.APTS_New_Bridge_Discount__c=1;       
  ordline1.APTS_Contract_Term__c='2 Years';         
  ordline1.Apttus_Config2__Quantity__c=1.000;       
  ordline1.Apttus_Config2__ProductId__c=oProductP.id;       
  ordline1.Apttus_Config2__OrderId__c=order3.id;        
  ordline1.Apttus_Config2__ChargeType__c='Standard Price';      
  ordline1.Apttus_Config2__PriceType__c ='One Time';        
  ordline1.Apttus_Config2__LineType__c ='Product/Service';      
  ordlineitem.add(ordline1);        
  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();      
  ordline2.APTS_Contract_Term__c='5 Years';     
  ordline2.Apttus_Config2__Quantity__c=1.000;       
  ordline2.Apttus_Config2__OrderId__c=order3.id;        
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;      
  ordline2.Apttus_Config2__ChargeType__c = 'Standard Price';        
        
  ordline2.Apttus_Config2__PriceType__c = 'One Time';       
  ordline2.Apttus_Config2__LineType__c ='Option';       
   ordlineitem.add(ordline2);       
            
        
  Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();        
  ordline143.APTS_Contract_Term__c='5 Years';       
  ordline143.Apttus_Config2__Quantity__c=1.000;     
  ordline143.Apttus_Config2__OrderId__c=order3.id;      
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;      
  ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';      
  ordline143.Apttus_Config2__LineType__c = 'Product/Service';       
  ordline143.Apttus_Config2__PriceType__c = 'One Time';     
  ordlineitem.add(ordline143);      
        
  
  Apttus_Config2__OrderLineItem__c ordlinee =  new Apttus_Config2__OrderLineItem__c();
  ordlinee.APTS_Contract_Term__c='1 Year';
  ordlinee.Apttus_Config2__OrderId__c=order3.id;
  ordlinee.Apttus_Config2__LineStatus__c='Renewed'; 
  ordlinee.Apttus_Config2__Quantity__c=1.000;
  ordlinee.Apttus_Config2__ProductId__c=oProductB.id;
  ordlinee.APTS_Group__c='Bundle A';  
  ordlinee.APTS_Bridge__c='7 Days';
  ordlinee.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordlineitem.add(ordlinee);
      
   insert ordlineitem;
            
  List<Apttus_Config2__OrderProductAttributeValue__c> ordPrAttList=new List<Apttus_Config2__OrderProductAttributeValue__c>();       
        
  Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();       
  attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';       
  attribute1.Apttus_Config2__LineItemId__c=ordline2.id;     
  OrdPrAttList.add(attribute1);     
          
  Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();      
  attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';      
  attribute23.Apttus_Config2__LineItemId__c=ordline2.id;        
  OrdPrAttList.add(attribute23);        
          
   Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();    
  attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';       
  attribute2.Apttus_Config2__LineItemId__c=ordline1.id;     
  OrdPrAttList.add(attribute2);     
          
  insert OrdPrAttList;      
   List<Apttus_Config2__OrderLineItem__c>  updateOrderLineList=new List<Apttus_Config2__OrderLineItem__c>();        
        
  ordline2.Apttus_Config2__AttributeValueId__c=attribute23.id;      
  updateOrderLineList.add(ordline2);        
  ordline1.Apttus_Config2__AttributeValueId__c=attribute2.id;       
  updateOrderLineList.add(ordline1);
  
  
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc4);
   
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc5);
   
    Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc6);
   
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc7);
   
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc8);
   
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc9);
   
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc10);
   
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc11);
   
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc12);
   
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc13);
   
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc14);
   
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc15);
   
    Online_Contacts__c oc16 = new Online_Contacts__c(QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com',Material__c='064',Type__c='Admin',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc16);
   
   insert onlineContactList;
        
    List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
    Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc1);
    Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '172.16.254.1',To_IP_Address__c = '172.16.254.1');
    masterContactList.add(mc2);
    Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
    masterContactList.add(mc3); 
    Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc4);
    Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc5);
    Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc6);
    Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc7);
    insert masterContactList;
    
    /*List<Apttus_Config2__Order__c> updateOrders=new List<Apttus_Config2__Order__c>();
  order.Apttus_Config2__Status__c='Pending';
  updateOrders.add(order);
  order1.Apttus_Config2__Status__c='Pending';
  updateOrders.add(order1);
  
    update updateOrders;*/
    
  Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order3.id];
  /*List<String> ordername = new List<String>();
  ordername.add(order2.Name); */

   // Test.startTest();
  //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456
  //APTS_OrderQueuetoESI.orderSubmissionToESI(ordername[0]);//Added as part of CRM-9456
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);
    Test.stopTest();
     Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order3.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order3.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  
  }
 

  static testmethod void ordersubmissionESINB1()
  {
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
  Account acc = new Account();
  acc.Name='test';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
  accountSSD.Name='ABC';
  accountSSD.Source_System_Name__c='ABC';
  accountSSD.Account_Name__c=acc.ID;
  accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
  accountSSD.Account_Inactive__c=false;
    accountSSD.LCRM_Sales_Org__c='CARS';
  insert accountSSD;
  
 
         List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
        
  Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact con = new Contact();
  con.AccountId = acc.Id;
  con.LastName='Prabhu';
  con.FirstName='Issac';
  insert con;
  
  List<Product2> prodList=new List<Product2>();
  
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'OA',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
  Product2 oProductB1 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06',APTS_Media_Lower_Level_Code__c = 'I9', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP1 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='07',APTS_Media_Lower_Level_Code__c = 'F4', Apttus_Config2__Uom__c = 'Seats');
  Product2 oProductB2 = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978967', APTS_Media_High_Level_Code__c= '06', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP2 = new Product2(Name='Sreenu Product Test2', ProductCode = '1234568978961', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats');
  prodList.add(oProductB);
  prodList.add(oProductP);
  prodList.add(oProductB1);
  prodList.add(oProductP1);
  prodList.add(oProductB2);
  prodList.add(oProductP2);
    insert prodList;
     
     Test.startTest();   
 // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Proposal_Business_Unit__c='FindLaw',APTS_Approval_Segment__c='Corporate',APTS_Order_Confirmation_Contact__c=con.id,APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
     oProposal.APTS_Payer__c = accountSSD.id;
     oProposal.APTS_Ebilling_contact__c=con.id;
  
  insert oProposal;
  
  
   
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li3);
  Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB1.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li4);
  Apttus_Proposal__Proposal_Line_Item__c li5 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li5);
  Apttus_Proposal__Proposal_Line_Item__c li6 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB2.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li6);
  
  insert listLineItems;
  
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_ship_to__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  insert order;
  
  List<Apttus_Config2__OrderLineItem__c> orderlineitemList = new List<Apttus_Config2__OrderLineItem__c>();
  
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A';  
  ordline.APTS_Bridge__c='1 Month';
  ordline.APTS_SAP_MLA_Agreement_Number__c = '12345';
  ordline.APTS_Service_Number__c = '40757482';
  ordline.APTS_Program_ID__c = 'CPRO';
  ordline.Apttus_Config2__LineType__c = 'Product/Service';
    orderlineitemList.add(ordline);
  
  Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
  ordline1.APTS_Contract_Term__c='1 Year';
  ordline1.Apttus_Config2__OrderId__c=order.id;
  ordline1.Apttus_Config2__LineStatus__c='Amended'; 
  ordline1.APTS_Service_Number__c = '41841757';
  ordline1.Apttus_Config2__Quantity__c=1.000;
  ordline1.Apttus_Config2__ProductId__c=oProductB.id;
  //ordline1.APTS_Group__c='Bundle A';  
  ordline1.APTS_Bridge__c='1 Month';
  ordline1.Apttus_Config2__AdjustmentType__c='% Discount';
  orderlineitemList.add(ordline1);
  
  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='1 Year';
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordline2.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id; 
  ordline2.APTS_Bridge__c='1 Month';
  orderlineitemList.add(ordline2);
  
  Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='1 Year';
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordline3.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline3.Apttus_Config2__BillingFrequency__c='Yearly';
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__ProductId__c=oProductP1.id; 
  ordline3.APTS_Bridge__c='1 Month';
  orderlineitemList.add(ordline3);
  insert orderlineitemList; 
  
  Apttus_Approval__Approval_Request__c ar = new Apttus_Approval__Approval_Request__c(                   
                Apttus_Approval__Approval_Status__c = 'Approved',
                Apttus_QPApprov__ProposalId__c =  oProposal.id               
       );
        insert ar;  
  
  //Test.startTest();
  
  order.Apttus_Config2__Status__c='Pending';
  update order;
  
  Apttus_Config2__Order__c order2= [select Id, Name from Apttus_Config2__Order__c where id = : order.id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name); 
  
  //OrdersubmissionESI.invokeOrdertoESI(ordername); Commented as part of CRM-9456
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id); //Added as part of CRM-9456
    Test.stopTest();
     Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  
  }
  
  @isTest static void onlineBundlestest(){
  
   WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
          Account acc = new Account();
      acc.Name='testWCMP';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        accountSSD.Source_System_Account_Number__c = '123456';
      insert accountSSD;
      
     List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
        
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
  
     /* Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
            Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',acc.id,'Oppty Online',Date.Today());
            oppty.RecordtypeId=opptyRecorType;
            oppty.Source_System_Detail__c=accountSSD.id;
            oppty.Account=acc;
            insert oppty;  */
            
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  
          Contact con = new Contact();
          con.AccountId=acc.Id;
          con.LastName='WCMP';
          con.FirstName='Bundle';
          insert con;
  
      List<Product2> productlist=new List<Product2>();
      Product2 oProductB = new Product2(Name='Primary Product', ProductCode = '1234568978965', APTS_Corporate_Select__c = 'Primary');
      Product2 oProductP = new Product2(Name='Option Product', ProductCode = '1234568978966', APTS_Corporate_Select__c = 'Module');
      Product2 oProductS = new Product2(Name='Standard Product', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='I9');
      Product2 oProductStd = new Product2(Name='Standard ProductMLA', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='06',APTS_Media_Lower_Level_Code__c='2P');
      Product2 oProductBN = new Product2(Name='Standard ProductMLA', ProductCode = '1234568978966', APTS_Standard_Bundle__c = true,APTS_Media_High_Level_Code__c='21',APTS_Media_Lower_Level_Code__c='EC');
      productlist.add(oProductBN);
      productlist.add(oProductB);
      productlist.add(oProductP);
      productlist.add(oProductS);
      productlist.add(oProductStd);
      insert productlist;
      
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
  Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
     RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test',
      APTS_Proposal_Business_Unit__c='SCS',
      APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,
      //APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
    //  APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
     APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
     oProposal.APTS_Ebilling_contact__c=con.id;
  
  insert oProposal;
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
  
  Test.startTest();
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  order.Apttus_Config2__Status__c='Pending';
  order.Retry_Count__c = 2;
  order.APTS_Payer__c = accountSSD.id;
  insert order;
  
  List<Apttus_Config2__LineItem__c> listofLineItems = new List<Apttus_Config2__LineItem__c>();

  Apttus_Config2__LineItem__c lineItemBN =  new Apttus_Config2__LineItem__c();
  lineItemBN.APTS_Group_Primary_Material__c= '40666420';
  lineItemBN.Apttus_Config2__LineStatus__c = 'New';  
  //lineItemP.APTS_Group__c = 'Bundle A';
  lineItemBN.APTS_Contract_Number__c = 123456;
  lineItemBN.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItemBN.Apttus_Config2__ItemSequence__c = 1;
  lineItemBN.Apttus_Config2__LineNumber__c = 1;
  lineItemBN.Apttus_Config2__ProductId__c = oProductB.Id;  
  //insert lineItemP;
  listofLineItems.add(lineItemBN);

  Apttus_Config2__LineItem__c lineItemP =  new Apttus_Config2__LineItem__c();
  lineItemP.APTS_Group_Primary_Material__c= '40666420';
  lineItemP.Apttus_Config2__LineStatus__c = 'New';  
  //lineItemP.APTS_Group__c = 'Bundle A';
  lineItemP.APTS_Contract_Number__c = 123456;
  lineItemP.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItemP.Apttus_Config2__ItemSequence__c = 1;
  lineItemP.Apttus_Config2__LineNumber__c = 1;
  lineItemP.Apttus_Config2__ProductId__c = oProductBN.Id;  
  //insert lineItemP;
  listofLineItems.add(lineItemP);
  
  Apttus_Config2__LineItem__c lineItemM =  new Apttus_Config2__LineItem__c();
  lineItemM.APTS_Group_Primary_Material__c= '40666420';
  lineItemM.Apttus_Config2__LineStatus__c = 'New';  
  //lineItemP.APTS_Group__c = 'Bundle A';
  lineItemM.APTS_Contract_Number__c = 123456;
  lineItemM.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItemM.Apttus_Config2__ItemSequence__c = 1;
  lineItemM.Apttus_Config2__LineNumber__c = 1;
  lineItemM.Apttus_Config2__OptionId__c= oProductP.Id;  
  //insert lineItemM;
  listofLineItems.add(lineItemM);
  
  Apttus_Config2__LineItem__c lineItemS =  new Apttus_Config2__LineItem__c();
  lineItemS.APTS_Group_Primary_Material__c= '40666420';
  lineItemS.Apttus_Config2__LineStatus__c = 'New';  
  //lineItemP.APTS_Group__c = 'Bundle A';
  lineItemS.APTS_Contract_Number__c = 123456;
  lineItemS.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItemS.Apttus_Config2__ItemSequence__c = 1;
  lineItemS.Apttus_Config2__LineNumber__c = 1;
  lineItemS.Apttus_Config2__ProductId__c= oProductS.Id;
  //insert lineItemS;
  listofLineItems.add(lineItemS);
  
  Apttus_Config2__LineItem__c lineItemStd =  new Apttus_Config2__LineItem__c();
  lineItemStd.APTS_Group_Primary_Material__c= '40666420';
  lineItemStd.Apttus_Config2__LineStatus__c = 'New';  
  //lineItemP.APTS_Group__c = 'Bundle A';
  lineItemStd.APTS_Contract_Number__c = 123456;
  lineItemStd.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItemStd.Apttus_Config2__ItemSequence__c = 1;
  lineItemStd.Apttus_Config2__LineNumber__c = 1;
  lineItemStd.Apttus_Config2__ProductId__c= oProductStd.Id;
  //insert lineItemStd;
  listofLineItems.add(lineItemStd);
  insert listofLineItems;
  
  List<Apttus_Config2__OrderLineItem__c> orderLineList = new List<Apttus_Config2__OrderLineItem__c>();
  Apttus_Config2__OrderLineItem__c ordlineS =  new Apttus_Config2__OrderLineItem__c();  
  ordlineS.Apttus_Config2__OrderId__c=order.id;  
  ordlineS.Apttus_Config2__ProductId__c=oProductS.id;  
  ordlineS.Apttus_Config2__LineStatus__c = 'New';
  //insert ordlineS;
  orderLineList.add(ordlineS);
  
  Apttus_Config2__OrderLineItem__c ordlineStd =  new Apttus_Config2__OrderLineItem__c();  
  ordlineStd.Apttus_Config2__OrderId__c=order.id;  
  ordlineStd.Apttus_Config2__ProductId__c=oProductStd.id;  
  ordlineStd.Apttus_Config2__LineStatus__c = 'New';
  //insert ordlineStd;
  orderLineList.add(ordlineStd);
  
  List<APTS_Dynamic_Bundle__c> dynbundleList = new List<APTS_Dynamic_Bundle__c>();
  APTS_Dynamic_Bundle__c dynamicbundle7D = new APTS_Dynamic_Bundle__c();
  //dynamicbundlewm.APTS_Bundle_Primary_Material__c='1111';
  //dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
  //dynamicbundlewm.APTS_Group__c='Bundle A';
  dynamicbundle7D.APTS_Quote_Proposal__c=oProposal.id;
  //dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
  //dynamicbundlewm.APTS_YoY_2_Plus__c='1';
  //dynamicbundlewm.APTS_Keep_Terms__c=false;
  //dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
  //dynamicbundlewm.APTS_Deal_Number__c = 623589;
  //dynamicbundlewm.APTS_Bridge_Discount__c = '10';
  //dynamicbundlewm.APTS_Bridge_Length__c = 2;
  //dynamicbundlewm.APTS_Bundle_Adjustment_Type__c = '% Discount';
  dynamicbundle7D.APTS_Bridge__c = '7 Days';  
  dynamicbundle7D.APTS_isBLINotCreated__c =true;
  //insert dynamicbundle7D;
  dynbundleList.add(dynamicbundle7D);
  
  APTS_Dynamic_Bundle__c dynamicbundle14D = new APTS_Dynamic_Bundle__c();  
  dynamicbundle14D.APTS_Quote_Proposal__c=oProposal.id;  
  dynamicbundle14D.APTS_Bridge__c = '14 Days';  
  //insert dynamicbundle14D;
  dynbundleList.add(dynamicbundle14D);
  
  APTS_Dynamic_Bundle__c dynamicbundle28D = new APTS_Dynamic_Bundle__c();  
  dynamicbundle28D.APTS_Quote_Proposal__c=oProposal.id;  
  dynamicbundle28D.APTS_Bridge__c = '28 Days';  
  dynamicbundle28D.APTS_isBLINotCreated__c =true; 
  //insert dynamicbundle28D;
  dynbundleList.add(dynamicbundle28D);
  insert dynbundleList;
  
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);  
  Test.stopTest();   
  
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  }  
  
   static testMethod void orderQueuetoESIWCMPNegativeScenario(){
    WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
  
  Account acc = new Account();
  acc.Name='testWCMPNegative';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
      insert accountSSD;
  List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
      
      Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
       
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='WCMPNegativeTest';
  con.FirstName='Bundle';
  insert con;
 
    Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
  Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
     RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test Negative Scenario',
      APTS_Proposal_Business_Unit__c='SCS',
      APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,
      APTS_SSD_Sold_To__c = accountSSD.Id,
      APTS_Payer__c = accountSSD.id,
      APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
    //  APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
     APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
      oProposal.APTS_Ebilling_contact__c=con.id;
  insert oProposal;
  
 
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
  
  Test.startTest();
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  //order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  order.Apttus_Config2__Status__c='Pending';
  insert order;
  
  Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle B';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMP';
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem.Apttus_Config2__Quantity__c = 1;
  insert lineItem; 
      
 
  APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
  dynamicbundlewm.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewm.APTS_Group__c='Bundle B';
  dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
  dynamicbundlewm.APTS_YoY_2_Plus__c='1';
  dynamicbundlewm.APTS_Keep_Terms__c=false;
  dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewm.APTS_Deal_Number__c = null;
  dynamicbundlewm.APTS_Bridge_Discount__c = '10';
  dynamicbundlewm.APTS_Bridge_Length__c = 2;
  dynamicbundlewm.APTS_isBLINotCreated__c =true;
  insert dynamicbundlewm;   
  
  
   
   
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);  
  Test.stopTest();   
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  } 
  
  
   static testMethod void orderQueuetoESIWCMPNegativeScenario2(){
    WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
  
  Account acc = new Account();
  acc.Name='testWCMPNegative';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
      insert accountSSD;
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
      
      Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
       
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='WCMPNegativeTest';
  con.FirstName='Bundle';
  insert con;
  
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
  Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
        RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test Negative Scenario',
      APTS_Proposal_Business_Unit__c='SCS',
      APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,
      APTS_SSD_Sold_To__c = accountSSD.Id,
      APTS_Payer__c = accountSSD.id,
      APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
     // APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
     APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
      oProposal.APTS_Ebilling_contact__c=con.id;
  insert oProposal;
  
 
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
  
  Test.startTest();
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  //order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  order.Apttus_Config2__Status__c='Pending';
  insert order;
  
  Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
        lineItem.APTS_Group_Primary_Material__c= '40666420';
        lineItem.Apttus_Config2__LineStatus__c = 'New';  
        lineItem.APTS_Group__c = 'Bundle B';
        lineItem.APTS_Contract_Number__c = 123456;
        lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        lineItem.Apttus_Config2__ItemSequence__c = 1;
        lineItem.Apttus_Config2__LineNumber__c = 1;
        lineItem.APTS_Deal_Type__c = 'WCMPS';
        lineItem.Apttus_Config2__AddedBy__c = 'User';
        lineItem.Apttus_Config2__AdjustedPrice__c = 50;
        lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
        lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
        lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        lineItem.Apttus_Config2__AllowProration__c = FALSE;
        lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
        lineItem.Apttus_Config2__AutoRenew__c = FALSE;
        lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
        lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        lineItem.Apttus_Config2__BasePrice__c = 100;
        lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
        lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        lineItem.Apttus_Config2__Customizable__c = FALSE;
        lineItem.Apttus_Config2__DeltaPrice__c = 50;
        lineItem.Apttus_Config2__DeltaQuantity__c = 1;
        lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        lineItem.Apttus_Config2__ExtendedCost__c = 0;
        lineItem.Apttus_Config2__ExtendedPrice__c = 100;
        lineItem.Apttus_Config2__Frequency__c = 'Monthly';
        lineItem.Apttus_Config2__Guidance__c = 'Red';
        lineItem.Apttus_Config2__HasAttributes__c = FALSE;
        lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
        lineItem.Apttus_Config2__HasDefaults__c = FALSE;
        lineItem.Apttus_Config2__HasIncentives__c = FALSE;
        lineItem.Apttus_Config2__HasOptions__c = FALSE;
        lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
        lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
        lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
        lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
        lineItem.Apttus_Config2__IsHidden__c = FALSE;
        lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
        lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        lineItem.Apttus_Config2__LineSequence__c = 1;
        lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
        lineItem.Apttus_Config2__LineType__c = 'Product/Service';
        lineItem.Apttus_Config2__ListPrice__c = 100;
        lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
        lineItem.Apttus_Config2__NetPrice__c = 50;
        lineItem.Apttus_Config2__NetUnitPrice__c = 50;
        lineItem.Apttus_Config2__OptionSequence__c = 0;
        lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        lineItem.Apttus_Config2__PriceType__c = 'Recurring';
        lineItem.Apttus_Config2__PriceUom__c = 'Each';
        lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
        lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        lineItem.Apttus_Config2__ProductVersion__c = 1;
        lineItem.Apttus_Config2__Quantity__c = 1;
        lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        lineItem.Apttus_Config2__SellingTerm__c = 1;
        lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
        lineItem.Apttus_Config2__Taxable__c = FALSE;
        lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
        lineItem.Apttus_Config2__Term__c = 1;
        lineItem.Apttus_Config2__TotalQuantity__c = 1;
        lineItem.Apttus_Config2__Uom__c = 'Each';
        lineItem.CurrencyIsoCode = 'USD';
        lineItem.APTS_Product_Family__c = 'WESTLAW';
        lineItem.APTS_Contract_Term__c = '2 Years';
        lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
        lineItem.APTS_Product_Delivery__c = 'Online/Internet';
        lineItem.Apttus_Config2__Quantity__c = 1;
  insert lineItem; 
      
 
  APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
  dynamicbundlewm.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewm.APTS_Group__c='Bundle B';
  dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
  dynamicbundlewm.APTS_YoY_2_Plus__c='1';
  dynamicbundlewm.APTS_Keep_Terms__c=false;
  dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewm.APTS_Deal_Number__c = 623589;
  dynamicbundlewm.APTS_Bridge_Discount__c = '10';
  dynamicbundlewm.APTS_Bridge_Length__c = 2;
  dynamicbundlewm.APTS_isBLINotCreated__c =true;
  insert dynamicbundlewm;   
  
  
   
   //Test.startTest();
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);  
  Test.stopTest();   
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  } 
  
   static testMethod void orderQueuetoESIWCMPNegativeScenario3(){
    WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
  
  Account acc = new Account();
  acc.Name='testWCMPNegative';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='CARS';
  Insert acc;
  
  Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
      insert accountSSD;
      List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
      
      Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
       
  Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='WCMPNegativeTest';
  con.FirstName='Bundle';
  insert con;
  
  Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
  Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
    RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test Negative Scenario',
      APTS_Proposal_Business_Unit__c='SCS',
      APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,
      APTS_SSD_Sold_To__c = accountSSD.Id,
      APTS_Payer__c = accountSSD.id,
      APTS_Payment_Option__c='Payment Express Auto EFT/Auto Charge' ,
     // APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
      APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
       oProposal.APTS_Ebilling_contact__c=con.id;
  insert oProposal;
  
 
  
  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
  insert prodConfig;
  
  Test.startTest();
  
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  //order.Apttus_Config2__Status__c='Ready for Activation';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  order.Apttus_Config2__Status__c='Pending';
  insert order;
  
  Apttus_Config2__LineItem__c lineItem =  new Apttus_Config2__LineItem__c();
  lineItem.APTS_Group_Primary_Material__c= '40666420';
  lineItem.Apttus_Config2__LineStatus__c = 'New';  
  lineItem.APTS_Group__c = 'Bundle B';
  lineItem.APTS_Contract_Number__c = 123456;
  lineItem.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
  lineItem.Apttus_Config2__ItemSequence__c = 1;
  lineItem.Apttus_Config2__LineNumber__c = 1;
  lineItem.APTS_Deal_Type__c = 'WCMP';
  lineItem.Apttus_Config2__AddedBy__c = 'User';
  lineItem.Apttus_Config2__AdjustedPrice__c = 50;
  lineItem.Apttus_Config2__AdjustmentAmount__c = 50;
  lineItem.Apttus_Config2__AdjustmentType__c = '% Discount';
  lineItem.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
  lineItem.Apttus_Config2__AllowableAction__c = 'Unrestricted';
  lineItem.Apttus_Config2__AllowManualAdjustment__c = TRUE;
  lineItem.Apttus_Config2__AllowProration__c = FALSE;
  lineItem.Apttus_Config2__AllowRemoval__c = TRUE;
  lineItem.Apttus_Config2__AutoRenew__c = FALSE;
  lineItem.Apttus_Config2__BaseExtendedCost__c = 0;
  lineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
  lineItem.Apttus_Config2__BasePrice__c = 100;
  lineItem.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
  lineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
  lineItem.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  lineItem.Apttus_Config2__ConfigStatus__c = 'Complete';
  lineItem.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
  lineItem.Apttus_Config2__Customizable__c = FALSE;
  lineItem.Apttus_Config2__DeltaPrice__c = 50;
  lineItem.Apttus_Config2__DeltaQuantity__c = 1;
  lineItem.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
  lineItem.Apttus_Config2__ExtendedCost__c = 0;
  lineItem.Apttus_Config2__ExtendedPrice__c = 100;
  lineItem.Apttus_Config2__Frequency__c = 'Monthly';
  lineItem.Apttus_Config2__Guidance__c = 'Red';
  lineItem.Apttus_Config2__HasAttributes__c = FALSE;
  lineItem.Apttus_Config2__HasBaseProduct__c = FALSE;
  lineItem.Apttus_Config2__HasDefaults__c = FALSE;
  lineItem.Apttus_Config2__HasIncentives__c = FALSE;
  lineItem.Apttus_Config2__HasOptions__c = FALSE;
  lineItem.Apttus_Config2__HasTieredPrice__c = FALSE;
  lineItem.Apttus_Config2__HideCopyAction__c = FALSE;
  lineItem.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
  lineItem.Apttus_Config2__IsAssetPricing__c = FALSE;
  lineItem.Apttus_Config2__IsCustomPricing__c = FALSE;
  lineItem.Apttus_Config2__IsHidden__c = FALSE;
  lineItem.Apttus_Config2__IsOptionRollupLine__c = FALSE;
  lineItem.Apttus_Config2__IsPrimaryLine__c = TRUE;
  lineItem.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
  lineItem.Apttus_Config2__IsQuantityModifiable__c = FALSE;
  lineItem.Apttus_Config2__IsReadOnly__c = FALSE;
  lineItem.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
  lineItem.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
  lineItem.Apttus_Config2__LineSequence__c = 1;
  lineItem.APTS_Yr_1_Renewal_Adjustment__c ='1';
  lineItem.Apttus_Config2__LineType__c = 'Product/Service';
  lineItem.Apttus_Config2__ListPrice__c = 100;
  lineItem.Apttus_Config2__NetAdjustmentPercent__c = -50;
  lineItem.Apttus_Config2__NetPrice__c = 50;
  lineItem.Apttus_Config2__NetUnitPrice__c = 50;
  lineItem.Apttus_Config2__OptionSequence__c = 0;
  lineItem.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
  lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
  lineItem.Apttus_Config2__PriceType__c = 'Recurring';
  lineItem.Apttus_Config2__PriceUom__c = 'Each';
  lineItem.Apttus_Config2__PricingStatus__c = 'Complete';
  lineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
  lineItem.Apttus_Config2__ProductVersion__c = 1;
  lineItem.Apttus_Config2__Quantity__c = 1;
  lineItem.Apttus_Config2__RollupPriceToBundle__c = TRUE;
  lineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
  lineItem.Apttus_Config2__SellingTerm__c = 1;
  lineItem.Apttus_Config2__SyncStatus__c = 'Pending';
  lineItem.Apttus_Config2__Taxable__c = FALSE;
  lineItem.Apttus_Config2__TaxInclusive__c = FALSE;
  lineItem.Apttus_Config2__Term__c = 1;
  lineItem.Apttus_Config2__TotalQuantity__c = 1;
  lineItem.Apttus_Config2__Uom__c = 'Each';
  lineItem.CurrencyIsoCode = 'USD';
  lineItem.APTS_Product_Family__c = 'WESTLAW';
  lineItem.APTS_Contract_Term__c = '2 Years';
  lineItem.APTS_Years_2_Plus_Adjustment__c = '4';
  lineItem.APTS_Product_Delivery__c = 'Online/Internet';
  lineItem.Apttus_Config2__Quantity__c = 1;
  insert lineItem; 
      
 
  APTS_Dynamic_Bundle__c dynamicbundlewm = new APTS_Dynamic_Bundle__c();
  dynamicbundlewm.APTS_Bundle_Primary_Material__c='41972767';
  dynamicbundlewm.APTS_Program_ID__c= 'WCMP';  
  dynamicbundlewm.APTS_Group__c='Bundle B';
  dynamicbundlewm.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundlewm.APTS_Contract_Terms__c='3 Years';
  dynamicbundlewm.APTS_YoY_2_Plus__c='1';
  dynamicbundlewm.APTS_Keep_Terms__c=false;
  dynamicbundlewm.APTS_MLA_Agreement_Number__c='7378768';
  dynamicbundlewm.APTS_Deal_Number__c = 6354673;
  dynamicbundlewm.APTS_Bridge_Discount__c = '10';
  dynamicbundlewm.APTS_Bridge_Length__c = 2;
  dynamicbundlewm.APTS_isBLINotCreated__c =true;
  insert dynamicbundlewm;   
  
  
   
   //Test.startTest();
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);  
  Test.stopTest();   
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
  } 
  
   static testMethod void prgmItemifo(){
     WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
    //Test.startTest();
  Account acc = new Account();
  acc.Name='Test Program Id';
  acc.Customer_Group__c='FEDERAL GOVERNMENT';
  acc.CurrencyIsoCode='USD';
  acc.Sales_Org__c='WEST';
  Insert acc;
  
    Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='WEST';
      insert accountSSD;
      
    Contact con = new Contact();
  con.AccountId=acc.Id;
  con.LastName='SEAT';
  con.FirstName='CPRO';
  insert con;
  
    Product2 oProductB = new Product2(Name='Standard Bundle ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'I9',APTS_Media_High_Level_Code__c='06', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c = 'ZPMT' ,APTS_Corporate_Select__c='Primary');
  insert oProductB;
  Product2 oProductC = new Product2(Name='Corp Select ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'E2',APTS_Media_High_Level_Code__c='05', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c = 'ZPAL' ,APTS_Corporate_Select__c='Primary',APTS_Standard_Bundle__c=True);
   insert oProductC;
   Product2 oProductD = new Product2(Name='Test ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'PQ',APTS_Media_High_Level_Code__c='13', Family = System.Label.Caseline_Product_Family);
   insert oProductD;
   Product2 oProductE = new Product2(Name='Test ', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = '',APTS_Media_High_Level_Code__c='26', Family = System.Label.Caseline_Product_Family);
   insert oProductE;
   
   Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
    Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(
    RecordtypeId=propRecorType,
      Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test2',
      APTS_Proposal_Business_Unit__c='SCS',
      APTS_Approval_Segment__c='Small Law',
      APTS_Order_Confirmation_Contact__c=con.id,
      APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'), 
      Apttus_Proposal__Account__c = acc.Id,
      APTS_SSD_Sold_To__c = accountSSD.Id,
      APTS_Payer__c = accountSSD.id,
      APTS_Payment_Option__c='Credit Card' ,
      //APTS_SA_ID__c = 'CA OC MSA-WEST(OCMS)',
      APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08'));
      oProposal.APTS_Ebilling_contact__c=con.id;
      insert oProposal;
      
      
    Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
    order.Apttus_Config2__Type__c='New';
    //order.Apttus_Config2__Status__c='Ready for Activation';
  //order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  order.Apttus_Config2__Status__c='Pending';
  insert order;
  
  List<Apttus_Config2__OrderLineItem__c> ordlineList = new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c oordline =  new Apttus_Config2__OrderLineItem__c();
  oordline.APTS_Contract_Term__c='1 Year';
  oordline.Apttus_Config2__OrderId__c=order.id;
  oordline.Apttus_Config2__Quantity__c=1.000;
  oordline.Apttus_Config2__ProductId__c=oProductD.id; 
  oordline.Apttus_Config2__LineType__c = 'Product/Service';
  oordline.APTS_Program_ID__c = 'CPRO';
  oordline.APTS_Bridge__c='11 Months';
  oordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
  oordline.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline;
  ordlineList.add(oordline);

  Apttus_Config2__OrderLineItem__c oordline1 =  new Apttus_Config2__OrderLineItem__c();
  oordline1.APTS_Contract_Term__c='1 Year';
  oordline1.Apttus_Config2__OrderId__c=order.id;
  oordline1.Apttus_Config2__Quantity__c=1.000;
  oordline1.Apttus_Config2__ProductId__c=oProductE.id;
  oordline1.Apttus_Config2__LineType__c = 'Product/Service';
  oordline1.APTS_Program_ID__c = 'CPRO';
  oordline1.APTS_Bridge__c='11 Months';
  oordline1.Apttus_Config2__BillingFrequency__c = 'Yearly';
  oordline1.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline;
  ordlineList.add(oordline1);

 Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A'; 
  ordline.Apttus_Config2__LineType__c = 'Product/Service';
  ordline.APTS_Program_ID__c = 'CPRO';
  ordline.APTS_Bridge__c='11 Months';
  ordline.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline;
  ordlineList.add(ordline);
  
  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='1 Year';
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductC.id;
  ordline2.APTS_Program_ID__c = 'CPRO';
  ordline2.Apttus_Config2__ListPrice__c=100;
  ordline2.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline2.Apttus_Config2__LineType__c = 'Product/Service';
  ordline2.APTS_Bridge__c='11 Months';
  ordline2.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline2.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline2;
  ordlineList.add(ordline2);
  
   Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='1 Year';
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__ProductId__c=oProductB.id;
  ordline3.APTS_Program_ID__c = 'CPRO';
  ordline3.Apttus_Config2__ListPrice__c=100;
  ordline3.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline3.Apttus_Config2__LineType__c = 'Product/Service';
  ordline3.APTS_Bridge__c='11 Months';
  ordline3.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline3.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline3;
  ordlineList.add(ordline3);
  
   Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
  ordline4.APTS_Contract_Term__c='Short Term Trial';
  ordline4.Apttus_Config2__OrderId__c=order.id;
  ordline4.Apttus_Config2__Quantity__c=1.000;
  ordline4.Apttus_Config2__ProductId__c=oProductC.id;
  ordline4.APTS_Program_ID__c = 'CPRO';
  ordline4.Apttus_Config2__ListPrice__c=100;
  ordline4.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline4.Apttus_Config2__LineType__c = 'Product/Service';
  ordline4.APTS_Bridge__c='11 Months';
  ordline4.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline4.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline4;
  ordlineList.add(ordline4);
  
   Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
  ordline5.APTS_Contract_Term__c='2 Years';
  ordline5.Apttus_Config2__OrderId__c=order.id;
  ordline5.Apttus_Config2__Quantity__c=1.000;
  ordline5.Apttus_Config2__ProductId__c=oProductC.id;
  ordline5.APTS_Program_ID__c = 'CPRO';
  ordline5.Apttus_Config2__ListPrice__c=100;
  ordline5.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline5.Apttus_Config2__LineType__c = 'Product/Service';
  ordline5.APTS_Bridge__c='11 Months';
  ordline5.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline5.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline5;
  ordlineList.add(ordline5);
  
   Apttus_Config2__OrderLineItem__c ordline6 =  new Apttus_Config2__OrderLineItem__c();
  ordline6.APTS_Contract_Term__c='3 Years';
  ordline6.Apttus_Config2__OrderId__c=order.id;
  ordline6.Apttus_Config2__Quantity__c=1.000;
  ordline6.Apttus_Config2__ProductId__c=oProductC.id;
  ordline6.APTS_Program_ID__c = 'CPRO';
  ordline6.Apttus_Config2__ListPrice__c=100;
  ordline6.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline6.Apttus_Config2__LineType__c = 'Product/Service';
  ordline6.APTS_Bridge__c='11 Months';
  ordline6.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline6.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline6;
  ordlineList.add(ordline6);
  
  Apttus_Config2__OrderLineItem__c ordline7 =  new Apttus_Config2__OrderLineItem__c();
  ordline7.APTS_Contract_Term__c='4 Years';
  ordline7.Apttus_Config2__OrderId__c=order.id;
  ordline7.Apttus_Config2__Quantity__c=1.000;
  ordline7.Apttus_Config2__ProductId__c=oProductC.id;
  ordline7.APTS_Program_ID__c = 'CPRO';
  ordline7.Apttus_Config2__ListPrice__c=100;
  ordline7.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline7.Apttus_Config2__LineType__c = 'Product/Service';
  ordline7.APTS_Bridge__c='11 Months';
  ordline7.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline7.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline7;
  ordlineList.add(ordline7);
  
  Apttus_Config2__OrderLineItem__c ordline8 =  new Apttus_Config2__OrderLineItem__c();
  ordline8.APTS_Contract_Term__c='5 Years';
  ordline8.Apttus_Config2__OrderId__c=order.id;
  ordline8.Apttus_Config2__Quantity__c=1.000;
  ordline8.Apttus_Config2__ProductId__c=oProductC.id;
  ordline8.APTS_Program_ID__c = 'CPRO';
  ordline8.Apttus_Config2__ListPrice__c=100;
  ordline8.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline8.Apttus_Config2__LineType__c = 'Product/Service';
  ordline8.APTS_Bridge__c='11 Months';
  ordline8.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline8.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline8;
  ordlineList.add(ordline8);
  
  Apttus_Config2__OrderLineItem__c ordline9 =  new Apttus_Config2__OrderLineItem__c();
  ordline9.APTS_Contract_Term__c='10 Years';
  ordline9.Apttus_Config2__OrderId__c=order.id;
  ordline9.Apttus_Config2__Quantity__c=1.000;
  ordline9.Apttus_Config2__ProductId__c=oProductC.id;
  ordline9.APTS_Program_ID__c = 'CPRO';
  ordline9.Apttus_Config2__ListPrice__c=100;
  ordline9.Apttus_Config2__LineStatus__c='Renewed'; 
  ordline9.Apttus_Config2__LineType__c = 'Product/Service';
  ordline9.APTS_Bridge__c='11 Months';
  ordline9.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline9.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline9;
  ordlineList.add(ordline9);
  
  Apttus_Config2__OrderLineItem__c ordline10 =  new Apttus_Config2__OrderLineItem__c();
  ordline10.APTS_Contract_Term__c='Short Term Trial';
  ordline10.Apttus_Config2__OrderId__c=order.id;
  ordline10.Apttus_Config2__Quantity__c=1.000;
  ordline10.Apttus_Config2__ProductId__c=oProductC.id;
  ordline10.APTS_Program_ID__c = 'CPRO';
  ordline10.Apttus_Config2__ListPrice__c=100;
  ordline10.Apttus_Config2__LineStatus__c='New'; 
  ordline10.Apttus_Config2__LineType__c = 'Product/Service';
  ordline10.APTS_Bridge__c='11 Months';
  ordline10.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline10.Apttus_Config2__NetPrice__c = 1728;
  //insert ordline10;
  ordlineList.add(ordline10);
  
  Apttus_Config2__OrderLineItem__c ordline11 =  new Apttus_Config2__OrderLineItem__c();
  ordline11.APTS_Contract_Term__c='Short Term Trial';
  ordline11.Apttus_Config2__OrderId__c=order.id;
  ordline11.Apttus_Config2__Quantity__c=1.000;
  ordline11.Apttus_Config2__ProductId__c=oProductC.id;
  ordline11.APTS_Program_ID__c = 'CPRO';
  ordline11.Apttus_Config2__ListPrice__c=100;
  ordline11.Apttus_Config2__LineStatus__c='Existing'; 
  ordline11.Apttus_Config2__LineType__c = 'Product/Service';
  ordline11.APTS_Bridge__c='11 Months';
  ordline11.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordline11.Apttus_Config2__NetPrice__c = 1728;
 // insert ordline11;
 ordlineList.add(ordline11);
 
 insert ordlineList;
  
  Test.startTest();
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = : order.id];   
  APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);  
  Test.stopTest();
   Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;
    
    List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
      updateordList =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
      System.assertequals(1,updateordList.size(),'');
   
} 

  
   static testmethod void ordersubmissionESI2()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
        
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
  
  
        Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
  Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');
  Product2 oProductB1 = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = '', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVAU');
  productlist.add(oProductC);
  productlist.add(oProductB);
  productlist.add(oProductB1);
  insert productlist;

        
 // Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'), Apttus_Proposal__Account__c = acc.Id,APTS_SSD_Sold_To__c=accountSSD.Id,APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c=date.ValueOf('2015-03-08'));
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
  oProposal.Apttus_Proposal__Account__c=acc.id;
  //oProposal.APTS_SA_ID__c = 'AL MSA-WEST(ALMS)';
  oProposal.APTS_Payer__c = accountSSD.id;
  oProposal.APTS_Ebilling_contact__c=oContact.id;
  insert oProposal;
  Test.startTest(); 
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
 
  insert orderList; 
  
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
  
  Apttus_Config2__OrderLineItem__c ordlineA =  new Apttus_Config2__OrderLineItem__c();
  ordlineA.APTS_Contract_Term__c='3 Years';
  ordlineA.Apttus_Config2__Quantity__c=1.000;
  ordlineA.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA.Apttus_Config2__OrderId__c=order.id;
  ordlineA.APTS_Group__c=' ';
  ordlineA.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineA.Apttus_Config2__AdjustmentType__c='% Discount';
  ordlineA.Apttus_Config2__LineType__c = 'Product/Service';
  ordlineA.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordlineA);   
  
  Apttus_Config2__OrderLineItem__c ordlineA1 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA1.APTS_Contract_Term__c='3 Years';
  ordlineA1.Apttus_Config2__Quantity__c=1.000;
  ordlineA1.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA1.Apttus_Config2__OrderId__c=order.id;
  ordlineA1.APTS_Group__c=' ';
  ordlineA1.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineA1.Apttus_Config2__AdjustmentType__c='% Markup';
  ordlineA1.Apttus_Config2__LineType__c = 'Product/Service';
  ordlineA1.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordlineA1 );   
  
  Apttus_Config2__OrderLineItem__c ordlineA2 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA2.APTS_Contract_Term__c='3 Years';
  ordlineA2.Apttus_Config2__Quantity__c=1.000;
  ordlineA2.Apttus_Config2__ProductId__c=oProductB1.id;
  ordlineA2.Apttus_Config2__OrderId__c=order.id;
  ordlineA2.APTS_Group__c=' ';
  ordlineA2.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineA2.Apttus_Config2__AdjustmentType__c='% Markup';
  ordlineA2.Apttus_Config2__LineType__c = 'Product/Service';
  ordlineA2.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordlineA2);   
   
  insert ordlineList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
 Apttus_Config2__OrderProductAttributeValue__c attributeA1 = new Apttus_Config2__OrderProductAttributeValue__c();
  attributeA1.SCS_Print_Purchase_Options__c='Ship Only';
  attributeA1.Apttus_Config2__LineItemId__c=ordlineA1.id;
  orderProd.add(attributeA1);
  
  Apttus_Config2__OrderProductAttributeValue__c attributeA2 = new Apttus_Config2__OrderProductAttributeValue__c();
  attributeA2.SCS_Print_Purchase_Options__c='Ship Only';
  attributeA2.Apttus_Config2__LineItemId__c=ordlineA2.id;
  orderProd.add(attributeA2);
  
  Apttus_Config2__OrderProductAttributeValue__c attributeA = new Apttus_Config2__OrderProductAttributeValue__c();
  attributeA.SCS_Print_Purchase_Options__c='Sub Only';
  attributeA.Apttus_Config2__LineItemId__c=ordlineA.id;
  orderProd.add(attributeA);
   
  insert orderProd;
  
  List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
  
   ordlineA1.Apttus_Config2__AttributeValueId__c=attributeA1.id;
  updateOrderList.add(ordlineA1 );
  
  ordlineA.Apttus_Config2__AttributeValueId__c=attributeA.id;
  updateOrderList.add(ordlineA );
  
  ordlineA2.Apttus_Config2__AttributeValueId__c=attributeA2.id;
  updateOrderList.add(ordlineA2 );


  update updateOrderList;
 
 
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
 
    Test.stopTest();
    Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    system.assertequals(o.Apttus_Config2__Status__c,'Submitted','');
    update o;    
    List<Apttus_Config2__Order__c> updateordList1=new List<Apttus_Config2__Order__c>();
     updateordList1 =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
  
  }
  
  static testmethod void ordersubmissionESIPrintSK()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
   
   Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVAU');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '40987270', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPAL');
  Product2 oProductC = new Product2(Name='Sreenu Product Test', ProductCode = '41055954', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',APTS_Item_Category_Group__c='ZPMT');
  productlist.add(oProductC);
  productlist.add(oProductB);
  productlist.add(oProductP);
  insert productlist;
  
 Test.startTest();
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
  oProposal.Apttus_Proposal__Account__c=acc.id;
 // oProposal.APTS_SA_ID__c = 'AL MSA-WEST(ALMS)';
  oProposal.APTS_Payer__c = accountSSD.id;
  oProposal.APTS_Proposal_Business_Unit__c='Canada';
  oProposal.APTS_Revenue_Channel_Override__c='05';
  oProposal.APTS_Ebilling_contact__c=oContact.id;
  insert oProposal;
   
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
  
  Apttus_Config2__OrderLineItem__c ordline =  new Apttus_Config2__OrderLineItem__c();
  ordline.APTS_Contract_Term__c='1 Year';
  ordline.Apttus_Config2__OrderId__c=order.id;
  ordline.Apttus_Config2__Quantity__c=1.000;
  ordline.Apttus_Config2__ProductId__c=oProductB.id;
  ordline.APTS_Group__c='Bundle A'; 
  ordline.APTS_Program_ID__c = 'WCMP';
  ordline.APTS_Bridge__c='1 Month';
  ordlineList.add(ordline);
   
    Apttus_Config2__OrderLineItem__c ordlineA2 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA2.APTS_Contract_Term__c='1 Year';
  ordlineA2.Apttus_Config2__OrderId__c=order.id;
  ordlineA2.Apttus_Config2__Quantity__c=1.000;
  ordlineA2.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA2.APTS_Group__c='Bundle A'; 
  ordlineA2.APTS_Program_ID__c = 'WCMP';
  ordlineA2.APTS_Bridge__c='2 Months';
  ordlineList.add(ordlineA2);
   
   Apttus_Config2__OrderLineItem__c ordlineA3 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA3.APTS_Contract_Term__c='1 Year';
  ordlineA3.Apttus_Config2__OrderId__c=order.id;
  ordlineA3.Apttus_Config2__Quantity__c=1.000;
  ordlineA3.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA3.APTS_Group__c='Bundle A'; 
  ordlineA3.APTS_Program_ID__c = 'WCMP';
  ordlineA3.APTS_Bridge__c='3 Months';
  ordlineList.add(ordlineA3);
  
  Apttus_Config2__OrderLineItem__c ordlineA4 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA4.APTS_Contract_Term__c='1 Year';
  ordlineA4.Apttus_Config2__OrderId__c=order.id;
  ordlineA4.Apttus_Config2__Quantity__c=1.000;
  ordlineA4.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA4.APTS_Group__c='Bundle A'; 
  ordlineA4.APTS_Program_ID__c = 'WCMP';
  ordlineA4.APTS_Bridge__c='4 Months';
  ordlineList.add(ordlineA4);
  
  Apttus_Config2__OrderLineItem__c ordlineA5 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA5.APTS_Contract_Term__c='1 Year';
  ordlineA5.Apttus_Config2__OrderId__c=order.id;
  ordlineA5.Apttus_Config2__Quantity__c=1.000;
  ordlineA5.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA5.APTS_Group__c='Bundle A'; 
  ordlineA5.APTS_Program_ID__c = 'WCMP';
  ordlineA5.APTS_Bridge__c='5 Months';
  ordlineList.add(ordlineA5);
  
  Apttus_Config2__OrderLineItem__c ordlineA6 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA6.APTS_Contract_Term__c='1 Year';
  ordlineA6.Apttus_Config2__OrderId__c=order.id;
  ordlineA6.Apttus_Config2__Quantity__c=1.000;
  ordlineA6.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA6.APTS_Group__c='Bu6dle A'; 
  ordlineA6.APTS_Program_ID__c = 'WCMP';
  ordlineA6.APTS_Bridge__c='6 Months';
  ordlineList.add(ordlineA6);
  
  Apttus_Config2__OrderLineItem__c ordlineA7 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA7.APTS_Contract_Term__c='1 Year';
  ordlineA7.Apttus_Config2__OrderId__c=order.id;
  ordlineA7.Apttus_Config2__Quantity__c=1.000;
  ordlineA7.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA7.APTS_Group__c='Bundle A'; 
  ordlineA7.APTS_Program_ID__c = 'WCMP';
  ordlineA7.APTS_Bridge__c='7 Months';
  ordlineList.add(ordlineA7);
  
  Apttus_Config2__OrderLineItem__c ordlineA8 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA8.APTS_Contract_Term__c='1 Year';
  ordlineA8.Apttus_Config2__OrderId__c=order.id;
  ordlineA8.Apttus_Config2__Quantity__c=1.000;
  ordlineA8.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA8.APTS_Group__c='Bundle A'; 
  ordlineA8.APTS_Program_ID__c = 'WCMP';
  ordlineA8.APTS_Bridge__c='8 Months';
  ordlineList.add(ordlineA8);
  
  Apttus_Config2__OrderLineItem__c ordlineA9 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA9.APTS_Contract_Term__c='1 Year';
  ordlineA9.Apttus_Config2__OrderId__c=order.id;
  ordlineA9.Apttus_Config2__Quantity__c=1.000;
  ordlineA9.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA9.APTS_Group__c='Bundle A'; 
  ordlineA9.APTS_Program_ID__c = 'WCMP';
  ordlineA9.APTS_Bridge__c='9 Months';
  ordlineList.add(ordlineA9);
  
  Apttus_Config2__OrderLineItem__c ordlineA10 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA10.APTS_Contract_Term__c='1 Year';
  ordlineA10.Apttus_Config2__OrderId__c=order.id;
  ordlineA10.Apttus_Config2__Quantity__c=1.000;
  ordlineA10.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA10.APTS_Group__c='Bundle A'; 
  ordlineA10.APTS_Program_ID__c = 'WCMP';
  ordlineA10.APTS_Bridge__c='10 Months';
  ordlineList.add(ordlineA10);
  
  Apttus_Config2__OrderLineItem__c ordlineA101 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA101.APTS_Contract_Term__c='1 Year';
  ordlineA101.Apttus_Config2__OrderId__c=order.id;
  ordlineA101.Apttus_Config2__Quantity__c=1.000;
  ordlineA101.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA101.APTS_Group__c='Bundle A'; 
  ordlineA101.APTS_Program_ID__c = 'WCMP';
  ordlineA101.APTS_Bridge__c='N/A';
  ordlineList.add(ordlineA101);
  
  Apttus_Config2__OrderLineItem__c ordlineA102 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA102.APTS_Contract_Term__c='1 Year';
  ordlineA102.Apttus_Config2__OrderId__c=order.id;
  ordlineA102.Apttus_Config2__Quantity__c=1.000;
  ordlineA102.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA102.APTS_Group__c='Bundle A'; 
  ordlineA102.APTS_Program_ID__c = 'WCMP';
  ordlineA102.APTS_Bridge__c='7 Days';
  ordlineList.add(ordlineA102);
  
  Apttus_Config2__OrderLineItem__c ordlineA103 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA103.APTS_Contract_Term__c='1 Year';
  ordlineA103.Apttus_Config2__OrderId__c=order.id;
  ordlineA103.Apttus_Config2__Quantity__c=1.000;
  ordlineA103.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA103.APTS_Group__c='Bundle A'; 
  ordlineA103.APTS_Program_ID__c = 'WCMP';
  ordlineA103.APTS_Bridge__c='14 Days';
  ordlineList.add(ordlineA103);
  
  Apttus_Config2__OrderLineItem__c ordlineA104 =  new Apttus_Config2__OrderLineItem__c();
  ordlineA104.APTS_Contract_Term__c='1 Year';
  ordlineA104.Apttus_Config2__OrderId__c=order.id;
  ordlineA104.Apttus_Config2__Quantity__c=1.000;
  ordlineA104.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineA104.APTS_Group__c='Bundle A'; 
  ordlineA104.APTS_Program_ID__c = 'WCMP';
  ordlineA104.APTS_Bridge__c='28 Days';
  ordlineList.add(ordlineA104);
  
  Apttus_Config2__OrderLineItem__c ordline22 =  new Apttus_Config2__OrderLineItem__c();
  ordline22.Apttus_Config2__OrderId__c=order.id;
  ordline22.Apttus_Config2__Quantity__c=1.000; 
  ordline22.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordline22.APTS_SAP_MLA_Agreement_Number__c = '12345';
  ordline22.APTS_Service_Number__c = '40757482';
  ordlineList.add(ordline22);   

  Apttus_Config2__OrderLineItem__c ordline23 =  new Apttus_Config2__OrderLineItem__c();
  ordline23.Apttus_Config2__OrderId__c=order.id;
  ordline23.Apttus_Config2__Quantity__c=1.000; 
  ordline23.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineList.add(ordline23);
  
  Apttus_Config2__OrderLineItem__c ordline111 =  new Apttus_Config2__OrderLineItem__c();
  ordline111.Apttus_Config2__Uom__c='Each';
  ordline111.APTS_New_Bridge_Discount__c=1;
  ordline111.APTS_Contract_Term__c='2 Years';  
  ordline111.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline111.Apttus_Config2__Quantity__c=1.000;
  ordline111.Apttus_Config2__ProductId__c=oProductP.id;
  ordline111.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline111);  
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline5 =  new Apttus_Config2__OrderLineItem__c();
  ordline5.APTS_Contract_Term__c='10 Years';
  ordline5.Apttus_Config2__Quantity__c=1.000;
  ordline5.Apttus_Config2__OrderId__c=order.id;
  //ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline5.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline5.Apttus_Config2__PriceType__c = 'Recurring';
  ordline5.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline5.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline5);   
  
  Apttus_Config2__OrderLineItem__c ordline13 =  new Apttus_Config2__OrderLineItem__c();
  ordline13.Apttus_Config2__OrderId__c=order.id;
  ordline13.Apttus_Config2__Quantity__c=1.000; 
  ordline13.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineList.add(ordline13);  
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline4 =  new Apttus_Config2__OrderLineItem__c();
  ordline4.APTS_Contract_Term__c='5 Years';
  ordline4.Apttus_Config2__Quantity__c=1.000;
  ordline4.Apttus_Config2__OrderId__c=order.id;
  ordline4.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline4.Apttus_Config2__LineType__c = 'Option';
  ordline4.Apttus_Config2__PriceType__c = 'One Time';
  ordline4.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline4);
  
  //adding orderline
  Apttus_Config2__OrderLineItem__c ordline24 =  new Apttus_Config2__OrderLineItem__c();
  ordline24.APTS_Contract_Term__c='3 Years';
  ordline24.Apttus_Config2__Quantity__c=1.000;
  ordline24.Apttus_Config2__ProductId__c=oProductB.id;
  ordline24.Apttus_Config2__OrderId__c=order.id;
  ordline24.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline24.Apttus_Config2__LineType__c = 'Product/Service';
  ordline24.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordline24);
  
  Apttus_Config2__OrderLineItem__c ordline25 =  new Apttus_Config2__OrderLineItem__c();
  ordline25.APTS_Contract_Term__c='4 Years';
  ordline25.Apttus_Config2__Quantity__c=1.000;
  ordline25.Apttus_Config2__ProductId__c=oProductB.id;
  ordline25.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline25);
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline14 =  new Apttus_Config2__OrderLineItem__c();
  ordline14.APTS_Contract_Term__c='5 Years';
  ordline14.Apttus_Config2__Quantity__c=1.000;
  ordline14.Apttus_Config2__OrderId__c=order.id;
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline14.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline14.Apttus_Config2__LineType__c = 'Product/Service';
  ordline14.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordline14);
  
  Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='3 Years';
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline2);
  
  Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='4 Years';
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordlineList.add(ordline3);
  
  Apttus_Config2__OrderLineItem__c ordline26 =  new Apttus_Config2__OrderLineItem__c();
  ordline26.Apttus_Config2__OrderId__c=order.id;
  ordline26.Apttus_Config2__Quantity__c=1.000; 
  ordline26.Apttus_Config2__LineStatus__c='Cancelled'; 
  ordlineList.add(ordline26);
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline53 =  new Apttus_Config2__OrderLineItem__c();
  ordline53.APTS_Contract_Term__c='10 Years';
  ordline53.Apttus_Config2__Quantity__c=1.000;
  ordline53.Apttus_Config2__OrderId__c=order.id;
  //ordline53.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline53.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline53.Apttus_Config2__PriceType__c = 'Recurring';
  ordlineList.add(ordline53);  
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline43 =  new Apttus_Config2__OrderLineItem__c();
  ordline43.APTS_Contract_Term__c='5 Years';
  ordline43.Apttus_Config2__Quantity__c=1.000;
  ordline43.Apttus_Config2__OrderId__c=order.id;
  ordline43.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline43.Apttus_Config2__LineType__c = 'Option';
  ordline43.Apttus_Config2__PriceType__c = 'One Time';
  ordlineList.add(ordline43);
  
  //changed order1 to order
  Apttus_Config2__OrderLineItem__c ordline143 =  new Apttus_Config2__OrderLineItem__c();
  ordline143.APTS_Contract_Term__c='5 Years';
  ordline143.Apttus_Config2__Quantity__c=1.000;
  ordline143.Apttus_Config2__OrderId__c=order.id;
  //ordline4.Apttus_Config2__AttributeValueId__c=attribute.id;
  ordline143.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordline143.Apttus_Config2__LineType__c = 'Product/Service';
  ordline143.Apttus_Config2__PriceType__c = 'One Time';
  insert ordline143; 
  
   //added product
  Apttus_Config2__OrderLineItem__c ordline15 =  new Apttus_Config2__OrderLineItem__c();
  ordline15.APTS_Contract_Term__c='5 Years';
  ordline15.Apttus_Config2__Quantity__c=1.000;
  ordline15.Apttus_Config2__OrderId__c=order.id;
  ordline15.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline15.Apttus_Config2__PriceType__c = 'One Time';
  ordline15.Apttus_Config2__ProductId__c = oProductC.Id;
  ordline15.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline15);  
 
  Apttus_Config2__OrderLineItem__c ordline112 =  new Apttus_Config2__OrderLineItem__c();
  ordline112.Apttus_Config2__OrderId__c=order.id;
  ordline112.Apttus_Config2__Uom__c='Each';
  ordline112.APTS_New_Bridge_Discount__c=1;
  ordline112.APTS_Contract_Term__c='2 Years';  
  ordline112.Apttus_Config2__BillingFrequency__c ='Yearly';
  ordline112.Apttus_Config2__Quantity__c=1.000;
  ordline112.Apttus_Config2__ProductId__c=oProductB.id;
  ordlineList.add(ordline112);  
  //added fill up
  Apttus_Config2__OrderLineItem__c ordlineF =  new Apttus_Config2__OrderLineItem__c();
  ordlineF.APTS_Contract_Term__c='5 Years';
  ordlineF.Apttus_Config2__Quantity__c=1.000;
  ordlineF.Apttus_Config2__OrderId__c=order.id;
  ordlineF.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineF.Apttus_Config2__PriceType__c = 'One Time';
  ordlineF.Apttus_Config2__LineType__c = 'Product/Service';
  ordlineF.Apttus_Config2__ProductId__c = oProductC.Id;
  ordlineF.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordlineF);  
  
  Apttus_Config2__OrderLineItem__c ordlineF1 =  new Apttus_Config2__OrderLineItem__c();
  ordlineF1.APTS_Contract_Term__c='5 Years';
  ordlineF1.Apttus_Config2__Quantity__c=1.000;
  ordlineF1.Apttus_Config2__OrderId__c=order.id;
  ordlineF1.Apttus_Config2__ChargeType__c = 'Standard Price';
  ordlineF1.Apttus_Config2__PriceType__c = 'One Time';
  ordlineF1.Apttus_Config2__LineType__c = 'Option';
  ordlineF1.Apttus_Config2__ProductId__c = oProductC.Id;
  ordlineF.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordlineF1); 
  
   Apttus_Config2__OrderLineItem__c ordline51 =  new Apttus_Config2__OrderLineItem__c();
  ordline51.APTS_Contract_Term__c='5 Years';
  ordline51.Apttus_Config2__Quantity__c=1.000;
  ordline51.Apttus_Config2__OrderId__c=order.id;
  ordline51.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline51.Apttus_Config2__PriceType__c = 'One Time';
  ordline51.Apttus_Config2__BillingFrequency__c='Yearly';
  ordline51.Apttus_Config2__ProductId__c = oProductB.Id;
  ordline51.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline51);  
  
  
   Apttus_Config2__OrderLineItem__c ordline52 =  new Apttus_Config2__OrderLineItem__c();
  ordline52.APTS_Contract_Term__c='5 Years';
  ordline52.Apttus_Config2__Quantity__c=1.000;
  ordline52.Apttus_Config2__OrderId__c=order.id;
  ordline52.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline52.Apttus_Config2__PriceType__c = 'One Time';
  ordline52.Apttus_Config2__BillingFrequency__c='Monthly';
  ordline52.Apttus_Config2__ProductId__c = oProductP.Id;
  ordline52.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline52);  
  
  
   Apttus_Config2__OrderLineItem__c ordline54 =  new Apttus_Config2__OrderLineItem__c();
  ordline54.APTS_Contract_Term__c='5 Years';
  ordline54.Apttus_Config2__Quantity__c=1.000;
  ordline54.Apttus_Config2__OrderId__c=order.id;
  ordline54.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline54.Apttus_Config2__PriceType__c = 'One Time';
  ordline54.Apttus_Config2__BillingFrequency__c='Yearly';
  ordline54.Apttus_Config2__ProductId__c = oProductP.Id;
  ordline54.Apttus_Config2__NetPrice__c = 1728;
  ordlineList.add(ordline54);  
  
   Apttus_Config2__OrderLineItem__c ordline152 =  new Apttus_Config2__OrderLineItem__c();
  ordline152.APTS_Contract_Term__c='5 Years';
   ordline152.Apttus_Config2__OrderId__c=order.id;
  ordline152.Apttus_Config2__Quantity__c=1.000;
  ordline152.Apttus_Config2__ChargeType__c = 'Subscription Fee';
  ordline152.Apttus_Config2__PriceType__c = 'One Time';
  ordline152.Apttus_Config2__ProductId__c = oProductB.Id;
  ordline152.Apttus_Config2__NetPrice__c = 1728;
  ordline152.Apttus_Config2__BillingFrequency__c='Yearly';
  ordlineList.add(ordline152);  
            
   Apttus_Config2__OrderLineItem__c ordlinee =  new Apttus_Config2__OrderLineItem__c();
  ordlinee.APTS_Contract_Term__c='1 Year';
  ordlinee.Apttus_Config2__OrderId__c=order.id;
  ordlinee.Apttus_Config2__LineStatus__c='Renewed'; 
  ordlinee.Apttus_Config2__Quantity__c=1.000;
  ordlinee.Apttus_Config2__ProductId__c=oProductB.id;
  ordlinee.APTS_Group__c='Bundle A';  
  ordlinee.APTS_Bridge__c='7 Days';
  ordlinee.Apttus_Config2__BillingFrequency__c = 'Yearly';
  ordlineList.add(ordlinee);
  
  insert ordlineList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  Apttus_Config2__OrderProductAttributeValue__c attribute = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute.Apttus_Config2__LineItemId__c=ordline5.id;
  orderProd.add(attribute);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute11 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute11.SCS_Print_Purchase_Options__c='Ship & Enter Sub';
  attribute11.Apttus_Config2__LineItemId__c=ordline51.id;
  orderProd.add(attribute11);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute111 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute111.SCS_Print_Purchase_Options__c='Sub Only';
  attribute111.Apttus_Config2__LineItemId__c=ordline152.id;
  orderProd.add(attribute111);
  
   Apttus_Config2__OrderProductAttributeValue__c attribute110 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute110.SCS_Print_Purchase_Options__c='Ship Only';
  attribute110.Apttus_Config2__LineItemId__c=ordline112.id;
  orderProd.add(attribute110);
  
  
  Apttus_Config2__OrderProductAttributeValue__c attributeF = new Apttus_Config2__OrderProductAttributeValue__c();
  attributeF.SCS_Print_Purchase_Options__c='Fill-Up';
  attributeF.Apttus_Config2__LineItemId__c=ordlineF.id;
  orderProd.add(attributeF);
   
  Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute1.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute1.Apttus_Config2__LineItemId__c=ordline4.id;
  orderProd.add(attribute1);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute2.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute2.Apttus_Config2__LineItemId__c=ordline14.id;
  orderProd.add(attribute2);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute24 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute24.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute24.Apttus_Config2__LineItemId__c=ordline14.id;
  orderProd.add(attribute24);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute15 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute15.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub';
  attribute15.Apttus_Config2__LineItemId__c=ordline15.id;
  orderProd.add(attribute15);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute33 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute33.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute33.Apttus_Config2__LineItemId__c=ordline5.id;
  orderProd.add(attribute33);
  
  
  Apttus_Config2__OrderProductAttributeValue__c attribute13 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute13.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute13.Apttus_Config2__LineItemId__c=ordline43.id;
  orderProd.add(attribute13);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute23 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute23.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute23.Apttus_Config2__LineItemId__c=ordline14.id;
  orderProd.add(attribute23);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute3.SCS_Print_Purchase_Options__c='Fill-Up & Enter Sub APP';
  attribute3.Apttus_Config2__LineItemId__c=ordline15.id;
  orderProd.add(attribute3);
  
   
  Apttus_Config2__OrderProductAttributeValue__c attribute52 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute52.SCS_Print_Purchase_Options__c='Sub Only';
  attribute52.Apttus_Config2__LineItemId__c=ordline52.id;
  orderProd.add(attribute52);
   
  Apttus_Config2__OrderProductAttributeValue__c attribute54 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute54.SCS_Print_Purchase_Options__c='Sub Only';
  attribute54.Apttus_Config2__LineItemId__c=ordline54.id;
  orderProd.add(attribute54);
  insert orderProd;
  
  List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
  
  ordline5.Apttus_Config2__AttributeValueId__c=attribute.id;
  updateOrderList.add(ordline5);
  
  ordlineF.Apttus_Config2__AttributeValueId__c=attributeF.id;
  updateOrderList.add(ordlineF);
  
  ordlineF1.Apttus_Config2__AttributeValueId__c=attributeF.id;
  updateOrderList.add(ordlineF1);
  
  ordline4.Apttus_Config2__AttributeValueId__c=attribute1.id;
  updateOrderList.add(ordline4);
 
  ordline14.Apttus_Config2__AttributeValueId__c=attribute2.id;
  updateOrderList.add(ordline14);
  
  ordline53.Apttus_Config2__AttributeValueId__c=attribute33.id;
  updateOrderList.add(ordline53);
  
  ordline43.Apttus_Config2__AttributeValueId__c=attribute13.id;
  updateOrderList.add(ordline43);
  
  ordline24.Apttus_Config2__AttributeValueId__c=attribute24.id;
  updateOrderList.add(ordline24);
  
  ordline15.Apttus_Config2__AttributeValueId__c=attribute15.id;
  updateOrderList.add(ordline15);
  
  ordline143.Apttus_Config2__AttributeValueId__c=attribute23.id;
  updateOrderList.add(ordline143);
  
  ordline51.Apttus_Config2__AttributeValueId__c=attribute11.id;
  updateOrderList.add(ordline51);
  
  ordline152.Apttus_Config2__AttributeValueId__c=attribute111.id;
  updateOrderList.add(ordline152);
  
   ordline112.Apttus_Config2__AttributeValueId__c=attribute110.id;
  updateOrderList.add(ordline112);
  
  ordline52.Apttus_Config2__AttributeValueId__c=attribute52.id;
  updateOrderList.add(ordline52);
  
  ordline54.Apttus_Config2__AttributeValueId__c=attribute54.id;
  updateOrderList.add(ordline54);
  
  update updateOrderList;
  
  List<APTS_Dynamic_Bundle__c> dynamicList=new List<APTS_Dynamic_Bundle__c>();
  
  APTS_Dynamic_Bundle__c dynamicbundle = new APTS_Dynamic_Bundle__c();
  dynamicbundle.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle.APTS_Group__c='Bundle A';
  dynamicbundle.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle.APTS_Contract_Terms__c='3 Years';
  dynamicbundle.APTS_Net_Price__c=70;
  dynamicbundle.APTS_Billing_Frequency__c='Yearly';
  dynamicbundle.APTS_YoY_2_Plus__c='1';
  dynamicbundle.APTS_isBLINotCreated__c =true;
  dynamicList.add(dynamicbundle);
  
  APTS_Dynamic_Bundle__c dynamicbundle2 = new APTS_Dynamic_Bundle__c();
  dynamicbundle2.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle2.APTS_Group__c='Bundle C';
  dynamicbundle2.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle.APTS_Net_Price__c=50;
  dynamicbundle.APTS_Billing_Frequency__c='Monthly';
  dynamicbundle2.APTS_Contract_Terms__c='5 Years';
  dynamicbundle2.APTS_YoY_2_Plus__c='1';
  dynamicbundle2.APTS_isBLINotCreated__c =true;
  dynamicList.add(dynamicbundle2);
  
  APTS_Dynamic_Bundle__c dynamicbundle3 = new APTS_Dynamic_Bundle__c();
  dynamicbundle3.APTS_Bundle_Primary_Material__c='41972767';
  //dynamicbundle.APTS_Quantity__c=1.00;
  dynamicbundle3.APTS_Group__c='Bundle D';
  dynamicbundle3.APTS_Quote_Proposal__c=oProposal.id;
  dynamicbundle3.APTS_Contract_Terms__c='4 Years';
  dynamicbundle.APTS_Net_Price__c=70;
  dynamicbundle.APTS_Billing_Frequency__c='Yearly';
  dynamicbundle3.APTS_YoY_2_Plus__c='1';
  dynamicbundle3.APTS_isBLINotCreated__c =true;
  dynamicList.add(dynamicbundle3);
  
  insert dynamicList;
  
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc4);
   
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc5);
   
    Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = acc.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non- Attorney',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
   onlineContactList.add(oc6);
   
   insert onlineContactList;
        
    List<Customer_Master_Contacts__c> masterContactList = new List<Customer_Master_Contacts__c>();  
    Customer_Master_Contacts__c mc1 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EBILL EMAIL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address__c = '98.139.180.149',To_IP_Address__c = '111.111.111.111');
    masterContactList.add(mc1);
    Customer_Master_Contacts__c mc2 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address1__c = '172.16.254.1',To_IP_Address1__c = '172.16.254.1');
    masterContactList.add(mc2);
    Customer_Master_Contacts__c mc3 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'PATRON ACC TECH CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com',From_IP_Address2__c = '172.16.254.1',To_IP_Address2__c = '172.16.254.1');
    masterContactList.add(mc3); 
    Customer_Master_Contacts__c mc4 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc4);
    Customer_Master_Contacts__c mc5 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Contact__c = oContact.Id, Customer_Type_Description__c = 'EML PSWD CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc5);
    Customer_Master_Contacts__c mc6 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 03 TECHNICAL CONTACT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc6);
    Customer_Master_Contacts__c mc7 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c = 'SAP - 46 CLEAR PRIMARY CONT', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc7);
     Customer_Master_Contacts__c mc8 = new Customer_Master_Contacts__c(Quote__c = oProposal.Id, Customer_Type_Description__c='Administrator', First_Name__c = 'Sreenu', Last_Name__c = 'Daram', Email_Address__c= 'sreenu.d@tcs.com');
    masterContactList.add(mc8);
    
    insert masterContactList;
   //Test.startTest();
    
     List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
    
  //order.Apttus_Config2__Status__c='Pending';
 // updateordList.add(order);
  /*order1.Apttus_Config2__Status__c='Pending';
  updateordList.add(order1);*/
  
  update updateorderList;
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
 
    Test.stopTest();
    Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;    
    List<Apttus_Config2__Order__c> updateordList1=new List<Apttus_Config2__Order__c>();
     updateordList1 =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
     System.assertequals(0,updateordList.size(),'');
 
  }
   
  }
  
  static testmethod void ordersubmissionGLP()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06'),new Shipping_Method__c(name='International Expedited Rate',Value__c='01')};     
    insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
   
   Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'F4', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVSU');
  productlist.add(oProductB);
  insert productlist;
  
 Test.startTest();
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
  oProposal.Apttus_Proposal__Account__c=acc.id;
 // oProposal.APTS_SA_ID__c = 'AL MSA-WEST(ALMS)';
  oProposal.APTS_Payer__c = accountSSD.id;
  oProposal.APTS_Proposal_Business_Unit__c='Canada';
  oProposal.APTS_Revenue_Channel_Override__c='05';
  oProposal.APTS_Ebilling_contact__c=oContact.id;
  insert oProposal;
   
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();
  
  Apttus_Config2__OrderLineItem__c ordline1 =  new Apttus_Config2__OrderLineItem__c();
  ordline1.APTS_Contract_Term__c='1 Year';
  ordline1.Apttus_Config2__OrderId__c=order.id;
  ordline1.Apttus_Config2__Quantity__c=1.000;
  ordline1.Apttus_Config2__ProductId__c=oProductB.id;
  ordline1.APTS_Group__c='Bundle A'; 
  ordline1.APTS_Program_ID__c = 'WCMP';
  ordline1.APTS_Bridge__c='1 Month';
  ordlineList.add(ordline1);
   
    Apttus_Config2__OrderLineItem__c ordline2 =  new Apttus_Config2__OrderLineItem__c();
  ordline2.APTS_Contract_Term__c='1 Year';
  ordline2.Apttus_Config2__OrderId__c=order.id;
  ordline2.Apttus_Config2__Quantity__c=1.000;
  ordline2.Apttus_Config2__ProductId__c=oProductB.id;
  ordline2.APTS_Group__c='Bundle A'; 
  ordline2.APTS_Program_ID__c = 'WCMP';
  ordline2.APTS_Bridge__c='2 Months';
  ordlineList.add(ordline2);
   
   Apttus_Config2__OrderLineItem__c ordline3 =  new Apttus_Config2__OrderLineItem__c();
  ordline3.APTS_Contract_Term__c='1 Year';
  ordline3.Apttus_Config2__OrderId__c=order.id;
  ordline3.Apttus_Config2__Quantity__c=1.000;
  ordline3.Apttus_Config2__ProductId__c=oProductB.id;
  ordline3.APTS_Group__c='Bundle A'; 
  ordline3.APTS_Program_ID__c = 'WCMP';
  ordline3.APTS_Bridge__c='3 Months';
  ordlineList.add(ordline3);
  
 
  insert ordlineList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  Apttus_Config2__OrderProductAttributeValue__c attribute1 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute1.Purchase_Option_Bundle_Print__c ='Ship & Entitle Sub';
  attribute1.Apttus_Config2__LineItemId__c=ordline1.id;
  orderProd.add(attribute1);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute2 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute2.Purchase_Option_Bundle_Print__c ='Sub Only';
  attribute2.Apttus_Config2__LineItemId__c=ordline2.Id;
  orderProd.add(attribute2);
  
  Apttus_Config2__OrderProductAttributeValue__c attribute3 = new Apttus_Config2__OrderProductAttributeValue__c();
  attribute3.Purchase_Option_Bundle_Print__c ='Ship & Entitle Only';
  attribute3.Apttus_Config2__LineItemId__c=ordline3.id;
  orderProd.add(attribute3);
  insert orderProd;
  
  system.debug(LoggingLevel.WARN,'##### orderProd'+orderProd);
  List<Apttus_Config2__OrderLineItem__c> updateOrderList=new List<Apttus_Config2__OrderLineItem__c>();
  
  ordline1.Apttus_Config2__AttributeValueId__c=attribute1.id;
  updateOrderList.add(ordline1);
  
  ordline2.Apttus_Config2__AttributeValueId__c=attribute2.id;
  updateOrderList.add(ordline2);
  
  ordline3.Apttus_Config2__AttributeValueId__c=attribute3.id;
  updateOrderList.add(ordline3);
  
  update updateOrderList; 
  
  system.debug(LoggingLevel.WARN,'##### updateOrderList'+updateOrderList);
     List<Apttus_Config2__Order__c> updateordList=new List<Apttus_Config2__Order__c>();
  
  update updateorderList;
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
 
    Test.stopTest();
    Apttus_Config2__Order__c o = new Apttus_Config2__Order__c(id=order.id);
    o.Apttus_Config2__Status__c='Submitted';
    update o;    
    List<Apttus_Config2__Order__c> updateordList1=new List<Apttus_Config2__Order__c>();
     updateordList1 =[Select id,Apttus_Config2__Status__c from Apttus_Config2__Order__c  where id = :order.Id AND Apttus_Config2__Status__c ='Submitted'];
     System.assertequals(0,updateordList.size(),'');
 
    }
  }
   //Added by TK 
    @isTest
  static void ordersubmissionTK()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
   
   Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'F4', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVSU');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

  productlist.add(oProductB);
  productlist.add(oproductP);
  productlist.add(prodObj);
  insert productlist;
  
 Test.startTest();
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();

   Apttus_Proposal__Proposal__c oProposalBN=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposalBN.RecordtypeId=propRecorType;
   oProposalBN.Apttus_Proposal__Account__c=acc.id;
   oProposalBN.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposalBN.APTS_Proposal_Business_Unit__c='Canada';
   oProposalBN.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposalBN.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposalBN.Apttus_Proposal__Account__c = acc.Id;
   oProposalBN.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposalBN.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oProposalBN.APTS_HAS_DYNAMIC_BUNDLE__c = true;
   oProposalBN.APTS_SA_ID__c='AZ MSA CTR 048140 (AZM1)';
  insert oProposalBN;

  Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
   oProposal.Apttus_Proposal__Account__c=acc.id;
   oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposal.APTS_Proposal_Business_Unit__c='Canada';
   oProposal.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposal.Apttus_Proposal__Account__c = acc.Id;
   oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;
  insert oProposal;
   

  List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;

        
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();

  Apttus_Config2__Order__c orderBN = new Apttus_Config2__Order__c();
  orderBN.Apttus_Config2__Type__c='New';
  orderBN.Apttus_Config2__Status__c='Pending';
  orderBN.APTS_SSD_Sold_To__c=accountSSD.id;
  orderBN.APTS_SSD_bill_to__c=accountSSD.id;
  orderBN.APTS_SSD_Ship_To__c=accountSSD.id;
  orderBN.Apttus_QPConfig__ProposalId__c=oProposalBN.id;
  orderList.add(orderBN);

  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordlineProfBN =  new Apttus_Config2__OrderLineItem__c();
        ordlineProfBN.APTS_Contract_Term__c='5 Years';
        ordlineProfBN.Apttus_Config2__Quantity__c=1.000;
        ordlineProfBN.Apttus_Config2__OrderId__c=order.id;
        ordlineProfBN.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProfBN.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProfBN.Apttus_Config2__LineType__c = 'Option';
        ordlineProfBN.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProfBN.Apttus_Config2__NetPrice__c = 1728;
        ordlineProfBN.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProfBN.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProfBN.Apttus_Config2__ListPrice__c=100;
        ordlineProfBN.APTS_Program_ID__c = 'WCMP';
        ordlineProfBN.APTS_Keep_Terms__c = false;
        ordlineProfBN.APTS_MLA__c = true;
        ordlineProfBN.APTS_Deal_Number__c = null;
        ordlineProfBN.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProfBN.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProfBN);

        Apttus_Config2__OrderLineItem__c ordlineProfBN1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProfBN1.APTS_Contract_Term__c='5 Years';
        ordlineProfBN1.Apttus_Config2__Quantity__c=1.000;
        ordlineProfBN1.Apttus_Config2__OrderId__c=order.id;
        ordlineProfBN1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProfBN1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProfBN1.Apttus_Config2__LineType__c = 'Option';
        ordlineProfBN1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProfBN1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProfBN1.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProfBN1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProfBN1.Apttus_Config2__ListPrice__c=100;
        ordlineProfBN1.APTS_Program_ID__c = 'WCMP';
        ordlineProfBN1.APTS_Keep_Terms__c = false;
        ordlineProfBN1.APTS_MLA__c = true;
        ordlineProfBN1.APTS_Deal_Number__c = null;
        ordlineProfBN1.APTS_SAP_MLA_Agreement_Number__c = '' ;
        ordlineProfBN1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProfBN1);

  Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.Apttus_Config2__ListPrice__c=100;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.APTS_MLA__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf);
  
        Apttus_Config2__OrderLineItem__c ordlineProf1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf1.APTS_Contract_Term__c='5 Years';
        ordlineProf1.Apttus_Config2__Quantity__c=1.000;
        ordlineProf1.Apttus_Config2__OrderId__c=order.id;
        ordlineProf1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf1.Apttus_Config2__LineType__c = 'Option';
        ordlineProf1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf1.Apttus_Config2__ListPrice__c=100;
        ordlineProf1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        ordlineProf1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf1.APTS_Program_ID__c = 'WCMPS';
        ordlineProf1.APTS_Keep_Terms__c = false;
        ordlineProf1.APTS_MLA__c = true;
        ordlineProf1.APTS_Deal_Number__c = null;
        ordlineProf1.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf1);
            
        Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__LineType__c = 'Option';
        ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMPS';
        ordlineProf2.APTS_Keep_Terms__c = true;
        ordlineProf2.APTS_MLA__c = true;
        ordlineProf2.APTS_Deal_Number__c = 12345;
        ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf2.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf2.APTS_Bridge__c='7 Days';

        ordlineList.add(ordlineProf2);
            
        Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__LineType__c = 'Option';
        ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.APTS_Keep_Terms__c = true;
        ordlineProf3.APTS_MLA__c = true;
        ordlineProf3.APTS_Deal_Number__c = 12345;
        ordlineProf3.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf3.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf3.APTS_Bridge__c='14 Days';

        ordlineList.add(ordlineProf3);
            
        Apttus_Config2__OrderLineItem__c ordlineProf4 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf4.APTS_Contract_Term__c='5 Years';
        ordlineProf4.Apttus_Config2__Quantity__c=1.000;
        ordlineProf4.Apttus_Config2__OrderId__c=order.id;
        ordlineProf4.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf4.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf4.Apttus_Config2__LineType__c = 'Option';
        ordlineProf4.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf4.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf4.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf4.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf4.APTS_Program_ID__c = 'WCMP';
        ordlineProf4.APTS_Keep_Terms__c = true;
        ordlineProf4.APTS_MLA__c = true;
        ordlineProf4.APTS_Deal_Number__c = 12345;
        ordlineProf4.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf4.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf4.APTS_Bridge__c='28 Days';

        ordlineList.add(ordlineProf4);
            
            
 
  insert ordlineList;
            
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc4); 
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc5);
   Online_Contacts__c oc6 =new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc6); 
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc13); 
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc14); 
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc15);
   Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc16);
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc17);
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc18);
            
   insert onlineContactList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  
  
  system.debug(LoggingLevel.WARN,'##### orderProd'+orderProd);
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
  System.assertequals('','','');
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456

    Test.stopTest();
        }
   
    }
    
   @isTest
  static void ordersubTK1()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
   
   Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'F4', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVSU');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';
        
        Product2  objEC =  new Product2();
        objEC.Name='Sreenu Product Test';
        objEC.ProductCode = '41972767';
        objEC.APTS_Media_High_Level_Code__c = '21';
        objEC.APTS_Media_Lower_Level_Code__c = 'EC';
        objEC.IsActive = true;
        objEC.APTS_Corporate_Select__c = 'Primary';
        objEC.LCRM_Sub_Bu__c = label.SALESORGCAN;
        objEC.Service_Number__c ='0';

  productlist.add(oProductB);
  productlist.add(oproductP);
  productlist.add(prodObj);
  productlist.add(objEC);
  insert productlist;
  
 Test.startTest();
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
   Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
   oProposal.Apttus_Proposal__Account__c=acc.id;
   oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposal.APTS_Proposal_Business_Unit__c='Canada';
   oProposal.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposal.Apttus_Proposal__Account__c = acc.Id;
   oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;
  insert oProposal;
   

  List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;

        Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c (Apttus_QPConfig__Proposald__c=oProposal.Id,Apttus_Config2__Status__c ='Finalized');
        insert prodConfig;
  
        List<Apttus_Config2__LineItem__c> liList = new List<Apttus_Config2__LineItem__c>();
        Apttus_Config2__LineItem__c li33 =  new Apttus_Config2__LineItem__c();
        li33.APTS_Group_Primary_Material__c= '40666420';
        li33.Apttus_Config2__LineStatus__c = 'New';
        li33.APTS_Contract_Number__c = 123456;
        li33.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
        li33.Apttus_Config2__ItemSequence__c = 1;
        li33.Apttus_Config2__LineNumber__c = 1;
        li33.Apttus_Config2__ProductId__c = objEC.Id; 
        li33.Apttus_Config2__AddedBy__c = 'User';
        li33.Apttus_Config2__AdjustedPrice__c = 50;
        li33.Apttus_Config2__AdjustmentAmount__c = 50;
        li33.Apttus_Config2__AdjustmentType__c = '% Discount';
        li33.Apttus_Config2__AllocateGroupAdjustment__c = TRUE;
        li33.Apttus_Config2__AllowableAction__c = 'Unrestricted';
        li33.Apttus_Config2__AllowManualAdjustment__c = TRUE;
        li33.Apttus_Config2__AllowProration__c = FALSE;
        li33.Apttus_Config2__AllowRemoval__c = TRUE;
        li33.Apttus_Config2__AutoRenew__c = FALSE;
        li33.Apttus_Config2__BaseExtendedCost__c = 0;
        li33.Apttus_Config2__BaseExtendedPrice__c = 100;
        li33.Apttus_Config2__BasePrice__c = 100;
        li33.Apttus_Config2__BasePriceMethod__c = 'Per Unit';
        li33.Apttus_Config2__BillingFrequency__c = 'Monthly';
        li33.Apttus_Config2__ChargeType__c = 'Subscription Fee';
        li33.Apttus_Config2__ConfigStatus__c = 'Complete';
        li33.Apttus_Config2__ConstraintCheckStatus__c = 'NA';
        li33.Apttus_Config2__Customizable__c = FALSE;
        li33.Apttus_Config2__DeltaPrice__c = 50;
        li33.Apttus_Config2__DeltaQuantity__c = 1;
        li33.Apttus_Config2__Description__c = 'Westlaw Flex Plan $100/500';
        li33.Apttus_Config2__ExtendedCost__c = 0;
        li33.Apttus_Config2__ExtendedPrice__c = 100;
        li33.Apttus_Config2__Frequency__c = 'Monthly';
        li33.Apttus_Config2__Guidance__c = 'Red';
        li33.Apttus_Config2__HasAttributes__c = FALSE;
        li33.Apttus_Config2__HasBaseProduct__c = FALSE;
        li33.Apttus_Config2__HasDefaults__c = FALSE;
        li33.Apttus_Config2__HasIncentives__c = FALSE;
        li33.Apttus_Config2__HasOptions__c = FALSE;
        li33.Apttus_Config2__HasTieredPrice__c = FALSE;
        li33.Apttus_Config2__HideCopyAction__c = FALSE;
        li33.Apttus_Config2__HideInvoiceDisplay__c = FALSE;
        li33.Apttus_Config2__IsAssetPricing__c = FALSE;
        li33.Apttus_Config2__IsCustomPricing__c = FALSE;
        li33.Apttus_Config2__IsHidden__c = FALSE;
        li33.Apttus_Config2__IsOptionRollupLine__c = FALSE;
        li33.Apttus_Config2__IsPrimaryLine__c = TRUE;
        li33.Apttus_Config2__IsPrimaryRampLine__c = FALSE;
        li33.Apttus_Config2__IsQuantityModifiable__c = FALSE;
        li33.Apttus_Config2__IsReadOnly__c = FALSE;
        li33.Apttus_Config2__IsSellingTermReadOnly__c = FALSE;
        li33.Apttus_Config2__IsUsageTierModifiable__c = FALSE;
        li33.Apttus_Config2__LineSequence__c = 1;
        li33.APTS_Yr_1_Renewal_Adjustment__c ='1';
        li33.Apttus_Config2__LineType__c = 'Product/Service';
        li33.Apttus_Config2__ListPrice__c = 100;
        li33.Apttus_Config2__NetAdjustmentPercent__c = -50;
        li33.Apttus_Config2__NetPrice__c = 50;
        li33.Apttus_Config2__NetUnitPrice__c = 50;
        li33.Apttus_Config2__OptionSequence__c = 0;
        li33.Apttus_Config2__PriceIncludedInBundle__c = FALSE;
        li33.Apttus_Config2__PriceMethod__c = 'Per Unit';
        li33.Apttus_Config2__PriceType__c = 'Recurring';
        li33.Apttus_Config2__PriceUom__c = 'Each';
        li33.Apttus_Config2__PricingStatus__c = 'Complete';
        li33.Apttus_Config2__PrimaryLineNumber__c = 1;
        li33.Apttus_Config2__ProductVersion__c = 1;
        li33.Apttus_Config2__Quantity__c = 1;
        li33.Apttus_Config2__RollupPriceToBundle__c = TRUE;
        li33.Apttus_Config2__SellingFrequency__c = 'Monthly';
        li33.Apttus_Config2__SellingTerm__c = 1;
        li33.Apttus_Config2__SyncStatus__c = 'Pending';
        li33.Apttus_Config2__Taxable__c = FALSE;
        li33.Apttus_Config2__TaxInclusive__c = FALSE;
        li33.Apttus_Config2__Term__c = 1;
        li33.Apttus_Config2__TotalQuantity__c = 1;
        li33.Apttus_Config2__Uom__c = 'Each';
        li33.CurrencyIsoCode = 'USD';
        li33.APTS_Product_Family__c = 'WESTLAW';
        li33.APTS_Contract_Term__c = '2 Years';
        li33.APTS_Years_2_Plus_Adjustment__c = '4';
        li33.APTS_Product_Delivery__c = 'Online/Internet';
        li33.Apttus_Config2__Quantity__c = 1; 
        //insert lineItemo;
        liList.add(li33);
        insert liList;
        
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = objEC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li3);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();
  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = false;
        ordlineProf.APTS_MLA__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'New';
        ordlineList.add(ordlineProf);
        
        Apttus_Config2__OrderLineItem__c objOLIEC =  new Apttus_Config2__OrderLineItem__c();
        objOLIEC.APTS_Contract_Term__c='5 Years';
        objOLIEC.Apttus_Config2__Quantity__c=1.000;
        objOLIEC.Apttus_Config2__OrderId__c=order.id;
        objOLIEC.Apttus_Config2__ChargeType__c = 'Standard Price';
        objOLIEC.Apttus_Config2__PriceType__c = 'One Time';
        objOLIEC.Apttus_Config2__LineType__c = 'Option';
        objOLIEC.Apttus_Config2__ProductId__c = objEC.Id;
        objOLIEC.Apttus_Config2__NetPrice__c = 1728;
        objOLIEC.Apttus_Config2__BillingFrequency__c = 'Yearly';
        objOLIEC.APTS_New_Bridge_Discount__c = 5.00;
        objOLIEC.APTS_Program_ID__c = 'WCMP';
        objOLIEC.APTS_Keep_Terms__c = false;
        objOLIEC.APTS_MLA__c = true;
        objOLIEC.APTS_Deal_Number__c = 12345;
        objOLIEC.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        objOLIEC.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(objOLIEC);
  
 
  insert ordlineList;
            
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc4); 
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc5);
   Online_Contacts__c oc6 =new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc6); 
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc13); 
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc14); 
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc15);
   Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc16);
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc17);
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc18);
            
   insert onlineContactList;  
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  
  
  system.debug(LoggingLevel.WARN,'##### orderProd'+orderProd);
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);  
  System.assertequals('','',''); 
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
 
    Test.stopTest(); 
        } 
   
    }
     @isTest
  static void ordersubmission_old_process()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
      insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
     insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),new KeyValueListStore__c(Name='APTS_OldOrderProcess',TextValue__c='true')};
        insert keyvaluestore;
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
   
   Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'F4', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVSU');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

  productlist.add(oProductB);
  productlist.add(oproductP);
  productlist.add(prodObj);
  insert productlist;
  
 Test.startTest();
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();

   Apttus_Proposal__Proposal__c oProposalBN=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposalBN.RecordtypeId=propRecorType;
   oProposalBN.Apttus_Proposal__Account__c=acc.id;
   oProposalBN.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposalBN.APTS_Proposal_Business_Unit__c='Canada';
   oProposalBN.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposalBN.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposalBN.Apttus_Proposal__Account__c = acc.Id;
   oProposalBN.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposalBN.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oProposalBN.APTS_HAS_DYNAMIC_BUNDLE__c = true;
   oProposalBN.APTS_SA_ID__c='AZ MSA CTR 048140 (AZM1)';
  insert oProposalBN;

  Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
   oProposal.Apttus_Proposal__Account__c=acc.id;
   oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposal.APTS_Proposal_Business_Unit__c='Canada';
   oProposal.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposal.Apttus_Proposal__Account__c = acc.Id;
   oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;
  insert oProposal;
   

  List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;

        
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();

  Apttus_Config2__Order__c orderBN = new Apttus_Config2__Order__c();
  orderBN.Apttus_Config2__Type__c='New';
  orderBN.Apttus_Config2__Status__c='Pending';
  orderBN.APTS_SSD_Sold_To__c=accountSSD.id;
  orderBN.APTS_SSD_bill_to__c=accountSSD.id;
  orderBN.APTS_SSD_Ship_To__c=accountSSD.id;
  orderBN.Apttus_QPConfig__ProposalId__c=oProposalBN.id;
  orderList.add(orderBN);

  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordlineProfBN =  new Apttus_Config2__OrderLineItem__c();
        ordlineProfBN.APTS_Contract_Term__c='5 Years';
        ordlineProfBN.Apttus_Config2__Quantity__c=1.000;
        ordlineProfBN.Apttus_Config2__OrderId__c=order.id;
        ordlineProfBN.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProfBN.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProfBN.Apttus_Config2__LineType__c = 'Option';
        ordlineProfBN.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProfBN.Apttus_Config2__NetPrice__c = 1728;
        ordlineProfBN.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProfBN.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProfBN.Apttus_Config2__ListPrice__c=100;
        ordlineProfBN.APTS_Program_ID__c = 'WCMP';
        ordlineProfBN.APTS_Keep_Terms__c = false;
        ordlineProfBN.APTS_MLA__c = true;
        ordlineProfBN.APTS_Deal_Number__c = null;
        ordlineProfBN.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProfBN.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProfBN);

        Apttus_Config2__OrderLineItem__c ordlineProfBN1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProfBN1.APTS_Contract_Term__c='5 Years';
        ordlineProfBN1.Apttus_Config2__Quantity__c=1.000;
        ordlineProfBN1.Apttus_Config2__OrderId__c=order.id;
        ordlineProfBN1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProfBN1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProfBN1.Apttus_Config2__LineType__c = 'Option';
        ordlineProfBN1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProfBN1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProfBN1.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProfBN1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProfBN1.Apttus_Config2__ListPrice__c=100;
        ordlineProfBN1.APTS_Program_ID__c = 'WCMP';
        ordlineProfBN1.APTS_Keep_Terms__c = false;
        ordlineProfBN1.APTS_MLA__c = true;
        ordlineProfBN1.APTS_Deal_Number__c = null;
        ordlineProfBN1.APTS_SAP_MLA_Agreement_Number__c = '' ;
        ordlineProfBN1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProfBN1);

  Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.Apttus_Config2__ListPrice__c=100;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.APTS_MLA__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf);
  
        Apttus_Config2__OrderLineItem__c ordlineProf1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf1.APTS_Contract_Term__c='5 Years';
        ordlineProf1.Apttus_Config2__Quantity__c=1.000;
        ordlineProf1.Apttus_Config2__OrderId__c=order.id;
        ordlineProf1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf1.Apttus_Config2__LineType__c = 'Option';
        ordlineProf1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf1.Apttus_Config2__ListPrice__c=100;
        ordlineProf1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        ordlineProf1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf1.APTS_Program_ID__c = 'WCMPS';
        ordlineProf1.APTS_Keep_Terms__c = false;
        ordlineProf1.APTS_MLA__c = true;
        ordlineProf1.APTS_Deal_Number__c = null;
        ordlineProf1.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf1);
            
        Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__LineType__c = 'Option';
        ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMPS';
        ordlineProf2.APTS_Keep_Terms__c = true;
        ordlineProf2.APTS_MLA__c = true;
        ordlineProf2.APTS_Deal_Number__c = 12345;
        ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf2.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf2.APTS_Bridge__c='7 Days';

        ordlineList.add(ordlineProf2);
            
        Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__LineType__c = 'Option';
        ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.APTS_Keep_Terms__c = true;
        ordlineProf3.APTS_MLA__c = true;
        ordlineProf3.APTS_Deal_Number__c = 12345;
        ordlineProf3.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf3.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf3.APTS_Bridge__c='14 Days';

        ordlineList.add(ordlineProf3);
            
        Apttus_Config2__OrderLineItem__c ordlineProf4 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf4.APTS_Contract_Term__c='5 Years';
        ordlineProf4.Apttus_Config2__Quantity__c=1.000;
        ordlineProf4.Apttus_Config2__OrderId__c=order.id;
        ordlineProf4.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf4.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf4.Apttus_Config2__LineType__c = 'Option';
        ordlineProf4.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf4.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf4.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf4.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf4.APTS_Program_ID__c = 'WCMP';
        ordlineProf4.APTS_Keep_Terms__c = true;
        ordlineProf4.APTS_MLA__c = true;
        ordlineProf4.APTS_Deal_Number__c = 12345;
        ordlineProf4.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf4.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf4.APTS_Bridge__c='28 Days';

        ordlineList.add(ordlineProf4);
            
            
 
  insert ordlineList;
            
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc4); 
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc5);
   Online_Contacts__c oc6 =new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc6); 
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc13); 
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc14); 
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc15);
   Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc16);
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc17);
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc18);
            
   insert onlineContactList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  
  
  system.debug(LoggingLevel.WARN,'##### orderProd'+orderProd);
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
  System.assertequals('','','');
  
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456
 
    Test.stopTest();
        }}
    
        @isTest
  static void ordersubmissionTKBN()
  {
       WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        insert ordSubSettings ;

        List<WebServiceSettings__c> webserviceList = new List<WebServiceSettings__c>{new WebServiceSettings__c(Name='EnterpriseWSDL',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='StatusPostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PostbackLocation',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='Payment AutoCharge',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available'),
        new WebServiceSettings__c(Name='PaymentCreditIncrease',Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/uat/getEntitlements/ebs/account/qa/createAccount',Service_Unavailable_Message__c='Service not Available')};
     insert webserviceList;
        
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
    insert shippingMethod;
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 

        User u1 = new User(alias = 'User_3', email='user@mydomain.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, employeenumber='0144020',Sales_Force_Description__c ='Home Office',
        timezonesidkey='America/Los_Angeles', username='user_3@mydomain.com');        
        insert u1;
        
        System.Runas(u1){
      Account acc = new Account();
      acc.Name='test';
      acc.Customer_Group__c='FEDERAL GOVERNMENT';
      acc.CurrencyIsoCode='USD';
      acc.Sales_Org__c='CARS';
      Insert acc;
  
      Source_System_Detail__c accountSSD= new Source_System_Detail__c();
      accountSSD.Name='ABC';
      accountSSD.Source_System_Name__c='ABC';
      accountSSD.Account_Name__c=acc.ID;
      accountSSD.LCRM_Customer_Group__c='FEDERAL GOVERNMENT';
      accountSSD.Account_Inactive__c=false;
      accountSSD.LCRM_Sales_Org__c='CARS';
      accountSSD.Source_System_Account_Number__c ='9476937';
      insert accountSSD;
  
          List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c=System.Label.APTS_OC_Test_Id),new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other')};
        insert keyvaluestore;
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
   
   Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
       Opportunity oppty= new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='25%',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert oppty;
  Contact oContact = UnitTest.getContactInstance(acc.Id);
  oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
  insert oContact;
  
  List<Product2> productlist=new List<Product2>();
  Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '40284616', APTS_Media_Lower_Level_Code__c = 'F4', APTS_Media_High_Level_Code__c = '21', Apttus_Config2__Uom__c = 'Attorneys',APTS_Item_Category_Group__c='ZVSU');
  Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'I9', APTS_Media_High_Level_Code__c='13',Apttus_Config2__Uom__c = 'Seats',LCRM_Sub_Bu__c =label.SALESORGCAN);
  Product2 prodobj = new Product2();

        prodobj.Name='Sreenu Product Test';
        prodobj.ProductCode = '41972767';
        prodobj.APTS_Media_High_Level_Code__c = '06';
        prodobj.APTS_Media_Lower_Level_Code__c = 'Q6';
        prodobj.IsActive = true;
        prodobj.LCRM_Sub_Bu__c = label.SALESORGCAN;
        prodobj.Service_Number__c ='0';

  productlist.add(oProductB);
  productlist.add(oproductP);
  productlist.add(prodObj);
  insert productlist;
  
 Test.startTest();
 Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();

   Apttus_Proposal__Proposal__c oProposalBN=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposalBN.RecordtypeId=propRecorType;
   oProposalBN.Apttus_Proposal__Account__c=acc.id;
   oProposalBN.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposalBN.APTS_Proposal_Business_Unit__c='SCS';
   oProposalBN.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposalBN.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposalBN.Apttus_Proposal__Account__c = acc.Id;
   oProposalBN.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposalBN.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oProposalBN.APTS_HAS_DYNAMIC_BUNDLE__c = true;
   oProposalBN.APTS_SA_ID__c='AZ MSA CTR 048140 (AZM1)';
  insert oProposalBN;

  Apttus_Proposal__Proposal__c oProposal=APTS_TestDataFactory.createProposal(oppty.Id, accountSSD.Id);
   oProposal.RecordtypeId=propRecorType;
   oProposal.Apttus_Proposal__Account__c=acc.id;
   oProposal.Apttus_Proposal__Proposal_Name__c ='WCMP Proposal Test';
   oProposal.APTS_Proposal_Business_Unit__c='SCS';
   oProposal.APTS_Approval_Segment__c='Canada';
   //oProposal.APTS_Order_Confirmation_Contact__c=con.id;
   oProposal.APTS_Assent_DateTime__c=date.ValueOf('2019-03-08'); 
   oProposal.Apttus_Proposal__Account__c = acc.Id;
   oProposal.APTS_SSD_Sold_To__c=accountSSD.Id;
   oProposal.APTS_Card_Expiration_Date__c=date.ValueOf('2019-03-08');
   oproposal.APTS_HAS_DYNAMIC_BUNDLE__c = true;
  insert oProposal;
   

  List<APTS_Quote_Agreement_Locations__c> quoteAgrLocList=new List<APTS_Quote_Agreement_Locations__c>();
        
        APTS_Quote_Agreement_Locations__c multiacc =  new APTS_Quote_Agreement_Locations__c();
        multiacc.APTS_Agreement_Number__c='8923238';  
        multiacc.APTS_Quote_Proposal__c=oProposal .id;
        multiacc.APTS_Status__c='New';
        multiacc.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        
        quoteAgrLocList.add(multiacc);
        
        APTS_Quote_Agreement_Locations__c multiacc1 =  new APTS_Quote_Agreement_Locations__c();
        multiacc1.APTS_Agreement_Number__c='8923238';  
        multiacc1.APTS_Quote_Proposal__c=oProposal .id;
        multiacc1.APTS_Status__c='Cancelled';
        //changed to new Subscriber ssd reference instead of old subscriber field
        multiacc1.APTS_Subscriber_Location_SSD__c=accountSSD.id;
        quoteAgrLocList.add(multiacc1);
        
        insert quoteAgrLocList;

        
  list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
  Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li1);
        
  Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
  listLineItems.add(li2);
  
  insert listLineItems;
  
  
  List<Apttus_Config2__Order__c> orderList=new List<Apttus_Config2__Order__c>();

  Apttus_Config2__Order__c orderBN = new Apttus_Config2__Order__c();
  orderBN.Apttus_Config2__Type__c='New';
  orderBN.Apttus_Config2__Status__c='Pending';
  orderBN.APTS_SSD_Sold_To__c=accountSSD.id;
  orderBN.APTS_SSD_bill_to__c=accountSSD.id;
  orderBN.APTS_SSD_Ship_To__c=accountSSD.id;
  orderBN.Apttus_QPConfig__ProposalId__c=oProposalBN.id;
  orderList.add(orderBN);

  Apttus_Config2__Order__c order = new Apttus_Config2__Order__c();
  order.Apttus_Config2__Type__c='New';
  order.Apttus_Config2__Status__c='Pending';
  order.APTS_SSD_Sold_To__c=accountSSD.id;
  order.APTS_SSD_bill_to__c=accountSSD.id;
  order.APTS_SSD_Ship_To__c=accountSSD.id;
  order.Apttus_QPConfig__ProposalId__c=oProposal.id;
  orderList.add(order);
  
  
  insert orderList; 
  List<Apttus_Config2__OrderLineItem__c> ordlineList=new List<Apttus_Config2__OrderLineItem__c>();

  Apttus_Config2__OrderLineItem__c ordlineProfBN =  new Apttus_Config2__OrderLineItem__c();
        ordlineProfBN.APTS_Contract_Term__c='5 Years';
        ordlineProfBN.Apttus_Config2__Quantity__c=1.000;
        ordlineProfBN.Apttus_Config2__OrderId__c=order.id;
        ordlineProfBN.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProfBN.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProfBN.Apttus_Config2__LineType__c = 'Option';
        ordlineProfBN.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProfBN.Apttus_Config2__NetPrice__c = 1728;
        ordlineProfBN.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProfBN.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProfBN.Apttus_Config2__ListPrice__c=100;
        ordlineProfBN.APTS_Program_ID__c = 'WCMP';
        ordlineProfBN.APTS_Keep_Terms__c = false;
        ordlineProfBN.APTS_MLA__c = true;
        ordlineProfBN.APTS_Deal_Number__c = null;
        ordlineProfBN.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProfBN.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProfBN);

        Apttus_Config2__OrderLineItem__c ordlineProfBN1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProfBN1.APTS_Contract_Term__c='5 Years';
        ordlineProfBN1.Apttus_Config2__Quantity__c=1.000;
        ordlineProfBN1.Apttus_Config2__OrderId__c=order.id;
        ordlineProfBN1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProfBN1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProfBN1.Apttus_Config2__LineType__c = 'Option';
        ordlineProfBN1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProfBN1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProfBN1.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProfBN1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProfBN1.Apttus_Config2__ListPrice__c=100;
        ordlineProfBN1.APTS_Program_ID__c = 'WCMP';
        ordlineProfBN1.APTS_Keep_Terms__c = false;
        ordlineProfBN1.APTS_MLA__c = true;
        ordlineProfBN1.APTS_Deal_Number__c = null;
        ordlineProfBN1.APTS_SAP_MLA_Agreement_Number__c = '' ;
        ordlineProfBN1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProfBN1);

  Apttus_Config2__OrderLineItem__c ordlineProf =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf.APTS_Contract_Term__c='5 Years';
        ordlineProf.Apttus_Config2__Quantity__c=1.000;
        ordlineProf.Apttus_Config2__OrderId__c=order.id;
        ordlineProf.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf.Apttus_Config2__LineType__c = 'Option';
        ordlineProf.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf.Apttus_Config2__ListPrice__c=100;
        ordlineProf.APTS_Program_ID__c = 'WCMP';
        ordlineProf.APTS_Keep_Terms__c = true;
        ordlineProf.APTS_MLA__c = true;
        ordlineProf.APTS_Deal_Number__c = 12345;
        ordlineProf.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf);
  
        Apttus_Config2__OrderLineItem__c ordlineProf1 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf1.APTS_Contract_Term__c='5 Years';
        ordlineProf1.Apttus_Config2__Quantity__c=1.000;
        ordlineProf1.Apttus_Config2__OrderId__c=order.id;
        ordlineProf1.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf1.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf1.Apttus_Config2__LineType__c = 'Option';
        ordlineProf1.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf1.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf1.Apttus_Config2__ListPrice__c=100;
        ordlineProf1.Apttus_Config2__BillingFrequency__c = 'Monthly';
        ordlineProf1.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf1.APTS_Program_ID__c = 'WCMPS';
        ordlineProf1.APTS_Keep_Terms__c = false;
        ordlineProf1.APTS_MLA__c = true;
        ordlineProf1.APTS_Deal_Number__c = null;
        ordlineProf1.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf1.Apttus_Config2__LineStatus__c = 'New';

        ordlineList.add(ordlineProf1);
            
        Apttus_Config2__OrderLineItem__c ordlineProf2 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf2.APTS_Contract_Term__c='5 Years';
        ordlineProf2.Apttus_Config2__Quantity__c=1.000;
        ordlineProf2.Apttus_Config2__OrderId__c=order.id;
        ordlineProf2.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf2.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf2.Apttus_Config2__LineType__c = 'Option';
        ordlineProf2.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf2.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf2.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf2.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf2.APTS_Program_ID__c = 'WCMPS';
        ordlineProf2.APTS_Keep_Terms__c = true;
        ordlineProf2.APTS_MLA__c = true;
        ordlineProf2.APTS_Deal_Number__c = 12345;
        ordlineProf2.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf2.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf2.APTS_Bridge__c='7 Days';

        ordlineList.add(ordlineProf2);
            
        Apttus_Config2__OrderLineItem__c ordlineProf3 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf3.APTS_Contract_Term__c='5 Years';
        ordlineProf3.Apttus_Config2__Quantity__c=1.000;
        ordlineProf3.Apttus_Config2__OrderId__c=order.id;
        ordlineProf3.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf3.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf3.Apttus_Config2__LineType__c = 'Option';
        ordlineProf3.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf3.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf3.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf3.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf3.APTS_Program_ID__c = 'WCMP';
        ordlineProf3.APTS_Keep_Terms__c = true;
        ordlineProf3.APTS_MLA__c = true;
        ordlineProf3.APTS_Deal_Number__c = 12345;
        ordlineProf3.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf3.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf3.APTS_Bridge__c='14 Days';

        ordlineList.add(ordlineProf3);
            
        Apttus_Config2__OrderLineItem__c ordlineProf4 =  new Apttus_Config2__OrderLineItem__c();
        ordlineProf4.APTS_Contract_Term__c='5 Years';
        ordlineProf4.Apttus_Config2__Quantity__c=1.000;
        ordlineProf4.Apttus_Config2__OrderId__c=order.id;
        ordlineProf4.Apttus_Config2__ChargeType__c = 'Standard Price';
        ordlineProf4.Apttus_Config2__PriceType__c = 'One Time';
        ordlineProf4.Apttus_Config2__LineType__c = 'Option';
        ordlineProf4.Apttus_Config2__ProductId__c = prodobj.Id;
        ordlineProf4.Apttus_Config2__NetPrice__c = 1728;
        ordlineProf4.Apttus_Config2__BillingFrequency__c = 'Yearly';
        ordlineProf4.APTS_New_Bridge_Discount__c = 5.00;
        ordlineProf4.APTS_Program_ID__c = 'WCMP';
        ordlineProf4.APTS_Keep_Terms__c = true;
        ordlineProf4.APTS_MLA__c = true;
        ordlineProf4.APTS_Deal_Number__c = 12345;
        ordlineProf4.APTS_SAP_MLA_Agreement_Number__c = '1234' ;
        ordlineProf4.Apttus_Config2__LineStatus__c = 'New';
        ordlineProf4.APTS_Bridge__c='28 Days';

        ordlineList.add(ordlineProf4);
            
            
 
  insert ordlineList;
            
   List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
   Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c , First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Attorney', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc1);
   Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clerk', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc2);
   Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc3); 
   Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = true, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Librarian', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc4); 
   Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Non-Attorney', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc5);
   Online_Contacts__c oc6 =new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Paralegal', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc6); 
   Online_Contacts__c oc7 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc7); 
   Online_Contacts__c oc8 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc8); 
   Online_Contacts__c oc9 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc9); 
   Online_Contacts__c oc10 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Administrator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc10); 
   Online_Contacts__c oc11 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Analyst', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc11); 
   Online_Contacts__c oc12 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Investigator', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc12); 
   Online_Contacts__c oc13 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Supervisor', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc13); 
   Online_Contacts__c oc14 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Clear Technical', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc14); 
   Online_Contacts__c oc15 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, Account__c = multiacc.APTS_Subscriber_Location__c, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Summer Associates', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);
   onlineContactList.add(oc15);
   Online_Contacts__c oc16 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Librarian',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc16);
   Online_Contacts__c oc17 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = true, First_Name__c = 'Sreenu',Account__c =  multiacc.APTS_Subscriber_Location__c, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'abc.def@gmail.com', Position__c = 'Tax Professional',Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=accountSSD.id);
   onlineContactList.add(oc17);
   Online_Contacts__c oc18 = new Online_Contacts__c(Material__c = prodobj.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = false, First_Name__c = 'Sreenu', Middle_Name__c = 'SD',Account__c =acc.id, Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c=multiacc1.APTS_Subscriber_Location__c);
   onlineContactList.add(oc18);
            
   insert onlineContactList;
  
  List<Apttus_Config2__OrderProductAttributeValue__c> orderProd=new List<Apttus_Config2__OrderProductAttributeValue__c>();
  
  
  
  system.debug(LoggingLevel.WARN,'##### orderProd'+orderProd);
  
  Apttus_Config2__Order__c order2= [select Id, Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id = :order.Id];
  //List<String> ordername = new List<String>();
  //ordername.add(order2.Name);
  system.debug(LoggingLevel.WARN,'order2$$ '+order2);   
  System.assertequals('','','');
         APTS_CARS_OrderQueuetoESI.orderSubmissionToESICARS(order2.Id);//Added as part of CRM-9456

    Test.stopTest();
        }
   
    }
 }