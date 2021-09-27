@isTest
public class OnlineContactsController_Test {
    public static final string USL_RECORDTPYE='USL_Source_Systems'; 
     @testSetup private static void setUp(){
        List<Shipping_Method__c> shippingMethod=new List<Shipping_Method__c>{new Shipping_Method__c(name='Ground Shipping - U.S. Only',Value__c='01'),new Shipping_Method__c(name='International best Rate',Value__c='06')};     
        insert shippingMethod;
        List<MLAMediaLevelCode__c> mlaMedLevelCode=new List<MLAMediaLevelCode__c>{
        new MLAMediaLevelCode__c(Name='Code1',MLA_Media_High_Level_Code__c='06',MLA_Media_Lower_Level_Code__c='P7'),
        new MLAMediaLevelCode__c(Name='Code2',MLA_Media_High_Level_Code__c='13',MLA_Media_Lower_Level_Code__c='I9'),
        new MLAMediaLevelCode__c(Name='Code3',MLA_Media_High_Level_Code__c='06',MLA_Media_Lower_Level_Code__c='I9'),
        new MLAMediaLevelCode__c(Name='Code4',MLA_Media_High_Level_Code__c='07',MLA_Media_Lower_Level_Code__c='F4')
        };     
        insert mlaMedLevelCode;
        
        List<WebServiceSettings__c> lswebservicesettings=new List<WebServiceSettings__c>();
        WebServiceSettings__c ordSubSettings = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OrdersubmissionESI',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        lswebservicesettings.add(ordSubSettings) ;
        WebServiceSettings__c ordSubSettings1 = new WebServiceSettings__c(
        Active__c = true,
        Name = 'OnlineContacts',
        Service_Unavailable_Message__c = 'Service Not Available',        
        Endpoint__c = 'https://esi-qa.thomsonreuters.com/osb/LegalOrderCreationService/PS_LEGOrderCreation_REST');
        lswebservicesettings.add(ordSubSettings1) ;
        insert lswebservicesettings;
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
        List<KeyValueListStore__c> keyvaluestoreList=new List<KeyValueListStore__c>();
        KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c=System.Label.APTS_OC_Test_Id;
        KeyValueListStore__c keyvaluestore1=new  KeyValueListStore__c();
        keyvaluestore1.Name='OrderCaptureProductId';
        keyvaluestore1.TextValue__c=System.Label.APTS_OC_Test_Id;
        
        KeyValueListStore__c lCRMStrikeIronFlagINS1 = new KeyValueListStore__c();
        lCRMStrikeIronFlagINS1.Name='LCRMDisableStrikeIronServices';
        lCRMStrikeIronFlagINS1.TextValue__c='True';
        keyvaluestoreList.add(lCRMStrikeIronFlagINS1 );
        keyvaluestoreList.add(keyvaluestore);
        keyvaluestoreList.add(keyvaluestore1);
        KeyValueListStore__c keyval = new KeyValueListStore__c();
        keyval.Name='ReasonWithCompetitor';
        keyval.TextValue__c='Price';
        keyvaluestoreList.add(keyval);
        insert keyvaluestoreList;
    }   
    public static testMethod void processController() {
        User u = [select Id from User where Name = 'Informatica User' limit 1];
        system.runAs(u){
        
         Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');       
            insert oAccount;        
            //Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName('LOTUS Source Systems').get().getRecordTypeId();
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=oAccount.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='CARS';
            insert accountSSD;        
            /*source_system_detail__c source = APTS_TestDataFactory.createsourcesystem(oAccount );      
            insert source;*/        
                    
            //Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();     
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
            //Opp.RecordTypeId=oppRecordTypeId;     
            Opp.source_system_detail__c = accountSSD.Id;      
            insert opp;     
            
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id,APTS_SSD_Sold_To__c=accountSSD.id);  
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            Product2 oProductB = new Product2(Name='SMALL FIRM PACKAGE',APTS_Cat_L5__c =Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978965',
                                    Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',
                                    APTS_Media_High_Level_Code__c='21');      
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, Apttus_Filter_Brand_Code__c='64', 
                                                ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');     
            Product2 oProductPS = new Product2(Name='Test1',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, Apttus_Filter_Brand_Code__c='64', ProductCode = '235432', 
                                        APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');  
           // Product2 oProductA = new Product2(Name='Patron Product Test',APTS_Cat_L5__c =Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_Media_High_Level_Code__c='21');        
            List<Product2> prodlist = new List<Product2>{oProductB,oProductP,oProductPS};      
            insert prodlist;       
           // insert oProductA;     
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            //Anjana        
            Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c=5);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);       
            li1.Apttus_QPConfig__LineStatus__c='New';       
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);           
            listLineItems.add(li2);  
            Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductPS.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);           
            listLineItems.add(li3);  
            insert listLineItems;       
                    
        /* Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductA.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);        
          li3.Apttus_QPConfig__LineStatus__c='New';     
          listLineItems.add(li3);*/     
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0016762721', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0016762721',Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram',Position__c = 'Judge', Type__c= 'User', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);        
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);       
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);     
            onlineContactList.add(oc5);     
            Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductPS.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
            onlineContactList.add(oc6);
            for(Integer i=7;i<=1007;i++){
                Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductPS.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu'+i, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
                onlineContactList.add(oc);
            }
            for(Integer i=7;i<=1007;i++){
                Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);       
                onlineContactList.add(oc); 
            }
            insert onlineContactList; 
              
            /*List<OnlineContactsSerializeandDeserializeRes.onlineContact> testcov1 = new List<OnlineContactsSerializeandDeserializeRes.onlineContact>(); 
            OnlineContactsSerializeandDeserializeRes.onlineContact testcov2 = new OnlineContactsSerializeandDeserializeRes.onlineContact(); 
            testcov2.sourceId = 'test';
            testcov2.endDate = 'test';
            testcov2.contactNumber = '0012409071';
            testcov2.onlineContactType = 'test';
            testcov2.onlineContactTypeDescription = 'test';
            List<OnlineContactsSerializeandDeserializeRes.entitlements> testcov3 = new List<OnlineContactsSerializeandDeserializeRes.entitlements>(); 
            OnlineContactsSerializeandDeserializeRes.entitlements testcov4 = new OnlineContactsSerializeandDeserializeRes.entitlements(); 
            testcov4.statusReason = 'test';
            testcov4.accessStartDate = 'test';
            testcov4.appUserGuid = 'test';
            testcov4.accessEndDate = 'test';
            testcov4.applicationId = 'test';
            testcov4.status = 'test';*/
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);       
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;      
            contr.perSeatProducts = '235432';
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();     
            contr.displayMaterialContacts();        
                
             Test.startTest();
            
            //Added Content Document
               
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        
            /* Anjana*/     
            OnlineContactsController contr1= new OnlineContactsController(sc);      
            contr1.isBandedSelectAll = True;        
            contr1.isPerSheetSelectAll = True;  
            contr1.perSeatProducts = '235432';
            contr1.olContactsSize=0;        
            contr1.getpspSelectedPS();      
            contr1.getperSheetSelectedPS();             
            contr1.addOnlineContacts();     
            contr1.addNAPSContact();        
            contr1.displayMaterialContacts();       
            /*Anjana*/      
            for(OnlineContactsController.APLIWrapper apr :contr.lstbandedSetController) {       
                apr.isSelected = True;      
                break;      
            }    
            List<OnlineContactsController.APLIWrapper> invalidaddress=new List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apw: contr.totalbandedList ){
            apw.stremail='poonam@@@test.com';
            invalidaddress.add(apw);
            }
            contr.totalbandedList.clear();
            contr.totalbandedList.addAll(invalidaddress);
            contr.save();
            invalidaddress=new List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apw: contr.totalbandedList ){
            apw.stremail='poonam@test.com';
            invalidaddress.add(apw);
            }
            contr.totalbandedList.clear();
            contr.totalbandedList.addAll(invalidaddress);   
            contr.setBandedTab();
            contr.getlstbandedSetController();
            contr.validateBandedMaterials(); 
            contr.paramDigit=3;
            contr.OnclickDigit();   
            contr.gethasNext();
            contr.next();
            contr.pageNum = 30;
            contr.gethasprevious();
            contr.previous(); 
              
            contr.tabName='Per Seat Products'; 
            contr.OnclickDigit();          
            contr.save();       
           // contr.olContactsSize=null;      
            //contr.maxBandedProdQnt=2;       
                    
                    
    for(OnlineContactsController.APLIWrapper apr :contr.lstperSeatController) {     
                apr.isSelected = True;      
                apr.isNewContact = false;
                break;              
            }    
            
            contr.getpspSelected(); 
            contr.setBandedTab();
            contr.setPerseatTab(); 
            contr.copypscontacts();
            contr.getlstperSeatController();
            contr.paramDigit=1;
            contr.gethasNext();
            contr.next();
            contr.pageNum = 10;
            contr.gethasprevious();
            //contr.previous();
            contr.savePSContacts();     
            contr.addPSContacts();      
            contr.cancel();     
            contr.save();    
            invalidaddress=new List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apw: contr.lstperSeatController){
            apw.stremail='poonam@@@test.com';
            invalidaddress.add(apw);
            }
            contr.materialsmap.put(oProductPS.ProductCode,invalidaddress);
            contr.savePSContacts();  
            contr.materialsmap.clear(); 
            invalidaddress=new List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apw: contr.lstperSeatController){
            apw.stremail='poonam@test.com';
            invalidaddress.add(apw);
            }
            contr.materialsmap.put(oProductPS.ProductCode,invalidaddress);   
           contr.olContactsSize=null;      
            contr.maxBandedProdQnt=2.0;       
            system.assertEquals(oAccount.Name, 'Sree Test');   
            list<Online_Contacts__c > mOnlineContactList=new  list<Online_Contacts__c >();  
        for(Integer i=7;i<=100;i++){
                Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);       
                mOnlineContactList.add(oc); 
            }
            insert mOnlineContactList;    
            PageReference pageRef4 = Page.OnlineContacts;        
            pageRef4.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef4);       
            ApexPages.StandardController sc2 = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr4= new OnlineContactsController(sc2);     
            contr4.getbpSelected();      
            contr4.getBandedSelected();      
            contr4.isBandedSelectAll = True;  
            /*List<OnlineContactsController.APLIWrapper> invalidaddress=new List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apw: contr4.totalbandedList ){
            apw.stremail='poonam@@@test.com';
            invalidaddress.add(apw);
            }
            contr4.totalbandedList.clear();
            contr4.totalbandedList.addAll(invalidaddress);
            contr4.save();*/
             MOnlineContactList=new  list<Online_Contacts__c >(); 
            for(Integer i=7;i<=107;i++){
                Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductPS.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu'+i, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
                MOnlineContactList.add(oc);
            }
            
            insert MOnlineContactList;    
            ApexPages.StandardController sc3 = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr5= new OnlineContactsController(sc3);     
            contr5.getperSheetSelectedPS();      
            contr5.getpspSelectedPS();       
            contr5.isPerSheetSelectAll = True;      
            contr5.perSeatProducts = '235432';
            contr5.getpspSelectedPS();       
            contr5.getperSheetSelectedPS();      
             invalidaddress=new List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apw: contr4.totaldspmaterialsList){
            apw.stremail='poonam@@@test.com';
            invalidaddress.add(apw);
            }
            contr5.totaldspmaterialsList.clear();
            contr5.totaldspmaterialsList.addAll(invalidaddress);
            contr5.save(); 
        Test.stopTest();     
        }//end system.runas         
    }
    
    public static testMethod void processController_TK() {
    User u = [select Id from User where Name = 'Informatica User' limit 1];
    system.runAs(u){
    
     Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');       
        insert oAccount;        
        //Id accRecordTypeIdSSD=Schema.SObjectType.Source_System_Detail__c.getRecordTypeInfosByName('LOTUS Source Systems').get().getRecordTypeId();
        Source_System_Detail__c accountSSD= new Source_System_Detail__c();
        accountSSD.Name='ABC';
        accountSSD.Source_System_Name__c='ABC';
        accountSSD.Account_Name__c=oAccount.ID;
        accountSSD.LCRM_Customer_Group__c='Academic';
        accountSSD.Account_Inactive__c=false;
        accountSSD.LCRM_Sales_Org__c='CARS';
        insert accountSSD;        
        /*source_system_detail__c source = APTS_TestDataFactory.createsourcesystem(oAccount );      
        insert source;*/        
                
        //Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();     
                
        Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
        //Opp.RecordTypeId=oppRecordTypeId;     
        Opp.source_system_detail__c = accountSSD.Id;      
        insert opp;     
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id,APTS_SSD_Sold_To__c=accountSSD.id);  
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;       
                
        Product2 oProductB = new Product2(Name='SMALL FIRM PACKAGE',APTS_Cat_L5__c =Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978965',
                                Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',
                                APTS_Media_High_Level_Code__c='21');      
        Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, Apttus_Filter_Brand_Code__c='64', 
                                            ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');     
        Product2 oProductPS = new Product2(Name='Test1',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, Apttus_Filter_Brand_Code__c='64', ProductCode = '235432', 
                                    APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');  
       // Product2 oProductA = new Product2(Name='Patron Product Test',APTS_Cat_L5__c =Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys',APTS_Media_High_Level_Code__c='21');        
        List<Product2> prodlist = new List<Product2>{oProductB,oProductP,oProductPS};      
        insert prodlist;       
       // insert oProductA;     
                
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
        //Anjana        
        Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c=5);     
                
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);       
        li1.Apttus_QPConfig__LineStatus__c='New';       
        listLineItems.add(li1);     
                
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);           
        listLineItems.add(li2);  
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductPS.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);           
        listLineItems.add(li3);  
        insert listLineItems;       
                
    /* Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductA.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);        
      li3.Apttus_QPConfig__LineStatus__c='New';     
      listLineItems.add(li3);*/     
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0016762721', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
        onlineContactList.add(oc1);     
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0016762721',Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram',Position__c = 'Judge', Type__c= 'User', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);        
        onlineContactList.add(oc2);     
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
        onlineContactList.add(oc3);         
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);       
        onlineContactList.add(oc4);     
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);     
        onlineContactList.add(oc5);     
        Online_Contacts__c oc6 = new Online_Contacts__c(Material__c = oProductPS.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
        onlineContactList.add(oc6);
        for(Integer i=7;i<=1007;i++){
            Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductPS.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu'+i, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
            onlineContactList.add(oc);
        }
        for(Integer i=7;i<=1007;i++){
            Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);       
            onlineContactList.add(oc); 
        }
        insert onlineContactList; 

        
          
        /*List<OnlineContactsSerializeandDeserializeRes.onlineContact> testcov1 = new List<OnlineContactsSerializeandDeserializeRes.onlineContact>(); 
        OnlineContactsSerializeandDeserializeRes.onlineContact testcov2 = new OnlineContactsSerializeandDeserializeRes.onlineContact(); 
        testcov2.sourceId = 'test';
        testcov2.endDate = 'test';
        testcov2.contactNumber = '0012409071';
        testcov2.onlineContactType = 'test';
        testcov2.onlineContactTypeDescription = 'test';
        List<OnlineContactsSerializeandDeserializeRes.entitlements> testcov3 = new List<OnlineContactsSerializeandDeserializeRes.entitlements>(); 
        OnlineContactsSerializeandDeserializeRes.entitlements testcov4 = new OnlineContactsSerializeandDeserializeRes.entitlements(); 
        testcov4.statusReason = 'test';
        testcov4.accessStartDate = 'test';
        testcov4.appUserGuid = 'test';
        testcov4.accessEndDate = 'test';
        testcov4.applicationId = 'test';
        testcov4.status = 'test';*/
        PageReference pageRef = Page.OnlineContacts;        
        pageRef.getParameters().put('id', oProposal.Id);        
        Test.setCurrentPage(pageRef);       
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
        OnlineContactsController contr= new OnlineContactsController(sc);       
        contr.getbpSelected();      
        contr.getBandedSelected();      
        contr.isBandedSelectAll = True;     
        contr.getBandedSelected();              
        contr.getperSheetSelectedPS();      
        contr.getpspSelectedPS();       
        contr.isPerSheetSelectAll = True;      
        contr.perSeatProducts = '235432';
        contr.getpspSelectedPS();       
        contr.getperSheetSelectedPS();              
        contr.addOnlineContacts();      
        contr.addNAPSContact();     
        contr.displayMaterialContacts();        
            
         Test.startTest();       
        /* Anjana*/   
        
        //Added Content Document
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');        
        LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
        insert test2;

        ContentVersion cv = new ContentVersion();
           cv.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
           cv.PathOnClient = 'Demo.pdf'; // The files name, extension is very important here which will help the file in preview.
           cv.Title = 'signed Demo.pdf'; // Display name of the files
           cv.VersionData = beforeblob; // converting your binary string to Blog
           insert cv;
                        
           Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
    
           //Create ContentDocumentLink
           ContentDocumentLink cDe = new ContentDocumentLink();
           cDe.ContentDocumentId = conDoc;
           cDe.LinkedEntityId = oProposal.Id; // you can use objectId,GroupId etc
           cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
           insert cDe;
        
        
        OnlineContactsController contr1= new OnlineContactsController(sc);      
        contr1.isBandedSelectAll = True;        
        contr1.isPerSheetSelectAll = True;  
        contr1.perSeatProducts = '235432';
        contr1.olContactsSize=0;        
        contr1.getpspSelectedPS();      
        contr1.getperSheetSelectedPS();             
        contr1.addOnlineContacts();     
        contr1.addNAPSContact();        
        contr1.displayMaterialContacts();       
        /*Anjana*/      
        for(OnlineContactsController.APLIWrapper apr :contr.lstbandedSetController) {       
            apr.isSelected = True;      
            break;      
        }    
        List<OnlineContactsController.APLIWrapper> invalidaddress=new List<OnlineContactsController.APLIWrapper>();
        for(OnlineContactsController.APLIWrapper apw: contr.totalbandedList ){
        apw.stremail='poonam@@@test.com';
        invalidaddress.add(apw);
        }
        contr.totalbandedList.clear();
        contr.totalbandedList.addAll(invalidaddress);
        contr.save();
        invalidaddress=new List<OnlineContactsController.APLIWrapper>();
        for(OnlineContactsController.APLIWrapper apw: contr.totalbandedList ){
        apw.stremail='poonam@test.com';
        invalidaddress.add(apw);
        }
        contr.totalbandedList.clear();
        contr.totalbandedList.addAll(invalidaddress);   
        contr.setBandedTab();
        contr.getlstbandedSetController();
        contr.validateBandedMaterials(); 
        contr.paramDigit=3;
        contr.OnclickDigit();   
        contr.gethasNext();
        contr.next();
        contr.pageNum = 30;
        contr.gethasprevious();
        contr.previous(); 
          
        contr.tabName='Per Seat Products'; 
        contr.OnclickDigit();          
        contr.save();       
       // contr.olContactsSize=null;      
        //contr.maxBandedProdQnt=2;       
                
                
