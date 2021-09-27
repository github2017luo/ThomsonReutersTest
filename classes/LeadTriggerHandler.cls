public without sharing class LeadTriggerHandler{

    public static boolean inFutureContext = false; 
    public static boolean populateLeadOwnerRecCheck = false;
    public static boolean executeOnce = true; 
    
    public void populateLeadOwner(List<Lead> listLeads){
      Map<Id,String> mapSAPAccountIds = new Map<Id,String>();
      Map<Id,String> mapMDBAccountIds = new Map<Id,String>();
      Map<Id,String> mapRepChannel = new Map<Id,String>();
      List<Lead> leadsToUpd = new List<Lead>();
      List<Lead> leadsToUpdPLC = new List<Lead>();
      List<AccountTeamMember> listAccountTeamMembers = new List<AccountTeamMember>();
      Map<Id,String> mapUserRepType = new Map<Id,String>();
      Map<String,List<Id>> mapAccountUser = new Map<String,List<Id>>();
      Map<String,List<Id>> mapMDBAccountUser = new Map<String,List<Id>>();
      Map<String,String> mapDataTransformationRepType = new Map<String,String>();
      Map<String,String> mapDTLookUpValue = new Map<String,String>();
      Map<Id,String> userToTransdesc =new Map<Id,String>();
      Map<Id,Id> mapAccountLeadOwner = new Map<Id,Id>();
      LIST<Holiday> holidayList;
      

        for(Lead oLead : listLeads){      
           //System.debug(oLead.Is_Web_To_Lead__c+'&&&&&&&');//Commented as part of DPS-19692
           //system.debug('@@@@listLeads@@@@'+listLeads);//Commented as part of DPS-19692
            if(oLead.LeadSource=='Customer Service' && oLead.Is_Web_To_Lead__c==true){
                 if(oLead.SAPAccountNumber__c!=null && oLead.Rep_Channel__c!=null){
                    MapSAPAccountIds.put(oLead.Id,oLead.SAPAccountNumber__c);
                    MapRepChannel.put(oLead.Id,oLead.Rep_Channel__c);
                    LeadsToUpd.add(oLead);
              }
            }
             
            if(oLead.LeadSource=='Website' && oLead.Is_Web_to_PPO__c==true && oLead.Is_Web_To_Lead__c==true){
              if(oLead.MDBID__c!=null && oLead.Rep_Channel__c!=null){
                MapMDBAccountIds.put(oLead.Id,oLead.MDBID__c);
                MapRepChannel.put(oLead.Id,oLead.Rep_Channel__c);
                LeadsToUpdPLC.add(oLead);
               }
            }
            
        }
        
         
         
          

if(Schema.sObjectType.AccountTeamMember.isAccessible())  {
        listAccountTeamMembers = [Select Account.SAPAccountNumber__c,Account.MDBID__c,UserId,User.Rep_Type_Description__c from AccountTeamMember
                                   where Account.SAPAccountNumber__c IN : MapSAPAccountIds.values() OR Account.MDBID__c IN : MapMDBAccountIds.values()];
}      
       //system.debug('@@@@listAccountTeamMembers@@@@'+listAccountTeamMembers);//Commented as part of DPS-19692
        for(AccountTeamMember oAccTeamMem : listAccountTeamMembers){
            mapUserRepType.put(oAccTeamMem.UserId,oAccTeamMem.User.Rep_Type_Description__c);
            
            if(oAccTeamMem.Account.SAPAccountNumber__c!=null){
                if(MapAccountUser.containsKey(oAccTeamMem.Account.SAPAccountNumber__c)){
                  MapAccountUser.get(oAccTeamMem.Account.SAPAccountNumber__c).add(oAccTeamMem.UserId);
                }else{
                    List<Id> listUserIds = new List<Id>();
                    ListUserIds.add(oAccTeamMem.UserId);
                    MapAccountUser.put(oAccTeamMem.Account.SAPAccountNumber__c,ListUserIds);
                
                }
            }
            
            if(oAccTeamMem.Account.MDBID__c!=null){
             if(MapMDBAccountUser.containsKey(oAccTeamMem.Account.MDBID__c)){
                  MapMDBAccountUser.get(oAccTeamMem.Account.MDBID__c).add(oAccTeamMem.UserId);
                }else{
                    List<Id> listUserIds = new List<Id>();
                    ListUserIds.add(oAccTeamMem.UserId);
                    MapMDBAccountUser.put(oAccTeamMem.Account.MDBID__c,ListUserIds);
                
                }
            }
        }
        
       List<Data_Transformation__c> listDataTrans = new List<Data_Transformation__c>();
       if(Schema.sObjectType.Data_Transformation__c.isAccessible()){
       listDataTrans = [Select Return_Value__c,Transformation_Description__c,Lookup_Value__c from Data_Transformation__c where Return_Value__c IN : mapUserRepType.values() 
                        and Source__c = 'Unica Opty Owner' and Lookup_Value__c  IN:MapRepChannel.values() order by Transformation_Description__c asc];
       }
       for(Data_Transformation__c oDT : listDataTrans){
            if(!MapDataTransformationRepType.containsKey(oDT.Return_Value__c)){
                MapDataTransformationRepType.put(oDT.Return_Value__c,oDT.Transformation_Description__c);
            }
            MapDTLookUpValue.put(oDT.Transformation_Description__c,ODT.Lookup_Value__c);
       }
        
      
       for(Id oUserId : mapUserRepType.keySet()){
          
           for(String retrnval : MapDataTransformationRepType.keyset()){
              if(mapUserRepType.get(oUserId) == Retrnval){
                   UserToTransdesc.put(oUserId,MapDataTransformationRepType.get(Retrnval));
           }
         }
       }
       
        if(!MapAccountUser.IsEmpty()){
           for(String accSAPId : MapSAPAccountIds.values()){
            List<String> transdesc = new List<String>();
            if(MapAccountUser != null && MapAccountUser.containsKey(AccSAPId)){
               for(Id userid : MapAccountUser.get(AccSAPId)){ 
                  if(UserToTransdesc.containsKey(userid)){
                       if(UserToTransdesc.get(userid)!=null){
                           transdesc.add(UserToTransdesc.get(userid));
                       }else if(UserToTransdesc.get(userid)==null){
                               transdesc.clear();
                               transdesc.add(UserToTransdesc.get(userid));
                               break;
                       }
                   }
                }
               }
              if(!transdesc.isempty()){
                 transdesc.sort(); 
                for(Lead oUpdLead : LeadsToUpd){
                    for(Id userid: UserToTransdesc.keySet()){
                        Integer i = 0;
                        if(transdesc[i]==UserToTransdesc.get(userid) && MapDTLookUpValue.get(transdesc[i])==MapRepChannel.get(oUpdLead.Id)){
                            MapAccountLeadOwner.put(oUpdLead.Id,userid);
                        }
                    }
                }
           }
           }
        
        
      for(Lead oLead : LeadsToUpd){
         if(MapAccountLeadOwner.get(oLead.Id)!=null){
           oLead.OwnerId = MapAccountLeadOwner.get(oLead.Id);
           oLead.Is_Web_To_Lead__c = false;
         }
      }
      
      }
      
      if(!MapMDBAccountUser.IsEmpty()){
         for(String accMDBId : MapMDBAccountIds.values()){
            List<String> transdesc = new List<String>();
            if(MapMDBAccountUser != null && MapMDBAccountUser.containsKey(AccMDBId)){
               for(Id userid : MapMDBAccountUser.get(AccMDBId)){ 
                  if(UserToTransdesc.containsKey(userid)){
                       if(UserToTransdesc.get(userid)!=null){
                           transdesc.add(UserToTransdesc.get(userid));
                       }else if(UserToTransdesc.get(userid)==null){
                               transdesc.clear();
                               transdesc.add(UserToTransdesc.get(userid));
                               break;
                       }
                   }
                }
               }
              if(!transdesc.isempty()){
                 transdesc.sort(); 
                for(Lead oUpdLead : LeadsToUpdPLC){
                   for(Id userid: UserToTransdesc.keySet()){
                        Integer i = 0;

                        if(transdesc[i]==UserToTransdesc.get(userid) && MapDTLookUpValue.get(transdesc[i])==MapRepChannel.get(oUpdLead.Id)){
                            MapAccountLeadOwner.put(oUpdLead.Id,userid);
                        }
                    }
                }
           }
           }
        
        
      for(Lead oLead : LeadsToUpdPLC){
         if(MapAccountLeadOwner.get(oLead.Id)!=null){
           oLead.OwnerId = MapAccountLeadOwner.get(oLead.Id);
           oLead.Is_Web_To_Lead__c = false; 
           //System.debug('*****'+oLead.OwnerId);//Commented as part of DPS-19692
         }
      }
      
      
      }

    
    
    }
    
   
    public void populateAccountonLead(List<Lead> listofLeads){
        Set<String> setSAPAccountIds = new Set<String>();
        Set<String> setMDBAccountIds = new Set<String>();
        Set<String> setEXTAccountIds = new Set<String>();    
        Set<String> setWLDIds = new Set<String>();
        Map<String,Account> mapAccountSAPIds = new Map<String,Account>();
        Map<String,Account> mapAccountMDBIds = new Map<String,Account>();
        Map<String,Account> mapAccountExtIds = new Map<String,Account>();
        Map<String,Account> mapAccountWLDIds = new Map<String,Account>();
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Lead> listLeads = new List<Lead>();
        List<Id> listLeadsOwner = new List<Id>();
        List<Account> listAccounts = new List<Account>();
        String accountsQuery = 'Select Id,SAPAccountNumber__c,Name,Sales_Org__c,Industry,Customer_Class_c__c,Customer_Type__c,Customer_Group__c,MDBID__c,Legacy_System_ID__c,WLD_ID__c, Tax_Number_Type__c from Account';
        for(Lead oLead : listofLeads){
            if(oLead.Is_GLI__c != true){
                listLeads.add(oLead);
            }
        }
  
        for(Lead oLead : listLeads){
            listLeadsOwner.add(oLead.OwnerId);
            if(oLead.SAPAccountNumber__c!= null){
                SetSAPAccountIds.add(oLead.SAPAccountNumber__c);
                LeadsToUpdate.add(olead);
            }else if(oLead.MDBID__c!= null){
                SetMDBAccountIds.add(oLead.MDBID__c);
                LeadsToUpdate.add(olead);
                
            }else if(oLead.Legacy_System_ID__c!= null){
                SetEXTAccountIds.add(oLead.Legacy_System_ID__c);
                LeadsToUpdate.add(olead);
            }else if(oLead.WLD_ID__c!=null){
                SetWLDIds.add(oLead.WLD_ID__c);
                LeadsToUpdate.add(olead);
            }
        }
        Map<Id,User> mapUsers = new map<Id,User>([Select Id,Sales_Org__c from User where Id IN : listLeadsOwner and Sales_Org__c!=null]);
        
        
        if(!SetSAPAccountIds.IsEmpty()){
            AccountsQuery += ' where SAPAccountNumber__c IN : SetSAPAccountIds';
            if(!SetMDBAccountIds.IsEmpty()){
                AccountsQuery += ' OR MDBID__c IN : SetMDBAccountIds';
            }
            if(!SetEXTAccountIds.IsEmpty()){
                AccountsQuery += ' OR Legacy_System_ID__c IN : SetEXTAccountIds';
            }
            if(!SetWLDIds.IsEmpty()){
                AccountsQuery += ' OR WLD_ID__c IN : SetWLDIds';          
            }
        }else if(!SetMDBAccountIds.IsEmpty()){
            AccountsQuery += ' where MDBID__c IN : SetMDBAccountIds';
            
            if(!SetEXTAccountIds.IsEmpty()){
                AccountsQuery += ' OR Legacy_System_ID__c IN : SetEXTAccountIds';
            }
            if(!SetWLDIds.IsEmpty()){
                 AccountsQuery += ' OR WLD_ID__c IN : SetWLDIds';
            }
        } else if(!SetEXTAccountIds.IsEmpty()){
               AccountsQuery += ' where Legacy_System_ID__c IN : SetEXTAccountIds';
               
            if(!SetWLDIds.IsEmpty()){
                 AccountsQuery += ' OR WLD_ID__c IN : SetWLDIds';
            }
        }else if(!SetWLDIds.IsEmpty()){
             AccountsQuery += ' where WLD_ID__c IN : SetWLDIds';
        }
         
         if(!SetSAPAccountIds.IsEmpty() || !SetMDBAccountIds.IsEmpty() || !SetEXTAccountIds.IsEmpty() || !SetWLDIds.IsEmpty()){
            listAccounts = Database.query(AccountsQuery);
        }
            //List<Account> listAccounts = [Select Id,SAPAccountNumber__c,Name,Sales_Org__c,Industry,
            //                               Customer_Class_c__c,Customer_Type__c,Customer_Group__c from Account where SAPAccountNumber__c IN : SetSAPAccountIds';
            
        
        if(!listAccounts.IsEmpty()){
            for(Account oAccount : listAccounts){
                if(oAccount.SAPAccountNumber__c!=null && !MapAccountSAPIds.containsKey(oAccount.SAPAccountNumber__c)){
                    MapAccountSAPIds.put(oAccount.SAPAccountNumber__c,oAccount);
                }
                if(oAccount.MDBID__c!=null && !MapAccountMDBIds.containsKey(oAccount.MDBID__c)){
                    MapAccountMDBIds.put(oAccount.MDBID__c,oAccount);
                }
                if(oAccount.Legacy_System_ID__c!=null && !MapAccountExtIds.containsKey(oAccount.Legacy_System_ID__c)){
                    MapAccountExtIds.put(oAccount.Legacy_System_ID__c,oAccount);
                }
                if(oAccount.WLD_ID__c !=null && !MapAccountWLDIds.containsKey(oAccount.WLD_ID__c )){
                    MapAccountWLDIds.put(oAccount.WLD_ID__c,oAccount);
                }
            }
            
                    
            for(Lead oLead : LeadsToUpdate){
                if(oLead.SAPAccountNumber__c!=null && MapAccountSAPIds.containsKey(oLead.SAPAccountNumber__c)){
                    oLead.Account__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Id;
                    oLead.MDBID__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).MDBID__c;
                    oLead.Sales_Org__c= MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Sales_Org__c;
                    
                    if(MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Class_c__c!=null && MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Class_c__c!=''){
                        oLead.Customer_Class__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Class_c__c; 
                    }else if(MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Class_c__c==null || MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Class_c__c==''){
                        oLead.Customer_Class__c = 'None';
                    }                
                    
                    oLead.Customer_Group__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Group__c; 
                    oLead.Customer_Type__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Customer_Type__c ;   
                    oLead.Industry = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Industry; 
                    oLead.Legacy_System_ID__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Legacy_System_ID__c ;
                    if(MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Tax_Number_Type__c != null && MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Tax_Number_Type__c !=''){
                        oLead.Tax_Number_Type__c = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Tax_Number_Type__c;
                    }     
                    if(oLead.Company == null || oLead.Company == '[not provided]'){
                        oLead.Company = MapAccountSAPIds.get(oLead.SAPAccountNumber__c).Name;   
                    }
                    
                    
                }else if(oLead.MDBID__c!=null && MapAccountMDBIds.containsKey(oLead.MDBID__c)){
                    oLead.Account__c = MapAccountMDBIds.get(oLead.MDBID__c).Id;
                    oLead.SAPAccountNumber__c = MapAccountMDBIds.get(oLead.MDBID__c).SAPAccountNumber__c;
                    oLead.Legacy_System_ID__c = MapAccountMDBIds.get(oLead.MDBID__c).Legacy_System_ID__c ;
                    oLead.Sales_Org__c = MapAccountMDBIds.get(oLead.MDBID__c).Sales_Org__c;
                    
                    if(MapAccountMDBIds.get(oLead.MDBID__c).Customer_Class_c__c!=null && MapAccountMDBIds.get(oLead.MDBID__c).Customer_Class_c__c!=''){
                        oLead.Customer_Class__c= MapAccountMDBIds.get(oLead.MDBID__c).Customer_Class_c__c;
                    
                    }else if(MapAccountMDBIds.get(oLead.MDBID__c).Customer_Class_c__c==null || MapAccountMDBIds.get(oLead.MDBID__c).Customer_Class_c__c==''){
                        oLead.Customer_Class__c= 'None';
                    }
                     
                    oLead.Customer_Group__c = MapAccountMDBIds.get(oLead.MDBID__c).Customer_Group__c; 
                    oLead.Customer_Type__c = MapAccountMDBIds.get(oLead.MDBID__c).Customer_Type__c ;     
                    oLead.Industry = MapAccountMDBIds.get(oLead.MDBID__c).Industry; 
                    //System.debug('test1: ' +MapAccountSAPIds);//Commented as part of DPS-19692
                    //System.debug('test2: '  +oLead);//Commented as part of DPS-19692
                    if(MapAccountMDBIds.get(oLead.MDBID__c).Tax_Number_Type__c != null && MapAccountMDBIds.get(oLead.MDBID__c).Tax_Number_Type__c !=''){
                        oLead.Tax_Number_Type__c = MapAccountMDBIds.get(oLead.MDBID__c).Tax_Number_Type__c;
                    }    
                    if(oLead.Company == null || oLead.Company == '[not provided]'){
                        oLead.Company = MapAccountMDBIds.get(oLead.MDBID__c).Name; 
                        
                    }
                
                }else if(oLead.Legacy_System_ID__c!=null && MapAccountExtIds.containsKey(oLead.Legacy_System_ID__c)){
                    oLead.Account__c = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Id;
                    oLead.SAPAccountNumber__c = MapAccountExtIds.get(oLead.Legacy_System_ID__c).SAPAccountNumber__c;
                    oLead.MDBID__c= MapAccountExtIds.get(oLead.Legacy_System_ID__c).MDBID__c;
                    oLead.Sales_Org__c = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Sales_Org__c;
                    if(MapAccountExtIds.get(oLead.Legacy_System_ID__c).Tax_Number_Type__c != null && MapAccountExtIds.get(oLead.Legacy_System_ID__c).Tax_Number_Type__c !=''){
                        oLead.Tax_Number_Type__c = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Tax_Number_Type__c;
                    } 
                    
                    if( MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Class_c__c!=null && MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Class_c__c!=''){
                        oLead.Customer_Class__c= MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Class_c__c; 
                     }else if(MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Class_c__c==null || MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Class_c__c==''){
                         oLead.Customer_Class__c= 'None';
                     
                     }
                    oLead.Customer_Group__c = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Group__c; 
                    oLead.Customer_Type__c = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Customer_Type__c ;     
                    oLead.Industry = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Industry; 
                    if(oLead.Company == null || oLead.Company == '[not provided]'){
                        oLead.Company = MapAccountExtIds.get(oLead.Legacy_System_ID__c).Name; 
                        
                    }
                }else if(oLead.WLD_ID__c != null && MapAccountWLDIds.containsKey(oLead.WLD_ID__c)){
                   //System.debug('WLD ID');//Commented as part of DPS-19692
                    oLead.Account__c = MapAccountWLDIds.get(oLead.WLD_ID__c).Id;
                    oLead.SAPAccountNumber__c = MapAccountWLDIds.get(oLead.WLD_ID__c).SAPAccountNumber__c;
                    oLead.MDBID__c= MapAccountWLDIds.get(oLead.WLD_ID__c).MDBID__c;
                    oLead.Sales_Org__c = MapAccountWLDIds.get(oLead.WLD_ID__c).Sales_Org__c;
                    oLead.Customer_Group__c = MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Group__c; 
                    oLead.Customer_Type__c = MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Type__c ;     
                    oLead.Industry = MapAccountWLDIds.get(oLead.WLD_ID__c).Industry; 
                    if(MapAccountWLDIds.get(oLead.WLD_ID__c).Tax_Number_Type__c != null && MapAccountWLDIds.get(oLead.WLD_ID__c).Tax_Number_Type__c !=''){
                        oLead.Tax_Number_Type__c = MapAccountWLDIds.get(oLead.WLD_ID__c).Tax_Number_Type__c;
                    }       
                    
                    if( MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Class_c__c!=null && MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Class_c__c!=''){
                        oLead.Customer_Class__c= MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Class_c__c; 
                     }else if(MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Class_c__c==null || MapAccountWLDIds.get(oLead.WLD_ID__c).Customer_Class_c__c==''){
                         oLead.Customer_Class__c= 'None';
                     
                     }
                    
                    if(oLead.Company == null || oLead.Company == '[not provided]'){
                        oLead.Company = MapAccountWLDIds.get(oLead.WLD_ID__c).Name; 
                        
                    }
                 }
                
            }
        }
        
        for(Lead oLead : listLeads){
             if((oLead.Sales_Org__c=='' || oLead.Sales_Org__c==null )&& mapUsers.containsKey(oLead.OwnerId)){
                        oLead.Sales_Org__c = mapUsers.get(oLead.OwnerId).Sales_Org__c;
            }   
           
       }
    }
   
       public void populateContactonLead(List<Lead> listLeads){
      
        List<Lead> leadsToUpdate = new List<Lead>();
        List<Contact> listContact = new List<Contact>();
        Set<String> setSAPContactIds= new Set<String>();
        Set<String> setContactExternalIds= new Set<String>();
        Map<String,Contact> mapContactSAPId= new Map<String,Contact>();
        Map<String,Contact> mapContactExtId= new Map<String,Contact>();
        String contactsquery = 'Select Id,SAP_Contact_ID__c,Job_Function__c,External_ID__c  from Contact ';
        
         for(Lead oLead : listLeads){
            if(oLead.Contact_SAP_ID__c!= null){
              SetSAPContactIds.add(oLead.Contact_SAP_ID__c);
              LeadsToUpdate.add(oLead);
            }else if(oLead.External_Contact_ID__c!= null){
              SetContactExternalIds.add(oLead.External_Contact_ID__c);
              LeadsToUpdate.add(oLead);
            }
            else if(oLead.Is_GLI__c==False){
                oLead.Contact__c =null;
                //system.debug('delete contact reference');//Commented as part of DPS-19692
            }
        }
        
        if(!SetSAPContactIds.IsEmpty()){
           Contactsquery+= 'where SAP_Contact_ID__c IN : SetSAPContactIds';
           
            if(!SetContactExternalIds.IsEmpty()){
                Contactsquery+= ' OR External_ID__c IN : SetContactExternalIds';
             }
                
        }else if(!SetContactExternalIds.IsEmpty()){
                Contactsquery+= 'where External_ID__c IN : SetContactExternalIds';
            }
            
            if(!SetSAPContactIds.IsEmpty() || !SetContactExternalIds.IsEmpty()){
                listContact = Database.query(Contactsquery);
            }
            
            for(Contact oContact : listContact){
                if(!MapContactSAPId.containsKey(oContact.SAP_Contact_ID__c) && oContact.SAP_Contact_ID__c!=null){
                    MapContactSAPId.put(oContact.SAP_Contact_ID__c ,oContact);
                }
                if(!MapContactExtId.containsKey(oContact.External_ID__c) && oContact.External_ID__c!=null){
                    MapContactExtId.put(oContact.External_ID__c ,oContact);
                }
            }
        
            for(Lead oLead : LeadsToUpdate){
                if(oLead.Contact_SAP_ID__c!= null && MapContactSAPId.containsKey(oLead.Contact_SAP_ID__c) && (oLead.Is_GLI__c==False)){ 
                    oLead.Contact__c = MapContactSAPId.get(oLead.Contact_SAP_ID__c).Id;
                    if(MapContactSAPId.get(oLead.Contact_SAP_ID__c).Job_Function__c !=null){    //added null check for job function as per story DPS-8543
                        oLead.Job_Function__c = MapContactSAPId.get(oLead.Contact_SAP_ID__c).Job_Function__c;
                    }
                    oLead.External_Contact_ID__c = MapContactSAPId.get(oLead.Contact_SAP_ID__c).External_ID__c ;
                }
                else if(oLead.External_Contact_ID__c!= null && MapContactExtId.containsKey(oLead.External_Contact_ID__c) && (oLead.Is_GLI__c==False)){ 
                    oLead.Contact__c = MapContactExtId.get(oLead.External_Contact_ID__c).Id;
                    if(MapContactExtId.get(oLead.External_Contact_ID__c).Job_Function__c !=null){   //added null check for job function as per story DPS-8543
                        oLead.Job_Function__c = MapContactExtId.get(oLead.External_Contact_ID__c).Job_Function__c;
                    }
                    oLead.Contact_SAP_ID__c = MapContactExtId.get(oLead.External_Contact_ID__c).SAP_Contact_ID__c;
                }
                
                
            }
            
           
        } 
        
    // Added for JIRA #20 - Dynamic Holiday check for accept by and convert by fields   
    public void isHoliday(List<Lead> listLeads,Map<id,Lead> newMap, Map<id,Lead> oldMap,boolean isInsert, boolean isUpdate){
       
        // this can be out side a loop to limit the numbers of queries issued
         LIST<Holiday> holidayList = new LIST<Holiday>();
        if(Schema.sObjectType.Holiday.isAccessible()){
            holidayList = [select ActivityDate From Holiday]; 
        }
        SET<Holiday> holidaySet=new SET<Holiday>();
        SET<Date> holiayDates=new SET<Date>();
        HolidaySet.addAll(holidayList);
        Boolean isHoliday = false;
        if(HolidaySet!=null && HolidaySet.size()>0){
            for(Holiday h : HolidaySet)
            {
               HoliayDates.add(h.ActivityDate);
            }                      
        if(listLeads != null && listLeads.size()>0){
             for(Lead l: listLeads){    
                 if((isInsert || (isUpdate && (newMap.get(l.id).Convert_By__c != oldMap.get(l.id).Convert_By__c
                                                   || newMap.get(l.id).Accept_By__c != oldMap.get(l.id).Accept_By__c))
                                    ) 
                        && ((l.Convert_By__c!=null && HoliayDates.Contains(l.Convert_By__c.date()))
                                || (l.accept_By__c!=null && HoliayDates.Contains(l.accept_By__c.date()))
                           )
                     ){
                      l.addError('SLAs should take into account National holidays. Convert By And/Or Accept By cannot fall on holiday');       
                    }
                }
            }
        }
    }
        
    // Added for JIRA #33 - sub task-Account Lead activities - Create custom object with fields
    //public void pullLeadActivities(List<Lead> listLeads,Map<id,Lead> newMap, Map<id,Lead> oldMap,boolean isInsert, boolean isUpdate){
        
     /*   List<AccountLeadActivity__c> alcList=new List<AccountLeadActivity__c>();
        List<AccountLeadActivity__c> alcListInsert=new List<AccountLeadActivity__c>();
        
        if(isUpdate){
        //system.debug('**** inUpdate');//Commented as part of DPS-19692
            List<Task> taskListforLeads=new List<Task>();
            taskListforLeads = [SELECT id,CallType,ActivityDate,Status,Subject,Owner.name,OwnerId,WhatId,whoId from Task WHERE WhoId IN : newMap.keySet()];
            //System.debug('*****taskListforLeads '+ taskListforLeads );//Commented as part of DPS-19692

            Map<id,List<Task>> tasksForLeadMap= new Map<id,List<Task>>();
            if(taskListforLeads != null & taskListforLeads.size()>0){
                for(Task t: taskListforLeads){
                    if(tasksForLeadMap.ContainsKey(t.WhoId))
                        tasksForLeadMap.get(t.whoId).add(t);
                    else{
                        tasksForLeadMap.put(t.whoId,new List<Task>());
                        tasksForLeadMap.get(t.WhoId).add(t);
                    } 
                }
            } 
            //system.debug('****tasksForLeadMap' + tasksForLeadMap);//Commented as part of DPS-19692
                      
            for(Lead l: listLeads){                
                List<Task> taskListForOneLead= new List<Task>(); 
                taskListForOneLead = tasksForLeadMap.get(l.id);
                for(Task t: taskListForOneLead ){
                    AccountLeadActivity__c acctLeadActivity=new AccountLeadActivity__c();
                    //acctLeadActivity.Call_Type__c = t.CallType;
                    //acctLeadActivity.due_date__c= t.ActivityDate;
                    //acctLeadActivity.Status__c= t.Status;
                    //system.debug('*****t.whatid'+t.whatid);//Commented as part of DPS-19692
                    //system.debug('*****acctLeadActivity.Related_To_Account__c'+acctLeadActivity.Related_To_Account__c);//Commented as part of DPS-19692
                    
                    acctLeadActivity.Related_To_Account__c = t.whatid;
                    
                    //acctLeadActivity.Subject__c = t.Subject;
                    acctLeadActivity.Lead__c= t.whoId;
                    alcListInsert.add(acctLeadActivity);
                    
                }
            } 
            //system.debug('****alcListInsert' + alcListInsert);//Commented as part of DPS-19692
            if(alcListInsert != null && alcListInsert.size()>0)
                insert alcListInsert;

        }*/
              
  //  }
    
        // Added for JIRA ILM 96 - SLA Convert by and Accept by Update based on LEad score and channel combination on LM SLA custom object.   
    public void setSLAFromSLAAdminTable(List<Lead> listLeads,Map<id,Lead> newMap, Map<id,Lead> oldMap,boolean isInsert, boolean isUpdate){
        //LIST<Holiday> holidayList = [select ActivityDate From Holiday];
        string bHourstr= Label.BusinessHoursLeadSLA;
        BusinessHours stdBusinessHours = new BusinessHours();
        List<Lead> listNonAnzLeads = new List<Lead>();
        List<Lead> listAnzLeads = new List<Lead>();
        
        for(Lead leadRecord:listLeads){
            if(leadRecord.Sales_Org__c == 'LRA' || leadRecord.Sales_Org__c == 'BKRS'){
                listAnzLeads.add(leadRecord); 
            } else {
               listNonAnzLeads.add(leadRecord); 
            }
        }
        
        if(listAnzLeads!= null && listAnzLeads.size() >0){
            setANZSLAFromSLAAdminTable(listAnzLeads,newMap, oldMap, isInsert, isUpdate);        
        }

        SET<String> leadChannelsSET= new SET<String>();
        if(listNonAnzLeads!= null && listNonAnzLeads.size() >0){
            
            if(Schema.sObjectType.businesshours.isAccessible()){
         stdBusinessHours = [select id from businesshours WHERE name = :bHourstr]; 
            }
            
            for(Lead newLead:listNonAnzLeads){
                if(newLead.Business_Org__c != null && newLead.Business_Org__c != ''){
                    leadChannelsSET.add(newLead.Business_Org__c); 
                }
            }
        } 
        
        List<LM_SLA__c> lMSLALst= new List<LM_SLA__c>();
        // Fetching LM SLA records for lead score and channel combination of leads
        if(leadChannelsSET!= null && leadChannelsSET.size()>0){
            if(Schema.sObjectType.LM_SLA__c.isAccessible()){
            LMSLALst = [SELECT Channel__c,Lead_Score__c,Send_AcceptBy_Violation_Email__c,Accept_By_SLA_Violation_Period__c,Conversion_SLA__c,Send_AcceptBy_Warning_Email__c,Accept_By_SLA_Warning_period__c,
                        Send_Convert_By_Violation_Email__c,Send_Convert_By_Warning_Email__c,Convert_By_SLA_Warning_period__c,Convert_By_SLA_Violation_period__c,Acceptance_SLA__c,UniqueChannelAndLeadScore__c FROM LM_SLA__c 
                         WHERE Channel__c IN : leadChannelsSET];
            }
        }
        
        map<string,LM_SLA__C> lMSLAMap= new map<string,LM_SLA__C>();
        if(LMSLALst!= null && LMSLALst.size() >0){
            for(LM_SLA__c lmsla :LMSLALst){
                LMSLAMap.put(lmsla.UniqueChannelAndLeadScore__c,lmsla);  
            
            }         
        }

        
        if(listNonAnzLeads!= null && listNonAnzLeads.size() >0 && LMSLAMap != null && LMSLAMap.size() > 0 ){
            //system.debug('***today date' + system.now());//Commented as part of DPS-19692
            for(Lead l: listNonAnzLeads){
                if(isInsert || (isUpdate && (newMap.get(l.id).Business_Org__c != oldMap.get(l.id).Business_Org__c
                                                       || newMap.get(l.id).Lead_Scoring_Combined__c != oldMap.get(l.id).Lead_Scoring_Combined__c))
                                        ) {
                    DateTime leadCreatedDate= l.createdDate;
            DateTime leadCombScrUpdateOn = system.now();//12/12/2016 : Mrinmoy Sarkar added for MCL 1567
                    //system.debug('*****testing' + leadChannelsSET + ' '+ LMSLAMap+ ' ' + LMSLAMap.get(l.Business_Org__c  + 'N/A') );//Commented as part of DPS-19692
                    if( leadChannelsSET != null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null)
                    {
                        l.SLA_Updated__c = true;//12/12/2016 : Mrinmoy Sarkar added for MCL 1567
                        Decimal noOfdaysAccept= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Acceptance_SLA__c;
                        if(noOfdaysAccept != null)  {                      
                           // l.accept_by__c = leadCreatedDate.addDays(integer.valueOf(noOfdaysAccept));
                           // l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;Mrinmoy Sarkar Commented out on 12/12/2016 for MCL 1567
                           //12/12/2016 :Mrinmoy Sarkar replaced leadCreatedDate to leadCombScrUpdateOn for SLA fields calculation for MCL 1567
                           l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCombScrUpdateOn == null ? system.now() :leadCombScrUpdateOn, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;
                            
                        }
                        else{
                             l.accept_by__c = null;                              
                        }
                        Decimal noOfdaysConvert= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Conversion_SLA__c; 
                        if(noOfdaysConvert != null) {
                            //l.convert_by__c =BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ; Mrinmoy Sarkar Commented out on 12/12/2016 for MCL 1567
                            //12/12/2016 :Mrinmoy Sarkar replaced leadCreatedDate to leadCombScrUpdateOn for SLA fields calculation for MCL 1567
                            l.convert_by__c =BusinessHours.addGMT(stdBusinessHours.id, leadCombScrUpdateOn == null ? system.now() :leadCombScrUpdateOn, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ;
                           
                        }
                         else{
                            l.convert_by__c = null;
                         }
                    }                    
                    // if Lead scoring combined is not specified, bring default SLA.
                    
                    else if((l.Lead_Scoring_Combined__c== null || l.Lead_Scoring_Combined__c== '')  && LMSLAMap.get(l.Business_Org__c  + 'N/A')!= null){
                        Decimal noOfdaysAccept= LMSLAMap.get(l.Business_Org__c  + 'N/A').Acceptance_SLA__c;
                        if(noOfdaysAccept != null) {      
                            l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;
                            
                        }
                        else{
                            l.accept_by__c = null;                       
                        }
                        Decimal noOfdaysConvert= LMSLAMap.get(l.Business_Org__c  + 'N/A').Conversion_SLA__c; 
                        if(noOfdaysConvert != null) {                       
                            l.convert_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ;
                            
                        } 
                        else{
                            l.convert_by__c = null;
                        }                
                    
                    }
                    // if no match for leradscoringcombined from lead with LM SLA bring default SLA.
                    else if(LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c) == null && LMSLAMap.get(l.Business_Org__c  + 'N/A')!= null){
                        Decimal noOfdaysAccept= LMSLAMap.get(l.Business_Org__c  + 'N/A').Acceptance_SLA__c;
                        if(noOfdaysAccept != null) {                       
                            l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;
                        }
                         else{
                            l.accept_by__c = null;                              
                         }
                         Decimal noOfdaysConvert= LMSLAMap.get(l.Business_Org__c  + 'N/A').Conversion_SLA__c; 
                        if(noOfdaysConvert != null)  {                      
                           l.convert_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ;
                        }
                        else{
                            l.convert_by__c = null;    
                        }       
                    }
                    
                    else{
                        l.accept_by__c = null; 
                        l.convert_by__c = null;  
                    }
                }
                
                // Accept Warning SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_AcceptBy_Warning_Email__c == true){
                    Decimal warningPeriod = LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Accept_By_SLA_Warning_period__c;
                    //l.Accept_SLA_Warning_Date__c = (l.accept_by__c  - LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Accept_By_SLA_Warning_period__c).Date() ;
                    if(l.accept_by__c != null && warningPeriod!= null){
                        l.Accept_SLA_Warning_Date__c = BusinessHours.addGMT(stdBusinessHours.id, l.accept_by__c , -integer.valueOf(warningPeriod)* 24 * 60 * 60 * 1000L).Date();                    
                    }
                    //if(l.Accept_SLA_Warning_Date_Flag__c == null || (isUpdate && newMap.get(l.id).Accept_SLA_Warning_Date__c != oldMap.get(l.id).Accept_SLA_Warning_Date__c)){
                       // l.Accept_SLA_Warning_Date_Flag__c =  l.Accept_SLA_Warning_Date__c;   
                    //}
                }
                else{
                    l.Accept_SLA_Warning_Date__c = null;
                    //l.Accept_SLA_Warning_Date_Flag__c = null;
                }
                // Accept Violation SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_AcceptBy_Violation_Email__c== true){
                    Decimal violationPeriod= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Accept_By_SLA_Violation_Period__c;
                    if(l.accept_by__c != null && violationPeriod!= null){
                        l.Accept_SLA_Violation_End_Date__c = BusinessHours.addGMT(stdBusinessHours.id, l.accept_by__c , integer.valueOf(violationPeriod)* 24 * 60 * 60 * 1000L).Date();
                    }
                    //if(l.Accept_SLA_Violation_Date__c ==null || (isUpdate && newMap.get(l.id).accept_by__c != oldMap.get(l.id).accept_by__c))
                        //l.Accept_SLA_Violation_Date__c = l.accept_by__c.Date();
                }
                else{
                    l.Accept_SLA_Violation_End_Date__c = null;
                    //l.Accept_SLA_Violation_Date__c = null;
                }
                
                 // Convert Warning SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_Convert_By_Warning_Email__c== true){
                    Decimal warningPeriod = LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Convert_By_SLA_Warning_Period__c;
                    if(l.convert_by__c != null && warningPeriod != null){
                        l.Convert_SLA_Warning_Date__c = BusinessHours.addGMT(stdBusinessHours.id, l.convert_by__c , -integer.valueOf(warningPeriod)* 24 * 60 * 60 * 1000L).Date();                    
                    }
                    //if(l.Convert_SLA_Warning_Date_Flag__c== null || (isUpdate && newMap.get(l.id).Convert_SLA_Warning_Date__c!= oldMap.get(l.id).Convert_SLA_Warning_Date__c)){
                        //l.Convert_SLA_Warning_Date_Flag__c=  l.Convert_SLA_Warning_Date__c;   
                    //}
                }
                else{
                    l.Convert_SLA_Warning_Date__c = null;
                    //l.Convert_SLA_Warning_Date_Flag__c  = null;
                }
                // Convert Violation SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_Convert_By_Violation_Email__c== true){
                    Decimal violationPeriod= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Convert_By_SLA_Violation_period__c;
                    if(l.convert_by__c != null && violationPeriod!= null){
                        l.Convert_SLA_Violation_End_Date__c= BusinessHours.addGMT(stdBusinessHours.id, l.convert_by__c , integer.valueOf(violationPeriod)* 24 * 60 * 60 * 1000L).Date() ;                    
                    }
                    //if(l.Convert_SLA_Violation_Date_Flag__c ==null || (isUpdate && newMap.get(l.id).convert_by__c != oldMap.get(l.id).convert_by__c))
                        //l.Convert_SLA_Violation_Date_Flag__c= l.convert_by__c.Date();
                }
                else{
                    l.Convert_SLA_Violation_End_Date__c= null;
                    //l.Convert_SLA_Violation_Date_Flag__c= null;
                }
                 
            }
        }           
    }
    
            // Added for MCL-2193   
    public void setANZSLAFromSLAAdminTable(List<Lead> listLeads,Map<id,Lead> newMap, Map<id,Lead> oldMap,boolean isInsert, boolean isUpdate){

        //LIST<Holiday> holidayList = [select ActivityDate From Holiday];
        string bHourstrANZ = Label.BusinessHoursLeadSLAANZ;
        BusinessHours stdBusinessHours = new BusinessHours();
        if(Schema.sObjectType.businesshours.isAccessible()){
            stdBusinessHours = [select id from businesshours WHERE name = :bHourstrANZ]; 
        }
        SET<String> leadChannelsSET= new SET<String>();
        for(Lead newLead:listLeads){
            if(newLead.Business_Org__c != null && newLead.Business_Org__c != ''){
                leadChannelsSET.add(newLead.Business_Org__c); 
            }    
        }
        
        List<LM_SLA__c> lMSLALst= new List<LM_SLA__c>();
        // Fetching LM SLA records for lead score and channel combination of leads
        if(leadChannelsSET!= null && leadChannelsSET.size()>0){
            if(Schema.sObjectType.LM_SLA__c.isAccessible())
            LMSLALst = [SELECT Channel__c,Lead_Score__c,Send_AcceptBy_Violation_Email__c,Accept_By_SLA_Violation_Period__c,Conversion_SLA__c,Send_AcceptBy_Warning_Email__c,Accept_By_SLA_Warning_period__c,
                        Send_Convert_By_Violation_Email__c,Send_Convert_By_Warning_Email__c,Convert_By_SLA_Warning_period__c,Convert_By_SLA_Violation_period__c,Acceptance_SLA__c,UniqueChannelAndLeadScore__c FROM LM_SLA__c 
                         WHERE Channel__c IN : leadChannelsSET];
        }
        
        map<string,LM_SLA__C> lMSLAMap= new map<string,LM_SLA__C>();
        if(LMSLALst!= null && LMSLALst.size() >0){
            for(LM_SLA__c lmsla :LMSLALst){
                LMSLAMap.put(lmsla.UniqueChannelAndLeadScore__c,lmsla);  
            
            }         
        }

        
        if(listLeads!= null && listLeads.size() >0 && LMSLAMap != null && LMSLAMap.size() > 0 ){
            //system.debug('***today date' + system.now());//Commented as part of DPS-19692
            for(Lead l: listLeads){
                if(isInsert || (isUpdate && (newMap.get(l.id).Business_Org__c != oldMap.get(l.id).Business_Org__c
                                                       || newMap.get(l.id).Lead_Scoring_Combined__c != oldMap.get(l.id).Lead_Scoring_Combined__c))
                                        ) {
                    DateTime leadCreatedDate= l.createdDate;
            DateTime leadCombScrUpdateOn = system.now();//12/12/2016 : Mrinmoy Sarkar added for MCL 1567
                    //system.debug('*****testing' + leadChannelsSET + ' '+ LMSLAMap+ ' ' + LMSLAMap.get(l.Business_Org__c  + 'N/A') );//Commented as part of DPS-19692
                    if( leadChannelsSET != null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null)
                    {
                        l.SLA_Updated__c = true;//12/12/2016 : Mrinmoy Sarkar added for MCL 1567
                        Decimal noOfdaysAccept= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Acceptance_SLA__c;
                        if(noOfdaysAccept != null)  {                      
                           // l.accept_by__c = leadCreatedDate.addDays(integer.valueOf(noOfdaysAccept));
                           // l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;Mrinmoy Sarkar Commented out on 12/12/2016 for MCL 1567
                           //12/12/2016 :Mrinmoy Sarkar replaced leadCreatedDate to leadCombScrUpdateOn for SLA fields calculation for MCL 1567
                           l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCombScrUpdateOn == null ? system.now() :leadCombScrUpdateOn, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;
                            
                        }
                        else{
                             l.accept_by__c = null;                              
                        }
                        Decimal noOfdaysConvert= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Conversion_SLA__c; 
                        if(noOfdaysConvert != null) {
                            //l.convert_by__c =BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ; Mrinmoy Sarkar Commented out on 12/12/2016 for MCL 1567
                            //12/12/2016 :Mrinmoy Sarkar replaced leadCreatedDate to leadCombScrUpdateOn for SLA fields calculation for MCL 1567
                            l.convert_by__c =BusinessHours.addGMT(stdBusinessHours.id, leadCombScrUpdateOn == null ? system.now() :leadCombScrUpdateOn, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ;
                           
                        }
                         else{
                            l.convert_by__c = null;
                         }
                    }                    
                    // if Lead scoring combined is not specified, bring default SLA.
                    
                    else if((l.Lead_Scoring_Combined__c== null || l.Lead_Scoring_Combined__c== '')  && LMSLAMap.get(l.Business_Org__c  + 'N/A')!= null){
                        Decimal noOfdaysAccept= LMSLAMap.get(l.Business_Org__c  + 'N/A').Acceptance_SLA__c;
                        if(noOfdaysAccept != null) {      
                            l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;
                            
                        }
                        else{
                            l.accept_by__c = null;                       
                        }
                        Decimal noOfdaysConvert= LMSLAMap.get(l.Business_Org__c  + 'N/A').Conversion_SLA__c; 
                        if(noOfdaysConvert != null) {                       
                            l.convert_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ;
                            
                        } 
                        else{
                            l.convert_by__c = null;
                        }                
                    
                    }
                    // if no match for leradscoringcombined from lead with LM SLA bring default SLA.
                    else if(LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c) == null && LMSLAMap.get(l.Business_Org__c  + 'N/A')!= null){
                        Decimal noOfdaysAccept= LMSLAMap.get(l.Business_Org__c  + 'N/A').Acceptance_SLA__c;
                        if(noOfdaysAccept != null) {                       
                            l.accept_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysAccept)* 24 * 60 * 60 * 1000L) ;
                        }
                         else{
                            l.accept_by__c = null;                              
                         }
                         Decimal noOfdaysConvert= LMSLAMap.get(l.Business_Org__c  + 'N/A').Conversion_SLA__c; 
                        if(noOfdaysConvert != null)  {                      
                           l.convert_by__c = BusinessHours.addGMT(stdBusinessHours.id, leadCreatedDate == null ? system.now() :leadCreatedDate, integer.valueOf(noOfdaysConvert)* 24 * 60 * 60 * 1000L) ;
                        }
                        else{
                            l.convert_by__c = null;   
                        }        
                    }
                    
                    else{
                        l.accept_by__c = null; 
                        l.convert_by__c = null;  
                    }
                }
                
                // Accept Warning SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_AcceptBy_Warning_Email__c == true){
                    Decimal warningPeriod = LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Accept_By_SLA_Warning_period__c;
                    //l.Accept_SLA_Warning_Date__c = (l.accept_by__c  - LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Accept_By_SLA_Warning_period__c).Date() ;
                    if(l.accept_by__c != null && warningPeriod!= null){
                        l.Accept_SLA_Warning_Date__c = BusinessHours.addGMT(stdBusinessHours.id, l.accept_by__c , -integer.valueOf(warningPeriod)* 24 * 60 * 60 * 1000L).Date();                    
                    }
                    //if(l.Accept_SLA_Warning_Date_Flag__c == null || (isUpdate && newMap.get(l.id).Accept_SLA_Warning_Date__c != oldMap.get(l.id).Accept_SLA_Warning_Date__c)){
                       // l.Accept_SLA_Warning_Date_Flag__c =  l.Accept_SLA_Warning_Date__c;   
                    //}
                }
                else{
                    l.Accept_SLA_Warning_Date__c = null;
                    //l.Accept_SLA_Warning_Date_Flag__c = null;
                }
                // Accept Violation SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_AcceptBy_Violation_Email__c== true){
                    Decimal violationPeriod= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Accept_By_SLA_Violation_Period__c;
                    if(l.accept_by__c != null && violationPeriod!= null){
                        l.Accept_SLA_Violation_End_Date__c = BusinessHours.addGMT(stdBusinessHours.id, l.accept_by__c , integer.valueOf(violationPeriod)* 24 * 60 * 60 * 1000L).Date() ;                    
                    }
                    //if(l.Accept_SLA_Violation_Date__c ==null || (isUpdate && newMap.get(l.id).accept_by__c != oldMap.get(l.id).accept_by__c))
                        //l.Accept_SLA_Violation_Date__c = l.accept_by__c.Date();
                }
                else{
                    l.Accept_SLA_Violation_End_Date__c = null;
                    //l.Accept_SLA_Violation_Date__c = null;
                }
                
                 // Convert Warning SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_Convert_By_Warning_Email__c== true){
                    Decimal warningPeriod = LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Convert_By_SLA_Warning_Period__c;
                    if(l.convert_by__c != null && warningPeriod != null){
                        l.Convert_SLA_Warning_Date__c = BusinessHours.addGMT(stdBusinessHours.id, l.convert_by__c , -integer.valueOf(warningPeriod)* 24 * 60 * 60 * 1000L).Date();                    
                    }//if(l.Convert_SLA_Warning_Date_Flag__c== null || (isUpdate && newMap.get(l.id).Convert_SLA_Warning_Date__c!= oldMap.get(l.id).Convert_SLA_Warning_Date__c)){
                        //l.Convert_SLA_Warning_Date_Flag__c=  l.Convert_SLA_Warning_Date__c;   
                    //}
                }
                else{
                    l.Convert_SLA_Warning_Date__c = null;
                    //l.Convert_SLA_Warning_Date_Flag__c  = null;
                }
                // Convert Violation SLA Dates Calculation
                if(l.Business_Org__c != null && l.Lead_Scoring_Combined__c!= null && LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c)!= null &&  LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Send_Convert_By_Violation_Email__c== true){
                    Decimal violationPeriod= LMSLAMap.get(l.Business_Org__c + l.Lead_Scoring_Combined__c).Convert_By_SLA_Violation_period__c;
                    if(l.convert_by__c != null && violationPeriod!= null){
                        l.Convert_SLA_Violation_End_Date__c= BusinessHours.addGMT(stdBusinessHours.id, l.convert_by__c , integer.valueOf(violationPeriod)* 24 * 60 * 60 * 1000L).Date() ;                    
                    }
                    //if(l.Convert_SLA_Violation_Date_Flag__c ==null || (isUpdate && newMap.get(l.id).convert_by__c != oldMap.get(l.id).convert_by__c))
                        //l.Convert_SLA_Violation_Date_Flag__c= l.convert_by__c.Date();
                }
                else{
                    l.Convert_SLA_Violation_End_Date__c= null;
                    //l.Convert_SLA_Violation_Date_Flag__c= null;
                }
                 
            }
        }
    }
    
    //This method is used to update Lead Owner Manager- REgional MAnager by referring to User Object 
    //to send SLA Warning or violation email notificaitons.
    public void updateSalesRegionalMAnager(List<Lead> listLeads,Map<id,Lead> newMap, Map<id,Lead> oldMap,boolean isInsert, boolean isUpdate){
        
        SET<String> leadOwnerSet=new SET<String>();        
        for(Lead l:listLeads){
            LeadOwnerSet.add(l.OwnerId); 
        
        }
        MAP<id,User> userListForLeadOwners= new MAP<id,User>([SELECT Id,LM_Regional_Manager__c,Name FROM USER WHERE id IN:LeadOwnerSet]);
        if(isInsert || isUpdate){
            for(Lead l: listLeads){
                if(UserListForLeadOwners.get(l.OwnerId) !=null){
                    l.Regional_Manager__c = UserListForLeadOwners.get(l.OwnerId).LM_Regional_Manager__c;
                }
            }        
        }
    }

 //CMC-3 ---------------------------------------------------- CUIT Validator ------------------------------------------------------------
  public static boolean isValidCUIT(String inNroCuit) {
  
    //system.debug(logginglevel.info, '### Validando CNPJ - Valor ' + InNroCuit);//Commented as part of DPS-19692
    
    boolean ret = false;
    Integer posicion, coeficienteModulo, sumaTotal, digito, factor;
    String cLFSCARG = '54327654321';
    Integer cLFSCARGLEN = 11;
    

    
    //validate number format
    if(!InNroCuit.isNumeric()) {
      return false;
    }
  
   //control length of the entered number.
    if (InNroCuit.length() != CLFSCARGLEN) {
      return false;
    }
    
   //Entered number should not be less than or equal to zero
    if(Double.valueOf(InNroCuit) <= 0){
      return false;
    }
    //CMC-3
    //Validate first two digit of tax number
  
    if(Integer.valueOf(InNroCuit.substring(0, 2)) != 30 && Integer.valueOf(InNroCuit.substring(0, 2)) != 33 && Integer.valueOf(InNroCuit.substring(0, 2)) != 20 && Integer.valueOf(InNroCuit.substring(0, 2)) != 23 && Integer.valueOf(InNroCuit.substring(0, 2)) != 24 && Integer.valueOf(InNroCuit.substring(0, 2)) != 27 && Integer.valueOf(InNroCuit.substring(0, 2)) != 34){
      return false;
    }
        
    //Sum total of the entered digits multipled by the digits used in calculation of CUIT for Argentina
    SumaTotal = 0;
    posicion = 0;
    while(posicion < CLFSCARGLEN) {
      Factor = Integer.valueOf( CLFSCARG.substring(posicion, posicion+1) );
      Digito = Integer.valueOf( InNroCuit.substring(posicion, posicion+1) );
      SumaTotal = SumaTotal + (Factor * Digito);
      posicion++;
    }
    
    //Determine if the number entered is a valid CUIT number
    CoeficienteModulo = Math.mod(SumaTotal, CLFSCARGLEN);
    if(CoeficienteModulo != 0) {
      return false;
    }
    
    return true;
  
 }    
    
    
