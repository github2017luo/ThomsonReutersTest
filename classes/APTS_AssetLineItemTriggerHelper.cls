public with sharing  class APTS_AssetLineItemTriggerHelper {

    //AssetAutoNumber Code for Informatica process By Poorva
    public static void updateAutoNumber(List<Apttus_Config2__AssetLineItem__c > newObjectList){
        try{
            for(Apttus_Config2__AssetLineItem__c assetlLine : newObjectList){
                if(assetlLine.APTS_Proposal_Business_Unit__c == 'Tax Professional' && 
                        (assetlLine.Asset_Auto_Number__c==null || assetlLine.Asset_Auto_Number__c=='')){
                    assetlLine.Asset_Auto_Number__c = assetlLine.Tax_Asset_Auto_Number__c;  
                }                    
            } 
            system.debug('newObjectList : '+newObjectList);
        }catch(Exception e){
            
        }
        
     /*   try{
            Latam_AssetItemAutoNumber__c objAssetSetting = Latam_AssetItemAutoNumber__c.getOrgDefaults();
            List<Id> assetIdList = new List<Id>();  
            if(objAssetSetting != null && objAssetSetting.Auto_Format__c != null && !('').equals(objAssetSetting.Auto_Format__c)){
                String autoNumber = objAssetSetting.Auto_Format__c + '%';
                Decimal latestNumber = objAssetSetting.Latam_Latest_Number__c;
                
                if(latestNumber ==  null){
                    objAssetSetting.Latam_Latest_Number__c = objAssetSetting.Starting_Number__c != null ? objAssetSetting.Starting_Number__c : 0;   
                }
                
                for(Apttus_Config2__AssetLineItem__c assetlLine : newObjectList){
                    if(assetlLine.Apttus_QPConfig__ProposalId__c == null &&                      
                       assetlLine.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                           objAssetSetting.Latam_Latest_Number__c ++;
                           assetlLine.Asset_Auto_Number__c = objAssetSetting.Auto_Format__c + objAssetSetting.separator__c + String.valueOf(Integer.valueOf(objAssetSetting.Latam_Latest_Number__c)).leftPad(4, '0');                          
                       }                    
                }  
                if(latestNumber != objAssetSetting.Latam_Latest_Number__c){
                    update objAssetSetting;
                }   
            }
        }catch(Exception e){
            
        }   */     
    }
    
    /*Code added by Khushboo Vaidya for DOC-3335: Quote Creation Error Log starts*/
    public static void updateRenewalQuoteCreatedFlag(List<Apttus_Config2__AssetLineItem__c> listOfAssetLis,Map<ID, Apttus_Config2__AssetLineItem__c> mapOfOldAssetLis)
    {
        for(Apttus_Config2__AssetLineItem__c oAli: listOfAssetLis)
        {
            /*System.debug('Kh***URQCF APTS_Proposal_Business_Unit__c===> ' + oAli.APTS_Proposal_Business_Unit__c);
            System.debug('Kh***URQCF Apttus_Config2__AssetStatus__c ===> ' + oAli.Apttus_Config2__AssetStatus__c );
            System.debug('Kh***URQCF APTS_Line_Status__c ===> ' + oAli.APTS_Line_Status__c );
            System.debug('Kh***URQCF ===> mapOfOldAssetLis ' + mapOfOldAssetLis );
            System.debug('Kh***URQCF ===> Renewal_quote_created__c BEFORE' + oAli.Renewal_quote_created__c );*/
            
            if(oAli.APTS_Proposal_Business_Unit__c != null 
               && oAli.APTS_Proposal_Business_Unit__c.equalsIgnoreCase('Tax Professional')
               && oAli.Apttus_Config2__AssetStatus__c !=null && mapOfOldAssetLis != null 
               && !mapOfOldAssetLis.isEmpty() && mapOfOldAssetLis.containsKey(oAli.id)
               && mapOfOldAssetLis.get(oAli.Id).Apttus_Config2__AssetStatus__c.equalsIgnoreCase('Pending Renewal') 
               && oAli.Apttus_Config2__AssetStatus__c.equalsIgnoreCase('Activated')
               && oAli.Renewal_quote_created__c == TRUE)
               {
                   oAli.Renewal_quote_created__c = FALSE;
                   //System.debug('Kh***Renewal_quote_created__c AFTER UPDATION===>'+oAli.Renewal_quote_created__c);
               }
        }
    }
    /*Code added by Khushboo Vaidya for DOC-3335: Quote Creation Error Log ends*/
    
    //Start: Added by Kruti Shah(DOC-9128)
    public static void populateRenewalDate(List<Apttus_Config2__AssetLineItem__c> newObjectList,Map<ID, Apttus_Config2__AssetLineItem__c> mapOfOldAssetLis){
        try{            
            for(Apttus_Config2__AssetLineItem__c newAli: newObjectList){              
                Apttus_Config2__AssetLineItem__c oldALIRec = mapOfOldAssetLis.get(newAli.Id);
                system.debug('KS-->newAli.Apttus_Config2__RenewalDate__c '+newAli.Apttus_Config2__RenewalDate__c);
                system.debug('KS-->newAli.APTS_MYR_End_Date__c '+newAli.APTS_MYR_End_Date__c);
                if(newAli.APTS_Proposal_Business_Unit__c == 'Tax Professional' && newAli.APTS_MYR_End_Date__c != null
                   && newAli.APTS_MYR_End_Date__c != oldALIRec.APTS_MYR_End_Date__c && newALI.Apttus_Config2__AssetStatus__c != 'Cancelled'){
                    //newAli.Apttus_Config2__RenewalDate__c = newAli.APTS_MYR_End_Date__c.AddDays(1); 
                    newAli.APTS_Info_RenewalDate__c = newAli.APTS_MYR_End_Date__c.AddDays(1); 
                }
            }  
        }catch(Exception ex){
            system.debug('Error Message: '+ex.getMessage());
            /*system.debug('Error Line Number'+ex.getLineNumber());
            system.debug('Error stack'+ex.getStackTraceString());*/
        }
    }
    //End: Added by Kruti Shah(DOC-9128)
}