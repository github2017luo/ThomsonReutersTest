/******************************************************************************************
* Class         : OmniCalloutMockResponseGenerator
* @description  : test
* @param        : NA
* @return       : NA
* Created Date  : 07-May-2021
* Author        : TCS Developer 
* ****************************************************************************************/
public class OmniCalloutMockResponseGenerator {
 /** 
* @description jsonGenerator the Response.
* @return str 
*/ 
    public static string jsonGenerator(){
        
        OmniEsiResponseWrapper.Address adr = new OmniEsiResponseWrapper.Address();
        adr.firstName = 'Test1';
        adr.lastName = 'User1';
        
        OmniEsiResponseWrapper.Account acc = new OmniEsiResponseWrapper.Account();
        acc.accountNumber = '1004635821';
        acc.companyId = 'WEST';
        
        list<OmniTrialOnlineContactWrapper.Entitlements> etls = new  list<OmniTrialOnlineContactWrapper.Entitlements>();
         
         
        OmniTrialOnlineContactWrapper.Entitlements etl3 = new OmniTrialOnlineContactWrapper.Entitlements();
        etl3.applicationId ='Test';
        etl3.status='ACTIVE';
        etl3.appUserGuid= 'i0accd0bb00000177d91dc8d1e9a8f424';
        etl3.accessStartDate ='2021-02-25';
        etl3.accessEndDate='9999-12-31';
        etl3.registered=true;
        //etl3.detailsIncomplete=false;
        etl3.authFirstName='Test1';
        etl3.authLastName='User1';
        etl3.authEmail='FEBTest5.corp1.user1@mailinator.com';
        etl3.authId='235ffaaa644a403e9bf2c1ab598fae2b';
        //etl3.logonName ='FEBTest5.corp1.user1@mailinator.com';
        //etl3.appUserRefIdPrimary = true;
        //etl3.appUserRefIdNickName='TEST';
        //etl3.lastPasswordChangeDate ='9998-12-31T23:59:59.9999999';
        etl3.authenticationSystem = 'ONE_PASS';

        etls.add(etl3);
        
        OmniTrialOnlineContactWrapper.Entitlements etl4 = new OmniTrialOnlineContactWrapper.Entitlements();
        etl4.applicationId ='Test';
        etl4.status='INACTIVE';
        etl4.appUserGuid= 'i0accd0bb00000177d91dc8d1e9a8f424';
        etl4.accessStartDate ='2021-02-25';
        etl4.accessEndDate='9999-12-31';
        etl4.registered=true;
        //etl4.detailsIncomplete=false;
        etl4.authFirstName='Test1';
        etl4.authLastName='User1';
        etl4.authEmail='FEBTest5.corp1.user1@mailinator.com';
        etl4.authId='235ffaaa644a403e9bf2c1ab598fae2b';
        //etl4.logonName ='FEBTest5.corp1.user1@mailinator.com';
        //etl4.appUserRefIdPrimary = true;
        //etl4.appUserRefIdNickName='TEST';
        //etl4.lastPasswordChangeDate ='9998-12-31T23:59:59.9999999';
        etl4.authenticationSystem = 'ONE_PASS';

        etls.add(etl4);
        
        
        OmniTrialOnlineContactWrapper.Entitlements etl = new OmniTrialOnlineContactWrapper.Entitlements();
        etl.applicationId ='COBALT';
        etl.status='ACTIVE';
        etl.appUserGuid= 'i0accd0bb00000177d91dc8d1e9a8f424';
        etl.accessStartDate ='2021-02-25';
        etl.accessEndDate='9999-12-31';
        etl.registered=true;
        //etl.detailsIncomplete=false;
        etl.authFirstName='Test1';
        etl.authLastName='User1';
        etl.authEmail='FEBTest5.corp1.user1@mailinator.com';
        etl.authId='235ffaaa644a403e9bf2c1ab598fae2b';
        //etl.logonName ='FEBTest5.corp1.user1@mailinator.com';
        //etl.appUserRefIdPrimary = true;
        //etl.appUserRefIdNickName='TEST';
        //etl.lastPasswordChangeDate ='9998-12-31T23:59:59.9999999';
        etl.authenticationSystem = 'ONE_PASS';
        etls.add(etl);
        
        OmniTrialOnlineContactWrapper.Entitlements etl1 = new OmniTrialOnlineContactWrapper.Entitlements();
        etl1.applicationId ='DATAROOM';
        etl1.status='ACTIVE';
        etl1.appUserGuid= 'i0accd6a200000177d91dccc1509a92ec';
        etl1.accessStartDate ='2021-02-25';
        etl1.accessEndDate='9999-12-31';
        etl1.authenticationSystem = 'ONE_PASS';
        etls.add(etl1);
        
        OmniTrialOnlineContactWrapper.Entitlements etl2 = new OmniTrialOnlineContactWrapper.Entitlements();
        etl2.applicationId ='COBALT';
        etl2.status='INACTIVE';
        etl2.appUserGuid= 'i0accd0bb00000177d91dc8d1e9a8f424';
        etl2.accessStartDate ='2021-02-25';
        etl2.accessEndDate='9999-12-31';
        etl2.registered=true;
        //etl2.detailsIncomplete=false;
        etl2.authFirstName='Test1';
        etl2.authLastName='User1';
        etl2.authEmail='FEBTest5.corp1.user1@mailinator.com';
        etl2.authId='235ffaaa644a403e9bf2c1ab598fae2b';
        //etl2.logonName ='FEBTest5.corp1.user1@mailinator.com';
        //etl2.appUserRefIdPrimary = true;
        //etl2.appUserRefIdNickName='TEST';
        //etl2.lastPasswordChangeDate ='9998-12-31T23:59:59.9999999';
        etl2.authenticationSystem = 'ONE_PASS';
        etls.add(etl2);
       
        
        list<OmniEsiResponseWrapper.OnlineContact> onls = new  list<OmniEsiResponseWrapper.OnlineContact>();
        OmniEsiResponseWrapper.OnlineContact  onl = new OmniEsiResponseWrapper.OnlineContact();
        onl.contactNumber = '0006500519';
        onl.address = adr;
        onl.account = acc;
        onl.sourceId = 'SAP';
        onl.endDate = '9999-12-31T00:00:00.000-06:00';
        onl.entitlements = etls;
        onl.onlineContactType ='0100';
        onl.allowContactEmails = false;
        onls.add(onl);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('ESIHeader');
        gen.writeStartObject();
        gen.writeStringField('applicationId', 'CXODT');
        gen.writeEndObject();
                
        gen.writeFieldName('onlineContact');
        gen.writeObject(onls);

        
        gen.writeEndObject();
        string str = gen.getAsString();
        
        return str;
    }
}