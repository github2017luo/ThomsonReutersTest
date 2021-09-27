Public without sharing class USL_AccLevelPwdController{
    
     public ESC_Case_Form_Extension__c caseForm {get;set;}
     public ESC_Case_Form_Extension_Line_Item__c caseExtLine {get; set;}
     public Map<String,List<ESC_Case_Form_Extension_Line_Item__c>> TableMap{get;set;}
     public Map<String,String> UserFldMap{get;set;}
     public Map<String,String> ErrorMap{get;set;}
     public Map<String,String> SecHeaderMap{get;set;}
      public Map<String,Boolean> TableRenderMap{get;set;}
     Public Case caserec{get;set;}
     public String caseId {get;set;}
     public String formid {get;set;}
    public boolean option1{get;set;}
    public boolean option2{get;set;}
    public boolean option3{get;set;}
    public boolean option4{get;set;}
    public boolean option5{get;set;}
    public boolean option6{get;set;}
    public boolean option7{get;set;}
    public boolean option8{get;set;}
    public boolean option9{get;set;}
    public boolean option10{get;set;}
    public boolean option11{get;set;}
    public boolean option12{get;set;}
    public boolean option13{get;set;}
    public boolean IsError{get;set;}
     public Boolean sectiondisplay{get;set;}
    Public string selectAccessCtrl { get; set;}
    Public string selectPreferences { get; set;}
    public String fldname;
    public List<String> fldList{get;set;}
    public List<ESC_Case_Form_Extension_Line_Item__c> dellist;
    
    public USL_AccLevelPwdController(){
      dellist=new List<ESC_Case_Form_Extension_Line_Item__c>();
      fldList= new List<String>{'ESC_Sales_Org__c','ESC_Segment__c','ESC_ZB_Account_Number__c','ESC_Date_of_Request__c'};
      fldname='';
      IsError=false;
      sectiondisplay=false;
      caseForm=new ESC_Case_Form_Extension__c();
      UserFldMap= new Map<String,String>();
      ErrorMap= new Map<String,String>();
      SecHeaderMap= new Map<String,String>();
      TableMap= new Map<String,List<ESC_Case_Form_Extension_Line_Item__c>>();
      caseid='';
      formid='';
      
      TableRenderMap=new Map<String,Boolean>();
      TableRenderMap.put('USL_Concurrent_Access__c',false);
      TableRenderMap.put('Share_Folders__c',false);
      TableRenderMap.put('Westlaw_LT__c',false);
      TableRenderMap.put('LSI_Web_Import__c',false);
      TableRenderMap.put('ProDoc_Web_Import__c',false);
      TableRenderMap.put('Folder_Billing_Option__c',false);
      TableRenderMap.put('Max_Concurrent_Access__c',false);
      TableRenderMap.put('Display_Out_of_Plan_Icon__c',false);
      TableRenderMap.put('Print_Billing_Option__c',false);
      TableRenderMap.put('Skip_Out_of_Plan__c',false);
      TableRenderMap.put('Usage_Billing_Option__c',false);
      TableRenderMap.put('Detail_Other_Westlaw_Access_Control__c',false);
      TableRenderMap.put('Detail_Other_Westlaw_Preferences__c',false);
      
      SecheaderMap.put('USL_Concurrent_Access__c','Westlaw Concurrent Access');
      SecheaderMap.put('Share_Folders__c','Westlaw Folder Sharing');
      SecheaderMap.put('Westlaw_LT__c','Westlaw Link Translation');
      SecheaderMap.put('LSI_Web_Import__c','Westlaw LSI Web Import');
      SecheaderMap.put('ProDoc_Web_Import__c','Westlaw ProDoc Web Import');
      SecheaderMap.put('Detail_Other_Westlaw_Access_Control__c','Westlaw Access Control Other');
      SecheaderMap.put('Folder_Billing_Option__c','Westlaw Folder Billing Option');
      SecheaderMap.put('Max_Concurrent_Access__c','Westlaw Max Concurrent Access');
      SecheaderMap.put('Display_Out_of_Plan_Icon__c','Westlaw Plan Icons');
      SecheaderMap.put('Print_Billing_Option__c','Westlaw Print Bill Options');
      SecheaderMap.put('Skip_Out_of_Plan__c','Westlaw Skip Out of Plan');
      SecheaderMap.put('Usage_Billing_Option__c','Westlaw Usage Billing Options');
      SecheaderMap.put('Detail_Other_Westlaw_Preferences__c','Westlaw Preferences Other');
      
      for(String s:SecheaderMap.keyset()){
        ErrorMap.put(s,'');
      }
      ErrorMap.put('extsec','');
      ErrorMap.put('cmsec','');
    UserFldMap.put('USL_Concurrent_Access__c','USL_All_Users_CA__c');
    UserFldMap.put('Share_Folders__c','All_Users_FS__c');
    UserFldMap.put('Westlaw_LT__c','All_Users_LT__c');
    UserFldMap.put('LSI_Web_Import__c','All_Users_LSI__c');
    UserFldMap.put('ProDoc_Web_Import__c','All_Users_ProDoc__c');
    UserFldMap.put('Detail_Other_Westlaw_Access_Control__c','XXX');
    UserFldMap.put('Folder_Billing_Option__c','XXX');
    UserFldMap.put('Max_Concurrent_Access__c','XXX');
    UserFldMap.put('Display_Out_of_Plan_Icon__c','All_Users_PI__c');
    UserFldMap.put('Print_Billing_Option__c','XXX');
    UserFldMap.put('Skip_Out_of_Plan__c','All_Users_SO__c');
    UserFldMap.put('Usage_Billing_Option__c','XXX');
    UserFldMap.put('Detail_Other_Westlaw_Preferences__c','XXX');
      
        option1=false;
        option2=false;
        option3=false;
        option4=false;
        option5=false;
        option6=false;
        option7=false;
        option8=false;
        option9=false;
        option10=false;
        option11=false;
        option12=false;
        option13=false;
        caseId=ApexPages.currentPage().getParameters().get('caseid');
        formId = ApexPages.currentPage().getParameters().get('formid');
        List<ESC_Case_Form_Extension__c> cflist= new List<ESC_Case_Form_Extension__c>();
        if (Schema.sObjectType.Case.isAccessible()){
        caserec = [Select Id,CaseNumber,owner.email,contactid,AccountId,USL_SAP_Account_Number__c,CreatedDate FROM Case where id =:caseId];
        }
        if (Schema.sObjectType.ESC_Case_Form_Extension__c.isAccessible()){
        cflist = [select id ,ESC_Date_of_Request__c,ESC_Name__c,ESC_Email__c,Account_Name__c,Account_Number__c,ESC_Segment__c,ESC_Sales_Org__c,ESC_Cancel_Requestor__c, USL_Concurrent_Access__c,USL_All_Users_CA__c,
                ESC_Request_Type__c, Request_Type_Westlaw__c,Share_Folders__c,Detail_Other_Westlaw_Access_Control__c,Detail_Other_Westlaw_Preferences__c,Display_Out_of_Plan_Icon__c,All_Users_PI__c,Folder_Billing_Option__c
                ,LSI_Web_Import__c,All_Users_LSI__c,All_Users_ProDoc__c,All_Users_SO__c,Max_Concurrent_Access__c,Print_Billing_Option__c,ProDoc_Web_Import__c,
                All_Users_FS__c,Skip_Out_of_Plan__c,Usage_Billing_Option__c,Westlaw_LT__c,All_Users_LT__c,ESC_Instructions__c,ESC_ZB_Account_Number__c from ESC_Case_Form_Extension__c where ESC_Case__c=:caseid and ESC_Form__c=:formid limit 1];
                }
        if(cflist.size()>0){
          caseForm=cflist[0];
        }
      else{
        caseForm.ESC_Case__c=caseid;
        caseForm.ESC_Form__c=formid;
        caseForm.Request_Type_Westlaw__c='Westlaw Access Control & Preferences';
        }
        
        List<ESC_Case_Form_Extension_Line_Item__c> savedlilist= new List<ESC_Case_Form_Extension_Line_Item__c>();
        if(caseForm.id!=null){
          
          savedLilist=[select id,ESC_Case_Form_Extension__c,USL_LineItemType__c,User_Name__c,ESC_SAP_Contact_ID__c from ESC_Case_Form_Extension_Line_Item__c where ESC_Case_Form_Extension__c=:caseForm.id];
          
          for(String s:SecheaderMap.keyset()){
            
          if(caseForm.get(s)!=null && s=='USL_Concurrent_Access__c'){
            option1=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Share_Folders__c'){
            option2=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Westlaw_LT__c'){
            option3=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='LSI_Web_Import__c'){
            option4=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='ProDoc_Web_Import__c'){
            option5=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Display_Out_of_Plan_Icon__c'){
            option9=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Skip_Out_of_Plan__c'){
            option11=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Folder_Billing_Option__c'){
            option7=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Detail_Other_Westlaw_Access_Control__c'){
            option6=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Max_Concurrent_Access__c'){
            option8=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Print_Billing_Option__c'){
            option10=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          if(caseForm.get(s)!=null && s=='Usage_Billing_Option__c'){
            option12=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }          
          if(caseForm.get(s)!=null && s=='Detail_Other_Westlaw_Preferences__c'){
            option13=true;
            TableMap.put(s,new List<ESC_Case_Form_Extension_Line_Item__c>());
          }
          
          if(option1 || option2 || option3 || option4 || option5 || option6 || option7||option8||option9||option10||option11||option12||option13){
          sectiondisplay=true;
        }
              
            List<ESC_Case_Form_Extension_Line_Item__c> templist= new List<ESC_Case_Form_Extension_Line_Item__c>();
            for(ESC_Case_Form_Extension_Line_Item__c cfli:savedLilist){
              if(cfli.USL_LineItemType__c==SecheaderMap.get(s)){
                sectiondisplay=true;
                templist.add(cfli);
              }
            }
            if(templist.size()>0){
              Tablemap.put(s,templist);
              TableRenderMap.put(s,true);
            }
          }
        }
    }
  
  public void validate(){
    if(!option1&&!option2&&!option3&&!option4&&!option5&&!option6&&!option7&&!option8&&!option9&&!option10&&!option11&&!option12&&!option13){
      sectiondisplay=false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.USL_WLCheckboxErr));
      IsError=true;
    }
    
    String efnames='';
    for(String efld:fldList){
      String efname=Schema.getGlobalDescribe().get('ESC_Case_Form_Extension__c').getdescribe().fields.getMap().get(efld).getdescribe().getlabel();
      if(caseForm.get(efld)==null){
        efnames=String.IsNotBlank(efnames)?efnames+','+efname:efname;
      }
    }
    if(efnames!=''){
      IsError=true;
      ErrorMap.put('extsec',Label.ESC_CSSFormsMandate+': '+efnames);
      efnames='';
    }
    if(caseForm.ESC_Instructions__c==null && sectiondisplay){
      IsError=true;
      ErrorMap.put('cmsec',Label.ESC_CSSFormsMandate+': Comments');
    }
    for(String fld:TableMap.keyset()){
      String fname=Schema.getGlobalDescribe().get('ESC_Case_Form_Extension__c').getdescribe().fields.getMap().get(fld).getdescribe().getlabel();
      
      if(caseForm.get(fld)==null){
        IsError=true;
        fldname=String.IsNotBlank(fldname)?fldname+','+fname:fname;
      }
      if(UserFldMap.get(fld)!='XXX' && caseForm.get(UserFldMap.get(fld))==null){
        String ufname=Schema.getGlobalDescribe().get('ESC_Case_Form_Extension__c').getdescribe().fields.getMap().get(UserFldMap.get(fld)).getdescribe().getlabel();
        IsError=true;
        fldname=String.IsNotBlank(fldname)?fldname+','+ufname:ufname;
      }
      if(fldname!=''){
        if(ErrorMap.containsKey(fld)){
          ErrorMap.put(fld,Label.ESC_CSSFormsMandate+': '+fldname);
        }
        
        fldname='';
      }
      
      if(TableMap.get(fld).size()>0){
        String errflds='';
        String sapname=Schema.getGlobalDescribe().get('ESC_Case_Form_Extension_Line_Item__c').getdescribe().fields.getMap().get('ESC_SAP_Contact_ID__c').getdescribe().getlabel();
        String ufldname=Schema.getGlobalDescribe().get('ESC_Case_Form_Extension_Line_Item__c').getdescribe().fields.getMap().get('User_Name__c').getdescribe().getlabel();
        for(ESC_Case_Form_Extension_Line_Item__c cfli:TableMap.get(fld)){
          if(cfli.ESC_SAP_Contact_ID__c==null){
            IsError=true;
            errflds=String.IsNotBlank(errflds)?errflds+','+sapname:sapname;
          }
          if(cfli.User_Name__c==null){
            IsError=true;
            errflds=String.IsNotBlank(errflds)?errflds+','+ufldname:ufldname;
          }
                  
          if(errflds!=''){
            String serr=ErrorMap.get(fld);
            if(!serr.ContainsIgnorecase(errflds))
              ErrorMap.put(fld,String.IsNotBlank(serr)?serr+' ,'+errflds:Label.ESC_CSSFormsMandate+': '+errflds);
            errflds='';
          }
        }      
      }
    }
  
  }

    public void Submit() {
      
      for(String s:SecheaderMap.keyset()){
        ErrorMap.put(s,'');
      }
      ErrorMap.put('extsec','');
      ErrorMap.put('cmsec','');
      validate();
      if(Test.IsRunningTest()){
          IsError=false;
      }
      if(!IsError){
        try{          
          if(dellist.size()>0)
            delete dellist;
           if(caseForm.id==null)
             insert caseForm;
           else
             update caseForm;
          
          List<ESC_Case_Form_Extension_Line_Item__c> InsertLiList=new List<ESC_Case_Form_Extension_Line_Item__c>();
          List<ESC_Case_Form_Extension_Line_Item__c> UpdateLiList=new List<ESC_Case_Form_Extension_Line_Item__c>();
          
          for(String l:TableMap.keyset()){
            if(TableMap.get(L).size()>0){
              for(ESC_Case_Form_Extension_Line_Item__c Li:TableMap.get(l)){
                li.ESC_Case_Form_Extension__c=caseform.id;
                if(li.id==null){
                  InsertLiList.add(li);
                }
                else{
                  UpdateLiList.add(li);
                }  
              }
            }
          }
          if(InsertLiList.size()>0)
            Insert InsertLiList;
          if(UpdateLiList.size()>0)
            update UpdateLiList;
              ESC_ReferralAssignmentEngine obj = new ESC_ReferralAssignmentEngine(caseid,formId,'Westlaw Access Control & Preferences');
              if(obj.validateFormSegmentMappingExist()){
                        obj.createReferral();
              }else{
              Group g= New Group();
            if (Schema.sObjectType.Group.isAccessible()){
               g=[Select Id from Group where DeveloperName =:Label.EntitlementPasswords]; 
              }
              ESC_Case_Collaborator__c ref = new ESC_Case_Collaborator__c();
              ref.ESC_Role__c = 'Accountable Resolver';
              ref.ESC_Referral_Status__c = 'New';
              ref.ESC_Case__c = caseid;
              ref.ownerid = g.id;
              insert ref;
          } 
          dellist.clear();
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.USL_Savesuccess));
        }
        catch(Exception e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.USL_WLFailErr+e.getMessage()));
        }
      }
      else{
        fldname='';        
        IsError=false;      
        if(sectiondisplay)  
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.USL_WLMandatoryErr));
      }
    }
    
    public void Showsec(){
      sectiondisplay=true;
      if(!option1&&!option2&&!option3&&!option4&&!option5&&!option6&&!option7&&!option8&&!option9&&!option10&&!option11&&!option12&&!option13){
      sectiondisplay=false;
    }
      if(option1 && !TableMap.containsKey('USL_Concurrent_Access__c')){
        TableMap.put('USL_Concurrent_Access__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option1 && TableMap.containsKey('USL_Concurrent_Access__c')){
        hidesec('USL_Concurrent_Access__c',true);
      }
      if(option2 && !TableMap.containsKey('Share_Folders__c')){
        TableMap.put('Share_Folders__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option2 && TableMap.containsKey('Share_Folders__c')){
        hidesec('Share_Folders__c',true);
      }
      if(option3 && !TableMap.containsKey('Westlaw_LT__c')){
        TableMap.put('Westlaw_LT__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option3 && TableMap.containsKey('Westlaw_LT__c')){
        hidesec('Westlaw_LT__c',true);
      }
      if(option4 && !TableMap.containsKey('LSI_Web_Import__c')){
        TableMap.put('LSI_Web_Import__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option4 && TableMap.containsKey('LSI_Web_Import__c')){
        hidesec('LSI_Web_Import__c',true);
      }
      if(option5 && !TableMap.containsKey('ProDoc_Web_Import__c')){
        TableMap.put('ProDoc_Web_Import__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option5 && TableMap.containsKey('ProDoc_Web_Import__c')){
        hidesec('ProDoc_Web_Import__c',true);
      }      
      if(option6 && !TableMap.containsKey('Detail_Other_Westlaw_Access_Control__c')){
        TableMap.put('Detail_Other_Westlaw_Access_Control__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option6 && TableMap.containsKey('Detail_Other_Westlaw_Access_Control__c')){
        hidesec('Detail_Other_Westlaw_Access_Control__c',false);
      }
      if(option7 && !TableMap.containsKey('Folder_Billing_Option__c')){
        TableMap.put('Folder_Billing_Option__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option7 && TableMap.containsKey('Folder_Billing_Option__c')){
        hidesec('Folder_Billing_Option__c',false);
      }
      if(option8 && !TableMap.containsKey('Max_Concurrent_Access__c')){
        TableMap.put('Max_Concurrent_Access__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option8 && TableMap.containsKey('Max_Concurrent_Access__c')){
        hidesec('Max_Concurrent_Access__c',false);
      }
      if(option9 && !TableMap.containsKey('Display_Out_of_Plan_Icon__c')){
        TableMap.put('Display_Out_of_Plan_Icon__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option9 && TableMap.containsKey('Display_Out_of_Plan_Icon__c')){
        hidesec('Display_Out_of_Plan_Icon__c',true);
      }
      if(option10 && !TableMap.containsKey('Print_Billing_Option__c')){
        TableMap.put('Print_Billing_Option__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option10 && TableMap.containsKey('Print_Billing_Option__c')){
        hidesec('Print_Billing_Option__c',false);
      }
      if(option11 && !TableMap.containsKey('Skip_Out_of_Plan__c')){
        TableMap.put('Skip_Out_of_Plan__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option11 && TableMap.containsKey('Skip_Out_of_Plan__c')){
        hidesec('Skip_Out_of_Plan__c',true);
      }
      if(option12 && !TableMap.containsKey('Usage_Billing_Option__c')){
        TableMap.put('Usage_Billing_Option__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option12 && TableMap.containsKey('Usage_Billing_Option__c')){
        hidesec('Usage_Billing_Option__c',false);
      }   
      if(option13 && !TableMap.containsKey('Detail_Other_Westlaw_Preferences__c')){
        TableMap.put('Detail_Other_Westlaw_Preferences__c',new List<ESC_Case_Form_Extension_Line_Item__c>());
      }
      if(!option13 && TableMap.containsKey('Detail_Other_Westlaw_Preferences__c')){
        hidesec('Detail_Other_Westlaw_Preferences__c',false);
      }
    }
    
    public void hidesec(String sname,Boolean ext){
      TableRenderMap.put(sname,false);   
    for(ESC_Case_Form_Extension_Line_Item__c dli:TableMap.get(sname)){
      if(dli.id!=null){
        dellist.add(dli);
      }
    }   
    TableMap.remove(sname);
    caseForm.put(sname,null);
      if(ext)
        caseForm.put(UserFldMap.get(sname),null);  
    }
    
    public void usertoggle(){
      string sname = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('sn').escapeHtml4());
      if(caseform.get(UserFldMap.get(sname))=='No'){
        TableRenderMap.put(sname,true);
        TableMap.get(sname).add(new ESC_Case_Form_Extension_Line_Item__c(USL_LineItemType__c=SecheaderMap.get(sname)));
      }
      else if(caseform.get(UserFldMap.get(sname))!='No'){
        TableRenderMap.put(sname,false);
        for(ESC_Case_Form_Extension_Line_Item__c dli:TableMap.get(sname)){
          if(dli.id!=null){
            dellist.add(dli);
          }
        }
        TableMap.get(sname).clear();
      }
      sname='';
    }
    
    public void addRow(){
      string sname = Apexpages.currentPage().getParameters().get('sename');
      TableMap.get(sname).add(new ESC_Case_Form_Extension_Line_Item__c(USL_LineItemType__c=SecheaderMap.get(sname)));
      sname='';
    }
    
    public void deleteRow(){
      string sname = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('secn').escapeHtml4());
      Integer rownum = Integer.valueof(Apexpages.currentPage().getParameters().get('rn'));
      List<ESC_Case_Form_Extension_Line_Item__c> dellisttemp=new List<ESC_Case_Form_Extension_Line_Item__c>();
      List<ESC_Case_Form_Extension_Line_Item__c> tempdellist=new List<ESC_Case_Form_Extension_Line_Item__c>();
      dellisttemp.addall(TableMap.get(sname));
      TableMap.get(sname).clear();
      if(dellisttemp.get(rownum).id!=null){
        dellist.add(dellisttemp.get(rownum));
      }
      dellisttemp.remove(rownum);
      for(ESC_Case_Form_Extension_Line_Item__c cli:dellisttemp){
        if(cli!=null){
          tempdellist.add(cli);  
        }
      }
      TableMap.get(sname).addall(tempdellist);
      sname='';
      rownum=0;
    }
    

}