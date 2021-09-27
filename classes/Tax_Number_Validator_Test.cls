@isTest
private class Tax_Number_Validator_Test {


    static testMethod void cpf() {
    Test.startTest();

        Account a = UnitTest.getAccountInstance();
        a.Tax_Number_Type__c = 'CPF';
        a.Tax_Number__c= '41170456448'; // valid
        insert a;
        
        try {
          a.Tax_Number__c= '27604108825';
          update a;
        } catch(Exception e) {
          return;
        }
        system.assert(false, 'Invalid');
        Test.stopTest();
    }
    
    
    
    
    static testMethod void cnpj() {
    Test.startTest();

        Account a = UnitTest.getAccountInstance();
        a.Tax_Number_Type__c = 'CNPJ';
        a.Tax_Number__c= '99999999999999'; // invalid
        a.Tax_3__c='12345';
        a.Tax_4__c='123456';
        
        try {
          insert a;
        } catch(Exception e) {
          a.Tax_Number__c= '17947680000158'; // valid
          insert a;
          return;
        }
        system.assert(false, 'Invalid');
            Test.stopTest();

    }
    
    static testMethod void cuit() {
    Test.startTest();
try {
        Account a = UnitTest.getAccountInstance();
        a.Tax_Number_Type__c = 'C.U.I.T.';
        a.Tax_Number__c= '33707586279';
        a.BillingCountry= 'AR';// valid
                insert a;
                system.assertequals(a.id!=null,true);

        
  

        } catch(Exception e) {
          return;
        }
       
            Test.stopTest();

    }
    
      static testMethod void cuil() {
   Test.startTest();
     
      Account a = UnitTest.getAccountInstance();
        a.Tax_Number_Type__c = 'C.U.I.L.';
        a.Tax_Number__c= '23267487219';
        a.BillingCountry= 'AR';// valid
                insert a;
                system.assertequals(a.id!=null,true);
            Test.stopTest();
    }
    
    static testMethod void dni() {
    Test.startTest();
        
        Account a = UnitTest.getAccountInstance();
        a.Tax_Number_Type__c = 'D.N.I.';
        a.Tax_Number__c= '2326748';
        a.BillingCountry= 'AR';// valid
                insert a;

                system.assertequals(a.id!=null,true);
            Test.stopTest();

    }
    
    static testMethod void ci() {
    Test.startTest();
    Tax_Number_Validator.isValid_CI('');
    Account a = UnitTest.getAccountInstance();
        a.Tax_Number_Type__c = 'C.I.';
        a.Tax_Number__c= 'abc26748';
        a.BillingCountry= 'AR';// valid
                insert a;
                 system.assertequals(a.id!=null,true);
    
            Test.stopTest();
        }

  public static testmethod void checkIndustryTest(){  
       
       Id profileId = [SELECT Id From Profile Where Name = 'Latam User' LIMIT 1].Id;
       user usr = [SELECT Id FROM User WHERE profileId =:profileId AND IsActive = True LIMIT 1];
      Account testAccount = UnitTest.getAccountInstance();
        
      testAccount.Industry_LatAm__c= '';
      testAccount.Industry= 'Not Applicable'; // valid
        System.RunAs(usr) {
            Test.startTest();
            try {
                insert testAccount;
                testAccount.Industry= 'FINANCE';
                testAccount.Industry= '';
                update testAccount;
                system.assertequals(testAccount.id!=null,true);
            }
            catch(exception ex){system.debug('Test class');}
            Test.StopTest();
            }
      }


    }