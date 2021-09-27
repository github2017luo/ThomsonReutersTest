/**
* This class is used as controller for Opty mass remove team member Page
* to do mass remove team member from OpportunityTeamMember.
* @ Author: Ravi Havashetty
* @ Last Modified: June 18, 2015
*/


public class opptyMassRemoveTeamMemberController
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
    public List<OptyMassAdd> OptyMassList{get;set;}
    public List<OptyMassAdd> OptyMassWrapper{get;set;}
    public Boolean isNotAll{get;set;}
    public boolean isRecords{get;set;}
    public boolean isFirst{get;set;}
    public boolean isEdit{get;set;}
    public boolean isNonEditOpty{get;set;}
    public boolean isNotAssignOpty{get;set;}
    public boolean isAssign{get;set;}
    public static boolean isRequired{get;}
    public String opt;
    public boolean optNullCheck;
    public RecordtypeIds__c recId;
    public String rId;
    public String selectStage{get;set;}
    public String winLoss{get;set;}
    public OpportunityTeamMember OppTeamMember{get;set;}
    public OpportunityTeamMember OppTeamMemberAdd{get;set;}
    
    
    public List<OpportunityTeamMember> members {
    get {
        system.debug('Calling getMembers Method !');
        system.debug('mOpportunityTeamMembers:'+mOpportunityTeamMembers);
        system.debug('mOpportunityTeamMembers.values():'+mOpportunityTeamMembers.values());
        return mOpportunityTeamMembers.values();
    }
    set;
}

