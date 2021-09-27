/**
* @description       : 
* @author            : TCS Dev Team
* @group             : 
* @last modified on  : 06-09-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-18-2021   TCS DEV Team                        Initial Version
**/
public with sharing class OmniTrialDuplicateCheck {
    
    /**
*  @description  :  To perform the Duplicate Check - calling from Trial Console Page
*  @param     prodCodes
*  @param     emailIds 
*  @return    needToDisplayErrors
*/
    
    @AuraEnabled
    public static List<String> duplicateCheckCallLWC(List<String> prodCodes , List<String> emailIds){
        
        List<String> needToDisplayErrors = new List<String>();
        if(!prodCodes.isEmpty() && !emailIds.isEmpty() ){
            Map<String,String>  emailProdCodeMapUIMap = emailProdCodeFromUI(prodCodes,emailIds);
            
            map<String,string> emailProdCodeFromSFDCMAP = emailProdCodeFromSFDC(emailProdCodeMapUIMap.values());
            
            Map<string,string> errorsMap = new Map<string,string>();
            
            for(String emailandProd : emailProdCodeFromSFDCMAP.keySet()){
                string errorMsg='';
                if(emailProdCodeMapUIMap.containsKey(emailandProd) && errorsMap.containsKey(emailandProd.substringBefore('-'))){
                   
                    errorMsg   = errorsMap.get(emailandProd.substringBefore('-'))+',';
                    errorMsg += emailProdCodeFromSFDCMAP.get(emailandProd);
                    //errorMsg += emailandProd.substringAfter('-');
                    errorsMap.put(emailandProd.substringBefore('-'),errorMsg);
                    //needToDisplayErrors.add('This User '+emailandProd.substringBefore('-')+' already used the Trail Version of the Product '+emailandProd.substringAfter('-'));
                }
                else if(emailProdCodeMapUIMap.containsKey(emailandProd)){
                    errorMsg += emailProdCodeFromSFDCMAP.get(emailandProd);
                    //errorMsg += emailandProd.substringAfter('-');
                    errorsMap.put(emailandProd.substringBefore('-'),errorMsg);
                }
            }
            // System.debug('needToDisplayErrors: '+needToDisplayErrors);
            
            
            for(string email : errorsMap.keyset()){
                needToDisplayErrors.add('This contact ('+email+') has already trialed ' +errorsMap.get(email));
               //  needToDisplayErrors.add('This contact has already trialed ' +errorsMap.get(email));
                break;
            }
        }
        return needToDisplayErrors;
    }
    
    
    /**
*  @description  :  To generate the Map consists of Email--Product code and Email
*  @param     prodCodes
*  @param     emailIds 
*  @return    emailProdCodeMapUIMap
*/
    public static Map<String,String> emailProdCodeFromUI(List<String> prodCodes , List<String> emailIds){
        
        Map<String,String> emailProdCodeMapUIMap = new  Map<String,String>();
        for(String email : emailIds){
            for(String materialNumb : prodCodes){
                emailProdCodeMapUIMap.put(email+'-'+materialNumb,email);
            } 
        }
        return emailProdCodeMapUIMap;
    }
    
    /**
*  @description  :  To generate the Map consists of Email--Product code and Email in Existing SFDC
*  @param    emailIds 
*  @return   emailProdCodeFromSFDCMAP
*/
    
    public static MAP<String,String> emailProdCodeFromSFDC(List<String> emailIds){
        Map<String,List<String>> trailIdEmailMap = fetchTrailUserDtls(emailIds);
        MAP<String,String> emailProdCodeFromSFDCMAP = fetchTrailProductsDtls(trailIdEmailMap);
        return emailProdCodeFromSFDCMAP;
    }
    
    
    
    /**
*  @description  :  
*  @param      emailIds
*  @return     trailIdEmailMap
*/
    public static  Map<String,List<String>> fetchTrailUserDtls(List<String> emailIds){
        Map<String,List<String>> trailIdEmailMap = new Map<String,List<String>>();
        if(Trial_Contact__c.SObjectType.getDescribe().isAccessible() && schema.sobjectType.Trial_Contact__c.fields.Email__c.isAccessible() && schema.sobjectType.Trial_Contact__c.fields.Trials__c.isAccessible() ){
            List<Trial_Contact__c> collegues = [select id,Trials__c,Email__c from Trial_Contact__c where Email__c in :emailIds and Status__c  in ('Invited','Accepted','Active','Ended')];
            for(Trial_Contact__c inv : collegues){
                //If the trailusers are mapped to same Trail
                List<String> emails = new List<String>();            
                if(trailIdEmailMap.containsKey(inv.Trials__c)){
                    emails.addAll(trailIdEmailMap.get(inv.Trials__c));
                }
                emails.add(inv.Email__c);            
                trailIdEmailMap.put(inv.Trials__c,emails);
            }
        }
        return trailIdEmailMap; 
    }
    
    
    /**
*  @description  :  
*  @param     trailIdEmailMap
*  @return    emailProdCodeFromSFDCMAP
*/
    public static MAP<String,String> fetchTrailProductsDtls( Map<String,List<String>> trailIdEmailMap){
        MAP<String,String> emailProdCodeFromSFDCMAP = new MAP<String,String>();
        if(Trial_Product__c.SObjectType.getDescribe().isAccessible()&&schema.sobjectType.Trial_Product__c.isAccessible()){
            List<Trial_Product__c> trlProducts = [select id,Material_Number__c,Trial__c,Product_Name__r.name from Trial_Product__c where Trial__c in :trailIdEmailMap.keyset()];
            for(Trial_Product__c tpr : trlProducts){
                List<String> emailIds = trailIdEmailMap.get(tpr.Trial__c);
                for(String eml : emailIds){
                    emailProdCodeFromSFDCMAP.put(eml+'-'+tpr.Material_Number__c,tpr.Product_Name__r.name);
                }
            }
        }
        return emailProdCodeFromSFDCMAP;
    }
    
    
}