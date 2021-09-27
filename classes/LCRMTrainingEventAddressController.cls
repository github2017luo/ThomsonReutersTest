/**
* Controller class for LCRM Training Event Address Section VF page
*
* @author  Saloni Sukhija
* @version 2017-06-27
*/

public without sharing class LCRMTrainingEventAddressController{

    public ApexPages.StandardController oStandardController;
    public Training_Event__c oTrainingEvent;
     
    public boolean isEditable{get;set;}
    public boolean ServiceError {get;set;}
    public boolean SkipAddressCleanse {get;set;}
    public boolean isTrainingUser{get;set;}
     
    public LCRMTrainingEventAddressController(ApexPages.StandardController oController) {
        oStandardController = oController;
        oTrainingEvent = (Training_Event__c) oController.getRecord();
        isEditable = false;
        ServiceError = false;
        SkipAddressCleanse = false;
        if (!Schema.sObjectType.PermissionSetAssignment.isAccessible()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        List<PermissionSetAssignment> assignment =  [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name IN ('LCRM_GLI_Training_Users','LCRM_USL_Training_Users')];
         String profileName = [SELECT Id,Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        if(assignment.size()>0 || profileName=='System Administrator')
            isTrainingUser = true;   
    }
     
    public void changeToEdit(){
        isEditable = true;
    }
    
     public void save(){ //Changed the return type as part of Sales Lightning rollout
        if(oTrainingEvent.LCRM_Address_1__c!=null || oTrainingEvent.LCRM_Address_2__c!=null || oTrainingEvent.LCRM_City__c!=null || oTrainingEvent.LCRM_State__c!=null || oTrainingEvent.LCRM_Postcode_Zip__c!=null || oTrainingEvent.LCRM_Country__c!=null ){
            try {
                if(AppUtil.isEmpty(oTrainingEvent.LCRM_Address_1__c)){
                   throw new LCRMAddressException(Label.TrainingEventAddressError_Address1required);
                }
                
                if(!AppUtil.isEmpty(oTrainingEvent.LCRM_Address_1__c) && oTrainingEvent.LCRM_Address_1__c.length()>35){
                   throw new LCRMAddressException(Label.TrainingEventAddressError_Address1cannotexceed35characters);
                }
                
                if(!AppUtil.isEmpty(oTrainingEvent.LCRM_City__c) && oTrainingEvent.LCRM_City__c.length()>40){
                   throw new LCRMAddressException(Label.TrainingEventAddressError_Citycannotexceed40characters);
                }
                if(!AppUtil.isEmpty(oTrainingEvent.LCRM_Postcode_Zip__c) && oTrainingEvent.LCRM_Postcode_Zip__c.length()>10){
                   throw new LCRMAddressException(Label.TrainingEventAddressError_Postcodecannotexceed10characters);
                }
            
                //Validate Address
                DataQualityUtil.Address oAddress = new DataQualityUtil.Address();
                oAddress.Street = oTrainingEvent.LCRM_Address_1__c;
                oAddress.City = oTrainingEvent.LCRM_City__c;
                oAddress.State = oTrainingEvent.LCRM_State__c;
                oAddress.PostalCode = oTrainingEvent.LCRM_Postcode_Zip__c;
                oAddress.Country = oTrainingEvent.LCRM_Country__c;
                
                if (SkipAddressCleanse == false && !Test.isRunningTest()){
                    oAddress = DataQualityUtil.cleanseAddress(oAddress);
                }
                
                //Update Address
                oTrainingEvent.LCRM_Address_1__c = oAddress.Street;
                oTrainingEvent.LCRM_City__c = oAddress.City;
                oTrainingEvent.LCRM_State__c = oAddress.State;
                oTrainingEvent.LCRM_Postcode_Zip__c = oAddress.PostalCode;
                oTrainingEvent.LCRM_Country__c = oAddress.Country;
            }
            
            catch(LCRMAddressException addressException){
                ApexPages.addMessages(addressException);
                //return null; //commented as part of sales lightning roll-out
            }   
            catch (DataQualityUtil.AddressCleanseServiceException addressCleanseServiceException) {
                ServiceError = true;
                ApexPages.addMessages(addressCleanseServiceException);
                //return null; //commented as part of sales lightning roll-out
            }
            catch (Exception unknownException) {
                ApexPages.addMessages(unknownException);
                //return null; //commented as part of sales lightning roll-out
            }
        }
         
    try{
        if(!Schema.sObjectType.Training_Event__c.isUpdateable()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        update oTrainingEvent;
    }
    catch(Exception e){
        ApexPages.addMessages(e);
        //return null; //commented as part of sales lightning roll-out
    }
         
    isEditable = false;
    PageReference oPage = Page.LCRMTrainingEventAddressSection;
    oPage.getParameters().put('id',oTrainingEvent.id);
    oPage.setRedirect(true);
    //return oPage; //commented as part of sales lightning roll-out
    }
     
    public void continueSave(){ //changed the return type as part of sales lightning roll-out
        this.SkipAddressCleanse = true;        
        //return save(); //commented as part of sales lightning roll-out
        save(); //added as part of sales lightning roll-out
    }
     
    public PageReference cancel(){
        isEditable = false;
        PageReference oPage = Page.LCRMTrainingEventAddressSection;
        oPage.getParameters().put('id',oTrainingEvent.id);
        //oPage.setRedirect(true); //commented as part of sales lightning roll-out
        oPage.setRedirect(false); //added as part of sales lightning roll-out
        return oPage;
    }
     
    public class LCRMAddressException extends Exception{}
}