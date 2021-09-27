/*
* CHANGE HISTORY
* ==================================================================================================================================
* Date         Name                  Description
* 2018-05-31   Rajan Tatuskar        DLT-9839 - [SLF] Reassign users link on Confirmation page (up-sell only)
* 2018-06-15   Rajan Tatuskar        DLT-9752 - Updates Account/Contact reference For Classes mentioned
* 2018-08-09   Rajan Tatuskar        DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
* 2018-10-16   Rajan Tatuskar        DLT-12938 - Fixed issue : Number of Users not getting updated correctly on confirmation page
* 2018-10-19   Rajan Tatuskar        DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
* 2018-11-06   Rajan Tatuskar        DLT-13389 - Defect : Add on page - Per seat not working 
* 2018-12-20   Benjamin Her          DLT-14153 - Code Scan fixes
* 2019-01-10   Bishanka Dassarma     DLT-14347 - Code Scan Fixes
* 2019-02-14   Navleen Kaur          DLT-14618 - [All] Digital firm should be populated based Firm type in automation feed/file
* 2019-06-25   Pavithra              DLT-16916 - [Tech Story] [Code Scan] - Fix code scan MINOR issues in DCAddOnProducts, DCAddRemoveAddOns, DCAddRemoveAddOns_Test, DCAddRemoveOnlineContacts, DCAddRemoveOnlineContacts_Test
* 2019-06-24   Srikanth kota         DLT-16787 - [Code Scan] -Fix code scan MAJOR issues in this DCAcceptQuoteTest ,DCAddRemoveAddOns, DCAddRemoveOnlineContacts
* 2020-03-31   Brenda Shields        DLT-19862 - Set OLC based on Product Detail.  Add logic to use Product configuration type and PLI Service Number Override to correctly set OLCs
==================================================================================================================================   
*/

