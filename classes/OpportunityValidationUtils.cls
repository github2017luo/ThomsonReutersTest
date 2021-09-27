/*
======================================================================================================================
CLASS NAME:    OpportunityValidationUtils
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-15        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public without sharing class OpportunityValidationUtils
{
    public final opportunity opp{get;set;}
    private boolean isWarning;
    private Apexpages.StandardController controller;
    private string strSalesOrg;
    private boolean  showWarning;   
    public OpportunityValidationUtils(ApexPages.StandardController stdController) {
    if(!test.isRunningTest()){
        stdController.addFields(new list<string>{'validation_Notice__c'});
     }
        this.controller= stdController;
        this.opp= (Opportunity)stdController.getRecord();        
        strSalesOrg = [Select sales_Org__c  From User Where Id = :UserInfo.getUserId() Limit 1].sales_Org__c;           
        //Reading sales rogs from custom setting
        string strSalesOrgs;
        if(!Test.IsRunningTest()){
            strSalesOrgs= LatAmGeneral__c.getInstance('SalesOrgMCShowWarning').Value__C;
        }else
            strSalesOrgs = 'LLEY';
        List<string> salesOrgsLst=new  List<string>();
        SET<string> salesOrgSet= new SET<string>();
        if(strSalesOrgs != ''){
            salesOrgsLst= strSalesOrgs.split(','); 
            salesOrgSet.addAll(salesOrgsLst);
            if(salesOrgSet.contains(strSalesOrg)){
                showWarning = true;
            } else
                showWarning = false;  
        }
    }
    public void validatesub()
    {
        // To check if User has Edit access on Opportunity to stop saving Opportunity to avoid error if no edit access on Opportunity View
        UserRecordAccess ura = [select RecordId, HasEditAccess from UserRecordAccess where UserId = :UserInfo.getUserId() and RecordId = :this.opp.id];
        if(opp!= null && opp.Expiration_Date__c!= null && opp.Expected_Revenue_Date__c!= null && showWarning  ){
            try{
                Decimal noOfMonths;
                integer noOfDays;  
                Integer numberOfDays = Date.daysInMonth(opp.Expiration_Date__c.year(), opp.Expiration_Date__c.month());
/*system.debug('***numberOfDays' +numberOfDays);-- commented to reduce character for s2e optimization */
                Integer lastDayOfMonth = Integer.ValueOf(DateTime.newInstance(opp.Expiration_Date__c.year(), opp.Expiration_Date__c.month(), numberOfDays).format('DD'));            
                Integer startDay= opp.Expected_Revenue_Date__c.Day();
                Integer EndDay= opp.Expiration_Date__c.Day();
/*system.debug('***startDay EndDay lastDayOfMonth:: ' + startDay +':' + EndDay+ ':' + lastDayOfMonth);-- commented to reduce character for s2e optimization */
                if(opp.Expected_Revenue_Date__c < opp.Expiration_Date__c){
                    if(startDay == 1 && EndDay == numberOfDays){
                        isWarning = false;
                    }
                    else if(startDay != 1 && EndDay == startDay - 1){
                        isWarning = false;    
                    }
                    else
                        isWarning = true;     
/*system.debug('***noOfMonths' +noOfMonths);-- commented to reduce character for s2e optimization */
                    if(isWarning)
                    {
/*system.debug('***noOfMonths' +noOfMonths);-- commented to reduce character for s2e optimization */
                        if(ura.HasEditAccess){
                            this.Opp.Validation_Notice__c =Label.LatAm_Subscription_Term_Validation; //this.controller.Save();
                        }
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING,opp.Validation_Notice__c));
                    }
                    else{
                        if(ura.HasEditAccess){
                            this.Opp.Validation_Notice__c =''; //this.controller.Save();
                        }
                    }
                }
                else{
                    isWarning = true;
                    if(ura.HasEditAccess){
                        this.Opp.Validation_Notice__c =Label.LatAm_Subscription_Term_Validation;  //this.controller.Save();
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING,opp.Validation_Notice__c));
                }
            }catch(Exception ex){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ex.getMessage()));
            }
        }
    }
}