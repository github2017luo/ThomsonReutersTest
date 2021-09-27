@isTest(seeAllData=false)
public class TRstoreOrderConfirmationFrenchConTest {


    public static testmethod void method1(){
        Pricebook2 pbook = new Pricebook2();
        pbook.name =  'GLI Price Book - US Legal/LMS';        
        pbook.IsActive = true;
        insert pbook;
        
        Product2 prodObj = new Product2();
          prodObj.Name = 'Network Services 1.0';
          prodObj.APTS_Media_High_Level_Code__c = '08';
          prodObj.APTS_Media_Lower_Level_Code__c = 'BB';
          prodObj.APTS_Corporate_Select__c = 'Primary Essentials';
          prodobj.ProductCode='30790769'; 
         
         insert prodObj;
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>();
        Static_Values__c ibr = new Static_Values__c(name='International best Rate', value__c='International best Rate');
        Static_Values__c ibrf = new Static_Values__c(name='International best RateFr', value__c='International best RateFr');
        Static_Values__c ier = new Static_Values__c(name='International Expedited Rate', value__c='International Expedited Rate');
        Static_Values__c ierf = new Static_Values__c(name='International Expedited RateFr', value__c='International Expedited Ratefr');
        staticCSList.add(ibr);
        staticCSList.add(ibrf);
        staticCSList.add(ier);
        staticCSList.add(ierf);
        insert staticCSList;
        
           Apttus_Config2__ProductTranslation__c pt = new Apttus_Config2__ProductTranslation__c();
          pt.name = 'testval';
          pt.Apttus_Config2__ProductId__c = prodObj.id;
          pt.Apttus_Config2__Language__c = 'French';
          insert pt;
        
        
        Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
        priceListObj.Name = 'Thomson Reuters Master - US Legal';
        insert priceListObj;
        
        Apttus_Proposal__Proposal__c propObj = new Apttus_Proposal__Proposal__c();
        propObj.Apttus_QPConfig__PriceListId__c = priceListObj.ID;
        propObj.APTS_Ground_Shipping__c = 'International best Rate';
        insert propObj;
        
        Apttus_Config2__ProductConfiguration__c prodConfig = APTS_TestDataFactory.createProductConfiguration(propObj.Id);
        //prodConfig.APTS_SSD_Sold_To__c = accountSSD.Id;
        insert prodConfig;
        
          Apttus_Proposal__Proposal_Line_Item__c pl1 = new Apttus_Proposal__Proposal_Line_Item__c(          
          Apttus_Proposal__Quantity__c=1,
          Apttus_QPConfig__ConfigurationId__c = prodConfig.id, 
          Apttus_QPConfig__LineType__c = 'Product/Service',
          Apttus_QPConfig__LineNumber__c = 1, 
          Apttus_QPConfig__ItemSequence__c = 1,
          Apttus_QPConfig__NetPrice__c=1,
          APTS_Corporate_Select__c = 'Primary',
          Apttus_Proposal__Product__c = prodObj.id,
          Apttus_Proposal__Proposal__c=propObj.id);
        
          insert pl1;
          
          
          TRstoreOrderConfirmationFrenchCon  ocf = new TRstoreOrderConfirmationFrenchCon();
          
          ocf.proposalRecId = propObj.id;
          //ocf.getproposalRecId();
          
    }



}