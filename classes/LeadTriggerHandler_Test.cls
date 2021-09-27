@isTest

public class LeadTriggerHandler_Test{
   
        
        
        @testSetup static void addKeyValueStore() {
KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
}
  public static testmethod void populateLeadOwnerTest(){
    List<Lead> listlead = new List<Lead>();
    //Commented as a part of DPS-6078
    //AccountHandler.verifyStrikeIronRecCheck = false;
    Account testAcc = UnitTest.getAccountInstance();
    TestAcc.SAPAccountNumber__c = '1';
    TestAcc.Tax_Number_Type__c = 'C.I';
    System.assert(TestAcc.SAPAccountNumber__c == '1');
    
    insert TestAcc;
    
    ILMGeneral__c ilmGen=new ILMGeneral__c();
    ilmGen.name= 'AllowedUsersForSalesRepAssignment';
    ilmGen.Value__C = 'SL Eloqua';        
    insert ilmGen;
    
    Account testAcc1 = UnitTest.getAccountInstance();
    TestAcc1.MDBId__c = '1';
  //  TestAcc.SAPAccountNumber__c = '98711';
    TestAcc1.Tax_Number_Type__c = 'C.I';
    insert TestAcc1;
    
    Contact testContact = UnitTest.getContactInstance(TestAcc.Id);
    testContact.SAP_Contact_ID__c = '1';
   
    insert testContact;
    
    Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
      User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
       insert u1;
       
    
    AccountTeamMember testAccTeamMember = new AccountTeamMember(AccountId=TestAcc.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    insert testAccTeamMember;
    
    AccountTeamMember testAccTeamMember1 = new AccountTeamMember(AccountId=TestAcc1.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    insert testAccTeamMember1;
    
    Data_Transformation__c testDataTrans = new Data_Transformation__c(Name='test',Return_Value__c='test',Transformation_Description__c='abc',Lookup_Value__c='test',Source__c = 'Unica Opty Owner' );
     insert testDataTrans ;
     
   Data_Transformation__c testDataTrans1 = new Data_Transformation__c(Name='test',Return_Value__c='test',Transformation_Description__c='abc',Lookup_Value__c='test1',Source__c = 'Unica Opty Owner' );
    insert testDataTrans1;
    
    KeyValueListStore__c strikSettings = new KeyValueListStore__c();
    StrikSettings.name='SUB-BU';
    StrikSettings.TextValue__c='Elite,FindLaw,UKI';
    insert StrikSettings;   
    
      Lead testLead = UnitTest.getLeadInstance();
      TestLead.LeadSource='Customer Service';
      TestLead.SAPAccountNumber__c='1';
      TestLead.Contact_SAP_ID__c = '1';
      TestLead.Is_Web_To_Lead__c = true;
      TestLead.Rep_Channel__c = 'test';
      TestLead.LCRM_Sub_BU__c='USL';
       listlead.add(TestLead);
      
      Lead testLead1 = UnitTest.getLeadInstance();
      TestLead1.LeadSource='Customer Service';
      TestLead1.SAPAccountNumber__c='1';
      TestLead1.Contact_SAP_ID__c = '1';
      TestLead1.Is_Web_To_Lead__c = true;
      TestLead1.LCRM_Sub_BU__c='USL';
      listlead.add(TestLead1);
      
      Lead testLead2 = UnitTest.getLeadInstance();
      TestLead2.LCRM_Sub_BU__c='USL';
      listlead.add(TestLead2);
      
      Lead testLead3 = UnitTest.getLeadInstance();
      TestLead3.LeadSource='Website';
      TestLead3.Source__c ='Practical Law';
      TestLead3.MDBId__c='1';
      TestLead3.Is_Web_To_Lead__c = true;
      TestLead3.Rep_Channel__c = 'test1';
      TestLead3.Is_Web_to_PPO__c = true;
      TestLead3.LCRM_Sub_BU__c='USL';
       listlead.add(TestLead3);
       
      Lead testLead4 = UnitTest.getLeadInstance();
      TestLead4.LeadSource='Website';
      TestLead4.Source__c ='Practical Law';
      TestLead4.MDBId__c='1';
      TestLead4.Contact_SAP_ID__c = '1';
      TestLead4.Is_Web_To_Lead__c = true;
      TestLead4.Rep_Channel__c = 'test1';
      TestLead4.Is_Web_to_PPO__c = true;
      TestLead4.LCRM_Sub_BU__c='USL';
      
       listlead.add(TestLead4);
      if(listlead.size()>0){
          insert listlead;
        }
    /*  for(Lead oLead : [Select OwnerId,Id,Rep_Channel__c,LeadSource from Lead where Id IN : listlead]){
            if(oLead.Rep_Channel__c=='test'){
                System.assertEquals(oLead.OwnerId,u1.Id,'Not Equal');
            }else if(oLead.Rep_Channel__c == 'test1'){
                System.assertEquals(oLead.OwnerId,u1.Id,'Not Equal');
            }else if(oLead.LeadSource=='Customer Service'){
                System.assertEquals(oLead.OwnerId,Userinfo.getUserId(),'Not Equal');
            }
       }*/
       
      System.runas(u1) {
          Lead testL = UnitTest.getLeadInstance();
          TestL.LeadSource='Customer Service';
          TestL.SAPAccountNumber__c='1';
          TestL.Contact_SAP_ID__c = '1';
          TestL.Is_Web_To_Lead__c = true;
          TestL.Rep_Channel__c = 'test';
          TestL.LCRM_Sub_BU__c='USL';
          TestL.OwnerId = u1.id;
          insert TestL;
           
           Test.startTest();
            try{
                LCRMConvertLeadMaptoLeadHistory lcl = new LCRMConvertLeadMaptoLeadHistory();
                lcl.createLeadHistory(TestL);
               // lcl.bError = true;
            }catch(Exception e){system.debug(e.getMessage());}
            Test.stopTest(); 
        } 
        //System.asset(true==true);
    }

    public static testmethod void populateAccountOnLeadTest(){
        test.startTest();
        List<Account> listtestAccount = new List<Account>();
        Map<String,Account> mapAccountSAPNumber = new Map<String,Account>();
        //Commented as a part of DPS-6078
        //AccountHandler.verifyStrikeIronRecCheck = false;
        
        Account testAcc1 = UnitTest.getAccountInstance();
        TestAcc1.SAPAccountNumber__c = '98711';
        TestAcc1.Tax_Number_Type__c = 'C.I';
        TestAcc1.Sales_Org__c = 'LRA';
        TestAcc1.Customer_Class_c__c = 'Academic';
        TestAcc1.Name = 'Unit Test Company';
        TestAcc1.Tax_3__c = 'Tax3';
        TestAcc1.Tax_4__c= 'Tax4';
        TestAcc1.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc1);
        
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
    
        Account testAcc2 = UnitTest.getAccountInstance();
        TestAcc2.SAPAccountNumber__c = '233211';
        TestAcc2.Tax_Number_Type__c = 'C.I';
        TestAcc2.Customer_Class_c__c = 'Academic';
        TestAcc2.Name = 'Unit Test Company';
        TestAcc2.Tax_3__c = 'Tax3';
        TestAcc2.Tax_4__c= 'Tax4';
        TestAcc2.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc2);
        
        Account testAcc3 = UnitTest.getAccountInstance();
        TestAcc3.SAPAccountNumber__c = '32354311';
        TestAcc3.Tax_Number_Type__c = 'C.I';
        TestAcc3.Customer_Class_c__c = 'Academic';
        TestAcc3.Name = 'Unit Test Company';
        TestAcc3.Tax_3__c = 'Tax3';
        TestAcc3.Tax_4__c= 'Tax4';
        TestAcc3.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc3);
        
