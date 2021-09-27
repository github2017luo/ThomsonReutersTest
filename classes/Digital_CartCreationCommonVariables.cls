public without sharing class Digital_CartCreationCommonVariables{
    
    public static final String PRICELISTNAME = 'Thomson Reuters Master - US Legal';
    public static final String GLIPRICEBOOKNAME = 'GLI Price Book - US Legal/LMS';
    public static final String CARTOBJ = 'Product Configuration';
    public static final String SEGMENT_FINDLAW = 'FindLaw';
    public static final List<String> LAW_FIRMS = System.Label.Digital_Law_Firm.split(',');
    public static Id priceBookId = [SELECT Id FROM pricebook2 WHERE name = :GLIPRICEBOOKNAME LIMIT 1].Id;
    public static List<Apttus_Config2__PriceList__c> plNameList = [SELECT Id, Name FROM Apttus_Config2__PriceList__c WHERE Name =:PRICELISTNAME LIMIT 1];
    public static Map<String, DC_Contract_Term_V2__mdt> defaultByAccFirmMap = new Map<String, DC_Contract_Term_V2__mdt>();
    public static Map<String, String> mapOfProductIds = new Map<String, String>();
    public static Map<String, Decimal> discountAdjAmountMap = new Map<String,Decimal>();
    public static Map<String, String> dgfirmap = new Map<String, String>();
    public static List<Product_Account_Detail__c> dSubList;    //Added by Harika
    public static List<Apttus_Config2__AssetLineItem__c> configAssets = new List<Apttus_Config2__AssetLineItem__c> ();
    public static list<Apttus_Config2__ProductConfiguration__c> listNewCarts = new List<Apttus_Config2__ProductConfiguration__c>();

}