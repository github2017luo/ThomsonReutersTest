/**
 * @description Utility for 'APTS_OnlineContactsController'
 */
public with sharing class APTS_OnlineContactsController_Utility {
    // Method to create a attachment with all Online Contacts
            /**
             * @description onlineContactsExcel
             * @param proposalId 
             * @param qName 
             * 
             */
            @Future(callout=true)
            public static void onlineContactsExcel(string proposalId, string qName) {
                PageReference csvData = Page.OnlineContactsExport;        
                csvData.getParameters().put('id',proposalId);           
                ContentVersion conVersion = new ContentVersion();
                //conVersion.FileType = 'application/pdf';
                List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
                if( Schema.sObjectType.ContentDocumentLink.isAccessible() && Schema.sObjectType.ContentDocumentLink.isQueryable()){
                contentDocumentLinkList = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=: proposalId Limit 1];
                }
                List<ContentVersion> contVersionList=new List<ContentVersion>();       
                if( Schema.sObjectType.ContentVersion.isAccessible() && Schema.sObjectType.ContentVersion.isQueryable() && contentDocumentLinkList.isEmpty())
                {
            
                    if( Schema.sObjectType.ContentVersion.isAccessible() 
                            && Schema.sObjectType.ContentVersion.isCreateable() ){
                        
                        //LatAm_Profile_List__c test2 = new LatAm_Profile_List__c(Name='LatAmProfileList',Profile_List__c='LatAm User');
                        //insert test2;
                                
                        conVersion = returnConVersion(conVersion, csvData);
                        system.debug(LoggingLevel.WARN, 'attach...'+conVersion);
                        conVersion.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                        conVersion.Title = qName +' '+System.Label.OCFileName ;
                        conVersion.PathOnClient = qName +' '+System.Label.OCFileName + '.pdf';
                        insert conVersion; 
                                
                        contVersionList = [SELECT Id, ContentDocumentId, VersionData FROM ContentVersion WHERE id=: conVersion.id Limit 1];
                        insertConDocLink(contVersionList,  proposalId);
                        
                    }  
                    }else {
                        
                        if(!contentDocumentLinkList.isEmpty()){
                            ContentVersion cv=new ContentVersion(); 
                            contVersionList.clear();
                       
                            cv.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                            cv.Title = qName +' '+System.Label.OCFileName ;
                            cv.PathOnClient = qName +' '+System.Label.OCFileName + '.pdf';
                            cv.ContentDocumentId=contentDocumentLinkList[0].ContentDocumentId;
                            insertUpdatedContVersionList(contVersionList,cv, csvData);
                    }
                    }
               
                
            }
    
            @testVisible
            private static ContentVersion returnConVersion(ContentVersion conVersion, PageReference csvData){
                if(!Test.isRunningTest()){ 
                    conVersion.VersionData = csvData.getContent();}
                else{
                    conVersion.VersionData = Blob.ValueOf('123');}
                return conVersion;
            }
            
            @testVisible
            private static void insertConDocLink(List<ContentVersion> contVersionList, string proposalId){
            
                if(!contVersionList.isEmpty()){
                    System.debug(LoggingLevel.WARN, 'ContentDocumentId'+contVersionList[0].ContentDocumentId);
                    
                    String conDocId=contVersionList[0].ContentDocumentId;
                    ContentDocumentLink conDocLink = New ContentDocumentLink();
                    conDocLink.LinkedEntityId = proposalId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                    conDocLink.ContentDocumentId = conDocId;  //ContentDocumentId Id from ContentVersion
                    conDocLink.shareType = 'V';
                    System.debug(LoggingLevel.WARN, 'conDocLink'+conDocLink);
                    if(Schema.sObjectType.ContentDocumentLink.isAccessible() 
                    && Schema.sObjectType.ContentDocumentLink.isCreateable()){
                    insert conDocLink;
                    }
                }
            }
            
            @testVisible
            private static void insertUpdatedContVersionList(List<ContentVersion> contVersionList, ContentVersion cv, PageReference csvData){
                
                if(!Test.isRunningTest()){ 
                    cv.VersionData = csvData.getContent();}
                    else{
                    cv.VersionData = Blob.ValueOf('123');}
                    contVersionList.add(cv);
            
                if(Schema.sObjectType.ContentVersion.isAccessible() 
                    && Schema.sObjectType.ContentVersion.isCreateable()){
                    insert contVersionList;
                }
            }
    }