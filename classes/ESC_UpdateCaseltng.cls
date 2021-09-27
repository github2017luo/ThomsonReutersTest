public without sharing class ESC_UpdateCaseltng {
    
    @AuraEnabled
    public static String reopenCase(Id caseId){
        
        Case oCase = new Case();
        
        try{
            if (Schema.sObjectType.Case.isAccessible()){
                oCase = [Select Id, RecordTypeId,RecordType.Name, Status, ESC_Fix_Applied_Time__c, ESC_Resolved_by__c, 
                         ESC_Service_Restored__c from Case where id = : caseId];
            }
            String openRecordType =oCase.RecordType.Name.substringBefore(' (');
            
            if(oCase != null)
            {
                oCase.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(openRecordType).getRecordTypeId();
                oCase.Status = 'Work In Progress';
                oCase.ESC_Fix_Applied_Time__c = null;
                oCase.ESC_Resolved_by__c = null;
                oCase.ESC_Service_Restored__c = null;
                if (Schema.sObjectType.Case.isUpdateable()){
                    update oCase;
                }
            }
            
            return 'Success';
        }
        catch(Exception ex)
        {
            return 'Failure';
        }
        
        //return oCase;
    }
    
    @AuraEnabled
    public static String sendCaseRequest(Id caseId, String type)
    {
        String result = '';
        Id selectCaseID = caseId;
        String recType = type;
        Boolean isComplaint = false;
        
        try{
            Case oSelectedCase = [Select id, casenumber, accountId,contactId, Status,ParentId,
                                  Ownerid, ESC_Preferred_Contact_Method__c,Subject, ESC_Case_Sub_Type__c, Description
                                  FROM Case
                                  WHERE Id = :selectCaseID];
            
            Case caseRec = new Case();
            caseRec.accountId = oSelectedCase.accountId;
            caseRec.contactId = oSelectedCase.contactId;
            caseRec.Status = 'Work In Progress';
            caseRec.Ownerid = UserInfo.getUserId();
            caseRec.ESC_Preferred_Contact_Method__c = oSelectedCase.ESC_Preferred_Contact_Method__c;
            caseRec.Subject = oSelectedCase.Subject;
            caseRec.Description = oSelectedCase.Description;
            caseRec.ParentId = oSelectedCase.id;
            if(rectype=='EnhancementRequest'){
                caseRec.ESC_Case_Type__c = 'Enhancement Request';
                caseRec.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRec.ESC_Case_Type__c).getRecordTypeId();
                isComplaint = false;
            }
            else if(rectype == 'Feedback' ){
                caseRec.ESC_Case_Type__c = 'Feedback';  
                caseRec.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRec.ESC_Case_Type__c).getRecordTypeId();          
                isComplaint = false;
            }
            else if(rectype == 'Complaint'){
                isComplaint = true;
                caseRec.ESC_Case_Type__c = 'Feedback';
                caseRec.RecordtypeID=Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRec.ESC_Case_Type__c).getRecordTypeId();
                caseRec.ESC_Case_Sub_Type__c = 'Complaint';
                //caseRec.ParentId = oSelectedCase.id;
                
            }
            if (Schema.sObjectType.Case.isCreateable()){
                insert caseRec;
            }
            List<FeedItem> listPost= new List<FeedItem>();
            
            ID idOfRecord = caseRec.id;
            if (Schema.sObjectType.case.isAccessible()){
                caseRec = [select casenumber from case where id =:idOfRecord];
            }
            FeedItem post= new FeedItem();
            post.ParentId= oSelectedCase.id;
            string userName=UserInfo.getName();
            if(rectype == 'Feedback' ){
                post.Body=userName+' '+System.Label.ESC_FeedbackMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
                listpost.add(post);
            }
            else if(rectype == 'Complaint'){ 
                post.Body=userName+' '+System.Label.ESC_ComplaintMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
                listpost.add(post);   
            }
            else if(rectype == 'EnhancementRequest' ){
                post.Body=userName+' '+System.Label.ESC_ERMessage+' '+caseRec.casenumber+' '+System.Label.ESC_CaseMessage;
                listpost.add(post);
            }
            if(listpost.size()>0){
                insert listpost;
            }
            /*  
if(!isComplaint){
Case pcase = [select id,parentId,casenumber from case where id=:oSelectedCase.id];
Case updCase = new Case();
updCase.id = pcase.id;
updCase.parentId = caseRec.Id;
update updCase;
}*/
            
            return caseRec.Id;
        }
        catch(Exception ex)
        {
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean validateCaseHasParentId(Id caseId, String type)
    {
        Case oCase = [Select Id,RecordType.Name, ParentID from Case where id = : caseId];
        
        if(String.isNotBlank(oCase.ParentID) && !type.equalsIgnoreCase('Complaint')){
            return true;
        }
        else{
            return false;
        }
        
    }
    
    @AuraEnabled
    public static String closeCase(Id caseId)
    {
        system.debug('I ma here');
        Case oCase = [Select id, Status,OwnerId from Case where Id = :caseId];
        try{
            if(oCase != null)
            {
             //if(string.valueOf(oCase.OwnerId).startsWith('005'))
             {
                oCase.status = 'Closed';
                update oCase;
            }
            //else{
             //    return 'error';
              //   }
             }
            return 'No Error';
        }
        catch(Exception ex)
        {
            return '';
        }
    }
    @AuraEnabled
    public static String UpdateRecordType(Id caseId)
    {
        system.debug('I ma here in UpdateRecordType');
        Case oCase = new Case();
        oCase = [Select id, Status,ESC_Case_Type__c,AccountId,ContactId,ownerid from Case where Id = :caseId];
        //String openRecordType =oCase.RecordType.Name.substringBefore(' (');
        try{
            if(oCase != null)
            {
               // oCase.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(openRecordType).getRecordTypeId();
               // if (Schema.sObjectType.Case.isUpdateable()){
               //     update oCase;
               // }
            }
            
            return 'Success';
        }
        catch(Exception ex)
        {
            return 'Failure';
        }
    }
    @AuraEnabled
    public static List<Case> getRecTypeId(Id caseId)
    {    
        
        List<Case> lstCase = new List<case>();
        if (Schema.sObjectType.case.isAccessible()){
            lstCase = [select id,recordtypeid,recordType.Developername from case where id=:caseId];
        }
        return lstCase;
    }
    
    @AuraEnabled
    public static String createCaseFromContact(String contactID)
    {
        Id conId = contactID;
        Contact objCon;
        try{
            if (Schema.sObjectType.Contact.isAccessible()){
                objCon=[Select Id,AccountId From Contact where Id =: conId];
            }
            //String curUserTimeZone = [Select TimeZoneSidKey from User where id =: USerInfo.getUserId()].TimeZoneSidKey;
            String curUserTimeZone = String.valueof(UserInfo.getTimeZone());
            List<businesshours> curUserBH =new List<businesshours>();
            if (Schema.sObjectType.businesshours.isAccessible()){
                curUserBH = [select TimeZoneSidKey,isactive, name from businesshours where TimeZoneSidKey=:curUserTimeZone and isactive=true limit 1];
            }
                                                
            Case oCase = new Case();
            List<ESC_CasefromContactFieldValueList__c> cc= ESC_CasefromContactFieldValueList__c.getall().values();
                                                
        String recordtypeId ='';
        String rectype='';
        String bhrs='';
        rectype = ESC_SegmentregionUtility.getDetailInfo(contactId,'Rectype');
        //bhrs = ESC_SegmentregionUtility.getDetailInfo(contactId,'BusHrs');
                                if(rectype!=''){
            recordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(rectype).recordTypeId;
        }
            for(ESC_CasefromContactFieldValueList__c c:cc){
                
            if(c.Name=='RecordTypeId'){
            if(recordtypeId ==''){
                recordtypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get(c.ESC_Value__c).RecordTypeId;
            }
            c.ESC_Value__c=recordtypeId;
            }
            oCase.put(c.Name,c.ESC_Value__c);
                
            }
            if(!LCRMGenericComponent.isLotusUser()){
            if(bhrs ==''){
            if(curUserBH.size()>0){
                oCase.BusinessHoursId = curUserBH[0].Id;
            }
            }else{
              oCase.BusinessHoursId = bhrs;
            }
            }
            //oCase.ESC_User_Timezone__c = curUserTimeZone ;
            oCase.AccountId = objCon.AccountId;
            oCase.ContactId = objCon.Id;
             if(!LCRMGenericComponent.isLotusUser()){
                   oCase=GLIGenericUtilityHelper.setGLI(oCase);
             }else{
                   if(oCase.Sales_Org__c==null){
                             oCase.Sales_Org__c='GLI';
             }
             }
        insert oCase;
            system.debug('case Id: ' + oCase.Id); 
            return oCase.id;
        }
        catch(Exception ex)
        {
            system.debug('Exception: ' + ex);
            return null;
        }
    }
    
}