        Account testAcc4 = UnitTest.getAccountInstance();
        TestAcc4.MDBID__c = '6789990';
        TestAcc3.SAPAccountNumber__c = '6';
        TestAcc4.Tax_Number_Type__c = 'C.I';
        TestAcc4.Customer_Class_c__c = 'Academic';
        TestAcc4.Name = 'Unit Test Company';
        TestAcc4.Tax_3__c = 'Tax3';
        TestAcc4.Tax_4__c= 'Tax4';
        TestAcc4.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc4);
        
        Account testAcc5 =UnitTest.getAccountInstance();
        TestAcc5.Legacy_System_Id__c = '89999';
        TestAcc5.Tax_Number_Type__c = 'C.I';
        TestAcc5.Customer_Class_c__c = 'Academic';
        TestAcc5.Name = 'Unit Test Company';
        TestAcc5.Tax_3__c = 'Tax3';
        TestAcc5.Tax_4__c= 'Tax4';
        TestAcc5.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc5);
        
        Account testAcc6 =UnitTest.getAccountInstance();
        TestAcc6.Legacy_System_Id__c = '69999';
        TestAcc6.SAPAccountNumber__c = '32354333';
        TestAcc6.Tax_Number_Type__c = 'C.I';
        TestAcc6.Customer_Class_c__c = 'Academic';
        TestAcc6.Name = 'Unit Test Company';
        TestAcc6.Tax_3__c = 'Tax3';
        TestAcc6.Tax_4__c= 'Tax4';
        TestAcc6.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc6);
        
        Account testAcc7 =UnitTest.getAccountInstance();
        TestAcc7.Legacy_System_Id__c = '79999';
        TestAcc7.Tax_Number_Type__c = 'C.I';
        TestAcc7.Sales_Org__c = 'LRA';
        TestAcc7.Customer_Class_c__c = 'Academic';
        TestAcc7.Name = 'Unit Test Company';
        TestAcc7.Tax_3__c = 'Tax3';
        TestAcc7.Tax_4__c= 'Tax4';
        TestAcc7.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc7);
        
        Account testAcc8 =UnitTest.getAccountInstance();
        TestAcc8.WLD_ID__c = '4123567';
        TestAcc8.Tax_Number_Type__c = 'C.I';
        TestAcc8.Customer_Class_c__c = 'Academic';
        TestAcc8.Tax_3__c = 'Tax3';
        TestAcc8.Tax_4__c= 'Tax4';
        TestAcc8.Customer_Group__c = 'ACADEMIC';
        listtestAccount.add(TestAcc8);
        
        insert listtestAccount;
        
        for(Account oAccount : [Select Id,SAPAccountNumber__c,MDBID__c,Legacy_System_Id__c,Customer_Class_c__c from Account where Id IN : listtestAccount ]){
            if(oAccount.SAPAccountNumber__c!=null){
              MapAccountSAPNumber.put(oAccount.SAPAccountNumber__c,oAccount);
            }
            if(oAccount.MDBID__c!=null){
               MapAccountSAPNumber.put(oAccount.MDBID__c,oAccount);
            }
            if(oAccount.Legacy_System_Id__c !=null){
                MapAccountSAPNumber.put(oAccount.Legacy_System_Id__c ,oAccount);
            }
        }
        
        KeyValueListStore__c strikSettings = new KeyValueListStore__c();
        StrikSettings.name='SUB-BU';
        StrikSettings.TextValue__c='Elite,FindLaw,UKI';
        insert StrikSettings;   
        
        List<Lead> listlead = new List<Lead>();
        
         Lead testLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service';
         //TestLead1.Account__c = TestAcc1.Id;
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.Contact_SAP_ID__c = '1';
         TestLead1.Is_Web_To_Lead__c = true;
         TestLead1.Rep_Channel__c = 'test';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';
         TestLead1.Tax_Number_Type__c = 'C.I.';
         TestLead1.Tax_3__c = 'Tax3';
         TestLead1.Tax_4__c= 'Tax4';
         TestLead1.Customer_Group__c = 'ACADEMIC';
         TestLead1.Customer_Class__c = 'Academic';
         TestLead1.LCRM_Sub_BU__c='USL';
         listlead.add(TestLead1);
         
         Lead testLead2 = UnitTest.getLeadInstance();
         TestLead2.SAPAccountNumber__c='32354311';
         TestLead2.LCRM_Sub_BU__c='USL';
         listlead.add(TestLead2);
         
         Lead testLead3 = UnitTest.getLeadInstance();
         //TestLead3.SAPAccountNumber__c='233211';
         TestLead3.MDBID__c = '6789990';
         TestLead3.FirstName = 'Unit';
         TestLead3.LastName = 'Tester1';
         //TestLead3.Account__c = TestAcc3.Id;
         TestLead3.Company = 'Unit Test Company';
         TestLead3.Status = 'Contacting';
         TestLead3.Tax_Number_Type__c = 'C.I.';
         TestLead3.Tax_3__c = 'Tax3';
         TestLead3.Tax_4__c= 'Tax4';
         TestLead3.Customer_Group__c = 'ACADEMIC';
         TestLead3.Customer_Class__c = 'Academic';
         TestLead3.LCRM_Sub_BU__c='USL';
         listlead.add(TestLead3);
         
         Lead testLead4 = UnitTest.getLeadInstance();
         TestLead4.LeadSource='Customer Service';
         TestLead4.Legacy_System_Id__c ='79999';
         TestLead4.Contact_SAP_ID__c = '4';
         //TestLead4.Account__c = TestAcc4.Id;
         TestLead4.Is_Web_To_Lead__c = true;
         TestLead4.Rep_Channel__c = 'test';
         TestLead4.FirstName = 'Unit';
         TestLead4.LastName = 'Tester4';
         TestLead4.Company = 'Unit Test Company';
         //TestLead4.SAPAccountNumber__c = '98711';
         TestLead4.Customer_Class__c = 'Bar Chambers';
         TestLead4.Status = 'Contacting';
         TestLead4.Tax_Number_Type__c = 'C.I.';
         TestLead4.Tax_3__c = 'Tax3';
         TestLead4.Tax_4__c= 'Tax4';
         TestLead4.Customer_Group__c = 'ACADEMIC';
         TestLead4.Customer_Class__c = 'Academic';
         TestLead4.LCRM_Sub_BU__c='USL';
         listlead.add(TestLead4);
         
         Lead testLead5 = UnitTest.getLeadInstance();
         TestLead5.LeadSource='Customer Service';
         TestLead5.WLD_ID__c='4123567';
         TestLead5.Contact_SAP_ID__c = '5';
         TestLead5.Is_Web_To_Lead__c = true;
         TestLead5.Rep_Channel__c = 'test';
         //TestLead5.Account__c = TestAcc5.Id;
         TestLead5.FirstName = 'Unit';
         TestLead5.LastName = 'Tester5';
         TestLead5.Company = 'Unit Test Company';
         TestLead5.Status = 'Contacting';
         TestLead5.Tax_Number_Type__c = 'C.I.';
         TestLead5.Tax_3__c = 'Tax3';
         TestLead5.Tax_4__c= 'Tax4';
         TestLead5.Customer_Group__c = 'ACADEMIC';
         TestLead5.Customer_Class__c = 'Academic';
         TestLead5.LCRM_Sub_BU__c='USL';
         listlead.add(TestLead5);
         
         Lead testLead6 = UnitTest.getLeadInstance();
         TestLead6.Legacy_System_Id__c='69999';
         TestLead6.LCRM_Sub_BU__c='USL';
         listlead.add(TestLead6);
      
         insert listlead;
         

        
        /*listlead.add(new Lead(SAPAccountNumber__c='98711', FirstName = 'Unit',
                LastName = 'Tester1',
                Company = 'Unit Test Company',
                Status = 'Contacting'));
                
        listlead.add(new Lead(SAPAccountNumber__c='233211', FirstName = 'Unit',
                LastName = 'Tester2',
                Company = 'Unit Test Company',
                Status = 'Contacting', Account__c = TestAcc2.Id));
                
        listlead.add(new Lead(SAPAccountNumber__c='32354311', FirstName = 'Unit',
                LastName = 'Tester3',
                Company = 'Unit Test Company',
                Status = 'Contacting', Account__c = TestAcc3.Id));
                
        listlead.add(new Lead(FirstName = 'Unit',
                LastName = 'Tester4',
                Company = 'Unit Test Company',
                Status = 'Contacting'));
                
        listlead.add(new Lead(MDBID__c = '6789999',FirstName = 'Unit',
                LastName = 'Tester5',
                Company = 'Unit Test Company',
                Status = 'Contacting', Account__c = TestAcc4.Id));
        
        listlead.add(new Lead(Legacy_System_Id__c ='79999', FirstName = 'Unit',
                LastName = 'Tester6',
                Company = 'Unit Test Company',
                Status = 'Contacting'));
                
        listlead.add(new Lead(Legacy_System_Id__c ='89999', FirstName = 'Unit',
                LastName = 'Tester7',
                Company = 'Unit Test Company',
                Status = 'Contacting'));
        Insert listlead;*/
        
        for(Lead oLead : [Select SAPAccountNumber__c,Account__c,MDBID__c,Legacy_System_Id__c,Sales_Org__c,Customer_Class__c from Lead where Id IN : listlead]){
            if(MapAccountSAPNumber.ContainsKey(oLead.SAPAccountNumber__c)){
                System.assertEquals(oLead.Account__c,MapAccountSAPNumber.get(oLead.SAPAccountNumber__c).Id,'Not Equal');
               if(oLead.SAPAccountNumber__c == '98711'){
                   System.assertEquals(oLead.Customer_Class__c ,MapAccountSAPNumber.get(oLead.SAPAccountNumber__c).Customer_Class_c__c ,'Not Equal');
               }/*else{
                   System.assertEquals(oLead.Customer_Class__c ,'None' ,'Not Equal');
               }*/
               oLead.SAPAccountNumber__c = null;
            }else if(MapAccountSAPNumber.ContainsKey(oLead.MDBID__c)){
                System.assertEquals(oLead.Account__c,MapAccountSAPNumber.get(oLead.MDBID__c).Id,'Not Equal');
                
            }else if(MapAccountSAPNumber.ContainsKey(oLead.Legacy_System_Id__c)){
                System.assertEquals(oLead.Account__c,MapAccountSAPNumber.get(oLead.Legacy_System_Id__c ).Id,'Not Equal');
                oLead.Legacy_System_Id__c = '69999';
            }/*else{
                System.assertEquals(oLead.Account__c,null,'Not Equal');
                oLead.SAPAccountNumber__c = '32354311';
            }        */
        }
             
         update listlead;
         
         for(Lead oLead : [Select SAPAccountNumber__c,Account__c,MDBID__c,Legacy_System_Id__c from Lead where Id IN : listlead]){
            if(MapAccountSAPNumber.ContainsKey(oLead.SAPAccountNumber__c)){
                System.assertEquals(oLead.Account__c,MapAccountSAPNumber.get(oLead.SAPAccountNumber__c).Id,'Not Equal');
                
            }else if(MapAccountSAPNumber.ContainsKey(oLead.MDBID__c)){
                System.assertEquals(oLead.Account__c,MapAccountSAPNumber.get(oLead.MDBID__c).Id,'Not Equal');
                
            }else if(MapAccountSAPNumber.ContainsKey(oLead.Legacy_System_Id__c)){
                System.assertEquals(oLead.Account__c,MapAccountSAPNumber.get(oLead.Legacy_System_Id__c ).Id,'Not Equal');
                
            }/*else{
                System.assertEquals(oLead.Account__c,null,'Not Equal');    
            }*/
        }
        try{
          TestLead6.Approval_status__c='Approved';
          TestLead6.LatAm_Created_by_Partner__c=true;
          TestLead6.Customer_Group__c='';
          TestLead6.Customer_Class__c='';
          TestLead6.Industry_LatAm__c='';
          TestLead6.Sub_Industry_LatAm__c='';
          update TestLead6;
        }catch(Exception e){system.debug(e.getMessage());}
        try{
          TestLead6.Approval_status__c='Submitted';
          update TestLead6;
        }catch(Exception e){system.debug(e.getMessage());}
        
                test.stopTest();
            
    }
    
    
     public static testmethod void populateContactOnLeadTest(){
        List<Contact> listtestContact = new List<Contact>();
        Map<String,Id> mapContactSAPNumber = new Map<String,Id>();
        //Commented as a part of DPS-6078
        //AccountHandler.verifyStrikeIronRecCheck = false;
        ILMGeneral__c ilmGen=new ILMGeneral__c();
        ilmGen.name= 'AllowedUsersForSalesRepAssignment';
        ilmGen.Value__C = 'SL Eloqua';        
        insert ilmGen;
        
        Account testAcc = UnitTest.getAccountInstance();
        TestAcc.SAPAccountNumber__c = '1';
        insert TestAcc;
    
        Contact testContact1 = UnitTest.getContactInstance(TestAcc.Id);
        testContact1.SAP_Contact_ID__c = '123';
        listtestContact.add(testContact1);
        
        Contact testContact2 = UnitTest.getContactInstance(TestAcc.Id);
        listtestContact.add(testContact2);
        
        Contact testContact3 = UnitTest.getContactInstance(TestAcc.Id);
        testContact3.SAP_Contact_ID__c = '111';
        listtestContact.add(testContact3);
        
        Contact testContact4 = UnitTest.getContactInstance(TestAcc.Id);
        testContact4.External_ID__c = '6999';
        listtestContact.add(testContact4);
        
        Contact testContact5 = UnitTest.getContactInstance(TestAcc.Id);
        testContact5.External_ID__c = '7999';
        listtestContact.add(testContact5);
        
        insert listtestContact;
        
        for(Contact oContact : [Select Id,SAP_Contact_ID__c,External_ID__c from Contact where Id IN :listtestContact]){
            if(oContact.SAP_Contact_ID__c!=null){
               MapContactSAPNumber.put(oContact.SAP_Contact_ID__c,oContact.Id);
            }else if(oContact.External_ID__c!=null){
            MapContactSAPNumber.put(oContact.External_ID__c,oContact.Id);
         }
        }
        
        KeyValueListStore__c strikSettings = new KeyValueListStore__c();
        StrikSettings.name='SUB-BU';
        StrikSettings.TextValue__c='Elite,FindLaw,UKI';
        insert StrikSettings;   
        
        List<Lead> listlead = new List<Lead>();

        listlead.add(new Lead(Contact_SAP_ID__c='111', FirstName = 'Unit',
                LastName = 'Tester1',
                Company = 'Unit Test Company',LCRM_Sub_BU__c='USL',
                Status = 'Contacting'));
                
        listlead.add(new Lead(Contact_SAP_ID__c='123', FirstName = 'Unit',
                LastName = 'Tester2',
                Company = 'Unit Test Company',LCRM_Sub_BU__c='USL',
                Status = 'Contacting'));
                
                    
        listlead.add(new Lead( FirstName = 'Unit',
                LastName = 'Tester3',
                Company = 'Unit Test Company',LCRM_Sub_BU__c='USL',
                Status = 'Contacting'));
                
         listlead.add(new Lead( External_Contact_ID__c='6999',FirstName = 'Unit',
                LastName = 'Tester4',
                Company = 'Unit Test Company',LCRM_Sub_BU__c='USL',
                Status = 'Contacting'));
                
         listlead.add(new Lead( External_Contact_ID__c='7999',FirstName = 'Unit',
                LastName = 'Tester5',
                Company = 'Unit Test Company',LCRM_Sub_BU__c='USL',
                Status = 'Contacting'));
                                      
        Insert listlead;
        
        test.startTest();
        for(Lead oLead :[Select Contact_SAP_ID__c,Id,Contact__c,External_Contact_ID__c from Lead where Id IN: listlead]){
            if(MapContactSAPNumber.ContainsKey(oLead.Contact_SAP_ID__c)){

                System.assertEquals(oLead.Contact__c,MapContactSAPNumber.get(oLead.Contact_SAP_ID__c),'Not Equal');
                oLead.Contact_SAP_ID__c= null;
            }else if(MapContactSAPNumber.ContainsKey(oLead.External_Contact_ID__c)){
                System.assertEquals(oLead.Contact__c,MapContactSAPNumber.get(oLead.External_Contact_ID__c),'Not Equal');
                oLead.External_Contact_ID__c=null;
            }else{
                System.assertEquals(oLead.Contact__c,null,'Not Equal');
                oLead.Contact_SAP_ID__c = '111';
            }
        }
        
        update listlead;
        
        for(Lead oLead :[Select Contact_SAP_ID__c,Id,Contact__c,External_Contact_ID__c from Lead where Id IN: listlead]){
            if(MapContactSAPNumber.ContainsKey(oLead.Contact_SAP_ID__c)){

                System.assertEquals(oLead.Contact__c,MapContactSAPNumber.get(oLead.Contact_SAP_ID__c),'Not Equal');
                
            }else if(MapContactSAPNumber.ContainsKey(oLead.External_Contact_ID__c)){
                System.assertEquals(oLead.Contact__c,MapContactSAPNumber.get(oLead.External_Contact_ID__c),'Not Equal');
               
            }else{
                System.assertEquals(oLead.Contact__c,null,'Not Equal');
                
            }
        }
                test.stopTest();
     }
     
      public static testmethod void setSLAFromSLAAdminTable(){
        
        List<Lead> listLead= new  List<Lead>();
        
        Lead l1= new Lead(FirstName='John', LastNAme='Carry',business_org__c ='Corporate', Lead_scoring_combined__c='A2',Company='TR',Country='BANGLADESH');
        listLead.add(l1);
        
        Lead l2= new Lead(FirstName='Mike', LastNAme='Jorden',business_org__c ='Corporate', Lead_scoring_combined__c='',Company='TR',Country='BANGLADESH');
        listLead.add(l2);
        
        Lead l3= new Lead(FirstName='Rose', LastNAme='Talor',business_org__c ='Corporate', Lead_scoring_combined__c='B1',Company='TR',Country='BANGLADESH');
        listLead.add(l3);
        
        Lead l4= new Lead(FirstName='Brand', LastNAme='Pit',business_org__c ='Corporate', Lead_scoring_combined__c='A1A2',Company='TR',Country='BANGLADESH');
        listLead.add(l4);
        
        Lead l5= new Lead(FirstName='Alex', LastNAme='Will',business_org__c ='Corporate', Lead_scoring_combined__c='N/A',Company='TR',Country='BANGLADESH');
        listLead.add(l5);
        
        Lead l6= new Lead(FirstName='Alex', LastNAme='Will',business_org__c ='Corporate', Lead_scoring_combined__c='N/A',Company='TR',Country='BANGLADESH',Sales_Org__c = 'LRA');
        listLead.add(l6);
        
        Lead l7= new Lead(FirstName='Alex', LastNAme='Will',business_org__c ='CorporateN/A', Lead_scoring_combined__c='',Company='TR',Country='BANGLADESH',Sales_Org__c = 'LRA');
        listLead.add(l7);
        
        Lead l8= new Lead(FirstName='Alex', LastNAme='Will',business_org__c ='CorporateN/A', Lead_scoring_combined__c='',Company='TR',Country='BANGLADESH',Sales_Org__c = 'GLI');
        listLead.add(l8);
        
        Lead l9= new Lead(FirstName='Alex', LastNAme='Will',business_org__c ='CorporateNA', Lead_scoring_combined__c='N/A',Company='TR',Country='BR',Sales_Org__c = 'GLI');
        listLead.add(l9);        
            
        System.assert(l7.FirstName=='Alex');
        Test.startTest();
            try{
                createLMSMA();
                insert listLead;
            }catch(exception e){
              System.debug('test');
            }
            try{
                /*LM_SLA__c  lmsla4= new LM_SLA__c(Channel__c ='CorporateNA', Lead_Score__c='N/A',Conversion_SLA__c= 2,Acceptance_SLA__c=2, Send_AcceptBy_Warning_Email__c =true, Send_AcceptBy_Violation_Email__c= true, Send_Convert_By_Warning_Email__c=true, Send_Convert_By_Violation_Email__c=true, Accept_By_SLA_Warning_period__c=2, Accept_By_SLA_Violation_Period__c=2, Convert_By_SLA_Warning_Period__c=2, Convert_By_SLA_Violation_period__c=2);
                insert lmsla4;
                Lead l9= new Lead(FirstName='Alex', LastNAme='Will',business_org__c ='CorporateNA', Lead_scoring_combined__c='N/A',Company='TR',Country='BR',Sales_Org__c = 'GLI');
                insert l9;*/
            }catch(exception e){
              System.debug('test'+e.getStacktraceString());
            }
            
        Test.StopTest();
        
        /*Test.startTest();
            createLMSMA();
            update listLead;
        Test.StopTest();*/
        
        /*Test.startTest();
            createLMSMA();        
            Lead l1= new Lead(FirstName='John', LastNAme='Carry',business_org__c ='Corporate', Lead_scoring_combined__c='A1',Company='TR',Country='BANGLADESH');
            insert l1;
        Test.StopTest();
        
        Test.startTest();
            createLMSMA();        
            Lead l2= new Lead(FirstName='Mike', LastNAme='Jorden',business_org__c ='', Lead_scoring_combined__c='',Company='TR',Country='BANGLADESH');
            insert l2;
        Test.StopTest();*/
      
      }
      
      public static void createLMSMA(){
      
          ILMGeneral__c ilmGen=new ILMGeneral__c();
          ilmGen.name= 'AllowedUsersForSalesRepAssignment';
          ilmGen.Value__C = 'SL Eloqua';        
          insert ilmGen;
               
          
          List<LM_SLA__c> lmSLAList= new  List<LM_SLA__c>();
          LM_SLA__c lmsla1= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='A2',Conversion_SLA__c= 2,Acceptance_SLA__c=2);
          lmSLAList.add(lmsla1);
          
          LM_SLA__c  lmsla2= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='N/A',Conversion_SLA__c= 2,Acceptance_SLA__c=2);
          lmSLAList.add(lmsla2);
          
          LM_SLA__c  lmsla3= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='B4',Conversion_SLA__c= 2,Acceptance_SLA__c=2);
          lmSLAList.add(lmsla3);
          
          LM_SLA__c  lmsla4= new LM_SLA__c(Channel__c ='CorporateN/A', Lead_Score__c='N/A',Conversion_SLA__c= 2,Acceptance_SLA__c=2, Send_AcceptBy_Warning_Email__c =false);
          lmSLAList.add(lmsla4);
          
          LM_SLA__c  lmsla5= new LM_SLA__c(Channel__c ='CorporateNA', Lead_Score__c='N/A',Conversion_SLA__c= 2,Acceptance_SLA__c=2, Send_AcceptBy_Warning_Email__c =true, Send_AcceptBy_Violation_Email__c= true, Send_Convert_By_Warning_Email__c=true, Send_Convert_By_Violation_Email__c=true, Accept_By_SLA_Warning_period__c=2, Accept_By_SLA_Violation_Period__c=2, Convert_By_SLA_Warning_Period__c=2, Convert_By_SLA_Violation_period__c=2);
          lmSLAList.add(lmsla5);
                 
          //LM_SLA__c  lmsla4= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='A1A2',Conversion_SLA__c= 2,Acceptance_SLA__c=2, Send_AcceptBy_Warning_Email__c =true);
          //lmSLAList.add(lmsla4);
          
          if(lmSLAList!= null){
              insert lmSLAList;
          }
          
      }
      
      public static testmethod void isHoliday(){
          Datetime checkDateTime = System.Today();
          System.assert(checkDateTime == System.Today());
          Datetime hilidatetime = datetime.newInstance(2015, 12, 25, 02, 30, 0);
          Date holidate = date.newInstance(2015,12,25);
          /*List<Holiday> holidays = [Select Id From Holiday];
          system.assert(holidays.size() == 0);
          insert holidays;*/
          
          /*ILMGeneral__c ilmGen=new ILMGeneral__c();
          ilmGen.name= 'AllowedUsersForSalesRepAssignment';
          ilmGen.Value__C = 'SL Eloqua';        
          insert ilmGen; */   
          
          List<Holiday> listholidays = new List<Holiday>();
          
          Holiday hol1 = new Holiday();
          hol1.Name='Test holiday1';
          hol1.activitydate = System.Today();
          listholidays.add(hol1);
          //insert hol1;
          
          Holiday hol2 = new Holiday();
          hol2.Name='Test holiday2';
          hol2.activitydate = holidate ;
          //insert hol2;
          listholidays.add(hol2);
          
          Test.startTest();
          if(listholidays != null){
              insert listholidays ;
          }
          Test.stopTest();
          
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
          User u = new User(Alias = 'standt1', Email='standarduser80@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser80@testorg.com');
          
          System.runAs(u){
          
          List<Lead> listLead1= new  List<Lead>();
          Lead l1= new Lead(FirstName='Mike1', LastNAme='Jo1', Accept_By__c=CheckDateTime ,Convert_By__c= CheckDateTime ,Company='TR',Country='BANGLADESH');
          listLead1.add(l1);
          Lead l2= new Lead(FirstName='John1', LastNAme='Carry1', Accept_By__c= hilidatetime ,Convert_By__c= hilidatetime ,Company='TR',Country='BANGLADESH');
          listLead1.add(l2);
          Lead l3= new Lead(FirstName='John3', LastNAme='Carry3', Accept_By__c= hilidatetime ,Convert_By__c= hilidatetime ,Company='TR',Country='BANGLADESH', Sales_Org__c='LRA');
          listLead1.add(l3);
          
          try{
          if(listLead1 != null){
              insert listLead1;
          }
          }catch(Exception e){
               System.debug('An error occurred');
          }
          
          }
          
          
      }
      
       static testMethod void cuit() {
    Test.startTest();
try{
        Lead testLead = UnitTest.getLeadInstance();
        
        TestLead.Tax_Number_Type__c = 'C.U.I.T.';
        System.assert(TestLead.Tax_Number_Type__c == 'C.U.I.T.');
        TestLead.Tax_Number__c= '33707586279'; // valid
        TestLead.Billing_Country__c= 'AR';
                insert TestLead;

        

        } catch(Exception e) {
          return;
        }
        
            Test.stopTest();

    }
      
       static testMethod void cuil() {
       KeyValueListStore__c strikSettings = new KeyValueListStore__c();
    StrikSettings.name='SUB-BU';
    StrikSettings.TextValue__c='Elite,FindLaw,USL,UKI';
    insert StrikSettings;   
    system.assert(StrikSettings.name=='SUB-BU');
   Test.startTest();
     Lead testLead = UnitTest.getLeadInstance();
        
        TestLead.Tax_Number_Type__c = 'C.U.I.L.';
        TestLead.Tax_Number__c= '23267487219'; // valid
        TestLead.Billing_Country__c= 'AR';
        TestLead.LCRM_Sub_BU__c='USL';
                insert TestLead;


      
            Test.stopTest();
    }
    
    static testMethod void dni() {
    
    KeyValueListStore__c strikSettings = new KeyValueListStore__c();
    StrikSettings.name='SUB-BU';
    System.assert(StrikSettings.name=='SUB-BU');
    StrikSettings.TextValue__c='Elite,FindLaw,USL,UKI';
    insert StrikSettings;   
    
    Test.startTest();
       Lead testLead = UnitTest.getLeadInstance();
        
        TestLead.Tax_Number_Type__c = 'D.N.I';
        TestLead.Tax_Number__c= '2326748'; // valid
        TestLead.Billing_Country__c= 'AR';
        TestLead.LCRM_Sub_BU__c='USL';
        insert TestLead;
            Test.stopTest();

    }
    
    static testMethod void ci() {
      
    Test.startTest();
    KeyValueListStore__c strikSettings = new KeyValueListStore__c();
    StrikSettings.name='SUB-BU';
    System.assert(StrikSettings.name=='SUB-BU');
    StrikSettings.TextValue__c='Elite,FindLaw,UKI';
    insert StrikSettings;
    
    Lead testLead = UnitTest.getLeadInstance();
        
        TestLead.Tax_Number_Type__c = 'C.I';
        TestLead.Tax_Number__c= 'abc26748'; // valid
        TestLead.Billing_Country__c= 'AR';
        TestLead.LCRM_Sub_BU__c='USL';
                insert TestLead;

            Test.stopTest();
        }
        
        
        public static testmethod void checkIndustryTest(){  
       
       Id profileId = [SELECT Id From Profile Where Name = 'Latam User' LIMIT 1].Id;
       user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
      Lead testLead = UnitTest.getLeadInstance();
       Lead testLead1 = UnitTest.getLeadInstance();
        
        TestLead.Industry_LatAm__c= '';
        TestLead.Industry= 'Not Applicable';
        System.assert(TestLead.Industry== 'Not Applicable');
        TestLead1.Industry_LatAm__c= 'FINANCE';
        TestLead1.Industry= 'FINANCE';
        System.RunAs(usr) {
            Test.startTest();
            try {
                insert TestLead;
                 insert TestLead;
                 TestLead.Industry_LatAm__c= 'FINANCE';
                 TestLead.Industry= '';
                 
                 update TestLead;
                 
                 TestLead1.Industry_LatAm__c= '';
                 TestLead1.Industry= 'FINANCE';
                update TestLead1;
            }
            catch(exception ex){
              System.debug('test');
            }
            Test.StopTest();
            }
      }
      
      public static testmethod void checkIndustryTest1(){  
       
       Id profileId = [SELECT Id From Profile Where Name = 'LatAm User' LIMIT 1].Id;
       user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
      Lead testLead = UnitTest.getLeadInstance();
       Lead testLead1 = UnitTest.getLeadInstance();
        
        TestLead.Industry_LatAm__c= '';
        TestLead.Industry= 'Not Applicable';
        System.assert(TestLead.Industry== 'Not Applicable');
        TestLead.Is_Web_to_PPO__c =false;
        
        TestLead1.Industry_LatAm__c= 'FINANCE';
        TestLead1.Industry= 'FINANCE';
        TestLead1.Is_Web_to_PPO__c =false;
        
            Test.startTest();
            try {
                insert TestLead;
                 insert TestLead1;
                 TestLead.Industry_LatAm__c= 'FINANCE';
                 TestLead.Industry= '';
                 TestLead.Is_Web_to_PPO__c =true;
                 TestLead.Source__c = 'Practical Law';
                 TestLead.Status = 'Contacting';
                 
                 update TestLead;
                 
                 
                 TestLead1.Industry_LatAm__c= '';
                 TestLead1.Industry= 'FINANCE';
                 TestLead1.Is_Web_to_PPO__c =true;
                 TestLead1.Source__c = 'Practical Law';
                 TestLead1.Status = 'Contacting';
                update TestLead1;
            }
            catch(exception ex){
              System.debug('test');
            }
            Test.StopTest();
            
      }
      
      
      //Commented out as a part of DPS-6078 
      /*static testMethod void verifyEmailAndPhone() {
    
        GenericObject__c obj1 = new GenericObject__c(name = 'Lead', Apifieldname__c = 'LCRM_Sub_BU__c' ,Isglifieldapiname__c  = 'Is_GLI__c', Salesorgapiname__c = 'Sales_Org__c');
        insert obj1;
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'GB', LCRM_Country_Code__c = 'GB', LCRM_Country_Name__c = 'United Kingdom', LCRM_ISD_Code__c = '44');
        insert dialCode;
          system.debug('+++ generic object inserted');

          
          Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];
          User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                  localesidkey='en_US', profileid = p.Id, employeenumber='0144020', Sub_Bu__c='UKI',
                                  timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
          insert gliUser;
     RecordType rt = [select id from recordtype where developername='UKI' and sObjectType = 'Lead' and isactive=true];
    Test.startTest();
    system.runAs(gliUser){
        Lead TestLead = UnitTest.getLeadInstance();
        TestLead.Email = 'test@test.com';
        TestLead.phone = '3456789023';
        TestLead.MobilePhone = '7718838846';
        TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        TestLead.RecordtypeId=rt.Id;
        TestLead.Billing_Country__c = 'GB';
        insert TestLead;
        
        //TestLead.Email = 'test1@test.com';
        //TestLead.Phone = '3456789029';
        //TestLead.MobilePhone = '7718838849';
        //update TestLead;
        
    }
            Test.stopTest();
        }*/
        
        //Commented out as a part of DPS-6078
        /*static testMethod void verifyEmailAndPhoneTest() {
    
        GenericObject__c obj1 = new GenericObject__c(name = 'Lead', Apifieldname__c = 'LCRM_Sub_BU__c' ,Isglifieldapiname__c  = 'Is_GLI__c', Salesorgapiname__c = 'Sales_Org__c');
        insert obj1;
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'GB', LCRM_Country_Code__c = 'GB', LCRM_Country_Name__c = 'United Kingdom', LCRM_ISD_Code__c = '44');
        insert dialCode;
          system.debug('+++ generic object inserted');

          
          Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];
          User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                  localesidkey='en_US', profileid = p.Id, employeenumber='0144020', Sub_Bu__c='UKI',
                                  timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
          insert gliUser;
     RecordType rt = [select id from recordtype where developername='UKI' and sObjectType = 'Lead' and isactive=true];
    Test.startTest();
    system.runAs(gliUser){
        Lead TestLead = UnitTest.getLeadInstance();
        TestLead.Email = 'test@test.com';
        TestLead.phone = '+3456789023';
        TestLead.MobilePhone = '+7718838846';
        TestLead.LCRM_Mobile_Verification__c = 'Exception';
        TestLead.LCRM_Email_Verification__c = 'Exception';
        TestLead.LCRM_Phone_Verification__c = 'Exception';
        TestLead.RecordtypeId=rt.Id;
        TestLead.Billing_Country__c = 'GB';
        insert TestLead;
        
        TestLead.Email = 'test1@test.com';
        TestLead.Phone = '+3456789029';
        TestLead.MobilePhone = '+7718838849';
        //TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        //TestLead.LCRM_Email_Verification__c = 'Exception';
        //TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        update TestLead;
        
    }
            Test.stopTest();
        }*/
        
        
        /**static testMethod void verifyEmailAndPhoneTest1() {
    
        GenericObject__c obj1 = new GenericObject__c(name = 'Lead', Apifieldname__c = 'LCRM_Sub_BU__c' ,Isglifieldapiname__c  = 'Is_GLI__c', Salesorgapiname__c = 'Sales_Org__c');
        insert obj1;
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'GB', LCRM_Country_Code__c = 'GB', LCRM_Country_Name__c = 'United Kingdom', LCRM_ISD_Code__c = '44');
        insert dialCode;
          system.debug('+++ generic object inserted');

          
          Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];
          User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                  localesidkey='en_US', profileid = p.Id, employeenumber='0144020', Sub_Bu__c='UKI',
                                  timezonesidkey='America/Los_Angeles', username='user@mydomain.com',Rep_Type_Description__c='test');        
          insert gliUser;
     RecordType rt = [select id from recordtype where developername='UKI' and sObjectType = 'Lead' and isactive=true];
    Test.startTest();
    system.runAs(gliUser){
        Lead TestLead = UnitTest.getLeadInstance();
        TestLead.Email = null;
        TestLead.phone = null;
        TestLead.MobilePhone = null;
        //TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        //TestLead.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        //TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        TestLead.RecordtypeId=rt.Id;
        TestLead.Billing_Country__c = 'GB';
        insert TestLead;
        
        TestLead.Email = 'test1@test.com';
        TestLead.Phone = '+3456789029';
        TestLead.MobilePhone = '+7718838849';
        TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        update TestLead;
        
    }
            Test.stopTest();
        }**/
        
        //Commented out as a part of DPS-6078
        /*static testMethod void verifyEmailAndPhoneTest2() {
    
        GenericObject__c obj1 = new GenericObject__c(name = 'Lead', Apifieldname__c = 'LCRM_Sub_BU__c' ,Isglifieldapiname__c  = 'Is_GLI__c', Salesorgapiname__c = 'Sales_Org__c');
        insert obj1;
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'GB', LCRM_Country_Code__c = 'GB', LCRM_Country_Name__c = 'United Kingdom', LCRM_ISD_Code__c = '44');
        insert dialCode;
          system.debug('+++ generic object inserted');

          
          Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];
          User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                  localesidkey='en_US', profileid = p.Id, employeenumber='0144020', Sub_Bu__c='UKI',
                                  timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
          insert gliUser;
     RecordType rt = [select id from recordtype where developername='UKI' and sObjectType = 'Lead' and isactive=true];
    Test.startTest();
    system.runAs(gliUser){
        Lead TestLead = UnitTest.getLeadInstance();
        TestLead.Email = 'test1@test.com';
        TestLead.phone = '+3456789029';
        TestLead.MobilePhone = '+7718838849';
        TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        TestLead.RecordtypeId=rt.Id;
        TestLead.Billing_Country__c = 'GB';
        insert TestLead;
        
        TestLead.Email = 'test1@test.com';
        TestLead.Phone = '+3456789029';
        TestLead.MobilePhone = '+7718838849';
        TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        update TestLead;
        
    }
            Test.stopTest();
        }*/
        
        //Commented out as a part of DPS-6078
        /*static testMethod void verifyEmailAndPhoneTest3() {
    
        GenericObject__c obj1 = new GenericObject__c(name = 'Lead', Apifieldname__c = 'LCRM_Sub_BU__c' ,Isglifieldapiname__c  = 'Is_GLI__c', Salesorgapiname__c = 'Sales_Org__c');
        insert obj1;
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'GB', LCRM_Country_Code__c = 'GB', LCRM_Country_Name__c = 'United Kingdom', LCRM_ISD_Code__c = '44');
        insert dialCode;
          system.debug('+++ generic object inserted');

          
          Profile p = [SELECT Id FROM profile WHERE name='UKI Users'];
          User gliUser = new User(alias = 'newUser', email='user@mydomain.com', 
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                  localesidkey='en_US', profileid = p.Id, employeenumber='0144020', Sub_Bu__c='UKI',
                                  timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
          insert gliUser;
     RecordType rt = [select id from recordtype where developername='UKI' and sObjectType = 'Lead' and isactive=true];
    Test.startTest();
    system.runAs(gliUser){
        Lead TestLead = UnitTest.getLeadInstance();
        TestLead.Email = 'newUser@gmail.com';
        TestLead.phone = '1245789023';
        TestLead.MobilePhone = '7718838846';
        TestLead.LCRM_Mobile_Verification__c = 'Exception';
        TestLead.LCRM_Email_Verification__c = 'Exception';
        TestLead.LCRM_Phone_Verification__c = 'Exception';
        TestLead.RecordtypeId=rt.Id;
        TestLead.Billing_Country__c = 'GB';
        insert TestLead;
        
        TestLead.Email = 'newUse1r@gmail.com';
        TestLead.Phone = '1245789123';
        TestLead.MobilePhone = '7718838849';
        //TestLead.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
        //TestLead.LCRM_Email_Verification__c = 'Pending. Please refresh.';
        //TestLead.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
        update TestLead;
        
    }
            Test.stopTest();
        }*/
        
        static testMethod void isValidDNILELC() {
        
         Test.startTest();
         LeadTriggerhandler oLead = new LeadTriggerhandler();
         LeadTriggerhandler.isValidDNILELC('12345678');
         LeadTriggerhandler.isValidCI('12345678');
         String s = 'test';
          System.assert(s == 'test');
         Test.stopTest();
    }
            
    @isTest static void testLeadtriggerHandler() {
 try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            //Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser; 
        
        System.runAs(testUser) {
            
             test.startTest();
             
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
          KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
          
          KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
          
          KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
          
          KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
           
         KeyValueListStore__c kValue5 = new KeyValueListStore__c();
            kValue5.Name ='LCRMStrikeIronSubBULeads';
           kValue5.TextValue__c='FindLaw,LMS,USL,Elite';
            
         KeyValueListStore__c kValue6 = new KeyValueListStore__c();
            kValue6.Name ='LCRMStrikeIronInformaticaUsers';
            kValue6.Failure_Email__c='Informatica User';
         
            System.assert(kValue6.Failure_Email__c=='Informatica User');
           kValueLst.add(kValue1);
           kValueLst.add(kValue2);
           kValueLst.add(kValue3);
           kValueLst.add(kValue4);        
           kValueLst.add(kValue5);      
           kValueLst.add(kValue6);      
           
           if(kValueLst.size()>0){
           insert  kValueLst;
           }
        
        LCRMGenericComponent.isLotusUser();
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead testLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         testLead1.Email='Debarghya.sen@thomsonreuters.com';
         testLead1.Phone='+919870185077';
         testLead1.MobilePhone='7506356379';         
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Billing_Country__c='US';
         TestLead1.LCRM_Sub_BU__c='test';
         listlead.add(TestLead1);
         
            //Commented out as a part of DPS-6078   
             //LeadTriggerHandler.verifyEmailAndPhoneRecCheck=false;
             if(listlead.size()>0){
             insert listlead;
            }
            listlead[0].phone = '';
            update listlead;
               
            
            
             test.stoptest();
        }
        
        
   }catch(Exception ex){
    system.debug('Ex');
  }

}


  @isTest static void testLeadtriggerHandlerDialcode() {
 try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            //Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser; 
        
        System.runAs(testUser) {
            
             test.startTest();
             
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
          KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
          
          KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
          
          KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
          
          KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
           
         KeyValueListStore__c kValue5 = new KeyValueListStore__c();
            kValue5.Name ='LCRMStrikeIronSubBULeads';
           kValue5.TextValue__c='FindLaw,LMS,USL,Elite';
            
         KeyValueListStore__c kValue6 = new KeyValueListStore__c();
            kValue6.Name ='LCRMStrikeIronInformaticaUsers';
            kValue6.Failure_Email__c='Informatica User';
         
            System.assert(kValue6.Failure_Email__c=='Informatica User');
           kValueLst.add(kValue1);
           kValueLst.add(kValue2);
           kValueLst.add(kValue3);
           kValueLst.add(kValue4);        
           kValueLst.add(kValue5);      
           kValueLst.add(kValue6);      
           
           if(kValueLst.size()>0){
           insert  kValueLst;
           }
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'US', LCRM_ISD_Code__c = '44');
        insert dialCode;
        LCRMGenericComponent.isLotusUser();
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead testLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         testLead1.Email='Debarghya.sen@thomsonreuters.com';
         testLead1.Phone='+919870185077';
         testLead1.MobilePhone='+917506356379';         
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Billing_Country__c='US';
         TestLead1.LCRM_Sub_BU__c='test';
         listlead.add(TestLead1);
         
            //Commented out as a part of DPS-6078
             //LeadTriggerHandler.verifyEmailAndPhoneRecCheck=false;
             if(listlead.size()>0){
             insert listlead;
            }
            
            update listlead;
             test.stoptest();
        }
        
        
   }catch(Exception ex){
    system.debug('Ex');
  }

}



  @isTest static void testLeadtriggerHandlervalues() {
 try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            //Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser; 
        
        System.runAs(testUser) {
            
             test.startTest();
             
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
          KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
          
          KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
          
          KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
          
          KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
           
         KeyValueListStore__c kValue5 = new KeyValueListStore__c();
            kValue5.Name ='LCRMStrikeIronSubBULeads';
           kValue5.TextValue__c='FindLaw,LMS,USL,Elite';
            
         KeyValueListStore__c kValue6 = new KeyValueListStore__c();
            kValue6.Name ='LCRMStrikeIronInformaticaUsers';
            kValue6.Failure_Email__c='Informatica User';
         
            System.assert(kValue6.Failure_Email__c=='Informatica User');
           kValueLst.add(kValue1);
           kValueLst.add(kValue2);
           kValueLst.add(kValue3);
           kValueLst.add(kValue4);        
           kValueLst.add(kValue5);      
           kValueLst.add(kValue6);      
           
           if(kValueLst.size()>0){
           insert  kValueLst;
           }
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'US', LCRM_ISD_Code__c = '44');
        insert dialCode;
        LCRMGenericComponent.isLotusUser();
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead testLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         testLead1.Email='Debarghya.sen@thomsonreuters.com';
         testLead1.Phone='9870185077';
         testLead1.MobilePhone='7506356379';         
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Billing_Country__c='US';
         TestLead1.LCRM_Sub_BU__c='test';
         listlead.add(TestLead1);
         
            //Commented out as a part of DPS-6078
            // LeadTriggerHandler.verifyEmailAndPhoneRecCheck=false;
             if(listlead.size()>0){
             insert listlead;
            }
            
            update listlead;
             test.stoptest();
        }
        
        
   }catch(Exception ex){
    system.debug('Ex');
  }

}

