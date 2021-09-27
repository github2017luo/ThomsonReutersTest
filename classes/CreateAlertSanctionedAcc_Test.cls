/*
    Test Class : Created for Process Builder - Create Account Alert on Sanctioned Accounts
    Developer : TCS OffShore
*/
@isTest
public class CreateAlertSanctionedAcc_Test{
 
   
    public static testMethod void testAccWithAccAlert() {
        
        List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            
        oAccountB.Sanctioned_Status__c = 'Sanctioned';
        oAccountB.Is_GLI__c = true;
        update oAccountB;
    }   
    
    public static testMethod void testAccWithAccAlert1() {
    
        LTS_Disable_Application_Automation__c ltstemp = new LTS_Disable_Application_Automation__c();
        ltstemp.LTS_Disable_Process_Builders__c = true;
        ltstemp.Name = 'temp';
        ltstemp.SetupOwnerId = userinfo.getuserid();
        insert ltstemp; 
        
        List<RecordType> recordtypeIDs=[SELECT Id,DeveloperName,IsActive FROM RecordType WHERE DeveloperName LIKE '%GLI%' AND SobjectType = 'Account' and IsActive =true];
            List<GLI_Record_type_Ids__c> listofRecordtype = new List<GLI_Record_type_Ids__c>();
            GLI_Record_type_Ids__c oAccRecordtype = new GLI_Record_type_Ids__c ();
            oAccRecordtype.name ='GLI Account';       
            oAccRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[0].Id;
            listofRecordtype.add(oAccRecordtype);
            
            GLI_Record_type_Ids__c accRecordtype = new GLI_Record_type_Ids__c ();
            accRecordtype.name ='GLI Account ECM';       
            accRecordtype.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtype);
            
            GLI_Record_type_Ids__c accRecordtypeValue = new GLI_Record_type_Ids__c ();
            accRecordtypeValue.name ='GLI_Archive';       
            accRecordtypeValue.GLI_Account_RecordTypeId__c = recordtypeIDs[1].Id;
            listofRecordtype.add(accRecordtypeValue);
            
            if(listofRecordtype.size()>0){
                insert listofRecordtype;            
            }
            List<Account> accountlst = new List<Account>();
            Account oAccountA = UnitTest.getAccountInstance();
            oAccountA.Is_GLI__c=true;
            accountlst.add(oAccountA);
            
            Account oAccountB = UnitTest.getAccountInstance();
            oAccountB.Is_GLI__c=true;
            accountlst.add(oAccountB);
            
            if(accountlst.size()>0){
                insert accountlst;
            }
            
       
    }   

}