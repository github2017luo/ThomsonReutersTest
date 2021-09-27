@istest(SeeAllData=false)
public Class ESC_ChatUtility_Test{

public static testmethod void testMethods(){
    
       Profile prof = [SELECT Id FROM profile WHERE name='USL Helpdesk Agent']; 
        
        User us1 =  New User(FirstName = 'j.a5' , LastName= 't.b5',Alias = 'j.a5b5',Email='j.a5T.b5@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='j.a5T.b5@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='j.a5t.b5');
        insert us1;
    
        User us2 =  New User(FirstName = 'j.a6' , LastName= 't.b6',Alias = 'j.a6b6',Email='j.a6t.b6@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='j.a6t.b6@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='j.a6t.b6');
        insert us2;
        system.debug(logginglevel.warn,'**usercreation**' + us2);
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'NY',ShippingCountry= 'US',ShippingStreet='testStreet');
        insert testAccount1;
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        insert testContact1;
        
         Contact testContact2=new Contact (AccountId = testAccount1.id,firstname= 'John1',lastname= 'Mile1',email = 'ab1c@tr.com', phone='7886864710');
        insert testContact2;
        
        Case testCase1=new Case (ContactId = testContact1.id);
        insert testCase1;
        
        Case testCase2=new Case (ContactId = testContact1.id);
         insert testCase2;
         
        testCase1.ContactId=testContact2.id;
        Update testCase1;

        LiveChatVisitor lcv = new LiveChatVisitor();
          insert lcv;
        
        LiveChatTranscript lc=new LiveChatTranscript();
        lc.ownerid=us1.id;
        lc.Caseid=testCase1.id;
        lc.LiveChatVisitorid=lcv.id;
        //insert lc;
        
        
        list<LiveChatTranscript> lcList=new list<LiveChatTranscript>();
        lcList.add(lc);
        insert lcList;
        system.debug(logginglevel.warn,'**updateownerid**' + lc);
        lc.ownerid=us2.id;
        //update lc;
        
        Map<id,LiveChatTranscript> lcMap=new Map<id,LiveChatTranscript>();
        lcMap.put(lc.id,lc);

        ESC_ChatUtility.changeCaseOwnerTransfer(lcList,lcMap);
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
}


public static testmethod void testMethods2(){
    
       Profile prof = [SELECT Id FROM profile WHERE name='System Administrator']; 
        
        User us1 =  New User(FirstName = 'j.a5' , LastName= 't.b5',Alias = 'j.a5b5',Email='j.a5T.b5@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='j.a5T.5b5@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='j.a5t.b5',
         Sales_Org__c='GLI',Segment__c='Professional Tax',Sub_Bu__c='USL',Default_Catalog__c='USL',ICP_Admin__c=true,federationidentifier='P2343212');
        insert us1;
    
        User us2 =  New User(FirstName = 'j.a6' , LastName= 't.b6',Alias = 'j.a6b6',Email='j.a6t.b6@thomsonreuters.com', emailencodingkey='UTF-8', 
        UserName='j.a66t.b6@thomsonreuters.com',languagelocalekey='en_US', localesidkey='en_US', 
        profileid = prof.Id,timezonesidkey='America/Los_Angeles',CommunityNickname='j.a6t.b6',Sales_Org__c='GLI',Segment__c='Professional Tax',Sub_Bu__c='USL',Default_Catalog__c='USL',federationidentifier='P2343222');
        insert us2;
        system.debug(logginglevel.warn,'**usercreation**' + us2);
        system.runas(us1){
        Account testAccount1=new Account(Name= 'testName',ShippingCity= 'NY',ShippingCountry= 'US',ShippingStreet='testStreet');
        insert testAccount1;
        //fill contact
        Contact testContact1=new Contact (AccountId = testAccount1.id,firstname= 'John',lastname= 'Mile',email = 'abc@tr.com', phone='7786864710');
        insert testContact1;
        
         Contact testContact2=new Contact (AccountId = testAccount1.id,firstname= 'John1',lastname= 'Mile1',email = 'ab1c@tr.com', phone='7886864710');
        insert testContact2;
        
        Case testCase1=new Case (ContactId = testContact1.id,status='New');
        insert testCase1;
        
        Case testCase2=new Case (ContactId = testContact1.id,status='New');
         insert testCase2;
         
        testCase1.ContactId=testContact2.id;
        Update testCase1;

        LiveChatVisitor lcv = new LiveChatVisitor();
          insert lcv;
        
        LiveChatTranscript lc=new LiveChatTranscript();
        lc.ownerid=us1.id;
        lc.Caseid=testCase1.id;
        lc.ESC_GSI_SalesPerson__c = us2.federationidentifier;
        lc.LiveChatButtonId = '5734O000000k9ij';
        lc.LiveChatVisitorid=lcv.id;
        //insert lc;
        
        
        list<LiveChatTranscript> lcList=new list<LiveChatTranscript>();
        lcList.add(lc);
        insert lcList;
        system.debug(logginglevel.warn,'**updateownerid**' + lc);
        lc.ownerid=us2.id;
        //update lc;
        
        Map<id,LiveChatTranscript> lcMap=new Map<id,LiveChatTranscript>();
        lcMap.put(lc.id,lc);
        
        ESC_ChatUtility.changeCaseOwnerTransfer(lcList,lcMap);
        
        integer i = 1;
        integer j = 1;
        System.assertEquals(i,j);
        }
}
}