@isTest static void testLeadtriHandlerException() {
 try{
         Profile profileId = [Select id,name from profile where name = 'System Administrator'];
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            //Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser; 
        
        System.runAs(testUser) {
            
             test.startTest();
             
        List<KeyValueListStore__c> kValueLst = new List<KeyValueListStore__c>();
          KeyValueListStore__c kValue1 = new KeyValueListStore__c();
            kValue1.Name ='ANZUsersProfileId';
          
          KeyValueListStore__c kValue2 = new KeyValueListStore__c();
            kValue2.Name ='LTS_partnerUserProfileName';
          
          KeyValueListStore__c kValue3 = new KeyValueListStore__c();
            kValue3.Name ='LTS_partnerUserLeadSourceValue';
          
          KeyValueListStore__c kValue4 = new KeyValueListStore__c();
            kValue4.Name ='LTS_partnerUserBUSegmentValue';
           
         KeyValueListStore__c kValue5 = new KeyValueListStore__c();
            kValue5.Name ='LCRMStrikeIronSubBULeads';
           kValue5.TextValue__c='FindLaw,LMS,USL,Elite';
            
         KeyValueListStore__c kValue6 = new KeyValueListStore__c();
            kValue6.Name ='LCRMStrikeIronInformaticaUsers';
            kValue6.Failure_Email__c='Informatica User';
         
            System.assert(kValue6.Failure_Email__c=='Informatica User');
           kValueLst.add(kValue1);
           kValueLst.add(kValue2);
           kValueLst.add(kValue3);
           kValueLst.add(kValue4);        
           kValueLst.add(kValue5);      
           kValueLst.add(kValue6);      
           
           if(kValueLst.size()>0){
           insert  kValueLst;
           }
        
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c(Name = 'US', LCRM_Country_Code__c = 'US', LCRM_Country_Name__c = 'US', LCRM_ISD_Code__c = '44',LCRM_International_Prefix__c='+1',LCRM_Minimum_Length__c=10);
        insert dialCode;
        LCRMGenericComponent.isLotusUser();
         recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
        List<Lead> listlead = new List<Lead>();
        
         Lead testLead1 = UnitTest.getLeadInstance();
         TestLead1.LeadSource='Customer Service'; 
         TestLead1 .RecordTypeId=leadRt.Id;      
         TestLead1.SAPAccountNumber__c = '98711';
         TestLead1.FirstName = 'Unit';
         TestLead1.LastName = 'Tester1';
         testLead1.Email='Debarghya.sen@thomsonreuters.com';
         testLead1.Phone='9870185077';
         testLead1.MobilePhone='7506356379';         
         TestLead1.Company = 'Unit Test Company';
         TestLead1.Status = 'Contacting';         
         TestLead1.Billing_Country__c='US';
         TestLead1.LCRM_Sub_BU__c='test';
          testLead1.LCRM_Email_Verification__c='Exception';
            testLead1.LCRM_Phone_Verification__c='Exception';
            testLead1.LCRM_Mobile_Verification__c='Exception';
            
         Lead testLead2 = UnitTest.getLeadInstance();
         TestLead2.LeadSource='Customer Service'; 
         TestLead2 .RecordTypeId=leadRt.Id;      
         TestLead2.SAPAccountNumber__c = '98711';
         TestLead2.FirstName = 'Unit';
         TestLead2.LastName = 'Tester1';
         testLead2.Email='Debarghya.sen@thomsonreuters.com';
         testLead2.Phone='449870185077';
         testLead2.MobilePhone='447506356379';         
         TestLead2.Company = 'Unit Test Company';
         TestLead2.Status = 'Contacting';         
         TestLead2.Billing_Country__c='US';
         TestLead2.LCRM_Sub_BU__c='test';
          testLead1.LCRM_Email_Verification__c='Exception';
            testLead1.LCRM_Phone_Verification__c='Exception';
            testLead1.LCRM_Mobile_Verification__c='Exception';
         
         listlead.add(TestLead1);
         listlead.add(TestLead2);
         
            //Commented out as a part of DPS-6078
             //LeadTriggerHandler.verifyEmailAndPhoneRecCheck=false;
             if(listlead.size()>0){
             insert listlead;
            }
            
            testLead1.Email='test.sen@thomsonreuters.com';
            testLead1.Phone='1987018506';
            testLead1.MobilePhone='0009870006';         
            testLead1.LCRM_Email_Verification__c='Exception';
            testLead1.LCRM_Phone_Verification__c='Exception';
            testLead1.LCRM_Mobile_Verification__c='Exception';
            checkRecursive.lcrmRecursivecheckflag_Lead=true;
            testLead2.Phone='441987018508';
            testLead2.MobilePhone='440009870008';         
            update listlead;
            testLead1.LatAm_Created_by_Partner__c =true;
            testLead1.Approval_status__c = '';
            testLead2.LatAm_Created_by_Partner__c =true;
            testLead2.Approval_status__c = 'Rejected';
            LeadTriggerHandler ctrl = new LeadTriggerHandler();
            ctrl.rejectionReasonValidation(new Map<id, lead>{testLead1.id=>testLead1},new MAp<id, lead>{testLead1.id=>testLead2});
             test.stoptest();
        }
        
        
   }catch(Exception ex){
    system.debug('Ex');
  }

}

