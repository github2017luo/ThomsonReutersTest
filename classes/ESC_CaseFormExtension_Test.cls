@isTest
public class ESC_CaseFormExtension_Test{
    
    static testmethod void escCaseFormExtension(){
        
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

            UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
            insert r;
         User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id,
              TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
              insert u;
              
        system.runAs(u){
              
              list<case> caselist =new list<case>();
            Account acc1 = new Account();
            Contact con = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert acc1;
            con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con;
           list<case> listcaseupdate =new list<case>();

            Case case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            Case case2 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case3 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case4 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case5= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            Case case6 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case7 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case8= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case9= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
           Case case10= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            Case case11= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            Case case12= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            case12.Form_Name__c ='test';
            Case case13= ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            case13.Form_Name_New__c ='test';
            listcaseupdate.add(case1);           
            listcaseupdate.add(case2);           
            listcaseupdate.add(case3);           
            listcaseupdate.add(case4);           
            listcaseupdate.add(case5);           
            listcaseupdate.add(case6);           
            listcaseupdate.add(case7);           
            listcaseupdate.add(case8);           
            listcaseupdate.add(case9);           
            listcaseupdate.add(case10);     
            listcaseupdate.add(case11);     
            listcaseupdate.add(case12);
            listcaseupdate.add(case13);
            
            Test.startTest();
             insert listcaseupdate; 
           /*list<case> caselist=new list<case>();
           
            case3 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'Work In Progress');
            case4 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'Work In Progress');

           caselist.add(case1);
           
           */
            
           GenerateForm__c formname =new GenerateForm__c();
           formname.Name='Order Correction 1';
           insert formname;
           
           GenerateForm__c formname1 =new GenerateForm__c();
           formname1.Name='Write Off Form';
           insert formname1;
           
           GenerateForm__c formname2 =new GenerateForm__c();
           formname2.Name='Billing Request Form';
           insert formname2;
           
           
           GenerateForm__c formname3 =new GenerateForm__c();
           formname3.Name='Billing Research Form';
           insert formname3;
           
           
          list<ESC_Case_Form_Extension__c> listecf =new list<ESC_Case_Form_Extension__c>();
          list<ESC_Case_Form_Extension__c> listecf1 =new list<ESC_Case_Form_Extension__c>();
           list<ESC_Case_Form_Extension__c> listecfupdate =new list<ESC_Case_Form_Extension__c>();
           
          
          
          ESC_Case_Form_Extension__c  ecf= new  ESC_Case_Form_Extension__c();
          
             ecf.Name='testform';
             ecf.ESC_Case__c=case1.id;
             ecf.ESC_Form__c=formname.id;
             ecf.Media_Type__c='Online';
             ecf.Product__c='Special Offer';             
             ecf.Online_Special_Offer__c='Yes';
            // ecf.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change';
            
             listecf.add(ecf);
             ESC_Case_Form_Extension__c  ecf11= new  ESC_Case_Form_Extension__c();
          
             ecf11.Name='testform';
             ecf11.ESC_Case__c=case12.id;
             ecf11.ESC_Form__c=formname.id;
             ecf11.Media_Type__c='Online';
             ecf11.Product__c='Special Offer';             
             ecf11.Online_Special_Offer__c='Yes';
            // ecf.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change';
            
             listecf.add(ecf11);
             ESC_Case_Form_Extension__c  ecf12= new  ESC_Case_Form_Extension__c();
          
             ecf12.Name='testform';
             ecf12.ESC_Case__c=case13.id;
             ecf12.ESC_Form__c=formname.id;
             ecf12.Media_Type__c='Online';
             ecf12.Product__c='Special Offer';             
             ecf12.Online_Special_Offer__c='Yes';
            // ecf.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change';
            
             listecf.add(ecf12);
             
           ESC_Case_Form_Extension__c  ecf1= new  ESC_Case_Form_Extension__c();
          
             ecf1.Name='testform1';
             ecf1.ESC_Case__c=case2.id;
             ecf1.ESC_Form__c=formname.id;
             ecf1.Media_Type__c='Online';
             ecf1.Product__c='Special Offer';             
             ecf1.Online_Special_Offer__c='NO';
             ecf1.USL_Approval_Status__c='Rejected';
             listecf.add(ecf1);
             
             ESC_Case_Form_Extension__c  ecf2= new  ESC_Case_Form_Extension__c();
          
             ecf2.Name='testform2';
             ecf2.ESC_Case__c=case3.id;
             ecf2.ESC_Form__c=formname1.id; 
             ecf2.ESC_Form_BU__c = 'USL';
             ecf2.Media_Type__c='Online';
             ecf2.Product__c='Other';             
             ecf2.Online_Special_Offer__c='NO';         
             ecf2.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change'; 
             ecf2.USL_Approval_Status__c='Approved';

             listecf.add(ecf2);             
             
             
             
             ESC_Case_Form_Extension__c  ecf3= new  ESC_Case_Form_Extension__c();
          
             ecf3.Name='testform4';
             ecf3.ESC_Case__c=case4.id;
             ecf3.ESC_Form_BU__c = 'USL';
             ecf3.ESC_Form__c=formname1.id;          
             ecf3.Request_Type_Post_Prod_Lapse2__c='Bill Pull Current Month Review';                 
             listecf.add(ecf3);
             
             ESC_Case_Form_Extension__c ecf4= new  ESC_Case_Form_Extension__c();          
             ecf4.Name='testform3';
             ecf4.ESC_Case__c=case5.id;
             ecf4.ESC_Form__c=formname1.id;
             ecf4.ESC_Form_BU__c = 'USL';          
             ecf4.Request_Type_Post_Prod_Lapse2__c='Modify Invoice';                 
             listecf.add(ecf4);        
             
             
               ESC_Case_Form_Extension__c  ecf5= new  ESC_Case_Form_Extension__c();
          
             ecf5.Name='testform5';
             ecf5.ESC_Case__c=case6.id;
             ecf5.ESC_Form_BU__c = 'USL';
             ecf5.ESC_Form__c=formname1.id;          
            // ecf5.Request_Type_Post_Prod_Lapse__c='Post Pro Lapse %-% Zero Out Current Month';                 
             listecf.add(ecf5);
             
             /*USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
            int1.Applicationid__c = 'ESCU';
            int1.Companyid__c = 'WEST';
            int1.name = 'Integrationdefaults';
            insert int1;*/
            
             ESC_Case_Form_Extension__c  ecf6= new  ESC_Case_Form_Extension__c();
          
             ecf6.Name='testform6';
             ecf6.ESC_Case__c=case7.id;
             ecf6.ESC_Form__c=formname1.id;  
             ecf6.ESC_Form_BU__c = 'USL';        
             ecf6.Request_Type_Post_Prod_Lapse__c='Billing Research';                 
             listecf.add(ecf6);
             
             ESC_Case_Form_Extension__c ecf7= new  ESC_Case_Form_Extension__c();          
             ecf7.Name='testform7';
             ecf7.ESC_Case__c=case8.id;
             ecf7.ESC_Form__c=formname1.id;    
             ecf7.ESC_Form_BU__c = 'USL';      
             ecf7.ESC_Request_Type_Account_Related__c='Change Account Address';                 
             listecf.add(ecf7);  

             ESC_Case_Form_Extension__c ecf8= new  ESC_Case_Form_Extension__c();          
             ecf8.Name='testform7';
             ecf8.ESC_Case__c=case9.id;
             ecf8.ESC_Form__c=formname1.id;          
             ecf8.Request_Type_Post_Prod_Lapse__c='Charge Only Request';
             ecf8.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change';
             ecf8.USL_Approval_Type__c='Writeoff';
             ecf8.ESC_Form_BU__c = 'UKI';
             listecf.add(ecf8); 
             ESC_Case_Form_Extension__c ecf9= new  ESC_Case_Form_Extension__c();          
             ecf9.Name='testform7';
             ecf9.ESC_Case__c=case10.id;
             ecf9.ESC_Form_BU__c = 'USL';
             ecf9.ESC_Form__c=formname1.id;          
             ecf9.ESC_Request_Type_Account_Related__c='Change Marketing/Sales data';            
             listecf.add(ecf9);     
                                                           
                Map<id,ESC_Case_Form_Extension__c> oldmap=new Map<id,ESC_Case_Form_Extension__c>();
            oldmap.put(ecf8.id,ecf8);
            Map<id,ESC_Case_Form_Extension__c> newmap=new Map<id,ESC_Case_Form_Extension__c>();
           newmap.put(ecf9.id,ecf9);
              ESC_CaseFormExtension.CaseUpdUpdate(listecf,oldmap);
              
              
              ESC_CaseFormExtension.ValidateRequesttype(oldmap,newmap);
                  
              insert listecf; 
             
          list<ESC_Case_Form_Extension__c >listece=[select id,name from ESC_Case_Form_Extension__c  where id =:listecf] ;   
             
             ESC_Case_Form_Extension__c ecf10= new  ESC_Case_Form_Extension__c();          
             ecf10.Name='testharsha';  
             ecf10.id=listece[0].id;
             ecf10.ESC_Case__c=case11.id;
             ecf10.ESC_Form_BU__c = 'USL';
             ecf10.ESC_Form__c=formname1.id;
             ecf10.USL_Approval_Status__c='Approved';          
             ecf10.ESC_Request_Type_Account_Related__c='Change Account Address';            
             listecf1.add(ecf10);              
             update listecf1;
            
               system.assertEquals(ecf10.ESC_Case__c,case11.id);
               Test.stopTest();
        }
           
            
            
        
        
    }
    
