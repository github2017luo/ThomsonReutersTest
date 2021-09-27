/**
 * @description       : 
 * @author            : TCS team
 * @group             : 
 * @last modified on  : 06-18-2021
 * @last modified by  : tcs
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-18-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class OmniEntitlementOLCPostback_Test {
     
    @isTest
    public static void testMethod1(){
        string json = '{';
        json += '"trialId":"aOd2g0000004DLeCAM",';        
        json += ' "customerNumber":7001234567,';
        json += ' "products":[';
        json += '{';
        json += ' "productId":"2345678901",';
        json += '"referenceId":"aFB2g00000001eRGAQ",';
        json += ' "status":{';
        json += '  "statusCode":"COMPLETE",';
        json += '   "statusDescription":"Entitlement is done for all the contacts.1"';
        json += '  },';
        json += '  "contact":[';
        json += '    {';
        json += '      "contactNumber":"8001234567",';
        json += '      "extContactId":"aOe2g000000002ICAQ",';
        json += '     "profileIdentifier":"123dfgt7890jhffd",';
        json += '    "status":{';
        json += '      "statusCode":"COMPLETE",';
        json += '       "statusDescription":"User is entitled.1"';
        json += '   },';
        json += '    "users":[';
        json += '       {';
        json += '         "userGUID":"ACFHKDK73934943BDKDIM",';
        json += '         "domain":"COBALT"';
        json += '     },';
        json += '     {';
        json += '        "userGUID":"ABCHKDK73934943BDMORR",';
        json += '        "domain":"DATAROOM"';
        json += '      }';
        json += '   ]';
        json += '  }';
        json += '  ]';
        json += ' }';
        json += ' ]';
        json += '}';
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OmniEntitlementOLCPostback';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;
        OmniEntitlementOLCPostback.ResponseWrapper resp = OmniEntitlementOLCPostback.doPost();
        
        Test.stopTest();
        System.assertEquals(resp != null,true,'SUCCESS');
       
    }
    
     @isTest
    public static void testMethod2(){
       
        
        
        Account acc = new account();
        acc.name = 'test';
        acc.BillingCountry = 'US';
        acc.Billingcity= 'Baltimore'; 
        acc.billingstate= 'AK';
        ACC.BillingpostalCode='21204';
        
        insert acc;
        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Trial_Start_Date__c  =system.today();
        trl.Trial_End_Date__c = system.today();
        trl.External_Account_Number__c = '4332938';
        insert trl;
        
        
          Trial_Contact__c trlCon = new Trial_Contact__c();
        trlCon.Email__c = 'get2arpit@me.com';
        trlCon.Trials__c = trl.id;
        trlCon.name = 'test';
        trlCon.Status__c  = 'Draft';
        trlCon.First_Name__c = 'Fname';
        trlCon.Last_Name__c = 'lname';
        trlcon.Name= 'Test Name';
        insert trlCon;
        
        
        Product2 prd = new Product2();
        prd.DC_Product_Title__c = 'sample product';
        prd.Name ='TEST';
        prd.ProductCode = '824925';
        insert prd;
        
        Trial_Product__c trprd = new Trial_Product__c();
        trprd.Product_Name__c = prd.id;
        trprd.Trial__c = trl.id;
        trprd.Name= 'Test Name';
        insert trprd;  
        
        Trial_Product_Contact__c trialPrdCont= new Trial_Product_Contact__c();
        trialPrdCont.Trial_Contact__c = trlCon.id;
        trialPrdCont.Trial_Product__c = trprd.Id;
        trialPrdCont.Trials__c = trl.Id;
        insert trialPrdCont;
        
         string json = '{';
        json += '"trialId":"'+trl.id+'",';        
        json += ' "customerNumber":7001234567,';
        json += ' "products":[';
        json += '{';
        json += ' "productId":"2345678901",';
        json += '"referenceId":"'+trprd.Id+'",';
        json += ' "status":{';
        json += '  "statusCode":"COMPLETE",';
        json += '   "statusDescription":"Entitlement is done for all the contacts.1"';
        json += '  },';
        json += '  "contact":[';
        json += '    {';
        json += '      "contactNumber":"8001234567",';
        json += '      "extContactId":"'+trlCon.Id+'",';
        json += '     "profileIdentifier":"123dfgt7890jhffd",';
        json += '    "status":{';
        json += '      "statusCode":"COMPLETE",';
        json += '       "statusDescription":"User is entitled.1"';
        json += '   },';
        json += '    "users":[';
        json += '       {';
        json += '         "userGUID":"ACFHKDK73934943BDKDIM",';
        json += '         "domain":"COBALT"';
        json += '     },';
        json += '     {';
        json += '        "userGUID":"ABCHKDK73934943BDMORR",';
        json += '        "domain":"DATAROOM"';
        json += '      }';
        json += '   ]';
        json += '  }';
        json += '  ]';
        json += ' }';
        json += ' ]';
        json += '}';
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/OmniEntitlementOLCPostback';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;
        OmniEntitlementOLCPostback.ResponseWrapper resp = OmniEntitlementOLCPostback.doPost();
        
        Test.stopTest();
        list<Trial_Product_Contact__c> productContacts = new list<Trial_Product_Contact__c>();
        productContacts.add(trialPrdCont);
        OmniEntitlementOLCPostback.genarateRespForProdCont(false,true,productContacts);
        OmniEntitlementOLCPostback.genarateRespForProdCont(TRUE,FALSE,productContacts);
        System.assertEquals(resp != null,true,'SUCCESS');
       
    }
}