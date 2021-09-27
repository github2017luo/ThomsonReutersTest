/* Class: DCPCreateLineQueue
* Purpose: Queueable Job to create line item records
* Created: 07/23/2021
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2021-07-23   Avudaiappan A     DCP-3149   Creating a queueable class to run the rest API for create proposal records in a threshold limit
* =============================================================================
*/
/********************************************************************************************************
    *  @description  DCPCreateLineQueue - QueueJob to Create the line item record in UE Proposal Object
*********************************************************************************************************/
    
public class DCPCreateLineQueue implements Queueable {
    private integer threshold;
      
  /********************************************************************************************************
      *  @description  DCPCreateLineQueue - Constructor
  *********************************************************************************************************/
   
      public DCPCreateLineQueue (){
          
          threshold = Integer.valueof(static_values__c.getValues('LineItemLimit').value__c);
          
      }
  /********************************************************************************************************
      *  @description  execute - Execute method to compile the logic
      *  @param context - batch
  *********************************************************************************************************/
   
      public void execute(QueueableContext context) {
            String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member
          Set<Id> lineIds = new Set<Id>();
          List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
          
           Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c();
              Integer len = 12;
              Blob blobKey = crypto.generateAesKey(128);
              String key = EncodingUtil.convertToHex(blobKey);
              String unqStr = key.substring(0,len);
              prodConfig.Name = 'UE-Dummy-'+unqStr;
              //prodConfig.Apttus_QPConfig__Proposald__c = saveResultList[i].getId();
              prodConfig.Apttus_Config2__BusinessObjectType__c =  'Agreement';
              //prodConfig.Apttus_Config2__PriceListId__c = pli.Id;
              prodConfig.CurrencyIsoCode = 'USD';
              //prodConfig.Apttus_Config2__BusinessObjectRefId__c = saveResultList[i].getId();
              prodConfig.Apttus_Config2__SummaryGroupType__c= 'Ad Hoc';
              //prodConfig.Apttus_Config2__EffectivePriceListId__c = pli.Id;
              prodConfig.Apttus_Config2__Status__c = 'New';
              prodConfig.Apttus_Config2__IsPricePending__c = TRUE;
              prodConfig.Apttus_CQApprov__Approval_Preview_Status__c = 'Complete';
             Database.insert(prodConfig,true);
          for(integer i=0; i<threshold;i++){
              Apttus_Config2__LineItem__c lineSO = new Apttus_Config2__LineItem__c();
              integer count = i+2;
              lineSO.Apttus_Config2__ConfigurationId__c = prodConfig.Id;
              lineSO.Apttus_Config2__PricingStatus__c = 'Pending';
              lineSO.Mark_Removed__c = true;
              lineSO.Apttus_Config2__LineNumber__c = count;
              lineSO.Apttus_Config2__PrimaryLineNumber__c=  lineSO.Apttus_Config2__LineNumber__c;
              lineSO.Apttus_Config2__ItemSequence__c =  lineSO.Apttus_Config2__LineNumber__c;
              lineSO.Apttus_Config2__IsPrimaryLine__c = true;
              //lineSO.Apttus_Config2__PriceListId__c = (pli!=null)?pli.id:null;
              lineItemList.add(lineSO);
          }
          Database.insert(lineItemList,false);
          for(Apttus_Config2__LineItem__c li: lineItemList){
              lineIds.add(li.id);
          }
          DCPCartMultiProductRequestUtility.deleteCart(supportEmail,threshold);
          DCPCartMultiProductRequestUtility.insertCart(lineIds,threshold,supportEmail);
        }
      
  
  }