public class AccountAlertDetailController {

    private ApexPages.StandardController controller {get; set;}
    Account a;
    List<AggregateResult> accAlertList;
    
    List<Account> accList;
    //Map<String, Map<String, Integer>> accAlertMap;
    Map<String, String> accAlertMap;
    //public Map<String, Map<String, Integer>> accAlertMapUI{get;set;}
    public Map<String, String> accAlertMapUI{get;set;}
    public Integer columns{get;set;}
    public boolean isEmbargoedAccount;
    public boolean sanctionStatusNoSanction;
    public boolean showAlertAvailable{get; set;}
    public AccountAlertDetailController(ApexPages.StandardController controller) {

        this.controller = controller;
        this.a = (Account)controller.getRecord();
        //this.accAlertMap = new Map<String, Map<String, Integer>>();
        this.accAlertMap = new Map<String, String>();
        //this.accAlertMapUI = new Map<String, Map<String, Integer>>();
        this.accAlertMapUI = new Map<String, String>();
        this.showAlertAvailable = false;
        this.isEmbargoedAccount = false;
        this.sanctionStatusNoSanction = false;
        System.debug('@@@@@ Account Id: '+a.Id);
        accList = [SELECT Id, LCRM_Embargoed_Account__c, Sanctioned_Status__c FROM Account WHERE Id =: a.Id];
        //accAlertList = [SELECT Severity__c, Sub_BU__c FROM Account_Alert__c WHERE Active_Alert__c = true AND Severity__c != null AND Sub_BU__c != null AND Account__c =: a.Id];
        accAlertList = [SELECT Severity__c, Sub_BU__c, COUNT(Id) FROM Account_Alert__c WHERE Active_Alert__c = true AND Severity__c != null AND Sub_BU__c != null AND Account__c =: a.Id GROUP BY CUBE (Severity__c, Sub_BU__c) Having Severity__c != null AND Sub_BU__c != null];
        
        if(accList[0].LCRM_Embargoed_Account__c)
            isEmbargoedAccount = true;
        if(accList[0].Sanctioned_Status__c == 'No Sanctions')
            sanctionStatusNoSanction = true;
        
        for(AggregateResult alert: accAlertList){
            if(!accAlertMap.containsKey(String.valueOf(alert.get('Severity__c')))){
                //accAlertMap.put(String.valueOf(alert.get('Severity__c')), new Map<String, Integer>{String.valueOf(alert.get('Sub_BU__c')) => Integer.valueOf(alert.get('expr0'))});
                accAlertMap.put(String.valueOf(alert.get('Severity__c')), '('+Integer.valueOf(alert.get('expr0'))+') '+String.valueOf(alert.get('Sub_BU__c')));
            }
            else{
                //accAlertMap.get(String.valueOf(alert.get('Severity__c'))).put(String.valueOf(alert.get('Sub_BU__c')), Integer.valueOf(alert.get('expr0')));
                accAlertMap.put(String.valueOf(alert.get('Severity__c')), accAlertMap.get(String.valueOf(alert.get('Severity__c')))+' ('+Integer.valueOf(alert.get('expr0'))+') '+String.valueOf(alert.get('Sub_BU__c')));
            }
        }
        if(accAlertMap.size()>0){
            columns = accAlertMap.size();
            showAlertAvailable = true;
            if(accAlertMap.keySet().contains('Severe'))
                accAlertMapUI.put('1. Severe', accAlertMap.get('Severe'));
            if(accAlertMap.keySet().contains('Important'))
                accAlertMapUI.put('2. Important', accAlertMap.get('Important'));
            if(accAlertMap.keySet().contains('Informational'))
                accAlertMapUI.put('3. Informational', accAlertMap.get('Informational'));
        }
        
        if(!showAlertAvailable && !isEmbargoedAccount){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, Label.No_Account_Alert_message));
        }
        if(isEmbargoedAccount && !sanctionStatusNoSanction){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.Embargoed_Account_Warning_Message));
        }
        if(isEmbargoedAccount && sanctionStatusNoSanction){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.Embargoed_Account_Warning_Message_No_Sanctioned));
        }
    }
}