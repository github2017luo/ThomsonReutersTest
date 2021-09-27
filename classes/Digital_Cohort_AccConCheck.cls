/***************************************************************************************************
 CLASS NAME  : Digital_Cohort_AccConCheck
 DESCRIPTION : Checks Valid Data on Account,Contact,ContactSourceSystemDetail Records present at SSD Object
 ====================================================================================================
 CUSTOM MESSAGES ADDED
 ====================================================================================================
 S.NO      OBJECT                                      MESSAGE
 1.        Account                                                        SSD Account Email is null
 2.        Account                                                        SSD Account Email is not valid
 3.        Account                                                        SSD Account Email Verification not done
 4.        Account                                                        SSD Account Phone Number is null
 5.        Account                                                        SSD Account Phone Number is not valid
 6.        Account                                                        SSD Account Phone Verification not done
 7.        Account&SourceSystemDetail                                     Segmentation Fields Mismatch between Account and SSD
 8.        Contact                                                        SSD Contact is Inactive
 9.        Contact                                                        SSD Contact Email is null
 10.       Contact                                                        SSD Contact Email is not valid
 11.       Contact                                                        SSD Contact Email Verification not done
 12.       Contact                                                        SSD Contact Phone value is null
 13.       Contact                                                        SSD Contact Phone is not valid
 14.       Contact                                                        SSD Contact Phone Verification not done
 15.       Contact                                                        SSD Contact LCRM Suppression Reason
 16.       Contact&SourceSystemDetail                                     Segmentation Fields Mismatch between Contact and SSD
 17.       ContactSourceSystemDetail                                      ContactSourceSystemDetail has no Email
 18.       ContactSourceSystemDetail                                      ContactSourceSystemDetail is Inactive
 19.       ContactSourceSystemDetail                                      ContactSourceSystemDetail Inactive Reason
 20.       ContactSourceSystemDetail&SourceSystemDetail                   SAP Number Mismatch between ContactSourceSystemDetail and SSD
 21.       ContactSourceSystemDetail                                      ContactSourceSystemDetail is Hard Bounced
 22        Contact                                                        SSD Contact Segmentation field is null
 23        Account                                                        SSD Account Segmentation fields are null
 ====================================================================================================
 CHANGE HISTORY
 ====================================================================================================
 DATE            NAME                    DESCRIPTION
 31-05-2020      Rahul Natarajan         Created For CXD Project
 07-10-2020      Rahul Natarajan         DLT-20728 - Updated to track Fatal errors during Automation
                                         Updated for PMD violations
 ====================================================================================================
 ***************************************************************************************************/
public class Digital_Cohort_AccConCheck implements Database.Batchable < Digital_Customer__c > , Database.Stateful {
    Digital_Settings__c ds;
    String sfdcBaseUrl;
    List < Digital_Message__c > dmList;
    List < Digital_Customer__c > dcsList;
    List < Digital_Cohort_Messages__mdt > dcmlist;
    public Digital_Cohort_AccConCheck(Digital_Settings__c digitalSettings) {
        this.ds = digitalSettings;
        sfdcBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        dmList = new List < Digital_Message__c > ();
        dcmlist = [SELECT Class__c, Label, Message__c, Object__c, Fatal_Error__c, Severity_Level__c
            FROM Digital_Cohort_Messages__mdt
            WHERE Class__c = 'Digital_Cohort_AccConCheck'
            ORDER BY Label ASC
            NULLS LAST
        ];
    }

