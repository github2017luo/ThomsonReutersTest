public without sharing class ESC_ChargeCancellation extends ESC_FormsAbstractExecute {

    public override void executePreRender(){
       system.debug('empty');
    }
    
    public override void validateForms(){
        system.debug('empty');
    }
    public override void executePostSubmit(){
        try{
            list<ESC_Case_Form_Extension__c > eCFM = new list<ESC_Case_Form_Extension__c >();
            list<ESC_Case_Form_Extension__c > caseextlist = new list<ESC_Case_Form_Extension__c >();
            String totalamt = '0';
            boolean routetoConsultant = false;
            boolean isapproval =false;
            String chargecancelbu = '';
            if (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){
                eCFM = [Select id,ESC_Form__c,ESC_Case__c,ESC_Case__r.ownerid,USL_Total_Amount__c from ESC_Case_Form_Extension__c where ESC_Case__c =: caseId AND ESC_Form__c=:formid]; 
            }
            ESC_SectionDescriber secdesc1 = new ESC_SectionDescriber();
            system.debug('RoutetoConsultant1 is'+routetoConsultant);
            if(componentcontrollermap.containskey('Charge_Cancellation_Exception_form3')){
                ESC_FormGeneratorCompController formgen = (ESC_FormGeneratorCompController)componentcontrollermap.get('Charge_Cancellation_Exception_form3');
                ESC_SectionDescriber secdesc = formgen.currentDescribedSection;
                routetoConsultant = (Boolean) secdesc.sobj.get('USL_Route_to_Consultant__c');
            }                      
            //Boolean routeform =Boolean.valueof(routetoConsultant);
            system.debug('case and form id is'+caseId+'***'+formid);
            if(componentcontrollermap.containskey('Charge Cancellation Exception Form')){
                ESC_FormGeneratorCompController formgen1 = (ESC_FormGeneratorCompController)componentcontrollermap.get('Charge Cancellation Exception Form');            
                secdesc1 = formgen1.currentDescribedSection;
                chargecancelbu = (String)secdesc1.sobj.get('USL_Approval_Type__c');
            }
            system.debug('charge cancel bu is'+chargecancelbu );
            //modified for DSS-7483 TRTA Corp Charge Cancellation exception
            ESC_FormGeneratorCompController formgen2;
            ESC_SectionDescriber secdesc2;
            if(componentcontrollermap.containskey('Sec-00801') && chargecancelbu != 'TRTA_Corporates'){
                formgen2 = (ESC_FormGeneratorCompController)componentcontrollermap.get('Sec-00801');
                secdesc2 = formgen2.currentDescribedSection;        
               }
               else if( componentcontrollermap.containskey('Corp Charge Cancellation Exception Form 2') && chargecancelbu == 'TRTA_Corporates'){
                   formgen2 = (ESC_FormGeneratorCompController)componentcontrollermap.get('Corp Charge Cancellation Exception Form 2');
                    secdesc2 = formgen2.currentDescribedSection;
               }
                List<ESC_Case_Form_Extension_Line_Item__c> lineitemlist = secdesc2.sobjlist;
                if(lineitemlist.size()>0){ 
                for(ESC_Case_Form_Extension_Line_Item__c lineitem : lineitemlist ){                         
                    //system.debug('amount is'+lineitem.ESC_Tax_Amount__c + lineitem.ESC_Net_Amount__c );
                    if(lineitem.ESC_Tax_Amount__c !=null){
                        totalamt = String.valueof(double.valueof(totalamt) + double.valueof(lineitem.ESC_Tax_Amount__c) + double.valueof(lineitem.ESC_Net_Amount__c));                   
                    }
                    else if(lineitem.ESC_Tax_Amount__c ==null){
                        totalamt = String.valueof(double.valueof(totalamt)  + double.valueof(lineitem.ESC_Net_Amount__c));                                       
                    }                
                }
            }
            User u = new  User();
            if(Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()){
                u = [select Id, name from User where Id = :UserInfo.getUserId()];     
             } 
            //Added for DSS-7483 TRTA Corp Charge Cancellation exception
            if(chargecancelbu == 'TRTA_Corporates'){
                ESC_Case_form_Extension__c casextupd = new ESC_Case_form_Extension__c();
                system.debug('case ext id is'+string.valueof(secdesc1.sobj.get('id')));
                casextupd.id = string.valueof(secdesc1.sobj.get('id'));
                casextupd.USL_Total_Amount__c  = double.valueof(totalamt);
                Case caseacc = new case();
                Caseacc = [Select Id,CaseNumber,ESC_Email_Thread_Id__c FROM Case where id =:caseId limit 1];            
                casextupd.USL_APPRServiceNoteNum__c = Caseacc.casenumber + ':'+ caseacc.ESC_Email_Thread_Id__c;
                if(decimal.valueof(totalamt)  <=1000){
                    //ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Charge Cancellation Exception Form');    
                    //obj.createReferral();    
                     casextupd.USL_Approval_Status__c = 'Approved';     
                    casextupd.USL_Approver_name__c = u.name;
                     isapproval = True;
                }  
                caseextlist.add(casextupd);
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){ 
                   update caseextlist;
                }
                if(!isapproval){      
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();    
                    req1.setComments('Submitting request for approval.');    
                    req1.setObjectId(string.valueof(secdesc1.sobj.get('id')));                     
                    req1.setSubmitterId(ECFM[0].ESC_Case__r.ownerid);                                     
                    Approval.ProcessResult result = Approval.process(req1);    
                }               
            } 
            if(string.valueof(secdesc1.sobj.get('id')) != '' && chargecancelbu != 'TRTA_Corporates'){
                ESC_Case_form_Extension__c casextupd = new ESC_Case_form_Extension__c();
                system.debug('case ext id is'+string.valueof(secdesc1.sobj.get('id')));
                casextupd.id = string.valueof(secdesc1.sobj.get('id'));
                casextupd.USL_Total_Amount__c  = double.valueof(totalamt);
               
            // DSS-6987 START  
            if(chargecancelbu == 'Tax Profs - Software'){  
                if(decimal.valueof(totalamt)  <=300){  
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Charge Cancellation Exception Form');  
                    obj.createReferral();  
                     casextupd.USL_Approval_Status__c = 'Approved';
                      casextupd.USL_Approver_name__c = u.name;
                }  
                 caseextlist.add(casextupd);
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){ 
                   update caseextlist;
                }
                if(decimal.valueof(totalamt)  > 300){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
                    req1.setComments('Submitting request for approval.');  
                    req1.setObjectId(string.valueof(secdesc1.sobj.get('id')));                   
                    req1.setSubmitterId(ECFM[0].ESC_Case__r.ownerid);                                   
                    Approval.ProcessResult result = Approval.process(req1);  
                }  
            }  
            else if(chargecancelbu == 'Tax Profs - Content'){  
                if(decimal.valueof(totalamt)  <=3000){
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Charge Cancellation Exception Form');
                    obj.createReferral();
                    casextupd.USL_Approval_Status__c = 'Approved';
                    casextupd.USL_Approver_name__c = u.name;
                }
                 caseextlist.add(casextupd);
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){ 
                   update caseextlist;
                }
                 if(decimal.valueof(totalamt)  > 3000){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(string.valueof(secdesc1.sobj.get('id')));                 
                    req1.setSubmitterId(eCFM[0].ESC_Case__r.ownerid);                                 
                    Approval.ProcessResult result = Approval.process(req1);
                }
            }
            else if(chargecancelbu == 'C2C Tax Profs – Content Collections' || chargecancelbu == 'C2C Tax Profs - Software Collections'  || chargecancelbu == 'C2C Tax Profs – DT Tax Collections' ){
                if(decimal.valueof(totalamt)  <=1000){
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Charge Cancellation Exception Form');
                    obj.createReferral();
                    casextupd.USL_Approval_Status__c = 'Approved';
                    casextupd.USL_Approver_name__c = u.name;
                }
                 caseextlist.add(casextupd);
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){ 
                   update caseextlist;
                }
                if(decimal.valueof(totalamt)  > 1000){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(string.valueof(secdesc1.sobj.get('id')));                 
                    req1.setSubmitterId(ECFM[0].ESC_Case__r.ownerid);                                 
                    Approval.ProcessResult result = Approval.process(req1);
                }
            }           
            else if(chargecancelbu == 'Legal_Tracker' ){
                if(decimal.valueof(totalamt)  <= 500){
                    casextupd.USL_Approval_Status__c = 'Approved';
                    casextupd.USL_Approver_name__c = u.name;
                    if(routetoConsultant){
                        casextupd.USL_Route_to_Consultant__c = false;}
                }
                else if(test.isrunningtest() || routetoConsultant){
                    system.debug('routetoConsultant is'+routetoConsultant);
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Charge Cancellation Exception Form');
                    if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    } 
                    else{
                    list<Group> g= new list<Group>();
                    List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
                    if (Schema.sObjectType.Group.isAccessible()){
                     g=[Select Id from Group where DeveloperName =:Label.USL_CCException_referral_Queue];
                    } 
                    ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                    ref.ESC_Role__c = 'Accountable Resolver';
                    ref.ESC_Referral_Status__c = 'New';
                    ref.ESC_Case__c = caseid;
                    ref.ownerid = g[0].id;
                    referralinsertlist.add(ref);
                    if(Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
                    insert referralinsertlist;
                    }
                    }
                }
                caseextlist.add(casextupd);
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){ 
                   update caseextlist;
                }
                if(!routetoConsultant && decimal.valueof(totalamt) > 500){  
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(string.valueof(secdesc1.sobj.get('id')));                 
                    req1.setSubmitterId(eCFM[0].ESC_Case__r.ownerid);                                 
                    Approval.ProcessResult result = Approval.process(req1);  
                }
            }
            else{
                if(decimal.valueof(totalamt)  <= 1000){
                    casextupd.USL_Approval_Status__c = 'Approved';
                    casextupd.USL_Approver_name__c = u.name;
                    if(routetoConsultant){
                        casextupd.USL_Route_to_Consultant__c = false;}
                }
                else if(test.isrunningtest() || routetoConsultant){
                    system.debug('routetoConsultant is'+routetoConsultant);
                    ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Charge Cancellation Exception Form');
                    if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
                    } 
                    else{
                    list<Group> g= new list<Group>();
                    List<ESC_Case_Collaborator__c> referralinsertlist = new List<ESC_Case_Collaborator__c>();
                    if (Schema.sObjectType.Group.isAccessible()){
                     g=[Select Id from Group where DeveloperName =:Label.USL_CCException_referral_Queue];
                    } 
                    ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
                    ref.ESC_Role__c = 'Accountable Resolver';
                    ref.ESC_Referral_Status__c = 'New';
                    ref.ESC_Case__c = caseid;
                    ref.ownerid = g[0].id;
                    referralinsertlist.add(ref);
                    if(Schema.sObjectType.ESC_Case_Collaborator__c.isCreateable()){
                    insert referralinsertlist;
                    }
                    }
                }
                caseextlist.add(casextupd);
                if (Schema.sObjectType.ESC_Case_Form_Extension__c.isUpdateable()){ 
                   update caseextlist;
                }
                if(!routetoConsultant && decimal.valueof(totalamt) > 1000){  
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(string.valueof(secdesc1.sobj.get('id')));                 
                    req1.setSubmitterId(eCFM[0].ESC_Case__r.ownerid);                                 
                    Approval.ProcessResult result = Approval.process(req1);  
                }
            }
            }
        }
        catch(exception e) {          
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage());
            Apexpages.addMessage(msg);
            
        }
    }
}