//CMC-3 ---------------------------------------------------- CUIL/CDI Validator ------------------------------------------------------------
  public static boolean isValidCUILCDI(String inNroCuil) {
  
    //system.debug(logginglevel.info, '### Validando CNPJ - Valor ' + InNroCuil);//Commented as part of DPS-19692
    
    boolean ret = false;
    Integer posicion, coeficienteModulo, sumaTotal, digito, factor;
    String cLFSCARG = '54327654321';
    Integer cLFSCARGLEN = 11;
    

    
    //validate number format
    if(!InNroCuil.isNumeric()) {
      return false;
    }
  
   //control length of the entered number.
    if (InNroCuil.length() != CLFSCARGLEN) {
      return false;
    }
    
   //Entered number should not be less than or equal to zero
    if(Double.valueOf(InNroCuil) <= 0){
      return false;
    }  
    //CMC-3
    //Validate first two digit of tax number

    if(Integer.valueOf(InNroCuil.substring(0, 2)) != 20 && Integer.valueOf(InNroCuil.substring(0, 2)) != 23 && Integer.valueOf(InNroCuil.substring(0, 2)) != 24 && Integer.valueOf(InNroCuil.substring(0, 2)) != 27){
      return false;
    }
        
    //Sum total of the entered digits multipled by the digits used in calculation of CUIT for Argentina
    SumaTotal = 0;
    posicion = 0;
    while(posicion < CLFSCARGLEN) {
      Factor = Integer.valueOf( CLFSCARG.substring(posicion, posicion+1) );
      Digito = Integer.valueOf( InNroCuil.substring(posicion, posicion+1) );
      SumaTotal = SumaTotal + (Factor * Digito);
      posicion++;
    }
    
    //Determine if the number entered is a valid CUIT number
    CoeficienteModulo = Math.mod(SumaTotal, CLFSCARGLEN);
    if(CoeficienteModulo != 0) {
      return false;
    }
    
    return true;
  
 } 