    static testmethod void escCaseFormExtension1(){
        
        
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

            UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
            insert r;

           User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id,
              TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
              insert u;
              
              system.runAs(u){
              list<case> caselist =new list<case>();
            Account acc1 = new Account();
            Contact con = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert acc1;
            con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con;
           list<case> listcaseupdate =new list<case>();

            Case case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            case1.Form_Name__c = 'Write Off Form';    
            insert case1;
            Test.startTest();
           GenerateForm__c formname1 =new GenerateForm__c();
           formname1.Name='Write Off Form';
           insert formname1;
           
          /* USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
            int1.Applicationid__c = 'ESCU';
            int1.Companyid__c = 'WEST';
            int1.name = 'Integrationdefaults';
            insert int1;*/
            
          ESC_Case_Form_Extension__c ecf8= new  ESC_Case_Form_Extension__c();          
             ecf8.Name='testform7';
             ecf8.ESC_Case__c=case1.id;
             ecf8.ESC_Form__c=formname1.id;          
             ecf8.USL_Approval_Type__c='Writeoff';
             ecf8.ESC_Form_BU__c = 'USL';
             
              insert ecf8; 
             
          //list<ESC_Case_Form_Extension__c >listece=[select id,name from ESC_Case_Form_Extension__c  where id =:listecf] ;   
             
             ESC_Case_Form_Extension__c ecf10= new  ESC_Case_Form_Extension__c();          
             ecf10.Name='testharsha';  
             ecf10.id=ecf8.id;
             ecf10.ESC_Case__c=case1.id;
             ecf10.ESC_Form__c=formname1.id;
             ecf10.ESC_Form_BU__c = 'USL';
             ecf10.USL_Approval_Status__c='Approved'; 
             ecf10.Request_Type_Post_Prod_Lapse__c='Charge Only Request';
             ecf10.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change';         
             ecf10.ESC_Request_Type_Account_Related__c='Change Account Address';            
                           
             update ecf10;
            
               system.assertEquals(ecf10.ESC_Case__c,case1.id);
               Test.stopTest();
              }
           
     }
     
