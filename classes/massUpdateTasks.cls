public with sharing class massUpdateTasks{

    Public String URLIDs;
    Public List<ID> lTaskSelect= New List<ID>();
    //public String theme{get;set;}
    
    public massUpdateTasks() {
    
        URLIDs=Apexpages.CurrentPage().getParameters().get('IDs');
        lTaskSelect=URLIDs.Split(',');
        
        seletOwner=true;
        owner=true;
        ivOwner=false;
        chkBox=True;
        updateBtn=True;
        this.selvalue='Update all Tasks';
        selTskOwner= New Task();
        lTasks=New List<Task>();
        
        oPagingContacts = new PagingContacts();
        oPagingContacts.Pagesize = 250;
        oPagingContacts.listofTaks= new List<taskWrapper>(); 
        getTask();

    }


    public List<Task> lTasks;
    public List<taskWrapper> wTasks{get;set;}
    public String selvalue{get;set;}
    public Task selTskOwner{get;set;}
    public List<Task> updateTask=New List<Task>();
    public PagingContacts oPagingContacts {get;set;}
    
    //Render Properties
    public Boolean seletOwner{get;set;}
    public Boolean chkBox{get;set;}
    public Boolean owner{get;set;}
    public Boolean ivOwner{get;set;} 
    public Boolean updateBtn{get;set;}
    Public PageReference P;
    public Boolean msgflag{get;set;}
    
    public Integer Nextoffset=0;
    public Integer lmt=1000;
    
    public massUpdateTasks(ApexPages.StandardController controller) {
        URLIDs=Apexpages.CurrentPage().getParameters().get('IDs');
        lTaskSelect=URLIDs.Split(',');
        
        seletOwner=true;
        owner=true;
        ivOwner=false;
        chkBox=True;
        updateBtn=True;
        this.selvalue='Update all Tasks';
        selTskOwner= New Task();
        lTasks=New List<Task>();
        
        oPagingContacts = new PagingContacts();
        oPagingContacts.Pagesize = 250;
        oPagingContacts.listofTaks= new List<taskWrapper>(); 
        getTask();
        
         
    }
    
    public void getTask(){
        oPagingContacts = new PagingContacts();
        Integer temp;
        if(oPagingContacts.pgoffset!=null){
            temp=oPagingContacts.pgoffset;
        }else{
        temp=0;
        }
        
        System.debug(oPagingContacts.Offset+'****');
          if(Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.isQueryable())
        lTasks=[Select Id,OwnerId,whoID,WhatID,Subject,Priority from Task where id in : lTaskSelect ];
        wTasks= New List<taskWrapper>();
        
        if(lTasks.size()>0){
            msgflag=true;
        }else{
            msgflag=false;
        }
        
        for(Task T:lTasks){
            
            wTasks.add(new taskWrapper(t));
        
        }
        oPagingContacts.listofTaks =wTasks;
        oPagingContacts.PageNumber =1; 
    
    }
    
    public void renderfun(){
    
       system.debug('<<select value>>'+selvalue); 
       
          if(selvalue=='Update all Tasks'){
        
            seletOwner=true;
            owner=true;
            ivOwner=false;
            chkBox=true;
            updateBtn=True;
            
        }else if(selvalue=='Update Individual Task'){
            seletOwner=false;
            owner=false;
            ivOwner=true;
            chkBox=false;
            updateBtn=false;
        }
        //return null;
    
    }
    
     public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Update all Tasks','Update all Tasks')); 
        options.add(new SelectOption('Update Individual Task','Update Individual Task')); 
        return options; 
    }
    
    public PageReference UpdateallTasks(){
        Task T= New Task();
        for(taskWrapper tw :wTasks){
        
            if(tw.flag){
                T=tw.st;
                T.OwnerId=selTskOwner.ownerid;
                updateTask.add(T);
            }
        
        }
        
        if(updateTask.size()>0){
            String sUserSubBU = LCRMGenericComponent.getUserBU();
            Boolean bLCRMUserBU = LCRMGenericComponent.validateUserBU(sUserSubBU);
             // modification done as part of lightning.
            if(bLCRMUserBU ){
                 if(UserInfo.getUiThemeDisplayed()=='Theme4d' || UserInfo.getUiThemeDisplayed()=='Theme4t'){
                 P=New PageReference('/lightning/n/Activities');
                }else{
                     P=New PageReference('/apex/LCRMActivitiesPage');
                }
            }else {
            P=New PageReference('/apex/TasksShow');
             }      
              P.setredirect(true);
             try{
              if(Schema.sObjectType.Task.isUpdateable())
            update updateTask; 
            }Catch(Exception ex){
                
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.WARNING,'You do not have permission to reassign the activity record(s) below.Only administrators or supervisors of the activity owner have the right to reassign their activities.');
                ApexPages.addMessage(msg);  
                return null; 
            }
            return P;
        }else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select atleast one Record to update'));  
           return null;
        }   
    
    }
    
    
    
    public PageReference UpdateindualTasks(){
        Task T= New Task();
        for(taskWrapper tw :wTasks){
        
            T=tw.st;
            //T.OwnerId=selTskOwner.ownerid;
            updateTask.add(T);
         
            }
        if(updateTask.size()>0){
            String sUserSubBU = LCRMGenericComponent.getUserBU();
            Boolean bLCRMUserBU = LCRMGenericComponent.validateUserBU(sUserSubBU);
            // modification done as part of lightning.
           
           if(bLCRMUserBU ){
                 if(UserInfo.getUiThemeDisplayed()=='Theme4d' || UserInfo.getUiThemeDisplayed()=='Theme4t'){
                 P=New PageReference('/lightning/n/Activities');
                }else{
                     P=New PageReference('/apex/LCRMActivitiesPage');
                }
            }else {
            P=New PageReference('/apex/TasksShow');
            }   
            update updateTask; 
            return P;
            
        }else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select atleast one Record to update'));  
           return null;
        } 
    
    }
    
    //Added method for cancel functionality in lightning    
   public PageReference cancelBtn(){
    if(UserInfo.getUiThemeDisplayed()=='Theme4d' || UserInfo.getUiThemeDisplayed()=='Theme4t'){
     P=New PageReference('/lightning/n/Activities');
    }else{
    P=New PageReference('/apex/LCRMActivitiesPage');
    } 
    

    P.setRedirect(true);
    return P;              
    }
     
    public class taskWrapper{
    
        public Boolean flag{get;set;}
        public Task st{get;set;}
        
        public taskWrapper(Task t){
            
            this.st=t;
            this.flag=true;
        
        }
    }
    
   //extended pageable class to use pagination on page
     
    public class PagingContacts extends Pageable {
        public List<taskWrapper> listofTaks {get;set;} 
        public Integer pgoffset;      
        public Integer pglimti;
        public PagingContacts(){ 
               this.pgoffset=0;
               this.pglimti=100;
        }
        
        public override integer getRecordCount() {
            return (listofTaks == null ? 0 : listofTaks.size());
        }
        public override void moveNext(){
            pgoffset=pgoffset+50;
            super.moveNext();           
        }        
        public override void movePrev(){
           pgoffset=pgoffset-50;
           super.movePrev();           
        }
    } 
    
    
    ///off set methods
    public void next(){
    Nextoffset=Nextoffset+50;
    getTask();
    }
    
    //Added method to return theme being used by user in lightning
   // public String getContextUserUiThemeDisplayed() {
   //     return UserInfo.getUiThemeDisplayed();
  //  } 
    
    
    public void previous(){
    Nextoffset=Nextoffset+50;
    getTask();
    }
}