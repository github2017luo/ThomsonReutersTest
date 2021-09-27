public class TaxDocumentLoadController{

    public Id account_Id{get;set;}
    public Date cm_05_effDate{get;set;}
    public Attachment cm_05_file{get;set;}
    public Attachment turnover_file{get;set;}
    public Attachment exemption_file{get;set;}
    public Attachment other_file{get;set;}
    public list<Tax_document__c> taxlist = new list<Tax_document__c>();
    public list<Attachment> attachlist = new list<Attachment>();
    public Tax_document__c tax1 {get;set;}
    public Tax_document__c tax3{get;set;}
    public Tax_document__c tax2{get;set;}
    public Tax_document__c tax4{get;set;}
    public Account acc{get;set;}
    set<string> docTypes = new set<string>();
  
      
    public TaxDocumentLoadController(ApexPages.StandardController Stdctlr)
    {
    account_Id = Apexpages.currentpage().getParameters().get('accountId');
    acc = [Select Id,Name,Tax_Document_Type__c,Tax_Document_Expiration_Date__c from Account where Id=:account_Id];
    tax1 = new Tax_document__c();
    tax2 = new Tax_document__c();
    tax3 = new Tax_document__c();
    tax4 = new Tax_document__c();
    cm_05_file = new attachment();
    turnover_file = new attachment();
    exemption_file = new attachment();
    other_file = new attachment();
    }
    
    public Pagereference Save(){        
        
        
        String str = '';
        if(acc.Tax_Document_Type__c == null){
        Apexpages.addmessage(new Apexpages.message(Apexpages.severity.ERROR,'Tax Document type should not be null'));
        attachclear();
        return null;
        }
        docTypes.clear();
        docTypes.addAll(acc.Tax_Document_Type__c.split(';'));        
        if(!Schema.SObjectType.Tax_Document__c.isDeletable() && docTypes.contains('Other (CMT only)')){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Tax Document type :Other (CMT only) is only available for CMT members'));
        attachclear();
        return null;
        }
        
        if(turnover_file.body != null && tax2.Tax_Document_Effective_Date__c !=null && tax2.Tax_Document_Expiration_Date__c !=null )
        {
         
         str = turnover_file.name.substringAfter('.');
         turnover_file.name = 'Turnover' + '.' + str; 
         tax2.name = 'Turnover '+ acc.name;
         tax2.Tax_Document_Type__c = 'Turnover Certificate (Ingresos Brutos)';
         tax2.account__c = account_Id;
         taxlist.add(tax2);
                  
        }
        
        if(cm_05_file.body != null && tax1.Tax_Document_Effective_Date__c !=null && tax1.Tax_Document_Expiration_Date__c !=null)
        {
         str = cm_05_file.name.substringAfter('.');
         cm_05_file.name = 'CM-05' + '.' + str;
         tax1.name='CM-05 '+acc.name;
         tax1.Tax_Document_Type__c = 'CM-05 Certificate (Formulario Multilateral)';
         tax1.account__c = account_Id;
         taxlist.add(tax1);
                  
        }        
        
        
        if(exemption_file.body != null && tax3.Tax_Document_Effective_Date__c !=null && tax3.Tax_Document_Expiration_Date__c !=null)
        {
         str = exemption_file.name.substringAfter('.');         
         exemption_file.name = 'Exemption' + '.' + str;
         tax3.name = 'Exemption '+ acc.name;
         tax3.account__c = account_Id;
         tax3.Tax_Document_Type__c = 'Exemption Certificate (Certificado de Exencion)';
         taxlist.add(tax3);
        
                 
        }
        
        if(other_file.body != null && tax4.Tax_Document_Effective_Date__c !=null && tax4.Tax_Document_Expiration_Date__c !=null)
        {
         str = other_file.name.substringAfter('.');         
         other_file.name = 'Other' + '.' + str;
         tax4.name = 'Other '+ acc.name;
         tax4.account__c = account_Id;
         tax4.Tax_Document_Type__c = 'Other (CMT only)';
         taxlist.add(tax4);
                 
        }
        
        system.debug('taxlist...'+taxlist);
        if(!taxlist.isEmpty() && taxlist!=null){
        insert taxlist;
        acc.Sales_Check__c = true;
        }
        else{
        Apexpages.addmessage(new Apexpages.message(Apexpages.severity.ERROR,'Please upload the tax documents along with Tax Effective & Expiration Dates'));
        attachclear();
        return null;
        }
        
        
        system.debug('taxlist...'+taxlist); 
        
               
        if(cm_05_file.body != null){
        
        cm_05_file.parentid = tax1.id;
        attachlist.add(cm_05_file); 
         }
         
         if(turnover_file.body != null){
         turnover_file.parentid = tax2.id;
         attachlist.add(turnover_file);
         }
         
         if(exemption_file.body != null){
         exemption_file.parentid = tax3.id; 
         attachlist.add(exemption_file);
         }
         
         if(other_file.body != null){
         other_file.parentid = tax4.id; 
         attachlist.add(other_file);
         }
        
        system.debug('attachlist...'+attachlist); 
        
        if(attachlist!= null && !attachlist.isEmpty())
            insert attachlist;
        else{
            Apexpages.addmessage(new Apexpages.message(Apexpages.severity.ERROR,'Please upload the tax documents'));
            attachclear();
            return null;
            }
        
        /*docTypes.addAll(acc.Tax_Document_Type__c.split(';'));        
        if(!Schema.SObjectType.Tax_Document__c.isDeletable() && docTypes.contains('Other (CMT only)')){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Tax Document type option is only available for CMT members'));
        return null;
        }
        else*/
        update acc;
           
        return new Pagereference('/'+ account_Id);
        } 
        
        public void attachclear(){
        
        cm_05_file = new attachment();
        turnover_file = new attachment();
        exemption_file = new attachment();
        other_file = new attachment();
        }
 
     public pagereference cancel(){
     
     return new Pagereference('/'+ account_Id);
     
     }
 
 }