/**
 * Controller for redirecing case to visualforcepage or standard layout depending on seleccted record type 
 * Account standard controller
 *
 * @author  Prathyush
 * @version 2015-05-01
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 *                                                                                                              
 * =============================================================================
 */
 
 public with sharing class CaseRedirectController{
 
 public string accId;
 public String profId; 
 public string salesOrg; 
 public string acctId;
 public Set<Id> lstProfIds; 
    
    public CaseRedirectController(){
        
       
    }
    public string selectedRtype;
    public String getselectedRtype(){
        return selectedRtype;
    }
    public void setselectedRtype(string value){
        this.selectedRtype = value;
    }
    public CaseRedirectController(ApexPages.StandardSetController controller){
        
        accId = ApexPages.currentPage().getParameters().get('id');
        if(accId != NULL && accId.substring(0, 3) == '006') {
            acctId= [Select AccountId FROM Opportunity WHERE Id =:accId].AccountId;
        }
        else if(!test.isrunningtest() && accId != NULL && accId.substring(0, 3) == '003') {
            acctId= [Select AccountId FROM Contact WHERE Id =:accId].AccountId;
        }
        salesOrg = [Select Id,Sales_Org__c from User where Id =: userinfo.getUserId() ].Sales_Org__c;
        lstProfIds = new Set<Id>();
        for(Profile Prof : [Select Id, Name FROM Profile WHERE Name IN ('TR Legal FindLaw User','TR Legal US Sales User','System Administrator') ])
        { 
           lstProfIds.add(Prof.Id);
        }
    }
    
    public List<SelectOption> getItems() {
     List<SelectOption> items = new List<SelectOption>();
    
     //default value
     items.add(new SelectOption('','--Select Record Type --'));
    
     //query force.com database to get the record type of the requested object. and  Name IN ('Findlaw Inquiry', 'SCS Inquiry')
     for(RecordType rt: [select id,name from recordtype where sobjecttype='Case' ]) {
          items.add(new SelectOption(rt.id,rt.name));
      }
    
     return items;
    }
    
    //this method will redirect the case to 'Inquirycase' vf page or standard layout based on selected record type
    public PageReference redirectToPage() {
        
             
        Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = sObjectMap.get('Case') ; // getting Sobject Type
        Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
        
        PageReference pageref = new PageReference('/500/e?ent=Case&nooverride=1');
        if(accId != null){
                if(accId.substring(0, 3) == '003') {
                        pageref.getParameters().put('def_contact_id',accId);
                 }   
                
                pageref.getParameters().put('def_account_id',acctId);
               
                pageref.getParameters().put('retURL','/'+accId);
        }
        else{
                pageref.getParameters().put('retURL','/500/o');
        }
        pageref.setRedirect(true);    
            
        if (selectedRtype == recordTypeInfo.get('Findlaw Inquiry').getRecordTypeId() || selectedRtype == recordTypeInfo.get('SCS Inquiry').getRecordTypeId()){
       
           Pagereference vfPage = Page.Inquirycase;
            if(accId != null){
            
                if(acctId != null){
                vfPage.getParameters().put('def_account_id',acctId); 
                }
                else {
                vfPage.getParameters().put('def_account_id',accId); 
                }
                
                vfPage.getParameters().put('retURL','/'+accId);
            }
            else{
                vfPage.getParameters().put('retURL','/500/o');
            }
            
            return vfPage;
        }
            
        else if(selectedRtype == recordTypeInfo.get('ANZ').getRecordTypeId()){
        
            pageref.getParameters().put('RecordType',selectedRtype);
            
        }
            
        else if(selectedRtype == recordTypeInfo.get('WPD').getRecordTypeId()){
        
            pageref.getParameters().put('RecordType',selectedRtype);
            
        }
            
        else if(selectedRtype == recordTypeInfo.get('Archive Requests').getRecordTypeId()){
        
            pageref.getParameters().put('RecordType',selectedRtype);
            
        }
        
        pageref.getParameters().put('00Na000000B23I2', salesOrg);
        return pageref;
            
    }
    
    public pagereference redirectToANZrecordtype(){
    
        if(!lstProfIds.contains(userinfo.getProfileId())){        
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
            Schema.SObjectType s = sObjectMap.get('Case') ; // getting Sobject Type
            Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
            
            PageReference pageref = new PageReference('/500/e?ent=Case&nooverride=1');
            if(accId != null){
                    system.debug('accid..'+accId);
                    system.debug('objid..'+accId.substring(0, 3));
                    if(accId.substring(0, 3) == '001') {
                        pageref.getParameters().put('def_account_id',accId);
                        
                    } 
                    else if(accId.substring(0, 3) == '003') {
                        pageref.getParameters().put('def_contact_id',accId);
                        pageref.getParameters().put('def_account_id',acctId);
                        
                    }
                    else if(accId.substring(0, 3) == '006') {
                        //pageref.getParameters().put('def_opportunity_id',accId);
                        pageref.getParameters().put('def_account_id',acctId);
                    }
                    pageref.getParameters().put('retURL','/'+accId);
                    pageref.getParameters().put('RecordType',recordTypeInfo.get('ANZ').getRecordTypeId());
            }
            else{
                    pageref.getParameters().put('retURL','/500/o');
                    pageref.getParameters().put('RecordType',recordTypeInfo.get('ANZ').getRecordTypeId());
            }
            pageref.getParameters().put('00Na000000B23I2', salesOrg);
            pageref.setRedirect(true);
            
            return pageref;
        }
        else{
        
            return null;
        }        
    }
 }