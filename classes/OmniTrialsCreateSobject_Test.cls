/** 
 * @description : Test class
* Class         : OmniTrialsCreateSobject_Test
* Purpose       : Test class codevoverage for OmniTrialsCreateSobject
* Created Date  : 06-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
@isTest
public class OmniTrialsCreateSobject_Test {
    
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
        der.oLCStatus = 'uStatus';
        der.appid = 'uDomain';
        OmniContactsWrapper.contactsWrapper cw = new OmniContactsWrapper.contactsWrapper(der);
        system.assertEquals(true,cw!= null, 'SUCCESS');
        
        Product2 prdList = new Product2();
        prdList.ProductCode='test';
        prdList.Name = 'Test';
        
        
          Account acc = new Account();
          acc.name = 'test acc';
          acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GLI Account').getRecordTypeId();  
          acc.BU_Region__c = 'Canada';
          acc.Bu_Segment__c = 'Professional Tax';
          acc.Is_GLI__c = true;
          insert acc;
          
          Opportunity testOpportunity = UnitTest.getOpportunityInstance(acc.Id);        
        Ent_Trial__c trl= new Ent_Trial__c();
        trl.Account__c = acc.id;
        trl.Opportunity__c = testOpportunity.id;
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
        trlCon.Last_Name__c = 'NET_NEW';
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
        olcOnepassVar.profileType = 'NEW_CUSTOMER';
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
        tw.trialstatus='active';
        tw.gsiPrimaryFlag = true;
        tw.onlineContactDesignation = true;
        tw.oLCStatus = 'active';
        tw.olcOnePass = olcOnepassVar;
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
        
        OmniTrialWrapper res = OmniTrialsCreateSobject.saveTrialAndChildSobjects(trl ,system.JSON.Serialize(products), system.JSON.Serialize(trlContacts)); 
        system.assertEquals(true,res!= null,'SUCCESS');
    }
}