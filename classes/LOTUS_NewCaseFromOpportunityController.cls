/********************************************************************************************************* 
Name: LOTUS_NewCaseFromOpportunityController
==========================================================================================================
Req:  Controller for VF page named 'LOTUS_NewCaseFromOpportunity'.
==========================================================================================================
Purpose: Controller is used to redirect to new Sales Case standard page from Opportunity
========================================================================================================== 
* CHANGE HISTORY
* ========================================================================================================
* JIRA             Date               Name                               Project               Description
* DPS-16572        1-July-2020        Debarghya Sen                      LCRM                  Created
* DPS-16572        2-July-2020        Sateeesh Kumar Pindi,Niket Kapasi  LCRM                  Logic added redirect to Case creation page in classic/ lightning/ mobile
* =========================================================================================================
***********************************************************************************************************/

/** 
 * @description :  new case from opportunity
*/
public without sharing class LOTUS_NewCaseFromOpportunityController {
    
    /** @description gettersetter*/
    Public static boolean sowCase {get; set;}
   /**
    * @description : LOTUS_NewCaseFromOpportunityController
    */
    
    public LOTUS_NewCaseFromOpportunityController() {
        System.debug(LoggingLevel.WARN,'Inside  controller');
    }
    /**
    * @description : LOTUS_NewCaseFromOpportunityController
    * @param  controller
    */
    public LOTUS_NewCaseFromOpportunityController(ApexPages.StandardSetController controller) {
        return; 
    }

    /**
         * @description : redirectCase
         * @return Pagereference
    */
    public Pagereference redirectCase(){
        @TestVisible Boolean lightningTheme;
        @TestVisible Boolean mobileTheme;
        @TestVisible Boolean classicTheme;

        PageReference nextPage;
        //Calling the class/method for identifying user theme9
        Id recordId = ApexPages.currentPage().getParameters().get('id'); 

        Map<String, LCRM_Opty_Case_Brand_Map__c> optycaseMap = LCRM_Opty_Case_Brand_Map__c.getAll();
        String salesIssue;
        String salesReason;
        String salesBrand;
        String optyBrand;
        Opportunity op = new Opportunity();
        if(Opportunity.sObjectType.getDescribe().isAccessible()){
            op = [SELECT id,name, AccountId, Key_Contact__c,Brand__c FROM Opportunity WHERE id =: recordId LIMIT 1];
            //op = [SELECT id,name, AccountId, Key_Contact__c,Brand__c,LCRM_Material_Product__c FROM Opportunity WHERE id =: recordId LIMIT 1];
           /*if(op.Brand__c =='Caselines'){
            //salesBrand  = getPicklistValues('Case','ESC_Product_Segment_Brand__c','Caselines');           

                        salesBrand  =optycaseMap.get('CaseLines Cae').Case_Brand__c;
                        salesIssue  =optycaseMap.get('CaseLines Cae').Case_Issue__c;
                        salesReason =optycaseMap.get('CaseLines Cae').Case_Reason__c;
            }  else{
                        salesBrand  =optycaseMap.get('Professional Services Case').Case_Brand__c;
                        salesIssue  =optycaseMap.get('Professional Services Case').Case_Issue__c;
                        salesReason =optycaseMap.get('Professional Services Case').Case_Reason__c;
                                                
                    }*/
                /*optyBrand=op.Brand__c;
                if(optyBrand == null)  {
                    optyBrand ='Risk';
                }*/
                 if(optycaseMap.containsKey(op.Brand__c)){
                    optyBrand=op.Brand__c;
                 }
                else {
                    optyBrand='Risk';
                }
                if(optyBrand!=null){    
                    salesBrand  =optycaseMap.get(optyBrand).Case_Brand__c;
                    salesIssue  =optycaseMap.get(optyBrand).Case_Issue__c;
                    salesReason =optycaseMap.get(optyBrand).Case_Reason__c;
                                            
                }

            
        }
        List<LOTUS_case_from_Opportunity_field_DOM__mdt> mdtFields = new  List<LOTUS_case_from_Opportunity_field_DOM__mdt>();
        
        mdtFields = [SELECT MasterLabel, QualifiedApiName, AccountId_DOM__c,OpportunityName_DOM__c,
                                                                  Brand_DOM__c,contactId_DOM__c,Issue_DOM__c,OpportunityId_DOM__c,ProductTitle_DOM__c,Reason_DOM__c 
                                                                  FROM LOTUS_case_from_Opportunity_field_DOM__mdt WITH SECURITY_ENFORCED];


        Id recordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ESC_Sales_Case').getRecordTypeId();
        // Forming the URLs for classic, lightning and mobile to pass AccountId, ContactId, OpportunityId
        lightningTheme = UserInfo.getUiThemeDisplayed() == 'Theme4d';
        mobileTheme = UserInfo.getUiThemeDisplayed() == 'Theme4t';
        classicTheme = UserInfo.getUiThemeDisplayed() == 'Theme3';
        //For Lightning Redirect

        if(lightningTheme){
           nextPage = new PageReference(System.URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/o/Case/new?recordTypeId='+recordTypeId+'&nooverride=1'+'&defaultFieldValues=ContactId='+op.Key_Contact__c+',AccountId='+op.AccountId+',Opportunity__c='+op.Id +',ESC_Issue__c='+salesIssue +',ESC_Product_Segment_Brand__c='+salesBrand+',ESC_Reason__c='+salesReason+',ESC_Product_Title__c='+op.Brand__c +'&ent=Case');           

        }
        //For Classic Redirect

        else if(classicTheme){
            nextPage = new PageReference( System.URL.getSalesforceBaseUrl().toExternalForm() +'/500/e?retURL=%2F500%2Fo&RecordType='+recordTypeId+mdtFields[0].AccountId_DOM__c+op.AccountId+mdtFields[0].contactId_DOM__c+op.Key_Contact__c+mdtFields[0].OpportunityName_DOM__c+op.name+mdtFields[0].OpportunityId_DOM__c+op.Id+mdtFields[0].Issue_DOM__c+salesIssue+mdtFields[0].Reason_DOM__c+salesReason+mdtFields[0].Brand_DOM__c+salesBrand+mdtFields[0].ProductTitle_DOM__c+op.Brand__c+'&ent=Case');
             }
        //For Mobile Redirect

        else if(mobileTheme){
            //Need to put the Mobile Redirect URL Here
            nextPage = new PageReference(System.URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/o/Case/new?recordTypeId='+recordTypeId+'&nooverride=1'+'&ContactId='+op.Key_Contact__c+'&AccountId='+op.AccountId+'&Opportunity__c='+op.Id +'&ESC_Issue__c='+salesIssue +'&ESC_Product_Segment_Brand__c='+salesBrand+ '&ESC_Reason__c='+salesReason+'&ESC_Product_Title__c='+op.Brand__c+'&ent=Case');

        }
        nextPage.setredirect(true);
        //}
        /*else{
            String parentRec = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+recordId;
            String backLink = '\n<a href="'+parentRec+'">Back To Opportunity'+'</a>';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, system.label.LOTUS_SoWCaseWarning+' '+ backLink));
      }*/
        return nextpage;
        
    }
    // For fetching picklist values dynamically
    private static string getPicklistValues(string objName, string fieldName, string plVal){
        String plValue='';
        Schema.DescribeSObjectResult objDesc = Schema.getGlobalDescribe().get(objName).getDescribe() ;
        List<Schema.PicklistEntry> plEntry = objDesc.fields.getMap().get(fieldName).getDescribe().getPicklistValues();
        for( Schema.PicklistEntry pickListVal : plEntry){
            if(pickListVal.getLabel() == plVal){
                plValue = pickListVal.getValue();
            }
        }
        return plValue;
    }
    
    /**
         * @description : redirectCase
         * @return list<Case>
    */
    public static list<Case> getSowCases(){
        Id recordId = ApexPages.currentPage().getParameters().get('id');
        List<Case> cases =  [SELECT id,AccountId,ContactId,ESC_Issue__c,ESC_Reason__c,Subject,Description,RecordTypeId,
                ESC_Product_Title__c,ESC_Product_Segment_Brand__c,LCRM_Sub_BU__c,BU_Segment__c  
                FROM case WHERE opportunity__c =: recordId];
        if(cases.size()>0){
            sowCase =true;
        }
        return cases;
    }
    /**
     * @description createProjectInitiationCase
     * @param optyId
     */
    public static void createProjectInitiationCase(Id optyId){
        
        List<Case> sowCases = new List<Case>();
        List<Case> piCases = new List<Case>();
        List<Case> cases  = new List<Case>();
        if(optyId!=Null && Case.sObjectType.getDescribe().isAccessible()){
            
            //List<Case> cases = getSowCases();
             cases = [SELECT id,AccountId,ContactId,ESC_Issue__c,ESC_Reason__c,Subject,Description,RecordTypeId,
                ESC_Product_Title__c,ESC_Product_Segment_Brand__c,LCRM_Sub_BU__c,BU_Segment__c  
                FROM Case WHERE opportunity__c =: optyId];
        }
            if(cases.size() > 0){
                for(Case scase : cases){
                    //system.debug('scase'+scase.ESC_Issue__c);
                    if(sCase.ESC_Reason__c == 'SoW Pricing'){
                        sowCases.add(scase);
                        //system.debug('sowCases'+sowCases);
                    }
                    if(sCase.ESC_Reason__c == 'Project Initiation'){
                        piCases.add(scase);
                    }
                }
            }
            
            
            insertPiCase(sowCases,piCases,optyId);
    }
   
    /**
         * @description : insertPiCase
         * @param sowCases
         * @param piCases 
         * @param optyId
    */
    public static void insertPiCase(List<Case>sowCases, List<Case> piCases ,id optyId){
    
    if(sowCases.size()>0 && piCases.size()> 0){
                return;
                //system.debug('sowCases'+sowCases);
            }else if(sowCases.size()>0 && piCases.size() == 0){
                
                case newPICase = new case();
                
                newPICase.AccountId = sowCases[0].AccountId;
                newPICase.ContactId = sowCases[0].ContactId;
                newPICase.Opportunity__c = optyId;
                newPICase.ESC_Issue__c = getPicklistValues('Case','ESC_Issue__c', 'Professional Services');
                newPICase.ESC_Reason__c = getPicklistValues('Case','ESC_Reason__c', 'Project Initiation'); 
                newPICase.Description = 'Delivery';
                newPICase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Case').getRecordTypeId();
                newPICase.Subject = sowCases[0].Subject;
                newPICase.ESC_Product_Segment_Brand__c = sowCases[0].ESC_Product_Segment_Brand__c;
                newPICase.ESC_Product_Title__c = sowCases[0].ESC_Product_Title__c;
                newPICase.LCRM_Sub_BU__c = sowCases[0].LCRM_Sub_BU__c;
                newPICase.BU_Segment__c = sowCases[0].BU_Segment__c;
                newPICase.Is_GLI__c = TRUE;
                if(case.sObjectType.getDescribe().isAccessible() && case.sObjectType.getDescribe().isCreateable()){
                    insert newPICase;
                    
                }
                  
               
            
   
    }
    
}
}