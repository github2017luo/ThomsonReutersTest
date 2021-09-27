/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_ProductCheck
 DESCRIPTION : Checks Valid Data on Product records present at Digital Subscription  Object
 ====================================================================================================
 CUSTOM MESSAGES ADDED
 ====================================================================================================
 S.NO      OBJECT                                      MESSAGE
 1         DigitalSubscription                         DS Data Does not have valid product with same MaterialNumber,ServiceNumber with Different SubscriptionNumber
 2         Product                                     Given DS Data Straight Offer Product has no Price Matrix on it
 3         Product                                     Given DS Data Straight Offer Product has no Price Book on it
 4         Product                                     Given DS Data Best Offer Product has no Price Matrix on it
 5         Product                                     Given DS Data Best Offer Product has no Price Book on it
 6         Product                                     Given DS Data Premium Offer Product has no Price Matrix on it
 7         Product                                     Given DS Data Premium Offer Product has no Price Book on it
 8         DigitalSubscription                         DS Data Does not have valid product
 9         DigitalSubscription                         DS Data has no Product Values on it
 10        DigitalSubscription                         DS Data Best Offer Product Values missing on it
 11        DigitalSubscription                         DS Data Premium Offer Product Values missing on it
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Rahul Natarajan          DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_ProductCheck implements Database.Batchable < Product_Account_Detail__c > , Database.Stateful {
    Digital_Settings__c ds;
    List < Digital_Message__c > dmList;
    String sfdcBaseUrl;
    String dcSettingsId;
    List < Product_Account_Detail__c > dsList;
    List < Digital_Cohort_Messages__mdt > dcmlist;
    public Digital_Cohort_ProductCheck(Digital_Settings__c digitalSettings, List < Product_Account_Detail__c > totalDsList) {
        this.Ds = digitalSettings;
        this.dsList = totalDsList;
        dmList = new List < Digital_Message__c > ();
        sfdcBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        dcSettingsId = ds.Id;
        dcmlist = [SELECT Class__c, Label, Message__c, Object__c, Fatal_Error__c, Severity_Level__c
            FROM Digital_Cohort_Messages__mdt
            WHERE Class__c = 'Digital_Cohort_ProductCheck'
            ORDER BY Label ASC
            NULLS LAST
        ];
    }

    public Iterable < Product_Account_Detail__c > start(Database.BatchableContext bc) {
        ds.Class__c = 'Digital_Cohort_ProductCheck';
        ds.Completion__c = 45;
        update ds;
        if (dsList.isEmpty()) {
            ds.Completion__c = 100;
            ds.Job_Status__c = dcmlist[3].Message__c;
            ds.End_Time__c = DateTime.now();
            update ds;
        }
        return dsList;
    }

    public void execute(Database.BatchableContext bc, List < Product_Account_Detail__c > dsList) {
        try {
            for (Product_Account_Detail__c dsData: dsList) {
                checkDCProduct(dsData);
            }
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();
            ex.Additional_Information__c = String.valueof(e.getLineNumber());
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_Cohort_AssetCheck > Execute';
            insert ex;
        }
    }

    public void checkDCProduct(Product_Account_Detail__c dsData) {
        Digital_Customer__c dc = [Select Id
            from Digital_Customer__c
            where Customer_SSD__c =: dsData.AccountSSD__c and Digital_Settings__c =: ds.Id
        ][0];
        String dcCustomerId = dc.Id;
        String dsDataId = dsData.Id;
        if (ds.Segment__c != 'FindLaw') {
        	checkProdNotFindlaw(dsData, dcCustomerId, dsDataId);         
        } 
        checkProdFindlaw(dsData, dcCustomerId, dsDataId);

    }
    
    public void checkProdNotFindlaw(Product_Account_Detail__c dsData, Id dcCustomerId, string dsDataId) {
    	// combine parameters dsDataId, dcCustomerId
		string strDsDcIds = dsDataId + ':' + dcCustomerId;
     	if (!((dsData.Current_Subscription__c == null) && (dsData.Actual_New_Service__c == null) && (dsData.Actual_New_Subscription__c == null) && (dsData.Premium_New_Service__c == null) && (dsData.Premium_New_Subscription__c == null))) {
        	if (dsData.Current_Subscription__c != null) {
                    checkproduct(null, dsData.Current_Subscription__c, 'Straight Offer' + ':' + strDsDcIds); //dsDataId, dcCustomerId);
                }
                if ((dsData.Actual_New_Service__c != null) && (dsData.Actual_New_Subscription__c != null)) {
                    checkproduct(dsData.Actual_New_Service__c, dsData.Actual_New_Subscription__c, 'Best Offer' + ':' + strDsDcIds); // dsDataId, dcCustomerId);
                } else if (((dsData.Actual_New_Service__c == null) && (dsData.Actual_New_Subscription__c != null)) || ((dsData.Actual_New_Service__c != null) && (dsData.Actual_New_Subscription__c == null))) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[0].Object__c, Digital_Customer__c = dcCustomerId, Digital_Settings__c = ds.Id, Message__c = dcmlist[0].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsDataId));
                    dmList.add(createMessage(0, dcCustomerId, dsDataId));
                }
                if ((dsData.Premium_New_Service__c != null) && (dsData.Premium_New_Subscription__c != null)) {
                    checkproduct(dsData.Premium_New_Service__c, dsData.Premium_New_Subscription__c, 'Premium Offer' + ':' + strDsDcIds); //dsDataId, dcCustomerId);
                } else if (((dsData.Premium_New_Service__c == null) && (dsData.Premium_New_Subscription__c != null)) || ((dsData.Premium_New_Service__c != null) && (dsData.Premium_New_Subscription__c == null))) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[1].Object__c, Digital_Customer__c = dcCustomerId, Digital_Settings__c = ds.Id, Message__c = dcmlist[1].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsDataId));
                    dmList.add(createMessage(1, dcCustomerId, dsDataId));
                }
            } else {
                if (dsData.Add_On_Svc__c == null && dsData.Add_On_Sub__c == null) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[2].Object__c, Digital_Customer__c = dcCustomerId, Digital_Settings__c = ds.Id, Message__c = dcmlist[2].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsDataId));
                    dmList.add(createMessage(2, dcCustomerId, dsDataId));
                } else {
                    checkproduct(dsData.Add_On_Svc__c, dsData.Add_On_Sub__c, 'AddOn Offer' + ':' + strDsDcIds); //dsDataId, dcCustomerId);
                }
            }  	
    }
        
    public void checkProdFindlaw(Product_Account_Detail__c dsData, Id dcCustomerId, string dsDataId) {
        if ((ds.Segment__c == 'FindLaw') && (dsData.Current_Subscription__c != null)) {
            list<Product2> findLawProduct = new list<Product2>();
            findLawProduct = [Select Id from Product2 where ProductCode =: dsData.Current_Subscription__c Limit 1];
            if (findLawProduct.isEmpty()) {
                // dmList.add(new Digital_Message__c(Name = dcmlist[8].Object__c, Digital_Customer__c = dcCustomerId, Digital_Settings__c = ds.Id, Message__c = dcmlist[8].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsDataId));
                dmList.add(createMessage(8, dcCustomerId, dsDataId));
            } else {
                // Excluded Standard Price book value so it doesnt come on results
                list<PricebookEntry> pbe = [SELECT Id, IsActive, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Product2Id =: findLawProduct[0].Id AND Pricebook2Id !=: System.Label.stdPB];
                if (pbe.isEmpty()) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[6].Object__c, Digital_Customer__c = dcCustomerId, Digital_Settings__c = ds.Id, Message__c = dcmlist[6].Message__c, URL_2__c = sfdcBaseUrl + '/' + dsDataId, URL_1__c = sfdcBaseUrl + '/' + findLawProduct[0].Id));
                    dmList.add(createMessage(6, dcCustomerId, findLawProduct[0].Id));
                }
                list<Apttus_Config2__PriceMatrixEntry__c> pme = [SELECT Id FROM Apttus_Config2__PriceMatrixEntry__c WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c =: findLawProduct[0].Id];
                if (pme.isEmpty() && (findLawProduct[0].Id != System.Label.West_Proflex)) {
                    // dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcCustomerId, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_2__c = sfdcBaseUrl + '/' + dsDataId, URL_1__c = sfdcBaseUrl + '/' + findLawProduct[0].Id));
                    dmList.add(createMessage(7, dcCustomerId, findLawProduct[0].Id));
                }
                pbe.clear();
                pme.clear();
            }
        }
    }        
        
        
    public void checkproduct(String materialNumber, String subscriptionNumber, String strSubDsDcIds) {
    	// Combined parameters - String productSubscription, String dsId, String dcId
        list<string> listTemp = (strSubDsDcIds.split(':'));
        String productSubscription = listTemp[0];
        String dsId = listTemp[1];
        String dcId = listTemp[2];
            
        list<Product2> rqProducts = new list<Product2> ();
        list<Product2> searchproducts = new list<Product2> ();
        if (productSubscription != 'Straight Offer') {
            searchproducts = [SELECT Id, ProductCode, Service_Number__c, Subscription_Number__c
                FROM Product2
                WHERE Service_Number__c =: materialNumber AND Subscription_Number__c =: subscriptionNumber
            ];
        } else {
            searchproducts = [SELECT Id, ProductCode, Service_Number__c, Subscription_Number__c
                FROM Product2
                WHERE Subscription_Number__c =: subscriptionNumber
            ];
        }
        if (searchproducts.isEmpty()) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[4].Object__c, Digital_Customer__c = dcId, Digital_Settings__c = ds.Id, Message__c = dcmlist[4].Message__c + productSubscription, URL_1__c = sfdcBaseUrl + '/' + dsId));
            dmList.add(createMessage(4, dcId, dsId));
        } else {
            for (Product2 sp: searchproducts) {
                if ((sp.ProductCode == sp.Service_Number__c) && (sp.ProductCode != sp.Subscription_Number__c)) {
                    rqProducts.add(sp);
                }
            }
        }
        if (rqProducts.isEmpty()) {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[5].Object__c, Digital_Customer__c = dcId, Digital_Settings__c = ds.Id, Message__c = dcmlist[5].Message__c + productSubscription, URL_1__c = sfdcBaseUrl + '/' + dsId));
            dmList.add(createMessage(5, dcId, dsId));
        } else {
            // Excluded Standard Price book value so it doesnt come on results
            List < PricebookEntry > pbe = [SELECT Id, IsActive, Pricebook2Id, Product2Id
                FROM PricebookEntry
                WHERE Product2Id =: rqProducts[0].Id AND Pricebook2Id !=: System.Label.stdPB
            ];
            if (pbe.isEmpty()) {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[6].Object__c, Digital_Customer__c = dcId, Digital_Settings__c = ds.Id, Message__c = dcmlist[6].Message__c, URL_2__c = sfdcBaseUrl + '/' + dsId, URL_1__c = sfdcBaseUrl + '/' + rqProducts[0].Id));
                dmList.add(createMessage(6, dcId, dsId));
            }
            List < Apttus_Config2__PriceMatrixEntry__c > pme = [SELECT Id
                FROM Apttus_Config2__PriceMatrixEntry__c
                WHERE Apttus_Config2__PriceMatrixId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__ProductId__c =: rqProducts[0].Id
            ];
            if (pme.isEmpty() && (rqProducts[0].Id != System.Label.West_Proflex)) {
                // dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcId, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_2__c = sfdcBaseUrl + '/' + dsId, URL_1__c = sfdcBaseUrl + '/' + rqProducts[0].Id));
                dmList.add(createMessage(7, dcId, dsId));
            }
            pbe.clear();
            pme.clear();
        }
        rqProducts.clear();
        searchproducts.clear();
    }
    // Create the digital message with error content
    public Digital_Message__c createMessage(integer msgNumber, id custId, string urlString) {
        Digital_Message__c valMessage = new Digital_Message__c();
        valMessage.Name = dcmlist[msgNumber].Object__c;
        valMessage.Digital_Customer__c = custId;
        valMessage.Digital_Settings__c = ds.Id;
        valMessage.Message__c = dcmlist[msgNumber].Message__c;
        valMessage.Fatal_Error__c = dcmlist[msgNumber].Fatal_Error__c;
        valMessage.Severity_Level__c = dcmlist[msgNumber].Severity_Level__c;
        if (urlString != '') {
            valMessage.URL_1__c = sfdcBaseUrl + '/' + urlString;
        }
        return valMessage;
    }

    public void finish(Database.BatchableContext bc) {
        if (ds.Completion__c != 100) {
            if (!dmList.isEmpty()) {
                insert dmList;
            }
            ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_AssetCheck(ds), Integer.valueOf(ds.Batch_Size__c)));
            update ds;
        } else {
            Digital_Cohort_CompletionTasks dc = new Digital_Cohort_CompletionTasks();
            dc.sendcompletionemail(ds.Id);
        }
    }
}