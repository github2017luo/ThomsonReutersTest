/**
 * Contains methods for ManageContacts VF Page
 * Uses AppUtil2 Class to get the fields of contact, operators and to build the Query.
 * Contains the wrapper class for contacts for showing checkboxes
 * Contains the method to search the contacts based on the search criteria entered on the VF page.
 *
 * @author  Srikanth Kuruva
 * @version  2012-01-25
 */
 /**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2012-05-09   Srikanth Kuruva     Changed the logic so that the check mark is
 *                                  not lost during pagination.
 * 2012-05-18   Srikanth Kuruva     Did Enhancement for QC # 2717.
 * =============================================================================
 */ 
public class ManageContacts
{
    //private Map<String, Schema.SObjectType> mapGlobalObject ;
    public List<String> listContactFields = new List<String>();
    public Map<String,string> mapFields = new Map<string,string>();
    public Map<String,string> mapNameKey = new Map<string,string>();
    public Map<String,Schema.DisplayType> mapfieldsAndTypes = new Map<String,Schema.DisplayType>();
    public List<SelectOption> listOperatorFields = new List<SelectOption>();
    
    public CustomSetController oMatchingContactsCustomSetCon{get;set;} //for capturing the contacts on Add Contacts tab    
    public List<cContact> listMatchingContacts {get;set;}
    public List<cContact> listPagedContacts {get;set;}
    
    public CustomSetController oExistingContactsCustomSetCon{get;set;} //for capturing the existing contacts
    public List<cContact> listExistingMatchingContacts {get;set;}
    public List<cContact> listPagedExistingContacts {get;set;}
    public Map<Id, Contact> mapExistingContacts {get;set;}
    
    public Boolean bMatchesFound {get; set;}
    public Boolean bExistingMatchesFound {get; set;}
    public Boolean bRenderAddButton {get; set;}
    private Integer iPageSize = 100;
    
    public String sSelectedField1 {get;set;}
    public String sSelectedField2 {get;set;}
    public String sSelectedField9 {get;set;}
    public String sSelectedField3 {get;set;}
    public String sSelectedField4 {get;set;}
    
    public String sSelectedOperator1 {get;set;} 
    public String sSelectedOperator2 {get;set;}
    public String sSelectedOperator9 {get;set;}
    public String sSelectedOperator3 {get;set;} 
    public String sSelectedOperator4 {get;set;}
    
    public String sSearchValue1 {get;set;} 
    public String sSearchValue2 {get;set;}
    public String sSearchValue9 {get;set;}
    public String sSearchValue3 {get;set;} 
    public String sSearchValue4 {get;set;}
    
    DateTime dtField1,dtField2;
    DateTime dummy1,dummy2;
    Integer counter;
    List<String> tempConList1 = new List<String>();
    List<String> tempConList2 = new List<String>(); 
    
    public String sSelectedTab {get;set;}
    
    public Id TrainingEventId = System.currentPageReference().getParameters().get('id');
    public Id AccountId = System.currentPageReference().getParameters().get('AccId');
    public Boolean renderAccountInfo{get;set;}
    public Account acc{get;set;}
    public Training_Event__c tTrainingEvent{get;set;}
    
    public class cContact
    {
        public Contact cCon{get;set;}
        public Boolean bSelected{get;set;}
        public Boolean bDisableCheckbox{get;set;}
        
        public cContact(Contact c, Map<Id,Contact> mapExistingContacts, Boolean bforAddingContacts)
        {
            cCon = c;
            bSelected = false;
            if (bforAddingContacts)
            {
                if(!mapExistingContacts.isEmpty())
                {               
                    if(mapExistingContacts.containsKey(c.Id))
                    {
                        bSelected = true;
                        bDisableCheckbox = true; 
                    }
                    else
                    {
                        bSelected = false;
                        bDisableCheckbox = false;
                    }
                }
                else
                {
                    bSelected = false;
                }
            }
        }       
    }
    
