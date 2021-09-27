@isTest
public class LTGS_MassMuteReAssignLead_Test {
   
    @istest static void dataone()
    { 
        List<Lead> lods=new List<Lead>();
        Lead lod1=new Lead();
        lod1.FirstName='Barry';
        lod1.LastName='Allen';
        lod1.Company='DC';
        lod1.Status='Telesales Qualified';
        //lod1.Customer_Sub_Type__c='Private';
        lod1.Country='IN';
        lod1.LCRM_Do_Not_Reassign__c=true;
        lods.add(lod1);
        insert lods;
        
        Test.startTest();
        test.setCurrentPage(Page.LTGS_MassMuteReassignmentChange_Lead);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lods);
        stdSetController.setSelected(lods);
        LTGS_MassMuteReAssignLead ext = new LTGS_MassMuteReAssignLead(stdSetController);
        ext.changecbx();
        Test.stopTest();
    }
    
     @istest static void datatwo()
    { 
        List<Lead> lods=new List<Lead>();
        Lead lod2=new Lead();
        lod2.FirstName='Barry';
        lod2.LastName='Allen';
        lod2.Company='DC';
        lod2.Status='Telesales Qualified';
        lod2.Country='IN';
        lod2.LCRM_Do_Not_Reassign__c=false;
        lods.add(lod2);
        insert lods;
        
        Test.startTest();
        test.setCurrentPage(Page.LTGS_MassMuteReassignmentChange_Lead);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lods);
        stdSetController.setSelected(lods);
        LTGS_MassMuteReAssignLead ext = new LTGS_MassMuteReAssignLead(stdSetController);
        ext.changecbx();
        Test.stopTest();
    }
    @istest static void datathree()
    { 
        List<Lead> lods=new List<Lead>();
        Lead lod3=new Lead();
        insert lods;
        
        Test.startTest();
        test.setCurrentPage(Page.LTGS_MassMuteReassignmentChange_Lead);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lods);
        stdSetController.setSelected(lods);
        LTGS_MassMuteReAssignLead ext = new LTGS_MassMuteReAssignLead(stdSetController);
        ext.changecbx();
        Test.stopTest();
    }
}