/******************************************************************************************
* Class         : OmniCalltoEloquaHelper 
* @description  : OmniCalltoEloquaHelper 
* @param        : NA
* @return       : NA
* Created Date  : JUL-2021
* Author        : TCS Developer 
* ****************************************************************************************/
public without sharing  class OmniCalltoEloquaHelper {
    
    public static string encryptedURLCommon = '';
    public static string encryptedTrialContURL = '';
    
    /**
    * @description getEntTrialMappingUrl
    * @param trialRecord
    * @return entMappingURL
    */ 
   public static String getEntTrialMappingUrl(Ent_Trial__c trialRecord){
        encryptedURLCommon = '';
        String entMappingURL = '';
        String sapAccountId = '';
        String accName = '';
        if(trialRecord.External_Account_Number_Source__c == 'SAP'){
            sapAccountId= trialRecord.External_Account_Number__c;
        }
        
        accName = OmniCalltoEloquaHelperTwo.getParam(trialRecord,trialRecord.Account_Name__c, trialRecord.Account__r.Name);
        String testEnv = KeyValueListStore__c.getValues('OmniEloquaCallTestEnv').TextValue__c;
        
        entMappingURL = 'sfdcTrialId=' + trialRecord.ID + 
                        '&tSource=' +trialRecord.Trial_Source__c +
                        '&tSD=' + String.valueof(trialRecord.Trial_Start_Date__c) +
                        '&tED=' +String.valueof(trialRecord.Trial_End_Date__c) +
                        '&tCam=' +trialRecord.Campaign__c +
                        '&tLen=' +trialRecord.Number_of_Days__c +
                        '&oppId=' +trialRecord.Opportunity__c +
                        '&saAcctId=' + sapAccountId +
                        //'&pType=' +trialRecord.Profile_Type__c +
                        '&olcAcctId=' +trialRecord.External_Account_Number__c +
                        '&oEm=' +trialRecord.Owner.Email +
                        '&oPh=' +trialRecord.Owner.Phone +
                        '&oTitle=' +trialRecord.Owner.Title +
                        '&tstEnv=' + testEnv +
                        '&oFN=' +trialRecord.Owner.firstname +
                        //'&comp=' +accName +
                        '&tUsers=' +trialRecord.Total_NumberofTrial_Contacts__c +
                        '&organizationType=' +trialRecord.Account__r.ECC_Segment_Level_2__c +
                        '&oLN=' +trialRecord.Owner.lastname ;
        
        
        //added as part of Encryption
        encryptedURLCommon =  '&sfdcTrialId=' + trialRecord.ID + 
                        '&trialStartDate=' + String.valueof(trialRecord.Trial_Start_Date__c) +
                        '&trialEndDate=' +String.valueof(trialRecord.Trial_End_Date__c) +
                        '&company=' +accName +
                        '&organizationType=' +trialRecord.Account__r.ECC_Segment_Level_2__c;
        return entMappingURL;
    }
    
    /**
    * @description getRemovedSpaceNullChar
    * @param str
    * @return str
    */ 
    public static string getRemovedSpaceNullChar(String str)
    {
        if(str.contains('=null')) {
             str = str.replaceAll('=null','=');
        }

        if(str.contains(' ')) {
             str = str.replaceAll(' ','%20');
        }
        system.debug(LoggingLevel.DEBUG,'URL: '+str);
        return str;
    }
    /**
    * @description getOmniTrialsEloquaCalls
    * @param trialRecord
    * @param trialPrds
    * @return true
    */ 
    public static String getTrialProdMappingUrl(Ent_Trial__c trialRecord, List<Trial_Product__c> trialPrds){
        String trialPrdsMappingURL = '';
        
        //segment from plan to plan product
        String segment= '';
        
        //offering field for Digital
        String prodOffering = '';
        
        //List of Trial Product Ids
        List<Id> trialPrdIds = new List<Id>();
        
        //Create Map to Store Product Code and Product Name
        Map<String, String> prdCodePrdNameMap = new Map<String, String>();
        
        //Create Map to Store Product Code and Product Family
        Set<String> prdFamilySet = new Set<String>();
        
        //get Plan to Plan Product Code
        List<String> prodCodePlanToPlan = new List<String>();
        
        for(Trial_Product__c prd : trialPrds){
            
            prdCodePrdNameMap.put(prd.Material_Number__c,prd.Product_Name__r.Name);
            prdFamilySet.add(prd.Product_Name__r.Family);
            
            trialPrdIds.add(prd.Id);
            if(prd.Relationship_Type__c == 'Plan to Plan'){
                prodCodePlanToPlan.add(prd.Material_Number__c);
                segment = prd.Segment__c;
                prodOffering = prd.Product_Offerings__c;
            }
        }
        
        //Store Base Product and Related Accessory Product
        Map<String, List<String>> basePrdAccPrdMap = new Map<String, List<String>>();
        
        for(String planToPlanPrdCode: prodCodePlanToPlan){
            basePrdAccPrdMap.put(planToPlanPrdCode,new List<String>());
            basePrdAccPrdMap = getbasePrdAccPrdMap(basePrdAccPrdMap, planToPlanPrdCode, trialPrds);
            
            System.debug(LoggingLevel.DEBUG, '@@basePrdAccPrdMap : '+basePrdAccPrdMap);
        }
        
        //Create Base Product and Accessory Prduct with Commas
        trialPrdsMappingURL   = getTrialPrdMappingUrl(basePrdAccPrdMap, prdCodePrdNameMap);
        
        //String trialPrdRecordIds = String.join(trialPrdIds,',');
        
        //trialPrdsMappingURL   += '&trialProductId='+trialPrdRecordIds;
        trialPrdsMappingURL   += '&seg='+segment;
        trialPrdsMappingURL   += '&trialProduct='+prodOffering;
        
        trialPrdsMappingURL   += OmniCalltoEloquaHelperTwo.getVersionDataInString(prdFamilySet);
        
        
        //add into encrption variable
        encryptedURLCommon += '&segment='+segment;//'&trialProductId='+trialPrdRecordIds;
        
        return trialPrdsMappingURL;
    }
    
    /**
    * @description getTrialPrdMappingUrl
    * @param basePrdAccPrdMap
    * @param prdCodePrdNameMap
    * @return trialPrdMappingURL
    */ 
    public static String getTrialPrdMappingUrl(Map<String, List<String>> basePrdAccPrdMap, Map<String, String> prdCodePrdNameMap){
        
        String trialPrdMappingURL = '';
        
        //Store Key as Product Code which Relation Type is Plan to Plan and value as a Accessory Prd type with comma
        Map<String, String> basePrdAccessoryPrdMap = getBasePrdAccPrdWithComma(basePrdAccPrdMap,prdCodePrdNameMap);
        KeyValueListStore__c omniTrialPrdSizeToEloqua = KeyValueListStore__c.getValues('OmniTrialPrdSizeToEloqua');
        
        Integer planToPlanPrdSize = Integer.valueOf(omniTrialPrdSizeToEloqua.TextValue__c);
        
        Integer tempCount = 1;
        
        for(String baseProductMaterial : basePrdAccessoryPrdMap.keySet()){
        
             if(planToPlanPrdSize >= tempCount){
                 
             String accessoryMaterialNumbers = basePrdAccessoryPrdMap.get(baseProductMaterial);
             
             String accessoryProductNames = getAccessoryProductName(accessoryMaterialNumbers, prdCodePrdNameMap);
             
             System.debug(LoggingLevel.DEBUG, '@@accessoryMaterialNumbers: '+accessoryMaterialNumbers);
             System.debug(LoggingLevel.DEBUG, '@@accessoryProductNames: '+accessoryProductNames);
             
             String baseProductName = prdCodePrdNameMap.get(baseProductMaterial);
             
             String tempString = '&bP'+tempCount+'='+baseProductName +
                                 //'&bMN'+tempCount+'='+baseProductMaterial +   
                                 '&aP'+tempCount+'='+accessoryProductNames;// +                                        
                                 //'&aMN'+tempCount+ '='+accessoryMaterialNumbers;
                                 
             trialPrdMappingURL += tempString;            
             tempCount++; 
             }   
        }
        
        
        return trialPrdMappingURL;
    }
    
    /**
    * @description getAccessoryProductName
    * @param accessoryMaterialNumbers
    * @param prdCodePrdNameMap
    * @return accessoryProducts
    */ 
    @testvisible
    private static String getAccessoryProductName(String accessoryMaterialNumbers, Map<String, String> prdCodePrdNameMap){
        String accessoryProducts = '';
        List<String> accessoryMaterialNumbersList = null;
        if(accessoryMaterialNumbers != null){
            
            accessoryMaterialNumbersList = accessoryMaterialNumbers.split(';');
            accessoryMaterialNumbersList.sort();
            List<String> listAccPrdNames = new List<String>();
            for(String accPrd : accessoryMaterialNumbersList){
                
                String accPrdName = prdCodePrdNameMap.get(accPrd);
                listAccPrdNames.add(accPrdName);
            }
            
            if(!listAccPrdNames.isEmpty() && listAccPrdNames!= null){
                accessoryProducts = string.join(listAccPrdNames,';');
            }
        }
        return accessoryProducts;
    }
    /**
    * @description getBasePrdAccPrdWithComma
    * @param basePrdAccPrdMap
    * @param prdCodePrdNameMap
    * @return basePrdAccessoryPrdMap
    */ 
    @testvisible
    private static Map<String, String> getBasePrdAccPrdWithComma(Map<String, List<String>> basePrdAccPrdMap, Map<String, String> prdCodePrdNameMap){
    
        //Store Key as Product Code which Relation Type is Plan to Plan and value as a Accessory Prd type with comma
        Map<String, String> basePrdAccessoryPrdMap = new Map<String, String> ();
        
        for(String basePrdCode : basePrdAccPrdMap.Keyset()){
            
            String accPrdwithComma = null;
            
            List<String> accessoryPrds = basePrdAccPrdMap.get(basePrdCode);   
            accessoryPrds.sort();
            if(!accessoryPrds.isEMpty() && accessoryPrds != null){
                accPrdwithComma = string.join(accessoryPrds,';');
            }     
            
            basePrdAccessoryPrdMap.put(basePrdCode,accPrdwithComma);
        }
        return basePrdAccessoryPrdMap;
    }
    
    /**
    * @description getbasePrdAccPrdMap
    * @param basePrdAccPrdMap
    * @param planToPlanPrdCode
    * @param trialPrds
    * @return basePrdAccPrdMap
    */ 
    @testVisible
    private static Map<String, List<String>> getbasePrdAccPrdMap(Map<String, List<String>> basePrdAccPrdMap, String planToPlanPrdCode, List<Trial_Product__c> trialPrds){
        
        System.debug(LoggingLevel.DEBUG, '@@trialPrds: '+trialPrds);   
                
        for(Trial_Product__c prd : trialPrds){
                    
            if(prd.Relationship_Type__c == 'Accessory Product' && prd.Base_Material_Number__r.ProductCode == planToPlanPrdCode){
                
                System.debug(LoggingLevel.DEBUG, '@@prd.Material_Number__c: '+prd.Material_Number__c);   
                
                if(basePrdAccPrdMap.containsKey(planToPlanPrdCode)){
                    List<String> listAccPrd= basePrdAccPrdMap.get(planToPlanPrdCode);
                    listAccPrd.add(prd.Material_Number__c);//Base_Material_Number__r.ProductCode
                    
                    basePrdAccPrdMap.put(planToPlanPrdCode, listAccPrd);
                }
                else{
                    
                    basePrdAccPrdMap.put(planToPlanPrdCode, new List<String> { prd.Material_Number__c});
                }
            }
            System.debug(LoggingLevel.DEBUG, '@@basePrdAccPrdMap Inside: '+basePrdAccPrdMap);       
        }
        return basePrdAccPrdMap;
    }

    /**
    * @description getTrialContMappingUrl
    * @param trialRecord
    * @param cont
    * @return trialContMappingURL
    */ 
    public static String getTrialContMappingUrl(Ent_Trial__c trialRecord, Trial_contact__c cont){
        String trialContMappingURL = '';
        encryptedTrialContURL = '';
        String addUser = 'True';
        String sapContactId = '';
        String olcContactId = '';
        String primary = 'False';
        if(cont.Request_Type__c == 'TRIAL'){
            addUser = 'False';
            
        }
        
        if(cont.Primary__c){
            primary= 'True';
        }
        
        if(cont.External_Contact_Number_Source__c == 'SAP'){
            sapContactId= cont.External_Contact_Number__c;
        }
        else if(cont.External_Contact_Number_Source__c == 'OLC'){
            olcContactId= cont.External_Contact_Number__c;      
        }
        
        String country = OmniCalltoEloquaHelperTwo.getParam(trialRecord,cont.Country__c, trialRecord.Account__r.BillingCountry);

        String state = OmniCalltoEloquaHelperTwo.getParam(trialRecord,cont.State__c, trialRecord.Account__r.BillingState);

        trialContMappingURL = '&emailAddress='+cont.Email__c+
                            '&odtUniqueId='+cont.Unique_Name__c+
                            '&fName='+cont.First_Name__c+
                            '&lName='+cont.Last_Name__c+
                            '&country='+country+
                            '&state='+state+
                            '&tStatus='+cont.Status__c+
                            '&pReq='+primary+
                            '&oPU='+cont.One_Pass_User_Name__c+
                            '&oPId='+cont.One_Pass_ID__c+
                            '&saConId='+sapContactId+
                            '&olcConId='+olcContactId+
                            '&aUser='+addUser+
                            '&pFN='+cont.Invite_User_First_Name__c+
                            '&pLN='+cont.Invite_User_Last_Name__c+
                            '&busPhone='+cont.Contact_Phone__c+
                            '&pType='+cont.Profile_Type__c+
                            '&tConId='+cont.Id ;
                            
        //add encrpty url
        encryptedTrialContURL = '&busPhone='+cont.Contact_Phone__c+ 
                                '&emailAddress='+cont.Email__c+
                                '&firstName='+cont.First_Name__c+
                                '&lastName='+cont.Last_Name__c+
                                '&country='+country+
                                '&state='+state+
                                '&trialContactId='+cont.Id ;
                        
        return trialContMappingURL;
    }
    
}