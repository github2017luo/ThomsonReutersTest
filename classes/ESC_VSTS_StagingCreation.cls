public without sharing class ESC_VSTS_StagingCreation {
    
    @InvocableMethod(label='VSTS staging create' description='Create VSTS')
    
    public static void escVSTSStagingCreation(List<Id> referralList){
        
        
        system.debug('Referral List>>' +referralList);
          try{
            if(referralList == null || referralList.isEmpty()){
                return;
            }
            List<Id> caseIdList = new List<Id>();
            Map<String,String> specialInstructionMap= new Map<String,String>();
            
            for(ESC_Case_Collaborator__c ref:[Select id,ESC_Case__c from ESC_Case_Collaborator__c where id In: referralList]){
                caseIdList.add(ref.ESC_Case__c);
            }
            String recordtypeID=Schema.SObjectType.ESC_Special_Instruction__c.getRecordTypeInfosByName().get('Account Instruction').getRecordTypeId();
            
            System.debug('recordtypeID of special instruction>>>' +recordtypeID);
            system.debug('List value>>' +caseIdList);
             
            for(ESC_Case_Special_Instruction__c sp :[Select id,ESC_Case__c,ESC_Special_Instruction__r.RecordType.Id,ESC_Special_Instruction__r.ESC_Category_Account__c,ESC_Special_Instruction__r.ESC_Instructions__c from ESC_Case_Special_Instruction__c where ESC_Case__c in:caseIdList AND ESC_Special_Instruction__r.RecordType.Id=:recordtypeID AND ESC_Special_Instruction__r.ESC_Status__c='Active']){
                if(sp.ESC_Special_Instruction__r.ESC_Category_Account__c=='Premium Support Account' && sp.ESC_Special_Instruction__r.ESC_Instructions__c=='A'){
                    specialInstructionMap.put(sp.ESC_Case__c,'A');
                    break;
                }
                else{
                    specialInstructionMap.put(sp.ESC_Case__c,'B');
                }
            }
            //code block start for DSS-5235
            Map<String,ESC_VSTS_Product_List__c> prodListmap = ESC_VSTS_Product_List__c.getall();
            Set<string> prodList =prodListmap.keySet();
            System.debug('prodList--->'+prodList);
            System.debug('ProdListmap--->'+prodListmap);
            //code block end for DSS-5235
            List<ESC_VSTS_Staging__c> stagingList = new List<ESC_VSTS_Staging__c>();
            List<ESC_VSTS_Staging__c> stagingListOld = new List<ESC_VSTS_Staging__c>();
            ESC_VSTS_Routing__c vstsRouting= ESC_VSTS_Routing__c.getInstance();
            ESC_VSTS_Staging__c stagingOld = new ESC_VSTS_Staging__c();
            
            for(ESC_VSTS_Staging__c stg : [Select Id, ESC_Case_Number__c, ESC_Case_Id__c, ESC_Case_Product__c, ESC_Case_Product_Complement__c, CreatedDate, ESC_Staging_Status__c, ESC_RequestType__c from ESC_VSTS_Staging__c where ESC_Case_Id__c in : caseIdList Order by CreatedDate DESC Limit 1]){
             if(stg.ESC_Staging_Status__c == 'Success' && (stg.ESC_RequestType__c =='create' || stg.ESC_RequestType__c == 'reopen')){
                stagingListOld.add(stg);
             }
            }
            system.debug('stagingListOld' +stagingListOld);
            if(stagingListOld.size() >0 && (Schema.sObjectType.ESC_VSTS_Staging__c.isAccessible() || Schema.sObjectType.ESC_VSTS_Staging__c.isQueryable())){
                stagingOld = [Select Id, ESC_Case_Number__c, ESC_Case_Id__c, ESC_Case_Product__c, ESC_Case_Product_Complement__c, ESC_Staging_Status__c from ESC_VSTS_Staging__c where Id in : stagingListOld];
                 system.debug('Staging old record'+stagingOld);
                 
            }
            Map<Id,Group> ownerMap = new Map<Id,Group>([Select id,Name from Group where Type='Queue' and DeveloperName in :vstsRouting.VSTSAssignmentGroup__c.split(',')]);  
            for(ESC_Case_Collaborator__c cs: [Select Id,ESC_Case__r.ESC_VSTS_Id__c,ESC_Referral_Status__c,ESC_Case__r.Id,ESC_Case__r.Subject, ESC_Case__r.SAP_Account_Number__c,ESC_Case__r.ESC_Severity__c,ESC_Case__r.CaseNumber,ESC_Case__r.CreatedDate,ESC_Case__r.ESC_VSTS_Description__c,
                                              ESC_Case__r.Description,ESC_Case__r.Account.name,ESC_Case__r.Account.RecordType.Name,ESC_Case__r.GGO_Product_Complement_2__c,ESC_Case__r.GGO_Product_Version__c,ESC_Case__r.ESC_Product_Version__c,ESC_Case__r.ESC_IsAllowRepDB__c,ESC_Case__r.Status,ESC_Case__r.Product__c,ESC_Case__r.Priority,ESC_Case__r.Owner.name,ESC_Case__r.ESC_Diagnosis_Summary__c from ESC_Case_Collaborator__c where id In:referralList AND
                                              OwnerId In:ownerMap.keyset() AND ESC_Referral_Status__c!='Closed' AND ESC_Referral_Status__c!='Completed']){
                                                  system.debug('Referral List>>' +cs);
                                              //staging record creation for New Referral to VSTS    
                                                if(cs.ESC_Case__r.ESC_VSTS_Id__c==null || cs.ESC_Case__r.ESC_VSTS_Id__c==''){
                                                      ESC_VSTS_Staging__c staging = new ESC_VSTS_Staging__c();
                                                      
                                                      if(cs.ESC_Case__r.SAP_Account_Number__c==null || cs.ESC_Case__r.SAP_Account_Number__c==''){
                                                          staging.ESC_SAP_Account_Num__c= 'Empty';
                                                      }
                                                      else{
                                                          staging.ESC_SAP_Account_Num__c= cs.ESC_Case__r.SAP_Account_Number__c;
                                                      }
                                                      if(cs.ESC_Case__r.Account==null){
                                                          staging.ESC_Account_Name__c='Empty';
                                                      }
                                                      else{
                                                      staging.ESC_Account_Name__c=cs.ESC_Case__r.Account.name;
                                                      }
                                                      if(cs.ESC_Case__r.ESC_Severity__c=='Null' || cs.ESC_Case__r.ESC_Severity__c==null || cs.ESC_Case__r.ESC_Severity__c==''){
                                                          staging.ESC_Case_Severity__c='4 - Non-Service Affecting';
                                                      }
                                                      //added for DSS-9094
                                                      else if(cs.ESC_Case__r.ESC_Severity__c=='Critical'){
                                                          staging.ESC_Case_Severity__c='1 - High';
                                                      }
                                                      else{
                                                          staging.ESC_Case_Severity__c=cs.ESC_Case__r.ESC_Severity__c;
                                                      }
                                                      staging.ESC_Case_Number__c=cs.ESC_Case__r.CaseNumber;
                                                      staging.ESC_Case_Created_Date__c=cs.ESC_Case__r.CreatedDate;
                                                      staging.ESC_Case_Owner__c=cs.ESC_Case__r.Owner.name;
                                                      if((cs.ESC_Case__r.Description==null || cs.ESC_Case__r.Description=='')&& (cs.ESC_Case__r.ESC_VSTS_Description__c ==null || cs.ESC_Case__r.ESC_VSTS_Description__c =='')){
                                                          staging.ESC_Case_Description__c='Empty';
                                                      }
                                                      else if((cs.ESC_Case__r.Description==null || cs.ESC_Case__r.Description=='') && (cs.ESC_Case__r.ESC_VSTS_Description__c !=null && cs.ESC_Case__r.ESC_VSTS_Description__c !='')){
                                                          staging.ESC_Case_Description__c=cs.ESC_Case__r.ESC_VSTS_Description__c;
                                                      }
                                                      else if((cs.ESC_Case__r.Description!=null && cs.ESC_Case__r.Description !='') && (cs.ESC_Case__r.ESC_VSTS_Description__c ==null || cs.ESC_Case__r.ESC_VSTS_Description__c =='')){
                                                          staging.ESC_Case_Description__c=cs.ESC_Case__r.Description;
                                                      }
                                                      else{
                                                          staging.ESC_Case_Description__c=cs.ESC_Case__r.Description + '\n' + cs.ESC_Case__r.ESC_VSTS_Description__c;
                                                      }
                                                      if(cs.ESC_Case__r.Priority==null || cs.ESC_Case__r.Priority==''){
                                                          staging.ESC_Case_Priority__c='3 - Low';
                                                      }
                                                      else{
                                                          staging.ESC_Case_Priority__c=cs.ESC_Case__r.Priority;
                                                      }
                                                      staging.ESC_Referral_Id__c=cs.Id;
                                                      staging.ESC_RequestType__c='create';
                                                      staging.ESC_Case_Id__c=cs.ESC_Case__c;
                                                      //code block start for DSS-5235
                                                      if(cs.ESC_Case__r.ESC_Diagnosis_Summary__c==null || cs.ESC_Case__r.ESC_Diagnosis_Summary__c==''){
                                                          staging.ESC_Case_Diagnosis__c='Empty';
                                                      }
                                                      else if(cs.ESC_Case__r.ESC_Diagnosis_Summary__c == 'Assistive Technology'){
                                                      staging.ESC_Case_Diagnosis__c='1';
                                                      }
                                                      else{
                                                      staging.ESC_Case_Diagnosis__c='2';
                                                      }
                                                      if(cs.ESC_Case__r.Subject==null || cs.ESC_Case__r.Subject==''){
                                                        staging.ESC_Case_Subject__c='Empty';
                                                      }
                                                      else if((cs.ESC_Case__r.Subject).length() > Integer.ValueOf(Label.VSTS_Subject_length)) {
                                                        staging.ESC_Case_Subject__c=(cs.ESC_Case__r.Subject).left(Integer.ValueOf(Label.VSTS_Subject_length));
                                                      }
                                                      else{
                                                         staging.ESC_Case_Subject__c=cs.ESC_Case__r.Subject;
                                                      }
                                                      if(prodList.contains(cs.ESC_Case__r.Product__c)){
                                                          ESC_VSTS_Product_List__c myCS1 = ESC_VSTS_Product_List__c.getValues(cs.ESC_Case__r.Product__c);
                                                          staging.ESC_Case_Product__c = myCS1.Product_Code__c;
                                                      }
                                                      //code block end for DSS-5235
                                                      staging.ESC_Staging_Status__c='Pending';
                                                      staging.ESC_IsAllowRepDB__c=cs.ESC_Case__r.ESC_IsAllowRepDB__c;
                                                      
                                                      if(specialInstructionMap.size()>0){
                                                      staging.ESC_Customer_Category__c=specialInstructionMap.get(cs.ESC_Case__c);
                                                      }
                                                      if(cs.ESC_Case__r.GGO_Product_Complement_2__c==null || cs.ESC_Case__r.GGO_Product_Complement_2__c==''){
                                                          staging.ESC_Case_Product_Complement__c='Empty';
                                                      }
                                                      else{
                                                          staging.ESC_Case_Product_Complement__c=cs.ESC_Case__r.GGO_Product_Complement_2__c;
                                                      }
                                                      staging.ESC_Case_Product_Version__c=cs.ESC_Case__r.GGO_Product_Version__c;
                                                      if(cs.ESC_Case__r.Account.RecordType.Name=='Customer'){
                                                          staging.ESC_Is_Customer__c=true;
                                                      }
                                                      else{
                                                          staging.ESC_Is_Customer__c=false;
                                                      }
                                                      staging.ESC_SAP_TenancyName__c='Null';
                                                      stagingList.add(staging);
                                                  }
                                                  
                                                  else{
                                                  //staging record creation for Reopen ticket to VSTS 
                                                  ESC_VSTS_Staging__c staging = new ESC_VSTS_Staging__c();
                                                      
                                                      if(cs.ESC_Case__r.SAP_Account_Number__c==null || cs.ESC_Case__r.SAP_Account_Number__c==''){
                                                          staging.ESC_SAP_Account_Num__c= 'Empty';
                                                      }
                                                      else{
                                                          staging.ESC_SAP_Account_Num__c= cs.ESC_Case__r.SAP_Account_Number__c;
                                                      }
                                                      if(cs.ESC_Case__r.Account.name==null){
                                                          staging.ESC_Account_Name__c='Empty';
                                                      }
                                                      else{
                                                      staging.ESC_Account_Name__c=cs.ESC_Case__r.Account.name;
                                                      }
                                                      if(cs.ESC_Case__r.ESC_Severity__c=='Null' || cs.ESC_Case__r.ESC_Severity__c==null || cs.ESC_Case__r.ESC_Severity__c==''){
                                                          staging.ESC_Case_Severity__c='4 - Non-Service Affecting';
                                                      }
                                                      //added for DSS-9094
                                                      else if(cs.ESC_Case__r.ESC_Severity__c=='Critical'){
                                                          staging.ESC_Case_Severity__c='1 - High';
                                                      }
                                                      else{
                                                          staging.ESC_Case_Severity__c=cs.ESC_Case__r.ESC_Severity__c;
                                                      }
                                                      staging.ESC_Case_Number__c=cs.ESC_Case__r.CaseNumber;
                                                      staging.ESC_Case_Created_Date__c=cs.ESC_Case__r.CreatedDate;
                                                      staging.ESC_Case_Owner__c=cs.ESC_Case__r.Owner.name;
                                                      if((cs.ESC_Case__r.Description==null || cs.ESC_Case__r.Description=='')&& (cs.ESC_Case__r.ESC_VSTS_Description__c ==null || cs.ESC_Case__r.ESC_VSTS_Description__c =='')){
                                                          staging.ESC_Case_Description__c='Empty';
                                                      }
                                                      else if((cs.ESC_Case__r.Description==null || cs.ESC_Case__r.Description=='') && (cs.ESC_Case__r.ESC_VSTS_Description__c !=null && cs.ESC_Case__r.ESC_VSTS_Description__c !='')){
                                                          staging.ESC_Case_Description__c=cs.ESC_Case__r.ESC_VSTS_Description__c;
                                                      }
                                                      else if((cs.ESC_Case__r.Description!=null && cs.ESC_Case__r.Description !='') && (cs.ESC_Case__r.ESC_VSTS_Description__c ==null || cs.ESC_Case__r.ESC_VSTS_Description__c =='')){
                                                          staging.ESC_Case_Description__c=cs.ESC_Case__r.Description;
                                                      }
                                                      else{
                                                          staging.ESC_Case_Description__c=cs.ESC_Case__r.Description + '\n' + cs.ESC_Case__r.ESC_VSTS_Description__c;
                                                      }
                                                      if(cs.ESC_Case__r.Priority==null || cs.ESC_Case__r.Priority==''){
                                                          staging.ESC_Case_Priority__c='3 - Low';
                                                      }
                                                      else{
                                                          staging.ESC_Case_Priority__c=cs.ESC_Case__r.Priority;
                                                      }
                                                      staging.ESC_Referral_Id__c=cs.Id;
                                                      staging.ESC_Case_Id__c=cs.ESC_Case__c;
                                                      //code block start for DSS-5235
                                                      if(cs.ESC_Case__r.ESC_Diagnosis_Summary__c==null || cs.ESC_Case__r.ESC_Diagnosis_Summary__c==''){
                                                          staging.ESC_Case_Diagnosis__c='Empty';
                                                      }
                                                      else if(cs.ESC_Case__r.ESC_Diagnosis_Summary__c == 'Assistive Technology'){
                                                      staging.ESC_Case_Diagnosis__c='1';
                                                      }
                                                      else{
                                                      staging.ESC_Case_Diagnosis__c='2';
                                                      }
                                                      if(cs.ESC_Case__r.Subject==null || cs.ESC_Case__r.Subject==''){
                                                         staging.ESC_Case_Subject__c='Empty';
                                                      }
                                                      else if((cs.ESC_Case__r.Subject).length() > Integer.ValueOf(Label.VSTS_Subject_length)) {
                                                         staging.ESC_Case_Subject__c=(cs.ESC_Case__r.Subject).left(Integer.ValueOf(Label.VSTS_Subject_length));
                                                      }
                                                      else{
                                                         staging.ESC_Case_Subject__c=cs.ESC_Case__r.Subject;
                                                      }
                                                      if(prodList.contains(cs.ESC_Case__r.Product__c)){
                                                          ESC_VSTS_Product_List__c myCS1 = ESC_VSTS_Product_List__c.getValues(cs.ESC_Case__r.Product__c);
                                                          staging.ESC_Case_Product__c = myCS1.Product_Code__c;
                                                      //staging.ESC_Case_Product__c=prodListmap.get(cs.ESC_Case__r.Product__c);
                                                      }
                                                      //code block end for DSS-5235
                                                      staging.ESC_Staging_Status__c='Pending';
                                                      staging.ESC_IsAllowRepDB__c=cs.ESC_Case__r.ESC_IsAllowRepDB__c;
                                                      
                                                      if(specialInstructionMap.size()>0){
                                                      staging.ESC_Customer_Category__c=specialInstructionMap.get(cs.ESC_Case__c);
                                                      }
                                                      if(cs.ESC_Case__r.GGO_Product_Complement_2__c==null || cs.ESC_Case__r.GGO_Product_Complement_2__c==''){
                                                          staging.ESC_Case_Product_Complement__c='Empty';
                                                      }
                                                      else{
                                                          staging.ESC_Case_Product_Complement__c=cs.ESC_Case__r.GGO_Product_Complement_2__c;
                                                      }
                                                      staging.ESC_Case_Product_Version__c=cs.ESC_Case__r.GGO_Product_Version__c;
                                                      if(cs.ESC_Case__r.Account.RecordType.Name=='Customer'){
                                                          staging.ESC_Is_Customer__c=true;
                                                      }
                                                      else{
                                                          staging.ESC_Is_Customer__c=false;
                                                      }
                                                      staging.ESC_SAP_TenancyName__c='Null';
                                                      if(staging.ESC_Case_Product__c != stagingOld.ESC_Case_Product__c ||  staging.ESC_Case_Product_Complement__c != stagingOld.ESC_Case_Product_Complement__c){
                                                        staging.ESC_RequestType__c='create';
                                                        system.debug('Create fired');
                                                      }
                                                      else{
                                                        staging.ESC_RequestType__c='reopen';
                                                        system.debug('Reopen fired');
                                                      }
                                                      stagingList.add(staging);
                                                  }
                                              }
             if(Schema.sObjectType.ESC_VSTS_Staging__c.isAccessible() || Schema.sObjectType.ESC_VSTS_Staging__c.isCreateable()){
                insert stagingList;
             }
        }
        catch(Exception e){
            System.debug(e);
        }
    }
    
}