/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2017-08-07   AjayG                   Added GGO related lists and soql queries
* =============================================================================
*/
/**
 * @description ESC_CaseContactAssociation class
 */
public without sharing class ESC_CaseContactAssociation{
    
    /*
This method will be invoked by Case process builder for Case association to Account/Contact
based on the status of the contact(Cases created by Web2case,Email2Case)
*/
 /**
 * @description getContacttoCaseonCreation method
 * @param cases
 */   
    @InvocableMethod(label='Update Contact on Case' description='Update case')
    public static void getContacttoCaseonCreation(List<Case> cases){
        //Dss-6256 hardcoding removal
        //
        ESC_segment_Region_Lotus__c srl = ESC_segment_Region_Lotus__c.getOrgDefaults();
        //if list is empty lets keep it nothing
        if(cases == null || cases.isEmpty()){
            return;
        }
        List<String> lstemail = new List<String>();
        List<String> gliEmail = new List<String>();
        //  List<String> Lotusemail = new List<String>();
        List<String> buSegment = new List<String>();
        List<String> buRegion = new List<String>();
        List<String> ggoEmail = new List<String>();       
        map<string,List<contact>> mapcon=new Map<string,List<contact>>();
        List<Contact> lstcon=new List<Contact>();
        List<String> lstActTaxType= new List<String>();
        List<String> lstActTaxNum= new List<String>();
        List<Case> lstupdatecase = new List<case>();
        string taxNumbertype='';
        string taxNumber='';
        Boolean nonGLI = false;
        Boolean ggoContact= False;
        
        map<string,List<contact>> preMapcon=new Map<string,List<contact>>();
        List<Contact> lstcon1=new List<Contact>();
        List<Contact> lstcon2=new List<Contact>();
        
        for(Case si:cases){
            system.debug(logginglevel.warn,'supplied email'+si.SuppliedEmail+'@@@'+'is gli is'+si.Is_GLI__c);
            if(si.SuppliedEmail!=null && si.Is_GLI__c){
                gliEmail.add(si.SuppliedEmail);
                if(si.BU_Segment__c!=null && si.LCRM_Sub_Bu__c!=null){
                    buSegment.add(si.BU_Segment__c);
                    buRegion.add(si.LCRM_Sub_Bu__c);
                }
            }
            else if(si.ContactId==null && si.SuppliedEmail!=null && si.LCRM_Sub_BU__c!= null && (si.LCRM_Sub_BU__c!= 'USL'||si.LCRM_Sub_BU__c!= srl.RegionUSLegal__c )&& si.LCRM_Sub_BU__c!='GGO'){
                lstemail.add(si.SuppliedEmail);
                
            }
            
            else if(si.ContactId==null && si.SuppliedEmail!=null && si.LCRM_Sub_BU__c=='GGO' && si.Origin=='Email'){
                lstemail.add(si.SuppliedEmail);
                ggoContact=True;
            }
            else if(si.ContactId==null && si.SuppliedEmail!=null && si.LCRM_Sub_BU__c=='GGO' && si.Origin=='Web'){
                ggoEmail.add(si.SuppliedEmail);
                taxNumbertype=si.Description.substringBetween(Schema.case.fields.GGO_Tax_Number_Type__c.getDescribe().getLabel()+': ','; '+Schema.case.fields.GGO_Tax_Number__c.getDescribe().getLabel());
                taxNumber=si.Description.substringBetween(Schema.case.fields.GGO_Tax_Number__c.getDescribe().getLabel()+': ','; '+Schema.case.fields.SuppliedEmail.getDescribe().getLabel());    
                lstActTaxType.add(taxNumbertype);   
                lstActTaxNum.add(taxNumber);  
                ggoContact=True;
            }
            
        }
        
        if(gliEmail.size()>0 && (buSegment.isEmpty() || buRegion.isEmpty())){
            lstCon = [select Contact_Account_Is_Archived__c,id,ESC_tocContactStatus__c,Contact_Inactive__c,phone,Email,AccountId,LCRM_Is_GLI__c,Account.Sales_Org__c from contact where email IN :gliEmail and LCRM_Is_GLI__c=true and Account.Sales_Org__c='GLI'];
            if(lstcon.size()==0){
                nonGLI=true;
            }
        }
        else if(gliEmail.size()>0 && !buSegment.isEmpty() && !buRegion.isEmpty()){
            system.debug(logginglevel.warn,'buSegment is'+buSegment +'@@@@@'+'buRegion is'+buRegion);

            lstCon2 = [select Contact_Account_Is_Archived__c,id,ESC_tocContactStatus__c,Contact_Inactive__c,phone,Email,AccountId,LCRM_Is_GLI__c,Account.Sales_Org__c from contact where email IN :gliEmail and LCRM_Is_GLI__c=true and Account.Sales_Org__c='GLI'];

            //Start
            for(contact c : lstCon2)
            {
                if(c.email!=null){
                    if(preMapcon.containsKey(c.email)){
                        preMapcon.get(c.email).add(c);
                    }else{
                        preMapcon.put(c.email,new List<Contact>{c});
                    }
                }
            }
            
            List<id> conids = new List<id>();
            
            for(String conEmailId : preMapcon.keySet())
            {
                List<Contact> conEmails = preMapcon.get(conEmailId);
                
                if(conEmails.size() > 1)
                {
                 for(contact con : conEmails){
                    conids.add(con.id);
                    }
                }
                else
                {
                    lstCon.addAll(conEmails);
                }
            }
            
            if(conids.size() > 0 && Schema.sObjectType.contact.isQueryable())
            {
                lstCon1 = [select Contact_Account_Is_Archived__c,id,ESC_tocContactStatus__c,Contact_Inactive__c,phone,Email,AccountId,LCRM_Is_GLI__c,Account.Sales_Org__c from contact where id IN : conids and Account.Bu_Segment__c IN :buSegment and Account.BU_Region__c IN :buRegion];
                lstCon.addAll(lstCon1);
            }
            //End
            
            /*
            if(lstcon.size()>1){
            lstCon = [select Contact_Account_Is_Archived__c,id,ESC_tocContactStatus__c,Contact_Inactive__c,phone,Email,AccountId,LCRM_Is_GLI__c,Account.Sales_Org__c from contact where email IN :gliEmail and Account.Bu_Segment__c IN :buSegment and Account.BU_Region__c IN :buRegion];
            } 
            */
            if(lstcon.size()==0){
                nonGLI=true;
            }
        }
        else if(lstemail.size()>0){
            lstCon2 = [select id,ESC_tocContactStatus__c,Contact_Account_Is_Archived__c,Contact_Inactive__c,phone,Email,AccountId,LCRM_Is_GLI__c from contact where email IN :lstemail];
            lstCon.addAll(lstCon2);  
            system.debug(logginglevel.warn,'ist list'+ lstCon2);         
        }else if(ggoEmail.size()>0){  
            lstCon2 = [select id,ESC_tocContactStatus__c,Contact_Account_Is_Archived__c,Contact_Inactive__c,phone,Email,AccountId,LCRM_Is_GLI__c from contact 
                       where email IN :ggoEmail and Account.Tax_Number_Type__c IN :lstActTaxType and Account.Tax_Number__c IN :lstActTaxNum];
            lstCon.addAll(lstCon2);
        }
        for(Contact c:lstcon){
            if(c.email!=null){
                if(Mapcon.containsKey(c.email)){
                    Mapcon.get(c.email).add(c);
                }else{
                    Mapcon.put(c.email,new List<Contact>{c});
                }
            }
        }
        for(Case c:cases){
            if(mapcon.get(c.SuppliedEmail)!=null){
                //If only 1 contact exists with the email associated to a case,associate to it
                if(mapcon.get(c.SuppliedEmail).size()==1){
                    for(Contact con:mapcon.get(c.SuppliedEmail)){
                        Case cs=new Case();
                        cs.id=c.id; 
                        cs.contactid =con.id;
                        cs.accountid =con.AccountId;
                        lstupdatecase.add(cs);
                    }
                }
                //If more than1 contact exists with the email associated to a case
                else if(mapcon.get(c.SuppliedEmail).size()>1){
                    integer act=0;
                    integer inact=0;
                    // Contact contacts=new Contact();
                    for(Contact con:mapcon.get(c.SuppliedEmail)){
                        If(ggoContact=True)
                        {    if(!con.Contact_Inactive__c && !con.Contact_Account_Is_Archived__c){
                            act++;
                        }else if(con.Contact_Inactive__c || con.Contact_Account_Is_Archived__c){
                            inact++;
                        }
                        }
                        else
                        {
                            if(!con.Contact_Inactive__c){
                                act++;
                            }else if(con.Contact_Inactive__c){
                                inact++;
                            }
                        }
                    }
                    system.debug(logginglevel.warn,'InactveContacts :'+ inact);
                    //If 1 active contact exists with multi inactive, associate active contact to a case
                    if(act==1 && inact>0){
                        for(Contact con:mapcon.get(c.SuppliedEmail)){
                            If(ggoContact=True)
                            {    if(!con.Contact_Inactive__c && !con.Contact_Account_Is_Archived__c){
                                Case cs=new Case();
                                cs.id=c.id; 
                                cs.contactid =con.id;
                                cs.accountid =con.AccountId;
                                lstupdatecase.add(cs);
                            }
                            }
                            else if(!con.Contact_Inactive__c){
                                Case cs=new Case();
                                cs.id=c.id;
                                cs.contactid =con.id;
                                cs.accountid =con.AccountId;
                                lstupdatecase.add(cs);
                            }
                        }
                    }
                    
                    else if(act>1 || inact>1 || nonGLI){
                        //If multi contacts exist with many active contacts then don't associate any contact with a case
                        Case cs=new Case();
                        cs.id=c.id; 
                        cs.contactid = null;
                        cs.accountid = null;    
                        lstupdatecase.add(cs);
                    }
                }
            }
            // Added as part of UKI
            else if(mapcon.get(c.SuppliedEmail)==null && nonGLI){
                Case cs=new Case();
                cs.id=c.id; 
                cs.contactid = null;
                cs.accountid = null;
                lstupdatecase.add(cs);
            }
        }
        if(lstupdatecase.size()>0 && Schema.sObjectType.case.isQueryable()){
            update lstupdatecase;
        }
    }
}