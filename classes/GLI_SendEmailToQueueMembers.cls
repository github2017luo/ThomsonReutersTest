public without sharing class GLI_SendEmailToQueueMembers {
     @InvocableMethod(label='Send EmailToQueue' description='Sends Email to all Queue Members when case is created')
    public static void sendEmail(List<Case> caseList){
        List<Id> conIds = new List<Id>();
        List<user> usrList = new List<user>();
        List<Id> caseOwnerIds = new List<Id>();
        List<GroupMember> grpMember = new List<GroupMember>();
        List<Id> grpMemberId = new List<Id>();
        string[] address = new List<string>();
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
        EmailTemplate templateId = new EmailTemplate();
        for(case c : caseList){
            caseOwnerIds.add(c.ownerId);
            if(c.contactid != null){
            conIds.add(c.contactid);
            }
        }
        if((Schema.sObjectType.GroupMember.isAccessible() || Schema.sObjectType.GroupMember.isQueryable()) && caseOwnerIds.size() > 0){
        grpMember = [select id,UserOrGroupId From GroupMember where groupId in : caseOwnerIds];
        }
        if(grpMember.size()>0){
        for(GroupMember u :grpMember)
        {
            grpMemberId.add(u.UserOrGroupId);
        }
        }
        if((Schema.sObjectType.User.isAccessible() || Schema.sObjectType.User.isQueryable()) && grpMemberId.size()>0){
        usrList = [select id,email From User where id in : grpMemberId];
        }
        if(usrList.size() > 0){
        for(user u : usrList)
        {
            address.add(u.email);
        }
        if(Schema.sObjectType.OrgWideEmailAddress.isQueryable() || Schema.sObjectType.OrgWideEmailAddress.isAccessible()){
            owa = [select id from OrgWideEmailAddress where Address =: Label.ESC_Solcara_Org_Email_address];
        }
        if(Schema.sObjectType.EmailTemplate.isQueryable() || Schema.sObjectType.EmailTemplate.isAccessible()){
            templateId = [Select id from EmailTemplate where name = 'Solcara Case Creation Alert'];
        }
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             mail.setWhatId(caselist[0].id);
             mail.setTreatTargetObjectAsRecipient(false);
             mail.setToAddresses(address);
             mail.setSaveAsActivity(false);
        if(templateId != null){
             mail.setTemplateID(templateId.Id); 
        }
        if(conIds.size() > 0 && conIds != null){
            
            system.debug('contact 1'+conIds);
            mail.setTargetObjectId(conIds[0]);
        }
        else{
            system.debug('contact 2');
            Contact con;
            if(Schema.sObjectType.contact.isQueryable() || Schema.sObjectType.contact.isAccessible()){
              con = [select id from contact limit 1];
            }
            mail.setTargetObjectId(con.id);
        }
 
        if(owa != null){
            mail.setOrgWideEmailAddressId(owa.id);
        }
        allmsg.add(mail);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
            if (results[0].success) {
            System.debug('The email was sent successfully.');
            } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        }
    }
}