public Map<ID, OpportunityTeamMember> mOpportunityTeamMembers ;//{get; set;} 
    
    //Constructor
    public opptyMassRemoveTeamMemberController(ApexPages.StandardSetController controller)
    {   
        OppTeamMember = new OpportunityTeamMember ();
        OppTeamMemberAdd = new OpportunityTeamMember ();
        setCon = controller;
        isFirst = true;
        isNotAll = true;
        isEdit =false;
        isNonEditOpty = false;
        isNotAssignOpty  = false;
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
      public List<OptyMassAdd> getOpps() {
        if(OptyMassList == null) {
           OptyMassList = new List<OptyMassAdd>();
           for(Opportunity opp : [Select id, name, RecordTypeId, StageName, AccountId , OwnerId, Win_Loss__c,Reason__c,Competitor_Name__c,Was_There_a_Competitor__c from Opportunity where id IN: optyMap.KeySet()])
            {
               OptyMassList.add(new OptyMassAdd(opp));
            }
        }
        return OptyMassList;

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
            
        for(Opportunity opp : [Select id, name, RecordType.Name, RecordTypeId, StageName, AccountId , OwnerId, Win_Loss__c,Reason__c,Competitor_Name__c,Was_There_a_Competitor__c from Opportunity where id IN: optyMap.KeySet()])
        {
            if(rId == opp.RecordTypeId)
            {
                if(opp.StageName !='100%'){
                    if(ApexPages.currentPage().getUrl().contains('opptyMassRemoveTeamMember')){
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
         OptyMassWrapper = new List<OptyMassAdd>();
        OptyMassList =    new List<OptyMassAdd>();
        for (opportunity opt:editList){
        OptyMassWrapper.add( new OptyMassAdd(opt));
        OptyMassList.add(new OptyMassAdd(opt));
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
    
    public PageReference saveOpty()
    {
        List <Opportunity> optyLstUpdate= new List<Opportunity>();
        optyLstUpdate= setCon.getSelected();
        Set<ID> oppsID1 = New Set<ID>();
       for (Opportunity opp1 : selectedOptys)
       {
          oppsID1.add(opp1.Id);       
       }
        if(opt == 'Update all Opportunities')        
        {
            if(OppTeamMemberAdd.userid==null && OppTeamMember.userid==null)
            {
                // Add a custom error message to the page >>> THIS IS THE MAGIC LINE!
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'At least one entry should be made');
                ApexPages.addMessage(myMsg); 
                return null;
            }
        
        }        
    if(opt != 'Update all Opportunities')        
        {
         List<OpportunityTeamMember> oppsteammembersAd3 = [SELECT UserId,ID,opportunityid FROM OpportunityTeamMember WHERE OpportunityId IN: oppsID1];
      // List<OpportunityTeamMember> opptmbfind= new List<OpportunityTeamMember>();
         for(OptyMassAdd ops2:OptyMassList)
         {
             for(OpportunityTeamMember opptmb3 : oppsteammembersAd3)
             {
            if(ops2.Addopty.userid==null && ops2.Removeopty.userid==null)
            {
                // Add a custom error message to the page >>> THIS IS THE MAGIC LINE!
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'At least one entry should be made');
                ApexPages.addMessage(myMsg); 
                return null;
            }
        
         }
        }
       }        
        try
        {
            if(optyLstUpdate.size()>0)
            {                
                 OppTeamMemberToBeRemoved(selectedOptys);            
            }
        }
        catch(Exception e)
        {
           ApexPages.addMessages(e); 
           return null;
          
        }       
        Pagereference listPage= new PageReference('/006?fcf');
        listPage.setredirect(true);
        return listPage; 
    
    }
     
    public void OppTeamMemberToBeRemoved(List<Opportunity> selectedOptys)
    {
    
       Set<ID> oppsID = New Set<ID>();
       for (Opportunity opp : selectedOptys)
       {
          oppsID.add(opp.Id);       
       }
       if(isNotAll == true)
        {
        if(OppTeamMember.userid!=null){
        //System.debug('OppTeamMember.UserId' +OppTeamMember.UserId);
        List<OpportunityTeamMember> oppsteammembers = [SELECT UserId,ID FROM OpportunityTeamMember WHERE OpportunityId IN: oppsID];
        
       // List<OpportunityTeamMember> opptmbremove = new List<OpportunityTeamMember>();        
          List<ID> opptmbremove = new List<ID>();
          for(OpportunityTeamMember opptmb : oppsteammembers )
          {
          System.debug('opptmb.UserId' +opptmb.UserId);
                    System.debug('OppTeamMember.UserId' +OppTeamMember.UserId);
             if(opptmb.UserId == OppTeamMember.UserId)
             {
               opptmbremove.add(opptmb.id);
             }
          }            
         System.debug('opptmbremove' +opptmbremove);
        if(opptmbremove.size() > 0 && opptmbremove != null)
        {
          //Delete opptmbremove;
          Delete [select Id from opportunityTeamMember where Id IN: opptmbremove];
        }
         }
          if(OppTeamMemberAdd.userid!=null){
    
     List<OpportunityTeamMember> oppsteammembersAdd = [SELECT UserId,ID,opportunityid FROM OpportunityTeamMember WHERE OpportunityId IN: oppsID];
            
        List<OpportunityTeamMember> opptmbAdd= new List<OpportunityTeamMember>();        
        
          for(OpportunityTeamMember opptmb : oppsteammembersAdd)
          {
             if(opptmb.UserId != OppTeamMemberAdd.UserId)
             {
                                       System.debug('usrin111' +OppTeamMemberAdd.UserId);
               opptmbAdd.add( new OpportunityTeamMember(OpportunityId = opptmb.opportunityid,UserID = OppTeamMemberAdd.UserId));
             }
          }    
          
           if(opptmbAdd.size() > 0 && opptmbAdd!= null)
        {
          insert opptmbAdd;
        } 
     } 
     
     }
     else
     {
       List<OpportunityTeamMember> oppsteammembersAd1 = [SELECT UserId,ID,opportunityid FROM OpportunityTeamMember WHERE OpportunityId IN: oppsID];
       List<OpportunityTeamMember> opptmbrem= new List<OpportunityTeamMember>();
         for(OptyMassAdd ops:OptyMassList)
         {
             for(OpportunityTeamMember opptmb1 : oppsteammembersAd1)
             {
                 if(opptmb1.UserId == ops.Removeopty.UserId && opptmb1.opportunityid==ops.opp.id)
                 {
                   opptmbrem.add(opptmb1);
                 }               
             } 
        }
    
        if(opptmbrem.size() > 0 && opptmbrem!= null)
        {
          Delete opptmbrem;
        } 
        
        List<OpportunityTeamMember> oppsteammembersAd2 = [SELECT UserId,ID,opportunityid FROM OpportunityTeamMember WHERE OpportunityId IN: oppsID];
       List<OpportunityTeamMember> opptmbAd= new List<OpportunityTeamMember>();
         for(OptyMassAdd ops1:OptyMassList)
         {
             for(OpportunityTeamMember opptmb2 : oppsteammembersAd2)
             {
          //   System.debug('opptmb2.opportunityid' +opptmb2.opportunityid);
            // System.debug('ops1.opp.id' +ops1.opp.id);
                 if(opptmb2.UserId != ops1.Addopty.UserId && opptmb2.opportunityid==ops1.opp.id && ops1.Addopty.UserId!=null)
                 {
                 System.debug('opptmb2.opportunityid' +opptmb2.opportunityid);
                 System.debug('ops1.opp.id' +ops1.opp.id);
                 System.debug('ops1.Addopty.UserId' +ops1.Addopty.UserId);
                   opptmbAd.add( new OpportunityTeamMember(OpportunityId = ops1.opp.id,UserID = ops1.Addopty.UserId ));
                 }               
             } 
        }
    
        if(opptmbAd.size() > 0 && opptmbAd!= null)
        {
          Insert opptmbAd;
        }
          
    }

  }  
    @RemoteAction
    public static pagereference onStagenamechange(String Hello){
     // String strStage = ApexPages.currentPage().getParameters().get('Stagevalue');
      massOptyUpdateController.isRequired = true;
      System.debug('*****'+isRequired );
      return null;
    }
   
  public class OptyMassAdd{
  public opportunity opp{get; set;}
  public OpportunityTeamMember Removeopty{get; set;}
  public OpportunityTeamMember Addopty{get; set;}
  public OptyMassAdd(Opportunity o){
  opp=o;
  Removeopty=new OpportunityTeamMember();
  Addopty =new OpportunityTeamMember();
  }
 }
}