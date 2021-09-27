public class TaxDocumentTriggerHandler{

    public static void updateTaxDocumentType(list<Tax_Document__c> taxDocList){
    
    List<Id> TaxAccId = new List<Id>();
    set<string> docTypes = new set<string>();
    List<Account> accList = new List<Account>();
    string taxDocType;
    Account acc = new Account();
    boolean check;
    for(Tax_Document__c txDoc : taxDocList)
        TaxAccId.add(txDoc.Account__c);
        
    map<Id,Account> accountMap = new map<Id,Account>([Select id,Tax_Document_Type__c from Account where Id=:TaxAccId]);
    
    for(Tax_Document__c txDoc : taxDocList)
    {
    docTypes.clear();
    acc = accountMap.get(txDoc.Account__c);
    if(acc.Tax_Document_Type__c!=null){
    docTypes.addAll(acc.Tax_Document_Type__c.split(';'));
        if(docTypes.contains(txDoc.Tax_Document_Type__c)){
        taxDocType = 'temp';
        system.debug('Acct Tax Doc type..before..'+acc.Tax_Document_Type__c);
        //system.debug('str..before..'+str);
        check = true;
        docTypes.remove(txDoc.Tax_Document_Type__c);
        for(string s: docTypes){
            system.debug('inside for loop..');
     /*       if(!check)
                taxDocType =+';';
            else{
                taxDocType = +s;
                check=false;         */
              taxDocType = taxDocType + s +';' ;
            }
            taxDocType = taxDocType.removeStart('temp');
            taxDocType = taxDocType.removeEnd(';');
       
    system.debug('taxDocType...'+taxDocType);
    acc.Tax_Document_Type__c = taxDocType;
    system.debug('docTypes..after..'+docTypes);
    //system.debug('str..after..'+str);
    system.debug('Acct Tax Doc type..after..'+acc.Tax_Document_Type__c);
    accList.add(acc);
    }
    }
    }    
    if(!accList.isEmpty())
    update accList;
    }
 }