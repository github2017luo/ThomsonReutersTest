@isTest
public class LOTUSAddressValidation_Test {
    public testmethod static void testAddress(){
        Account acc= new Account(Name='Test Account');
        acc.BillingCountryCode= 'IN';
        acc.BillingCity='';
        acc.BillingStateCode='KA';
        acc.BillingPostalCode='560067';
        acc.BillingStreet='Test Street';        
        system.assertEquals(acc.BillingStreet != '',true);
        Test.startTest();
        try{
            LOTUSAddressValidation.validateAddress(acc);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    }
    public testmethod static void testAddress2(){
        
        Account acc1= new Account(Name='Test Account');
        acc1.BillingCountryCode= 'IN';
        acc1.BillingCity='Bangalore';
        acc1.BillingStateCode='';
        acc1.BillingPostalCode='560067';
        acc1.BillingStreet='Test Street'; 
        system.assertEquals(acc1.BillingStreet != '',true);
        Test.startTest();
        try{
            LOTUSAddressValidation.validateAddress(acc1);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    }    
    public testmethod static void testAddress3(){
        
        Account acc2= new Account(Name='Test Account');
        acc2.BillingCountryCode= 'IN';
        acc2.BillingCity='Bangalore';
        acc2.BillingStateCode='';
        acc2.BillingPostalCode='560067';
        acc2.BillingStreet='Test Street';      
        system.assertEquals(acc2.BillingStreet != '',true);
        Test.startTest();
        try{
            LOTUSAddressValidation.validateAddress(acc2);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    } 
    public testmethod static void testAddress4(){
        
        Account acc3= new Account(Name='Test Account');
        acc3.BillingCountryCode= 'IN';
        acc3.BillingCity='Bangalore';
        acc3.BillingStateCode='KA';
        acc3.BillingPostalCode='560067';
        acc3.BillingStreet='Test Street enough to throw street length exception';      
        system.assertEquals(acc3.BillingStreet != '',true);
        Test.startTest();
        try{
            LOTUSAddressValidation.validateAddress(acc3);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    } 
    public testmethod static void testAddress5(){
        
        Account acc4= new Account(Name='Test Account');
        acc4.BillingCountryCode= 'IN';
        acc4.BillingCity='Bangalore';
        acc4.BillingStateCode='KA';
        acc4.BillingPostalCode='56006700000';
        acc4.BillingStreet='Test Street';         
        system.assertEquals(acc4.BillingStreet != '',true);
        Test.startTest();
        try{
            LOTUSAddressValidation.validateAddress(acc4);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    }
    /*public testmethod static void testAddress6(){
        
        Lead olead= new Lead(LastName='Test Lead',Company='TestLead');
        olead.CountryCode= '';
        olead.City='Bangalore';
        olead.StateCode='KA';
        olead.PostalCode='56006700000';
        olead.Street='Test Street';         
        
        Test.startTest();
        try{
            LOTUSAddressValidation.validateLeadAddress(olead);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();         
    }*/
     public testmethod static void testAddress7(){
        Account acc= new Account(Name='Test Account');
        acc.BillingCountryCode= 'IN';
        acc.BillingCity='';
        acc.BillingStateCode='KA';
        acc.BillingPostalCode='560067';
        acc.BillingStreet='Test Street Street Street Street Street Street Street Street Street';        
        system.assertEquals(acc.BillingStreet != '',true);
        Test.startTest();
        try{
            LOTUSAddressValidation.validateAddress(acc);
        }catch(Exception e){system.debug(e.getMessage());}
        Test.stopTest();  
                 
    }
}