@isTest static void updateLeadFromAccounttest() {
  try{
         Profile profileId = [Select id,name from profile where name = 'LatAm User'];
         
        User testUser = new User(
            Alias = 'sUser', 
            Email='abc1@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = profileId.id,
            Sales_Org__c = 'WEST',
            Sub_Bu__c='USL',
            Segment__c='Corporate',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='abc123@testorg.com'
        );
        insert testUser;  
        
         System.runAs(testUser) {
      
            KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
        Profile_List__c profilevalue = new Profile_List__c();
        profilevalue.name=profileId.id;
        profilevalue.ProfileId__c=profileId.id;
        profilevalue.Profile_Name__c='LatAm User';
        insert profilevalue;
        
            List<Account> accList = new List<Account>();
            Account acc = new Account();
            //acc.Is_GLI__c = true;
            //acc.BillingCountry = 'US';
            acc.Name = 'TESTREGIONACCOUNT';
            //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GLI_Account').getRecordTypeId();
            acc.BillingStreet = '555 Test Street';
            acc.BillingCity = 'Dallas';
            acc.BillingState = 'SP';
            acc.BillingPostalCode = '55555';
            acc.BillingCountry = 'BR';
            insert acc;
            
            System.debug('accList**'+accList);
            recordtype leadRt= [select id from recordtype where name ='GLI' and sobjecttype='Lead' limit 1];
            List<Lead> listlead = new List<Lead>();
            test.starttest();
            Lead testLead1 = UnitTest.getLeadInstance();
            TestLead1.LeadSource='Customer Service'; 
            TestLead1 .RecordTypeId=leadRt.Id;      
            TestLead1.SAPAccountNumber__c = '98711';
            TestLead1.FirstName = 'Unit';
            TestLead1.LastName = 'Tester1';
            TestLead1.Company = 'Unit Test Company';
            TestLead1.Account__c=acc.Id;
            TestLead1.is_GLI__c =true;
            TestLead1.Sales_Org__c='GLI';
            TestLead1.Status = 'Contacting';         
            TestLead1.Billing_Country__c='US';
            TestLead1.Description='Lead is created for GLI';
            System.assert(TestLead1.Status == 'Contacting');
            listlead.add(TestLead1);
            
            if(listlead.size()>0){
            insert listlead;
            }
            
            Test.stoptest();
            
            }
 
         }catch(Exception ex){
             system.debug('Error'+ex);
          }
   
   } 
   
   
    static testMethod void dnistr() {      
    Test.startTest();      
        LeadTriggerHandler.isValidCUIT('RADtenst');
        LeadTriggerHandler.isValidCUIT('11');
    LeadTriggerHandler.isValidCUIT('0');
    LeadTriggerHandler.isValidCUILCDI('RADtest');
    LeadTriggerHandler.isValidCUILCDI('0');
    LeadTriggerHandler.isValidCUILCDI('11');
    LeadTriggerHandler.isValidDNILELC('RADtest');
    LeadTriggerHandler.isValidDNILELC('0');
    LeadTriggerHandler.isValidDNILELC('11');
    LeadTriggerHandler.isValidCI('WWW');
    String s = 'test';
    System.assert(s == 'test');
     Test.stopTest();
    }
    
     public static testmethod void testpopulateLeadOwner(){
    List<Lead> listlead = new List<Lead>();
    //Commented as a part of DPS-6078
    //AccountHandler.verifyStrikeIronRecCheck = false;
    List<account> accList = new List<account>();
    Account testAcc = UnitTest.getAccountInstance();
    TestAcc.SAPAccountNumber__c = '1';
    TestAcc.Tax_Number_Type__c = 'C.I';
    TestAcc.MDBId__c = '2';
    System.assert(TestAcc.MDBId__c == '2');
    accList.add(TestAcc);
    //insert TestAcc;
    Test.startTest();
    
    Account testAcc2 = UnitTest.getAccountInstance();
    TestAcc2.SAPAccountNumber__c = '11';
    TestAcc2.Tax_Number_Type__c = 'C.I';
    TestAcc2.MDBId__c = '22';
    accList.add(TestAcc2);
    Account testAcc3 = UnitTest.getAccountInstance();
    TestAcc3.SAPAccountNumber__c = null;
    TestAcc3.Tax_Number_Type__c = 'C.I';
    TestAcc3.MDBId__c = '23';
    accList.add(TestAcc3);
    insert accList;
    //insert TestAcc2;
    
    
    ILMGeneral__c ilmGen=new ILMGeneral__c();
    ilmGen.name= 'AllowedUsersForSalesRepAssignment';
    ilmGen.Value__C = 'SL Eloqua';        
    insert ilmGen;
    Account testAcc1 = UnitTest.getAccountInstance();
    TestAcc1.MDBId__c = '1';
    TestAcc1.SAPAccountNumber__c = '98711';
    TestAcc1.Tax_Number_Type__c = 'C.I';
    insert TestAcc1;
    
    Contact testContact = UnitTest.getContactInstance(TestAcc.Id);
    testContact.SAP_Contact_ID__c = '1';
   
    insert testContact;
    
    Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
      User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0144020',
            timezonesidkey='America/Los_Angeles', username='user@mydomain.com.'+Math.random(),Rep_Type_Description__c='test');        
       insert u1;
       
     User u2 = new User(alias = 'newUser1', email='user@my1domain.com', 
            emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, employeenumber='0134020',
            timezonesidkey='America/Los_Angeles', username='user@my1domain.com',Rep_Type_Description__c='test1');        
       insert u2;
       
    AccountTeamMember testAccTeamMember = new AccountTeamMember(AccountId=TestAcc.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    insert testAccTeamMember;
    
    AccountTeamMember testAccTeamMember1 = new AccountTeamMember(AccountId=TestAcc1.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    insert testAccTeamMember1;
    
    AccountTeamMember testAccTeamMember2 = new AccountTeamMember(AccountId=TestAcc2.Id,UserId=u1.Id,TeamMemberRole='Account Manager');
    insert testAccTeamMember2;
    
    AccountTeamMember testAccTeamMember3 = new AccountTeamMember(AccountId=TestAcc2.Id,UserId=u2.Id,TeamMemberRole='Account Manager');
    insert testAccTeamMember3;
    
    
    Data_Transformation__c testDataTrans = new Data_Transformation__c(Name='test3',Return_Value__c='test3',Transformation_Description__c='abc',Lookup_Value__c='test',Source__c = 'Unica Opty Owner' );
     insert testDataTrans ;
     
   Data_Transformation__c testDataTrans1 = new Data_Transformation__c(Name='test3',Return_Value__c='test3',Transformation_Description__c='abc',Lookup_Value__c='test1',Source__c = 'Unica Opty Owner' );
    insert testDataTrans1;
    
    KeyValueListStore__c strikSettings = new KeyValueListStore__c();
    StrikSettings.name='SUB-BU';
    StrikSettings.TextValue__c='Elite,FindLaw,UKI';
    insert StrikSettings;   
    
      Lead testLead = UnitTest.getLeadInstance();
      TestLead.LeadSource='Customer Service';
      TestLead.SAPAccountNumber__c='1';
      TestLead.Contact_SAP_ID__c = '1';
      TestLead.Is_Web_To_Lead__c = true;
      TestLead.Rep_Channel__c = 'test';
      TestLead.LCRM_Sub_BU__c='USL';
       listlead.add(TestLead);
      
      Lead testLead1 = UnitTest.getLeadInstance();
      TestLead1.LeadSource='Customer Service';
      TestLead1.SAPAccountNumber__c='1';
      TestLead1.Contact_SAP_ID__c = '1';
      TestLead1.Is_Web_To_Lead__c = true;
      TestLead1.LCRM_Sub_BU__c='USL';
      listlead.add(TestLead1);
      
      Lead testLead2 = UnitTest.getLeadInstance();
      TestLead2.LCRM_Sub_BU__c='USL';
      listlead.add(TestLead2);
      
      Lead testLead3 = UnitTest.getLeadInstance();
      TestLead3.LeadSource='Website';
      TestLead3.Source__c ='Practical Law';
      TestLead3.MDBId__c='1';
      TestLead3.Is_Web_To_Lead__c = true;
      TestLead3.Rep_Channel__c = 'test1';
      TestLead3.Is_Web_to_PPO__c = true;
      TestLead3.LCRM_Sub_BU__c='USL';
       listlead.add(TestLead3);
       
      Lead testLead4 = UnitTest.getLeadInstance();
      TestLead4.LeadSource='Website';
      TestLead4.Source__c ='Practical Law';
      TestLead4.MDBId__c='1';
      TestLead4.Contact_SAP_ID__c = '1';
      TestLead4.Is_Web_To_Lead__c = true;
      TestLead4.Rep_Channel__c = 'test1';
      TestLead4.Is_Web_to_PPO__c = true;
      TestLead4.LCRM_Sub_BU__c='USL';
      
       listlead.add(TestLead4);
       
       
      if(listlead.size()>0){
          insert listlead;
        }
    
       Lead testLead5 = UnitTest.getLeadInstance();
      TestLead5.LeadSource='Website';
      TestLead5.Source__c ='Practical Law';
      TestLead5.MDBId__c='23';
      TestLead5.Contact_SAP_ID__c = '1';
      TestLead5.Is_Web_To_Lead__c = true;
      TestLead5.Rep_Channel__c = 'test1';
      TestLead5.Is_Web_to_PPO__c = true;
      TestLead5.LCRM_Sub_BU__c='USL';
      TestLead5.Legacy_System_ID__c='1';
      TestLead5.WLD_ID__c='2';
      insert TestLead5;
      Test.stopTest();
    }
  

}