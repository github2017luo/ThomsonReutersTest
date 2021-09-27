public with sharing class ESC_UpdateInvoiceonCase{
    public static void updateinvoice(List<ESC_Invoice_Item__c> Invoicelist){
        List<String> Invidlist = new List<String>();
        List<String> Invlist = new List<String>();
        String newinvoicenum = '';
        map<string,string> invoicecasemap = new map<string,string>();
        map<string,string> invoicenummap = new map<string,string>();
        Map<String, Integer> invcountmap = new Map<String,Integer>();
        integer invposition;
        integer caseinvlength;
        integer invoicelength;
        List<String> caseinvlist = new List<String>();
        list<case> caseupdlist = new list<case>();
        for(ESC_Invoice_Item__c inv : Invoicelist){        
            Invidlist.add(inv.id);
            Invlist.add(inv.esc_invoicenumber__c+'-'+inv.ESC_Line_number__c);
            caseinvlist.add(inv.esc_case__c);
        }
        try{
            if(Schema.sObjectType.ESC_Invoice_Item__c.isAccessible() || Schema.sObjectType.ESC_Invoice_Item__c.isQueryable()){
                for(ESC_Invoice_Item__c invitem : [Select esc_case__r.ESC_Invoice_numbers__c,ESC_Line_number__c,esc_invoicenumber__c,esc_case__c from ESC_Invoice_Item__c where id IN:Invidlist]){
                    invoicecasemap.put(invitem.esc_invoicenumber__c+'-'+invitem.ESC_Line_number__c,invitem.esc_case__c);
                    invoicenummap.put(invitem.esc_invoicenumber__c+'-'+invitem.ESC_Line_number__c,invitem.esc_case__r.ESC_Invoice_numbers__c);
                    
                }
            }
            if(Schema.sObjectType.ESC_Invoice_Item__c.isAccessible() || Schema.sObjectType.ESC_Invoice_Item__c.isQueryable()){
                for(ESC_Invoice_Item__c invitem : [Select esc_case__r.ESC_Invoice_numbers__c,esc_invoicenumber__c,esc_case__c from ESC_Invoice_Item__c where esc_case__c IN:caseinvlist]){
                    caseinvlist.add(invitem.esc_invoicenumber__c);
                }
            }
            system.debug('invoicecasemap is'+invoicecasemap);
            system.debug('invoicenummap is'+invoicenummap);
            for(String invoice : Invlist){
                if(invoicenummap != null && invoicenummap.containsKey(invoice) && invoicenummap.get(invoice) != null ){
                    invposition = invoicenummap.get(invoice).indexOf(invoice); 
                    caseinvlength = invoicenummap.get(invoice).length();
                    invoicelength = invoice.length();                  
                    
                }
                system.debug('inv count map is'+invcountmap);
                system.debug('values are'+invposition+'^^^'+caseinvlength+'***'+invoicelength) ;                             
                if((invposition > 0) && (invposition+invoicelength != caseinvlength))
                    newinvoicenum = invoicenummap.get(invoice).substring(0,invposition+1)+ invoicenummap.get(invoice).substring(invposition+invoicelength+1);
                else if((invposition > 0) && (invposition+invoicelength == caseinvlength))
                    newinvoicenum = invoicenummap.get(invoice).substring(0,invposition-1);
                else if ((invposition == 0) && (invposition+invoicelength == caseinvlength))
                    newinvoicenum = '';
                else
                    newinvoicenum = invoicenummap.get(invoice).substring(invoicelength+1);
                
                case caseupd = new case ();
                caseupd.id =  invoicecasemap.get(invoice);
                caseupd.esc_invoice_numbers__c = newinvoicenum;
                caseupdlist.add(caseupd);
                
            }
            if(caseupdlist.size() > 0)
            if(Schema.sObjectType.Case.isUpdateable())
            update caseupdlist;
        }
        catch(Exception e){}
    }
}