     static testmethod void escCaseFormExtension2(){
        
        
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      

            UserRole r = new UserRole(DeveloperName = 'TR_Legal_Sales_Rep1', Name = 'My_Role');
            insert r;

            
          User u = new User(Alias = 'standt2', Email='sysadmin@2testorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id,
              TimeZoneSidKey='America/Los_Angeles',UserName='sysadmin2@testorg.com',UserRoleId = r.Id);
              insert u;
              
              system.runAs(u){
              list<case> caselist =new list<case>();
            Account acc1 = new Account();
            Contact con = new Contact();
            acc1 = ESC_GenericTestutility.TestAccountUtil('test account', '12345','9876543210');
            insert acc1;
            con =ESC_GenericTestutility.TestContactUtil(acc1.ID, 'test','contact','test7365@gmail.com');
            insert con;
           list<case> listcaseupdate =new list<case>();

            Case case1 = ESC_GenericTestutility.TestCaseUtil(con.ID,acc1.ID,'New');
            case1.Form_Name__c = 'Write Off Form';    
            insert case1;
            Test.startTest();
           GenerateForm__c formname1 =new GenerateForm__c();
           formname1.Name='Charge Cancellation';
           insert formname1;
           
           
          ESC_Case_Form_Extension__c ecf8= new  ESC_Case_Form_Extension__c();          
             ecf8.Name='testform7';
             ecf8.ESC_Case__c=case1.id;
             ecf8.ESC_Form__c=formname1.id;          
             //ecf8.USL_Approval_Type__c='Tax Profs - Software';
             
              insert ecf8; 
             
          //list<ESC_Case_Form_Extension__c >listece=[select id,name from ESC_Case_Form_Extension__c  where id =:listecf] ;   
            /* USL_Integration_defaults__c int1 = new USL_Integration_defaults__c();
            int1.Applicationid__c = 'ESCU';
            int1.Companyid__c = 'WEST';
            int1.name = 'Integrationdefaults';
            insert int1;*/
            
            ESC_Case_Form_Extension_Line_Item__c cLI = new ESC_Case_Form_Extension_Line_Item__c();
            cLI.USL_Invoice_Type__c = 'Open';
            cLI.ESC_Case_Form_Extension__c = ecf8.id;
            insert cLI;
        
             ESC_Case_Form_Extension__c ecf10= new  ESC_Case_Form_Extension__c();          
             ecf10.Name='testharsha';  
             ecf10.id=ecf8.id;
             ecf10.ESC_Case__c=case1.id;
             ecf10.ESC_Form__c=formname1.id;
             ecf10.USL_Approval_Status__c='Approved'; 
             ecf10.Request_Type_Post_Prod_Lapse__c='Charge Only Request';
             ecf10.Request_Type_Post_Prod_Lapse2__c='Billing Document Format Change';         
             ecf10.ESC_Request_Type_Account_Related__c='Change Account Address';            
                           
             update ecf10;
            
               system.assertEquals(ecf10.ESC_Case__c,case1.id);
               Test.stopTest();
              }
           
    }
    
}