for(OnlineContactsController.APLIWrapper apr :contr.lstperSeatController) {     
            apr.isSelected = True;      
            apr.isNewContact = false;
            break;              
        }    
        
        contr.getpspSelected(); 
        contr.setBandedTab();
        contr.setPerseatTab(); 
        contr.copypscontacts();
        contr.getlstperSeatController();
        contr.paramDigit=1;
        contr.gethasNext();
        contr.next();
        contr.pageNum = 10;
        contr.gethasprevious();
        //contr.previous();
        contr.savePSContacts();     
        contr.addPSContacts();      
        contr.cancel();     
        contr.save();    
        invalidaddress=new List<OnlineContactsController.APLIWrapper>();
        for(OnlineContactsController.APLIWrapper apw: contr.lstperSeatController){
        apw.stremail='poonam@@@test.com';
        invalidaddress.add(apw);
        }
        contr.materialsmap.put(oProductPS.ProductCode,invalidaddress);
        contr.savePSContacts();  
        contr.materialsmap.clear(); 
        invalidaddress=new List<OnlineContactsController.APLIWrapper>();
        for(OnlineContactsController.APLIWrapper apw: contr.lstperSeatController){
        apw.stremail='poonam@test.com';
        invalidaddress.add(apw);
        }
        contr.materialsmap.put(oProductPS.ProductCode,invalidaddress);   
       contr.olContactsSize=null;      
        contr.maxBandedProdQnt=2.0;       
        system.assertEquals(oAccount.Name, 'Sree Test');   
        list<Online_Contacts__c > mOnlineContactList=new  list<Online_Contacts__c >();  
    for(Integer i=7;i<=100;i++){
            Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);       
            mOnlineContactList.add(oc); 
        }
        insert mOnlineContactList;    
        PageReference pageRef4 = Page.OnlineContacts;        
        pageRef4.getParameters().put('id', oProposal.Id);        
        Test.setCurrentPage(pageRef4);       
        ApexPages.StandardController sc2 = new ApexPages.StandardController(oProposal);      
        OnlineContactsController contr4= new OnlineContactsController(sc2);     
        contr4.getbpSelected();      
        contr4.getBandedSelected();      
        contr4.isBandedSelectAll = True;  
        /*List<OnlineContactsController.APLIWrapper> invalidaddress=new List<OnlineContactsController.APLIWrapper>();
        for(OnlineContactsController.APLIWrapper apw: contr4.totalbandedList ){
        apw.stremail='poonam@@@test.com';
        invalidaddress.add(apw);
        }
        contr4.totalbandedList.clear();
        contr4.totalbandedList.addAll(invalidaddress);
        contr4.save();*/
         MOnlineContactList=new  list<Online_Contacts__c >(); 
        for(Integer i=7;i<=107;i++){
            Online_Contacts__c oc = new Online_Contacts__c(Material__c = oProductPS.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu'+i, Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',APTS_Source_System_Detail__c =accountSSD.id);      
            MOnlineContactList.add(oc);
        }
        
        insert MOnlineContactList;    
        ApexPages.StandardController sc3 = new ApexPages.StandardController(oProposal);      
        OnlineContactsController contr5= new OnlineContactsController(sc3);     
        contr5.getperSheetSelectedPS();      
        contr5.getpspSelectedPS();       
        contr5.isPerSheetSelectAll = True;      
        contr5.perSeatProducts = '235432';
        contr5.getpspSelectedPS();       
        contr5.getperSheetSelectedPS();      
         invalidaddress=new List<OnlineContactsController.APLIWrapper>();
        for(OnlineContactsController.APLIWrapper apw: contr4.totaldspmaterialsList){
        apw.stremail='poonam@@@test.com';
        invalidaddress.add(apw);
        }
        contr5.totaldspmaterialsList.clear();
        contr5.totaldspmaterialsList.addAll(invalidaddress);
        contr5.save(); 
    Test.stopTest();     
    }//end system.runas         
}

            
    public static testMethod void processControllerMLA() {      
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){   
              
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
                    
            Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');       
            insert ssdAccount;      
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
            opp.source_system_detail__c = ssdAccount.Id;        
            insert opp;
            
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);   
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);       
            insert al;      
            
            list<Product2> listofProducts = new list<Product2>();
            Product2 oProductB = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978967',Apttus_Filter_Brand_Code__c='64', APTS_Media_High_Level_Code__c ='06',APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');     
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978968', Apttus_Filter_Brand_Code__c='124',APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c ='21', Apttus_Config2__Uom__c = 'Seats');  
            listofProducts.add(oProductB);
            listofProducts.add(oProductP);
            insert listofProducts;       
            
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
                        Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c=5);     
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);       
            li1.Apttus_QPConfig__LineStatus__c='New';       
            li1.APTS_Program_ID__c='CPRO';      
            li1.Apttus_QPConfig__LineType__c='Product/Service';     
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);       
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c =  oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc5);     
            insert onlineContactList;   
            
                
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);        
             Test.startTest();  
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();             
            contr.displayMaterialContacts();        
            contr.patronFlag = True;        
            contr.errorFlag = True;     
                    
                    
                    
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();       
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                //break;                
            }       
            contr.locationEvent();      
            contr.save();       
              contr.olContactsSize=0;       
            contr.maxBandedProdQnt=2;       
            contr.getpspSelected();  
            contr.savePSContacts();     
            contr.addPSContacts(); 
            List<OnlineContactsController.APLIWrapper> lswrapper=new  List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;   
                apr.strEmail ='';   
                lswrapper.add(apr);
                //break;                
            }     
            //Map<String, List<APLIWrapper>> materialsMap = new Map<String, List<APLIWrapper>>();
            contr.materialsMap.put(oProductB.ProductCode, lswrapper);
            contr.savePSContacts();      
            contr.cancel();     
            system.assertEquals(oAccount.Name, 'Sree Test');  
            test.stopTest();      
        }       
    }       
            
            
    public static testMethod void processController2() {        
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){
                     
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;  
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=oAccount.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='CARS';
            insert accountSSD;      
                    
            /*source_system_detail__c source = APTS_TestDataFactory.createsourcesystem(oAccount );      
insert source;*/        
                    
            //Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();     
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);  
            opp.Source_System_Detail__c=accountSSD.id;   
            //Opp.RecordTypeId=oppRecordTypeId;     
            //Opp.source_system_detail__c = source.Id;      
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);   
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            Product2 oProductB = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978965',APTS_Product_Pricing_Model__c='BENEFITGRP',APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');        
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978966',APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');       
            insert oProductB;       
            insert oProductP;       
            
            Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c=5);  
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li1.Apttus_QPConfig__LineStatus__c='New';       
            listLineItems.add(li1);     
                    
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);          
            li2.Apttus_QPConfig__LineStatus__c = 'Amended';     
            listLineItems.add(li2);     
            insert listLineItems;       
                    
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc5);     
            insert onlineContactList;       
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);       
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();     
            contr.displayMaterialContacts();        
            contr.olContactsSize=0;     
            contr.maxBandedProdQnt=2;       
            /* Anjana*/     
            OnlineContactsController contr1= new OnlineContactsController(sc);      
            contr1.isBandedSelectAll = True;        
            contr1.isPerSheetSelectAll = True;      
            contr1.getpspSelectedPS();      
            contr1.getperSheetSelectedPS();             
            contr1.addOnlineContacts();     
            contr1.addNAPSContact();        
            contr1.displayMaterialContacts();       
             Test.startTest();             
        
            /*Anjana*/      
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();       
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                break;              
            }       
            contr.getpspSelected();     
            contr.savePSContacts();     
            contr.addPSContacts();      
            contr.cancel();     
            system.assertEquals(oAccount.Name, 'Sree Test');  
            Test.stopTest();            
        }//end system.runas         
    }       
            
    public static testMethod void processControllerMLA2() {     
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){   
                 
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
                    
            Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');       
            insert ssdAccount;      
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
            opp.source_system_detail__c = ssdAccount.Id;        
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id); 
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);       
            insert al;      
                    
            Product2 oProductB = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978967',Apttus_Filter_Brand_Code__c='064', APTS_Media_High_Level_Code__c ='06',APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');        
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978968',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c ='21', Apttus_Config2__Uom__c = 'Seats');       
            insert oProductB;       
            insert oProductP;       
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li1.Apttus_QPConfig__LineStatus__c='New';       
            li1.APTS_Program_ID__c='CPRO';      
            li1.Apttus_QPConfig__LineType__c='Product/Service';     
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);      
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
            onlineContactList.add(oc5);     
            insert onlineContactList;       
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', '');      
            Test.setCurrentPage(pageRef);  
             Test.startTest(); 
             System.assertEquals(listLineItems .size(),2);
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);               
            /* contr.getbpSelected();       
contr.getBandedSelected();      
contr.isBandedSelectAll = True;     
contr.getBandedSelected();              
contr.getperSheetSelectedPS();      
contr.getpspSelectedPS();       
contr.isPerSheetSelectAll = True;       
contr.getpspSelectedPS();       
contr.getperSheetSelectedPS();              
contr.addOnlineContacts();      
contr.addNAPSContact();             
contr.displayMaterialContacts();        
contr.olContactsSize=0;     
contr.maxBandedProdQnt=2;               
for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
apr.isSelected = True;      
break;      
}       
contr.validateBandedMaterials();        
contr.save();       
for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
apr.isSelected = True;      
//break;                
}       
contr.locationEvent();      
contr.save();       
contr.getpspSelected();     
contr.savePSContacts();     
contr.addPSContacts();      
contr.cancel();     
system.assertEquals(oAccount.Name, 'Sree Test');*/  
Test.stopTest();    
        }       
    }       
            
    public static testMethod void processControllerException() {        
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){ 
                 
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
                    
            Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');       
            insert ssdAccount;      
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
            opp.source_system_detail__c = ssdAccount.Id;        
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id); 
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'Existing', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);      
            insert al;      
                    
            Product2 oProductB = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978967',Apttus_Filter_Brand_Code__c='064', APTS_Media_High_Level_Code__c ='06',APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');        
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c ='21', Apttus_Config2__Uom__c = 'Seats');     
            insert oProductB;       
            insert oProductP;       
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li1.Apttus_QPConfig__LineStatus__c='New';       
            li1.APTS_Program_ID__c='CPRO';      
            li1.Apttus_QPConfig__LineType__c='Product/Service';     
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);      
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
            onlineContactList.add(oc5);     
            insert onlineContactList;       
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', opp.id);      
            Test.setCurrentPage(pageRef);  
             Test.startTest();  
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);               
            /* contr.getbpSelected();       
contr.getBandedSelected();      
contr.isBandedSelectAll = True;     
contr.getBandedSelected();              
contr.getperSheetSelectedPS();      
contr.getpspSelectedPS();       
contr.isPerSheetSelectAll = True;       
contr.getpspSelectedPS();       
contr.getperSheetSelectedPS();              
contr.addOnlineContacts();      
contr.addNAPSContact();             
contr.displayMaterialContacts();            
for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
apr.isSelected = True;      
break;      
}       
contr.validateBandedMaterials();        
contr.save();       
for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
apr.isSelected = True;      
//break;                
}       
contr.locationEvent();      
contr.save();       
contr.getpspSelected();     
contr.savePSContacts();     
contr.addPSContacts();      
contr.cancel();     
system.assertEquals(oAccount.Name, 'Sree Test');*/   
System.assertEquals(listLineItems .size(),2);
       Test.stopTest();   
        }       
    }       
            
    public static testMethod void processControllerMLA3() {     
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){  
                 
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
                    
            Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');       
            insert ssdAccount;      
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
            opp.source_system_detail__c = ssdAccount.Id;        
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);  
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);       
            insert al;      
            //APTS_Quote_Agreement_Locations__c al1= new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'Existing', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);        
            //insert al1;       
                    
            Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978967',Apttus_Filter_Brand_Code__c='064',APTS_Media_High_Level_Code__c ='13',APTS_Media_Lower_Level_Code__c = 'PS', Apttus_Config2__Uom__c = 'Attorneys');     
            Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', APTS_Media_High_Level_Code__c ='21', Apttus_Config2__Uom__c = 'Seats');     
            insert oProductB;       
            insert oProductP;       
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li1.Apttus_QPConfig__LineStatus__c='Amended';       
            li1.APTS_Program_ID__c='CPRO';      
            li1.Apttus_QPConfig__LineType__c='Product/Service';     
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li2.APTS_Program_ID__c='CPRO';      
            li2.Apttus_QPConfig__LineType__c='Product/Service';     
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
            onlineContactList.add(oc5);     
            insert onlineContactList;       
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);   
            Test.startTest();   
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();             
            contr.displayMaterialContacts();        
            contr.olContactsSize=0;     
            contr.maxBandedProdQnt=2;           
                    
                    
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();       
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                //break;                
            }  
              
            contr.locationEvent();      
            contr.save();       
              contr.olContactsSize=0;       
            contr.maxBandedProdQnt=2;       
            contr.getpspSelected();     
            contr.savePSContacts();     
            contr.addPSContacts();      
            contr.cancel();     
            system.assertEquals(oAccount.Name, 'Sree Test');    
            Test.stopTest();            
        }       
    }               
            
    public static testMethod void processController3() {        
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){        
           
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
              
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=oAccount.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='CARS';
            insert accountSSD;         
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id); 
            opp.source_system_detail__c  =accountSSD.id;          
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id); 
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'PS',APTS_Media_High_Level_Code__c ='13', Apttus_Config2__Uom__c = 'Attorneys');        
            Product2 oProductP = new Product2(Name='Sreenu Product Test',ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');       
            insert oProductB;       
            insert oProductP;       
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li1.Apttus_QPConfig__LineStatus__c='New';       
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);          
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
            onlineContactList.add(oc5);     
            insert onlineContactList;       
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);       
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();     
            contr.displayMaterialContacts();        
            contr.olContactsSize=0;     
            contr.maxBandedProdQnt=2;       
            /* Anjana*/     
            OnlineContactsController contr1= new OnlineContactsController(sc);      
            contr1.isBandedSelectAll = True;        
            contr1.isPerSheetSelectAll = True;      
            contr1.olContactsSize=0;        
            contr1.maxBandedProdQnt=2;      
            contr1.getpspSelectedPS();      
            contr1.getperSheetSelectedPS();             
            contr1.addOnlineContacts();     
            contr1.addNAPSContact();        
            contr1.displayMaterialContacts();       
            /*Anjana*/    
             Test.startTest();
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();       
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                break;              
            }       
            contr.getpspSelected();     
            contr.savePSContacts();     
            contr.addPSContacts();      
            contr.cancel();     
            system.assertEquals(oAccount.Name, 'Sree Test');
            Test.stopTest();            
        }//end system.runas         
    }       
    public static testMethod void processControllerNew() {      
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){
                 
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=oAccount.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='CARS';
            accountSSD.OLC_Account_Number__c='1234'; 
            insert accountSSD;         
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id); 
            opp.source_system_detail__c  =accountSSD.id; 
            opp.Active_Trial__c =true;
            /*source_system_detail__c source = APTS_TestDataFactory.createsourcesystem(oAccount );      
insert source;*/        
                    
            //Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();     
                    
                
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);   
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            Product2 oProductB = new Product2(Name='Patron Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');        
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, Apttus_Filter_Brand_Code__c='64', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');        
            insert oProductB;       
            insert oProductP;       
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);      
            li1.Apttus_QPConfig__LineStatus__c='New';       
                
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);          
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            /* List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();         
Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
onlineContactList.add(oc1);     
Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
onlineContactList.add(oc2);     
Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
onlineContactList.add(oc3);         
Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
onlineContactList.add(oc4);     
Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
onlineContactList.add(oc5);     
insert onlineContactList;*/     
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);       
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = false;        
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();     
            contr.displayMaterialContacts();        
                    
                    
                    
            /* Anjana*/     
            OnlineContactsController contr1= new OnlineContactsController(sc);      
            contr1.isBandedSelectAll = True;        
            contr1.isPerSheetSelectAll = True;      
            contr1.olContactsSize=0;        
            contr1.getpspSelectedPS();      
            contr1.getperSheetSelectedPS();             
            contr1.addOnlineContacts();     
            contr1.addNAPSContact();        
            contr1.displayMaterialContacts();       
            /*Anjana*/      
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();  
            Test.startTest();    
                    
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                        
            break;              
            }       
            contr.getpspSelected();     
            contr.savePSContacts();     
                    
            contr.olContactsSize=0;     
            contr.maxBandedProdQnt=3;       
            contr.save();       
            contr.addPSContacts();      
            contr.cancel();     
            system.assertEquals(oAccount.Name, 'Sree Test'); 
            Test.stopTest();            
        }//end system.runas         
    }       
            
            
    public static testMethod void processControllerCanada() { 
           
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){        
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
            Source_System_Detail__c accountSSD= new Source_System_Detail__c();
            accountSSD.Name='ABC';
            accountSSD.Source_System_Name__c='ABC';
            accountSSD.Account_Name__c=oAccount.ID;
            accountSSD.LCRM_Customer_Group__c='Academic';
            accountSSD.Account_Inactive__c=false;
            accountSSD.LCRM_Sales_Org__c='CARS';
            insert accountSSD;         
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id); 
            opp.source_system_detail__c  =accountSSD.id;     
            //Opp.RecordTypeId=oppRecordTypeId;     
            //Opp.source_system_detail__c = source.Id;      
            insert opp;     
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);  
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            Product2 oProductB = new Product2(Name='Patron',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family ,APTS_Product_Pricing_Model__c='BENEFITGRP', ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_High_Level_Code__c  = '06', APTS_Media_Lower_Level_Code__c = 'AB', Apttus_Config2__Uom__c = 'Attorneys');     
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family ,APTS_Product_Pricing_Model__c='BENEFITGRP',Apttus_Filter_Brand_Code__c='64', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'AB',APTS_Media_High_Level_Code__c  = '21', Apttus_Config2__Uom__c = 'Seats');       
            insert oProductB;       
            insert oProductP;       
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5 , Apttus_Proposal__Proposal__c = oProposal.Id);     
            li1.Apttus_QPConfig__LineStatus__c='New';       
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5,Apttus_Proposal__Proposal__c = oProposal.Id);           
            listLineItems.add(li2);     
            insert listLineItems;       
                    
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram',Position__c = 'Judge', Type__c= 'User', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');       
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
            onlineContactList.add(oc5);     
            insert onlineContactList;       
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);  
            Test.startTest();   
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();     
            contr.displayMaterialContacts();        
            contr.patronFlag = False;       
            contr.isLiveNoteBandedProduct = True;       
                    
        
            /* Anjana*/     
            OnlineContactsController contr1= new OnlineContactsController(sc);      
            contr1.isBandedSelectAll = True;        
            contr1.isPerSheetSelectAll = True;      
            contr1.olContactsSize=0;        
            contr1.getpspSelectedPS();      
            contr1.getperSheetSelectedPS();             
            contr1.addOnlineContacts();     
            contr1.addNAPSContact();        
            contr1.displayMaterialContacts();       
                        
        
            /*Anjana*/      
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();       
                
                               
for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                break;              
            }       
            contr.getpspSelected();     
            contr.savePSContacts();     
            contr.addPSContacts();      
            contr.cancel();     
            contr.save();       
            contr.olContactsSize=null;      
            contr.maxBandedProdQnt=3;       
            system.assertEquals(oAccount.Name, 'Sree Test'); 
            Test.stopTest();            
        }//end system.runas         
    }       
    public static testMethod void processController4() {        
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){
           
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        /*source_system_detail__c source = APTS_TestDataFactory.createsourcesystem(oAccount );
        insert source;*/
        Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');         
        insert ssdAccount;
        //Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GLI Pipeline Opportunity').getRecordTypeId();
        
        Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
        //Opp.RecordTypeId=oppRecordTypeId;
        opp.source_system_detail__c = ssdAccount.Id;
        insert opp;
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id,APTS_MLA_Quote__c = True, Apttus_Proposal__Opportunity__c = opp.Id);
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;
         APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);             
        insert al;
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family , ProductCode = '1234568978965',Apttus_Filter_Brand_Code__c='064', APTS_Media_Lower_Level_Code__c = 'LO',APTS_Media_High_Level_Code__c ='06',
        // APTS_Media_Lower_Level_Code__c = 'WA', 
        Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test',Apttus_Filter_Brand_Code__c='64',APTS_Cat_L5__c=Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        insert oProductB;
        insert oProductP;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        li1.Apttus_QPConfig__LineStatus__c='New';
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems; 
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        Online_Contacts__c oc5 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = '', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');        
        onlineContactList.add(oc5);
        insert onlineContactList;
        PageReference pageRef = Page.OnlineContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        OnlineContactsController contr= new OnlineContactsController(sc);
         Test.startTest();
        contr.getbpSelected();
        contr.getBandedSelected();
        contr.isBandedSelectAll = True;
        contr.getBandedSelected();        
        contr.getperSheetSelectedPS();
        contr.getpspSelectedPS();
        contr.isPerSheetSelectAll = True;
        contr.getpspSelectedPS();
        contr.getperSheetSelectedPS();        
        contr.addOnlineContacts();
        contr.addNAPSContact();
        contr.displayMaterialContacts();
        contr.olContactsSize=0;        
            contr.maxBandedProdQnt=2;       
            /* Anjana*/     
        OnlineContactsController contr1= new OnlineContactsController(sc);      
            contr1.isBandedSelectAll = True;        
            contr1.isPerSheetSelectAll = True;      
            contr1.olContactsSize=0;        
            contr1.getpspSelectedPS();      
            contr1.getperSheetSelectedPS();             
            contr1.addOnlineContacts();     
            contr1.addNAPSContact();        
            contr1.displayMaterialContacts();       
                       /*Anjana*/
        for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {
            apr.isSelected = True;
            break;
        }
        
        contr.validateBandedMaterials();
        contr.save();
        for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {
        apr.isSelected = True;
        break;        
        }
        contr.getpspSelected();
        contr.savePSContacts();
        contr.addPSContacts();
        contr.cancel();
        system.assertEquals(oAccount.Name, 'Sree Test');
        Test.stopTest();
        }//end system.runas 
        }
        
    public static testMethod void processControllerMLAInfo() {
        User u = [select Id from User where Name = 'Informatica User' limit 1];
        system.runAs(u){
           
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West'); 
        ssdAccount.OLC_Account_Number__c='1328';
        insert ssdAccount;
        
        Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
        opp.Active_Trial__c=true;
        opp.source_system_detail__c = ssdAccount.Id;
        insert opp;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;
        
        APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);
        insert al;
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats');
        insert oProductB;
        insert oProductP;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems; 
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        insert onlineContactList;
        PageReference pageRef = Page.OnlineContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        OnlineContactsController contr= new OnlineContactsController(sc);        
        contr.getbpSelected();
        contr.getBandedSelected();
        contr.isBandedSelectAll = True;
        contr.getBandedSelected();        
        contr.getperSheetSelectedPS();
        contr.getpspSelectedPS();
        contr.isPerSheetSelectAll = True;
        contr.getpspSelectedPS();
        contr.getperSheetSelectedPS();        
        contr.addOnlineContacts();
        contr.addNAPSContact();        
        contr.displayMaterialContacts();       
        
         Test.startTest();
        for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {
            apr.isSelected = True;
            break;
        }
        contr.validateBandedMaterials();
        contr.save();
        for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {
        apr.isSelected = True;
        //break;        
        }
        contr.locationEvent();
        contr.save();
        contr.getpspSelected();
        contr.savePSContacts();
        contr.addPSContacts();
        contr.cancel();
        system.assertEquals(oAccount.Name, 'Sree Test');
        Test.stopTest();
        }}
        
        public static testMethod void odenprocessControllerMLA() {
        User u = [select Id from User where Name = 'Informatica User' limit 1];
        system.runAs(u){
           
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West'); 
        insert ssdAccount;
        
        Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
        opp.source_system_detail__c = ssdAccount.Id;
        insert opp;
        
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;
        
        APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);
        insert al;
        
        list<Product2> listofproducts = new list<Product2>();
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'NT', APTS_Media_High_Level_Code__c = '13', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'NX', APTS_Media_High_Level_Code__c = '13',Apttus_Config2__Uom__c = 'Seats');
        Product2 oProductO = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978962', APTS_Media_Lower_Level_Code__c = 'NZ', APTS_Media_High_Level_Code__c = '05',Apttus_Config2__Uom__c = 'Seats');
        //Product2 oProductPS = new Product2(Name='Sreenu Product Test1', ProductCode = '1234568978962', APTS_Media_Lower_Level_Code__c = 'AB', APTS_Media_High_Level_Code__c = '06',Apttus_Config2__Uom__c = 'Seats');
        listofproducts.add(oProductB);
        listofproducts.add(oProductP);
        //listofproducts.add(oProductPS);
        listofproducts.add(oProductO);
        insert listofproducts;
        //insert oProductP;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        
        Apttus_Proposal__Proposal_Line_Item__c li3 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductO.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id, APTS_Program_ID__c = 'CPRO', Apttus_QPConfig__LineType__c = 'Product/Service');
        listLineItems.add(li3);
        
        /*Apttus_Proposal__Proposal_Line_Item__c li4 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductPS.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id, APTS_Program_ID__c = 'CPRO', Apttus_QPConfig__LineType__c = 'Product/Service');
        listLineItems.add(li4);*/
        insert listLineItems; 
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',NAIC_Number__c ='12345', NAIC_Name__c = 'Abc');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',NAIC_Number__c ='12345', NAIC_Name__c = 'Abc');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana',NAIC_Number__c ='12345', NAIC_Name__c = 'Abc', APTS_Source_System_Detail__c =ssdAccount.Id);
        onlineContactList.add(oc3); 
        //Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        //onlineContactList.add(oc4);
        insert onlineContactList;
        PageReference pageRef = Page.OnlineContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        OnlineContactsController contr= new OnlineContactsController(sc);        
        contr.getbpSelected();
        contr.getBandedSelected();
        contr.isBandedSelectAll = True;
        contr.getBandedSelected();        
        contr.getodenSelectedOD();
        contr.isodenSelectAll = True;
        contr.getodenSelectedOD();          
        contr.displayMaterialContacts();       
        
         Test.startTest();
        for(OnlineContactsController.APLIWrapper apr :contr.oddspMaterials) {
        apr.isSelected = True;
        apr.evnetIdToAdd = True;
        }
        contr.addrows();
        contr.setNAICTab();
        contr.locationEvent();
        contr.save();
        contr.getpspSelected();
        contr.savePSContacts();
        contr.cancel();
        system.assertEquals(oAccount.Name, 'Sree Test');
        Test.stopTest();
        }
        }
        
        
        //}
        
    public static testMethod void digitalprocessController() {
         User u = [select Id from User where Name = 'Informatica User' limit 1];
        system.runAs(u){
        
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West'); 
        insert ssdAccount;
        
        Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
        opp.isDigitalSpearHead__c = TRUE;
        opp.source_system_detail__c = ssdAccount.Id;
        insert opp;
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978965', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978966', APTS_Media_Lower_Level_Code__c = 'LO', Apttus_Config2__Uom__c = 'Seats');
        insert oProductB;
        insert oProductP;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems; 
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        insert onlineContactList;
        PageReference pageRef = Page.OnlineContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_OnlineContactsController contr= new Digital_OnlineContactsController(sc);
        contr.getbpSelected();
        contr.getBandedSelected();
        contr.isBandedSelectAll = True;
        contr.getBandedSelected();        
        contr.getperSheetSelectedPS();
        contr.getpspSelectedPS();
        contr.isPerSheetSelectAll = True;
        contr.getpspSelectedPS();
        contr.getperSheetSelectedPS();        
        contr.addOnlineContacts();
        contr.addNAPSContact();
        System.debug('contr.dspMaterials >>1'+contr.dspMaterials);
        
        //Digital_MasterContactsBatch dm = new Digital_MasterContactsBatch();
        //Database.executeBatch(dm,1);
        
        //Digital_PasswordHoldersBatch dphb = new Digital_PasswordHoldersBatch();        
        //Database.executeBatch(dphb,1);
        System.debug('contr.dspMaterials >>2'+contr.dspMaterials);
        Test.startTest();
        contr.displayMaterialContacts();
        for(Digital_OnlineContactsController.APLIWrapper apr :contr.totalbandedList) {
            //apr.isSelected = True;
            break;
        }
        contr.validateBandedMaterials();
        contr.save();
        for(Digital_OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {
        apr.isSelected = True;
        break;        
        }
        
        contr.getpspSelected();
        contr.savePSContacts();
        contr.addPSContacts();
        contr.cancel();
        system.assertEquals(oAccount.Name, 'Sree Test');
        Test.stopTest();
        }//end system.runas
        }
        
        
    public static testMethod void onlineGLP() {      
        User u = [select Id from User where Name = 'Informatica User' limit 1];     
        system.runAs(u){   
              
            Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');        
            insert oAccount;        
                    
            Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West');       
            insert ssdAccount;      
                    
            Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);     
            opp.source_system_detail__c = ssdAccount.Id;        
            insert opp;
            
            Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();        
            Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp.Id);   
            oProposal.RecordtypeId=propRecorType;
            insert oProposal;       
                    
            APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);       
            insert al;      
            
            list<Product2> listofProducts = new list<Product2>();
            Product2 oProductB = new Product2(Name='Sreenu Product Test',ProductCode = '1234568978967', APTS_Media_High_Level_Code__c ='21',APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats');     
            Product2 oProductP = new Product2(Name='Sreenu Product Test',APTS_Cat_L5__c = Label.APTS_GSCPW_RP_Product_Family, ProductCode = '1234568978968', Apttus_Filter_Brand_Code__c='124',APTS_Media_Lower_Level_Code__c = 'CQ', APTS_Media_High_Level_Code__c ='21', Apttus_Config2__Uom__c = 'Attorney');  
            listofProducts.add(oProductB);
            listofProducts.add(oProductP);
            insert listofProducts;       
            
                    
            list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();        
                        Apttus_QPConfig__ProposalProductAttributeValue__c ob = new Apttus_QPConfig__ProposalProductAttributeValue__c(APTS_Priced_Number_of_Attorneys__c=5);     
            Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);       
            li1.Apttus_QPConfig__LineStatus__c='New';       
            li1.APTS_Program_ID__c='CPRO';    
            li1.Apttus_QPConfig__Quantity2__c  =10;
            li1.Apttus_QPConfig__LineType__c='Product/Service';     
            listLineItems.add(li1);     
                    
            Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, Apttus_QPConfig__Quantity2__c  =10, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id,Apttus_QPConfig__AttributeValueId__c=ob.id);       
            listLineItems.add(li2);     
            insert listLineItems;       
                    
            List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();        
            Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc1);     
            Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc2);     
            Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc3);         
            Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');      
            onlineContactList.add(oc4);     
            Online_Contacts__c oc5 = new Online_Contacts__c(Material__c =  oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');     
            onlineContactList.add(oc5);     
            insert onlineContactList;   
            
                
            PageReference pageRef = Page.OnlineContacts;        
            pageRef.getParameters().put('id', oProposal.Id);        
            Test.setCurrentPage(pageRef);       
            ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);      
            OnlineContactsController contr= new OnlineContactsController(sc);        
             Test.startTest();  
            contr.getbpSelected();      
            contr.getBandedSelected();      
            contr.isBandedSelectAll = True;     
            contr.getBandedSelected();              
            contr.getperSheetSelectedPS();      
            contr.getpspSelectedPS();       
            contr.isPerSheetSelectAll = True;       
            contr.getpspSelectedPS();       
            contr.getperSheetSelectedPS();              
            contr.addOnlineContacts();      
            contr.addNAPSContact();             
            contr.displayMaterialContacts();        
            contr.patronFlag = True;        
            contr.errorFlag = True;     
                    
                    
                    
            for(OnlineContactsController.APLIWrapper apr :contr.totalBandedList) {       
                apr.isSelected = True;      
                break;      
            }       
            contr.validateBandedMaterials();        
            contr.save();       
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;      
                //break;                
            }       
            contr.locationEvent();      
            contr.save();       
              contr.olContactsSize=0;       
            contr.maxBandedProdQnt=2;       
            contr.getpspSelected();  
            contr.savePSContacts();     
            contr.addPSContacts(); 
            List<OnlineContactsController.APLIWrapper> lswrapper=new  List<OnlineContactsController.APLIWrapper>();
            for(OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {     
                apr.isSelected = True;   
                apr.strEmail ='';   
                lswrapper.add(apr);
                //break;                
            }     
            //Map<String, List<APLIWrapper>> materialsMap = new Map<String, List<APLIWrapper>>();
            contr.materialsMap.put(oProductB.ProductCode, lswrapper);
            contr.savePSContacts();      
            contr.cancel();     
            system.assertEquals(oAccount.Name, 'Sree Test');  
            test.stopTest();      
        }       
    } 
    
    public static testMethod void digitalprocessControllerMLA() {
         User u = [select Id from User where Name = 'Informatica User' limit 1];
        system.runAs(u){
         
        Account oAccount = new Account(Name='Sree Test', BillingCountry ='US', BillingState='IL', BillingPostalCode = '60603-3801', Tax_Number__c= '12345');
        insert oAccount; 
        
        Source_system_detail__c ssdAccount = new Source_system_detail__c (Account_Name__c = oAccount.id,Name=oAccount.name,Source_System_Name__c=oAccount.name,LCRM_Sales_Org__c='West'); 
        insert ssdAccount;
        
        Opportunity opp = UnitTest.getOpportunityInstance(oAccount.Id);
        opp .isDigitalSpearHead__c = TRUE;
        opp .source_system_detail__c = ssdAccount.Id;
        insert opp ;
        Id propRecorType=Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        Apttus_Proposal__Proposal__c oProposal = New Apttus_Proposal__Proposal__c(APTS_MLA_Quote__c = True, Apttus_Proposal__Proposal_Name__c ='Sreenu Proposal Test', Apttus_Proposal__Account__c = oAccount.Id, Apttus_Proposal__Opportunity__c = opp .Id);
        oProposal.RecordtypeId=propRecorType;
        insert oProposal;
        APTS_Quote_Agreement_Locations__c al = new APTS_Quote_Agreement_Locations__c(Name = 'Sreenu Test', APTS_Quote_Proposal__c = oProposal.Id, APTS_Status__c = 'New', APTS_Subscriber_Location__c = oAccount.Id, APTS_Subscriber_Location_SSD__c= ssdAccount.id);
        insert al;
        
        Product2 oProductB = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978967', APTS_Media_Lower_Level_Code__c = 'WA', Apttus_Config2__Uom__c = 'Attorneys');
        Product2 oProductP = new Product2(Name='Sreenu Product Test', ProductCode = '1234568978968', APTS_Media_Lower_Level_Code__c = 'ST', Apttus_Config2__Uom__c = 'Seats');
        insert oProductB;
        insert oProductP;
        
        list<Apttus_Proposal__Proposal_Line_Item__c> listLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c li1 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductB.Id, APTS_Number_of_Attorneys__c = 5, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li1);
        
        Apttus_Proposal__Proposal_Line_Item__c li2 = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Product__c = oProductP.Id, APTS_Number_of_Attorneys__c = 1, Apttus_Proposal__Proposal__c = oProposal.Id);
        listLineItems.add(li2);
        insert listLineItems; 
        
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();  
        Online_Contacts__c oc1 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id, ContactID__c = '0012409071', Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc1);
        Online_Contacts__c oc2 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  ContactID__c = '0012409071', Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc2);
        Online_Contacts__c oc3 = new Online_Contacts__c(Material__c = oProductP.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = False, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc3); 
        Online_Contacts__c oc4 = new Online_Contacts__c(Material__c = oProductB.ProductCode,QuoteId__c = oProposal.Id,  Is_Banded_Product__c = True, Account__c = oAccount.Id, First_Name__c = 'Sreenu', Middle_Name__c = 'SD', Last_Name__c = 'Daram', Email__c = 'sreenu.d@tcs.com', Position__c = 'Judge', Type__c= 'Admin', Sftwr_Admin__c = True, WLEc_Juris__c ='Indiana');
        onlineContactList.add(oc4);
        insert onlineContactList;
        
        PageReference pageRef = Page.OnlineContacts;
        pageRef.getParameters().put('id', oProposal.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oProposal);
        Digital_OnlineContactsController dcon = new Digital_OnlineContactsController();
        Digital_OnlineContactsController contr= new Digital_OnlineContactsController(sc); 
         Test.startTest();       
        contr.getbpSelected();
        contr.getBandedSelected();
        contr.isBandedSelectAll = True;
        contr.getBandedSelected();        
        contr.getperSheetSelectedPS();
        contr.getpspSelectedPS();
        contr.isPerSheetSelectAll = True;
        contr.getpspSelectedPS();
        contr.getperSheetSelectedPS();        
        contr.addOnlineContacts();
        contr.addNAPSContact();
        contr.displayMaterialContacts();      
        
        
        for(Digital_OnlineContactsController.APLIWrapper apr :contr.totalbandedList) {
            apr.isSelected = True;
            break;
        }
        contr.validateBandedMaterials();
        contr.save();
        for(Digital_OnlineContactsController.APLIWrapper apr :contr.dspMaterials) {
        apr.isSelected = True;
        //break;        
        }
          
        contr.locationEvent();
        contr.save();
        contr.getpspSelected();
        contr.savePSContacts();
        contr.addPSContacts();
        contr.cancel();
        system.assertEquals(oAccount.Name, 'Sree Test');       
        
        Customer_Master_Contacts__c mc = new Customer_Master_Contacts__c();
        mc.quote__C = oProposal.id;
        mc.First_Name__c = 'testfirstname';
        mc.Last_Name__c = 'teslastname';
        mc.Email_Address__c = 'test.test@gmail.com';
        insert mc; 
        Test.stopTest();
        //Digital_PasswordHoldersBatch dphb = new Digital_PasswordHoldersBatch();        
        //Database.executeBatch(dphb,1); 
        }
        }//end runAs
        
   }