Public class USL_CVM_Special_Offer_Cancellation{

    /*   Object  */
    public ESC_Case_Form_Extension__c CFE {get;set;} 
    Public Case Caseacc{get;set;}

    /* list object */
    list<ESC_Case_Form_Extension__c> ListCFE =new list<ESC_Case_Form_Extension__c>();
    /* boolean */
    Public Boolean disablenext{get;set;}
    public boolean isshowSpecialBilling{get;set;}
    public boolean isshowProduct{get;set;}
    public boolean alllocation{get;set;}
    public List<List<SubsWrapper>> Genericsubs {get;set;}
    Public Integer pagesize{get;set;}
    Public Integer Startnum{get;set;}
    Public Integer Endnum{get;set;}
    public List<SubsWrapper> SubsList{get;set;}
    public Paginate ordPaginater {get;set;}
    /* string id  */
    public String CaseId{get;set;}
    public String formId{get;set;}
    public string formname;
    public String Accnum{get;set;}
    public String Nosubs{get;set;}
    public List<SubsWrapper> Displaysubs {get;set;}
    public List<String> SelectedSubsList{get;set;} 
    public boolean showlistacc {get;set;}
    public USL_CVM_Special_Offer_Cancellation(){
        endnum=0;
        Startnum=0;
        ListCFE =new list<ESC_Case_Form_Extension__c>();
        Caseacc =new case();
        disablenext=false;
        showlistacc = false;
        Nosubs='';      
        isshowSpecialBilling=false;
        isshowProduct =false;
        alllocation=false;
        SubsList= new List<SubsWrapper>();
        try{
            CaseId = ApexPages.currentPage().getParameters().get('caseid');
            formId = ApexPages.currentPage().getParameters().get('formid');
            Caseacc =[select id,USL_SAP_Account_Number__c,Case.Owner.email,Case.AccountId  from case where id=:caseid];
            if(formId != null && formId != '')
            formname = [Select name from GenerateForm__c where id=:formId].name;
            Accnum=Caseacc.USL_SAP_Account_Number__c;
            CFE = new ESC_Case_Form_Extension__c();
            CFE.esc_case__c = caseid;
            CFE.esc_form__c = formid;
            List<ESC_Case_Form_Extension__c> cfelist= new List<ESC_Case_Form_Extension__c>();
          
             cfelist=[select ESC_Selected_Subs__c,Special_billing_allocation__c,Location__c,ESC_Type_of_Account_Number__c,ESC_Assigned_Sales_Rep__c,ESC_Reason_For_Termination__c,ESC_Competitors_Name__c,Product_Type__c,ESC_Special_Offer__c,ESC_Special_Offer_check__c,ESC_Special_Offer_time__c,ESC_Segment_Special_offer__c,ESC_Special_Offer_Account__c,ESC_Instructions__c,ESC_List_Product__c from ESC_Case_Form_Extension__c where ESC_case__c=:caseid and ESC_form__c=:formID];
            if(cfelist.size()>0){
                CFE=cfelist[0]; 
              
            }
     
            if(caseacc.USL_SAP_Account_Number__c == '' || caseacc.USL_SAP_Account_Number__c == null) {
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Usl_SAPAccError));
            }
            List<String> onloadselectedlist = new List<String>();
            Integer Count=0;
            if(CFE.ESC_Selected_Subs__c!=null)
                onloadselectedlist=CFE.ESC_Selected_Subs__c.split(';');
            if(accnum != '' && accnum != null){          
                List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse> listofSubscriptioninfo= new List<USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse>();
                USLsubscriptionsJsonWrapper.EsiHeadercls EsiHeaderRec = new USLsubscriptionsJsonWrapper.EsiHeadercls('ESCU','West',''); 
                            
                List<USLsubscriptionsJsonWrapper.Accountcls> Accountlst =new List<USLsubscriptionsJsonWrapper.Accountcls>();
                USLsubscriptionsJsonWrapper.Accountcls AccountRe= new USLsubscriptionsJsonWrapper.Accountcls(Accnum,'EN','WEST','true','true','');
                USLsubscriptionsJsonWrapper.GetSubscriptionsByAccountFiltercls Getsubs = new USLsubscriptionsJsonWrapper.GetSubscriptionsByAccountFiltercls('SH','true','true');

                USLsubscriptionsJsonWrapper.USLSubscriptionRequestWrapper RwquestWrapper= new USLsubscriptionsJsonWrapper.USLSubscriptionRequestWrapper(EsiHeaderRec,AccountRe,Getsubs);
                
                listofSubscriptioninfo = USLsubscriptionsJsonWrapper.getUSLSubscriptionResponse(RwquestWrapper);     
                this.Displaysubs= new List<SubsWrapper>();
                this.Genericsubs =new List<List<SubsWrapper>> ();
                if(listofSubscriptioninfo.size()>0){
                    for(USLsubscriptionsJsonWrapper.DisplaySubscriptionResponse c:listofSubscriptioninfo){
                        if(onloadselectedlist.contains(c.materialNumber)){
                            SubsList.add(new SubsWrapper(c.materialNumber,c.materialDescription,true));
                        }
                        else{
                            count++;
                            SubsList.add(new SubsWrapper(c.materialNumber,c.materialDescription,false));
                        }
                    }
                
                    pageSize = 50;
                    endnum=pageSize;
                    this.ordPaginater  = new Paginate(SubsList.size(), pageSize);
                    List<SubsWrapper> tempCC = new List<SubsWrapper>();
                    Integer i = 0;
                    for(SubsWrapper cc : SubsList){
                        tempCC.add(cc);
                        i++;          
                        if(i == pageSize){
                          this.Genericsubs.add(tempCC);
                          tempCC = new List<SubsWrapper>();  
                          i = 0;
                        }
                    }
                    if(!tempCC.isEmpty()){
                        this.Genericsubs.add(tempCC);
                    }
                    this.Displaysubs= this.Genericsubs.get(this.ordPaginater.index);
                }
            }
        } 
        catch(Exception e){
            disablenext=true; 
            Nosubs=e.getMessage();
        }
    }
 
    public PageReference previousPage(){
        this.ordPaginater.decrement();
        changeData();
        endnum=startnum;
        startnum=endnum-Displaysubs.size();
        return null;
    }

    public PageReference nextPage(){
        this.ordPaginater.increment();
        changeData();
        startnum=endnum;
        endnum=endnum+Displaysubs.size();
        return null;
    }
    public PageReference changeData(){
        this.Displaysubs = this.Genericsubs.get(this.ordPaginater.index);
        return null;
    }
 
    public void showdecision(){        
        if(CFE.Special_billing_allocation__c == 'Yes' && CFE.Location__c=='Individual Locations'){
            isshowSpecialBilling = true;
        }
        else{
            isshowSpecialBilling = false;           
        }
        if(CFE.Location__c=='Individual Locations'){
            showlistacc = true;
        }
        else{
            showlistacc = false;
        }
    }
    
    public void  showProducttype(){       
       if(CFE.Product_Type__c == 'Multiple Products' || CFE.Product_Type__c=='OTHER'){
            isshowProduct = true;
        }
        else{
            isshowProduct = false;
        }
    } 
          
    


    public boolean  validate(){
        SelectedSubsList= new List<String>();
        for(SubsWrapper sl:SubsList){
            if(sl.IsSelected){
                SelectedSubsList.add(sl.MaterialNum);
            }
        }
        if(SelectedSubsList.size()== 0){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select atleast one subscription.'));
            return false;
        }
                
        if(CFE.Special_billing_allocation__c == null || CFE.Special_billing_allocation__c == ''){
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Special billing allocation is required '));
            return false;
        }
        if(CFE.Location__c == '' || CFE.Location__c == null){
           Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Location is required '));
            return false;
        }
        if(CFE.Product_Type__c==null || CFE.Product_Type__c == ''){        
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Product Type is required. '));
            return false;
        }
        if(isshowProduct && (CFE.ESC_List_Product__c==null || CFE.ESC_List_Product__c=='')){           
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Products are required. '));
            return false;
        }
    
        if(CFE.ESC_Special_Offer_time__c==null ){          
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a valid date  '));
            return false;
        }
        if(CFE.ESC_Segment_Special_offer__c==null || CFE.ESC_Segment_Special_offer__c==''){       
            Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Segment is required. '));
            return false;
        }
        return true;  
    }
    
    
 
     
 
    public void Savebutton(){    
        if(validate()){               
            for(SubsWrapper sl:SubsList){
                if(sl.IsSelected){
                    SelectedSubsList.add(sl.MaterialNum);
                }
                if(SelectedSubsList.size()>0){                    
                    CFE.ESC_Selected_Subs__c=String.join(SelectedSubsList,';');
                }                
            }
            try{
                if(CFE.id==null){
                    Insert CFE;
                }
                else{
                    update CFE;
                }
                ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(CaseId,formId,formname);
                if(obj.validateFormSegmentMappingExist()){
                    obj.createReferral();
                }
                else{
                    List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
                    Group g=[Select Id from Group where DeveloperName =:Label.CSConsultantTeam]; 
                    ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                    ref.ESC_Role__c = 'Accountable Resolver';
                    ref.ESC_Referral_Status__c = 'New';
                    ref.ESC_Case__c = caseid;
                    ref.ownerid = g.id;
                    referralinsertlist.add(ref);
                    insert referralinsertlist;
                }
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data is saved successfully'));
            }
            catch(Exception e){
                Apexpages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            }
        }
    
    }
   
      
    
    public class SubsWrapper{
        public String Description{get;set;}
        public String MaterialNum {get;set;}
        public Boolean IsSelected{get;set;}
        
        public SubsWrapper(String mn,String Des,Boolean issel){
            this.Description=Des;
            this.MaterialNum=mn;
            this.IsSelected=issel;
        }
    }  
    
}