    public ManageContacts(ApexPages.StandardController controller) {
        bMatchesFound = false;
        mapFields = AppUtil2.getFieldNameList('Contact', mapFields, mapNameKey, mapfieldsAndTypes);
        //system.debug('mapFields:'+mapFields);
        //--Add account.BillingCity - Begin
        mapFields.put('City ','Account.BillingCity');
        mapfieldsAndTypes.put('City ',Schema.DisplayType.STRING);
        mapNameKey.put('Account.BillingCity','City ');
        //--Add account.BillingCity - End
        //system.debug('mapNameKey:'+mapNameKey);
        for (String sField : mapNameKey.Values())
        {
            if(sField == 'Westlaw User ID' || sField == 'Last Name' || sField == 'SAP Account Number' || 
               sField == 'City ' || sField == 'Account Name')
            {
                listContactFields.add(sField);
            }
        }
        listContactFields.sort();
        //tTrainingEvent = (Training_Event__c)controller.getRecord();
        tTrainingEvent = [select Id, Account_Level__c from Training_Event__c where Id = :TrainingEventId]; 
        if(tTrainingEvent.Account_Level__c)
        {
            List<Training_Event_Account__c> listTrainingEventAcc = new List<Training_Event_Account__c>();
            listTrainingEventAcc = [select Id, Account__c from Training_Event_Account__c where Training_Event__c = :TrainingEventId];
            if(!listTrainingEventAcc.isEmpty())
                AccountId = listTrainingEventAcc[0].Account__c;
        }
        if (AccountId != null)
        {
            acc = [select id, Name, SAPAccountNumber__c from Account where id =:AccountId];
            sSelectedField1 = 'SAP Account Number';
            sSelectedOperator1 = 'equals';
            sSearchValue1 = acc.SAPAccountNumber__c;
            renderAccountInfo = true;
            //ApexPages.addMessages('Account Name: '+acc.Name + '        SAP Account Number: '+ acc.SAPAccountNumber__c);
        }
    }

    public list<SelectOption> getlistOperatorFields(){       
       listOperatorFields = AppUtil2.populateOperators(Schema.DisplayType.STRING);
       return listOperatorFields;
    }
    
    public list<SelectOption> getlistContactFields(){
        List<SelectOption> listFieldOptions = new List<SelectOption>();
        listFieldOptions.add(new SelectOption('--None--','--None--'));
        for(Integer i=0;i<listContactFields.size();i++)
        {
            listFieldOptions.add(new SelectOption(listContactFields[i],listContactFields[i]));
        }
        return listFieldOptions;
    }
    
    public void getExistingContacts()
    {
        mapExistingContacts = new Map<Id, Contact>();
        List<Id> listContactIds = new List<Id>();
        for(Training_Event_Contact__c TrainingEventContact : [SELECT Id, Contact_Name__c FROM Training_Event_Contact__c where Training_Event__c = :TrainingEventId])
        {
            listContactIds.add(TrainingEventContact.Contact_Name__c);
        }
        
        if(!listContactIds.isEmpty())
        {
            mapExistingContacts = new Map<Id, Contact>([SELECT Id, Name, FirstName, LastName, SAP_Account_Number__c,Westlaw_User_ID__c, SAP_Role__c, Account.billingcity,MailingCity, Account.Name FROM Contact where Id in :listContactIds]);
        }       
    }
    
