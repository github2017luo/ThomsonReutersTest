public Class checkRecursive{
    public static Boolean emailAlertCheck = true;
    public static boolean beforeUpdateOppotunityRecCheck = false; 
    private static boolean run = true;
    private static boolean runTask = true;
    private static boolean runUser = true;
    private static boolean iscalled = true;
    private static boolean iscalled2 = true;
    public static boolean isOpptyUpdate = true;  
    public static boolean isOLISync =true;
    public static boolean isRenewalQLIInsert = true;
    public static boolean isRenewalOLIInsert = true;
    private static boolean runOpptyBeforeListner = true;
    private static boolean runOpptySyncOnce = true; 
    private static boolean runOpptyLockOnce = true; 
    public static boolean isRenewalQuote = true;
    public static boolean isRenewalOpp = true;
    public static boolean isNotRenewal = true;
    public static boolean isRenewalOLI = true;
    public static boolean isRenewalQLI = true;
    public static boolean isRenwlQLINotUpdt = true;
    public static boolean isAllowChildQuoteDiscard = true;
    public static boolean isQuote = true;
    public static boolean isBPF= true;
    public static boolean isOpptyLIUpdate = true;
    public static boolean isQuoteLI = true;
    public static boolean isBAS = true;
    public static boolean BeforeInsert = true;
    public static boolean AfterInsert = true;
    public static boolean BeforeUpdate = true;
    public static boolean AfterUpdate = true;
    @testvisible
    private static boolean isFirstTime = true;
    // CRM-13693 and CRM-8058 To restric to run VerifyEmailAndPhone Method in Contact trigger whenever LCRMBatchForActiveContactEntitlements is running
    public static boolean runConTrigger = true ;
        public static boolean isACVproductCheck= true;
    public static boolean runAutoPayment_Update_Trgrflaf  = true;
	public static boolean runUpdateProposalFromOrderTrigger  = true; 
    public static boolean runLineItemCalIncrementalMethflag  = true;
    public static boolean propsaltrgr_updatePriceList  = true;
    public static boolean propsaltrgr_updatebilltoshipto  = true;
    public static boolean propsaltrgr_updateOpportunityStage  = true;
    public static boolean propsaltrgr_updateApprovalSegment = true;
    public static boolean propsaltrgr_updateAddressFeilds  = true;
    public static boolean propsaltrgr_createOrderAndAssetLineItems = true;
    public static boolean propsaltrgr_updateTmpOrderConfirmationContact = true;
    public static boolean propsaltrgr_Digital_SecondaryQuoteExpiration = true;
    public static boolean propsaltrgr_DigitalUpdateToProposal = true;
  
  // public static boolean isOppChck = true; //SFD-1189/1205  Enhancement November release
    //public static boolean isCreateCaseOnce = true;
    public static boolean runEvent = true; //added for CRM-7710
    private static boolean runRenewalOpptySyncOnce = true;
    private static boolean runRenewalQuoteSyncOnce = true;
    private static boolean runRenewalQLISyncOnce = true;
    private static boolean runRenewalOLISyncOnce = true;
    public static boolean runCaseUpdateForGPOnce = true;
    public static boolean runQuoteUpdateForGPOnce = true;
    public static boolean runCaseUpdateForGPDaysOnce = true;
    public static boolean lcrmRecursivecheckflag_Account = true;
    public static boolean lcrmRecursivecheckflag_Contact = true;
    public static boolean lcrmRecursivecheckflag_Lead = true;
    public static boolean optycontactrole =true;
    
    public static boolean runinsertcaseteammember = true; //tejas code for metastorm
    
    //added by Saloni for CPQ
    public static boolean runupdatecaseowner = true; 
    public static boolean runsendEmailtoSalesRep = true;
    public static boolean runQuoteRequestCancellationEmail = true;
    
    public static boolean runupdateOppTerritoryId = true;
    //public static boolean runLineItemCalIncrementalMethflagOnce = true;
    public static boolean runsyncOptyTeam = true;//Added for CRM-17836
    
    Public static boolean approvalDashboard  = true; //DOC-6335
    

    @TestVisible private static boolean alreadyRunBeforeUpdateQuote = false;
    @TestVisible private static boolean alreadyRunBeforeUpdateOppLineItem = false;
    
    public static boolean hasAlreadyRunBeforeUpdateQuote() {
      return alreadyRunBeforeUpdateQuote ;
    }
    
    public static void setAlreadyRunBeforeUpdateQuote() {
        alreadyRunBeforeUpdateQuote = true;
    }
    
    public static boolean hasAlreadyRunBeforeUpdateOppLI() {
      return alreadyRunBeforeUpdateOppLineItem ;
    }
    
    public static void setAlreadyRunBeforeUpdateOppLI() {
        alreadyRunBeforeUpdateOppLineItem = true;
    }
 public static boolean runAcvProductLogicOnce(){
        if(isACVproductCheck){
         isACVproductCheck=false;
         return true;
        }else{
            return isACVproductCheck;
        }
    } 
    //CRM-13693 and CRM-8058 To restric to run VerifyEmailAndPhone Method in Contact trigger whenever LCRMBatchForActiveContactEntitlements is running
    public static boolean hasRunVerifyEmailAndPhone (){
        return runConTrigger ;
    }
 public static boolean runAutoPayment_Update_TriggerOnce(){
        if(runAutoPayment_Update_Trgrflaf){
         runAutoPayment_Update_Trgrflaf=false;
         return true;
        }else{
            return runAutoPayment_Update_Trgrflaf;
        }
    }
	//DOC 2996 Added by Poonam Garg to avoid running Method recursively on Order After Insert
    public static boolean runUpdateProposalFromOrderOnce(){
        if(runUpdateProposalFromOrderTrigger  ){
         runUpdateProposalFromOrderTrigger  =false;
         return true;
        }else{
            return runUpdateProposalFromOrderTrigger ;
        }
    }
    //Added by Poonam Garg to avoid Too many SOQL error on APTS_LineItemTriggerHelper
    public static boolean runLineItemCalIncrementalMethflagOnce(){
        if(runLineItemCalIncrementalMethflag  ){
         runLineItemCalIncrementalMethflag  =false;
         return true;
        }else{
            return runLineItemCalIncrementalMethflag;
        }
    } 
    public static boolean runpropsaltrgr_updatePriceListOnce(){
        if(propsaltrgr_updatePriceList){
         propsaltrgr_updatePriceList=false;
         return true;
        }else{
            return propsaltrgr_updatePriceList;
        }
    }
    public static boolean runpropsaltrgr_propsaltrgr_updatebilltoshiptoOnce(){
        if(propsaltrgr_updatebilltoshipto){
         propsaltrgr_updatebilltoshipto=false;
         return true;
        }else{
            return propsaltrgr_updatebilltoshipto;
        }
    } 
    public static boolean runpropsaltrgr_updateOpportunityStageOnce(){
        if(propsaltrgr_updateOpportunityStage){
         propsaltrgr_updateOpportunityStage=false;
         return true;
        }else{
            return propsaltrgr_updateOpportunityStage;
        }
    }   
     public static boolean runpropsaltrgr_updateApprovalSegmentOnce(){
        if(propsaltrgr_updateApprovalSegment){
         propsaltrgr_updateApprovalSegment=false;
         return true;
        }else{
            return propsaltrgr_updateApprovalSegment;
        }
    }     
     public static boolean runpropsaltrgr_updateAddressFeildsOnce(){
        if(propsaltrgr_updateAddressFeilds){
         propsaltrgr_updateAddressFeilds=false;
         return true;
        }else{
            return propsaltrgr_updateAddressFeilds;
        }
    }   
     public static boolean runpropsaltrgr_createOrderAndAssetLineItemsOnce(){
        if(propsaltrgr_createOrderAndAssetLineItems){
         propsaltrgr_createOrderAndAssetLineItems=false;
         return true;
        }else{
            return propsaltrgr_createOrderAndAssetLineItems;
        }
    }   
     public static boolean runpropsaltrgr_updateTmpOrderConfirmationContactOnce(){
        if(propsaltrgr_updateTmpOrderConfirmationContact){
         propsaltrgr_updateTmpOrderConfirmationContact=false;
         return true;
        }else{
            return propsaltrgr_updateTmpOrderConfirmationContact;
        }
    }   
      public static boolean runpropsaltrgr_Digital_SecondaryQuoteExpirationOnce(){
        if(propsaltrgr_Digital_SecondaryQuoteExpiration){
         propsaltrgr_Digital_SecondaryQuoteExpiration=false;
         return true;
        }else{
            return propsaltrgr_Digital_SecondaryQuoteExpiration;
        }
    }   
      public static boolean runpropsaltrgr_DigitalUpdateToProposalOnce(){
        if(propsaltrgr_DigitalUpdateToProposal){
         propsaltrgr_DigitalUpdateToProposal=false;
         return true;
        }else{
            return propsaltrgr_DigitalUpdateToProposal;
        }
    }    
    
    public static boolean runOnce(){
        if(run){
         run=false;
         return true;
        }else{
            return run;
        }
    }    
    public static boolean runTaskTriggerOnce(){
        if(runTask){
             runTask =false;
             return true;
        }else{
            return runTask;
        }
    }   

    //added for CRM-7710
    public static boolean runEventTriggerOnce(){
        if(runEvent){
             runEvent =false;
             return true;
        }else{
            return runEvent;
        }
    }    
    //end for CRM-7710    
    
    
    public static boolean runupdateOppTerritory(){
        if(runupdateOppTerritoryId){
             runupdateOppTerritoryId =false;
             return true;
        }else{
            return runupdateOppTerritoryId;
        }
    }   
    //Start:Added for CRM-17836
    public static boolean runsyncOppTeamToOppTeamClone(){
        if(runsyncOptyTeam){
             runsyncOptyTeam =false;
             return true;
        }else{
            return runsyncOptyTeam;
        }
    } 
    //End
    public static boolean runUserTriggerOnce(){
        if(runUser){
             runUser =false;
             return true;
        }else{
            return runUser ;
        }
    }
    
    public static boolean runQuoteTriggerOnce(){
        if(iscalled){
             iscalled=false;
             return true;
        }else{
            return iscalled;
        }
    }
    
    public static boolean runQuoteTrigger(){
        if(iscalled2){
             iscalled2=false;
             return true;
        }else{
            return iscalled2;
        }
    }
    public static boolean runOpptyBeforeListnerOnce(){
        if(runOpptyBeforeListner){
         runOpptyBeforeListner=false;
         return true;
        }else{
            return runOpptyBeforeListner;
        }
    }   
    public static boolean runOpptySyncOnce(){
        if(runOpptySyncOnce){
         runOpptySyncOnce=false;
         return true;
        }else{
            return runOpptySyncOnce;
        }
    }  
    public static boolean runOpptyLockOnce(){
        if(runOpptyLockOnce){
         runOpptyLockOnce=false;
         return true;
        }else{
            return runOpptyLockOnce;
        }
    } 
    public static boolean runRenewalOpptySyncOnce(){
        if(runRenewalOpptySyncOnce){
         runRenewalOpptySyncOnce=false;
         return true;
        }else{
            return runRenewalOpptySyncOnce;
        }
    }   
    public static boolean runRenewalQuoteSyncOnce(){
        if(runRenewalQuoteSyncOnce){
         runRenewalQuoteSyncOnce=false;
         return true;
        }else{
            return runRenewalQuoteSyncOnce;
        }
    }  
    public static boolean runRenewalQLISyncOnce(){
        if(runRenewalQLISyncOnce){
         runRenewalQLISyncOnce=false;
         return true;
        }else{
            return runRenewalQLISyncOnce;
        }
    } 
    public static boolean runRenewalOLISyncOnce(){
        if(runRenewalOLISyncOnce){
         runRenewalOLISyncOnce=false;
         return true;
        }else{
            return runRenewalOLISyncOnce;
        }
    }
    
    
    public static boolean runoptycontactroleonce(){
        if(optycontactrole){
            optycontactrole=false;
            return true;
        }else 
        {
             return optycontactrole;
        }
    }
    //Merged Code as part of SOC-6701 Start--Zakeer
    public static boolean runFirstTime(){
    if(isFirstTime){
     isFirstTime =false;
     return true;
    }else{
        return isFirstTime ;
    }
    }
    //SOC-6701 End

    public static boolean runBeforeInsertOnce(){
        if(BeforeInsert){
         BeforeInsert=false;
         return true;
        }else{
            return BeforeInsert;
        }
    } 
    public static boolean runAfterInsertOnce(){
        if(AfterInsert){
         AfterInsert=false;
         return true;
        }else{
            return AfterInsert;
        }
    } 
    public static boolean runAfterUpdateOnce(){
        if(AfterUpdate){
         AfterUpdate=false;
         return true;
        }else{
            return AfterUpdate;
        }
    }
    public static boolean runonBeforeUpdateOnce(){
        if(BeforeUpdate){
         BeforeUpdate=false;
         return true;
        }else{
            return BeforeUpdate;
        }
    } 
    public static boolean lCRMRecursivecheck_Account(){
        if(lcrmRecursivecheckflag_Account){
            lcrmRecursivecheckflag_Account=false;
         return true;
        }else{
            return lcrmRecursivecheckflag_Account;
        }
    }
    public static boolean lCRMRecursivecheck_Contact(){
        if(lcrmRecursivecheckflag_Contact){
            lcrmRecursivecheckflag_Contact=false;
         return true;
        }else{
            return lcrmRecursivecheckflag_Contact;
        }
    }
    public static boolean lCRMRecursivecheck_Lead(){
        if(lcrmRecursivecheckflag_Lead){
            lcrmRecursivecheckflag_Lead=false;
         return true;
        }else{
            return lcrmRecursivecheckflag_Lead;
        }
    }
    
    //Start: DOC-6335
    Public static boolean runForApproval(){
        if (approvalDashboard) {
            approvalDashboard=false;
            return true;
        } else {
            return approvalDashboard;
        }
    }
    //End DOC-6335
    
    
}