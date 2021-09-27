/**
* This class is used as controller for Opty mass update Page
* to do multi edit of opty status and discard reason.
* @ Author: Anshita Sharma
* @ Last Modified: Sep 4, 2012
*/


public class massOptyStatusUpdateController
{
    
    //Instantiate a StandardSetController
    public ApexPages.StandardSetController setCon;
    
    //Lists 
    
    List<Opportunity> ppoOppEditList= new List<Opportunity>();
    List<Opportunity> ppoOppNonEditList= new List<Opportunity>();
    List<Opportunity> selectedOptys = new List<Opportunity>();
    //Maps
    Map<Id,Opportunity> optyMap = new Map<Id,Opportunity>();
    
    //Properties
    public Boolean isNotAll{get;set;}
    public boolean isRecords{get;set;}
    public boolean isNonEditPPOpty{get;set;}
    public boolean isPPOEdit{get;set;}
    public String opt;
    public RecordtypeIds__c recId;
    public String rId;
    
    //Constructor
    public massOptyStatusUpdateController(ApexPages.StandardSetController controller)
    {
        setCon = controller;
        isNotAll = true;
        isNonEditPPOpty = false;
        isPPOEdit = false;
        this.opt = 'Update all Opportunities' ;
        recId = RecordtypeIds__c.getValues('Pre-Pipeline Opportunities');         
        if(recId !=null)
            rId = recId.recTypeId__c ;
         
        if(setCon.getSelected().size()>0)
            isRecords = true;
        else
            isRecords = false;                   
       getPPOpty();
       if(ppoOppEditList.size()!=0)
           isPPOEdit= true;    
   
    }
    
   
    //Getters and Setters

    
    public integer getPpoOppEditListSize()
    {
        return ppoOppEditList.size();
    }
        
    public integer getPpoOppNonEditListSize()
    {
        return ppoOppNonEditList.size();
    }
          
        
    
    public List<Opportunity> getPpoOppEditList()
    {
        return ppoOppEditList;
    }
    
    public List<Opportunity> getPpoOppNonEditList()
    {
        return ppoOppNonEditList;
    }
    
    //Actions methods and other methods
     
    //Called for action attribute of <actionSupport>
    
    
    public PageReference Test()
    {
       if(ppoOppEditList.size()!=0)
            isPPOEdit = true;
        else
            isPPOEdit =false;
       return null;
    }    
    
    //Called from constructor and filter the TRUST/Siebel mastered optys
    
   
    public void getPPOpty()
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
        
        for(Opportunity opp : [Select id, name, RecordType.Name, RecordTypeId, Status__c, AccountId , OwnerId, Discard_Reason__c  from Opportunity where id IN: optyMap.KeySet()])
        {
            if(rId == opp.RecordTypeId)
                ppoOppEditList.add(opp);
            else
            {
                ppoOppNonEditList.add(opp);
                isNonEditPPOpty = true;
            }    
        }
        if(!ppoOppEditList.IsEmpty())
            setCon.setSelected(ppoOppEditList);
             
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
        try
        {
            if(optyLstUpdate.size()>0)
            {
                 update optyLstUpdate;              
            }
        }
        catch(Exception e)
        {
           return null;           
        }       
        Pagereference listPage= new PageReference('/006?fcf');
        listPage.setredirect(true);
        return listPage; 
    
    }
    
}