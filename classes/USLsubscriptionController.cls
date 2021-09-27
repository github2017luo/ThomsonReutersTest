public without sharing class USLsubscriptionController{
    public Boolean renderedNonInfo{get;set;}
    public Boolean renderedPgblock{get;set;}
    public String strSalesOrg{get;set;}
    public Boolean tempflag{get;set;}
    //CRM-13578
    public String strSubBu{get;set;}
    public Account oAccount{get;set;}
    public string sSelectedOption{get;set;}
    public String webserviceName = 'SubscriptionService';
    public List<String> accountSapIdList{get;set;}
    
    public String field{get;set;}
    public String sortOrder{get;set;}   
    public Integer totalNumberOfSubscription{get;set;}        

    public User sCurrentUser{get;set;}
    public String sTranslatedSelectOption{get;set;}
    public List<Source_System_Detail__c> listofSSD;

    public Set<ID> accountIdSet{get;set;}
    public USLsubscriptionsJsonWrapper.USLsubscriptionRequestWrapper rwquestWrapper;
    public list<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listDisplaySubscriptionResponse {get;set;}
    //below variables used for pagination
    public List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listofSubscriptioninfo{get;set;}
     public List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listofallSubscriptioninfo{get;set;}
    public List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> displayUSLsubscription {get;set;}
    public List<List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>> genericDisplayUSLsubscription {get;set;}
    //DSS-3663 code block start
    public map<string,USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> selectedwrappermap;
    public list<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> selectedwrappertotal;
    public map<string,USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> oSelectedmap{get;set;}
    public boolean selectall{get;set;}
    public string renderAsdoc{get;set;}
    public string renderAsExcel{get;set;}
    public Integer sizeOfOpenMap { get { return oSelectedmap.size(); } }
    //DSS-3663 code block end
    public Paginate ordPaginater {get;set;}  
    Public Integer startnum{get;set;}
    Public Integer pagesize{get;set;}
    Public Integer endnum{get;set;}
    public Source_System_Detail__c  oSSD{get;set;}
    
    //DSS-8713 Finplan key code changes start
    public List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listofFinplaninfo{get;set;}
    public boolean inRole {get;set;}
    //DSS-8713 Finplan key code changes end
/*
Constructor USLsubscriptionController, get the SAp Account numbers from SSD according to Account parent/child relationship
*/
    public USLsubscriptionController(ApexPages.StandardController controller){
        tempflag = false;
        String temps = apexpages.currentpage().getparameters().get('flag');
        if(temps == 'true'){
            tempflag = true;
        }
        oSSD = new Source_System_Detail__c();
        endnum=0;
        startnum=0;
        renderedNonInfo = false;   
        renderedPgblock = false;
        listofSSD = new List<Source_System_Detail__c>();
        accountSapIdList = new List<String>();
        field = 'MATERIAL_NUMBER';
        sortOrder = 'ascending';
        accountIdSet = new Set<ID>(); 
        totalNumberOfSubscription = 0;
        sTranslatedSelectOption = ''; 
        final string applicationId ='ESCU';
        String companyId = 'West';
        final String timeStamp = '';
        String includeActiveSubs='true';
        String includeLapsedSubs='true';
        String partnerType='SH';
        String maxResults = '250';
        String subType='ALL';
        final String startRecord='1';
        String language='EN';
        String isPrimary='true';
        String isActive='true';
        String applyDate='';
    try{
        if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
        sCurrentUser = [select LanguageLocaleKey,Sales_Org__c,Sub_Bu__c from User where id = :UserInfo.getUserId()];
        }
        sSelectedOption ='All Active';  
        strSubBu  = sCurrentUser.Sub_Bu__c;
        listofSubscriptioninfo = new list<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>(); 
        listofallSubscriptioninfo = new list<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>(); 
        
        //DSS-8713 Finplan key code changes start
        listofFinplaninfo = new list<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>(); 
        inRole = false;
        //DSS-8713 Finplan key code changes end
        
         //DSS-3663 code block start
        selectedwrappermap = new map<string,USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        selectedwrappertotal = new list<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
        oSelectedmap= new map<string,USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> ();
        //DSS-3663 code block end
        Map<String,SubscriptionTypes__c> mapSubscriptionTypes = SubscriptionTypes__c.getAll();
        
        
         oSSD = (Source_System_Detail__c) controller.getRecord();
          if(Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){
         oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.Sales_Org__c  FROM Source_System_Detail__c where id = :oSSD.id ];
          }
   
  
        USLsubscriptionsJsonWrapper.EsiHeadercls esiHeaderRec = new USLsubscriptionsJsonWrapper.EsiHeadercls(applicationId,companyId,timeStamp); 
        USLsubscriptionsJsonWrapper.Accountcls accountRe= new USLsubscriptionsJsonWrapper.Accountcls(oSSD.Source_System_Account_Number__c,language,companyId,isPrimary,isActive,applyDate);
        USLsubscriptionsJsonWrapper.GetSubscriptionsByAccountFiltercls getSubscriptionsByAccountFilterRec = new USLsubscriptionsJsonWrapper.GetSubscriptionsByAccountFiltercls(partnerType,includeLapsedSubs,includeActiveSubs);
        rwquestWrapper= new USLsubscriptionsJsonWrapper.USLSubscriptionRequestWrapper(esiHeaderRec,accountRe,getSubscriptionsByAccountFilterRec);
        system.debug('**rwquestWrapper**'+rwquestWrapper);
       
            listofSubscriptioninfo = USLsubscriptionsJsonWrapper.getUSLSubscriptionResponse(rwquestWrapper);
            listofallSubscriptioninfo.addall(listofSubscriptioninfo);
    }Catch(Exception Exp){
        System.debug('Exp'+Exp);
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,+Exp.getMessage()));
        System.Debug('Error:-'+Exp.getMessage());
    }
}

