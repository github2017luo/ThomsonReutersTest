/**
* Processes Opportunity records after a DML event is processed by the system
*
* @author  Srikanth Kuruva
* @version  2011-07-26

* CHANGE HISTORY
* =========================================================================================================
* Date         Name                       Description
* 2011-07-26   Srikanth Kuruva            updated. New Case needs to be created if 
*                                         Request Inspection Copy is checked.
* 2014-06-24   Srujana                    MCL-500 Added Competitive Info Create method 
*                                         call
* 2016-06-03   TCS Offshore, Kolkata     (BRS_MS7.1.18,BRS_MS7.1.26) Added afterUpdateMasterOpptySyncs
* 2016-07-20   Satyaki                    Added RenewalOpptySync
* 2017-03-31   Karthi                     Optimized the code as per JIRA STORY: PS0-1
* 2020/10/13    LATAM Community User      Commenting code related to Reservation Process - DPS-17684
* ==========================================================================================================
*/
trigger OpportunityAfterEventListener on Opportunity (after delete, after insert, after undelete, after update) {
    
    Boolean blnRenewalChck = false;
    //LTS_5227 : Exclusion framework
    System.debug('LTS_ApplicationAutomationUtility.checkTriggerApplicability()** '+LTS_ApplicationAutomationUtility.checkTriggerApplicability());
    If(LTS_ApplicationAutomationUtility.checkTriggerApplicability()){
        return;
    }
    if(Boolean.valueOf(System.Label.LCRMGLIOpportunityLoadTriggerFlag) == False){//Added for CRM-14346
        if(trigger.new != NULL && !trigger.new.isEmpty()){
            for(Opportunity op : trigger.new){
                if(op.Renewal_Flag__c == true && op.RecordTypeId != NULL &&  RecordtypeIds__c.getInstance('LATAM Renewal Opportunity') != NULL && op.RecordTypeId== RecordtypeIds__c.getInstance('LATAM Renewal Opportunity').recTypeId__c ){
                    blnRenewalChck = true;
                }                   
                else{
                    blnRenewalChck = false;  
                }
                
            }
        }
        List<Opportunity> lstOptys = new List<Opportunity>();
        List<Opportunity> listPipelineOptys = new List<Opportunity>();
        Set<String> setANZSalesOrg = new Set<String>{'LRA','BKRS'};   
            SET<Opportunity> opptySET= new SET<Opportunity>();
        
        //String strProfileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].Name;
        
        List<Opportunity> listOpp_CompInfo = new List<Opportunity>(); // MCL -500
        
        if ((test.isRunningTest() && !Trigger.isBefore && Trigger.old!=null )||     trigger.isDelete){
                List<Opportunity> lstUpdateOpp1 = new List<Opportunity>();            
                for(Opportunity oOpportunity : trigger.old){                
                    if(oOpportunity.Is_Child_Opportunity__c == true){
                        
                        if(stoprecurssion.runonce()){   //Commented as per SFD-1189/1205  Enhancement November release
                            Opportunity opp = new Opportunity(Id = oOpportunity.Id);
                            opp.Amount = -(oOpportunity.Amount);
                            opp.Master_Opportunity__c = oOpportunity.Master_Opportunity__c;
                            //system.debug('***** '+stoprecurssion.runonce()); 
                            lstUpdateOpp1.add(opp);
                        } 
                    }       
                }
                if(!lstUpdateOpp1.isEmpty()){
                    OpportunityTriggerHandler.updateChildOpportunityAmountSubtotalOnParentOppty(lstUpdateOpp1);
                }   
            } 
        
        if (trigger.isInsert || (trigger.isUpdate && OpportunityUtil.syncRevenueAmountsRecCheck == false)){
            OpportunityUtil.syncRevenueAmounts(trigger.newMap.keySet());
            if(trigger.IsUpdate){
                OpportunityUtil.syncRevenueAmountsRecCheck = true;
            }
            list<Opportunity> oppLst = new list<Opportunity>();
            
            for(Opportunity oOpportunity : trigger.new){
                system.debug('oOpportunity.StageName******'+oOpportunity.StageName);
                system.debug('oOpportunity.StageName******'+oOpportunity.StageName);
                system.debug('trigger.isInsert'+trigger.isInsert);    
                system.debug('trigger.Update'+trigger.isUpdate);
                if((trigger.isInsert || (trigger.isUpdate && oOpportunity.StageName != null && oOpportunity.StageName != trigger.oldMap.get(oOpportunity.id).StageName)) && oOpportunity.StageName =='100%'){
                    oppLst.add(oOpportunity);
                    // system.debug('oppLst------>'+oppLst.size());
                }
            }
            //Commenting Below lines of code as part of DPS-17684
            /* if(!oppLst.isEmpty() && OpportunityTriggerHandler.reservationcreated){
                // System.debug('oppLst********'+oppLst);
                OpportunityTriggerHandler.CreateReservation(oppLst);
            } */
            
            List<Opportunity> lstUpdateOpp = new List<Opportunity>();            
            for(Opportunity oOpportunity : trigger.new){
                if(oOpportunity.Is_Child_Opportunity__c == true){
                    
                    //if(stoprecurssion.runonce()){  //Commented as per SFD-1189/1205  Enhancement November release
                    if(OpportunityTriggerHandler.varAmntFlag==false){   
                        Opportunity opp = new Opportunity(Id = oOpportunity.Id);
                        opp.Master_Opportunity__c = oOpportunity.Master_Opportunity__c;
                        opp.Amount = oOpportunity.Amount;
                        // system.debug('***** '+stoprecurssion.runonce()); 
                        // system.debug('%%%% '+oOpportunity.Amount); 
                        // system.debug('%%%% '+oOpportunity.Master_Opportunity__c);
                        lstupdateOpp.add(opp);
                    } 
                }                      
            }
            
            if(!lstUpdateOpp.isEmpty()){
                OpportunityTriggerHandler.updateChildOpportunityAmountSubtotalOnParentOppty(lstUpdateOpp);
                OpportunityTriggerHandler.varAmntFlag=true;
            }
            
            /*if(trigger.isInsert){
if(stoprecurssion.runonce()){
OpportunityTriggerHandler.OppQuoteSync(trigger.oldMap,trigger.newMap);
}
}*/    
            if (trigger.isInsert)
            {
                    List<Opportunity> newOppList = new List<Opportunity> ();
                 for (Opportunity opp:Trigger.new)
                 {
                      newOppList.add(opp);
                 }
                //Lcrm code to insert contact role on opty tejas
                if(checkRecursive.runoptycontactroleonce() && Boolean.valueOf(System.Label.Legal_CRM_Switch) == True){
                    OpportunityTriggerHandler.populatecontactroleonopty(newOppList,null);
                } 
                 LCRMGenericComponent.checkArchiveAccountType(newOppList);
                createCaseforInspectionCopy.createCaseAfterOpportunityInsert(newOppList);
                if(!blnRenewalChck){
                    OpportunityTriggerHandler.createStrategy2Oppty(newOppList);
                }
                if(!blnRenewalChck){
                    OpportunityTriggerHandler.CreateOwnerasTeamMember(newOppList);
                }
                
                for(Opportunity oOpportunity : trigger.new){
                    if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pre-Pipeline Opportunities').recTypeId__c &&
                       setANZSalesOrg.contains(oOpportunity.Opportunity_Owner_s_Sales_Org__c)){
                           lstOptys.add(oOpportunity);
                           
                       }
                    if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c &&
                       setANZSalesOrg.contains(oOpportunity.Opportunity_Owner_s_Sales_Org__c)){
                           listPipelineOptys.add(oOpportunity);
                       }
                    
                    /*******MCL-500*****/
                    /*if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c &&
(oOpportunity.StageName == '95%' || (oOpportunity.StageName== '90%' && strProfileName == 'LatAm User') || 
oOpportunity.StageName == '0%') && !(AppUtil.isEmpty(oOpportunity.Win_Loss__c)) && oOpportunity.Win_Loss__c!='Abandoned' 
&& oOpportunity.Competitor_Name__c!='Not Applicable'){

if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c 
&& (oOpportunity.StageName == '100%' || oOpportunity.StageName == '95%'  
|| (oOpportunity.StageName== '90%' && strProfileName == 'LatAm User') 
||  oOpportunity.StageName == '0%')
&& oOpportunity.Win_Loss__c =='Lost'  
&& oOpportunity.Competitor_Name__c!='No External Competitor / Contract Terms Unknown'
&& oOpportunity.Competitor_Name__c!='Not Applicable'
&& oOpportunity.Competitor_Name__c!='No Provider Selected'
&& oOpportunity.Competitor_Name__c!='Unknown'){                       

listOpp_CompInfo.add(oOpportunity);
}*/
                    
                    if(oOpportunity.Was_There_a_Competitor__c == 'Yes'){
                        listOpp_CompInfo.add(oOpportunity);
                    }
                }
                
                if(!lstOptys.isEmpty()){
                    OpportunityTriggerHandler.CreateCase_ANZ(lstOptys);    
                }
                
                if(!listPipelineOptys.isEmpty()){
                    OpportunityTriggerHandler.CreateCasefromOpty_ANZ(listPipelineOptys);
                }
                
                /*******MCL-500*****/
                if(!listOpp_CompInfo.isEmpty()){
                    if(!blnRenewalChck){
                        OpportunityTriggerHandler.CreateCompetitiveInfo(listOpp_CompInfo,new map<Id,Opportunity>()); 
                    }   
                }
            }
            if (trigger.isUpdate){
                List<opportunity> contactroleoptylist = new list<opportunity>();
                Map<id,opportunity> oldOppMap = new Map<id,opportunity>();
                //Start For Renewals- Satyaki
                // if(checkRecursive.runRenewalOpptySyncOnce()) {
                //System.debug('trigger.oldMap,trigger.newMap'+trigger.oldMap+'/n----'+trigger.newMap);
                if(blnRenewalChck){
                    OpportunityTriggerHandler.RenewalOpptySync(trigger.oldMap,trigger.newMap); 
                    //   }
                }
                //End for Renewals- Satyaki
                createCaseforInspectionCopy.createCaseAfterOpportunityUpdate(trigger.oldMap, trigger.new);
                //  if(checkRecursive.runOpptySyncOnce()){
                //    if(!blnRenewalChck){
                OpportunityTriggerHandler.afterUpdateMasterOpptySyncs(trigger.oldMap,trigger.newMap); // [BRS_MS7.1.18] [BRS_MS7.1.26]
                //  }
                //  }
                if(!blnRenewalChck){
                    OpportunityTriggerHandler.afterUpdateSalesTeam(trigger.new,trigger.old,trigger.oldmap);
                }
                // OpportunityTriggerHandler.CreateReservation(trigger.new); 
                
                for(Opportunity oOpportunity:trigger.new){
                    
                    if((oOpportunity.Key_Contact__c != trigger.oldmap.get(oOpportunity.id).Key_Contact__c && Boolean.valueOf(System.Label.Legal_CRM_Switch) == True) || Test.isRunningTest()){
                        contactroleoptylist.add(oOpportunity);
                        oldOppMap.put(oOpportunity.id,trigger.oldmap.get(oOpportunity.id));
                    }
                    
                    if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pre-Pipeline Opportunities').recTypeId__c &&
                       setANZSalesOrg.contains(oOpportunity.Opportunity_Owner_s_Sales_Org__c)){
                           // System.debug(oOpportunity.Discard_Reason__c + '*****DSCR'+ trigger.oldmap.get(oOpportunity.Id).Discard_Reason__c);
                           if(oOpportunity.Discard_Reason__c!=trigger.oldmap.get(oOpportunity.Id).Discard_Reason__c){
                               lstOptys.add(oOpportunity);
                           }
                       }
                    
                    if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c &&
                       setANZSalesOrg.contains(oOpportunity.Opportunity_Owner_s_Sales_Org__c)){
                           if(oOpportunity.StageName!=trigger.oldmap.get(oOpportunity.Id).StageName
                              || oOpportunity.Win_Loss__c!=trigger.oldmap.get(oOpportunity.Id).Win_Loss__c){
                                  listPipelineOptys.add(oOpportunity);
                              }
                       }
                    
                    //SFD -14
                    string oppStage0prct;
                    if(Test.isRunningTest()){
                        oppStage0prct= '0%';
                    }
                    else{
                        oppStage0prct=LatamGeneral__c.getInstance('Opp Stage 0').Value__c;  
                    }
                    
                    
                    if(oOpportunity.stageName == oppStage0prct && oOpportunity.stageName !=trigger.oldmap.get(oOpportunity.Id).stageName){
                        opptySET.add(oOpportunity);
                    }//ends
                    
                    /*******MCL-500*****/   
                    /* if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c &&
((oOpportunity.StageName!=trigger.oldmap.get(oOpportunity.Id).StageName 
&& (oOpportunity.StageName == '95%' || (oOpportunity.StageName == '90%'&& strProfileName == 'LatAm User') || oOpportunity.StageName=='0%')
&& !(AppUtil.isEmpty(oOpportunity.Win_Loss__c)))
|| (oOpportunity.Win_Loss__c!=trigger.oldmap.get(oOpportunity.Id).Win_Loss__c && !(AppUtil.isEmpty(oOpportunity.Win_Loss__c)))
|| (oOpportunity.Competitor_Name__c!=trigger.oldmap.get(oOpportunity.Id).Competitor_Name__c && !(AppUtil.isEmpty(oOpportunity.Competitor_Name__c)))
|| oOpportunity.Expiration_Date__c!=trigger.oldmap.get(oOpportunity.Id).Expiration_Date__c
|| oOpportunity.Competitor_Price__c!=trigger.oldmap.get(oOpportunity.Id).Competitor_Price__c
|| oOpportunity.Price_Type__c!=trigger.oldmap.get(oOpportunity.Id).Price_Type__c
|| oOpportunity.Competitor_Notes__c!= trigger.oldmap.get(oOpportunity.Id).Competitor_Notes__c)

)


if(oOpportunity.RecordTypeId == RecordtypeIds__c.getValues('Pipeline Opportunities').recTypeId__c 
&& ((oOpportunity.StageName!=trigger.oldmap.get(oOpportunity.Id).StageName 
&& (oOpportunity.StageName == '100%' 
|| oOpportunity.StageName == '95%' 
|| (oOpportunity.StageName == '90%'&& strProfileName == 'LatAm User') 
|| oOpportunity.StageName=='0%')
)
|| oOpportunity.Win_Loss__c!=trigger.oldmap.get(oOpportunity.Id).Win_Loss__c 
|| (oOpportunity.Competitor_Name__c!=trigger.oldmap.get(oOpportunity.Id).Competitor_Name__c && !(AppUtil.isEmpty(oOpportunity.Competitor_Name__c)))
|| oOpportunity.Expiration_Date__c!=trigger.oldmap.get(oOpportunity.Id).Expiration_Date__c
|| oOpportunity.Competitor_Price__c!=trigger.oldmap.get(oOpportunity.Id).Competitor_Price__c
|| oOpportunity.Price_Type__c!=trigger.oldmap.get(oOpportunity.Id).Price_Type__c
|| oOpportunity.Competitor_Notes__c!= trigger.oldmap.get(oOpportunity.Id).Competitor_Notes__c
) && oOpportunity.Competitor_Name__c!='No External Competitor / Contract Terms Unknown'
&& oOpportunity.Competitor_Name__c!='Not Applicable' && oOpportunity.Win_Loss__c=='Lost'
&& oOpportunity.Competitor_Name__c!='No Provider Selected'
&& oOpportunity.Competitor_Name__c!='Unknown'

)
{
listOpp_CompInfo.add(oOpportunity);

}*/
                    
                    //MCL-1863 : Included Name__c field in the below logic
                    if(oOpportunity.Was_There_a_Competitor__c !=trigger.oldmap.get(oOpportunity.Id).Was_There_a_Competitor__c ||
                       oOpportunity.Competitor_Name__c !=trigger.oldmap.get(oOpportunity.Id).Competitor_Name__c ||
                       oOpportunity.Expiration_Date__c !=trigger.oldmap.get(oOpportunity.Id).Expiration_Date__c ||
                       oOpportunity.Competitor_Price__c !=trigger.oldmap.get(oOpportunity.Id).Competitor_Price__c ||
                       oOpportunity.Price_Type__c !=trigger.oldmap.get(oOpportunity.Id).Price_Type__c ||
                       oOpportunity.Name__c !=trigger.oldmap.get(oOpportunity.Id).Name__c ||
                       oOpportunity.Competitor_Notes__c !=trigger.oldmap.get(oOpportunity.Id).Competitor_Notes__c 
                      )
                    {
                        listOpp_CompInfo.add(oOpportunity);
                    }
                }
                
                if(!lstOptys.isEmpty() && OpportunityTriggerHandler.bCaseCreateFlg == true){
                    OpportunityTriggerHandler.CreateCase_ANZ(lstOptys);    
                }
                
                if(!listPipelineOptys.isEmpty() && OpportunityTriggerHandler.bCaseCreateFlg == true){
                    OpportunityTriggerHandler.CreateCasefromOpty_ANZ(listPipelineOptys);
                }
                /*******MCL-500*****/
                if(!listOpp_CompInfo.isEmpty()){
                    if(!blnRenewalChck){
                        OpportunityTriggerHandler.CreateCompetitiveInfo(listOpp_CompInfo,trigger.oldMap);    
                    }
                }
                
                //SFD -44            
                if(!opptySET.isEmpty()){   
                    if(checkRecursive.isAllowChildQuoteDiscard){
                        OpportunityTriggerHandler.updateChildQuotesToDiscarded(opptySET);
                    }
                }//Ends
                
                //SFD-342
                //To update Oppty Quotes Account Lookup with opportunity Account
                SET<Id> updOpptySet= new SET<Id>();
                Map<Id,Id> oppIdAccntIdMap= new Map<Id,Id>();
                for(Opportunity oOpportunity : trigger.new){
                    
                    if(trigger.isUpdate && oOpportunity.AccountId != null && oOpportunity.AccountId != trigger.oldMap.get(oOpportunity.id).AccountId){
                        updOpptySet.add(oOpportunity.Id);
                        oppIdAccntIdMap.put(oOpportunity.Id,oOpportunity.AccountId);
                        // system.debug('updOpptySet------>'+updOpptySet);   
                    }
                }
                // system.debug('***oppIdAccntIdMap:::' +oppIdAccntIdMap);
                if(!updOpptySet.isEmpty()){
                    OpportunityTriggerHandler.updateAccountLookUPOfChildQuotes(updOpptySet,oppIdAccntIdMap); 
                }                   
                
                if(!contactroleoptylist.isEmpty() && checkRecursive.runoptycontactroleonce() && Boolean.valueOf(System.Label.Legal_CRM_Switch) == True)//tejas code
                {    OpportunityTriggerHandler.populatecontactroleonopty(contactroleoptylist,oldOppMap); //tejas code commented    }
                 
                 if(stoprecurssion.runonce() && !blnRenewalChck){
                     OpportunityTriggerHandler.OppQuoteSync(trigger.oldMap,trigger.newMap);
                 }                                 
                }
            }
            system.debug('Delete Opp:'+trigger.isDelete + 'flag :'+ stoprecurssion.flag );
            /*if ((test.isRunningTest() && !Trigger.isBefore && Trigger.old!=null )||     trigger.isDelete){
                List<Opportunity> lstUpdateOpp1 = new List<Opportunity>();            
                for(Opportunity oOpportunity : trigger.old){                
                    if(oOpportunity.Is_Child_Opportunity__c == true){
                        
                        if(stoprecurssion.runonce()){   //Commented as per SFD-1189/1205  Enhancement November release
                            Opportunity opp = new Opportunity(Id = oOpportunity.Id);
                            opp.Amount = -(oOpportunity.Amount);
                            opp.Master_Opportunity__c = oOpportunity.Master_Opportunity__c;
                            //system.debug('***** '+stoprecurssion.runonce()); 
                            lstUpdateOpp1.add(opp);
                        } 
                    }       
                }
                if(!lstUpdateOpp1.isEmpty()){
                    OpportunityTriggerHandler.updateChildOpportunityAmountSubtotalOnParentOppty(lstUpdateOpp1);
                }   
            } */
            
            if(blnRenewalChck){          
                if(trigger.isAfter && trigger.isUpdate){
                    // system.debug('*******calling method');
                    OpportunityTriggerHandler.businessUnitUpdate(trigger.newMap, trigger.oldMap);     
                }
            }
            //Start: added for CRM-17639
            if(trigger.isUpdate){
                List<Id> optyidlist = new List<Id>();
                List<OpportunityTeamMember> optyTeamlist = new List<OpportunityTeamMember>();
                
                for(Opportunity oOpportunity:trigger.new){  
                    System.debug('new:---'+oOpportunity.CloseDate);
                    System.debug('old---'+trigger.oldmap.get(oOpportunity.id).CloseDate + oOpportunity.Is_GLI__c);
                    if(oOpportunity.CloseDate != trigger.oldmap.get(oOpportunity.id).CloseDate && oOpportunity.Is_GLI__c == true ){
                        optyidList.add(oOpportunity.id);
                        
                    }
                }
                
                if(!optyidList.isEmpty()){
                    
                    if(Schema.sObjectType.OpportunityTeamMember.isAccessible()){
                        optyTeamlist = [Select UserId,User.UserRole.ParentRoleId,OpportunityId,Opportunity.Closedate,User_Quota__c ,Manager_Quota__c  from OpportunityTeamMember  where OpportunityId IN : optyidList];
                        
                        
                        if(!optyTeamlist.isEmpty()){
                            OptyTeamMemberTriggerHandler.SyncUserQuota(optyTeamlist,true);
                        }}
                }
            }
            //End: CRM-17639
            
            //Start : Added for DPS- 12388
            if(Trigger.isAfter && Trigger.isInsert){
                
                if(!LCRMGenericComponent.StrikeIronCheckActive() && LCRMGenericComponent.isLotusUser() && UserInfo.getUIThemeDisplayed() == Label.Theme ) 
                {
                    LotusOpptyExecutionAfterLeadConversion.addOpportunityMemberAfterLeadConversion(trigger.new);
                }
            }
            //End of DPS 12388
            
            //Start : Added for DPS- 16055
            if(Boolean.valueOf(System.Label.Lcrm_disable_opportunityquotesync) == False){
                if(Trigger.isAfter && Trigger.isUpdate){  
                    if(!LCRMGenericComponent.StrikeIronCheckActive())
                    {
                        System.debug('invokeOnce in trigger--'+LcrmOpportunityQuoteSync.invokeOnce);
                        if (Limits.getQueueableJobs() < Limits.getLimitQueueableJobs() && LcrmOpportunityQuoteSync.invokeOnce == false && 
                            !System.isQueueable() && !System.isFuture() && Trigger.isExecuting) {
                                LcrmOpportunityQuoteSync.invokeOnce=true;    
                                System.enqueueJob(new LcrmOpportunityQuoteSync(Trigger.New, Trigger.oldMap, Trigger.newMap));
                            }   
                    }
                }}
            //End of DPS- 16055
            
        }
        
        //Start : Added as part of DPS-16573
        if(Trigger.isAfter && Trigger.isUpdate && trigger.new[0].StageName == 'Contract Signed' && trigger.new[0].Is_GLI__c == true && !LCRMGenericComponent.StrikeIronCheckActive()){ 
            /*String userSubbu = LCRMGenericComponent.getUserBU();
if(LCRMGenericComponent.isLotusUser() && !LCRMGenericComponent.StrikeIronCheckActive()){
LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(trigger.new[0].Id);
}else if(String.isNotBlank(userSubbu) && LCRMGenericComponent.validateUserBU(userSubbu) && !LCRMGenericComponent.StrikeIronCheckActive()){
LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(trigger.new[0].Id);
}*/
            LOTUS_NewCaseFromOpportunityController.CreateProjectInitiationCase(trigger.new[0].Id);
        }
        //End : Added as part of DPS-16573
    }
}