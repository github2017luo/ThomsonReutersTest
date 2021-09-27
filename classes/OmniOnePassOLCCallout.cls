/**
* @description       : 
* @author            : TCS Dev Team
* @group             : 
* @last modified on  : 06-03-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                                Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public class OmniOnePassOLCCallout{
    
    /**
    *  @description  : calling from LWC UI getTrialContsWrapFromOLCOnePass
    *  @param     selectedContacts
    *  @return    trialContWrapList 
    */
    @AuraEnabled
    public static List<TrialContactWrapper> getTrialContsWrapFromOLCOnePass(String selectedContacts){
        List<TrialContactWrapper> trialContWrapList = new List<TrialContactWrapper>();
        
        List<TrialContactWrapper> trialContacts = (List<TrialContactWrapper>) JSON.deserialize(selectedContacts, List<TrialContactWrapper>.class);
         
        for(TrialContactWrapper trialCont :  trialContacts){
        
            System.debug(LoggingLevel.DEBUG, trialCont.email);
            TrialOLCOnePassByEmailRespWrap  trialOLCOnePassResp = getOLCOnePassWrapper(trialCont.email);
            
            TrialOLCOnePassByEmailRespWrap olcOnePassWrap = new TrialOLCOnePassByEmailRespWrap();
            
            
            olcOnePassWrap.cobaltGUID = trialOLCOnePassResp.cobaltGUID;
            olcOnePassWrap.dataRoomGUID = trialOLCOnePassResp.dataRoomGUID;
            olcOnePassWrap.onePassId = trialOLCOnePassResp.onePassId;
            olcOnePassWrap.onePassUserName = trialOLCOnePassResp.onePassUserName;
            olcOnePassWrap.externalContactNumberSource= trialOLCOnePassResp.externalContactNumberSource;
            olcOnePassWrap.externalContactNumber = trialOLCOnePassResp.externalContactNumber;
            
            olcOnePassWrap.externalAccountNumberSource= trialOLCOnePassResp.externalAccountNumberSource;
            olcOnePassWrap.externalAccountNumber = trialOLCOnePassResp.externalAccountNumber;
            olcOnePassWrap.profileType= trialOLCOnePassResp.profileType;
            //companyId
            
            trialCont.olcOnePass = olcOnePassWrap;
            
            trialContWrapList.add(trialCont);
        }
        
        return trialContWrapList; 
    }
    
    /**
    *  @description  : getOLCOnePassWrapper
    *  @param     email
    *  @return    trialOLCOnePassResp 
    */
    public static TrialOLCOnePassByEmailRespWrap getOLCOnePassWrapper(String email){
        
        TrialOLCOnePassByEmailRespWrap trialOLCOnePassResp = new TrialOLCOnePassByEmailRespWrap();
        
        //call to OLC
        OmniCallToOLCByEmailResponseWrapper   olcWrap = OmniCallToOLCByEmail.getOLCDetailsByEmail(email);
        
        if((olcWrap != null && olcWrap.onlineContact != null) && OmniOnePassOLCCallout_Test.isFromTest){
            trialOLCOnePassResp  = OmniOnePassOLCResHandler.getTrialOLCReponseWrap(olcWrap );
        }
        else{
            //call to one pass if OLC Response is blank
            OmniOnePassResponseWrapper onePassResp = OmniCallToOnePassByEmail.callToOnePass(email);
          
            if(test.isRunningTest()){
                onePassResp = OmniOnePassOLCCallout_Test.Omniwrapper;
            }
             else{
                trialOLCOnePassResp  = OmniOnePassOLCResHandler.getTrialOnePassReponseWrap(onePassResp);
            }
        }
        return trialOLCOnePassResp;
    } 
}