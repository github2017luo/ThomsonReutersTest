/* CHANGE HISTORY
 ==================================================================================================================================
Date         Name                  Description
2018-06-19   Srikanth Kota         DLT-9757 - APTS_Source_System_Detail_c is update with Proposal Sold To SSD(APTS_SSD_Sold_To_c) and removed Account as per GLI.

==================================================================================================================================   
 */
public class Digital_MasterContactsController {
    // Variables
    public string proposalId = '';
    public Apttus_Proposal__Proposal__c aptProposal;
    public List<Apttus_Proposal__Proposal_Line_Item__c> apliList;
    public List<Apttus_Proposal__Proposal_Line_Item__c> apliUpdList;
    public Set<Id> apliIds;
    Map<Id, String> ipIdsMap; // Map contains Ids of clear and Patron products line Itelms    
    public List<Customer_Master_Contacts__c> mstrConList;
    //public List<Contact> contactList;
    public List<LCRM_Contact_SSD__c > contactssdList;
    public List<MCWrapper> techConList {get; set;}
    public List<MCWrapper> clrPrimaryList {get; set;}
    public List<MCWrapper> pwdEmailList {get; set;}
    public List<MCWrapper> patronConList {get; set;}
    public List<MCWrapper> ebConList {get; set;}
    // Boolean variables for Tabs display
    public Boolean isTechContact {get; set;}
    public Boolean isClrPrimary {get; set;}
    public Boolean isPwdEmailCon {get; set;}
    public Boolean isPatronAccCon {get; set;}
    public Boolean isEbillityCon {get; set;}
    public Boolean isError = False;
    public string techMaterials = '';
    public string clrMaterials = '';
    public string pwdMaterials = '';
    public string patronMaterials = '';
    public string ebillMaterials = '';
    public ipWrapper clrIps {get; set;}
    public ipWrapper patIps {get; set;}
    public string fromIP {get; set;}
    public string toIP {get; set;}
    public string fromIPac {get; set;}
    public string toIPac {get; set;}    
    
    
    
