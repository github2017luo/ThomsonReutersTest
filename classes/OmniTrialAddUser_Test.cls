/** 
 * @description : Test class
* Class         : OmniTrialAddUser_Test
* Purpose       : Test class codevoverage for OmniTrialsAddUserController
* JIRA Number:  DPS-21098
* Created Date  : 23-JUN-2021
* Author        : TCS Developer 
* ****************************************************************************************/
@isTest
public class OmniTrialAddUser_Test {
 /**
    * @description testMethod
    */
    @isTest
    public static void testMethod1(){
        
        OmniCallToOLCFetchOnlineContactsHelper.displayContactsWrapper der = new  OmniCallToOLCFetchOnlineContactsHelper.displayContactsWrapper();
        der.fname = 'fname';
        der.lname= 'lname';
        der.apguid= 'apguid';
        der.email = 'test@gmail.com';
        der.sAPConId='sAPConId';
        der.sFDCconid='sFDCconid';
        der.sAPAccid='sAPAccid'; 
        der.oLCStatus = 'Active';
        der.appid = 'uDomain';
        OmniContactsWrapper.contactsWrapper cw = new OmniContactsWrapper.contactsWrapper(der);
        system.assertEquals(true,cw!= null, 'SUCCESS');
        
        Product2 prdList = new Product2();
        prdList.ProductCode='test';
        prdList.Name = 'Test';
        
        
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
        
        list<TrialContactWrapper> trlContacts = new list<TrialContactWrapper>();
        TrialContactWrapper tw = new TrialContactWrapper();
        TrialOLCOnePassByEmailRespWrap olcOnepassVar = new TrialOLCOnePassByEmailRespWrap();
        olcOnepassVar.externalAccountNumber='1234567';
        olcOnepassVar.externalAccountNumberSource ='test';
        olcOnepassVar.companyId = 'CID00123';
        olcOnepassVar.cobaltGUID ='CGID0921';
        olcOnepassVar.dataRoomGUID = 'DRMGID002';
        tw.email = 'TEST@GMAIL.COM';
        olcOnepassVar.externalContactNumber = 'ex00312';
        olcOnepassVar.externalContactNumberSource ='Test';
        tw.firstName = 'fname';
        tw.lastName='lname';
        olcOnepassVar.onePassId ='12321232';
        tw.onlineContact=true;
        tw.fullName = 'fullname';
        tw.isPrimaySelectedFromUI = true;
        tw.trialId=trl.ID;
        tw.trialStatus='Active';
        tw.gsiPrimaryFlag = true;
        tw.onlineContactDesignation = true;
        tw.oLCStatus = 'Active';
        
        trlContacts.add(tw);
        
        List<TrialProductWrapper> products = new List<TrialProductWrapper>();
        TrialProductWrapper tpw = new TrialProductWrapper();
        tpw.trialPrdId = prd.id;
        tpw.trialPrdRecordId = trprd.id;
        tpw.bundleType='test';
        tpw.productCode = '4545455';
        //tpw.segmentType = 'TEST';
        tpw.materialType = 'test';
        tpw.productName = 'P2213323';
        products.add(tpw);

        OmniTrialWrapper res = OmniTrialsAddUserController.saveTrialAndChildSobjectsAddUser(trl ,system.JSON.Serialize(products), system.JSON.Serialize(trlContacts));
        OmniTrialsAddUserController.getExistingTrailDetailsAddUser(trl.Id,new list<Id>{trlCon.id});
        OmniTrialsAddUserController.getEntTrailSobjects(trl.id);
           
        system.assertEquals(true,res!= null,'SUCCESS');
    }
    
}