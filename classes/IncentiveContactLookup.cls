public with sharing class IncentiveContactLookup {
    public List<contact> results{get;set;} 
    public string searchString{get;set;}
    Private id AccountId;
    public IncentiveContactLookup(){
        try{            
            searchString = System.currentPageReference().getParameters().get('lksrch');            
            AccountId = (id)System.currentPageReference().getParameters().get('accountid') ;
            search();
        }
        catch(exception OException){
            Apexpages.addMessages(OException);
        }       
    }
    public void search(){
        try{
            results = new list<contact>();            
            if(searchString == null)
                searchString ='';
            searchString = searchString.replace('*','');                
            results=[SELECT Id, Name, Phone, Email, Sap_role__C FROM Contact 
                            WHERE accountid=:AccountId and name like: searchString+'%' Limit 50];                     
        }
        catch(exception OException){
            Apexpages.addMessages(OException);
        }
    }
     public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}