    public Iterable < Digital_Customer__c > start(Database.BatchableContext bc) {
        ds.Class__c = 'Digital_Cohort_AccConCheck';
        ds.Completion__c = 75;
        update ds;
        dcsList = [Select Id, Cohort_Execution__c, Customer_SSD__r.Digital_Firm__c, Customer_SSD__r.Source_System_Account_Number__c, Customer_SSD__c, Customer_SSD__r.BU_Segment_Level_2__c, Customer_SSD__r.Account_Name__c, Digital_Settings__c, Has_Account__c, Has_Assets__c, Has_Contact__c, Has_DSdata__c, Has_Opportunity__c, Has_Quotes__c, Has_SSD__c, SAP_Number__c
            from Digital_Customer__c
            where Digital_Settings__c =: ds.Id AND Cohort_Execution__c = false AND Has_SSD__c = true AND Has_DSdata__c = true AND Has_Assets__c = true AND Has_Account__c = true
        ];
        if (dcsList.isEmpty()) {
            ds.Completion__c = 100;
            ds.Job_Status__c = dcmlist[0].Message__c;
            ds.End_Time__c = DateTime.now();
            update ds;
        }
        return dcsList;
    }

    public void execute(Database.BatchableContext bc, List < Digital_Customer__c > dcsList) {
        try {
            for (Digital_Customer__c dcs: dcsList) {
                getAccountData(dcs);
            }
        } catch (Exception e) {
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c(Exception_Message__c = e.getMessage(), Exception_Type__c = e.getStackTraceString(), Additional_Information__c = String.valueof(e.getLineNumber()), User_Message__c = String.valueof(e.getCause()), Class_Reference__c = 'Digital_Cohort_AccConCheck > Execute');
            insert ex;
        }
    }

