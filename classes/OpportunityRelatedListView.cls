/*
======================================================================================================================
CLASS NAME:  OpportunityRelatedListView
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-23        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class OpportunityRelatedListView{
    private Opportunity oOpportunity;
    public List<user> lstOpptyTeamMembrs{get;set;}
    public String strSortField {get; set;}
    public String strOrdr{get; set;}
    public String strPrevSortField {get; set;}
    public OpportunityRelatedListView(ApexPages.StandardController oController){
        oOpportunity= (Opportunity) oController.getRecord();
        lstOpptyTeamMembrs= new List<user>(); 
        list<id> listUserIds = new List<id>();
          for(opportunityTeamMember oTeam:  [select id,userid from opportunityTeamMember where OpportunityId=:oOpportunity.id ]){
             listUserIds.add(oTeam.userID);
          }
       lstOpptyTeamMembrs=[select id,Rep_Type_Description__c, Name , Email,phone from user where id in:listUserIds];
    }
    
    public ApexPages.StandardSetController setSalesTeam{
        get{
            if(setSalesTeam == null){
                setSalesTeam = new ApexPages.StandardSetController(lstOpptyTeamMembrs);
                // sets the number of records in each page set
                setSalesTeam.setPageSize(60);
            }
         return setSalesTeam;
        }
      set;
    }
    public List<user> getGoToListSalesTeam(){
         return setSalesTeam.getRecords();
    }
     public pagereference doSort(){
        strOrdr = 'asc';
        if(strPrevSortField== strSortField ){
            strOrdr = 'desc';
            strPrevSortField= '';
        }else{
            strPrevSortField= strSortField ;
        }
        lstOpptyTeamMembrs=GenericSort.sortList(lstOpptyTeamMembrs,strSortField,strOrdr);
        setSalesTeam = null;                 
        return null;
    }
}