    public pagereference findResults(){
        bMatchesFound = true;        
        listMatchingContacts = new List<cContact>();
        getExistingContacts();
        counter = 0;
        String sQueryString = 'SELECT Id, Name, FirstName, LastName, SAP_Account_Number__c,Westlaw_User_ID__c, SAP_Role__c,Account.billingcity, MailingCity, Account.Name FROM Contact where CreatedDate <> null ';        
        if(sSearchValue1!=null && sSearchValue1!='' && sSelectedField1!='--None--')
        {
            counter = 1;
            sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField1),sSelectedOperator1,sSearchValue1);            
        }   
          
        if(sSearchValue2!=null && sSearchValue2!='' && sSelectedField2!='--None--')
        {
            counter = 2;
            sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField2),sSelectedOperator2,sSearchValue2);
        }
        if(sSearchValue9!=null && sSearchValue9!='' && sSelectedField9!='--None--')
        {
            counter = 3;
            sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField9),sSelectedOperator9,sSearchValue9);
        }
        if(counter != 0)  
        {
            sQueryString += ' order by Name';
            sQueryString += ' limit 3000 ';
            //system.debug('sQueryString:'+sQueryString);
            Contact[] templistMatchingContacts = Database.query(sQueryString);        
            listMatchingContacts = convertType(templistMatchingContacts);
            oMatchingContactsCustomSetCon = new CustomSetController(listMatchingContacts, iPageSize);
            listPagedContacts = reverseType(oMatchingContactsCustomSetCon.getCurrentRecordList());
        }
        else
        {
            oMatchingContactsCustomSetCon = new CustomSetController(new List<cContact>(), iPageSize);
            listPagedContacts = reverseType(oMatchingContactsCustomSetCon.getCurrentRecordList());
        }
        return null;
    }
    public List<cContact> convertType(Contact[] templistMatchingContacts)
    {
        List<cContact> listTempWrapperObj = new List<cContact>();
        for(Contact ctempContact : templistMatchingContacts)
        {
            cContact cc = new cContact(ctempContact, mapExistingContacts, bMatchesFound);
            if(cc.bSelected == false)
                bRenderAddButton = true;
            listTempWrapperObj.add(cc);
        } 
        return listTempWrapperObj;       
    }
    public List<cContact> reverseType(List<Object> liObj)
    {
        List<cContact> listTempWrapperObj = new List<cContact>();
        for(Object obj : liObj)
        {
            cContact cc = (cContact)obj;
            listTempWrapperObj.add(cc);
        }
        return listTempWrapperObj;        
    }
    public pageReference Next()
    {
        if(bMatchesFound)
        {
            listPagedContacts = reverseType(oMatchingContactsCustomSetCon.Next());
        }
        else if(bExistingMatchesFound)
        {
            listPagedExistingContacts = reverseType(oExistingContactsCustomSetCon.Next());
        }
        return null;
    }
    public pageReference Previous()
    {
        if(bMatchesFound)
        {
            listPagedContacts = reverseType(oMatchingContactsCustomSetCon.Previous());
        }
        else if(bExistingMatchesFound)
        {
            listPagedExistingContacts = reverseType(oExistingContactsCustomSetCon.Previous());
        }
        return null;
    }
    
    public pageReference searchExistingContacts()
    {
        bMatchesFound = false;
        listExistingMatchingContacts = new List<cContact>();
        List<Id> listContactIds = new List<Id>();
        listContactIds.addAll(mapExistingContacts.keySet());
        if(!listContactIds.isEmpty())
        {
            String strContactIds = '';
            for (Id contactId : listContactIds)
            {
                strContactIds += (string)contactId + ',';
            }
            String sQueryString = 'SELECT Id, Name, FirstName, LastName, SAP_Account_Number__c,Westlaw_User_ID__c, SAP_Role__c,Account.billingcity, MailingCity, Account.Name FROM Contact where Id in '+AppUtil2.getValueList(strContactIds,',')+' and CreatedDate <> null ';
            if(sSearchValue3!=null && sSearchValue3!='' && sSelectedField3!='--None--')
            {
                counter = 1;
                sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField3),sSelectedOperator3,sSearchValue3);                
            }   
              
            if(sSearchValue4!=null && sSearchValue4!='' && sSelectedField4!='--None--')
            {
                counter = 2;               
                sQueryString += AppUtil2.queryForText(mapFields.get(sSelectedField4),sSelectedOperator4,sSearchValue4);
            }
              
            sQueryString += ' order by Name';
            sQueryString += ' limit 3000 ';
            Contact[] templistMatchingContacts = Database.query(sQueryString);
            listExistingMatchingContacts = convertType(templistMatchingContacts);
            oExistingContactsCustomSetCon = new CustomSetController(listExistingMatchingContacts, iPageSize);
            listPagedExistingContacts = reverseType(oExistingContactsCustomSetCon.getCurrentRecordList());                       
        }
        return null;
    }
    
    public pageReference enterExistingContactsTab()
    {        
        bExistingMatchesFound = true;
        bMatchesFound = false;        
        getExistingContacts();
        listExistingMatchingContacts = new List<cContact>();
        listExistingMatchingContacts = convertType(mapExistingContacts.values());
        oExistingContactsCustomSetCon = new CustomSetController(listExistingMatchingContacts, iPageSize);
        listPagedExistingContacts = reverseType(oExistingContactsCustomSetCon.getCurrentRecordList());
        /*for (Contact ctempContact : mapExistingContacts.values())
        {
            listExistingMatchingContacts.add(new cContact(ctempContact, mapExistingContacts, false));
        }*/
        return null;
    }
    
    public pageReference enterAddContactsTab()
    {
        bMatchesFound = false;
        bExistingMatchesFound = false;        
        return findResults();
    }
    public List<Training_Event_Contact__c> getSelectedFromExistingContactsTab()
    {
        List<Id> listSelectedContactIds = new List<Id>();
        
        for(cContact con : listExistingMatchingContacts) 
        {
            if(con.bSelected == true) 
            {
                listSelectedContactIds.add(con.cCon.Id);
            }
        }
        if(!listSelectedContactIds.isEmpty())
        {
            return [SELECT Id, Contact_Name__c FROM Training_Event_Contact__c where Training_Event__c = :TrainingEventId and Contact_Name__c in :listSelectedContactIds];
        }
        return new List<Training_Event_Contact__c>();
    }
    public pageReference RemovefromTraining()
    {
        List<Training_Event_Contact__c> listTrainingEventContacts = getSelectedFromExistingContactsTab();
        if(!listTrainingEventContacts.isEmpty())
        {
            delete listTrainingEventContacts;
        }                
        return enterExistingContactsTab();
    }
    
    public pageReference AddTopics()
    {
        List<Training_Event_Contact__c> listTrainingEventContacts = getSelectedFromExistingContactsTab();
        if (!listTrainingEventContacts.isEmpty())
        {
            String sTrainingEventContactIds = '';
            for(Training_Event_Contact__c tec : listTrainingEventContacts)
                sTrainingEventContactIds += tec.Id +',';
            //PageReference pgTrainingEvent = new PageReference('/apex/ManageTopics?Id=' + TrainingEventId+'&TECIds='+str);
            PageReference pgTrainingEvent = new PageReference('/apex/ManageTopics?Id=' + TrainingEventId);
            pgTrainingEvent.getParameters().put('TECIds', sTrainingEventContactIds);
            return pgTrainingEvent;
        }
        else
        {
            return null;
        }
    }
    
    public pageReference AddtoTraining()
    {
        List<Contact> listSelectedContacts = new List<Contact>();
        //system.debug('oMatchingContactsCustomSetCon:'+oMatchingContactsCustomSetCon.getAllRecords());
        //system.debug('mapExistingContacts.isEmpty():'+mapExistingContacts.isEmpty());
        if (listMatchingContacts != null)
        {
            for(cContact con : reverseType(oMatchingContactsCustomSetCon.getAllRecords())) 
            {
                if(con.bSelected == true) 
                {
                    system.debug('con.bSelected:'+ con.bSelected + 'con.cCon.Name:'+con.cCon.Name);
                    if(mapExistingContacts.isEmpty())
                    {               
                        listSelectedContacts.add(con.cCon);                 
                    }
                    else if(!mapExistingContacts.containsKey(con.cCon.Id))
                    {
                        listSelectedContacts.add(con.cCon);
                    }
                    con.bDisableCheckbox = true;
                }
            }        
            String str = '';
            system.debug('listSelectedContacts.isEmpty():'+listSelectedContacts.isEmpty());
            system.debug('listSelectedContacts:'+listSelectedContacts);
            if(!listSelectedContacts.isEmpty())
            {
                List<Training_Event_Contact__c> listTrainingEventContacts = new List<Training_Event_Contact__c>();            
                Training_Event_Contact__c TrainingEventContact;
                for(Contact c : listSelectedContacts)
                {
                    TrainingEventContact = new Training_Event_Contact__c();
                    TrainingEventContact.Contact_Name__c = c.Id;
                    TrainingEventContact.Training_Event__c = TrainingEventId; 
                    listTrainingEventContacts.add(TrainingEventContact);
                }
                insert listTrainingEventContacts;
                /*Database.Saveresult[] lsr = Database.Insert(listTrainingEventContacts, true);
                for(Database.SaveResult sr:lsr)
                {   
                    if(sr.isSuccess())
                        str += sr.getId()+',';
                }*/

                //PageReference pgTrainingEvent = new PageReference('/apex/ManageTopics?Id=' + TrainingEventId+'&TECIds='+str);
                //return pgTrainingEvent;
                listPagedContacts = reverseType(oMatchingContactsCustomSetCon.getCurrentRecordList());
                return null;
            }
            else
            {
                listPagedContacts = reverseType(oMatchingContactsCustomSetCon.getCurrentRecordList());
                return null;
            }
        }
        listPagedContacts = reverseType(oMatchingContactsCustomSetCon.getCurrentRecordList());
        return null;
    }

}