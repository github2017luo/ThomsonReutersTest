Public without sharing class ESC_CaseFormExtension{    
           
    public static void escFromExtension(list<ESC_Case_Form_Extension__c> newCaseForm){     
        Map<string,string> casid =new Map<string,string>();
        Map<string,String> productvalues =new Map<string,String>();
        list<Case> caseupdate= new list<Case>();                        
        Map<string,String> specialOffer =new Map<string,String>();
        Map<string,String> mediatype =new Map<string,String>();
        Map<string,String> requestType =new Map<string,String>();
        Map<string,String> requestType1 =new Map<string,String>();
        Map<string,String> escRequestType =new Map<string,String>();
                
        for(ESC_Case_Form_Extension__c cft :newCaseForm){  
                            
                 casid.put(cft.ESC_Case__c,cft.ESC_Form__c); 
                 productvalues.put(cft.id,cft.Product__c); 
                 specialOffer.put(cft.id,cft.Online_Special_Offer__c);
                  mediatype.put(cft.id,cft.Media_Type__c);
                  requestType.put(cft.id,cft.Request_Type_Post_Prod_Lapse2__c);
                 requestType1.put(cft.id,cft.Request_Type_Post_Prod_Lapse__c);
                 escRequestType.put(cft.id,cft.ESC_Request_Type_Account_Related__c);
         }                                                
          Map<ID,ESC_Case_Form_Extension__c> cssFromExtMap= new Map<Id, ESC_Case_Form_Extension__c>();
         
         List<ESC_Case_Form_Extension__c> cssFormList =new List<ESC_Case_Form_Extension__c>([select id,Request_Type_Post_Prod_Lapse__c,ESC_Request_Type_Account_Related__c,Request_Type_Post_Prod_Lapse2__c,ESC_Form__c,ESC_Case__c,ESC_Case__r.Form_Name__c,ESC_Case__r.Form_Name_New__c,ESC_Case__r.ESC_Proactive_Type__c,Name,Online_Special_Offer__c,Media_Type__c, ESC_Form__r.Name from ESC_Case_Form_Extension__c where id IN:newCaseForm]);   
         
         system.debug('CSSFromExtlist17' +cssFormList); 
         for(ESC_Case_Form_Extension__c listCssform :cssFormList ){
             cssFromExtMap.put(listCssform.id,listCssform);
             
         
         }
         
         for(ESC_Case_Form_Extension__c cid:newCaseForm){ 
         
              case c =new case();                          
              c.id=cid.ESC_Case__c;
                //below code block added for DSS-8493/DSS-9412 to supress survey for Write off   
               if((cssFromExtMap.get(cid.id).ESC_Form__r.Name == 'Write Off Form' || cssFromExtMap.get(cid.id).ESC_Form__r.Name == 'Write Off Exception Form') && cssFromExtMap.get(cid.id).ESC_Case__r.ESC_Proactive_Type__c != 'COVID-19'){
               c.ESC_Proactive_Type__c = 'Internal Origin';  
              }  
              system.debug('CSSFrom');
              if(specialOffer.containskey(cid.id) && productvalues.containskey(cid.id) && mediatype.containsKey(cid.id) && productvalues.get(cid.id)=='Special Offer'  && specialOffer.get(cid.id) == 'YES'  && mediatype.get(cid.id)=='Online'){               
                  if(cssFromExtMap != null && cssFromExtMap.containskey(cid.id)){
                      if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c != null){         
                        c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c + '; '+ cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'Special Offers';
                    }
                    else{
                      c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'Special Offers';
                    }
                    if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c != null){         
                        c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c + '; '+ cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'Special Offers';
                    }
                    else{
                      c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'Special Offers';
                    }
                    
                    
                  }
                  system.debug('CSSFromExtlist18');
              }
              else if(specialOffer.containskey(cid.id) && productvalues.containskey(cid.id) && mediatype.containsKey(cid.id) && productvalues.get(cid.id)!='Special Offer'  && specialOffer.get(cid.id) == 'NO'  && mediatype.get(cid.id)=='Online'){
             if(cssFromExtMap != null && cssFromExtMap.containskey(cid.id)){
                      if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c != null){
                         c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c + '; '+ cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'PRO';
                      }
                      else{
                      c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'PRO';
                      } 
                      if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c != null){
                         c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c + '; '+ cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'PRO';
                      }
                      else{
                      c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Form__r.Name + ' ' + 'PRO';
                    }                     
                  }
                  system.debug('CSSFrom1111111111111111111333');
              }
             else if(requestType.containsKey(cid.id) && requestType.get(cid.id)!=null){
                      if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c != null){
                          c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c + '; '+ cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse2__c;
                      } 
                      else{
                          c.Form_Name__c = cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse2__c;
                      }  
                      if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c != null){
                           c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c + '; '+ cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse2__c;
                      } 
                      else{
                           c.Form_Name_New__c = cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse2__c;
                      }                       
                          
                      system.debug('CSSFromExtlist20' + cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse2__c);
                }                              
            else if(requestType1.containsKey(cid.id) && requestType1.get(cid.id)!=null){
                     if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c != null){
                         c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c + '; '+ cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse__c;
                     }
                     else{
                      c.Form_Name__c = cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse__c;
                      } 
                     if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c != null){
                         c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c + '; '+ cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse__c;
                     }
                     else{
                      c.Form_Name_New__c = cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse__c;
                      } 
                  system.debug('CSSFromExtlist21' + cssFromExtMap.get(cid.id).Request_Type_Post_Prod_Lapse__c);
              }
              else if(escRequestType.containsKey(cid.id) && escRequestType.get(cid.id)!=null){
                       if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c != null){
                         c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c + '; '+ cssFromExtMap.get(cid.id).ESC_Request_Type_Account_Related__c;
                        }
                      else{
                         c.Form_Name__c = cssFromExtMap.get(cid.id).ESC_Request_Type_Account_Related__c;
                        } 
                        if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c != null){
                         c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c + '; '+ cssFromExtMap.get(cid.id).ESC_Request_Type_Account_Related__c;
                        }
                      else{
                         c.Form_Name_New__c = cssFromExtMap.get(cid.id).ESC_Request_Type_Account_Related__c;
                        }                           
                  system.debug('CSSFromExtlist22' + cssFromExtMap.get(cid.id).ESC_Request_Type_Account_Related__c);
              } 
              else { 
                  if(cssFromExtMap != null && cssFromExtMap.containskey(cid.id)){
                       if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c != null){
                          c.Form_Name__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name__c +'; '+cssFromExtMap.get(cid.id).ESC_Form__r.Name;
                        }
                       else{
                         c.Form_Name__c = cssFromExtMap.get(cid.id).ESC_Form__r.Name;
                        } 
                        if(cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c != null){
                          c.Form_Name_New__c=cssFromExtMap.get(cid.id).ESC_Case__r.Form_Name_New__c +'; '+cssFromExtMap.get(cid.id).ESC_Form__r.Name;
                        }
                       else{
                         c.Form_Name_New__c = cssFromExtMap.get(cid.id).ESC_Form__r.Name;
                        }                           
                    }
                   system.debug('CSSFromExtlist23');
                } 


                  
              caseupdate.add(c); 
          }              
          if(!caseupdate.isEmpty() && (Schema.sObjectType.Case.isAccessible() || Schema.sObjectType.Case.isUpdateable())){                          
                update caseupdate;             
          }
          
         
     }  
     public static void validateRequesttype(Map<id,ESC_Case_Form_Extension__c>oldMap,Map<id,ESC_Case_Form_Extension__c>newmap){
         for(id formid : newmap.keyset()){
             if(oldMap.get(formid).Request_Type_Post_Prod_Lapse2__c != null && (oldMap.get(formid).Request_Type_Post_Prod_Lapse2__c != newmap.get(formid).Request_Type_Post_Prod_Lapse2__c)){
                 newmap.get(formid).addError('Request type cannot be changed');
             }
             if(oldMap.get(formid).Request_Type_Post_Prod_Lapse__c!= null && (oldMap.get(formid).Request_Type_Post_Prod_Lapse__c!= newmap.get(formid).Request_Type_Post_Prod_Lapse__c)){
                 newmap.get(formid).addError('Request type cannot be changed');
             }
             if(oldMap.get(formid).ESC_Request_Type_Account_Related__c!= null && (oldMap.get(formid).ESC_Request_Type_Account_Related__c!= newmap.get(formid).ESC_Request_Type_Account_Related__c)){
                 newmap.get(formid).addError('Request type cannot be changed');
             }
         }
     } 
       public static void caseUpdUpdate(list<ESC_Case_Form_Extension__c> newCaseForm, Map<Id,ESC_Case_Form_Extension__c> oldCaseForm){
       MasterCaseTriggerRecursiveCheck.checkRecursiveForforms = false;
       set<String> caseidsapp = new set<string>();
       set<String> caseidsrej = new set<string>();
       for(ESC_Case_Form_Extension__c formext : newCaseForm){
           if(formext.USL_Approval_Status__c != null && formext.USL_Approval_Status__c.equalsignoreCase('Approved') && oldCaseForm.get(formext.id).USL_Approval_Status__c !=formext.USL_Approval_Status__c){
           caseidsapp.add(formext.esc_case__c);  
           }         
       }
       for(ESC_Case_Form_Extension__c formext : newCaseForm){
           if(formext.USL_Approval_Status__c != null && formext.USL_Approval_Status__c.equalsignoreCase('Rejected') && oldCaseForm.get(formext.id).USL_Approval_Status__c !=formext.USL_Approval_Status__c){
           caseidsrej.add(formext.esc_case__c);
       }           
       }
       if(caseidsapp.size() > 0){
       system.debug('updateUPDFlagForReferrals Approved');        
       ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(caseidsapp,'Approved' , 'Approved');
       }
       if(caseidsrej.size() > 0){  
              system.debug('updateUPDFlagForReferrals Rejected');       
       ESC_ReferalTriggerHelperClass.updateUPDFlagForReferrals(caseidsrej,'Rejected' , 'Rejected');
       }
       
       
       
   } 
    public static void chargeCancellationChatter(list<ESC_Case_Form_Extension__c> newCaseForm,Map<Id,ESC_Case_Form_Extension__c> oldMap){
        List<Id> caseidsapp = new List<Id>();
        string formName= [Select Name from GenerateForm__C where ID =: newCaseForm[0].ESC_Form__C LIMIT 1].Name;
        for(ESC_Case_Form_Extension__c cfe: newCaseForm){
            if((label.USL_Form_chatter_post.contains(formName) && cfe.USL_Approval_Status__c!=null &&cfe.USL_Approval_Status__c!=oldMap.get(Cfe.Id).USL_Approval_Status__c) || Test.isRunningTest()){
                caseidsapp.add(cfe.ESC_Case__C);
            }
        }
        if(caseidsapp.size()>0 || Test.isRunningTest()){
        Map<Id,Case> caseMap= new Map<Id,Case>([Select id,OwnerID,CaseNumber from case where id in :caseidsapp]);
       for(ESC_Case_Form_Extension__c formext : newCaseForm){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                 mentionSegmentInput.id = caseMap.get(formext.esc_case__c).OwnerId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                //textSegmentInput.text = ' Charge Cancellation for the Case '+caseMap.get(formext.esc_case__c).CaseNumber+' has  been '+formext.USL_Approval_Status__c+'.';
                 if(formName =='Charge Cancellation'){textSegmentInput.text = ' Charge Cancellation for the Case '+caseMap.get(formext.esc_case__c).CaseNumber+' has  been '+formext.USL_Approval_Status__c+'.';}
                else if(formName=='Charge Cancellation Exception Form'){textSegmentInput.text = ' Charge Cancellation Exception Form for the Case '+caseMap.get(formext.esc_case__c).CaseNumber+' has  been '+formext.USL_Approval_Status__c+'.';}
                else if(formName =='Write Off Form'){textSegmentInput.text = ' Write Off Form for the Case '+caseMap.get(formext.esc_case__c).CaseNumber+' has  been '+formext.USL_Approval_Status__c+'.';}
                else if(formName=='Write Off Exception Form'){textSegmentInput.text = ' Write Off Exception Form for the Case '+caseMap.get(formext.esc_case__c).CaseNumber+' has  been '+formext.USL_Approval_Status__c+'.';}
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = formext.esc_case__c;
                if(!Test.isRunningTest()){
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
                }    
           }
       }
    }
    
    public static void writeOffFormUpdate(Map<Id,ESC_Case_Form_Extension__c> newMap,Map<Id,ESC_Case_Form_Extension__c> oldMap){
        
        Set<Id> caseFormExtSetIds = new Set<Id>();
        if(!newMap.isEmpty() && !oldMap.isEmpty()){
        
            for(Id formExtId:newMap.keyset()){
                if(newMap.get(formExtId)!=null && oldMap.get(formExtId)!=null){
                    system.debug('@@ form name: ' +newMap.get(formExtId).ESC_Form__r.name);
                    if(newMap.get(formExtId).USL_Approval_Type__c!=null && newMap.get(formExtId).USL_Approval_Type__c =='Writeoff' && newMap.get(formExtId).USL_Approval_Status__c!=null && newMap.get(formExtId).USL_Approval_Status__c!=oldMap.get(formExtId).USL_Approval_Status__c && newMap.get(formExtId).USL_Approval_Status__c =='Approved' && newMap.get(formExtId).ESC_Form_BU__c!=null && !newMap.get(formExtId).USL_Is_Processed__c && (newMap.get(formExtId).ESC_Form_BU__c.startsWith('Tax Profs'))){
                        caseFormExtSetIds.add(formExtId);
                    }
                }
            }
            
            system.debug('@@ caseFormExtSetIds : ' + caseFormExtSetIds);
            if(caseFormExtSetIds!=null && caseFormExtSetIds.size() > 0 ){
                //MasterCaseTriggerRecursiveCheck.checkRecursiveForWriteOff =false; 
                updateFormExtSAP(caseFormExtSetIds,False);
            }
        }
        
    }
    
    public static void ccFormUpdate(Map<Id,ESC_Case_Form_Extension__c> newMap,Map<Id,ESC_Case_Form_Extension__c> oldMap){
        List<String> formidlist = new List<String>();
        Set<Id> caseFormExtSetIds = new Set<Id>();
        map<String,String> formnamemap = new map<String,String>();
        if(!newMap.isEmpty() && !oldMap.isEmpty()){
            for(Id formExtId:newMap.keyset()){
                formidlist.add(newMap.get(formExtId).ESC_Form__c);
            }
            for(GenerateForm__c form : [select id,name from GenerateForm__c where id IN:formidlist]){
                formnamemap.put(form.id,form.name);
            }
            for(Id formExtId:newMap.keyset()){
                if(newMap.get(formExtId)!=null && oldMap.get(formExtId)!=null){
                    system.debug('@@ form name: ' +newMap.get(formExtId).ESC_Form__r.name);                 
                    if(newMap.get(formExtId).USL_Approval_Type__c!=null && newMap.get(formExtId).USL_Approval_Type__c.containsIgnoreCase('Tax Profs') && newMap.get(formExtId).USL_Approval_Status__c!=null && newMap.get(formExtId).USL_Approval_Status__c!=oldMap.get(formExtId).USL_Approval_Status__c && newMap.get(formExtId).USL_Approval_Status__c =='Approved' && !newMap.get(formExtId).USL_Is_Processed__c&& formnamemap != null && formnamemap.containsKey(newMap.get(formExtId).esc_form__c) && (formnamemap.get(newMap.get(formExtId).esc_form__c)).equalsignorecase('Charge Cancellation')){
                        caseFormExtSetIds.add(formExtId);
                    }
                    if(newMap.get(formExtId).USL_Approval_Type__c!=null && newMap.get(formExtId).USL_Approval_Type__c.containsIgnoreCase('Tax Profs') && newMap.get(formExtId).USL_Approval_Status__c!=null && newMap.get(formExtId).USL_Approval_Status__c!=oldMap.get(formExtId).USL_Approval_Status__c && newMap.get(formExtId).USL_Approval_Status__c =='Approved' && !newMap.get(formExtId).USL_Is_Processed__c && formnamemap != null && formnamemap.containsKey(newMap.get(formExtId).esc_form__c) && (formnamemap.get(newMap.get(formExtId).esc_form__c)).containsignorecase('Charge Cancellation Exception Form')){
                        ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(newMap.get(formExtId).ESC_Case__c,newMap.get(formExtId).ESC_Form__c,formnamemap.get(newMap.get(formExtId).ESC_Form__c));
                        obj.createReferral();
                        
                    }
                    //added for DSS-7483 
                    if(newMap.get(formExtId).USL_Approval_Type__c!=null && (newMap.get(formExtId).USL_Approval_Type__c.containsIgnoreCase('TRTA') || newMap.get(formExtId).USL_Approval_Type__c.containsIgnoreCase('EBO') ||newMap.get(formExtId).USL_Approval_Type__c =='USL_Customer_Service' ||newMap.get(formExtId).USL_Approval_Type__c =='CDN Customer Service'|| newMap.get(formExtId).USL_Approval_Type__c =='Findlaw_Customer_Service' || newMap.get(formExtId).USL_Approval_Type__c =='USL_Print_Subscription' || newMap.get(formExtId).USL_Approval_Type__c =='Legal_Tracker' || 
                    newMap.get(formExtId).USL_Approval_Type__c =='C2C UKI Collections' || newMap.get(formExtId).USL_Approval_Type__c =='C2C CDN Collections') && newMap.get(formExtId).USL_Approval_Status__c!=null && newMap.get(formExtId).USL_Approval_Status__c!=oldMap.get(formExtId).USL_Approval_Status__c && newMap.get(formExtId).USL_Approval_Status__c =='Approved' && !newMap.get(formExtId).USL_Is_Processed__c && formnamemap != null && formnamemap.containsKey(newMap.get(formExtId).esc_form__c) && (formnamemap.get(newMap.get(formExtId).esc_form__c)).containsignorecase('Charge Cancellation Exception Form')){
                        ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(newMap.get(formExtId).ESC_Case__c,newMap.get(formExtId).ESC_Form__c,formnamemap.get(newMap.get(formExtId).ESC_Form__c));
                        obj.createReferral();
                    }
                }
            }
            
            system.debug('@@ caseFormExtSetIds : ' + caseFormExtSetIds);
            if(caseFormExtSetIds!=null && caseFormExtSetIds.size() > 0 ){
                //MasterCaseTriggerRecursiveCheck.checkRecursiveForWriteOff =false; 
                updateFormExtSAP(caseFormExtSetIds,true);
            }
        }
        
    }
    
    @future(callout=true)
    public static void updateFormExtSAP(Set<Id> caseFormExtList,boolean isCC){
    
        ESC_IntegrationUtil.createDellBoomiRequest(caseFormExtList,isCC);
    }
    


    
}