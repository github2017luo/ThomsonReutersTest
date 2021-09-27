/*
===============================================================================
AddressCleanseController
===============================================================================

PURPOSE: To cleanse and display cleansed address data                   

FUNCTIONALITY: Display cleansed info and on edit clean provided address data using data services

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE            NAME                    DESC
2011-06-16    Nick Cook                 Created against re-factored DataServices 
                                            and DataServicesWS classes
                                            
===============================================================================
*/


public with sharing class AddressCleanseController {

    //properties
    private Account mObjAccount; 
    private ApexPages.StandardController mStandardController;
    
    public boolean editMode{get;set;}
    public boolean readMode{get;set;}
    public boolean bDataServiceError{get;set;}
    
    public string StreetAddress{get;set;}
    public string StreetAddress2{get;set;}
    public string StreetAddress3{get;set;}
    public string StreetAddress4{get;set;}
    public string StreetAddress5{get;set;}
    public string City{get;set;}
    public string State{get;set;}
    public string PostalCode{get;set;}
    public string Province{get;set;}
    public string POBox{get;set;}
    public string County{get;set;}
    public string Country{get;set;}
    public string AccountName{get;set;}
    public string Building{get;set;}
    public string DXNumber{get;set;}
    public string Level{get;set;}
    public string SubUrb{get;set;}
    public boolean accessflg{get;set;}
    public Recordtype oRecordtype;
    public String rectypename{get;set;}
    
    public AddressCleanseController(ApexPages.StandardController stdController) 
    {
    //  mObjAccount = (Account)stdController.getRecord();
       mObjAccount = [Select BillingStreet,Street_Address_2__c,RecordTypeId,
                        Street_Address_3__c,
                        Street_Address_4__c,
                        Street_Address_5__c,                        
                        BillingCity,
                        BillingState,
                        BillingCountry,
                        BillingPostalCode,
                        County__c,
                        PO_Box__c,
                        Province__c,
                        Name,
                        ANZ_Building__c,
                        ANZ_DX_Number__c,
                        ANZ_Level__c,
                        ANZ_Suburb__c from Account where Id=:stdController.getId()];
        mStandardController = stdController;
        readMode = true;
        editMode = false;
        bDataServiceError = false;
        
        defaultAccountValues();
    }   
        
    private void defaultAccountValues()
    {
      
        oRecordtype = [Select Id,name from Recordtype where Id=:mObjAccount.RecordTypeId];
        rectypename = oRecordtype.name;
        StreetAddress = mObjAccount.BillingStreet;
        StreetAddress2 = mObjAccount.Street_Address_2__c;
        StreetAddress3 = mObjAccount.Street_Address_3__c;
        StreetAddress4 = mObjAccount.Street_Address_4__c;
        StreetAddress5 = mObjAccount.Street_Address_5__c;                        
        City = mObjAccount.BillingCity;
        State = mObjAccount.BillingState;
        Country = mObjAccount.BillingCountry;
        PostalCode= mObjAccount.BillingPostalCode;
        POBox = mObjAccount.PO_Box__c;
        Province = mObjAccount.Province__c;
        AccountName = mObjAccount.Name;
        Building = mObjAccount.ANZ_Building__c;
        DXNumber = mObjAccount.ANZ_DX_Number__c;
        Level = mObjAccount.ANZ_Level__c;
        SubUrb = mObjAccount.ANZ_Suburb__c;

        
    }       
        
        
    //methods
    public PageReference edit()
    {
        readMode = false;
        editMode = true;
        return null;
    }
    
    public PageReference cancel()
    {
        mObjAccount.BillingStreet = StreetAddress;
        StreetAddress2 = mObjAccount.Street_Address_2__c;
        StreetAddress3 = mObjAccount.Street_Address_3__c;
        StreetAddress4 = mObjAccount.Street_Address_4__c;
        StreetAddress5 = mObjAccount.Street_Address_5__c;     
        mObjAccount.BillingCity = City;
        mObjAccount.BillingState = State;
        mObjAccount.BillingCountry = Country;
        mObjAccount.BillingPostalCode = PostalCode;
        POBox = mObjAccount.PO_Box__c;
        Province = mObjAccount.Province__c;
        Building = mObjAccount.ANZ_Building__c;
        DXNumber = mObjAccount.ANZ_DX_Number__c;
        Level = mObjAccount.ANZ_Level__c;
        SubUrb = mObjAccount.ANZ_Suburb__c;
        readMode = true;
        editMode = false;
        bDataServiceError = false;
        return null;
    }   
    
    public PageReference save(){ 
        try {
            DataServices oDataServices = new DataServices();
            DataServices.AddressInfo oRequest = new DataServices.AddressInfo();
            oRequest.Street = mObjAccount.BillingStreet;
            oRequest.City = mObjAccount.BillingCity;
            oRequest.State = mObjAccount.BillingState;
            oRequest.PostalCode = mObjAccount.BillingPostalCode;
            oRequest.Country = mObjAccount.BillingCountry;
            oRequest.County = mObjAccount.County__c;
            oRequest.Name = mObjAccount.Name;
            
            DataServices.AddressInfo oResponse = DataServices.cleanseAddress(oRequest);
            
            if (oResponse.IsCleansed) {
                mObjAccount.BillingStreet = AppUtil.toTitleCase(oResponse.Street);
                mObjAccount.BillingCity = AppUtil.toTitleCase(oResponse.City);
                mObjAccount.BillingState = oResponse.State;
                mObjAccount.BillingPostalCode = oResponse.PostalCode;
                mObjAccount.BillingCountry = oResponse.Country;
                mObjAccount.County__c = AppUtil.toTitleCase(oResponse.County); 
                
                mObjAccount.Secondary_Range__c = oResponse.SECONDARY_RANGE;
                mObjAccount.Street_Name__c = oResponse.STREET_NAME;
                mObjAccount.Street_Post_Dir__c = oResponse.STREET_POST_DIR;
                mObjAccount.Street_Pre_Dir__c = oResponse.STREET_PRE_DIR;
                mObjAccount.Street_Range__c = oResponse.STREET_RANGE;
                mObjAccount.Street_Type__c = oResponse.STREET_TYPE;
                
                upsert mObjAccount;
                
                String msMessage = 'Data Quality corrected for address components.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,msMessage,'resultMessage'));
                readMode = true;
                editMode = false;
            }
            else {
                bDataServiceError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                'Data Services returned an address correction error: ' + oResponse.ErrorMessage,
                'resultMessage'));
                readMode = false;
                editMode = true;        
            }
            return null;            
        }       
        catch(Exception oException) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,oException.getMessage(),'resultMessage'));
            return null;                        
        }
    }
    
    public PageReference savewithoutCleanse()
    {
        try
        {
            upsert mObjAccount;
            bDataServiceError = false; 
            readMode = true;
            editMode = false;   
            
            return null;
        }
        catch(Exception oException)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,oException.getMessage(),'resultMessage'));
            return null;
        }
    }
    
    
    
}