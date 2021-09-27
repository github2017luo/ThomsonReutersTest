/*
 *Change Items:
1. Neeharika Upadrasta, 23rd Aug 2017
    Added APTS_Incremental_Growth_violated = true for Product Configuration where the Approval is triggered based on Incremental Growth criteria. 
    This will be used in Approval Rule (Entries) to update the Condition when Incremental Growth violation is true.
2. Neeharika Upadrasta, 20th Sep 2017
    To fix 'Draft' status of Quote even after it is Submitted and Approved, added a condition on Product Config Approval Status to check if Line Item
    approval or Incremental Growth is violated. If both do not require approval and cart is in Approval Required, status then reset to Draft.
3. Neeharika Upadrasta, 3rd Oct 2017
    To fix incorrect approval firing, moved the 'ProdConfigApproval' method to Before Update from After Update
4. Neeharika Upadrasta, 6th Oct 2017
    To fix SOQL 101 issue in LRP1QA1(E-commerce CXD dev) env, removed the Segment Threshold SOQL from 'ProdConfigApproval' method and added it 
    as a Static class List (segmentThresholdList).
5. Neeharika Upadrasta, 9th Oct 2017
    To fix Approval Required status on Configuration even after it is Approved. Added a condition to check if Status on Prod Config is New,
    Ready For Approvals or Approval Required only then check the Segment Thresholds and update status to Approval Required.
6. Neeharika Upadrasta, 11th Oct 2017
    Added 'Saved' to the list of valid statuses on Product Configuration to trigger approval.  
7. Neeharika Upadrasta, 16th Oct 2017
    Removed Approval Status update from 'ProdConfigApproval' since it is conflicting with CXD testing. 
    Issue - When user clicks on 'Add/Edit products' button after Finalization, new cart is created and Approval is firing for this new cart. 
    This is changing Proposal Approval Status back to 'Approval Required'. 
8. Neeharika Upadrasta, 27th Oct 2017
    Added condition if incremental growth formula < 0, then Approval = true. This is to trigger Approvals for negative incremental growth. 
*/
public with sharing class APTS_ProductConfigurationTriggerHelper {
    //Added following SOQL as Change 4
     //SOC-5933 Added by CG 12/19/17 Added new fields in the SOQL
    static List<APTS_Segment_Threshold__c> segmentThresholdList = new List<APTS_Segment_Threshold__c>([Select APTS_Approval_Required__c,APTS_Customer_Category__c,
                                                                                                    APTS_Minimum_Incremental_Growth__c,APTS_Minimum_OY_Increase__c,
                                                                                                    APTS_Product_Family__c,APTS_Segment__c,APTS_Term_in_years__c,
                                                                                                    APTS_Promo_Codes__c, APTS_Promo_Minimum_Incremental_Growth__c,
                                                                                                    APTS_Renewal_Window__c   //DOC-14800
                                                                                                    from APTS_Segment_Threshold__c]);
    static APTS_Configurable_Variables__mdt configurableVariable=[Select MasterLabel,APTS_Finalized_Date__c,APTS_Finalized_Status__c from APTS_Configurable_Variables__mdt where masterLabel='FinalizedCart' LIMIT 1]; 
                                                                                                     
        //SOC-7061  
         static boolean isMinIncrGrw = False;            
    //Added by Chirag 12/7/16
    //This method updates Tally on Q/P object
    public static void updateTally (List<Apttus_Config2__ProductConfiguration__c> listNewObjects){
        
        Set<Id> proposalIds = new Set<Id>();
        List<Apttus_Proposal__Proposal__c> updatedProposalsList = new List<Apttus_Proposal__Proposal__c>();
        // Added as part of SOC-3505 by Punitha 
        Map<Id, List<Apttus_Config2__LineItem__c>> lineItemMap = new Map<Id, List<Apttus_Config2__LineItem__c>>();
        
        // SOC-3867 06/07/17
        Map <string,Boolean> lnItemMap = new Map<string,Boolean>();
       
        for(Apttus_Config2__ProductConfiguration__c proposal : listNewObjects){
            proposalIds.add(proposal.Apttus_QPConfig__Proposald__c);
        }
        //SOC-5515 added Pricing model to the query
        List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>([SELECT Id, APTS_Contract_Term__c, APTS_Media_High_Level_Code__c,
                                                                                                APTS_Media_Lower_Level_Code__c, APTS_Group_Primary_Material__c,
                                                                                                APTS_Print_Purchase_Options__c, APTS_Purchase_Options__c, Apttus_Config2__SellingFrequency__c,
                                                                                                APTS_Bridge_Length__c,Apttus_Config2__LineStatus__c, Apttus_Config2__IncentiveCode__c,
                                                                                                Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
                                                                                                APTS_Program_ID__c,Purchase_Option_Bundle_Print__c, APTS_Contract_Term_Number__c, APTS_Bundle__c,APTS_Bridge__c, // Bijeta SOC-6445 May release
                                                                                                APTS_Group__c, Apttus_Config2__ChargeType__c,APTS_Product_Family__c,Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c,Apttus_Config2__LineType__c, APTS_Deal_Type__c,// Bijeta SOC-6607 May release
                                                                                                Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Subscription_Number__c,Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c,Apttus_Config2__ProductId__r.APTS_Cat_L5__c,
                                                                                                Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,Apttus_Config2__ProductId__r.Name,APTS_PRODUCT_CODE__C,APTS_Keep_Terms__c,APTS_is_Primary_in_Bundle__c,APTS_Deal_Number__c,APTS_MLA__c //soc-9312
                                                                                                FROM Apttus_Config2__LineItem__c 
                                                                                                WHERE Apttus_Config2__ConfigurationId__c IN: listNewObjects]);
                                                                                                
        Map <Id,Apttus_Proposal__Proposal__c> proposalMap = new Map<Id,Apttus_Proposal__Proposal__c>([SELECT Id, APTS_Boolean_Short_Term_Trials__c,APTS_Boolean_Windows_Count__c, 
                                                                                                    APTS_Boolean_Non_Bridge_Proflex__c, APTS_Boolean_Count_of_Online__c,APTS_Boolean_Count_of_Software__c,
                                                                                                    APTS_Boolean_Count_of_Print__c, APTS_Boolean_Count_of_Proview__c, APTS_Boolean_Count_of_Print_Ship_ONLY__c,
                                                                                                    APTS_Boolean_Count_of_Print_Fill_Up_ONLY__c, APTS_Boolean_Print_Fill_Up_Enter_Sub__c,
                                                                                                    APTS_Boolean_Print_Fill_Up_Enter_Sub_AP__c, APTS_Boolean_Proview_Entitle_and_Charge__c,
                                                                                                    APTS_Boolean_Count_of_Proview_APP__c, APTS_Boolean_Count_of_Lapsed__c, APTS_Boolean_Count_of_Promotions__c,
                                                                                                    APTS_Boolean_Rutter_Seminars_TRG__c, APTS_Boolean_WestLaw_LegalEdCenter__c,
                                                                                                    APTS_Boolean_Bridge_CPRO__c, APTS_Boolean_CPRO__c, APTS_Boolean_PFLEX_Bridge_CPRO__c,
                                                                                                    APTS_MasterContacts_Collected__c,APTS_IP_Address_Collected__c,//soc-9312
                                                                                                    APTS_Boolean_PFLEX_CPRO__c,APTS_Count_of_NEW_Proposal_Line_Item__c,APTS_Print_Proview_Bundle_Type__c,
                                                                                                    APTS_CPRO_Standalone_Short_Term_Trial__c,APTS_CPRO_PFlex_Short_Term_Trial__c,APTS_Number_of_Non_Bridged_ProFlex_BDL__c,APTS_Number_of_Non_Bridged_Print_BDL__c,APTS_Number_of_Bridged_Print_BDL__c,APTS_Number_of_Bridged_ProFlex_BDL__c,APTS_MLA_Quote__c,APTS_Boolean_Modification_Keep_Terms__c,APTS_Boolean_Mod_Keep_Terms_WCMP__c //SOC-8995
                                                                                                    
                                                                                                    FROM Apttus_Proposal__Proposal__c WHERE Id IN: proposalIds]);
        System.debug('in lineItemList' + lineItemList.size());
        // Added as part of SOC-3505 by Punitha till Line 45
        for(Apttus_Config2__LineItem__c li :lineItemList ) {        
           if(!lineItemMap.isEmpty() && lineItemMap.containsKey(li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c)) {
                lineItemMap.get(li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).add(li);    
      } else {
                lineItemMap.put(li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, new List<Apttus_Config2__LineItem__c> {li});
            }   
            if ((li.APTS_Media_High_Level_Code__c == '07')||(li.APTS_Media_High_Level_Code__c == '21')) {
                    lnItemMap.put(li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c+'True', True);
      } else if (li.Apttus_Config2__LineStatus__c == 'New' && ((li.APTS_Media_High_Level_Code__c == '05') || (li.APTS_Media_High_Level_Code__c == '06') || (li.APTS_Media_High_Level_Code__c == '13'))){
                lnItemMap.put(li.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c+'False', False); } 
        }
     
        
        // initialize the flags
        for(Id id:proposalIds){
            System.debug('in initialize loop_______'); 
            if(proposalMap.containsKey(id)){
    
                proposalMap.get(id).APTS_Boolean_Short_Term_Trials__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Windows_Count__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Non_Bridge_Proflex__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Online__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Software__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Print__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Proview__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Print_Ship_ONLY__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Print_Fill_Up_ONLY__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Print_Fill_Up_Enter_Sub__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Print_Fill_Up_Enter_Sub_AP__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Proview_Entitle_and_Charge__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Proview_APP__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Lapsed__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Promotions__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Bridge_Only__c = FALSE;
                proposalMap.get(id).APTS_Boolean_WestLaw_LegalEdCenter__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Rutter_Seminars_TRG__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Count_of_Proview_One_Time__c = FALSE;
                proposalMap.get(id).APTS_Boolean_Bridge_CPRO__c = FALSE;
                proposalMap.get(id).APTS_Boolean_CPRO__c = FALSE;
                proposalMap.get(id).APTS_Print_Proview_Bundle_Type__c ='';
                proposalMap.get(id).APTS_Boolean_PFLEX_Bridge_CPRO__c = FALSE;
                proposalMap.get(id).APTS_Boolean_PFLEX_CPRO__c = FALSE;
                proposalMap.get(id).APTS_CPRO_Standalone_Short_Term_Trial__c = FALSE; //SOC-8995            
                proposalMap.get(id).APTS_CPRO_PFlex_Short_Term_Trial__c = FALSE; //SOC-8995
                proposalMap.get(id).APTS_MasterContacts_Collected__c = FALSE;//soc-9312
                proposalMap.get(id).APTS_IP_Address_Collected__c = FALSE;//soc-9312
                // Added as part of SOC-3505 by Punitha till Line 105
                proposalMap.get(id).APTS_Count_of_NEW_Proposal_Line_Item__c = FALSE;
                
                boolean isNew = False;
                boolean isAmend = False;
                string liGroup = '';
                integer countofisNew = 0;
                boolean isaProflex;
                if(lineitemMap != Null && lineitemMap.keyset().size() > 0){
                    for(Apttus_Config2__LineItem__c lItem : lineItemMap.get(id)){  
                        isaProflex = false;
                        if(lItem.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(lItem.Apttus_Config2__ProductId__r.ProductCode)){
                            isaProflex = true;                         
                        }      
                        //SOC-3867 6/7/17
                        if(!lnItemMap.isEmpty() || !lnItemMap.containsKey(lItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c+'True') || lnItemMap.containsKey(lItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c+'False')){           
                        
                        if(String.isEmpty(lItem.APTS_Group__c) && lItem.Apttus_Config2__LineStatus__c == 'New'){
                            proposalMap.get(lItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Count_of_NEW_Proposal_Line_Item__c = TRUE;
                            countofisNew += 1;                
              } else if (!String.isEmpty(lItem.APTS_Group__c) && lItem.Apttus_Config2__LineStatus__c == 'Amended' && isaProflex == true ) {
                             proposalMap.get(lItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Count_of_NEW_Proposal_Line_Item__c = FALSE;                
                             isNew = False;
                             isAmend = True;
                             liGroup = lItem.APTS_Group__c;               
                        }  
                        if(!String.isEmpty(lItem.APTS_Group__c) && lItem.Apttus_Config2__LineStatus__c == 'New' && isaProflex == true){
                            if(string.isEmpty(liGroup)) {
                                isNew = True;
                                countofisNew += 1;                      
                                liGroup = lItem.APTS_Group__c;               
                } else If(liGroup == lItem.APTS_Group__c && !isAmend){
                                isNew = True;
                                countofisNew += 1;}
                            else If(liGroup != lItem.APTS_Group__c) {
                                liGroup = lItem.APTS_Group__c;               
                                isNew = True;
                                countofisNew += 1;
                            }
                            else{
                                isNew = False; }
                        }
                        
                      }
                       /* else If(!String.isEmpty(lItem.APTS_Group__c) && lItem.Apttus_Config2__LineStatus__c != 'New' && liGroup == lItem.APTS_Group__c))
                            isNew = False; */                
                        
                    }
                }
                system.debug('RK --> Block5 isNew ='+isNew+'isAmend ='+isAmend+'liGroup ='+liGroup+'countofisNew ='+countofisNew+'isaProflex ='+isaProflex);
                if(countofisNew > 0){
                    proposalMap.get(id).APTS_Count_of_NEW_Proposal_Line_Item__c = TRUE; }      
           }                  
        }
        
        for(Apttus_Config2__LineItem__c item : lineItemList){
            System.debug('in loop_______'); 
          //SOC-6794 Added by Sakshi May'18 release for SCS OC  
            if(proposalMap.containsKey(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c)){

                if(item.APTS_Contract_Term__c == 'Short Term Trial' && item.Apttus_Config2__LineStatus__c == 'New'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Short_Term_Trials__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '06' && item.APTS_Media_Lower_Level_Code__c == 'AR'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Windows_Count__c = TRUE;
                }
                
                if((item.APTS_Media_High_Level_Code__c == '06' || item.APTS_Media_High_Level_Code__c == '13') && item.APTS_Media_Lower_Level_Code__c != 'AR' && (item.APTS_Bridge_Length__c > 0 && item.APTS_Contract_Term__c == 'Short Term Trial')){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Non_Bridge_Proflex__c = TRUE;
                }
                //Adding Product Family condition as part of SOC-3336 03/20/2017  //SOC-4840 Adding 05,13 MHL and Removing Prod Family 
                if((item.APTS_Media_High_Level_Code__c == '06'|| item.APTS_Media_High_Level_Code__c == '05'|| item.APTS_Media_High_Level_Code__c == '13') && (item.APTS_Group__c  == NULL)){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Online__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '13' && item.APTS_Group__c  == NULL){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Software__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '07' && item.APTS_Group__c  == NULL){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Print__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '21' && item.APTS_Group__c  == NULL){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Proview__c = TRUE;
                }
                //SOC-5515 10-Oct
                if(item.APTS_Media_High_Level_Code__c == '07' && item.APTS_Group__c  == NULL && (item.APTS_Print_Purchase_Options__c == 'Ship ONLY'|| item.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='Print Finished'|| item.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='Print Finished No Service')){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Print_Ship_ONLY__c = TRUE;
                }            
                
                if(item.APTS_Media_High_Level_Code__c == '07' && item.APTS_Group__c  == NULL && item.APTS_Print_Purchase_Options__c == 'Fill-Up'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Print_Fill_Up_ONLY__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '07' && item.APTS_Group__c  == NULL && item.APTS_Print_Purchase_Options__c == 'Fill-Up & Enter Sub'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Print_Fill_Up_Enter_Sub__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '07' && item.APTS_Group__c  == NULL && item.APTS_Print_Purchase_Options__c == 'Fill-Up & Enter Sub APP'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Print_Fill_Up_Enter_Sub_AP__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '21' && item.APTS_Group__c  == NULL && item.APTS_Purchase_Options__c == 'Entitle and Charge'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Proview_Entitle_and_Charge__c = TRUE;
                }
                
                //Added on 03/02
                if(item.APTS_Media_High_Level_Code__c == '21' && item.APTS_Group__c  == NULL && item.APTS_Purchase_Options__c == NULL && item.Apttus_Config2__ChargeType__c == 'Subscription Fee'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Proview_Entitle_and_Charge__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '21' && item.APTS_Group__c  == NULL && item.APTS_Purchase_Options__c == 'APP'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Proview_APP__c = TRUE;
                }
                
                if(item.Apttus_Config2__LineStatus__c == 'Cancelled'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Lapsed__c = TRUE;
                }
                
                if(item.Apttus_Config2__IncentiveCode__c != NULL){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Promotions__c = TRUE;
                }
                
                if(item.APTS_Bridge_Length__c > 0 && item.APTS_Contract_Term__c != 'Short Term Trial'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Bridge_Only__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '05' && item.APTS_Media_Lower_Level_Code__c == 'E1'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_WestLaw_LegalEdCenter__c = TRUE;
                }
                //Removing media lower level 38 SOC-3886
                if(item.APTS_Media_High_Level_Code__c == '08'){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Rutter_Seminars_TRG__c = TRUE;
                }
                
                if(item.APTS_Media_High_Level_Code__c == '21' && item.APTS_Group__c  == NULL && item.Apttus_Config2__SellingFrequency__c == 'One Time' && item.Apttus_Config2__ChargeType__c != 'Subscription Fee' ){
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Count_of_Proview_One_Time__c = TRUE;
                }
                
                //soc-9686 changes added
                if(item.APTS_Program_ID__c == 'CPRO' && item.APTS_Bridge_Length__c > 0 && item.APTS_Contract_Term_Number__c  > 0 && item.APTS_Group__c == NULL && item.Apttus_Config2__LineType__c=='Product/Service' && item.Apttus_Config2__LineStatus__c != 'Cancelled'){// Bijeta SOC-6607 May release
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_Bridge_CPRO__c = TRUE;
                }
                 //soc-9686 changes added
                if(item.APTS_Program_ID__c == 'CPRO' && item.APTS_Bridge_Length__c == 0 && item.APTS_Group__c == NULL && item.Apttus_Config2__LineType__c=='Product/Service' && item.Apttus_Config2__LineStatus__c != 'Cancelled'){ // Bijeta SOC-6607 May release
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_CPRO__c = TRUE;
                }
                 //soc-9686 changes added
                if(item.APTS_Program_ID__c == 'CPRO' && item.APTS_Bridge_Length__c > 0 && item.APTS_Contract_Term_Number__c  > 0 && item.APTS_Group__c != NULL && item.Apttus_Config2__LineType__c=='Product/Service' && item.Apttus_Config2__LineStatus__c != 'Cancelled'){ // Bijeta SOC-6607 May release
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_PFLEX_Bridge_CPRO__c = TRUE;
                }
                 //soc-9686 changes added
                if(item.APTS_Program_ID__c == 'CPRO' && item.APTS_Bridge_Length__c == 0 && item.APTS_Group__c != NULL && item.Apttus_Config2__LineType__c=='Product/Service' && item.Apttus_Config2__LineStatus__c != 'Cancelled'){// Bijeta SOC-6607 May release
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Boolean_PFLEX_CPRO__c = TRUE;
                }
                //soc-9312 starts
                if(item.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '06' || item.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21' || item.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13'|| item.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='LW'){            
                    proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_MasterContacts_Collected__c = TRUE;
                }
                //GLP-57 - added condition for 21/CQ
                if((!string.isEmpty(item.Apttus_Config2__ProductId__r.Name) && item.Apttus_Config2__ProductId__r.Name.Contains('Patron Access')) 
                || item.Apttus_Config2__ProductId__r.ProductCode == '41727130' 
                || item.Apttus_Config2__ProductId__r.Subscription_Number__c == '41727130' 
                || item.Apttus_Config2__ProductId__r.APTS_Cat_L5__c == 'L5_L1451_FP' 
                || item.Apttus_Config2__ProductId__r.APTS_Cat_L5__c == 'L5_L0064_FP'  
                || (item.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' && item.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='LW') 
                || item.Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c == '076'
                || (item.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='21' && item.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='CQ')){
                     proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_IP_Address_Collected__c = TRUE;
                }
                //GPP
                system.debug('##### mapSummaryGroupToLI'+item.Purchase_Option_Bundle_Print__c);
                if(!string.isEmpty(item.Purchase_Option_Bundle_Print__c)) {
                    if(item.Purchase_Option_Bundle_Print__c =='Ship & Entitle - APP'){
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Print_Proview_Bundle_Type__c= 'Ship& entitle – sub  app';
                    }
                    else if(item.Purchase_Option_Bundle_Print__c=='Ship & Entitle Sub'){
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Print_Proview_Bundle_Type__c= 'Ship&entitle-  sub s&c';
                    }
                    else if(item.Purchase_Option_Bundle_Print__c=='Sub Only APP'){
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Print_Proview_Bundle_Type__c= 'Ship& entitle – sub only app';
                    }
                    else if(item.Purchase_Option_Bundle_Print__c=='Sub Only'){
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Print_Proview_Bundle_Type__c= 'Ship&-entitle  sub only s&c';
                    }
                    else if(item.Purchase_Option_Bundle_Print__c=='Ship & Entitle Only'){
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_Print_Proview_Bundle_Type__c= 'ship& entitle – no sub';
                    }
                }
                //soc-9312 3nds
                 //SOC-8995 starts
                if(item.APTS_Program_ID__c == 'CPRO' && item.Apttus_Config2__LineType__c == 'Product/Service' && item.APTS_Contract_Term__c == 'Short Term Trial'){
                    if(item.APTS_Group__c == null ){  
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_CPRO_Standalone_Short_Term_Trial__c = TRUE;
                    }else if(item.APTS_Group__c != null){
                        proposalMap.get(item.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c).APTS_CPRO_PFlex_Short_Term_Trial__c = TRUE;
                    }   
                } // SOC-8995 ends
               }
        }
         //Added By Poonam Garg code starts here
        if(!Schema.sObjectType.APTS_Configurable_Variables__mdt .isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        Boolean isProflex=false;
        Boolean isBundle=false;
        Boolean hasGroup=false;
        Boolean mla=false;
        Boolean keepTerms=false;
        Boolean wcmpKeepTerms=false;
        Integer bridgedPrintCount;
        Integer nonBridgedPrintCount;
        Integer bridgedProFlexCount;
        Integer nonBridgedProFlexCount;
        List<Apttus_Config2__LineItem__c> mlaRenewUpdateOnLineItems=new List<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__ProductConfiguration__c config : listNewObjects){
            isProflex=false;
            isBundle=false; 
            hasGroup=false;    
            mla=false;
            keepTerms=false;
            wcmpKeepTerms=false;
            bridgedPrintCount=0;
            nonBridgedPrintCount=0;
            bridgedProFlexCount=0;
            nonBridgedProFlexCount=0;
            System.debug('Nandha1');
            for(Apttus_Config2__LineItem__c item : lineItemList){
                System.debug('Nandha2');
                if(item.Apttus_Config2__ConfigurationId__c==config.id && Item.Apttus_Config2__LineStatus__c != 'Cancelled'){
                    System.debug('Nandha3');
                    if(item .APTS_Product_Code__c != null && System.Label.APTS_Proflex_Materials.contains(item.APTS_Product_Code__c)){
                       isProflex=true;
                    }       
                    if(item .APTS_Bundle__c != null){
                       isBundle=true;
                    }
                    if(item .APTS_Group__c != null){
                       hasGroup=true;
                    }
                    if(item.APTS_Group_Primary_Material__c == '40666420' && item.APTS_Bundle__c != null){                           
                        // Print
                        if(item.APTS_Bridge_Length__c > 0){
                            bridgedPrintCount++;
                }
                        else if(item.APTS_Keep_Terms__c == False){ 
                            nonBridgedPrintCount++;
                        }
                    }else if(item.APTS_Bundle__c != null){
                        // Online Software
                        if(item.APTS_Bridge_Length__c > 0){
                            bridgedProFlexCount++;
                        }else{ 
                            nonBridgedProFlexCount++;
                        }
                    }
                    if(item.APTS_is_Primary_in_Bundle__c == true && item.APTS_MLA__c == true){
                        System.debug('Nandha4');
                        mla = true;
                        item.APTS_MLA__c = true;
                        mlaRenewUpdateOnLineItems.add(item);
                    }
                    if(item.APTS_Keep_Terms__c && item.APTS_Bundle__c != null && item.APTS_is_Primary_in_Bundle__c){
                        if(item.APTS_Deal_Number__c == null && item.APTS_Program_ID__c !='WCMP' && item.APTS_Group_Primary_Material__c !='40666420'){
                            keepTerms = true;
                        }
                        if(item.APTS_Deal_Number__c != null && item.APTS_Program_ID__c =='WCMP'){wcmpKeepTerms = true;
                        }
                    }
                }     
             }
             if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null && configurableVariable!=null &&
             (config.Apttus_Config2__FinalizedDate__c <=configurableVariable.APTS_Finalized_Date__c && config.Apttus_Config2__Status__c==configurableVariable.APTS_Finalized_Status__c ) ){
                    proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_HAS_DYNAMIC_BUNDLE__c = false;
                    System.debug(proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_HAS_DYNAMIC_BUNDLE__c );
            }
            else if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null && configurableVariable!=null &&
             (config.Apttus_Config2__FinalizedDate__c >configurableVariable.APTS_Finalized_Date__c && config.Apttus_Config2__Status__c==configurableVariable.APTS_Finalized_Status__c )){
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_HAS_DYNAMIC_BUNDLE__c = true;    
                System.debug(proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_HAS_DYNAMIC_BUNDLE__c );
            } 
            if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null && configurableVariable!=null &&
             (config.Apttus_Config2__FinalizedDate__c >configurableVariable.APTS_Finalized_Date__c && config.Apttus_Config2__Status__c==configurableVariable.APTS_Finalized_Status__c ) && hasGroup && !(isProflex)){
             proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_HAS_DYNAMIC_BUNDLE__c = false;    
                System.debug(proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_HAS_DYNAMIC_BUNDLE__c );
             }
            if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null){
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_Number_of_Non_Bridged_ProFlex_BDL__c = nonBridgedProFlexCount;
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_Number_of_Non_Bridged_Print_BDL__c = nonBridgedPrintCount;
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_Number_of_Bridged_Print_BDL__c = bridgedPrintCount;
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_Number_of_Bridged_ProFlex_BDL__c = bridgedProFlexCount;
            }
            if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null && mla == true){
                System.debug('Nandha5');
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_MLA_Quote__c = true;
            }
            if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null && keepTerms == true){
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_Boolean_Modification_Keep_Terms__c = true;
            }
            if(config!=null && config.Apttus_QPConfig__Proposald__c!=null && proposalMap.get(config.Apttus_QPConfig__Proposald__c)!=null && wcmpKeepTerms == true){
                proposalMap.get(config.Apttus_QPConfig__Proposald__c).APTS_Boolean_Mod_Keep_Terms_WCMP__c = true;
             } 
        }
        // Added By Poonam Garg code ends here
        updatedProposalsList.addAll(proposalMap.values());
        if(mlaRenewUpdateOnLineItems.size() > 0 && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
        update mlaRenewUpdateOnLineItems;}
        
        if(updatedProposalsList.size() > 0 && Schema.sObjectType.Apttus_Proposal__Proposal__c.isUpdateable()){
            update updatedProposalsList;
        }
        
    }
    
    public static void createDynamicBundles(Map<Id, Apttus_Config2__ProductConfiguration__c> mapOldObjects, Map<Id, Apttus_Config2__ProductConfiguration__c> mapNewObjects){
        Set<Id> productConfigIds = new Set<Id>();
        Id proposalId;
        boolean isMLA = false;
        DateTime configDate= configurableVariable!=null && configurableVariable.APTS_Finalized_Date__c!=null ? configurableVariable.APTS_Finalized_Date__c : null;
        DateTime propCreatedDate;
        for(Apttus_Config2__ProductConfiguration__c pc : mapNewObjects.values()){
            if(pc.Apttus_Config2__Status__c == 'Finalized' && mapOldObjects.get(pc.Id).Apttus_Config2__Status__c != 'Finalized'){ // DOC 13542 added by Poonam Garg apts_has_dynamic_bundle__c==false
                productConfigIds.add(pc.Id);
                proposalId = pc.Apttus_QPConfig__Proposald__c;
            }
        }
        if(!productConfigIds.isEmpty()){
            List<APTS_Dynamic_Bundle__c> dbList = new List<APTS_Dynamic_Bundle__c>();
            Set<Id> proposalIds = new Set<Id>();
            
            Integer nonBridgedProFlexCount = 0;
            Integer nonBridgedPrintCount = 0;

            Integer bridgedPrintCount = 0;
            Integer bridgedProFlexCount = 0;
            Boolean keepTerms = false;
            Boolean wcmpKeepTerms = false; //SOC-4220 Added on 26/06/17
            String dealString = '';

            Set<String> usedItems = new Set<String>();
            Set<String> dealNumber = new Set<String>();
            
            //Start: Jinal Bhatt: DOC-7983
            Map<Id, APTS_Group__c> groupMap = new Map<Id, APTS_Group__c>();
            Map<Id, Id> mapSummaryGroupToLI = new Map<Id, Id>(); //Map<Summary Group Id, Proposal Group Id>
            List<Apttus_Config2__SummaryGroup__c> lstSummaryGroup = [SELECT 
                                                                     (SELECT APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c, APTS_Years_2_Plus_Adjustment__c, 
                                                                      APTS_Program_ID__c, APTS_Bridge__c,APTS_Group__c,APTS_Proposal_Group__c, APTS_Group_Primary_Material__c, 
                                                                      APTS_Group_Primary_Material_Name__c, Apttus_Config2__LineStatus__c, APTS_Contract_Term_Number__c, 
                                                                      Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c, APTS_Deal_Number__c , 
                                                                      // Added as part od SOC-3525 - Bridge Discount chages //SOC-7310 Aug 2018
                                                                      Apttus_Config2__NetPrice__c, APTS_Keep_Terms__c, APTS_SAP_MLA_Agreement_Number__c,
                                                                      Apttus_Config2__AdjustmentType__c, Apttus_Config2__AdjustmentAmount__c, APTS_New_Bridge_Discount__c, 
                                                                      APTS_Bridge_Length__c, APTS_Deal_Type__c,Apttus_Config2__BillingFrequency__c,APTS_Product_Code__c
                                                                      FROM Apttus_Config2__LineItems__r),
                                                                     Name, Apttus_Config2__NetPrice__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.createdDate,
                                                                     Apttus_Config2__BaseExtendedPrice__c FROM Apttus_Config2__SummaryGroup__c WHERE Apttus_Config2__ConfigurationId__c IN: productConfigIds 
                                                                     AND Apttus_Config2__LineType__c = 'Group Total'  WITH SECURITY_ENFORCED];  //and Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.createdDate < :configDate
            if (lstSummaryGroup != null && lstSummaryGroup.size() > 0) {
                for (Apttus_Config2__SummaryGroup__c objSummaryGroup : lstSummaryGroup) {
                    if (objSummaryGroup.Apttus_Config2__LineItems__r.size() > 0 
                        && objSummaryGroup.Apttus_Config2__LineItems__r[0] != null 
                        && objSummaryGroup.Apttus_Config2__LineItems__r[0].Id != null 
                        && objSummaryGroup.Apttus_Config2__LineItems__r[0].APTS_Proposal_Group__c != null) {
                            mapSummaryGroupToLI.put(objSummaryGroup.Id, objSummaryGroup.Apttus_Config2__LineItems__r[0].APTS_Proposal_Group__c);
                    }
                }
                
                system.debug('##### mapSummaryGroupToLI'+mapSummaryGroupToLI);
                
                if (mapSummaryGroupToLI != null && mapSummaryGroupToLI.size() > 0) {
                    groupMap = new Map<Id, APTS_Group__c>([SELECT Id, APTS_Existing_Agreement_Total__c,APTS_Online_Incremental__c,APTS_MLA__c,
                                                           APTS_Decentralized__c, APTS_Existing_Agreement_Product_Code__c, APTS_SAP_MLA_Agreement_Number__c, 
                                                           APTS_Group_Name__c FROM APTS_Group__c WHERE Id IN: mapSummaryGroupToLI.values()]);
                }
            
            //}
            //End: DOC-7983
      
            for(Apttus_Config2__SummaryGroup__c tg : lstSummaryGroup) {
                // Apttus_Config2__NetPrice__c, APTS_Keep_Terms__c, APTS_SAP_MLA_Agreement_Number__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__AdjustmentAmount__c, APTS_Bridge_Discount__c, APTS_Bridge_Length__c FROM Apttus_Config2__LineItems__r), Name, Apttus_Config2__NetPrice__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c FROM Apttus_Config2__SummaryGroup__c WHERE Apttus_Config2__ConfigurationId__c IN: productConfigIds AND Apttus_Config2__LineType__c='Group Total']){
               //Integer indexOfColon = tg.Name.indexOf(':');
               Integer indexOfBundle = tg.Name.indexOf('Bundle');
               if(indexOfBundle >= 0){
                    APTS_Dynamic_Bundle__c db = new APTS_Dynamic_Bundle__c();
                    propCreatedDate=tg.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.createdDate;
            
                    if(tg.Apttus_Config2__LineItems__r != null && !tg.Apttus_Config2__LineItems__r.isEmpty()){
                       /* for(Apttus_Config2__LineItem__c lit : tg.Apttus_Config2__LineItems__r ){// added by bijeta as WCMP changes start
                           dealNumber.add(String.valueOf(lit.APTS_Deal_Number__c));
                        }
                        if(!dealNumber.isempty()){
                        for(String s:dealNumber) {
                           dealString += (dealString ==''?'':',')+s;
                        }
                        }
                        db.APTS_Deal_Number__c = dealString  ;*/// added by bijeta as WCMP changes ends
                        Apttus_Config2__LineItem__c li = tg.Apttus_Config2__LineItems__r.get(0);
                        db.Name = li.APTS_Group_Primary_Material_Name__c;
                        db.APTS_Bundle_Primary_Material__c = li.APTS_Group_Primary_Material__c;
                        db.APTS_Group__c = li.APTS_Group__c;
                        db.APTS_UoM__c = 'Each';
                        db.APTS_Quantity__c = 1;
                        db.APTS_Contract_Terms__c = li.APTS_Contract_Term__c;
                        db.APTS_Contract_Number_of_Months__c = li.APTS_Contract_Term_Number__c;
                        db.APTS_Billing_Frequency__c = li.Apttus_Config2__BillingFrequency__c; //DOC-3872 : Added by Nandha
                        db.APTS_YoY_1_Renewal__c = li.APTS_Yr_1_Renewal_Adjustment__c;
                        db.APTS_YoY_2_Plus__c = li.APTS_Years_2_Plus_Adjustment__c;
                         db.APTS_Bridge__c = li.APTS_Bridge__c;// Bijeta SOC-6607 May release
                        //db.APTS_Program_ID__c = li.APTS_Program_ID__c;

                        db.APTS_Keep_Terms__c = li.APTS_Keep_Terms__c; 
                        //SOC-7310 commenting the Deal Number
                       //db.APTS_Deal_Number__c = li.APTS_Deal_Number__c ;//SOC-3878 added by bijeta as WCMP modification 6/8/17
                        db.APTS_Bundle_Adjustment_Amount__c = li.Apttus_Config2__AdjustmentAmount__c;
                        db.APTS_Bundle_Adjustment_Type__c = li.Apttus_Config2__AdjustmentType__c;
                        //Added as part of SOC-3525 - Bridge Discount changes
                        //db.APTS_Bridge_Discount__c = li.APTS_Bridge_Discount__c;
                        if(li.APTS_New_Bridge_Discount__c!= null && string.valueOf(li.APTS_New_Bridge_Discount__c) != ''){
                        db.APTS_Bridge_Discount__c = string.valueOf(li.APTS_New_Bridge_Discount__c.setScale(3));} //SOC-8600
                        db.APTS_Bridge_Length__c = li.APTS_Bridge_Length__c;     
                        
                        //SOC-6607 19/03
                        if(li.APTS_Program_ID__c =='WCMP'){   
                        db.APTS_Program_ID__c = li.APTS_Program_ID__c; 
                        //SOC-7310 commenting the Deal Number
                       //db.APTS_Deal_Number__c = li.APTS_Deal_Number__c ;//SOC-3878 added by bijeta as WCMP modification 6/8/17
                           }
                           
                        String key = li.APTS_Group_Primary_Material__c+'-'+li.APTS_Group__c;
                        if(!usedItems.contains(key)){
                            if(li.APTS_Group_Primary_Material__c == '40666420'){                           
                                // Print
                                if(li.APTS_Bridge_Length__c > 0){
                                    bridgedPrintCount++;}
                                else if (li.APTS_Keep_Terms__c == False){ //SOC-4235 21/07 
                                    nonBridgedPrintCount++;}
                            } else{
                                // Online Software
                                if(li.APTS_Bridge_Length__c > 0){
                                    bridgedProFlexCount++;}
                                else{ 
                                    nonBridgedProFlexCount++;}
                                    
                            }

                            usedItems.add(key);
                        }

           
                    //Start: Jinal Bhatt : DOC-7983
                    if (groupMap.isEmpty()) {
                      continue;
                    }
                    system.debug('##### groupMap'+groupMap);
                    APTS_Group__c gr = new APTS_Group__c();
        
                    if (li != null && li.APTS_Proposal_Group__c != null) {
                      gr = groupMap.get(li.APTS_Proposal_Group__c);
                    }
                    if (gr != null) {
                      if ( gr.APTS_Group_Name__c != null && gr.APTS_Group_Name__c.contains('Online/Software')) {
                        gr.APTS_MLA__c = true;
                      }
        
                      //End: Jinal Bhatt : DOC-7983
                        
                        db.APTS_Existing_Agreement_Total__c = gr.APTS_Existing_Agreement_Total__c;
                        db.APTS_Online_Incremental__c = gr.APTS_Online_Incremental__c;

                        db.APTS_MLA__c = gr.APTS_MLA__c;
                        db.APTS_Decentralized__c = gr.APTS_Decentralized__c;

                        if(db.APTS_Keep_Terms__c && gr.APTS_Existing_Agreement_Product_Code__c != null){
                            db.APTS_Bundle_Primary_Material__c = gr.APTS_Existing_Agreement_Product_Code__c;
                        }
                        //SOC-7310 Aug 2018
                        for(Apttus_Config2__LineItem__c line : tg.Apttus_Config2__LineItems__r){
                            if(line.Apttus_Config2__LineStatus__c =='Amended' && line.APTS_Deal_Type__c =='WCMP'){
                                db.APTS_Deal_Number__c = line.APTS_Deal_Number__c ;
                                }
                                //DOC-12198
                                if(line.APTS_Product_Code__c != null && !System.Label.APTS_Proflex_Materials.contains(line.APTS_Product_Code__c) && line.Apttus_Config2__LineStatus__c =='Amended'){
                                   db.APTS_isBLINotCreated__c =true;
                                }
                        }
                        if(db.APTS_Keep_Terms__c){
                            //SOC-4220 Added on 26/06/17
                            if(db.APTS_Deal_Number__c == null && db.APTS_Program_ID__c !='WCMP' && db.APTS_Bundle_Primary_Material__c !='40666420'){
                            db.APTS_MLA_Agreement_Number__c = gr.APTS_SAP_MLA_Agreement_Number__c;
                            keepTerms = true;
                            }
                            //SOC-4220 Added on 26/06/17
                            if(db.APTS_Deal_Number__c != null && db.APTS_Program_ID__c =='WCMP'){
                             wcmpKeepTerms = true;
                            }
                        }
                        
                        isMLA = !isMLA && gr.APTS_MLA__c ? true : isMLA;
                        System.debug('Artem MLA: '+gr.APTS_MLA__c);
                    }
                  }
                    
                    db.APTS_Net_Price__c = tg.Apttus_Config2__NetPrice__c;
                    db.APTS_Base_Price__c = tg.Apttus_Config2__BaseExtendedPrice__c; //DOC-11343
                    db.APTS_Quote_Proposal__c = tg.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
                    Decimal existingTotal = 0;
                    Decimal newTotal = 0;
                    for(Apttus_Config2__LineItem__c li : tg.Apttus_Config2__LineItems__r){
                        if(li.Apttus_Config2__LineStatus__c == 'New'){
                            newTotal+= li.Apttus_Config2__NetPrice__c;}
                        else{
                            existingTotal+= li.Apttus_Config2__NetPrice__c;}                        
                    }
                    db.APTS_Existing_Subscriptions_Total__c = existingTotal;
                    db.APTS_New_Subscriptions_Total__c = newTotal;
                    proposalIds.add(db.APTS_Quote_Proposal__c);
                    if(db.APTS_isBLINotCreated__c){dbList.add(db);}
                }
            }
            List<APTS_Dynamic_Bundle__c> dbToDelete = new List<APTS_Dynamic_Bundle__c>();
            if( Schema.sObjectType.APTS_Dynamic_Bundle__c.isAccessible()){
                 dbToDelete = [SELECT Id FROM APTS_Dynamic_Bundle__c WHERE APTS_Quote_Proposal__c IN: proposalIds];
            }
            if(!dbToDelete.isEmpty() && Schema.sObjectType.APTS_Dynamic_Bundle__c.isDeletable()){
                delete dbToDelete;}

            if(!dbList.isEmpty() && Schema.sObjectType.APTS_Dynamic_Bundle__c.isCreateable() &&  propCreatedDate< configDate){
                insert dbList;}


            /*List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>([SELECT Id, APTS_Media_High_Level_Code__c, APTS_Group_Primary_Material__c 
                                                                                                FROM Apttus_Config2__LineItem__c 
                                                                                                WHERE Apttus_Config2__ConfigurationId__c IN: productConfigIds]);

            for(Apttus_Config2__LineItem__c li : lineItemList){
                if(li.APTS_Media_High_Level_Code__c != null && li.APTS_Group_Primary_Material__c == null){
                    if(li.APTS_Media_High_Level_Code__c == '06' || li.APTS_Media_High_Level_Code__c == '13'){
                        numberOfStandaloneOnlineSoftware++;
                    } else if(li.APTS_Media_High_Level_Code__c == '07' || li.APTS_Media_High_Level_Code__c == '21'){
                        numberOfStandalonePrintProView++;
                    }
                } 
            }*/
            
            //Apttus_Proposal__Proposal__c proposal = [SELECT id, name, APTS_Number_of_Bridged_ProFlex_BDL__c, APTS_Number_of_Bridged_Print_BDL__c, APTS_Number_of_Non_Bridged_ProFlex_BDL__c, 
            //                                        APTS_Number_of_Non_Bridged_Print_BDL__c, APTS_Boolean_Modification_Keep_Terms__c, APTS_Number_of_Standalone_Onl_Software__c, 
            //                                        APTS_Number_of_Standalone_Print_ProView__c FROM Apttus_Proposal__Proposal__c WHERE Id = :proposalId];
            if(proposalId != null){
                
               List<Apttus_Proposal__Proposal__c> proposal = [SELECT id, name, APTS_Number_of_Bridged_ProFlex_BDL__c, APTS_Number_of_Bridged_Print_BDL__c, APTS_Number_of_Non_Bridged_ProFlex_BDL__c, 
                                                        APTS_Number_of_Non_Bridged_Print_BDL__c, APTS_Boolean_Modification_Keep_Terms__c, APTS_MLA_Quote__c,APTS_Boolean_Mod_Keep_Terms_WCMP__c 
                                                        FROM Apttus_Proposal__Proposal__c WHERE Id = :proposalId and APTS_HAS_DYNAMIC_BUNDLE__c =false];
                if(!proposal.isEmpty()){    
                System.debug('Artem MLA Last: '+isMLA);
                proposal[0].APTS_Number_of_Non_Bridged_ProFlex_BDL__c = nonBridgedProFlexCount;
                proposal[0].APTS_Number_of_Non_Bridged_Print_BDL__c = nonBridgedPrintCount;
    
                proposal[0].APTS_Number_of_Bridged_Print_BDL__c = bridgedPrintCount;
                proposal[0].APTS_Number_of_Bridged_ProFlex_BDL__c = bridgedProFlexCount;
                if(proposal[0].APTS_MLA_Quote__c != true){
                    proposal[0].APTS_MLA_Quote__c = isMLA;
                }
                proposal[0].APTS_Boolean_Modification_Keep_Terms__c = keepTerms;
                proposal[0].APTS_Boolean_Mod_Keep_Terms_WCMP__c =wcmpKeepTerms ; //SOC-4220 Added on 26/06/17
                /*proposal.APTS_Number_of_Standalone_Onl_Software__c = numberOfStandaloneOnlineSoftware;
                proposal.APTS_Number_of_Standalone_Print_ProView__c = numberOfStandalonePrintProView;*/
    
                update proposal;
                }   
        }}
    }
    }
    /*
    public static void updateSignatureBlockFlag(Map<Id, Apttus_Config2__ProductConfiguration__c> mapOldObjects, Map<Id, Apttus_Config2__ProductConfiguration__c> mapNewObjects){
        Set<Id> productConfigIds = new Set<Id>();
        Set<Id> proposalIds = new Set<Id>();
        for(Apttus_Config2__ProductConfiguration__c pc : mapNewObjects.values()){
            if(pc.Apttus_Config2__Status__c == 'Finalized' && mapOldObjects.get(pc.Id).Apttus_Config2__Status__c != 'Finalized') {
                productConfigIds.add(pc.Id);
                proposalIds.add(pc.Apttus_QPConfig__Proposald__c);
            }
        }
        
        List<Apttus_Proposal__Proposal__c> proposals = new List<Apttus_Proposal__Proposal__c>();
        if(!proposalIds.isEmpty()){
            for (Id propId :proposalIds) {
                Apttus_Proposal__Proposal__c p = new Apttus_Proposal__Proposal__c(Id=propId);
                String s = APTS_ProposalUtilities.validateProposalForManualOrderSubmission(propId);
                System.Debug('******validate proposal return val' + s + '**************');
                if (s == 'Checks successful')
                    p.APTS_Signature_Block_Required__c = true;
                else
                    p.APTS_Signature_Block_Required__c = false;
                    
                proposals.add(p);
            }
        }
        
        update proposals;    
    }
    */
    //Author :- ssuri@apttus.com Starts
    public static void prodConfigApproval(List<Apttus_Config2__ProductConfiguration__c> prdConfigList){
        
        boolean ClearProdFam=false;
        String CustCategory='';
        List<APTS_Segment_Threshold__c> segThrsList=new List<APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> SegThresholdMap = new Map<String,APTS_Segment_Threshold__c>(); //DOC-14800
        Map<String,Boolean> SegThresholdCorpMap = new Map<String,Boolean>();
        //changes by Priyanka for SOC-8938                            
         Map<String,Boolean> SegThresholMediumdMap = new Map<String,Boolean>();
        Map<String,Boolean> SegThresholdMapForGovernment = new Map<String,Boolean>();
        
        //SOC-5933/6873 Added by Chirag 3/6/2018
        Map<String,APTS_Segment_Threshold__c> SegThresholdCorMapPROMO = new Map<String,APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> SegThresholdGovMapPROMO = new Map<String,APTS_Segment_Threshold__c>();
        Map<String,APTS_Segment_Threshold__c> SegThreSmallLawMapPROMO = new Map<String,APTS_Segment_Threshold__c>();
        
        //SOC-7061
        List<Apttus_Config2__AdjustmentLineItem__c> promoApplied = new List<Apttus_Config2__AdjustmentLineItem__c>();
        if(APTS_ApprovalRequestTriggerHelper.approvalRequest== false){
        List<Apttus_Config2__LineItem__c> liList =   [Select APTS_Proposal_Business_Unit__c, APTS_Cat_L3__c, APTS_Cat_L2__c, APTS_Product_Family__c, LMS_Profile_Approval__c, APTS_is_Primary_in_Bundle__c, APTS_Group__c, Apttus_Config2__LineStatus__c , Apttus_Config2__NetPrice__c , APTS_media_high_level__c, APTS_Media_High_Level_Code__c, APTS_Media_Lower_Level_Code__c, Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c, APTS_Yr_1_Renewal_Adjustment__c, Apttus_Config2__AssetLineItemId__r.APTS_Deal_Type__c,Apttus_Config2__ConfigurationId__c,(select id,Minimum_Incremental_override__c ,Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c,Approvals_Impacted__c,Bridge_override__c,Apttus_Config2__LineItemId__c,Minimum_YOY_override__c from Apttus_Config2__AdjustmentLineItems__r), Name From Apttus_Config2__LineItem__c  Where Apttus_Config2__ConfigurationId__c IN:prdConfigList ];
        system.debug('Adjustment list'+liList);
        newHoldingsCalc(liList,prdConfigList); //DOC-16541
        for(Apttus_Config2__LineItem__c li :liList){         
            if(li.Apttus_Config2__AdjustmentLineItems__r!=null){
             promoApplied.addAll(li.Apttus_Config2__AdjustmentLineItems__r); }    
             
             }             
         }
        
        if(segmentThresholdList!=null && segmentThresholdList.size()>0){
           segThrsList.addall(segmentThresholdList); 
        }        
        System.debug('segThrsList>>>>>'+segThrsList);
        for(APTS_Segment_Threshold__c seg:segThrsList){
            if(seg.APTS_Minimum_Incremental_Growth__c!=0 && seg.APTS_Minimum_Incremental_Growth__c!=null){
                String myNumber2 = String.ValueOf(seg.APTS_Minimum_Incremental_Growth__c);
                System.debug('myNumber2>>>>'+myNumber2);
                String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
                System.debug('myTruncatedNumber2>>>>'+myTruncatedNumber2);
                Integer d = Integer.valueOf(myTruncatedNumber2);
                System.debug('d>>>>'+d);
                //DOC-14800
                if(seg.APTS_Segment__c=='Small Law' && seg.APTS_Minimum_Incremental_Growth__c!=0 && seg.APTS_Minimum_Incremental_Growth__c!=null){
                        String keysetId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c/*+MinInc*/;
                        SegThresholdMap.put(keysetId,Seg);                    
                }
                 //changes by Priyanka for SOC-8938
        if(seg.APTS_Segment__c=='Medium Law' && seg.APTS_Minimum_Incremental_Growth__c!=0 && seg.APTS_Minimum_Incremental_Growth__c!=null){
                    for(decimal MinInc=0;MinInc<d;MinInc++){
                        String keysetId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c+MinInc;
                        SegThresholMediumdMap.put(keysetId,Seg.APTS_Approval_Required__c);
                    }
                }
                if(seg.APTS_Product_Family__c=='CLEAR' || seg.APTS_Product_Family__c=='PONDERA'){
          ClearProdFam = true;
        } else {ClearProdFam = false;}
                //SOC-8508 changed it to contains Added by Chirag 8/6/2018
                if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Corporate') && seg.APTS_Minimum_Incremental_Growth__c!=0 && seg.APTS_Minimum_Incremental_Growth__c!=null){
                    for(decimal MinInc=0;MinInc<d;MinInc++){
                        String keysetCorpId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c+MinInc+ClearProdFam;
                        SegThresholdCorpMap.put(keysetCorpId,Seg.APTS_Approval_Required__c);
                    }
                }                
                 //SOC-8508 changed it to contains Added by Chirag 8/6/2018
                if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Government') && seg.APTS_Minimum_Incremental_Growth__c!=0 && seg.APTS_Minimum_Incremental_Growth__c!=null){
                    for(decimal MinInc=0;MinInc<d;MinInc++){
                        String keysetGovId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c+MinInc+ClearProdFam;
                        SegThresholdMapForGovernment.put(keysetGovId,Seg.APTS_Approval_Required__c);
                    }
                }
            }
            
            //SOC-5933/6873 Added by Chirag 3/6/2018
            if(seg.APTS_Promo_Minimum_Incremental_Growth__c!=0 && seg.APTS_Promo_Minimum_Incremental_Growth__c!=null){
                String myNumber2 = String.ValueOf(seg.APTS_Promo_Minimum_Incremental_Growth__c);
                System.debug('myNumber2>>>>'+myNumber2);
                String myTruncatedNumber2 = myNumber2.subString(0,myNumber2.indexOf('.')+3);
                System.debug('myTruncatedNumber2>>>>'+myTruncatedNumber2);
                Integer d = Integer.valueOf(myTruncatedNumber2);
                System.debug('d>>>>'+d);
                if(seg.APTS_Segment__c=='Small Law' && seg.APTS_Promo_Minimum_Incremental_Growth__c!=0 && seg.APTS_Promo_Minimum_Incremental_Growth__c!=null){
                    for(decimal MinInc=0;MinInc<d;MinInc++){
                        String keysetId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c+MinInc;
                        SegThreSmallLawMapPROMO.put(keysetId,Seg);
                    }
                }
                if(seg.APTS_Product_Family__c=='CLEAR'){
          ClearProdFam = true;
        } else {ClearProdFam = false;}
                //SOC-8508 changed it to contains Added by Chirag 8/6/2018
                if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Corporate') && seg.APTS_Promo_Minimum_Incremental_Growth__c!=0 && seg.APTS_Promo_Minimum_Incremental_Growth__c!=null){
                    for(decimal MinInc=0;MinInc<d;MinInc++){
                        String keysetCorpId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c+MinInc+ClearProdFam;
                        SegThresholdCorMapPROMO.put(keysetCorpId,Seg);
                    }
                }                
                //SOC-8508 changed it to contains Added by Chirag 8/6/2018                
                if(seg.APTS_Segment__c != NULL && seg.APTS_Segment__c.contains('Government') && seg.APTS_Promo_Minimum_Incremental_Growth__c!=0 && seg.APTS_Promo_Minimum_Incremental_Growth__c!=null){
                    for(decimal MinInc=0;MinInc<d;MinInc++){
                        String keysetGovId=seg.APTS_Segment__c+seg.APTS_Term_in_years__c+seg.APTS_Customer_Category__c+MinInc+ClearProdFam;
                        SegThresholdGovMapPROMO.put(keysetGovId,Seg);
                    }
                }
            }          
        }
        
        System.debug('SegThresholdMap>>>>>'+SegThresholdMap);
        System.debug('SegThresholdCorpMap>>>>>'+SegThresholdCorpMap);
        System.debug('SegThresholdMapForGovernment>>>>>'+SegThresholdMapForGovernment);
        
        
        List<Apttus_Config2__ProductConfiguration__c> newProdConfigList=new List<Apttus_Config2__ProductConfiguration__c>();

        if(!prdConfigList.isEmpty()){
            for(Apttus_Config2__ProductConfiguration__c prdConf:prdConfigList){                
                //Apttus_Config2__ProductConfiguration__c prd_config  = new Apttus_Config2__ProductConfiguration__c(Id = prdConf.Id);//Commented as part of Change 3   

                //Reset ALL the flags to false - Change 3
                prdConf.APTS_Small_Law_Approval_Required_New__c = false;
                prdConf.APTS_Corporate_Approval_Required_New__c = false;
                prdConf.APTS_Government_Approval_Required_New__c = false;
                prdConf.APTS_Incremental_Growth_violated__c = false;
                prdConf.APTS_Canada_Approval_Required_New__c=false;
                //changes by Priyanka for SOC-8938
                prdConf.APTS_Medium_Law_Approval_Required_New__c=false;
                isMinIncrGrw  = false; 
                               
                if(prdConf.APTS_Customer_Category__c!=null){
                    CustCategory = prdConf.APTS_Customer_Category__c;
                } else {CustCategory = '0';}            
                  
        if (prdConf.APTS_Proposal_Business_Unit__c != 'Corp OneOTC US' && prdConf.APTS_Proposal_Business_Unit__c != 'Corp OneOTC UK'
                 && prdConf.APTS_Proposal_Business_Unit__c != 'Canada' && (prdConf.APTS_Proposal_Business_Unit__c != null && !System.Label.Risk_PBUs.contains(prdConf.APTS_Proposal_Business_Unit__c))) {
                
                System.debug('prdConf.APTS_Small_Law_Approval_Required_New__c' + prdConf.APTS_Small_Law_Approval_Required_New__c);                    
                //SOC-7061               
                prodConfigPromo(prdConf,promoApplied);
                system.debug('PRINT promoApplied LIST ******'+promoApplied);
                
                    
                    if(prdConf.APTS_Approval_Segment__c!=null && prdConf.APTS_Incremental_Growth_Formula__c!=null && prdConf.APTS_Rutter_Approval__c!=null && prdConf.APTS_Is_Print_Only_Configuration__c!=null && prdConf.APTS_Exclude_Incremental_Growth__c!=null && prdConf.APTS_Proposal_Business_Unit__c != 'FindLaw'){    //DOC-14663
                        Integer incGrowth = (Integer)prdConf.APTS_Incremental_Growth_Formula__c;
                        // 1. Small Law Checkbox
                        // SOC-5797 Added APTS_Is_Short_Term_Only_Config__c condition - CG 11/14/2017
                        if(prdConf.APTS_Approval_Segment__c == 'Small Law' && prdConf.APTS_Incremental_Growth_Formula__c !=-1 && prdConf.APTS_Rutter_Approval__c == False && prdConf.APTS_Is_Print_Only_Configuration__c == False && prdConf.APTS_Exclude_Incremental_Growth__c == False && prdConf.APTS_Is_Short_Term_Only_Config__c == FALSE){
                            String Condition=prdConf.APTS_Approval_Segment__c+prdConf.APTS_Least_Contract_Term__c+CustCategory/*+incGrowth*/;
                            String Condition1=prdConf.APTS_Approval_Segment__c+prdConf.APTS_Least_Contract_Term__c+CustCategory+incGrowth;
                            System.debug('RK --> SL Condition>>>>>'+Condition+'SL Condition1>>>>>'+Condition1);                            
                            //SOC-5933/6873 Added by Chirag 3/2/2018
                            Boolean Approval;
                            /*if(prdConf.APTS_Number_of_Line_Items_with_Promo_Cod__c == 0 && SegThresholdMap.get(Condition)!= null){
                                Approval = SegThresholdMap.get(Condition).APTS_Approval_Required__c;
                                System.debug('RK --> Approval PC'+Approval);
                            }else{*/
                            System.debug('RK --> Approval PC'+Approval);
                             if (SegThreSmallLawMapPROMO.get(Condition1)!= null){
                                Approval = SegThreSmallLawMapPROMO.get(Condition1).APTS_Approval_Required__c;
                            }//}
                            if(Approval==null && incGrowth<0 && SegThresholdMap.get(Condition)!= null && prdConf.APTS_Number_of_Line_Items_with_Promo_Cod__c == 0){
                                 System.debug('RK --> Inside Approval assign'+SegThresholdMap.get(Condition).APTS_Minimum_Incremental_Growth__c+'RW ='+prdConf.APTS_Renewal_Window__c);
                                if((incGrowth < SegThresholdMap.get(Condition).APTS_Minimum_Incremental_Growth__c) && 
                                (prdConf.APTS_Renewal_Window__c <= SegThresholdMap.get(Condition).APTS_Renewal_Window__c)){
                                    Approval = SegThresholdMap.get(Condition).APTS_Approval_Required__c;    // Added
                                    system.debug('RK --> SL Flag 1= '+Approval);
                                }
                                else if( prdConf.APTS_Renewal_Window__c > SegThresholdMap.get(Condition).APTS_Renewal_Window__c  )
                                    {
                                        Approval = SegThresholdMap.get(Condition).APTS_Approval_Required__c;    // Added
                                        system.debug('RK --> SL Flag 2= '+Approval);
                                    }
                                //Approval = (incGrowth<0) ? true : false; //Change 8
                                //Approval = SegThresholdMap.get(Condition).APTS_Approval_Required__c;  // Added
                            }
                            if(isMinIncrGrw ==False && Approval != null){                           
                            prdConf.APTS_Incremental_Growth_violated__c = Approval;     //Added by Neeharika Upadrasta, 23/Aug/2017
                            System.debug('Approval on small law '+Approval+' Condition>>>>>>>>>>>SL'+Condition+' small law approval'+prdConf.APTS_Small_Law_Approval_Required_New__c+' prdConf.APTS_Incremental_Growth_violated__c'+prdConf.APTS_Incremental_Growth_violated__c);                    
                            //SOC-2828 Added by Chirag 10/18/2017
                            
                            }      
                            system.debug('RK --> ACR ='+prdConf.APTS_Attorney_Count_Reduced__c);                      
                            if(prdConf.APTS_Attorney_Count_Reduced__c == TRUE){
                            system.debug('SLAR ='+prdConf.APTS_Small_Law_Approval_Required_New__c+'IGV = '+prdConf.APTS_Incremental_Growth_violated__c+'DLA ='+prdConf.APTS_Downband_Logic_Applicable__c+'WLAR ='+prdConf.APTS_WLEC_Approval_Required__c);
                                    if(Approval!=null && prdConf.APTS_Small_Law_Approval_Required_New__c != Approval && 
                                    prdConf.APTS_Incremental_Growth_violated__c == TRUE && prdConf.APTS_Downband_Logic_Applicable__c == TRUE && 
                                   /* prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE && */ prdConf.APTS_WLEC_Approval_Required__c == FALSE ){//DOC-14800
                                    prdConf.APTS_Small_Law_Approval_Required_New__c = Approval;
                                    system.debug('RK --> SL Flag 3= '+prdConf.APTS_Small_Law_Approval_Required_New__c);
                                }
                            }else{
                            system.debug('2SLAR ='+prdConf.APTS_Small_Law_Approval_Required_New__c+'IGV = '+prdConf.APTS_Incremental_Growth_violated__c+'DLA ='+prdConf.APTS_Downband_Logic_Applicable__c+'SLDLA = '+prdConf.APTS_Downgrade_Logic_Applicable__c+'WLAR ='+prdConf.APTS_WLEC_Approval_Required__c);
                                if(Approval!=null && prdConf.APTS_Small_Law_Approval_Required_New__c != Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE /*&& prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE*/ && prdConf.APTS_WLEC_Approval_Required__c == FALSE ){//DOC-14800
                                    prdConf.APTS_Small_Law_Approval_Required_New__c = Approval;
                                    system.debug('RK --> SL Flag 4= '+prdConf.APTS_Small_Law_Approval_Required_New__c);
                                }
                            }
                        }
                                     
                //changes by Priyanka for SOC 8938
                if(prdConf.APTS_Approval_Segment__c == 'Medium Law' && prdConf.APTS_Incremental_Growth_Formula__c !=-1 && prdConf.APTS_Rutter_Approval__c == False && prdConf.APTS_Is_Print_Only_Configuration__c == False && prdConf.APTS_Exclude_Incremental_Growth__c == False && prdConf.APTS_Is_Short_Term_Only_Config__c == FALSE && prdConf.APTS_Proposal_Business_Unit__c != 'FindLaw'){    //DOC-14663
                            String Condition=prdConf.APTS_Approval_Segment__c+prdConf.APTS_Least_Contract_Term__c+CustCategory+incGrowth;
                            System.debug('Condition>>>>>'+Condition);
                            
                            Boolean Approval;
                            if(prdConf.APTS_Number_of_Line_Items_with_Promo_Cod__c == 0){
                                Approval = SegThresholMediumdMap.get(Condition);
                            }
                            if(Approval==null){
                                Approval = (incGrowth<0) ? true : false; //Change 8
                            }
                            prdConf.APTS_Incremental_Growth_violated__c = Approval;     //Added by Neeharika Upadrasta, 23/Aug/2017
                            System.debug('Approval on medium law '+Approval+' Condition>>>>>>>>>>>SL'+Condition+' medium law approval'+prdConf.APTS_Medium_Law_Approval_Required_New__c+' prdConf.APTS_Incremental_Growth_violated__c'+prdConf.APTS_Incremental_Growth_violated__c);                    
                            //SOC-2828 Added by Chirag 10/18/2017
                            /*if(Approval!=null && prdConf.APTS_Small_Law_Approval_Required_New__c != Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE && prdConf.APTS_Downband_Logic_Applicable__c == TRUE && prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE && prdConf.APTS_WLEC_Approval_Required__c == FALSE ){
                                prdConf.APTS_Small_Law_Approval_Required_New__c = Approval;
                            }*/
                            
                            //if(prdConf.APTS_Attorney_Count_Reduced__c == TRUE){
                                if(Approval!=null && prdConf.APTS_Medium_Law_Approval_Required_New__c!= Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE && /*prdConf.APTS_Downband_Logic_Applicable__c == TRUE && prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE &&*/ prdConf.APTS_WLEC_Approval_Required__c == FALSE ){
                                    prdConf.APTS_Medium_Law_Approval_Required_New__c= Approval;
                                }
                            /*}else{
                                if(Approval!=null && prdConf.APTS_Medium_Law_Approval_Required_New__c!= Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE && prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE && prdConf.APTS_WLEC_Approval_Required__c == FALSE ){
                                    prdConf.APTS_Medium_Law_Approval_Required_New__c= Approval;
                                }
                            }*/
                        }
                        // 2. Corporate Checkbox
                        // SOC-5797 Added APTS_Is_Short_Term_Only_Config__c condition - CG 11/14/2017
                        if(prdConf.APTS_Approval_Segment__c.Contains('Corporate') && prdConf.APTS_Incremental_Growth_Formula__c !=-1 && prdConf.APTS_Rutter_Approval__c == False && prdConf.APTS_Is_Print_Only_Configuration__c == False && prdConf.APTS_Exclude_Incremental_Growth__c == False && prdConf.APTS_Is_Short_Term_Only_Config__c == FALSE){
                            //SOC-8508 changed Approval Segment to String Added by Chirag 8/28/2018
                            String segment = 'Corporate';
                            String Condition = segment+prdConf.APTS_Least_Contract_Term__c+CustCategory+incGrowth+prdConf.APTS_Use_CLEAR_Approval_Rules_Formula__c;
                            //SOC-5933/6873 Added by Chirag 3/2/2018
                            Boolean Approval;
                            if(prdConf.APTS_Number_of_Line_Items_with_Promo_Cod__c == 0){
                                Approval = SegThresholdCorpMap.get(Condition);
                            }else if (SegThresholdCorMapPROMO.get(Condition) != NULL){
                                Approval = SegThresholdCorMapPROMO.get(Condition).APTS_Approval_Required__c;
                            }
                            if(Approval==null){
                                Approval = (incGrowth<0) ? true : false; //Change 8
                            }
                            System.debug('Approval>>>'+Approval+'Condition>>>>>>>>>>>corp'+Condition);
                                 if(isMinIncrGrw ==False){ 
                            if(Approval!=null && prdConf.APTS_Corporate_Approval_Required_New__c != Approval && prdConf.APTS_Incremental_Growth_violated__c!=Approval && prdConf.APTS_WLEC_Approval_Required__c == FALSE){                                
                                prdConf.APTS_Corporate_Approval_Required_New__c = Approval;
                                prdConf.APTS_Incremental_Growth_violated__c = Approval;//Added by Neeharika Upadrasta, 23/Aug/2017
                                }
                            }
                        }
                        //3. Government Approval Checkbox
                        // SOC-5797 Added APTS_Is_Short_Term_Only_Config__c condition - CG 11/14/2017
                        if(prdConf.APTS_Approval_Segment__c.Contains('Government') && prdConf.APTS_Incremental_Growth_Formula__c !=-1 && prdConf.APTS_Rutter_Approval__c == False && prdConf.APTS_Is_Print_Only_Configuration__c == False && prdConf.APTS_Exclude_Incremental_Growth__c == False && prdConf.APTS_Is_Short_Term_Only_Config__c == FALSE){
                             //SOC-8508 changed Approval Segment to String Added by Chirag 8/28/2018
                            String segment = 'Government';
                            String Condition = segment +prdConf.APTS_Least_Contract_Term__c+CustCategory+incGrowth+prdConf.APTS_Use_CLEAR_Approval_Rules_Formula__c;
                            //SOC-5933/6873 Added by Chirag 3/2/2018
                            Boolean Approval;
                            if(prdConf.APTS_Number_of_Line_Items_with_Promo_Cod__c == 0){
                                Approval = SegThresholdMapForGovernment.get(Condition);
                            }else if (SegThresholdGovMapPROMO.get(Condition) != NULL){
                                Approval = SegThresholdGovMapPROMO.get(Condition).APTS_Approval_Required__c;
                            }
                            if(Approval==null){
                                Approval = (incGrowth<0) ? true : false; //Change 8
                            }
                            if(isMinIncrGrw ==False){                           
                            prdConf.APTS_Incremental_Growth_violated__c = Approval;     //Added by Neeharika Upadrasta, 23/Aug/2017
                            System.debug('Approval>>>'+Approval+'Condition>>>>>>>>>>>Gov'+Condition);
                            //SOC-2828 Added by Chirag 10/18/2017
                            /*if(Approval!=null && prdConf.APTS_Government_Approval_Required_New__c!=Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE && prdConf.APTS_Downband_Logic_Applicable__c == TRUE && prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE && prdConf.APTS_WLEC_Approval_Required__c == FALSE){
                                prdConf.APTS_Government_Approval_Required_New__c = Approval;
                            }*/
                            }
                            if(prdConf.APTS_Attorney_Count_Reduced__c == TRUE){
                                if(Approval!=null && prdConf.APTS_Government_Approval_Required_New__c!=Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE && prdConf.APTS_Downband_Logic_Applicable__c == TRUE && prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE && prdConf.APTS_WLEC_Approval_Required__c == FALSE){
                                    prdConf.APTS_Government_Approval_Required_New__c = Approval;
                                }
                            }else{
                                if(Approval!=null && prdConf.APTS_Government_Approval_Required_New__c!=Approval && prdConf.APTS_Incremental_Growth_violated__c == TRUE && prdConf.APTS_Downgrade_Logic_Applicable__c == TRUE && prdConf.APTS_WLEC_Approval_Required__c == FALSE){
                                    prdConf.APTS_Government_Approval_Required_New__c = Approval;
                                }
                            }
                        }
                    }
                }
                //update newProdConfigList; //Commented as part of Change 3
                               
 
               // Added by Priyanka for DOC-1602
 
               else if((prdConf.APTS_Proposal_Business_Unit__c =='Corp OneOTC US' || prdConf.APTS_Proposal_Business_Unit__c =='Corp OneOTC UK') && prdConf.APTS_Incremental_Growth_Formula__c < -25 && prdConf.APTS_Incremental_Growth_Formula__c!= 0 ){
 
               prdConf.APTS_Corporate_Approval_Required_New__c=true;

               prdConf.APTS_Incremental_Growth_violated__c = true;

                   }
                else if(prdConf.APTS_Proposal_Business_Unit__c != null && System.Label.Risk_PBUs.contains(prdConf.APTS_Proposal_Business_Unit__c) && prdConf.APTS_Incremental_Growth_Formula__c < 0 ){
 
               prdConf.APTS_Corporate_Approval_Required_New__c=true;

               prdConf.APTS_Incremental_Growth_violated__c = true;

                   }
        //DOC-170 added by Priyanka
        else if((prdConf.APTS_Proposal_Business_Unit__c =='Canada' ) && prdConf.APTS_Incremental_Growth_Formula__c < 0 ){
           prdConf.APTS_Canada_Approval_Required_New__c=true;
           prdConf.APTS_Incremental_Growth_violated__c = true;
         }
         system.debug('Incremental Growth GPP---- '+ prdConf.APTS_Incremental_Growth_GLP__c);
          //Start : GLP-14, 747
        system.debug('##### prdConf.APTS_Incremental_Growth_GLP__c'+prdConf.APTS_Incremental_Growth_GLP__c);
        if((prdConf.APTS_Proposal_Business_Unit__c == 'SCS' || prdConf.APTS_Proposal_Business_Unit__c == 'Canada') && prdConf.APTS_Incremental_Growth_GLP__c < -35){
            prdConf.APTS_PrintProview_MinIncrGrowth_Approval__c = true;
        } else if ((prdConf.APTS_Proposal_Business_Unit__c == 'SCS' || prdConf.APTS_Proposal_Business_Unit__c == 'Canada') && prdConf.APTS_Incremental_Growth_GLP__c >= -35) {
            prdConf.APTS_PrintProview_MinIncrGrowth_Approval__c = false;
        } else {
            prdConf.APTS_PrintProview_MinIncrGrowth_Approval__c = false;
        }
        //End - : GLP-14, 747
                }
        }
    }
    //Author :- ssuri@apttus.com ends
         //SOC-7061 
    public static void prodConfigPromo(Apttus_Config2__ProductConfiguration__c prcf , List<Apttus_Config2__AdjustmentLineItem__c> promoApplied ){
        decimal minIncrPromo =0.0;        
        
        for(Apttus_Config2__AdjustmentLineItem__c promo :promoApplied){
        system.debug('PRINT CONFIG ID'+prcf.id);
        system.debug('PRINT PROMO config id'+promo.Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c);
            if(prcf.id ==promo.Apttus_Config2__LineItemId__r.Apttus_Config2__ConfigurationId__c){
                system.debug('INSIDE FIRST IF');
                if(promo.Approvals_Impacted__c !=Null && promo.Approvals_Impacted__c !='' && promo.Approvals_Impacted__c.containsIgnorecase('Minimum Incremental Growth')){
                    if(minIncrPromo ==0){
                        minIncrPromo = promo.Minimum_Incremental_override__c;               
                    }else if(minIncrPromo>promo.Minimum_Incremental_override__c){
                        minIncrPromo =promo.Minimum_Incremental_override__c;
                        
                    }
                    system.debug('minIncrPromo');
                    if(minIncrPromo <= prcf.APTS_Incremental_Growth_Formula__c){
                        isMinIncrGrw =True;
                        system.debug('isMinIncrGrw '+isMinIncrGrw );
                    }
                    
                }
                
            }
            
        } 
        
    }
    @testvisible
    private static void newHoldingsCalc(List<Apttus_Config2__LineItem__c> liList, List<Apttus_Config2__ProductConfiguration__c> prdConfigList){
        
            for(Apttus_Config2__ProductConfiguration__c config : prdConfigList){ 
                decimal totalNewItems=0.0;
                double tmp = 0.0;
                decimal totalAmendedItems = 0.0;
                Integer amendProflexLICount = 0;
                decimal totalRenewedItems =0;
                for(Apttus_Config2__LineItem__c li :liList){
                    
                    if(li.Apttus_Config2__ConfigurationId__c==config.id ){

                        if ((((((li.APTS_media_high_level__c  == 'Software') || (li.APTS_media_high_level__c  == 'Online')) && !(li.APTS_Media_High_Level_Code__c=='13' && li.APTS_Media_Lower_Level_Code__c == null)) || ((li.APTS_media_high_level__c  == 'Online Non-Westlaw') && !(li.APTS_Media_High_Level_Code__c=='05' && li.APTS_Media_Lower_Level_Code__c == null))) ||
                            (li.APTS_Proposal_Business_Unit__c  =='Corp OneOTC UK' || li.APTS_Proposal_Business_Unit__c  =='Corp OneOTC US' || (!(li.APTS_Media_High_Level_Code__c=='13' && li.APTS_Media_Lower_Level_Code__c == null) && !(li.APTS_Media_High_Level_Code__c=='26' && li.APTS_Media_Lower_Level_Code__c == null) && li.APTS_Proposal_Business_Unit__c  != null && (li.APTS_Proposal_Business_Unit__c  =='Canada' || System.Label.Risk_PBUs.contains(li.APTS_Proposal_Business_Unit__c )) )))
                            && (li.Apttus_Config2__NetPrice__c != null))
                        {

                                if ((li.APTS_Proposal_Business_Unit__c != null && System.Label.Risk_PBUs.contains(li.APTS_Proposal_Business_Unit__c)) || ((!String.isBLANK(li.APTS_Cat_L3__c) && li.APTS_Cat_L3__c != System.Label.APTS_Case_Logistix_Product_Family) 
                                    && (!String.isBLANK(li.APTS_Cat_L2__c) && li.APTS_Cat_L2__c != System.Label.APTS_Print_Product_Family) 
                                    && (!String.isBLANK(li.APTS_Cat_L2__c) && li.APTS_Cat_L2__c != System.Label.APTS_Proview_Product_Family) && (li.APTS_Product_Family__c != 'FINDLAW') 
                                    && (!String.isBLANK(li.APTS_Cat_L3__c) && li.APTS_Cat_L3__c != System.Label.APTS_Ediscovery_Product_Family) && (li.LMS_Profile_Approval__c != 'LMS'))) 
                                    {
                                        if ((li.APTS_Group__c== null || (li.APTS_Group__c != null && li.APTS_is_Primary_in_Bundle__c)) && (li.apttus_config2__linestatus__c == 'New' || li.apttus_config2__linestatus__c == 'Amended') && li.Apttus_Config2__NetPrice__c!=null)
                                        {
                                            if((li.APTS_Group__c != null && li.APTS_is_Primary_in_Bundle__c) && li.apttus_config2__linestatus__c == 'Amended' && li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c!=null){
                                                totalAmendedItems += (li.Apttus_Config2__AssetLineItemId__r.Apttus_Config2__NetPrice__c - li.Apttus_Config2__NetPrice__c);
                                                amendProflexLICount += 1;
                                            }
                                            else{
                                            totalNewItems+=li.Apttus_Config2__NetPrice__c;}
                                        }
                                        else if(li.apttus_config2__linestatus__c == 'Renewed') {                     
                                            if (li.APTS_Yr_1_Renewal_Adjustment__c != null) {
                                                totalRenewedItems += (li.Apttus_Config2__NetPrice__c * integer.valueof(li.APTS_Yr_1_Renewal_Adjustment__c)/100);
                                            } else {
                                                totalRenewedItems += li.Apttus_Config2__NetPrice__c;
                                            }
                                         }
                                        system.debug('totalAmendedItems TK-->'+totalAmendedItems +'&'+' amendProflexLICount TK-->'+amendProflexLICount);
                                    }
                        
                                else if((li.APTS_Cat_L3__c!=null && (li.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Ediscovery_Product_Family)
                                        || li.APTS_Cat_L3__c.equalsIgnoreCase(System.Label.APTS_Case_Logistix_Product_Family))) 
                                        &&  (li.LMS_Profile_Approval__c == 'LMS')) {
                                        System.debug('UserProfile ++ LMS' );
                                        if ((li.APTS_Group__c== null || (li.APTS_Group__c != null && li.APTS_is_Primary_in_Bundle__c)) && (li.apttus_config2__linestatus__c == 'New' || li.apttus_config2__linestatus__c == 'Amended') && li.Apttus_Config2__NetPrice__c!=null) {
                                            totalNewItems += li.Apttus_Config2__NetPrice__c;}
                                        else if (li.apttus_config2__linestatus__c == 'Renewed') {
                                                if (li.APTS_Yr_1_Renewal_Adjustment__c != null) {
                                                    totalRenewedItems += (li.Apttus_Config2__NetPrice__c * integer.valueof(li.APTS_Yr_1_Renewal_Adjustment__c)/100);
                                                   
                                                } else {
                                                    totalRenewedItems += li.Apttus_Config2__NetPrice__c;
                                                }
                                                system.debug('totalRenewedItems TK-->'+totalRenewedItems);
                                        }
                                    }
                        }

                        
                    }
                }
                config.APTS_New_Holdings__c = totalNewItems;
                totalNewItems = 0.0;

                system.debug('config.APTS_Current_Holdings__c TK-->'+config.APTS_Current_Holdings__c);
                system.debug('totalAmendedItems TK-->'+totalAmendedItems);
                system.debug('amendProflexLICount TK-->'+amendProflexLICount );
                system.debug('config.APTS_Lapsed_Holdings__c TK-->'+config.APTS_Lapsed_Holdings__c);
                system.debug('config.APTS_Current_Holdings__c TK-->'+config.APTS_Current_Holdings__c);
                if (config.APTS_Current_Holdings__c > 0) {   
                    if(totalAmendedItems != null && totalAmendedItems != 0.0 && amendProflexLICount  > 0){
                    system.debug('Inside GLI block');
                        tmp = 100 * ((0 - config.APTS_Lapsed_Holdings__c - totalAmendedItems) / config.APTS_Current_Holdings__c);               
                    }
                    else{tmp = 100 * ((totalRenewedItems + config.APTS_New_Holdings__c - config.APTS_Lapsed_Holdings__c) / config.APTS_Current_Holdings__c);} // 10/14/2016
                    
                    System.debug('*** tmp  = ' + tmp);
                    
                } else {
                    tmp = 100.0; // based on my conversation with Harish -- 10/14/2016.
                }
                 config.APTS_Incremental_Growth__c = tmp;
            } 
    }       
}