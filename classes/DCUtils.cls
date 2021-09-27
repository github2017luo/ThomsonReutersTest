/*
 * CHANGE HISTORY
 * ==================================================================================================================================
 * Date         Name                    Description
 * 2018-01-02   Ramesh Reddy          This class has reusable code used by digital configurator
 * 2018-06-13   Rajan Tatuskar        DLT-9752 - Updates Account/Contact reference For Classes mentioned
 * 2018-07-17   Navleen Kaur          Added GLI Changes for DigtalFieldValueCaptialisation
 * 2018-12-19   Navleen Kaur          DLT-14155 : [Tech Story] [Code Scan] - Fix Code Scan Security Issues
 * 2019-01-10   Navleen Kaur          DLT-14349 : [Tech Story] [Code Scan] 
 * 2019-01-28   Navleen Kaur          DLT-14679  :Contact is not getting updated to new one when changed in not you pop-up.
 * 2019-10-07   Srikanth Kota         DLT-17790: Split firstName field into to string is not working
 * ==================================================================================================================================   
 */

public without sharing class DCUtils {
    
    public static Final String CART_STATUS_FINALIZED = 'Finalized';
    public static Final String STR_DIMENSION1_NAME = 'Quantity';
    public static Final String LINE_STATUS_CANCELLED = 'Cancelled';
    
    /**
     * used for reprice a cart with Apttus API
     * 
    */
    public static boolean reprice (Id cartId) {
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = cartID;
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
        
        return result.IsPricePending;
    }
    /**
     * used for reprice a cart with Apttus API by QuoteId
     * 
    */
    public static boolean repriceByQuoteId (Id cQuoteId) {
        List<Apttus_Config2__ProductConfiguration__c> carts = new List<Apttus_Config2__ProductConfiguration__c>();
    
        if(Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
             carts = [select id,name,Apttus_Config2__Status__c ,Apttus_QPConfig__Proposald__c
                                                               from Apttus_Config2__ProductConfiguration__c 
                                                             where Apttus_Config2__Status__c =: CART_STATUS_FINALIZED and Apttus_QPConfig__Proposald__c =: cQuoteId ];
        }
        if(carts != null && carts.size() > 0){
            return reprice(carts[0].id);
        }
        else {
            throw new DCCustomException('Record does not exist anymore - reference:'+cQuoteId);
        }
        return Null;
    }
    
    /**
     * Used to save exceptions in DIGITAL_EXCEPTION_LOG object
     * 
    */
    public static Digital_Exception_Log__c trackLog(Exception e,String className,String methodName){
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  
        ex.Exception_Message__c = e.getMessage();
        ex.Exception_Type__c = e.getStackTraceString();        
        ex.Additional_Information__c = String.valueof(e.getLineNumber());   
        ex.User_Message__c = String.valueof(e.getCause());
        ex.Class_Reference__c = '<'+className+'> > <'+methodName+'>';  
         if(Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){    
            insert ex;
        } 
        System.debug('Exception : '+ex); 
        return ex;
    }
    /**
     * used for formatting digital firstname for contact SSD :added by Navleen
     * 
    */ 
    public static list<LCRM_Contact_SSD__c> formatContactSSDFirstName(list<LCRM_Contact_SSD__c> digitalConList){  
        list<String> firstNameList = new list<String>();
        list<LCRM_Contact_SSD__c> finalContactList =  new list<LCRM_Contact_SSD__c>();
        if(digitalConList != NULL && digitalConList.size() > 0){
             for(LCRM_Contact_SSD__c con : digitalConList){
                 if(con.LCRM_First_Name__c != Null && con.LCRM_First_Name__c != ''){
                        String finalFirstName = '';
                        firstNameList = con.LCRM_First_Name__c.replaceall('\\s+',' ').split(' '); 
                        for(String sName : firstNameList){
                             finalFirstName  += sName.substring(0,1).toUpperCase()+sName.substring(1,sName.length()).toLowerCase()+ ' '; 
                             con.Digital_FirstName__c = finalFirstName;
                             
                         }
                         finalContactList.add(con);
                 } 
            }
       } 
       return finalContactList;
    }
     /**
     * used for formatting firstname for Contact :added by Navleen - DLT-14679
     * Update Space Split firstName as part of  DLT-17790
     * 
    */
     public static String formatName(String name){  
        String finalName = '';
        list<String> nameList = name.replaceall('\\s+',' ').split(' '); 
        for(String sName : nameList){
         finalName  +=' '+sName.substring(0,1).toUpperCase()+sName.substring(1,sName.length()).toLowerCase();
        }
        return finalName;                     
    } 
    /**
     * used for formatting fields for SSD:added by Navleen
     * 
    */ 
   
    public static list<Source_System_Detail__c> formatSSDFirmName(list<Source_System_Detail__c> digitalSSDList){  
        list<String> firmNameList = new list<String>();
        list<String> billingCityList = new list<String>();
        list<Source_System_Detail__c> finalSSDList =  new list<Source_System_Detail__c>();
   
        if(digitalSSDList != NULL && digitalSSDList.size() > 0){ 
            for(Source_System_Detail__c accssd : digitalSSDList){
                if(accssd.Name != NULL && accssd.Name != ''){
                    String finalFirmName = '';
                    firmNameList = accssd.Name.replaceAll('\\s+',' ').split(' ');     
                    for(String sFName : firmNameList){
                        finalFirmName += sFName.substring(0,1).toUpperCase()+sFName.substring(1,sFName.length()).toLowerCase()+ ' ';         
                        accssd.Digital_Firm_Name__c = finalFirmName ;       
                    }
                 } 
               
                if(accssd.City__c != NULL && accssd.City__c != '' ){
                    String finalBillingCity = '';
                    billingCityList = accssd.City__c.replaceAll('\\s+',' ').split(' ');
               
                    for(String bCity : billingCityList ){       
                        finalBillingCity += bCity.substring(0,1).toUpperCase()+bCity.substring(1,bCity.length()).toLowerCase()+ ' ';          
                    }
                    if(finalBillingCity.length()>40){
                           accssd.Digital_Billing_City__c = finalBillingCity.substring(0,40); 
                    }
                    else{
                        accssd.Digital_Billing_City__c = finalBillingCity; 
                    } 
                }
                finalSSDList.add(accssd); 
            }
        } 
        return finalSSDList;
   } 

    /**
     * used for remove lineitems from cart based on line numbers using Apttus API
     * 
    */    
    public static Apttus_CPQApi.CPQ.RemoveLineItemsResponseDO removeLineItems(List<Integer> removablelines, String cartId){
        Apttus_CPQApi.CPQ.RemoveLineItemsRequestDO request = new Apttus_CPQApi.CPQ.RemoveLineItemsRequestDO();
        request.CartId = cartId;
        request.PrimaryLineNumbers.addAll(removablelines);
        Apttus_CPQApi.CPQ.RemoveLineItemsResponseDO result = Apttus_CPQApi.CPQWebService.removeLineItems(request);
        
        System.debug('Is deleted '+result);
        return result;
    }
    
    /**
     * used for add multiple products to cart with Apttus API
     * 
    */
    public static Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultipleProducts(Set<string> productIds,integer iQuantity,String cartID,Apttus_Config2__LineItem__c liSO ){
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO addMultiProdRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        addMultiProdRequest.cartId = cartId;
        addMultiProdRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        for( String productId : productIds ){
            Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            selectedProduct.productId = productId;
            selectedProduct.Quantity = iQuantity;
            selectedProduct.comments = 'Inserted via Ecommerce';
            Map<String,Object> line = liSO.getPopulatedFieldsAsMap(); 
            System.debug('line  '+line);
            if(line.keySet() != null && line.keySet().size() > 0){
                List<String> allFields = new List<String>(line.keySet());
                selectedProduct.CustomFields = allFields;
                selectedProduct.CustomData = liSO; 
            }        
            addMultiProdRequest.selectedProducts.add(selectedProduct);  
        }     
        Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultiProdResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(addMultiProdRequest);
        return addMultiProdResponse;
    }
    
    /**
     * used for add multiple products to cart with Apttus API with ability
     to add different quantity for each Product
     * 
    */
    public static Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultipleProducts(List<ProductDetails> productDetailsList, String cartID, Apttus_Config2__LineItem__c liSO ){
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO addMultiProdRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
        addMultiProdRequest.cartId = cartId;
        addMultiProdRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
        for(ProductDetails prodDetail : productDetailsList ){
            Apttus_CPQApi.CPQ.SelectedProductDO selectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            selectedProduct.productId = prodDetail.productId;
            selectedProduct.Quantity = prodDetail.quantity;
            selectedProduct.comments = 'Inserted via Ecommerce';
            Map<String,Object> line = liSO.getPopulatedFieldsAsMap(); 
            System.debug('line  '+line);
            if(line.keySet() != null && line.keySet().size() > 0){
                List<String> allFields = new List<String>(line.keySet());
                selectedProduct.CustomFields = allFields;
                selectedProduct.CustomData = liSO; 
            }        
            addMultiProdRequest.selectedProducts.add(selectedProduct);  
        }     
        Apttus_CPQApi.CPQ.AddMultiProductResponseDO addMultiProdResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(addMultiProdRequest);
        return addMultiProdResponse;
    }
    /**
     * online contacts are removed on the basis whether the request has "removeOnlineContact" = true
     * online contacts are added according to the onlinecontactlist present in request
     * 
    */
    public static void addRemoveOnlineContacts(List<OCAddRemoveRequest> ocAddRemoveRequestList){
        Set<String> productIdRemovalSet = new Set<String>();
        List<String> matchKeyList = new List<String>();
        List<String> productIdList = new List<String>();
        //List<String> quoteIdAddList = new List<String>();
        List<Online_Contacts__c> ocInsertList = new List<Online_Contacts__c>();
        List<OCAddRemoveRequest> ocAddRequestList = new List<OCAddRemoveRequest>();
        List<OCAddRemoveRequest> ocRemovalRequestList = new List<OCAddRemoveRequest>();
        Map<String, Product2> productIdRecordAddMap = new Map<String, Product2>();        
        Map<String, Product2> productIdRecordRemoveMap = new Map<String, Product2>();
        Map<String, Apttus_Proposal__Proposal__c> quoteIdRecordMap = new Map<String, Apttus_Proposal__Proposal__c>();
        
        for(OCAddRemoveRequest ocAddRemoveRequest : ocAddRemoveRequestList) {
            if(ocAddRemoveRequest.removeOnlineContact == true) {
                ocRemovalRequestList.add(ocAddRemoveRequest);
                productIdRemovalSet.add(ocAddRemoveRequest.productId);
            } else {
                ocAddRequestList.add(ocAddRemoveRequest);
            }
            productIdList.add(ocAddRemoveRequest.productId);
        }
        
        for(Product2 product : [SELECT Id, ProductCode, APTS_Product_Pricing_Model__c
                                FROM Product2
                                WHERE Id IN :productIdList]) {
            if(productIdRemovalSet.contains(product.Id)) {
                productIdRecordRemoveMap.put(product.Id, product);
            } else {
                productIdRecordAddMap.put(product.Id, product);
            }
        }
        
        for(OCAddRemoveRequest ocAddRemoveRequest : ocRemovalRequestList) {
            String materialNumber = '';
            if(productIdRecordRemoveMap.containsKey(ocAddRemoveRequest.productId)){
                materialNumber = productIdRecordRemoveMap.get(ocAddRemoveRequest.productId).ProductCode;
            }
            matchKeyList.add(ocAddRemoveRequest.quoteId.left(15) + '' + materialNumber);
        }
        System.debug('matchKeyList: ' + matchKeyList);
        for(OCAddRemoveRequest ocAddRemoveRequest : ocAddRequestList) {
            for(OnlineContact oc : ocAddRemoveRequest.onlineContactList) {
                oc.selectedProduct = productIdRecordAddMap.get(ocAddRemoveRequest.productId);
            }
            ocInsertList.addAll(createOCInstanceList(ocAddRemoveRequest)); 
        }
        List<Online_Contacts__c> onlineContactList = new List<Online_Contacts__c>();
         if(Schema.sObjectType.Online_Contacts__c.isAccessible()){ 
            onlineContactList =[SELECT Id, DC_Match_Key__c
                                                    FROM Online_Contacts__c 
                                                    WHERE DC_Match_Key__c IN :matchKeyList];
         }
        System.debug('onlineContactList to be deleted: ' + onlineContactList);
        
        if(!onlineContactList.isEmpty() && Schema.sObjectType.Online_Contacts__c.isDeletable()) {
            Delete onlineContactList;
        }
        
        if(!ocInsertList.isEmpty() && Schema.sObjectType.Online_Contacts__c.isCreateable()) {
            Insert ocInsertList;
        }
        
    }
    /**
     * used for creating list of online contacts that needs to be added 
     * this method is invoked in addRemoveOnlineContacts
     * 
    */
    public static List<Online_Contacts__c> createOCInstanceList(OCAddRemoveRequest ocAddRemoveRequest) {
        List<Online_Contacts__c> ocList = new List<Online_Contacts__c>();
        for(OnlineContact reqOnlineContact : ocAddRemoveRequest.onlineContactList){
            Online_Contacts__c  onlineContact = new Online_Contacts__c();
            onlineContact.Email__c = reqOnlineContact.email;
            onlineContact.ContactID__c = reqOnlineContact.contactId;
            onlineContact.First_Name__c = reqOnlineContact.firstName;
            onlineContact.Last_Name__c = reqOnlineContact.lastName; 
            if(reqOnlineContact.selectedProduct != null) {
                onlineContact.Material__c = reqOnlineContact.selectedProduct.ProductCode;
                onlineContact.Is_Banded_Product__c = reqOnlineContact.selectedProduct.APTS_Product_Pricing_Model__c == 'Banded' ? true : false ;
            }
            onlineContact.ProductId__c = ocAddRemoveRequest.productId;
            onlineContact.QuoteId__c = ocAddRemoveRequest.quoteId; 
            
            //*** START :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
            //onlineContact.Account__c = ocAddRemoveRequest.accountId;
            onlineContact.APTS_Source_System_Detail__c = ocAddRemoveRequest.accountId;
            //*** END :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
            
            onlineContact.Position__c = reqOnlineContact.onlineContactTypeDescription;
                        
            ocList.add(onlineContact);
        }
        return ocList;
    }
    
    /**
     * add a field, value to sObject
     * 
    */
    public static void addToLineItem(Apttus_Config2__LineItem__c obj, String field, String value){
        if(obj.get(field) == null && value != null){
            obj.put(field,value);
        }
    }
    
   public class ProductDetails {
        public String productId;
        public Integer quantity;
    }
    
    public class OnlineContact {
        public String contactId;
        public String firstName;
        public String lastName;
        public String email;
        public String companyId;
        public String sourceId;
        public String onlineContactType;
        public String onlineContactTypeDescription;
        public Boolean allowContactEmails;
        public Product2 selectedProduct;
    }
    
    public class OCAddRemoveRequest {
        public String quoteId;
        public String accountId;
        public String productId;
        public Boolean removeOnlineContact;
        public List<OnlineContact> onlineContactList;
    }
    
}