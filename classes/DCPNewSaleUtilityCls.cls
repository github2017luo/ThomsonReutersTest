/* Class: DCPNewSaleUtilityCls
* Purpose: This class is for holding the reusable codes and constant for new sale codes
* Created: 5/19/2021
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 05/19/2021    Avudaiappan A    DCP-1821     Created 
* 06/15/2021    Avudaiappan A    DCP-2136     Added FinalizeCart & Reprice functions
* =============================================================================
*/
/** 
 * @description : This is the class to have all the reusable code & test factory
 */ 
public with sharing class DCPNewSaleUtilityCls {

    public static string successStatus='Success';
    public static string successCode = '200';
    public static string errorCode = '400';
    public static string failureStatus = 'Failed';
    public static string requiredFieldMissing = 'Required Fields are missing in request.';
    public static string detailsNotFound = 'Details are not found';
    public static string successStatusOne = '209';
    public static string detailsFound = 'Details are found';
    public static string notAvail = 'N/A';
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member

 /** 
 * @description : This is the class to structure the response Array
 */    
    public class Response
    {
        public string status;
        public string statusMsg;
        public string statusCode;
    }
 /********************************************************************************************************
*  @description  responseMethod - This is the main method to handle the response  
*  @return DCPNewSaleUtilityCls.response : this is a return statement and having return result as failure or success  
*  @param statusCode - expected the statusCode parameters 
*  @param statusMsg - expected the statusMsg parameters 
*  @param status - expected the product status parameters 
*********************************************************************************************************/
   
    public static DCPNewSaleUtilityCls.response responseMethod(String statusCode, String statusMsg, String status){
        DCPNewSaleUtilityCls.response res = new DCPNewSaleUtilityCls.response();
        res.statusCode = statusCode;
        res.statusMsg = statusMsg;
        res.status = status;
        return res;
    }
   /********************************************************************************************************
*  @description  logException - This is the main method to handle the exception and log it
*  @param errorMap - expected the error info parameters 
*********************************************************************************************************/
     
    public static void logException(Map<String,String> errorMap){
        try{
            integration_Logger__c intLog = new Integration_Logger__c();
            intLog.Object_Name__c = errorMap.get('objectName');
            intLog.Exception_Message__c = errorMap.get('expMsg');
            intLog.Request_Message__c = errorMap.get('reqMsg');
            intLog.Request_Type__c = errorMap.get('requestType');
            intLog.Service_Name__c = errorMap.get('webServiceName');
            intLog.Exception_Module__c = errorMap.get('module');
            intLog.Object_Id__c = errorMap.get('recId');
            intLog.Support_Email__c = errorMap.get('supportEmail');
            intLog.Is_Escalated_to_Support__c = boolean.valueOf(errorMap.get('toSupport'));  
            
            database.saveResult intLoggerSave = database.insert(intLog,false); 
            system.debug(LoggingLevel.INFO,'Integer:'+intLoggerSave);    
            if((errorMap.get('objectName')).contains('Lead')){
                Database.update(new Lead(ID=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }else if((errorMap.get('objectName')).contains('Quote/Proposal')){
                Database.update(new Apttus_Proposal__Proposal__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }else if((errorMap.get('objectName')).contains('Product Configuration')){
                Database.update(new Apttus_Config2__ProductConfiguration__c(Id=errorMap.get('recId'), TRStore_Exception__c=intLog.id));
            }
            system.debug(loggingLevel.INFO,'Integration logger record created');
        } catch(Exception e){
            system.debug(loggingLevel.INFO,'TRS Exception >>'+e);
        }
    }  
     /********************************************************************************************************
*  @description  createProduct - This is the test factory method to handle the product creation
*   @param productCode - requires prductCode as input params
*  @return Product2
*********************************************************************************************************/  
    public static Product2 createProduct(String productCode){
        product2 productSO = new product2();
        productSO.Name = 'Test Product';
        productSO.ProductCode = productCode; //'42015055';
        productSO.Description = 'Test Desc';
        productSO.Service_Number__c = '87654';
        productSO.product_offering__c = 'Westlaw Classic';
        productSO.Apttus_Filter_Jurisdiction__c = 'Alabama';
        productSO.Practice_Area__c ='General';
        productSO.APTS_Media_High_Level_Code__c = '21';
        productSO.APTS_Item_Category_Group__c = 'ZVSU';
        productSO.APTS_Media_Lower_Level_Code__c = '11';
        productSO.LCRM_Sub_Bu__c = 'USL';
        productSO.Format__c= 'Format';
        productSO.IsActive = true;
        productSO.Apttus_Config2__HasOptions__c = true;
        productSO.Apttus_Config2__HasAttributes__c = true;
        productSO.Apttus_Config2__HasDefaults__c = false;
        productSO.CPD_Sellable_Description__c ='Display and Sell';
        return productSO;
    }
     /********************************************************************************************************
*  @description  createProduct - This is the test factory method to handle the priceList creation
*  @param name - expected the name parameters 
*  @return Apttus_Config2__PriceList__c
*********************************************************************************************************/    
    public static Apttus_Config2__PriceList__c createPriceList(String name){
        return new Apttus_Config2__PriceList__c(Name = name);
    }
      /********************************************************************************************************
*  @description  createPLI - This is the test factory method to handle the priceListItem creation
*  @param priceListId - expected the PLI parameters 
*  @param productId - expected the product parameters 
*  @return Apttus_Config2__PriceListItem__c
*********************************************************************************************************/ 
    public static Apttus_Config2__PriceListItem__c createPLI(String priceListId,String productId){
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO.Apttus_Config2__PriceListId__c = priceListId;
        pliSO.Apttus_Config2__ProductId__c = productId;
        pliSo.Apttus_Config2__ChargeType__c = 'Standard Price';
        pliSO.Apttus_Config2__PriceType__c = 'One time';
        pliSO.Apttus_Config2__Frequency__c = 'One time';
        pliSO.Apttus_Config2__ListPrice__c = 250;
        return pliSO;
    }
        /********************************************************************************************************
*  @description  createPD - This is the test factory method to handle the price dimension creation
*  @param field1 - expected the field parameters 
*  @return Apttus_Config2__PriceDimension__c
*********************************************************************************************************/ 
    public static Apttus_Config2__PriceDimension__c createPD(string field1){
        Apttus_Config2__PriceDimension__c pd= new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__lineitem__c',Apttus_Config2__Datasource__c = field1,Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Line Item');
        return pd;
    }
        /********************************************************************************************************
*  @description  createPM - This is the test factory method to handle the priceMatrix creation
*  @param pd - expected the pricedimension parameters 
*  @param pd1 - expected the pricedimension1 parameters 
*  @param pli - expected the pli parameters 
*  @return Apttus_Config2__PriceList__c
*********************************************************************************************************/ 
   
    public static Apttus_Config2__PriceMatrix__c createPM(string pd, string pd1,string pli){
        Apttus_Config2__PriceMatrix__c pm = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__Dimension1Id__c=pd,Apttus_Config2__Dimension1ValueType__c='Discrete',
                                                                                Apttus_Config2__Dimension2Id__c=pd1,Apttus_Config2__Dimension2ValueType__c='Discrete',
                                                                                Apttus_Config2__EnableDateRange__c =false, Apttus_Config2__EnableUsageIndexing__c=false,Apttus_Config2__IsCumulativeRange__c=false,Apttus_Config2__MatrixType__c='Dimension',
                                                                                Apttus_Config2__PriceListItemId__c =pli,Apttus_Config2__Sequence__c=1,Apttus_Config2__StopProcessingMoreMatrices__c=false);
        return pm;
    }
     /********************************************************************************************************
*  @description  createPME - This is the test factory method to handle the priceMatrixEntry creation
*  @param pm - expected the priceMatrixId parameters 
*  @param segment - expected the segment parameters
*  @return Apttus_Config2__PriceMatrixEntry__c
*********************************************************************************************************/ 
     
    public static Apttus_Config2__PriceMatrixEntry__c createPME(String pm,String segment){
        Apttus_Config2__PriceMatrixEntry__c pme = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__AdjustmentAmount__c=90,Apttus_Config2__AdjustmentType__c='List Price Override',
                                                                                          Apttus_Config2__Dimension1Value__c ='1',Apttus_Config2__Dimension2Value__c =segment,Apttus_Config2__IsIncluded__c=false, Apttus_Config2__PriceMatrixId__c=PM,
                                                                                          Apttus_Config2__Sequence__c=1);
        return pme;
    }
      /********************************************************************************************************
*  @description  createPlatform - This is the test factory method to handle the productplatform creation
*  @return Product_Platform__c
*********************************************************************************************************/ 
        
    public static Product_Platform__c createPlatform(){
        Product_Platform__c pp = new Product_Platform__c(Platform__c='WestLaw',Platform_Category__c='Test',Platform_Category_Benefit__c='Test',Platform_Category_Feature__c='Test',Platform_Group__c='Test');
        return pp;
    }
       /********************************************************************************************************
*  @description  createPlatformValue - This is the test factory method to handle the productplatform value creation
*  @param prodId - expected the productId parameters 
*  @param ppId - expected the product platform Id parameters
*  @return Product_Platform_Value__c
*********************************************************************************************************/ 
      
    public static Product_Platform_Value__c createPlatformValue(String prodId,String ppId){
        return new Product_Platform_Value__c(Product__c=prodId,Product_Platform__c =ppId);
    }
   
          /********************************************************************************************************
*  @description  handleEmptyString - This is the method to replace empty string with NA
*  @param source - expected the source field parameters 
*  @param target - expected the target field parameters
*  @return string
*********************************************************************************************************/ 
   
    public static string handleEmptyString(String source, String target){
        String returnString = source;
        if(String.isBlank(returnString) && String.isBlank(target)){
            returnString = DCPNewSaleUtilityCls.notAvail;
        }else if(String.isBlank(returnString)){
            returnString = target;
        }
        return returnString;
    }
    



/********************************************************************************************************
*  @description - finalizeCart: This method will finalize the Product Configuration/Cart Record
*  @param cartId - cartId
*********************************************************************************************************/ 
    public static void finalizeCart(Id cartId){
        system.debug(LoggingLevel.INFO,'cart id..'+cartId);
        if(cartId != null){
            try{
                Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
                system.debug(LoggingLevel.INFO,'Requestcart..'+request);
                request.CartId = cartId;
                Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
                system.debug(LoggingLevel.INFO,'Response..'+response);
                if(response.IsSuccess){
                    system.debug(LoggingLevel.INFO,'Finalize success');
                    //submitTRStoreOrder(quoteId);
                }
                
            }
            catch(Exception ex){
                system.debug(LoggingLevel.INFO,'Exception came : Finalize ...........'+ex);
                Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>String.valueof(ex.getLineNumber())+','+ex.getMessage(),'webServiceName'=>'FinalizeCart','requestType'=>'Finalize Cart from Class DCPQuoteSyncupController','reqMsg'=>ex.getStackTraceString(),'module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'false'};
                DCPNewSaleUtilityCls.logException(errorHandlerMap);
            }
            
        }
        
    }
    /********************************************************************************************************
*  @description  repriceCart - This is a main method to reprice cart 
*  @return string   : this is a return statement after maniplate line items 
*  @param cartId - expected cart id for reprice cart 
*********************************************************************************************************/   
  public static String repriceCart(String cartId) {

    String isPending;
    Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
    objUpdatePriceRequestDO.CartId = cartId;
    Apttus_CpqApi.CPQ.UpdatePriceResponseDO result;
    try {
      result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
      isPending = string.valueOf(result.IsPricePending);
    } catch (Exception e) {
        if(cartId!=null){
              Map<String,String> errorHandlerMap = new Map<String,String>{'objectName'=>'Product Configuration','expMsg'=>e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString(),'webServiceName'=>'CartManipulationAPI','requestType'=>'Reprice Issue','reqMsg'=>'Exception Class Name: DCP_CartPriceRequest','module'=>'UEStore','recId'=>cartId,'supportEmail'=>supportEmail,'toSupport'=>'true'};
              DCPNewSaleUtilityCls.logException(errorHandlerMap);
        }
        isPending = 'Reprice Exception';
    }
     
   return isPending;
  }
    
}