//CMC-3 ---------------------------------------------------- DNI/LE/LC Validator ------------------------------------------------------------
  public static boolean isValidDNILELC(String inNroDni) {
  
  //control length of the entered number.
  Integer int1=7, int2=8;
    if (InNroDni.isNumeric()&&(InNroDni.length() == int1|| InNroDni.length() == int2)){ 
      return true;
      }
    else{  
      return false;  
    }
   
  }
//CMC-3 ----------------------------------------------------CI/PASAPORTE Validator ------------------------------------------------------------
  public static boolean isValidCI(String inNroCi) {
  
//validate format
  if (!InNroCi.isAlphanumeric()) {
      return false;
    }
    return true;
  }

  
//BIG RULE ----------------------------------------------------Update Tax and customer fields from Account ------------------------------------------------------------
    @future
    public static void updateLeadFromAccount(Set<ID> newLeadIDs,SET<Id> leadIdSET) {
    List<Lead> newLead  = new List<Lead>();
        if(Schema.sObjectType.Lead.isAccessible()){
            newLead = [SELECT ID, Tax_3__c, Tax_4__c, Tax_Number_Type__c, Customer_Class__c, Customer_Group__c, Account__c FROM Lead WHERE ID IN :newLeadIDs]; 
        }
        Map<id,Account> accntMap=new Map<id,Account>([SELECT Id,Tax_3__c,Tax_4__c,Tax_Number_Type__c,Customer_Class_c__c,Customer_Group__c FROM ACCOUNT WHERE ID IN :LeadIdSET]);
        if(accntMap != null){
            for(Lead l: newLead){   
                if(accntMap.get(l.Account__c) != null){            
                    l.Tax_3__c = accntMap.get(l.Account__c).Tax_3__c!= null && accntMap.get(l.Account__c).Tax_3__c!='' ? accntMap.get(l.Account__c).Tax_3__c : l.Tax_3__c;
                    l.Tax_4__c = accntMap.get(l.Account__c).Tax_4__c!= null && accntMap.get(l.Account__c).Tax_4__c!='' ? accntMap.get(l.Account__c).Tax_4__c : l.Tax_4__c;
                    l.Tax_Number_Type__c = accntMap.get(l.Account__c).Tax_Number_Type__c!= null && accntMap.get(l.Account__c).Tax_Number_Type__c!='' ? accntMap.get(l.Account__c).Tax_Number_Type__c : l.Tax_Number_Type__c;
                    l.Customer_Class__c = accntMap.get(l.Account__c).Customer_Class_c__c!= null && accntMap.get(l.Account__c).Customer_Class_c__c!='' ? accntMap.get(l.Account__c).Customer_Class_c__c : l.Customer_Class__c; 
                    l.Customer_Group__c = accntMap.get(l.Account__c).Customer_Group__c!= null && accntMap.get(l.Account__c).Customer_Group__c!='' ? accntMap.get(l.Account__c).Customer_Group__c: l.Customer_Group__c; 
                }                          
            
            }
        }
        if(Schema.sObjectType.Lead.isUpdateable()){
            update newLead;
        }
        //System.debug('inFutureContext : '+LeadTriggerHandler.inFutureContext);//Commented as part of DPS-19692
        LeadTriggerHandler.inFutureContext = true;
    }
