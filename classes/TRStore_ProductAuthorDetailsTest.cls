/* Class: TRStore_ProductAuthorDetailsTest
* Purpose: This class is Test class for TRStore_ProductAuthorDetails
* Created: 5-APR-2020
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date           Name           JIRA          Description
* 5-APR-2020   Kanishk        DLT-19888     Created 
* =============================================================================
*/
@isTest(seeAllData=false)
public class TRStore_ProductAuthorDetailsTest {

    @isTest static void testAuthorDetails() {
        
        Product_Author__c pa1 = new Product_Author__c();
        pa1.Author_ID__c = '1';
        pa1.Name= 'Test Author one';
        pa1.Author_Biography__c = 'Biography of Author one';
        database.insert(pa1,true);
        
        Product_Author__c pa2 = new Product_Author__c();
        pa2.Author_ID__c = '2';
        pa2.Name = 'Test Author two';
        pa2.Author_Biography__c = '';
        database.insert(pa2,true);
        
        
        RestResponse res = new RestResponse();
        res.addHeader('Content-Type', 'application/json');
        RestContext.response = res;
        
        RestRequest req1 = new RestRequest();
        req1.params.put('ANum','1');
        req1.requestURI = '/services/apexrest/AuthorDetails';  //Request URL
        req1.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req1;
        TRStore_ProductAuthorDetails.authorDetails();
         
        RestRequest req2 = new RestRequest();
        req2.params.put('ANum','1,2');
        req2.requestURI = '/services/apexrest/AuthorDetails';  //Request URL
        req2.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req2;
        TRStore_ProductAuthorDetails.authorDetails();
        
        RestRequest req3 = new RestRequest();
        req3.params.put('ANum','10');
        req3.requestURI = '/services/apexrest/AuthorDetails';  //Request URL
        req3.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req3;
        TRStore_ProductAuthorDetails.authorDetails();
   
    }
    
     

}