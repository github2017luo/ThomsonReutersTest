/* Class: ODTDG_Helper
* @description: This is the class to write generic code for ODTDG
* Created: 04/16/2021
* Author: Mallikarjuna Rao
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-04-16   Mallikarjuna   DCP-     
* =============================================================================
* @description ODTDG_Helper : class for error handlings for all services, data will be fetch from SFDC custom meta data
*/
/********************************************************************************************************
*  
*  @description ODTDG_Helper : Helper class for ODTDG, this is just a common methods 
*********************************************************************************************************/
public with sharing class ODTDG_Helper {
    
    private static string cusSegment;
    private static LIST<string> cusProductOfferings;



    /********************************************************************************************************
    *  @description getStaticValues: Method to get static values from custom settings 
    *  @param name : this will accept the name of custom settings name  
    *  @return string : value of that custom setting name
    *********************************************************************************************************/ 
        public static string getStaticValues(string name){
    
            if(Static_Values__c.getAll().containsKey(name)){ 
                return Static_Values__c.getValues(name).value__c ;
             } 
    
             return null;
    
        }
    
         
       
    /********************************************************************************************************
    *  @description getProductCode: Method to get productCode based on requested param 
    *  @param productOffering : this will accept list of productOffering 
    *  @param customerSegment : this will accept customerSegment   
    *  @return List<string> : list of product codes
    *********************************************************************************************************/ 
    
        public static List<string> getProductCode(List<String> productOffering,string customerSegment){
            return getProductCodesFromRelationship(productOffering, customerSegment, null);
        }
    
    /********************************************************************************************************
    *  @description getProductCode: Method to get productCode based on requested param 
    *  @param productOffering : this will accept list of productOffering 
    *  @param customerSegment : this will accept customerSegment   
    *  @param state : this will expect the state of customer selection 
    *  @return List<string> : list of product codes
    *********************************************************************************************************/ 
    public static List<string> getProductCodesByState(List<String> productOffering,string customerSegment, string state){
        return getProductCodesFromRelationship(productOffering, customerSegment,state);
    }
   
    /********************************************************************************************************
    *  @description getProductCodesFromRelationship: Method to get productCode based on requested param 
    *  @param productOffering : this will accept list of productOffering 
    *  @param customerSegment : this will accept customerSegment   
    *  @param state : this will expect the state of customer selection 
    *  @return List<string> : list of product codes
    *********************************************************************************************************/ 
    
    public static List<string> getProductCodesFromRelationship(List<String> productOffering,string customerSegment, string state){
            
        system.debug(LoggingLevel.INFO,'ProductOffering............'+productOffering);
        system.debug(LoggingLevel.INFO,'customerSegment............'+customerSegment);
        system.debug(LoggingLevel.INFO,'state............'+state);
        

        cusSegment = customerSegment;
        cusProductOfferings =new list<string>();
        cusProductOfferings.addAll(productOffering);


        set<string> productCodes = new set<string>();
       // set<string> primaryFromCodes = new set<string>();
        List<string> productJuridisctionsList = new List<string>();

        string relationshipLinkType=getStaticValues('ODTDG_RelationshipLinkType');
        string freeTrial=getStaticValues('ODTDG_FreeTrial');
        string relationshipTypeMain=getStaticValues('ODTDG_RelationshipTypeMain');
        string relationshipTypeExtended=getStaticValues('ODTDG_RelationshipTypeExtended');
        string productJuridisctions = getStaticValues('ODTDG_ProductJuridisctions');

        if(productJuridisctions != null){
            productJuridisctionsList = productJuridisctions.split(';');
        }

        system.debug(LoggingLevel.INFO,'We are not using Best link type on Relationshi fields '+relationshipLinkType);

        if(Schema.sObjectType.product_relationship__c.isQueryable()){

 
            LIST<product_relationship__c> parentProducts = [select id,product_to__r.free_trial__c, Segment__c, relationship_link_type__c,
                                                                    Product_To__r.Product_Offering__c,product_to__r.productcode,  
                                                                    product_from__r.productcode, product_to__r.ProductMarketingRecordID__c
                                                                FROM product_relationship__c 
                                                                WHERE /*relationship_link_type__c =: relationshipLinkType
                                                                AND */ product_to__r.free_trial__c LIKE :('%'+freeTrial+'%')
                                                                AND relationship_type__c =: relationshipTypeMain
                                                                AND Product_To__r.Product_Offering__c IN: productOffering
                                                                AND Segment__c =: customerSegment  ];
          
            system.debug(LoggingLevel.INFO,'parentProducts....'+parentProducts);

            productCodes.addAll(filterbaseProducts(parentProducts));
            
            List<product_relationship__c> relatedStates =  new List<product_relationship__c>();
            if(state != null){
                relatedStates = [select id,product_to__r.free_trial__c,product_to__r.productcode, product_from__r.productcode, Product_To__r.Product_Offering__c, Segment__c, 
                                        product_to__r.Name, product_to__r.Apttus_Filter_Jurisdiction__c                 
                                            FROM product_relationship__c 
                                                WHERE product_to__r.free_trial__c LIKE :('%'+freeTrial+'%')
                                                AND  relationship_type__c =: relationshipTypeExtended
                                                AND Segment__c =: customerSegment
                                                AND product_FROM__r.productcode IN: productCodes 
                                                /* AND relationship_link_type__c =: relationshipLinkType  */ 
                                                AND ( product_to__r.Apttus_Filter_Jurisdiction__c =: state OR product_to__r.Apttus_Filter_Jurisdiction__c IN: productJuridisctionsList  )];
            }else{
                relatedStates = [select id,product_to__r.free_trial__c,product_to__r.productcode, product_from__r.productcode, Product_To__r.Product_Offering__c, Segment__c, 
                                        product_to__r.Name, product_to__r.Apttus_Filter_Jurisdiction__c                 
                                            FROM product_relationship__c 
                                                WHERE product_to__r.free_trial__c LIKE :('%'+freeTrial+'%')
                                                AND  relationship_type__c =: relationshipTypeExtended
                                                AND Segment__c =: customerSegment
                                                AND product_FROM__r.productcode IN: productCodes 
                                                /* AND relationship_link_type__c =: relationshipLinkType  */ 
                                                AND product_to__r.Apttus_Filter_Jurisdiction__c IN: productJuridisctionsList ];
            }

            for(product_relationship__c p: relatedStates){
                productCodes.add(p.product_to__r.productcode);
            }
        }    
         
        system.debug(LoggingLevel.INFO,'ProductCodes............'+productCodes);
         list<string> productCodesList = new List<string>();
         productCodesList.addAll(productCodes);
        return productCodesList;

    }
    //End........................


    
    /********************************************************************************************************
    *  @description getProductCode: Method to get productCode based on requested param 
    *  @param onePassId : this will accept list of productOffering 
    *  @return Trial_Contact__c : list of product codes
    *********************************************************************************************************/ 
    
        public static Trial_Contact__c getTrialContact(string onePassId){
    
            Trial_Contact__c result=new Trial_Contact__c();
            if(Schema.sObjectType.Trial_Contact__c.isQueryable()){
                
                for(Trial_Contact__c c: [SELECT Id, Trials__c, First_Name__c, Last_Name__c, Email__c, One_Pass_ID__c, Primary__c, lead__c, Status__c 
                                                FROM Trial_Contact__c 
                                                WHERE One_Pass_ID__c=: onePassId order by LastModifiedDate Desc Limit 1]){
                    result=c;
                }
            }
            return result;
        }
        
    /********************************************************************************************************
    *  @description getPrimaryContactOnepass: Method to get userAuthId based on requested param 
    *  @param trCon : List of trialcontacts
    *  @return string :  primary user onepass 
    *********************************************************************************************************/ 
    
        public static string getPrimaryContactOnepass(List<ODTDG_TrialRecord_ContactHelper.TrialContacts> trCon){
             
            for(ODTDG_TrialRecord_ContactHelper.TrialContacts tc: trCon){
                if(tc.primaryUser){
                    return tc.userAuthId;
                }
            }
             
            return null ;
        }



        private static set<string> checkToProductsCodesSize(LIST<product_relationship__c> parentProducts){
            set<string> productCodes = new set<string>();

            for(product_relationship__c pr: parentProducts){
                productCodes.add(pr.product_to__r.productcode);
            }

            return productCodes;
        }

        private static LIST<string> filterbaseProducts(LIST<product_relationship__c> parentProducts){

            LIST<string> productCodes = new LIST<string>();
            set<string>  productsCodeSet = new Set<string>();
            productsCodeSet = checkToProductsCodesSize(parentProducts);

            if(!productsCodeSet.isEmpty()){
                if(productsCodeSet.size() > 1){
                    productCodes = getPrimaryProductsFromlist(parentProducts);
                }else{
                    productCodes.addAll(productsCodeSet);
                }
            }
            return productCodes;
        }
        @testVisible
        private static LIST<string> getPrimaryProductsFromlist(LIST<product_relationship__c> prMoreThanOne){
            LIST<string> finallist = new LIST<String>();
            set<string>  productsCodeSet = new Set<string>();
            LIST<product_relationship__c> basedOnLinkType = new LIST<product_relationship__c>(); 
            basedOnLinkType = getValidParentProduct(prMoreThanOne);
            productsCodeSet = checkToProductsCodesSize(basedOnLinkType);

            if(!productsCodeSet.isEmpty()){
                if(productsCodeSet.size() == 1){
                    finallist.addAll(productsCodeSet);
                }else{
                     system.debug(LoggingLevel.INFO,'calling from 230.'+getPLProductsList(prMoreThanOne));
                    finallist.addAll(getPLProductsList(prMoreThanOne));
                }
            }
            return finallist;
        }


        private static List<product_relationship__c> getValidParentProduct(LIST<product_relationship__c> parentProducts){
            List<product_relationship__c> bestPdt = new List<product_relationship__c>();
            List<product_relationship__c> betterPdt = new List<product_relationship__c>();
            List<product_relationship__c> goodPdt = new List<product_relationship__c>();
            String odtdgbest=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_best','best'); //isnull(getStaticValues('ODTDG_best'))?'best':getStaticValues('ODTDG_best');
            String odtdgbetter=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_better','better'); //isnull(getStaticValues('ODTDG_better'))?'better':getStaticValues('ODTDG_better');
            String odtdggood=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_good','good'); //isnull(getStaticValues('ODTDG_good'))?'good':getStaticValues('ODTDG_good');

            for(product_relationship__c pr : parentProducts){
                if(pr.relationship_link_type__c.equalsIgnoreCase(odtdgbest)){
                   bestPdt.add(pr);
                }else if(pr.relationship_link_type__c.equalsIgnoreCase(odtdgbetter)){
                   betterPdt.add(pr);
                }else if(pr.relationship_link_type__c.equalsIgnoreCase(odtdggood)){
                   goodPdt.add(pr);
                }
            }
            if(!bestPdt.isEmpty()){
                return bestPdt;
            }else if(!betterPdt.isEmpty()){
                return betterPdt;
            }else if(!goodPdt.isEmpty()){
                return goodPdt;
            }

            return parentProducts;
        }
        
        

        private static LIST<string> getPLProductsList(LIST<product_relationship__c> basedOnLinkType){
            
            LIST<string> finallist = new LIST<String>();
            SET<string> finallistSet = new SET<String>();
            String odtdgPractLawConnect=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_PractLawConnect','58180'); //isnull(getStaticValues('ODTDG_PractLawConnect'))?'58172':getStaticValues('ODTDG_PractLawConnect');
            String odtdgPractLaw=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_PractLaw','58172'); //isnull(getStaticValues('ODTDG_PractLaw'))?'58133':getStaticValues('ODTDG_PractLaw');
            String odtdgPractLawConnectName=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_PractLawConnetName','Practical Law Connect');
            String odtdgPractLawName=ODTDG_EntitleTrialCustomerServiceHelper.getMarketingRecordID('ODTDG_PractLawName','Practical Law');

            for(product_relationship__c p: basedOnLinkType){
                if(p.product_to__r.ProductMarketingRecordID__c == Integer.valueOf(odtdgPractLawConnect) && p.Product_To__r.Product_Offering__c == odtdgPractLawConnectName){
                    finallistSet.add(p.product_to__r.productcode);
                }else if(p.product_to__r.ProductMarketingRecordID__c == Integer.valueOf(odtdgPractLaw) && p.Product_To__r.Product_Offering__c == odtdgPractLawName){
                    finallistSet.add(p.product_to__r.productcode);
                } 
            } 
             system.debug(LoggingLevel.INFO,'finallistSet.......'+finallistSet);

            if(!finallistSet.isEmpty()){
                finallist.addAll(finallistSet);
            }else{
                finallist.addAll( checkToProductsCodesSize(basedOnLinkType));
            }


            
            return finallist;
        }

        

 }