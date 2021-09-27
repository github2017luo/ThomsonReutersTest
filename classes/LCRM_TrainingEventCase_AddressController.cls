/**
* Controller class for LCRM GLI Training Event Case Address Section
*
* @author  Saloni Sukhija
* @version 2017-05-29
*/

public class LCRM_TrainingEventCase_AddressController{

    public ApexPages.StandardController oStandardController;
    public Case oCase;
     
    public boolean isEditable{get;set;}
    public boolean ServiceError {get;set;}
    public boolean SkipAddressCleanse {get;set;}
     
    public LCRM_TrainingEventCase_AddressController(ApexPages.StandardController oController) {
        oStandardController = oController;
        oCase = (Case) oController.getRecord();
        isEditable = false;
        ServiceError = false;
        SkipAddressCleanse = false;
    }
     
    public void changeToEdit(){
        isEditable = true;
    }
     
    public PageReference save(){
       
        if(oCase.LCRM_Address_1__c!=null || oCase.LCRM_Address_2__c!=null || oCase.LCRM_City__c!=null || oCase.LCRM_State__c!=null || oCase.LCRM_Postcode_Zip__c!=null || oCase.LCRM_Country__c!=null ){
            try {
                if(AppUtil.isEmpty(oCase.LCRM_Address_1__c)){
                   throw new customException(Label.TrainingEventAddressError_Address1required);
                }
                
                if(!AppUtil.isEmpty(oCase.LCRM_Address_1__c) && oCase.LCRM_Address_1__c.length()>35){
                   throw new customException(Label.TrainingEventAddressError_Address1cannotexceed35characters);
                }
                
                if(!AppUtil.isEmpty(oCase.LCRM_City__c) && oCase.LCRM_City__c.length()>40){
                   throw new customException(Label.TrainingEventAddressError_Citycannotexceed40characters);
                }
                if(!AppUtil.isEmpty(oCase.LCRM_Postcode_Zip__c) && oCase.LCRM_Postcode_Zip__c.length()>10){
                   throw new customException(Label.TrainingEventAddressError_Postcodecannotexceed10characters);
                }
            
                //Validate Address
                DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
                oAddress.Street = oCase.LCRM_Address_1__c;
                oAddress.City = oCase.LCRM_City__c;
                oAddress.State = oCase.LCRM_State__c;
                oAddress.PostalCode = oCase.LCRM_Postcode_Zip__c;
                oAddress.Country = oCase.LCRM_Country__c;
                
                if (SkipAddressCleanse == false  && !Test.isRunningTest()){
                    oAddress = DataQualityUtil.cleanseAddress(oAddress);
                }
                
                //Update Address
                oCase.LCRM_Address_1__c = oAddress.Street;
                oCase.LCRM_City__c = oAddress.City;
                oCase.LCRM_State__c = oAddress.State;
                oCase.LCRM_Postcode_Zip__c = oAddress.PostalCode;
                oCase.LCRM_Country__c = oAddress.Country;
            }
                
            catch (DataQualityUtil.AddressCleanseServiceException addressCleanseServiceException) {
                ServiceError = true;
                ApexPages.addMessages(addressCleanseServiceException);
                return null;
            }
            catch (Exception unknownException) {
                ApexPages.addMessages(unknownException);
                return null;
            }
        }
         
        try{
            update oCase;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
             
        isEditable = false;
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        oPage.getParameters().put('id',oCase.id);
        oPage.setRedirect(true);
        return oPage;
    }
     
    public PageReference continueSave(){
        this.SkipAddressCleanse = true;        
        return save();
    }
     
    public PageReference cancel(){
        isEditable = false;
        PageReference oPage = Page.LCRM_GLITrainingEventCase_AddressSection;
        oPage.getParameters().put('id',oCase.id);
        oPage.setRedirect(true);
        return oPage;
    }
     
    public class customException extends Exception{}
}