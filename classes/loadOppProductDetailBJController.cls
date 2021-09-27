/**
 * Controller for load Bejerman details vf page
 *
 * @author  Anshita Sharma
 * @version 2013-07-11
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2013-07-10   Anshita Sharma          Created                                                                
 * =============================================================================
 */
public with sharing class loadOppProductDetailBJController {
    public class MyException extends Exception {}
        
    public String opportunityId {get;set;}
    public Map<String,String> mapfieldTitles {get;set;}
    public List<DetailItem> listDetailItems {get;set;}
    public Opportunity oOpportunity {get;set;}
    public RecordType oRecordType {get;set;}
    public map<Id,Contact> mapContacts {get;set;}
    public Account oAccount{get;set;}
    public boolean bQuickSave{get;set;}
    
    public loadOppProductDetailBJController (ApexPages.StandardController oStdController){
        if(oStdController.getId() == null){
            opportunityId = System.currentPageReference().getParameters().get('oppId');
        }else{
            Id OppProductDetailId = oStdController.getId();
            OpportunityProductDetail__c oOppProductDetail = [Select Opportunity__c From OpportunityProductDetail__c Where ID =:OppProductDetailId];
            OpportunityId = oOppProductDetail.Opportunity__c;
        }
        
        initController();
        bQuickSave = false;
    }
    public void initController(){
        oOpportunity = [Select Name, AccountId From Opportunity Where ID = :OpportunityId ];
        
        initTitles(); // initialize mapfieldTitles
                
        //Initialize the Account
        oAccount = [Select Name From Account Where Id = :oOpportunity.AccountId];
                   
        init();
    }
    
    public PageReference save(){
        System.Savepoint sp = Database.setSavepoint();
        Boolean hasError = false;
        
        for(DetailItem oDetailItem : listDetailItems){
            List<Database.UpsertResult> results = Database.upsert(oDetailItem.listOppProductDetails, false);
            
            Integer i = 0;
            for(OpportunityProductDetail__c oOppProductDetail : oDetailItem.listOppProductDetails){
                Database.UpsertResult result = results.get(i);
                i++;
                
                List<Database.Error> listErrors = result.getErrors();
                if( (listErrors != null) && (listErrors.size() != 0) ){
                    hasError = true;
                    for(Database.Error error : listErrors){
                        String msg = '';
                        if(oOppProductDetail.Contact__c != null){
                            msg = '. Contact: ' + mapContacts.get(oOppProductDetail.Contact__c).Name + mapContacts.get(oOppProductDetail.Contact__c).Id;
                        }
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,error.getMessage() + msg));
                    }                       
                }
            }           
        }
        
        if(hasError){
            Database.Rollback(sp);
            return null;
        }
        
        if(bQuickSave){
            return null;
        }
        else{
            return new PageReference('/' + opportunityId );
        }
    }
    
    public PageReference cancel(){
        return new PageReference('/' +opportunityId );
    }
    public PageReference quickSave(){
        bQuickSave = true;
        return save();
    }
    /**
    * Wrapper class to wrap Opp line items and its related details from 
    * opportunity product details object and the field list that needs to be
    * shown on the vf page.
    */
    public class DetailItem{
        public OpportunityLineItem oOppLineItem {get;set;}
        public List<OpportunityProductDetail__c> listOppProductDetails {get;set;}
        public List<String> fieldList {get;set;}
        
        public DetailItem(){
            listOppProductDetails = new List<OpportunityProductDetail__c>();
        }
    }
    /**
    * initialize the mapfieldTitles which maps the api name and its related label.
    */
    private void initTitles(){
        mapfieldTitles = new Map<String,String>();
        mapfieldTitles.put('Account__c', getFieldLabel('OpportunityProductDetail__c', 'Account__c'));
        mapfieldTitles.put('Accounting__c', getFieldLabel('OpportunityProductDetail__c', 'Accounting__c'));  
        mapfieldTitles.put('Actual_Quote_US__c', getFieldLabel('OpportunityProductDetail__c', 'Actual_Quote_US__c'));  
        mapfieldTitles.put('Additional__c', getFieldLabel('OpportunityProductDetail__c', 'Additional__c'));  
        mapfieldTitles.put('Additional_GDoc__c', getFieldLabel('OpportunityProductDetail__c', 'Additional_GDoc__c'));  
        mapfieldTitles.put('Additional_HR__c', getFieldLabel('OpportunityProductDetail__c', 'Additional_HR__c'));  
        mapfieldTitles.put('Amount_CRM__c', getFieldLabel('OpportunityProductDetail__c', 'Amount_CRM__c'));  
        mapfieldTitles.put('Amount_Payroll_Subscription__c', getFieldLabel('OpportunityProductDetail__c', 'Amount_Payroll_Subscription__c'));  
        mapfieldTitles.put('Backup_on_line__c', getFieldLabel('OpportunityProductDetail__c', 'Backup_on_line__c'));  
        mapfieldTitles.put('Balance_on_Delivery__c', getFieldLabel('OpportunityProductDetail__c', 'Balance_on_Delivery__c'));  
        mapfieldTitles.put('Basic_Core__c', getFieldLabel('OpportunityProductDetail__c', 'Basic_Core__c'));  
        mapfieldTitles.put('Basic_GDoc__c', getFieldLabel('OpportunityProductDetail__c', 'Basic_GDoc__c'));  
        mapfieldTitles.put('Basics__c', getFieldLabel('OpportunityProductDetail__c', 'Basics__c'));  
        mapfieldTitles.put('Bookkeeper_Wages__c', getFieldLabel('OpportunityProductDetail__c', 'Bookkeeper_Wages__c'));  
        mapfieldTitles.put('BPM_Puestos__c', getFieldLabel('OpportunityProductDetail__c', 'BPM_Puestos__c'));  
        mapfieldTitles.put('Budget__c', getFieldLabel('OpportunityProductDetail__c', 'Budget__c'));  
        mapfieldTitles.put('Call_to_Schedule__c', getFieldLabel('OpportunityProductDetail__c', 'Call_to_Schedule__c'));  
        mapfieldTitles.put('Companies__c', getFieldLabel('OpportunityProductDetail__c', 'Companies__c'));  
        mapfieldTitles.put('Contact__c', getFieldLabel('OpportunityProductDetail__c', 'Contact__c'));  
        mapfieldTitles.put('Continuous_Receipts__c', getFieldLabel('OpportunityProductDetail__c', 'Continuous_Receipts__c'));  
        mapfieldTitles.put('Core_Basic_Amount__c', getFieldLabel('OpportunityProductDetail__c', 'Core_Basic_Amount__c'));  
        mapfieldTitles.put('CRM__c', getFieldLabel('OpportunityProductDetail__c', 'CRM__c'));  
        mapfieldTitles.put('Curso_de_apacitaci_n__c', getFieldLabel('OpportunityProductDetail__c', 'Curso_de_apacitaci_n__c'));  
        mapfieldTitles.put('Data_Import__c', getFieldLabel('OpportunityProductDetail__c', 'Data_Import__c'));  
        mapfieldTitles.put('Date_Budget__c', getFieldLabel('OpportunityProductDetail__c', 'Date_Budget__c'));  
        mapfieldTitles.put('Date_From__c', getFieldLabel('OpportunityProductDetail__c', 'Date_From__c'));  
        mapfieldTitles.put('Date_to__c', getFieldLabel('OpportunityProductDetail__c', 'Date_to__c'));  
        mapfieldTitles.put('Description_Models__c', getFieldLabel('OpportunityProductDetail__c', 'Description_Models__c'));  
        mapfieldTitles.put('Dollar__c', getFieldLabel('OpportunityProductDetail__c', 'Dollar__c'));  
        mapfieldTitles.put('e_Data__c', getFieldLabel('OpportunityProductDetail__c', 'e_Data__c'));  
        mapfieldTitles.put('eFlexWeb__c', getFieldLabel('OpportunityProductDetail__c', 'eFlexWeb__c'));  
        mapfieldTitles.put('e_Sales__c', getFieldLabel('OpportunityProductDetail__c', 'e_Sales__c'));  
        mapfieldTitles.put('eSales_Amount__c', getFieldLabel('OpportunityProductDetail__c', 'eSales_Amount__c'));  
        mapfieldTitles.put('Fee_configuracion__c', getFieldLabel('OpportunityProductDetail__c', 'Fee_configuracion__c'));  
        mapfieldTitles.put('Flex__c', getFieldLabel('OpportunityProductDetail__c', 'Flex__c'));  
        mapfieldTitles.put('Functional_Meetings__c', getFieldLabel('OpportunityProductDetail__c', 'Functional_Meetings__c'));  
        mapfieldTitles.put('Gdoc__c', getFieldLabel('OpportunityProductDetail__c', 'Gdoc__c'));  
        mapfieldTitles.put('Hours_Consulting_Distributor__c', getFieldLabel('OpportunityProductDetail__c', 'Hours_Consulting_Distributor__c'));  
        mapfieldTitles.put('HR_Bundles__c', getFieldLabel('OpportunityProductDetail__c', 'HR_Bundles__c'));  
        mapfieldTitles.put('Hs_MAM__c', getFieldLabel('OpportunityProductDetail__c', 'Hs_MAM__c'));  
        mapfieldTitles.put('Hs_STA__c', getFieldLabel('OpportunityProductDetail__c', 'Hs_STA__c'));  
        mapfieldTitles.put('Imp_Lic_Rental__c', getFieldLabel('OpportunityProductDetail__c', 'Imp_Lic_Rental__c'));  
        mapfieldTitles.put('Importers__c', getFieldLabel('OpportunityProductDetail__c', 'Importers__c'));  
        mapfieldTitles.put('Installs__c', getFieldLabel('OpportunityProductDetail__c', 'Installs__c'));  
        mapfieldTitles.put('Interface__c', getFieldLabel('OpportunityProductDetail__c', 'Interface__c'));  
        mapfieldTitles.put('Laser_Receipts__c', getFieldLabel('OpportunityProductDetail__c', 'Laser_Receipts__c'));  
        mapfieldTitles.put('Maturity__c', getFieldLabel('OpportunityProductDetail__c', 'Maturity__c'));  
        mapfieldTitles.put('Migration__c', getFieldLabel('OpportunityProductDetail__c', 'Migration__c'));  
        mapfieldTitles.put('Migration_to_Flex__c', getFieldLabel('OpportunityProductDetail__c', 'Migration_to_Flex__c'));  
        mapfieldTitles.put('Modis__c', getFieldLabel('OpportunityProductDetail__c', 'Modis__c'));  
        mapfieldTitles.put('Multiple_Selection__c', getFieldLabel('OpportunityProductDetail__c', 'Multiple_Selection__c'));  
        mapfieldTitles.put('Multiple_Selection_Bejerman__c', getFieldLabel('OpportunityProductDetail__c', 'Multiple_Selection_Bejerman__c'));  
        mapfieldTitles.put('Nominate_Amount_Factual__c', getFieldLabel('OpportunityProductDetail__c', 'Nominate_Amount_Factual__c'));  
        mapfieldTitles.put('Number_of_CAL__c', getFieldLabel('OpportunityProductDetail__c', 'Number_of_CAL__c'));  
        mapfieldTitles.put('Number_of_CD__c', getFieldLabel('OpportunityProductDetail__c', 'Number_of_CD__c'));  
        mapfieldTitles.put('Number_of_Functional_Hours__c', getFieldLabel('OpportunityProductDetail__c', 'Number_of_Functional_Hours__c'));  
        mapfieldTitles.put('Number_of_Technical_Hours__c', getFieldLabel('OpportunityProductDetail__c', 'Number_of_Technical_Hours__c'));  
        mapfieldTitles.put('Online__c', getFieldLabel('OpportunityProductDetail__c', 'Online__c'));  
        mapfieldTitles.put('Opportunity__c', getFieldLabel('OpportunityProductDetail__c', 'Opportunity__c'));  
        mapfieldTitles.put('Opportunity_Line_Item_Id__c', getFieldLabel('OpportunityProductDetail__c', 'Opportunity_Line_Item_Id__c'));  
        mapfieldTitles.put('Points_of_Sale__c', getFieldLabel('OpportunityProductDetail__c', 'Points_of_Sale__c'));  
        mapfieldTitles.put('Posts__c', getFieldLabel('OpportunityProductDetail__c', 'Posts__c'));  
        mapfieldTitles.put('Posts_Balances__c', getFieldLabel('OpportunityProductDetail__c', 'Posts_Balances__c'));  
        mapfieldTitles.put('Posts_GDoc__c', getFieldLabel('OpportunityProductDetail__c', 'Posts_GDoc__c'));  
        mapfieldTitles.put('Product__c', getFieldLabel('OpportunityProductDetail__c', 'Product__c'));  
        mapfieldTitles.put('Quantity_USP__c', getFieldLabel('OpportunityProductDetail__c', 'Quantity_USP__c'));  
        mapfieldTitles.put('Queries__c', getFieldLabel('OpportunityProductDetail__c', 'Queries__c'));  
        mapfieldTitles.put('Queries_Posts__c', getFieldLabel('OpportunityProductDetail__c', 'Queries_Posts__c'));  
        mapfieldTitles.put('Queries_WEB__c', getFieldLabel('OpportunityProductDetail__c', 'Queries_WEB__c'));  
        mapfieldTitles.put('Renew_and_Upgrade__c', getFieldLabel('OpportunityProductDetail__c', 'Renew_and_Upgrade__c'));  
        mapfieldTitles.put('RRHH__c', getFieldLabel('OpportunityProductDetail__c', 'RRHH__c'));  
        mapfieldTitles.put('Salaries__c', getFieldLabel('OpportunityProductDetail__c', 'Salaries__c'));  
        mapfieldTitles.put('SAV__c', getFieldLabel('OpportunityProductDetail__c', 'SAV__c'));  
        mapfieldTitles.put('Serv_Hosting__c', getFieldLabel('OpportunityProductDetail__c', 'Serv_Hosting__c'));  
        mapfieldTitles.put('Stands_for_Point_of_Sale__c', getFieldLabel('OpportunityProductDetail__c', 'Stands_for_Point_of_Sale__c'));  
        mapfieldTitles.put('Technical_Meetings__c', getFieldLabel('OpportunityProductDetail__c', 'Technical_Meetings__c'));  
        mapfieldTitles.put('Transact_BPM__c', getFieldLabel('OpportunityProductDetail__c', 'Transact_BPM__c'));  
        mapfieldTitles.put('Web__c', getFieldLabel('OpportunityProductDetail__c', 'Web__c'));     
    }
    
    private void init(){
        listDetailItems = new List<DetailItem>();
        Map<String,DetailItem> mapOppLineDetailItems = new Map<String, DetailItem>();
        
        for(OpportunityLineItem oOppLineItem : [Select id, Number_of_Contacts__c,PricebookEntry.Product2.Name, PricebookEntry.Product2Id, Quantity From OpportunityLineItem Where OpportunityId = :opportunityId Order By PricebookEntry.Product2.Name]){
            DetailItem oDetailItem = new DetailItem();
            oDetailItem.oOppLineItem = oOppLineItem;
            
            oDetailItem.fieldList = fieldList(oOppLineItem);
            
            listDetailItems.add(oDetailItem); 
            //mapOppLineDetailItems.put(oOppLineItem.Id, oDetailItem);   
            mapOppLineDetailItems.put(((String)oOppLineItem.ID).substring(0,15), oDetailItem);   

        }
        
        for(OpportunityProductDetail__c oOppProductDetail : [SELECT Accounting__c,Account__c,Actual_Quote_US__c,Additional_GDoc__c,Additional_HR__c,Additional__c,Amount_CRM__c,Amount_Payroll_Subscription__c,Backup_on_line__c,Balance_on_Delivery__c,Basics__c,Basic_Core__c,Basic_GDoc__c,Bookkeeper_Wages__c,BPM_Puestos__c,Budget__c,Call_to_Schedule__c,Companies__c,Contact__c,Continuous_Receipts__c,Core_Basic_Amount__c,CreatedById,CreatedDate,CRM__c,CurrencyIsoCode,Curso_de_apacitaci_n__c,Data_Import__c,Date_Budget__c,Date_From__c,Date_to__c,Description_Models__c,Dollar__c,eFlexWeb__c,eSales_Amount__c,e_Data__c,e_Sales__c,Fee_configuracion__c,Flex__c,Functional_Meetings__c,Gdoc__c,Hours_Consulting_Distributor__c,HR_Bundles__c,Hs_MAM__c,Hs_STA__c,Id,Importers__c,Imp_Lic_Rental__c,Installs__c,Interface__c,IsDeleted,Laser_Receipts__c,LastActivityDate,LastModifiedById,LastModifiedDate,Maturity__c,Migration_to_Flex__c,Migration__c,Modis__c,Multiple_Selection_Bejerman__c,Multiple_Selection__c,Name,Nominate_Amount_Factual__c,Number_of_CAL__c,Number_of_CD__c,Number_of_Functional_Hours__c,Number_of_Technical_Hours__c,Online__c,Opportunity_Line_Item_Id__c,Opportunity__c,Points_of_Sale__c,Posts_Balances__c,Posts_GDoc__c,Posts__c,Product__c,Quantity_USP__c,Queries_Posts__c,Queries_WEB__c,Queries__c,Renew_and_Upgrade__c,RRHH__c,Salaries__c,SAV__c,Serv_Hosting__c,Stands_for_Point_of_Sale__c,SystemModstamp,Technical_Meetings__c,Transact_BPM__c,Web__c FROM OpportunityProductDetail__c
 Where Opportunity_Line_Item_Id__c IN :mapOppLineDetailItems.keySet()]){
            
            DetailItem oDetailItem = mapOppLineDetailItems.get(oOppProductDetail.Opportunity_Line_Item_Id__c);
            if(oDetailItem != null){
                oDetailItem.listOppProductDetails.add(oOppProductDetail);   
            }               
              
        }
        
          
       for(DetailItem di:listDetailItems){
            while(di.oOppLineItem.Number_of_Contacts__c > di.listOppProductDetails.size()){
                OpportunityProductDetail__c oppDet = new OpportunityProductDetail__c(Opportunity__c = opportunityId, Product__c = di.oOppLineItem.PricebookEntry.Product2Id, Opportunity_Line_Item_Id__c = ((String)di.oOppLineItem.Id).substring(0,15));
                di.listOppProductDetails.add(oppDet);
            }    
            if(di.listOppProductDetails.size() == 0 ){
                OpportunityProductDetail__c oppDet = new OpportunityProductDetail__c(Opportunity__c = opportunityId, Product__c = di.oOppLineItem.PricebookEntry.Product2Id, Opportunity_Line_Item_Id__c =((String)di.oOppLineItem.Id).substring(0,15));
                di.listOppProductDetails.add(oppDet);
            }            
        }
      
        
        mapContacts = new map<Id,Contact>([Select Name, Email From Contact Where AccountId = :oAccount.Id Order By Name LIMIT 999]);
    }
    /**
    * 
    */
    public List<string> fieldList(OpportunityLineItem oOppLineItem){
        List<String> fieldList = new List<String>();
        fieldList.add('Contact__c'); 
        fieldList.add('Curso_de_apacitaci_n__c');
        fieldList.add('Date_Budget__c'); 
        fieldList.add('Technical_Meetings__c');
        fieldList.add('Budget__c'); 
        fieldList.add('Number_of_Technical_Hours__c');
        fieldList.add('Online__c');
        fieldList.add('Functional_Meetings__c');  
        fieldList.add('Basics__c');
        fieldList.add('Number_of_Functional_Hours__c');  
        fieldList.add('Migration_to_Flex__c'); 
        fieldList.add('Hours_Consulting_Distributor__c'); 
        fieldList.add('Additional__c'); 
        fieldList.add('Hs_STA__c'); 
        fieldList.add('Posts__c'); 
        fieldList.add('Call_to_Schedule__c'); 
        fieldList.add('Companies__c');
        fieldList.add('Hs_MAM__c'); 
        fieldList.add('BPM_Puestos__c'); 
        fieldList.add('Installs__c');
        fieldList.add('Transact_BPM__c'); 
        fieldList.add('Balance_on_Delivery__c'); 
        fieldList.add('Queries_Posts__c'); 
        fieldList.add('Description_Models__c'); 
        fieldList.add('Queries_WEB__c'); 
        fieldList.add('Date_From__c');
        fieldList.add('CRM__c');  
        fieldList.add('Date_to__c'); 
        fieldList.add('Importers__c'); 
        fieldList.add('Flex__c'); 
        fieldList.add('Interface__c');
        fieldList.add('Modis__c'); 
        fieldList.add('Accounting__c');
        fieldList.add('Bookkeeper_Wages__c'); 
        fieldList.add('Salaries__c'); 
        fieldList.add('Amount_CRM__c'); 
        fieldList.add('Posts_Balances__c'); 
        fieldList.add('RRHH__c'); 
        fieldList.add('Points_of_Sale__c'); 
        fieldList.add('Gdoc__c'); 
        fieldList.add('Stands_for_Point_of_Sale__c'); 
        fieldList.add('Queries__c'); 
        fieldList.add('Migration__c'); 
        fieldList.add('Renew_and_Upgrade__c'); 
        fieldList.add('HR_Bundles__c'); 
        fieldList.add('Web__c'); 
        fieldList.add('Additional_HR__c'); 
        fieldList.add('Core_Basic_Amount__c');
        fieldList.add('Basic_GDoc__c'); 
        fieldList.add('eSales_Amount__c');
        fieldList.add('Posts_GDoc__c');
        fieldList.add('Data_Import__c');  
        fieldList.add('Additional_GDoc__c');  
        fieldList.add('Serv_Hosting__c'); 
        fieldList.add('eFlexWeb__c'); 
        fieldList.add('Imp_Lic_Rental__c'); 
        fieldList.add('Fee_configuracion__c'); 
        fieldList.add('Backup_on_line__c'); 
        fieldList.add('Basic_Core__c'); 
        fieldList.add('Nominate_Amount_Factual__c'); 
        fieldList.add('e_Sales__c'); 
        fieldList.add('Amount_Payroll_Subscription__c'); 
        fieldList.add('e_Data__c'); 
        fieldList.add('Multiple_Selection_Bejerman__c');
        fieldList.add('Dollar__c'); 
        fieldList.add('Multiple_Selection__c'); 
        fieldList.add('Actual_Quote_US__c'); 
        fieldList.add('Number_of_CD__c'); 
        fieldList.add('Number_of_CAL__c'); 
        fieldList.add('Continuous_Receipts__c'); 
        fieldList.add('Laser_Receipts__c'); 
        //fieldList.add('Account__c');
        fieldList.add('Quantity_USP__c'); 
        //fieldList.add('Product__c'); 
        fieldList.add('SAV__c'); 
        //fieldList.add('Opportunity__c'); 
        fieldList.add('Maturity__c'); 
        //fieldList.add('Opportunity_Line_Item_Id__c'); 
        return fieldList;
    }
    /**
    * 
    */
    public List<SelectOption> getContactSelectOptions() {
        List<SelectOption> listContactSelectOptions = new List<SelectOption>();
        
        listContactSelectOptions.add(new SelectOption('','-- None --'));
        for(Contact oContact : mapContacts.Values()){
            listContactSelectOptions.add(new SelectOption(oContact.ID,oContact.Name));
        }
        return listContactSelectOptions;
    }
    /**
    * method to get the label of a particular field.
    */
    public String getFieldLabel(String SObjectType, String fieldName){
    
        Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe() ;
        Schema.SObjectType schemaSobjectType = mapGlobalDescribe.get('OpportunityProductDetail__c') ;
        Schema.DescribeSObjectResult SchemaDescribeSObjectResult = schemaSobjectType.getDescribe() ;
        Map<String, Schema.SObjectField> mapfields = SchemaDescribeSObjectResult.fields.getMap();
        
        Schema.SObjectField SchemaSObjectField = mapfields.get(fieldName) ;
        Schema.DescribeFieldResult SchemaDescribeFieldResult = SchemaSObjectField.getDescribe() ;
        return SchemaDescribeFieldResult.getLabel();
    }
  
}