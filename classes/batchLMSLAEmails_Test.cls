@isTest
class batchLMSLAEmails_Test{
    public static TestMethod void SLAEmails(){

        try{
            ILMGeneral__c ilmGen=new ILMGeneral__c();
            ilmGen.name= 'AllowedProfilesForSLAEmails';
            ilmGen.Value__C = 'System Administrator';        
            insert ilmGen;
            
            Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'newUser', email='user@mydomain.com', 
            emailencodingkey='UTF-8', lastname='Eloqua',FirstName='SL', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, Rep_Employee_Number__c='0130083',
            timezonesidkey='America/Los_Angeles', username='user123@mydomain.com',Rep_Type_Description__c='test');        
            insert u1;
            
            system.runAs(u1){
                createLMSLA();    
                List<Lead> leadList= new List<Lead>();
                leadList = createLEads();
                if(leadList!= null && leadList.size() >0){
                    
                    leadList[1].Lead_Scoring_Combined__c = 'A22';
                    
                    //leadList[0].Convert_SLA_Warning_Date__c  = System.Today() -2;
                    insert leadList;            
                } 
                
                boolean isAccept = true;
                boolean isConvert = true;
                string Query= 'SELECT Id,Name,Accept_By__c,Accept_SLA_Violation_End_Date__c,Accept_SLA_Warning_Date__c,Accept_By_Date__c,Regional_Manager__c,owner.Email,owner.profile.name,Sales_Org__c FROM LEAD WHERE Status = \'Unworked\' AND Business_Org__c != null AND Lead_Scoring_Combined__c != null  AND  Accept_SLA_Warning_Date__c <= TODAY AND Accept_By_Date__c > TODAY ';
                batchLMSLAEmails temp= new batchLMSLAEmails (Query,isAccept,false);
                Id batchprocessID= Database.ExecuteBatch(temp,5);
                
                string Query1= 'SELECT Id,Name,Accept_By__c,Accept_SLA_Violation_End_Date__c,Accept_SLA_Warning_Date__c,Accept_By_Date__c,Regional_Manager__c,owner.Email,Sales_Org__c FROM LEAD WHERE Status = \'Unworked\' AND Business_Org__c != null AND Lead_Scoring_Combined__c != null AND Accept_By_Date__c <= TODAY AND Accept_SLA_Violation_End_Date__c >= TODAY ';
                batchLMSLAEmails temp1= new batchLMSLAEmails (Query1,isAccept,false);
                Id batchprocessID2= Database.ExecuteBatch(temp1,5);
                
                string Query2= 'SELECT Id,Name,Convert_By__c,Convert_SLA_Violation_End_Date__c,Convert_SLA_Warning_Date__c,Convert_By_Date__c,Regional_Manager__c,owner.Email,Sales_Org__c FROM LEAD WHERE Status NOT IN(\'Discarded\',\'Converted\') AND Business_Org__c != null AND Lead_Scoring_Combined__c != null  AND  Convert_SLA_Warning_Date__c <= TODAY AND Convert_By_Date__c > TODAY ';
                batchLMSLAEmails temp2= new batchLMSLAEmails (Query2,false,isConvert);
                Id batchprocessID3= Database.ExecuteBatch(temp2,5);
                
                string Query3=  'SELECT Id,Name,Convert_By__c,Convert_SLA_Violation_End_Date__c,Convert_SLA_Warning_Date__c,Convert_By_Date__c,Regional_Manager__c,owner.Email,Sales_Org__c FROM LEAD WHERE Status NOT IN(\'Discarded\',\'Converted\') AND Business_Org__c != null AND Lead_Scoring_Combined__c != null AND Convert_By_Date__c <= TODAY AND Convert_SLA_Violation_End_Date__c >= TODAY ';
                batchLMSLAEmails temp3= new batchLMSLAEmails (Query3,false,isConvert);
                Id batchprocessID4= Database.ExecuteBatch(temp3,5);
            
            }
        }
        catch(Exception ex){
             system.debug('$$ Batch Exception'+ex.getMessage());        
        
        }
    
    }
    
    private static List<LEAD> createLEads(){
        List<LEAD> LeadLst=new List<LEAD>();
        for(integer i=0;i<5;i++){
        
            Lead l1= new Lead();
            l1.FirstNAme='Test1'+ i;
            l1.LAstNAme='Test2' + i;
            l1.Company='companyTest' +i;
            l1.Status= 'UnWorked';
            l1.Business_org__c= 'Corporate';
            l1.Lead_Scoring_Combined__c ='A11';
            LeadLst.add(l1);
        
        }        
        return LeadLst;       
    
    }
    
    private static void createLMSLA(){    
        
        List<LM_SLA__c> lmSLAList= new  List<LM_SLA__c>();
        LM_SLA__c lmsla1= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='A11',Conversion_SLA__c= 2,Acceptance_SLA__c=2,Accept_By_SLA_Warning_period__c= 3,
                                        Convert_By_SLA_Warning_Period__c =3,Accept_By_SLA_Violation_period__c=2,
                                        Convert_By_SLA_Violation_period__c=2,Send_AcceptBy_Violation_Email__c=true,
                                        Send_AcceptBy_Warning_Email__c =true,Send_Convert_By_Violation_Email__c =true,
                                        Send_Convert_By_Warning_Email__c =true);
        lmSLAList.add(lmsla1);        
        LM_SLA__c  lmsla2= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='A22',Conversion_SLA__c= 0,Acceptance_SLA__c=0,Accept_By_SLA_Violation_period__c=1,Convert_By_SLA_Violation_period__c=1,        
                                        Send_AcceptBy_Violation_Email__c=true,
                                        Send_Convert_By_Violation_Email__c =true
                                        );
        lmSLAList.add(lmsla2);
        
        if(lmSLAList!= null){
        insert lmSLAList;
        }
        
    
    }
    
    
}