Public class LeadCreateSendMail{
public Static Void NewLeadCreation(List<Lead> Newlistlead)
    {
    List<LM_SLA__C> LmSLA=[select Send_Notification_Email__c,Lead_Score__c,Channel__c from LM_SLA__C where Send_Notification_Email__c =true];
    
    
    List<Lead> NewLeadList = [Select id, Company,Name,firstname,lastname,Business_Org__c,Lead_Scoring_Combined__c,Ownerid,Source_Desc__c,
                              Description,Billing_Street__c,Accept_By__c,Billing_City__c,Billing_Zip__c,
                              Billing_State__c,Source__c,Phone,Email
                               from Lead where  id IN : Newlistlead limit 1];
    integer i;
     system.debug('&&&NewLeadList' + NewLeadList);
    
  // List<User> = map
   String newOwner;
    
    if(!LmSLA.isEmpty()){
    List<Messaging.SingleEmailMessage> listSingleEmailMessages = new List<Messaging.SingleEmailMessage>();
    
    for(Lead nLead : NewLeadList)
    {
       List<String> toAddresses = new List<String>(); 
            system.debug('***Email: ' + nLead.Ownerid); 
            system.debug('&&&Size' + NewLeadList.Size());     
            system.debug('&&&LM' + LmSLA.Size());             
        for(i=0; i<LmSLA.Size(); i++)
         {
           if(LmSLA[i].Lead_Score__c == nLead.Lead_Scoring_Combined__c && LmSLA[i].Channel__c == nLead.Business_Org__c)
           {
           toAddresses.add(nLead.Ownerid);
           newOwner=nLead.Ownerid;
           }
         }
         
         system.debug('***Address: ' + toAddresses);
         if(!toAddresses.isEmpty())
         {
           OrgWideEmailAddress[] owea;
                    //Get the OrgWideEmailAddress to use as the From email address
                 owea = [select Id from OrgWideEmailAddress where address = 'tlr.miscrmoperations@thomsonreuters.com'];
         
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          string sLink = System.URL.getSalesforceBaseUrl().toExternalForm() + '/'+ nLead.Id; 
                    if (owea.size() > 0) {
                         mail.setOrgWideEmailAddressId(owea.get(0).Id); 
                         system.debug('***OrgWideaddress: ' + owea.get(0).Id);          
                     }  
                     if(newOwner.substring(0,3)=='005')
                     {
                     mail.setToAddresses(toAddresses);       
                    mail.setSaveAsActivity(false);
                    mail.setSubject('Alert - Lead ' + nLead.name+ ' Has Been Assigned to You');  
                     mail.setHtmlBody('Please be aware that the following Lead has been created and assigned to you.' +
                        '<p>Account : ' + nLead.Company + 
                        '<p>Contact: ' + nLead.firstname +'  '+nLead.lastname + 
                        '<p>Description: ' + nLead.Description + 
                        '<p>Accept By: ' + nLead.Accept_By__C+ 
                        '<p>Lead Score: ' + nLead.Lead_Scoring_Combined__c+ 
                        '<p>Source Type: ' + nLead.Source__c+ 
                        '<p>Source Description: ' + nLead.Source_Desc__c+ 
                        '<p>Phone: ' + nLead.Phone+ 
                        '<p>Email: ' + nLead.Email+ 
                        '<p>Address: ' + nLead.Billing_Street__c+'<br>' +nLead.Billing_City__c+' '+nLead.Billing_Zip__c+ '<br>' + nLead.Billing_State__c+                        
                         '<p>You can access Lead ' + nLead.Name + ' directly by clicking <a href="' + sLink + '">here</a>');
                    listSingleEmailMessages.add(mail); 
                  }
                 if(newOwner.substring(0,3)=='00G')
                     {
                    
                   //  List<groupmember> GroupMembers = [select id,userorgroupid from groupmember where groupid=:newOwner];
                   List<String> QueueAddresses = new List<String>(); 
                     
                   String email1= [select email from group where id=:newOwner limit 1].email;
                   if(email1!=Null)
                   {
                   QueueAddresses.add(email1);
                   system.debug('***QueueAddresses : ' + QueueAddresses );  
                   system.debug('***Size:++++ ' + QueueAddresses.size());        
                    mail.setToAddresses(QueueAddresses);
                    mail.setSaveAsActivity(false);
                    mail.setSubject('Alert - Lead ' + nLead.name+ ' Has Been Assigned to You');  
                     mail.setHtmlBody('Please be aware that the following Lead has been created and assigned to you.' +
                        '<p>Account : ' + nLead.Company + 
                        '<p>Contact: ' + nLead.firstname +'  '+nLead.lastname + 
                        '<p>Description: ' + nLead.Description + 
                        '<p>Accept By: ' + nLead.Accept_By__C+ 
                        '<p>Lead Score: ' + nLead.Lead_Scoring_Combined__c+ 
                        '<p>Source Type: ' + nLead.Source__c+ 
                        '<p>Source Description: ' + nLead.Source_Desc__c+ 
                        '<p>Phone: ' + nLead.Phone+ 
                        '<p>Email: ' + nLead.Email+ 
                        '<p>Address: ' + nLead.Billing_Street__c+ '<br>' +nLead.Billing_City__c+' '+nLead.Billing_Zip__c+ '<br>' + nLead.Billing_State__c+                        
                         '<p>You can access Lead ' + nLead.Name + ' directly by clicking <a href="' + sLink + '">here</a>');
                    listSingleEmailMessages.add(mail); 
                    }
                    list<group> id= [select id from group where id=:newOwner and DoesSendEmailToMembers =:true limit 1];
                    if(!id.isEmpty())
                    {
                      List<groupmember> Groupmember = [select id,userorgroupid from groupmember where groupid=:id];
                      for (groupmember newmember :Groupmember)
                      {
                      QueueAddresses.add(newmember.userorgroupid);
                      mail.setToAddresses(QueueAddresses);
                      mail.setSaveAsActivity(false);
                      system.debug('***Size:++++ ' + QueueAddresses);        
                      mail.setSubject('Alert - Lead ' + nLead.name+ ' Has Been Assigned to You');  
                      mail.setHtmlBody('Please be aware that the following Lead has been created and assigned to you.' +
                        '<p>Account : ' + nLead.Company + 
                        '<p>Contat: ' + nLead.firstname +'  '+nLead.lastname + 
                        '<p>Description: ' + nLead.Description + 
                        '<p>Accept By: ' + nLead.Accept_By__C+ 
                        '<p>Lead Score: ' + nLead.Lead_Scoring_Combined__c+ 
                        '<p>Source Type: ' + nLead.Source__c+ 
                        '<p>Source Description: ' + nLead.Source_Desc__c+ 
                        '<p>Phone: ' + nLead.Phone+ 
                        '<p>Email: ' + nLead.Email+ 
                        '<p>Address: ' + nLead.Billing_Street__c+ '<br>' +nLead.Billing_City__c+' '+nLead.Billing_Zip__c+ '<br>' + nLead.Billing_State__c+                        
                         '<p>You can access Lead ' + nLead.Name + ' directly by clicking <a href="' + sLink + '">here</a>');
                         listSingleEmailMessages.add(mail); 
                      }
                    }
                    
                  }
                }
              }              
                   if (!listSingleEmailMessages.isEmpty()) {
                Messaging.sendEmail(listSingleEmailMessages);
                system.debug('***listSingleEmailMessages: ' + listSingleEmailMessages.size());  
                 } 
              }  
           }    
      }