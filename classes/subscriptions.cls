/*
======================================================================================================================
CLASS NAME:    subscriptions 
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public class subscriptions {
    //Properties
    Public Account oAccount{get;set;}
    public string sSelectedOption{get;set;}
    public List<SubscriptionServices.Subitem> SubitemList{get;set;}   
    
    
    public list<SubscriptionServices.SubUseritem> oSubUseritem{get;set;}
    public List<SubscriptionServices.SortParm> listParmNames;
    
    public SubscriptionServices.Subitem oSubitem{get;set;}
    public boolean detailFlag{get;set;}
    public boolean mainBlockFlag{get;set;}
  
    
    public boolean subuseritemFlag{get;set;}
    public decimal[] accountSapIdList{get;set;}
    public integer pagenumber{get;set;}
    public integer totalpages{get;set;}
    public integer pagesize{get;set;}       
    
    public String strCompanyCode{get;set;}
    public String strSalesOrgCode{get;set;}
    public String strDistChanCode{get;set;}
    public String strDivisionCode{get;set;}
    
    
    public String field{get;set;}
    public String sortOrder{get;set;}   
    public Integer totalNumberOfSubscription{get;set;}        
  
    public PagingSubscriptions oPagingSubscriptions {get;set;} 
    public SubscriptionServices.SubsRequest oRequest;
    public String sSelectedSubs {get; set;}
    public User sCurrentUser{get;set;}
    public String sTranslatedSelectOption{get;set;}
   
    
    //Constructor
    
    public subscriptions(ApexPages.StandardController controller) {            
        
        mainBlockFlag = true;
        listParmNames = new SubscriptionServices.SortParm[]{};
        field = 'MaterialDesc';
        sortOrder = 'ASC';
       
        try{
            sCurrentUser = [select LanguageLocaleKey from User where id = :UserInfo.getUserId()];
            sSelectedOption ='All Active';           
            oAccount = new account();
               if (Test.isRunningTest()) {   // code snippet added as part of S2E Optimization to increase coverage
                  oAccount = [select id, parentId, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c, Account_Indicator__c from account where id = : controller.getRecord().Id];
             }
             else{           
            controller.addFields(new string[]{'SAPAccountNumber__c','parentId','CompanyCodeDescription__c','Sales_Org__c','DistributionChannel__c','DivisionCodeDescription__c','Account_Indicator__c'});
            oAccount = (account) controller.getRecord();
            }
            SubitemList = new list<SubscriptionServices.Subitem>();
          
            oSubUseritem= new list<SubscriptionServices.SubUseritem>();
            oSubitem= new SubscriptionServices.Subitem();
            
           
            IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAccount.Sales_org__c);
            
            strCompanyCode = oIXOSCodeMap.Company_Code__c;
            strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            strDivisionCode = oIXOSCodeMap.Division_Code__c;
         
            accountSapIdList =  new Decimal[]{};
            
            if(oAccount.parentid!=null || oAccount.Account_Indicator__c=='Branch'){
                if(oAccount.SAPAccountNumber__c != null){
                    accountSapIdList.add(Decimal.valueOf(oAccount.SAPAccountNumber__c));
                }
                else{
                        accountSapIdList.add(Decimal.valueOf('-1'));
                    }                  
                }
            else{
                for(Account acc:[select id,SAPAccountNumber__c from account where id in :AccountDetailController.getChildAccountIds(oAccount.id)]){
                    if(acc.SAPAccountNumber__c != null){
                        accountSapIdList.add(Decimal.valueOf(acc.SAPAccountNumber__c));
                    }                                       
                }            
            }
            DisplaySubsList();  
        }
         catch (Exception oException) {
            ApexPages.addMessages(oException);
        }  
    
    }
    
    /*
    Called on selection of Subs Type
    */
 
   public void sortSubscription(){
 
     
        field = 'MaterialDesc';
        sortOrder = 'ASC';
       
                  
        displaySubsList();
   }
   
   
    /*
    sets productid of SubscriptionServices.subs
    @param SubscriptionServices.subs object
    */
   
   // Public Methods
   /*
    Retrieve subscription items based on the select list value
    @return SubscriptionServices.Subitem object
    */ 
    public pagereference displaySubsList(){
        Map<String,SubscriptionTypes__c> mapSubscriptionTypes = SubscriptionTypes__c.getAll();
        sTranslatedSelectOption = '';
        
        oRequest = new SubscriptionServices.SubsRequest();
        oRequest.SystemId = 'SFDC CORE LEGAL'; 
        oRequest.AcctSAPId = accountSapIdList;
        oRequest.CompanyCode = strCompanyCode;
        oRequest.SalesOrgCode = strSalesOrgCode;
        oRequest.DistChanCode = strDistChanCode;
        oRequest.DivisionCode = strDivisionCode;
        oRequest.IncludeActiveSubs=true;
        oRequest.IncludeLapsedSubs=true;
        oRequest.MaxResults = 250;
        oRequest.SubType='ALL';  
         
        
        
        try{

            if(sSelectedOption == 'ALL Lapsed'){
              oRequest.SubType='ALL';  
              oRequest.IncludeActiveSubs=false;
              oRequest.IncludeLapsedSubs=true;
              
                                            
            }   
            if(sSelectedOption =='All Active'){               
                    
                oRequest.IncludeActiveSubs=true;
                oRequest.IncludeLapsedSubs=false;
                oRequest.SubType='ALL';
               
            }   
            if(sSelectedOption =='Online'){
                  
                 oRequest.SubType = 'ONLINE';   
                     
            }            
            if(sSelectedOption =='FindLaw'){
              
                 oRequest.SubType = 'FINDLAW';     
                         
            }
            if(sSelectedOption =='Print'){
             
                 oRequest.SubType = 'PRINT';         
                    
            }
            if(sSelectedOption =='WPD'){           
            
                 oRequest.SubType = 'WPD';
                 
                 
            }
            if(SubitemList == null){
                SubitemList = new list<SubscriptionServices.Subitem>() ;
            }    
            
            oRequest.listSortParms = new SubscriptionServices.SortParm[]{};
            SubscriptionServices.SortParm oSortParm = new SubscriptionServices.SortParm();
          
                if((sSelectedOption =='ALL Active' || sSelectedOption =='ALL Lapsed')){
                        oRequest.listSortParms.add(new SubscriptionServices.SortParm());
                        oRequest.listSortParms[0].sParmName = field;
                        oRequest.listSortParms[0].sSortDirection = sortOrder;
                  }     
                else if((sSelectedOption =='WPD' || sSelectedOption =='Online' || sSelectedOption =='Print' || sSelectedOption =='Findlaw')){
                        
                        oRequest.listSortParms.add(new SubscriptionServices.SortParm());
                        oRequest.listSortParms[0].sParmName = 'SubscriptionStatus';
                        oRequest.listSortParms[0].sSortDirection ='ASC';
                        if(field == 'SubscriptionStatus') {
                            oRequest.listSortParms[0].sSortDirection = sortOrder;
                        }  
                        oRequest.listSortParms.add(new SubscriptionServices.SortParm());
                        oRequest.listSortParms[1].sParmName = field;
                        oRequest.listSortParms[1].sSortDirection = sortOrder;    
                                            
              }
          
             // Translating the selectedOption into User's languages
            
             if(sCurrentUser.LanguageLocaleKey == 'es'){
                 
                  
                       if(sSelectedOption == 'All Active'){
                           sTranslatedSelectOption = 'Todas las suscripciones Activas';
                       }
                       if(sSelectedOption == 'All Lapsed'){
                           sTranslatedSelectOption = 'Todas las suscripciones Expiradas';
                       }
                       if(sSelectedOption == 'FindLaw'){
                           sTranslatedSelectOption = 'Suscripciones FindLaw';
                       }
                       if(sSelectedOption == 'Online'){
                           sTranslatedSelectOption = 'Suscripciones OnLine';
                       }
                      
                       if(sSelectedOption == 'Print'){
                           sTranslatedSelectOption = 'Suscripciones Impresas';
                       }
                       
                 }
             else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                       sTranslatedSelectOption = mapSubscriptionTypes.get(sSelectedOption).Portuguese__c; 
                       
                       if(sSelectedOption == 'All Active'){
                           sTranslatedSelectOption = 'Todas Assinaturas Ativas';
                       }
                       if(sSelectedOption == 'All Lapsed'){
                           sTranslatedSelectOption = 'Todas Assinaturas Caducadas';
                       }
                       if(sSelectedOption == 'FindLaw'){
                           sTranslatedSelectOption = 'FindLaw Assinaturas';
                       }
                       if(sSelectedOption == 'Online'){
                           sTranslatedSelectOption = 'Assinaturas OnLine';
                       }
                      
                       if(sSelectedOption == 'Print'){
                           sTranslatedSelectOption = 'Assinturas Impresas';
                       }
                      
                 }
             else{
                    sTranslatedSelectOption = sSelectedOption +' Subscriptions';
             }
       
            
            oPagingSubscriptions = new PagingSubscriptions(oRequest);
      
            oPagingSubscriptions.PageSize = 250;
            oPagingSubscriptions.getSubscriptions();
          
            totalNumberOfSubscription  = oPagingSubscriptions.TotalRecs = SubscriptionServices.TotalofRecs; 
            if(oPagingSubscriptions.listofSubscription.size()!=0)
            {
                for(SubscriptionServices.SubItem lst:oPagingSubscriptions.listofSubscription)                 
                {
                    lst.MaterialNumber=lst.MaterialNumber.substring(10);                          
                                                                         
                }
            }
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        } 
        
        
        return null;       
    }
    
    
    /*
    Returns list of values to be slected in the page
    @return List of selectoption
    */
    
     public List<selectoption> getSubscriptionListOptions(){
        List<selectoption> SubscriptionsList = new  List<selectoption>();              
        Map<String,SubscriptionTypes__c> mapSubscriptionTypes = SubscriptionTypes__c.getAll();

        string sProfileName=[select id, name from profile where id=:userinfo.getProfileId()].name.toUpperCase();  

        System.debug(mapSubscriptionTypes+'*****');
        for(SubscriptionTypes__c oSubscriptionType : mapSubscriptionTypes.values()){
             if(oSubscriptionType.Name == 'WPD'){
                  if((sProfileName.contains('WPD')|| sProfileName.contains('ADMIN'))){
                        if(sCurrentUser.LanguageLocaleKey == 'es'){
                           SubscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Spanish__c));                      
                           }
                        else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                            SubscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Portuguese__c));      
                        }
                        else{
                            SubscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Name));    
                        }
                  }
            }
            else if(sCurrentUser.LanguageLocaleKey == 'es'){
                   SubscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Spanish__c));                      
                   }
                else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                    SubscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Portuguese__c));      
                }
                else{
                    SubscriptionsList.add(new selectoption(oSubscriptionType.Name, oSubscriptionType.Name));    
                }
        }

        return SubscriptionsList;
    }
    
    public void translateSubscriptionView(){
        
    }
    
    /*
    Returns subscription List for wpd subscriptions
   
    */
    
    public List<asset> getWPDsubscriptionList(){
       return [select id , name, WLEC_Type__c, WLEC_Number_Of_Seats__c, Usage__c, PurchaseDate,External_Id__c ,UsageEndDate,Product2.Topic__c, Product2.Media_Lower_Level__c, Product2.Media_High_Level__c, Product2.Category__c
                from asset where Accountid=:oAccount.id];
    }
    
    /*
    sets up osubitem when detail link is clicked
   
    */
    
    public void displayDetail(){
        try{
             string subsId=ApexPages.currentPage().getParameters().get('subsId');
            oSubitem= new SubscriptionServices.Subitem();
            for(SubscriptionServices.Subitem s : oPagingSubscriptions.listofSubscription){
                if(subsId== s.subkey){
                    oSubItem=s;
                }   
            }
            detailFlag=true;     
            subuseritemFlag=false;
            mainBlockFlag=false;
        }
        catch (Exception oException) {
            ApexPages.addMessages(oException);
        }   
    }
    
    /*
    sets up osubitem when subuseritem link is clicked
   
    */
    public void displaySubUserItem(){
        try{
            oSubUseritem= new list<SubscriptionServices.SubUseritem>();
            string subsId=ApexPages.currentPage().getParameters().get('subsId');            
            for(SubscriptionServices.Subitem s: oPagingSubscriptions.listofSubscription){
                if(subsId == s.subkey){                                 
                    SubscriptionServices.SubUserRequest oSubUserRequest = new SubscriptionServices.SubUserRequest();                                           
                    oSubUserRequest.AcctSAPId = s.AcctSapId;
                    oSubUserRequest.CompanyCode = strCompanyCode;
                    oSubUserRequest.SalesOrgCode = strSalesOrgCode;
                    oSubUserRequest.DistChanCode = strDistChanCode;
                    oSubUserRequest.DivisionCode = strDivisionCode;                       
                    oSubUserRequest.ContractNumber=s.ContractNumber; 
                    oSubUserRequest.OrderItem=s.OrderItem;                       
                    SubscriptionServices oSubscriptionServices = new SubscriptionServices();                       
                    oSubUseritem=oSubscriptionServices.GetSubUserItem(oSubUserRequest);
                    osubitem=s;
                    break;  
                }
            }                
            detailFlag=false;    
            subuseritemFlag=true;
            mainBlockFlag = false;
        }
        catch (Exception oException) {
           ApexPages.addMessages(oException);
        }
    }       
     
    public List<selectOption> sortSubscriptionByfield{
        get {
            List<selectOption> options = new List<selectOption>();
            List<String> listOfFields = new List<String>(SubscriptionSortByField__c.getAll().Keyset());
            listOfFields.sort();        
              for(String sSubsField: listOfFields){   
               if(sCurrentUser.LanguageLocaleKey == 'es'){
                   options.add(new selectoption(SubscriptionSortByField__c.getInstance(sSubsField).Sort_By__c, SubscriptionSortByField__c.getInstance(sSubsField).Spanish__c));
                   }
               else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                    options.add(new selectoption(SubscriptionSortByField__c.getInstance(sSubsField).Sort_By__c, SubscriptionSortByField__c.getInstance(sSubsField).Portuguese__c));
                   } 
               else
                    options.add(new SelectOption(SubscriptionSortByField__c.getInstance(sSubsField).Sort_By__c,SubscriptionSortByField__c.getInstance(sSubsField).name));                          
                }      
            return options; 
        }
        set;
    }


    public List<SelectOption> getSortByOrder(){
        List<SelectOption> options = new List<SelectOption>();
        list<String> listOfSortOrder = new list<String>(Sort_Order__c.getAll().keySet());
        listOfSortOrder.sort();
        for(String sSortOrder : listOfSortOrder){
            if(sCurrentUser.LanguageLocaleKey == 'es'){
                options.add(new SelectOption(Sort_Order__c.getInstance(sSortOrder).Name, Sort_Order__c.getInstance(sSortOrder).Spanish__c));
            }
            else if(sCurrentUser.LanguageLocaleKey == 'pt_BR'){
                options.add(new SelectOption(Sort_Order__c.getInstance(sSortOrder).Name, Sort_Order__c.getInstance(sSortOrder).Portuguese__c));
            }
            else{
                options.add(new SelectOption(Sort_Order__c.getInstance(sSortOrder).Name, Sort_Order__c.getInstance(sSortOrder).English__c));
            }
        }
        return options;
    }
    
    public class PagingSubscriptions extends Pageable {
        public List<SubscriptionServices.SubItem> listofSubscription{get;set;}
        public Integer Totalrecs;
        public SubscriptionServices.SubsRequest oRequest;
        
        public PagingSubscriptions() {
            ListofSubscription = new List<SubscriptionServices.SubItem>();
            TotalRecs = 0;
            
        }
        
        public PagingSubscriptions(SubscriptionServices.SubsRequest oRequest){
            this.oRequest = oRequest;
        }
        
        public override integer getRecordCount() {
            return (listofSubscription == null ? 0 : TotalRecs);
        }
            
       public void getSubscriptions(){
          oRequest.StartRec = (PageIndex * Pagesize +1);
          
          listofSubscription = SubscriptionServices.getSubItems(oRequest);
          
       }
       public override void moveNext(){
            super.moveNext();
            getSubscriptions();
        }
        
       public override void movePrev(){
           super.movePrev();
           getSubscriptions();
       }
       
        public override void moveLast(){
            super.moveLast();
            getSubscriptions();
        }
        
        public override void moveFirst(){
           super.moveFirst();
           getSubscriptions();
        }
    }
    
    
    public class AccountSubscriptions {
    }
}