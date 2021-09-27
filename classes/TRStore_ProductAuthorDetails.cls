/* Class: TRStore_ProductAuthorDetails
* Purpose: This class is for providing the product author details to AEM  as part of TRStore 
* Created: 5-APR-2020
*  
* 
* CHANGE HISTORY
* =============================================================================
* Date           Name           JIRA          Description
* 5-APR-2020   Kanishk        DLT-19888     Created 
* =============================================================================
*/

@RestResource(urlMapping='/AuthorDetails/*')
global with sharing class TRStore_ProductAuthorDetails{

  @Httpget   
    global static void authorDetails(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        string authorNumber = req.params.get('ANum');
        List<String> authorNumberList = new List<String>();
        if(String.isNotBlank(authorNumber)){
            if(authorNumber.split(',')!=null){
                for(string str: authorNumber.split(',')){
                    authorNumberList.add(str);
                }
            }else{
                authorNumberList.add(authorNumber);
            }
            
        }
        JSONGenerator gen = JSON.createGenerator(true);
        LIST<Product_Author__c> productAuthorsList = new LIST<Product_Author__c>();
        
        if(Schema.sObjectType.Product_Author__c.isAccessible()) {
            productAuthorsList = [SELECT Id, Name, Author_Biography__c, Author_ID__c
                                  FROM Product_Author__c 
                                  WHERE Author_ID__c IN: authorNumberList];
                        
         }
         
         List<TRStoreproductDetailsService.productAuthors> paList = new List<TRStoreproductDetailsService.productAuthors>();            
         system.debug(LoggingLevel.Info,'Author List>>>'+productAuthorsList );   
         if(!productAuthorsList.isEmpty()){ // Check the products author list is empty or not 
             
             gen.writeStartObject();  
             gen.writeFieldName('AuthorDetails');
             gen.writeStartArray(); 
             for(Product_Author__c  p : productAuthorsList){
                  
                gen.writeStartObject();
                gen.writeStringField('AuthorId',p.Author_ID__c);
                gen.writeStringField('AuthorName',p.Name);
                gen.writeStringField('SfdcId',p.Id);
                if (p.Author_Biography__c!=null)
                    gen.writeStringField('AuthorDesc',p.Author_Biography__c);
                else
                    gen.writeStringField('AuthorDesc',TRStoreConstants.NOT_AVAILABLE);
                
                gen.writeEndObject();
                
             }
             gen.writeEndArray();
             gen.writeEndObject(); 
             
             TRStoreproductDetailsService.RequestStatus reqStatus = new TRStoreproductDetailsService.RequestStatus();
             reqStatus.statusCode = TRStoreConstants.SUCCESS_CODE;
             reqStatus.statusDesc = TRStoreConstants.DETAILS_FOUND;
             reqStatus.status = TRStoreConstants.SUCCESS_STATUS;
             
        }else{ // Send response as details are not found in salesforce 
                gen.writeStartObject(); 
                gen.writeFieldName('status');
                gen.writeStartObject();
                gen.writeStringField('statusDesc',TRStoreConstants.DETAILS_NOT_FOUND);
                gen.writeStringField('statusCode',TRStoreConstants.DETAILS_NOT_FOUND_CODE);
                gen.writeStringField('status',TRStoreConstants.FAILURESTATUS);
                gen.writeEndObject();
                gen.writeEndObject();
        }
            
        String jsonData = gen.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        try{ 
            RestContext.response.responseBody = Blob.valueOf(jsonData);
        }catch(Exception e){
            system.debug('Exception:'+e);
        }
              
    }

}