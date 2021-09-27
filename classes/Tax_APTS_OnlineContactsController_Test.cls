/*
* Test Class for Tax_APTS_OnlineContactsController
* Change History
==========================================================
Date            Name        Description
4/7/2019       Poorva      Test Class made for tax Proffessional functionalities
==========================================================
*
*/
@isTest
public class Tax_APTS_OnlineContactsController_Test{
    
    public static testmethod void onlinecontacts(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        id quoteSSD;
        
        
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='TaxProfessional_OnlineContact',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings;
        WebServiceSettings__c webSettings1=new WebServiceSettings__c(Name='CreditCheck',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings1;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype2);
        
        insert recordlist;
         profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='123647';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        //oppty.CurrencyIsoCode=opp;
        //oppty.ForecastCategory='Pipeline';
        // oppty.Key_Contact__c=cont.Id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        // proposal.APTS_Flag_Recursive__c=true;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        //proposal.LATAM_APTS_Quote_Type__c = 'Upgrade/Downgrade';
        //proposal.LATAM_APTS_Boleto_Contact__c = cont.id;
        //proposal.LATAM_APTS_Payment_Method__c = null;
        insert proposal;  
        

        
        
        //List<onlineContactsSerialDeserial.onlineContact> oCDSList= new List<onlineContactsSerialDeserial.onlineContact>();
        onlineContactsSerialDeserial.onlineContact oContacts = new onlineContactsSerialDeserial.onlineContact();
        onlineContactsSerialDeserial.Address a1 = new onlineContactsSerialDeserial.Address();
        onlineContactsSerialDeserial.Account account1= new onlineContactsSerialDeserial.Account();
        onlineContactsSerialDeserial.EsiHeader esiHead= new onlineContactsSerialDeserial.EsiHeader();
        esiHead.applicationId='123456789';
        a1.firstName='ABCD';
        a1.lastName='EFGH'; 
        a1.emailAddress= 'ABCD.E.EFGH@GMAIL.COM';
        account1.accountNumber='12345678';
        
        List<onlineContactsSerialDeserial.Material> lstMaterial = new List<onlineContactsSerialDeserial.Material>();
        onlineContactsSerialDeserial.Material m = new onlineContactsSerialDeserial.Material();
        m.materialNumber = '767';
        m.materialDescription = 'Phone';
        lstMaterial.add(m);
        
        List<onlineContactsSerialDeserial.Assets> lstAssets = new List<onlineContactsSerialDeserial.Assets>();
        onlineContactsSerialDeserial.Assets asst = new onlineContactsSerialDeserial.Assets();
        asst.assetId = 'A-4978375';
        lstAssets.add(asst);
        
        List<onlineContactsSerialDeserial.Subscriptions > lstSub = new List<onlineContactsSerialDeserial.Subscriptions >();
        onlineContactsSerialDeserial.Subscriptions  s = new onlineContactsSerialDeserial.Subscriptions ();
        s.material = lstMaterial;
        s.assets = lstAssets;
        lstSub.add(s);
        
        List<onlineContactsSerialDeserial.Entitlements > lstEnt = new List<onlineContactsSerialDeserial.Entitlements >();
        onlineContactsSerialDeserial.Entitlements  e = new onlineContactsSerialDeserial.Entitlements ();
        e.subscriptions = lstSub;
        lstEnt.add(e);
        
        oContacts.contactNumber='0012409071';
        oContacts.address=a1;
        oContacts.account=account1;
        oContacts.entitlements = lstEnt;
        oContacts.onlineContactType='Admin';
        
        system.debug('Ram Test--->'+oContacts);
        string sortStr =a1.firstName;
        
        
        
        Apttus_Config2__ProductConfiguration__c config=APTS_TestDataFactory.createCart(a.Id, proposal.id,pl.id);
        insert config;
        
        List<Product2> productList =new List<Product2>();
        
           
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test',isActive=true, ProductCode = '1234568978967',  LCRM_Sub_Bu__c ='Tax_Prof',APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',Apttus_Filter_Media__c = 'Online');
        Product2 oProductP = new Product2(Name='Sreenu Product Test12',isActive=true, ProductCode = '1234568978968', LCRM_Sub_Bu__c ='Tax_Prof', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Media__c = 'Online');
        insert oProductB;
        insert oProductP;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=oProductB .id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=oProductP .id;
        pli1.Apttus_Config2__ListPrice__c=100;
        ListPli.add(pli1);
        
