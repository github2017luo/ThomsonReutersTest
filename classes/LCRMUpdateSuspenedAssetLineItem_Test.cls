/*
    Flow Builder - LCRM-Update Suspened Asset Line Item On ShipToAccount Flow
 
*/
@isTest
public class LCRMUpdateSuspenedAssetLineItem_Test{

  public static testMethod void testPB() {

        Profile p = [SELECT Id FROM profile WHERE name='System Administrator']; 
        Shipping_Method__c shippingMethod=new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01');
        insert shippingMethod;
        
        List<KeyValueListStore__c> keyvaluestore=new  List<KeyValueListStore__c>{new KeyValueListStore__c(Name='ANZUsersProfileId',TextValue__c='00e30000001ZUki'),
        new KeyValueListStore__c(Name='ReasonWithCompetitor',TextValue__c='Content,Functionality,Price,Outsourced,Contract Terms,Poor TR Experience,Other'),
        new KeyValueListStore__c(Name='LCRMDisableStrikeIronServices',TextValue__c='False')};
        insert keyvaluestore;
   
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='OrdersubmissionESI',Active__c=true,Endpoint__c='https://esi-dev.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST',Password__c='s2esandboxESI12c',Username__c='esisfdcs2euser',Service_Unavailable_Message__c='Service Not Available',Timeout__c=120);
        insert webSettings;
        User u=new User(alias = 'User_3', email='user@mydomain.com', Username = System.now().getTime() + 'test2@test.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago', 
        profileid = p.Id,Sub_Bu__c='FindLaw',Sales_Force_Description__c='Home Office',Rep_Employee_Number__c='12345678',Market_Segment_Description__c='FindLaw' );
        insert u;
        //[Select Id,Name,email,Apts_Revenue_Channel__c,Sales_Force_Description__c,Rep_Employee_Number__c,Market_Segment_Description__c from User where id=:UserInfo.GetUserid()];
    
        Order_Submission__c ordersub=new Order_Submission__c(Name='Order_Submission',Retry_Count__c=3,Period__c=2);
        insert ordersub;
        
        
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
       
        
        Account acc =APTS_TestDataFactory.createAccount('Test');
          acc.Customer_Group__c='FEDERAL GOVERNMENT';
          acc.CurrencyIsoCode='USD';
          acc.Sales_Org__c='WEST';
          acc.Customer_Type__c = 'Individual';
          acc.BU_Marketing_Segment__c='West-International Account';
          acc.Is_GLI__c = true;
          Insert acc;
           
        //Inserting SourceSystemDetail
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c(RecordtypeId=ssdRecorType,Name='ABC',Source_System_Name__c='ABC',Account_Name__c=acc.ID,APTS_Customer_Category__c='1',
                                          LCRM_Customer_Group__c='Academic',Account_Inactive__c=false,LCRM_Sales_Org__c='WEST',Source_System_Account_Number__c='123456',
                                          LCRM_Name_2__c='DEF',LCRM_Name_3__c='XYZ',Number_Street__c='Street5',LCRM_Street_2__c='Street2',LCRM_Street3__c='Street3',LCRM_Street4__c='Street4',
                                          City__c='TestCity',State__c='TestState',Country__c='testCountry',Postal_Code__c='12345',LCRM_Phone__c='9876547777',LCRM_Fax__c='8765432109',LCRM_PO_Box__c='PO-156');
      insert accountSSD;
      
      Contact oContact = APTS_TestDataFactory.createContact('TestContact',acc.id);
      oContact.firstname='TestFirst';
      oContact.SAP_Role__c = 'SAP - 03 TECHNICAL CONTACT;SAP - 46 CLEAR PRIMARY CONT,SAP - 24 EML PSWD CONTACT;SAP - 59 PATRON ACC TECH CONT;EBILL EMAIL CONTACT';
      insert oContact;
      
      List<Product2> productList=new List<Product2>();
      Product2 oProductC = new Product2(Name='Sreenu Product Test9', ProductCode = '40656701', APTS_Media_Lower_Level_Code__c = 'H5', Apttus_Config2__Uom__c = 'Each',Family='FL DIRECTORY',Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      Product2 oProductP = new Product2(Name='Sreenu Product Test9', ProductCode = '40588593', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats',Family='PPC MANAGEMENT',Product_Level_5__c = 'FL NATIONAL AD PACKAGES');
      
      productList.add(oProductC);
      productList.add(oProductP);

      insert productList;    
       
       Date todaysDate = system.today();
       Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Pipeline Opportunity').getRecordTypeId();
       Opportunity o = new Opportunity(RecordTypeId=oppRecordTypeId,  Name='tst-opp', stagename='Needs Analysis',closedate=todaysDate,forecastcategoryname='Omitted',accountId=acc.id,Source_System_Detail__c=accountSSD.id);
       insert o;
              
       Id devRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
       List<Apttus_Proposal__Proposal__c> proposalList=new List<Apttus_Proposal__Proposal__c>();
      Apttus_Proposal__Proposal__c oProposal1 = New Apttus_Proposal__Proposal__c(RecordTypeId=devRecordTypeId, CurrencyIsoCode = 'USD',Apttus_Proposal__Account__c=acc.id, Apttus_Proposal__Proposal_Name__c='TST-10',APTS_Assent_DateTime__c=date.ValueOf('2015-03-08'),APTS_Payment_Option__c='Credit Card' ,APTS_Card_Expiration_Date__c= System.Today(), APTS_amount__c = 30, APTS_Order_Confirmation_Contact__c = oContact.Id,APTS_Proposal_Business_Unit__c = 'FindLaw',
      APTS_SSD_Sold_To__c=accountSSD.Id,APTS_SSD_ship_to__c=accountSSD.Id,APTS_SSD_bill_to__c=accountSSD.Id, Apttus_Proposal__Opportunity__c=o.id, Apttus_Proposal__Approval_Stage__c='Draft', Apttus_Proposal__Proposal_Category__c='Quote', Apttus_Proposal__ReadyToGenerate__c = true, Apttus_Proposal__ReadyToPresent__c= true,ownerid=u.id,APTS_Ground_Shipping__c='Ground Shipping - U.S. Only',APTS_SA_ID__c='NY STATE BK CONTRACT PC66967 (NYBK)',APTS_Ebilling_contact__c=oContact.id,APTS_Align_Contract_End_Dates__c=true);
      
      proposalList.add(oProposal1);
      insert proposalList;
      
      list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
      Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id);
      listLineItems.add(li1);            
      Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductC.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal1.Id,APTS_Category_Name__c='FS 1');
      listLineItems.add(li2);
      insert listLineItems;
      
      Apttus_Config2__AssetLineItem__c assetLineItem=new Apttus_Config2__AssetLineItem__c(Apttus_Config2__ProductId__c=oProductC.id,APTS_Info_RenewalDate__c=system.today(),APTS_SSD_Ship_to__c=accountSSD.id,APTS_SSD_Sold_To__c=accountSSD.id,Apttus_Config2__AccountId__c=acc.id,Apttus_Config2__ShipToAccountId__c=acc.id);
      assetLineItem.Apttus_Config2__AssetStatus__c = 'Pending';
      insert assetLineItem;
        
      assetLineItem.Apttus_Config2__AssetStatus__c = 'Suspended';
      update assetLineItem;
      
      assetLineItem.Apttus_Config2__AssetStatus__c = 'Pending';
      update assetLineItem;  
    }
}