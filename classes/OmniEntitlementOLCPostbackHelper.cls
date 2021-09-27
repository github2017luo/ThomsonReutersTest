/**
* @description       :
* @ JIRA              : DPS-21463
* TestClass       : OmniEntitlementOLCPostback_Test 
* @author            : TCS Devteam
* @group             : 
* @last modified on  : 06-18-2021
* @last modified by  : TCS Devteam
* Modifications Log 
* Ver   Date         Author        Modification
* 1.0   06-18-2021   TCS Devteam   Initial Version
**/
public class OmniEntitlementOLCPostbackHelper {
    
    
    /**
* @description doesRecordExist
* @param prod
* @param productContactIDsMap
* @return trailProductContactsMap
* */  
    
    public static Map<id,Trial_Product_Contact__c> getNeedtoUpdateProductContactsList(OmniEntitlOLCPostbackWrapper.Products prod,Map<string,list<Trial_Product_Contact__c>> productContactIDsMap){
        
        Map<id,Trial_Product_Contact__c> trailProductContactsMap = new Map<id,Trial_Product_Contact__c>();
        
        for(OmniEntitlOLCPostbackWrapper.Contact cont : prod.contact){              
            //Trail Product Contact Start
            OmniEntitlOLCPostbackWrapper.Status prodStatusWrap = prod.Status;
            OmniEntitlOLCPostbackWrapper.Status contactStatusWrap = cont.Status;
            
            Trial_Product_Contact__c trlPrdCon = new Trial_Product_Contact__c();
            if(productContactIDsMap.get(prod.referenceId+'-'+cont.extContactId) != null && productContactIDsMap.get(prod.referenceId+'-'+cont.extContactId).size()>0 &&
               productContactIDsMap.get(prod.referenceId+'-'+cont.extContactId)[0].id != null ){              
                   trlPrdCon.id = productContactIDsMap.get(prod.referenceId+'-'+cont.extContactId)[0].id;
                   /*IF(statWrap.statusCode =='Complete'){
                    trlPrdCon.Entitlement_Status__c= 'Active';
                    }
                    trlPrdCon.Entitlement_Status_Description__c = statWrap.statusDescription;*/
                   trlPrdCon.Entitlement_Status__c= contactStatusWrap.statusCode;
                   trlPrdCon.Entitlement_Status_Description__c = getSubStringText(contactStatusWrap.statusDescription);
                   trlPrdCon.Product_Entitlement_Status__c = prodStatusWrap.statusCode;
                   trlPrdCon.Product_Entitlement_Status_Description__c = getSubStringText(prodStatusWrap.statusDescription);
                   
                   trailProductContactsMap.put(trlPrdCon.id,trlPrdCon);
                   
               }
            
            //Trail Product Contact End
        }
        return trailProductContactsMap;
    }
    
    
    
    
    
    
    /**
* @description getNeedtoUpdateContactsList
* @return contactsMap
* @param prod
* @param productContactIDsMap
*/
    public static Map<id,Trial_Contact__c> getNeedtoUpdateContactsList(OmniEntitlOLCPostbackWrapper.Products prod,Map<string,list<Trial_Product_Contact__c>> productContactIDsMap){
        
        Map<id,Trial_Contact__c> contactsMap = new Map<id,Trial_Contact__c>();
        
        for(OmniEntitlOLCPostbackWrapper.Contact cont : prod.contact){
            
            //Trail Contact Start
            Trial_Contact__c trlContact = new Trial_Contact__c();
            
            trlContact.id = cont.extContactId;
            trlContact.External_Contact_Number__c = cont.contactNumber;
            
            if(trlContact.External_Contact_Number_Source__c == null || trlContact.External_Contact_Number_Source__c== ''){
                trlContact.External_Contact_Number_Source__c ='OLC';
            }
            
            trlContact.One_Pass_ID__c = cont.profileIdentifier;
            
            /*OmniEntitlOLCPostbackWrapper.Status statusWrap = cont.Status;
            
            if(statusWrap.statusCode == 'Complete'){
trlContact.Status__c = 'Active';
}
trlContact.Status_Description__c = statusWrap.statusDescription;*/
            
            
            
            //list<OmniEntitlOLCPostbackWrapper.Users> usrWrap = cont.users;
            trlContact = getCOBALTDATARoomValues(cont.users, trlContact);
            /*
            if(usrWrap != null && usrWrap.size()>0){
            
                for(OmniEntitlOLCPostbackWrapper.Users omniUser : usrWrap){
                    
                    if(omniUser.domain == 'COBALT'){
                        trlContact.COBALT_GUID__c =   omniUser.userGUID;
                    }
                    if(usrWrap[0].domain == 'DATAROOM'){
                        trlContact.DATAROOM_GUID__c  =   omniUser.userGUID;
                    }
                }
            }*/
            contactsMap.put(trlContact.id, trlContact);
            //Trail Contact End
            
            
        }
        
        return contactsMap;
    }
    
    /**
    * @description getCOBALTDATARoomValues
    * @param usrWrap
    * @param trlContact
    * @return trlContact
    */
    private static Trial_Contact__c getCOBALTDATARoomValues(list<OmniEntitlOLCPostbackWrapper.Users> usrWrap, Trial_Contact__c trlContact){
        
        if(usrWrap != null && usrWrap.size()>0){
            
            for(OmniEntitlOLCPostbackWrapper.Users omniUser : usrWrap){
                
                if(omniUser.domain != null && omniUser.domain == 'COBALT'){
                    trlContact.COBALT_GUID__c =   omniUser.userGUID;
                }
                if(omniUser.domain != null && omniUser.domain == 'DATAROOM'){
                    trlContact.DATAROOM_GUID__c  =   omniUser.userGUID;
                }
            }
        }
        return trlContact;
    }
    
    /**
    * @description getSubStringText
    * @param strMain
    * @return subString
    */
    public static String getSubStringText(String strMain){
        
        string subString=strMain;
        
        If(string.isNotBlank(strMain) && strMain.length() >255){
            subString = strMain.subString(0,255);
        }
        return subString;
    }
}