/*
sortSubscription method used for while changing the sub type values from View picklist
*/
    public void sortSubscription(){
        System.debug('** call sortSubscription Method**');
        displayUSLSubcriptioninfo();
    }
/*
displaySubscription method used for fetching the  values from response
*/    
    public pagereference displayUSLSubcriptioninfo(){
    System.debug('**call Method displayUSLSubcriptioninfo**');
  
              this.displayUSLsubscription= new List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
              this.genericDisplayUSLsubscription =new List<List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>> ();
            
             if(listofallSubscriptioninfo.size()>0){
              List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> tmplst =new List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
                for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse lapse :listofallSubscriptioninfo ){
                //DSS-3663 code block start 
                   if(selectedwrappermap != null && selectedwrappermap.containskey(lapse.subscriptionNumber)){
                        lapse.isselected = true;
                   }
                   if(test.isrunningtest()){
                            lapse.isselected = true;
                   }
                //DSS-3663 code block end   
                    system.debug('sSelectedOption'+sSelectedOption+'-lapse.MediaType'+lapse.MediaType);
                   if(sSelectedOption==label.USL_AllLapsed){
                        if(lapse.lapseIndicator=='X'){
                            tmplst.add(lapse);
                        }
                   }
                   else if(sSelectedOption==label.USL_AllActive){
                        if(lapse.lapseIndicator=='' || lapse.lapseIndicator== Null){
                            tmplst.add(lapse);
                        }
                   }
                   else if(sSelectedOption==label.USL_CD){
                        if(lapse.MediaType=='CD'){
                            tmplst.add(lapse);
                        }
                   }
                   else if(sSelectedOption==label.USL_Software){
                        if(lapse.MediaType=='Software'){
                            tmplst.add(lapse);
                        }
                   }
                  else if(sSelectedOption==label.USL_print){
                        if(lapse.MediaType=='Print'){
                            tmplst.add(lapse);
                        }
                  }
                  else if(sSelectedOption==label.USL_Online){
                        if(lapse.MediaType=='Online'){
                            tmplst.add(lapse);
                        }
                  }
                   else if(sSelectedOption==label.USL_Others){
                        if(lapse.MediaType=='Others'){
                            tmplst.add(lapse);
                        }
                  }
                        
                  else {
                       tmplst.add(lapse);
                   }           
         
            }
            if(tmplst.size()>0){
            listofSubscriptioninfo=tmplst;
            }
            else{
                listofSubscriptioninfo.clear();
            }
              totalNumberOfSubscription  = listofSubscriptioninfo.size();
            }
      /*      if(listofSubscriptioninfo.size()>0){
            system.debug('**listofSubscriptioninfo**'+listofSubscriptioninfo);
                 pageSize = 20;
                 endnum=pageSize;
                 this.ordPaginater  = new Paginate(listofSubscriptioninfo.size(), pageSize);
                 renderedPgblock = false;
                 renderedNonInfo = false;  
                   // totalNumberOfSubscription  = listofSubscriptioninfo.size();    
                                 
                    List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> tempCC = new List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
                Integer i = 0;
                for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse cc : listofSubscriptioninfo){
                     tempCC.add(cc);
                    i++;
                    if(i == pageSize){
                    this.genericDisplayUSLsubscription.add(tempCC);
                    tempCC = new List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();  
                    i = 0;
                    }
                    }
                    System.debug('tempCC:-'+tempCC);
                    if(!tempCC.isEmpty()){
                        this.genericDisplayUSLsubscription.add(tempCC);
                    }
                    this.displayUSLsubscription= this.genericDisplayUSLsubscription.get(this.ordPaginater.index);
            }*/
    return null;
    }
 /*--------------------------------------------------------------------------------------------------------------------------------       
   
 Get the source system details based on current logged in users sales org value should be matched with SSD sales Org field value

----------------------------------------------------------------------------------------------------------------------------------*/
    public List<Source_System_Detail__c> getSourceSystemDetails(Set<Id> listAccId,String strSubBu){
        System.debug('**call Method getSourceSystemDetails**');
        List<Source_System_Detail__c> ssdList = new List<Source_System_Detail__c>();
        if(strSubBu == 'USL'){
             System.debug('USL');
            if(Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){ 
            ssdList = [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c  IN ('USL') and LCRM_Sales_Org__c!= null];  
            }
            return ssdList;
            }else{
            System.debug('Other Profiles ');
            if(Schema.sObjectType.Source_System_Detail__c.isAccessible() || Schema.sObjectType.Source_System_Detail__c.isQueryable()){
             ssdList = [Select id,name,Source_System_Account_Number__c,Account_Name__c,LCRM_Sales_Org__c,LCRM_Sub_BU__c from Source_System_Detail__c Where Account_Name__c in :listAccId and Source_System_Account_Number__c != null and LCRM_Sub_BU__c=:strSubBu and LCRM_Sales_Org__c!= null];  
            }
            return ssdList;
        }
    }
    