        insert ListPli;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, Apttus_QPConfig__PriceUom__c = 'Concurrent');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, Apttus_QPConfig__PriceUom__c = 'Concurrent');
        listLineItems.add(li2);
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, Apttus_QPConfig__PriceUom__c = 'Users',APTS_CUAS1__c=true,Apttus_QPConfig__LineStatus__c='Renewed');
        listLineItems.add(li3);
        insert listLineItems; 
        
        List<Apttus_Config2__AssetLineItem__c> aslList = new List<Apttus_Config2__AssetLineItem__c>();
            Apttus_Config2__AssetLineItem__c assetline =  new Apttus_Config2__AssetLineItem__c(Apttus_QPConfig__ProposalId__c=Proposal .id);
            assetline.Apttus_QPConfig__ProposalLineItemId__c = li3.id;
            assetline.Asset_Auto_Number__c = 'A-4978375';
            aslList.add(Assetline);
            insert aslList;
           /* Set<Id> aliSet = new Set<Id>{Assetline.Id};
            List<Apttus_Config2__AssetLineItem__c> aliListUpdt = [select id, Asset_Auto_Number__c, Tax_Asset_Auto_Number__c from Apttus_Config2__AssetLineItem__c where id in :aliSet];
            for(Apttus_Config2__AssetLineItem__c ali : aliListUpdt){
                ali.Asset_Auto_Number__c = ali.Tax_Asset_Auto_Number__c; 
            }
            update aliListUpdt;*/
            li3.Apttus_QPConfig__AssetLineItemId__c=Assetline.id;
            update li3;
           test.startTest(); 
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(APTS_Source_System_Detail__c=accountSSD.Id,Material__c = oProductP.ProductCode,ProductId__c=oProductP.Id , QuoteId__c = proposal.Id, ContactID__c = cont.id, Is_Banded_Product__c = False, Account__c = a.Id, Latam_Action__c='Add',First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(APTS_Source_System_Detail__c=accountSSD.Id,Material__c = oProductB.ProductCode,ProductId__c=oProductB.Id ,QuoteId__c = proposal.Id,  ContactID__c = cont.id, Is_Banded_Product__c = True,Account__c = a.Id,Latam_Action__c='Add',First_Name__c = 'Gadupudi', Middle_Name__c = 'Gd', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(APTS_Source_System_Detail__c=accountSSD.Id,Latam_Action__c='Add',Material__c = oProductP.ProductCode,ProductId__c=oProductP.Id ,QuoteId__c = proposal.Id,  Is_Banded_Product__c = False, Account__c = a.Id, First_Name__c = 'Naresh', Middle_Name__c = 'SD', Last_Name__c = 'G', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,ProductId__c=oProductB.Id ,QuoteId__c = proposal.Id,  Is_Banded_Product__c = True, Account__c = a.Id, Latam_Action__c='Add',First_Name__c = 'Naidu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,ProductId__c=oProductB.Id ,QuoteId__c = proposal.Id,  Is_Banded_Product__c = True, Account__c = a.Id, First_Name__c = 'Ram',Latam_Action__c='Add', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc5);
       /* Online_Contacts__c oc6 = new Online_Contacts__c(APTS_Source_System_Detail__c=accountSSD.Id, Latam_APTS_IP_Address__c='100.111.111.111', Latam_APTS_To_IP_Address__c='10.133.4.36',Latam_Action__c='Add',Material__c = oProductP.ProductCode,ProductId__c=oProductP.Id , QuoteId__c = proposal.Id, ContactID__c = cont.id, Is_Banded_Product__c = False, Account__c = a.Id, First_Name__c = 'Vasu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc6);*/
        insert onlineContactList;
        
       
        List<oncWrapper> oncWList= new List<oncWrapper>();
         oncWrapper onc= new oncWrapper();            
            onc.evnetIdToAdd = true;
            onc.isSelected = True;
            onc.materialNo = '12345';
            onc.onlineContact=oc3;
            onc.isNewContact=true;
            onc.Action='Edit';
            onc.PrevAction='';
            onc.prevEmail='rama@tcs.com';
            onc.eventIdToDelete=false;
            onc.eventIdToEdit=true;
            onc.evnetIdToAdd=true;
            onc.eventIdToUndo=true;
            oncWList.add(onc);
        
        /*oncWrapper aw1 = new oncWrapper();
        aw1.onlineContact = oc1;
        aw1.evnetIdToAdd=True;
        //aw1.onlineContact.Latam_Action__c='Update';
        //aw1.onlineContact.ProductId__c='12345656';*/
        //List<oncWrapper.onlineContact> oncWList= new List<oncWrapper.onlineContact>();
        //List<oncWrapper> oncWList= new List<oncWrapper>();
         //oncWrapper onc= new oncWrapper();
            onc.evnetIdToAdd = true;
            onc.isSelected = True;
            onc.materialNo = '12345';
            onc.onlineContact=oc3;
            onc.isNewContact=true;
            onc.Action='Add';
            onc.PrevAction='';
            onc.prevEmail='sreenu.d@tcs.com';
            onc.eventIdToDelete=true;
            onc.eventIdToEdit=true;
            onc.evnetIdToAdd=true;
            onc.eventIdToUndo=true;
        oncWList.add(onc);
        
        system.debug('Ram Wrapper--->'+oncWList);
        
           

            
        
        Online_Contacts__c awTest = new Online_Contacts__c();
        awTest.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest.QuoteId__c = proposal.id;
        awTest.ProductId__c = oProductB.id;
        awTest.Material__c = '1205863';
        awTest.Latam_Action__c ='Add';  
        insert awTest;

        oncWrapper aw1 = new oncWrapper();
        aw1.onlineContact = awTest;
        aw1.evnetIdToAdd=True;
        aw1.isSelected= true;
         aw1.eventIdToEdit= true;
        oncWList.add(aw1);
        
        
        Online_Contacts__c awTest11 = new Online_Contacts__c();
        awTest11.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest11.QuoteId__c = proposal.id;
        awTest11.ProductId__c = oProductB.id;
        awTest11.Material__c = '1205863';
        awTest11.Latam_Action__c ='Add';  
        insert awTest11;

        oncWrapper aw11 = new oncWrapper();
        aw11.onlineContact = awTest11;
        aw11.evnetIdToAdd=True;
        aw11.isSelected= true;
        aw11.eventIdToEdit= false;
        aw11.eventIdToDelete = true;
        oncWList.add(aw11);
        
        
        Online_Contacts__c awTest12 = new Online_Contacts__c();
        awTest12.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest12.QuoteId__c = proposal.id;
        awTest12.ProductId__c = oProductB.id;
        awTest12.Material__c = '1205863';
        awTest12.Latam_Action__c ='Add';  
        insert awTest12;
        oncWrapper aw12 = new oncWrapper();
        aw12.onlineContact = awTest12;
        aw12.evnetIdToAdd=false;
        aw12.isSelected= true;
        aw12.eventIdToEdit= false;
        aw12.eventIdToDelete = false;
        oncWList.add(aw12);
        

        Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        PageReference pageRef = Page.Tax_APTS_Online_Contact;
        pageRef.getParameters().put('id', proposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(proposal);
        Tax_APTS_OnlineContactsController contr= new Tax_APTS_OnlineContactsController(sc);
        contr.productsdropdown='A-4978375';
        //contr.ipAdd='1234';
        //contr.quantity = 0;
        //contr.quote_type = 'Upgrade/Downgrade';
        contr.displayMaterials = oncWList;
        
        contr.productsdropdown = li1.Id;
        PageReference pageRef1 = contr.saveRecordAndExit();
        contr.currentPLI=li1;
        pageRef1 = contr.undo_close(); 
       
        contr.fetchAccountOnlinePasswords(accountSSD.Source_System_Account_Number__c);
       
        onc = contr.assignESISelectedContactsUtil(oContacts,'12345678',oc3);
          system.assertEquals(a.Name, 'Testing Account');
        //contr.assignESIContacts('1234568978967',onlineContactList);
        contr.assignESIContacts();
        system.debug('Ram Wrapper1111--->'+oncWList);
             
                     // test.startTest();      
          contr.productsdropdown=null;
          pageRef1 = contr.displayAccountContacts();
        contr.productsdropdown='A-4977375';
          pageRef1 = contr.displayAccountContacts();
          pageRef1 = contr.cancel();
          oncWList = contr.sortByNameList();
          contr.sortStr='First Name';
         contr.sortDir='DESC';
        
           oncWList = contr.sortByNameList();
          
          contr.sortStr='Last Name';
          contr.sortDir='ASC';
          oncWList = contr.sortByNameList();
          contr.sortStr='Last Name';
          contr.sortDir='DESC';
          oncWList = contr.sortByNameList();
          contr.sortStr='Email';
          contr.sortDir='ASC';
          oncWList = contr.sortByNameList();
          contr.sortStr='Email';
          contr.sortDir='DESC';
          oncWList = contr.sortByNameList();
          contr.searchString='Ram';
         
          pageRef1=contr.searchOnlineContacts();
           contr.productsdropdown=null;
           pageRef1=contr.searchOnlineContacts();
          contr.productsdropdown='A-4977375';
            contr.searchString=null;
          pageRef1=contr.searchOnlineContacts();
           contr.searchString='ANNAMA';
          pageRef1=contr.searchOnlineContacts();
         
            contr.productsdropdown='A-4977375';
           contr.currentPLI = li1 ;
           contr.saveRecordAndExit();
           contr.resetOnlineContacts();
           //contr.validIP('11.22.33.1111');
           //contr.validIP('1111122');
           boolean prev= contr.hasPrevious;
           boolean next= contr.hasNext;
            contr.rowToRemove=1;
           pageRef1=contr.removeOnlineContactRowFromDisplayList();
        // contr.previous();
           //contr.previous();
           pageRef1=contr.add_rows();
          onc = contr.assignESIContactsUtil(oContacts,'12345679',pli.ID);
            system.debug('Assign'+onc);
        
        Apttus_Proposal__Proposal__c Prop = [Select id,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_ship_to__c from Apttus_Proposal__Proposal__c where id =: proposal.id];
        quoteSSD = Prop.APTS_SSD_ship_to__c;
        
        
        
        OnlineContactsSerializeandDeserialize ocSD = new OnlineContactsSerializeandDeserialize();
        OnlineContactsSerializeandDeserialize.onlineContacts oc = new OnlineContactsSerializeandDeserialize.onlineContacts();
       
        OnlineContactsSerializeandDeserialize.GetOCBySAPAccountRequest smpReq = new OnlineContactsSerializeandDeserialize.GetOCBySAPAccountRequest();  
        smpReq.assetNumber = ''; 
        OnlineContactsSerializeandDeserialize.onlineContactResponse reso = new OnlineContactsSerializeandDeserialize.onlineContactResponse();
        reso.onlineContact= null;
        OnlineContactsSerializeandDeserialize.Address objAddress = new OnlineContactsSerializeandDeserialize.Address();
        objAddress.contactId  = '';
        objAddress.firstName  = '';
        objAddress.lastName   = '';
        objAddress.middleName   = '';
        objAddress.emailAddress   = '';
        objAddress.phone   = '';
        
        OnlineContactsSerializeandDeserialize.account objaccount = new OnlineContactsSerializeandDeserialize.account();
        objaccount.accountNumber  = '';
        
        OnlineContactsSerializeandDeserialize.material objmaterial = new OnlineContactsSerializeandDeserialize.material();
        objmaterial.materialNumber  = '';
        objmaterial.materialDescription = '';
        
        list<OnlineContactsSerializeandDeserialize.material> objlistmaterial = new list<OnlineContactsSerializeandDeserialize.material>();
        objlistmaterial.add(objmaterial);
        
       
        
        OnlineContactsSerializeandDeserialize.subscriptions objsubscriptions = new OnlineContactsSerializeandDeserialize.subscriptions();
        objsubscriptions.material  = objlistmaterial;
        
        list<OnlineContactsSerializeandDeserialize.subscriptions> objlistsubscriptions = new list<OnlineContactsSerializeandDeserialize.subscriptions>();
        objlistsubscriptions.add(objsubscriptions);
        
        OnlineContactsSerializeandDeserialize.entitlements objentitlements = new OnlineContactsSerializeandDeserialize.entitlements();
        objentitlements.applicationId  = '';
        objentitlements.appUserGuid  = '';
        objentitlements.accessStartDate   = '';
        objentitlements.accessEndDate   = '';
        objentitlements.subscriptions   = objlistsubscriptions;
        
        list<OnlineContactsSerializeandDeserialize.entitlements> objlistentitlements = new list<OnlineContactsSerializeandDeserialize.entitlements>();
        objlistentitlements.add(objentitlements);
        
        
        OnlineContactsSerializeandDeserialize.onlineContact onlco = new OnlineContactsSerializeandDeserialize.onlineContact();
        onlco.contactNumber = '';
        onlco.onlineContactType = '';
        onlco.Address = objAddress;
        onlco.account = objaccount;
        onlco.entitlements = objlistentitlements;
        
        OnlineContactsSerializeandDeserialize.OnlineContactsResponse onlcorespo = new OnlineContactsSerializeandDeserialize.OnlineContactsResponse();
        
        OnlineContactsSerializeandDeserialize.GetOnlineContactsByAccountRequest objGetOnlineContactsByAccountRequest = new OnlineContactsSerializeandDeserialize.GetOnlineContactsByAccountRequest();
        OnlineContactsSerializeandDeserialize.context objcontext = new OnlineContactsSerializeandDeserialize.context();
        OnlineContactsSerializeandDeserialize.filter objfilter = new OnlineContactsSerializeandDeserialize.filter();
        OnlineContactsSerializeandDeserialize.Notification objNotification = new OnlineContactsSerializeandDeserialize.Notification();
        OnlineContactsSerializeandDeserialize.NotificationResponse objNotificationResponse = new OnlineContactsSerializeandDeserialize.NotificationResponse();
        OnlineContactsSerializeandDeserialize.OnlineContactsRequest objOnlineContactsRequest = new OnlineContactsSerializeandDeserialize.OnlineContactsRequest();
        
        onlineContactsSerialDeserial.Account objsaccount = new onlineContactsSerialDeserial.Account();
        objsaccount.accountNumber = '';
        
        onlineContactsSerialDeserial.Address objsAddress = new onlineContactsSerialDeserial.Address();
        objsAddress.firstName = '';
        objsAddress.lastName = '';
        objsAddress.middleName = '';
        objsAddress.phone = '';
        objsAddress.emailAddress = '';
        
        onlineContactsSerialDeserial.Assets objsAssets = new onlineContactsSerialDeserial.Assets();
        objsAssets.assetId = '';
        
        onlineContactsSerialDeserial.Material objsMaterial = new onlineContactsSerialDeserial.Material();
        objsMaterial.materialNumber = '';
        objsMaterial.materialDescription = '';
        
        onlineContactsSerialDeserial.EsiHeader objsEsiHeader = new onlineContactsSerialDeserial.EsiHeader();
        objsEsiHeader.applicationId = '';
        
        onlineContactsSerialDeserial.Subscriptions objsSubscriptions = new onlineContactsSerialDeserial.Subscriptions();
        objsSubscriptions.material = null;
        objsSubscriptions.assets = null;
        
        onlineContactsSerialDeserial.Entitlements objsEntitlements = new onlineContactsSerialDeserial.Entitlements();
        objsEntitlements.applicationId = '';
        objsEntitlements.status = '';
        objsEntitlements.appUserGuid = '';
        objsEntitlements.accessStartDate = '';
        objsEntitlements.accessEndDate = '';
        objsEntitlements.subscriptions = null;
        
        onlineContactsSerialDeserial.onlineContact objsOnlineContact = new onlineContactsSerialDeserial.onlineContact();
        objsOnlineContact.contactNumber = '';
        objsOnlineContact.address = objsAddress;
        objsOnlineContact.account = objsaccount;
        objsOnlineContact.entitlements = null;
        objsOnlineContact.userStatus = null;
        objsOnlineContact.onlineContactType = '';
        
        onlineContactsSerialDeserial.onlineContact objsonlineContacti = new onlineContactsSerialDeserial.onlineContact();
        onlineContactsSerialDeserial.esiHeader objsesiHeaderi = new onlineContactsSerialDeserial.esiHeader();
        
                
            
        ApexPages.Message[] pageMessage = ApexPages.getMessages();
        contr= new Tax_APTS_OnlineContactsController(sc);
        contr.add_rows();
        contr.productsdropdown =li3.id;
        contr.mappingLogic();
        contr.removeduplicateemails(new List<Online_Contacts__c>{new Online_Contacts__c()});
        oncWList= new List<oncWrapper>();
        Online_Contacts__c awTest13 = new Online_Contacts__c();
        awTest13.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest13.QuoteId__c = proposal.id;
        awTest13.ProductId__c = oProductB.id;
        awTest13.Material__c = '1205863';
        awTest13.Latam_Action__c ='Add'; 
        awTest13.QuoteLineItem__c = li3.id; 
        awTest13.Tax_Type__c = 'Admin;User';
        awTest13.Email__c = 't@t.com';
        awTest13.First_Name__c = 't@t.com';
        awTest13.Last_Name__c= 't@t.com';
        oncWrapper aw13 = new oncWrapper();
        aw13.onlineContact = awTest13;
        aw13.evnetIdToAdd=true;
        aw13.isSelected= true;
        aw13.eventIdToEdit= false;
        aw13.eventIdToDelete = false;
        oncWList.add(aw13);
        contr.displayMaterials = oncWList;
        contr.saveRecordAndExit();
        //Tax_APTS_OnlineContactsController.validateOnlineContactInformation(onlineContactList,true,false);
        //Tax_APTS_OnlineContactsController.validateMinOCPresent();
        test.stopTest();
    }
    
    public static testmethod void onlinecontacts1(){
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        id quoteSSD;
        
        
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='TaxProfessional_OnlineContact',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype2);
        
        insert recordlist;
         profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='123647';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        //oppty.CurrencyIsoCode=opp;
        //oppty.ForecastCategory='Pipeline';
        // oppty.Key_Contact__c=cont.Id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        // proposal.APTS_Flag_Recursive__c=true;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
        //proposal.LATAM_APTS_Quote_Type__c = 'Upgrade/Downgrade';
        //proposal.LATAM_APTS_Boleto_Contact__c = cont.id;
       // proposal.LATAM_APTS_Payment_Method__c = null;
        insert proposal; 
        
        Apttus_Config2__ProductConfiguration__c config=APTS_TestDataFactory.createCart(a.Id, proposal.id,pl.id);
        insert config;
        
        List<Product2> productList =new List<Product2>();        
           
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test',isActive=true, ProductCode = '1234568978967',  LCRM_Sub_Bu__c ='Tax_Prof',APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',Apttus_Filter_Media__c = 'Online');
        Product2 oProductP = new Product2(Name='Sreenu Product Test12',isActive=true, ProductCode = '1234568978968', LCRM_Sub_Bu__c ='Tax_Prof', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Media__c = 'Online');
        insert oProductB;
        insert oProductP;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=oProductB .id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=oProductP .id;
        pli1.Apttus_Config2__ListPrice__c=100;
        ListPli.add(pli1);
        
        insert ListPli;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, Apttus_QPConfig__PriceUom__c = 'Concurrent');
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, Apttus_QPConfig__PriceUom__c = 'Concurrent');
        listLineItems.add(li2);
        insert listLineItems; 
        
        test.startTest(); 
       
        
       
       /* List<oncWrapper> oncWList= new List<oncWrapper>();
         oncWrapper onc= new oncWrapper();            
            onc.evnetIdToAdd = true;
            onc.isSelected = True;
            onc.materialNo = '12345';
            onc.onlineContact=oc3;
            onc.isNewContact=true;
            onc.Action='Edit';
            onc.PrevAction='';
            onc.prevEmail='rama@tcs.com';
            onc.eventIdToDelete=false;
            onc.eventIdToEdit=true;
            onc.evnetIdToAdd=true;
            onc.eventIdToUndo=true;
            oncWList.add(onc);*/
        
        /*oncWrapper aw1 = new oncWrapper();
        aw1.onlineContact = oc1;
        aw1.evnetIdToAdd=True;
        //aw1.onlineContact.Latam_Action__c='Update';
        //aw1.onlineContact.ProductId__c='12345656';*/
        //List<oncWrapper.onlineContact> oncWList= new List<oncWrapper.onlineContact>();
        //List<oncWrapper> oncWList= new List<oncWrapper>();
         //oncWrapper onc= new oncWrapper();
          /*  onc.evnetIdToAdd = true;
            onc.isSelected = True;
            onc.materialNo = '12345';
            onc.onlineContact=oc3;
            onc.isNewContact=true;
            onc.Action='Add';
            onc.PrevAction='';
            onc.prevEmail='sreenu.d@tcs.com';
            onc.eventIdToDelete=true;
            onc.eventIdToEdit=true;
            onc.evnetIdToAdd=true;
            onc.eventIdToUndo=true;
        oncWList.add(onc);
        
        system.debug('Ram Wrapper--->'+oncWList);
        
           

            
        
        Online_Contacts__c awTest = new Online_Contacts__c();
        awTest.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest.QuoteId__c = proposal.id;
        awTest.ProductId__c = oProductB.id;
        awTest.Material__c = '1205863';
        awTest.Latam_Action__c ='Add';  
        insert awTest;

        oncWrapper aw1 = new oncWrapper();
        aw1.onlineContact = awTest;
        aw1.evnetIdToAdd=True;
        aw1.isSelected= true;
         aw1.eventIdToEdit= true;
        oncWList.add(aw1);
        
        
        Online_Contacts__c awTest11 = new Online_Contacts__c();
        awTest11.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest11.QuoteId__c = proposal.id;
        awTest11.ProductId__c = oProductB.id;
        awTest11.Material__c = '1205863';
        awTest11.Latam_Action__c ='Add';  
        insert awTest11;

        oncWrapper aw11 = new oncWrapper();
        aw11.onlineContact = awTest11;
        aw11.evnetIdToAdd=True;
        aw11.isSelected= true;
        aw11.eventIdToEdit= false;
        aw11.eventIdToDelete = true;
        oncWList.add(aw11);
        
        
        Online_Contacts__c awTest12 = new Online_Contacts__c();
        awTest12.APTS_Source_System_Detail__c =accountSSD.Id;
        awTest12.QuoteId__c = proposal.id;
        awTest12.ProductId__c = oProductB.id;
        awTest12.Material__c = '1205863';
        awTest12.Latam_Action__c ='Add';  
        insert awTest12;
        oncWrapper aw12 = new oncWrapper();
        aw12.onlineContact = awTest12;
        aw12.evnetIdToAdd=false;
        aw12.isSelected= true;
        aw12.eventIdToEdit= false;
        aw12.eventIdToDelete = false;
        oncWList.add(aw12);*/
        

     //   Test.setMock(HttpCalloutMock.class,new OrderSubmissionMocKCallout());
        PageReference pageRef = Page.Tax_APTS_Online_Contact;
        pageRef.getParameters().put('id', proposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(proposal);
        Tax_APTS_OnlineContactsController contr= new Tax_APTS_OnlineContactsController(sc);
        contr.productsdropdown='A-4978345';  
        //contr.quantity= 1;
        contr.intProductQuantiy =1;
        contr.currentPLI = li1;
        contr.add_rows();
        contr.displayMaterials[0].onlineContact.First_Name__c = 'Poorva';
        contr.displayMaterials[0].onlineContact.Last_Name__c = 'Sinha';
        contr.displayMaterials[0].onlineContact.Last_Name__c = 'Sinha';
        contr.displayMaterials[0].onlineContact.Tax_Type__c = 'Admin';
        contr.displayMaterials[0].onlineContact.Email__c = 'poo@gmail.com';
        contr.displayMaterials[0].onlineContact.Latam_Action__c = 'Add';
        
        contr.productsdropdown = li1.ID;
        PageReference pageRef1 = contr.saveRecordAndExit();       
       
      
        //Tax_APTS_OnlineContactsController.validateMinOCPresent();
        test.stopTest();
    }
    
    public static testmethod void taxUpdateAssetLineAfterPLIInsert_test(){
           LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
        id quoteSSD;
        
        WebServiceSettings__c webSettings=new WebServiceSettings__c(Name='TaxProfessional_OnlineContact',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings;
        WebServiceSettings__c webSettings1=new WebServiceSettings__c(Name='CreditCheck',Active__c=true,Endpoint__c='https://api.apigarden-qa.thomsonreuters.com/ebs/entitlement/uat/getEntitlements/ebs/entitlement/qa/getEntitlements',Password__c='esiggouser123',Username__c='esiggouser',Service_Unavailable_Message__c='Online Contact Service is unavailable',Timeout__c=120);
        insert webSettings1;
        
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
        
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='LatamGGOProductId';
        keyvaluestore1.TextValue__c='SF07';
        insert keyvaluestore1;
        
        
        List<RecordtypeIds__c> recordlist=new List<RecordtypeIds__c>();
        RecordtypeIds__c recordtype=new RecordtypeIds__c();
        recordtype.Name='Pre-Pipeline Opportunities';
        recordtype.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype);
        
        RecordtypeIds__c recordtype1=new RecordtypeIds__c();
        recordtype1.Name='Pipeline Opportunities';
        recordtype1.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype1);
        
        RecordtypeIds__c recordtype2=new RecordtypeIds__c();
        recordtype2.Name='GLI Pipeline Opportunity';
        recordtype2.recTypeId__c='01230000001MA4c';
        recordlist.add(recordtype2);
        
        insert recordlist;
         profile_list__c plist = new profile_list__c(name = 'Partner Portal User',Profile_Name__c='Partner Portal User',ProfileId__c = '00ea00000024JwaAAE');
        insert plist;
        
        Account a = APTS_TestDataFactory.createAccount('Testing Account');
        a.Customer_Group__c = 'Customer Class';
        insert a;
        system.debug('@@@@@@@@Account'+a);
        
        Contact cont=APTS_TestDataFactory.createContact('Kaur',a.id);
        cont.FirstName='Navpreet';
        cont.Email='abc@gmail.com';
        cont.Phone='9873337890';
        insert cont;
        system.debug('@@@@@@@@Contact'+cont);
        
        Id ssdRecorType=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName().get('LOTUS Source Systems').getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.RecordtypeId=ssdRecorType;
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=a.ID;
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='BEJE';
        accountSSD.Source_System_Account_Number__c='123647';
        insert accountSSD;
        
        Id opptyRecorType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        Opportunity oppty=APTS_TestDataFactory.createOpportunity('abc',a.id,'Needs Analysis',Date.Today());
        oppty.RecordtypeId=opptyRecorType;
        oppty.Source_System_Detail__c=accountSSD.id;
        oppty.Email__c='abc@tcs.com';
        //oppty.CurrencyIsoCode=opp;
        //oppty.ForecastCategory='Pipeline';
        // oppty.Key_Contact__c=cont.Id;
        oppty.Account=a;
        insert oppty;
        
        Apttus_Config2__PriceList__c pl= APTS_TestDataFactory.createPriceList('Test Price List 1');
        insert pl;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        system.debug('$$$$$$$'+accountSSD);
        Apttus_Proposal__Proposal__c proposal = APTS_TestDataFactory.createProposal(oppty.id,a.Id);
        proposal.Apttus_Proposal__Approval_Stage__c='Draft';
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.APTS_Proposal_Business_Unit__c='Tax Professional';
        proposal.RecordtypeId = propRecorType;
        // proposal.APTS_Flag_Recursive__c=true;
        proposal.Apttus_Proposal__Opportunity__c = oppty.id;
        proposal.CurrencyIsoCode = 'ARS';
        proposal.APTS_SSD_Sold_To__c = accountSSD.Id;
        proposal.Apttus_Proposal__Account__c = a.Id;
        proposal.Apttus_Proposal__Primary__c = true;
       // proposal.LATAM_APTS_Quote_Type__c = 'Upgrade/Downgrade';
        //proposal.LATAM_APTS_Boleto_Contact__c = cont.id;
       // proposal.LATAM_APTS_Payment_Method__c = null;
        insert proposal;  
        

        
        
        //List<onlineContactsSerialDeserial.onlineContact> oCDSList= new List<onlineContactsSerialDeserial.onlineContact>();
        onlineContactsSerialDeserial.onlineContact oContacts = new onlineContactsSerialDeserial.onlineContact();
        onlineContactsSerialDeserial.Address a1 = new onlineContactsSerialDeserial.Address();
        onlineContactsSerialDeserial.Account account1= new onlineContactsSerialDeserial.Account();
        onlineContactsSerialDeserial.EsiHeader esiHead= new onlineContactsSerialDeserial.EsiHeader();
        esiHead.applicationId='123456789';
        a1.firstName='ABCD';
        a1.lastName='EFGH'; 
        a1.emailAddress= 'ABCD.E.EFGH@GMAIL.COM';
        account1.accountNumber='12345678';
        
        List<onlineContactsSerialDeserial.Material> lstMaterial = new List<onlineContactsSerialDeserial.Material>();
        onlineContactsSerialDeserial.Material m = new onlineContactsSerialDeserial.Material();
        m.materialNumber = '767';
        m.materialDescription = 'Phone';
        lstMaterial.add(m);
        
        List<onlineContactsSerialDeserial.Assets> lstAssets = new List<onlineContactsSerialDeserial.Assets>();
        onlineContactsSerialDeserial.Assets asst = new onlineContactsSerialDeserial.Assets();
        asst.assetId = 'A-4978375';
        lstAssets.add(asst);
        
        List<onlineContactsSerialDeserial.Subscriptions > lstSub = new List<onlineContactsSerialDeserial.Subscriptions >();
        onlineContactsSerialDeserial.Subscriptions  s = new onlineContactsSerialDeserial.Subscriptions ();
        s.material = lstMaterial;
        s.assets = lstAssets;
        lstSub.add(s);
        
        List<onlineContactsSerialDeserial.Entitlements > lstEnt = new List<onlineContactsSerialDeserial.Entitlements >();
        onlineContactsSerialDeserial.Entitlements  e = new onlineContactsSerialDeserial.Entitlements ();
        e.subscriptions = lstSub;
        lstEnt.add(e);
        
        oContacts.contactNumber='0012409071';
        oContacts.address=a1;
        oContacts.account=account1;
        oContacts.entitlements = lstEnt;
        oContacts.onlineContactType='Admin';
        
        system.debug('Ram Test--->'+oContacts);
        string sortStr =a1.firstName;
        
        
        
        Apttus_Config2__ProductConfiguration__c config=APTS_TestDataFactory.createCart(a.Id, proposal.id,pl.id);
        insert config;
        
        List<Product2> productList =new List<Product2>();
        
           
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test',isActive=true, ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',Apttus_Filter_Media__c = 'Online');
        Product2 oProductP = new Product2(Name='Sreenu Product Test12',isActive=true, ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats', Apttus_Filter_Media__c = 'Online');
        insert oProductB;
        insert oProductP;
        
        List<Apttus_Config2__PriceListItem__c> ListPli= new  List<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pli= new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c=pl.id;
        pli.Apttus_Config2__ProductId__c=oProductB .id;
        pli.Apttus_Config2__ListPrice__c=200;
        ListPli.add(pli);
        
        
        Apttus_Config2__PriceListItem__c pli1= new Apttus_Config2__PriceListItem__c();
        pli1.Apttus_Config2__PriceListId__c=pl.id;
        pli1.Apttus_Config2__ProductId__c=oProductP .id;
        pli1.Apttus_Config2__ListPrice__c=100;
        ListPli.add(pli1);
        
        insert ListPli;
        
        Test.StartTest();
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, Apttus_QPConfig__PriceUom__c = 'Concurrent', APTS_Proposal_Business_Unit__c='Tax Professional');        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = proposal.Id, Apttus_QPConfig__Quantity2__c = 1, APTS_Proposal_Business_Unit__c='Tax Professional');
        listLineItems.add(li1);
        listLineItems.add(li2);
        insert listLineItems;   
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(APTS_Source_System_Detail__c=accountSSD.id,Material__c = oProductP.ProductCode,ProductId__c=oProductP.Id , QuoteId__c = proposal.Id, ContactID__c = cont.id, Is_Banded_Product__c = False, Account__c = a.Id, Latam_Action__c='Add',First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        insert onlineContactList;   
        
        
        Tax_APTS_OnlineContactsController.taxUpdateAssetLineAfterPLIInsert(listLineItems);
        Test.StopTest();
        
        
      }
      
     public static testmethod void tax_customIterableTest(){
     List<oncWrapper> oncWList= new List<oncWrapper>();
         oncWrapper onc= new oncWrapper();            
            onc.evnetIdToAdd = true;
            onc.isSelected = True;
            onc.materialNo = '12345';
            onc.isNewContact=true;
            onc.Action='Edit';
            onc.PrevAction='';
            onc.prevEmail='rama@tcs.com';
            onc.eventIdToDelete=false;
            onc.eventIdToEdit=true;
            onc.evnetIdToAdd=true;
            onc.eventIdToUndo=true;
            oncWList.add(onc);
        
        oncWrapper onc1 = new oncWrapper();        
            onc1.evnetIdToAdd = true;
            onc1.isSelected = True;
            onc1.materialNo = '12345';
            onc1.isNewContact=true;
            onc1.Action='Add';
            onc1.PrevAction='';
            onc1.prevEmail='sreenu.d@tcs.com';
            onc1.eventIdToDelete=true;
            onc1.eventIdToEdit=true;
            onc1.evnetIdToAdd=true;
            onc1.eventIdToUndo=true;
        oncWList.add(onc1);
        
        oncWrapper onc12 = new oncWrapper();        
            onc12.evnetIdToAdd = true;
            onc12.isSelected = True;
            onc12.materialNo = '12345';
            onc12.isNewContact=true;
            onc12.Action='Add';
            onc12.PrevAction='';
            onc12.prevEmail='sreenu.d@tcs.com';
            onc12.eventIdToDelete=true;
            onc12.eventIdToEdit=true;
            onc12.evnetIdToAdd=true;
            onc12.eventIdToUndo=true;
        oncWList.add(onc12);
        
        oncWrapper onc13 = new oncWrapper();        
            onc13.evnetIdToAdd = true;
            onc13.isSelected = True;
            onc13.materialNo = '12345';
            onc13.isNewContact=true;
            onc13.Action='Add';
            onc13.PrevAction='';
            onc13.prevEmail='sreenu.d@tcs.com';
            onc13.eventIdToDelete=true;
            onc13.eventIdToEdit=true;
            onc13.evnetIdToAdd=true;
            onc13.eventIdToUndo=true;
        oncWList.add(onc13);
        
        
        test.startTest();
         CustomIterable  obj = new CustomIterable (oncWList); 
         obj.setPageSize = 2;
         if(obj.hasNext())
             obj.next();
        obj.hasPrevious();
             obj.previous();             
        test.stopTest();
         
     }
}