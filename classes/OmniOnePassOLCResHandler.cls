/**
* @description       : 
* @author            : TCS Dev Team
* @group             : 
* @last modified on  : 06-03-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public class OmniOnePassOLCResHandler{
    
    /**
    *  @description  : getTrialOLCReponseWrap
    *  @param     olcWrap 
    *  @return    trialRespWrap
    */
    public static TrialOLCOnePassByEmailRespWrap getTrialOLCReponseWrap(OmniCallToOLCByEmailResponseWrapper   olcWrap ){
       
        TrialOLCOnePassByEmailRespWrap trialRespWrap = new TrialOLCOnePassByEmailRespWrap();
        
        //default value
        trialRespWrap.profileType='NEW_CUSTOMER';
        
        trialRespWrap = getTrialContWrapOLC(olcWrap, trialRespWrap);
        
        return trialRespWrap;
    }
     
    /**
    *  @description  : getTrialOnePassReponseWrap
    *  @param     onePassResp 
    *  @return    trialRespWrap
    */
    public static TrialOLCOnePassByEmailRespWrap getTrialOnePassReponseWrap(OmniOnePassResponseWrapper onePassResp ){
    
        TrialOLCOnePassByEmailRespWrap trialRespWrap = new TrialOLCOnePassByEmailRespWrap();
        
        //default value
        trialRespWrap.profileType='NEW_CUSTOMER';
        
        trialRespWrap = getTrialContWrapFromOnePass(trialRespWrap, onePassResp.Results);
        
        return trialRespWrap;
    }
     
    /**
    *  @description  : getTrialContWrapFromOnePass
    *  @param     trialRespWrap
    *  @param      results
    *  @return    trialRespWrap
    */
    @testVisible
    private static TrialOLCOnePassByEmailRespWrap getTrialContWrapFromOnePass(TrialOLCOnePassByEmailRespWrap trialRespWrap, List<OmniOnePassResponseWrapper.Results> results){
        
        for(OmniOnePassResponseWrapper.Results result : results){
            
            List<OmniTrialsProfilesWrapper.Profiles> profiles = result.Profiles;
            
            if(profiles != null){
                for(OmniTrialsProfilesWrapper.Profiles  profile : profiles ){
                
                    trialRespWrap.onePassId = profile.Identifier;
                    //OnePass
                    trialRespWrap.onePassUserName = profile.Username;
                    trialRespWrap = getPrismGuidFromOnePass(trialRespWrap, profile.RegisteredProducts);
                }
            }
        }
        return trialRespWrap;
    }
    
    /**
    *  @description  : getPrismGuidFromOnePass
    *  @param     trialRespWrap
    *  @param      registPrds
    *  @return    trialRespWrap
    */
    @testVisible
    private static TrialOLCOnePassByEmailRespWrap getPrismGuidFromOnePass(TrialOLCOnePassByEmailRespWrap trialRespWrap,List<OmniTrialsProfilesWrapper.RegisteredProducts> registPrds){
        
        List<OmniTrialsProfilesWrapper.RegisteredProducts> registProds = registPrds;
        if(registProds != null){
            for(OmniTrialsProfilesWrapper.RegisteredProducts registPrd : registProds){
                
               for(OmniRegistrationKeyWrapper.RegistrationKeys registKey : registPrd.RegistrationKeys){
                   
                   trialRespWrap = getPrismGuidLogic(trialRespWrap, registPrd.ProductCode, registKey.Properties);
                }
            }
        }
        return trialRespWrap;
    }
    
    /**
    *  @description  : getPrismGuidLogic
    *  @param     trialRespWrap
    *  @param      registPrdProductCode
    *  @param      properties
    *  @return    trialRespWrap
    */
    @testVisible
    private static TrialOLCOnePassByEmailRespWrap getPrismGuidLogic(TrialOLCOnePassByEmailRespWrap trialRespWrap,String registPrdProductCode, List<OmniRegistrationKeyWrapper.Properties> properties){
        String productCodValues = 'CBT,CBTUAT,CPA,CRSW,PLCUK,PRODOC,PRODOCPTL,WLNTAX,PLCCA';
        List<String> productCodeValueList = productCodValues.split(',');
        
        List<OmniRegistrationKeyWrapper.Properties> propertiesList = properties;
        if(propertiesList != null){
            for(OmniRegistrationKeyWrapper.Properties property : properties){
                if(String.isNotBlank(registPrdProductCode) && productCodeValueList.contains(registPrdProductCode)){
                    trialRespWrap.cobaltGUID = property.Value;
                }
                else if(registPrdProductCode == 'DATAROOM'){
                    trialRespWrap.dataRoomGUID = property.Value;
                }
            }
        }
        return trialRespWrap;
    }
    
    
     
    /**
    *  @description  : getTrialContWrapOLC
    *  @param      olcWrap
    *  @param      trialRespWrap
    *  @return    trialRespWrap
    */
    @testvisible
    private static TrialOLCOnePassByEmailRespWrap getTrialContWrapOLC(OmniCallToOLCByEmailResponseWrapper olcWrap,TrialOLCOnePassByEmailRespWrap trialRespWrap){
        
        if(olcWrap != null && olcWrap.onlineContact != null){
            
            trialRespWrap = getTrialCOntWrapFromOLC(trialRespWrap, olcWrap.onlineContact);
            
        }
        
        return trialRespWrap;
    } 
    
    /**
    *  @description  : getTrialContWrapFromOLC
    *  @param     trialRespWrap
    *  @param     onlineCont
    *  @return    trialRespWrap
    */
    @testVisible
    private static TrialOLCOnePassByEmailRespWrap getTrialContWrapFromOLC(TrialOLCOnePassByEmailRespWrap trialRespWrap, List<OmniCallToOLCByEmailResponseWrapper.OnlineContact>  onlineCont){
    
        for(OmniCallToOLCByEmailResponseWrapper.OnlineContact  cont : onlineCont){
            trialRespWrap.externalContactNumber = cont.contactNumber;
            trialRespWrap.externalContactNumberSource = cont.sourceId;
            
            trialRespWrap.externalAccountNumber = cont.account.accountNumber;
            trialRespWrap.companyId = cont.account.companyId;
            trialRespWrap.externalAccountNumberSource = cont.sourceId;
            
            //find COBALT and DATAROOM GUID Id
            trialRespWrap= getCOBALTDATAROOMGuid(trialRespWrap, cont.entitlements);
        }
        
        return trialRespWrap;
    }
    
    
    /**
    *  @description  : getCOBALTDATAROOMGuid
    *  @param     trialRespWrap
    *  @param      entitlements
    *  @return    trialRespWrap
    */
    @testVisible
    private static TrialOLCOnePassByEmailRespWrap getCOBALTDATAROOMGuid(TrialOLCOnePassByEmailRespWrap  trialRespWrap, List<OmniOLCEntitlementsWrapper.Entitlements> entitlements){
        
        for(OmniOLCEntitlementsWrapper.Entitlements entil : entitlements){
            
            if(entil.applicationId == 'COBALT'){
                trialRespWrap.cobaltGUID = entil.appUserGuid;
                trialRespWrap.onePassId = entil.authId;
                //OlC
                trialRespWrap.onePassUserName = entil.logonName;
            }
            else if(entil.applicationId == 'DATAROOM'){
                trialRespWrap.dataRoomGUID= entil.appUserGuid;
            }
            
            if(trialRespWrap.profileType != 'EXISTING_CUSTOMER_SAME_DOMAIN'){
                trialRespWrap = getProfileType(trialRespWrap, entil);
            }
        }
        
        return trialRespWrap;
    }
    
    
    /**
    *  @description  : getCOBALTDATAROOMGuid
    *  @param     trialRespWrap
    *  @param      entil
    *  @return    trialRespWrap
    */
    @testVisible
    private static TrialOLCOnePassByEmailRespWrap getProfileType(TrialOLCOnePassByEmailRespWrap  trialRespWrap, OmniOLCEntitlementsWrapper.Entitlements entil){
        if(entil.status != null && entil.applicationId != null)
        {
            if(entil.status.equalsIgnoreCase('ACTIVE') && entil.applicationId.equalsIgnoreCase('COBALT'))
            {
                trialRespWrap.profileType = 'EXISTING_CUSTOMER_SAME_DOMAIN';
            }
            else if(((entil.status.equalsIgnoreCase('INACTIVE') && entil.applicationId.equalsIgnoreCase('COBALT')) || 
                (entil.status.equalsIgnoreCase('ACTIVE') && entil.applicationId != 'COBALT'))
                )
            {
                trialRespWrap.profileType = 'EXISTING_CUSTOMER_NEW_DOMAIN';
            }
        }   
        return trialRespWrap;
    } 
}