/*
    GetSubscriptionListOptions method used for retrieving the value in View picklist which is displayed in the LCRMScubscription VF page and this is a mandatory field in input request parameters for fetching the response from external System.
*/     
   public List<selectoption> getSubscriptionListOptions(){
        System.debug('**call Method getSubscriptionListOptions**');
        List<selectoption> subscriptionsList = new  List<selectoption>();   
        
            subscriptionsList.add(new SelectOption(System.Label.USL_AllLapsed,System.Label.USL_AllLapsed)); 
            subscriptionsList.add(new SelectOption(System.Label.USL_AllActive,System.Label.USL_AllActive));
            subscriptionsList.add(new SelectOption(System.Label.USL_ALL,System.Label.USL_ALL));
            subscriptionsList.add(new SelectOption(System.Label.USL_CD,System.Label.USL_CD));
            subscriptionsList.add(new SelectOption(System.Label.USL_print,System.Label.USL_print));
            subscriptionsList.add(new SelectOption(System.Label.USL_Online,System.Label.USL_Online));
            subscriptionsList.add(new SelectOption(System.Label.USL_Software,System.Label.USL_Software));
            subscriptionsList.add(new SelectOption(System.Label.USL_Others,System.Label.USL_Others));
      
        subscriptionsList.sort();       
        return subscriptionsList;
    }
  /*   public PageReference previousPage(){
        this.ordPaginater.decrement();
        changeData();
        endnum=startnum;
        startnum=endnum-displayUSLsubscription.size();
        return null;
    }

    public PageReference nextPage(){
        this.ordPaginater.increment();
        changeData();
        startnum=endnum;
        endnum=endnum+displayUSLsubscription.size();
        return null;
    }

    public PageReference updatePage(){
        this.ordPaginater.updateNumbers();
        return changeData();
    }
    
    public PageReference changeData(){
        this.displayUSLsubscription = this.genericDisplayUSLsubscription.get(this.ordPaginater.index);
        return null;
    }*/
    //DSS-3663 code block start
    public PageReference saveAsPDF(){
        processSelected();
        PageReference pr;
        if(sizeOfOpenMap > 0){ 
         pr = new PageReference('/apex/USLSSDSubscriptionDownloadPage');
        renderAsdoc='pdf';
        pr.setRedirect(false);   
        return pr;
        }
        else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select ateast one subscription to download'));
        return null;
        }   
    }
    public PageReference saveAsExcel(){
        processSelected();
        PageReference pr;
        if(sizeOfOpenMap > 0){ 
         pr = new PageReference('/apex/USLSSDSubscriptionDownloadPage');
         renderAsExcel='application/vnd.ms-excel#SubscriptionReport.xls'; 
        pr.setRedirect(false);
        return pr; 
        }
        else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select ateast one subscription to download'));
        return null;
        }     
        
    }
    public Void processSelected(){
    for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse wrapobj:selectedwrappertotal){
            if(wrapobj.isSelected==true){
                oSelectedmap.put(wrapobj.subscriptionNumber,wrapobj);
            }
            }
    }
    public void saveselectedopen(){
        for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse wrapobj:listofSubscriptioninfo){
            if(wrapobj.isselected){
                if(!selectedwrappermap.containskey(wrapobj.subscriptionNumber)){                
                selectedwrappertotal.add(wrapobj);
                }
                selectedwrappermap.put(wrapobj.subscriptionNumber,wrapobj);
            }
        }
    }
    public void selectalllineitem(){
            for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse wrapobj:listofallSubscriptioninfo){
            if(!selectedwrappermap.containskey(wrapobj.subscriptionNumber)){                
                selectedwrappertotal.add(wrapobj);
            }
            selectedwrappermap.put(wrapobj.subscriptionNumber,wrapobj);
            if(selectall){
                wrapobj.isselected=true;
            }
            if(!selectall){
                 wrapobj.isselected=false;       
            }
        }
        
    }
    
    //DSS-3663 code block end
    //DSS-8713 Finplan key code changes start
    public PageReference displayFinplanSubcriptioninfo(){
                List<User> userlist = new List<User>();
                 Set<String> roleList = new Set<String>();  
                for(USL_Roles_Static_CC_Milestone__c rv : USL_Roles_Static_CC_Milestone__c.getAll().values()) {
                   roleList.add(rv.Rolename__c);
                }
                if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
                    userlist =[select Id,UserRole.DeveloperName from User where id =: Userinfo.getuserId()];
                 } 
              if(userlist.size()>0){ 
                for(user u : userlist){
                 if(roleList.contains(u.UserRole.DeveloperName)){
                  inRole= true;
                 }
                 }
                }
                if(inRole){
                for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse finsub : listofSubscriptioninfo){
                System.debug('entered for Finplan' +finsub);
                 if (finsub.licenseKeyCode != '' && finsub.licenseKeyCode != null){
                    listofFinplaninfo.add(finsub);
                 }  
                }
                }
                else{
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,+ System.Label.ESC_USLCSRoles));
                }
                return null;
                }
            //DSS-8713 Finplan key code changes end
}