    public void getAccountData(Digital_Customer__c dcs) {
        Integer segmentSize;
        Account acc = [Select Id, LCRM_Email_Verification__c, LCRM_Phone_Verification__c, Email__c, LCRM_Email_StrikeIron_Validated__c, ECC_Segment_Level_2__c, Phone, LCRM_Phone_StrikeIron_Validated__c, Bu_Segment__c
            from Account
            where Id =: dcs.Customer_SSD__r.Account_Name__c
        ][0];
        
        // validate Account information
        validateAccount(dcs, acc);

        if (dcs.Has_Contact__c == true) {
            List < LCRM_Contact_SSD__c > contactSSDList = [Select Id, LCRM_Hard_Bounce__c, LCRM_Contact__c, LCRM_Email__c, Contact_Inactive__c, LCRM_SAP_Account_Number__c, LCRM_Contact_Inactive_Reason__c, LCRM_Contact__r.LCRM_Suppression_Reason__c, LCRM_Contact__r.AccountId, LCRM_Contact__r.Contact_Inactive__c, LCRM_Contact__r.Email, LCRM_Contact__r.Phone, LCRM_Contact__r.BU_Segment__c, LCRM_Contact__r.LCRM_Email_StrikeIron_Validated__c, LCRM_Contact__r.LCRM_Phone_StrikeIron_Validated__c, LCRM_Contact__r.LCRM_Email_Verification__c, LCRM_Contact__r.LCRM_Phone_Verification__c
                from LCRM_Contact_SSD__c
                where LCRM_Account_SSD__c =: dcs.Customer_SSD__c
            ];
            for (LCRM_Contact_SSD__c contactSSD: contactSSDList) {
            	// validate Contact SSD
            	validateCotactSSD(dcs, contactSSD);
            } 	
            
        }
    }
    
    
    // validate Account information
	public void validateAccount(Digital_Customer__c dcs, Account acc) {
		Integer segmentSize;
		
        if (acc.Email__c == null) {
            //   dmList.add(new Digital_Message__c(Name = dcmlist[1].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[1].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(1, dcs.Id, String.valueof(acc.Id)));
        } else if (acc.LCRM_Email_Verification__c != 'Email Valid') {
            //   dmList.add(new Digital_Message__c(Name = dcmlist[2].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[2].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(2, dcs.Id, String.valueof(acc.Id)));
        }
        if ((acc.Email__c != null) && (acc.LCRM_Email_StrikeIron_Validated__c == false)) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[3].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[3].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(3, dcs.Id, String.valueof(acc.Id)));
        }
        if (acc.Phone == null) {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[4].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[4].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(4, dcs.Id, String.valueof(acc.Id)));
        } else if (acc.LCRM_Phone_Verification__c != 'Valid Number') {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[5].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[5].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(5, dcs.Id, String.valueof(acc.Id)));
        }
        if ((acc.Phone != null) && (acc.LCRM_Phone_StrikeIron_Validated__c == false)) {
            //   dmList.add(new Digital_Message__c(Name = dcmlist[6].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[6].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(6, dcs.Id, String.valueof(acc.Id)));
        }
        if ((acc.ECC_Segment_Level_2__c != null) || (acc.Bu_Segment__c != null)) {
            List < String > accListSegments = new List < String > ();
            accListSegments.add(acc.ECC_Segment_Level_2__c);
            accListSegments.add(dcs.Customer_SSD__r.BU_Segment_Level_2__c);
            accListSegments.add(acc.Bu_Segment__c);
            accListSegments.add(dcs.Customer_SSD__r.Digital_Firm__c);
            segmentSize = checkSegmentCount(accListSegments);
            if (segmentSize > 1) {
                // dmList.add(new Digital_Message__c(Name = dcmlist[7].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[7].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id, URL_2__c = sfdcBaseUrl + '/' + dcs.Customer_SSD__c));
                dmList.add(createMessage(7, dcs.Id, String.valueof(acc.Id)));
            }
        } else {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[8].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[8].Message__c, URL_1__c = sfdcBaseUrl + '/' + acc.Id));
            dmList.add(createMessage(8, dcs.Id, String.valueof(acc.Id)));
        }
	}
    
    
    // validate Contact SSD information
	public void validateCotactSSD(Digital_Customer__c dcs, LCRM_Contact_SSD__c contactSSD) {
		
        if (contactSSD.LCRM_Contact__c != null) {
        	if (contactSSD.LCRM_Contact__r.Contact_Inactive__c == true) {
            	//  dmList.add(new Digital_Message__c(Name = dcmlist[9].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[9].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
                dmList.add(createMessage(9, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
            }
            if (contactSSD.LCRM_Contact__r.Email == null) {
                //   dmList.add(new Digital_Message__c(Name = dcmlist[10].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[10].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
                dmList.add(createMessage(10, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
            } else if (contactSSD.LCRM_Contact__r.LCRM_Email_Verification__c != 'Email Valid') {
                // dmList.add(new Digital_Message__c(Name = dcmlist[11].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[11].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
                dmList.add(createMessage(11, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
            }
            if ((contactSSD.LCRM_Contact__r.Email != null) && (contactSSD.LCRM_Contact__r.LCRM_Email_StrikeIron_Validated__c == false)) {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[12].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[12].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
                dmList.add(createMessage(12, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
            }
            if (contactSSD.LCRM_Contact__r.Phone == null) {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[13].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[13].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
                dmList.add(createMessage(13, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
            } else if (contactSSD.LCRM_Contact__r.LCRM_Phone_Verification__c != 'Valid Number') {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[14].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[14].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
                dmList.add(createMessage(14, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
            }

            validateCotactSSDHelper(dcs, contactSSD);

        }
        validateCotactSSDHardBounce(dcs, contactSSD);

	} 
	
	// validate Contact SSD information for additional errors
	public void validateCotactSSDHelper(Digital_Customer__c dcs, LCRM_Contact_SSD__c contactSSD) {
		Integer segmentSize;
		
		if ((contactSSD.LCRM_Contact__r.Phone != null) && (contactSSD.LCRM_Contact__r.LCRM_Phone_StrikeIron_Validated__c == false)) {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[15].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[15].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
            dmList.add(createMessage(15, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
        }
        if (contactSSD.LCRM_Contact__r.LCRM_Suppression_Reason__c != null) {
            //   dmList.add(new Digital_Message__c(Name = dcmlist[16].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[16].Message__c + contactSSD.LCRM_Contact__r.LCRM_Suppression_Reason__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
            dmList.add(createMessage(16, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
        }
	
	    if (contactSSD.LCRM_Contact__r.BU_Segment__c != null) {
            List < String > conListSegments = new List < String > ();
            conListSegments.add(contactSSD.LCRM_Contact__r.BU_Segment__c);
            conListSegments.add(dcs.Customer_SSD__r.Digital_Firm__c);
            segmentSize = checkSegmentCount(conListSegments);
        } else {
            //  dmList.add(new Digital_Message__c(Name = dcmlist[18].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[18].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c));
            dmList.add(createMessage(18, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
        }
        if ((segmentSize > 1) && (contactSSD.LCRM_Contact__r.BU_Segment__c != null)) {
            // dmList.add(new Digital_Message__c(Name = dcmlist[17].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[17].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.LCRM_Contact__c, URL_2__c = sfdcBaseUrl + '/' + dcs.Customer_SSD__c));
            dmList.add(createMessage(17, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
        }
            	
	}
	
	// validate Contact SSD information
	public void validateCotactSSDHardBounce(Digital_Customer__c dcs, LCRM_Contact_SSD__c contactSSD) {
		        
        if (contactSSD.LCRM_Hard_Bounce__c == true) {
                //  dmList.add(new Digital_Message__c(Name = dcmlist[19].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[19].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.Id));
                dmList.add(createMessage(19, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
                }
                if (contactSSD.LCRM_Email__c == null) {
                    //  dmList.add(new Digital_Message__c(Name = dcmlist[20].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[20].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.Id));
                    dmList.add(createMessage(20, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
                }
                if (contactSSD.Contact_Inactive__c == true) {
                    //  dmList.add(new Digital_Message__c(Name = dcmlist[21].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[21].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.Id));
                    dmList.add(createMessage(21, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
                }
                if (contactSSD.LCRM_Contact_Inactive_Reason__c != null) {
                    //  dmList.add(new Digital_Message__c(Name = dcmlist[22].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[22].Message__c + contactSSD.LCRM_Contact_Inactive_Reason__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.Id));
                    dmList.add(createMessage(22, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
                }
                if (contactSSD.LCRM_SAP_Account_Number__c != dcs.Customer_SSD__r.Source_System_Account_Number__c) {
                    //  dmList.add(new Digital_Message__c(Name = dcmlist[23].Object__c, Digital_Customer__c = dcs.Id, Digital_Settings__c = ds.Id, Message__c = dcmlist[23].Message__c, URL_1__c = sfdcBaseUrl + '/' + contactSSD.Id, URL_2__c = sfdcBaseUrl + '/' + dcs.Customer_SSD__c));
                    dmList.add(createMessage(23, dcs.Id, String.valueof(contactSSD.LCRM_Contact__c)));
        }
	}
    
    public Integer checkSegmentCount(List < String > availableSegments) {
        Integer segmentSize;
        Set < String > accSetSegments = new Set < String > ();
        for (String accListSegment: availableSegments) {
            List < ODT_Market_Segments__mdt > oms = getSegments(accListSegment);
            if (!oms.isEmpty()) {
                accSetSegments.add(oms[0].Business_Type__c);
            }
        }
        segmentSize = accSetSegments.size();
        return segmentSize;
    }

    public List < ODT_Market_Segments__mdt > getSegments(String accListSegment) {
        List < ODT_Market_Segments__mdt > oms = [Select Business_Type__c, Market_Segment__c from ODT_Market_Segments__mdt where Market_Segment__c =: accListSegment];
        return oms;
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
            ds.Batch_Id__c = String.valueof(Database.executeBatch(new Digital_Cohort_OppPropCheck(ds), Integer.valueOf(ds.Batch_Size__c)));
            update ds;
        } else {
            Digital_Cohort_CompletionTasks dc = new Digital_Cohort_CompletionTasks();
            dc.sendcompletionemail(ds.Id);
        }
    }
}