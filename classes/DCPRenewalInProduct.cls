/** 
* @description : Webservice to return related details based on SAP AccountNum
*/
@RestResource(urlMapping = '/dcpRenewalsInProduct')
global with sharing class DCPRenewalInProduct{

    private static Final string ACCOUNTNOTFOUND = 'Could not find any account for the SAP account number provided';
    private static Final string OPPORTUNITYNOTFOUND = 'Could not find any opportunity for the SAP account number provided';
    private static Final string FILTEREDOPPNOTFOUND = 'Could not find any filtered opty for the SAP account number provided';
    private static Final string NOERROR = 'No Error';
    private static Final String OLDMIDCONTRACT = 'Old Mid Contract';
    private static Final Set <String> MIDCONTRACT = new Set<String> {'Old Mid Contract','New Mid Contract'}; 
    private static Set<Id> optyIds = new Set<Id> ();
    
    /** 
    * @description : GET method of the webservice
    * @return AccOptyWrapper
    */
    @HttpGet
    global static InProductServiceWrapper doGet(){
        InProductServiceWrapper objWrapper;
        
        RestRequest req = RestContext.request;
        String sapAccountNum = req.params.get('sapAccountNum');

        Set <Id> optyIdFiltered = new Set <Id> ();
        Source_System_Detail__c acc = new Source_System_Detail__c();
        Source_System_Detail__c ssd = new Source_System_Detail__c();
        
        try{ 
            ssd = [Select Id,Source_System_Account_Number__c,BU_Segment_Level_2__c from Source_System_Detail__c 
                   where Source_System_Account_Number__c =: sapAccountNum WITH SECURITY_ENFORCED];
                    
            if(ssd.BU_Segment_Level_2__c == 'Medium Law'){
                acc = [Select id, name, Source_System_Account_Number__c, OLC_Account_Number__c, LCRM_Phone__c, LCRM_Website__c, 
                Trial_Status__c,Digital_Firm__c from Source_System_Detail__c 
                where(Source_System_Account_Number__c =: sapAccountNum OR OLC_Account_Number__c =: sapAccountNum) WITH SECURITY_ENFORCED]; 
            }else{
                acc = [Select id, name, Source_System_Account_Number__c, OLC_Account_Number__c, LCRM_Phone__c, LCRM_Website__c,
                Trial_Status__c,Digital_Firm__c, 
                (SELECT Id FROM Opportunities__r WHERE isDigitalSpearHead__c = true AND Digital_Review_Complete__c = true)            
                from Source_System_Detail__c 
                where(Source_System_Account_Number__c =: sapAccountNum OR OLC_Account_Number__c =: sapAccountNum) 
                AND Account_Name__r.Disable_In_Product_Notifications__c = false AND BU_Segment_Level_2__c <> 'Medium Law' WITH SECURITY_ENFORCED];
            }
            System.debug(LoggingLevel.INFO,'Account found'+acc);
            
            //retrieve list of opportunity ID
            objWrapper = retrieveSetOfOppty(acc);
            
            if(objWrapper != null){
                return objWrapper;
            }else{
                optyIdFiltered = getfilteredOpportunities();
            
                if(optyIdFiltered != null && optyIdFiltered.size() >= 1){
                    objWrapper = processFilteredOpp(optyIdFiltered,acc);   
                }else{
                    objWrapper = new InProductServiceWrapper(acc, null, OPPORTUNITYNOTFOUND);
                }
            }
        } catch(System.QueryException e) {
            System.debug(LoggingLevel.INFO,ACCOUNTNOTFOUND);
        }
        
        return objWrapper;
    }

    /** 
    * @description : method to retrieve set of oppty id's
    * @param acc : SSD query
    * @return AccOptyWrapper
    */    
    private static InProductServiceWrapper retrieveSetOfOppty(Source_System_Detail__c acc){
        InProductServiceWrapper wrapperObj;
        
        if (acc != null){
            if (acc.Opportunities__r != null && acc.Opportunities__r.size() >= 1) {
                for (Opportunity op: acc.Opportunities__r) {
                    optyIds.add(op.Id);
                }
            } else{
                wrapperObj = new InProductServiceWrapper (acc, null, OPPORTUNITYNOTFOUND);
            }
        } else{
            wrapperObj = new InProductServiceWrapper (null, null, ACCOUNTNOTFOUND);
        }
        
        return wrapperObj;
    }
    
    
    private static set<Id> getfilteredOpportunities(){
        Set < Id > optyIdFiltered = new Set < Id > ();
        if (optyIds != null && optyIds.size() >= 1){
            list<Apttus_Proposal__Proposal__c> listProposal = new list<Apttus_Proposal__Proposal__c>();
            listProposal = [SELECT id, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Approval_Stage__c,Contract_Type__c 
                            FROM Apttus_Proposal__Proposal__c 
                            WHERE Digital_Quote_Type__c != 'Manual' AND Contract_Type__c NOT IN: MIDCONTRACT AND 
                            Apttus_Proposal__Approval_Stage__c IN('Presented')
                            AND Apttus_Proposal__Primary__c = TRUE AND APTS_Proposal_Business_Unit__c != 'FindLaw'
                            AND Apttus_Proposal__Opportunity__c IN: optyIds];
                            
            for (Apttus_Proposal__Proposal__c ap:listProposal) {
                system.debug(LoggingLevel.INFO,'-' + ap.Apttus_Proposal__Opportunity__c);
                optyIdFiltered.add(ap.Apttus_Proposal__Opportunity__c);
            }
            System.debug(LoggingLevel.INFO,'@@@@@@@@@@54filterde' + optyIdFiltered);
        } 
        return optyIdFiltered;
    }
    
    private static InProductServiceWrapper processFilteredOpp(set<ID> optyIdFiltered,Source_System_Detail__c acc){
        
        InProductServiceWrapper objWrapper;
        List <Opportunity> optyList = new List <Opportunity> ();
        optyList = [SELECT Id, accountId, Name,sub_Campaign_Code__c,Renewal_Date__c, 
                    (SELECT Id, Name, Apttus_Proposal__Approval_Stage__c FROM Apttus_Proposal__R00N70000001yUfDEAU__r WHERE 
                    Digital_Quote_Type__c != 'Manual'AND Contract_Type__c NOT IN: MIDCONTRACT AND 
                    Apttus_Proposal__Approval_Stage__c IN('Presented') AND Apttus_Proposal__Primary__c = TRUE 
                    AND APTS_Proposal_Business_Unit__c != 'FindLaw') 
                    FROM Opportunity WHERE Id IN: optyIdFiltered WITH SECURITY_ENFORCED];
        
        if(optyList != null && optyList.size()>0){
            objWrapper = new InProductServiceWrapper(acc, optyList, NOERROR);
        }else{
            objWrapper = new InProductServiceWrapper(acc, null, OPPORTUNITYNOTFOUND);
        }
        
        return objWrapper;
    }
    /** 
    * @description : Creating this wrapper class in case service wants more unrelated Obj data in future
    */ 
    global class InProductServiceWrapper{
        List <Opportunity> opty;
        String message;
        
        InProductServiceWrapper(Source_System_Detail__c objSSD, List <Opportunity> listOpporunity, String message){
            if (listOpporunity != null){
                for (Opportunity objOpportunity: listOpporunity){
                    objOpportunity.accountId = objSSD.id;
                }
            }
            this.opty= listOpporunity;
            this.message = message;
        }
    }
}