/**
 * Controller class for LCRMTrainingEventCreation VF page
 * 
 * @description LCRMTrainingEventCreationController
 * @author  Saloni Sukhija
 * @version  2017-06-02
 *
 */
 
public without sharing class LCRMTrainingEventCreationController{
    
    String accountId;
    String contactId;
    String opptyId;
    string strategyId;

    public ApexPages.StandardController oStandardController;
    public Training_Event__c oTrainingEvent;
    
    /**
     * @description fromTab
     * @param boolean
     * @return boolean
     */
    public boolean fromTab{get;set;}
    /**
     * @description fromContact
     * @param boolean
     * @return boolean
     */
    public boolean fromContact{get;set;}
    /**
     * @description fromOpportunity
     * @param boolean
     * @return boolean
     */
    public boolean fromOpportunity{get;set;}
    /**
     * @description fromStrategy
     * @param boolean
     * @return boolean
     */
    public boolean fromStrategy{get;set;}
    
    
    /**
     * @description LCRMTrainingEventCreationController
     * @param oController
     */
    
   
    public LCRMTrainingEventCreationController(ApexPages.StandardController oController){
        oStandardController = oController;
        oTrainingEvent = (Training_Event__c) oController.getRecord();
        fromTab = fromContact = fromOpportunity = fromStrategy = false;
        
        //Added string.escapeSingleQuotes to avoid ApexXSSFromURLParam violation and added null check
         if(ApexPages.currentPage().getParameters().get('AccId') != null)
        {accountId = (String)string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccId'));}
        
       //Added string.escapeSingleQuotes to avoid ApexXSSFromURLParam violation and added null check
        if(ApexPages.currentPage().getParameters().get('ConId') != null)
        {contactId = (String)string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('ConId'));}
        
        //Added string.escapeSingleQuotes to avoid ApexXSSFromURLParam violation and added null check
        if(ApexPages.currentPage().getParameters().get('OppId') != null)
        {opptyId = (String)string.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('OppId'));}
        
        strategyId = System.currentPageReference().getParameters().get('strategyId');
        this.check();
        
      
      
    }
    
    /**
     * @description PageReference
     * @param 
     * @return 
     */
    public PageReference save(){
        PageReference oPage;
        
        try{
             if(Schema.sObjectType.Training_Event__c.isCreateable()){
                insert oTrainingEvent;
                 }
                system.debug(LoggingLevel.DEBUG,'@@@contactId ----->'+contactId );
                system.debug(LoggingLevel.DEBUG,'@@@AccountId ----->'+accountId );
                Boolean s1 = fromContact  && contactId != null;
                Boolean s2 = accountId != null && contactId == null;
                //if( fromContact  && contactId != null){
                if(s1){
                    Training_Event_Contact__c tTECon = new Training_Event_Contact__c();
                    tTECon.Contact_Name__c =contactId;
                    tTECon.Training_Event__c = oTrainingEvent.Id; 
                    if(Schema.sObjectType.Training_Event_Contact__c.isCreateable()){
                        insert tTECon;
                    }
                }
                //else if(accountId != null && contactId == null){
                else if(s2){
                //system.debug('inside account TE');
                    Training_Event_Account__c tTEA = new Training_Event_Account__c();
                    tTEA.Account__c = accountId ;
                    tTEA.Training_Event__c = oTrainingEvent.Id;
                    if(Schema.sObjectType.Training_Event_Account__c.isCreateable()){
                        insert tTEA;
                    //system.debug('inserted Training event Account'+tTEA );
                    }
                } 
                
        }
        catch(Exception e){
             ApexPages.addMessages(e);
             return null;
        }
        
        if(oTrainingEvent.id != null){
            oPage = new PageReference('/'+oTrainingEvent.id);
        }
            
        return oPage;
    }
    
    /**
     * @description PageReference
     * @param 
     * @return 
     */
    public PageReference cancel(){
        PageReference oPage;
        if(strategyId != null){
            oPage = new PageReference('/'+strategyId);
        }
        else if (contactId != null){
            {oPage = new PageReference('/'+contactId);}
        }
        else if(opptyId != null){
            {oPage = new PageReference('/'+opptyId);}
        }
        else if(accountId != null){
            {oPage = new PageReference('/'+accountId);}
        }
        else{
            String retURL = FieldId__c.getOrgDefaults().TrainingEventTabPage__c;
            //Added this to avoid ApexOpenRedirect PMD violation
            if(retURL.startsWith('/')){
            retURL=retURL.replaceFirst('/','');
        }
            oPage = new PageReference('/'+retURL);
            oPage.setRedirect(true);
        }
            
        return oPage;
    }
     /**
     * @description strategyCheck
    
     */
    public void check(){
        Boolean s = strategyId !=null && Schema.sObjectType.SFDC_Strategy__c.isQueryable();
        if(s){
            SFDC_Strategy__c str;
            //if(Schema.sObjectType.SFDC_Strategy__c.isQueryable()){
                 str = [Select Id,Account__c from SFDC_Strategy__c where id =: strategyId];
            //}
            oTrainingEvent.Strategy__c =str.Id;
            accountId = str.Account__c;
            fromStrategy = true;
        }
        Boolean c = contactId != null && Schema.sObjectType.Contact.isQueryable();
        Boolean o =opptyId != null && Schema.sObjectType.Opportunity.isQueryable();
      
       
        
          
            if(c){
                Contact con;
               // if(Schema.sObjectType.Contact.isQueryable()){
                 con =[Select Id,AccountId from Contact where Id=:contactId];
               // }
                fromContact = true;
                oTrainingEvent.LCRM_Primary_Contact__c = contactId;
                accountId=con.AccountId;
            }
            else if(o){
                Opportunity opp;
                //if(Schema.sObjectType.Opportunity.isQueryable()){
                 opp = [SELECT AccountId,OwnerId FROM Opportunity WHERE id = :opptyId];
                //}
                Id owner = opp.OwnerId;
                accountId=opp.AccountId;
                fromOpportunity = true;
                oTrainingEvent.LCRM_Opportunity__c = opptyId;
                oTrainingEvent.LCRM_Created_from_Opportunity__c = true;
                oTrainingEvent.LCRM_Opportunity_Owner_s_Email__c = [SELECT Email FROM User WHERE id = :owner].Email;
            }
            Boolean a =accountId != null && Schema.sObjectType.Account.isQueryable();
            if(a){
                Account acc;
                //if(Schema.sObjectType.Account.isQueryable()){
                 acc = [SELECT BillingStreet,Street_Address_2__c,BillingCity,BillingPostalCode,BillingState,BillingCountry FROM Account WHERE id= :accountId];
               // }
            if(acc != null){
            oTrainingEvent.Account__c = accountId;
                oTrainingEvent.LCRM_Address_1__c = acc.BillingStreet;
                oTrainingEvent.LCRM_Address_2__c = acc.Street_Address_2__c;
                oTrainingEvent.LCRM_City__c = acc.BillingCity;
                oTrainingEvent.LCRM_State__c = acc.BillingState;
                oTrainingEvent.LCRM_Postcode_Zip__c = acc.BillingPostalCode;
                oTrainingEvent.LCRM_Country__c = acc.BillingCountry;
            }
        }
        else{
           fromTab = true; 
        }
        oTrainingEvent.OwnerId = UserInfo.getUserId();

        //Is GLI and Sub-Bu fields   
        List<sobject> sObjectList = new List<sobject>();
        sObjectList.add(oTrainingEvent);
        LCRMGenericComponent.populateSubbu(sObjectList);
        oTrainingEvent.LCRM_Is_GLI__c = LCRMGenericComponent.validateUserBU(oTrainingEvent.LCRM_Sub_Bu__c);

    }
}