@isTest
public class ListButtonController_Test{

private static testmethod void hideSectionOnChangeTest(){

    ILMGeneral__c ilmGen=new ILMGeneral__c();
    ilmGen.name= 'AllowedUsersForSalesRepAssignment';
    ilmGen.Value__C = 'SL Eloqua';        
    insert ilmGen;
           
     List<Lead> listLead = new List<Lead>();
          
     Lead l1= new Lead(FirstName='saty1', LastNAme='chan1', Status='Contacting',Company='TR',Country='BANGLADESH');
     listLead .add(l1);
     Lead l2= new Lead(FirstName='saty2', LastNAme='chan2', Status='Discarded',Discard_Reason__c='Busy1', Company='TR',Country='BANGLADESH');
     listLead .add(l2);
     Lead l3= new Lead(FirstName='saty3', LastNAme='chan3', Status='Unworked',Rejected_Reason__c='Busy2', Company='TR',Country='BANGLADESH');
     listLead .add(l3);
     insert listLead;
     
     Test.startTest();
         ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listLead);
         stdSetController.setSelected(listLead);
        ListButtonController ext = new ListButtonController(stdSetController);
        
        ext.lead.Status='Contacting';
        ext.hideSectionOnChange();
        
        ext.lead.Status='Discarded';
        ext.hideSectionOnChange();
        //System.assertEquals(true, ext.lead.Status); 

        ext.lead.Status='Unworked';
        ext.hideSectionOnChange();
        //System.assertEquals(true, ext.lead.Status); 
        
        ext.updateLeads();
     Test.stopTest();
     
    

}

}