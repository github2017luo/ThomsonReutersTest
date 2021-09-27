/**
* This class is used as controller for Opty mass update Page
* to do multi edit of opty stage/WL reason.
* @ Author: Anshita Sharma
* @ Last Modified: Sep 4, 2012
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2012-09-04   Anshita Sharma           Created
* 2017-12-29   Harika Devi Kalidindi    Modified as part of CRM -11871  to allow mass update opps if the user is having Opportunity Mass Transfer Permission set.
* 2018-01-23   Harika Devi Kalidindi    Modified error message  as part of CRM -13112
* 2018 -02-09  Harika Devi Kalidindi    CRM -5600 Modified RemoveOppTeamMember and saveOpty methods to delete the opportunity split before deleting Opportunity team member.
* 2019-04-02   Tejasree Tadi             DPS-441:Modified logic in the sendEmailnotificationToNewOwner Method and used VF Email template'SendingEmailMessageTonewOwner' to send Emails based on User language
* =============================================================================
*/


public without sharing class massOptyUpdateController
{
    //Instantiate a StandardSetController
    public ApexPages.StandardSetController setCon;
    
    //Lists 
    List<Opportunity> selectedOptys = new List<Opportunity>();
    List<Opportunity> editList= new List<Opportunity>();
    List<Opportunity> nonEditList= new List<Opportunity>();
    List<Opportunity> nonAssignList= new List<Opportunity>();
    List<Opportunity> AssignList = new List<Opportunity>();
    
    //Maps
    Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>();
    
    //Properties
    public List<oOppSelected > OppsList {get; set;}
    public List<oOppSelected > OppWrapper {get; set;}
    public Boolean isNotAll{get;set;}
    public boolean isRecords{get;set;}
    public boolean isFirst{get;set;}
    public boolean isEdit{get;set;}
    public boolean isNonEditOpty{get;set;}
    public boolean isNotAssignOpty{get;set;}
    public boolean isAssign{get;set;}
    public static boolean isRequired{get;}
    public String opt;
    public RecordtypeIds__c recId;
    public String rId;
    public String selectStage{get;set;}
    public String winLoss{get;set;}
    public boolean isRemovePrevOwnerfromTeammember{get;set;}
    public boolean isSendEmailNotification{get;set;}
    public String UserBusinessUnit; 
    public Boolean BUFlag;
    //Constructor
    public massOptyUpdateController(ApexPages.StandardSetController controller)
    {   
        setCon = controller;
        isFirst = true;
        isNotAll = true;
        isEdit =false;
        isNonEditOpty = false;
        isNotAssignOpty  = false;
        
        UserBusinessUnit = LCRMGenericComponent.getUserBU(); 
        BUFlag = LCRMGenericComponent.validateUserBU(UserBusinessUnit);
        
        this.opt = 'Update all Opportunities' ;
        recId = RecordtypeIds__c.getValues('Pipeline Opportunities'); 
        if(recId !=null)
            rId = recId.recTypeId__c ;
            
        if(setCon.getSelected().size()>0)
            isRecords = true;
        else
            isRecords = false; 
            
        getOpty(); 
        if(editList.size()!=0)
            isEdit = true;
        else
            isEdit =false;    
            
       if(AssignList.size()!=0)
            isAssign = true;
        else
            isAssign = false; 
        
        
    }
    
   
   
   
    //Getters and Setters

    public integer getMySelectedSize()
    {
        return setCon.getSelected().size();
    } 
    
    
    public integer getNonEditListSize()
    {
        return nonEditList.size();
    }
    
    public integer getEditListSize()
    {
        return editList.size();
    }
        
    public integer getNonAssignListSize()
    {
        return nonAssignList.size();
    }
          
        
    public List<Opportunity> getEditList()
    {
        return editList;
    }
    
    public List<Opportunity> getNonEditList()
    {
        return nonEditList;
    }
    public List<Opportunity> getNonAssignList()
    {
        return nonAssignList;
    }
    
    //Actions methods and other methods
     
    //Called for action attribute of <actionSupport>
    
    public PageReference Test()
    {
       if(editList.size()!=0)
            isEdit = true;
        else
            isEdit =false;
       return null;
    }    
    
    //Called from constructor and filter the TRUST/Siebel mastered optys
    public List<oOppSelected> getOpps() {
        if(OppsList == null) {
           OppsList = new List<oOppSelected>();
           for(Opportunity opp : [Select id, name, RecordTypeId, StageName, AccountId , OwnerId, Win_Loss__c,Reason__c,Competitor_Name__c,Was_There_a_Competitor__c,Is_GLI__c from Opportunity where id IN: optyMap.KeySet()])
            {
               OppsList.add(new oOppSelected (opp));
            }
        }
        return OppsList ;

    }
    
    
    public void getOpty()
    {        
        if(setCon.getSelected().size()>0)
        {
            selectedOptys.clear();
            selectedOptys = setCon.getSelected();
        }        
        
        for(Opportunity opp:selectedOptys)
        {
            optyMap.put(opp.id, opp);
        }   
            
        for(Opportunity opp : [Select id, name, RecordTypeId, RecordType.Name, StageName, AccountId , OwnerId, Win_Loss__c,Reason__c,Competitor_Name__c,Was_There_a_Competitor__c,Is_GLI__c from Opportunity  where id IN: optyMap.KeySet()])
        {
      
            if(rId == opp.RecordTypeId)
            {
                if(opp.StageName !='100%'){
                    if(ApexPages.currentPage().getUrl().contains('massReassignOpptyOwner')){
                        AssignList.add(opp);
                    }
                    else{
                        editList.add(opp);
                    }
                }
                    
                else if(opp.StageName =='100%')
                {
                    nonAssignList.add(opp);
                    nonEditList.add(opp);
                    
                    
                }  
            }
            else
            {
                AssignList.add(opp);
                nonEditList.add(opp);
            } 
            
        } 
        if(!nonEditList.isEmpty())
            isNonEditOpty = true;
        if(!nonAssignList.isEmpty())
            isNotAssignOpty = true;    
        if(!editList.IsEmpty()){
            setCon.setSelected(editList);
           OppWrapper = new List<oOppSelected>();
           OppsList = new List<oOppSelected>();
            for(Opportunity opt :editList) {
                OppWrapper.add(new oOppSelected (opt));
                OppsList.add(new oOppSelected (opt));
                }
        }else{
            setCon.setSelected(AssignList);
        }
        
    }
    
    //Called for showing available Radio options
    
    public List<SelectOption> getItems()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Update all Opportunities','Update all Opportunities')); 
        options.add(new SelectOption('Update Individual Opportunity','Update Individual Opportunity')); 
        return options; 
    }
    
    // getter for selected radio option
    
    public String getOpt()
    {
        return opt;
    }
    
    // setter for selected radio option
                        
    public void setOpt(String opt)
    {
        this.opt= opt;
        if(opt != 'Update all Opportunities')
            isNotAll = false;               
        else
            isNotAll = true;                   
                      
    }
    
    //Called on 'Save' and 'Mass Update' to update optys
    // Harika - 29/12/2017 Modified as part of CRM -11871  to allow mass update opps if the user is having Opportunity Mass Transfer Permission set.
     // If user has Opportunity Mass Transfer Sales Reps permission set then only records owned by them can be update 
    // Harika - 09/02/2018 Modified as part of CRM -5600 to call RemoveOppTeamMember() after updating the Opportunity owner
    public PageReference saveOpty()
    {
        List <Opportunity> lstoptyUpdate= new List<Opportunity>();
        List <Opportunity> lstfinalUpdate= new List<Opportunity>();
        List<PermissionSetAssignment> lstOppMasTransferPerset = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> lstOppMasTransferSalesRepPerset = new List<PermissionSetAssignment>();
        List<Id> lstoppid =new List<Id>();
        List <Opportunity> LstbeforeUpdate= new List<Opportunity>();
        Map<Id,Id> previousownermap =new Map<Id,Id>();
        Map<Id,Id>whatAndWhoIdMap = new Map<Id,Id>();
        lstoptyUpdate= setCon.getSelected();
        Id loggedinuserId = Userinfo.getUserId();
        Boolean isdirect =true;
        Boolean hasOppMasTransferPerset  =false;
        Boolean hasOppMasTransferSalesRepPerset =false; 
        if(Schema.sObjectType.PermissionSetAssignment.isQueryable())
        lstOppMasTransferPerset =  [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :loggedinuserId  and PermissionSet.Name ='Opportunity_Mass_Transfer'];
        
        lstOppMasTransferSalesRepPerset=  [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :loggedinuserId  and PermissionSet.Name ='Opportunity_Mass_Transfer_Sales_Reps'];
 
        
        if(!lstOppMasTransferPerset.IsEmpty())
        {
            hasOppMasTransferPerset =true;
        }
        if(!lstOppMasTransferSalesRepPerset.IsEmpty())
        {
            hasOppMasTransferSalesRepPerset=true;
        }
        try
        {
            if(lstoptyUpdate.size()>0)
            {                
                if(isNotAll)
                { 
                    for(opportunity oppty :lstoptyUpdate)
                    {
                        lstoppid.add(oppty .Id);
                        whatAndWhoIdMap.put(oppty.Id,oppty.OwnerId);
                    }
                    if(!lstoppid.isEmpty() && Schema.sObjectType.Opportunity.isQueryable())
                    LstbeforeUpdate =[Select Id,Is_GLI__c, OwnerId from Opportunity where Id In :lstoppid];
                    for(Opportunity opp :LstbeforeUpdate )
                    {
                        previousownermap.put(opp.id,opp.OwnerId);
                     
                    }       
                    if(hasOppMasTransferPerset || !BUFlag)
                    {
                        lstfinalUpdate.addall(lstoptyUpdate);
                    } 
                    else if(hasOppMasTransferSalesRepPerset)
                    {
                        Id UpdatedOwner =lstoptyUpdate[0].OwnerId;
                        if(!LstbeforeUpdate.isEmpty())
                        for(Opportunity opp :LstbeforeUpdate)
                        {
                            if(opp.OwnerId==loggedinuserId)
                            {
                                opp.OwnerId =UpdatedOwner;
                                lstfinalUpdate.add(opp);
                            }
                        }
                     }
                     if(!lstfinalUpdate.isEmpty() && Schema.sObjectType.Opportunity.isupdateable())
                     {
                          update lstfinalUpdate;
                          if(isRemovePrevOwnerfromTeammember != NULL && isRemovePrevOwnerfromTeammember)
                          {
                              RemoveOppTeamMember(lstfinalUpdate,previousownermap);
                          } 
                     }
                     else
                     {
                         //Harika - modified the error message as part of CRM -13112
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Mass_OptyUpdate_Error));
                         isdirect = false;
                     }
                     if(isSendEmailNotification != NULL && isSendEmailNotification && Schema.sObjectType.User.isQueryable())  
                     {                     
                         User Ownerdetails = [Select Email from User where Id =: lstoptyUpdate[0].OwnerId];
                         SendEmailNotificationToNewOwner(whatAndWhoIdMap, lstoptyUpdate);
                     }
                 }
                 else
                 {
                     Map<Id,Id> mapownerid =new Map<Id,Id>();
                     List <Opportunity> lstoptyRemoveTmb= new List<Opportunity>();
                     List <Opportunity> lstoptySendNtf= new List<Opportunity>();
                     List <Opportunity> lstoptys = new List<Opportunity>();
                    
                     for(oOppSelected opps : OppsList)
                     { 
                         for(Opportunity oppbeforeUpdate : selectedOptys)
                         {
                             // System.debug('isRemovePrevOwnerfromTeammemberSelected..'+opps.isRemovePrevOwnerfromTeammemberSelected);
                             lstoppid.add(oppbeforeUpdate.Id);  
                             if(opps.isRemovePrevOwnerfromTeammemberSelected )
                             {                          
                                 If(Opps.opp.id == oppbeforeUpdate.id)
                                 lstoptyRemoveTmb.add(oppbeforeUpdate);
                                 System.debug('Individual Opps Update Inside Remove loop');
                             } 
                             //  System.debug('isSendEmailNotificationSelected ..'+opps.isSendEmailNotificationSelected);   
                             if(opps.isSendEmailNotificationSelected )
                             {
                                 If(Opps.opp.id == oppbeforeUpdate.id)
                                 lstoptySendNtf.add(opps.opp);
                                 // System.debug('Individual Opps Update Inside Send notification loop');
                             }                           
                             
                         }                      
                         lstoptys.add(opps.opp); 
                     }
                     if(!lstoppid.isEmpty())
                     LstbeforeUpdate =[Select Id,Is_GLI__c, OwnerId from Opportunity where Id In :lstoppid];
                     if(!LstbeforeUpdate .isEmpty())
                     {
                          for(Opportunity opp :LstbeforeUpdate)
                          {
                              previousownermap.put(opp.id,opp.OwnerId);
                          }
                          for(opportunity oppty :LstbeforeUpdate )
                          {
                              mapownerid.put(oppty.Id,oppty.OwnerId );
                          }
                     }
                     if(hasOppMasTransferPerset || !BUFlag)
                     { 
                         lstfinalUpdate.addall(lstoptys);
                     } 
                     else if(hasOppMasTransferSalesRepPerset)
                     {
                         for(Opportunity opp :lstoptys)
                         {
                             if(mapownerid.get(opp.Id) == loggedinuserId)
                             {
                                 lstfinalUpdate.add(opp);
                             }
                         }
                      
                     } 
                     if(!lstfinalUpdate.isEmpty() && Schema.sObjectType.Opportunity.isUpdateable())
                     {
                         update lstfinalUpdate;
                         List<Opportunity> lstfinaloptyRemoveTmb =new List<Opportunity>();
                         if(lstoptyRemoveTmb.size()>0)  
                         {  
                             Map<Id,Opportunity> mapfinallist=new Map<Id,Opportunity>();
                             for(Opportunity oppfinallist : lstoptyRemoveTmb)
                             {
                                 mapfinallist.put(oppfinallist.Id, oppfinallist);
                             }
                                
                             for(Opportunity oppremovetmb : lstfinalUpdate)
                             {
                                 if(mapfinallist.containskey(oppremovetmb.Id))
                                 {
                                     lstfinaloptyRemoveTmb.add(mapfinallist.get(oppremovetmb.Id));
                                 }
                                
                             }
                         }
                         if(lstfinaloptyRemoveTmb.size()>0)
                         {    
                             RemoveOppTeamMember(lstfinaloptyRemoveTmb,previousownermap);
                         }
                     }
                     else
                     {
                         //Harika - modified the error message as part of CRM -13112
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Mass_OptyUpdate_Error));
                         isdirect = false;    
                     }     
                     if(lstoptySendNtf.size()>0)  
                     {      
                                 
                         for(Opportunity op : lstoptySendNtf)
                         {
                              whatAndWhoIdMap.put(op.Id,op.OwnerId);
                         }
                         SendEmailNotificationToNewOwner(whatAndWhoIdMap, lstoptySendNtf);
                         //System.debug('Individual Opps Update : Calling send notification method');
                     }
                }                         
            }
        }
        catch(Exception e)
        {
           ApexPages.addMessages(e); 
           return null;
          
        }
        if(isdirect)
        {       
            Pagereference listPage= new PageReference('/006?fcf');
            listPage.setredirect(true);
            return listPage;
        }
        else
        {
            return null;
        } 
    
    }
    
    //Added VF Email template for french users and used common utility class 'LTS_SendCustomEmailUtilityClass' to send Email as a part of DPS-122
      public void sendEmailnotificationToNewOwner(Map<Id,Id>OpptyEmailMap,List<Opportunity> OpptyList)
    {
        Map<Id,Id> MapofTargetId = new Map<Id,Id>();
        EmailTemplate templateId;
        if(EmailTemplate.sObjectType.getDescribe().isAccessible())
        templateId= [Select id from EmailTemplate where name = 'SendEmailNotificationToNewOwner'];
      
        for(opportunity opptyIns : OpptyList){
            
            if(OpptyEmailMap.containskey(opptyIns.Id)){
                MapofTargetId.put(OpptyEmailMap.get(opptyIns.Id),opptyIns.Id);
            }
        }
                
        System.debug('Call ****LTS_SendCustomEmailUtilityClass****');
        LTS_SendCustomEmailUtilityClass utilityIns = new LTS_SendCustomEmailUtilityClass();
        utilityIns.sendSingleEmailMsg(MapofTargetId,templateId.Id,System.label.Opportunity_Owner);


    }
   
   // Harika - 09/02/2018 Modified as part of CRM -5600 to remove Opportunity Split record before deleting the Opportunity team member
    public void RemoveOppTeamMember(List<Opportunity> lstopps ,Map<Id,Id> mappreviousownerId)
    {
        Set<ID> oppsID = New Set<ID>();
        Map<Id,Id> mapopps = new Map<Id,Id>();
         Map<Id,Boolean> mapgliopps= new Map<Id,Boolean>();
        
        for (Opportunity opp : lstopps)
        {
            oppsID.add(opp.Id);
            mapgliopps.put(opp.Id,opp.Is_GLI__c);
            if(mappreviousownerId.containskey(opp.Id))
            {
                mapopps.put(opp.Id,mappreviousownerId.get(opp.Id));
            }
        }
        List<OpportunityTeamMember> lstoppsteammembers = new List<OpportunityTeamMember>();
        List<OpportunitySplit> lstoppsSplit = new  List<OpportunitySplit>();
        if(Schema.sObjectType.OpportunityTeamMember.isQueryable() && Schema.sObjectType.OpportunitySplit.isQueryable())
        lstoppsteammembers = [SELECT UserId,ID,OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN: oppsID];
        lstoppsSplit=[SELECT Id,OpportunityId,SplitOwnerId FROM OpportunitySplit where  OpportunityId IN: oppsID];
        List<ID> lstoppsplitemove = new List<ID>();
        List<ID> lstopptmbremove = new List<ID>();
        
        if(!lstoppsSplit.isEmpty())
        {
            for(OpportunitySplit oppsplit : lstoppsSplit )
            {
           
                if(oppsplit.SplitOwnerId == mapopps.get(oppsplit.OpportunityId) && mapgliopps.get(oppsplit.OpportunityId) )
                {
                    lstoppsplitemove.add(oppsplit.Id);
                }
                 
            }
            
        }    
            
       
        
        if(!lstoppsteammembers.isEmpty())
        {
            for(OpportunityTeamMember oppteamem : lstoppsteammembers )
            {
                if(oppteamem.UserId == mapopps.get(oppteamem.OpportunityId))
                {
                    lstopptmbremove.add(oppteamem .Id);
                }
                 
            }
        }
        
        
         try{
        
         if(lstoppsplitemove.size() > 0 && lstoppsplitemove!= null)
        {
            Delete [select Id from OpportunitySplit  where Id IN: lstoppsplitemove];
        }
        
        
        if(lstopptmbremove.size() > 0 && lstopptmbremove != null)
        {
            Delete [select Id from opportunityTeamMember where Id IN: lstopptmbremove];
        }
        }
        catch (DMLException e){
         ApexPages.addMessages(e);

        }
    
    }
   
   
    @RemoteAction
    public static pagereference onStagenamechange(String Hello){
     // String strStage = ApexPages.currentPage().getParameters().get('Stagevalue');
      massOptyUpdateController.isRequired = true;
      System.debug('*****'+isRequired );
      return null;
    }
    
    
    public class oOppSelected {

       public Opportunity opp {get; set;}
       public Boolean isRemovePrevOwnerfromTeammemberSelected {get; set;}
       public Boolean isSendEmailNotificationSelected {get; set;}
       public oOppSelected(Opportunity o) {
           opp = o;
           isRemovePrevOwnerfromTeammemberSelected = false;
           isSendEmailNotificationSelected = false;   
       }

}
    
}