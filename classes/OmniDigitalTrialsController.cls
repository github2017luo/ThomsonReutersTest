/**
* @description       : This class will help to fetch Contact, Products records and store response into Wrapper to show on LWC lightning datatable
* @author            : TCS Dev Team
* @group             : Omni Trial Team
* @last modified on  : MAY-JUN 2021
* @last modified by  : 
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   MAY-2021   TCS DEV Team                        Initial Version
**/
public with sharing class OmniDigitalTrialsController {
     
    
    /**
     * @description getProductsList
     * @param productName
     * @return Product2
     */
    @AuraEnabled //(cacheable=true)
    public static List<TrialProductWrapper> getProductsList(String productName){
        
        OmniTrialProductRelationship.ProductRelationShipIdsWrap  prdRelWrap = OmniTrialProductRelationship.getProducts();
        
        List<OmniTrialProductRelationship.ProductRelationShipWrap> productRelationListWrap = prdRelWrap.productRelationListWrap;
        set<Id> prodFromToIds = prdRelWrap.prodFromToIds;
        
        Map<Id, OmniTrialProductRelationship.ProductRelationShipWrap> mapPrdRel = getmapPrdRel(productRelationListWrap);
        
        string searchKey = '%' + productName  + '%';
        
        //String[] freeTrialValues = '%Digital%,%Omni channel%,%Digital, Omni channel%'.split(',');
        
        List<Product2> prdList = new List<Product2> ();
        if(String.isNotBlank(productName) && Schema.sObjectType.Product2.isAccessible()){
            prdList = [SELECT Id, Name, ProductCode,Bundle_Type__c ,Material_Type__c
                    FROM Product2  WHERE (Name LIKE: searchKey OR ProductCode LIKE: searchKey ) and 
                    (Free_Trial__c = 'Digital;Omni' OR Free_Trial__c = 'Omni')
                    and Free_Trial__c  !=  null and ID IN :prodFromToIds ];
        } else if(Schema.sObjectType.Product2.isAccessible()){
            prdList = [SELECT Id, Name, ProductCode,Bundle_Type__c ,Material_Type__c
                    FROM Product2  WHERE 
                    (Free_Trial__c = 'Digital;Omni' OR Free_Trial__c = 'Omni')
                    and Free_Trial__c  !=  null and ID IN :prodFromToIds ];
        } 
        
        List<TrialProductWrapper> productWrapList  = getTrialContactWrapperList(prdList, mapPrdRel );
        return  productWrapList;
    }
      /**
     * @description getmapPrdRel
     * @param productRelationListWrap
     * @return mapPrdRel
     */
      @testVisible
      private static Map<Id, OmniTrialProductRelationship.ProductRelationShipWrap> getmapPrdRel(List<OmniTrialProductRelationship.ProductRelationShipWrap> productRelationListWrap){
        
          Map<Id, OmniTrialProductRelationship.ProductRelationShipWrap> mapPrdRel = new Map<Id, OmniTrialProductRelationship.ProductRelationShipWrap>();
         
         for(OmniTrialProductRelationship.ProductRelationShipWrap prdWrap : productRelationListWrap){
         
             
             mapPrdRel.put(prdWrap.productId, prdWrap);
         }
         
         return mapPrdRel;
      }
      
      
      
     /**
     * @description getTrialContactWrapperList
     * @param produts
     * @param mapPrdRel
     * @return produts
     */
    @testVisible
    private static List<TrialProductWrapper> getTrialContactWrapperList(List<Product2> produts, Map<Id, OmniTrialProductRelationship.ProductRelationShipWrap> mapPrdRel ){
        
        List<TrialProductWrapper> productWrapList = new List<TrialProductWrapper>();
        if(!produts.isEmpty() && produts != null){
            for(Product2 prd : produts){
                TrialProductWrapper trialPrdWrap = new TrialProductWrapper();
                
                trialPrdWrap.trialPrdId = prd.Id; //Product 2 Id
                trialPrdWrap.trialPrdRecordId = null;
                trialPrdWrap.trialId = null;
                trialPrdWrap.productName = prd.Name;
                trialPrdWrap.productCode = prd.ProductCode;
                trialPrdWrap.bundleType = prd.Bundle_Type__c ;
                trialPrdWrap.materialType = prd.Material_Type__c;
                
                OmniTrialProductRelationship.ProductRelationShipWrap prdRelwrap = mapPrdRel.get(prd.Id); 
                
                trialPrdWrap.segmentType = prdRelwrap.segmentType;
                trialPrdWrap.relationshipType = prdRelwrap.relationshipType;
                trialPrdWrap.baseMaterialNumber = prdRelwrap.baseMaterialNumber;
                trialPrdWrap.baseMaterialName = prdRelwrap.baseMaterialName;
               
                
                productWrapList.add(trialPrdWrap);
            }
        }
        return productWrapList;
    }
    
    /**
     * @description fetchGSIContacts
     * @param accId
     * @return contacts
     */
    @AuraEnabled//(cacheable=true)  
    public static List<TrialContactWrapper> fetchGSIContacts(String accId){ 
        System.debug(LoggingLevel.WARN,'accId: '+accId);
        List<TrialContactWrapper> contactWrapList = new List<TrialContactWrapper>();
        if(String.isNotBlank(accId) && Schema.sObjectType.Contact.isAccessible()){
            List<Contact> contacts = [SELECT Id, FirstName, LastName, Name, Email, Online_Contact_Designation__c, Primary_Flag__c From Contact WHERE AccountId = :accId and Email != null];
            contactWrapList = getTrialContactWrapperList(contacts);
        } 
        return contactWrapList;  
    }
    
    /**
     * @description getTrialContactWrapperList
     * @param contacts
     * @return contacts
     */
    @testVisible
    private static List<TrialContactWrapper> getTrialContactWrapperList(List<Contact> contacts){
        
        List<TrialContactWrapper> contactWrapList = new List<TrialContactWrapper>();
        
        if(contacts != null && !contacts.isEmpty()){
            
            for(Contact cont :  contacts)
            {
                TrialContactWrapper contactWrap = new TrialContactWrapper();
                contactWrap.contactId = cont.Id; 
                contactWrap.email = cont.Email; 
                contactWrap.firstName = cont.FirstName; 
                contactWrap.lastName = cont.LastName; 
                contactWrap.onlineContact = false; 
                contactWrap.isPrimaySelectedFromUI = false;
                contactWrap.onlineContactDesignation = cont.Online_Contact_Designation__c;
                contactWrap.gsiPrimaryFlag = cont.Primary_Flag__c ;
                contactWrap.fullName = cont.Name;
                contactWrapList.add(contactWrap);
            }
        }
        
        return contactWrapList;
    }
    
    /**
     * @description fetchSSD
     * @param recordId
     * @return opty
     */
    @AuraEnabled 
    public static Opportunity fetchOpportunity(String recordId){ 
        Opportunity opty  = new Opportunity();
        if(String.isNotBlank(recordId) && Schema.sObjectType.Opportunity.isAccessible()){
            opty = [SELECT Id, Name, StageName, Owner.Name, AccountId, Key_Contact__r.Email, Source_System_Detail__c,
                Account.SAPAccountNumber__c, Account.Sanctioned_Status__c, Source_System_Detail__r.Source_System_Account_Number__c,Source_System_Detail__r.Name
                From Opportunity WHERE Id = :recordId];
        } 
        return opty ;  
    } 
    
    /**
     * @description SSD validation check for existin nd new customer
     * @param accountId - account Id from opportunity
     * @return isExistingCustomer
     */
    @AuraEnabled 
    public static Boolean ssdExistingCustomerCheck(String accountId){ 
        Boolean isExistingCustomer = false;
        
        List<Source_System_Detail__c> ssdList= new List<Source_System_Detail__c>();
        if(String.isNotBlank(accountId) && Schema.sObjectType.Source_System_Detail__c.isAccessible()){
            
            ssdList = [SELECT Id  From Source_System_Detail__c WHERE Account_Name__c = :accountId and Source_System_Account_Number__c != null];
            
            if(ssdList != null && ssdList.size() > 0){
                isExistingCustomer = true;
            }
        } 
        return isExistingCustomer;  
    }
    
  }