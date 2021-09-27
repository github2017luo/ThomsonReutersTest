/* Class: DCPCovertLead_Test
* Purpose: Test coverage for DCPConvertLead.cls, DCPConvertLeadUtility.cls,
*            DCPConvertLeadHandler.cls,
*           DCPConstants.cls
* Created: 06/14/2021
* Author: Kavya Ganagaraju
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 06/14/2021   Kavya G          DCP-1693    Created
* =============================================================================
*/

@isTest(seeAllData=false)
public class DCPConverLead_Test {
    
    @TestSetup
    static void convertLeadTestDataSetup(){
        
        // Create New Lead
        Lead newLead = new Lead();

        newLead.FirstName          ='Lead';
        newLead.LastName           ='Test';
        newLead.Email              ='LeadTest123@test.com';        
        newLead.IsConverted        =false;
        newLead.Company            ='CL Test LLC';
        newLead.Billing_Street__c  = 'Test Lead St';
        newLead.Billing_City__c    = 'Eagan';
        newLead.Billing_State__c   = 'MN';
        newLead.Billing_Country__c = 'US';
        newLead.PostalCode         = '55123';
        //newLead.Is_GLI__c          =true;

        insert newLead;

        //Create Cart
        Apttus_Config2__ProductConfiguration__c cart =
                    new Apttus_Config2__ProductConfiguration__c();
         cart = DCPTestDataFactory.createCart();
         insert cart;

         //Create lineItem
         Apttus_Config2__LineItem__c lineItem =
                    new Apttus_Config2__LineItem__c();
        lineItem = DCPTestDataFactory.createLineItem();
        lineItem.Apttus_Config2__ConfigurationId__c = cart.id;
        insert lineItem;

        //update lead with Cart Id
        newLead.Product_Configuration__c = cart.id;
        update newLead;
        
        //Insert Static values Custom settings
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>();
       
        Static_Values__c sv1 = new Static_Values__c(name='LeadSupportEmail', 
                            value__c= 'testLeadsupport@test.com');
        Static_Values__c sv2 = new Static_Values__c(name='SSDRecordType', 
                            value__c= 'LOTUS Source Systems');
        Static_Values__c sv3 = new Static_Values__c(name='PriceBookName', 
                            value__c= 'GLI Price Book - US Legal/LMS');
        Static_Values__c sv4 = new Static_Values__c(name='OrderProcessSupportEmail', 
                                                value__c= 'orderProcesssupport@test.com');
        
        staticCSList.add(sv1);
        staticCSList.add(sv2);
        staticCSList.add(sv3);
        staticCSList.add(sv4);
        insert staticCSList;

        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.LTS_Disable_Triggers__c = true;
        ltstemp.LTS_Disable_Validation_Rules__c = true;
        ltstemp.LTS_Disable_Workflow_Rules__c = true; 
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp;
    
         Profile p = [SELECT Id FROM Profile WHERE Name = 'ANZ Users' LIMIT 1];
        User u;
        u  = [Select ID, Sales_Org__c FROM User where Sales_Org__c = 'LRA'AND Profile.id =:p.id limit 1];
        LIST<KeyValueListStore__c> keyValueList = new LIST<KeyValueListStore__c>();
        KeyValueListStore__c kv = new KeyValueListStore__c(TextValue__c=p.id, name='ANZUsersProfileId' );
         KeyValueListStore__c kv1 = new KeyValueListStore__c(TextValue__c='Content,Functionality', name='ReasonWithCompetitor');
        keyValueList.add(kv);
        keyValueList.add(kv1);
        insert keyValueList;

       /* KeyValueListStore__c keyvaluestore=new  KeyValueListStore__c();
        keyvaluestore.Name='ANZUsersProfileId';
        keyvaluestore.TextValue__c='00e30000001ZUki';
        insert keyvaluestore;
     */
        
    } 
    
    @istest static void convertLeadTest1() {

        Lead l = [SELECT Id, email, firstname,lastName, company, isconverted,Billing_Street__c, Billing_City__c,
        Billing_State__c,Billing_Country__c, postalcode FROM Lead Limit 1];
        
        Apttus_Config2__ProductConfiguration__c cart = [SELECT Id  
                            FROM  Apttus_Config2__ProductConfiguration__c
                            LIMIT 1];
        DmlException dmlEx;
    
        Test.startTest();

        try{
            DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails clwdt = new DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails();

            clwdt.leadId = l.id;
            clwdt.cartId = cart.id;

            DCPConvertLead cLead = new DCPConvertLead();
            cLead.convertLeadInitiation(clwdt);  

        }
        catch(dmlException d){
            dmlEx = d;
        }
        
        Test.stopTest();

        system.assertEquals(null, dmlEx, 'Lead Conversion is Unsuccessful');

        
    }

