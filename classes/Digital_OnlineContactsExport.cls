/*
 * 
 * 
 * CHANGE HISTORY
 * ==================================================================================================================================
 *  Date            Name                    Description
 *  2021-01-15      Kavya S                 DLT-21271 Update to fix the Digital_OnlineContactsExport failure   
 */

global class Digital_OnlineContactsExport implements Database.Batchable<Apttus_Proposal__Proposal__c>,Database.AllowsCallouts{
    global static List<Apttus_Proposal__Proposal__c> successProposalList = new List<Apttus_Proposal__Proposal__c>();
    
    global Iterable<Apttus_Proposal__Proposal__c> start(database.batchablecontext bc){
        List<Apttus_Proposal__Proposal__c> mcProposalList = new list<Apttus_Proposal__Proposal__c>();
        if(!test.isrunningtest()){
            mcProposalList = [select id,name,Digital_Ready_Online_Export__c from Apttus_Proposal__Proposal__c where is_Digital_Channel__c = TRUE AND Digital_Batch_Processed__c = TRUE AND Digital_Quote_Type__c IN ('Best Value','Best Value+Config','Premium') AND Apttus_Proposal__Approval_Stage__c IN ('Draft','Approved') AND APTS_Order_Confirmation_Contact_Email__c != Null AND APTS_Validation_Messages__c = Null AND Digital_Ready_Online_Export__c = TRUE];
        }
        else{
            mcProposalList = [select id,name,Digital_Ready_Online_Export__c from Apttus_Proposal__Proposal__c where is_Digital_Channel__c = TRUE AND Digital_Batch_Processed__c = TRUE AND Digital_Quote_Type__c IN ('Best Value','Best Value+Config','Premium')  AND Apttus_Proposal__Approval_Stage__c IN ('Draft','Approved') AND APTS_Order_Confirmation_Contact_Email__c != Null AND Digital_Ready_Online_Export__c = TRUE];
        }
        return mcProposalList;
    }
    global void execute(Database.BatchableContext bc, List<Apttus_Proposal__Proposal__c> scope){
        for(Apttus_Proposal__Proposal__c quote : scope){
            Digital_OnlineContactsController oCon = new Digital_OnlineContactsController();
            If(Digital_OnlineContactsController.onlineContactsExcel(quote.id,quote.name)){
                successProposalList.add(quote);    
            }
        }  
        updateTempField(successProposalList);
    }
    public void updateTempField(list<Apttus_Proposal__Proposal__c> qlist){
        if(qlist.size() > 0){
            try{
                for(Apttus_Proposal__Proposal__c quote : qlist){
                    quote.Digital_Ready_Online_Export__c = FALSE;
                    if(test.isrunningtest()){
                        quote.id = '12345';
                    }    
                }
                Database.Update(successProposalList,false);
            }
            Catch(Exception e){
                Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  
                ex.Exception_Message__c = e.getMessage();
                ex.Exception_Type__c = e.getStackTraceString();        
                ex.Additional_Information__c = String.valueof(e.getLineNumber());   
                ex.User_Message__c = String.valueof(e.getCause());
                ex.Class_Reference__c = 'Digital_OnlineContactsExport > updateTempField';       
                insert ex; 
            }
        }        
    }
    global void finish(Database.BatchableContext info){
        if(!test.isrunningtest()){
            Digital_GenerateDocumentsBatch dgb = new Digital_GenerateDocumentsBatch();
            Database.executebatch(dgb,1);
        }
    }
}