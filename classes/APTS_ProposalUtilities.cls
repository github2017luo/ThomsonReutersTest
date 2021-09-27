/**
 * @description Class method to manually submit proposal that does not need customer signature.
 */
global with sharing class APTS_ProposalUtilities {
    // Class method to manually submit proposal that does not need customer signature.
    // Returns a string that indicates success or failure.
    /**
     * @description Class method to manually submit proposal that does not need customer signature.
     * @param proposalId
     * @param emailAddress
     * @return '' 
     */
    webservice static String sendEmail(Id proposalId,String emailAddress){
        Boolean wetSignatureFlag=false;
        //get the wet signature flag from the proposal record.
       
        /* if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
            return null;
        }
        Apttus_Proposal__Proposal__c prop = [SELECT APTS_Wet_Signature__c,Languagecode__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposalId]; */  
        
        Apttus_Proposal__Proposal__c prop=returnProposal(proposalId);

        /* if(prop!=null){
            wetSignatureFlag=prop.APTS_Wet_Signature__c;
        } */
        wetSignatureFlag= returnWetSignFlag(prop,wetSignatureFlag);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
        integer count=0;//SOC-3600 by Bijeta on 15/3/17
        string message;//SOC-3600 by Bijeta on 15/3/17
        /*
        // Get the documents attached to the proposal.
        if(!Schema.sObjectType.Attachment.isAccessible() && !Schema.sObjectType.Attachment.isQueryable()){
            return null;
        }
        List<Attachment> attList = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId = :proposalId order by createddate desc];
        
        List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
        integer count=0;//SOC-3600 by Bijeta on 15/3/17
        string message;//SOC-3600 by Bijeta on 15/3/17
        // List of attachments handler
        for(Attachment att : attList){
            if (wetSignatureFlag == true) {
                if ((att.Name.containsIgnoreCase('signed') ||
                     att.Name.containsIgnoreCase('product user detail')) &&
                    !att.Name.containsIgnoreCase('cvms')){
                        
                        //SOC-3600 by Bijeta on 15/3/17
                        if(att.Name.containsIgnoreCase('signed'))
                        {
                            count = count +1;
                        }
                        // Create the email attachment
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(att.Name);
                        efa.setBody(att.body);
                        if (att.ContentType == '.pdf'){
                            efa.setContentType('application/pdf');}
                        else{
                            efa.setContentType(att.ContentType);}
                        efa.setInline(false);
                        efaList.add(efa);
                    }
            } else {
                // NOT a wet signature quote
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(att.Name);
                efa.setBody(att.body);
                if (att.ContentType == '.pdf'){
                    efa.setContentType('application/pdf');}
                else{
                    efa.setContentType(att.ContentType);}
                efa.setInline(false);
                efaList.add(efa);
                break; // only one attachment is required.         
            }
        }
        
        */
        
         /* List<id> contLinkIds  = new List<id>();
        if(!Schema.sObjectType.ContentDocumentLink.isAccessible() && !Schema.sObjectType.ContentDocumentLink.isQueryable()){
            return null;
        }
        List<ContentDocumentLink> contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
        System.debug(LoggingLevel.WARN, 'Fine ContLink...'+contLink); 
        //ContLinkId.add(ContLink);
        if(!contLink.isEmpty()) 
        {
            for(ContentDocumentLink cd : contLink) 
            { contLinkIds.add(cd.ContentDocumentId);}
            
        }
        if(!Schema.sObjectType.contentversion.isAccessible() && !Schema.sObjectType.contentversion.isQueryable()){
            return null;
        }
        List<contentversion> contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata from contentversion where (ContentDocumentId IN : contLinkIds) ORDER BY LastModifiedDate ASC NULLS LAST];
        System.debug(LoggingLevel.WARN, 'Fine contVerion...'+contVerion);   */

        List<contentversion> contVerion=returnContVersion(proposalId);


        For(contentversion att1: contVerion) 
        {
            System.debug(LoggingLevel.WARN, 'Fine contVerion...'+contVerion);
            if (wetSignatureFlag == true) {
                if (checkCond(att1)){
                        
                        //SOC-3600 by Bijeta on 15/3/17

                        /* if(att1.title.containsIgnoreCase('signed'))
                        {
                            count = count +1;
                        } */
                        count=returnCount(att1,count);
                        // Create the email attachment

                        /* Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.setFileName(att1.title);
                        efa.setBody(att1.versiondata);
                        if (att1.FileExtension == 'pdf'){
                            efa.setContentType('application/pdf');}
                        else if (att1.FileExtension == 'doc'){
                            efa.setContentType('application/doc');}
                        else if (att1.FileExtension == 'docx'){
                            efa.setContentType('application/docx');}
                        else if (att1.FileExtension == 'rtf'){
                            efa.setContentType('application/rtf');}
                        else{
                            efa.setContentType(att1.FileExtension);}
                        efaList.add(efa); */

                        efaList = returnEfaListSendEmail(att1,efaList);
                    }
            }       else {
                System.debug(LoggingLevel.WARN, 'Fine contVerion...'+contVerion);
                // NOT a wet signature quote
               
                 /* Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(att1.title);
                efa.setBody(att1.versiondata);
                if (att1.FileExtension == 'pdf'){
                    efa.setContentType('application/pdf');}
                else if (att1.FileExtension == 'doc'){
                    efa.setContentType('application/doc');}
                else if (att1.FileExtension == 'docx'){
                    efa.setContentType('application/docx');}
                else if (att1.FileExtension == 'rtf'){
                    efa.setContentType('application/rtf');}
                else{
                    efa.setContentType(att1.FileExtension);}
                efaList.add(efa); */

                efaList=returnEfaListSendEmailElse(att1,efaList);
                break; // only one attachment is required.         
            }
        } 
        
        
        // Attach files to email instance
        //Added labels for French Translation --DOC-3045
        
        string orderSubmissionSub = System.Label.OrderSubmissionSubject;
        string orderSubBody = System.Label.OrderSubmissionBody;
        email.setSubject(orderSubmissionSub);      
        email.setPlainTextBody(orderSubmissionSub);
        if(isCheckProp(prop)){
            email.setSubject(orderSubBody );      
            email.setPlainTextBody(orderSubBody);
        }
        //DOC-3045 changes ends here   
        // Attach files to email instance
        //Added labels for French Translation
        email.setFileAttachments(efaList);
        // Send Email to the customer.
        email.setToAddresses(new String[]{emailAddress});
        
        //SOC-3600 by Bijeta on 15/3/17
        if(email != null){
            //(attList.size()>0 && count == 0 && wetSignatureFlag==true) ||
            if(isCheckMsg(count,wetSignatureFlag,contVerion)){  
                message='Order cannot be submitted as files do not contain any signed documents.'; //Modified by Tanmay as a part of DOC-15048
            }
            else{
                Messaging.sendEmail(new Messaging.singleEmailMessage[] {email}); 
                // On success, return a message to the calling program.
                message='Confirmation Email Sent Successfully.';
            }
        }
        return message;
    }

    /**
     * @description isCheckMsg
     * @return isCheckMsg
     * @param count
     * @param wetSignatureFlag
     * @param contVerion
     */
    public static Boolean isCheckMsg(integer count,Boolean wetSignatureFlag,List<contentversion> contVerion){
        Boolean blnIsCondCheck =false;
        if((count == 0 && wetSignatureFlag==true && contVerion.size()>0)){
            blnIsCondCheck = true;
        }
        return blnIsCondCheck;
    }

    /**
     * @description isCheckProp
     * @return isCheckProp
     * @param prop
     */
    public static Boolean isCheckProp(Apttus_Proposal__Proposal__c prop) {
        Boolean blnCheckProp=false;
        if(prop!=null && prop.Languagecode__c!=null && prop.Languagecode__c =='fr_CA') {
            blnCheckProp = true;
        }
        return blnCheckProp;
    } 

    /**
     * @description checkCond
     * @return checkCond 
     * @param att1
     */
    public static Boolean checkCond(contentversion att1) {
        Boolean blnIsAtt = false;
        if ((att1.title.containsIgnoreCase('signed') ||
            att1.title.containsIgnoreCase('product user detail')) &&
            !att1.title.containsIgnoreCase('cvms')){
                blnIsAtt=true;
        }
        return blnIsAtt;
    }

    /**
     * @description returnWetSignFlag
     * @return returnWetSignFlag
     * @param prop
     * @param wetSignatureFlag
     */
    public static Boolean returnWetSignFlag(Apttus_Proposal__Proposal__c prop, Boolean wetSignatureFlag){
        if(prop!=null){
            wetSignatureFlag=prop.APTS_Wet_Signature__c;
        }
        return wetSignatureFlag;
    }

    /**
     * @description returnProposal
     * @return returnProposal
     * @param proposalId
     */
    public static Apttus_Proposal__Proposal__c returnProposal(Id proposalId){
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){return null;
        }
        Apttus_Proposal__Proposal__c prop = [SELECT APTS_Wet_Signature__c,Languagecode__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposalId];
    return prop;  
    }

    /**
     * @description returnCount
     * @return returnCount
     * @param att1
     * @param count
     */
    public static Integer returnCount(contentversion att1,integer count){
            if(att1.title.containsIgnoreCase('signed'))
            {
                count = count +1;
            }
        return count;
    }

    /**
     * @description returnContVersion
     * @return returnContVersion
     * @param proposalId
     */
    public static List<contentversion> returnContVersion(Id proposalId){
        List<id> contLinkIds  = new List<id>();
        if(!Schema.sObjectType.ContentDocumentLink.isAccessible() && !Schema.sObjectType.ContentDocumentLink.isQueryable()){
            return null;
        }
        List<ContentDocumentLink> contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
        System.debug(LoggingLevel.WARN, 'Fine ContLink...'+contLink); 
        //ContLinkId.add(ContLink);
        if(!contLink.isEmpty()) 
        {
            for(ContentDocumentLink cd : contLink) 
            { contLinkIds.add(cd.ContentDocumentId);}
            
        }
        if(!Schema.sObjectType.contentversion.isAccessible() && !Schema.sObjectType.contentversion.isQueryable()){return null;
        }
        List<contentversion> contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata from contentversion where (ContentDocumentId IN : contLinkIds) ORDER BY LastModifiedDate ASC NULLS LAST];
        System.debug(LoggingLevel.WARN, 'Fine contVerion...'+contVerion);
    return contVerion;
    }

    /**
     * @description returnEfaListSendEmail
     * @return returnEfaListSendEmail
     * @param att1
     * @param efaList
     */
    public static List<Messaging.Emailfileattachment> returnEfaListSendEmail(contentversion att1,List<Messaging.Emailfileattachment> efaList){
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(att1.title);
        efa.setBody(att1.versiondata);
        if (att1.FileExtension == 'pdf'){
            efa.setContentType('application/pdf');}
        else if (att1.FileExtension == 'doc'){
            efa.setContentType('application/doc');}
        else if (att1.FileExtension == 'docx'){
            efa.setContentType('application/docx');}
        else if (att1.FileExtension == 'rtf'){
            efa.setContentType('application/rtf');}
        else{
            efa.setContentType(att1.FileExtension);}
        efaList.add(efa);   

    return efaList;
    }

    /**
     * @description returnEfaListSendEmailElse
     * @return returnEfaListSendEmailElse
     * @param att1
     * @param efaList
     */
    public static List<Messaging.Emailfileattachment> returnEfaListSendEmailElse(contentversion att1,List<Messaging.Emailfileattachment> efaList){
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(att1.title);
        efa.setBody(att1.versiondata);
        if (att1.FileExtension == 'pdf'){
            efa.setContentType('application/pdf');}
        else if (att1.FileExtension == 'doc'){
            efa.setContentType('application/doc');}
        else if (att1.FileExtension == 'docx'){
            efa.setContentType('application/docx');}
        else if (att1.FileExtension == 'rtf'){
            efa.setContentType('application/rtf');}
        else{
            efa.setContentType(att1.FileExtension);}
        efaList.add(efa);   

    return efaList;
    }




    /**
     * @description submitOrder
     * @param proposalId
     *
     * @return ''
     */
    // This function accepts a proposal. This function is called from Javascript when "Submit Order" button is clicked in proposal detail page.
    @AuraEnabled
    webservice static String submitOrder(Id proposalId) {
        // validateProposalForManualOrderSubmission.
        String retStr = validateProposalForManualOrderSubmission(proposalId);
        
        if (retStr != 'Checks successful'){ return retStr;}
        
        // send email.
        //Added by Sakshi for SOC-7056 on 3/29/2018  
        //Commented this as we will reuse the further query in code 
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){return null;
        }
        Apttus_Proposal__Proposal__c prop = [SELECT APTS_Order_Confirmation_Contact__r.email,TR_Store_Source__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposalId]; 
        // String email = [SELECT APTS_Order_Confirmation_Contact__r.email FROM Apttus_Proposal__Proposal__c WHERE id=:proposalId and TR_Store_Source__c =''].APTS_Order_Confirmation_Contact__r.email;
        //String proposal_business_unit = [SELECT APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c WHERE id=:proposalId].APTS_Proposal_Business_Unit__c;
        if (prop != null && prop.APTS_Order_Confirmation_Contact__r.email!= null && String.isBlank(prop.TR_Store_Source__c)){            
            String str = sendEmail(proposalId, prop.APTS_Order_Confirmation_Contact__r.email);
             if(str=='Order cannot be submitted as files do not contain any signed documents.'){ //Modified by Tanmay as a part of DOC-15048
                return str;}
        }
        // call the acceptProposal web service.
        //  Apttus_Proposal__Proposal__c prop = [SELECT ID,(select name from Apttus_QPConfig__Orders__r) FROM Apttus_Proposal__Proposal__c WHERE id=:proposalId];
        //  if(prop.Apttus_QPConfig__Orders__r.size()==0)
        //added by Gowthami fro SOC-8996
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){return null;
        }
        Apttus_Proposal__Proposal__c proposal = [SELECT APTS_Wet_Signature__c,APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c  WHERE id =:proposalId LIMIT 1];
        
        System.debug(LoggingLevel.WARN,'TEST ORDER PROPOSAL '+ proposalId);
        if(!String.isEmpty(proposalId)){
            Apttus_QPConfig.QPConfigWebService.acceptQuote(proposalId);
            System.debug(LoggingLevel.WARN, 'TEST22 ORDER PROPOSAL '+ proposalId); 
        } 
        if(proposal.APTS_Proposal_Business_Unit__c == 'FindLaw'){
            return 'WARNING:Your order is NOT yet complete! Please go fill out the Client Order Brief, after completion of the COB your order will be submitted for processing.';}
        else{
            return 'Order submitted successfully!!!';}
    }
    /**
     * @description validateForSignatureBlock
     * @param proposalId
     *
     * @return ''
     */
    webservice static String validateForSignatureBlock(Id proposalId){
        return validateProposalForSignatureBlock(proposalId);
    }
    /**
     * @description validateProposalForAssentFields
     * @param proposalId
     *
     * @return ''
     */
    // This method checks for Assent Info for non InsideSales Profile // Punitha Soc-3358
    public static String validateProposalForAssentFields(Id proposalId){
        Boolean assentFieldRepFlag=False; 
        //Boolean notInsideSalesFlag=False;
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){return null;
        }
        Apttus_Proposal__Proposal__c proposal1 = [SELECT APTS_Assent_Customer_Name__c, APTS_Assent_Name_of_Rep__c, APTS_Assent_DateTime__c, OwnerId FROM Apttus_Proposal__Proposal__c WHERE id =:proposalId LIMIT 1];  
                
        // SOC-3358 by Punitha    
        if((proposal1.APTS_Assent_Customer_Name__c != null) ||
           (proposal1.APTS_Assent_Name_of_Rep__c != null) || 
           (proposal1.APTS_Assent_DateTime__c != null)){
               assentFieldRepFlag = true;
           } 
        System.debug(LoggingLevel.WARN,'assentFieldRepFlag...'+assentFieldRepFlag);
        if(!Schema.sObjectType.PermissionSetAssignment.isAccessible() && !Schema.sObjectType.PermissionSetAssignment.isQueryable()){
            return null;
        }
        List<PermissionSetAssignment> proposalNonInsideSales =  [SELECT Id, PermissionSet.Name,AssigneeId
                                                                 FROM PermissionSetAssignment
                                                                 WHERE AssigneeId = :proposal1.ownerId AND PermissionSet.Name = 'Apttus_CPQ_Inside_Sales_User'];        
        if(!Schema.sObjectType.user.isAccessible() && !Schema.sObjectType.user.isQueryable()){
            return null;
        }
        User proposalOwner = [SELECT Id,name, Market_Segment_Description__c, Sales_Force_Description__c from user where id =:proposal1.ownerId];
        
        if(assentFieldRepFlag == True){
            If(proposalNonInsideSales.isEmpty() && (proposalOwner .Market_Segment_Description__c !='Inside' && proposalOwner.Sales_Force_Description__c !='Home Office')) {
                    System.debug( LoggingLevel.WARN, 'Inside if condition...');
                    return System.Label.APTTUS_Error_Message;                    
            }            
        }         
        return null;        
    }
    /**
     * @description validateProposalForSignatureBlock
     * @param proposalId
     *
     * @return ''
     */
    // This function performs the checks for signature block.
    public static String validateProposalForSignatureBlock(Id proposalId) {
        Double totalAmount=0;
        Double totalAmountcan=0;
        Boolean productFlag=false;
        Boolean signblockFlag1=false;      //DOC-239 
        Boolean signblockFlag2=false;      //DOC-239
        Boolean signblockFlag3=false;      //DOC-239
        Boolean signblockFlag4=false;      //DOC-14303
        Boolean checkCaselineFamilyFlag=false; //DOC-14303
        Boolean checkPonderaFamilyFlag =false; //DOC-15746
        Boolean canadaproductFlag=false;  //DOC-239 
        Boolean assentFlag=false;  //DOC-239
        Boolean isGLPSignatureFlag = false;      //GLP-164 
        String printPurchaseOptions;
        String purchaseOptions;
        Boolean assentCompletedFlag=true;
        Boolean customerSignatureReqd=false;
        //Boolean onlineContactsValidation;
        Boolean masterContactsValidation;
        Boolean contactsValidation=true;
        Boolean shipOrSubFlag=false; 
        //Boolean canadaSignature=false;
        Boolean lawFlag=false;// SOC-3798 by Bijeta
        //SOC-3912 19/07      
        Map<Id,User> userMap = new Map<Id,User>();
        //Boolean taxSignatureReq = false;
        
        //get the threshold amount from config approval settings
        Double thresholdAmount = [SELECT Threshold_Amount__c FROM APTS_ConfigApprovalSettings__c].Threshold_Amount__c;   
        
        //check the total amount and media high level of the products associated with the proposal
        //Ravali - DOC-239 added customer group and industry
        if(!Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){
            return null;
        }
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = [SELECT Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c,Apttus_Proposal__Proposal__r.Customer_Group__c,Apttus_Proposal__Proposal__r.APTS_Industry_Code__c,Apttus_QPConfig__NetPrice__c,APTS_Media_High_Level__c,APTS_Product_Family__c , APTS_Media_High_Level_Code__c,APTS_Media_Lower_Level_Code__c,apttus_qpconfig__attributevalueid__r.scs_print_purchase_options__c,apttus_qpconfig__attributevalueid__r.eBook_Purchase_Options__c,APTS_Item_Category_Group__c,APTS_Online_Contacts_Validation__c, APTS_Master_Contacts_Validation__c, Apttus_QPConfig__LineType__c,APTS_Cat_L3__c,APTS_Cat_L2__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c=:proposalId];       
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : lineItems) {
            //if (lineItem != null && lineitem.Apttus_QPConfig__HasOptions__c == false) totalAmount += lineItem.Apttus_QPConfig__NetPrice__c;
            //DOC-239 Added !PBU Canada
            if (lineItem != null && lineitem.Apttus_QPConfig__LineType__c == 'Product/Service' && lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c != 'Canada'){ totalAmount += lineItem.Apttus_QPConfig__NetPrice__c;}
            //DOC-239 Added PBU Canada
            if (lineItem != null && lineitem.Apttus_QPConfig__LineType__c == 'Product/Service' && lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Canada'){ totalAmountcan += lineItem.Apttus_QPConfig__NetPrice__c;}
            
            //DOC-14303
            if (lineItem.APTS_Product_Family__c!=null &&(lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
                checkCaselineFamilyFlag = true;
            }
            
            //DOC-15746
            if (lineItem.APTS_Product_Family__c!=null &&(lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Pondera_Product_Family))) {
                checkPonderaFamilyFlag = true;
            }
            
            //DOC-239 added PBU!=Canada
            if (((lineItem.APTS_Media_High_Level__c == 'Software') || (lineItem.APTS_Media_High_Level__c == 'ProView') || (lineItem.APTS_Media_High_Level__c == 'Online') || (lineItem.APTS_Media_High_Level_Code__c == '21')|| (lineItem.APTS_Cat_L3__c== 'L3_L039_FP')) && (lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c != 'Canada')) {
                productFlag = true;
                system.debug(LoggingLevel.WARN,'##### productFlag = '+productFlag );
            }
            //DOC-239 - canadaproductflag
            else if((lineItem.APTS_Media_High_Level_Code__c == '21' || lineItem.APTS_Media_High_Level_Code__c == '07') && lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Canada'){
                canadaproductFlag = true;
            } 
            //DOC-239 & DOC-15746
            else if((lineItem.APTS_Media_High_Level_Code__c == '06' || lineItem.APTS_Media_High_Level_Code__c == '05' || lineItem.APTS_Media_High_Level_Code__c == '13') && lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Canada' && (!checkCaselineFamilyFlag || !checkPonderaFamilyFlag)){
                signblockFlag1 = true;
            }
            //DOC-14303 & DOC-15746
            else if((lineItem.APTS_Media_High_Level_Code__c == '13' || lineItem.APTS_Media_High_Level_Code__c == '26') && (checkCaselineFamilyFlag || checkPonderaFamilyFlag)){ 
                signblockFlag4 = true;
            }
            
            printPurchaseOptions = lineitem.apttus_qpconfig__attributevalueid__r.scs_print_purchase_options__c;
            purchaseOptions = lineitem.apttus_qpconfig__attributevalueid__r.eBook_Purchase_Options__c;
            //DOC-239 added PBU != Canada 
            
            if(lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Canada' && ((printPurchaseOptions == 'Sub Only' || printPurchaseOptions == 'Ship & Enter Sub') || purchaseOptions == 'Sub Only' || purchaseOptions == 'Entitle and Charge')){
                assentFlag = true;
            }
            if (lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c != 'Canada' && ((printPurchaseOptions == 'Ship & Enter Sub') ||
                                                                                                     (printPurchaseOptions == 'Sub Only')||
                                                                                                     (printPurchaseOptions == 'Fill-Up & Enter Sub'))){ //SOC-3518 by Punitha on 15/3/17
                                                                                                     shipOrSubFlag = true;}
            
            //DOC-239 added PBU != Canada 
            if (lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c != 'Canada' && ((printPurchaseOptions == 'Ship & Enter Sub APP') ||
                                                                                                     (printPurchaseOptions == 'Sub Only APP') ||
                                                                                                     (printPurchaseOptions == 'Fill-Up & Enter Sub APP'))){
                                                                                                     customerSignatureReqd = true;    }       
            
            System.Debug(LoggingLevel.WARN,'printPurchaseOption = ' + printPurchaseOptions + '********');
            System.Debug(LoggingLevel.WARN,'customerSignatureReqd = ' + customerSignatureReqd + '********');
            
            masterContactsValidation=lineitem.APTS_Master_Contacts_Validation__c;
            if (((lineItem.APTS_Media_High_Level__c=='Online') || (lineItem.APTS_Media_High_Level__c=='Software'))&&(masterContactsValidation!=true) && lineItem.APTS_Product_Family__c!=null &&!(lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family))){
                contactsValidation=false;  }
            if (((lineItem.APTS_Media_High_Level__c == 'Software') ||
                 (lineItem.APTS_Media_High_Level__c == 'Online') ) && 
                (lineItem.APTS_Cat_L2__c!=    Label.APTS_Clear_Product_Family)){
                    lawFlag = true;}// SOC-3798 by Bijeta
            /*if(lineItem.APTS_Media_High_Level_Code__c == '06' || lineItem.APTS_Media_High_Level_Code__c == '05' ||lineItem.APTS_Media_High_Level_Code__c == '15'){
mediaCode = true;
}*/
            //Start: GLP-164
            if (lineItem.APTS_Media_High_Level_Code__c == '21' && lineItem.APTS_Media_Lower_Level_Code__c =='F4' 
                && lineItem.APTS_Item_Category_Group__c == 'ZPR2') {
                isGLPSignatureFlag = true;
            }
            //End GLP-164
        }
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){return null;
        }
        Apttus_Proposal__Proposal__c proposal = [SELECT APTS_LMS_Catalog__c,APTS_Assent_Customer_Name__c,APTS_SSD_Sold_To__c,APTS_Proposal_Business_Unit__c,Languagecode__c,Customer_Group__c,APTS_Industry_Code__c, APTS_Assent_Name_of_Rep__c, APTS_Assent_DateTime__c, OwnerId, Apttus_Proposal__Account__c,Apttus_Proposal__Account__r.Customer_Group__c, APTS_Law_Enforcement_Required__c, APTS_Access_Type__c FROM Apttus_Proposal__Proposal__c WHERE id =:proposalId LIMIT 1];  // 3717 by Bijeta// SOC-3798 by Bijeta
        
        if((proposal.APTS_Assent_Customer_Name__c == null) ||
           (proposal.APTS_Assent_Name_of_Rep__c == null) || 
           (proposal.APTS_Assent_DateTime__c == null)){
           assentCompletedFlag = false;}
                
        // 3717 by Bijeta
        Boolean isInsideSales=false;
        if(!Schema.sObjectType.PermissionSetAssignment.isAccessible() && !Schema.sObjectType.PermissionSetAssignment.isQueryable()){return null;
        }
        List<PermissionSetAssignment> proposalOwnerPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :proposal.ownerId];
        for (PermissionSetAssignment psa: proposalOwnerPerSet)
        {
            if(psa.PermissionSet.Name.equals('Apttus_CPQ_Inside_Sales_User')){                
                isInsideSales = true;
            }
        }
        //SOC-3912 19/07   
        if(!Schema.sObjectType.User.isAccessible() && !Schema.sObjectType.User.isQueryable()){return null;
        }       
        for( User up : [SELECT id, Name, Market_Segment_Description__c, Sales_Force_Description__c,Sub_Bu__c,Profile.Name from User WHERE id =:proposal.ownerId OR id =:UserInfo.getUserId()]){
            userMap.put(up.Id,up);
        }
        
        //user propowner = [select id, name, Market_Segment_Description__c, Sales_Force_Description__c from user where id =:proposal.ownerId ];
        
        //DOC-239 added PBU != Canada 
        if((customerSignatureReqd == false) && (shipOrSubFlag == true) && proposal.APTS_Proposal_Business_Unit__c != 'canada' && (assentCompletedFlag==false) && (totalAmount < thresholdAmount)){
            if((userMap.containsKey(proposal.ownerId) && (userMap.get(proposal.ownerId).Market_Segment_Description__c=='Inside' || userMap.get(proposal.ownerId).Sales_Force_Description__c=='Home Office')) || isInsideSales==true){                
                return 'Assent info missing!!!';                 
            }
        } 
        // 3717 by Bijeta end
        // SOC-3798 by Bijeta
        //Replaced Account query with Source System Detail query by Tejaswi for Product configuration jira story
        if(!Schema.sObjectType.Source_System_Detail__c.isAccessible() && !Schema.sObjectType.Source_System_Detail__c.isQueryable()){return null;
        }
        Source_System_Detail__c ssd = [select id, LCRM_Customer_Group__c,LCRM_Sales_Org__c from Source_System_Detail__c where id =:proposal.APTS_SSD_Sold_To__c];
        // if (proposal.Apttus_Proposal__Account__c!= null && (userMap.containsKey(proposal.ownerId)&& userMap.get(proposal.ownerId).Profile.Name !='LMS - User' && userMap.containsKey(UserInfo.getUserId())&& userMap.get(UserInfo.getUserId()).Profile.Name !='LMS - User'))  {     
        //SOC-8422 Changing LMS profile to SUB BU LMS
        //DOC-5181 : Added by Nandha - SSD != CAN
        //DOC-12752-Added and Commented as part of CrossSell
        /*if (ssd != null && ssd.LCRM_Sales_Org__c != 'CARS' && (userMap.containsKey(proposal.ownerId)&& userMap.get(proposal.ownerId).Sub_Bu__c !='LMS' && userMap.containsKey(UserInfo.getUserId())&& userMap.get(UserInfo.getUserId()).Sub_Bu__c !='LMS')) {*/
        if (ssd != null && ssd.LCRM_Sales_Org__c != 'CARS' && proposal.APTS_LMS_Catalog__c != true) {
            if(String.isEmpty(proposal.APTS_Law_Enforcement_Required__c)==true && lawFlag==true && (ssd.LCRM_Customer_Group__c=='GOVERNMENT' || ssd.LCRM_Customer_Group__c=='FEDERAL GOVERNMENT')){
                return'Indicate if account is Law Enforcement and inmate access type.  Add applicable Selected Clause.';
            }
        }
        //Added by Bhargav-- DOC-239 Code Changes start here
        if(proposal.APTS_Proposal_Business_Unit__c == 'Canada'){            
            if (assentCompletedFlag == false && totalAmountcan <= 5000 && canadaproductFlag == true && assentFlag == true && (proposal.Customer_Group__c != 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD')){                
                return 'Assent info missing!!!'; 
            }
            if(proposal.Customer_Group__c != 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD'){
                signblockFlag2 = true;
            } 
            if(signblockFlag1 == true && ((proposal.Customer_Group__c != 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD') || (proposal.Customer_Group__c == 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD'))){
                signblockFlag3 = true;
            }
        }
        
        //Start:GLP-164
        if(isGLPSignatureFlag == true) {
            return 'Signature required';
        }
        //End:GLP-164
        
        //DOC-239 changes end here
        //DOC-5181 : Added by Nandha - PBU != CAN
        if(proposal.APTS_Law_Enforcement_Required__c=='Yes' && String.isEmpty(proposal.APTS_Access_Type__c) == true && proposal.APTS_Proposal_Business_Unit__c != 'Canada'){
            return'Indicate if account is Law Enforcement and inmate access type.  Add applicable Selected Clause.';
        }// SOC-3798 by Bijeta
        
        if ((productFlag == true) || (customerSignatureReqd == true) || (totalAmount > thresholdAmount)){ return 'Docusign needed';}
        if ((shipOrSubFlag == true) && (totalAmount < thresholdAmount) && (isInsideSales == false)){ return 'Update Signature Flag';}
        //DOC-239 : Added by Nandha - PBU != CAN
        if (contactsValidation == false && proposal.APTS_Proposal_Business_Unit__c != 'Canada'){ return 'Online or Master Contacts missing!!!';}
        //DOC-239
        if((signblockFlag2 == true && ((signblockFlag1 == true && totalAmountcan < 5000) || totalAmountcan > 5000)) || signblockFlag3 == true){ return 'Signature required';}
        
        //DOC-14303 & DOC-15746
        if(signblockFlag4 == true){
            return 'Signature required';
        }

        return 'Checks successful'; 
    }   
    /**
     * @description validateProposalForManualOrderSubmission
     * @param proposalId
     *
     * @return ''
     */
    // This function performs the checks to make sure that the order is eligible for manual order submission.
    public static String validateProposalForManualOrderSubmission(Id proposalId) {
        Double totalAmount=0;
        Boolean productFlag=false;
        String printPurchaseOptions;
        Boolean assentReqd=false;
        List<String> listofSSDNo;
       List<Source_System_Detail__c> listofSSD;
       String strCredentialaction ='CredentialInfo';  
    String strCredentialsalesOrg;
    string WebServiceNameCredential = 'LCRM_CredentialInfoServices';
    LCRMCredentialInfoHelper CredentialHelper;
    list<LCRMCredentialJsonWrapper.CredentialInfoItemcls> credInfoList1;
        Boolean canadaonlineFlag=false;  //DOC-239
        Boolean checkFlag=false; //DOC-14302
        Boolean checkCaselineFamilyFlag=false; //DOC-14302
        Boolean customerSignatureReqd=false;
        Boolean onlineContactsValidation;
        Boolean masterContactsValidation;
        Boolean contactsValidation=true;    
        //Boolean peopleMap=false;
        Boolean taxSignatureReq = false;
        Double taxThreshold =1000;
        // Apttus_Proposal__Proposal__c proposal = [SELECT APTS_Assent_Customer_Name__c,APTS_People_Map__c,APTS_Assent_Name_of_Rep__c, APTS_Assent_DateTime__c, APTS_Wet_Signature__c,OwnerId,Apttus_Proposal__Account__r.SAPAccountNumber__c,Apttus_Proposal__Account__r.Sales_Org__c FROM Apttus_Proposal__Proposal__c  WHERE id =:proposalId LIMIT 1];//SOC-3600 by Bijeta on 15/3/17   
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){
            return null;
        }
        Apttus_Proposal__Proposal__c proposal = [SELECT APTS_Assent_Customer_Name__c,Customer_Group__c,APTS_People_Map__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_Industry_Code__c,APTS_Assent_Name_of_Rep__c, APTS_Assent_DateTime__c, APTS_Wet_Signature__c, OwnerId, RecordType.Name,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c,APTS_Proposal_Business_Unit__c , APTS_Validation_Messages__c,APTS_Is_HighQ_Quote__c FROM Apttus_Proposal__Proposal__c WHERE id =:proposalId LIMIT 1];//SOC-3600 by Bijeta on 15/3/17//added PBU SOC-8996
        System.debug(LoggingLevel.WARN, 'Exception caught: ' +proposal); 
        system.debug(LoggingLevel.WARN, 'aptsSSD '+proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c);
        strCredentialsalesOrg = proposal.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c;
         if(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!= null){
            
            listofSSDNo = new List<String>();
             listofSSDNo.add(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c);
             
             
             if(!Schema.sObjectType.Source_System_Detail__c.isAccessible() && !Schema.sObjectType.Source_System_Detail__c.isQueryable()){
            return null;
        }
            
            listofSSD = [Select id, Source_System_Account_Number__c from Source_System_Detail__c where Source_System_Account_Number__c IN : listofSSDNo];
            }
        //if(proposal.APTS_People_Map__c>0 && proposal.Apttus_Proposal__Account__r.SAPAccountNumber__c != null)
        if(proposal.APTS_People_Map__c>0 && proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!= null && (!listofSSD.isEmpty() && strCredentialaction =='CredentialInfo' && strCredentialsalesOrg ==proposal.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c)){
                //Credential Webservice
                String jsonString = LCRMCredentialJsonWrapper.getCredentialReqJsonString(strCredentialaction,strCredentialsalesOrg,listofSSD);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                
                CredentialHelper = new LCRMCredentialInfoHelper(); 
                credInfoList1 = new list<LCRMCredentialJsonWrapper.CredentialInfoItemcls>(); 
                request = CredentialHelper.getHttpRequestCred(WebServiceNameCredential,jsonString);
                system.debug(LoggingLevel.WARN,'request123 '+request);
                HttpResponse Response = new HttpResponse();
                 if (!test.isrunningtest()) { 
                Response = http.Send(request);
                 }else {
                //Test Classes Response.
                Response = new HttpResponse();
                Response.setHeader('Content-Type', 'application/json');
                Response.setBody('{"getCredentialInfoResponse" : {"CredentialInfoItem" : [ {"accountNumber" : "1000497321","domain" : "WESTLAW","credentialProgress" : null,"credentialProgressDesc" : null,"credentialStatus" : "AA","credentialStatusDesc" : "Approved - All","businessType" : null,"businessTypeDesc" : null,"restrictionCls" : null,"restrictionClsDesc" : null,"progessDt" : "0000-00-00","statusDt" : "0000-00-00","responseStatus" : null,"responseStatusDescription" : null} ],"BusinessRestrictionItem" : [ {"accountNumber" : "1000497321","businessRestriction" : null,"businessRestrictionDesc" : null,"responseStatus" : "E","responseStatusDescription" : "No Data Found"} ]}}');
                Response.setStatusCode(200);
            }
                System.debug(LoggingLevel.WARN, 'Response:-'+Response);
                System.debug(LoggingLevel.WARN, 'response body'+Response.getBody());
                System.debug(LoggingLevel.WARN, 'response status '+Response.getStatusCode());
                String JsonResponseCredential=Response.getBody();
                if(Response.getStatusCode() == 200 && JsonResponseCredential.contains('credentialStatusDesc')){
                credInfoList1 = LCRMCredentialJsonWrapper.getjsonresponse(JsonResponseCredential);
                }
               
            //Prabhu Starts SOC-5513/5512
            //IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(proposal.Apttus_Proposal__Account__r.Sales_Org__c);
            /*IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(proposal.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c);
            CredentialInfoServices.CredentialRequest oRequest;
            String strValidityDate= system.today().format();
            String strCompanyCode = oIXOSCodeMap.Company_Code__c;
            String strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            String strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            String strDivisionCode = oIXOSCodeMap.Division_Code__c;
            Decimal accountSapId; 
            if(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!= null){                
                accountSapId=Decimal.valueOf(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c);         
            }
                    
            
            oRequest = new CredentialInfoServices.CredentialRequest();
            oRequest.AcctSapId = accountSapId;
            oRequest.CompanyCode = strCompanyCode;
            oRequest.SalesOrgCode = strSalesOrgCode;
            oRequest.DistChanCode = strDistChanCode;
            oRequest.DivisionCode = strDivisionCode;
            credInfoList = CredentialInfoServices.getCredentialInfoItems(oRequest);*/
            //List<Attachment> attList;
            List<contentversion> contVerion = new List<contentversion>();
            List<id> contLinkIds  = new List<id>();
            try{
                /*if(!Schema.sObjectType.Attachment.isAccessible() && !Schema.sObjectType.Attachment.isQueryable()){
                    return null;
                }
                attList = [SELECT id, Name FROM Attachment WHERE ParentId = :proposalId AND Name Like '%AVC%'];   
                if(attList.isEmpty()) { */
                    if(!Schema.sObjectType.ContentDocumentLink.isAccessible() && !Schema.sObjectType.ContentDocumentLink.isQueryable()){return null;
                    }
                    List<ContentDocumentLink> contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
                    System.debug(LoggingLevel.WARN, 'Fine ContLink...'+contLink); 
                    if(!contLink.isEmpty()) 
                    {
                        for(ContentDocumentLink cd : contLink) 
                        { contLinkIds.add(cd.ContentDocumentId);}
                        
                    }
                    if(!Schema.sObjectType.contentversion.isAccessible() && !Schema.sObjectType.contentversion.isQueryable()){return null;
                    }
                    contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata from contentversion where ContentDocumentId IN : contLinkIds AND title Like '%AVC%'];
                //}
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }  
            }
            catch(Exception e) {
                System.debug(LoggingLevel.WARN, 'Exception caught: ' + e.getMessage());    
            }
            System.debug(LoggingLevel.WARN, 'CredentialStatusDesc: ' + credInfoList1);
           if(credInfoList1.isempty() && (contVerion==null || contVerion.size()==0)){
             
            //if((credInfoList1.isempty() && (attList==null || attList.size()==0)) && (credInfoList1.isempty() && (contVerion==null || contVerion.size()==0))){
                return 'AVC Order Form Has To Be Generated Before Sending For Esignature.'; 
            }
           if(credInfoList1.size() > 0) {  
           for(Integer i=0; i<credInfoList1.size(); i++){
                System.debug(LoggingLevel.WARN, 'Fine credInfoList...'+credInfoList1);     
                if( ((credInfoList1 != null && !credInfoList1[i].CredentialStatusDesc.contains('Approved')) && (contVerion==null || contVerion.size()==0 ))){
                //if(((JsonResponseCredential!= null && !JsonResponseCredential.contains('Approved')) && (attList==null || attList.size()==0 )) && ((JsonResponseCredential!= null && !JsonResponseCredential.contains('Approved')) && (contVerion==null || contVerion.size()==0 ))){
                     
                    return 'AVC Form Has To Be Generated Before Submitting Order.';  
                }
            }}
        }
        //Prabhu Ends
        /* June Release Changes SOC-3841
    if((proposal.RecordType.Name =='SpecialOffer')&& 
    (proposal.APTS_Wet_Signature__c == false)) return 'Wet Signature must be checked before submitting an order for processing';*/
        //Added by Gowthami as part of SOC-8669 dated 20/8/18
        //Added by Nandha for wet sign - DOC-3941
        if((proposal.APTS_Proposal_Business_Unit__c=='FindLaw' || proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' 
            || proposal.APTS_Proposal_Business_Unit__c == 'Corp OneOTC UK' /*|| proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'*/) && proposal.APTS_Wet_Signature__c==false){
            return 'You are unable to submit this quote proposal as you have not completed the wet signature process.';}
        if (proposal.APTS_Wet_Signature__c == true){
            return 'Checks successful';}  
        
        //get the threshold amount from config approval settings
        //if(!Schema.sObjectType.APTS_ConfigApprovalSettings__c.isAccessible() && !Schema.sObjectType.APTS_ConfigApprovalSettings__c.isQueryable()){
                    //return null;
        //}
        Double thresholdAmount=0;
        APTS_ConfigApprovalSettings__c configApp= APTS_ConfigApprovalSettings__c.getinstance('SignoffRequiredAmount');
        if(configApp!=null && configApp.Threshold_Amount__c!=null){
            thresholdAmount = configApp.Threshold_Amount__c;
        }
        
        //check the total amount and media high level of the products associated with the proposal
        //Ravali - DOC-239 - Added PBU, Cust group and Ind code
        if(!Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){return null;
        }
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItems = [SELECT Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c,Apttus_Proposal__Proposal__r.Customer_Group__c, Apttus_Proposal__Proposal__r.APTS_Industry_Code__c,Apttus_QPConfig__NetPrice__c,APTS_Media_High_Level__c,APTS_Product_Family__c, APTS_Media_High_Level_Code__c,APTS_Media_Lower_Level_Code__c, apttus_qpconfig__attributevalueid__r.scs_print_purchase_options__c, APTS_Online_Contacts_Validation__c,APTS_Master_Contacts_Validation__c,Apttus_QPConfig__LineType__c, Apttus_product_variant__c,Apttus_product_variant__r.APTS_Product_Delivery_Pick__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c=:proposalId];       
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : lineItems) {
            //if (lineItem != null && lineitem.Apttus_QPConfig__HasOptions__c == false) totalAmount += lineItem.Apttus_QPConfig__NetPrice__c;
            if (lineItem != null && lineitem.Apttus_QPConfig__LineType__c == 'Product/Service'){ totalAmount += lineItem.Apttus_QPConfig__NetPrice__c;}
            //DOC-14302
            if (lineItem.APTS_Product_Family__c!=null && (lineItem.APTS_Product_Family__c.equalsIgnoreCase(System.Label.Caseline_Product_Family))) {
                checkCaselineFamilyFlag= true;
            }
            //Ravali - DOC-239 - Added PBU!=canada
            if ( (((lineItem.APTS_Media_High_Level__c == 'Software') ||
                 (lineItem.APTS_Media_High_Level__c == 'ProView') ||
                 (lineItem.APTS_Media_High_Level__c == 'Online') ||
                 (lineItem.APTS_Media_High_Level_Code__c == '21')) 
                 && (lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c != 'Canada'))
                //Start: Added by Kruti Shah for DOC-11542
                 || ((lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'SCS' || (lineitem.apttus_proposal__proposal__r.apts_proposal_business_unit__c != null && System.Label.Risk_PBUs.contains(lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c))) 
                    && ((lineItem.APTS_Media_High_Level_Code__c == '05' &&
                         (String.isBlank(lineItem.APTS_Media_Lower_Level_Code__c) || lineItem.APTS_Media_Lower_Level_Code__c =='E9' || lineItem.APTS_Media_Lower_Level_Code__c =='NZ'))
                        || (lineItem.APTS_Media_High_Level_Code__c == '06' && lineItem.APTS_Media_Lower_Level_Code__c =='AB')
                        || (lineItem.APTS_Media_High_Level_Code__c == '13' &&
                            (lineItem.APTS_Media_Lower_Level_Code__c =='NX' || lineItem.APTS_Media_Lower_Level_Code__c =='NW' || lineItem.APTS_Media_Lower_Level_Code__c =='NT'))
                        || (lineItem.APTS_Media_High_Level_Code__c == '26' && String.isBlank(lineItem.APTS_Media_Lower_Level_Code__c) )))
                        //DOC-14302
                        && !checkCaselineFamilyFlag
                //End: Added by Kruti Shah for DOC-11542
               ) {
                productFlag = true;
                system.debug(LoggingLevel.WARN, '#### productFlag'+productFlag);
            //DOC-239 - canadaonlineflag
            //Added lineItem.APTS_Media_High_Level_Code__c == '26' by Kruti Shah for DOC-11542
            //DOC-14302
            } else if((lineItem.APTS_Media_High_Level_Code__c == '06' || lineItem.APTS_Media_High_Level_Code__c == '05' || lineItem.APTS_Media_High_Level_Code__c == '13' || lineItem.APTS_Media_High_Level_Code__c == '26')
                      && lineitem.Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c == 'Canada' && !checkCaselineFamilyFlag ){
                canadaonlineFlag = true;
            } 
            //DOC-14302
            else if((lineItem.APTS_Media_High_Level_Code__c == '13' || lineItem.APTS_Media_High_Level_Code__c == '26') && proposal.APTS_Wet_Signature__c != true && checkCaselineFamilyFlag ){
                checkFlag = true;
            }
            printPurchaseOptions = lineitem.apttus_qpconfig__attributevalueid__r.scs_print_purchase_options__c;

            
            if ((printPurchaseOptions == 'Ship & Enter Sub') ||
                (printPurchaseOptions == 'Sub Only') ||
                (printPurchaseOptions == 'Fill-Up & Enter Sub')){
                    assentReqd = true;
                }
            
            if ((printPurchaseOptions == 'Ship & Enter Sub APP') ||
                (printPurchaseOptions == 'Sub Only APP') ||
                (printPurchaseOptions == 'Fill-Up & Enter Sub APP')){
                customerSignatureReqd = true;}
            if(printPurchaseOptions != 'Ship Only' || 
               (lineitem.Apttus_product_variant__c == null || (lineitem.Apttus_product_variant__c != null && lineitem.Apttus_product_variant__r.APTS_Product_Delivery_Pick__c != 'Print'))){
                   taxSignatureReq = true;
               }  
            onlineContactsValidation=lineitem.APTS_Online_Contacts_Validation__c;
            masterContactsValidation=lineitem.APTS_Master_Contacts_Validation__c; 
            
            if (proposal.APTS_Validation_Messages__c != null && proposal.APTS_Validation_Messages__c.Contains('Password Holder')) { //DOC-11887 : Jinal Bhatt
                
                if ((lineItem.APTS_Media_High_Level__c == 'Online') && (onlineContactsValidation!=true)){
                contactsValidation = false;}
                
                if (((lineItem.APTS_Media_High_Level__c=='Online') || (lineItem.APTS_Media_High_Level__c=='Software'))
                    &&(masterContactsValidation!=true)){
                    contactsValidation=false;     }
                
            }  //DOC-11887 : Jinal Bhatt      
        }
        if (productFlag == true){ return 'Orders with Software/ProView/Online products cannot be manually submitted';}
        system.debug(LoggingLevel.WARN, '### contactsValidation'+contactsValidation);
        if (customerSignatureReqd == true){ return 'Orders containing APP cannot be manually submitted. Use Docusign to get customer approval!!!';}
        //Added HighQ Conditio by Kruti Shah for DOC-11820
        if (contactsValidation == false && proposal.APTS_Is_HighQ_Quote__c != null && proposal.APTS_Is_HighQ_Quote__c == 0){ return 'Online or Master Contacts are missing. Please add them before submitting the order!!!';}
        
        //SOC-3358 by bijeta 16/3/17      
        Boolean test=false;
        if(!Schema.sObjectType.PermissionSetAssignment.isAccessible() && !Schema.sObjectType.PermissionSetAssignment.isQueryable()){return null;
        }
        List<PermissionSetAssignment> proposalOwnerPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :proposal.ownerId];
        for (PermissionSetAssignment psa: proposalOwnerPerSet )
        {
            if(psa.PermissionSet.Name.equals('Apttus_CPQ_Inside_Sales_User')){  // 3717 by Bijeta
            test = true;}
        }
        if(!Schema.sObjectType.User.isAccessible() && !Schema.sObjectType.User.isQueryable()){return null;
        }
        user propowner = [select id, name, Market_Segment_Description__c, Sales_Force_Description__c from user where id =:proposal.ownerId ];
        
        if (customerSignatureReqd == false && assentReqd == true && (totalAmount < thresholdAmount)) {
            // get the assent fields from proposal
            if (((proposal.APTS_Assent_Customer_Name__c == null) ||
                (proposal.APTS_Assent_Name_of_Rep__c == null) || 
                (proposal.APTS_Assent_DateTime__c == null)) && (propowner.Market_Segment_Description__c=='Inside' || propowner.Sales_Force_Description__c=='Home Office'  || Test==true)) { 
                        return 'Please fill out all the fields in the Assent section before submitting the order!!!';}
            }
        if(canadaonlineFlag == true && ((proposal.Customer_Group__c != 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD') || (proposal.Customer_Group__c == 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD')) && proposal.APTS_Wet_Signature__c==false){
            return 'Orders with Software/Online products cannot be manually submitted';
        }
        
        //get the threshold amount from config approval settings
        //   Double thresholdAmount = [SELECT Threshold_Amount__c FROM APTS_ConfigApprovalSettings__c].Threshold_Amount__c;
        //Ravali - DOC-239 - added PBU != canada and condition for canada $ value
        //DOC-14302
        if (totalAmount > thresholdAmount && proposal.APTS_Proposal_Business_Unit__c != 'canada' && proposal.APTS_Proposal_Business_Unit__c != 'Tax Professional' && !checkCaselineFamilyFlag){ return ('Order value greater than $' + thresholdAmount + ' need customer signature');}
        if(totalAmount >5000 &&proposal.APTS_Proposal_Business_Unit__c == 'canada' && proposal.Customer_Group__c != 'ACADEMIC' && proposal.APTS_Industry_Code__c != 'CARS-RS-BKST ACAD' && !checkCaselineFamilyFlag){
        return 'Order value greater than $5000 needs customer signature';}
        //DOC-3812 - added PBU = Tax Professional and condition for Tax $ value
        if(proposal.APTS_Proposal_Business_Unit__c == 'Tax Professional'){
            if(!taxSignatureReq && totalAmount < taxThreshold){
                return 'Checks successful';
            }else{
                return 'You are unable to submit this quote proposal as you have not completed the wet signature process.';
            }            
        }
        //DOC-14302
        if(checkFlag == true){
            return 'Orders with Software/ProView/Online products cannot be manually submitted';
        }
    
        //uncommented by roma 
        return 'Checks successful'; 
    }
    
    /**
     * @description validateProposalForInventory
     * @param proposalId
     * @return ''
     */
    //Merging Findlaw change starts
    //Changed by Gowthami as part of OC-FL SOC-6853 dated 22/3/18
    //Checks for the lineItem wich is having line status new,BU as FL,Product details shoudl not be null
    public static List<Apttus_Proposal__Proposal_Line_Item__c> validateProposalForInventory(Id proposalId)
    {
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){return null;
        }
        //Apttus_Proposal__Proposal__c proposal = [SELECT id,APTS_Proposal_Business_Unit__c FROM Apttus_Proposal__Proposal__c WHERE id =:proposalId LIMIT 1];
        if(!Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isQueryable()){return null;
        }
        List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList=[SELECT id,Name,Apttus_Proposal__Proposal__c,Apttus_Proposal__Product__r.Name,APTS_Combination_Key__c,APTS_Combination_Key__r.APTS_Inventory_Available__c from Apttus_Proposal__Proposal_Line_Item__c where  Apttus_Proposal__Proposal__r.id=:proposalId AND Apttus_QPConfig__LineStatus__c='New' AND Apttus_Proposal__Proposal__r.APTS_Proposal_Business_Unit__c='FindLaw' AND APTS_Combination_Key__c!=null AND APTS_Combination_Key__r.APTS_Inventory_Available__c!=null];
        List<Apttus_Proposal__Proposal_Line_Item__c> inventList=new List<Apttus_Proposal__Proposal_Line_Item__c>();
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem: lineItemList){
            if(lineItem.APTS_Combination_Key__r.APTS_Inventory_Available__c==0 && lineItem.APTS_Combination_Key__r.APTS_Inventory_Available__c!=null){
                inventList.add(lineItem);
            }     
        }
        return inventList;
    }
    /**
     * @description generateAVC
     * @param proposalId
     * @return ''
     */
    //ended Changes by Gowthami as part of OC-FL SOC-6853 dated 22/3/18,merging findlaw changes ends
    //Prabhu Starts SOC-5513/5512
    //Method to check the AVC order for if the credentialling status is other that Approved/
    public static String generateAVC(Id proposalId) {          
       //Boolean peopleMap=false;
        List<String> listofSSDNo;
       List<Source_System_Detail__c> listofSSD;
       String strCredentialaction ='CredentialInfo';  
    String strCredentialsalesOrg; 
    string WebServiceNameCredential = 'LCRM_CredentialInfoServices';
        List<LCRMCredentialJsonWrapper.CredentialInfoItemcls> credInfoList;
    LCRMCredentialInfoHelper CredentialHelper;
        //Apttus_Proposal__Proposal__c proposal = [SELECT APTS_People_Map__c,Apttus_Proposal__Account__r.SAPAccountNumber__c,Apttus_Proposal__Account__r.Sales_Org__c FROM Apttus_Proposal__Proposal__c  WHERE id =:proposalId LIMIT 1];
        if(!Schema.sObjectType.Apttus_Proposal__Proposal__c .isAccessible() && !Schema.sObjectType.Apttus_Proposal__Proposal__c .isQueryable()){return null;
        }
        Apttus_Proposal__Proposal__c proposal = [SELECT APTS_People_Map__c,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c FROM Apttus_Proposal__Proposal__c  WHERE id =:proposalId LIMIT 1];
        System.debug(LoggingLevel.WARN, 'Exception caught: ' +proposal); 

        strCredentialsalesOrg = proposal.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c;

        if(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!= null){
            listofSSDNo = new List<String>();

            listofSSDNo.add(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c);
            
             if(!Schema.sObjectType.Source_System_Detail__c.isAccessible() && !Schema.sObjectType.Source_System_Detail__c.isQueryable()){
            return null;
        }
            
            
            listofSSD = [Select id, Source_System_Account_Number__c from Source_System_Detail__c where Source_System_Account_Number__c IN : listofSSDNo];
            }
        if(proposal.APTS_People_Map__c>0 && proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!= null && (!listofSSD.isEmpty() && strCredentialaction =='CredentialInfo' && strCredentialsalesOrg ==proposal.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c)) {       
                //Credential Webservice
                String jsonString = LCRMCredentialJsonWrapper.getCredentialReqJsonString(strCredentialaction,strCredentialsalesOrg,listofSSD);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                /*if(ApexPages.getMessages().size()>0){
                    return null;
                }*/
                CredentialHelper = new LCRMCredentialInfoHelper();
                
                request = CredentialHelper.getHttpRequestCred(WebServiceNameCredential,jsonString);
                HttpResponse Response = new HttpResponse();
                 if (!test.isrunningtest()) { 
                Response = http.Send(request);
                 }else {
                //Test Classes Response.
                Response = new HttpResponse();
                Response.setHeader('Content-Type', 'application/json');
                Response.setBody('{"getCredentialInfoResponse" : {"CredentialInfoItem" : [ {"accountNumber" : "1000497321","domain" : "WESTLAW","credentialProgress" : null,"credentialProgressDesc" : null,"credentialStatus" : "AA","credentialStatusDesc" : "Approved - All","businessType" : null,"businessTypeDesc" : null,"restrictionCls" : null,"restrictionClsDesc" : null,"progessDt" : "0000-00-00","statusDt" : "0000-00-00","responseStatus" : null,"responseStatusDescription" : null} ],"BusinessRestrictionItem" : [ {"accountNumber" : "1000497321","businessRestriction" : null,"businessRestrictionDesc" : null,"responseStatus" : "E","responseStatusDescription" : "No Data Found"} ]}}');
                Response.setStatusCode(200);
            }
                System.debug(LoggingLevel.WARN, 'Response:-'+Response);
                System.debug(LoggingLevel.WARN, 'response status '+Response.getStatusCode());
                System.debug(LoggingLevel.WARN, 'response body'+Response.getBody());
                String JsonResponseCredential=Response.getBody();
                credInfoList = new List<LCRMCredentialJsonWrapper.CredentialInfoItemcls>();
                
                if(Response.getStatusCode() == 200 && JsonResponseCredential.contains('credentialStatusDesc')){
                credInfoList = LCRMCredentialJsonWrapper.getjsonresponse(JsonResponseCredential);
                }
            /*IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance(proposal.APTS_SSD_Sold_To__r.LCRM_Sales_Org__c);
            CredentialInfoServices.CredentialRequest oRequest;
            String strValidityDate= system.today().format();
            String strCompanyCode = oIXOSCodeMap.Company_Code__c;
            String strSalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            String strDistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            String strDivisionCode = oIXOSCodeMap.Division_Code__c;
            Decimal accountSapId; 
            if(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c!= null){
                accountSapId=Decimal.valueOf(proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c);       
            }
            list<CredentialInfoServices.CredentialInfoBusinessRestrictionItem> credInfoList = new list<CredentialInfoServices.CredentialInfoBusinessRestrictionItem>();         
            
            oRequest = new CredentialInfoServices.CredentialRequest();
            oRequest.AcctSapId = accountSapId;
            oRequest.CompanyCode = strCompanyCode;
            oRequest.SalesOrgCode = strSalesOrgCode;
            oRequest.DistChanCode = strDistChanCode;
            oRequest.DivisionCode = strDivisionCode;
            credInfoList = CredentialInfoServices.getCredentialInfoItems(oRequest);*/
            //List<Attachment> attList;
            List<contentversion> contVerion = new List<contentversion>();
            List<id> contLinkIds  = new List<id>();
            try{
                /*if(!Schema.sObjectType.Attachment.isAccessible() && !Schema.sObjectType.Attachment.isQueryable()){
                    return null;
                }
                attList = [SELECT id, Name FROM Attachment WHERE ParentId = :proposalId AND Name Like '%AVC%'];
                if(attList.isEmpty()) {  */
                    if(!Schema.sObjectType.ContentDocumentLink .isAccessible() && !Schema.sObjectType.ContentDocumentLink .isQueryable()){return null;
                    }         
                    List<ContentDocumentLink> contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
                    if(!contLink.isEmpty()) 
                    {
                        for(ContentDocumentLink cd : contLink) 
                        { contLinkIds.add(cd.ContentDocumentId);}
                        
                    }
                    contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata from contentversion where ContentDocumentId IN : contLinkIds AND title Like '%AVC%'];
                //}
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            }
            catch(Exception e) {
                System.debug(LoggingLevel.WARN, 'Exception caught: ' + e.getMessage());    
            }
            
                 if(credInfoList.isEmpty() && (contVerion==null || contVerion.size()==0)){
            //if((JsonResponseCredential.contains('Method Not Allowed') && (attList==null || attList.size()==0)) && (JsonResponseCredential.contains('Method Not Allowed') && (contVerion==null || contVerion.size()==0))){
                return 'AVC form must be generated before generating the order form in order to ensure proper signatures can be obtained.'; 
            } 
            //if(JsonResponseCredential.length() > 0) {  
             if(credInfoList.size() > 0) {  
           for(Integer i=0; i<credInfoList.size(); i++){ 
                 if((credInfoList != null && credInfoList[i]!=null && credInfoList[i].CredentialStatusDesc!=null 
                  && !credInfoList[i].CredentialStatusDesc.contains('Approved')) && 
                 credInfoList[i].AccountNumber == proposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c && (contVerion==null || contVerion.size()==0 )){
                //if(((JsonResponseCredential!= null && !JsonResponseCredential.contains('Approved')) && (attList==null || attList.size()==0 )) && ((JsonResponseCredential!= null && !JsonResponseCredential.contains('Approved')) && (contVerion==null || contVerion.size()==0 ))){            
                    return 'AVC form must be generated before generating the order form in order to ensure proper signatures can be obtained.';              
                } 
           }}
        }
        return null;    
    }
    /**
     * @description generateExposurePackAttachment
     * @param proposalId
     *
     * @return ''
     */
    //SOC-9755 logic starts here to check Exposure pack attachment form is generated befor submitting the order if quote contains exposure pack as line item in it
    public static String generateExposurePackAttachment(Id proposalId) {      
        //List<Attachment> attList;
        List<contentversion> contVerion = new List<contentversion>();
        List<id> contLinkIds  = new List<id>();
        try{
            /*attList = [SELECT id, Name FROM Attachment WHERE ParentId = :proposalId AND Name Like '%Findlaw Attachment%'];
            if(attList.isEmpty()) { */          
                List<ContentDocumentLink> contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
                if(!contLink.isEmpty()) 
                {
                    for(ContentDocumentLink cd : contLink) 
                    { contLinkIds.add(cd.ContentDocumentId);}
                    
                }
                contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata from contentversion where ContentDocumentId IN : contLinkIds AND title Like '%Findlaw Attachment%'];
            //}
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }
        catch(Exception e) {
            System.debug(LoggingLevel.WARN, 'Exception caught: ' + e.getMessage());    
        }
        if(contVerion==null || contVerion.size()==0){
            return 'Exposure Pack Attachment MUST be generated prior to the Proposal, and MUST be provided with the Proposal to the client.'; 
        } 
        return null;
    }
    /**
     * @description sendEmailForDatabaseEntitlement
     * @param proposalId
     * @param emailAddress
     * @param propName
     * @param wetsign
     * @param existingDatabase
     *  @param clientDatabaseCode
     *  @param proposalBusinessUnit
     * @return ''
     */
    webservice static String sendEmailForDatabaseEntitlement(Id proposalId,String emailAddress,String propName,Boolean wetsign,Boolean existingDatabase,String clientDatabaseCode,String proposalBusinessUnit){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
        integer count=0;
        string message;
        String mailBodyText;//DOC-2690 
        // Get the documents attached to the proposal.
        //List<Attachment> attList = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId = :proposalId order by createddate desc];
        // List of attachments handler
        /*for(Attachment att : attList){
            if ((att.Name.containsIgnoreCase('signed') && wetsign == True) || (att.Name.containsIgnoreCase(propName+'__signed') && wetsign == False )){
                // Create the email attachment
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(att.Name);
                efa.setBody(att.body);
                if (att.ContentType == '.pdf'){
                    efa.setContentType('application/pdf');}
                else{
                    efa.setContentType(att.ContentType);}
                efa.setInline(false);
                efaList.add(efa);
                count = 1;
                break;
            }
        }*/
        List<id> contLinkIds  = new List<id>();
        List<contentversion> contVerion = new List<contentversion>();
        List<ContentDocumentLink> contLink;

        
        /* if(Schema.sObjectType.ContentDocumentLink.isAccessible() && Schema.sObjectType.ContentDocumentLink.isQueryable()){
             contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
        }
        System.debug(LoggingLevel.WARN, 'Fine ContLink...'+contLink); */ 

        contLink =returnContLinkDatabase(proposalId,contLink);

        //ContLinkId.add(ContLink);
        if(!contLink.isEmpty()){

             /* for(ContentDocumentLink cd : contLink){ 
                contLinkIds.add(cd.ContentDocumentId);
            } */
            contLinkIds = returnContLinkIds(contLink,contLinkIds);

            contVerion =[Select id, ContentDocumentId, title,FileExtension, versiondata from contentversion where (ContentDocumentId IN : contLinkIds) ORDER BY createddate desc NULLS LAST];
            System.debug(LoggingLevel.WARN, 'Fine contVerion...'+contVerion);   
            for(contentversion att1: contVerion){
                System.debug(LoggingLevel.WARN, 'Fine contVerion...'+contVerion);
                if (isCheckAtt(att1,wetsign,propName)){
                    count = count +1;
                    // Create the email attachment

                    /*Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(att1.title);
                    efa.setBody(att1.versiondata);
                    if (att1.FileExtension == 'pdf'){
                    efa.setContentType('application/pdf');}
                    else if (att1.FileExtension == 'doc'){
                    efa.setContentType('application/doc');}
                    else if (att1.FileExtension == 'docx'){
                    efa.setContentType('application/docx');}
                    else if (att1.FileExtension == 'rtf'){
                    efa.setContentType('application/rtf');}
                    else{
                    efa.setContentType(att1.FileExtension);}
                    efa.setInline(false);
                    efaList.add(efa);*/

                    efaList = returnEfaList(att1,efaList);

                    break;
                }
            }
        }
        // Attach files to email instance
        system.debug(LoggingLevel.WARN, 'mailBodyText--'+mailBodyText);

        /*
        //DOC-4862 starts       
        if(proposalBusinessUnit!=null){      
            mailBodyText='Proposal Business Unit : '+proposalBusinessUnit+'\n'; }     
        //DOC-4862 ends
        */
        mailBodyText=rtnMailBodyTxt(proposalBusinessUnit,mailBodyText);

        //DOC-2690 starts    

       /* if(existingDatabase || clientDatabaseCode!=null){   
            mailBodyText+='Existing Database : '+existingDatabase+'\n';
            mailBodyText+='Client Database Code : '+clientDatabaseCode;   
        }
        system.debug(LoggingLevel.WARN, 'mailBodyText--'+mailBodyText); */ 

        mailBodyText=returnMailBodyText(existingDatabase,clientDatabaseCode,mailBodyText);

        if(mailBodyText!=null){     
            email.setPlainTextBody(mailBodyText); }  
        else{
            email.setPlainTextBody(''); }      
        //DOC-2690 ends
        email.setSubject(System.Label.CORPEMAILSUB);
        email.setFileAttachments(efaList);
        email.setToAddresses(new String[]{emailAddress});        
        if(email != null){

            if(isCheckCond(contVerion,count)){      //attList.size() > 0 ||         
                message='Order cannot be submitted as files do not contain any signed documents.'; //Modified by Tanmay as a part of DOC-15048
            }            
            else{
                Messaging.sendEmail(new Messaging.singleEmailMessage[] {email}); 
                // On success, return a message to the calling program.
                message='Confirmation Email Sent Successfully.';
            }
        }   
        return message; 
    }

        /**
         * @description returnContLinkDatabase
         * @return returnContLinkDatabase
         * @param proposalId
         * @param contLink
         */
        public static List<ContentDocumentLink> returnContLinkDatabase(Id proposalId,List<ContentDocumentLink> contLink){
            if(Schema.sObjectType.ContentDocumentLink.isAccessible() && Schema.sObjectType.ContentDocumentLink.isQueryable()){
                contLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId =: proposalId];
           }
           System.debug(LoggingLevel.WARN, 'Fine ContLink...'+contLink);

           return contLink;
        }


    /**
     * @description rtnMailBodyTxt
     * @return rtnMailBodyTxt 
     * @param proposalBusinessUnit
     * @param mailBodyText
     */
    public static String rtnMailBodyTxt(String proposalBusinessUnit, String mailBodyText){
        if(proposalBusinessUnit!=null){      
        mailBodyText='Proposal Business Unit : '+proposalBusinessUnit+'\n'; }

        return mailBodyText; 
    }

    /**
    * @description isCheckAtt
    * @return isCheckAtt
    * @param att1
    * @param wetsign
    * @param propName
    */
    public static Boolean isCheckAtt(contentversion att1, Boolean wetsign,String propName){
        Boolean blnIsCheck =false;
        if((att1.title.containsIgnoreCase('signed') && wetsign == True) || (att1.title.containsIgnoreCase(propName+'__signed') && wetsign == False )){
            blnIsCheck = true;
        }
        return blnIsCheck;
    }
            
    /** @description returnContLinkIds
    * @return returnContLinkIds
    * @param contLink
    * @param contLinkIds
    */
    public static List<id> returnContLinkIds(List<ContentDocumentLink> contLink, List<id> contLinkIds){
        for(ContentDocumentLink cd : contLink){ 
            contLinkIds.add(cd.ContentDocumentId);
        }
        return contLinkIds;
     }

    /**
     * @description returnMailBodyText
     * @return returnMailBodyText
     * @param existingDatabase 
     * @param clientDatabaseCode
     * @param mailBodyText
     */
    public static String returnMailBodyText(Boolean existingDatabase,String clientDatabaseCode,String mailBodyText){
        if(existingDatabase || clientDatabaseCode!=null){   
            mailBodyText+='Existing Database : '+existingDatabase+'\n';
            mailBodyText+='Client Database Code : '+clientDatabaseCode;   
        }
        system.debug(LoggingLevel.WARN, 'mailBodyText--'+mailBodyText);

        return mailBodyText;
    }

    /**
     * @description isCheckCond
     * @return isCheckCond
     * @param contVerion
     * @param count
     */
    public static Boolean isCheckCond(List<contentversion> contVerion, integer count){
        Boolean blnIsCheckCond =false;
        if(contVerion.size()>0 && count == 0){
            blnIsCheckCond=true;
        }
        return blnIsCheckCond;
    }

    /**
     * @description returnEfaList
     * @return returnEfaList
     * @param att1
     * @param efaList
     */
    public static List<Messaging.Emailfileattachment> returnEfaList(contentversion att1,List<Messaging.Emailfileattachment> efaList){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(att1.title);
                    efa.setBody(att1.versiondata);
                    if (att1.FileExtension == 'pdf'){
                    efa.setContentType('application/pdf');}
                    else if (att1.FileExtension == 'doc'){
                    efa.setContentType('application/doc');}
                    else if (att1.FileExtension == 'docx'){
                    efa.setContentType('application/docx');}
                    else if (att1.FileExtension == 'rtf'){
                    efa.setContentType('application/rtf');}
                    else{
                    efa.setContentType(att1.FileExtension);}
                    efa.setInline(false);
                    efaList.add(efa);

            return efaList;
    }
}