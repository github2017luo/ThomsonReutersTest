/* CHANGE HISTORY
==================================================================================================================================
Date         Name                  Description
2018-06-19   Srikanth Kota         DLT-9757 - APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.
2018-12-27   Srikanth Kota         DLT-14154 - Fix code scan performance issues for Digital_MasterContactsBatch.
2019-01-04   Srikanth Kota         DLT-14323 - Fix code scan performance issues for Digital_MasterContactsBatch.
==================================================================================================================================   
*/
public with sharing class Digital_MasterContactsBatch implements  Database.AllowsCallouts, Database.Batchable<Apttus_Proposal__Proposal__c>{
    
    Public static list<Apttus_Proposal__Proposal__c> proposalList = [select id,Previous_Order_Confirmation_SSD_Contact__c,APTS_Order_Confirmation_Contact__r.FirstName,APTS_Order_Confirmation_Contact__r.LastName,APTS_Order_Confirmation_Contact_Email__c,is_Digital_Channel__c from Apttus_Proposal__Proposal__c where is_Digital_Channel__c = TRUE AND Digital_Batch_Processed__c = TRUE AND APTS_Validation_Messages__c != Null AND Digital_Quote_Type__c IN ('Best Value','Best Value+Config','Premium') AND Digital_Has_Line_Items__c > 0 AND APTS_Order_Confirmation_Contact_Email__c != Null AND Apttus_Proposal__Approval_Stage__c IN ('Draft','Approved') AND ID NOT IN (select Quote__C from Customer_Master_Contacts__c) AND ID IN (select Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Digital_Pending_Cart__c = FALSE) ];
    //Public static list<Apttus_Proposal__Proposal__c> proposalList = [select id,Previous_Order_Confirmation_SSD_Contact__c,APTS_Order_Confirmation_Contact__r.FirstName,APTS_Order_Confirmation_Contact__r.LastName,APTS_Order_Confirmation_Contact_Email__c,is_Digital_Channel__c from Apttus_Proposal__Proposal__c where id='a4N1B000002VV0Y' ];
    
    public Iterable<Apttus_Proposal__Proposal__c> start(database.batchablecontext bCont){
        
        System.debug('proposalList===============>'+proposalList);
        return proposalList;
    }
    
    public void execute(Database.BatchableContext bCont, List<Apttus_Proposal__Proposal__c> scope){
        
        
        Pagereference pr;
        
        for(Apttus_Proposal__Proposal__c quote : scope){
            try{                           
                ApexPages.StandardController scon = new ApexPages.StandardController(quote);
                Digital_MasterContactsController mcon = new Digital_MasterContactsController(scon);                
                
                if(mcon.patronConList.size() > 0 && (mcon.patronConList[0].mstrCon.First_Name__c == Null || mcon.patronConList[0].mstrCon.Last_Name__c == Null || mcon.patronConList[0].mstrCon.Email_Address__c == Null)){
                    
                    mcon.patronConList[0].mstrCon.First_Name__c  = quote.APTS_Order_Confirmation_Contact__r.FirstName;
                    mcon.patronConList[0].mstrCon.Last_Name__c = quote.APTS_Order_Confirmation_Contact__r.LastName;
                    mcon.patronConList[0].mstrCon.Email_Address__c = quote.APTS_Order_Confirmation_Contact_Email__c;
                    mcon.patronConList[0].mstrCon.Contact_SDD__c = quote.Previous_Order_Confirmation_SSD_Contact__c;
                    
                }    
                
                if(mcon.clrPrimaryList.size() > 0 && (mcon.clrPrimaryList[0].mstrCon.First_Name__c == Null || mcon.clrPrimaryList[0].mstrCon.Last_Name__c == Null || mcon.clrPrimaryList[0].mstrCon.Email_Address__c == Null)){
                    mcon.clrPrimaryList[0].mstrCon.First_Name__c  = quote.APTS_Order_Confirmation_Contact__r.FirstName;
                    mcon.clrPrimaryList[0].mstrCon.Last_Name__c = quote.APTS_Order_Confirmation_Contact__r.LastName;
                    mcon.clrPrimaryList[0].mstrCon.Email_Address__c = quote.APTS_Order_Confirmation_Contact_Email__c;
                    mcon.clrPrimaryList[0].mstrCon.Contact__c = quote.APTS_Order_Confirmation_Contact__c;
                    //mcon.clrPrimaryList[0].mstrCon.Contact_SDD__c = quote.Previous_Order_Confirmation_SSD_Contact__c;
                }
                //   pr = mcon.save();
                
                if(mcon.ebConList.size() > 0 && (mcon.ebConList[0].mstrCon.First_Name__c == Null || mcon.ebConList[0].mstrCon.Last_Name__c == Null || mcon.ebConList[0].mstrCon.Email_Address__c == Null)){
                    mcon.ebConList[0].mstrCon.First_Name__c  = quote.APTS_Order_Confirmation_Contact__r.FirstName;
                    mcon.ebConList[0].mstrCon.Last_Name__c = quote.APTS_Order_Confirmation_Contact__r.LastName;
                    mcon.ebConList[0].mstrCon.Email_Address__c = quote.APTS_Order_Confirmation_Contact_Email__c;
                    mcon.ebConList[0].mstrCon.Contact__c = quote.APTS_Order_Confirmation_Contact__c;
                    //mcon.ebConList[0].mstrCon.Contact_SDD__c = quote.Previous_Order_Confirmation_SSD_Contact__c;
                }
                // pr = mcon.save();
                
                if(mcon.techConList.size() > 0 && (mcon.techConList[0].mstrCon.First_Name__c == Null || mcon.techConList[0].mstrCon.Last_Name__c == Null || mcon.techConList[0].mstrCon.Email_Address__c == Null)){
                    mcon.techConList[0].mstrCon.First_Name__c  = quote.APTS_Order_Confirmation_Contact__r.FirstName;
                    mcon.techConList[0].mstrCon.Last_Name__c = quote.APTS_Order_Confirmation_Contact__r.LastName;
                    mcon.techConList[0].mstrCon.Email_Address__c = quote.APTS_Order_Confirmation_Contact_Email__c;
                    mcon.techConList[0].mstrCon.Contact__c = quote.APTS_Order_Confirmation_Contact__c;
                    //mcon.techConList[0].mstrCon.Contact_SDD__c = quote.Previous_Order_Confirmation_SSD_Contact__c;
                }
                
                if(mcon.pwdEmailList.size() > 0 && (mcon.pwdEmailList[0].mstrCon.First_Name__c == Null || mcon.pwdEmailList[0].mstrCon.Last_Name__c == Null || mcon.pwdEmailList[0].mstrCon.Email_Address__c == Null)){                 
                    mcon.pwdEmailList[0].mstrCon.First_Name__c = quote.APTS_Order_Confirmation_Contact__r.FirstName;
                    mcon.pwdEmailList[0].mstrCon.Last_Name__c = quote.APTS_Order_Confirmation_Contact__r.LastName;
                    mcon.pwdEmailList[0].mstrCon.Email_Address__c = quote.APTS_Order_Confirmation_Contact_Email__c;
                    mcon.pwdEmailList[0].mstrCon.Contact__c = quote.APTS_Order_Confirmation_Contact__c;
                    //mcon.pwdEmailList[0].mstrCon.Contact_SDD__c = quote.Previous_Order_Confirmation_SSD_Contact__c;
                }
                
                pr = mcon.save();  
            }
            catch(Exception e){
                
                createExceptionLog(e.getMessage(), e.getStackTraceString(),String.valueof(e.getLineNumber()));
                System.debug('String.valueof(e.getCause())===============>'+String.valueof(e.getCause()));
            }
        }
    }
    
    //DLT-14323 
    public void  createExceptionLog(String exMessage, String exType, String additionalInfo) {
        
        List<Digital_Exception_Log__c> dsExList = new List<Digital_Exception_Log__c>(); 
        
        Digital_Exception_Log__c ex = new Digital_Exception_Log__c();
        
        ex.Exception_Message__c = exMessage;
        ex.Exception_Type__c = exType;
        ex.Additional_Information__c = additionalInfo;            
        ex.Class_Reference__c = 'Digital_MasterContactsBatch > Execute' ;
        dsExList.add(ex);
        if(dsExList != Null && dsExList.size() > 0 && Schema.sObjectType.Digital_Exception_Log__c.isCreateable()){
            
            Database.insert(dsExList,false); 
        }
    }
    
    public void finish(Database.BatchableContext info){
        
        if(!Test.isRunningTest()){
            Digital_PasswordHoldersBatch dph = new Digital_PasswordHoldersBatch();
            Database.executeBatch(dph, 1);
        }
    }
    
}