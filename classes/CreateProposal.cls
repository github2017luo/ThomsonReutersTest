/* 
 *@author Original : Priyanka Pawar (UX007471)
 *@date Original   : 15th May 2018
 *@description     : (CRM-CRM-13656) Class created to show validation before creating quote/proposal on GLI opportunity 
 */

public without sharing class CreateProposal{
    public String OppId{get;set;} 
        
    public CreateProposal(ApexPages.StandardController controller) {
     OppId =controller.getRecord().id;
    //redirect();
    }
    public CreateProposal(){
        System.debug('test');
        //redirect();
    }
public Pagereference redirect(){
    //DOC-12752-Commented as part of CrossSell
    /*Set<String> subBuWestSet=new Set<String>{'Findlaw','LMS','USL'};
    User loggedUser=new User();
    if(Schema.sObjectType.user.fields.id.isAccessible()&&Schema.sObjectType.user.fields.Sub_Bu__c.isAccessible()&&Schema.sObjectType.user.fields.Segment__c.isAccessible()){
        loggedUser=[select id,Sub_Bu__c,Segment__c,Default_Catalog__c from user where id =: UserInfo.getUserId()];
    }*/
    String oppId;      
    String actId = string.escapeSingleQuotes('id');  
    if(string.isNotBlank(ApexPages.currentPage().getParameters().get(actId))){  
       oppId=(String) (string.escapeSingleQuotes(apexpages.currentpage().getparameters().get(actId)));  
    }
    Opportunity opp=new Opportunity();
    if(Schema.sObjectType.opportunity.fields.id.isAccessible()&&Schema.sObjectType.opportunity.fields.Source_System_Detail__c.isAccessible()&&Schema.sObjectType.opportunity.fields.AccountID.isAccessible()&&Schema.sObjectType.opportunity.fields.LCRM_Sub_BU__c.isAccessible()){
        opp=[Select id,Source_System_Detail__c,AccountID,LCRM_Sub_BU__c,Key_Contact__c  from opportunity where id=:oppId];
    }
    system.debug('opp'+opp);
     if( opp.Source_System_Detail__c == null || string.valueOf(opp.Source_System_Detail__c) ==''){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Source System Detail is required to create a quote/proposal'));
        return null;
    }
    Source_System_Detail__c ssd;
    if(Schema.sObjectType.Source_System_Detail__c.isAccessible()&& Schema.sObjectType.Source_System_Detail__c.isQueryable()){
        ssd =[select id,Source_System_Account_Number__c,Account_Name__r.id,LCRM_Sales_Org__c from Source_System_Detail__c where id=:opp.Source_System_Detail__c ];
    }
    //Added as part of LTS-5087
    if( opp.accountID != ssd.Account_Name__r.id ){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'opportunity should have same account as SSD '));
        return null;
    }
    //DOC-12752-Commented as part of CrossSell
    /*if( ssd.LCRM_Sales_Org__c !='WEST' && !String.isBlank(loggedUser.Default_Catalog__c)
         && (subBuWestSet.contains( loggedUser.Default_Catalog__c)) && loggedUser.Segment__c!= Label.SALESORGCORP && loggedUser.Segment__c!= Label.SUBBUGLOBAL){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ensure SSD selected on opportunity has a  Sales Org value of WEST '));
        return null;
    }
   //DOC 3111 Poonam Garg Added for Canada . If Salesorg is not CARS and User Region is Canada then User shouldnot be allowed to create Proposal
    if( ssd.LCRM_Sales_Org__c !=label.SALESORGCARS  && (loggedUser.Sub_Bu__c== Label.SALESORGCAN )){ 
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ensure SSD selected on opportunity has a  Sales Org value of '+   label.SALESORGCARS));
        return null;
    }*/
    //DOC 6198 Poonam Garg Added for Canada . If Salesorg is not CARS and User Region is Canada then User shouldnot be allowed to create Proposal
    if( ssd.LCRM_Sales_Org__c ==label.SALESORGCARS  /*&& (loggedUser.Sub_Bu__c== Label.SALESORGCAN || loggedUser.Segment__c== Label.SUBBUGLOBAL || loggedUser.Sub_Bu__c== Label.SUBBUGLOBAL)*/ && String.isEmpty(opp.Key_Contact__c)){ 
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please ensure contact is entered before creating a proposal'));
        return null;
    }
    //DOC-12752-Commented as part of CrossSell
   /*if( (ssd.LCRM_Sales_Org__c !=label.SALESORGONEOTCUK && ssd.LCRM_Sales_Org__c !=label.SALESORGONEOTCUS && ssd.LCRM_Sales_Org__c !='WEST' && ssd.LCRM_Sales_Org__c !='CARS' && !(System.Label.Risk_Sales_Orgs.contains(ssd.LCRM_Sales_Org__c))) 
        && (loggedUser.Segment__c != null && (loggedUser.Segment__c== Label.SALESORGCORP || loggedUser.Segment__c== Label.SUBBUGLOBAL  )) && loggedUser.Sub_Bu__c!= Label.SALESORGCAN){  
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, label.CorpProposalCreationError));
        return null;
    }*/
    List<Business_Partner_Function__c> businnesPartner = new List<Business_Partner_Function__c> ();
    if(Schema.sObjectType.Business_Partner_Function__c.fields.id.isAccessible()&& Schema.sObjectType.Business_Partner_Function__c.fields.Sold_To_Account_GLI__c.isAccessible()&&Schema.sObjectType.Business_Partner_Function__c.fields.Relationship_Type__c.isAccessible()){
        businnesPartner =[Select id,Sold_To_Account_GLI__c,Relationship_Type__c  from Business_Partner_Function__c where Sold_To_Account_GLI__r.Id=:ssd.id];
    }
    Boolean status =false;
    for(Business_Partner_Function__c bp :businnesPartner ){
        if(bp.Relationship_Type__c =='Sold to party' || bp.Relationship_Type__c =='Sold-to party'|| bp.Relationship_Type__c =='Sold To'){
        status = true;
        break;
        }
    }
    //DOC-12752-Commented as part of CrossSell
    //DOC 3111 Poonam Garg Added condition for Canada    
    if(businnesPartner.size() == 0 && ssd.Source_System_Account_Number__c!=null 
        /*&& ((subBuWestSet.contains( loggedUser.Default_Catalog__c) && loggedUser.Default_Catalog__c != null )
        || (loggedUser.Segment__c != null && (loggedUser.Segment__c == Label.SALESORGCORP || loggedUser.Segment__c == Label.SUBBUGLOBAL || loggedUser.Sub_Bu__c==Label.SUBBUGLOBAL || (loggeduser.Segment__c ==Label.SALESORGTAX && loggedUser.Sub_Bu__c==Label.SALESORGTAXREG)))
        || (loggedUser.Sub_Bu__c== Label.SALESORGCAN || (loggedUser.Sub_Bu__c==Label.SUBBUGLOBAL && opp.LCRM_Sub_BU__c==Label.SALESORGCAN) ))*/)
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sold To Account required for Proposal creation'));
        return null;
    }
    //DOC-12752-Commented as part of CrossSell
   //DOC 3111 Poonam Garg Added condition for Canada
    //DOC-4784 Gokila Added condition for Tax Professional   
    else if(businnesPartner.size() > 0 && status ==false 
        /*&& ((subBuWestSet.contains( loggedUser.Default_Catalog__c) && loggedUser.Default_Catalog__c != null )
        || (loggedUser.Segment__c != null && (loggedUser.Segment__c == Label.SALESORGCORP || loggedUser.Segment__c == Label.SUBBUGLOBAL || loggedUser.Sub_Bu__c==Label.SUBBUGLOBAL || (loggeduser.Segment__c ==Label.SALESORGTAX && loggedUser.Sub_Bu__c==Label.SALESORGTAXREG)))
        || (loggedUser.Sub_Bu__c== Label.SALESORGCAN || (loggedUser.Sub_Bu__c==Label.SUBBUGLOBAL && opp.LCRM_Sub_BU__c==Label.SALESORGCAN) ))*/){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sold To Account required for Proposal creation'));
        return null;
    }
    else{    
        PageReference pageRef = Page.Apttus_Proposal__OpportunityProposalCreate;
        pageRef.getParameters().put('id',(String)(string.escapeSingleQuotes(OppId)));
        
        
        return pageRef;        
    }
}

    public Pagereference cancel(){
        PageReference pg = new PageReference('/'+oppId);
        
        return pg;
    
    }

}