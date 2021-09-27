public with sharing class APTS_ProposalLineItemTriggerHelper {   
    //This method updates the contact validation flag in the proposal record.
    public static void updateValidationFlag(List<Apttus_Proposal__Proposal_Line_Item__c> listNewObjects){
        Set<Id> proposalIds = new Set<Id>();
        Boolean contactValidation;
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        
        //Merged code as part of SOC-6701 Start--Gokila
        List<Apttus_Proposal__Proposal__c> proposalCountList = new List<Apttus_Proposal__Proposal__c>();
        List<id> lineitemlist=new List<id>();
        //Set<Apttus_Proposal__Proposal__c> proposalSet = new Set<Apttus_Proposal__Proposal__c>();
        Map<id,Apttus_Proposal__Proposal__c> proposalprintShipMap= new Map<id,Apttus_Proposal__Proposal__c>();
        Map<id,boolean> countOfOnlineMap = new Map<id,boolean>();
        Map<id,boolean> proposalMap= new Map<id,boolean>();
        Map<id,boolean> proposalNotFoundMap= new Map<id,boolean>();
        List<String> listproductcode=new list<String>();
        List<String> listAttVal=new list<String>();
        //Merged code as part of SOC-6701 Ends--Gokila
          Map<Id, Boolean> contactValidationMap = new Map<Id, Boolean>();
        //Merged code as part of SOC-6701 Start--Gokila
        
        //SOC-4795 Sreenu changes start
        Id propId = null;
        string pickValues = '';
        Map<Id, string> firmsiteMap = new Map<Id, string>();
        //SOC-4795 Sreenu changes end
        //Merged code as part of SOC-6701 Ends--Gokila
        // Sreenu - MLA Changes Start
        Map<Id, APTS_Quote_Agreement_Locations__c> locationsMap = new Map<Id, APTS_Quote_Agreement_Locations__c>(); 
        Map<String, String> perSeatLLCodeMap = new Map<String, String>();
        Map<Id, List<Apttus_Proposal__Proposal_Line_Item__c>> lineitemMap = new Map<Id, List<Apttus_Proposal__Proposal_Line_Item__c>>(); 
        
        for(string str :System.Label.OCPerSeatLowerLevelCodes.split(',')) {
            perSeatLLCodeMap.put(str, str);           
        } 
        // Sreenu - MLA Changes End
        
        for(Apttus_Proposal__Proposal_Line_Item__c item : listNewObjects){
            proposalIds.add(item.Apttus_Proposal__Proposal__c);
            
        }
       

        for (Id i : proposalIds) {
            contactValidationMap.put(i, true);
        }
        
        //start of MLA stuff - SOC-3375
        List<APTS_Quote_Agreement_Locations__c> quoteAgreementLocsList = new List<APTS_Quote_Agreement_Locations__c>();
        if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isAccessible() && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isQueryable()){
        quoteAgreementLocsList = [SELECT APTS_Quote_Proposal__c, APTS_Status__c
                                                                            FROM APTS_Quote_Agreement_Locations__c
                                                                           WHERE APTS_Quote_Proposal__c IN :proposalIds
                                                                             AND APTS_Quote_Proposal__r.APTS_Proposal_Business_Unit__c != 'Tax Professional'
                                                                             AND APTS_Online_Contacts_Validation__c=false 
                                                                             AND (APTS_Status__c ='New' OR APTS_Status__c ='Existing')
                                                                           ORDER BY APTS_Quote_Proposal__c];//SOC-3494 by Bijeta on 22/3/17
        }
        for (APTS_Quote_Agreement_Locations__c agreementLocListItem : quoteAgreementLocsList){
            /*if(agreementLocListItem.APTS_Status__c == 'New')
                contactValidationMap.put(agreementLocListItem.APTS_Quote_Proposal__c, false); */
            locationsMap.put(agreementLocListItem.APTS_Quote_Proposal__c, agreementLocListItem); // Sreenu - MLA changes  
        }
        system.debug('locationsMap...'+locationsMap);                                                                            
        //end of MLA stuff        
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
            proposalLineItemList = [SELECT Id,  Apttus_QPConfig__AttributeValueId__r.APTS_Product_Delivery__c,APTS_Master_Contacts_Validation__c, APTS_Online_Contacts_Validation__c, IP_Address_Check__c,Product_level_5__c,
                                                                            
          //Merged code as part of SOC-6701 Start--Gokila
                                                                            Apttus_QPConfig__LineStatus__c, APTS_Media_High_Level__c, APTS_Media_High_Level_Code__c,APTS_Product_Family__c,Apttus_QPConfig__PriceType__c,
          //Merged code as part of SOC-6701 Ends--Gokila
                                                                            APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Proposal__c, Apttus_QPConfig__LineType__c, 
           //Merged code as part of SOC-6701 Start--Gokila
                                                                            Apttus_QPConfig__ChargeType__c,Apttus_Proposal__Proposal__r.APTS_Boolean_Count_of_Online__c,
           //Merged code as part of SOC-6701 Ends--Gokila

                                                                            APTS_Cat_L5__c, Net_Qty_Difference__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Subscription_Number__c,
                                                                            Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.family,
            //Merged code as part of SOC-6701 Start--Gokila
                                                                            Apttus_Proposal__Proposal__r.APTS_Boolean_Count_of_Print_Ship_ONLY__c,Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c
                                                                            ,Apttus_Proposal__Product__r.Product_Level_4__c,Apttus_Proposal__Product__r.APTS_Cat_L5__c,APTS_Proposal_Business_Unit__c, 
            //Merged code as part of SOC-6701 Ends--Gokila
                                                                             Apttus_product_variant__c, Apttus_product_variant__r.APTS_Product_Delivery_Pick__c ,
                                                                             APTS_Cat_L2__c, Contract_Subscription_Type_Text__c, APTS_Contract_Sub_Type_French_Display__c   // Added By Poonam Garg for DOC 12648 
                                                                             FROM Apttus_Proposal__Proposal_Line_Item__c
                                                                             WHERE Apttus_Proposal__Proposal__c IN :proposalIds
                                                                             ORDER BY Apttus_Proposal__Proposal__c ];
            //Merged code as part of SOC-6701 Start--Gokila
                                                                             system.debug('proposalLineItemList size here=======>'+proposalLineItemList.size());  
             //Merged code as part of SOC-6701 Ends--Gokila        
        }                                                                     
                                                                                                                                       
        for (Apttus_Proposal__Proposal_Line_Item__c pLineItem : proposalLineItemList){
            contactValidation = true;
            system.debug('###### pLineItem.Contract_Subscription_Type_Text__c '+pLineItem.Contract_Subscription_Type_Text__c);
            system.debug('###### pLineItem.Contract_Subscription_Type_Text__c '+pLineItem.APTS_Contract_Sub_Type_French_Display__c );
            system.debug('$$PS let us see whats here - '+ pLineItem.APTS_Online_Contacts_Validation__c+ ' : ' + pLineItem.Apttus_product_variant__c);
            
           if(pLineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional' && (pLineItem.APTS_Online_Contacts_Validation__c == false && pLineItem.Apttus_QPConfig__LineType__c == 'Product/Service')
            && (pLineItem.Apttus_product_variant__c == null || (pLineItem.Apttus_product_variant__c != null && pLineItem.Apttus_product_variant__r.APTS_Product_Delivery_Pick__c != 'Print'))
             && pLineItem.Apttus_QPConfig__LineStatus__c != 'Renewed'  && pLineItem.Apttus_QPConfig__LineStatus__c != 'Cancelled' && !pLineItem.IP_Address_Check__c){
             
                   system.debug('$$PS Inside contact validation');
                    contactValidation = false;
            }
            /*if(pLineItem.APTS_Proposal_Business_Unit__c == 'Tax Professional' && pLineItem.APTS_Online_Contacts_Validation__c == false            
             && pLineItem.Apttus_QPConfig__LineStatus__c != 'Renewed'  && pLineItem.Apttus_QPConfig__LineStatus__c != 'Cancelled'){
                    //contactValidationMap.put(pLineItem.Apttus_Proposal__Proposal__c,false);
                    system.debug('$$PS Inside contact validation');
                    contactValidation = false;
            }*/
            
            
            if(pLineItem.APTS_Proposal_Business_Unit__c != 'Tax Professional'){
            if ((pLineItem.Apttus_QPConfig__LineStatus__c!=null && (pLineItem.Apttus_QPConfig__LineStatus__c!='Cancelled') 
                && (pLineItem.Apttus_QPConfig__LineStatus__c!='Renewed') && (pLineItem.Apttus_QPConfig__LineStatus__c!='Amended'))
                && (pLineItem.Apttus_QPConfig__LineType__c != null && pLineItem.Apttus_QPConfig__LineType__c!='Option')){
                if ((pLineItem.APTS_Media_High_Level_Code__c != null && pLineItem.APTS_Media_Lower_Level_Code__c != null) &&
                    ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='65')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='2R')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='2S')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='AA')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='AZ')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='JA')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='JB')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='L4')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='LA')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='LS')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='LT')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='MC')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='MG')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='PE')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='PF')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='PH')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='Q6')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='AV')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='LY')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='CK')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='CO')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='06') && (pLineItem.APTS_Media_Lower_Level_Code__c=='L9')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='ST')) ||
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='E2')) || //SOC-6271
                     ((pLineItem.APTS_Media_High_Level_Code__c=='13') && (pLineItem.APTS_Media_Lower_Level_Code__c=='SS')) ||                           
                     (pLineItem.Apttus_Proposal__Product__r.APTS_Cat_L5__c=='L5_L1445_FP') || (pLineItem.APTS_Cat_L2__c!= null 
                            && pLineItem.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_HighQ_Product_Family))
                            || (pLineItem.Apttus_Proposal__Product__r.Family != null &&
                                (pLineItem.Apttus_Proposal__Product__r.Family.equalsIgnoreCase(System.Label.Caseline_Product_Family) || pLineItem.Apttus_Proposal__Product__r.Family.equalsIgnoreCase(System.Label.Pondera_Product_Family)))) {   //DOC-15902
                      contactValidation = true;
                } else {
                    if ((pLineItem.APTS_Media_High_Level__c =='Online') && (pLineItem.APTS_Online_Contacts_Validation__c!=true))
                    {
                        System.debug('Contact Validation False 1');
                        contactValidation = false;
                    }                       
                    
                    if (((pLineItem.APTS_Media_High_Level__c =='Online') || (pLineItem.APTS_Media_High_Level__c =='Software')) 
                        && (pLineItem.APTS_Master_Contacts_Validation__c!=true)
                        && pLineItem.Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family
                        ) 
                        {
                            System.debug('Contact Validation False 2');
                            contactValidation = false;
                        }                        

                    if (((pLineItem.APTS_Media_Lower_Level_Code__c=='2P') || (pLineItem.APTS_Media_Lower_Level_Code__c=='AB') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='AO') || (pLineItem.APTS_Media_Lower_Level_Code__c=='CM') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='CR') || (pLineItem.APTS_Media_Lower_Level_Code__c=='IA') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='IE') || (pLineItem.APTS_Media_Lower_Level_Code__c=='LO') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='LR') || (pLineItem.APTS_Media_Lower_Level_Code__c=='OA') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='PS') || (pLineItem.APTS_Media_Lower_Level_Code__c=='SB') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='SN') || (pLineItem.APTS_Media_Lower_Level_Code__c=='51') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='AR') || (pLineItem.APTS_Media_Lower_Level_Code__c=='ST') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='E2') || 
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='65') || (pLineItem.APTS_Media_Lower_Level_Code__c=='2R') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='2S') || (pLineItem.APTS_Media_Lower_Level_Code__c=='AA') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='AV') || (pLineItem.APTS_Media_Lower_Level_Code__c=='AZ') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='CK') || (pLineItem.APTS_Media_Lower_Level_Code__c=='CO') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='JA') || (pLineItem.APTS_Media_Lower_Level_Code__c=='JB') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='L4') || (pLineItem.APTS_Media_Lower_Level_Code__c=='LA') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='LS') || (pLineItem.APTS_Media_Lower_Level_Code__c=='LT') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='LY') || (pLineItem.APTS_Media_Lower_Level_Code__c=='MC') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='MG') || (pLineItem.APTS_Media_Lower_Level_Code__c=='PE') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='PF') || (pLineItem.APTS_Media_Lower_Level_Code__c=='PH') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='CB') || (pLineItem.APTS_Media_Lower_Level_Code__c=='CC') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='CD') || (pLineItem.APTS_Media_Lower_Level_Code__c=='CE') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='CH') || (pLineItem.APTS_Media_Lower_Level_Code__c=='CP') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='CQ') || (pLineItem.APTS_Media_Lower_Level_Code__c=='CS') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='ED') || (pLineItem.APTS_Media_Lower_Level_Code__c=='EM') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='EN') || (pLineItem.APTS_Media_Lower_Level_Code__c=='FD') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='LM') || (pLineItem.APTS_Media_Lower_Level_Code__c=='PU') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='UE') || (pLineItem.APTS_Media_Lower_Level_Code__c=='WE') ||
                         (pLineItem.APTS_Media_Lower_Level_Code__c=='WO'))
                        && (pLineItem.APTS_Online_Contacts_Validation__c!=true) 
                        && (pLineItem.APTS_Master_Contacts_Validation__c!=true)
                        && (pLineItem.Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family))   //Ref: SOC-3269 added by CG 3/14/17
                    {
                        System.debug('Contact Validation False 3');
                        contactValidation = false;
                    }                    
                
                    if ((pLineItem.APTS_Media_High_Level_Code__c == '06') && (pLineItem.APTS_Media_Lower_Level_Code__c == 'I9') && 
                        (pLineItem.APTS_Online_Contacts_Validation__c!=true))  //Ref: SOC-3269 added by CG 3/14/17
                    {
                        System.debug('Contact Validation False 4');
                        contactValidation = false;
                    }                        
                    
                    if (((pLineItem.APTS_Media_High_Level_Code__c == '21') || 
                        ((pLineItem.APTS_Media_High_Level_Code__c == '13') && (pLineItem.APTS_Media_Lower_Level_Code__c == 'I9'))) && 
                         (pLineItem.APTS_Online_Contacts_Validation__c!=true))    //Ref: SOC-3269 added by CG 3/14/17
                    {
                        System.debug('Contact Validation False 5');
                        contactValidation = false;
                    }
                        
                    if((pLineItem.APTS_Master_Contacts_Validation__c!=true) 
                       && ((pLineItem.APTS_Media_High_Level_Code__c == '21') || pLineItem.APTS_Media_High_Level_Code__c == '13' 
                            || (pLineItem.APTS_Media_High_Level_Code__c == '06'))
                       && (pLineItem.Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family)){
                        System.debug('Contact Validation False 6');
                        contactValidation = false;
                    }  
                    if((pLineItem.APTS_Master_Contacts_Validation__c!=true ||pLineItem.APTS_Online_Contacts_Validation__c!=true) 
                       && ((pLineItem.APTS_Media_High_Level_Code__c == '13' || pLineItem.APTS_Media_High_Level_Code__c == '05') && 
                            ((pLineItem.APTS_Media_Lower_Level_Code__c=='NX') || 
                                (pLineItem.APTS_Media_Lower_Level_Code__c=='NT') || 
                                (pLineItem.APTS_Media_Lower_Level_Code__c=='NZ') ||
                                (pLineItem.APTS_Media_Lower_Level_Code__c=='NW')))){
                        System.debug('Contact Validation False Risk');
                        contactValidation = false;
                    }  

                    //New Block
                    if((pLineItem.APTS_Master_Contacts_Validation__c!=true) 
                       && ((pLineItem.APTS_Media_High_Level_Code__c == '05') && ((pLineItem.APTS_Media_Lower_Level_Code__c=='E9') || (pLineItem.APTS_Media_Lower_Level_Code__c==null))))
                       {
                        System.debug('Contact Validation False New');
                        contactValidation = false;
                    }                        
                    
                    //Start: Added by Kruti Shah for DOC-1656
                    IF((pLineItem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' 
                        || pLineItem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK')
                        && pLineItem.Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family 
                        && pLineItem.APTS_Online_Contacts_Validation__c!=true){
                        contactValidation = false;
                    }
                    //End: Added by Kruti Shah for DOC-1656
                   
                    //Ref: SOC-3367 added by CG 3/14/17
                    //SKG commented out to get deploy to run
                    if(((!string.isEmpty(pLineItem.Apttus_Proposal__Product__r.Name) && pLineItem.Apttus_Proposal__Product__r.Name.Contains('Patron Access')) || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41727130' || 
                    pLineItem.Apttus_Proposal__Product__r.Subscription_Number__c == '41727130'|| pLineItem.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '076') 
                    && pLineItem.IP_Address_Check__c!=true ){
                        System.debug('Contact Validation False 7');
                        contactValidation = false;
                    } 
                    if((pLineItem.APTS_Media_High_Level_Code__c != '05' && pLineItem.APTS_Media_Lower_Level_Code__c !='E9' && pLineItem.APTS_Media_Lower_Level_Code__c!= null) || (pLineItem.APTS_Media_High_Level_Code__c == '05' && pLineItem.APTS_Media_Lower_Level_Code__c !='E9') || (pLineItem.APTS_Media_High_Level_Code__c != '05' && pLineItem.APTS_Media_Lower_Level_Code__c == null)){
                        if(!lineitemMap.isEmpty() && lineitemMap.containsKey(pLineItem.Apttus_Proposal__Proposal__c)) {
                            lineitemMap.get(pLineItem.Apttus_Proposal__Proposal__c).add(pLineItem);    
                        }
                        else {
                            lineitemMap.put(pLineItem.Apttus_Proposal__Proposal__c, new List<Apttus_Proposal__Proposal_Line_Item__c> {pLineItem});
                        }
                    }
                }                
                    
            }
            // Sreenu - MLA Changes Start
            else If(pLineItem.Apttus_QPConfig__LineStatus__c == 'Amended' && pLineItem.Net_Qty_Difference__c != Null && pLineItem.Net_Qty_Difference__c > 0 && 
                ((!perSeatLLCodeMap.isEmpty() && perSeatLLCodeMap.containsKey(pLineItem.APTS_Media_Lower_Level_Code__c)) || (pLineItem.APTS_Media_High_Level_Code__c == '21') || (pLineItem.APTS_Media_High_Level_Code__c == '13' && pLineItem.APTS_Media_Lower_Level_Code__c == 'I9')) && 
                (pLineItem.APTS_Online_Contacts_Validation__c!=true) && 
                (!locationsMap.isEmpty() && locationsMap.containsKey(pLineItem.Apttus_Proposal__Proposal__c) && locationsMap.get(pLineItem.Apttus_Proposal__Proposal__c).APTS_Status__c == 'New')){
                System.debug('Contact Validation False 10');
                contactValidation = false;
                if(!lineitemMap.isEmpty() && lineitemMap.containsKey(pLineItem.Apttus_Proposal__Proposal__c)) {
                    lineitemMap.get(pLineItem.Apttus_Proposal__Proposal__c).add(pLineItem);    
                }
                else {
                    lineitemMap.put(pLineItem.Apttus_Proposal__Proposal__c, new List<Apttus_Proposal__Proposal_Line_Item__c> {pLineItem});
                }
            }
            // Sreenu - MLA Changes End
            }
            if (contactValidation!=true){
                System.debug('KS--> Contact Valdiation is set to False.');
                contactValidationMap.put(pLineItem.Apttus_Proposal__Proposal__c, false);
                }
                
            //Merged code as part of SOC-6701 Start--Gokila
                //SOC-4795 Sreenu Changes start  -Commented By Gayatri- Rewriting below logic in APTS_proposaltriggerhelper class
           /* if(propId == null || propId == pLineItem.Apttus_Proposal__Proposal__c || propId != pLineItem.Apttus_Proposal__Proposal__c){
                if(propId != pLineItem.Apttus_Proposal__Proposal__c){
                    propId = pLineItem.Apttus_Proposal__Proposal__c;
                    pickValues = '';
                }
                if(pLineItem.Apttus_Proposal__Product__r.Name == 'FirmSite 111C')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-111C');                
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FirmSite 222C')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-222C');                
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW FS Integrated Marketing Catalyst' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41892830')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-IMC');                
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'Integrated Marketing Suite:' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41777796')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-IMS');                
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW FS Integrated Marketing Essentials' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41822784')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-IME');
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'Integrated Marketing Presence' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41915678')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-IMP');   
                // Added by Gayatri   
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW CLIENT PULSE QUARTERLY' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '42089522')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Client Pulse Quart');              
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FINDLAW CLIENT PULSE' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '42089523')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Client Pulse');        
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FINDLAW REPUTATION REVIEW' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '42089524')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Reput Rev');
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW REPUTATION ADVISOR' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '42089521')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Rep Adv');             
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW BLOG PLATFORM - BPS' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41874867')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Blog Plat');       
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'SUPER LAWYERS PREM ONLINE FIRM PROFILE' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41618486')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-SuperL-Prem');             
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW ENGAGEMENT BUILDER' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41819164')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Eng Bldr');                
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW IMPACT SUITE' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41817448')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Imp Ste');     
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'LI CALL TRACKING NUMBER - NO CHARGE' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41895338')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Cal Track');
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'SUPER LAWYERS LEGAL LEADER' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41870119')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-SL Leg Lead');             
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FNDLW LEGAL LEADER' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41697107')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Leg Leadr');       
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FirmSite 333C' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '40483699')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-333C');
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'FirmSite 444C' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '40485592')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-444C');        
                else if(pLineItem.Apttus_Proposal__Product__r.Name == 'SUPER LAWYERS ASK ANSWER PAGE' || pLineItem.Apttus_Proposal__Product__r.ProductCode == '41484905')
                    pickValues = mapProductLanguageValues(pickValues, 'PI-LL-Ask Answ');                 
                                    
                if(!String.isEmpty(pickValues))
                    firmsiteMap.put(pLineItem.Apttus_Proposal__Proposal__c, pickValues);
            }*/
            //SOC-4795 Sreenu Changes end
            
            //Update APTS_Boolean_Count_of_Online__c flag -Gayatri changes Start
            /*  if(pLineItem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'FindLaw' &&
                pLineItem.Apttus_QPConfig__PriceType__c=='Recurring' && pLineItem.Apttus_QPConfig__ChargeType__c == 'Subscription Fee' && pLineItem.Apttus_QPConfig__LineStatus__c == 'New'){                
                 if(!proposalMap.containsKey(pLineItem.Apttus_Proposal__Proposal__c))
                 countOfOnlineMap.put(pLineItem.Apttus_Proposal__Proposal__c,pLineItem.Apttus_Proposal__Proposal__r.APTS_Boolean_Count_of_Online__c);              
                 }*/
           //Update APTS_Boolean_Count_of_Print_Ship_ONLY__c flag -Gayatri changes Start
           // Removed condition - pLineItem.APTS_Product_Family__c=='Engagement Solutions' -gayatri-09/01/2018
              if(pLineItem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'FindLaw' && pLineItem.Apttus_QPConfig__LineType__c=='Product/Service' &&
                pLineItem.Apttus_QPConfig__PriceType__c=='One Time' && pLineItem.Apttus_QPConfig__ChargeType__c == 'Standard Price' && pLineItem.Apttus_QPConfig__LineStatus__c == 'New'){                
                if(!proposalMap.containsKey(pLineItem.Apttus_Proposal__Proposal__c)){
                proposalMap.put(pLineItem.Apttus_Proposal__Proposal__c,pLineItem.Apttus_Proposal__Proposal__r.APTS_Boolean_Count_of_Print_Ship_ONLY__c); } 
            }
            else{ 
                if(!proposalNotFoundMap.containsKey(pLineItem.Apttus_Proposal__Proposal__c) && pLineItem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'FindLaw'){
                proposalNotFoundMap.put(pLineItem.Apttus_Proposal__Proposal__c,pLineItem.Apttus_Proposal__Proposal__r.APTS_Boolean_Count_of_Print_Ship_ONLY__c);}                  
           }
        }
         //Logic for checking the flag APTS_Boolean_Count_of_Print_Ship_ONLY__c 
      /*  if(!countOfOnlineMap.isEmpty()) {      
          for(Id pId : countOfOnlineMap.keySet()){
            Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(id=pId, APTS_Boolean_Count_of_Online__c=true);                 
            proposalCountList.put(p.id,p);
          }
        }*/
        //Logic for checking the flag APTS_Boolean_Count_of_Print_Ship_ONLY__c 
        if(!proposalMap.isEmpty()) {          
          for(Id pId : proposalMap.keySet()){
            Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(id=pId, APTS_Boolean_Count_of_Print_Ship_ONLY__c=true);
            if(!proposalprintShipMap.containsKey(p.id)){
            proposalprintShipMap.put(p.id,p);}
          }  
        }//Logic for Unchecking the flag APTS_Boolean_Count_of_Print_Ship_ONLY__c 
        else if(!proposalNotFoundMap.isEmpty()) {             
          for(Id pId : proposalNotFoundMap.keySet()){
            Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(id=pId, APTS_Boolean_Count_of_Print_Ship_ONLY__c=false);
            if(!proposalprintShipMap.containsKey(p.id)){
            proposalprintShipMap.put(p.id,p);}
          }
        } 
        //Merged code as part of SOC-6701 Ends--Gokila
       
        // Sreenu - MLA Changes Start
        if(!locationsMap.isEmpty()) {
            for(APTS_Quote_Agreement_Locations__c al :locationsMap.values()) {
                if(al.APTS_Status__c == 'Existing') {
                    Boolean isAmemnedOnly = True;
                    if(!lineitemMap.isEmpty() && lineitemMap.containsKey(al.APTS_Quote_Proposal__c)) {
                        for(Apttus_Proposal__Proposal_Line_Item__c litem :lineitemMap.get(al.APTS_Quote_Proposal__c)) {
                            If(litem.Apttus_QPConfig__LineStatus__c != 'Amended') {
                                isAmemnedOnly = False;
                                break;
                            }
                        }
                    }
                    if(!isAmemnedOnly){
                    contactValidationMap.put(al.APTS_Quote_Proposal__c, false);}
                } 
                if(al.APTS_Status__c == 'New') {
                    if(!lineitemMap.isEmpty() && lineitemMap.containsKey(al.APTS_Quote_Proposal__c)  && !lineitemMap.get(al.APTS_Quote_Proposal__c).isEmpty()){
                        contactValidationMap.put(al.APTS_Quote_Proposal__c, false);
                    }
                }
            }
        }
        // Sreenu - MLA Changes End
        for (Id pId : contactValidationMap.keySet()){
            Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(id=pId, APTS_Contact_Validation_Flag__c=contactValidationMap.get(pId));
            proposalList.add(p);
        }
        if(proposalList.size()>0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isCreateable()){
            upsert proposalList;
        }
        system.debug('proposalList-->'+proposalList);
        //Merged code as part of SOC-6701 Start--Gokila
             system.debug('proposalprintShipMap here======>'+proposalprintShipMap);
       if(!proposalprintShipMap.isEmpty()){ 
            upsert proposalprintShipMap.values();} 
        
       
   }
     
    //SOC-4795 Sreenu Changes Start
    public static string mapProductLanguageValues(string pValues, string pValue) {
        if(String.isEmpty(pValues)){
            pValues = pValue;}
        else if(!pValues.contains(pValue)){
            pValues = pValues + ';'+pValue;}
        return pValues;

    //Merged code as part of SOC-6701 Ends--Gokila
    
    }
    //SOC-4795 Sreenu Changes end
    // Sreenu Changes Start for validating the Online/Master Contacs Flag on before insert - SOC-2337
    public static void validateOnlineMasterFlags(List<Apttus_Proposal__Proposal_Line_Item__c> listNewObj) {
        set<Id> quoteIds = new Set<Id>();
        Map<String,String> onlineConMap = new Map<String, String>();
        Map<String, String> masterConMap = new Map<String, String>();
        map<Id, String> productMap = new Map<Id, String>();
        Set<Id> productIds = new Set<Id>();
        
        for(Apttus_Proposal__Proposal_Line_Item__c apli :listNewObj) {
           //Added for cloning fuctionality Auguest release-Prabhu Issac
            apli.APTS_Online_Contacts_Validation__c = False;
            apli.APTS_Master_Contacts_Validation__c = False;            
           //Prabhu ends
            quoteIds.add(apli.Apttus_Proposal__Proposal__c);
            productIds.add(apli.Apttus_Proposal__Product__c);
            // CPRO changes
            if(apli.APTS_Program_ID__c == 'CPRO' && apli.Apttus_QPConfig__LineType__c == 'Product/Service') {
                productMap.put(apli.Apttus_Proposal__Product__c, apli.APTS_Service_Number_Override__c); 
            }
        }
        
        for(Product2 prod :[SELECT Id, ProductCode from Product2 where Id = :productIds]) {
            if(!string.isEmpty(prod.ProductCode)){
                productMap.put(prod.Id, prod.ProductCode);    }
        }
        
        for(Online_Contacts__c onl :[Select Id, Material__c From Online_Contacts__c Where QuoteId__c =: quoteIds]) {
            if(onlineConMap.isEmpty() || !onlineConMap.containsKey(onl.Material__c)){
                onlineConMap.put(onl.Material__c, onl.Material__c);}    
        }
        
        for(Customer_Master_Contacts__c mc :[SELECT Id, Material__c FROM Customer_Master_Contacts__c WHERE Quote__c = : quoteIds]) {
            if(!string.isEmpty(mc.Material__c)) {
                for(string str : mc.Material__c.split(',')) {
                    if(masterConMap.isEmpty() || !masterConMap.containsKey(str)){
                        masterConMap.put(str, str); }
                }
            }
        } 
        
        for(Apttus_Proposal__Proposal_Line_Item__c aplis :listNewObj) {
            if(aplis.Apttus_Proposal__Product__c != null && !productMap.isEmpty() && productMap.containsKey(aplis.Apttus_Proposal__Product__c)) {
                system.debug('in method Sreenu...');
                if(!onlineConMap.isEmpty() && onlineConMap.containsKey(productMap.get(aplis.Apttus_Proposal__Product__c))) {
                    aplis.APTS_Online_Contacts_Validation__c = True;
                }
                if(!masterConMap.isEmpty() && masterConMap.containsKey(productMap.get(aplis.Apttus_Proposal__Product__c))) {
                    aplis.APTS_Master_Contacts_Validation__c = True;
                }
            }
        }
        
    } 
    //This method updates the Contract Availabilty field in the Proposal Line Item
    //DOC-2024,DOC-2028-Added by Nandha : Starts Here
    public static void updateContractAvailabilty(List<Apttus_Proposal__Proposal_Line_Item__c> listNewObj) {
            Set<String> materialno = new Set<String>();
            String availDate; 
            Integer fiscalmonth,contractmonth,contractyear;
            for(CORPMaterialNumber__c matno : CORPMaterialNumber__c.getall().values()){
                materialno.add(matno.MaterialNumber__c);
            }
            for (Apttus_Proposal__Proposal_Line_Item__c pLineItem : listNewObj){
            if(pLineItem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' && pLineItem.APTS_Availability_Date__c != NULL){
                if(pLineItem.APTS_Fiscal_Year_End__c != NULL && pLineItem.APTS_Fiscal_Year_End__c != '' && pLineItem.APTS_Fiscal_Filer__c == true){
                    for(Fiscal_Year_End__c fy :  Fiscal_Year_End__c.getall().values() ){
                        if(fy.Fiscal_Year__c == pLineItem.APTS_Fiscal_Year_End__c){
                            fiscalmonth = integer.valueof(fy.Month__c); 
                            contractmonth = fiscalmonth;
                            break;
                        }
                    }
                    if(pLineItem.APTS_Availability_Date__c > pLineItem.APTS_Finalized_Date__c){
                        if(fiscalmonth < pLineItem.APTS_Availability_Date__c.month()){
                            contractyear = pLineItem.APTS_Availability_Date__c.year() + 1;
                        }
                        if(fiscalmonth >= pLineItem.APTS_Availability_Date__c.month()){
                            contractyear = pLineItem.APTS_Availability_Date__c.year() + 2;
                        }
                    }
                    else{
                        if(fiscalmonth < pLineItem.APTS_Finalized_Date__c.month()){
                            contractyear = pLineItem.APTS_Finalized_Date__c.year() + 1;
                        }
                        if(fiscalmonth >= pLineItem.APTS_Finalized_Date__c.month()){
                            contractyear = pLineItem.APTS_Finalized_Date__c.year();
                        }
                    }
                    availDate = contractmonth + '/' + '1' + '/' + contractyear;
                    pLineItem.APTS_Contract_Availability__c = availDate;
                }
                else{
                    if(pLineItem.APTS_Finalized_Date__c < pLineItem.APTS_Availability_Date__c){
                        availDate = pLineItem.APTS_Availability_Date__c.format();
                        pLineItem.APTS_Contract_Availability__c = availDate;
                    }
                    if(pLineItem.APTS_Finalized_Date__c >= pLineItem.APTS_Availability_Date__c){
                        pLineItem.APTS_Contract_Availability__c = 'Upon Processing';
                    }
                }
            }
            //DOC-4566-Added by Nandha:Ends Here
            if((pLineItem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' || pLineItem.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK') && ((pLineItem.APTS_Item_Category_Group__c == 'ZT07' && plineitem.APTS_Product_Pricing_Model__c == 'TAX INFORMATION REPORTING') || pLineItem.APTS_FL_Material_Number__c == '30081375' || materialno.contains(pLineItem.APTS_FL_Material_Number__c) || pLineItem.APTS_WLEC_Product_Category__c == 'PS')){
                pLineItem.APTS_PS_Ancillary_Flag__c = True;
            }
            //DOC-4566-Added by Nandha:Ends Here
        } 
    }
    //DOC-2024,DOC-2028-Added by Nandha:Ends Here
    
        

    
     //Asset Auto Number functionality --- addedy by Poorva
    /*public static void updateAutoNumber(List<Apttus_Proposal__Proposal_Line_Item__c> newObjectList , Boolean isUpdate){
        try{
            Latam_AssetItemAutoNumber__c objAssetSetting = Latam_AssetItemAutoNumber__c.getOrgDefaults();
            //Latam_AssetItemAutoNumber__c objAssetSetting = Latam_AssetItemAutoNumber__c.getInstance(UserInfo.getProfileId());
            List<Id> assetIdList = new List<Id>();  
            Boolean isChanged = false;
            if(!('').equals(objAssetSetting.Auto_Format__c)){
                String autoNumber = objAssetSetting.Auto_Format__c + '%';
                for(Apttus_Proposal__Proposal_Line_Item__c proposalLine : newObjectList){
                    if(proposalLine.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                         if(!isUpdate && proposalLine.Apttus_QPConfig__LineStatus__c.equals('New') ){
                             if(objAssetSetting.Latam_Latest_Number__c == null){
                                 objAssetSetting.Latam_Latest_Number__c = objAssetSetting.Starting_Number__c != null ? objAssetSetting.Starting_Number__c : 0;                             
                             }
                             objAssetSetting.Latam_Latest_Number__c ++;
                             proposalLine.Asset_Auto_Number__c = objAssetSetting.Auto_Format__c + objAssetSetting.separator__c + String.valueOf(Integer.valueOf(objAssetSetting.Latam_Latest_Number__c)).leftPad(6, '0');
                             isChanged = true;
                         }else if(!isUpdate && proposalLine.Apttus_QPConfig__LineStatus__c.equals('Existing') || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Amended') 
                         || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Renewed') || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Changed Configuration')
                         || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Upgraded') || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Cancelled')){
                             assetIdList.add(proposalLine.Apttus_QPConfig__AssetLineItemId__c);
                         }else if(isUpdate && proposalLine.Apttus_QPConfig__LineStatus__c.equals('Renewed')){
                             assetIdList.add(proposalLine.Apttus_QPConfig__AssetLineItemId__c);
                         }
                     }
                     
                    
                }
                //if(latestNumber !=  objAssetSetting.Latam_Latest_Number__c){
                if(isChanged){
                    update objAssetSetting;
                }   
                if(!assetIdList.isEmpty())
                {
                    Map<Id, Apttus_Config2__AssetLineItem__c> assetMap = new Map<Id,Apttus_Config2__AssetLineItem__c>([select id, Asset_Auto_Number__c from Apttus_Config2__AssetLineItem__c where id in :assetIdList]);
                    if(assetMap != null){
                        for(Apttus_Proposal__Proposal_Line_Item__c proposalLine : newObjectList){
                            if(proposalLine.Apttus_QPConfig__LineStatus__c.equals('Existing') || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Amended')
                             || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Renewed') || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Changed Configuration')
                             || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Upgraded') || proposalLine.Apttus_QPConfig__LineStatus__c.equals('Cancelled')){
                                 proposalLine.Asset_Auto_Number__c = assetMap.get(proposalLine.Apttus_QPConfig__AssetLineItemId__c).Asset_Auto_Number__c;
                             }
                        }
                    }
                }
            }
         }catch(Exception e){
         
         }   
    }*/
    /*
     //Update contact validation flag for tax professional.
    public static void updateContactValidationFlag(List<Apttus_Proposal__Proposal_Line_Item__c> newProposalLines, String event){
        Map<Id, Boolean> contactValidationMap = new Map<Id, Boolean>();
        Set<Id> proposalIds = new Set<Id>();
        Map<Id, Apttus_Proposal__Proposal_Line_Item__c> oldPliMap = new Map<Id, Apttus_Proposal__Proposal_Line_Item__c>();
        List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
        Boolean flag;  
        
        if(event == 'delete'){
            for(Apttus_Proposal__Proposal_Line_Item__c item : newProposalLines){
                if(item.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
                    proposalIds.add(item.Apttus_Proposal__Proposal__c);
                    oldPliMap.put(item.id, item);
                }
            }
            List<Apttus_Proposal__Proposal__c> propList =  new List<Apttus_Proposal__Proposal__c>();
            if(!proposalIds.isEmpty()){
                propList = [select id, (select id from R00N70000001yUfBEAU__r) from Apttus_Proposal__Proposal__c where id in :proposalIds and APTS_Contact_Validation_Flag__c = true];
                if(!propList.isEmpty()){
                    for(Apttus_Proposal__Proposal__c prop : propList){
                        flag = false;
                        for(Apttus_Proposal__Proposal_Line_Item__c pli: prop.R00N70000001yUfBEAU__r){
                         if(!oldPliMap.containsKey(pli.id)){
                             flag = true;
                             break;
                         }
                        }
                        if(flag == false){
                            Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(id=prop.Id, APTS_Contact_Validation_Flag__c=false);
                            proposalList.add(p);   
                        }
                    }
                    if(proposalList.size()>0){
                        upsert proposalList; 
                    } 
                }
            }
        }
    }
    */
    public static void populateProductVariant(List<Apttus_Proposal__Proposal_Line_Item__c> newProposalLineitems)
    {
        system.debug('****Method Call');
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIToupdate  =new List<Apttus_Proposal__Proposal_Line_Item__c>();

        Map<id,Apttus_Proposal__Proposal_Line_Item__c> variantIdProposal=new  Map<id,Apttus_Proposal__Proposal_Line_Item__c>();
        Map<Id, Id>  mapVarientProposalIds = new  Map<Id, Id>();
        List<String> listproductcode=new list<String>();
        List<String> listAttVal=new list<String>();
         /*DOC-7682 Product Variant(Navpreet) Code Starts here*/
        
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList=[select Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.APTS_Product_Delivery__c,Apttus_Proposal__Product__r.productcode,Apttus_QPConfig__AttributeValueId__r.APTS_Product_Delivery__c,Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c from Apttus_Proposal__Proposal_Line_Item__c where id in:newProposalLineitems];
        //List<Apttus_Config2__LineItem__c> proposaldDetails=[select Apttus_Config2__ProductId__r.productcode, Apttus_Config2__AttributeValueId__r.APTS_Product_Delivery__c from Apttus_Config2__LineItem__c where id in :newProposalLineitems.Apttus_QPConfig__DerivedFromId__c];
        for(Apttus_Proposal__Proposal_Line_Item__c item: proposalLineItemList)
        {
            listproductcode.add(item.Apttus_Proposal__Product__r.productcode);
            listAttVal.add(item.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.APTS_Product_Delivery__c);

            system.debug('######Attribute record'+item.Apttus_QPConfig__AttributeValueId__c);
        }
        system.debug('######if listproductcode'+listproductcode);
        system.debug('listAttVal '+listAttVal);
        List<APTS_Product_Variant__c> listVariantId = new List<APTS_Product_Variant__c>();
        if(Schema.sObjectType.APTS_Product_Variant__c.isAccessible() && Schema.sObjectType.APTS_Product_Variant__c.isQueryable()){
             listVariantId=[select APTS_Product_Variant_ID__c,APTS_Product_ID__c,APTS_Product_Delivery__c  from APTS_Product_Variant__c where APTS_Product_ID__c in :listproductcode and APTS_Product_Delivery__c in :listAttVal];
        }
        system.debug('######if listVariantId'+listVariantId);
        system.debug('Size of PLIs '+proposalLineItemList.size());
         for(Apttus_Proposal__Proposal_Line_Item__c pli: proposalLineItemList)
         {
            for(APTS_Product_Variant__c pv:listVariantId)
            {
                system.debug('######if 1');
                if(pli.Apttus_Proposal__Product__r.productcode==pv.APTS_Product_ID__c && pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.APTS_Product_Delivery__c == pv.APTS_Product_Delivery__c)
                {
                    variantIdProposal.put(pv.id,pli);
                    system.debug('######if');
                    mapVarientProposalIds.put(pli.Id, pv.id);
                }
            }
         }

        system.debug('###### proposalLineItemList'+proposalLineItemList);
        system.debug('###### mapVarientProposalIds'+mapVarientProposalIds);
        if (proposalLineItemList!= null && proposalLineItemList.size() > 0) {
            for(Apttus_Proposal__Proposal_Line_Item__c proposalLis : proposalLineItemList) {
                if (mapVarientProposalIds.containsKey(proposalLis.Id) && proposalLis.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c=='Tax Professional') {
                    proposalLis.Apttus_product_variant__c = mapVarientProposalIds.get(proposalLis.id);
                              system.debug('product variant'+mapVarientProposalIds.get(proposalLis.id));
                    lstPLIToupdate.add(proposalLis);
                }
            }
            if (lstPLIToupdate != null && lstPLIToupdate.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isUpdateable()) {
                update lstPLIToupdate;
            }
        }/*DOC-7682 Product Variant(Navpreet) Code Ends here*/  
    }
    
    //Start: GLP-57
    public static void populateContractTermSubscription(List<Apttus_Proposal__Proposal_Line_Item__c> newProposalLineitems) {
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLIToUpdate = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        system.debug('##### in');
        Set<Id> setProposalIds = new Set<Id>();
        Set<Id> setProductId = new Set<Id>();
        Map<Id, Apttus_QPConfig__ProposalProductAttributeValue__c> mapPAV = new Map<Id, Apttus_QPConfig__ProposalProductAttributeValue__c>();
        for (Apttus_Proposal__Proposal_Line_Item__c objPLI : newProposalLineitems) {
            setProposalIds.add(objPLI.Id);
        }
        List<Apttus_QPConfig__ProposalProductAttributeValue__c> lstProposalPAV = [Select Id, Apttus_QPConfig__LineItemId__c,Purchase_Option_Bundle_Print__c, SCS_Print_Purchase_Options__c,
                                                                eBook_Purchase_Options__c from Apttus_QPConfig__ProposalProductAttributeValue__c
                                                                where Apttus_QPConfig__LineItemId__c IN: setProposalIds];
        if (lstProposalPAV != null && lstProposalPAV.size() > 0) {
            for (Apttus_QPConfig__ProposalProductAttributeValue__c objPAV :  lstProposalPAV ) {
                mapPAV.put(objPAV.Apttus_QPConfig__LineItemId__c, objPAV);
            }
        }
        
        Boolean blnIs21 = false;
        system.debug('##### mapPAV'+lstProposalPAV);
        for (Apttus_Proposal__Proposal_Line_Item__c objPLI : newProposalLineitems) {
            if (objPLI.Apttus_QPConfig__LineType__c == 'Product/Service') {
                if(objPLI.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Sub' || objPLI.Purchase_Option_Bundle_Print__c == 'Ship & Entitle - APP'){
                    objPLI.Contract_Subscription_Type_Text__c  = 'Ship-Entitle & Enter Subscription';
                }
                else if(objPLI.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Only'){
                   objPLI.Contract_Subscription_Type_Text__c  = 'Ship-Entitle-No Subscription';
                }
                else if(objPLI.Purchase_Option_Bundle_Print__c == 'Sub Only' || objPLI.Purchase_Option_Bundle_Print__c == 'Sub Only APP'){
                   objPLI.Contract_Subscription_Type_Text__c  = 'Subscription Only';
                }
                else if (objPLI.APTS_Proposal_Business_Unit__c == 'Canada' && objPLI.APTS_Media_High_Level_Code__c == '02') {
                    objPLI.Contract_Subscription_Type_Text__c  = objPLI.APTS_Contract_Subscription__c;
                } else if (objPLI.APTS_Proposal_Business_Unit__c == 'Canada' && objPLI.APTS_Media_High_Level_Code__c == '07'
                   && objPLI.APTS_Item_Category_Group__c == 'ZVAM') {
                    objPLI.Contract_Subscription_Type_Text__c  = 'Ship & Enter Subscription';
                } else if (objPLI.APTS_Media_High_Level_Code__c == '07') {
                    if (objPLI.APTS_Product_Pricing_Model__c  != null
                        && (objPLI.APTS_Product_Pricing_Model__c == 'Print Finished' ||
                       objPLI.APTS_Product_Pricing_Model__c == 'Print Finished No Service')) {
                        objPLI.Contract_Subscription_Type_Text__c  = 'Ship Only-No Subscription';
                    } else if (mapPAV != null && mapPAV.containsKey(objPLI.Id) && mapPAV.get(objPLI.Id) != null) {
                        system.debug('in if 07'+objPLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c );
                            if (mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Ship & Enter Sub APP'
                            || mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Ship & Enter Sub') { 
                                objPLI.Contract_Subscription_Type_Text__c  = 'Ship & Enter Subscription';
                            } else if (mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Fill-Up & Enter Sub APP' 
                            || mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Sub Only'
                            || mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Sub Only APP'
                            || mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Fill-Up & Enter Sub') {
                                objPLI.Contract_Subscription_Type_Text__c = 'Subscription Only';
                            } else if (mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Ship Only'
                                || mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Fill-Up') {
                                objPLI.Contract_Subscription_Type_Text__c  = 'Ship Only-No Subscription';
                            }
                    }
                } else if (objPLI.APTS_Media_High_Level_Code__c == '08') {
                    objPLI.Contract_Subscription_Type_Text__c = 'Seminars';
                } else if (objPLI.APTS_Media_High_Level_Code__c == '21') {
                    if (objPLI.APTS_Media_Lower_Level_Code__c == 'CQ') {
                        objPLI.Contract_Subscription_Type_Text__c = 'Subscription Only';
                    } else if (objPLI.APTS_Product_Pricing_Model__c != null && objPLI.APTS_Product_Pricing_Model__c == 'Proview OTC') {
                       objPLI.Contract_Subscription_Type_Text__c = 'Entitle only - no subscription'; //- no subscription';
                       system.debug('###### objPLI.Contract_Subscription_Type_Text__c '+objPLI.Contract_Subscription_Type_Text__c);
                    } else if (mapPAV != null && mapPAV.containsKey(objPLI.Id) != null && mapPAV.get(objPLI.Id) != null
                        && mapPAV.get(objPLI.Id).eBook_Purchase_Options__c != null) {
                        if (mapPAV.get(objPLI.Id).eBook_Purchase_Options__c == 'APP') {
                            objPLI.Contract_Subscription_Type_Text__c = 'Subscription Only';
                        } else if (mapPAV.get(objPLI.Id).eBook_Purchase_Options__c == 'Entitle and Charge') {
                            objPLI.Contract_Subscription_Type_Text__c = 'Entitle & Enter Subscription';
                        } 
                    } else if (mapPAV != null && mapPAV.containsKey(objPLI.Id) != null && mapPAV.get(objPLI.Id) != null
                        && mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c != null) {
                        if (mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Fill-Up & Enter Sub APP' || 
                            mapPAV.get(objPLI.Id).SCS_Print_Purchase_Options__c == 'Fill-Up') {
                            objPLI.Contract_Subscription_Type_Text__c = 'Ship Only-No Subscription';
                        }
                    }  else if (objPLI.Apttus_QPConfig__ChargeType__c != null && objPLI.Apttus_QPConfig__ChargeType__c == 'Subscription Fee') {
                            objPLI.Contract_Subscription_Type_Text__c = 'Entitle & Enter Subscription';
                    } else {
                        objPLI.Contract_Subscription_Type_Text__c = 'Entitle only - no subscription';
                    } 
                }
            }
            system.debug('### objPLI'+objPLI);  
        }
    }
    //End GLP-57
    
    //Start: GLP-57
    public static void populateContractDisplayFrench(List<Apttus_Proposal__Proposal_Line_Item__c> newProposalLineitems) {
        String strOriginal = '';
        String strTranslated = '';
        List<APTS_Integration_Variables__mdt> orderSubmissionEsiList;
        if(Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible() && Schema.sObjectType.APTS_Integration_Variables__mdt.isQueryable()){
            orderSubmissionEsiList=[Select MasterLabel,Value__c from APTS_Integration_Variables__mdt];
        }
        for(APTS_Integration_Variables__mdt var : orderSubmissionEsiList){
            if(var.masterlabel=='French Language Display Original') {
                strOriginal =var.Value__c;
            } 
            if(var.masterlabel=='French Language Display Translated') {
                strTranslated =var.Value__c;
            }
        }
        
        system.debug('######## mapContractTerm'+strOriginal +'---- >'+strTranslated);
        
        List<String> lstOriginal = new List<String>();
        lstOriginal = strOriginal.split(',');
        
        List<String> lstTranslated = new List<String>();
        lstTranslated = strTranslated.split(',');
        
        Map<String, String> mapContractTerm = new Map<String, String>();
        
        if (lstOriginal.size() == lstTranslated.size()) {
            for (Integer i=0 ;i<lstTranslated.size(); i++) {
                mapContractTerm.put(lstOriginal[i],lstTranslated[i]);
            }
        }
        
        system.debug('######## mapContractTerm'+mapContractTerm);
        
        if (newProposalLineitems != null && newProposalLineitems.size() > 0 && mapContractTerm != null && mapContractTerm.size() > 0) {
            
            for (Apttus_Proposal__Proposal_Line_Item__c objPLI : newProposalLineitems) {
                if (!string.isBlank(objPLI.Contract_Subscription_Type_Text__c) && lstOriginal.size() > 0 && lstTranslated.size() > 0 && mapContractTerm.containsKey(objPLI.Contract_Subscription_Type_Text__c)) {
                    objPLI.APTS_Contract_Sub_Type_French_Display__c = mapContractTerm.get(objPLI.Contract_Subscription_Type_Text__c); 
                }
            }
        }
    }
    
    public static void pupulateNetPrintProview(List<Apttus_Proposal__Proposal_Line_Item__c> newProposalLineitems) {
        Set<String> setContractTermValues = new Set<String>{'Ship Only-No Subscription','Entitle only - no subscription','Seminars','Ship-Entitle-No Subscription'};
        Set<String> setLineType = new Set<String>{'Option','Misc'};
        Set<String> setHighLevelCode = new Set<String>{'07','21','08'};
        Set<String> setHighLevelCodeCars = new Set<String>{'02','07','21','08'};
        if (newProposalLineitems != null && newProposalLineitems.size() > 0
            && setContractTermValues != null && setContractTermValues.size() > 0 && setHighLevelCode != null && setHighLevelCode.size() > 0
            && setHighLevelCodeCars != null && setHighLevelCodeCars.size() >0) {
            for (Apttus_Proposal__Proposal_Line_Item__c objPLI : newProposalLineitems) {
                if (setContractTermValues.contains(objPLI.Contract_Subscription_Type_Text__c)
                    && !setLineType.contains(objPLI.Apttus_QPConfig__LineStatus__c)
                    && setHighLevelCode.contains(objPLI.APTS_Media_High_Level_Code__c)
                    && objPLI.APTS_Proposal_Business_Unit__c != 'Canada') {
                        objPLI.APTS_Net_Price_PrintProview_No_Sub__c = objPLI.APTS_Net_Price_display__c;   
                }  else if (objPLI.APTS_Proposal_Business_Unit__c == 'Canada' && setHighLevelCodeCars.contains(objPLI.APTS_Media_High_Level_Code__c)
                    && setContractTermValues.contains(objPLI.Contract_Subscription_Type_Text__c)
                    && !setLineType.contains(objPLI.Apttus_QPConfig__LineStatus__c)) {
                        objPLI.APTS_Net_Price_PrintProview_No_Sub__c = objPLI.APTS_Net_Price_display__c;   
                }
            }
        }
    }
    //DOC-15215
    /**
     * @description updateOneTimeProducts
     * @param lstPropLineItems
     */
    public static void updateOneTimeProducts(List<Apttus_Proposal__Proposal_Line_Item__c> lstPropLineItems)
    {
        String vRiskRIProfessionalServices = '';
        List<APTS_Integration_Variables__mdt> integrationVarList= new List<APTS_Integration_Variables__mdt>();
    
        if (Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible() && Schema.sObjectType.APTS_Integration_Variables__mdt.isQueryable()) {
            integrationVarList=[Select MasterLabel,Value__c from APTS_Integration_Variables__mdt];
        }
        for (APTS_Integration_Variables__mdt var : integrationVarList) {
            if (var.masterlabel.contains('Risk RI Professional Services')) {
                vRiskRIProfessionalServices = vRiskRIProfessionalServices + var.Value__c;
            }
        }
        if (checkVRiskProfService(vRiskRIProfessionalServices)) {
            for (Apttus_Proposal__Proposal_Line_Item__c objPLI : lstPropLineItems) {
                if (checkMaterialNum(objPLI) && vRiskRIProfessionalServices.contains(objPLI.APTS_FL_Material_Number__c)) {
                    objPLI.XA_Is_on_MagicTable__c= true;
                }
            }
        }
    }

    /**
     * @description checkVRiskProfService
     * @return checkVRiskProfService
     * @param vRiskRIProfessionalServices
     */
    public static Boolean checkVRiskProfService(String vRiskRIProfessionalServices){
        Boolean blnVRiskFlag = false;
        if(vRiskRIProfessionalServices!=null && vRiskRIProfessionalServices!=''){
            blnVRiskFlag = true;
        }
        return blnVRiskFlag;
    }

    /**
     * @description checkMaterialNum
     * @return checkMaterialNum
     * @param objPLI
     */
    public static Boolean checkMaterialNum(Apttus_Proposal__Proposal_Line_Item__c objPLI){
        Boolean blnMatNum=False;
        if (objPLI.APTS_FL_Material_Number__c != null && objPLI.APTS_FL_Material_Number__c != ''){
            blnMatNum = true;
        }
        return blnMatNum;
    }

     /**
     * @description updateLapseDate
     * @param lstPropLineItems
     */
    public static void updateLapseDate(List<Apttus_Proposal__Proposal_Line_Item__c> lstPropLineItems) {
        Set<String> setSAPAgreementNumber = new Set<String>();
        Set<String> setSSDIds = New Set<String>();
        Set<ID> setAccountIds = New Set<ID>();

        Set<ID> setProposalIds = returnSetPropIds(lstPropLineItems);

        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLI= returnQuerylstPLI(setProposalIds);
                                                                
        if (lstPLI != null && lstPLI .size() > 0) {

            for (Apttus_Proposal__Proposal_Line_Item__c objPLI : lstPLI) {
                if (returnObjPLICheck(objPLI)) {
                        setSAPAgreementNumber.add(objPLI.Apttus_QPConfig__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c);
                        setSSDIds.add(objPLI.APTS_SSD_Sold_To__c);
                        setAccountIds.add(objPLI.Apttus_QPConfig__BillToAccountId__c);
                }
            }
        }

        Map<String, Date> mapAssetIdToRenewalDate = new Map<String, Date>();
        Map<Id, String> mapAssetToMLANumber = new Map<Id, String>();
        if (returnCheckSets(setAccountIds, setSSDIds)) {
            List<Apttus_Config2__AssetLineItem__c> lstAssetLineItems = returnQueryLstAssetLineItems(setAccountIds, setSSDIds);
            system.debug('############ lstAssetLine'+lstAssetLineItems);
            if (returnlstALI(lstAssetLineItems)) {
                for (Apttus_Config2__AssetLineItem__c objALI : lstAssetLineItems ) {
                    mapAssetIdToRenewalDate = returnMapAssetIdToRenewalDate(objALI, setSAPAgreementNumber, mapAssetIdToRenewalDate);
                    mapAssetToMLANumber = returnMLAPLIs(objALI, mapAssetToMLANumber);
                }
            } 
            system.debug('########### mapAssetToMLANumber'+mapAssetToMLANumber);
            system.debug('########### mapAssetIdToRenewalDate '+mapAssetIdToRenewalDate );
        }
        if (returnlstPLI(lstPropLineItems)) { 
            setDate(lstPropLineItems, mapAssetToMLANumber, mapAssetIdToRenewalDate);
        }
    }

    /**
    * @description returnSetPropIds
    * @return returnSetPropIds
    * @param lstPropLineItems
    */
    public static Set<ID> returnSetPropIds(List<Apttus_Proposal__Proposal_Line_Item__c> lstPropLineItems){
        Set<ID> setProposalIds = new Set<ID>();
        for (Apttus_Proposal__Proposal_Line_Item__c objPLI : lstPropLineItems) {
            setProposalIds.add(objPLI.Apttus_Proposal__Proposal__c);
        }
    return setProposalIds;
    }

    /**
     * @description returnQuerylstPLI
     * @return returnQuerylstPLI
     * @param setProposalIds
     */
    public static List<Apttus_Proposal__Proposal_Line_Item__c> returnQuerylstPLI(Set<ID> setProposalIds){
        List<Apttus_Proposal__Proposal_Line_Item__c> lstPLI = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        if(Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
        lstPLI = [Select Id, Apttus_QPConfig__AssetLineItemId__c , APTS_Product_Family__c, Apttus_QPConfig__AssetLineItemId__r.APTS_Info_RenewalDate__c,
                                Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.family , Apttus_QPConfig__AssetLineItemId__r.APTS_SAP_MLA_Agreement_Number__c,
                                APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c, Apttus_QPConfig__BillToAccountId__c,  APTS_SSD_Sold_To__c,  APTS_Lapse_Date__c 
                                from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c IN: setProposalIds
                                AND Apttus_QPConfig__LineStatus__c = 'Cancelled'];
        }
        return lstPLI;
    }

    /**
     * @description returnObjPLICheck
     * @return returnObjPLICheck
     * @param objPLI
     */
    public static Boolean returnObjPLICheck(Apttus_Proposal__Proposal_Line_Item__c objPLI){
        Boolean isBlnObj =false;
        if (objPLI.Apttus_Proposal__Product__r.ProductCode != null 
            && objPLI.Apttus_QPConfig__AssetLineItemId__c != null 
            && objPLI.Apttus_QPConfig__AssetLineItemId__r.APTS_Info_RenewalDate__c != null
            && objPLI.APTS_SSD_Sold_To__c != null
            && objPLI.Apttus_QPConfig__BillToAccountId__c != null) {
            isBlnObj =true;
        }
        return isBlnObj;
    }

    /**@description returnCheckSets
     * @return returnCheckSets
     * @param setSAPAgreementNumber
     * @param setAccountIds
     * @param setSSDIds
     */
    public static Boolean returnCheckSets(Set<ID> setAccountIds, Set<String> setSSDIds){
        Boolean isBlnSet = false;
        if (setAccountIds != null && setAccountIds.size() > 0
            && setSSDIds != null && setSSDIds.size() > 0 ){
                isBlnSet = true;
        }
        return isBlnSet;
    }

    /**
     * @description returnQueryLstAssetLineItems
     * @return returnQueryLstAssetLineItems
     * @param setSAPAgreementNumber
     * @param setAccountIds
     * @param setSSDIds
     */
    public static List<Apttus_Config2__AssetLineItem__c> returnQueryLstAssetLineItems(Set<ID> setAccountIds, Set<String> setSSDIds){
        List<Apttus_Config2__AssetLineItem__c> lstAssetLineItems = new List<Apttus_Config2__AssetLineItem__c>();
        if(Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isAccessible() && Schema.sObjectType.Apttus_Config2__AssetLineItem__c.isQueryable()){
            lstAssetLineItems = [Select Id, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,
                                                                        Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, Apttus_Config2__ProductId__r.Family, APTS_Info_RenewalDate__c
                                                                        from Apttus_Config2__AssetLineItem__c
                                                                        where Apttus_Config2__BillToAccountId__c IN: setAccountIds
                                                                        AND APTS_SSD_Sold_To__c IN: setSSDIds];
        }
        return lstAssetLineItems;
    }


    /**@description returnlstALI
     * @return returnlstALI
     * @param lstAssetLineItems
     */
    public static Boolean returnlstALI(List<Apttus_Config2__AssetLineItem__c> lstAssetLineItems){
        Boolean islstALI = false;
        if(lstAssetLineItems != null && lstAssetLineItems.size() > 0) {
            islstALI =true;
        }
        return islstALI;
    }
    
    /**
     * @description returnBooleanFor13PQ
     * @return returnCLAssets
     * @param objALI
     */
    public static Boolean returnCLAssets(Apttus_Config2__AssetLineItem__c objALI) { 
        Boolean blnIsCLAsset = false;
        if (objALI.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' 
            && objALI.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='PQ'
            && (objALI.Apttus_Config2__ProductId__r.Family != null 
            && objALI.Apttus_Config2__ProductId__r.Family.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
               blnIsCLAsset = true;      
        }
        return blnIsCLAsset ;
    }

    /**
     * @description returnMapAssetIdToRenewalDate
     * @return returnMapAssetIdToRenewalDate 
     * @param objALI
     * @param setSAPAgreementNumber
     * @param mapAssetIdToRenewalDate
     */
    public static Map<String, Date> returnMapAssetIdToRenewalDate(Apttus_Config2__AssetLineItem__c objALI, Set<String> setSAPAgreementNumber, Map<String, Date> mapAssetIdToRenewalDate) { 
        if (returnCLAssets(objALI) && !String.isBlank(objALI.APTS_SAP_MLA_Agreement_Number__c)) {
            mapAssetIdToRenewalDate.put(objALI.APTS_SAP_MLA_Agreement_Number__c, objALI.APTS_Info_RenewalDate__c);       
        }  else if (returnCLAssets(objALI) && String.isBlank(objALI.APTS_SAP_MLA_Agreement_Number__c)) {
            mapAssetIdToRenewalDate.put(objALI.Id, objALI.APTS_Info_RenewalDate__c);  
        }
        system.debug('####### mapAssetIdToRenewalDate'+mapAssetIdToRenewalDate);
        return mapAssetIdToRenewalDate;
    }
    
    /**
     * @description returnMLAPLIs
     * @return returnMLAPLIs
     * @param objALI
     */
    public static Map<Id, String> returnMLAPLIs(Apttus_Config2__AssetLineItem__c objALI, Map<Id, String> mapAssetToMLANumber) { 
        
        if (!String.isBlank(objALI.APTS_SAP_MLA_Agreement_Number__c)) {
            mapAssetToMLANumber.put(objALI.Id, objALI.APTS_SAP_MLA_Agreement_Number__c);
        }
        return mapAssetToMLANumber;
    }

    /**@description returnlstPLI
     * @return returnlstPLI
     * @param lstPropLineItems
     */
    public static Boolean returnlstPLI(List<Apttus_Proposal__Proposal_Line_Item__c> lstPropLineItems){
        Boolean islstPLI = false;
        if(lstPropLineItems != null && lstPropLineItems.size() > 0) {
            islstPLI =true;
        }
        return islstPLI;
    }

    /**
     * @description setDate
     * @param lstPropLineItems
     * @param mapAssetToMLANumber
     * @param mapAssetIdToRenewalDate
     */
    public static void setDate(List<Apttus_Proposal__Proposal_Line_Item__c> lstPropLineItems, Map<Id, String> mapAssetToMLANumber, Map<String, Date> mapAssetIdToRenewalDate){
        for (Apttus_Proposal__Proposal_Line_Item__c objPLI : lstPropLineItems) {
            if (returnProfCheck(objPLI, mapAssetToMLANumber, mapAssetIdToRenewalDate)) {
                    Date tempRenewalDate = mapAssetIdToRenewalDate.get(mapAssetToMLANumber.get(objPLI.Apttus_QPConfig__AssetLineItemId__c));
                    objPLI.APTS_Lapse_Date__c  = returnLapseDate(tempRenewalDate);
        
            } else if (returnCslnStandCheck(objPLI, mapAssetIdToRenewalDate)) {
                    Date tempRenewalDate = mapAssetIdToRenewalDate.get(objPLI.Apttus_QPConfig__AssetLineItemId__c);
                    objPLI.APTS_Lapse_Date__c  = returnLapseDate(tempRenewalDate);
            }
        }
    }

    /**
     * @description returnProfCheck
     * @return returnProfCheck
     * @param objPLI
     * @param mapAssetToMLANumber
     * @param mapAssetIdToRenewalDate
     */
    public static boolean returnProfCheck(Apttus_Proposal__Proposal_Line_Item__c objPLI, Map<Id, String> mapAssetToMLANumber, Map<String, Date> mapAssetIdToRenewalDate){
        Boolean isBlnCheck = false;
        if (objPLI.APTS_FL_Material_Number__c != null 
            && System.Label.APTS_Proflex_Materials.contains(objPLI.APTS_FL_Material_Number__c)
            && mapAssetToMLANumber != null 
            && mapAssetToMLANumber.containsKey(objPLI.Apttus_QPConfig__AssetLineItemId__c)
            && mapAssetIdToRenewalDate != null 
            && mapAssetIdToRenewalDate.containskey(mapAssetToMLANumber.get(objPLI.Apttus_QPConfig__AssetLineItemId__c))) {
                    isBlnCheck = true;
        }
        return isBlnCheck;
    }

    /**
     * @description returnCslnStandCheck
     * @return returnCslnStandCheck
     * @param objPLI
     * @param mapAssetToMLANumber
     * @param mapAssetIdToRenewalDate
     */
    public static Boolean returnCslnStandCheck(Apttus_Proposal__Proposal_Line_Item__c objPLI, Map<String, Date> mapAssetIdToRenewalDate){
        Boolean isBlnCheckCS =false;
        if (returnIsObjCheck(objPLI)
            && mapAssetIdToRenewalDate != null 
            && mapAssetIdToRenewalDate.get(objPLI.Apttus_QPConfig__AssetLineItemId__c) != null){
                isBlnCheckCS = true;
        }
        return isBlnCheckCS;
    }

    /**
     * @description returnIsObjCheck
     * @return returnIsObjCheck
     * @param objPLI
     */
    public static Boolean returnIsObjCheck(Apttus_Proposal__Proposal_Line_Item__c objPLI){
        Boolean isBlnCaseLine = false;
        if(objPLI.Apttus_QPConfig__AssetLineItemId__c != null 
            && objPLI.APTS_Media_High_Level_Code__c =='13' && objPLI.APTS_Media_Lower_Level_Code__c =='PQ'
            && (objPLI.APTS_Product_Family__c != null 
            && objPLI.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
                isBlnCaseLine = true;
            }
        return isBlnCaseLine;
    }

    /**
     * @description returnLapseDate
     * @param renewalDate
     * @return date
     */
    public static Date returnLapseDate(Date renewalDate){
        Date lapseDate;
        Date tempRenewalDate = renewalDate;
        
        Integer renwlDay = tempRenewalDate.day() - 1;
        Integer renwlMonth = tempRenewalDate.month();
         
        Date dt = System.today();
        Integer currentMonth = dt.month();
        Integer currentYear = dt.year();
        Integer currentdate = dt.day();
         
        if(currentMonth > renwlMonth) {
            lapseDate = date.newInstance(currentYear+1, renwlMonth, renwlDay); 
        } else if (currentMonth == renwlMonth && renwlDay >= currentdate ) {
            lapseDate = date.newInstance(currentYear, renwlMonth, renwlDay); 
        } else if (currentMonth < renwlMonth) {
            lapseDate = date.newInstance(currentYear, renwlMonth, renwlDay); 
        } else if (currentMonth == renwlMonth && renwlDay < currentdate ){
            lapseDate = date.newInstance(currentYear+1, renwlMonth, renwlDay);
        }  
        System.debug('##########lapseDate'+lapseDate);
        return lapseDate;
    }
 
}