    // Constructor
    public Digital_MasterContactsController(ApexPages.StandardController stdCon) {
        apliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        apliIds = new Set<Id>();
        ipIdsMap = new Map<Id, string>(); 
        aptProposal = new Apttus_Proposal__Proposal__c();
        mstrConList = new List<Customer_Master_Contacts__c>();
        //contactList = new List<Contact>();
        contactssdList = new List<LCRM_Contact_SSD__c>();
        techConList = new List<MCWrapper>();
        clrPrimaryList = new List<MCWrapper>();
        pwdEmailList = new List<MCWrapper>();
        patronConList = new List<MCWrapper>();
        ebConList = new List<MCWrapper>();
        isTechContact = False;
        isClrPrimary = False;
        isPwdEmailCon = False;
        isPatronAccCon = False;
        isEbillityCon = False;
        clrIps = new ipWrapper();
        patIps = new ipWrapper();
        fromIP = '';
        toIP = '';
        fromIPac = '';
        toIPac = '';
        
        
        // get the current page parameter - Id value
       // proposalId = ApexPages.CurrentPage().getParameters().get('id');   // Commented By Dinesh      
        Apttus_Proposal__Proposal__c quote  = (Apttus_Proposal__Proposal__c)stdcon.getrecord(); // Added by Dinesh
        proposalId = quote.id;
        
        if(!string.isEmpty(proposalId)) {
            try {
                //aptProposal = [Select Id, Name, Apttus_Proposal__Account__c, Apttus_Proposal__Account__r.Name, Apttus_Proposal__Account__r.Sales_Org__c, Apttus_Proposal__Account__r.SapAccountNumber__c From Apttus_Proposal__Proposal__c Where Id =: proposalId];
                aptProposal = [Select Id, Name, APTS_SSD_Sold_To__c, APTS_SSD_Sold_To__r.Name, Apttus_Proposal__Account__c,APTS_SSD_Sold_To__r.LCRM_Sales_Org__c, APTS_SSD_Sold_To__r.LCRM_SAP_Account_Number__c, APTS_SSD_Sold_To__r.Source_System_Account_Number__c From Apttus_Proposal__Proposal__c Where Id =: proposalId];
                apliList = [Select Id, Name, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Subscription_Number__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c,  Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name From Apttus_Proposal__Proposal_Line_Item__c Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed') Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last];    
                mstrConList = [SELECT Id, Contact_SDD__c,Contact__c, Customer_Type_Description__c, Email_Address__c, First_Name__c, Last_Name__c, To_IP_Address__c, To_IP_Address1__c, To_IP_Address2__c, From_IP_Address__c, From_IP_Address1__c, From_IP_Address2__c, Phone__c, Quote__c FROM Customer_Master_Contacts__c WHERE Quote__c = : proposalId];
                //contactList = [Select Id, FirstName, LastName, Email, Phone, SAP_Role__c From Contact Where AccountId = :aptProposal.Apttus_Proposal__Account__c AND (SAP_Role__c != null AND SAP_Role__c != '')];
                contactssdList  = [Select Id, LCRM_Contact__c, LCRM_Contact__r.FirstName, LCRM_Contact__r.LastName, LCRM_Contact__r.Email, LCRM_Contact__r.Phone, LCRM_SAP_Role__c From LCRM_Contact_SSD__c Where LCRM_Contact__r.AccountId = :aptProposal.Apttus_Proposal__Account__c AND (LCRM_SAP_Role__c != null AND LCRM_SAP_Role__c != '')];
                
                System.debug('apliList======1'+apliList );
                System.debug('mstrConList===========2'+mstrConList );
                System.debug('contactList==========3'+contactssdList  );
                
                // Identify the types products and set the flags to rendered the tabs
                for(Apttus_Proposal__Proposal_Line_Item__c aplis :apliList) {
                    if((!OnlineContactsController.validateProductLLCode((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c+aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP') {
                         if(aplis.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '064') {
                             isTechContact = True;
                             apliIds.add(aplis.Id);
                             techMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                         } 
                         if(aplis.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '076') {
                             isClrPrimary = True;
                             apliIds.add(aplis.Id);
                             ipIdsMap.put(aplis.Id, 'Clear');
                              clrMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                         }
                         
                        // if((!OnlineContactsController.validateProductLLCode((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c+aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP')
                             if(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' || aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' || aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13') {
                                 isPwdEmailCon = True;
                                  apliIds.add(aplis.Id);
                                  pwdMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                             }
                         
                         if((!string.isEmpty(aplis.Apttus_Proposal__Product__r.Name) && aplis.Apttus_Proposal__Product__r.Name.Contains('Patron Access')) || aplis.Apttus_Proposal__Product__r.ProductCode == '41727130' || aplis.Apttus_Proposal__Product__r.Subscription_Number__c == '41727130' || aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c == 'L5_L1451_FP' || aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c == 'L5_L0064_FP') {
                             isPatronAccCon = True;
                             apliIds.add(aplis.Id);
                             ipIdsMap.put(aplis.Id, 'Patron');
                              patronMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                         } 
                         if(aplis.Apttus_Proposal__Product__r.ProductCode == '41409998' || aplis.Apttus_Proposal__Product__r.ProductCode== '41815778' ||
                             aplis.Apttus_Proposal__Product__r.Subscription_Number__c == '41409998' || aplis.Apttus_Proposal__Product__r.Subscription_Number__c == '41815778') {
                             isEbillityCon = True;
                             apliIds.add(aplis.Id);
                             ebillMaterials += (aplis.Apttus_Proposal__Product__r.productCode +',');
                         }
                     }
                } 
               //find the selected contacts by comparing with Master contacts
                //for(Contact con :contactList) {
               for(LCRM_Contact_SSD__c con :contactssdList ) {
                   Boolean isConFound = False;
                   List<string> strList = new List<string>();                   
                   if(!mstrConList.isEmpty()) {
                       for(Customer_Master_Contacts__c mc :mstrConList) {
                           //if(con.Id == mc.Contact__c) {
                           if(con.Id == mc.Contact_SDD__c) {
                               isConFound = True;                               
                               strList = con.LCRM_SAP_Role__c.split(';');
                               for(string str :strList) {
                                   mcAssigntoList(str, mc);                                        
                               }
                           }                           
                       }
                       If(!isConFound) {
                           mcListHelper(con.LCRM_SAP_Role__c.split(';'), con);                          
                       }
                   }
                   else {
                       
                       mcListHelper(con.LCRM_SAP_Role__c.split(';'), con);                     
                   }
                   
               }
               
               // Assign the Master Contacts which contacts have Contact field is null
               for(Customer_Master_Contacts__c mc :mstrConList) {
                   MCWrapper mcw = new MCWrapper();
                   if(mc.Contact__c == null) {
                      mcAssigntoList(mc.Customer_Type_Description__c, mc);                       
                   }
               }
               
               // If list is empty assign blank row
               MCWrapper mcw = new MCWrapper();
               if(isTechContact) {                   
                   mcw.mstrCon.Customer_Type_Description__c = 'TECHNICAL CONTACT';
                   techConList.add(mcw);
                   mcw = new MCWrapper();
                   selectCB(techConList);
               } 
               if(isClrPrimary) {                   
                   mcw.mstrCon.Customer_Type_Description__c = 'CLEAR PRIMARY CONT';
                   clrPrimaryList.add(mcw);
                   mcw = new MCWrapper();
                   selectCB(clrPrimaryList);
               } 
               if(isPwdEmailCon) {
                   mcw.mstrCon.Customer_Type_Description__c = 'EML PSWD CONTACT';
                   pwdEmailList.add(mcw);
                   mcw = new MCWrapper();
                   selectCB(pwdEmailList);
               } 
               if(isPatronAccCon) {
                   mcw.mstrCon.Customer_Type_Description__c = 'PATRON ACC TECH CONT';
                   patronConList.add(mcw);
                   mcw = new MCWrapper();
                   selectCB(patronConList);
               } 
               if(isEbillityCon) {
                   mcw.mstrCon.Customer_Type_Description__c = 'ADMINISTRATOR';
                   ebConList.add(mcw);
                   selectCB(ebConList);
               } 
               
            }
            catch(Exception ex) {
               // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()+ex.getLineNumber()));               
            }
        }
        else {
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Quote/Proposal'));               
        }
    }
    
    // method to check the check box of records by default
    public void selectCB(List<MCWrapper> listMC) {
        Boolean isChecked = False;
        for(MCWrapper mcr :listMC) {
            If(mcr.isSelected == True) {
                isChecked = True;
                Break;
            }            
        }
        if(!isChecked) {
            for(MCWrapper mcr :listMC) {
                mcr.isSelected = True;
                Break;                
            }
        }
    }
    // helper method to assign the contact field to Master Contacts Fields.
    public Customer_Master_Contacts__c mcAssignHelper(LCRM_Contact_SSD__c con) {
        Customer_Master_Contacts__c mcCon = new  Customer_Master_Contacts__c();
        mcCon.First_Name__c = con.LCRM_Contact__r.FirstName;
        mcCon.Last_Name__c = con.LCRM_Contact__r.LastName;
        mcCon.Email_Address__c = con.LCRM_Contact__r.Email;
        mcCon.Phone__c = con.LCRM_Contact__r.Phone;
        mcCon.Contact__c = con.LCRM_Contact__c;
        mcCon.Contact_SDD__c = con.Id;
        mcCon.Quote__c = proposalId;  
        return mcCon;      
    }
    // helper method to assign the recs to list if existing contact is matched or new master contact is found
    public void mcAssigntoList(string str, Customer_Master_Contacts__c mc) {
        MCWrapper mcw = new MCWrapper();
        mcw.isSelected = True;
        mcw.mstrCon = mc;
        mcListUtil(mcw, str);
    }
   public void mcListUtil(MCWrapper mcw, string str) {
       if(str == 'TECHNICAL CONTACT' && isTechContact) {           
           techConList.add(mcw);                                         
       }
       if(str == 'CLEAR PRIMARY CONT' && isClrPrimary) { 
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address__c))
               clrIps.fromIp = mcw.mstrCon.From_IP_Address__c;
           if(!string.isEmpty(mcw.mstrCon.To_IP_Address__c))
               clrIps.toIp = mcw.mstrCon.To_IP_Address__c;
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address1__c))
               clrIps.fromIp1 = mcw.mstrCon.From_IP_Address1__c;
           if(!string.isEmpty(mcw.mstrCon.To_IP_Address1__c))
               clrIps.toIp1 = mcw.mstrCon.To_IP_Address1__c; 
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address2__c))
               clrIps.fromIp2 = mcw.mstrCon.From_IP_Address2__c;
           if(!string.isEmpty(mcw.mstrCon.To_IP_Address2__c))
               clrIps.toIp2 = mcw.mstrCon.To_IP_Address2__c;
                          
