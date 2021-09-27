/*
===============================================================================
ContactAddressCleanseController
===============================================================================

PURPOSE: To cleanse and display cleansed address data                   

FUNCTIONALITY: Display cleansed info and on edit clean provided address data using data services

COMMENTS:

CHANGE HISTORY
===============================================================================
DATE        NAME          DESC
2011-12-09  Partha        Used Nick's Code for address cleanse controller and  Created against re-factored DataServices 
                      and DataServicesWS classes
                      
===============================================================================
*/


public with sharing class ContactAddressCleanseController {

  //properties
  private Contact mObjContact; 
  private ApexPages.StandardController mStandardController;
  
  public boolean editMode{get;set;}
    public boolean readMode{get;set;}
    public boolean bDataServiceError{get;set;}
  
  public string StreetAddress{get;set;}
  public string StreetAddress2{get;set;}
  public string City{get;set;}
  public string State{get;set;}
  public string PostalCode{get;set;}
  public string County{get;set;}
  public string Country{get;set;}
  public string ContactName{get;set;}
  
  public ContactAddressCleanseController(ApexPages.StandardController stdController) 
    {
        mObjContact = (Contact)stdController.getRecord();
        mStandardController = stdController;
        readMode = true;
        editMode = false;
        bDataServiceError = false;
        
        defaultContactValues();
    }  
    
    private void defaultContactValues()
    {
      StreetAddress = mObjContact.MailingStreet;
      StreetAddress2 = mObjContact.Street_Address_2__c;
        City = mObjContact.MailingCity;
        State = mObjContact.MailingState;
        Country = mObjContact.MailingCountry;
        PostalCode= mObjContact.MailingPostalCode;
        ContactName = mObjContact.Name;
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
      mObjContact.MailingStreet = StreetAddress;
       mObjContact.Street_Address_2__c=StreetAddress2;
        mObjContact.MailingCity = City;
        
        mObjContact.MailingState = State;
        mObjContact.MailingCountry = Country;
        mObjContact.MailingPostalCode = PostalCode;
         
        readMode = true;
        editMode = false;
        bDataServiceError = false;
        return null;
    }  
  
  public PageReference save(){ 
    try {
      DataServices oDataServices = new DataServices();
      DataServices.AddressInfo oRequest = new DataServices.AddressInfo();
      oRequest.Street = mObjContact.MailingStreet;
      oRequest.City = mObjContact.MailingCity;
      oRequest.State = mObjContact.MailingState;
      oRequest.PostalCode = mObjContact.MailingPostalCode;
      oRequest.Country = mObjContact.MailingCountry;
      //oRequest.County = mObjContact.County__c;
      oRequest.Name = mObjContact.Name;
      
      DataServices.AddressInfo oResponse = DataServices.cleanseAddress(oRequest);
      
      if (oResponse.IsCleansed) {
        mObjContact.MailingStreet = AppUtil.toTitleCase(oResponse.Street);
        mObjContact.MailingCity = AppUtil.toTitleCase(oResponse.City);
        mObjContact.MailingState = oResponse.State;
        mObjContact.MailingPostalCode = oResponse.PostalCode;
        mObjContact.MailingCountry = oResponse.Country;
         //mObjContact.County__c = AppUtil.toTitleCase(oResponse.County); 
        
        mObjContact.Secondary_Range__c = oResponse.SECONDARY_RANGE;
                mObjContact.Street_Name__c = oResponse.STREET_NAME;
                mObjContact.Street_Post_Dir__c = oResponse.STREET_POST_DIR;
                mObjContact.Street_Pre_Dir__c = oResponse.STREET_PRE_DIR;
                mObjContact.Street_Range__c = oResponse.STREET_RANGE;
                mObjContact.Street_Type__c = oResponse.STREET_TYPE;
        
        upsert mObjContact;
        
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
        upsert mObjContact;
        bDataServiceError = false; 
        readMode = true;
          editMode = false;  
          
        return null;
      }
      catch(Exception oException)
        {
     // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,oException.getMessage(),'resultMessage'));
      return null;
        }
  }
  
  
  
}