/*
   public void updateLeadFromAccount(List<Lead> newLead,SET<Id> LeadIdSET) {
        
       Map<id,Account> accntMap=new Map<id,Account>([SELECT Id,Tax_3__c,Tax_4__c,Tax_Number_Type__c,Customer_Class_c__c,Customer_Group__c FROM ACCOUNT WHERE ID IN :LeadIdSET]);
        if(accntMap != null){
            for(Lead l: newLead){   
                if(accntMap.get(l.Account__c) != null){            
                    l.Tax_3__c = accntMap.get(l.Account__c).Tax_3__c!= null && accntMap.get(l.Account__c).Tax_3__c!='' ? accntMap.get(l.Account__c).Tax_3__c : l.Tax_3__c;
                    l.Tax_4__c = accntMap.get(l.Account__c).Tax_4__c!= null && accntMap.get(l.Account__c).Tax_4__c!='' ? accntMap.get(l.Account__c).Tax_4__c : l.Tax_4__c;
                    l.Tax_Number_Type__c = accntMap.get(l.Account__c).Tax_Number_Type__c!= null && accntMap.get(l.Account__c).Tax_Number_Type__c!='' ? accntMap.get(l.Account__c).Tax_Number_Type__c : l.Tax_Number_Type__c;
                    l.Customer_Class__c = accntMap.get(l.Account__c).Customer_Class_c__c!= null && accntMap.get(l.Account__c).Customer_Class_c__c!='' ? accntMap.get(l.Account__c).Customer_Class_c__c : l.Customer_Class__c; 
                    l.Customer_Group__c = accntMap.get(l.Account__c).Customer_Group__c!= null && accntMap.get(l.Account__c).Customer_Group__c!='' ? accntMap.get(l.Account__c).Customer_Group__c: l.Customer_Group__c; 
                }                          
            
            }
        }
        
    } */
    /* Update record type for lead based on the sub-bu value */
    /*public void updaterecordtype(List<Lead> leadList){
        for(Lead obj: leadList){
            if(obj.LCRM_Sub_BU__c == 'UKI')
               { obj.recordtypeid=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('UKI').getRecordTypeId();
                 obj.Is_GLI__c= true; }
            else if(obj.LCRM_Sub_BU__c == 'Elite') 
                {obj.recordtypeid=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite').getRecordTypeId();
                 obj.Is_GLI__c= true;}
            else
                {obj.recordtypeid=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
                 obj.Is_GLI__c=false;}     
        }
    }*/
    
    //Commented as part of DPS-6078
    //Method added by LCRM to call furture method to verify Phone & Email fields using StrikeIron
    /*public static boolean verifyEmailAndPhoneRecCheck= false;
    public void verifyEmailAndPhone(List<Lead> leadListOld, List<Lead> leadListNew){
        Boolean loggedinUserFlag = LCRMGenericComponent.StrikeIronCheckActive();
        //System.debug('loggedinUserFlag :'+loggedinUserFlag);//Commented as part of DPS-19692
        if(loggedinUserFlag==true && (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
            return;
        }
        
        Id eliteRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite').getRecordTypeId();
        Id ukiRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('UKI').getRecordTypeId();
        Id gliRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        Set<ID> leadIdList = new Set<ID>();
        //if condition for insert check
        if(leadListOld == null || leadListOld.size()==0){
            for(Lead ld : leadListNew){
               //System.debug('Elite Lead : '+ld);//Commented as part of DPS-19692
                //if block to update timestamps
                if(Trigger.isBefore){
                    if(ld.LCRM_Email_Verification__c != null && ld.LCRM_Email_Verification__c !=''){
                        ld.LCRM_Email_Verification_TimeStamp__c = DateTime.Now();
                    }
                    if(ld.LCRM_Phone_Verification__c != null && ld.LCRM_Phone_Verification__c !=''){
                        ld.LCRM_Phone_Verification_TimeStamp__c = DateTime.Now();
                    }
                    if(ld.LCRM_Mobile_Verification__c != null && ld.LCRM_Mobile_Verification__c !=''){
                        ld.LCRM_Mobile_Verification_TimeStamp__c = DateTime.Now();
                    }
                }
                
                if(ld.recordTypeId==eliteRecordTypeId || ld.recordTypeId==ukiRecordTypeId || ld.recordTypeId == gliRecordTypeId){ 
                    //retrieve ISD codes from custom setting to standarize the phone numbers
                    LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                    if(ld.Billing_Country__c != null && ld.Billing_Country__c !=''){
                        dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(ld.Billing_Country__c);
                    }
                    //System.debug('dialCode : '+ld.Billing_Country__c+' : '+dialCode);//Commented as part of DPS-19692
                    
                    //Email field check 
                    if(ld.Email!= null && ld.Email!='' && (ld.LCRM_Email_Verification__c == null || ld.LCRM_Email_Verification__c =='' || ld.LCRM_Email_Verification__c =='Pending. Please refresh.')){
                        if(Trigger.isAfter){
                            leadIdList.add(ld.ID);
                        }
                        if(Trigger.isBefore){
                            if(!loggedinUserFlag){
                                ld.LCRM_Email_Verification__c = 'Pending. Please refresh.';
                            }else{
                                ld.LCRM_Email_Verification__c = '';
                            }
                            ld.LCRM_Email_Verification_TimeStamp__c = null;
                        }
                    }
                    
                    //Phone field check
                    if(ld.Phone!= null && ld.Phone!='' && (ld.LCRM_Phone_Verification__c == null || ld.LCRM_Phone_Verification__c =='' || ld.LCRM_Phone_Verification__c =='Pending. Please refresh.')){
                        //System.debug('1test after : '+Trigger.isAfter+':'+ld.Phone+':'+ld.Id);//Commented as part of DPS-19692
                        if(ld.Phone.startsWith('+') || ld.Phone.startsWith('00')){
                            //System.debug('test after : '+Trigger.isAfter+':'+ld.Phone+':'+ld.Id);//Commented as part of DPS-19692
                            if(Trigger.isAfter){
                                leadIdList.add(ld.ID);
                            }
                            if(Trigger.isBefore){
                                if(!loggedinUserFlag){
                                    ld.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Phone_Verification__c = '';
                                }
                                ld.LCRM_Phone_Verification_TimeStamp__c = null;
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                leadIdList.add(ld.ID);
                            }
                            if(Trigger.isBefore){
                                // ld.Phone = '+'+dialCode.LCRM_ISD_Code__c + ld.Phone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    ld.Phone = '+'+dialCode.LCRM_ISD_Code__c + ld.Phone; // Added by Shovon w.r.t. CRM-10134
                                    ld.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Phone_Verification__c = '';
                                }
                                ld.LCRM_Phone_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                    
                    //mobile Phone field check
                    if(ld.MobilePhone!= null && ld.MobilePhone!='' && (ld.LCRM_Mobile_Verification__c == null || ld.LCRM_Mobile_Verification__c =='' || ld.LCRM_Mobile_Verification__c =='Pending. Please refresh.')){
                        if(ld.MobilePhone.startsWith('+') || ld.MobilePhone.startsWith('00')){
                            if(Trigger.isAfter){
                                leadIdList.add(ld.ID);
                            }
                            if(Trigger.isBefore){
                                if(!loggedinUserFlag){
                                    ld.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Mobile_Verification__c = '';
                                }
                                ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                leadIdList.add(ld.ID);
                            }
                            if(Trigger.isBefore){
                                // ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                                    ld.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Mobile_Verification__c = '';
                                }
                                ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                }
            }    
        }else{//update block
            Integer i = 0;
            Set<id> ldIDsSet = new Set<ID>();
            for(Lead ld : leadListNew){
                if(ld.recordTypeId==eliteRecordTypeId || ld.recordTypeId==ukiRecordTypeId || ld.recordTypeId == gliRecordTypeId){
                    ldIDsSet.add(ld.ID);
                }
            }
            Map<ID,Lead> leadMap = new Map<ID,Lead>([SELECT ID, Email, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
                                          Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
                                          MobilePhone, LCRM_Mobile_Verification__c, LCRM_Mobile_Verification_TimeStamp__c FROM Lead WHERE ID IN :ldIDsSet]); 
            if(ldIDsSet.size()>0){
                //ldIDsSet = new Set<ID>();
                for(Lead ld : leadListNew){
                    //System.debug('LCRM Lead : '+ld);//Commented as part of DPS-19692
                    if(ld.recordTypeId==eliteRecordTypeId || ld.recordTypeId==ukiRecordTypeId || ld.recordTypeId == gliRecordTypeId){
                        //if stmts to change strikeiron fields to null values if field values are removed
                        if(ld.Email ==null){
                            ld.LCRM_Email_Verification__c = null;
                            ld.LCRM_Email_Verification_TimeStamp__c = null;
                        }
                        if(ld.Phone ==null){
                            ld.LCRM_Phone_Verification__c = null;
                            ld.LCRM_Phone_Verification_TimeStamp__c = null;
                        }
                        if(ld.MobilePhone ==null){
                            ld.LCRM_Mobile_Verification__c = null;
                            ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                        }
                        
                        //condition to handle double update
                        //Commented below system.debugs as part of DPS-19692                       
                        //system.debug('@@@@' + ld.Email);
                        //system.debug('@@@@' + leadListOld[i].Email);
                        //system.debug('@@@@ ' + ld.phone);
                        //system.debug('@@@@ ' + leadListOld[i].phone);
                        //system.debug('@@@@' + ld.MobilePhone);
                        //system.debug('@@@@' + leadListOld[i].MobilePhone);
                        
                        if(ld.Email !=null && (ld.Email == leadListOld[i].Email) && (leadMap!=null && leadMap.get(ld.ID)!=null && leadMap.get(ld.ID).Email == ld.Email && ld.LCRM_Email_Verification__c =='Pending. Please refresh.' && leadMap.get(ld.ID).LCRM_Email_Verification__c !='Pending. Please refresh.')){
                            ld.LCRM_Email_Verification__c = leadMap.get(ld.ID).LCRM_Email_Verification__c;
                            ld.LCRM_Email_Verification_TimeStamp__c = leadMap.get(ld.ID).LCRM_Email_Verification_TimeStamp__c;
                        }
                        if(ld.Phone !=null && (ld.Phone == leadListOld[i].Phone) && (leadMap!=null && leadMap.get(ld.ID)!=null && leadMap.get(ld.ID).Phone == ld.Phone && ld.LCRM_Phone_Verification__c =='Pending. Please refresh.' && leadMap.get(ld.ID).LCRM_Phone_Verification__c !='Pending. Please refresh.')){
                            ld.LCRM_Phone_Verification__c = leadMap.get(ld.ID).LCRM_Phone_Verification__c;
                            ld.LCRM_Phone_Verification_TimeStamp__c = leadMap.get(ld.ID).LCRM_Phone_Verification_TimeStamp__c;
                        }
                        if(ld.MobilePhone !=null && (ld.MobilePhone == leadListOld[i].MobilePhone) && (leadMap!=null && leadMap.get(ld.ID)!=null && leadMap.get(ld.ID).MobilePhone == ld.MobilePhone && ld.LCRM_Mobile_Verification__c =='Pending. Please refresh.' && leadMap.get(ld.ID).LCRM_Mobile_Verification__c !='Pending. Please refresh.')){
                            ld.LCRM_Mobile_Verification__c = leadMap.get(ld.ID).LCRM_Mobile_Verification__c;
                            ld.LCRM_Mobile_Verification_TimeStamp__c = leadMap.get(ld.ID).LCRM_Mobile_Verification_TimeStamp__c;
                        }
                            
                    
                    
                        //System.debug('beforeaaa : '+ld.LCRM_Email_Verification__c);//Commented as part of DPS-19692
                        //condition to flag error message to stop double update on email/phone field when strike iron verificationb is still in progress
                        if(((ld.LCRM_Email_Verification__c =='Pending. Please refresh.' || (ld.LCRM_Email_Verification__c =='' && leadMap!=null && leadMap.get(ld.ID)!=null && leadMap.get(ld.ID).LCRM_Email_Verification__c =='Pending. Please refresh.')) && leadListOld[i].Email != ld.Email)
                            || 
                            ((ld.LCRM_Phone_Verification__c =='Pending. Please refresh.' || (ld.LCRM_Phone_Verification__c =='' && leadMap!=null && leadMap.get(ld.ID)!=null && leadMap.get(ld.ID).LCRM_Phone_Verification__c =='Pending. Please refresh.')) && leadListOld[i].Phone != ld.Phone)
                            || 
                            ((ld.LCRM_Mobile_Verification__c =='Pending. Please refresh.' || (ld.LCRM_Mobile_Verification__c =='' && leadMap!=null && leadMap.get(ld.ID)!=null && leadMap.get(ld.ID).LCRM_Mobile_Verification__c =='Pending. Please refresh.')) && leadListOld[i].MobilePhone != ld.MobilePhone)
                            ){
                            if(!loggedinUserFlag){
                                ld.addError(System.label.LCRM_LeadUpdateWarningStrikeIron.replace('<link>','<a href=\'/'+ld.id+'\'>{!$Label.Click_to_refresh}</a>'), False);
                            }
                            continue;
                        }
                        
                        //retrieve ISD codes from custom setting to standarize the phone numbers
                        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                        if(ld.Billing_Country__c != null && ld.Billing_Country__c !=''){
                            dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(ld.Billing_Country__c);
                        }
                        //System.debug('dialCode : '+ld.Billing_Country__c+' : '+dialCode);//Commented as part of DPS-19692
                        
                        //block to check email field for verification/update
                        if(ld.Email!= null && ld.Email!='' && (leadListOld[i].Email != ld.Email || ld.LCRM_Email_Verification__c == null || 
                         ld.LCRM_Email_Verification__c =='' || (!loggedinUserFlag && ld.LCRM_Email_Verification__c!=null && ld.LCRM_Email_Verification__c!='' && ld.LCRM_Email_Verification__c.contains('Exception')))){
                            //system.debug('@@ Email is not null');//Commented as part of DPS-19692
                            leadIdList.add(ld.ID);
                            if(!loggedinUserFlag){
                                ld.LCRM_Email_Verification__c = 'Pending. Please refresh.';
                            }else{
                                ld.LCRM_Email_Verification__c = '';
                            }
                            ld.LCRM_Email_Verification_TimeStamp__c = null;
                        }
                        
                        //block to check phone field for verification/update
                        if(ld.Phone!= null && ld.Phone!='' && (leadListOld[i].Phone != ld.Phone || ld.LCRM_Phone_Verification__c == null || 
                         ld.LCRM_Phone_Verification__c =='' || (!loggedinUserFlag && ld.LCRM_Phone_Verification__c!=null && ld.LCRM_Phone_Verification__c!='' && ld.LCRM_Phone_Verification__c.contains('Exception')))){
                            //system.debug('@@ Email is not null');//Commented as part of DPS-19692
                            if(ld.Phone.startsWith('+') || ld.Phone.startsWith('00')){
                                leadIdList.add(ld.ID);
                                if(!loggedinUserFlag){
                                    ld.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Phone_Verification__c = '';
                                }
                                ld.LCRM_Phone_Verification_TimeStamp__c = null;
                            }else if(dialCode != null){
                                leadIdList.add(ld.ID);
                                // ld.Phone = '+'+dialCode.LCRM_ISD_Code__c + ld.Phone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    ld.Phone = '+'+dialCode.LCRM_ISD_Code__c + ld.Phone; // Added by Shovon w.r.t. CRM-10134
                                    ld.LCRM_Phone_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Phone_Verification__c = '';
                                }
                                ld.LCRM_Phone_Verification_TimeStamp__c = null;
                            }
                        }
                        
                        //block to check mobile phone field for verification/update
                        if(ld.MobilePhone!= null && ld.MobilePhone!='' && (leadListOld[i].MobilePhone != ld.MobilePhone || ld.LCRM_Mobile_Verification__c == null || 
                         ld.LCRM_Mobile_Verification__c =='' || (!loggedinUserFlag && ld.LCRM_Mobile_Verification__c!=null && ld.LCRM_Mobile_Verification__c!='' && ld.LCRM_Mobile_Verification__c.contains('Exception')))){
                            //system.debug('@@ Email is not null');//Commented as part of DPS-19692
                            if(ld.MobilePhone.startsWith('+') || ld.MobilePhone.startsWith('00')){
                                leadIdList.add(ld.ID);
                                if(!loggedinUserFlag){
                                    ld.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Mobile_Verification__c = '';
                                }
                                ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }else if(dialCode != null){
                                leadIdList.add(ld.ID);
                                // ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone; Commented by Shovon w.r.t. CRM-10134
                                if(!loggedinUserFlag){
                                    ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                                    ld.LCRM_Mobile_Verification__c = 'Pending. Please refresh.';
                                }else{
                                    ld.LCRM_Mobile_Verification__c = '';
                                }
                                ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                            }
                        }
                    }
                    i = i+1;
                }
            }
        }
        //System.debug('leadIdList : '+leadIdList);//Commented as part of DPS-19692
        if(!loggedinUserFlag && leadIdList!=null && leadIdList.size()>0){
            //future method invoked to make callouts to webservices
            verifyEmailAndPhoneFuture(leadIdList);
        }
    } 
     
    //Method added by LCRM to verify Phone & Email fields using StrikeIron
    @future(callout=true)
    public static void verifyEmailAndPhoneFuture(Set<ID> leadIdList){
        LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
        List<LCRM_Exception_Log__c> excepObjList = new List<LCRM_Exception_Log__c>();
        try{
        List<Lead> leadList  = new List<Lead>();
            if(Schema.sObjectType.Lead.isAccessible())
             leadList = [SELECT ID, Email, LCRM_Email_Verification__c, LCRM_Email_Verification_TimeStamp__c, 
                                              Phone, LCRM_Phone_Verification__c, LCRM_Phone_Verification_TimeStamp__c,
                                              MobilePhone, LCRM_Mobile_Verification__c, LCRM_Mobile_Verification_TimeStamp__c FROM Lead WHERE ID IN :leadIdList];
            LCRMStrikeIronServices servObj;
            String phone = '';
            //loop to create list of phone and email values for making callout to strike iron services
            for(Lead ld : leadList){
                servObj = new LCRMStrikeIronServices();
                if(ld.LCRM_Email_Verification__c == 'Pending. Please refresh.'){
                    //making callout to email strikiron services
                    String emailStatus = servObj.callEmailValidation(ld.Email);
                    //String emailStatus = 'Exception';
                    //System.debug('emailStatus : '+emailStatus);//Commented as part of DPS-19692
                    if(emailStatus!=null && emailStatus!='' && emailStatus.contains('Exception')){
                        if(emailStatus == 'Exception : Email Service not configured.' || emailStatus == 'Exception : Email Service not active.'){
                            ld.LCRM_Email_Verification__c = emailStatus;
                        }else{
                            ld.LCRM_Email_Verification__c = 'Exception in Verification Service.';
                        }
                        ld.LCRM_Email_Verification_TimeStamp__c = null;
                        LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                        excepObj.LCRM_Exception_Message__c = '';
                        excepObj.LCRM_Exception_Trace__c = emailStatus;
                        excepObj.LCRM_Exception_Type__c = 'StrikeIron Lead Email';
                        excepObj.LCRM_Record_Ids__c = String.valueOf(leadIdList);
                        excepObj.LCRM_User_ID__c = userinfo.getUserId();
                        excepObjList.add(excepObj);
                    }else if(emailStatus!=null && emailStatus!=''){
                        ld.LCRM_Email_Verification__c = emailStatus;
                        ld.LCRM_Email_Verification_TimeStamp__c = DateTime.Now();
                    }else{
                        ld.LCRM_Email_Verification__c = '';
                        ld.LCRM_Email_Verification_TimeStamp__c = null;
                    }
                }
                
                if(ld.LCRM_Phone_Verification__c == 'Pending. Please refresh.'){
                    phone = phone + ((phone==null || phone=='')?'':',') + ld.Phone;
                }
                if(ld.LCRM_Mobile_Verification__c == 'Pending. Please refresh.'){
                    phone = phone + ((phone==null || phone=='')?'':',') + ld.MobilePhone;
                }
            }
            //block to make callout to strikeiron for phone field verification
            if(phone!=null && phone!=''){
                Map<String, String> reponsePhone = servObj.callPhoneValidation(phone);
                //System.debug('reponsePhone : '+reponsePhone);//Commented as part of DPS-19692
                for(Lead ld : leadList){
                    //block to update phone field accourdingly after strikiron callout
                    if(ld.LCRM_Phone_Verification__c == 'Pending. Please refresh.'){
                        String phoneStatus = reponsePhone.get(ld.Phone);
                        //System.debug('phoneStatus : '+phoneStatus);//Commented as part of DPS-19692
                        if(phoneStatus!=null && phoneStatus!='' && phoneStatus.contains('Exception')){
                            if(phoneStatus == 'Exception : Phone Service not configured.' || phoneStatus == 'Exception : Phone Service not active.'){
                                ld.LCRM_Phone_Verification__c = phoneStatus;
                            }else{
                                ld.LCRM_Phone_Verification__c = 'Exception in Verification Service.';
                            }
                            ld.LCRM_Phone_Verification_TimeStamp__c = null;
                            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                            excepObj.LCRM_Exception_Message__c = 'Phone';
                            excepObj.LCRM_Exception_Trace__c = phoneStatus;
                            excepObj.LCRM_Exception_Type__c = 'StrikeIron Lead Phone';
                            excepObj.LCRM_Record_Ids__c = String.valueOf(ld.ID);
                            excepObj.LCRM_User_ID__c = userinfo.getUserId();
                            excepObjList.add(excepObj);
                        }else if(phoneStatus!=null && phoneStatus!=''){
                            ld.LCRM_Phone_Verification__c = phoneStatus;
                            ld.LCRM_Phone_Verification_TimeStamp__c = DateTime.Now();
                        }else{
                            ld.LCRM_Phone_Verification__c = '';
                            ld.LCRM_Phone_Verification_TimeStamp__c = null;
                        }
                    }
                    
                    //block to update mobile phone field accourdingly after strikiron callout
                    if(ld.LCRM_Mobile_Verification__c == 'Pending. Please refresh.'){
                        String mobileStatus = reponsePhone.get(ld.MobilePhone);
                        //System.debug('mobileStatus : '+mobileStatus);//Commented as part of DPS-19692
                        if(mobileStatus!=null && mobileStatus!='' && mobileStatus.contains('Exception')){
                            if(mobileStatus == 'Exception : Phone Service not configured.' || mobileStatus == 'Exception : Phone Service not active.'){
                                ld.LCRM_Mobile_Verification__c = mobileStatus;
                            }else{
                                ld.LCRM_Mobile_Verification__c = 'Exception in Verification Service.';
                            }
                            ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
                            excepObj.LCRM_Exception_Message__c = 'MobilePhone';
                            excepObj.LCRM_Exception_Trace__c = mobileStatus;
                            excepObj.LCRM_Exception_Type__c = 'StrikeIron Lead Phone';
                            excepObj.LCRM_Record_Ids__c = String.valueOf(ld.ID);
                            excepObj.LCRM_User_ID__c = userinfo.getUserId();
                            excepObjList.add(excepObj);
                        }else if(mobileStatus!=null && mobileStatus!=''){
                            ld.LCRM_Mobile_Verification__c = mobileStatus;
                            ld.LCRM_Mobile_Verification_TimeStamp__c = DateTime.Now();
                        }else{
                            ld.LCRM_Mobile_Verification__c = '';
                            ld.LCRM_Mobile_Verification_TimeStamp__c = null;
                        }
                    }
                }
            }
            //System.debug('leadList : '+leadList);//Commented as part of DPS-19692
            if(Schema.sObjectType.lead.isUpdateable())
            update leadList;
        }catch(Exception e){
            //System.debug('Exception : '+e.getMessage()+' : '+e.getStackTraceString());//Commented as part of DPS-19692
            LCRM_Exception_Log__c excepObj = new LCRM_Exception_Log__c();
            excepObj.LCRM_Exception_Message__c = e.getMessage();
            excepObj.LCRM_Exception_Trace__c = e.getStackTraceString();
            excepObj.LCRM_Exception_Type__c = 'StrikeIron Lead Email & Phone';
            excepObj.LCRM_Record_Ids__c = String.valueOf(leadIdList);
            excepObj.LCRM_User_ID__c = userinfo.getUserId();
            excepObjList.add(excepObj);
        }
        if(excepObjList!=null && excepObjList.size()>0){
            if(Schema.sObjectType.LCRM_Exception_Log__c.isCreateable()){
            insert excepObjList;}
        }
    } */
    
    public void validateGLIAccountNotAssociatedToS2ELead(List<Lead> lstNewLead)
    {
        List<Lead> lstLead = new List<Lead>();
        Set<Id> setAccountId = new Set<Id>();
        Map<Id, Account> mapAccount;
        
        for(Lead oLead : lstNewLead)
        {
            if(!oLead.is_GLI__c && oLead.Account__c != null)
            {
                lstLead.add(oLead);
                setAccountId.add(oLead.Account__c);
            }
            
        }
        
        if(lstLead.size() > 0)
        {
            mapAccount = new Map<Id,Account>([ Select id, is_Gli__c from Account where id IN :setAccountId]);
            
            for(Lead oLead : lstLead)
            {
                if(mapAccount.containsKey(oLead.Account__c))
                {
                    Account oAccount = mapAccount.get(oLead.Account__c);
                    if(oAccount.Is_Gli__c)
                    {
                        oLead.addError(Label.LCRM_S2E_Lead_Convert_Error.escapeHtml4(), false);
                    }
                }
            }
        }
    }
    //Added for CRM-15772
    public void updateLastUpdatedByLeadOwner(List<Lead> listLeads){
        for(Lead oLead : listLeads)
        {
            if(oLead.is_GLI__c){
                oLead.Last_Updated_By_Lead_Owner__c = System.NOW();
            }
        }
    }
        //Method added as part of DPS-6078
    public void addISDcodeWithPhoneOrMobile(List<Lead> leadListOld, List<Lead> leadListNew){
        
        Id eliteRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite').getRecordTypeId();
        Id ukiRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('UKI').getRecordTypeId();
        Id gliRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        
        List<Id> leadIdList = new List<Id>();
        if(CheckRecursive.lCRMRecursivecheck_Lead()){
        //Insert Flow
        if(leadListOld == null || leadListOld.size()==0){
            for(Lead ld : leadListNew){
                LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                if(ld.Billing_Country__c != null && ld.Billing_Country__c !=''){
                    dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(ld.Billing_Country__c);
                }
                //System.debug('dialCode : '+ld.Billing_Country__c+' : '+dialCode);//Commented as part of DPS-19692
                //Phone field check
                if(ld.Phone!= null && ld.Phone!='' /*&& (ld.LCRM_Phone_Verification__c == null || ld.LCRM_Phone_Verification__c =='' || ld.LCRM_Phone_Verification__c =='Pending. Please refresh.')*/){
                    
                    //LOC-4414 - StrikeIron - International Phone Format on Lead
                    //System.debug('1test after : '+Trigger.isAfter+':'+ld.Phone+':'+ld.Id);//Commented as part of DPS-19692
                    if(ld.Phone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && ld.Phone.startsWith(dialCode.LCRM_International_Prefix__c))){
                       // System.debug('test after : '+Trigger.isAfter+':'+ld.Phone+':'+ld.Id);//Commented as part of DPS-19692
                        if(Trigger.isAfter){
                            leadIdList.add(ld.ID);
                        }else if(dialCode != null){
                            if(Trigger.isAfter){
                                leadIdList.add(ld.ID);
                            }
                        }
                        if(Trigger.isBefore){
                           // system.debug('inside isBefore :' );//Commented as part of DPS-19692
                            if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && ld.Phone.length()>=dialCode.LCRM_Minimum_Length__c && ld.Phone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                ld.Phone = '+' + ld.Phone; // Added by Shovon w.r.t. CRM-10134
                            }else{
                                ld.Phone = '+'+dialCode.LCRM_ISD_Code__c + ld.Phone;  // Added by Shovon w.r.t. CRM-10134
                            }
                        }
                    }
                    
                }
                
                
                //mobile Phone field check
                if(ld.MobilePhone!= null && ld.MobilePhone!='' /*&& (ld.LCRM_Mobile_Verification__c == null || ld.LCRM_Mobile_Verification__c =='' || ld.LCRM_Mobile_Verification__c =='Pending. Please refresh.')*/){
                    //LOC-4414 - StrikeIron - International Phone Format on Lead - MobilePhone
                    if(ld.MobilePhone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && ld.MobilePhone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                        if(Trigger.isAfter){
                            leadIdList.add(ld.ID);
                        }
                    }else if(dialCode != null){
                        if(Trigger.isAfter){
                            leadIdList.add(ld.ID);
                        }
                        if(Trigger.isBefore){
                            //LOC-4414 - StrikeIron - International Phone Format on Lead - MobilePhone Minimum Length Consideration
                            if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && ld.MobilePhone.length()>=dialCode.LCRM_Minimum_Length__c && ld.MobilePhone.startsWith (dialCode.LCRM_ISD_Code__c)){
                                ld.MobilePhone = '+' + ld.MobilePhone; // Added by Shovon w.r.t. CRM-10134
                            }else{
                                ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone;  // Added by Shovon w.r.t. CRM-10134
                            }
                        }
                    }
                }
            }
        }else{ //Update Flow
            Integer i = 0;
            Set<id> ldIDsSet = new Set<ID>();
            for(Lead ld : leadListNew){
                //LOC-4404 - Added LatAm Recordtype
                if(ld.recordTypeId==eliteRecordTypeId || ld.recordTypeId==ukiRecordTypeId || ld.recordTypeId == gliRecordTypeId ){
                    ldIDsSet.add(ld.ID);
                }
            }
            Map<ID,Lead> leadMap = new Map<ID,Lead>([SELECT ID, Email, Phone, MobilePhone FROM Lead WHERE ID IN :ldIDsSet]); 
            if(ldIDsSet.size()>0){
                //ldIDsSet = new Set<ID>();
                for(Lead ld : leadListNew){
                    //System.debug('LCRM Lead : '+ld);//Commented as part of DPS-19692
                    //retrieve ISD codes from custom setting to standarize the phone numbers
                    LCRM_StrikeIron_CountryCodes__c dialCode = new LCRM_StrikeIron_CountryCodes__c();
                    if(ld.Billing_Country__c != null && ld.Billing_Country__c !=''){
                        dialCode = LCRM_StrikeIron_CountryCodes__c.getInstance(ld.Billing_Country__c);
                    }
                    //System.debug('dialCode : '+ld.Billing_Country__c+' : '+dialCode);//Commented as part of DPS-19692
                    
                    //block to check email field for verification/update
                    if(ld.Email!= null && ld.Email!='' && (leadListOld[i].Email != ld.Email )){
                        //system.debug('@@ Email is not null');//Commented as part of DPS-19692
                        leadIdList.add(ld.ID);
                    }
                    
                    //block to check phone field for verification/update
                    if(ld.Phone!= null && ld.Phone!='' && (leadListOld[i].Phone != ld.Phone )){
                       // system.debug('@@ Email is not null');//Commented as part of DPS-19692
                        
                        //LOC-4414 - StrikeIron - International Phone Format for Lead 
                        
                        if(ld.Phone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && ld.Phone.startsWith(dialCode.LCRM_International_Prefix__c) )){
                            leadIdList.add(ld.ID);
                        }else if(dialCode != null){
                            leadIdList.add(ld.ID);
                            if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && ld.Phone.length()>=dialCode.LCRM_Minimum_Length__c && ld.Phone.startsWith(dialCode.LCRM_ISD_Code__c) ){
                                ld.Phone = '+' + ld.Phone; // Added by Shovon w.r.t. CRM-10134
                            }else{
                                ld.Phone = '+'+dialCode.LCRM_ISD_Code__c + ld.Phone;  // Added by Shovon w.r.t. CRM-10134
                            }
                        }
                    }
                    
                    //block to check mobile phone field for verification/update
                    if(ld.MobilePhone!= null && ld.MobilePhone!='' && (leadListOld[i].MobilePhone != ld.MobilePhone )){
    //system.debug('@@ Email is not null');//Commented as part of DPS-19692
    //LOC - 4414 - International Phone Format for Lead
    if(ld.MobilePhone.startsWith('+') || (dialCode!=null && (dialCode.LCRM_International_Prefix__c !=null && dialCode.LCRM_International_Prefix__c !='') && ld.MobilePhone.startsWith(dialCode.LCRM_International_Prefix__c) )){
        leadIdList.add(ld.ID);
    }else if(dialCode != null){
        //system.debug('inside dialcode!=null');//Commented as part of DPS-19692
        leadIdList.add(ld.ID);
        // ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone; Commented by Shovon w.r.t. CRM-10134
        //LOC - 4414 - International Phone Format for Lead - Minimum Length Consideration
        if(dialCode.LCRM_Minimum_Length__c!=null && dialCode.LCRM_Minimum_Length__c!=0 && ld.MobilePhone.length()>=dialCode.LCRM_Minimum_Length__c && ld.MobilePhone.startsWith (dialCode.LCRM_ISD_Code__c)){
            //system.debug('inside if');//Commented as part of DPS-19692
            ld.MobilePhone = '+'+ ld.MobilePhone; // Added by Shovon w.r.t. CRM-10134
        }else{
            //system.debug('inside else');//Commented as part of DPS-19692
            ld.MobilePhone = '+'+dialCode.LCRM_ISD_Code__c + ld.MobilePhone;  // Added by Shovon w.r.t. CRM-10134
        }
        
    }
}
                }
            }
                    i = i+1;
                
                
            }
        }
    } 
    
    public void rejectionReasonValidation(Map<Id, Lead> oldMap, Map<Id, Lead> newMap){
        Id s2eRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('S2E').getRecordTypeId();
        for(Lead l : newMap.values()){
            if(l.recordTypeID != s2eRecordTypeId){
                continue;
            }
            if(l.LatAm_Created_by_Partner__c == true && l.Approval_status__c == 'Rejected' && oldMap.get(l.Id)!=null && oldMap.get(l.Id).Approval_status__c!='Rejected' && (l.Rejected_Reason__c==null || l.Rejected_Reason__c=='')){
                l.addError(System.Label.LatAmRejectionReasonError);
            }
            approvedLatAmError(l, oldMap.get(l.Id));
        }
    }

    private void approvedLatAmError(Lead newLead, Lead oldLead){
        String errMsg = '';
        errMsg = approvedCustomerGroup(newLead, oldLead, errMsg);
        errMsg = approvedCustomerClass(newLead, oldLead, errMsg);
        errMsg = approvedIndustryLatAm(newLead, oldLead, errMsg);
        errMsg = approvedSubIndustryLatAm(newLead, oldLead, errMsg);
        if(errMsg != null && errMsg!= ''){
            newLead.addError(System.Label.LatAm_LeadApprovalReqFields + ' ' + errMsg);
        }
    }

    private String approvedCustomerGroup(Lead newLead, Lead oldLead, String errMsg){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Lead');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        String lbl = fieldMap.get('Customer_Group__c').getDescribe().getLabel();
        if(newLead.LatAm_Created_by_Partner__c == true && newLead.Approval_status__c == 'Approved' && oldLead!=null && oldLead.Approval_status__c!='Approved' && (newLead.Customer_Group__c==null || newLead.Customer_Group__c=='')){
            errMsg = (errMsg != null && errMsg!= '')?errMsg+', '+lbl : lbl;
        }
        return errMsg;
    }

    private String approvedCustomerClass(Lead newLead, Lead oldLead, String errMsg){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Lead');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        String lbl = fieldMap.get('Customer_Class__c').getDescribe().getLabel();
        if(newLead.LatAm_Created_by_Partner__c == true && newLead.Approval_status__c == 'Approved' && oldLead!=null && oldLead.Approval_status__c!='Approved' && (newLead.Customer_Class__c==null || newLead.Customer_Class__c=='')){
            errMsg = (errMsg != null && errMsg!= '')?errMsg+', '+lbl : lbl;
        }
        return errMsg;
    }

    private String approvedIndustryLatAm(Lead newLead, Lead oldLead, String errMsg){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Lead');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        String lbl = fieldMap.get('Industry_LatAm__c').getDescribe().getLabel();
        if(newLead.LatAm_Created_by_Partner__c == true && newLead.Approval_status__c == 'Approved' && oldLead!=null && oldLead.Approval_status__c!='Approved' && (newLead.Industry_LatAm__c==null || newLead.Industry_LatAm__c=='')){
            errMsg = (errMsg != null && errMsg!= '')?errMsg+', '+lbl : lbl;
        }
        return errMsg;
    }

    private String approvedSubIndustryLatAm(Lead newLead, Lead oldLead, String errMsg){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Lead');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        String lbl = fieldMap.get('Sub_Industry_LatAm__c').getDescribe().getLabel();
        if(newLead.LatAm_Created_by_Partner__c == true && newLead.Approval_status__c == 'Approved' && oldLead!=null && oldLead.Approval_status__c!='Approved' && (newLead.Sub_Industry_LatAm__c==null || newLead.Sub_Industry_LatAm__c=='')){
            errMsg = (errMsg != null && errMsg!= '')?errMsg+', '+lbl : lbl;
        }
        return errMsg;
    }
    
    //DPS-17696 - Update business Unit (LatAm) and Sales Org on Lead from User
    public static void updateLatAmBUSalesOrg(List<Lead> triggerNewList){
        
        if(CheckRecursive.lCRMRecursivecheck_Lead()){
            List<LaTAm_Business_Unit_Sync__c> listOfBusinesUnitValues = LaTAm_Business_Unit_Sync__c.getAll().values();
                
            Map<String, String> leadUserBUMap = new Map<String, String>();
            for(LaTAm_Business_Unit_Sync__c BU :  listOfBusinesUnitValues ){
                leadUserBUMap.put(bu.User_Business_Unit__c, bu.Lead_Business_Unit__c);        
            }
            
            //Store User Ids from Lead
            List<Id> userIdList = new List<Id>();
            for(Lead ll : triggerNewList){
                userIdList.add(ll.OwnerId);
            }
            
            List<User> userSobjList = new List<User>();
            if(Schema.sObjectType.User.isAccessible()){
                userSobjList = [Select id,name, Business_Unit__c,Sales_Org__c from User Where Id IN :userIdList AND Profile.Name = 'Partner Portal User'];
            }
            
            //Map Id and Business Unit.Sales Org... 
            Map<Id, String> userIdBUMap = new Map<Id, String>();
            Map<Id, String> userIdSalesOrgMap = new Map<Id, String>();
            
            //get Partner Portal User profile owner Ids
            List<Id> listPartnerUserIds = new List<Id>();
            
            //put user Id
            for(User uu : userSobjList){
                userIdBUMap.put(uu.Id, uu.Business_Unit__c);
                userIdSalesOrgMap.put(uu.Id, uu.Sales_Org__c);
                listPartnerUserIds.add(uu.Id);
            }
                
            //Update on Lead record before insertion and updation
            for(Lead leadNew : triggerNewList)
            {
                if(listPartnerUserIds != null && listPartnerUserIds.contains(leadNew.ownerId)){
                    String leadBusinessUnit = userIdBUMap.get(leadNew.OwnerId);
                    
                    if(leadUserBUMap != null && leadUserBUMap.get(leadBusinessUnit) != null && String.isNotBlank(leadBusinessUnit))
                    {
                        leadBusinessUnit= leadUserBUMap.get(leadBusinessUnit);  
                    }
                    
                    leadNew.Business_Unit_LatAm__c = leadBusinessUnit;
                    leadNew.Sales_Org__c = userIdSalesOrgMap.get(leadNew.OwnerId);
                }
            }
        }
    }
    
    public void checkFieldsBeforeApproval(Map<Id, Lead> oldLeadMap, List<Lead> newLeadList){
        for(Lead l:newLeadList){
            if(l.LatAm_Created_by_Partner__c==true && l.Approval_status__c=='Submitted' && oldLeadMap.get(l.Id).Approval_status__c!='Submitted'){
                LatAmLeadApprovalCtrl ctrl = new LatAmLeadApprovalCtrl();
                ctrl.leadDetails = l;
                ctrl.checkRequiredFields();
                if(ctrl.bError == true){
                    l.addError(ctrl.sErrorMsg);           
                }
            }
        }
    }
    public static void updateGSISalesOrg(List<Lead> triggerNewList){
        for(Lead salesorgLead : triggerNewList ){
            if(String.isBlank(salesorgLead.sales_org__c) ){
              salesorgLead.sales_org__c = 'GLI';
            }
        }
    }
}