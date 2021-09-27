/* Class: TRStoreProductPricingServiceTest
* Purpose: Coverage for  Class TRStoreProductPricingService (Rest API Service to bring the JSON formatted Pricing related Apttus objects for products)
* Created: 01/02/2020
* Author: Avudaiappan A
* 
* CHANGE HISTORY
* =============================================================================
* Date         Name             JIRA        Description
* 2020-01-02   Avudaiappan A     DLT-19171   Test Coverage Started
* 2020-10-21   Avudaiappan A     DUE-5665    Test Coverage for Bundle Child Changes
* 2020-12-28   Avudaiappan A  DUE-7561   Publisher remapped to product Offering
* =============================================================================
*/
@isTest(seeAllData = False)
public class TRStoreProductPricingServiceTest {
    
    /** 
    * @description : Prepare test data
    */ 
    public static testMethod void testData(){
        
        LIST<Static_Values__c> staticCSList = new LIST<Static_Values__c>{new Static_Values__c(name='PriceListName', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='CanadaSubBU', value__c='CANADA'),
            new Static_Values__c(name='TRStorePricelistCA', value__c='Thomson Reuters Master - Canada'),
            new Static_Values__c(name='USSubBU', value__c='USL'),
            new Static_Values__c(name='TRStorePricelistUS', value__c='Thomson Reuters Master - US Legal'),
            new Static_Values__c(name='sellableFlagValues' , value__c='Display and Sell'),
            new Static_Values__c(name='TrstorePDPJsonSchedulehrs' , value__c='1'),
            new Static_Values__c(name='PDPCurrentVersion' , value__c='v1'),
            new Static_Values__c(name='USLSellableFlags' , value__c='Display and Sell,Display But Do Not Sell'),
            new Static_Values__c(name='TRStoreCollateral' , value__c='Release Note,Index,Table of Contents'),
            new Static_Values__c(name='TRStoreFeaturesToExclude' , value__c='Table of content,IndexFileName,ReleaseFileName,IndexNote,ReleaseNote,TOCFileName'),
            new Static_Values__c(name='TRStoreFeatureSetToInclude' , value__c='Hardcover Specifications,Microsite Specifications,Formats,Taxcode Specifications,eBook'),
            new Static_Values__c(name='Release Note' , value__c='Release note'),
            new Static_Values__c(name='Index' , value__c='Index'),
            new Static_Values__c(name='GPPCheck' , value__c='Enabled'),
            new Static_Values__c(name='TransactSellableFlag' , value__c='Display and Sell,Display But Do Not Sell'), //Change Start and End - DCP-1338//
            new Static_Values__c(name='TransactDisplayProducts' , value__c='Display But Do Not Sell'), //Change Start and End - DCP-1382//
            new Static_Values__c(name='Table of Contents' , value__c='Table of contents')};
                
            insert staticCSList;
        
        LIST<Product_Pricing_Field__c> productPricingMidelList = new LIST<Product_Pricing_Field__c>{new Product_Pricing_Field__c(Name='ProdRec1',Field_API_Name__c='APTS_Media_High_Level_Code__c',Object_Name__c='Product2',Service_Field_Name__c='MediaHighLevelCode'),
            new Product_Pricing_Field__c(Name='ProdRec2',Field_API_Name__c='APTS_Product_Pricing_Model__c',Object_Name__c='Product2',Service_Field_Name__c='ProductPricingModel'),
            new Product_Pricing_Field__c(Name='ProdRec3',Field_API_Name__c='Apttus_Config2__ConfigurationType__c',Object_Name__c='Product2',Service_Field_Name__c='ConfigurationType'),
            new Product_Pricing_Field__c(Name='ProdRec4',Field_API_Name__c='Apttus_Config2__HasAttributes__c',Object_Name__c='Product2',Service_Field_Name__c='HasAttributes'),
            new Product_Pricing_Field__c(Name='ProdRec5',Field_API_Name__c='Apttus_Config2__HasDefaults__c',Object_Name__c='Product2',Service_Field_Name__c='HasDefaults'),
            new Product_Pricing_Field__c(Name='ProdRec6',Field_API_Name__c='Apttus_Config2__HasOptions__c',Object_Name__c='Product2',Service_Field_Name__c='HasOptions'),
            new Product_Pricing_Field__c(Name='ProdRec7',Field_API_Name__c='Apttus_Config2__Uom__c',Object_Name__c='Product2',Service_Field_Name__c='Uom'),
            new Product_Pricing_Field__c(Name='ProdRec8',Field_API_Name__c='Apttus_Filter_Jurisdiction__c',Object_Name__c='Product2',Service_Field_Name__c='Jurisdiction'),
            new Product_Pricing_Field__c(Name='ProdRec9',Field_API_Name__c='Description',Object_Name__c='Product2',Service_Field_Name__c='Description'),
            new Product_Pricing_Field__c(Name='ProdRec10',Field_API_Name__c='Family',Object_Name__c='Product2',Service_Field_Name__c='Family'),
            new Product_Pricing_Field__c(Name='ProdRec11',Field_API_Name__c='Format__c',Object_Name__c='Product2',Service_Field_Name__c='ProductFormat'),
            new Product_Pricing_Field__c(Name='ProdRec12',Field_API_Name__c='Id',Object_Name__c='Product2',Service_Field_Name__c='Id'),
            new Product_Pricing_Field__c(Name='ProdRec13',Field_API_Name__c='IsActive',Object_Name__c='Product2',Service_Field_Name__c='IsActive'),
            new Product_Pricing_Field__c(Name='ProdRec14',Field_API_Name__c='LCRM_Sub_Bu__c',Object_Name__c='Product2',Service_Field_Name__c='LCRM'),
            new Product_Pricing_Field__c(Name='ProdRec15',Field_API_Name__c='Name',Object_Name__c='Product2',Service_Field_Name__c='Name'),
            new Product_Pricing_Field__c(Name='ProdRec16',Field_API_Name__c='ProductCode',Object_Name__c='Product2',Service_Field_Name__c='ProductCode'),
            new Product_Pricing_Field__c(Name='ProdRec17',Field_API_Name__c='Service_Number__c',Object_Name__c='Product2',Service_Field_Name__c='ServiceNumber'),
            new Product_Pricing_Field__c(Name='ProdRec18',Field_API_Name__c='Product_offering__c',Object_Name__c='Product2',Service_Field_Name__c='Publisher'),
            new Product_Pricing_Field__c(Name='ProdRec19',Field_API_Name__c='LCRM_Author__c',Object_Name__c='Product2',Service_Field_Name__c='Authors'),
            new Product_Pricing_Field__c(Name='ProdRec20',Field_API_Name__c='Practice_Area__c',Object_Name__c='Product2',Service_Field_Name__c='PracticeArea'),
            new Product_Pricing_Field__c(Name='dim1',Field_API_Name__c='Apttus_Config2__BusinessObject__c',Object_Name__c='dimension',Service_Field_Name__c='BusinessObject'),
            new Product_Pricing_Field__c(Name='dim2',Field_API_Name__c='Apttus_Config2__childFilterName__c',Object_Name__c='dimension',Service_Field_Name__c='ChildFilterName'),              
            new Product_Pricing_Field__c(Name='dim3',Field_API_Name__c='Apttus_Config2__contextType__c',Object_Name__c='dimension',Service_Field_Name__c='ContextType'),
            new Product_Pricing_Field__c(Name='dim4',Field_API_Name__c='Apttus_Config2__Datasource__c',Object_Name__c='dimension',Service_Field_Name__c='Datasource'),
            new Product_Pricing_Field__c(Name='dim5',Field_API_Name__c='Apttus_Config2__IncentiveId__c',Object_Name__c='dimension',Service_Field_Name__c='IncentiveId'),
            new Product_Pricing_Field__c(Name='dim6',Field_API_Name__c='Apttus_Config2__RelationType__c',Object_Name__c='dimension',Service_Field_Name__c='RelationType'),
            new Product_Pricing_Field__c(Name='dim8',Field_API_Name__c='Apttus_Config2__Type__c',Object_Name__c='dimension',Service_Field_Name__c='Type'),
            
            new Product_Pricing_Field__c(Name='F1',Field_API_Name__c='Name',Object_Name__c='Feature',Service_Field_Name__c='Name'),
            new Product_Pricing_Field__c(Name='F2',Field_API_Name__c='Apttus_Config2__Description__c',Object_Name__c='Feature',Service_Field_Name__c='Description'),
            new Product_Pricing_Field__c(Name='F3',Field_API_Name__c='Apttus_Config2__Sequence__c',Object_Name__c='Feature',Service_Field_Name__c='Sequence'),
            
            new Product_Pricing_Field__c(Name='FS1',Field_API_Name__c='Name',Object_Name__c='Featureset',Service_Field_Name__c='Name'),
            new Product_Pricing_Field__c(Name='FS2',Field_API_Name__c='Apttus_Config2__Description__c',Object_Name__c='Featureset',Service_Field_Name__c='Description'),
            new Product_Pricing_Field__c(Name='FS3',Field_API_Name__c='Apttus_Config2__Sequence__c',Object_Name__c='Featureset',Service_Field_Name__c='Sequence'),
            new Product_Pricing_Field__c(Name='FS4',Field_API_Name__c='Id',Object_Name__c='Featureset',Service_Field_Name__c='Id'),
            
            new Product_Pricing_Field__c(Name='PFV1',Field_API_Name__c='Apttus_Config2__Value__c',Object_Name__c='ProductFeatureValue',Service_Field_Name__c='Value'),
            new Product_Pricing_Field__c(Name='PFV3',Field_API_Name__c='Apttus_Config2__IsIncluded__c',Object_Name__c='ProductFeatureValue',Service_Field_Name__c='IsIncluded'),
            
            new Product_Pricing_Field__c(Name='PLI20',Field_API_Name__c='Id',Object_Name__c='PriceListItem',Service_Field_Name__c='Id'),                  
            new Product_Pricing_Field__c(Name='PLI1',Field_API_Name__c='Apttus_Config2__ExpirationDate__c',Object_Name__c='PriceListItem',Service_Field_Name__c='ExpirationDate'),
            new Product_Pricing_Field__c(Name='PLI2',Field_API_Name__c='Apttus_Config2__EffectiveDate__c',Object_Name__c='PriceListItem',Service_Field_Name__c='EffectiveDate'),
            new Product_Pricing_Field__c(Name='PLI3',Field_API_Name__c='Apttus_Config2__ContractPrice__c',Object_Name__c='PriceListItem',Service_Field_Name__c='ContractPrice'),
            new Product_Pricing_Field__c(Name='PLI4',Field_API_Name__c='Apttus_Config2__ListPrice__c',Object_Name__c='PriceListItem',Service_Field_Name__c='ListPrice'),
            new Product_Pricing_Field__c(Name='PLI5',Field_API_Name__c='Apttus_Config2__Active__c',Object_Name__c='PriceListItem',Service_Field_Name__c='Active'),
            new Product_Pricing_Field__c(Name='PLI6',Field_API_Name__c='Apttus_Config2__ProductId__c',Object_Name__c='PriceListItem',Service_Field_Name__c='ProductId'),
            new Product_Pricing_Field__c(Name='PLI7',Field_API_Name__c='Apttus_Config2__PriceListId__c',Object_Name__c='PriceListItem',Service_Field_Name__c='PriceListId'),
            new Product_Pricing_Field__c(Name='PLI9',Field_API_Name__c='Apttus_Config2__PriceUom__c',Object_Name__c='PriceListItem',Service_Field_Name__c='PriceUom'),
            new Product_Pricing_Field__c(Name='PLI10',Field_API_Name__c='Apttus_Config2__PriceMethod__c',Object_Name__c='PriceListItem',Service_Field_Name__c='PriceMethod'),
            new Product_Pricing_Field__c(Name='PLI11',Field_API_Name__c='Apttus_Config2__Frequency__c',Object_Name__c='PriceListItem',Service_Field_Name__c='Frequency'),
            new Product_Pricing_Field__c(Name='PLI12',Field_API_Name__c='Apttus_Config2__ChargeType__c',Object_Name__c='PriceListItem',Service_Field_Name__c='ChargeType'),
            new Product_Pricing_Field__c(Name='PLI13',Field_API_Name__c='Apttus_Config2__PriceType__c',Object_Name__c='PriceListItem',Service_Field_Name__c='PriceType'),
            new Product_Pricing_Field__c(Name='PLI16',Field_API_Name__c='Apttus_Config2__NumberOfMatrices__c',Object_Name__c='PriceListItem',Service_Field_Name__c='NumberOfMatrices'),
            new Product_Pricing_Field__c(Name='PLI17',Field_API_Name__c='Apttus_Config2__DefaultSellingTerm__c',Object_Name__c='PriceListItem',Service_Field_Name__c='DefaultSellingTerm'),
            new Product_Pricing_Field__c(Name='PLI18',Field_API_Name__c='Apttus_Config2__Sequence__c',Object_Name__c='PriceListItem',Service_Field_Name__c='Sequence'),
            new Product_Pricing_Field__c(Name='PLI19',Field_API_Name__c='Apttus_Config2__Criteria__c',Object_Name__c='PriceListItem',Service_Field_Name__c='Criteria'),
            
            new Product_Pricing_Field__c(Name='PM2',Field_API_Name__c='Apttus_Config2__Dimension1ValueType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Dimension1ValueType'),
            new Product_Pricing_Field__c(Name='PM3',Field_API_Name__c='Apttus_Config2__Dimension2ValueType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Dimension2ValueType'),
            new Product_Pricing_Field__c(Name='PM4',Field_API_Name__c='Apttus_Config2__Dimension3ValueType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Dimension3ValueType'),
            new Product_Pricing_Field__c(Name='PM5',Field_API_Name__c='Apttus_Config2__Dimension4ValueType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Dimension4ValueType'),
            new Product_Pricing_Field__c(Name='PM6',Field_API_Name__c='Apttus_Config2__Dimension5ValueType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Dimension5ValueType'),
            new Product_Pricing_Field__c(Name='PM7',Field_API_Name__c='Apttus_Config2__Dimension6ValueType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Dimension6ValueType'),
            new Product_Pricing_Field__c(Name='PM8',Field_API_Name__c='Apttus_Config2__EnableDateRange__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='EnableDateRange'),
            new Product_Pricing_Field__c(Name='PM9',Field_API_Name__c='Apttus_Config2__InitialRows__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='InitialRows'),
            new Product_Pricing_Field__c(Name='PM10',Field_API_Name__c='Apttus_Config2__IsCumulativeRange__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='IsCumulativeRange'),
            new Product_Pricing_Field__c(Name='PM11',Field_API_Name__c='Apttus_Config2__MatrixType__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='MatrixType'),
            new Product_Pricing_Field__c(Name='PM12',Field_API_Name__c='Apttus_Config2__NumberOfEntries__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='NumberOfEntries'),
            new Product_Pricing_Field__c(Name='PM13',Field_API_Name__c='Apttus_Config2__PriceListItemId__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='PriceListItemId'),
            new Product_Pricing_Field__c(Name='PM14',Field_API_Name__c='Apttus_Config2__Sequence__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='Sequence'),
            new Product_Pricing_Field__c(Name='PM15',Field_API_Name__c='Apttus_Config2__StopProcessingMoreMatrices__c',Object_Name__c='PriceMatrix',Service_Field_Name__c='StopProcessingMoreMatrices'),
            new Product_Pricing_Field__c(Name='PM16',Field_API_Name__c='Id',Object_Name__c='PriceMatrix',Service_Field_Name__c='Id'),
            new Product_Pricing_Field__c(Name='PME1',Field_API_Name__c='Apttus_Config2__AdjustmentAmount__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='AdjustmentAmount'),
            new Product_Pricing_Field__c(Name='PME2',Field_API_Name__c='Apttus_Config2__AdjustmentType__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='AdjustmentType'),
            new Product_Pricing_Field__c(Name='PME3',Field_API_Name__c='Apttus_Config2__BandSize__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='BandSize'),
            new Product_Pricing_Field__c(Name='PME4',Field_API_Name__c='Apttus_Config2__condition__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Condition'),
            new Product_Pricing_Field__c(Name='PME5',Field_API_Name__c='Apttus_Config2__Dimension1Value__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Dimension1Value'),
            new Product_Pricing_Field__c(Name='PME6',Field_API_Name__c='Apttus_Config2__Dimension2Value__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Dimension2Value'),
            new Product_Pricing_Field__c(Name='PME7',Field_API_Name__c='Apttus_Config2__Dimension3Value__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Dimension3Value'),
            new Product_Pricing_Field__c(Name='PME8',Field_API_Name__c='Apttus_Config2__Dimension4Value__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Dimension4Value'),
            new Product_Pricing_Field__c(Name='PME9',Field_API_Name__c='Apttus_Config2__Dimension5Value__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Dimension5Value'),
            new Product_Pricing_Field__c(Name='PME10',Field_API_Name__c='Apttus_Config2__Dimension6Value__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Dimension6Value'),
            new Product_Pricing_Field__c(Name='PME11',Field_API_Name__c='Apttus_Config2__PeriodEndDate__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='PeriodEndDate'),
            new Product_Pricing_Field__c(Name='PME12',Field_API_Name__c='Apttus_Config2__EndFactor__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='EndFactor'),
            new Product_Pricing_Field__c(Name='PME13',Field_API_Name__c='Apttus_Config2__EntryKey__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='EntryKey'),
            new Product_Pricing_Field__c(Name='PME14',Field_API_Name__c='Apttus_Config2__FlatPrice__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='FlatPrice'),
            new Product_Pricing_Field__c(Name='PME15',Field_API_Name__c='Apttus_Config2__TierStartValue__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='TierStartValue'),
            new Product_Pricing_Field__c(Name='PME16',Field_API_Name__c='Apttus_Config2__IsIncluded__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='IsIncluded'),
            new Product_Pricing_Field__c(Name='PME17',Field_API_Name__c='Apttus_Config2__PriceMatrixId__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='PriceMatrixId'),
            new Product_Pricing_Field__c(Name='PME18',Field_API_Name__c='Apttus_Config2__PriceOverride__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='PriceOverride'),
            new Product_Pricing_Field__c(Name='PME19',Field_API_Name__c='Apttus_Config2__Sequence__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='Sequence'),
            new Product_Pricing_Field__c(Name='PME20',Field_API_Name__c='Apttus_Config2__PeriodStartDate__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='PeriodStartDate'),
            new Product_Pricing_Field__c(Name='PME21',Field_API_Name__c='Apttus_Config2__StartFactor__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='StartFactor'),
            new Product_Pricing_Field__c(Name='PME22',Field_API_Name__c='Apttus_Config2__TierEndValue__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='TierEndValue'),
            new Product_Pricing_Field__c(Name='PME23',Field_API_Name__c='Apttus_Config2__UsageRate__c',Object_Name__c='PriceMatrixEntry',Service_Field_Name__c='UsageRate'),
            
            new Product_Pricing_Field__c(Name='poc1',Field_API_Name__c='Name',Object_Name__c='ProductOptionComponent',Service_Field_Name__c='Name'),
            new Product_Pricing_Field__c(Name='pa1',Field_API_Name__c='Id',Object_Name__c='ProductAttribute',Service_Field_Name__c='Id'),      
            new Product_Pricing_Field__c(Name='pog1',Field_API_Name__c='Name',Object_Name__c='ProductOptionGroup',Service_Field_Name__c='Name'),
            new Product_Pricing_Field__c(Name='ProdAuth2',Field_API_Name__c='Name',Object_Name__c='ProductAuthor',Service_Field_Name__c='Name')                        
            };
                insert productPricingMidelList;
        
        list<product2> products = new LIST<product2>();
        
        
        product2 pd1 = new product2();
        pd1.Name = 'Test Product';
        pd1.ProductCode = '98765';
        pd1.Description = 'Test Desc';
        pd1.Service_Number__c = '87654';
        pd1.product_offering__c = 'Test';
        pd1.Apttus_Filter_Jurisdiction__c = 'Colorado';
        pd1.Practice_Area__c ='General';
        pd1.APTS_Media_High_Level_Code__c = '21';
        pd1.APTS_Item_Category_Group__c = 'ZVSU';
        pd1.APTS_Media_Lower_Level_Code__c = 'F4';
        pd1.LCRM_Sub_Bu__c = 'USL';
        pd1.Format__c= 'Format';
        pd1.IsActive = true;
        pd1.Apttus_Config2__HasOptions__c = true;
        pd1.Apttus_Config2__HasAttributes__c = true;
        pd1.Apttus_Config2__HasDefaults__c = false;
        pd1.CPD_Sellable_Description__c ='Display and Sell';
        products.add(pd1);
         
        product2 pd2 = new product2();
        pd2.Name = 'Test Product';
        pd2.ProductCode = '987654';
        pd2.Description = 'Test Desc';
        pd2.CPD_Sellable_Description__c ='Display and Sell';
        pd2.IsActive = true;
        
        products.add(pd2);
        
        product2 pd3 = new product2();
        pd3.Name = 'Test Product123';
        pd3.ProductCode = '12345';
        pd3.Description = 'Test Desc';
        pd3.Service_Number__c = '8765412';
        pd3.Product_Offering__c = 'Test';
        pd3.Apttus_Filter_Jurisdiction__c = 'Colorado';
        pd3.Practice_Area__c ='General';
        pd3.LCRM_Sub_Bu__c = 'USL';
        pd3.Format__c= 'Format';
        pd3.IsActive = true;
        pd3.Apttus_Config2__HasOptions__c = false;
        pd3.Apttus_Config2__HasAttributes__c = false;
        pd3.Apttus_Config2__HasDefaults__c = false;
        pd3.CPD_Sellable_Description__c ='Display and Sell';
        products.add(pd3);
        System.assert(products.size() == 3, 'Inserted 3 test products');
        
        LIST<database.saveResult> pdres = database.insert(products, false);
        system.debug(loggingLevel.INFO,'products Result'+pdres);
        
        Apttus_Config2__FeatureSet__c fs = new Apttus_Config2__FeatureSet__c(Apttus_Config2__Sequence__c=3,Name='Formats');
        insert fs;
        Apttus_Config2__Feature__c faet = new Apttus_Config2__Feature__c(Apttus_Config2__Sequence__c=8,Name='Binding',Apttus_Config2__FeatureSetId__c = fs.id);
        insert faet;
        Apttus_Config2__ProductGroup__c pg = new Apttus_Config2__ProductGroup__c(Name='ABC');
        insert pg;
        Apttus_Config2__ProductGroupMember__c pgm = new Apttus_Config2__ProductGroupMember__c(Apttus_Config2__ProductGroupId__c=pg.Id,Apttus_Config2__ProductId__c=pdres[0].getId(),Apttus_Config2__Sequence__c=1);
        insert pgm;
        Apttus_Config2__ProductFeatureValue__c pfv = new Apttus_Config2__ProductFeatureValue__c(Apttus_Config2__ProductId__c = pdres[0].getId(), Apttus_Config2__FeatureId__c=faet.id,Apttus_Config2__Value__c='abc');
        insert pfv;
        Apttus_Config2__ProductFeatureValue__c pfv1 = new Apttus_Config2__ProductFeatureValue__c(Apttus_Config2__ProductId__c = pdres[1].getId(), Apttus_Config2__FeatureId__c=faet.id,Apttus_Config2__Value__c='abc');
        insert pfv1;
        
        Product_Collateral__c pColl = new Product_Collateral__c();
        pColl.Collateral_Title__c = 'Index';
        pColl.Collateral_Path__c = 'Index';
        pColl.Collateral_Type__c = 'Index';
        insert pColl;
        
        Product_Collateral_Value__c pCollValue = new Product_Collateral_Value__c();
        pCollValue.Product_Collateral__c = pColl.id;
        pCollValue.Product__c = pd1.id;
        insert pCollValue;
        
        Apttus_Config2__PriceList__c plSO = APTS_TestDataFactory.createPriceList('Thomson Reuters Master - US Legal');
        insert plSO;
        
        LIST<Apttus_Config2__PriceListItem__c> plList = new list<Apttus_Config2__PriceListItem__c>();
        
        Apttus_Config2__PriceListItem__c pliSO = new Apttus_Config2__PriceListItem__c();
        pliSO.Apttus_Config2__Active__c = true;
        pliSO.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO.Apttus_Config2__ProductId__c = pd1.id;
        pliSo.Apttus_Config2__ChargeType__c = 'Standard Price';
        pliSO.Apttus_Config2__PriceType__c = 'One time';
        pliSO.Apttus_Config2__Frequency__c = 'One time';
        pliSO.Apttus_Config2__ListPrice__c = 250;
        
        
        database.insert(pliSO,true);
        
        Apttus_Config2__PriceListItem__c pliSO1 = new Apttus_Config2__PriceListItem__c();
        pliSO1.Apttus_Config2__Active__c = true;
        pliSO1.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO1.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO1.Apttus_Config2__ProductId__c = pd1.id;
        pliSO1.Apttus_Config2__PriceType__c = 'One time';
        pliSO1.Apttus_Config2__Frequency__c = 'One time';
        pliSO1.Apttus_Config2__ListPrice__c = 200;
        
        plList.add(pliSO1);
        
        Apttus_Config2__PriceListItem__c pliSO2 = new Apttus_Config2__PriceListItem__c();
        pliSO2.Apttus_Config2__Active__c = true;
        pliSO2.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO2.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO2.Apttus_Config2__ProductId__c = pd2.id;
        pliSO2.Apttus_Config2__PriceType__c = 'One time';
        pliSO2.Apttus_Config2__Frequency__c = 'One time';
        pliSO2.Apttus_Config2__ListPrice__c = 200;
        
        plList.add(pliSO2);

    Apttus_Config2__PriceListItem__c pliSO3 = new Apttus_Config2__PriceListItem__c();
        pliSO3.Apttus_Config2__Active__c = true;
        pliSO3.Apttus_Config2__ChargeType__c = 'MRC';
        pliSO3.Apttus_Config2__PriceListId__c = plSO.Id;
        pliSO3.Apttus_Config2__ProductId__c = pd3.id;
        pliSO3.Apttus_Config2__PriceType__c = 'One time';
        pliSO3.Apttus_Config2__Frequency__c = 'One time';
        pliSO3.Apttus_Config2__ListPrice__c = 400;
        
        plList.add(pliSO3);
        
        database.insert(plList, true); 

    Apttus_Config2__FeatureSet__c fs1 = new Apttus_Config2__FeatureSet__c(Apttus_Config2__Sequence__c=4,Name='Formats');
        insert fs1;
        Apttus_Config2__Feature__c faet1 = new Apttus_Config2__Feature__c(Apttus_Config2__Sequence__c=8,Name='Book-harbound',Apttus_Config2__FeatureSetId__c = fs1.id);
        insert faet1;
    Apttus_Config2__ProductFeatureValue__c pfv2 = new Apttus_Config2__ProductFeatureValue__c(Apttus_Config2__ProductId__c = pdres[2].getId(), Apttus_Config2__FeatureId__c=faet1.id,Apttus_Config2__Value__c='987654');
        insert pfv2;

    Product_Detail__c pdet = new Product_Detail__c(APTS_Ext_ID__c='abc123',Product__c=pd3.id,Price_List__c=plSO.id,Product_Code__c='12345',product_details__c='abcTestJson');
        Database.insert(pdet,true);

    Product_Detail__c pdet1 = new Product_Detail__c(APTS_Ext_ID__c='abc124',Product__c=pd2.id,Price_List__c=plSO.id,Product_Code__c='987654',product_details__c='abcTestJson');
        Database.insert(pdet1,true);

        
        Apttus_Config2__PriceDimension__c pD = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        database.insert(PD,true);
        
        Apttus_Config2__PriceDimension__c pD01 = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        database.insert(PD01,true);
        Apttus_Config2__PriceDimension__c pD02 = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        database.insert(PD02,true);
        Apttus_Config2__PriceDimension__c pD03 = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        database.insert(PD03,true);
        Apttus_Config2__PriceDimension__c pD04 = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        database.insert(PD04,true);
        Apttus_Config2__PriceDimension__c pD05 = new Apttus_Config2__PriceDimension__c(Apttus_Config2__BusinessObject__c='Apttus_Config2__ProductAttributeValue__c',Apttus_Config2__Datasource__c = 'SCS_Print_Purchase_Options__c',Apttus_Config2__Type__c = 'Standard',Apttus_Config2__ContextType__c = 'Product Attribute');
        database.insert(PD05,true);
        Apttus_Config2__PriceMatrix__c pM1 = new Apttus_Config2__PriceMatrix__c(Apttus_Config2__Dimension1Id__c=pD.id,Apttus_Config2__Dimension1ValueType__c='Discrete',
                                                                                Apttus_Config2__Dimension2Id__c=pD01.Id,Apttus_Config2__Dimension2ValueType__c='Discrete',
                                                                                Apttus_Config2__Dimension3Id__c=pD02.Id,Apttus_Config2__Dimension3ValueType__c='Discrete',
                                                                                Apttus_Config2__Dimension4Id__c=pD03.Id,Apttus_Config2__Dimension4ValueType__c='Discrete',
                                                                                Apttus_Config2__Dimension5Id__c=pD04.Id,Apttus_Config2__Dimension5ValueType__c='Discrete',
                                                                                Apttus_Config2__Dimension6Id__c=pD05.Id,Apttus_Config2__Dimension6ValueType__c='Discrete',
                                                                                Apttus_Config2__EnableDateRange__c =false, Apttus_Config2__EnableUsageIndexing__c=false,Apttus_Config2__IsCumulativeRange__c=false,Apttus_Config2__MatrixType__c='Dimension',
                                                                                Apttus_Config2__PriceListItemId__c =pliSO.id,Apttus_Config2__Sequence__c=1,Apttus_Config2__StopProcessingMoreMatrices__c=false);
        database.insert(pM1,true);
        
        Apttus_Config2__PriceMatrixEntry__c pME = new Apttus_Config2__PriceMatrixEntry__c(Apttus_Config2__AdjustmentAmount__c=90,Apttus_Config2__AdjustmentType__c='List Price Override',
                                                                                          Apttus_Config2__Dimension1Value__c ='Amended',Apttus_Config2__IsIncluded__c=false, Apttus_Config2__PriceMatrixId__c=PM1.Id,
                                                                                          Apttus_Config2__Sequence__c=1);
        database.insert(pME,true);
        
        Product_Author__c pa1 = new Product_Author__c();
        pa1.Author_ID__c = '1';
        pa1.Name= 'Test Author one';
        pa1.Author_Biography__c = 'Biography of Author one';
        database.insert(pa1,true);
        
        Product_Author_Value__c pAuthV1 = new Product_Author_Value__c (ProductId__c = pd1.id, Product_AuthorId__c = pa1.ID);
        database.insert(pAuthV1 ,true);
        
        Apttus_Config2__ProductAttributeGroup__c pag = new Apttus_Config2__ProductAttributeGroup__c();
        pag.Apttus_Config2__BusinessObject__c = 'Apttus_Config2__ProductAttributeValue__c';
        pag.Apttus_Config2__Description__c = 'SCS Print';
        database.insert(pag, true);
        
        Apttus_Config2__ProductAttribute__c agi = new Apttus_Config2__ProductAttribute__c();
        agi.Apttus_Config2__AttributeGroupId__c = PAG.id;
        agi.Apttus_Config2__Field__c = 'SCS_Print_Purchase_Options__c';
        agi.Apttus_Config2__DisplayType__c ='Picklist';
        agi.Apttus_Config2__IsPrimary__c = true;
        agi.Apttus_Config2__IsHidden__c = false;
        agi.Apttus_Config2__IsReadOnly__c = false;
        agi.Apttus_Config2__Sequence__c = 1;
        database.insert(agi,true);
        
        Apttus_Config2__ProductAttributeGroupMember__c pagm = new Apttus_Config2__ProductAttributeGroupMember__c();
        pagm.Apttus_Config2__AttributeGroupId__c = pag.id;
        pagm.Apttus_Config2__ProductId__c = pd1.id;
        pagm.Apttus_Config2__Sequence__c = 1;
        database.insert(pagm,true);
        
        Apttus_Config2__ClassificationName__c cn = new Apttus_Config2__ClassificationName__c(Apttus_Config2__Active__c=true,Apttus_Config2__HierarchyLabel__c='Fill-Up',
                                                                                             Apttus_Config2__Type__c='Option Group');
        database.insert(cn,true);
        
        Apttus_Config2__ClassificationHierarchy__c ch = new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c=CN.id,Apttus_Config2__Label__c='Fill-Up',
                                                                                                       Apttus_Config2__Modifiable__c =true);
        database.insert(ch,true);
        
        Apttus_Config2__ProductOptionGroup__c pog1 = new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__CascadeGroupChanges__c=false,Apttus_Config2__ContentType__c='options',
                                                                                               Apttus_Config2__ProductId__c=pd1.id,Apttus_Config2__Sequence__c=1,Apttus_Config2__DetailPage__c='Fill up',
                                                                                               Apttus_Config2__OptionGroupId__c =CH.id,Apttus_Config2__RootOptionGroupId__c=CH.id);
        
        
        database.insert(pog1,true);
        
        
        Apttus_Config2__ProductOptionComponent__c poc = new Apttus_Config2__ProductOptionComponent__c();
        poc.Apttus_Config2__ProductOptionGroupId__c = pog1.Id;
        poc.Apttus_Config2__Sequence__c =1;
        poc.Apttus_Config2__ComponentProductId__c = pd2.id;
        poc.Apttus_Config2__ParentProductId__c = pd1.Id;
        database.insert(poc,true);
        
     }

    /** 
    * @description : Test method for getPricingDetails
    */ 
     public static testMethod void testGetPricingDetails() {
       testData();
       
       RestRequest req = new RestRequest();
        req.params.put('country','US');
        req.params.put('prodCode','98765');
        req.params.put('isPricing','Yes');
        req.params.put('origin','UE');
        req.requestURI = '/services/apexrest/GetProductDetails';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        TRStoreProductPricingService.getServiceResponse();
        system.assert(res!=null, 'method failure');
        
        RestRequest req0 = new RestRequest();
        req0.params.put('country','US');
        req0.params.put('prodCode','abcdefg');
        req0.params.put('isPricing','No');
        req0.params.put('origin','UE');
        req0.requestURI = '/services/apexrest/GetProductDetails';  //Request URL
        req0.httpMethod = 'GET';//HTTP Request Type
        req0.addHeader('Content-Type', 'application/json');
        RestContext.request = req0;
        RestResponse res0 = new RestResponse();
        RestContext.response = res0;
        TRStoreProductPricingService.getServiceResponse();
        
        RestRequest req1 = new RestRequest();
        req1.params.put('country','US');
        req1.params.put('prodCode','98765');
        req1.params.put('isPricing','Yes');
        
        req1.requestURI = '/services/apexrest/GetProductDetails';  //Request URL
        req1.httpMethod = 'GET';//HTTP Request Type
        req1.addHeader('Content-Type', 'application/json');
        RestContext.request = req1;
        RestResponse res1 = new RestResponse();
        RestContext.response = res1;
        TRStoreProductPricingService.getServiceResponse();

    RestRequest req2 = new RestRequest();
        req2.params.put('country','US');
        req2.params.put('prodCode','12345');
    req2.params.put('origin','UE');
        req2.requestURI = '/services/apexrest/GetProductDetails';  //Request URL
        req2.httpMethod = 'GET';//HTTP Request Type
        req2.addHeader('Content-Type', 'application/json');
        RestContext.request = req2;
        RestResponse res2 = new RestResponse();
        RestContext.response = res2;
        TRStoreProductPricingService.getServiceResponse();

    Static_Values__c cs = new Static_Values__c(name='PDPCurrentVersion' , value__c='v0');
        insert cs;

    RestRequest req3 = new RestRequest();
        req3.params.put('country','US');
        req3.params.put('prodCode','98765');
    req3.params.put('origin','UE');
        req3.requestURI = '/services/apexrest/GetProductDetails';  //Request URL
        req3.httpMethod = 'GET';//HTTP Request Type
        req3.addHeader('Content-Type', 'application/json');
        RestContext.request = req3;
        RestResponse res3 = new RestResponse();
        RestContext.response = res3;
        TRStoreProductPricingService.getServiceResponse();
        
        RestRequest req4 = new RestRequest();
        req4.params.put('country','US');
        req4.params.put('prodCode','abcdefg');
        req4.params.put('isPricing','No');
        req4.params.put('origin','UE');
        req4.params.put('lang','FR');
        
        req4.requestURI = '/services/apexrest/GetProductDetails';  //Request URL
        req4.httpMethod = 'GET';//HTTP Request Type
        req4.addHeader('Content-Type', 'application/json');
        RestContext.request = req4;
        RestResponse res4 = new RestResponse();
        RestContext.response = res4;
        TRStoreProductPricingService.getServiceResponse();
    }
}