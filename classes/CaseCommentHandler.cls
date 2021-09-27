public without sharing class CaseCommentHandler 
{
    public static void getListOfCase(Map<ID,CaseComment> mapOfComments){
        Map <ID, String> mapOfIds= new Map<Id,string>();
        List<Case> listofCases = CaseCommentHelper.getValidCase(mapOfComments.keySet());
        Map<ID,String> mapOfStatus=new Map<ID,String>();
        for(Case ocase:listofCases){
            mapOfStatus.put(ocase.ID,'Alert : New Comment is added for Case Number:' );
        }
        Map <ID,List<String>> follower=CaseCommentHelper.getListofFollower(listofCases);
        CaseCommentHelper.sendEmailMessage(listofCases,follower, mapOfStatus);
    }
    
    
    public static void getListOfEmail(Map<ID,Emailmessage> mapOfEmails){
        Map <ID, String> mapOfIds= new Map<Id,string>();
        list<Case> listOfEmail=CaseCommentHelper.getValidCase(mapOfEmails.keySet());
        Map <ID,List<String>> follower=CaseCommentHelper.getListofFollower(listOfEmail);
        Map<ID,String> mapOfStatus=new Map<ID,String>();
        for(Emailmessage emailRec : mapOfEmails.values()){
            if(emailRec.Incoming==true){
                mapOfStatus.put(emailRec.ParentId,'Alert : Incoming Emails is recieved for Case Number:' );
            }else{
                mapOfStatus.put(emailRec.ParentId,'Alert : Outgoing Emails is sent for Case Number :' );
            }
        }
        CaseCommentHelper.sendEmailMessage(listOfEmail, follower, mapOfStatus);
    }
    
    public static void sendEmailonCaseFieldUpdate(Map<Id,case>newCaseMap, Map<Id,case> oldCaseMap){
        List<Case> listofCases = new List<Case>();
        Map<ID,String> mapOfStatus=new Map<ID,String>();
        Map<id,String> caseOwnerIdMap= new Map<id,String>();
        List<Case> cases = new List<Case>();
        if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isQueryable()){
            cases = [SELECT Id,Sales_Org__c,Recordtype.DeveloperName,CaseNumber,OwnerId,Subject,Priority,Account.name, Owner.name, Contact.name,Status,Product.name,Description,ParentId,Parent.CaseNumber,Product__c
                            FROM Case Where ID IN: newCaseMap.keySet()];
        }        

            for(Case caseRec : cases ){
                Case oldCaseRec = oldCaseMap.get(caseRec.Id);
                system.debug('$$$$$ RT:'+caseRec.Recordtype.DeveloperName +'Sales Org: ' +caseRec.Sales_Org__c +'Staus' +caseRec.Status +'Ostatus' +oldCaseRec.Status +'ParentId' +caseRec.ParentId +'OParentId' +oldCaseRec.ParentId);
                if (caseRec.Recordtype.DeveloperName =='ANZ' && (caseRec.Sales_Org__c =='BKRS' || caseRec.Sales_Org__c =='LRA') && caseRec.Subject != 'Triggered' 
                    && (caseRec.Status != oldCaseRec.Status || caseRec.ParentId != oldCaseRec.ParentId) ){
                        listofCases.add(caseRec);
                        caseOwnerIdMap.put(caseRec.Id,caseRec.OwnerId);
                        if((caseRec.Status != oldCaseRec.Status) &&(caseRec.ParentId != oldCaseRec.ParentId)){
                            mapOfStatus.put(caseRec.id,'Alert : Parent ID for Case is Changed to '+caseRec.Parent.CaseNumber +' and Status for Case is Changed from '+oldCaseRec.Status+ '  to '+caseRec.Status +' for Case Number:');
                        }
                        else if((caseRec.ParentId != oldCaseRec.ParentId) && (caseRec.Status == oldCaseRec.Status)){
                            mapOfStatus.put(caseRec.id,'Alert : Parent ID for Case is Changed to '+caseRec.Parent.CaseNumber +' for Case Number:');
                        }
                        else{
                            mapOfStatus.put(caseRec.id,'Alert : Status for Case is Changed from '+oldCaseRec.Status+ ' to '+caseRec.Status +' for Case Number:');
                        } 
                        
                    }
            }           
        
            Map <ID,List<String>> follower = CaseCommentHelper.getListofFollower(listofCases); 
            CaseCommentHelper.sendEmailMessage(listofCases,follower,mapOfStatus);

    }   
}