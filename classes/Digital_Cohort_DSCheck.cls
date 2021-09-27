/***************************************************************************************************
  CLASS NAME  : Digital_Cohort_DSCheck
 DESCRIPTION : Checks Valid Data on SSD and DS records present at DigitalCustomer Object
 ====================================================================================================
 CUSTOM MESSAGES ADDED
 ====================================================================================================
 S.NO      OBJECT                                                  MESSAGE
 1.      DigitalSubscription&SourceSystemDetail                  Quantity mismatch between DS and SSD
 2.      SourceSystemDetail                                      SSD has DS Data with Multiple Renewal Dates
 3.      DigitalSubscription                                     DS Data has no Offer Type
 4.      DigitalSubscription                                     DS Data has no Renewal Date
 5.      DigitalSubscription&SourceSystemDetail                  Segmentation mismatch between DS and SSD
 6.      DigitalSubscription                                     Duplicate Current Subscription found on DS Data
 7.      DigitalSubscription                                     Duplicate Best New Service found on DS Data
 8.      DigitalSubscription                                     Duplicate Best New Subscription found on DS Data
 9.      DigitalSubscription                                     Duplicate Premium New Service found on DS Data
 10.     DigitalSubscription                                     Duplicate Premium New Subscription found on DS Data
 11.     SourceSystemDetail                                      SSD has DS Data with no Straight Offer
 12.     SourceSystemDetail                                      SSD has DS Data with Multiple Offer Types
 13.     SourceSystemDetail                                      SSD has DS Data with Multiple Campaign Code
 14.     SourceSystemDetail                                      SSD has DS Data with Multiple sub-Campaign Code
 15.     DigitalSubscription                                     DS Data has no Campaign Code
 16.     DigitalSubscription                                     DS Data has no sub-Campaign Code
 17.     SourceSystemDetail                                      SSD has DS Data with Multiple Current Term Length
 18.     DigitalSubscription                                     DS Data has no Current Term Length
 19.     General                                                 Interrupted , Digital Customers has no SSD or DS data
 20.     DigitalSubscription                                     FindLaw Quotes Should Have only Straight Offer
 21.     DigitalSubscription                                     Current Subscription Null on FindLaw DS Data
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Brenda Shields          DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_DSCheck implements Database.Batchable<Digital_Customer__c>, Database.Stateful{
    Digital_Settings__c ds;
    list<Digital_Message__c> dmList;
    string sfdcBaseUrl;
    list<Product_Account_Detail__c> totalDsList;
    list<Digital_Customer__c> dcsList;
    list<Digital_Cohort_Messages__mdt> dcmlist;
    // Sets and Lists needed to validate Digital Subscription records
    Set<String> cSub = new Set<String>();
    Set<String> cc = new Set<String>();
    Set<String> scc = new Set<String>();
    list<String> lcSub = new list<String>();
    list<String> lbSer = new list<String>();
    list<String> lbSub = new list<String>();
    list<String> lpSer = new list<String>();
    list<String> lpSub = new list<String>();
                
    // Method to check Digital Subscription records for validation errors
    public Digital_Cohort_DSCheck(Digital_Settings__c digitalSettings) {
        this.Ds = digitalSettings;
        sfdcBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        dmList = new List<Digital_Message__c>();
        totalDsList = new List<Product_Account_Detail__c>();
        dcmlist = [SELECT Class__c, Label, Message__c, Object__c, Fatal_Error__c, Severity_Level__c
                   FROM Digital_Cohort_Messages__mdt
                   WHERE Class__c = 'Digital_Cohort_DSCheck'
                   ORDER BY Label ASC
                   NULLS LAST];
    }


	// start method for batch processing
    public Iterable<Digital_Customer__c> start(Database.BatchableContext bc) {
        ds.Class__c = 'Digital_Cohort_DSCheck';
        ds.Completion__c = 30;
        update ds;
        dcsList = [Select Id, Cohort_Execution__c, Customer_SSD__c, Digital_Settings__c, Has_Account__c, Has_Assets__c, Has_Contact__c, Has_DSdata__c, Has_Opportunity__c, Has_Quotes__c, Has_SSD__c, SAP_Number__c
                   from Digital_Customer__c
                   where Digital_Settings__c = :ds.Id AND Cohort_Execution__c = false AND Has_SSD__c = true AND Has_DSdata__c = true];
        if (dcsList.isEmpty()){
            ds.Completion__c = 100;
            ds.Job_Status__c = dcmlist[0].Message__c;
            ds.End_Time__c = DateTime.now();
            update ds;
        }
        return dcsList;
    }
    
	// execute/main batching processing method
    public void execute(Database.BatchableContext bc, List<Digital_Customer__c> dcsList) {
        try {
            for (Digital_Customer__c dcs : dcsList) {
                cSub.clear();
                cc.clear();
                scc.clear();
                
                lcSub.clear();
                lbSer.clear();
                lbSub.clear();
                lpSer.clear();
                lpSub.clear();
                boolean dup = false;
                
                // get the SSD record to validate
                Source_System_Detail__c ssd = selectSSD(dcs.Customer_SSD__c);
                // get the DS records to validate
                list<Product_Account_Detail__c> dsList;
                dsList = selectDS(ds.Data_Status__c, ssd.Source_System_Account_Number__c);

                // process all digital subscription records for this customer
                for (Product_Account_Detail__c dsL : dsList)  {
                	
                	system.debug(LoggingLevel.INFO, 'List Digital Subscription: ' + dsl);
                    if (dsL.Digital_Firm__c != ds.Segment__c){
                        //dmList.add(new Digital_Message__c(Name = dcmlist[22].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[22].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));
                        dmList.add(createMessage(22, dcs.Id, dsL.Id));
                        continue;
                    }
                    totalDsList.add(dsL);

                    // validate Digital Subscription fields and values and update list values
                    validateDSLines(dsL, dcs.Id);
                    // update Digital Subscription lists
                    if (ds.Segment__c != 'FindLaw') {
                    	updateDSLists( dsL);
                    }
                    // validate Digital Subscription and SSD fields and values 
                    validateDSandSSDLines(dsL, dcs.Id, ssd);
                    
                } // end of for loop 
                
 				// validate the summary of DS records for this customer               
                validateDSSummary(dcs.Id, ssd);
            }
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c= e.getMessage(),Exception_Type__c = e.getStackTraceString(),Additional_Information__c = String.valueof(e.getLineNumber()),User_Message__c = String.valueof(e.getCause()),Class_Reference__c = 'Digital_Cohort_DSCheck > Execute'); 
            insert ex;
        }
    }
    
    // select the SSD record to validate
	public Source_System_Detail__c selectSSD(Id custSSDId) {
		Source_System_Detail__c ssd = [Select Id, LCRM_APTS_Band_Number__c, LCRM_Email__c, Source_System_Account_Number__c, BU_Segment_Level_2__c, Digital_Firm__c
                                               FROM Source_System_Detail__c
                                               WHERE Id = : custSSDId LIMIT 1][0];
        return ssd;
	}
	
	// select the DS records to validate
	public list<Product_Account_Detail__c> selectDS(string strDataStatus, string strSSDAcctNumber) {
		list<Product_Account_Detail__c> dsList;

        if (strDataStatus == 'Pre-CohortsJob') {
            dsList = [SELECT Id, DC_Contract_Number__c, Campaign_Code__c, sub_Campaign_Code__c, AccountSSD__c, ZP_Cust_Number__c, Current_Subscription__c, Add_On_Sub__c, Add_On_Svc__c, Renewal_Date__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c, Premium_New_Subscription__c, Type__c, Digital_Firm__c, Current_Term_Length__c
                      FROM Product_Account_Detail__c
                      WHERE ZP_Cust_Number__c = : strSSDAcctNumber AND Renewal_Date__c > Today AND Bypass_Automation__c = FALSE];
        } else {
            dsList = [SELECT Id, DC_Contract_Number__c, Campaign_Code__c, sub_Campaign_Code__c, AccountSSD__c, ZP_Cust_Number__c, Current_Subscription__c, Add_On_Sub__c, Add_On_Svc__c, Renewal_Date__c, Quantity__c, Actual_New_Service__c, Actual_New_Subscription__c, Premium_New_Service__c, Premium_New_Subscription__c, Type__c, Digital_Firm__c, Current_Term_Length__c
                      FROM Product_Account_Detail__c
                      WHERE ZP_Cust_Number__c = : strSSDAcctNumber AND Renewal_Date__c > Today];
        }
		return dsList;
	}
    
    // validate Digital Subscription line items
	public void validateDSLines(Product_Account_Detail__c dsL, id custId) {
		
		// Add all needed items to the sets.  Remove the nulls later
        cc.add(dsL.Campaign_Code__c);
        scc.add(dsL.sub_Campaign_Code__c);
        
        if (dsL.Type__c == null){
            //dmList.add(new Digital_Message__c(Name = dcmlist[2].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[2].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));
            dmList.add(createMessage(2, custId, dsL.Id));
        }

        if (ds.Segment__c == 'FindLaw') {
        	cSub.add(dsL.Current_Subscription__c);
        	if (dsL.Type__c != 'Straight') {
                //dmList.add(new Digital_Message__c(Name = dcmlist[19].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[19].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));
                dmList.add(createMessage(19, custId, dsL.Id));
            }
            if ((dsL.Current_Subscription__c == null) && (dsL.Current_Subscription__c == '')) {
		      	//dmList.add(new Digital_Message__c(Name = dcmlist[20].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[20].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));            
				dmList.add(createMessage(20, custId, dsL.Id));
            }
            if (dsL.DC_Contract_Number__c == null){
                //dmList.add(new Digital_Message__c(Name = dcmlist[21].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[21].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));
                dmList.add(createMessage(21, custId, dsL.Id));
            }
        }

		// check campaign codes
        if (dsL.Campaign_Code__c == null) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[4].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[4].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));
            dmList.add(createMessage(4, custId, dsL.Id));
        } 
        if (dsL.sub_Campaign_Code__c == null) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[5].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[5].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id));
            dmList.add(createMessage(5, custId, dsL.Id));
        }  
	}
               
    // update lists for each Digital Subscription Record
    public void updateDSLists(Product_Account_Detail__c dsL) {
    	
		if (String.isNotBlank(dsL.Current_Subscription__c)) { // != null) && (dsL.Current_Subscription__c != '')) {
        	lcSub.add(String.valueOf(dsL.Current_Subscription__c));
        }
        if (String.isNotBlank(dsL.Actual_New_Service__c)) { // != null) && (dsL.Actual_New_Service__c != '')) {
            lbSer.add(String.valueOf(dsL.Actual_New_Service__c));
        }
        if (String.isNotBlank(dsL.Actual_New_Subscription__c)) { // != null) && (dsL.Actual_New_Subscription__c != '')) {
            lbSub.add(String.valueOf(dsL.Actual_New_Subscription__c));
        }
        if (String.isNotBlank(dsL.Premium_New_Service__c)) { // != null) && (dsL.Premium_New_Service__c != '')) {
            lpSer.add(String.valueOf(dsL.Premium_New_Service__c));
        }
        if (String.isNotBlank(dsL.Premium_New_Subscription__c)) { // != null) && (dsL.Premium_New_Subscription__c != '')) {
            lpSub.add(String.valueOf(dsL.Premium_New_Subscription__c));
        }
    }
            
	// validate fields in DS and SSD records 
   	public void validateDSandSSDLines(Product_Account_Detail__c dsL, id custId, Source_System_Detail__c ssd) {
          
        if (dsL.Quantity__c != ssd.LCRM_APTS_Band_Number__c){
            //dmList.add(new Digital_Message__c(Name = dcmlist[1].Object__c, Digital_Customer__c = custId, Digital_Settings__c = ds.Id, Message__c = dcmlist[1].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id, URL_2__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(11, custId, ssd.Id);  
			valMessage.URL_2__c = sfdcBaseUrl + '/' + ssd.Id;
			dmList.add(valMessage);
        }
        if ((dsL.Digital_Firm__c != ssd.Digital_Firm__c) && (ds.Segment__c != 'FindLaw') && (dsL.Digital_Firm__c != 'FindLaw')) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = custId, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id, URL_2__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(7, custId, ssd.Id);  
			valMessage.URL_2__c = sfdcBaseUrl + '/' + ssd.Id;
			dmList.add(valMessage);
        }
        if ((dsL.Digital_Firm__c == 'FindLaw') && (ssd.Digital_Firm__c != 'Small Law')){
            //dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = custId, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_1__c = sfdcBaseUrl + '/' + dsL.Id, URL_2__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(7, custId, ssd.Id);  
			valMessage.URL_2__c = sfdcBaseUrl + '/' + ssd.Id;
			dmList.add(valMessage);
        }              
	}

	// validate additonal information for Digital Subscriptions
    public void validateDSSummary(id custId, Source_System_Detail__c ssd) {
        Set<String> dsTypes = new Set<String>();
        Set<Date> dsDates = new Set<Date>();
        Set<Decimal> ctl = new Set<Decimal>();
            
        // loop through all DS records to check if no or multiple values are there    
        for (Product_Account_Detail__c dsL : totalDsList) { //dsList)  {
        	dsTypes.add(dsL.Type__c);
        	dsDates.add(dsL.Renewal_Date__c); 
        	ctl.add(dsL.Current_Term_Length__c); 
        }
                                    
        // Remove any null values 
        dsTypes.remove(null);
        ctl.remove(null);
        cc.remove(null);
        scc.remove(null);
        dsDates.remove(null);
                
        if (ds.Segment__c != 'FindLaw') {
        	validateDSSetsHelper1(custId, ssd);
            validateDSSetsHelper2(custId, ssd);
            validateDSSetsHelper3(custId, ssd);
        }
        if (dsTypes.size() > 1) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[14].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[14].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(14, custId, ssd.Id));
        }
        if (dsDates.size() > 1){
            //dmList.add(new Digital_Message__c(Name = dcmlist[13].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[13].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(13, custId, ssd.Id));
        }
        if (ctl.size() > 1){
            //dmList.add(new Digital_Message__c(Name = dcmlist[17].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[17].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(17, custId, ssd.Id)); 
        } 
        
        if (cSub.isEmpty()) {
            //dmList.add(new Digital_Message__c(Name = dcmlist[18].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[18].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(18, custId, ssd.Id));
        }
    }   
     
    // check DS set sizes
    public void validateDSSetsHelper1(id custId, Source_System_Detail__c ssd) {
    	
    	Set<String> bSer = new Set<String>();
    	Set<String> bSub = new Set<String>();
    	Set<String> pSer = new Set<String>();
    	Set<String> pSub = new Set<String>();
    	system.debug(LoggingLevel.INFO, 'List contents - lcsub: ' + lcsub);
        system.debug(LoggingLevel.INFO, 'List contents - lpSer: ' + lpSer);
        system.debug(LoggingLevel.INFO, 'List contents - lpSub: ' + lpSub);
        system.debug(LoggingLevel.INFO, 'List contents - lbSer: ' + lbSer);
        system.debug(LoggingLevel.INFO, 'List contents - lbSub: ' + lbSub);
       
        csub.addAll(lcsub);
        pSer.addAll(lpSer);
        pSub.addAll(lpSub);
        bSer.addAll(lbSer);
        bSub.addAll(lbSub);

        // check set sizes for errors
        if (pSer.Size() != lpSer.Size()){
            //dmList.add(new Digital_Message__c(Name = dcmlist[12].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[12].Message__c + 'Values->' + pSer + 'LValues->' + lpSer, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(12, custId, ssd.Id);  
			valMessage.Message__c = dcmlist[12].Message__c + 'Values->' + pSer + 'LValues->' + lpSer;
			dmList.add(valMessage);
        }
        if (pSub.Size() != lpSub.Size()){
            //dmList.add(new Digital_Message__c(Name = dcmlist[11].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[11].Message__c + 'Values->' + pSub + 'LValues->' + lpSub, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(11, custId, ssd.Id);  
			valMessage.Message__c = dcmlist[11].Message__c + 'Values->' + pSub + 'LValues->' + lpSub;
			dmList.add(valMessage);
        }
        if (bSub.Size() != lbSub.Size()){
            //dmList.add(new Digital_Message__c(Name = dcmlist[10].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[10].Message__c + 'Values->' + bSub + 'LValues->' + lbSub, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(10, custId, ssd.Id);  
			valMessage.Message__c = dcmlist[10].Message__c + 'Values->' + bSub + 'LValues->' + lbSub;
			dmList.add(valMessage);
        }
    } 
      
   // check DS set sizes - Additional checks
    public void validateDSSetsHelper2(id custId, Source_System_Detail__c ssd) {
    	
    	Set<String> bSer = new Set<String>();
    	Set<String> bSub = new Set<String>();
    	Set<String> pSer = new Set<String>();
    	Set<String> pSub = new Set<String>();
        system.debug(LoggingLevel.INFO, 'List contents - lcsub: ' + lcsub);
        system.debug(LoggingLevel.INFO, 'List contents - lpSer: ' + lpSer);
        system.debug(LoggingLevel.INFO, 'List contents - lpSub: ' + lpSub);
        system.debug(LoggingLevel.INFO, 'List contents - lbSer: ' + lbSer);
        system.debug(LoggingLevel.INFO, 'List contents - lbSub: ' + lbSub);
 
        csub.addAll(lcsub);
        pSer.addAll(lpSer);
        pSub.addAll(lpSub);
        bSer.addAll(lbSer);
        bSub.addAll(lbSub);
                                      
        if (bSer.Size() != lbSer.Size()){
            //dmList.add(new Digital_Message__c(Name = dcmlist[9].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[9].Message__c + 'Values->' + bSer + 'LValues->' + lbSer, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(9, custId, ssd.Id);  
			valMessage.Message__c = dcmlist[9].Message__c + 'Values->' + bSer + 'LValues->' + lbSer;
			dmList.add(valMessage);
        }
        if (cSub.Size() != lcSub.Size()){
            //dmList.add(new Digital_Message__c(Name = dcmlist[8].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[8].Message__c + 'Values->' + cSub + 'LValues->' + lcSub, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            // the message is set differently from the create method so update it again
			Digital_Message__c valMessage = createMessage(8, custId, ssd.Id);  
			valMessage.Message__c = dcmlist[8].Message__c + 'Values->' + cSub + 'LValues->' + lcSub;
			dmList.add(valMessage);
    	}
    } 

    // check DS set sizes - Additional checks
    public void validateDSSetsHelper3(id custId, Source_System_Detail__c ssd) {

		// check set sizes for errors
        if (cc.size() > 1){
            //dmList.add(new Digital_Message__c(Name = dcmlist[15].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[15].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(15, custId, ssd.Id));
        }
        if (scc.size() > 1){
            //dmList.add(new Digital_Message__c(Name = dcmlist[16].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[16].Message__c, URL_1__c = sfdcBaseUrl + '/' + ssd.Id));
            dmList.add(createMessage(16, custId, ssd.Id));
        }

           
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
	

	// finish method
    public void finish(Database.BatchableContext bc) {
        if (ds.Completion__c != 100) {
            if (!dmList.isEmpty()) {
                insert dmList;
            }
            if (!test.isrunningtest()) { 
            	ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_ProductCheck(ds, totalDsList), Integer.valueOf(ds.Batch_Size__c))); 
            	update ds; 
            }
        } else {
            if (!test.isrunningtest()) {  
            	Digital_Cohort_CompletionTasks dc = new Digital_Cohort_CompletionTasks(); 
            	dc.sendcompletionemail(ds.Id); 
            }
        }
    }
}