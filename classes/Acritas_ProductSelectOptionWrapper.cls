public with sharing class Acritas_ProductSelectOptionWrapper {
    public  string oProdSection{get;set;}
    public List<SelectOption> oProdsections{get;set;}
    public List<SelectOption> oProdItemTitles{get;set;}
    public List<SelectOption> oProdRenewals{get;set;}
    public  string oProditem{get;set;}
    public  string oProdRenewal{get;set;}
    public Acritas_ProductSelectOptionWrapper() {
        system.debug('Inside constructor acritas prod wrapper');
    }
}