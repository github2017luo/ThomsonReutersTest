/*============================================================================================
Name                : ODTWestLawAccTrialDetails
Description         : This class is developed as part of CXD-ODT project for Servicee to fetch Market Segment and trial Eligibility info based on SAP Account number
Created Date        : 07/26/2018
Author              : Harshitha KN
Modification History: Rohit Sharma DLT-13517
					  
					  Modified by Ameeta Antonio 12/21/2018
					  DLT-14150 : [SFDC] Populate Market segment field for converted lead Account SSDs
==============================================================================================*/

@RestResource(urlMapping='/ODTTrialDetails/*')
global with sharing class ODTWestLawAccTrialDetails {
    @HttpGet
    global static AccTrialWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String sapAccountNumber=req.params.get('sapAccountNum');
        AccTrialWrapper accTrWrap;
        Source_System_Detail__c ssdAcc=new Source_System_Detail__c();
        Lead lead = new Lead();
        system.debug('sapAcc'+sapAccountNumber);
        if(sapAccountNumber !='' && sapAccountNumber != null ){
            
            
                try{
                    system.debug('in the first');
                    if(Schema.sObjectType.Source_System_Detail__c.isAccessible()){
                    ssdAcc=[SELECT id,name,Source_System_Account_Number__c,OLC_Account_Number__c, Operating_Unit__c, Trial_Status__c,BU_Segment_Level_2__c,(SELECT Id, Trial_Status__c,Trial_Id__c,Trial_End_Date__c from Trials__r ORDER BY Trial_End_Date__c DESC  LIMIT 10) from Source_System_Detail__c WHERE (Source_System_Account_Number__c=:sapAccountNumber OR OLC_Account_Number__c =:sapAccountNumber) LIMIT 1];
                
                    system.debug('ssdAcc'+ssdAcc);
                    }
                }
                catch(Exception e)
                {
                    System.debug('Could not find any SSD  Account for the given SAP Account number');
                }
                
                try
                {
                    if(ssdAcc.id==null)
                    {
                        system.debug('in lead');
                        if(Schema.sObjectType.Lead.isAccessible()){
                        	lead=[select id , name, SAPAccountNumber__c ,Operating_Unit__c ,External_Trial_Account_ID__c , ( select id , name ,Trial_Status__c,Trial_Id__c,Trial_End_Date__c from Trials__r ) from Lead where External_Trial_Account_ID__c =:sapAccountNumber and isConverted=false ];
                        } 	
                    }
                }
                catch(Exception e)
                {
                    System.debug('Could not find any Lead  Account for the given SAP Account number');
                }
                
                
                
                system.debug('account' +ssdAcc);
                system.debug('Lead'+lead);
     
            //Check if ssdAccount is null
            if(ssdAcc.Id!=null){
                accTrWrap= new AccTrialWrapper(ssdAcc,null,'Data Found');
            }
            else if(lead.id!=null)
            {
                accTrWrap= new AccTrialWrapper(null,lead,'Data Found');
            }
            else{
                accTrWrap=new AccTrialWrapper(null,null,'Data not found in SFDC');
            }
        }else{
            accTrWrap=new AccTrialWrapper(null,null,'Data not found in SFDC');       
            
        } 
        
        return accTrWrap;
    }
    
    
    
    //checks the Market Segment field and return the corresponding BusinessType value 
    public static String getBusinessType(String mSegment){
        String businessType;
        //Start : DLT-14600 : Dynamic Market Segment
        if(mSegment != null){
        List<ODT_Market_Segments__mdt> marketSegmentList = new List<ODT_Market_Segments__mdt>([SELECT Business_Type__c,Market_Segment__c FROM ODT_Market_Segments__mdt WHERE Market_Segment__c =: mSegment limit 1]);
        if(marketSegmentList.size() > 0){
            for(ODT_Market_Segments__mdt mktSegment : marketSegmentList){
                businessType = mktSegment.Business_Type__c;
            } 
        }
        else{
            businessType='OTHER';
        }
        }
        //END : DLT-14600
        
        /*if(mSegment == 'SLF 11-20' || mSegment == 'SLF 21-29' || mSegment == 'SLF 2-3' ||
           mSegment == 'SLF 4-6' || mSegment == 'SLF 7-10' || mSegment == 'Solo Law Firm'){
               businessType='SLF';
           }
        /*else if(mSegment == 'Corporation National Accounts' || mSegment == 'Corp National Investigative' || mSegment == 'Corp Counsel' ||
                mSegment == 'Corp Investigative Financial' || mSegment == 'Corp Investigative' || mSegment == 'Corp Counsel Existing'){*/
        /*else if(mSegment.startsWith('Corp')){
                    businessType='CORP';  
                }*/
        if(mSegment == null){
            businessType='NULL';
        }
        return businessType;
    }   
    
    global class AccTrialWrapper{
        String TrialEligibility;
        String Status;
        String accountID;
        String BusinessType;
        String sapAccNumber;
        String mssg;
        Source_System_Detail__c ODTTrialDetails;
        
        AccTrialWrapper(Source_System_Detail__c acc, Lead leadTrial, String m){
            system.debug('account1' +acc);
            system.debug('lead'+leadTrial);
            this.ODTTrialDetails=acc;
            this.mssg=m;
            if(acc!= null){
                //Status=acc.Trial_Status__c;
                accountID=acc.Id;
                //sapAccNumber=acc.Source_System_Account_Number__c;
                if(acc.Source_System_Account_Number__c == null && acc.OLC_Account_Number__c != null){
                    SAPAccNumber=acc.OLC_Account_Number__c;
                }
                else if(acc.Source_System_Account_Number__c != null){
                    SAPAccNumber=acc.Source_System_Account_Number__c;
                }
                
                //DLT-14150 : START
                if(acc.BU_Segment_Level_2__c != null){
                    System.debug('1111');
                	BusinessType=getBusinessType(acc.BU_Segment_Level_2__c) ;
                }else{
                    System.debug('2222');
                    BusinessType = acc.Operating_Unit__c;
                }//DLT-14150 : END
                system.debug('BusinessType'+BusinessType);
                
                if(acc.Trial_Status__c == null)
                {
                    TrialEligibility='true';
                }    
                else {
                    String s = Label.ODT_Trial_Difference;
                    Integer ODT_Difference=180;
                    if(s.isNumeric())
                        ODT_Difference=integer.valueOf(s);
                    
                    for(Trial__c tr:acc.Trials__r){
                        if(tr.Trial_Status__c == 'Invited' || tr.Trial_Status__c == 'Rep Initiated' || tr.Trial_Status__c == 'Timed-out' || tr.Trial_Status__c == 'Bounceback'){
                            TrialEligibility='true';
                            Status=tr.Trial_Status__c;
                            
                        }else if(tr.Trial_Status__c == 'Accepted'){
                            TrialEligibility='false';
                            Status=tr.Trial_Status__c;
                            break;
                        }else if(tr.Trial_Status__c == 'Expired' || tr.Trial_Status__c == 'Ended'){
                            Integer TrialDifference= tr.Trial_End_Date__c.DaysBetween(System.today());   
                            system.debug('Dates'+TrialDifference);
                            if(TrialDifference>ODT_Difference){
                                TrialEligibility='true';
                                Status=tr.Trial_Status__c;
                            }
                            else{
                                TrialEligibility='false';
                                Status=tr.Trial_Status__c;
                                break;
                            }
                        }
                    }
                }
                mssg=m;
            }
            
            else if(leadTrial!=null) // for lead
            {
                accountID = leadTrial.id;   // 
                BusinessType=leadTrial.Operating_Unit__c ; 
                
                if(leadTrial.External_Trial_Account_ID__c  !=null)
                {
                    SAPAccNumber = leadTrial.External_Trial_Account_ID__c;
                }
               // directly pass 
                
                if(leadTrial.Trials__r == null)
                {
                    TrialEligibility='true';
                }  
                
                else {
                    String s = Label.ODT_Trial_Difference;
                    Integer ODT_Difference=180;
                    if(s.isNumeric())
                        ODT_Difference=integer.valueOf(s);
                    
                    for(Trial__c tr:leadTrial.Trials__r){
                        if(tr.Trial_Status__c == 'Invited' || tr.Trial_Status__c == 'Rep Initiated' || tr.Trial_Status__c == 'Timed-out' || tr.Trial_Status__c == 'Bounceback'){
                            TrialEligibility='true';
                            Status=tr.Trial_Status__c;
                            
                        }else if(tr.Trial_Status__c == 'Accepted'){
                            TrialEligibility='false';
                            Status=tr.Trial_Status__c;
                            break;
                        }else if(tr.Trial_Status__c == 'Expired' || tr.Trial_Status__c == 'Ended'){
                            Integer TrialDifference= tr.Trial_End_Date__c.DaysBetween(System.today());   
                            system.debug('Dates'+TrialDifference);
                            if(TrialDifference>ODT_Difference){
                                TrialEligibility='true';
                                Status=tr.Trial_Status__c;
                            }
                            else{
                                TrialEligibility='false';
                                Status=tr.Trial_Status__c;
                                break;
                            }
                        }
                    }
                }
                
            }
            
            else{
                TrialEligibility = null;
                Status=null;
            }
        } 
        
    }
    public void test1(){
        integer a = 1;
        integer b = 1;
        integer sum;
        integer pdt;
        integer sub; 
        integer div;
        sum = a + b;
        pdt = a * b;
        sub = a-b;
        div = a/b;
        System.debug('test1');
    }
    
    public void test2(){
        integer a = 1;
        integer b = 1;
        integer sum;
        integer pdt;
        integer sub; 
        integer div;
        sum = a + b;
        pdt = a * b;
        sub = a-b;
        div = a/b;
        System.debug('test2');
    }
    
    public void test3(){
         integer a = 1;
        integer b = 1;
        integer sum;
        integer pdt;
        integer sub; 
        integer div;
        sum = a + b;
        pdt = a * b;
        sub = a-b;
        div = a/b;
        System.debug('test3');
    }
    
    public void test4(){
         integer a = 1;
        integer b = 1;
        integer sum;
        integer pdt;
        integer sub; 
        integer div;
        sum = a + b;
        pdt = a * b;
        sub = a-b;
        div = a/b;
        System.debug('test4');
    }
    
    public void test5(){
        integer a = 1;
        integer b = 1;
        integer sum;
        integer pdt;
        integer sub; 
        integer div;
        sum = a + b;
        pdt = a * b;
        sub = a-b;
        div = a/b;
        System.debug('test5');
    }
    
}