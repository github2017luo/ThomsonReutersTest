/*
    Process Builder - Update Panorama Lead Stage Field for Corporate leads
*/
@isTest
public class UpdatePanoramaLeadStagePB_Test{
    
    @testSetup static void addKeyValueStore() {
        KeyValueListStore__c profilename = new KeyValueListStore__c();
        profilename.TextValue__c = 'TR Corp Partner Community User';
        profilename.Name = 'LTS_partnerUserProfileName';
        insert profilename;
        
        KeyValueListStore__c leadsourcevalue = new KeyValueListStore__c();
        leadsourcevalue.Name = 'LTS_partnerUserLeadSourceValue';
        leadsourcevalue.TextValue__c = 'Partner';
        insert leadsourcevalue;
        
        KeyValueListStore__c busegment = new KeyValueListStore__c();
        busegment.Name = 'LTS_partnerUserBUSegmentValue';
        busegment.TextValue__c = 'Corporate';
        insert busegment;
    }
    
    public static testmethod void setSLAFromSLAAdminTable(){
        
        recordtype leadRT = [select id from recordtype where name ='Elite' and sobjecttype='Lead' limit 1];
        
        Lead lead = UnitTest.getLeadInstance();
        lead.LastName='Patel';
        lead.Company = 'UTLeadAccount';
        lead.Billing_City__c = 'test';
        lead.Billing_Street__c = 'test';
        lead.Billing_State__c = 'CA';
        lead.Billing_Zip__c = 'test';
        lead.Billing_Country__c = 'US';
        lead.email = 'abc@gmail.com';
        //lead.Contact__c = contact.Id;
        lead.RecordTypeId = leadRT.Id;
        lead.Is_GLI__c = true;
        lead.LCRM_Sub_BU__c = 'Elite';
        lead.BU_Segment__c = 'Corporate';
        lead.Status ='Unworked';
        lead.Lead_Scoring_Combined__c  = 'A4';
        insert lead;
        
        Lead lead1 = UnitTest.getLeadInstance();
        lead1.LastName='Patel';
        lead1.Company = 'UTLeadAccount';
        lead1.Billing_City__c = 'test';
        lead1.Billing_Street__c = 'test';
        lead1.Billing_State__c = 'CA';
        lead1.Billing_Zip__c = 'test';
        lead1.Billing_Country__c = 'US';
        lead1.email = 'abcd@gmail.com';
        //lead.Contact__c = contact.Id;
        lead1.RecordTypeId = leadRT.Id;
        lead1.Is_GLI__c = true;
        lead1.LCRM_Sub_BU__c = 'Elite';
        lead1.BU_Segment__c = 'Corporate';
        lead1.Status ='Unworked';
        lead1.Lead_Scoring_Combined__c  = 'A2';
        insert lead1;
        
        lead1.Lead_Scoring_Combined__c  = 'A1';
        update lead1;
    
      }
      
       public static void createLMSMA(){
      
          ILMGeneral__c ilmGen=new ILMGeneral__c();
          ilmGen.name= 'AllowedUsersForSalesRepAssignment';
          ilmGen.Value__C = 'SL Eloqua';        
          insert ilmGen;
               
          
          List<LM_SLA__c> lmSLAList= new  List<LM_SLA__c>();
          LM_SLA__c lmsla1= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='A2',Conversion_SLA__c= 2,Acceptance_SLA__c=2);
          lmSLAList.add(lmsla1);
          
          LM_SLA__c  lmsla2= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='N/A',Conversion_SLA__c= 2,Acceptance_SLA__c=2);
          lmSLAList.add(lmsla2);
          
          LM_SLA__c  lmsla3= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='B4',Conversion_SLA__c= 2,Acceptance_SLA__c=2);
          lmSLAList.add(lmsla3);
          
          //LM_SLA__c  lmsla4= new LM_SLA__c(Channel__c ='Corporate', Lead_Score__c='A1A2',Conversion_SLA__c= 2,Acceptance_SLA__c=2, Send_AcceptBy_Warning_Email__c =true);
          //lmSLAList.add(lmsla4);
          
          if(lmSLAList!= null){
              insert lmSLAList;
          }
          
      }
      
      
}