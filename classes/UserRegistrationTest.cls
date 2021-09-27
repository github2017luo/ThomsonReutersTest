@IsTest
public class UserRegistrationTest {
    public class MyException extends Exception {}
   
    @testSetup 
     static void setup(){
        //Insert account and SSD details
        Account acc = new Account(Name='Test Account',Is_GLI__c = true,SAPAccountNumber__c ='A123');
        insert acc;
        
        Contact obj_contact1 = new contact();
        obj_contact1.AccountId = acc.id;     
        obj_contact1.FirstName = 'Akshay';
        obj_contact1.LastName = 'Kakkar';
        obj_contact1.Email = 'akshaykakkar@thomsonreuters.com';
        obj_contact1.SAP_Contact_ID__c = '1234'  ;      
        Insert obj_contact1;
     }
    
    @isTest    
     private static void TestMissingDetails() {
        test.startTest(); 
        // Call the method to test
        RestRequest request = new RestRequest();
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String url = baseURL+'/services/apexrest/userRegister';            
        request.requestUri  = url; 
        request.httpMethod = 'POST';        
        RestContext.request = request;                                                         
        
         /***doPost(String sapContactID, String sapAccountNumber, String sapContactType, String emailId, 
                                                String role, String firstName, String lastName)**/
        
         /**************************************Error COnditions************************************/
         //One of the mandatory parameters not passed
         String returnValue = UserRegistration.doPost('','','61','akshaykakkar@thomsonreuters.com','Global User','','Kakkar');
         returnValue = UserRegistration.doPost('1212','A123','61','akshaykakkar@thomsonreuters.com','Global User','','Kakkar');
         //Account not available
         returnValue = UserRegistration.doPost('111','A124','61','akshaykakkar@thomsonreuters.com','Global User','Akshay','Kakkar');
         
         /**************************************Standard User and Admin User COnditions************************************/
         //Contact available
         returnValue = UserRegistration.doPost('1234','A123','61','akshaykakkar@thomsonreuters.com','Global User','Akshay','Kakkar');
        //Contact not available
         returnValue = UserRegistration.doPost('1235','A123','61','akshaykakkar@thomsonreuters.com','Global User','Akshay1','Kakkar1');
         test.stoptest();
    }
}