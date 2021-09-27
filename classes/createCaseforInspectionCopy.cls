/**
 * Processes Opportunity records after a DML event is processed by the system
 *
 * @author  Srikanth Kuruva
 * @version  2011-07-26
 */

/**
 * CHANGE HISTORY
 * =============================================================================
 * Date      Name          Description
 * 2011-07-26   Srikanth Kuruva        Created
 * =============================================================================
 */
public class createCaseforInspectionCopy
{
    public static Id ANZCaseRecordTypeId = schema.sobjecttype.Case.getRecordTypeInfosByName().get('ANZ').getRecordTypeId();
    public static Id CaseOwnerId;
    public static map<id,Opportunitylineitem> mapOppty2Productcode;
    public static map<Id,Opportunity> MapOpportunity;


    //from the list of inserted opportunities identify those for which the case needs to be created
    
    public static void createCaseAfterOpportunityInsert(List<Opportunity> listOpportunitiesInserted)
    {        
        List<Opportunity> listInspectionCopyOpportunities = new List<Opportunity>();
        for(Opportunity oOpportunity : listOpportunitiesInserted)
        {
            if(oOpportunity.Request_Inspection_Copy__c == true)
            {
                listInspectionCopyOpportunities.add(oOpportunity);
            }
        }
        createCase(listInspectionCopyOpportunities);
    }
    
    
    //from the list of updated opportunities identify those for which the case needs to be created  
    
    public static void createCaseAfterOpportunityUpdate(map<Id, Opportunity> mapOpportunitiesBeforeUpdated, List<Opportunity> listOpportunitiesAfterUpdated)
    {
        List<Opportunity> listInspectionCopyOpportunities = new List<Opportunity>();
        for(Opportunity oOpportunity : listOpportunitiesAfterUpdated)
        {
            if(mapOpportunitiesBeforeUpdated.get(oOpportunity.Id).Request_Inspection_Copy__c != oOpportunity.Request_Inspection_Copy__c 
               && oOpportunity.Request_Inspection_Copy__c == true)
            {
                listInspectionCopyOpportunities.add(oOpportunity);
            }
        }
        createCase(listInspectionCopyOpportunities);
    }
    
    
    //create cases for the opportunities identified above
    
