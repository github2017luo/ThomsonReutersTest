/*
======================================================================================================================
CLASS NAME:  XREFFamilyHelper_class
======================================================================================================================
PURPOSE:  Re parenting of Notes & Attachments across all Objects(CRM-13837)

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                  DESC
20/3/2018       Seema Nagdev         Created.   
======================================================================================================================
*/
public class XREFFamilyHelper_class{
    
    /** Method to insert notes and attachments**/
    public static void CreateNotesandAttachments(List<sobject> sobjectList){

        String OldId = 'Old_Id__c';
        String NewId = 'New_Id__c';
        String isProcessed = 'Is_Processed__c';
        String ProcessedDateTime = 'Processed_Date_Time__c';
        String ObjectName= '';
        
        Set<ID> newrecId = new Set<ID>();
        Set<ID> parentIDs = new set<Id>();
        set<Id> idswithnoNotes = new set<Id>();
        Set<Id> idswithNotes = new Set<Id>();
        Set<Id> idswithAttachments =new Set<Id>();
        set<Id> idswithnoAttachments = new set<Id>();
        set<Id> idswithNonotesattch = new set<Id>();
        
        Map<id,id> oldnewIdmap = new Map<id,id>();
        Map<sobject,id> newIdsobjmap = new Map<sobject,id>();
        Map<id,sobject> oldIdsobjmap = new Map<id,sobject>();
        Map<id,sobject> Idsobjmap = new Map<id,sobject>();
        Set<id> sobjsettobeUpdated = new Set<id>();
        List<sobject> sobjtobeUpdated = new List<sobject>();
        List<LCRM_Exception_Log__c> exceptionList = new List<LCRM_Exception_Log__c>();
            
        //User ouser = new User();
        if(!sobjectList.isEmpty()){
            ObjectName= sobjectList[0].getSObjectType().getDescribe().getLabel();
        }
        System.debug('ObjectName'+ObjectName);
        
        try{
            System.debug('sobjectList Size***'+sobjectList.size());
            if(!sobjectList.isEmpty()){
             
                for(Sobject sobj :sobjectList){
                    
                    newIdsobjmap.put(sobj,(String) sobj.get(NewId));
                    oldnewIdmap.put((String) sobj.get(OldId),(String) sobj.get(NewId));
                    oldIdsobjmap.put((String) sobj.get(OldId),sobj);
                    parentIDs.add((String)sobj.get(OldId));
                    Idsobjmap.put(sobj.id,sobj);
                 }
                System.debug('parentIDs:-'+parentIDs);
                //String informaticaUser = '%'+label.XREFUserName+'%';
                //ouser = [SELECT CreatedDate,Id,IsActive,Name FROM User WHERE Name LIKE :informaticaUser AND IsActive = true ORDER BY CreatedDate ASC NULLS FIRST LIMIT 1];
                //System.debug('ouser:'+ouser);
                
                //Adding Notes under newid
                List<Note> notesListToBeInserted = new List<Note>();
                for(Note oNote :[SELECT Id, ParentId, Title, Body, OwnerId,Owner.IsActive, IsPrivate FROM Note where ParentId IN : oldnewIdmap.keyset()]){
                    idswithNotes.add(oNote.ParentId);
                    System.debug('idswithNotes:-'+idswithNotes);
                    //Create new Notes
                    if(oldnewIdmap.get(oNote.ParentId) !=null){
                            Note tempNote = new Note();
                            tempNote.Body= oNote.Body;
                            tempNote.IsPrivate= oNote.IsPrivate;
                            tempNote.Title = oNote.Title;
                            tempNote.parentid = oldnewIdmap.get(oNote.ParentId);
                            System.debug('oNote.Owner.IsActive:-'+oNote.Owner.IsActive+' oNote.Owner.NAme'+oNote.Ownerid);
                            /**if(oNote.Owner.IsActive){
                                tempNote.OwnerId= oNote.OwnerId;
                            } else if(!String.isBlank(ouser.id)&&(!oNote.Owner.IsActive)){
                                tempNote.OwnerId = ouser.id;
                            }**/
                             tempNote.OwnerId= oNote.OwnerId;
                            notesListToBeInserted.add(tempNote);
                        }
                    }
                
                if(!notesListToBeInserted.isEmpty()){
                    Database.SaveResult[] srNotesList =  Database.insert(notesListToBeInserted,false);
                    System.debug('srNotesList-->'+srNotesList);
                    List<Id> successNoteList = new List<Id>();
                    //getting the processed XREF records
                    if(!srNotesList.isEmpty()){
                        for(integer i=0;i<srNotesList.size();i++){
                            if(srNotesList.get(i).isSuccess()){
                                System.debug(srNotesList.get(i).getId());
                                successNoteList.add(srNotesList.get(i).getId());
                            } else if(!srNotesList.get(i).isSuccess()){
                                System.debug('srNotesList.get(i).getErrors().get(0):'+srNotesList.get(i).getErrors().get(0));
                                Database.Error err = srNotesList.get(i).getErrors().get(0);
                                String strException = err.getMessage();
                                String strStackTrace = String.valueof(err.getFields());
                                exceptionList.add(createExceptionLog(strException,strStackTrace,ObjectName));
                            }
                        } 
                    }
                    if(!successNoteList.isEmpty()){
                        for( Note oNote: [Select ParentId from Note where id = :successNoteList]){
                            newrecId.add(oNote.ParentId);
                        }
                    }
                    System.debug('newrecId_notes'+newrecId.size());
                }
                
                //Adding Attachments under newid
                List<Attachment> attachmentsToBeInserted = new List<Attachment>();
                for(Attachment oAttachment :[SELECT ParentId, Id, Name, IsPrivate, ContentType, BodyLength, Body, Description, OwnerId,Owner.IsActive FROM Attachment where ParentId IN : oldnewIdmap.keyset()]){
                    idswithAttachments.add(oAttachment.ParentId);
                    System.debug('idswithAttachments:-'+idswithAttachments);
                    if(oldnewIdmap.get(oAttachment.ParentId) !=null){
                        Attachment tempAttachment = new Attachment();
                        tempAttachment.Body=oAttachment.Body;
                        tempAttachment.ContentType=oAttachment.ContentType;
                        tempAttachment.Description=oAttachment.Description;
                        tempAttachment.IsPrivate=oAttachment.IsPrivate;
                        tempAttachment.Name=oAttachment.Name;
                        tempAttachment.parentid = oldnewIdmap.get(oAttachment.ParentId);
                        System.debug('oAttachment.Owner.IsActive:-'+oAttachment.Owner.IsActive+' oAttachment.Owner.Name:-'+oAttachment.Ownerid);
                        /**if(oAttachment.Owner.IsActive){
                            tempAttachment.OwnerId=oAttachment.OwnerId;
                        }else if(!String.isBlank(ouser.id)&& (!oAttachment.Owner.IsActive)){
                            tempAttachment.OwnerId = ouser.id;
                        }**/
                        tempAttachment.OwnerId=oAttachment.OwnerId;
                        attachmentsToBeInserted.add(tempAttachment);
                    }
                }
                System.debug('attachmentsToBeInserted.size'+attachmentsToBeInserted.size());
                if(!attachmentsToBeInserted.isEmpty()){
                    Database.SaveResult[] srAttachmentList =  Database.insert(attachmentsToBeInserted,false);
                    System.debug('srAttachmentListErr-->'+srAttachmentList);
                     List<Id> successAttachList = new List<Id>();
                    //getting the processed XREF records
                    if(!srAttachmentList.isEmpty()){
                        for(integer i=0;i<srAttachmentList.size();i++){
                            if(srAttachmentList.get(i).isSuccess()){
                                System.debug(srAttachmentList.get(i).getId());
                                successAttachList.add(srAttachmentList.get(i).getId());
                            } else if(!srAttachmentList.get(i).isSuccess()){
                                Database.Error err = srAttachmentList.get(i).getErrors().get(0);
                                String strException = err.getMessage();
                                String strStackTrace = String.valueof(err.getFields());
                                exceptionList.add(createExceptionLog(strException,strStackTrace,ObjectName));
                            }
                        } 
                    }
                    if(!successAttachList.isEmpty()){
                         for( Attachment oAttachment: [Select ParentId from Attachment where id = :successAttachList]){
                            newrecId.add(oAttachment.ParentId);
                        }
                    }
                    System.debug('newrecId_attachment'+newrecId.size());
                }
                System.debug('newrecId'+newrecId);
                /**if(!newrecId.isEmpty()){
                    for(Sobject sobj : newIdsobjmap.keyset()){
                        System.debug('id:-'+(String)sobj.get(NewId));
                        String oldaccid=(String)sobj.get(OldId);
                        if(newrecId.contains((String)sobj.get(NewId)))
                            if(String.isNotBlank(oldaccid)){
                                sobjsettobeUpdated.add(sObj.id);
                            }
                                
                        }**/
                    
                    /**for(Id oId : newrecId){
                         if(newIdsobjmap.containsKey(oId)){
                            Sobject sObj =  newIdsobjmap.get(oId);
                             sobjtobeUpdated.add(sObj);
                         }
                     }**/
                 
                if(!newrecId.isEmpty()){
                    for(Sobject s : sobjectList){
                        if(newrecId.contains((String)s.get(NewId))){
                            sobjsettobeUpdated.add(s.id);
                        }
                    }
                }
                System.debug('sobjsettobeUpdated:-'+sobjsettobeUpdated);
                if(!parentIDs.isEmpty()){
                    for(Id ids:parentIDs ){
                         //Getting Ids with no notes
                        if(!idswithNotes.contains(ids)){
                            idswithnoNotes.add(ids);
                        }   
                        System.debug('idswithnoNotes***'+idswithnoNotes);
                        System.debug('idswithnoNotes size()***'+idswithnoNotes.size());
                         //Getting Ids with no attachments
                         if(!idswithAttachments.contains(ids)){
                            idswithnoAttachments.add(ids);
                        }
                        System.debug('idswithnoAttachments***'+idswithnoAttachments);
                        System.debug('idswithnoAttachments size()***'+idswithnoAttachments.size());
                        // Getting the ids with no notes adn attachments
                        if(idswithnoNotes.contains(Ids)&& idswithnoAttachments.contains(ids)){
                            idswithNonotesattch.add(ids);
                        }
                    }
                }
                if(!idswithNonotesattch.isEmpty()){
                    for(Id oId : idswithNonotesattch){
                        if(oldIdsobjmap.containsKey(oId)){
                            Sobject sObj =  oldIdsobjmap.get(oId);
                             sobjsettobeUpdated.add(sObj.id);
                        }
                    }
                }
                
                
                 //Updating the XREF Object
                 if(!sobjsettobeUpdated.isEmpty()){
                     System.debug('Update begin');
                     for(Id sobjid : sobjsettobeUpdated){
                         sobjtobeUpdated.add(Idsobjmap.get(sobjid));
                     }
                     if(!sobjtobeUpdated.isEmpty()){
                         for(Sobject sobj:sobjtobeUpdated){
                             String oldidval=(String)sobj.get(OldId);
                             String newidval=(String)sobj.get(NewId);
                             if(String.isNotBlank(oldidval)&&String.isNotBlank(newidval)){
                                 sobj.put(isProcessed, true);
                                 sobj.put(ProcessedDateTime,system.now());
                             }
                         }
                         update sobjtobeUpdated;
                     }

                }
            }
        } catch(Exception Excep){
            System.debug('Error:'+Excep);
            String strException = Excep.getMessage();
            String strStackTrace = Excep.getStackTraceString();
            exceptionList.add(createExceptionLog( strException,strStackTrace,ObjectName));
        } 
     
     System.debug('exceptionList'+exceptionList.size());
     if(!exceptionList.isEmpty()){
         insert exceptionList;
        }   
        
    }
    //End Method
   
   /** Method to log Exception**/
    public static LCRM_Exception_Log__c createExceptionLog( String Excep,String strStackTrace,String ObjectName ){
        System.debug('**createExceptionLog**');
        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
        excepObj = new LCRM_Exception_Log__c();
        excepObj.LCRM_Exception_Message__c = Excep;
        excepObj.LCRM_Exception_Trace__c = ObjectName+' '+strStackTrace;
        excepObj.LCRM_Exception_Type__c = 'Error found in '+ObjectName+' batch';          
        excepObj.LCRM_User_ID__c = userinfo.getUserId();
        return excepObj;
        
    }
    //Method End
 }