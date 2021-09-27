/*
======================================================================================================================
CLASS NAME: GetPaidNoteController  
======================================================================================================================
=
PURPOSE:    LEGACY CODE
 
CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Karthi                 Optimized the code as per JIRA STORY: PS0-1
2017-11-12        Niket                  CRM-7829 The class is modified to handle the 'Get Paid Notes' webservice for USL   
======================================================================================================================
*/
public with sharing class GetPaidNoteController  {
    //Properties
    Public Account oAccount{get;set;}
    public string sSelectedOption{get;set;}    
    public CustomDate__c Calldt{get;set;}
    public Decimal SAPAccountNumber{get;set;}
    public String strCompanyCode{get;set;}
    public String strSalesOrgCode{get;set;}
    public String strDistChanCode{get;set;}
    public String strDivisionCode{get;set;}
    
    public Source_System_Detail__c oSSD{get;set;}//Account SSD instance
    public String profileName{get;set;}//Variable to store the profile name based on user profile Id
    public string strUserSubBU{get;set;}//Variable to store loggedin user SubBu 
    Public static boolean uslCheck = false;//Boolean variable to check whether user is USL user or not
    Private String tempObjIdString;// variable to store the keyPrefix of Account SSD object

    
    /* public date OrderBegDt {get;set;}
public date OrderEndDt {get;set;}*/
    public List<GetPaidNoteServices.PaidNoteInfo> DisplayGetPaidNotesList{get;set;}
    public List<GetPaidNoteServices.PaidNoteInfo> AllGetPaidNotes {get;set;}
    public List<GetPaidNoteServices.PaidNoteInfo> GetPaidNotes {get;set;}
    
    //Constructor
    /*@Desc : SSD id is fetched when user clicks 'GetPaidNotes' button from SSD record page and
    Account id is fetched when user clicks on 'GetPaidNotes' button from SSD record page
    */
    public GetPaidNoteController(ApexPages.StandardController controller){
        try{  
            
            oAccount = new account();
            oSSD = new Source_System_Detail__c();
            String objid = controller.getRecord().id;                    
            String[] types = new String[]{'Source_System_Detail__c'};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
            for(Schema.DescribeSobjectResult res : results) {
                
                tempObjIdString = res.getKeyPrefix();
                
                
            }
            //Desc@@ : The below if loop handles the implementation of USL 'get Paid Notes Webservice.
            if( String.isNotBlank(objid) && String.isNotEmpty(objid) && objid.startswith(tempObjIdString)){
                id profileId = userinfo.getProfileId();
                Profile pObj = [select Name from profile where id = :profileId];
                profileName = pObj.Name;
                
                KeyValueListStore__c tempObj = KeyValueListStore__c.getInstance('LCRMSubBuValues');//Gets the SUBBU value from KeyValueListStore__c custom settings
                String tempSubBuValues = tempObj.TextValue__c;
                KeyValueListStore__c tempProfileObj = KeyValueListStore__c.getInstance('LCRMGLIProfileNames');//Gets the profile name value from KeyValueListStore__c custom settings
                String tempProfileValues = tempProfileObj.TextValue__c;
                                 
                strUserSubBU = LCRMGenericComponent.getUserBU();
                
                if(String.isnotBlank(profileName) && String.isNotEmpty(profileName) && String.isnotblank(strUserSubBU) && String.isnotempty(strUserSubBU))
                {
                    
                    //Desc@@: The loop checks if profileName is 'GLI Sales User' OR 'GLI Sales Ops User' OR 'System Administrator' 
                    if (String.isNotEmpty(tempProfileValues) && String.isNotBlank(tempProfileValues) && tempProfileValues.contains(profileName)){
                        
                        uslCheck = true;
                        //Desc@@: The loop checks if strUserSubBU is 'USL' OR 'LMS' OR 'FindLaw'
                        if(String.isNotEmpty(tempSubBuValues) && String.isNotBlank(tempSubBuValues) && tempSubBuValues.contains(strUserSubBU)){   
                            oSSD = new Source_System_Detail__c();
                            oSSD = (Source_System_Detail__c) controller.getRecord();
                            
                            try{
                                oSSD = [Select Id,LCRM_Sales_org__c,Source_System_Account_Number__c,Account_Name__c,Account_Name__r.SAPAccountNumber__c, Account_Name__r.CompanyCodeDescription__c, Account_Name__r.Sales_Org__c, Account_Name__r.DistributionChannel__c, Account_Name__r.DivisionCodeDescription__c,Account_Name__r.parentId FROM Source_System_Detail__c where id = :oSSD.id]; 
                                
                            }Catch(Exception e){
                                System.debug('EXCEPTION@@@ '+e.getMessage());
                            }
                            
                        }
                    }
                    
                }
                
                
            }
            else{
                System.debug('OTHER USERS');
                /*controller.reset();  
controller.addFields(new string[]{'SAPAccountNumber__c','CompanyCodeDescription__c','Sales_Org__c','DistributionChannel__c','DivisionCodeDescription__c'});                 */
                oAccount = (account) controller.getRecord(); 
                
                oAccount = [select id, parentId, SAPAccountNumber__c, CompanyCodeDescription__c, Sales_Org__c, DistributionChannel__c, DivisionCodeDescription__c from account where id = : oAccount.Id];
                System.debug('oAccount@@'+oAccount);
            }
            Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-24),End_date__c= system.today());   
            //Calldt = new CustomDate__c(Begin_date__c=system.today().addyears(-2),End_date__c= system.today());
            //Calldt = new CustomDate__c(Begin_date__c=system.today(),End_date__c= system.today());
            //Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-1),End_date__c= system.today());
            
            //Desc@@ : The below if-else loop Assignes values as per the USL users and other users 
            if(uslCheck){
                
                if(String.isNotBlank(oSSD.Source_System_Account_Number__c) && String.isNotEmpty(oSSD.Source_System_Account_Number__c)){
                    SAPAccountNumber = Decimal.valueOf(oSSD.Source_System_Account_Number__c); //SSD SAP number is assigned to SAPAccountNumber
                }
                if(String.isNotBlank(oSSD.Account_Name__r.CompanyCodeDescription__c) && String.isNotEmpty(oSSD.Account_Name__r.CompanyCodeDescription__c)){
                    strCompanyCode = oSSD.Account_Name__r.CompanyCodeDescription__c;
                }  
                if(String.isNotBlank(oSSD.Account_Name__r.Sales_Org__c) && String.isNotEmpty(oSSD.Account_Name__r.Sales_Org__c)){
                    strSalesOrgCode = oSSD.Account_Name__r.Sales_Org__c;
                }  
                if(String.isNotBlank(oSSD.Account_Name__r.DistributionChannel__c) && String.isNotEmpty(oSSD.Account_Name__r.DistributionChannel__c)){
                    strDistChanCode = oSSD.Account_Name__r.DistributionChannel__c;
                }  
                if(String.isNotBlank(oSSD.Account_Name__r.DivisionCodeDescription__c) && String.isNotEmpty(oSSD.Account_Name__r.DivisionCodeDescription__c)){
                    strDivisionCode = oSSD.Account_Name__r.DivisionCodeDescription__c;
                } 
                //IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAccount.Sales_org__c);
                //IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.Account_Name__r.Sales_Org__c);
                IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oSSD.LCRM_Sales_org__c);
                strCompanyCode = oIXOSCodeMap.Company_Code__c;
                strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
                strDivisionCode = oIXOSCodeMap.Division_Code__c;
                sSelectedOption = 'All';   
                changeDisplayGetPaidNotesList();  

            }
            else{
                SAPAccountNumber = Decimal.valueOf(oAccount.SAPAccountNumber__c); 
                System.debug('SAPAccountNumber@@ '+SAPAccountNumber);
                strCompanyCode = oAccount.CompanyCodeDescription__c;
                strSalesOrgCode = oAccount.Sales_Org__c;
                strDistChanCode = oAccount.DistributionChannel__c;
                strDivisionCode = oAccount.DivisionCodeDescription__c;
                System.debug('strSalesOrgCode@@@ '+strSalesOrgCode);    
                IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(oAccount.Sales_org__c);
                strCompanyCode = oIXOSCodeMap.Company_Code__c;
                strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
                strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
                strDivisionCode = oIXOSCodeMap.Division_Code__c;
                sSelectedOption = 'All';   
                changeDisplayGetPaidNotesList();  
                
            }
            
            /*SAPAccountNumber = Decimal.valueOf(oAccount.SAPAccountNumber__c); 
System.debug('SAPAccountNumber@@ '+SAPAccountNumber);*/            
            
            
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
    }
    
    public list<GetPaidNoteServices.PaidNoteInfo> GetPaidNotes(CustomDate__c ModifiedDate){
        try{
            if(ModifiedDate.Begin_date__c != null ||  ModifiedDate.End_date__c != null){
                if(ModifiedDate.Begin_date__c > ModifiedDate.End_date__c)
                    // throw new AppUtil.AppException('End Date must not be less than Begin Date'); //Replaced with Custom Label as part of S2E Optimization
                    throw new AppUtil.AppException(Label.GetPaidNoteEx); 
            }
            GetPaidNoteServices oGetPaidNoteServices = new GetPaidNoteServices();
            GetPaidNoteServices.GetPaidNotesRequest oGetPaidNotesRequest = new GetPaidNoteServices.GetPaidNotesRequest();
            oGetPaidNotesRequest.AcctSapId = SAPAccountNumber;
            oGetPaidNotesRequest.CompanyCode = strCompanyCode;
            oGetPaidNotesRequest.DistChanCode = strDistChanCode;
            oGetPaidNotesRequest.DivisionCode = strDivisionCode;
            oGetPaidNotesRequest.SalesOrgCode = strSalesOrgCode;
            oGetPaidNotesRequest.ModifiedDtStart = ModifiedDate.Begin_date__c;
            oGetPaidNotesRequest.ModifiedDtEnd = ModifiedDate.End_date__c;
            /*     if(ModifiedDate.Begin_date__c != null ||  ModifiedDate.End_date__c != null){
if(ModifiedDate.Begin_date__c.daysbetween(ModifiedDate.End_date__c)>31)
throw new AppUtil.AppException('Date range cannot exceed 30 days'); 
}*/  
            system.debug('*oGetPaidNotesRequest**'+oGetPaidNotesRequest);    
            GetPaidNotes = GetPaidNoteServices.GetPaidNotesInfo(oGetPaidNotesRequest);
        }
        catch(Exception oException){
            if(oException.getMessage().contains('timed out'))
                // ApexPages.addMessages(new AppUtil.AppException('Webservice timed out. Please filter the orders furthermore and retry')); //Replaced with Custom Label as part of S2E Optimization
                ApexPages.addMessages(new AppUtil.AppException(Label.TimeOutException));
            else    
                ApexPages.addMessages(oException);
        } 
        return GetPaidNotes;     
    }
    
    // Public Methods
    /*
Retrieve order items based on the select list value
@return OrderServices.OrderInfo object
*/ 
    public void changeDisplayGetPaidNotesList(){
        try{
            if(sSelectedOption == 'All'){
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-24),End_date__c= system.today());
                AllGetPaidNotes = GetPaidNotes(calldt);
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '6 months back'){
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-6),End_date__c= system.today());
                AllGetPaidNotes = GetPaidNotes(calldt);
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '6 - 12 months back'){
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-12),End_date__c= system.today().addMonths(-6));
                AllGetPaidNotes = GetPaidNotes(calldt);
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '12 - 18 months back'){
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-18),End_date__c= system.today().addMonths(-12));
                AllGetPaidNotes = GetPaidNotes(calldt);
                DisplayGetPaidNotesList =  AllGetPaidNotes;
            }
            if(sSelectedOption == '18 - 24 months back'){
                Calldt = new CustomDate__c(Begin_date__c=system.today().addMonths(-24),End_date__c= system.today().addMonths(-18));
                AllGetPaidNotes = GetPaidNotes(calldt);
                DisplayGetPaidNotesList =  AllGetPaidNotes;               
            }
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
        if(DisplayGetPaidNotesList == null){
            DisplayGetPaidNotesList= new List<GetPaidNoteServices.PaidNoteInfo>() ; 
        }     
    }
    
    /*
Returns list of values to be slected in the page
@return List of selectoption
*/
    
    public List<selectoption> getPaidNoteListOptions(){
        List<selectoption> NoteList = new List<selectoption>();
        NoteList.add(new selectoption('All','All'));
        NoteList.add(new selectoption('6 months back','6'));
        NoteList.add(new selectoption('6 - 12 months back','6-12'));
        NoteList.add(new selectoption('12 - 18 months back','12-18'));
        NoteList.add(new selectoption('18 - 24 months back','18-24'));
        return NoteList; 
    }
}