@RestResource(urlMapping='/digitalconfigurator/DCAddRemoveOnlineContacts/*')
Global with sharing class DCAddRemoveOnlineContacts {
    //*** START :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
    private static Final String LINE_STATUS_CANCELLED = 'Cancelled';
    private static Final String CART_STATUS_FINALIZED = 'Finalized';
    private static Final String PRODUCT_PRICING_MODEL_BANDED = 'Banded';
    private static final string PRODUCT_BUNDLE_CONFIG_TYPE = 'Bundle';
    //*** END :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
    /**
	* The API used to Add or Remove online contacts for specific product and quote.
	*/ 
    @HttpPost
    global static OLCResponse addRemoveOnlineContacts(OLCRequest updateDetails){
        OLCResponse response = new OLCResponse();
        System.debug('----Inside addRemoveOnlineContacts----updateDetails -----------'+ updateDetails);
        if(updateDetails == null){
            response.responseCode = 400;
            response.responseMessage = 'Invalid Parameters';
            return response;
        }
        try{
            //DCAddRemoveOnlineContacts service = new DCAddRemoveOnlineContacts();
            //response = service.updateOnlineContacts(updateDetails); 
            response = updateOnlineContacts(updateDetails); 
            return response;
            
        }catch(Exception ex){
            response = new OLCResponse();
            response.responseCode = 400;
            response.responseMessage = ex.getMessage();
            DCUtils.trackLog(ex,'DCAddRemoveOnlineContacts','updateOnlineContacts');
            return response;
        }
    }
    
    public static OLCResponse updateOnlineContacts(OLCRequest updateDetails){
        set<string> setProdIDs = new set<string>();
        set<string> setBundleProds = new set<string>();
        map<id, string> mapProdServ = new map<id, string>();
        list<Product2> lstProducts = new list<Product2>();
        list<Apttus_Proposal__Proposal_Line_Item__c> lstQuoteLineItems = new list<Apttus_Proposal__Proposal_Line_Item__c>();
        OLCResponse response = new OLCResponse();
        
        try{
           
            System.debug('----Inside updateOnlineContacts----updateDetails -----------'+ updateDetails);
            if (String.isNotBlank(updateDetails.quoteId) && updateDetails.productDetails != null) { //String.isNotBlank(updateDetails.materialNumber)){
                
                if(!Schema.sObjectType.Online_Contacts__c.isAccessible()){
                    throw new DCCustomException(UserInfo.getName()+' does not have access to: Online_Contacts__c');
                }  

                // Delete all Online Contacts for this quote - updated per DLT-19862
                if(!updateDetails.onlineContacts.isEmpty()){
                    List<Online_Contacts__c> onlineContactList = [SELECT Id, Name, Account__c, Email__c, ContactID__c, First_Name__c, Is_Banded_Product__c, Last_Name__c, Material__c, ProductId__c, Middle_Name__c, QuoteId__c, QuoteLineItem__c, SAP_Account_Number__c, Account_Address__c, WLEc_Juris__c, Type__c, Sftwr_Admin__c, Product_Attribute__c 
                    												FROM Online_Contacts__c 
                    												WHERE QuoteId__c =: updateDetails.quoteId];
                    												// AND (Material__c =: updateDetails.materialNumber)];
                    
                    System.debug('Existing onlineContactList to be deleted -----------'+ onlineContactList);
                    
                    if(!onlineContactList.isEmpty()){
                        if(Schema.SObjectType.Online_Contacts__c.isDeletable()){
                            Delete onlineContactList;
                        }
                    }
                    
                    List<Online_Contacts__c> onlineContactInsert = new List<Online_Contacts__c>();
                    List<OnlineContacts> wrapList = new List<OnlineContacts>();
                    
                    wrapList.addAll(updateDetails.onlineContacts);
                    System.debug('wrapList------------  '+ wrapList);
                    
                    if(!Schema.sObjectType.Product2.isAccessible()){
                        throw new DCCustomException(UserInfo.getName()+' does not have access to: Product2');
                    }  
                    // get a list of Product ids to select all products - updated per DLT-19862
	               	if (updateDetails.productDetails != null) {
    	            	for(ProductDetails prod : updateDetails.productDetails) {
        	            	setProdIDs.add(prod.productId);
            	        }
                	}
                    // Add Configuration Type to query - updated per DLT-19862
                    lstProducts = [Select Id, ProductCode, APTS_Product_Pricing_Model__c, Apttus_Config2__ConfigurationType__c 
                    					FROM Product2 
                   						WHERE Id in : setProdIDs];  //ProductCode =: updateDetails.materialNumber 
                   						
					// If Configuration Type is Bundle - query QLI - updated per DLT-19862
					for (Product2 prodRec : lstProducts) {
						If (prodRec.Apttus_Config2__ConfigurationType__c == PRODUCT_BUNDLE_CONFIG_TYPE) {
							setBundleProds.add(prodRec.ID);						
						}
                	}
  					// get Quote line items for the quote to check for bundled override flag - updated per DLT-19862
                    if(setBundleProds != Null && setBundleProds.size() > 0) {
                    	if (!Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible()){
                        	throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Proposal__Proposal_Line_Item__c');
                    	} else {
                    		lstQuoteLineItems = [Select Id, Apttus_Proposal__Product__c, APTS_Service_Number_Override__c 
                    								FROM Apttus_Proposal__Proposal_Line_Item__c 
                    								WHERE Apttus_Proposal__Proposal__c =:updateDetails.quoteId and
                    								APTS_Service_Number_Override__c != null];
                    	}	 
                    }
                    if (lstQuoteLineItems != Null && lstQuoteLineItems.size() > 0) {
                     	for (Apttus_Proposal__Proposal_Line_Item__c quoteLineItemRec : lstQuoteLineItems) {
                     		mapProdServ.put(quoteLineItemRec.Apttus_Proposal__Product__c, quoteLineItemRec.APTS_Service_Number_Override__c);
                     	}
                    }
                                						
                    //*** START :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
                    //Apttus_Proposal__Proposal__c proposal = [Select Id, Account__c FROM Apttus_Proposal__Proposal__c WHERE Id =:updateDetails.quoteId LIMIT 1];
                    if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible()){
                        throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Proposal__Proposal__c');
                    }  
                    Apttus_Proposal__Proposal__c proposal = [Select Id, APTS_SSD_Sold_To__c FROM Apttus_Proposal__Proposal__c WHERE Id =:updateDetails.quoteId LIMIT 1];
                    //*** END :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
            	
            	
            		// for each product, create oline contacts
            		for (Product2 prod : lstProducts) {
            			if (prod.Apttus_Config2__ConfigurationType__c != PRODUCT_BUNDLE_CONFIG_TYPE || 
            				(prod.Apttus_Config2__ConfigurationType__c == PRODUCT_BUNDLE_CONFIG_TYPE && mapProdServ.get(prod.Id) != null)) {
                    		for (OnlineContacts obj: wrapList) {
                        		Online_Contacts__c  onc = new Online_Contacts__c();
                        		onc.Email__c = obj.email;
                        		onc.ContactID__c = obj.contactId;
                        		onc.First_Name__c = obj.firstName;
                        		onc.Last_Name__c = obj.lastName; 
                        		if (prod.Apttus_Config2__ConfigurationType__c == PRODUCT_BUNDLE_CONFIG_TYPE) {
                        			onc.Material__c = mapProdServ.get(prod.Id);
                        		} else {
                        			onc.Material__c = prod.ProductCode;
                        		}
                        		onc.ProductId__c = Prod.id;
  		                    	onc.Is_Banded_Product__c  =  prod.APTS_Product_Pricing_Model__c == PRODUCT_PRICING_MODEL_BANDED ? true : false ;
  		                	    //onc.ProductId__c = product.Id;
                		        onc.QuoteId__c = proposal.Id; 
    	   		                //onc.Type__c = obj.onlineContactType;
  			                    //*** START :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
       			                //onc.Account__c = proposal.Apttus_Proposal__Account__c;
       			                onc.APTS_Source_System_Detail__c = proposal.APTS_SSD_Sold_To__c;
       			                //*** END :: Added by Rajan :: DLT-9752 - Updates Account/Contact reference For Classes mentioned
        		                onc.Position__c = obj.onlineContactTypeDescription;
                        		/*
								if(onc.Type__c == 'Admin') 
									onc.Sftwr_Admin__c = True;
								else
									onc.Sftwr_Admin__c = False;
								*/
                        		onlineContactInsert.add(onc);
                    		}
            			} 
          			}
            
                    System.debug('onlineContactInsert ----'+ onlineContactInsert);
                    if(!onlineContactInsert.isEmpty()) {
                        if(Schema.SObjectType.Online_Contacts__c.isCreateable()){
                            insert onlineContactInsert;
                        }
                    }
                }else{
                    response.responseCode = 400;
                    response.responseMessage = 'No Online Contacts to add/update.';
                    return response;
                }
                //*** START :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
                Boolean isSucess;
                if(!updateDetails.productDetails.isEmpty()){
                    isSucess = updateProdQuantity(updateDetails);
                }
                //*** END :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
                
                //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
                if(isSucess){
                    response.responseCode = 200;
                    response.responseMessage = 'Success';    
                }else{
                    response.responseCode = 400;
                    response.responseMessage = 'Unable to update Product Quantity.';
                    createExceptionLog('Unable to update Product Quantity.', 'Missing required data', 'Class:DCAddRemoveOnlineContacts > Method:updateProdQuantity');
                }
                //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
            }else{
                response.responseCode = 400;
                response.responseMessage = 'Invalid Parameters - QuoteId or Product Details is blank';
                createExceptionLog('Invalid Parameters - QuoteId or Product Details is blank.', 'Missing required data', 'Class:DCAddRemoveOnlineContacts > Method:updateOnlineContacts');
            }
            return response;
            //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        }catch(Exception ex){
            throw ex;
        }
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
    }
    
    //*** START :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
    public static Boolean updateProdQuantity(OLCRequest updateDetails){
    	Boolean isUpdated = false;
        try{
            System.debug('----Inside updateProdQuantity----updateDetails -----------'+ updateDetails);
            List<Apttus_Config2__LineItem__c>  updateItems = new List<Apttus_Config2__LineItem__c>();
            if(!Schema.sObjectType.Apttus_Config2__ProductConfiguration__c.isAccessible()){
                throw new DCCustomException(UserInfo.getName()+' does not have access to: Apttus_Config2__ProductConfiguration__c');
            }  
            if(updateDetails != null && String.isNotBlank(updateDetails.quoteId)){
                List<Apttus_Config2__ProductConfiguration__c> carts = [SELECT Id, Apttus_QPConfig__Proposald__c, 
                                                                       (SELECT Id, Name, Apttus_Config2__ProductId__c, Apttus_Config2__PrimaryLineNumber__c,
                                                                        Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c, Apttus_Config2__ProductId__r.ProductCode, 
                                                                        Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c,
                                                                        Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c, Apttus_Config2__Quantity__c, 
                                                                        Apttus_Config2__NetPrice__c, APTS_Contract_Term__c, APTS_Yr_1_Renewal_Adjustment__c,
                                                                        APTS_Years_2_Plus_Adjustment__c, APTS_Bridge_Discount__c, APTS_Bridge__c
                                                                        FROM Apttus_Config2__LineItems__r 
                                                                        WHERE Apttus_Config2__LineStatus__c != :LINE_STATUS_CANCELLED  ) 
                                                                       FROM Apttus_Config2__ProductConfiguration__c 
                                                                       WHERE Apttus_QPConfig__Proposald__c =: updateDetails.quoteId 
                                                                       AND Apttus_Config2__Status__c =: CART_STATUS_FINALIZED];
                
                if(!carts.isEmpty()){
                    Apttus_Config2__ProductConfiguration__c cart = carts[0];
                    system.debug('----Rajan---cart-------' + cart);
                    for(Apttus_Config2__LineItem__c line : cart.Apttus_Config2__LineItems__r) {
                        system.debug('----Rajan---final code started----line---' + line);
                        //*** START :: Added by Rajan :: DLT-12938 - Fixed issue : Number of Users not getting updated correctly on confirmation
                        // Bundle products don't have pricing model - udpated per DLT-19862
                        if(updateDetails.productDetails != null && 
                        	(line.Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c == PRODUCT_BUNDLE_CONFIG_TYPE ||
                        	(!(PRODUCT_PRICING_MODEL_BANDED.equalsIgnoreCase(line.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c))))){
                            for(ProductDetails prod : updateDetails.productDetails){
                                if(line.Apttus_Config2__ProductId__c == prod.productId){
                                    line.Apttus_Config2__Quantity__c = prod.productQuantity;
                                    updateItems.add(line);
                                    system.debug('----Rajan---final update done----line---' + line);
                                }
                            }
                        }
                        //*** END :: Added by Rajan :: DLT-12938 - Fixed issue : Number of Users not getting updated correctly on confirmation 
                    }
                    system.debug('----Rajan---updateItems-------' + updateItems);
                    //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
                    
                    if(!updateItems.isEmpty() && Schema.sObjectType.Apttus_Config2__LineItem__c.isUpdateable()){
                        update updateItems;
                    }
                    //*** START :: Added by Rajan :: DLT-13389 - Defect : Add on page - Per seat not working
                    /*else{
					return false;
					}*/
                }
                /*else{
				return false;
				}*/
                //*** END :: Added by Rajan :: DLT-13389 - Defect : Add on page - Per seat not working
            }else{
                return isUpdated;
            }
            
            isUpdated = true;
            return isUpdated;
            
        }catch(Exception ex){
            //throw ex;
            createExceptionLog(ex.getMessage(), ex.getStackTraceString(), String.valueof(ex.getLineNumber())+String.valueof(ex.getCause()));
        }
        //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
        return isUpdated;
    }
    //*** END :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
    
    //*** START :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
    public static Digital_Exception_Log__c createExceptionLog(String exMessage, String exType, String additionalInfo) {
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        //ex.User_Message__c = userMessage;
        //ex.Class_Reference__c = classRef ;
        //ex.Object__c = obj;
        //ex.Record_Id__c = recordId;     
        if(!Schema.sObjectType.Digital_Exception_Log__c.isAccessible()){
            throw new DCCustomException(UserInfo.getName()+' does not have access to: Digital_Exception_Log__c');
        }  
        if(Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            insert ex;
        }
        return ex;
    }
    //*** END :: Added by Rajan :: DLT-12934 - Handle Exception for "DCAddRemoveOnlineContacts" and "DCAddRemoveAddOns"
    
    
    global class OLCRequest{
        global String quoteId;
        //global String productId;
        global String materialNumber;
        global List<OnlineContacts> onlineContacts;
        //*** START :: Added by Rajan :: DLT-11652 - Merge services
        global List<ProductDetails> productDetails;
        //*** END :: Added by Rajan :: DLT-11652 - Merge services
    }
    
    global class OnlineContacts {
        private String contactId;
        public String firstName;
        public String lastName;
        private String email;
        //public String companyId;
        //public String sourceId;
        //public String onlineContactType;
        private String onlineContactTypeDescription;
        //public Boolean allowContactEmails;
    }
    
    //*** START :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
    global class ProductDetails {
        public String productId;
        public Integer productQuantity;
    }
    //*** START :: Added by Rajan :: DLT-11652 - Merge services performCartUpdate, DCAddRemoveAddOns and DCAddRemoveOnlineContacts
    
    global class OLCResponse{
        global Integer responseCode;
        global String responseMessage;
    }
}