           clrPrimaryList.add(mcw);                                         
       }
       if(str == 'EML PSWD CONTACT' && isPwdEmailCon) {           
           pwdEmailList.add(mcw);                                         
       }
       if(str == 'PATRON ACC TECH CONT' && isPatronAccCon) {
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address__c))
               patIps.fromIp = mcw.mstrCon.From_IP_Address__c;
           if(!string.isEmpty(mcw.mstrCon.To_IP_Address__c))
               patIps.toIp = mcw.mstrCon.To_IP_Address__c;
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address1__c))
               patIps.fromIp1 = mcw.mstrCon.From_IP_Address1__c;
           if(!string.isEmpty(mcw.mstrCon.To_IP_Address1__c))
               patIps.toIp1 = mcw.mstrCon.To_IP_Address1__c; 
           if(!string.isEmpty(mcw.mstrCon.From_IP_Address2__c))
               patIps.fromIp2 = mcw.mstrCon.From_IP_Address2__c;
           if(!string.isEmpty(mcw.mstrCon.To_IP_Address2__c))
               patIps.toIp2 = mcw.mstrCon.To_IP_Address2__c;
                          
           patronConList.add(mcw);                                         
       }
       if(str == 'ADMINISTRATOR' && isEbillityCon) {           
           ebConList.add(mcw);                                         
       } 
    }
    // Helper method for assign the mc to list if existing contacts found and not selected by the user
    public void mcListHelper(List<string> strList, LCRM_Contact_SSD__c con) {
        MCWrapper mcwr = new MCWrapper();
        mcwr.mstrCon = mcAssignHelper(con);
        for(string str :strList) {
           mcwr.mstrCon.Customer_Type_Description__c = str;
           mcListUtil(mcwr, str);           
       }
    }
    // Save button 
    public PageReference save() {
        Integer count = 0;
        Boolean isExceeded = False;
        string conType = '';
        Boolean isDataFill = False;
        isError = False;
        List<Customer_Master_Contacts__c> cmList = new List<Customer_Master_Contacts__c >();
        
        try{        
            cmList.addAll(saveUtilValidations(techConList));
            cmList.addAll(saveUtilValidations(clrPrimaryList));
            cmList.addAll(saveUtilValidations(pwdEmailList));
            cmList.addAll(saveUtilValidations(patronConList));
            cmList.addAll(saveUtilValidations(ebConList));            
            if(isError) {
                return null;
            }        
            if(!mstrConList.isEmpty()) {
                delete mstrConList;
            }
            if(!cmList.isEmpty()) {
                insert cmList;
            }
            // update the line items with
            apliUpdList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            
            addLineItemIds(apliIds);        
            
            if(!apliUpdList.isEmpty()) {
                update apliUpdList;
            }            
        }
        catch(Exception e){
            Digital_Exception_Log__c ex = new Digital_Exception_Log__c();  
            ex.Exception_Message__c = e.getMessage();
            ex.Exception_Type__c = e.getStackTraceString();        
            ex.Additional_Information__c = String.valueof(e.getLineNumber());   
            ex.User_Message__c = String.valueof(e.getCause());
            ex.Class_Reference__c = 'Digital_MasterContactsController > Save';       
            insert ex;
        }
        PageReference oPage = new PageReference('/'+proposalId);
        return oPage;        
    }
    // method to check ip adderess flag assign for clear and Patron contacts on Line Items
    public void addLineItemIds(Set<Id> ids) {
        for(Id pId :ids) {
            Apttus_Proposal__Proposal_Line_Item__c apliRec = new Apttus_Proposal__Proposal_Line_Item__c(Id = pId, APTS_Master_Contacts_Validation__c = True);
            if(!ipIdsMap.isEmpty() && ipIdsMap.containsKey(pId)) {
                apliRec.IP_Address_Check__c = False;   
                if(ipIdsMap.get(pId) == 'Clear' && !string.isEmpty(clrIps.fromIp)) {            
                    apliRec.IP_Address_Check__c = True;   
                }
                else If(ipIdsMap.get(pId) == 'Patron' && !string.isEmpty(patIps.fromIp)) {
                    apliRec.IP_Address_Check__c = True;   
                }         
            } 
            apliUpdList.add(apliRec);
        }   
    }
    // Save validations method
    public List<Customer_Master_Contacts__c> saveUtilValidations(List<MCWrapper> mcList) {
        List<Customer_Master_Contacts__c> cmList1 = new List<Customer_Master_Contacts__c >();
        Integer count = 0;
        Boolean isExceeded = False;
        string conType = '';
        Boolean isDataFill = False;
        Boolean isvalidIP = True;
        
        for(MCWrapper mcw :mcList) {
            conType = mcw.mstrCon.Customer_Type_Description__c;
            
            if(mcw.isSelected == True) {   
                count +=1;                               
                
                if(!string.isEmpty(mcw.mstrCon.First_Name__c) && !string.isEmpty(mcw.mstrCon.Last_Name__c) && !string.isEmpty(mcw.mstrCon.Email_Address__c)) {
                    isDataFill = True;
                }
                // validate the Ip Addresses for CLEAR Primary & Patron Access Tech Contact
                if(conType == 'CLEAR PRIMARY CONT'){
                    
                    if(isvalidIP = validateIP(clrIps)) {    
                        mcw.mstrCon.From_IP_Address__c = clrIps.fromIP;
                        mcw.mstrCon.To_IP_Address__c =  clrIps.toIP;
                        mcw.mstrCon.From_IP_Address1__c = clrIps.fromIP1;
                        mcw.mstrCon.To_IP_Address1__c =  clrIps.toIP1;
                        mcw.mstrCon.From_IP_Address2__c = clrIps.fromIP2;
                        mcw.mstrCon.To_IP_Address2__c =  clrIps.toIP2;    
                    }                   
                }
                if(conType == 'PATRON ACC TECH CONT') {
                    if(isvalidIP = validateIP(patIps)) {    
                        mcw.mstrCon.From_IP_Address__c = patIps.fromIP;
                        mcw.mstrCon.To_IP_Address__c =  patIps.toIP;
                        mcw.mstrCon.From_IP_Address1__c = patIps.fromIP1;
                        mcw.mstrCon.To_IP_Address1__c =  patIps.toIP1;
                        mcw.mstrCon.From_IP_Address2__c = patIps.fromIP2;
                        mcw.mstrCon.To_IP_Address2__c =  patIps.toIP2;     
                    }  
                }
                cmList1.add(saveHelper(mcw.mstrCon));                
            }
            if(count > 1) {
                isExceeded = True;                
                break;    
            }
        }
        if(!mcList.isEmpty() && count == 0) {
            isError = True;            
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select one Contact for '+conType));
        }
        if(!isDataFill && count > 0) {
            isError = True;
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill First Name , Last Name and Email of selected Contact for '+conType));
        }
        if(isExceeded) {
            isError = True;
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select only one Contact for '+conType));
        }
        if(!isvalidIP) {
            isError = True;
          //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter valid IP addresses '+conType));
        }
        return cmList1;
    }
    public Customer_Master_Contacts__c saveHelper(Customer_Master_Contacts__c mc) {
        Customer_Master_Contacts__c cmc = new Customer_Master_Contacts__c();
        cmc.First_Name__c = mc.First_Name__c;
        cmc.Last_Name__c = mc.Last_Name__c;
        cmc.Email_Address__c = mc.Email_Address__c;
        cmc.Quote__c = proposalId;
        cmc.Contact__c = mc.Contact__c;
        cmc.Contact_SDD__c = mc.Contact_SDD__c;
        cmc.Material__c = assignProductMaterials(mc.Customer_Type_Description__c);
        cmc.Customer_Type_Description__c = mc.Customer_Type_Description__c;
        cmc.From_IP_Address__c = mc.From_IP_Address__c;
        cmc.To_IP_Address__c = mc.To_IP_Address__c; 
        cmc.From_IP_Address1__c = mc.From_IP_Address1__c;
        cmc.To_IP_Address1__c = mc.To_IP_Address1__c;    
        cmc.From_IP_Address2__c = mc.From_IP_Address2__c;
        cmc.To_IP_Address2__c = mc.To_IP_Address2__c;       
        return cmc;
    }
    // asign the matirials based on the contact type.
    public string assignProductMaterials(string conType) {
        string materials = '';
        if(conType == 'TECHNICAL CONTACT') {           
           materials = techMaterials;                                       
       }
       else if(conType == 'CLEAR PRIMARY CONT') {           
           materials = clrMaterials;                                       
       }
       else if(conType  == 'EML PSWD CONTACT') {           
           materials = pwdMaterials;                                        
       }
       else if(conType == 'PATRON ACC TECH CONT') {           
           materials = patronMaterials;                                        
       }
       else if(conType == 'ADMINISTRATOR') {           
           materials = ebillMaterials;                                       
       } 
       return materials;
    }
    
    public Boolean validateIP(ipWrapper ipw) {
        Boolean isvalid = True;
        Boolean b1 = True;
        Boolean b2 = True;
        Boolean b3 = True;
        Boolean b4 = True;
        Boolean b5 = True;        
        Boolean b6 = True;
        if(!string.isEmpty(ipw.fromIp)) 
            b1 = validIP(ipw.fromIp); 
        if(!string.isEmpty(ipw.toIp))
            b2 = validIP(ipw.toIp);
        if(!string.isEmpty(ipw.fromIp1)) 
            b3 = validIP(ipw.fromIp1); 
        if(!string.isEmpty(ipw.toIp1))
            b4 = validIP(ipw.toIp1);
        if(!string.isEmpty(ipw.fromIp2)) 
            b5 = validIP(ipw.fromIp2); 
        if(!string.isEmpty(ipw.toIp2))
            b6 = validIP(ipw.toIp2);
        if(!b1 || !b2 || !b3 || !b4 || !b5 || !b6) {
            isvalid = False;    
        }
            
        return isvalid; 
    }
    
    // method to validate the Ip Addreess    
    public Boolean validIP(string ip) {
        boolean isValidIP = True;
        String RE_IP = '^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$'; 
        Pattern MyPattern = Pattern.compile(RE_IP);        
        Matcher MyMatcher = MyPattern.matcher(ip);
        if(!MyMatcher.matches()) {
            isValidIP = False;
            
        }
        return isValidIP;
    }
    
    //Cance method
    public PageReference cancel() {
        PageReference oPage = new PageReference('/'+proposalId);
        return oPage;
    }
    // Wrapper Class
    public class MCWrapper {
        public Boolean isSelected {get; set;}
        public Customer_Master_Contacts__c mstrCon {get; set;}
        
        public MCWrapper() {
            isSelected = False;
            mstrCon = new Customer_Master_Contacts__c();
        }
    }
    // Wrapper class for IP Addresses'
    public class ipWrapper {
        public string fromIp {get; set;}
        public string toIp {get; set;}
        public string fromIp1 {get; set;}
        public string toIp1 {get; set;}
        public string fromIp2 {get; set;}
        public string toIp2 {get; set;}
        public ipWrapper(){
            fromIp = '';
            toIp = '';
            fromIp1 = '';
            toIp1 = '';
            fromIp2 = '';
            toIp2 = '';
        }
    }  
}