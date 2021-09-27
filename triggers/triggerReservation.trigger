trigger triggerReservation on Reservation__c (before insert, before update, before delete) {
 
    List<Reservation__c> ReservToAddShare = new  List<Reservation__c>();
    List<Reservation__c> ReservToDelShare = new  List<Reservation__c>();

    Set<ID> IdPortalUsers = new Set<ID>(); 
    Map<ID,ID> MapUserAccount = new Map<ID,ID>();
    Map<ID,String> MapUserLatamdept = new Map<Id,String>();
    
    Profile oProfile = new Profile(); 
    oProfile = [Select Id, Name from Profile where Id = :UserInfo.getProfileID()];
 
    /****************************
    INSERT  
    ****************************/
    // Added bu Sreenu
    if(trigger.isInsert){
        if(oProfile.Name == System.Label.Partner_Portal_Profile) {
            for(Reservation__c myReserva : trigger.new){
                if(myReserva.OpportunityReservation__c == false && myReserva.Partner_Portal_User__c == null){
                    myReserva.Partner_Portal_User__c = UserInfo.getUserID();    
                }
            }
        }
    } 
    // Ended by Sreenu     
    
    if(trigger.isInsert){
        for(Reservation__c myReserva : trigger.new){
            if(myReserva.Partner_Portal_User__c != null ){
                IdPortalUsers.add(myReserva.Partner_Portal_User__c);
    
                if ( myReserva.Start_Date__c <= System.today()  && 
                     myReserva.End_Date__c >= System.today() && 
                     myReserva.Active__c){
                    
                    ReservToAddShare.add(myReserva);
                }
            }
            else{
                myReserva.addError('Please select a partner portal user.');
            }
        }
    }

    /****************************
            UPDATE
    ****************************/
    if(trigger.isUpdate){
        ReservationTriggerHandler.mandatePartnerManagerOnApproval(Trigger.new, Trigger.oldMap); // Added by Shovon for SFD-497
        ReservationTriggerHandler.updateOpportunityOnReservationUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);  // Added by Shovon for SFD-497
        
        for(Reservation__c myReserva : trigger.new){
            if(myReserva.Partner_Portal_User__c != null){
                IdPortalUsers.add(myReserva.Partner_Portal_User__c);
                Reservation__c oldReserva  = Trigger.oldMap.get(myReserva.Id);
                //to modify the range
                if( (oldReserva.Start_Date__c != myReserva.Start_Date__c) || 
                    (oldReserva.End_Date__c != myReserva.End_Date__c) ||
                    (oldReserva.Active__c != myReserva.Active__c) ) {
                    if ( myReserva.Start_Date__c <= System.today()  && 
                         myReserva.End_Date__c >= System.today() && 
                         myReserva.Active__c){
                        ReservToAddShare.add(myReserva);
                    }
                    else if(myReserva.OpportunityReservation__c == false){
                        ReservToDelShare.add(myReserva);
                        myReserva.Active__c = false;
                    }
                }
            }
            else{
              myReserva.addError('Please select a partner portal user.');
            }
        }   
    }
    
    /****************************
            DELETE
    ****************************/
    if(trigger.isDelete)
    {
        for(Reservation__c myReserva : trigger.old){
            ReservToDelShare.add(myReserva);
        }
    }

    //Wanted accounts Channels 
    if(trigger.isInsert || trigger.isUpdate){
        List<User> UserAcountsID = new List<User>();
        UserAcountsID = [select id, Contact.AccountID,LatAm_Department__c from User Where id in :IdPortalUsers];
        for(User myUser : UserAcountsID ) {

            MapUserAccount.put(MyUser.Id, MyUser.Contact.AccountID);
            if(MyUser.LatAm_Department__c!=null){
             MapUserLatamdept.put(MyUser.Id,MyUser.LatAm_Department__c);
            }
        }
        for (Reservation__c myReserva :trigger.new)
        {
               if (myReserva.OpportunityReservation__c == false) {
               myReserva.Partner_Account__c = MapUserAccount.get(myReserva.Partner_Portal_User__c);
            }
        // MCL-1854 
        /*   else{
             myReserva.Active__c = true;
            }  */
       } 
    }

    //Process Reservations lists 

    List<AccountShare> Share_Create = new List<AccountShare>();
    List<AccountShare> Shares_Delete = new List<AccountShare>();

    for (Reservation__c myReserva :ReservToAddShare)
    {
            System.debug(MapUserLatamdept+'****MapUserLatamdept****');
            AccountShare ReservaCanal = new AccountShare();
            ReservaCanal.AccountId = myReserva.Account__c ;
            ReservaCanal.UserOrGroupId = myReserva.Partner_Portal_User__c ;
            ReservaCanal.AccountAccessLevel= 'Edit';
            if(MapUserLatamdept.containskey(myReserva.Partner_Portal_User__c) && MapUserLatamdept.get(myReserva.Partner_Portal_User__c) == 'Mastersaf - Canal'){
              ReservaCanal.OpportunityAccessLevel = 'Read';
            }else{
              ReservaCanal.OpportunityAccessLevel = 'Edit';
            }
            ReservaCanal.CaseAccessLevel = 'Edit';
            Share_Create.add(ReservaCanal);
    
    }
    /* IM02315141 fix start*/
    Set<ID> accIDSet = new Set<ID>();
    Set<ID> ppUIDSet = new Set<ID>();
    Set<ID> delResID = new Set<ID>();
    for (Reservation__c myReserva :ReservToDelShare){
        delResID.add(myReserva.ID);
        accIDSet.add(myReserva.Account__c);
        ppUIDSet.add(myReserva.Partner_Portal_User__c);
    }
    Map<String,Integer> exisReserList = new Map<String,Integer>();
    if(!ReservToDelShare.isEmpty()){
        try{
            for(Reservation__c res : [SELECT ID, Account__c, Partner_Portal_User__c, Start_Date__c, End_Date__c FROM Reservation__c WHERE ID NOT IN :delResID AND (Account__c IN :accIDSet OR Partner_Portal_User__c IN :ppUIDSet) AND Active__c=TRUE AND Start_Date__c <= :System.Today() AND End_Date__c >= :System.Today() LIMIT 50000]){
                Integer count = 1;
                if(exisReserList.get(res.Account__c+':'+res.Partner_Portal_User__c)!=null){
                    count = exisReserList.get(res.Account__c+':'+res.Partner_Portal_User__c) + 1;
                }
                exisReserList.put(res.Account__c+':'+res.Partner_Portal_User__c,count);
            }
        }catch(Exception e){}
    }
    /* IM02315141 fix end*/
    
    String sqltxt = '';
    String sqltxt2 = '';
    for (Reservation__c myReserva :ReservToDelShare)
    {       
        if(exisReserList.get(myReserva.Account__c+':'+myReserva.Partner_Portal_User__c)==null || exisReserList.get(myReserva.Account__c+':'+myReserva.Partner_Portal_User__c)<=0){/* IM02315141 fix condition*/
            if(sqltxt!=''){
                sqltxt += ' OR ';   
                sqltxt2 += ' OR ';
            }
            sqltxt += ' ( AccountID = \'' + myReserva.Account__c + '\' and UserOrGroupId = \'' + myReserva.Partner_Portal_User__c + '\' and RowCause = \'Manual\' ) ';
            sqltxt2 += ' ( AccountID = \'' + myReserva.Account__c + '\' and UserOrGroupId = \'' + myReserva.Partner_Portal_User__c + '\' and RowCause = \'ImplicitParent\' ) ';
        }
    }
    
    if(sqltxt!=''){
        Shares_Delete = Database.query('select id from AccountShare where ' + sqltxt);
    }

    //  Add or remove the Shares 
    if (!Share_Create.isEmpty()){
        insert Share_Create;  
    }
    if (!Shares_Delete.isEmpty()){
        delete Shares_Delete; 
    }

    // Add Notice of Open Opportunities
    if(sqltxt2!='' && (trigger.isInsert || trigger.isUpdate)){
        Shares_Delete = Database.query('select id,UserOrGroupId,AccountId from AccountShare where ' + sqltxt2);
        for (Reservation__c myReserva :ReservToDelShare){
            for(AccountShare myShare :Shares_Delete ){
                if( myReserva.Partner_Portal_User__c == myShare.UserOrGroupId && myReserva.Account__c == myShare.AccountId){
                    myReserva.Notes__c = 'The account will remain visible, as it has other collaborations implicit';
                    System.Debug(LoggingLevel.debug , '***************trigRservation - Reservation share with error:' +  Shares_Delete );
                }
            }
        }   
    }
}