    public static void createCase(List<Opportunity> listInspectionCopyOpportunities)
    {
        List<Case> listCasestoInsert = new List<Case>();
        List<Id> listCourseIds = new List<Id>();
        
        //***Start: Codes to populate SAP Material Number & ProductCode from Product2 to Case
        //Inspection Copy Request Process – Additional Requirements QC 3601
        
        mapOppty2Productcode = new map<id,Opportunitylineitem>();
        list<Opportunitylineitem> listOpportunityLineItem = new list<Opportunitylineitem>();
        
        if(!listInspectionCopyOpportunities.isEmpty())
        {
           listOpportunityLineItem = [select opportunityid,pricebookentry.product2.Name,pricebookentry.product2.productcode from Opportunitylineitem
                                    where opportunityid IN :listInspectionCopyOpportunities order by SortOrder, pricebookentry.product2.Name];
                                    
           MapOpportunity = new map<Id,Opportunity>([select Id,Account.SAPAccountNumber__c,Product_Participation__c,
                                                    Product_Participation__r.Product_Name__c,Account.Name,
                                                    Account.BillingStreet,Account.BillingCity,Account.BillingState,
                                                    Account.BillingCountry,Account.BillingPostalCode from Opportunity 
                                                    where id IN: listInspectionCopyOpportunities]);       
    
          for(Opportunitylineitem oli: listOpportunityLineItem )
          {
            if(!mapOppty2Productcode.Containskey(oli.opportunityid))             
                mapOppty2Productcode.put(oli.opportunityid,oli);
          }
        
        //***End: Codes to populate Material Number(ProductCode) from Product2 to Case
        
        
            CaseOwnerId = [SELECT Id, Name FROM Group where Name = 'ANZ Material Master'][0].Id;
            
            //get the list of course ids the opportunities identified above are attached
            
            for(Opportunity oOpportunity : listInspectionCopyOpportunities)
            {
                listCourseIds.add(oOpportunity.Product_Participation__c);
            }
            //get course details - these details can be used while creating the case
    
            Map<Id, Course__c> mapCourses = new Map<Id, Course__c>([SELECT Id, Name,Product_Name__c,Course_Name__c, Account_Name__c, 
                                                                        Account_Name__r.Name, Contact_Name__c,Contact_Name__r.Name, 
                                                                        Account_Name__r.BillingStreet,Account_Name__r.BillingCity,
                                                                        Account_Name__r.BillingState,Account_Name__r.BillingCountry,
                                                                        Account_Name__r.BillingPostalCode 
                                                                        from Course__c where Id in :listCourseIds]);
            
            for(Opportunity oOpportunity : listInspectionCopyOpportunities)
            {              
                try{
                    listCasestoInsert.add(getCaseInstance(oOpportunity, mapCourses.get(oOpportunity.Product_Participation__c)));
                }Catch(Exception Ex)
                {                
                listInspectionCopyOpportunities[0].addError('Please attach a course to the opportunity.');              
              //listInspectionCopyOpportunities[0].addError(Ex.getMessage());
                }
            }
        }
        if(!listCasestoInsert.isEmpty())
        {
            insert listCasestoInsert;
        }        
    }
    public static Case getCaseInstance(Opportunity oOpportunity, Course__c oCourse)
    {
        Case oCase = new Case();
        
        //Inspection Copy Request Process – Additional Requirements QC 3601 
       

        oCase.Description = 'SAP Account Number:' + MapOpportunity.get(oOpportunity.Id).Account.SAPAccountNumber__c + '\n\n' 
                            
                            + + oCourse.Contact_Name__r.Name + '\n'
                           // + + MapOpportunity.get(oOpportunity.Id).Account.Name+ '\n'
                            + oCourse.Account_Name__r.Name + '\n'+
                            
                              /*
                            + MapOpportunity.get(oOpportunity.Id).Account.BillingStreet+'\n'
                            + MapOpportunity.get(oOpportunity.Id).Account.BillingCity+'\n'
                             + MapOpportunity.get(oOpportunity.Id).Account.BillingState +' '+ MapOpportunity.get(oOpportunity.Id).Account.BillingPostalCode +'\n' 
                            + MapOpportunity.get(oOpportunity.Id).Account.BillingCountry + '\n\n'
                            */
                          
                            oCourse.Account_Name__r.BillingStreet + '\n' +
                            oCourse.Account_Name__r.BillingCity + '\n' +
                            oCourse.Account_Name__r.BillingState + ' ' + oCourse.Account_Name__r.BillingPostalCode + '\n' +
                            oCourse.Account_Name__r.BillingCountry + '\n\n'
                            ;
                            
        if(mapOppty2Productcode.ContainsKey(oOpportunity.id))
            {                              
                    oCase.Description += 'Product Name: ' + mapOppty2Productcode.get(oOpportunity.id).pricebookentry.product2.Name+'\n'                                                                    
                                         + 'SAP Material Number: ' + mapOppty2Productcode.get(oOpportunity.id).pricebookentry.product2.ProductCode+'\n';
            }
        
        oCase.Product__c = 'Books';
        oCase.ANZ_Issue__c = 'Orders';
        oCase.Reason__c = 'Trial';
        oCase.Priority = 'Medium';
        oCase.Origin = 'Internal Users';
        oCase.Status = 'New';
        oCase.Subject = 'Inspection Copy Request';
        oCase.RecordTypeId = ANZCaseRecordTypeId ;
        oCase.Due_DateTime__c = System.DateTime.Now();       
        oCase.AccountId = oCourse.Account_Name__c;
        oCase.ContactId = oCourse.Contact_Name__c;
        oCase.OwnerId = CaseOwnerId;
        
        return oCase;
    }
}