    @istest static void convertLeadTest2() {

        Lead l = [SELECT Id, email, firstname,lastName, company, isconverted,Billing_Street__c, Billing_City__c,
        Billing_State__c,Billing_Country__c, postalcode FROM Lead Limit 1];

        Apttus_Config2__ProductConfiguration__c cart = [SELECT Id  
                            FROM  Apttus_Config2__ProductConfiguration__c
                            LIMIT 1];

        Account a = new Account();

        a.Name = l.company;
        a.Bu_Segment__C = 'Professional Legal';
        a.BillingStreet = l.Billing_Street__c;
        a.BillingCountry = l.Billing_Country__c;
        a.BillingCity = l.Billing_city__c;
        a.BillingState = l.Billing_State__C;
        a.Customer_Group__c = 'CORPORATION';
        a.Customer_class_c__c = 'LARGE';

        insert a;

        contact c = new contact();

        c.FirstName = l.firstname;
        c.lastname = l.LastName;
        c.email = l.email;
        c.AccountId = a.id;

        insert c;

        DmlException dmlEx;

        test.startTest();
       try{
            DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails clwdt = new DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails();

            clwdt.leadId = l.id;
            clwdt.cartId = cart.id;

            DCPConvertLead cLead = new DCPConvertLead();
            cLead.convertLeadInitiation(clwdt);  

        }
        catch(dmlException d){
            dmlEx = d;
        }
        
        Test.stopTest();

        system.assertEquals(null, dmlEx, 'Lead Conversion is Unsuccessful');

        
    }

    @istest static void convertLeadTest3() {


        test.startTest();
       try{
        DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails clwdt = new DCPConvertLeadHelperTwo.ConvertLeadWrapperDetails();

            DCPConvertLead cLead = new DCPConvertLead();
            cLead.convertLeadInitiation(clwdt);  

        }
        catch(Exception e){
            system.assert(e.getMessage().contains('Errors While Conversion of Lead convertion failed cartId or leadId is null'),true);
        }
        
        Test.stopTest();
        
    }

    @istest static void  beforeconvertLeadTest(){
        //checks to see if an exception is thrown if there is no Contact and account created.

        Lead l = [SELECT Id, email, firstname,lastName, company, isconverted,Billing_Street__c, Billing_City__c,
        Billing_State__c,Billing_Country__c, postalcode FROM Lead Limit 1];

        Apttus_Config2__ProductConfiguration__c cart;
        cart = [SELECT Id  
                            FROM  Apttus_Config2__ProductConfiguration__c
                            LIMIT 1];

        Account a = new Account();

        a.Name = l.company;
        a.Bu_Segment__C = 'Professional Legal';
        a.BillingStreet = l.Billing_Street__c;
        a.BillingCountry = l.Billing_Country__c;
        a.BillingCity = l.Billing_city__c;
        a.BillingState = l.Billing_State__C;
        a.Customer_Group__c = 'CORPORATION';
        a.Customer_class_c__c = 'LARGE';

        insert a;

        contact c = new contact();

        c.FirstName = l.firstname;
        c.lastname = l.LastName;
        c.email = l.email;
        c.AccountId = a.id;

        insert c;
        try{
            list<Lead> unConvertedLeads = new List<Lead>();
            unConvertedLeads.add(l);

            DCPConvertLead.convertLeadWrapper cwl = new DCPConvertLead.ConvertLeadWrapper();

            cwl.conIdw = c.Id;
            cwl.leadsw = unConvertedLeads;

            DCPConvertLead cLead = new DCPConvertLead();

            cLead.convertLeadDataCheck(cwl);
        }catch(Exception e){
            system.assert(e.getMessage().contains('convertion failed as your email or account is incorrect'),true);
        }

        

    }

    @istest static void  createNewAccountTest(){
        //checks to see if an exception is thrown if there is no Contact and account created.

        Lead l = [SELECT Id, email, firstname,lastName, company, isconverted,Billing_Street__c, Billing_City__c,
        Billing_State__c,Billing_Country__c, postalcode FROM Lead Limit 1];

        Map<String,String> existingContToAccMap = 
                            new Map<String,String>();
        DCPConvertLeadHelper cLeadHelper = new DCPConvertLeadHelper();
        try{
            cLeadHelper.createNewAccount(l, existingContToAccMap);
        }catch(Exception e){
            system.assert(e.getMessage().contains('Errors While Creation of Account / SSD'),true);
        }

    }


}